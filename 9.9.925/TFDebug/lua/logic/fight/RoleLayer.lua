--
-- Author: Zippo
-- Date: 2013-12-03 12:14:39
--

local mapLayer  = require("lua.logic.fight.MapLayer")
local fightRoleMgr  = require("lua.logic.fight.FightRoleManager")

local RoleLayer = class("RoleLayer", function(...)
	local layer = TFPanel:create()
	return layer
end)

function RoleLayer:ctor(data)
	fightRoleMgr:CreateAllRole(FightManager.fightBeginInfo.rolelist, self)
	self.initPosX = self:getPositionX()
end


function RoleLayer:showRoleGotoScene()
	if (GameConfig.HD_VN and FightManager.tempMsg) then
		toastMessage(FightManager.tempMsg, nil, nil, nil, true, 5)
		FightManager.tempMsg = nil
	end
	local nViewWidth = GameConfig.WS.width
	local temp_time = 0
	local temp_num = 0
	local role_num = 0

	for k,role in pairs(fightRoleMgr.map) do
		role_num = role_num + 1
	end
	--print("role_num = ",role_num)
	for k,role in pairs(fightRoleMgr.map) do
		local row = k%3 + 1
		local originPos = mapLayer.GetPosByIndex(k,role.logicInfo.roleId)
		if k < 9 then
			role.rolePanel:setPositionX(-100)
		elseif k < 18 then
			role.rolePanel:setPositionX(nViewWidth + 100)
		else
			temp_num = temp_num + 1
			if temp_num == role_num then
				local currentScene = Public:currentScene()
				if currentScene and currentScene.__cname == "FightScene" then
					if FightManager.fightBeginInfo and FightManager.fightBeginInfo.index and FightManager.fightBeginInfo.total then
						currentScene:PlayBeginMoreEffect(FightManager.fightBeginInfo.index,FightManager.fightBeginInfo.total)
					else
						currentScene:PlayBeginEffect()
					end
				end
				return
			end			
		end
		role.armature:play("move")
		local moveTween = {
			target = role.rolePanel,
			{
				delay = (0.3*(row-1)) / FightManager.fightSpeed,
				duration = 0.5 / FightManager.fightSpeed,
				x = originPos.x,
				y = originPos.y,
				onComplete = function ()
					role:PlayStandAnim()
					temp_num = temp_num + 1
					if temp_num == role_num then
						local currentScene = Public:currentScene()
						if currentScene and currentScene.__cname == "FightScene" then
							if FightManager.fightBeginInfo and FightManager.fightBeginInfo.index and FightManager.fightBeginInfo.total then
								currentScene:PlayBeginMoreEffect(FightManager.fightBeginInfo.index,FightManager.fightBeginInfo.total)
							else
								currentScene:PlayBeginEffect()
							end
						end
					end
				end
			}
		}
		TFDirector:toTween(moveTween)
		-- temp_time = math.max((0.3*(row-1)) / FightManager.fightSpeed , temp_time)
	end
	-- temp_time = temp_time + 0.5 / FightManager.fightSpeed
	-- local beginTimer = TFDirector:addTimer(temp_time*1000,1,nil,function ()
	-- 	local currentScene = Public:currentScene()
	-- 	if currentScene and currentScene.__cname == "FightScene" then
	-- 		if FightManager.fightBeginInfo and FightManager.fightBeginInfo.index and FightManager.fightBeginInfo.total then
	-- 			currentScene:PlayBeginMoreEffect(FightManager.fightBeginInfo.index,FightManager.fightBeginInfo.total)
	-- 		else
	-- 			currentScene:PlayBeginEffect()
	-- 		end
	-- 	end
	-- end)
end

function RoleLayer:showOneRoleGotoScene(role)
	local posindex  = role.logicInfo.posindex
	local row       = posindex%3 + 1
	local originPos = mapLayer.GetPosByIndex(posindex)
	if posindex < 9 then
		role.rolePanel:setPositionX(-100)
	elseif posindex < 18 then
		local nViewWidth = GameConfig.WS.width
		role.rolePanel:setPositionX(nViewWidth + 100)
	else
		return
	end
	role.armature:play("move")
	local moveTween = {
		target = role.rolePanel,
		{
			ease = {type=TFEaseType.EASE_IN_OUT, rate=3},
			duration = 0.5 ,
			x = originPos.x,
			y = originPos.y,

			onUpdate = function ()
				role:UpdateZOrder()
			end,
		
			onComplete = function ()
				role:UpdateZOrder()
				role:PlayStandAnim()
				FightManager:OnAddRoleEnd()
			end,
		}
	}
	TFDirector:toTween(moveTween)
end

function RoleLayer:showRoleGoOutScene(role)
	local nViewWidth = GameConfig.WS.width
	local temp_time = 0
	local pos_x = role.rolePanel:getPositionX()
	local moveTween = {
			target = role.rolePanel,
			{
				duration = 0.5 / FightManager.fightSpeed,
				x = pos_x + nViewWidth - 110 ,
			}
		}
		TFDirector:toTween(moveTween)
end



return RoleLayer