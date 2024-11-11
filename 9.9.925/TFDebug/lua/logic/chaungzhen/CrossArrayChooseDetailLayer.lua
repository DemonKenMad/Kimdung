-- client side CrossArrayChooseDetailLayer.lua
--[[
 * @Description: 闯阵描述
 ]]
-- script writer Stephen.tao
-- creation time 2016-08-10

local CrossArrayChooseDetailLayer = class("CrossArrayChooseDetailLayer", BaseLayer);


function CrossArrayChooseDetailLayer:ctor(data)
    self.super.ctor(self,data);
    self.type = 0
    self:init("lua.uiconfig_mango_new.crossarray.CrossArrayChooseDetail");
end


function CrossArrayChooseDetailLayer:initUI(ui)
    self.super.initUI(self,ui);

    self.img_tittle         = TFDirector:getChildByPath(ui, 'img_tittle');
    self.btn_close          = TFDirector:getChildByPath(ui, 'btn_close');
    self.txt_zhanli         = TFDirector:getChildByPath(ui, 'txt_zhanli');
    self.panel_reward1      = TFDirector:getChildByPath(ui, 'panel_reward1');
    self.panel_reward2      = TFDirector:getChildByPath(ui, 'panel_reward2');
    self.btn_quick1         = TFDirector:getChildByPath(ui, 'btn_quick1');
    self.txt_freequick      = TFDirector:getChildByPath(ui, 'txt_freequick');
    self.img_qucikneed      = TFDirector:getChildByPath(ui, 'img_qucikneed');
    self.txt_qucikneed      = TFDirector:getChildByPath(ui, 'txt_qucikneed');
    self.txt_qucikneed0     = TFDirector:getChildByPath(ui, 'txt_qucikneed0');
    self.txt_number         = TFDirector:getChildByPath(ui, 'txt_number');
    self.btn_challenge      = TFDirector:getChildByPath(ui, 'btn_challenge');
    self.bg_point           = TFDirector:getChildByPath(ui, 'bg_point');
    self.btn_sweep          = TFDirector:getChildByPath(ui, 'btn_sweep');
    self.bg_point:setVisible(false)
    self.txt_freequick:setVisible(false)
    self.btn_quick1:setVisible(true)
    self.btn_sweep:setVisible(false)
end

function CrossArrayChooseDetailLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function CrossArrayChooseDetailLayer:refreshUI()
    if not self.isShow then
        return;
    end
    
    self.txt_qucikneed0:setVisible(false)
    self.img_qucikneed:setVisible(false)
    
    local tool = BagManager:getItemById(30035)
    if tool and tool.num > 0 then
        self.txt_qucikneed0:setVisible(true)
        self.txt_qucikneed0:setText(stringUtils.format(localizable.carbonDetailLayer_sweep_pro ,tool.num))
    else        
        local freeQuickprice = 1
        self.img_qucikneed:setVisible(true)
        self.txt_qucikneed:setText(stringUtils.format(localizable.carbonDetailLayer_use ,freeQuickprice))
    end

end


function CrossArrayChooseDetailLayer:getRewardByStr( conf )
    --    "a_b_c|a_b_c|a_b_c"
    local rewardList = TFArray:new()
    local temptbl = string.split(conf,'|')           --分解"|"
    for k,v in pairs(temptbl) do
        local temp = string.split(v,'_')                --分解'_',集合为 key，vaule 2个元素
        if temp[1] and temp[2] and temp[2] then
            local reward = {}
            reward.type = tonumber(temp[1])
            reward.itemId = tonumber(temp[2])
            reward.number = tonumber(temp[3])
            rewardList:push(reward)
        end     
    end
    return rewardList
end

function CrossArrayChooseDetailLayer:setType(type)
    self.type = type
    local zoneInfo = ChuangzhenManager:getZoneInfo(self.type)
    self.box_reward = self:getRewardByStr(zoneInfo.box_reward)
    self.pass_reward = self:getRewardByStr(zoneInfo.pass_reward)
    self.img_tittle:setTexture("ui_new/crossarray/img_rukou"..type..".png")
    self.txt_zhanli:setText(zoneInfo.power)
    if self.boxTblView == nil then
        self:createBoxTableView()
    end
    self.boxTblView:reloadData()
    if self.rewardTblView == nil then
        self:createRewardTableView()
    end
    self.rewardTblView:reloadData()
end

function CrossArrayChooseDetailLayer:createBoxTableView()
    local  tableView =  TFTableView:create()
    -- tableView:setName("btnTableView")
    local tableViewSize = self.panel_reward1:getContentSize()
    tableView:setTableViewSize(CCSizeMake(tableViewSize.width, tableViewSize.height))
    tableView:setDirection(TFTableView.TFSCROLLHORIZONTAL)
    tableView:setPosition(self.panel_reward1:getPosition())
    self.boxTblView = tableView
     
    self.boxTblView.logic = self
    self.boxTblView.index = "box"
    -- tableView:addMEListener(TFTABLEVIEW_TOUCHED, CrossArrayChooseDetailLayer.tableCellTouched)
    tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, CrossArrayChooseDetailLayer.cellSizeForTable)
    tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, CrossArrayChooseDetailLayer.tableCellAtIndex)
    tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, CrossArrayChooseDetailLayer.numberOfCellsInTableView)


    self.panel_reward1:getParent():addChild(self.boxTblView,10)
end
function CrossArrayChooseDetailLayer:createRewardTableView()
    local  tableView =  TFTableView:create()
    local tableViewSize = self.panel_reward2:getContentSize()
    tableView:setTableViewSize(CCSizeMake(tableViewSize.width, tableViewSize.height))
    tableView:setDirection(TFTableView.TFSCROLLHORIZONTAL)
    tableView:setPosition(self.panel_reward2:getPosition())
    self.rewardTblView = tableView

    self.rewardTblView.logic = self
    self.rewardTblView.index = "pass"
    -- tableView:addMEListener(TFTABLEVIEW_TOUCHED, CrossArrayChooseDetailLayer.tableCellTouched)
    tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, CrossArrayChooseDetailLayer.cellSizeForTable)
    tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, CrossArrayChooseDetailLayer.tableCellAtIndex)
    tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, CrossArrayChooseDetailLayer.numberOfCellsInTableView)


    self.panel_reward2:getParent():addChild(self.rewardTblView,11)
end

function CrossArrayChooseDetailLayer.cellSizeForTable(table,idx)
    return 100,90
end

function CrossArrayChooseDetailLayer.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local reward = nil
    if table.index == "box" then
        local rewardList = table.logic.box_reward;
        reward = BaseDataManager:getReward(rewardList:getObjectAt(idx+1));
    else
        local rewardList = table.logic.pass_reward;
        reward = BaseDataManager:getReward(rewardList:getObjectAt(idx+1));
    end
    if nil == cell then
        table.cells = table.cells or {}
        cell = TFTableViewCell:create()
        table.cells[cell] = true

        local reward_item = Public:createIconNumNode(reward);
        reward_item:setScale(0.6)
        reward_item:setPosition(ccp(0,0))
        cell.reward_item = reward_item
        cell:addChild(reward_item);
    else
        Public:loadIconNode(cell.reward_item,reward)
    end

    return cell
end

function CrossArrayChooseDetailLayer.numberOfCellsInTableView(table)
    if table.index == "box" then
        return table.logic.box_reward:length()
    else
        return table.logic.pass_reward:length()
    end
    
end

function CrossArrayChooseDetailLayer.onChallengeClickHandle(sender)
    local self = sender.logic;
    if ChuangzhenManager.type ~= 0 and self.type ~= ChuangzhenManager.type then
        CommonManager:showOperateSureLayer(function()
            ChuangzhenManager:GiveUpRush()
            local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.CHUANGZHEN)
            local challengeTime = challengeInfo:getLeftChallengeTimes()
            if challengeTime > 0 then
                ChuangzhenManager:StartRush(self.type)
                AlertManager:close()
                return
            end
        end,
        nil,
        {
            msg = localizable.CrossArray_PleaseCancelType
        })
        return
    end
    --------------------------------------------------------
    local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.CHUANGZHEN)
    local challengeTime = challengeInfo:getLeftChallengeTimes()
    if challengeTime <= 0 then
        toastMessage(localizable.common_fight_times)
        return
    end
    ChuangzhenManager:StartRush(self.type)
    AlertManager:close()
end

function CrossArrayChooseDetailLayer.onQuickClickHandle(sender)
    local self = sender.logic;
    if ChuangzhenManager.maxType < self.type then
        toastMessage(localizable.CrossArrayChooseDetail_Quick1)
        return
    end
    local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.CHUANGZHEN)
    local challengeTime = challengeInfo:getLeftChallengeTimes()
    if challengeTime <= 0 then
        toastMessage(localizable.common_fight_times)
        return
    end
    ChuangzhenManager:RushSweeping(self.type)
    -- local index = sender.index
    -- local zoneInfo = ChuangzhenManager:getZoneInfo(index)

end

function CrossArrayChooseDetailLayer:removeUI()
    self.super.removeUI(self);

end

function CrossArrayChooseDetailLayer:registerEvents()
    self.super.registerEvents(self);
    
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);

    self.btn_quick1.logic = self
    self.btn_challenge.logic = self
    self.btn_quick1:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onQuickClickHandle),1);
    self.btn_challenge:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onChallengeClickHandle),1);
end

function CrossArrayChooseDetailLayer:removeEvents()
    self.super.removeEvents(self);
end

return CrossArrayChooseDetailLayer;
