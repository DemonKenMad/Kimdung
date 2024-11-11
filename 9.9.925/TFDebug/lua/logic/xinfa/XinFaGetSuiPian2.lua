--[[
 * @Description: 心法碎片界面2
 ]]
-- script writer fei
-- creation time 2017-03-02
local XinFaPieceMergeLayer = class("XinFaPieceMergeLayer", BaseLayer)

function XinFaPieceMergeLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.xinfa.GetSuiPian2")
end

function XinFaPieceMergeLayer:initUI( ui )
    self.super.initUI(self, ui)
    self.pannel_getway      = TFDirector:getChildByPath(ui, 'pannel_getway')
    self.txt_bookname       = TFDirector:getChildByPath(ui, 'txt_bookname')
    local panel_way_book    = TFDirector:getChildByPath(ui, 'panel_way_book')
    self.img_quality        = TFDirector:getChildByPath(panel_way_book, 'img_quality')
    self.img_equip          = TFDirector:getChildByPath(panel_way_book, 'img_equip')
    self.btn_fanhui         =  TFDirector:getChildByPath(ui, "btn_fanhui")
end

function XinFaPieceMergeLayer:loadData(id,canRob)
    self.PieceInfo = ItemData:objectByID(id)
    self.itemId = id
    self.canRob = canRob
    self:refreshUI()
    self:drawOutWayList()
end

function XinFaPieceMergeLayer.cellSizeForTable_out(table, idx)
    return 70, 348
end

function XinFaPieceMergeLayer.tableCellAtIndex_out(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    local node = nil
    if nil == cell then
        table.cells = table.cells or {}
        cell = TFTableViewCell:create()
        table.cells[cell] = true

        -- node = createUIByLuaNew("lua.uiconfig_mango_new.handbook.HandbookOutPutCell")
        node = self.panel_outnode:clone()
        node:setName("HandbookOutPutCell")
        node:setPosition(ccp(180, 30))
        cell:addChild(node)
        node:setTag(617)
    end

    node = cell:getChildByTag(617)
    if self.canRob == false then
        idx = idx + 1
    end
    local output = string.split(self.outputList[idx + 1], "_")
    node.type    = tonumber(output[1])
    node.mission = tonumber(output[2])
    node.logic   = self  
    node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.touchMission),1)
    self:drawOutNode(node)

    node:setVisible(true)
    return cell
end

function XinFaPieceMergeLayer:drawOutNode(node) 
    local txt_leveldesc  = TFDirector:getChildByPath(node, "txt_leveldesc")
    local txt_levelopen  = TFDirector:getChildByPath(node, "txt_levelopen")

    local type = node.type

    print("type = ",type)
    local desc = EnumItemOutPutType[type]
    txt_leveldesc:setText(desc)
    txt_levelopen:setVisible(false)
    return
end

function XinFaPieceMergeLayer.numberOfCellsInTableView_out(table)
    local self = table.logic

    return self.outputNum
end

function XinFaPieceMergeLayer:drawOutWayList()
    self.output   = self.PieceInfo.show_way

    if self.output ~= "" then
        self.outputList  = string.split(self.output, "|")
        self.outputNum   = #self.outputList

        if self.canRob == false then
            self.outputNum = self.outputNum - 1
        end
    end
    self:drawOutPutList()
end

function XinFaPieceMergeLayer:drawOutPutList()
    local pannel_outList =  TFDirector:getChildByPath(self.pannel_getway, "pannel_getwaylist")
    if pannel_outList == nil then
        return
    end


    self.panel_outnode   =  TFDirector:getChildByPath(self.pannel_getway, "bg_cell")
    self.panel_outnode:setVisible(false)    


    if self.outputTableView ~= nil then
        self.outputTableView:setVisible(true)
        self.outputTableView:reloadData()

        if self.outputNum > 3 then
            self.outputTableView:setInertiaScrollEnabled(true)
        else
            self.outputTableView:setInertiaScrollEnabled(false)
        end
        self.outputTableView:setScrollToBegin(false)
        return
    end

    local  tableView =  TFTableView:create()
    tableView:setTableViewSize(pannel_outList:getContentSize())
    tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
    tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    tableView:setPosition(ccp(0,0))
    self.outputTableView = tableView
    self.outputTableView.logic = self

    tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, XinFaPieceMergeLayer.cellSizeForTable_out)
    tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, XinFaPieceMergeLayer.tableCellAtIndex_out)
    tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, XinFaPieceMergeLayer.numberOfCellsInTableView_out)
    tableView:reloadData()

    if self.outputNum > 3 then
        self.outputTableView:setInertiaScrollEnabled(true)
    else
        self.outputTableView:setInertiaScrollEnabled(false)
    end

    pannel_outList:addChild(tableView,1)

end

function XinFaPieceMergeLayer:removeUI()
  self.super.removeUI(self)
end

function XinFaPieceMergeLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function XinFaPieceMergeLayer:refreshUI()
    if self.PieceInfo == nil then
        return
    end

    self.txt_bookname:setText(self.PieceInfo.name)
    self.img_quality:setTextureNormal(getBookBackgroud(self.PieceInfo.quality))
    self.img_equip:setTexture("icon/item/"..self.PieceInfo.display..".png")
    local rewardItem = {itemid = self.itemId}
    Public:addPieceImg(self.img_equip,rewardItem,nil,1.0)
end

function XinFaPieceMergeLayer:registerEvents()
    self.super.registerEvents(self)

    self.img_quality.logic = self
    self.img_quality:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowItemClickHandle),1)
    self.btn_fanhui.logic = self
    self.btn_fanhui:addMEListener(TFWIDGET_CLICK, audioClickfun(self.BtnClickBackHandle))
  
end

function XinFaPieceMergeLayer.BtnClickBackHandle(sender)
    local self    = sender.logic
    AlertManager:close()
end

function XinFaPieceMergeLayer.onShowItemClickHandle(sender)
    local self = sender.logic;
    Public:ShowItemTipLayer(self.itemId, 1)
end

function XinFaPieceMergeLayer.touchMission(sender)
    local self    = sender.logic
    local type    = sender.type
    local mission = sender.mission

    IllustrationManager:gotoProductSystem(type, mission)
    
end

function XinFaPieceMergeLayer:removeEvents()
    self.super.removeEvents(self)
end

return XinFaPieceMergeLayer