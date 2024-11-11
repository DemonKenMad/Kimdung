-- client side MoiveLayer.lua
--[[
 * @Description: 电影播放
 ]]
-- script writer Stephen.tao
-- creation time 2016-08-22

local MoiveLayer = class("MoiveLayer", function(...)
	local layer = TFPanel:create()
	return layer
end)

function MoiveLayer:ctor(data)
	self.script = data --MoiveScriptData:objectByID(data)

	local mapID = self.script.mapId
	local mapName = "fightmap/mission"..mapID..".jpg"

	local fightBGImg = TFImage:create(mapName)
	if fightBGImg == nil then
		fightBGImg = TFImage:create("fightmap/mission1.jpg")
	end

	local nViewHeight = GameConfig.WS.height
    local nViewWidth = GameConfig.WS.width
    fightBGImg:setPosition(CCPoint(nViewWidth/2, nViewHeight/2))
    self:addChild(fightBGImg)

    self:AddMapEffect(false, fightBGImg, mapID)
    self:AddMapEffect(true, fightBGImg, mapID)

    self:initTarget()
    self:doActions()
    self:playBgMusic()
end

function MoiveLayer:playBgMusic()
	if self.script.bgm and self.script.bgm ~= "" then
		TFAudio.playMusic("sound/bgmusic/"..self.script.bgm, true)
	end 
end

function MoiveLayer:stopBgm()
	TFAudio.stopMusic()
end

function MoiveLayer:AddMapEffect(bFrontEffect, fightBGImg, mapID, effectPos)
	local effectName = "mission"..mapID
	if bFrontEffect then
		effectName = "mission"..mapID.."_f"
	end

	local effectPath = "fightmap/effect/"..effectName..".xml"
	if not TFFileUtil:existFile(effectPath) then
		return
	end

	TFResourceHelper:instance():addArmatureFromJsonFile(effectPath)
	local effect = TFArmature:create(effectName.."_anim")
	if effect == nil then
		return
	end

	effect:setAnimationFps(GameConfig.ANIM_FPS)
	effect:playByIndex(0, -1, -1, 1)

	local uiSize = fightBGImg:getSize()
	effect:setPosition(ccp(uiSize.width/2, uiSize.height/2))

	if bFrontEffect then
		effect:setZOrder(1000)
		self:addChild(effect)
	else
		fightBGImg:addChild(effect)
	end
end

function MoiveLayer:initTarget()
	if self.script.target == nil then
		return
	end
	self.targetList = {}
	for i=1,#self.script.target do
		local target = self.script.target[i]
		local roleId = target.roleId
		if target.roleId == 0 then
			roleId = MainPlayer:getProfession()
		end
		local roleTableData = nil
		if target.isNpc then
			roleTableData = NPCData:objectByID(roleId)
		else
			roleTableData = RoleData:objectByID(roleId)
		end
		local rolePanel = self:createRoleArmature(roleId,roleTableData.image)
		self.targetList[i] = rolePanel
		self.targetList[i]:setPosition(self:getposition(target.pos, target.pos_type))
		self:CreateShadowImg(rolePanel)
		self:addChild(self.targetList[i])
		if target.forward == 2 then
			self.targetList[i].armature:setRotationY(180)
		end
	end
	self:initActionsInfo()
end

function MoiveLayer:getposition( pos , pos_type )
	if pos_type == 1 then
		return CCPoint(pos.x , pos.y) 
	else
		local nViewWidth = GameConfig.WS.width
		return CCPoint(nViewWidth - pos.x , pos.y) 
	end
end

function MoiveLayer:CreateShadowImg(rolePanel)
	local shadowImg = TFImage:create("ui_new/fight/shadow.png")
	shadowImg:setZOrder(-1001)
	shadowImg:setAnchorPoint(ccp(0.5, 0.5))
	rolePanel.shadowImg = shadowImg
	rolePanel:addChild(shadowImg)
end

function MoiveLayer:createRoleArmature( roleId,armatureID )
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

	armature:setAnimationFps(GameConfig.ANIM_FPS)
	armature:setPosition(ccp(0,0))
	armature:play("stand", -1, -1, 1)

	local rolePanel = TFPanel:create()
	rolePanel:setSize(armature:getContentSize())
	rolePanel:addChild(armature)
	rolePanel.armature = armature
	return rolePanel
end

function MoiveLayer:initActionsInfo()
	self.m_moive_step = 1
	self.m_action_step = 1
	self.timerList = self.timerList or TFArray:new()
	self.timerList:clear()
end

function MoiveLayer:doActions()
	if self.script.actions == nil then
		self:doMoiveEnd()
		return
	end
	if self.m_moive_step > #self.script.actions then
		self:doMoiveEnd()
		return
	end
	local moive_scripts = self.script.actions[self.m_moive_step]
	if moive_scripts == nil then
		self:doMoiveEnd()
		return
	end
	if self.m_action_step > #moive_scripts then
		self:doActionsFull()
		return
	end
	for i=self.m_action_step,#moive_scripts do
		local script = moive_scripts[i]
		if self:doActionByScript(script) == 4 then
			return
		end
	end
end

--当前动作执行满
function MoiveLayer:doActionsFull()
	print("MoiveLayer:doActionsFull")
	self.m_moive_step = self.m_moive_step + 1
	self.m_action_step = 1
	self:doActions()
end

function MoiveLayer:doActionByScript( script )
	if script.delay and script.delay ~= 0 then
		local timer = -1;
		timer = TFDirector:addTimer(script.delay * 1000, 1, nil, 
		function()
			if self and self._doActionByScript then
				self:_doActionByScript(script)
			end
			if self.timerList then
				self.timerList:removeObject(timer)
			end
			TFDirector:removeTimer(timer)
			timer = nil
		end)
		self.timerList:push(timer)
	else
		self:_doActionByScript(script)
	end
	return script.action_type
end
function MoiveLayer:_doActionByScript( script )
	if script.action_type == 1 then
		self:doMoveAction(script)
	elseif script.action_type == 2 then
		self:doHurtAction(script)
	elseif script.action_type == 3 then
		self:doActionByName(script)
	elseif script.action_type == 4 then
		self:doDialAction(script)
	elseif script.action_type == 5 then
		self:doSkillEffectAction(script)
	elseif script.action_type == 6 then
		self:removeSkillEffectAction(script)
	end
	return script.action_type
end

function MoiveLayer:doMoveAction(script)
	local targetId = script.targetId
	local position_now = self.targetList[targetId]:getPosition()
	local position_new = self:getposition(script.pos , script.pos_type)
	local x = position_new.x - position_now.x
	if x >= 0 then
		self.targetList[targetId].armature:setRotationY(0)
	else
		self.targetList[targetId].armature:setRotationY(180)
	end
	if script.action_time > 0 then
		self.targetList[targetId].armature:play("move")
		local moveTween = {
			target = self.targetList[targetId],
			{
				duration = script.action_time,
				x = position_new.x,
				y = position_new.y,
				onComplete = function ()
					self.targetList[targetId].armature:play("stand", -1, -1, 1)
					self:onActionEnd()
				end,
			}
		}
		TFDirector:toTween(moveTween)
	else
		self.targetList[targetId]:setPosition(position_new)
		self.targetList[targetId].armature:play("stand", -1, -1, 1)
		self:onActionEnd()
	end
end

function MoiveLayer:onActionEnd()
	self.m_action_step = self.m_action_step + 1
	local moive_scripts = self.script.actions[self.m_moive_step]
	print("m_action_step == >>",self.m_action_step ,#moive_scripts)
	if self.m_action_step > #moive_scripts then
		self:doActionsFull()
	end
end

function MoiveLayer:doHurtAction(script)
	local targetId = script.targetId
	local headPosX = self.targetList[targetId]:getPosition().x
	local headPosY = self.targetList[targetId]:getPosition().y + 200
	local hurtLabel = self:CreateDamageNumFont(script.hurt)
	hurtLabel:setPosition(ccp(headPosX, headPosY))

	if script.hurt > 0 then
		hurtLabel:setText("-"..script.hurt)
	else
		hurtLabel:setText(math.abs(script.hurt))
	end

	self:addChild(hurtLabel)

	local pos = hurtLabel:getPosition()
	hurtLabel:setScale(0)
	hurtLabel:setAlpha(0.5)
	local textTween = 
	{
		target = hurtLabel,
		{
			ease = {type=TFEaseType.EASE_IN, rate=2},
			duration = 0.2,
			alpha = 1,
			scale = 1,
			x = headPosX,
			y = headPosY + 40,
		},
		{
			delay = 0.2,
			duration = 0.4,
			x = headPosX,
			y = headPosY + 110,
			alpha = 0,

			onComplete = function ()
				self:removeChild(hurtLabel)
				self:onActionEnd()
			end
		},
	}
	TFDirector:toTween(textTween)
end

function MoiveLayer:removeSkillEffectAction(script)
	if script.tag == nil or  script.tag == 0 then
		return
	end 
	local effectType = script.effectType or 0
	local skillEff = nil;
	if effectType == 0 or effectType == 5 then
		local rolePanel = self.targetList[script.target_srcId]
		skillEff = rolePanel:getChildByTag(script.tag)
	else
		skillEff = self:getChildByTag(script.tag)
	end
	if skillEff then
		skillEff:removeFromParent()
	end
end

function MoiveLayer:doSkillEffectAction(script)-- nEffectID, effectType, nPosOffsetX, nPosOffsetY, effectScale,targetRole, flyEffRotate)
	
	local nEffectID = script.effectId

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
		self:onActionEnd()
		return
	end

	if skillEff == nil then
		self:onActionEnd()
		return
	end
	if script.tag and script.tag ~= 0 then
		skillEff:setTag(script.tag)
	end
	-- if self.logicInfo.bEnemyRole then
	-- 	GameResourceManager:addEnemyEffect( self.logicInfo.roleId , nEffectID , skillEff )
	-- else
	-- 	GameResourceManager:addRoleEffect( self.logicInfo.roleId , nEffectID , skillEff )
	-- end

	local effectType = script.effectType or 0
	local effPosX = script.pos.x
	local effPosY = script.pos.y

	skillEff:setPosition(ccp(effPosX, effPosY))

	skillEff:setAnimationFps(GameConfig.ANIM_FPS)
	
	if script.pos_type and script.pos_type == 2 then
		skillEff:setRotationY(180)
	end
	local rolePanel = self.targetList[script.target_srcId]
	if effectType == 0 then
		rolePanel:addChild(skillEff)
	elseif effectType == 5 then
		skillEff:setZOrder(-1000)
		rolePanel:addChild(skillEff)
	elseif effectType == 6 or effectType == 7 then
		skillEff:setZOrder(-1000)
		self:addChild(skillEff)
	elseif effectType == 8  or effectType == 9 or effectType == 10 then
		skillEff:setZOrder(10001)
		self:addChild(skillEff)
	else
		local roleZOrder = rolePanel:getZOrder()
		skillEff:setZOrder(10001 + roleZOrder)
		self:addChild(skillEff)
	end
	if effectType == 0 or effectType == 1 or effectType == 2 or effectType == 5 or effectType == 6 or effectType == 7 or effectType == 8 or effectType == 9 or effectType == 10 then
		if script.loop then
			skillEff:playByIndex(0, -1, -1, 1)
			self:onActionEnd()
		else
			skillEff:playByIndex(0, -1, -1, 0)
			skillEff:addMEListener(TFARMATURE_COMPLETE,
			function()
				skillEff:removeMEListener(TFARMATURE_COMPLETE)
				if effectType == 0 then
					rolePanel:removeChild(skillEff)
				else
					self:removeChild(skillEff)
				end
				self:onActionEnd()
			end)
		end
	else -- 飞行特效 循环播放
		skillEff:playByIndex(0, -1, -1, 1)
		local targetRole = self.targetList[script.target_desId]
		local flyEffRotate = script.flyEffRotate or false
		self:MoveSkillEffect(skillEff, effectType, targetRole)
	end
	if script.sound and script.sound ~= "" then
		local soundList = string.split(script.sound,'|')
        local sound = soundList[1]
        if #soundList > 1 then
            sound = soundList[MainPlayer.sex]
        end
		TFAudio.playEffect("sound/"..sound,false)
	end
end

function MoiveLayer:MoveSkillEffect(skillEffect, effectType, targetRole)
	if targetRole == nil then
		assert(false)
		return
	end

	local originPos = targetRole:getPosition()

	local movePath = 
	{
		target = skillEffect,
		{
			duration = 0.3,
			
			x = originPos.x,
			y = originPos.y,

			onComplete = function ()
				self:removeChild(skillEffect)
				self:onActionEnd()
			end,
		},
	}

	TFDirector:toTween(movePath)
end


function MoiveLayer:CreateDamageNumFont(hurtNum)
	local angerNumFont = TFLabelBMFont:create()
	angerNumFont:setAnchorPoint(ccp(0.5, 0.5))
	-- angerNumFont:setZOrder()

	if hurtNum < 0 then
		angerNumFont:setFntFile("font/damage.fnt")	
	else
		angerNumFont:setFntFile("font/addHp.fnt")	
	end

	return angerNumFont
end


function MoiveLayer:doActionByName(script)
	local targetId = script.targetId
	self.targetList[targetId].armature:play(script.action_name,-1, -1, 0)
	self.targetList[targetId].armature:addMEListener(TFARMATURE_COMPLETE,
	function()
		self.targetList[targetId].armature:removeMEListener(TFARMATURE_COMPLETE)
		if script.action_name ~= script.end_action then
			self.targetList[targetId].armature:play(script.end_action,-1, -1, 1)
		end
		self:onActionEnd()
	end)
	if script.sound and script.sound ~= "" then
		local soundList = string.split(script.sound,'|')
        local sound = soundList[1]
        if #soundList > 1 then
            sound = soundList[MainPlayer.sex]
        end
		TFAudio.playEffect("sound/"..sound,false)
	end
end

function MoiveLayer:doDialAction(script)
	if self.dial_layer == nil then
		self.dial_layer = require("lua.logic.fight.MoiveTipLayer"):new();
		self.dial_layer:setZOrder(1001)
		self.dial_layer.logic = self
	    self:addChild(self.dial_layer);
	end
	self.dial_layer:setVisible(true)
	self.dial_layer:showTip(script)
end

function MoiveLayer:dialTouchEnd()
	self.m_action_step = self.m_action_step + 1
	self.dial_layer:setVisible(false)
	self:doActions()
end

function MoiveLayer:doMoiveEnd()
	self.logic:moiveEnd()
end
function MoiveLayer:stopAllTimer()
	if self.timerList and self.timerList:length() then
		for timer in self.timerList:iterator() do
			TFDirector:removeTimer(timer)
		end
		self.timerList:clear()
	end
	self:stopBgm()
end
return MoiveLayer