-- client side PeakManager.lua
--[[
 * @Description: 论剑峰管理类
 ]]
-- script writer chikui
-- creation time 2016-06-20

local PeakManager = class("PeakManager")

PeakManager.RECEIVE_PEAK_INFO               = "PeakManager.RECEIVE_PEAK_INFO"
PeakManager.RECEIVE_OCCUPIED_PEAK_INFO      = "PeakManager.RECEIVE_OCCUPIED_PEAK_INFO"
PeakManager.RECEIVE_ABANDON_PEAK            = "PeakManager.RECEIVE_ABANDON_PEAK"
PeakManager.RECEIVE_BATTLE_LOG              = "PeakManager.RECEIVE_BATTLE_LOG"
PeakManager.RECEIVE_PEAK_REVENGE            = "PeakManager.RECEIVE_PEAK_REVENGE"
PeakManager.RECEIVE_IS_IN_BATTLE            = "PeakManager.RECEIVE_IS_IN_BATTLE"
PeakManager.RECEIVE_RANKING_INFO            = "PeakManager.RECEIVE_RANKING_INFO"
PeakManager.RECEIVE_ERROR_PEAK_CHANGED      = "PeakManager.RECEIVE_ERROR_PEAK_CHANGED"
PeakManager.RECEIVE_PEAK_FALL               = "PeakManager.RECEIVE_PEAK_FALL"
PeakManager.RECEIVE_LAST_CHAMPION_MSG       = "PeakManager.RECEIVE_LAST_CHAMPION_MSG"
PeakManager.RECEIVE_FIGHT_END               = "PeakManager.RECEIVE_FIGHT_END"
PeakManager.RECEIVE_ACTIVITY_STATE          = "PeakManager.RECEIVE_ACTIVITY_STATE"
PeakManager.RECEIVE_FACTION_RANK            = "PeakManager.RECEIVE_FACTION_RANK"
PeakManager.PER_PAGE_NUM = 6

PeakManager.Peak_Open_StartTime =  "00:05:00"
PeakManager.Peak_Open_EndTime =  "23:55:00"

local PeakGuildAttribute = require('lua.table.t_s_peak_guild_attrib')
function PeakManager:ctor(data)
    TFDirector:addProto(s2c.OPEN_PEAK_REPONSE, self, self.onReceivePeakInfo)
    TFDirector:addProto(s2c.OCCUPIED_PEAK_REPONSE, self, self.onReceiveOccupiedPeakInfo)
    TFDirector:addProto(s2c.ABANDON_PEAK_REPONSE, self, self.onReceiveAbandonPeak)
    TFDirector:addProto(s2c.PEAK_BATTLE_LOG_REPONSE, self, self.onReceiveBattleLog)
    TFDirector:addProto(s2c.PEAK_REVENGE_REPONSE, self, self.onReceiveRevengeInfo)
    TFDirector:addProto(s2c.TARGET_BATTLE_REPONSE, self, self.onReceiveIsInBattle)
    TFDirector:addProto(s2c.PEAK_RANKING_REPONSE, self, self.onReceiveRankingInfo)
    TFDirector:addProto(s2c.PEAK_FALL_REPONSE, self, self.onReceivePeakFall)
    TFDirector:addProto(s2c.PEAK_RANKING_HISTORY_REPONSE, self, self.onReceiveLastChampionMsg)
    TFDirector:addProto(s2c.PEAK_BATTLE_END_REPONSE, self, self.onReceiveFightEnd)
    TFDirector:addProto(s2c.PEAK_IS_OPEN_REPONSE, self, self.onReceiveActivitySate)
    TFDirector:addProto(s2c.PEAK_GUILD_RANKS, self, self.onReceiveFactionRank)

    ErrorCodeManager:addProtocolListener(s2c.OCCUPIED_PEAK_REPONSE,  function(target,event)
        if event.errorCode == 0x7102 then
            TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_ERROR_PEAK_CHANGED, {})
            return true
        end
    end)
    ErrorCodeManager:addProtocolListener(s2c.TARGET_BATTLE_REPONSE,  function(target,event)
        if event.errorCode == 0x7102 then
            TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_ERROR_PEAK_CHANGED, {})
            return true
        end
    end)
    self:restart()
end

function PeakManager:restart()
    self.floorInfo  = {}
    self.curInfo    = {}
    self.battleLog  = {}
    self.rankInfo   = {}
    self.myRankInfo = {}
    self.factionRank = {}
    self.factionMyIntegra = 0
    self.factionMyRank = 0
    self.isInPoint  = false
    self.activityState = 1
end

-- 请求论剑峰信息
function PeakManager:requestPeakInfo( floorId , pageIdx )
    showLoading()
    local msg = {
        floorId,
        pageIdx
    }
    TFDirector:send(c2s.OPEN_PEAK_REQUEST,msg)
end

-- 请求阵眼信息
function PeakManager:requestOccupiedPeakInfo( floorId , pos , playerId )
    showLoading()
    local msg = {
        floorId,
        pos,
        playerId
    }
    TFDirector:send(c2s.OCCUPIED_PEAK_REQUEST,msg)
end

-- 请求放弃阵眼
function PeakManager:requestAbandonPeak()
    if self:isPeakOpen() == false then
        toastMessage(localizable.LunJianFeng_txt_Close)
        return
    end
    showLoading()
    TFDirector:send(c2s.ABANDON_PEAK_REQUEST,{})
end

-- 请求购买挑战次数
function PeakManager:requestBuyChallengeNum()
    showLoading()
    TFDirector:send(c2s.BUY_CHALLENGE_NUM_REQUEST,{})
end

-- 请求战斗日志
function PeakManager:requestBattleLog()
    showLoading()
    TFDirector:send(c2s.PEAK_BATTLE_LOG_REQUEST,{})
end

-- 请求复仇
function PeakManager:requestRevengeInfo( floorId , pos , playerId )
    showLoading()
    local msg = {
        playerId,
        pos,
        floorId
    }
    TFDirector:send(c2s.PEAK_REVENGE_REQUEST,msg)
end

-- 请求开始论剑峰战斗
function PeakManager:requestStartBattle( playerId , serverId , result , pos , layer )
    if self:isPeakOpen() == false then
        toastMessage(localizable.LunJianFeng_txt_Close)
        return
    end
    showLoading()
    local msg = {
        playerId,
        serverId,
        result,
        pos,
        layer,
    }
    TFDirector:send(c2s.START_PEAK_BATTLE_REQUEST,msg)
end

-- 请求排行榜信息
function PeakManager:requestRankingInfo( startRank )
    showLoading()
    local msg = {
        startRank
    }
    if startRank == 1 then
        self.rankInfo = {}
    end
    TFDirector:send(c2s.PEAK_RANKING_REQUEST,msg)
end

function PeakManager:requestLastChampion()
    showLoading()
    TFDirector:send(c2s.PEAK_RANKING_HISTORY_REQUEST,{})
end 

function PeakManager:requestFactionRank(startRank)
    showLoading()
    self.factionStartRank = startRank
    local msg = {
        startRank
    } 
    TFDirector:send(c2s.GAIN_PEAK_GUILD_RANKS,msg)
end 
-->>>>>>>-------------------------------------------->>>>>>>>--

function PeakManager:onReceivePeakInfo(event)
    hideLoading()

    self.curInfo = event.data.myInfo or {}
    self.curInfo.startTime = self.curInfo.startTime/1000
    self.curInfo.settleTime = self.curInfo.settleTime/1000
    self.curInfo.unitedTime = self.curInfo.unitedTime/1000
    if self.curInfo.layer and self.curInfo.layer > 0 and self.curInfo.pos and self.curInfo.pos > 0 then
        self.isInPoint = true
    else
        self.isInPoint = false
    end
    self.floorInfo = event.data.info or {}
    self.guildInfo = event.data.guildInfo or {}
    self.unitedInfo = event.data.united or {}
    local pageIdx = event.data.page
    local floorId = event.data.layer
    self.pageIdx = pageIdx
    local sort_Func = function( info1 , info2 )
        if info1.pos > info2.pos then
            return false
        end
        return true
    end
    table.sort(self.floorInfo,sort_Func)

    
    if self.isOpenMainLayer == true then
        self.isOpenMainLayer = false
        local layer  = require("lua.logic.peak.PeakMainLayer"):new()
        layer:drawFloorInfo({pageIdx = pageIdx,floorId = floorId})
        AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
        AlertManager:show()
    end
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_PEAK_INFO, {pageIdx = pageIdx,floorId = floorId})
end

function PeakManager:onReceiveOccupiedPeakInfo(event)
    hideLoading()
    local data = event.data
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_OCCUPIED_PEAK_INFO, data)
end

function PeakManager:onReceiveAbandonPeak(event)
    hideLoading()
    if event.data.result ~= 2 then
        TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_ABANDON_PEAK, {})
    else
        self.isInPoint = true
    end
end

function PeakManager:onReceiveBattleLog(event)
    hideLoading()
    self.battleLog = event.data.info or {}
    table.sort(self.battleLog, function(a, b)
        return a.battleTime > b.battleTime
    end)

    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_BATTLE_LOG, {})

    local layer = AlertManager:getLayerByName("lua.logic.peak.LunJianRecord")
    if layer == nil then
        layer = AlertManager:addLayerByFile("lua.logic.peak.LunJianRecord",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
        AlertManager:show()
        return
    end
    layer:refreshUI()
end

function PeakManager:onReceiveRevengeInfo(event)
    hideLoading()
    local data = event.data
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_PEAK_REVENGE, data)
end

function PeakManager:onReceiveIsInBattle(event)
    hideLoading()
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_IS_IN_BATTLE, {isInBattle = event.data.result})
end

function PeakManager:onReceiveRankingInfo(event)
    hideLoading()
    self.rankInfo = self.rankInfo or {}
    local data = event.data.info or {}

    self.bRankFull = false
    if #data < 10 then
        self.bRankFull = true
    end

    for k,v in pairs(data) do
        self.rankInfo[v.ranking] = v
    end
    self.myRankInfo = {}
    self.myRankInfo.myRanking = event.data.myRanking or 0
    self.myRankInfo.myIntegral = event.data.myIntegral or 0
    self.myRankInfo.bestIntegral = event.data.bestIntegral or 0
    self.myRankInfo.guildIntegral = event.data.guildIntegral or 0
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_RANKING_INFO, {})
    if self.isOpenBuffLayer == true then
        self.isOpenBuffLayer = false
        if self:getTotalAttr() > 0 then
            self:openBPBuffMoreLayer()
        else
            self:openBPBuffLayer()
        end
        return
    end
    local layer = AlertManager:getLayerByName("lua.logic.peak.LunJianRank")
    if layer == nil then
        layer = AlertManager:addLayerByFile("lua.logic.peak.LunJianRank",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
        AlertManager:show()
        return
    end
    layer:refreshUI()
end

function PeakManager:onReceivePeakFall( event )
    hideLoading()
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_PEAK_FALL, {})
end

function PeakManager:onReceiveLastChampionMsg( event )
    hideLoading()
    local data = event.data
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_LAST_CHAMPION_MSG, data)
end 

function PeakManager:onReceiveFightEnd( event )
    hideLoading()
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_FIGHT_END, {})
end

function PeakManager:onReceiveActivitySate( event )
    hideLoading()
    if self.activityState ~= 2 then
        self.activityState = event.data.isOpen
    end
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_ACTIVITY_STATE, {})
end

function PeakManager:onReceiveFactionRank( event )
    hideLoading()
    local data = event.data
    if data.ranks == nil then
        data.ranks = {}
    end
    if self.factionStartRank == 1 then
        self.factionRank = {}
    end
    for i,v in ipairs(data.ranks) do
        self.factionRank[i - 1 + self.factionStartRank] = v
    end
    if data.myIntegra then
        self.factionMyIntegra = data.myIntegra
    end
    if data.myRank then
        self.factionMyRank = data.myRank
    end
    TFDirector:dispatchGlobalEventWith(PeakManager.RECEIVE_FACTION_RANK, {})
    if self.isOpenFactionRank == true then
        self.isOpenFactionRank = false
        local layer = AlertManager:addLayerByFile("lua.logic.peak.PeakFactionRankLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
        AlertManager:show()
    end
end
-->>>>>>>-------------------------------------------->>>>>>>>--

function PeakManager:openMainLayer()
    self.isOpenMainLayer = true
    self:requestPeakInfo(0,0)
end

function PeakManager:getUnitedInfoById(floorId)
    for k,v in pairs(self.unitedInfo) do
        if v.layer == floorId then
            return v
        end
    end
    return nil
end

function PeakManager:getFloorInfo()
    return self.floorInfo or {}
end

function PeakManager:getMyInfo()
    return self.curInfo or {}
end

function PeakManager:getGuildInfo()
    return self.guildInfo or {}
end

function PeakManager:getBattleLog()
    return self.battleLog or {}
end

function PeakManager:getRankInfo()
    return self.rankInfo or {}
end

function PeakManager:getMyRankInfo()
    return self.myRankInfo or {}
end

function PeakManager:getUnitedInfo()
    return self.unitedInfo or {}
end

function PeakManager:getFactionRank()
    return self.factionRank or {}
end

function PeakManager:getMyFactionIntegral()
    return self.factionMyIntegra or 0
end

function PeakManager:getMyFactionRank()
    return self.factionMyRank or 0
end

function PeakManager:getGuildAttri(rank)
    return PeakGuildAttribute:objectByID(rank)
end

function PeakManager:getGuildAttriLength()
    return PeakGuildAttribute:length()
end

function PeakManager:getMyIntegral()
    local timeBegan = self.curInfo.startTime
    local timeCounted = self.curInfo.settleTime
    local unitedTime = self.curInfo.unitedTime
    local floorId = self.curInfo.layer
    if timeCounted < timeBegan then
        timeCounted = 0
    end

    local nIntegral = 0
    local nIntegralCounted = 0
    local item = PeakData:objectByID(floorId)
    if item == nil then 
        return {0,0}
    end
    local maxTimeLen = ConstantData:objectByID("PeakTakeDownTime").value * 60
    local timeMax = timeBegan + maxTimeLen
    local timeNow = MainPlayer:getNowtime()
    if timeNow < timeMax then
        timeMax = timeNow
    end

    --------------nIntegralCounted
    if timeCounted == 0 then
        nIntegralCounted = 0
    else
        local countedIntegral = self:countIntegral(item.integral,timeBegan,timeCounted,item)
        nIntegralCounted = nIntegralCounted + countedIntegral
    end

    local countedUnited = self.curInfo.unitedTotalIntegral - self.curInfo.unitedIntegral
    if countedUnited < 0 then
        print("countedUnited is a minus ---->>> ",countedUnited)
        countedUnited = 0
    end
    nIntegralCounted = nIntegralCounted + countedUnited
    --------------nIntegral
    -- 众志成城部分累积积分
    nIntegral = nIntegral + self.curInfo.unitedTotalIntegral
    -- 阵眼时间积分
    local countedIntegral = self:countIntegral(item.integral,timeBegan,timeMax,item)
    nIntegral = nIntegral + countedIntegral
    -- 众志成城时间积分
    if unitedTime and unitedTime > 0 and unitedTime >= timeBegan then
        countedIntegral = self:countIntegral(item.united_integral,unitedTime,timeMax,item)
        nIntegral = nIntegral + countedIntegral
    end
    return {nIntegral,nIntegralCounted}
end

function PeakManager:countIntegral(integral,timeBegan,timeEnd,item)
    local integralCount = 0
    local time1 = timeBegan
    local timeLen = timeEnd - timeBegan
    local index = 0
    if timeLen < 60 then
        return 0
    end
    local tTime = GetCorrectDate("*t",time1)
    local min = tTime.hour*60 + tTime.min
    local tTime0 = GetCorrectDate("*t",timeEnd)
    local min0 = tTime0.hour*60 + tTime0.min

    while(index ~= 20 and ( min ~= min0 or tTime.yday ~= tTime0.yday )) do
        index = index + 1
        tTime = GetCorrectDate("*t",time1)
        min = tTime.hour*60 + tTime.min

        local timeData = self:getTimeDataByMin_Data(min,item)
        if timeData == nil then
            break
        end
        local curTimeLen = timeData.endTime - min
        -- 因为时段都是从0开始，不存在跨天时段
        if tTime.yday == tTime0.yday and min0 >= timeData.beginTime and min0 < timeData.endTime then
            curTimeLen = min0 - min
        end
        time1 = time1 + curTimeLen*60

        integralCount = integralCount + curTimeLen * integral * timeData.percent
    end
    return integralCount
end

function PeakManager:getTimeDataByTime( time,floorId )
    local item = PeakData:objectByID(floorId)
    if item == nil then 
        return nil
    end
    local data = item:getData()
    local tTime = GetCorrectDate("*t",time)
    local min = tTime.hour*60 + tTime.min
    for i,v in ipairs(data) do
        if min >= v.beginTime and min < v.endTime then
            return v
        end
    end
end

function PeakManager:getTimeDataByMin_Data( min,item )
    if item == nil then 
        return nil
    end
    local data = item:getData()
    for i,v in ipairs(data) do
        if min >= v.beginTime and min < v.endTime then
            return v
        end
    end
end

function PeakManager:getActivityStatus()
    if MainPlayer:getServerSwitchStatue(ServerSwitchType.Peak) == true then
        if self.activityState == 2 then
            return 1
        end
        return self.activityState
    end
    return 1
end

function PeakManager:openRewardLayer()
    local layer = AlertManager:addLayerByFile("lua.logic.peak.LunJianJiangli",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show()
end

function PeakManager:getRankReward(curRank)
    local rewardList = ChampionsAwardData:getAllRewardDataByType(7)
    for i = 1, #rewardList do
        local minRank = rewardList[i].min_rank
        local maxRank = rewardList[i].max_rank
        if curRank >= minRank and curRank <= maxRank then
            return rewardList[i]:getReward()
        end
    end
    return nil
end

function PeakManager:getScoreReward(curScore)
    local rewardList = ChampionsAwardData:getAllRewardDataByType(8)
    for i = 1, #rewardList do
        local minRank = rewardList[i].min_rank
        local maxRank = rewardList[i].max_rank
        if curScore >= minRank and curScore <= maxRank then
            return rewardList[i]:getReward()
        end
    end
    return nil
end

function PeakManager:getCurReward()
    if not self.myRankInfo then
        return nil
    end
    local curRank = self.myRankInfo.myRanking
    local curScore = self.myRankInfo.myIntegral

    local rankReward = self:getRankReward(curRank)
    if rankReward then
        return rankReward
    end
    local scoreReward = self:getScoreReward(curScore)
    if scoreReward then
        return scoreReward
    end
    return nil
end

function PeakManager:getBuffItemIds()
    local idTab = {}
    for v in PeakData:iterator() do
        if v.attribute > 0 then
            table.insert(idTab, v.id)
        end
    end
    table.sort(idTab, function(a, b)
        return a < b
    end)
    return idTab
end

function PeakManager:openBPBuffLayer()
    local layer = AlertManager:addLayerByFile("lua.logic.peak.LunJianBPBuff",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    AlertManager:show()   
end

function PeakManager:openBPBuffMoreLayer()
    local layer = AlertManager:addLayerByFile("lua.logic.peak.LunJianBPBuffMore",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    AlertManager:show()
end

function PeakManager:openBuffLayer()
    self.isOpenBuffLayer = true
    self:requestRankingInfo(1)
end

function PeakManager:openBuffLayer0(attri)
    local layer = AlertManager:addLayerByFile("lua.logic.peak.PeakBuffLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    layer:setNum(attri)
    AlertManager:show()   
end

function PeakManager:getBuffPlayerTab()
    local guildInfo = self:getGuildInfo() or {}   
    local tab = {}

    local function pushToTab(tempTab)
        local layer = tempTab.layer
        if not tab[layer] then
            tab[layer] = {}            
        end
        table.insert(tab[layer], tempTab)
    end
    if #guildInfo > 0 then
        for i, v in ipairs(guildInfo) do
            local floorData = PeakData:objectByID(v.layer)
            if floorData.attribute > 0 then                
                pushToTab(v)
            end
        end
    end
    return tab
end

function PeakManager:getTotalAttr()
    local guildInfo = self:getGuildInfo() or {}
    local attri = 0   
    if #guildInfo > 0 then        
        for i, v in ipairs(guildInfo) do
            local floorData = PeakData:objectByID(v.layer)
            attri = attri + floorData.attribute
        end
    end
    if attri >= 1500 then
        attri = 1500
    end
    return attri
end

function PeakManager:openVSlayer(data,floorId,pos)
    local layer = AlertManager:getLayerByName("lua.logic.peak.PeakVSLayer")
    if layer == nil then
        layer = AlertManager:addLayerByFile("lua.logic.peak.PeakVSLayer")
        layer:loadData(data,floorId,pos)
        AlertManager:show()
    else
        layer:loadData(data,floorId,pos)
        layer.firstShow = true
        layer:refreshUI()
    end
end

function PeakManager:openMyInfolayer()
    local layer = AlertManager:addLayerByFile("lua.logic.peak.PeakInfoLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    AlertManager:show()
end

function PeakManager:openZZCClayer(floorId)
    local layer = AlertManager:addLayerByFile("lua.logic.peak.PeakZZCCBuffLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    layer:setInfo(floorId)
    AlertManager:show()
end

function PeakManager:openSJBufflayer(floorId)
    local layer = AlertManager:addLayerByFile("lua.logic.peak.PeakSJBuffLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    layer:setInfo(floorId)
    AlertManager:show()
end

function PeakManager:openFactionRanklayer()
    self.isOpenFactionRank = true
    self:requestFactionRank(1)
end

function PeakManager:checkRedPoint()
    if self:getActivityStatus() == 1 then
        return false
    end
    local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2210)
    if teamLev < openLev then
        return false
    end
    if self.isInPoint == false then
        local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.PEAK)
        times = challengeInfo:getLeftChallengeTimes()
        if times > 0 then
            return true
        end
    end
    return false
end

function PeakManager:isPeakOpen()
    local function getPeakOpenTime(time)
        local c         = split(time, ":")
        local nextDate  = {hour=c[1], min=c[2], sec=c[3]}
        local date  = GetCorrectDate("*t", MainPlayer:getNowtime())

        date.hour = nextDate.hour
        date.min  = nextDate.min
        date.sec  = nextDate.sec
        local timeSec   = os.time(date) - getTimeAreaDifSec() -- time correct
        return timeSec
    end

    local nowTime = MainPlayer:getNowtime()

    local time1 = getPeakOpenTime(self.Peak_Open_StartTime)
    local time2 = getPeakOpenTime(self.Peak_Open_EndTime)
    print("time1    = ", time1)
    print("time2    = ", time2)
    print("nowTime  = ", nowTime)
    if nowTime >= time1 and nowTime <= time2 then
        return true
    end

    return false
end
return PeakManager:new()