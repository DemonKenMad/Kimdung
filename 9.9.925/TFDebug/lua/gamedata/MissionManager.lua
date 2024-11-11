--[[
******PVE推图管理类*******

	-- by haidong.gan
	-- 2013/11/15
]]


local MissionManager = class("MissionManager")

MissionManager.STATUS_PASS  = 1;--已通过
MissionManager.STATUS_CUR   = 2;--当前
MissionManager.STATUS_CLOSE = 3;--未开放
MissionManager.STATUS_NEED_DIFFICULTY0  = 4;--先通过普通关卡

MissionManager.TYPE_COMMON       = 1;--普通关卡
MissionManager.TYPE_SMALL_BOSS   = 2;--小boss
MissionManager.TYPE_BIG_BOSS     = 3;--大boss

MissionManager.DIFFICULTY0 = 1;--初级
MissionManager.DIFFICULTY1 = 2;--中级
MissionManager.DIFFICULTY2 = 3;--高级
MissionManager.DIFFICULTY3 = 4;--奇遇关卡普通
MissionManager.DIFFICULTY4 = 5;--奇遇关卡困难

-- MissionManager.DIFFICULTY_STR = {[MissionManager.DIFFICULTY0] = "普通",[MissionManager.DIFFICULTY1] = "宗师",[MissionManager.DIFFICULTY2] = "宗师",};
MissionManager.DIFFICULTY_STR = {[MissionManager.DIFFICULTY0] = localizable.MissionManager_mission_typy1,[MissionManager.DIFFICULTY1] = localizable.MissionManager_mission_typy2,[MissionManager.DIFFICULTY2] = localizable.MissionManager_mission_typy2,};


MissionManager.STARLEVEL0 = 0;--0星
MissionManager.STARLEVEL1 = 1;--1星
MissionManager.STARLEVEL2 = 2;--2星
MissionManager.STARLEVEL3 = 3;--3星
MissionManager.STARLEVEL4 = 4;--4星
MissionManager.STARLEVEL5 = 5;--5星

MissionManager.TIPLEFT   = 1;--左
MissionManager.TIPRIGTH  = 2;--右

MissionManager.EVENT_UPDATE_MISSION = "MissionManager.EVENT_UPDATE_MISSION";
MissionManager.EVENT_UPDATE_BOX     = "MissionManager.EVENT_UPDATE_BOX";
MissionManager.RESET_CHALLENGE_COUNT_RESULT     = "MissionManager.RESET_CHALLENGE_COUNT_RESULT";

MissionManager.QUICK_PASS_RESULT = "MissionManager.QUICK_PASS_RESULT"


--一键托管
MissionManager.trustOnkeyLayerName = "lua.logic.mission.TrusteeshipLayer"

function MissionManager:ctor()
    TFDirector:addProto(s2c.MISSION_LIST, self, self.onReceiveMissionList)
    TFDirector:addProto(s2c.UPDATE_MISSION, self, self.onReceiveUpMission)

    TFDirector:addProto(s2c.CHAPTER_BOX_OPEN, self, self.onReceiveOpenBox)

    TFDirector:addProto(s2c.RESET_CHALLENGE_COUNT_RESULT, self, self.onReceiveResetChallengeCountResult)
    TFDirector:addProto(s2c.QUICK_PASS_RESULT, self, self.onReceiveQuickPassResult)
    TFDirector:addProto(s2c.UNLOCK_FUNCTION, self, self.onSetOpenSystem)
    TFDirector:addProto(s2c.UNLOCK_ALL_FUNCTION, self, self.onSetOpenSystemList)


    -- self.MissionDataReset = function(event)
    --     self:resetMissionData()
    -- end
    -- TFDirector:addMEGlobalListener(MainPlayer.GAME_RESET, self.MissionDataReset)
    -- --测试代码 begin
    -- local event = require("testdata.Mission_s2c")
    -- self:onGetMissionListHandle(event);
    -- --测试代码 end

    self.mapList         = require("lua.table.t_s_stage_mapinfo");
    self.missionList     = require("lua.table.t_s_stage_data");
    self.missionTipList  = require("lua.table.t_s_stage_dial");
    self.mapBoxList      = require("lua.table.t_s_stage_box");
    self.missionPosList  = require("lua.table.t_s_stage_pos");

    self:initMapList()
    self:initMissionList()
    self:initSpecialDropMissionList()
    self.openSystemList = {}
    -- MoiveScriptData  = require("lua.table.t_s_stage_moive");
end

function MissionManager:initSpecialDropMissionList()
    if self.normalSpecialDropMissionList == nil then
        self.normalSpecialDropMissionList = MEMapArray:new()
    end
    self.normalSpecialDropMissionList:clear()

    if self.normalSpecialDropStar2MissionList == nil then
        self.normalSpecialDropStar2MissionList = MEMapArray:new()
    end
    self.normalSpecialDropStar2MissionList:clear()

    if self.normalSpecialDropStar3MissionList == nil then
        self.normalSpecialDropStar3MissionList = MEMapArray:new()
    end
    self.normalSpecialDropStar3MissionList:clear()

    if self.difficultySpecialDropMissionList == nil then
        self.difficultySpecialDropMissionList = MEMapArray:new()
    end
    self.difficultySpecialDropMissionList:clear()

    if self.difficultySpecialDropStar2MissionList == nil then
        self.difficultySpecialDropStar2MissionList = MEMapArray:new()
    end
    self.difficultySpecialDropStar2MissionList:clear()

    if self.difficultySpecialDropStar3MissionList == nil then
        self.difficultySpecialDropStar3MissionList = MEMapArray:new()
    end
    self.difficultySpecialDropStar3MissionList:clear()

    for mission in self.missionList:iterator() do
        local specialDrop = string.split(mission.special_drop,'_');
        local specialDropStar = string.split(mission.special_drop_star,'_');
        if specialDrop[1] ~= "" then
            if  mission.difficulty == 1 then 
                self.normalSpecialDropMissionList:push(mission)
                if specialDropStar[1] ~= "" then 
                    if tonumber(specialDropStar[1]) == 2 then
                        self.normalSpecialDropStar2MissionList:push(mission);
                    elseif tonumber(specialDropStar[1]) == 3 then
                        self.normalSpecialDropStar3MissionList:push(mission);
                    end
                end
            else 
                self.difficultySpecialDropMissionList:push(mission);
                if specialDropStar[1] ~= "" then 
                    if tonumber(specialDropStar[1]) == 2 then
                        self.difficultySpecialDropStar2MissionList:push(mission);
                    elseif tonumber(specialDropStar[1]) == 3 then
                        self.difficultySpecialDropStar3MissionList:push(mission);
                    end
                end
            end
        end 
    end
end

function MissionManager:getSpecialDropMissionList(difficulty)
    difficulty = difficulty or MissionManager.DIFFICULTY0;
    if difficulty == MissionManager.DIFFICULTY0 then
        return self.normalSpecialDropMissionList;
    else
        return self.difficultySpecialDropMissionList;
    end
end

function MissionManager:getSpecialDropMissionListBool(difficulty,missionId)
    local difficulty = difficulty or MissionManager.DIFFICULTY0;
    for i = 3,1,-1 do
        local starList = self:getSpecialDropStarMissionList(difficulty,i);
        for starMission in starList:iterator() do 
            if starMission.id == missionId then
                return i;
            end
        end
    end
    return false;
end

function MissionManager:getSpecialDropMissionListMaxId(difficulty)
    difficulty = difficulty or MissionManager.DIFFICULTY0;
    if difficulty == MissionManager.DIFFICULTY0 then
        if self.normalSpecialDropMissionList then 
            local MissionMax = self.normalSpecialDropMissionList:back();
            return MissionMax.id;
        else 
            return nil;
        end
    else
        if self.difficultySpecialDropMissionList then 
            local MissionMax = self.difficultySpecialDropMissionList:back();
            return MissionMax.id;
        else 
            return nil;
        end
    end
end

function MissionManager:getSpecialDropStarMissionList(difficulty,star)
    local difficulty = difficulty or MissionManager.DIFFICULTY0;
    star = star or 1;
    if difficulty == MissionManager.DIFFICULTY0 then
        if star == 1 then
            return self.normalSpecialDropMissionList;
        elseif star == 2 then 
            return self.normalSpecialDropStar2MissionList;
        elseif star == 3 then 
            return self.normalSpecialDropStar3MissionList;
        end
    else
        if star == 1 then
            return self.difficultySpecialDropMissionList;
        elseif star == 2 then 
            return self.difficultySpecialDropStar2MissionList;
        elseif star == 3 then 
            return self.difficultySpecialDropStar3MissionList;
        end
    end
end

function MissionManager:getSpecialDropStarNextMissionId(difficulty,missionId)
    local difficulty = difficulty or MissionManager.DIFFICULTY0;
    local starNextMissionIdList = {}
    for i = 1,3 do
        local starList = self:getSpecialDropStarMissionList(difficulty,i);
        local mission = self:getMissionById(missionId);
        local MissionIdBool;
        for starMission in starList:iterator() do 
            starNextMissionIdList[i] = nil;
            MissionIdBool = self:getSpecialDropListBool(difficulty,starMission.id);
            if MissionIdBool or starMission.starLevel < i then
                if starMission.id > mission.id then
                    if starMission.mapid >= mission.mapid then
                        starNextMissionIdList[i] = starMission;
                        break;
                    end
                end
            end
        end
    end
    local minMissionId = 999999;
    if starNextMissionIdList then 
        for k = 1,3 do
            if starNextMissionIdList[k] then 
                if starNextMissionIdList[k].id < minMissionId then
                    minMissionId = starNextMissionIdList[k].id;
                end
            end
        end
    end
    if minMissionId == 999999 then 
        return nil;
    else
        return minMissionId;
    end
end

function MissionManager:reLoadspecialDropList()
    if self.specialDropListDifficulty0 == nil then
        self.specialDropListDifficulty0 = MEMapArray:new()
    end
    self.specialDropListDifficulty0:clear()
    if next(self.difficultySpecialDropMissionList) ~= nil then
        for normalSpecialDropMission in self.normalSpecialDropMissionList:iterator() do
            if normalSpecialDropMission.state == 0 then
                self.specialDropListDifficulty0:push(normalSpecialDropMission);
            end
        end
    end

    if self.specialDropListDifficulty1 == nil then
        self.specialDropListDifficulty1 = MEMapArray:new()
    end
    self.specialDropListDifficulty1:clear()

    if next(self.difficultySpecialDropMissionList) ~= nil then
        for difficultySpecialDropMission in self.difficultySpecialDropMissionList:iterator() do
            if difficultySpecialDropMission.state == 0 then
                self.specialDropListDifficulty1:push(difficultySpecialDropMission);
            end
        end
    end
end

function MissionManager:getSpecialDropList(difficulty)
    local difficulty = difficulty or MissionManager.DIFFICULTY0;
    if difficulty == MissionManager.DIFFICULTY0 then
        return self.specialDropListDifficulty0;
    else
        return self.specialDropListDifficulty1;
    end
end

function MissionManager:getSpecialDropListBool(difficulty,missionId)
    local difficulty = difficulty or MissionManager.DIFFICULTY0;
    local specialDropMissionList = self:getSpecialDropList(difficulty);
    if next(specialDropMissionList) ~= nil then 
        for specialDropMission in specialDropMissionList:iterator() do
            if specialDropMission.id == missionId then
                return true;
            end
        end
    end
    return false;
end


function MissionManager:initMapList()
    if self.normalMapList == nil then
        self.normalMapList = MEMapArray:new()
    end
    self.normalMapList:clear()

    if self.difficultyMapList == nil then
        self.difficultyMapList = MEMapArray:new()
    end
    self.difficultyMapList:clear()

    for map in self.mapList:iterator() do
        if map.open == 1 then
            if map.type == MissionManager.DIFFICULTY1 then
                self.difficultyMapList:push(map)
            else
                self.normalMapList:push(map)
            end
        end
    end
end
-- function MissionManager:registerResetEvent()
--     self.MissionDataReset = function(event)
--         self:resetMissionData()
--     end
--     TFDirector:addMEGlobalListener(MainPlayer.GAME_RESET, self.MissionDataReset)
-- end

function MissionManager:onReceiveMissionList( event )
    -- print("onGetMissionListHandle")
    -- print(event.data)
    hideLoading();
    local data = event.data;
    -- print("miss === >> ", MissionManager)
    --添加奇遇关卡信息
    AdventureMissionManager:onReceiveMissionList(data)

    self.useQuickPassTimes = event.data.useQuickPassTimes or 0
    self.useResetTimes = event.data.useResetTimes or 0

    local function getIsAlreadyOpenByBoxId( boxId )

        if not data.openBoxIdList then
           return false;
        end
        for index,id in pairs(data.openBoxIdList) do
           if id == boxId then
             return true;
           end
        end
        return false
    end

    local function getPlayerMissionByMissionId( missionId )
        if not data.missionlist then
           return nil
        end
        for index,playerMission in pairs(data.missionlist) do
           if playerMission.missionId == missionId then
             return playerMission;
           end
        end
        return nil;
    end

    for mapBox in self.mapBoxList:iterator() do
        mapBox.isAlreadyOpen = getIsAlreadyOpenByBoxId(mapBox.id);
    end


    for mission in self.missionList:iterator() do
        local playerMission = getPlayerMissionByMissionId(mission.id);
        if playerMission then
            mission.challengeCount = playerMission.challengeCount
            mission.starLevel = playerMission.starLevel
            mission.resetCount = playerMission.resetCount or 0
            mission.state = playerMission.state or 0
        else
            mission.challengeCount = 0
            mission.starLevel = MissionManager.STARLEVEL0
            mission.resetCount = 0
            mission.state = 0
        end
    end


    self:reLoadspecialDropList();

    --test code

    -- print("MissionManager:isHasPassAllMap():")
    -- print(self:isHasPassAllMap())
    -- print("MissionManager:isHasPassAllMissionForDifficulty():")
    -- print(self:isHasPassAllMissionForDifficulty(10, MissionManager.DIFFICULTY0))
    -- print("MissionManager:isCanUseBox():")
    -- print(self:isCanUseBox(10, MissionManager.DIFFICULTY0))

    -- print("MissionManager:getMaxStarlevelCount():")
    -- print(self:getMaxStarlevelCount(10, MissionManager.DIFFICULTY0))
    -- print("MissionManager:getStarlevelCount():")
    -- print(self:getStarlevelCount(10, MissionManager.DIFFICULTY0))
    -- print("MissionManager:getLastMap():")
    -- print(self:getLastMap())

    -- print("MissionManager:getLastMission():")
    -- print(self:getLastMission())
    -- print("MissionManager:getLastMissionByDifficulty():")
    -- print(self:getLastMissionByDifficulty(MissionManager.DIFFICULTY1))
    -- print("MissionManager:getMissionListByMapIdAndDifficulty():")
    -- print(self:getMissionListByMapIdAndDifficulty(10,MissionManager.DIFFICULTY0))

    -- print("MissionManager:isHaveMission():")
    -- print(self:isHaveMission(10,"04"))
    -- print("MissionManager:getCurrentMap():")
    -- print(self:getCurrentMap())
    -- print("MissionManager:getCurrentMission():")
    -- print(self:getCurrentMission())
    -- print("MissionManager:getCurrentMissionByDifficulty():")
    -- print(self:getCurrentMissionByDifficulty("02"))

    -- print("MissionManager:getMapById():")
    -- print(self:getMapById(11))
    -- print("MissionManager:getMissionById():")
    -- print(self:getMissionById(100201))
    -- print("MissionManager:getNextMapInfoByID():")
    -- print(self:getNextMapInfoByID(10))
    -- print("MissionManager:getNextMissionById():")
    -- print(self:getNextMissionById(10,"02",100203))

end



function MissionManager:onReceiveUpMission( event )
    print("onUpMissionHandle")
    -- print(event.data)
    hideLoading();

    local missionId = event.data.missionId
    local challengeCount = event.data.challengeCount
    local starLevel = event.data.starLevel
    local resetCount = event.data.resetCount or 0
    local state = event.data.state or 0

    local mission = AdventureMissionManager:getMissionById(missionId)
    if mission == nil then
        mission = self:getMissionById(missionId)
    end

    --判断是否首次通过
    local isFirstTimesPass = false;
    if not mission.starLevel  or mission.starLevel < MissionManager.STARLEVEL1 then
       isFirstTimesPass = true;
    end
    --判断是否首次到达三星
    local isFirstTimesToStarLevel3 = false;
    if (not mission.starLevel  or mission.starLevel < MissionManager.STARLEVEL3) and starLevel == MissionManager.STARLEVEL3 then
       isFirstTimesToStarLevel3 = true;
    end

    --更新缓存数据
    local mission = AdventureMissionManager:getMissionById(missionId)
    if mission == nil then
        mission = self:getMissionById(missionId)
    end
    mission.challengeCount = challengeCount;
    mission.starLevel = starLevel;
    mission.resetCount = resetCount
    mission.state = state

    self:reLoadspecialDropList();

    local data ={};
    data.missionId = missionId;
    data.isFirstTimesPass = isFirstTimesPass;
    data.isFirstTimesToStarLevel3 = isFirstTimesToStarLevel3;

    TFDirector:dispatchGlobalEventWith(MissionManager.EVENT_UPDATE_MISSION, data);
end

function MissionManager:onReceiveOpenBox( event )
    print("onReceiveOpenBox")
    -- print(event.data)
    hideLoading();
    TFAudio.playEffect("sound/effect/openbox.mp3", false)

    local mapBox = self:getBoxById(event.data.boxId);
    mapBox.isAlreadyOpen = true;

    TFDirector:dispatchGlobalEventWith(MissionManager.EVENT_UPDATE_BOX, event.data.boxId);
end

function MissionManager:onSetOpenSystem(event)
    hideLoading();
    if (event.data.info) then
        self.openSystemList[event.data.info] = true
        toastMessage(localizable.OpenFaction_Tips[event.data.info] or "")        
    end
end

function MissionManager:onSetOpenSystemList(event)

    hideLoading();
    self.openSystemList = {}
    if(event.data.infolist) then
        for i, v in pairs(event.data.infolist) do
            self.openSystemList[v] = true
        end
    end
end

function MissionManager:onReceiveResetChallengeCountResult( event )
    print("onReceiveResetChallengeCountResult")
    -- print(event.data)
    hideLoading();


    local missionId = event.data.missionId;     
    local mission = AdventureMissionManager:getMissionById(missionId)
    if mission == nil then
        mission = self:getMissionById(missionId)
    end        
    mission.challengeCount = 0;
    mission.resetCount = mission.resetCount + 1

    self.useResetTimes = self.useResetTimes + 1;
    
    TFDirector:dispatchGlobalEventWith(MissionManager.RESET_CHALLENGE_COUNT_RESULT, event.data.missionId);
    -- toastMessage("挑战次数已重置");
    toastMessage(localizable.MissionManager_reset_time)
end

function MissionManager:onReceiveQuickPassResult( event )
    print("onReceiveQuickPassResult")
    -- print(event.data)
    hideLoading();

    self.useQuickPassTimes = event.data.useQuickPassTimes or 0;
    self.useResetTimes = event.data.useResetTimes or 0;

    local missionId = event.data.missionId;  
    local mission = AdventureMissionManager:getMissionById(missionId)
    if mission == nil then
        mission = self:getMissionById(missionId)
    end  
    mission.challengeCount = event.data.challengeCount;
    self:showQuickPassReslutListLayer(event.data);

    TFDirector:dispatchGlobalEventWith(MissionManager.QUICK_PASS_RESULT, {});
end

function MissionManager:openBox( boxId )
    showLoading();
    local mapBox = self:getBoxById(boxId);
    TFDirector:send(c2s.OPEN_CHAPTER_BOX_REQUEST, {mapBox.mapid,mapBox.difficulty,boxId} );  
end

function MissionManager:singleQuickPassMission( missionId )
    showLoading();
    TFDirector:send(c2s.SINGLE_SWEEP_SECTION, {missionId} );
end

function MissionManager:manyQuickPassMission( missionId,isResetTili,isResetTimes ,challengeTimes)
    if challengeTimes <= 0 then
        return
    end
    showLoading();
    TFDirector:send(c2s.SWEEP_SECTION, {missionId,challengeTimes} );
end

function MissionManager:attackMission( missionId ,fightType, isYouLiRandom)
    showLoading();
    self.attackMissionId = missionId;

    local mission = AdventureMissionManager:getMissionById(missionId)
    if mission == nil then
        mission = self:getMissionById(missionId)
    end

    --判断是否首次通过
    self.isFirstTimesPass = false;
    if not mission.starLevel  or mission.starLevel < MissionManager.STARLEVEL1 then
       self.isFirstTimesPass = true;
    end
    if fightType == nil then
        fightType = 0 
    end
    print("=========================> attackMission",fightType)
    if (isYouLiRandom) then
        TFDirector:send(c2s.ADVENTURE_EVENT, {missionId, EnumFightStrategyType.StrategyType_HIRE_TEAM} );
    else
        TFDirector:send(c2s.CHALLENGE_MISSION, {missionId ,fightType} );
    end
    -- TFDirector:send(c2s.ADVENTURE_EVENT, {missionId} );
    
   -- --测试代码 begin
   -- local mission = MissionManager:getMissionById(missionId);
   -- local event = {}
   -- event.data ={}
   -- event.data.missionId = missionId;
   -- event.data.challengeCount = mission.challengeCount + 1;
   -- event.data.starLevel = MissionManager.STARLEVEL2;  

   -- MissionManager:onReceiveUpMission( event )
   -- --测试代码 end
end

function MissionManager:resetChallengeCount( missionId )
    showLoading();
    TFDirector:send(c2s.RESET_CHALLENGE_COUNT_REQUEST, {missionId} );
end

function MissionManager:isAlreadyOpenBox(mapId,difficulty)
    local mapBox = self:getBoxByMapIdAndDifficulty(mapId,difficulty);
    if not mapBox then
        return false;
    end
    return mapBox.isAlreadyOpen;
end

function MissionManager:getBoxByMapIdAndDifficulty(mapId,difficulty)
    for mapBox in self.mapBoxList:iterator() do
        if mapBox.mapid == mapId and mapBox.difficulty == difficulty then
            return mapBox;
        end
    end
    return nil;
end

function MissionManager:isAlreadyOpenByBoxId(boxid,difficulty)
    local mapBox = self:getBoxByBoxIdAndDifficulty(boxid,difficulty);
    if not mapBox then
        return false;
    end
    return mapBox.isAlreadyOpen;
end

function MissionManager:getBoxByBoxIdAndDifficulty(boxid,difficulty)
    for mapBox in self.mapBoxList:iterator() do
        if mapBox.id == boxid and mapBox.difficulty == difficulty then
            return mapBox;
        end
    end
    return nil;
end

--是否通过所有章节
function MissionManager:isHasPassAllMap(difficulty)
    difficulty = difficulty or MissionManager.DIFFICULTY0;
    return self:getCurrentMap(difficulty) == nil;
end

--是否通过本章节、本难度所有关卡
function MissionManager:isHasPassAllMissionForDifficulty(mapId,difficulty)
    local missionlist = self:getMissionListByMapIdAndDifficulty(mapId , difficulty);
    local lastMission = missionlist:back();
    if lastMission.starLevel > MissionManager.STARLEVEL0 then
        return true;
    end
    return false;
end

--是否能吃鸡
function MissionManager:isCanUseBox(mapId,difficulty)
    local starLevelCount = self:getStarlevelCount(mapId,difficulty);
    local maxStarLevelCount = self:getMaxStarlevelCount(mapId,difficulty);
    if starLevelCount < maxStarLevelCount  then
        return false;
    end
    return true;
end

--获取最大星级
function MissionManager:getMaxStarlevelCount(mapId,difficulty)
    local missionlist = self:getMissionListByMapIdAndDifficulty(mapId , difficulty);
    local starLevelCount = missionlist:length() * 3;
    return starLevelCount;
end

--获取关卡宝箱列表
function MissionManager:getBoxListByMapId( mapId,difficulty)

    local boxList = boxList or {}
    local boxIndex = 1
    for mapBox in self.mapBoxList:iterator() do
        local id = mapBox.mapid
        if self.DIFFICULTY1 == mapBox.difficulty then
            id  = id + 1000
        end
        if id == mapId and mapBox.difficulty == difficulty then
            boxList[boxIndex] = mapBox
            boxIndex = boxIndex + 1
        end
    end
    return boxList
end

--获取当前关卡所获得星级
function MissionManager:getStarlevelCount(mapId,difficulty)
    local starLevelCount = 0;
    local missionlist = self:getMissionListByMapIdAndDifficulty(mapId , difficulty);
    for mission in missionlist:iterator() do
        starLevelCount = starLevelCount +  math.min(mission.starLevel,MissionManager.STARLEVEL3);
    end
    return starLevelCount;
end

--取得第一个章节
function MissionManager:getMapList(difficulty)
    if difficulty == MissionManager.DIFFICULTY1 then
        return self.difficultyMapList
    else
        return self.normalMapList
    end
end
function MissionManager:getFirstMap(difficulty)
    if difficulty == MissionManager.DIFFICULTY1 then
        return self.difficultyMapList:front()
    else
        return self.normalMapList:front()
    end
end

--取得最后一个章节
function MissionManager:getLastMap(difficulty)
    if difficulty == MissionManager.DIFFICULTY1 then
        return self.difficultyMapList:back()
    else
        return self.normalMapList:back()
    end
end

--取得低级难度的第一个关卡
function MissionManager:getFirstMission()
    return self:getFirstMissionByDifficulty(MissionManager.DIFFICULTY0);
end

--取得低级难度的最后一个关卡
function MissionManager:getLastMission()
    return self:getLastMissionByDifficulty(MissionManager.DIFFICULTY0);
end

--取得特定难度的第一个关卡
function MissionManager:getFirstMissionByDifficulty(difficulty)
    local firstMap = self:getFirstMap(difficulty);
    return self:getFirstMissionByMapIdAndDifficulty(firstMap.id, difficulty);
end

--取得特定章节、难度的第一个关卡
function MissionManager:getFirstMissionByMapIdAndDifficulty(mapId, difficulty)
    local missionlist = self:getMissionListByMapIdAndDifficulty(mapId , difficulty);
    return missionlist:front();
end

--取得特定难度的最后一个关卡
function MissionManager:getLastMissionByDifficulty(difficulty)
    local lastMap = self:getLastMap(difficulty);
    return self:getLastMissionByMapIdAndDifficulty(lastMap.id, difficulty);
end
--取得特定章节、难度的最后一个关卡
function MissionManager:getLastMissionByMapIdAndDifficulty(mapId, difficulty)
    local missionlist = self:getMissionListByMapIdAndDifficulty(mapId, difficulty);
    return missionlist:back();
end

function MissionManager:initMissionList()
    self.normalMission = {}
    self.difficultyMission = {}

    for mission in self.missionList:iterator() do
        if mission.difficulty == MissionManager.DIFFICULTY0 then
            if self.normalMission[mission.mapid] == nil then
                self.normalMission[mission.mapid] = TFArray:new()
            end
            self.normalMission[mission.mapid]:push(mission)
        else
            --change by wuqi 16/09/28
            mission.mapid = mission.mapid + 1000
            if self.difficultyMission[mission.mapid] == nil then
                self.difficultyMission[mission.mapid] = TFArray:new()
            end
            self.difficultyMission[mission.mapid]:push(mission)
        end
    end
end

--取得特定章节、难度的关卡列表
function MissionManager:getMissionListByMapIdAndDifficulty(mapId,difficulty)
    if difficulty == MissionManager.DIFFICULTY0 then
        return self.normalMission[mapId]
    else
        return self.difficultyMission[mapId]
    end

    -- if difficulty == MissionManager.DIFFICULTY0 then
    --     if self.normalMission == nil then
    --         self.normalMission = {}
    --     end
    --     if self.normalMission[mapId] then
    --         return self.normalMission[mapId]
    --     end
    --     local missionlist = TFArray:new();
    --     for mission in self.missionList:iterator() do
    --         if mission.mapid == mapId and mission.difficulty == difficulty then
    --               missionlist:push(mission);
    --         end
    --     end
    --     self.normalMission[mapId] = missionlist
    --     return self.normalMission[mapId]
    -- else
    --     if self.difficultyMission == nil then
    --         self.difficultyMission = {}
    --     end
    --     if self.difficultyMission[mapId] then
    --         return self.difficultyMission[mapId]
    --     end
    --     local missionlist = TFArray:new();
    --     for mission in self.missionList:iterator() do
    --         if mission.mapid == mapId and mission.difficulty == difficulty then
    --               missionlist:push(mission);
    --         end
    --     end
    --     self.difficultyMission[mapId] = missionlist
    --     return self.difficultyMission[mapId]
    -- end
end

function MissionManager:showBeginTip()
    self:showTip(1);
end

function MissionManager:showEndTip()
    self:showTip(2);
end

function MissionManager:isHaveBeginTip()
    return self:isHaveTipInMission(self.attackMissionId,1);
end

function MissionManager:isHaveBeginMoive()
    if not self.isFirstTimesPass then
        return false;
    end
    if (AdventureManager and AdventureManager.bPlayMoive) then
        return false;
    end
    
    if MoiveScriptData:objectByID(self.attackMissionId) then
        return true;
    end
    return false;
end
function MissionManager:getMoiveInfo()
    if not self.isFirstTimesPass then
        return nil;
    end
    return MoiveScriptData:objectByID(self.attackMissionId)
end

function MissionManager:isHaveEndTip()
    return self:isHaveTipInMission(self.attackMissionId,2);
end

function MissionManager:showTip(stageType)
    if not self:isHaveTipInMission(self.attackMissionId,stageType) then
        return;
    end
    
    local tipList = self:getTipListByMissionId(self.attackMissionId,stageType);

    local tipData = {};
    tipData.mapId        = self.mapId;
    tipData.missionId    = missionId;
    tipData.delegate     = self;
    tipData.tiplist      = tipList; 
    tipData.stageType    = stageType;
    local tipLayer = require("lua.logic.mission.MissionTipLayer"):new(tipData);
    local currentScene = Public:currentScene();
    currentScene:addLayer(tipLayer);
end


function MissionManager:showBeginTipForMission(missionId)
    self:showTipForMission(missionId,1);
end

function MissionManager:showEndTipForMission(missionId)
    self:showTipForMission(missionId,2);
end

function MissionManager:showTipForMission(missionId,stageType,dispatchGlobalMessage)
    local tipList = self:getTipListByMissionId(missionId,stageType);

    local mission = AdventureMissionManager:getMissionById(missionId)
    if mission == nil then
        mission = self:getMissionById(missionId)
    end

    local tipData = {};
    local mapId = 1
    if mission then
        mapId = mission.mapId
    end
    tipData.mapId        = mapId;
    tipData.missionId    = missionId;
    tipData.delegate     = self;
    tipData.tiplist      = tipList; 
    tipData.stageType    = stageType;
    tipData.dispatchGlobalMessage = dispatchGlobalMessage
    local tipLayer = require("lua.logic.mission.MissionTipLayer"):new(tipData);
    local currentScene = Public:currentScene();
    currentScene:addLayer(tipLayer);
end

--取得关卡的剧情列表
function MissionManager:getTipListByMissionId(missionId,stageType)
    local tiplist = TFArray:new();
    for tip in self.missionTipList:iterator() do
        if tip.stageid == missionId and tip.type == stageType then
            tiplist:push(tip);
        end
    end
    return tiplist;
end

--关卡的是否剧情列表
function MissionManager:isHaveTipInMission(missionId,stageType)

    if not self.isFirstTimesPass then
        return false;
    end
    for tip in self.missionTipList:iterator() do
        if tip.stageid == missionId and tip.type == stageType then
            return true;
        end
    end
    return false;
end

--取得特定章节的关卡列表(分类)
function MissionManager:getMissionListByMapId(mapId)
    local missionlist0    = self:getMissionListByMapIdAndDifficulty(mapId , MissionManager.DIFFICULTY0);
    local missionlist1    = self:getMissionListByMapIdAndDifficulty(mapId , MissionManager.DIFFICULTY1);
    local missionlist2    = self:getMissionListByMapIdAndDifficulty(mapId , MissionManager.DIFFICULTY2);
    local missionlist = {[MissionManager.DIFFICULTY0] = missionlist0, [MissionManager.DIFFICULTY1] = missionlist1, [MissionManager.DIFFICULTY2] = missionlist2 }
    return missionlist;
end

--某章节、难度是否有关卡
function MissionManager:isHaveMission(mapId,difficulty)
    for mission in self.missionList:iterator() do
        if mission.mapid == mapId and mission.difficulty == difficulty then
            return true;
        end
    end
    return false;
end

--低等级的当前章节
function MissionManager:getCurrentMap(difficulty)
    difficulty = difficulty or MissionManager.DIFFICULTY0;
	local currentMission = self:getCurrentMission(difficulty);
    if currentMission then
       return self:getMapById(currentMission.difficulty, currentMission.mapid);
    end
    return nil;
end

--低等级的当前关卡
function MissionManager:getCurrentMission(difficulty)
    difficulty = difficulty or MissionManager.DIFFICULTY0;
    local _mission = AdventureMissionManager:getCurrentMission(difficulty)
    if _mission then
        return _mission
    end
    for mission in self.missionList:iterator() do
        --无星关卡，为当前小关卡
        local map = self:getMapById(mission.difficulty,mission.mapid)

        if mission.difficulty == difficulty and map then           

            if mission.starLevel == MissionManager.STARLEVEL0 then

                return mission;
            end
            _mission = mission
        end
    end
    return _mission;
end

--是否已开启第一关的宗师关卡
function MissionManager:isOpenFirstZongshiMap()
    local firstZongshiMission =self:getFirstMissionByDifficulty(MissionManager.DIFFICULTY1)
    if self:getMissionPassStatus(firstZongshiMission.id) ~= 3 then
        return true;
    end
    return false;
end

function MissionManager:getMissionIsOpen(missionId)
    return self:getMissionPassStatus(missionId) ~= 3;
end

function MissionManager:getMissionPassStatus(missionId)
    local mission = self:getMissionById(missionId);
    if mission == nil then
        print("mission == nil ,missionId =" , missionId)
        return
    end
    local missionlist = self:getMissionListByMapId(mission.mapid);
    local status = 1; --1\2\3 已通关、当前、未开放

    --初级难度
    if (mission.difficulty == MissionManager.DIFFICULTY0) then

        local currentMission = self:getCurrentMission(MissionManager.DIFFICULTY0)
        if not currentMission then
            status = 1;
        else
            --已通关
            if (missionId < currentMission.id) then
                status = 1;
            end
            --当前关
            if (missionId == currentMission.id) then
                status = 2;
            end
            --未开放
            if (missionId > currentMission.id) then
                status = 3; 
            end
        end
    end

    --初级难度
    if (mission.difficulty == MissionManager.DIFFICULTY1) then

        local currentMission0 = self:getCurrentMission(MissionManager.DIFFICULTY0)
        local currentMission  = self:getCurrentMission(MissionManager.DIFFICULTY1)

        -- print("-----------------")
        -- print("missionId = ", missionId)
        -- -- print("mission = ", mission)

        -- print("missionId = ", missionId)
        -- print("currentMission0 = ", currentMission0.id)
        -- print("currentMission = ", currentMission.id)
        -- print("currentMission0.mapid = ", currentMission0.mapid)
        -- print("mission.mapid = ", mission.mapid)
        -- print("currentMission0.mapid = ", currentMission0.mapid)
        -- if currentMission0 and  mission.mapid >= currentMission0.mapid then
        status = 3;
        if currentMission0 and  mission.mapid <= currentMission.mapid then
            status = 3; 
        -- elseif not currentMission then
        --     status = 1;
        -- else
            --已通关
            if (missionId < currentMission.id) then
                status = 1;
            end
            --当前关
            if (missionId == currentMission.id) then
                if currentMission.starLevel ~= MissionManager.STARLEVEL0 then
                    status = 1
                else
                    status = 2;
                end
            end
            --未开放
            if (missionId > currentMission.id) then
                status = 3; 
            end
        end

    end

    -- print("status = ", status)

    return status;
end
  
--特定等级的当前关卡
function MissionManager:getCurrentMissionInMapByDifficulty(mapId,difficulty)
    local missionlist = self:getMissionListByMapIdAndDifficulty(mapId ,difficulty);
    for mission in missionlist:iterator() do
        --无星关卡，为当前小关卡
        if mission.difficulty == difficulty and  mission.starLevel == MissionManager.STARLEVEL0 then
           return mission;
        end
    end
    return nil;
end

--根据ID取得章节
function MissionManager:getMapById(difficulty,mapId)
    if difficulty == MissionManager.DIFFICULTY1 then
        --change by wuqi 16/09/28
        --mapinfo表里困难本mapid从1001开始,其他表里困难本mapid从1开始
        return self.difficultyMapList:objectByID(mapId);
    else
        return self.normalMapList:objectByID(mapId);
    end
end

function MissionManager:getBoxById(boxId)
    return self.mapBoxList:objectByID(boxId);
end

--根据ID取得章节
function MissionManager:gePosListByMapId(mapId)
    local missionPosList = TFArray:new();
    for posItem in self.missionPosList:iterator() do
        if posItem.mapid == mapId then
           missionPosList:push(posItem);
        end
    end
    return missionPosList;
end

--根据ID取得关卡
function MissionManager:getMissionById(missionId)
    return self.missionList:objectByID(missionId);
end


function MissionManager:getDropItemByMissionId(missionId)
    local mission = self:getMissionById(missionId);
    return DropGroupData:GetShowDropItemByIdsStr(mission.drop);
end

function MissionManager:getSpecialDropItemByMissionId(missionId)
    
    if MainPlayer:getServerSwitchStatue(ServerSwitchType.SPECIAL_DROP ) == true then
        local mission = self:getMissionById(missionId);
        local specialDrop = string.split(mission.special_drop,'_');
        if specialDrop[1] == "" then 
            specialDrop = nil;
        end
        return specialDrop;
    else 
        return nil;
    end
end

function MissionManager:getSpecialDropStarByMissionId(missionId)
    local mission = self:getMissionById(missionId);
    local specialDropStar = string.split(mission.special_drop_star,'_');
    if specialDropStar[1] == "" then 
        specialDropStar[1] = nil;
    end
    return specialDropStar[1];
end

function MissionManager:getDropItemListByMissionId(missionId)
    local mission = self:getMissionById(missionId);
    local status = self:getMissionPassStatus(missionId);
    print("statusstatus = ",status)
    if status ~= MissionManager.STATUS_PASS then
        return DropGroupData:GetDropItemListByIdsStr(mission.first_drop);
    end
    return DropGroupData:GetDropItemListByIdsStr(mission.drop);
end

--下一个章节
function MissionManager:getNextMapInfoByID(mapId)
    -- for map in self.mapList:iterator() do
    --     if map.id > mapId then
    --     	return map;
    --     end
    -- end
    return nil;
end

--某章节、某难度的下一个关卡
function MissionManager:getNextMissionById(mapId,difficulty,missionId)
    local missionlist = self:getMissionListByMapIdAndDifficulty(mapId,difficulty);
    for mission in missionlist:iterator() do
        if mission.id > missionId then
        	return mission;
        end
    end
    return nil;
end

function MissionManager:restart()
    self.isFirstTimesPass = false;
    self:stopTrustOnekey()
end


function MissionManager:showHomeToIndexLayer(index,difficulty)
    difficulty = difficulty or MissionManager.DIFFICULTY1 ;
    local map
    if difficulty == MissionManager.DIFFICULTY1 then
        map = self.difficultyMapList:objectAt(index)
    else
        map = self.normalMapList:objectAt(index)
    end

    local missionlist = self:getMissionListByMapIdAndDifficulty(map.id , difficulty)

    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionLayer");
    layer:loadData(missionlist:front().id,difficulty);
    AlertManager:show();
end

function MissionManager:showHomeLayer(difficulty)
    difficulty = difficulty or MissionManager.DIFFICULTY0 ;

    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionLayer");
    layer:loadData(nil,difficulty);
    AlertManager:show();
end

function MissionManager:changeDifficulty(difficulty)
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionLayer");
    if layer then
        layer:changeDifficulty(difficulty);
    end
end

function MissionManager:showHomeToMissionLayer(missionId)
    local cacheKey = "lua.logic.mission.MissionLayer"
    -- if AlertManager:isInQueueByKey( cacheKey ) then
    --     -- toastMessage("关卡界面已打开，请返回关卡界面")
    --     toastMessage(localizable.MissionManager_layer_is_open)
    --     return
    -- end
    local layer = AlertManager:addLayerToQueueAndCacheByFile(cacheKey);
    -- local layer = AlertManager:addLayerByFile("lua.logic.mission.MissionLayer");
    layer:showAttackTip(missionId);
    layer:loadData(missionId);
    AlertManager:show();
end

function MissionManager:showDetailLayer(missionId)
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionDetailLayer",AlertManager.BLOCK)--,AlertManager.TWEEN_2);
    layer:loadData(missionId);

    AlertManager:show();
end

function MissionManager:showAutoResetLayer(missionId)
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionAutoResetLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
    layer:loadData(missionId);
    AlertManager:show();
end

function MissionManager:showQuickPassReslutListLayer(data)
    local layer = AlertManager:addLayerByFile("lua.logic.mission.QuickPassReslutListLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1);
    layer:loadData(data);
    AlertManager:show();
end

function MissionManager:addLayerToCache()

end

function MissionManager:resetMissionData()

    AdventureMissionManager:resetMissionData()
    -- 挑战次数重置
    for mission in self.missionList:iterator() do
        mission.challengeCount = 0;
        --add by wkdai,reset count per section
        mission.resetCount = 0;
    end

    -- 重置次数设置 0
    self.useResetTimes = 0
end

function MissionManager:quickPassToGetFGoods(goodid, needNum)

    self.quickPassGoodId = goodid
    self.quickPassGoodNum = needNum
end

function MissionManager:quickPassGoodIdGet()
    return self.quickPassGoodId,self.quickPassGoodNum
end

function MissionManager:getMaxMapIdByDifficulty( difficulty )
end

--是否第一次点击此关卡-游历
function MissionManager:checkIsFirstTimeInMission(missionId)

    local mission = AdventureMissionManager:getMissionById(missionId)
    if mission then
        if mission.starLevel  and mission.starLevel < MissionManager.STARLEVEL1 then
            return true
        end
    end

    return false
end

--关卡的是否剧情列表
function MissionManager:isHaveTipInMissionForYouli(missionId,stageType)

    for tip in self.missionTipList:iterator() do
        if tip.stageid == missionId and tip.type == stageType then
            return true;
        end
    end
    return false;
end

--开始一键托管
function MissionManager:startTrustOnekey(desLayer, needTimer)
    MainPlayer.levelUpForTrustOneKey = nil
    local vipLevel = VipData:getMinLevelDeclear(8416)
    local level = ConstantData:objectByID("AutoPassOpenLevel").value or 20
    if MainPlayer:getVipLevel() < vipLevel and MainPlayer:getLevel() < level then
        local msg =  stringUtils.format(localizable.vip_trustOnekey_not_enough,vipLevel,level);
        CommonManager:showOperateSureLayer(
                function()
                    PayManager:showPayLayer();
                end,
                nil,
                {
                title = localizable.common_vip_up,
                msg = msg,
                uiconfig = "lua.uiconfig_mango_new.common.NeedTpPayLayer"
                }
        )
        return
    end
    self.trustOneKeyState = true
    self:openTrustOnekeyLayer(desLayer, needTimer)
    if HeitaoSdk then
        HeitaoSdk.disableDeviceSleep(true)
    end
    -- TFDirector:disableDiviceSleep(true)
end

--停止一键托管
function MissionManager:stopTrustOnekey()
    self.trustOneKeyState = nil
    self:closeTrustOnekeyLayer()
    if HeitaoSdk then
        HeitaoSdk.disableDeviceSleep(false)
    end
    -- TFDirector:disableDiviceSleep(false)
end


function MissionManager:openTrustOnekeyLayer(desLayer, needTimer)
    self.trustOneKeyLayer = AlertManager:addLayerByFile(MissionManager.trustOnkeyLayerName,AlertManager.BLOCK)
    self.trustOneKeyLayer.name = MissionManager.trustOnkeyLayerName
    self.trustOneKeyLayer:setType(desLayer,needTimer)
    AlertManager:show()
end

--关闭一键托管界面----托管功能不改变
function MissionManager:closeTrustOnekeyLayer()
    print("Public:currentScene().__cname = ",Public:currentScene().__cname)
    if Public:currentScene().__cname  == 'HomeScene' then
        AlertManager:closeLayerByName(MissionManager.trustOnkeyLayerName)
    else
        if self.trustOneKeyLayer then
            Public:currentScene():removeLayer(self.trustOneKeyLayer)
        end
    end
    self.trustOneKeyLayer = nil
end

--检测一键托管 在相关layer的onshow中调用
function MissionManager:checkTrustOnekeyLayer(desLayer,needTimer)
    -- self:closeTrustOnekeyLayer()
    if self.trustOneKeyState == nil then
        return
    end
    if Public:currentScene().__cname  == 'HomeScene' then
        self:openTrustOnekeyLayer(desLayer,needTimer)
    else
        self.trustOneKeyLayer = require(MissionManager.trustOnkeyLayerName):new()
        self.trustOneKeyLayer:setType(desLayer, needTimer)
        Public:currentScene():addLayer(self.trustOneKeyLayer)
        FightManager:setAutoFight(true)
    end
end

--检测是否存在一键托管 ture or false
function MissionManager:isInTrustOnekey()
    if self.trustOneKeyState == true then
        return true
    end
    return false
end

--常驻引导关卡(前X章)
function MissionManager:checkIsInCurMap(idx)
    local limitChapter = 3
    idx = idx or 10
    if idx > limitChapter then
        return false
    end
    local bCur = false
    local missionlist = self:getMissionListByMapId(idx)
    local curMissionlist = missionlist[1]
    for v in curMissionlist:iterator() do
        local status = self:getMissionPassStatus(v.id)
        if status == self.STATUS_CUR then
            bCur = true
        end
    end
    return bCur
end

--是否完成常驻引导关卡(前X章)
function MissionManager:checkIsPassGuideMission()
    local limitChapter = 3
    local bAllPass = true
    for i = 1, limitChapter do
        local missionlist = self:getMissionListByMapId(i)
        local curMissionlist = missionlist[1]
        for v in curMissionlist:iterator() do
            local status = self:getMissionPassStatus(v.id)
            if status ~= self.STATUS_PASS then
                bAllPass = false
            end
        end
    end
    return bAllPass
end

function MissionManager:isNeedForceDown()
    local status = self:getMissionPassStatus(21);
    if status ~= self.STATUS_CLOSE then
        return true
    end
    if MainPlayer:getLevel() > 8 then
        return true
    end
    return false
end

return MissionManager:new();
