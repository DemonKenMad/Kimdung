--    script writer fei
--    creation time 2018.01.03
--    Description:
--　　　　┏┓　　　┏┓+ +
--　　　┏┛┻━━━┛┻┓ + +
--　　　┃　　　　　　　┃ 　
--　　　┃　　　━　　　┃ ++ + + +
--　　 ████━████ ┃+
--　　　┃　　　　　　　┃ +
--　　　┃　　　┻　　　┃
--　　　┃　　　　　　　┃ + +
--　　　┗━┓　　　┏━┛
--　　　　　┃　　　┃　　　　　　
--　　　　　┃　　　┃ + + + +
--　　　　　┃　　　┃　　　　　　
--　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug　　
--　　　　　┃　　　┃
--　　　　　┃　　　┃　　+　　　　　　　　
--　　　　　┃　 　　┗━━━┓ + +
--　　　　　┃ 　　　　　　　┣┓
--　　　　　┃ 　　　　　　　┏┛
--　　　　　┗┓┓┏━┳┓┏┛ + + + +
--　　　　　　┃┫┫　┃┫┫
--　　　　　　┗┻┛　┗┻┛+ + + +

local FightPublic = {}
function FightPublic:init()
	self.bInit = true
	self.cacheConstant = {}
end
function FightPublic:GetCacheConstant(key)
	if (not self.bInit or not self.cacheConstant) then
		self:init()
	end
	local value = self.cacheConstant[key]
	if (value == nil) then
		value = ConstantData:getValue(key)
		self.cacheConstant[key] = value
	end
	return value
end

--计算暴击伤害
--最终伤害 = 基础伤害 * max（1, 1.5+暴击增加-对面暴击减免） 2019-8-29 11:44:59修改
function FightPublic:CaculateCritHurtNum(attackRole, targetRole, hurt)
	-- hurt = 1.5 * hurt
	--
	local addCrit = 0
	local subCrit = 0
	if (attackRole) then
		--暴击加成
		-- hurt = hurt + hurt * attackRole:GetAttrNum(EnumAttributeType.CritAdditionPercent) / 10000
		addCrit =  attackRole:GetAttrNum(EnumAttributeType.CritAdditionPercent) / 10000
		print('----------------暴击加成伤害--',addCrit)
		-- hurt = hurt + math.floor(hurt * attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra, EnumAttributeType.CritAdditionPercent) / 10000)
	end

	if (targetRole) then
		--暴击伤害减免
		-- hurt = hurt - hurt * targetRole:GetAttrNum(EnumAttributeType.CritSubitionPercent) / 10000
		subCrit = targetRole:GetAttrNum(EnumAttributeType.CritSubitionPercent) / 10000
		print('----------------暴击减免伤害--',subCrit)
		-- hurt = hurt + math.floor(hurt * targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra, EnumAttributeType.CritSubitionPercent) / 10000)
	end
	--
	hurt = hurt * math.max( 1, 1.5 + addCrit - subCrit)
	print('----------------暴击伤害--',hurt)
	return math.floor(hurt)
end

-------------ActiveEffect---begin-----------------
function FightPublic:ActiveEffect(activeEffect, targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	local _activeEffectFunc = self[ "ActiveEffect_"..activeEffect ]
	if _activeEffectFunc then
		bHaveTrigger = _activeEffectFunc(self, targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	else
		local effect = activeEffect or "nil"
		toastMessage("not ActiveEffect_"..effect)
	end

	return bHaveTrigger, activeEffect
end



function FightPublic:ActiveEffect_1(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)

	if (bHaveTrigger == false ) then
		local bImmune = true
		local immune = targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune, EnumFightEffectType.FightEffectType_NoXiNu)
		if immune ~= nil and immune > 0 then
			local random = math.random(1, 10000)
			if random <= immune then
				bImmune = false
			end
		end
		if (bImmune) then
			targetInfo.activeEffect = 1
			targetInfo.activeEffectValue = effectValue.value
			bHaveTrigger = true
		end
	end
	return bHaveTrigger
end
function FightPublic:ActiveEffect_2(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if (bHaveTrigger == false) then
		targetInfo.activeEffect = 2
		targetInfo.activeEffectValue = effectValue.value
		bHaveTrigger = true
	end
	return bHaveTrigger
end
function FightPublic:ActiveEffect_3(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if (bHaveTrigger == false) then
		targetInfo.activeEffect = 3
		targetInfo.activeEffectValue = effectValue.value
		bHaveTrigger = true
	end
	return bHaveTrigger
end
function FightPublic:ActiveEffect_4(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if (bHurtSkill) then
		targetInfo.activeEffect = 4
		targetInfo.activeEffectValue = math.floor(targetInfo.hurt * effectValue.value / 100)

		-- 己方被治疗修正
		local fightEffectValue = attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing)
		fightEffectValue = fightEffectValue/10000+1
		fightEffectValue = math.max(0,fightEffectValue)

		targetInfo.activeEffectValue = math.floor(targetInfo.activeEffectValue * fightEffectValue)
		targetInfo.activeEffectValue = math.abs(targetInfo.activeEffectValue)
		targetInfo.activeEffectValue = targetInfo.activeEffectValue + attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing_Num)
		targetInfo.activeEffectValue = math.max(0,targetInfo.activeEffectValue)
	end
	return bHaveTrigger
end
function FightPublic:ActiveEffect_8(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if (attackRole:IsSameRow(targetRole) == false) then
		if (skillID.skillId == 0) then
			targetInfo.activeEffect = 8
			targetInfo.hurt = targetInfo.hurt * (100+effectValue.value) / 100
			targetInfo.hurt = math.floor(targetInfo.hurt)
		elseif (skillID.skillId > 0) then
			targetInfo.activeEffect = 8
			targetInfo.hurt = targetInfo.hurt * (100+effectValue.value) / 100
			targetInfo.hurt = math.floor(targetInfo.hurt)
		end
	end
	return bHaveTrigger
end
function FightPublic:ActiveEffect_10(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = 10
	return bHaveTrigger
end
function FightPublic:ActiveEffect_11(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	--致死 老技能效果 目前未使用
	-- targetInfo.activeEffect = 11
	-- targetInfo.hurt = -targetRole.currHp
	return bHaveTrigger
end

function FightPublic:ActiveEffect_14(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = 14
	targetInfo.hurt = targetInfo.hurt - effectValue.value*(targetRole.maxhp-targetRole.currHp)
	targetInfo.hurt = math.floor(targetInfo.hurt)
	return bHaveTrigger
end

function FightPublic:ActiveEffect_15(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = 15
	targetInfo.activeEffectValue = effectValue.value
	targetInfo.hurt = math.floor(targetInfo.hurt -  effectValue.value*(targetRole.maxhp)/100)
	return bHaveTrigger
end

function FightPublic:ActiveEffect_16(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = 16
	targetInfo.activeEffectValue = effectValue.value
	targetInfo.hurt = math.floor(targetInfo.hurt -  effectValue.value*(targetRole.currHp)/100)
	return bHaveTrigger
end

function FightPublic:ActiveEffect_21(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffectValue = -math.floor(attackRole.currHp * effectValue.value / 100)
	targetInfo.hurt = math.floor(targetInfo.hurt + targetInfo.activeEffectValue*2)
	targetInfo.activeEffect = 21
	return bHaveTrigger
end

function FightPublic:ActiveEffect_22(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = 22
	return bHaveTrigger
end
function FightPublic:ActiveEffect_23(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = 23
	return bHaveTrigger
end

function FightPublic:ActiveEffect_24(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = 24
	targetInfo.hurt = targetInfo.hurt * (1+(i-1)*effectValue.value / 10000)
	targetInfo.hurt = math.floor(targetInfo.hurt)	
	return bHaveTrigger
end

function FightPublic:ActiveEffect_28(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = 28
	targetInfo.activeEffectValue = effectValue.value
	return bHaveTrigger
end

function FightPublic:ActiveEffect_29(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffectValue = effectValue.value
	targetInfo.hurt = targetInfo.hurt
	targetInfo.activeEffect = 29
	return bHaveTrigger
end
function FightPublic:ActiveEffect_31(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if (bHaveTrigger == false) then
		targetInfo.activeEffect = EnumFightActiveEffectType.effect_31
		targetInfo.activeEffectValue = effectValue.value
		bHaveTrigger = true
	end
	return bHaveTrigger
end
function FightPublic:ActiveEffect_32(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if not isspecialBoss then
		targetInfo.activeEffect = 32
		targetInfo.activeEffectValue = math.floor(effectValue.value*(targetRole.maxhp)/100)
	end
	return bHaveTrigger
end

function FightPublic:ActiveEffect_33(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if not isspecialBoss then
		targetInfo.activeEffect = 33
		targetInfo.activeEffectValue = math.floor(effectValue.value*(targetRole.currHp)/100)
	end
	return bHaveTrigger
end
function FightPublic:ActiveEffect_34(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.effect = 2
	return bHaveTrigger
end



function FightPublic:ActiveEffect_58(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if not isspecialBoss then
		targetInfo.activeEffect = 58
		targetInfo.hurt = targetInfo.hurt -  math.floor(effectValue.value*(targetRole.maxhp)/100)
		targetInfo.activeEffectValue = math.floor( attackRole.maxhp * ( effectValue.value/100 ) )
	end
	return bHaveTrigger
end

function FightPublic:ActiveEffect_60(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = EnumFightActiveEffectType.effect_60
	targetInfo.hurt = 0
	return bHaveTrigger
end

function FightPublic:ActiveEffect_65(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if (bHaveTrigger == false) then
		targetInfo.activeEffect = EnumFightActiveEffectType.effect_65
		targetInfo.activeEffectValue = effectValue.value
		bHaveTrigger = true
	end
	return bHaveTrigger
end

--
function FightPublic:ActiveEffect_67(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = EnumFightActiveEffectType.effect_67
	targetInfo.activeEffectValue = effectValue.value
	return bHaveTrigger
end

--
function FightPublic:ActiveEffect_70(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	--当自身的攻击产生暴击时，最终伤害值随机翻2—X倍。（即暴击时最终伤害保底翻2倍
	if (targetInfo.effect == EnumFightHurtEffect.effect_2) then
		targetInfo.activeEffect = EnumFightActiveEffectType.effect_70
		local minHurtTimes = 1
		if (effectValue.value < minHurtTimes) then
			effectValue.value = minHurtTimes
		end
		local hurtTimes = math.random(minHurtTimes, effectValue.value)
		targetInfo.hurt = math.floor(targetInfo.hurt * hurtTimes)
		targetInfo.activeEffectValue = hurtTimes
	end
	return bHaveTrigger
end

--
function FightPublic:ActiveEffect_71(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	local hpPer =  attackRole.maxhp * ( effectValue.value / 100 ) 
	targetInfo.hurt 				= math.floor(targetInfo.hurt - hpPer)
	if (targetInfo.activeEffect ~= EnumFightActiveEffectType.effect_73) then
		targetInfo.activeEffect 		= EnumFightActiveEffectType.effect_71
		targetInfo.activeEffectValue 	= hpPer
	else
		targetInfo.activeEffectValue 	= 0
	end
	-- end
	return bHaveTrigger
end

--
function FightPublic:ActiveEffect_73(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	local currHp 		= targetRole:getCurrHp()
	if (effectValue.value == 100) then
		--必斩杀
		targetInfo.activeEffect 	= EnumFightActiveEffectType.effect_73
		targetInfo.hurt 			= -math.ceil( currHp + 100)
	elseif (currHp < (targetRole:getMaxHp() * effectValue.value / 100)) then
		targetInfo.activeEffect 	= EnumFightActiveEffectType.effect_73
		targetInfo.hurt 			= targetInfo.hurt - currHp
		if (targetInfo.hurt < 0) then
			targetInfo.hurt = -math.ceil( -targetInfo.hurt )
		end
	end
	return bHaveTrigger
end

--
function FightPublic:ActiveEffect_75(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if (targetRole.quality >= 6) then
		targetInfo.activeEffect 		= EnumFightActiveEffectType.effect_75
		targetInfo.activeEffectValue 	= effectValue.value
	end
	return bHaveTrigger
end



--天池神功治疗 恢复血量点上限百分百
function FightPublic:ActiveEffect_77(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect = EnumFightActiveEffectType.effect_77
	local maxHp = math.floor(targetRole:getMaxHp() * effectValue.value / 100)
	targetInfo.hurt 		= math.max(0, maxHp - targetRole:getCurrHp())
	return bHaveTrigger
end

function FightPublic:ActiveEffect_78(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	if (bHaveTrigger == false) then
		targetInfo.activeEffect = EnumFightActiveEffectType.effect_78
		targetInfo.activeEffectValue = effectValue.value
		bHaveTrigger = true
	end
	return bHaveTrigger
end


function FightPublic:ActiveEffect_79(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffectValue = effectValue.value
	targetInfo.activeEffect = EnumFightActiveEffectType.effect_79
		
 	return bHaveTrigger
end
function FightPublic:ActiveEffect_81(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffectValue = math.floor(effectValue.value * targetRole:getMaxHp() / 100)
	targetInfo.hurt = 0
	targetInfo.activeEffect = EnumFightActiveEffectType.effect_81
		
 	return bHaveTrigger
end
--
function FightPublic:ActiveEffect_100(targetInfo, effectValue, attackRole, targetRole, skillID, bHaveTrigger, bHurtSkill, isspecialBoss, i, isbackAttack)
	targetInfo.activeEffect 	= EnumFightActiveEffectType.effect_100
	targetInfo.hurt = 0
	return bHaveTrigger
end
-------------ActiveEffect---end-----------------

-------------FightAction:ShowActiveEffect---begin-----------------

function FightPublic:FightActionEffect(activeEffect, isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local _activeEffectFunc = self[ "FightActionEffect_"..activeEffect ]
	if _activeEffectFunc then
		_activeEffectFunc( self , isOut, attackerRole, targetRole, targetInfo, actionInfo)
	else
		local effect = activeEffect or "nil"
		-- toastMessage("not FightActionEffect_"..activeEffect)
		print("not function FightActionEffect_"..effect)
	end
end

function FightPublic:FightActionEffect_1(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	fightRoleMgr:AddAnger(targetRole.logicInfo.bEnemyRole, -effectValue)
	fightRoleMgr:AddAnger(attackerRole.logicInfo.bEnemyRole, effectValue)
	if (not isOut) then
		attackerRole:ShowEffectName("xinu")
		if not attackerRole.logicInfo.bEnemyRole then
			TFDirector:currentScene().fightUiLayer:AddAngerEffect(0)
		else
			TFDirector:currentScene().fightUiLayer:AddAngerEffect(1)
		end
	end	
end

function FightPublic:FightActionEffect_2(isOut, attackerRole, targetRole , targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	fightRoleMgr:AddAnger(targetRole.logicInfo.bEnemyRole, -effectValue)
	if (not isOut) then
		targetRole:ShowEffectName("jiannu")
		if not attackerRole.logicInfo.bEnemyRole then
			TFDirector:currentScene().fightUiLayer:AddAngerEffect(1)
		end
	end
end
function FightPublic:FightActionEffect_3(isOut, attackerRole, targetRole , targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	fightRoleMgr:AddAnger(attackerRole.logicInfo.bEnemyRole, effectValue)
	if (not isOut) then
		attackerRole:ShowEffectName("jianu")
		if not attackerRole.logicInfo.bEnemyRole then
			TFDirector:currentScene().fightUiLayer:AddAngerEffect(2)
		end
	end
end
function FightPublic:FightActionEffect_4(isOut, attackerRole, targetRole , targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	fightRoleMgr:addHurtReport(attackerRole.logicInfo.posindex,  effectValue)
	
	if (not isOut) then
		attackerRole:ShowEffectName("xixue")
	end
	attackerRole:showFightHurtText(isOut, effectValue, "")
end
function FightPublic:FightActionEffect_10(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	targetRole:CleanBuff(attackerRole)
end
function FightPublic:FightActionEffect_11(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	if (not isOut) then
		targetRole:ShowEffectName("zhisi")
	end
end
function FightPublic:FightActionEffect_14(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	if (not isOut) then
		targetRole:ShowEffectName("zhongji")
	end
end
function FightPublic:FightActionEffect_21(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	-- local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	attackerRole:showFightHurtText(isOut, effectValue, "")
end
function FightPublic:FightActionEffect_81(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	-- local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	targetRole:showFightHurtText(isOut, effectValue, "")
	targetRole:addTriggerSkillCount(actionInfo.skillid.skillId)
end

--斩杀 赵敏
function FightPublic:FightActionEffect_26(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local effectValue 	= targetInfo.activeEffectValue
	
	if (not isOut) then
		targetRole:ShowEffectName("zhimingyiji")
	end
	attackerRole:showFightHurtText(isOut, effectValue, "")
	targetRole:removeZhanShaBuff()
end

function FightPublic:FightActionEffect_28(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	local liveList = fightRoleMgr:GetAllLiveRole(attackerRole.logicInfo.bEnemyRole)
	local length = liveList:length()
	for i=1,length do
		local role = liveList:objectAt(i)
		role.skillCD = 0
	end
	fightRoleMgr:AddAnger( attackerRole.logicInfo.bEnemyRole,effectValue)
	if (not isOut) then
		if not attackerRole.logicInfo.bEnemyRole then
			TFDirector:currentScene().fightUiLayer:AddAngerEffect(0)
		end
	end
end

function FightPublic:FightActionEffect_32(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	fightRoleMgr:addHurtReport(attackerRole.logicInfo.posindex,  effectValue)
	
	if (not isOut) then
		attackerRole:ShowEffectName("xixue")
	end
	attackerRole:showFightHurtText(isOut, effectValue, "")
end

function FightPublic:FightActionEffect_33(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	fightRoleMgr:addHurtReport(attackerRole.logicInfo.posindex,  effectValue)
	
	if (not isOut) then
		attackerRole:ShowEffectName("xixue")
	end
	attackerRole:showFightHurtText(isOut, effectValue, "")
end
function FightPublic:FightActionEffect_58(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	attackerRole:showFightHurtText(isOut, effectValue, "")
	if (not isOut) then
		attackerRole:ShowEffectName("xixue")
	else
		fightRoleMgr:addHurtReport(attackerRole.logicInfo.posindex,  effectValue)
	end
end

function FightPublic:FightActionEffect_67(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	--
	fightRoleMgr:AddAnger(targetRole.logicInfo.bEnemyRole, effectValue)
	if (not isOut) then
		targetRole:ShowEffectName("jianu_1")
	end
end


function FightPublic:FightActionEffect_71(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	if (actionInfo.skillid.skillId == attackerRole.skillID.skillId) then
		attackerRole:addTriggerSkillCount(actionInfo.skillid.skillId, -1)
	end
end


--斩杀神雕大侠
function FightPublic:FightActionEffect_73(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	if (not isOut) then
		targetRole:ShowEffectName("zhimingyiji")
	end
end

--
function FightPublic:FightActionEffect_75(isOut, attackerRole, targetRole, targetInfo, actionInfo)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.activeEffectValue
	-- fightRoleMgr:AddAnger(targetRole.logicInfo.bEnemyRole, -effectValue)
	targetRole:addRoleAnger(-effectValue)
end
-------------FightAction:ShowActiveEffect---end-----------------

-------------FightAction:ShowPassiveEffect---begin-----------------

function FightPublic:FightPassiveEffect(passiveEffect, isOut, attackerRole, targetRole , targetInfo, fightAction)
	if (passiveEffect == EnumFightActiveEffectType.effect_9) then
		targetInfo.passiveEffect = 0;
		targetInfo.passiveEffectValue = 0;
		return
	end
	local _activeEffectFunc = self[ "FightPassiveEffect_"..passiveEffect ]
	if _activeEffectFunc then
		_activeEffectFunc( self , isOut, attackerRole, targetRole , targetInfo, fightAction)
	else
		local effect = passiveEffect or "nil"
		print("not FightPassiveEffect_"..effect)
	end
end

function FightPublic:FightPassiveEffect_3(isOut, attackerRole, targetRole , targetInfo, fightAction)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.passiveEffectValue
	--
	fightRoleMgr:AddAnger(targetRole.logicInfo.bEnemyRole, effectValue)
	if (not isOut) then
		if not targetRole.logicInfo.bEnemyRole then
			TFDirector:currentScene().fightUiLayer:AddAngerEffect(2)
		end
	end
end
function FightPublic:FightPassiveEffect_5(isOut, attackerRole, targetRole , targetInfo, fightAction)
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.passiveEffectValue
	--
	fightRoleMgr:addHurtReport(targetInfo.targetpos,  -effectValue)
	if (not isOut) then
		attackerRole:ShowEffectName("fantan")
	end
	attackerRole:showFightHurtText(isOut, -effectValue, "")
	if(GameConfig.HD) then
		local Buff = targetRole:GetBuffByType(EnumFightBufferType.type_19)
		if (Buff and Buff.config.last_type == EnumFightBuffLastType.last_Type_3) then
			targetRole:OnBuffTriggerByTypeInfo(Buff)
		end
	end
end

function FightPublic:FightPassiveEffect_6(isOut, attackerRole, targetRole , targetInfo, fightAction)
	if fightAction and fightAction.actionInfo.skillid.skillId == 0 then
		if (not isOut) then
			FightManager:getFightRoundMgr():SetBackAttackAction(targetRole, attackerRole)
		else
			fightAction.hasTrrigerBackAttack = true
		end
	end
end

function FightPublic:FightPassiveEffect_7(isOut, attackerRole, targetRole , targetInfo, fightAction)
	if (not isOut) then
		targetRole:ShowEffectName("huajie")
	end
	local msBuff = targetRole:GetBuffByType(32)
	if msBuff then
		targetRole:OnBuffTriggerByType(32)
	end
end

function FightPublic:FightPassiveEffect_9(isOut, attackerRole, targetRole , targetInfo, fightAction)
	--这里校验是否真的复活
	local reallyRelive = false
	if targetRole and targetRole:IsLive() == false then
		local effectValue 	= targetInfo.passiveEffectValue
		if (not isOut) then
			reallyRelive = targetRole:ReLive(effectValue)
		else
			reallyRelive = targetRole:ReLiveOut(effectValue)
		end
	end
	if not reallyRelive then
		targetInfo.passiveEffect = 0;
		targetInfo.passiveEffectValue = 0;
	elseif(GameConfig.HD) then
		local skillID = targetRole:getAngerSkill()
		if skillID and skillID.skillId > 0 then
			targetRole:addTriggerSkillCount(skillID.skillId, 1)
			if (targetRole:getTriggerSkillCountBySkill(skillID.skillId) < 2) then
				targetRole.haveRelive = false
			end
		end
	end
end

function FightPublic:FightPassiveEffect_12(isOut, attackerRole, targetRole , targetInfo, fightAction)
	if (not isOut) then
		targetRole:ShowEffectName("mianyi")
	end
end

function FightPublic:FightPassiveEffect_25(isOut, attackerRole, targetRole , targetInfo, fightAction)
	targetInfo.hurt = 0
	if (not isOut) then
		targetRole:AddBodyEffect("biqi_up", false)
		targetRole:AddBodyEffect("biqi_buttom", false,true)
	end
end

function FightPublic:FightPassiveEffect_36(isOut, attackerRole, targetRole , targetInfo, fightAction)
	targetInfo.passiveEffect = 0
	targetRole.beHurtNum = 0
end

function FightPublic:FightPassiveEffect_37(isOut, attackerRole, targetRole , targetInfo, fightAction)
	targetInfo.hurt = 0
	targetRole:CleanBuff(targetRole)
	targetRole.bActDie = true
	if (not isOut) then
		targetRole:AddBodyEffect("miansi_2", false)
	end
	local fightRoleMgr 	= FightManager:getFightRoleMgr()
	local effectValue 	= targetInfo.passiveEffectValue
	--
	local effectRole = fightRoleMgr:GetRoleByGirdIndex(effectValue)
	if effectRole then
		if (not isOut) then
			effectRole:AddBodyEffect("miansi_1", false)
		end
		effectRole._specialSkillTime 	= effectRole._specialSkillTime or 0
		effectRole.specialSkillTime 	= effectRole.specialSkillTime or 0
		effectRole._specialSkillTime 	= effectRole._specialSkillTime - 1
		effectRole.specialSkillTime 	= effectRole.specialSkillTime + 1
		local  skillInfo = effectRole:getTrigerHurtMianyiEffectSkillId(37)
		if skillInfo and skillInfo.buff_id then
			if fightAction and fightAction:AddBuffToTarget(effectRole,targetRole, skillInfo.buff_id,skillInfo.level) then
				fightAction:__AddBuffInfoToServer(effectRole, targetRole,skillInfo.id,skillInfo.level ,skillInfo.buff_id, 0)
			end
		end
	end
end


function FightPublic:FightPassiveEffect_50(isOut, attackerRole, targetRole , targetInfo, fightAction)
	if targetRole:IsLive() then
		local fightRoleMgr 	= FightManager:getFightRoleMgr()
		local effectValue 	= targetInfo.passiveEffectValue
		--
		fightRoleMgr:addHurtReport(targetInfo.targetpos ,  effectValue)
		targetRole:showFightHurtText(isOut, effectValue, "")
		targetRole:OnBuffTriggerByType(30)
	end
end

function FightPublic:FightPassiveEffect_39(isOut, attackerRole, targetRole, targetInfo, fightAction)
	if targetRole:IsLive() then
		local effectValue 	= targetInfo.passiveEffectValue
		targetRole:showFightHurtText(isOut, effectValue, "")
	end
end
function FightPublic:FightPassiveEffect_72(isOut, attackerRole, targetRole, targetInfo, fightAction)
	self:FightPassiveEffect_39(isOut, attackerRole, targetRole, targetInfo, fightAction)
end

function FightPublic:FightPassiveEffect_82(isOut, attackerRole, targetRole , targetInfo, fightAction)
	if (not isOut) then
		targetRole:AddBodyEffect("mianshang_2", false)
		if (targetInfo.targetRole) then
			targetInfo.targetRole:AddBodyEffect("mianshang_1", false)
		end
	end
	targetInfo.targetRole = nil
end

--
function FightPublic:FightPassiveEffect_85(isOut, attackerRole, targetRole , targetInfo, fightAction)
	if (not isOut) then
		targetRole:ShowEffectName("jinghua")
	end
	local effectValue 	= targetInfo.passiveEffectValue or 0
	targetRole:showFightHurtText(isOut, effectValue, "")
	--
end
return FightPublic