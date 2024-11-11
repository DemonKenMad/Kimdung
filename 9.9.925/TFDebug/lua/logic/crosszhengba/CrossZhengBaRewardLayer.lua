-- client side CrossZhengBaRewardLayer.lua
--[[
 * @Description: 天梯奖励
 ]]
-- script writer chikui
-- creation time 2017-03-03

local CrossZhengBaRewardLayer = class("CrossZhengBaRewardLayer", BaseLayer)

function CrossZhengBaRewardLayer:ctor(data)
    self.super.ctor(self, data)
    self:init("lua.uiconfig_mango_new.crosszhenba.CrossZhenBaReward")
end

function CrossZhengBaRewardLayer:initUI( ui )
    self.super.initUI(self, ui)

    self.btn_close = TFDirector:getChildByPath(ui, 'btn_close')

    self.panel_list = TFDirector:getChildByPath(ui, "panel_list")
    self.panelSize = self.panel_list:getSize()
    self.panel_cell = TFDirector:getChildByPath(self.panel_list, "bg_1")
    self.panel_cell:setAnchorPoint(ccp(0, 0))
    self.panel_cell:setVisible(false)
    self.panel_cell:retain()
    self.panel_cell:removeFromParent()

    self.pathBig = {[3] = "ui_new/common/qhp_tb_icon.png",[21] = "ui_new/wulin/icon_ryl2.png",[22] = "ui_new/wulin/icon_ryl.png"}
    self.pathSmall = {[3] = "ui_new/common/icon_coin.png",[21] = "ui_new/wulin/icon_ryl4.png",[22] = "ui_new/wulin/icon_ryl3.png"}
end

function CrossZhengBaRewardLayer:refreshData()
    self.data = ChampionsAwardData:getAllRewardDataByType(18) or {}
end

function CrossZhengBaRewardLayer:refreshTabView()
    if self.tabView then
        self.tabView:reloadData()
        return
    end
    local tabView = TFTableView:create()
    tabView:setTableViewSize(CCSize(self.panelSize.width, self.panelSize.height))
    tabView:setDirection(TFTableView.TFSCROLLHORIZONTAL)
    tabView.logic = self
    self.panel_list:addChild(tabView)
    tabView:setPosition(ccp(0, 0))
    self.tabView = tabView

    self.tabView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
    self.tabView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
    self.tabView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
    self.tabView:reloadData()
end

function CrossZhengBaRewardLayer.cellSizeForTable(table, idx)
    local self = table.logic
    local index = idx + 1
    if index == #self.data or index == 1 then
        return 400,164
    end
    return 400, 140
end

function CrossZhengBaRewardLayer.numberOfCellsInTableView(table)
    local self = table.logic    
    local num = #self.data
    return num
end

function CrossZhengBaRewardLayer.tableCellAtIndex(table, idx)
    local self = table.logic

    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.panel_cell:clone()
        panel:setPosition(ccp(0,18))
        panel:setVisible(true)
        panel:setTag(100)
        cell.panel = panel
        cell:addChild(panel)
    end
    idx = idx + 1
    self:refreshCell(cell.panel, idx)
    return cell
end

function CrossZhengBaRewardLayer:refreshCell(panel, index)
    local rewardInfo = self.data[index]
    if rewardInfo == nil then
        panel:setVisible(false)
        return
    end
    local posX = 0
    if index == 1 then
        posX = 24
    end
    panel:setPositionX(posX)
    local rankPath = "ui_new/crosszhenba/" .. "img_rank_" .. index .. ".png"
        
    local img_rank = TFDirector:getChildByPath(panel, 'img_diyi')
    img_rank:setTexture(rankPath)
    local rewardll = {}
    local rewardStr = stringToTable(rewardInfo.award,"|")
    for i,v in ipairs(rewardStr) do
        local tbl = stringToNumberTable(v,"_")
        if tbl[3] > 0 then
            table.insert(rewardll,{type = tbl[1],itemId = tbl[2],number = tbl[3]})
        end
    end
    local txt1 = TFDirector:getChildByPath(panel, 'txt1')
    local img_reward1 = TFDirector:getChildByPath(panel, 'img_yb1')
    if rewardll[1] then
        txt1:setText("x" .. rewardll[1].number)
        local path = self.pathBig[rewardll[1].type]
        if path == nil then
            local rewardtt = BaseDataManager:getReward(rewardll[1])
            path = rewardtt.path
        end
        img_reward1:setVisible(true)
        img_reward1:setTexture(path)
    else
        txt1:setText("")
        img_reward1:setVisible(false)
    end


    local txt2 = TFDirector:getChildByPath(panel, 'txt2')
    local img_reward2 = TFDirector:getChildByPath(panel, 'img_tongbi')

    if rewardll[2] then
        txt2:setText("x" .. rewardll[2].number)
        local path = self.pathSmall[rewardll[2].type]
        if path == nil then
            local rewardtt = BaseDataManager:getReward(rewardll[2])
            path = rewardtt.path
        end
        img_reward2:setVisible(true)
        img_reward2:setTexture(path)
    else
        txt2:setText("")
        img_reward2:setVisible(false)
    end
end

function CrossZhengBaRewardLayer:refreshUI()
    self:refreshData()
    self:refreshTabView()
end

function CrossZhengBaRewardLayer:removeUI()
    self.super.removeUI(self)

    if self.panel_cell then
        self.panel_cell:release()
        self.panel_cell = nil
    end
end

function CrossZhengBaRewardLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function CrossZhengBaRewardLayer:registerEvents()
    self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)
end

function CrossZhengBaRewardLayer:removeEvents()
    self.super.removeEvents(self)
end

return CrossZhengBaRewardLayer