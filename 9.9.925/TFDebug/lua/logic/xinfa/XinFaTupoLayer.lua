--[[
 * @Description: 心法突破界面
 ]]
-- script writer fei
-- creation time 2017-10-20
local XinFaTuPoLayer = class("XinFaTuPoLayer", BaseLayer)

function XinFaTuPoLayer:ctor(gmId)
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.xinfa.XinFaTuPo")
    self.gmId = gmId
end

function XinFaTuPoLayer:initUI( ui )
    self.super.initUI(self, ui)
    self.img_fz = TFDirector:getChildByPath(ui, "img_fz")

    self.img_quality           = TFDirector:getChildByPath(self.img_fz, "img_quality")
    self.img_icon              = TFDirector:getChildByPath(self.img_fz, "img_icon")
    self.txt_intensify_lv      = TFDirector:getChildByPath(self.img_fz, "txt_intensify_lv")
    self.txt_name              = TFDirector:getChildByPath(self.img_fz, "txt_name")
    self.img_equiped           = TFDirector:getChildByPath(self.img_fz, "img_equiped")
    self.txt_equiped_name      = TFDirector:getChildByPath(self.img_fz, "txt_equiped_name")
    self.panel_star            = TFDirector:getChildByPath(ui, "img_star")
	self.txt_starlv            = TFDirector:getChildByPath(ui, "txt_starlv")
    self.panel_star1            = TFDirector:getChildByPath(self.img_quality, 'panel_star')

    self.panel_current         = TFDirector:getChildByPath(ui, "panel_current")
    self.panel_star_current    = TFDirector:getChildByPath(self.panel_current, "panel_star_current")
    self.img_star_left         = TFDirector:getChildByPath(self.panel_current, "img_star_4")
    self.txt_star_left         = TFDirector:getChildByPath(self.panel_current, "txt_star_lv")

    self.panel_new_val         = TFDirector:getChildByPath(ui, "panel_new_val")
    self.img_to                = TFDirector:getChildByPath(ui, "img_to_1")
    self.panel_star_new        = TFDirector:getChildByPath(self.panel_new_val, "panel_star_new")
    self.img_star_right        = TFDirector:getChildByPath(self.panel_new_val, "img_star_4")
    self.txt_star_right        = TFDirector:getChildByPath(self.panel_new_val, "txt_star_lv")

    self.power                 = TFDirector:getChildByPath(ui, "txt_power_details")
    self.btn_tupo              = TFDirector:getChildByPath(ui, "btn_tupo")
    self.btn_tupo.logic        = self 
    self.txt_numLv_effect    = TFDirector:getChildByPath(self.panel_new_val, 'txt_numLv_effect')
    self.txt_numLv_effect:setText('+'..1)
    self.txt_numLv_effect:setVisible(false)
    local img_zhandouli 		    = TFDirector:getChildByPath(ui, 'img_zhandouli')
    img_zhandouli:setPositionX(img_zhandouli:getPositionX() - 40)
    self.SxList = {}
    for i = 1,6 do
        self.SxList[i]={}
        local img_sx            = TFDirector:getChildByPath(ui, "img_sx"..i)
        img_sx.img_to           = TFDirector:getChildByPath(img_sx, "img_to")
        img_sx.txt_current_lv   = TFDirector:getChildByPath(img_sx, "txt_current_lv")
        img_sx.txt_next_lv      = TFDirector:getChildByPath(img_sx, "txt_next_lv")
        img_sx.txt_numLv_effect = TFDirector:getChildByPath(img_sx, 'txt_numLv_effect')
        img_sx.txt_numLv_effect:setVisible(false)
        img_sx.txt_current_lv:setText(0)
        img_sx.txt_next_lv:setText(0)
        img_sx.txt_name         = TFDirector:getChildByPath(img_sx, "txt_name")
        img_sx.logic =self
        self.SxList[i] = img_sx
    end 
    self.BtnTool = {}
    for i = 1,2 do 
        self.BtnTool[i]= {}
        local tool              = TFDirector:getChildByPath(ui, "btn_tool"..i) 
        tool.img_tool           = TFDirector:getChildByPath(ui, "img_tool"..i) 
        tool.txt_num1           = TFDirector:getChildByPath(ui, "txt_num"..i.."_1")   
        tool.txt_num2           = TFDirector:getChildByPath(ui, "txt_num"..i.."_2") 
        tool:setVisible(false)
        tool.logic = self
        self.BtnTool[i] = tool
    end
    self.txt_qhs                = TFDirector:getChildByPath(ui, 'txt_qhs')
    self.Panel_nextLevel        = TFDirector:getChildByPath(ui, "Panel_nextLevel") 
    self.img_tsxg               = TFDirector:getChildByPath(self.Panel_nextLevel, "img_tsxg")
    self.txt_next               = TFDirector:getChildByPath(self.Panel_nextLevel, "txt_next_1")
    self.txt_next2              = TFDirector:getChildByPath(self.Panel_nextLevel, "txt_next_2") --------------一次性用品
    self.imgeffect = {}
    for i = 1,2 do  
        self.imgeffect[i] = {}
        local img_effect_di              = TFDirector:getChildByPath(ui, "img_effect_di"..i)
        img_effect_di.txt_nextHurtDerate = TFDirector:getChildByPath(img_effect_di, "txt_nextHurtDerate")
        img_effect_di.logic = self
        img_effect_di:setVisible(false)
        self.imgeffect[i] = img_effect_di
    end
    self.Effect = false
    self.SpecialSx = false

    local ymj = TFImage:create()
    ymj:setTexture("ui_new/rolerisingstar/btn_lianti_h.png")
    self.btn_tupo:addChild(ymj)
    self.btn_tupo.ymj = ymj
    --self.onTuPo = false
end
function XinFaTuPoLayer:setXinFaData(data)
    self.gmId = data
    self.XinFainfo = XinFaManager:getXinFaByGmId(self.gmId)
    self:refreshUI()
end

function XinFaTuPoLayer:removeUI()
    self.super.removeUI(self)
end

function XinFaTuPoLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function XinFaTuPoLayer:refreshUI()
    if self.XinFainfo == nil then
        print('cannot find the card gmId = ',self.gmId)
        return
    end
    self.img_quality:setTexture(GetColorIconByQuality_118(self.XinFainfo.config.quality))
    XinFaManager:BindEffectOnEquip(self.img_quality,self.XinFainfo)
    self.img_icon:setTexture("icon/item/"..self.XinFainfo.config.display..".png")
    if self.XinFainfo.star == 0 then
        self.panel_star1:setVisible(false)
    else 
        self.panel_star1:setVisible(true)
        self.txt_starlv:setText(self.XinFainfo:getStar())
    end
    if self.XinFainfo.level == 1 then
        self.txt_intensify_lv:setVisible(false)
    else
        self.txt_intensify_lv:setVisible(true)
    end
    self.txt_intensify_lv:setText("+"..self.XinFainfo.level)
    self.txt_name:setText(self.XinFainfo.config.name)
    self.txt_star_left:setText(self.XinFainfo.star)
    self:refreshShuXingPanel()
    self:refreshCost(self.XinFainfo)
    if self.XinFainfo.equip then
        self.txt_equiped_name:setText(CardRoleManager:getRoleById(self.XinFainfo.equip).name)
        self.img_equiped:setVisible(true)
    else
        self.img_equiped:setVisible(false)
    end
    
    -- 等级未达到满级
    if self.XinFainfo.star < self.XinFainfo.Maxstar then
        self.btn_tupo.ymj:setVisible(false)
        self.btn_tupo:setGrayEnabled(false)
        self.btn_tupo:setTouchEnabled(true)
        self.img_star_right:setVisible(true)
        self.img_to:setVisible(true)
        self.txt_star_right:setVisible(true)
        self.txt_star_right:setText(self.XinFainfo.star + 1)
        self.txt_qhs:setVisible(true)
    else
        self.img_star_right:setVisible(false)
        self.txt_star_right:setVisible(false)
        self.img_to:setVisible(false)
        self.btn_tupo:setGrayEnabled(true)
        self.btn_tupo:setTouchEnabled(false)
        self.txt_qhs:setVisible(false)
        if self.XinFainfo.config.level > 0 then
            self.txt_next:setText(localizable.ShiXinTaiBuff1)
        end
        self.btn_tupo.ymj:setVisible(true)
        for i = 1,2 do 
            self.BtnTool[i]:setVisible(false)
        end 
        for i = 1,6 do
            self.SxList[i].img_to:setVisible(false)
            self.SxList[i].txt_next_lv:setVisible(false)
        end
    end

end
function XinFaTuPoLayer:registerEvents()
self.super.registerEvents(self)
    self.btn_tupo:addMEListener(TFWIDGET_CLICK, audioClickfun(self.TopoBtnClickHandle),1);

    self.updateShuxin = function(event)
        self.Effect = true
        self:setXinFaData(event.data[1].instanceId)
    end
    TFDirector:addMEGlobalListener(XinFaManager.XinfaTupoBreach, self.updateShuxin)
    
end

function XinFaTuPoLayer:refreshShuXingPanel()
    -- local arr  = KongfuTupoData:GetMulNumByQualityType(self.XinFainfo.config.quality,self.XinFainfo.config.usable,self.XinFainfo.star)
    -- local arr1  = KongfuTupoData:GetMulNumByQualityType(self.XinFainfo.config.quality,self.XinFainfo.config.usable,self.XinFainfo.star+1) 
    local attribute = self.XinFainfo:getTotalAttribute().attribute
    local attribute2 = self.XinFainfo:getDiffTotalAttribute(1, self.XinFainfo.star + 1)

    for i = 1,6 do
        if attribute[i] then
            self.SxList[i].txt_next_lv:setVisible(true)
            self.SxList[i].txt_name:setText(AttributeTypeStr[i]..":")
            self.SxList[i].txt_current_lv:setText("+"..math.floor(attribute[i]))
            if self.XinFainfo.star < self.XinFainfo.Maxstar then 
                self.SxList[i].txt_next_lv:setText("+"..math.floor(attribute2.attribute[i]))
                self.SxList[i].txt_numLv_effect:setText("+"..math.floor(attribute2.attribute[i]) - math.floor(attribute[i]))
            else
                --当等级超过书本等级时会出现负数
                attribute2 = self.XinFainfo:getDiffTotalAttribute(1, self.XinFainfo.star - 1)
                self.SxList[i].txt_next_lv:setText("+"..math.floor(attribute2.attribute[i]))
                self.SxList[i].txt_numLv_effect:setText("+".. math.floor(attribute[i]) - math.floor(attribute2.attribute[i]))
            end 
        else
            self.SxList[i].txt_name:setText(AttributeTypeStr[i]..":")
            self.SxList[i].txt_current_lv:setText(0)
            self.SxList[i].txt_next_lv:setText(0)
        end
        if i == 6 then 
            self.SxList[i]:setVisible(false)
        end
    end
    self.txt_next2:setText(stringUtils.format(localizable.Xinfa_XiuLian_Lv,20,self.XinFainfo.level,20))        ----一次性卡点修炼到达20
    
    local attr_active = nil
    local nextstar =0
    if self.XinFainfo.level < 20 then
        attr_active , nextstar = KongfuTupoData:GetTuPoAttrByQualityAndLv(self.XinFainfo.config.quality,1,self.XinFainfo.config.usable)
        self.SpecialSx = false
    else
        attr_active , nextstar = KongfuTupoData:GetTuPoAttrByQualityAndLv(self.XinFainfo.config.quality,self.XinFainfo.star,self.XinFainfo.config.usable)
        self.SpecialSx = true
    end

    self.txt_next:setText(stringUtils.format(localizable.Xinfa_TuPo_star,nextstar,self.XinFainfo.star,nextstar))
    local i = 1
    if attr_active ~= nil then 
        for k,v in pairs(attr_active) do    
            if k < 500 then 
                self.imgeffect[i].txt_nextHurtDerate:setText(AttributeTypeStr[k].."+"..(v/100).."%")
                self.imgeffect[i]:setVisible(true)
                i = i+1
            else
                self.imgeffect[i].txt_nextHurtDerate:setText(localizable.XinFaSpecialbuteTypeStr[k].."+"..(v/100).."%")
                self.imgeffect[i]:setVisible(true)
                i = i+1
            end
        end
    end 
    if self.Effect == true then 
        self:BreachXinFaeffect()
        self:TupoShuxingeffect()
        self.Effect = false
    end
    self.power:setText(self.XinFainfo:getTotalAttribute():getPower())
end



function XinFaTuPoLayer:BreachXinFaeffect()
    if self.XinfaEffect == nil then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/equip_star_lv_up_2.xml")
        local effect = TFArmature:create("equip_star_lv_up_2_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)

        local img_icon = self.img_fz
        effect:setPosition(ccp(150, 250))
        effect:setZOrder(100)
        img_icon:addChild(effect)
        self.XinfaEffect = effect
    end
    self.XinfaEffect:playByIndex(0, -1, -1, 0)

    self:UpLevelNumEffect(self.txt_numLv_effect)

    if not self.shuaguang_effect_lv then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
        local effect = TFArmature:create("equipIntensify_3_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)

        local img_intensify_lv = self.txt_name
        effect:setPosition(ccp(360, 150))
        img_intensify_lv:addChild(effect)
        self.shuaguang_effect_lv = effect
    end
    self.shuaguang_effect_lv:playByIndex(0, -1, -1, 0)

    self.shuaguang_effect = self.shuaguang_effect or {}
    for i = 1, #self.SxList do
        if not self.shuaguang_effect[i] then
            TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
            local effect = TFArmature:create("equipIntensify_3_anim")
            effect:setAnimationFps(GameConfig.ANIM_FPS)

            local img_intensify_lv = self.SxList[i]
            effect:setPosition(ccp(70, -60))
            img_intensify_lv:addChild(effect)
            self.shuaguang_effect[i] = effect
        end

        self:UpLevelNumEffect(self.SxList[i].txt_numLv_effect)
        self.shuaguang_effect[i]:playByIndex(0, -1, -1, 0)
    end

end
function XinFaTuPoLayer:TupoShuxingeffect()
    local bool = KongfuTupoData:GetWhetherTuPoAttrByQualityAndLv(self.XinFainfo.config.quality,self.XinFainfo.star,self.XinFainfo.config.usable)
   for i = 1,2 do 
        if self.SpecialSx == true and bool == true and self.imgeffect[i]:isVisible() == true then 
            TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
            local effect = TFArmature:create("equipIntensify_3_anim")
            effect:setAnimationFps(GameConfig.ANIM_FPS)
    
            effect:setPosition(ccp(0,-50))
            effect:setScaleX(0.5)
            self.imgeffect[i].effect = effect
            self.imgeffect[i]:addChild(effect,800)
            self.imgeffect[i].effect:playByIndex(0, -1, -1, 0)
        end
    end
end

function XinFaTuPoLayer.TopoBtnClickHandle(sender)
    local self = sender.logic 
    KongfuTupoId = KongfuTupoData:GetIdByQualityAndstar(self.XinFainfo.config.quality, self.XinFainfo.star,self.XinFainfo.config.usable)
    XinFaManager:sendHeartMethodBreach(KongfuTupoId,self.gmId)
end

function XinFaTuPoLayer:removeEvents()
    self.super.removeEvents(self)
    TFDirector:removeMEGlobalListener(XinFaManager.XinfaTupoBreach, self.updateShuxin)
    self.updateShuxin = nil
end

function XinFaTuPoLayer:refreshCost(itemdata)
    local costList = KongfuTupoData:GetCostByQualityAndLv(itemdata.config.quality,self.XinFainfo.star + 1,itemdata.config.usable)
   -- self.onTuPo = true
    for i,data in ipairs(costList) do
        if (data and data ~= "") then
            local info          = string.split(data, "_")
            local itemTypeId    = tonumber(info[1])
            local itemId        = tonumber(info[2])
            local itemNum       = tonumber(info[3])
            local btn           = self.BtnTool[i]
            if (btn) then
                btn:setVisible(true)
                btn.itemId          = itemId
                btn.itemTypeId      = itemTypeId
                btn:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowItemClickHandle),1)
                if itemTypeId == EnumDropType.GOODS then 
                    local item = ItemData:objectByID(itemId)
                    if (item) then
                        local iconStr = item:GetPath()
                        btn.img_tool:setTexture(iconStr)
                        btn:setTextureNormal(GetColorIconByQuality(item.quality))
                    end
                    btn.txt_num2:setText(itemNum)
                    local num = XinFaManager:getIdenticalXinFaStuffNum(itemId,itemdata.instanceId)
                    btn.txt_num1:setText(num.."/") 
                    -- if (num < itemNum) then
                    --     self.onTuPo = false
                    -- end
                elseif itemTypeId == EnumDropType.ZHUXIN then
                    btn.img_tool:setTexture(GetZhuXinCoinIcon())
                    btn:setTextureNormal(GetColorIconByQuality(4))
                    btn.txt_num2:setText(itemNum)
                    local num =MainPlayer:getResValueByType(EnumDropType.ZHUXIN)
                    btn.txt_num1:setText(num.."/")
                    -- if (num < itemNum) then
                    --     self.onTuPo = false
                    -- end
                elseif itemTypeId == EnumDropType.COIN then
                    btn.img_tool:setTexture(GetCoinIcon())
                    btn:setTextureNormal(GetColorIconByQuality(4))
                    btn.txt_num2:setText(itemNum)
                    local num =MainPlayer:getResValueByType(EnumDropType.COIN)
                    btn.txt_num1:setText(num.."/")
                    -- if (num < itemNum) then
                    --     self.onTuPo = false
                    -- end  
                end
            end
        end
    end
end

function XinFaTuPoLayer:UpLevelNumEffect(widget )
    TFDirector:killAllTween(widget)
    widget:setVisible(true)
    widget:setScale(0.1)
    local tween = {
        target = widget,
            {
                duration = 0.1,
                scale = 1,
            },
            {
                duration = 0.1,
                scale = 0.8,
            },
            {
                duration = 0.1,
                scale = 1,
            },
            {
                duration = 0,
                delay = 1,
                onComplete = function ()
                    widget:setVisible(false)

                end,
            },
    }
    TFDirector:toTween(tween)

end

function XinFaTuPoLayer.onShowItemClickHandle(sender)
    local self = sender.logic;
    if sender.itemId == nil then
        Public:ShowItemTipLayer(nil, sender.itemTypeId)
    else
        Public:ShowItemTipLayer(sender.itemId, sender.itemTypeId, XinFaManager:getIdenticalXinFaStuffNum(sender.itemId,self.gmId))
    end
end
return XinFaTuPoLayer