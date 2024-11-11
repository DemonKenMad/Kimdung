--    script writer fei
--    creation time 2018.06.03
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

local fightRoleMgr  = require("lua.logic.fight.FightRoleManager")
local fightRoundMgr = require("lua.logic.fight.FightRoundManager")
local fightPublic 	= require("lua.logic.fight.FightPublic")
local BaseFightAction = class("BaseFightAction")

function BaseFightAction:ctor(actionInfo)
	self.bQuick = false
	self.hitAnimCount = nil
end

function BaseFightAction:Execute()
	if self.attackerRole == nil or self.attackerRole:IsLive(true) == false then
		return false
	end
	if self.attackerRole.ispet then
		self.attackerRole.rolePanel:setVisible(true)
	end

	if self.actionInfo.targetlist == nil then
		return false
	end

	local nTargetCount = #self.actionInfo.targetlist
	if nTargetCount == 0 then
		return false
	end

	local targetRole = fightRoleMgr:GetRoleByGirdIndex(self.actionInfo.targetlist[1].targetpos)
	if targetRole == nil then
		return false
	end

	self:OnActionStart()

	self.attackerRole:OnAttackBuffTrigger()

	if self.actionInfo.triggerType == 5 or self.actionInfo.triggerType == 6 then
		self.attackerRole:OnHelpAttackBuffTrigger()
	end

	self:ShowSkillNameEff()

	return true
end

function BaseFightAction:BeginAttack()
	local targetRole = self:GetTargetRole(1)
	self:AddAttackBuff()
	--
	self:onShowAttackAnim()
end

function BaseFightAction:ShowAttackAnim()
	--print("----------------------ShowAttackAnim->",self.skillDisplayInfo.attackAnim)
	
	local buffList = {79, 14}
	local haveBuffList = self.attackerRole:GetBuffListByType(buffList)
	local frozenBuff = haveBuffList[79]
	if frozenBuff ~= nil and haveBuffList[14] == nil then
		self.attackerRole:RemoveFrozenBuff()
	end
	if (not self.bQuick and self.skillDisplayInfo) then
		self.attackerRole:PlayAttackAnim(self.bNormalAttack, self.skillDisplayInfo.attackAnim)
	end
	self:skillTrigerAttack()

	self:ShowAttackerText()

	self:ShowXuliEff()

	self:ShowAttackEff()

	self:PlayAttackSound()

	self:ShowQianKunDaNuoYi()

	self:showHitXuliEff()

	self:ShowSpecilEffect()
	self:AddRoleHitNumber()

	self:addSkillAngel()
	self:onShowAttackAnimEnd()
end

function BaseFightAction:ShowHit(hitIndex)
	-- self.hitAnimCompleteRoleNum = 0
	local bLastHit = (hitIndex == self.hitCount)
	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bSkillShowFight then
	else
		if self.bEnemyAllDie and bLastHit then
			if (not self.bQuick) then
				if self.skillDisplayInfo and self.skillDisplayInfo.zoomIn == 0 then
					TFDirector:currentScene():ZoomIn(self.attackerRole)
				end
				fightRoleMgr:SetAllRoleSpeed(0.5)
			end
			TFDirector:currentScene().fightUiLayer:PlayFightEndEffect()
		end
	end

	local attackAddEnger 	= 0
	local hitAddEnger 		= 0
	local attackRedEnger 	= 0
	local hit_benemy 		= not self.attackerRole.logicInfo.bEnemyRole
	local nTargetCount 		= #self.actionInfo.targetlist
	local needAddRedAnger 	= false
	local needRemoveIndex 	= 0
	local tempRemoveBuffTag = false
	if (hitIndex == 1) then
		if (FightManager.log_fileName ) then
			local act = "  阵位: "..self.attackerRole.logicInfo.posindex.." "..self.attackerRole.logicInfo.name.."-->技能: "..self.actionInfo.skillid.skillId
			local actionCount = FightManager:GetFightCurrActionCount()
			Lua_fightWriteFile(EnumFight_Log.HP, nil, "动作: "..actionCount, act)
		end
		self:AddHelpManualAction();
	end
	--

	for i=1,nTargetCount do
		local targetInfo = self.actionInfo.targetlist[i - needRemoveIndex]
		local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)

		if targetInfo.hurtList[hitIndex] == nil then
			targetInfo.hurtList[hitIndex] = 0
		end
		local bHurtSkill 	= false	
		if targetInfo.effect == EnumFightHurtEffect.effect_1 or targetInfo.effect == EnumFightHurtEffect.effect_2 then
			if targetInfo.hurt < 0 then
				bHurtSkill = true
			elseif self.actionInfo.skillid.skillId ~= 0 and targetRole:GetBuffByType(64) and FightManager:GetFightType() ~= EnumFightType.Boss then
				bHurtSkill = true
				if bLastHit then
					targetRole:OnBuffTriggerByType(64)
				end
			end
		elseif targetInfo.effect == EnumFightHurtEffect.effect_4 or targetInfo.effect == EnumFightHurtEffect.effect_16 then
			local buff_81 = targetRole:GetBuffByType(81)
			if targetInfo.hurt < 0 and buff_81 then
				bHurtSkill = true
				if bLastHit then
					-- targetRole:OnBuffTriggerByType(81)
					targetRole:OnBuffTriggerByTypeInfo(buff_81)
				end
			end
		end
		if tempRemoveBuffTag == false and bLastHit and targetInfo.activeEffect == EnumFightActiveEffectType.effect_79 then
			local buffInfo = self.attackerRole:GetBuffByType(EnumFightBufferType.type_519)
			if(buffInfo) then
				self.attackerRole:OnBuffLastTypeTrigger(buffInfo, EnumFightBuffLastType.last_Type_3)
				tempRemoveBuffTag = true
			end
		end
		--受击昏睡buff解除
		if hitIndex == 1 then
			if bHurtSkill  then
				targetRole:RemoveBuffByType(15)
				targetRole:RemoveBuffByType(EnumFightBufferType.type_520)
			end
			
		end
		--
		local effect = targetInfo.effect
		local _ShowHitEffectFunc = self[ "ShowHitEffect_"..effect ]
		if _ShowHitEffectFunc then
			local _needAddRedAnger, _needRemoveIndex = _ShowHitEffectFunc( self , targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
			needAddRedAnger = _needAddRedAnger or needAddRedAnger
			needRemoveIndex = _needRemoveIndex or needRemoveIndex
		else
			effect = effect or "nil"
			toastMessage("not ShowHitEffect_"..effect)
		end
		--
		if (bLastHit) then
			local _ShowHitEffectEngerFunc = self[ "ShowHitEffect_Enger_"..effect ]
			if (_ShowHitEffectEngerFunc) then
				if (EnumFightActiveEffectType.effect_82 == targetInfo.passiveEffect) then
					--82免伤
					bHurtSkill = true
				end
				hitAddEnger, hit_benemy, attackAddEnger = _ShowHitEffectEngerFunc(self, targetRole, bLastHit, hitAddEnger, hit_benemy, attackAddEnger, bHurtSkill)
			end
			
		end
	end
	if (bLastHit) then
		self:AllHitEndTargetLogic()
		self:addEndAction()
		self:TriggerBuffAddBloodAction(EnumFightBufferType.type_515)
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
		if needAddRedAnger and self.actionInfo.triggerType ~= 5 and self.actionInfo.triggerType ~= 6 then
			if self.actionInfo.bBackAttack and self.actionInfo.triggerType ~= EnumFightTriggerHurtType.type_22 then
				attackRedEnger = math.max(attackRedEnger,fightPublic:GetCacheConstant("KillIdea.BackAttackAnger"))
			else
				if self.bNormalAttack then
					attackRedEnger = math.max(attackRedEnger,fightPublic:GetCacheConstant("KillIdea.AttackAnger"))
				else
					-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
					if skillBaseInfo and skillBaseInfo.hidden_skill ~= 3 then
						attackRedEnger = math.max(attackRedEnger,fightPublic:GetCacheConstant("KillIdea.SkillAttackAnger"))
					end
				end
			end
		end
		if skillBaseInfo then
			if (skillBaseInfo.trigger_hurtType == EnumFightTriggerHurtType.type_25) then
				self.attackerRole:addTriggerSkillCount(skillBaseInfo.triggerSkill, -1)
			end
		end
		--
		if attackAddEnger ~= 0 then
			self.attackerRole:AddCommonAnger(attackAddEnger)
		end
		if attackRedEnger ~= 0 then
			self.attackerRole:addRoleAnger(attackRedEnger)
		end
		if hitAddEnger ~= 0 then
			fightRoleMgr:AddAnger(hit_benemy,hitAddEnger, true)
		end
	end
end

function BaseFightAction:AddHelpManualAction()
	local bManualAction = self.actionInfo.bManualAction or self.actionInfo.bAngerManualAction	
	if (bManualAction) then
		local attackRoleList = fightRoleMgr:getHasBuffRole(self.attackerRole.logicInfo.bEnemyRole, EnumFightBufferType.type_517)
		local targetRoleList = fightRoleMgr:getHasBuffRole(not self.attackerRole.logicInfo.bEnemyRole, EnumFightBufferType.type_518)
		for buffTypeId, bEnemyRole in pairs(EnumFightManualActionAttackBuff) do	
			for attackRole in attackRoleList:iterator() do
				if (self.actionInfo.attackerpos ~= attackRole.logicInfo.posindex) then
					local info = {}
					info.attackRole     = attackRole
					info.targetList     = {}
	
					local tempList = {}
					for targetRole in targetRoleList:iterator() do
						if (not tempList[targetRole.logicInfo.posindex] and fightRoleMgr:IsSelfTeam(self.actionInfo.attackerpos, targetRole.logicInfo.posindex) == bEnemyRole) then
							local buffInfo = targetRole:GetBuffByType(buffTypeId)
							if (buffInfo) then
								local skillBaseInfo = BaseDataManager:GetSkillBaseInfo({skillId = tonumber(buffInfo.config.value), level = buffInfo.config.level})
								if (skillBaseInfo) then
									local skillInfo = attackRole:getBuffSkill(skillBaseInfo)
									info.skillid        = {skillId = skillInfo.id, level = buffInfo.config.level}
								else
									info.skillid        = {skillId = tonumber(buffInfo.config.value), level = buffInfo.config.level}
								end
								table.insert( info.targetList, targetRole )
								tempList[targetRole.logicInfo.posindex] = true
							end
						end
					end
					fightRoundMgr:setHelpAttackAction_New( info )
					-- fightRoundMgr:SetBackAttackAction(attackRole, nil, info.skillid, 0, info.targetList)
				end
			end
		end
		--
		local buffInfo = self.attackerRole:GetBuffByType(EnumFightBufferType.type_94)
		if (buffInfo) then
			local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.attackerRole.skillID)
			if (skillBaseInf and skillBaseInfo.replace_skill_id == self.actionInfo.skillid.skillId) then
				self.attackerRole:OnBuffTriggerByTypeInfo(buffInfo)
			end
		end
	end
end


function BaseFightAction:AddRoleHitNumber()
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
		local totalHurt = targetInfo.hurt
		if totalHurt < 0 then
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
			targetRole:addBeHurtNum()
		end
	end
end

function BaseFightAction:IsEnemyAllDie()
	if self.attackerRole.logicInfo.bEnemyRole then
		return false
	end
	local liveEnemyList = fightRoleMgr:GetAllLiveRole(true)
	local liveEnemyNum = liveEnemyList:length()
	if self.actionInfo.targetlist == nil then
		return false
	end
	local dieEnemyNumList = {}
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
		local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
		if targetRole ~= nil and targetRole:IsLive() and targetRole.logicInfo.bEnemyRole then
			if targetInfo.effect == EnumFightHurtEffect.effect_1 or targetInfo.effect == EnumFightHurtEffect.effect_2 then --普通受击和暴击
				local dunHurt = targetRole:hasDunBuff()
				local currHp = targetRole.currHp + targetInfo.hurt + dunHurt
				if currHp <= 0 and (targetInfo.passiveEffect ~= 9 and targetInfo.passiveEffect ~= 25 and 
				targetInfo.passiveEffect ~= 37 and targetInfo.passiveEffect ~= EnumFightActiveEffectType.effect_82) and 
				targetRole:GetBuffByType(56) == nil then
					-- dieEnemyNum = dieEnemyNum + 1
					dieEnemyNumList[targetInfo.targetpos] = true
				end
			end
		end
	end
	local dieEnemyNum = 0
	for k,v in pairs(dieEnemyNumList) do
		dieEnemyNum = dieEnemyNum + 1
	end
	if dieEnemyNum >= liveEnemyNum then
		return true
	else
		return false
	end
end


function BaseFightAction:addAttackNum()
	if self.actionInfo.bBackAttack then
		return
	end
	
	if self.actionInfo.triggerType and self.actionInfo.triggerType == 12 then 
		return
	end
	if self.actionInfo.skillid.skillId ~= 0 then
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
		if skillBaseInfo == nil then
			return
		end
		if skillBaseInfo.is_atk_count and skillBaseInfo.is_atk_count == 0 then
			return
		end
	end
	self.attackerRole:addAttackNum()
	fightRoleMgr:addAttackNum(self.attackerRole.logicInfo.bEnemyRole)
end

function BaseFightAction:setAttackSkill( ... )
	local effectValue = {}
	if self.attackerRole:TriggerBeAttackSkill(effectValue) and not fightRoundMgr:isHasRoleAttackSkill(self.attackerRole) then
		self.attackerRole.attackNum = 0
		fightRoundMgr:SetSkillTrgerSkillAction(self.attackerRole, effectValue, 4)
	end

end

--触发TriggerHurtType回血
function BaseFightAction:TriggerHurtTypeSkiAddBloodAction(triggerHurtType)
	--
	if (triggerHurtType == EnumFightTriggerHurtType.type_24) then
		if (self.actionInfo.bManualAction or self.actionInfo.bAngerManualAction ) then
		else
			return
		end
	end
	local attackRole,skillInfo = fightRoleMgr:GetSelfLiveRoleTriggerHurtType(self.attackerRole.logicInfo.bEnemyRole, triggerHurtType)
	if (skillInfo) then
		local addRoleList = fightRoundMgr:getTargetListBySkillInfo( skillInfo.target_type, skillInfo.target_num, attackRole )
		fightRoundMgr:setHurtAddSkill( attackRole ,{skillId = skillInfo.triggerSkill , level = skillInfo.level}, addRoleList )
	end
end
function BaseFightAction:TriggerBuffAddBloodAction(buffTypeId)
	--
	if (buffTypeId ~= EnumFightBufferType.type_515) then
		return 
	end
	if (self.actionInfo.bManualAction or self.actionInfo.bAngerManualAction ) then
	else
		return
	end
	local addHpRole,attackRole2,addHpBuff,buff2 = fightRoleMgr:GetAllHaveBuffRoleByType(buffTypeId)
	if (self.attackerRole.logicInfo.bEnemyRole) then
		addHpRole = attackRole2
		addHpBuff = buff2
	end

	if (addHpRole and addHpBuff) then
		local liveList = fightRoleMgr:GetAllLiveRole(self.attackerRole.logicInfo.bEnemyRole)
		for role in liveList:iterator() do
			local maxHp = role:getMaxHp()
			local currHp = role:getCurrHp(true)
			local dropHp = maxHp - currHp
			if dropHp > 0 then
				local addHp = math.floor(dropHp * addHpBuff.config.value / 100)
				local str = "buffTypeId : "..buffTypeId.."--回血 :"..addHp
				if (FightManager.log_fileName) then
					Lua_fightWriteFile(EnumFight_Log.HP, nil, "         "..str)
				end
			
				role:showFightHurtText(self.bQuick, addHp)
			end
		end
	end
end
function BaseFightAction:setHelpAttack()
	if fightRoundMgr.helpAttackList and fightRoundMgr.helpAttackList:length() > 0 then
		for v in fightRoundMgr.helpAttackList:iterator() do
			fightRoundMgr:setHelpAttackAction_New( v )
		end
		fightRoundMgr.helpAttackList:clear()
	end
	if fightRoundMgr.backAddAttackList and fightRoundMgr.backAddAttackList:length() > 0 then
		for v in fightRoundMgr.backAddAttackList:iterator() do
			for i,buffId in ipairs(EnumFightEnemyEndAttackBuff) do
				fightRoundMgr:setHelpAttackActionByBuff_New( v ,buffId)
			end
			-- fightRoundMgr:setHelpAttackActionByBuff_New( v ,68)
		end
		fightRoundMgr.backAddAttackList:clear()
	end
end

function BaseFightAction:skillTrigerAttack()
	if FightManager.isReplayFight then
		return
	end
	if not self:isSkillAction() then
		return
	end
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	if skillBaseInfo == nil then
		return
	end
	if skillBaseInfo.effect_triger and skillBaseInfo.effect_triger ~= "" then
		effect_triger = GetAttrByString(skillBaseInfo.effect_triger)
		if effect_triger then
			local triger3 = effect_triger[3]
			local triger4 = effect_triger[4]
			if triger3 or triger4 then
				local hasTriggerBuf = false
				local nTargetCount = #self.actionInfo.targetlist
				for i=1,nTargetCount do
					if self.actionInfo.targetlist[i].triggerBufferID ~= 0 then
						hasTriggerBuf = true
					end
				end
				if triger3 and triger3 ~= 0 then
					if hasTriggerBuf ==true then
						fightRoundMgr:SetSkillTrgerSkillAction(self.attackerRole, {skillId = triger3,level = self.actionInfo.skillid.level},3)
					end
				end
				if triger4 and triger4 ~= 0 then
					if hasTriggerBuf == false then
						fightRoundMgr:SetSkillTrgerSkillAction(self.attackerRole, {skillId = triger4,level = self.actionInfo.skillid.level},4)
					end
				end
			end
		end
	end
end


function BaseFightAction:isSkillAction()
	return self.actionInfo.skillid.skillId ~= 0
end


function BaseFightAction:GetHitNumber()
	self:GetHitCount()

	local hurtCount = self.hitCount
	if hurtCount == 0 then
		-- assert(false)
		return
	end
	local hurtList = {}
	self.reLiveTagList = {}
	-- local nTargetCount = #self.actionInfo.targetlist
	-- for i=1,nTargetCount do
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
	
		local totalHurt = targetInfo.hurt
		local activeEffect = targetInfo.activeEffect
		if activeEffect then
			if activeEffect == 26 then
				local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
				if targetRole then
					totalHurt = -targetRole.currHp
				end
			elseif activeEffect == 32 then
				targetInfo.hurt = targetInfo.hurt - targetInfo.activeEffectValue
				totalHurt = targetInfo.hurt
			elseif activeEffect == 33 then
				targetInfo.hurt = targetInfo.hurt - targetInfo.activeEffectValue
				totalHurt = targetInfo.hurt
			end
		end
		

		targetInfo.hurtList = {}
		if hurtCount == 1 then
			targetInfo.hurtList[1] = totalHurt
		else
			local targetpos = targetInfo.targetpos
			local _hurt = hurtList[targetpos] or 0
			_hurt = _hurt + totalHurt
			hurtList[targetpos] = _hurt
			if (targetInfo.passiveEffect == EnumFightActiveEffectType.effect_9 and self.reLiveTagList[targetpos] == nil) then
				local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetpos)
				if targetRole and targetRole:IsLive() then
					if (math.abs(_hurt) >= targetRole:getCurrHp()) then
						self.reLiveTagList[targetpos] = {tagIndex = i, value = targetInfo.passiveEffectValue}
					end
				end
			end
			-----------------------
			local singleHurt = math.floor(totalHurt/hurtCount)
			local nHurtLeft = totalHurt
			for j=1,hurtCount-1 do
				if singleHurt < 0 then
					local _singleHurt = math.abs(singleHurt)
					targetInfo.hurtList[j] = 0-math.floor(math.random(_singleHurt*0.8, _singleHurt))
				else
					targetInfo.hurtList[j] = math.floor(math.random(singleHurt*0.8, singleHurt))
				end
				nHurtLeft = nHurtLeft - targetInfo.hurtList[j]
			end

			if totalHurt < 0 and nHurtLeft > 0 then
				nHurtLeft = 0 
			end

			targetInfo.hurtList[hurtCount] = math.floor(nHurtLeft)
		end
	end
end

function BaseFightAction:_ShowHitEff(targetRole,index,targetIndex )
end

function BaseFightAction:CalculateInBufferTriggerRate(attackerRole,targetRole,config)
	if config == nil or config.value == "" then
		return 0
	end

	local bufferInfo = SkillBufferData:objectByID(tonumber(config.value))
	local bufRateSuppress = 0
	if bufferInfo.good_buff == 0 then
		if FightManager.fightBeginInfo.fighttype == 5 then
			bufRateSuppress = ClimbManager:getBufRateSuppress( attackerRole.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole )*100
			print("无量山战力压制 buff增加几率 = ",bufRateSuppress)
		elseif FightManager.fightBeginInfo.fighttype == 16 then
			bufRateSuppress = NorthClimbManager:getBufRateSuppress( attackerRole.logicInfo.bEnemyRole,targetRole.logicInfo.bEnemyRole )*100
			print("无量山战力压制 buff增加几率 = ",bufRateSuppress)
		end
	end


	local formula = config.buff_formula
	if formula == nil or formula == 0 then
		local result = config.buff_rate + bufRateSuppress
		print(" buff几率 = ",result)
		return result
	elseif formula == 1 then
		--[[
		角色技能：封印技能添加受技能等级影响的命中率计算规则。
		封印技能命中率 = （1-（目标等级- 技能等级）* 0.1） * 基础命中率（表格配置） 
		其中：7≥(目标等级 - 技能等级）≥-20
		命中率：从 30%-100% 之间波动
		]]
		local tmp = (targetRole.logicInfo.level - config.buff_level)
		tmp = math.min(7,tmp)
		tmp = math.max(-20,tmp)
		local result =(1 -  tmp * 0.1) * config.buff_rate + bufRateSuppress
			print(" buff几率 = ",result)
		return result
	end
end
--被动效果:反弹5 反击6 化解7 复活9 免疫12 受击加血50 表现
function BaseFightAction:ShowPassiveEffect(targetInfo)
	
end


function BaseFightAction:showTriggerSkill(targetInfo)
	self:_showTriggerSkill(targetInfo)
	self:showActiveTriggerSkill(targetInfo)
	self:showActiveTriggerSkill_mrll(targetInfo)
end

function BaseFightAction:_showTriggerSkill(targetInfo)
	-- self:showActiveTriggerSkill(targetInfo)
	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	if targetRole == nil then
		return
	end
	if targetInfo.triggerSkillType ==nil or targetInfo.triggerSkillType == 0 or targetInfo.triggerSkillType == 12 or targetInfo.triggerSkillType == EnumFightTriggerHurtType.type_22 then
		return
	end
	if targetInfo.triggerSkillType == 8 then
		targetRole.beHurtNum = 0
	end
	local buff = targetRole:getBuffByTriggerSkillId(targetInfo.triggerSkill.skillId)
	-- print("targetInfo.triggerSkill  buff= ",buff)
	if buff then
		targetRole:OnBuffTriggerByType(buff.config.type)
	end
	fightRoundMgr:SetBackAttackAction(targetRole, self.attackerRole, targetInfo.triggerSkill, targetInfo.triggerSkillType)
end

function BaseFightAction:showActiveTriggerSkill(targetInfo)

	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	if targetInfo.activeTriggerSkillType ==nil or targetInfo.activeTriggerSkillType == 0 or targetInfo.activeTriggerSkillType == 12 then
		return
	end
	--
	local attackerRole 	= nil
	if (targetInfo.activeTriggerSkillType == EnumFightTriggerHurtType.type_15) then
		--斗酒僧傀儡受击给斗酒僧加BUFF
		local roleId = targetRole:GetSummoned()
		if (roleId ~= 0) then
			attackerRole 	= fightRoleMgr:GetRoleById(targetRole.logicInfo.bEnemyRole, roleId)
			if (not attackerRole) then
				targetInfo.activeTriggerSkillType = 0
				targetInfo.activeTriggerSkill = {}
				return
			end
			if (attackerRole.logicInfo.roleId ~= roleId or targetRole.logicInfo.bEnemyRole ~= attackerRole.logicInfo.bEnemyRole) then
				--防止加错
				targetInfo.activeTriggerSkillType = 0
				targetInfo.activeTriggerSkill = {}
				return
			end
			if (attackerRole:isCanNotTriggerBeiDong()) then
				targetInfo.activeTriggerSkillType = 0
				targetInfo.activeTriggerSkill = {}
				return
			end
			targetRole 		= attackerRole
		else
			targetInfo.activeTriggerSkillType = 0
			targetInfo.activeTriggerSkill = {}
			return
		end	
	else
		attackerRole 	= self.attackerRole
		local buff = self.attackerRole:getBuffByTriggerSkillId(targetInfo.activeTriggerSkill.skillId)
		-- print("targetInfo.activeTriggerSkill  buff= ",buff)
		if buff then
			self.attackerRole:OnBuffTriggerByType(buff.config.type)
		end
	end
	fightRoundMgr:SetBackAttackAction(attackerRole, targetRole, targetInfo.activeTriggerSkill, targetInfo.activeTriggerSkillType, true)
	-- fightRoundMgr:SetSkillTrgerSkillAction(self.attackerRole, targetInfo.activeTriggerSkill,targetInfo.activeTriggerSkillType)
	-- fightRoundMgr:SetBackAttackAction(attackerRole, self.attackerRole,targetInfo.activeTriggerSkill,targetInfo.activeTriggerSkillType)
end
--慕容龙城
function BaseFightAction:showActiveTriggerSkill_mrll(targetInfo)

	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	if targetRole == nil then
		return
	end
	if targetInfo.triggerSkillType == nil or targetInfo.triggerSkillType ~= 12 then
		return
	end
	-- local buff = targetRole:GetBuffByType(83)
	-- print("targetInfo.activeTriggerSkill  buff= ",buff)
	-- if buff then
	-- 	targetRole:OnBuffTriggerByType(buff.config.type)
	-- end
	fightRoundMgr:SetBackAttackAction(targetRole, self.attackerRole,targetInfo.triggerSkill,targetInfo.triggerSkillType)
end


--主动效果:吸怒1 减敌怒2 增己怒3 吸血4 侧击8 净化10 致死11 七伤拳21 表现
function BaseFightAction:ShowActiveEffect(targetInfo)
	
end

function BaseFightAction:OnRoleHitAnimComplete()
	
end

function BaseFightAction:AddBuffToTarget(attackRole, targetRole, bufferID, level, hurt)
	if targetRole == nil or (not targetRole:IsLive()) then
		return false
	end

	if bufferID > 0 then
		return targetRole:AddBuff(attackRole, bufferID, level, hurt)
	end
	return false
end

function BaseFightAction:GetTargetRole(index)
	if self.actionInfo.targetlist == nil then
		return nil
	end


	local targetInfo = self.actionInfo.targetlist[index]
	if targetInfo == nil then
		return nil
	end

	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	return targetRole
end

function BaseFightAction:ShowSpecilEffect()
	self:ShowXiXinDaFaEffect()
	self:ShowXiXinDaFa_linghuchong_Effect()
end

function BaseFightAction:ShowXiXinDaFa_linghuchong_Effect()
  
	-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	local skillInfo = SkillLevelData:objectByID(self.actionInfo.skillid)
	if skillInfo == nil then
		return
	end
	if skillInfo.effect ~= 23 then
		return
	end
	-- local nTargetCount = #self.actionInfo.targetlist
	-- for i=1,nTargetCount do
	-- 	local targetInfo = self.actionInfo.targetlist[i]
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
		if targetInfo.activeEffect == 23 and targetInfo.triggerBufferID ~= 0 then
			if self:AddBuffToTarget(self.attackerRole,self.attackerRole, tonumber(skillInfo.effect_value),self.actionInfo.skillid.level) then
				self:AddBuffInfoToServer(self.attackerRole, self.attackerRole, tonumber(skillInfo.effect_value), 0)
			end
			return
		end
	end
end

function BaseFightAction:AddBuffInfoToServerByFanTan(fromRole, targetRole, bufferID, triggerBuffID)
	local buffInfo = {}
	buffInfo[1] = fromRole.logicInfo.posindex
	buffInfo[2] = targetRole.logicInfo.posindex
	buffInfo[3] = triggerBuffID
	buffInfo[4] = self.actionInfo.skillid.skillId
	buffInfo[5] = self.actionInfo.skillid.level
	buffInfo[6] = bufferID
	buffInfo[7] = self.actionInfo.skillid.level

	if self.actionInfo.skillid.skillId == 0 then
	-- local passiveSkillNum = #targetRole.passiveSkill
		-- for i=1,passiveSkillNum do
		for i,skillID in ipairs(targetRole.passiveSkill) do
			local skillInfo = SkillLevelData:objectByID(skillID)
			if skillInfo ~= nil then
				if  skillInfo.buff_id == bufferID then
					buffInfo[4] = skillInfo.id
					buffInfo[5] = skillInfo.level
				else
					if skillInfo.effect == 25 and tonumber(skillInfo.effect_value) == bufferID then
						buffInfo[4] = skillInfo.id
						buffInfo[5] = skillInfo.level
					end
				end
			end
		end
	else
		buffInfo[4] = self.actionInfo.skillid.skillId
		buffInfo[5] = self.actionInfo.skillid.level
	end

	local num = #self.actionInfo.buffList
	self.actionInfo.buffList[num+1] = buffInfo
end


function BaseFightAction:__AddBuffInfoToServer(fromRole, targetRole, skillId,level,bufferID, triggerBuffID)
	local buffInfo = {}
	buffInfo[1] = fromRole.logicInfo.posindex
	buffInfo[2] = targetRole.logicInfo.posindex
	buffInfo[3] = triggerBuffID
	buffInfo[4] = skillId
	buffInfo[5] = level
	buffInfo[6] = bufferID
	buffInfo[7] = level

	local num = #self.actionInfo.buffList
	self.actionInfo.buffList[num+1] = buffInfo
end

function BaseFightAction:AddBuffInfoToServer(fromRole, targetRole, bufferID, triggerBuffID)
	local buffInfo = {}
	buffInfo[1] = fromRole.logicInfo.posindex
	buffInfo[2] = targetRole.logicInfo.posindex
	buffInfo[3] = triggerBuffID
	buffInfo[4] = self.actionInfo.skillid.skillId
	buffInfo[5] = self.actionInfo.skillid.level
	buffInfo[6] = bufferID
	buffInfo[7] = self.actionInfo.skillid.level

	if self.actionInfo.skillid.skillId == 0 then
		local passiveSkillNum = #fromRole.passiveSkill
		for i=1,passiveSkillNum do
			local skillInfo = SkillLevelData:objectByID(fromRole.passiveSkill[i])
			if skillInfo ~= nil then
				if  skillInfo.buff_id == bufferID then
					buffInfo[4] = skillInfo.id
					buffInfo[5] = skillInfo.level
				else
					if skillInfo.effect == 25 and tonumber(skillInfo.effect_value) == bufferID then
						buffInfo[4] = skillInfo.id
						buffInfo[5] = skillInfo.level
					end
				end
			end
		end
	else
		buffInfo[4] = self.actionInfo.skillid.skillId
		buffInfo[5] = self.actionInfo.skillid.level
	end

	local num = #self.actionInfo.buffList
	self.actionInfo.buffList[num+1] = buffInfo
end
function BaseFightAction:AddBuSiBuffInfoToServer(fromRole, targetRole, bufferID, triggerBuffID)
	local buffInfo = {}
	buffInfo[1] = fromRole.logicInfo.posindex
	buffInfo[2] = targetRole.logicInfo.posindex
	buffInfo[3] = triggerBuffID
	buffInfo[4] = 0
	buffInfo[5] = 0
	buffInfo[6] = bufferID
	buffInfo[7] = 0

	local passiveSkillNum = #fromRole.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(fromRole.passiveSkill[i])
		if skillInfo ~= nil then
			if skillInfo.effect == 25 and tonumber(skillInfo.effect_value) == bufferID then
				buffInfo[4] = skillInfo.id
				buffInfo[5] = skillInfo.level
				buffInfo[7] = skillInfo.level
			end
		end
	end

	if buffInfo[4] == 0 then
		return
	end
	local num = #self.actionInfo.buffList
	self.actionInfo.buffList[num+1] = buffInfo
end
function BaseFightAction:AddBuffInBeginToServer(buffInfo)

	local num = #self.actionInfo.buffList
	self.actionInfo.buffList[num+1] = buffInfo
end

function BaseFightAction:setHurtAddBloodAction()
	---
	local haveRoleList = fightRoleMgr:getHasTriggerHurtTypeRole(EnumFightTriggerHurtType.type_25)
	for i,roleInfo in ipairs(haveRoleList) do
		local role = roleInfo.role
		local skillInfo = roleInfo.skillInfo
		if role and skillInfo and math.floor(role.currHp/role.maxhp*10000) < skillInfo.triggerSkill_rate then
			local _skillInfo = SkillLevelData:objectByID({skillId = skillInfo.triggerSkill, level = skillInfo.level})
			if (_skillInfo) then
				local useCount = role:getTriggerSkillCountBySkill(_skillInfo.id)
				if useCount < tonumber(skillInfo.special_num) then
					fightRoundMgr:setHurtAddSkill( role ,{skillId = _skillInfo.id , level = _skillInfo.level}, {role} )
				end
			end
		end
	end
	---
	local targetInfo = self.actionInfo.targetlist[1]
	local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
	-- local hurtAddRole , skillInfo= fightRoundMgr:IsHaveHurtAddHpRole(targetRole)
	-- self:TriggerHurtTypeSkiAddBloodAction(EnumFightTriggerHurtType.type_24)
	local hurtAddRoleList = fightRoundMgr:IsHaveHurtAddHpRole(targetRole)
	if hurtAddRoleList == nil or hurtAddRoleList:length() <= 0 then
		return
	end
	-- fightRoundMgr.hurtAddBloodActionList:clear()
	for v in hurtAddRoleList:iterator() do
		local hurtAddRole = v.role
		local skillInfo = v.skillInfo
		if hurtAddRole == nil or fightRoleMgr:IsSameSide({self.attackerRole,hurtAddRole}) then
		else
			local specialTime = hurtAddRole.specialSkillTime or 0
			if specialTime >= tonumber(skillInfo.special_num) then
			else
				local addRoleList = {}
				local num = #self.actionInfo.targetlist
				for i=1,num do
					local _targetInfo = self.actionInfo.targetlist[i]
					if _targetInfo.effect == EnumFightHurtEffect.effect_1 or _targetInfo.effect == EnumFightHurtEffect.effect_2 or 
					_targetInfo.effect == EnumFightHurtEffect.effect_6 or _targetInfo.effect == EnumFightHurtEffect.effect_9 then
						local _targetRole = fightRoleMgr:GetRoleByGirdIndex(_targetInfo.targetpos)
						if _targetRole.currHp > 0 and fightRoleMgr:IsSameSide({_targetRole,hurtAddRole}) and  math.floor(_targetRole.currHp/_targetRole.maxhp*10000) < skillInfo.triggerSkill_rate then
							if specialTime < tonumber(skillInfo.special_num) then
								addRoleList[#addRoleList+1] = _targetRole
								specialTime = specialTime + 1
							end
						end
					end
				end
				if #addRoleList > 0 then
					fightRoundMgr:setHurtAddSkill( hurtAddRole ,{skillId = skillInfo.triggerSkill , level = skillInfo.level}, addRoleList )
				end
			end
		end
	end
end

--主动效果:吸怒1 减敌怒2 增己怒3 吸血4 侧击8 净化10 致死11 七伤拳21 表现
function BaseFightAction:ShowActiveEffectHitEnd()
	-- local nTargetCount = #self.actionInfo.targetlist
	-- for i=1,nTargetCount do
	-- 	local targetInfo = self.actionInfo.targetlist[i]
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
		if targetInfo.effect == 1 or targetInfo.effect == 2 or targetInfo.effect == 4 or targetInfo.effect == 5 or targetInfo.effect == 7 or targetInfo.effect == EnumFightHurtEffect.effect_16 then 
			local effect = targetInfo.activeEffect
			local effectValue = targetInfo.activeEffectValue
			if effect == 31 or effect == EnumFightActiveEffectType.effect_65 then
				self.attackerRole.specialSkillTime = self.attackerRole.specialSkillTime or 0
				self.attackerRole.specialSkillTime = self.attackerRole.specialSkillTime - effectValue
				self.attackerRole.specialSkillTime = math.max(self.attackerRole.specialSkillTime ,0)
			elseif effect == EnumFightActiveEffectType.effect_78 then
				if (self.actionInfo.bManualAction or self.actionInfo.bAngerManualAction) then
					self.attackerRole:addTriggerSkillCount(self.attackerRole.skillID.skillId, -effectValue)
				end
			end
		end
	end
	--
	self:attackDieAddBuff()
end

function BaseFightAction:addSkillAngel()
	local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.actionInfo.skillid)
	-- local skillInfo = SkillLevelData:objectByID(self.actionInfo.skillid)
	if skillBaseInfo == nil then
		return
	end
	if skillBaseInfo.anger_add and skillBaseInfo.anger_add ~= 0 then
		fightRoleMgr:AddAnger( self.attackerRole.logicInfo.bEnemyRole,skillBaseInfo.anger_add)
	end
end

--99 金蛇游身
function BaseFightAction:ShowBuffPassiveEffect(targetRole)
	if targetRole == nil then
		return false
	end
	local buffInfo = targetRole:GetBuffByType(EnumFightBufferType.type_99)
	if (buffInfo) then
		-- targetRole:OnBuffTriggerByType(EnumFightBufferType.type_99)
		targetRole:OnBuffTriggerByTypeInfo(buffInfo)
		-- fightRoleMgr:AddAnger(not targetRole.logicInfo.bEnemyRole, -buffInfo.config.value)
		if (targetRole.logicInfo.bEnemyRole ~= self.attackerRole.logicInfo.bEnemyRole) then
			fightRoleMgr:AddAnger(not targetRole.logicInfo.bEnemyRole, -buffInfo.config.value)
			self.attackerRole:ShowEffectName("jiannu_1")
		end
		return true
	end
	return false
end


function BaseFightAction:addEndAction()
	local removeEffectList = {
		[EnumFightHurtEffect.effect_3] = true,
		[EnumFightHurtEffect.effect_11] = true,
		[EnumFightHurtEffect.effect_12] = true,
		[EnumFightHurtEffect.effect_13] = true,
		[EnumFightHurtEffect.effect_14] = true,
		[EnumFightHurtEffect.effect_15] = true,
	}
	local attackRole1,attackRole2,buff1,buff2 = fightRoleMgr:GetAllHaveBuffRoleByType(EnumFightBufferType.type_511)
	if (attackRole1 or attackRole2) then
	
		local targetList = {}
		local firstEnemy = nil
		local tempList = {}
		for i, targetInfo in ipairs(self.actionInfo.targetlist) do
			local effect = targetInfo.effect
			local baseHurt = targetInfo.hurt
			if (not removeEffectList[effect] and baseHurt < 0) then
				local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
				if (targetRole and targetRole:IsLive() and tempList[targetInfo.targetpos] == nil) then
					if (firstEnemy == nil) then
						firstEnemy = targetRole.logicInfo.bEnemyRole
					end
					targetList[targetRole.logicInfo.bEnemyRole] = targetList[targetRole.logicInfo.bEnemyRole] or {}
					tempList[targetInfo.targetpos] = true
					table.insert( targetList[targetRole.logicInfo.bEnemyRole], targetRole)					
				end
			end
		end
		local info1 = nil
		if (attackRole1 and targetList[false]) then
			info1 = {attackIndex = attackRole1.logicInfo.posindex, skillID = {skillId =tonumber(buff1.config.value), level = buff1.config.level},
			targetList = targetList[attackRole1.logicInfo.bEnemyRole], buffTypeId = buff1.config.type }
		end
		local info2 = nil
		if (attackRole2 and targetList[true]) then
			info2 = {attackIndex = attackRole2.logicInfo.posindex, skillID = {skillId =tonumber(buff2.config.value), level = buff2.config.level},
			targetList = targetList[attackRole2.logicInfo.bEnemyRole], buffTypeId = buff2.config.type }
		end
		if (firstEnemy == true) then
			fightRoundMgr:AddEndAction(EnumFightEndActionSortLevel.level_1, info2)
			fightRoundMgr:AddEndAction(EnumFightEndActionSortLevel.level_1, info1)
		else
			fightRoundMgr:AddEndAction(EnumFightEndActionSortLevel.level_1, info1)
			fightRoundMgr:AddEndAction(EnumFightEndActionSortLevel.level_1, info2)
		end	
	end
end

--闪避
function BaseFightAction:ShowHitEffect_3(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end
--治疗加血
function BaseFightAction:ShowHitEffect_4(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end

--净化，去除目标所有减益buff 
function BaseFightAction:ShowHitEffect_5(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end

--乾坤挪移 
function BaseFightAction:ShowHitEffect_6(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)	
	return needAddRedAnger
end

--额外的加buff 
function BaseFightAction:ShowHitEffect_8(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end
function BaseFightAction:ShowHitEffect_9(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end


function BaseFightAction:ShowHitEffect_10(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end

--治疗加血 
function BaseFightAction:ShowHitEffect_11(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end

function BaseFightAction:ShowHitEffect_12(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end

function BaseFightAction:ShowHitEffect_13(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end

--酒桶召唤
function BaseFightAction:ShowHitEffect_14(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end

--金蛇 复活队友
function BaseFightAction:ShowHitEffect_15(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return needAddRedAnger
end

--治疗加净化
function BaseFightAction:ShowHitEffect_16(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	if hitIndex == 1 then
		targetRole:CleanBuff(self.attackerRole)
	end
	needAddRedAnger = self:ShowHitEffect_4(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill)
	return needAddRedAnger,needRemoveIndex
end

--普通受击和暴击 7:主动加buff
function BaseFightAction:ShowHitEffect_7(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return self:ShowHitEffect_1(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
end
function BaseFightAction:ShowHitEffect_2(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	return self:ShowHitEffect_1(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
end
function  BaseFightAction:ShowHitEffect_1(targetInfo, targetRole, needAddRedAnger, hitIndex, bLastHit, i, bHurtSkill, needRemoveIndex)
	needAddRedAnger = true
	return needAddRedAnger
end

function BaseFightAction:ShowHitEffect_fanzhi(targetInfo, targetRole, bLastHit)
	if (not targetRole:IsLive()) then
		return
	end
	local fanzhiBuffType = {28,38,39,65,88,91, EnumFightBufferType.type_507}
	if bLastHit and self.actionInfo.triggerType ~= 5 and targetInfo.effect ~= 7 and not self.attackerRole.ispet and not targetInfo.isExtra then
	-- if bLastHit and bHurtSkill then
		local haveBuffList = targetRole:GetBuffListByType(fanzhiBuffType)
		-- for i=1,#fanzhiBuffType do
		-- 	local buff_type = fanzhiBuffType[i]
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
				hitBuff =  haveBuffList[buff_type]--targetRole:GetBuffByType(buff_type)
				if hitBuff ~= nil then
					local buff_rate = self:CalculateInBufferTriggerRate(self.attackerRole, targetRole,hitBuff.config)
					local random = math.random(1, 10000)
					print("反制触发buff id== "..hitBuff.config.value.."buff_rate == "..buff_rate..",random == ",random)
					
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
							local effectValue = {}
							if (hitBuff.config.good_buff == 0 and self.attackerRole:TriggerPassiveEffect(EnumFightSpellEffect.effect_85, effectValue)) then
								self.attackerRole:ShowEffectName("jinghua")
							elseif self:AddBuffToTarget(targetRole,self.attackerRole, tonumber(hitBuff.config.value),hitBuff.config.buff_level) then
								self:AddBuffInfoToServer(targetRole, self.attackerRole, tonumber(hitBuff.config.value), hitBuff.config.id)
							end
						end
					end
					targetRole:OnBuffTriggerByType(buff_type)
				end
			end
		end
	end
end


function BaseFightAction:ShowHitEffect_Enger_7(targetRole, bLastHit, hitAddEnger, hit_benemy, attackAddEnger, bHurtSkill)
	return self:ShowHitEffect_Enger_1(targetRole, bLastHit, hitAddEnger, hit_benemy, attackAddEnger, bHurtSkill)
end
function BaseFightAction:ShowHitEffect_Enger_2(targetRole, bLastHit, hitAddEnger, hit_benemy, attackAddEnger, bHurtSkill)
	return self:ShowHitEffect_Enger_1(targetRole, bLastHit, hitAddEnger, hit_benemy, attackAddEnger, bHurtSkill)
end
--击打怒气相关
function BaseFightAction:ShowHitEffect_Enger_1(targetRole, bLastHit, hitAddEnger, hit_benemy, attackAddEnger, bHurtSkill)
	if bLastHit and self.actionInfo.triggerType ~= 5 and self.actionInfo.triggerType ~= 6 then
		if bHurtSkill then
			hitAddEnger = math.max(hitAddEnger,targetRole:AddOtherAnger(fightPublic:GetCacheConstant("Fight.HitAnger")))
			targetRole:addRoleAnger(fightPublic:GetCacheConstant("KillIdea.HitAnger"))
			hit_benemy = targetRole.logicInfo.bEnemyRole
			if self.actionInfo.bBackAttack then
				if targetRole:IsLive() then
					attackAddEnger = math.max(attackAddEnger,fightPublic:GetCacheConstant("Fight.BackAttackAnger"))
					if (self.actionInfo.triggerType == EnumFightTriggerHurtType.type_22) then
						attackAddEnger = attackAddEnger + math.max(attackAddEnger,fightPublic:GetCacheConstant("Fight.AttackAnger"))
					end
				else
					attackAddEnger = math.max(attackAddEnger,fightPublic:GetCacheConstant("Fight.BackAttackAnger"))
					attackAddEnger = attackAddEnger + fightPublic:GetCacheConstant("Fight.BackAttackDieAnger")
					self.attackerRole:addRoleAnger(fightPublic:GetCacheConstant("KillIdea.BackAttackDieAnger"))
				end
			else
				if self.bNormalAttack then
					if targetRole:IsLive() then
						attackAddEnger = math.max(attackAddEnger,fightPublic:GetCacheConstant("Fight.AttackAnger"))
					else
						attackAddEnger = math.max(attackAddEnger,fightPublic:GetCacheConstant("Fight.AttackAnger"))
						attackAddEnger = attackAddEnger + fightPublic:GetCacheConstant("Fight.AttackDieAnger")
						self.attackerRole:addRoleAnger(fightPublic:GetCacheConstant("KillIdea.AttackDieAnger"))
					end
				else
					if targetRole:IsLive() then
						attackAddEnger = math.max(attackAddEnger,fightPublic:GetCacheConstant("Fight.SkillAttackAnger"))
					else
						attackAddEnger = math.max(attackAddEnger,fightPublic:GetCacheConstant("Fight.SkillAttackAnger"))
						attackAddEnger = attackAddEnger + fightPublic:GetCacheConstant("Fight.SkillAttackDieAnger")
						self.attackerRole:addRoleAnger(fightPublic:GetCacheConstant("KillIdea.SkillAttackDieAnger"))
					end
				end
			end
		end
	end
	return hitAddEnger, hit_benemy, attackAddEnger
end

function BaseFightAction:HitTargetList()
	-- self:attackDieAddBuff()
end

--借尸伏毒
function BaseFightAction:attackDieAddBuff()
	local buffRole, skillInfo = fightRoleMgr:GetSelfLiveRolePassiveSkillInfoByEffect(not self.attackerRole.logicInfo.bEnemyRole, EnumFightSpellEffect.effect_80)
	if (buffRole == nil or skillInfo == nil) then
		return
	end
	for i,targetInfo in ipairs(self.actionInfo.targetlist) do
		if (targetInfo.hurt < 0 or targetInfo.passiveEffect == EnumFightActiveEffectType.effect_37) then
			local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetInfo.targetpos)
			if (targetRole and targetRole.logicInfo.bEnemyRole == buffRole.logicInfo.bEnemyRole) then
				if (targetRole.bActDie == true) then
					if self:AddBuffToTarget(buffRole,self.attackerRole, tonumber(skillInfo.effect_value),skillInfo.level) then
						self:__AddBuffInfoToServer(buffRole, self.attackerRole, skillInfo.id, skillInfo.level, tonumber(skillInfo.effect_value), 0)
					end
					if self:AddBuffToTarget(buffRole,self.attackerRole, tonumber(skillInfo.buff_id), skillInfo.level) then
						self:__AddBuffInfoToServer(buffRole, self.attackerRole, skillInfo.id, skillInfo.level, tonumber(skillInfo.buff_id), 0)
					end
				end
				targetRole.bActDie = nil
			end
		end
	end
end

--被动9复活在动作结算处理
function BaseFightAction:HitEndTargetReLive()
	--自身复活动作结束处理
	if (self.reLiveTagList) then
		for targetpos,tagInfo in pairs(self.reLiveTagList) do
			-- local targetInfo = self.actionInfo.targetlist[tagIndex]
			for i,targetInfo in ipairs(self.actionInfo.targetlist) do
				if (targetInfo.targetpos == targetpos) then
					local targetRole = fightRoleMgr:GetRoleByGirdIndex(targetpos)
					targetInfo.passiveEffect = EnumFightActiveEffectType.effect_9
					targetInfo.passiveEffectValue = tagInfo.value or 0
					fightPublic:FightPassiveEffect_9( false, self.attackerRole, targetRole , targetInfo, self)
					break
				else
					print("*******ERROR*******-->  targetpos：  ",targetpos, "  tagIndex:  ",tagIndex)
				end
			end
		end
	end
end



function BaseFightAction:pause()
end

function BaseFightAction:resume()
end

function BaseFightAction:ShowQianKunDaNuoYi()
end

function BaseFightAction:ShowHitEff(targetRole, targetIndex)
end

function BaseFightAction:ShowExtraBuffEff(targetRole, targetIndex)
end

function BaseFightAction:_ShowExtraEff(targetRole,index )
end

function BaseFightAction:ShowAttackerText()
end

function BaseFightAction:ShowXuliEff()
end

function BaseFightAction:_ShowAttackEff(index)

end

function BaseFightAction:PlayHitSound(hitIndex)

end
function BaseFightAction:PlayAttackSound()

end

function BaseFightAction:ShowAttackEff()
end

function BaseFightAction:OnActionStart()
	
end
function BaseFightAction:ShowSkillNameEff()
	
end

function BaseFightAction:AddAttackBuff()
	
end
function BaseFightAction:dispose()
end

function BaseFightAction:GetBuffDisplayId()
	return 0
end

function BaseFightAction:showHitXuliEff()

end
function BaseFightAction:_showHitXuliEff()

end

function BaseFightAction:ShowAllHit()
	
end

function BaseFightAction:GetHitCount()
	
end
-------------以下通用中转函数---------一定要继承的---------
function BaseFightAction:onShowAttackAnim()
	prtin("no extends onShowAttackAnim")
end
--
function BaseFightAction:onShowAttackAnimEnd()
	prtin("no extends onShowAttackAnimEnd")
end
--
function BaseFightAction:ShowXiXinDaFaEffect()
	prtin("no extends ShowXiXinDaFaEffect")
end
--
function BaseFightAction:AllHitEndTargetLogic()
	prtin("no extends AllHitEndTargetLogic")
end
-------------以上通用中转函数---------一定要继承的---------
return BaseFightAction