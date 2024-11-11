-- client side QianXiuManager.lua
--[[
 * @Description: 潜修管理器
 ]]
-- script writer chikui
-- creation time 2016-05-27


local QianXiuManager = class("QianXiuManager")

QianXiuManager.qianxiuResult = "QianXiuManager.qianxiuResult"
QianXiuManager.tihuanResult = "QianXiuManager.tihuanResult"

function QianXiuManager:ctor(data)
    TFDirector:addProto(s2c.POTENTIAL_PRACTICE_RESPONSE, self, self.onReceiveQianXiu)
    TFDirector:addProto(s2c.POTENTIAL_PRACTICE_REPLACE_RESPONSE, self, self.onReceiveTiHuan)
    TFDirector:addProto(s2c.POTENTIAL_PRACTICE_EXCHANGE_RESPONSE, self, self.onReceiveHuanGong)
    self:restart()
end

function QianXiuManager:restart()
    self.qianxiuTypeList = {}
    self.break_start_cost_tip = false
end

function QianXiuManager:setRoleQianXiuType( roleId , type )
    self.qianxiuTypeList[roleId] = type
end

function QianXiuManager:getRoleQianXiuType( roleId )
    return self.qianxiuTypeList[roleId] or 0
end

function QianXiuManager:requestQianXiu(rolegmId, type,count,lockmsg, stage)
    showLoading()
    type = ((stage - 1) * 3) + type
    local msg = {
        rolegmId,
        stage,
        type,
        count,
        lockmsg
    }
    TFDirector:send(c2s.POTENTIAL_PRACTICE_REQUEST,msg)
end

function QianXiuManager:requestTiHuan(rolegmId, stage)
    showLoading()
    local msg = {
        rolegmId,
        stage
    }
    TFDirector:send(c2s.POTENTIAL_PRACTICE_REPLACE_REQUEST,msg)
end

function QianXiuManager:onReceiveQianXiu(event)
    hideLoading()
    local data = event.data.info
    local cardRole = CardRoleManager:getRoleByGmid(data.roleId)
    if cardRole then
        cardRole:setQianXiuChangeAttri(data)
        TFDirector:dispatchGlobalEventWith(QianXiuManager.qianxiuResult, {})
    end
end

function QianXiuManager:onReceiveTiHuan(event)
    hideLoading()

    local dataList = event.data.info
    local isChangeList = event.data.isResetChange
    if (not dataList) then
        toastMessage(localizable.common_data_error)
        return
    end
    for k,v in pairs(dataList) do
        local data = v
        --local isChange = isChangeList[k]
        local cardRole = CardRoleManager:getRoleByGmid(data.roleId)
        if cardRole then
            cardRole:setQianXiuAttri(data)
            --if isChange == 1 then
            cardRole:setQianXiuChangeAttri(data)
            self:setRoleQianXiuType(cardRole.id,0)
            --end
            TFDirector:dispatchGlobalEventWith(QianXiuManager.tihuanResult, {})
        end
    end
    
end

function QianXiuManager:onReceiveHuanGong( event )
    hideLoading()
    local dataList = event.data.xiaKeInfo or {}
    for k,v in pairs(dataList) do
        local isClear = true
        for _k,_v in ipairs(v.ppInfo) do
            local cardRole = CardRoleManager:getRoleByGmid(_v.roleId)
            if cardRole then
                if isClear == true then
                    isClear = false
                    cardRole:clearQianXiu()
                end
                if _v.stage ~= 0 then
                    cardRole:setQianXiuAttri(_v)
                end
            end
        end
        for _k,_v in ipairs(v.changePPInfo) do
            local cardRole = CardRoleManager:getRoleByGmid(_v.roleId)
            if cardRole then
                if isClear == true then
                    isClear = false
                    cardRole:clearQianXiu()
                end
                if _v.stage ~= 0 then
                    cardRole:setQianXiuChangeAttri(_v)
                end
            end
        end
    end
end
function QianXiuManager:openQianXiuLayer( cardRoleGmid, cardRoleList,fightType)
    local layer =  AlertManager:addLayerToQueueAndCacheByFile("lua.logic.role_new.RoleQianXiuLayer")
    layer:loadData(cardRoleGmid,fightType)
    layer:setRoleList(cardRoleList)
    AlertManager:show()
end

return QianXiuManager:new()