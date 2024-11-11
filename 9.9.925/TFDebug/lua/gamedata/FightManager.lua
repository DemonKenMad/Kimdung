--
-- Author: Zippo
-- Date: 2013-12-02 15:36:49
--

local fightRoundMgr  = require("lua.logic.fight.FightRoundManager")
local fightReplayMgr  = require("lua.logic.fight.FightReplayManager")
local fightRoleMgr  = require("lua.logic.fight.FightRoleManager")
local fightAI = require("lua.logic.fight.FightAI")

local battleRoundMgr  = require("lua.logic.battle.BattleRoleManager")
local battleReplayMgr  = require("lua.logic.battle.BattleReplayManager")
local FightManager = class("FightManager")

FightManager.FactionBossFightLeave = "FightManager.FactionBossFightLeave"
FightManager.LeaveFightCommand = "FightManager.LeaveFightCommand"
FightManager.FactionBossFightResult = "FightManager.FactionBossFightResult"
FightManager.FactionBossFightWin 	= "FightManager.FactionBossFightWin"
FightManager.LeaveFightForOneKey = "FightManager.LeaveFightForOneKey"
FightManager.LeaveFightForKingWar = "FightManager.LeaveFightForKingWar"
FightManager.StartSecondBattle = "FightManager.StartSecondBattle"
FightManager.ActionReportMax 	= 80
FightManager.savePrint 			= nil
FightManager.isClearFight 		= false
FightManager.bCheckBug = false
FightManager.MaxMen = 390
function FightManager:ctor()
	self.fightSpeed = 2
	self.isAutoFight = false
	self.maxRoundNum = 10
	self.nCurrRoundNum = 0
	self.manualActionNum = 0 		--主动攻击次数
	self.ispause = false
	self.isTiaoGuo = false
	self.bFighting = false			--越南报错标识
	self:Reset()
	self:RegisterEvents()
end

function FightManager:restart()
	if self.fightBeginInfo ~= nil and self.fightBeginInfo.bGuideFight then
		return
	end
	
	self.fightSpeed = 2
	if(GameConfig.HD) then
		self.fightSpeed = 1
	end
	self.isAutoFight = false

	self:Reset()
end

function FightManager:Reset()
	
	self.bWaitResultMsg = false
	self.isFighting = false
	self.isBattle = false
	self.fightBeginInfo = nil
	self.fightResultInfo = nil
	self.lastEndFightMsg = nil
	self.lastEndFightReport = nil
	self.nCurrRoundNum = 0
	self.manualActionNum = 0
	self.temp_flag = 0
	self.isCheckPoint1_6 = false 		--判断是不是关卡1-6,用于埋点
	if self.end_timerID then
		TFDirector:removeTimer(self.end_timerID)
		self.end_timerID = nil
	end
	if self.nextBattleTimerID then
		TFDirector:removeTimer(self.nextBattleTimerID)
		self.nextBattleTimerID = nil
	end
	if self.reportTimer then
		TFDirector:removeTimer(self.reportTimer)
		self.reportTimer = nil
	end
	self.maxRoundNum = 10
	DeviceAdpter.skipMemoryWarning = false
	self.isTiaoGuo = false
	self.callBackInterrupt = false
	self.battleCustomSkill = nil
	self.fightReportList = {}
	self.cacheSkillBaseInfo = {}
	self.sendResultState = false
	if self.sendResultTimer then
		TFDirector:removeTimer(self.sendResultTimer)
		self.sendResultTimer = nil
	end
	if (self.__debug_layerTimer) then
		TFDirector:removeTimer(self.__debug_layerTimer)
		self.__debug_layerTimer = nil
	end
	self.bFighting = false
end
function FightManager:GetCacheSkillBaseInfo(skillId)
	if (skillId == 0) then
		return 
	end
	local skillBaseInfo = self.cacheSkillBaseInfo[skillId]
	if (skillBaseInfo == nil) then
		skillBaseInfo = SkillBaseData:objectByID(skillId)
		self.cacheSkillBaseInfo[skillId] = skillBaseInfo
	end
	if (skillBaseInfo == nil) then
		print("Error*************skillId: ",skillId)
	end
	
	return skillBaseInfo
end

function FightManager:ClearSkillCache()
	self.cacheSkillBaseInfo = {}
end
function FightManager:RegisterEvents()
	TFDirector:addProto(s2c.FIGHT_BEGIN, self, self.FightBeginMsgHandle)
	TFDirector:addProto(s2c.FIGHT_RESULT, self, self.FightResultMsgHandle)
	TFDirector:addProto(s2c.TONG_REN_FIGHT_RESULT, self, self.FightResultMsgHandle)
	TFDirector:addProto(s2c.FIGHT_REPLAY, self, self.FightReplayMsgHandle)
	
	TFDirector:addProto(s2c.FIGHT_RERORT, self, self.FightReportMsgHandle)

	ErrorCodeManager:addProtocolListener(s2c.FIGHT_RESULT, function() self:FightErrorHandle() end)
	ErrorCodeManager:addProtocolListener(s2c.TONG_REN_FIGHT_RESULT,  function() self:FightErrorHandle() end)

	TFDirector:addProto(s2c.BATTLE_START, self, self.BattleStartMsg)
	TFDirector:addProto(s2c.ROUNDS_BATTLE, self, self.RoundsBattleMsg)
	TFDirector:addProto(s2c.BATTLE_REPLAY, self, self.BattleReplayMsg)
	TFDirector:addProto(s2c.BATTLE_RESULT, self, self.BattleResultMsgHandle)

	TFDirector:addProto(s2c.PLAY_REPLAY_ARENA_TOP_SUCCESS, self, self.FightArenaReplayMsgHandle)

	self.leaveFightCommandCallBack = function (event)
		-- local currentScene = Public:currentScene()
		-- if currentScene == nil or currentScene.__cname ~= "FightScene" then
		-- 	return
		-- end
		-- self:EndFight(false)
		-- -- self:LeaveFight()
		self.callBackInterrupt = true
	end
    TFDirector:addMEGlobalListener(FightManager.LeaveFightCommand, self.leaveFightCommandCallBack)

	TFDirector:addProto(s2c.BATTLE_CUSTOM_SKILL, self, self.BattleCustomSkillMsgHandle) -- 自定义技能顺序
end

function FightManager:BeginFight()
	
	self:initFightLog()
	
	self.isReplayFight = false
	fightRoundMgr.actionList:clear()
	self.manualActionNum = 0

	self.maxRoundNum = 10
	if self.fightBeginInfo.fighttype == 16 then
		local floorOptionNow = NorthClimbManager:getNowFloorOption()
		for i=1,2 do
			if floorOptionNow[i] then
				local battleInfo = BattleLimitedData:objectByID(floorOptionNow[i])
				if battleInfo and battleInfo.type == 2 then
					self.maxRoundNum = battleInfo.value
				end
			end
		end
	elseif self.fightBeginInfo.fighttype == 31 or self.fightBeginInfo.fighttype == 32 then
		--浪人武士
		print("浪人武士   fighttype  =   ", self.fightBeginInfo.fighttype)
		local knightLimitIds = {}
		if (self.fightBeginInfo.fighttype == 32) then
			local info = KnightManager:getFightKnightInfo()
			knightLimitIds = KnightManager:getKnightLimitIds(info.knightType, info.level)
		else
			knightLimitIds = KnightManager:getKnightLimitIds()
		end
		for i,limitId in pairs(knightLimitIds) do
			local battleInfo = BattleLimitedData:objectByID(tonumber(limitId))
 			if battleInfo and battleInfo.type == 2 then
				self.maxRoundNum = battleInfo.value
			end
		end
	elseif self.fightBeginInfo.fighttype == 10 and BossFightManager.isAllOut and BossFightManager.isAllOut >= 1 then
		self.maxRoundNum = 5
	end
	if self.fightBeginInfo.bGuideFight then
		AlertManager:changeScene(SceneType.FIGHT)
	else
		local currentScene = Public:currentScene()
	    if currentScene.__cname == "FightResultScene" or currentScene.__cname == "FightScene" then
			AlertManager:changeScene(SceneType.FIGHT)
	    else
			AlertManager:changeScene(SceneType.FIGHT, nil, TFSceneChangeType_PushBack)
	    end
	end
	self.isFighting = true

	DeviceAdpter.skipMemoryWarning = true
end

function FightManager:addManualActionNum()
	self.manualActionNum = self.manualActionNum + 1
end

function FightManager:ReplayFight(bRecordFight)
	if self.isFighting then
		return
	end
	self.isReplayFight = true
	if bRecordFight then
		local currentScene = Public:currentScene()
	    if currentScene.__cname == "FightResultScene" or currentScene.__cname == "FightScene" then
			AlertManager:changeScene(SceneType.FIGHT)
	    else
			AlertManager:changeScene(SceneType.FIGHT, nil, TFSceneChangeType_PushBack)
	    end
	else
		AlertManager:changeScene(SceneType.FIGHT)
	end
	
	self.isFighting = true

	DeviceAdpter.skipMemoryWarning = true
end

function FightManager:OnEnterFightScene()
	TFDeviceInfo:setOpenAccelerometer(false)
	if self.isBattle then
		battleReplayMgr:ExecuteAction(1)		
		return
	end
	if self.isReplayFight then
		fightReplayMgr:ExecuteAction(1)
	else
		fightRoundMgr:ExecuteFirstRound()
	end
end

function FightManager:EndReplayFight()
	if self.isFighting then
		self.isFighting = false

		DeviceAdpter.skipMemoryWarning = false

		if self.end_timerID then
			TFDirector:removeTimer(self.end_timerID)
			self.end_timerID = nil
		end
		self.end_timerID = TFDirector:addTimer(1000, 1, nil, 
		function() 
			TFDirector:removeTimer(self.end_timerID)
			self.end_timerID = nil
			AlertManager:changeScene(SceneType.FIGHTRESULT)
		end)
	end
end

function FightManager:BreakFight()
	self:EndFight(true)
end

function FightManager:SwitchAutoFight()
	self.isAutoFight = not self.isAutoFight
end
function FightManager:setAutoFight(bool)
	self.isAutoFight = bool
end

function FightManager:updateTimeOut()
	fightAI:Update(2000)
end

--
function FightManager:CleanFightAi()
	fightAI:dispose()
end

--
function FightManager:CleanFight()
	fightAI:dispose()
	fightRoundMgr:dispose()
	fightReplayMgr:dispose()
	fightRoleMgr:dispose()
	self.isTiaoGuo = false
end

function FightManager:OnReConnect()
	print("战斗断线重连成功")
	if self.lastEndFightMsg ~= nil and self.isFighting == false then
		self.bWaitResultMsg = true

		if self.lastEndFightReport and #self.lastEndFightReport > 0 and #self.lastEndFightMsg[3] == 0 then
			local index = 1
			self.reportTimer = TFDirector:addTimer(100,#self.lastEndFightReport+1,nil,function ()
				if index <= #self.lastEndFightReport then
					TFDirector:send(c2s.FIGHT_RERORT, self.lastEndFightReport[index])
				else
					TFDirector:send(c2s.FIGHT_END_REQUEST, self.lastEndFightMsg)
					if self.reportTimer then
						TFDirector:removeTimer(self.reportTimer)
						self.reportTimer = nil
					end
					self:setSendState();
				end
				index = index + 1;

			end)
		else
			TFDirector:send(c2s.FIGHT_END_REQUEST, self.lastEndFightMsg)
			self:setSendState();
		end
		-- TFDirector:send(c2s.FIGHT_END_REQUEST, self.lastEndFightMsg)
	end
end

function FightManager:EndFight(win)
	self:ClearSkillCache()
	if self.isBattle then
		if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
			self:initFightLog()
			Lua_fightWriteFile(EnumFight_Log.Battle, "w+","\n", battleReplayMgr.battleRoundList)
		end
		self:EndReplayBattle()
		return
	end

	if self.isReplayFight then
		fightRoleMgr:FightEndHpLog()
		if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
			local actionNum = fightRoundMgr.actionList:length()
			for i=1,actionNum do
				local actionInfo = fightRoundMgr.actionList:objectAt(i)
				Lua_fightWriteFile(EnumFight_Log.Replay, "a+",i.."  ----------------\n", actionInfo)
			end
		end
		self:EndReplayFight()
		return
	end

	if self.isFighting then
		self.isFighting = false

		DeviceAdpter.skipMemoryWarning = false
		if self.end_timerID then
			TFDirector:removeTimer(self.end_timerID)
			self.end_timerID = nil
		end
		self.end_timerID = TFDirector:addTimer(1000, 1, nil,
		function() 
			TFDirector:removeTimer(self.end_timerID)
			self.end_timerID = nil
			if self.fightBeginInfo.bGuideFight then
				self:OnGuideFightEnd(win)
			else
				self:SendEndFightMsg(win)
			end
		end)
	end
end

local function transTableToString( tbl ,deep)
	deep = deep or 1
	local type_ = type(tbl)
	if type_ == "table" then
		local str0 = "{"
		for i,v in pairs(tbl) do
			if str0 ~= "{" then
				str0 = str0 .. ","
			end
			-- for i=1,deep do
			-- 	str0 = str0 .. "\t"
			-- end
			str0 = str0 .. "\"" .. tostring(i) .. "\" = " 
			local deep0 = deep + 1
			str0 = str0 .. transTableToString(v,deep0)
		end
		-- str0 = str0 .. "\n"
		-- for i=1,deep-1 do
		-- 	str0 = str0 .. "\t"
		-- end
		str0 = str0 .. "}"
		return str0
	elseif type_ == "number" or type_ == "string" then
		return "\"" .. tbl .. "\""
	else
		return "\"" .. tostring(tbl) .. "\""
	end
	return "\"\""
end

function FightManager:SendEndFightMsg(win)
	self.bFighting = false
	win = win or false
	local topLayer = Public:currentScene():getTopLayer()
    if topLayer ~= nil and topLayer.__cname == "ReconnectLayer" then
    else
    	hideAllLoading()
	    for i=1,100 do
	        showLoading()
	    end
    end

	local list = {}
	local nActionCount = fightRoundMgr.actionList:length()
	local strlog = EnumFight_Log.FightAct
	if FightManager.isTiaoGuo then
		strlog = EnumFight_Log.FightOutAct
	end
	---
	self.sendAutoLog = {}
	-- for i=1,nActionCount do
	-- 	local actionInfo = fightRoundMgr.actionList:objectAt(i)
	local actionCount = 0
	for actionInfo in fightRoundMgr.actionList:iterator() do
		if actionInfo ~= nil and actionInfo.unExecute == false and actionInfo.targetlist ~= nil then
			local bBackAttack = actionInfo.bBackAttack or false
			local info = {actionInfo.bManualAction, actionInfo.roundIndex, actionInfo.attackerpos,
						actionInfo.skillid.skillId,actionInfo.skillid.level, bBackAttack}

			info[8] = actionInfo.buffList or {}
			info[9] = actionInfo.triggerType or 0
			info[7]	= {}
			for j=1, #actionInfo.targetlist do
				local actionTargetInfo = actionInfo.targetlist[j]
				local triggerBufferID    = actionTargetInfo.triggerBufferID or 0
				local triggerBufferLevel = actionTargetInfo.triggerBufferLevel or 0
				local passiveEffect      = actionTargetInfo.passiveEffect or 0
				local passiveEffectValue = actionTargetInfo.passiveEffectValue or 0
				local activeEffect       = actionTargetInfo.activeEffect or 0
				local activeEffectValue  = actionTargetInfo.activeEffectValue or 0
			  	local targetInfo = {actionTargetInfo.targetpos, actionTargetInfo.effect, actionTargetInfo.hurt,
			  						triggerBufferID, triggerBufferLevel, passiveEffect, passiveEffectValue, activeEffect, activeEffectValue}
			  	info[7][j] = targetInfo
			end	  
			list[#list+1] = info
			actionCount = actionCount + 1
			if (self.log_fileName ) then
				actionInfo.backTarget = nil
				actionInfo._targetlist = nil
				Lua_fightWriteFile(strlog, nil, "------"..actionCount.."------\n",actionInfo)
			
			end
		end
	end

	local liveList = {}
	for k,role in pairs(fightRoleMgr.map) do
		liveList[#liveList+1] = {role.logicInfo.posindex, role.currHp ,role.role_anger}
	end
	local hurtcountlist = {}
	for k,role in pairs(fightRoleMgr.map) do
		hurtcountlist[#hurtcountlist+1] = {role.logicInfo.posindex, fightRoleMgr.hurtReport[role.logicInfo.posindex] or 0}
	end
	----------------------
	if #list > FightManager.ActionReportMax then
		self.lastEndFightReport = {}
		local exter_packet_num = math.ceil(#list/FightManager.ActionReportMax)
		for i=1,exter_packet_num do
			local report_msg = {}
			for j=1,FightManager.ActionReportMax do
				local exter_index = (i-1)* FightManager.ActionReportMax + j
				if exter_index <= #list then
					report_msg[j] = list[exter_index]
				else
					break
				end
			end
			self.lastEndFightReport[i] = {i,report_msg}
			-- TFDirector:send(c2s.FIGHT_RERORT, self.lastEndFightReport[i])
		end
		list = {}	
	end
	----------------------
	self.lastEndFightMsg = {self.fightBeginInfo.fighttype, win, list, liveList, fightRoleMgr.selfAnger, fightRoleMgr.enemyAnger,hurtcountlist}
	self.bWaitResultMsg = true
	if self.lastEndFightReport and #self.lastEndFightReport > 0 and #list == 0 then
		TFDirector:currentScene().fightUiLayer:SetAngerNBPosition(-100)
		local index = 1
		self.reportTimer = TFDirector:addTimer(100,#self.lastEndFightReport+1,nil,function ()
			if index <= #self.lastEndFightReport then
				local sendMsg = self.lastEndFightReport[index]
				if (sendMsg) then
					TFDirector:send(c2s.FIGHT_RERORT, sendMsg)
				else
					toastMessage("ERROR--->  index："..index)
				end		
			else
				TFDirector:send(c2s.FIGHT_END_REQUEST, self.lastEndFightMsg)
				if self.reportTimer then
					TFDirector:removeTimer(self.reportTimer)
					self.reportTimer = nil
				end
				self:setSendState();
				TFDirector:currentScene().fightUiLayer:SetAngerNBPosition(0)
			end
			index = index + 1;
		end)
	else
		TFDirector:send(c2s.FIGHT_END_REQUEST, self.lastEndFightMsg)
		self:setSendState();
		TFDirector:currentScene().fightUiLayer:SetAngerNBPosition(0)
	end
	-- TFDirector:send(c2s.FIGHT_END_REQUEST, self.lastEndFightMsg)

	fightRoleMgr:FightEndHpLog()
	self.isTiaoGuo = false
end

function FightManager:setSendState()
	self.sendResultState = true
	if self.sendResultTimer then
		TFDirector:removeTimer(self.sendResultTimer)
		self.sendResultTimer = nil
	end
	self.sendResultTimer = TFDirector:addTimer(30000 ,1,nil,function ()
		if self.sendResultState then
			hideAllLoading()
			self.sendResultState = false
			CommonManager:showReconnectLayer()
		end
		if self.sendResultTimer then
			TFDirector:removeTimer(self.sendResultTimer)
			self.sendResultTimer = nil 
		end
	end)
end

function FightManager:LeaveFight()
	self.bLeaveFight = true
	self:clearFightLog()
	self:Debug_Layer(true, true)
	if self.fightBeginInfo and self.fightBeginInfo.fighttype == 30 or self.fightBeginInfo.fighttype == 32 then
		TFDirector:send(c2s.QUIT_BATTLE_REQUEST, {})
	end
	self:CleanFightAi()
	self:Reset()
	AlertManager:changeScene(SceneType.HOME,nil,TFSceneChangeType_PopBack)
	BossFightManager.isAllOut = 0

	if MissionManager:isInTrustOnekey() then
		TFDirector:dispatchGlobalEventWith(FightManager.LeaveFightForOneKey, {})
	end
	TFDirector:dispatchGlobalEventWith(FightManager.LeaveFightForKingWar, {})
	-- CCArmatureDataManager:purge()
	KingOfWarManager:setNeedShowSkip(false)
end

--切换战斗两倍速
function FightManager:SwitchDoubleSpeed()
	local speed = 1.2
	if self.fightSpeed == 1 then
		self.fightSpeed = 2
		if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
			-- TFDirector:setFPS(GameConfig.FPS)
			me.Scheduler:setTimeScale(speed)
		else
			-- TFDirector:setFPS(GameConfig.FPS * 2)
			me.Scheduler:setTimeScale(speed)
		end
	else
		self.fightSpeed = 1
		-- TFDirector:setFPS(GameConfig.FPS)
		me.Scheduler:setTimeScale(1)
	end

	if self.isBattle then
		battleRoundMgr:OnFightSpeedChange()
	else
		fightRoleMgr:OnFightSpeedChange()
	end
end

function FightManager:backInitSpeed()
	me.Scheduler:setTimeScale(1)
end

function FightManager:IsRoundStart()
	if self.isBattle then
		return battleReplayMgr.nCurrRoundIndex > 0		
	end
	if self.isReplayFight then
		return fightReplayMgr.nCurrRoundIndex > 0
	else
		return fightRoundMgr.nCurrRoundIndex > 0
	end
end

function FightManager:GetCurrAction()
	if self.isBattle then
		return battleReplayMgr.currAction	
	end
	if self.isReplayFight then
		return fightReplayMgr.currAction
	else
		return fightRoundMgr.currAction
	end
end

function FightManager:OnAddRoleEnd()
	TFDirector:currentScene().fightUiLayer:initSkillbtnClick()
	self:OnActionEnd()
end
function FightManager:OnActionEnd()
	TFDirector:currentScene():ZoomOut()
	
	if self.isBattle then
		battleReplayMgr:OnActionEnd()
		return 
	end
	if self.isReplayFight then
		fightReplayMgr:OnActionEnd()
	else
		fightRoundMgr:OnActionEnd()
	end
end

function FightManager:HaveBackAttackAction()

	if self.isBattle then
		return battleReplayMgr:HaveBackAttackAction()
	end
	if self.isReplayFight then
		return fightReplayMgr:HaveBackAttackAction()
	else
		return fightRoundMgr:HaveBackAttackAction()
	end
end

--战斗类型。1:pve推图；2:pve铜人阵；3:pvp豪杰榜；4:pvp天罡星 5:pve无量山 6:pvp大宝藏 7:pve摩柯崖 8:pve护驾
function FightManager:IsPVEFight()
	local fightType = self.fightBeginInfo.fighttype
	if fightType == 1 or fightType == 2 or fightType == 5 or fightType == 7 or fightType == 8 or fightType == 10 then
		return true
	else
		return false
	end
end

function FightManager:GetFightType()
	local fightType = 0
	if (self.fightBeginInfo and self.fightBeginInfo.fighttype) then
		fightType = self.fightBeginInfo.fighttype
	end
	return fightType
end

function FightManager:NeedShowText(bBenginTip)
	-- if MissionManager:isInTrustOnekey() then
	-- 	return false
	-- end
	if self.isBattle then
		return false
	end
	if self.isReplayFight then
		return false
	end
	if self:FactorShowTest(bBenginTip) then
		return true
	end
	if bBenginTip == false and (self.fightBeginInfo.fighttype == 31 or self.fightBeginInfo.fighttype == 32) then
		--浪人武士
		return true
	end
	if self.fightBeginInfo.fighttype == 30 then
		if bBenginTip then
			return JapanIslandManager:isHaveTip(bBenginTip)
		else
			return self.fightResultInfo.result > 0 and JapanIslandManager:isHaveTip(bBenginTip)
		end
	end
	if self.fightBeginInfo.fighttype ~= 1 and self.fightBeginInfo.fighttype ~= 19 and self.fightBeginInfo.fighttype ~= 23 then
		return false
	end

	if self.fightBeginInfo.bSkillShowFight then
		return false
	end

	if self.fightBeginInfo.bGuideFight then
		return true
	end

	if bBenginTip then
		return MissionManager:isHaveBeginTip()
	else
		if self.fightResultInfo.result == 0 then
			return false
		end
		return MissionManager:isHaveEndTip()
	end
end
function FightManager:isNeedMoive()
	if self.isBattle then
		return false
	end
	if self.isReplayFight then
		return false
	end
	-- if self:FactorShowTest(bBenginTip) then
	-- 	return true
	-- end

	if self.fightBeginInfo.index and self.fightBeginInfo.total and self.fightBeginInfo.index ~= 1 then
		return false
	end

	if self.fightBeginInfo.fighttype ~= 1 and self.fightBeginInfo.fighttype ~= 19 and self.fightBeginInfo.fighttype ~= 23 then
		return false
	end

	if self.fightBeginInfo.bSkillShowFight then
		return false
	end

	if self.fightBeginInfo.bGuideFight then
		return false
	end

	return MissionManager:isHaveBeginMoive()
end


function FightManager:FactorShowTest( bBenginTip )
	if self.fightBeginInfo.fighttype ~= 17 then
		return false
	end
	if self.fightBeginInfo.bSkillShowFight then
		return false
	end

	if self.fightBeginInfo.bGuideFight then
		return true
	end
	if bBenginTip then
		return FactionManager:isHaveBeginTip()
	else
		if self.fightResultInfo.result == 0 then
			return false
		end
		return FactionManager:isHaveEndTip()
	end
end
function FightManager:isHasSecondFight()
	if self.fightBeginInfo == nil then
		return false
	end
	if self.fightBeginInfo.bSkillShowFight then
		return false
	end
	if self.fightBeginInfo.fighttype >= EnumFightType.Adventure_Copy and self.fightBeginInfo.fighttype <= EnumFightType.Adventure_Event then
		return true
	end
	return false
end

function FightManager:isNeedQuickEnd()
	if self.isBattle then
		return false
	end
	if self.isReplayFight then
		return false
	end
	if self.fightBeginInfo.bGuideFight then
		return false
	end
	if self.fightBeginInfo.bSkillShowFight then
		return false
	end

	if self.fightBeginInfo.fighttype == 1 then
		local status = MissionManager:getMissionPassStatus(MissionManager.attackMissionId);
		if status == MissionManager.STATUS_PASS then
			return true
		end		
		return false
	end

	if EnumFightNeedQuicList[self.fightBeginInfo.fighttype] == true then
		return true
	end
	
	return false
end
--战斗类型。1:pve推图；2:pve铜人阵；3:pvp豪杰榜；4:pvp天罡星 5:pve无量山 6:pvp大宝藏 7:pve摩柯崖 8:pve护驾 10:世界boss 11:切磋 12:争霸赛
function FightManager:isNeedPause()
	if self.isBattle then
		return false
	end
	if self.isReplayFight then
		return false
	end

	if self.fightBeginInfo.bSkillShowFight then
		return false
	end

	if EnumFightNeedPauseList[self.fightBeginInfo.fighttype] == false then
		return false
	end
	if self.fightBeginInfo.bGuideFight then
		return false
	end
	if self.fightBeginInfo.bPrologue then
		return false
	end

	if self.fightBeginInfo.fighttype == 19 then
		local mission = AdventureMissionManager:getMissionById(20002);
		if mission.starLevel ~= MissionManager.STARLEVEL0 then
			return true
		else
			return false
		end
	end
	local status = MissionManager:getMissionPassStatus(5);
	if status ~= MissionManager.STATUS_PASS then
		return false
	end
	return true
end

function FightManager:getFactionBossIndex()
	local data = GuildZoneCheckPointData:GetInfoByZoneIdAndPoint(HoushanManager.chapter ,HoushanManager.bossIndex)
	if data == nil  or data.boss_index == "" then
		print("boss 信息有误===",HoushanManager.chapter ,HoushanManager.bossIndex)
		return {}
	end
	if type(data.boss_index) == "number" then
		if data.boss_index <= 0 then
			return {}
		else
			return {data.boss_index}
		end
	end
	local boss_index = string.split(data.boss_index,"|")
	return boss_index
end
function FightManager:getBossIndex()
	if self.fightBeginInfo.fighttype == 17 then
		return self:getFactionBossIndex()
	end
	if self.fightBeginInfo.fighttype ~= 1 then
		return {}
	end

	if self.fightBeginInfo.bSkillShowFight then
		return {}
	end

	if self.fightBeginInfo.bGuideFight then
		return {}
	end
	local mission_info = MissionManager:getMissionById(MissionManager.attackMissionId)
	if mission_info == nil or mission_info.boss_index == "" then
		return {}
	end
	if type(mission_info.boss_index) == "number" then
		if mission_info.boss_index <= 0 then
			return {}
		else
			return {mission_info.boss_index}
		end
	end
	local boss_index = string.split(mission_info.boss_index,"|")
	return boss_index
end

function FightManager:BattleCustomSkillMsgHandle(event)
	local data = event.data
	self.battleCustomSkill = data
end

function FightManager:checkBattleCustomSkill( roleList )
	if self.battleCustomSkill == nil then
		return
	end
	local role_map_1 = {}
	local role_map_2 = {}
	for k,role in pairs(roleList) do
		if role.posindex < 9 then
			role_map_1[role.roleId] = true
		else
			role_map_2[role.roleId] = true
		end
	end
	
	if self.battleCustomSkill.atkInfo and not self:_checkBattleCustomSkill(self.battleCustomSkill.atkInfo , role_map_1) then
		self.battleCustomSkill.atkInfo = nil
	end
	if self.battleCustomSkill.defInfo and not self:_checkBattleCustomSkill(self.battleCustomSkill.defInfo , role_map_2) then
		self.battleCustomSkill.defInfo = nil
	end
end

function FightManager:_checkBattleCustomSkill( info , role_map )
	if info == nil or not info.isUse then
		return false
	end
	if info.baseOrder then
		for i=1,#info.baseOrder do
			if not role_map[info.baseOrder[i]] then
				return false
			end
		end
	end
	if info.specialOrder then
		for i=1,#info.specialOrder do
			if not role_map[info.specialOrder[i].roleId] then
				return false
			end
		end
	end
	return true
end

function FightManager:FightBeginMsgHandle(event)
	print("FightBeginMsgHandle", event.data)
	self.fightBeginInfo = event.data
	if self.isFighting then
		return
	end
	self:checkBattleCustomSkill( self.fightBeginInfo.rolelist )
	if self.fightBeginInfo.fighttype == 1 then
		local status = MissionManager:getMissionPassStatus(MissionManager.attackMissionId);
		if status ~= MissionManager.STATUS_PASS then
			if self:BeginPrologueFight() then
				return
			end
		end
	end
	self:BeginFight()
end

function FightManager:FightReportMsgHandle(event)
	local data = event.data
	--print("FightReportMsgHandle", data)
	if data.packetIndex == 1 then
		self.fightReportList = {}
	end
	if data.actionlist then
		for i=1,#data.actionlist do
			self.fightReportList[#self.fightReportList + 1] = data.actionlist[i]
		end
	end
end

function FightManager:FightResultMsgHandle(event)
	print("FightResultMsgHandle", event.data)
	hideAllLoading()
	self.sendResultState = false
	if self.bWaitResultMsg then
		self.bWaitResultMsg = false
		self.fightResultInfo = event.data
		self.temp_flag = 0
		if self:isHasSecondFight() then
			if self.fightResultInfo.result ~= 0 and self.fightResultInfo.rank  and self.fightResultInfo.rank == 1 then
				TFDirector:dispatchGlobalEventWith(FightManager.StartSecondBattle,{ });
				return
			end
		end
		AlertManager:changeScene(SceneType.FIGHTRESULT)
		if self.fightResultInfo.championsInfo then
			ZhengbaManager:updateChampionsInfo(self.fightResultInfo.championsInfo)
		end
		--风云录计算挑战次数
		if self.fightResultInfo.achievement and self.fightResultInfo.achievement ~= -1 then
			FengYunLuManager.challengeCount = FengYunLuManager.challengeCount - 1 
			local layer1 = AlertManager:getLayerByName("lua.logic.fengyunlu.FengYunLuVSLayer");
			if layer1 then
				AlertManager:closeLayer(layer1);
			end
		end
		if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 and VERSION_DEBUG == true then
			local bServerfail = (self.fightResultInfo.result == 0)
			if (bServerfail) then	
				if (self.lastEndFightMsg and self.lastEndFightMsg[2] == true) then
					toastMessage("Error--> Client:true server:false")
					print("Error--> Client:true Server:false")
					print("Error--> Client:true Server:false")
					print("Error--> Client:true Server:false")
				
					self.sendAutoLog = self.sendAutoLog or {}
		
				end
			else	
				if (self.lastEndFightMsg and self.lastEndFightMsg[2] == false) then
					print("Error--> Client:false server:true")
					print("Error--> Client:false Server:true")
					print("Error--> Client:false Server:true")
					toastMessage("Error--> Client:false Server:true")
				
					self.sendAutoLog = self.sendAutoLog or {}
		
				end
			end
		end
	end
	self.sendAutoLog = nil
	--英雄大会判断是否是反击类型，是的话要刷新个人战报界面
	if HeroMeetingManager.reportId ~= "" then
		HeroMeetingManager.reportId = ""
		HeroMeetingManager:GetHeroDuelMyReportRequest()
	end
end


function FightManager:FightErrorHandle()
	-- print("FightManager:FightErrorHandle()")
	hideAllLoading()

	if self.bWaitResultMsg then
		self.bWaitResultMsg = false
		self.fightResultInfo = {}
		self.fightResultInfo.result = 0
		AlertManager:changeScene(SceneType.FIGHTRESULT)
	end
end

function FightManager:FightReplayMsgHandle(event)
	-- print("FightReplayMsgHandle", event.data)
	hideAllLoading()
	
	self.fightBeginInfo = event.data.beginInfo
	local liveList = {}
	-- for i=1,#event.data.fightData.livelist do
	-- 	local temp = event.data.fightData.livelist[i]
	for i, temp in ipairs(event.data.fightData.livelist) do
		liveList[i] = {temp.posindex,temp.currhp}
	end

	local roleList = self.fightBeginInfo.rolelist
	for k,roleInfo in pairs(roleList) do
		if roleInfo.posindex == 18 then
			roleInfo.posindex = 19
		elseif roleInfo.posindex == 19 then
			roleInfo.posindex = 18
		elseif roleInfo.posindex < 9 then
			roleInfo.posindex = roleInfo.posindex + 9
		else
			roleInfo.posindex = roleInfo.posindex - 9
		end
	end

	local hurtcountlist = {}
	if event.data.fightData.hurtcountlist then
		-- for i=1,#event.data.fightData.hurtcountlist do
		-- 	local temp = event.data.fightData.hurtcountlist[i]
		for i,temp in ipairs(event.data.fightData.hurtcountlist) do
			local pos = temp.posindex
			if temp.posindex < 9 then
				pos = temp.posindex + 9
			elseif temp.posindex < 18 then
				pos = temp.posindex - 9
			elseif temp.posindex == 18 then
				pos = 19
			elseif temp.posindex == 19 then
				pos = 18
			end
			hurtcountlist[i] = {pos,temp.hurt}
		end
	else
		for k,v in pairs(self.fightBeginInfo.rolelist) do
			hurtcountlist[#hurtcountlist + 1] = {v.posindex , 0}
		end
	end
	local actionlist = event.data.fightData.actionlist
	if actionlist == nil then
		actionlist = self.fightReportList
	end
	self.lastEndFightMsg = {event.data.fightData.fighttype,event.data.fightData.win,actionlist,liveList, event.data.fightData.angerSelf,event.data.fightData.angerEnemy,hurtcountlist}


	self.fightResultInfo = {}
	if event.data.fightData.win then
		self.fightResultInfo.result = 0
	else
		self.fightResultInfo.result = 3
	end

	fightRoundMgr:AddReplayAction(actionlist)
	local tempArrayId = self.fightBeginInfo.myBattlearrayId
	self.fightBeginInfo.myBattlearrayId = self.fightBeginInfo.enemyBattlearrayId
	self.fightBeginInfo.enemyBattlearrayId = tempArrayId
	self:ReplayFight(true)
end


function FightManager:FightArenaReplayMsgHandle(event)
	-- print("FightArenaReplayMsgHandle", event.data)
	hideAllLoading()
	
	self.fightBeginInfo = event.data.beginInfo
	local liveList = {}
	-- for i=1,#event.data.fightData.livelist do
	-- 	local temp = event.data.fightData.livelist[i]
	for i,temp in ipairs(event.data.fightData.livelist) do
		liveList[i] = {temp.posindex,temp.currhp}
	end


	local hurtcountlist = {}
	if event.data.fightData.hurtcountlist then
		-- for i=1,#event.data.fightData.hurtcountlist do
		-- 	local temp = event.data.fightData.hurtcountlist[i]
		for i,temp in ipairs(event.data.fightData.hurtcountlist) do		
			-- if temp.posindex < 18 then
			hurtcountlist[i] = {temp.posindex,temp.hurt}
			-- end
		end
	else
		for k,v in pairs(self.fightBeginInfo.rolelist) do
			-- if v.posindex < 18 then
			hurtcountlist[#hurtcountlist + 1] = {v.posindex , 0}
			-- end
		end
	end
	local actionlist = event.data.fightData.actionlist
	if actionlist == nil then
		actionlist = self.fightReportList
	end

	self.lastEndFightMsg = {event.data.fightData.fighttype,event.data.fightData.win,actionlist,liveList,event.data.fightData.angerSelf,event.data.fightData.angerEnemy,hurtcountlist}
	local roleList = self.fightBeginInfo.rolelist
	-- for k,roleInfo in pairs(roleList) do
	-- 	if roleInfo.posindex < 9 then
	-- 		roleInfo.posindex = roleInfo.posindex + 9
	-- 	else
	-- 		roleInfo.posindex = roleInfo.posindex - 9
	-- 	end
	-- end

	self.fightResultInfo = {}
	if event.data.fightData.win then
		self.fightResultInfo.result = 3
	else
		self.fightResultInfo.result = 0
	end

	fightRoundMgr:AddReplayActionNoChangPos(actionlist)

	self:ReplayFight(true)
end


function GetRoleAttr(attr, roleInfo)
	local baseAttrList = GetAttrByString(roleInfo.attribute)
	local baseAttr = baseAttrList[attr]
	baseAttr = baseAttr or 0

	baseAttr = math.floor(baseAttr)
	return baseAttr
end

--序章
function FightManager:BeginPrologueFight()
	print("FightManager:BeginPrologueFight()")
	-- local mission_info = MissionManager:getMissionById(MissionManager.attackMissionId)
	local prologurFightInfo = MissionPrologueData:objectByID(MissionManager.attackMissionId)
	if prologurFightInfo == nil then
		return false
	end

	self.fightBeginInfo = {}
	self.fightBeginInfo.bGuideFight = false
	self.fightBeginInfo.bPrologue = true
	self.fightBeginInfo.fighttype = 1
	self.fightBeginInfo.angerSelf = prologurFightInfo.role_anger
	self.fightBeginInfo.angerEnemy = prologurFightInfo.npc_anger
	self.fightBeginInfo.rolelist = {}
	local roleList = prologurFightInfo.role
    for index=1,#roleList do
    	local roleid = roleList[index]
    	if roleid ~= 0 then
			if prologurFightInfo.mainPlay and prologurFightInfo.mainPlay ~= 0 then
				if roleid == prologurFightInfo.mainPlay then
					roleid = roleid + MainPlayer:getProfession()
				end
			end
	    	local fightRole = {}
	        local roleInfo = RoleData:objectByID(roleid)
			fightRole.typeid = 1
			fightRole.roleId = roleid
			fightRole.posindex = index-1
			fightRole.level = 1

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, roleInfo)
			end
			fightRole.maxhp = fightRole.attr[1]

			fightRole.spellId = {}
			fightRole.spellId.skillId = roleInfo.skill
			fightRole.spellId.level = 1

			fightRole.passiveskill = {}

			local passiveskillList = string.split(roleInfo.passive_skill, ',')
			for i=1,#passiveskillList do
				if passiveskillList[i] ~= "" then
					fightRole.passiveskill[i] = {}
					fightRole.passiveskill[i].skillId = tonumber(passiveskillList[i])
					fightRole.passiveskill[i].level = 1
				end
			end

			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
    end

    local npcList = prologurFightInfo.npc
	for i=1,#npcList do
		local npcid = npcList[i]
    	if npcid ~= 0 then
	    	local fightRole = {}
	        local npcInfo = NPCData:objectByID(npcid)
	        fightRole.typeid = 2
			fightRole.roleId = npcid
			fightRole.posindex = 8+i
			fightRole.level = npcInfo.level

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, npcInfo)
			end
			fightRole.maxhp = fightRole.attr[1]

			fightRole.spellId = {}
			fightRole.spellId.skillId = npcInfo.skill
			fightRole.spellId.level = npcInfo.level
			fightRole.passiveskill = {}

			local passiveskillList = string.split(npcInfo.passive_skill, ',')
			for i=1,#passiveskillList do
				if passiveskillList[i] ~= "" and tonumber(passiveskillList[i]) ~= "0" then
					fightRole.passiveskill[i] = {}
					fightRole.passiveskill[i].skillId = tonumber(passiveskillList[i])
					fightRole.passiveskill[i].level = 1
				end
			end


			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
	end
	self.isAutoFight = false
	self:BeginFight()
	return true
end

function FightManager:addNewRole( roleid ,index, attackRole, effect_value)
	local fightRole 	= {}
    local roleInfo 		= RoleData:objectByID(roleid)
	local addRoleLevel 	= 1
	if (attackRole) then
		addRoleLevel = attackRole.logicInfo.level
	end
	fightRole.typeid 	= 1
	fightRole.roleId 	= roleid
	fightRole.posindex 	= index
	fightRole.level 	= addRoleLevel

	fightRole.attr = {}
	for attrIndex=1,17 do
		if (attackRole) then
			fightRole.attr[attrIndex] = math.floor(attackRole.logicInfo.attr[attrIndex] * effect_value / 100)
		else
			fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, roleInfo)
		end
	end
	fightRole.maxhp 			= fightRole.attr[1]
	--
	fightRole.spellId 			= {}
	fightRole.spellId.skillId 	= roleInfo.skill
	fightRole.spellId.level 	= addRoleLevel
	fightRole.passiveskill 		= {}
	--
	local passiveskillList = string.split(roleInfo.passive_skill, ',')
	for i=1,#passiveskillList do
		if passiveskillList[i] ~= "" then
			fightRole.passiveskill[i] 			= {}
			fightRole.passiveskill[i].skillId 	= tonumber(passiveskillList[i])
			fightRole.passiveskill[i].level 	= addRoleLevel
		end
	end
	--
	if (attackRole) then
	else
		self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
	end
	
	-- table.insert( self.fightBeginInfo.rolelist, fightRole )
	--
	if self.isBattle then
		return battleRoundMgr:addNewRoleIntoFight(fightRole)
	end
	return fightRoleMgr:addNewRoleIntoFight(fightRole)
end
function FightManager:addNewNpc( npcid ,index)
	local fightRole = {}
    local npcInfo = NPCData:objectByID(npcid)
    fightRole.typeid = 2
	fightRole.roleId = npcid
	fightRole.posindex = 9+index
	fightRole.level = npcInfo.level

	fightRole.attr = {}
	for attrIndex=1,17 do
		fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, npcInfo)
	end
	fightRole.maxhp = fightRole.attr[1]

	fightRole.spellId = {}
	fightRole.spellId.skillId = npcInfo.skill
	fightRole.spellId.level = npcInfo.level
	fightRole.passiveskill = {}

	local passiveskillList = string.split(npcInfo.passive_skill, ',')
	for i=1,#passiveskillList do
		if passiveskillList[i] ~= "" and tonumber(passiveskillList[i]) ~= "0" then
			fightRole.passiveskill[i] = {}
			fightRole.passiveskill[i].skillId = tonumber(passiveskillList[i])
			fightRole.passiveskill[i].level = 1
		end
	end
	self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole

	fightRoleMgr:addNewRoleIntoFight(fightRole)
end

function FightManager:BeginGuideFight(fightGuideInfo)
	self.fightBeginInfo = {}
	self.fightBeginInfo.bGuideFight = true
	self.fightBeginInfo.fighttype = 1
	self.fightBeginInfo.angerSelf = fightGuideInfo.role_anger
	self.fightBeginInfo.angerEnemy = fightGuideInfo.npc_anger
	self.fightBeginInfo.rolelist = {}

	local roleList = fightGuideInfo.role
    for index=1,#roleList do
    	local roleid = roleList[index]
    	if roleid ~= 0 then
	    	local fightRole = {}
	        local roleInfo = RoleData:objectByID(roleid)
			fightRole.typeid = 1
			fightRole.roleId = roleid
			fightRole.posindex = index-1
			fightRole.level = 1

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, roleInfo)
			end
			fightRole.maxhp = fightRole.attr[1]

			fightRole.spellId = {}
			fightRole.spellId.skillId = roleInfo.skill
			fightRole.spellId.level = 1

			fightRole.passiveskill = {}

			local passiveskillList = string.split(roleInfo.passive_skill, ',')
			for i=1,#passiveskillList do
				if passiveskillList[i] ~= "" then
					fightRole.passiveskill[i] = {}
					fightRole.passiveskill[i].skillId = tonumber(passiveskillList[i])
					fightRole.passiveskill[i].level = 1
				end
			end

			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
    end

    local npcList = fightGuideInfo.npc
	for i=1,#npcList do
		local npcid = npcList[i]
    	if npcid ~= 0 then
	    	local fightRole = {}
	        local npcInfo = NPCData:objectByID(npcid)
	        fightRole.typeid = 2
			fightRole.roleId = npcid
			fightRole.posindex = 8+i
			fightRole.level = npcInfo.level

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, npcInfo)
			end
			fightRole.maxhp = fightRole.attr[1]

			fightRole.spellId = {}
			fightRole.spellId.skillId = npcInfo.skill
			fightRole.spellId.level = npcInfo.level
			fightRole.passiveskill = {}

			local passiveskillList = string.split(npcInfo.passive_skill, ',')
			for i=1,#passiveskillList do
				if passiveskillList[i] ~= "" and tonumber(passiveskillList[i]) ~= "0" then
					fightRole.passiveskill[i] = {}
					fightRole.passiveskill[i].skillId = tonumber(passiveskillList[i])
					fightRole.passiveskill[i].level = 1
				end
			end


			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
	end

	self:BeginFight()
end

function FightManager:OnGuideFightEnd(win)
	local endTextShowEndCallBack = function(event)
		self:Reset()
		-- CCArmatureDataManager:purge()
		-- AlertManager:changeScene(SceneType.CREATEPLAYER)
		TFAudio.stopAllEffects()
		TFDirector:removeMEGlobalListener("MissionTipLayer.EVENT_SHOW_ENDTIP_COM")
		PlayerGuideManager:ShowGameBeginVideo2(Public:currentScene().fightUiLayer)
	end
	TFDirector:addMEGlobalListener("MissionTipLayer.EVENT_SHOW_ENDTIP_COM",  endTextShowEndCallBack)

	local blackPanel = TFPanel:create()
	local nViewHeight = GameConfig.WS.height
    local nViewWidth = GameConfig.WS.width
	blackPanel:setSize(CCSize(nViewWidth,nViewHeight))
   	blackPanel:setBackGroundColorType(TF_LAYOUT_COLOR_SOLID)
   	blackPanel:setBackGroundColor(ccc3(0,0,0))
   	blackPanel:setZOrder(10001)
	TFDirector:currentScene().fightUiLayer:addChild(blackPanel)

	local guideInfo = PlayerGuideManager:GetGuideFightInfo()
    MissionManager:showEndTipForMission(guideInfo.mission_id)
end

function FightManager:BeginSkillShowFight(typeid)
	self.fightBeginInfo = {}
	self.fightBeginInfo.bSkillShowFight = true
	self.fightBeginInfo.fighttype = 1
	self.fightBeginInfo.angerSelf = 0
	self.fightBeginInfo.angerEnemy = 0
	self.fightBeginInfo.rolelist = {}

	-- print("typeid = ", typeid)
	local skillRoleInfo = RoleData:objectByID(typeid)
	local cureRole = 0
	-- if skillRoleInfo.outline == 3 then
	-- 	cureRole = 1
	-- end
	-- print("skillRoleInfo = ", skillRoleInfo)
	local roleList = {0,0,0,0,typeid,0,cureRole,0,0}
    for index=1,#roleList do
    	local roleid = roleList[index]
    	if roleid ~= 0 then
	    	local fightRole = {}
	        local roleInfo = RoleData:objectByID(roleid)
			fightRole.typeid = 1
			fightRole.posindex = index-1
			fightRole.level = 1

			fightRole.roleId = roleid --

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, roleInfo)
			end
			fightRole.maxhp = 10000-index
			fightRole.attr[5] = 100000

			fightRole.spellId = {}
			local isMainPlayer 		= ProtagonistData:IsMainPlayer( roleid )

			if isMainPlayer == true then
				local leadingSpellInfoConfigList	= roleInfo:getLeadingSpellInfoConfigList();
				local skillInfo = leadingSpellInfoConfigList:objectAt(1)
				fightRole.spellId.skillId = skillInfo.spell_id
			else
				fightRole.spellId.skillId = roleInfo.skill
			end
			fightRole.spellId.level = 1
			fightRole.passiveskill = {}

			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
    end

    local npcList = {45,0,0,45,45,45,45,0,0}
	for i=1,#npcList do
		local npcid = npcList[i]
    	if npcid ~= 0 then
	    	local fightRole = {}
	        local npcInfo = NPCData:objectByID(npcid)
			fightRole.typeid = 2
			fightRole.posindex = 8+i
			fightRole.level = 1

			fightRole.roleId = npcid--

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, npcInfo)
			end
			fightRole.maxhp = fightRole.attr[1]

			fightRole.spellId = {}
			fightRole.spellId.skillId = 0
			fightRole.spellId.level = 0
			fightRole.passiveskill = {}

			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
	end

	self.fightSpeed = 1
	self:BeginFight()
end
function FightManager:BeginRedSkillShowFight(typeid)
	self.fightBeginInfo = {}
	self.fightBeginInfo.bSkillShowFight = true
	self.fightBeginInfo.fighttype = 1
	self.fightBeginInfo.angerSelf = 0
	self.fightBeginInfo.angerEnemy = 0
	self.fightBeginInfo.rolelist = {}

	-- print("typeid = ", typeid)
	local skillRoleInfo = RoleData:objectByID(typeid)
	local cureRole = 0
	if skillRoleInfo.outline == 3 then
		cureRole = 1
	end
	-- print("skillRoleInfo = ", skillRoleInfo)

	local roleList = {0,0,0,0,typeid,0,cureRole,0,0}
    for index=1,#roleList do
    	local roleid = roleList[index]
    	if roleid ~= 0 then
	    	local fightRole = {}
	        local roleInfo = RoleData:objectByID(roleid)
			fightRole.typeid = 1
			fightRole.posindex = index-1
			fightRole.level = 1

			fightRole.roleId = roleid --

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, roleInfo)
			end
			fightRole.maxhp = 10000-index
			fightRole.attr[5] = 100000

			fightRole.spellId = {}
			fightRole.spellId.skillId = roleInfo.skill_2
			fightRole.spellId.level = 1
			fightRole.passiveskill = {}

			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
    end

    local npcList = {45,0,0,45,45,45,45,0,0}
	for i=1,#npcList do
		local npcid = npcList[i]
    	if npcid ~= 0 then
	    	local fightRole = {}
	        local npcInfo = NPCData:objectByID(npcid)
			fightRole.typeid = 2
			fightRole.posindex = 8+i
			fightRole.level = 1

			fightRole.roleId = npcid--

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, npcInfo)
			end
			fightRole.maxhp = fightRole.attr[1]

			fightRole.spellId = {}
			fightRole.spellId.skillId = 0
			fightRole.spellId.level = 0
			fightRole.passiveskill = {}

			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
	end

	self.fightSpeed = 1
	self:BeginFight()
end



function FightManager:BeginPetSkillShowFight(petId,quality)
	-- if 1 then
	-- 	self:BeginSkillShowFight(1)
	-- 	return
	-- end
	self.fightBeginInfo = {}
	self.fightBeginInfo.bSkillShowFight = true
	self.fightBeginInfo.bPetSkillShowFight = true
	self.fightBeginInfo.fighttype = 1
	self.fightBeginInfo.angerSelf = 0
	self.fightBeginInfo.angerEnemy = 0
	self.fightBeginInfo.rolelist = {}

	-- print("typeid = ", typeid)
	-- local skillRoleInfo = RoleData:objectByID(typeid)
	-- local cureRole = 0
	-- if skillRoleInfo.outline == 3 then
	-- 	cureRole = 1
	-- end
	-- print("skillRoleInfo = ", skillRoleInfo)
	local roleList = {0,0,0,0,1,0,1,0,0}
    for index=1,#roleList do
    	local roleid = roleList[index]
    	if roleid ~= 0 then
	    	local fightRole = {}
	        local roleInfo = RoleData:objectByID(roleid)
			fightRole.typeid = 1
			fightRole.posindex = index-1
			fightRole.level = 1

			fightRole.roleId = roleid --

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, roleInfo)
			end
			fightRole.maxhp = 10000-index
			fightRole.attr[5] = 100000

			fightRole.spellId = {}
			local isMainPlayer 		= ProtagonistData:IsMainPlayer( roleid )

			if isMainPlayer == true then
				local leadingSpellInfoConfigList	= roleInfo:getLeadingSpellInfoConfigList();
				local skillInfo = leadingSpellInfoConfigList:objectAt(1)
				fightRole.spellId.skillId = skillInfo.spell_id
			else
				fightRole.spellId.skillId = roleInfo.skill
			end
			fightRole.spellId.level = 1
			fightRole.passiveskill = {}

			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
    end

    local npcList = {45,0,0,45,45,45,45,0,0}
	for i=1,#npcList do
		local npcid = npcList[i]
    	if npcid ~= 0 then
	    	local fightRole = {}
	        local npcInfo = NPCData:objectByID(npcid)
			fightRole.typeid = 2
			fightRole.posindex = 8+i
			fightRole.level = 1

			fightRole.roleId = npcid--

			fightRole.attr = {}
			for attrIndex=1,17 do
				fightRole.attr[attrIndex] = GetRoleAttr(attrIndex, npcInfo)
			end
			fightRole.maxhp = fightRole.attr[1]

			fightRole.spellId = {}
			fightRole.spellId.skillId = 0
			fightRole.spellId.level = 0
			fightRole.passiveskill = {}

			self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
		end
	end

	if 1 then
    	local fightRole = {}
        -- local roleInfo = RoleData:objectByID(petId)
		fightRole.typeid = 1
		fightRole.posindex = 18
		fightRole.level = 1

		fightRole.roleId = petId --

		fightRole.attr = {}
		for i=1,17 do
			fightRole.attr[i] = 0
		end
		fightRole.attr[1] = 10000
		for k,attrId in pairs(EudemonAttributeTypeList) do
			fightRole.attr[attrId] = 10000
		end
		-- for attrIndex=1,17 do
		-- end
		fightRole.maxhp = quality

		fightRole.spellId = {}
		fightRole.passiveskill = {}
		local qualityData = EudemonManager:getBattlePetQualityData(quality, petId, 0)
		if (qualityData) then
			local skillList = string.split(qualityData.effect_id, ",") or {}
			local skillId = tonumber(skillList[1]) or 0
			fightRole.spellId.skillId = skillId
			fightRole.spellId.level = 1
			if skillId ~= 0 then
				local skillInfo = SkillBaseData:objectByID(skillId)
				if skillInfo and skillInfo.triggerSkill then
					fightRole.spellId.skillId = skillInfo.triggerSkill
				end
			end
		end
		self.fightBeginInfo.rolelist[fightRole.posindex] = fightRole
	end
	-- print("self.fightBeginInfo.rolelist---->>",self.fightBeginInfo.rolelist)
	self.fightSpeed = 1
	self:BeginFight()
end


function FightManager:ReplaySkillShow()
	fightRoleMgr:ClearAllRoleBuff()
	self.isReplayFight = true
	fightReplayMgr:ExecuteAction(1)
end

function FightManager:pause()
	self.ispause = true
	fightRoundMgr:pause()
end

function FightManager:setTiaoGuo()
	self.isTiaoGuo = true
end




function FightManager:BattleStartMsg(event)
	print("======================BattleStartMsg=====")
	self.fightBeginInfo = event.data
	self.fightResultInfo = {}
	self.fightResultInfo.round = {}
	self.fightResultInfo.packNum = 0
end
function FightManager:RoundsBattleMsg(event)
	hideAllLoading()
	local data = event.data
	-- print("data.totle",data)
	if data.rounds == nil then
		return
	end
	if self.fightResultInfo.packNum >= data.totle then
		return
	end

	for i=1,#data.rounds do
		self.fightResultInfo.round[#self.fightResultInfo.round + 1] = data.rounds[i]
	end
	if data.win then
		self.fightResultInfo.result = 3
	else
		self.fightResultInfo.result = 0
	end

	self.fightResultInfo.packNum = self.fightResultInfo.packNum + 1

	if self.fightResultInfo.packNum < data.totle then
		return
	end

	battleReplayMgr:AddReplayAction(self.fightResultInfo.round)

	if self.isFighting then
		return
	end
	self:battleHurtCount( self.fightResultInfo.round )



	-- 供读取输出的战斗序列使用
	-- local battleList = require("lua.table.battleList")
	-- battleReplayMgr:AddReplayAction(battleList)

	self.isBattle = true
	self.isReplayFight = true
	AlertManager:changeScene(SceneType.BATTLE, nil, TFSceneChangeType_PushBack)

	self.isFighting = true

	DeviceAdpter.skipMemoryWarning = true
end


function FightManager:battleHurtCount( roundList )
	local hurtList = {}
	for i=1,#self.fightBeginInfo.rolelist do
		local role = self.fightBeginInfo.rolelist[i]
		hurtList[role.posindex] = 0
	end

	local buffList = {}
	-- for i=1,#roundList do
	-- 	local round = roundList[i]
	for i,round in ipairs(roundList) do
		if round.action then
			-- for j=1,#round.action do
			-- 	local action = round.action[j]
			for j,action in ipairs(round.action) do
				if action.target then
					-- for k=1,#action.target do
					-- 	local target = action.target[k]
					for k,target in ipairs(action.target) do
						if target.effectValue < 0 then
							hurtList[action.fromPos] = hurtList[action.fromPos] or 0
							hurtList[action.fromPos] = hurtList[action.fromPos] + math.abs(math.ceil(target.effectValue))
						end
						if target.newState then
							for l=1,#target.newState do
								local status = target.newState[l]
								buffList[target.position] = buffList[target.position] or {}
								buffList[target.position][status.stateId] = status.fromPos
							end
						end
						if target.stateCycle then
							for l=1,#target.stateCycle do
								local stateCycle = target.stateCycle[l]

								if stateCycle.effectValue < 0 and  buffList[stateCycle.position] and buffList[stateCycle.position][stateCycle.stateId] then
									local fromPos = buffList[stateCycle.position][stateCycle.stateId]
									hurtList[fromPos] = hurtList[fromPos] or 0
									hurtList[fromPos] = hurtList[fromPos] + math.abs(math.ceil(stateCycle.effectValue))
								end
							end
						end
					end
				end
				if action.newState then
					for l=1,#action.newState do
						local status = action.newState[l]
						buffList[action.fromPos] = buffList[action.fromPos] or {}
						buffList[action.fromPos][status.stateId] = status.fromPos
					end
				end
				if action.stateCycle then
					for l=1,#action.stateCycle do
						local stateCycle = action.stateCycle[l]
						if stateCycle.effectType == 19 then
							if action.target then
								for k=1,#action.target do
									local target = action.target[k]
									if stateCycle.effectValue < 0 and  buffList[target.position] and buffList[target.position][stateCycle.stateId] then
										local fromPos = buffList[target.position][stateCycle.stateId]
										hurtList[fromPos] = hurtList[fromPos] or 0
										hurtList[fromPos] = hurtList[fromPos] + math.abs(math.ceil(stateCycle.effectValue))
									end
								end
							end
						else
							if stateCycle.effectValue < 0 and  buffList[stateCycle.position] and buffList[stateCycle.position][stateCycle.stateId] then
								local fromPos = buffList[stateCycle.position][stateCycle.stateId]
								hurtList[fromPos] = hurtList[fromPos] or 0
								hurtList[fromPos] = hurtList[fromPos] + math.abs(math.ceil(stateCycle.effectValue))
							end
						end
					end
				end
			end
		end
		if round.stateCycle then
			for l=1,#round.stateCycle do
				local stateCycle = round.stateCycle[l]
				if stateCycle.effectValue < 0 and  buffList[stateCycle.position] and buffList[stateCycle.position][stateCycle.stateId] then
					local fromPos = buffList[stateCycle.position][stateCycle.stateId]
					hurtList[fromPos] = hurtList[fromPos] or 0
					hurtList[fromPos] = hurtList[fromPos] + math.abs(math.ceil(stateCycle.effectValue))
				end
			end
		end
	end
	self.fightBeginInfo.hurtList = hurtList
end

function FightManager:BattleReplayMsg(event)
	hideAllLoading()
	
	self.fightBeginInfo = event.data.startMsg
	
	self.fightResultInfo = {}
	if event.data.roundMsg.win then
		self.fightResultInfo.result = 3
	else
		self.fightResultInfo.result = 0
	end
	-- self.fightResultInfo = event.data.result
	-- if self.fightResultInfo.win == false then
	-- 	self.fightResultInfo.result = 0
	-- end


	battleReplayMgr:AddReplayAction(event.data.roundMsg.round)


	if self.isFighting then
		return
	end

	self.isBattle = true
	self.isReplayFight = true
	AlertManager:changeScene(SceneType.BATTLE, nil, TFSceneChangeType_PushBack)

	self.isFighting = true

	DeviceAdpter.skipMemoryWarning = true
end

function FightManager:EndReplayBattle()
	print("self.isFighting",self.isFighting,self.isBattle)
	if self.isFighting and self.isBattle then
		self.isFighting = false
		

		DeviceAdpter.skipMemoryWarning = false

		if self.end_timerID then
			TFDirector:removeTimer(self.end_timerID)
			self.end_timerID = nil
		end
		battleRoundMgr:SetAllRoleSpeed(0.5)
		TFDirector:currentScene().fightUiLayer:PlayFightEndEffect()
		self.end_timerID = TFDirector:addTimer(1500, 1, nil, 
		function()
			TFDirector:removeTimer(self.end_timerID)
			self.end_timerID = nil
			self.isBattle = false
			AlertManager:changeScene(SceneType.BATTLERESULT)
		end)
	end
end

function FightManager:BattleResultMsgHandle(event)
	-- print("FightResultMsgHandle", event.data)
	hideAllLoading()
	self.fightResultInfo = event.data
	if self.fightResultInfo.win == false then
		self.fightResultInfo.result = 0
	end

end

function FightManager:getBattleRoundIndex()
	return battleReplayMgr.nCurrRoundIndex
end


function FightManager:GetAttackOrder()
	return battleReplayMgr:GetAttackOrder()
end


function FightManager:ReplayBattle(bRecordFight)
	if self.isFighting then
		return
	end
	self.isReplayFight = true
	self.isBattle = true

	battleReplayMgr:clear()
	if bRecordFight then
		AlertManager:changeScene(SceneType.BATTLE, nil, TFSceneChangeType_PushBack)
	else
		AlertManager:changeScene(SceneType.BATTLE)
	end
	
	self.isFighting = true

	DeviceAdpter.skipMemoryWarning = true
end


function FightManager:CleanBattle()
	battleReplayMgr:dispose()
	battleRoundMgr:dispose()
	-- require("lua.logic.battle.BattleRoundManager"):dispose()
	-- fightReplayMgr:dispose()
	-- fightRoleMgr:dispose()
end

function FightManager:openHurtCount()
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.fight.Shanghaitongji",AlertManager.BLOCK_AND_GRAY)
	-- AlertManager:addLayer(layer)
	layer.toScene = TFDirector:currentScene()
	AlertManager:show()
end

function FightManager:openBattleHurtCount()
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.battle.BattleHurtCount",AlertManager.BLOCK_AND_GRAY)
	-- AlertManager:addLayer(layer)
	layer.toScene = TFDirector:currentScene()
	AlertManager:show()
end

function FightManager:gotoNextBattle()
	if self.temp_flag ~= 0 then
		return
	end
	self.temp_flag = self.temp_flag + 1
	fightRoleMgr:gotoNextBattle()
	self.nextBattleTimerID = TFDirector:addTimer(500, 1, nil, 
		function() 
			TFDirector:removeTimer(self.nextBattleTimerID)
			self.nextBattleTimerID = nil
			AdventureManager:startSecondBattle()
		end)
end

--左右阵容转换
function FightManager:GetConverterTeam(posindex)
	if posindex < 9 then
		return posindex + 9
	elseif posindex < 18 then
		return posindex - 9
	elseif posindex == 18 then
		return 19
	elseif posindex == 19 then
		return 18
	end
	return posindex
end

function FightManager:GetFightCurrActionCount()
	if (self.isReplayFight) then
		return fightReplayMgr.nCurrActionIndex or 1
	end
	if (self.isBattle) then
		return battleRoundMgr.nCurrActionIndex or 1
	end
	return fightRoundMgr.actionCount - 1
end

function FightManager:getFightRoundMgr()
	return fightRoundMgr
end

function FightManager:getFightRoleMgr()
	if self.isBattle then
		return battleRoundMgr
	end
	return fightRoleMgr
end

function FightManager:GetPosByIndex(posIndex, roleId)
	local function GetLeftPosByIndex(posIndex)
		local nGirdOffsetX = 2-posIndex%3
		local nGirdOffsetY = 2-math.floor(posIndex/3)
		local nPosX = 110 + 110*nGirdOffsetX
		local nPosY = 125 + 102*nGirdOffsetY + nGirdOffsetX
		return CCPoint(nPosX, nPosY)
	end

    local nViewWidth = GameConfig.WS.width

	if posIndex >= 0 and posIndex <= 8 then
		return GetLeftPosByIndex(posIndex)
	elseif posIndex >= 9 and posIndex <= 17 then
		local pos = GetLeftPosByIndex(posIndex-9) 
		return CCPoint(nViewWidth-pos.x, pos.y)
	elseif posIndex == 18 then
		local petInfo = BattlePetData:objectByID(roleId)
		return CCPoint(petInfo.posX, petInfo.posY)
	elseif posIndex == 19 then
		local petInfo = BattlePetData:objectByID(roleId)
		return CCPoint(nViewWidth-petInfo.posX, petInfo.posY)
	else
		assert(false)
		return CCPoint(0, 0)
	end
end
function FightManager:initFightLog()
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 and VERSION_DEBUG == true then
	
		if (self.savePrint == nil) then 
			local file_name = CCFileUtils:sharedFileUtils():getWritablePath().."\\".."FightReport\\"
			local date 		= os.date("*t", os.time())
			local timeStr 	= date.month.."-"..date.day .."--"..date.hour.."_"..date.min.."_"..date.sec
			self.log_fileName = file_name..timeStr
			--
			Lua_fightWriteFile(EnumFight_Log.BUFF)
			--
			-- self.savePrint = clone(print)
			self.savePrint = (print)
			print = Lua_FightPrint	
		end
	end
end

function FightManager:clearFightLog()
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32  and VERSION_DEBUG == true then
		if (self.savePrint) then
			print = self.savePrint
			self.savePrint = nil
		end
	end
end

function FightManager:restartLoaded()
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 and self.isClearFight then
		fightRoundMgr  		= require("lua.logic.fight.FightRoundManager")
		fightReplayMgr  	= require("lua.logic.fight.FightReplayManager")
		fightRoleMgr  		= require("lua.logic.fight.FightRoleManager")
		fightAI 			= require("lua.logic.fight.FightAI")
		battleRoundMgr  	= require("lua.logic.battle.BattleRoleManager")
		battleReplayMgr  	= require("lua.logic.battle.BattleReplayManager")
		self.isClearFight = false
	end
end
function FightManager:Debug_Layer(bNew, bDel)
	-- do return end
	self.bMenWarning = false
	if CC_TARGET_PLATFORM ~= CC_PLATFORM_WIN32 then
		return
	end
	if (self.__debug_layerTimer) then
		TFDirector:removeTimer(self.__debug_layerTimer)
		self.__debug_layerTimer = nil
	end
	--
	local touchPanel = nil
	local node = me.Director:getNotificationNode()
	if node then
		touchPanel = node:getChildByName("Test_Debug")
		if (bNew and touchPanel) then
			touchPanel:removeAllChildren()
			touchPanel:removeFromParent()
			touchPanel = nil
		end
		if (touchPanel == nil) then
			if (bDel) then
				return
			end
			touchPanel = TFPanel:create()
			node:addChild(touchPanel)
		end
		
	elseif (not bDel) then
		touchPanel = TFPanel:create()
		me.Director:setNotificationNode(touchPanel)	
	end
	
	if (bDel) then
		return
	end
	--
	touchPanel:setSize(CCSizeMake(120, 50))
	touchPanel:setTouchEnabled(true)
	touchPanel:setDoubleClickEnabled(true)
	touchPanel:setDoubleClickGap(0.2)
	touchPanel:setSwallowTouch(false)
	touchPanel:setBackGroundColorType(TF_LAYOUT_COLOR_SOLID);
	touchPanel:setBackGroundColorOpacity(200);
	-- touchPanel:setBackGroundColor(ccc3(  255,   0,   0));
	touchPanel:setPosition(ccp(100, 0))
	touchPanel:setName("Test_Debug")
	-- touchPanel:setOpacity(100)
	-- touchPanel:addMEListener(TFWIDGET_DOUBLECLICK, __open)
	-- touchPanel:addChild(testDebuger.debugPanel)
	local textLabel = touchPanel:getChildByName("textLabel")
	if (textLabel == nil) then
		textLabel = TFTextArea:create()
		touchPanel:addChild(textLabel)
	end
	textLabel:setFontSize(15)
	textLabel:setAnchorPoint(ccp(0, 0))
	textLabel:setColor(ccc3(  0,   0,   0));
	textLabel:setName("textLabel")
	--
	local function checkStringNum(str)
		if type(str) == 'string' and (str[#str] == 'K' or str[#str] == 'k') then 
			str = str[{1, #str-1}]
		end
		return str
	end
	if (self.initFreeMem == nil) then
		self.initFreeMem = checkStringNum(TFDeviceInfo.getFreeMem())/1024
	end
	
	local function updateCounters()
		if (me.TextureCache.getTexturesMap == nil) then
			return
		end
		local allMem = checkStringNum(TFDeviceInfo.getTotalMem())
		local freeMem = checkStringNum(TFDeviceInfo.getFreeMem())
		local str = string.format("I:%.2fM-%.2fM\n", self.initFreeMem, (self.initFreeMem - (freeMem / 1024)))
		str = str..string.format('Mem: %dM/%dM \n', freeMem/1024, allMem/1024)
		--
		local tmap = me.TextureCache:getTexturesMap()
		local nLen = tmap:size()
		local keys = tmap:keys()

		local nUsed = 0
		local nMem = 0
		local nUsedMem = 0
		for i = 0, nLen - 1 do 
			local name = keys:at(i)
			local cs = name:getCString()
			local tex = tmap:objectForKey(name:getCString())
			local bpp = tex:bitsPerPixelForFormat()
			local bytes = tex:getPixelsWide() * tex:getPixelsHigh() * bpp / 8 / 1024
			nMem = nMem + bytes
			if tex:retainCount() > 1 then 
				nUsed = nUsed + 1 
				nUsedMem = nUsedMem + bytes
				-- IF_NOT((bytes / 1024) .. "   - "..cs.."\n")
			end
		end
		str = str..string.format("%.2fM/%.2fM", nUsedMem/1024, nMem/1024)
		if (self.addDebugLog) then
			touchPanel:setSize(CCSizeMake(120, 80))
			str = str.."\n"..(self.addDebugLog)
		end
		-- str = str.."\n"..(self.addDebugLog or "aa")
		if (textLabel and textLabel.setText) then
			textLabel:setText(str)
			local testSize = textLabel:getSize();
			local touchPanelSize = touchPanel:getSize();
			if (testSize.width > touchPanelSize.width) then
				touchPanel:setSize(CCSizeMake(testSize.width, 50))
			end
		end
	end
	updateCounters()
	self.__debug_layerTimer = TFDirector:addTimer(1000, -1, nil, function(dt)
		updateCounters()
	end)
end

function FightManager:GetTextureCacheMem()
	if (me.TextureCache.getTexturesMap == nil) then
		return 0
	end
	local tmap = me.TextureCache:getTexturesMap()
	local nLen = tmap:size()
	local keys = tmap:keys()

	local nUsed = 0
	local nMem = 0
	local nUsedMem = 0
	for i = 0, nLen - 1 do 
		local name = keys:at(i)
		local cs = name:getCString()
		local tex = tmap:objectForKey(name:getCString())
		local bpp = tex:bitsPerPixelForFormat()
		local bytes = tex:getPixelsWide() * tex:getPixelsHigh() * bpp / 8 / 1024
		nMem = nMem + bytes
		-- if tex:retainCount() > 1 then 
		-- 	nUsed = nUsed + 1 
		-- 	nUsedMem = nUsedMem + bytes
		-- end
	end
	return nMem

end
function FightManager:Debug_Log(p)
	if ( p == nil) then
		if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32) then
			local fileName = CCFileUtils:sharedFileUtils():getWritablePath().."\\log\\AAAA_";
			local date 		= os.date("*t", os.time())
			local timeStr 	= date.year.."-"..date.month.."-"..date.day .."--"..date.hour--.."_"..date.min.."_"
			-- local timeStr 	= date.year.."-"..date.month.."-"..date.day .."--"..date.hour.."_"..date.min.."_"..date.sec
			fileName = fileName..timeStr
			timeStr = "\n"..timeStr.."_"..date.min.."_"..date.sec.."\n"
			--
			local log = debug.traceback()
			--
			-- print('',fileName)
			
			-- Lua_writeFile(fileName, 'a+',timeStr, log)
			Lua_writeFile(fileName, 'a+', p)
			-- local USER32 = INIT_DALL("USER32", "user32.dll"); 
			-- local nRet = USER32.MessageBoxA( NULL, "出错啦！", "信息提示", 0 ); 
		end
		return true
	end
	return false
end
function FightManager:getFightRoundMgr()
	return fightRoundMgr
end

function FightManager:GetFightCurrActionCount()
	if (self.isReplayFight) then
		return fightReplayMgr.nCurrActionIndex or 1
	end
	if (self.isBattle) then
		return battleRoundMgr.nCurrActionIndex or 1
	end
	return fightRoundMgr.actionCount - 1
end
return FightManager:new()