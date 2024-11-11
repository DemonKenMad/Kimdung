-- client side CrossZhengBaMissionLayer.lua
--[[
 * @Description: 成就
 ]]
-- script writer chikui
-- creation time 2017-03-02



local CrossZhengBaMissionLayer = class("CrossZhengBaMissionLayer", BaseLayer)
function CrossZhengBaMissionLayer:ctor(equipid)
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.crosszhenba.CrossZhenBaCJ")
end

function CrossZhengBaMissionLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.btn_close          = TFDirector:getChildByPath(ui, 'btn_close')
    self.panel_list         = TFDirector:getChildByPath(ui, 'Panel_Reward')
    self.img_di1            = TFDirector:getChildByPath(ui, 'img_guodu')

    self.panel_cell_model = TFDirector:getChildByPath(ui, 'bg_1' )
    self.panel_cell_model:removeFromParent()
    self.panel_cell_model:retain()

    self.panel_item_model = TFDirector:getChildByPath(self.panel_cell_model, 'img_quality_bg' )
    self.panel_item_model:removeFromParent()
    -- self.panel_item_model:retain()

    self:refreshUI()
end

function CrossZhengBaMissionLayer:registerEvents(ui)
    self.super.registerEvents(self)
    
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)

    self.receiveMainInfo = function(event)
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(CrossZhengBaManager.RECEIVE_MAIN_INFO,self.receiveMainInfo)
end

function CrossZhengBaMissionLayer:removeEvents()
    TFDirector:removeMEGlobalListener(CrossZhengBaManager.RECEIVE_MAIN_INFO,self.receiveMainInfo)
    self.super.removeEvents(self)
end

function CrossZhengBaMissionLayer:dispose()
    self.super.dispose(self)
end

function CrossZhengBaMissionLayer:removeUI()
    if self.panel_cell_model then
        self.panel_cell_model:release()
        self.panel_cell_model = nil
    end
end

function CrossZhengBaMissionLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function CrossZhengBaMissionLayer:refreshUI()
    self:refreshTableView()
end

function CrossZhengBaMissionLayer:refreshTableView()
    if self.tableView == nil then
        local  tableView =  TFTableView:create()

        self.tableView = tableView
        tableView:setTableViewSize(self.panel_list:getContentSize())
        tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
        tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)

        self.tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, handler(self.cellSizeForTable,self))
        self.tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, handler(self.tableCellAtIndex,self))
        self.tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, handler(self.numberOfCellsInTableView,self))
        self.tableView:addMEListener(TFTABLEVIEW_SCROLL, handler(self.tableScroll,self))
        self.panel_list:addChild(tableView)
    end
    self.tableView:reloadData()
end

function CrossZhengBaMissionLayer:tableScroll(table)
    local size = self.tableView:getTableViewSize()
    local size2 = self.tableView:getContentSize()
    local pos = self.tableView:getContentOffset()
    -- if pos.y == size.height - size2.height then
    --     self.img_di2:setVisible(false)
    -- else
    --     self.img_di2:setVisible(true)
    -- end
    if pos.y >= 0 then
        self.img_di1:setVisible(false)
    else
        self.img_di1:setVisible(true)
    end
end

function CrossZhengBaMissionLayer:cellSizeForTable(table,idx)
    return 110,600
end

function CrossZhengBaMissionLayer:tableCellAtIndex(table, idx)
    idx = idx + 1
    local cell = table:dequeueCell()
    if nil == cell then
        cell = TFTableViewCell:create()
        local node = self.panel_cell_model:clone()
        node:setVisible(true)
        node:setPositionY(55)
        cell:addChild(node,1)
        cell.panel = node
    end
    self:setCellInfo(cell,idx)
    return cell
end

function CrossZhengBaMissionLayer:numberOfCellsInTableView(table)
    local num = CrossZhengBaManager:getMissionSize()
    if num < 0 then num = 0 end
    return num
end

function CrossZhengBaMissionLayer:setCellInfo(cell,idx)
    local info = CrossZhengBaManager:getMissionByCase(idx)
    local panel = cell.panel
    local missionId = info.currMission
    if info == nil or missionId == nil then
        panel:setVisible(false)
        return
    end
    panel:setVisible(true)
    local itemData = CrossZhengBaManager:getMissionData(missionId)


    local panel_Icon = TFDirector:getChildByPath(panel, 'panel_Icon')
    panel_Icon:setVisible(true)
    panel_Icon:removeAllChildren()
    local txt1 = TFDirector:getChildByPath(panel, 'txt1')
    txt1:setText(itemData.desc)
    local size = panel_Icon:getSize()
    local rewardList = RewardConfigureData:GetRewardItemListById(itemData.award)
    local index = 0
    for item in rewardList:iterator() do
        index = index + 1
        local itemNode = Public:createIconNumNode(item)
        itemNode:setPosition(ccp(8 + ( index - 1 ) * 100,-3))
        panel_Icon:addChild(itemNode,1)
    end
    
    local load_di = TFDirector:getChildByPath(panel, 'load_di')
    load_di:setPercent(100 * info.currNum / info.maxNum)
    local txt_num = TFDirector:getChildByPath(panel, 'txt_num')
    txt_num:setText(info.currNum .. "/" .. info.maxNum)
    local btn_get = TFDirector:getChildByPath(panel, 'btn_get')
    if info.state == CrossZhengBaManager.MissionState_1 then
        btn_get:setVisible(true)
    else
        btn_get:setVisible(false)
    end
    local onGetClick = function( sender )
        CrossZhengBaManager:requestGetMissionReward(missionId)
    end
    btn_get:addMEListener(TFWIDGET_CLICK, audioClickfun(onGetClick))
end

return CrossZhengBaMissionLayer