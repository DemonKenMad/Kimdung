-- client side XinFaMainLayer.lua
--[[
 * @Description: 心法信息预览
 ]]
-- script writer Happy.All
-- creation time 2016-08-01


local XinFaMainLayer = class("XinFaMainLayer", BaseLayer);

function XinFaMainLayer:ctor(data,type)
    self.super.ctor(self,data);
    self.gmId = data
    self.type = type
    self.XinFainfo = XinFaManager:getXinFaByGmId(self.gmId)
    self:init("lua.uiconfig_mango_new.xinfa.XinFaMain");
end

function XinFaMainLayer:initUI(ui,layer)
    self.super.initUI(self,ui);

    self.logic              = layer
    
    self.btn_close          = TFDirector:getChildByPath(ui, 'btn_close')
    self.btn_help           = TFDirector:getChildByPath(ui, 'btn_help')
    self.btn_tupo           = TFDirector:getChildByPath(ui, 'btn_tupo')
    self.btn_xiuliang       = TFDirector:getChildByPath(ui, 'btn_tuiyan')
    self.btn_ninglian       = TFDirector:getChildByPath(ui, 'btn_ninglian')
    self.btn_mingxin        = TFDirector:getChildByPath(ui, 'btn_mingxin')
    self.img_icon           = TFDirector:getChildByPath(ui, 'img_icon')
    self.img_quality        = TFDirector:getChildByPath(ui, "img_quality")
    self.txt_name           = TFDirector:getChildByPath(ui, 'txt_name')
    self.panel_star         = TFDirector:getChildByPath(ui, 'panel_star')
    self.txt_starlv         = TFDirector:getChildByPath(ui, 'txt_starlv')
    self.txt_intensify_lv   = TFDirector:getChildByPath(ui, 'txt_intensify_lv')
    self.img_equiped        = TFDirector:getChildByPath(ui, 'img_equiped')
    self.txt_equiped_name   = TFDirector:getChildByPath(ui, 'txt_equiped_name')
    self.bar_soul           = TFDirector:getChildByPath(ui, 'bar_soul');
    self.txt_tips           = TFDirector:getChildByPath(ui, 'txt_tips');
    
    local panel_sx          = TFDirector:getChildByPath(ui, 'panel_sx')
    self.total_attr         = {}
    for i = 1, 12 do
        local attr      = TFDirector:getChildByPath(panel_sx, 'img_attr'..i)
        attr.txt_name   = TFDirector:getChildByPath(attr, 'txt_name')
        attr.img_point  = TFDirector:getChildByPath(attr, 'img_point')
        attr.txt_base   = TFDirector:getChildByPath(attr, 'txt_base')
        attr.txt_add    = TFDirector:getChildByPath(attr, 'txt_add')
        self.total_attr[i] = attr
        self.total_attr[i]:setVisible(false)
    end
    self.panel_bs = {}
    for i = 1, 5 do
        local panel_bs      = TFDirector:getChildByPath(ui, 'panel_bs'..i)
        panel_bs.btn_icon   = TFDirector:getChildByPath(panel_bs, 'btn_icon')
        panel_bs.img_jiahao = TFDirector:getChildByPath(panel_bs, 'img_icon1')
        panel_bs.img_icon   = TFDirector:getChildByPath(panel_bs, 'img_icon')
        panel_bs.img_suo    = TFDirector:getChildByPath(panel_bs, 'img_suo')
        panel_bs:setVisible(XinFaManager:IsNingLianOpen(self.gmId))
        panel_bs.txt_level  = TFDirector:getChildByPath(panel_bs, 'txt_level')
        self.panel_bs[i] = panel_bs
    end
    self.btn_ninglian:setVisible(XinFaManager:IsNingLianOpen(self.gmId))
    self.btn_mingxin:setVisible(XinFaManager:IsMingXinOpen(self.gmId))
    
    self.panel_book             = TFDirector:getChildByPath(ui, 'panel_book')
    self.panel_book.img_quality = TFDirector:getChildByPath(self.panel_book, 'img_quality')     
    self.panel_book.img_equip   = TFDirector:getChildByPath(self.panel_book, 'img_equip') 
    self.panel_info             = TFDirector:getChildByPath(ui, 'panel_info')
    self.img_quality            = TFDirector:getChildByPath(self.panel_info, 'img_quality')
    self.img_icon               = TFDirector:getChildByPath(self.panel_info, 'img_icon')
    self.txt_tsjc               = TFDirector:getChildByPath(ui, 'txt_tsjc')
    self.panel_book.txt_soul    = TFDirector:getChildByPath(ui, 'txt_soul')
    self.panel_book.txt_soul_num = TFDirector:getChildByPath(ui, 'txt_soul_num')
    self.starImg = TFDirector:getChildByPath(ui, 'img_stardi1')
    self.starImg:setVisible(false)
    self.txt_star_lv = TFDirector:getChildByPath(ui, 'txt_star_lv')
    self.txt_star_lv:setVisible(false)
   
    self.btn_chushou = TFDirector:getChildByPath(ui, 'btn_sale')
    self.btn_chushou.logic = self
    self.btn_zhihuan = TFDirector:getChildByPath(ui, 'btn_zhihuan')
    self.btn_zhihuan.logic = self

    --self.deduceOpenLevel = tonumber(ConstantData:objectByID("DeduceFunctionOpen").value) or 0 -----------心法推演开放
    self.BtnTopoeffect = true
end

function XinFaMainLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function XinFaMainLayer:refreshUI()
    --心法基本信息
    if self.XinFainfo == nil then
        print('cannot find the card gmId = ',self.gmId)
        return
    end
    self.img_quality:setTexture(GetColorIconByQuality_118(self.XinFainfo.config.quality))
    XinFaManager:BindEffectOnEquip(self.img_quality,self.XinFainfo)
    --self.panel_book.img_equip(self.XinFainfo.config:GetPath())
    self.panel_book.img_quality:setTextureNormal(GetColorIconByQuality(self.XinFainfo.config.quality))

    --心法置换开关
    local xinfazhihuanVisible =  MainPlayer:getServerSwitchStatue(ServerSwitchType.XinFaZhihuan)

    if self.XinFainfo.config.quality <= 3 or xinfazhihuanVisible == false then
        self.btn_zhihuan:setVisible(false)
    else
        self.btn_zhihuan:setVisible(true)
    end

    if self.XinFainfo.star == 0 then
        self.panel_star:setVisible(false)
    else 
        self.panel_star:setVisible(true)
        self.txt_starlv:setText(self.XinFainfo:getStar())
    end
    self.txt_name:setText(self.XinFainfo.config.name)
    local KongfuData = KongfuComData:objectByKongfuId(self.XinFainfo.itemId)
    self.img_quality:setTexture(GetColorIconByQuality(self.XinFainfo.config.quality))
    self.img_icon:setTexture(self.XinFainfo.config:GetPath())
    local str = ""
    for i,v in pairs(self.XinFainfo:getTotalAttribute().attribute) do
        if i >= 500 then
            str = str..localizable.XinFaSpecialbuteTypeStr[i].."+"..(v/100).."%".."\n"
        elseif (i > 15 and i < 18) or (i > 30 and i < 34) then
            str = str..AttributeTypeStr[i].."+"..(v/100).."%".."\n"
        end
    end
    if str ~= "" then
        self.txt_tips:setVisible(false)
    else
        self.txt_tips:setVisible(true)
    end 
    self.txt_tsjc:setText(str)
    self.img_icon:setTexture("icon/item/"..self.XinFainfo.config.display..".png")   
    if self.XinFainfo.level == 1 then
        self.txt_intensify_lv:setVisible(false)
    else
        self.txt_intensify_lv:setVisible(true)
    end
    if self.XinFainfo.equip then
        self.txt_equiped_name:setText(CardRoleManager:getRoleById(self.XinFainfo.equip).name)
        self.img_equiped:setVisible(true)
    else
        self.img_equiped:setVisible(false)
    end

    for i = 1, 5 do
        local holeLevel = self.XinFainfo:getGemPosLevel(i)
        if i ~= 1 then
            if self.XinFainfo:IsGemPosOpen(i) then
                self.panel_bs[i].img_suo:setVisible(false)
            else
                self.panel_bs[i].img_suo:setVisible(true)
            end
        end 
        self.panel_bs[i].img_jiahao:setVisible(false)
        if self.XinFainfo:IsGemPosOpen(i) then
            if self.XinFainfo:getGemPos(i) == nil or self.XinFainfo:getGemPos(i) == 0 then
                self.panel_bs[i].img_jiahao:setVisible(true)
            end
        end
        if self.XinFainfo:getGemPos(i) ~= 0 and self.XinFainfo:getGemPos(i) ~= nil then
            self.panel_bs[i].img_icon:setTexture("icon/item/"..self.XinFainfo:getGemPos(i)..".png")
            self.panel_bs[i].img_icon:setVisible(true)
        else
            self.panel_bs[i].img_icon:setVisible(false)
        end
        if holeLevel == 0 then
            self.panel_bs[i].txt_level:setVisible(false)
        else
            self.panel_bs[i].txt_level:setVisible(true)
        end
        self.panel_bs[i].txt_level:setText(stringUtils.format(localizable.common_LV, holeLevel))
    end

    self.txt_intensify_lv:setText('+'..self.XinFainfo.level)
    self:refreshCost()
    self:refreshShuXingPanel()
    self:refreshBtnEffect(self.BtnTopoeffect)
end

function XinFaMainLayer:refreshShuXingPanel()
    local count = 0
    -- print(self.XinFainfo:getXiuLianAttribute().attribute)
    -- print(self.XinFainfo:getTupoAttribute().attribute)
    -- print(self.XinFainfo:getTotalAttribute().attribute)
    for attrId,attrValue in pairs(self.XinFainfo:getTotalAttribute().attribute) do
        -- print(attrId,attrValue)
        if attrId < 18 then 
            count = count + 1
            local attr = self.total_attr[count]
            if (attr) then
                attr.txt_name:setText(AttributeTypeStr[attrId])
                attr.txt_base:setText("+"..covertToDisplayValue(attrId, attrValue, true))
                attr:setVisible(true)      
            else
                print("*ERROR*********XinFaMainLayer:refreshShuXingPanel***************attrId*",attrId, " attrValue ",attrValue)
            end
        elseif attrId == 32 or attrId == 33 then
            count = count + 1
            local attr = self.total_attr[count]
            if (attr) then
                attr.txt_name:setText(localizable.shortAttributeTypeStr[attrId])
                attr.txt_base:setText("+"..covertToDisplayValue(attrId, attrValue, true))
                attr:setVisible(true)      
            else
                print("*ERROR*********XinFaMainLayer:refreshShuXingPanel***************attrId*",attrId, " attrValue ",attrValue)
            end
        end
    end 

end

function XinFaMainLayer:refreshCost()
    local costList = KongfuTupoData:GetCostByQualityAndLv(self.XinFainfo.config.quality,self.XinFainfo.star + 1,self.XinFainfo.config.usable)
    if costList[2] == nil then
        self.panel_book.txt_soul_num:setText("")
        self.panel_book.txt_soul:setText(localizable.Tianshu_chongzhi_tips8)
        self.panel_book.img_quality.itemId          = self.XinFainfo.config.id
        self.panel_book.img_quality.itemTypeId      = self.XinFainfo.config.type
        self.panel_book.img_quality.logic = self
        self.panel_book.img_quality:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowItemClickHandle),1)
        local iconStr = self.XinFainfo.config:GetPath()
        self.panel_book.img_equip:setTexture(iconStr)
        self.panel_book.img_quality:setTextureNormal(GetColorIconByQuality(self.XinFainfo.config.quality))
        return
    end
    self.BtnTopoeffect = true
    if (costList[2] and costList[2] ~= "") then
        local info          = string.split(costList[2], "_")
        local itemTypeId    = tonumber(info[1])
        local itemId        = tonumber(info[2])
        local itemNum       = tonumber(info[3])
        local btn           = self.panel_book      
        if (btn) then
            btn:setVisible(true)
            btn.img_quality.itemId          = itemId
            btn.img_quality.itemTypeId      = itemTypeId
            btn.img_quality.logic = self
            btn.img_quality:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowItemClickHandle),1)
            if itemTypeId == EnumDropType.GOODS then 
                local item = ItemData:objectByID(itemId)
                if (item) then
                    local iconStr = item:GetPath()
                    btn.img_equip:setTexture(iconStr)
                    btn.img_quality:setTextureNormal(GetColorIconByQuality(item.quality))
                end
                local num = XinFaManager:getIdenticalXinFaStuffNum(itemId,self.gmId)
                btn.txt_soul_num:setText(num.."/"..itemNum)  
                self.bar_soul:setPercent((num/itemNum)*100);
                if num <= itemNum then 
                    self.BtnTopoeffect = false
                end
            elseif itemTypeId == EnumDropType.ZHUXIN then   
                local num =MainPlayer:getResValueByType(EnumDropType.ZHUXIN)
                if num <= itemNum then 
                    self.BtnTopoeffect = false
                end
            end
        end
    end
    if (costList[1] and costList[1] ~= "") then
    local info          = string.split(costList[1], "_")
    local itemTypeId    = tonumber(info[1])
    local itemId        = tonumber(info[2])
    local itemNum       = tonumber(info[3])
        if itemTypeId == EnumDropType.ZHUXIN then   
            local num =MainPlayer:getResValueByType(EnumDropType.ZHUXIN)
            if num <= itemNum then 
                self.BtnTopoeffect = false
            end
        end
    end
end
function XinFaMainLayer:refreshBtnEffect(bool)
     if bool == true  and self.XinFainfo.star<self.XinFainfo.Maxstar then
        if self.btn_tupo.effect then
            self.btn_tupo.effect:removeFromParent()
            self.btn_tupo.effect = nil
        end

        TFResourceHelper:instance():addArmatureFromJsonFile("effect/btn_common_small.xml")
        local effect = TFArmature:create("btn_common_small_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        self.btn_tupo:addChild(effect, 100)
        self.btn_tupo.effect = effect
    else
        if self.btn_tupo.effect then
            self.btn_tupo.effect:removeFromParent()
            self.btn_tupo.effect = nil
        end
    end
end

function XinFaMainLayer.onShowItemClickHandle(sender)
    local self = sender.logic;
    -- print("sadfjsadfdsafsdafsad",XinFaManager:getIdenticalXinFaStuffNum(sender.itemId,self.gmId))
    Public:ShowItemTipLayer(sender.itemId, sender.itemTypeId,XinFaManager:getIdenticalXinFaStuffNum(sender.itemId,self.gmId))
end

function XinFaMainLayer:removeUI()
    self.super.removeUI(self);
end

--注册事件
function XinFaMainLayer:registerEvents()
    self.super.registerEvents(self);

    ADD_ALERT_CLOSE_LISTENER(self,self.btn_close);

  
    self.btn_tupo:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onOperationTuPoClickHandle),1)
    self.btn_tupo.logic = self


    self.btn_xiuliang:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onOperationClickHandle),1)
    self.btn_xiuliang.logic = self

    self.btn_ninglian:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onNingLianClickHandle),1)
    self.btn_ninglian.logic = self
    self.btn_mingxin:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMingXinClickHandle),1)
    self.btn_mingxin.logic = self
    for i = 1, 5 do
        self.panel_bs[i].btn_icon:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onXiangQianClickHandle),1)
        self.panel_bs[i].btn_icon.logic = self
    end

    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onHelpClickHandle),1)
    self.btn_help.logic = self

    self.btn_chushou:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onChuShouClickHandle),1)
    self.btn_zhihuan:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onZhiHuanClickHandle),1)

    self.xinfaSell = function ()
        AlertManager:close();
    end
    TFDirector:addMEGlobalListener(XinFaManager.XinFaSell, self.xinfaSell)
    
    self.ServerSwitchChange = function()
        for i = 1, 5 do
            self.panel_bs[i]:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.XinFaNingLian))
        end
        self.btn_ninglian:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.XinFaNingLian))
    end
  
    TFDirector:addMEGlobalListener(XinFaManager.ServerSwitchChange, self.ServerSwitchChange)

    self.smritiCallBack = function()
        self.XinFainfo = XinFaManager:getXinFaByGmId(self.gmId)
    end
    TFDirector:addMEGlobalListener(XinFaManager.RESPONSE_HEART_EXCHANGE, self.smritiCallBack)
end

function XinFaMainLayer:removeEvents()
    self.super.removeEvents(self)
    TFDirector:removeMEGlobalListener(XinFaManager.XinFaSell, self.xinfaSell)
    self.xinfaSell = nil
    TFDirector:removeMEGlobalListener(XinFaManager.ServerSwitchChange, self.ServerSwitchChange)
    self.ServerSwitchChange = nil
    TFDirector:addMEGlobalListener(XinFaManager.RESPONSE_HEART_EXCHANGE, self.smritiCallBack)
    self.smritiCallBack =nil
end

function XinFaMainLayer.onOperationClickHandle( btn )
    local self = btn.logic
    XinFaManager:openEquipOperationLayer(self.gmId, XinFaManager.select_type_xiulian,self.type)
end

function XinFaMainLayer.onNingLianClickHandle( btn )
    local self = btn.logic
    XinFaManager:openEquipOperationLayer(self.gmId, XinFaManager.select_type_ninglian,self.type)
end
function XinFaMainLayer.onMingXinClickHandle(btn)
    local self = btn.logic
    XinFaManager:openEquipOperationLayer(self.gmId, XinFaManager.select_type_mingxin,self.type)
end

function XinFaMainLayer.onXiangQianClickHandle( btn )
    local self = btn.logic
    XinFaManager:openEquipOperationLayer(self.gmId, XinFaManager.select_type_xiangqian,self.type)
end

function XinFaMainLayer.onOperationTuPoClickHandle( btn )
    local self = btn.logic
    XinFaManager:openEquipOperationLayer(self.gmId, XinFaManager.select_type_tupo,self.type)
end

function XinFaMainLayer.onHelpClickHandle( btn )
    CommonManager:showRuleLyaer("kongfumethod")
end

function XinFaMainLayer.onChuShouClickHandle( sender )
    local self = sender.logic
    XinFaManager:getXinFaSellList(self.XinFainfo)
end
function XinFaMainLayer.onZhiHuanClickHandle( sender )
    local self = sender.logic
    XinFaManager:openXinFaZhiHuanLayer(self.gmId)
end

return XinFaMainLayer
