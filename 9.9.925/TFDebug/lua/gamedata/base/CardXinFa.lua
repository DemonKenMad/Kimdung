--[[
******心法类*******
	-- by yejiawei
	-- 2017/03/01
]]

local GameObject 		= require('lua.gamedata.base.GameObject')
local GameAttributeData = require('lua.gamedata.base.GameAttributeData')

local CardXinFa 		= class("CardXinFa",GameObject)

function CardXinFa:ctor( Data )
	self.super.ctor(self)
	self:init(Data)

end

function CardXinFa:init( id )
	self.totalAttribute 			= GameAttributeData:new()   --总加成
	self.tupoAttribute				= GameAttributeData:new()	--突破属性
	self.xiulianAttribute			= GameAttributeData:new()	--修炼属性
	self.NingLianHoleAttribute		= {}						--凝练属性
	self.extraGemAttr 				= GameAttributeData:new()	--凝练成就属性
	self.GemAttribute 				= GameAttributeData:new()	--宝石属性
	self.MingXinAttribute			= GameAttributeData:new()	--明心基本属性
	self.MingXinExtraAttribute 		= GameAttributeData:new()	--明心孔达到条件时附加属性
	self.MingXinPercent = 0	                                    --全属性百分比
	self.MingXinExtraPercent	= 0


	self.instanceId 			= id
	self.itemId 				= 0						--物品id
	self.starid 				= 0 					--星级id
	self.star 					= 0  					--星级
	self.levelid 				= 0 					--修炼等级id
	self.level 					= 0 					--修炼等级
	self.differlevel			= 0 				    --修炼提升了多少级
	self.Maxstar                = 0
	self.mulAttr 				= 1
	self.config					= nil
	self.equip 					= nil 					--装备者
	self.number                 = 0  					--心法残页数量
	self.GemAddPercent			= 0 					--宝石强化百分比

	self.gemId 					= {}					--心法镶嵌的宝石
	self.gemHole				= {} 					--心法孔位
	self.MulExtra 				= {} 
	self.MingXinSpecialandMain 	= {}					--明心额外特殊和主属性
	for i = 1, 5 do
		self.gemHole[i] 	= 0
		self.MulExtra[i] 	= 0
	end


	for i = 1, 5 do
		self.NingLianHoleAttribute[i] = GameAttributeData:new()
	end
	--重铸(明心)孔
	self.chongzhuData = {
		{pos = 1,level = 0,quality = 0},
		{pos = 2,level = 0,quality = 0},
		{pos = 3,level = 0,quality = 0},
		{pos = 4,level = 0,quality = 0},
		{pos = 5,level = 0,quality = 0},
	}

end

function CardXinFa:dispose()
	self.super.dispose(self)
	
	self.instanceId 	= 0
	self.itemId 		= 0
	self.starid 		= 0
	self.star 			= 0
	self.levelid 		= 0
	self.level 			= 0
	self.differlevel	= 0
	self.Maxstar    	= 0
	self.mulAttr 		= 0
	
	self.number			= 0

	self.config			= nil
	self.equip 			= nil 
	self.gemId 			= {}
	self.gemHole		= {}
	self.MulExtra 		= {} 
	self.totalAttribute:clear() 
	self.tupoAttribute:clear()	
	self.xiulianAttribute:clear()
	self.extraGemAttr:clear()
	self.GemAttribute:clear()
	self.MingXinAttribute:clear()
	self.MingXinExtraAttribute:clear()
	self.MingXinPercent 		= nil

	TFDirector:unRequire('lua.gamedata.base.GameObject')
	TFDirector:unRequire('lua.gamedata.base.GameAttributeData')
end

function CardXinFa:setData(data)
	if data.itemId then
		self.itemId = data.itemId
		self.config = ItemData:objectByID(self.itemId)
	end
	if data.instanceId then
		self.instanceId = data.instanceId
	end
	if data.practiceId then
		self.levelid = data.practiceId or 0
		self:setlevelid(self.levelid)
	end
	if data.breachId then
		self.starid = data.breachId
		self:setstarid(self.starid)
		self.Maxstar = KongfuTupoData:GetMaxLvByQuality(self.config.quality,self.config.usable)
	end
	if data.roleId then
		-- print("绑定角色",data.roleId,self.instanceId)
		self.equip = data.roleId
	end
	if data.number then
		self.number = data.number
	end

	if data.concise then
		for i,v in pairs(data.concise) do
			self:setGemPosLevel(v.pos, v.level)
		end
	end
	if data.gemInfo then
		self.gemId = {}
		for i,v in pairs(data.gemInfo) do
			if v.itemId == 0 then
				v.itemId = nil 
			end
			self:setGemPos(v.pos, v.itemId)
		end
	end
	if data.recast then
		for i,v in pairs(data.recast) do
			self:setChongzhuInfo(v.pos,v.level)
		end
	end

	self:updateAttr()
end

function CardXinFa:setstarid(starlevelid)
	self.starid = starlevelid
	if self.starid == 0 then
		self.star = 0
	else	
		self.star = KongfuTupoData:objectByID(self.starid).lv
	end
	self.mulAttr = KongfuTupoData:GetMulNumByQualityType(self.config.quality,self.config.usable,self.star)
end

function CardXinFa:setlevelid(levelid)
	self.levelid = levelid or 0
	if self.levelid == 0 then
		self.level = 0
	else
		self.level = 0
		local data = KongfuXiuLianData:objectByID(self.levelid)
		if (data) then
			self.level = data.lv
		end
		
	end
end
--
function CardXinFa:setLevel(level)
	self.level = level
end

function CardXinFa:setdifferLevel(levelid)
	-- print(levelid)
	levelid = levelid or 0
	if levelid == 0 then
		self.differlevel = 0
		return 
	end
	local data = KongfuXiuLianData:objectByID(levelid)
	self.differlevel = 0
	-- local level = KongfuXiuLianData:objectByID(levelid).lv
	-- self.differlevel = level - self.level
	if (data) then
		self.differlevel = data.lv - self.level
	end
end

function CardXinFa:setGemPosLevel( pos , level )
	self.gemHole[pos] = level
	self.MulExtra[pos] = KongfuGemData:GetExtraByLvAndQuality(self.gemHole[pos],self.config.quality)
end

--设置宝石
function CardXinFa:setGemPos( pos , id )
	--线上已经有人1号孔位镶嵌了宝石要计算战力 宝石要显示，以后1号不允许 由后端控制
	if self:IsGemPosOpen(pos) == false and pos ~= 1 then
		return
	end
	self.gemId[pos] = id
end
--查找宝石
function CardXinFa:getGemPos( pos )
	--先前的判断
	--self:IsGemPosOpen(pos) == false 
	if (self.gemId[pos]) == nil then
		return nil
	end
	return self.gemId[pos]
end

--查找孔位是否开启
function CardXinFa:IsGemPosOpen( pos )
	--print("是否开启",KongfuGemRuleData:GetGemOpenRoleByPos(pos))
	if self.gemHole[pos] == nil then
		return false
	end
	local openRule = KongfuGemRuleData:GetGemOpenRoleByPos(pos)
	-- print(self.gemHole,openRule)
	-- if pos ~= 1 then
	if self.gemHole[tonumber(openRule[1])] >= tonumber(openRule[2]) then
		return true
	else
		return false, tonumber(openRule[1])
	end
	-- end
	-- return true
end

--查找孔位等级
function CardXinFa:getGemPosLevel( pos )
	if pos > 5 then
		return nil
	end
	return self.gemHole[pos]
end

function CardXinFa:getExtraGemRule(pos)
	return KongfuGemRuleData:GemRuleByPos(pos)
end

function CardXinFa:getGemPosIsExtra(pos)
	local rule 		= KongfuGemRuleData:GemRuleByPos(pos)
	local gemId 	= self:getGemPos(pos)
	local GemInfo 	= ItemData:objectByID(gemId)
	if GemInfo == nil then 
		return 0
	end
	if tonumber(rule[1][1]) == GemInfo.kind then
		return 1, tonumber(rule[1][2]) / 10000
	elseif tonumber(rule[2][1]) == GemInfo.kind then
		return 2, tonumber(rule[2][2]) / 10000
	end
	return 0
end

function CardXinFa:getGemPosMaxLevel(pos)
	return KongfuGemRuleData:GetHoleMaxLevelByPos(pos)
end

function CardXinFa:getGemPosMaxGemLevel(pos)
	return KongfuGemData:GetMaxGemLevelByLvAndQuality(self.gemHole[pos],self.config.quality)
end

function CardXinFa:getMulExtra(pos)
	return self.MulExtra[pos]
end

function CardXinFa:getLevel()
	return self.level
end

function CardXinFa:getStar()
	return self.star
end
function CardXinFa:getConfigType()
	return self.config.type
end
function CardXinFa:getConfigKind()
	return self.config.kind
end
function CardXinFa:getConfigName()
	return self.config.name
end
function CardXinFa:getDifferlevel()
	return self.differlevel or 0
end
function CardXinFa:getConfigQuality()
	return self.config.quality
end
function CardXinFa:getPath()
	return self.config:GetPath()
end

function CardXinFa:Whetherculture()
	-- local bool = false
	if self.star ~=0 then
		return true
	end
	if (self.config.type == 35 and self.config.kind == 2) then
		if (self.level ~= 0) then
			return true
		end
	elseif self.level ~= 1 then
		return true
	end
	if self.equip ~= nil and self.equip ~= 0 then
		return true
	end
	if self:getGemPosLevel(1) ~= 0 then
		return true
	end
	for i =1 ,5 do
		if self:getGemPos(i) then
			return true
		end
	end
	for k, v in pairs(self.chongzhuData) do
		if v.level > 0 then
			return true
		end
	end
	return false
end

function CardXinFa:getpower()
	return GetPowerByAttribute(self.totalAttribute.attribute)
end

function CardXinFa:updatePower()
	self:updateAttr()
end

function CardXinFa:updateAttr()
	self.MingXinSpecialandMain = {}
	self.totalAttribute:clear()
	self.MingXinExtraAttribute:clear()
	--突破属性加成
	self:updateTupoAttr()
	self:updateXiuLianAttr()
	self:updateNingLianAttr()
	self:updateExtraGemAttr()

	--明心额外属性(要在镶嵌宝石前获取宝石加成百分比)
	local extraTab = self:getMingXinExtraAttr() or {}

	self:updateGemAttr()
	self:updateMingxin()
	self:getGradeNumPercent()
	for attrId,value in pairs(self.tupoAttribute.attribute) do
		self.totalAttribute:addAttr(attrId, value)
	end

	for attrId,value in pairs(self.xiulianAttribute.attribute) do
		self.totalAttribute:addAttr(attrId, math.floor(value * self.mulAttr))
	end

	for attrId,value in pairs(self:getTotalNingLianAttribute().attribute) do
		self.totalAttribute:addAttr(attrId, math.floor(value))
	end


	for attrId,value in pairs(self.GemAttribute.attribute) do
		self.totalAttribute:addAttr(attrId, math.floor(value))
	end
	for attrId,value in pairs(self.MingXinAttribute.attribute) do
		self.totalAttribute:addAttr(attrId, math.floor(value))
	end
	--明心额外属性
	local extraList = clone( extraTab.attr2 )
	-- if extraList and next(extraList) ~= nil then
	-- 	for k, v in pairs(extraTab.attr1) do
	-- 		extraList[k] = extraList[k] or 0
	-- 		extraList[k] = extraList[k] + v
	-- 		-- if self.MingXinSpecialandMain[k] == nil then 
	-- 		-- 	self.MingXinSpecialandMain[k] = 0
	-- 		-- end
	-- 		self.MingXinSpecialandMain[k] = self.MingXinSpecialandMain[k] or 0 
	-- 		self.MingXinSpecialandMain[k] = self.MingXinSpecialandMain[k] + v
	-- 	end
	-- 	for k, v in pairs(extraList) do
	-- 		self.MingXinExtraAttribute:addAttr(k, v)
	-- 		self.totalAttribute:addAttr(k, v)
	-- 	end 
	-- end
	if extraList and next(extraList) ~= nil then
		for k, v in pairs(extraList) do
			self.totalAttribute:addAttr(k, v)
			self.MingXinExtraAttribute:addAttr(k, v)
		end
	end
	if (extraTab.attr1) then
		for k, v in pairs(extraTab.attr1) do
			self.totalAttribute:addAttr(k, v)
			self.MingXinExtraAttribute:addAttr(k, v)
			self.MingXinSpecialandMain[k] = self.MingXinSpecialandMain[k] or 0 
			self.MingXinSpecialandMain[k] = self.MingXinSpecialandMain[k] + v
		end
	end
	if extraTab.attr2 and next(extraTab.attr2) ~= nil and extraTab.attr2[18] then 
		self.MingXinExtraPercent = extraTab.attr2[18] or 0
	end
	--明心百分比加成
	local extraList1 = clone( extraTab.attr2 )
	if extraList1 and next(extraList1) ~= nil then 
		for k, v in pairs(extraList1) do
			self.totalAttribute:addAttr(k, math.floor(self.MingXinPercent))
		end
	end
	--明心特殊属性加成
	for k, v in pairs(self.MingXinSpecialandMain) do
		if k >500 then
			self.totalAttribute:addAttr(k, math.floor(v))
		end
	end
	self.totalAttribute:refreshBypercent()
	self.totalAttribute:updatePower()
	if self.equip and self.equip ~= 0 then
		local role = CardRoleManager:getRoleById(self.equip)
		if role then
			role:updateXinFaAttr()
		end
	end
end

function CardXinFa:updateTupoAttr()
	self.tupoAttribute:clear()
	local attrList 	= KongfuTupoData:GetTuPoAttrBySQUK(self.star,self.config.quality,self.config.usable,self.config.kind)
	for attrId, attrValue in pairs(attrList) do
		self.tupoAttribute:addAttr(attrId, attrValue)
	end
	if self.level < 20 then
		attriList = {}
		self.tupoAttribute:clear()
	end
	self.tupoAttribute:updatePower()
	--print("self.tupoAttribute",self.tupoAttribute)
end

function CardXinFa:updateXiuLianAttr()
	self.xiulianAttribute:clear()
	local attrList 	= KongfuXiuLianData:GetXiuLianAttrByQualityAndLv(self.config.quality,self.level,self.config.usable)
	for attrId, attrValue in pairs(attrList) do
		self.xiulianAttribute:addAttr(attrId, attrValue)
	end
	self.xiulianAttribute:updatePower()
	--print("self.tupoAttribute",self.tupoAttribute)
end

function CardXinFa:updateNingLianAttr()
	for i = 1, 5 do
		self.NingLianHoleAttribute[i]:clear()
		if self:IsGemPosOpen(i) or i == 1 then	
			local attrList = KongfuGemData:GetHoleAttrByLvAndQualityAndPos(self.gemHole[i],self.config.quality,i)
			if attrList == nil then
				return
			end
			for attrId, attrValue in pairs(attrList) do
				if self:getGemPosIsExtra(i) ~= 0 then
					self.NingLianHoleAttribute[i]:addAttr(attrId, math.floor(attrValue * (1 + self:getMulExtra(i) + self:getExtraGemRule(i)[self:getGemPosIsExtra(i)][2] / 10000)))
				else
					self.NingLianHoleAttribute[i]:addAttr(attrId, math.floor(attrValue * (1 + self:getMulExtra(i))))
				end
			end
			self.NingLianHoleAttribute[i]:updatePower()
		end
	end
end

function CardXinFa:updateExtraGemAttr()
	self.extraGemAttr:clear()
	if self.gemHole[1] == nil then
		return
	end
	local level = self.gemHole[1]
	for i,v in pairs(self.gemHole) do
		if self.gemHole[i] < level then
			level = self.gemHole[i]
		end
	end

	local attrList = KongfuGemAimData:GetExtraAttrByMinLevel(level)
	if attrList == nil then
		return
	end

	for attrId, attrValue in pairs(attrList) do
		self.extraGemAttr:addAttr(attrId, attrValue)
	end
	self.extraGemAttr:updatePower()
end

function CardXinFa:setChongzhuInfo(pos, level)
	if (not pos) or (not level) or pos > 5 then
		return
	end
	self.chongzhuData[pos] = self.chongzhuData[pos] or {}
	self.chongzhuData[pos].level = level
	local item = KongfuRefineData:getItem(self.config.quality, pos, level)
	local holeQuality = 0
	if item then
		holeQuality = item:getQuality()
	end
	self.chongzhuData[pos].quality = holeQuality
end

function CardXinFa:getMingXinExtraAttr()
	self.GemAddPercent = 0
	if self.config.quality < 4 then
		return { attr1 = {}, attr2 = {} }
	end
	local itemList = KongfuRefineExtraData:getExtraItems(self.config.id) or {}
	if next(itemList) == nil then
		return
	end
	self.isDouble = false
	if string.find( itemList[1].attribute, '|' ) then
		self.isDouble = true
	end

	table.sort(itemList, function (item1, item2)
		return item1.id > item2.id
	end)
	local attrTab = {}
	local attrList1 = {}
	local attrList2 = {}
	local attrList3 = {}
	for i = 1, #itemList do
		local item = itemList[i] or {}
		local quality = item.quality or 10
		local count = self:getHoleNumByQuality(quality)
		if count >= item.number then
			local str1 = item.attribute or ""
			local str2 = item.base_attribute or ""
			local str3 = item.special_attr or ""
			table.insert(attrList1, str1)
			table.insert(attrList2, str2)
			table.insert(attrList3, str3)
			self.GemAddPercent = self.GemAddPercent + item.gem_attr
		end
	end
	local tab = { attr1 = {}, attr2 = {} }

	local tt = {}
	local maxIndex = 1
	local tempValue = 0
	for i = 1, #attrList1 do
		local tab1 = stringToTable( attrList1[i], '|' )
		for _,attr in pairs(tab1) do
			local _attr = stringToNumberTable( attr, '_' )
			tab.attr1[_attr[1]] = tab.attr1[_attr[1]] or 0
			tab.attr1[_attr[1]] = tab.attr1[_attr[1]] + _attr[2]
		end
	end

	local temp2 = {}
	for i = 1, #attrList2 do
		if attrList2[i] and attrList2[i] ~= "0" then
			local temp = string.split(attrList2[i], "|")
			local newTab = stringToNumberTable(temp[1], "_")
			local tt = { index = i, value = newTab[2] }
			table.insert(temp2, tt)
		end
	end
	for k,v in pairs(temp2) do
		local resultStr = attrList2[v.index]
		if resultStr then
			local resultTab = string.split(resultStr, "|")
			for k, v in pairs(resultTab) do
				local temp = stringToNumberTable(v, "_")
				local kk = temp[1]
				local vv = temp[2]
				if kk and vv then
					tab.attr2[kk] = tab.attr2[kk] or 0
					tab.attr2[kk] = tab.attr2[kk] + vv
				end
			end
		end
	end
	local temp3 ={}
	for i =1,#attrList3 do 
		if attrList3[i] and attrList3[i] ~= "" then
			local temp = string.split(attrList3[i], "|")
			local newTab = stringToNumberTable(temp[1], "_")
			local tt = { index = i, value = newTab[2] }
			table.insert(temp3, tt)
		end
	end
	for k,v in pairs(temp3) do
		local resultStr = attrList3[v.index]
		if resultStr then
			local resultTab = string.split(resultStr, "|")
			for k, v in pairs(resultTab) do
				local temp = stringToNumberTable(v, "_")
				local kk = temp[1]
				local vv = temp[2]
				if kk and vv then
					self.MingXinSpecialandMain[kk] = self.MingXinSpecialandMain[kk] or 0
					self.MingXinSpecialandMain[kk] = self.MingXinSpecialandMain[kk] + vv
				end
			end
		end
	end
	return tab
end
function CardXinFa:getHoleNumByQuality(quality)
	local count = 0
	for k, v in pairs(self.chongzhuData) do
		if v.quality >= quality then
			count = count + 1
		end
	end
	return count
end
function CardXinFa:getGradeNumPercent()
	self.MingXinPercent = 0
	for k, v in pairs(self.chongzhuData) do
		self.MingXinPercent = self.MingXinPercent + KongfuRefineData:getposGradeNumPercent(self.config.quality, v.pos, v.level)*10
		if v.level < 60 then
			self.MingXinPercent = 0
			return
		end
	end
end
function CardXinFa:getChongzhuDataByIdx(idx)
	idx = idx or 1
	return self.chongzhuData[idx]
end
function CardXinFa:getChongzhuData()
	return self.chongzhuData
end
function CardXinFa:updateGemAttr()
	self.GemAttribute:clear()
	for i = 1, 5 do
		local gemId = self.gemId[i]
		if gemId ~= nil then
			local gemAttr = GemData:objectByID(gemId)
			if gemAttr.attribute and gemAttr.attribute ~= "" then 
            	local attributekind , attributenum = gemAttr:getAttribute()
            	if self:getGemPosIsExtra(i) ~= 0 then
            		if self.GemAddPercent == 0 then 
           				self.GemAttribute:addAttr(attributekind, attributenum * (1 + self:getMulExtra(i) + self:getExtraGemRule(i)[self:getGemPosIsExtra(i)][2] / 10000))
           			else
           				local per = self.GemAddPercent / 10000
           				self.GemAttribute:addAttr(attributekind, attributenum *(1+per)* (1 + self:getMulExtra(i) + self:getExtraGemRule(i)[self:getGemPosIsExtra(i)][2] / 10000))
           			end
           		else
           			local per = self.GemAddPercent / 10000
           			self.GemAttribute:addAttr(attributekind, attributenum *(1+per)* (1 + self:getMulExtra(i)))
           		end
        	end
		end
	end

	self.GemAttribute:updatePower()
end
function CardXinFa:updateMingxin()
	self.MingXinAttribute:clear()

	local attrList = {}
	for k, v in pairs(self.chongzhuData) do
        local tab = KongfuRefineData:getTotalBaseAttribute(self.config.quality, v.pos, v.level) or {}
        for i, j in pairs(tab) do
            attrList[i] = attrList[i] or 0
            attrList[i] = attrList[i] + j
        end
    end
    for attrId, attrValue in pairs(attrList) do
		self.MingXinAttribute:addAttr(attrId, attrValue)
	end
    self.MingXinAttribute:updatePower()
end

function CardXinFa:getDiffTotalAttribute(type,level)
	if type == nil or level == nil then
		return
	end
	self.MingXinSpecialandMain ={}
	--明心额外属性(要在镶嵌宝石前获取宝石加成百分比)
	local extraTab = self:getMingXinExtraAttr() or {}

	local totalAttribute = GameAttributeData:new()
	totalAttribute:clear()
	local mulAttr = self.mulAttr
	--更新突破属性
	if type == 1 then
		mulAttr = KongfuTupoData:GetMulNumByQualityType(self.config.quality,self.config.usable,level)
		local tupoAttribute = GameAttributeData:new()
		tupoAttribute:clear()
		local attrList 	= KongfuTupoData:GetTuPoAttrBySQUK(level,self.config.quality,self.config.usable,self.config.kind)
		if attrList == nil then
			print("tupoattribute nil")
			return
		end
		for attrId, attrValue in pairs(attrList) do
			tupoAttribute:addAttr(attrId, attrValue)
		end
		if self.level < 20 then
			attriList = {}
			tupoAttribute:clear()
		end
		for attrId,value in pairs(tupoAttribute.attribute) do
			totalAttribute:addAttr(attrId, value)
		end
	else
		for attrId,value in pairs(self.tupoAttribute.attribute) do
			totalAttribute:addAttr(attrId, value)
		end
	end
	--更新修炼属性
	if type == 2 then
		local xiulianAttribute = GameAttributeData:new()
		xiulianAttribute:clear()
		local attrList 	= KongfuXiuLianData:GetXiuLianAttrByQualityAndLv(self.config.quality, level, self.config.usable)
		print(attrList)
		if #attrList == 0 then
			print("xiulianAttribute nil")
			return
		end
		for attrId, attrValue in pairs(attrList) do
			xiulianAttribute:addAttr(attrId, attrValue)
		end
		for attrId,value in pairs(xiulianAttribute.attribute) do
			totalAttribute:addAttr(attrId, value * mulAttr)
		end
	else
		for attrId,value in pairs(self.xiulianAttribute.attribute) do
			totalAttribute:addAttr(attrId, value * mulAttr)
		end
	end

	for attrId,value in pairs(self:getTotalNingLianAttribute().attribute) do
		totalAttribute:addAttr(attrId, math.floor(value))
	end

	for attrId,value in pairs(self.GemAttribute.attribute) do
		totalAttribute:addAttr(attrId, math.floor(value))
	end
	for attrId,value in pairs(self.MingXinAttribute.attribute) do
		totalAttribute:addAttr(attrId, math.floor(value))
	end
	--明心额外属性
	local extraList = clone( extraTab.attr2 )
	-- if extraList and next(extraList) ~= nil then
	-- 	for k, v in pairs(extraTab.attr1) do
	-- 		extraList[k] = extraList[k] or 0
	-- 		extraList[k] = extraList[k] + v
	-- 		self.MingXinSpecialandMain[k] = self.MingXinSpecialandMain[k] or 0 
	-- 		self.MingXinSpecialandMain[k] = self.MingXinSpecialandMain[k] + v
	-- 	end
	-- 	for k, v in pairs(extraList) do
	-- 		totalAttribute:addAttr(k, v)
	-- 	end
	-- end
	if extraList and next(extraList) ~= nil then
		for k, v in pairs(extraList) do
			totalAttribute:addAttr(k, v)
		end
	end
	for k, v in pairs(extraTab.attr1) do
		totalAttribute:addAttr(k, v)
		self.MingXinSpecialandMain[k] = self.MingXinSpecialandMain[k] or 0 
		self.MingXinSpecialandMain[k] = self.MingXinSpecialandMain[k] + v
	end
	--明心百分比加成
	local extraList1 = clone( extraTab.attr2 )
	if extraList1 and next(extraList1) ~= nil then 
		for k, v in pairs(extraList1) do
			totalAttribute:addAttr(k, math.floor(self.MingXinPercent))
		end
	end
	totalAttribute:refreshBypercent()
	return totalAttribute
end

--获得突破属性
function CardXinFa:getTupoAttribute()
	return self.tupoAttribute
end

--获得修炼属性
function CardXinFa:getXiuLianAttribute()
	return self.xiulianAttribute
end

function CardXinFa:getTotalNingLianAttribute()
	local tmp = GameAttributeData:new()
	for i = 1, 5 do
		for k,v in pairs(self.NingLianHoleAttribute[i].attribute) do 
			tmp:addAttr(k,v)
		end
	end
	for k,v in pairs(self.extraGemAttr.attribute) do
		tmp:addAttr(k,v)
	end
	tmp:refreshBypercent()
	return tmp
end

function CardXinFa:getNingLianAttribute(pos)
	return self.NingLianHoleAttribute[pos]
end

function CardXinFa:getExtraAttribute()
	return self.extraGemAttr
end

--获得总属性
function CardXinFa:getTotalAttribute()
	return self.totalAttribute
end


return CardXinFa