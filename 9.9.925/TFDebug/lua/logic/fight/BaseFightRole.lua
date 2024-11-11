--     script writer feng
--     @ new DateTime{{20180413}:
--　　　┏┓　　　┏┓+ +
--　　┏┛┻━━━┛┻┓ + +
--　　┃　　　　　　　┃ 　
--　　┃　　　━　　　┃ ++ + + +
--　 ████━████ ┃+
--　　┃　　　　　　　┃ +
--　　┃　　　┻　　　┃
--　　┃　　　　　　　┃ + +
--　　┗━┓　　　┏━┛
--　　　　┃　　　┃　　　　　　
--　　　　┃　　　┃ + + + +
--　　　　┃　　　┃　　　　　　
--　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug　　
--　　　　┃　　　┃
--　　　　┃　　　┃　　+　　　　　　　　
--　　　　┃　 　　┗━━━┓ + +
--　　　　┃ 　　　　　　　┣┓
--　　　　┃ 　　　　　　　┏┛
--　　　　┗┓┓┏━┳┓┏┛ + + + +
--　　　　　┃┫┫　┃┫┫
--　　　　　┗┻┛　┗┻┛+ + + +
--

local BaseFightRole = class("BaseFightRole")
local EFFECT_ZORDER = 100
local FIGHT_TEXT_ZORDER = 300

function BaseFightRole:ctor(roleInfo, bFight)
    print("///////////////BaseFightRole-Begin/////////////////////")
    local nPosIndex = roleInfo.posindex
    self.logicInfo  = roleInfo
    self.profession = 1
    self.sex        = 1
    print("------阵位  "..nPosIndex)
	local bEnemyRole = false
	if nPosIndex >= 9 and nPosIndex < 18 then
		bEnemyRole = true
	elseif nPosIndex == 18 then
		bEnemyRole = false
		self.ispet = true
	elseif nPosIndex == 19 then
		bEnemyRole = true
		self.ispet = true
    end
   
	--
	if (bFight) then
		self.role_angerMax = 100
		self.role_anger = roleInfo.anger or 0
	end
    local roleId    = roleInfo.roleId
    self.soundRoleId = roleId
    self.quality = 1
    local bNpc = (roleInfo.typeid == 2)
    local roleTableData = nil
    local armatureID = 10040
	if self.ispet then
		roleTableData = BattlePetData:objectByID(roleId)
		if (roleTableData == nil) then
			FightManager.bLoadError = true
			return
		end
        self.quality = roleInfo.maxhp
        armatureID = roleTableData:getIcon(self.quality)
        self.iconPath = roleTableData:getIconPath(self.quality)
        self.headPath = "icon/head/"..roleTableData:getIcon(self.quality)..".png"
		self.logicInfo.name = roleTableData.describ or "_ispet"
		if (bFight) then
			self.role_angerMax = 0
		end
	else
		if bNpc then
            --39 风云录
			if FightManager.fightBeginInfo.fighttype == EnumFightType.FYRecord then
				roleTableData = FYRecordData:objectByID(roleId)
			else
				roleTableData = NPCData:objectByID(roleId)
			end
			if (roleTableData == nil) then
				FightManager.bLoadError = true
				return
			end
            self.normalAttackSkillID = roleTableData.normal_attack or 0
            self.soundRoleId         = roleTableData.role_id
            local npcRoleData = RoleData:objectByID(roleTableData.role_id)
            if npcRoleData then
                self.sex = npcRoleData.sex
                self.profession = npcRoleData.outline
                --
                if self.normalAttackSkillID == 0 then
                    self.normalAttackSkillID = npcRoleData.normal_attack or 0
                end
			end
		else
			roleTableData = RoleData:objectByID(roleId)
			if (roleTableData == nil) then
				FightManager.bLoadError = true
				return
			end
            self.normalAttackSkillID = roleTableData.normal_attack or 0
            self.quality             = roleTableData.quality
            self.sex                 = roleTableData.sex
			self.profession          = roleTableData.outline
		end
		if (bFight) then
			self.role_angerMax = roleTableData.maxAnger or 100
		end
        armatureID = roleTableData.image
        self.headPath = "icon/head/"..roleTableData.image..".png"
        self.logicInfo.name = roleTableData.name or ("name_"..roleId)
	end

    self.normalAttackSkillID = self.normalAttackSkillID or 0
    self.directional_sensitivity = false
	if roleTableData.directional_sensitivity and roleTableData.directional_sensitivity == 1 then
		self.directional_sensitivity = true
    end
    --
	local resPathXML = "armature/"..armatureID..".xml"
	local resPathAlats = "armature/".. armatureID .. ".atlas" 
	local armature
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "armature/".. armatureID
		armature = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		armature = TFArmature:create(armatureID.."_anim")
	else
		armatureID = 10006
		TFResourceHelper:instance():addArmatureFromJsonFile("armature/"..armatureID..".xml")
		armature = TFArmature:create(armatureID.."_anim")
	end
	
	if armature == nil then
		assert(false, "armature"..armatureID.."create error")
		return
	end
    GameResourceManager:addEnemy( roleId, armature )
    armature:setAnimationFps(FightManager.fightSpeed * GameConfig.ANIM_FPS)
    --
    if bEnemyRole then
		armature:setRotationY(180)
    end
    armature:setPosition(ccp(0,0))
    self.armatureID     = armatureID
    self.old_armature   = armature
    self.armature       = armature

    self.rolePanel = TFPanel:create()
	self.rolePanel:setSize(armature:getContentSize())
	self.rolePanel:addChild(armature)
	self.originPos = FightManager:GetPosByIndex(nPosIndex, roleId)
	self:setPosition(clone(self.originPos))
    --
    self.animSpeed = FightManager.fightSpeed
    --
	if self.ispet then
		
        self.logicInfo.name = roleTableData.describ or ""
        self.rolePanel:setVisible(false)
	else
        self.logicInfo.name = roleTableData.name or ""
	end
    
	self.logicInfo.bEnemyRole = bEnemyRole
	self.currHp               = roleInfo.maxhp
    self.maxhp                = self.logicInfo.attr[1]
	print(self.logicInfo.name .."属性: ",displayAttributeString(self.logicInfo.attr))
	self.summoned 	        = roleTableData.summoned or 0
	--2018-11-21  黄剑武说会发过来 让我去掉
	-- if roleTableData and roleTableData.be_effect_extra ~= nil and roleTableData.be_effect_extra ~= "" and FightManager.fightBeginInfo.fighttype ~= EnumFightType.Boss then
	if (self:IsSummoned()) then
		self.beEffectExtraAttribute = GetAttrByString(roleTableData.be_effect_extra)
		print("------be_effect_extra: ",roleTableData.be_effect_extra)
	end

    --
    self.passiveSkill = roleInfo.passiveskill or {}
    print("roleInfo.spellId ", roleInfo.spellId, " ------passiveSkill end =",self.passiveSkill )
    
	-- 

    --
    
    --
    self.haveAttack          = false
    self.buffList            = TFArray: new()
    self.bodyEffectList      = {}
	self.bufferIconList      = {}
	self.bossEffectList 	= {}
    self.lastHurtHp			= 0	--上次所受伤害
    
    --未使用
    self.isreturn      = true
    self.addDelay      = 0
    self.lastFloatTime      = 0
    --
    self:UpdateZOrder()
	self:PlayStandAnim()
    self:CreateHpLabel()
	self:CreateShadowImg()
	if roleInfo.isboss and roleInfo.isboss == true then
		self:AddBossEffect("fight_boss")
	end
end

--不等于0时为召唤物
function BaseFightRole:GetSummoned()
	return self.summoned or 0
end
function BaseFightRole:IsSummoned()
	return (self:GetSummoned() ~= 0)
end
function BaseFightRole:UpdateZOrder()
	local rolePos = self:getPosition()
	self.rolePanel:setZOrder(-rolePos.y)
end

function BaseFightRole:setPosition(pos)
	self.rolePanel:setPosition(pos)
end

function BaseFightRole:getPosition()
	return self.rolePanel:getPosition()
end

function BaseFightRole:GetColumnIndex()
	local posIndex = self.logicInfo.posindex
	if posIndex >= 9 then
		posIndex = posIndex - 9
	end

	return posIndex%3
end
function BaseFightRole:GetRowIndex()
	local posIndex = self.logicInfo.posindex
	if posIndex >= 9 then
		posIndex = posIndex - 9
	end

	return math.floor(posIndex/3)
end

function BaseFightRole:CreateShadowImg()
	local shadowImg = TFImage:create("ui_new/fight/shadow.png")
	shadowImg:setZOrder(-1001)
	shadowImg:setAnchorPoint(ccp(0.5, 0.5))
	self.shadowImg = shadowImg
	self.rolePanel:addChild(shadowImg)
end

function BaseFightRole:SetSpeed(speed)
	self.animSpeed = speed
	local nSpeed = speed * GameConfig.ANIM_FPS
	self.armature:setAnimationFps(nSpeed)

	for k,effect in pairs(self.bodyEffectList) do
		if effect ~= nil then
			effect:setAnimationFps(nSpeed)
		end
	end
	for k,effect in pairs(self.bossEffectList) do
		if effect ~= nil then
			effect:setAnimationFps(nSpeed)
		end
	end
end

function BaseFightRole:CreateHpLabel()
	if FightManager.fightBeginInfo.bSkillShowFight or self.ispet then
		return
	end

	local hpLabel = TFLoadingBar:create()
	if self.logicInfo.bEnemyRole then
		if self.logicInfo.isboss and self.logicInfo.isboss == true then
			hpLabel:setTexture("ui_new/fight/enemybloodboss.png")
		else
			hpLabel:setTexture("ui_new/fight/enemyblood.png")
		end
	else
		hpLabel:setTexture("ui_new/fight/blood.png")
	end
	hpLabel:setPosition(ccp(0, 0))
	hpLabel:setPercent(self.currHp/self.maxhp*100)
	self.hpLabel = hpLabel

	local hpBackground = TFImage:create()
	if self.logicInfo.isboss and self.logicInfo.isboss == true then
		hpBackground:setTexture("ui_new/fight/bloodboss_bg.png")
	else
		hpBackground:setTexture("ui_new/fight/blood_bg.png")
	end
	hpBackground:setZOrder(100)
	hpBackground:addChild(hpLabel)
	self.hpBackground = hpBackground

	hpBackground:setPosition(ccp(0,180))

	if self.role_angerMax and self.role_angerMax ~= 0 then
		local angerLabel = TFLoadingBar:create()
		angerLabel:setTexture("ui_new/fight/bar_shayitiao.png")
		angerLabel:setPosition(ccp(7, 0))
		angerLabel:setPercent(self.role_anger/self.role_angerMax*100)
		self.angerLabel = angerLabel
		local angerBackground = TFImage:create()
		angerBackground:setTexture("ui_new/fight/bg_shayitiao.png")
		angerBackground:setZOrder(100)
		angerBackground:addChild(angerLabel)
		self.angerBackground = angerBackground
		angerBackground:setPosition(ccp(-10,172))
		self.rolePanel:addChild(angerBackground)
	end

	local professionImg = TFImage:create("ui_new/fight/zhiye_"..self.profession..".png")
	if professionImg ~= nil then
		professionImg:setPosition(ccp(-55, 7))
		hpBackground:addChild(professionImg)
	end

	self.rolePanel:addChild(hpBackground)
	if self.ispet then
		hpBackground:setVisible(false)
	end
end

function BaseFightRole:AddBossEffect(nEffectID, nZorder, nDelayTime, bLoop)
	if self.armature == nil then
		return
	end
	if (not nZorder) then
		if self.logicInfo.isboss == nil or self.logicInfo.isboss ~= true then
			return
		end
		if self.bossEffect ~= nil then
			return
		end
	end
	if self.bossEffectList[nEffectID] ~= nil then
		return
	end
	local resPathXML = "effect/"..nEffectID..".xml"
	local resPathAlats = "effect/"..nEffectID..".atlas" 
	local bodyEffect
	
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "effect/".. nEffectID
		bodyEffect = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		bodyEffect = TFArmature:create(nEffectID.."_anim")
	else
		return
	end

	if bodyEffect == nil then
		return
	end
	local nPosOffsetX = 0
	local nPosOffsetY = 0
	bodyEffect:setPosition(ccp(nPosOffsetX, nPosOffsetY))
	bodyEffect:setAnimationFps(FightManager.fightSpeed * GameConfig.ANIM_FPS)
	-- bodyEffect:setScale(2)
	-- if bBehindBody then
	-- 	local roleZOrder = self.armature:getZOrder()
	-- 	bodyEffect:setZOrder(roleZOrder-1)
	-- else
	-- 	bodyEffect:setZOrder(200)
	-- end
	local addZorder = nZorder
	if (addZorder == 1) then
		local roleZOrder = self.armature:getZOrder()
		bodyEffect:setZOrder(roleZOrder-1)
	else
		bodyEffect:setZOrder(200)
	end
	self.rolePanel:addChild(bodyEffect)
	if bLoop then
		bodyEffect:playByIndex(0, -1, -1, 1)
	else
		bodyEffect:playByIndex(0, -1, -1, 0)
	end
	if (not nZorder) then
		self.bossEffect = bodyEffect
	else
		self.bossEffectList[nEffectID] = bodyEffect
		nDelayTime = nDelayTime or 0
		if (nDelayTime > 0) then
			bodyEffect:setVisible(false)
			local delayTimer = -1
			delayTimer= TFDirector:addTimer(nDelayTime, 1, function() 
				TFDirector:removeTimer(delayTimer)
				if (self.bossEffectList[nEffectID]) then
					self.bossEffectList[nEffectID]:setVisible(true)
				end
			end, nil)
		else
			bodyEffect:addMEListener(TFARMATURE_COMPLETE,
			function()
				bodyEffect:removeMEListener(TFARMATURE_COMPLETE) 
				self:RemoveBossEffect(nEffectID)
			end)
		end
	end
end

function BaseFightRole:HaveAnim(animName)
	animName = animName..";"
	local movNames = self.armature:getMovementNameStrings()
	movNames = movNames..";"
	if string.find(movNames, animName) then
		return true
	else
		return false
	end
end

function BaseFightRole:PlayStandAnim()
	if self.armature == nil then
		return
	end

	self.attackAnimEnd = true

	local animName = "stand"
	if self.directional_sensitivity then
		if not bEnemyRole then
			animName = animName.."l"
		else
			animName = animName.."r"
		end
	end

	self.armature:play(animName, -1, -1, 1)

   
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffer = self.buffList:objectAt(i)
		if buffer.bValid and buffer.config.stand_display and buffer.config.stand_display ~= "" then

			local animName = buffer.config.stand_display
			if self.directional_sensitivity then
				if not bEnemyRole then
					animName = animName.."l"
				else
					animName = animName.."r"
				end
			end
			if self:HaveAnim(animName) == false then
				animName = "stand"
			end
			self.armature:play(animName, -1, -1, 1)
		end
	end

	if self.bossEffect then
		self.bossEffect:setVisible(true)
	end

	if self:HaveForbidAttackBuff() then
		self.armature:stop()
	end

	self.armature:removeMEListener(TFARMATURE_COMPLETE)
end

function BaseFightRole:showSelfDisplay()
	if self.tihuan_armature then
		self.armature = self.old_armature
		self.old_armature:setVisible(true)
		self.tihuan_armature:removeFromParent(true)
		self.tihuan_armature = nil
		self:PlayStandAnim()
	end
end
function BaseFightRole:dispose()
	TFDirector:killAllTween(self.rolePanel)
end

function BaseFightRole:setScale( scale )
	self.rolePanel:setScale(scale)
end

--
function BaseFightRole:SetRoleVisible(isVisible)
	if (self.hpBackground) then
		self.hpBackground:setVisible(isVisible)
	end
	if (self.armature) then
		self.armature:setVisible(isVisible)
	end
end

--
function BaseFightRole:SetHpBarVisible(bVisible)
	if self.ispet and bVisible then
		return
	end
	if self.hpBackground ~= nil then
		self.hpBackground:setVisible(bVisible)
	end
	if self.angerBackground ~= nil then
		self.angerBackground:setVisible(bVisible)
	end

	self.shadowImg:setVisible(bVisible)
end

function BaseFightRole:changeHpLabel()
	local hp = 4
	if (self.currHp > self.maxhp) then
		local a     = self.currHp / self.maxhp * 100
		local hp    = math.ceil( a / 34 ) 
		if (hp < 4) then
			hp = 4
		elseif(hp > 8) then
			hp = 8
		end
		if self.logicInfo.bEnemyRole then
			self.hpLabel:setTexture("ui_new/fight/enemyblood_"..hp..".png")
		else
			self.hpLabel:setTexture("ui_new/fight/blood_"..hp..".png")
		end
	else
		if self.logicInfo.bEnemyRole then
			self.hpLabel:setTexture("ui_new/fight/enemyblood.png")
		else
			self.hpLabel:setTexture("ui_new/fight/blood.png")
		end
	end
end
---------------------------------
function BaseFightRole:GetBuffByType(buffType)
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffer = self.buffList:objectAt(i)
	-- 	if buffer.bValid and buffer.config.type == buffType then
	-- 		return buffer
	-- 	end
	-- end
	for buffer in self.buffList:iterator() do
		if buffer.bValid and buffer.config.type == buffType then
			return buffer
		end
	end
	return nil
end

function BaseFightRole:GetBuffListByType(buffTypeList)
	local haveList = {}
	for buffer in self.buffList:iterator() do
		if buffer.bValid then
			for i,buffType in ipairs(buffTypeList) do
				if (buffer.config.type == buffType) then
					haveList[buffType] = buffer
					break
				end
			end	
		end
	end
	return haveList
end

--
function BaseFightRole:HaveForbidAttackBuff()
	local forbidAttackBuff = {12, 13, 14, 15, EnumFightBufferType.type_520}
	local buffTypeList = self:GetBuffListByType(forbidAttackBuff)
	for i=1,#forbidAttackBuff do
		if buffTypeList[forbidAttackBuff[i]] ~= nil then
			return true
		end
	end
	return false
end

--
function BaseFightRole:HaveForbidBackAttackBuff()
	local forbidAttackBuff = {10,12, 13, 14, EnumFightBufferType.type_520}
	local buffTypeList = self:GetBuffListByType(forbidAttackBuff)
	for i=1,#forbidAttackBuff do
		if buffTypeList[forbidAttackBuff[i]] ~= nil then
			return true
		end
	end
	return false
end

function BaseFightRole:HaveForbidManualSkillBuff()
	local forbidSkillBuff = {10, 11, 12, 13, 14, 15, EnumFightBufferType.type_520}
	local buffTypeList = self:GetBuffListByType(forbidSkillBuff)
	for i=1,#forbidSkillBuff do
		if buffTypeList[forbidSkillBuff[i]] ~= nil then
			return true
		end
	end
	return false
end

function BaseFightRole:TestReleaseManualSkill()
	if self:HaveForbidManualSkillBuff() then
		TFDirector:currentScene().fightUiLayer:ForbidSkill(self, true)
	else
		TFDirector:currentScene().fightUiLayer:ForbidSkill(self, false)
	end
end

--
function BaseFightRole:AddBuffIcon(buffId, iconId)
	local iconImg = TFImage:create("icon/buffer/"..iconId..".png")
	if iconImg ~= nil and self.bufferIconList[buffId] == nil and self.hpBackground ~= nil then
		self.hpBackground:addChild(iconImg)
		self.bufferIconList[buffId] = iconImg
		self:SetBuffIconPos()
	end
end

function BaseFightRole:SetBuffIconPos()
	local iconNum = 0
	for k,bufferIcon in pairs(self.bufferIconList) do
		if bufferIcon ~= nil then
			iconNum = iconNum + 1
			bufferIcon:setPosition(ccp(24*iconNum-50, 22))
		end
	end
end

function BaseFightRole:ShowBufferName(buffType, buffId)
	local buffImg = "icon/buffer/name_"..buffType..".png"
	if (EnumFight_Buff_Res[buffId]) then
		buffImg = "icon/buffer/name_"..EnumFight_Buff_Res[buffId]..".png"
	end
	if not TFFileUtil:existFile(buffImg) then
		return
	end
	local nameImg = TFImage:create(buffImg)
	if nameImg ~= nil then
		self:MoveNameImage(nameImg)
	end
end

function BaseFightRole:ShowEffectName(name)
	if (FightManager.isTiaoGuo) then
		return
	end
	local nameImg = TFImage:create("icon/effect/"..name..".png")
	if nameImg ~= nil then
		self:MoveNameImage(nameImg)
	end
end


function BaseFightRole:MoveNameImage(nameImg)
	if nameImg == nil then
		return
	end
	
	local posX = self:getPosition().x
	local posY = self:getPosition().y + 150
	nameImg:setPosition(ccp(posX, posY))

	local uiLayer = TFDirector:currentScene().fightUiLayer.ui
	uiLayer:addChild(nameImg)

	local pos = nameImg:getPosition()
	local nameImgTween = 
	{
		target = nameImg,
		{
			duration = 0.7 / FightManager.fightSpeed,
			x = pos.x,
			y = pos.y + 70,
			alpha = 0.3,
		
			onComplete = function ()
				nameImgTween = nil
				uiLayer:removeChild(nameImg)
			end
		},
	}

	TFDirector:toTween(nameImgTween)
end

--
function BaseFightRole:HaveBuff(buffId)
	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.id == buffId then 
			return true
		end
	end
	return false
end


--乾坤挪移buff
function BaseFightRole:HaveDzxyBuff()
	return self:GetBuffByType(27) ~= nil
end

function BaseFightRole:HaveBadBuff()
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid and buffInfo.config.good_buff == 0 then 
			return true
		end
	end

	return false
end

function BaseFightRole:RemoveFrozenBuff()
	self:RemoveBuffByType(79)
	self:RemoveBuffByType(14)
end

--
function BaseFightRole:RemoveBuffIcon(buffId)
	if self:HaveBuff(buffId) then
		return
	end

	local bufferIcon = self.bufferIconList[buffId]
	if bufferIcon ~= nil then
		bufferIcon:removeFromParent()
		self.bufferIconList[buffId] = nil
		self:SetBuffIconPos()
	end
end

--
function BaseFightRole:RemoveBuffByType(bufferType)
	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffInfo = self.buffList:objectAt(i)
	for buffInfo in self.buffList:iterator() do
		if buffInfo.bValid and buffInfo.config.type == bufferType then 
			self:RemoveBuffByInfo(buffInfo)
		end
	end
end

function BaseFightRole:isDunBuff( buff_type )
	local dunBuff = {57,58,85}
	for i=1,#dunBuff do
		if buff_type == dunBuff[i] then
			return true
		end
	end
	return false
end

function BaseFightRole:removeZhanShaBuff()
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid and self:isDunBuff(buffInfo.config.type) then 
			self:RemoveBuffByIndex(i)
		end
	end
end

--[[
判断当前角色是否还活着
return 如果角色或者返回true
]]
function BaseFightRole:IsAlive(includePet)
	if self.ispet then
		return includePet or false
	end
	return self.currHp > 0
end

function BaseFightRole:IsLive(includePet)
	if self.ispet then
		return includePet or false
	end
	return self.currHp > 0
end

--[[
判断角色是否为有效攻击目标
@return 如果角色为可攻击目标返回true，否则返回false
]]
function BaseFightRole:IsValidTarget(includePet)
	if not self:IsAlive(includePet) then
		return false
	end

	if self:HaveFrozenBuff(false) then
		return false
	end

	return true
end


function BaseFightRole:addBuffDisplay( buffID ,isloop)
	local buffDisplay = BuffFightDisplayData:objectByID(buffID)
	if buffDisplay == nil then
		return false
	end
	local length = #buffDisplay.display_id
	for i=1,length do
		local under_show = buffDisplay.under_show[i] ~= 0
		self:AddBodyEffect(buffDisplay.display_id[i], isloop , under_show,0,0,buffDisplay.rotation[i])
	end
	return true
end

function BaseFightRole:RemoveBodyEffect(nEffectID)
	local effect = self.bodyEffectList[nEffectID]
	if effect ~= nil then
		self.rolePanel:removeChild(effect)
		self.bodyEffectList[nEffectID] = nil
	end
end

function BaseFightRole:RemoveAllBodyEffect(nEffectID)
	for k,effect in pairs(self.bodyEffectList) do
		if effect ~= nil then
			self.rolePanel:removeChild(effect)
		end
	end
	self.bodyEffectList = {}
end

--
function BaseFightRole:PlayTextEffect(text, pos)
	if self.armature == nil then
		return
	end

	local resPathXML = "effect/"..text..".xml"
	local resPathAlats = "effect/"..text..".atlas" 
	local textEff
	
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "effect/".. text
		textEff = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		textEff = TFArmature:create(text.."_anim")
	else
		return
	end

	if textEff == nil then
		assert(false, "effect/"..text..".xml not find")
		return
	end

	GameResourceManager:addEnemyEffect( self.logicInfo.roleId , text , textEff )
	

	local roleZOrder = self.armature:getZOrder()
	textEff:setZOrder(FIGHT_TEXT_ZORDER)

	textEff:setPosition(pos)

	textEff:setAnimationFps(FightManager.fightSpeed * GameConfig.ANIM_FPS)

	textEff:playByIndex(0)

	TFDirector:currentScene().fightUiLayer.ui:addChild(textEff)
	textEff:addMEListener(TFARMATURE_COMPLETE,
	function() 
		textEff:removeMEListener(TFARMATURE_COMPLETE)
		TFDirector:currentScene().fightUiLayer.ui:removeChild(textEff)
	end)
end

function BaseFightRole:IsSameRow(targetRole)
	if math.abs(self.originPos.y - targetRole.originPos.y) < 10 then
		return true
	else
		return false
	end
end

function BaseFightRole:HaveAnim(animName)
	animName = animName..";"
	local movNames = self.armature:getMovementNameStrings()
	movNames = movNames..";"
	if string.find(movNames, animName) then
		return true
	else
		return false
	end
end


function BaseFightRole:DoHitBackAction()
	if self.armature == nil then
		return
	end

	if self.hitBackTween then
		TFDirector:killTween(self.hitBackTween)
		self.hitBackTween = nil
	end

	local originPos = self:getPosition()
	local movePos = {}
	if self.logicInfo.bEnemyRole then
		movePos.x = originPos.x + 30
	else
		movePos.x = originPos.x - 30
	end

	if self:IsLive() then
		self.hitBackTween = 
		{
			target = self.rolePanel,
			{
				duration = 0.2 / FightManager.fightSpeed,
				x = movePos.x,
				y = movePos.y,
			},
			{
				delay = 0.5 / FightManager.fightSpeed,
				duration = 0.1,
				x = originPos.x,
				y = originPos.y,

				onComplete = function ()
					self.hitBackTween = nil
				end
			},
		}
	else
		self.hitBackTween = 
		{
			target = self.rolePanel,
			{
				duration = 0.2 / FightManager.fightSpeed,
				x = movePos.x,
				y = movePos.y,

				onComplete = function ()
					self.hitBackTween = nil
				end
			},
		}
	end

	TFDirector:toTween(self.hitBackTween)
end

function BaseFightRole:DoAvoidAction()
	if self.armature == nil then
		return
	end

	local originPos = self:getPosition()
	local movePos = {}
	if self.logicInfo.bEnemyRole then
		movePos.x = originPos.x + 70
		movePos.y = originPos.y + 50
	else
		movePos.x = originPos.x - 70
		movePos.y = originPos.y + 50
	end

	local avoid = 
	{
		target = self.rolePanel,
		{
			duration = 0.1 / FightManager.fightSpeed,
			x = movePos.x,
			y = movePos.y,
		},
		{ 
   			duration = 0,
   			delay = 0.7 / FightManager.fightSpeed,

   			onComplete = function ()
				self:setPosition(originPos)
			end	
		},
	}
	TFDirector:toTween(avoid)
end

function BaseFightRole:PlayDieBezier()
	local middlePosX = self:getPosition().x + 200
	local middlePosY = self:getPosition().y + 200
	local endPosX = self:getPosition().x + 400
	local endPosY = self:getPosition().y

	local dieBezier = 
	{
		target = self.rolePanel,
		{
			duration = 1,
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
					x = endPosX,
					y = endPosY,
				},
			},

			rotate = 90,

			onComplete = function ()
				self.rolePanel:setVisible(false)
			end,
		},
	}
	self:SetHpBarVisible()
	TFDirector:toTween(dieBezier)
end

function BaseFightRole:CreateAngerNumFont(angerNum)
	local angerNumFont = TFLabelBMFont:create()
	angerNumFont:setAnchorPoint(ccp(0.5, 0.5))
	angerNumFont:setZOrder(FIGHT_TEXT_ZORDER + self.logicInfo.posindex)

	if angerNum > 0 then
		angerNumFont:setFntFile("font/addAnger.fnt")	
	else
		angerNumFont:setFntFile("font/subAnger.fnt")	
	end

	return angerNumFont
end


--香香公主 援护特效
function BaseFightRole:addYuanHuEffect()
	self:AddBodyEffect("yuanFu_1", false, false, 0, 0, self.logicInfo.bEnemyRole)
	self:AddBodyEffect("yuanFu_2", false, true, 0, 0, self.logicInfo.bEnemyRole)
end

--技能触发
function BaseFightRole:GetTriggerBySkillHurtType(skillID, triggerHurtType, isUse)
	local random = math.random(1, 10000)
	if (not isUse) then
		--只是检测身上有没有此技能
		random = 10000
	end
	local skillInfo 	= SkillLevelData:objectByID(skillID)
	if (skillInfo and skillInfo.trigger_hurtType == triggerHurtType) then
		if random <= skillInfo.triggerSkill_rate then 
			return skillInfo
		end
	end
	return nil
end

function BaseFightRole:getPassiveSkillInfoByEffect( effect )
	-- local passiveSkillNum = #self.passiveSkill
	-- for i=1,passiveSkillNum do
	-- 	local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
	for i,skillID in ipairs(self.passiveSkill) do
		local skillInfo = SkillLevelData:objectByID(skillID)
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillInfo.effect == effect then
			return skillInfo
		end
	end
	return nil
end

function BaseFightRole:RemoveBuffDisplay( buffID )
	print(self.logicInfo.posindex,"  FightRole:RemoveBuffDisplay -->",buffID)
	local buffDisplay = BuffFightDisplayData:objectByID(buffID)
	if buffDisplay == nil then
		self:RemoveBodyEffect(buffID)
		return false
	end
	local length = #buffDisplay.display_id
	for i=1,length do
		self:RemoveBodyEffect(buffDisplay.display_id[i])
	end
	return true
end

function BaseFightRole:CreateDamageNumFont(text, number)
	local damageFont = TFLabelBMFont:create()
	damageFont:setAnchorPoint(ccp(0.5, 0.5))
	damageFont:setZOrder(FIGHT_TEXT_ZORDER + self.logicInfo.posindex)

	if number < 0 then
		if text == "baoji" then --暴击
			damageFont:setFntFile("font/bigDamage.fnt")	
		else
			damageFont:setFntFile("font/damage.fnt")	
		end
	else
		damageFont:setFntFile("font/addHp.fnt")
	end	

	return damageFont
end

function BaseFightRole:PlayHitAnim(bLastHit)
	if self.armature == nil then
		return
	end 

	self.attackAnimEnd = true
	local animName = "hit"
	if self.directional_sensitivity then
		if not bEnemyRole then
			animName = animName.."l"
		else
			animName = animName.."r"
		end
	end

	self.armature:play(animName, -1, -1, 0)

	-- local bufferNum = self.buffList:length()
	-- for i=1,bufferNum do
	-- 	local buffer = self.buffList:objectAt(i)
	for buffer in self.buffList:iterator() do
		if buffer.bValid and buffer.config.behit_display and buffer.config.behit_display ~= "" then
			local animName = buffer.config.behit_display
			if self.directional_sensitivity then
				if not bEnemyRole then
					animName = animName.."l"
				else
					animName = animName.."r"
				end
			end
			self.armature:play(animName, -1, -1, 0)
		end
	end


	if self.bossEffect then
		self.bossEffect:setVisible(false)
	end

	if bLastHit then
		self:DoHitBackAction()
	end

	self.armature:setColor(ccc3(100, 0, 0))

	self.armature:addMEListener(TFARMATURE_COMPLETE, function() 
		self.armature:removeMEListener(TFARMATURE_COMPLETE)
		if self:IsLive() then
			self:PlayStandAnim()
			self.armature:setColor(ccc3(255, 255, 255))
		else
			if bLastHit then
				self:Die()
			end
		end

		local currAction = FightManager:GetCurrAction()
		if currAction ~= nil and bLastHit then
			currAction:OnRoleHitAnimComplete(self.logicInfo.posindex)
		end
	end)
end

function BaseFightRole:MoveToRole(targetRole, distance, beforeMoveAnim)
	if not targetRole then
		return
	end

	distance = distance or 30

	local targetPos = targetRole:getPosition()
	local targetBoxWidth = targetRole.armature:boundingBox().size.width
	local targetPosX = nil
	if self.logicInfo.bEnemyRole then
		targetPosX = targetPos.x + math.floor(targetBoxWidth/2+distance)
	else
		targetPosX = targetPos.x - math.floor(targetBoxWidth/2+distance)
	end

	local targetPosY = targetPos.y - 1

	if beforeMoveAnim ~= nil and self:HaveAnim(beforeMoveAnim) then
		if self.directional_sensitivity then
			if not bEnemyRole then
				beforeMoveAnim = beforeMoveAnim.."l"
			else
				beforeMoveAnim = beforeMoveAnim.."r"
			end
		end
		self.armature:play(beforeMoveAnim, -1, -1, 0)
		if self.bossEffect then
			self.bossEffect:setVisible(false)
		end
		self.armature:addMEListener(TFARMATURE_COMPLETE, 
		function()
			self.armature:removeMEListener(TFARMATURE_COMPLETE)
			self:MoveToPosition(targetPosX, targetPosY)
		end)
	else
		self:MoveToPosition(targetPosX, targetPosY)
	end
end

function BaseFightRole:MoveToPosition(targetPosX, targetPosY)
	self.attackAnimEnd = true

	local animName = "move"
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

	if self.hitBackTween then
		TFDirector:killTween(self.hitBackTween)
		self.hitBackTween = nil
	end

	local moveTween = 
	{
		target = self.rolePanel,
		{
			ease = {type=TFEaseType.EASE_IN_OUT, rate=3},
			duration = 0.5 / FightManager.fightSpeed,
			x = targetPosX,
			y = targetPosY,

			onUpdate = function ()
				self:UpdateZOrder()
			end,
		
			onComplete = function ()
				self:UpdateZOrder()
				self:OnReachTarget()
				self.isreturn = false
			end,
		},
	}
	TFDirector:toTween(moveTween)
end

function BaseFightRole:OnReachTarget()
	FightManager:GetCurrAction():ShowAttackAnim()
end

--在自己身上添加特效
function BaseFightRole:AddBodyEffect(nEffectID, bLoop, bBehindBody, nPosOffsetX, nPosOffsetY,isRotation)
	if (FightManager.isTiaoGuo) then
		return
	end
	if self.armature == nil then
		return
	end

	if self.bodyEffectList[nEffectID] ~= nil then
		return
	end


	local resPathXML = "effect/"..nEffectID..".xml"
	local resPathAlats = "effect/"..nEffectID..".atlas" 
	local bodyEffect
	
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "effect/".. nEffectID
		bodyEffect = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		bodyEffect = TFArmature:create(nEffectID.."_anim")
	else
		return
	end

	
	-- if self.logicInfo.bEnemyRole then
	-- 	GameResourceManager:addEnemyEffect( self.logicInfo.roleId , nEffectID , resPath )
	-- else
	-- 	GameResourceManager:addRoleEffect( self.logicInfo.roleId , nEffectID , resPath )
	-- end

	if bodyEffect == nil then
		assert(false, "bodyEffect"..nEffectID.."create error")
		return
	end

	isRotation = isRotation or 0
	nPosOffsetX = nPosOffsetX or 0
	nPosOffsetY = nPosOffsetY or 0
	bodyEffect:setPosition(ccp(nPosOffsetX, nPosOffsetY))

	bodyEffect:setAnimationFps(GameConfig.ANIM_FPS)
	-- bodyEffect:setAnimationFps(FightManager.fightSpeed * GameConfig.ANIM_FPS)
	if self.logicInfo.bEnemyRole and isRotation ~= 0 then
		bodyEffect:setRotationY(180)
	end
	if bBehindBody then
		local roleZOrder = self.armature:getZOrder()
		bodyEffect:setZOrder(roleZOrder-1)
	else
		bodyEffect:setZOrder(200)
	end

	self.rolePanel:addChild(bodyEffect)

	local movNames = bodyEffect:getMovementNameStrings()
	local moveList = string.split(movNames, ";")

	if #moveList <= 1 then
		if bLoop then
			bodyEffect:playByIndex(0, -1, -1, 1)
		else
			bodyEffect:playByIndex(0, -1, -1, 0)
			bodyEffect:addMEListener(TFARMATURE_COMPLETE,
			function()
				bodyEffect:removeMEListener(TFARMATURE_COMPLETE) 
				self:RemoveBodyEffect(nEffectID)
			end)
		end
	else
		bodyEffect:playByIndex(0, -1, -1, 0)
		bodyEffect:addMEListener(TFARMATURE_COMPLETE,
			function()
				bodyEffect:removeMEListener(TFARMATURE_COMPLETE) 
				bodyEffect:playByIndex(1, -1, -1, 1)
			end)
	end

	self.bodyEffectList[nEffectID] = bodyEffect
end
function BaseFightRole:PlayYuanHuAnim(rolePos)
	if self.armature == nil then
		return
	end
	self.isYuanHuAction = true

	local animName = "huanhu"
	if self.directional_sensitivity then
		if not bEnemyRole then
			animName = animName.."l"
		else
			animName = animName.."r"
		end
	end


	self.armature:play(animName, -1, -1, 0)

	if self.bossEffect then
		self.bossEffect:setVisible(false)
	end

	local originPos = self:getPosition()
	local movePos = {}
	local nowPos = clone(originPos)
	if self.logicInfo.bEnemyRole then
		movePos.x = rolePos.x - 30
	else
		movePos.x = rolePos.x + 30
	end
	movePos.y = rolePos.y
	local isUpdate = true
	if (math.abs(rolePos.x - originPos.x) <= 1 and math.abs(rolePos.y - originPos.y) <= 1) then
		movePos = originPos
		isUpdate = false
	end
	-- local m_nCurFrame = 0
	if (isUpdate) then
		--坑爹的 香香跟小昭 援护动作帧不一样
		self.armature:addMEListener(TFARMATURE_UPDATE, function(test1,test2,frame)
			-- m_nCurFrame = m_nCurFrame + 1
			if frame >= 4 and frame <= 6 then
				self:setPosition(movePos)
				self:UpdateZOrder()
			elseif frame >= 36 then
				self.armature:removeMEListener(TFARMATURE_UPDATE)
				self:setPosition(nowPos)
				self:UpdateZOrder()
			end
		end)
	end

	self.armature:addMEListener(TFARMATURE_COMPLETE, function() 
		self.armature:removeMEListener(TFARMATURE_COMPLETE)
		if self:IsLive() then
			self:PlayStandAnim()
			self.armature:setColor(ccc3(255, 255, 255))
		else
			self:Die()
		end

		local currAction = FightManager:GetCurrAction()
		if currAction ~= nil then
			currAction:OnRoleHitAnimComplete()
		end
	end)
end

function BaseFightRole:setTiHuanRole( armatureID )
	if self.tihuan_armature then
		self.tihuan_armature:removeFromParent(true)
		self.tihuan_armature = nil
	end
	
	local resPathXML = "armature/"..armatureID..".xml"
	local resPathAlats = "armature/".. armatureID .. ".atlas" 
	local armature
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "armature/".. armatureID
		armature = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		armature = TFArmature:create(armatureID.."_anim")
	else
		armatureID = 10006
		TFResourceHelper:instance():addArmatureFromJsonFile("armature/"..armatureID..".xml")
		armature = TFArmature:create(armatureID.."_anim")
	end
	
	if armature == nil then
		assert(false, "armature"..armatureID.."create error")
		return
	end
	if self.logicInfo.bEnemyRole then
		armature:setRotationY(180)
	end
	self.tihuan_armature = armature
	self.tihuan_armature:setPosition(ccp(0,0))
	self.tihuan_armature:setVisible(true)
	self.old_armature:setVisible(false)
	self.rolePanel:addChild(self.tihuan_armature)
	self.armature = self.tihuan_armature

	armature:setAnimationFps(FightManager.fightSpeed * GameConfig.ANIM_FPS)
	self:PlayStandAnim()
end
-------------mgr--------------------
function BaseFightRole:PlaySkillEffect(nEffectID, effectType, nPosOffsetX, nPosOffsetY, effectScale ,isRotation,targetRole, flyEffRotate)
	if self.armature == nil then
		return
	end

	local resPathXML = "effect/"..nEffectID..".xml"
	local resPathAlats = "effect/"..nEffectID..".atlas" 
	local skillEff
	
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "effect/".. nEffectID
		skillEff = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		skillEff = TFArmature:create(nEffectID.."_anim")
	else
		if (GameConfig.HD) then
			if not bEnemyRole then
				nEffectID = nEffectID.."r"
			else 
				nEffectID = nEffectID.."l"
			end
			resPath = "effect/"..nEffectID..".xml"
			if not TFFileUtil:existFile(resPath) then
				return
			end
		end
		return
	end

---	local resPath = "effect/"..nEffectID..".xml"
---	if not TFFileUtil:existFile(resPath) then
---		if (GameConfig.HD) then
---			if not bEnemyRole then
---				nEffectID = nEffectID.."r"
---			else 
---				nEffectID = nEffectID.."l"
---			end
---			resPath = "effect/"..nEffectID..".xml"
---			if not TFFileUtil:existFile(resPath) then
---				return
---			end
---		end
---		return
---	end

---	TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
---	local skillEff = TFArmature:create(nEffectID.."_anim")
	if skillEff == nil then
		assert(false, "skillEff"..nEffectID.."create error")
		return
	end
	if (GameConfig.HD) then
		if self.logicInfo.bEnemyRole then
			GameResourceManager:addEnemyEffect( self.logicInfo.roleId , nEffectID , skillEff )
		else
			GameResourceManager:addRoleEffect( self.logicInfo.roleId , nEffectID , skillEff )
		end
	else
		GameResourceManager:addEnemyEffect( self.logicInfo.roleId , nEffectID , skillEff )
	end

	nPosOffsetX = nPosOffsetX or 0
	nPosOffsetY = nPosOffsetY or 0
	effectType = effectType or 0
	if isRotation == nil then
		isRotation = true
	end

	local effPosX = 0
	local effPosY = 0
	if effectType == 1 or effectType == 8 then
		effPosX = GameConfig.WS.width/2
		effPosY = GameConfig.WS.height/2
	elseif effectType == 6 or effectType == 9 then
		local pos = 4
		if self.logicInfo.bEnemyRole then
			pos = 13
		end
		local rolePos = FightManager:GetPosByIndex(pos,self.logicInfo.roleId)
		effPosX = rolePos.x
		effPosY = rolePos.y
	elseif effectType == 7 or effectType == 10 then
		local pos = 13
		if self.logicInfo.bEnemyRole then
			pos = 4
		end
		local rolePos = FightManager:GetPosByIndex(pos,self.logicInfo.roleId)
		effPosX = rolePos.x
		effPosY = rolePos.y
	elseif effectType > 1 and effectType <= 4 then
		local rolePos = self:getPosition()
		effPosX = rolePos.x
		effPosY = rolePos.y
	elseif effectType == 11 or effectType == 12 then
		local pos = 13
		if self.logicInfo.bEnemyRole then
			pos = 4
		end
		local _rolePos = FightManager:GetPosByIndex(pos,self.logicInfo.roleId)
		effPosX = _rolePos.x
		local rolePos = self:getPosition()
		effPosY = rolePos.y
	end

	effPosY = effPosY + nPosOffsetY
	if not self.logicInfo.bEnemyRole then
		effPosX = effPosX + nPosOffsetX
	else
		effPosX = effPosX - nPosOffsetX
	end

	skillEff:setPosition(ccp(effPosX, effPosY))

	skillEff:setAnimationFps(self.animSpeed * GameConfig.ANIM_FPS)

	if self.logicInfo.bEnemyRole and isRotation then
		print("isRotation=========>>",isRotation)
		skillEff:setRotationY(180)
	end

	if effectScale == nil then
		effectScale = 1
	end
	skillEff:setScale(effectScale)
	local roleMgr = FightManager:getFightRoleMgr()
	if effectType == 0 then
		self.rolePanel:addChild(skillEff)
	elseif effectType == 5 or effectType == 13 then
		skillEff:setZOrder(-1000)
		self.rolePanel:addChild(skillEff)
	elseif effectType == 6 or effectType == 7 or effectType == 11  then
		skillEff:setZOrder(-1000)
		roleMgr.roleLayer:addChild(skillEff)
	elseif effectType == 8 or effectType == 9 or effectType == 10 or effectType == 12 then
		skillEff:setZOrder(EFFECT_ZORDER)
		roleMgr.roleLayer:addChild(skillEff)
	else
		local roleZOrder = self.armature:getZOrder()
		skillEff:setZOrder(EFFECT_ZORDER + roleZOrder)
		roleMgr.roleLayer:addChild(skillEff)
	end

	if effectType == 0 or effectType == 1 or effectType == 2 or (effectType >= 5 and effectType <= 13) then
		skillEff:playByIndex(0, -1, -1, 0)
		skillEff:addMEListener(TFARMATURE_COMPLETE,
		function()
			skillEff:removeMEListener(TFARMATURE_COMPLETE)
			if effectType == 0 then
				self.rolePanel:removeChild(skillEff)
			else
				roleMgr.roleLayer:removeChild(skillEff)
			end
			if (self:GetSummoned() ~= 0) then
				if (self.armature:isVisible() == false and self:IsLive()) then
					self:SetRoleVisible(true)
					-- FightManager:OnAddRoleEnd()
				end
			end
		end)
	else -- 飞行特效 循环播放
		skillEff:playByIndex(0, -1, -1, 1)
		self:MoveSkillEffect(skillEff, effectType, targetRole, flyEffRotate)
	end
end

--
function BaseFightRole:MoveSkillEffect(skillEffect, effectType, targetRole, flyEffRotate)
	if targetRole == nil then
		assert(false)
		return
	end

	if self.logicInfo.bEnemyRole then
		skillEffect:setRotationY(180)
	end

	local movePath = 
	{
		target = skillEffect,
		{
			duration = 0.3 / FightManager.fightSpeed,
			x = targetRole.originPos.x,
			y = targetRole.originPos.y,

			onComplete = function ()
				FightManager:getFightRoleMgr().roleLayer:removeChild(skillEffect)
			end,
		},
	}

	TFDirector:toTween(movePath)
end

function BaseFightRole:PlaySkillNameEffect()
	if self.armature == nil then
		return
	end

	TFResourceHelper:instance():addArmatureFromJsonFile("effect/light.xml")

	local lightEff = TFArmature:create("light_anim")
	if lightEff == nil then
		return
	end

	lightEff:setZOrder(EFFECT_ZORDER + 102)

	local rolePos = self:getPosition()
	local effPosX = rolePos.x
	local effPosY = rolePos.y
	lightEff:setPosition(ccp(effPosX, effPosY-50))

	lightEff:setAnimationFps(FightManager.fightSpeed * GameConfig.ANIM_FPS)

	lightEff:playByIndex(0)

	FightManager:getFightRoleMgr().roleLayer:addChild(lightEff)
	lightEff:addMEListener(TFARMATURE_COMPLETE,
	function() 
		lightEff:removeMEListener(TFARMATURE_COMPLETE)
		FightManager:getFightRoleMgr().roleLayer:removeChild(lightEff)
		local currAction = FightManager:GetCurrAction()
		if currAction then
			currAction:BeginAttack()
		end
	end)
end

function BaseFightRole:AddCommonAnger(num)
	if self:GetBuffByType(16) ~= nil then
		return
	end

	if num == nil or num == 0 then
		return
	end

	FightManager:getFightRoleMgr():AddAnger(self.logicInfo.bEnemyRole, num , true)
end

--------------以下方法是一定要被继续重写的-------------------
function BaseFightRole:ShowFightText(text, number, bAngerNum, bTestDie, bBezier, isBuff)
	toastMessage("-->ShowFightText")
end
function BaseFightRole:RemoveBuffByIndex(buffIndex)
	toastMessage("-->RemoveBuffByIndex")
end

function BaseFightRole:HaveFrozenBuff( isCanAttack )
	toastMessage("-->HaveFrozenBuff")
end

function BaseFightRole:Die()
	toastMessage("-->die")
end
function BaseFightRole:ReturnBack()
	toastMessage("-->ReturnBack")
end

function BaseFightRole:OnActionEnd()
	toastMessage("-->OnActionEnd")
end
function BaseFightRole:AddBuff()
	toastMessage("-->AddBuff")
end
function BaseFightRole:OnActionEnd()
	toastMessage("-->OnActionEnd")
end
function BaseFightRole:RemoveBuffByInfo()
	toastMessage("-->RemoveBuffByInfo")
end
--------------以上方法是一定要被继续重写的-------------------
return BaseFightRole