-- client side JapanIslandManager.lua
--[[
 * @Description: 勇闯东瀛岛

 ]]
-- script writer wuqi
-- creation time 2016-12-09

local JapanIslandManager = class("JapanIslandManager")

JapanIslandManager.MY_TEAM_REPONSE = "JapanIslandManager.MY_TEAM_REPONSE"
JapanIslandManager.LOTTERY_RESPONSE = "JapanIslandManager.LOTTERY_RESPONSE"
JapanIslandManager.UpdateNewChatMsg = "JapanIslandManager.UpdateNewChatMsg"
JapanIslandManager.UpdateInvitationMsg = "JapanIslandManager.UpdateInvitationMsg"
JapanIslandManager.TEAM_DATA_REPONSE = "JapanIslandManager.TEAM_DATA_REPONSE"
JapanIslandManager.UpdateTeamInfoMsg = "JapanIslandManager.UpdateTeamInfoMsg"
JapanIslandManager.CHAPTER_STATUS_DATA_RESPONSE = "JapanIslandManager.CHAPTER_STATUS_DATA_RESPONSE"
JapanIslandManager.REFRESH_LAST_TIME = "JapanIslandManager.REFRESH_LAST_TIME"
JapanIslandManager.RESPONSE_TEAMMATE_HP = "JapanIslandManager.RESPONSE_TEAMMATE_HP"
JapanIslandManager.TEAM_DISSOLVE = "JapanIslandManager.TEAM_DISSOLVE"

JapanIslandManager.EnumTeamStatus = 
{
    PREPARE = 0,    --筹备状态
    FIGHTING = 1,   --战斗状态
    FIGHTEND = 2,   --战斗结束(抽奖)
    NONE = 3        --无队伍
}

JapanIslandManager.EnumCopyStatus = 
{
    NOT_CHALLENGE = 1,  --未挑战
    CHALLENGING = 2,    --挑战中
    TRUSTING = 3,       --托管中
    PASSED = 4          --已通关
}

JapanIslandManager.VIP_CODE = 9001
JapanIslandManager.MAX_SEC = 9

JapanIslandManager.IS_TEST = true

function JapanIslandManager:ctor(data)
    self.teamRedState = false
    
    TFDirector:addProto(s2c.PASS_CHAPTER_RESPONSE, self, self.onGetPassInfo)
    TFDirector:addProto(s2c.TEAM_DATA_REPONSE, self, self.onAllTeamDataResponse)
    TFDirector:addProto(s2c.MY_TEAM_REPONSE, self, self.onMyTeamDataResponse)
    TFDirector:addProto(s2c.CHAPTER_STATUS_DATA_RESPONSE, self, self.onChapterStatusResponse)
    TFDirector:addProto(s2c.LOTTERY_RESPONSE, self, self.onLotteryResponse)
    TFDirector:addProto(s2c.COPY_TEAM_CHAT_RESPONSE, self, self.onContestTeamChatMsg)
    --被邀请的私聊消息  
    TFDirector:addProto(s2c.COPY_TEAM_INVITATION_INFO_RESPONSE, self, self.onGetInvitationMsg)
    -- 队友信息
    TFDirector:addProto(s2c.RESPONSE_TEAMMATE_HP, self, self.onGetTeammateMsg)
    ErrorCodeManager:addProtocolListener(s2c.TEAM_DATA_REPONSE,  function(target,event)
        if event.errorCode == 22818 then
            TFDirector:dispatchGlobalEventWith(JapanIslandManager.TEAM_DISSOLVE, {})
            return true
        end
    end)
    self.teamChatList       = TFArray:new()
    self.invitationHistory  = TFArray:new()
    self.isShowBox = true
    self:restart()

    self.enemyList = {}
end

function JapanIslandManager:restart()
    self.allTeamData    = {}
    self.myTeamData     = nil
    self.passedChap     = 0
    self.teamChatList:clear()
    self.teamRedState   = false
    self.invitationHistory:clear()

    self.achievementAttribute   = nil
    self.achievementList        = {}  
    self.isFirstLoaded          = false
    self.isEnterTeam            = false
    self.isEnterFightMain       = false

    self.maxChapter     = JapanTeamChapterData:back().chapter_id or 0
    self.teamStatus     = self.EnumTeamStatus.NONE
    self.showChatRed    = false
    self.isShowBox      = true
end

function JapanIslandManager:getTeamChatList()
    return self.teamChatList
end

function JapanIslandManager:checkNeedShowSkip()
    return self.showSkipInFight
end

function JapanIslandManager:setNeedShowSkip(flag)
    self.showSkipInFight = flag
end

function JapanIslandManager:getAcheivAttri()
    if self.achievementAttribute == nil then
        self.achievementAttribute = {}
        
        local achievId = 0
        for item in JapanTeamChapterData:iterator() do
            if self.passedChap and self.passedChap >= item.chapter_id then
                if achievId < item.chapter_id then
                    achievId = item.chapter_id
                end
                if self.achievementList[achievId] == nil then
                    self.achievementList[achievId] = true
                end
            end
        end
        if achievId > 0 then
            self.achievementAttribute = JapanTeamChapterData:getAttributeByid(achievId)
        end
    end
    return self.achievementAttribute or {}
end

function JapanIslandManager:clearAchieveRed()
    for k,v in pairs(self.achievementList) do
        self.achievementList[k] = false
    end
end


-- 请求队伍信息(0代表查看所有队伍, index:章id)
function JapanIslandManager:requestTeamData(index)
    print("requestdata ===>> ", index)
    showLoading()
    TFDirector:send(c2s.TEAM_DATA_REQUEST, {index})
end

-- 创建新队伍
function JapanIslandManager:requestCreateTeam(chapter, minLevel, maxLevel, show)
    showLoading()
    local Msg = {
        chapter, 
        minLevel, 
        maxLevel, 
        show
    }
    if self.IS_TEST then
        print("JapanIslandManager:requestCreateTeam ===>>> ", Msg)
    end
    TFDirector:send(c2s.CREATE_TEAM_REQUEST, Msg)
end

-- 队伍操作
function JapanIslandManager:requestOperateTeam(tType, teamId, playerId, isSkip, isAssist)
    if not isSkip then
        showLoading()
    end
    teamId = teamId or 0
    if (isAssist == nil and self:isAssistPlayer(playerId)) then
        isAssist = 1
    end
    isAssist = isAssist or 0
    local Msg = {
        tType, 
        teamId, 
        playerId,
        isAssist
    }
    print("mmmsssggg ==>> ", Msg)
    TFDirector:send(c2s.OPERATING_TEAM_REQUEST, Msg)
end

-- 队伍聊天
function JapanIslandManager:requestTeamChat(str)
    showLoading()
    local Msg = {
        str
    }
    TFDirector:send(c2s.TEAM_CHAT_REQUEST, Msg)
end

-- 开始战斗
function JapanIslandManager:requestStartBattle(copyId)
    showLoading()
    local Msg = {
        copyId
    }
    local tb = TFLuaTime:clock()
    self.lastReqTime = self.lastReqTime or 0
    if (math.abs(self.lastReqTime - tb) < 1.5) then
        toastMessage(localizable.JapanIsland_Fight)
        return
    end
    self.challengingChapId = self:getChallengingChapId()
    self.challengingCopyId = copyId
    print("requestStartBattle ==>> ", Msg)
    TFDirector:send(c2s.START_BATTLE_REQUEST, Msg)
    self.lastReqTime = tb
end

-- 托管
function JapanIslandManager:requestHosting(tType)
    --showLoading()
    print("[wklog]==>> hosting")
    local Msg = {
        tType
    }
    TFDirector:send(c2s.HOSTING_REQUEST, Msg)
end

-- 抽奖
function JapanIslandManager:requestLottery(tType)
    showLoading()
    TFDirector:send(c2s.LOTTERY_REQUEST, {tType})
end

-- 请求队友信息
function JapanIslandManager:requestTeammateInfo(playerId)
    showLoading()
    TFDirector:send(c2s.QUERY_TEAMMATE_HP, {playerId})
end

-- 购买
function JapanIslandManager:requestByAllItem()
    showLoading()
    TFDirector:send(c2s.BUY_REMANENT_REWARD, {})
end

-- 已经通关的最新章,登陆推,更新时推
function JapanIslandManager:onGetPassInfo(event)
    local data = event.data or {}
    self.passedChap = data.chapterId or 0
    self.achievementAttribute = nil
    if self.isFirstLoaded ~= true then
        self:getAcheivAttri()
        self.isFirstLoaded = true
    else
        self.isFirstLoaded = false
    end
end

function JapanIslandManager:getPassedChapId()
    --self.passedChap = 2
    return self.passedChap or 0
end

function JapanIslandManager:canJoin(info)
    if self.passedChap + 1 >= info.chapterId and MainPlayer:getLevel() >= info.minLevel and MainPlayer:getLevel() <= info.maxLevel then
        return true
    else
        return false
    end
end

-- query所选章队伍信息
function JapanIslandManager:onAllTeamDataResponse(event)
    hideLoading()
    local data = event.data or {}
    self.allTeamData = {}
    local teamInfo = data.teamInfo or {}

    -- 排序方式:可加入的队伍前置,不可加入的后置,然后各自按创建时间排序
    local function sortFunc(v1, v2)
        if self:canJoin(v1) then
            if self:canJoin(v2) then
                return v1.createTime > v2.createTime
            else
                return true
            end
        else
            if self:canJoin(v2) then
                return false
            else
                return v1.createTime > v2.createTime
            end
        end
    end
    table.sort(teamInfo, sortFunc)
    self.allTeamData = teamInfo
    TFDirector:dispatchGlobalEventWith(self.TEAM_DATA_REPONSE, {})
end

-- 我的队伍信息
function JapanIslandManager:onMyTeamDataResponse(event)
    if self.IS_TEST then
        print("JapanIslandManager:onMyTeamDataResponse ===>> ", event.data)
    end
    hideLoading()
    local isArray       = self:isAssistPlayer(MainPlayer:getPlayerId())
    local data          = event.data or {}
    local teamInfo      = data.teamInfo
    self.teamStatus     = data.status
    local quitMemName   = data.quitMemName
    if quitMemName and quitMemName ~= "" then
        if (self.teamStatus == 4) then
            toastMessage( stringUtils.format( localizable.JapanIsland_txt_mem_quit1, quitMemName ) )
        else
            toastMessage( stringUtils.format( localizable.JapanIsland_txt_mem_quit, quitMemName ) )
        end
    end
    local chapId = self:getChallengingChapId() or 1
   
    self.myTeamData = teamInfo or {}
    self.myTeamData.passCopy = self.myTeamData.passCopy or {}

    local temp = VipData:getVipItemByTypeAndVip(self.VIP_CODE, MainPlayer:getVipLevel()) or {}
    self.defaultLotTimes = temp.benefit_value or 2   

    if self.lastStatus and self.lastStatus == 2 and self.teamStatus < 2 then
        return
    end
    if self.teamStatus == 2 then
        print("self:getChallengingChapId() ===>> ", chapId)

        self.lastStatus = self.teamStatus

        TFDirector:dispatchGlobalEventWith(self.REFRESH_LAST_TIME, {})
        if (isArray ~= true) then
            self:showBoxLayer( chapId )
        end
        return
    elseif self.teamStatus == 0 then
        self.isShowBox = true
    end
    self.lastStatus = self.teamStatus
    local layer = AlertManager:getLayerByName("lua.logic.japanIsland.IslandMyTeamLayer")
    if self.teamStatus == 0 and (not layer) and (not self.isEnterTeam) then
        layer = require("lua.logic.japanIsland.IslandMyTeamLayer"):new()
        AlertManager:addLayer(layer)
        AlertManager:show()
    else
        TFDirector:dispatchGlobalEventWith(self.MY_TEAM_REPONSE, {})
    end
end

function JapanIslandManager:getMyTeamData()
    return self.myTeamData
end

function JapanIslandManager:getMyTeamId()
    if self.myTeamData then
        return self.myTeamData.teamId
    end
    return nil
end

function JapanIslandManager:getTeamMemInfo()
    if self.myTeamData then
        return self.myTeamData.member
    end
    return nil
end

--队伍是否正常，队长不能为助战。
function JapanIslandManager:isTeamLegal()
    local teamInfo = self:getTeamInfo()
    if (teamInfo and teamInfo.member) then
        for i,v in ipairs(teamInfo.member) do
            if (v.isAssist ~= 1 and teamInfo.leader == v.playerId) then
                return true
            end
        end
    end
    return false
end

function JapanIslandManager:getChallengingChapId()
    if self.myTeamData then
        return self.myTeamData.chapterId
    end
    return nil
end

function JapanIslandManager:getSectionInfoByChapId(chapId)
    return JapanTeamCopyData:GetInfoByZoneId(chapId)
end

function JapanIslandManager:getPassedSecList(chapId, isSelf)
    local secList = {}
    local nameList = {}
    local secData = self:getSectionInfoByChapId(chapId) or {}
    -- local teamData = self:getTeamMemInfo() or {}
    local teamData = self:getMyTeamData()
    if not isSelf then
        teamData.passCopy = teamData.passCopy or {}
        for i, j in pairs(teamData.passCopy) do
            secList[j] = secList[j] or true
            nameList[j] = teamData.name
        end
    else
        teamData = self:getTeamMemInfo() or {}
        for k, v in pairs(teamData) do
            if v.playerId == MainPlayer:getPlayerId() then
                v.passCopy = v.passCopy or {}
                for i, j in pairs(v.passCopy) do
                    secList[j] = secList[j] or true
                    nameList[j] = v.name
                end
            end
        end
    end

    -- for k, v in pairs(teamData) do
    --     if v.passCopy then
    --         if not isSelf then
    --             for i, j in pairs(v.passCopy) do
    --                 secList[j] = secList[j] or true
    --             end
    --         else
    --             if v.playerId == MainPlayer:getPlayerId() then
    --                 for i, j in pairs(v.passCopy) do
    --                     secList[j] = secList[j] or true
    --                 end
    --             end
    --         end
    --     end
    -- end
    return secList, nameList
end

function JapanIslandManager:getSecStatus(chapId, copyId)
    local status = self.EnumCopyStatus.NOT_CHALLENGE
    local passList, nameList = self:getPassedSecList(chapId)
    if passList[copyId] then
        return self.EnumCopyStatus.PASSED, nameList[copyId]
    end
    local memInfo = self:getTeamMemInfo()
    for k, v in pairs(memInfo) do
        if v.hosting == 1 and v.battleCopyId == copyId then
            return self.EnumCopyStatus.TRUSTING, v.name
        elseif v.hosting == 0 and v.battleCopyId == copyId then
            return self.EnumCopyStatus.CHALLENGING, v.name
        end
    end
    return status
end

function JapanIslandManager:getMyPassSecList()
    local nowChap = self:getChallengingChapId()
    local myPassList = {}
    local list = self:getPassedSecList(nowChap, true)
    local secData = self:getSectionInfoByChapId(nowChap)
    for k, v in pairs(secData) do
        if list[v.copy_id] then
            table.insert(myPassList, v.copy_id)
        end
    end
    return myPassList
end

function JapanIslandManager:getMyAttrLess()
    local nowChap = self:getChallengingChapId()
    local myPassList = self:getMyPassSecList()
    local count = 0

    local secInfo = JapanTeamCopyData:GetInfoByZoneId(nowChap)
    local function getCount(sec)
        local cc = 0
        for _, v in pairs(secInfo) do
            if v.copy_id == sec then
                local lessCount = v.attribute_less or 0
                lessCount = lessCount / 100
                return lessCount
            end
        end
        return cc
    end

    for k, v in pairs(myPassList) do
        count = count + getCount(v)
    end
    return count
end

function JapanIslandManager:onChapterStatusResponse(event)
    hideLoading()

    --print("JapanIslandManager:onChapterStatusResponse ==>> ", event.data)
    local data = event.data or {}
    self.enemyList = {}
    self.enemyList[data.chapterId] = {}
    self.enemyList[data.chapterId].copy = data.copy or {}
    self.enemyList[data.chapterId].data = data.data or {}

    TFDirector:dispatchGlobalEventWith(self.CHAPTER_STATUS_DATA_RESPONSE, {  })
end

function JapanIslandManager:onLotteryResponse(event)
    hideLoading()

    print("JapanIslandManager:onLotteryResponse(event) ==>> ", event.data)
    local data      = event.data
    local obtain    = data.obtain
    local show      = data.show or nil
    -- self.showAwardList = show
    TFDirector:dispatchGlobalEventWith(self.LOTTERY_RESPONSE, { obtain , show})
end

function JapanIslandManager:checkIsInTeam()
    if self.myTeamData and self.myTeamData.member and #self.myTeamData.member > 0 then
        return true
    end
    return false
end

-- 队伍聊天信息 服务器推送
function JapanIslandManager:onContestTeamChatMsg(event)
    hideLoading()
    local chat = event.data.chat or {}
    local newChat = nil
    for k,v in pairs(chat) do
        --跟聊天信息统一
        v.chatType          = EnumChatType.Team
        v.content           = v.content
        v.roleId            = v.useIcon
        v.competence        = 0
        v.invitationGuilds  = 0
        v.icon              = v.useIcon
        v.quality           = 0
        v.timestamp         = v.chatTime
        v.headPicFrame      = v.frameId
        v.isAssist          = v.isAssist or 0
        local teamInfo = self:getMyTeamByPlayerID(v.playerId)
        v.serverId = 0
        if (teamInfo) then
            v.serverId = teamInfo.serverId
        end
        newChat = v
        self.teamChatList:pushBack(v)
    end
    if newChat.playerId ~= MainPlayer:getPlayerId() and self:checkIsInTeam() then
        self.teamRedState = true
    end       

    TFDirector:dispatchGlobalEventWith(JapanIslandManager.UpdateNewChatMsg, {})
end

function JapanIslandManager:getTeamChatMsg()
    --获取队伍聊天信息列表
    return self.teamChatList
end

--Remark: 队伍邀请
function JapanIslandManager:onGetInvitationMsg( event )
    --获取邀请信息记录 将其显示到队伍聊天 服务器推送
    hideLoading()
    local infos = event.data.infos or {}
    print("infos = ",infos)
    for k,v in pairs(infos) do
        --跟聊天信息统一
        v.chatType          = EnumChatType.Team
        v.content           = ""
        v.roleId            = v.icon
        v.vipLevel          = v.vip
        v.timestamp         = v.createTime
        v.showType          = v.type
        v.serverId          = v.serverId
        v.isAssist          = v.isAssist or 0
        v.invitationGuilds  = {}
        self.invitationHistory:pushBack(v)
    end
    if self:checkIsInTeam() == false then
        self.teamRedState = true

        local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.JAPAN_ISLAND)
        local times = challengeInfo:getLeftChallengeTimes() or 0
        if times > 0 then
            self.showChatRed = true
        else
            self.showChatRed = false
        end
        TFDirector:dispatchGlobalEventWith(JapanIslandManager.UpdateInvitationMsg, {})
    end
end

-- 队友信息
function JapanIslandManager:onGetTeammateMsg( event )
    hideLoading()

    local data = event.data or {}
    print("JapanIslandManager:onGetTeammateMsg( event ) ==>> ", data)
    -- TFDirector:dispatchGlobalEventWith(self.RESPONSE_TEAMMATE_HP, { data })
    self:openTeammateInfoLayer(data)
end

--Remark: 队伍聊天
-- function JapanIslandManager:onContestTeamChatMsg(event)
--     --队伍聊天信息 服务器推送
--     --self.invitationHistory:clear()
--     hideLoading()
--     local chat = event.data.chat or {}
--     local newChat = nil
--     for k,v in pairs(chat) do
--         --跟聊天信息统一
--         v.chatType          = EnumChatType.Team
--         v.content           = v.content
--         v.roleId            = v.useIcon
--         v.competence        = 0
--         v.invitationGuilds  = 0
--         v.icon              = v.useIcon
--         v.quality           = 0
--         v.timestamp         = v.chatTime
--         v.headPicFrame      = v.frameId
--         newChat = v
--         self.teamChatList:pushBack(v)
--     end
--     if newChat.playerId ~= MainPlayer:getPlayerId() and self:checkIsInTeam() then
--         self.teamRedState = true
--     end       

--     TFDirector:dispatchGlobalEventWith(JapanIslandManager.UpdateNewChatMsg, {})
-- end

function JapanIslandManager:deleteInvitationMsg(teamId)
    --根据teamId删除邀请相应的组队记录
    for v in self.invitationHistory:iterator() do
        if v.teamId == teamId then
            self.invitationHistory:removeObject(v)
            break
        end
    end
end

function JapanIslandManager:openRuleLayer()
    CommonManager:showRuleLyaer("yongchuangdongyingdao")
end

function JapanIslandManager:openCreateTeamLayer(selectChap)
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.japanIsland.IslandTeam", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1)
    layer:loadData(selectChap)
    AlertManager:show()
end

function JapanIslandManager:openMainIslandLayer()
    local layer = AlertManager:getLayerByName("lua.logic.japanIsland.IslandMain")
    if not layer then
        layer = require("lua.logic.japanIsland.IslandMain"):new()
        AlertManager:addLayer(layer, nil, AlertManager.TWEEN_NONE) 
        AlertManager:show()
        return
    end
end

function JapanIslandManager:getDropItemListByChapInfo(Info)
    return DropGroupData:GetDropItemListByIdsStr(Info.drops)
end

function JapanIslandManager:openCreateEditLayer()
    local layer = AlertManager:getLayerByName("lua.logic.japanIsland.IslandCreateTeam")
    if not layer then
        layer = require("lua.logic.japanIsland.IslandCreateTeam"):new()
        AlertManager:addLayer(layer, nil, AlertManager.TWEEN_1)
        AlertManager:show()
        return
    end
end

--队伍聊天红点
function JapanIslandManager:getTeamChatRedState()
    return self.teamRedState
end

function JapanIslandManager:setTeamChatRedState(isRed)
    self.teamRedState = isRed
end

function JapanIslandManager:openChatLayer()
    if self:checkIsInTeam() then
        local layer = require("lua.logic.chat.ChatMainLayer"):new()
        layer:changeGroupChoice( 5 )
        AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
        AlertManager:show()    
    else
        toastMessage(localizable.JapanIsland_no_team_join)
    end
end

function JapanIslandManager:getTeamInfo()
    return self.myTeamData
end

function JapanIslandManager:getTeamStatus()
    return self.teamStatus
end

function JapanIslandManager:openInvitationLayer()
    AlertManager:addLayerByFile("lua.logic.japanIsland.IslandFriendTeam",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
    AlertManager:show();
end

function JapanIslandManager:isAssistPlayer(playerId)
    local teamInfo = self:getTeamMemInfo()
    if (teamInfo) then
        for i,v in ipairs(teamInfo) do
            if (v.isAssist == 1 and playerId == v.playerId) then
                return true
            end
        end
    end
    return false
end
function JapanIslandManager:showBoxLayer(chap)
    if (self.isShowBox ~= true) then
        return
    end
    chap = chap or 1
    local info = JapanTeamChapterData:objectByID(chap)
    local data = self:getDropItemListByChapInfo(info)
    local layer = AlertManager:addLayerByFile("lua.logic.japanIsland.IslandPrize", AlertManager.BLOCK_AND_GRAY)
    layer:loadBoxData(chap, data);
    AlertManager:show();
    self.isShowBox = false
end

function JapanIslandManager:openAchievementLayer()
    AlertManager:addLayerByFile("lua.logic.japanIsland.IslandAchieveLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1);
    AlertManager:show();
end

function JapanIslandManager:openFightMainLayer()
    -- local layer = AlertManager:getLayerByName("lua.logic.japanIsland.IslandFightMain")
    -- if not layer then
    --     layer = require("lua.logic.japanIsland.IslandFightMain"):new()
    --     AlertManager:addLayer(layer)
    --     AlertManager:show()
    --     return
    -- end
    AlertManager:addLayerByFile("lua.logic.japanIsland.IslandFightMain", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_NONE);
    AlertManager:show();
end

function JapanIslandManager:openVSLayer(data)
    local layer = AlertManager:addLayerByFile("lua.logic.japanIsland.IslandVSLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_NONE);
    layer:loadData(data)
    print("JapanIslandManager:openVSLayer(data) ==>> ", data)
    AlertManager:show();
end

function JapanIslandManager:checkIsInMyTeamByPlayerID(playerId)
    if self.myTeamData then
        local member = self.myTeamData.member or {}
        for k,v in pairs(member) do
            if v.playerId == playerId then
                return true
            end
        end
    end
    return false
end
function JapanIslandManager:getMyTeamByPlayerID(playerId)
    if self.myTeamData then
        local member = self.myTeamData.member or {}
        for k,v in pairs(member) do
            if v.playerId == playerId then
                return v
            end
        end
    end
    return nil
end
function JapanIslandManager:checkIsInMyTeamByServerID(playerId)
    if self.myTeamData then
        local member = self.myTeamData.member or {}
        local myServerId = 0
        local teamServerId = 0
        for k,v in pairs(member) do
            if v.playerId == playerId then
                teamServerId = v.serverId
            elseif v.playerId == MainPlayer:getPlayerId() then
                myServerId = v.serverId
            end
        end
        if (teamServerId ~= 0 and (teamServerId == myServerId)) then
            return true
        end
    end
    return false
end

function JapanIslandManager:checkNeedViewTeamBtn()
    if self:checkIsInTeam() then
        return true
    end
    local list = self:getRefuseSuccessMsg()
    if list:length() >= 1 then
        return true
    end
    return false
end

function JapanIslandManager:getRefuseSuccessMsg()
    --获取邀请信息列表
    return self.invitationHistory
end
function JapanIslandManager:getTeamChatMsg()
    --获取队伍聊天信息列表
    return self.teamChatList
end

function JapanIslandManager:getWarSideData(sec)
    local curChap = self:getChallengingChapId() or 1
    local secInfo = JapanTeamCopyData:GetInfoByZoneId(curChap)
    local item = nil
    for _, v in pairs(secInfo) do
        if v.copy_id == sec then
            item = v
            break
        end
    end

    return item
end

function JapanIslandManager:openMyTeamShowLayer()
    local layer = AlertManager:addLayerByFile("lua.logic.japanIsland.IslandMyTeamShowLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1);
    AlertManager:show();
end

function JapanIslandManager:openArmyLayer(data)
    local layer =  AlertManager:addLayerToQueueAndCacheByFile("lua.logic.japanIsland.IslandArmyLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    layer:setCanOpenInfo(false)
    layer:loadData(data)
    AlertManager:show()

    -- CardRoleManager:UpdateRoleFate()
end

function JapanIslandManager:openTeammateInfoLayer(userData, data)
    local layer = AlertManager:addLayerByFile("lua.logic.japanIsland.IslandInfoLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1);
    layer:loadData(userData, data)
    AlertManager:show();
end

function JapanIslandManager:getMapId()
    local challengeId = self:getChallengingChapId() or 1
    local item = JapanTeamChapterData:objectByID(challengeId) or {}

    return item.map_img or 22 
end

function JapanIslandManager:showTip(isBegin, isWin, fightType)
    -- type         = 1 战前tip
    -- type         = 2 战后tip
    -- fightType    = 30
    local nType = 1
    if not isBegin then
        if isWin then
            nType = 2
        else
            return
        end
    end

    local challengingCopyId = self.challengingCopyId or 0
    local tipList = MissionManager:getTipListByMissionId(challengingCopyId, nType);
    if tipList:length() <= 0 then
        return
    end
    local tipData = {};
    tipData.tiplist      = tipList; 
    tipData.stageType    = nType;
    local tipLayer = require("lua.logic.mission.MissionTipLayer"):new(tipData);
    local currentScene = Public:currentScene();
    currentScene:addLayer(tipLayer);
end

function JapanIslandManager:isHaveTip(isBegin)
    local challengingCopyId = self.challengingCopyId or 0
    local nType = 1
    if not isBegin then
        nType = 2
    end
    local tipList = MissionManager:getTipListByMissionId(challengingCopyId, nType);
    if tipList:length() <= 0 then
        return false
    end
    return true
end

function JapanIslandManager:needShowChatRed()
    return self.showChatRed
end

function JapanIslandManager:setChatRedState(bShow)
    self.showChatRed = bShow
end

function JapanIslandManager:setIslandRedPoint(widget, isShow, offset)
    if not widget then
        return
    end
    local pp = widget:getChildByName("KnightRedPoint")
    if pp and pp:isVisible() then
        return
    end
    local redPoint = widget:getChildByName("IslandRedPoint")
    if redPoint then
        if (isShow) then
            redPoint:setVisible(true)
        else
            redPoint:setVisible(false)
        end
    elseif (isShow) then
        redPoint = TFImage:create("ui_new/home/img_huangdian.png")
        redPoint:setName("IslandRedPoint")
        local widgetSize    = widget:getSize()
        local pointSize     = redPoint:getSize()
        offset = offset or ccp(0,0)
        local pos = ccp(-pointSize.width + offset.x, -pointSize.height + offset.y)
        redPoint:setAnchorPoint(ccp(0, 0))
        redPoint:setPosition(pos)
        widget:addChild(redPoint,100)
    end
end

function JapanIslandManager:isLeader()
    local selfId = MainPlayer:getPlayerId()
    local myTeam = self:getTeamInfo() or {}
    -- print("playerId ==>> ", playerId)
    -- print("myTeam ==>> ", myTeam)

    if myTeam.leader and myTeam.leader == selfId then
        return true
    else
        return false
    end
end

return JapanIslandManager:new()