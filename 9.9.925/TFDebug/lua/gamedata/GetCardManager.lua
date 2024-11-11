
local GetCardManager = class('GetCardManager')

-- local yuanBaoCost = {ConstantData:getValue("Recruit.Consume.Sycee.Hundred"), ConstantData:getValue("Recruit.Consume.Sycee.Million"), 
-- 					 ConstantData:getValue("Recruit.Consume.Sycee.Million.Batch")}

RecruitRateData = require('lua.table.t_s_recruit_rate')
RecruitBoxData = require('lua.table.t_s_recruit_box')
GetCardManager.Event_QueryStateMsg = "GetCardManager.QueryStateMsg"
GetCardManager.Event_GetRoleResult = "GetCardManager.GetRoleResult"
GetCardManager.Event_GetRewardResult = "GetCardManager.Event_GetRewardResult"
function GetCardManager:ctor()
	TFDirector:addProto(s2c.GET_CARD_ROLE, self, self.GetRoleState)
	TFDirector:addProto(s2c.GET_CARD_ROLE_RESULT, self, self.GetRoleResult)		
	TFDirector:addProto(s2c.GET_GET_RECRUIT_CHEST, self, self.GetBoxRewardResult)		

	self.cardStateInfo = {}
end

function GetCardManager:restart()
	self.cardStateInfo = {}
end

function GetCardManager:resetData_24()
	self:SendQueryStateMsg()
end

function GetCardManager:SendQueryStateMsg()
	local msg = {}
	TFDirector:send(c2s.QUERY_GET_ROLE, msg) 
end

function GetCardManager:requestBoxReward(id)
	local msg = {id}
	TFDirector:send(c2s.GET_RECRUIT_CHEST, msg) 
end

function GetCardManager:GetRoleState(event)
	print("GetRoleState", event.data)
	local stateList = event.data.stateList
	if stateList == nil then
		return
	end
	for i=1,3 do
		self.cardStateInfo[i] = stateList[i]
		self.cardStateInfo[i].clientTime = MainPlayer:getNowtime() + self.cardStateInfo[i].cdTime
	end
	self.recruitCount = event.data.toltalCount
	self.gotRewardList = event.data.alreadyGet or {}
	self.rewardRound = event.data.round
	TFDirector:dispatchGlobalEventWith(GetCardManager.Event_QueryStateMsg, {})
end

function GetCardManager:isBoxGot( id )
	if self.gotRewardList == nil then
		return false
	end
	for k,v in pairs(self.gotRewardList) do
		if v == id then
			return true
		end
	end
	return false
end

function GetCardManager:getTenInfo()
 	self.tenCardcount = self.tenCardcount or 0
 	local item = RecruitTenData:objectByID(self.tenCardcount + 1)
 	if item == nil then
 		item = RecruitTenData:objectByID(1)
 	end
 	return item.message
 end 

function GetCardManager:IsFreeGet(cardType)

	-- print('cardType = ',cardType)
	-- print('self.cardStateInfo = ',self.cardStateInfo)
	local state = self.cardStateInfo[cardType]
	if not state then
		return false
	end
	if cardType == 1 then
		if state.cdTime <= 0 and state.freeTimes >= 1 then
			return true
		elseif state.cdTime > 0  and state.clientTime <= MainPlayer:getNowtime() and state.freeTimes >= 1 then
			return true
		else
			return false
		end
	elseif cardType == 2 then
		if state.cdTime <= 0 and state.freeTimes >= 1 then
			return true
		elseif state.cdTime > 0  and state.clientTime <= MainPlayer:getNowtime() then
			return true
		else
			return false
		end
	else
		return false
	end
end

function GetCardManager:SendGetCardMsg(cardType)

	local bFreeGet = false

	-- 判断道具
	local enoughTool = false
	local RecruitData = RecruitRateData:objectByID(cardType)
    if RecruitData then
        local goodId 	= RecruitData.consume_goods_id
        local costTool 	= RecruitData.consume_goods_num
        local tool 		= BagManager:getItemById(goodId)

        if tool and tool.num >= costTool then
        	enoughTool = true
        end
    end
    -- end
	-- local bFreeGet = self:IsFreeGet(cardType)
	
	if enoughTool == false then
		bFreeGet = self:IsFreeGet(cardType)
		if not bFreeGet and self.cardStateInfo[cardType]then
			local todayTimes = self.cardStateInfo[cardType].todayTimes or 0
			if not MainPlayer:isEnoughSycee(GetRolePriceData:getNowPrice( cardType , todayTimes + 1 ) , true) then
				PayManager:setPaySource(1)
				return false
			end
		end
	end
	if not enoughTool and not bFreeGet then
		if not VipRuleManager:showUsedGoldTimeLayer(self:getGetRoleTimes(cardType),8300+cardType-1, localizable.getRoleLayer_txt1)  then
			return false
		end
	end
	self.lastSendTime = self.lastSendTime or 0
	if GetCorrectTime() - self.lastSendTime < 1 then
		return false
	end

	showLoading()

	local getRoleMsg = {cardType, bFreeGet}
	TFDirector:send(c2s.GET_CARD_ROLE, getRoleMsg)
	self.lastSendTime = GetCorrectTime()

	return true
end

function GetCardManager:getGetRoleTimes(cardType )
	return MainPlayer:getVipRuleTimesByCode( 8300+cardType-1 )
end

function GetCardManager:GetBoxRewardResult(event)
	hideAllLoading()
	print("GetBoxRewardResult",event.data)
	self.gotRewardList = event.data.alreadyGet or {}
	self.rewardRound = event.data.round
	TFDirector:dispatchGlobalEventWith(GetCardManager.Event_GetRewardResult, {})
end

function GetCardManager:GetRoleResult(event)
	hideAllLoading()
	
	print("GetRoleResult", event.data)
	local cardType = event.data.state.cardType
	self.cardStateInfo[cardType] = event.data.state
	self.cardStateInfo[cardType].clientTime = self.cardStateInfo[cardType].cdTime + MainPlayer:getNowtime()
	-- MainPlayer:addVipRuleTimeByCode( 8300+cardType-1 , 1 )
	self.recruitCount = event.data.state.totalCount
	self.getCardTypeList = event.data.element
	-- self.hunNumberList = event.data.num

	if #self.getCardTypeList > 0 and cardType == 3 then
		for i=1,30 do
			local first =  math.random(1, #self.getCardTypeList)
			local second =  math.random(1, #self.getCardTypeList)
			if first ~= second then
				local temp_typid = self.getCardTypeList[first]
				self.getCardTypeList[first] = self.getCardTypeList[second]
				self.getCardTypeList[second] = temp_typid

				-- local temp_num = self.hunNumberList[first]
				-- self.hunNumberList[first] = self.hunNumberList[second]
				-- self.hunNumberList[second] = temp_num
			end
		end
	end

	self:showGetEffect(cardType)
 	TFDirector:dispatchGlobalEventWith(GetCardManager.Event_GetRoleResult, {cardType})
end

function GetCardManager:showGetEffect(cardType)
	local blockUI = TFPanel:create();
	blockUI:setSize(GameConfig.WS);
	blockUI:setTouchEnabled(true); 

	blockUI:setBackGroundColorType(TF_LAYOUT_COLOR_SOLID);
	blockUI:setBackGroundColorOpacity(200);
	blockUI:setBackGroundColor(ccc3(  0,   0,   0));
	AlertManager:getTopLayer().toScene:addLayer(blockUI);

	TFResourceHelper:instance():addArmatureFromJsonFile("effect/NewCardEffect.xml")
	local effect = TFArmature:create("NewCardEffect_anim")
	if effect == nil then
		return
	end
	-- effect:setZOrder(-100)
	effect:setAnimationFps(GameConfig.ANIM_FPS)
	effect:playByIndex(0, -1, -1, 0)
	effect:setPosition(ccp(GameConfig.WS.width/2, GameConfig.WS.height/2))

	blockUI:addChild(effect)
	play_zhaomu_pengwan()

	
	local function showResult()
		blockUI:removeFromParent()
		if #self.getCardTypeList > 0 then
			if cardType < 3 then
				-- play_shili_bailizhaomu()
				if self.getCardTypeList[1].resType == EnumDropType.ROLE then
					self:ShowGetOneRoleLayer(cardType, 1)
				else
					self:ShowGetOneItemLayer(cardType, 1)
				end
			else
				-- play_wanlizhaomu()
				local layer = require("lua.logic.shop.GetTenRoleResultLayer"):new(cardType)
				layer.name = "lua.logic.shop.GetTenRoleResultLayer"
			AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY)
			AlertManager:show()
			end
		end
	end

	effect:addMEListener(TFARMATURE_COMPLETE,showResult)
	blockUI:addMEListener(TFWIDGET_CLICK,showResult)
	-- effect:addMEListener(TFARMATURE_COMPLETE,showResult)
end

function GetCardManager:ShowGetOneRoleLayer(cardType, roleIndex)
	local layer = require("lua.logic.shop.GetRoleResultLayer"):new({cardType, roleIndex})
	AlertManager:addLayer(layer, AlertManager.BLOCK)
	AlertManager:show()
end

function GetCardManager:ShowGetOneItemLayer(cardType, roleIndex)
	local layer = require("lua.logic.shop.GetItemResultLayer"):new({cardType, roleIndex})
	AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY)
	AlertManager:show()
end

function GetCardManager:getRoleListInTen( )
	local item = RecruitTenData:objectByID(1)
	local list = stringToNumberTable(item.drop_list,",")
	local roleList = TFArray:new()
	if #list > 0 then
		for i,v in ipairs(list) do
            local rewardInfo = {}
            rewardInfo.type = EnumDropType.ROLE
            rewardInfo.itemId = v
            rewardInfo.number = 1
            local _rewardInfo = BaseDataManager:getReward(rewardInfo)
            roleList:push(_rewardInfo);
        end                    
    end 
    return roleList
end

function GetCardManager:ShowTenList()
	local item = RecruitTenData:objectByID(1)
	local list = stringToNumberTable(item.drop_list,",")
	print("item.drop_list = ",item.drop_list)
	local roleList = TFArray:new()
	if #list > 0 then
		for i,v in ipairs(list) do
            local rewardInfo = {}
            rewardInfo.type = EnumDropType.ROLE
            rewardInfo.itemId = v
            rewardInfo.number = 1
            local _rewardInfo = BaseDataManager:getReward(rewardInfo)
            roleList:push(_rewardInfo);
        end                    
    end        
    local layer  = require("lua.logic.shop.TenExtLayer"):new()
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    layer:setRewardList(roleList)
    AlertManager:show()
    return
end

--红点判断逻辑
--是否该招募免费
function GetCardManager:isGetCardFree(index)
	return self:IsFreeGet(index);
end

--是否有招募免费
function GetCardManager:isHaveGetCardFree()
	for i =1,3 do
		if self:IsFreeGet(i) then
			return true
		end
	end
	return false;
end

function GetCardManager:getRecruitCount()
	return self.recruitCount or 0
end

function GetCardManager:getRecruitRound()
	return self.rewardRound
end

function GetCardManager:getRewardBoxData( id )
	return RecruitBoxData:objectByID(id)
end

function GetCardManager:isFrontThreeGot()
	if self.gotRewardList == nil or #self.gotRewardList < 3 then
		return false
	end
	local x0 = 0
	for k,v in pairs(self.gotRewardList) do
		if v == 1 or v == 2 or v == 3 then
			x0 = x0 + 1
		end
	end
	if x0 < 3 then
		return false
	end
	return true
end

function GetCardManager:checkRedPoint()
	local round = self:getRecruitRound()
    local lastData = self:getRewardBoxData(6)
	local currCount = self:getRecruitCount()
	local num = (round - 1) * lastData.target_count
    for i=1,6 do
        local data = self:getRewardBoxData(i)
        local totalNum = num + data.target_count
        if totalNum <= currCount then
            local bGot = self:isBoxGot(i)
            if bGot == false then
            	return true
            end
        end
    end
    return false
end

return GetCardManager:new()