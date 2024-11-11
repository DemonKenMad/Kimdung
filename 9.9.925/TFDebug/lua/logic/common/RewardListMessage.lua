--[[
******奖励结果列表*******

    -- by haidong.gan
    -- 2013/11/27
]]
local RewardListMessage = class("RewardListMessage", BaseLayer);

CREATE_SCENE_FUN(RewardListMessage);
CREATE_PANEL_FUN(RewardListMessage);

local ShowMaxNum = 8

function RewardListMessage:ctor(data)
    self.super.ctor(self,data);
    self:init("lua.uiconfig_mango_new.common.RewardListMessage");
end

function RewardListMessage:initUI(ui)
    self.super.initUI(self,ui);

    self.btn_ok             = TFDirector:getChildByPath(ui, 'btn_ok');
    self.bg              = TFDirector:getChildByPath(ui, 'bg');
    self.txt_cishu              = TFDirector:getChildByPath(ui, 'txt_cishu');

    self:addEffect("get_reward")
    self.node_reward    = TFDirector:getChildByPath(ui, 'node_reward');
    self.node_reward_positionX = self.node_reward:getPosition().x
    self.bg_width = self.bg:getSize().width

    self.txt_cishu:setVisible(false)
end

function RewardListMessage:addEffect(effectName)
    if (self.effect) then
        return 
    end
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/"..effectName..".xml")
    local effect = TFArmature:create(effectName.."_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        effect:setPosition(ccp(568, 136))
        effect:setZOrder(11)
        self.bg:addChild(effect)
        self.effect = effect
    end
end

function RewardListMessage:loadData(rewardList,isShowTxt)
    if isShowTxt == nil then
        isShowTxt = false
    end
    self.rewardList = rewardList;
    self:refreshUI();
    self:showGetHero()
    self.txt_cishu:setVisible(isShowTxt)
end

function RewardListMessage:setTextSHow( txt )
    self.txt_cishu:setVisible(true)
    self.txt_cishu:setText(txt)
end

function RewardListMessage:showGetHero()
    local hero_list = TFArray:new()
    for v in self.rewardList:iterator() do
        if v.type == EnumDropType.ROLE then
            hero_list:push(v.itemid)
        end
    end

    function showGetHeroResultLayer()
        if hero_list:length() > 0 then
            local layer = require("lua.logic.shop.GetHeroResultLayer"):new(hero_list:pop())
            layer:setReturnFun(function ()
                    AlertManager:close()
                    showGetHeroResultLayer()
                end)
            AlertManager:addLayer(layer, AlertManager.BLOCK)
            AlertManager:show()
        end
    end
    showGetHeroResultLayer()
end

function RewardListMessage:onShow()
    self.super.onShow(self)
    self:refreshBaseUI();
end

function RewardListMessage:refreshBaseUI()

end

function RewardListMessage:refreshUI()
    -- if not self.isShow then
    --     return;
    -- end
    print("RewardListMessage:refreshUI-------------111")
    -- self.node_reward:removeAllChildren();

    local rewardList = self.rewardList;

    local cell_width = 115;
    --cell_width = cell_width * math.min(1,6/rewardList:length()) 
    local length = math.min(ShowMaxNum , rewardList:length()) 
    -- local width = math.max(math.min(cell_width * length + 80,900),396);

    -- for reward in rewardList:iterator() do
    --     local index = rewardList:indexOf(reward);

    --     local reward_item = Public:createRewardNode(reward);

    --     reward_item:setScale(math.min(1,6/length));
    --     reward_item:setPosition(ccp((index - 1) * cell_width, -10));
    --     self.node_reward:addChild(reward_item);
    -- end
    -- local rewardwidthoffset = width - ( cell_width * length + 80);
    local width = cell_width * length
    if rewardList:length() > ShowMaxNum then
        width = 1136
    elseif length <= 1 then
        width = cell_width + 30
    end
    -- self.node_reward:setPosition(ccp(200  ,400));
    -- self.bg:setSize(ccs( width ,self.bg:getSize().height))
    if self.tableView == nil then
        local  tableView =  TFTableView:create()
        -- tableView:setTableViewSize(ccs(cell_width*length ,self.node_reward:getSize().height))
        tableView:setName("btnTableView")
        -- tableView:setDirection(TFTableView.TFSCROLLHORIZONTAL)
        self.tableView = tableView
        self.tableView.logic = self
        -- tableView:addMEListener(TFTABLEVIEW_TOUCHED, RewardListMessage.tableCellTouched)
        tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, RewardListMessage.cellSizeForTable)
        tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, RewardListMessage.tableCellAtIndex)
        tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, RewardListMessage.numberOfCellsInTableView)
        self.bg:addChild(self.tableView,1)
        -- tableView:setClippingEnabled(false)
    end
    self.tableView:setTableViewSize(ccs(width,self.node_reward:getSize().height))
    self.tableView:setDirection(TFTableView.TFSCROLLHORIZONTAL)
    if rewardList:length() > ShowMaxNum then
        self.tableView:setInertiaScrollEnabled(true)
    else
        self.tableView:setInertiaScrollEnabled(false)
    end
    self.tableView:setPosition(ccp(self.node_reward_positionX + (cell_width - width)/2  ,self.node_reward:getPosition().y))
    self.tableView:reloadData();
    print("RewardListMessage:refreshUI-------------222")
end


function RewardListMessage.cellSizeForTable(table,idx)
    return 150,115
end

function RewardListMessage.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local self = table.logic
    local rewardList = table.logic.rewardList;
    local num = table.logic.rewardList:length()
    local reward = nil
    if num > ShowMaxNum then
        if idx > 0 then
            reward = rewardList:getObjectAt(idx);
        end
    else
        reward = rewardList:getObjectAt(idx+1);
    end
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
        -- if txt_name then
        --     txt_name:setColor(ccc3(255,255,255))
        -- end
        cell.reward_item = reward_item
        cell:addChild(reward_item);
        if reward and reward.multiple ~= nil and reward.multiple > 0 then
            self:addTag(cell.reward_item,reward.multiple)
        end
    else
        Public:loadIconNode(cell.reward_item,reward)
        -- cell.reward_item:setPosition(ccp(0,-5))
        -- cell.reward_item:setScale(0.85)
        -- local click_widget = TFDirector:getChildByPath(cell.reward_item,"btn_icon")
        if reward and reward.multiple ~= nil and reward.multiple > 0 then
            self:addTag(cell.reward_item,reward.multiple)
        end
        local txt_name = TFDirector:getChildByPath(cell.reward_item,"txt_name")
        local txt_namew = TFDirector:getChildByPath(cell.reward_item,"txt_namew")
        if txt_namew then
            txt_name:setVisible(false)
            txt_namew:setVisible(true)
        end
        -- if click_widget then
        --     click_widget:setVisible(false)
        -- end
    end
    return cell
end

function RewardListMessage:addTag(node,num)
    local img_tag = node:getChildByTag(1023)
    local txt_mulriple = node:getChildByTag(1024)

    if img_tag == nil then
        img_tag = TFImage:create()
        node:addChild(img_tag,10,1023)
        img_tag:setTexture('ui_new/treasure/img_jiaobiao.png')

        img_tag:setPosition(ccp(46, 141))
    end
    
    if txt_mulriple == nil then
        txt_mulriple = TFLabelBMFont:create()
        txt_mulriple:setFntFile("font/num_227.fnt")
        node:addChild(txt_mulriple,10,1024)
        
        txt_mulriple:setAnchorPoint(ccp(1, 0.5))
        txt_mulriple:setRotation(-40)
        txt_mulriple:setPosition(ccp(50, 154))
    end
    txt_mulriple:setText(num)
    if num > 9 then
        txt_mulriple:setScale(0.7)
    else
        txt_mulriple:setScale(1.0)
    end
end

function RewardListMessage.numberOfCellsInTableView(table)
    local num = table.logic.rewardList:length()
    if num > ShowMaxNum then
        num = num+1
    end
    return num
end

function RewardListMessage:removeUI()
   self.super.removeUI(self);
end

--注册事件
function RewardListMessage:registerEvents()
    self.super.registerEvents(self);

    ADD_ALERT_CLOSE_LISTENER(self,self.btn_ok);
end

function RewardListMessage:removeEvents()
    self.super.removeEvents(self)
    self.btn_ok:removeMEListener(TFWIDGET_CLICK)
    if self.ntimer then
        TFDirector:removeTimer(self.ntimer)
        self.ntimer = nil
    end
end
return RewardListMessage;
