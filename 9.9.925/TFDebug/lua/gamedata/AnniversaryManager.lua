-- 周年庆活动
-- Author: shenjingjie
-- Date: 2017-11-21
--.
local AnniversaryManager = class('AnniversaryManager')


AnniversaryManager.Type_ZhouNianH 			= 41   --周年庆·活跃任务
AnniversaryManager.Type_ZhouNianK			= 42   --周年庆·狂欢任务
AnniversaryManager.Type_ZhouNianD			= 43   --周年庆·兑换任务
AnniversaryManager.Type_ZDZX 				= 44   --整点在线
AnniversaryManager.Type_ZhouNianQ			= 45   --周年庆·每日签到
AnniversaryManager.Type_TJHL 				= 102  --天降好礼



AnniversaryManager.MSG_ACTIVITY_UPDATE 	  		= "AnniversaryManager.MSG_ACTIVITY_UPDATE"
AnniversaryManager.MSG_EXCHANGE_UPDATE 	  		= "AnniversaryManager.MSG_EXCHANGE_UPDATE"
AnniversaryManager.MSG_SIGN_UPDATE 	  			= "AnniversaryManager.MSG_SIGN_UPDATE"

function AnniversaryManager:ctor()

	-- 记录活动列表（活动的相关信息 id 名字 type ）
    self.ActivityInfoList 	= TFMapArray:new()
    self.isNew = true
    -- 周年庆活动列表
    TFDirector:addProto(s2c.ANNIVERSARY_RESPONSE, self, self.updateActivityListEvent)
    -- 兑换活动回调
    TFDirector:addProto(s2c.EXCHANGE_REWARD_REPONSE, self, self.updateExchange)
    -- 整点在线和天降好礼
    TFDirector:addProto(s2c.ACTIVITIES_INFO_RESPONSE, self, self.updateActivity)
   	--每日签到
   	TFDirector:addProto(s2c.SIGNER_INFO_RESPONSE, self, self.updateActivitySignEvent)



end
-- 重新清除数据
function AnniversaryManager:restart()

	-- -- 重置活动
	-- -- self.ActivityList = nil
	-- -- self.activityData = {}

	self.ActivityInfoList:clear()
end

function AnniversaryManager:restart_24()

	-- -- 重置活动
	-- -- self.ActivityList = nil
	-- -- self.activityData = {}

	self.ActivityInfoList:clear()
end

function AnniversaryManager:updateActivityListEvent(event)
	-- print("AnniversaryManager:updateActivityListEvent(event)",event.data)
	if event.data == nil then
		return
	end
	
	if (self.isNew) then
		self.ActivityInfoList:clear()
		self.isNew = false
	end

	for i,v in pairs(event.data.AnniInfo) do
		-- print("v = ", v)
		-- 针对每个活动单独解析
		self:updateAnniversaryActivityData(v)
	end
	self:activityInfoListSort()
	
	-- TFDirector:dispatchGlobalEventWith(self.MSG_ACTIVITY_UPDATE, {})
end
function AnniversaryManager:updateExchange( event )
	hideLoading()
	if event.data == nil then
		return
	end
	local data = event.data.info[1]
	local activityInfo = self.ActivityInfoList:objectByID(self.Type_ZhouNianD)
	local currReward = activityInfo.activityReward:objectByID(data.exchangeId)
	local Carni = CarniValShopData:getSingleCarniValById(data.exchangeId)
	currReward.progress 	= Carni.chance - data.count

	TFDirector:dispatchGlobalEventWith(self.MSG_EXCHANGE_UPDATE, {})
end

function AnniversaryManager:activityInfoListSort()
	local function sortlist( v1,v2 )
		if v1.type and v2.type then
			return v1.type < v2.type
		end
		return false
	end
	self.ActivityInfoList:sort(sortlist)
end
-- 整点在线和天降好礼
function AnniversaryManager:updateActivity(event)

	if event.data == nil then
		return
	end
	local sinleActivityInfo = nil

	event.data.detil = event.data.detil or {}

	
	for i,v in pairs(event.data.detil) do
		-- print("v = ", v)
		-- 针对每个活动单独解析
		local activityId = v.type

		local bNewActivity = false
		sinleActivityInfo = self.ActivityInfoList:objectByID(activityId)
		if sinleActivityInfo == nil then
			sinleActivityInfo = {}
			bNewActivity = true
		end
		sinleActivityInfo.type			= v.type

		sinleActivityInfo.beginTime = v.startTime * 0.001
		sinleActivityInfo.endTime = v.endTime * 0.001
		sinleActivityInfo.startTime = sinleActivityInfo.beginTime

		sinleActivityInfo.name			= localizable.Anniversary_Name[activityId]
		sinleActivityInfo.details		= localizable.Anniversary_details[activityId]
		if (bNewActivity) then
			sinleActivityInfo.value 		= 0
			self.ActivityInfoList:pushbyid(sinleActivityInfo.type, sinleActivityInfo)
		end
	end

end


--把周年活动塞进活动列表
function AnniversaryManager:updateAnniversaryActivityData(data)
	local sinleActivityInfo = nil

	local activityId = data.type

	local bNewActivity = false
	sinleActivityInfo = self.ActivityInfoList:objectByID(activityId)
	if sinleActivityInfo == nil then
		sinleActivityInfo = {}
		bNewActivity = true
	end

	sinleActivityInfo.type			= data.type
	sinleActivityInfo.mission 		= data.mission
	sinleActivityInfo.name			= localizable.Anniversary_Name[activityId]
	sinleActivityInfo.details		= localizable.Anniversary_details[activityId]
	sinleActivityInfo.sendDataFlag = false
	
	-- 活动开启时间startTimez 格式  "2017-09-04 12:00:00"
	sinleActivityInfo.beginTime 	= localizable.sinleActivityInfo_BeginTime
	sinleActivityInfo.endTime 		= localizable.sinleActivityInfo_endTime
	if (activityId == self.Type_ZhouNianD) then
		sinleActivityInfo.endTime 		= localizable.sinleActivityInfo_endTime
	end

	if sinleActivityInfo.beginTime == "" then
		sinleActivityInfo.beginTime = nil
	else
		sinleActivityInfo.beginTime = getTimeByDate(sinleActivityInfo.beginTime)
	end

	if sinleActivityInfo.endTime == "" then
		sinleActivityInfo.endTime = nil
	else
		sinleActivityInfo.endTime = getTimeByDate(sinleActivityInfo.endTime)
	end
	sinleActivityInfo.startTime = sinleActivityInfo.beginTime

	if (bNewActivity) then
		sinleActivityInfo.value 		= 0
		self.ActivityInfoList:pushbyid(sinleActivityInfo.type, sinleActivityInfo)
	end
	self:updateActivityRewardData(sinleActivityInfo)
end
--每日签到
function AnniversaryManager:updateActivitySignEvent(event)
	print("每日签到",event.data)
	if event.data == nil then
		return
	end
	local data = event.data
	local sinleActivityInfo = nil

	local activityId = data.type

	local bNewActivity = false
	sinleActivityInfo = self.ActivityInfoList:objectByID(activityId)
	if sinleActivityInfo == nil then
		sinleActivityInfo = {}
		bNewActivity = true
	end

	sinleActivityInfo.type			= data.type
	sinleActivityInfo.name			= localizable.Anniversary_Name[activityId]
	sinleActivityInfo.details		= localizable.Anniversary_details[activityId]
	sinleActivityInfo.sendDataFlag = false
	sinleActivityInfo.signTime = data.signTime
	sinleActivityInfo.progress = data.progress
	-- 活动开启时间startTimez 格式  "2017-09-04 12:00:00"
	sinleActivityInfo.beginTime 	= localizable.sinleActivityInfo_BeginTime
	sinleActivityInfo.endTime 		= localizable.sinleActivityInfo_endTime

	if sinleActivityInfo.beginTime == "" then
		sinleActivityInfo.beginTime = nil
	else
		sinleActivityInfo.beginTime = getTimeByDate(sinleActivityInfo.beginTime)
	end

	if sinleActivityInfo.endTime == "" then
		sinleActivityInfo.endTime = nil
	else
		sinleActivityInfo.endTime = getTimeByDate(sinleActivityInfo.endTime)
	end
	sinleActivityInfo.startTime = sinleActivityInfo.beginTime

	if (bNewActivity) then
		sinleActivityInfo.value 		= 0
		self.ActivityInfoList:pushbyid(sinleActivityInfo.type, sinleActivityInfo)
	else
		TFDirector:dispatchGlobalEventWith(self.MSG_SIGN_UPDATE, {})
	end
	-- self:updateActivityRewardData(sinleActivityInfo)
end
--存目标数据
function AnniversaryManager:updateActivityRewardData( activityInfo )
	local activityType 		= activityInfo.type

	local singleActivityReward = activityInfo.activityReward or nil
	if singleActivityReward == nil then
		singleActivityReward = MEMapArray:new()
	else
		singleActivityReward:clear()
	end
	activityInfo.activityReward = singleActivityReward
	--周年活跃和狂欢活动
	if (activityType == self.Type_ZhouNianH or activityType == self.Type_ZhouNianK) then
		local CountReward = 1

		for k,v in pairs(activityInfo.mission) do
			
			local activityRewardData = {
					index 		= CountReward,
					Id 			= v.activityId,
					status  	= v.status,
					progress 	= v.progress,
					missionType = v.missionType
				}
			singleActivityReward:pushbyid(CountReward,activityRewardData)
			CountReward = CountReward + 1
		end
		TFDirector:dispatchGlobalEventWith(self.MSG_ACTIVITY_UPDATE, {})
	--周年庆兑换活动
	elseif (activityType == self.Type_ZhouNianD) then
		local CountReward = 1
		for k,v in pairs(activityInfo.mission) do
			local Carni = CarniValShopData:getSingleCarniValById(v.activityId)
			local activityRewardData = {
					index 		= CountReward,
					Id 			= v.activityId,
					status  	= v.status,
					progress 	= Carni.chance - v.progress
				}
			singleActivityReward:pushbyid(CountReward,activityRewardData)
			CountReward = CountReward + 1
		end
	end

end

--发送所获取的奖励的id
function AnniversaryManager:RequireAnniversaryReward(id, type, kind)
	-- showLoading()
	TFDirector:send(c2s.REWARD_REQUEST,{id,type,kind})
end
function AnniversaryManager:ExchangeRewardRequest(id)
	showLoading()
	TFDirector:send(c2s.EXCHANGE_REWARD_REQUEST,{id})
end
--请求签到
function AnniversaryManager:SignRequest(rewardId)
	showLoading()
	TFDirector:send(c2s.SIGNER_REQUEST,{rewardId})
end
function AnniversaryManager:openHomeLayer()
	if self.ActivityInfoList == nil then
		-- toastMessage("还没有开启的活动")
		toastMessage(localizable.GameActivitiesManager_no_acitivty)
		return
	end

	if self.ActivityInfoList:length() < 1 then
		-- toastMessage("还没有开启的活动")
		toastMessage(localizable.GameActivitiesManager_no_acitivty)
		return
	end
	-- if show_type == nil then
	-- 	show_type = 0
	-- end
	-- local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.gameactivity.OpenServiceHomeLayer", AlertManager.BLOCK_AND_GRAY)
	local layer = require("lua.logic.zhounianqing.AnniversaryMainLayer"):new()
	AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY)
    layer:select(1)
    AlertManager:show()
end

-- 获取活动的相关信息
function AnniversaryManager:getActivityInfo(ActivityId)
	-- print("self.ActivityInfoList = ",self.ActivityInfoList)
	-- print("ActivityId = ", ActivityId)
	return self.ActivityInfoList:objectByID(ActivityId)
end

function AnniversaryManager:isHaveRewardCanGet()
	for v in self.ActivityInfoList:iterator() do

		if (self:isHaveRewardCanGetByActivity(v.type) == true) then
			print(v.name.."红点")
			return true
		end
	end

	return false
end

function AnniversaryManager:isHaveRewardCanGetByActivity(activitytype)
	local activity = self:getActivityInfo(activitytype)

	if (activitytype == AnniversaryManager.Type_ZhouNianH or activitytype == AnniversaryManager.Type_ZhouNianK) then
		
		for k,data in pairs(activity.activityReward.map) do
        	if (data.Id == nil) then 
        	    break
        	end
        	local Id = CarniValData:getSingleCarniValByTypeKind(activity.type,data.missionType).id
        	local Data = CarniValData:objectByID(Id)
       		if Data.target <= data.progress and data.status == 1 then 
       			return true
       		end
       	end
    -- elseif (activitytype == AnniversaryManager.Type_ZhouNianD) then
    -- 	local bagInfo = BagManager:getItemById(30306)
    -- 	print("背包信息30306",bagInfo)
    -- 	for k,data in pairs(activity.activityReward.map) do
    -- 		if (data.Id == nil) then 
    --     	    break
    --     	end
        	
    --     	local shopInfo = CarniValShopData:getSingleCarniValById(data.Id)
    --     	local coin_num = tonumber(string.split(shopInfo.coin_num,"_")[3])
    --     	if (data.progress > 0 and bagInfo.num >= coin_num) then
    --     		return true
    --     	end
    -- 	end

    elseif (activitytype == AnniversaryManager.Type_ZhouNianQ) then
    	local nowTiem = os.date("*t", MainPlayer:getNowtime())
	    local lastTiemDate = os.date("*t", activity.signTime * 0.001)
	    if (nowTiem.yday ~= lastTiemDate.yday) then
	    	return true
	    end
	end

end

function AnniversaryManager:isShowInMenu()
	local currTime = MainPlayer:getNowtime()

	for v in self.ActivityInfoList:iterator() do
		if (v.startTime <= currTime and currTime <= v.endTime) then
			return true
		end
	end
	return false
end

function AnniversaryManager:getOpenAndShowActivityList()
	local activityList = {}
	local num = 0
	local currTime = MainPlayer:getNowtime()
	for v in self.ActivityInfoList:iterator() do
		if (v.startTime <= currTime and currTime <= v.endTime) then
				num = num + 1
				activityList[num] = v.type
				print("AnniversaryManager",v.type)
		end
	end

	return activityList, num
end

function AnniversaryManager:isHaveRewardCanGetByActivityId(activityId)
	local activityInfo  = self:getActivityInfo(activityId)
	if activityInfo == nil then
		return false
	end
	
	local bHaveRedPoint = self:isHaveRewardCanGetByActivity(activityInfo.type)

	return bHaveRedPoint
end


return AnniversaryManager:new()