--
-- Author: Zippo
-- Date: 2014-01-08 18:28:29
--

local QiyuManager = class("QiyuManager")

QiyuManager.OPEN_HOME_REPONSE = "QiyuManager.OPEN_HOME_REPONSE"
QiyuManager.HOME_TURNTABLE_REPONSE = "QiyuManager.HOME_TURNTABLE_REPONSE"
QiyuManager.Receive_Friend_Praise_Ranks = "QiyuManager.Receive_Friend_Praise_Ranks"
QiyuManager.Receive_Friend_Praise_Fresh = "QiyuManager.Receive_Friend_Praise_Fresh"
QiyuManager.Receive_Draw_HomeAward_Scuess = "QiyuManager.Receive_Draw_HomeAward_Scuess"
QiyuManager.OPEN_HOME_EVENT_SCUESS = "QiyuManager.OPEN_HOME_EVENT_SCUESS"
QiyuManager.ACCESS_RECORDS = "QiyuManager.ACCESS_RECORDS"
QiyuManager.HOME_LEVEL_REPONSE = "QiyuManager.HOME_LEVEL_REPONSE"
QiyuManager.Jiayuan_MaxLevel = 500
function QiyuManager:ctor()
	self:registerEvents()

	--运营玩法开关
	self.FunctionSwitchList = {}

	--初始化契约数据
	self.ContractInfo = {}
	-- 默认没有月卡
	self.ContractInfo.OwnMonthCard = false

	--初始化邀请码数据
	self.InviteCodeInfo = {}
	self.IsGetInviteReward = false
	self.escortingFinishMark = false

	--初始化押镖数据
	self.yabiaoData = {}
	-- self.initQiyuIndex = 1
    self.jiayuanData = {level = 0, exp = 0,praiseCount = 0,praiseFriends = {},drawCount = 0}
    self.loginAcceptCode = 0
    
    --游方商人存在的时间
    self.jiayuanYoufangTime=0
end

function QiyuManager:restart()
	self.escortingFinishMark 		= false
	self.ContractInfo.OwnMonthCard 	= false
end

function QiyuManager:registerEvents()

	--运营活动开启
	TFDirector:addProto(s2c.FACTION_SWITH_LIST, self, self.FunctionSwitchMsgHandle)

	TFDirector:addProto(s2c.GET_DINING, self, self.EatPigStateMsgHandle)
	TFDirector:addProto(s2c.DINING, self, self.EatPigMsgHandle)

	--sign
	TFDirector:addProto(s2c.GET_SIGN,    self, self.onReceiveSignStatus)
    TFDirector:addProto(s2c.SIGN_RESULT, self, self.onReceiveSignResult)


    -- 契约
    -- TFDirector:addProto(s2c.CONTRACT_INFO, self, self.ContractInfoMsgHandle)
    -- TFDirector:addProto(s2c.BUY_CONTRACT_RESULT, self, self.BuyContractMsgHandle)
    -- TFDirector:addProto(s2c.GET_CONTRACT_DAILY_REWARD_RESULT, self, self.ContractPrizeMsgHandle)

    -- 邀请码
    TFDirector:addProto(s2c.MY_INVITE_CODE_INFO, self, self.InviteCodeInfoMsgHandle)
    TFDirector:addProto(s2c.MY_INVITE_CODE , self, self.GetCodeMsgHandle)
    TFDirector:addProto(s2c.VERIFY_INVITE_CODE_RESULT , self, self.CheckInviteCodeMsgHandle)

    --护驾
    TFDirector:addProto(s2c.ESCORTING_INFO, self, self.onReceiveEscortingInfo)
    TFDirector:addProto(s2c.ESCORTING_FINISH, self, self.onReceiveEscortingFinish)

    -- 押镖
    TFDirector:addProto(s2c.YABIAO, self, self.onReceiveYaBiaoInfo)
    -- 刷新镖车
    TFDirector:addProto(s2c.REFRESH_YABIAO_RESULT, self, self.onReceiveRefreshYaBiao)
    -- 开始押镖
    TFDirector:addProto(s2c.YABIAO_RESULT, self, self.onReceiveBeginYaBiao)
    -- 镖车领奖
    TFDirector:addProto(s2c.GET_YABIAO_REWARD_RESULT, self, self.onReceiveRewardYaBiao)
    -- 清除押镖cd
    TFDirector:addProto(s2c.CLEAR_YABIAO_CDNOTIFY, self, self.onReceiveClearCDYaBiao)



    -- 新邀请码
    TFDirector:addProto(s2c.MY_NEW_INVITE_CODE_INFO, self, self.onReceiveInviteCodeEvent)

    -- self:GetSignStatus()
    --家园
    TFDirector:addProto(s2c.OPEN_HOME_REPONSE, self, self.onReceiveOpenJiayuan)
    TFDirector:addProto(s2c.HOME_TURNTABLE_REPONSE, self, self.onReceiveJiayuanLunpan)    
    TFDirector:addProto(s2c.HOME_LEVEL_REPONSE, self, self.onReceiveJiayuanLevel)   
    TFDirector:addProto(s2c.OPEN_HOME_EVENT_SCUESS, self, self.onReceiveDealJiaYuanEvent)

    ErrorCodeManager:addProtocolListener(s2c.OPEN_HOME_EVENT_SCUESS,  function(target,event)
		if event.errorCode == 29702 then
			self:requestOpenJiayuan(false)
		end
		return false
	end)
    TFDirector:addProto(s2c.ACCESS_RECORDS, self, self.onReceiveAccessRecord)
    TFDirector:addProto(s2c.FRIEND_PRAISE_RANKS, self, self.onReceiveFriendPraiseRanks)   
    TFDirector:addProto(s2c.PRAISE_SUCESS, self, self.onReceivePraiseSucess)   
    TFDirector:addProto(s2c.DRAW_HOME_AWARD_SCUESS, self, self.onReceiveDrawHomeAwardScuess)   
end

function QiyuManager:registerResetEvent()
    self.QiyuDataReset = function(event)
        self:resetQiyuData()
    end
    -- TFDirector:addMEGlobalListener(MainPlayer.GAME_RESET, self.QiyuDataReset)
end

function QiyuManager:OpenHomeLayer(initQiyuIndex)
	initQiyuIndex = initQiyuIndex or 1;
	local index = initQiyuIndex
	if self:QiyuFuctionIsOpenByIndex(initQiyuIndex) == false then
		local temp = 0
		for i=1,5 do
			local isOpen = self:QiyuFuctionIsOpenByIndex(i)
			if isOpen == true then
				index = i
				temp = temp + 1
			end
		end
		if temp == 0 then
			-- toastMessage("奇遇的活动都没有开放")
            toastMessage(localizable.QiyuManager_wuhuodong)
			return
		end
	end
	local teamLev   = MainPlayer:getLevel()
    local openLevel = FunctionOpenConfigure:getOpenLevel(900+index)
    --  等级开发之后奇遇才会有红点
    if openLevel > teamLev then
        return
    end
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.qiyu.QiyuHomeLayer", AlertManager.BLOCK_AND_GRAY);
	layer:select(index);
	layer:redraw()
    AlertManager:show()
end

function QiyuManager:SengQueryEatPigMsg()
	TFDirector:send(c2s.GET_DINING_REQUEST, {})
end

function QiyuManager:GetSignStatus()
	--请求当前状态
	showLoading()
    TFDirector:send(c2s.GET_SIGN_REQUEST, {} )
end

function QiyuManager:SignRequest()
	showLoading()
	TFDirector:send(c2s.SIGN_REQUEST, {})
end

function QiyuManager:GetInviteCodeDataRequest(index)
	-- showLoading()
	-- TFDirector:send(c2s.SIGN_REQUEST, {})
end

-- 领取邀请码奖励
function QiyuManager:GetInviteCodePrizeRequest(index)
	showLoading()
	TFDirector:send(c2s.GET_SEND_REWARD, {index})
end

function QiyuManager:EatPigStateMsgHandle(event)
	-- print("QiyuManager:EatPigStateMsgHandle = ", event.data)
	self.lastDietTime = event.data.lastTime
	self.eatPigInfo = event.data.info
	TFDirector:dispatchGlobalEventWith("eatPigInfo")
end

function QiyuManager:getEatPigState(btnIndex)
	-- print("eatPigInfo = ",self.eatPigInfo)
	if self.eatPigInfo then
		for k,v in pairs(self.eatPigInfo) do
			if v.type == btnIndex then
				return v.status
			end
		end
	end
	return 4
end

function QiyuManager:getEatPigCutDown()
	local cutDown
	if self.eatPigInfo then
		for _,v in pairs(self.eatPigInfo) do
			if v.status == 1 then
				local info = DietData:objectByID(v.type)
				local timerTbl = stringToNumberTable(info.start_time,":")
				local second = ((timerTbl[1]*60)+timerTbl[2])*60+timerTbl[3]+70--主动延后70s
				local currDate = GetCorrectDate("*t", MainPlayer:getNowtime())
				local currSecond = (currDate.hour*60+currDate.min)*60+currDate.sec
				cutDown = second - currSecond
				if second < currSecond then
					cutDown = 1
				end
				return cutDown
			elseif v.status == 2 then
				local info = DietData:objectByID(v.type)
				local timerTbl = stringToNumberTable(info.end_time,":")
				local second = ((timerTbl[1]*60)+timerTbl[2])*60+timerTbl[3]+70--主动延后70s
				local currDate = GetCorrectDate("*t", MainPlayer:getNowtime())
				local currSecond = (currDate.hour*60+currDate.min)*60+currDate.sec
				cutDown = second - currSecond
				if second < currSecond then
					cutDown = 1
				end
				return cutDown
			end
		end
	end 
end
function QiyuManager:EatPigMsgHandle(event)
	-- toastMessage("用餐成功，体力增加"..event.data.power)
	toastMessage(stringUtils.format(localizable.QiyuManager_tilizengjia, event.data.power))
	TFDirector:dispatchGlobalEventWith("eatPigInfo")
end

function QiyuManager:getJiayuanYoufangTime()
	--家园游方商人的时间
	return self.jiayuanYoufangTime
end

function QiyuManager:getDealPlayerId()
	--家园游方商人的时间
	return self.dealPlayerId
end


function QiyuManager:onReceiveSignStatus(event)
	hideLoading()
	self.GetSignRequest = event.data
	TFDirector:dispatchGlobalEventWith("getSignRequest")

end

function QiyuManager:onReceiveSignResult(event)
	hideLoading()
	self.SignResult = event.data.itemlist
	if self.SignResult == nil then
		-- print("self.SignResult is nil")
	end

	self.GetSignRequest.isSign = true --已签到

	TFDirector:dispatchGlobalEventWith("signResult")
end

function QiyuManager:IsSignToday()
	if self.GetSignRequest == nil or self.GetSignRequest.isSign == nil then
		return false
	end

	return (not self.GetSignRequest.isSign)
end
function QiyuManager:isTouchTmall()
	if MainPlayer:getServerSwitchStatue(ServerSwitchType.Tmall ) then
		local hasTouch =  CCUserDefault:sharedUserDefault():getBoolForKey("touch_tmall") or false;
		return not hasTouch
	end
	return false
end

function QiyuManager:OpenSignLayer()
	if PlayerGuideManager:IsGuidePanelVisible() then
		return
	end
    self:OpenHomeLayer(QiYuType.NewSign)
end

--契约
function QiyuManager:RequestContractInfo()
	showLoading()
	TFDirector:send(c2s.QUERY_CONTRACT, {})
end

function QiyuManager:ContractInfoMsgHandle(event)
	local data = event.data.info[1]
	-- 玩家有月卡
	self.ContractInfo.OwnMonthCard = true

	self.ContractInfo.id 				= data.id --	[	契约ID]
	self.ContractInfo.startTime 		= data.startTime	--[开始时间]
	self.ContractInfo.endTime 			= data.endTime	--[ 结束时间]
	self.ContractInfo.lastGotRewardTime = data.lastGotRewardTime	--[上次领奖时间]

end


function QiyuManager:BuyContract(contractId)
	showLoading()
	TFDirector:send(c2s.BUY_CONTRACT, {contractId})
end

function QiyuManager:BuyMonthCard()
	self:BuyContract(1)
end

function QiyuManager:BuyContractMsgHandle(event)
	hideLoading()
	-- 玩家买月卡成功
	self.ContractInfo.OwnMonthCard = true

	TFDirector:dispatchGlobalEventWith("BuyMonthCardPrize")
end

-- 契约//ok
-- 检查月卡是否过期
function QiyuManager:CheckContractIsExpire()
    -- 判断月卡是否过期
    local nowTime = MainPlayer:getNowtime() * 1000

    if self.ContractInfo.OwnMonthCard and nowTime >= self.ContractInfo.endTime then
       self.ContractInfo.OwnMonthCard = false
	end
end

function QiyuManager:ContractIsExpire()
	return self.ContractInfo.OwnMonthCard
end

function QiyuManager:IsMonthCardCanGet()
	--检查是否月卡是否过期
    self:CheckContractIsExpire()

    -- 判断当前是否有月卡
    if  self:ContractIsExpire() then
    	-- return false
    	local nowTime               = MainPlayer:getNowtime()
	    local secInOneDay           = 24 * 60 * 60 * 1000
	    local lastRewardDayIndex    = self.ContractInfo.lastGotRewardTime / secInOneDay
	    local endDayIndex           = self.ContractInfo.endTime / secInOneDay
	    local nowDayIndex           = nowTime * 1000 / secInOneDay

	    lastRewardDayIndex  = math.ceil(lastRewardDayIndex)
	    endDayIndex         = math.ceil(endDayIndex)
	    nowDayIndex         = math.ceil(nowDayIndex)

	    if nowDayIndex <= lastRewardDayIndex then
	        return false
	    else
	        return true
	    end
    else
    	return false
    end

    -- true 为有小红点
end

function QiyuManager:EntryMonthCard()
	-- if true then
	-- 	toastMessage("封测阶段暂不开放")
	-- 	return
	-- end

	--检查是否月卡是否过期
    self:CheckContractIsExpire()

    -- 判断当前是否有月卡
    if  self:ContractIsExpire() then
    	AlertManager:addLayerByFile("lua.logic.qiyu.MonthCardGetLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    else
    	AlertManager:addLayerByFile("lua.logic.qiyu.MonthCardBuyLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    end
    AlertManager:show()
end

function QiyuManager:GetContractPrize()
	showLoading()
	TFDirector:send(c2s.GET_CONTRACT_DAILY_REWARD, {})
end

function QiyuManager:ContractPrizeMsgHandle(event)
	hideLoading()
	TFDirector:dispatchGlobalEventWith("GetMonthCardPrize")
end

-- 邀请码
function QiyuManager:CheckInviteCode(code)
	showLoading()
	TFDirector:send(c2s.VERIFY_INVITE_CODE, {code})
end

function QiyuManager:InviteCodeInfoMsgHandle(event)
	hideLoading()

	local data = event.data
	self.InviteCodeInfo.invited     	 = data.invited 			--自己是否被邀请过（验证过别人的邀请码）
	self.InviteCodeInfo.inviteCount  	 = data.inviteCount			--主动邀请次数
	self.InviteCodeInfo.getRewardRecord  = data.getRewardRecord    	--已领取第n此奖励（形如：1,2,3,4,5,...表示已领取发送1,2,3,4,5次奖励）

	self:CheckInviteRewardIsGet()
	if self.IsGetInviteReward then
		-- print("有邀请码奖励未领取")
	else
		-- print("没有邀请码奖励")
	end
	TFDirector:dispatchGlobalEventWith("UpdateInviteCodeInfo")
end

function QiyuManager:CheckInviteCodeMsgHandle(event)
	hideLoading()

	self.InviteCodeInfo.invited = true

	TFDirector:dispatchGlobalEventWith("CheckInviteCode")
end

function QiyuManager:GetCodeMsgHandle(event)
	hideLoading()

	-- 获取自己的邀请码
	self.InviteCodeInfo.code = event.data.myCode

end

-- 邀请码奖励是否没有了领取
function QiyuManager:CheckInviteRewardIsGet()
	local inviteConfig = require("lua.table.t_s_invite_code_reward_config")
    local rewardList  = string.split(self.InviteCodeInfo.getRewardRecord, ',')

    self.IsGetInviteReward = false

    -- 检查是否领取过奖
    local function checkPrizeIsGet(id)
        if rewardList == nil or #rewardList == 0 or id == nil then
            return false
        end
        local index = string.format("%d", id)
        for i=1,#rewardList do
            if rewardList[i] ~= nil and string.len(rewardList[i]) >= 1 then
                -- print("id = ", rewardList[i])
               if rewardList[i] == index then
                    return true
                end
            end
        end
        return false
    end

    -- 遍历查找
    for i=1,4 do
        local config = inviteConfig:getObjectAt(i)
        local complete_ = false
        -- 计算邀请人数
        local people_ = config.invite_time - self.InviteCodeInfo.inviteCount
        if people_ <= 0 then
            complete_ = true
        end

        -- 是否领过奖
        local receive_ = false
        if  checkPrizeIsGet(i) == true then
            receive_ = true
        end

        -- 已完成 未领奖
        if complete_ == true and receive_ == false then
        	self.IsGetInviteReward = true
        	return true
        end
    end

	return false;
end

--护驾
QiyuManager.EscortingInfoUpdate = "QiyuManager.EscortingInfoUpdate"
QiyuManager.EscortingFinish = "QiyuManager.EscortingFinish"
--[[
接收护驾信息
]]
function QiyuManager:onReceiveEscortingInfo(event)
 	self.escortingInfo = event.data
 	-- print("QiyuManager:onReceiveEscortingInfo(event)",self.escortingInfo)
 	-- self.escortingInfo.enableTime = GetCorrectTime() + math.ceil(self.escortingInfo.remainWaitTime/1000)
 	self.escortingInfo.enableTime = MainPlayer:getNowtime() + math.ceil(self.escortingInfo.remainWaitTime/1000)

    local type = self.escortingInfo.type
    local finishTimes = self.escortingInfo.times
    local setting = EscortingSetting:objectByID(type)
 	if setting.total_day > self.escortingInfo.days then
 		self.escortingFinishMark = false
 	end
 	TFDirector:dispatchGlobalEventWith(QiyuManager.EscortingInfoUpdate)
 end

--[[
接收护驾完成信息
]]
function QiyuManager:onReceiveEscortingFinish(event)
	-- print("QiyuManager:onReceiveEscortingFinish(event)")
 	self.escortingFinishMark = true
 	TFDirector:dispatchGlobalEventWith(QiyuManager.EscortingFinish)
 end

--[[
获取护驾奖励
]]
function QiyuManager:requestGetEscortingReward()
	if not self.escortingFinishMark then
		-- toastMessage("您的护驾还没有完成呢，着急什么呢？")
		toastMessage(localizable.QiyuManager_hujia_tips)
		return
	end

 	local msg = {

 	}
 	TFDirector:send(c2s.GET_ESCORTING_REWARD, {})
 end

--[[
挑战护驾
]]
function QiyuManager:requestChallengeEscorting(fightType)
	--if self.escortingFinishMark then
	--	toastMessage("您的护驾已经完成了,无法再挑战.")
	--	return
	--end

	local escortingInfo = self.escortingInfo
    local type = escortingInfo.type
    local finishTimes = escortingInfo.times
    local setting = EscortingSetting:objectByID(type)

    if self.escortingInfo.times > setting.max_times then
    	-- toastMessage("您今日挑战次数已经用完，明日再来.")
    	toastMessage(localizable.QiyuManager_hujia_tips2)
    	return
    end

    local waitTime = self:getEscortingWaitTime()
    if waitTime > 0 then
    	-- toastMessage("您应该耐心等待，行吗？")
    	toastMessage(localizable.QiyuManager_hujia_tips3)
    	return
    end
    if fightType == nil then
    	fightType = 0
    end
 	TFDirector:send(c2s.CHALLENGE_ESCORTING, {fightType})
 end

 --[[
获取护驾等待时间
 ]]
function QiyuManager:getEscortingWaitTime()
	if self.escortingInfo.remainWaitTime == 0 then
		return 0
	end

 	-- return math.max(0,self.escortingInfo.enableTime - GetCorrectTime())
 	
 	return math.max(0,self.escortingInfo.enableTime - MainPlayer:getNowtime())
 	
 end


QiyuManager.Escorting_Status_Coming = 1
QiyuManager.Escorting_Status_Can_Challenge = 2
QiyuManager.Escorting_Status_Finished = 3
QiyuManager.Escorting_Status_TodayTimes_Is_Zero = 4

--[[
获取当前护驾状态
@return 准备中：	QiyuManager.Escorting_Status_Coming , waitTime
		可以挑战：	QiyuManager.Escorting_Status_Can_Challenge
		已经结束：	QiyuManager.Escorting_Status_Finished
		次数为零：	QiyuManager.Escorting_Status_TodayTimes_Is_Zero
]]
function QiyuManager:getEscortingStatus()
 	--已经完成本次护驾
    --if self.escortingFinishMark then
    --    return QiyuManager.Escorting_Status_Finished
    --end

    local escortingInfo = self.escortingInfo
    local type = escortingInfo.type
    local finishTimes = escortingInfo.times
    local setting = EscortingSetting:objectByID(type)

    --当日挑战次数已经用完
    if finishTimes >= setting.max_times then
        return  QiyuManager.Escorting_Status_TodayTimes_Is_Zero
    end

    local waitTime = self:getEscortingWaitTime()
    if waitTime == 0 then
    	return QiyuManager.Escorting_Status_Can_Challenge
    else
    	return QiyuManager.Escorting_Status_Coming , waitTime
    end
end

-- 押镖

function QiyuManager:RequestYaBiaoInfo()
	-- showLoading()
	TFDirector:send(c2s.QUERY_YABIAO, {})
end

function QiyuManager:onReceiveYaBiaoInfo(event)
	-- print("接受押镖数据")
	local data = event.data.info[1]

	self.yabiaoData.id 						= data.id			--镖车ID
	self.yabiaoData.startTime 				= data.startTime 	--开始时间
	self.yabiaoData.endTime 				= data.endTime		--今日剩余押镖次数
	self.yabiaoData.status 					= data.status		--是否领取奖励
	self.yabiaoData.leftFreeRefreshTime 	= data.leftFreeRefreshTime 	--今日剩余免费刷新次数
	self.yabiaoData.leftYabiaoTime 			= data.leftYabiaoTime		--今日剩余押镖次数
	self.yabiaoData.nextRefreshCostSysee 	= data.nextRefreshCostSysee	--下次刷新花费元宝

	-- print("data = ", data)
	TFDirector:dispatchGlobalEventWith("rewardYaBiao")
end

-- 刷新镖车
function QiyuManager:RequestRefreshYaBiao()
	showLoading()
	TFDirector:send(c2s.REFRESH_YABIAO, {})
end

function QiyuManager:onReceiveRefreshYaBiao(event)
	hideLoading()
	TFDirector:dispatchGlobalEventWith("refreshYaBiao")
end

-- 开始押镖
function QiyuManager:RequestBeginYaBiao()
	showLoading()
	TFDirector:send(c2s.YABIAO, {})
end

-- 清除押镖CD
function QiyuManager:RequestClearYaBiaoCD()
	showLoading()
	TFDirector:send(c2s.REQUEST_CLEAR_YABIAO_CD, {})
end

function QiyuManager:onReceiveBeginYaBiao(event)
	hideLoading()
	TFDirector:dispatchGlobalEventWith("beginYaBiao")
end

function QiyuManager:onReceiveClearCDYaBiao(event)
	hideLoading()
	-- TFDirector:dispatchGlobalEventWith("rewardYaBiao")
end

-- 镖车领奖
function QiyuManager:RequestGetYaBiaoReward()
	showLoading()
	TFDirector:send(c2s.GET_YABIAO_REWARD, {})
end

function QiyuManager:RequestDealJiaYuanEvent( playerId, eventId)

	local maxTime = ConstantData:getValue("HomeEventMaximumTimes")
	-- print("self.eventOpenCount = ",self.eventOpenCount)
	if self.eventOpenCount >= maxTime then
		toastMessage(localizable.Jiayuan_home_event_times)
		return
	end
	showLoading()
	local msg = {
		playerId,
		eventId
	}
	self.dealPlayerId=playerId
	self.dealEventId = eventId
	TFDirector:send(c2s.OPEN_HOME_EVENT, msg)
end

function QiyuManager:RequestAccessRecord()
	showLoading()
	local msg = {
	}
	TFDirector:send(c2s.GAIN_ACCESS_RECORDS, msg)
end

function QiyuManager:onReceiveDealJiaYuanEvent(event)
	hideLoading()
	self:requestOpenJiayuan(false)
	self.isReceiveEventSuccess = true
	TFDirector:dispatchGlobalEventWith(QiyuManager.OPEN_HOME_EVENT_SCUESS,{self.dealEventId})
end

function QiyuManager:onReceiveAccessRecord(event)
	hideLoading()
	local layer = AlertManager:getLayerByName("lua.logic.qiyu.JiayuanAccessRecordLayer")
	if layer == nil then
		layer = AlertManager:addLayerByFile("lua.logic.qiyu.JiayuanAccessRecordLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
		layer:setData(event.data.records)
        AlertManager:show() 
	else
		layer:setData(event.data.records)
	end
	TFDirector:dispatchGlobalEventWith(QiyuManager.ACCESS_RECORDS,{event.data})
end

function QiyuManager:onReceiveRewardYaBiao(event)
	hideLoading()
	TFDirector:dispatchGlobalEventWith("rewardYaBiao")
end

--红点判断逻辑

--邀请码是否有礼包可领取
function QiyuManager:isCodeCanGetReward()
	return self.IsGetInviteReward
end

function QiyuManager:FunctionSwitchMsgHandle(event)
	if event.data.swithList == nil then
		return
	end
	-- print("运营活动开启控制 = ", event.data.swithList)
	local num = #event.data.swithList
	for i=1,num do
		local factionSwith = event.data.swithList[i]
		local factionId = factionSwith.factionId --运营活动ID;1御膳房; 2邀请码;3龙门镖局 ;4护驾 ;,5签到 6月卡;
		local isOpen 	= factionSwith.isOpen    --是否开启

		self.FunctionSwitchList[factionId] = {}
		self.FunctionSwitchList[factionId].id 		= factionId
		self.FunctionSwitchList[factionId].isOpen 	= isOpen
	end
end


function QiyuManager:SignIsOpen()
	return self:QiyuFuctionIsOpenByIndex(5)
end

function QiyuManager:MonthCardIsOpen()
	return self:QiyuFuctionIsOpenByIndex(12)
end

-- 是否可以押镖或者可以领奖
function QiyuManager:YABIAOIsHaveRedPoint()

	if self.yabiaoData then
		if self.yabiaoData.leftYabiaoTime ~= nil then
			-- 押镖是否可以领奖
			local nowTime 		= MainPlayer:getNowtime()*1000
			local status      	= self.yabiaoData.status             --是否领取奖励
			local endTime 		= self.yabiaoData.endTime
			 -- 闲置状态0 押镖状态1 领奖状态2
			 -- 没有正在押镖的时候增加红点
			if status == 0 then
    			if self.yabiaoData.leftYabiaoTime > 0 then
					return true
         		end
        	elseif status == 1 then
        		if nowTime >= endTime then
        			return true
        		end
    		else
    			return true
        	end


        end
   
	end

	return false
end

-- 是否可以吃猪
function QiyuManager:CanEatPig()
	for i=1,3 do
		local state = self:getEatPigState(i)
		if state == 2 then
			return true
		end
	end
	return false
	-- local enabledDiet = DietData:getCurrentDiet()
 --    if enabledDiet then
 --        local status = enabledDiet:getStatus(self.lastDietTime)
 --        if enabledDiet.id == 1 and status == 2 then
 --            return true
 --        elseif enabledDiet.id == 2 and status == 2 then
 --        	return true

 --        elseif enabledDiet.id == 3 and status == 2 then
 --        	return true
 --        end
 --    end

 --    return false
end


-- 护驾有红点
function QiyuManager:EscortingHaveRedPoint()
 	--已经完成本次护驾
    --if self.escortingFinishMark then
    --    return QiyuManager.Escorting_Status_Finished
    --end
    local verLock = VersionLockData:objectByID(EnumVersionLockType.HuJia_Lock)
	if verLock and verLock.open == 0 then
		return false
	end
    if self:getEscortingStatus() == QiyuManager.Escorting_Status_Can_Challenge then
    	return true
    end

    return false
end



function QiyuManager:isHaveRedPointWithIndex(index)

	local teamLev   = MainPlayer:getLevel()
    local openLevel = FunctionOpenConfigure:getOpenLevel(900+index)
    --  等级开发之后奇遇才会有红点
    if openLevel > teamLev then
        return false
    end
    if  index == QiYuType.EatPig then
        return self:CanEatPig()

    --elseif index == QiYuType.Invite then
        --return self:isCodeCanGetReward()
    elseif index == QiYuType.JiaYuan then
        return self:checkJiayuanRedPoint()

    elseif index == QiYuType.EscortTran then
        return self:YABIAOIsHaveRedPoint()

    elseif index == QiYuType.Escorting then
            return self:EscortingHaveRedPoint()
    -- 奇遇
    elseif index == QiYuType.NewSign then
        return self:IsSignToday()
    elseif index == QiYuType.Tmall then
        return false--self:isTouchTmall()
    elseif index == QiYuType.Gamble then
        return false
    elseif index == QiYuType.Fete then
        return self:isFeteHaveRedPoint()

    elseif index == QiYuType.RoleIdentify then
        return false
    elseif index == QiYuType.DaTi then
        return DaTiManager:getStartOrClose()
    end
    
    return true
end

function QiyuManager:checkJiayuanRedPoint()
    local InviteCodeInfo = self:GetInviteCodeData()
    local bIsGetReward = InviteCodeInfo.invited
    local bShow = true
    local levelLimit = ConstantData:getValue("Invite.Validate.Level")
    if MainPlayer:getLevel() > levelLimit or bIsGetReward then
        bShow = false
    end

    local timesInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.JIAYUAN_ZHUANPAN)
    local timesNum = timesInfo:getLeftChallengeTimes() or 0
    if MainPlayer:getServerSwitchStatue(ServerSwitchType.JiaYuan) then
        if timesNum >= 1 or bShow then
            return true
        end
    end
    return false
end

function QiyuManager:checkBeInviteRedPoint()
    local InviteCodeInfo = self:GetInviteCodeData()
    local bIsGetReward = InviteCodeInfo.invited
    local bShow = true
    local levelLimit = ConstantData:getValue("Invite.Validate.Level")
    if MainPlayer:getLevel() > levelLimit or bIsGetReward then
        bShow = false
    end

    if MainPlayer:getServerSwitchStatue(ServerSwitchType.JiaYuan) then
        if bShow then
            return true
        end
    end
    return false
end

function QiyuManager:isHaveRedPoint()

    for i=1, QiYuType.Max - 1 do
    	if self:isHaveRedPointWithIndex(i) then
    		return true
    	end
    end
    
    return false
end





function QiyuManager:QiyuFuctionIsOpenByIndex(index)
	if index == QiYuType.EatPig then
		return MainPlayer:getServerSwitchStatue(ServerSwitchType.EatPig )
	--elseif index == QiYuType.Invite then
		--return MainPlayer:getServerSwitchStatue(ServerSwitchType.Invite )
	elseif index == QiYuType.EscortTran then
		return MainPlayer:getServerSwitchStatue(ServerSwitchType.EscortTran )
	elseif index == QiYuType.Escorting then
		local verLock = VersionLockData:objectByID(EnumVersionLockType.HuJia_Lock)
		if verLock and verLock.open == 0 then
			return false
		end
		return MainPlayer:getServerSwitchStatue(ServerSwitchType.Escorting )
	elseif index == QiYuType.NewSign then
		return MainPlayer:getServerSwitchStatue(ServerSwitchType.NewSign )
	elseif index == QiYuType.Tmall then
		return MainPlayer:getServerSwitchStatue(ServerSwitchType.Tmall )
	elseif index == 12 then
		return MainPlayer:getServerSwitchStatue(ServerSwitchType.MonthCard )
    elseif index == QiYuType.JiaYuan then
        return MainPlayer:getServerSwitchStatue(ServerSwitchType.JiaYuan )
    elseif index == QiYuType.Gamble then
    	local gambleLock = VersionLockData:objectByID(EnumVersionLockType.Gamble_Lock)
	    if gambleLock and gambleLock.open == 0 then
	        return false
	    end
    	return true
    elseif index == QiYuType.Fete then
		return MainPlayer:getServerSwitchStatue(ServerSwitchType.JiSi )
	elseif index == QiYuType.DaTi then
        return MainPlayer:getServerSwitchStatue(ServerSwitchType.DaTi )
	end
	-- if self.FunctionSwitchList[index] == nil then
	-- 	return false
	-- end

	-- if self.FunctionSwitchList[index] and self.FunctionSwitchList[index].isOpen == false then
	-- 	return false
	-- end

	return true
end

function QiyuManager:QiyuFuctionIsOpen()
	-- 运营活动ID;1御膳房; 2邀请码;3龙门镖局 ;4护驾 ;5签到 6月卡
	for i=1,6 do
		if self:QiyuFuctionIsOpenByIndex(i) then
			return true
		end
	end

	return false
end

function QiyuManager:ActivityFuctionOnlineReward()
	return self:QiyuFuctionIsOpenByIndex(15)
end

function QiyuManager:ActivityFuctionIsOpenByIndex(index)
	return self:QiyuFuctionIsOpenByIndex(index + 10)
end

function QiyuManager:ActivityFuctionIsOpen()
-- 11	开服活动-大侠冲冲冲
-- 12	开服活动-寻找武林至尊
-- 13	开服活动-谁是江湖闯关王
-- 14	开服活动-7日登陆奖励
-- 15	开服活动-在线奖励
-- 16	开服活动-升级奖励
-- 17	开服活动-加入QQ群
-- 18	开服活动-提交BUG送礼
-- 19	开服活动-送VIP
-- 20	开服活动-邀请好友
	for i=11,20 do
		if self.FunctionSwitchList[i] and self.FunctionSwitchList[i].isOpen == true then
			return true
		end
	end
	
	return false
end

-- 1	御膳房
-- 2	邀请码
-- 3	龙门镖局
-- 4	护驾
-- 5	签到
-- 6	月卡(契约)
-- 11	开服活动-大侠冲冲冲
-- 12	开服活动-寻找武林至尊
-- 13	开服活动-谁是江湖闯关王
-- 14	开服活动-7日登陆奖励
-- 15	开服活动-在线奖励
-- 16	开服活动-升级奖励
-- 17	开服活动-加入QQ群
-- 18	开服活动-提交BUG送礼
-- 19	开服活动-送VIP
-- 20	开服活动-邀请好友

function QiyuManager:resetQiyuData()
	local data = self.GetSignRequest

    local monthDay    = data.monthDay    --当天是本月第几天
    local month       = data.month       --当前月数    
    local days        = data.monthDaySum --当前月数总共天数

    if monthDay < days then
    	self.GetSignRequest.monthDay = monthDay + 1
    else
    	self.GetSignRequest.monthDay = 1
    	self.GetSignRequest.month = month + 1
    	if self.GetSignRequest.month >= 13 then
    		 self.GetSignRequest.month = 1
    	end
    end
    
    --是否已签到
    self.GetSignRequest.isSign = false


	TFDirector:dispatchGlobalEventWith("monthCardUpdate")
	TFDirector:dispatchGlobalEventWith("getSignRequest")
end


-- 镖车领奖
function QiyuManager:VerifyInviteCode(inviteCode)
	showLoading()
    local deviceId = TFDeviceInfo.getMachineOnlyID() or "NULL"
	TFDirector:send(c2s.VERIFY_NEW_INVITE_CODE, {inviteCode, deviceId})
end


-- function QiyuManager:VerifyInviteCodeEventCallBack(event)
-- 	hideLoading()
-- 	TFDirector:dispatchGlobalEventWith("rewardYaBiao")
-- end



function QiyuManager:onReceiveInviteCodeEvent(event)
	-- hideLoading()


	-- required int32 myCode = 1;					//自己的邀请码
	-- required bool invited = 2; 					//自己是否验证过别人的邀请码
	-- required bool invitedAward = 3;				//是否已领受邀奖
	-- required int32 inviteCount = 4; 			//邀请好友次数
	-- required string getRewardRecord = 5; 		//邀请领奖记录，格式:id_达到条件次数_已领次数&id_次数...
	self.InviteCodeInfo = {}

	local data = event.data
	self.InviteCodeInfo.myCode     	 	 = data.myCode
	self.InviteCodeInfo.invited     	 = data.invited 			--自己是否被邀请过（验证过别人的邀请码
	self.InviteCodeInfo.invitedAward 	 = data.invitedAward
	self.InviteCodeInfo.inviteCount  	 = data.inviteCount			--主动邀请次数
	self.InviteCodeInfo.getRewardRecord  = data.getRewardRecord    	--已领取第n此奖励（形如：1,2,3,4,5,...表示已领取发送1,2,3,4,5次奖励）

	self:CheckInviteRewardIsGetNew()
	if self.IsGetInviteReward then
		-- print("有邀请码奖励未领取")
	else
		-- print("没有邀请码奖励")
	end
	TFDirector:dispatchGlobalEventWith("UpdateInviteCodeInfo")
end

function QiyuManager:GetInviteCodeData()
	return self.InviteCodeInfo
end

function QiyuManager:requestInviteCodeGift(invitedId)
	showLoading()
	TFDirector:send(c2s.GET_SEND_REWARD, {invitedId})

end

-- 邀请码奖励是否没有了领取
function QiyuManager:CheckInviteRewardIsGetNew()

    self.IsGetInviteReward = false

    local levelLimit = ConstantData:getValue("Invite.Validate.Level")
    if MainPlayer:getLevel() <= levelLimit then
        self.IsGetInviteReward = true

    	-- 没有被邀请 
    	if self.InviteCodeInfo.invited == false then
        	self.IsGetInviteReward = true
        	return
        else
        	self.IsGetInviteReward = false
    	end
        -- return 
    end


    local tblOfReward = string.split(self.InviteCodeInfo.getRewardRecord,'&')

    for k,v in pairs(tblOfReward) do
        local rewardInfo = string.split(v,'_')
        local id         = tonumber(rewardInfo[1])
        local numTotal   = tonumber(rewardInfo[2])      -- 可以领取总数
        local numGet     = tonumber(rewardInfo[3])      --已经领取次数
        local times  	 = numTotal - numGet

        if times > 0 then
        	self.IsGetInviteReward = true
        	return
        end
    end
end

--进入家园
function QiyuManager:requestOpenJiayuan(isOpenLunpan)
    if not MainPlayer:getServerSwitchStatue(ServerSwitchType.JiaYuan) then
        toastMessage(localizable.Jiayuan_server_close)
        return
    end

    showLoading()
    TFDirector:send(c2s.OPEN_HOME_REQUEST, {})
    self.isOpenLunpan = isOpenLunpan
    self:requestFriendPraiseRanks()
    --------test by wuqi start >>
    --[[
    local event = {}
    event.data = {}
    local tab = event.data
    tab.level = 15
    tab.exp = 0
    self:onReceiveOpenJiayuan(event)
    ]]
    --------test by wuqi end <<<<
end

function QiyuManager:onReceiveOpenJiayuan(event)
    hideLoading()

    local data = event.data
    local oldLevel = self.jiayuanData.level
    local isChangeLvl = false
    self.jiayuanData.level = data.level

    if oldLevel and oldLevel < data.level then
    	isChangeLvl = true
    end
    self.jiayuanData.exp = data.exp   
    self.jiayuanData.praiseCount = data.praiseCount or 0          
    self.jiayuanData.praiseFriends = {}
    if data.praiseFriends then
		for i=1,#data.praiseFriends do
			local roleId = data.praiseFriends[i]
			self.jiayuanData.praiseFriends[roleId] = 1
		end
	end          
    self.jiayuanData.drawCount = data.drawCount or 0
    self.homeEventMsg = data.events or {}
    self.eventOpenCount = data.eventOpenCount
    if data.events then
	    for i,v in pairs(data.events) do
	        if v.eventId == 4 then
	            self.jiayuanYoufangTime=v.time/1000+86400
	            break
	        end
	    end
	end
    --TFDirector:dispatchGlobalEventWith(QiyuManager.OPEN_HOME_REPONSE, data)

    local layer = AlertManager:getLayerByName("lua.logic.qiyu.JiayuanLayer")
    if layer == nil then
        layer = AlertManager:addLayerByFile("lua.logic.qiyu.JiayuanLayer")
        AlertManager:show() 
        local daibi = BagManager:getItemNumById(30153)
    	if daibi > 0 or MainPlayer:isEnoughTimes(EnumRecoverableResType.JIAYUAN_ZHUANPAN, 1, false) then
            if layer and layer.contentLayer and layer.contentLayer.onZhuanpanClickHandle then
                layer.contentLayer:zhuanpanClick()
            end
        end    
        return
    end
    layer:refreshUI(isChangeLvl)
end

function QiyuManager:requestJiayuanLunpan()
    showLoading()
    TFDirector:send(c2s.HOME_TURNTABLE_REQUEST, {})
end

function QiyuManager:onReceiveJiayuanLunpan(event)
    hideLoading()
    local data = event.data
    -- print("QiyuManager:onReceiveJiayuanLunpan(event) >>> ", data)
    TFDirector:dispatchGlobalEventWith(QiyuManager.HOME_TURNTABLE_REPONSE, data)
end

--家园升级
function QiyuManager:requestJiayuanLevelUp(data)
    --showLoading()
    local Msg = {data}
    TFDirector:send(c2s.HOME_LEVEL_UP_REQUEST, Msg)

    -- print("requestJiayuanLevelUp >>> ", data)
end

function QiyuManager:requestHomeShare()
    showLoading()
    TFDirector:send(c2s.HOME_SHARE_REQUEST, {})
end

function QiyuManager:getJiayuanData()
    return self.jiayuanData or {}
end

function QiyuManager:getJiayuanLevel()
    local jiayuanData = self:getJiayuanData()
    local level = jiayuanData.level or 0
    return level
end

function QiyuManager:setJiayuanLevel(level)
    local jiayuanData = self:getJiayuanData()
    jiayuanData.level = level
end

function QiyuManager:getJiayuanAttr()
    local level = self:getJiayuanLevel()

    return FamilyData:getTotalAttr(level)
end

function QiyuManager:getJiayuanNextAttr()
    local level = math.min(self:getJiayuanLevel() + 1, FamilyData:length())

    return FamilyData:getTotalAttr(level)
end

function QiyuManager:getJiayuanEventMsg()
	return self.homeEventMsg
end

function QiyuManager:onReceiveFriendPraiseRanks(event)
	local data = event.data
	self.homeFriendPraiseRanks = self.homeFriendPraiseRanks or TFArray:new()
	self.homeFriendPraiseRanks:clear()
	if data.ranks then
		for i=1,#data.ranks do
			local playerInfo = data.ranks[i]
			self.homeFriendPraiseRanks:push(playerInfo)
		end
	end

    TFDirector:dispatchGlobalEventWith(QiyuManager.Receive_Friend_Praise_Ranks, {})
end

function QiyuManager:requestFriendPraiseRanks()
    -- showLoading()
    TFDirector:send(c2s.GAIN_FRIEND_PRAISE_RANKS, {})
end

function QiyuManager:requestHomePraise(friendId)
	local jiayuanData = self:getJiayuanData()
	if jiayuanData.praiseFriends[friendId] and jiayuanData.praiseFriends[friendId] == 1 then
		toastMessage(localizable.NiuBilityManager_dianzan)
		return	
	end

    showLoading()
    self.click_praise_friendId = friendId
    TFDirector:send(c2s.HOME_PRAISE, {friendId})
end

function QiyuManager:requestDrawHomeAward()
	local jiayuanData = self:getJiayuanData()
	local praiseData = HomePraiseAwardData:objectByID(1)
	if praiseData == nil then
		return
	end
	if jiayuanData.drawCount >= math.floor(jiayuanData.praiseCount/praiseData.praise) then
		toastMessage(localizable.Jiayuan_zan_not_enough)
		return
	end
    showLoading()
    TFDirector:send(c2s.DRAW_HOME_AWARD, {})
end

function QiyuManager:onReceivePraiseSucess(event)
	hideLoading()
	toastMessage(localizable.Jiayuan_zan_success)
	if self.click_praise_friendId and self.click_praise_friendId ~= 0 then
		local jiayuanData = self:getJiayuanData()
		jiayuanData.praiseFriends[self.click_praise_friendId] = 1
		for firendInfo in self.homeFriendPraiseRanks:iterator() do
	        if firendInfo.playerId == self.click_praise_friendId then
	        	firendInfo.praiseCount = firendInfo.praiseCount + 1
	        	TFDirector:dispatchGlobalEventWith(QiyuManager.Receive_Friend_Praise_Fresh, {})
	    		self.click_praise_friendId = 0
	        	return
	        end
	    end
	    self.click_praise_friendId = 0
	end
end

function QiyuManager:onReceiveDrawHomeAwardScuess(event)
	hideLoading()
	local jiayuanData = self:getJiayuanData()
    jiayuanData.drawCount = jiayuanData.drawCount + 1
    TFDirector:dispatchGlobalEventWith(QiyuManager.Receive_Draw_HomeAward_Scuess, {})
end

function QiyuManager:onReceiveJiayuanLevel(event)
	hideLoading()
    local data = event.data
    -- print("QiyuManager:onReceiveJiayuanLevel(event) >>> ", data)
    self:setJiayuanLevel(data.level)
	TFDirector:dispatchGlobalEventWith(QiyuManager.HOME_LEVEL_REPONSE,nil)

end

function QiyuManager:goShare(type)
    if not type then
        type = 1
    end
    self.shareType = type
    AlertManager:addLayerByFile("lua.logic.qiyu.JiayuanInviteSendLayer")
    AlertManager:show()
end

function QiyuManager:goShare2()
    -- print("start share!")

    if not self.shareType then
        self.shareType = 1
    end
    AlertManager:addLayerByFile("lua.logic.qiyu.JiayuanShareLayer")
    AlertManager:show()
end

function QiyuManager:share(index)
    if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
        -- print("++++++++++ win32!!!!")
        if self.shareType and self.shareType == 2 then
            TFDirector:send(c2s.HOME_LEVEL_SHARE_REQUEST, {})
        else
            TFDirector:send(c2s.HOME_SHARE_REQUEST, {})
        end
        return
    end

    self.shareCallback = function(result)
        if result == HeitaoSdk.LOGIN_SHARE_SUCESS then
            if self.shareType and self.shareType == 2 then
                TFDirector:send(c2s.HOME_LEVEL_SHARE_REQUEST, {})
            else
                TFDirector:send(c2s.HOME_SHARE_REQUEST, {})
            end
        else
            toastMessage(localizable.Jiayuan_share_fail)
        end
    end

    local currentServer = SaveManager:getCurrentSelectedServer()
    local serverName = "[" .. SaveManager:getServerName(currentServer) .. "]"
    local InviteCodeInfo = self:GetInviteCodeData()
    local InviteCode = InviteCodeInfo.myCode
    local myName = MainPlayer:getPlayerName()

    local desc1 = localizable.Jiayuan_share_desc1
    --local desc2 = stringUtils.format(localizable.Jiayuan_share_desc2, serverName, myName) 
    --local desc3 = stringUtils.format(localizable.Jiayuan_share_desc3, InviteCode)
    local desc2 = localizable.Jiayuan_share_desc2
    local desc3 = localizable.Jiayuan_share_desc3
    local desc4 = localizable.Jiayuan_share_desc4

    local notifyStr = desc1 .. serverName .. desc2 .. myName .. desc3 .. InviteCode .. desc4

    if HeitaoSdk then
        HeitaoSdk.setSharecallback(self.shareCallback)
        local ret = HeitaoSdk.shareGameInfo(index, notifyStr)
        if not ret then
            toastMessage(localizable.Jiayuan_share_fail)
        end
    end
end

function QiyuManager:openLoginAcceptLayer()
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.qiyu.JiayuanLoginCodeLayer", AlertManager.BLOCK_AND_GRAY)
    AlertManager:show()
end

function QiyuManager:setLoginAcceptCode(str)
    if (not str) or str == "" then
        return
    end
    self.loginAcceptCode = str
end

function QiyuManager:getLoginAcceptCode()
    return self.loginAcceptCode or 0
end

function QiyuManager:openInviteSuccessLayer()
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.qiyu.JiayuanInviteSuccess", AlertManager.BLOCK_AND_GRAY)
    AlertManager:show()
end

-- 祭祀红点
function QiyuManager:isFeteHaveRedPoint()
	
	if JiSiManager.everyDayGetTime then
        local NowTimeData = GetCorrectDate("*t", MainPlayer:getNowtime())
        local lastTiemDate = GetCorrectDate("*t", JiSiManager.everyDayGetTime * 0.001)
        if lastTiemDate then
			if NowTimeData.year > lastTiemDate.year then
				return true
			elseif NowTimeData.year == lastTiemDate.year and NowTimeData.yday > lastTiemDate.yday then
                return true
            end
        end
    end
    return false
end
return QiyuManager:new()
