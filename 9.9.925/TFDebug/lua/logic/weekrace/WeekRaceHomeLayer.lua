--[[
******争霸赛-周赛-主界面*******

	-- by quanhuan
	-- 2015/12/4
	
]]

local WeekRaceHomeLayer = class("WeekRaceHomeLayer",BaseLayer)

local NodeEndIdx = {8,4,2}
local NodeMax = {4,2,1}
local NodeChange = {1,3,4,2}

local msgRound = 0
local msgIndex = 0
local msgPlayerId = 0

-- local timeFont = {
--     {
--         '押注剩余时间:',
--         '八进四战斗中:',
--         '半决赛开始剩余时间:',
--     },
--     {
--         '押注剩余时间:',
--         '半决赛战斗中:',
--         '总决赛开始剩余时间:',
--     },
--     {
--         '押注剩余时间:',
--         '总决赛战斗中:',
--     }
-- }

local timeFont = localizable.weekrace_timeFont

function WeekRaceHomeLayer:ctor(data)

	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.zhenbashai.Zhenbashai_8qiang")

    self.currPageIdx = nil
end

function WeekRaceHomeLayer:initUI( ui )

	self.super.initUI(self, ui)

    self.generalHead = CommonManager:addGeneralHead(self)
    self.generalHead:setData(ModuleType.WeekRace,{HeadResType.COIN})

    self.btnRule = TFDirector:getChildByPath(ui, "btn_help")
    self.btnReward = TFDirector:getChildByPath(ui, "btn_jiangli")
    self.btnBattlefield = TFDirector:getChildByPath(ui, "btn_zhanbao")
    self.btnBuzhen = TFDirector:getChildByPath(ui, "btn_buzhen") 
    self.Box = TFDirector:getChildByPath(ui,"btn_mubiao1")
    self.img_baoxiang = TFDirector:getChildByPath(self.Box, 'img_baoxiang')
    self.txt_mubiao = TFDirector:getChildByPath(self.Box, 'txt_mubiao')

    self.bg = TFDirector:getChildByPath(ui, 'bg')

    self.progressInfo = {}
    local progressNode = TFDirector:getChildByPath(ui, 'Panel_shaichen')
    for i=1,3 do
        self.progressInfo[i] = {}
        local yNode = TFDirector:getChildByPath(progressNode, 'y'..i)
        self.progressInfo[i].node = yNode
        self.progressInfo[i].time = TFDirector:getChildByPath(yNode, 'txt_time')
        self.progressInfo[i].desc = TFDirector:getChildByPath(yNode, 'txt_battle')
    end

    self.panelNode = {}
    self.panelRoleInfo = {}
    self.panelZhanbaoBtn = {}
    self.CountDownTime = {}
    self.CountDownBg = {}
    self.AnimEffect = {}
    local panelName = {'Panel_8to4','Panel_4to2','Panel_2to1'} 
    local zhanbaoName = {
        {'btn_zhanbao1','btn_zhanbao2','btn_zhanbao3','btn_zhanbao4'},
        {'btn_zhanbao1','btn_zhanbao3'}
    } 
    local AnimName = {
        {'panelAnim1','panelAnim2','panelAnim3','panelAnim4'},
        {'panelAnim1','panelAnim2'},
        {'panelAnim1'}
    }  
    for i=1,3 do
        local panelNode = TFDirector:getChildByPath(ui, panelName[i])
        self.panelNode[i] = panelNode

        self.CountDownTime[i] = TFDirector:getChildByPath(panelNode, 'txt_time')
        self.CountDownBg[i] = TFDirector:getChildByPath(panelNode, 'bg_yazhushijian')

        for j=1,NodeEndIdx[i] do
            local roleNode = TFDirector:getChildByPath(panelNode, 'role'..j..'_bg')
            local idx = #self.panelRoleInfo + 1
            self.panelRoleInfo[idx] = {}
            self.panelRoleInfo[idx].roleName = TFDirector:getChildByPath(roleNode, 'txt_name')
            self.panelRoleInfo[idx].roleHead = TFDirector:getChildByPath(roleNode, 'icon_head')
            self.panelRoleInfo[idx].roleFrame = TFDirector:getChildByPath(roleNode, 'img_di')
            self.panelRoleInfo[idx].panel_buff = TFDirector:getChildByPath(roleNode, 'panel_buff')
			self.panelRoleInfo[idx].panel_buff:setVisible(false)
            self.panelRoleInfo[idx].txt_buff = TFDirector:getChildByPath(roleNode, 'txt_num')
            self.panelRoleInfo[idx].btn_buff = TFDirector:getChildByPath(roleNode, 'btn_buff')
            self.panelRoleInfo[idx].roleHead:setTouchEnabled(true)
            self.panelRoleInfo[idx].iconLose = TFDirector:getChildByPath(roleNode, 'icon_fu')
            self.panelRoleInfo[idx].iconWin = TFDirector:getChildByPath(roleNode, 'icon_sheng')
            self.panelRoleInfo[idx].iconYiya = TFDirector:getChildByPath(roleNode, 'icon_yiya')
            self.panelRoleInfo[idx].btnYazhu = TFDirector:getChildByPath(roleNode, 'btn_yazhu')
        end
        if zhanbaoName[i] then
            for k,v in pairs(zhanbaoName[i]) do
                local idx = #self.panelZhanbaoBtn
                self.panelZhanbaoBtn[idx+1] = TFDirector:getChildByPath(panelNode, v)
                self.panelZhanbaoBtn[idx+1]:setVisible(false)
            end
        end

        if AnimName[i] then
            for k,v in pairs(AnimName[i]) do
                local idx = #self.AnimEffect
                self.AnimEffect[idx+1] = TFDirector:getChildByPath(panelNode, v)
                self.AnimEffect[idx+1]:setVisible(false)

                TFResourceHelper:instance():addArmatureFromJsonFile("effect/weekFight.xml")
                local effect = TFArmature:create("weekFight_anim")
                effect:setPosition(ccp(0,0))
                effect:setScale(0.5)
                self.AnimEffect[idx+1]:addChild(effect,100)
                self.AnimEffect[idx+1].animEffect = effect
                effect:playByIndex(0,-1,-1,1)
            end
        end
        if i == 3 then
            self.gameOver = {}
            local gameOverNode = TFDirector:getChildByPath(panelNode, 'bg_gameover')
            self.gameOver.roleNode = gameOverNode
            self.gameOver.rolePower = TFDirector:getChildByPath(gameOverNode, 'txt_power')
            self.gameOver.roleHead = TFDirector:getChildByPath(gameOverNode, 'img_head')
            self.gameOver.roleFrame = TFDirector:getChildByPath(gameOverNode, 'img_headframe')
            self.gameOver.roleName = TFDirector:getChildByPath(gameOverNode, 'txt_name')
            self.gameOver.roleHead:setTouchEnabled(true)
        end
    end
    ZhengbaManager:joinChampions()
    self:freshBoxInfo()
end


function WeekRaceHomeLayer:removeUI()
	self.super.removeUI(self)
end

function WeekRaceHomeLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow()

    if self.bgEffect == nil then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/zhengbasai_jifen_bg.xml")
        local effect = TFArmature:create("zhengbasai_jifen_bg_anim")
        effect:setPosition(ccp(568,320))
        self.bg:addChild(effect,100)
        self.bgEffect = effect
        effect:playByIndex(0,-1,-1,1)
    end
    self:refreshWindow()
end

function WeekRaceHomeLayer:registerEvents()

	self.super.registerEvents(self)
    self.playAudio = true

    if self.generalHead then
        self.generalHead:registerEvents()
    end

    self.btnRule:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnRuleClick))
    self.btnRule.logic = self
    self.btnReward:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnRewardClick))
    self.btnReward.logic = self
    self.btnBattlefield:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnBattlefieldClick))
    self.btnBattlefield.logic = self
    self.btnBuzhen:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnBuzhenClick))
    self.btnBuzhen.logic = self
    self.Box:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OpenBoxClick))
    self.Box.logic = self

    self.gameOver.roleHead:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnHeadClick))
    for i=1,#self.panelRoleInfo do        
        self.panelRoleInfo[i].btnYazhu:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnRateClick))
        self.panelRoleInfo[i].roleHead:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnHeadClick))    
        self.panelRoleInfo[i].btn_buff:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnBuffClick))    
        self.panelRoleInfo[i].btn_buff:setVisible(false) -- pck tag 2017.2.15
    end
    for i=1,#self.panelZhanbaoBtn do
        self.panelZhanbaoBtn[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.panelBtnZhanbaoClick))
    end

    self.refreshWindowCallBack = function (event)
        self:refreshWindow()
    end
    TFDirector:addMEGlobalListener(WeekRaceManager.refreshWindow, self.refreshWindowCallBack)  

    self.onOverView = function(event)
        local userData   = event.data[1]
        local cardRoleId = userData[1].warside[1].id

        OtherPlayerManager:openRoleInfo(userData[1], cardRoleId)
    end
    TFDirector:addMEGlobalListener(OtherPlayerManager.WeekRace, self.onOverView)

    self.openBoxSucess = function(event)
        self:freshBoxInfo()
    end
    TFDirector:addMEGlobalListener(ZhengbaManager.OPENBOXSUCESS, self.openBoxSucess)

    self.updataBetRate = function(event)
        self:btnYaZhuClick(event.data[1].betRadio)
    end
    TFDirector:addMEGlobalListener(ZhengbaManager.BETRATE, self.updataBetRate)

end

function WeekRaceHomeLayer:removeEvents()

	if self.generalHead then
        self.generalHead:removeEvents()
    end
    self.playAudio = false
    TFAudio.stopAllEffects()
 	
 	self.btnRule:removeMEListener(TFWIDGET_CLICK)
    self.btnReward:removeMEListener(TFWIDGET_CLICK)
    self.btnBattlefield:removeMEListener(TFWIDGET_CLICK)
    self.btnBuzhen:removeMEListener(TFWIDGET_CLICK)
    self.Box:removeMEListener(TFWIDGET_CLICK)
    self.gameOver.roleHead:removeMEListener(TFWIDGET_CLICK)
    for i=1,#self.panelRoleInfo do        
        self.panelRoleInfo[i].btnYazhu:removeMEListener(TFWIDGET_CLICK)
        self.panelRoleInfo[i].roleHead:removeMEListener(TFWIDGET_CLICK)
    end

    for i=1,#self.panelZhanbaoBtn do
        self.panelZhanbaoBtn[i]:removeMEListener(TFWIDGET_CLICK)
    end
    TFDirector:removeMEGlobalListener(WeekRaceManager.refreshWindow, self.refreshWindowCallBack)
    self.refreshWindowCallBack = nil
    TFDirector:removeMEGlobalListener(OtherPlayerManager.WeekRace, self.onOverView)
    self.onOverView = nil

    TFDirector:removeMEGlobalListener(ZhengbaManager.BETRATE, self.updataBetRate)
    self.updataBetRate = nil 

    TFDirector:removeMEGlobalListener(ZhengbaManager.OPENBOXSUCESS, self.openBoxSucess)
    self.openBoxSucess = nil

    if self.countDownTimer then
        TFDirector:removeTimer(self.countDownTimer)
        self.countDownTimer = nil
    end
    self.super.removeEvents(self)
end

function WeekRaceHomeLayer:dispose()
	self.super.dispose(self)
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
end

function WeekRaceHomeLayer:refreshWindow()
    self.currRound = WeekRaceManager:getCurrRound()
    if (not self.currRound) then
        toastMessage(localizable.Error_Time_Tips)
        return
    end
    print("currRound = ",self.currRound)
    self.currTimeState = WeekRaceManager:getCurrTimeState(self.currRound)
    if self.currTimeState == 10086 then
        if self.currRound <= 1 then
            -- toastMessage("比赛尚未开始")
            toastMessage(localizable.weekrace_race_no_start)
            
        else
            self.currRound = self.currRound - 1
            self.currTimeState = WeekRaceManager:getCurrTimeState(self.currRound)
        end
    end
    --生成定时器
    
    if self.countDownTimer then
        TFDirector:removeTimer(self.countDownTimer)
        self.countDownTimer = nil
    end

    self.countDown = WeekRaceManager:getCutDownByState( self.currRound, self.currTimeState )
    --延迟5秒
    self.countDown = self.countDown + 10
    if (not timeFont[self.currRound]) then
        local tips = self.currRound or ""
        toastMessage("not currRound "..tips)
        return
    end
    local timeTips = timeFont[self.currRound][self.currTimeState]
    if timeTips ~= nil then
        self.CountDownBg[self.currRound]:setVisible(true)
    else
        timeTips = ''
        self.CountDownBg[self.currRound]:setVisible(false)
    end

    if self.currTimeState == 1 then
        --押注剩余时间
        -- self.CountDownBg[self.currRound]:setVisible(true)
        local timeStr = FactionManager:getTimeString( self.countDown )
        self.CountDownTime[self.currRound]:setText(timeTips..timeStr)

        self.countDownTimer = TFDirector:addTimer(1000, -1, nil, function () 
                if self.countDown <= 0 then
                    if self.countDownTimer then
                        TFDirector:removeTimer(self.countDownTimer)
                        self.countDownTimer = nil
                    end
                    local timeStr = FactionManager:getTimeString( self.countDown )
                    self.CountDownTime[self.currRound]:setText(timeTips..timeStr)
                    WeekRaceManager:requestRaceInfo(false)
                else
                    self.countDown = self.countDown - 1
                    local timeStr = FactionManager:getTimeString( self.countDown )
                    self.CountDownTime[self.currRound]:setText(timeTips..timeStr)
                end
            end)
    elseif self.currTimeState == 2 then
        --战斗剩余时间
        local timeStr = FactionManager:getTimeString( self.countDown )
        self.CountDownTime[self.currRound]:setText(timeTips..timeStr)

        self.countDownTimer = TFDirector:addTimer(1000, -1, nil, function () 
                if self.countDown <= 0 then
                    if self.countDownTimer then
                        TFDirector:removeTimer(self.countDownTimer)
                        self.countDownTimer = nil
                    end
                    local timeStr = FactionManager:getTimeString( self.countDown )
                    self.CountDownTime[self.currRound]:setText(timeTips..timeStr)                    
                    WeekRaceManager:requestRaceInfo(false)
                else
                    self.countDown = self.countDown - 1
                    local timeStr = FactionManager:getTimeString( self.countDown )
                    self.CountDownTime[self.currRound]:setText(timeTips..timeStr)
                end
            end)
    elseif self.currTimeState == 3 then
        --战报剩余时间
        local timeStr = FactionManager:getTimeString( self.countDown )
        self.CountDownTime[self.currRound]:setText(timeTips..timeStr)

        self.countDownTimer = TFDirector:addTimer(1000, -1, nil, function () 
                if self.countDown <= 0 then
                    if self.countDownTimer then
                        TFDirector:removeTimer(self.countDownTimer)
                        self.countDownTimer = nil
                    end
                    local timeStr = FactionManager:getTimeString( self.countDown )
                    self.CountDownTime[self.currRound]:setText(timeTips..timeStr)
                    WeekRaceManager:requestRaceInfo(false)
                else
                    self.countDown = self.countDown - 1
                    local timeStr = FactionManager:getTimeString( self.countDown )
                    self.CountDownTime[self.currRound]:setText(timeTips..timeStr)
                end
            end)
    end
    self:showByRound(self.currRound)
end

function WeekRaceHomeLayer.btnRuleClick( btn )  
    -- local layer = require("lua.logic.weekrace.WeekRaceRuleLayer"):new()

    -- AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY)
    -- AlertManager:show()  
    CommonManager:showRuleLyaer('zhengbasaibaqiang')
end

function WeekRaceHomeLayer.btnRewardClick( btn )	
    local layer = require("lua.logic.weekrace.WeekRaceRewardLayer"):new()
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY)
    AlertManager:show()
end

function WeekRaceHomeLayer.btnBuffClick( btn )
    local num = btn.addNum or 0
    PeakManager:openBuffLayer0(num)
end

function WeekRaceHomeLayer.btnBattlefieldClick( btn )
    --WeekRaceRecordLayer
    local layer = require("lua.logic.weekrace.WeekRaceRecordLayer"):new()
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY)
    AlertManager:show()
end

function WeekRaceHomeLayer.btnBuzhenClick( btn )
    ZhengbaManager:openArmyLayer(EnumFightStrategyType.StrategyType_CHAMPIONS_ATK)
end
function WeekRaceHomeLayer.OpenBoxClick( btn )
    --3 是本服武林押注
    ZhengbaManager:openBox(3)       
end
function WeekRaceHomeLayer.btnRateClick( btn )
    ZhengbaManager:BetRateInfo(btn.msgRound, btn.msgIndex, btn.msgPlayerId)
    msgRound = btn.msgRound
    msgIndex = btn.msgIndex
    msgPlayerId = btn.msgPlayerId
end
function WeekRaceHomeLayer:btnYaZhuClick(betRadio)
    local layer = require("lua.logic.weekrace.ZhenbashaiBets"):new()
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY)
    layer:setData(msgRound, msgIndex, msgPlayerId, betRadio)
    AlertManager:show()
end

function WeekRaceHomeLayer.panelBtnZhanbaoClick( btn )
    -- print("replayId = ",btn.replayId)
end
function WeekRaceHomeLayer:showByRound( round )

    for i=1,#self.panelNode do
        if i == round then
            self.progressInfo[i].node:setTexture('ui_new/Zhenbashai/img_yuandian2.png')
            self.panelNode[i]:setVisible(true)
        else
            self.progressInfo[i].node:setTexture('ui_new/Zhenbashai/img_yuandian1.png')
            self.panelNode[i]:setVisible(false)
        end
        self.progressInfo[i].time:setText(WeekRaceManager:getStartTimeStrByRound(i))
    end

    local roundInfo = WeekRaceManager:getRaceInfoByRound( round )
    print("roundInfo = ",roundInfo)
    for i=1,NodeMax[round] do
        local info = nil
        for k,v in pairs(roundInfo) do
            if v.index == i then
                info = v
            end
        end
        local idx = i

        if round == 1 then
            idx = NodeChange[i]  
        else      
            for j=1,round-1 do
                idx = idx + NodeMax[j]
            end
        end
        self:addNodeData( idx, info )
    end

    self.btnBuzhen:setVisible(false)
    if self.currTimeState == 1 and WeekRaceManager:isJoin(round) then
        self.btnBuzhen:setVisible(true)
    end

    self.gameOver.roleNode:setVisible(false)
    if round == 3 and self.currTimeState == 3 then

        local info = roundInfo[1]
        if info and (info.winPlayerId and info.winPlayerId ~= 0) then
            if self.playAudio then
                self.playAudio = false
                TFAudio.playEffect("sound/effect/shili_bailizhaomu.mp3",false)
            end
            self.gameOver.roleNode:setVisible(true)
            if info.atkPlayerId == info.winPlayerId then
                if info.atkIcon == nil or info.atkIcon <= 0 then                    --pck change head icon and head icon frame
                    info.atkIcon = info.atkProfession
                end     
                local RoleIcon = RoleData:objectByID(info.atkIcon)
                self.gameOver.roleHead:setTexture(RoleIcon:getIconPath())
                Public:addFrameImg(self.gameOver.roleHead,info.atkHeadPicFrame)    --end
                Public:addInfoListen(self.gameOver.roleHead,true,1,info.atkPlayerId)
                self.gameOver.roleName:setText(info.atkPlayerName)
                self.gameOver.rolePower:setText(info.atkPower)
                self.gameOver.roleHead.playerId = info.atkPlayerId
            else
                if info.defIcon == nil or info.defIcon <= 0 then                    --pck change head icon and head icon frame
                    info.defIcon = info.defProfession
                end
                local RoleIcon = RoleData:objectByID(info.defIcon)
                self.gameOver.roleHead:setTexture(RoleIcon:getIconPath())
                Public:addFrameImg(self.gameOver.roleHead,info.defHeadPicFrame)    --end
                Public:addInfoListen(self.gameOver.roleHead,true,1,info.defPlayerId)
                self.gameOver.roleName:setText(info.defPlayerName)
                self.gameOver.rolePower:setText(info.defPower)
                self.gameOver.roleHead.playerId = info.defPlayerId
            end
            if self.panelRoleInfo then
                for k,v in pairs(self.panelRoleInfo) do
                    v.roleHead:setTouchEnabled(false)
                end
            end
        end
    end
end

function WeekRaceHomeLayer:addNodeData( idx, info )
    
    local atkIdx = idx*2 - 1
    local defIdx = idx*2

    self.panelRoleInfo[atkIdx].roleName:setVisible(false)
    self.panelRoleInfo[atkIdx].roleHead:setVisible(false)
    self.panelRoleInfo[atkIdx].iconYiya:setVisible(false)
    self.panelRoleInfo[atkIdx].btnYazhu:setVisible(false)
    self.panelRoleInfo[atkIdx].iconLose:setVisible(false)
    self.panelRoleInfo[atkIdx].iconWin:setVisible(false)
    self.panelRoleInfo[atkIdx].panel_buff:setVisible(false)

    self.panelRoleInfo[defIdx].roleName:setVisible(false)
    self.panelRoleInfo[defIdx].roleHead:setVisible(false) 
    self.panelRoleInfo[defIdx].iconYiya:setVisible(false)
    self.panelRoleInfo[defIdx].btnYazhu:setVisible(false)
    self.panelRoleInfo[defIdx].iconLose:setVisible(false)
    self.panelRoleInfo[defIdx].iconWin:setVisible(false)
    self.panelRoleInfo[defIdx].panel_buff:setVisible(false)

    
    if self.currTimeState == 2 then
        self.AnimEffect[idx]:setVisible(true)
    else
        self.AnimEffect[idx]:setVisible(false)
    end

    print('info = ',info)
    print('self.currTimeState = ',self.currTimeState)
    print('atkIdx = ',atkIdx)
    print('defIdx = ',defIdx)
    if info then
        self.panelRoleInfo[atkIdx].roleName:setVisible(true)
        self.panelRoleInfo[atkIdx].roleHead:setVisible(true)        
        self.panelRoleInfo[atkIdx].roleHead.playerId = info.atkPlayerId
        self.panelRoleInfo[atkIdx].roleName:setText(info.atkPlayerName)
        if info.atkPeakAddition and info.atkPeakAddition > 0 then
            self.panelRoleInfo[atkIdx].panel_buff:setVisible(false) -- pck tag 2017.2.15
            self.panelRoleInfo[atkIdx].btn_buff.addNum = info.atkPeakAddition
            self.panelRoleInfo[atkIdx].txt_buff:setText(info.atkPeakAddition * 0.01 ..'%')
        end
        if info.atkIcon == nil or info.atkIcon <= 0 then                    --pck change head icon and head icon frame
            info.atkIcon = info.atkProfession
        end
        local RoleIcon = RoleData:objectByID(info.atkIcon)
        self.panelRoleInfo[atkIdx].roleHead:setTexture(RoleIcon:getIconPath())
        Public:addFrameImg(self.panelRoleInfo[atkIdx].roleHead,info.atkHeadPicFrame)    --end
        Public:addInfoListen(self.panelRoleInfo[atkIdx].roleHead,true,1,info.atkPlayerId)
        if info.defPlayerId then
            self.panelRoleInfo[defIdx].roleName:setVisible(true)
            self.panelRoleInfo[defIdx].roleHead:setVisible(true)        
            self.panelRoleInfo[defIdx].roleHead.playerId = info.defPlayerId
            self.panelRoleInfo[defIdx].roleName:setText(info.defPlayerName)
            if info.defPeakAddition and info.defPeakAddition > 0 then
                self.panelRoleInfo[defIdx].panel_buff:setVisible(false) -- pck tag 2017.2.15
                self.panelRoleInfo[defIdx].btn_buff.addNum = info.defPeakAddition
                self.panelRoleInfo[defIdx].txt_buff:setText(info.defPeakAddition * 0.01 ..'%')
            end
            if info.defIcon == nil or info.defIcon <= 0 then                --pck change head icon and head icon frame
                info.defIcon = info.defProfession
            end
            RoleIcon = RoleData:objectByID(info.defIcon)
            self.panelRoleInfo[defIdx].roleHead:setTexture(RoleIcon:getIconPath())   
            Public:addFrameImg(self.panelRoleInfo[defIdx].roleHead,info.defHeadPicFrame)    --end 
            Public:addInfoListen(self.panelRoleInfo[defIdx].roleHead,true,1,info.defPlayerId)
        end

        --处理押注标签
        if info.betPlayerId and info.betPlayerId ~= 0 then
            if info.betPlayerId == info.atkPlayerId then
                self.panelRoleInfo[atkIdx].iconYiya:setVisible(true)
            elseif info.betPlayerId == info.defPlayerId then
                self.panelRoleInfo[defIdx].iconYiya:setVisible(true)
            end
        end      

        if self.currTimeState == 1 then
            --押注时间
            --if info.defPlayerId ~= nil and (WeekRaceManager:checkEnableYazhu( self.currRound ))then
            if info.defPlayerId ~= nil and info.betPlayerId == nil then
                self.panelRoleInfo[atkIdx].btnYazhu:setVisible(true)
                self.panelRoleInfo[atkIdx].btnYazhu.msgRound = info.round
                self.panelRoleInfo[atkIdx].btnYazhu.msgIndex = info.index
                self.panelRoleInfo[atkIdx].btnYazhu.msgPlayerId = info.atkPlayerId

                self.panelRoleInfo[defIdx].btnYazhu:setVisible(true)            
                self.panelRoleInfo[defIdx].btnYazhu.msgRound = info.round
                self.panelRoleInfo[defIdx].btnYazhu.msgIndex = info.index
                self.panelRoleInfo[defIdx].btnYazhu.msgPlayerId = info.defPlayerId
            end     
        elseif self.currTimeState == 2 then
            --战斗时间
            -- self.AnimEffect[idx]:setVisible(true)
            
        elseif self.currTimeState == 3 then
            --战报时间
            --处理获胜图标
            if info.winPlayerId and info.winPlayerId ~= 0 then
                if info.winPlayerId == info.atkPlayerId then
                    self.panelRoleInfo[atkIdx].iconWin:setVisible(true)
                    if info.defPlayerId ~= nil then
                        self.panelRoleInfo[defIdx].iconLose:setVisible(true)
                    end
                else
                    self.panelRoleInfo[atkIdx].iconLose:setVisible(true)
                    self.panelRoleInfo[defIdx].iconWin:setVisible(true)
                end
                
            end            
        end
    end
end

function WeekRaceHomeLayer:freshBoxInfo()
    --3   是本服押注
    local boxes_id = ZhengbaManager.boxes[3] or 0
    local boxInfo = ChampionsBoxData:objectByID(3*1000 + boxes_id)
    self:addBoxEffect(self.img_baoxiang,false)
    if boxInfo == nil then
        -- txt_mubiao:setText("已领取完毕")
        self.txt_mubiao:setText(localizable.zhengba_ZhengbaLayer_no_prize)     
    else
        self.txt_mubiao:setText(stringUtils.format(localizable.ZhengbaManager_Yazhu, boxInfo.value))
        if ZhengbaManager.championsInfo and ZhengbaManager.championsInfo.betWinCount >= boxInfo.value then
            self:addBoxEffect(self.img_baoxiang,true)
        end
    end   
    self.txt_mubiao:setScale(0.8) 
end

function WeekRaceHomeLayer:addBoxEffect(widget,visible)
    local widget_effect = widget:getChildByTag(100)
    if widget == nil and visible == false then
        return
    end
    if widget_effect == nil then
        local resPath = "effect/smallBox.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("smallBox_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(23, 13))
        widget:addChild(effect)
        effect:setTag(100)
        effect:playByIndex(0, -1, -1, 1)
        widget_effect = effect
    end
    widget_effect:setVisible(visible)
end

function WeekRaceHomeLayer.btnHeadClick( btn )
    print('btn.playerId = ',btn.playerId)
    if btn.playerId and btn.playerId > 0 then
        OtherPlayerManager:showOtherPlayerdetailsForWeekRace(btn.playerId, "weekrace")
    end
end

return WeekRaceHomeLayer