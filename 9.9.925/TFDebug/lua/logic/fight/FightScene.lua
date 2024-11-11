--
-- Author: Zippo
-- Date: 2013-12-03 12:11:16
--
local fightAI = require("lua.logic.fight.FightAI")

local FightScene = class("FightScene", BaseScene)

function FightScene:ctor(...)
	self.super.ctor(self, ...)
end

function FightScene:onEnter()
	-- me.ArmatureDataManager:removeArmatureFileInfo()
	me.ArmatureDataManager:removeUnusedArmatureInfo()
	CCDirector:sharedDirector():purgeCachedData()
	FightManager:Debug_Layer(true)
	if FightManager.fightBeginInfo and FightManager.fightBeginInfo.bGuideFight == true then
		self:createFightLayer()
		FightManager:SwitchDoubleSpeed()
		return
	end

	if FightManager.fightBeginInfo == nil then
		return
	end
	FightManager.bFighting = true
	if (GameConfig.HD) then
		if FightManager.fightBeginInfo.index and FightManager.fightBeginInfo.index > 1 then
			self:createFightLayer()
			-- PlayerGuideManager:doGuide()
			return
		end
	end
	if self.loadingLayer == nil then
		self.loadingLayer = require("lua.logic.main.FightLoadingLayer"):new()
		self.loadingLayer:setZOrder(200)
		self.loadingLayer.toScene = TFDirector:currentScene()
		self:addLayer(self.loadingLayer)
		-- AlertManager:show()
	end
	if FightManager.fightBeginInfo == nil then
		return
	end
	if (GameConfig.HD) then
		local bDelayLoad = false
		local function checkStringNum(str)
			if type(str) == 'string' and (str[#str] == 'K' or str[#str] == 'k') then 
				str = str[{1, #str-1}]
			end
			return str
		end
		local allMem = checkStringNum(TFDeviceInfo.getTotalMem()) / 1024
		local freeMem = checkStringNum(TFDeviceInfo.getFreeMem()) / 1024
		if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS) then
			if (allMem <= 1024) then
				bDelayLoad = true
			end
		elseif (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) then
			if (allMem <= 2048) then
				bDelayLoad = true
			end
		end
		if (GameConfig.HD_VN) then
			bDelayLoad = false
		end
		if ( bDelayLoad) then
			self:loadingAniMalEffectIos()
			return
		end
	end

	local length = 0
	for idx in pairs(FightManager.fightBeginInfo.rolelist) do 
		length = math.max(idx, length)
	end
	local index = 1
	self.loadingLayer:setData(math.ceil(1500/length+1),length+1,function ()
			self:removeLayer(self.loadingLayer,true)
			self.loadingLayer = nil
			self:createFightLayer()
			PlayerGuideManager:doGuide()
	end,function ()
		if index > length then
			return
		end
		self:creatRoleAnimal(FightManager.fightBeginInfo.rolelist[index])
		index = index + 1
	end)
end

function FightScene:loadingAniMalEffectIos(lllll)
	local loadingSkillList = {}
	local loadingRoleList  = {}
	local nRoleLen         = 0
	local loadingPercent   = 0
	local loadingCount     = 0
	-- if (lllll) then
	-- 	for i,v in pairs(lllll) do 
	-- 		nRoleLen = nRoleLen + 1
	-- 		table.insert( loadingRoleList, v)
	-- 	end
	-- else
		for i,v in pairs(FightManager.fightBeginInfo.rolelist) do 
			nRoleLen = nRoleLen + 1
			table.insert( loadingRoleList, v)
		end
	-- end
	local function loadingRole()
		local loadInfo = loadingRoleList[1]
		if (loadInfo) then
			local name = self:creatRoleAnimal(loadInfo, loadingSkillList)
			loadingCount = loadingCount + 1
			loadingPercent = (loadingCount) / nRoleLen * 40
			-- self.loadingLayer:setTips(name or "")
			self.loadingLayer.loadPercent = loadingPercent
			table.remove( loadingRoleList, 1)
		else

		end
	end

	local function loadOver()
		self:removeLayer(self.loadingLayer,true)
		self.loadingLayer = nil
		self:createFightLayer()
		PlayerGuideManager:doGuide()
	end
	local function loadingSkillEffect( )
		local loadInfo = loadingSkillList[1]
		if (loadInfo) then
			self:creatSKillEffectByID(loadInfo.nEffectID, loadInfo.roleId, loadInfo.bEnemy, true)
			loadingCount = loadingCount + 1
			loadingPercent = 40 + (loadingCount) / nSkillList * 60
			-- self.loadingLayer:setTips(loadInfo.name, true)
			local nMem = math.ceil(FightManager:GetTextureCacheMem() / 1024)
			-- self.loadingLayer:setTips(loadInfo.name.." "..nMem)
			self.loadingLayer.loadPercent = loadingPercent
			table.remove( loadingSkillList, 1)
			if (nMem >= FightManager.MaxMen) then
				FightManager.bMenWarning = true
				loadingSkillList = {}
				self.loadingLayer:overLoading_Ios()
				loadOver()
			end
			
		else
			
		end
	end
	
	local function loadRoleOver()
		loadingCount = 0
		nSkillList = #loadingSkillList
		-- return TFDirector:addTimer(math.ceil(800/nSkillList+1), nSkillList+1, nil, loadingSkillEffect)
		self.loadingLayer:setData_Ios(50, nSkillList + 1,loadOver, loadingSkillEffect)
	end
	self.loadingLayer:setData_Ios(150, nRoleLen, loadRoleOver, loadingRole)
end

function FightScene:creatRoleAnimal(roleInfo, loadingSkillList)

	if roleInfo == nil then
		return
	end
	local bEnemyRole = false
	if roleInfo.posindex >= 9 then
		bEnemyRole = true
	end
	local bNpc = false
	if roleInfo.typeid == 2 then
		bNpc = true
	end
	local roleTableData = nil
	
	if bNpc then
		roleTableData = NPCData:objectByID(roleInfo.roleId)
		--39 风云录1
		if FightManager.fightBeginInfo.fighttype == EnumFightType.FYRecord then
			roleTableData = FYRecordData:objectByID(roleInfo.roleId)
		end
	else
		roleTableData = RoleData:objectByID(roleInfo.roleId)
	end
	if roleTableData == nil then
		print("role configure not found : ",roleInfo.typeid,roleInfo.roleId)
	end
	local armatureID = roleTableData.image
	if roleTableData.directional_sensitivity and roleTableData.directional_sensitivity == 1 then
		if not bEnemyRole then
			armatureID = roleTableData.image.."r"
		else
			armatureID = roleTableData.image.."l"
		end
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
	if self.loadingLayer then
		self.loadingLayer:addChild(armature)
	end
	if loadingSkillList ~= nil then
	-- if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
		self:queryRoleSkillEffect(roleTableData,{skillId = 0,level = 0},bEnemyRole, loadingSkillList)
		if roleInfo.spellId then
			self:queryRoleSkillEffect(roleTableData,roleInfo.spellId,bEnemyRole, loadingSkillList)
		end
		if roleInfo.passiveskill then
			local bLoadRed = false
			for k,v in ipairs(roleInfo.passiveskill) do
				if (not bLoadRed) then
					bLoadRed = self:queryRoleSkillEffect(roleTableData, v, bEnemyRole, loadingSkillList, true)
				end
			end
		end
		return roleTableData.name
	end

	self:creatRoleSkillEffect(roleTableData,{skillId = 0,level = 0},bEnemyRole)
	if roleInfo.spellId then
		self:creatRoleSkillEffect(roleTableData,roleInfo.spellId,bEnemyRole)
	end
	if roleInfo.passiveskill then
		for k,v in pairs(roleInfo.passiveskill) do
			self:creatRoleSkillEffect(roleTableData,v,bEnemyRole)
		end
	end
end

function FightScene:queryRoleSkillEffect(roleTableData,skillid,bEnemyRole, loadingSkillList, bRedSkill)
	local skillDisplayID = 0
	local bNormalAttack = false
	if skillid.skillId == 0 then -- 普通攻击
		skillDisplayID = roleTableData.normal_attack
		bNormalAttack = true
	end

	local skillInfo = BaseDataManager:GetSkillBaseInfo(skillid)
	if skillInfo ~= nil then
		skillDisplayID = skillInfo.display_id
		if (bRedSkill and skillInfo.hidden_skill ~= 3) then
			return true
		end
	end

	local skillDisplayInfo = SkillDisplayData:objectByID(skillDisplayID)
	if skillDisplayInfo == nil then
		local armatureID = roleTableData.image
		if bNormalAttack then
			skillDisplayInfo = SkillDisplayData:objectByID(armatureID-10000)
		else
			skillDisplayInfo = SkillDisplayData:objectByID((armatureID-10000)*100+1)
		end

		if skillDisplayInfo == nil then
			skillDisplayInfo = SkillDisplayData:objectByID(9999)
		end
	end

	local xuliEffID = skillDisplayInfo.xuliEff
	if xuliEffID ~= nil and xuliEffID ~= 0 then
		local info = {
				nEffectID = xuliEffID,
				roleId = roleTableData.id,
				name = roleTableData.name,
				bEnemy = bEnemyRole
			} 
		table.insert( loadingSkillList, info)
	end
	local attackEff_list = skillDisplayInfo.attackEff
	if attackEff_list ~= nil and #attackEff_list ~= 0 then
		for k,v in pairs(attackEff_list) do
			-- self:creatSKillEffectByID( v ,roleTableData.id ,bEnemyRole )
			local info = {
				nEffectID = v,
				roleId = roleTableData.id,
				name = roleTableData.name,
				bEnemy = bEnemyRole
			} 
		table.insert( loadingSkillList, info)
		end
	end
	local hitEff_list = skillDisplayInfo.hitEff
	if hitEff_list ~= nil and #hitEff_list ~= 0 then
		for k,v in pairs(hitEff_list) do
			-- self:creatSKillEffectByID( v ,roleTableData.id ,bEnemyRole )
			local info = {
				nEffectID = v,
				roleId = roleTableData.id,
				name = roleTableData.name,
				bEnemy = bEnemyRole
			} 
		table.insert( loadingSkillList, info)
		end
	end
	-- return effectList
end
function FightScene:creatRoleSkillEffect(roleTableData,skillid,bEnemyRole)
	local skillDisplayID = 0
	local bNormalAttack = false
	if skillid.skillId == 0 then -- 普通攻击
		skillDisplayID = roleTableData.normal_attack
		bNormalAttack = true
	end

	local skillInfo = BaseDataManager:GetSkillBaseInfo(skillid)
	if skillInfo ~= nil then
		skillDisplayID = skillInfo.display_id
	end

	local skillDisplayInfo = SkillDisplayData:objectByID(skillDisplayID)
	if skillDisplayInfo == nil then
		local armatureID = roleTableData.image
		if bNormalAttack then
			skillDisplayInfo = SkillDisplayData:objectByID(armatureID-10000)
		else
			skillDisplayInfo = SkillDisplayData:objectByID((armatureID-10000)*100+1)
		end

		if skillDisplayInfo == nil then
			skillDisplayInfo = SkillDisplayData:objectByID(9999)
		end
	end

	local xuliEffID = skillDisplayInfo.xuliEff
	if xuliEffID ~= nil and xuliEffID ~= 0 then
		self:creatSKillEffectByID( xuliEffID ,roleTableData.id ,bEnemyRole )
	end
	local attackEff_list = skillDisplayInfo.attackEff
	if attackEff_list ~= nil and #attackEff_list ~= 0 then
		for k,v in pairs(attackEff_list) do
			self:creatSKillEffectByID( v ,roleTableData.id ,bEnemyRole )
		end
	end
	local hitEff_list = skillDisplayInfo.hitEff
	if hitEff_list ~= nil and #hitEff_list ~= 0 then
		for k,v in pairs(hitEff_list) do
			self:creatSKillEffectByID( v ,roleTableData.id ,bEnemyRole )
		end
	end
end

function FightScene:creatSKillEffectByID( nEffectID ,roleId,bEnemyRole, bDelayLoad)
	if (FightManager.bMenWarning and bDelayLoad) then
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
		return
	end
	if skillEff == nil then
		return
	end

	if bEnemyRole then
		GameResourceManager:addEnemyEffect(roleId , nEffectID , skillEff )
	else
		GameResourceManager:addRoleEffect(roleId , nEffectID , skillEff )
	end
	if self.loadingLayer then
		self.loadingLayer:addChild(skillEff)
	end
	-- if (bDelayLoad) then
	-- 	local nMem = math.ceil(FightManager:GetTextureCacheMem() / 1024)
	-- 	if (nMem >= FightManager.MaxMen) then
	-- 		FightManager.bMenWarning = true
	-- 	end
	-- 	self.loadingLayer:setTips(nMem)
	-- end
end

function FightScene:moiveEnd()
	-- if FightManager.fightBeginInfo and FightManager.fightBeginInfo.index then
	-- 	TFDirector:currentScene():PlayBeginMoreEffect(FightManager.fightBeginInfo.index)
	-- else
	-- 	TFDirector:currentScene():PlayBeginEffect()
	-- end

	self.roleLayer:showRoleGotoScene()
	-- TFDirector:currentScene():PlayBgMusic()
	PlayerGuideManager:doGuide()
	self.moiveLayer:stopAllTimer()
	self.moiveLayer:removeFromParent(true)
	self.moiveLayer = nil
	self:PlayBgMusic()
end

function FightScene:createFightLayer()
	if self.mapLayer == nil then
		self.mapLayer  = require("lua.logic.fight.MapLayer"):new()
		self.roleLayer = require("lua.logic.fight.RoleLayer"):new()
		if(FightManager.bLoadError == true) then
			FightManager.bLoadError = false
			FightManager:LeaveFight()
			toastMessage(stringUtils.format(localizable.common_error_1, "Fight"), nil, nil, nil, true, 5)
			return
		end
		self.fightUiLayer = require("lua.logic.fight.FightUiLayer"):new()
		-- self.fightPauseLayer = require("lua.logic.fight.fightPauseLayer"):new()

		self.roleLayer:setZOrder(100)
		self.mapLayer:addChild(self.roleLayer)
		self:addLayer(self.mapLayer)
		self.fightUiLayer.logic = self
		self:addLayer(self.fightUiLayer)
		-- self:addLayer(self.fightPauseLayer)
		self:addPauseLayer()
		self.fightPauseLayer:setVisible(false)
		self.fightPauseLayer.logic = self
	end
	
	MissionManager:checkTrustOnekeyLayer(self.fightUiLayer)

	if FightManager:isNeedMoive() then
		local moiveInfo = MissionManager:getMoiveInfo()
		self.moiveLayer = require("lua.logic.fight.MoiveLayer"):new(moiveInfo)
		-- self.moiveLayer = require("lua.logic.fight.MoiveLayer"):new(1)
		self.moiveLayer:setZOrder(200)
		self.moiveLayer.logic = self
		self:addChild(self.moiveLayer)

	elseif FightManager:NeedShowText(true) then 
		local beginTextShowEndCallBack = function(event)
			-- if FightManager.fightBeginInfo and FightManager.fightBeginInfo.index then
			-- 	TFDirector:currentScene():PlayBeginMoreEffect(FightManager.fightBeginInfo.index)
			-- else
			-- 	TFDirector:currentScene():PlayBeginEffect()
			-- end
			TFDirector:currentScene().roleLayer:showRoleGotoScene()
			-- TFDirector:currentScene():PlayBgMusic()
			TFDirector:removeMEGlobalListener("MissionTipLayer.EVENT_SHOW_BEGINTIP_COM")
			PlayerGuideManager:doGuide()
		end
		TFDirector:removeMEGlobalListener("MissionTipLayer.EVENT_SHOW_BEGINTIP_COM")
		TFDirector:addMEGlobalListener("MissionTipLayer.EVENT_SHOW_BEGINTIP_COM",  beginTextShowEndCallBack)
		self:PlayBgMusic()
		if FightManager.fightBeginInfo.bGuideFight then
			local guideInfo = PlayerGuideManager:GetGuideFightInfo()
			MissionManager:showBeginTipForMission(guideInfo.mission_id)
		else
			if FightManager.fightBeginInfo.fighttype == 1 then
				MissionManager:showBeginTip()
			elseif FightManager.fightBeginInfo.fighttype == 17 then
				FactionManager:showTip(11)
			elseif FightManager.fightBeginInfo.fighttype == EnumFightType.JapanIsland and GameConfig.HD then
				JapanIslandManager:showTip(true)
			end
		end
    else
		self.timerID = TFDirector:addTimer(100, 1, nil, 
		function() 
			if FightManager.fightBeginInfo.bSkillShowFight then
				FightManager:OnEnterFightScene()
			else
				self.roleLayer:showRoleGotoScene()
				-- if FightManager.fightBeginInfo and FightManager.fightBeginInfo.index then
				-- 	self:PlayBeginMoreEffect(FightManager.fightBeginInfo.index)
				-- else
				-- 	self:PlayBeginEffect()
				-- end
				-- self:PlayBeginEffect()
				self:PlayBgMusic()
			end
			TFDirector:removeTimer(self.timerID)
			self.timerID = nil
		end)
	end
end

function FightScene:PlayBgMusic()
	local fightType = FightManager.fightBeginInfo.fighttype
	if fightType == 1 then
		local currMissionID = MissionManager.attackMissionId
		if MissionManager.missionList ~= nil then
			local missionInfo = MissionManager.missionList:objectByID(currMissionID)
			if missionInfo ~= nil and missionInfo.type ~= MissionManager.TYPE_COMMON then
				TFAudio.playMusic("sound/bgmusic/fight_boss.mp3", true)
			else
				TFAudio.playMusic("sound/bgmusic/fight.mp3", true)
			end
		end
	else
		TFAudio.playMusic("sound/bgmusic/fight.mp3", true)
	end
end
function FightScene:showZhenFa( index , battlearrayId , showEnter )
	if battlearrayId == nil or battlearrayId == 0 then
		return
	end
	local battlearray = BattleArrayData:objectByID(battlearrayId)
	if battlearray == nil then
		return
	end
	local effectName = "zhenfa_effect_zi"
	if battlearray.quality == 4 then
		effectName = "zhenfa_effect_zi"
	else
		effectName = "zhenfa_effect_jin"
	end
	if battlearrayId == 50035 then
		effectName = "zhenfa_effect_zi"
	end
	if battlearrayId == 50039 then
		effectName = "zhenfa_effect_zi2"
	end
	local _name = "effect/ui/"..effectName..".xml"
	TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/"..effectName..".xml")
	local effect = TFArmature:create(effectName.."_anim")
	effect:setAnimationFps(GameConfig.ANIM_FPS*2.3)
	effect:playByIndex(battlearray.effect_id, -1, -1, 0)
	if index == 1 then
		effect:setPosition(ccp(GameConfig.WS.width/2 - 350, GameConfig.WS.height/2+25))
	else
		effect:setPosition(ccp(GameConfig.WS.width/2 + 350, GameConfig.WS.height/2+25))
	end
	if showEnter then
		effect:addMEListener(TFARMATURE_COMPLETE,
		function()
				local removeTimeId 
				removeTimeId = TFDirector:addTimer(10, 1, function() 
															TFDirector:removeTimer(removeTimeId)
															removeTimeId = nil
														me.ArmatureDataManager:removeArmatureFileInfo(_name) 
													end, nil)
				
				FightManager:OnEnterFightScene()
		end)
	end
	self:addChild(effect)
end

function FightScene:PlayBeginEffect()
	TFAudio.playEffect("sound/effect/fight_begin.mp3", false)

	TFResourceHelper:instance():addArmatureFromJsonFile("effect/fightbegin.xml")
	local fightBeginEff = TFArmature:create("fightbegin_anim")
	fightBeginEff:setAnimationFps(GameConfig.ANIM_FPS)
	fightBeginEff:playByIndex(0, -1, -1, 0)
	fightBeginEff:setPosition(ccp(GameConfig.WS.width/2, GameConfig.WS.height/2+100))

	fightBeginEff:addMEListener(TFARMATURE_COMPLETE,
	function() 
		fightBeginEff:removeFromParent()
		local removeTimeId 
		removeTimeId = TFDirector:addTimer(10, 1, function() 
													TFDirector:removeTimer(removeTimeId)
													removeTimeId = nil
													me.ArmatureDataManager:removeArmatureFileInfo("effect/fightbegin.xml")
											end, nil)
		
		if FightManager.fightBeginInfo and (FightManager.fightBeginInfo.myBattlearrayId or FightManager.fightBeginInfo.enemyBattlearrayId) then
			local isshow = false
			if FightManager.fightBeginInfo.enemyBattlearrayId and FightManager.fightBeginInfo.enemyBattlearrayId ~= 0 then
				local showEnter = true
				if FightManager.fightBeginInfo.myBattlearrayId and FightManager.fightBeginInfo.myBattlearrayId ~= 0 then
					showEnter = false
				end
				self:showZhenFa( 2 , FightManager.fightBeginInfo.enemyBattlearrayId , showEnter )
				isshow = true
			end
			if FightManager.fightBeginInfo.myBattlearrayId and FightManager.fightBeginInfo.myBattlearrayId ~= 0 then
				self:showZhenFa( 1 , FightManager.fightBeginInfo.myBattlearrayId , true )
				isshow = true
			end
			if isshow == false then
				FightManager:OnEnterFightScene()
			end
		else
			FightManager:OnEnterFightScene()
		end
	end)

	self:addChild(fightBeginEff)
	fightAI:Start()
end

-- function FightScene:PlayBeginMoreEffect(index)
-- 	TFAudio.playEffect("sound/effect/fight_begin.mp3", false)

-- 	TFResourceHelper:instance():addArmatureFromJsonFile("effect/fight_begin_more.xml")
-- 	local fightBeginEff = TFArmature:create("fight_begin_more_anim")
-- 	fightBeginEff:setAnimationFps(GameConfig.ANIM_FPS)
-- 	fightBeginEff:playByIndex(index - 1, -1, -1, 0)
-- 	fightBeginEff:setPosition(ccp(GameConfig.WS.width/2, GameConfig.WS.height/2+100))

-- 	fightBeginEff:addMEListener(TFARMATURE_COMPLETE,
-- 	function() 
-- 		fightBeginEff:removeFromParent()
-- 		FightManager:OnEnterFightScene()
-- 	end)

-- 	self:addChild(fightBeginEff)
-- 	fightAI:Start()
-- end
function FightScene:PlayBeginMoreEffect(index,total)
	--happy modify
	print("--------------------------------->>>>>>>> index = ",index)
	print("--------------------------------->>>>>>>> total = ",total)
	TFAudio.playEffect("sound/effect/fightBeginMore.mp3", false)

	TFResourceHelper:instance():addArmatureFromJsonFile("effect/fightBeginMore.xml")
	local fightBeginEff = TFArmature:create("fightBeginMore_anim")
	fightBeginEff:setAnimationFps(GameConfig.ANIM_FPS)
	if index == total then
		fightBeginEff:playByIndex(3 - 1, -1, -1, 0)
	else
		fightBeginEff:playByIndex(index - 1, -1, -1, 0)
	end
	fightBeginEff:setPosition(ccp(GameConfig.WS.width/2, GameConfig.WS.height/2+100))

	fightBeginEff:addMEListener(TFARMATURE_COMPLETE,
	function() 
		fightBeginEff:removeFromParent()
		if FightManager.fightBeginInfo and (FightManager.fightBeginInfo.myBattlearrayId or FightManager.fightBeginInfo.enemyBattlearrayId) then
			local isshow = false
			if FightManager.fightBeginInfo.enemyBattlearrayId and FightManager.fightBeginInfo.enemyBattlearrayId ~= 0 then
				local showEnter = true
				if FightManager.fightBeginInfo.myBattlearrayId and FightManager.fightBeginInfo.myBattlearrayId ~= 0 then
					showEnter = false
				end
				self:showZhenFa( 2 , FightManager.fightBeginInfo.enemyBattlearrayId , showEnter )
				isshow = true
			end
			if FightManager.fightBeginInfo.myBattlearrayId and FightManager.fightBeginInfo.myBattlearrayId ~= 0 then
				self:showZhenFa( 1 , FightManager.fightBeginInfo.myBattlearrayId , true )
				isshow = true
			end
			if isshow == false then
				FightManager:OnEnterFightScene()
			end
		else
			FightManager:OnEnterFightScene()
		end
		-- FightManager:OnEnterFightScene()
	end)

	self:addChild(fightBeginEff)
	fightAI:Start()
end

function FightScene:clickPause( ... )
	-- FightManager:pause()
	-- fightAI:pause()
end

function FightScene:ZoomIn(attackRole)
	local zoomScale = 1.3
	local attackRolePos = attackRole:getPosition()

	local moveX = (attackRolePos.x - GameConfig.WS.width/2 + 250) * zoomScale
	local moveY = (attackRolePos.y - GameConfig.WS.height/2 + 125) * zoomScale
	moveX = math.max(0, moveX)
	moveY = math.max(0, moveY)

	moveX = math.min((zoomScale-1)*GameConfig.WS.width, moveX)

	self.mapLayer:ZoomIn(zoomScale, -moveX, -moveY)
end

function FightScene:ZoomOut()
	self.mapLayer:ZoomOut()
end

function FightScene:onExit()
	FightManager:Debug_Layer(true, true)
	FightManager.bFighting = false
	TFAudio.stopMusic()
	self.super.onExit(self)
	if self.timerID then
		TFDirector:removeTimer(self.timerID)
		self.timerID = nil
	end
end

function FightScene:addPauseLayer( ... )
	local blockUI = TFPanel:create();
	blockUI:setSize(GameConfig.WS);
	blockUI:setTouchEnabled(true); 

	blockUI:setBackGroundColorType(TF_LAYOUT_COLOR_SOLID);
	blockUI:setBackGroundColorOpacity(200);
	blockUI:setBackGroundColor(ccc3(  0,   0,   0));
	self:addLayer(blockUI);
	self.fightPauseLayer= blockUI
	local fightPauseLayer = require("lua.logic.fight.fightPauseLayer"):new()
	fightPauseLayer.logic = self
	blockUI:addChild(fightPauseLayer)
end

return FightScene
	-- end