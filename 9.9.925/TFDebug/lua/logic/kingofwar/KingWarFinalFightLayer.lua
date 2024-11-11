
-- client side KingWarFinalFightLayer.lua
--[[
 * @Description: 王者争霸-擂主赛
 ]]
-- script writer Happy.All
-- creation time 2016-10-31 14:45:19
local KingWarFinalFightLayer = class("KingWarFinalFightLayer",BaseLayer)

local RANK_NUM = 8

function KingWarFinalFightLayer:ctor(data)
	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.crossarena.CrossArena2to1")
end

function KingWarFinalFightLayer:initUI( ui )

	self.super.initUI(self, ui)

    self.generalHead = CommonManager:addGeneralHead(self)
    self.generalHead:setData(ModuleType.KFKingWar,{HeadResType.SYCEE})

    -- local bg = TFDirector:getChildByPath(ui, 'bg')
    -- TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/zhengbasai_jifen_bg.xml")
    -- local effect = TFArmature:create("zhengbasai_jifen_bg_anim")
    -- effect:setPosition(ccp(568,320))
    -- bg:addChild(effect,100)
    -- effect:playByIndex(0,-1,-1,1)

    self.img_vsbig = TFDirector:getChildByPath(ui, "img_vsbig")
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/weekFight.xml")
    local effect = TFArmature:create("weekFight_anim") 
    effect:setPosition(ccp(80, 150))
    effect:setScale(0.8)
    effect:playByIndex(0, -1, -1, 1)
    effect:setZOrder(100)
    self.img_vsbig:addChild(effect) 
    self.fightEffect = effect
    effect:setVisible(false)

    self.img_paiming = TFDirector:getChildByPath(ui, "img_paiming")
    self.txtTimeStrTipDown = TFDirector:getChildByPath(self.img_paiming, "txt_time1")
    self.txtTimStrDown = TFDirector:getChildByPath(self.img_paiming, "txt_num1")
    --积分赛剩余时间
    self.teamInfoNode = TFDirector:getChildByPath(ui, 'bg_yazhushijian')
    self.txtTimeStrTip = TFDirector:getChildByPath(self.teamInfoNode, 'txt_time')
    self.txtTimStr = TFDirector:getChildByPath(self.teamInfoNode, 'txt_num')

    local roleNode = TFDirector:getChildByPath(ui, "panel_1")
    
    self.btnFightDetail = TFDirector:getChildByPath(ui, "btn_xiang")

    local atkNode = TFDirector:getChildByPath(roleNode, "role1_bg")
    self.imgAtkHead = TFDirector:getChildByPath(atkNode, "icon_head")
    self.txtAtkName = TFDirector:getChildByPath(atkNode, "txt_name")
    self.imgAtkWin = TFDirector:getChildByPath(atkNode, "icon_sheng")
    self.imgAtkLose = TFDirector:getChildByPath(atkNode, "icon_fu")
    self.imgAtkBet = TFDirector:getChildByPath(atkNode, "icon_yiya")
    self.btnAtkBet = TFDirector:getChildByPath(atkNode, "btn_yazhu")
    self.txtAtkYgw = TFDirector:getChildByPath(atkNode, "txt_ygw")
    self.txtAtkYll = TFDirector:getChildByPath(atkNode, "txt_yll")
    self.atkInspirePanel = TFDirector:getChildByPath(atkNode, "panel_gw")
    self.atkBtnInspire = TFDirector:getChildByPath(atkNode, "btn_inspire2")
    self.atkImgLeizhu = TFDirector:getChildByPath(atkNode, "img_leizhu")
    self.imgAtkResultWin = {}
    self.imgAtkResultLose = {}
    for i=1,3 do
        local panel_dian1 = TFDirector:getChildByPath(atkNode, "panel_dian"..i)
        self.imgAtkResultWin[i] = TFDirector:getChildByPath(panel_dian1, "img_sheng")
        self.imgAtkResultLose[i] = TFDirector:getChildByPath(panel_dian1, "img_fu")
    end
    local defNode = TFDirector:getChildByPath(roleNode, "role2_bg")
    self.imgDefHead = TFDirector:getChildByPath(defNode, "icon_head")
    self.txtDefName = TFDirector:getChildByPath(defNode, "txt_name")
    self.imgDefWin = TFDirector:getChildByPath(defNode, "icon_sheng")
    self.imgDefLose = TFDirector:getChildByPath(defNode, "icon_fu")
    self.imgDefBet = TFDirector:getChildByPath(defNode, "icon_yiya")
    self.btnDefBet = TFDirector:getChildByPath(defNode, "btn_yazhu")
    self.txtDefYgw = TFDirector:getChildByPath(defNode, "txt_ygw")
    self.txtDefYll = TFDirector:getChildByPath(defNode, "txt_yll")
    self.defInspirePanel = TFDirector:getChildByPath(defNode, "panel_gw")
    self.defBtnInspire = TFDirector:getChildByPath(defNode, "btn_inspire2")
    self.defImgLeizhu = TFDirector:getChildByPath(defNode, "img_leizhu")
    self.imgDefResultWin = {}
    self.imgDefResultLose = {}
    for i=1,3 do
        local panel_dian1 = TFDirector:getChildByPath(defNode, "panel_dian"..i)
        self.imgDefResultWin[i] = TFDirector:getChildByPath(panel_dian1, "img_sheng")
        self.imgDefResultLose[i] = TFDirector:getChildByPath(panel_dian1, "img_fu")
    end

    self.rankNode = TFDirector:getChildByPath(ui, "Panel_Paihang")
    self.rankNodeInitX = self.rankNode:getPositionX()
    self.rankNodeMoveX = self.rankNodeInitX - 210
    --我的信息
    local txt_paiming = TFDirector:getChildByPath(self.rankNode, "txt_paiming")
    self.txtMyRank = TFDirector:getChildByPath(txt_paiming, 'txt_num')
    txt_jifen = TFDirector:getChildByPath(self.rankNode, 'txt_jifen')
    self.txtMyScore = TFDirector:getChildByPath(txt_jifen, 'txt_num')

    self.btnScore = TFDirector:getChildByPath(self.rankNode, "btn_jifen")

    --排行榜信息
    local scrollViewUi = TFDirector:getChildByPath(self.rankNode, 'panel_gun')
    self.ScrollView = TFScrollView:create()
    self.ScrollView:setPosition(ccp(0,0))
    self.ScrollView:setBackGroundColorType(TF_LAYOUT_COLOR_NONE)
    self.ScrollView:setSize(scrollViewUi:getSize())
    self.ScrollView:setBounceEnabled(true);
    scrollViewUi:addChild(self.ScrollView)
    Public:bindScrollFun(self.ScrollView);

    self.scrollCell = TFDirector:getChildByPath(self.rankNode, 'panel_rank')
    self.scrollCell:setVisible(false)
    self.ScrollView:setInnerContainerSize(CCSizeMake(250,80*RANK_NUM))
    self.scrollData = {}
    for i=1,RANK_NUM do
        local panelCell = self.scrollCell:clone()
        panelCell:setVisible(true)
        panelCell:setPosition(ccp(0,(RANK_NUM-i)*80))
        self.ScrollView:addChild(panelCell)
        self.scrollData[i] = {}        
        self.scrollData[i].txtRank = TFDirector:getChildByPath(panelCell, 'txt_xuhao')
        self.scrollData[i].txtRank:setText(i)
        self.scrollData[i].txtName = TFDirector:getChildByPath(panelCell, 'txt_name')
        self.scrollData[i].txtName:setVisible(false)
        self.scrollData[i].txtScore = TFDirector:getChildByPath(panelCell, 'txt_jifen')
        self.scrollData[i].txtScore:setVisible(false)
        self.scrollData[i].txtServer = TFDirector:getChildByPath(panelCell, 'txt_server')
        self.scrollData[i].txtServer:setVisible(false)
        local txt_num = TFDirector:getChildByPath(panelCell, 'txt_num')
        txt_num:setVisible(false)        
    end
    --ui 按钮
    self.btnRule = TFDirector:getChildByPath(ui, "btn_guizhe")
    self.btnBattlefield = TFDirector:getChildByPath(ui, "btn_zhanbao")
    self.btnBattlefield:setVisible(false)
    self.btnReward = TFDirector:getChildByPath(ui, "btn_jiangli")
    self.btnMyTeam = TFDirector:getChildByPath(ui, "btn_myteam")
    self.btnChat = TFDirector:getChildByPath(ui, "btn_teamchat")
    self.btnArmy = TFDirector:getChildByPath(ui, "btn_buzhen")

    self.PlayType = 0
    -- self.btnMyTeam:setPosition(self.btnBattlefield:getPosition())
end

function KingWarFinalFightLayer:removeUI()
	self.super.removeUI(self)
end

function KingWarFinalFightLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow()
    CommonManager:setRedPoint(self.btnChat, KingOfWarManager:getTeamChatRedState(),"btnChat",ccp(0,0))
end

function KingWarFinalFightLayer:registerEvents()

    if self.registerEventCallFlag then
        return
    end
	self.super.registerEvents(self)

    if self.generalHead then
        self.generalHead:registerEvents()
    end
    KingOfWarManager:requestFinalFightInfo()

    self.UpdateActivityStateCallback = function ( event )
        KingOfWarManager:requestFinalFightInfo()
    end
    TFDirector:addMEGlobalListener(KingOfWarManager.UpdateActivityState, self.UpdateActivityStateCallback)

    self.UpdateFightDataCallBack = function (event)
        self.playerInfo = KingOfWarManager:getFinalFightPlayerInfo()
        self:showMyInfo()
        self:showRankInfo()
        self:showFightInfo()  
        self:showCutDownTimer()              
    end
    TFDirector:addMEGlobalListener(KingOfWarManager.UpdateFinalFightMsg, self.UpdateFightDataCallBack)
    TFDirector:addMEGlobalListener(KingOfWarManager.UpdateBetMsg, self.UpdateFightDataCallBack)
    TFDirector:addMEGlobalListener(KingOfWarManager.UpdateResultMsg, self.UpdateFightDataCallBack)

    self.updateRedPoint = function ( event )
        CommonManager:setRedPoint(self.btnChat, KingOfWarManager:getTeamChatRedState(),"btnChat",ccp(0,0))
    end
    TFDirector:addMEGlobalListener(KingOfWarManager.UpdateInvitationMsg, self.updateRedPoint)
    TFDirector:addMEGlobalListener(KingOfWarManager.UpdateNewChatMsg, self.updateRedPoint)

    self.updataBetRate = function(event)
        if self.playType == 0 then 
            self:onbtnAtkBetClick(event.data[1].betRadio)
        else
            self:onbtnDefBetClick(event.data[1].betRadio)
        end
    end
    TFDirector:addMEGlobalListener(KingOfWarManager.BETRATE, self.updataBetRate)



    self.btnArmy:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnAtkArmyClick))
    self.btnArmy.logic = self
    self.btnRule:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnRuleClick))
    self.btnRule.logic = self
    self.btnFightDetail:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnFightDetailClick))
    self.btnFightDetail.logic = self
    self.btnAtkBet:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnAtkRateClick))
    self.btnAtkBet.logic = self
    self.btnDefBet:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnDefRateClick))
    self.btnDefBet.logic = self
    self.btnMyTeam:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnMyTeamClick))
    self.btnMyTeam.logic = self
    self.btnChat:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnChatClick))
    self.btnChat.logic = self
    self.btnReward:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnRewardClick))
    self.btnReward.logic = self
    self.btnScore:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnScoreClick))
    self.btnScore.logic = self

    self.defBtnInspire:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnDefInspireClick))
    self.defBtnInspire.logic = self
    self.atkBtnInspire:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnAtkInspireClick))
    self.atkBtnInspire.logic = self
    self.registerEventCallFlag = true 
end

function KingWarFinalFightLayer:removeEvents()

    self.super.removeEvents(self)

	if self.generalHead then
        self.generalHead:removeEvents()
    end	

    if self.countDownTimer then
        TFDirector:removeTimer(self.countDownTimer)
        self.countDownTimer = nil
    end 

    if self.UpdateFightDataCallBack then
        TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateFinalFightMsg, self.UpdateFightDataCallBack)
        TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateBetMsg, self.UpdateFightDataCallBack)
        TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateResultMsg, self.UpdateFightDataCallBack)
        self.UpdateFightDataCallBack = nil
    end
    if self.updateRedPoint then
        TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateInvitationMsg, self.updateRedPoint)
        TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateNewChatMsg, self.updateRedPoint)
        self.updateRedPoint = nil
    end

    if self.UpdateActivityStateCallback then
        TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateActivityState, self.UpdateActivityStateCallback)
        self.UpdateActivityStateCallback = nil
    end
    self.registerEventCallFlag = nil  

    TFDirector:removeMEGlobalListener(KingOfWarManager.BETRATE, self.updataBetRate)
    self.updataBetRate = nil  
end

function KingWarFinalFightLayer:dispose()
	self.super.dispose(self)
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end    
end

function KingWarFinalFightLayer:showCutDownTimer()

    local countDown = KingOfWarManager:getBetCutDownTime()
    local state = KingOfWarManager:getActivityState()
    local currStr = localizable.KingWarBetTimeStr
    local needOffset = true
    local currStrNode = self.txtTimeStrTipDown
    local currNumNode = self.txtTimStrDown
    self.teamInfoNode:setVisible(false)
    self.img_paiming:setVisible(true)
    self.fightEffect:setVisible(false)
    if state == KingOfWarManager.ActivityState_Final then
        local canRet = true
        for i=1,3 do
            local retData,round = KingOfWarManager:getFinalFightDataByIndex(i)
            print("round = ",round)
            if retData and round == i and i ~= 3 then
                local isEnd,currFightIndex = KingOfWarManager:getStateByTeamIndex(i)  
                local atkResult = 0
                for k,v in pairs(retData) do
                    local isPlayed = KingOfWarManager:checkFightVideoPlayed(v.replayId)
                    if k == currFightIndex and isPlayed then
                        currFightIndex = currFightIndex + 1
                    end                           
                end
                countDown = KingOfWarManager:getFinalFightRoundCutDownTime(i)
                if (isEnd or currFightIndex > 3) and countDown > 0 then
                    
                    currStr = localizable.multiFight_CutDownTime32[i+1]
                    canRet = false
                    break
                end
            end
        end
        self.fightEffect:setVisible(true)
        if canRet then
            self.img_paiming:setVisible(false)
            return
        end
        
    elseif state == KingOfWarManager.ActivityState_Result then
        countDown = KingOfWarManager:getFinalViewEndCutDownTime()
        currStr = localizable.KingWarFightViewTime        
    elseif state == KingOfWarManager.ActivityState_Betting then
        currStr = localizable.KingWarBetTimeStr
        self.teamInfoNode:setVisible(true)
        self.img_paiming:setVisible(false)
        currStrNode = self.txtTimeStrTip
        currNumNode = self.txtTimStr
        needOffset = false
    end

    if self.countDownTimer then
        TFDirector:removeTimer(self.countDownTimer)
        self.countDownTimer = nil
    end
    local timeStr = KingOfWarManager:showTime( countDown )
    currStrNode:setText(currStr)
    if needOffset then
        currNumNode:setPositionX(currStrNode:getContentSize().width)   
    end
    currNumNode:setText(timeStr)
    if countDown <= 0 then
        return
    end
    self.countDownTimer = TFDirector:addTimer(1000, -1, nil, function ()

        if countDown <= 0 then
            if self.countDownTimer then
                TFDirector:removeTimer(self.countDownTimer)
                self.countDownTimer = nil
            end
            local timeStr = KingOfWarManager:showTime( countDown )
            currStrNode:setText(currStr) 
            if needOffset then
                currNumNode:setPositionX(currStrNode:getContentSize().width)   
            end
            currNumNode:setText(timeStr)
            self:showCutDownTimer()
        else
            countDown = countDown - 1
            local timeStr = KingOfWarManager:showTime( countDown )
            currStrNode:setText(currStr)
            if needOffset then
                currNumNode:setPositionX(currStrNode:getContentSize().width)
            end    
            currNumNode:setText(timeStr) 
        end
    end)
end

function KingWarFinalFightLayer:showMyInfo()

    --我的信息
    self.txtMyRank:setText(KingOfWarManager:getFinalFightMyRank())
    self.txtMyScore:setText(KingOfWarManager:getFinalFightMyScore())
    local state = KingOfWarManager:getActivityState()
    if state == KingOfWarManager.ActivityState_Betting then
        self.btnFightDetail:setVisible(false)
        if KingOfWarManager:checkIsInFinalFight() then
            --有队伍参加比赛
            local playerInfo = self.playerInfo[1]
            
            self.atkInspirePanel:setVisible(false)
            if playerInfo.atkIsMe then
                self.atkInspirePanel:setVisible(true)
            end
            self.defInspirePanel:setVisible(false)
            if playerInfo.defIsMe then
                self.defInspirePanel:setVisible(true)
            end
        else
            self.atkInspirePanel:setVisible(false)
            self.defInspirePanel:setVisible(false)
        end   
    else       
        self.atkInspirePanel:setVisible(false)
        self.defInspirePanel:setVisible(false)
        self.btnFightDetail:setVisible(true)
    end

    if KingOfWarManager:checkIsInFinalFight() then
        self.btnArmy:setVisible(true)
    else
        self.btnArmy:setVisible(false)
    end
end

function KingWarFinalFightLayer:showRankInfo()
    local rankDataInfo = KingOfWarManager:getFinalFightRankInfo()
    for i=1,RANK_NUM do
        local data = rankDataInfo[i]
        if data then
            self.scrollData[i].txtName:setText(data.name)
            self.scrollData[i].txtName:setVisible(true)
            self.scrollData[i].txtScore:setText(localizable.multiFight_score..data.integral)
            self.scrollData[i].txtScore:setVisible(true)
            self.scrollData[i].txtServer:setVisible(true)
            self.scrollData[i].txtServer:setText(data.serverName)
        else
            self.scrollData[i].txtName:setVisible(false)
            self.scrollData[i].txtScore:setVisible(false)
            self.scrollData[i].txtServer:setVisible(false)
        end
    end
end

function KingWarFinalFightLayer:showFightInfo()  
    self.imgAtkHead:setVisible(false)
    self.txtAtkName:setVisible(false)
    self.txtAtkYgw:setVisible(false)
    self.txtAtkYll:setVisible(false)
    
    self.imgDefHead:setVisible(false)
    self.txtDefName:setVisible(false)
    self.txtDefYgw:setVisible(false)

    self.imgAtkWin:setVisible(false)
    self.imgAtkLose:setVisible(false)
    self.imgDefWin:setVisible(false)
    self.imgDefLose:setVisible(false)

    self.imgAtkBet:setVisible(false)
    self.imgDefBet:setVisible(false)  

    self.btnAtkBet:setVisible(false)
    self.btnDefBet:setVisible(false)      
    for i=1,3 do
        self.imgAtkResultWin[i]:setVisible(false)
        self.imgAtkResultLose[i]:setVisible(false)
        self.imgDefResultWin[i]:setVisible(false)
        self.imgDefResultLose[i]:setVisible(false)
    end
    if KingOfWarManager:checkIsFirst() then
        self.atkImgLeizhu:setVisible(false)            
        self.defImgLeizhu:setVisible(false)            
    else
        self.atkImgLeizhu:setVisible(true)            
        self.defImgLeizhu:setVisible(true)            
    end
    self.currRound = 0
    if self.playerInfo == nil or self.playerInfo[1] == nil then  
        return
    end
    local playerInfo = self.playerInfo[1]
    
    local RoleIcon = RoleData:objectByID(playerInfo.atkUseIcon)
    self.imgAtkHead:setTexture(RoleIcon:getIconPath())
    self.imgAtkHead:setTouchEnabled(true)
    self.imgAtkHead:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onAtkHeadClick))
    self.imgAtkHead:setVisible(true)
    self.txtAtkName:setText(playerInfo.atkTeamName)
    self.txtAtkName:setVisible(true)
    self.txtAtkYgw:setText(stringUtils.format(localizable.KingWarInspireTips,playerInfo.atkInspireNum))
    self.txtAtkYgw:setVisible(true)
    if playerInfo.LeizhuCount == 0 then
        self.txtAtkYll:setVisible(false)
    else
        self.txtAtkYll:setText(stringUtils.format(localizable.KingWarLianLei,playerInfo.LeizhuCount))
        self.txtAtkYll:setVisible(true)
    end
    RoleIcon = RoleData:objectByID(playerInfo.defUseIcon)
    self.imgDefHead:setTexture(RoleIcon:getIconPath())
    self.imgDefHead:setVisible(true)
    self.imgDefHead:setTouchEnabled(true)
    self.imgDefHead:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onDefHeadClick))
    self.txtDefName:setText(playerInfo.defTeamName)
    self.txtDefName:setVisible(true)
    self.txtDefYgw:setText(stringUtils.format(localizable.KingWarInspireTips,playerInfo.defInspireNum))
    self.txtDefYgw:setVisible(true)

    local atkWinCount = 0
    local defWinCount = 0
    for i=1,3 do
        local result = self.playerInfo[i]
        if result and result.fightResult then
            if result.fightResult == 0 then                
                self.imgAtkResultWin[i]:setVisible(true)
                self.imgDefResultLose[i]:setVisible(true)
                atkWinCount = atkWinCount + 1
            else
                defWinCount = defWinCount + 1
                self.imgAtkResultLose[i]:setVisible(true)
                self.imgDefResultWin[i]:setVisible(true)
            end
        end
    end
    
    self.currRound = defWinCount + atkWinCount
    if (defWinCount + atkWinCount) >= 3 then
        if atkWinCount > defWinCount then
            self.imgAtkWin:setVisible(true)
            self.imgDefLose:setVisible(true)
        else
            self.txtAtkYll:setVisible(false)
            self.imgAtkLose:setVisible(true)
            self.imgDefWin:setVisible(true)
        end
    end

    local state = KingOfWarManager:getActivityState()
    if state == KingOfWarManager.ActivityState_Betting then
        self.txtAtkYgw:setVisible(false)
        self.txtDefYgw:setVisible(false)
    end

    if playerInfo.betWho == 0 then
        self.imgAtkBet:setVisible(true)
    elseif playerInfo.betWho == 1 then
        self.imgDefBet:setVisible(true)
    elseif state == KingOfWarManager.ActivityState_Betting then
        self.btnAtkBet:setVisible(true)
        self.btnDefBet:setVisible(true)        
    end
end

function KingWarFinalFightLayer.onBtnRuleClick( btn )
    KingOfWarManager:openRuleLayer()
end

function KingWarFinalFightLayer.onBtnAtkArmyClick( btn )
    KingOfWarManager:openAtkArmyLayer()
end

function KingWarFinalFightLayer.recordBtnClick( btn )
    local createTime = btn.createTime
    KingOfWarManager:openScoreFightDetailLayer(createTime)
end 

function KingWarFinalFightLayer.onBtnMyTeamClick( btn )
    KingOfWarManager:openMyTeamLayer()
end 

function KingWarFinalFightLayer.onBtnChatClick( btn )
    local self = btn.logic
    KingOfWarManager:setTeamChatRedState(false)
    self:onShow()
    KingOfWarManager:openChatLayer()
end 

function KingWarFinalFightLayer.onBtnRewardClick( btn )
    KingOfWarManager:openRewardLayer()
end 

function KingWarFinalFightLayer:setData()
    self.playerInfo = KingOfWarManager:getFinalFightPlayerInfo()
    self.btnScoreFlag = false
    self:showMyInfo()
    self:showRankInfo()
    self:showFightInfo()  
    self:showCutDownTimer()    
end

function KingWarFinalFightLayer.onBtnFightDetailClick(btn)
    local self = btn.logic
    -- print("self.currRound = ",self.currRound)
    KingOfWarManager:openFinalFightDetailLayer(self.currRound+1)
end

function KingWarFinalFightLayer.btnAtkRateClick(btn)
    local self = btn.logic
    self.playType = 0
    KingOfWarManager:BetRateInfo(0)
  
end
function KingWarFinalFightLayer.btnDefRateClick(btn)
    local self = btn.logic
    self.playType = 1
    KingOfWarManager:BetRateInfo(1)
  
end
function KingWarFinalFightLayer:onbtnAtkBetClick(betRadio)
    local layer = AlertManager:addLayerByFile("lua.logic.kingofwar.KingWarBetsLayer",AlertManager.BLOCK_AND_GRAY_CLOSE)
    layer:setData(0,betRadio)
    AlertManager:show()
end

function KingWarFinalFightLayer:onbtnDefBetClick(betRadio)
    local layer = AlertManager:addLayerByFile("lua.logic.kingofwar.KingWarBetsLayer",AlertManager.BLOCK_AND_GRAY_CLOSE)
    layer:setData(1,betRadio)
    AlertManager:show()
end

function KingWarFinalFightLayer.onBtnScoreClick(btn)
    local self = btn.logic
    
    local dis = self.rankNodeMoveX
    if self.btnScoreFlag == true then
        --打开动画
        dis = self.rankNodeInitX
    end

    local toastTween = {
        target = self.rankNode,
        {
            duration = 0.1,
            x = dis
        },
        {
            duration = 0,
            onComplete = function() 
                if self.btnScoreFlag == true then
                    self.btnScoreFlag = false
                else
                    self.btnScoreFlag = true
                end
            end
        }
    }
    TFDirector:toTween(toastTween);
end

function KingWarFinalFightLayer.onAtkHeadClick( btn )
    KingOfWarManager:openOtherTeamLayer("atk")
end

function KingWarFinalFightLayer.onDefHeadClick( btn )
    KingOfWarManager:openOtherTeamLayer("def")    
end

function KingWarFinalFightLayer.onBtnAtkInspireClick( btn )
    local layer = AlertManager:addLayerByFile("lua.logic.kingofwar.KingWarInspireLayer",AlertManager.BLOCK_AND_GRAY_CLOSE)
    AlertManager:show()
end

function KingWarFinalFightLayer.onBtnDefInspireClick( btn )
    local layer = AlertManager:addLayerByFile("lua.logic.kingofwar.KingWarInspireLayer",AlertManager.BLOCK_AND_GRAY_CLOSE)
    AlertManager:show()
end

return KingWarFinalFightLayer