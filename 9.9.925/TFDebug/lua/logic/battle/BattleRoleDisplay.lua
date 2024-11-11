--
-- Author: Zippo
-- Date: 2013-12-05 17:34:00
--

local mapLayer  = require("lua.logic.battle.BattleMapLayer")
local battleRoleMgr  = require("lua.logic.battle.BattleRoleManager")
-- local fightRoundMgr  = require("lua.logic.battle.FightRoundManager")

local BattleRoleDisplay = class("BattleRoleDisplay")

local EFFECT_ZORDER = 100
local FIGHT_TEXT_ZORDER = 300
	
function BattleRoleDisplay:ctor(roleInfo)
	local nPosIndex = roleInfo.posindex
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

	local bNpc = false
	if roleInfo.typeid == 2 then
		bNpc = true
	end

	local roleTableData = nil
	if self.ispet then
		roleTableData = BattlePetData:objectByID(roleInfo.roleId)
	else
		if bNpc then
			roleTableData = NPCData:objectByID(roleInfo.roleId)
		else
			roleTableData = RoleData:objectByID(roleInfo.roleId)
		end
	end

	if roleTableData == nil then
		print("role configure not found : ",roleInfo.typeid,roleInfo.roleId)
	end

	self.directional_sensitivity = false
	if roleTableData.directional_sensitivity and roleTableData.directional_sensitivity == 1 then
		self.directional_sensitivity = true
	end

	self.quality = 1
	if self.ispet then
		self.quality = roleInfo.maxhp
	end


	local armatureID = 10040
	if self.ispet then
		armatureID = roleTableData:getIcon(self.quality)
	else
		armatureID = roleTableData.image
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

	if bEnemyRole then
		GameResourceManager:addEnemy( roleInfo.roleId , armature )
	else
		GameResourceManager:addRole( roleInfo.roleId , armature )
	end

	self.armatureID = armatureID
	self.armature = armature
	self.old_armature = armature
	self.armature:setPosition(ccp(0,0))

	self.rolePanel = TFPanel:create()
	self.rolePanel:setSize(self.armature:getContentSize())
	self.rolePanel:addChild(self.armature)

	self.originPos = mapLayer.GetPosByIndex(nPosIndex,roleInfo.roleId)
	
	self:setPosition(clone(self.originPos))

	armature:setAnimationFps(FightManager.fightSpeed * GameConfig.ANIM_FPS)

	if bEnemyRole then
		armature:setRotationY(180)
	end

	self.logicInfo = roleInfo
	self.logicInfo.bEnemyRole = bEnemyRole
	self.currHp = roleInfo.maxhp
	self.maxhp = self.logicInfo.attr[1]

	self.passiveSkill = roleInfo.passiveskill or {}

	if self.ispet then
		self.iconPath = roleTableData:getIconPath(self.quality)
		self.headPath = "icon/head/"..roleTableData:getIcon(self.quality)..".png"
	else
		self.headPath = "icon/head/"..roleTableData.image..".png"
	end

	self.animSpeed = FightManager.fightSpeed

	self.normalAttackSkillID = roleTableData.normal_attack
	self.haveAttack          = false
	self.buffList            = TFArray: new()
	self.bodyEffectList      = {}
	self.bufferIconList      = {}

	if self.logicInfo.name == nil then
		self.logicInfo.name = roleTableData.name or ""
	end
	print(self.logicInfo.name .."属性: ",displayAttributeString(self.logicInfo.attr))
	self.profession = 1
	self.sex = 1
	if not self.ispet then
		if bNpc then
			local npcInfo = RoleData:objectByID(roleTableData.role_id)
			if npcInfo ~= nil then
				self.sex = npcInfo.sex
				self.profession = npcInfo.outline
			end
		else
			self.sex = roleTableData.sex
			self.profession = roleTableData.outline
		end
	end

	self:UpdateZOrder()
	self:PlayStandAnim()

	self:CreateHpLabel()
	self:CreateShadowImg()
	self:CreateHalo()

	if roleInfo.isboss and roleInfo.isboss == true then
		self:AddBossEffect("fight_boss")
	end

	if self.ispet then
		self.rolePanel:setVisible(false)
	end
	self.isreturn      = true
	self.addDelay      = 0 
	self.lastFloatTime = 0
	self.summoned 	    = roleTableData.summoned or 0
end


--不等于0时为召唤物
function BattleRoleDisplay:GetSummoned()
	return self.summoned
end

function BattleRoleDisplay:showSelfDisplay()
	if self.tihuan_armature then
		self.armature = self.old_armature
		self.old_armature:setVisible(true)
		self.tihuan_armature:removeFromParent(true)
		self.tihuan_armature = nil
		self:PlayStandAnim()
	end
end

function BattleRoleDisplay:setTiHuanRole( armatureID )
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

end

function BattleRoleDisplay:dispose()
	TFDirector:killAllTween(self.rolePanel)
end


function BattleRoleDisplay:setScale( scale )
	self.rolePanel:setScale(scale)
end
function BattleRoleDisplay:CreateShadowImg()
	local shadowImg = TFImage:create("ui_new/fight/shadow.png")
	shadowImg:setZOrder(-1001)
	shadowImg:setAnchorPoint(ccp(0.5, 0.5))
	self.shadowImg = shadowImg
	self.rolePanel:addChild(shadowImg)
end

function BattleRoleDisplay:changeHpLabel()
	--if (self:GetSummoned() ~= 0) then
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
--	end
end	

function BattleRoleDisplay:SetRoleVisible(isVisible)
	if (self.hpBackground) then
		self.hpBackground:setVisible(isVisible)
	end
	if (self.armature) then
		self.armature:setVisible(isVisible)
	end
end

--
function BattleRoleDisplay:CreateHpLabel()
	if FightManager.fightBeginInfo.bSkillShowFight then
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

function BattleRoleDisplay:SetHpBarVisible(bVisible)
	if self.ispet and bVisible then
		return
	end
	if self.hpBackground ~= nil then
		self.hpBackground:setVisible(bVisible)
	end

	self.shadowImg:setVisible(bVisible)
end



function BattleRoleDisplay:AddCommonAnger(num)
	if self:GetBuffByType(16) ~= nil then
		return
	end

	if num == nil or num == 0 then
		return
	end

	battleRoleMgr:AddAnger(self.logicInfo.bEnemyRole, num)
end

function BattleRoleDisplay:setPosition(pos)
	self.rolePanel:setPosition(pos)
end

function BattleRoleDisplay:getPosition()
	return self.rolePanel:getPosition()
end

function BattleRoleDisplay:GetRowIndex()
	local posIndex = self.logicInfo.posindex
	if posIndex >= 9 then
		posIndex = posIndex - 9
	end

	return math.floor(posIndex/3)
end

function BattleRoleDisplay:GetColumnIndex()
	local posIndex = self.logicInfo.posindex
	if posIndex >= 9 then
		posIndex = posIndex - 9
	end

	return posIndex%3
end

function BattleRoleDisplay:OnActionStart()
	if self:IsLive() then
		if self.hitBackTween then
			TFDirector:killTween(self.hitBackTween)
			self.hitBackTween = nil
		end

		--目标原地被反击
		if FightManager:GetCurrAction().actionInfo.type == 2 then
			local targetRole = FightManager:GetCurrAction():GetTargetRole(1)
			if targetRole == self then
				print("target role is myself. return....")
				return
			end
		end

		self:setPosition(clone(self.originPos))
		self:UpdateZOrder()

	end
end
function BattleRoleDisplay:SetSpeed(speed)
	self.animSpeed = speed
	self.armature:setAnimationFps(speed * GameConfig.ANIM_FPS)

	for k,effect in pairs(self.bodyEffectList) do
		if effect ~= nil then
			effect:setAnimationFps(speed * GameConfig.ANIM_FPS)
		end
	end
end

function BattleRoleDisplay:UpdateZOrder()
	local rolePos = self:getPosition()
	self.rolePanel:setZOrder(-rolePos.y)
end

function BattleRoleDisplay:MoveToRole(targetRole, distance, beforeMoveAnim)
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

function BattleRoleDisplay:MoveToPosition(targetPosX, targetPosY)
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

function BattleRoleDisplay:OnReachTarget()
	FightManager:GetCurrAction():ShowAttackAnim()
end
function BattleRoleDisplay:isNeedBack()
	return not self.isreturn
	-- local currPos = self:getPosition()
	-- local eq = (self.originPos.x == currPos.x and self.originPos.y == currPos.y)
	-- return not eq
end

function BattleRoleDisplay:ReturnBack()
	TFDirector:currentScene():ZoomOut()
	
	if self.armature == nil then
		FightManager:OnActionEnd()
		return
	end

	if not self:IsLive() then
		FightManager:OnActionEnd()
		return
	end

	local currPos = self:getPosition()
	self.originPos = mapLayer.GetPosByIndex(self.logicInfo.posindex,self.logicInfo.roleId)
	local eq = (self.originPos.x == currPos.x and self.originPos.y == currPos.y)
	if eq or FightManager:HaveBackAttackAction(self.logicInfo.posindex) then
		self:PlayStandAnim()
		FightManager:OnActionEnd()
		return
	end
	

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
					self.isreturn = true
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
					self.isreturn = true
					FightManager:OnActionEnd()
				end,
			},
		}
		self.shadowImg:setVisible(false)
		TFDirector:toTween(returnBackBezier)
	end
end
function BattleRoleDisplay:_ReturnBack()
	if self.armature == nil then
		return
	end

	if not self:IsLive() then
		return
	end

	local currPos = self:getPosition()
	local eq = (self.originPos.x == currPos.x and self.originPos.y == currPos.y)
	if eq then
		self:PlayStandAnim()
		return
	end


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

	self.armature:play("back")
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
					self.isreturn = true
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
					self.isreturn = true
				end,
			},
		}
		self.shadowImg:setVisible(false)
		TFDirector:toTween(returnBackBezier)
	end
end

--在自己身上添加特效
function BattleRoleDisplay:AddBodyEffect(nEffectID, bLoop, bBehindBody, nPosOffsetX, nPosOffsetY,isRotation)
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

	if bodyEffect == nil then
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

function BattleRoleDisplay:RemoveBodyEffect(nEffectID)
	local effect = self.bodyEffectList[nEffectID]
	if effect ~= nil then
		self.rolePanel:removeChild(effect)
		self.bodyEffectList[nEffectID] = nil
	end
end

function BattleRoleDisplay:RemoveAllBodyEffect(nEffectID)
	for k,effect in pairs(self.bodyEffectList) do
		if effect ~= nil then
			self.rolePanel:removeChild(effect)
		end
	end
	self.bodyEffectList = {}
end

function BattleRoleDisplay:PlaySkillEffect(nEffectID, effectType, nPosOffsetX, nPosOffsetY, effectScale ,isRotation,targetRole, flyEffRotate)
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
			if not bEnemyRole then
				nEffectID = nEffectID.."r"
			else 
				nEffectID = nEffectID.."l"
			end
				resPath = "effect/"..nEffectID..".xml"
			if not TFFileUtil:existFile(resPath) then
				print("没有资源 resPath === nil",resPath)
				return
			end
			TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
			skillEff = TFArmature:create(nEffectID.."_anim")
	end
  
	
	---if not TFFileUtil:existFile(resPath) then
	---	if not bEnemyRole then
	---		nEffectID = nEffectID.."r"
	---	else 
	---		nEffectID = nEffectID.."l"
	---	end
	---	resPath = "effect/"..nEffectID..".xml"
	---	if not TFFileUtil:existFile(resPath) then
	---		print("没有资源 resPath === nil",resPath)
	---		return
	---	end
	---end


	if skillEff == nil then
		return
	end

	if self.logicInfo.bEnemyRole then
		GameResourceManager:addEnemyEffect( self.logicInfo.roleId , nEffectID , skillEff )
	else
		GameResourceManager:addRoleEffect( self.logicInfo.roleId , nEffectID , skillEff )
	end

	nPosOffsetX = nPosOffsetX or 0
	nPosOffsetY = nPosOffsetY or 0
	if isRotation == nil then
		isRotation = true
	end
	-- isRotation = isRotation or true

	effectType = effectType or 0 
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
		local rolePos = mapLayer.GetPosByIndex(pos,self.logicInfo.roleId)
		effPosX = rolePos.x
		effPosY = rolePos.y
	elseif effectType == 7 or effectType == 10 then
		local pos = 13
		if self.logicInfo.bEnemyRole then
			pos = 4
		end
		local rolePos = mapLayer.GetPosByIndex(pos,self.logicInfo.roleId)
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
		local _rolePos = mapLayer.GetPosByIndex(pos,self.logicInfo.roleId)
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

	if effectType == 0 then
		self.rolePanel:addChild(skillEff)
	elseif effectType == 5 then
		skillEff:setZOrder(-1000)
		self.rolePanel:addChild(skillEff)
	elseif effectType == 6 or effectType == 7 or effectType == 11  then
		skillEff:setZOrder(-1000)
		battleRoleMgr.roleLayer:addChild(skillEff)
	elseif effectType == 8 or effectType == 9 or effectType == 10 or effectType == 12 then
		skillEff:setZOrder(EFFECT_ZORDER)
		battleRoleMgr.roleLayer:addChild(skillEff)
	else
		local roleZOrder = self.armature:getZOrder()
		skillEff:setZOrder(EFFECT_ZORDER + roleZOrder)
		battleRoleMgr.roleLayer:addChild(skillEff)
	end

	if effectType == 0 or effectType == 1 or effectType == 2 or (effectType >= 5 and effectType <= 12) then
		skillEff:playByIndex(0, -1, -1, 0)
		skillEff:addMEListener(TFARMATURE_COMPLETE,
		function()
			skillEff:removeMEListener(TFARMATURE_COMPLETE)
			if effectType == 0 then
				self.rolePanel:removeChild(skillEff)
			else
				battleRoleMgr.roleLayer:removeChild(skillEff)
			end
		end)
	else -- 飞行特效 循环播放
		skillEff:playByIndex(0, -1, -1, 1)
		self:MoveSkillEffect(skillEff, effectType, targetRole, flyEffRotate)
	end
end

function BattleRoleDisplay:PlayTextEffect(text, pos)
	if self.armature == nil then
		return
	end

	local resPath = "effect/"..text..".xml"
	if not TFFileUtil:existFile(resPath) then
		return
	end

	TFResourceHelper:instance():addArmatureFromJsonFile(resPath)

	
	local textEff = TFArmature:create(text.."_anim")
	if textEff == nil then
		assert(false, "effect/"..text..".xml not find")
		return
	end

	if self.logicInfo.bEnemyRole then
		GameResourceManager:addEnemyEffect( self.logicInfo.roleId , text , textEff )
	else
		GameResourceManager:addRoleEffect( self.logicInfo.roleId , text , textEff )
	end


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

function BattleRoleDisplay:PlaySkillNameEffect()
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

	battleRoleMgr.roleLayer:addChild(lightEff)
	lightEff:addMEListener(TFARMATURE_COMPLETE,
	function() 
		lightEff:removeMEListener(TFARMATURE_COMPLETE)
		battleRoleMgr.roleLayer:removeChild(lightEff)
		if FightManager:GetCurrAction() then
			FightManager:GetCurrAction():BeginAttack()
		end
	end)
end

function BattleRoleDisplay:IsSameRow(targetRole)
	if math.abs(self.originPos.y - targetRole.originPos.y) < 10 then
		return true
	else
		return false
	end
end

function BattleRoleDisplay:MoveSkillEffect(skillEffect, effectType, targetRole, flyEffRotate)
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
				battleRoleMgr.roleLayer:removeChild(skillEffect)
			end,
		},
	}

	TFDirector:toTween(movePath)
end

function BattleRoleDisplay:HaveAnim(animName)
	animName = animName..";"
	local movNames = self.armature:getMovementNameStrings()
	movNames = movNames..";"
	if string.find(movNames, animName) then
		return true
	else
		return false
	end
end

function BattleRoleDisplay:PlayAttackAnim(bNormalAttack, animName)
	if self.armature == nil then
		return
	end

	local currAction = FightManager:GetCurrAction()
	if currAction.skillDisplayInfo.attackAnimMove then
		self:SetHpBarVisible(false)
	end

	if self.logicInfo.bEnemyRole == false and currAction.actionInfo.skill and currAction.actionInfo.skill[1].skillId > 0 and currAction.skillDisplayInfo.remote == 0 then
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

function BattleRoleDisplay:PlayStandAnim()
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

function BattleRoleDisplay:PlayHitAnim(bLastHit)
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

	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffer = self.buffList:objectAt(i)
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

function BattleRoleDisplay:DoHitBackAction()
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

function BattleRoleDisplay:DoAvoidAction()
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



function BattleRoleDisplay:fuHuoActionEnd()
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

function BattleRoleDisplay:Die()
	if self.armature == nil then
		return
	end
	battleRoleMgr:refreshMaxHp()
	TFDirector:currentScene().fightUiLayer:OnFightRoleDie(self)

	self:RemoveAllBuff()

	self:RemoveAllBodyEffect()

	local currAction = FightManager:GetCurrAction()
	if currAction ~= nil and currAction.bEnemyAllDie and self.logicInfo.bEnemyRole then
		self:PlayDieBezier()
	else
		if self:HaveAnim("die") then
			self.armature:setColor(ccc3(255, 255, 255))
			self.armature:play("die", -1, -1, 0)
			self:setPosition(self.originPos)
			self:UpdateZOrder()
			return
		end
			
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
end

function BattleRoleDisplay:PlayDieBezier()
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

function BattleRoleDisplay:ReLive(reliveHp)
	-- if self.haveRelive then
	-- 	return false
	-- end

	self:RemoveAllBuff()

	-- self.haveRelive = true
	self:AddBodyEffect("fuhuo", false)
	print("self:AddBodyEffect(fuhuo)")
	self:ShowEffectName("fuhuo")
	self:SetHp(reliveHp)

	TFDirector:currentScene().fightUiLayer:OnFightRoleReLive(self)
	return true
end

function BattleRoleDisplay:CreateDamageNumFont(text, number)
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

function BattleRoleDisplay:CreateAngerNumFont(angerNum)
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

function BattleRoleDisplay:SetHp(currHp, bTestDie)
	local oldHp = self.currHp
	self.currHp = currHp
	self.currHp = math.max(self.currHp, 0)
	local maxHp = self.maxhp
	local addHpPercent = 1
	-- if (self:GetSummoned() ~= 0) then
	-- 	--召唤物治疗溢出
	-- 	local constantInfo = ConstantData:objectByID("SummonedPercentMaxHP")
	-- 	if (constantInfo) then
	-- 		addHpPercent = addHpPercent + math.floor(constantInfo.value / 100)
	-- 	end
	-- end
	-- addHpPercent = addHpPercent + battleRoleMgr:GetSkillAddMaxHpByRole(self.logicInfo.bEnemyRole)
	addHpPercent = addHpPercent + battleRoleMgr.addHpPercentRole[self.logicInfo.bEnemyRole] or 0
	if (addHpPercent > 1) then
		self.saveAddHpPercent = addHpPercent
	else
		if (self.saveAddHpPercent) then
			if (self.currHp > self.maxhp) then
				addHpPercent = self.saveAddHpPercent
				if (self.currHp > oldHp) then
					self.currHp = oldHp
				end
			else
				self.saveAddHpPercent = nil
			end
		end
	end
	maxHp = math.floor(maxHp * addHpPercent)
	--
	self.currHp = math.min(self.currHp, maxHp)
	
	local str = "阵位:"..self.logicInfo.posindex.." "..self.logicInfo.name.."最大 "..maxHp.." 剩余 "..self.currHp
	--
	if (FightManager.log_fileName) then
		local currHurt = self.currHp - oldHp
		local _str = str.."  之前  "..oldHp.." 本次伤害 "..currHurt.." MaxHp:"..self.maxhp
		if (isBuff) then
			_str = "BUFF-->".._str
		end
		Lua_fightWriteFile(EnumFight_Log.HP, nil, "        ".._str)
	end
	print(str)
	--
	if self.hpLabel ~= nil then
		self.hpLabel:setPercent(self.currHp*100 / self.maxhp)
		self:changeHpLabel()
	end

	if bTestDie == nil then
		bTestDie = true
	end

	if bTestDie and self.currHp <= 0 then
		self:Die()
	end
end


function BattleRoleDisplay:ShowFightText(text, number, bAngerNum, bTestDie, bBezier, isBuff)
	if self.armature == nil then
		return
	end

	if FightManager.fightBeginInfo.bSkillShowFight then
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
	local currHp = self.currHp + number
	if self:GetBuffByType(56) then
		currHp = math.max(currHp,1)
	end
	self:SetHp(currHp, bTestDie)

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
		fightTextLabel:setScale(0)
		fightTextLabel:setAlpha(0.5)
		textTween = 
		{
			target = fightTextLabel,
			{
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

--状态类型：1中毒 2灼烧 3破绽 4虚弱 5重伤 6迟缓 7失明 8神力 9防守 10混乱 11散功 12点穴 13击晕 14冻结 15昏睡
--			16束手 17回血 18挑衅 19反弹 25赏善 26罚恶 27乾坤挪移 28护体(受击给攻击方加buff) 30 血刀大法
--			32 免伤 
function BattleRoleDisplay:GetBuffByType(buffType)
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffer = self.buffList:objectAt(i)
		if buffer.bValid and buffer.config.type == buffType then
			return buffer
		end
	end
	return nil
end

function BattleRoleDisplay:HaveForbidAttackBuff()
	local forbidAttackBuff = {12, 13, 14, 15}
	for i=1,#forbidAttackBuff do
		if self:GetBuffByType(forbidAttackBuff[i]) ~= nil then
			return true
		end
	end
	return false
end

function BattleRoleDisplay:HaveForbidBackAttackBuff()
	local forbidAttackBuff = {12, 13, 14}
	for i=1,#forbidAttackBuff do
		if self:GetBuffByType(forbidAttackBuff[i]) ~= nil then
			return true
		end
	end
	return false
end

function BattleRoleDisplay:HaveForbidManualSkillBuff()
	local forbidSkillBuff = {10, 11, 12, 13, 14, 15}
	for i=1,#forbidSkillBuff do
		if self:GetBuffByType(forbidSkillBuff[i]) ~= nil then
			return true
		end
	end
	return false
end

function BattleRoleDisplay:TestReleaseManualSkill()
	if self:HaveForbidManualSkillBuff() then
		TFDirector:currentScene().fightUiLayer:ForbidSkill(self, true)
	else
		TFDirector:currentScene().fightUiLayer:ForbidSkill(self, false)
	end
end


function BattleRoleDisplay:AddBuff(buffID, level , hurt)
	local config =  SkillLevelData:getBuffInfo(buffID,level)
	if config == nil then
		assert(false, buffID..":buffer not find")
		return
	end

	if config.is_repeat == 0 then
		self:RemoveBuffByType(config.type)
	end

	local buffInfo = {}
	buffInfo.config = config
	buffInfo.lastNum = 0
	buffInfo.bValid = true
	buffInfo.hurt = hurt

	self.buffList:pushBack(buffInfo)

	self:AddBuffIcon(buffID, config.icon_id)

	local under_show = config.under_show ~= 0
	-- if config.effect_loop == 1 then
	-- 	self:AddBodyEffect(config.effect_id, true , under_show,0,0,config.rotation)
	-- else
	-- 	self:AddBodyEffect(config.effect_id, false , under_show,0,0,config.rotation)
	-- end
	if config.effect_loop == 1 then
		if not self:addBuffDisplay( config.effect_id, true) then
			self:AddBodyEffect(config.effect_id, true , under_show,0,0,config.rotation)
		end
	else
		if not self:addBuffDisplay( config.effect_id, false) then
			self:AddBodyEffect(config.effect_id, false , under_show,0,0,config.rotation)
		end
	end

	if config.type > 2 then
		self:ShowBufferName(config.type, config.id)
	end

	--挑衅buff
	if config.type == 18 then
		self.defianceTarget = FightManager:GetCurrAction().attackerRole
	end

	self:TestReleaseManualSkill()
	self:TestDieBuff()
end

function BattleRoleDisplay:AddBuffIcon(buffId, iconId)
	local iconImg = TFImage:create("icon/buffer/"..iconId..".png")
	if iconImg ~= nil and self.bufferIconList[buffId] == nil and self.hpBackground ~= nil then
		self.hpBackground:addChild(iconImg)
		self.bufferIconList[buffId] = iconImg
		self:SetBuffIconPos()
	end
end

function BattleRoleDisplay:SetBuffIconPos()
	local iconNum = 0
	for k,bufferIcon in pairs(self.bufferIconList) do
		if bufferIcon ~= nil then
			iconNum = iconNum + 1
			bufferIcon:setPosition(ccp(24*iconNum-50, 22))
		end
	end
end

function BattleRoleDisplay:ShowBufferName(buffType, buffId)
	local buffImg = "icon/buffer/name_"..buffType..".png"
	if (EnumFight_Buff_Res[buffId]) then
		buffImg = "icon/buffer/name_"..EnumFight_Buff_Res[buffId]..".png"
	end
	local nameImg = TFImage:create(buffImg)
	if nameImg ~= nil then
		self:MoveNameImage(nameImg)
	end
end

function BattleRoleDisplay:ShowEffectName(name)
	local nameImg = TFImage:create("icon/effect/"..name..".png")
	if nameImg ~= nil then
		self:MoveNameImage(nameImg)
	end
end

function BattleRoleDisplay:MoveNameImage(nameImg)
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

function BattleRoleDisplay:HaveBuff(buffId)
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid and buffInfo.config.id == buffId then 
			return true
		end
	end

	return false
end

function BattleRoleDisplay:HaveFrozenBuff()
	return self:GetBuffByType(14) ~= nil
end

--乾坤挪移buff
function BattleRoleDisplay:HaveDzxyBuff()
	return self:GetBuffByType(27) ~= nil
end
--乾坤挪移buff
function BattleRoleDisplay:canTriggerDzxy()
	print("self.stateAttr",self.stateAttr)
	if self.stateAttr and self.stateAttr[27] ~= nil then
		return false
	end
	return true
end

function BattleRoleDisplay:HaveBadBuff()
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid and buffInfo.config.good_buff == 0 then 
			return true
		end
	end

	return false
end

function BattleRoleDisplay:RemoveFrozenBuff()
	self:RemoveBuffByType(14)
end

function BattleRoleDisplay:RemoveBuffIcon(buffId)
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

function BattleRoleDisplay:RemoveBuffByIndex(buffIndex)
	local buffInfo = self.buffList:objectAt(buffIndex)
	if buffInfo.bValid then
		buffInfo.bValid = false
		self:RemoveBuffDisplay(buffInfo.config.effect_id)
		self:RemoveBuffIcon(buffInfo.config.id)
	end

	-- if not self:HaveForbidAttackBuff() then
	-- 	print("RemoveBuffByIndex ---->>>>")
	-- 	-- self.armature:resume()
	-- end
	self:PlayStandAnim()

	self:TestReleaseManualSkill()
end

function BattleRoleDisplay:RemoveBuffByType(bufferType)
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid and buffInfo.config.type == bufferType then 
			self:RemoveBuffByIndex(i)
		end
	end
end
function BattleRoleDisplay:RemoveBuffById(bufferid)
	print("BattleRoleDisplay:RemoveBuffById(bufferid)",bufferid)
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid and buffInfo.config.id == bufferid then
			self:RemoveBuffByIndex(i)
		end
	end
end

function BattleRoleDisplay:RemoveAllBuff()
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid then 
			self:RemoveBuffByIndex(i)
		end
	end
end


function BattleRoleDisplay:isDunBuff( buff_type )
	local dunBuff = {57,58}
	for i=1,#dunBuff do
		if buff_type == dunBuff[i] then
			return true
		end
	end
	return false
end

function BattleRoleDisplay:removeZhanShaBuff()
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid and self:isDunBuff(buffInfo.config.type) then 
			self:RemoveBuffByIndex(i)
		end
	end
end

function BattleRoleDisplay:CleanBuff(attackerRole)
	self:AddBodyEffect("jinghua", false)
	local cleanGood = true
	if battleRoleMgr:IsSameSide({attackerRole, self}) then
		cleanGood = false
	end

	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buffInfo = self.buffList:objectAt(i)
		if buffInfo.bValid and buffInfo.config.is_clean == 0 then
			if cleanGood and buffInfo.config.good_buff == 1 then
				self:RemoveBuffByIndex(i)
			elseif cleanGood == false and buffInfo.config.good_buff == 0 then
				self:RemoveBuffByIndex(i)
			end
		end
	end

	if cleanGood then
		self:ShowEffectName("qusan")
	else
		self:ShowEffectName("jinghua")
	end
end

function BattleRoleDisplay:OnRoundChange()
	
end

function BattleRoleDisplay:OnActionEnd()


end

function BattleRoleDisplay:ShowHpChangeBuff(stateCycleEffect)
	-- self:ShowFightText("", stateCycleEffect.effectValue)
	local buffInfo = SkillBufferData:objectByID(stateCycleEffect.stateId)
	if buffInfo == nil then
		return stateCycleEffect.effectValue
	end
	local buffId = buffInfo.id
	if buffInfo.type == 1 then
		self:ShowBufferName(1, buffId)
		print(self.logicInfo.name.."中毒扣血："..stateCycleEffect.effectValue.."当前血量："..self.currHp)
	elseif buffInfo.type == 2 then
		self:ShowBufferName(2, buffId)
		print(self.logicInfo.name.."灼烧扣血："..stateCycleEffect.effectValue.."当前血量："..self.currHp)
	elseif buffInfo.type == 50 then
		self:ShowBufferName(50, buffId)
		print(self.logicInfo.name.."流血扣血："..stateCycleEffect.effectValue.."当前血量："..self.currHp)
	end
	return stateCycleEffect.effectValue
end


--在自己身上添加特效
function BattleRoleDisplay:AddBossEffect(nEffectID, nZorder, nDelayTime, bLoop)
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

	if self.bossEffect ~= nil then
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
	if bBehindBody then
		local roleZOrder = self.armature:getZOrder()
		bodyEffect:setZOrder(roleZOrder-1)
	else
		bodyEffect:setZOrder(200)
	end
	self.rolePanel:addChild(bodyEffect)
	bodyEffect:playByIndex(0, -1, -1, 1)
	self.bossEffect = bodyEffect
end

--------------add by wk.dai--------------------
--[[
判断当前角色是否还活着
return 如果角色或者返回true
]]
function BattleRoleDisplay:IsAlive()
	return self.currHp > 0
end


function BattleRoleDisplay:IsLive()
	return self.currHp > 0
end
--[[
判断角色是否为有效攻击目标
@return 如果角色为可攻击目标返回true，否则返回false
]]
function BattleRoleDisplay:IsValidTarget()
	if not self:IsAlive() then
		return false
	end

	if self:HaveFrozenBuff() then
		return false
	end

	return true
end


function BattleRoleDisplay:CreateHalo()
	-- self.haloAttr = {}
	self.haloTypeList = {}
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		-- local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil then
			if skillInfo.type == 5 or skillInfo.type == 6 then
				self:AddBodyEffect(50, true, true)
				local skillType = skillInfo.type
				for i=1,17 do
					local haloAttr = self.haloTypeList[skillType] or {}
					haloAttr[i] = haloAttr[i] or 0
					if skillInfo.attr_add[i+17] ~= nil and i <= EnumAttributeType.PoisonResistance then
						haloAttr[i+17] = haloAttr[i+17] or 0
						haloAttr[i+17] =  skillInfo.attr_add[i+17] + haloAttr[i+17]
					end

					if skillInfo.attr_add[i] ~= nil then
						haloAttr[i] = haloAttr[i] + skillInfo.attr_add[i]
					end
				end
				if skillInfo.attr_add[EnumAttributeType.BonusHealing] ~= nil then
					haloAttr[EnumAttributeType.BonusHealing] = haloAttr[EnumAttributeType.BonusHealing] or 0
					haloAttr[EnumAttributeType.BonusHealing] = haloAttr[EnumAttributeType.BonusHealing] + skillInfo.attr_add[EnumAttributeType.BonusHealing]
				end
				self.haloTypeList[skillType] = haloAttr
			end
			if (skillInfo.effect == EnumFightSpellEffect.effect_69) then
				battleRoleMgr.addHpPercentRole[self.logicInfo.bEnemyRole] = battleRoleMgr.addHpPercentRole[self.logicInfo.bEnemyRole] + (skillInfo.effect_value / 100)
			end
		end
	end
end


function BattleRoleDisplay:GetAttrNum(attrIndex)
	local attrNum = self.logicInfo.attr[attrIndex]
	if attrNum == nil then
		return 0
	end

	attrNum = attrNum + battleRoleMgr:GetTotalHaloAttrAdd(self.logicInfo.bEnemyRole, attrIndex)
	attrNum = math.max(0, attrNum)

	local attrPercent = 0
	if attrIndex < EnumAttributeType.PoisonResistance then
		attrPercent = battleRoleMgr:GetTotalHaloAttrAdd(self.logicInfo.bEnemyRole, attrIndex+17)
	end
	local percent = attrPercent/100
	local bufferNum = self.buffList:length()
	for i=1,bufferNum do
		local buff = self.buffList:objectAt(i)
		if buff.bValid and buff.config.attr_change ~= "0" and buff.config.attr_change ~= "" then
			local valueInfo = GetAttrByString(buff.config.attr_change)

			if valueInfo[17+attrIndex] ~= nil then
				percent = valueInfo[17+attrIndex] + percent
			end

			if valueInfo[attrIndex] ~= nil then
				attrNum = attrNum + valueInfo[attrIndex]
			end
		end
	end

	attrNum = attrNum + math.floor(attrNum * percent / 100)

	if self.passiveSkillAttrAdd ~= nil then
		local valueInfo = self.passiveSkillAttrAdd--GetAttrByString(self.passiveSkillAttrAdd)
		if valueInfo[17+attrIndex] ~= nil then
			attrNum = attrNum + math.floor(attrNum * valueInfo[17+attrIndex] / 100)
		end

		if valueInfo[attrIndex] ~= nil then
			attrNum = attrNum + valueInfo[attrIndex]
		end
	end

	attrNum = math.max(0, attrNum)
	return attrNum
end

function BattleRoleDisplay:PlayYuanHuAnim(rolePos)
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
	
	-- local m_nCurFrame = 0
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


function BattleRoleDisplay:addBuffDisplay( buffID ,isloop)
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

function BattleRoleDisplay:RemoveBuffDisplay( buffID )
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

function BattleRoleDisplay:TestDieBuff()
	if self:GetBuffByType(25) ~= nil and self:GetBuffByType(26) ~= nil then
	  	self:SetHp(0)
	end
end

function BattleRoleDisplay:getPassiveSkillInfoByEffect( effect )
	local passiveSkillNum = #self.passiveSkill
	for i=1,passiveSkillNum do
		local skillInfo = SkillLevelData:objectByID(self.passiveSkill[i])
		local skillBaseInfo = BaseDataManager:GetSkillBaseInfo(self.passiveSkill[i])
		if skillInfo ~= nil and skillBaseInfo ~= nil and skillBaseInfo.effect == effect then
			return skillInfo
		end
	end
	return nil
end

--技能触发
function BattleRoleDisplay:GetTriggerBySkillHurtType(skillID, triggerHurtType, isUse)
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

--香香公主 援护特效
function BattleRoleDisplay:addYuanHuEffect()
	self:AddBodyEffect("yuanFu_1", false, false, 0, 0, self.logicInfo.bEnemyRole)
	self:AddBodyEffect("yuanFu_2", false, true, 0, 0, self.logicInfo.bEnemyRole)
end
return BattleRoleDisplay