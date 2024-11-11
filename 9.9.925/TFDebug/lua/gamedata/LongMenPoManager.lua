-- client side LongMenPoManager.lua
--[[
 * @Description: 龙门破管理类
 ]]
-- script writer chikui
-- creation time 2016-06-02


local LongMenPoManager = class("LongMenPoManager")

LongMenPoManager.RECEIVE_FLOOR_INFO     = "LongMenPoManager.RECEIVE_FLOOR_INFO"
LongMenPoManager.RECEIVE_BREAK_START    = "LongMenPoManager.RECEIVE_BREAK_START"
LongMenPoManager.RECEIVE_BREAK_CLICK    = "LongMenPoManager.RECEIVE_BREAK_CLICK"
LongMenPoManager.RECEIVE_REFRESH_AWARD  = "LongMenPoManager.RECEIVE_REFRESH_AWARD"

LongMenPoManager.RECEIVE_USE_ITEM_1     = "LongMenPoManager.RECEIVE_USE_ITEM_1"
LongMenPoManager.RECEIVE_USE_ITEM_2     = "LongMenPoManager.RECEIVE_USE_ITEM_2"
LongMenPoManager.RECEIVE_USE_ITEM_3     = "LongMenPoManager.RECEIVE_USE_ITEM_3"
LongMenPoManager.RECEIVE_CLEAR_24       = "LongMenPoManager.RECEIVE_CLEAR_24"

LongMenPoManager.RECEIVE_PUSH_MSG       = "LongMenPoManager.RECEIVE_PUSH_MSG"

LongMenPoManager.RECEIVE_SHOW_FLOOR_INFO = "LongMenPoManager.RECEIVE_SHOW_FLOOR_INFO"

LongMenPoManager.Item_1 = 1               --璇玑镜
LongMenPoManager.Item_2 = 2               --昆仑玉
LongMenPoManager.Item_3 = 3               --羲皇碟

function LongMenPoManager:ctor(data)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_INFO_RESPONSE, self, self.onReceiveFloorInfo)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_START_RESPONSE, self, self.onReceiveBreakStart)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_CLICK_RESPONSE, self, self.onReceiveBreakClick)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_REFRESH_RESPONSE, self, self.onReceiveRefreshAward)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_USE_XUAN_JI_JING_RESPONSE, self, self.onReceiveUseItem_1)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_REVIVER_RESPONSE, self, self.onReceiveUseItem_2)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_RESET_RESPONSE, self, self.onReceiveUseItem_3)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_CLEAR_RESPONSE, self, self.onReceiveClear24)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_PUSH_REWARD_RESPONSE, self, self.onReceivePushMsg)
    TFDirector:addProto(s2c.LONG_MEN_BREAK_RED_RESPONSE, self, self.onReceiveChallengeCount)
    TFDirector:addProto(s2c.GAIN_LONG_MEN_TYPE_INFO, self, self.onReceiveShowFloorInfo)
    
    
    self:restart()
end

function LongMenPoManager:restart()
    self.floorInfo  = {}
    self.curInfo    = {}
    self.break_start_cost_tip = false
    self.curInfo.challengeCount = -1
    self.pushMsgList = {}
    self.clickIndex = 0
    self.floorClicked = false
end

function LongMenPoManager:getFloorInfo()
    return self.floorInfo or {}
end

function LongMenPoManager:getFloorInfoById(id)
    return self.floorInfo[id] or {}
end

function LongMenPoManager:getCurInfo()
    return self.curInfo or {}
end

function LongMenPoManager:requestInfo()
    showLoading()
    local msg = {
    }
    TFDirector:send(c2s.LONG_MEN_BREAK_INFO_REQUEST,msg)
end

function LongMenPoManager:requestBreakStart()
    showLoading()
    local msg = {
    }
    TFDirector:send(c2s.LONG_MEN_BREAK_START_REQUEST,msg)
end

function LongMenPoManager:requestBreakClick( floorId ,index)
    showLoading()
    local msg = {
        floorId,
        index - 1
    }
    self.clickIndex = index
    TFDirector:send(c2s.LONG_MEN_BREAK_CLICK_REQUEST,msg)
end

function LongMenPoManager:requestRefreshAward()
    showLoading()
    local msg = {
    }
    TFDirector:send(c2s.LONG_MEN_BREAK_REFRESH_REQUEST,msg)
end

function LongMenPoManager:requestItem_1( floorId )
    showLoading()
    local msg = {
        floorId,
        30132
    }
    TFDirector:send(c2s.LONG_MEN_BREAK_USE_XUAN_JI_JING_REQUEST,msg)
end

function LongMenPoManager:requestItem_2( floorId , isRviver )
    showLoading()
    local msg = {
        floorId,
        isRviver,
        30133
    }
    TFDirector:send(c2s.LONG_MEN_BREAK_REVIVER_REQUEST,msg)
end

function LongMenPoManager:requestItem_3( floorId )
    showLoading()
    local msg = {
        floorId,
        30134
    }
    TFDirector:send(c2s.LONG_MEN_BREAK_RESET_REQUEST,msg)
end

function LongMenPoManager:requestPushMsg()
    TFDirector:send(c2s.LONG_MEN_BREAK_PUSH_REWARD_REQUEST,{})
end

function LongMenPoManager:requestShowFloorInfo( floorId )
    showLoading()
    TFDirector:send(c2s.GAIN_LONG_MEN_TYPE_INFO_REQUEST,{})
end

-->>>>>>>-------------------------------------------->>>>>>>>--

function LongMenPoManager:onReceiveFloorInfo( event )
    hideLoading()
    self.floorClicked = false
    local info = event.data.info or {}
    self.curInfo = info
    local floorInfo = event.data.floorInfo or {}
    local consumeInfo = event.data.consumeInfo or {}
    for k,v in pairs(floorInfo) do
        self.floorInfo[v.floorId] = v
    end

    for k,v in pairs(consumeInfo) do
        if v.type == 1 then
            self.nConsume_Brush = tonumber(v.value)
        elseif v.type == 2 then
            self.breakConsumeList = stringToNumberTable(v.value,'_')
        elseif v.type == 3 then
            local tb = stringToTable(v.value,'|')
            self.itemConsumeList = {}
            for _,vv in pairs(tb) do
                local tbl = stringToNumberTable(vv,'_')
                self.itemConsumeList[tbl[1]] = tbl[2]
            end
        end
    end

    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_FLOOR_INFO, {})
    if self.isOpenMainLayer == true then
        self.isOpenMainLayer = false
        local layer = require('lua.logic.longmenpo.LongMenPoLayer'):new()
        AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
        AlertManager:show()
        layer:drawFloorInfo()
    end
end

function LongMenPoManager:onReceiveBreakStart( event )
    hideLoading()
    local count = self.curInfo.challengeCount or 0
    self.curInfo.challengeCount = count + 1
    self.curInfo.floorId = 1
    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_BREAK_START, {})
end

function LongMenPoManager:onReceiveBreakClick( event )
    hideLoading()
    self.floorClicked = true
    local pointType = event.data.pointType
    local typeList = event.data.pointTypes or {}
    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_BREAK_CLICK, { index = self.clickIndex , type = pointType , typeList = typeList })
end

function LongMenPoManager:onReceiveRefreshAward( event )
    hideLoading()
    local items = event.data.items or {}
    local index = 9 - (#items)
    for i=1,#items do
        self.floorInfo[i + index].item = items[i]
    end

    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_REFRESH_AWARD, {brushFloorId = index+1})
end

function LongMenPoManager:onReceiveUseItem_1( event )
    hideLoading()
    self.floorClicked = true
    self.curInfo.minedCount = (self.curInfo.minedCount or 0) + 1
    local floorId = event.data.floorId
    local index = event.data.index + 1
    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_USE_ITEM_1, { index = index ,type = 2})
end

function LongMenPoManager:onReceiveUseItem_2( event )
    hideLoading()

    self.curInfo.reviveCount = self.curInfo.reviveCount or 0
    local reviveCount = event.data.ReviveCount
    local isRevive = false
    if reviveCount > self.curInfo.reviveCount then
        isRevive = true
    end
    self.curInfo.reviveCount = reviveCount

    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_USE_ITEM_2, { isRevive = isRevive })
end

function LongMenPoManager:onReceiveUseItem_3( event )
    hideLoading()

    local currentinfo = event.data.info
    local typeList = event.data.befPointType
    self.floorInfo[currentinfo.floorId] = currentinfo
    self.curInfo.minedCount = 0
    self.curInfo.reviveCount = 0
    self.curInfo.resetCount = (self.curInfo.resetCount or 0) + 1

    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_USE_ITEM_3, { typeList = typeList })
end

function LongMenPoManager:onReceiveClear24(event)
    self.curInfo.challengeCount = 0
    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_CLEAR_24, {})
end

function LongMenPoManager:onReceivePushMsg(event)
    local data = event.data.rewardInfo
    if event.data.type == 0 then
        self.pushMsgList = data or {}
        return
    end
    local len = #data
    if len <= 0 then
        return
    end
    local maxLen = #self.pushMsgList
    for i=1,maxLen do
        data[ i + len] = self.pushMsgList[i]
    end
    self.pushMsgList = data
    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_PUSH_MSG, {})
end

function LongMenPoManager:onReceiveChallengeCount(event)
    self.curInfo.challengeCount = event.data.challengeCount
end

function LongMenPoManager:onReceiveShowFloorInfo(event)
    hideLoading()
    local typeList = event.data.pointTypes or {}
    TFDirector:dispatchGlobalEventWith(LongMenPoManager.RECEIVE_SHOW_FLOOR_INFO, {typeList = typeList})
end

-->>>>>>>-------------------------------------------->>>>>>>>--

function LongMenPoManager:isItemCanUse(type,floorId)
    if self.floorInfo[floorId] == nil then
        print("can't find floor info  id = ",floorId)
        return -1 --找不到层信息
    end
    local itemId    = 0
    local limitNum  = 0
    local usedNum   = 0
    if     type == LongMenPoManager.Item_1 then

        itemId = 30132
        limitNum = self.floorInfo[floorId].minedCount or 0
        usedNum = self.curInfo.minedCount or 0
    elseif type == LongMenPoManager.Item_2 then

        itemId = 30133
        limitNum = self.floorInfo[floorId].reviveCount or 0
        usedNum = self.curInfo.reviveCount or 0
    elseif type == LongMenPoManager.Item_3 then

        itemId = 30134
        limitNum = self.floorInfo[floorId].resetCount or 0
        usedNum = self.curInfo.resetCount or 0
    end
    if limitNum <= usedNum then
        return 2 --可使用次数不足
    end
    local itemNum = BagManager:getItemNumById(itemId)
    if itemNum <= 0 then
        return 1 --数量不足
    end
    return 0
end

function LongMenPoManager:haveJiGuan(floorId)
    -- self.floorInfo[floorId] = self.floorInfo[floorId] or {}
    -- pointList = self.floorInfo[floorId].pointInfo or {}
    -- for k,v in pairs(pointList) do
    --     if v.type == 2 and v.value == 0 then
    --         return true
    --     end
    -- end
    return true
end

function LongMenPoManager:nextFloor()
    self.curInfo.minedCount = 0
    self.curInfo.reviveCount = 0
    self.curInfo.floorId = self.curInfo.floorId + 1
    self.floorClicked = false
end

function LongMenPoManager:getBrushConsume()
    return self.nConsume_Brush or 0
end

function LongMenPoManager:getBreakConsume()
    local count = self.curInfo.challengeCount or 0
    if (not self.breakConsumeList) then
        return 0
    end
    local maxNum = #self.breakConsumeList
    if maxNum <= 0 then
        return 0
    end
    return self.breakConsumeList[count + 1] or self.breakConsumeList[maxNum]
end

function LongMenPoManager:getItemBuyConsumeById( resId )
    return self.itemConsumeList[resId] or 0
end

function LongMenPoManager:getPushMsgList()
    return self.pushMsgList or {}
end

function LongMenPoManager:openMainLayer()
    self.isOpenMainLayer = true
    self:requestPushMsg()
    self:requestInfo()
end

function LongMenPoManager:haveFreeChance()
    if self.curInfo.challengeCount and self.curInfo.challengeCount == 0 then
        return true
    end
    return false
end

function LongMenPoManager:isCanBrush(floorId)
    if floorId == 9 and self.floorClicked == true then
        return 1
    end
    return 0
end

return LongMenPoManager:new()