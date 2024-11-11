--
-- Author: Zippo
-- Date: 2013-12-05 18:13:41
--
local fightRoleMgr 	= require("lua.logic.fight.FightRoleManager")
local fightPublic 	= require("lua.logic.fight.FightPublic")

local FightRoundManager = class("FightRoundManager")

function FightRoundManager:ctor()

	self.actionList             = TFArray:new()
	self.backAttackActionList   = TFArray:new()
	self.helpAttackActionList   = TFArray:new()
	self.helpAttackList         = TFArray:new()
	self.backAddAttackList      = TFArray:new()
	self.hurtAddBloodActionList = TFArray:new()
	--
	self:InitRoundData()
	--
	self.actionList:clear()
end

function FightRoundManager:dispose()
	if (self.updateTimerID) then
		TFDirector:removeTimer(self.updateTimerID)
		self.updateTimerID = nil
	end
	if self.currAction ~= nil then
		self.currAction:dispose()
		self.currAction = nil
	end
	self:InitRoundData()
	--
	-- self.actionList:clear()
end

function FightRoundManager:ExecuteFirstRound()
	------------测试代码-Begin--------------
	-- if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
	-- TFDirector:currentScene().fightUiLayer.btn_fastforward:setVisible(true)
	-- FightManager.fightBeginInfo.bGuideFight = false
	-- FightManager.isAutoFight = true
	-- FightManager:setTiaoGuo()
	--TFDirector:currentScene().fightUiLayer.stopBtn:setVisible(true)
	-- end
	------------测试代码-End----------------
	FightManager.bLeaveFight = nil
	self.actionCount = 1 			--动作次数
	self.nCurrRoundIndex = 1
	self.backAttackActionList:clear()
	self.helpAttackActionList:clear()
	self.hurtAddBloodActionList:clear()
	self.helpAttackList:clear()
	self.backAddAttackList:clear()
	self.bOverTime = false
	self.skillTrigerAttackAction = nil
	self.hurtAddBloodAction = nil
	self.endActionList = {}
	-- fightRoleMgr:OnRoundStart()
	if (FightManager.fightBeginInfo.fighttype == EnumFightType.HeroicBoss) then
		self.heroIcBossInfo = HeroListManager:getBossInfo()
		self:InitHeroicBossEffect()
	else
		self.heroIcBossInfo = nil
	end
	if fightRoleMgr:IsEnemyAllDie() then
		FightManager:EndFight(true)
		return
	elseif fightRoleMgr:IsSelfAllDie() then
		FightManager:EndFight(false)
		return
	end
	fightRoleMgr:OnAddPermanentBuf()

	if self:ExecuteManualAction() then
		return
	end
	-- if self:ExecuteAngerManualAction() then
	-- 	return
	-- end

	self:ExecuteNewAction()
end
function FightRoundManager:InitRoundData()
	---------------全局Begin------------------
	self.endActionList    = {}
	self.fuhuoActionList  = {}
	self.permanentBufList = {}
	--
	self.backAttackActionList:clear()
	self.helpAttackActionList:clear()
	self.hurtAddBloodActionList:clear()
	self.helpAttackList:clear()
	self.backAddAttackList:clear()
	-- self.actionList:clear()
	--
	self.skillTrigerAttackAction = nil
	self.hurtAddBloodAction      = nil
	self.currAction              = nil
	--
	self.bOverTime       = false
	self.endActionCount  = 0
	self.nCurrRoundIndex = 0
	self.actionCount     = 1 			--动作次数
	self.tagInsertIndex  = 0			--插队标识(剑神)
	---------------全局End------------------
	---------------中间逻辑生产的玩意Begin----------------
	self.heroIcBossInfo = nil
	---------------中间逻辑生产的玩意End------------------
end
function FightRoundManager:InitHeroicBossEffect()
	if (self.heroIcBossInfo)then
		local bossInedx = self.heroIcBossInfo.bossIndex + 9 - 1
		if(self.nCurrRoundIndex == self.heroIcBossInfo.minRound) then
			local bossRole = fightRoleMgr:GetRoleByGirdIndex(bossInedx)
			if (bossRole) then
				for i,effectName in ipairs(self.heroIcBossInfo.effectName) do
					local nDelayTime = 0
					if (i > 2) then
						nDelayTime = 800
					end
					bossRole:AddBossEffect(effectName, math.fmod(i,2), nDelayTime, i > 2)
				end
			end
		else
			local bossRole = fightRoleMgr:GetRoleByGirdIndex(bossInedx)
			if(bossRole and self.nCurrRoundIndex >= self.heroIcBossInfo.maxRound) then
				for i,effectName in ipairs(self.heroIcBossInfo.effectName) do
					bossRole:RemoveBossEffect(effectName)
				end
			end
		end
	end
end


function FightRoundManager:ExecuteNewRound()
	
	if self.nCurrRoundIndex >= FightManager.maxRoundNum then
		self.bOverTime = true
		FightManager:CleanFightAi()
		TFDirector:currentScene().fightUiLayer:PlayOverTimeEffect()
		return
	end
	if FightManager.callBackInterrupt then
		self.bOverTime = true
		TFDirector:currentScene().fightUiLayer:PlayOverTimeEffect()
		return
	end
	self.nCurrRoundIndex = self.nCurrRoundIndex + 1
	self:InitHeroicBossEffect()
	TFDirector:currentScene().fightUiLayer:SetCurrRoundNum(self.nCurrRoundIndex)
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 and VERSION_DEBUG == true then
		local str = " NewRoundIndex："..self.nCurrRoundIndex
		if (FightManager.log_fileName) then
			Lua_fightWriteFile(EnumFight_Log.HP, nil, str)
			Lua_fightWriteFile(EnumFight_Log.BUFF, nil, str)
		end
		
	end
	fightRoleMgr:OnRoundStart()
	fightRoleMgr:resetAllForbidAttackBuff()
	self:ExecuteNewAction()
end

function FightRoundManager:ExecutePetSkillAhowAction()

	-- fightRoleMgr:OnAddPermanentBuf()
	local attackRole = fightRoleMgr:GetRoleByGirdIndex(18)
	if attackRole == nil then
		self:OnActionEnd()
		return
	end

	local newAction              = {}
	newAction.bManualAction      = false 		--是否主动技能
	newAction.bAngerManualAction = false 	--是否神技
	newAction.unExecute          = true 				--是否可释放(还未执行)
	newAction.roundIndex         = self.nCurrRoundIndex
	newAction.attackerpos        = attackRole.logicInfo.posindex
	newAction.skillid            = attackRole.skillID
	newAction.bBackAttack        = false
	newAction.triggerType        = 0

	newAction.targetlist = self:GetPetActionTargetInfo(attackRole, newAction.skillid,true)
	if newAction.targetlist == nil or #newAction.targetlist == 0 then
		local targetEnemy = not attackRole.logicInfo.bEnemyRole
		if fightRoleMgr:CleanFrozenBuffRole(targetEnemy) then
			newAction.targetlist = self:GetPetActionTargetInfo(attackRole, newAction.skillid,true)
		end
		if newAction.targetlist == nil or #newAction.targetlist == 0 then
			return
		end
	end
	self.actionList:pushBack(newAction)
	self:ExecuteAction(newAction)
end

function FightRoundManager:ExecuteNewAction()
	if FightManager.callBackInterrupt then
		self.bOverTime = true
		TFDirector:currentScene().fightUiLayer:PlayOverTimeEffect()
		return
	end
	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bPetSkillShowFight then
		self:ExecutePetSkillAhowAction()
		return
	end

	local attackRole = fightRoleMgr:GetNormalAttackRole()
	if attackRole == nil then
		self:OnActionEnd()
		return
	end

	attackRole.haveAttack = true

	local newAction 				= {}
	newAction.bManualAction 		= false
	newAction.bAngerManualAction 	= false
	newAction.unExecute 			= true
	newAction.roundIndex 			= self.nCurrRoundIndex
	newAction.attackerpos 			= attackRole.logicInfo.posindex
	newAction.skillid 				= attackRole:GetNormalSkill()

	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bSkillShowFight then
		newAction.skillid = attackRole.skillID
	end
	local buffList = attackRole:GetBuffListByType({33, 10})
	if buffList[33] == nil and buffList[10] then
		newAction.skillid = {skillId = 0,level = 0}
	end

	newAction.targetlist = self:GetActionTargetInfo(attackRole, newAction.skillid)
	if newAction.targetlist == nil or #newAction.targetlist == 0 then
		local targetEnemy = not attackRole.logicInfo.bEnemyRole
		if fightRoleMgr:CleanFrozenBuffRole(targetEnemy) then
			newAction.targetlist = self:GetActionTargetInfo(attackRole, newAction.skillid)
		end

		if newAction.targetlist == nil or #newAction.targetlist == 0 then
			-- print("newAction.targetlist == nil    这里出来的话是不是有延迟啊。。")
			if (FightManager.fightBeginInfo.bSkillShowFight) then
				if (not self:SummonedRoleSkill(attackRole, newAction)) then
					--技能展示
					self:OnActionEnd()
				end
			else
				self:OnActionEnd()
				return
			end
		end
	end

	self.actionList:pushBack(newAction)

	self:ExecuteAction(newAction)
end

function FightRoundManager:ExecuteAction(actionInfo,tiaoguoChange)
	if actionInfo.bManualAction then
		fightRoleMgr:OnExecuteManualAction(actionInfo)
	end
	if actionInfo.bAngerManualAction then
		fightRoleMgr:OnExecuteAngerManualAction(actionInfo)
	end
	if not tiaoguoChange and (actionInfo.triggerType == nil or actionInfo.triggerType ~= 6 ) then 
		self:ChangeActionTarget(actionInfo)
		self:ChangeDefianceTarget(actionInfo)
	end

	actionInfo.unExecute = false
	if (self.currAction) then
		self.currAction:dispose()
	end
	if FightManager.isTiaoGuo then
		self.currAction = require("lua.logic.fight.FightOutAction"):new(actionInfo)
		FightManager:updateTimeOut()
	else
		self.currAction = require("lua.logic.fight.FightAction"):new(actionInfo)
	end
	TFDirector:currentScene().fightUiLayer:SetCurrActionNum(self.actionCount)
	self.actionCount = self.actionCount + 1
	print('-------------------------------------------------------------')
	print('-----------------------new action----------------------------',self.actionCount)
	print('-------------------------------------------------------------')
	-- print("↓↓↓↓↓↓↓↓↓↓↓↓↓ 身法数据  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓")
	if #self.permanentBufList > 0 then
		for i,v in ipairs(self.permanentBufList) do
			self.currAction:AddBuffInBeginToServer(v)
		end
		self.permanentBufList = {}
	end
	if not self.currAction:Execute() then
		self.actionList:removeObject(actionInfo)
		self:_OnActionEnd()
	end
end

function FightRoundManager:ExecuteUnExecuteAction()
	if FightManager.callBackInterrupt then
		self.bOverTime = true
		TFDirector:currentScene().fightUiLayer:PlayOverTimeEffect()
		return
	end

	local manualAction = nil
	while manualAction == nil do 
		manualAction = self:getNextUnExecuteAction()
		if manualAction == nil then
			return false
		end
		if manualAction ~= nil then
			local role = fightRoleMgr:GetRoleByGirdIndex(manualAction.attackerpos)
			manualAction.targetlist = self:GetActionTargetInfo(role, manualAction.skillid)

			if manualAction.targetlist == nil or #manualAction.targetlist == 0 then
				local targetEnemy = not role.logicInfo.bEnemyRole
				if fightRoleMgr:CleanFrozenBuffRole(targetEnemy) then
					manualAction.targetlist = self:GetActionTargetInfo(role, manualAction.skillid)
				end
			end

			if manualAction.targetlist ~= nil and #manualAction.targetlist > 0 then
				self:ExecuteAction(manualAction)
				return true
			else
				-- print("manualAction targetlist not find target" .. manualAction.skillid)
				-- if manualAction.bManualAction then
				-- 	self:RemoveManualAction(manualAction.attackerpos)
				-- elseif manualAction.bAngerManualAction then
				-- 	self:RemoveAngerManualAction(manualAction.attackerpos)
				-- end
				self.actionList:removeObject(manualAction)
				manualAction = nil
			end
		end
	end
	return false
end
function FightRoundManager:ExecuteManualAction()
	if FightManager.callBackInterrupt then
		self.bOverTime = true
		TFDirector:currentScene().fightUiLayer:PlayOverTimeEffect()
		return
	end
	local manualAction = self:GetManualAction()
	if manualAction ~= nil then
		local role = fightRoleMgr:GetRoleByGirdIndex(manualAction.attackerpos)
		manualAction.targetlist = self:GetActionTargetInfo(role, manualAction.skillid)
		--
		if (manualAction.targetlist == nil) then
			self:SummonedRoleSkill(role, manualAction)
		end
		--
		if manualAction.targetlist == nil or #manualAction.targetlist == 0 then
			local targetEnemy = not role.logicInfo.bEnemyRole
			if fightRoleMgr:CleanFrozenBuffRole(targetEnemy) then
				manualAction.targetlist = self:GetActionTargetInfo(role, manualAction.skillid)
			end
		end
		
		if manualAction.targetlist ~= nil and #manualAction.targetlist > 0 then
			local breakSkillRole , breakSkill = self:getBreakSkillRole(role)
			if breakSkillRole then
				-- manualAction = {}
				if manualAction.bManualAction then
					fightRoleMgr:OnExecuteManualAction(manualAction)
				elseif manualAction.bAngerManualAction then
					fightRoleMgr:OnExecuteAngerManualAction(manualAction)
				end

				manualAction.bManualAction 		= false
				manualAction.bAngerManualAction = false
				manualAction.unExecute 			= true
				manualAction.roundIndex 		= self.nCurrRoundIndex
				manualAction.attackerpos 		= breakSkillRole.logicInfo.posindex
				manualAction.skillid 			= breakSkill
				manualAction.targetlist 		= self:GetBreakSkillActionTargetInfo(breakSkillRole,breakSkill ,role)
				manualAction.triggerType 		= 6
				-- breakSkillRole:OnBuffTrigger(5)
			end

			self:ExecuteAction(manualAction)
			-- --西施选中角色放技能需要在西施Action之后才能加入
			-- for i=1, #manualAction.targetlist do
			-- 	if (manualAction.attackerpos ~= manualAction.targetlist[i].targetpos) then
			-- 		local targetRole 	= fightRoleMgr:GetRoleByGirdIndex(manualAction.targetlist[i].targetpos)
			-- 		self:XiShiInitiativeSkill(manualAction.skillid, targetRole)
			-- 	end
			-- end
			return true
		else
			
			-- print("manualAction targetlist not find target" .. manualAction.skillid)
			if manualAction.bManualAction then
				self:RemoveManualAction(manualAction.attackerpos)
			elseif manualAction.bAngerManualAction then
				self:RemoveAngerManualAction(manualAction.attackerpos)
			end
		end
	end

	return false
end

--酒桶召唤系技能
function FightRoundManager:SummonedRoleSkill(attackRole, manualAction)
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(manualAction.skillid)
	if (not skillBaseInfo) then
		return false
	end
	--
	local bEnemyRole = attackRole.logicInfo.bEnemyRole
	if (skillBaseInfo.type == EnumFightSkillType.type_13) then
		local addRoleList = fightRoleMgr:getRoleSummonedByRole(attackRole, bEnemyRole)
		if (addRoleList == nil) then
			--没有召唤物或召唤物已GG
			local addMapIndx = fightRoleMgr:getUsableMapIndexByRoleId(bEnemyRole)
			if (addMapIndx) then
				-- local addRole = FightManager:addNewRole(skillBaseInfo.buff_id, addMapIndx, attackRole)
				-- if (addRole) then
					local targetlist 				= {}
					targetlist.effect 				= EnumFightHurtEffect.effect_14
					targetlist.targetpos 			= attackRole.logicInfo.posindex
					targetlist.activeEffect 		= EnumFightSpellEffect.effect_61
					targetlist.activeEffectValue 	= addMapIndx
					targetlist.hurt 				= 0
					--
					manualAction.targetlist 		= {}
					manualAction.targetlist[1] 		= targetlist
					--
					return true
				-- end
			end
		end
	end
	return false
end

function FightRoundManager:_OnActionEnd()
	if self.currAction ~= nil then
		self.currAction:dispose()
		self.currAction = nil
	end
	if fightRoleMgr:IsEnemyAllDie() then
		FightManager:EndFight(true)
		return
	elseif fightRoleMgr:IsSelfAllDie() then
		FightManager:EndFight(false)
		return
	end
	if self:HaveSkillTrigerAttackAction() and self:ExecuteSkillTrigerAttackAction() then
		return
	end
	if self:HaveHurtAddBloodAction() and self:ExecuteHurtAddBloodAction() then
		return
	end
	if self:_HaveBackAttackAction() and self:ExecuteBackAttackAction() then
		return
	end
	if self:HaveHelpAttackAction() and self:ExecuteHelpAttackAction() then
		return
	end
	if self:HaveFuhuoActionAction() and self:ExecuteFuhuoAction() then
		return
	end
	if self:ExecuteEndKillRoleAction() then
		return
	end
	if self:ExecuteEndAction() then
		return
	end

	if self:ExecuteManualAction() then
		return
	end
	local attackRole = fightRoleMgr:GetNormalAttackRole()
	if attackRole == nil then
		self:ExecuteNewRound()
	else
		self:ExecuteNewAction()
	end

end


function FightRoundManager:isHasRoleAttackSkill(role )
	local pos = role.logicInfo.posindex
	if self:HaveSkillTrigerAttackAction() and self:hasRoleSkillTrigerSkill(pos) then
		return true
	end
	if self:HaveHurtAddBloodAction() and self:hasRoleHurtAddBloodSkill(pos) then
		return true
	end
	if self:_HaveBackAttackAction() and self:hasRoleBackAttackSkill(pos) then
		return true
	end

	if self:HaveHelpAttackAction() and self:hasRoleHelpAttackSkill(pos) then
		return true
	end
	return false
end

function FightRoundManager:OnActionEnd()
	if (FightManager.bLeaveFight) then
		toastMessage(localizable.Fight_End_Tips)
		return
	end
	TFDirector:currentScene().mapLayer:ChangeDark(false)
	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bSkillShowFight then
		TFDirector:currentScene().fightUiLayer:OnSkillShowEnd()
		return
	end
	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bPetSkillShowFight then
		TFDirector:currentScene().fightUiLayer:OnSkillShowEnd()
		return
	end
	if self.currAction ~= nil and self.currAction.bBackAttack ~= true then
		fightRoleMgr:OnActionEnd(self.currAction)
		if self.currAction.attackerRole then
			local enemy  = self.currAction.attackerRole.logicInfo.bEnemyRole
			-- fightRoleMgr:OnActionbuffType(enemy , 8)
			-- fightRoleMgr:OnActionbuffType(not enemy , 9)
			--
			local enemyBuffLastTypeList1 	= {8}
			local notEnemyBuffLastTypeList2 = {9}
			fightRoleMgr:OnActionbuffType(enemy, enemyBuffLastTypeList1, not enemy, notEnemyBuffLastTypeList2)
		end
	end

	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bSkillShowFight then
		TFDirector:currentScene().fightUiLayer:OnSkillShowEnd()
		return
	end
	if self.currAction ~= nil then
		self.currAction:setHurtAddBloodAction()
	end

	
	local endActionInfo = nil

	if self.currAction ~= nil then
		endActionInfo = self.currAction.actionInfo
		self.currAction:dispose()
		self.currAction = nil
	end

	if fightRoleMgr:IsEnemyAllDie() then
		FightManager:EndFight(true)
		return
	elseif fightRoleMgr:IsSelfAllDie() then
		FightManager:EndFight(false)
		return
	end
	fightRoleMgr.addHpPercentRole[false] = fightRoleMgr:GetSkillAddMaxHpByRole(false)
	fightRoleMgr.addHpPercentRole[true] = fightRoleMgr:GetSkillAddMaxHpByRole(true)
	if self:HaveSkillTrigerAttackAction() and self:ExecuteSkillTrigerAttackAction(endActionInfo) then
		return
	end
	if self:HaveHurtAddBloodAction() and self:ExecuteHurtAddBloodAction(endActionInfo) then
		return
	end
	if self:SetBeHurtNumTriggerSkillAction() then
		return
	end
	if self:_HaveBackAttackAction() and self:ExecuteBackAttackAction(endActionInfo) then
		return
	end

	if self:HaveHelpAttackAction() and self:ExecuteHelpAttackAction(endActionInfo) then
		return
	end
	fightRoleMgr:OnAddPermanentBuf()
	if self:HaveFuhuoActionAction() and self:ExecuteFuhuoAction() then
		return
	end
	if self:ExecuteEndKillRoleAction() then
		return
	end
	if self:ExecuteEndAction() then
		return
	end
	-- if self:HaveBackAttackBuff(endActionInfo) then
	-- 	self:ExecuteBackAttackAction(endActionInfo)
	-- 	return
	-- end

	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bGuideFight then
		self.endActionCount = self.endActionCount or 0
		self.endActionCount = self.endActionCount + 1

		local fightGuideInfo = PlayerGuideManager:GetGuideFightInfo()
		for i=1,#fightGuideInfo.skill do
			local stepInfo = PlayerGuideStepData:objectByID(10000)
			local skillInfo = fightGuideInfo.skill[i]
			if skillInfo[2] == self.endActionCount then
				local beginTextShowEndCallBack = function(event)
					if FightManager.isFighting then
						stepInfo.widget_name = "roleskill"..skillInfo[1] .."|roleicon"
						-- print("stepInfo.widget_name = ",stepInfo.widget_name)
						PlayerGuideManager:showGuideLayerByStepId(10000)
						TFDirector:currentScene().fightUiLayer:SetGuideRoleSkillEnable(skillInfo[1])
					end
					
	       	 		TFDirector:removeMEGlobalListener("MissionTipLayer.EVENT_SHOW_BEGINTIP_COM")
	    		end
	    		TFDirector:addMEGlobalListener("MissionTipLayer.EVENT_SHOW_BEGINTIP_COM",  beginTextShowEndCallBack)
				MissionManager:showBeginTipForMission(skillInfo[3])
				return
			end
		end
	end
	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bPrologue then
		self.endActionCount = self.endActionCount or 0
		self.endActionCount = self.endActionCount + 1
		local prologurFightInfo = MissionPrologueData:objectByID(MissionManager.attackMissionId)
		if prologurFightInfo.skill == nil or #prologurFightInfo.skill== 0 then
			FightManager.fightBeginInfo.bPrologue = false
		end
		if FightManager.fightBeginInfo.bPrologue then
			for i=1,#prologurFightInfo.skill do
				local stepInfo = PlayerGuideStepData:objectByID(10000)
				local skillInfo = prologurFightInfo.skill[i]
				if skillInfo[2] == self.endActionCount then
					if skillInfo[1] <= 10 then
						local beginTextShowEndCallBack = function(event)
							if FightManager.isFighting then
								if skillInfo[1] == 0 then
									FightManager:OnActionEnd()
								else
									stepInfo.widget_name = "roleskill"..skillInfo[1] .."|roleicon"
									-- print("stepInfo.widget_name = ",stepInfo.widget_name)
									PlayerGuideManager:showGuideLayerByStepId(10000)
									TFDirector:currentScene().fightUiLayer:SetGuideRoleSkillEnable(skillInfo[1])
								end
							end
							
			       	 		TFDirector:removeMEGlobalListener("MissionTipLayer.EVENT_SHOW_BEGINTIP_COM")
			    		end
			    		TFDirector:addMEGlobalListener("MissionTipLayer.EVENT_SHOW_BEGINTIP_COM",  beginTextShowEndCallBack)
						MissionManager:showBeginTipForMission(skillInfo[3])
						if i == #prologurFightInfo.skill then
							FightManager.fightBeginInfo.bPrologue = false
						end
						return
					else
						if skillInfo[1] >= 10 and skillInfo[1] < 20 then
							FightManager:addNewRole(skillInfo[3] ,skillInfo[1] - 10)
						else
							FightManager:addNewNpc(skillInfo[3] , skillInfo[1] - 20)
						end
						if i == #prologurFightInfo.skill then
							FightManager.fightBeginInfo.bPrologue = false
						end
						return
					end
				end
			end
		end
	end

	-- if PlayerGuideManager:NextGuideIsSkill() then
	-- 	PlayerGuideManager:ShowNextGuideStep()
	-- 	return
	-- end
	if self:setTeamAttackSkill() then
		return
	end
	-- fightRoleMgr:OnAddPermanentBuf()
	if self:ExecuteManualAction() then
		return
	end

	-- if self:ExecuteAngerManualAction() then
	-- 	return
	-- end
	local attackRole = fightRoleMgr:GetNormalAttackRole()
	if attackRole == nil then
		self:ExecuteNewRound()
	else
		self:ExecuteNewAction()
	end
end

--混乱目标转换
function FightRoundManager:ChangeActionTarget(actionInfo)
	local attackRole = fightRoleMgr:GetRoleByGirdIndex(actionInfo.attackerpos)
	if attackRole == nil or attackRole:IsLive() == false then
		return
	end
	if actionInfo.triggerType and actionInfo.triggerType == 5 then
		return
	end
	local buffList = attackRole:GetBuffListByType({33, 10})
	if buffList[33] then
		return
	end

	if buffList[10] == nil then
		return
	end

	local targetRole = fightRoleMgr:GetCharmActionTarget(attackRole,false)
	if targetRole == nil then
		targetRole = fightRoleMgr:GetCharmActionTarget(attackRole,true)
	end
	if targetRole == nil then
		return
	end
	actionInfo.skillid.skillId = 0
	actionInfo.skillid.level = 0
	

	local frozenBuff = targetRole:GetBuffByType(14)
	if frozenBuff ~= nil then
		targetRole:RemoveFrozenBuff()
	end
	print("混乱目标转换  ChangeActionTarget")
	local targetList = {targetRole}
	actionInfo.targetlist = self:CaculateTargetHurt(attackRole, 0, targetList, nil, nil, actionInfo.triggerType)
	local lingHunLianJieRole = self:hasLingHunLianJie(actionInfo.targetlist)
	if lingHunLianJieRole then
		self:setLingHunLianJie(lingHunLianJieRole,actionInfo.targetlist)
	end
end

--挑衅buff目标转换
function FightRoundManager:ChangeDefianceTarget(actionInfo)
	local attackRole = fightRoleMgr:GetRoleByGirdIndex(actionInfo.attackerpos)
	if attackRole == nil or attackRole:IsLive() == false then
		return
	end
	
	if actionInfo.triggerType then
		if actionInfo.triggerType == 5 or actionInfo.triggerType == 8 then
			return
		end
	end
	
	local buffList = attackRole:GetBuffListByType({33, 18})
	if buffList[33] then
		return
	end
	if buffList[18] == nil then
		return
	end

	local targetRole = fightRoleMgr:GetDefianceTarget(attackRole)
	if targetRole == nil then
		attackRole:RemoveBuffByType(18)
		return
	end

	local frozenBuff = targetRole:GetBuffByType(14)
	if frozenBuff ~= nil then
		targetRole:RemoveFrozenBuff()
	end
	local targetList = {targetRole}

	local haveHelpRoleList = self:IsHaveHelpAttack(attackRole)
	if haveHelpRoleList:length() > 0 then
		self:setHelpAttackAction(haveHelpRoleList , targetList)
	end

	-- local backAddRole = self:IsHaveEndAddAttackBuffRole(not attackRole.logicInfo.bEnemyRole)
	-- if backAddRole then
	-- 	self:setBackAddAttackAction(backAddRole ,attackRole )
	-- end
	print("挑衅buff目标转换  ChangeDefianceTarget")
	local backAddRoleList = self:IsHaveEndAddSkillAttackBuffRole(attackRole, actionInfo.skillid)
	for i,roleInfo in ipairs(backAddRoleList) do
		self:setBackAddAttackAction(roleInfo ,attackRole, i == 1 )
	end
	actionInfo.targetlist = self:CaculateTargetHurt(attackRole, actionInfo.skillid, targetList,targetList,actionInfo.isbackAttack)
	local lingHunLianJieRole = self:hasLingHunLianJie(actionInfo.targetlist)
	if lingHunLianJieRole then
		self:setLingHunLianJie(lingHunLianJieRole,actionInfo.targetlist)
	end
	if attackRole.skillID.skillId ~= 0 then
		self:setFearBuff(attackRole, actionInfo.targetlist)
	end
end

function FightRoundManager:GetActionTargetInfo(attackRole, skillID, isbackAttack, triggerSkillType)
	if isbackAttack == nil then
		isbackAttack = false
	end
	local targetList = {}
	local extra_targetList = {}
	local buSiBuXiu = attackRole:GetBuffByType(33)
	if buSiBuXiu then
		print("==================不死不休====================")
		local attackIsEnemy = attackRole.logicInfo.bEnemyRole
		local targetIsEnemy = not attackIsEnemy
		targetList = fightRoleMgr:GetBuffTarget(buSiBuXiu,targetIsEnemy)
		for i=1,#targetList do
			local targetRole = targetList[i]
			local frozenBuff = targetRole:GetBuffByType(14)
			if frozenBuff ~= nil then
				targetRole:RemoveFrozenBuff()
			end
		end

		if #targetList > 0 then

			local haveHelpRoleList = self:IsHaveHelpAttack(attackRole)
			if haveHelpRoleList:length() > 0 then
				self:setHelpAttackAction(haveHelpRoleList , targetList)
			end
			local backAddRoleList = self:IsHaveEndAddSkillAttackBuffRole(attackRole, skillID)
			for i,roleInfo in ipairs(backAddRoleList) do
				self:setBackAddAttackAction(roleInfo ,attackRole, i == 1 )
			end
			local targetInfo = {}
			if isbackAttack then
				targetInfo = self:CaculateTargetBackAttackHurt(attackRole, skillID, targetList, {}, triggerSkillType)
			else
			 	targetInfo = self:CaculateTargetHurt(attackRole, skillID, targetList)
			end
			local yuanHuRole = self:IsHaveYuanHuBuffRole(attackRole, targetInfo)
			if yuanHuRole then -- and not self:isYuanHuRoleInTarget(yuanHuRole , targetInfo) then
				targetInfo = self:CaculateTargetYuanHu(yuanHuRole, targetInfo)
			end

			local lingHunLianJieRole = self:hasLingHunLianJie(targetInfo)
			if lingHunLianJieRole then
				self:setLingHunLianJie(lingHunLianJieRole,targetInfo)
			end
			-- local hurtAddRole = self:IsHaveHurtAddHpRole(targetList[1])
			-- if hurtAddRole then
			-- 	self:setHurtAddSkill(yuanHuRole, targetInfo)
			-- end
			return targetInfo
		end

	end
	local  isNeedHelp = false
	if skillID.skillId == 0 then --普通技能打单体	
		targetList = fightRoleMgr:GetSingleTarget(attackRole, true)
		isNeedHelp = true
	else
		local skillInfo = SkillLevelData:objectByID(skillID)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo == nil or skillBaseInfo == nil then
			print("skill not find：" ,skillID)
		end

		local targetType = skillBaseInfo.target_type
		local targetNum = skillInfo.target_num
		if targetNum == nil or targetNum == 0 then
			targetNum = 1
		end
		if skillInfo == nil then
			print("skillInfo not find：" ,skillID)
			targetType = 1
		end
		targetList = self:getTargetListBySkillInfo( targetType,targetNum,attackRole, skillBaseInfo )

		if skillInfo and skillBaseInfo.extra_buffid > 0 then
			extra_targetList = self:getTargetListBySkillInfo( skillBaseInfo.extra_targe_type ,skillInfo.extra_buff_targetnum ,attackRole)
		end
		if skillBaseInfo.type ~= 8 then
			isNeedHelp = true
		end
	end

	if not targetList then
		return nil
	end

	if #targetList > 0 then
		if not isbackAttack then
			local haveHelpRoleList = self:IsHaveHelpAttack(attackRole)
			if attackRole:HasTriggerSkillBySkill(skillID , 5) then
				haveHelpRoleList:pushFront(attackRole)
			end
			if isNeedHelp and  haveHelpRoleList:length() > 0 then
				self:setHelpAttackAction(haveHelpRoleList , targetList)
			end
			-- local backAddRole = self:IsHaveEndAddAttackBuffRole(not attackRole.logicInfo.bEnemyRole)
			-- if backAddRole then
			-- 	self:setBackAddAttackAction(backAddRole ,attackRole )
			-- end
			local backAddRoleList = self:IsHaveEndAddSkillAttackBuffRole(attackRole, skillID)
			for i,roleInfo in ipairs(backAddRoleList) do
				self:setBackAddAttackAction(roleInfo ,attackRole, i == 1 )
			end
		end
		
		local targetInfo = {}
		if isbackAttack then
			targetInfo = self:CaculateTargetBackAttackHurt(attackRole, skillID, targetList, extra_targetList, triggerSkillType)
		else
		 	targetInfo = self:CaculateTargetHurt(attackRole, skillID, targetList,extra_targetList)
		end

		-- local targetInfo = self:CaculateTargetHurt(attackRole, skillID, targetList,extra_targetList)

		if not isbackAttack then
			local yuanHuRole = self:IsHaveYuanHuBuffRole(attackRole, targetInfo)
			if yuanHuRole then --  and not self:isYuanHuRoleInTarget(yuanHuRole , targetInfo) then
				targetInfo = self:CaculateTargetYuanHu(yuanHuRole, targetInfo)
			end
		end
		local lingHunLianJieRole = self:hasLingHunLianJie(targetInfo)
		if lingHunLianJieRole then
			self:setLingHunLianJie(lingHunLianJieRole,targetInfo)
		end
		if skillID.skillId ~= 0 then
			self:setFearBuff(attackRole, targetInfo)
		end
		return targetInfo --self:CaculateTargetHurt(attackRole, skillID, targetList,extra_targetList)
	end
end


function FightRoundManager:getTargetListBySkillInfo( targetType,targetNum,attackRole, skillBaseInfo)
		local attackIsEnemy = attackRole.logicInfo.bEnemyRole
		local targetIsEnemy = not attackIsEnemy
		local targetList = {}
		if  targetType == 1 then -- 单体技能
			targetList = fightRoleMgr:GetSingleTarget(attackRole)
		elseif targetType == 2 then -- 全屏技能
			targetList = fightRoleMgr:GetScreenTarget(targetIsEnemy)
		elseif targetType == 3 then -- 横排贯穿技能
			targetList = fightRoleMgr:GetRowTarget(attackRole, true)
		elseif targetType == 4 then -- 竖排穿刺技能
			targetList = fightRoleMgr:GetColumnTarget(attackRole)
		elseif targetType == 5 then -- 敌方随机
			targetList = fightRoleMgr:GetRandomTarget(targetIsEnemy, targetNum)
		elseif targetType == 6 then -- 敌方血最少
			targetList = fightRoleMgr:GetTargetByAttr(1, targetIsEnemy, false, targetNum)
		elseif targetType == 7 then -- 敌方防最少
			targetList = fightRoleMgr:GetTargetByAttr(3, targetIsEnemy, false, targetNum)
		elseif targetType == 8 then -- 我方随机
			targetList = fightRoleMgr:GetRandomTarget(attackIsEnemy, targetNum)
		elseif targetType == 9 then -- 我方血最少
			targetList = fightRoleMgr:GetTargetByAttr(1, attackIsEnemy, false, targetNum)
		elseif targetType == 10 then -- 我方全体
			targetList = fightRoleMgr:GetScreenTarget(attackIsEnemy)
		elseif targetType == 11 then -- 自己
			targetList = {attackRole}
		elseif targetType == 12 then -- 敌方防最高
			targetList = fightRoleMgr:GetTargetByAttr(3, targetIsEnemy, true, targetNum)
		elseif targetType == 13 then -- 敌方内力最高
			targetList = fightRoleMgr:GetTargetByAttr(4, targetIsEnemy, true, targetNum)
		elseif targetType == 14 then -- 敌方内力最少
			targetList = fightRoleMgr:GetTargetByAttr(4, targetIsEnemy, false, targetNum)
		elseif targetType == 15 then -- 敌方武力最高
			targetList = fightRoleMgr:GetTargetByAttr(2, targetIsEnemy, true, targetNum)
		elseif targetType == 16 then -- 敌方武力最少
			targetList = fightRoleMgr:GetTargetByAttr(2, targetIsEnemy, false, targetNum)
		elseif targetType == 17 then -- 我方武力最高
			targetList = fightRoleMgr:GetTargetByAttr(2, attackIsEnemy, true, targetNum)
		elseif targetType == 18 then -- 我方武力最少
			targetList = fightRoleMgr:GetTargetByAttr(2, attackIsEnemy, false, targetNum)
		elseif targetType == 19 then -- 我方内力最高
			targetList = fightRoleMgr:GetTargetByAttr(4, attackIsEnemy, true, targetNum)
		elseif targetType == 20 then -- 我方内力最少
			targetList = fightRoleMgr:GetTargetByAttr(4, attackIsEnemy, false, targetNum)
		elseif targetType == 21 then -- 横排贯穿技能
			targetList = fightRoleMgr:GetRowTarget(attackRole , false)
		elseif targetType == 22 then -- 竖排穿刺技能
			targetList = fightRoleMgr:GetSelfColumnTarget(attackRole)
		elseif targetType == 23 then -- 敌方身法最高
			targetList = fightRoleMgr:GetTargetByAttr(EnumAttributeType.Agility, targetIsEnemy, true, targetNum)
		elseif targetType == 24 then -- 敌方身法最少
			targetList = fightRoleMgr:GetTargetByAttr(EnumAttributeType.Agility, targetIsEnemy, false, targetNum)
		elseif targetType == 25 then -- 正前方十字
			targetList = fightRoleMgr:GetAwardTenTarget(attackRole)
		elseif targetType == 26 then -- 我方随机两个 排除自己 实在没有人的情况上就上自己吧
			targetList = fightRoleMgr:GetRandomTargetDouble(attackRole.logicInfo, attackIsEnemy, targetNum, skillBaseInfo, self.actionList)
		elseif targetType == 27 then -- 酒桶召唤阵位
			targetList = fightRoleMgr:getRoleSummonedByRole(attackRole, attackIsEnemy)
		elseif targetType == 28 then -- 我方血量最少，不包括自己
			targetList = fightRoleMgr:GetTargetByAttr(1, attackIsEnemy, false, targetNum, attackRole)
		-- elseif targetType == 29 then -- 施放技能角色正后方
			-- targetList = fightRoleMgr:GetTargetByAttr(1, attackIsEnemy, false, targetNum, attackRole)
		-- elseif targetType == 30 then -- 敌方最大血量值对自己低
		elseif targetType == 31 then -- 已方最大血量上限
			targetList = fightRoleMgr:getMaxLimit(attackIsEnemy)
		else
			targetType = targetType or ""
			assert(false, targetType.."  targetType error")
		end
		return targetList	
end

--西施主动技--
function FightRoundManager:XiShiInitiativeSkill(skillID, targetRole)
	local skillInfo = FightManager:GetCacheSkillBaseInfo(skillID.skillId)
	if (skillInfo and targetRole and skillInfo.effect == EnumFightSpellEffect.effect_60) then
		targetRole.skillCD = 0
		if (skillInfo.hidden_skill == 3) then
			--神技
			targetRole:setConsumptionSkillReleaseState(true, true)
			self:AddAngerManualAction(targetRole, true, true)
			
		else
			targetRole:setConsumptionSkillReleaseState(true, false)
			self:AddManualAction(targetRole, false, true)
		end
	end
end

--普通攻击伤害 = 武力*武力/(武力+防御)*1.2
--技能攻击伤害 = (武力*武力系数+内力*内力系数)* (武力*武力系数+内力*内力系数)/( 武力*武力系数+内力*内力系数+防御)*1.2
--               +技能属性系数(冰火毒)*属性伤害(冰火毒)-属性抗性（冰火毒）+ 附加伤害
-- 老的 最终伤害 = 基础伤害*暴击修正(1.5) 结果取整
-- 新的 最终伤害 = 基础伤害 * max（1, 1.5+暴击增加-对面暴击减免） 2019-8-29 11:44:59修改


function FightRoundManager:CaculateHurtNum(attackRole, skillID, targetRole, effect,targetNum)
	local attackAttr 	= attackRole:GetAttrNum(2)
	local defAttr 		= targetRole:GetAttrNum(3)
	local neiliAttr 	= attackRole:GetAttrNum(4)
	local agilityAttr 	= attackRole:GetAttrNum(EnumAttributeType.Agility)

	attackAttr , neiliAttr = attackRole:getChangeAttrSkill(attackAttr , neiliAttr ,agilityAttr)

	if skillID.skillId == 0 then
		local hurt = 0
		if attackAttr+defAttr > 0 then
			local coefficientOne = fightPublic:GetCacheConstant("Fight.Defense.coefficient.one")
			hurt = 1.2 * attackAttr * attackAttr / (attackAttr+defAttr * coefficientOne)
		end

		if FightManager.fightBeginInfo.fighttype == 5 then
			local power_suppress = ClimbManager:getAtkSuppress( attackRole.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole  )
			hurt = math.floor(hurt * power_suppress)
		elseif FightManager.fightBeginInfo.fighttype == 16 then
			local power_suppress = NorthClimbManager:getAtkSuppress( attackRole.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole  )
			hurt = math.floor(hurt * power_suppress)
		elseif FightManager.fightBeginInfo.fighttype == 17 then
			local power_suppress = FactionManager:getAtkSuppress( attackRole.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole  )
			hurt = math.floor(hurt * power_suppress)
		end
		--暴击加成
		if effect == 2 then
			-- hurt = 1.5 * hurt
			hurt = fightPublic:CaculateCritHurtNum(attackRole, targetRole, hurt)
		end
		hurt = math.floor(hurt)

		print("攻击方属性:武力-- "..attackAttr)
		print("受击方属性:防御-- "..defAttr)
		print(attackRole.logicInfo.name.."   普通攻击  "..targetRole.logicInfo.name..",   造成伤害： "..hurt)
		hurt = fightRoleMgr:GetHurtPercentByIndex(attackRole.logicInfo.posindex, hurt)

		return hurt
	else
		local hurtParams = {1.0, 1.0, 1.0, 1.0, 1.0}
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo ~= nil then
			hurtParams[1] = skillInfo.outside --武力系数
			hurtParams[2] = skillInfo.inside	--内力系数
			hurtParams[3] = skillInfo.ice
			hurtParams[4] = skillInfo.fire
			hurtParams[5] = skillInfo.poison
			hurtParams[6] = skillInfo.blood_max or 0
			--
			if (skillID.skillId == attackRole.skillID.skillId) then
				local _WuNei 	= attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Xinfa_effect, EnumXinFaSpecialType.XinFaSpecialType_WuNei)
				local _Wu 		= attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Xinfa_effect, EnumXinFaSpecialType.XinFaSpecialType_WuLi)
				local _Nei 		= attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Xinfa_effect, EnumXinFaSpecialType.XinFaSpecialType_NeiLi)
				_WuNei 	= _WuNei / 10000
				_Wu 	= _Wu / 10000
				_Nei 	= _Nei / 10000
				hurtParams[1] = hurtParams[1] + _WuNei + _Wu
				hurtParams[2] = hurtParams[2] + _WuNei + _Nei
			elseif skillInfo.hidden_skill == 3 then
				local _WuNei 		= attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Xinfa_effect, EnumXinFaSpecialType.XinFaSpecialType_WuNei)
				local _SuperWuNei 	= attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Xinfa_effect, EnumXinFaSpecialType.XinFaSpecialType_SuperWuNei)
				_WuNei 			= _WuNei / 10000
				_SuperWuNei 	= _SuperWuNei / 10000
				hurtParams[1] = hurtParams[1] + _SuperWuNei
				hurtParams[2] = hurtParams[2] + _SuperWuNei
			end
			print("技能系数加成:",hurtParams, "  skillInfo.extra_hurt: ",skillInfo.extra_hurt)
		end
		print("----------------攻击方属性:武力-- "..attackAttr..",内力-- "..neiliAttr)
		print("----------------受击方属性:防御-- "..defAttr)
		--加血量 = 治疗者(武力*武力系数+内力*内力系数)+配置表附加值
		if self:IsTreatmentEffect(effect) then
			local addHpNum = attackAttr*hurtParams[1]+neiliAttr*hurtParams[2]+skillInfo.effect_value + hurtParams[6]*attackRole.maxhp
					-- 我发治疗修正+敌方被动治疗修正
			local attackExtra 		= attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_BonusHealing)
			local targetExtra 		= targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing)
			local fightEffectValue 	= attackExtra + targetExtra
			fightEffectValue 		= fightEffectValue / 10000 + 1
			fightEffectValue 		= math.max(0, fightEffectValue)
			-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
			print(attackRole.logicInfo.name.." 治疗 "..targetRole.logicInfo.name.." ,基础"..addHpNum)
			print(" -------------主动治疗系数",attackExtra)
			print(" -------------被动治疗系数",targetExtra)
			addHpNum = addHpNum * fightEffectValue
			local targetBonusHealing = targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing_Num)
			addHpNum = addHpNum + targetBonusHealing
			-- addHpNum = math.max(0,addHpNum)
			print(" -------------被动治疗加成",targetBonusHealing)
			--最终治疗加成
			local endBonusHealing 		= targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_EndBonusHealing)
			endBonusHealing = endBonusHealing / 10000 * addHpNum
			addHpNum = addHpNum + endBonusHealing
			addHpNum = math.max(0,addHpNum)
			--
			
			print(" -------------治疗血量最终：",addHpNum)
			
			return math.floor(addHpNum)
		end
		
		local baseAttr = attackAttr*hurtParams[1]+neiliAttr*hurtParams[2]
		local hurt = 0
		if skillInfo.hurt_type == 0 then
			if baseAttr+defAttr*2 > 0 then
			 	hurt = 	1.2*baseAttr*baseAttr/(baseAttr+defAttr*ConstantData:objectByID("Fight.Defense.coefficient.two").value) + 
						math.max(0, hurtParams[3]*attackRole:GetAttrNum(6) - targetRole:GetAttrNum(9)) +
						math.max(0, hurtParams[4]*attackRole:GetAttrNum(7) - targetRole:GetAttrNum(10)) +
						math.max(0, hurtParams[5]*attackRole:GetAttrNum(8) - targetRole:GetAttrNum(11)) +
						math.max(0, skillInfo.extra_hurt)
			end
		elseif skillInfo.hurt_type == 1 then
			--
			if skillInfo.effect == EnumFightSpellEffect.effect_64 then
				defAttr = 0
			end
			if baseAttr+defAttr*2 > 0 then
			 	hurt = 	1.2*baseAttr*baseAttr/(baseAttr+defAttr*ConstantData:objectByID("Fight.Defense.coefficient.two").value) + 
						math.max(0, hurtParams[3]*attackRole:GetAttrNum(6) - targetRole:GetAttrNum(9)) +
						math.max(0, hurtParams[4]*attackRole:GetAttrNum(7) - targetRole:GetAttrNum(10)) +
						math.max(0, hurtParams[5]*attackRole:GetAttrNum(8) - targetRole:GetAttrNum(11)) +
						math.max(0, skillInfo.extra_hurt)
			end
			--分摊伤害2017。10。27 --策划龙哥说修改分推伤害系数
			-- local morePepleHurtParams = {1, 1, 1, 1.0, 1.0, 1.0,1.0}
			
			hurt = (hurt * EnumFightMorePepleHurtParams[targetNum]) / targetNum
		end
		print(attackRole.logicInfo.name.."技能攻击"..targetRole.logicInfo.name..",造成伤害："..hurt)
		if FightManager.fightBeginInfo then
			local power_suppress = 0
			if FightManager.fightBeginInfo.fighttype == 5 then
				power_suppress = ClimbManager:getAtkSuppress( attackRole.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole  )
				hurt = math.floor(hurt * power_suppress)
			elseif FightManager.fightBeginInfo.fighttype == 16 then
				power_suppress = NorthClimbManager:getAtkSuppress( attackRole.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole  )
				hurt = math.floor(hurt * power_suppress)
			elseif FightManager.fightBeginInfo.fighttype == 17 then
				power_suppress = FactionManager:getAtkSuppress( attackRole.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole  )
				hurt = math.floor(hurt * power_suppress)
			end
			print("----------------战斗类型伤害加成系数: ",power_suppress,"  ,造成伤害："..hurt)
		end
	
		--暴击加成
		if effect == 2 then
			hurt = fightPublic:CaculateCritHurtNum(attackRole, targetRole, hurt)
		end

		hurt = fightRoleMgr:GetHurtPercentByIndex(attackRole.logicInfo.posindex, hurt)
		hurt = math.floor(hurt)
		print("----------------技能攻击 造成伤害："..hurt)

		return hurt
	end
end

function FightRoundManager:canInsertInManualAction( fightRole , targetAction )
	if targetAction.bBackAttack or not targetAction.unExecute then
		return false
	end
	if targetAction.triggerType and targetAction.triggerType ~= 0 then
		return false
	end
	if self.currAction == nil or self.currAction == targetAction then
		return false
	end
	if not targetAction.bManualAction and not targetAction.bAngerManualAction then
		return true
	else
		local actionRole = fightRoleMgr:GetRoleByGirdIndex(targetAction.attackerpos)
		if fightRole:GetAttrNum(5) <= actionRole:GetAttrNum(5) then
			return false
		end
	end
	return true
end

--插入主动技能
function FightRoundManager:AddManualAction(fightRole, bManualAdd, bConsume)
	if not fightRole:CanReleaseManualSkill() then
		if (bConsume) then
			fightRole:setConsumptionSkillReleaseState(false, false)
		end
		return false	
	end	
	local skillInfo 				= fightRole:getUseSelfSkill()
	local newAction              	= {}
	newAction.bManualAction      	= true
	newAction.bAngerManualAction 	= false
	newAction.unExecute          	= true
	newAction.roundIndex         	= math.max(1, self.nCurrRoundIndex)
	newAction.attackerpos        	= fightRole.logicInfo.posindex
	if (skillInfo) then
		newAction.skillid 			= {skillId = skillInfo.id,level = fightRole.skillID.level}
	else
		newAction.skillid 			= fightRole.skillID
	end
	local bInsert = false
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		local actionRole = fightRoleMgr:GetRoleByGirdIndex(actionInfo.attackerpos)
		if actionRole ~= nil and actionRole:IsLive() then
			if self:canInsertInManualAction(fightRole,actionInfo) then
				self.actionList:insertAt(i, newAction)
				bInsert = true
				break
			end
		end
	end

	if not bInsert then
		self.actionList:pushBack(newAction)
	end

	local skillAnger = fightRole:GetSkillAnger()
	fightRoleMgr:AddAnger(fightRole.logicInfo.bEnemyRole, -skillAnger)

	if fightRole.logicInfo.bEnemyRole == false and bManualAdd ~= true then
		if (FightManager.isAutoFight or bConsume) then
			TFDirector:currentScene().fightUiLayer:ReleaseSkillByAI(fightRole)
		end
	end
	fightRole:addManualActionNum()
	if not fightRole.logicInfo.bEnemyRole then
		FightManager:addManualActionNum()
	end
	fightRole:AddBodyEffect("skill_yuyue", true, false, 0, 200)
	return true
end

--判断角色主动技是否已经在待施放队列中
function FightRoundManager:IsRoleHaveManualAction(fightRole)
	local actionNum = self.actionList:length()
	-- for i=1,actionNum do
	-- 	local actionInfo = self.actionList:objectAt(i)
	for actionInfo in self.actionList:iterator() do
		if actionInfo.bManualAction and actionInfo.unExecute and actionInfo.attackerpos == fightRole.logicInfo.posindex then
			return true
		end
	end
	return false
end

--判断角色神技是否已经在待施放队列中
function FightRoundManager:IsRoleHaveAngerManualAction(fightRole)
	local actionNum = self.actionList:length()
	-- for i=1,actionNum do
	-- 	local actionInfo = self.actionList:objectAt(i)
	for actionInfo in self.actionList:iterator() do
		if actionInfo.bAngerManualAction and actionInfo.unExecute and actionInfo.attackerpos == fightRole.logicInfo.posindex then
			return true
		end
	end
	return false
end

function FightRoundManager:getNextUnExecuteAction()
	local manualAction = nil
	local actionIndex = nil
	while manualAction == nil do
		local actionNum = self.actionList:length()
		-- for i=1,actionNum do
		-- 	local actionInfo = self.actionList:objectAt(i)
		for actionInfo in self.actionList:iterator() do
			if actionInfo.unExecute then
				manualAction = actionInfo
				break
			end
		end
		if manualAction == nil then
			return nil
		end
		local attackRole = fightRoleMgr:GetRoleByGirdIndex(manualAction.attackerpos)
		local canRelease = true
		-- if attackRole and (manualAction.bManualAction and attackRole.skillCD > 0) then
		-- 	canRelease = false
		-- end
		local isNeedDel = false
		if attackRole == nil or attackRole:IsLive() == false then
			isNeedDel = true
		else
			if manualAction.bManualAction then
				if attackRole.skillCD > 0 or attackRole:HaveForbidManualSkillBuff() then
					isNeedDel = true
				end
			elseif manualAction.bAngerManualAction then
				if attackRole.angerSkillCD > 0 or attackRole:HaveForbidManualSkillBuff() then
					isNeedDel = true
				end
			end
		end
		if isNeedDel then
			self.actionList:removeObject(manualAction)
			manualAction = nil
		end
	end
	return manualAction
end

function FightRoundManager:GetManualAction(bEnemy)
	local manualAction = nil
	local actionIndex = nil
	while manualAction == nil do
		local actionNum = self.actionList:length()
		for i=1,actionNum do
			local actionInfo = self.actionList:objectAt(i)
			local bEnemyAction = false
			if actionInfo.attackerpos >= 9 then
				bEnemyAction = true
			end

			if (actionInfo.bManualAction or actionInfo.bAngerManualAction ) and actionInfo.unExecute then
				if bEnemy == nil or bEnemyAction == bEnemy then
					manualAction = actionInfo
					actionIndex = i
					break
				end
			end
		end
		if manualAction == nil then
			return
		end

		if manualAction ~= nil then
			local attackRole = fightRoleMgr:GetRoleByGirdIndex(manualAction.attackerpos)
			local canRelease = true
			if attackRole and (manualAction.bManualAction and attackRole.skillCD > 0) then
				canRelease = false
			end
			if attackRole == nil or attackRole:IsLive() == false or attackRole:HaveForbidManualSkillBuff() or not canRelease then
				if manualAction.bManualAction then
					self:RemoveManualAction(manualAction.attackerpos)
				elseif manualAction.bAngerManualAction then
					self:RemoveAngerManualAction(manualAction.attackerpos)
				end
				-- self:RemoveManualAction(manualAction.attackerpos)
				manualAction = nil
			end
		end
	end
	return manualAction
end

function FightRoundManager:RemoveAngerManualAction(rolePos)
	-- local actionNum = self.actionList:length()
	-- for i=1,actionNum do
	-- 	local actionInfo = self.actionList:objectAt(i)
	for actionInfo in self.actionList:iterator() do
		if actionInfo.bAngerManualAction and actionInfo.unExecute and rolePos == actionInfo.attackerpos then
			-- print("self.actionList:removeObjectAt---RemoveAngerManualAction-->>>pos = "..(i).."roundIndex = "..actionInfo.roundIndex.."attackerpos = "..actionInfo.attackerpos)
			-- self.actionList:removeObjectAt(i)
			self.actionList:removeObject(actionInfo)
			-- for _i = #self.tagInsertIndex, 1, -1 do
			-- 	if (self.tagInsertIndex[_i] == i) then
			-- 		table.remove( self.tagInsertIndex, _i)
			-- 		break
			-- 	end
			-- end
			return
		end
	end
end

function FightRoundManager:RemoveManualAction(rolePos)
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		if actionInfo.bManualAction and actionInfo.unExecute and rolePos == actionInfo.attackerpos then
			-- print("self.actionList:removeObjectAt---RemoveManualAction--->>>pos = "..(i).."roundIndex = "..actionInfo.roundIndex.."attackerpos = "..actionInfo.attackerpos)
			self.actionList:removeObjectAt(i)
			fightRoleMgr:OnRemoveManualAction(actionInfo)
			return
		end
	end
end


function FightRoundManager:RemoveAllManualAction(rolePos, bManualAction, bAngerManualAction)
	if (FightManager.isReplayFight) then
		return
	end
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		if (bManualAction and actionInfo.bManualAction) or (bAngerManualAction and actionInfo.bAngerManualAction ) then
			if actionInfo.unExecute and rolePos == actionInfo.attackerpos then
				-- print("self.actionList:removeObjectAt---RemoveManualAction--->>>pos = "..(i).."roundIndex = "..actionInfo.roundIndex.."attackerpos = "..actionInfo.attackerpos)
				self.actionList:removeObjectAt(i)
				fightRoleMgr:OnRemoveManualAction(actionInfo)
				return
			end
		end
	end
end

--乾坤挪移反击action
function FightRoundManager:SetDzxyAttackAction(attackRole, targetRole, hurt)
	if FightManager.isReplayFight then
		return
	end

	if attackRole:IsLive() == false or targetRole:IsLive() == false then
		return
	end
	if attackRole:HaveForbidBackAttackBuff() then
		return
	end
	local buffList = attackRole:GetBuffListByType({10, 27, 18})
	if buffList[10] then
		return
	end

	-- if self:_HaveBackAttackAction() then
	-- 	return
	-- end

	local dzxyBuff = buffList[27]
	if dzxyBuff == nil then
		return
	end
	local fromTarget = dzxyBuff.fromTarget
	local _skillInfo = fromTarget:getskillInfoByDzxy(dzxyBuff.config.id)
	-- local _skillInfo = {skillId = 0 , level = 0}
	-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(attackRole.skillID)
	-- if skillBaseInfo then
	-- 	if skillBaseInfo.buff_id ~= 0 then
	-- 		local buffInfo = SkillBufferData:objectByID(skillBaseInfo.buff_id)
	-- 		if buffInfo and  buffInfo.type == 27 then
	-- 			_skillInfo = attackRole.skillID
	-- 		end
	-- 	end
	-- end


	self.backAttackActionList 		= self.backAttackActionList or TFArray:new()
	local  backAttackAction 		= {}
	backAttackAction.bManualAction 	= false
	backAttackAction.unExecute 		= true
	backAttackAction.roundIndex 	= self.nCurrRoundIndex
	backAttackAction.attackerpos 	= attackRole.logicInfo.posindex
	backAttackAction.skillid 		= _skillInfo
	backAttackAction.bBackAttack 	= true
	backAttackAction.targetlist 	= {}
	backAttackAction.isDZXY 		= true
	if buffList[18] then

		local _targetRole = fightRoleMgr:GetDefianceTarget(attackRole)
		if _targetRole == nil then
			attackRole:RemoveBuffByType(18)
			return
		end
		local buffHurt = -1
		local isBuffTarget = false
		buffHurt, isBuffTarget= self:CaculateSelfTargetHurtEnd(_targetRole, buffHurt)
		if (not isBuffTarget) then
			backAttackAction.targetlist[1] = {}
			backAttackAction.targetlist[1].targetpos = _targetRole.logicInfo.posindex
			backAttackAction.targetlist[1].effect = 1
			local neiliAttr = attackRole:GetAttrNum(4)

			--总伤害修正
			local fightEffectValue = attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain) +
				_targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain) + 
				attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack) +
				_targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack)

			fightEffectValue = fightEffectValue/10000+1
			fightEffectValue = math.max(0,fightEffectValue)
			print("------------------------------------vvvvvvvvvvvvvv---")
			print("受到伤害 ==",hurt)
			local  temp_hurt = math.floor(hurt*dzxyBuff.config.value/100 - neiliAttr*dzxyBuff.config.params)
			print("反击伤害==",temp_hurt)
			temp_hurt = math.floor(temp_hurt*fightEffectValue)


			print("反击伤害1 ==",temp_hurt)
			temp_hurt = temp_hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
			temp_hurt = temp_hurt - _targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
			temp_hurt = temp_hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
			temp_hurt = temp_hurt - _targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
		
			print("反击伤害2 ==",temp_hurt)

			temp_hurt = math.min(-10, temp_hurt)
			backAttackAction.targetlist[1].hurt = temp_hurt
			print("  ========伤害加成减免最终值====",temp_hurt)
			self:CaculateDZXYBuff(backAttackAction.targetlist[1], _targetRole)
		else
			backAttackAction.targetlist[1] = {}
			backAttackAction.targetlist[1].hurt = buffHurt
			self:CaculateDZXYBuff(backAttackAction.targetlist[1], _targetRole)
			backAttackAction.targetlist[1].hurt = math.max(buffHurt, backAttackAction.targetlist[1].hurt)
		end

		local lingHunLianJieRole = self:hasLingHunLianJie(backAttackAction.targetlist)
		if lingHunLianJieRole then
			self:setLingHunLianJie(lingHunLianJieRole,backAttackAction.targetlist)
		end

		return
	end
	backAttackAction.targetlist[1] = {}
	backAttackAction.targetlist[1].targetpos = targetRole.logicInfo.posindex
	backAttackAction.targetlist[1].effect = 1
	local neiliAttr = attackRole:GetAttrNum(4)
	local buffHurt = -1
	local isBuffTarget = false
	buffHurt, isBuffTarget= self:CaculateSelfTargetHurtEnd(targetRole, buffHurt)
	if (not isBuffTarget) then
		--总伤害修正
		local fightEffectValue = attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain) +
			targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain) + 
			attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack) +
			targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack)

		fightEffectValue = fightEffectValue/10000+1
		fightEffectValue = math.max(0,fightEffectValue)

		print("------------------------------------vvvvvvvvvvvvvv---")
		print("受到伤害 ==",hurt)
		local  temp_hurt = math.floor(hurt*dzxyBuff.config.value/100 - neiliAttr*dzxyBuff.config.params)
		print("反击伤害==",temp_hurt)

		temp_hurt = math.floor(temp_hurt*fightEffectValue)
		print("反击伤害1 ==",temp_hurt)

		temp_hurt = temp_hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
		temp_hurt = temp_hurt - targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
		temp_hurt = temp_hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
		temp_hurt = temp_hurt - targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
			-- targetInfo[i].hurt = math.max(0, targetInfo[i].hurt)
		print("反击伤害2 ==",temp_hurt)


		temp_hurt = math.min(-10, temp_hurt) 
		backAttackAction.targetlist[1].hurt = temp_hurt--math.floor(temp_hurt*dzxyBuff.config.value/100 - neiliAttr*dzxyBuff.config.params)
		-- print("========伤害加成减免最终值====",backAttackAction.targetlist[1].hurt)
		print(self.actionCount,"  ========伤害加成减免最终值====",backAttackAction.targetlist[1].hurt)
		self:CaculateDZXYBuff(backAttackAction.targetlist[1],targetRole)
	else
		backAttackAction.targetlist[1].hurt = buffHurt
		self:CaculateDZXYBuff(backAttackAction.targetlist[1], targetRole)
		backAttackAction.targetlist[1].hurt = math.max(buffHurt, backAttackAction.targetlist[1].hurt)
	end
	
	local lingHunLianJieRole = self:hasLingHunLianJie(backAttackAction.targetlist)
	if lingHunLianJieRole then
		self:setLingHunLianJie(lingHunLianJieRole,backAttackAction.targetlist)
	end
	
	self.backAttackActionList:pushBack(backAttackAction)
end

--反击action
function FightRoundManager:SetBackAttackAction(attackRole, targetRole, skillid, triggerSkillType, exclude)
	if FightManager.isReplayFight then
		return
	end
	if attackRole:IsLive() == false then
		return
	end
	-- if targetRole:IsLive() == false and not exclude then
	-- end
	
	if attackRole:HaveForbidBackAttackBuff() and triggerSkillType ~= 8 then
		return
	end
	local buffType_10 = attackRole:GetBuffByType(10)
	if buffType_10 and triggerSkillType ~= 8 then
		return
	end

	-- if self:_HaveBackAttackAction() then
	-- 	return
	-- end
	if triggerSkillType == nil then
		triggerSkillType = 0
	end

	if (fightRoleMgr:IsSameSide({attackRole, targetRole})) then
		--自己人
		if triggerSkillType ~= 3 and triggerSkillType ~= EnumFightTriggerHurtType.type_15 and triggerSkillType ~= EnumFightTriggerHurtType.type_23 then
			return
		end
	end
	if skillid == nil then
		skillid = {skillId = 0 ,level = 0 }
	end
	if buffType_10 and triggerSkillType ~= 8 then
		skillid.skillId = 0 
		skillid.level = 0
	end
	self.backAttackActionList = self.backAttackActionList or TFArray:new()
	local  backAttackAction = {}

	backAttackAction.bManualAction 	= false
	backAttackAction.unExecute 		= true
	backAttackAction.roundIndex 	= self.nCurrRoundIndex
	backAttackAction.attackerpos 	= attackRole.logicInfo.posindex
	backAttackAction.skillid 		= skillid--{skillId = 0 , level = 0}
	backAttackAction.bBackAttack 	= true
	backAttackAction.triggerType 	= triggerSkillType or 0
	backAttackAction.backTarget 	= targetRole
	backAttackAction.isDZXY 		= false
	backAttackAction.bHaveTarget 	= false
	local triggerList = {
		9,
		12,
		EnumFightTriggerHurtType.type_14,
		EnumFightTriggerHurtType.type_16,
		-- EnumFightTriggerHurtType.type_22,
	}
	for i,v in ipairs(triggerList) do
		if triggerSkillType == v then
			backAttackAction.bBackAttack = false
			break
		end
	end
	if (triggerSkillType == EnumFightTriggerHurtType.type_22) then
		attackRole:addTriggerSkillCount(backAttackAction.skillid.skillId, 1)
	elseif (triggerSkillType == EnumFightTriggerHurtType.type_23) then
		backAttackAction.bHaveTarget 	= true
	end
	--
	self.backAttackActionList:pushBack(backAttackAction)
end

function FightRoundManager:HaveBackAttackAction()
	if self.backAttackActionList == nil then
		return false
	end
	if self.backAttackActionList:length() == 0 then
		return false
	end
	local action = self.backAttackActionList:objectAt(1)
	return action.bBackAttack
end
function FightRoundManager:_HaveBackAttackAction()
	if self.backAttackActionList == nil then
		return false
	end
	return self.backAttackActionList:length() ~= 0
end

-- function FightRoundManager:HaveBackAttackBuff(endActionInfo)
-- 	local attackerRole = fightRoleMgr:GetRoleByGirdIndex(endActionInfo.attackerpos)
-- 	if attackerRole == nil then
-- 		return false
-- 	end
-- 	local attackEnemy = not attackerRole.logicInfo.bEnemyRole
-- 	local role = self:IsHaveEndAddAttackBuffRole(attackEnemy)
-- 	if role then
-- 		self:SetBackAttackAction(role,attackerRole)
-- 		role:OnBuffTrigger(5)
-- 		return true
-- 	end
-- 	return false
-- end


function FightRoundManager:_caculateTargetBackAttackHurt( newAction )
	local attackRole = fightRoleMgr:GetRoleByGirdIndex(newAction.attackerpos)
	if attackRole == nil or not attackRole:IsLive() then
		return false
	end

	local targetList = {}
	local triggerType = newAction.triggerType or 0
	if (triggerType == EnumFightTriggerHurtType.type_12) then
		local buff_83 = attackRole:GetBuffByType(EnumFightBufferType.type_83)
		if(buff_83) then
			attackRole:OnBuffTriggerByTypeInfo(buff_83)
		else
			return false
		end
	end
	if newAction.skillid.skillId == 0 then
		targetList[1] = newAction.backTarget
		if newAction.backTarget:IsLive() then
			newAction.targetlist = self:CaculateTargetBackAttackHurt(attackRole, newAction.skillid , targetList)
			local lingHunLianJieRole = self:hasLingHunLianJie(newAction.targetlist)
			if lingHunLianJieRole then
				self:setLingHunLianJie(lingHunLianJieRole,newAction.targetlist)
			end
		else
			return false
		end
	else
		local triggerType = newAction.triggerType or 0
		if attackRole:GetBuffByType(18) and triggerType ~= 8 then
			local _targetRole = fightRoleMgr:GetDefianceTarget(attackRole)
			if _targetRole and _targetRole:IsLive() then
				local targetList = {_targetRole}
				newAction.targetlist = self:CaculateTargetHurt(attackRole, newAction.skillid, targetList,targetList)
				local lingHunLianJieRole = self:hasLingHunLianJie(newAction.targetlist)
				if lingHunLianJieRole then
					self:setLingHunLianJie(lingHunLianJieRole,newAction.targetlist)
				end
				if newAction.skillid.skillId ~= 0 then
					self:setFearBuff(attackRole, newAction.targetlist)
				end
				return true
			end
		elseif (triggerType == EnumFightTriggerHurtType.type_23 and GameConfig.HD) then
			--陈圆圆治病回复 不重新选择目标 暂时性不同步国服
			targetList[1] = newAction.backTarget
			newAction.targetlist = self:CaculateTargetBackAttackHurt(attackRole, newAction.skillid, targetList,extra_targetList)
			return true
		end
		local extra_targetList = {}
		local skillInfo = SkillLevelData:objectByID(newAction.skillid)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(newAction.skillid)
		if skillInfo == nil or skillBaseInfo == nil then
			print("skill not find：" ,newAction.skillid)
		end
		local targetType = skillBaseInfo.target_type
		local targetNum = skillInfo.target_num
		if targetNum == nil or targetNum == 0 then
			targetNum = 1
		end
		if skillInfo == nil then
			targetType = 1
		end
		if targetType == 1 then
			targetList[1] = newAction.backTarget
		else
			targetList = self:getTargetListBySkillInfo( targetType,targetNum,attackRole )
		end

		if skillInfo and skillBaseInfo.extra_buffid > 0 then
			extra_targetList = self:getTargetListBySkillInfo( skillBaseInfo.extra_targe_type ,skillInfo.extra_buff_targetnum ,attackRole)
		end
		if not targetList then
			return false
		end

		if #targetList > 0 then
			newAction.targetlist = self:CaculateTargetBackAttackHurt(attackRole, newAction.skillid, targetList,extra_targetList)
			local lingHunLianJieRole = self:hasLingHunLianJie(newAction.targetlist)
			if lingHunLianJieRole then
				self:setLingHunLianJie(lingHunLianJieRole,newAction.targetlist)
			end
			if newAction.skillid.skillId ~= 0 then
				self:setFearBuff(attackRole, newAction.targetlist)
			end
		end
	end	
	return true
end
function FightRoundManager:RemoveBackAttackActionList(roleIndex, triggerType)
	for action in self.backAttackActionList:iterator() do
		if (triggerType == action.triggerType and roleIndex == action.attackerpos) then
			self.backAttackActionList:removeObject(action)
		end
	end
end
function FightRoundManager:ExecuteBackAttackAction(endActionInfo)
	if self.backAttackActionList == nil or self.backAttackActionList:length() == 0 then
		return false
	end
	while self.backAttackActionList:length() > 0 do 
		local newAction = self.backAttackActionList:pop()
		-- local newAction = clone(self.backAttackAction)
		-- self.backAttackAction = nil

		if newAction.isDZXY then
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(newAction.targetlist[1].targetpos)
			if targetRole == nil or not targetRole:IsLive() then
				newAction = nil
			end
		else
			if not self:_caculateTargetBackAttackHurt(newAction) then
				newAction = nil
			end
		end
		if newAction then
			newAction.unExecute = false
			local bInsert = false
			local actionNum = self.actionList:length()
			for i=1,actionNum do
				local actionInfo = self.actionList:objectAt(i)
				if actionInfo and actionInfo.unExecute then --actionInfo == endActionInfo then
					self.actionList:insertAt(i, newAction)
					bInsert = true
					break
				end
			end
			if not bInsert then
				self.actionList:pushBack(newAction)
			end
			local triggerType = newAction.triggerType or 0
			if triggerType ~= 8 then
				self:ExecuteAction(newAction)
			else
				self:ExecuteAction(newAction,true)
			end
			return true
		end
	end
	return false
end

function FightRoundManager:AddReplayAction(replayList)
	self.actionList:clear()
	if replayList == nil then
		return
	end

	local actionNum = #replayList
	for i=1,actionNum do
		local replayAction = replayList[i]
		local action = {}
		action.bManualAction = replayAction.bManualAction
		action.bAngerManualAction = replayAction.bAngerManualAction or false
		action.bBackAttack = replayAction.bBackAttack
		action.unExecute = true
		action.roundIndex = replayAction.roundIndex
		action.triggerType = replayAction.triggerType or 0

		action.attackerpos = replayAction.attackerpos
		if action.attackerpos == 18 then
			action.attackerpos = 19
		elseif action.attackerpos == 19 then
			action.attackerpos = 18
		elseif action.attackerpos < 9 then
			action.attackerpos = action.attackerpos + 9
		else
			action.attackerpos = action.attackerpos - 9
		end

		action.skillid = {skillId = replayAction.skillid ,level = replayAction.skillLevel}

		action.targetlist = replayAction.targetlist
		local nTargetCount = #action.targetlist
		for i=1,nTargetCount do
			local targetInfo = action.targetlist[i]
			if targetInfo.targetpos == 18 then
				targetInfo.targetpos = 19
			elseif targetInfo.targetpos == 19 then
				targetInfo.targetpos = 18
			elseif targetInfo.targetpos < 9 then
				targetInfo.targetpos = targetInfo.targetpos + 9
			else
				targetInfo.targetpos = targetInfo.targetpos - 9
			end
			if targetInfo.effect == 9 then
				if targetInfo.activeEffect == 18 then
					targetInfo.activeEffect = 19
				elseif targetInfo.activeEffect == 19 then
					targetInfo.activeEffect = 18
				elseif targetInfo.activeEffect < 9 then
					targetInfo.activeEffect = targetInfo.activeEffect + 9
				else
					targetInfo.activeEffect = targetInfo.activeEffect - 9
				end
			end
		end
		action.buffList = {}
		if replayAction.stateList then
			for i=1,#replayAction.stateList do
				local length = #action.buffList
				local state = replayAction.stateList[i]
				action.buffList[length+1] = {}
				if state.frompos == 18 then
					action.buffList[length+1][1] = 19
				elseif state.frompos == 19 then
					action.buffList[length+1][1] = 18
				elseif state.frompos < 9 then
					action.buffList[length+1][1] = state.frompos + 9
				else
					action.buffList[length+1][1] = state.frompos - 9
				end

				if state.targetpos == 18 then
					action.buffList[length+1][2] = 19
				elseif state.targetpos == 19 then
					action.buffList[length+1][2] = 18
				elseif state.targetpos < 9 then
					action.buffList[length+1][2] = state.targetpos + 9
				else
					action.buffList[length+1][2] = state.targetpos - 9
				end
				action.buffList[length+1][3] = state.stateId
				action.buffList[length+1][4] = state.skillId
				action.buffList[length+1][5] = state.skillLevel
				action.buffList[length+1][6] = state.bufferId
				action.buffList[length+1][7] = state.bufferLevel
			end
		end

		self.actionList:pushBack(action)
	end
end

function FightRoundManager:AddReplayActionNoChangPos(replayList)
	self.actionList:clear()
	if replayList == nil then
		return
	end

	local actionNum = #replayList
	for i=1,actionNum do
		local replayAction = replayList[i]
		local action = {}
		action.bManualAction = replayAction.bManualAction
		action.bAngerManualAction = replayAction.bAngerManualAction or false
		action.bBackAttack = replayAction.bBackAttack
		action.unExecute = true
		action.roundIndex = replayAction.roundIndex
		action.triggerType = replayAction.triggerType or 0

		action.attackerpos = replayAction.attackerpos

		action.skillid = {skillId = replayAction.skillid ,level = replayAction.skillLevel}

		action.targetlist = replayAction.targetlist
		action.buffList = {}
		if replayAction.stateList then
			for i=1,#replayAction.stateList do
				local length = #action.buffList
				local state = replayAction.stateList[i]
				action.buffList[length+1] = {}

				action.buffList[length+1][1] = state.frompos
				action.buffList[length+1][2] = state.targetpos
				action.buffList[length+1][3] = state.stateId
				action.buffList[length+1][4] = state.skillId
				action.buffList[length+1][5] = state.skillLevel
				action.buffList[length+1][6] = state.bufferId
				action.buffList[length+1][7] = state.bufferLevel
			end
		end
		-- action.buffList = replayAction.stateList
		self.actionList:pushBack(action)
	end
end

function cmpAgilityFun(role1, role2)
	if role1:GetAttrNum(5) < role2:GetAttrNum(5) then
        return false
    else
        return true
    end
end

function FightRoundManager:GetAttackOrder()
	local maxNum = 5
	local orderList = {}

	if self.currAction ~= nil and self.currAction.actionInfo.bBackAttack ~= true then
		orderList[1] = {}
		orderList[1].fightRole = self.currAction.attackerRole
		orderList[1].bManualAction = self.currAction.actionInfo.bManualAction
		orderList[1].bAngerManualAction = self.currAction.actionInfo.bAngerManualAction
		orderList[1].triggerType = self.currAction.actionInfo.triggerType or 0
	end

	-- local actionNum = self.actionList:length()
	-- for i=1,actionNum do
	-- 	local actionInfo = self.actionList:objectAt(i)
	for actionInfo in self.actionList:iterator() do
		if actionInfo.unExecute and (actionInfo.bManualAction or actionInfo.bAngerManualAction) then
			local attackRole = fightRoleMgr:GetRoleByGirdIndex(actionInfo.attackerpos)
			local num = #orderList
			if attackRole ~= nil and attackRole:IsLive() and num < maxNum then
				orderList[num+1] = {}
				orderList[num+1].fightRole = attackRole
				orderList[num+1].bManualAction = actionInfo.bManualAction
				orderList[num+1].bAngerManualAction = actionInfo.bAngerManualAction
				orderList[num+1].triggerType = actionInfo.triggerType or 0

			end
		end
	end

	if #orderList >= maxNum then
		return orderList
	end

	local unAttackList = TFArray:new()
	for k,role in pairs(fightRoleMgr.map) do
		if role:IsLive() and role:HaveForbidAttackBuff() == false and role.haveAttack == false then
			unAttackList:pushBack(role) 
		end
	end

	local unAttackNum = unAttackList:length()
	if unAttackNum == 0 then
		return orderList
	end

	unAttackList:sort(cmpAgilityFun)
	for i=1,unAttackNum do
		local currNum = #orderList
		if currNum >= maxNum then
			break
		end
		orderList[currNum+1] = {}
		orderList[currNum+1].fightRole = unAttackList:objectAt(i)
		orderList[currNum+1].bManualAction = false
		orderList[currNum+1].bAngerManualAction = false
		orderList[currNum+1].triggerType = 0
	end

	return orderList
end

function FightRoundManager:hasBuffByType(buff_type ,bEnemyRole, isTeammateOnly)
	local targetIsEnemy = not bEnemyRole
	if (isTeammateOnly) then
		targetIsEnemy = bEnemyRole
	end
	local liveList = fightRoleMgr:GetAllLiveRole(targetIsEnemy, false,false)
	-- local liveNum = liveList:length()
	-- for i=1,liveNum do
		-- local role = liveList:objectAt(i)
	for role in liveList:iterator() do
		if role:GetBuffByType(buff_type) then
			return true
		end
	end
	return false
end

function FightRoundManager:hasOrGiveBuff(triggerBuffID, buff, attackRole, isTeammateOnly)
	local attackIsEnemy = attackRole.logicInfo.bEnemyRole
	local targetType 	= tonumber(buff.params)
	local targetIsEnemy = not attackIsEnemy
	if (isTeammateOnly == true) then
		targetIsEnemy = attackIsEnemy
	end
	local liveList = fightRoleMgr:GetAllLiveRole(targetIsEnemy, false, false)
	for role in liveList:iterator() do
		if role:GetBuffByType(buff.type) then
			return
		end
	end
	local targetList = {}
	if targetType == 1 then -- 单体技能
		targetList = fightRoleMgr:GetSingleTarget(attackRole)
	elseif targetType == 2 then -- 全屏技能
		targetList = fightRoleMgr:GetScreenTarget(targetIsEnemy)
	elseif targetType == 3 then -- 横排贯穿技能
		targetList = fightRoleMgr:GetRowTarget(attackRole)
	elseif targetType == 4 then -- 竖排穿刺技能
		targetList = fightRoleMgr:GetColumnTarget(attackRole)
	elseif targetType == 5 then -- 敌方随机
		targetList = fightRoleMgr:GetRandomTarget(targetIsEnemy, 1)
	elseif targetType == 6 then -- 敌方血最少
		targetList = fightRoleMgr:GetTargetByAttr(1, targetIsEnemy, false, 1)
	elseif targetType == 7 then -- 敌方防最少
		targetList = fightRoleMgr:GetTargetByAttr(3, targetIsEnemy, false, 1)
	elseif targetType == 8 then -- 我方随机
		targetList = fightRoleMgr:GetRandomTarget(attackIsEnemy, 1)
	elseif targetType == 9 then -- 我方血最少
		targetList = fightRoleMgr:GetTargetByAttr(1, attackIsEnemy, false, 1)
	elseif targetType == 10 then -- 我方全体
		targetList = fightRoleMgr:GetScreenTarget(attackIsEnemy)
	elseif targetType == 11 then -- 自己
		targetList = {attackRole}
	elseif targetType == 12 then -- 敌方防最高
		targetList = fightRoleMgr:GetTargetByAttr(3, targetIsEnemy, true, 1)
	elseif targetType == 13 then -- 敌方内力最高
		targetList = fightRoleMgr:GetTargetByAttr(4, targetIsEnemy, true, 1)
	elseif targetType == 14 then -- 敌方内力最少
		targetList = fightRoleMgr:GetTargetByAttr(4, targetIsEnemy, false, 1)
	elseif targetType == 15 then -- 敌方武力最高
		targetList = fightRoleMgr:GetTargetByAttr(2, targetIsEnemy, true, 1)
	elseif targetType == 16 then -- 敌方武力最少
		targetList = fightRoleMgr:GetTargetByAttr(2, targetIsEnemy, false, 1)
	elseif targetType == 17 then -- 我方武力最高
		targetList = fightRoleMgr:GetTargetByAttr(2, attackIsEnemy, true, 1)
	elseif targetType == 18 then -- 我方武力最少
		targetList = fightRoleMgr:GetTargetByAttr(2, attackIsEnemy, false, 1)
	elseif targetType == 19 then -- 我方内力最高
		targetList = fightRoleMgr:GetTargetByAttr(4, attackIsEnemy, true, 1)
	elseif targetType == 20 then -- 我方内力最少
		targetList = fightRoleMgr:GetTargetByAttr(4, attackIsEnemy, false, 1)
	elseif targetType == 21 then -- 横排贯穿技能
		targetList = fightRoleMgr:GetRowTarget(attackRole , false)
	elseif targetType == 22 then -- 竖排穿刺技能
		targetList = fightRoleMgr:GetSelfColumnTarget(attackRole)
	elseif targetType == 23 then -- 敌方身法最高
		targetList = fightRoleMgr:GetTargetByAttr(EnumAttributeType.Agility, targetIsEnemy, true, 1)
	elseif targetType == 24 then -- 敌方身法最少
		targetList = fightRoleMgr:GetTargetByAttr(EnumAttributeType.Agility, targetIsEnemy, false, 1)
	elseif targetType == 25 then -- 正前方十字
		targetList = fightRoleMgr:GetAwardTenTarget(attackRole)
	elseif targetType == 26 then -- 我方随机两个 排除自己 实在没有人的情况上就上自己吧
		targetList = fightRoleMgr:GetRandomTargetDouble(attackRole.logicInfo, attackIsEnemy, 2, self.actionList)
	elseif targetType == 27 then -- 酒桶召唤阵位
		targetList = fightRoleMgr:getRoleSummonedByRole(attackRole, attackIsEnemy)
	elseif targetType == 28 then -- 我方血量最少，不包括自己
		targetList = fightRoleMgr:GetTargetByAttr(1, attackIsEnemy, false, 2, attackRole)
	-- elseif targetType == 29 then -- 施放技能角色正后方
	elseif targetType == 30 then -- 敌方最大血量值对自己低
		targetList = fightRoleMgr:getEnemyMaxHpList(attackRole)
	elseif targetType == 31 then -- 已方最大血量上限
		targetList = fightRoleMgr:getMaxLimit(targetIsEnemy)
	else
		assert(false, buff.id.."  targetType error")
	end
	if not targetList then
		return
	end
	--
	for i,targetRole in ipairs(targetList) do
		if targetRole:IsLive() then
			if targetRole:AddBuff(attackRole,buff.id, 1,0) then
				self:AddPermanentBuf(attackRole, targetRole ,{skillid = 0, level = 0},buff.id, triggerBuffID)
			end
		end

	end
end

function FightRoundManager:AddPermanentBuf(fromRole, targetRole, skillInfo,bufferID, triggerBuffID )
	local buffInfo = {}
	buffInfo[1] = fromRole.logicInfo.posindex
	buffInfo[2] = targetRole.logicInfo.posindex
	buffInfo[3] = triggerBuffID
	buffInfo[4] = skillInfo.skillid
	buffInfo[5] = skillInfo.level
	buffInfo[6] = bufferID
	buffInfo[7] = 1

	local num = #self.permanentBufList
	self.permanentBufList[num+1] = buffInfo
end
function FightRoundManager:CaculateTargetBackAttackHurt(attackRole, skillID, targetList, extra_targetList, triggerSkillType)
	return self:CaculateTargetHurt(attackRole, skillID, targetList ,extra_targetList, true, triggerSkillType)
end


function FightRoundManager:isImmuneByIndex( targetRole,index )
	local immune = targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune,index)
	if immune ~= nil and immune > 0 then
		local random = math.random(1, 10000)
		if random <= immune then
			return false
		end
	end
	return true
end

function FightRoundManager:CaculateDZXYBuff(targetInfo, targetRole )
	--是否触发被动效果:反弹5 反击6 化解7 复活9 免疫12 受击加血50
	effectValue = {}
	fightRoleMgr:clearSpecialTime()
	if targetRole:GetBuffByType(64)  then
		print("r伤害转治疗")
		targetInfo.hurt = math.abs(targetInfo.hurt)
		return
	end
	if  math.abs(targetInfo.hurt) >= targetRole:getCurrHp()  and targetRole:TrigerHurtMianyiSkill(37, effectValue)then
		targetInfo.passiveEffect = 37
		effectValue.targetRole._specialSkillTime = effectValue.targetRole._specialSkillTime or 0
		effectValue.targetRole._specialSkillTime = effectValue.targetRole._specialSkillTime + 1
		-- targetRole.haveXianTianGong = targetRole.haveXianTianGong + 1
		targetInfo.passiveEffectValue = effectValue.value
		-- targetInfo.triggerBufferID = effectValue.buff_id
		-- targetInfo.triggerBufferLevel = effectValue.level
	elseif targetRole:TriggerPassiveEffect(9, effectValue) then
		targetInfo.passiveEffect = 9
		effectValue.value = math.min(100, effectValue.value)
		targetInfo.passiveEffectValue = targetRole.maxhp * effectValue.value / 100
		targetInfo.passiveEffectValue = math.floor(targetInfo.passiveEffectValue)
	elseif targetRole:TrigerXianTianGongSkill(25, effectValue) and math.abs(targetInfo.hurt) >= targetRole:getCurrHp()  then
		targetInfo.passiveEffect = 25
		-- targetInfo.hurt = 1
		targetRole.haveXianTianGong = targetRole.haveXianTianGong + 1
		targetInfo.passiveEffectValue = effectValue.value
		targetInfo.triggerBufferID = effectValue.value
		targetInfo.triggerBufferLevel = effectValue.level
	elseif (math.abs(targetInfo.hurt) < targetRole:getCurrHp() and targetInfo.activeEffect ~= 26) and targetRole:TriggerPassiveEffect(39, effectValue) then
		targetInfo.passiveEffect = 39
		-- effectValue.value = math.min(100, effectValue.value)
		targetInfo.passiveEffectValue = targetRole.maxhp * effectValue.value / 100
		targetInfo.passiveEffectValue = math.abs(targetInfo.hurt) - math.floor(targetInfo.passiveEffectValue)
		if targetInfo.passiveEffectValue <= 0 then
			targetInfo.passiveEffect = 0
			targetInfo.passiveEffectValue = 0
		end
	elseif targetRole:TriggerPassiveEffect(5, effectValue) and math.abs(targetInfo.hurt) < targetRole:getCurrHp() then
		targetInfo.passiveEffect = 5
		targetInfo.passiveEffectValue = math.abs(targetInfo.hurt) * effectValue.value / 100
		targetInfo.passiveEffectValue = self:CaculateSelfTargetHurtEnd(targetRole, targetInfo.passiveEffectValue)
		targetInfo.passiveEffectValue = math.floor(targetInfo.passiveEffectValue)
	elseif targetRole:TriggerPassiveEffect(7, effectValue) then
		targetInfo.passiveEffect = 7
		effectValue.value = math.min(100, effectValue.value) 
		targetInfo.hurt = targetInfo.hurt * (100-effectValue.value) / 100
		targetInfo.hurt = math.floor(targetInfo.hurt)
	end
	--
	targetRole:TriggerDongXie(targetInfo)
	if targetRole:IsLive() then
		--血刀大法
		local xdBuff = targetRole:GetBuffByType(30)
		if xdBuff ~= nil then
			targetInfo.hurt = targetInfo.hurt * (100-xdBuff.config.value) / 100
			targetInfo.hurt = math.floor(targetInfo.hurt)
			targetInfo.passiveEffect = 50

			-- 己方被治疗修正
			local fightEffectValue = targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing)
			fightEffectValue = fightEffectValue/10000+1
			fightEffectValue = math.max(0,fightEffectValue)

			targetInfo.passiveEffectValue = math.floor(targetRole:GetAttrNum(4)*xdBuff.config.params * fightEffectValue)

			targetInfo.passiveEffectValue = targetInfo.passiveEffectValue + targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing_Num)

			local endBonusHealing 		= targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_EndBonusHealing)
			endBonusHealing = endBonusHealing / 10000 * targetInfo.passiveEffectValue
			targetInfo.passiveEffectValue = targetInfo.passiveEffectValue + endBonusHealing

			targetInfo.passiveEffectValue = math.max(0,targetInfo.passiveEffectValue)
		end
		local msBuff = targetRole:GetBuffByType(32)
		if msBuff ~= nil then
			targetInfo.hurt = targetInfo.hurt * (100-xdBuff.config.value) / 100
			targetInfo.hurt = math.floor(targetInfo.hurt)
			targetInfo.passiveEffect = 7
		end
	
	end
end

function FightRoundManager:pause( ... )
	if self.currAction then
		self.currAction:pause()
	end
end

--反击action 只允许存在一个
function FightRoundManager:SetSkillTrgerSkillAction(attackRole, skillid, triggerSkillType)
	if FightManager.isReplayFight then
		return
	end
	if attackRole:IsLive(true) == false then
		return
	end

	if skillid == nil then
		return
	end
	self.skillTrigerAttackAction 					= {}
	self.skillTrigerAttackAction.bManualAction 		= false
	self.skillTrigerAttackAction.bAngerManualAction = false
	self.skillTrigerAttackAction.unExecute 			= true
	self.skillTrigerAttackAction.roundIndex 		= self.nCurrRoundIndex
	self.skillTrigerAttackAction.attackerpos 		= attackRole.logicInfo.posindex
	self.skillTrigerAttackAction.skillid 			= skillid--{skillId = 0 , level = 0}
	self.skillTrigerAttackAction.bBackAttack 		= false
	self.skillTrigerAttackAction.triggerType 		= triggerSkillType or 0
	self.skillTrigerAttackAction.isbackAttack 		= true

	self.skillTrigerAttackAction.targetlist = self:GetActionTargetInfo(attackRole, self.skillTrigerAttackAction.skillid, true, triggerSkillType)
	
	if self.skillTrigerAttackAction.targetlist == nil or #self.skillTrigerAttackAction.targetlist == 0 then
		local targetEnemy = not attackRole.logicInfo.bEnemyRole
		if fightRoleMgr:CleanFrozenBuffRole(targetEnemy) then
			self.skillTrigerAttackAction.targetlist = self:GetActionTargetInfo(attackRole, self.skillTrigerAttackAction.skillid, true, triggerSkillType)
		end

		if self.skillTrigerAttackAction.targetlist == nil or #self.skillTrigerAttackAction.targetlist == 0 then
			-- self:OnActionEnd()
			self.skillTrigerAttackAction  = nil
			return
		end
	end
end
--反击action
function FightRoundManager:SetFuhuoAction(attackRole, skillInfo, saveRole)
	if FightManager.isReplayFight then
		return
	end

	if skillInfo == nil then
		return
	end

	if attackRole:IsLive() == false then
		return
	end
	if (saveRole:IsLive()) then
		return
	end
	
	for _,action in pairs(self.fuhuoActionList) do
		if (action.targetlist) then
			for i,targetInfo in ipairs(action.targetlist) do
				if (targetInfo.targetpos == saveRole.logicInfo.posindex) then
					return
				end
			end
		end
	end
	local fuhuoAction 				= {}
	fuhuoAction.bManualAction 		= false
	fuhuoAction.bAngerManualAction 	= false
	fuhuoAction.unExecute 			= true
	fuhuoAction.roundIndex 			= self.nCurrRoundIndex
	fuhuoAction.attackerpos 		= attackRole.logicInfo.posindex
	fuhuoAction.skillid 			= {skillId = skillInfo.id , level = skillInfo.level}
	fuhuoAction.bBackAttack 		= false
	fuhuoAction.triggerType 		= 0
	fuhuoAction.targetlist 			= self:GetFuhuoActionTargetInfo(attackRole, fuhuoAction.skillid, saveRole)
	
	if fuhuoAction.targetlist == nil or #fuhuoAction.targetlist == 0 then
		fuhuoAction  = nil
		return
	end
	local bInsert = false
	if (skillInfo.type == EnumFightSkillType.type_14 and skillInfo.effect == EnumFightActiveEffectType.effect_62) then
		--金蛇复活优先复活最后排侠客
		for _,action in pairs(self.fuhuoActionList) do
			if (action.targetlist[1]) then
				if (saveRole.logicInfo.posindex > action.targetlist[1].targetpos) then
					table.insert( self.fuhuoActionList, 1, fuhuoAction )
					bInsert = true
					break
				end
			end
		end
	else
		attackRole.fuhuoSkillTime = attackRole.fuhuoSkillTime or 0
		attackRole.fuhuoSkillTime = attackRole.fuhuoSkillTime + 1
	end
	if not bInsert then
		table.insert( self.fuhuoActionList, fuhuoAction)
	end
end

function FightRoundManager:HaveFuhuoActionAction()
	if (self.fuhuoActionList ~= nil and #self.fuhuoActionList > 0) then
		return true
	end
	return false
end


function FightRoundManager:ExecuteFuhuoAction(endActionInfo)
	if self.fuhuoActionList == nil or #self.fuhuoActionList <= 0 then
		return false
	end

	local newAction = clone(self.fuhuoActionList[1])
	newAction.unExecute = false
	table.remove( self.fuhuoActionList, 1)
	
	local attackRole = fightRoleMgr:GetRoleByGirdIndex(newAction.attackerpos)
	if attackRole == nil or not attackRole:IsLive() then
		--复活失败状态清除
		if (newAction.targetlist) then
			for _,targetInfo in ipairs(newAction.targetlist) do
				local fuHuoRoleInfo = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
				if (fuHuoRoleInfo)then
					if (not fuHuoRoleInfo:IsLive()) then
						fuHuoRoleInfo:fuHuoFeated()
					else
						--金蛇复活队友自身受伤害无敌BUFF处理
						if (targetInfo.activeEffect == EnumFightActiveEffectType.effect_63) then
							targetInfo.hurt = self:CaculateSelfTargetHurtEnd(fuHuoRoleInfo, targetInfo.hurt)
						end
					end
				end
			end
		end
		return false
	end

	local bInsert = false
	-- local actionNum = self.actionList:length()
	-- for i=1,actionNum do
	-- 	local actionInfo = self.actionList:objectAt(i)
	local index = 0
	for actionInfo in self.actionList:iterator() do
		index = index + 1
		if actionInfo and actionInfo.unExecute then --actionInfo == endActionInfo then
			self.actionList:insertAt(index, newAction)
			bInsert = true
			break
		end
	end

	if not bInsert then
		self.actionList:pushBack(newAction)
	end
	self:ExecuteAction(newAction, true)
	return true
end


function FightRoundManager:ExecuteEndKillRoleAction()
	local selfRoleList, enemyRoleList = fightRoleMgr:GetAllRoleBySkill(EnumFightTriggerHurtType.type_20)
	local tempRoleList = TFArray:new()
	-- for role in selfRoleList:iterator() do
	-- 	tempRoleList:push(role)
	-- end
	for role in enemyRoleList:iterator() do
		selfRoleList:push(role)
	end

	local function sort_function(role1,role2)
		return role1:GetAttrNum(EnumAttributeType.Agility) < role2:GetAttrNum(EnumAttributeType.Agility)
	end
	--身法排序
	selfRoleList:sort(sort_function)
	local attackRole = selfRoleList:getObjectAt(1)

	if (not attackRole) then
		return
	end

	local function getKillAction(role)
		if (not role) then
			return
		end
		local _skillInfo = role:HasTriggerSkillBySkill(role.skillID, EnumFightTriggerHurtType.type_20)
		if (not _skillInfo) then
			return
		end
		local _skillId = {skillId = _skillInfo.triggerSkill, level = _skillInfo.level}
		if not role:TriggerSkillIdCount(_skillInfo.id, _skillInfo.special_num) then
			return
		end
		
		local skillInfo 	= SkillLevelData:objectByID(_skillId)
		local hpTargetList 	= fightRoleMgr:GetTargetByAttr(EnumAttributeType.Blood, not role.logicInfo.bEnemyRole, false, skillInfo.target_num)
		local targetList 	= {}
		for i,role in ipairs(hpTargetList) do
			if (role:getCurrHp() < (role:getMaxHp() * skillInfo.effect_value / 100)) then
				table.insert( targetList, role )
			end
		end
		if (#targetList <= 0) then
			return
		end
		---
		local newAction 				= {}
		newAction.bManualAction 		= false
		newAction.bAngerManualAction 	= false
		newAction.unExecute 			= true
		newAction.roundIndex 			= self.nCurrRoundIndex
		newAction.attackerpos 			= role.logicInfo.posindex
		newAction.skillid 				= _skillId
		newAction.triggerType 			= EnumFightTriggerHurtType.type_20
		newAction.targetlist 			= self:CaculateTargetHurt(role, newAction.skillid, targetList)
		if (#newAction.targetlist <= 0) then
			return
		end
		role:addTriggerSkillCount(_skillInfo.id, 1)
		return newAction
	end
	local newAction1 = getKillAction(attackRole)
	local newAction2 = getKillAction(selfRoleList:getObjectAt(2))
	--
	
	--
	if (not newAction1 and not newAction2) then
		return
	end
	if (not newAction1 and newAction2) then
		newAction1 = newAction2
		newAction2 = nil
	end
	local bInsert = false
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		if actionInfo and actionInfo.unExecute then 
			self.actionList:insertAt(i, newAction1)
			if (newAction2) then
				self.actionList:insertAt(i + 1, newAction2)
			end
			bInsert = true
			break
		end
	end

	if not bInsert then
		self.actionList:pushBack(newAction1)
		if (newAction2) then
			self.actionList:pushBack(newAction2)
		end
	end
	-- toastMessage("qqqqqq")
	self:ExecuteAction(newAction1, true)
	return true
end

function FightRoundManager:AddEndAction(sortLevel, info)
	if (info == nil) then
		return
	end
	if (sortLevel < EnumFightEndActionSortLevel.level_1 or sortLevel > EnumFightEndActionSortLevel.level_Max) then
		return
	end
	-- local actionInfo = {}
	-- actionInfo.skillID = skillID
	-- actionInfo.attackIndex = attackIndex
	-- actionInfo.targetlist = targetlist
	-- actionInfo.buffTypeId = buffTypeId
	-- actionInfo.forbid = false 		--是否吃控制,默认false 吃
	--
	self.endActionList[sortLevel] = self.endActionList[sortLevel] or TFArray:new()
	self.endActionList[sortLevel]:pushBack(info)
end


function FightRoundManager:ExecuteEndAction()
	local actionInfo = nil
	for i = EnumFightEndActionSortLevel.level_1, EnumFightEndActionSortLevel.level_Max do
		local actionList = self.endActionList[i]
		if (actionList and actionList:length() > 0) then
			actionInfo = actionList:pop()
			break
		end
	end
	if (actionInfo == nil) then
		--endActionList 容器所有动作已执行完
		return
	end
	local attackRole = fightRoleMgr:GetRoleByGirdIndex(actionInfo.attackIndex)
	if (not attackRole or not attackRole:IsLive()) then
		self:ExecuteEndAction()
		return
	end
	--
	if (not actionInfo.forbid) then
		if (attackRole:HaveTriggerType6AttackBuff()) then
			self:ExecuteEndAction()
			return
		end
	end
	--
	local buffTypeId = actionInfo.buffTypeId
	local buffInfo = nil
	if (buffTypeId) then
		buffInfo = attackRole:GetBuffByType(buffTypeId)
		if (buffInfo == nil) then
			self:ExecuteEndAction()
			return
		end	
	end
	---
	local newAction 				= {}
	newAction.bManualAction 		= false
	newAction.bAngerManualAction 	= false
	newAction.unExecute 			= true
	newAction.roundIndex 			= self.nCurrRoundIndex
	newAction.attackerpos 			= actionInfo.attackIndex
	newAction.skillid 				= actionInfo.skillID
	local targgetLen = #actionInfo.targetList
	for i = targgetLen, 1, -1 do
		local tarRole = actionInfo.targetList[i]
		if (tarRole) then
			if (not tarRole:IsLive()) then
				table.remove( actionInfo.targetList, i)
			end
		else
			table.remove( actionInfo.targetList, i)
		end
	end
	targgetLen = #actionInfo.targetList
	if (#actionInfo.targetList <= 0) then
		self:ExecuteEndAction()
		return
	end
	if (buffInfo) then
		local nValidNum = buffInfo.config.last_num - buffInfo.lastNum
		local nNum 		= nValidNum - targgetLen
		if (nNum < 0) then
			for i = targgetLen, nValidNum + 1, -1 do
				table.remove( actionInfo.targetList, i)
			end
		end
	end
	-- newAction.triggerType 			= EnumFightTriggerHurtType.type_20
	newAction.targetlist 			= self:CaculateTargetHurt(attackRole, newAction.skillid, actionInfo.targetList)

	targgetLen = #newAction.targetlist
	if (targgetLen <= 0) then
		self:ExecuteEndAction()
		return
	end
	if (buffInfo) then
		for i = 1, targgetLen do
			attackRole:OnBuffLastTypeTrigger(buffInfo, EnumFightBuffLastType.last_Type_12)
		end
	end
	--
	local bInsert = false
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		if actionInfo and actionInfo.unExecute then 
			self.actionList:insertAt(i, newAction)
			bInsert = true
			break
		end
	end

	if not bInsert then
		self.actionList:pushBack(newAction)
	end
	-- toastMessage("qqqqqq")
	self:ExecuteAction(newAction, true)
	return true
end

--
function FightRoundManager:HaveSkillTrigerAttackAction()
	return self.skillTrigerAttackAction ~= nil
end

function FightRoundManager:hasRoleSkillTrigerSkill(rolePos)
	if self.skillTrigerAttackAction == nil then
		return false
	end
	return self:hasRoleSkill(self.skillTrigerAttackAction, rolePos) 
end


function FightRoundManager:hasRoleBackAttackSkill(rolePos)
	if self.backAttackActionList == nil or self.backAttackActionList:length() <= 0 then
		return false
	end

	for action in self.backAttackActionList:iterator() do
		if self:hasRoleSkill(action, rolePos) then
			return true
		end
	end
	return false
end

function FightRoundManager:hasRoleHurtAddBloodSkill(rolePos)
	if self.hurtAddBloodActionList == nil or self.hurtAddBloodActionList:length() <= 0 then
		return false
	end

	for action in self.hurtAddBloodActionList:iterator() do
		if self:hasRoleSkill(action, rolePos) then
			return true
		end
	end
	return false
end

function FightRoundManager:hasRoleHelpAttackSkill(rolePos)
	if self.helpAttackActionList == nil or self.helpAttackActionList:length() <= 0 then
		return false
	end

	for action in self.helpAttackActionList:iterator() do
		if action.attackerpos == rolePos then
			return true
		end
	end
	return false
end


function FightRoundManager:hasRoleSkill(actionInfo,attackerpos)
	return actionInfo.attackerpos == attackerpos
end

function FightRoundManager:ExecuteSkillTrigerAttackAction(endActionInfo)
	if self.skillTrigerAttackAction == nil then
		return false
	end

	local newAction = clone(self.skillTrigerAttackAction)
	newAction.unExecute = false
	self.skillTrigerAttackAction = nil

	local attackRole = fightRoleMgr:GetRoleByGirdIndex(newAction.attackerpos)
	if attackRole == nil or not attackRole:IsLive(true) or attackRole:HaveForbidManualSkillBuff() then
		return false
	end

	newAction.targetlist = self:GetActionTargetInfo(attackRole, newAction.skillid, true, newAction.triggerType)
	if newAction.targetlist == nil or #newAction.targetlist == 0 then
		local targetEnemy = not attackRole.logicInfo.bEnemyRole
		if fightRoleMgr:CleanFrozenBuffRole(targetEnemy) then
			newAction.targetlist = self:GetActionTargetInfo(attackRole, newAction.skillid,true)
		end

		if newAction.targetlist == nil or #newAction.targetlist == 0 then
			-- self:OnActionEnd()
			newAction  = nil
			return false
		end
	end

	local bInsert = false
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		if actionInfo and actionInfo.unExecute then --actionInfo == endActionInfo then
			self.actionList:insertAt(i, newAction)
			bInsert = true
			break
		end
	end

	if not bInsert then
		self.actionList:pushBack(newAction)
	end
	-- print("newAction = ",newAction)
	self:ExecuteAction(newAction)
	return true
end



function FightRoundManager:IsHaveYuanHuBuffRole(attackRole, targetInfo)
	if FightManager.isReplayFight then
		return nil
	end
	if attackRole:GetBuffByType(10) then
		return nil
	end
	local roleList = fightRoleMgr:GetAllLiveRole(not attackRole.logicInfo.bEnemyRole,false,false)
	for role in roleList:iterator() do
		if role:IsCanYuaHuBuff() then
			local buff = role:GetBuffByType(61)
			if buff and buff.bValid then
				if (not self:isYuanHuRoleInTarget(role , targetInfo)) then
					return role
				end
			end
			--援护技能
			if (not role:isCanNotTriggerBeiDong()) then
				local skillInfo = role:GetTriggerBySkillHurtType(role.skillID, EnumFightTriggerHurtType.type_18, true)
				if skillInfo then
					if (role:getTriggerSkillCountBySkill(role.skillID.skillId) >= skillInfo.special_num) then
						return nil
					end
					if (not self:isYuanHuRoleInTarget(role , targetInfo)) then
						return role
					end
				end
			end
		end
	end
	return nil
end

--此方法已遗弃 新方法  IsHaveEndAddSkillAttackBuffRole
function FightRoundManager:IsHaveEndAddAttackBuffRole(bEnemyRole)
	if FightManager.isReplayFight then
		return nil
	end
	-- if attackRole:GetBuffByType(10) then
	-- 	return nil
	-- end
	local roleList = fightRoleMgr:GetAllLiveRole(bEnemyRole,false,false)
	for role in roleList:iterator() do
		local buff = role:GetBuffByType(68)
		if buff and buff.bValid then
			-- if role:IsCanYuaHuBuff() then
			return role
			-- end
		end
	end
	return nil
end

--在敌方出手后攻击的BUFF  通用方法
function FightRoundManager:IsHaveEndAddSkillAttackBuffRole(attackRole, skillID)
	if FightManager.isReplayFight then
		return nil
	end
	--
	local backRoleList = {}
	local roleList = fightRoleMgr:GetAllLiveRole(not attackRole.logicInfo.bEnemyRole, false, false)
	for role in roleList:iterator() do
		for i,buffId in ipairs(EnumFightEnemyEndAttackBuff) do
			local buff = role:GetBuffByType(buffId)
			if buff and buff.bValid then
				local isAdd = true
				if (buffId == EnumFightBufferType.type_501) then
					isAdd = false
					if (skillID and skillID.skillId ~= 0) then
						if (attackRole and attackRole.skillID.skillId == skillID.skillId) then
							isAdd = true
						else
							local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
							if (skillBaseInfo and skillBaseInfo.hidden_skill == 3) then
								isAdd = true
							end
						end
					end
				end
				--
				if (isAdd) then
					table.insert( backRoleList, role )
				end
				break
			end
		end
	end
	return backRoleList
end

function FightRoundManager:IsHaveHelpAttack(attackRole)
	-- print("FightRoundManager:IsHaveHelpAttack")
	local hasHelpList = TFArray:new()
	if FightManager.isReplayFight then
		return hasHelpList
	end
	if attackRole:GetBuffByType(10) then
		return hasHelpList
	end

	local roleList = fightRoleMgr:GetAllLiveRole(attackRole.logicInfo.bEnemyRole,false,false)
	for role in roleList:iterator() do
		local buff = role:GetBuffByType(EnumFightBufferType.type_59)
		if buff then
			hasHelpList:pushBack(role)
		end
	end
	return hasHelpList
end

function FightRoundManager:setHelpAttackAction(attackList , targetList)
	if FightManager.isReplayFight then
		return
	end
	if attackList:length() == 0 or #targetList == 0  then
		print("FightRoundManager:setHelpAttackAction == nil")
		return
	end
	self.helpAttackList = self.helpAttackList or TFArray:new()
	self.helpAttackList:clear()
	for attackRole in attackList:iterator() do
		self:_setHelpAttackAction(attackRole, targetList)
	end
end

function FightRoundManager:_setHelpAttackAction(attackRole , targetList)
	print("_setHelpAttackAction ==>")
	if attackRole:IsLive() == false then
		return
	end
	local buff = attackRole:GetBuffByType(EnumFightBufferType.type_59)
	if buff == nil then
		self:_setHelpAttackActionBySkill(attackRole , targetList)
		return
	end

	local skillid ={skillId =  tonumber(buff.config.value) , level = buff.config.level}

	self.helpAttackList = self.helpAttackList or TFArray:new()
	local helpAttackInfo          = {}
	helpAttackInfo.skillid        = skillid
	helpAttackInfo.attackRole     = attackRole
	helpAttackInfo.targetList     = targetList
	helpAttackInfo.helpBuffTypeId = buff.config.type
 	
 	self.helpAttackList:pushBack(helpAttackInfo)

end



function FightRoundManager:_setHelpAttackActionBySkill(attackRole , targetList)
	if attackRole.skillID == nil or attackRole.skillID.skillId == 0 then
		return false
	end
	-- local skillInfo = SkillLevelData:objectByID(attackRole.skillID)
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(attackRole.skillID)
	if skillBaseInfo ~= nil and skillBaseInfo.trigger_hurtType == 5 then
		local skillid ={skillId =  skillBaseInfo.triggerSkill , level = attackRole.skillID.level}
		self.helpAttackList = self.helpAttackList or TFArray:new()
		local helpAttackInfo = {}
		helpAttackInfo.skillid = skillid
		helpAttackInfo.attackRole = attackRole
		helpAttackInfo.targetList = targetList
	 	self.helpAttackList:pushBack(helpAttackInfo)
	end
end


function FightRoundManager:setHelpAttackActionByBuff_New( info , buff_type )
	local attackRole = info.attackRole
	if attackRole:IsLive() == false then
		return
	end
	local buff = attackRole:GetBuffByType(buff_type)
	if buff and buff.bValid then
		self:setHelpAttackAction_New( info )
	end
end
function FightRoundManager:setHelpAttackAction_New( info )
	print("FightRoundManager:setHelpAttackAction_New")
	local attackRole = info.attackRole
	if attackRole:IsLive() == false then
		return
	end

	local skillid = info.skillid
	local targetList = {}
	
	for i=1,#info.targetList do
		local targetRole = info.targetList[i]
		if  targetRole and targetRole:IsLive() and targetRole:HaveFrozenBuff(false) == false then
			targetList[#targetList +1] = targetRole
		end
	end
	if #targetList == 0 then
		return
	end

	local skillInfo = SkillLevelData:objectByID(skillid)
	local targetRole = targetList[1]
	if skillInfo.type ~= 2 and targetRole.logicInfo.bEnemyRole == attackRole.logicInfo.bEnemyRole then
		print("打自己人啊--------------")
		return
	end

	self.helpAttackActionList = self.helpAttackActionList or TFArray:new()
	local  helpAttackAction 			= {}
	helpAttackAction.bManualAction      = false
	helpAttackAction.bAngerManualAction = false
	helpAttackAction.unExecute          = true
	helpAttackAction.roundIndex         = self.nCurrRoundIndex
	helpAttackAction.attackerpos        = attackRole.logicInfo.posindex
	helpAttackAction.skillid            = skillid--{skillId = 0 , level = 0}
	helpAttackAction.bBackAttack        = false
	helpAttackAction.helpBuffTypeId     = info.helpBuffTypeId or 0	--技能触发BUFF的ID
	helpAttackAction.triggerType        = 5    --协助攻击


	helpAttackAction._targetlist = targetList
	

	self.helpAttackActionList:pushBack(helpAttackAction)
end

function FightRoundManager:HaveHelpAttackAction()
	if self.helpAttackActionList == nil then
		return false
	end
	return self.helpAttackActionList:length() ~= 0
end

function FightRoundManager:ExecuteHelpAttackAction(endActionInfo)
	if self.helpAttackActionList == nil or self.helpAttackActionList:length() == 0 then
		return false
	end
	local newAction = self.helpAttackActionList:pop()
	newAction.unExecute = false
	
	local attackRole = fightRoleMgr:GetRoleByGirdIndex(newAction.attackerpos)
	if attackRole == nil or not attackRole:IsLive() then
		--此处clear存疑 貌似有隐藏BUG
		self.helpAttackActionList:clear()
		return false
	end
	if (newAction.helpBuffTypeId and newAction.helpBuffTypeId ~= 0) then
		local helpBuffInfo = attackRole:GetBuffByType(newAction.helpBuffTypeId)
		if (not helpBuffInfo or not helpBuffInfo.bValid) then
			return false
		end
	end
	newAction.targetlist = self:CaculateTargetHelpAttackHurt(attackRole, newAction.skillid, newAction._targetlist)

	local allDie = false
	local lingHunLianJieRoleList = {}
	for i,targetInfo in ipairs(newAction.targetlist) do
		local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
		if targetRole == nil or not targetRole:IsLive() then
			allDie = true
		else
			if targetInfo.effect == EnumFightHurtEffect.effect_1 or EnumFightHurtEffect.effect_2 == targetInfo.effect then
				if not targetInfo.activeEffect or targetInfo.activeEffect ~= 30 then
					local buffList = targetRole:GetBuffListByType({EnumFightBufferType.type_69, EnumFightBufferType.type_523})
					if targetRole and next(buffList) and targetInfo.hurt < 0 and math.abs(targetInfo.hurt) < targetRole:getCurrHp() then
						for buffTypeId,buffInfo in pairs(buffList) do
							local temp = {}
							temp.targetRole = targetRole
							temp.targetInfo = targetInfo
							temp.buffInfo 	= buffInfo
							table.insert(lingHunLianJieRoleList,temp)
						end
					end
				end
			end
		end
	end
	if allDie then
		self.helpAttackActionList:clear()
		return false
	end
	if lingHunLianJieRole then
		local targetRole = fightRoleMgr:GetRoleByGirdIndex(lingHunLianJieRole.targetpos)
		if targetRole == nil then
			return
		end
		local liveList = fightRoleMgr:GetAllLiveRole(not targetRole.logicInfo.bEnemyRole,false,false)
		local liveNum = liveList:length()
		-- local _buff = targetRole:GetBuffByType(69)
		for i=1,liveNum do
			local _targetRole = liveList:objectAt(i)
			local buff = _targetRole:GetBuffByType(70)
			if _targetRole and _targetRole:IsLive() and buff then
				local targetNum = #newAction.targetlist

				local _targetRoleInfo = {}
				_targetRoleInfo.targetpos = _targetRole.logicInfo.posindex
				_targetRoleInfo.hurt = math.floor(lingHunLianJieRole.hurt * tonumber(buff.config.value) /100)
				_targetRoleInfo.effect = 10
				_targetRoleInfo.triggerBufferID = 0
				_targetRoleInfo.triggerBufferLevel = 0
				_targetRoleInfo.activeEffect = lingHunLianJieRole.targetpos

				_targetRoleInfo.hurt, isBuffTarget = self:CaculateSelfTargetHurtEnd(_targetRole, _targetRoleInfo.hurt)
				local _effectValue = {}
				if (math.abs(_targetRoleInfo.hurt) >= _targetRole:getCurrHp() or _targetRoleInfo.activeEffect == 26) and _targetRole:TrigerHurtMianyiSkill(37, _effectValue)then
					_targetRoleInfo.passiveEffect = 37
					_effectValue.targetRole._specialSkillTime = _effectValue.targetRole._specialSkillTime or 0
					_effectValue.targetRole._specialSkillTime = _effectValue.targetRole._specialSkillTime + 1
					-- _targetRole.haveXianTianGong = _targetRole.haveXianTianGong + 1
					_targetRoleInfo.passiveEffectValue = _effectValue.value
					-- _targetRoleInfo.triggerBufferID = _effectValue.buff_id
					-- _targetRoleInfo.triggerBufferLevel = _effectValue.level
				elseif _targetRole:TriggerPassiveEffect(9, _effectValue) then
					_targetRoleInfo.passiveEffect = 9
					_effectValue.value = math.min(100, _effectValue.value)
					_targetRoleInfo.passiveEffectValue = _targetRole.maxhp * _effectValue.value / 100
					_targetRoleInfo.passiveEffectValue = math.floor(_targetRoleInfo.passiveEffectValue)
				elseif _targetRole:TrigerXianTianGongSkill(25, _effectValue) and (math.abs(_targetRoleInfo.hurt) >= _targetRole:getCurrHp() or _targetRoleInfo.activeEffect == 26)then
					_targetRoleInfo.passiveEffect = 25
					_targetRole.haveXianTianGong = _targetRole.haveXianTianGong + 1
					_targetRoleInfo.passiveEffectValue = _effectValue.value
					_targetRoleInfo.triggerBufferID = _effectValue.value
					_targetRoleInfo.triggerBufferLevel = _effectValue.level
				end
				--
				targetRole:TriggerDongXie(_targetRoleInfo)
				newAction.targetlist[targetNum+1] = _targetRoleInfo
			end
		end
	end
	local bInsert = false
	local actionNum = self.actionList:length()
	-- for i=1,actionNum do
	-- 	local actionInfo = self.actionList:objectAt(i)
	-- 	-- if self:needInsert(actionInfo, endActionInfo)
	-- 	if actionInfo and actionInfo.unExecute then -- actionInfo == endActionInfo then
			-- print("self.actionList:insertAt--->>>ExecuteHelpAttackAction = "..(i).."roundIndex = "..newAction.roundIndex.."attackerpos = "..newAction.attackerpos)
	-- 		self.actionList:insertAt(i, newAction)
	-- 		bInsert = true
	-- 		break
	-- 	end
	-- end
	for i=actionNum,1,-1 do
		local actionInfo = self.actionList:objectAt(i)
		if actionInfo and not actionInfo.unExecute then
			-- print("self.actionList:insertAt--->>>ExecuteHelpAttackAction = "..(i+1).."roundIndex = "..newAction.roundIndex.."attackerpos = "..newAction.attackerpos)
			self.actionList:insertAt(i+1, newAction)
			self:ExecuteAction(newAction)
			return true
		end
	end


	if not bInsert then
		-- print("self.actionList:pushBack---ExecuteHelpAttackAction-->>>pos = "..(self.actionList:length()+1).."roundIndex = "..newAction.roundIndex.."attackerpos = "..newAction.attackerpos)
		self.actionList:pushBack(newAction)
	end
	-- attackRole:OnHelpAttackBuffTrigger()

	self:ExecuteAction(newAction)
	return true
end


function FightRoundManager:CaculateTargetHelpAttackHurt(attackRole, skillID, targetList)
	local targetInfo = {}
	local targetNum = #targetList
	local bHaveTrigger = false
	fightRoleMgr:clearSpecialTime()
	for i=1,targetNum do
		targetInfo[i] = {}
		local targetRole = targetList[i]
		targetInfo[i].targetpos = targetRole.logicInfo.posindex
		targetInfo[i].effect = self:CaculateHurtEffect(attackRole, skillID, targetRole, false, true)
		if targetInfo[i].effect == 7 then --主动加buff
			targetInfo[i].hurt = 0
			--触发buffer
			local bufferID , bufferLevel = attackRole:GetTriggerBufferID(skillID, targetRole)
			if bufferID > 0 and SkillBufferData:objectByID(bufferID,bufferLevel) == nil then
				bufferID = 0
				bufferLevel = 0
			end
			targetInfo[i].triggerBufferID = bufferID
			targetInfo[i].triggerBufferLevel = bufferLevel
			local effectValue = {}
			if attackRole:TriggerActiveEffect(skillID, 3, effectValue) then
				targetInfo[i].activeEffect = 3
				targetInfo[i].activeEffectValue = effectValue.value
			end
			local triggerShanBi = true
			if FightManager.fightBeginInfo.fighttype == 10 or FightManager.fightBeginInfo.fighttype == 28 then
				triggerShanBi = false
			end

			local mrll_dzxy = targetRole:GetBuffByType(83)
			if mrll_dzxy ~= nil and triggerShanBi then
				targetInfo[i].effect = 3
				targetInfo[i].triggerSkillType = 12 ---闪避
				targetInfo[i].triggerSkill = skillID
				targetInfo[i].hurt = 0
				targetInfo[i].passiveEffect = 0
				targetInfo[i].passiveEffectValue = 0
				targetInfo[i].activeEffect = 0
				targetInfo[i].activeEffectValue = 0
				targetInfo[i].triggerBufferLevel = 0
				targetInfo[i].triggerBufferID = 0
			end
		elseif targetInfo[i].effect == EnumFightHurtEffect.effect_8 then
			--触发buffer
			self:CaculateTarget_Buffer(attackRole, targetRole, targetInfo[i], skillID)
			targetInfo[i].hurt	= 0
			targetInfo[i].activeEffect = EnumFightActiveEffectType.effect_100
		else
			local bHurtSkill = false
			if targetInfo[i].effect == 1 or targetInfo[i].effect == 2 then
				bHurtSkill = true
			end
			--触发buffer
			self:CaculateTarget_Buffer(attackRole, targetRole, targetInfo[i], skillID)
			local isBuffTarget 		= false
			if self:IsTreatmentEffect(targetInfo[i].effect) then
				targetInfo[i].hurt	= 0
			else
				targetInfo[i].hurt	= -1
			end
			--真元护体 优先级最高， 所有伤害都要计算此BUFF后面计算
			targetInfo[i].hurt, isBuffTarget = self:CaculateSelfTargetHurtEnd(targetRole, targetInfo[i].hurt)
			local tempBuffEndHurt = targetInfo[i].hurt
			if (not isBuffTarget) then
				targetInfo[i].hurt = self:CaculateHurtNum(attackRole, skillID, targetRole, targetInfo[i].effect,targetNum)
				local fightEffectValue = 0
				if bHurtSkill then
					self:CaculateTarget_coefficient(attackRole, targetRole, targetList, skillID, targetInfo[i])
				end
			end


			if bHurtSkill then
				--总伤害修正
				fightEffectValue = attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain) +
					targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain)
				if skillID.skillId == 0 then

					-- 我发普通攻击修正+敌方被动普通攻击修正
					fightEffectValue = fightEffectValue + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_NormalAttack) +
						targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_NormalAttack)
				else

					-- 我发普通攻击修正+敌方被动普通攻击修正
					fightEffectValue = fightEffectValue + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack) +
						targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack)
				end

				fightEffectValue = fightEffectValue/10000+1
				fightEffectValue = math.max(0,fightEffectValue)
				targetInfo[i].hurt = math.floor(targetInfo[i].hurt*fightEffectValue)

				if skillID.skillId == 0 then
					targetInfo[i].hurt = targetInfo[i].hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_NormalAttack_Num)
					targetInfo[i].hurt = targetInfo[i].hurt - targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_NormalAttack_Num)
				else
					targetInfo[i].hurt = targetInfo[i].hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
					targetInfo[i].hurt = targetInfo[i].hurt - targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
				end
				targetInfo[i].hurt = targetInfo[i].hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
				targetInfo[i].hurt = targetInfo[i].hurt - targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
				targetInfo[i].hurt = math.min(-10, targetInfo[i].hurt)
			end
			local effectValue = {}
			if attackRole:TriggerActiveEffect(skillID, EnumFightSpellEffect.effect_73, effectValue) then
				local currHp 		= targetRole:getCurrHp()
				if (effectValue.value == 100) then
					--必斩杀
					targetInfo[i].activeEffect 	= EnumFightActiveEffectType.effect_73
					targetInfo[i].hurt 			= -math.ceil( currHp + 100)
				elseif (currHp < (targetRole:getMaxHp() * effectValue.value / 100)) then
					targetInfo[i].activeEffect 	= EnumFightActiveEffectType.effect_73
					targetInfo[i].hurt 			= targetInfo[i].hurt - currHp
					if (targetInfo[i].hurt < 0) then
						targetInfo[i].hurt = -math.ceil( -targetInfo[i].hurt )
					end
				end
			elseif attackRole:TriggerActiveEffect(skillID, EnumFightSpellEffect.effect_71, effectValue) then
				local hpPer =  attackRole.maxhp * ( effectValue.value / 100 ) 
				targetInfo[i].hurt 				= math.floor(targetInfo[i].hurt - hpPer)
				if (targetInfo[i].activeEffect ~= EnumFightActiveEffectType.effect_73) then
					targetInfo[i].activeEffect 		= EnumFightActiveEffectType.effect_71
					targetInfo[i].activeEffectValue 	= hpPer
				else
					targetInfo[i].activeEffectValue 	= 0
				end
			elseif attackRole:TriggerActiveEffect(skillID, EnumFightSpellEffect.effect_79, effectValue) then
				targetInfo[i].activeEffect = EnumFightActiveEffectType.effect_79
				targetInfo[i].activeEffectValue = effectValue.value
			elseif attackRole:TriggerActiveEffect(skillID, EnumFightSpellEffect.effect_10) then
				targetInfo[i].activeEffect = EnumFightActiveEffectType.effect_10
			end
			if bHurtSkill and targetRole:GetBuffByType(64) then
				if skillID.skillId > 0 then
					print("q伤害转治疗")
					targetInfo[i].hurt = math.abs(targetInfo[i].hurt)
					bHurtSkill = false
				end
			elseif not bHurtSkill and targetRole:GetBuffByType(81) then
				local buff = targetRole:GetBuffByType(81)
				targetInfo[i].hurt = - math.abs(targetInfo[i].hurt)*tonumber(buff.config.value) / 100
				bHurtSkill = true
			end
			
			effectValue = {}
			if bHurtSkill then
				if math.abs(targetInfo[i].hurt) >= targetRole:getCurrHp() and targetRole:TrigerHurtMianyiSkill(37, effectValue)then
					targetInfo[i].passiveEffect = 37
					effectValue.targetRole._specialSkillTime = effectValue.targetRole._specialSkillTime or 0
					effectValue.targetRole._specialSkillTime = effectValue.targetRole._specialSkillTime + 1
					-- targetRole.haveXianTianGong = targetRole.haveXianTianGong + 1
					targetInfo[i].passiveEffectValue = effectValue.value
					-- targetInfo[i].triggerBufferID = effectValue.buff_id
					-- targetInfo[i].triggerBufferLevel = effectValue.level
				elseif targetRole:TriggerPassiveEffect(9, effectValue) then
					targetInfo[i].passiveEffect = 9
					effectValue.value = math.min(100, effectValue.value)
					targetInfo[i].passiveEffectValue = targetRole.maxhp * effectValue.value / 100
					targetInfo[i].passiveEffectValue = math.floor(targetInfo[i].passiveEffectValue)
				elseif targetRole:TrigerXianTianGongSkill(25, effectValue) and math.abs(targetInfo[i].hurt) >= targetRole:getCurrHp() then
					targetInfo[i].passiveEffect = 25
					-- targetInfo[i].hurt = 0
					targetRole.haveXianTianGong = targetRole.haveXianTianGong + 1
					targetInfo[i].passiveEffectValue = effectValue.value
					targetInfo[i].triggerBufferID = effectValue.value
					targetInfo[i].triggerBufferLevel = effectValue.level
				elseif (math.abs(targetInfo[i].hurt) < targetRole:getCurrHp() and targetInfo[i].activeEffect ~= 26) and targetRole:TriggerPassiveEffect(39, effectValue) then
					targetInfo[i].passiveEffect = 39
					-- effectValue.value = math.min(100, effectValue.value)
					targetInfo[i].passiveEffectValue = targetRole.maxhp * effectValue.value / 100
					targetInfo[i].passiveEffectValue = math.abs(targetInfo[i].hurt) - math.floor(targetInfo[i].passiveEffectValue)
					if targetInfo[i].passiveEffectValue <= 0 then
						targetInfo[i].passiveEffect = 0
						targetInfo[i].passiveEffectValue = 0
					end
				elseif targetRole:TriggerPassiveEffect(27 ,effectValue, attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune,EnumFightEffectType.FightEffectType_NoFanTan)) and targetInfo[i].triggerBufferID ~= 0 then
					-- if (attackRole.logicInfo.roleId ~= 314) then
						local buffInfo = SkillBufferData:objectByID(targetInfo[i].triggerBufferID)
						if buffInfo and buffInfo.good_buff == 0 and buffInfo.no_rebound ~= 3 then
							targetInfo[i].passiveEffect = 27
						end
					-- end
				end
				--
				targetInfo[i].hurt = self:CaculateSelfTargetHurtEnd(targetRole, targetInfo[i].hurt)
				targetRole:TriggerDongXie(targetInfo[i])
			-- else
			-- 	local temp_value = {}
			-- 	if targetRole:TriggerBeHurtUseSkill(3, temp_value) then
			-- 		-- isbackAttack = true
			-- 		targetInfo[i].triggerSkillType = 3 ---被治疗
			-- 		targetInfo[i].triggerSkill = temp_value
			-- 	end
			end
		end
		targetInfo[i].hurt = math.floor(targetInfo[i].hurt)
		print(' help-END--------->  ',targetInfo[i].hurt)
	end
	return targetInfo
end

--插入主动技能 恕气
function FightRoundManager:AddAngerManualAction(fightRole, bManualAdd, bConsume)

	if not fightRole:CanReleaseAngerManualSkill() then
		if (bConsume) then
			fightRole:setConsumptionSkillReleaseState(true, true)
		end
		return false
	end
	local skillInfo ,level = fightRole:getUseSelfAngerSkill()

	local newAction = {}
	newAction.bManualAction      = false
	newAction.bAngerManualAction = true
	newAction.unExecute          = true
	newAction.roundIndex         = math.max(1, self.nCurrRoundIndex)
	newAction.attackerpos        = fightRole.logicInfo.posindex
	newAction.skillid            = {skillId = skillInfo.id,level = level}

	local bInsert = false
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		local actionRole = fightRoleMgr:GetRoleByGirdIndex(actionInfo.attackerpos)
		if actionRole ~= nil and actionRole:IsLive() then
			if self:canInsertInManualAction(fightRole,actionInfo) then
				self.actionList:insertAt(i, newAction)
				bInsert = true
				break
				-- end
			end
		end
	end


	if fightRole.logicInfo.bEnemyRole == false and bManualAdd ~= true then
		if (FightManager.isAutoFight or bConsume) then
			TFDirector:currentScene().fightUiLayer:ReleaseSkillByAI(fightRole,true)
		end
	end

	if not bInsert then
		self.actionList:pushBack(newAction)
	end
	if (not bConsume) then
	    fightRole:addRoleAnger( - skillInfo.trigger_anger )
	end
	return true
end

function FightRoundManager:isYuanHuRoleInTarget(yuanHuRole, targetInfo)
	if (targetInfo) then
		for i,_targetInfo in ipairs(targetInfo) do
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(_targetInfo.targetpos)
			if targetRole == yuanHuRole then
				return true
			end
		end
	end
	return false
end

function FightRoundManager:CaculateTargetYuanHu(yuanHuRole, targetInfo)
	local index = 0
	local curhp = 0
	for i=1,#targetInfo do
		local target = targetInfo[i]
		if (target.effect == 1 or target.effect == 2) and not self:IsActiveEffectBeheaded(target.activeEffect) and 
			target.activeEffect ~= 30 and target.passiveEffect ~= 25 and target.passiveEffect ~= 37 and target.passiveEffect ~= EnumFightSpellEffect.effect_82 then
			-- if (yuanHuRole.logicInfo.posindex == target.targetpos) then
			-- 	return targetInfo
			-- end
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(target.targetpos)
			if targetRole and target.hurt < 0 and yuanHuRole.logicInfo.posindex ~= target.targetpos then
				if targetRole:IsLive() then
					if curhp == 0 or curhp > targetRole.currHp then
						curhp = targetRole.currHp
						index = i
					end
				end
			end
		end
	end
	
	if index ~= 0 or curhp ~= 0 then
		local buff = yuanHuRole:GetBuffByType(61)
		local configValue = 0
		if (buff) then
			configValue = tonumber(buff.config.value)
		else
			local skillInfo = yuanHuRole:GetTriggerBySkillHurtType(yuanHuRole.skillID, EnumFightTriggerHurtType.type_18)
			if (skillInfo) then
				local skillInfo_1 	= SkillLevelData:objectByID({skillId = skillInfo.triggerSkill, level = skillInfo.level})
				if (skillInfo_1 and skillInfo_1.effect_value) then
					--援护技能这里表配的是百分比 需要转成万分比
					configValue = skillInfo_1.effect_value * 100
				end
			end
		end
		if (configValue <= 0) then
			return targetInfo
		end
		local totalHurt = targetInfo[index].hurt
		targetInfo[index].hurt = math.floor(totalHurt *(10000 - configValue)/10000)
		-- _length = #targetInfo+1
		local _targetInfo = {}
		-- targetInfo[_length] = {}

		_targetInfo.targetpos 	= yuanHuRole.logicInfo.posindex
		_targetInfo.effect 		= EnumFightHurtEffect.effect_9
		_targetInfo.hurt 		= 0	
		_targetInfo.activeEffect 		= targetInfo[index].targetpos
		if (buff == nil) then
			--香香公主 援护
			_targetInfo.activeEffectValue 	= EnumFightActiveEffectType.effect_68
		else
			_targetInfo.hurt 		= math.floor(totalHurt * configValue/10000)
		end
		local effectValue = {}
		if yuanHuRole:TriggerPassiveEffect(7, effectValue) then
			_targetInfo.passiveEffect = 7
			effectValue.value = math.min(100, effectValue.value)
			_targetInfo.hurt = _targetInfo.hurt * (100 - effectValue.value) / 100
			_targetInfo.hurt = math.floor(_targetInfo.hurt)
		end
		--
		if(EnumFight_BackBloodEffect[targetInfo[index].passiveEffect]) then			
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo[index].targetpos)
			if (targetRole) then
				-- --被援护后 受到伤害回血被动需要重新计算
				local passiveEffectList = {targetInfo[index].passiveEffect}
				targetInfo[index].passiveEffect 		= 0
				targetInfo[index].passiveEffectValue	= 0
				self:CaculateTarget_PassiveEffect(nil,targetRole, targetInfo[index], passiveEffectList)
			end
		end
		if (targetInfo[index].activeEffect == EnumFightActiveEffectType.effect_29) then
			local newHurt = math.floor(targetInfo[index].hurt * targetInfo[index].activeEffectValue / 100)
			for i,__targetInfo in ipairs(targetInfo) do
				if (__targetInfo.activeEffect == EnumFightActiveEffectType.effect_30 and __targetInfo.activeEffectValue == targetInfo[index].targetpos) then
					__targetInfo.hurt = newHurt
				end
			end
		end
		_targetInfo.hurt = self:CaculateSelfTargetHurtEnd(yuanHuRole, _targetInfo.hurt)
		targetInfo[#targetInfo + 1] = _targetInfo
		-- table.insert(targetInfo,1,_targetInfo)
	end
	return targetInfo
end


function FightRoundManager:IsHaveHurtAddHpRole(beAttackRole)
	if FightManager.isReplayFight then
		return nil 
	end
	local addHpRoleList = TFArray:new()
	local roleList = fightRoleMgr:GetAllLiveRole(beAttackRole.logicInfo.bEnemyRole, false, false)
	for role in roleList:iterator() do
		local hasSkill ,skillInfo = role:HasTriggerSkillByType(EnumFightTriggerHurtType.type_4)
		if hasSkill then
			if role:HaveForbidAttackBuff() == false then
				addHpRoleList:pushBack({role = role  ,skillInfo = skillInfo})
				-- return role  ,skillInfo
			end
		end
	end
	return addHpRoleList
end


function FightRoundManager:IsHaveSaveOtherSkillRole(beAttackRole)
	if FightManager.isReplayFight then
		return nil 
	end
	-- local saveRole = nil
	local roleList = fightRoleMgr:GetAllLiveRole(beAttackRole.logicInfo.bEnemyRole,false,false)
	for role in roleList:iterator() do
		if rol ~= beAttackRole then
			local hasSkill = role:HasTriggerSkillBySkillType(10)
			if hasSkill then
				if role:HaveForbidAttackBuff() == false then
					return role
					-- return role  ,skillInfo
				end
			end
		end
	end
	return nil
end

function FightRoundManager:setHurtAddSkill( attackRole ,skillid, targetList )
	if FightManager.isReplayFight then
		return
	end
	if attackRole:IsLive() == false then
		return
	end
	if attackRole:IsCanYuaHuBuff() == false then
		return
	end

	if skillid == nil then
		return
	end
	if #targetList <= 0 then
		return
	end

	local hurtAddBloodAction = {}
	hurtAddBloodAction.bManualAction      = false
	hurtAddBloodAction.bAngerManualAction = false
	hurtAddBloodAction.unExecute          = true
	hurtAddBloodAction.roundIndex         = self.nCurrRoundIndex
	hurtAddBloodAction.attackerpos        = attackRole.logicInfo.posindex
	hurtAddBloodAction.skillid            = skillid--{skillId = 0 , level = 0}
	hurtAddBloodAction.bBackAttack        = false
	hurtAddBloodAction.triggerType        = 4
	hurtAddBloodAction.targetlist = self:CaculateTargetHurt(attackRole, skillid, targetList)
	attackRole.specialSkillTime = attackRole.specialSkillTime or 0
	attackRole.specialSkillTime = attackRole.specialSkillTime + #hurtAddBloodAction.targetlist
	self.hurtAddBloodActionList:pushBack(hurtAddBloodAction)
end

function FightRoundManager:HaveHurtAddBloodAction()
	if self.hurtAddBloodActionList == nil then
		return false
	end
	return self.hurtAddBloodActionList:length() ~= 0

	-- return self.hurtAddBloodAction ~= nil
end

function FightRoundManager:ExecuteHurtAddBloodAction(endActionInfo)
	if self.hurtAddBloodActionList == nil or self.hurtAddBloodActionList:length() <= 0 then
		return false
	end
	
	local newAction = self.hurtAddBloodActionList:pop()
	-- local newAction = clone(self.hurtAddBloodAction)

	newAction.unExecute = false
	-- self.hurtAddBloodAction = nil


	local bInsert = false
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		if actionInfo and actionInfo.unExecute then --actionInfo == endActionInfo then
			-- print("self.actionList:insertAt--->>>pos = "..(i).."roundIndex = "..newAction.roundIndex.."attackerpos = "..newAction.attackerpos)
			self.actionList:insertAt(i, newAction)
			bInsert = true
			break
		end
	end

	if not bInsert then
		-- print("self.actionList:pushBack---ExecuteSkillTrigerAttackAction-->>>pos = "..(self.actionList:length()+1).."roundIndex = "..newAction.roundIndex.."attackerpos = "..newAction.attackerpos)
		self.actionList:pushBack(newAction)
	end
	local attackRole = fightRoleMgr:GetRoleByGirdIndex(newAction.attackerpos)

	--f回血验证是否存活
	local len = #newAction.targetlist
	for i = len, 1, -1 do
		local targetInfo = newAction.targetlist[i]
		local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
		if (targetRole == nil or not targetRole:IsLive()) then
			table.remove( newAction.targetlist, i)
		end
	end
	if (#newAction.targetlist <= 0) then
		return false
	end
	-- local specialTime = attackRole.specialSkillTime or 0
	
	-- attackRole.specialSkillTime = attackRole.specialSkillTime or 0
	-- attackRole.specialSkillTime = attackRole.specialSkillTime + #newAction.targetlist
	-- print("newAction = ",newAction)
	self:ExecuteAction(newAction)
	return true
end



function FightRoundManager:GetNearIndex(posIndex)
	local nearList = {}
	local nearAdd = {1,-1,3,-3}
	for i=1,4 do
		local pos_index = posIndex + nearAdd[i]
		if math.floor(pos_index/3) == math.floor(posIndex/3) or pos_index%3 == posIndex%3 then
			if pos_index >= 0 and pos_index < 18 and math.floor(pos_index/9) == math.floor(posIndex/9) then
				nearList[#nearList + 1] = pos_index
			end
		end
	end
	return nearList
end



function FightRoundManager:setBackAddAttackAction(attackRole , targetRole)
	if FightManager.isReplayFight then
		return
	end
	if not attackRole or not attackRole:IsLive()  then
		print("attackRole or attackRole:IsLive() == nil")
		return
	end
	self.backAddAttackList = self.backAddAttackList or TFArray:new()
	self.backAddAttackList:clear()
	self:_setBackAddAttackAction(attackRole,targetRole)
end
function FightRoundManager:_setBackAddAttackAction(attackRole , targetRole)
	print("_setBackAddAttackAction ==>")
	if attackRole:IsLive() == false or (targetRole:GetSummoned() ~= 0) then
		return
	end
	local buffTypeList = attackRole:GetBuffListByType(EnumFightEnemyEndAttackBuff)
	local buff = nil
	for i,buffId in ipairs(EnumFightEnemyEndAttackBuff) do
		buff = buffTypeList[buffId]
		if (buff) then
			break
		end
	end
	if (buff == nil) then
		return
	end
	local skillid ={skillId =  tonumber(buff.config.value) , level = buff.config.level}

	local helpAttackInfo = {}
	helpAttackInfo.skillid = skillid
	helpAttackInfo.attackRole = attackRole
	--香意 根据技能找目标
	local buff_504 = buffTypeList[EnumFightBufferType.type_504]
	if buff_504 then	
		--local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		local skillInfo = SkillLevelData:objectByID(skillid)
		helpAttackInfo.targetList = self:getTargetListBySkillInfo(skillInfo.target_type, skillInfo.target_num, attackRole)
	else
		helpAttackInfo.targetList 	= {targetRole}
	end
	helpAttackInfo.helpBuffTypeId = buff.config.type
 	self.backAddAttackList:pushBack(helpAttackInfo)
	
end
function FightRoundManager:hasLingHunLianJie(targetlist)
	if FightManager.isReplayFight then
		return nil
	end
	local targetNum = #targetlist
	for i=1,targetNum do
		if targetlist[i].effect == 1 or targetlist[i].effect == 2 then
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetlist[i].targetpos)
			if targetRole and targetRole:GetBuffByType(69)  and targetlist[i].hurt < 0 and math.abs(targetlist[i].hurt) < targetRole:getCurrHp() then
				print("targetlist[i] hasLingHunLianJie-->>",targetlist[i])
				if not targetlist[i].activeEffect or targetlist[i].activeEffect ~= 30 then
					return targetlist[i]
				end
			end
		end
	end
end

function FightRoundManager:setLingHunLianJie(targetInfo,targetlist)
	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	if targetRole == nil then
		print("setLingHunLianJie--------->>nilnilnil")
		return
	end
	local liveList = fightRoleMgr:GetAllLiveRole(not targetRole.logicInfo.bEnemyRole,false,false)
	local liveNum = liveList:length()
	-- local _buff = targetRole:GetBuffByType(69)
	for i=1,liveNum do
		local _targetRole = liveList:objectAt(i)
		local buff = _targetRole:GetBuffByType(70)
		if _targetRole and _targetRole:IsLive() and buff then
			local targetNum = #targetlist

			local _targetRoleInfo              	= {}
			_targetRoleInfo.targetpos          	= _targetRole.logicInfo.posindex
			_targetRoleInfo.hurt               	= math.floor(targetInfo.hurt * tonumber(buff.config.value) /100)
			_targetRoleInfo.effect             	= EnumFightHurtEffect.effect_10
			_targetRoleInfo.triggerBufferID    	= 0
			_targetRoleInfo.triggerBufferLevel 	= 0
			_targetRoleInfo.activeEffect 		= targetInfo.targetpos
			--龙哥之前不受护盾影响，现在又说受了
			local isBuffTarget = false
			_targetRoleInfo.hurt, isBuffTarget = self:CaculateSelfTargetHurtEnd(_targetRole, _targetRoleInfo.hurt)
			--
			local _effectValue = {}
			if _targetRole:TriggerPassiveEffect(9, _effectValue) then
				_targetRoleInfo.passiveEffect = 9
				_effectValue.value = math.min(100, _effectValue.value)
				_targetRoleInfo.passiveEffectValue = _targetRole.maxhp * _effectValue.value / 100
				_targetRoleInfo.passiveEffectValue = math.floor(_targetRoleInfo.passiveEffectValue)
			-- elseif _targetRole:TrigerXianTianGongSkill(25, _effectValue) and (math.abs(_targetRoleInfo.hurt) >= _targetRole:getCurrHp() or _targetRoleInfo.activeEffect == 26)then
			-- 	_targetRoleInfo.passiveEffect = 25
			-- 	-- _targetRoleInfo.hurt = 0
			-- 	_targetRole.haveXianTianGong = _targetRole.haveXianTianGong + 1
			-- 	_targetRoleInfo.passiveEffectValue = _effectValue.value
			-- 	_targetRoleInfo.triggerBufferID = _effectValue.value
			-- 	_targetRoleInfo.triggerBufferLevel = _effectValue.level
			end
			--
			targetRole:TriggerDongXie(_targetRoleInfo)
			targetlist[targetNum+1] = _targetRoleInfo
			return
		end
	end
	return false
end

--恐惧
function FightRoundManager:setFearBuff(attackRole, targetlist)
	local targetNum 	= #targetlist
	local buff2 		= attackRole:GetBuffByType(EnumFightBufferType.type_92) --东方不败 恐惧
	if (buff2) then
		local liveList 		= fightRoleMgr:GetAllLiveRole(not attackRole.logicInfo.bEnemyRole)
		for k = 1, targetNum do
			local targetInfo 		= targetlist[k]
			local targetRole 		= nil
			if (targetInfo and targetInfo.hurt < 0 and (targetInfo.effect == EnumFightHurtEffect.effect_1 or targetInfo.effect == EnumFightHurtEffect.effect_2) and 
			targetInfo.activeEffect ~= EnumFightActiveEffectType.effect_83) then
				targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
			end
			if (targetRole) then
				print(targetRole.logicInfo.posindex, "   技能击中",targetRole.logicInfo.name, "->伤害: ",targetInfo.hurt)
				
				-- local liveNum 		= liveList:length()
				-- for i = 1,liveNum do
				-- 	local _targetRole 	= liveList:objectAt(i)
				for _targetRole in liveList:iterator() do
					if (_targetRole and _targetRole:IsLive()) then
						local buff1 = _targetRole:GetBuffByType(EnumFightBufferType.type_93) --东方不败 恐惧
						if (buff1 and (targetRole.logicInfo.bEnemyRole == _targetRole.logicInfo.bEnemyRole)) then
							local isHurt 	= true
							local hurtSum 	= 0
							--
							for _,target in pairs(targetlist) do
								if (target.targetpos == _targetRole.logicInfo.posindex) then
									hurtSum = hurtSum + target.hurt
								end
							end
							--
							if (hurtSum < 0 and (math.abs( hurtSum ) >= _targetRole:getCurrHp())) then
								isHurt = false
							end
							if (isHurt) then
								local targetLen 					= #targetlist
								local _targetRoleInfo 				= {}
								_targetRoleInfo.targetpos 			= _targetRole.logicInfo.posindex
								_targetRoleInfo.hurt 				= math.floor(targetInfo.hurt * tonumber(buff1.config.value) / 100)
								_targetRoleInfo.effect 				= EnumFightHurtEffect.effect_10
								_targetRoleInfo.triggerBufferID 	= 0
								_targetRoleInfo.triggerBufferLevel 	= 0
								_targetRoleInfo.activeEffect 		= attackRole.logicInfo.posindex
								_targetRoleInfo.tagBuffId 			= EnumFightBufferType.type_93
								_targetRoleInfo.activeEffectValue 	= EnumFightBufferType.type_93
								--龙哥之前不受护盾影响，现在又说受了
								local isBuffTarget = false
								_targetRoleInfo.hurt, isBuffTarget = self:CaculateSelfTargetHurtEnd(_targetRole, _targetRoleInfo.hurt)
								--
								print(_targetRole.logicInfo.posindex, "       --->恐惧BUFF额外伤害",_targetRole.logicInfo.name, " -> ",_targetRoleInfo.hurt)
								if (not isBuffTarget) then
									fightRoleMgr:ChangeEffectHurt(_targetRole, _targetRoleInfo)
								end
								local passiveEffectList = {EnumFightPassiveEffectType.effect_9, EnumFightPassiveEffectType.effect_72}
								self:CaculateTarget_PassiveEffect(attackRole, _targetRole, _targetRoleInfo, passiveEffectList, {}, nil, #targetlist, targetlist)
								targetlist[#targetlist+1] = _targetRoleInfo
							end
						end
					end
				end
			end
		end
	end
	return false
end

function FightRoundManager:getBreakSkillRole(attackRole)

	if FightManager.isReplayFight then
		return nil
	end
	if FightManager.fightBeginInfo.fighttype == EnumFightType.Boss then
		return nil
	end
	if FightManager.fightBeginInfo.fighttype == EnumFightType.Wuling then
		return nil
	end
	if attackRole:GetBuffByType(EnumFightBufferType.type_10) then
		return nil
	end
	-- if not attackRole:HaveForbidManualSkillBuff() then
	-- 	return nil
	-- end

	local roleList = fightRoleMgr:GetAllLiveRole(not attackRole.logicInfo.bEnemyRole,false,false)
	for role in roleList:iterator() do
		
		if (not role:HaveForbidManualSkillBuff()) then
			local buffTypeList = role:GetBuffListByType({EnumFightBufferType.type_71, EnumFightBufferType.type_503})
			local buff = buffTypeList[EnumFightBufferType.type_71]
			if (buff == nil) then
				buff = buffTypeList[EnumFightBufferType.type_503]
			end
			if buff then
				local skill = {skillId = 0 , level = 0}
				if buff.config.value and buff.config.value ~= "" and tonumber(buff.config.value) ~= 0 then
					skill = {skillId = tonumber(buff.config.value) , level = buff.config.level}
				end
				return role ,skill
			end
		end
	end
	return nil
end

--治疗型
function FightRoundManager:IsTreatmentEffect(effect)
	if effect == 4 or effect == 11 or effect == EnumFightHurtEffect.effect_16 then
		return true
	end
	return false
end


function FightRoundManager:GetBreakSkillActionTargetInfo(attackRole, skillID ,targetRole)
	local targetList = {targetRole}
	

	local haveHelpRoleList = self:IsHaveHelpAttack(attackRole)
	if haveHelpRoleList:length() > 0 then
		self:setHelpAttackAction(haveHelpRoleList , targetList)
	end
	-- local backAddRole = self:IsHaveEndAddAttackBuffRole(not attackRole.logicInfo.bEnemyRole)
	-- if backAddRole then
	-- 	self:setBackAddAttackAction(backAddRole ,attackRole )
	-- end
	local backAddRoleList = self:IsHaveEndAddSkillAttackBuffRole(attackRole, skillID)
	for i,roleInfo in ipairs(backAddRoleList) do
		self:setBackAddAttackAction(roleInfo ,attackRole, i == 1 )
	end

	local targetInfo = self:CaculateTargetHurt(attackRole, skillID, targetList)

	local yuanHuRole = self:IsHaveYuanHuBuffRole(attackRole, targetInfo)
	if yuanHuRole then -- and not self:isYuanHuRoleInTarget(yuanHuRole , targetInfo) then
		targetInfo = self:CaculateTargetYuanHu(yuanHuRole, targetInfo)
	end
	local lingHunLianJieRole = self:hasLingHunLianJie(targetInfo)
	if lingHunLianJieRole then
		self:setLingHunLianJie(lingHunLianJieRole,targetInfo)
	end
	return targetInfo --self:CaculateTargetHurt(attackRole, skillID, targetList,extra_targetList)

end


function FightRoundManager:GetFuhuoActionTargetInfo(attackRole, skillID,saveRole)
	local targetList = {}
	-- local skillInfo = SkillLevelData:objectByID(skillID)
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
	if skillBaseInfo == nil then
		print("skill not find：" ,skillID)
	end
	targetList[1] = saveRole

	if #targetList > 0 then
		local targetInfo = {}
		 targetInfo = self:CaculateFuhuoTargetHurt(attackRole, skillID, targetList)
		return targetInfo
	end
end


function FightRoundManager:CaculateFuhuoTargetHurt(attackRole, skillID, targetList)
	local targetInfo = {}
	local targetNum = #targetList
	local bHaveTrigger = false
	if type(skillID) == "number" then
		skillID = { skillId = skillID,level = 0}
	end
	for i=1,targetNum do
		targetInfo[i] = {}
		local targetRole = targetList[i]
		targetInfo[i].targetpos = targetRole.logicInfo.posindex
		targetInfo[i].effect = 11
		targetInfo[i].hurt = 0
		--触发buffer
		self:CaculateTarget_Buffer(attackRole, targetRole, targetInfo[i], skillID)
		--
		local effectValue = {}
		local temp_activeEffect = attackRole:TriggerBuffHurt(targetRole, skillID, effectValue)
		--加深效果跟activeEffect不冲突
		if temp_activeEffect and temp_activeEffect ~= 0 then
			-- targetInfo[i].activeEffect = temp_activeEffect + 100
			targetInfo[i].deepHurtType = temp_activeEffect
			targetInfo[i].hurt = targetInfo[i].hurt * (100+effectValue.value) / 100
			targetInfo[i].hurt = math.floor(targetInfo[i].hurt)
			print("加深效果触发:",effectValue,targetInfo)
		end
		--是否触发主动效果:吸怒1 减敌怒2 增己怒3 吸血4 侧击8 净化10 致死11 重击14 七伤拳21
		if attackRole:TriggerActiveEffect(skillID, 15, effectValue) then
			-- targetInfo[i].activeEffect = 15
			-- targetInfo[i].activeEffectValue = effectValue.value
			targetInfo[i].hurt = math.floor(targetInfo[i].hurt +  effectValue.value*(targetRole.maxhp)/100)
		elseif attackRole:TriggerActiveEffect(skillID, EnumFightActiveEffectType.effect_62, effectValue) then
			local neiliAttr 	= attackRole:GetAttrNum(EnumAttributeType.Magic)
			if (neiliAttr <= 0) then
				neiliAttr = 1
			end
			targetInfo[i].hurt 	= math.floor(effectValue.value*(neiliAttr)/100)
			--恢复金蛇公子内力百分比的血量。同时自身会承受其所受到的那一次致命伤害。（同时复活两个人的话，会同时承受两个人的致命伤害）
			local roleLastHurtNum 			= targetRole.lastHurtHp
			if (roleLastHurtNum < 0) then
				local _targetRoleInfo              	= {}
				_targetRoleInfo.targetpos          	= attackRole.logicInfo.posindex
				_targetRoleInfo.effect             	= EnumFightHurtEffect.effect_15
				_targetRoleInfo.activeEffect 		= EnumFightActiveEffectType.effect_63
				_targetRoleInfo.activeEffectValue 	= 0
				_targetRoleInfo.hurt               	= self:CaculateSelfTargetHurtEnd(attackRole, roleLastHurtNum)
				
				targetInfo[#targetInfo+1] = _targetRoleInfo
			end
		end
	end
	return targetInfo
end

function FightRoundManager:ExecuteBeHurtNumTriggerSkillAction(attackRole,skillid,triggerSkillType)
	if FightManager.isReplayFight then
		return false
	end

	if attackRole == nil or not attackRole:IsLive(true) then
		return false
	end

	if attackRole:IsLive(true) == false then
		return false
	end

	if skillid == nil then
		return false
	end
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillid)
	if skillBaseInfo == nil then
		return false
	end

	local newAction = {}
	newAction.bManualAction = false
	newAction.bAngerManualAction = false
	newAction.unExecute = true
	newAction.roundIndex = self.nCurrRoundIndex
	newAction.attackerpos = attackRole.logicInfo.posindex
	newAction.skillid = {skillId = skillBaseInfo.triggerSkill , level = skillid.level}
	newAction.bBackAttack = false
	newAction.triggerType = triggerSkillType or 0

	newAction.targetlist = self:GetActionTargetInfo(attackRole, newAction.skillid,false)
	if newAction.targetlist == nil or #newAction.targetlist == 0 then
		return false
	end

	attackRole.beHurtNum = 0

	local bInsert = false
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		if actionInfo and actionInfo.unExecute then --actionInfo == endActionInfo then
			self.actionList:insertAt(i, newAction)
			bInsert = true
			break
		end
	end

	if not bInsert then
		self.actionList:pushBack(newAction)
	end
	self:ExecuteAction(newAction)
	return true
end

function FightRoundManager:SetBeHurtNumTriggerSkillAction()
	if FightManager.isReplayFight then
		return false
	end
	local roleList = fightRoleMgr:getAllCanUserSkillRole(true)
	if roleList:length() > 0 then
		for role in roleList:iterator() do
			local effectValue = {}
			if role and role:HaveTriggerType6AttackBuff() == false and role:TriggerBeHitPassiveEffect(EnumFightSpellEffect.effect_57, effectValue) then
				if self:ExecuteBeHurtNumTriggerSkillAction(role, effectValue.skillId,0) then
					return true
				end
			end
		end
	end
	return false
end

function FightRoundManager:setTeamAttackSkill()
-- 	self.attackerRole:OnHelpAttackBuffTrigger()
	if FightManager.isReplayFight then
		return false
	end
	local roleList = fightRoleMgr:getAllCanUserSkillRole(true)
	if roleList:length() > 0 then
		for role in roleList:iterator() do
			local effectValue = {}
			if role and role:HaveForbidManualSkillBuff() == false and role:TriggerTeamAttackSkill(effectValue) then
				if self:SetTeamAttackTrgerSkillAction(role, effectValue, 10) then
					return true
				end
			end
		end
	end
	for i=1,2 do
		local pet = fightRoleMgr:GetPetByIndex(i)
		local effectValue = {}
		if pet and pet:TriggerTeamAttackSkill(effectValue) then
			if self:SetTeamAttackTrgerSkillAction(pet, effectValue,10) then
				return true
			end
		end
	end
	return false
end


--反击action
function FightRoundManager:SetTeamAttackTrgerSkillAction(attackRole, skillid,triggerSkillType)
	if FightManager.isReplayFight then
		return false
	end
	if attackRole:IsLive(true) == false then
		return false
	end

	if skillid == nil then
		return false
	end
	local teamAttackAction              = {}
	teamAttackAction.bManualAction      = false
	teamAttackAction.bAngerManualAction = false
	teamAttackAction.unExecute          = true
	teamAttackAction.roundIndex         = self.nCurrRoundIndex
	teamAttackAction.attackerpos        = attackRole.logicInfo.posindex
	teamAttackAction.skillid            = skillid--{skillId = 0 , level = 0}
	teamAttackAction.bBackAttack        = false
	teamAttackAction.triggerType 		= triggerSkillType or 0

	teamAttackAction.targetlist = self:GetPetActionTargetInfo(attackRole, teamAttackAction.skillid,true)
	if teamAttackAction.targetlist == nil or #teamAttackAction.targetlist == 0 then
		local targetEnemy = not attackRole.logicInfo.bEnemyRole
		if fightRoleMgr:CleanFrozenBuffRole(targetEnemy) then
			teamAttackAction.targetlist = self:GetPetActionTargetInfo(attackRole, teamAttackAction.skillid,true)
		end

		if teamAttackAction.targetlist == nil or #teamAttackAction.targetlist == 0 then
			-- self:OnActionEnd()
			teamAttackAction  = nil
			return false
		end
	end

	local bInsert = false
	local actionNum = self.actionList:length()
	for i=1,actionNum do
		local actionInfo = self.actionList:objectAt(i)
		if actionInfo and actionInfo.unExecute then --actionInfo == endActionInfo then
			self.actionList:insertAt(i, teamAttackAction)
			bInsert = true
			break
		end
	end

	if not bInsert then
		self.actionList:pushBack(teamAttackAction)
	end
	-- print("teamAttackAction = ",teamAttackAction)
	self:ExecuteAction(teamAttackAction)

	return true
end



function FightRoundManager:GetPetActionTargetInfo(attackRole, skillID,isbackAttack)
	if isbackAttack == nil then
		isbackAttack = false
	end
	local targetList = {}
	local extra_targetList = {}

	if skillID.skillId == 0 then --普通技能打单体	
		targetList = fightRoleMgr:GetSingleTarget(attackRole)
	else
		local skillInfo = SkillLevelData:objectByID(skillID)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo == nil or skillBaseInfo == nil then
			print("skill not find：" ,skillID)
			return
		end

		local targetType = skillBaseInfo.target_type
		local targetNum = skillInfo.target_num
		if targetNum == nil or targetNum == 0 then
			targetNum = 1
		end
		if skillInfo == nil then
			targetType = 1
		end
		targetList = self:getTargetListBySkillInfo(targetType, targetNum, attackRole )

		if skillInfo and skillBaseInfo.extra_buffid > 0 then
			extra_targetList = self:getTargetListBySkillInfo( skillBaseInfo.extra_targe_type ,skillInfo.extra_buff_targetnum ,attackRole)
		end
	end
	if not targetList then
		return nil
	end
	if #targetList > 0 then
		targetInfo = self:CaculateTargetHelpAttackHurt(attackRole, skillID, targetList,extra_targetList)
		return targetInfo
	end
end

--计算目标伤害最后处理的东东
function FightRoundManager:CaculateTargetHurtEnd(attackRole, targetRole, targetInfo, skillID)
	local isBuffTarget = false
	targetInfo.hurt = self:CaculateSelfAttackHurtEnd(attackRole, targetInfo.hurt, skillID, targetInfo, targetRole)
	targetInfo.hurt, isBuffTarget = self:CaculateSelfTargetHurtEnd(targetRole, targetInfo.hurt)

	--超过XX血量上限就回血 用最终伤害重新计算
	if (EnumFight_BackBloodEffect[targetInfo.passiveEffect]) then
		targetInfo.passiveEffect = 0
		targetInfo.passiveEffectValue = 0
	end
	local tempEffectList = {EnumFightSpellEffect.effect_82, EnumFightSpellEffect.effect_37}
	for effect,v in pairs(EnumFight_BackBloodEffect) do
		table.insert( tempEffectList, effect )
	end 
	-- if (not isBuffTarget) then
	-- 	--被真元护体后伤害不足以超出生命上限x%
	-- 	fightRoleMgr:ChangeEffectHurt(targetRole, targetInfo)
	-- end
	if (#tempEffectList > 0) then
		self:CaculateTarget_PassiveEffect(attackRole, targetRole, targetInfo, tempEffectList)
	end
	--
end

--目标自身状态影响最终伤害值 此方法做通用方法使用，只处理伤害，不添加额外逻辑
function FightRoundManager:CaculateSelfTargetHurtEnd(targetRole, hurt)
	local baseHurt = hurt
	local isBuffTarget = false
	--牛逼BUFF真元护体 伤害强制为-1
	if (hurt < 0) then
		local buffTypeList = targetRole:GetBuffListByType({EnumFightBufferType.type_98, EnumFightBufferType.type_99, EnumFightBufferType.type_514})
		if (buffTypeList[EnumFightBufferType.type_98] or buffTypeList[EnumFightBufferType.type_514]) then
			print('牛逼牛逼【无敌】BUFF 生效了  ')
			hurt = -1
			isBuffTarget = true
		elseif (buffTypeList[EnumFightBufferType.type_99]) then
			--2019-8-7 15:43:8脏兮兮要求修改这样子 我不知道，也不敢问
			local addHrut = buffTypeList[EnumFightBufferType.type_99].config.be_effect_extra[EnumFightEffectType.FightEffectType_HurtGain] or 0
			if (math.abs(addHrut) >= 10000) then
				hurt = -1
			else
				hurt = hurt + math.floor(hurt * addHrut / 10000)
			end
		end
	end

	return hurt, isBuffTarget
end


--攻击方自身状态影响最终伤害值
function FightRoundManager:CaculateSelfAttackHurtEnd(attackRole, hurt, skillID, targetInfo, targetRole)
	--风恕下
	local baseHurt = hurt
	local _skillInfo = attackRole:getBuffSkill(nil, skillID)
	if (_skillInfo) then
		hurt = hurt + math.floor(hurt * _skillInfo.effect_value / 10000)
	else
		if (targetInfo) then
			targetInfo.hurt = hurt
			local _activityEffectList = {EnumFightSpellEffect.effect_70}
			self:CaculateTarget_ActiveEffect(_activityEffectList, attackRole, targetRole, targetInfo, skillID)
			hurt = targetInfo.hurt
		end
	end
	
	return hurt
end

--计算触发技能相关
function FightRoundManager:CaculateTriggerSkill(attackRole, targetRole, targetInfo, skillID, bHaveAttackTrigger, isbackAttack)
	local skillTypeList = {
		EnumFightSkillType.type_7
	}
	local triggerHurtTypeList = {
		EnumFightTriggerHurtType.type_16
	}
	local triggerEffectList = {}
	local addTriggerSkill 	= {}
	local addEffectValue 	= {}

	targetRole:TriggerSkill(skillTypeList, triggerHurtTypeList, addTriggerSkill, triggerEffectList, addEffectValue)
	--
	if (addTriggerSkill and addTriggerSkill[1]) then
		local activeTrigger = addTriggerSkill[1]
		targetInfo.triggerSkillType 	= activeTrigger.triggerSkillType
		targetInfo.triggerSkill 		= {skillId = activeTrigger.skillId, level = activeTrigger.level}
	end
	--
	-----------------------
	local __temp_value2 = {}
	if attackRole:TriggerActiveAddSkillEffect(skillID, EnumFightTriggerHurtType.type_14, __temp_value2) then --触发主动效果：追加一次主动
		targetInfo.activeTriggerSkillType 	= EnumFightTriggerHurtType.type_14
		targetInfo.activeTriggerSkill 		= __temp_value2
	elseif not bHaveAttackTrigger and attackRole:TriggerActiveAddSkillEffect(skillID, EnumFightTriggerHurtType.type_19, __temp_value2) then --触发主动效果：追加一次主动
		targetInfo.activeTriggerSkillType 	= EnumFightTriggerHurtType.type_19
		targetInfo.activeTriggerSkill 		= __temp_value2
		bHaveAttackTrigger = true
	elseif not fightRoleMgr:IsSameSide({attackRole, targetRole}) then
		local __temp_value = {}
		if not bHaveAttackTrigger and targetInfo.effect == 2 and attackRole:TriggerBeHurtUseSkill(9, __temp_value) and isbackAttack == false then
			if triggerType == nil or triggerType ~= 9 then
				targetInfo.activeTriggerSkillType 	= 9 ---攻击暴击
				targetInfo.activeTriggerSkill 		= __temp_value
				bHaveAttackTrigger = true
			end
		end
	end
	return bHaveAttackTrigger
end

--是否斩杀
function FightRoundManager:IsActiveEffectBeheaded(activeEffect)
	if (activeEffect == nil) then
		return false
	end
	local effectList = {EnumFightSpellEffect.effect_26, EnumFightSpellEffect.effect_73}
	for i, effect in ipairs(effectList) do
		if (activeEffect == effect) then
			return true
		end
	end
	return false
end
-----乾坤挪移
function FightRoundManager:CaculateTarget_QianKunNuoYi(attackRole, targetRole, _targetInfo, skillID, targetNum)
	-- isbackAttack = true
	local targetInfo = {}
	local i = 1
	targetInfo[i] = _targetInfo
	---
	targetInfo[i].hurt = self:CaculateHurtNum(attackRole, skillID, targetRole, targetInfo[i].effect, targetNum)
	--总伤害修正
	local fightEffectValue = attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain) +
		targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain, attackRole)
	if skillID.skillId == 0 then
		-- 我发普通攻击修正+敌方被动普通攻击修正
		fightEffectValue = fightEffectValue + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_NormalAttack) +
			targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_NormalAttack)
	else
		-- 我发普通攻击修正+敌方被动普通攻击修正
		fightEffectValue = fightEffectValue + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack) +
			targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack)
	end
	fightEffectValue = fightEffectValue/10000+1
	fightEffectValue = math.max(0,fightEffectValue)

	targetInfo[i].hurt = math.floor(targetInfo[i].hurt*fightEffectValue)
	if skillID.skillId == 0 then
		targetInfo[i].hurt = targetInfo[i].hurt + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_NormalAttack_Num)
		targetInfo[i].hurt = targetInfo[i].hurt + targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_NormalAttack_Num)
	else
		targetInfo[i].hurt = targetInfo[i].hurt + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
		targetInfo[i].hurt = targetInfo[i].hurt + targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
	end
	targetInfo[i].hurt = targetInfo[i].hurt + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
	targetInfo[i].hurt = targetInfo[i].hurt + targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
	targetInfo[i].hurt = math.max(0, targetInfo[i].hurt)
	if FightManager.fightBeginInfo then
		if FightManager.fightBeginInfo.fighttype == EnumFightType.type_5 then
			local power_suppress = ClimbManager:getAtkSuppress( targetRole.logicInfo.bEnemyRole,attackRole.logicInfo.bEnemyRole  )
			targetInfo[i].hurt = math.floor(targetInfo[i].hurt * power_suppress)
		elseif FightManager.fightBeginInfo.fighttype == 16 then
			local power_suppress = NorthClimbManager:getAtkSuppress( targetRole.logicInfo.bEnemyRole,attackRole.logicInfo.bEnemyRole  )
			targetInfo[i].hurt = math.floor(targetInfo[i].hurt * power_suppress)
		elseif FightManager.fightBeginInfo.fighttype == 17 then
			local power_suppress = FactionManager:getAtkSuppress( targetRole.logicInfo.bEnemyRole,attackRole.logicInfo.bEnemyRole  )
			targetInfo[i].hurt = math.floor(targetInfo[i].hurt * power_suppress)
		end
	end
	
	targetInfo[i].hurt = math.floor(math.max(10, targetInfo[i].hurt))
	targetInfo[i].hurt = -(targetInfo[i].hurt)
	print("  ========伤害加成减免最终值====",targetInfo[i].hurt)
	--
	return targetInfo[i]
end

--计算伤害_伤害修正
function FightRoundManager:CaculateTarget_Correction(attackRole, targetRole, skillID, targetInfo)
	--总伤害修正
	local fightEffectValue = attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain) +
		targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain, attackRole)
	if skillID.skillId == 0 then

		-- 我发普通攻击修正+敌方被动普通攻击修正
		fightEffectValue = fightEffectValue + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_NormalAttack) +
			targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_NormalAttack)
	else

		-- 我发普通攻击修正+敌方被动普通攻击修正
		fightEffectValue = fightEffectValue + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack) +
			targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack)
	end

	fightEffectValue = fightEffectValue/10000+1
	fightEffectValue = math.max(0,fightEffectValue)
	targetInfo.hurt = math.floor(targetInfo.hurt*fightEffectValue)


	if skillID.skillId == 0 then
		targetInfo.hurt = targetInfo.hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_NormalAttack_Num)
		targetInfo.hurt = targetInfo.hurt - targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_NormalAttack_Num)
	else
		targetInfo.hurt = targetInfo.hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
		targetInfo.hurt = targetInfo.hurt - targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_SkillAttack_Num)
	end
	targetInfo.hurt = targetInfo.hurt - attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)
	targetInfo.hurt = targetInfo.hurt - targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_HurtGain_Num)

	targetInfo.hurt = math.min(-10, targetInfo.hurt)
	print("========伤害加成减免值====",targetInfo.hurt)
end

--计算伤害_系数相关处理
function FightRoundManager:CaculateTarget_coefficient(attackRole, targetRole, targetList, skillID, targetInfo)
	local frontRoleNum = fightRoleMgr:GetFrontRoleNum(targetRole, targetList)
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
	local decay = 1
	if skillBaseInfo ~= nil and skillBaseInfo.target_type == 2 then
		if frontRoleNum == 1 then
			decay = fightPublic:GetCacheConstant("hurt.decay.screen.one") / 100
		elseif frontRoleNum == 2 then
			decay = fightPublic:GetCacheConstant("hurt.decay.screen.two") / 100
		end
	elseif skillBaseInfo ~= nil and skillBaseInfo.target_type == 3 then
		if frontRoleNum == 1 then
			decay = fightPublic:GetCacheConstant("hurt.decay.row.one") / 100
		elseif frontRoleNum == 2 then
			decay = fightPublic:GetCacheConstant("hurt.decay.row.two") / 100
		end
	end
	targetInfo.hurt = targetInfo.hurt * decay
	targetInfo.hurt = math.floor(targetInfo.hurt)
	if decay ~= 1 then
		print(attackRole.logicInfo.name.."技能攻击"..targetRole.logicInfo.name..",伤害衰减系数："..decay..",衰减到："..targetInfo.hurt)
	end

	targetInfo.hurt = -(targetInfo.hurt)
end


--触发buffer
function FightRoundManager:CaculateTarget_Buffer(attackRole, targetRole, targetInfo, skillID, haveBuffTrigerList)
	local bufferID, bufferLevel = attackRole:GetTriggerBufferID(skillID, targetRole)
	local buffInfo = SkillBufferData:objectByID(bufferID, bufferLevel)
	if bufferID > 0 then
		if buffInfo == nil then
			bufferID = 0
			bufferLevel = 0
		elseif (haveBuffTrigerList ~= nil) then
			--haveBuffTrigerList 类型BUFF一次攻击只触发一次
			local haveBuff = haveBuffTrigerList[buffInfo.type]
			if (haveBuff == false) then		
				haveBuffTrigerList[buffInfo.type] = true
			elseif (haveBuff == true) then
				bufferID 		= 0
				bufferLevel 	= 0
			end
		end
		local effectValue = {}
		if (buffInfo.good_buff == 0 and targetRole:TriggerPassiveEffect(EnumFightSpellEffect.effect_85, effectValue)) then
			targetInfo.passiveEffect 	 	= EnumFightActiveEffectType.effect_85
			targetInfo.passiveEffectValue 	= -effectValue.value
			bufferID                      	= 0
			bufferLevel                   	= 0
		end
	end
	targetInfo.triggerBufferID 		= bufferID
	targetInfo.triggerBufferLevel 	= bufferLevel
end

--触发ExtraBuffer
function FightRoundManager:Target_ExtraBuffer(attackRole, targetRole, targetInfo, skillID)
	local bufferID, bufferLevel = attackRole:GetTriggerExtraBufferID(skillID, targetRole)
	local buffInfo = SkillBufferData:objectByID(bufferID, bufferLevel)
	if bufferID > 0 then
		if buffInfo == nil then
			bufferID = 0
			bufferLevel = 0
		end
	end
	targetInfo.triggerBufferID 		= bufferID
	targetInfo.triggerBufferLevel 	= bufferLevel
end

--attackRole 可不传
----计算被打角色的被动
function FightRoundManager:CaculateTarget_PassiveEffect(attackRole, targetRole, targetInfo, _passiveEffectList, immuneList, skillID, nTempTargetNum, targetInfoList, bNotTrigger)
	local isMarkHurt 		= targetInfo.effect == EnumFightHurtEffect.effect_10
	if (not isMarkHurt and not bNotTrigger) and targetInfo.hurt < 0 and targetRole:GetBuffByType(88) then
		targetInfo.hurt = 0
		return nTempTargetNum
	end
	
	--
	local passiveEffectList = targetRole:TriggerPassiveEffectList(_passiveEffectList, immuneList)
	local effectValue 		= {}
	local isMarkHurt 		= targetInfo.effect == EnumFightHurtEffect.effect_10
	local isDie				= self:IsActiveEffectBeheaded(targetInfo.activeEffect) --斩杀
	if (not isDie) then
		fightRoleMgr:ChangeEffectHurt(targetRole, targetInfo)
	end
	for i,effect in ipairs(_passiveEffectList) do
		if (effect == EnumFightSpellEffect.effect_82 and targetInfo.hurt < 0 and (not isDie) and targetRole:TrigerHurtMianyiSkill(EnumFightSpellEffect.effect_82, effectValue)) then
			local hurtLimit = targetRole:getMaxHp() * effectValue.value / 100
			if (math.abs(targetInfo.hurt) >= hurtLimit) then
				if (targetInfo.passiveEffect ~= EnumFightActiveEffectType.effect_82) then
					effectValue.targetRole:addTriggerSkillCount(effectValue.triggerSkillId, 1)
				end
				targetInfo.passiveEffect = EnumFightActiveEffectType.effect_82
				targetInfo.targetRole = effectValue.targetRole
				targetInfo.hurt = 0
				return nTempTargetNum
			end
		end
		if effect == EnumFightSpellEffect.effect_37 and targetInfo.hurt < 0 and (not isMarkHurt) and 
						( math.abs(targetInfo.hurt) >= targetRole:getCurrHp() and not isDie ) and 
						targetRole:TrigerHurtMianyiSkill(EnumFightSpellEffect.effect_37, effectValue)then
			--要死要死
			if (targetInfo.passiveEffect ~= 37) then
				effectValue.targetRole._specialSkillTime = effectValue.targetRole._specialSkillTime or 0
				effectValue.targetRole._specialSkillTime = effectValue.targetRole._specialSkillTime + 1
			end
			targetInfo.passiveEffect = 37
			targetInfo.passiveEffectValue = effectValue.value
			--
			local buffInfo = SkillBufferData:objectByID(targetInfo.triggerBufferID)
			if buffInfo and buffInfo.good_buff == 0 then
				targetInfo.triggerBufferID = 0
			end
			return nTempTargetNum
		end
	end
	--免疫BUFF
	if passiveEffectList[12] and targetInfo.triggerBufferID ~= 0 then
		local buffInfo = SkillBufferData:objectByID(targetInfo.triggerBufferID)
		if buffInfo and buffInfo.good_buff == 0 then
			targetInfo.passiveEffect = 12
			targetInfo.triggerBufferID = 0
		end
	elseif passiveEffectList[EnumFightActiveEffectType.effect_85] and targetInfo.triggerBufferID ~= 0 then
		local buffInfo = SkillBufferData:objectByID(targetInfo.triggerBufferID)
		if buffInfo and buffInfo.good_buff == 0 then
			local _effectValue = passiveEffectList[EnumFightActiveEffectType.effect_85]
			targetInfo.passiveEffect 		= EnumFightActiveEffectType.effect_85
			targetInfo.passiveEffectValue 	= -_effectValue.value
			targetInfo.triggerBufferID	 	= 0
		end
	elseif passiveEffectList[9] then
		local _effectValue = passiveEffectList[9]
		targetInfo.passiveEffect = 9
		_effectValue.value = math.min(100, _effectValue.value)
		targetInfo.passiveEffectValue = targetRole.maxhp * _effectValue.value / 100
		targetInfo.passiveEffectValue = math.floor(targetInfo.passiveEffectValue)
	elseif targetInfo.hurt < 0 and (not isMarkHurt) and targetRole:TrigerXianTianGongSkill(25, effectValue) and (math.abs(targetInfo.hurt) >= targetRole:getCurrHp() or isDie)then
		targetInfo.passiveEffect = 25
		targetRole.haveXianTianGong = targetRole.haveXianTianGong + 1
		targetInfo.passiveEffectValue = effectValue.value
		targetInfo.triggerBufferID = effectValue.value
		targetInfo.triggerBufferLevel = effectValue.level
	elseif (passiveEffectList[39] ) then
		if (math.abs(targetInfo.hurt) < targetRole:getCurrHp() and not isDie) then
			local _effectValue = passiveEffectList[39]
			targetInfo.passiveEffect = 39	
			targetInfo.passiveEffectValue = math.floor(targetRole.maxhp * _effectValue.value / 100)
			targetInfo.passiveEffectValue = math.abs(targetInfo.hurt) - math.floor(targetInfo.passiveEffectValue)
			if targetInfo.passiveEffectValue <= 0 then
				targetInfo.passiveEffect = 0
				targetInfo.passiveEffectValue = 0
			end
		end
	elseif passiveEffectList[5] then
		if math.abs(targetInfo.hurt) < targetRole:getCurrHp() then
			local _effectValue = passiveEffectList[5]
			targetInfo.passiveEffect = 5			
			targetInfo.passiveEffectValue = math.abs(targetInfo.hurt) * _effectValue.value / 100
			targetInfo.passiveEffectValue = self:CaculateSelfTargetHurtEnd(targetRole, targetInfo.passiveEffectValue)
			targetInfo.passiveEffectValue = math.floor(targetInfo.passiveEffectValue)
		end
	elseif passiveEffectList[6] then
		if skillID and skillID.skillId == 0 then
			targetInfo.passiveEffect = 6
		end
	elseif passiveEffectList[7] then
		if (not isDie) then
			local _effectValue = passiveEffectList[7]
			targetInfo.passiveEffect = 7
			_effectValue.value = math.min(100, _effectValue.value)
			targetInfo.hurt = targetInfo.hurt * (100-_effectValue.value) / 100
			targetInfo.hurt = math.floor(targetInfo.hurt)
		end
	elseif passiveEffectList[27] then
		if targetInfo.triggerBufferID ~= 0 then
			local buffInfo = SkillBufferData:objectByID(targetInfo.triggerBufferID)
			if buffInfo and buffInfo.good_buff == 0 and buffInfo.no_rebound ~= 3 then
				targetInfo.passiveEffect = 27
			end
		end
	elseif passiveEffectList[EnumFightPassiveEffectType.effect_72] then
		local currHp = targetRole:getCurrHp()
		local hurt = math.abs(targetInfo.hurt)
		if (hurt < currHp and not isDie) then
			local _effectValue 	= passiveEffectList[EnumFightPassiveEffectType.effect_72]
			local maxHp 		= targetRole:getMaxHp()
			local percentHurt 	= math.floor(maxHp * _effectValue.value / 100)
			if (hurt >= percentHurt) then
				targetInfo.passiveEffect 		= EnumFightPassiveEffectType.effect_72
				targetInfo.passiveEffectValue 	= hurt - percentHurt
			end
		end
	elseif (not isMarkHurt and not bNotTrigger) and not targetRole:isCanNotTriggerBeiDong() and targetRole:getPassiveSkillInfoByEffect(56) then
		--血刀的放最后处理
		for i,effect in ipairs(_passiveEffectList) do
			if (effect == 56) then
				if passiveEffectList[56] then
					if (not isDie) then
						--斩杀下不能触发
						local _effectValue 						=  passiveEffectList[56]
						targetInfo.passiveEffect                = 7
						_effectValue.value                      = math.min(100, _effectValue.value)
						targetInfo.hurt                         = math.floor(targetInfo.hurt * (100 - _effectValue.value) / 100)
						nTempTargetNum                           = nTempTargetNum + 1
						local tempInfo 				= {}
						tempInfo.effect 			= 1
						tempInfo.targetpos 			= targetRole.logicInfo.posindex
						tempInfo.hurt 				= 0
						tempInfo.passiveEffect 		= 3
						tempInfo.passiveEffectValue = 10   --怒气
						tempInfo.isExtra 			= true
						targetInfoList[nTempTargetNum] 	= tempInfo
					end
				elseif math.abs(targetInfo.hurt) < targetRole:getCurrHp() then
					local _targetList = self:getTargetListBySkillInfo(9,1,targetRole)
					if #_targetList > 0 then
						nTempTargetNum                    = nTempTargetNum + 1
						local tempInfo 			= {}
						tempInfo.effect 		= EnumFightHurtEffect.effect_4
						tempInfo.targetpos 		= _targetList[1].logicInfo.posindex
						tempInfo.hurt      		= math.abs(targetInfo.hurt)
						tempInfo.isExtra 		= true
						tempInfo.passiveEffect 	= EnumFightPassiveEffectType.effect_56
						tempInfo.passiveEffectValue 	= targetRole.logicInfo.posindex
						targetInfoList[nTempTargetNum] 	= tempInfo					
					end
				end
				break
			end
		end
	end
	return nTempTargetNum
end

function FightRoundManager:CaculateTarget_ActiveZhanShaEffect(attackRole, targetRole, targetInfo, skillID)
	if targetInfo.activeEffect == nil or targetInfo.activeEffect == 0 then
		--
		local immune 		= targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune, EnumFightEffectType.FightEffectType_ZhanSha)
		local effectValue 	= {}
		--
		local effect = attackRole:TriggerActiveZhanShaEffect(skillID,  effectValue, math.floor(targetRole.currHp / targetRole.maxhp * 10000), immune)
		if effect ~= 0 then
			targetInfo.activeEffect 		= effect
			targetInfo.activeEffectValue 	= -math.floor(attackRole.currHp * effectValue.value / 100)
			targetInfo.hurt 				= targetInfo.hurt + targetInfo.activeEffectValue * 2
		end
	end
end

--额外的buff触发
function FightRoundManager:CaculateTarget_ExtraBuff(attackRole, extra_targetList, skillID, targetInfoList)
	if extra_targetList and skillID.skillId > 0 then
		-- print("==================================>>>>>>      有额外的buff触发哦")
		for i,_targetRole in ipairs(extra_targetList) do
			local _targetInfo 		= {}
			_targetInfo.targetpos 	= _targetRole.logicInfo.posindex
			_targetInfo.effect 		= EnumFightHurtEffect.effect_8   --额外加buff
			_targetInfo.hurt 		= 0
			--
			self:Target_ExtraBuffer(attackRole, _targetRole, _targetInfo, skillID)
			if (_targetInfo.triggerBufferID ~= 0) then
				print("extra_buffid = ",_targetInfo.triggerBufferID)
				--table.insert( targetInfoList, _targetInfo)
				targetInfoList[#targetInfoList + 1] = _targetInfo
			end
		end
	end
end

--主动加buff EnumFightHurtEffect.effect_7
function FightRoundManager:CaculateTarget_ActiveBuff(attackRole, targetRole, targetInfo, skillID, bHaveTrigger, isspecialBoss)
	--触发buffer
	self:CaculateTarget_Buffer(attackRole, targetRole, targetInfo, skillID)
	--
	local effectValue = {}
	if attackRole:TriggerActiveEffect(skillID, 3, effectValue) then
		targetInfo.activeEffect = 3
		targetInfo.activeEffectValue = effectValue.value
	else
		local _activityEffectList = {10, 31}
		bHaveTrigger, activeEffect = self:CaculateTarget_ActiveEffect(_activityEffectList, attackRole, targetRole, targetInfo, skillID, bHaveTrigger, false, isspecialBoss, 0)
		--
		if (activeEffect and activeEffect ~= 0) then
			local immuneNoFanTan = attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune,EnumFightEffectType.FightEffectType_NoFanTan)
			if targetRole:TriggerPassiveEffect(27 ,effectValue, immuneNoFanTan) and targetInfo.triggerBufferID ~= 0 then
				local buffInfo = SkillBufferData:objectByID(targetInfo.triggerBufferID)
				if buffInfo and buffInfo.good_buff == 0 and buffInfo.no_rebound ~= 3 then
					targetInfo.passiveEffect = 27
				end
			end
		end
	end
	return bHaveTrigger
end

--其他处理
function FightRoundManager:CaculateTarget_Other(attackRole, targetRole, targetInfo, isbackAttack)
	if targetRole:IsLive() and not self:IsActiveEffectBeheaded(targetInfo.activeEffect) then
		--血刀大法
		local buffTypeList = targetRole:GetBuffListByType({30, 32, 54})
		local xdBuff = buffTypeList[30]
		if xdBuff ~= nil then
			targetInfo.hurt = targetInfo.hurt * (100 - xdBuff.config.value) / 100
			targetInfo.hurt = math.floor(targetInfo.hurt)
			targetInfo.passiveEffect = 50
			-- 己方被治疗修正
			local fightEffectValue 			= targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing)
			fightEffectValue 				= fightEffectValue / 10000+1
			fightEffectValue 				= math.max(0, fightEffectValue)
			targetInfo.passiveEffectValue 	= math.floor(targetRole:GetAttrNum(4) * xdBuff.config.params * fightEffectValue)
			targetInfo.passiveEffectValue 	= targetInfo.passiveEffectValue + targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing_Num)
			targetInfo.passiveEffectValue 	= math.max(0, targetInfo.passiveEffectValue)
		end

		if (GameConfig.HD) then
			--2019年7月1日17:5:10 老江湖不知道为什么注释掉了，但HD有。同步国服的时候HD暂时继续按之前打开，有问题再说
			local msBuff = buffTypeList[32]
			if msBuff ~= nil then
				targetInfo.hurt = targetInfo.hurt * (100-msBuff.config.value) / 100
				targetInfo.hurt = math.floor(targetInfo.hurt)
				targetInfo.passiveEffect = 7
			end
		end

		local fzBuff = buffTypeList[54]
		if fzBuff ~= nil and targetInfo.activeEffect ~= 10 and isbackAttack == false then --  and not fightRoleMgr:IsSameSide({attackRole, targetRole})  then
			-- isbackAttack = true
			targetInfo.triggerSkillType = 1 ---被击打
			targetInfo.triggerSkill = {skillId = tonumber(fzBuff.config.value)  ,level = fzBuff.config.level}
		end
	end
end

--狂龙乱舞 十字型溅射伤害
function FightRoundManager:CaculateTarget_ActiveEffect_29(attackRole, targetRole, targetInfo, targetInfoList)
	if targetInfo.passiveEffect == EnumFightActiveEffectType.effect_37 or targetInfo.passiveEffect == EnumFightActiveEffectType.effect_82 then
		return
	end
	if targetInfo.activeEffect == EnumFightActiveEffectType.effect_29 or targetInfo.activeEffect == EnumFightActiveEffectType.effect_79 then
		local nearList = self:GetNearIndex(targetRole.logicInfo.posindex)
		for j, pos in ipairs(nearList) do
			local _targetRole = fightRoleMgr:GetRoleByGirdIndex(pos)
			if _targetRole and _targetRole:IsLive() then
				local _targetRoleInfo 				= {}
				_targetRoleInfo.targetpos 			= pos
				_targetRoleInfo.hurt 				= math.floor(targetInfo.hurt * targetInfo.activeEffectValue / 100)
				_targetRoleInfo.effect 				= 1
				_targetRoleInfo.triggerBufferID 	= 0
				_targetRoleInfo.triggerBufferLevel 	= 0
				_targetRoleInfo.activeEffect 		= EnumFightActiveEffectType.effect_30
				_targetRoleInfo.activeEffectValue 	= targetInfo.targetpos
				--
				local passiveEffectList = {EnumFightSpellEffect.effect_82, 37, EnumFightSpellEffect.effect_9}
				self:CaculateTarget_PassiveEffect(nil, _targetRole, _targetRoleInfo, passiveEffectList)
				_targetRoleInfo.hurt = self:CaculateSelfTargetHurtEnd(_targetRole, _targetRoleInfo.hurt)
				if (GameConfig.HD) then
					targetRole:TriggerDongXie(_targetRoleInfo)
				end
				targetInfoList[#targetInfoList + 1] = _targetRoleInfo
			end
		end
	end
end


--
function FightRoundManager:CaculateTarget_BuffHandle(attackRole, targetRole, targetInfo, skillID, triggerShanBi, triggerType)
	local bUse = true
	if (GameConfig.HD and triggerType and (triggerType == 3 or triggerType == 4)) then
		bUse = false
	end
	if (bUse and triggerShanBi and targetInfo.effect ~= EnumFightHurtEffect.effect_3) then
		local buffTypeList = targetRole:GetBuffListByType({EnumFightBufferType.type_83, EnumFightBufferType.type_84})
		local mrll_dzxy = buffTypeList[EnumFightBufferType.type_83]
		if mrll_dzxy then
			targetInfo.effect             	= EnumFightHurtEffect.effect_3
			targetInfo.triggerSkillType   	= EnumFightTriggerHurtType.type_12 ---闪避
			targetInfo.triggerSkill 		= skillID
			targetInfo.hurt 				= 0
			targetInfo.passiveEffect 		= 0
			targetInfo.passiveEffectValue 	= 0
			targetInfo.activeEffect 		= 0
			targetInfo.activeEffectValue  	= 0
		elseif buffTypeList[EnumFightBufferType.type_84] then
			targetInfo.effect 				= EnumFightHurtEffect.effect_3
			targetInfo.hurt 				= 0
			targetInfo.passiveEffect 		= 0
			targetInfo.passiveEffectValue 	= 0
			targetInfo.activeEffect 		= 0
			targetInfo.activeEffectValue  	= 0
		end
	end
end

--目标受击触发相关
function FightRoundManager:CaculateTarget_BeHurt(attackRole, targetRole, targetInfo, triggerShanBi, skillID, bHaveAttackTrigger, isbackAttack, triggerType)
	local temp_value 	= {}
	if triggerShanBi and targetRole:TriggerBeHitPassiveEffect(36) then
		targetInfo.effect			 	= EnumFightHurtEffect.effect_3
		targetInfo.hurt 				= 0
		targetInfo.passiveEffect 		= 36
		targetInfo.passiveEffectValue 	= 0
		targetInfo.activeEffect 		= 0
		targetInfo.activeEffectValue 	= 0
	elseif targetRole:TriggerBeHurtUseSkill(2, temp_value) and triggerShanBi then
		targetInfo.effect 				= EnumFightHurtEffect.effect_3
		targetInfo.triggerSkillType 	= 2 ---闪避
		targetInfo.triggerSkill 		= temp_value
		targetInfo.hurt 				= 0
		targetInfo.passiveEffect 		= 0
		targetInfo.passiveEffectValue 	= 0
		targetInfo.activeEffect 		= 0
		targetInfo.activeEffectValue 	= 0
	elseif targetRole:TriggerBeHurtUseSkill(1, temp_value) and isbackAttack == false then
		targetInfo.triggerSkillType 	= 1 ---被击打
		targetInfo.triggerSkill 		= temp_value
	elseif targetRole:TriggerBeHitUseSkill(8, temp_value) then -- 被击打次数 
		targetInfo.triggerSkillType 	= 8 ---被击打
		targetInfo.triggerSkill 		= temp_value
	elseif targetRole:TriggerBeHitUseSkill(EnumFightTriggerHurtType.type_15, temp_value) then -- 被击打次数 
		targetInfo.activeTriggerSkillType 	= EnumFightTriggerHurtType.type_15
		targetInfo.activeTriggerSkill 		= temp_value
	end
	return bHaveAttackTrigger
end

----计算角色额外的effect
function FightRoundManager:CaculateTarget_ActiveEffect(activityEffectList, attackRole, targetRole, targetInfo, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	isbackAttack = isbackAttack or false
	local effectValue 	= {}
	local activeEffect, newEffectValue 
	activeEffect, newEffectValue = attackRole:TriggerActiveEffectList(skillID, activityEffectList, effectValue, newEffectValue)
	if (activeEffect ~= 0 and effectValue.value) then
		bHaveTrigger = fightPublic:ActiveEffect(activeEffect, targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
		if (newEffectValue and newEffectValue.value) then
			bHaveTrigger = fightPublic:ActiveEffect(newEffectValue.activeEffect, targetInfo, newEffectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
			activeEffect = targetInfo.activeEffect
		end
	end
	
	return bHaveTrigger, activeEffect
end


function FightRoundManager:CaculateHurtEffect(attackRole, skillID, targetRole, isbackAttack, isHelpAttack)
	if isbackAttack == nil then
		isbackAttack = false
	end
	--是否治疗技能
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
	if skillBaseInfo ~= nil then
		if skillBaseInfo.type == EnumFightSkillType.type_2 then
			return EnumFightHurtEffect.effect_4 --治疗
		elseif skillBaseInfo.type == EnumFightSkillType.type_3 then
			return EnumFightHurtEffect.effect_5 --净化
		elseif skillBaseInfo.type == EnumFightSkillType.type_8 then
			return EnumFightHurtEffect.effect_7 --主动加buff
		elseif skillBaseInfo.type == EnumFightSkillType.type_10 then
			return EnumFightHurtEffect.effect_11 -- 复活
		elseif skillBaseInfo.type == EnumFightSkillType.type_12 then
			return EnumFightHurtEffect.effect_12
		elseif skillBaseInfo.type == EnumFightSkillType.type_13 then
			return EnumFightHurtEffect.effect_13
		elseif skillBaseInfo.type == EnumFightSkillType.type_15 then
			return EnumFightHurtEffect.effect_16
		end
		local effect = skillBaseInfo.effect
		if effect == EnumFightSpellEffect.effect_100 then
			return EnumFightHurtEffect.effect_8
		elseif effect == EnumFightSpellEffect.effect_81 then
			return EnumFightHurtEffect.effect_4
		end
	end
	local attackLogic = attackRole.logicInfo
	local targetLogic = targetRole.logicInfo
	-- print("↓↓↓↓↓↓↓↓↓↓↓↓↓ 身法数据  ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓")
	-- print("阵位-->"..attackLogic.posindex,"  攻击者 = ",attackLogic.name ,"  skillID  ",skillID.skillId)
	-- print("身法 = ",attackRole:GetAttrNum(5))
	-- print("阵位-->"..targetLogic.posindex,"  被攻击者 = ",targetLogic.name)
	-- print("身法 = ",targetRole:GetAttrNum(5))
	-- print("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑")
	--[[
	暴击率 = max(暴击值/2-目标等级*49),0)/(1+0.04)^目标等级 + 暴击值/ (4*(1+0.04)^自身等级+0.65*自身等级）；      最小为：0
	命中率 = max(命中值/2-目标等级*49),0)/(1+0.04)^目标等级 + 命中值/ (4*(1+0.04)^自身等级+0.65*自身等级）+100 ； 最小为：0 + 100
	闪避率 = max(闪避值/2-目标等级*49),0)/(1+0.04)^目标等级 + 闪避值/（4*(1+0.04)^自身等级+0.65*自身等级）；      最小为：0
	抗暴率 = max(闪避值/2-目标等级*49),0)/(1+0.04)^目标等级 + 抗暴值/（4*(1+0.04)^自身等级+0.65*自身等级）；      最小为：0
	实际暴击率 = （暴击率 - 抗暴率 ）/100
	实际命中率 = 基础命中率  +  自己命中率 – 敌方闪避率 + 自己命中率% – 敌方闪避率%附加
	]]
	

	local targetLevel 	= targetLogic.level
	local attackLevel 	= attackLogic.level
	local pow104 		= math.pow(1.04,targetLevel)
	local pow104attack 	= math.pow(1.04,attackLevel)
	if (MainPlayer:getServerSwitchStatue(ServerSwitchType.Fight_Level)) then
		targetLevel = 100
		attackLevel = 100
	end
	if (not isHelpAttack) then
		if targetRole:HaveDzxyBuff() and attackRole:canTriggerDzxy() and isbackAttack == false then
			return 6 --乾坤挪移
		end
		
		local bizhong_buff = attackRole:GetBuffByType(53)
		if bizhong_buff == nil and (skillBaseInfo and skillBaseInfo.effect ~= EnumFightSpellEffect.effect_67) then
			local attackAttr_14 = attackRole:GetAttrNum(14)
			local hit = attackAttr_14 / 2 - targetLevel * 49
			hit = math.max(0,hit)
			if hit ~= 0 then
				hit = hit/pow104
			end
			hit = hit + attackAttr_14/ (4*(1+0.04)^attackLevel + 0.65*attackLevel)+ 100 --	说明:基础命中率 = 1 ,即:玩家初始有90%的基础命中率
			local targetAttr_15 = targetRole:GetAttrNum(15)
			local dodge = targetAttr_15 / 2 - attackLevel * 49
			dodge = math.max(0,dodge)
			if dodge ~= 0 then
				dodge = dodge/pow104attack
			end
			--闪避率公式修改 添加修正值
			dodge = dodge + targetAttr_15 / (4*pow104attack +0.65*attackLevel)
			-- print("↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓")
			-- print("被攻击者 = ",targetRole.logicInfo.name)
			-- print("闪避值 = ",targetAttr_15,"闪避率 = ",dodge)

				
			local hitRate = (hit - dodge) / 100 + attackRole:GetAttrNum(17)/10000 - targetRole:GetAttrNum(EnumAttributeType.MissPercent)/10000

			-- print("攻击者 = ",attackRole.logicInfo.name)
			-- print("基础命中率 = ",hit)
			-- print("附加命中率 = ",attackRole:GetAttrNum(17))
			-- print("敌方附加闪避率 = ",targetRole:GetAttrNum(EnumAttributeType.MissPercent))
			-- print("实际命中率 = ",hitRate)

			hitRate = math.max(hitRate, 0.3)
			hitRate = math.min(hitRate, 1.0)

			local radomNumber = math.random(1, 10000)
			
			if radomNumber > hitRate * 10000 and targetRole:GetSummoned() == 0 then --miss
				return 3
			end
		else
			print("必中buff耶")
		end
	end

	local attackAttr_12 = attackRole:GetAttrNum(12)
	local violent = attackAttr_12 / 2 - targetLevel * 49
	violent = math.max(0,violent)
	if violent ~= 0 then
		violent = violent/pow104
	end
	-- 暴击修正值，暴击值对暴击者自身的加成
	violent = violent + attackAttr_12 / (4*pow104attack +0.65*attackLevel)
	-- print("攻击者 = ",attackRole.logicInfo.name)
	-- print("暴击率 = ",attackAttr_12,"暴击率 = ",violent)

	local resistViolent = targetRole:GetAttrNum(13) / 2 - attackLevel * 49
	resistViolent = math.max(0,resistViolent)
	if resistViolent ~= 0 then
		resistViolent = resistViolent/pow104
	end
	-- 抗暴修正值，抗暴值对抗暴者自身的加成
	resistViolent = resistViolent + targetRole:GetAttrNum(13) / (4*pow104attack +0.65*attackLevel)
	-- print("被攻击者 = ",targetRole.logicInfo.name)
	-- print("抗暴率 = ",targetRole:GetAttrNum(13),"抗暴率 = ",resistViolent)
	-- print("↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑")

	local violentRate = (violent - resistViolent) / 100 + attackRole:GetAttrNum(16)/10000  - targetRole:GetAttrNum(EnumAttributeType.CritResistancePercent)/10000
	violentRate = math.max(violentRate, 0)
	violentRate = math.min(violentRate, 0.9)

	local radomNumber = math.random(1, 10000)
	if radomNumber < violentRate*10000 then --暴击
		return 2
	else
		return 1
	end
end

--伤害分摊
function FightRoundManager:TargetHurtShare(targetList)
	
	local roleList_1 = fightRoleMgr:GetAllLiveRole(false, false, true)
	local roleList_2 = fightRoleMgr:GetAllLiveRole(true, false, true)
	local nLen_1 = roleList_1:length()
	local nLen_2 = roleList_2:length()
	local buff_1, buff_2, role_1, role_2
	-- if (nLen_1 > 1) then
		for role in roleList_1:iterator() do
			buff_1 = role:GetBuffByType(EnumFightBufferType.type_525)
			if (buff_1) then
				role_1 = role
				break
			end
		end
	-- end
	-- if (nLen_2 > 1) then
		for role in roleList_2:iterator() do
			buff_2 = role:GetBuffByType(EnumFightBufferType.type_525)
			if (buff_2) then
				role_2 = role
				break
			end
		end
	
	-- end
	if (buff_2 == nil and buff_1 == nil) then
		return
	end
	local excludeEffect= {
				[EnumFightHurtEffect.effect_3] = true,
				[EnumFightHurtEffect.effect_9] = true,
				[EnumFightHurtEffect.effect_15] = true
	}
	local excludePassiveEffect= {
				[EnumFightActiveEffectType.effect_37] = true,
				[EnumFightActiveEffectType.effect_82] = true,
			
	}
	local excludeActiveEffect= {
				[EnumFightActiveEffectType.effect_30] = true,
				[EnumFightActiveEffectType.effect_63] = true,
	}
	
	local addHrutList = {}
	local nLen = #targetList
	local passiveEffectList = {EnumFightSpellEffect.effect_82, EnumFightSpellEffect.effect_37, EnumFightSpellEffect.effect_9,
													EnumFightSpellEffect.effect_39, EnumFightSpellEffect.effect_72}
	local bUseBuff_1 = false
	local bUseBuff_2 = false
	for i=1,nLen do
		local targetInfo = targetList[i]
		if (targetInfo and targetInfo.hurt < 0) then
			if (excludeEffect[targetInfo.effect] or excludePassiveEffect[targetInfo.passiveEffect] or excludeActiveEffect[targetInfo.activeEffect] or self:IsActiveEffectBeheaded(targetInfo.activeEffect)) then
			else
				--
				if (targetInfo.hurt < 0) then
					local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
					if (targetRole) then
						if (buff_1 and targetRole.logicInfo.bEnemyRole == false) then
							targetInfo.hurt = math.floor(targetInfo.hurt / nLen_1)
							for role in roleList_1:iterator() do
								if (role.logicInfo.posindex ~= targetInfo.targetpos or nLen_1 == 1) then
									local _targetRoleInfo 				= {}
									_targetRoleInfo.targetpos 			= role.logicInfo.posindex
									_targetRoleInfo.hurt 				= targetInfo.hurt
									_targetRoleInfo.effect 				= EnumFightHurtEffect.effect_10
									_targetRoleInfo.triggerBufferID 	= 0
									_targetRoleInfo.triggerBufferLevel 	= 0
									_targetRoleInfo.activeEffect 		= EnumFightActiveEffectType.effect_83
									_targetRoleInfo.activeEffectValue 	= targetInfo.targetpos
									if (nLen_1 == 1) then
										_targetRoleInfo.hurt = 0
									end
									bUseBuff_1 = true
									table.insert( addHrutList, _targetRoleInfo )
								end
							end
						elseif ( buff_2 and targetRole.logicInfo.bEnemyRole == true) then
							targetInfo.hurt = math.floor(targetInfo.hurt / nLen_2)
							for role in roleList_2:iterator() do
								if (role.logicInfo.posindex ~= targetInfo.targetpos or nLen_2 == 1) then
									local _targetRoleInfo 				= {}
									_targetRoleInfo.targetpos 			= role.logicInfo.posindex
									_targetRoleInfo.hurt 				= targetInfo.hurt
									_targetRoleInfo.effect 				= EnumFightHurtEffect.effect_10
									_targetRoleInfo.triggerBufferID 	= 0
									_targetRoleInfo.triggerBufferLevel 	= 0
									_targetRoleInfo.activeEffect 		= EnumFightActiveEffectType.effect_83
									_targetRoleInfo.activeEffectValue 	= targetInfo.targetpos
									if (nLen_2 == 1) then
										_targetRoleInfo.hurt = 0
									end
									bUseBuff_2 = true
									table.insert( addHrutList, _targetRoleInfo )
								end
							end
						end
						self:CaculateTarget_PassiveEffect(nil, targetRole, targetInfo, passiveEffectList)
					end
				end
			end
		end
	end
	for i,targetInfo in ipairs(addHrutList) do
		local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
		if (targetRole) then
			 self:CaculateTarget_PassiveEffect(nil, targetRole, targetInfo, passiveEffectList)
			 table.insert( targetList, targetInfo)
		end
	end
	if (bUseBuff_1) then
		role_1:OnBuffTriggerByTypeInfo(buff_1)
	end
	if (bUseBuff_2) then
		role_2:OnBuffTriggerByTypeInfo(buff_2)
	end
	return targetList
end

function FightRoundManager:CaculateTargetHurt(attackRole, skillID, targetList ,extra_targetList, isbackAttack, triggerType)

	local targetInfoList 		= {}
	local targetNum 			= #targetList
	local nTempTargetNum 		= targetNum
	local bHaveTrigger 			= false
	local bHaveAttackTrigger 	= false
	if type(skillID) == "number" then
		skillID = { skillId = skillID,level = 0}
	end
	if isbackAttack == nil then
		isbackAttack = false 
	end

	fightRoleMgr:clearSpecialTime()
	--
	local fightType 	= FightManager:GetFightType()
	local boosFightList = {
		[EnumFightType.Boss] 				= true,
		[EnumFightType.FactionFightShan] 	= true,
		[EnumFightType.Wuling] 				= true,
	}
	local isspecialBoss = boosFightList[fightType] or false
	--
	local triggerShanBi = true	
	if fightType == 10 or fightType == 28 then
		triggerShanBi = false
	end
	local haveBuffTrigerList = {[EnumFightBufferType.type_505] = false}
	local activityEffectList = 
	{
		15,16,1,2,3,4,8,10,31,11,14,21,22,23,24,29,32,58,33,
		EnumFightSpellEffect.effect_60,EnumFightSpellEffect.effect_65,EnumFightSpellEffect.effect_67,EnumFightSpellEffect.effect_71,EnumFightSpellEffect.effect_73,
		EnumFightSpellEffect.effect_75,EnumFightSpellEffect.effect_77,EnumFightSpellEffect.effect_78,EnumFightSpellEffect.effect_79,EnumFightSpellEffect.effect_81
	}
	local addTargetInfoList = {}
	--attack---
	local immuneNoFanTan = nil--attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune,EnumFightEffectType.FightEffectType_NoFanTan)
	--
	print("/////////////////////////////")
	print("------动作--------------------",self.actionCount)
	print("------阵位: ",attackRole.logicInfo.posindex,"  攻击者:",attackRole.logicInfo.name," 技能:",skillID)

	for i=1,targetNum do
		local targetRole 		= targetList[i]
		local targetInfo 		= {}
		local isDie				= false
		targetInfoList[i] 		= targetInfo
		targetInfo.targetpos 	= targetRole.logicInfo.posindex
		targetInfo.effect 		= self:CaculateHurtEffect(attackRole, skillID, targetRole, isbackAttack)
		print(i,"--被攻击者---",targetRole.logicInfo.name, targetInfo)
		targetInfo.isExtra 		= false
		local bHurtSkill = false
		local bHelpToHurt = false
		if targetInfo.effect == EnumFightHurtEffect.effect_3 then
			targetInfo.hurt = 0
		elseif targetInfo.effect == EnumFightHurtEffect.effect_5 then
			targetInfo.hurt = 0
			local _activityEffectList = {28, 31}
			bHaveTrigger = self:CaculateTarget_ActiveEffect(_activityEffectList, attackRole, targetRole, targetInfo, skillID, bHaveTrigger, false, isspecialBoss, i)
		elseif targetInfo.effect == EnumFightHurtEffect.effect_6 then
			--乾坤挪移
			targetInfo = self:CaculateTarget_QianKunNuoYi(attackRole, targetRole, targetInfo, skillID, targetNum)
		elseif targetInfo.effect == EnumFightHurtEffect.effect_7 then
			--主动加buff
			targetInfo.hurt = 0
			bHaveTrigger = self:CaculateTarget_ActiveBuff(attackRole, targetRole, targetInfo, skillID, bHaveTrigger, isspecialBoss)
			if (GameConfig.HD) then
				local triggerShanBi = true
				if fightType == EnumFightType.Boss or fightType == EnumFightType.Wuling then
					triggerShanBi = false
				end
				self:CaculateTarget_BuffHandle(attackRole, targetRole, targetInfo, skillID, triggerShanBi)
			end
		elseif targetInfo.effect == EnumFightHurtEffect.effect_8 then
			--触发buffer
			self:CaculateTarget_Buffer(attackRole, targetRole, targetInfo, skillID, haveBuffTrigerList)
			targetInfo.hurt = 0
			targetInfo.activeEffect = EnumFightActiveEffectType.effect_100
		elseif (targetInfo.effect == EnumFightHurtEffect.effect_13) then
			--给召唤物加血
			local skillInfo 	= SkillLevelData:objectByID(skillID)
			local targetRole 	= fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
			if (targetRole and targetRole:IsLive()) then
				targetInfo.hurt = math.abs(math.floor(targetRole.maxhp * (skillInfo.buff_rate/100)))
			else
				targetInfo.hurt = 0
			end
		else
			
			if targetInfo.effect == EnumFightHurtEffect.effect_1 or targetInfo.effect == EnumFightHurtEffect.effect_2 then
				bHurtSkill = true
			end

			if attackRole:TriggerActiveEffect(skillID, 34, effectValue) then
				targetInfo.effect = 2
			end
		
			--触发buffer
			self:CaculateTarget_Buffer(attackRole, targetRole, targetInfo, skillID, haveBuffTrigerList)
		
			local isBuffTarget 		= false
			targetInfo.hurt			= -1
			if self:IsTreatmentEffect(targetInfo.effect) then
				targetInfo.hurt		= 0
			end
			--真元护体 优先级最高， 所有伤害都要计算此BUFF后面计算
			targetInfo.hurt, isBuffTarget = self:CaculateSelfTargetHurtEnd(targetRole, targetInfo.hurt)

			local tempBuffEndHurt 	= targetInfo.hurt
			if (isBuffTarget) then
				tempBuffEndHurt = targetInfo.hurt
			else
				targetInfo.hurt = self:CaculateHurtNum(attackRole, skillID, targetRole, targetInfo.effect, targetNum)
				if (bHurtSkill) then
					self:CaculateTarget_coefficient(attackRole, targetRole, targetList, skillID, targetInfo)
				end
			end	
			--
			local effectValue = {}
			local temp_activeEffect = nil
			if (isbackAttack) then
				temp_activeEffect = attackRole:TriggerBuffHurtBackAttack(targetRole,  effectValue)					
			else
				temp_activeEffect = attackRole:TriggerBuffHurt(targetRole, skillID, effectValue)
			end
			--加深效果跟activeEffect不冲突
			if temp_activeEffect and temp_activeEffect ~= 0 then
				targetInfo.deepHurtType = temp_activeEffect
				targetInfo.hurt = targetInfo.hurt * (100+effectValue.value) / 100
				targetInfo.hurt = math.floor(targetInfo.hurt)
				print("加深效果触发:",effectValue,targetInfo)
			end
			if (isBuffTarget) then
				targetInfo.hurt = tempBuffEndHurt
			elseif (bHurtSkill) then
				--总伤害修正
				self:CaculateTarget_Correction(attackRole, targetRole, skillID, targetInfo)
			end
			--------------------------------------
			bHaveTrigger = self:CaculateTarget_ActiveEffect(activityEffectList, attackRole, targetRole, targetInfo, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
			--修正攻击角色技能ActiveEffect加深的伤害
			if (isBuffTarget) then
				targetInfo.hurt = tempBuffEndHurt
			end
			--------------------------------------
			self:CaculateTarget_ActiveZhanShaEffect(attackRole, targetRole, targetInfo, skillID)
			--是否触发被动效果:反弹5 反击6 化解7 复活9 免疫12 受击加血50
			effectValue = {}
			isDie				= self:IsActiveEffectBeheaded(targetInfo.activeEffect) --斩杀
			if not isDie and fightType ~= EnumFightType.Boss and bHurtSkill and targetRole:GetBuffByType(64) then
				if skillID.skillId > 0 then
					print("伤害转治疗")
					targetInfo.hurt = math.abs(targetInfo.hurt)
					bHurtSkill = false
				end
			end
			local immuneList 	= {}
			immuneList[27] 		= immuneNoFanTan or attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune,EnumFightEffectType.FightEffectType_NoFanTan)
			if bHurtSkill then
				local passiveEffectList = {12, EnumFightSpellEffect.effect_9 , 5, 6, 56, 7, 27, EnumFightSpellEffect.effect_85}
				nTempTargetNum = self:CaculateTarget_PassiveEffect(attackRole, targetRole, targetInfo, passiveEffectList, immuneList, skillID, nTempTargetNum, targetInfoList)
				--
				if (GameConfig.HD) then
					targetRole:TriggerDongXie(targetInfo)
				end
				--
				if (not isbackAttack) then
					local temp_value 		= {}
					local _triggerShanBi 	= triggerShanBi
					if (_triggerShanBi) then
						local immune 		= immuneNoShanBi
						if immune ~= nil and immune > 0 then
							local _random = math.random(1, 10000)
							if _random <= immune then
								_triggerShanBi = false
							end
						end
					end
					--
					bHaveAttackTrigger = self:CaculateTarget_BeHurt(attackRole, targetRole, targetInfo, _triggerShanBi, skillID, bHaveAttackTrigger, isbackAttack, triggerType)
					-----------------------
					self:CaculateTarget_BuffHandle(attackRole, targetRole, targetInfo, skillID, _triggerShanBi, triggerType)
					-----------------------
					bHaveAttackTrigger = self:CaculateTriggerSkill(attackRole, targetRole, targetInfo, skillID, bHaveAttackTrigger, isbackAttack)
					-- -----------------------
					-- self:CaculateTarget_ActiveEffect_29(attackRole, targetRole, targetInfo, targetInfoList)
				end
				local __temp_value2 = {}
				if targetInfo.effect ~= EnumFightHurtEffect.effect_3 and not bHaveAttackTrigger and attackRole:TriggerActiveAddSkillEffect(skillID, EnumFightTriggerHurtType.type_22, __temp_value2) then --触发主动效果：追加一次主动
					targetInfo.activeTriggerSkillType 	= EnumFightTriggerHurtType.type_22
					targetInfo.activeTriggerSkill 		= __temp_value2
					bHaveAttackTrigger = true
				end
				-----------------------
				self:CaculateTarget_Other(attackRole, targetRole, targetInfo, isbackAttack)
				
			else
				--bHurtSkill = false
				local buff = targetRole:GetBuffByType(81)
				if buff then
					targetInfo.hurt = -math.floor(math.abs(targetInfo.hurt)*tonumber(buff.config.value) / 100)
					print("治疗转伤害:",targetInfo.hurt)
					bHurtSkill = true
					bHelpToHurt = true
				end
				
				local effectValue = {}
				if bHurtSkill then
					local __passiveEffectList = {EnumFightSpellEffect.effect_82, 37, EnumFightSpellEffect.effect_9, 39}
					nTempTargetNum = self:CaculateTarget_PassiveEffect(attackRole, targetRole, targetInfo, __passiveEffectList, immuneList, skillID, nTempTargetNum, targetInfoList, true)
					local isBuffTarget = false
					targetInfo.hurt, isBuffTarget = self:CaculateSelfTargetHurtEnd(targetRole, targetInfo.hurt)
					if( GameConfig.HD) then
						targetRole:TriggerDongXie(targetInfo)
					end
				end
				local temp_value = {}
				if not bHurtSkill and targetRole:TriggerBeHurtUseSkill(3, temp_value) then
					targetInfo.triggerSkillType = 3 ---被治疗
					targetInfo.triggerSkill = temp_value
				end
			end
		end
		self:CaculateTargetHurtEnd(attackRole, targetRole, targetInfo, skillID)
		if (bHurtSkill and not bHelpToHurt) then
			self:CaculateTarget_ActiveEffect_29(attackRole, targetRole, targetInfo, targetInfoList)
		end
		if (isDie) then
			targetInfo.hurt = -(targetRole:getCurrHp() + 100)
		end
		targetInfo.hurt = math.floor(targetInfo.hurt)
		print(" end----> ",targetInfo.hurt)
	end
	
	self:CaculateTarget_ExtraBuff(attackRole, extra_targetList, skillID, targetInfoList)
	--
	return targetInfoList
end
function FightRoundManager:SwitchSpeed(speed)
	local n = 0.2
	if  speed ~= nil and speed > 1 then
		FightManager.fightSpeed = speed
		local ss = speed * 0.6
		me.Scheduler:setTimeScale(ss)
	else
		FightManager.fightSpeed = 1
		me.Scheduler:setTimeScale(1)
	end
	fightRoleMgr:OnFightSpeedChange()
end
return FightRoundManager:new()