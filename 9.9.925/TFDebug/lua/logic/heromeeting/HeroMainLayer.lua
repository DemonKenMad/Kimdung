--[[
******英雄大会-欢迎界面*******

    -- by jiawei.miao
    -- 2018/1/5
]]
local HeroMainLayer = class("HeroMainLayer", BaseLayer);

CREATE_SCENE_FUN(HeroMainLayer);
CREATE_PANEL_FUN(HeroMainLayer);

function HeroMainLayer:ctor(data)
    self.super.ctor(self,data);
    self:init("lua.uiconfig_mango_new.hero.HeroMain");
end

function HeroMainLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
    if self.generalHead then
        self.generalHead:onShow()
    end
end

function HeroMainLayer:refreshUI()

end

function HeroMainLayer:initUI(ui)

    self.super.initUI(self,ui);

    self.generalHead = CommonManager:addGeneralHead( self)

    self.generalHead:setData(ModuleType.Hero,{HeadResType.HERO,HeadResType.WEIWANG,HeadResType.SYCEE})

    self.btn_help       = TFDirector:getChildByPath(ui, "btn_help")
    self.btn_mrzk       = TFDirector:getChildByPath(ui, 'btn_mrzk')
    self.btn_jiangli    = TFDirector:getChildByPath(ui, 'btn_jiangli')
    self.btn_paihang    = TFDirector:getChildByPath(ui, 'btn_paihang')
    self.btn_report     = TFDirector:getChildByPath(ui, 'btn_zhanbao')
    self.btn_fsbz       = TFDirector:getChildByPath(ui, 'btn_fsbz')
    self.btn_refresh    = TFDirector:getChildByPath(ui, 'btn_refresh')
    self.btn_shangcheng = TFDirector:getChildByPath(ui, 'btn_shangcheng')

    self.panel_role     = {}
    local panel_content     = TFDirector:getChildByPath(ui, 'panel_content')
    for i = 1, 4 do
        local panel_role               = TFDirector:getChildByPath(ui, 'panel_role'..i)
        panel_role.panel_role          = TFDirector:getChildByPath(panel_role, 'panel_role')
        panel_role.img_role            = TFDirector:getChildByPath(panel_role.panel_role, 'img_role')
        panel_role.panel_sx            = TFDirector:getChildByPath(panel_role, 'panel_sx')
        panel_role.img_name            = TFDirector:getChildByPath(panel_role, 'img_name')
        panel_role.txt_name            = TFDirector:getChildByPath(panel_role.img_name, 'txt_name')
        panel_role.img_qizhi           = TFDirector:getChildByPath(panel_role.img_name, 'img_qizhi')
        panel_role.img_biaozhi         = TFDirector:getChildByPath(panel_role.img_qizhi, 'img_biaozhi')
        panel_role.txt_bpname          = TFDirector:getChildByPath(panel_role.img_name, 'txt_bpname')
        panel_role.txt_power           = TFDirector:getChildByPath(panel_role.panel_sx, 'txt_power')
        panel_role.txt_dj              = TFDirector:getChildByPath(panel_role.panel_sx, 'txt_dj')
        panel_role.img_biaoqian        = TFDirector:getChildByPath(panel_role.panel_sx, 'img_biaoqian')
        panel_role.txt_jifen_num       = TFDirector:getChildByPath(panel_role.panel_sx, 'txt_jifen_num')
        panel_role.img_role:setVisible(false)
        self.panel_role[i]      = panel_role
    end
    self.DayilyRewardList   = HeroDuelRewardData:getRewardList(HeroMeetingManager.HeroBoxReward)
    self.panel_box = {}
    for i = 1,3 do
        local panel_box     = TFDirector:getChildByPath(ui, 'panel_box'..i)
        panel_box.btn_box   = TFDirector:getChildByPath(panel_box, 'btn_box')
        panel_box.img_ylq   = TFDirector:getChildByPath(panel_box, 'img_ylq')
        panel_box.btn_box.data      = self.DayilyRewardList[i]
        panel_box.btn_box.index     = i
        panel_box.btn_box.logic = self
        panel_box.btn_box:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onDailyBoxClickHandle),self)
        self.panel_box[i]   = panel_box
    end
    local img_ytz           = TFDirector:getChildByPath(ui, 'img_ytz')
    self.mr_num             = TFDirector:getChildByPath(img_ytz, 'txt_num')
    self.bqPath = {"ui_new/hero/img_bq1.png", "ui_new/hero/img_bq2.png", "ui_new/hero/img_bq3.png", "ui_new/hero/img_bq4.png"}

    local bg_wode   = TFDirector:getChildByPath(ui, 'bg_wode')
    self.my_biaoqian        = TFDirector:getChildByPath(bg_wode, 'img_biaoqian')
    self.my_head            = TFDirector:getChildByPath(bg_wode, 'icon_head')
    self.my_rank            = TFDirector:getChildByPath(bg_wode, 'txt_pm')
    self.my_score           = TFDirector:getChildByPath(bg_wode, 'txt_jf')
    self.txt_wsb            = TFDirector:getChildByPath(bg_wode, 'txt_wsb')

    self.challengeNum       = 0
    self.rewardIds          = {}
    self.timerId = nil
    self.endTime = 0

    local img_jinrijiangli  = TFDirector:getChildByPath(ui, 'img_jinrijiangli')
    self.txt_jiangli        = TFDirector:getChildByPath(img_jinrijiangli, 'txt_jiangli')
    local bg_times       = TFDirector:getChildByPath(ui, 'bg_times')
    self.txt_time       = TFDirector:getChildByPath(bg_times, 'txt_time')
end

function HeroMainLayer:removeUI()
    self.super.removeUI(self);

end
function HeroMainLayer:registerEvents()
    self.super.registerEvents(self);

    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(handler(self.OnRuleClick,self)))
    self.btn_mrzk:addMEListener(TFWIDGET_CLICK, audioClickfun(handler(self.OnDuiHuanClick,self)))
    self.btn_jiangli:addMEListener(TFWIDGET_CLICK, audioClickfun(handler(self.OnRewardClick,self)))
    self.btn_paihang:addMEListener(TFWIDGET_CLICK, audioClickfun(handler(self.OnListClick,self)))
    self.btn_report:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.openReportClickHandle),self)
    self.btn_fsbz:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onFSBZClickHandle),self)
    self.btn_refresh:addMEListener(TFWIDGET_CLICK,audioClickfun(self.OnBtnClickrefreshPlayer),self)
    self.btn_shangcheng:addMEListener(TFWIDGET_CLICK,audioClickfun(self.OnBtnClickShangcheng),self)

    self.HeroDuelMsg = function(event)
        self:refreshMainScene(event.data[1][1])
    end
    TFDirector:addMEGlobalListener(HeroMeetingManager.HeroDuelInfo ,self.HeroDuelMsg)

    self.heroPlayerMsg = function (event)
        self:refreshPlayerList(event.data)
    end
    TFDirector:addMEGlobalListener(HeroMeetingManager.REFRESH_HERO_DUEL_PLAYERS_RESPONSE ,self.heroPlayerMsg)

    self.OpenBox = function (event)
        local boxid = event.data[1][1].rewardId
        self.rewardIds[boxid] = boxid
        self:refreshBox()
    end
    TFDirector:addMEGlobalListener(HeroMeetingManager.OpenBox,self.OpenBox)
    self.updatePower = function (event)
        for i = 1,4 do 
            if event.data[1][1].playerId == self.panel_role[i].playerId then
                self.panel_role[i].txt_power:setText(event.data[1][1].power);
            end
        end
    end
    TFDirector:addMEGlobalListener(HeroMeetingManager.HERO_DUEL_POWER_UPDATE,self.updatePower)

    -- self.refreshHead = function (event)
    --     self.generalHead:onShow()        
    -- end
    -- TFDirector:addMEGlobalListener(MainPlayer.ChallengeTimesChange,self.refreshHead)

end

function HeroMainLayer:removeEvents()
    -- TFDirector:removeMEGlobalListener(ClimbManager.updateInfo ,self.updateInfoCallBack);
    TFDirector:removeMEGlobalListener(HeroMeetingManager.HeroDuelInfo ,self.HeroDuelMsg)
    self.HeroDuelMsg = nil

    TFDirector:removeMEGlobalListener(HeroMeetingManager.REFRESH_HERO_DUEL_PLAYERS_RESPONSE ,self.heroPlayerMsg)
    self.heroPlayerMsg =nil

    TFDirector:removeMEGlobalListener(HeroMeetingManager.OpenBox,self.OpenBox)
    self.OpenBox = nil 

    TFDirector:removeMEGlobalListener(HeroMeetingManager.HERO_DUEL_POWER_UPDATE,self.updatePower)
    self.updatePower = nil

    -- TFDirector:removeMEGlobalListener(MainPlayer.ChallengeTimesChange,self.refreshHead)
    -- self.refreshHead = nil

    self.super.removeEvents(self);
    if self.timerId ~= nil then 
        TFDirector:removeTimer(self.timerId)
        self.timerId = nil
    end

    if self.generalHead then
        self.generalHead:removeEvents()
    end
end

function HeroMainLayer:refreshMainScene(event)
    self.my_head:setTexture(MainPlayer:getIconPath())
    self.my_rank:setText(event.myRank)
    self.endTime = event.endTime / 1000
    if event.myRank == 0 then
        self.my_rank:setText("")
        self.txt_jiangli:setText(localizable.common_no)
        self.txt_wsb:setVisible(true)
    else
        self.txt_wsb:setVisible(false)
        local str = ""
        local rewardList = HeroDuelRewardData:getTodayRewardByRank(event.myRank)
        for i,v in pairs(rewardList) do
            local info = string.split(v,'_')
            local itemType = tonumber(info[1])
            local itemId   = tonumber(info[2])
            local itemNum  = tonumber(info[3])
            if i ~= 1 then
                str = str..'、'
            end
            if itemType == EnumDropType.GOODS then
                local item = ItemData:objectByID(itemId)
                if item then
                    local name = item.name
                    str = str..itemNum..name
                end
            elseif itemType == EnumDropType.WEIWANG or itemType == EnumDropType.COIN or itemType == EnumDropType.SYCEE then
                local name = localizable.ResourceName[itemType]
                str = str..itemNum..name
            end
        end
        self.txt_jiangli:setText(str)
    end
    
    self.my_score:setText(event.myScore)
    self.my_biaoqian:setTexture(self.bqPath[event.myGroup])
    self.mr_num:setText(event.challengeNum)
    self.challengeNum   = event.challengeNum
    if event.rewardIds then 
        self.rewardIds = event.rewardIds
    end
    self:refreshBox()
    if self.timerId == nil then
        self.timerId = TFDirector:addTimer(1000, -1, nil, 
            function() 
                self:refreshTime()
            end)
    end
    self:refreshTime()

end
function HeroMainLayer:refreshTime()
    local currTime = MainPlayer:getNowtime()
    local timestemp = self.endTime - currTime
    local day = math.floor(timestemp / (60 * 60 * 24))
    if day == 0 then 
        local Time = OperationActivitiesManager:TimeConvertString(timestemp)
        self.txt_time:setText(Time)
    elseif day > 0 then
        local hour = math.floor(timestemp / (60 * 60 )% 24)
        local min = math.floor(timestemp / 60 % 60)
        self.txt_time:setText(stringUtils.format(localizable.common_time_3, day, hour, min))
    elseif day < 0 then
        --活动已结束
        self.txt_time:setText(localizable.treasureMain_tiemout)
        --AlertManager:close()
    end 
end
function HeroMainLayer:refreshBox()
    local state = false
    for i = 1,3 do
        self.panel_box[i].img_ylq:setVisible(false)
        self.panel_box[i]:setGrayEnabled(false)
        self.panel_box[i].btn_box:setTouchEnabled(true)
        self:showRewardEffect(self.panel_box[i],false)
        if self.rewardIds and self.rewardIds[i] ~= nil then
            self.panel_box[i].img_ylq:setVisible(true)
            self.panel_box[i]:setGrayEnabled(true)
            self.panel_box[i].btn_box:setTouchEnabled(false)
        elseif self.challengeNum >= i*5 then
            if self.rewardIds == nil or self.rewardIds[i] == nil then 
                state = true
                self:showRewardEffect(self.panel_box[i],true)
            end
        end
    end
    HeroMeetingManager.boxreward  = state
end

function HeroMainLayer:showRewardEffect(node,bShow)
    if bShow == true then
        if node.EscortingEffect == nil then
            local resPath = "effect/escorting.xml"
            TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
            local effect = TFArmature:create("escorting_anim")
            effect:setAnimationFps(GameConfig.ANIM_FPS)
            node:addChild(effect, 1)
            local size = node:getContentSize()
            effect:setPosition(ccp(size.width * 0.5, size.height * 0.5 -5))
            effect:setAnchorPoint(ccp(0.5, 0.5))
            effect:setScale(0.5)
            node.EscortingEffect = effect
            node.EscortingEffect:playByIndex(1, -1, -1, 1)
        end
    else
        if node.EscortingEffect ~= nil then
            node.EscortingEffect:removeFromParent()
            node.EscortingEffect = nil
        end
    end
end

function HeroMainLayer:refreshPlayerList(data)
    --刷新红点.
    local redPointState = HeroMeetingManager.settlement
    CommonManager:setRedPoint(self.btn_jiangli, redPointState,"peakHaveTimes",ccp(0,0))
    --刷新自己的信息
    self.myGroup = data[1][1].myGroup
    HeroMeetingManager.myGroup = self.myGroup
    self.my_biaoqian:setTexture(self.bqPath[data[1][1].myGroup])
    self.my_rank:setText(data[1][1].myRank)
    if data[1][1].myRank == 0 then
        self.my_rank:setText("")
        self.txt_wsb:setVisible(true)
    else
        self.txt_wsb:setVisible(false)
    end
    self.my_score:setText(data[1][1].myScore)
    -- 对战玩家刷新
    self.playerList = data[1][1].players;
    for i = 1,4 do
        self.panel_role[i]:setVisible(false);
    end
    if self.playerList then
        for index,playerItem in pairs(self.playerList) do
            if index > 4 then 
                return
            end
            self.panel_role[index]:setVisible(true);
            local player_node = self.panel_role[index];
            player_node.txt_jifen_num:setText(playerItem.playerScore)
            player_node.txt_dj:setText(playerItem.playerLevel  .. "级");
            player_node.txt_power:setText(playerItem.fightPower);
            player_node.img_biaoqian:setTexture(self.bqPath[playerItem.playerGroup])
            player_node.txt_name:setText(playerItem.playerName);
            if playerItem.guildName then 
                player_node.txt_bpname:setText(playerItem.guildName)
                local bannerInfo = stringToNumberTable(playerItem.bannerId, '_')
                player_node.img_qizhi:setTexture(FactionManager:getBannerBgPath(bannerInfo[1],bannerInfo[2]))
                player_node.img_biaozhi:setTexture(FactionManager:getBannerIconPath(bannerInfo[3],bannerInfo[4])) 
                player_node.img_qizhi:setVisible(true)
                player_node.txt_bpname:setVisible(true)
            else
                player_node.img_qizhi:setVisible(false)
                player_node.txt_bpname:setText(localizable.HERO_FACTION)
            end
            if player_node.playerId ~= playerItem.playerId then
                player_node.playerId = playerItem.playerId;

               
                local armature = self:getArmature(playerItem.useIcon);
                armature:setScaleX(-1)
                self:AddRoleFootEffect(armature);

                player_node.panel_role:removeAllChildrenWithCleanup(true);
                --加套装特效
                if playerItem.suitNum ~= nil then 
                    Public:OtherPlayEffectOnRole(armature,playerItem.suitNum)
                end

                player_node.panel_role:addChild(armature,1)

                local btn_attack = player_node.panel_role;
                btn_attack.logic = self;
                btn_attack.playerId = playerItem.playerId;
                btn_attack:setTouchEnabled(true)
                btn_attack:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onPlayerItemClickHandle),1); 
            end
        end  
    end
end
function HeroMainLayer:getArmature(generalId)

    local npcTableData = RoleData:objectByID(generalId)
    local resID = npcTableData.image
	
	local resPathXML = "armature/"..resID..".xml"
	local resPathAlats = "armature/".. resID .. ".atlas" 
	local armature
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "armature/".. resID
		armature = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		armature = TFArmature:create(resID.."_anim")
	else
		resID = 10006
		TFResourceHelper:instance():addArmatureFromJsonFile("armature/"..resID..".xml")
		armature = TFArmature:create(resID.."_anim")
	end
	
	if armature == nil then
		assert(false, "armature"..resID.."create error")
		return
	end

    --armature:setScale(0.9)
    armature:setPositionX(100)
    armature:setAnimationFps(GameConfig.ANIM_FPS)
    armature:playByIndex(0, -1, -1, 1)
    return armature
end
function HeroMainLayer:AddRoleFootEffect(roleArmature)
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role.xml")
    local effect = TFArmature:create("main_role_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        roleArmature:addChild(effect)
    end

    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role2.xml")
    local effect2 = TFArmature:create("main_role2_anim")
    if effect2 ~= nil then
        effect2:setAnimationFps(GameConfig.ANIM_FPS)
        effect2:playByIndex(0, -1, -1, 1)
        effect2:setZOrder(-1)
        effect2:setPosition(ccp(0, -10))
        roleArmature:addChild(effect2)
    end
end
function HeroMainLayer.onPlayerItemClickHandle(sender)
    if not MainPlayer:isEnoughTimes(EnumRecoverableResType.HERO,1, true) then
        return ;
    end
    HeroMeetingManager:showDetail(sender.playerId)
end
--兑换面板
function HeroMainLayer:OnDuiHuanClick(sender)
    local layer = AlertManager:addLayerByFile("lua.logic.heromeeting.HeroDuiHuanLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
    HeroMeetingManager:sendHeroDuihuanInformation()
    -- layer:loadData();
    AlertManager:show()
end
--奖励面板
function HeroMainLayer:OnRewardClick(sender)
    local layer = AlertManager:addLayerByFile("lua.logic.heromeeting.HeroRewardLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
    -- layer:loadData();
    AlertManager:show()
end
--排行面板
function HeroMainLayer:OnListClick(sender)
   -- local self = sender.logic
    HeroMeetingManager:sendPersonalRanking(self.myGroup)
    HeroMeetingManager:OpenHeroListLayer()
end
--帮助面板
function HeroMainLayer:OnRuleClick( sender )
    CommonManager:showRuleLyaer('thekingoffighters')
end
--战斗纪录
function HeroMainLayer.openReportClickHandle(sender)
    local layer = AlertManager:addLayerByFile("lua.logic.heromeeting.HeroRecordLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1)
    AlertManager:show()
end

function HeroMainLayer.onFSBZClickHandle( sender )
    ZhengbaManager:openArmyLayer(EnumFightStrategyType.StrategyType_AREAN)
end
--每日奖励
function HeroMainLayer:openBoxDetailLayer(idx, count)
    -- print("self.DayilyRewardList[idx]",self.DayilyRewardList[idx])
    local data = {self.DayilyRewardList[idx]}
    if self.challengeNum < count then
        local layer  = require("lua.logic.heromeeting.HeroBoxDetail"):new()
        layer:loadData(data, count)
        AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
        AlertManager:show()
    else
        HeroMeetingManager:sendOpenBox(idx)
    end
end

function HeroMainLayer.OnBtnClickrefreshPlayer()
    HeroMeetingManager:sendHeroPlayer()
end
function HeroMainLayer.onDailyBoxClickHandle(sender)
    local self = sender.logic 
    self:openBoxDetailLayer(sender.index,sender.data.count )
end
function HeroMainLayer.OnBtnClickShangcheng()
    MallManager:openMallLayerByType(EnumMallType.WeiWangMall,1)
end

return HeroMainLayer;
