--
-- Author: Zippo
-- Date: 2013-12-05 20:02:30
--

local fightRoleMgr  = require("lua.logic.fight.FightRoleManager")
local fightRoundMgr = require("lua.logic.fight.FightRoundManager")
local fightPublic 	= require("lua.logic.fight.FightPublic")

local baseAction = require("lua.logic.fight.BaseFightAction")
local FightOutAction = class("FightOutAction", baseAction)

function FightOutAction:ctor(actionInfo)
	self.super.ctor(self, actionInfo)
	self.bQuick = true
	self.actionInfo = actionInfo
	self.attackerRole = fightRoleMgr:GetRoleByGirdIndex(actionInfo.attackerpos)
	assert(self.attackerRole, "attackerpos" .. actionInfo.attackerpos .. "not find")

	self.bNormalAttack = false
	if actionInfo.skillid.skillId == 0 then -- 普通攻击
		self.bNormalAttack = true
	end
	self.bEnemyAllDie = self:IsEnemyAllDie()
	if self.actionInfo.buffList and #self.actionInfo.buffList > 0 then
		-- for i=1,#self.actionInfo.buffList do
		-- 	local buff = self.actionInfo.buffList[i]
		for i,buff in ipairs(self.actionInfo.buffList) do
			local buffInfo = SkillBufferData:objectByID(buff[6])
			if buff  and buffInfo  and buffInfo.gain_type == 1 then
				local targetRole = fightRoleMgr:GetRoleByGirdIndex(buff[2])
				self:AddBuffToTarget(targetRole,targetRole,buff[6],buff[7],0)
			end
		end
	end
	self.actionInfo.buffList = {}
end

function FightOutAction:dispose()
end

function FightOutAction:ShowSkillNameEff()
	self:BeginAttack()
end

function FightOutAction:AddAttackBuff()
	if self.actionInfo.targetlist == nil then
		return
	end
	-- for i=1,#self.actionInfo.targetlist do
	-- 	local targetInfo = self.actionInfo.targetlist[i]
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
		local targetRole = self:GetTargetRole(i)
		targetInfo.triggerBufferID = targetInfo.triggerBufferID or 0
		if targetInfo.triggerBufferID > 0 then
			local buffConfig = SkillLevelData:getBuffInfo( targetInfo.triggerBufferID , targetInfo.triggerBufferLevel)
			if buffConfig ~= nil and buffConfig.good_buff == 1 and not fightRoleMgr:IsSameSide({self.attackerRole, targetRole}) then
				if buffConfig.type ~= 56 then
					targetInfo.bHaveAddBuff = true
					if self:AddBuffToTarget(self.attackerRole,self.attackerRole, targetInfo.triggerBufferID,targetInfo.triggerBufferLevel) then
						self:AddBuffInfoToServer(self.attackerRole, self.attackerRole, targetInfo.triggerBufferID, 0)
						-- break
					end
				end
			end
		end
	end
end

--通用中转函数
function FightOutAction:onShowAttackAnim()
	self:ShowAttackAnim()
end

--通用中转函数
function FightOutAction:onShowAttackAnimEnd()
	self:setHelpAttack()
	self:ShowActiveEffectHitEnd()
	self:addAttackNum()
	self:setAttackSkill()
	FightManager:OnActionEnd()
end

function FightOutAction:showHitXuliEff()
	self:ShowAllHit()
end
function FightOutAction:_showHitXuliEff()
	self:ShowAllHit()
end

function FightOutAction:ShowAllHit()
	self:GetHitNumber()
	self:ShowHit(1)
end

function FightOutAction:GetHitCount()
	self.hitCount = 1
end

--被动效果:反弹5 反击6 化解7 复活9 免疫12 受击加血50 表现
function FightOutAction:ShowPassiveEffect(targetInfo)
	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	if targetRole == nil then
		return
	end

	local effect = targetInfo.passiveEffect
	local effectValue = targetInfo.passiveEffectValue
	if (effect) then
		fightPublic:FightPassiveEffect(effect, true, self.attackerRole, targetRole , targetInfo, self)
	end
end

--主动效果:吸怒1 减敌怒2 增己怒3 吸血4 侧击8 净化10 致死11 七伤拳21 表现
function FightOutAction:ShowActiveEffect(targetInfo)
	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	if targetRole == nil then
		return
	end

	local effect = targetInfo.activeEffect
	-- local effectValue = targetInfo.activeEffectValue
	if (effect) then
		fightPublic:FightActionEffect(effect, true, self.attackerRole, targetRole, targetInfo, self.actionInfo)
	end
end

function FightOutAction:OnRoleHitAnimComplete()
	if self.hitAnimCompleteRoleNum == nil then
		return
	end

	local targetNum = #self.actionInfo.targetlist
	self.hitAnimCompleteRoleNum = self.hitAnimCompleteRoleNum + 1
	if self.hitAnimCompleteRoleNum == targetNum then
		self.hitAnimCompleteRoleNum = nil
		FightManager:OnActionEnd()
	end
end

--攻击动作完成后逻辑处理
function FightOutAction:AllHitEndTargetLogic()
	self:HitEndTargetReLive()
end
function FightOutAction:ShowXiXinDaFaEffect()

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
			if self:AddBuffToTarget(self.attackerRole,self.attackerRole, tonumber(skillInfo.effect_value),self.actionInfo.skillid.level) then
				self:AddBuffInfoToServer(self.attackerRole, self.attackerRole, tonumber(skillInfo.effect_value), 0)
			end
			return
		end
	end
end


function FightOutAction:ShowQianKunDaNuoYi()
	-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	local skillInfo = SkillLevelData:objectByID(self.actionInfo.skillid)
	if skillInfo == nil then
		return
	end

	if skillInfo.effect == 20 then
		local liveList = fightRoleMgr:GetAllLiveRole(self.attackerRole.logicInfo.bEnemyRole)
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
			role:ShowFightTextOut(math.floor(skillInfo.effect_value))
		end
	end
end

--闪避
function FightOutAction:ShowHitEffect_3(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	if self.actionInfo.bBackAttack == nil or self.actionInfo.bBackAttack == false then
		self:showTriggerSkill(targetInfo)
	end
	
	if targetRole:GetBuffByType(84) then
		targetRole:OnBuffTriggerByType(84)
	end
	self:ShowPassiveEffect(targetInfo)
	return needAddRedAnger,needRemoveIndex
end
--治疗加血
function FightOutAction:ShowHitEffect_4(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = (true and not targetInfo.isExtra)
	-- fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurtList[hitIndex])
	if (not targetRole:IsLive()) then
		-- if (targetInfo.passiveEffect == EnumFightPassiveEffectType.effect_56) then
			targetInfo.hurt = 0
			targetInfo.hurtList[hitIndex] = 0
		-- end
	else
		targetRole:ShowFightTextOut(targetInfo.hurtList[hitIndex])
	end
	
	self:ShowActiveEffect(targetInfo)
	self:ShowPassiveEffect(targetInfo)
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
	if (i == 1) then
		local skillInfo = targetRole:GetTriggerBySkillHurtType(self.attackerRole.skillID, EnumFightTriggerHurtType.type_18, false)
		if (skillInfo) then
			self.attackerRole:addTriggerSkillCount(self.attackerRole.skillID.skillId, -1)
		end
	end
	self:showTriggerSkill(targetInfo)
	return needAddRedAnger,needRemoveIndex
end

--净化，去除目标所有减益buff 
function FightOutAction:ShowHitEffect_5(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	targetRole:CleanBuff(self.attackerRole)
	self:ShowActiveEffect(targetInfo)
	return needAddRedAnger,needRemoveIndex
end

--乾坤挪移 
function FightOutAction:ShowHitEffect_6(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	fightRoundMgr:SetDzxyAttackAction(targetRole, self.attackerRole, targetInfo.hurt)
	targetRole:ShowFightTextOut(0)
	targetRole:OnBuffTriggerByType(27)
	targetInfo.hurt = 0
	return needAddRedAnger,needRemoveIndex
end

--额外的加buff 
function FightOutAction:ShowHitEffect_8(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	targetInfo.triggerBufferID = targetInfo.triggerBufferID or 0
	if targetInfo.triggerBufferID > 0 and targetInfo.bHaveAddBuff ~= true and bLastHit then
		local buffConfig = SkillLevelData:getBuffInfo( targetInfo.triggerBufferID , targetInfo.triggerBufferLevel)
		if buffConfig ~= nil then
			if self:AddBuffToTarget(self.attackerRole, targetRole, targetInfo.triggerBufferID, targetInfo.triggerBufferLevel,targetInfo.hurt) then
				self:AddBuffInfoToServer(self.attackerRole, targetRole, targetInfo.triggerBufferID, 0)
			end
		end
	end
	return needAddRedAnger,needRemoveIndex
end
function FightOutAction:ShowHitEffect_9(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	targetRole:OnBuffTrigger(6)
	fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurt)
	targetRole:ShowFightTextOut( targetInfo.hurt)
	self:ShowPassiveEffect(targetInfo)
	self:showTriggerSkill(targetInfo)
	return needAddRedAnger,needRemoveIndex
end


function FightOutAction:ShowHitEffect_10(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	targetRole:ShowFightTextOut( targetInfo.hurt)
	self:ShowPassiveEffect(targetInfo)
	return needAddRedAnger,needRemoveIndex
end

--治疗加血 
function FightOutAction:ShowHitEffect_11(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	targetRole:fuHuoActionEnd()
	fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurtList[hitIndex])
	targetRole:ShowFightTextOut( math.floor(targetInfo.hurtList[hitIndex]))
	self:ShowActiveEffect(targetInfo)
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
		fightRoleMgr:refreshMaxHp()
	end
	return needAddRedAnger,needRemoveIndex
end

function FightOutAction:ShowHitEffect_12(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	self:ShowActiveEffect(targetInfo)
	self:ShowHitEff(targetRole, i)
	--西施选中角色放技能需要在西施Action之后才能加入
	if (self.actionInfo.attackerpos ~= targetInfo.targetpos) then
		fightRoundMgr:XiShiInitiativeSkill(self.actionInfo.skillid, targetRole)
	end
	self:OnRoleHitAnimComplete()
	return needAddRedAnger,needRemoveIndex
end

function FightOutAction:ShowHitEffect_13(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	targetRole:ShowFightTextOut(math.floor(targetInfo.hurtList[hitIndex]))
	local haveBuff = targetRole:GetBuffByType(EnumFightBufferType.type_97)
	if (haveBuff) then
		local enemyBuffTypeList1 	= {EnumFightBufferType.type_98}
		fightRoleMgr:RemoveRoleBuff(targetRole.logicInfo.bEnemyRole, enemyBuffTypeList1)
	end
	if not targetInfo.isExtra then
		self:ShowHitEff(targetRole, i)
	end
	self:OnRoleHitAnimComplete()
	return needAddRedAnger,needRemoveIndex
end

--酒桶召唤
function FightOutAction:ShowHitEffect_14(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	if (skillBaseInfo.type == EnumFightSkillType.type_13) then
		local skillInfo2 = SkillLevelData:objectByID(self.actionInfo.skillid)
		FightManager:addNewRole(skillBaseInfo.buff_id, targetInfo.activeEffectValue, self.attackerRole, skillInfo2.effect_value)
		if not targetInfo.isExtra then
			targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.activeEffectValue)
			if (targetRole) then
				self:ShowHitEff(targetRole, i)
			end
		end
	end
	return needAddRedAnger,needRemoveIndex
end


function FightOutAction:ShowHitEffect_15(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	if (targetRole:getCurrHp() > 0) then
		targetRole:ShowFightTextOut(targetInfo.hurtList[hitIndex])
	elseif (targetInfo.passiveEffect == EnumFightPassiveEffectType.effect_56) then
		targetInfo.hurt = 0
	end
	self:ShowBuffPassiveEffect(targetRole)
	self:OnRoleHitAnimComplete()
	return needAddRedAnger,needRemoveIndex
end

--治疗加净化
function FightOutAction:ShowHitEffect_16(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	if hitIndex == 1 then
		targetRole:CleanBuff(self.attackerRole)
	end
	needAddRedAnger = self:ShowHitEffect_4(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger,needRemoveIndex
end

function FightOutAction:ShowHitEffect_1(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	if hitIndex == 1 and self.actionInfo.triggerType ~= 5 then
		self:ShowActiveEffect(targetInfo)
	end
	
	fightRoleMgr:addHurtReport(self.attackerRole.logicInfo.posindex ,targetInfo.hurtList[hitIndex])
	if targetInfo.passiveEffect == 25 or targetInfo.passiveEffect == 37 or targetInfo.passiveEffect == EnumFightActiveEffectType.effect_82 then
		targetRole:ShowFightTextOut( 0, false, true)
	else
		targetRole:ShowFightTextOut(targetInfo.hurtList[hitIndex], false, true)
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
		if bHurtSkill then
			self:ShowBuffPassiveEffect(targetRole)
		end
	end


	if targetInfo.hurtList[hitIndex] < 0 then
		if not targetRole:IsLive() then
			fightRoleMgr:refreshMaxHp()
		end
	end
	return needAddRedAnger,needRemoveIndex
end
return FightOutAction