--
-- Author: Zippo
-- Date: 2013-12-05 20:02:30
--

local fightRoleMgr  = require("lua.logic.fight.FightRoleManager")
local fightRoundMgr = require("lua.logic.fight.FightRoundManager")
local mapLayer  	= require("lua.logic.fight.MapLayer")
local fightPublic 	= require("lua.logic.fight.FightPublic")
local baseAction = require("lua.logic.fight.BaseFightAction")
local FightAction 	= class("FightAction", baseAction)

function FightAction:ctor(actionInfo)
	self.bQuick = false
	self.actionInfo = actionInfo
	self.attackerRole = fightRoleMgr:GetRoleByGirdIndex(actionInfo.attackerpos)
	assert(self.attackerRole, "attackerpos" .. actionInfo.attackerpos .. "not find")

	
	self.bNormalAttack = false
	local skillDisplayID = 0
	if actionInfo.skillid.skillId == 0 then -- 普通攻击
		skillDisplayID = self.attackerRole.normalAttackSkillID
		if self.actionInfo.triggerType == 12 and self.attackerRole.hitRoleDisPlay and self.attackerRole.hitRoleDisPlay ~= 0 then
		-- print("skillDisplayID--->>",skillDisplayID)
			-- print("self.attackerRole.skillDisplayID--->>",self.attackerRole.skillDisplayID)
			skillDisplayID = self.attackerRole.skillDisplayID
		end
		-- print("skillDisplayID--->>",skillDisplayID)
		self.bNormalAttack = true
		local buffDisplayID = self:GetBuffDisplayId()
		if buffDisplayID ~= 0 then
			skillDisplayID = buffDisplayID
		end
	end

	local skillInfo = BaseDataManager:GetSkillBaseInfo(actionInfo.skillid)
	if skillInfo ~= nil and skillInfo.target_type == 3 then -- 横排技能
		self.bRowAttack = true
	else
		self.bRowAttack = false
	end

	if skillInfo ~= nil then
		skillDisplayID = skillInfo.display_id
		if FightManager.isReplayFight and skillInfo.hidden_skill == 3 then
			self.attackerRole:addRoleAnger( - skillInfo.trigger_anger )
			self.actionInfo.bAngerManualAction = true
		end
	end

	self.skillDisplayInfo = SkillDisplayData:objectByID(skillDisplayID)
	-- print("skillDisplayID 0000000000---->>",skillDisplayID)
	if self.skillDisplayInfo == nil then
		-- print("playskill:skillDisplayID----------->"..skillDisplayID.."not find")
		local armatureID = self.attackerRole.armatureID
		if self.bNormalAttack then
			self.skillDisplayInfo = SkillDisplayData:objectByID(armatureID-10000)
		else
			self.skillDisplayInfo = SkillDisplayData:objectByID((armatureID-10000)*100+1)
		end

		if self.skillDisplayInfo == nil then
			self.skillDisplayInfo = SkillDisplayData:objectByID(9999)
		end
	end

	if self.skillDisplayInfo.needMoveSameRow == 1 then
		self.bRowAttack = true
	end

	-- print("playskill:----------->skillid:"..actionInfo.skillid.."---->displayid:"..self.skillDisplayInfo.id)

	self.hitEffTimerIDList = TFArray:new()
	self.showBuffDelayTimerList = TFArray:new()
	self.extraEffTimerIDList = TFArray:new()
	self.bEnemyAllDie = self:IsEnemyAllDie()
	if self.actionInfo.buffList and #self.actionInfo.buffList > 0 then
		for i=1,#self.actionInfo.buffList do
			local buff = self.actionInfo.buffList[i]
			local buffInfo = SkillBufferData:objectByID(buff[6])
			if buff and buffInfo and buffInfo.gain_type == 1 then
				local targetRole = fightRoleMgr:GetRoleByGirdIndex(buff[2])
				if (targetRole) then
					self:AddBuffToTarget(targetRole,targetRole,buff[6],buff[7],0)
				end
			end
		end
	end
	self.actionInfo.buffList = self.actionInfo.buffList or {}
	if not FightManager.isReplayFight then
		self.actionInfo.buffList = {}
	end
end

function FightAction:dispose()
	print("FightAction:dispose-->")
	if self.actionInfo.triggerType == 12 and self.attackerRole then
		self.attackerRole:showSelfDisplay()
	end

	if self.xuliEffTimerID then
		TFDirector:removeTimer(self.xuliEffTimerID)
		self.xuliEffTimerID = nil
	end
	if self.specilTimerID then
		TFDirector:removeTimer(self.specilTimerID)
		self.specilTimerID = nil
	end

	-- if self.attackEffTimerID then
	-- 	TFDirector:removeTimer(self.attackEffTimerID)
	-- 	self.attackEffTimerID = nil
	-- end
	if self.attackEffTimerID then
		for k,v in pairs(self.attackEffTimerID) do
			TFDirector:removeTimer(v)
		end
		self.attackEffTimerID = nil
	end
	if self.hitTimerID then
		TFDirector:removeTimer(self.hitTimerID)
		self.hitTimerID = nil
	end
	if self.hitXuliEffTimerID  then
		TFDirector:removeTimer(self.hitXuliEffTimerID )
		self.hitXuliEffTimerID  = nil
	end
	if self.attackSoundTimerID then
		TFDirector:removeTimer(self.attackSoundTimerID)
		self.attackSoundTimerID = nil
	end
	if self.hitSoundTimerID then
		TFDirector:removeTimer(self.hitSoundTimerID)
		self.hitSoundTimerID = nil
	end


	local buffDelayTimerNum = self.showBuffDelayTimerList:length()
	for i=1,buffDelayTimerNum do
		TFDirector:removeTimer(self.showBuffDelayTimerList:objectAt(i))
	end
	self.showBuffDelayTimerList:clear()

	local hitEffTimerNum = self.hitEffTimerIDList:length()
	for i=1,hitEffTimerNum do
		TFDirector:removeTimer(self.hitEffTimerIDList:objectAt(i))
	end
	self.hitEffTimerIDList:clear()

	local extraEffTimerNum = self.extraEffTimerIDList:length()
	for i=1,extraEffTimerNum do
		TFDirector:removeTimer(self.extraEffTimerIDList:objectAt(i))
	end
	self.extraEffTimerIDList:clear()

	-- self.actionInfo.buffList = {}
end

function FightAction:GetBuffDisplayId()
	if self.actionInfo.targetlist == nil or #self.actionInfo.targetlist == 0 then
		return 0
	end

	local targetInfo = self.actionInfo.targetlist[1]
	targetInfo.triggerBufferID = targetInfo.triggerBufferID or 0
	if targetInfo.triggerBufferID > 0 then
		local buffConfig = SkillLevelData:getBuffInfo( targetInfo.triggerBufferID , targetInfo.triggerBufferLevel)
		if buffConfig ~= nil then
			return buffConfig.skill_display
		end
	end

	return 0
end


function FightAction:ShowSkillNameEff()
	if self.bNormalAttack or self.attackerRole.ispet  then
		self:BeginAttack()
		return
	end
	if not self.attackerRole.logicInfo.bEnemyRole then
		TFDirector:currentScene().mapLayer:ChangeDark(true)
	end
	
	local skillInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	if skillInfo ~= nil and skillInfo.name ~= "" then
		TFDirector:currentScene().fightUiLayer:ShowSkillName(skillInfo.name, self.attackerRole.logicInfo.bEnemyRole)
	end
	TFAudio.playEffect("sound/effect/skill_ready.mp3", false)
	if skillInfo ~= nil and skillInfo.sound == 1 then
		RoleSoundData:playFightSoundByIndex(self.attackerRole.soundRoleId)
	end
	self.attackerRole:PlaySkillNameEffect()
end

--此处加BUFF有BUG，等跟后端对应再改--2018.7.24  此次BUG暂不修改（正常战斗BUFF加了#targetlist次，快速战斗只加一次）
function FightAction:AddAttackBuff()
	if self.actionInfo.targetlist == nil then
		return
	end

	for i=1,#self.actionInfo.targetlist do
		local targetInfo = self.actionInfo.targetlist[i]
		local targetRole = self:GetTargetRole(i)
		targetInfo.triggerBufferID = targetInfo.triggerBufferID or 0
		if targetInfo.triggerBufferID > 0 then
			local buffConfig = SkillLevelData:getBuffInfo( targetInfo.triggerBufferID , targetInfo.triggerBufferLevel)
			if buffConfig ~= nil and buffConfig.good_buff == 1 and not fightRoleMgr:IsSameSide({self.attackerRole, targetRole}) then
				if buffConfig.type ~= 56 then
					targetInfo.bHaveAddBuff = true
					local skillDisplay = self.skillDisplayInfo
					local showBuffDelayTime = skillDisplay.showBuffDelayTime
					if showBuffDelayTime == nil or showBuffDelayTime == 0 then
						if self:AddBuffToTarget(self.attackerRole,self.attackerRole, targetInfo.triggerBufferID,targetInfo.triggerBufferLevel) then
							self:AddBuffInfoToServer(self.attackerRole, self.attackerRole, targetInfo.triggerBufferID, 0)
						end
						return
					else
							
						local _showBuffDelayTimer = -1
						_showBuffDelayTimer = TFDirector:addTimer(showBuffDelayTime /FightManager.fightSpeed,1,nil,function ()
							if self:AddBuffToTarget(self.attackerRole,self.attackerRole, targetInfo.triggerBufferID,targetInfo.triggerBufferLevel) then
								self:AddBuffInfoToServer(self.attackerRole, self.attackerRole, targetInfo.triggerBufferID, 0)
							end
							if _showBuffDelayTimer then
								TFDirector:removeTimer(_showBuffDelayTimer)
								_showBuffDelayTimer = nil
							end
							return
						end)
						self.showBuffDelayTimerList:push(_showBuffDelayTimer)
					end
				end
			end
		end
	end
end

function FightAction:BeginAttack()
	local targetRole = self:GetTargetRole(1)
	self:AddAttackBuff()

	if self.actionInfo.triggerType == 12 and self.attackerRole.hitRoleDisPlay and self.attackerRole.hitRoleDisPlay ~= 0 then
		self.attackerRole:setTiHuanRole( self.attackerRole.hitRoleDisPlay )
	end

	if self.actionInfo.bBackAttack then
		self:ShowAttackAnim()
	elseif self.skillDisplayInfo.remote == 0 then
		self.attackerRole:MoveToRole(targetRole, self.skillDisplayInfo.moveDistance, self.skillDisplayInfo.beforeMoveAnim)
	elseif self.bRowAttack and self.attackerRole:IsSameRow(targetRole) == false then
		local pos = mapLayer.GetRowAttackPos(targetRole.logicInfo.posindex)
		self.attackerRole:MoveToPosition(pos.x, pos.y)
	elseif self.skillDisplayInfo.needMoveCenter then
		self.attackerRole:MoveToPosition(GameConfig.WS.width/2, GameConfig.WS.height/2-100)
	else
		self:ShowAttackAnim()
	end
end

function FightAction:onShowAttackAnimEnd()
	
end

function FightAction:ShowAttackerText()
	if self.actionInfo.bBackAttack and not self:isSkillAction() then
		self.attackerRole:ShowFightText("fanji", 0)
	elseif self.actionInfo.targetlist[1].activeEffect == 8 then
		self.attackerRole:ShowFightText("ceji", 0)
	end
end

function FightAction:ShowXuliEff()
	local skillDisplay = self.skillDisplayInfo
	local xuliEffID = skillDisplay.xuliEff
	if xuliEffID == nil or xuliEffID == 0 then
		return
	end

	local effStartTime = skillDisplay.xuliEffTime
	if effStartTime ~= nil and effStartTime > 0 then
		self.xuliEffTimerID = TFDirector:addTimer(effStartTime / FightManager.fightSpeed, 1, nil, 
		function() 
			TFDirector:removeTimer(self.xuliEffTimerID)
			self.xuliEffTimerID = nil
			self.attackerRole:PlaySkillEffect(xuliEffID, 0, skillDisplay.xuliEffOffsetX, skillDisplay.xuliEffOffsetY)
		end)
	else
		self.attackerRole:PlaySkillEffect(xuliEffID, 0, skillDisplay.xuliEffOffsetX, skillDisplay.xuliEffOffsetY)
	end
end

function FightAction:ShowAttackEff()
	local skillDisplay = self.skillDisplayInfo
	local attackList = skillDisplay.attackEff
	if attackList == nil or #attackList == 0 then
		return
	end
	-- for i=1,#attackList do
	for i,v in ipairs(attackList) do
		self:_ShowAttackEff(i)
	end
end

function FightAction:_ShowAttackEff(index)
	local skillDisplay = self.skillDisplayInfo
	local attackEffID = skillDisplay.attackEff[index]
	if attackEffID == 0 then
		return
	end
	local effStartTime = 0
	if skillDisplay.attackEffTime then
		effStartTime = skillDisplay.attackEffTime[index] or skillDisplay.attackEffTime[1]
	end
	if effStartTime ~= nil and effStartTime > 0 then
		self.attackEffTimerID = self.attackEffTimerID or {}
		self.attackEffTimerID[index] = TFDirector:addTimer(effStartTime / FightManager.fightSpeed, 1, nil, 
		function() 
			TFDirector:removeTimer(self.attackEffTimerID[index])
			self.attackEffTimerID[index] = nil
			local nTargetCount = #self.actionInfo.targetlist
			local attackEffType = skillDisplay.attackEffType[index] or skillDisplay.attackEffType[1]
			if attackEffType ~= 4 then
				nTargetCount = 1
			end

			
			local attackEffOffsetX = 0
			if skillDisplay.attackEffOffsetX then
				attackEffOffsetX = skillDisplay.attackEffOffsetX[index] or skillDisplay.attackEffOffsetX[1]
			end

			local attackEffOffsetY = 0
			if skillDisplay.attackEffOffsetY then
				attackEffOffsetY = skillDisplay.attackEffOffsetY[index] or skillDisplay.attackEffOffsetY[1]
			end
			local attackRotation = true
			if skillDisplay.attackRotation then
				attackRotation = skillDisplay.attackRotation[index] or skillDisplay.attackRotation[1]
			end

			local flyEffRotate = skillDisplay.flyEffRotate
		
			for i=1,nTargetCount do
				local targetInfo = self.actionInfo.targetlist[i]
				local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
				self.attackerRole:PlaySkillEffect(attackEffID, attackEffType,attackEffOffsetX, attackEffOffsetY,1,attackRotation,targetRole, flyEffRotate)
			end
		end)
	else
		local nTargetCount = #self.actionInfo.targetlist
		local attackEffType = skillDisplay.attackEffType[index] or skillDisplay.attackEffType[1]
		if attackEffType ~= 4 then
			nTargetCount = 1
		end

		
		local attackEffOffsetX = 0
		if skillDisplay.attackEffOffsetX then
			attackEffOffsetX = skillDisplay.attackEffOffsetX[index] or skillDisplay.attackEffOffsetX[1]
		end

		local attackEffOffsetY = 0
		if skillDisplay.attackEffOffsetY then
			attackEffOffsetY = skillDisplay.attackEffOffsetY[index] or skillDisplay.attackEffOffsetY[1]
		end
		local attackRotation = true
		if skillDisplay.attackRotation then
			attackRotation = skillDisplay.attackRotation[index] or skillDisplay.attackRotation[1]
		end

		local flyEffRotate = skillDisplay.flyEffRotate

		for i=1,nTargetCount do
			local targetInfo = self.actionInfo.targetlist[i]
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
			self.attackerRole:PlaySkillEffect(attackEffID, attackEffType,attackEffOffsetX, attackEffOffsetY,1,attackRotation,targetRole, flyEffRotate)
		end
	end
end

function FightAction:PlayAttackSound()
	local skillDisplay = self.skillDisplayInfo
	local attackSoundID = skillDisplay.attackSound
	if attackSoundID == nil or attackSoundID == 0 then
		return
	end

	local soundFile = "sound/skill/"..attackSoundID..".mp3"
	local soundStartTime = skillDisplay.attackSoundTime
	if soundStartTime ~= nil and soundStartTime > 0 then
		self.attackSoundTimerID = TFDirector:addTimer(soundStartTime / FightManager.fightSpeed, 1, nil, 
		function() 
			TFDirector:removeTimer(self.attackSoundTimerID)
			self.attackSoundTimerID = nil
			TFAudio.playEffect(soundFile, false)
		end)
	else
		TFAudio.playEffect(soundFile, false)
	end
end

function FightAction:PlayHitSound(hitIndex)
	local skillDisplay = self.skillDisplayInfo
	local hitSoundID = skillDisplay.hitSound
	if hitSoundID == nil or hitSoundID == 0 then
		return
	end
	local dieSound = nil
	if self.bEnemyAllDie and hitIndex == self.hitCount then
		if hitSoundID >= 11 and hitSoundID <= 15 then
			dieSound = "sound/skill/1_die.mp3"
		elseif hitSoundID >= 21 and hitSoundID <= 23 then
			dieSound = "sound/skill/2_die.mp3"
		elseif hitSoundID >= 31 and hitSoundID <= 33 then
			dieSound = "sound/skill/3_die.mp3"
		elseif hitSoundID >= 41 and hitSoundID <= 43 then
			dieSound = "sound/skill/4_die.mp3"
		end
	end

	local soundFile = "sound/skill/"..hitSoundID..".mp3"
	local soundStartTime = skillDisplay.hitSoundTime
	if soundStartTime ~= nil and soundStartTime > 0 then
		self.hitSoundTimerID = TFDirector:addTimer(soundStartTime / FightManager.fightSpeed, 1, nil, 
		function() 
			TFDirector:removeTimer(self.hitSoundTimerID)
			self.hitSoundTimerID = nil
			TFAudio.playEffect(soundFile, false)
			if dieSound ~= nil then
				TFAudio.playEffect(dieSound, false)
			end
		end)
	else
		TFAudio.playEffect(soundFile, false)
		if dieSound ~= nil then
			TFAudio.playEffect(dieSound, false)
		end
	end
end

function FightAction:showHitXuliEff()
	local skillDisplay = self.skillDisplayInfo
	local hitXuliEffID = skillDisplay.hitXuliEff
	if hitXuliEffID == nil or hitXuliEffID == 0 then
		self:ShowAllHit()
		return
	end

	local effStartTime = skillDisplay.hitXuliEffTimeDelay

	if effStartTime ~= nil and effStartTime > 0 then
		self.hitXuliEffTimerID = TFDirector:addTimer(effStartTime / FightManager.fightSpeed, 1, nil,
		function()
			TFDirector:removeTimer(self.hitXuliEffTimerID )
			self.hitXuliEffTimerID = nil
			self:_showHitXuliEff()
		end)
	else
		self:_showHitXuliEff()
	end
end
function FightAction:_showHitXuliEff()

	local skillDisplay = self.skillDisplayInfo
	local hitXuliEffID = skillDisplay.hitXuliEff

	local hitXuliEffType = skillDisplay.hitXuliEffType or 0 
	local effStartTime = skillDisplay.hitXuliEffTime


	 --0攻击者身上播放 1屏幕中心播放 2打横排 3直线飞行单体 4直线飞行竖排 5攻击者脚下播放 6我方阵容中心播放 7敌方阵容中心播放 8屏幕中心置顶 9我方阵容中心置顶播放 10敌方阵容中心置顶播放 
	 --13被攻击者脚下播放(排除已方)
	if hitXuliEffType == 0 or hitXuliEffType == 5 or hitXuliEffType == 13 then
		-- local nTargetCount = #self.actionInfo.targetlist
		-- for i=1,nTargetCount do
		-- 	local targetInfo = self.actionInfo.targetlist[i]
		for i,targetInfo in ipairs(self.actionInfo.targetlist) do
			if (targetInfo.effect ~= EnumFightHurtEffect.effect_10) then
				local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
				if targetRole ~= nil then
					if (hitXuliEffType ~= 13) then
						targetRole:PlaySkillEffect(hitXuliEffID, hitXuliEffType, skillDisplay.hitXuliEffOffsetX, skillDisplay.hitXuliEffOffsetY)
					elseif (hitXuliEffType == 13 and targetRole.logicInfo.bEnemyRole ~= self.attackerRole.logicInfo.bEnemyRole) then
						targetRole:PlaySkillEffect(hitXuliEffID, hitXuliEffType, skillDisplay.hitXuliEffOffsetX, skillDisplay.hitXuliEffOffsetY)
					end
				elseif (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32) then
					assert(false, "targetpos" .. targetInfo.targetpos .. "not find")
				end
			end
		end
	else
		local targetInfo = self.actionInfo.targetlist[1]
		local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
		if targetRole ~= nil then
			targetRole:PlaySkillEffect(hitXuliEffID, hitXuliEffType, skillDisplay.hitXuliEffOffsetX, skillDisplay.hitXuliEffOffsetY)
		else
			assert(false, "targetpos" .. targetInfo.targetpos .. "not find")
		end
	end
	self:ShowAllHit()
end


function FightAction:ShowAllHit()
	self:GetHitNumber()

	-- for i=1, self.hitCount do
	-- 	local hitTime = self.skillDisplayInfo["hitAnimTime"..i]
	-- 	if hitTime ~= nil and hitTime >= 0 then
	-- 		if hitTime > 0 then
	-- 			local hitTimerID = TFDirector:addTimer(hitTime / FightManager.fightSpeed, 1, nil, 
	-- 			function()
	-- 				print("self:ShowHit(i) ====111")
	-- 				TFDirector:removeTimer(hitTimerID)
	-- 				hitTimerID = nil
	-- 				self:ShowHit(i)
	-- 				self:PlayHitSound(i)
	-- 			end)

	-- 			self.hitTimerIDList:push(hitTimerID)
	-- 		else
	-- 			print("self:ShowHit(i) ====222")
	-- 			self:ShowHit(i)
	-- 			self:PlayHitSound(i)
	-- 		end
	-- 	end
	-- end
	self.hitAnimCompleteRoleNum = 0
	local temp_num = 1
	local function showhitDisplay(skillDisplayId)
		if (skillDisplayId ~= self.skillDisplayInfo.id) then
			return
		end
		if temp_num > self.hitCount then
			return
		end
		
		local oldtime = 0
		if temp_num ~= 1 then
			oldtime = self.skillDisplayInfo["hitAnimTime"..(temp_num-1)] or 0
		end
		local hitTime = self.skillDisplayInfo["hitAnimTime"..temp_num] or 0
		local  temp_time = hitTime - oldtime
		if temp_time ~= nil and temp_time >= 0 then
			if temp_time > 0 then
				if (self.hitTimerID) then
					TFDirector:removeTimer(self.hitTimerID)
					self.hitTimerID = nil
				end
				self.hitTimerID = TFDirector:addTimer(temp_time / FightManager.fightSpeed, 1, nil,
				function()
					TFDirector:removeTimer(self.hitTimerID)
					self.hitTimerID = nil
					self:ShowHit(temp_num)
					self:PlayHitSound(temp_num)
					temp_num = temp_num + 1
					showhitDisplay(self.skillDisplayInfo.id)
				end)
			
			else
				self:ShowHit(temp_num)
				self:PlayHitSound(temp_num)
				temp_num = temp_num + 1
				showhitDisplay(self.skillDisplayInfo.id)
			end
		end
	end
	showhitDisplay(self.skillDisplayInfo.id)
	self:showYuanHuDisplay()
end

function FightAction:GetHitCount()
	self.hitCount = 0
	local nMaxHitCount = 10
	for i=1,nMaxHitCount do
		local hitTime = self.skillDisplayInfo["hitAnimTime"..i]
		if hitTime ~= nil and hitTime >= 0 then
			if i > 1 then
				local preTime = self.skillDisplayInfo["hitAnimTime"..i-1]
				if hitTime <= preTime then
					assert(false)
					break
				end
			end

			self.hitCount = self.hitCount + 1
		end
	end
end

function FightAction:ShowHitEff(targetRole, targetIndex)
	if targetRole == nil then
		return
	end
	local hitEffList = self.skillDisplayInfo.hitEff
	if hitEffList == nil or #hitEffList == 0 then
		return
	end
	for i=1,#hitEffList do
		self:_ShowHitEff(targetRole,i,targetIndex)
	end
end

function FightAction:_ShowHitEff(targetRole,index,targetIndex )
	local skillDisplay = self.skillDisplayInfo
	local hitEffID = skillDisplay.hitEff[index]
	if hitEffID == 0 then
		return
	end
	local effStartTime = 0
	if skillDisplay.hitEffTime then
		effStartTime = skillDisplay.hitEffTime[index] or skillDisplay.hitEffTime[1]
	end

	local hitEffType = 0
	if skillDisplay.hitEffType then
		hitEffType = skillDisplay.hitEffType[index] or skillDisplay.hitEffType[1]
	end
	local hitEffOffsetX = 0
	if skillDisplay.hitEffOffsetX then
		hitEffOffsetX = skillDisplay.hitEffOffsetX[index] or skillDisplay.hitEffOffsetX[1]
	end
	local hitEffOffsetY = 0
	if skillDisplay.hitEffOffsetY then
		hitEffOffsetY = skillDisplay.hitEffOffsetY[index] or skillDisplay.hitEffOffsetY[1]
	end
	local effectScale = 1
	if skillDisplay.effectScale then
		_effectScale = skillDisplay.effectScale[targetIndex] or skillDisplay.effectScale[1]
		if type(_effectScale) == "table" then
			effectScale = _effectScale[index] or _effectScale[1]
		else
			effectScale = tonumber(_effectScale)
		end
	end
	local hitRotation = true
	if skillDisplay.hitRotation then
		hitRotation = skillDisplay.hitRotation[targetIndex] or skillDisplay.hitRotation[1]
	end
	if effStartTime ~= nil and effStartTime > 0 then
		local effTimerID = -1
		effTimerID = TFDirector:addTimer(effStartTime / FightManager.fightSpeed, 1, nil, 
		function() 
			TFDirector:removeTimer(effTimerID)
			effTimerID = nil

			targetRole:PlaySkillEffect(hitEffID, hitEffType, hitEffOffsetX, hitEffOffsetY,effectScale,hitRotation)
		end)
		self.hitEffTimerIDList:push(effTimerID)
	else
		targetRole:PlaySkillEffect(hitEffID, hitEffType, hitEffOffsetX, hitEffOffsetY,effectScale,hitRotation)
	end
end

function FightAction:showYuanHuDisplay()
	-- local nTargetCount = #self.actionInfo.targetlist
	-- for i=1,nTargetCount do
	-- 	local targetInfo = self.actionInfo.targetlist[i]
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
		if targetInfo.effect == 9 then
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
			-- local _targetInfo = self.actionInfo.targetlist[targetInfo.activeEffect]
			local helpTargetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.activeEffect)
			local movePos = helpTargetRole:getPosition()
			
			if (targetInfo.activeEffectValue and targetInfo.activeEffectValue == EnumFightActiveEffectType.effect_68) then
				helpTargetRole:addYuanHuEffect()
				movePos = targetRole:getPosition()
			end
			targetRole:PlayYuanHuAnim(movePos)
		end
	end
end


function FightAction:ShowExtraBuffEff(targetRole, targetIndex)
	if targetRole == nil then
		return
	end
	if self.skillDisplayInfo.extraShowHit then
		self:ShowHitEff(targetRole, targetIndex)
		return
	end

	local extraEffList = self.skillDisplayInfo.extraEff
	if extraEffList == nil or #extraEffList == 0 then
		return
	end
	-- for i=1,#extraEffList do
	for i,v in ipairs(extraEffList) do
		self:_ShowExtraEff(targetRole,i)
	end
end

function FightAction:_ShowExtraEff(targetRole,index )
	local skillDisplay = self.skillDisplayInfo
	local extraEffID = skillDisplay.extraEff[index]
	if extraEffID == 0 then
		return
	end
	local effStartTime = 0
	if skillDisplay.extraEffTime then
		effStartTime = skillDisplay.extraEffTime[index] or skillDisplay.extraEffTime[1]
	end

	local extraEffType = 0
	if skillDisplay.extraEffType then
		extraEffType = skillDisplay.extraEffType[index] or skillDisplay.extraEffType[1]
	end
	local extraEffOffsetX = 0
	if skillDisplay.extraEffOffsetX then
		extraEffOffsetX = skillDisplay.extraEffOffsetX[index] or skillDisplay.extraEffOffsetX[1]
	end
	local extraEffOffsetY = 0
	if skillDisplay.extraEffOffsetY then
		extraEffOffsetY = skillDisplay.extraEffOffsetY[index] or skillDisplay.extraEffOffsetY[1]
	end

	if effStartTime ~= nil and effStartTime > 0 then
		local effTimerID = -1
		effTimerID = TFDirector:addTimer(effStartTime / FightManager.fightSpeed, 1, nil, 
		function() 
			TFDirector:removeTimer(effTimerID)
			effTimerID = nil

			targetRole:PlaySkillEffect(extraEffID, extraEffType, extraEffOffsetX, extraEffOffsetY)
		end)
		self.extraEffTimerIDList:push(effTimerID)
	else
		targetRole:PlaySkillEffect(extraEffID, extraEffType, extraEffOffsetX, extraEffOffsetY)
	end
end


--被动效果:反弹5 反击6 化解7 复活9 免疫12 受击加血50 表现
function FightAction:ShowPassiveEffect(targetInfo)
	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	if targetRole == nil then
		return
	end

	local effect = targetInfo.passiveEffect
	-- local effectValue = targetInfo.passiveEffectValue
	if (effect) then
		fightPublic:FightPassiveEffect(effect, false, self.attackerRole, targetRole , targetInfo, self)
	end
end


--主动效果:吸怒1 减敌怒2 增己怒3 吸血4 侧击8 净化10 致死11 七伤拳21 表现
function FightAction:ShowActiveEffect(targetInfo)
	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	if targetRole == nil then
		return
	end

	local effect = targetInfo.activeEffect
	-- local effectValue = targetInfo.activeEffectValue
	if (effect) then
		fightPublic:FightActionEffect(effect, false, self.attackerRole, targetRole , targetInfo, self.actionInfo)
	end
	--伤害加深不可以占用主动效果，使用新增的deepHurtType字段判定
	local deepHurtType = targetInfo.deepHurtType
	if deepHurtType then
		if EnumFightDeepHurtEffectMap[deepHurtType] then
			targetRole:ShowEffectName(EnumFightDeepHurtEffectMap[deepHurtType])
		end
	end
end


function FightAction:OnRoleHitAnimComplete(roleIndex)
	if self.hitAnimCompleteRoleNum == nil then
		return
	end
	local targetNum = #self.actionInfo.targetlist
	local addCount = 0
	if (roleIndex and self.hitAnimCount) then
		addCount = self.hitAnimCount[roleIndex] or 0
		self.hitAnimCount[roleIndex] = nil
	end
	self.hitAnimCompleteRoleNum = self.hitAnimCompleteRoleNum + 1 + addCount
	if self.hitAnimCompleteRoleNum == targetNum then
		self.hitAnimCount = nil
		self.hitAnimCompleteRoleNum = nil
		self:ShowActiveEffectHitEnd()
		self:setHelpAttack()
		-- if self.actionInfo.triggerType ~= 5 then
			-- self:setHurtAddBloodAction()
		-- end

		self:addAttackNum()
		self:setAttackSkill()

		if self.actionInfo.bBackAttack and self.actionInfo.triggerType ~= 12 then
			local targetInfo = self.actionInfo.targetlist[1]
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
			if targetRole ~= nil then
				if targetRole:IsLive() then
					if self.attackerRole == targetRole then
						if self.attackerRole.attackAnimEnd then
							self.attackerRole:ReturnBack()
						else
							self.attackerRole.needReturnBack = true
						end
					else
							targetRole:ReturnBack()
					end
				else
						FightManager:OnActionEnd()
				end
			end
		else
			if self.attackerRole:IsLive() then
				if self.attackerRole.attackAnimEnd then
					self.attackerRole:ReturnBack()
				else
					self.attackerRole.needReturnBack = true
				end
			else
				FightManager:OnActionEnd()
			end
		end
	end
end


function FightAction:ShowXiXinDaFaEffect()

	-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	local skillInfo = SkillLevelData:objectByID(self.actionInfo.skillid)
	if skillInfo == nil then
		return
	end
	if skillInfo.effect ~= 22 then
		return
	end

	-- local nTargetCount = #self.actionInfo.targetlist
	-- for i=1,nTargetCount do
	-- 	local targetInfo = self.actionInfo.targetlist[i]
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
		if targetInfo.activeEffect == 22 and targetInfo.triggerBufferID ~= 0 then
			self.specilTimerID =  TFDirector:addTimer(300 / FightManager.fightSpeed, 1, nil,
				function()
					if self:AddBuffToTarget(self.attackerRole,self.attackerRole, tonumber(skillInfo.effect_value),self.actionInfo.skillid.level) then
						self:AddBuffInfoToServer(self.attackerRole, self.attackerRole, tonumber(skillInfo.effect_value), 0)
					end
					TFDirector:removeTimer(self.specilTimerID)
					self.specilTimerID = nil
				end)
			return
		end
	end
end

function FightAction:ShowQianKunDaNuoYi()
	-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	local skillInfo = SkillLevelData:objectByID(self.actionInfo.skillid)
	if skillInfo == nil then
		return
	end

	if skillInfo.effect == 20 then
		-- self.specilTimerID =  TFDirector:addTimer(3000 / FightManager.fightSpeed, 1, nil,
		-- function()
			local liveList = fightRoleMgr:GetAllLiveRole(self.attackerRole.logicInfo.bEnemyRole, nil, true)
			-- local liveNum = liveList:length()
			-- for i=1,liveNum do
			-- 	local role = liveList:objectAt(i)
			for role in liveList:iterator() do
				-- --治疗修正
				-- local fightEffectValue = self.attackerRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_BonusHealing) +
				-- 	role:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing)
				-- fightEffectValue = fightEffectValue/10000+1
				-- fightEffectValue = math.max(0,fightEffectValue)

				-- local _tempNum = skillInfo.effect_value * fightEffectValue + role:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing_Num)
				-- _tempNum = math.max(0,_tempNum)
				-- fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex,  math.floor(_tempNum))
				-- role:ShowFightText("",math.floor(_tempNum))
				role:ShowFightText("",skillInfo.effect_value)
			end
			-- TFDirector:removeTimer(self.specilTimerID)
			-- self.specilTimerID = nil
		-- end)
	end
end


function FightAction:AddBuffInBeginToServer(buffInfo)
	-- local buffInfo = {}
	-- buffInfo[1] = fromRole.logicInfo.posindex
	-- buffInfo[2] = targetRole.logicInfo.posindex
	-- buffInfo[3] = triggerBuffID
	-- buffInfo[4] = 0
	-- buffInfo[5] = 0
	-- buffInfo[6] = bufferID
	-- buffInfo[7] = 1

	local num = #self.actionInfo.buffList
	self.actionInfo.buffList[num+1] = buffInfo
end

function FightAction:pause()
	if self.xuliEffTimerID then
		TFDirector:stopTimer(self.xuliEffTimerID)
	end
	if self.attackEffTimerID then
		for k,v in pairs(self.attackEffTimerID) do
			TFDirector:stopTimer(v)
		end
	end
	if self.hitTimerID then
		TFDirector:stopTimer(self.hitTimerID)
	end
	if self.attackSoundTimerID then
		TFDirector:stopTimer(self.attackSoundTimerID)
	end
	if self.hitSoundTimerID then
		TFDirector:stopTimer(self.hitSoundTimerID)
	end
	if self.hitSoundTimerID then
		TFDirector:stopTimer(self.hitSoundTimerID)
	end
	local hitEffTimerNum = self.hitEffTimerIDList:length()
	for i=1,hitEffTimerNum do
		if self.hitEffTimerIDList:objectAt(i) then
			TFDirector:stopTimer(self.hitEffTimerIDList:objectAt(i))
		end
	end
	-- local extraEffTimerNum = self.extraEffTimerIDList:length()
	-- for i=1,extraEffTimerNum do
	for extra in self.extraEffTimerIDList:iterator() do
		if extra then
			TFDirector:stopTimer(extra)
		end
	end
end

function FightAction:setHitRole(targetRole)
	-- if self.actionInfo.bBackAttack then
	-- 	return
	-- end
	-- if self.actionInfo.triggerType
	targetRole.skillDisplayID = self.attackerRole.normalAttackSkillID 
	print(targetRole.logicInfo.name.."targetRole.skillDisplayID-->",targetRole.skillDisplayID)
	targetRole.hitRoleDisPlay = self.attackerRole.armatureID 
end

function FightAction:resume()
	if self.xuliEffTimerID then
		TFDirector:startTimer(self.xuliEffTimerID)
	end
	if self.attackEffTimerID then
		for k,v in pairs(self.attackEffTimerID) do
			TFDirector:startTimer(v)
		end
	end
	if self.hitTimerID then
		TFDirector:startTimer(self.hitTimerID)
	end
	if self.attackSoundTimerID then
		TFDirector:startTimer(self.attackSoundTimerID)
	end
	if self.hitSoundTimerID then
		TFDirector:startTimer(self.hitSoundTimerID)
	end
	-- local hitEffTimerNum = self.hitEffTimerIDList:length()
	-- for i=1,hitEffTimerNum do
	for hitEff in self.hitEffTimerIDList:iterator() do
		if hitEff then
			TFDirector:startTimer(hitEff)
		end
	end
	-- local extraEffTimerNum = self.extraEffTimerIDList:length()
	-- for i=1,extraEffTimerNum do
	for extraEffect in self.extraEffTimerIDList:iterator() do
		if extraEffect then
			TFDirector:startTimer(extraEffect)
		end
	end
end

--闪避
function FightAction:ShowHitEffect_3(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	if hitIndex == 1 then
		targetRole:ShowFightText("shanbi", 0)
		if self.actionInfo.bBackAttack == nil or self.actionInfo.bBackAttack == false then
			targetRole:DoAvoidAction()
			self:showTriggerSkill(targetInfo)
		end
		self:setHitRole(targetRole)
	end

	if bLastHit then
		if targetRole:GetBuffByType(84) then
			targetRole:OnBuffTriggerByType(84)
		end
		self:ShowPassiveEffect(targetInfo)
		self:OnRoleHitAnimComplete()
	end
	return needAddRedAnger,needRemoveIndex
end
--治疗加血
function FightAction:ShowHitEffect_4(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = (true and not targetInfo.isExtra)
	if (self.actionInfo.bHaveTarget) then
		needAddRedAnger = false
	end
	if targetInfo.hurtList[hitIndex] then
		if (targetRole:getCurrHp(true) > 0) then
			fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurtList[hitIndex])
			targetRole:ShowFightText("", math.floor(targetInfo.hurtList[hitIndex]))
		else
			-- if (targetInfo.passiveEffect == EnumFightPassiveEffectType.effect_56) then
				targetInfo.hurt = 0
			-- end
		end
	end
	if not targetInfo.isExtra then
		self:ShowHitEff(targetRole, i - needRemoveIndex)
	end

	if hitIndex == 1 then
		self:ShowActiveEffect(targetInfo)
		self:ShowPassiveEffect(targetInfo)
	end

	if bLastHit then
		targetInfo.triggerBufferID = targetInfo.triggerBufferID or 0
		if targetInfo.triggerBufferID > 0 and targetInfo.bHaveAddBuff ~= true then
			local buffConfig = SkillLevelData:getBuffInfo( targetInfo.triggerBufferID , targetInfo.triggerBufferLevel)
			if buffConfig ~= nil then
				if self:AddBuffToTarget(self.attackerRole, targetRole, targetInfo.triggerBufferID, targetInfo.triggerBufferLevel,targetInfo.hurt) then
					self:AddBuffInfoToServer(self.attackerRole, targetRole, targetInfo.triggerBufferID, 0)
				end
			end
		end
		--
		if ((i - needRemoveIndex) == 1) then
			local skillInfo = targetRole:GetTriggerBySkillHurtType(self.attackerRole.skillID, EnumFightTriggerHurtType.type_18, false)
			if (skillInfo) then
				self.attackerRole:addTriggerSkillCount(self.attackerRole.skillID.skillId, -1)
			end
		end
		--
		self:showTriggerSkill(targetInfo)
		self:OnRoleHitAnimComplete()
	end
	return needAddRedAnger,needRemoveIndex
end

--净化，去除目标所有减益buff 
function FightAction:ShowHitEffect_5(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	if not targetInfo.isExtra then
		self:ShowHitEff(targetRole, i - needRemoveIndex)
	end
	if hitIndex == 1 then
		targetRole:CleanBuff(self.attackerRole)
		self:ShowActiveEffect(targetInfo)
	end

	if bLastHit then
		self:showTriggerSkill(targetInfo)
		self:OnRoleHitAnimComplete()
	end
	return needAddRedAnger,needRemoveIndex
end

--乾坤挪移 
function FightAction:ShowHitEffect_6(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	-- needAddRedAnger = true
	if hitIndex == 1 then
		fightRoundMgr:SetDzxyAttackAction(targetRole, self.attackerRole, targetInfo.hurt)
		targetRole:ShowFightText("shanbi", 0)
		targetRole:DoAvoidAction()
		targetRole:OnBuffTriggerByType(27)
		targetInfo.hurt = 0
	end

	if bLastHit then
		self:OnRoleHitAnimComplete()
	end
	return needAddRedAnger,needRemoveIndex
end

--额外的加buff 
function FightAction:ShowHitEffect_8(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	if targetRole:IsLive() then
		if bLastHit then
			self:ShowExtraBuffEff(targetRole, i - needRemoveIndex)
			targetInfo.triggerBufferID = targetInfo.triggerBufferID or 0
			if targetInfo.triggerBufferID > 0 and targetInfo.bHaveAddBuff ~= true and bLastHit then
				local buffConfig = SkillLevelData:getBuffInfo( targetInfo.triggerBufferID , targetInfo.triggerBufferLevel)
				if buffConfig ~= nil then
					if self:AddBuffToTarget(self.attackerRole, targetRole, targetInfo.triggerBufferID, targetInfo.triggerBufferLevel,targetInfo.hurt) then
						self:AddBuffInfoToServer(self.attackerRole, targetRole, targetInfo.triggerBufferID, 0)
					end
				end
			end
			self:OnRoleHitAnimComplete()
		end
	else
		table.remove(self.actionInfo.targetlist , i - needRemoveIndex)
		needRemoveIndex = needRemoveIndex + 1
	end
	return needAddRedAnger,needRemoveIndex
end

function FightAction:ShowHitEffect_9(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	if hitIndex == 1 then
		local bBezier = false
		targetRole:OnBuffTrigger(6)
		fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurt)
		if targetRole.isYuanHuAction then
			if (targetRole:GetTriggerBySkillHurtType(targetRole.skillID, EnumFightTriggerHurtType.type_18, false)) then
				targetRole:addTriggerSkillCount(targetRole.skillID.skillId, 1)
				--targetRole:addYuanHuEffect()
			end
			targetRole:ShowFightText("", targetInfo.hurt, false, false, bBezier)
		else
			targetRole:ShowFightText("", targetInfo.hurt, false, true, bBezier)
		end
		self:ShowPassiveEffect(targetInfo)
		self:showTriggerSkill(targetInfo)
	end
	return needAddRedAnger,needRemoveIndex
end

--标记伤害
function FightAction:ShowHitEffect_10(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	local bBezier = false
	-- fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurt)
	local isTemp = true
	if (hitIndex == 1) then
		if (targetInfo.tagBuffId) then
			if (not targetRole:IsLive() or not targetRole:GetBuffByType(targetInfo.tagBuffId)) then
				table.remove(self.actionInfo.targetlist , i - needRemoveIndex)
				needRemoveIndex = needRemoveIndex + 1
				isTemp = false
			end
		end
	end
	if (isTemp) then
		targetRole:ShowFightText("", targetInfo.hurtList[hitIndex], false, true, bBezier)
		if bLastHit then
			self:ShowPassiveEffect(targetInfo)
			self:OnRoleHitAnimComplete()
		end
	else
		--死亡移除时不应该再调用 OnRoleHitAnimComplete 不然会卡住
		-- if bLastHit then
		-- 	self:OnRoleHitAnimComplete()
		-- end
	end
	return needAddRedAnger,needRemoveIndex
end

 --治疗加血 
function FightAction:ShowHitEffect_11(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	if hitIndex == 1 then
		targetRole:fuHuoActionEnd()
	end
	-- fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurtList[hitIndex])
	targetRole:ShowFightText("", math.floor(targetInfo.hurtList[hitIndex]))
	if not targetInfo.isExtra then
		self:ShowHitEff(targetRole, i - needRemoveIndex)
	end

	if hitIndex == 1 then
		self:ShowActiveEffect(targetInfo)
	end

	if bLastHit then
		targetInfo.triggerBufferID = targetInfo.triggerBufferID or 0
		if targetInfo.triggerBufferID > 0 and targetInfo.bHaveAddBuff ~= true then
			local buffConfig = SkillLevelData:getBuffInfo( targetInfo.triggerBufferID , targetInfo.triggerBufferLevel)
			if buffConfig ~= nil then
				if self:AddBuffToTarget(self.attackerRole, targetRole, targetInfo.triggerBufferID, targetInfo.triggerBufferLevel,targetInfo.hurt) then
					self:AddBuffInfoToServer(self.attackerRole, targetRole, targetInfo.triggerBufferID, 0)
				end
			end
		end
		TFDirector:currentScene().fightUiLayer:OnFightRoleReLive(targetRole)
		self:showTriggerSkill(targetInfo)
		--
		fightRoleMgr:refreshMaxHp()
		self:OnRoleHitAnimComplete()
		
	end
	return needAddRedAnger,needRemoveIndex
end

function FightAction:ShowHitEffect_12(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	if (hitIndex == 1) then
		self:ShowActiveEffect(targetInfo)
		--西施选中角色放技能需要在西施Action之后才能加入
		if (self.actionInfo.attackerpos ~= targetInfo.targetpos) then
			fightRoundMgr:XiShiInitiativeSkill(self.actionInfo.skillid, targetRole)
		end
	end
	self:ShowHitEff(targetRole, i - needRemoveIndex)
	self:OnRoleHitAnimComplete()
	return needAddRedAnger,needRemoveIndex
end

function FightAction:ShowHitEffect_13(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	targetRole:ShowFightText("", math.floor(targetInfo.hurtList[hitIndex]))
	local haveBuff = targetRole:GetBuffByType(EnumFightBufferType.type_97)
	if (haveBuff) then
		local enemyBuffTypeList1 	= {EnumFightBufferType.type_98}
		fightRoleMgr:RemoveRoleBuff(targetRole.logicInfo.bEnemyRole, enemyBuffTypeList1)
	end
	if not targetInfo.isExtra then
		self:ShowHitEff(targetRole, i - needRemoveIndex)
	end
	self:OnRoleHitAnimComplete()
	return needAddRedAnger,needRemoveIndex
end

--酒桶召唤
function FightAction:ShowHitEffect_14(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	if (skillBaseInfo and skillBaseInfo.type == EnumFightSkillType.type_13) then
		local skillInfo2 = SkillLevelData:objectByID(self.actionInfo.skillid)
		if FightManager.isReplayFight then
			if (FightManager.fightBeginInfo and (not FightManager.fightBeginInfo.bSkillShowFight)) then
				if (not fightRoleMgr:IsSelfTeam(targetInfo.targetpos, targetInfo.activeEffectValue)) then
					targetInfo.activeEffectValue = fightRoleMgr:GetConverterTeam(targetInfo.activeEffectValue)
				end
			end
		end
		FightManager:addNewRole(skillBaseInfo.buff_id, targetInfo.activeEffectValue, self.attackerRole, skillInfo2.effect_value)
		if #fightRoundMgr.permanentBufList > 0 then
			for _,permanentBuff in ipairs(fightRoundMgr.permanentBufList) do
				if permanentBuff then
					self:AddBuffInBeginToServer(permanentBuff)
				end
			end
			fightRoundMgr.permanentBufList = {}
		end
		if not targetInfo.isExtra then
			targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.activeEffectValue)
			if (targetRole) then
				self:ShowHitEff(targetRole, i - needRemoveIndex)
			end
		end
	end
	self:OnRoleHitAnimComplete()
	return needAddRedAnger,needRemoveIndex
end


function FightAction:ShowHitEffect_15(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	-- needAddRedAnger = true
	targetRole:ShowFightText("", math.floor(targetInfo.hurtList[hitIndex]))
	--
	self:ShowBuffPassiveEffect(targetRole)
	self:OnRoleHitAnimComplete()
	return needAddRedAnger,needRemoveIndex
end

--治疗加净化
function FightAction:ShowHitEffect_16(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	if hitIndex == 1 then
		targetRole:CleanBuff(self.attackerRole)
	end
	needAddRedAnger, needRemoveIndex = self:ShowHitEffect_4(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger,needRemoveIndex
end

--普通受击和暴击 7:主动加buff
function FightAction:ShowHitEffect_7(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return self:ShowHitEffect_1(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
end

function FightAction:ShowHitEffect_2(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return self:ShowHitEffect_1(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
end

function FightAction:ShowHitEffect_1(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	local fightText = ""
	local bBezier = false
	if targetInfo.effect == 2 then
		fightText = "baoji"
	elseif bHurtSkill then
		bBezier = true
	end

	if (hitIndex == 1 and self.actionInfo.triggerType ~= 5) then
		self:ShowActiveEffect(targetInfo)
	end
	
	fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurtList[hitIndex])
	if targetInfo.passiveEffect == 25 or targetInfo.passiveEffect == 37 or targetInfo.passiveEffect == EnumFightActiveEffectType.effect_82 then
		targetRole:ShowFightText(fightText, 0, false, false, bBezier)
	else
		targetRole:ShowFightText(fightText, targetInfo.hurtList[hitIndex], false, false, bBezier)
	end
	if hitIndex > 1 and self.skillDisplayInfo.hitEffShowOnce or targetInfo.isExtra then
	else
		self:ShowHitEff(targetRole, i - needRemoveIndex)
	end

	targetInfo.triggerBufferID = targetInfo.triggerBufferID or 0
	if targetInfo.triggerBufferID > 0 and targetInfo.bHaveAddBuff ~= true and bLastHit then
		local buffConfig = SkillLevelData:getBuffInfo( targetInfo.triggerBufferID , targetInfo.triggerBufferLevel)
		if buffConfig ~= nil then
			if buffConfig.type ~= 56 then
				if targetInfo.passiveEffect and targetInfo.passiveEffect == 27 and buffConfig.type ~= EnumFightBufferType.type_512 then
					if self:AddBuffToTarget( targetRole , self.attackerRole, targetInfo.triggerBufferID, targetInfo.triggerBufferLevel,targetInfo.hurt) then
						self:AddBuffInfoToServerByFanTan( targetRole, self.attackerRole,targetInfo.triggerBufferID, 0)
					end
				else
					if self:AddBuffToTarget(self.attackerRole, targetRole, targetInfo.triggerBufferID, targetInfo.triggerBufferLevel,targetInfo.hurt) then
						self:AddBuffInfoToServer(self.attackerRole, targetRole, targetInfo.triggerBufferID, 0)
					end
				end 
			else
				if self:AddBuffToTarget(targetRole, targetRole, targetInfo.triggerBufferID, targetInfo.triggerBufferLevel,targetInfo.hurt) then
					self:AddBuSiBuffInfoToServer(targetRole, targetRole, targetInfo.triggerBufferID, 0)
				end
			end
		end
	end

	self:ShowHitEffect_fanzhi(targetInfo, targetRole, bLastHit)

	if bLastHit then
		self:ShowPassiveEffect(targetInfo)
		self:showTriggerSkill(targetInfo)
		self:setHitRole(targetRole)
		--
		if bHurtSkill then
			self:ShowBuffPassiveEffect(targetRole)
		end
	end

	if bHurtSkill and not self.bNormalAttack and not self.attackerRole.logicInfo.bEnemyRole then
		if self.skillDisplayInfo.shake ~= nil then
			local shake = self.skillDisplayInfo.shake
			TFDirector:currentScene().mapLayer:Shake(shake,shake)
		else
			if self.skillDisplayInfo.remote == 0 then
				TFDirector:currentScene().mapLayer:Shake(6,6)
			else
				TFDirector:currentScene().mapLayer:Shake(3,3)
			end
		end
	end

	if bHurtSkill then
		if (bLastHit) then
			self.hitAnimCount = self.hitAnimCount or {}
			self.hitAnimCount[targetInfo.targetpos] = self.hitAnimCount[targetInfo.targetpos] or -1
			self.hitAnimCount[targetInfo.targetpos] = self.hitAnimCount[targetInfo.targetpos] + 1
		end
		targetRole:PlayHitAnim(bLastHit)
	else
		if bLastHit then
			self:OnRoleHitAnimComplete()
		end
	end
	return needAddRedAnger,needRemoveIndex
end

--攻击动作完成后逻辑处理
function FightAction:AllHitEndTargetLogic()
	-- for i, targetInfo in ipairs(self.actionInfo.targetlist) do
	-- 	self:HitEndTargetLogic(targetInfo)
	-- end
	-- --倒序是因为可能出现多次复活
	-- local nTargetLen = #self.actionInfo.targetlist
	-- for i=nTargetLen,1,-1 do
	-- 	self:HitEndTargetLogic(self.actionInfo.targetlist[i])
	-- end
	self:HitEndTargetReLive()
end


function FightAction:ShowHitEffect_fanzhi(targetInfo, targetRole, bLastHit)
	if (not targetRole:IsLive()) then
		return
	end
	local fanzhiBuffType = {28,38,39,65,88,91, EnumFightBufferType.type_507}
	if bLastHit and self.actionInfo.triggerType ~= 5 and targetInfo.effect ~= 7 and not self.attackerRole.ispet and not targetInfo.isExtra then
		local haveBuffList = targetRole:GetBuffListByType(fanzhiBuffType)
		-- for i=1,#fanzhiBuffType do
			-- local buff_type = fanzhiBuffType[i]
		for i,buff_type in ipairs(fanzhiBuffType) do
			local canFanzhi = true
			if (self.bNormalAttack) then
				if (buff_type == 39) then
					canFanzhi = false
				end
			else
				if (buff_type == 38) then
					canFanzhi = false
				end
			end
			if (buff_type == EnumFightBufferType.type_507) then
				if ((self.actionInfo.bManualAction or self.actionInfo.bAngerManualAction) and targetRole.logicInfo.bEnemyRole ~= self.attackerRole.logicInfo.bEnemyRole) then
				else
					canFanzhi = false
				end
			end
		
			if canFanzhi then
				local hitBuff = haveBuffList[buff_type]--targetRole:GetBuffByType(buff_type)
				if hitBuff ~= nil and hitBuff.bValid then
					if not FightManager.isReplayFight then			
						local buff_rate = self:CalculateInBufferTriggerRate(self.attackerRole, targetRole, hitBuff.config)
						local random = math.random(1, 10000)
						if random <= buff_rate then
							local _trigger = true
							local bufferInfo = SkillBufferData:objectByID(tonumber(hitBuff.config.value))
							local immuneNum = 0
							if bufferInfo then
								local _random = math.random(1, 10000)
								if (buff_type == EnumFightBufferType.type_507) then
									immuneNum = targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune, bufferInfo.type)
									if immuneNum and _random <= immuneNum then
										targetRole:ShowEffectName("mianyi")
									else
										if self:AddBuffToTarget(hitBuff.fromTarget, targetRole, tonumber(hitBuff.config.value), hitBuff.config.buff_level) then
											self:AddBuffInfoToServer(hitBuff.fromTarget, targetRole, tonumber(hitBuff.config.value), hitBuff.config.id)
										end
									end
									_trigger = false
								else
									immuneNum = self.attackerRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune, bufferInfo.type)
									if immuneNum and _random <= immuneNum then
										_trigger = false
										self.attackerRole:ShowEffectName("mianyi")
									end
								end
							end
							
							if _trigger == true then
								if (hitBuff.config.good_buff == 0 and self.attackerRole:TriggerPassiveEffect(EnumFightSpellEffect.effect_85, effectValue)) then
									self.attackerRole:ShowEffectName("jinghua")
								elseif self:AddBuffToTarget(targetRole,self.attackerRole, tonumber(hitBuff.config.value),hitBuff.config.buff_level) then
									self:AddBuffInfoToServer(targetRole, self.attackerRole, tonumber(hitBuff.config.value), hitBuff.config.id)
								end
							end
						end
					else
						if self.actionInfo.buffList and #self.actionInfo.buffList > 0 then
							for i=1,#self.actionInfo.buffList do
								local buff = self.actionInfo.buffList[i]
								if buff[6] == tonumber(hitBuff.config.value) and buff[2] == self.attackerRole.logicInfo.posindex and buff[1] == targetRole.logicInfo.posindex then
									self:AddBuffToTarget(targetRole,self.attackerRole, tonumber(hitBuff.config.value),hitBuff.config.buff_level)
								end
							end
						end
					end
					targetRole:OnBuffTriggerByType(buff_type)
				end
			end
		end
	end
end


function FightAction:OnActionStart()
	fightRoleMgr:OnActionStart()
end
return FightAction