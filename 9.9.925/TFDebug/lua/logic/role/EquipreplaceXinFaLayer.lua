--[[
    更换天书,已穿戴
]]

local EquipReplaceXinFaLayer = class("EquipReplaceXinFaLayer", BaseLayer)

UINum = 13

function EquipReplaceXinFaLayer:ctor()
    self.super.ctor(self, data)
    self:init("lua.uiconfig_mango_new.role.EquipReplaceXinFa")

end

function EquipReplaceXinFaLayer:loadData(roleGmId,equipGmId)
    self.roleGmId   = roleGmId;
    self.equipGmId  = equipGmId;
end

function EquipReplaceXinFaLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
    self.equipInfo  = XinFaManager:getXinFaByGmId(self.equipGmId)
    self:refreshUI()
end

function EquipReplaceXinFaLayer:initUI(ui)
    self.super.initUI(self, ui)
    
    self.btn_genghuan        = TFDirector:getChildByPath(ui, 'btn_genghuan')
    self.panel_close        = TFDirector:getChildByPath(ui, 'panel_close')

    self.panel_chuandaizhuangbei        = TFDirector:getChildByPath(ui, 'panel_chuandaizhuangbei');
    self.panel_dangqianzhuangbei        = TFDirector:getChildByPath(ui, 'panel_dangqianzhuangbei');
end


function EquipReplaceXinFaLayer:refreshUI()
    self.cardRole = CardRoleManager:getRoleByGmid(self.roleGmId);

    self.equip = XinFaManager:getXinFaByGmId(self.equipGmId);
    self:initAttr(self.panel_chuandaizhuangbei, self.equip);

    self.cur_equip = self.cardRole:getXinFa()
    self:initAttr(self.panel_dangqianzhuangbei, self.cur_equip);
    local img_arrow = TFDirector:getChildByPath(self.panel_dangqianzhuangbei, 'img_jiantousheng');
    img_arrow:setVisible(false)
    img_arrow = TFDirector:getChildByPath(self.panel_chuandaizhuangbei, 'img_jiantousheng');
    if (self.cur_equip ~= nil and self.cur_equip.gmId == self.equipGmId) then
        print(1)
        img_arrow:setVisible(false);
    elseif self.cur_equip == nil or self.cur_equip:getpower() < self.equip:getpower() then
        img_arrow:setVisible(true);
        img_arrow:setTexture("ui_new/roleequip/js_jts_icon.png");
    else
        img_arrow:setVisible(true);
        img_arrow:setTexture("ui_new/roleequip/js_jtx_icon.png");
    end
end

function EquipReplaceXinFaLayer:initAttr(panel_node,equipInfo)
    local btn_equip                 = TFDirector:getChildByPath(panel_node, 'btn_equip')       
    local img_tianshu_icon          = TFDirector:getChildByPath(btn_equip, 'img_tianshu_icon')    
    local panel_star                = TFDirector:getChildByPath(panel_node, 'panel_star') 
    local txt_starlv                = TFDirector:getChildByPath(panel_star, 'txt_starlv') 
    local txt_qianghualv            = TFDirector:getChildByPath(panel_node, 'txt_qianghualv')
    local panel_shuxing             = TFDirector:getChildByPath(panel_node, 'panel_shuxing')
    local panel_move                = TFDirector:getChildByPath(panel_shuxing, 'panel_move')
    local txt_zhanlizhi             = TFDirector:getChildByPath(panel_node, 'txt_zhanlizhi')
    local btn_zhuangpei             = TFDirector:getChildByPath(panel_node, 'btn_zhuangpei')
    local txt_zhuangbeiming         = TFDirector:getChildByPath(panel_node, 'txt_zhuangbeiming')
    local txt_attr = {}
    for i = 1, UINum do
        local txt_attr1     = TFDirector:getChildByPath(panel_move, 'txt_attr'..i)
        txt_attr1.txt_num   = TFDirector:getChildByPath(txt_attr1, 'txt_attr'..i..'_num')
        txt_attr1:setVisible(false)
        txt_attr[i]         = txt_attr1
    end

    if equipInfo == nil then 
         return
    end
    txt_zhuangbeiming:setText(equipInfo.config.name)
    btn_equip:setTextureNormal(GetColorIconByQuality(equipInfo.config.quality))
    XinFaManager:BindEffectOnEquip(btn_equip,equipInfo)
    img_tianshu_icon:setTexture(equipInfo.config:GetPath())
    if equipInfo.star == 0 then
        panel_star:setVisible(false)
    else
        panel_star:setVisible(true)
    end
    txt_starlv:setText(equipInfo.star)
    if equipInfo.level == 1 then
        txt_qianghualv:setVisible(false)
    else
        txt_qianghualv:setVisible(true)
    end
    txt_qianghualv:setText('+'..equipInfo.level)
    txt_zhanlizhi:setText(GetPowerByAttribute(equipInfo:getTotalAttribute().attribute))

    local attribute = equipInfo:getTotalAttribute().attribute
    if # attribute <= 0 then
        return
    end
    for i = 1, UINum do
        txt_attr[i]:setVisible(false)
    end
    local count = 1
    for i,v in pairs(attribute) do
        if i < 6 then
            local txt_attr = txt_attr[count]
            txt_attr:setText(AttributeTypeStr[i])
            txt_attr:setPosition(ccp(40, 245 - 30 * (count - 1)))
            txt_attr.txt_num:setText('+'..v)
            txt_attr:setColor(ccc3(0,0,0))
            txt_attr:setVisible(true)
            count = count + 1
        elseif i == 32 or i == 33 then
            local txt_attr = txt_attr[count]
            txt_attr:setText(localizable.XinFaSpecialbuteTypeDisPlayeStr[i][1]..'+'..v / 100 ..'%')
            txt_attr:setPosition(ccp(40, 245 - 30 * (count - 1)))
            txt_attr.txt_num:setText('')
            txt_attr:setColor(ccc3(0,0,0))
            txt_attr:setVisible(true)
            count = count + 1
        end
    end
    for i,v in pairs(attribute) do
        if (i > 6 and i < 18) or (i > 23 and i < 31) then
            local txt_attr = txt_attr[count]
            txt_attr:setText(localizable.AttributeTypeStr[i]..'+'..covertToPercentNotZero(v/10))
            txt_attr:setPosition(ccp(40, 245 - 30 * (count - 1)))
            txt_attr.txt_num:setText("")
            txt_attr:setColor(ccc3(189,74,48))
            txt_attr:setVisible(true)
            count = count + 1
        -- elseif i == 32 or i == 33 then
        --     local txt_attr = txt_attr[count]
        --     txt_attr:setText(localizable.XinFaSpecialbuteTypeDisPlayeStr[i][1]..'+'..covertToPercentNotZero(v/10))
        --     txt_attr:setPosition(ccp(40, 245 - 30 * (count - 1)))
        --     txt_attr.txt_num:setText("")
        --     txt_attr:setColor(ccc3(189,74,48))
        --     txt_attr:setVisible(true)
        --     count = count + 1
        end
    end
    for i,v in pairs(attribute) do
        if i > 500 then
            local txt_attr = txt_attr[count]
            --策划说要直接判断换行
            txt_attr:setPosition(ccp(40, 245 - 30 * (count - 0.7)))
            txt_attr:setText(localizable.XinFaSpecialbuteTypeDisPlayeStr[i][1]..'\n'..localizable.XinFaSpecialbuteTypeDisPlayeStr[i][2]..'+'..covertToPercentNotZero(v/10))
            txt_attr.txt_num:setText("")
            txt_attr:setColor(ccc3(189,74,48))
            txt_attr:setVisible(true)
            count = count + 1
        end
    end

    self:SetMove(panel_move,count)

end

function EquipReplaceXinFaLayer:removeUI()
    self.super.removeUI(self)
end

function EquipReplaceXinFaLayer:registerEvents(ui)
    self.super.registerEvents(self);

    self.btn_genghuan.logic = self;
    self.btn_genghuan:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onGenghuanClickHandle),1);
end

function EquipReplaceXinFaLayer.onGenghuanClickHandle(sender) 
    local self = sender.logic
    TFAudio.playEffect("sound/effect/btn_wear.mp3", false)
    local item = XinFaManager:getXinFaByGmId(self.equipGmId).config

    TFDirector:dispatchGlobalEventWith("XinFaChangeBegin", {})
    XinFaManager:sendEquipHeartMethod(self.roleGmId, self.equipGmId, item.id)
    self:getParent():removeLayer(self, not self.isCache)
end


function EquipReplaceXinFaLayer:removeEvents()
    self.super.removeEvents(self)
end

function EquipReplaceXinFaLayer:SetMove(node,index)
    if node == nil then
        return nil
    end
    if node.moveTween then
        TFDirector:killTween(node.moveTween)
        node.moveTween = nil
        node:setPositionY(node.initPosY)
    end

    if node.initPosY == nil then
        node.initPosY = node:getPositionY()
    end
    local limitAttrNum = 9
    if index > limitAttrNum then    
        local moveDy = (index - limitAttrNum)*30
        local posY = node.initPosY
        local moveTween = 
        {
            target = node,
            repeated = -1,
            {
                duration = 2,
                delay = 1,
                y = posY + moveDy,
                      
            },
            { -- 此节实现节与节之间的延时
                duration = 1,
                delay = 1, 
                onComplete = function()
                    node:setPositionY(posY)
                end    
            },
        }
        TFDirector:toTween(moveTween)
        node.moveTween = moveTween
    end
end


return EquipReplaceXinFaLayer