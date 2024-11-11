--
-- Author: Zippo
-- Date: 2013-12-05 17:34:18
--

local mapLayer = require("lua.logic.fight.MapLayer")
local FightRoleManager = {}

function FightRoleManager:CreateAllRole(roleList, roleLayer)
	FightManager:initFightLog()
	FightManager:ClearSkillCache()
	self.roleLayer = roleLayer

	self.map 			= {}
	self.summonedIndex 	= {}
	self.addHpPercentRole = {[true] = 0,[false] = 0}
	self.fullAnger = ConstantData:getValue("Fight.FullAnger")
	self.qwergqgq = 50
	self.enemyAnger = 0
	self.selfAnger = 0
	self:AddRoleAnger(true, FightManager.fightBeginInfo.angerEnemy+0.1 , true)
	self:AddRoleAnger(false, FightManager.fightBeginInfo.angerSelf+0.1, true)
	local nViewWidth = GameConfig.WS.width
	local boss_index = FightManager:getBossIndex()
	for k,v in pairs(roleList) do
		v.isboss = false
		for _,_index in pairs(boss_index) do
			local index = tonumber(_index)+8
			if index >= 9 and index ==  v.posindex then
				v.isboss = true
			end
		end
		local __isboss = false
		if FightManager.fightBeginInfo.fighttype == 10 or FightManager.fightBeginInfo.fighttype == 28 then
			__isboss = true
		end	
		if __isboss and v.posindex >= 9 then
			v.isboss = true
		end
		local fightRole = require("lua.logic.fight.FightRole"):new(v)
		if fightRole ~= nil and FightManager.bLoadError ~= true then
			roleLayer:addChild(fightRole.rolePanel)
			self.map[fightRole.logicInfo.posindex] = fightRole
			if (fightRole:GetSummoned() ~= 0) then
				self.summonedIndex[fightRole.logicInfo.bEnemyRole] = fightRole.logicInfo.posindex
			end
		else
			return
		end
		if __isboss and v.posindex >= 9 then
			fightRole:setScale(1.3)
		end
		
		if k < 9 then
			fightRole.rolePanel:setPositionX(-100)
		elseif k < 18 then
			fightRole.rolePanel:setPositionX(nViewWidth + 100)
		end
		
	end
	self:refreshMaxHp(true)
	
	self.hurtReport = {}

	self.enemyAttackTime = 0
	self.selfAttackTime = 0
end

function FightRoleManager:GetAnger(bEnemy)
	local selfAnger = 0
	local nValue = 0
	local nAnger = 17
	if (bEnemy) then
		-- nValue = self:GetValue(self.enemyAnger, false)
		nValue = self.enemyAnger
	else
		--  nValue = self:GetValue(self.selfAnger, false)
		nValue = self.selfAnger
	end
	return (nValue )
end

function FightRoleManager:GetValue(nValue, bAdd)
	-- local k1 = 1.1
	-- if (bAdd) then
	-- 	return nValue * k1
	-- end
	-- return nValue / k1
	-- local k1 = 1.1
	-- if (bAdd) then
	-- 	return nValue
	-- end
	-- return nValue
end

function FightRoleManager:AddRoleAnger(bEnemy, nValue, bMax)
	if (bEnemy) then
		if (bMax) then
			self.enemyAnger = nValue
		else
			self.enemyAnger = self.enemyAnger + nValue
		end
	else
		if (bMax) then
			self.selfAnger = nValue
		else
			self.selfAnger = self.selfAnger + nValue
		end
	end
	
	do return end
	-- local selfAnger = 0
	-- local enemyAnger = 0
	local nAnger = 0
	if (bEnemy) then
		if (bMax) then
			self.enemyAnger = self:GetValue(nValue + nAnger, true)
		else
			self.enemyAnger = self.enemyAnger + self:GetValue(nValue, true)
		end
		return 	
	end
	if (bMax) then
		self.selfAnger = self:GetValue(nValue + nAnger, true)
	else
		self.selfAnger = self.selfAnger + self:GetValue(nValue, true)
	end
	-- local aa = nValue.. " -- ".. self:GetAnger(false).. "   "..self.selfAnger.."\n"
	-- Lua_writeFile("x:\\aaa.txt", nil, aa)
	-- print(nValue, " -- ", self:GetAnger(false), "   ",self.selfAnger)
end
function FightRoleManager:addNewRoleIntoFight( roleInfo )
	roleInfo.isboss = false
	local fightRole = require("lua.logic.fight.FightRole"):new(roleInfo)
	if fightRole ~= nil then
		self.roleLayer:addChild(fightRole.rolePanel)
		self.map[fightRole.logicInfo.posindex] = fightRole
		if (fightRole:GetSummoned() ~= 0) then
			fightRole:SetRoleVisible(false)
			self.summonedIndex[fightRole.logicInfo.bEnemyRole] = fightRole.logicInfo.posindex
		end
		local mapHp = fightRole:GetAttrNum(1)
		fightRole.maxhp = mapHp
		fightRole.currHp = mapHp
		if (fightRole:GetSummoned() ~= 0) then
			fightRole:OnAddPermanentBuf()
		else
			self:refreshMaxHp()
			--
			if roleInfo.posindex < 9 then
				fightRole.rolePanel:setPositionX(-100)
			else
				local nViewWidth = GameConfig.WS.width
				fightRole.rolePanel:setPositionX(nViewWidth + 100)
			end	
			self.roleLayer:showOneRoleGotoScene(fightRole)
		end
	end
	
	return fightRole
end

function FightRoleManager:addHurtReport( attackerpos , hurt )
	if FightManager.isReplayFight then
		return
	end
	if hurt and hurt < 0 then
		self.hurtReport[attackerpos] = self.hurtReport[attackerpos] or 0
		self.hurtReport[attackerpos] = self.hurtReport[attackerpos] + math.abs(math.ceil(hurt))
	end
end

function FightRoleManager:refreshMaxHp(bInit)
	local fightType = FightManager.fightBeginInfo.fighttype
	for k,role in pairs(self.map) do
		local maxhp = role:GetAttrNum(1)
		if (bInit and maxhp > role.maxhp) then
			local bAdd = true
			if (fightType == EnumFightType.YanmenGuan or fightType == EnumFightType.FactionFight or fightType == EnumFightType.Dartcar or fightType == EnumFightType.JapanIsland) then
				bAdd = false
			end
			if (bAdd and role.logicInfo.posindex >= 9) then
				if (fightType == EnumFightType.Boss or fightType == EnumFightType.Wuling or fightType == EnumFightType.YanWu or fightType == EnumFightType.FactionFightShan or 
					fightType == EnumFightType.Knight) then
					bAdd = false
				end
			end
			if (bAdd) then
				local oldHp = role.currHp
				role.currHp = maxhp
				print(role.logicInfo.posindex, role.logicInfo.name," refreshMaxHp -->  old Hp: ",oldHp, "   currHp: ",role.currHp)
			end
		end
		role.maxhp = maxhp
	end
end
function FightRoleManager:dispose()
	for k,role in pairs(self.map) do
		role:dispose()
		role = nil
	end
	self.map = nil
	self.roleLayer = nil
	self.enemyAttackTime = nil
	self.selfAttackTime = nil
end

function FightRoleManager:OnRoundStart()
	for k,role in pairs(self.map) do
		role.haveAttack = false
		role:OnRoundChange()
	end
end

function FightRoleManager:OnAddPermanentBuf()
	for k,role in pairs(self.map) do
		role:OnAddPermanentBuf()
	end
end

function FightRoleManager:OnActionEnd(currAction)
	for k,role in pairs(self.map) do
		role:OnActionEnd(currAction)
	end
	for i,role in pairs(self.map) do
		for haveBuffId,buffId in pairs(EnumFightTeammateBuff) do
			local haveBuff = role:GetBuffByType(buffId)
			if (haveBuff) then
				if (FightManager:getFightRoundMgr():hasBuffByType(haveBuffId, role.logicInfo.bEnemyRole, true) == false) then
					role:RemoveBuffByInfo(haveBuff)
					role:CleanRemove()
				end
			end
		end
	end
end

-- function FightRoleManager:OnActionbuffType(enemy , buffType)
-- 	for k,role in pairs(self.map) do
-- 		if role:IsLive() and role.logicInfo.bEnemyRole == enemy then
-- 			role:OnBuffTrigger(buffType)
-- 		end
-- 	end
-- end

function FightRoleManager:OnActionbuffType(enemy1 ,buffTypeList1, enemy2 , buffTypeList2)
	for k,role in pairs(self.map) do
		if role:IsLive() then
			local buffList = {}
			if (role.logicInfo.bEnemyRole == enemy1) then
				buffList = buffTypeList1
			elseif (role.logicInfo.bEnemyRole == enemy2) then
				buffList = buffTypeList2
			end
			if (buffList) then
				for _,last_type in pairs(buffList) do
					role:OnBuffTrigger(last_type)
				end
			end
		end
	end
end

function FightRoleManager:RemoveRoleBuff(enemy1 ,buffTypeList1, enemy2 , buffTypeList2)
	for k,role in pairs(self.map) do
		if role:IsLive() then
			local buffList = {}
			if (role.logicInfo.bEnemyRole == enemy1) then
				buffList = buffTypeList1
			elseif (role.logicInfo.bEnemyRole == enemy2) then
				buffList = buffTypeList2
			end
			if (buffList) then
				for _,buffType in pairs(buffList) do
					role:RemoveBuffByType(buffType)
				end
			end
		end
	end
end

function FightRoleManager:isAbnormal()
	local abnormal = true

	local liveNum = 0
	for k,role in pairs(self.map) do
		if role:IsLive() then
			liveNum = liveNum + 1
			if role.isAbnormal == false then
				abnormal = false
			end
		end
	end

	if abnormal and liveNum >= 3 then
		CommonManager:showFightPluginErrorLayer()
	end
end

function FightRoleManager:OnActionStart()
	for k,role in pairs(self.map) do
		role:OnActionStart()
	end
end

function FightRoleManager:OnFightSpeedChange()
	for k,role in pairs(self.map) do
		role:SetSpeed(FightManager.fightSpeed)
	end
end

function FightRoleManager:SetAllRoleSpeed(speed)
	for k,role in pairs(self.map) do
		role:SetSpeed(speed)
	end
end

function FightRoleManager:GetRoleByGirdIndex(nGirdIndex)
	assert(nGirdIndex >= 0 and nGirdIndex < 20, "nGirdIndex ："..nGirdIndex)
	return self.map[nGirdIndex]
end

function FightRoleManager:GetPetByIndex(nGirdIndex)
	assert(nGirdIndex >= 1 and nGirdIndex < 3, "nGirdIndex ："..nGirdIndex)
	return self.map[nGirdIndex+17]
end


function FightRoleManager:GetRoleById(bEnemy,id)
	local temp = 0
	if bEnemy then
		temp = 1
	end
	for i=0 + temp*9,8 + temp*9 do
		if self.map[i] and self.map[i].logicInfo.roleId == id then
			return self.map[i] 
		end
	end
	return nil
end

function FightRoleManager:GetNormalAttackRole()
	local attackRole = nil 
	local maxAgility = -1 -- 身法
	for k,role in pairs(self.map) do
		local roleAgility = role:GetAttrNum(5)
		if role:IsLive() and (role:GetSummoned() == 0) and role:HaveForbidAttackBuff() == false and role.haveAttack == false and roleAgility > maxAgility then
			attackRole = role
			maxAgility = roleAgility
		end
	end
	return attackRole
end

function FightRoleManager:resetAllForbidAttackBuff()
	for k,role in pairs(self.map) do
		if role:IsLive() and role:HaveForbidAttackBuff() == false then
			return
		end
	end

	for k,role in pairs(self.map) do
		if role:IsLive() and role:HaveForbidAttackBuff() == true then
			role:removeForbidAttackBuff()
		end
	end
end

function FightRoleManager:GetSingleTarget(attackRole, bAttract)
	local targetList = {}
	if (bAttract) then
		targetList = self:GetAttractRole(attackRole, nil, 0)
		if (#targetList > 0) then
			return targetList
		end
	end
	local attackRolePos = attackRole.logicInfo.posindex
	local attackRoleRow = attackRole:GetRowIndex()

	local targetPosIndex = {}
	if attackRoleRow == 0 then
		targetPosIndex = {0, 1, 2, 3, 4, 5, 6, 7, 8}
	elseif attackRoleRow == 1 then
		targetPosIndex = {3, 4, 5, 0, 1, 2, 6, 7, 8}
	else
		targetPosIndex = {6, 7, 8, 3, 4, 5, 0, 1, 2}
	end


	for i=1,9 do
		local posIndex = targetPosIndex[i]
		if attackRolePos < 9 then
			posIndex = posIndex + 9
		end
		local role = self.map[posIndex]
		if role ~= nil and role:IsLive() and role:HaveFrozenBuff(false) == false then
			targetList[1] = role
			break
		end
	end

	return targetList
end

--全体目标
function FightRoleManager:GetScreenTarget(bEnemyRole)
	local liveList = self:GetAllLiveRole(bEnemyRole, false, true)
	local targetList = {}
	for role in liveList:iterator() do
		table.insert( targetList, role )
  	end
	return targetList
end


--全体目标
function FightRoleManager:GetBuffTarget(buff,bEnemyRole)
	local bufferInfo = SkillBufferData:objectByID(tonumber(buff.config.value))
	if bufferInfo == nil then
		return nil
	end
	local liveList = self:GetAllLiveRole(bEnemyRole, false, false)
	local liveNum = liveList:length()
	local targetList = {}
	for i=1,liveNum do
		local role = liveList:objectAt(i)
		if role:GetBuffByType(bufferInfo.type) then
			local num = #targetList
			targetList[num+1] = role
		end
	end

	return targetList
end


function FightRoleManager:GetRowTarget(attackRole , isenemy)
	if isenemy == nil then
		isenemy = true
	end
	local attackRolePos = attackRole.logicInfo.posindex
	local attackRoleRow = attackRole:GetRowIndex()
	local targetPosIndex = {}
	if attackRoleRow == 0 then
		targetPosIndex = {0, 1, 2, 3, 4, 5, 6, 7, 8}
	elseif attackRoleRow == 1 then
		targetPosIndex = {3, 4, 5, 0, 1, 2, 6, 7, 8}
	else
		targetPosIndex = {6, 7, 8,3, 4, 5, 0, 1, 2}
	end

	local targetList = {}
	for i=0,2 do
		for j=1,3 do
			local posIndex = targetPosIndex[i*3+j]
			if attackRolePos < 9 and isenemy then
				posIndex = posIndex + 9
			elseif attackRolePos >= 9 and not isenemy then
				posIndex = posIndex + 9	
			end
			local role = self.map[posIndex]
			if role ~= nil and role:IsLive() and role:HaveFrozenBuff(false) == false then
				local num = #targetList
				targetList[num+1] = role
			end
		end

		if #targetList > 0 then
			break
		end
	end

	return targetList
end

function FightRoleManager:GetSelfColumnTarget(attackRole)
	local targetList = {}

	local attackRolePos = attackRole.logicInfo.posindex
	local targetRoleColumn = attackRole:GetColumnIndex()

	local targetPosIndex = {}
	if targetRoleColumn == 0 then
		targetPosIndex = {0, 3, 6, 1, 4, 7, 2, 5, 8}
	elseif targetRoleColumn == 1 then
		targetPosIndex = {1, 4, 7, 0, 3, 6, 2, 5, 8}
	else
		targetPosIndex = {2, 5, 8, 0, 3, 6, 1, 4, 7}
	end

	for i=0,2 do
		for j=1,3 do
			local posIndex = targetPosIndex[i*3+j]
			if attackRolePos >= 9 then
				posIndex = posIndex + 9
			end
			local role = self.map[posIndex]
			if role ~= nil and role:IsLive() and role:HaveFrozenBuff(false) == false then
				local num = #targetList
				targetList[num+1] = role
			end
		end
		
		if #targetList > 0 then
			break
		end
	end
	return targetList
end

function FightRoleManager:GetColumnTarget(attackRole)
	local targetList = {}

	local attackRolePos = attackRole.logicInfo.posindex
	local singleTarget = self:GetSingleTarget(attackRole)

	local targetRoleColumn = 0
	if #singleTarget > 0 then
		targetRoleColumn = singleTarget[1]:GetColumnIndex()
		targetList[1] = singleTarget[1]
	else
		return targetList
	end

	local targetPosIndex = {0, 3, 6, 1, 4, 7, 2, 5, 8}
	if targetRoleColumn == 0 then
		targetPosIndex = {0, 3, 6, 1, 4, 7, 2, 5, 8}
	elseif targetRoleColumn == 1 then
		targetPosIndex = {1, 4, 7, 0, 3, 6, 2, 5, 8}
	else
		targetPosIndex = {2, 5, 8, 0, 3, 6, 1, 4, 7}
	end

	for i=0,2 do
		for j=1,3 do
			local posIndex = targetPosIndex[i*3+j]
			if attackRolePos < 9 then
				posIndex = posIndex + 9
			end
			local role = self.map[posIndex]
			if role ~= nil and role:IsLive() and role:HaveFrozenBuff(false) == false and role ~= singleTarget[1] then
				local num = #targetList
				targetList[num+1] = role
			end
		end
		
		if #targetList > 0 then
			break
		end
	end

	return targetList
end

function FightRoleManager:GetRandomTarget(bEnemy, targetNum)
	local targetList = {}
	local liveList = self:GetAllLiveRole(bEnemy, false, true)
	for i=1,targetNum do
		local liveNum = liveList:length()
		if liveNum > 0 then
			local randomIndex = math.random(1, liveNum)
			local num = #targetList
			targetList[num+1] = liveList:objectAt(randomIndex)
			liveList:removeObjectAt(randomIndex)
		end
	end
	return targetList
end

--我方随机两个 排除自己
-- param:
--		logicInfo	角色信息   s2c.FIGHT_BEGIN 中 FightRole信息
--		bEnemy 		是否敌人
--		targetNum	目标个数  t_s_spell 中 target_num 字段 
--		actionList 	动作队列
function FightRoleManager:GetRandomTargetDouble(logicInfo, bEnemy, targetNum, skillBaseInfo, actionList)
	local targetList 	= {}
	if (skillBaseInfo == nil) then
		return targetList
	end
	local liveList 		= self:GetAllLiveRole(bEnemy, false, true, true)
	-- local actionRoleList = TFArray:new()
	-- --
	-- local actionNum = actionList:length()
	-- for i=1,actionNum do
	-- 	local actionInfo = actionList:objectAt(i)
	-- 	if actionInfo.unExecute then
	-- 		local actionRole = self:GetRoleByGirdIndex(actionInfo.attackerpos)
	-- 		if (actionRole.bEnemyRole == logicInfo.bEnemyRole) then
	-- 			actionRoleList:push(actionRole)
	-- 		end
	-- 	end
	-- end
	-- 排除技能已经在队列中的侠客
	local removeList = {}
	for role in liveList:iterator() do
		if (role:GetSummoned() ~= 0) then
			table.insert( removeList, role )
		elseif(logicInfo.posindex == role.logicInfo.posindex) then
			-- liveList:removeObject(role)
			table.insert( removeList, role )
		else
			if (skillBaseInfo.hidden_skill == 3) then
				for actionInfo in actionList:iterator() do
					if actionInfo.bAngerManualAction and actionInfo.unExecute and actionInfo.attackerpos == role.logicInfo.posindex then
						-- liveList:removeObject(role)
						table.insert( removeList, role )
					end
				end
			else
				for actionInfo in actionList:iterator() do
					if actionInfo.bManualAction and actionInfo.unExecute and actionInfo.attackerpos == role.logicInfo.posindex then
						-- liveList:removeObject(role)
						table.insert( removeList, role )
					end
				end
			end
		end
	end
	for i,role in ipairs(removeList) do
		liveList:removeObject(role)
	end
	--
	liveNum_1 	= liveList:length()
	if (liveNum_1 <= 0) then
		--如果都有队列，排除傀儡，随机选取
		liveList = self:GetAllLiveRole(bEnemy, false, true, true)
	end
	--
	liveNum_1 	= liveList:length()
	if (liveNum_1 <= 0) then
		--如果场上没有人（或排除傀儡后场上没有人） 就选自己
		targetList[1] = self:GetRoleByGirdIndex(logicInfo.posindex)
		return targetList
	end
	for i=1,targetNum do
		local liveNum = liveList:length()
		if liveNum > 0 then
			local randomIndex = math.random(1, liveNum)
			local num = #targetList
			targetList[num+1] = liveList:objectAt(randomIndex)
			liveList:removeObjectAt(randomIndex)
		end
	end
	return targetList
end

function FightRoleManager:IsEnemyAllDie()
	for k,role in pairs(self.map) do
		if role.logicInfo.bEnemyRole and role:IsLive() then
			return false
		end
	end
	return true
end

function FightRoleManager:IsSelfAllDie()
	for k,role in pairs(self.map) do
		if role.logicInfo.bEnemyRole == false and role:IsLive() then
			return false
		end
	end
	return true
end

function FightRoleManager:GetAllLiveRole(bEnemy, bExcludeFullHp, bExcludeFrozenRole, bSummoned)
	local list = TFArray:new()
	for k,role in pairs(self.map) do
		local bValidRole = true
		if bExcludeFullHp and role.currHp == role.maxhp then
			bValidRole = false
		end

		if bExcludeFrozenRole and role:HaveFrozenBuff(false) then
			bValidRole = false
		end
		if role.ispet then
			bValidRole = false
		elseif (bSummoned and role:GetSummoned() ~= 0) then
			bValidRole = false
		end
		if bValidRole then
			if bEnemy then
				if role.logicInfo.bEnemyRole and role:IsLive() then
					list:pushBack(role)
				end
			else
				if role.logicInfo.bEnemyRole == false and role:IsLive() then
					list:pushBack(role)
				end
			end
		end
	end
	return list
end
function FightRoleManager:isAllHpPercent(bEnemy,percent)
	bEnemy = bEnemy or false
	for k,role in pairs(self.map) do
		if role.logicInfo.bEnemyRole == bEnemy and not role.ispet then
			if role:IsLive() == false or (role.currHp / role.maxhp)*100 < percent then
				return false
			end
		end
	end
	return true
end

--血量升序
function sortCurrentHpAsc(role1, role2)
	local full_1 = role1.currHp == role1.maxhp
	local full_2 = role2.currHp == role2.maxhp
	if full_1 == full_2 then
		if  (role1.currHp/role1.maxhp) > (role2.currHp/role2.maxhp) then
    	    return false
    	else
    	    return true
    	end
    else
    	if full_2 then
    		return true
    	else
    		return false
    	end
	end
end

--当前血量降序
function sortCurrentHpDesc(role1, role2)
	local full_1 = role1.currHp == role1.maxhp
	local full_2 = role2.currHp == role2.maxhp
	if full_1 == full_2 then
		if (role1.currHp/role1.maxhp) < (role2.currHp/role2.maxhp) then
    	    return false
    	else
    	    return true
    	end
    else
    	if full_1 then
    		return true
    	else
    		return false
    	end
	end
end

--防御降序
function sortDefenceDesc(role1, role2)
	if role1:GetAttrNum(3) < role2:GetAttrNum(3) then
        return false
    else
        return true
    end
end

--防御升序
function sortDefenceAsc(role1, role2)
	if role1:GetAttrNum(3) > role2:GetAttrNum(3) then
        return false
    else
        return true
    end
end

--内力降序
function sortMagicDesc(role1, role2)
	if role1:GetAttrNum(4) < role2:GetAttrNum(4) then
        return false
    else
        return true
    end
end

--内力升序
function sortMagicAsc(role1, role2)
	if role1:GetAttrNum(4) > role2:GetAttrNum(4) then
        return false
    else
        return true
    end
end

--[[
获得有效的目标
@return 有效的目标列表，返回的是TFArray
]]
function FightRoleManager:GetValidTargets(bEnemy)
	local list = TFArray:new()
	for k,role in pairs(self.map) do
		if role.logicInfo.bEnemyRole == bEnemy and role:IsValidTarget() then
			list:pushBack(role)
		end
	end
	if list:length() < 1 then
		for k,role in pairs(self.map) do
			if role.logicInfo.bEnemyRole == bEnemy and role:IsLive() then
				list:pushBack(role)
			end
		end
	end
	return list
end

--根据某属性获得目标角色
function FightRoleManager:GetTargetByAttr(attrType, bEnemy, bMax, roleNum, attackRole)
	local validTargets = self:GetValidTargets(bEnemy)
	--如果没有一个有效的目标则返回nil
	if not validTargets or validTargets:length() < 1 then
		return nil
	end

	function sort_function(role1,role2)
		if (bMax) then
			return role1:GetAttrNum(attrType) >= role2:GetAttrNum(attrType)
		else
			return role1:GetAttrNum(attrType) < role2:GetAttrNum(attrType)
		end
		-- if role1:GetAttrNum(attrType) < role2:GetAttrNum(attrType) and bMax then
		-- 	return false
		-- elseif role1:GetAttrNum(attrType) > role2:GetAttrNum(attrType) and bMax == false then
		-- 	return false
		-- else
		-- 	return true
		-- end
	end


	--属性排序，由变量bMax决定是降序还是升序
	if attrType == 1 then   --当前血量
		if bMax then
			validTargets:sort(sortCurrentHpDesc)
		else
			validTargets:sort(sortCurrentHpAsc)
		end
	else
		validTargets:sort(sort_function)
	end
	-- elseif attrType == 2 then
	-- 	if bMax then
	-- 		validTargets:sort(sortDefenceDesc)
	-- 	else
	-- 		validTargets:sort(sortDefenceAsc)
	-- 	end
	-- elseif attrType == 3 then
	-- 	if bMax then
	-- 		validTargets:sort(sortMagicDesc)
	-- 	else
	-- 		validTargets:sort(sortMagicAsc)
	-- 	end
	-- end
	local validCount = validTargets:length()
	local maxNum = math.min(roleNum,validCount)

	--转换为table表（sb）
	local tbl = {}
	local index = 0
	for v in validTargets:iterator() do
		if (attackRole ~= v) then
			--不选中自己
			index = index + 1
			tbl[index] = v
			if index >= maxNum then
				break
			end
		end
	end

	return tbl


	-- local bExcludeFullHp = false
	-- if attrType == 1 then
	-- 	bExcludeFullHp = true
	-- end

	-- local targetRole = {}
	-- local liveRole = self:GetValidTarget(bEnemy)
	-- local liveRoleNum = liveRole:length()
	-- if liveRoleNum == 0 then
	-- 	if bExcludeFullHp then
	-- 		liveRole = self:GetAllLiveRole(bEnemy, false, true)
	-- 	end
	-- end

	-- --由大到小排序
	-- if attrType == 1 then
	-- 	liveRole:sort(cmpHpFun)
	-- elseif attrType == 2 then
	-- 	liveRole:sort(cmpDefFun)
	-- end

	-- if bExcludeFullHp then
	-- 	local fullHpList = self:GetFullHpRole(bEnemy)
	-- 	for i=1,#fullHpList do
	-- 		liveRole:pushFront(fullHpList[i])
	-- 	end
	-- end

	-- liveRoleNum = liveRole:length()
	-- if liveRoleNum == 0 then
	-- 	return targetRole
	-- end

	-- if bMax then
	-- 	local i = 1
	-- 	local count = #targetRole
	-- 	while i <= liveRoleNum and count < roleNum do
 --        	targetRole[count+1] = liveRole:objectAt(i)
 --        	i = i + 1
 --        	count = #targetRole
 --    	end
 --    else
 --    	local i = liveRoleNum
	-- 	local count = #targetRole
	-- 	while i >= 1 and count < roleNum do
 --        	targetRole[count+1] = liveRole:objectAt(i)
 --        	i = i - 1
 --        	count = #targetRole
 --    	end
	-- end

	-- return targetRole
end

--目标自己及自己附带的召唤物
function FightRoleManager:GetSelfAndSummoned(attackRole, targetList, targetNum)
	-- local targetList 	= {attackRole}
	-- if (targetNum > 1) then
	-- 	local bEnemyRole 	= attackRole.logicInfo.bEnemyRole
	-- 	local roleId 		= attackRole.logicInfo.roleId
	-- 	for k,role in pairs(self.map) do
	-- 		if role:IsAlive() and role.logicInfo.bEnemyRole == bEnemyRole and role:GetSummoned() == roleId then
	-- 			table.insert( targetList, role )
	-- 			if (targetNum >= #targetList) then
	-- 				break
	-- 			end
	-- 		end
	-- 	end
	-- end
	local bEnemyRole 	= attackRole.logicInfo.bEnemyRole
	local roleId 		= attackRole.logicInfo.roleId
	for k,role in pairs(self.map) do
		local _targetNum = #targetList
		if (targetNum and _targetNum >= targetNum) then
			break
		end
		if role:IsAlive() and role.logicInfo.bEnemyRole == bEnemyRole and role:GetSummoned() == roleId then
			table.insert( targetList, role )
		end
	end

	return targetList
end

function FightRoleManager:GetFullHpRole(bEnemy)
	local fullHpList = {}
	for k,role in pairs(self.map) do
		if role.logicInfo.bEnemyRole == bEnemy and role.currHp == role.maxhp then
			fullHpList[#fullHpList+1] = role
		end
	end

	return fullHpList
end

function FightRoleManager:GetCharmActionTarget(attackRole , isfrozen)
	if isfrozen == nil then
		isfrozen = true
	end
	local target = nil 
	local maxHp = 0
	for k,role in pairs(self.map) do
		if (isfrozen or not role:HaveFrozenBuff(false) ) and role:IsLive() then
			if attackRole.logicInfo.bEnemyRole then
				if role.logicInfo.bEnemyRole and role.currHp > maxHp and attackRole ~= role then
					target = role
					maxHp = role.maxhp
				end
			else
				if role.logicInfo.bEnemyRole == false and role.currHp > maxHp and attackRole ~= role then
					target = role
					maxHp = role.maxhp
				end
			end
		end
	end
	return target
end

function FightRoleManager:GetDefianceTarget(attackRole)
	for k,role in pairs(self.map) do
		if role:IsLive() and attackRole.defianceTarget == role then
			return role
		end
	end
	return nil
end

function FightRoleManager:IsSameSide(roleList)
	local roleNum = #roleList
	if roleNum == 0 then
		return false
	end

	local side = roleList[1].logicInfo.bEnemyRole
	for i=2,roleNum do
		if roleList[i].logicInfo.bEnemyRole ~= side then
			return false
		end
	end
	--自己人
	return true
end

function FightRoleManager:GetEnemyMainRole()
	for k,role in pairs(self.map) do
		if role.logicInfo.bEnemyRole then
			role.logicInfo.skill1 = role.logicInfo.skill1 or 0
			role.logicInfo.skill2 = role.logicInfo.skill2 or 0
			if role.logicInfo.skill1 ~= 0 or role.logicInfo.skill2 ~= 0 then
				return role
			end
		end
	end
	return nil
end

function FightRoleManager:FindMinAnger( bEnemy )
	local min = 0
	local roleList = self:GetAllLiveRole(bEnemy)
	-- local length = roleList:length()
	-- for i=1,length do
	-- 	local role = roleList:objectAt(i)
	for role in roleList:iterator() do
		if role and role:IsLive() then
			local buff = role:GetBuffByType(77)
			if buff then
				min = math.max(min,buff.config.value)
				break
			end
		end
	end
	min = math.max(min, 0)
	return min
end

function FightRoleManager:AddAnger(bEnemy, angerNum,isGuanhuan)
	if not isGuanhuan then
		local liveList = self:GetAllLiveRole(not bEnemy)
		-- local liveNum = liveList:length()
	   	-- for i=1,liveNum do
		  -- 	local role = liveList:objectAt(i)
		for role in liveList:iterator() do
	  		local skillInfo = role:getTriggerSkillBySkillType(11)
	  		if skillInfo then
	  			local value = skillInfo.effect_value
				  angerNum = math.min(angerNum,value)
				  break
	  		end
	  	end
	end
	do
		local liveList = self:GetAllLiveRole(not bEnemy)
		-- local liveNum = liveList:length()
	   	-- for i=1,liveNum do
		-- local role = liveList:objectAt(i)
		for role in liveList:iterator() do
	  		local skillInfo = role:getPassiveSkillInfoByEffect(55)
	  		if skillInfo then
	  			local tbl = stringToNumberTable(skillInfo.effect_value,"_")
	  			local value = tbl[1]
	  			if angerNum > value then
	  				FightManager:getFightRoundMgr():SetSkillTrgerSkillAction(role, {skillId = skillInfo.id,level = skillInfo.level},0)
	  			end
	  		end
	  	end
	end
	-- if bEnemy then
	-- 	self.enemyAnger = self.enemyAnger + angerNum
	-- else
	-- 	self.selfAnger = self:AddAnger() + angerNum
	-- end
	local nValue = 0
	local fullAnger = self.fullAnger 
	self:AddRoleAnger(bEnemy, angerNum)
	local enemyAnger_min = self:FindMinAnger(true)
	local enemyAnger = self:GetAnger(true)
	-- self.enemyAnger = math.min(self:enemyAnger, self.fullAnger)
	-- self.enemyAnger = math.max(self.enemyAnger, enemyAnger_min)
	local minEnemyAnger = math.min(enemyAnger, fullAnger)
	-- self:AddRoleAnger(true, minEnemyAnger, true)
	local maxEnemyAnger = math.max(minEnemyAnger, enemyAnger_min)
	self:AddRoleAnger(true, maxEnemyAnger+ nValue, true)

	local selfAnger_min = self:FindMinAnger(false)
	
	local selfAnger = self:GetAnger(false)
	-- self.selfAnger = math.min(self.selfAnger, self.fullAnger)
	-- self.selfAnger = math.max(self.selfAnger, selfAnger_min)
	local minSelfAnger = math.min(selfAnger, fullAnger)
	-- self:AddRoleAnger(false, minEnemyAnger, true)
	local maxSelfAnger = math.max(minSelfAnger, selfAnger_min)
	self:AddRoleAnger(false, maxSelfAnger + nValue, true)
	if FightManager.isTiaoGuo then
		return
	end
	if not bEnemy and TFDirector:currentScene().fightUiLayer then
		TFDirector:currentScene().fightUiLayer:RefreshAngerBar()
	end
end

function FightRoleManager:OnExecuteAngerManualAction(actionInfo)
	local attackRole = self:GetRoleByGirdIndex(actionInfo.attackerpos)
	if attackRole == nil then
		return
	end

	-- if (attackRole.bConsumptionSkillRelease) then
	-- 	attackRole.angerSkillCD = 0
	-- 	attackRole.bConsumptionSkillRelease = false
	-- end
	if (attackRole:isConsumptionAngerManual()) then
		attackRole.angerSkillCD = 0
		attackRole:setConsumptionSkillReleaseState(false, true)
	else
		attackRole.angerSkillCD = attackRole.angerSkillMaxCD
	end
	if not attackRole.logicInfo.bEnemyRole then
		TFDirector:currentScene().fightUiLayer:OnExecuteAngerManualAction(actionInfo.attackerpos)
	end

	attackRole:RemoveBodyEffect("skill_yuyue")
end
function FightRoleManager:OnExecuteManualAction(actionInfo)
	local attackRole = self:GetRoleByGirdIndex(actionInfo.attackerpos)
	if attackRole == nil then
		return
	end

	attackRole.skillCD = attackRole:GetSkillCD()
	-- if (attackRole.bConsumptionSkillRelease) then
	-- 	attackRole.skillCD = 0
	-- 	attackRole.bConsumptionSkillRelease = false
	-- end
	if (attackRole:isConsumptionManual()) then
		attackRole.skillCD = 0
		attackRole:setConsumptionSkillReleaseState(false, false)
	end
	if not attackRole.logicInfo.bEnemyRole then
		TFDirector:currentScene().fightUiLayer:OnExecuteManualAction(actionInfo.attackerpos)
	end
	
	attackRole:RemoveBodyEffect("skill_yuyue")
end

function FightRoleManager:OnRemoveManualAction(actionInfo)
	local attackRole = self:GetRoleByGirdIndex(actionInfo.attackerpos)
	if attackRole == nil then
		return
	end
	if not attackRole.logicInfo.bEnemyRole then
		TFDirector:currentScene().fightUiLayer:OnExecuteManualAction(actionInfo.attackerpos)
	end

	attackRole:RemoveBodyEffect("skill_yuyue")
end
function FightRoleManager:OnRemoveAngerManualAction(actionInfo)
	local attackRole = self:GetRoleByGirdIndex(actionInfo.attackerpos)
	if attackRole == nil then
		return
	end

	if not attackRole.logicInfo.bEnemyRole then
		TFDirector:currentScene().fightUiLayer:OnExecuteAngerManualAction(actionInfo.attackerpos)
	end

	attackRole:RemoveBodyEffect("skill_yuyue")
end

function FightRoleManager:GetTotalHaloAttrAdd(bEnemyRole, attrIndex)
	local selfAttrAdd = 0
	local enemyAttrAdd = 0

	for k,role in pairs(self.map) do
		if role:IsLive(true) then
			for haloType, haloAttr in pairs(role.haloTypeList) do
				local haloAttrNum 	= haloAttr[attrIndex] or 0
				haloAttrNum 		= math.abs(haloAttrNum)
				if (haloAttrNum > 0) then
					if role.logicInfo.bEnemyRole then
						if haloType == 5 then --增益光环
							enemyAttrAdd = enemyAttrAdd + haloAttrNum
							-- print(role.logicInfo.name," 增益光环 属性:",attrIndex,"  ",haloAttrNum," 总加成: ",enemyAttrAdd)
						else
							selfAttrAdd = selfAttrAdd - haloAttrNum
							-- print(role.logicInfo.name," 减益光环 属性:",attrIndex,"  ",haloAttrNum," 总加成: ",selfAttrAdd)
						end
					else
						if haloType == 5 then --增益光环
							selfAttrAdd = selfAttrAdd + haloAttrNum
							-- print(role.logicInfo.name," 增益光环 属性:",attrIndex,"  ",haloAttrNum," 总加成: ",selfAttrAdd)
						else
							enemyAttrAdd = enemyAttrAdd - haloAttrNum
							-- print(role.logicInfo.name," 减益光环 属性:",attrIndex,"  ",haloAttrNum," 总加成: ",enemyAttrAdd)
						end
					end
				end
			end
		end
	end

	if bEnemyRole then
		return enemyAttrAdd
	else
		return selfAttrAdd
	end
end
function FightRoleManager:GetTotalHaloEffectAttrAdd(AttrType, bEnemyRole, attrIndex)
	local selfAttrAdd = 0
	local enemyAttrAdd = 0

	for k,role in pairs(self.map) do
		local haloAttr = 0
		if AttrType == EnumFightAttributeType.Immune then
			haloAttr = role.haloImmuneAttr[attrIndex] or 0
		elseif AttrType == EnumFightAttributeType.Effect_extra then
			haloAttr = role.haloEffectExtraAttr[attrIndex] or 0
		elseif AttrType == EnumFightAttributeType.Be_effect_extra then
			haloAttr = role.haloBeEffectExtraAttr[attrIndex] or 0
		end
		-- haloAttr = math.abs(haloAttr)
		-- if role:IsLive(true) and role.haloType ~= nil and haloAttr > 0 then
		-- 	if role.logicInfo.bEnemyRole then
		-- 		if role.haloType == 5 then --增益光环
		-- 			enemyAttrAdd = enemyAttrAdd + haloAttr
		-- 		else
		-- 			selfAttrAdd = selfAttrAdd - haloAttr
		-- 		end
		-- 	else
		-- 		if role.haloType == 5 then --增益光环
		-- 			selfAttrAdd = selfAttrAdd + haloAttr
		-- 		else
		-- 			enemyAttrAdd = enemyAttrAdd - haloAttr
		-- 		end
		-- 	end
		-- end
		local absHaloAttr = math.abs(haloAttr)
		if role:IsLive(true) and absHaloAttr > 0 then
			for haloType,list in pairs(role.haloTypeList) do
				if role.logicInfo.bEnemyRole then
					if haloType == 5 and haloAttr > 0 then --增益光环
						enemyAttrAdd = enemyAttrAdd + absHaloAttr
						-- print(role.logicInfo.name," 增益光环 属性:",attrIndex,"  ",haloAttrNum," 总加成: ",enemyAttrAdd)
					elseif (haloType == 6 and haloAttr < 0) then
						selfAttrAdd = selfAttrAdd - absHaloAttr
						-- print(role.logicInfo.name," 减益光环 属性:",attrIndex,"  ",haloAttrNum," 总加成: ",selfAttrAdd)
					end
				else
					if haloType == 5 and haloAttr > 0 then --增益光环
						selfAttrAdd = selfAttrAdd + absHaloAttr
						-- print(role.logicInfo.name," 增益光环 属性:",attrIndex,"  ",haloAttrNum," 总加成: ",selfAttrAdd)
					elseif (haloType == 6 and haloAttr < 0) then
						enemyAttrAdd = enemyAttrAdd - absHaloAttr
						-- print(role.logicInfo.name," 减益光环 属性:",attrIndex,"  ",haloAttrNum," 总加成: ",enemyAttrAdd)
					end
				end
			end
		end
	end

	if bEnemyRole then
		return enemyAttrAdd
	else
		return selfAttrAdd
	end
end

function FightRoleManager:CleanFrozenBuffRole(bEnemyRole)
	local maxLastNum = -1
	local frozenBuffRole = nil 
	local liveList = self:GetAllLiveRole(bEnemyRole)
	local liveNum = liveList:length()
   	for i=1,liveNum do
  		local role = liveList:objectAt(i)
		local buffTypeList = role:GetBuffListByType({79, 14})
  		local frozenBuff = buffTypeList[79]
  		if frozenBuff ~= nil and frozenBuff.lastNum > maxLastNum then
  			role:RemoveFrozenBuff()
  			return true
		  end
  		local frozenBuff = buffTypeList[14]
  		if frozenBuff ~= nil and frozenBuff.lastNum > maxLastNum then
  			frozenBuffRole = role
  			maxLastNum = frozenBuff.lastNum
  		end

  	end

  	if frozenBuffRole ~= nil then
  		frozenBuffRole:RemoveFrozenBuff()
  		return true
  	else
  		return false
  	end
end

function FightRoleManager:HaveBadBuffRole(bEnemyRole)
	local liveList = self:GetAllLiveRole(bEnemyRole)
	local liveNum = liveList:length()
   	for i=1,liveNum do
  		local role = liveList:objectAt(i)
  		if role:HaveBadBuff() then
  			return true
  		end
  	end
  	return false
end

function FightRoleManager:HaveNeedCureRole(bEnemyRole)
	local liveList = self:GetAllLiveRole(bEnemyRole)
	local liveNum = liveList:length()
   	for i=1,liveNum do
  		local role = liveList:objectAt(i)
  		if role.currHp / role.maxhp < 0.5 then
  			return true
  		end
  	end
  	return false
end



function FightRoleManager:GetAwardTenTarget(attackRole)
	local attackRolePos = attackRole.logicInfo.posindex
	local attackRoleRow = attackRole:GetRowIndex()

	local targetPosIndex = {}
	if attackRoleRow == 0 then
		targetPosIndex = {0, 1, 2, 3, 4, 5, 6, 7, 8}
	elseif attackRoleRow == 1 then
		targetPosIndex = {3, 4, 5, 0, 1, 2, 6, 7, 8}
	else
		targetPosIndex = {6, 7, 8,3, 4, 5, 0, 1, 2 }
	end

	local targetList = {}
	for i=1,9 do
		local posIndex = targetPosIndex[i]
		if attackRolePos < 9 then
			posIndex = posIndex + 9
		end
		local role = self.map[posIndex]
		if role ~= nil and role:IsLive() and role:HaveFrozenBuff(false) == false then
			targetList[1] = role
			break
		end
	end
	if #targetList <= 0 then
		return targetList
	end

	local nearList = self:GetNearIndex(targetList[1].logicInfo.posindex)
	for j=1,#nearList do
		local pos = nearList[j]
		local _targetRole = self:GetRoleByGirdIndex(pos)
		if _targetRole and _targetRole:IsLive() and _targetRole:HaveFrozenBuff(false) == false then
			targetList[#targetList+1] = _targetRole
		end
	end
	
	return targetList
end



function FightRoleManager:GetNearIndex(posIndex)
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


function FightRoleManager:ClearAllRoleBuff()
	for k,role in pairs(self.map) do
		if role:IsLive() then
			role:RemoveAllBuff()
		end
	end
end

function FightRoleManager:GetFrontRoleNum(targetRole, targetList)
	local num = 0
	local targetNum = #targetList
	local rowIndex = targetRole:GetRowIndex()
	for i=1,targetNum do
		local role = targetList[i]
		if role.logicInfo.posindex < targetRole.logicInfo.posindex and rowIndex == role:GetRowIndex() then
			num = num + 1
		end
	end
	return num
end

function FightRoleManager:getLiveRoleWithOutSelf(targetRole)
	local list = TFArray:new()
	for k,role in pairs(self.map) do
		local bValidRole = true

		-- if bExcludeFrozenRole and role:HaveFrozenBuff() then
		-- 	bValidRole = false
		-- end
		if role == targetRole then
			bValidRole = false
		end

		if bValidRole then
			if targetRole.logicInfo.bEnemyRole then
				if role.logicInfo.bEnemyRole and role:IsLive() then
					list:pushBack(role)
				end
			else
				if role.logicInfo.bEnemyRole == false and role:IsLive() then
					list:pushBack(role)
				end
			end
		end
	end
	return list
end


--根据阵容 buff找对应侠客
function FightRoleManager:getHasBuffRole(bEnemyRole, buffType)
	local roleList = TFArray:new()
	local liveList = self:GetAllLiveRole(bEnemyRole)
	-- local liveNum = liveList:length()
	-- for i=1,liveNum do
	-- 	local role = liveList:objectAt(i)
	for role in liveList:iterator() do
		if role:GetBuffByType(buffType) then
			roleList:pushBack(role)
		end
	end
	return roleList
end
--根据阵容 trigger_hurtType
function FightRoleManager:getHasTriggerHurtTypeRole(triggerHurtType)
	local roleList = {}
	for k,_role in pairs(self.map) do
		if (_role:IsLive()) then
			local _skillInfo = SkillLevelData:objectByID(_role.skillID)
			if (_skillInfo and _skillInfo.trigger_hurtType == triggerHurtType) then
				table.insert( roleList, {role = _role  ,skillInfo = _skillInfo})
			end
		end
	end
	return roleList
end

function FightRoleManager:getHasBuffNum(bEnemyRole,buffType)
	local liveList = self:GetAllLiveRole(bEnemyRole)
	local totalNum = 0
	local liveNum = liveList:length()
	-- for i=1,liveNum do
	-- 	local role = liveList:objectAt(i)
	for role in liveList:iterator() do
		if role:GetBuffByType(buffType) then
			totalNum = totalNum + 1
		end
	end
	return liveNum , totalNum
end

function FightRoleManager:addAttackNum(bEnemy)
	if bEnemy then
		self.enemyAttackTime = self.enemyAttackTime + 1
	else
		self.selfAttackTime = self.selfAttackTime + 1
	end
	local liveList = self:GetAllLiveRole(bEnemyRole)
	for role in liveList:iterator() do
		if role.logicInfo.bEnemyRole ~= bEnemy then
			role:OnBuffTrigger(EnumFightBuffLastType.last_Type_13)
		end
	end
end
function FightRoleManager:getTeamAttackNum(bEnemy)
	if bEnemy then
		return self.enemyAttackTime or 0
	else
		return self.selfAttackTime or 0
	end
end

function FightRoleManager:clearSpecialTime()
	for k,role in pairs(self.map) do
		if role._specialSkillTime then
			role._specialSkillTime = 0
		end
	end
end

function FightRoleManager:getAllCanUserSkillRole(bExcludeFrozenRole)
	local list = TFArray:new()
	for k,role in pairs(self.map) do
		local bValidRole = true
		if bExcludeFrozenRole and role:HaveFrozenBuff(false) then
			bValidRole = false
		end

		if bValidRole and role:IsLive() then
			list:pushBack(role)
		end
	end
	return list
end

--获取bEnemyRole方空余阵位
function FightRoleManager:getUsableMapIndexByRoleId(bEnemyRole)
	local list_1 	= {0, 3, 6, 1, 4, 7, 2 ,5, 8}
	local list_2 	= {9, 12, 15, 10, 13, 16, 11 ,14, 17}
	local list_temp = list_1
	if (bEnemyRole) then
		list_temp = list_2
	end
	--
	-- local liveList 		= self:GetAllLiveRole(bEnemyRole, false, true)
	-- local liveNum 		= liveList:length()
	-- for i=1,liveNum do
	-- 	local role = liveList:objectAt(i)
	-- 	for k,v in pairs(list_temp) do
	-- 		if (role.logicInfo.posindex == v) then
	-- 			table.remove( list_temp, k)
	-- 			break
	-- 		end
	-- 	end
	-- end
	for _,role in pairs(self.map) do
		if (role.logicInfo.bEnemyRole == bEnemyRole) then
			if (role:GetSummoned() ~= 0)then
				if (not role:IsLive()) then
					--以前存在
					return role.logicInfo.posindex
				end
				return nil
			end
			for k,v in pairs(list_temp) do
				if (role.logicInfo.posindex == v) then
					table.remove( list_temp, k)
					break
				end
			end
		end
	end
	local listLen = #list_temp
	if (listLen <= 0) then
		return nil
	end
	-- local selectIndex = math.random(1, listLen)
	return list_temp[1]
end

--敌方最大血量值对自己低
function FightRoleManager:getEnemyMaxHpList(attackRole)
	local liveList 		= self:GetAllLiveRole(not attackRole.logicInfo.bEnemyRole, false, false, true)
	--
	local liveNum 	= liveList:length()
	local list 		= {}
	local attackMaxHp = attackRole:getMaxHp()
	for role in liveList:iterator() do
		if (role:IsLive()) then
			if (role:getMaxHp() < attackMaxHp) then
				table.insert( list, role)
			end
		end
	end
	if (#list < 1) then
		return nil
	end
	return list
end
--最大血量上限
function FightRoleManager:getMaxLimit(bEnemyRole)
	local liveList 		= self:GetAllLiveRole(bEnemyRole, false, true, true)
	local list 		= {}
	local attackMaxHp = 0
	for role in liveList:iterator() do
		local maxHp = role:getMaxHp()
		if (maxHp > attackMaxHp) then
			attackMaxHp = maxHp
			list[1] = role
		end
	end
	return list
end


--目标角色召唤物列表
function FightRoleManager:getRoleSummonedByRole(attackRole, bEnemyRole)
	-- local liveList 		= self:GetAllLiveRole(bEnemyRole, false, true)
	--
	-- local liveNum 	= liveList:length()
	local list 		= {}
	-- for i=1,liveNum do
	-- 	local role 		= liveList:objectAt(i)
	-- 	local summoned 	= role:GetSummoned()
	-- 	if (summoned ~= 0 and role:IsLive()) then
	-- 		if (summoned == attackRole.logicInfo.roleId) then
	-- 			table.insert( list, role)
	-- 		end
	-- 	end
	-- end
	--
	local fatherId = attackRole.logicInfo.roleId
	for k, role in pairs(self.map) do
		local summoned 	= role:GetSummoned()
		if (summoned ~= 0 and role:IsLive()) then
			if( bEnemyRole == role.logicInfo.bEnemyRole and summoned == fatherId) then
				table.insert( list, role)
			end
		end
	end
	if (#list < 1) then
		return nil
	end
	return list
end

--目标阵位是否在攻击角色的正后方
function FightRoleManager:IsAttackAfter(attackRole, fuhuoindex)
	-- local first_list 	= {9, 12, 15}
	-- local first_list2 	= {0, 3, 6}
	local bEnemyRole 	= attackRole.logicInfo.bEnemyRole
	local attackIndex 	= attackRole.logicInfo.posindex
	-- if (not bEnemyRole) then
	-- 	first_list = first_list2
	-- else
	-- 	attackIndex = attackIndex - 9
	-- 	if (attackIndex < 0) then
	-- 		return false
	-- 	end
	-- end
	--

	local row 			= math.floor(attackIndex % 3) + 1
	if (row >= 3) then
		--最后一行
		return false
	end
	local fuhuo_row 			= math.floor(fuhuoindex / 3) + 1
	local attack_row 			= math.floor(attackIndex / 3) + 1
	if (fuhuo_row ~= attack_row) then
		--不是同一排
		return false
	end
	if (attackIndex + 1 == fuhuoindex or attackIndex + 2 == fuhuoindex) then
		return true
	end
	-- local firstRow 		= first_list[row]
	-- if (firstRow) then
	-- 	local index = fuhuoindex--7
	-- 	if (index - 1 == firstRow or index - 2 == firstRow) then
	-- 		return true
	-- 	end
	-- end
	return false
end

function FightRoleManager:gotoNextBattle()
	local liveList = self:GetAllLiveRole(false)
	local liveNum = liveList:length()
	for i=1,liveNum do
		local role = liveList:objectAt(i)
		self.roleLayer:showRoleGoOutScene(role)
	end
end


function FightRoleManager:GetAttackAfterTargetList(attackRole)
	local first_list 	= {9, 12, 15}
	local first_list2 	= {0, 3, 6}
	local bEnemyRole 	= attackRole.logicInfo.bEnemyRole
	if (not bEnemyRole) then
		first_list = first_list2
	end
	--
	local attackIndex 	= attackRole.logicInfo.posindex
	local row 			= math.floor(attackIndex / 3) + 1
	local firstRow 		= first_list[row]
	local fuHuoList 	= {}
	if (firstRow) then
		local liveList 	= self:GetAllLiveRole(bEnemyRole, false, true)
		for role in liveList:iterator() do
			local index = role.logicInfo.posindex
			if (index - 1 == firstRow or index - 2 == firstRow) then
				if (attackIndex < index) then
					table.insert( fuHuoList, role )
				end
			end
		end
	end
	return fuHuoList
end

--
function FightRoleManager:ChangeEffectHurt(targetRole, targetInfo)
	local baseHurt = targetInfo.hurt
	if (baseHurt >= -1) then
		return
	end
	local maxHp 		= targetRole.maxhp
	local hurtPercent 	= baseHurt / maxHp * 100
	local liveList 	= self:GetAllLiveRole(targetRole.logicInfo.bEnemyRole, false, false)
	for role in liveList:iterator() do
		for i,skillID in ipairs(role.passiveSkill) do
			local skillInfo = SkillLevelData:objectByID(skillID)
			if (skillInfo and skillInfo.effect == EnumFightSpellEffect.effect_76) then
				if (math.abs(hurtPercent) >= skillInfo.effect_value) then
					local maxHurt = maxHp * skillInfo.effect_value / 100
					if (baseHurt < -maxHurt) then
						print("伤害值: ",baseHurt," 不能超过伤害值",maxHurt)
						targetInfo.hurt = -maxHurt
						break
					end
				end
			end
		end
	end
end

--角色主动技
function FightRoleManager:GetSelfLiveRoleSkillInfoByEffect(bEnemyRole, effect)
	local liveList = self:GetAllLiveRole(bEnemyRole, false, false)
	-- local liveNum = liveList:length()
	-- for i=1,liveNum do
	-- 	local role = liveList:objectAt(i)
		-- if (role and role:IsLive()) then
		for role in liveList:iterator() do
			local skillInfo = BaseDataManager:GetSkillBaseInfo(role.skillID)
			if skillInfo ~= nil and skillInfo.effect == effect then
				return role, skillInfo
			end
		end
	-- end
	return nil
end
--角色被主动技 神技
function FightRoleManager:GetSelfLiveRolePassiveSkillInfoByEffect(bEnemyRole, effect)
	local liveList = self:GetAllLiveRole(bEnemyRole, false, false)
		for role in liveList:iterator() do
			local skillInfo = role:getPassiveSkillInfoByEffect(effect)
			if skillInfo ~= nil and skillInfo.effect == effect then
				return role, skillInfo
			end
		end
	-- end
	return nil
end

--
function FightRoleManager:GetSelfLiveRoleTriggerHurtType(bEnemyRole, triggeHurtType)
	local liveList = self:GetAllLiveRole(bEnemyRole, false, true)
	for role in liveList:iterator() do
		local isHave, skillInfo = role:HasTriggerSkillByType(triggeHurtType)
		if skillInfo == nil then
			skillInfo = role:GetTriggerBySkillHurtType(role.skillID, triggeHurtType)
		end
		if (skillInfo) then
			return role, skillInfo
		end
	end
	return nil
end

--被动光环技能开场
function FightRoleManager:OnBeginPassiveHaloSkill()
	for k,role in pairs(self.map) do
		role:OnBeginPassiveHaloSkill()
	end
end

--治疗血量溢出
function FightRoleManager:GetSkillAddMaxHpByRole(bEnemyRole)
	local selfRoleList 	= self:GetAllLiveRole(bEnemyRole, false, false)
	for role in selfRoleList:iterator() do
		--if (targetIndex ~= role.logicInfo.posindex) then
			local skillInfo = role:getPassiveSkillInfoByEffect(EnumFightSpellEffect.effect_69)
			if (skillInfo) then
				return (skillInfo.effect_value / 100)
			end
		--end
	end
	return 0
end

--战力比
function FightRoleManager:GetHurtPercentByIndex(index, hurt)
if (FightManager.fightBeginInfo and FightManager.fightBeginInfo.fighttype ~= EnumFightType.NorthClimb and FightManager.fightBeginInfo.suppress) then
		local tempSuuppress = tostring(FightManager.fightBeginInfo.suppress)
		local suppress = string.split(tempSuuppress,'_')
		local hurtPercent = tonumber(suppress[1] or 0)
		if (index >= 9) then
			hurtPercent = tonumber(suppress[2] or 0)
		end
		if (hurtPercent > 0) then
			print("----------------战力压制百分比 ",tempSuuppress)
			hurt = math.floor((hurt * hurtPercent) / 100)
			print("----------------战力压制后伤害 hurt = ",hurt)
		end
	end
	return  hurt
end

--是否同一阵容
function FightRoleManager:IsSelfTeam(posindex1, posindex2)
	local function isLeft(a)
		return (a < 9 )
	end
	local function isRight(a)
		return (a >= 9 and a < 18)
	end
	local function isRightPet(a)
		return (a == 19)
	end
	local function isLeftPet(a)
		return (a == 18)
	end
	local aa = isLeft(posindex1) or isLeftPet(posindex1)
	local bb = isLeft(posindex2) or isLeftPet(posindex2)
	return (aa == bb)
end

--左右阵容转换
function FightRoleManager:GetConverterTeam(posindex)
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


--获取阵容上拥有触发triggerHurtType的侠客
function  FightRoleManager:GetAllRoleBySkill(triggerHurtType)
	local selfRoleList = TFArray:new()
	local enemyRoleList = TFArray:new()
	for k,role in pairs(self.map) do
		if (role:IsLive() and not role:isCanNotTriggerBeiDong() 
			and role:HasTriggerSkillBySkill(role.skillID, triggerHurtType, true)) then
			if (role.logicInfo.bEnemyRole) then
				selfRoleList:push(role)
			else
				enemyRoleList:push(role)
			end
		end
	end
	return selfRoleList, enemyRoleList
end

function FightRoleManager:GetAllHaveBuffRoleByType(buffType)
	local list1 = {}
	local list2 = {}
	local buff1 = {}
	local buff2 = {}
	for k,role in pairs(self.map) do
		if (role:IsLive() and role:GetSummoned() == 0 and not role.ispet) then
			if (not role:HaveFrozenBuff(false)) then
				local buffInfo = role:GetBuffByType(buffType)
				if (buffInfo) then
					if (role.logicInfo.bEnemyRole) then
						table.insert( list2, role)
						table.insert( buff2, buffInfo)
					else
						table.insert( list1, role)
						table.insert( buff1, buffInfo)
					end
				end
			end
		end
	end
	return list1[1],list2[1],buff1[1],buff2[1]
end

--检查阵位上是否有拥有复活侠客 按阵位号选取
function FightRoleManager:CheckHaveSaveOtherSkillRole(beAttackRole)
	if FightManager.isReplayFight then
		return {} 
	end
	-- local saveRole = nil
	local fuHuoRoleList = {}
	local firstRoleList = {}
	-- local roleList = self:GetAllLiveRole(beAttackRole.logicInfo.bEnemyRole,false,false)
	-- for role in roleList:iterator() do
	local nBeginIndex = 0
	local nEndIndex = 8
	if (beAttackRole.logicInfo.bEnemyRole) then
		nBeginIndex = 9
		nEndIndex 	= 17
	end
	for i = nBeginIndex, nEndIndex do
		local role = self:GetRoleByGirdIndex(i)
		if (role and role:IsLive()) then
			if role:HaveForbidAttackBuff() == false then
				local hasSkillInfo = role:HasTriggerSkillBySkillType(EnumFightSkillType.type_10)
				if hasSkillInfo then
					table.insert( fuHuoRoleList, role)
				else
					--
					local skillInfo = role:HasTriggerSkillBySkillType(EnumFightSkillType.type_14)
					if skillInfo then
						if (self:IsAttackAfter(role, beAttackRole.logicInfo.posindex)) then
							table.insert( firstRoleList, role)
						end
					end
				end
			end
			
		end
	end
	return fuHuoRoleList, firstRoleList
end

--吸引攻击目标角色
function FightRoleManager:GetAttractRole(attackRole, targetType, skillId)
	if (attackRole.ispet) then
		return {}
	end
	local targetList = {}
	local buffRole = nil
	local liveList = self:GetAllLiveRole(not attackRole.logicInfo.bEnemyRole, false, true, false)
	for role in liveList:iterator() do
		if (role:GetBuffByType(EnumFightBufferType.type_521)) then
			buffRole = role
			break
		end
	end
	if (skillId == 0) then
		return {buffRole}
	end
	if (buffRole) then
		local bAdd = false
		for i,_targetType in ipairs(EnumFightSummonedSkillTargetType) do
			if (targetType == _targetType) then
				table.insert( targetList, buffRole )
				buffRole:OnBuffTriggerByType(EnumFightBufferType.type_521)
				break
			end
		end
		if (#targetList < 1) then
			for i,_targetType in ipairs(EnumFightSkillTargetMostType) do
				if (targetType == _targetType) then
					table.insert( targetList, buffRole )
					buffRole:OnBuffTriggerByType(EnumFightBufferType.type_521)
					break
				end
			end
		end
	end
	return targetList	
end
function FightRoleManager:FightEndHpLog()
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 and VERSION_DEBUG == true then
		local hpRight = {}
		Lua_fightWriteFile(EnumFight_Log.HP, nil,"\n")
		for k,role in pairs(self.map) do
			local str = "战斗结算  阵位: "..role.logicInfo.posindex.."  "..role.logicInfo.name..role.logicInfo.roleId.." 剩于血量    "..role.currHp
			if (role.logicInfo.bEnemyRole) then
				table.insert(hpRight, str)
			else

				Lua_fightWriteFile(EnumFight_Log.HP, nil, str)
			end
		end
		Lua_fightWriteFile(EnumFight_Log.HP, nil,"\n")
		-- for i,str in pairs(hpRight) do

		-- end
		Lua_fightWriteFile(EnumFight_Log.HP, nil, hpRight)
	end
end
return FightRoleManager