--[[
******跨服个人战-淘汰赛第二轮*******

	-- by quanhuan
	-- 2016/2/22
	
]]

local KuaFuSecondRoundLayer = class("KuaFuSecondRoundLayer",BaseLayer)

local msgIndex = 0
local msgPlayerId = 0

PanelCount = {[2] = 4,[3] = 2,[4] = 1}
function KuaFuSecondRoundLayer:ctor(data)
	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.kuafuwulin.KuaFu_8qiang")
end

function KuaFuSecondRoundLayer:initUI( ui )

	self.super.initUI(self, ui)
    self.copyUi = ui
    self.generalHead = CommonManager:addGeneralHead(self)
    self.generalHead:setData(ModuleType.KFWLDH,{HeadResType.SYCEE})

    self.btn_guizhe = TFDirector:getChildByPath(ui, 'btn_help')
    self.btn_jiangli = TFDirector:getChildByPath(ui, 'btn_jiangli')
    self.btn_zhanbao = TFDirector:getChildByPath(ui, 'btn_zhanbao')

    self.btn_buzhen = TFDirector:getChildByPath(ui, "btn_buzhen")
    self.btn_buzhen:setVisible(true)
    
    local bg = TFDirector:getChildByPath(ui, 'bg')
    ViewSizeCheck(bg)
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/zhengbasai_jifen_bg.xml")
    local effect = TFArmature:create("zhengbasai_jifen_bg_anim")
    effect:setPosition(ccp(568,320))
    bg:addChild(effect,100)
    effect:playByIndex(0,-1,-1,1)

    self.Box = TFDirector:getChildByPath(ui,"btn_mubiao1")
    self.img_baoxiang = TFDirector:getChildByPath(self.Box, 'img_baoxiang')
    self.txt_mubiao = TFDirector:getChildByPath(self.Box, 'txt_mubiao')
end

function KuaFuSecondRoundLayer:reLoadUI()
    local ui = self.copyUi

    local Panel_shaichen = TFDirector:getChildByPath(ui, "Panel_shaichen")
    local panelName = {'Panel_8to4','Panel_4to2','Panel_2to1'}
    local dataNode
    for i=1,3 do
        local index = i+1
        local pointNode = TFDirector:getChildByPath(Panel_shaichen, 'y'..i)
        if index == self.currRound then
            dataNode = TFDirector:getChildByPath(ui, panelName[i])
            dataNode:setVisible(true)
            pointNode:setTexture('ui_new/Zhenbashai/img_yuandian2.png')
        else
            local otherNode = TFDirector:getChildByPath(ui, panelName[i])
            otherNode:setVisible(false)
            pointNode:setTexture('ui_new/Zhenbashai/img_yuandian1.png')
        end
    end

    self.playerData = {}    
    for i=1,self.currPanelCount do
        local playerNode = TFDirector:getChildByPath(dataNode, 'panel_'..i)
        self.playerData[i] = {}

        local atkNode = TFDirector:getChildByPath(playerNode, 'role1_bg')
        self.playerData[i].atkHeadIcon = TFDirector:getChildByPath(atkNode, 'icon_head')
        self.playerData[i].atkHeadFrame = TFDirector:getChildByPath(atkNode, 'img_di')
        self.playerData[i].atkWinIcon = TFDirector:getChildByPath(atkNode, 'icon_sheng')
        self.playerData[i].atkLoseIcon = TFDirector:getChildByPath(atkNode, 'icon_fu')
        self.playerData[i].atkYiYaImg = TFDirector:getChildByPath(atkNode, 'icon_yiya')
        self.playerData[i].atkName = TFDirector:getChildByPath(atkNode, 'txt_name')        
        self.playerData[i].atkBtnYazhu = TFDirector:getChildByPath(atkNode, 'btn_yazhu')
        self.playerData[i].panel_buff = TFDirector:getChildByPath(atkNode, 'panel_buff')
        self.playerData[i].panel_buff:setVisible(false)
        self.playerData[i].atkResultFlg = {}
        for flag=1,3 do
            local atkResultNode = TFDirector:getChildByPath(atkNode, "panel_dian"..flag)
            self.playerData[i].atkResultFlg[flag] = {}
            self.playerData[i].atkResultFlg[flag].imgWin = TFDirector:getChildByPath(atkResultNode, "img_sheng")
            self.playerData[i].atkResultFlg[flag].imgWin:setVisible(false)
            self.playerData[i].atkResultFlg[flag].imgLose = TFDirector:getChildByPath(atkResultNode, "img_fu")
            self.playerData[i].atkResultFlg[flag].imgLose:setVisible(false)
        end

        local defNode = TFDirector:getChildByPath(playerNode, 'role2_bg')
        self.playerData[i].defHeadIcon = TFDirector:getChildByPath(defNode, 'icon_head')
        self.playerData[i].defHeadFrame = TFDirector:getChildByPath(defNode, 'img_di')
        self.playerData[i].defWinIcon = TFDirector:getChildByPath(defNode, 'icon_sheng')
        self.playerData[i].defLoseIcon = TFDirector:getChildByPath(defNode, 'icon_fu')
        self.playerData[i].defYiYaImg = TFDirector:getChildByPath(defNode, 'icon_yiya')
        self.playerData[i].defName = TFDirector:getChildByPath(defNode, 'txt_name')        
        self.playerData[i].defBtnYazhu = TFDirector:getChildByPath(defNode, 'btn_yazhu')
        self.playerData[i].panel_buff = TFDirector:getChildByPath(defNode, 'panel_buff')
        self.playerData[i].panel_buff:setVisible(false)
        self.playerData[i].defResultFlg = {}
        for flag=1,3 do
            local defResultNode = TFDirector:getChildByPath(defNode, "panel_dian"..flag)
            self.playerData[i].defResultFlg[flag] = {}
            self.playerData[i].defResultFlg[flag].imgWin = TFDirector:getChildByPath(defResultNode, "img_sheng")
            self.playerData[i].defResultFlg[flag].imgWin:setVisible(false)
            self.playerData[i].defResultFlg[flag].imgLose = TFDirector:getChildByPath(defResultNode, "img_fu")
            self.playerData[i].defResultFlg[flag].imgLose:setVisible(false)
        end

        self.playerData[i].btnReport = TFDirector:getChildByPath(playerNode, 'btn_zhanbao1')
        self.playerData[i].effectNode = TFDirector:getChildByPath(dataNode, 'panelAnim'..i)

        TFResourceHelper:instance():addArmatureFromJsonFile("effect/weekFight.xml")
        local effect = TFArmature:create("weekFight_anim")
        effect:setPosition(ccp(0,0))
        effect:setScale(0.5)
        self.playerData[i].effectNode:addChild(effect,100)
        effect:playByIndex(0,-1,-1,1)
        self.playerData[i].effect = effect
        self.playerData[i].effect:setVisible(false)
    end

    self.tipsNode = TFDirector:getChildByPath(dataNode, 'bg_yazhushijian')
    self.txtTips = TFDirector:getChildByPath(self.tipsNode, 'txt_time')
    self.txtTime = TFDirector:getChildByPath(self.tipsNode, 'txt_num')


    local Panel_Content = TFDirector:getChildByPath(ui, "Panel_Content")
    local img_title = TFDirector:getChildByPath(Panel_Content, "img_title")
    local img_title2 = TFDirector:getChildByPath(Panel_Content, "img_title2")

    if self.currRound == 2 then
        img_title:setVisible(true)
        img_title2:setVisible(false)
    else
        img_title:setVisible(false)
        img_title2:setVisible(true)
    end


end
function KuaFuSecondRoundLayer:removeUI()
	self.super.removeUI(self)
end

function KuaFuSecondRoundLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow()
end

function KuaFuSecondRoundLayer:registerEvents()

    if self.registerEventCallFlag then
        return
    end
	self.super.registerEvents(self)

    if self.generalHead then
        self.generalHead:registerEvents()
    end

    self.CrossBetUpdateCallBack = function (event)
        self:showCutDownTimer()
    end
    TFDirector:addMEGlobalListener(MultiServerFightManager.CrossBetUpdate, self.CrossBetUpdateCallBack)

    self.updataBetRate = function(event)
        self:BtnYazhuClick(event.data[1].betRadio)
    end
    TFDirector:addMEGlobalListener(MultiServerFightManager.BETRATE, self.updataBetRate)

    self.btn_guizhe:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnRuleClick))
    self.btn_jiangli:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnRewardClick))
    self.btn_zhanbao:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnReportClick))
    self.btn_zhanbao.logic = self

    self.btn_buzhen:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnBuzhenClick))
    self.registerEventCallFlag = true 

    self.Box:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OpenBoxClick))
    self.Box.logic = self

    self.UpdataBoxInfo = function(event)
        self:freshBoxInfo()
    end

    TFDirector:addMEGlobalListener(MultiServerFightManager.REPONSEBetWinCount,self.UpdataBoxInfo)

    -- self.UpdataBoxInfo1 = function(event)
    --     self:freshBoxInfo()
    -- end

    -- TFDirector:addMEGlobalListener(ZhengbaManager.OPENBOXKUAFUSUCESS,self.UpdataBoxInfo1)

end

function KuaFuSecondRoundLayer:removeEvents()

    self.super.removeEvents(self)

	if self.generalHead then
        self.generalHead:removeEvents()
    end	

    if self.countDownTimer then
        TFDirector:removeTimer(self.countDownTimer)
        self.countDownTimer = nil
    end

    self.btn_guizhe:removeMEListener(TFWIDGET_CLICK)
    self.btn_jiangli:removeMEListener(TFWIDGET_CLICK)
    self.btn_zhanbao:removeMEListener(TFWIDGET_CLICK)

    if self.CrossBetUpdateCallBack then
        TFDirector:removeMEGlobalListener(MultiServerFightManager.CrossBetUpdate, self.CrossBetUpdateCallBack)  
        self.CrossBetUpdateCallBack = nil
    end

    TFDirector:removeMEGlobalListener(MultiServerFightManager.BETRATE, self.updataBetRate)
    self.updataBetRate = nil 

    TFDirector:removeMEGlobalListener(MultiServerFightManager.REPONSEBetWinCount,self.UpdataBoxInfo)
    self.UpdataBoxInfo = nil 
    -- TFDirector:removeMEGlobalListener(ZhengbaManager.OPENBOXKUAFUSUCESS,self.UpdataBoxInfo1)
    -- self.UpdataBoxInfo1 = nil

    self.registerEventCallFlag = nil  
end

function KuaFuSecondRoundLayer:dispose()
	self.super.dispose(self)
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end    
end

function KuaFuSecondRoundLayer:setData(data)
    -- print('data = ',data)
    self.currPanelCount = PanelCount[data]
    self.currRound = data
    self.currTimeState = data + 4
    self.reportRound = 0--self.currRound - 1
    self:reLoadUI()
    self:showCutDownTimer()
end

function KuaFuSecondRoundLayer:showFightDetailsInfo()

    local fightData = MultiServerFightManager:getFightDataByRound(self.currRound)

    -- print('fightData = ',fightData)
    for i=1,self.currPanelCount do
        local data = fightData[i]
        local playerNode = self.playerData[i]
        playerNode.atkHeadIcon:setVisible(false)
        playerNode.atkHeadIcon:setTouchEnabled(true)
        playerNode.atkHeadIcon.dataIndex = i
        playerNode.atkHeadIcon.logic = self
        playerNode.atkHeadIcon:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnAtkHeadClick))

        playerNode.atkWinIcon:setVisible(false)
        playerNode.atkLoseIcon:setVisible(false)
        playerNode.atkYiYaImg:setVisible(false)
        playerNode.atkName:setVisible(false)
        playerNode.atkBtnYazhu:setVisible(true)
        playerNode.atkBtnYazhu:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnRateClick))

        playerNode.defHeadIcon:setVisible(false)
        playerNode.defHeadIcon:setTouchEnabled(true)
        playerNode.defHeadIcon.dataIndex = i
        playerNode.defHeadIcon.logic = self
        playerNode.defHeadIcon:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnDefHeadClick))

        playerNode.defWinIcon:setVisible(false)
        playerNode.defLoseIcon:setVisible(false)
        playerNode.defYiYaImg:setVisible(false)
        playerNode.defName:setVisible(false)
        playerNode.defBtnYazhu:setVisible(true)
        playerNode.defBtnYazhu:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnRateClick))

        playerNode.btnReport:setVisible(false)
        playerNode.btnReport:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnReportClick))

        playerNode.effect:setVisible(false)

        if data then
            if data.atkPlayerId then
                playerNode.atkHeadIcon:setVisible(true)
                local RoleIcon = RoleData:objectByID(data.atkIcon)
                playerNode.atkHeadIcon:setTexture(RoleIcon:getIconPath())
                Public:addFrameImg(playerNode.atkHeadIcon,data.atkHeadPicFrame)
                -- Public:addInfoListen(playerNode.atkHeadIcon,true,1,data.atkPlayerId)
                playerNode.atkName:setVisible(true)
                playerNode.atkName:setText(data.atkPlayerName)
                playerNode.atkBtnYazhu.logic = self
                playerNode.atkBtnYazhu.playerId = data.atkPlayerId
                playerNode.atkBtnYazhu.index = data.index
            end

            if data.defPlayerId then
                playerNode.defHeadIcon:setVisible(true)
                local RoleIcon = RoleData:objectByID(data.defIcon)
                playerNode.defHeadIcon:setTexture(RoleIcon:getIconPath())
                Public:addFrameImg(playerNode.defHeadIcon,data.defHeadPicFrame)
                -- Public:addInfoListen(playerNode.defHeadIcon,true,1,data.defPlayerId)
                playerNode.defName:setVisible(true)
                playerNode.defName:setText(data.defPlayerName)
                playerNode.defBtnYazhu.logic = self
                playerNode.defBtnYazhu.playerId = data.defPlayerId
                playerNode.defBtnYazhu.index = data.index
            else
                playerNode.defBtnYazhu:setVisible(false)
                playerNode.atkBtnYazhu:setVisible(false)
            end

            if data.betPlayerId and data.betPlayerId ~= 0 then
                playerNode.defBtnYazhu:setVisible(false)
                playerNode.atkBtnYazhu:setVisible(false)
                if data.betPlayerId == data.atkPlayerId then
                    playerNode.atkYiYaImg:setVisible(true)
                elseif data.betPlayerId == data.defPlayerId then
                    playerNode.defYiYaImg:setVisible(true)
                end
            end

            if data.winPlayerId and data.winPlayerId ~= 0 then
                if data.winPlayerId == data.atkPlayerId then
                    playerNode.atkWinIcon:setVisible(true)
                    if data.defPlayerId ~= nil then
                        playerNode.defLoseIcon:setVisible(true)
                    end
                else
                    playerNode.atkLoseIcon:setVisible(true)
                    playerNode.defWinIcon:setVisible(true)
                end
            end            

            playerNode.btnReport.logic = self
            -- if (data.winPlayerId and data.winPlayerId ~= 0) and (data.defPlayerId and data.defPlayerId ~= 0) then
                
            -- end
            playerNode.btnReport:setVisible(true)
            local replayId = nil
            if data.replayId and #data.replayId >= 1 then
                replayId = data.replayId[#data.replayId]
            end
            playerNode.btnReport.replayId = replayId            

            playerNode.atkWinRound = data.atkWinRound
            playerNode.defWinRound = data.defWinRound
            for j=1,3 do
                local flag = bit_and(data.atkWinRound,math.pow(2,(j-1)))                
                if flag ~= 0 then
                    playerNode.atkResultFlg[j].imgWin:setVisible(true)
                    playerNode.atkResultFlg[j].imgLose:setVisible(false)
                else
                    playerNode.atkResultFlg[j].imgWin:setVisible(false)
                    playerNode.atkResultFlg[j].imgLose:setVisible(true)
                end
                   
                if data.defPlayerId and data.defPlayerId ~= 0 then
                    local flag = bit_and(data.defWinRound,math.pow(2,(j-1)))
                    if flag ~= 0 then
                        playerNode.defResultFlg[j].imgWin:setVisible(true)
                        playerNode.defResultFlg[j].imgLose:setVisible(false)
                    else
                        playerNode.defResultFlg[j].imgWin:setVisible(false)
                        playerNode.defResultFlg[j].imgLose:setVisible(true)
                    end
                end
            end
        else
            playerNode.defBtnYazhu:setVisible(false)
            playerNode.atkBtnYazhu:setVisible(false)
        end
    end
    --成就宝箱显示
    self:freshBoxInfo()
end
function KuaFuSecondRoundLayer:showCutDownTimer()
    if self.countDownTimer then
        TFDirector:removeTimer(self.countDownTimer)
        self.countDownTimer = nil
    end
    self:showFightDetailsInfo()
    local timeInfo = MultiServerFightManager:getFightTimeByState( self.currTimeState )
    local currTime = MultiServerFightManager:getCurrSecond()
    if currTime < timeInfo.fightTime then
        --押注时间
        for i=1,self.currPanelCount do
            local playerNode = self.playerData[i]            
            playerNode.atkWinIcon:setVisible(false)
            playerNode.atkLoseIcon:setVisible(false)
            playerNode.defWinIcon:setVisible(false)
            playerNode.defLoseIcon:setVisible(false)
            playerNode.btnReport:setVisible(false)
            for flag=1,3 do
                playerNode.atkResultFlg[flag].imgWin:setVisible(false)
                playerNode.atkResultFlg[flag].imgLose:setVisible(false)
                playerNode.defResultFlg[flag].imgWin:setVisible(false)
                playerNode.defResultFlg[flag].imgLose:setVisible(false)
            end 
        end
        self.tipsNode:setVisible(true)
        self.txtTips:setText(localizable.multiFight_yzsyTime)
        local countDown = timeInfo.fightTime - currTime
        self.txtTime:setText(FactionManager:getTimeString(countDown))
        self.countDownTimer = TFDirector:addTimer(1000, -1, nil, function ()
            -- print('countDown = ',countDown)
            if countDown <= 0 then
                if self.countDownTimer then
                    TFDirector:removeTimer(self.countDownTimer)
                    self.countDownTimer = nil
                end
                self:showCutDownTimer()
            else
                countDown = countDown - 1
                self.txtTime:setText(FactionManager:getTimeString(countDown))
            end
        end)
    elseif currTime < timeInfo.endTime then
        --战斗时间
        local currSence,currSenceState,senceEndTime,senceFightTime = MultiServerFightManager:getRoundAndStatus(timeInfo.fightTime, currTime)
        print("currSence = ",currSence)
        print("currSenceState = ",currSenceState)
        print("senceEndTime = ",senceEndTime)
        for i=1,self.currPanelCount do
            local playerNode = self.playerData[i]            
            playerNode.atkBtnYazhu:setVisible(false)
            playerNode.atkWinIcon:setVisible(false)
            playerNode.atkLoseIcon:setVisible(false)
            playerNode.defBtnYazhu:setVisible(false)
            playerNode.defWinIcon:setVisible(false)
            playerNode.defLoseIcon:setVisible(false)
            playerNode.btnReport:setVisible(false)
            playerNode.effect:setVisible(false)

            local startSence = currSence
            if currSenceState == 1 then
                --正在战斗
                playerNode.effect:setVisible(true)
                playerNode.effect:playByIndex(0,-1,-1,1)
            else
                startSence = startSence + 1
                print('playerNode.btnReport.replayId = ',playerNode.btnReport.replayId)
                if playerNode.btnReport.replayId and playerNode.btnReport.replayId ~= 0 then
                    playerNode.btnReport:setVisible(true)
                end
            end
            self.reportRound = startSence
            for flag=startSence,3 do
                playerNode.atkResultFlg[flag].imgWin:setVisible(false)
                playerNode.atkResultFlg[flag].imgLose:setVisible(false)
                playerNode.defResultFlg[flag].imgWin:setVisible(false)
                playerNode.defResultFlg[flag].imgLose:setVisible(false)
            end
        end

        self.tipsNode:setVisible(true)
        self.txtTips:setText(localizable.multiFight_fightTime32[currSence])
        local countDown = senceEndTime - currTime
        local countDownFignt = senceFightTime - currTime
        if countDownFignt < 0 then
            countDownFignt = nil
        end
        -- self.txtTime:setText(FactionManager:getTimeString(countDown))
        if countDownFignt then
            self.txtTime:setText(FactionManager:getTimeString(countDownFignt))
        else
            self.txtTime:setText(FactionManager:getTimeString(countDown))
        end

        if countDownFignt == nil then
            if currSence < 3 then
                self.txtTips:setText(localizable.multiFight_CutDownTime32[currSence+1])
            else
                self.tipsNode:setVisible(false)
            end
        else
            self.txtTips:setText(localizable.multiFight_fightTime32[currSence])
        end

        self.countDownTimer = TFDirector:addTimer(1000, -1, nil, function ()
            if countDown <= 0 then
                if self.countDownTimer then
                    TFDirector:removeTimer(self.countDownTimer)
                    self.countDownTimer = nil
                end
                self:showCutDownTimer()
            else
                countDown = countDown - 1
                if countDownFignt then
                    countDownFignt = countDownFignt - 1
                    if countDownFignt <= 0 then
                        MultiServerFightManager:requestCrossChampionInfosWar(self.currRound)
                        self:showCutDownTimer()
                    end
                end
                if countDownFignt then
                    self.txtTime:setText(FactionManager:getTimeString(countDownFignt))
                else
                    self.txtTime:setText(FactionManager:getTimeString(countDown))
                end
            end
        end)
    else--if currTime < timeInfo.nextFightTime then
        --战斗结果展示
        self.reportRound = 4--self.currRound
        for i=1,self.currPanelCount do
            local playerNode = self.playerData[i]
            playerNode.atkBtnYazhu:setVisible(false)
            playerNode.defBtnYazhu:setVisible(false)
        end
        self.tipsNode:setVisible(true)
        self.txtTips:setText(localizable.multiFight_viewTime)
        local countDown = timeInfo.nextFightTime - currTime
        if countDown <= 0 then
            countDown = 0
        end
        self.txtTime:setText(FactionManager:getTimeString(countDown))
        self.countDownTimer = TFDirector:addTimer(1000, -1, nil, function ()
            if countDown <= 0 then
                if self.countDownTimer then
                    TFDirector:removeTimer(self.countDownTimer)
                    self.countDownTimer = nil
                end
                -- self:showCutDownTimer()
                MultiServerFightManager:switchFightLayer()
            else
                countDown = countDown - 1
                self.txtTime:setText(FactionManager:getTimeString(countDown))
            end
        end)
    -- else
        --显示下一轮信息
        -- self.reportRound = self.currRound
        -- MultiServerFightManager:openCurrLayer()
    end
end

function KuaFuSecondRoundLayer.btnRuleClick( btn )
    MultiServerFightManager:openRuleLayer()
end

function KuaFuSecondRoundLayer.btnRewardClick( btn )
    MultiServerFightManager:openRewardLayer()
end

function KuaFuSecondRoundLayer.btnReportClick( btn )
    local self = btn.logic
    -- print('self.reportRound = ',self.reportRound)
    MultiServerFightManager:openReportLayer(self.currRound,self.reportRound)
end
function KuaFuSecondRoundLayer.OpenBoxClick( btn )
    --4 跨服武林押注
    ZhengbaManager.tempBoxIndex = 4
    MultiServerFightManager:openBox(4)   

end

function KuaFuSecondRoundLayer.btnRateClick( btn )
    local self = btn.logic
    MultiServerFightManager:BetRateInfo(self.currRound, btn.index, btn.playerId)
    msgIndex = btn.index
    msgPlayerId = btn.playerId
end

function KuaFuSecondRoundLayer:BtnYazhuClick( betRadio )
    local layer = AlertManager:addLayerByFile("lua.logic.multiServerFight.KuaFuBetsLayer",AlertManager.BLOCK_AND_GRAY_CLOSE)
    layer:setData(msgPlayerId, self.currRound, msgIndex,betRadio,betRadio)
    AlertManager:show()
end

function KuaFuSecondRoundLayer.onBtnReportClick( btn )
    MultiServerFightManager:onBtnReportClick( btn.replayId )
end

function KuaFuSecondRoundLayer.onBtnAtkHeadClick( btn )
    local index = btn.dataIndex
    local self = btn.logic
    local fightData = MultiServerFightManager:getFightDataByRound(self.currRound) or {}
    if fightData[index] and fightData[index].atkPlayerId then
        local data = {}
        data.playerName = fightData[index].atkPlayerName
        data.serverName = fightData[index].atkServerName
        data.power = fightData[index].atkPower
        data.headIcon = fightData[index].atkIcon
        data.headFrame = fightData[index].atkHeadPicFrame
        local layer = require("lua.logic.multiServerFight.KuaFuCheckLayer"):new()
        layer:setData(data)
        AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_NONE)
        AlertManager:show()
    end    
end

function KuaFuSecondRoundLayer.onBtnDefHeadClick( btn )
    local index = btn.dataIndex
    local self = btn.logic
    local fightData = MultiServerFightManager:getFightDataByRound(self.currRound) or {}
    if fightData[index] and fightData[index].defPlayerId then
        local data = {}
        data.playerName = fightData[index].defPlayerName
        data.serverName = fightData[index].defServerName
        data.power = fightData[index].defPower
        data.headIcon = fightData[index].defIcon
        data.headFrame = fightData[index].defHeadPicFrame
        local layer = require("lua.logic.multiServerFight.KuaFuCheckLayer"):new()
        layer:setData(data)
        AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_NONE)
        AlertManager:show()
    end    
end

function KuaFuSecondRoundLayer.btnBuzhenClick( btn )
    MultiServerFightManager:btnAtkClick()
end

function KuaFuSecondRoundLayer:freshBoxInfo()
    --4   是跨服押注
    local boxes_id = MultiServerFightManager.boxes or 0
    local boxInfo = ChampionsBoxData:objectByID(4*1000 + boxes_id)
    self:addBoxEffect(self.img_baoxiang,false)
    if boxInfo == nil then
        -- txt_mubiao:setText("已领取完毕")
        self.txt_mubiao:setText(localizable.zhengba_ZhengbaLayer_no_prize)     
    else
        self.txt_mubiao:setText(stringUtils.format(localizable.ZhengbaManager_Yazhu, boxInfo.value))
        if MultiServerFightManager.betWinCount >= boxInfo.value then
            self:addBoxEffect(self.img_baoxiang,true)
        end
    end
    self.txt_mubiao:setScale(0.8)    
end

function KuaFuSecondRoundLayer:addBoxEffect(widget,visible)
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
return KuaFuSecondRoundLayer