--[[
******月卡数据管理类*******

	-- by quanhuan
	-- 2015-10-9 15:55:31
]]


local MonthCardManager = class("MonthCardManager")


MonthCardManager.BTN_STATUS_PAY = 1		--充值状态
MonthCardManager.BTN_STATUS_GET = 2		--领取状态
MonthCardManager.BTN_STATUS_GOT = 3		--已领状态

MonthCardManager.CARD_TYPE_1 = 1	--小月卡
MonthCardManager.CARD_TYPE_2 = 2	--大月卡
MonthCardManager.CARD_TYPE_3 = 3	--大小月卡

MonthCardManager.MONTH_CARD_LINGQU_COMPELTE = "MonthCardManager.MONTH_CARD_LINGQU_COMPELTE"
MonthCardManager.MONTH_CARD_INFO_UPDATE = "MonthCardManager.MONTH_CARD_INFO_UPDATE"
MonthCardManager.MONTH_CARD_RefeshAttr = "MonthCardManager.MONTH_CARD_RefeshAttr"
MonthCardManager.MONTH_CardMARK_RefeshAttr = "MonthCardManager.MONTH_CardMARK_RefeshAttr"

function MonthCardManager:ctor(data)

    TFDirector:addProto(s2c.CONTRACT_INFO, self, self.requestMonthCardCopmplete)
    TFDirector:addProto(s2c.BUY_CONTRACT_RESULT, self, self.chongzhiComplete)
    TFDirector:addProto(s2c.GET_CONTRACT_DAILY_REWARD_RESULT, self, self.lingquComplete)
    TFDirector:addProto(s2c.MONTH_CARD_MARK_REPONSE , self, self.monthCardMarkReponse)

    self.contractData = require('lua.table.t_s_contract_template')
    -- if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
    --     self.rechargeList = require("lua.table.t_s_recharge_ios");
    -- else
    --     self.rechargeList = require("lua.table.t_s_recharge");
    -- end
	
	self:restart()
end

function MonthCardManager:restart()
	self.rechargeList = Public:getRechargeList();
	self.DataTable = {}
	self.cardMark = {}
	for i=1,2 do
		self.cardMark[i] = 0
		self.DataTable[i] = {}
		self.DataTable[i].btnStatus = MonthCardManager.BTN_STATUS_PAY
		self.DataTable[i].day = 30
		self.DataTable[i].id = 1
		self.DataTable[i].startTime = 1
		self.DataTable[i].endTime = 1
		self.DataTable[i].lastGotRewardTime = 1
		self.DataTable[i].RMB = 0
		self.DataTable[i].YB = 0
	end

	local rechargeItem = self.rechargeList:objectByID(7)
	self.DataTable[1].RMB = rechargeItem.price
	self.DataTable[1].sycee = rechargeItem.sycee
	self.DataTable[1].extra_sycee = rechargeItem.extra_sycee
	self.DataTable[1].YB = self:getYuanbaoNum(MonthCardManager.CARD_TYPE_1)

	local rechargeItem1 = self.rechargeList:objectByID(11)
	self.DataTable[2].RMB = rechargeItem1.price
	self.DataTable[2].sycee = rechargeItem1.sycee
	self.DataTable[2].extra_sycee = rechargeItem1.extra_sycee
	self.DataTable[2].YB = self:getYuanbaoNum(MonthCardManager.CARD_TYPE_2)
	self:stopCheckTimer()
end

function MonthCardManager:chongzhi( card_type )

--	if card_type == MonthCardManager.CARD_TYPE_1 then
--		PayManager:pay(7,2)
--	else
--		PayManager:pay(11,3)
--	end

	---------------- Web view ------------
	
	showLoading();
	local userInfo = SaveManager:getUserInfo()
	if HeitaoSdk then
        local price         = 30
        local rate          = 10
        local count         = 1
        local fixedMoney    = true
        --local unitName      = "元宝"
        local unitName      = localizable.common_gold
        local productId     = "123"
        local serverId      = userInfo.currentServer
        local name          = "Thẻ Tháng "
        local callbackUrl   = nil
        local description   = nil
        local cpExtendInfo  = productId
        
        local sycee         = MainPlayer:getSycee()
        local level         = MainPlayer:getLevel()
        local viplevel      = MainPlayer:getVipLevel()
        local party         = ""
        local month         = 0

        HeitaoSdk.setPayCallBack(PayManagerPaySDKCallBack)
        HeitaoSdk.pay(price, rate, count, fixedMoney, unitName, productId, serverId, name, callbackUrl, description, cpExtendInfo, sycee, level, viplevel, month, party)
    end
	
	hideLoading();
	
	---------------- en  Web view ------------



end

function MonthCardManager:chongzhiComplete( event )

	hideLoading()
    -- toastMessage("月卡购买成功")
    toastMessage(localizable.MonthCardManager_buy_suc)
end

function MonthCardManager:lingqu( card_type )

	showLoading()
	if card_type == MonthCardManager.CARD_TYPE_1 then
		TFDirector:send(c2s.GET_CONTRACT_DAILY_REWARD, {1})
	else
		TFDirector:send(c2s.GET_CONTRACT_DAILY_REWARD, {2})
	end
	
end

function MonthCardManager:monthCardMarkReponse( event )
	local data = event.data
	if data.mark then
		for i=1,#data.mark do
			self.cardMark[i] = data.mark[i]
		end
		TFDirector:dispatchGlobalEventWith(MonthCardManager.MONTH_CardMARK_RefeshAttr, {})
	end
end
function MonthCardManager:getExtValue(id,extra_sycee)
	if id == 7 then
		if self.cardMark[1] == 0 then
			return extra_sycee
		end
	elseif id == 11 then
		if self.cardMark[2] == 0 then
			return extra_sycee
		end
	end
	return 0
end

function MonthCardManager:getDoubleBuffReward()
	showLoading()
	TFDirector:send(c2s.GET_CARD_CONTRACT_DAILY_REWARD, {})
end

function MonthCardManager:lingquComplete( event )

	hideLoading()
	TFDirector:dispatchGlobalEventWith(MonthCardManager.MONTH_CARD_LINGQU_COMPELTE, {event.data.id})
end

function MonthCardManager:getBtnStatus( card_type )
	return self.DataTable[card_type]
end

function MonthCardManager:openMonthCardLayer()
	if SettingManager:tipJumpAnti() == true then
		return
	end
	--进入月卡界面之前刷新月卡信息
	self:CheckMonthCardStatus()
	local layer  = require("lua.logic.pay.MonthCardLayer"):new()
	AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
	AlertManager:show()

end

-- 刷新月卡状态信息
function MonthCardManager:CheckMonthCardStatus()
    
    local nowTime = MainPlayer:getNowtime() 
    local secInOneDay = 24 * 60 * 60 
    local index = 0
    for i=1,2 do
    	if self.DataTable[i].btnStatus ~= MonthCardManager.BTN_STATUS_PAY then

    		if nowTime >= self.DataTable[i].endTime then
    			self.DataTable[i].btnStatus = MonthCardManager.BTN_STATUS_PAY
    			self.DataTable[i].day = 30
    		else
			    local lastRewardDayIndex    = calculateDayNumber(self.DataTable[i].lastGotRewardTime / 1000)
			    local nowDayIndex           = calculateDayNumber(nowTime)
			    local endDayIndex           = calculateDayNumber(self.DataTable[i].endTime/1000)
			    local startDayIndex         = calculateDayNumber(self.DataTable[i].startTime/1000)
			    index = index + 1
			    if nowDayIndex > lastRewardDayIndex then
			    	self.DataTable[i].btnStatus = MonthCardManager.BTN_STATUS_GET
			    	self.DataTable[i].day = endDayIndex - nowDayIndex
			    else
			    	self.DataTable[i].btnStatus = MonthCardManager.BTN_STATUS_GOT
			    	self.DataTable[i].day = endDayIndex - nowDayIndex - 1
			    end

			    if self.DataTable[i].day < 0 then
	    			self.DataTable[i].btnStatus = MonthCardManager.BTN_STATUS_PAY
	    			self.DataTable[i].day = 30
			    end
    		end    		
    	end
    end
    self.DataTable[3] = {}
    if index >= 2 and self.lastDoubleBuffRewardTime ~= nil and self.lastDoubleBuffRewardTime >= 0 then
    	local lastRewardDayIndex    = calculateDayNumber(self.lastDoubleBuffRewardTime / 1000)
	    local nowDayIndex           = calculateDayNumber(nowTime)
	    if nowDayIndex > lastRewardDayIndex then
	    	self.DataTable[3].btnStatus = MonthCardManager.BTN_STATUS_GET
	    else
	    	self.DataTable[3].btnStatus = MonthCardManager.BTN_STATUS_GOT
	    end
    else
    	self.DataTable[3].btnStatus = MonthCardManager.BTN_STATUS_PAY
    end
end

function MonthCardManager:IsMonthCardCanGet()
	--刷新月卡状态信息
	--需要查找其他文件
    self:CheckMonthCardStatus()

    for i=1,2 do
    	if self.DataTable[i].btnStatus == MonthCardManager.BTN_STATUS_GET then
	    	return true
    	end
    end

    if self.DataTable[3] ~= nil and self.DataTable[3].btnStatus == MonthCardManager.BTN_STATUS_GET then
    	return true
    end
    return false
end

function MonthCardManager:requestMonthCardCopmplete( event )

	local infoTable = event.data.info

	-- print("OOOOOOOOOOOOOOOOOOOOOOOOOOO")
	-- print("OOOOOOOOOOOOOOOOOOOOOOOOOOO")
	-- print("OOOOOOOOOOOOOOOOOOOOOOOOOOO")
	-- print("OOOOOOOOOOOOOOOOOOOOOOOOOOO")
	-- print("infoTable",infoTable)

	for i=1,#infoTable do

		if infoTable[i].id == 1 then
			self.DataTable[1].btnStatus = MonthCardManager.BTN_STATUS_GET
			self.DataTable[1].id = infoTable[i].id 									--[	契约ID]
			self.DataTable[1].startTime = infoTable[i].startTime    				--[开始时间]
			self.DataTable[1].endTime = infoTable[i].endTime 						--[ 结束时间]
			self.DataTable[1].lastGotRewardTime = infoTable[i].lastGotRewardTime	--[上次领奖时间]
		elseif infoTable[i].id == 2 then
			self.DataTable[2].btnStatus = MonthCardManager.BTN_STATUS_GET
			self.DataTable[2].id = infoTable[i].id 									--[	契约ID]
			self.DataTable[2].startTime = infoTable[i].startTime    				--[开始时间]
			self.DataTable[2].endTime = infoTable[i].endTime 						--[ 结束时间]
			self.DataTable[2].lastGotRewardTime = infoTable[i].lastGotRewardTime	--[上次领奖时间]
		end
	end
	self.lastDoubleBuffRewardTime = event.data.lastGotCardRewardTime

	self:CheckMonthCardStatus()

	-- add by king
	self:startCheckTimer()

	TFDirector:dispatchGlobalEventWith(MonthCardManager.MONTH_CARD_INFO_UPDATE)
end

function MonthCardManager:getYuanbaoNum( card_type )

	local number = 0
	local index = 1
	if card_type == MonthCardManager.CARD_TYPE_1 then
		index = 1
	else
		index = 2
	end
	local template = self.contractData:getObjectAt(index)
	if template then
		local config = RewardConfigureData:GetRewardItemListById(template.reward_id)
		if config then
			for item in config:iterator() do
				number = item.number
			end
		end		
	end
	
	return number;
end

function MonthCardManager:isExistMonthCard(card_type)
	if card_type == MonthCardManager.CARD_TYPE_3 then
		return self:_isExistMonthCard(MonthCardManager.CARD_TYPE_1) and self:_isExistMonthCard(MonthCardManager.CARD_TYPE_2)
	end
	return self:_isExistMonthCard(card_type)
end
function MonthCardManager:_isExistMonthCard(card_type)
	
	local nowDate = GetCorrectDate("*t", MainPlayer:getNowtime())
	local endDate = GetCorrectDate("*t", math.floor(self.DataTable[card_type].endTime/1000))

	if nowDate.year > endDate.year then
		return false
	elseif nowDate.year < endDate.year then
		return true
	elseif nowDate.month > endDate.month then
		return false
	elseif nowDate.month < endDate.month then
		return true
	elseif nowDate.day > endDate.day then
		return false
	else
		return true
	end
end

function MonthCardManager:getCardState()
	local card_1 = self:_isExistMonthCard(MonthCardManager.CARD_TYPE_1) and 1 or 0
	local card_2 = self:_isExistMonthCard(MonthCardManager.CARD_TYPE_2) and 2 or 0
	return card_1 + card_2
end

function MonthCardManager:stopCheckTimer()
	-- if self.monthCheckTimer then
 --        TFDirector:removeTimer(self.monthCheckTimer)
 --        self.monthCheckTimer = nil
 --    end
end


function MonthCardManager:startCheckTimer()

end

function MonthCardManager:buyBigMonthCardSuccess()
	CardRoleManager:refreshAllRolePower()

	TFDirector:dispatchGlobalEventWith(MonthCardManager.MONTH_CARD_RefeshAttr, {})
end


function MonthCardManager:refreshMonthCard()
	-- local bOwnMonth = self:isExistMonthCard(MonthCardManager.CARD_TYPE_2)

	-- if bOwnMonth then
	-- 	:buyBigMonthCardSuccess()
	-- end
	self:buyBigMonthCardSuccess()
	TFDirector:dispatchGlobalEventWith(MonthCardManager.MONTH_CARD_RefeshAttr, {})
end

return MonthCardManager:new()