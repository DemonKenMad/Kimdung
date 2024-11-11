--
-- Author: yejiawei
-- Date: 2017-02-28 17:09:29
--
local CardXinFa      = require('lua.gamedata.base.CardXinFa');

local XinFaManager = class("XinFaManager",TFArray)
--最高品质
XinFaManager.MAX_QUALITY 	= KongfuComData:getXinFaMaxQuality()
XinFaManager.MAX_LEVEL 		= KongfuXiuLianData:GetXiuLianMaxLv()

XinFaManager.select_type_xiulian 	= 1 		--修炼
XinFaManager.select_type_tupo 		= 2 		--突破
XinFaManager.select_type_mingxin	= 3 		--明心
XinFaManager.select_type_ninglian	= 4 		--凝练
XinFaManager.select_type_xiangqian 	= 5 		--镶嵌
XinFaManager.select_type_hecheng 	= 6 		--合成

XinFaManager.BagPanelLayer			= 1
XinFaManager.PlayPanelLayer			= 2	

XinFaManager.UpLevel 				= "XinFaManager.UpLevel"
XinFaManager.HeartMethodMerge 		= "XinFaManager.HeartMethodMerge"
XinFaManager.XinfaTupoBreach 		= "XinFaManager.XinfaTupoBreach"
XinFaManager.XinFaSell 				= "XinFaManager.XinFaSell"
XinFaManager.EQUIP_OPERATION 		= "XinFaManager.EQUIP_OPERATION"
XinFaManager.UNEQUIP_OPERATION 		= "XinFaManager.UNEQUIP_OPERATION"
XinFaManager.HEART_METHOD_CHANGE 	= "XinFaManager.HEART_METHOD_CHANGE"
XinFaManager.NingLian 				= "XinFaManager.NingLian"
XinFaManager.GemInfo 				= "XinFaManager.GemInfo"
XinFaManager.ServerSwitchChange 	= "XinFaManager.ServerSwitchChange"
XinFaManager.RESPONSE_HEART_EXCHANGE = "XinFaManager.RESPONSE_HEART_EXCHANGE"

XinFaManager.sell_type_35_5 = 1 	-- 1.全本（类型35，品质5）
XinFaManager.sell_type_35_4 = 2 	-- 2.残篇以下（类型35，品质<5）
XinFaManager.sell_type_36_5 = 3 	-- 3.全本碎片（类型36，品质5）
XinFaManager.sell_type_36_4 = 4 	-- 4.残篇以下碎片（类型36，品质<5）
XinFaManager.sell_type_35   = 5 	-- 5.所有整本（类型35）
XinFaManager.sell_type_36   = 6 	-- 6.所有碎片（类型36）
XinFaManager.MianXinMaxLevel   = 200 	--明心最大等级


function XinFaManager:ctor()
	TFDirector:addProto(s2c.ALL_HEART_METHOD_INFO , self, self.updateXinFaList)
	TFDirector:addProto(s2c.HEART_METHOD_INFO , self, self.updateSingleXinFaList)
	TFDirector:addProto(s2c.HEART_METHOD_SYNTHESIS , self, self.updateSingleXinFaList)
	--心法突破
	TFDirector:addProto(s2c.HEART_METHOD_BREACH, self, self.onTopoResponse)
	TFDirector:addProto(s2c.HEART_METHOD_PRACTICE , self, self.reciveXiuLianData)
	--心法装配
	TFDirector:addProto(s2c.EQUIP_HEART_METHOD, self, self.onReceiveXinFaEquip)
	TFDirector:addProto(s2c.UN_EQUIP_HEART_MEHOD, self, self.onReceiveXinFaUnEquip)
	TFDirector:addProto(s2c.HEART_METHOD_SELL , self, self.UpdateXinFaSell)
	--心法凝练
	TFDirector:addProto(s2c.HEART_METHOD_CONCISE_INFO, self, self.onReceiveXinFaNingLian)
	TFDirector:addProto(s2c.HEART_METHOD_GEM_INFO, self, self.onReceiveXinFaGemInfo)
	--心法删除
	TFDirector:addProto(s2c.HEART_METHOD_CHANGE , self, self.HeartMethodChange)
	--心法置换
	TFDirector:addProto(s2c.RESPONSE_HEART_EXCHANGE , self, self.ResponseHeartExChange)
	self.super.ctor(self)
	self.XinFaList = TFArray:new()
	self.XinFaInfoList = {}

end

function XinFaManager:restart()
	self.XinFaList:clear()
	self.XinFaInfoList = {}
end

function XinFaManager:sendHeartMethodMerge(id)
	local msg = {id}
	-- showLoading()
	TFDirector:send(c2s.REQUEST_HEART_METHOD_SYNTHESIS,msg)
end

function XinFaManager:sendHeartMethodXiuLian(isOneKey, levelid, gmid)
	local msg = {isOneKey, levelid, gmid}
	print("XinFaManager:sendHeartMethodXiuLian",msg)
	showLoading()
	TFDirector:send(c2s.REQUEST_HEART_METHOD_PRACTICE,msg)
end

function XinFaManager:sendHeartMethodNingLian(instanceId, pos)
	local msg = {instanceId, pos}
	print("XinFaManager:sendHeartMethodNingLian",msg)
	showLoading()
	TFDirector:send(c2s.REQUEST_HEART_CONCISE,msg)
end

function XinFaManager:sendHeartMethodGemMosaic(instanceId, gemId, pos)
	local msg = {instanceId, gemId, pos}
	showLoading()
	TFDirector:send(c2s.REQUEST_HEART_GEM_MOSAIC,msg)
end

function XinFaManager:sendHeartMethodGemUnMosaic(instanceId, pos)
	local msg = {instanceId, pos}
	showLoading()
	TFDirector:send(c2s.REQUEST_HEART_GEM_UN_MOSAIC,msg)
end

function XinFaManager:UpdateXinFaSell(event)
	hideLoading()
	local data = event.data.instanceId
	
	if data == nil then
		return
	end
	for i=1,#data do
		self:sellXinFaByGmid(data[i])
	end
	
 	self:setXinFaSellListByType()
	TFDirector:dispatchGlobalEventWith(XinFaManager.XinFaSell,{})
end

function XinFaManager:sendEquipHeartMethod(roleId,gmid,itemid)
	local msg = {roleId,gmid,itemid}
	showLoading()
	TFDirector:send(c2s.REQUEST_EQUIP_HEART_METHOD,msg)
end

function XinFaManager:sendUnEquipHeartMethod(roleId, gmid)
	local msg = {roleId,gmid}
	showLoading()
	TFDirector:send(c2s.REQUEST_UNEQUIP_HEART_MEHOD,msg)
end

function XinFaManager:onReceiveXinFaEquip(event)
	local data = event.data
	-- print("*********XinFaManager:onReceiveBibleEquip********** roleId = ", data.roleId)
	-- print("*********XinFaManager:onReceiveBibleEquip********** xinfa = ", data.heartMid)
	-- print("*********XinFaManager:onReceiveBibleEquip********** dropMid = ", data.dropMid)

	hideLoading()

	local role = CardRoleManager:getRoleByGmid(data.roleId)
	local oldequip = nil
	oldequip = role:getXinFa()
	if role == nil then 
		print("role == nil")
		return
	end

	local equip = self:getXinFaByGmId(data.heartMid)
	if oldequip then
		role:delXinFa()
	end
	role:setXinFa(equip)
	role:updateXinFaAttr()

	TFDirector:dispatchGlobalEventWith(XinFaManager.EQUIP_OPERATION, {gmId = role.gmId, equip = equip})
	TFDirector:dispatchGlobalEventWith("XinFaChangeEnd", {}) 
end

function XinFaManager:onReceiveXinFaUnEquip(event)
	local data = event.data
	-- print("*********XinFaManager:onReceiveBibleUnEquip********** roleId = ", data.roleId)
	-- print("*********XinFaManager:onReceiveBibleUnEquip********** heartMid = ", data.heartMid)
	hideLoading()

	local role = CardRoleManager:getRoleByXinFaInstanceId(data.heartMid)
	local equip = self:getXinFaByGmId(data.heartMid)
	if role == nil or equip == nil then 
		print("role == nil or equip == nil")
		return
	end
	oldequip = role:getXinFa()
	if oldequip then
		role:delXinFa()
	end
		
	role:delXinFa()
	role:updateXinFaAttr()
	TFDirector:dispatchGlobalEventWith(XinFaManager.UNEQUIP_OPERATION, {gmId = role.gmId, equip = equip})
	TFDirector:dispatchGlobalEventWith("XinFaChangeEnd", {})
end

function XinFaManager:reciveXiuLianData(event)
	hideLoading()
	local info = event.data
	local cardxinfa = self:getXinFaByGmId(info.instanceId)
	cardxinfa:setdifferLevel(info.id)
	cardxinfa:setlevelid(info.id)
	TFDirector:dispatchGlobalEventWith(XinFaManager.UpLevel, {})
end

function XinFaManager:onReceiveXinFaGemInfo(event)
	hideLoading()
	print("onReceiveXinFaGemInfo",event.data)
	TFDirector:dispatchGlobalEventWith(XinFaManager.GemInfo, {event.data})
end

function XinFaManager:onReceiveXinFaNingLian(event)
	hideLoading()
	-- print("onReceiveXinFaNingLian",event)
	TFDirector:dispatchGlobalEventWith(XinFaManager.NingLian, {event.data})
end

function XinFaManager:IsNingLianOpen(gmId)
	if (MainPlayer:getServerSwitchStatue(ServerSwitchType.XinFaNingLian)) then
		local info = self:getXinFaByGmId(gmId)
		if(info and info.config.quality >= 4) then
			return true
		end
	end
	return false
end
function XinFaManager:IsMingXinOpen(gmId)
	if (MainPlayer:getServerSwitchStatue(ServerSwitchType.XinFaMingXin)) then
		local info = self:getXinFaByGmId(gmId)
		if(info and info.config.quality >= 4) then
			return true
		end
	end
	return  false
end
--[[
	--通过id获得背包道具信息
	--@返回道具
]]
function XinFaManager:getItemById( id )
	--print("getItem by : ",id)
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.config.id == id then
			return v
		end
	end
end

local function sortlistByPower(v1,v2)
	if v1.equip and v2.equip == nil then
    	return true
    elseif v2.equip and v1.equip == nil then 
    	return false
    end
	if v1:getpower() > v2:getpower() then
        return true;
    elseif v1:getpower() == v2:getpower() then
        if v1.config.quality > v2.config.quality then
            return true;
        elseif v1.config.quality == v2.config.quality then
            if v1.instanceId > v2.instanceId then
                return true;
            end
        end 
    end
end 


--心法列表
function XinFaManager:updateXinFaList(event)
	local info = event.data.heartMethodInfo
	if (info == nil) then
		return
	end 
	
	for i,v in ipairs(info) do
		self:addCardXinFa(v)
	end
	self.XinFaList:sort(sortlistByPower)
end

--单个心法
function XinFaManager:updateSingleXinFaList(event)
	--print("单个心法 ",event.data)
	hideLoading()
	local info = event.data
	if (info == nil) then
		return
	end
	self:addCardXinFa(info)
	TFDirector:dispatchGlobalEventWith(self.HEART_METHOD_CHANGE, {})
end

function XinFaManager:HeartMethodChange(event)
	print("删除心法 ",event.data)
	local info = event.data.removeXinfa
	if not info then
		toastMessage(localizable.common_data_error)
		return
	end
	local name = 0
	for i,id in ipairs(info) do
		for _, v in ipairs(self.XinFaList.m_list) do
			if v.instanceId == id then
				-- print(v)
				name = v.config.name
				self.XinFaList:removeObject(v)
				break
			end
		end
	end
	TFDirector:dispatchGlobalEventWith(self.HEART_METHOD_CHANGE, {})
end
function XinFaManager:ResponseHeartExChange(event)
	hideLoading()
	TFDirector:dispatchGlobalEventWith(XinFaManager.RESPONSE_HEART_EXCHANGE, {})
end

function XinFaManager:addCardXinFa(info)
	if (info and info.itemId and info.itemId ~= 0) then
		local xinfaId 	= info.instanceId
		local cardXinFa	= self:getXinFaByGmId(xinfaId)
		if cardXinFa ~= nil then
			cardXinFa:setData(info)	
		else
			cardXinFa = CardXinFa:new(xinfaId);
			cardXinFa:setData(info)	
			TFDirector:dispatchGlobalEventWith(XinFaManager.HeartMethodMerge,info)		
			self.XinFaList:push(cardXinFa)
		end
	end
end

function XinFaManager:sellXinFaByGmid(gmId)
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.instanceId == gmId then
			return self.XinFaList:removeObject(v)
		end
	end
	
	return nil
end

function XinFaManager:sendHeartMethodBreach(id,gmId)
	showLoading()
	local msg = {id,gmId}
	TFDirector:send(c2s.REQUEST_HEART_METHOD_BREACH, msg)
end
function XinFaManager:onTopoResponse(event)
	hideLoading()
	local info = self:getXinFaByGmId(event.data.instanceId)
	info:setstarid(event.data.id)
	TFDirector:dispatchGlobalEventWith(XinFaManager.XinfaTupoBreach,event.data)

end
function XinFaManager:sendRequestHeArtRecast(Id,pos)
	showLoading()
	TFDirector:send(c2s.REQUEST_HEART_RECAST, {Id,pos})
end

function XinFaManager:getAllXinFa()
	local XinFaArray = TFArray:new()
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.config.type == 35 and v.config.kind == 1 then
			XinFaArray:push(v)
		end
	end
	XinFaArray:sort(sortlistByPower)

	return XinFaArray
end

function XinFaManager:getAllXinFaPiece()
	local XinFaArray = TFArray:new()
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.config.type == 36 then
			XinFaArray:push(v)
		end
	end
	XinFaArray:sort(sortlistByPower)

	return XinFaArray
end

function XinFaManager:getXinFaPieceNumById(id)
	local XinFaArray = TFArray:new()
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.config.id == id then
			return v.number
		end
	end
	return 0
end

function XinFaManager:getAllUnEquippedXinFa()
	local xinFaArray = TFArray:new()
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.equip == nil or v.equip == 0 then
			if v.config.type == 35 then 
				xinFaArray:push(v)
			end
		end
	end
	xinFaArray:sort(sortlistByPower)

	return xinFaArray
end

function XinFaManager:getAllEquippedXinFa()
	local xinFaArray = TFArray:new()
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.equip and v.equip ~= 0 then
			if v.config.type == 35 then 
				xinFaArray:push(v)
			end
		end
	end
	xinFaArray:sort(sortlistByPower)

	return xinFaArray
end


function XinFaManager:openXinFaMainLayer(gmId,type)
    local layer = require("lua.logic.xinfa.XinFaMainLayer"):new(gmId,type)
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_NONE)
    AlertManager:show()
end

function XinFaManager:openEquipOperationLayer(gmId,index,type)
	local layer = require("lua.logic.xinfa.XinFaPanelLayer"):new()
	layer:loadData(gmId, index,type)
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_NONE)
    AlertManager:show()
end
function XinFaManager:openXinFaZhiHuanLayer(gmId)
	local layer = require("lua.logic.xinfa.XinFaZhihuanLayer"):new()
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_NONE)
    AlertManager:show()
    if gmId then
		layer:setSelectId(gmId)
	end
end

function XinFaManager:getIdenticalXinFaStuffNum(id,gmId)
	local num = 0
	for _, info in ipairs(self.XinFaList.m_list) do
		if info.config.id == id and info.instanceId ~= gmId and info:Whetherculture() == false then
			num = num + 1
		end
	end
	return num
end

function XinFaManager:getIdenticalXinFaMaxNumById(id)
	local num = 0
	for _, info in ipairs(self.XinFaList.m_list) do
		if info.config.id == id then
			num = num + 1
		end
	end
	return num
end
function XinFaManager:getXinFaByGmId(xinfaId)
	local xinfaInfo = nil
	for _, info in ipairs(self.XinFaList.m_list) do
		if (info.instanceId == xinfaId) then
			xinfaInfo = info	
			return xinfaInfo
		end
	end
	return xinfaInfo
end

function XinFaManager:getIdenticalXinFaMAxNum()
	local num = 0
	for _, info in ipairs(self.XinFaList.m_list) do
		if info.config.type == 35 then
			num = num + 1
		end
	end
	return num
end

function XinFaManager:getXinFaIndexByGmid(gmId)
	local num = 0
	for _, info in ipairs(self.XinFaList.m_list) do
		num = num + 1
		if info.instanceId == gmId then
			return num
		end
	end
	return 0
end

function XinFaManager:getXinFaByIndex(index,bool)
	local info = nil
	for i = 1 , #self.XinFaList.m_list do 
		if index >#self.XinFaList.m_list then 
			return nil
		end
		info = self.XinFaList:objectAt(index)
		if info and info.config and info.config.type == 35 and info.config.kind == 1 then
			return info
		end 

		if bool == true then  
			index = index + 1
		else
			index = index - 1
		end
	end
	return info
end

function XinFaManager:getXinFaSellList(xinfaInfo)
	-- local XinFaSellList  = TFArray:new();
	-- local ZhuXin = 0
	-- local ValueCost2 = 0
	-- local TupoList    = KongfuTupoData:GetAllCostByQualityAndLv(xinfaInfo.config.quality,xinfaInfo.star,xinfaInfo.config.usable)
	-- local XiuLianList = KongfuXiuLianData:GetAllCostByQualityAndLv(xinfaInfo.config.quality,xinfaInfo.level,xinfaInfo.config.usable)
	-- local NinglianList = KongfuGemData:GetAllUpdateCostByQualityAndLv(xinfaInfo)
	-- local MingXinList  = KongfuRefineData:GetAllUpdateConsumeByChongzhu(xinfaInfo.chongzhuData,xinfaInfo.config.quality)
	-- local cost1Num = 0
	-- local cost2Num = 0
	-- local NingLian = false
	-- local XinFaPercent = ConstantData:objectByID("KongfuMethodSellbackDiscount").value or 75
	-- XinFaPercent = XinFaPercent / 100
	-- if xinfaInfo.config.kind == 2 then
	-- 	ValueCost2  = ConstantData:objectByID("KongfuMethodSellbackQuality"..xinfaInfo.config.quality.."Special").value
	-- else
	-- 	ValueCost2  = ConstantData:objectByID("KongfuMethodSellbackQuality"..xinfaInfo.config.quality).value
	-- end
	-- if TupoList and TupoList[1].itemNum then 
	-- 	cost1Num = cost1Num + TupoList[1].itemNum
	-- end
	-- if TupoList and TupoList[2].itemNum then 
	-- 	cost2Num = cost2Num + TupoList[2].itemNum
	-- end
	-- if XiuLianList and XiuLianList[1].itemNum then 
	-- 	cost1Num = cost1Num + XiuLianList[1].itemNum
	-- end
	-- if XiuLianList and XiuLianList[2].itemNum then 
	-- 	cost2Num = cost2Num + XiuLianList[2].itemNum
	-- end
	-- ZhuXin = ((cost2Num * ValueCost2) + cost1Num) * XinFaPercent + ValueCost2
	-- if ZhuXin ~= 0 then 
	-- 	local rewardInfo = {}
	-- 	rewardInfo.type = EnumDropType.ZHUXIN
 --        rewardInfo.itemId = TupoList[1].itemId
 --        rewardInfo.number = math.floor(ZhuXin)
 --        local _rewardInfo = BaseDataManager:getReward(rewardInfo)
 --        XinFaSellList:push(_rewardInfo);
	-- end 
	-- for v,k in pairs(NinglianList) do
	-- 	local rewardInfo = {}
	-- 	rewardInfo.type = EnumDropType.GOODS
 --        rewardInfo.itemId = v
 --        rewardInfo.number = math.ceil(k * XinFaPercent)
 --        local _rewardInfo = BaseDataManager:getReward(rewardInfo)
 --        XinFaSellList:push(_rewardInfo); 
 --        if rewardInfo.number > 0 then
 --        	NingLian = true
 --        end  
	-- end
	-- for v,k in pairs(MingXinList) do
	-- 	local rewardInfo = {}
	-- 	rewardInfo.type = EnumDropType.GOODS
 --        rewardInfo.itemId = v
 --        rewardInfo.number = math.ceil(k * XinFaPercent)
 --        local _rewardInfo = BaseDataManager:getReward(rewardInfo)
 --        XinFaSellList:push(_rewardInfo); 
 --        if rewardInfo.number > 0 then
 --        	NingLian = true
 --        end  
	-- end
	-- for i = 1,5 do
	-- 	if xinfaInfo.gemId[i] then
	-- 		local rewardInfo = {}
	-- 		rewardInfo.type = EnumDropType.GOODS
 --        	rewardInfo.itemId = xinfaInfo.gemId[i]
 --        	rewardInfo.number = 1
 --        	local _rewardInfo = BaseDataManager:getReward(rewardInfo)
 --        	XinFaSellList:push(_rewardInfo); 
 --        end
	-- end
 --    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.hermit.HermitSure",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
 --    layer:setTitle(localizable.XinFa_sell)
 --    layer:loadData(XinFaSellList);
 --    layer:setBtnHandle(function ()
 --    	if ZhuXin >  ValueCost2 or NingLian == true then
 --    		CommonManager:showOperateSureLayer(
 --            	function(data, widget)
 --                	self:sendXinFaSell(xinfaInfo.instanceId)
 --            	end,
 --            	function(data, widget)
 --                	AlertManager:close()
 --            	end,
 --            	{
 --            	    msg = localizable.Xinfa_tips_more
 --            	}
 --        	)
 --    	else
	--     	self:sendXinFaSell(xinfaInfo.instanceId)
	--     end
 --    end);
 	self:setXinFaSellListByType()
 	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.xinfa.XinFaSellLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1);
    AlertManager:show();

end

function XinFaManager:ServerSwitchChange()
	TFDirector:dispatchGlobalEventWith(XinFaManager.ServerSwitchChange,{})
end

function XinFaManager:sendXinFaSell(gmId)
	showLoading();
	local msg = {gmId}
	TFDirector:send(c2s.REQUEST_HEART_METHOD_SELL, msg)
	TFDirector:dispatchGlobalEventWith(XinFaManager.XinFaSell,{})
end
function XinFaManager:sendXinfaZhiHuan(xinfaInfo1,xinfaInfo2)
	showLoading();
	local msg = {xinfaInfo1,xinfaInfo2}
	TFDirector:send(c2s.REQUEST_HEART_EXCHANGE, msg)
end
function XinFaManager:getListForBag()
	--sortType 1.强化等级 2.升星等级
	
	--local pieceList = BagManager:getItemByType(EnumGameItemType.XinFaPiece)
	local pieceList = TFArray:new()
	local cardList = TFArray:new()
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.config.type == 35 and v.equip == nil then
			cardList:push(v)
		elseif v.config.type == 36 then
			pieceList:push(v)
		end
	end
	local function cmpFunPower(equip1, equip2)
		if equip1.equip and equip2.equip == nil then
    		return true
    	elseif equip2.equip and equip1.equip == nil then 
    		return false
    	end
    	if equip1:getpower() > equip2:getpower() then
    	    return true;
    	elseif equip1:getpower() == equip2:getpower() then
    	    if equip1.config.quality > equip2.config.quality then
    	        return true;
    	    elseif equip1.config.quality == equip2.config.quality then
    	        if equip1.instanceId > equip2.instanceId then
    	            return true;
    	        end
    	    end 
    	end
    	return false;
    end

    local function cmpFunQuality(equip1, equip2)
    	if equip1.equip and equip2.equip == nil then
    		return true
    	elseif equip2.equip and equip1.equip == nil then 
    		return false
    	end
        if equip1.config.quality > equip2.config.quality then
            return true;
        elseif equip1.config.quality == equip2.config.quality then
            if equip1:getpower() > equip2:getpower() then
                return true;
            elseif equip1:getpower() == equip2:getpower() then
                if equip1.instanceId > equip2.instanceId then
                    return true;
                end
            end 
        end
        return false;
    end
	cardList:sort(cmpFunQuality)
	cardList:sort(cmpFunPower)
	pieceList:sort(cmpFunQuality)

	for _, v in ipairs(pieceList.m_list) do
		--v.isStrategyPiece = true
		cardList:push(v)
	end
	return cardList;

end

function XinFaManager:BindEffectOnEquip(panel, equip, type)
	if equip == nil or panel == nil then
    	return
    end
    local quality = 0
    if type and type == 2 then
    	quality = equip or 0
    else
	    local recastInfo = equip:getChongzhuData() or {}
	    for k,v in pairs(recastInfo) do
	    	if v.quality > quality then
	    		quality = v.quality 
	    	end
	    end
	end

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
	    if widgetClassName == 'TFImage' then
	    	local contentSize = panel:getContentSize()
	    	offsetX = contentSize.width/2
	    	offsetY = contentSize.height/2
	    end
	    effect:setPosition(ccp(offsetX,offsetY))
	    panel:addChild(effect,100)
	    panel.equipEffect = effect	
    end
end

-- 设置出售类型
function XinFaManager:setXinFaSellListByType() 
	self.xinFaSellArray = {}
	for i = 1 , self.sell_type_36 do
    	self.xinFaSellArray[i] = {}
    end

	local function sellSort( a, b )
        if a.type == b.type then
            if a.quality == b.quality then
                return a.level > b.level
            else
                return a.quality > b.quality
            end
        else
            return a.type < b.type
        end
    end

    -- 分类
	for _, v in ipairs(self.XinFaList.m_list) do
		if v.equip == nil or v.equip == 0 then
			local item = ItemData:objectByID(v.itemId)
			v.type = item.type
			v.quality = item.quality
			if (item.type == 35) then
				table.insert(self.xinFaSellArray[self.sell_type_35],v)
				if (item.quality == 5) then
					table.insert(self.xinFaSellArray[self.sell_type_35_5],v)
				elseif (item.quality < 5) then
					table.insert(self.xinFaSellArray[self.sell_type_35_4],v)
				end
			elseif (item.type == 36) then
				table.insert(self.xinFaSellArray[self.sell_type_36],v)
				if (item.quality == 5) then
					table.insert(self.xinFaSellArray[self.sell_type_36_5],v)
				elseif (item.quality < 5) then
					table.insert(self.xinFaSellArray[self.sell_type_36_4],v)
				end
			end
		end
	end

	for i = 1 , self.sell_type_36 do
    	table.sort(self.xinFaSellArray[i],sellSort) 
    end
end

function XinFaManager:getXInFaSellListByType(sellType) 
	return self.xinFaSellArray[sellType]
end
return XinFaManager:new()