-- client side jiangliyulanLayer
--[[
 * @Description: 奖励预览
 ]]
-- script writer zengweizhong
-- creation time 2017-02-27

local jiangliyulanLayer = class("jiangliyulanLayer", BaseLayer)

function jiangliyulanLayer:ctor()
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.nianshou.DaNianShouCheck")
end

function jiangliyulanLayer:initUI(ui)
	self.super.initUI(self,ui)
    
    self.panel_neirong = TFDirector:getChildByPath(ui, 'panel_neirong')

    self.panel_item = TFDirector:getChildByPath(ui, 'panel_item')
    self.panel_item:removeFromParent()
    self.panel_item:retain()

    local drop_id = ConstantData:getValue('MonsterNian.DropGroup.Fireworks')
    print("drop_id",drop_id)
    local dropItem = DropGroupData:objectByID(drop_id)
    local rewardList = dropItem:GetDropItemList()
    self.rewardList = rewardList.m_list

    local bg_icon = TFDirector:getChildByPath(self.panel_item, 'bg_icon')
    self.Itemsize = bg_icon:getContentSize()
    print("self.rewardList",self.rewardList)

    self:refreshUI()
    self:setIcon()
    
end

function jiangliyulanLayer:setRewardList( list )
    self.rewardList = list
    self:refreshUI()
    self:setIcon()
end

function jiangliyulanLayer:setIcon()
    -- local Itemsize = self.panel_item:getContentSize()
    local Panelsize = self.panel_neirong:getContentSize()
    local num = math.floor(Panelsize.width/(self.Itemsize.width - 20))
    print("num",num)
    -- local x=0
    for i=0,#self.rewardList -1 do
        local node = self.panel_item:clone()
        node:setVisible(true)
        -- if math.floor(i/num) > x then
        --     x = math.floor(i/num)
        -- end
		node:setPosition(ccp((i%num)*(self.Itemsize.width - 20) + 25,Panelsize.height- 110 - (math.floor(i/num))*(self.Itemsize.height)))
		self.panel_neirong:addChild(node,1)
        self:setCellInfo(node,i+1)
    end
end

function jiangliyulanLayer:refreshUI()    
    self:refreshTableView()
end

function jiangliyulanLayer:refreshTableView()
    if self.tableView == nil then
        local  tableView =  TFTableView:create()

        self.tableView = tableView
        tableView:setTableViewSize(self.panel_neirong:getContentSize())
        tableView:setDirection(TFTableView.TFSCROLLHORIZONTAL)
        tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)

        self.tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, handler(self.cellSizeForTable,self))
        self.tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, handler(self.tableCellAtIndex,self))
        self.tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, handler(self.numberOfCellsInTableView,self))
        --self.tableView:addMEListener(TFTABLEVIEW_SCROLL, handler(self.tableScroll,self))
        self.panel_neirong:addChild(tableView)
    end
    self.tableView:reloadData()
end

function jiangliyulanLayer:cellSizeForTable(table,idx)
    return 140,140
end

function jiangliyulanLayer:tableCellAtIndex(table, idx)
	idx = idx + 1
	local cell = table:dequeueCell()
	if nil == cell then
		cell = TFTableViewCell:create()
		local node = self.panel_item:clone()
        node:setZOrder(100)
		node:setVisible(true)
		node:setPosition(ccp(0,0))
		cell:addChild(node,1)
		cell.panel = node	
	end
	self:setCellInfo(cell,idx)
	
	return cell
end

function jiangliyulanLayer:numberOfCellsInTableView(table)
    -- if self.rewardList then
    --     return #self.rewardList
    -- end
    return 0
end

function jiangliyulanLayer:setCellInfo(cell,idx)
	-- local panel = cell.panel
    local panel = cell
	local bg_icon = TFDirector:getChildByPath(panel, "bg_icon")
    local img_icon = TFDirector:getChildByPath(panel, "img_icon")
    local txt_num = TFDirector:getChildByPath(panel, "txt_num")
    local img_jp = TFDirector:getChildByPath(panel, "img_jp")

    bg_icon:setTextureNormal(GetColorIconByQuality(self.rewardList[idx].quality))
    img_icon:setTexture(self.rewardList[idx].path)
    txt_num:setText(self.rewardList[idx].number)
    img_jp:setVisible(false)

    bg_icon:addMEListener(TFWIDGET_CLICK, 
    audioClickfun(function()
        Public:ShowItemTipLayer(self.rewardList[idx].itemid, self.rewardList[idx].type, self.rewardList[idx].number)
    end))
    
end

function jiangliyulanLayer.returnButtonClick()
    print("11111111")
end

function jiangliyulanLayer:registerEvents()
    self.super.registerEvents(self)
end

function jiangliyulanLayer:removeEvents()
    self.super.removeEvents(self)	

end

return jiangliyulanLayer