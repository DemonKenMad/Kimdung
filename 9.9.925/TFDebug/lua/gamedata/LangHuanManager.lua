--[[
******琅环福地管理类*******

	-- by shenjingjie
	-- 2017/7/19	
]]

local LangHuanManager = class("LangHuanManager")

LangHuanManager.MaxTreasuresNum = 3  	-- 最大珍品数量
LangHuanManager.MaxBoutiqueNum = 5		-- 最大精品数量
LangHuanManager.PoolType_Treasures = 1
LangHuanManager.PoolType_Boutique = 2

LangHuanManager.MaxTreasuresPoolNum = 8
LangHuanManager.MaxBoutiquePoolNum = 12
LangHuanManager.PoolCol = 4

LangHuanManager.zhuanPanNum = 8

LangHuanManager.LangBlesseSelectResponse = "LangHuanManager.LangBlesseSelectResponse"
LangHuanManager.LangBlessedConfigResponse = "LangHuanManager.LangBlessedConfigResponse"
LangHuanManager.LangBlessedPrayResponse = "LangHuanManager.LangBlessedPrayResponse"
LangHuanManager.LangBlessedRecord		= "LangHuanManager.LangBlessedRecord"

function LangHuanManager:ctor()
	TFDirector:addProto(s2c.LANG_BLESSED_CONFIG_RESPONSE, self, self.onReceiveLangHuanGoodsInfo)
	TFDirector:addProto(s2c.LANG_BLESSE_SELECT_RESPONSE, self, self.onReceiveSelectPool)	
	TFDirector:addProto(s2c.LANG_BLESSED_PRAY_RESPONSE, self, self.onReceivePrayInfo)
	TFDirector:addProto(s2c.LANG_BLESSED_HISTORY_RESPONSE, self, self.onReceiveHistoryRecord)
		
	self.rewardPoolInfo = {}	
	self.selectPoolInfo = {}
	self.recordInfo	= {}
end

--清零
function LangHuanManager:restart()
	self.rewardPoolInfo = {}	
	self.selectPoolInfo = {}
	self.recordInfo	= {}

end

-----------------------onReceive-------------------------------->>
function LangHuanManager:onReceiveLangHuanGoodsInfo(event)
	-- s2c.LANG_BLESSED_CONFIG_RESPONSE = 0x4d01 琅嬛福地配置信息
	hideLoading()
	local data = event.data
	--print("琅嬛福地配置信息",data)
	local treasuresPoolInfo = {}
	local boutiquePoolInfo = {}
	--配置信息
	for _, reward in pairs(data.items) do
		if (reward.kind == self.PoolType_Treasures) then
			reward.itemId = reward.goodId
			reward.type = EnumDropType.GOODS
			treasuresPoolInfo[reward.id] = reward
		elseif (reward.kind == self.PoolType_Boutique) then
			reward.itemId = reward.goodId
			boutiquePoolInfo[reward.id] = reward
		end	
	end
	self.rewardPoolInfo[self.PoolType_Treasures] = treasuresPoolInfo
	self.rewardPoolInfo[self.PoolType_Boutique] = boutiquePoolInfo

	--奖励池选择
	if (data.selected ~= nil) then
		for _, reward in pairs(data.selected) do
			reward.itemId = reward.goodId
			reward.type = EnumDropType.GOODS
			reward.index = tonumber(reward.index)
			self.selectPoolInfo[reward.index] = reward
		end
	end
	TFDirector:dispatchGlobalEventWith(self.LangBlessedConfigResponse,{})
end


function LangHuanManager:onReceiveSelectPool( event )
	-- s2c.LANG_BLESSE_SELECT_RESPONSE = 0x4d02  琅嬛福地选择奖池
	hideLoading()

	TFDirector:dispatchGlobalEventWith(self.LangBlesseSelectResponse,{})
end

function LangHuanManager:onReceivePrayInfo( event )
	-- s2c.LANG_BLESSED_PRAY_RESPONSE = 0x4d03 琅嬛福地祈福
	hideLoading()

	TFDirector:dispatchGlobalEventWith(self.LangBlessedPrayResponse,event.data)
end

function LangHuanManager:onReceiveHistoryRecord( event )
	-- s2c.LANG_BLESSED_HISTORY_RESPONSE = 0x4d04 琅嬛福地获奖记录
	hideLoading()

	self.recordInfo	= {}
	local info = event.data
	if (info and info.records ~= nil) then

		local recodeData = info.records
		for i = 1, #recodeData , 1 do 
			local goodsInfo = string.split(recodeData[i].rewards, '|')
			local goodsData = {}
			goodsData.time = recodeData[i].time
			goodsData.playerName = recodeData[i].playerName
			for k, v in pairs(goodsInfo) do
				local recodeGoods = {}
				local strData = string.split(v, '_')
				recodeGoods.type = EnumDropType.GOODS
				recodeGoods.itemId = tonumber(strData[2])
				recodeGoods.number = tonumber(strData[3])				
				table.insert(goodsData, k, recodeGoods)	
			end		
			table.insert(self.recordInfo, i, goodsData)	
		end
	end
	table.sort( self.recordInfo, function(a, b) return a.time > b.time end )
	TFDirector:dispatchGlobalEventWith(LangHuanManager.LangBlessedRecord,{})
end


--------------------------request---------------------------------------->>
function LangHuanManager:requestConfigInfo()
	showLoading()
	-- c2s.LANG_BLESSED_CONFIG_REQUEST = 0x4d01 请求琅嬛福地配置
	
	TFDirector:send(c2s.LANG_BLESSED_CONFIG_REQUEST ,{})
end

function LangHuanManager:requestSeletPool( selectPool )
	showLoading()
	self.selectPoolInfo = selectPool
	-- c2s.LANG_BLESSED_SELET_REQUEST = 0x4d02 请求琅嬛福地选择奖池

	local tab = {}
	local items = {}
	local idx = 1
	for k,v in pairs(selectPool) do
		
		if (v.id ~= nil) then
			--print("v = ",k,v)
			tab[idx] = {v.id,v.index,v.kind}
			idx = idx + 1
		end
	end

	local Msg = {
		tab,
	}	
	print("Msg = ", Msg)
	TFDirector:send(c2s.LANG_BLESSED_SELET_REQUEST ,Msg)
end

function LangHuanManager:requestPray( type )
	showLoading()
	-- c2s.LANG_BLESSED_PRAY_REQUEST = 0x4d03 请求琅嬛福地祈福
	TFDirector:send(c2s.LANG_BLESSED_PRAY_REQUEST ,{type})
end

function LangHuanManager:requestPrayRecord( type )
	showLoading()
	-- c2s.LANG_BLESSED_HISTORY_REQUEST = 0x4d04 请求琅嬛福地记录
	if type == 1 then
		print("请求琅嬛福地个人记录")
	elseif type == 2 then
		print("请求琅嬛福地玩家记录")
	end
	TFDirector:send(c2s.LANG_BLESSED_HISTORY_REQUEST ,{type})
end



function LangHuanManager:getRewardPool( type )
	if (type == nil) then
		return self.rewardPoolInfo or {}
	else
		return self.rewardPoolInfo[type] or {}
	end
end

function LangHuanManager:getSelectInfo()
	return self.selectPoolInfo
end

function LangHuanManager:getRecordInfo()
	return self.recordInfo
end

function LangHuanManager:isGoodsInSelect( id )
	for k,v in pairs(self.selectPoolInfo) do
		if (v.id == id) then
			return true
		end
	end
	return false
end


function LangHuanManager:openLangHuanMainLayer()
	self:requestConfigInfo()
	AlertManager:addLayerByFile("lua.logic.gameactivity.LangHuanMainLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
	AlertManager:show()
end

function LangHuanManager:openLangHuanChooseLayer()

	AlertManager:addLayerByFile("lua.logic.gameactivity.LangHuanChooseLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
	AlertManager:show()
end

function LangHuanManager:openLangHuanRecodeLayer()
    AlertManager:addLayerByFile("lua.logic.gameactivity.LangHuanRecodeLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show()
end

function LangHuanManager:showRuleLayer()
    CommonManager:showRuleLyaer( 'langhuanfd' )
end

return LangHuanManager:new()