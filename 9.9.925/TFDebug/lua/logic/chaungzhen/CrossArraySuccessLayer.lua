-- client side CrossArraySuccessLayer.lua
--[[
 * @Description: 闯阵奖励界面
 ]]
-- script writer chikui
-- creation time 2016-08-15

local CrossArraySuccessLayer = class("CrossArraySuccessLayer", BaseLayer);

local ShowMaxNum = 8

function CrossArraySuccessLayer:ctor(data)
    self.super.ctor(self,data);
    self:init("lua.uiconfig_mango_new.common.RewardListMessage");
end

function CrossArraySuccessLayer:initUI(ui)
    self.super.initUI(self,ui);

    self.btn_ok             = TFDirector:getChildByPath(ui, 'btn_ok');
    self.bg              = TFDirector:getChildByPath(ui, 'bg');
    self.bg:setTexture("ui_new/common/img_reward_bg2.png")
    self.txt_cishu              = TFDirector:getChildByPath(ui, 'txt_cishu');

    self:addEffect("get_reward")
    self.node_reward    = TFDirector:getChildByPath(ui, 'node_reward');
    self.node_reward_positionX = self.node_reward:getPosition().x
    self.bg_width = self.bg:getSize().width

    self.txt_cishu:setVisible(false)
end

function CrossArraySuccessLayer:addEffect(effectName)
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/"..effectName..".xml")
    local effect = TFArmature:create(effectName.."_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        effect:setPosition(ccp(568, 136))
        effect:setZOrder(11)
        self.bg:addChild(effect)
    end
end

function CrossArraySuccessLayer:loadData(rewardList,islast)
    self.rewardList = rewardList;
    self.islast = islast
    self:refreshUI();
end

function CrossArraySuccessLayer:onShow()
    self.super.onShow(self)
end

function CrossArraySuccessLayer:refreshUI()

    local rewardList = self.rewardList;

    local cell_width = 115;
    local length = math.min(ShowMaxNum , #rewardList) 
    local width = cell_width * length
    if #rewardList > ShowMaxNum then
        width = 1136
    end
    if self.tableView == nil then
        local  tableView =  TFTableView:create()
        tableView:setName("btnTableView")
        self.tableView = tableView
        self.tableView.logic = self
        tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, CrossArraySuccessLayer.cellSizeForTable)
        tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, CrossArraySuccessLayer.tableCellAtIndex)
        tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, CrossArraySuccessLayer.numberOfCellsInTableView)
        self.bg:addChild(self.tableView,1)
    end
    self.tableView:setTableViewSize(ccs(width,self.node_reward:getSize().height))
    self.tableView:setDirection(TFTableView.TFSCROLLHORIZONTAL)
    if #rewardList > ShowMaxNum then
        self.tableView:setInertiaScrollEnabled(true)
    else
        self.tableView:setInertiaScrollEnabled(false)
    end
    self.tableView:setPosition(ccp(self.node_reward_positionX + (cell_width - width)/2  ,self.node_reward:getPosition().y))
    self.tableView:reloadData();
end


function CrossArraySuccessLayer.cellSizeForTable(table,idx)
    return 150,115
end

function CrossArraySuccessLayer.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local self = table.logic
    local rewardList = table.logic.rewardList
    local num = #rewardList
    local rewardInfo = nil
    if num > ShowMaxNum then
        if idx > 0 then
            rewardInfo = rewardList[idx]
        end
    else
        rewardInfo = rewardList[idx + 1]
    end
    local reward = BaseDataManager:getReward(rewardInfo)
    if nil == cell then
        table.cells = table.cells or {}
        cell = TFTableViewCell:create()
        table.cells[cell] = true
        local reward_item = Public:createRewardNode(reward);
        reward_item:setPosition(ccp(0,-5))
        reward_item:setScale(0.85)
        local click_widget = TFDirector:getChildByPath(reward_item,"btn_icon")
        local txt_name = TFDirector:getChildByPath(reward_item,"txt_name")
        local txt_namew = TFDirector:getChildByPath(reward_item,"txt_namew")
        if txt_namew then
            txt_name:setVisible(false)
            txt_namew:setVisible(true)
        end
        if click_widget then
            click_widget:setVisible(false)
        end
        cell.reward_item = reward_item
        cell:addChild(reward_item);
    else
        Public:loadIconNode(cell.reward_item,reward)
        local txt_name = TFDirector:getChildByPath(cell.reward_item,"txt_name")
        local txt_namew = TFDirector:getChildByPath(cell.reward_item,"txt_namew")
        if txt_namew then
            txt_name:setVisible(false)
            txt_namew:setVisible(true)
        end
    end
    return cell
end

function CrossArraySuccessLayer.numberOfCellsInTableView(table)
    local num = #(table.logic.rewardList)
    if num > ShowMaxNum then
        num = num+1
    end
    return num
end

function CrossArraySuccessLayer:removeUI()
    self.super.removeUI(self);
end

--注册事件
function CrossArraySuccessLayer:registerEvents()
    self.super.registerEvents(self);

    ADD_ALERT_CLOSE_LISTENER(self,self.btn_ok);
end

function CrossArraySuccessLayer:removeEvents()
    if self.islast == true or self.islast == 1 then
        AlertManager:close()
    end
    self.super.removeEvents(self)
    self.btn_ok:removeMEListener(TFWIDGET_CLICK)
end
return CrossArraySuccessLayer;