local FightResultScene = class("FightResultScene", BaseScene);

function FightResultScene:ctor(data)
	self.super.ctor(self,data);

	self.mapLayer = require("lua.logic.fight.MapLayer"):new()
	self:addLayer(self.mapLayer)
end

function FightResultScene:onEnter()
	TFAudio.stopMusic()
	-- TFDirector:setFPS(GameConfig.FPS)
	FightManager:backInitSpeed()

	local fightType = FightManager.fightBeginInfo.fighttype
	if fightType == 10 or fightType == 17  then
		local uiLayer = require("lua.logic.fight.BossFightResultLayer"):new()
		self:addLayer(uiLayer)
		return 
	end
	if FightManager:NeedShowText(false) and not self:isYouliFirst() then
		local endTextShowEndCallBack = function(event)
			local uiLayer = require("lua.logic.fight.FightResultLayer"):new()
			self:addLayer(uiLayer)
			self.desLayer = uiLayer
			-- if MissionManager:isInTrustOnekey() then
			-- 	local oneKeyLayer = require(MissionManager.trustOnkeyLayerName):new()
			-- 	oneKeyLayer:setType(uiLayer, true)
			-- 	self:addLayer(oneKeyLayer)
			-- end
			
			PlayerGuideManager:doGuide()
			TFDirector:removeMEGlobalListener("MissionTipLayer.EVENT_SHOW_ENDTIP_COM")
		end
		TFDirector:addMEGlobalListener("MissionTipLayer.EVENT_SHOW_ENDTIP_COM",  endTextShowEndCallBack)

		if FightManager.fightBeginInfo.fighttype == 1 or FightManager.fightBeginInfo.fighttype == EnumFightType.Adventure_Copy or FightManager.fightBeginInfo.fighttype == EnumFightType.Adventure_Event then
			MissionManager:showEndTip()
		elseif FightManager.fightBeginInfo.fighttype == 17 then
			FactionManager:showTip(12)
		elseif FightManager.fightBeginInfo.fighttype == 30 then
			--东瀛岛战斗结束		
			JapanIslandManager:showTip(false, FightManager.fightResultInfo.result > 0, FightManager.fightBeginInfo.fighttype)
		elseif FightManager.fightBeginInfo.fighttype == 31 or FightManager.fightBeginInfo.fighttype == 32 then
			--浪人武士			
			KnightManager:showTip(FightManager.fightResultInfo.result > 0, FightManager.fightBeginInfo.fighttype)
		end
	else
		local uiLayer = require("lua.logic.fight.FightResultLayer"):new()
		self:addLayer(uiLayer)
		self.desLayer = uiLayer
		-- if MissionManager:isInTrustOnekey() then
		-- 	local oneKeyLayer = require(MissionManager.trustOnkeyLayerName):new()
		-- 	oneKeyLayer:setType(uiLayer, true)
		-- 	self:addLayer(oneKeyLayer)
		-- end
	end

	if fightType == 5 then
		MissionManager:checkTrustOnekeyLayer(self.desLayer, true)
	end
end

function FightResultScene:isYouliFirst()
	if FightManager:isHasSecondFight() then
		if FightManager.fightResultInfo and FightManager.fightResultInfo.rank  and FightManager.fightResultInfo.rank == 1 then
			return true
		end
	end
	return false
end

function FightResultScene:StarShake(swingX, swingY,shakeTime)
	local postion = self:getPosition()

	if self.shakeTween ~= nil then
		TFDirector:killTween(self.shakeTween)
		self.shakeTween = nil
	end

	self:setScale(1.05)

	shakeTime = shakeTime or 0.05
	self.shakeTween = 
	{
		target = self,
		{
			duration = shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = shakeTime,
			x = postion.x,
			y = postion.y,
		},
		onComplete = function ()
			TFDirector:killTween(self.shakeTween)
		end,
	}
	TFDirector:toTween(self.shakeTween)
end

function FightResultScene:StarShakeTwise(swingX, swingY,shakeTime)
	local postion = self:getPosition()

	if self.shakeTween ~= nil then
		TFDirector:killTween(self.shakeTween)
		self.shakeTween = nil
	end

	self:setScale(1.05)

	shakeTime = shakeTime or 0.05
	self.shakeTween = 
	{
		target = self,
		{
			duration = shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = shakeTime,
			x = postion.x,
			y = postion.y,
		},
		onComplete = function ()
			TFDirector:killTween(self.shakeTween)
		end,
	}
	TFDirector:toTween(self.shakeTween)
end

function FightResultScene:LastStarShakeTwise(swingX, swingY,shakeTime)
	local postion = self:getPosition()

	if self.shakeTween ~= nil then
		TFDirector:killTween(self.shakeTween)
		self.shakeTween = nil
	end

	self:setScale(1.05)

	shakeTime = shakeTime or 0.05
	self.shakeTween = 
	{
		target = self,
		{
			duration = shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = shakeTime,
			x = postion.x,
			y = postion.y,
		},
		onComplete = function ()
			self:setScale(1)
			TFDirector:killTween(self.shakeTween)
		end,
	}
	TFDirector:toTween(self.shakeTween)
end

function FightResultScene:LastStarShakeThrice(swingX, swingY,shakeTime)
	local postion = self:getPosition()

	if self.shakeTween ~= nil then
		TFDirector:killTween(self.shakeTween)
		self.shakeTween = nil
	end

	self:setScale(1.05)

	shakeTime = shakeTime or 0.05
	self.shakeTween = 
	{
		target = self,
		{
			duration = shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = shakeTime,
			x = postion.x,
			y = postion.y,
		},
		onComplete = function ()
			self:setScale(1)
			TFDirector:killTween(self.shakeTween)
		end,
	}
	TFDirector:toTween(self.shakeTween)
end

function FightResultScene:LastStarShake(swingX, swingY, shakeTime)
	local postion = self:getPosition()

	if self.shakeTween ~= nil then
		TFDirector:killTween(self.shakeTween)
		self.shakeTween = nil
	end

	shakeTime = shakeTime or 0.05
	self:setScale(1.05)

	self.shakeTween = 
	{
		target = self,
		{
			duration = shakeTime,
			x = postion.x+swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x-swingX,
			y = postion.y-swingY,
		},
		{
			duration = shakeTime,
			x = postion.x,
			y = postion.y,
		},
		{
			duration = shakeTime,
			x = postion.x-swingX,
			y = postion.y+swingY,
		},
		{
			duration = 2*shakeTime,
			x = postion.x+swingX,
			y = postion.y-swingY,
		},
		{
			duration = shakeTime,
			x = 0,
			y = 0,
		},
		onComplete = function ()
			self:setScale(1)
			TFDirector:killTween(self.shakeTween)
		end,
	}
	TFDirector:toTween(self.shakeTween)
end

return FightResultScene

