--[[
******游戏数据角色牌类*******

	-- by Stephen.tao
	-- 2013/11/27

    -- by haidong.gan
	-- 2014/4/10
]]

-- local GameObject    = require('lua.gamedata.base.GameObject')
-- local RoleEquipment = require('lua.gamedata.base.RoleEquipment')

-- local GameAttributeData = require('lua.gamedata.base.GameAttributeData')
-- local RoleEffectExtraData = require('lua.gamedata.base.RoleEffectExtraData')

local GameObject    = clone(GameObjectModel)
local RoleEquipment = clone(RoleEquipmentModel)
local GameAttributeData = clone(GameAttributeDataModel)
local RoleEffectExtraData = clone(RoleEffectExtraDataModel)
local EffectExtraData = clone(EffectExtraDataModel)

local CardRole = class("CardRole",GameObject)

function CardRole:ctor( Data )
	self.super.ctor(self)
	self:init(Data)

	self.fightTypePos = {}
end

function CardRole:init( Data )
	self.Type 			= EnumGameObjectType.Role	--类型		//1为武将卡
	self.gmId			= 0 						--服务器唯一id
	self.level 			= 0							--等级
	self.pos			= 0							--位置
	self.curExp 		= 0 						--当前经验
	self.maxExp 		= 0 						--总经验
	self.upHp 			= 0 						--每升一级加血量
	self.head       	= 0 						--头像
	self.skillId		= 0 						--装备的技能id
	self.getTime 		= 0 						-- 获得时间
	self.power 			= 0
	self.skillLevel 	= 1
	self.starlevel		= 0 						--星级
	self.starexp 		= 0							--星级经验
	self.maxQianXiuStage= 1							--最大潜修阶段
	self.skillStarLevel = 0 --神技突破等级

	self.otherPlayerCard= false
	self.baseAttribute 	= GameAttributeData:new() 				
	self.attributeUp 	= GameAttributeData:new() 				
	self.attribute 		= GameAttributeData:new() 				
	self.equipAttribute	= GameAttributeData:new()				
	self.fateAttribute	= GameAttributeData:new()				
	self.fateAttributeForQihe = GameAttributeData:new()
	self.totalAttribute	= GameAttributeData:new()				
	self.totalAttributeForQihe	= GameAttributeData:new()
	self.attrCoefficient	= GameAttributeData:new()
	self.skillAttribute		= GameAttributeData:new()
	self.martialAttribute 	= GameAttributeData:new()
	self.starupAttribute 	= GameAttributeData:new()
	self.factionPracticeAttribute = GameAttributeData:new()
	self.qiheAttribute 	= GameAttributeData:new()	--契合属性
	self.monthAttribute = GameAttributeData:new()	--契合属性
	self.skyBookAttribute 	= GameAttributeData:new()	--契合属性
	self.xinFaAttribute 	= GameAttributeData:new() 	--心法属性
	self.XinFaSpecialAttribute = GameAttributeData:new() 	--特殊属性（不加战力只在人物属性界面显示）
	self.TianMingAttribute 		= GameAttributeData:new() 	--天命属性
	--self.TianMingSpecialAttribute  = EffectExtraData:new()  --天命特殊属性（只做存储显示用）
	-- self.TianMingAchievementAttribute = GameAttributeData:new()  --天命成就属性
	
	self.TianMingAchievementIdList = {} 	--天命成就达成id
	self.qimenAttribute = GameAttributeData:new()	--奇门属性
	self.qimenAttrTable = {}
	self.qimenTeamAttrTable = {}
	self.qimenPower = 0
	self.equipExtraPower = 0
	self.skyBookPower = 0
	self.suitPower = 0
	self.TianMingPower = 0

	self.lianTiAttribute = GameAttributeData:new()	--炼体属性
	self.lianTiAttrTable = {}

	self.qianxiuAttribute = GameAttributeData:new()	--潜修属性
	self.qianxiuAttrTable = {}
	self.qxChangeAttriTable = {}

	self.totalAttributeByType = {}
	self.fateStatesByType = {}

	--套装加成系数
	self.suitAttribute = {}
	self.suitEffectActivity = {}
	self.suitBeEffectActivity = {}

	self.factionPractice = {}

	self.effectExtraAttribute = RoleEffectExtraData:new(self)
	self.effectExtraAttribute:restart()
	self.beEffectExtraAttribute = RoleEffectExtraData:new(self)
	self.beEffectExtraAttribute:restart()
	self.immuneAttribute = RoleEffectExtraData:new(self) 	
	self.immuneAttribute:restart()
	-- self.starLevelAttributeTable	= {}
	-- self.starLevelPercentTable = {}
	
	self.acupointList 	= {}

	self.bookAttrAdd 	= {}
	self.acupointAttrAdd= {}
	self.equipment 		= RoleEquipment:new()		--装备
	self.fateMap 		= {}
	
	self:initConfig( Data ,true)
	-- <--------------add by king-
	self.blood_pos			= 0
	self.blood_maxHp		= 0
	self.blood_curHp		= 0
	self.blood_tag			= 0
	---->------------------end----
	--self:setLevel(1)

	--武学列表，装备武学的栏目
	self.martialList 		= {}
	self.martialLevel 		= 1							--武学等级，角色默认1级

	--added by wuqi
	self.bible = nil
	self.xinfa = nil
	self.LianTiData = {
		{acupoint = 1,level = 0,quality = 0,isOpen = true},
		{acupoint = 2,level = 0,quality = 0,isOpen = false},
		{acupoint = 3,level = 0,quality = 0,isOpen = false},
		{acupoint = 4,level = 0,quality = 0,isOpen = false},
		{acupoint = 5,level = 0,quality = 0,isOpen = false}
	}
	self.TianMing = {
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,star = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil}
	}

	-- add by stephen
	self.absoluteConfig = {}
	self.lvlupAddConfig = {}
	self.monthState = 0
	
end


function CardRole:initConfig( role_id ,isInit)
	local roleConfig = RoleData:objectByID(role_id)
	if(roleConfig == nil) then
		toastMessage("角色获取为空(CardroleConfig:49)-"..role_id)
		return
	end
	self.id 				= roleConfig.id 
	self.name  				= roleConfig.name
	if isInit then
		self.quality			= roleConfig.quality					--品质
	end
	-- self.textrueName		= roleConfig:getImagePath()				--全身像
	self.bigTextrueName		= roleConfig:getBigImagePath()				--全身像
	self.head 				= roleConfig:getHeadPath()				--头像
	self.icon 				= roleConfig:getIconPath()				--头像
	self.describe1			= roleConfig.description				--描述
	self.provide_exp			= roleConfig.provide_exp	
	self.soul_card_id			= roleConfig.soul_card_id	
	self.merge_card_num			= roleConfig.merge_card_num	
	self.upstar_need_soul_num_arr	= string.split(roleConfig.upstar_need_soul_num,',')			--分解"，"
	self.maxStar = roleConfig.max_star_level

	--quanhuan 2015-10-10 10:25:09
	self.upstar_need_soul_num_list = RoleTalentData:GetRoleStarInfoByRoleId( self.id , self.quality)
	
	self.spellLevelIdList	= {}
	self.leadingRoleSpellList	= {}

	self.spellInfoList				= roleConfig:getSpellInfoList();
	self.leadingSpellInfoConfigList	= roleConfig:getLeadingSpellInfoConfigList();
	self.leadingSpellInfoList	    = roleConfig:getLeadingSpellInfoList();

	self.price				= 100 									--身价
	self.skillId			= roleConfig.skill
	self.outlineArr			= roleConfig:getOutline()
	self.outline			= roleConfig.outline

	self.baseAttribute:init(roleConfig.attribute)
	self.attributeUp:init(roleConfig.level_up)

	self.effectExtraAttribute:initBaseAttribute(roleConfig.effect_extra)
	self.beEffectExtraAttribute:initBaseAttribute(roleConfig.be_effect_extra)
	self.immuneAttribute:initBaseAttribute(roleConfig.immune)

	self.upHp 				= roleConfig.lv_maxhp
	self.isMainPlayer 		= ProtagonistData:IsMainPlayer( self.id )
	self.qualityOne		    = roleConfig.quality_one

end

function CardRole:dispose()
	self.gmId		= nil 								--服务器唯一id
	self.level 		= nil								--等级

	self.pos		= nil								--位置
	self.curExp 	= nil 								--当前经验
	self.maxExp 	= nil 								--总经验
	self.getTime 	= nil 		  						-- 获得时间
	self.upHp  		= nil
	self.head  		= nil
	self.baseAttribute 		= nil
	self.attributeUp 		= nil
	self.attribute 			= nil 						--基本属性
	self.fateAttribute		= nil						--缘分属性
	self.fateAttributeForQihe		= nil						--缘分属性
	self.totalAttribute		= nil						--总属性
	self.totalAttributeForQihe		= nil						--总属性
	self.skyBookAttribute		= nil						--总属性
	self.xinFaAttribute 		= nil
	self.XinFaSpecialAttribute	= nil
	self.TianMingAttribute		= nil 
	--self.TianMingSpecialAttribute  = nil
	-- self.starLevelAttributeTable = nil						--升星属性加成
	-- self.starLevelPercentTable = nil
	self.starupAttribute	= nil
	self.attrCoefficient 	= nil
	self.equipment 			= nil 						--装备
	self.skillId			= nil 						--装备的技能id
	self.equipAttribute		= nil
	self.power 				= nil
	self.skillLevel 		= nil
	self.acupointList		= nil
	self.otherPlayerCard	= nil
	self.bookAttrAdd 		= nil
	self.acupointAttrAdd	= nil
	self.starlevel			= nil
	self.starexp 			= nil
	self.skillStarLevel		= nil
	self.fateMap 			= nil
	self.martialList		= nil
	self.martialAttribute 	= nil
	self.factionPracticeAttribute 	= nil
	self.immuneAttribute 	= nil
	self.effectExtraAttribute 	= nil
	self.beEffectExtraAttribute 	= nil
	self.lianTiAttribute = nil
	self.lianTiPercentAttribute = nil
	self.lianTiAttrTable = {}
	self.qianxiuAttribute = nil
	self.qianxiuAttrTable = {}
	self.qxChangeAttriTable = {}
	self.totalAttributeByType = nil
	self.fateStatesByType = nil
	self.fateMap = {}
	self.super.dispose(self)

	--套装加成系数
	self.suitAttribute = {}
	self.suitEffectActivity = {}
	self.suitBeEffectActivity = {}
	-- TFDirector:unRequire('lua.gamedata.base.GameObject')
	-- TFDirector:unRequire('lua.table.RoleData')
	self.qualityOne	= nil
end

function CardRole:setPos(pos)
	if pos == nil then
		pos = 0
	end
	
	self.pos = pos
end

function CardRole:setSpellLevelIdList(spellLevelIdList)
	self.spellLevelIdList	= spellLevelIdList or {};
	self:updateSkillAttr();
end
function CardRole:setLeadingRoleSpellList(leadingRoleSpellList)
	self.leadingRoleSpellList = leadingRoleSpellList
end

function CardRole:getEquipment()
	return self.equipment
end

function CardRole:getNameColor()
	return GetColorByQuality(self.quality)
end

function CardRole:getEquipmentByIndex(index)
	return self.equipment:GetEquipByType(index)
end

--added by wuqi
--test
--[[
function CardRole:getSkyBook()
	local book  = SkyBookManager:getItemByInstanceId(1)
	book.equip = self.id
	return book
end
]]

function CardRole:setLevel(level)
	if self.level == level then
		return
	end

	self.level = level
	self.maxExp = LevelData:getMaxRoleExp(level)
	--self:refreshRoleBaseAttr()
	self:updateTotalAttr()

	if self.effectExtraAttribute:isNeedUpdateByLevelUp() then
		self.effectExtraAttribute:updateAttribute()
	end
	if self.immuneAttribute:isNeedUpdateByLevelUp() then
		self.immuneAttribute:updateAttribute()
	end
	if self.beEffectExtraAttribute:isNeedUpdateByLevelUp() then
		self.beEffectExtraAttribute:updateAttribute()
	end
end

function CardRole:getTotalExp()
	local exp = self.curExp
	for i=1,self.level - 1 do
		exp = exp + LevelData:getMaxRoleExp(i)
	end
	return exp
end

function CardRole:refreshRoleBaseAttr()
	local function cmp( attr , index ,tbl)
		local attributeUp = tbl.attributeUp:getAttribute()
		local temp = attributeUp[index] or 0
		local martialAdd = 0
		if tbl.martial and tbl.martial[index] then
			martialAdd = tbl.martial[index]
		end
		local num = math.floor((attr + temp * tbl.trainItem.lv_up_mutil * (tbl.level + tbl.trainItem.extra_lv))  * tbl.trainItem.streng_then + martialAdd)
		return math.floor(num)
	end
	self.attribute:clear()

	-- local roleConfig = RoleData:objectByID(self.id)
	-- if roleConfig == nil then
	-- 	toastMessage("角色获取为空(CardroleConfig:49) - ".. self.id)
	-- 	return
	-- end

	--print("CARD ROLE : ",roleConfig.quality,self.quality)
	--[[
	local roleType = 1 
    local bQuailtyUp =  CardRoleManager:getShengPingByCard(self.cardRole)
    --红色侠客升品 成长系数不同
    if bQuailtyUp and self.cardRole.quality == 6 then
    	roleType = 2
    end	
	]]
	
	local trainItem = RoleTrainData:getRoleTrainByQuality(self.quality,self.starlevel,self.qualityOne)
	local martialRole = MartialRoleConfigure:findByRoleIdAndMartialLevel(self.id,self.martialLevel -1)
	local martialAdd = nil
	if martialRole then
		martialAdd = martialRole:getAttributeTable()
	end
	--if self.id == 77 then
	--	print("CardRole:refreshRoleBaseAttr() : ",self.quality,self.startlevel,trainItem)
	--end
	self.attribute:setAttByMath(self.baseAttribute,cmp,{level = (self.level -1),attributeUp = self.attributeUp,trainItem = trainItem,martial = martialAdd})

	-- --添加天赋属性Attribute 固定值
	-- for k,v in pairs(self.starLevelAttributeTable) do
	-- 	self.attribute:addAttr(k,v)
	-- end

	-- --添加天赋属性Attribute 百分比
	-- for k,v in pairs(self.starLevelPercentTable) do
	-- 	local attr_index = k-17
	-- 	local base_value = self.attribute:getAttributeByIndex(attr_index)
	-- 	local curr_value = math.floor((v)/10000*base_value)
	-- 	self.attribute:addAttr(attr_index,curr_value)
	-- end
end

function CardRole:updateTotalAttr()
	if self.otherPlayerCard then
		return
	end
	if CommonManager:checkLoginCompleteState() == false then
		return
	end
	self.totalAttribute:clear()
	self.totalAttributeForQihe:clear()

	self:refreshRoleBaseAttr()
	self.totalAttribute:clone(self.attribute)


	-- print(self.name.."------------------self.totalAttribute 11111 ->",self.totalAttribute:displayString())
	self.totalAttribute:setAddAttData(self.martialAttribute)
	--if self.id == 77 then
	--	print("裸体【等级+放大倍数】 ->",self.attribute:displayString())
	--end
	
	--if self.id == 77 then
	--	print("+缘分 ->",self.totalAttribute:displayString())
	--end
	for k,v in pairs(self.bookAttrAdd) do
		self.totalAttribute:addAttr(k,v)
	end
	
	for k,v in pairs(self.acupointAttrAdd) do
		self.totalAttribute:addAttr(k,v)
		--print("经脉 ",k,v)
	end
	-- print(self.name.."------------------self.totalAttribute 222 ->",self.totalAttribute:displayString())
	--奇门属性加成
	self.totalAttribute:setAddAttData(self.qimenAttribute)

	--if self.id == 77 then
	--	print("+经脉 ->",self.totalAttribute:displayString())
	--end
	--print("装备属性尼玛逼 ： ",self.equipAttribute:displayString())
	--if self.id == 77 then
	--	print("+装备 ->",self.totalAttribute:displayString())
	--end
	self.totalAttribute:setAddAttData(self.skillAttribute)
	--if self.id == 77 then
	--	print("+被动技能 ->",self.totalAttribute:displayString())
	--end
	--天赋属性
	self.totalAttribute:setAddAttData(self.starupAttribute)

	self.totalAttribute:setAddAttData(self.lianTiAttribute)
	self.totalAttribute:setAddAttData(self.qianxiuAttribute)
	
	self.totalAttribute:setAddAttData(self.fateAttribute)

	self.totalAttribute:setAddAttData(self.factionPracticeAttribute)

	self.totalAttribute:refreshBypercent()
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	self.equipAttribute:refreshBypercent()
	self.totalAttribute:setAddAttData(self.equipAttribute)
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	
	self.skyBookAttribute:refreshBypercent()
	self.totalAttribute:setAddAttData(self.skyBookAttribute)
	self.totalAttribute:setAddAttData(self.xinFaAttribute)
	--天命属性
	self.totalAttribute:setAddAttData(self.TianMingAttribute)
	
	--self.totalAttributeForQihe:setAddAttData(self.fateAttributeForQihe)
	self.monthAttribute:clear()
	if self.isMainPlayer then
		local vip_add = VipRuleManager:addMainPlayerAttr()
		if vip_add ~= 0 then
			self.monthAttribute:addAttr(EnumAttributeType.Force,vip_add)
			self.monthAttribute:addAttr(EnumAttributeType.Magic,vip_add)

			-- self.totalAttributeForQihe:addAttr(EnumAttributeType.Force,vip_add)
			-- self.totalAttributeForQihe:addAttr(EnumAttributeType.Magic,vip_add)
		end
	end

	
	if MonthCardManager:getCardState() ~= self.monthState then
		self.monthState = MonthCardManager:getCardState()
		self:calculationMonthAttr()
	end
	self:updateMonthCard()
	self.monthAttribute:refreshBypercent()
	self.totalAttribute:setAddAttData(self.monthAttribute)
	self.totalAttributeForQihe:clone(self.totalAttribute)
	--契合所加属性
	


	--self.totalAttribute:setAddAttData(self.qiheAttribute)
	

	-- self.totalAttributeForQihe:refreshBypercent()

	-- self.totalAttributeForQihe:setAddAttData(self.qiheAttribute)
	-- self.totalAttributeForQihe:setAddAttData(self.factionPracticeAttribute)
	-- print(self.name.."------------------self.totalAttribute 333 ->",self.totalAttribute:displayString())

	-- -- 大月卡增加额外属性-- 主角：武力、内力 各500 +level*5
	-- local bOwnMonth = MonthCardManager:isExistMonthCard(MonthCardManager.CARD_TYPE_2)
	-- if bOwnMonth == true then
	-- 	if self.isMainPlayer then
	-- 		self.monthAttribute:clear()
	-- 		self:updateMonthCard()
	-- 		self.totalAttribute:setAddAttData(self.monthAttribute)	
	-- 		self.totalAttributeForQihe:setAddAttData(self.monthAttribute)	
	-- 		-- local level = MainPlayer:getLevel()
	-- 		-- local wuliPower = 500 + 5 * level
	-- 		-- self.totalAttribute:addAttr(EnumAttributeType.Force, wuliPower)
	-- 		-- local neiliPower = 500 + 5 * level
	-- 		-- self.totalAttribute:addAttr(EnumAttributeType.Magic, neiliPower)

	-- 		-- self.totalAttributeForQihe:addAttr(EnumAttributeType.Force, wuliPower)
	-- 		-- self.totalAttributeForQihe:addAttr(EnumAttributeType.Magic, neiliPower)
	-- 	end
	-- end

	-- print(self.name.."------------------self.totalAttribute 444 ->",self.totalAttribute:displayString())
	-- 套装加成
	-- self:updataSuitAdd()
	self.totalAttribute:refreshBypercent()
	local suitAttribute = self:getSuitPowerAndAttri(self.totalAttribute)
	-- print("套装加成",suitAttribute)
	self.totalAttribute:setAddAttData(suitAttribute)
	self.totalAttributeForQihe:setAddAttData(suitAttribute)
	self.totalAttributeForQihe:refreshBypercent()
	self.totalAttribute:refreshBypercent()
	self.totalAttribute:updatePower()
	
	self:updatePower()
	CardRoleManager.cardRoleAttriChanged = true
	--if self.id == 77 then
	--	print("总属性 ->",self.totalAttribute:displayString())
	--end
	-- print("############# " .. self.name .. "  战力：" .. self.power .." ##################")
end

function CardRole:calculationMonthAttr()
	self.absoluteConfig = {}
	self.lvlupAddConfig = {}
	for v in MonthCardBuffData:iterator() do
		if (v.role_type == 1 and self.isMainPlayer) or v.role_type == 2 then
			local flag = bit_and(self.monthState , v.enable_bit)
			if flag == v.enable_bit then
				local absolute = v:getAbsolute()
				local lvlup = v:getLevelUp()
				for k,v in pairs(absolute) do
					self.absoluteConfig[k] = self.absoluteConfig[k] or 0
					self.absoluteConfig[k] = self.absoluteConfig[k] + v
				end
				for k,v in pairs(lvlup) do
					self.lvlupAddConfig[k] = self.lvlupAddConfig[k] or 0
					self.lvlupAddConfig[k] = self.lvlupAddConfig[k] + v
				end
			end
		end
	end
end
 
function CardRole:calculationMonthAttrInArmy()
	--print("calculationMonthAttrInArmy")
	local absoluteConfig = {}
	local lvlupAddConfig = {}
	local level = MainPlayer:getLevel()
	local attribute	= GameAttributeData:new()
	for v in MonthCardBuffData:iterator() do
		-- print("calculationMonthAttrInArmy=-=====>>",v)
		if v.role_type == 3 then
			local flag = bit_and(self.monthState , v.enable_bit)
			-- print("------------->>>>.flag",flag)
			if flag == v.enable_bit then
				local absolute = v:getAbsolute()
				local lvlup = v:getLevelUp()
				for k,v in pairs(absolute) do
					absoluteConfig[k] = absoluteConfig[k] or 0
					absoluteConfig[k] = absoluteConfig[k] + v
				end
				for k,v in pairs(lvlup) do
					lvlupAddConfig[k] = lvlupAddConfig[k] or 0
					lvlupAddConfig[k] = lvlupAddConfig[k] + v
				end
			end
		end
	end

	for k,v in pairs(absoluteConfig) do
		attribute:addAttr(k, v)
	end
	for k,v in pairs(lvlupAddConfig) do
		attribute:addAttr(k, v*level)
	end
	return attribute
end

function CardRole:updateMonthCard()
	local level = MainPlayer:getLevel()
	for k,v in pairs(self.absoluteConfig) do
		self.monthAttribute:addAttr(k, v)
	end
	for k,v in pairs(self.lvlupAddConfig) do
		self.monthAttribute:addAttr(k, v*level)
	end
end
-- function CardRole:updateMonthCard()
-- 	-- 大月卡增加额外属性-- 主角：t_s_month_card_buff_conf
-- 	print("updateMonthCard")
-- 	local bOwnMonth = MonthCardManager:isExistMonthCard(MonthCardManager.CARD_TYPE_2)
-- 	if bOwnMonth == true then
-- 		if self.isMainPlayer then
-- 			local level = MainPlayer:getLevel()
-- 			local dataConfig = MonthCardBuffData:objectByID(1)
-- 			local absoluteConfig,_ = stringToTable(dataConfig.absolute,"|")
-- 			local lvlupAddConfig,_ = stringToTable(dataConfig.level_up,"|")
-- 			local propAddConfig = {}
-- 			for k,v in pairs(absoluteConfig) do
-- 				local config,_ = stringToNumberTable(v,"_")
-- 				if config[1] ~= nil then
-- 					local index = config[1]
-- 					local baseAdd = config[2]
-- 					propAddConfig[index] = propAddConfig[index] or {}
-- 					propAddConfig[index].baseAdd = baseAdd
-- 				end
-- 			end
-- 			for k,v in pairs(lvlupAddConfig) do
-- 				local config,_ = stringToNumberTable(v,"_")
-- 				if config[1] ~= nil then
-- 					local index = config[1]
-- 					local lvlAdd = config[2]
-- 					propAddConfig[index] = propAddConfig[index] or {}
-- 					propAddConfig[index].lvlAdd = lvlAdd
-- 				end
-- 			end
-- 			for k,v in pairs(propAddConfig) do
-- 				local baseAdd = v.baseAdd or 0
-- 				local lvlAdd = v.lvlAdd or 0
-- 				self.monthAttribute:addAttr(k, baseAdd + lvlAdd*level)
-- 			end
-- 		end
-- 	end
-- end

--[[
战斗力 = 生命*0.1 + 武力 * 0.5+ 内力*0.5+ 身法*0.5 +防御*0.5 + 冰伤*0.5 + 毒伤*0.5+ 火伤*0.5+冰抗 *0.5+ 火抗*0.5+ 毒抗*0.5 + 技能加成
]]
function CardRole:updatePower()
	self.power = self.totalAttribute:getPower()
	if self.spellPower then
		self.power = self.power + self.spellPower
	end

	--增加修炼场战斗力
	local factionSkill = self.factionPractice or {}
	for k,v in pairs(factionSkill) do
		self.power = self.power + v.power
	end

	self.power = self.power + self.qimenPower
	self.power = self.power + self.skyBookPower
	self.power = self.power + self.equipExtraPower
	self.power = self.power + self.suitPower
	self.power = self.power + self.TianMingPower


	for i=1,EnumFightStrategyType.StrategyType_Max do
		if i == CardRoleManager.openArmyIndex then
			if self.totalAttributeByType[i] then
				if AssistFightManager:freshRoleInStrategyPower( i ,self.gmId ) == false then
					self.totalAttributeByType[i] = nil
				end
			end
		end
	end
end

function CardRole:getTotalAttribute(index  )
	if index == nil then
		return self.totalAttribute:getAttribute()
	end

	local attribute = self.totalAttribute:getAttribute()
	local num = attribute[index] or 0
	local attrCoefficient = 1
	return num,attrCoefficient
end

function CardRole:getTotalAttributeByFightType(fight_type,index  )
	-- print("self.totalAttributeByType[fight_type]  ==",self.totalAttributeByType[fight_type]:displayString())
	-- print("self.totalAttribute  ==",self.totalAttribute:displayString())
	if self.totalAttributeByType[fight_type] == nil then
		return self:getTotalAttribute(index)
	end
	if AssistFightManager:isinStrategyList( fight_type,self.gmId ) == false then
		self.totalAttributeByType[fightType] = nil
		return self:getTotalAttribute(index)
	end

	if index == nil then
		return self.totalAttributeByType[fight_type]:getAttribute()
	end
	local attribute = self.totalAttributeByType[fight_type]:getAttribute()

	local num = attribute[index] or 0
	local attrCoefficient = 1
	return num,attrCoefficient
end

function CardRole:getTotalAttributeWithOutQihe(index)
	if index == nil then
		return self.totalAttributeForQihe:getAttribute()
	end
	local attribute = self.totalAttributeForQihe:getAttribute()
	local num = attribute[index] or 0
	local attrCoefficient = 1
	return num,attrCoefficient
end

function CardRole:getTotalExtAttributeByFightType(fight_type)
	local immuneAttribute = EffectExtraData:new()
	local effectExtraAttribute = EffectExtraData:new()
	local beEffectExtraAttribute = EffectExtraData:new()

	immuneAttribute:setAddAttData(self.immuneAttribute.totalAttribute)
	effectExtraAttribute:setAddAttData(self.effectExtraAttribute.totalAttribute)
	beEffectExtraAttribute:setAddAttData(self.beEffectExtraAttribute.totalAttribute)

	local posInStrategy = AssistFightManager:checkIsStrategyMemberByFightType( self.gmId,fight_type )
	--判断是否上阵
	if posInStrategy ~= 0 then
		local ir_tbl0,ea_tbl0,ep_tbl0 = AssistFightManager:getAchieveTotalExtAttr()
		-- print('AssistFight ir_tbl0,ea_tbl0,ep_tbl0 = ',ir_tbl0,ea_tbl0,ep_tbl0)
		ir_tbl0 = ir_tbl0 or {}
		ea_tbl0 = ea_tbl0 or {}
		ep_tbl0 = ep_tbl0 or {}
		immuneAttribute:add(ir_tbl0)
		effectExtraAttribute:add(ea_tbl0)
		beEffectExtraAttribute:add(ep_tbl0)
		---------------------------------------------------------------
		ea_tbl0,ep_tbl0 = RedPacketManager:getAcheivExtAttri()
		-- print('RedPacket ea_tbl0,ep_tbl0 = ',ea_tbl0,ep_tbl0)
		ea_tbl0 = ea_tbl0 or {}
		ep_tbl0 = ep_tbl0 or {}
		effectExtraAttribute:add(ea_tbl0)
		beEffectExtraAttribute:add(ep_tbl0)

		---------------------------------------------------------------
		local cardStrategy = StrategyCardManager:getStrategyCardByStrategyType(fight_type)
		if cardStrategy then
			--阵法星级加成,判断是否在阵位上
			local isInPos, ir_tbl0,ea_tbl0,ep_tbl0 = cardStrategy:getTotalExtAttr(self.pos)
			--基础属性上阵就加,特殊属性只加在阵位上
			ir_tbl0 = ir_tbl0 or {}
			immuneAttribute:add(ir_tbl0)
			if (isInPos == true) then
				ea_tbl0 = ea_tbl0 or {}
				ep_tbl0 = ep_tbl0 or {}
				effectExtraAttribute:add(ea_tbl0)
				beEffectExtraAttribute:add(ep_tbl0)
			end
			--阵法深研加成
			local isInPos, ea_tbl0, ep_tbl0 = cardStrategy:getShenYanEffectAttr(self.pos)
			if (isInPos == true) then
				ea_tbl0 = ea_tbl0 or {}
				ep_tbl0 = ep_tbl0 or {}
				effectExtraAttribute:add(ea_tbl0)
				beEffectExtraAttribute:add(ep_tbl0)
			end
		end
		--帮派成就属性
		local giveAchievementAttr, beAttrList, power, effectAttrList = FactionJiShiTangManager:getGiveAchievementAttr(fight_type)
		if (giveAchievementAttr) then
			immuneAttribute:add(giveAchievementAttr)
		end
		if (effectAttrList) then
			effectExtraAttribute:add(effectAttrList)
		end
		if (beAttrList) then
			beEffectExtraAttribute:add(beAttrList)
		end
	end
	-- 套装加成
	
	local ir_tbl0,ea_tbl0,ep_tbl0  = self:getSuitAttri(immuneAttribute.attribute, effectExtraAttribute, beEffectExtraAttribute)
	ir_tbl0 = ir_tbl0 or {}
	ea_tbl0 = ea_tbl0 or {}
	ep_tbl0 = ep_tbl0 or {}
	immuneAttribute:add(ir_tbl0)
	effectExtraAttribute:add(ea_tbl0)
	beEffectExtraAttribute:add(ep_tbl0)


	if self.xinfa and self.xinfa.totalAttribute.attribute then 
		immuneAttribute:add(self.xinfa.totalAttribute.attribute)
	end
	
	local exp = 0
	for i = 1,9 do
		exp = exp + self.TianMing[i].exp 
		ir_tbl0 = self.TianMing[i].ir_tb or {}
		ea_tbl0 = self.TianMing[i].ea_tb or {}
		ep_tbl0 = self.TianMing[i].ep_tb or {}
		immuneAttribute:add(ir_tbl0)
		effectExtraAttribute:add(ea_tbl0)
		beEffectExtraAttribute:add(ep_tbl0)
	end
	--天命成就属性
	local ir_tbl0, ea_tbl0, ep_tbl0, power = DesTinyMissionData:getTianMingAchievementAttr(exp)
	ea_tbl0 = ea_tbl0 or {}
	ep_tbl0 = ep_tbl0 or {}
	immuneAttribute:add(ir_tbl0)
	effectExtraAttribute:add(ea_tbl0)
	beEffectExtraAttribute:add(ep_tbl0)
	local ir_tbl0, ea_tbl0, ep_tbl0 ,power,list= DesTinyAchievementData:getDesTinyAchievementAttributeByTianMingList(self.TianMing)
	immuneAttribute:add(ir_tbl0)
	effectExtraAttribute:add(ea_tbl0)
	beEffectExtraAttribute:add(ep_tbl0)

	return immuneAttribute.attribute,effectExtraAttribute.attribute,beEffectExtraAttribute.attribute
end

function CardRole:getIndexExtAttributeByFightType(fight_type,index,attr_type)
	local immuneAttribute = EffectExtraData:new()
	local effectExtraAttribute = EffectExtraData:new()
	local beEffectExtraAttribute = EffectExtraData:new()

	immuneAttribute:setAddAttData(self.immuneAttribute.totalAttribute)
	effectExtraAttribute:setAddAttData(self.effectExtraAttribute.totalAttribute)
	beEffectExtraAttribute:setAddAttData(self.beEffectExtraAttribute.totalAttribute)

	local posInStrategy = AssistFightManager:checkIsStrategyMemberByFightType( self.gmId,fight_type )
	--判断是否上阵
	if posInStrategy ~= 0 then
		local ir_tbl0,ee_tbl0,ep_tbl0 = AssistFightManager:getAchieveTotalExtAttr()
		ir_tbl0 = ir_tbl0 or {}
		ee_tbl0 = ee_tbl0 or {}
		ep_tbl0 = ep_tbl0 or {}
		immuneAttribute:add(ir_tbl0)
		effectExtraAttribute:add(ee_tbl0)
		beEffectExtraAttribute:add(ep_tbl0)
		---------------------------------------------------------------
		ee_tbl0,ep_tbl0 = RedPacketManager:getAcheivExtAttri()
		ee_tbl0 = ee_tbl0 or {}
		ep_tbl0 = ep_tbl0 or {}
		effectExtraAttribute:add(ee_tbl0)
		beEffectExtraAttribute:add(ep_tbl0)
		---------------------------------------------------------------
		local cardStrategy = StrategyCardManager:getStrategyCardByStrategyType(fight_type)
		if cardStrategy then
            --阵法星级加成,判断是否在阵位上
			local isInPos, ir_tbl0,ea_tbl0,ep_tbl0 = cardStrategy:getTotalExtAttr(self.pos)
			--基础属性上阵就加,特殊属性只加在阵位上
			ir_tbl0 = ir_tbl0 or {}
			immuneAttribute:add(ir_tbl0)
			if (isInPos == true) then
				ea_tbl0 = ea_tbl0 or {}
				ep_tbl0 = ep_tbl0 or {}
				effectExtraAttribute:add(ea_tbl0)
				beEffectExtraAttribute:add(ep_tbl0)
			end
			--阵法深研加成
			local isInPos, ea_tbl0, ep_tbl0 = cardStrategy:getShenYanEffectAttr(self.pos)
			if (isInPos == true) then
				ea_tbl0 = ea_tbl0 or {}
				ep_tbl0 = ep_tbl0 or {}
				effectExtraAttribute:add(ea_tbl0)
				beEffectExtraAttribute:add(ep_tbl0)
			end
		end
		--帮派成就属性
		local giveAchievementAttr, beAttrList, power, effectAttrList = FactionJiShiTangManager:getGiveAchievementAttr(fight_type)
		if (giveAchievementAttr) then
			immuneAttribute:add(giveAchievementAttr)
		end
		if (effectAttrList) then
			effectExtraAttribute:add(effectAttrList)
		end
		if (beAttrList) then
			beEffectExtraAttribute:add(beAttrList)
		end
	end
	-- 套装加成
	local ir_tbl0,ea_tbl0,ep_tbl0  = self:getSuitAttri(immuneAttribute.attribute, effectExtraAttribute, beEffectExtraAttribute)
	ir_tbl0 = ir_tbl0 or {}
	ea_tbl0 = ea_tbl0 or {}
	ep_tbl0 = ep_tbl0 or {}
	immuneAttribute:add(ir_tbl0)
	effectExtraAttribute:add(ea_tbl0)
	beEffectExtraAttribute:add(ep_tbl0)

	if self.xinfa and self.xinfa.totalAttribute.attribute then 
		immuneAttribute:add(self.xinfa.totalAttribute.attribute)
	end

	if attr_type == EnumFightAttributeType.Immune then
		return immuneAttribute:getAttribute(index)
	elseif attr_type == EnumFightAttributeType.Effect_extra then
		return effectExtraAttribute:getAttribute(index)
	elseif attr_type == EnumFightAttributeType.Be_effect_extra then
		return beEffectExtraAttribute:getAttribute(index)
	end
	return 0
end

function CardRole:RefreshBookAttrAdd()
	self.bookAttrAdd = {}
	for k,v in pairs(BookManager.bookBag) do
		if v.roleID == self.gmId then
			local bookResData = BookConfig:objectByID(v.resID)
		    if bookResData ~= nil then
		        local attribute = bookResData.attribute
		        local currAdd = self.bookAttrAdd[attribute] or 0
		    	self.bookAttrAdd[attribute] = currAdd + v.attrAdd
		    else
		    	assert(false)
		    end
		end
	end

	self:updateTotalAttr()
end

function CardRole:RefreshEquipment( ... )
	self.equipAttribute:clear()
	self.equipExtraPower = 0
	local function cmp( x , y , tbl )
		return x+ y
	end
	-- for v in self:getEquipment():iterator() do
	-- 	self.equipAttribute:doMathAttData(v:GetTotalAttrArray(),cmp)
	-- end
	--self.equipAttribute:refreshRoleAttrBypercent(self)
	for v in self:getEquipment():iterator() do
		self.equipExtraPower = self.equipExtraPower + v:getExtraPower()
		self.equipAttribute:doMathAttData(v:getAttrWithOutGem(),cmp)
	end

	self.effectExtraAttribute:getEquipAttribute():clear()
	self.beEffectExtraAttribute:getEquipAttribute():clear()	
	self.immuneAttribute:getEquipAttribute():clear()
	
	self.equipAttribute:refreshBypercent()
	for v in self:getEquipment():iterator() do
		self.equipAttribute:setAddAttData(v:getAttrWithGem())

		self.immuneAttribute:getEquipAttribute():setAddAttData(v.immuneAttribute)
		self.effectExtraAttribute:getEquipAttribute():setAddAttData(v.effectExtraAttribute)
		self.beEffectExtraAttribute:getEquipAttribute():setAddAttData(v.beEffectExtraAttribute)
	end
	self.effectExtraAttribute:updateAttribute()

	self.immuneAttribute:updateAttribute()
	
	self.beEffectExtraAttribute:updateAttribute()
	
	self:updateTotalAttr()
end

function CardRole:refreshMartial(...)
	self.martialAttribute:clear()
	for i = 1,6 do
		local martial = self.martialList[i]
		if martial then
			local attributeTable 	= martial.template:getAttributeTable()
			local newAttributeTable = {}
			for i,v in pairs(attributeTable) do
				v = v + math.floor(v*martial.enchantLevel*0.1)
				newAttributeTable[i] = v
			end

			self.martialAttribute:add(newAttributeTable)
		end
	end
	self:updateTotalAttr()
end

function CardRole:AddEquipment( equip )
	self:getEquipment():AddEquipment(equip)
	equip.equip = self.id

	for v in self:getEquipment():iterator() do
		v:UpdateAttr()
	end

	self:RefreshEquipment()
end

function CardRole:DelEquipment( equip )
	self:getEquipment():DelEquipment(equip)

	for v in self:getEquipment():iterator() do
		v:UpdateAttr()
	end
	equip:UpdateAttr()
	
	self:RefreshEquipment()
end

function CardRole:DelEquipmentBygmid(gmid)
	local equip = EquipmentManager:getEquipByGmid(gmid)
	if equip then
		self:DelEquipment( equip )
	end
end

function CardRole:UpdatePower()
	if CardRoleManager.freshLock == true then
		return
	end
	self:updateTotalAttr()
end

function CardRole:getpower( )
	return self.power
end
function CardRole:getTotalRoleExp()
	return LevelData:getTotalRoleExp( self.level ) + self.curExp
end
function CardRole:getBigImagePath()
	return self.bigTextrueName
end

function CardRole:getHeadPath()
	return self.head
end

function CardRole:getIconPath()
	return self.icon
end
function CardRole:getOutline()
	return self.outlineArr
end

function CardRole:getUpstarNeedSoulNum()
	-- if self.upstar_need_soul_num_arr[self.starlevel + 1] then
	-- 	return tonumber(self.upstar_need_soul_num_arr[self.starlevel + 1]) 
	-- end
	local item = self.upstar_need_soul_num_list:getObjectAt(self.starlevel+1)
	if item then
		return item.soul_num
	end
	return 0;
end

function CardRole:getHaveSoulNum()
	local soul = BagManager:getItemById(self.soul_card_id );
    if soul then
        return soul.num;
    end
    return 0;
end

function CardRole:getIsMainPlayer()
	return self.isMainPlayer;
end

function CardRole:getChangSoulNum()
	local num = self.merge_card_num
	-- for i=1,self.starlevel do
	-- 	num = num + tonumber(self.upstar_need_soul_num_arr[i])
	-- end
	for i=1,self.starlevel do
		local item = self.upstar_need_soul_num_list:getObjectAt(i)
		if item then
			num = num + item.soul_num
		end
	end
	return num
end
function CardRole:getStarSoulNum()
	local num = 0
	-- for i=1,self.starlevel do
	-- 	num = num + tonumber(self.upstar_need_soul_num_arr[i])
	-- end
	for i=1,self.starlevel do
		local item = self.upstar_need_soul_num_list:getObjectAt(i)
		if item then
			num = num + item.soul_num
		end
	end	
	return num
end
--[[
获取当前可以升级的穴位索引
]]
function CardRole:getCurrentAcupointIndex()
	local configure = MeridianConfigure:objectByID(self.id)
	local alen = configure:acupointLength()
	local acupintInfo = nil
	local minLevelIndex = nil
	for i = 1,alen do
		acupointInfo = self.acupointList[i]
		if not acupointInfo then
			-- print("CardRole:getCurrentAcupointIndex : ",i)
			return i
		end
		if minLevelIndex then
			if self.acupointList[i-1].level > acupointInfo.level then
				minLevelIndex = i
			end
		else
			minLevelIndex = 1
		end
	end
	return minLevelIndex
end

function CardRole:SetAcupointInfo(acupointInfo)

	local pos = acupointInfo.position
	if self.acupointList[pos] == nil then
		self.acupointList[pos] = {}
	end

	self.acupointList[pos].level =  acupointInfo.level
	self.acupointList[pos].position = pos
	self.acupointList[pos].breachLevel = acupointInfo.breachLevel


	self:RefresAcuPointAttrAdd()
end

function CardRole:RefresAcuPointAttrAdd()
	self.acupointAttrAdd = {}
	local configure = MeridianConfigure:objectByID(self.id)
	-- print("acupoint configure : ",configure)
	for k,acupointInfo in pairs(self.acupointList) do
		if acupointInfo then
			if acupointInfo.breachLevel == nil then
				acupointInfo.breachLevel = 0
			end
			local key = configure:getAttributeKey(k)
			local info = AcupointBreachData:getData( key, acupointInfo.breachLevel )
			local value = info.value * acupointInfo.level
			
			self.acupointAttrAdd[key] = value
		end
	end

	self:updateTotalAttr()
end

function CardRole:GetAcupointInfo(pos)
	-- print('self.acupointList = ',self.acupointList)
	if pos == nil then
		return nil
	else
		return self.acupointList[pos]
	end
end

--设置角色品质
function CardRole:setQuality( quality )
	self.quality = quality				--品质
	-- if (self.quality == 7) then
	-- 	self.maxStar = 15
	-- end
	self.upstar_need_soul_num_list:clear()
	self.upstar_need_soul_num_list = RoleTalentData:GetRoleStarInfoByRoleId( self.id , self.quality)
end

--设置角色星级属性等级，
function CardRole:setStarlevel( starlevel )
	if self.starlevel == starlevel then
		return
	end

	self.starlevel = starlevel

	self:updateStarLevelAttr()
	self:updateSkillAttr()
	self:updateTotalAttr()
end

--设置角色星级属性经验
function CardRole:setStarexp( starexp )
	self.starexp = starexp				--星级经验
end

function CardRole:setSkillStarLevel(skillStarLevel)
	if self.skillStarLevel == skillStarLevel then
		return
	end	
    
	self.skillStarLevel = skillStarLevel
	self:updateStarLevelAttr()
	self:updateSkillAttr()
	self:updateTotalAttr()
end


function CardRole:getPowerByFightType(fightType)

	if self.totalAttributeByType[fightType] == nil then
		return self.power
	end
	if AssistFightManager:isinStrategyList( fightType,self.gmId ) == false then
		self.totalAttributeByType[fightType] = nil
		return self.power
	end
	local power = self.totalAttributeByType[fightType]:getPower()
	if self.spellPower then
		power = power +self.spellPower
	end

	local qihePower = 0
	local attrList,subAttrList = AssistFightManager:getQihePreviewInfo(fightType)
	if subAttrList then
		for k,v in pairs(subAttrList) do
			qihePower = qihePower + v.power
		end
	end

	local cardStrategy = StrategyCardManager:getStrategyCardByStrategyType(fightType)
	if cardStrategy then		
		local posInStrategy = AssistFightManager:checkIsStrategyMemberByFightType( self.gmId,fightType )
		if (posInStrategy ~= 0) then
			local des,power = cardStrategy:getSkillDesAndPower(posInStrategy)
			local shenYanPower = cardStrategy:getShenYanPower(posInStrategy)
			qihePower = qihePower + power + shenYanPower
		end
	end

	local redPacketPower = 0
	local acheivAttriList,subAcheivAttrList,_,_,_ = RedPacketManager:getAcheivAttri()
	if subAcheivAttrList then
		for k,v in pairs(subAcheivAttrList) do
			redPacketPower = redPacketPower + v
		end
	end
	--帮派成就属性
	local giveAchievementAttr, beAttrList, jishiPower = FactionJiShiTangManager:getGiveAchievementAttr(fightType)
	--增加修炼场战斗力
	local factionSkill = self.factionPractice or {}
	for k,v in pairs(factionSkill) do
		power = power + v.power
	end
	power = power + (jishiPower or 0)
	power = power + qihePower
	power = power + redPacketPower
	power = power + self.qimenPower
	power = power + self.skyBookPower
	power = power + self.equipExtraPower + self.suitPower
	power = power + self.TianMingPower
	return power
end

--清除缘分
function CardRole:clearFate()
	self.fateMap ={}
	self.fateAttribute:clear()
	self.fateAttributeForQihe:clear()
	--清除缘分时也要刷新属性
	self:updateTotalAttr()
end

--获取缘分的状态
function CardRole:getFateStatusByFightType(fightType,fateId)
	-- print("self.fateStatesByType = ",self.fateStatesByType)
	if self.fateStatesByType == nil then
		return false
	end
	if self.fateStatesByType[fightType] == nil then
		if self.fateStatesByType[100] == nil then
			return false
		end
		return self.fateStatesByType[100][fateId]
	end
	if AssistFightManager:isinStrategyList( fightType,self.gmId ) == false then
		self.fateStatesByType[fightType] = nil

		return self.fateStatesByType[100][fateId]
		-- self:updateFateByList({},fightType)
		-- if self.fateStatesByType == nil or self.fateStatesByType[fightType] == nil then
		-- 	return false
		-- end
	end
	if self.fateStatesByType[fightType][fateId] == true then
		return true
	else
		return false
	end
end
--获取缘分的状态
function CardRole:getFateStatus(fateId)
	if self.fateMap[fateId] == true then
		return true
	else
		return false
	end
end

function CardRole:checkCommondFate( fate,battleType )
	local commondTargetList = fate:getCommondTarget()
	if #commondTargetList >= 1 then
		for _,target in pairs(commondTargetList) do
			if self:getTargetStatus(target,battleType) == true then
				if target.fateType == 1 then
					return true,false
				else
					return true,true
				end
			end
		end
	end
	return false
end

--更新缘分
function CardRole:updateFate(showMessage,brushAttri)
	--先清除现有缘分
	-- self.fateMap ={}
	if showMessage == nil then
		showMessage = false
	end

	self.fateStatesByType = self.fateStatesByType or {}
	self.fateStatesByType[100] = self.fateStatesByType[100] or {}

	-- print("CardRole:updateFate()  self.fateMap = ",self.fateMap)
	self.fateAttribute:clear()
	self.fateAttributeForQihe:clear()

	local battleType = 1 -- 普通1  血战2
	local inWar		 = false
	--如果自身不在战阵上则肯定没有任何缘分
	if BloodFightManager:bPlayerIsInBloodFighting() == true then
		inWar 		= BloodFightManager:getRoleByTemplateId(self.id)
		battleType 	= 2
	else
		inWar = StrategyManager:getRoleByTemplateId(self.id)
	end

	local fateArray = RoleFateData:getRoleFateById( self.id)
	if fateArray == nil then
		print("此人没有缘分  id == "..self.id)
		--by pck
		--self:updateQihe()
		return
	end

	for v in fateArray:iterator() do
		local targetList = v:gettarget()
		local status = true
		if #targetList == 0 then
			status = false
		end
		local isRoleFate = true
		for _,target in pairs(targetList) do
			if target.fateType == 1 then
				isRoleFate = false
			end
			if self:getTargetStatus(target,battleType) == true then
			else
				status = false
				isRoleFate = false
			end
		end
		if status == false then
			local _isRoleFate = nil
			status,_isRoleFate = self:checkCommondFate( v,battleType )
			if _isRoleFate then
				isRoleFate = _isRoleFate
			end
		end

		local fateItemInfo = FateManager:getFateItemInfo( self.id,v.id )
		if fateItemInfo then
			if fateItemInfo.forever or fateItemInfo.endTime >= MainPlayer:getNowtime() then
				status = true
				isRoleFate = true
			elseif fateItemInfo.endTime < MainPlayer:getNowtime() then
				FateManager:removeFateItemInfo( self.id,v.id )
			end
		end
		if status == true then
			if self.fateMap[v.id] ~= nil and self.fateMap[v.id] == false and showMessage then
				-- print(self.name.. "self.fateMap[v.id]  v.title = "..v.title.." vaule = ",self.fateMap[v.id])
				-- toastMessage("激活缘分 "..v.title)
				fateMessage(v.title,nil,nil,nil,true,"lua.uiconfig_mango_new.common.FateMessage")
			end
			self.fateMap[v.id] = true
			local attr_index , attr_num = v:getAttr()
			self.fateStatesByType[100][v.id] = true
			if isRoleFate then
				self.fateAttributeForQihe:addAttr(attr_index,attr_num)
				self.fateAttribute:addAttr(attr_index,attr_num)
			else
				self.fateStatesByType[100][v.id] = false
			end
		else
			self.fateMap[v.id] = false
			self.fateStatesByType[100][v.id] = false
		end
	end
	--布阵类不刷新主属性
	if brushAttri ~= false then
		self:updateTotalAttr()
	end
	--by pck
	--self:updateQihe()

	TFDirector:dispatchGlobalEventWith(CardRoleManager.updateFateMessage,{self.gmId})
end
--判断是否与物品有缘分
function CardRole:hasFate( fateType , fateId )
	local fateArray = RoleFateData:getRoleFateById( self.id)
	if fateArray == nil then
		print("此人没有缘分  id == "..self.id)
		return false
	end
	for v in fateArray:iterator() do
		local targetList = v:gettarget()
		for _,target in pairs(targetList) do
			if target.fateType == fateType and target.fateId == fateId then
				return true
			end
		end
		local commondTargetList = v:getCommondTarget()
		for _,target in pairs(commondTargetList) do
			if target.fateType == fateType and target.fateId == fateId then
				return true
			end
		end
	end
	return false
end

--更新技能属性加成
function CardRole:updateSkillAttr()
	self.skillAttribute:clear()
	self.effectExtraAttribute:getSkillAttribute():clear()
	self.immuneAttribute:getSkillAttribute():clear()
	self.beEffectExtraAttribute:getSkillAttribute():clear()

	self.spellPower = 0
	if self:getIsMainPlayer() then
		for i,spell in pairs(self.leadingRoleSpellList) do
			if spell.choice then

				local skillLevelInfo = SkillLevelData:getInfoBySkillAndLevel( spell.spellId.skillId , spell.spellId.level);
	            --<<<<<<<<<<<<<<<<<<<技能替换判断
	            local replaceSkillId = CardRoleManager:isSkillReplace(self.id, self.starlevel,spell.spellId.skillId, nil, self.quality)
	            if replaceSkillId ~= spell.spellId.skillId then
	                skillLevelInfo = SkillLevelData:getInfoBySkillAndLevel( replaceSkillId , spell.spellId.level);
	            end       
	            -->>>>>>>>>>>>>>>>>>>>						
				self.spellPower =  self.spellPower + skillLevelInfo.power
				if skillLevelInfo.type ~= EnumSkillType.BeiDongZengYiGuangHuan and skillLevelInfo.type ~= EnumSkillType.BeiDongChiJianGuangHuan  then

					-- local attr_add_arr = string.split(skillLevelInfo.attr_add, '|');
					for k,v in pairs(skillLevelInfo.attr_add) do
						self.skillAttribute:addAttr(k,v)
					end

					for k,v in pairs(skillLevelInfo.immune) do
						self.immuneAttribute:getSkillAttribute():addAttr(k,v)
					end
					for k,v in pairs(skillLevelInfo.effect_extra) do
						self.effectExtraAttribute:getSkillAttribute():addAttr(k,v)
					end
					for k,v in pairs(skillLevelInfo.be_effect_extra) do
						self.beEffectExtraAttribute:getSkillAttribute():addAttr(k,v)
					end
				end
			end
		end
	else
		for i,levelInfo in pairs(self.spellLevelIdList) do
			local skillLevelInfo = SkillLevelData:getInfoBySkillAndLevel( levelInfo.skillId , levelInfo.level);
			if (skillLevelInfo) then
				--<<<<<<<<<<<<<<<<<<<技能替换判断
				local skillStarLevel = nil
				if (skillLevelInfo.hidden_skill == 3) then
					--神技
					skillStarLevel = self.skillStarLevel
				end
				local replaceSkillId = CardRoleManager:isSkillReplace(self.id, self.starlevel, levelInfo.skillId, skillStarLevel, self.quality)
				if replaceSkillId ~= levelInfo.skillId then
					skillLevelInfo = SkillLevelData:getInfoBySkillAndLevel( replaceSkillId , levelInfo.level);
				end      
				-->>>>>>>>>>>>>>>>>>>>
				if skillLevelInfo then
					self.spellPower =  self.spellPower + skillLevelInfo.power
				end
				if skillLevelInfo.type ~= EnumSkillType.BeiDongZengYiGuangHuan and skillLevelInfo.type ~= EnumSkillType.BeiDongChiJianGuangHuan then
					-- local attr_add_arr = string.split(skillLevelInfo.attr_add, '|');

					for k,v in pairs(skillLevelInfo.attr_add) do
						self.skillAttribute:addAttr(k,v)
					end
					for k,v in pairs(skillLevelInfo.immune) do
						self.immuneAttribute:getSkillAttribute():addAttr(k,v)
					end
					for k,v in pairs(skillLevelInfo.effect_extra) do
						self.effectExtraAttribute:getSkillAttribute():addAttr(k,v)
					end
					for k,v in pairs(skillLevelInfo.be_effect_extra) do
						self.beEffectExtraAttribute:getSkillAttribute():addAttr(k,v)
					end
				end
			else
				toastMessage("skillId: "..levelInfo.skillId.."  level: ".. levelInfo.level)
			end
		end
	end
	
	self:updateTotalAttr()
	self.effectExtraAttribute:updateAttribute()
	self.immuneAttribute:updateAttribute()
	self.beEffectExtraAttribute:updateAttribute()
end

--更新侠客升星属性加成
function CardRole:updateStarLevelAttr()
	-- self.starLevelAttributeTable = {}
	-- self.starLevelPercentTable = {}

	-- local roleInfoList = RoleTalentData:GetRoleStarInfoByRoleId( self.id )

	-- for i=1,self.starlevel do
	-- 	local item = roleInfoList:getObjectAt(i)
	-- 	if item ~= nil then
	-- 		if item.type == 1 then --属性加成
	-- 			local attr_buffer = string.split(item.expression,'|')
	-- 			for j=1,#attr_buffer do

	-- 				local activity = string.split(attr_buffer[j],'_')
	-- 				local attr_index = tonumber(activity[1])
	-- 				local attr_value = tonumber(activity[2])

	-- 				if attr_index < 18 then--18之前加固定值
	-- 					if self.starLevelAttributeTable[attr_index] then
	-- 						self.starLevelAttributeTable[attr_index] = self.starLevelAttributeTable[attr_index] + attr_value
	-- 					else 
	-- 						self.starLevelAttributeTable[attr_index] = attr_value
	-- 					end
	-- 				else
	-- 					if self.starLevelPercentTable[attr_index] then
	-- 						self.starLevelPercentTable[attr_index] = self.starLevelPercentTable[attr_index] + attr_value
	-- 					else 
	-- 						self.starLevelPercentTable[attr_index] = attr_value
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- end
	--close 2015-10-12 14:19:46 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑

	self.starupAttribute:clear()
	local roleInfoList = RoleTalentData:GetRoleStarInfoByRoleId( self.id, self.quality )
	for i=1,self.starlevel do
		local item = roleInfoList:getObjectAt(i)
		if item ~= nil then
			if item.type == 1 then --属性加成
				local attr_buffer = string.split(item.expression,'|')
				for j=1,#attr_buffer do

					local activity = string.split(attr_buffer[j],'_')
					local attr_index = tonumber(activity[1])
					local attr_value = tonumber(activity[2])

					self.starupAttribute:addAttr(attr_index,attr_value)

				end
			end
		end
	end

	local supperInfo = RoleTalentData:GetRoleSupperStarInfoByRoleId(self.id)
	for i=1,self.skillStarLevel do
		local item = supperInfo[i]
		if item ~= nil then
			if item.type == 1 then --属性加成
				local attr_buffer = string.split(item.expression,'|')
				for j=1,#attr_buffer do
					local activity = string.split(attr_buffer[j],'_')
					local attr_index = tonumber(activity[1])
					local attr_value = tonumber(activity[2])
					self.starupAttribute:addAttr(attr_index,attr_value)
				end
			end
		end
	end
end

--获取缘分目标状态（是否存在） battleType == 1 普通战阵 2 血战
function CardRole:getTargetStatus( target, battleType)
	--1、角色；2、装备；3、秘籍；4、道具
	if target.fateType == 1 then
		local StrategyFate = StrategyManager
		if battleType == 1 then
			StrategyFate = StrategyManager
		elseif battleType == 2 then
			StrategyFate = BloodFightManager
		end

		local selfInWar = StrategyFate:getRoleByTemplateId(self.id)
		if not selfInWar then
			return false
		end

		local fateRole =  StrategyFate:getRoleByTemplateId(target.fateId)
		if fateRole then
			return true
		else
			-- 在缘分列表里面找找
			if battleType == 1 then
				local role =  self:getRoleByTemplateId(target.fateId)
				if role ~= nil then
					return true
				end
			end
			return false
		end
	elseif  target.fateType == 2 then
		for i=1,5 do
			local equip = self.equipment:GetEquipByType(i)
			if equip and equip.id == target.fateId then
				return true
			end
		end
		return false
	elseif target.fateType == 3 then
		for k,v in pairs(BookManager.bookBag) do
			if v.roleID == self.gmId and v.resID == target.fateId then
				return true
			end
		end
		return false
	elseif target.fateType == 4 then
		return false
	end
	return false 
end

--[[
检测是否可以装备武学
@martialTemplate 武学模版
@position 位置，从1开始
]]
function CardRole:isCanEquipMartial(martialTemplate,position)
	if self.martialList[position] ~= nil then
		--toastMessage("该位置已经装备了武学，不可重复装备")
		toastMessage(localizable.CardRole_tip1)
		return false
	end

	local martialRoleConfigure = MartialRoleConfigure:findByRoleIdAndMartialLevel(self.id,self.martialLevel)
	if martialRoleConfigure == nil then
		--toastMessage("找不到对应的角色武学配置 : [" .. self.id .. "] , [" ..self.martialLevel .. "]")
		toastMessage(stringUtils.format(localizable.CardRole_tip2, self.id, self.martialLevel))
		return false
	end

	local martialTable = martialRoleConfigure:getMartialTable()
	if not martialTable then
		--toastMessage("不可装备，Martial table is nil or not found")
		toastMessage(localizable.CardRole_tip3)
		return false
	end

	if martialTable[position] ~= martialTemplate.id then
		--toastMessage("武学id与配置不匹配.")
		toastMessage(localizable.CardRole_tip4)
		return false
	end
	return true
end

--[[
尝试装备武学，经过本地校验，如果有效则会请求服务器进行武学装备
@martialTemplate 武学模版
@position 位置，从1开始
]]
function CardRole:tryEquipMartial(martialTemplate,position)
	MartialManager:requestEquip(self,martialTemplate,position,false)
end

--[[
在角色实力身上直接添加武学
@martialTemplate 武学模版
@position 位置，从1开始
]]
function CardRole:addMartial(martialTemplate,position)
	local martialInstance = require('lua.gamedata.hold.MartialInstance'):new(martialTemplate)
	martialInstance:setTemplate(martialTemplate)
	martialInstance.position = position
	self.martialList[position] = martialInstance
	martialInstance.roleId = self.gmId
	return martialInstance
end

--[[
通过武学id查找装备到角色身上的武学实力
@martialId 武学id
@return 因为同一种武学可能同时装备多个，所以返回的事table表格
]]
function CardRole:findMartialById(martialId)
	local result = {}
	for i,value in pairs(self.martialList) do
		if value then
			if value.template.id == martialId then
				result[i] = value
			end
		end
	end
	return result
end

--[[
通过武学装备位置查找武学实例
@position 武学装备位置
@return 武学实例，找不到返回nil
]]
function CardRole:findMartialByPosition(position)
	-- return self[position]
	return self.martialList[position]
end

--是否有技能可以升级
function CardRole:isSkillCanUp()
    local skillMaxLevel = MainPlayer:getRoleSkillMax()
	if self:getIsMainPlayer() then
		for i,spell in pairs(self.leadingRoleSpellList) do
			if spell.choice then
				if spell.spellId.level < self.level and spell.spellId.level < skillMaxLevel then
					return true
				end
			end
		end
	else
		for i,levelInfo in pairs(self.spellLevelIdList) do
			if levelInfo.level and (levelInfo.level < self.level  and levelInfo.level < skillMaxLevel) then
				return true
			end
		end
	end
	return false
end

--是否有技能可以升级并且满足消耗
function CardRole:isSkillCanEnoughUp()
    local skillMaxLevel = ConstantData:objectByID("RoleSkill.Max.Level").value or 150
	if self:getIsMainPlayer() then
		for i,spell in pairs(self.leadingRoleSpellList) do
			if spell.choice then
				if spell.spellId.level < self.level and spell.spellId.level < skillMaxLevel then
					local levelInfo = SkillLevelData:objectByID(spell.spellId);
					if MainPlayer:isEnoughCoin(levelInfo.uplevel_cost, false) and MainPlayer:isEnoughTimes(EnumRecoverableResType.SKILL_POINT,1,false,false) then
						return true
					end
				end
			end
		end
	else
		for i,levelInfo in pairs(self.spellLevelIdList) do
			if levelInfo.level and (levelInfo.level < self.level  and levelInfo.level < skillMaxLevel) then
				local levelInfo = SkillLevelData:objectByID(spell.spellId);
				if MainPlayer:isEnoughCoin(levelInfo.uplevel_cost, false) and MainPlayer:isEnoughTimes(EnumRecoverableResType.SKILL_POINT,1,false,false) then
					return true
				end
			end
		end
	end
	return false
end
function CardRole:getSpellAllCost()
	local cost = 0
	local costPoint = 0
	if self:getIsMainPlayer()  then
		for i,levelInfo in pairs(self.leadingRoleSpellList) do
			for i=1,levelInfo.spellId.level - 1 do
				local info = SkillAttributeData:objectByID(i)
				if info then
					cost = cost + info.uplevel_cost
				end
			end
		end
	else
		for i,levelInfo in pairs(self.spellLevelIdList) do

			for i=1,levelInfo.level - 1 do
				local info = SkillAttributeData:objectByID(i)
				if info then
					cost = cost + info.uplevel_cost
					costPoint = costPoint + 1
				end
			end
		end
	end
	return cost,costPoint
end
function CardRole:getMeridianAllCostByLevel( level )
	local cost = 0
	for i=1,level do
		local info = MeridianConsume:objectByID(i)
		if info then
			cost = cost + info.cost
		end
	end
	return cost
end

function CardRole:getMeridianAllCost()
	local cost = 0
	for k,acupointInfo in pairs(self.acupointList) do
		if acupointInfo then
			cost = cost + self:getMeridianAllCostByLevel(acupointInfo.level)
		end
	end
	return cost
end
function CardRole:getMeridianBreachAllCost()
	local cost = 0
	local configure = MeridianConfigure:objectByID(self.id)
	for k,acupointInfo in pairs(self.acupointList) do
		if acupointInfo then
			local key = configure:getAttributeKey(k)
			cost = cost + AcupointBreachData:getConsumeMinByLevel(key ,acupointInfo.breachLevel)
		end
	end
	return cost
end

function CardRole:reBirth()
	self.curExp = 0
	self:setLevel(1)
	-- self.level = 1;
	self.starlevel = 0;

	self.skillStarLevel = 0;

	self.martialList		= {}
	self.martialLevel		= 1							--武学等级，角色默认1级

	self.acupointList 	= {}
	self.acupointAttrAdd = {}
	self.bookAttrAdd = {}
	if self:getIsMainPlayer() then
		self.leadingRoleSpellList[1].spellId.level = 1
		self.leadingRoleSpellList[1].choice = true
		for i=2,9 do
			self.leadingRoleSpellList[i] = nil
		end
	else
		self.spellLevelIdList[1].level = 1
		for i=2,4 do
			self.spellLevelIdList[i] = nil
		end
		     
		if self.quality >= 6  then 
			self.spellLevelIdList[2] ={}            
			self.spellLevelIdList[2].level = 1
			
			local spellInfo =  self.spellInfoList:objectAt(4)
			self.spellLevelIdList[2].skillId = spellInfo.id
		end
        
	end

	print("self.spellLevelIdList = ",self.spellLevelIdList)
	self:setFactionPractice({})
	self:updateSkillAttr()
	self:updateStarLevelAttr()
	self:refreshFactionPractice()
	self:refreshMartial()
	-- self:updateTotalAttr()
end

function CardRole:replaceSkillList()

end



--获取缘分目标状态（是否存在）
function CardRole:getRoleFateStatusByList( list,target)
	--1、角色；2、装备；3、秘籍；4、道具
	if target.fateType ~= 1 then
		return false
	end
	local inWar = false
	-- for i=1,9 do
	-- 	if list[i] and list[i] == self.gmId then
	-- 		inWar = true
	-- 	end
	-- end
	-- if inWar == false then
	-- 	return false
	-- end

	local fateRole = CardRoleManager:getRoleById( target.fateId )
	if fateRole then
		for i=1,19 do
			if list[i] and list[i] == fateRole.gmId then
				return true
			end
		end
	end
	return false
end
--获取缘分目标状态（是否存在）
function CardRole:getRoleFateStatusByIdList( list,target)
	--1、角色；2、装备；3、秘籍；4、道具
	if target.fateType ~= 1 then
		return false
	end
	local inWar = false
	-- for i=1,9 do
	-- 	if list[i] and list[i] == self.gmId then
	-- 		inWar = true
	-- 	end
	-- end
	-- if inWar == false then
	-- 	return false
	-- end

	for i=1,19 do
		if list[i] and list[i] == target.fateId then
			return true
		end
	end
	return false
end

--获取缘分目标状态（是否存在
function CardRole:getTargetStatusWithOutRole( target)
	--1、角色；2、装备；3、秘籍；4、道具
	if target.fateType == 1 then
		return false
	end
	if  target.fateType == 2 then
		for i=1,5 do
			local equip = self.equipment:GetEquipByType(i)
			if equip and equip.id == target.fateId then
				return true
			end
		end
		return false
	elseif target.fateType == 3 then
		for k,v in pairs(BookManager.bookBag) do
			if v.roleID == self.gmId and v.resID == target.fateId then
				return true
			end
		end
		return false
	elseif target.fateType == 4 then
		return false
	end
	return false 
end

function CardRole:updateFateByList(list,fight_type)
	self.fateStatesByType = self.fateStatesByType or {}
	self.fateStatesByType[fight_type] = {}
	local attribute	= GameAttributeData:new()

	local fateArray = RoleFateData:getRoleFateById( self.id)
	if fateArray == nil then
		print("此人没有缘分  id == "..self.id)
		return
	end

	for v in fateArray:iterator() do
		local status = true
		local fateItemInfo = FateManager:getFateItemInfo(self.id,v.id)
		if fateItemInfo and (fateItemInfo.forever or fateItemInfo.endTime >= MainPlayer:getNowtime()) then
			status = true
		else
			if fateItemInfo and fateItemInfo.endTime < MainPlayer:getNowtime() then
				FateManager:removeFateItemInfo( self.id,v.id )
			end
			
			local targetList = v:gettarget()
			if #targetList == 0 then
				status = false
			end
			for _,target in pairs(targetList) do
				if target.fateType == 1 then
					if self:getRoleFateStatusByList(list,target) == false then
						status = false
					end
				else
					if self:getTargetStatusWithOutRole(target) == false then
						status = false
					end
				end
			end
			if status == false then
				status = self:checkCommondFateByList( v,list )
			end
		end
		if status == true then
			-- print(self.name.."fate == ",v)
			local attr_index , attr_num = v:getAttr()
			attribute:addAttr(attr_index,attr_num)
		end
		
		self.fateStatesByType[fight_type][v.id] = status
	end
	return attribute
end

function CardRole:checkCommondFateByList( fate,list )
	local commondTargetList = fate:getCommondTarget()
	if #commondTargetList >= 1 then
		for _,target in pairs(commondTargetList) do
			if target.fateType == 1 then
				if self:getRoleFateStatusByList(list,target) then
					return true
				end
			else
				if self:getTargetStatusWithOutRole(target) then
					return true
				end
			end
		end
	end
	return false
end


function CardRole:updateFateByIdListForShow(list,fight_type,showMessage)
	self.fateStatesByType = self.fateStatesByType or {}
	self.fateStatesByType[fight_type] = self.fateStatesByType[fight_type] or {}

	local fateArray = RoleFateData:getRoleFateById( self.id)
	if fateArray == nil then
		print("此人没有缘分  id == "..self.id)
		return
	end

	for v in fateArray:iterator() do
		local status = true
		local isRoleFate = true
		local fateItemInfo = FateManager:getFateItemInfo(self.id,v.id)
		if fateItemInfo and (fateItemInfo.forever or fateItemInfo.endTime >= MainPlayer:getNowtime()) then
			status = true
			isRoleFate = true
		else
			if fateItemInfo and fateItemInfo.endTime < MainPlayer:getNowtime() then
				FateManager:removeFateItemInfo( self.id,v.id )
			end
			local targetList = v:gettarget()
			if #targetList == 0 then
				status = false
			end
			for _,target in pairs(targetList) do
				if target.fateType == 1 then
					isRoleFate = false
					if self:getRoleFateStatusByIdList(list,target) == false then
						status = false
					end
				else
					if self:getTargetStatusWithOutRole(target) == false then
						status = false
						isRoleFate = false
					end
				end
			end
			if status == false then
				status = self:checkCommondFateByList( v,list )
			end

		end
		if status == true and not isRoleFate then
			-- print(self.name.."fate == ",v)
			-- print("status == true | self.fateStatesByType[fight_type][v.id] = ,",self.fateStatesByType[fight_type][v.id])
			if (self.fateStatesByType[fight_type][v.id] == nil or self.fateStatesByType[fight_type][v.id] == false) and showMessage then
				-- print(self.name.. "self.fateMap[v.id]  v.title = "..v.title.." vaule = ",self.fateMap[v.id])
				-- toastMessage("激活缘分 "..v.title)
				fateMessage(v.title,nil,nil,nil,true,"lua.uiconfig_mango_new.common.FateMessage")
			end
		end
		
		self.fateStatesByType[fight_type][v.id] = status
	end
	return
end

function CardRole:updateFateByIdList(list,fight_type,showMessage)
	self.fateStatesByType = self.fateStatesByType or {}
	self.fateStatesByType[fight_type] = self.fateStatesByType[fight_type] or {}
	local attribute	= GameAttributeData:new()

	local fateArray = RoleFateData:getRoleFateById( self.id)
	if fateArray == nil then
		print("此人没有缘分  id == "..self.id)
		return
	end

	for v in fateArray:iterator() do
		local status = true
		local fateItemInfo = FateManager:getFateItemInfo(self.id,v.id)
		if fateItemInfo and (fateItemInfo.forever or fateItemInfo.endTime >= MainPlayer:getNowtime()) then
			status = true
		else
			if fateItemInfo and fateItemInfo.endTime < MainPlayer:getNowtime() then
				FateManager:removeFateItemInfo( self.id,v.id )
			end
			local targetList = v:gettarget()
			if #targetList == 0 then
				status = false
			end
			for _,target in pairs(targetList) do
				if target.fateType == 1 then
					if self:getRoleFateStatusByIdList(list,target) == false then
						status = false
					end
				else
					if self:getTargetStatusWithOutRole(target) == false then
						status = false
					end
				end
			end
			if status == false then
				status = self:checkCommondFateByList( v,list )
			end
		end
		if status == true then
			-- print(self.name.."fate == ",v)
			local attr_index , attr_num = v:getAttr()
			attribute:addAttr(attr_index,attr_num)
		end
		self.fateStatesByType[fight_type][v.id] = status
	end
	return attribute
end

function CardRole:getPowerByList(list,fight_type)
	self.totalAttributeByType = self.totalAttributeByType or {}
	local attribute	= GameAttributeData:new()
	local fateAttribute	= GameAttributeData:new()
	local qiheAttribute = GameAttributeData:new()
	local zhuanjiAttribute = GameAttributeData:new()
	local jiayuanAttribute = GameAttributeData:new()
	local monthAttribute	= GameAttributeData:new()
	local redpacketAttribute = GameAttributeData:new()
	local japanIslandAttribute = GameAttributeData:new()
	local headPicFrameAttribute = GameAttributeData:new()
	local redPacketPower = 0
	local jishiPower = 0
	local strategyCardAttribute = GameAttributeData:new()
	local eudemonCardAttribute 	= GameAttributeData:new() --宠物
	local giveAchievementAttribute 	= GameAttributeData:new() --济世堂成就
	local spacielSkillPower = 0 --特殊技能所加的固定战斗力
	local isInArmy = false
	local posInStrategy = AssistFightManager:checkIsStrategyMemberByFightType( self.gmId,fight_type )
	if posInStrategy ~= 0 then
		isInArmy = true
		local attrList,subAttrList = AssistFightManager:getQihePreviewInfo(fight_type)
		for k,v in pairs(attrList) do
			qiheAttribute:addAttr(k,v)
		end
		local zhuanjiAttrList = IllustrationManager:getZhuanJiAllAttri()
		for k,v in pairs(zhuanjiAttrList) do
			zhuanjiAttribute:addAttr(k,v)
		end

		local jiayuanAttrList = QiyuManager:getJiayuanAttr()
		for k, v in pairs(jiayuanAttrList) do
			jiayuanAttribute:addAttr(k, v)
		end

		if subAttrList then
			for k,v in pairs(subAttrList) do
				spacielSkillPower = spacielSkillPower + v.power
			end
		end

		local cardStrategy = StrategyCardManager:getStrategyCardByStrategyType(fight_type)
		if cardStrategy then
			local baseAttr = cardStrategy:getTotalAttrArray()
			strategyCardAttribute:setAddAttData(baseAttr)
			local starAttr = cardStrategy:getPositonAttributeByRolePos(posInStrategy)
			local des,power = cardStrategy:getSkillDesAndPower(posInStrategy)
			local shenYanPower = cardStrategy:getShenYanPower(posInStrategy)
			if starAttr then
				strategyCardAttribute:setAddAttData(starAttr)
			end
			spacielSkillPower = spacielSkillPower + power + shenYanPower

		end

		local sendAttriList = RedPacketManager:getSendAttri()
		for k, v in pairs(sendAttriList) do
			redpacketAttribute:addAttr(k, v)
		end

		local acheivAttriList,subAcheivAttrList = RedPacketManager:getAcheivAttri()
		for k, v in pairs(acheivAttriList) do
			redpacketAttribute:addAttr(k, v)
		end

		local japAchieveAttriList = JapanIslandManager:getAcheivAttri()
		for k, v in pairs(japAchieveAttriList) do
			japanIslandAttribute:addAttr(k, v)
		end

		if subAcheivAttrList then
			for k,v in pairs(subAcheivAttrList) do
				redPacketPower = redPacketPower + v
			end
		end
		--宠物
		local eudemonId 	= EudemonManager:getEudemonByFightId(fight_type)
		local eudemonInfo 	= EudemonManager:getEudemonById(eudemonId)
		if (eudemonInfo) then
			eudemonCardAttribute:setAddAttData(eudemonInfo:getTeamAttribute())
		end
		--帮派成就属性
		local giveAchievementAttr, beAttrList, power = FactionJiShiTangManager:getGiveAchievementAttr(fight_type)
		if (giveAchievementAttr) then
			for attrId, attrValue in pairs(giveAchievementAttr) do
				giveAchievementAttribute:addAttr(attrId, attrValue)
			end
		end
		local hpfAttriTable = HeadPicFrameManager:getAttribute()
		for k, v in pairs(hpfAttriTable) do
			headPicFrameAttribute:addAttr(k, v)
		end
		
		jishiPower = power or 0
	end
	
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--

	attribute:clone(self.attribute)
	attribute:setAddAttData(self.martialAttribute)
	for k,v in pairs(self.bookAttrAdd) do
		attribute:addAttr(k,v)
	end
	
	for k,v in pairs(self.acupointAttrAdd) do
		attribute:addAttr(k,v)
	end
	attribute:setAddAttData(self.qimenAttribute)
	attribute:setAddAttData(self.skillAttribute)
	attribute:setAddAttData(self.starupAttribute)
	attribute:setAddAttData(self.lianTiAttribute)
	attribute:setAddAttData(self.qianxiuAttribute)
	
	--attribute:setAddAttData(self.skyBookAttribute)
	

	fateAttribute = self:updateFateByList(list,fight_type)
	attribute:setAddAttData(fateAttribute)
	
	attribute:setAddAttData(self.factionPracticeAttribute)
	attribute:setAddAttData(redpacketAttribute)
	attribute:setAddAttData(headPicFrameAttribute)
	attribute:setAddAttData(qiheAttribute)
	
	

	attribute:refreshBypercent()
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	--东瀛岛
	attribute:setAddAttData(japanIslandAttribute)
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	-- 装备属性
	self.equipAttribute:refreshBypercent()
	attribute:setAddAttData(self.equipAttribute)
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	-- 独立系统属性
	-- 百分比自己算自己的
	
	self.skyBookAttribute:refreshBypercent()
	attribute:setAddAttData(self.skyBookAttribute)
	attribute:setAddAttData(self.xinFaAttribute)
	attribute:setAddAttData(self.TianMingAttribute)
	zhuanjiAttribute:refreshBypercent()
	attribute:setAddAttData(zhuanjiAttribute)
	jiayuanAttribute:refreshBypercent()
	attribute:setAddAttData(jiayuanAttribute)
	
	if self.isMainPlayer then
		local vip_add = VipRuleManager:addMainPlayerAttr()
		if vip_add ~= 0 then
			attribute:addAttr(EnumAttributeType.Force,vip_add)
			attribute:addAttr(EnumAttributeType.Magic,vip_add)
		end
	end
		

	self.monthAttribute:clear()
	if MonthCardManager:getCardState() ~= self.monthState then
		self.monthState = MonthCardManager:getCardState()
		self:calculationMonthAttr()
	end
	self:updateMonthCard()
	self.monthAttribute:refreshBypercent()
	attribute:setAddAttData(self.monthAttribute)

	if isInArmy  then
		monthAttribute = self:calculationMonthAttrInArmy()
		monthAttribute:refreshBypercent()
		attribute:setAddAttData(monthAttribute)
	end

	if isInArmy  then
		--strategyCardAttribute:refreshBypercent()
		attribute:setAddAttData(strategyCardAttribute)
		-- eudemonCardAttribute:refreshBypercent()
		attribute:setAddAttData(eudemonCardAttribute)
	end
	attribute:setAddAttData(giveAchievementAttribute)
	
	attribute:refreshBypercent()
	-- 套装加成
	-- self:updataSuitAdd()
	local suitAttribute = self:getSuitPowerAndAttri(attribute)
	attribute:setAddAttData(suitAttribute)
	attribute:refreshBypercent()
	attribute:updatePower()
	
	
	local power = attribute:getPower()
	if self.spellPower then
		power = power +self.spellPower
	end

	--增加修炼场战斗力
	local factionSkill = self.factionPractice or {}
	for k,v in pairs(factionSkill) do
		power = power + v.power
	end

	--契合固定战斗力
	power = power + spacielSkillPower + redPacketPower

	
	power = power + self.skyBookPower
	power = power + jishiPower
	power = power + self.equipExtraPower + self.suitPower
	power = power + self.TianMingPower

	
	
	self.totalAttributeByType[fight_type] = attribute
	return power

end
--删掉所有增益,只计算自己本身侠客的加成
function CardRole:getNotTeamPowerByIdList(list,fight_type)

	self.totalAttributeByType = self.totalAttributeByType or {}

	local attribute	= GameAttributeData:new()
	local fateAttribute	= GameAttributeData:new()
	
	local spacielSkillPower = 0 --特殊技能所加的固定战斗力
	

	attribute:clone(self.attribute)
	attribute:setAddAttData(self.martialAttribute)
	for k,v in pairs(self.bookAttrAdd) do
		attribute:addAttr(k,v)
	end
	
	for k,v in pairs(self.acupointAttrAdd) do
		attribute:addAttr(k,v)
	end
	-- attribute:setAddAttData(self.qimenAttribute)
	attribute:setAddAttData(self.skillAttribute)
	attribute:setAddAttData(self.starupAttribute)
	attribute:setAddAttData(self.lianTiAttribute)
	attribute:setAddAttData(self.qianxiuAttribute)
	
	--attribute:setAddAttData(self.skyBookAttribute)
	-- attribute:setAddAttData(qiheAttribute)
	fateAttribute = self:updateFateByIdList(list,fight_type)
	attribute:setAddAttData(fateAttribute)
	
	-- attribute:setAddAttData(self.factionPracticeAttribute)

	-- attribute:setAddAttData(redpacketAttribute)
	-- attribute:setAddAttData(headPicFrameAttribute)
	attribute:refreshBypercent()
	
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	--东瀛岛
	-- attribute:setAddAttData(japanIslandAttribute)
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	-- 装备属性
	self.equipAttribute:refreshBypercent()
	attribute:setAddAttData(self.equipAttribute)
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	-- 独立系统属性
	-- 百分比自己算自己的
	
	self.skyBookAttribute:refreshBypercent()
	attribute:setAddAttData(self.skyBookAttribute)
	attribute:setAddAttData(self.xinFaAttribute)
	attribute:setAddAttData(self.TianMingAttribute)

	local suitAttribute = self:getSuitPowerAndAttri(attribute)
	if (suitAttribute ~= nil) then
		attribute:setAddAttData(suitAttribute)
	end
	attribute:refreshBypercent()
	attribute:updatePower()
	
	local power = attribute:getPower()
	if self.spellPower then
		power = power +self.spellPower
	end

	--增加修炼场战斗力
	-- local factionSkill = self.factionPractice or {}
	-- for k,v in pairs(factionSkill) do
	-- 	power = power + v.power
	-- end

	--增加契合固定战斗力
	power = power + spacielSkillPower-- + redPacketPower
	power = power + self.equipExtraPower
	power = power + self.skyBookPower
	power = power + self.TianMingPower
	-- power = power + jishiPower

	self.totalAttributeByType[fight_type] = attribute
	return power

end

function CardRole:getPowerByIdList(list,assist_type)

	self.totalAttributeByType = self.totalAttributeByType or {}

	local attribute	= GameAttributeData:new()
	local fateAttribute	= GameAttributeData:new()
	local qiheAttribute	= GameAttributeData:new()
	local zhuanjiAttribute = GameAttributeData:new()
	local jiayuanAttribute = GameAttributeData:new()
	local redpacketAttribute = GameAttributeData:new()
	local japanIslandAttribute = GameAttributeData:new()
	local headPicFrameAttribute = GameAttributeData:new()
	local monthAttribute
	local redPacketPower = 0
	local jishiPower = 0  		--济世堂
	local strategyCardAttribute = GameAttributeData:new()
	local eudemonCardAttribute 	= GameAttributeData:new() --宠物
	local giveAchievementAttribute = GameAttributeData:new()  --济世堂
	local spacielSkillPower = 0 --特殊技能所加的固定战斗力
	
	local isInArmy = false
	local posInStrategy = AssistFightManager:checkIsStrategyMemberByFightType( self.gmId,assist_type )
	if posInStrategy ~= 0 then
		isInArmy = true
		local attrList,subAttrList = AssistFightManager:getQihePreviewInfo(assist_type)
		for k,v in pairs(attrList) do
			qiheAttribute:addAttr(k,v)
		end
		local zhuanjiAttrList = IllustrationManager:getZhuanJiAllAttri()--getZhuanJiAttri()
		--local zhuanjiAttrList = IllustrationManager:getZhuanJiAttri()
		for k,v in pairs(zhuanjiAttrList) do
			zhuanjiAttribute:addAttr(k,v)
		end

		local jiayuanAttrList = QiyuManager:getJiayuanAttr()
		for k, v in pairs(jiayuanAttrList) do
			jiayuanAttribute:addAttr(k, v)
		end
		if subAttrList then
			for k,v in pairs(subAttrList) do
				spacielSkillPower = spacielSkillPower + v.power
			end
		end

		local cardStrategy = StrategyCardManager:getStrategyCardByStrategyType(assist_type)
		if cardStrategy then

			local baseAttr = cardStrategy:getTotalAttrArray()
			strategyCardAttribute:setAddAttData(baseAttr)
			local starAttr = cardStrategy:getPositonAttributeByRolePos(posInStrategy)
			local des,power = cardStrategy:getSkillDesAndPower(posInStrategy)
			local shenYanPower = cardStrategy:getShenYanPower(posInStrategy)
			if starAttr then
				strategyCardAttribute:setAddAttData(starAttr)
			end
			spacielSkillPower = spacielSkillPower + power + shenYanPower
		end

		local sendAttriList = RedPacketManager:getSendAttri()
		for k, v in pairs(sendAttriList) do
			redpacketAttribute:addAttr(k, v)
		end

		local acheivAttriList,subAcheivAttrList = RedPacketManager:getAcheivAttri()
		for k, v in pairs(acheivAttriList) do
			redpacketAttribute:addAttr(k, v)
		end

		local japAchieveAttriList = JapanIslandManager:getAcheivAttri()
		for k, v in pairs(japAchieveAttriList) do
			japanIslandAttribute:addAttr(k, v)
		end

		if subAcheivAttrList then
			for k,v in pairs(subAcheivAttrList) do
				redPacketPower = redPacketPower + v
			end
		end
		--宠物
		local eudemonId 	= EudemonManager:getEudemonByFightId(assist_type)
		local eudemonInfo 	= EudemonManager:getEudemonById(eudemonId)
		if (eudemonInfo) then
			eudemonCardAttribute:setAddAttData(eudemonInfo:getTeamAttribute())
		end

		--帮派成就属性
		local giveAchievementAttr,beAttrList, power = FactionJiShiTangManager:getGiveAchievementAttr(assist_type)
		if (giveAchievementAttr) then
			for attrId, attrValue in pairs(giveAchievementAttr) do
				giveAchievementAttribute:addAttr(attrId, attrValue)
			end
		end
		local hpfAttriTable = HeadPicFrameManager:getAttribute()
		for k, v in pairs(hpfAttriTable) do
			headPicFrameAttribute:addAttr(k, v)
		end
		
		jishiPower = power or 0
	end
	
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--

	attribute:clone(self.attribute)
	attribute:setAddAttData(self.martialAttribute)
	for k,v in pairs(self.bookAttrAdd) do
		attribute:addAttr(k,v)
	end
	
	for k,v in pairs(self.acupointAttrAdd) do
		attribute:addAttr(k,v)
	end
	attribute:setAddAttData(self.qimenAttribute)
	attribute:setAddAttData(self.skillAttribute)
	attribute:setAddAttData(self.starupAttribute)
	attribute:setAddAttData(self.lianTiAttribute)
	attribute:setAddAttData(self.qianxiuAttribute)
	
	--attribute:setAddAttData(self.skyBookAttribute)
	attribute:setAddAttData(qiheAttribute)
	fateAttribute = self:updateFateByIdList(list,assist_type)
	attribute:setAddAttData(fateAttribute)
	
	attribute:setAddAttData(self.factionPracticeAttribute)

	attribute:setAddAttData(redpacketAttribute)
	attribute:setAddAttData(headPicFrameAttribute)
	attribute:refreshBypercent()
	
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	--东瀛岛
	attribute:setAddAttData(japanIslandAttribute)
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	-- 装备属性
	self.equipAttribute:refreshBypercent()
	attribute:setAddAttData(self.equipAttribute)
	--=================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>=============================--
	-- 独立系统属性
	-- 百分比自己算自己的
	
	self.skyBookAttribute:refreshBypercent()
	attribute:setAddAttData(self.skyBookAttribute)
	attribute:setAddAttData(self.xinFaAttribute)
	attribute:setAddAttData(self.TianMingAttribute)
	zhuanjiAttribute:refreshBypercent()
	attribute:setAddAttData(zhuanjiAttribute)
	jiayuanAttribute:refreshBypercent()
	attribute:setAddAttData(jiayuanAttribute)

	-- print(self.name.."属性 ->"..attribute:displayString())
	-- print(self.name.."fateAttribute 属性 ->"..fateAttribute:displayString())

	if self.isMainPlayer then
		local vip_add = VipRuleManager:addMainPlayerAttr()
		if vip_add ~= 0 then
			attribute:addAttr(EnumAttributeType.Force,vip_add)
			attribute:addAttr(EnumAttributeType.Magic,vip_add)
		end
	end

	self.monthAttribute:clear()
	if MonthCardManager:getCardState() ~= self.monthState then
		self.monthState = MonthCardManager:getCardState()
		self:calculationMonthAttr()
	end
	self:updateMonthCard()
	self.monthAttribute:refreshBypercent()
	attribute:setAddAttData(self.monthAttribute)


	if isInArmy  then
		monthAttribute = self:calculationMonthAttrInArmy()
		monthAttribute:refreshBypercent()
		attribute:setAddAttData(monthAttribute)
	end

	-- -- 大月卡增加额外属性-- 主角：武力、内力 各500 +level*5
	-- local bOwnMonth = MonthCardManager:isExistMonthCard(MonthCardManager.CARD_TYPE_2)
	-- if bOwnMonth == true then
	-- 	if self.isMainPlayer then
	-- 		self.monthAttribute:clear()
	-- 		self:updateMonthCard()
	-- 		attribute:setAddAttData(self.monthAttribute)
	-- 	end
	-- end

	if isInArmy  then
		-- strategyCardAttribute:refreshBypercent()
		attribute:setAddAttData(strategyCardAttribute)
		-- eudemonCardAttribute:refreshBypercent()
		attribute:setAddAttData(eudemonCardAttribute)
	end
	attribute:setAddAttData(giveAchievementAttribute)
	-- 套装属性
	-- self:updataSuitAdd()
	local suitAttribute = self:getSuitPowerAndAttri(attribute)
	if (suitAttribute ~= nil) then
		attribute:setAddAttData(suitAttribute)
	end
	attribute:refreshBypercent()
	attribute:updatePower()
	local power = attribute:getPower()
	if self.spellPower then
		power = power +self.spellPower
	end

	--增加修炼场战斗力
	local factionSkill = self.factionPractice or {}
	for k,v in pairs(factionSkill) do
		power = power + v.power
	end

	--增加契合固定战斗力
	power = power + spacielSkillPower + redPacketPower
	power = power + self.equipExtraPower + self.suitPower
	power = power + self.skyBookPower
	power = power + jishiPower
	power = power + self.TianMingPower
	
	--
	self.totalAttributeByType[assist_type] = attribute
	return power
end

function CardRole:getRoleByTemplateId(roleid)
	local assistlist = AssistFightManager:getAssistRoleList( LineUpType.LineUp_Main )

	--添加好友助战
	local info = AssistFightManager:getFriendIconInfo()
    local cardRole = RoleData:objectByID(info.friendRoleId)
    if cardRole and cardRole.id == roleid then
    	return cardRole
	end
	-- print("assistlist = ", assistlist)
 -- M = asdasd + 1
	-- print("----AssistFightManager time2 = ", os.time())

	for i=1,10 do
		if assistlist[i] and assistlist[i] ~= 0 then
			local role = CardRoleManager:getRoleByGmid(assistlist[i])
			if role and role.id == roleid then 
				return role
			end
		end
	end

	return nil
end

function CardRole:updateQihe()

	self.qiheAttribute:clear()
	
	if AssistFightManager:checkIsStrategyMember( self.gmId ) then
		local attrList = AssistFightManager:getQihePreviewInfo(LineUpType.LineUp_Main)
		-- print('CardRoleupdateQihe = ',self.name)
		-- print(attrList)
		for k,v in pairs(attrList) do
			self.qiheAttribute:addAttr(k,v)
		end
	-- else
	-- 	print('刷新契合属性-----',self.name)
	end
	self:updateTotalAttr()
end

function CardRole:getFactionPractice()
	return self.factionPractice
end

function CardRole:setFactionPractice( practice_list )
	-- print("practice_list",practice_list)
	practice_list = practice_list or {}
	self.factionPractice = {}
	for k,v in pairs(practice_list) do
		self:setFactionPracticeByType( v.type, v.level ,false)
	end
	self:refreshFactionPractice()
	-- self:refreshFactionPractice()

end

function CardRole:setFactionPracticeByType( type, level ,isneedRefresh )
	if isneedRefresh == nil then
		isneedRefresh = true
	end
	local power = 0
	if level ~= 0 then
		local practicStudyInfo = FactionPracticeManager:getHouseDetailInfo()
		if (practicStudyInfo) then
            local maxLevel = practicStudyInfo[type] or 0
            if (maxLevel > 0 and level > maxLevel) then
                level = maxLevel
            end
		end
		
		local itemData = GuildPracticeData:getPracticeInfoByTypeAndLevel( type,level,self.outline )
		if itemData then
			power = itemData.power
		end
	end
	for i=1,#self.factionPractice do
		if self.factionPractice[i].type == type then
			self.factionPractice[i].level = level
			self.factionPractice[i].power = power
			self.factionPractice[i].profession = self.outline
			if isneedRefresh then
				self:refreshFactionPractice()
			end
			return 
		end
	end
	local idx = #self.factionPractice + 1
	self.factionPractice[idx] = {type = type, level = level, power = power, profession = self.outline}
	if isneedRefresh then
		self:refreshFactionPractice()
	end
end

function CardRole:resetFactionPracticeByChangeProfession()
	for i=1,#self.factionPractice do
		if self.factionPractice[i] then
			self.factionPractice[i].profession = self.outline
		end
	end
	self:refreshFactionPractice()
end

function CardRole:getFactionPracticeLevelByType( type )
	for i=1,#self.factionPractice do
		if self.factionPractice[i].type == type then
			return self.factionPractice[i].level
		end
	end
	return 0
end

function CardRole:refreshFactionPractice()
	self.immuneAttribute:getPracticeAttribute():clear();
	self.effectExtraAttribute:getPracticeAttribute():clear();
	self.beEffectExtraAttribute:getPracticeAttribute():clear();

	self.factionPracticeAttribute:clear()

	for index,practicedata in pairs(self.factionPractice) do
		local practiceInfo = GuildPracticeData:getPracticeInfoByTbl(practicedata)
		if practiceInfo == nil then
			--print("没有此id的修炼信息 id == ",practicedata)
		else
			if practiceInfo.attribute ~= "" then
				local temp_tbl = GetAttrByString(practiceInfo.attribute)
				
				for k,v in pairs(temp_tbl) do
					self.factionPracticeAttribute:addAttr(k,v)
				end
			end
			if practiceInfo.immune_rate ~= "" then
				local temp_tbl = GetAttrByString(practiceInfo.immune_rate)
				for k,v in pairs(temp_tbl) do
					self.immuneAttribute:getPracticeAttribute():addAttr(k,v)
				end
			end
			if practiceInfo.effect_active ~= "" then
				local temp_tbl = GetAttrByString(practiceInfo.effect_active)
				for k,v in pairs(temp_tbl) do
					self.effectExtraAttribute:getPracticeAttribute():addAttr(k,v)
				end
			end
			if practiceInfo.effect_passive ~= "" then
				local temp_tbl = GetAttrByString(practiceInfo.effect_passive)
				for k,v in pairs(temp_tbl) do
					self.beEffectExtraAttribute:getPracticeAttribute():addAttr(k,v)
				end
			end
		end
	end
	self.immuneAttribute:updateAttribute()
	self.effectExtraAttribute:updateAttribute()
	self.beEffectExtraAttribute:updateAttribute()

	
	self:updateTotalAttr()
end

function CardRole:getFactionPracticeCost()
	local cost = 0
	local tableTool = {}
	for i=1,#self.factionPractice do
		local dataArray = GuildPracticeStudyData:getGuildPracticeStudyByType(self.factionPractice[i].type)
		if dataArray then
			for k,v in pairs(dataArray) do
				if v.attribute_level <= self.factionPractice[i].level then
					local tbl = string.split(v.start_practice, "|")
					local dedication = stringToNumberTable(tbl[1], "_") 
					if tbl[2] then
						local tool = stringToNumberTable(tbl[2],"_")
						tableTool[tool[2]] = tableTool[tool[2]] or 0
						tableTool[tool[2]] = tableTool[tool[2]] + tool[3]
					end
					cost = cost + dedication[3]
				end
			end
		end
	end
	return cost,tableTool
end

function CardRole:getQimenAttrDetail()
	return self.qimenAttrTable
end
function CardRole:getQimengetTotalAttribute(index)
	return self.qimenAttrTable[index]
end

function CardRole:getQimenTeamAttrDetail()
	return self.qimenTeamAttrTable
end
function CardRole:getQimenTeamgetTotalAttribute(index)
	return self.qimenTeamAttrTable[index]
end


function CardRole:getQimenLevelInfo()
	return self.qimenLevelInfo
end

function CardRole:setQimenInfo(id,level)

	if id == 0 and level == 0 then
		self.qimenLevelInfo = nil
	else
		self.qimenLevelInfo = {}
		self.qimenLevelInfo.id = id
		self.qimenLevelInfo.level = level
	end
	self.qimenPower = 0
	self.qimenAttrTable = {}
	self.qimenTeamAttrTable = {}
	self.qimenAttribute:clear()
	self.immuneAttribute:getQimenAttribute():clear();
	self.effectExtraAttribute:getQimenAttribute():clear();
	self.beEffectExtraAttribute:getQimenAttribute():clear();
	local endIdx = id
	local startIdx = endIdx - 24
	if startIdx < 1 then
		startIdx = 0
	end
	if self.isMainPlayer then
		for v in QimenConfigData:iterator() do
	        if v.id > startIdx and v.id <= endIdx then
	        -- print('QimenConfigData = '..v.attribute..' v.id = '..v.id)
		        if v.attribute ~= '' then
		        	self.qimenPower = self.qimenPower + v.power
					local awardData = stringToNumberTable(v.attribute, '_')
					self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] or 0
					self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] + awardData[2]
					self.qimenAttribute:addAttr(awardData[1],awardData[2])

				elseif v.immune_rate ~= '' then
					self.qimenPower = self.qimenPower + v.power
					local awardData = stringToNumberTable(v.immune_rate, '_')
					-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] or 0
					-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] + awardData[2]
					self.immuneAttribute:getQimenAttribute():addAttr(awardData[1],awardData[2])	

				elseif v.effect_active ~= '' then
					self.qimenPower = self.qimenPower + v.power
					local awardData = stringToNumberTable(v.effect_active, '_')
					-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] or 0
					-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] + awardData[2]
					self.effectExtraAttribute:getQimenAttribute():addAttr(awardData[1],awardData[2])	

				elseif v.effect_passive ~= '' then
					self.qimenPower = self.qimenPower + v.power
					local awardData = stringToNumberTable(v.effect_passive, '_')
					-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] or 0
					-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] + awardData[2]
					self.beEffectExtraAttribute:getQimenAttribute():addAttr(awardData[1],awardData[2])	
				end  
			end         
	    end

		for v in QimenBreachConfigData:iterator() do
	        if v.id > level then
	        	break
	        end
	        if v.attribute ~= '' then
				local dataBuff = string.split(v.attribute, '|')
				for i=1,#dataBuff do
					local awardData = stringToNumberTable(dataBuff[i], '_')
					self.qimenPower = self.qimenPower + v.power
					self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] or 0
					self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] + awardData[2]
					self.qimenAttribute:addAttr(awardData[1],awardData[2])
				end
			elseif v.immune_rate ~= '' then
				self.qimenPower = self.qimenPower + v.power
				local awardData = stringToNumberTable(v.immune_rate, '_')
				-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] or 0
				-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] + awardData[2]
				self.immuneAttribute:getQimenAttribute():addAttr(awardData[1],awardData[2])	

			elseif v.effect_active ~= '' then
				self.qimenPower = self.qimenPower + v.power
				local awardData = stringToNumberTable(v.effect_active, '_')
				self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] or 0
				self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] + awardData[2]
				self.effectExtraAttribute:getQimenAttribute():addAttr(awardData[1],awardData[2])	

			elseif v.effect_passive ~= '' then
				self.qimenPower = self.qimenPower + v.power
				local awardData = stringToNumberTable(v.effect_passive, '_')
				-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] or 0
				-- self.qimenAttrTable[awardData[1]] = self.qimenAttrTable[awardData[1]] + awardData[2]
				self.beEffectExtraAttribute:getQimenAttribute():addAttr(awardData[1],awardData[2])	
			end
	    end
	end

	for v in QimenBreachConfigData:iterator() do
        if v.id > level then
			break
        end
        if v.team_attribute ~= '' and v.team_attribute ~= '0' then
			local dataBuff = string.split(v.team_attribute, '|')
			for i=1,#dataBuff do
				local awardData = stringToNumberTable(dataBuff[i], '_')
				self.qimenTeamAttrTable[awardData[1]] = self.qimenTeamAttrTable[awardData[1]] or 0
				self.qimenTeamAttrTable[awardData[1]] = self.qimenTeamAttrTable[awardData[1]] + awardData[2]
				self.qimenAttribute:addAttr(awardData[1],awardData[2])
			end
		end
    end
	self.immuneAttribute:updateAttribute()
	self.effectExtraAttribute:updateAttribute()
	self.beEffectExtraAttribute:updateAttribute()

	self:updateTotalAttr()

	-- print('xxxselfxqimenAttrTable = ',self.qimenAttrTable)
	-- print('self.qimenAttribute = ',self.qimenAttribute)
	-- print('self.qimenPower = ',self.qimenPower)
end

--added by wuqi
function CardRole:setSkyBook(bible)
	if bible and bible.equip and bible.equip ~= 0 then
		bible.equip = nil
	end
	self.bible = bible
	bible.equip = self.id

	self.skyBookAttribute:clear()
	self.skyBookAttribute:clone(bible.totalAttribute)
	self.skyBookPower = self.bible.gemPower + self.bible.canWuBeExtraPower
	--self.skyBookPower = self.bible.gemPower
	self:updateTotalAttr()
end

function CardRole:setXinFa(xinfa)
	if xinfa and xinfa.equip and xinfa.equip ~= 0 then
		xinfa.equip = nil
	end
	self.xinfa = xinfa
	xinfa.equip = self.id

	self.xinFaAttribute:clear()
	self.xinFaAttribute:clone(xinfa.totalAttribute)
	self.XinFaSpecialAttribute:clone(xinfa.totalAttribute)

	self:updateTotalAttr()
end

function CardRole:setTianMing(tianming)
	if tianming.pos == 0 then 
		return
	else
		self.TianMingAchievementIdList = {}
		if tianming and tianming.equip and tianming.equip ~= 0 then
			tianming.equip = nil
		end
		tianming.equip = self.id
		self.TianMing[tianming.pos].id = tianming.instanceId
		self.TianMing[tianming.pos].level = tianming.level
		self.TianMing[tianming.pos].exp = tianming.exp
		self.TianMing[tianming.pos].quality = tianming.quality
		self.TianMing[tianming.pos].power = tianming.power
		self.TianMing[tianming.pos].price = tianming.config.price
		self.TianMing[tianming.pos].star = tianming.starnum
		self.TianMing[tianming.pos].ea_tb = tianming.eatotalAttribute.attribute
		self.TianMing[tianming.pos].ep_tb = tianming.eptotalAttribute.attribute
		self.TianMing[tianming.pos].ir_tb = tianming.irtotalAttribute.attribute
		
		self.TianMing[tianming.pos].totalAttribute = tianming.totalAttribute

		self.TianMingAttribute:clear()
		self.TianMingPower = 0
		local exp = 0
		for i = 1,9 do
			if self.TianMing[i].totalAttribute ~= nil then
				self.TianMingAttribute:setAddAttData(self.TianMing[i].totalAttribute)
			end
			exp = exp + self.TianMing[i].exp
			if self.TianMing[i].price then
				exp = exp + self.TianMing[i].price
			end 
			self.TianMingPower = self.TianMingPower + self.TianMing[i].power 
		end
		--天命经验加成
		local ir_tbl0, ea_tbl0, ep_tbl0, power = DesTinyMissionData:getTianMingAchievementAttr(exp)
		self.TianMingAttribute:add(ir_tbl0)
		self.TianMingAttribute:add(ea_tbl0)
		self.TianMingAttribute:add(ep_tbl0)
		self.TianMingPower = self.TianMingPower + power
		-- 天命成就加成
		local ir_tbl0, ea_tbl0, ep_tbl0 ,power,list= DesTinyAchievementData:getDesTinyAchievementAttributeByTianMingList(self.TianMing)
		self.TianMingAttribute:add(ir_tbl0)
		self.TianMingAttribute:add(ea_tbl0)
		self.TianMingAttribute:add(ep_tbl0)
		self.TianMingPower = self.TianMingPower + power
		self.TianMingAchievementIdList = list
		self.TianMingAttribute:refreshBypercent()

		self:updateTotalAttr()
	end
end
function CardRole:getSkyBook()
	return self.bible
end

function CardRole:getXinFa()
	return self.xinfa
end
function CardRole:geTianMing()
	return self.TianMing
end

function CardRole:delSkyBook()
	if self.bible then
		self.bible.equip = nil
		self.bible = nil
	end
	self.skyBookAttribute:clear()
	self.skyBookPower = 0
	self.effectExtraAttribute:getSkyBookAttribute():clear()
	self.beEffectExtraAttribute:getSkyBookAttribute():clear()	
	self.immuneAttribute:getSkyBookAttribute():clear()

	self.effectExtraAttribute:updateAttribute()
	self.immuneAttribute:updateAttribute()
	self.beEffectExtraAttribute:updateAttribute()
	
	self:updateTotalAttr()
end

function CardRole:delXinFa()
	if self.xinfa then
		self.xinfa.equip = nil
		self.xinfa = nil
	end

	self.effectExtraAttribute:getXinFaAttribute():clear()

	self.effectExtraAttribute:updateAttribute()
	self.xinFaAttribute:clear()
	self.XinFaSpecialAttribute:clear()
	self:updateTotalAttr()
end
function CardRole:delTianMing()
	self.TianMingPower = 0
	self.TianMingAchievementIdList = {}
	if self.TianMing then
		self.TianMing = {
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil},
		{id = 0,level = 0,exp = 0,price = 0,quality = 0,power = 0,totalAttribute = nil,ir_tb = nil,ea_tb = nil,ep_tb = nil}
		}
	end

	self.effectExtraAttribute:getTianMingAttribute():clear()

	self.effectExtraAttribute:updateAttribute()
	self.TianMingAttribute:clear()
	self:updateTotalAttr()
end

function CardRole:updateSkyBookAttr()
	if self.bible == nil then
		return
	end
	local bible = self.bible
	self.skyBookAttribute:clear()
	self.skyBookAttribute:clone(bible.totalAttribute)

	self.skyBookPower = self.bible.gemPower + self.bible.canWuBeExtraPower
	self.effectExtraAttribute:getSkyBookAttribute():clear()
	self.beEffectExtraAttribute:getSkyBookAttribute():clear()	
	self.immuneAttribute:getSkyBookAttribute():clear()

	self.immuneAttribute:getSkyBookAttribute():add(bible:getImmuneAttr())
	self.effectExtraAttribute:getSkyBookAttribute():add(bible:getEffectExtraAttr())
	self.beEffectExtraAttribute:getSkyBookAttribute():add(bible:getBeEffectExtraAttr())

	self.effectExtraAttribute:updateAttribute()
	self.immuneAttribute:updateAttribute()
	self.beEffectExtraAttribute:updateAttribute()
	self:updateTotalAttr()
end

function CardRole:updateTianMingAttr()

	self.TianMingAttribute:clear()
	
	local exp = 0
	for i = 1,9 do
		if self.TianMing[i].totalAttribute ~= nil then
			self.TianMingAttribute:setAddAttData(self.TianMing[i].totalAttribute)
		end
		exp = exp + self.TianMing[i].exp + self.TianMing[i].price
	end
	local ir_tbl0, ea_tbl0, ep_tbl0, power = DesTinyMissionData:getTianMingAchievementAttr(exp)
	self.TianMingAttribute:add(ir_tbl0)
	self.TianMingAttribute:add(ea_tbl0)
	self.TianMingAttribute:add(ep_tbl0)
	
	local ir_tbl0, ea_tbl0, ep_tbl0 ,power,list= DesTinyAchievementData:getDesTinyAchievementAttributeByTianMingList(self.TianMing)
	self.TianMingAttribute:add(ir_tbl0)
	self.TianMingAttribute:add(ea_tbl0)
	self.TianMingAttribute:add(ep_tbl0)
	self.TianMingAttribute:refreshBypercent()
	self:updateTotalAttr()	
end
function CardRole:updateXinFaAttr()
	if self.xinfa == nil then
		return
	end

	self.xinFaAttribute:clear()
	self.xinFaAttribute:clone(self.xinfa.totalAttribute)

	self.effectExtraAttribute:getXinFaAttribute():clear()
	--self.effectExtraAttribute:getXinFaAttribute():add(self.xinfa:getTupoAttribute())

	self:updateTotalAttr()	
end

function CardRole:judgeLianTiData(dataList)
	if self.LianTiData[1] and self.LianTiData[1].level > 0 then
		return true
	end
	local pointData = {}
	for k,data in pairs(dataList) do
		if data.acupoint == 1 then
			pointData = data
			break
		end
	end
	if pointData.level <= 0 then
		return false
	end
	return true
end

function CardRole:setLianTiData(dataList)
	self.LianTiData = self.LianTiData or {}
	if self:judgeLianTiData(dataList) == false then
 		return
	end

	for i = 1,#dataList do
		local data = dataList[i] or {}
		if data.acupoint ~= nil and data.level ~= nil then
			self.LianTiData[ data.acupoint ] = self.LianTiData[ data.acupoint ] or {}
			if self.LianTiData[ data.acupoint ].level ~= data.level then
				data.quality = LianTiData:getPointQuality(data.acupoint,data.level)
				self.LianTiData[ data.acupoint ] = data
			end
			if data.level <= 0 and self.LianTiData[ data.acupoint ].isOpen ~= true then
				local openItem = LianTiOpenData:objectByID(data.acupoint)
				if openItem then
					if openItem.needacu > 0 then
						needPointData = self.LianTiData[ openItem.needacu ]
						if needPointData and needPointData.quality then
							if needPointData.quality >= openItem.quality then
								self.LianTiData[ data.acupoint ].isOpen = true
							else
								self.LianTiData[ data.acupoint ].isOpen = false
							end
						else
							self.LianTiData[ data.acupoint ].isOpen = false
						end
					else
						self.LianTiData[ data.acupoint ].isOpen = true
					end
				end
			else
				self.LianTiData[ data.acupoint ].isOpen = true
			end
		end
	end
			
	self:setLianTiAttri()
end

function CardRole:checkCanLianTi( acupoint )
	local openItem = LianTiOpenData:objectByID( acupoint )
	if openItem then
		-- print("openItem = ",openItem)
		if openItem.needacu > 0 then
			needPointData = self.LianTiData[ openItem.needacu ]
			if needPointData and needPointData.quality then
				if needPointData.quality >= openItem.quality then
					return true
				else
					return false
				end
			else
				return false
			end
		else
			return true
		end
	end
	return true
end

function CardRole:setLianTiAttri()
	self.lianTiAttribute:clear()
	self.lianTiAttrTable = {}
	self.LianTiData = self.LianTiData or {}
	for k,v in ipairs(self.LianTiData) do
		local quality = self.quality
		if self.isMainPlayer == true then
			if quality <= QualityHeroType.ChuanShuo then
				quality = QualityHeroType.ChuanShuo
			end
		end
		local attributeTabel = LianTiData:getTotalAttributeByType(quality,v.acupoint,v.level)
		for kk,vv in pairs(attributeTabel) do
			self.lianTiAttrTable[kk] = self.lianTiAttrTable[kk] or 0
			self.lianTiAttrTable[kk] = self.lianTiAttrTable[kk] + vv
		end
	end
	local extraAttri = self:getExtraLianTiAttri()
	for k,v in pairs(extraAttri.attribute) do
		self.lianTiAttrTable[k] = self.lianTiAttrTable[k] or 0
		self.lianTiAttrTable[k] = self.lianTiAttrTable[k] + v.value
	end
	for k,v in pairs(self.lianTiAttrTable) do
		self.lianTiAttribute:addAttr(k,v)
	end
	self:updateTotalAttr()
end

function CardRole:getExtraLianTiAttri()
	self.LianTiData = self.LianTiData or {}
	local pointQuaNum = {}
	local maxQua = 1
	for k,v in pairs(self.LianTiData) do
		pointQuaNum[v.quality] = pointQuaNum[v.quality] or 0
		pointQuaNum[v.quality] = pointQuaNum[v.quality] + 1
		if v.quality > maxQua then
			maxQua = v.quality
		end
	end
	for i=1,maxQua do
		for j=2,maxQua do
			if i < j then
				pointQuaNum[i] = pointQuaNum[i] or 0
				pointQuaNum[j] = pointQuaNum[j] or 0
				pointQuaNum[i] = pointQuaNum[i] + pointQuaNum[j]
			end
		end
	end
	-- print("CardRole:getExtraLianTiAttri()  pointQuaNum, ",pointQuaNum)
	local curitem = {id = 0,meridians = 0,breakthrough = 0,attribute = {},addNum = 0}
	for item in LianTiExtraData:iterator() do
		local num = pointQuaNum[item.quality] or 0
		if num >= item.number then
			if curitem.id < item.id then
				curitem.id = item.id
				if item.attribute ~= "" and item.attribute ~= "0" then
					curitem.attribute = item:getAttributeValue()
					for k,v in pairs(curitem.attribute) do
						if v.value > 0 and v.value > curitem.addNum then
							curitem.addNum = v.value
						end
					end
				end
				if curitem.meridians < item.meridians then
					curitem.meridians = item.meridians
				end
				if curitem.breakthrough < item.breakthrough then
					curitem.breakthrough = item.breakthrough
				end
			end
		end
	end
	local ret = {meridians = curitem.meridians,breakthrough = curitem.breakthrough,attribute = curitem.attribute,addNum = curitem.addNum}
	return ret
end

function CardRole:getLianTiAttrDetail()
	return self.lianTiAttrTable or {}
end
function CardRole:getLianTiTotalAttribute(index)
	return self.lianTiAttrTable[index] or 0
end

function CardRole:getLianTiDataById(id)
	self.LianTiData = self.LianTiData or {}
	return self.LianTiData[ id ]
end

function CardRole:getMaxLianTiQua()
	local quality = 0
	for k,v in pairs(self.LianTiData) do
		if quality < v.quality then
			quality = v.quality
		end
	end
	return quality
end

function CardRole:setPosByFightType( fight_type,pos )
	self.fightTypePos[fight_type] = pos
end

function CardRole:getPosByFightType( fight_type )
	if self.fightTypePos[fight_type] then
		return self.fightTypePos[fight_type]
	end
	return 0
end

function CardRole:setQianXiuAttri(myInfo, isLoging)
	if myInfo == nil then 
		return 
	end
	myInfo.attIndex = myInfo.attIndex or {}
	self.qianxiuAttrTable[myInfo.stage] = {}
	myInfo.value = myInfo.value or {}
	local currNum = 0
	for k,v in pairs(myInfo.attIndex) do
		local num = myInfo.value[k] or 0
		self.qianxiuAttrTable[myInfo.stage][v] = num
		currNum = currNum + num
	end
	-- for _,v in pairs(self.qianxiuAttrTable) do
	-- 	for k,value in pairs(v) do
	-- 		self.qianxiuAttribute:addAttr(k,value)
	-- 	end
	-- end
	----------------------------------------临时关闭，下次更新打开
	-- if ( myInfo.open == 1) then
	-- 	if (isLoging ~= true) then
	-- 		self.maxQianXiuStage = 1
	-- 	end
	-- 	--关闭
	-- 	if(self.maxQianXiuStage <= myInfo.stage) then
	-- 		self.maxQianXiuStage = myInfo.stage
	-- 	elseif (isLoging ~= true) then
	-- 		local isOpen = self:isOpenStage(myInfo.stage + 1)
	-- 		if (isOpen) then
	-- 			self.maxQianXiuStage = myInfo.stage + 1
	-- 		end
	-- 	end
	-- end
	---------------------------------------- 
	self.maxQianXiuStage = 1
	local nextRank 		= myInfo.stage + 1
	local nextDataList 	= self:getQianXiuAttriTable(nextRank)--self.qianxiuAttrTable[nextRank]
	local nextDataNum 	= 0
	for k,v in pairs(nextDataList) do
		nextDataNum = nextDataNum + tonumber(v)
	end
	local maxRank = 0
	local isOpen = self:isOpenStage(nextRank)
	if (isOpen) then
		maxRank = nextRank
	elseif (nextDataNum > 0) then
		maxRank = nextRank
	elseif (currNum > 0) then
		maxRank = myInfo.stage
	end
	
	if(self.maxQianXiuStage < maxRank) then
		self.maxQianXiuStage = maxRank
	end
	self:updataQianXiuStageAttri()
	self:updateTotalAttr()
end

--计算潜修各阶段属性
function CardRole:updataQianXiuStageAttri()
	self.qianxiuAttribute:clear()
	local tempAttr 	= {}
	local percent 	= {}
	local count 	= 0
	for _,v in pairs(self.qianxiuAttrTable) do
		count = count + 1
		for attrId,attrValue in pairs(v) do	
			local constData = ConstantData:objectByID("PotentialPracticeStage"..count)
			local addType = 1
			if (constData) then
				addType = tonumber(constData.value)
			end
			if (addType == 1) then
				tempAttr[attrId] = (tempAttr[attrId] or 0) + attrValue
			elseif (addType == 2) then
				percent[attrId] = (percent[attrId] or 0) + attrValue
			end
		end
	end
	for attrId,attrValue in pairs(tempAttr) do
		local percentValue 	= percent[attrId] or 0
		--percentValue 		= percentValue + 1000
		attrValue 			= (attrValue or 0)
		-- attrValue 		= attrValue + math.floor(((attrValue * percentValue) / 1000))
		local add 			= math.floor(((attrValue * percentValue) / 1000))
		attrValue 			= attrValue + add
		if (attrValue > 0) then
			self.qianxiuAttribute:addAttr(attrId,attrValue)
		end
	end
end
function CardRole:setQianXiuChangeAttri(changeInfo)
	if changeInfo == nil then 
		return 
	end
	changeInfo.attIndex = changeInfo.attIndex or {}
	changeInfo.value = changeInfo.value or {}
	if (QianXiuManager.Debug) then
		changeInfo.stage = changeInfo.stage or 1
	end
	self.qxChangeAttriTable[changeInfo.stage] = {}
	local isQianXiu = false
	
	for k,v in pairs(changeInfo.attIndex) do
		
		self.qxChangeAttriTable[changeInfo.stage][v] = changeInfo.value[k] or 0
		
		local info = self.qianxiuAttrTable[changeInfo.stage]
		local attr_value = nil
		if (info) then
			attr_value = info[v]
		end
		if self.qxChangeAttriTable[changeInfo.stage][v] ~= attr_value then
			isQianXiu = true
		end
	end
	if isQianXiu == false then
		self.qxChangeAttriTable[changeInfo.stage] = {}
	end
end

function CardRole:clearQianXiu()
	self.qxChangeAttriTable = {}
	self.qianxiuAttrTable = {}
	self.maxQianXiuStage = 1
end

function CardRole:getQianXiuAttriTable(stage)
	return self.qianxiuAttrTable[stage] or {}
end

function CardRole:getQianXiuChangeAttriTable(stage)
	return self.qxChangeAttriTable[stage] or {}
end

--是否开启stage级别潜修
function CardRole:isOpenStage(stage)
	if (stage <= self.maxQianXiuStage) then
		return true
	end
	local roleQianXiuAttri  = self:getQianXiuAttriTable(stage - 1)
	local sum = 0
	for k,v in pairs(roleQianXiuAttri) do
		-- if (k == EnumAttributeType.Blood) then
		-- 	--气血 / 5 PotentialPracticeQuality.Stage2
		-- 	v = math.floor( v / 5 )
		-- end
		sum = sum + tonumber(v)
	end
	local openInfo = ConstantData:objectByID("PotentialPracticeStageOpen"..(stage - 1))
	local openNum = 0
	if (openInfo) then
		openNum = openInfo.value
	else
		return false
	end
	return (sum >= openNum), sum, openNum
end
--0: 无加成
--1: 5件装备6星
--2: 5件装备7星
--5: 5件装备10星
function CardRole:getStarAttrAddLevel()
	local tab = {}
	for i = 1, 5 do
		local equip = self:getEquipment():GetEquipByType(i)
		if equip then
			table.insert(tab, equip:getStar())
		end
	end

	if #tab ~= 5 then
		return 0
	end

	table.sort(tab, function(a, b)
		return a < b
	end)

	if tab[1] >= 10 then
		return 5
	elseif tab[1] >= 9 then
		return 4
	elseif tab[1] >= 8 then
		return 3
	elseif tab[1] >= 7 then
		return 2
	elseif tab[1] >= 6 then
		return 1
	else
		return 0
	end
end

function CardRole:getEquipNumByStar(starNum)
	local count = 0
	for i = 1, 5 do
		local equip = self:getEquipment():GetEquipByType(i)
		if equip and equip:getStar() >= starNum then
			count = count + 1
		end
	end
	return count
end

-- 获取装备升阶激活附加属性等级
--0: 无加成
--1: 5件装备11阶
--2: 5件装备12阶
--5: 5件装备15阶
function CardRole:getUpgradeAttrAddLevel(  )
	local tab = {}
	for i = 1, 5 do
		local equip = self:getEquipment():GetEquipByType(i)
		if equip then
			table.insert(tab, equip:getorderBreachLevel())
		end
	end

	if #tab ~= 5 then
		return 0
	end

	table.sort(tab, function(a, b)
		return a < b
	end)

	if tab[1] >= 15 then
		return 5
	elseif tab[1] >= 14 then
		return 4
	elseif tab[1] >= 13 then
		return 3
	elseif tab[1] >= 12 then
		return 2
	elseif tab[1] >= 11 then
		return 1
	else
		return 0
	end
end

function CardRole:getEquipmentNumByUpgrade( nUpgradeLevel )
	local count = 0
	for i = 1, 5 do
		local equip = self:getEquipment():GetEquipByType(i)
		if equip and equip:getorderBreachLevel() >= nUpgradeLevel then
			count = count + 1
		end
	end
	return count
end

function CardRole:isMainRole()
	local roleList = GetPlayerRoleList()
	for k, v in pairs(roleList) do
		if v == self.id then
			return true
		end
	end
	return false
end

--改名字
function CardRole:changeName(strName)
	if self:isMainRole() then
		return
	end
	self.name = strName
	local item = RoleData:objectByID(self.id)
	item.name = strName
	roleSql:saveData(self.id, strName)
end

--还原成默认名字
function CardRole:returnToDefaultName()
	if self:isMainRole() then
		return
	end
	local item = RoleData:objectByID(self.id)
	local strName = item.default_name
	self.name = strName
	item.name = strName
	roleSql:saveData(self.id, strName)
end

function CardRole:getDefaultName()
	local item = RoleData:objectByID(self.id)
	return item.default_name or self.name
end

--更新套装加成系数
function CardRole:updataSuitAdd()
	local suitInfo = EquipmentManager:getSuitEquipInfo( self.gmId )

	self.suitPower = 0
	self.suitAttribute = {}
	self.suitEffectActivity = {}
	self.suitBeEffectActivity = {}
	for id,num in pairs(suitInfo) do
		local ir_tbl0, ea_tbl0, ep_tbl0, power = SuitsData:getSuitAttributeInfo( id, num )
		if (ir_tbl0 ~= nil) then
			for index, value in pairs(ir_tbl0) do
				if (self.suitAttribute.index == index) then
					self.suitAttribute.val = self.suitAttribute.val + value
				else
					table.insert(self.suitAttribute, {index = index, val = value})
				end	

			end
		end

		if (ea_tbl0 ~= nil) then
			for index, value in pairs(ea_tbl0) do
				if (self.suitEffectActivity.index == index) then
					self.suitEffectActivity.val = self.suitEffectActivity.val + value
				else
					table.insert(self.suitEffectActivity, {index = index, val = value})
				end				
			end
		end

		if (ep_tbl0 ~= nil) then
			for index, value in pairs(ep_tbl0) do
				if (self.suitBeEffectActivity.index == index) then
					self.suitBeEffectActivity.val = self.suitBeEffectActivity.val + value
				else
					table.insert(self.suitBeEffectActivity, {index = index, val = value})
				end				
			end
		end
		self.suitPower = self.suitPower + power
	end
	self:updateTotalAttr()
end

--更新套装加成显示数值
function CardRole:getSuitAttri( allAttri, value, baValue )
	local suitAttribute = {}
	local effectExtraAttribute = {}
	local beEffectExtraAttribute = {}

	for i = 1, #self.suitAttribute do 
		local idx = self.suitAttribute[i].index
		--if (allAttri.attribute ~= nil and allAttri.attribute[idx] ~= nil and allAttri.attribute[idx] ~= 0) then
			suitAttribute[idx] = self.suitAttribute[i].val 
		--end
	end
	-- if (value ~= nil) then
		for i = 1, #self.suitEffectActivity do 
			local idx = self.suitEffectActivity[i].index
			-- if (value.attribute ~= nil and value.attribute[idx] ~= nil) then
				effectExtraAttribute[idx] = self.suitEffectActivity[i].val 
			-- end
		end
	-- end

	-- if (baValue ~= nil) then
		for i = 1, #self.suitBeEffectActivity do 
			local idx = self.suitBeEffectActivity[i].index
			-- if (baValue.attribute ~= nil and baValue.attribute[idx] ~= nil) then
				beEffectExtraAttribute[idx] = self.suitBeEffectActivity[i].val 
			-- end
		end
	-- end
	return suitAttribute, effectExtraAttribute, beEffectExtraAttribute
end

--更新套装战力
function CardRole:getSuitPowerAndAttri( allAttri )
	local suitAttri = GameAttributeData:new()
	
	for i = 1, #self.suitAttribute do 
		local idx = self.suitAttribute[i].index		
		suitAttri:addAttr(idx, self.suitAttribute[i].val )
	end
	return suitAttri
end

function CardRole:getLianTiCost()
	local costInfo = {}
	local vesselbreachNum = 0
	if (self.quality >= 4 and self.quality <= 7 ) then
		costInfo[self.quality] = {}
		if (self.quality == 4) then
			costInfo[self.quality].itemid = 30116
		elseif (self.quality == 5) then
			costInfo[self.quality].itemid = 30117
		elseif (self.quality >= 6) then
			costInfo[self.quality].itemid = 30127
		end
		for i,v in pairs(self.LianTiData) do
			costInfo[self.quality].level = costInfo[self.quality].level or 0
			costInfo[self.quality].level = v.level + costInfo[self.quality].level
			vesselbreachNum = vesselbreachNum + v.level
		end
	end
	vesselbreachNum = math.floor(vesselbreachNum * 800 * 0.3)
	return costInfo,vesselbreachNum
end

function CardRole:LianTiAttrAdd(addAttr)
	local temp1 = GameAttributeData:new() 			
	local temp2 = GameAttributeData:new() 			
	for k,v in pairs(self.lianTiAttribute.attribute) do
		if (isPercentAttr(k)) then
			temp1:addAttr(k, v)
		else
			temp2:addAttr(k, v)
		end
	end
	temp2:setAddAttData(self.lianTiPercentAttribute)
	temp2:refreshBypercent()
	addAttr:setAddAttData(temp2)
	addAttr:setAddAttData(temp1)
end
function CardRole:getMeridianCostInfo()

	local kuXingCost = 0
	local zhengNianCost = 0
	if (self.qianxiuAttrTable[1]) then
		for k, v in pairs(self.qianxiuAttrTable[1]) do
			if (k == 1) then
				v = v / 5
			end
			kuXingCost = kuXingCost + v
		end
	end
	if (self.qianxiuAttrTable[2]) then
		for k, v in pairs(self.qianxiuAttrTable[2]) do
			zhengNianCost = zhengNianCost + v
		end
	end
	kuXingCost = math.floor(kuXingCost / 25)
	zhengNianCost = math.floor(zhengNianCost / 25)
	return kuXingCost, zhengNianCost
end

return CardRole