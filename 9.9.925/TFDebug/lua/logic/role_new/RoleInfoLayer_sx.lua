--[[
******角色详情*******
    -- by king
    -- 2015/4/17
]]

local RoleInfoLayer_sx = class("RoleInfoLayer_sx", BaseLayer)

local guild_practice_order = require("lua.table.t_s_guild_practice_order")

function RoleInfoLayer_sx:ctor(data)
    self.super.ctor(self,data)
    self.fightType = EnumFightStrategyType.StrategyType_PVE
    self:init("lua.uiconfig_mango_new.role_new.RoleInfoLayer_sx")
end


function RoleInfoLayer_sx:onShow()
    self.super.onShow(self)
      
    self:refreshBaseUI();
    self:refreshUI();

    if self.ScrollView_sx then
        self.ScrollView_sx:scrollToTop()
    end
end


function RoleInfoLayer_sx:refreshBaseUI()

end

function RoleInfoLayer_sx:refreshUI()

    if self.roleGmid and self.type == "self" then
        self.cardRole  = CardRoleManager:getRoleByGmid(self.roleGmid)
    end

    self.txt_des:setText(self.cardRole.describe1)
    -- self.type = "self"
    --角色属性
    for index,txt_arr in pairs(self.txt_arr_base) do
        local arrStr = 0;
        if self.type == "self" then
            arrStr = self.cardRole:getTotalAttributeByFightType(self.fightType,index)
        else
            arrStr = self.cardRole.totalAttribute[index]
        end
        txt_arr:setText(arrStr)
    end

    for index,txt_arr in pairs(self.txt_arr_add) do
        txt_arr:setVisible(false)
    end

    self.txt_percent = {}
    self.txt_arr = {}

    for i=EnumAttributeType.Crit, EnumAttributeType.Miss do
        local node = TFDirector:getChildByPath(self, "panel_shuxing" .. i)
        if  node then
            self.txt_arr[i]     = TFDirector:getChildByPath(node, "txt_shuxingzhi")
            self.txt_percent[i] = TFDirector:getChildByPath(node, "txt_percent")
        end
    end

    --角色属性
    for index,txt_a in pairs(self.txt_arr) do
        -- local arrStr = self.cardRole:getTotalAttributeByFightType(self.fightType,index)
        if self.type == "self" then
            arrStr = self.cardRole:getTotalAttributeByFightType(self.fightType,index)
        else
            arrStr = self.cardRole.totalAttribute[index]
        end

        if txt_a then
            txt_a:setText(covertToDisplayValue(index,arrStr))
        end
    end

    for index,txt_b in pairs(self.txt_percent) do
        local newIndex = index
        if index == EnumAttributeType.Crit then
            newIndex = index + 4
        elseif index == EnumAttributeType.Preciseness then
            newIndex = index + 3
        end

        -- local arrStr = self.cardRole:getTotalAttributeByFightType(self.fightType,newIndex)
        if self.type == "self" then
            arrStr = self.cardRole:getTotalAttributeByFightType(self.fightType,newIndex)
        else
            arrStr = self.cardRole.totalAttribute[newIndex]
        end

        if txt_b then
            local percent = arrStr or 0

            txt_b:setVisible(false)
            if percent > 0 then
                txt_b:setVisible(true)
                -- covertToDisplayValue(newIndex, percent)
                local percentValue = string.format("%.2f", percent / 100) .. '%'
                txt_b:setText("+"..percentValue)
            end
        end
    end

    local ir_tbl0,ea_tbl0,ep_tbl0 = {},{},{}
    if self.type == "self" then
        ir_tbl0,ea_tbl0,ep_tbl0 = self.cardRole:getTotalExtAttributeByFightType(self.fightType)
        print("ir_tbl0,ea_tbl0,ep_tbl0 = ",ir_tbl0,ea_tbl0,ep_tbl0)
    end

    local idList = {
        {idx1 = EnumFightEffectType.FightEffectType_NormalAttack,  idx2 = EnumFightEffectType.FightEffectType_NormalAttack_Num,   type = EnumFightAttributeType.Effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_SkillAttack,   idx2 = EnumFightEffectType.FightEffectType_SkillAttack_Num,    type = EnumFightAttributeType.Effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_DotHurt,       idx2 = EnumFightEffectType.FightEffectType_DotHurt_Num,        type = EnumFightAttributeType.Effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_NormalAttack,  idx2 = EnumFightEffectType.FightEffectType_NormalAttack_Num,   type = EnumFightAttributeType.Be_effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_SkillAttack,   idx2 = EnumFightEffectType.FightEffectType_SkillAttack_Num,    type = EnumFightAttributeType.Be_effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_DotHurt,       idx2 = EnumFightEffectType.FightEffectType_DotHurt_Num,        type = EnumFightAttributeType.Be_effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_AddBloodBySelf, idx2 = EnumFightEffectType.FightEffectType_AddBloodBySelf_Num,  type = EnumFightAttributeType.Be_effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_BonusHealing,   idx2 = EnumFightEffectType.FightEffectType_BonusHealing_Num,    type = EnumFightAttributeType.Be_effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_HurtGain,       idx2 = EnumFightEffectType.FightEffectType_HurtGain_Num,        type = EnumFightAttributeType.Effect_extra},
        {idx1 = EnumFightEffectType.FightEffectType_HurtGain,       idx2 = EnumFightEffectType.FightEffectType_HurtGain_Num,        type = EnumFightAttributeType.Be_effect_extra},
        {idx1 = EnumAttributeType.CritAdditionPercent,              idx2 = EnumFightEffectType.FightEffectType_Crit_Num,            type = EnumFightAttributeType.Effect_extra},
        {idx1 = EnumAttributeType.CritSubitionPercent,              idx2 = EnumFightEffectType.FightEffectType_Crit_Num,            type = EnumFightAttributeType.Be_effect_extra},
        {idx1 = EnumXinFaSpecialType.XinFaSpecialType_SillCD,       idx2 = EnumXinFaSpecialType.XinFaSpecialType_SillCD,            type = EnumFightAttributeType.Effect_extra},
    }

    print('self.cardRole.effectActive = ',self.cardRole.effectActive)
    print('self.cardRole.effectPassive = ',self.cardRole.effectPassive)
    local count = 1
    for i=16,25 do
        local node          = TFDirector:getChildByPath(self.ScrollView_sx, "panel_shuxing" .. i)
        local txt_arr       = TFDirector:getChildByPath(node, "txt_shuxingzhi")
        local txt_percent   = TFDirector:getChildByPath(node, "txt_percent")

        local arrPer = 0
        local arrNum = 0
        local idInfo = idList[count]
        if self.type == "self" then
            if idInfo.type == EnumFightAttributeType.Effect_extra then
                local x = ea_tbl0[idInfo.idx1] or 0
                arrPer = x * 0.01
                x = ea_tbl0[idInfo.idx2] or 0
                arrNum = x
            elseif idInfo.type == EnumFightAttributeType.Be_effect_extra then
                local x = ep_tbl0[idInfo.idx1] or 0 
                arrPer = math.abs(x) * 0.01
                x = ep_tbl0[idInfo.idx2] or 0
                arrNum = math.abs(x)
            end
        else
            if idInfo.type == EnumFightAttributeType.Effect_extra then
                local x = 0
                if self.cardRole and self.cardRole.effectActive and self.cardRole.effectActive[idInfo.idx1] then
                    x = self.cardRole.effectActive[idInfo.idx1]
                end
                -- local x = self.cardRole.effectActive[idInfo.idx1] or 0
                arrPer = x * 0.01
                x = 0
                if self.cardRole.effectActive and self.cardRole.effectActive[idInfo.idx2] then
                    x = self.cardRole.effectActive[idInfo.idx2]
                end
                -- x = self.cardRole.effectActive[idInfo.idx2] or 0
                arrNum = x
            elseif idInfo.type == EnumFightAttributeType.Be_effect_extra then
                local x = 0
                if self.cardRole.effectPassive and self.cardRole.effectPassive[idInfo.idx1] then
                    x = self.cardRole.effectPassive[idInfo.idx1]
                end
                -- local x = self.cardRole.effectPassive[idInfo.idx1] or 0
                arrPer = math.abs(x) * 0.01
                x = 0
                if self.cardRole.effectPassive and self.cardRole.effectPassive[idInfo.idx2] then
                    x = self.cardRole.effectPassive[idInfo.idx2]
                end
                -- x = self.cardRole.effectPassive[idInfo.idx2] or 0
                arrNum = math.abs(x)
            end
        end
        if arrPer > 0 then
            txt_percent:setText(arrPer .. "%")
        else
            txt_percent:setText('0%')
        end
        if arrNum > 0 then
            txt_arr:setText("+" .. arrNum)
        else
            txt_arr:setText('')
        end
        count = count + 1
    end

    for i=26,27 do
        local node          = TFDirector:getChildByPath(self.ScrollView_sx, "panel_shuxing" .. i)
        local txt_arr       = TFDirector:getChildByPath(node, "txt_shuxingzhi")
        local txt_percent   = TFDirector:getChildByPath(node, "txt_percent")

        local arrPer = 0
        local arrNum = 0
        local idInfo = idList[count]

        if self.type == "self" then
            local x = self.cardRole.totalAttribute.attribute[idInfo.idx1] or 0
            arrPer = x * 0.01
        else
            local x = self.cardRole.totalAttribute[idInfo.idx1] or 0
            arrPer = x * 0.01
        end
        if arrPer > 0 then
            txt_percent:setText(arrPer .. "%")
        else
            txt_percent:setText('0%')
        end
        if arrNum > 0 then
            txt_arr:setText("+" .. arrNum)
        else
            txt_arr:setText('')
        end
        count = count + 1
    end
    for i=28,28 do
        local node          = TFDirector:getChildByPath(self.ScrollView_sx, "panel_shuxing" .. i)
        local txt_arr       = TFDirector:getChildByPath(node, "txt_shuxingzhi")
        local txt_percent   = TFDirector:getChildByPath(node, "txt_percent")

        local arrPer = 0
        local arrNum = 0
        local idInfo = idList[count]

        if idInfo.type == EnumFightAttributeType.Effect_extra then
            local x = 0
            if self.cardRole and self.cardRole.XinFaSpecialAttribute and self.cardRole.XinFaSpecialAttribute.attribute[idInfo.idx1] then
                x = self.cardRole.XinFaSpecialAttribute.attribute[idInfo.idx1]
            end
            arrPer = x * 0.01

            x = 0
            arrNum = x
        elseif idInfo.type == EnumFightAttributeType.Be_effect_extra then
            local x = 0
            if self.cardRole.XinFaSpecialAttribute and self.cardRole.XinFaSpecialAttribute.attribute[idInfo.idx1] then
                x = self.cardRole.XinFaSpecialAttribute.attribute[idInfo.idx1]
            end
            arrPer = math.abs(x) * 0.01
            x = 0

            arrNum = math.abs(x)
        --end
        end
        if arrPer > 0 then
            txt_percent:setText(arrPer .. "%")
        else
            txt_percent:setText('0%')
        end
        if arrNum > 0 then
            txt_arr:setText("+" .. arrNum)
        else
            txt_arr:setText('')
        end
        count = count + 1
    end

end

function RoleInfoLayer_sx:initUI(ui)
    self.super.initUI(self,ui)

    self.panel_content  = TFDirector:getChildByPath(ui, 'pan_content')
    self.txt_des     = TFDirector:getChildByPath(ui, 'txt_wenben')

    -- 基本属性
    local panel_arr = TFDirector:getChildByPath(ui, "panel_jingmaixiangqing")
    self.txt_arr_base = {}
    self.txt_arr_base[EnumAttributeType.Blood]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_qixue"),"txt_base")
    self.txt_arr_base[EnumAttributeType.Force]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_wuli"),"txt_base")
    self.txt_arr_base[EnumAttributeType.Defence] =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_fangyu"),"txt_base")
    self.txt_arr_base[EnumAttributeType.Magic]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_neili"),"txt_base")
    self.txt_arr_base[EnumAttributeType.Agility] =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_shenfa"),"txt_base")


    -- self.txt_arr_base[EnumAttributeType.Agility]:enableShadow(CCSizeMake(10, 10),0,0);

    self.txt_arr_add = {}
    self.txt_arr_add[EnumAttributeType.Blood]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_qixue"),"txt_add")
    self.txt_arr_add[EnumAttributeType.Force]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_wuli"),"txt_add")
    self.txt_arr_add[EnumAttributeType.Defence] =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_fangyu"),"txt_add")
    self.txt_arr_add[EnumAttributeType.Magic]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_neili"),"txt_add")
    self.txt_arr_add[EnumAttributeType.Agility] =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_shenfa"),"txt_add")


    for i=EnumAttributeType.Crit, EnumAttributeType.Miss do
        local node = TFDirector:getChildByPath(ui, "panel_shuxing" .. i)
        if  node then
            local percentNode = TFDirector:getChildByPath(node, "txt_percent")
            print("percentNode = ", percentNode)
            if percentNode then
                local posX = percentNode:getPositionX()

                percentNode:setPositionX(posX + 20)
            end
        end
    end


    self.ScrollView_sx = TFDirector:getChildByPath(ui, "ScrollView_sx")
end



function RoleInfoLayer_sx:registerEvents(ui)
    self.super.registerEvents(self)


end


function RoleInfoLayer_sx:removeEvents()
    self.super.removeEvents(self);
end


function RoleInfoLayer_sx.onCloseClickHandle(sender)
    local self = sender.logic;

    if (self.img_select) then
        self:removeSelectIcon();
        self:closeEquipListLayer();
       return;
    end 
    AlertManager:close(AlertManager.TWEEN_1);
end


function RoleInfoLayer_sx.BtnClickHandle(sender)
    local self  = sender.logic

end

function RoleInfoLayer_sx:setCardRole(cardRole)
    self.cardRole = cardRole

    if cardRole then
        self.roleGmid = cardRole.gmId
    end
end

return RoleInfoLayer_sx
