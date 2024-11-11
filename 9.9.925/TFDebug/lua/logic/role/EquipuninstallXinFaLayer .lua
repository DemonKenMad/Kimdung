--[[
    卸天书
]]

local EquipUninstallXinFaLayer = class("EquipUninstallXinFaLayer", BaseLayer)

UINum = 13

function EquipUninstallXinFaLayer:ctor()
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.role.EquipUninstallXinFa")

end
function EquipUninstallXinFaLayer:loadData(roleGmId,equipGmId)
    self.roleGmId   = roleGmId;
    self.equipGmId  = equipGmId
    self.equipInfo  = XinFaManager:getXinFaByGmId(self.equipGmId)
    self:refreshUI()
end

function EquipUninstallXinFaLayer:onShow()
    self.super.onShow(self)
    
    self:refreshUI()
end

function EquipUninstallXinFaLayer:initUI(ui)
    self.super.initUI(self,ui)
    
    self.equipInfo                  = nil

    self.img_zhuangbeibeijing_bg    = TFDirector:getChildByPath(ui, 'img_zhuangbeibeijing_bg')
    self.txt_zhuangbeiming          = TFDirector:getChildByPath(self.img_zhuangbeibeijing_bg, 'txt_zhuangbeiming')
    self.btn_equip                  = TFDirector:getChildByPath(self.img_zhuangbeibeijing_bg, 'btn_equip')       
    self.img_tianshu_icon           = TFDirector:getChildByPath(self.btn_equip, 'img_tianshu_icon')    
    self.panel_star                 = TFDirector:getChildByPath(self.img_zhuangbeibeijing_bg, 'panel_star') 
    self.txt_starlv                 = TFDirector:getChildByPath(self.panel_star, 'txt_starlv') 
    self.txt_qianghualv             = TFDirector:getChildByPath(self.img_zhuangbeibeijing_bg, 'txt_qianghualv')
    self.panel_shuxing              = TFDirector:getChildByPath(ui, 'panel_shuxing')
    self.panel_move                 = TFDirector:getChildByPath(self.panel_shuxing, 'panel_move')
    self.txt_zhanlizhi              = TFDirector:getChildByPath(ui, 'txt_zhanlizhi')
    local img_zhandouli              = TFDirector:getChildByPath(ui, 'img_zhandouli')
    -- img_zhandouli:setPositionX(img_zhandouli:getPositionX() - 30)
    self.img_zhandouli = img_zhandouli
    -- self.txt_zhanlizhi:setPositionX(self.txt_zhanlizhi:getPositionX() + 60)
    self.btn_xiexia                 = TFDirector:getChildByPath(ui, 'btn_xiexia')
    self.btn_yanxi                  = TFDirector:getChildByPath(ui, 'btn_yanxi')
    self.txt_attr = {}
    for i = 1, UINum do
        local txt_attr      = TFDirector:getChildByPath(self.panel_move, 'txt_attr'..i)
        txt_attr.txt_num    = TFDirector:getChildByPath(txt_attr, 'txt_attr'..i..'_num')
        txt_attr:setVisible(false)
        self.txt_attr[i]    = txt_attr
    end
end

function EquipUninstallXinFaLayer:refreshUI()
    self.cardRole = CardRoleManager:getRoleByGmid(self.roleGmId)
    if self.equipInfo == nil then 
        return
    end
    self.txt_zhuangbeiming:setText(self.equipInfo.config.name)
    self.btn_equip:setTextureNormal(GetColorIconByQuality(self.equipInfo.config.quality))
    XinFaManager:BindEffectOnEquip(self.btn_equip,self.equipInfo)
    self.img_tianshu_icon:setTexture(self.equipInfo.config:GetPath())
    if self.equipInfo.star == 0 then
        self.panel_star:setVisible(false)
    else
        self.panel_star:setVisible(true)
    end
    self.txt_starlv:setText(self.equipInfo.star)
    if self.equipInfo.level == 1 then
        self.txt_qianghualv:setVisible(false)
    else
        self.txt_qianghualv:setVisible(true)
    end
    self.txt_qianghualv:setText('+'..self.equipInfo.level)
    self:refreshAttr()

    self.txt_zhanlizhi:setText(GetPowerByAttribute(self.equipInfo:getTotalAttribute().attribute))
    if (string.len(self.txt_zhanlizhi:getText()) >= 6) then
        self.img_zhandouli:setPositionX(self.txt_zhanlizhi:getPositionX() - self.txt_zhanlizhi:getSize().width / 2 - 50)
    end
end

function EquipUninstallXinFaLayer:refreshAttr()
    local img_arrow = TFDirector:getChildByPath(self.img_zhuangbeibeijing_bg , 'img_jiantousheng');
    
    if (self.equipInfo ~= nil and  self.equipInfo.gmId == self.equipInfo.gmId) then
        img_arrow:setVisible(false);
    elseif self.equipInfo == nil or self.equipInfo:getpower() > self.equipInfo:getpower() then
        img_arrow:setVisible(true);
        img_arrow:setTexture("ui_new/roleequip/js_jts_icon.png");
    else
        img_arrow:setVisible(true);
        img_arrow:setTexture("ui_new/roleequip/js_jtx_icon.png");
    end
    local attribute = self.equipInfo:getTotalAttribute().attribute
    if # attribute <= 0 then
        return
    end
    for i = 1, UINum do
        self.txt_attr[i]:setVisible(false)
    end
    local count = 1
    for i,v in pairs(attribute) do
        if i < 6 then
            local txt_attr = self.txt_attr[count]
            txt_attr:setText(AttributeTypeStr[i])
            txt_attr:setPosition(ccp(40, 245 - 30 * (count - 1)))
            txt_attr.txt_num:setText('+'..v)
            txt_attr:setColor(ccc3(0,0,0))
            txt_attr:setVisible(true)
            count = count + 1
        elseif i == 32 or i == 33 then
            local txt_attr = self.txt_attr[count]
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
            local txt_attr = self.txt_attr[count]
            txt_attr:setText(localizable.AttributeTypeStr[i]..'+'..covertToPercentNotZero(v/10))
            txt_attr:setPosition(ccp(40, 245 - 30 * (count - 1)))
            txt_attr.txt_num:setText("")
            txt_attr:setColor(ccc3(189,74,48))
            txt_attr:setVisible(true)
            count = count + 1
        -- elseif i == 32 or i == 33 then
        --     local txt_attr = self.txt_attr[count]
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
            local txt_attr = self.txt_attr[count]
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

function EquipUninstallXinFaLayer.onXiexiaClickHandle(sender)
    local self = sender.logic
    TFAudio.playEffect("sound/effect/btn_drop.mp3", false)
    local item = XinFaManager:getXinFaByGmId(self.equipGmId).config

    TFDirector:dispatchGlobalEventWith("XinFaChangeBegin", {})
    XinFaManager:sendUnEquipHeartMethod(self.roleGmId, self.equipGmId)
end

function EquipUninstallXinFaLayer.onYanxiClickHandle(sender)
    local self = sender.logic
    XinFaManager:openXinFaMainLayer(self.equipGmId,XinFaManager.PlayPanelLayer)
end

function EquipUninstallXinFaLayer:removeUI()
    self.super.removeUI(self)
end

function EquipUninstallXinFaLayer:registerEvents(ui)
    self.super.registerEvents(self);
    
    self.btn_xiexia.logic = self
    self.btn_xiexia:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onXiexiaClickHandle),1)
    self.btn_yanxi.logic = self
    self.btn_yanxi:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onYanxiClickHandle),1)
end

function EquipUninstallXinFaLayer:removeEvents()
    self.super.removeEvents(self)
    self.isfirst = true
end

function EquipUninstallXinFaLayer:SetMove(node,index)
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

return EquipUninstallXinFaLayer