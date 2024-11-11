-- client side CrossZhengBaMainLayer
--[[
 * @Description: 天梯猪界面
 ]]
-- script writer chikui
-- creation time 2017-02-27

local CrossZhengBaMainLayer = class("CrossZhengBaMainLayer", BaseLayer)


function CrossZhengBaMainLayer:ctor()
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.crosszhenba.CrossZhenBaMain")
end

function CrossZhengBaMainLayer:initUI(ui)
	self.super.initUI(self,ui)
    self.panelDesPos = -525
    self.btn_help         = TFDirector:getChildByPath(ui, 'btn_help')
    self.btn_close = TFDirector:getChildByPath(ui, 'btn_fanhui')

    self.panel_role_list = {}
    for i=1,6 do
        local rootNode = TFDirector:getChildByPath(ui, 'panel_role'..i)
        self.panel_role_list[i] = rootNode
        self.panel_role_list[i].panel_role  = TFDirector:getChildByPath(rootNode, 'panel_role')
        self.panel_role_list[i].img_role    = TFDirector:getChildByPath(rootNode, 'img_role')
        self.panel_role_list[i].txt_name    = TFDirector:getChildByPath(rootNode, 'txt_name')
        self.panel_role_list[i].txt_power   = TFDirector:getChildByPath(rootNode, 'txt_power')
        self.panel_role_list[i].txt_dj  = TFDirector:getChildByPath(rootNode, 'txt_dj')
        self.panel_role_list[i].img_dw  = TFDirector:getChildByPath(rootNode, 'img_dw')
        self.panel_role_list[i].img_tzcg  = TFDirector:getChildByPath(rootNode, 'img_tzcg')
        self.panel_role_list[i].img_ytz  = TFDirector:getChildByPath(rootNode, 'img_ytz')
        self.panel_role_list[i].img_level  = TFDirector:getChildByPath(rootNode, 'img_level')
        self.panel_role_list[i].img_heidi  = TFDirector:getChildByPath(rootNode, 'img_heidi')
        self.panel_role_list[i].armature = nil
    end

    -- self.txt_time = TFDirector:getChildByPath(ui, 'txt_time')
    self.btn_reward = TFDirector:getChildByPath(ui, 'btn_reward')
    self.btn_task = TFDirector:getChildByPath(ui, 'btn_sjcj')
    self.btn_help = TFDirector:getChildByPath(ui, 'btn_guizhe')
    self.btn_rank = TFDirector:getChildByPath(ui, 'btn_tjb')

    self.panel_effect_back = TFDirector:getChildByPath(ui, 'panel_effect_back')
    self.panel_effect_center = TFDirector:getChildByPath(ui, 'panel_effect_center')
    self.panel_effect_front = TFDirector:getChildByPath(ui, 'panel_effect_front')

    self.panel_myinfo = TFDirector:getChildByPath(ui, 'img_di')
    self.img_dw = TFDirector:getChildByPath(self.panel_myinfo, 'img_dw')
    self.img_dj = TFDirector:getChildByPath(self.img_dw, 'img_dj')
    self.txt_time = TFDirector:getChildByPath(ui, 'txt_time')
    self.node_star_list = {}
    self.node_star_list[1] = TFDirector:getChildByPath(self.panel_myinfo, 'panel_star_to3')
    self.node_star_list[2] = TFDirector:getChildByPath(self.panel_myinfo, 'panel_star_to4')
    self.node_star_list[3] = TFDirector:getChildByPath(self.panel_myinfo, 'panel_star_to5')
    self.node_star_list[4] = TFDirector:getChildByPath(self.panel_myinfo, 'panel_star_tow')

    -- 一键扫荡
    self.btn_challenge = TFDirector:getChildByPath(ui, 'btn_challenge')
    local bg_tips = TFDirector:getChildByPath(ui, 'bg_times2')
    local txt_tips = TFDirector:getChildByPath(bg_tips, 'txt')
    local isOpen = MainPlayer:getServerSwitchStatue(ServerSwitchType.LadderSweep)
    txt_tips:setVisible(isOpen)
    bg_tips:setVisible(isOpen)

    self.tabView = nil
    self.oldRankIndex = nil
    self.isDoGotoRank = false
    self.armatureList = {}
    self:showLeftTimes()
    self:addUIEffect()
    self:showFightEndEffect()
end

function CrossZhengBaMainLayer:onShow()
    self.super.onShow(self)
    self:refreshUI(true)
end

function CrossZhengBaMainLayer:dispose()
    self.super.dispose(self)
end

function CrossZhengBaMainLayer:showFightEndEffect()
    local myChallengeInfo = CrossZhengBaManager:getMyChallengeInfo()
    if self.newGrade == nil then
        self.newGrade = myChallengeInfo.grade
        self.oldGrade = self.newGrade
        self.newStar = myChallengeInfo.star
        self.oldStar = self.newStar
    else
        self.oldGrade = self.newGrade
        self.oldStar = self.newStar
        self.newGrade = myChallengeInfo.grade
        self.newStar = myChallengeInfo.star

        if self.newGrade == self.oldGrade and self.newStar == self.oldStar then
        else
            CrossZhengBaManager:openDWLayer(self.newGrade,self.newStar,self.oldGrade,self.oldStar)
            print("self.newGrade ~= self.oldGrade")
            print("self.newGrade =",self.newGrade)
            print("self.oldGrade =",self.oldGrade)
            print("self.newStar =",self.newStar)
            print("self.oldStar =",self.oldStar)
        end
    end
end

function CrossZhengBaMainLayer:refreshUI(isOnShow)
    self:showChallengeList()
    self:showMyInfo()
    CommonManager:setRedPoint(self.btn_task, CrossZhengBaManager:IsCanGetReward(),"IsCanGetReward",ccp(0,0))
end

function CrossZhengBaMainLayer:addUIEffect()
    local resPath = "effect/crosszhengba_back_effect.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create("crosszhengba_back_effect_anim")
    self.panel_effect_back:addChild(effect,100,100)
    effect:setPosition(ccp(960*0.5,320))
    effect:playByIndex(0,-1,-1,1)

    resPath = "effect/crosszhengba_center_effect.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    effect = TFArmature:create("crosszhengba_center_effect_anim")
    self.panel_effect_center:addChild(effect,100,100)
    effect:setPosition(ccp(960*0.5,320))
    effect:playByIndex(0,-1,-1,1)

    resPath = "effect/crosszhengba_front_effect.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    effect = TFArmature:create("crosszhengba_front_effect_anim")
    self.panel_effect_front:addChild(effect,100,100)
    effect:setPosition(ccp(960*0.5,320))
    effect:playByIndex(0,-1,-1,1)
end

function CrossZhengBaMainLayer:showMyInfo()
    local myChallengeInfo = CrossZhengBaManager:getMyChallengeInfo()
    local itemData = CrossZhengBaManager:getData(myChallengeInfo.grade)
    if itemData.max_star == 0 then
        local node = self.node_star_list[4]
        node:setVisible(true)
        for i=1,3 do
            self.node_star_list[ i ]:setVisible(false)
        end
        local txt_star = TFDirector:getChildByPath(node, 'txt_num')
        local img_star = TFDirector:getChildByPath(node, 'img_light')
        if myChallengeInfo.star <= 0 then
            txt_star:setText("")
            img_star:setVisible(false)
        else
            txt_star:setText("X" .. myChallengeInfo.star)
            img_star:setVisible(true)
            img_star:setOpacity(255)
        end
    else
        for i=1,4 do
            if i == itemData.max_star - 2 then
                self.node_star_list[ i ]:setVisible(true)
            else
                self.node_star_list[ i ]:setVisible(false)
            end
        end
        local node = self.node_star_list[ itemData.max_star - 2 ]
        for i=1,itemData.max_star do
            local node0 = TFDirector:getChildByPath(node, 'img_star' .. i)
            local img_star = TFDirector:getChildByPath(node0, 'img_light')
            if i <= myChallengeInfo.star then
                img_star:setVisible(true)
                img_star:setOpacity(255)
            else
                img_star:setVisible(false)
            end
        end
    end
    local path = CrossZhengBaManager:getGradeImg(myChallengeInfo.grade)
    self.img_dw:setTexture(path)
    path = CrossZhengBaManager:getGradeName(myChallengeInfo.grade)
    self.img_dj:setTexture(path)
end

function CrossZhengBaMainLayer:showLeftTimes()
    local function MakeTimerStr()
        local timeNow = MainPlayer:getNowtime()
        local time = ConstantData:objectByID("Personal.Ladder.Battle.Cycle").value
        time = time * 24 * 3600
        local lastTime = CrossZhengBaManager:getLastFinishTime()
        local totalSec = lastTime + time - timeNow
        if totalSec < 0 then
            totalSec = 0
        end

        local day = math.floor(totalSec/(24*3600))
        totalSec = totalSec - day * 24 * 3600
        local hour = math.floor(totalSec/3600)
        totalSec = totalSec - hour * 3600
        local min = math.floor(totalSec/60)
        local sec = math.floor(totalSec - min * 60)
        local strList = ""
        if day > 0 then
            strList = day..localizable.time_day_txt
        end
        if hour > 0 then
            strList = strList .. hour .. localizable.time_hour_txt0
        end
        if min > 0 then
            strList = strList .. min .. localizable.time_minute_txt0
        end
        if sec <= 0 then 
            sec = 0
        end
        strList = strList..sec..localizable.time_second_txt
        self.txt_time:setText(strList)
    end

    MakeTimerStr()
    self.updateTimerID = TFDirector:addTimer(1000, -1, nil, 
    function()
        MakeTimerStr()
    end)
end

function CrossZhengBaMainLayer:CreateArmature(roleID)
    local roleTableData = RoleData:objectByID(roleID)
    if roleTableData == nil then
        return nil
    end

    local resID = roleTableData.image
	
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
    -- GameResourceManager:addRole( roleID, armature)

    self.armatureList[roleID] = armature
    armature:retain()
    return armature
end

function CrossZhengBaMainLayer:AddRoleFootEffect(roleArmature)
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role.xml")
    local effect = TFArmature:create("main_role_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        roleArmature:addChild(effect)
    end

    -- TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role2.xml")
    -- local effect2 = TFArmature:create("main_role2_anim")
    -- if effect2 ~= nil then
    --     effect2:setAnimationFps(GameConfig.ANIM_FPS)
    --     effect2:playByIndex(0, -1, -1, 1)
    --     effect2:setZOrder(-1)
    --     effect2:setPosition(ccp(0, -10))
    --     roleArmature:addChild(effect2)
    -- end
end

function CrossZhengBaMainLayer:RemoveNoUseArmature()
    local needRemove = false
    for roleID, armature in pairs(self.armatureList) do
        if armature then
            armature:release()
        end
        if not self:IsUsedArmature(roleID)  then
            GameResourceManager:removeRole( roleID )
            needRemove = true
        end
    end
    self.armatureList = {}
    if needRemove then
        me.ArmatureDataManager:removeUnusedArmatureInfo()
    end
end

function CrossZhengBaMainLayer:IsUsedArmature(roleID)
    local roleList = CardRoleManager:getUsedCardList()
    local roleNum = roleList:length()
    for i=1,roleNum do
        local cardRole = roleList:getObjectAt(i)
        if cardRole ~= nil and cardRole.id == roleID then
            return true
        end
    end

    return false
end

function CrossZhengBaMainLayer:showChallengeList()
    local scaleXList = {1,1,1,1,1,1}
    -- local myServerId = nil
    -- local serverInfo = SaveManager:getServerInfo()
    -- if serverInfo then
    --     myServerId = serverInfo.serverId
    -- end
    self.sweepList = {}
    for i = 1,6 do
        local heroInfo = CrossZhengBaManager:getChallengeInfo(i)
        if heroInfo then
            self.panel_role_list[i]:setVisible(true)
            if heroInfo.useIcon == nil or heroInfo.useIcon == 0 then
                heroInfo.useIcon = 77
            end
            local armature = self.panel_role_list[i].armature
            if armature == nil or armature.roleId ~= heroInfo.useIcon then
                if armature then
                    armature:removeFromParent()
                    self.panel_role_list[i].armature = nil
                end
                if self.armatureList[heroInfo.useIcon] ~= nil then
                    armature = self.armatureList[heroInfo.useIcon]:clone()
                else
                    local armatureModel = self:CreateArmature(heroInfo.useIcon)
                    if (armatureModel) then
                        armature = armatureModel:clone()
                    else
                        toastMessage("Error --> useIcon: "..heroInfo.useIcon)
                    end
                end
                if (armature) then
                    armature.roleId = heroInfo.useIcon
                    self.panel_role_list[i].armature = armature
                    self.panel_role_list[i].panel_role:addChild(armature,10)
                    local pos = self.panel_role_list[i].img_role:getPosition()
                    pos.y = pos.y - 80
                    armature:setPosition(pos)
                    armature:setName("armature")
                    armature:play("stand", -1, -1, 1)
                    armature:setScaleX(scaleXList[i])
                    self:AddRoleFootEffect(armature)
                end
            end
            if armature then
                self.panel_role_list[i].armature = armature
            end
            self.panel_role_list[i].img_role:setVisible(false)
            self.panel_role_list[i].panel_role:setTouchEnabled(true)
			local serverId = math.floor(heroInfo.playerId)
            serverId = math.floor(serverId/131072)
            self.panel_role_list[i].panel_role:setTouchEnabled(true)
            local tipFunc = function()end
            self.panel_role_list[i].img_tzcg:setVisible(false)
            self.panel_role_list[i].img_ytz:setVisible(false)
            if heroInfo.state == CrossZhengBaManager.HeroState_0 then
                tipFunc = function( sender )
                    if CrossZhengBaManager:IsCanFight() == true then
                        CrossZhengBaManager:requestChallengerDetail(i - 1)
                    else
                        toastMessage(localizable.CrossZhengBa_Main_Layer_tip3)
                    end
                end
                -- 可以一键扫荡
                -- 服务器他们说下标是从0开始,所以要减1
                table.insert(self.sweepList,i-1)
            elseif heroInfo.state == CrossZhengBaManager.HeroState_1 then
                tipFunc = function( sender )
                    toastMessage(localizable.CrossZhengBa_Main_Layer_tip1)
                end
                self.panel_role_list[i].img_tzcg:setVisible(true)
            elseif heroInfo.state == CrossZhengBaManager.HeroState_2 then
                tipFunc = function( sender )
                    toastMessage(localizable.CrossZhengBa_Main_Layer_tip2)
                end
                self.panel_role_list[i].img_ytz:setVisible(true)
            end
            self.panel_role_list[i].panel_role:addMEListener(TFWIDGET_CLICK, audioClickfun(tipFunc))
			serverId = math.mod(serverId,1000)
            local servvvvStr = getServerShortStrByName(heroInfo.serverName)
            self.panel_role_list[i].txt_name:setText(servvvvStr .. heroInfo.name)
            self.panel_role_list[i].txt_power:setText('' .. heroInfo.power)
            self.panel_role_list[i].txt_dj:setText(stringUtils.format(localizable.common_LV,heroInfo.level))
            self.panel_role_list[i].img_dw:setTexture(CrossZhengBaManager:getGradeImg( heroInfo.grade ))
            local path = CrossZhengBaManager:getGradeLevelTag(heroInfo.grade)
            if path and path ~= "" then
                self.panel_role_list[i].img_level:setVisible(true)
                self.panel_role_list[i].img_level:setTexture(path)
                self.panel_role_list[i].img_heidi:setVisible(true)
            else
                self.panel_role_list[i].img_level:setVisible(false)
                self.panel_role_list[i].img_heidi:setVisible(false)
            end
        else
            self.panel_role_list[i]:setVisible(false)
        end
    end

    if (#self.sweepList > 0 and CrossZhengBaManager.isSweepStatus == true and MainPlayer:getServerSwitchStatue(ServerSwitchType.LadderSweep)) then
        self.btn_challenge:setVisible(true)
        self.btn_challenge:setGrayEnabled(false)
    else
        self.btn_challenge:setTouchEnabled(false)
        self.btn_challenge:setGrayEnabled(true)
    end
end

function CrossZhengBaMainLayer:removeUI()
    self:RemoveNoUseArmature()
    if self.updateTimerID then
        TFDirector:removeTimer(self.updateTimerID)
        self.updateTimerID = nil
    end
    CrossZhengBaManager:reset_24()
    self.super.removeUI(self)
end

function CrossZhengBaMainLayer.onRuleClick( sender )
    CommonManager:showRuleLyaer('tianjiezhengba')
end

function CrossZhengBaMainLayer.onShowTaskClick( sender )
    CrossZhengBaManager:openTaskLayer()
end

function CrossZhengBaMainLayer.onShowRankClick( sender )
    CrossZhengBaManager:openRankLayer()
end

function CrossZhengBaMainLayer.onRewardClick(sender)
    CrossZhengBaManager:openRewardLayer()
end

function CrossZhengBaMainLayer.onSweepClick(sender)
    local self = sender.logic
    CrossZhengBaManager:requestSweep(self.sweepList)
end
function CrossZhengBaMainLayer:registerEvents()
	self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);
    self.btn_reward:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRewardClick),1)
    self.btn_reward.logic = self

    self.btn_rank:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShowRankClick),1)
    self.btn_rank.logic = self

    self.btn_task:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShowTaskClick),1)
    self.btn_task.logic = self

    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRuleClick))
    self.btn_help.logic = self

    self.btn_challenge:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSweepClick))
    self.btn_challenge.logic = self

    self.receiveMainInfo = function (event)
        self:refreshUI(self.isShow)
        if event.data[1][1] == true then
            self:toastStopMsg()
        end
    end
    TFDirector:addMEGlobalListener(CrossZhengBaManager.RECEIVE_MAIN_INFO,self.receiveMainInfo)

    self.receiveHomeSceneEnter = function (event)
        self:showFightEndEffect()
    end
    TFDirector:addMEGlobalListener("onEnterHomeScene",self.receiveHomeSceneEnter)
end

function CrossZhengBaMainLayer:toastStopMsg()
    local callFuncN = CCCallFuncN:create( function()
        toastMessage(localizable.CrossZhengBa_vs_Layer_tip3)
    end )
    
    local callFuncN0 = CCCallFuncN:create( function()
        self:showFightEndEffect()
    end )

    local acArr = TFVector:create()
    local delayAc = CCDelayTime:create(1.5)
    local delayAc0 = CCDelayTime:create(1.5)
    acArr:addObject(delayAc)
    acArr:addObject(callFuncN)
    acArr:addObject(delayAc0)
    acArr:addObject(callFuncN0)
    self:runAction(CCSequence:create(acArr))
end

function CrossZhengBaMainLayer:removeEvents()
    TFDirector:removeMEGlobalListener(CrossZhengBaManager.RECEIVE_MAIN_INFO,self.receiveMainInfo)
    TFDirector:removeMEGlobalListener("onEnterHomeScene",self.receiveHomeSceneEnter)

    self.super.removeEvents(self)
end

return CrossZhengBaMainLayer
