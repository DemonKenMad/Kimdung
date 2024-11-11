--
-- Author: Zippo
-- Date: 2013-12-05 17:34:00
--

local mapLayer  = require("lua.logic.fight.MapLayer")
local fightRoleMgr  = require("lua.logic.fight.FightRoleManager")
local fightRoundMgr  = require("lua.logic.fight.FightRoundManager")
local baseRole = require("lua.logic.fight.BaseFightRole")
local FightRole = class("FightRole", baseRole)

local EFFECT_ZORDER = 100
local FIGHT_TEXT_ZORDER = 300
	
function FightRole:ctor(roleInfo)
	self.super.ctor(self, roleInfo, true)
	print("///////////////Begin/////////////////////")
	self.extAnger = 0 			--策划要求额外怒气
	self.triggerPassiveSkillData = {} --被动技能触发次数 按需求加入
	self.manualActionNum = 0
	self.attackNum = 0
	self.beHurtNum = 0
	
	self.haveXianTianGong = 0
	-- self.armatureTime = os.clock()
	-- self.badTime = 0
	-- self.m_nCurFrame = 0
	-- self.isAbnormal = false  -- 是否cd有异常 
	-- armature:addMEListener(TFARMATURE_UPDATE, function(test1,test2,frame)
	-- 		local temp = frame - self.m_nCurFrame
	-- 		if self.m_nCurFrame ~= 0 and temp > 0 then
	-- 			local temp_time = os.clock() - self.armatureTime
	-- 			-- temp_time = temp_time * 10
	-- 			-- print("temp_time = ",temp_time)
	-- 			if temp_time > temp*1/(self.animSpeed*GameConfig.ANIM_FPS/2) then
	-- 				self.badTime = self.badTime + 1
	-- 			else
	-- 				self.badTime = 0
	-- 			end
	-- 			if self.badTime >= 3 then
	-- 				self.isAbnormal = true;
	-- 				-- CommonManager:showFightPluginErrorLayer()
	-- 				-- TFDirector:pause()
	-- 				-- toastMessage("使用非法外挂")
	-- 				-- AlertManager:changeSceneForce(SceneType.LOGIN)
	-- 			end
	-- 		end
	-- 		self.m_nCurFrame = frame
	-- 		self.armatureTime = os.clock()
	-- 	end)


	self.role_anger = roleInfo.anger or 0
	roleInfo.beginHp          = roleInfo.maxhp

	-- print("------阵位  "..nPosIndex)
	self.immuneAttribute = {}
	if self.logicInfo.immune ~= nil then
		self.immuneAttribute = GetAttrByString(self.logicInfo.immune)
		print("------immune: ",self.logicInfo.immune)
	end
	self.effectExtraAttribute = {}
	if self.logicInfo.effectActive ~= nil then
		self.effectExtraAttribute = GetAttrByString(self.logicInfo.effectActive)
		print("------effectActive: ",self.logicInfo.effectActive)
	end
	self.beEffectExtraAttribute = self.beEffectExtraAttribute or {}
	if self.logicInfo.effectPassive ~= nil then
		local addAttr = GetAttrByString(self.logicInfo.effectPassive)
		if (self.beEffectExtraAttribute) then
			for k,v in pairs(addAttr) do
				local y = self.beEffectExtraAttribute[k] or 0
				self.beEffectExtraAttribute[k] = v + y
			end
		else
			self.beEffectExtraAttribute = addAttr
		end
		
		print("------effectPassive: ",self.logicInfo.effectPassive)
	end

	self.skillID = roleInfo.spellId
	self.skillCD = 0

	self.angerSkillCD = 0
	self.angerSkillMaxCD = 0

	self.specialSkillAnger = -1
	self.immuneAttr = {}
	if self.role_angerMax and self.role_angerMax > 0 then 
		local specialSkill = self:getUseSelfAngerSkill()
		-- print("specialSkill == >",specialSkill)
		if specialSkill  then
			self.specialSkillAnger = specialSkill.trigger_anger
			self.angerSkillMaxCD = specialSkill.cool_time
		else
			self.role_angerMax = 0
		end
	end
	self:CreateHalo()
	self:initExtAnger()
	self.removeList 				= TFArray:new()
	self.nConsumptionSkillRelease 	= 0
	---
	if (self.angerSkillMaxCD > 0) then
		local addTime = self:getEffectExtraAttrNum(EnumFightAttributeType.Xinfa_effect, EnumXinFaSpecialType.XinFaSpecialType_SillCD)
		addTime = self.angerSkillMaxCD - math.floor(self.angerSkillMaxCD * addTime / 10000)
		if (addTime > 0) then
			self.angerSkillMaxCD = addTime
		end
	end
	print("///////////////END/////////////////////")
end


function FightRole:addManualActionNum()
	self.manualActionNum = self.manualActionNum + 1
end

function FightRole:addAttackNum()
	self.attackNum = self.attackNum + 1
end

function FightRole:addBeHurtNum()
	self.beHurtNum = self.beHurtNum + 1
end

function FightRole:initExtAnger()
	if FightManager.fightBeginInfo.fighttype == 16 and self.logicInfo.bEnemyRole == false then
		local climbOptionList = NorthClimbManager:getNowFloorOption()
		for i=1,#climbOptionList do
			local battleInfo = BattleLimitedData:objectByID(climbOptionList[i])
			if battleInfo.type == 4 then
				self.extAnger = self.extAnger + battleInfo.value
			end
		end
	end
	
	if GameConfig.HD then
		if self.logicInfo.bEnemyRole == false and FightManager.fightBeginInfo.fighttype == 31 or FightManager.fightBeginInfo.fighttype == 32 then
			--浪人武士
			local knightLimitIds = {}
			if (FightManager.fightBeginInfo.fighttype == 32) then
				local info = KnightManager:getFightKnightInfo()
				knightLimitIds = KnightManager:getKnightLimitIds(info.knightType, info.level)
			else
				knightLimitIds = KnightManager:getKnightLimitIds()
			end
			for i,limitId in pairs(knightLimitIds) do
				local battleInfo = BattleLimitedData:objectByID(tonumber(limitId))
				if battleInfo and battleInfo.type == 4 then
					self.extAnger = self.extAnger + battleInfo.value
				end
			end
		end
	end
end

function FightRole:CreateHalo()
	-- self.haloAttr = {}
	self.haloImmuneAttr        = {}
	self.haloEffectExtraAttr   = {}
	self.haloBeEffectExtraAttr = {}
	self.haloTypeList          = {}
	self.haloSkillEffectList   = {}
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil then
			local skillType = skillInfo.type
			if skillType == 5 or skillType == 6 then
				self:AddBodyEffect(50, true, true)
				local haloAttr = self.haloTypeList[skillType] or {}
				
				-- self.haloType = skillBaseInfo.type
				-- local attrAdd = GetAttrByString(skillInfo.attr_add)
				for i=1,17 do
					haloAttr[i] = haloAttr[i] or 0
					if skillInfo.attr_add[i+17] ~= nil and i <= EnumAttributeType.PoisonResistance then
						haloAttr[i+17] = haloAttr[i+17] or 0
						haloAttr[i+17] =  skillInfo.attr_add[i+17] + haloAttr[i+17]
					end

					if skillInfo.attr_add[i] ~= nil then
						haloAttr[i] = haloAttr[i] + skillInfo.attr_add[i]
					end
				end
				self.haloTypeList[skillType] = haloAttr
				for k,v in pairs(skillInfo.immune) do
					self.haloImmuneAttr[k] = self.haloImmuneAttr[k] or 0
					self.haloImmuneAttr[k] = self.haloImmuneAttr[k] + v
				end
				for k,v in pairs(skillInfo.effect_extra) do
					self.haloEffectExtraAttr[k] = self.haloEffectExtraAttr[k] or 0
					self.haloEffectExtraAttr[k] = self.haloEffectExtraAttr[k] + v
				end
				for k,v in pairs(skillInfo.be_effect_extra) do
					self.haloBeEffectExtraAttr[k] = self.haloBeEffectExtraAttr[k] or 0
					self.haloBeEffectExtraAttr[k] = self.haloBeEffectExtraAttr[k] + v
				end
				local effect = skillInfo.effect
				if (effect == EnumFightSpellEffect.effect_66) then
					--开场减对面恕气
					fightRoleMgr:AddAnger(not self.logicInfo.bEnemyRole, -skillInfo.effect_value)
				end
				if (EnumFightHaloEffect[effect]) then
					self.haloSkillEffectList[effect] = self.passiveSkill[i]
				end
			else
				for k,v in pairs(skillInfo.immune) do
					self.immuneAttr[k] = self.immuneAttr[k] or 0
					self.immuneAttr[k] = self.immuneAttr[k] + v
				end
			end
			if (skillInfo.effect == EnumFightSpellEffect.effect_69) then
				fightRoleMgr.addHpPercentRole[self.logicInfo.bEnemyRole] = fightRoleMgr.addHpPercentRole[self.logicInfo.bEnemyRole] + (skillInfo.effect_value / 100)
			end
		end
	end

	print("self.haloTypeList = " .."属性: ",self.haloTypeList)
	print("self.immuneAttr = " .."属性: ",displayAttributeString(self.immuneAttr))
	print("self.haloImmuneAttr = " .."属性: ",displayAttributeString(self.haloImmuneAttr))
	print("self.haloEffectExtraAttr = " .."属性: ",displayAttributeString(self.haloEffectExtraAttr))
	print("self.haloBeEffectExtraAttr = " .."属性: ",displayAttributeString(self.haloBeEffectExtraAttr))
end

--[[
验证状态是否为异常状态
]]
function FightRole:CalculateBufferTriggerRate(targetRole,levelInfo,baseInfo)
	if levelInfo == nil then
		return
	end
	if not baseInfo then
		baseInfo = FightManager:GetCacheSkillBaseInfo( levelInfo.id)
	end
	local bufferInfo = SkillBufferData:objectByID(levelInfo.buff_id)
	local bufRateSuppress = 0
	if bufferInfo and bufferInfo.good_buff == 0 then
		if FightManager.fightBeginInfo.fighttype == 5 then
			bufRateSuppress = ClimbManager:getBufRateSuppress( self.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole )*100
			-- print("无量山战力压制 buff增加几率 = ",bufRateSuppress)
		elseif FightManager.fightBeginInfo.fighttype == 16 then
			bufRateSuppress = NorthClimbManager:getBufRateSuppress( self.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole )*100
			-- print("无量山战力压制 buff增加几率 = ",bufRateSuppress)
		end
	end

	if baseInfo.buff_rate_addition and baseInfo.buff_rate_addition ~= "" then
		local addition_list = stringToNumberTable(baseInfo.buff_rate_addition,"_")
		if targetRole:GetBuffByType(addition_list[1]) then
			bufRateSuppress = addition_list[2] + bufRateSuppress
			-- print("针对特殊buff加成  = ",bufRateSuppress)
		end
	end

	local formula = baseInfo.buff_formula
	if formula == nil or formula == 0 then
		local result = levelInfo.buff_rate + bufRateSuppress
			-- print(" buff几率 = ",result)
		return result
	else
		--[[
		角色技能：封印技能添加受技能等级影响的命中率计算规则。
		封印技能命中率 = （1-（目标等级- 技能等级）* 0.1） * 基础命中率（表格配置） 
		其中：7≥(目标等级 - 技能等级）≥-20
		命中率：从 30%-100% 之间波动
		]]
		local tmp = (targetRole.logicInfo.level - levelInfo.level)
		tmp = math.min(7,tmp)
		tmp = math.max(-20,tmp)
		local result =(1 -  tmp * 0.1) * levelInfo.buff_rate + bufRateSuppress
			-- print(" buff几率 = ",result)
		return result
	end
end

--[[
验证状态是否为异常状态
]]
function FightRole:CalculateExtraBufferTriggerRate(targetRole,levelInfo,baseInfo)
	if levelInfo == nil then
		return
	end
	if not baseInfo then
		baseInfo = FightManager:GetCacheSkillBaseInfo( levelInfo.id)
	end
	local bufferInfo = SkillBufferData:objectByID(levelInfo.extra_buffid)
	
	local bufRateSuppress = 0
	if bufferInfo and bufferInfo.good_buff == 0 then
		if FightManager.fightBeginInfo.fighttype == 5 then
			bufRateSuppress = ClimbManager:getBufRateSuppress( self.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole )*100
			-- print("无量山战力压制 buff增加几率 = ",bufRateSuppress)
		elseif FightManager.fightBeginInfo.fighttype == 16 then
			bufRateSuppress = NorthClimbManager:getBufRateSuppress( self.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole )*100
			-- print("无量山战力压制 buff增加几率 = ",bufRateSuppress)
		end
	end

	-- if baseInfo.buff_rate_addition and baseInfo.buff_rate_addition ~= "" then
	-- 	local addition_list = stringToNumberTable(baseInfo.buff_rate_addition,"_")
	-- 	if targetRole:GetBuffByType(addition_list[1]) then
	-- 		bufRateSuppress = addition_list[2] + bufRateSuppress
			-- print("针对特殊buff加成  = ",bufRateSuppress)
	-- 	end
	-- end

	local formula = baseInfo.extra_buff_formula
	if formula == nil or formula == 0 then
		local result = levelInfo.extra_buff_rate + bufRateSuppress
			-- print(" buff几率 = ",result)
		return result
	else
		--[[
		角色技能：封印技能添加受技能等级影响的命中率计算规则。
		封印技能命中率 = （1-（目标等级- 技能等级）* 0.1） * 基础命中率（表格配置） 
		其中：7≥(目标等级 - 技能等级）≥-20
		命中率：从 30%-100% 之间波动
		]]
		local tmp = (targetRole.logicInfo.level - levelInfo.level)
		tmp = math.min(7,tmp)
		tmp = math.max(-20,tmp)
		local result =(1 -  tmp * 0.1) * levelInfo.extra_buff_rate + bufRateSuppress
			-- print(" buff几率 = ",result)
		return result
	end
end


function FightRole:GetTriggerExtraBufferID(skillID, targetRole)
	if self:GetBuffByType(10) ~= nil then
		return 0,0
	end
	attackImmune = self:getEffectExtraAttrNum(EnumFightAttributeType.Immune,EnumFightEffectType.FightEffectType_NoMianYi) or 0
	-- if FightManager.fightBeginInfo.bSkillShowFight then
	-- 	return 0 ,0
	-- end
	if skillID.skillId <= 0 then
		return 0,0
	end

	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
	if skillBaseInfo ~= nil and skillBaseInfo.target_sex == 1 then
		if self.sex == targetRole.sex then
			return 0 ,0
		end
	end

	local skillInfo = SkillLevelData:objectByID(skillID)
	local random = math.random(1, 10000)

	local rate = self:CalculateExtraBufferTriggerRate(targetRole,skillInfo,skillBaseInfo)

	-- print("-----------------------触发额外buff ,random = "..random.." rate = "..rate)
	if skillInfo ~= nil and skillInfo.extra_buffid > 0 and random <= rate then
		-- if targetRole.immuneAttribute then
		local bufferInfo = SkillBufferData:objectByID(skillInfo.extra_buffid)
		local immune = targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune,bufferInfo.type) + attackImmune
		if immune ~= nil and immune > 0 then
			local _random = math.random(1, 10000)
			if _random <= immune then
				targetRole:ShowEffectName("mianyi")
				return 0 ,0
			end
		end
		-- end
		return skillInfo.extra_buffid , skillInfo.level
	else
		return 0 ,0
	end
end

function FightRole:getskillInfoByDzxy(buff_id)
	local skillInfo = BaseDataManager:GetSkillBaseInfo(self.skillID)
	if skillInfo ~= nil then
		if skillInfo.buff_id == buff_id then
			return self.skillID
		end
	end
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		if self.passiveSkill[i].skillId ~= 0 then
			local _skillInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
			if _skillInfo.buff_id == buff_id then
				return self.passiveSkill[i]
			end
		end
	end
	return {skillId = 0 , level = 0}
end

function FightRole:GetTriggerBufferID(skillID, targetRole)
	if self:GetBuffByType(10) ~= nil then
		return 0,0
	end
	attackImmune = self:getEffectExtraAttrNum(EnumFightAttributeType.Immune,EnumFightEffectType.FightEffectType_NoMianYi) or 0
	if skillID.skillId > 0 then
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillBaseInfo ~= nil and skillBaseInfo.target_sex == 1 then
			if self.sex == targetRole.sex then
				return 0 ,0
			end
		end

		local skillInfo = SkillLevelData:objectByID(skillID)
		local random = math.random(1, 10000)
		if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bSkillShowFight then
			random = 0
		end

		local rate = self:CalculateBufferTriggerRate(targetRole,skillInfo,skillBaseInfo)

		if skillInfo ~= nil and skillInfo.buff_id > 0 and random <= rate then
			-- if targetRole.immuneAttribute then
			local bufferInfo = SkillBufferData:objectByID(skillInfo.buff_id)
			local immune = targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune,bufferInfo.type) + attackImmune
			if bufferInfo.good_buff == 0 and bufferInfo.no_rebound ~= 3 and immune ~= nil and immune > 0 then
				local _random = math.random(1, 10000)
				if _random <= immune then
					targetRole:ShowEffectName("mianyi")
					return 0 ,0
				end
			end
			-- end
			return skillInfo.buff_id , skillInfo.level
		else
			return 0 ,0
		end
	else
		if self:isCanNotTriggerBeiDong() then  --不触发被动buff
			return 0,0
		end
		local passiveSkillNum = #self.passiveSkill
		for i=1,passiveSkillNum do
			if self.passiveSkill[i].skillId ~= 0 then
				local bValidTarget = true
				local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
				if skillBaseInfo.hidden_skill == 1 or skillBaseInfo.hidden_skill == 2 or skillBaseInfo.hidden_skill == 3 then
					bValidTarget = false
				end
				
				--出手方排除触发借尸伏毒80
				local effect_filter_list = 
				{EnumFightFilterEffectType.effect_23,EnumFightFilterEffectType.effect_25,					
				EnumFightFilterEffectType.effect_55,EnumFightFilterEffectType.effect_57, 						
				EnumFightFilterEffectType.effect_37,EnumFightFilterEffectType.effect_80}

				for k,v in pairs(effect_filter_list) do
					if skillBaseInfo.effect == v then
						bValidTarget = false
						break
					end
				end
				if skillBaseInfo ~= nil and skillBaseInfo.target_sex == 1 then
					if self.sex == targetRole.sex then
						bValidTarget = false
					end
				end

				if bValidTarget then
					local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
					local random = math.random(1, 10000)
					local rate = self:CalculateBufferTriggerRate(targetRole,skillInfo,skillBaseInfo)
					-- print("使用技能 "..skillBaseInfo.name.."触发buff  id == "..skillInfo.buff_id)
					-- print("random ==  "..random.." ,rate == "..rate)
					if skillInfo ~= nil and skillInfo.buff_id > 0 and random <= rate then
						-- if targetRole.immuneAttribute then
						local bufferInfo = SkillBufferData:objectByID(skillInfo.buff_id)
						local immune = targetRole:getEffectExtraAttrNum(EnumFightAttributeType.Immune,bufferInfo.type) + attackImmune
						-- print("targetRole.immuneAttribute[bufferInfo.type] = ",bufferInfo.type,immune)
						if bufferInfo.good_buff == 0 and immune ~= nil and immune > 0 then
							local _random = math.random(1, 10000)
							if _random <= immune then
								targetRole:ShowEffectName("mianyi")
								return 0 ,0
							end
						end
						-- end
						return skillInfo.buff_id ,skillInfo.level
					end
				end
			end
		end
		return 0 ,0
	end
end

--是否触发被动效果：反弹5 反击6 化解7 复活9 免疫12 移魂13
function FightRole:TriggerPassiveEffect(passiveEffect, effectValue , immune)
	immune = immune or 0
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end
	if passiveEffect == 5 then
		local fantanBuff = self:GetBuffByType(19)
		if fantanBuff ~= nil then
			effectValue.value = fantanBuff.config.value
			return true
		end
	
	elseif passiveEffect == 6 then
		-- if self:GetBuffByType(10) ~= nil then
		-- 	return false
		-- end
		if FightManager:GetCurrAction() ~= nil and FightManager:GetCurrAction().actionInfo.bBackAttack then
			return false
		end
	end

	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		if skillInfo ~= nil and skillInfo.type == 7 and skillInfo.effect == passiveEffect then
			local random = math.random(1, 10000)

			if (passiveEffect == EnumFightSpellEffect.effect_85) then
				local triggerHp = math.floor(self.maxhp * skillInfo.effect_rate / 10000)
				if (self.currHp >= triggerHp) then
					if effectValue ~= nil then
						effectValue.value = math.floor(self.maxhp * skillInfo.effect_value / 100)
					end
					return true
				end
			elseif random <= skillInfo.effect_rate + immune then
				if effectValue ~= nil then
					effectValue.value = skillInfo.effect_value
				end

				local bTrigger = true
				if skillInfo.trigger_hp > 0 and self.currHp/self.maxhp > skillInfo.trigger_hp/100 then
					bTrigger = false
				else
					if passiveEffect == 13 then
						effectValue.value = skillInfo.attr_add
					end
				end

				if bTrigger then
					return true
				end
			end
		end
	end

	return false
end


--是否触发被动效果：反弹5 反击6 化解7 复活9 免疫12 移魂13
function FightRole:TriggerBeHitPassiveEffect(passiveEffect, effectValue)
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end

	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.type == 7 and skillBaseInfo.effect == passiveEffect then
			local random = self.beHurtNum
			if random >= skillInfo.effect_rate then
				if effectValue ~= nil then
					effectValue.value = skillInfo.effect_value
					effectValue.skillId = self.passiveSkill[i]
				end
				-- self.beHurtNum = 0
				return true
			end
		end
	end

	return false
end

function FightRole:TrigerHurtMianyiEffect( passiveEffect, effectValue )
	if (EnumFightSpellEffect.effect_37 == passiveEffect or passiveEffect == EnumFightSpellEffect.effect_82) then
		if self:isCanNotTriggerBeiDong() then  --不触发被动buff
			return false
		end
	end
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil then
			if skillInfo.effect == passiveEffect and passiveEffect == EnumFightSpellEffect.effect_82 then
				if (self:TriggerSkillIdCount(skillInfo.id, skillInfo.special_num)) then
					effectValue.triggerSkillId = skillInfo.id
					effectValue.value = skillInfo.effect_value
					return true
				end
			elseif  skillInfo.effect == passiveEffect then
				self.specialSkillTime = self.specialSkillTime or 0
				self._specialSkillTime = self._specialSkillTime or 0
				if self.specialSkillTime + self._specialSkillTime >= skillInfo.special_num then
					return false
				end
				-- self.specialSkillTime = self.specialSkillTime + 1
				effectValue.value = self.logicInfo.posindex
				effectValue.buff_id = skillInfo.buff_id
				effectValue.level = skillInfo.level
				return true
			elseif skillInfo.trigger_hurtType == 7 then
				local tempSkill = {skillId = skillInfo.triggerSkill ,level = self.passiveSkill[i].level}
				local _skillInfo = SkillLevelData:objectByID(tempSkill)
				-- local _skillBaseInfo = BaseDataManager:GetSkillBaseInfo(tempSkill)
				if  _skillInfo and _skillInfo.effect == passiveEffect then
					self.specialSkillTime = self.specialSkillTime or 0
					self._specialSkillTime = self._specialSkillTime or 0
					if self.specialSkillTime + self._specialSkillTime >= skillInfo.special_num then
						return false
					end
					-- self.specialSkillTime = self.specialSkillTime + 1
					effectValue.value = self.logicInfo.posindex
					effectValue.level = _skillInfo.level
					effectValue.buff_id = _skillInfo.buff_id
					return true
				end
			end
		end
	end
	return false
end

function FightRole:TrigerHurtMianyiSkill( passiveEffect, effectValue )
	if (self:IsSummoned()) then
		return false
	end
	if ((EnumFightPassiveEffectType.effect_37 == passiveEffect or EnumFightPassiveEffectType.effect_82 == passiveEffect)) then
		return false
	end
	
	local liveList = fightRoleMgr:GetAllLiveRole(self.logicInfo.bEnemyRole)
	-- local liveNum = liveList:length()
	local sortfunc = function( role1,role2 )
		return role1:GetAttrNum(EnumAttributeType.Agility) > role2:GetAttrNum(EnumAttributeType.Agility)
	end
	liveList:sort(sortfunc)
	-- for i=1,liveNum do
	-- 	local role = liveList:objectAt(i)
	for role in liveList:iterator() do
		if role and role:IsAlive() and role:TrigerHurtMianyiEffect(passiveEffect , effectValue) then
			effectValue.targetRole = role
			return true
		end
	end
	return false
end

function FightRole:getTrigerHurtMianyiEffectSkillId( passiveEffect )
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillBaseInfo ~= nil  then
			if  skillBaseInfo.effect == passiveEffect then
				return skillInfo
			elseif skillInfo.trigger_hurtType == 7 then
				local tempSkill = {skillId = skillInfo.triggerSkill ,level = self.passiveSkill[i].level}
				local _skillInfo = SkillLevelData:objectByID(tempSkill)
				local _skillBaseInfo = BaseDataManager:GetSkillBaseInfo(tempSkill)
				if  _skillInfo and _skillBaseInfo and _skillBaseInfo.effect == passiveEffect then
					return _skillInfo
				end
			end
		end
	end
	return nil
end


function FightRole:TrigerXianTianGongSkill(passiveEffect, effectValue)
	if passiveEffect ~= 25 then
		return false
	end
	if self.haveXianTianGong >= 2 then
		return false
	end
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end
	
	if self:GetBuffByType(56) then
		return false
	end
	
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo and skillBaseInfo and skillBaseInfo.effect == 25 then
			local effect_rate = skillInfo.effect_rate
			if self.haveXianTianGong == 0 then
				effect_rate = 10000
			end
			local random = math.random(1,10000)
			if random <= effect_rate then
				if effectValue ~= nil then
					effectValue.value = skillInfo.effect_value
				end
				effectValue.level = skillInfo.level
				return true
			end
		end
	end

	return false
end



--是否触发被动效果：闪避1，被击打2 , 3治疗
function FightRole:TriggerBeHurtUseSkill(hurtType, effectValue)	
	-- print("------------TriggerBeHurtUseSkill------")
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end
	if FightManager:GetCurrAction() ~= nil and FightManager:GetCurrAction().actionInfo.bBackAttack then
		return false
	end
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.type == 7 and skillBaseInfo.trigger_hurtType == hurtType then
			local random = math.random(1, 10000)
			if random <= skillInfo.triggerSkill_rate then
				effectValue.skillId = skillInfo.triggerSkill
				effectValue.level 	= skillInfo.level
				-- effectValue = {skillId = skillInfo.triggerSkill,level = skillInfo.level}
				-- print("触发 技能 ",effectValue)
				return true
			end
		end
	end
	return false
end
--是否触发被动效果：被击打次数
function FightRole:TriggerBeHitUseSkill(hurtType, effectValue)	
	-- print("------------TriggerBeHurtUseSkill------")
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end
	if FightManager:GetCurrAction() ~= nil and FightManager:GetCurrAction().actionInfo.bBackAttack then
		return false
	end
	local random 			= self.beHurtNum + 1
	local passiveSkillNum 	= #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo 	= SkillLevelData:objectByID(self.passiveSkill[i])
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.type == 7 and skillBaseInfo.trigger_hurtType == hurtType then
			
			if random >= skillInfo.triggerSkill_rate then
				if (hurtType == EnumFightTriggerHurtType.type_15) then
					local beHurtNum = math.mod(random , skillInfo.triggerSkill_rate)
					if (random > 0 and beHurtNum == 0) then
						effectValue.skillId = skillInfo.triggerSkill
						effectValue.level 	= skillInfo.level
						print("触发 技能 ",effectValue)
						return true
					end
					return false
				end
				effectValue.skillId = skillInfo.triggerSkill
				effectValue.level 	= skillInfo.level
				-- effectValue = {skillId = skillInfo.triggerSkill,level = skillInfo.level}
				print("触发 技能 ",effectValue)
				return true
			end
		end
	end
	--
	return false
end


--是否触发被动效果：被攻击次数 N
function FightRole:TriggerTeamAttackSkill(effectValue)	
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end
	for i, skillID in ipairs (self.passiveSkill) do
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo ~= nil and skillInfo ~= nil and skillInfo.type == 7 then
			if skillInfo.trigger_hurtType == 10 or skillInfo.trigger_hurtType == 11 then
				self.teamAttackNum = self.teamAttackNum or 0
				local bEnemyRole = self.logicInfo.bEnemyRole
				if skillInfo.trigger_hurtType == 11 then
					bEnemyRole = not self.logicInfo.bEnemyRole
				end
				local attackNum = fightRoleMgr:getTeamAttackNum(bEnemyRole)
				-- local str = "left"
				-- if (bEnemyRole) then
				-- 	str = "right"
				-- end
				-- str = str .. "  "..attackNum.." >= "..(self.teamAttackNum + skillInfo.triggerSkill_rate)
				-- toastMessage(str)
				if attackNum >= self.teamAttackNum + skillInfo.triggerSkill_rate then
					effectValue.skillId = skillInfo.triggerSkill
					effectValue.level = skillInfo.level
					self.teamAttackNum = attackNum
					return true
				end
			end
		end
	end
	return false
end

function FightRole:getPetAttackTime()
	if (not self.ispet) then
		return 0
	end
	for i, skillID in ipairs (self.passiveSkill) do
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo ~= nil and skillInfo.type == 7 then
			if skillInfo.trigger_hurtType == 10 or skillInfo.trigger_hurtType == 11 then
				self.teamAttackNum = self.teamAttackNum or 0
				local bEnemyRole = self.logicInfo.bEnemyRole
				if skillInfo.trigger_hurtType == 11 then
					bEnemyRole = not self.logicInfo.bEnemyRole
				end
				local attackNum = fightRoleMgr:getTeamAttackNum(bEnemyRole)
				local passTime = attackNum - self.teamAttackNum
				local percent = passTime/skillInfo.triggerSkill_rate *100
				percent = math.min(100,percent)
				return percent
			end
		end
	end
	return 0
end

function FightRole:getSkillByEffect( effect )
	for i, skillID in ipairs (self.passiveSkill) do
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo ~= nil and skillInfo.type == 7 and skillInfo.effect == effect then
			return skillID
		end
	end
	return {skillId = 0,level = 0}
end


--是否触发无概率的主动效果：吸怒1 减敌怒2 增己怒3 吸血4 侧击8 净化10 致死11 重击14
function FightRole:TriggerNoRateActiveEffect(skillID, activeEffect, effectValue)
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end
	if self:GetBuffByType(10) ~= nil then
		return false
	end
	if skillID.skillId > 0 then
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo ~= nil and skillInfo.type ~= 9 and skillInfo.effect == activeEffect then
			if effectValue ~= nil then
				effectValue.value = skillInfo.effect_value
			end
			-- print(self.logicInfo.name.."TriggerActiveEffect:"..activeEffect)
			return true
		end
	end
	return false
end

--是否触发主动效果：追加一次主动
function FightRole:TriggerActiveAddSkillEffect(skillID, hurtType, effectValue)
	if self:GetBuffByType(10) ~= nil then
		return false
	end
	--
	if skillID.skillId > 0 then
		local skillInfo 	= SkillLevelData:objectByID(skillID)
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		
		if skillInfo ~= nil and skillInfo.trigger_hurtType == hurtType then
			local random = math.random(1, 10000)
			if random <= skillInfo.triggerSkill_rate then
				local tempId = skillInfo.triggerSkill
				effectValue.skillId = tempId
				effectValue.level 	= skillInfo.level
				if (hurtType == EnumFightTriggerHurtType.type_22) then
					if (skillInfo.id == self.skillID.skillId) then
						--玄冥道人追加初始化
						self:addTriggerSkillCount(tempId, 0, 0)
					else
						-- toastMessage("BB  -> "..self:getTriggerSkillCountBySkill(tempId))		
						if (self:getTriggerSkillCountBySkill(tempId) >= skillInfo.effect_value) then
							effectValue = {}
							return false
						end
					end
				else
					local buffInfo = self:GetBuffByType(EnumFightBufferType.type_94)
					if (buffInfo) then
						local useNum = buffInfo.lastNum or 0
						--计算追加时BUFF次数没有减去
						useNum = useNum + 1
						if useNum >= buffInfo.config.last_num then

						else
							local skillInfo_1 	= FightManager:GetCacheSkillBaseInfo(tempId)
							effectValue.skillId = skillInfo_1.replace_skill_id
							print("追加一次主动技能 ",skillInfo.triggerSkill)
							return true
						end
					end	
				end
				return true
			else
				return false
			end
		end
	end
end
--是否触发主动效果：吸怒1 减敌怒2 增己怒3 吸血4 侧击8 净化10 致死11 重击14
function FightRole:TriggerActiveEffect(skillID, activeEffect, effectValue)

	if self:GetBuffByType(10) ~= nil then
		return false
	end
	if skillID.skillId > 0 then
		local skillInfo = SkillLevelData:objectByID(skillID)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.type ~= 9 and skillBaseInfo.effect == activeEffect then
			local random = math.random(1, 10000)
			if random <= skillInfo.effect_rate then
				if effectValue ~= nil then
					effectValue.value = skillInfo.effect_value
					if activeEffect == 31 or activeEffect == EnumFightSpellEffect.effect_65 or activeEffect == EnumFightSpellEffect.effect_77 then
						effectValue.value = tonumber(skillBaseInfo.effect_value)
					end
				end
				-- print(self.logicInfo.name.."TriggerActiveEffect:"..activeEffect)
				return true
			else
				return false
			end
		end
	else
		if self:isCanNotTriggerBeiDong() then  --不触发被动buff
			return false
		end
		local passiveSkillNum = #self.passiveSkill
		for i=1,passiveSkillNum do
			local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
			local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
			if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.type == 7 and skillBaseInfo.hidden_skill ~= 1 and skillBaseInfo.effect == activeEffect then
				local random = math.random(1, 10000)
				-- print("主动效果 random == "..random.."  ,skillInfo.effect_rate =="..skillInfo.effect_rate )
				if random <= skillInfo.effect_rate then
					if effectValue ~= nil then
						effectValue.value = skillInfo.effect_value
						if activeEffect == 31 or activeEffect == EnumFightSpellEffect.effect_65 or activeEffect == EnumFightSpellEffect.effect_77 then
							effectValue.value = tonumber(skillBaseInfo.effect_value)
						end
					end
					-- print(self.logicInfo.name.."TriggerActiveEffect:"..activeEffect)
					return true
				end
			end
		end
	end
	return false
end

function FightRole:TriggerActiveZhanShaEffect(skillID, effectValue ,random ,immune)
	if self:GetBuffByType(10) ~= nil then
		return 0
	end
	if skillID.skillId > 0 then
		local skillInfo = SkillLevelData:objectByID(skillID)
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo ~= nil and skillInfo ~= nil and skillInfo.effect == 26 then
			if effectValue ~= nil then
				effectValue.value = skillInfo.effect_value
			end
			-- local immune = 
			if immune and immune > 0 then
				local _random = math.random(1, 10000)
				if _random <= immune then
					return 21
				end
			end
			if random <= skillInfo.effect_rate then
				return 26
			else
				return 21
			end
		end
	end
	return 0
end


--是否触发主动效果：吸怒1 减敌怒2 增己怒3 吸血4 侧击8 净化10 致死11 重击14
function FightRole:SkillTriggerActiveEffect(skillID, activeEffect, effectValue)
	if self:GetBuffByType(10) ~= nil then
		return false
	end
	if skillID.skillId > 0 then
		local skillInfo = SkillLevelData:objectByID(skillID)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.effect == activeEffect then
			local random = math.random(1, 10000)
			if random <= skillInfo.effect_rate then
				if effectValue ~= nil then
					effectValue.value = skillInfo.effect_value
				end
				return true
			else
				return false
			end
		end
	end
	return false
end

--是否对中buff目标伤害加成
function FightRole:TriggerBuffHurt(targetRole, skillID, effectValue)
	if self:GetBuffByType(10) ~= nil then
		return 0
	end
	if skillID.skillId > 0 then
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo ~= nil and skillInfo.buff_hurt > 0 then
			if targetRole:GetBuffByType(skillInfo.buff_hurt) ~= nil then
				if effectValue ~= nil then
					effectValue.value = skillInfo.effect_value
				end
				return skillInfo.buff_hurt
			else
				return 0
			end
		end
	else
		local passiveSkillNum = #self.passiveSkill
		for i=1,passiveSkillNum do
			local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
			if skillInfo ~= nil and skillInfo.effect ~= 6 and skillInfo.buff_hurt > 0 then
				if  targetRole:GetBuffByType(skillInfo.buff_hurt) ~= nil then
					if effectValue ~= nil then
						effectValue.value = skillInfo.effect_value
					end
					return skillInfo.buff_hurt
				else
					return 0
				end
			end
		end
	end
	return 0
end

--是否对中buff目标伤害加成
function FightRole:TriggerBuffHurtBackAttack(targetRole, effectValue)
	if self:GetBuffByType(10) ~= nil then
		return 0
	end
	
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		if skillInfo ~= nil and skillInfo.buff_hurt > 0 then
			if  targetRole:GetBuffByType(skillInfo.buff_hurt) ~= nil then
				if effectValue ~= nil then
					effectValue.value = skillInfo.effect_value
				end
				return skillInfo.buff_hurt
			else
				return 0
			end
		end
	end
	return 0
end

function FightRole:GetAttrNum(attrIndex)
	local attrNum = self.logicInfo.attr[attrIndex]
	if attrNum == nil then
		return 0
	end
	if self.ispet then
		return attrNum
	end

	attrNum = attrNum + fightRoleMgr:GetTotalHaloAttrAdd(self.logicInfo.bEnemyRole, attrIndex)
	local attrPercent = 0
	if attrIndex < EnumAttributeType.PoisonResistance then
		attrPercent = fightRoleMgr:GetTotalHaloAttrAdd(self.logicInfo.bEnemyRole, attrIndex+17)
	end
	attrNum = math.max(0, attrNum)

	local percent = attrPercent/100
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buff = self.buffList:objectAt(i)
	for buff in self.buffList:iterator() do
		if buff.bValid and buff.config.attr_change ~= "0" and buff.config.attr_change ~= "" then
			local valueInfo = GetAttrByString(buff.config.attr_change)

			local fightEffectValue = 0
			if buff.config.good_buff == 1 then
				fightEffectValue = buff.fromTarget:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_GoodAttr) +
					self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_GoodAttr)
			else
				fightEffectValue = buff.fromTarget:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_BadAttr) +
					self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BadAttr)
			end
			fightEffectValue = fightEffectValue/10000+1
			fightEffectValue = math.max(0,fightEffectValue)

			if valueInfo[17+attrIndex] ~= nil then
				percent = valueInfo[17+attrIndex] *fightEffectValue + percent
			end

			if valueInfo[attrIndex] ~= nil then
				attrNum = attrNum + valueInfo[attrIndex] *fightEffectValue
			end
		end
	end
	-- if percent ~= 0 then
	-- 	print(self.logicInfo.name.."属性"..AttributeTypeStr[attrIndex].."固定值 ="..attrNum..", 百分比*100为.."..percent)
	-- end
	attrNum = attrNum + math.floor(attrNum * percent / 100)

	if self.passiveSkillAttrAdd ~= nil then
		local valueInfo = self.passiveSkillAttrAdd--GetAttrByString(self.passiveSkillAttrAdd)
		if valueInfo[17+attrIndex] ~= nil then
			attrNum = attrNum + math.floor(attrNum * valueInfo[17+attrIndex] / 10000)
		end

		if valueInfo[attrIndex] ~= nil then
			attrNum = attrNum + valueInfo[attrIndex]
		end
	end

	attrNum = math.max(0, attrNum)
	return attrNum
end

--attackRole别瞎传，死循环了解一下
function FightRole:getEffectExtraAttrNum(AttrType, attrIndex, attackRole)
	local attrNum = 0
	if AttrType == EnumFightAttributeType.Immune then
		attrNum = self.immuneAttribute[attrIndex] or 0
		attrNum = attrNum + (self.immuneAttr[attrIndex] or 0)
	elseif AttrType == EnumFightAttributeType.Effect_extra then
		attrNum = self.effectExtraAttribute[attrIndex] or 0
	elseif AttrType == EnumFightAttributeType.Be_effect_extra then
		attrNum = self.beEffectExtraAttribute[attrIndex] or 0
	elseif AttrType == EnumFightAttributeType.Xinfa_effect then
		attrNum = self.effectExtraAttribute[attrIndex] or 0
		return attrNum
	end
	-- print(self.logicInfo.name.."\n--------减伤----  attrIndex: "..attrIndex.."------\n")
	-- print("基础属性:  ",attrNum)
	attrNum = attrNum + fightRoleMgr:GetTotalHaloEffectAttrAdd(AttrType,self.logicInfo.bEnemyRole, attrIndex)
	
	-- print("光环增加后属性:  ",attrNum)
	-- attrNum = math.max(0, attrNum)

	local percent = 0
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buff = self.buffList:objectAt(i)
	for buff in self.buffList:iterator() do
		if buff.bValid then
			local buff_addEffect = {}
			-- print("buff.config = ",buff.config)
			if AttrType == EnumFightAttributeType.Immune then
				buff_addEffect = buff.config.immune
			elseif AttrType == EnumFightAttributeType.Effect_extra then
				buff_addEffect = buff.config.effect_extra
			elseif AttrType == EnumFightAttributeType.Be_effect_extra then
				buff_addEffect = buff.config.be_effect_extra
			end
			if buff_addEffect[attrIndex] ~= nil then
				attrNum = attrNum + buff_addEffect[attrIndex]
				-- print(buff.config.id.."   BUFF 加成 属性 "..attrIndex.." :  "..attrNum)
			end
		end
	end
	-- print("BUFF加成后属性:  ",attrNum)
	if (attrIndex == EnumFightEffectType.FightEffectType_HurtGain and attackRole) then
		-- if (self ~= attackRole) then
			local attackRoleAttr = attackRole:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra, EnumFightEffectType.FightEffectType_DotNoHurt)
			attrNum = attackRoleAttr + attrNum
			attrNum = math.min(0, attrNum)
			-- print("无视免伤属性: "..attackRoleAttr)
		-- end
	end
	return attrNum
end

function FightRole:GetSkillAnger()
	local skillInfo = BaseDataManager:GetSkillBaseInfo(self.skillID)
	if skillInfo ~= nil then
		if (skillInfo.hidden_skill == 3)then
			if(self:isConsumptionAngerManual()) then 
				return 0
			end
		elseif (self:isConsumptionManual()) then
			return 0
		end

		local buff_add = 0
		-- local buff = self:GetBuffByType(76)
		local buffList = self:GetBuffListByType({EnumFightBufferType.type_76, EnumFightBufferType.type_519})
		if (buffList[EnumFightBufferType.type_76]) then
			buff_add = buffList[EnumFightBufferType.type_76].config.value
		end
		if (buffList[EnumFightBufferType.type_519]) then
			buff_add = buff_add - buffList[EnumFightBufferType.type_519].config.value
		end
		
		return skillInfo.trigger_anger  + self.extAnger + buff_add
	else
		return 0
	end 
end

--主动技能类型：1 攻击 2治疗 3净化
function FightRole:GetActiveSkillType()
	local skillInfo = BaseDataManager:GetSkillBaseInfo(self.skillID)
	if skillInfo ~= nil then
		return skillInfo.type
	else
		return 0
	end 
end

--主动技能目标类型：1 单体 2全屏 3横排贯穿 4竖排穿刺
function FightRole:GetActiveSkillTargetType()
	local skillInfo = BaseDataManager:GetSkillBaseInfo(self.skillID)
	if skillInfo ~= nil then
		return skillInfo.target_type
	else
		return 0
	end 
end

function FightRole:CanReleaseManualSkill()
	if self:IsLive() == false or self.skillID.skillId == 0 then
		return false
	end

	if fightRoundMgr:IsRoleHaveManualAction(self) then
		return false
	end

	if self:HaveForbidManualSkillBuff() then
		return false
	end
	if (self:isConsumptionManual()) then
		return true
	end
	if self.skillCD > 0 then
		return false
	end

	local skillAnger = self:GetSkillAnger()
	local totalAnger = fightRoleMgr:GetAnger(self.logicInfo.bEnemyRole)
	if totalAnger < skillAnger then
		return false
	end

	return true
end

function FightRole:CanReleaseAngerManualSkill()
	if self:IsLive() == false then
		return false
	end

	if self:HaveForbidManualSkillBuff() then
		return false
	end
	local skillInfo = self:getUseSelfAngerSkill()
	if skillInfo == nil then
		return false
	end

	if fightRoundMgr:IsRoleHaveAngerManualAction(self) then
		return false
	end
	if (self:isConsumptionAngerManual()) then
		return true
	end
	if self.role_anger < skillInfo.trigger_anger then
		return false
	end
	if self.angerSkillCD > 0 then
		return false
	end

	return true
end

function FightRole:GetSkillCD()
	local skillInfo = BaseDataManager:GetSkillBaseInfo(self.skillID)
	if skillInfo ~= nil and skillInfo.cool_time ~= nil then
		local addTime = self:getEffectExtraAttrNum(EnumFightAttributeType.Xinfa_effect, EnumXinFaSpecialType.XinFaSpecialType_SillCD)
		if (addTime and addTime > 0) then
			addTime = skillInfo.cool_time - math.floor(skillInfo.cool_time * addTime / 10000)
			if (addTime > 0) then
				return addTime
			end
		end
		return skillInfo.cool_time
	else
		return 10000
	end 
end

function FightRole:GetNormalSkill()
	if self:isCanNotTriggerBeiDong() then
		return {skillId = 0,level = 0}
	end
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillId = self.passiveSkill[i]
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillId)
		if skillBaseInfo ~= nil and skillBaseInfo.hidden_skill == 1 then --暗器类技能
			local random = math.random(1, 10000)
			if random <= skillBaseInfo.trigger_rate then
				return skillId
			end
		end
	end

	return {skillId = 0,level = 0}
end
function FightRole:getPermanentBufSkill()
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillId = self.passiveSkill[i]
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillId)
		if skillBaseInfo ~= nil and skillBaseInfo.hidden_skill == 2 then --开场buf
			return skillBaseInfo
		end
	end

	return nil
end

function FightRole:getUseSelfAngerSkill()
	-- local passiveSkillNum = #self.passiveSkill
	-- for i=1,passiveSkillNum do
	-- 	local skillId = self.passiveSkill[i]
	for i,skillId in ipairs(self.passiveSkill) do
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillId)
		if skillBaseInfo ~= nil and skillBaseInfo.hidden_skill == 3 then --红色侠客怒气
			local skillInfo = self:getBuffSkill(skillBaseInfo)
			return skillInfo ,skillId.level
		end
	end

	return nil
end

--
function FightRole:getUseSelfSkill()
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.skillID)
	if skillBaseInfo ~= nil then
		local skillInfo = self:getBuffSkill(skillBaseInfo)
		return skillInfo ,self.skillID.level
	end
	return nil
end

--风华饮月（风怒）
function FightRole:getBuffSkill(skillBaseInfo, skill, skillId)

	local bufferNum = self.buffList:length()
	local buffTypeList = {EnumFightBufferType.type_94, EnumFightBufferType.type_519}
	local buffList = self:GetBuffListByType(buffTypeList)
	buffInfo = buffList[EnumFightBufferType.type_94] or buffList[EnumFightBufferType.type_519]
	if (buffInfo == nil) then
		return skillBaseInfo
	end
	if (skillBaseInfo) then
		if (skillBaseInfo.replace_skill_id and skillBaseInfo.replace_skill_id ~= 0) then
			local skillInfo = FightManager:GetCacheSkillBaseInfo(skillBaseInfo.replace_skill_id)
			if (skillInfo) then
				print(skillBaseInfo.id,'  转换 ',skillInfo.id, " - ",skillInfo.name)
				return skillInfo
			end 
		end
		return skillBaseInfo
	end
	if (skill) then
		local skillInfo = SkillLevelData:objectByID(skill)
		if (skillInfo) then
			return skillInfo
		end
	end 
	if (skillId) then
		local skillInfo = FightManager:GetCacheSkillBaseInfo(skillId)
		if (skillInfo) then
			return skillInfo
		end
	end
	return skillBaseInfo
end

function FightRole:addRoleAnger( anger )
	if anger >= 0 and self:GetBuffByType(16) ~= nil then
		return
	end
	if anger == nil or anger == 0 or self.role_angerMax == 0 then
		return
	end 
	self.role_anger = self.role_anger + anger
	self.role_anger = math.min(self.role_anger,self.role_angerMax)
--	print(self.logicInfo.name .."self.role_anger = ",self.role_anger,anger)
	if self.angerLabel then
		self.angerLabel:setPercent(self.role_anger/self.role_angerMax*100)
	end
end

function FightRole:AddOtherAnger(num)
	if self:GetBuffByType(16) ~= nil then
		fightRoleMgr:AddAnger(self.logicInfo.bEnemyRole, 0)
		return 0
	end

	if num == nil or num == 0 then
		return 0
	end
	-- self:addRoleAnger( num )
	return num
end


function FightRole:OnActionStart()
	if self:IsLive() then
		if self.hitBackTween then
			TFDirector:killTween(self.hitBackTween)
			self.hitBackTween = nil
		end

		--目标原地被反击
		if FightManager:GetCurrAction().actionInfo.bBackAttack then
			local targetRole = FightManager:GetCurrAction():GetTargetRole(1)
			if targetRole == self then
				print(self.logicInfo.name.."target role is myself. return....")
				return
			end
		end
		self:setPosition(self.originPos)
		self:UpdateZOrder()

		-- self:permanentBufSkill()
	end
end

function FightRole:OnAddPermanentBuf()
	local permanentBufSkill = self:getPermanentBufSkill()
	if self:IsLive() and permanentBufSkill and permanentBufSkill.buff_id ~= 0 then
		local buff_id = permanentBufSkill.buff_id
		local bufferInfo = SkillLevelData:findBuffInfo( buff_id , permanentBufSkill.level )
		if bufferInfo then
			if self:GetBuffByType(bufferInfo.type) == nil then
				if self:AddBuff(self, buff_id, permanentBufSkill.level, 0) then
					fightRoundMgr:AddPermanentBuf(self,self,{skillid = permanentBufSkill.id, level = permanentBufSkill.level},buff_id,0)
				end
			end
		end
	end
	local isFuMoLu = false --伏魔录boss
	if FightManager.fightBeginInfo then
		if FightManager.fightBeginInfo.fighttype == 10 or FightManager.fightBeginInfo.fighttype == 28 then
			isFuMoLu = true
		end
	end
	if self:IsLive() and FightManager.isReplayFight == false then
		if (not isFuMoLu) then
			local buff_type_list1 = {EnumFightBufferType.type_33, EnumFightBufferType.type_62, EnumFightBufferType.type_69, EnumFightBufferType.type_508}  --不死不休和周芷若的buff
			local buffTypeList = self:GetBuffListByType(buff_type_list1)
			for i,buffTypeId in ipairs(buff_type_list1) do
				local buSiBuXiu = buffTypeList[buffTypeId]
				if buSiBuXiu then
					local bufferInfo = SkillBufferData:objectByID(tonumber(buSiBuXiu.config.value))
					fightRoundMgr:hasOrGiveBuff(buSiBuXiu.config.id,bufferInfo ,self )
				end
			end
		end
		--给对方上BUFF
		local buff_type_list = {EnumFightBufferType.type_92, EnumFightBufferType.type_506, EnumFightBufferType.type_517} --92:东方不败BUFF
		for i=1,#buff_type_list do
			local haveBuff = self:GetBuffByType(buff_type_list[i])
			if haveBuff then
				local bufferInfo = SkillBufferData:objectByID(tonumber(haveBuff.config.value))
				fightRoundMgr:hasOrGiveBuff(haveBuff.config.id,bufferInfo ,self )
			end
		end
		--给已方上BUFF
		for haveBuffId,buffId in pairs(EnumFightTeammateBuff) do
			local haveBuff = self:GetBuffByType(haveBuffId)
			if (haveBuff) then
				local bufferInfo = SkillBufferData:objectByID(tonumber(haveBuff.config.value))
				fightRoundMgr:hasOrGiveBuff(haveBuff.config.id, bufferInfo, self, true)
			end
		end
	end

end

function FightRole:fuHuoActionEnd()
	-- TFDirector:currentScene():ZoomOut()
	if self.armature == nil then
		return
	end
	self:RemoveAllBuff()
	self:PlayStandAnim()
	self.rolePanel:setVisible(true)
	self.armature:setColor(ccc3(255, 255, 255))
	self.rolePanel:setOpacity(255)

	-- self.originPos = mapLayer.GetPosByIndex(self.logicInfo.posIndex)
	self:setPosition(self.originPos)
	self:UpdateZOrder()
end

function FightRole:ReturnBack()
	TFDirector:currentScene():ZoomOut()
	
	if self.armature == nil then
		return
	end

	if not self:IsLive() then
		FightManager:OnActionEnd()
	end

	local currPos = self:getPosition()
	local eq = (self.originPos.x == currPos.x and self.originPos.y == currPos.y)
	if eq or FightManager:HaveBackAttackAction() then
		print(self.logicInfo.name.."return fail")
		self:PlayStandAnim()
		FightManager:OnActionEnd()
		return
	end
	print(self.logicInfo.name.."return true")

	local pathType = 0
	-- local randNum = math.random(0, 100)
	-- if math.abs(currPos.y - self.originPos.y) < 10 and randNum < 30 then
	-- 	pathType = 1
	-- end

	if self.hitBackTween then
		TFDirector:killTween(self.hitBackTween)
		self.hitBackTween = nil
	end

	self.attackAnimEnd = true


	local animName = "back"
	if self.directional_sensitivity then
		if not bEnemyRole then
			animName = animName.."l"
		else
			animName = animName.."r"
		end
	end

	self.armature:play(animName)
	if self.bossEffect then
		self.bossEffect:setVisible(false)
	end

	if pathType == 0 then
		local returnBackLine = 
		{
			target = self.rolePanel,
			{
				ease = {type=TFEaseType.EASE_OUT, rate=2},
				duration = 0.3 / FightManager.fightSpeed,
				x = self.originPos.x,
				y = self.originPos.y,

				onUpdate = function ()
					self:UpdateZOrder()
				end,

				onComplete = function ()
					self:UpdateZOrder()
					self:PlayStandAnim()
					FightManager:OnActionEnd()
				end,
			},
		}
		TFDirector:toTween(returnBackLine)
	else
		local middlePosX = (self:getPosition().x + self.originPos.x)/2
		local dist = math.abs(self:getPosition().x - self.originPos.x)
		local middlePosY = (self:getPosition().y + self.originPos.y)/2 + dist/2

		returnBackBezier = 
		{
			target = self.rolePanel,
			{
				duration = 0.3 / FightManager.fightSpeed,
				bezier =
				{
					{
						x = middlePosX,
						y = middlePosY,
					},
					{
						x = middlePosX,
						y = middlePosY,
					},
					{
						x = self.originPos.x,
						y = self.originPos.y,
					},
				},
				
				onUpdate = function ()
					self:UpdateZOrder()
				end,

				onComplete = function ()
					self.shadowImg:setVisible(true)
					self:PlayStandAnim()
					FightManager:OnActionEnd()
				end,
			},
		}
		self.shadowImg:setVisible(false)
		TFDirector:toTween(returnBackBezier)
	end
end

function FightRole:PlayAttackAnim(bNormalAttack, animName)
	if self.armature == nil then
		return
	end

	local currAction = FightManager:GetCurrAction()
	if currAction.skillDisplayInfo.attackAnimMove then
		self:SetHpBarVisible(false)
	end

	if self.logicInfo.bEnemyRole == false and currAction.actionInfo.skillid.skillId > 0 and currAction.skillDisplayInfo.zoomIn == 0 then
		TFDirector:currentScene():ZoomIn(self)
	end

	self.attackAnimEnd = false
	self.needReturnBack = false

	-- local animName = "move"
	if animName ~= nil and self.directional_sensitivity then
		if not bEnemyRole then
			animName = animName.."l"
		else
			animName = animName.."r"
		end
	end

	if animName ~= nil and self:HaveAnim(animName) then
		self.armature:play(animName, -1, -1, 0)
		if self.bossEffect then
			self.bossEffect:setVisible(false)
		end
	else
		local _animName = "attack"
		if bNormalAttack then
			_animName = "attack"
		else
			_animName = "skill"
			-- self.armature:play("skill", -1, -1, 0)
		end
		if self.directional_sensitivity then
			if not bEnemyRole then
				_animName = _animName.."l"
			else
				_animName = _animName.."r"
			end
		end
		self.armature:play(_animName, -1, -1, 0)
		if self.bossEffect then
			self.bossEffect:setVisible(false)
		end
	end

	-- print("self.rolePanel:getPosition",self.rolePanel:getPosition())
	self.armature:addMEListener(TFARMATURE_COMPLETE, function()
		self.armature:removeMEListener(TFARMATURE_COMPLETE)
		if self.ispet then
			self.rolePanel:setVisible(false)
		end
		if not self.attackAnimEnd then
			self.attackAnimEnd = true
			if self.needReturnBack then
				self:ReturnBack()
			else
				self:PlayStandAnim()
			end
			self:SetHpBarVisible(true)
		end
	end)
end

function FightRole:Die(isBuff)
	if self.armature == nil then
		return
	end
	self.defianceTarget = nil
	fightRoleMgr:refreshMaxHp()
	self.bActDie = not isBuff

	TFDirector:currentScene().fightUiLayer:OnFightRoleDie(self)

	self:RemoveAllBuff()
	if (GameConfig.HD) then
		--2019-7-24 18:27:13  徐强、章熙熙联名要求老江湖不删除动作
		fightRoundMgr:RemoveAllManualAction(self.logicInfo.posindex, true, true)
	end
	if not FightManager.isTiaoGuo then
		self:RemoveAllBodyEffect()
		self:RemoveAllBossEffect()
	end
	
	local currAction = FightManager:GetCurrAction()
	if currAction ~= nil and currAction.bEnemyAllDie and self.logicInfo.bEnemyRole then

		if FightManager.isTiaoGuo then
			self.rolePanel:setVisible(false)
			return
		end	
		self:PlayDieBezier()
	else
		-- if self:HaveAnim("die_stand") then
		-- 	self.armature:play("die_stand", -1, -1, 0)
		-- 	if self.bossEffect then
		-- 		self.bossEffect:setVisible(false)
		-- 	end
		-- else
			
			local saveOtherRoleList,firstRoleList = fightRoleMgr:CheckHaveSaveOtherSkillRole(self)
			local saveOtherRole = nil --firstRole or saveOtherRoleList[1]
			if (firstRoleList and firstRoleList[1]) then
				-- if (fightRoleMgr:IsAttackAfter(firstRoleList[1], self.logicInfo.posindex)) then
					saveOtherRole = firstRoleList[1]
				-- end
			else
				saveOtherRole = saveOtherRoleList[1]
			end
			--
			if not isBuff and saveOtherRole and self:GetSummoned() == 0 then
				local skillInfo = saveOtherRole:getTriggerSkillBySkillType(EnumFightSkillType.type_10)
				if (skillInfo == nil) then
					skillInfo = saveOtherRole:getTriggerSkillBySkillType(EnumFightSkillType.type_14)
				end
				if skillInfo then
					fightRoundMgr:SetFuhuoAction(saveOtherRole, skillInfo, self)
				-- else
				-- 	self:playerDieTween()
					return
				end
			-- else
				-- self:playerDieTween()
			end
			if FightManager.isTiaoGuo then
				self.rolePanel:setVisible(false)
				return
			end			
			if self:HaveAnim("die") then
				self.armature:setColor(ccc3(255, 255, 255))
				self.armature:play("die", -1, -1, 0)
				self:setPosition(self.originPos)
				self:UpdateZOrder()
				return
			end
			self:playerDieTween()
		-- end 
	end
end

function FightRole:playerDieTween()
	local dieEffect = 
	{
		target = self.rolePanel,
		{
			duration = 1 / FightManager.fightSpeed,
			alpha = 0,
		
			onComplete = function()
				if not self:IsLive() then
					self.rolePanel:setVisible(false)
				else
					self.rolePanel:setOpacity(255)
				end
			end
		}
	}
	TFDirector:toTween(dieEffect)
end


function FightRole:ReLive(reliveHp)
	if self.haveRelive then
		return false
	end
	local act = self.logicInfo.posindex.."  "..self.logicInfo.name.."-ReLive复活: "..reliveHp
	Lua_fightWriteFile(EnumFight_Log.HP, nil, "-----------------阵位", act)
	-- AutoTestManager:addFightLog(EnumFight_Log.HP, "-----------------阵位", act)
	self:RemoveAllBuff()
	self.haveRelive = true
	self:AddBodyEffect("fuhuo", false)
	self:ShowEffectName("fuhuo")
	self:SetHp(reliveHp)

	TFDirector:currentScene().fightUiLayer:OnFightRoleReLive(self)
	return true
end


function FightRole:_ReLive(reliveHp)
	local act = self.logicInfo.posindex.."  "..self.logicInfo.name.."-_ReLive复活: "..reliveHp
	Lua_fightWriteFile(EnumFight_Log.HP, nil, "-----------------阵位", act)
	-- AutoTestManager:addFightLog(EnumFight_Log.HP, "-----------------阵位", act)
	self:RemoveAllBuff()

	self:AddBodyEffect("fuhuo", false)
	self:ShowEffectName("fuhuo")
	self:SetHp(reliveHp)

	TFDirector:currentScene().fightUiLayer:OnFightRoleReLive(self)
	return true
end


function FightRole:ReLiveOut(reliveHp)
	if self.haveRelive then
		return false
	end
	local act = self.logicInfo.posindex.."  "..self.logicInfo.name.."-ReLiveOut复活: "..reliveHp
	Lua_fightWriteFile(EnumFight_Log.HP, nil, "-----------------阵位", act)
	-- AutoTestManager:addFightLog(EnumFight_Log.HP, "-----------------阵位", act)
	self:RemoveAllBuff()

	self.haveRelive = true
	self:SetHp(reliveHp)
	return true
end

function FightRole:SetHp(currHp, bTestDie, isBuff)
	if self.currHp > currHp then
		if self.logicInfo.bEnemyRole then
			if fightRoleMgr:IsSelfAllDie() then
				return
			end
		else
			if fightRoleMgr:IsEnemyAllDie() then
				return
			end
		end
	end
	--
	local lastHp 		= currHp - self.currHp 
	local oldHp 		= self.currHp
	self.currHp 		= math.max(currHp, 0)
	local maxHp 		= self.maxhp
	local addHpPercent 	= 1	--最大血量百分比
	if (self:GetSummoned() ~= 0) then
		--召唤物治疗溢出
		local constantInfo = ConstantData:objectByID("SummonedPercentMaxHP")
		if (constantInfo) then
			addHpPercent = addHpPercent + math.floor(constantInfo.value / 100)
		end
	end

	-- addHpPercent = addHpPercent + fightRoleMgr:GetSkillAddMaxHpByRole(self.logicInfo.bEnemyRole)
	addHpPercent = addHpPercent + fightRoleMgr.addHpPercentRole[self.logicInfo.bEnemyRole] or 0
	
	if (addHpPercent > 1) then
		self.saveAddHpPercent = addHpPercent
	else
		if (self.saveAddHpPercent) then
			if (self.currHp > self.maxhp) then
				addHpPercent = self.saveAddHpPercent
				if (self.currHp > oldHp) then
					--香香死后血量不再溢出,已溢出的就不管了
					self.currHp = oldHp
					if (self.currHp < self.maxhp) then
						self.currHp = self.maxhp
					end
				end
			else
				self.saveAddHpPercent = nil
			end
		end
	end
	
	maxHp 			= math.floor(maxHp * addHpPercent)
	local _maxHp = maxHp
	if(self.currHp > maxHp  ) then
		_maxHp = self.currHp
	end
	self.currHp 	= math.min(self.currHp, _maxHp)
	local currHurt = self.currHp - oldHp
	local logNames = " 复活 "
	if (oldHp > 0) then
		--死亡后的伤害不记录
		if (currHurt < 0) then
			self.lastHurtHp = currHurt
			logNames = " 本次伤害 "
		elseif (currHurt > 0) then
			--治疗回血
			logNames = " 本次回血 "
			local haveBuffList = self:getSameBuffByType(EnumFightBufferType.type_516)
			local subNum = 0
			for i,buffInfo in ipairs(haveBuffList) do
				subNum = subNum + tonumber(buffInfo.config.value)
			end
			local subMaxHp = math.floor(self.maxhp - self.maxhp * subNum / 100)
			if (subMaxHp > 0) then
				subMaxHp = math.floor(subMaxHp * (addHpPercent))
				if (oldHp >= subMaxHp) then
					--之前的血量已经超过了限制上限
					self.currHp = oldHp
				elseif(self.currHp >= subMaxHp) then
					--加血后的血超过了限制上限
					self.currHp = subMaxHp
				end
			else
				--限制为不能加血
				self.currHp = oldHp
			end
		end
	end
	
	local str = "阵位:"..self.logicInfo.posindex.." "..self.logicInfo.name.."最大 "..maxHp.." 剩余 "..self.currHp
	print(str)
	str = str.."  之前  "..oldHp.." 本次伤害 "..currHurt.." 上次伤害"..self.lastHurtHp.." MaxHp:"..self.maxhp
	if (isBuff) then
		str = "BUFF-->"..str
	end
	
	--
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 and VERSION_DEBUG == true then
		if (FightManager.log_fileName) then
			Lua_fightWriteFile(EnumFight_Log.HP, nil, "         "..str)
		end
		-- AutoTestManager:addFightLog(EnumFight_Log.HP, "         "..str)
	end

	if self.hpLabel ~= nil then
		self.hpLabel:setPercent(self.currHp * 100 / self.maxhp)
		self:changeHpLabel()
	end

	if bTestDie == nil then
		bTestDie = true
	end

	if bTestDie and self.currHp <= 0 then
		self:Die(isBuff)
	end

	self:OnHpChange()
end

function FightRole:OnHpChange()
	if not self:IsLive() then
		return
	end

	local effectValue = {}
	if self.passiveSkillAttrAdd == nil and self:TriggerPassiveEffect(13, effectValue) then
		self.passiveSkillAttrAdd = effectValue.value
		if not FightManager.isTiaoGuo then
			self:ShowEffectName("xihundafa")
			self:AddBodyEffect("yihun", true)
		end
		-- print(self.logicInfo.name.."触发移魂:",self.passiveSkillAttrAdd)
	elseif self.passiveSkillAttrAdd ~= nil and not self:TriggerPassiveEffect(13, effectValue) then
		self.passiveSkillAttrAdd = nil
		if not FightManager.isTiaoGuo then
			self:RemoveBodyEffect("yihun")
		end
		-- print(self.logicInfo.name.."移除移魂")
	end
end


function FightRole:ShowFightText(text, number, bAngerNum, bTestDie, bBezier, isBuff)
	local buff = self:GetBuffByType(78)
	if buff == nil then
		self:_ShowFightText(text, number, bAngerNum, bTestDie, bBezier,isBuff)
	else
		local roleList = fightRoleMgr:getHasBuffRole(self.logicInfo.bEnemyRole,78)
		local num = roleList:length()
		local hurt = math.ceil(number/num)
		for role in roleList:iterator() do
			role:_ShowFightText(text, hurt, bAngerNum, bTestDie, bBezier,isBuff)
		end
	end
end

function FightRole:_ShowFightText(text, number, bAngerNum, bTestDie, bBezier,isBuff)
	if self.armature == nil then
		return
	end

	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bSkillShowFight then
		return
	end

	local headPosX = self:getPosition().x
	local headPosY = self:getPosition().y + 200

	if text ~= "" then
		local textPosX = headPosX
		if number ~= 0 then
			textPosX = headPosX - 100
		end
		self:PlayTextEffect(text, ccp(textPosX, headPosY))
	end

	if number == 0 then
		return
	end

	-- number = math.max(-1,number)
	local hurt = number
	if hurt < 0 then
		hurt = self:calculateDunHurt(number)
	end
	local currHp = self.currHp + hurt
	if self:GetBuffByType(56) then
		currHp = math.max(currHp,1)
	end
	self:SetHp(currHp, bTestDie,isBuff)

	local fightTextLabel = nil
	if bAngerNum then
		fightTextLabel = self:CreateAngerNumFont(number)
	else
		fightTextLabel = self:CreateDamageNumFont(text, number)
	end

	fightTextLabel:setPosition(ccp(headPosX, headPosY))

	if bAngerNum then
		number = math.abs(number)
		local text = "d".."-"..number
		fightTextLabel:setText(text)
	else
		if number > 0 then
			fightTextLabel:setText("-"..number)
		else
			number = math.abs(number)
			if text == "baoji" then
				fightTextLabel:setText(number.."d")
			else
				fightTextLabel:setText(number)
			end
		end
	end

	local roleLayer = TFDirector:currentScene().roleLayer
	roleLayer:addChild(fightTextLabel)
	
	local pos = fightTextLabel:getPosition()
	local textTween = nil 
	if not bBezier then
		if self.addDelay == nil or self.lastFloatTime == nil then
			self.lastFloatTime = os.time()
			self.addDelay = 0
		else
			local tempTime = os.time()
			if tempTime - self.lastFloatTime > 1 then
				self.addDelay = 0
			else
				self.addDelay = 0.3
			end
			self.lastFloatTime = tempTime
		end
		fightTextLabel:setScale(0)
		fightTextLabel:setAlpha(0.5)
		textTween = 
		{
			target = fightTextLabel,
			{
				delay = self.addDelay,
				ease = {type=TFEaseType.EASE_IN, rate=2},
				duration = 0.2 / FightManager.fightSpeed,
				alpha = 1,
				scale = 1,
				x = headPosX,
				y = headPosY + 40,
			},
			{
				delay = 0.2 / FightManager.fightSpeed,
				duration = 0.4 / FightManager.fightSpeed,
				x = headPosX,
				y = headPosY + 110,
				alpha = 0,

				onComplete = function ()
					roleLayer:removeChild(fightTextLabel)
				end
			},
		}
	else
		local offsetX = -50
		if self.logicInfo.bEnemyRole then
			offsetX = 50
		end
		textTween = 
		{
			target = fightTextLabel,
			{
				ease = {type=TFEaseType.EASE_IN_OUT, rate=2},
				duration = 0.8 / FightManager.fightSpeed,
				bezier = 
				{
					{	x = headPosX + offsetX,
						y = headPosY + 90,
					},
					{
						x = headPosX + offsetX,
						y = headPosY + 70,
					},
					{
						x = headPosX + 2*offsetX,
						y = headPosY - 100,
					},
				},
				alpha = 0.6,

				onComplete = function ()
					roleLayer:removeChild(fightTextLabel)
				end
			},
		}
	end

	TFDirector:toTween(textTween)
end


function FightRole:ShowFightTextOut( number, bAngerNum, bTestDie)
	local buff = self:GetBuffByType(78)
	if buff == nil then
		self:_ShowFightTextOut( number, bAngerNum, bTestDie)
	else
		local roleList = fightRoleMgr:getHasBuffRole(self.logicInfo.bEnemyRole,78)
		local num = roleList:length()
		local hurt = math.ceil(number/num)
		for role in roleList:iterator() do
			role:_ShowFightTextOut( hurt, bAngerNum, bTestDie)
		end
	end
end

function FightRole:_ShowFightTextOut( number, bAngerNum, bTestDie)
	-- print("FightRole:ShowFightTextOut --->>>>")
	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bSkillShowFight then
		return
	end
	if number == 0 then
		return
	end

	local hurt = number
	if hurt < 0 then
		hurt = self:calculateDunHurt(number)
	end
	local currHp = self.currHp + hurt
	if self:GetBuffByType(56) then
		currHp = math.max(currHp,1)
	end
	self:SetHp(currHp, bTestDie)
end

function FightRole:showFightHurtText(bQuick, number, text, bAngerNum, bTestDie, bBezier, isBuff)
	if (not bQuick) then
		text = text or ""
		self:ShowFightText(text, number, bAngerNum, bTestDie, bBezier, isBuff)
	else
		self:ShowFightTextOut(number, bAngerNum, bTestDie)
	end
end
function FightRole:HaveTriggerType6AttackBuff()
	local forbidAttackBuff = {10,12, 13, 14, 15, EnumFightBufferType.type_520}
	local buffTypeList = self:GetBuffListByType(forbidAttackBuff)
	for i=1,#forbidAttackBuff do
		if buffTypeList[forbidAttackBuff[i]] ~= nil then
			return true
		end
	end
	return false
end

function FightRole:removeForbidAttackBuff()
	local forbidAttackBuff = {12, 13, 14, 15, EnumFightBufferType.type_520}
	local buffTypeList = self:GetBuffListByType(forbidAttackBuff)
	for i=1,#forbidAttackBuff do
		if buffTypeList[forbidAttackBuff[i]] ~= nil then
			self:RemoveBuffByType(forbidAttackBuff[i])
		end
	end
end


function FightRole:IsCanYuaHuBuff()
	local forbidAttackBuff = {10,12, 13, 14,15,18, EnumFightBufferType.type_520}
	local buffTypeList = self:GetBuffListByType(forbidAttackBuff)
	for i=1,#forbidAttackBuff do
		if buffTypeList[forbidAttackBuff[i]] ~= nil then
			return false
		end
	end
	return true
end


function FightRole:TestDieBuff()
	local buffTypeList = self:GetBuffListByType({25, 26, 56})
	if buffTypeList[25] ~= nil and buffTypeList[26] ~= nil then
		self:RemoveBuffByType(25)
		self:RemoveBuffByType(26)
		if buffTypeList[56] then
			self:SetHp(1)
		else
	  		self:SetHp(0,nil,true)
	  	end
	end
end

function FightRole:hasDunBuff()
	local dunHurt = 0
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffer = self.buffList:objectAt(i)
		if buffer.bValid and self:isDunBuff(buffer.config.type) then
			dunHurt = dunHurt + buffer.hurt
		end
	end
	return dunHurt
end


function FightRole:calculateDunHurt( number )
	--20180419-使用护盾BUFF时跟服务器保持一致，按dunBuff顺序
	local dunBuff = {57,58,85}
	local buffList = self:GetBuffListByType(dunBuff)
	for i,buffTypeId in ipairs(dunBuff) do
		local buffInfo = buffList[buffTypeId]
		if (buffInfo) then
			buffInfo.hurt = buffInfo.hurt + number
			if buffInfo.hurt > 0 then
				return 0
			else
				number = buffInfo.hurt
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffer = self.buffList:objectAt(i)
	-- 	if buffer.bValid and self:isDunBuff(buffer.config.type) then
	-- 		buffer.hurt = buffer.hurt + number
	-- 		-- print(buffer.config.name.." 吸收伤害 "..number.." 剩余吸收量 "..buffer.hurt)
	-- 		if buffer.hurt > 0 then
	-- 			return 0
	-- 		else
	-- 			number = buffer.hurt
	-- 			self:RemoveBuffByInfo(buffer)
	-- 		end
	-- 	end
	-- end
	return number
end

function FightRole:calculateDunNum( buff_config ,fromTarget)
	local number = 0
	local valueInfo = GetAttrByString(buff_config.value)

	for i=2,17 do
		if valueInfo[i] then
			-- print( localizable.AttributeTypeStr[i].." = ",fromTarget:GetAttrNum(i) )
			-- print(" 百分比 ",valueInfo[i] )
			number = number + math.floor(fromTarget:GetAttrNum(i) * valueInfo[i] / 100)
		end
	end
	if valueInfo[18] ~= nil then
		number = number + math.floor(fromTarget.maxhp * valueInfo[18] / 100)
	elseif valueInfo[30] ~= nil then
		number = number + math.floor(fromTarget.currHp * valueInfo[30] / 100)
	end

	if valueInfo[1] ~= nil then
		number = number + valueInfo[1]
	end
	return number
end

function FightRole:AddBuff(fromTarget, buffID, level, hurt)
	
	local config = SkillLevelData:getBuffInfo(buffID, level)
	if config == nil then
		assert(false, buffID..":buffer not find")
		return false
	end
	--
	local buffTypeId = config.type
	if (EnumFightBufferType.type_94 == buffTypeId or buffTypeId == EnumFightBufferType.type_519) then
		--当前角色身上可添加风恕BUFF
		local isAddBuff = false
		local passiveSkillNum = #self.passiveSkill
		for i,skillid in ipairs(self.passiveSkill) do
			local skillInfo = FightManager:GetCacheSkillBaseInfo(skillid.skillId)
			if (skillInfo.extra_buffid == buffID or skillInfo.buff_id == buffID) then
				isAddBuff = true
				break
			end
		end
		if (not isAddBuff) then
			return false
		end
	end
	if (config.good_buff == 1) then
		if self:isCanNotTriggerBeiDong() and config.is_clean == 0 then  --不触发增益buff的buff
			return false
		elseif (fromTarget.logicInfo.bEnemyRole ~= self.logicInfo.bEnemyRole) then
			--增益BUFF只能对自己人上 放屁 有挑衅
			-- local str = stringUtils.format(EnumFightError.Error_A, self.logicInfo.roleId, fromTarget.logicInfo.roleId, buffID)
			-- toastMessage(str)
			-- print(str)
			-- return false
		end
	elseif (config.gain_type ~= 1) then
		if config.is_clean ~= 1 then
			local buffRole, skillInfo = fightRoleMgr:GetSelfLiveRoleTriggerHurtType(self.logicInfo.bEnemyRole, EnumFightTriggerHurtType.type_23)
			if (buffRole and skillInfo) then
				if (buffRole:getTriggerSkillCountBySkill(skillInfo.id) > skillInfo.special_num) then
					-- return false
				else
					buffRole:addTriggerSkillCount(skillInfo.id)
					fightRoundMgr:SetBackAttackAction(buffRole, self, {skillId = skillInfo.triggerSkill ,level = skillInfo.level }, EnumFightTriggerHurtType.type_23)
					return false
				end
			end
		end
	end
	--替换
	if config.is_replace == 0 then
		local has_buff = self:GetBuffByType(buffTypeId)
		if has_buff ~= nil and has_buff.bValid and has_buff.config.is_replace == 0 then
			return false
		end
	elseif config.is_replace == 2 then
		local has_buff = self:GetBuffByType(buffTypeId)
		if has_buff ~= nil then
			has_buff.lastNum = has_buff.lastNum - 1
			has_buff.lastNum = math.max(has_buff.lastNum , 0)
			return true
		end
	elseif (config.upper_limit and config.upper_limit > 0) then
		--BUFF拥有上限
		local buffCount = 0
		for buffInfo in self.buffList:iterator() do
			if buffInfo.bValid then
				if (buffTypeId == buffInfo.config.type) then
					buffCount = buffCount + 1
				end
			end
		end
		if (buffCount >= config.upper_limit) then
			return false
		end
	end
	--重复
	if config.is_repeat == 0 then
		if self:isDunBuff(buffTypeId) then
			for buffInfo in self.buffList:iterator() do
				if buffInfo.bValid and buffInfo.config.type == buffTypeId then 
					self:dunBufTrigger(buffInfo)
				end
			end
		end
		self:RemoveBuffByType(buffTypeId)
	end


	local buffInfo   	= {}
	buffInfo.config  	= config
	buffInfo.lastNum	= 0
	buffInfo.bValid  	= true
	buffInfo.hurt    	= hurt
	buffInfo.fromTarget = fromTarget

	if self:isDunBuff(buffTypeId) then
		buffInfo.hurt = self:calculateDunNum(config,fromTarget)
		-- print(config.name.." 可吸收伤害 "..buffInfo.hurt)
	end
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
		local aa = "\n\t\t----ADD-----\n\t\t"
		local act1 = "阵位: "..fromTarget.logicInfo.posindex.." "..fromTarget.logicInfo.name
		local act2 = "     对 -->  阵位: "..self.logicInfo.posindex.." "..self.logicInfo.name.."上  buffId: "..config.name.."  "..config.id.."  type: "..config.type
		local bb = "\n\t\t----END-----\n"
		local nCurrCount = FightManager:GetFightCurrActionCount()
		Lua_fightWriteFile(EnumFight_Log.BUFF, nil, "动作:"..nCurrCount, aa,act1,act2,bb)
		-- AutoTestManager:addFightLog(EnumFight_Log.BUFF,"动作:"..nCurrCount, "----ADD-----",act1,act2,"----END-----")
	end
	--
	for _i,_buffTypeId in ipairs(EnumFightTeamOnlyBuff) do
		if (buffTypeId == _buffTypeId) then
			local haveBuffList = fightRoleMgr:getHasBuffRole(self.logicInfo.bEnemyRole, _buffTypeId)
			for role in haveBuffList:iterator() do
				role:RemoveBuffByType(_buffTypeId)
			end
		end
	end
	self.buffList:pushBack(buffInfo)

	self:AddBuffIcon(buffID, config.icon_id)
	if buffTypeId == 77 then
		fightRoleMgr:AddAnger(self.logicInfo.bEnemyRole, 0)
	elseif buffTypeId == EnumFightBufferType.type_83 then
		self.bMrllBack = false
	end

	local under_show = config.under_show ~= 0
	if config.effect_loop == 1 then
		if not self:addBuffDisplay( config.effect_id, true) then
			self:AddBodyEffect(config.effect_id, true , under_show,0,0,config.rotation)
		end
	else
		if not self:addBuffDisplay( config.effect_id, false) then
			self:AddBodyEffect(config.effect_id, false , under_show,0,0,config.rotation)
		end
	end

	if buffTypeId > 2 then
		self:ShowBufferName(buffTypeId, config.id)
		--挑衅buff
		if buffTypeId == 18 then
			self.defianceTarget = FightManager:GetCurrAction().attackerRole
		elseif buffTypeId == 63 or buffTypeId == 86 or config.type == EnumFightBufferType.type_509 then
			self:cleanBuffByGood(true)
		end
	end

	self:TestReleaseManualSkill()
	self:TestDieBuff()
	
	return true
end

--

function FightRole:HaveFrozenBuff( isCanAttack )
	
	if isCanAttack then
		-- return isBuff ~= nil
		return self:GetBuffByType(14) ~= nil
	else
		local buffTypeList = self:GetBuffListByType({14, EnumFightBufferType.type_503, 79})
		local isBuff = nil
		if (buffTypeList[14]) then
			isBuff = true
		elseif (buffTypeList[EnumFightBufferType.type_503]) then
			local liveList = fightRoleMgr:GetAllLiveRole(self.logicInfo.bEnemyRole)
			if (liveList:length() > 1) then
				isBuff = true
			end
		end
		return isBuff ~= nil or buffTypeList[79] ~= nil
		-- return self:GetBuffByType(14) ~= nil or self:GetBuffByType(79) ~= nil
	end

	
end


--乾坤挪移buff
function FightRole:canTriggerDzxy()
	if self.ispet then
		return false
	end
	-- print("self.immuneAttribute",self.immuneAttribute)
	if self.immuneAttribute and self.immuneAttribute[27] ~= nil then
		return false
	end
	return true
end
--
function FightRole:RemoveBuffByIndex(buffIndex)
	local buffInfo = self.buffList:objectAt(buffIndex)
	self:RemoveBuffByInfo(buffInfo)
end

--
function FightRole:RemoveBuffByInfo(buffInfo)
	if buffInfo.bValid then
		buffInfo.bValid = false

		local needRemoveEffect = true
		local needRemoveIcon = true
		for _buffInfo in self.buffList:iterator() do
			if _buffInfo.bValid and _buffInfo.config.effect_id == buffInfo.config.effect_id then 
				needRemoveEffect = false
			end
			if _buffInfo.bValid and _buffInfo.config.id == buffInfo.config.id then 
				needRemoveIcon = false
			end
		end
		if needRemoveEffect then
			self:RemoveBuffDisplay(buffInfo.config.effect_id)
		end
		if needRemoveIcon then
			self:RemoveBuffIcon(buffInfo.config.id)
		end
		if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then	
			local act = "\n\t\t----remove--\n\t\t"
			local act0 = "阵位: "..self.logicInfo.posindex.." "..self.logicInfo.name.."  移除: buffid: "..buffInfo.config.name.."  "..buffInfo.config.id.." type: "..buffInfo.config.type
			local act1 = "  -->来源 阵位: "..buffInfo.fromTarget.logicInfo.posindex.." "..buffInfo.fromTarget.logicInfo.name
			-- print(act0..act1)
			Lua_fightWriteFile(EnumFight_Log.BUFF, nil, "动作: "..FightManager:GetFightCurrActionCount(), act,act0,act1,"\n\t\t----END-----\n")
			-- AutoTestManager:addFightLog(EnumFight_Log.BUFF,"动作: "..fightRoundMgr.actionCount-1, "----remove--",act0,act1,"----END-----")
		end
	end

	if not self:HaveForbidAttackBuff() then
		self.armature:resume()
	end
	self.removeList:pushBack(buffInfo)

	self:TestReleaseManualSkill()
end

--
function FightRole:RemoveAllBuff()
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid then 
			-- self:RemoveBuffByIndex(i)
			self:RemoveBuffByInfo(buffInfo)
		end
	end
	self.nConsumptionSkillRelease = 0
end



function FightRole:CleanBuff(attackerRole)
	self:AddBodyEffect("jinghua", false)
	local cleanGood = true
	if fightRoleMgr:IsSameSide({attackerRole, self}) then
		cleanGood = false
	end

	local buffLevel = 1
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffInfo = self.buffList:objectAt(i)
	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.is_clean == 0 then
			buffInfo.config.buffLevel = buffInfo.config.buffLevel or 1
			if cleanGood and buffInfo.config.good_buff == 1 then
				buffLevel = math.max(buffLevel ,buffInfo.config.buffLevel)
			elseif cleanGood == false and buffInfo.config.good_buff == 0 then
				buffLevel = math.max(buffLevel ,buffInfo.config.buffLevel)
			end
		end
	end

	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffInfo = self.buffList:objectAt(i)
	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.is_clean == 0 then
			if cleanGood and buffInfo.config.good_buff == 1 and buffLevel == buffInfo.config.buffLevel then
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)	
			elseif cleanGood == false and buffInfo.config.good_buff == 0 and buffLevel == buffInfo.config.buffLevel then
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end

	if cleanGood then
		self:ShowEffectName("qusan")
	else
		self:ShowEffectName("jinghua")
	end
end
function FightRole:cleanBuffByGood(cleanGood)
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffInfo = self.buffList:objectAt(i)
	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.is_clean == 0 then
			if cleanGood and buffInfo.config.good_buff == 1 then
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)
			elseif cleanGood == false and buffInfo.config.good_buff == 0 then
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end

	-- if cleanGood then
	-- 	self:ShowEffectName("qusan")
	-- else
	-- 	self:ShowEffectName("jinghua")
	-- end
end

function FightRole:OnRoundChange()
	if self.ispet then
		return
	end
	local hpChange = 0
	if self:IsLive() then
		local addBloodBySelf = self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_AddBloodBySelf)
		if addBloodBySelf then
			hpChange = hpChange + math.floor(self.maxhp * addBloodBySelf / 10000)
		end
		local addBloodBySelf_num = self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_AddBloodBySelf_Num)
		if addBloodBySelf_num then
			hpChange = hpChange + addBloodBySelf_num
		end
		hpChange = math.max(0,hpChange)
	else
		local effectValue = {}
		if self:TriggerPassiveEffect(35, effectValue) then
			self.rolePanel:setVisible(true)
			local addHp = self.maxhp * effectValue.value / 100
			addHp = math.floor(addHp)
			self:fuHuoActionEnd()
			self:_ReLive(addHp)
			fightRoleMgr:refreshMaxHp()
			return
		end
		return
	end
	-- self:ShowFightText("", hpChange, nil, nil, nil,true)
	self:showFightHurtText(FightManager.isTiaoGuo, hpChange, "", nil, nil, nil, true)
	hpChange = 0
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffInfo = self.buffList:objectAt(i)
	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.last_type == 1 then
			hpChange = hpChange + self:ShowHpChangeBuff(buffInfo)
			if hpChange ~= 0 then
				hpChange = self:IsBuffHurtReLive(hpChange)
				-- self:ShowFightText("", hpChange, nil, nil, nil,true)
				self:showFightHurtText(FightManager.isTiaoGuo, hpChange, "", nil, nil, nil, true)
				hpChange = 0
			end
			if (not self:IsLive()) then
				break
			end
			buffInfo.lastNum = buffInfo.lastNum + 1
			if FightManager.isReplayFight == false then
				--持续次数触发buff
				if buffInfo.config.buff_formula == 3 then
					if buffInfo.lastNum >= buffInfo.config.buff_rate then
						local new_buff_id = tonumber(buffInfo.config.value)
						local new_buff = SkillBufferData:objectByID(new_buff_id)
						if new_buff then
							if self:AddBuff(buffInfo.fromTarget , new_buff_id,buffInfo.config.level,0) then
								fightRoundMgr:AddPermanentBuf(self,self,{skillid = 0, level = 0},new_buff_id,buffInfo.config.id)
							end
						end
					end
				end
			end
			if buffInfo.lastNum >= buffInfo.config.last_num then
				self:dunBufTrigger(buffInfo)
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end
	-- if hpChange ~= 0 then
	-- 	-- self:ShowFightText("", hpChange)
	-- 	self:ShowFightText("", hpChange, nil, nil, nil,true)

	-- end
	-- self:permanentBufSkill()
end

function FightRole:OnActionEnd()
	if self.ispet then
		-- self.rolePanel:setVisible(false)
		return
	end
	-- local hpChange 		= 0
	local bufferNum 	= self.buffList:length()
	-- local isSelfAttacker = self.logicInfo.posindex == currAction.attackerRole.logicInfo.posindex
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid then
			local last_type = buffInfo.config.last_type
			if (last_type == EnumFightBuffLastType.last_Type_2) then
				local hpChange = self:ShowHpChangeBuff(buffInfo)
				if hpChange ~= 0 then
					hpChange = self:IsBuffHurtReLive(hpChange)
					-- self:ShowFightText("", hpChange, nil, nil, nil,true)
					self:showFightHurtText(FightManager.isTiaoGuo, hpChange, "", nil, nil, nil, true)
				end
				if (not self:IsLive()) then
					break
				end
				buffInfo.lastNum = buffInfo.lastNum + 1
				if FightManager.isReplayFight == false then
					--持续次数触发buff
					if buffInfo.config.buff_formula == 3 then
						if buffInfo.lastNum >= buffInfo.config.buff_rate then
							local new_buff_id = tonumber(buffInfo.config.value)
							local new_buff = SkillBufferData:objectByID(new_buff_id)
							if new_buff then
								if self:AddBuff(buffInfo.fromTarget ,new_buff_id,buffInfo.config.level,0) then
									fightRoundMgr:AddPermanentBuf(self,self,{skillid = 0, level = 0},new_buff_id,buffInfo.config.id)
								end
							end
						end
					end
				end
			elseif (last_type == EnumFightBuffLastType.last_Type_11) then
				--自己施放主动或神技
				local currAction 	= FightManager:GetCurrAction()
				if (currAction and (self.logicInfo.posindex == currAction.attackerRole.logicInfo.posindex) and (currAction.actionInfo.bManualAction or currAction.actionInfo.bAngerManualAction)) then
					local hpChange = self:ShowHpChangeBuff(buffInfo)
					buffInfo.lastNum = buffInfo.lastNum + 1
					if hpChange ~= 0 then
						hpChange = self:IsBuffHurtReLive(hpChange)
						-- self:ShowFightText("", hpChange, nil, nil, nil,true)
						self:showFightHurtText(FightManager.isTiaoGuo, hpChange, "", nil, nil, nil, true)
					end
					if (not self:IsLive()) then
						break
					end
				end
			end
			if buffInfo.lastNum >= buffInfo.config.last_num then
				self:dunBufTrigger(buffInfo)
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)
				if (buffInfo.config.type == EnumFightBufferType.type_94) then
					self:PlayStandAnim()
				end
			end
		end
	end
	
	-- if hpChange ~= 0 then
	-- 	-- self:ShowFightText("",hpChange)
	-- 	self:ShowFightText("", hpChange, nil, nil, nil,true)
	-- end
	-- self:permanentBufSkill()
	local buff_type_list = {33,62,69, EnumFightBufferType.type_92, EnumFightBufferType.type_508, EnumFightBufferType.type_517}--自己
	local buff_type_list1 = {34,63,70, EnumFightBufferType.type_93, EnumFightBufferType.type_509, EnumFightBufferType.type_518}
	--
	local bEnemyRole = self.logicInfo.bEnemyRole
	local buffTypeList = self:GetBuffListByType(buff_type_list1)
	for i=1,#buff_type_list1 do
		local buSiBuXiu_2 = buffTypeList[buff_type_list1[i]]
		if buSiBuXiu_2 and fightRoundMgr:hasBuffByType(buff_type_list[i], bEnemyRole) == false then
			self:RemoveBuffByType(buff_type_list1[i])
		end
	end
	--已方BUFF消失
	local isLive = self:IsLive()
	for haveBuffId,buffId in pairs(EnumFightTeammateBuff) do
		-- local buffTypeList = self:GetBuffListByType({haveBuffId, buffId}, true)
		local haveBuff = self:GetBuffByType(buffId)
		if (haveBuff) then
			if (fightRoundMgr:hasBuffByType(haveBuffId, bEnemyRole, true) == false) then
				-- self:RemoveBuffByType(buffId)
				self:RemoveBuffByInfo(haveBuff)
			end
		end
	end

	self:repeatBufTrigger()
	self:CleanRemove()
end

function FightRole:CleanRemove()
	if self.removeList:length() > 0 then
		for v in self.removeList:iterator() do
			self.buffList:removeObject(v)
		end
		self.removeList:clear()
	end
	-- self.removeList:pushBack(buffInfo)
end

function FightRole:dunBufTrigger(buffInfo)
	if not buffInfo.bValid and not self:isDunBuff(buffInfo.config.type) then
		return false
	end
	--叠加次数触发buff
	if buffInfo.config.buff_formula == 4 then
		local params = tonumber(buffInfo.config.params)
		if buffInfo.fromTarget and buffInfo.fromTarget:IsLive() then
			local skillId = params
			local skillLevel = tonumber(buffInfo.config.level)
			local skillID = {skillId = skillId,level =  skillLevel }
			fightRoundMgr:SetSkillTrgerSkillAction( buffInfo.fromTarget ,skillID )
		end
	end
	return true
end



function FightRole:repeatBufTrigger()
	local bufferNum = self.buffList:length()
	local formula_list = {}
	for i=bufferNum,1,-1 do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid then
			--叠加次数触发buff
			if buffInfo.config.buff_formula == 2 then
				local canTrigger = true
				for k,v in pairs(formula_list) do
					if v == buffInfo.config.type then
						canTrigger = false
					end
				end
				if canTrigger then
					local repeat_time = self:getRepeatBuffTriggerTime( buffInfo )
					formula_list[#formula_list+1] = buffInfo.config.type
					if repeat_time >= buffInfo.config.buff_rate then
						local params = tonumber(buffInfo.config.params)
						if params == 0 then  --触发buff
							local new_buff_id = tonumber(buffInfo.config.value)
							local new_buff = SkillBufferData:objectByID(new_buff_id)
							if new_buff then
								if self:AddBuff(buffInfo.fromTarget,new_buff_id,buffInfo.config.level,0) then
									fightRoundMgr:AddPermanentBuf(self,self,{skillid = 0, level = 0},new_buff_id,buffInfo.config.id)
								end
							end
						elseif params == 1 and buffInfo.fromTarget then --触发伤害
							local tbl = {}
							local temptbl = string.split(str,'|')			--分解"|"
							for k,v in pairs(temptbl) do
								local temp = string.split(v,'_')				--分解'_',集合为 key，vaule 2个元素
								local key = tonumber(temp[1])
								local value = tonumber(temp[2])
								local value_add = tonumber(temp[3] or 0)
								tbl[key] = value + value_add*level
							end
							local hurt = 0
							for k,v in pairs(table_name) do
								hurt = hurt + buffInfo.fromTarget:GetAttrNum(k)*v/100
							end
							-- self:ShowFightText("",hurt)
							self:showFightHurtText(FightManager.isTiaoGuo, hurt, "", nil, nil, nil, false)
						elseif params == 2 and buffInfo.fromTarget then --触发技能 
							local skillId = tonumber(buffInfo.config.value)
							local skillLevel = tonumber(buffInfo.config.level)
							local skillID = {skillId = skillId,level =  skillLevel }
							
							local triggerSkillType = nil
							if buffInfo.config.type == EnumFightBufferType.type_512 then
								triggerSkillType = 100
							end

							fightRoundMgr:SetSkillTrgerSkillAction( buffInfo.fromTarget ,skillID, triggerSkillType )
						end
						self:RemoveBuffByType(buffInfo.config.type)
					end
				end
			end
		end
	end
end


function FightRole:getRepeatBuffTriggerTime( buffInfo )
	local bufferNum = self.buffList:length()
	local repeat_time = 0
	for j=bufferNum,1,-1 do
		local like_buffInfo = self.buffList:objectAt(j)
		if like_buffInfo.bValid and like_buffInfo.config.type == buffInfo.config.type then
			repeat_time = repeat_time + 1
		end
	end
	return repeat_time
end

function FightRole:OnBuffTrigger(_type)
	if _type == nil then
		_type = 3
	end

	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.last_type == _type then
			buffInfo.lastNum = buffInfo.lastNum + 1
			if buffInfo.lastNum >= buffInfo.config.last_num then
				self:dunBufTrigger(buffInfo)
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end
end

--last_type类型触发
function FightRole:OnBuffLastTypeTrigger(buffInfo, lastType)
	if lastType == nil or buffInfo == nil then
		return 
	end
	if (buffInfo and buffInfo.bValid) then
		if (buffInfo.config.last_type == lastType) then
			buffInfo.lastNum = buffInfo.lastNum + 1
			if buffInfo.lastNum >= buffInfo.config.last_num then
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end
end
function FightRole:OnBuffTriggerByType(_type)
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffInfo = self.buffList:objectAt(i)
	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.type == _type then
			buffInfo.lastNum = buffInfo.lastNum + 1
			if buffInfo.lastNum >= buffInfo.config.last_num then
				self:dunBufTrigger(buffInfo)
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end
end

function FightRole:OnBuffTriggerByTypeInfo(buffInfo)
	if (buffInfo and buffInfo.bValid) then
		buffInfo.lastNum = buffInfo.lastNum + 1
		if buffInfo.lastNum >= buffInfo.config.last_num then
			self:dunBufTrigger(buffInfo)
			self:RemoveBuffByInfo(buffInfo)
		end
	end
end

function FightRole:OnAttackBuffTrigger()
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffInfo = self.buffList:objectAt(i)
	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.last_type == 4 then
			buffInfo.lastNum = buffInfo.lastNum + 1
			if buffInfo.lastNum >= buffInfo.config.last_num then
				self:dunBufTrigger(buffInfo)
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end
end
function FightRole:OnHelpAttackBuffTrigger()

	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.last_type == 5 then
			buffInfo.lastNum = buffInfo.lastNum + 1
			if buffInfo.lastNum >= buffInfo.config.last_num then
				self:dunBufTrigger(buffInfo)
				-- self:RemoveBuffByIndex(i)
				self:RemoveBuffByInfo(buffInfo)
			end
		end
	end
end

function FightRole:isBuffTypeChangeHp( buff_type )
	local changType = {EnumFightBufferType.type_1, 2, 17, EnumFightBufferType.type_513, EnumFightBufferType.type_502}
	for i=1,#changType do
		if changType[i] == buff_type then
			return true
		end
	end
	return false
end

function FightRole:ShowHpChangeBuff(buffInfo)
	if not self:IsLive() then
		return 0
	end
	if not self:isBuffTypeChangeHp(buffInfo.config.type) then
		return 0
	end

	local number = 0
	local valueInfo = GetAttrByString(buffInfo.config.value)
	local add_value = stringToNumberTable(buffInfo.config.params,"_")
	if buffInfo.config.type == EnumFightBufferType.type_513 then 	--流血
		
		local times = buffInfo.lastNum
		for k,v in pairs(valueInfo) do
			valueInfo[k] = v + add_value[1] + add_value[2]*times
		end
	elseif buffInfo.config.type == EnumFightBufferType.type_1 then 	--中毒
		if (add_value[1] and add_value[2]) then
			number = number + math.floor(buffInfo.fromTarget:GetAttrNum(add_value[1]) * add_value[2] / 100)
		end
	elseif buffInfo.config.type == EnumFightBufferType.type_502 then 	--蛇毒
		--放主动技能或神技时会损失血量上限10%的气血。此后每次释放主动技能或神技时蛇毒BUFF的扣血量都会递增10%。
		local times 	= buffInfo.lastNum
		local attrIndex = add_value[1]
		local attrValue = add_value[2]
		--
		if (attrIndex and attrValue) then
			valueInfo[attrIndex] = valueInfo[attrIndex] or 0
			valueInfo[attrIndex] = valueInfo[attrIndex] + attrValue * times 
		end
	end
	for i=2,17 do
		if valueInfo[i] then
			number = number + math.floor(self:GetAttrNum(i) * valueInfo[i] / 100)
		end
	end
	-- for i=19,22 do
	-- 	if valueInfo[i] then
	-- 		number = number + math.floor(self:GetAttrNum(i) * valueInfo[i] / 100)
	-- 	end
	-- end

	if valueInfo[18] ~= nil then
		number = number + math.floor(self.maxhp * valueInfo[18] / 100)
	elseif valueInfo[30] ~= nil then
		number = number + math.floor(self.currHp * valueInfo[30] / 100)
	elseif valueInfo[31] ~= nil then
		local hurt = buffInfo.hurt or 0
		number = number + math.floor(hurt * valueInfo[31] / 100)
	end

	if valueInfo[1] ~= nil then
		number = number + valueInfo[1]
	end
	-- print("number ==",number)


	--类型伤害修正
	local fightEffectValue = buffInfo.fromTarget:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,buffInfo.config.type) +
			self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,buffInfo.config.type)



	local fightDotEffectValue = 0
	local fightBonusEffectValue = 0
	if number < 0 then
			--dot伤害修正
		fightDotEffectValue = buffInfo.fromTarget:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_DotHurt) +
				self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_DotHurt)

	elseif number > 0 then
		--治疗dot修正
		fightBonusEffectValue = buffInfo.fromTarget:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_BonusHealing) +
				self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing)
	end
	fightEffectValue = fightEffectValue + fightDotEffectValue + fightBonusEffectValue
	fightEffectValue = math.max(0,fightEffectValue/10000+1)
	number = number * fightEffectValue
	number = math.floor(number)

	if number < 0 then
		number = number - buffInfo.fromTarget:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_DotHurt_Num)
		number = number - self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_DotHurt_Num)
		number = math.min(0,number)
	else
		number = number + buffInfo.fromTarget:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_BonusHealing_Num)
		number = number + self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_BonusHealing_Num)
		if(GameConfig.HD) then
			local endBonusHealing = 0
			endBonusHealing = buffInfo.fromTarget:getEffectExtraAttrNum(EnumFightAttributeType.Effect_extra,EnumFightEffectType.FightEffectType_EndBonusHealing) +
					self:getEffectExtraAttrNum(EnumFightAttributeType.Be_effect_extra,EnumFightEffectType.FightEffectType_EndBonusHealing)
			endBonusHealing = endBonusHealing / 10000 * number
			number = number + endBonusHealing
		end
		number = math.max(0,number)
	end
	local buffId = buffInfo.config.id
	if number == 0 then
		print("hurt == 0 , buffId ",buffId)
		return 0
	end
	if (number < -1) then
		if (self:GetBuffByType(EnumFightBufferType.type_98)) then
			number = -1
		end
	end
	
	-- print("buffInfo.config.type = ",buffInfo.config.type)
	
	if buffInfo.config.type == 1 then
		self:ShowBufferName(1, buffId)
		-- print(self.logicInfo.name.."中毒扣血："..number.."当前血量："..self.currHp)
	elseif buffInfo.config.type == 2 then
		self:ShowBufferName(2, buffId)
		-- print(self.logicInfo.name.."灼烧扣血："..number.."当前血量："..self.currHp)
	elseif buffInfo.config.type == EnumFightBufferType.type_513 then
		self:ShowBufferName(EnumFightBufferType.type_513, buffId)
		-- print(self.logicInfo.name.."流血扣血："..number.."当前血量："..self.currHp)
	end
	print(self.logicInfo.name.." currHp "..self.currHp.." BUFF: " ..buffInfo.config.id.."  扣血："..number.." lastNum-> "..buffInfo.lastNum)
	
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 and VERSION_DEBUG == true then
		if (FightManager.log_fileName) then
			local act = "   Buff "..buffInfo.fromTarget.logicInfo.posindex.."  "..buffInfo.fromTarget.logicInfo.name.." " ..buffInfo.config.id
			Lua_fightWriteFile(EnumFight_Log.HP, nil, act)
		end
		-- AutoTestManager:addFightLog(EnumFight_Log.HP, act)
	end
	--是否复活
	if self.currHp + number <= 0 then
		local effectValue = {}
		if self:HaveReliveSkill(effectValue) then
			-- self:ShowFightText("", number, false, false)
			self:showFightHurtText(FightManager.isTiaoGuo, number, "", nil, nil, nil, false)
			effectValue.value = math.min(100, effectValue.value)
			local reliveHp = math.floor(self.maxhp * effectValue.value / 100)
			self:ReLive(reliveHp)
			return 0
		end
	end
	fightRoleMgr:addHurtReport(buffInfo.fromTarget.logicInfo.posindex,  number)
	return number
end


function FightRole:IsBuffHurtReLive(number)
	if self.currHp + number <= 0 then
		local effectValue = {}
		if self:HaveReliveSkill(effectValue) then
			-- self:ShowFightText("", number, false, false)
			self:showFightHurtText(FightManager.isTiaoGuo, number, "", nil, nil, nil, false)
			effectValue.value = math.min(100, effectValue.value)
			local reliveHp = math.floor(self.maxhp * effectValue.value / 100)
			self:ReLive(reliveHp)
			return 0
		end
	end
	return number
end


function FightRole:HaveReliveSkill(effectValue)
	if self.haveRelive then
		return false
	end
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillInfo.effect_rate == 10000 and skillInfo.effect == 9 then
			effectValue.value = skillInfo.effect_value
			return true
		end
	end

	return false
end

--
function FightRole:RemoveBossEffect(nEffectID)
	local bodyEffect = self.bossEffectList[nEffectID]
	if bodyEffect then
		bodyEffect:removeFromParent()
		bodyEffect = nil
		self.bossEffectList[nEffectID] = nil
	end
end

function FightRole:RemoveAllBossEffect()
	for k,bodyEffect in pairs(self.bossEffectList) do
		if (bodyEffect) then
			bodyEffect:removeFromParent()
			bodyEffect = nil
		end
	end
	self.bossEffectList = {}
end

--bDun true时不算盾
function FightRole:getCurrHp(bDun)
	local dunHurt = 0
	if (not bDun) then
		dunHurt = self:hasDunBuff()
	end
	local currHp = self.currHp + dunHurt
	return currHp
end

function FightRole:getMaxHp()
	return self.maxhp
end

--是否触发被动效果：闪避1，被击打2 , 3治疗
function FightRole:HasTriggerSkillBySkillType(skillType)
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return nil
	end
	-- local passiveSkillNum = #self.passiveSkill
	-- for i=1,passiveSkillNum do
	for i,skillID in ipairs(self.passiveSkill) do
		local skillInfo = SkillLevelData:objectByID(skillID)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo and skillBaseInfo ~= nil and skillBaseInfo.type == skillType then
			if skillBaseInfo.type == EnumFightSkillType.type_10 then
				local targetNum = skillInfo.special_num
				self.fuhuoSkillTime = self.fuhuoSkillTime or 0
				if self.fuhuoSkillTime >= targetNum then
					return nil
				end
			end
			return skillBaseInfo 
		end
	end
	return nil
end
--是否触发被动效果：闪避1，被击打2 , 3治疗
function FightRole:getTriggerSkillBySkillType(skillType)
	for i,skillID in ipairs(self.passiveSkill) do
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo and skillInfo.type == skillType then
			return skillInfo 
		end
	end
	return nil
end

--是否触发被动效果：闪避1，被击打2 , 3治疗
function FightRole:HasTriggerSkillByType(hurtType)
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillInfo.trigger_hurtType == hurtType then
			return true ,skillInfo
		end
	end
	return false
end
--是否触发被动效果：闪避1，被击打2 , 3治疗
function FightRole:HasTriggerSkillBySkill(skillID, hurtType)
	if self:GetBuffByType(10) ~= nil then
		return nil
	end
	if skillID.skillId > 0 then
		local skillInfo = SkillLevelData:objectByID(skillID)
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo ~= nil and skillInfo.trigger_hurtType == hurtType then
			return skillInfo
		end
	else
		if self:isCanNotTriggerBeiDong() then  --不触发被动buff
			return nil
		end
		local passiveSkillNum = #self.passiveSkill
		for i=1,passiveSkillNum do
			local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
			-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
			if skillInfo ~= nil and skillInfo.trigger_hurtType == hurtType then
				return skillInfo
			end
		end
	end
	return nil
end

function FightRole:getBuffByTriggerSkillId( skillId)
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffer = self.buffList:objectAt(i)
	for buffer in self.buffList:iterator() do
		if buffer.bValid and tonumber(buffer.config.value) == skillId then
			return buffer
		end
	end
	return nil
end

function FightRole:getChangeAttrSkill(attack , neili , agility)
	local attackAttr 	= attack --武力
	local neiliAttr 	= neili  --内力
	local agilityAttr 	= agility--身法
	-- local passiveSkillNum = #self.passiveSkill
	-- for i=1,passiveSkillNum do
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
	for i,skillID in ipairs(self.passiveSkill) do
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo ~= nil and skillInfo.type == 9 then
			
			if skillInfo ~= nil then
				local efftct_type = skillInfo.effect
				local value = skillInfo.effect_value
				if efftct_type == 1 then
					attackAttr = attackAttr + value * neiliAttr/100
					neiliAttr = 0
				elseif efftct_type == 2 then
					neiliAttr = neiliAttr + value * attackAttr/100
					attackAttr = attackAttr
				elseif efftct_type == 3 then
					attackAttr = attackAttr + value * agilityAttr/100
					agilityAttr = 0
				end
				attackAttr = math.floor(attackAttr)
				neiliAttr = math.floor(neiliAttr)
				break
				-- return math.floor(attackAttr) , math.floor(neiliAttr) 
			end
		end
	end
	for buffer in self.buffList:iterator() do
		if buffer.bValid and tonumber(buffer.config.type) == EnumFightBufferType.type_96 then
			if (buffer.fromTarget:GetBuffByType(EnumFightBufferType.type_95)) then
				attackAttr = attackAttr + math.floor(buffer.fromTarget:GetAttrNum(EnumAttributeType.Magic) * tonumber(buffer.config.value) / 100)	
			end
		end
	end
	return attackAttr , neiliAttr
end


--是否触发被动效果：攻击次数 6
function FightRole:TriggerBeAttackSkill(effectValue)	
	-- print("------------TriggerBeHurtUseSkill------")
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return false
	end
	if self:HaveTriggerType6AttackBuff() then
		return false
	end
	if FightManager:GetCurrAction() ~= nil and FightManager:GetCurrAction().actionInfo.bBackAttack then
		return false
	end
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillInfo.type == 7 and skillInfo.trigger_hurtType == 6 then
			local random = self.attackNum
			if random >= skillInfo.triggerSkill_rate then
				effectValue.skillId = skillInfo.triggerSkill
				effectValue.level 	= skillInfo.level
				-- effectValue = {skillId = skillInfo.triggerSkill,level = skillInfo.level}
				-- print("触发 技能 ",effectValue)
				-- self.attackNum = 0
				return true
			end
		end
	end
	return false
end


function FightRole:isCanNotTriggerBeiDong()
	local buffTypeList = self:GetBuffListByType({63, 86, EnumFightBufferType.type_509})
	if buffTypeList[63] then--损心
		return true
	end
	if buffTypeList[86] then --诛心
		return true
	end
	if buffTypeList[EnumFightBufferType.type_509] then --诛心
		return true
	end
	return false
end

function FightRole:isConsumptionAngerManual()
	local mark = 4
	return (mark == bit_and(self.nConsumptionSkillRelease, mark))
end

function FightRole:setConsumptionSkillReleaseState(isAdd , isAnger)
	local mark = 2
	if (isAnger) then
		--怒气技
		mark = 4
	end
	local num = mark
	if (not isAdd) then
		num = -num
	end
	self.nConsumptionSkillRelease = self.nConsumptionSkillRelease + num
	if (self.nConsumptionSkillRelease < 0) then
		self.nConsumptionSkillRelease = 0
	end
end

function FightRole:isConsumptionManual()
	local mark = 2
	return (mark == bit_and(self.nConsumptionSkillRelease, mark))
end

--神技
function FightRole:getAngerSkill()
	if (self.angerSkill) then
		return self.angerSkill
	end
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local _skillId = self.passiveSkill[i]
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(_skillId)
		if skillBaseInfo ~= nil and skillBaseInfo.hidden_skill == 3 then --红色侠客怒气
			self.angerSkill = {skillId = _skillId.skillId, level = _skillId.level}
			return self.angerSkill
		end
	end

	return nil
end
--东邪神技 透骨打穴法 (HD特有)
function FightRole:TriggerDongXie(targetInfo)
	
	-- if self:GetBuffByType(10) ~= nil then
	-- 	return false
	-- end
	if self:isCanNotTriggerBeiDong() then
		return false
	end
	local skillID = self:getAngerSkill()
	if skillID and skillID.skillId > 0 then
		local count = self:getTriggerSkillCountBySkill(skillID.skillId)
		if (count >= 2) then
			return false
		end
		local skillInfo = SkillLevelData:objectByID(skillID)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.trigger_hurtType == EnumFightTriggerHurtType.type_17 then
			local random = math.random(1, 10000)
			if (count <= 0) then
				random = 0
			end
			
			if random <= skillInfo.triggerSkill_rate then
				targetInfo.passiveEffect = 9
				targetInfo.passiveEffectValue = self.maxhp
				--
				
				return true
			else
				return false
			end
		end
	end
end

--buff触发时
function FightRole:fuHuoFeated()
	if self:HaveAnim("die") then
		self.armature:setColor(ccc3(255, 255, 255))
		self.armature:play("die", -1, -1, 0)
		self:setPosition(self.originPos)
		self:UpdateZOrder()
		return
	end
	self:playerDieTween()
end

--触发skillTypeList技能
function FightRole:TriggerSkill(skillTypeList, triggerHurtTypeList, addTriggerSkill, triggerEffectList, addEffectValue)
	
	local isCanNotBeiDong = self:isCanNotTriggerBeiDong()
	if (isCanNotBeiDong) then
		return
	end
	for i,skillType in ipairs(skillTypeList) do
		if (skillType == EnumFightSkillType.type_7) then
			--被动技能
			-- local passiveSkillNum = #self.passiveSkill
			-- for i=1,passiveSkillNum do
			for _,skillId in ipairs(self.passiveSkill) do
				local skillInfo 	= SkillLevelData:objectByID(skillId)
				-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
				if skillInfo ~= nil then
					for i,triggerHurtType in ipairs(triggerHurtTypeList) do
						if (triggerHurtType == skillInfo.trigger_hurtType) then
							local random = math.random(1, 10000)
							if random <= skillInfo.triggerSkill_rate then
								local _addTriggerSkill 					= {}
								_addTriggerSkill.skillId 				= skillInfo.triggerSkill
								_addTriggerSkill.level 					= skillInfo.level
								_addTriggerSkill.triggerSkillType 		= triggerHurtType

								table.insert( addTriggerSkill,_addTriggerSkill)
							end
						end
					end			
				end
			end
		else
		end
	end
	--
	if (#addTriggerSkill <= 0) then
		addTriggerSkill = nil
	end
	if (#addEffectValue <= 0) then
		addEffectValue = nil
	end
	return addTriggerSkill,addEffectValue
end

--技能触发次数 addCount正数为使用 负数为回复
function FightRole:addTriggerSkillCount(skillID, addCount, initNum)
	addCount = addCount or 1
	local temp = self.triggerPassiveSkillData[skillID] or 0
	temp = temp + addCount
	if (initNum) then
		temp = initNum
	end
	temp = math.max(0, temp)
	self.triggerPassiveSkillData[skillID] = temp
end

function FightRole:getTriggerSkillCountBySkill(skillID)
	return self.triggerPassiveSkillData[skillID] or 0
end

--技能触发 技能ID
function FightRole:TriggerSkillIdCount(skillID, special_num, isUse)
	-- local skillInfo = SkillLevelData:objectByID(skillID)
	-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
	if skillID and skillID ~= 0 then
		-- if skillBaseInfo.effect == effect then
			if self:getTriggerSkillCountBySkill(skillID) >= special_num then
				return false
			end
			if (isUse) then
				self:addTriggerSkillCount(skillID, 1)
			end
			return true
		-- end
	end
	return false
end
--触发技能计数相关
function FightRole:TrigerCountSkilleEffect(effect, skillInfo)
	-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.skillID)
	if skillInfo ~= nil then
		if skillInfo.effect == effect then
			self.specialSkillTime 	= self.specialSkillTime or 0
			self._specialSkillTime 	= self._specialSkillTime or 0
			if self.specialSkillTime + self._specialSkillTime >= skillInfo.special_num then
				return false
			end
			
			self.specialSkillTime = self.specialSkillTime + 1
			-- toastMessage(self.specialSkillTime.."-/-"..skillBaseInfo.special_num)
			return true
		end
	end
	return false
end

--skillID是否触发主动效果
function FightRole:TriggerActiveEffectList(skillID, activityEffectList, effectValue, newEffectValue)
	
	if self:GetBuffByType(10) ~= nil then
		return 0
	end
	local isBeiDong = self:isCanNotTriggerBeiDong()  --不触发被动buff
	
	if skillID.skillId > 0 then
		local skillInfo = SkillLevelData:objectByID(skillID)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(skillID)
		if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.type ~= 9 then
			--
			local _activeEffect = skillBaseInfo.effect
			if (_activeEffect == 23 or _activeEffect == 24 or _activeEffect == EnumFightSpellEffect.effect_70) then
				if (isBeiDong) then
					return 0
				end
			end
			--
			for i,activeEffect in ipairs(activityEffectList) do
				if _activeEffect == activeEffect then
					
					local random = math.random(1, 10000)
					if (skillInfo.trigger_hurtType == EnumFightTriggerHurtType.type_21) then
						newEffectValue 				= {}
						newEffectValue.value 		= skillInfo.triggerSkill_rate
						newEffectValue.activeEffect = skillInfo.triggerSkill
					end
					if activeEffect == EnumFightSpellEffect.effect_78 then
						effectValue.value = tonumber(skillBaseInfo.effect_rate)
						return activeEffect,newEffectValue
					end
					if random <= skillInfo.effect_rate then
						if effectValue ~= nil then
							effectValue.value = skillInfo.effect_value
							if activeEffect == 31 or activeEffect == EnumFightSpellEffect.effect_65 or activeEffect == EnumFightSpellEffect.effect_77 then
								effectValue.value = tonumber(skillBaseInfo.effect_value)
							end
						end
						return activeEffect,newEffectValue
					end
				end
			end
		end
	else
		if isBeiDong then  --不触发被动buff
			return 0
		end
		--
		local passiveSkillNum = #self.passiveSkill
		for i=1,passiveSkillNum do
			local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
			local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
			if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.type == 7 and skillBaseInfo.hidden_skill ~= 1 then
				--
				for i,activeEffect in ipairs(activityEffectList) do
					if (skillBaseInfo.effect == activeEffect) then
						--
						local random = math.random(1, 10000)
						if random <= skillInfo.effect_rate then
							if effectValue ~= nil then
								effectValue.value = skillInfo.effect_value
								if activeEffect == 31 or activeEffect == EnumFightSpellEffect.effect_65 or activeEffect == EnumFightSpellEffect.effect_77 then
									effectValue.value = tonumber(skillBaseInfo.effect_value)
								end
							end
							return activeEffect
						end
					end
				end
			end
		end
	end
	return 0
end

--
--是否触发被动效果：反弹5 反击6 化解7 复活9 免疫12 移魂13
function FightRole:TriggerPassiveEffectList(passiveEffectList, immuneList)
	-- immune = immune or 0
	immuneList = immuneList or {}
	if self:isCanNotTriggerBeiDong() then  --不触发被动buff
		return {}
	end
	local passivetList = {}
	local temp = {}
	for i,passiveEffect in ipairs(passiveEffectList) do
		local effectValue = {}
		if passiveEffect == 5 then
			local fantanBuff = self:GetBuffByType(19)
			if fantanBuff ~= nil then
				effectValue.value = fantanBuff.config.value
				temp[passiveEffect] = true
				passivetList[passiveEffect] = effectValue
			end
		
		elseif passiveEffect == 6 then
			local currAction = FightManager:GetCurrAction()
			if currAction ~= nil and currAction.actionInfo.bBackAttack then
				temp[passiveEffect] = true
				passivetList[passiveEffect] = effectValue
			end
		end
	end

	for i,skillID in ipairs(self.passiveSkill) do
		local skillInfo = SkillLevelData:objectByID(skillID)
		if skillInfo ~= nil and skillInfo.type == 7 then
			local effectValue = {}
			for i,passiveEffect in ipairs(passiveEffectList) do
				if (not temp[passiveEffect]) and skillInfo.effect == passiveEffect then
					local random = math.random(1, 10000)
					local immune = immuneList[passiveEffect] or 0
					if (passiveEffect == EnumFightSpellEffect.effect_85) then
						local triggerHp = math.floor(self.maxhp * skillInfo.effect_rate / 10000)
						if (self.currHp >= triggerHp) then
							if effectValue ~= nil then
								effectValue.value = math.floor(self.maxhp * skillInfo.effect_value / 100)
							end	
							passivetList[passiveEffect] = effectValue
						end
					elseif  random <= skillInfo.effect_rate + immune then
						if effectValue ~= nil then
							effectValue.value = skillInfo.effect_value
						end

						local bTrigger = true
						if skillInfo.trigger_hp > 0 and self.currHp / self.maxhp > skillInfo.trigger_hp / 100 then
							bTrigger = false
						else
							if passiveEffect == 13 then
								effectValue.value = skillInfo.attr_add
							end
						end

						if bTrigger then
							passivetList[passiveEffect] = effectValue
						end
					end
					break
				end
			end
		end
	end
	return passivetList
end

function FightRole:getSameBuffByType(buffType)
	local haveList = {}
	for buffer in self.buffList:iterator() do
		if buffer.bValid then
			if (buffer.config.type == buffType) then
				table.insert( haveList, buffer)
			end
		end
	end
	return haveList
end
-- function FightRole:addTest(buffType)
-- 	-- local nameImg = TFImage:create("icon/effect/"..name..".png")
-- 	FightManager.testList = FightManager.testList or {}
-- 	local nameImg = TFImage:create("icon/skill/33404.png")
-- 	if nameImg ~= nil then
-- 		-- self:MoveNameImage(nameImg)
-- 		local posX = self:getPosition().x
-- 		local posY = self:getPosition().y + 150
-- 		nameImg:setPosition(ccp(posX, posY))
-- 		local uiLayer = TFDirector:currentScene().fightUiLayer.ui

-- 		local richtextHB = uiLayer:getChildByName("ddddddddd"..self.logicInfo.posindex)
-- 		if (richtextHB ~= nil) then
-- 			uiLayer:removeChild(richtextHB)
-- 		end
-- 		nameImg:setScale(0.5)
-- 		uiLayer:addChild(nameImg)
-- 		nameImg:setName("ddddddddd"..self.logicInfo.posindex)
-- 		table.insert(FightManager.testList, nameImg)
-- 	end
-- end
return FightRole