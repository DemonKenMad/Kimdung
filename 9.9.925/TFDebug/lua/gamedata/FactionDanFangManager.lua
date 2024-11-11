--[[
******帮派丹房数据管理类*******

	-- by sjj
	-- 2018/4/26
	
]]

local FactionDanFangManager = class("FactionDanFangManager")
FactionDanFangManager.refreshDanFangMsg = "FactionDanFangManager.refreshDanFangMsg"
FactionDanFangManager.refreshMyDanFangMsg = "FactionDanFangManager.refreshMyDanFangMsg"


function FactionDanFangManager:ctor(data)
	self.myMaterialData = nil
	self.otherHelpInfo = {}
	self.myDanFangInfo = nil
	self.danFangRedPoint = false
	self.DanFangData = require('lua.table.t_s_lianhua_cailiao') 

	--丹房主要信息 0x5e01
	TFDirector:addProto(s2c.GUILD_DAN_FANG_RESPONSE, self, self.onDanFangInfoMsgReceive) 
	--单个丹房信息 0x5e05
	TFDirector:addProto(s2c.DAN_FANG_DETIALS, self, self.onDanFangOnesInfoMsgReceive) 
	--丹房红点 0x5e06 
	TFDirector:addProto(s2c.DAN_FANG_RED_POINT, self, self.onDanFangRedPointMsgReceive) 
end

--接受丹房信息 
function FactionDanFangManager:onDanFangInfoMsgReceive( event )
	-- s2c.GUILD_DAN_FANG_RESPONSE 0x5e01
	hideLoading()
	self.otherHelpInfo = event.data.detials
	self.myDanFangInfo = event.data.myDetials
	if (self.myDanFangInfo) then
		self.myDanFangInfo.totalTime = (self.myDanFangInfo.endTime - self.myDanFangInfo.createTime) * 0.001
	end
	-- for i = 1, #event.data.detials do 
	-- 	local itemInfo = event.data.detials[i]
	-- 	self.otherHelpInfo[itemInfo.playerId] = itemInfo
	-- end

	self:refreshHelpInfo()

	self:openMainLayer()
	-- TFDirector:dispatchGlobalEventWith(self.refreshDanFangMsg,{})
end
--接受丹房信息 
function FactionDanFangManager:onDanFangOnesInfoMsgReceive( event )
	-- s2c.DAN_FANG_DETIALS 0x5e05
	hideLoading()
	
	-- -- self.myDanFangInfo = event.data.myDetials

	-- self:initHelpInfo()
	if (event.data.playerId == MainPlayer:getPlayerId()) then
		self.myDanFangInfo = event.data
		self:refreshMyDetialsInfo()
	else
		local item = self:getOtherInfoById(event.data.playerId)
		if (item) then
			item.endTime = event.data.endTime
			item.state = event.data.state
			item.helper = event.data.helper
		else
			item = event.data
			local num = #self.otherHelpInfo
			item.key = num + 1
			table.insert(self.otherHelpInfo, item)
		end
		
		self:refreshOnesHelpInfo(item.key)
	end
	
	
end
--丹房红点 0x5e06 
function FactionDanFangManager:onDanFangRedPointMsgReceive( event )
	-- s2c.DAN_FANG_RED_POINT 0x5e06
	-- 0显示红点,1不显示
	print("0显示红点,1不显示",event.data.state)
	if (event.data.state == 0) then
		self.danFangRedPoint = true
	else
		self.danFangRedPoint = false
	end
	TFDirector:dispatchGlobalEventWith(FactionManager.refreshWindow ,{})
end

--本帮丹房信息
function FactionDanFangManager:sendDanFangInfo()
	--c2s.GUILD_DAN_FANG_INFO_REQUEST 0x5e01
	TFDirector:send(c2s.GUILD_DAN_FANG_INFO_REQUEST,{})
	showLoading()
end

--请求升级的材料
function FactionDanFangManager:sendMaterialUp( id )
	--c2s.GUILD_DAN_FANG_LEVEL_UP_REQUEST 0x5e02
	print("请求升级的材料",id)
	TFDirector:send(c2s.GUILD_DAN_FANG_LEVEL_UP_REQUEST,{ id })
	showLoading()
end

--请求助力
function FactionDanFangManager:sendHelpInfo( toPlayer )
	--c2s.GUILD_DAN_FANG_HELPER_REQUEST 0x5e03
	TFDirector:send(c2s.GUILD_DAN_FANG_HELPER_REQUEST,{ toPlayer })
	showLoading()
end

--领取`
function FactionDanFangManager:sendReceiveMsg()
	--c2s.GUILD_DAN_FANG_RECIVER_REQUEST 0x5e04
	TFDirector:send(c2s.GUILD_DAN_FANG_RECIVER_REQUEST,{})
	showLoading()
end

-----------------------------以下是数据处理---------------------------------------------
function FactionDanFangManager:openMainLayer()
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.faction.FactionDanFangLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_NONE)
	AlertManager:show()
end

-- function FactionDanFangManager:openMaterialSelectLayer(layer)
-- 	self:setMyMaterialData()
-- 	local layer = AlertManager:addLayerByFile("lua.logic.faction.FactionDanFangSelectLayer",AlertManager.BLOCK)
-- 	AlertManager:show()
-- 	layer:setData()
-- 	layer.blockUI:setTouchEnabled(false);
-- end

--我可以升级的材料
function FactionDanFangManager:setMyMaterialData()
	--查找背包里面是否有表里的材料
	self.myMaterialData = {}
	local index = 1
	for item in DanFangData:iterator() do
		local itemNum = BagManager:getItemNumById( item.id_cailiao )
		if (itemNum ~= 0 ) then
			self.myMaterialData[index] = {}
			self.myMaterialData[index].hasNum = itemNum
			self.myMaterialData[index].needNum = item.num
			self.myMaterialData[index].num_shouhuo = item.num_shouhuo
			self.myMaterialData[index].id = item.id
			self.myMaterialData[index].itemId = item.id_cailiao
			self.myMaterialData[index].upId = item.id_shouhuo
			local isCanUp = false
			if (itemNum >= item.num) then
				isCanUp = true
			end
			self.myMaterialData[index].isCanUp = isCanUp
			index = index + 1
		end	
	end

end
function FactionDanFangManager:getMyMaterialData()
	return self.myMaterialData 
end

function FactionDanFangManager:getMyMaterialDataById(Id)
	return self.myMaterialData[Id]
end
--解析帮派求助信息
function FactionDanFangManager:refreshHelpInfo()
	if (self.otherHelpInfo) then
		for id ,itemInfo in pairs(self.otherHelpInfo) do 
			itemInfo.key = id
			itemInfo.totalTime = (itemInfo.endTime - itemInfo.createTime) * 0.001
			itemInfo.overplusTime = itemInfo.endTime * 0.001 - MainPlayer:getNowtime()
			itemInfo.isHelp = false
			if (itemInfo.helper) then
				for i = 1, #itemInfo.helper do 
					if (itemInfo.helper[i] == MainPlayer:getPlayerId()) then
						itemInfo.isHelp = true
						break;
					end
				end
			end
		end
		self:sortHelpDataByOverplusTime()
	else
		self.otherHelpInfo = {}
	end
end

--解析帮派单个信息
function FactionDanFangManager:refreshOnesHelpInfo(refreshKey)
	-- self.otherHelpInfo[refreshId]

	if (self.otherHelpInfo[refreshKey].state == 1) then
		-- 目标已被领取,删掉信息
		local index = 0
		self.otherHelpInfo[refreshKey] = nil
		for  i = refreshKey, #self.otherHelpInfo do 
			self.otherHelpInfo[i] = self.otherHelpInfo[i + 1]
			index = i
		end
		self.otherHelpInfo[index] = nil
	else
		self.otherHelpInfo[refreshKey].totalTime = (self.otherHelpInfo[refreshKey].endTime - self.otherHelpInfo[refreshKey].createTime) * 0.001
		self.otherHelpInfo[refreshKey].overplusTime = self.otherHelpInfo[refreshKey].endTime * 0.001 - MainPlayer:getNowtime()
		self.otherHelpInfo[refreshKey].isHelp = false
		if (self.otherHelpInfo[refreshKey].helper) then
			for i = 1, #self.otherHelpInfo[refreshKey].helper do 
				if (self.otherHelpInfo[refreshKey].helper[i] == MainPlayer:getPlayerId()) then
					self.otherHelpInfo[refreshKey].isHelp = true
					break;
				end
			end
		end
		
	end
	self:sortHelpDataByOverplusTime()

	TFDirector:dispatchGlobalEventWith(self.refreshDanFangMsg,{refreshKey})
end
--解析自己的丹房信息
function FactionDanFangManager:refreshMyDetialsInfo()
	if (self.myDanFangInfo.state == 0) then
		self.myDanFangInfo.totalTime = (self.myDanFangInfo.endTime - self.myDanFangInfo.createTime) * 0.001
	end

	TFDirector:dispatchGlobalEventWith(self.refreshMyDanFangMsg,{})

end

function FactionDanFangManager:sortHelpDataByOverplusTime()

	local function sortByOverplusTime(v1, v2)
		return v1.overplusTime > v2.overplusTime
	end
	if (#self.otherHelpInfo > 2) then
		table.sort(self.otherHelpInfo, sortByOverplusTime)
	end

	for id ,itemInfo in pairs(self.otherHelpInfo) do 
		itemInfo.key = id
	end
end
function FactionDanFangManager:getMyInfo()
	return self.myDanFangInfo
end

function FactionDanFangManager:getOtherInfo()
	return self.otherHelpInfo
end
function FactionDanFangManager:getOtherInfoById(id)
	if (#self.otherHelpInfo>0) then
		for k,item in pairs(self.otherHelpInfo) do 
			if (id == item.playerId) then
				return item
			end
		end
	end
	return nil
end


--打开规则
function FactionDanFangManager:showRuleLayer()
    CommonManager:showRuleLyaer( 'bangpaidanfang' )
end

--返回红点信息
function FactionDanFangManager:getRedPointInfo()
	return self.danFangRedPoint

end


return FactionDanFangManager:new()