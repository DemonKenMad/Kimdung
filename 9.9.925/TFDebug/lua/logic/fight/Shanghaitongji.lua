--[[
]]

local Shanghaitongji = class("Shanghaitongji", BaseLayer)


local fightRoleMgr  = require("lua.logic.fight.FightRoleManager")
function Shanghaitongji:ctor()
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.fight.Shanghaitongji")
end

function Shanghaitongji:initUI(ui)
    self.super.initUI(self,ui)

    self.panel_role = {}
    for i=1,10 do
        local index = i
        if i > 5 then
            index = index + 1
        end
        self.panel_role[index] = TFDirector:getChildByPath(ui, 'Panel_role'..i)
    end
    for i=1,2 do
        self.panel_role[i*5+i] = TFDirector:getChildByPath(ui, 'Panel_pet'..i)
    end
    self.btn_close = TFDirector:getChildByPath(ui, 'btn_close')
    local bg = TFDirector:getChildByPath(ui, 'bg')
    self.maxHurt = 0
    bg:setTouchEnabled(true); 
    self.effectTimer = {}
end

function Shanghaitongji:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function Shanghaitongji:dispose()
    self.super.dispose(self)
end

function Shanghaitongji:refreshUI()
    if FightManager.lastEndFightMsg == nil then
        return
    end
    local hurtList = FightManager.lastEndFightMsg[7]
    if hurtList == nil then
        return
    end
    self.maxHurt = 0
    for i=1,#hurtList do
        local hurtInfo = hurtList[i]
        if hurtInfo and hurtInfo[1] then
            self.maxHurt =  math.max(self.maxHurt , hurtInfo[2] or 0)
        end
    end

    table.sort( hurtList, function ( a,b )
        if a and b and a[1] and b[1] then
            return a[1] < b[1]
        end
        return false
    end )

    local ourIndex = 1
    local enemyIndex = 7

    for i=1,#hurtList do
        local hurtInfo = hurtList[i]
        if hurtInfo and hurtInfo[1] < 9 then
            if (not self:showInfo(ourIndex , hurtInfo)) then
                ourIndex = ourIndex + 1
            end
        elseif hurtInfo and hurtInfo[1] < 18 then
            if (not self:showInfo(enemyIndex , hurtInfo)) then
                enemyIndex = enemyIndex + 1
            end
        elseif hurtInfo and hurtInfo[1] == 18 then
            if (not self:showInfo(ourIndex , hurtInfo)) then
                ourIndex = ourIndex + 1
            end
        elseif hurtInfo and hurtInfo[1] == 19 then
            if (self:showInfo(enemyIndex , hurtInfo)) then
                enemyIndex = enemyIndex + 1
            end
        end
    end
    for i=ourIndex,6 do
        self.panel_role[i]:setVisible(false)
    end
    for i=enemyIndex,12 do
        self.panel_role[i]:setVisible(false)
    end
end

function Shanghaitongji:getRoleByIndex(index )
    local roleInfo = {}
    for k,v in pairs(FightManager.fightBeginInfo.rolelist) do
        if v.posindex == index then
            if v.posindex < 18 then
                local roleTableData = nil
                if v.typeid == 2 then
                    if FightManager.fightBeginInfo.fighttype  ~= EnumFightType.FYRecord then
                        roleTableData = NPCData:objectByID(v.roleId)
                        roleInfo.headPath = "icon/roleicon/"..roleTableData.image..".png"
                    else
                        roleTableData = FYRecordData:objectByID(v.roleId)
                        roleInfo.headPath = "icon/roleicon/"..roleTableData.image..".png"
                    end
                else
                    roleTableData = CardRoleManager:getModleRoleById(v.roleId)
                    if roleTableData == nil then
                        roleTableData = RoleData:objectByID(v.roleId)
                        if (roleTableData.summoned and roleTableData.summoned ~= 0) then
                            --召唤物
                            roleInfo.headPath = nil
                        else
                            roleInfo.headPath = "icon/roleicon/"..roleTableData.image..".png"
                        end
                    else
                        roleInfo.headPath = roleTableData.icon
                    end
                end
                roleInfo.quality = roleTableData.quality
                roleInfo.kind = 1
                return roleInfo
            else
                local roleTableData = BattlePetData:objectByID(v.roleId)
                roleInfo.quality = v.maxhp
                roleInfo.headPath = roleTableData:getIconPath(roleInfo.quality)
                roleInfo.kind = 2
                return roleInfo
            end
        end
    end
    return roleInfo
end

function Shanghaitongji:showInfo( index , info )
    
    local role = self:getRoleByIndex(info[1])
    if role.headPath == nil or role.quality == nil or self.panel_role[index] == nil then
        return true
    end
    self.panel_role[index]:setVisible(true)
    local bg_role = TFDirector:getChildByPath(self.panel_role[index], 'bg_role')
    bg_role:setTexture(GetColorIconByQuality(role.quality))
    local img_roleicon = TFDirector:getChildByPath(self.panel_role[index], 'img_roleicon')
    if role.kind == 1 then
        img_roleicon:setRotationY(0)
    else
        img_roleicon:setRotationY(180)
    end
    img_roleicon:setTexture(role.headPath)
    local txt_shanghai = TFDirector:getChildByPath(self.panel_role[index], 'txt_shanghai')
    local shanghai = TFDirector:getChildByPath(self.panel_role[index], 'shanghai')
    txt_shanghai:setText(info[2])
    shanghai:setPercent( 0 )
    local max_percent = math.ceil(info[2]/self.maxHurt*100)
    local time = 1
    self.effectTimer[index] = TFDirector:addTimer(30,-1,nil,function ()
        shanghai:setPercent( max_percent*time/30 )
        if time == 30 then
            TFDirector:removeTimer(self.effectTimer[index])
            self.effectTimer[index] = nil
            return
        end
        time = time + 1
    end)

end


function Shanghaitongji:removeUI()
    self.super.removeUI(self)
end

function Shanghaitongji:registerEvents()
	self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);
end

function Shanghaitongji:removeEvents()

    for i=1,12 do
        if self.effectTimer[i] then
            TFDirector:removeTimer(self.effectTimer[i])
            self.effectTimer[i] = nil
        end
    end
    self.effectTimer = {}
    self.super.removeEvents(self)
end

return Shanghaitongji
