--
-- Author: fei
-- Date: 2017-02-28 17:09:29
--
local CardEudemon      = require('lua.gamedata.base.CardEudemon');
BattlePetQualityData = require('lua.table.t_s_battle_pet_quality')
local EudemonManager = class("EudemonManager")

EudemonManager.MAX_LEVEL 						= 5       		-- 宠物最大等级
EudemonManager.MAX_STAR_LEVEL 					= 5  			-- 宠物最大突破星级
EudemonManager.MAX_QUALITY 						= 6  			-- 宠物最大品质
EudemonManager.MIN_QUALITY 						= 1  			-- 宠物最大品质
EudemonManager.OPEN_TRAINING_QUALITY 			= 5  	        -- 宠物开启训练师品质
--
EudemonManager.select_type_1 					= 1       		-- 宠物突破
EudemonManager.select_type_2					= 2 			-- 宠物驯化
EudemonManager.select_type_3					= 3 			-- 宠物驯驭

EudemonManager.upStarTupo 		= "EudemonManager.upStarTupo" 
EudemonManager.EudemonRole 		= "EudemonManager.EudemonRole" 
EudemonManager.EquipTeamEudemon = "EudemonManager.EquipTeamEudemon" 
EudemonManager.EudemonFree 		= "EudemonManager.EudemonFree"
EudemonManager.EudemonExchange 	= "EudemonManager.EudemonExchange"
EudemonManager.EudemonHole 		= "EudemonManager.EudemonHole"
EudemonManager.EudemonXunYu 	= "EudemonManager.EudemonXunYu"

EudemonManager.img_quality = {"ui_new/pet/icon_petlv_1.png","ui_new/pet/icon_petlv_2.png","ui_new/pet/icon_petlv_3.png","ui_new/pet/icon_petlv_4.png","ui_new/common/role_p5.png","ui_new/common/role_p6.png"}
EudemonManager.ImgEudemonType = {"ui_new/pet/icon_zhuwl.png","ui_new/pet/icon_zhuwl.png","ui_new/pet/icon_zhufy.png","ui_new/pet/icon_zhuwl.png","ui_new/pet/icon_zhusf.png"}
function EudemonManager:ctor()
	
	self.eudemonList = TFArray:new()
	self.eudemonInfoList = {}
	self:restart()
	--战宠
	TFDirector:addProto(s2c.BATTLE_PET_RESPONSE , self, self.updateEudemonList)
	--宠物升星
	TFDirector:addProto(s2c.BATTLE_PET_UP_RESPONSE , self, self.updateEudemonUpStar)
	--战宠请求更换驯兽师
	TFDirector:addProto(s2c.BATTLE_PET_TRAINER_REPLACE_RESPONSE , self, self.updateEudemonRole)
	--战宠请求装备阵容上
	TFDirector:addProto(s2c.BATTLE_PET_EQUIP_FORMATION_RESPONSE , self, self.updateEudemonTeam)
	--战宠放生
	TFDirector:addProto(s2c.BATTLE_PET_FREE_RESPONSE , self, self.updateEudemonFree)
	--战宠换功
	TFDirector:addProto(s2c.BATTLE_PET_EXCHANGE_RESPONSE , self, self.updateEudemonExchange)
	--获取战宠驯化孔位
	TFDirector:addProto(s2c.BATTLE_PET_GET_HOLE_RESPONSE , self, self.updateEudemonHole)
	--更新驯驭信息
	TFDirector:addProto(s2c.BATTLE_PET_TAME_HOLE_INFO_RESPONSE , self, self.updateXunYuEudemon)

	
	local openlevel = ConstantData:objectByID("BattlePet.WhichQualityOpenXunLianShi").value
	if (openlevel) then
		EudemonManager.OPEN_TRAINING_QUALITY = openlevel
	end
	--驯驭百分比加成(策划说的写死---徐强)
	self.XunYupercent = {1.5,1.3,1.15,1}
end

function EudemonManager:restart()
	self.eudemonList:clear()
	self.eudemonInfoList = {}
end

--宠物列表
function EudemonManager:updateEudemonList(event)
	--s2c.BATTLE_PET_RESPONSE = 0x4f01
	-- print("宠物列表 ",event.data.battlePetInfo)

	--self.eudemonList:clear()
	local info = event.data.battlePetInfo
	if (info == nil) then
		return
	end
	for i,v in ipairs(info) do
		self:addCardEudemon(v)
	end
	self:sortLevelList(self.eudemonList)
end

--宠物升星
function EudemonManager:updateEudemonUpStar(event)
	--s2c.BATTLE_PET_UP_RESPONSE = 0x4f02
	hideLoading()
	-- print("宠物升星回 ",event.data)
	local info 		= event.data
	local eudemonId = info.instanceId
	local quality 	= info.quality
	local star 		= info.star
	local upType 	= 1
	local eudemonInfo = self:getEudemonById(eudemonId)
	if (eudemonInfo) then
		if (eudemonInfo:getQuality() == quality) then
			if (eudemonInfo:getStarLevel() < star) then
				toastMessage(localizable.Eudemon_tips_4)
			end
		elseif (eudemonInfo:getQuality() < quality) then
			upType = 2
		end
	end
	
	local eudemonInfo = self:addCardEudemon(event.data)
	TFDirector:dispatchGlobalEventWith(EudemonManager.upStarTupo, {upType})
end

--战宠请求更换驯兽师
function EudemonManager:updateEudemonRole(event)
	--s2c.BATTLE_PET_TRAINER_REPLACE_RESPONSE = 0x4f03
	-- print("战宠请求更换驯兽师回 ",event.data)
	hideLoading()
	local info = event.data
	local eudemonId = info.instanceId
	local roleId 	= info.xiakeId
	local eudemonInfo = self:getEudemonById(eudemonId)
	if (eudemonInfo) then
		eudemonInfo:setTrainingRoleId(roleId)
	end
	TFDirector:dispatchGlobalEventWith(EudemonManager.EudemonRole, {eudemonId})
	
end

--战宠请求装备阵容上
function EudemonManager:updateEudemonTeam(event)
	--s2c.BATTLE_PET_EQUIP_FORMATION_RESPONSE = 0x4f04
	-- print("战宠请求装备阵容上回 ",event.data)
	local info 			= event.data
	local eudemonId 	= info.instanceId
	local fightType 	= info.formationType
	local useType 		= info.type
	self:clearEudemonFightState(fightType)
	local eudemonInfo 	= self:getEudemonById(eudemonId)
	eudemonInfo:addHelpFight(fightType, useType == 1)
	hideLoading()
	TFDirector:dispatchGlobalEventWith(EudemonManager.EquipTeamEudemon, {useType})
end
--战宠放生
function EudemonManager:updateEudemonFree(event)
	--s2c.BATTLE_PET_FREE_RESPONSE = 0x4f05
	hideLoading()
	-- print("战宠放生回  ",event.data)
	local info 			= event.data
	local eudemonId 	= info.instanceId
	for i,id in ipairs(eudemonId) do
		for info in self.eudemonList:iterator() do
			if (info:getId() == id) then
				self.eudemonList:removeObject(info)
				break
			end
		end
	end
	TFDirector:dispatchGlobalEventWith(EudemonManager.EudemonFree, {})
end
--战宠换功
function EudemonManager:updateEudemonExchange(event)
	--s2c.BATTLE_PET_EXCHANGE_RESPONSE = 0x4f06
	hideLoading()
	-- print("战宠换功回  ",event.data)
	local battlePetInfo 			= event.data.battlePetInfo
	local eudemonList = self:getEudemonList()
	for i,info in ipairs(battlePetInfo) do
		local eudemonId = info.instanceId
		for eudemonInfo in eudemonList:iterator() do
			if (eudemonInfo:getId() == eudemonId) then
				eudemonInfo:setData(info)
				break
			end
		end
	end
	local removePetId 	= event.data.removePetId
	local len 			= eudemonList:length()
	for i,eudemonId in ipairs(removePetId) do
		for eudemonInfo in eudemonList:iterator() do
			if (eudemonInfo:getId() == eudemonId) then
				eudemonList:removeObject(eudemonInfo)
				break
			end
		end
	end
	
	TFDirector:dispatchGlobalEventWith(EudemonManager.EudemonExchange, {})
end
--战宠孔位
function EudemonManager:updateEudemonHole(event)
	--s2c.BATTLE_PET_GET_HOLE_RESPONSE = 0x4f07
	hideLoading()
	--print("获取战宠驯化孔位和驯化战宠驯化孔位  ",event.data)
	local battlePetHole			  = event.data.hole
	local eudemonList = self:getEudemonList()
	local eudemonId = event.data.instanceId
	for eudemonInfo in eudemonList:iterator() do
		if (eudemonInfo:getId() == eudemonId) then
				local totalHole = string.split(battlePetHole,'|')
				local holeAttResponse = {}
				for k,v in ipairs(totalHole) do 
					local SingleHole = string.split(v,'_')
					local acupoint = tonumber(SingleHole[1])
					local level = tonumber(SingleHole[2])
					local quality = tonumber(SingleHole[3])
					holeAttResponse[k] = {}
					holeAttResponse[k].type = acupoint
					holeAttResponse[k].level = level
					holeAttResponse[k].quality = quality
					eudemonInfo:setHoleLevelValue(acupoint,quality,level)
				end
				eudemonInfo:setPetAttribute(holeAttResponse)
				eudemonInfo:updateAttr()
			break
		end
	end
	
	TFDirector:dispatchGlobalEventWith(EudemonManager.EudemonHole,{})
end
--战宠驯驭
function EudemonManager:updateXunYuEudemon(event)
	hideLoading()
	local eudemonId			  = event.data.instanceId
	local eudemonList = self:getEudemonList()
	for eudemonInfo in eudemonList:iterator() do
		if (eudemonInfo:getId() == eudemonId) then
			if event.data.tameMessage then
				eudemonInfo.XunyuLevel = string.split(event.data.tameMessage, '|')	
			end
			if event.data.tameMessage then
				eudemonInfo.XunyuOrder = string.split(event.data.tameHole, '|')	
			end
			eudemonInfo:updateAttr()
		end
	end
	TFDirector:dispatchGlobalEventWith(EudemonManager.EudemonXunYu,{})
end
--
function EudemonManager:clearEudemonFightState(fightType)
	--清除
	local eudemonId 	= self:getEudemonByFightId(fightType)
	local eudemonInfo 	= self:getEudemonById(eudemonId)
	if (eudemonInfo == nil) then
		return
	end
	eudemonInfo:addHelpFight(fightType, false, false)
end
function EudemonManager:isEudemonRoleIdFight(eudemonRoleId, fightType)
	for i=1,EnumFightStrategyType.StrategyType_Max do
		if (fightType == nil or (fightType and fightType == i)) then
	        local roleList = ZhengbaManager:getFightList(i)
	        for _,roleId in pairs(roleList) do
	            local role = CardRoleManager:getRoleByGmid(roleId)
	            if (role) then
	                if (eudemonRoleId == role.gmId) then
	                	return true
	                end
	            end
	        end
	    end
	end
	return false
end
--tyep //1升品，2升星
function EudemonManager:sendEudemonUpStar(type, eudemonId)
	--c2s.BATTLE_PET_UP_REQUEST = 0x4f02
	local msg = {type, eudemonId}
	print("1升品，2升星 ",msg)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_UP_REQUEST, msg)
end
--
function EudemonManager:sendEudemonUpHole(eudemonId,index)
	--c2s.Battle_Pet_Up_Hole_Request = code=0x4f08
	local msg = {eudemonId, index}
	--print("驯化孔位",msg)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_UP_HOLE_REQUEST,msg)
end
--
function EudemonManager:sendEudemonGetHole(eudemonId)
	local msg = {eudemonId}
	print("获得战宠孔位",msg)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_GET_HOLE_REQUEST,msg)
end
--
function EudemonManager:sendSetEudemonRole(eudemonId, xiakeId)
	--c2s.BATTLE_PET_TRAINER_REPLACE_REQUEST = 0x4f03
	local msg = {eudemonId, xiakeId}
	print("请求更改训练师  ",msg)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_TRAINER_REPLACE_REQUEST, msg)
	
end
function EudemonManager:sendEquipmentEudemonskill(eudemonId, num ,type)

	local msg = {eudemonId, num ,type}
	print("装备技能  ",msg)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_TAME_UPDATE_REQUEST, msg)
	
end
function EudemonManager:sendupgradeskill(eudemonId ,type)
	local msg = {eudemonId ,type}
	print("升级技能  ",msg)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_TAME_UPLEVEL_REQUEST, msg)
	
end
--//战宠请求装备阵容上//type 1 装备 2 卸下
function EudemonManager:sendEudemonEquipBattle (eudemonId, formationType, type)
	--c2s.BATTLE_PET_EQUIP_FORMATION_REQUEST = 0x4f04
	local msg = {eudemonId, formationType, type}
	print("战宠请求装备阵容上 ",msg)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_EQUIP_FORMATION_REQUEST, msg)
	
end

--//放生
function EudemonManager:sendEudemonBattleFree (eudemonIdlist)
	--c2s.BATTLE_PET_FREE_REQUEST = 0x4f05
	local msg = {}
	for i,eudemonId in ipairs(eudemonIdlist) do
		local eudemonInfo = self:getEudemonById(eudemonId)
		if (eudemonInfo == nil) then
			return
		end
		if (eudemonInfo:isHelpFight()) then
			toastMessage(stringUtils.format(localizable.Eudemon_not_free, eudemonInfo:getName()))
		--	return
		end
		table.insert(msg, eudemonId)
	end
	local msg1 = {msg}
	-- print("放生  ",msg1)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_FREE_REQUEST, msg1)
	
end
--//换功
function EudemonManager:sendEudemonBattleExchange (instanceId, exInstanceId)
	--c2s.BATTLE_PET_FREE_REQUEST = 0x4f06
	local msg = {}
	local msg1 = {instanceId, exInstanceId}
	-- print("换功  ",msg1)
	showLoading()
	TFDirector:send(c2s.BATTLE_PET_EXCHANGE_REQUEST, msg1)
	
end
function EudemonManager:getEudemonList()
	-- return self.eudemonInfoList
	return self.eudemonList
end

--获取阵容上的宠物
function EudemonManager:getEudemonByFightId(fightType)
    for info in self.eudemonList:iterator() do
		if (info:isHelpFight(fightType)) then
			return info:getId()
		end
	end
	return 0
end

function EudemonManager:getEudemonInfoByFightId(fightType)
    for info in self.eudemonList:iterator() do
		if (info:isHelpFight(fightType)) then
			return info
		end
	end
	return nil
end
function EudemonManager:OpemEudemonMainLayer(eudemonId, fightType, isShow, eudemonItemId)
	if (MainPlayer:getServerSwitchStatue(ServerSwitchType.Eudemon) == false) then
		return
	end
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.Eudemon.EudemonMainLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
	layer:setData(eudemonId, fightType, isShow, eudemonItemId)
    AlertManager:show()
	return layer
end

--培养界面
function EudemonManager:OpemEudemonTrainingLayer(eudemonId, index, fightType)
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.Eudemon.EudemonPanelLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
	layer:loadData(eudemonId, index, fightType)
    AlertManager:show()
end
--驯化界面
function EudemonManager:OpemEudemonXunHuaLayer(eudemonId, index, fightType)
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.Eudemon.EudemonPanelLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
	layer:loadData(eudemonId, index, fightType)
    AlertManager:show()
end
--宠物技能
function EudemonManager:openSkillInfo( skillId )
    --local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.Eudemon.EudemonSkillDetailLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1);
    local skillInfo = SkillBaseData:objectByID(skillId)
    if (skillInfo == nil) then
        return
    end
    local spellInfo         = skillInfo
    local spellLevelInfo    = spellInfo:GetLevelItem(1)
   -- spellLevelInfo.level 	= localizable.Eudemon_skill_tips
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.role.SkillDetailLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1);
    --第一个参数为cardrole_id,战宠不需要显示巅峰效果,便直接传入0
    layer:loadData(0,spellInfo,spellLevelInfo,nil, true);
    AlertManager:show();
end
--宠物预览
function EudemonManager:openPreviewLayer(eudemonId, quality)
    local layer = require("lua.logic.Eudemon.EudemonPreviewLayer"):new(eudemonId, quality)   
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    AlertManager:show();
end
--宠物装载
function EudemonManager:openRoleEudemonInfoLayer(fightType)
	local level = FunctionOpenConfigure:getOpenLevel(2226)
    local needLevel = level
    if MainPlayer:getLevel() < needLevel then
        --toastMessage(needLevel .. "级解锁")
        toastMessage(stringUtils.format(localizable.common_level_unlock,needLevel))
        return
    end
    if (MainPlayer:getServerSwitchStatue(ServerSwitchType.Eudemon) == false) then
    	toastMessage(localizable.Eudemon_tips_6)
		return
	end
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.Eudemon.RoleEudemonInfoLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_NONE);
    layer:setData(fightType)
    AlertManager:show();
end
--宠物列表
function EudemonManager:openEudemonListLayer()
	if (MainPlayer:getServerSwitchStatue(ServerSwitchType.Eudemon) == false) then
		return
	end
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.Eudemon.EudemonListLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_NONE);
    AlertManager:show();
end
--宠物放生列表
function EudemonManager:openEudemonFreeListLayer()
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.Eudemon.EudemonFreeListLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_NONE);
    AlertManager:show();
end

--宠物换功
function EudemonManager:openEudemonExchangeLayer()
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.Eudemon.EudemonExchangeLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_NONE);
    AlertManager:show();
end
--打开换功宠物
function EudemonManager:openEudemonListExchangeLayer(eudemonId, data, callBackFunc)
	local layer = require("lua.logic.Eudemon.PracticeEudemonSelect2"):new(data)   
    AlertManager:addLayer(layer, AlertManager.BLOCK, AlertManager.TWEEN_NONE)
    local clickCallBack = function(eudemonId)
		callBackFunc(eudemonId)
        layer:moveOut()
    end
	local eudemonList 	= self:getEudemonList()
	local selectList 	= TFArray:new()
	local tempList = TFArray:new()
	--if (eudemonId) then
	self:sortLevelList(eudemonList)
		for info in eudemonList:iterator() do
			if (info:getId() ~= eudemonId) then
				if (info:isHelpFight()) then
					tempList:push((info))
				else
					selectList:push((info))
				end
			end
		end
	-- else
	-- 	selectList = eudemonList
	--end
	self:sortLevelList(tempList, true)
    for info in tempList:iterator() do
        selectList:pushFront(info)
    end
	tempList:clear()
	layer:initDate(selectList, localizable.Eudemon_tips_7, clickCallBack)
	AlertManager:show();
end
--驯养师
function EudemonManager:openEudemonRoleSelectLayer(eudemonId, roleId, fightType)
	local layer = require("lua.logic.factionPractice.PracticeRoleSelect2"):new(nil, roleId)
    AlertManager:addLayer(layer, AlertManager.BLOCK, AlertManager.TWEEN_NONE)
    local clickCallBack = function(cardRole)
        local roleId = 0
        if (cardRole) then
            roleId = cardRole.gmId
            local eudemonInfo = self:getEudemonById(eudemonId)
            if (roleId == eudemonInfo:getTrainingRoleId()) then
            	roleId = 0
            end
        end
        layer:moveOut()
        self:sendSetEudemonRole(eudemonId, roleId)
    end

    local eudemonList = clone(CardRoleManager.cardRoleList)
    
	local roleList = ZhengbaManager:getFightList(fightType)
	for _,_roleId in pairs(roleList) do
		local roleInfo = CardRoleManager:getRoleByGmid(_roleId)
		if (roleInfo) then
			for roleId in eudemonList:iterator() do
				if (roleInfo.id == roleId) then
					eudemonList:removeObject(roleId)
					break
				end
			end
		end
	end

    local function sotrPower(cardRoleId1, cardRoleId2)
	    local cardRole1 = CardRoleManager:getRoleById(cardRoleId1)
	    local cardRole2 = CardRoleManager:getRoleById(cardRoleId2)
	    if cardRole1.quality == cardRole2.quality then
	    	if cardRole1.power ~= cardRole2.power then
		        return cardRole1.power > cardRole2.power
		    else
		    	return cardRole1.id > cardRole2.id
		    end
		else
			return cardRole1.quality > cardRole2.quality
	    end
	    return false
	end
	local nLen = eudemonList:length()
	if (nLen > 1) then
		eudemonList:sort(sotrPower)
	end
	local eudemonInfo = self:getEudemonById(eudemonId)
   	if (eudemonInfo) then
   		local roleGmId = eudemonInfo:getTrainingRoleId()
		if (roleGmId ~= 0) then
			local role = CardRoleManager:getRoleByGmid(roleGmId)
			if (role) then
				local roleId = role.id
				eudemonList:removeObject(roleId)
		    	eudemonList:pushFront(roleId)
		    end
	    end
   	end
    
   	
    layer:initDate(eudemonList, localizable.Eudemon_tips, clickCallBack)
    AlertManager:show();
end
--
function EudemonManager:addCardEudemon(info)

	local eudemonId 	= info.instanceId
	local cardEudemon 	= self:getEudemonById(eudemonId)
	if (cardEudemon == nil) then
		cardEudemon = CardEudemon:new(eudemonId);
		self.eudemonList:push(cardEudemon)
	end
	if (cardEudemon) then
		cardEudemon:setData(info)
	end
	return cardEudemon
end
--
function EudemonManager:getEudemonById(eudemonId, isNum)
	local eudemonInfo = nil
	local count = 0
	for info in self.eudemonList:iterator() do
		count = count + 1
		if (info.instanceId == eudemonId) then
			eudemonInfo = info
			break
		end
	end
	if (isNum) then
		return count
	end
	return eudemonInfo
end
--
function EudemonManager:isHaveEudemon(eudemonTypeId, quality)
	for info in self.eudemonList:iterator() do
		if (info:getEudemonTypeId() == eudemonTypeId and info:getQuality() >= quality) then
			return true
		end
	end
	
	return false
end
function EudemonManager:sortLevelList(eudemonList, order)
	-- 按宠物等级排序
    local function sortlist( info1, info2 )
    	if info1.quality == info2.quality then
    		if info1.starLevel == info2.starLevel then
    			return info1.instanceId > info2.instanceId
    		else
    			return info1.starLevel > info2.starLevel
    		end
    	else
    		return info1.quality > info2.quality
    	end
    end
 	local function sortlist2( info1, info2 )
    	if info1.quality == info2.quality then
    		if info1.starLevel == info2.starLevel then
    			return info1.instanceId < info2.instanceId
    		else
    			return info1.starLevel < info2.starLevel
    		end
    	else
    		return info1.quality < info2.quality
    	end
    end
    if (eudemonList:length() > 1) then
		if (order ~= true) then
    		eudemonList:sort(sortlist)
		else
			eudemonList:sort(sortlist2)
		end
    end
end
--
function EudemonManager:getBattlePetQualityData(quality, eudemonTypeId, starLevel)
	for info in BattlePetQualityData:iterator() do
		if (info.quality_id == quality and eudemonTypeId == info.pet_id and starLevel == info.star) then
			return info
		end
	end
	-- print("**ERROR********udemonManager:getBattlePetQualityData************",quality,",", eudemonTypeId,",", starLevel)
	return nil
end
function EudemonManager:getEudemonTeamAttr(quality, eudemonTypeId, starLevel)
	local eudemonData = self:getBattlePetQualityData(quality, eudemonTypeId, starLevel)
	if (nil == eudemonData) then
		return {}
	end
	local baseAttr = BattlePetData:GetPetAttrByEquipId(eudemonTypeId)
	if (baseAttr == nil) then
		return {}
	end
	local teamAttr = {}
	for attrId, attrValue in pairs(baseAttr) do
		attrValue = attrValue or 0
		attrValue = math.floor(attrValue * eudemonData.star_team_growth)
		teamAttr[attrId] = attrValue
	end
	return teamAttr
end

--
function EudemonManager:refreshRoleAttr(fightType)
	local roleList = ZhengbaManager:getFightList(fightType)
    for _,roleId in pairs(roleList) do
        local cardRole = CardRoleManager:getRoleByGmid(roleId)
        if (cardRole) then
        	cardRole:updateTotalAttr()
        end
	end
end

--获得返回消耗品
function EudemonManager:getEudemonFreeAward(eudemonTypeId, quality, starLevel)
	local qualityReturn = ConstantData:objectByID("BattlePet.Free.qualityReturn").value or 100
	local starReturn 	= ConstantData:objectByID("BattlePet.Free.starReturn").value or 100
	local awardList = {}
	for i=1,quality do
		local m = 5
		if (i == quality) then
			if (starLevel == 0 and i > 1) then
				m = 0
			else
				m = starLevel - 1
			end
		end
		for j=0, m do
			local data 	= self:getBattlePetQualityData(i, eudemonTypeId, j)
			if (quality > i or i == 1 or (quality == i and starLevel > 0)) then
				local item1 = string.split(data.star_consumes, "|")
				for _,v in ipairs(item1) do
					if (v and v ~= "") then
						local item1 		= string.split(v, "_")
						local itemTypeId 	= tonumber(item1[1])
						local itemId 		= tonumber(item1[2])
						local itemNum 		= tonumber(item1[3])
						itemNum = math.floor(itemNum * starReturn / 100)
						awardList[itemTypeId] 				= awardList[itemTypeId] or {}
						awardList[itemTypeId].item 			= awardList[itemTypeId].item or {}
						awardList[itemTypeId].item[itemId] 	= awardList[itemTypeId].item[itemId] or 0
						awardList[itemTypeId].item[itemId] 	= awardList[itemTypeId].item[itemId] + itemNum
						if (itemId == 30268) then
							aa = itemNum
						end
					end
				end
			end
			if (j == 0 and i ~= 1) then
				local item1 = string.split(data.quality_consumes, "|")
				for _,v in ipairs(item1) do
					if (v and v ~= "") then
						local item1 		= string.split(v, "_")
						local itemTypeId 	= tonumber(item1[1])
						local itemId 		= tonumber(item1[2])
						local itemNum 		= tonumber(item1[3])
						itemNum = math.floor(itemNum * qualityReturn / 100)
						awardList[itemTypeId] 				= awardList[itemTypeId] or {}
						awardList[itemTypeId].item 			= awardList[itemTypeId].item or {}
						awardList[itemTypeId].item[itemId] 	= awardList[itemTypeId].item[itemId] or 0
						awardList[itemTypeId].item[itemId] 	= awardList[itemTypeId].item[itemId] + itemNum
					end
				end
			end
		end
	end
	return awardList
end
function EudemonManager:getAllEudemonQualityList()
	local eudemonQualityList = {}
 	for v in BattlePetData:iterator() do
 		local iconList = string.split(v.icon, ",")
 		for i,itemId in ipairs(iconList) do
 			local itemData = ItemData:objectByID(tonumber(itemId))
			if (itemData) then
				eudemonQualityList[itemData.quality] = eudemonQualityList[itemData.quality] or {}
				local bHave = false
				if (self:isHaveEudemon(v.id, itemData.quality)) then
					bHave = true
				end
				if v.on_show == 1 and v.usable ~= 3 then
					table.insert(eudemonQualityList[itemData.quality], {id = itemData.id, quality = itemData.quality, isOwn = bHave,show_weight = itemData.show_weight or 0, typeId = v.id})
				end
			end
 		end
 	end
 	return eudemonQualityList
end
-- 计算每个品质的个数
function EudemonManager:CountNumInList(list)

	if list == nil then
		return nil
	end

	local qualityRoleNum = {}
	for i=1,(EudemonManager.MAX_QUALITY) do
		if list[i] then
			local SamequalityList = list[i]
			local num = #SamequalityList
			if num > 0 then
				local myOwnNum = 0
				for j=1,num do
					if SamequalityList[j].isOwn == true then
						myOwnNum = myOwnNum + 1
					end
				end
				table.insert(qualityRoleNum, 1, {quality = i, number = num, curNum = myOwnNum})
			end
		end
	end

    return qualityRoleNum
end
--驯养师红点
function EudemonManager:isShowRedPointOpenTraining(fightType)
	--fightType = EnumFightStrategyType.StrategyType_PVE
	local eudemonInfo = self:getEudemonInfoByFightId(fightType)
	if (eudemonInfo) then
		--已开启训练师且并没有装备
		if (eudemonInfo:isOpenTraining() and eudemonInfo:getTrainingRoleId() == 0) then
			local roleList = ZhengbaManager:getFightList(fightType)
			-- print("------------------------",roleList)
			local count = 0
			local countNum = 0
			for roldId in CardRoleManager.cardRoleList:iterator() do
				local roleInfo = CardRoleManager:getRoleById(roldId)
				if (roleInfo) then
					local gmId = roleInfo.gmId
					local isRed = true
					for _,_roleId in pairs(roleList) do
						-- print(_roleId ," ,  " ,gmId)
						if (_roleId ~= 0 and _roleId == gmId) then
							isRed = false
							break
						end
					end
					if (isRed) then
						return true
					end
				end
			end
		end
	end
	return false
end
--
function EudemonManager:isShowRedPoint()
	for info in self.eudemonList:iterator() do
		if (self:isShowEudemonRedPoint(info:getId())) then
			return true
		end
	end
	return false
end
--是否开启驯化
function EudemonManager:isOpenXunhua()
	local isOpen = MainPlayer:getServerSwitchStatue(ServerSwitchType.XunHua)
	if isOpen == false then 
		return false;
	end
	local openLevel = FunctionOpenConfigure:getOpenLevel(2224) or 78
    if MainPlayer:getLevel() >= openLevel then  
        return true
    end
	return false
end
--是否开启驯驭
function EudemonManager:isOpenXunYu()
	local isOpen = MainPlayer:getServerSwitchStatue(ServerSwitchType.XunYu)
	if isOpen == false then 
		return false;
	end
	local openLevel = FunctionOpenConfigure:getOpenLevel(2235)
    if MainPlayer:getLevel() >= openLevel then  
        return true
    end
	return false
end
--
function EudemonManager:isShowEudemonRedPoint(eudemonId)
	--for info in self.eudemonList:iterator() do
		local info = self:getEudemonById(eudemonId)
		if (info) then
			if (info:isHelpFight(EnumFightStrategyType.StrategyType_PVE) == false) then
				return false
			end
			local quality 	= info:getQuality()
			local starLevel = info:getStarLevel()
			local typeId 	= info:getEudemonTypeId()
			if (starLevel == EudemonManager.MAX_STAR_LEVEL) then
				--正常读表
				if (quality == EudemonManager.MAX_QUALITY) then
					return false
				end
				starLevel 	= 0
				quality 	= quality + 1
			end
			
			local itemList = {}
			if (info:getStarLevel() < EudemonManager.MAX_STAR_LEVEL) then
				local data 		= self:getBattlePetQualityData(quality, typeId, starLevel)
				if (data) then
					local item1 	= string.split(data.star_consumes, "|")
					for _,v in ipairs(item1) do
						if (v and v ~= "") then
							local item1 		= string.split(v, "_")
							local itemTypeId 	= tonumber(item1[1])
							local itemId 		= tonumber(item1[2])
							local itemNum 		= tonumber(item1[3]) or 0
							itemList[itemId] 	= itemList[itemId] or 0
							itemList[itemId] 	= itemList[itemId] + itemNum
						end
					end
				end
			else
				if (quality > EudemonManager.MAX_QUALITY) then
					return false
				end
				local data 		= self:getBattlePetQualityData(quality, typeId, 0)
				local item2 	= string.split(data.quality_consumes, "|")
				for _,v in ipairs(item2) do
					if (v and v ~= "") then
						local item1 		= string.split(v, "_")
						local itemTypeId 	= tonumber(item1[1])
						local itemId 		= tonumber(item1[2])
						local itemNum 		= tonumber(item1[3]) or 0
						itemList[itemId] 	= itemList[itemId] or 0
						itemList[itemId] 	= itemList[itemId] + itemNum
					end
				end
			end
			local count = 0
			local num 	= 0
			for itemId, itemNum in pairs(itemList) do
				count = count + 1
				local haveNum = BagManager:getItemNumById(itemId)
				if (haveNum < itemNum) then
					return false
				else
					num = num + 1
				end
			end
			return count == num
		end
		return false
end

--宠物换功消耗品
function EudemonManager:getEudemonExchareItemInfo(eudemonId_1, eudemonId_2)
	
	local constantNum = ConstantData:objectByID("BattlePet.Exchange.Consumes").value or 1
	local eudemonInfo_1 = self:getEudemonById(eudemonId_1)
	local eudemonInfo_2 = self:getEudemonById(eudemonId_2)
	if (eudemonInfo_1 and eudemonInfo_2) then
		local costItem 			= {}
		local quality_1 = eudemonInfo_1:getQuality()
		local quality_2 = eudemonInfo_2:getQuality()
		local diffQuality = math.abs( quality_2 - quality_1 )
		
		--宠物换功消耗品ID = 换功品质低的宠物类型ID
		local costEudemonTypeId = 0
		local costEudemonId 	= 0
		if (quality_2 > quality_1) then
			costEudemonTypeId 	= eudemonInfo_1:getEudemonTypeId()
			costEudemonId 		= eudemonInfo_1:getId()
			costEudemonPath 	= eudemonInfo_1:getIconPath()
		else
			costEudemonTypeId 	= eudemonInfo_2:getEudemonTypeId()
			costEudemonId 		= eudemonInfo_2:getId()
			costEudemonPath 	= eudemonInfo_2:getIconPath()
		end
		costItem.num 			= diffQuality * constantNum
		if (costItem.num <= 0) then
			--消耗保底
			costItem.num = 1
		end
		costItem.eudemonTypeId 	= costEudemonTypeId
		costItem.eudemonId 		= costEudemonId
		return costItem
	end
	return nil
end
--
function EudemonManager:getByEudemonTypeIdNum(eudemonIdList, eudemonTypeId, isFight)
	local eudemonList = self:getEudemonList()
	local num = 0
	for info in eudemonList:iterator() do
		if (info:getEudemonTypeId() == eudemonTypeId and info:getQuality() == 1 and info:getStarLevel() == 0) then
			local isAdd = true
			for _,eudId in ipairs(eudemonIdList) do
				if (info:getId() == eudId ) then
					isAdd = false
					break
				end
			end
			if (isAdd) then
				if (isFight ~= true and info:isHelpFight() ~= true) then
					--未上阵的所有宠物
					num = num + 1
				else
					num = num + 1
				end
			end
		end
	end
	return num
end

--宠物数量
function EudemonManager:getByEudemonTypeNum(eudemonTypeId)
	local eudemonList = self:getEudemonList()
	local num = 0
	for info in eudemonList:iterator() do
		if (info.itemTypeId == eudemonTypeId) then
			num = num + 1
		end
	end
	return num
end
--宠物驯化孔位等级特效
function EudemonManager:BindEffectOnEquip(panel, eudemonId)
	if eudemonId == nil or panel == nil then
    	return
    end
  	eudemonInfo = self:getEudemonById(eudemonId)
    local quality = 0
    if eudemonInfo then
    	for i=1, 5 do
    		local v = eudemonInfo:getHoleLevelValue(i)
    		if v then
    			if v.quality > quality then
    				quality = v.quality 
    			end
    		end
    	end
    end
    --quality = 3
	if panel.equipEffect then
		panel.equipEffect:removeFromParent()
		panel.equipEffect = nil
	end


    local infoTemplete = EquipmentRecastData:getInfoByquality(quality)
    if infoTemplete then
		local filePath = "effect/"..infoTemplete.effects..".xml"
		if not TFFileUtil:existFile(filePath) then
			return 
		end
    	TFResourceHelper:instance():addArmatureFromJsonFile(filePath)
	    local effect = TFArmature:create(infoTemplete.effects.."_anim")
	    effect:setAnimationFps(GameConfig.ANIM_FPS)
	    effect:playByIndex(0, -1, -1, 1)
	    effect:setVisible(true)
	    effect:setScale(1.15)
	    local offsetX = 0
	    local offsetY = 0
	    local widgetClassName = panel:getDescription()
	    if widgetClassName == 'TFPanel' then
	   		local contentSize = panel:getContentSize()
	   		offsetX = contentSize.width/2
	   		offsetY = contentSize.height/2
	    end
	    effect:setPosition(ccp(offsetX,offsetY))
	    panel:addChild(effect,100)
	    panel.equipEffect = effect	
    end
end

--宠物驯化孔位等级特效(直接取中间)
function EudemonManager:BindEffectOnEquip1(panel, eudemonId)
	if eudemonId == nil or panel == nil then
    	return
    end
  	eudemonInfo = self:getEudemonById(eudemonId)
    local quality = 0
    if eudemonInfo then
    	for i=1, 5 do
    		local v = eudemonInfo:getHoleLevelValue(i)
    		if v then
    			if v.quality > quality then
    				quality = v.quality 
    			end
    		end
    	end
    end
    --quality = 3
	if panel.equipEffect then
		panel.equipEffect:removeFromParent()
		panel.equipEffect = nil
	end


    local infoTemplete = EquipmentRecastData:getInfoByquality(quality)
    if infoTemplete then
    	local filePath = "effect/"..infoTemplete.effects..".xml"
    	TFResourceHelper:instance():addArmatureFromJsonFile(filePath)
	    local effect = TFArmature:create(infoTemplete.effects.."_anim")
	    effect:setAnimationFps(GameConfig.ANIM_FPS)
	    effect:playByIndex(0, -1, -1, 1)
	    effect:setVisible(true)
	    effect:setScale(1.15)
	    local offsetX = 0
	    local offsetY = 0
	    local widgetClassName = panel:getDescription()
	   	local contentSize = panel:getContentSize()
	   	offsetX = contentSize.width/2
	   	offsetY = contentSize.height/2
	    effect:setPosition(ccp(offsetX,offsetY))
	    panel:addChild(effect,100)
	    panel.equipEffect = effect	
    end
end

return EudemonManager:new()