--[[
 * @Description: 心法明心界面
 ]]
-- creation time 2018-02-08
local XinFaMingXinLayer = class("XinFaMingXinLayer", BaseLayer)

XinFaMingXinLayer.Quality_Name = 
{
    localizable.Xinfa_Chongzhu_Quality_Name_1,
    localizable.Xinfa_Chongzhu_Quality_Name_2,
    localizable.Xinfa_Chongzhu_Quality_Name_3,
    localizable.Xinfa_Chongzhu_Quality_Name_4,
    localizable.Xinfa_Chongzhu_Quality_Name_5,
    localizable.Xinfa_Chongzhu_Quality_Name_6,
}

function XinFaMingXinLayer:ctor(gmId)
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.xinfa.XinFaMingXin")
    self.gmId = gmId
end

function XinFaMingXinLayer:initUI( ui )
    self.super.initUI(self, ui)
    self.img_fz = TFDirector:getChildByPath(ui, "img_fz")
    self.btn_help           = TFDirector:getChildByPath(ui, 'btn_help')
    self.img_quality           = TFDirector:getChildByPath(self.img_fz, "img_quality")
    self.img_icon              = TFDirector:getChildByPath(self.img_fz, "img_icon")
    self.txt_intensify_lv      = TFDirector:getChildByPath(self.img_fz, "txt_intensify_lv")
    self.txt_name              = TFDirector:getChildByPath(self.img_fz, "txt_name")
    self.img_equiped           = TFDirector:getChildByPath(self.img_fz, "img_equiped")
    self.txt_equiped_name      = TFDirector:getChildByPath(self.img_fz, "txt_equiped_name")
    self.panel_star            = TFDirector:getChildByPath(ui, "img_star")
    self.txt_starlv            = TFDirector:getChildByPath(ui, "txt_starlv")
    self.panel_star1           = TFDirector:getChildByPath(self.img_quality, 'panel_star')
    self.btn_left              = TFDirector:getChildByPath(ui, 'btn_left')
    self.btn_right             = TFDirector:getChildByPath(ui, 'btn_right')
    self.btn_left:setVisible(false)
    self.btn_right:setVisible(false)
    self.btn_mingxin              = TFDirector:getChildByPath(ui, 'btn_tupo')
    self.btn_mingxin.logic        = self 
    self.panel_kong = {}
    for i = 1,5 do
        local kong      = TFDirector:getChildByPath(ui, "panel_kong"..i)
        kong.btn_icon   = TFDirector:getChildByPath(kong, "btn_icon")
        kong.img_di     = TFDirector:getChildByPath(kong, "img_di")
        kong.txt_level  = TFDirector:getChildByPath(kong.img_di, "txt_level")
        kong.txt_Info   = TFDirector:getChildByPath(kong.img_di, "txt_Info")
        kong.btn_icon.index      = i 
        kong.img_di:setVisible(false)
        kong.btn_icon.logic = self
        self.panel_kong[i] = kong
    end
    self.img_jbsx = TFDirector:getChildByPath(ui, 'img_jbsx')
    self.Node_Attri = {}
    --基础属性
    for i=1,5 do
        self.Node_Attri[i] = {}
        self.Node_Attri[i].txt_name = TFDirector:getChildByPath(self.img_jbsx, 'txt_current_lv'..i)
    end
    --额外属性
    self.img_ewsx = TFDirector:getChildByPath(ui, 'img_ewsx')
    self.Node_Extra_Attri = {}
    for i=1,3 do
        self.Node_Extra_Attri[i] = {}
        self.Node_Extra_Attri[i].txt_name = TFDirector:getChildByPath(self.img_ewsx, 'txt_current_lv'..i)
        self.Node_Extra_Attri[i].num = 0
        self.Node_Extra_Attri[i].effet = false
    end
    self.img_qsx =  TFDirector:getChildByPath(ui, 'img_qsx')
    self.img_qsx.txt_name = TFDirector:getChildByPath(self.img_qsx, 'txt_current_lv1')
    self.img_qsx.num = 0
    self.img_qsx.effect = false
    self.btn_tool = {}

    for i = 1, 2 do
        self.btn_tool[i] = TFDirector:getChildByPath(ui, 'btn_tool'..i)
        self.btn_tool[i].img_tool = TFDirector:getChildByPath(self.btn_tool[i], 'img_tool'..i)
        self.btn_tool[i].txt_num1_1 = TFDirector:getChildByPath(self.btn_tool[i], 'txt_num'..i..'_1')
        self.btn_tool[i].txt_num1_2 = TFDirector:getChildByPath(self.btn_tool[i], 'txt_num'..i..'_2')
        self.btn_tool[i]:setVisible(false)
    end

    self.index = 1

end
function XinFaMingXinLayer:setXinFaData(data)
    self.gmId = data
    self.XinFainfo = XinFaManager:getXinFaByGmId(self.gmId)
    self:refreshUI()
end

function XinFaMingXinLayer:removeUI()
    self.super.removeUI(self)
end
function XinFaMingXinLayer:removeEvents()
    self.super.removeEvents(self)

    TFDirector:removeMEGlobalListener(XinFaManager.HEART_METHOD_CHANGE ,self.XinfaUpdata)
    self.XinfaUpdata = nil 
end

function XinFaMingXinLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function XinFaMingXinLayer:refreshUI()
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
    if self.XinFainfo.equip then
        self.txt_equiped_name:setText(CardRoleManager:getRoleById(self.XinFainfo.equip).name)
        self.img_equiped:setVisible(true)
    else
        self.img_equiped:setVisible(false)
    end 
    self:refreshHoleText(self.index)
    self:showChongzhuAttri()
    self:brushPointInfo()
end
function XinFaMingXinLayer:registerEvents()
    self.super.registerEvents(self)
    for i=1,5 do
        self.panel_kong[i].btn_icon:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onHoleClickHandle),1)
    end
    self.btn_mingxin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.MingxinBtnClickHandle),1);

    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onHelpClickHandle),1)
    self.btn_help.logic = self

    self.XinfaUpdata = function()
        self.XinFainfo = XinFaManager:getXinFaByGmId(self.gmId)
        self:refreshUI()
        self:BreachXinFaeffect()
        self:brushPointInfo()
    end
    TFDirector:addMEGlobalListener(XinFaManager.HEART_METHOD_CHANGE ,self.XinfaUpdata)
    
end
function XinFaMingXinLayer.MingxinBtnClickHandle(sender)
    local self = sender.logic 
    XinFaManager:sendRequestHeArtRecast(self.gmId,self.index)

end
function XinFaMingXinLayer.onHoleClickHandle(sender)
    local self = sender.logic
    self.index = sender.index
    self:refreshHoleText(self.index)
end
function XinFaMingXinLayer:refreshHoleText(idx)
    for i = 1,5 do
        self.panel_kong[i].img_di:setVisible(false)
    end
    self.panel_kong[idx].img_di:setVisible(true)
    self:showConsume(idx)
end

function XinFaMingXinLayer:showConsume(index)
    local pointData = self.XinFainfo:getChongzhuDataByIdx(index)
    if pointData then
        local level = pointData.level + 1
        if level > XinFaManager.MianXinMaxLevel then 
            level = XinFaManager.MianXinMaxLevel
        end
        local quality = self.XinFainfo.config.quality
        local templateItem = KongfuRefineData:getItem(self.XinFainfo.config.quality, index, level)
        local consumeList = templateItem:getConsume()
        for i= 1,2 do
            if consumeList[i] then
                local item = ItemData:objectByID(consumeList[i].id)
                local num = BagManager:getItemNumById(consumeList[i].id)
                self.btn_tool[i].img_tool:setTexture(item:GetPath())
                self.btn_tool[i]:setTextureNormal(GetColorIconByQuality(item.quality))
                self.btn_tool[i].txt_num1_1:setText(num.."/")
                self.btn_tool[i].txt_num1_2:setText(consumeList[i].num)
                self.btn_tool[i].itemId          = consumeList[i].id
                self.btn_tool[i].itemTypeId      = consumeList[i].type
                self.btn_tool[i]:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowItemClickHandle),1)
                self.btn_tool[i]:setVisible(true)
            else
                self.btn_tool[i]:setVisible(false)
            end
        end
    end
    if self.XinFainfo.chongzhuData[self.index].level > XinFaManager.MianXinMaxLevel then
        self.btn_mingxin:setGrayEnabled(true)
        self.btn_mingxin:setTouchEnabled(false)
    else
        self.btn_mingxin:setGrayEnabled(false)
        self.btn_mingxin:setTouchEnabled(true)
    end 

end

function XinFaMingXinLayer:showChongzhuAttri()
    local attrTab = {}
    for k, v in pairs(self.XinFainfo.chongzhuData) do
        local tab = KongfuRefineData:getTotalBaseAttribute(self.XinFainfo.config.quality, v.pos, v.level) or {}
        for i, j in pairs(tab) do
            attrTab[i] = attrTab[i] or 0
            attrTab[i] = attrTab[i] + j
        end
    end

    for i = 1, 5 do
        local num = attrTab[i] or 0
        self.Node_Attri[i].txt_name:setText(AttributeTypeStr[i].."    +" .. num)
        local quality = self.XinFainfo.chongzhuData[i].quality or 0
        if quality <= 0 then 
            quality = 1
        end
        self.panel_kong[i].txt_level:setText(self.Quality_Name[quality].." Lv"..self.XinFainfo.chongzhuData[i].level)
        self.panel_kong[i].txt_Info:setText(AttributeTypeStr[i].."+"..num)
    end

    local Mainnum = KongfuRefineExtraData:getExtraMainAttribute(self.XinFainfo.config.id)
    self.Node_Extra_Attri[1].txt_name:setText(AttributeTypeStr[Mainnum-17].."    +0%")
    local Specialnum = KongfuRefineExtraData:getExtraSpecialAttribute(self.XinFainfo.config.id)
    self.Node_Extra_Attri[3].txt_name:setText(localizable.XinFaSpecialbuteTypeStr[Specialnum].."  +0%")

    --后期打补丁 多了一个属性
    if self.newAddAttr == nil then
        self.newAddAttr = {}
    end
    for _,v in pairs(self.newAddAttr) do
        v:setVisible(false)
    end
    local newAddCount = 0
    for k,v in pairs(self.XinFainfo.MingXinSpecialandMain) do
        if k > 17 and k < 23 then
            local newNode = self.Node_Extra_Attri[1].txt_name:clone()
            self.Node_Extra_Attri[1].txt_name:getParent():addChild(newNode)
            newNode:setText(AttributeTypeStr[k-17].."  +".. v/100 .."%")
            table.insert(self.newAddAttr, newNode)
            if newAddCount == 0 then
                self.Node_Extra_Attri[1].txt_name:setVisible(false)
                newNode:setPosition(self.Node_Extra_Attri[1].txt_name:getPosition())
            else
                local lastNode = self.newAddAttr[newAddCount]
                local pos = self.Node_Extra_Attri[1].txt_name:getPosition()
                if lastNode then
                    pos.x = lastNode:getPositionX()+lastNode:getSize().width+20
                end
                newNode:setPosition(pos)
            end
            newNode:setVisible(true)
            newAddCount = newAddCount + 1

            -- self.Node_Extra_Attri[1].txt_name:setText(AttributeTypeStr[k-17].."    +".. v/100 .."%")
            -- if v ~= self.Node_Extra_Attri[1].num then
            --     self.Node_Extra_Attri[1].num = v
            --     self.Node_Extra_Attri[1].effect = true
            -- end
        end
        if k > 500 then
            self.Node_Extra_Attri[3].txt_name:setText(localizable.XinFaSpecialbuteTypeStr[k].."  +"..v/100 .."%")
            if v ~= self.Node_Extra_Attri[3].num then
                self.Node_Extra_Attri[3].num = v
                self.Node_Extra_Attri[3].effect = true
            end
        end

    end
    local per = self.XinFainfo.GemAddPercent
    self.Node_Extra_Attri[2].txt_name:setText(localizable.XinfaMingxin_extra_attribute2.."  +".. per/100 .. "%")
    if self.XinFainfo.GemAddPercent ~= self.Node_Extra_Attri[2].num then
        self.Node_Extra_Attri[2].num = self.XinFainfo.GemAddPercent
        self.Node_Extra_Attri[2].effect = true
    end 
    per = self.XinFainfo.MingXinPercent + self.XinFainfo.MingXinExtraPercent
    self.img_qsx.txt_name:setText(localizable.Tianshu_Extra_Name1.."  +".. per/100 .."%")
    if self.XinFainfo.MingXinPercent ~= self.img_qsx.num then
        self.img_qsx.num = self.XinFainfo.MingXinPercent
        self.img_qsx.effect = true
    end
end
function XinFaMingXinLayer:BreachXinFaeffect()
    self.shuaguang_effect = self.shuaguang_effect or {}
    for i = 1, #self.Node_Attri do
        if not self.shuaguang_effect[i] then
            TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
            local effect = TFArmature:create("equipIntensify_3_anim")
            effect:setAnimationFps(GameConfig.ANIM_FPS)

            local img_intensify_lv = self.Node_Attri[i].txt_name
            effect:setPosition(ccp(-50, -50))
            img_intensify_lv:addChild(effect)
            self.shuaguang_effect[i] = effect
        end
        self.shuaguang_effect[i]:playByIndex(0, -1, -1, 0)
    end
    self.shuaguang_effect1 = self.shuaguang_effect1 or {}
    for i = 1, #self.Node_Extra_Attri do
        if self.Node_Extra_Attri[i].effect == true then
            if not self.shuaguang_effect1[i] then
                TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
                local effect = TFArmature:create("equipIntensify_3_anim")
                effect:setAnimationFps(GameConfig.ANIM_FPS)
    
                local img_intensify_lv = self.Node_Extra_Attri[i].txt_name
                effect:setPosition(ccp(-50, -50))
                img_intensify_lv:addChild(effect)
                self.shuaguang_effect1[i] = effect
            end
            self.shuaguang_effect1[i]:playByIndex(0, -1, -1, 0)
            self.Node_Extra_Attri[i].effect = false
        end
    end
    if self.img_qsx.effect == true then
        if not self.img_qsx.playeffect then
            TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
            local effect = TFArmature:create("equipIntensify_3_anim")
            effect:setAnimationFps(GameConfig.ANIM_FPS)

            local img_intensify_lv = self.img_qsx.txt_name
            effect:setPosition(ccp(-50, -50))
            img_intensify_lv:addChild(effect)
            self.img_qsx.playeffect = effect
        end
        self.img_qsx.playeffect:playByIndex(0, -1, -1, 0)
        self.img_qsx.effect = false
    end 

    if self.rightEffect then
        self.rightEffect:removeMEListener(TFARMATURE_COMPLETE)
        self.rightEffect:removeFromParent()
        self.rightEffect = nil
    end

    TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/equipment_refining.xml")
    local effect = TFArmature:create("equipment_refining_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    self.img_icon:addChild(effect)
    effect:setPosition(ccp(37,50))
    effect:setScale(0.5)
    self.rightEffect = effect
    self.rightEffect:playByIndex(0, -1, -1, 0)

    effect:addMEListener(TFARMATURE_COMPLETE,function()
        effect:removeFromParent()
        self.rightEffect = nil
    end)

    if self.successEffect then
        self.successEffect:removeMEListener(TFARMATURE_COMPLETE)
        self.successEffect:removeFromParent()
        self.successEffect = nil
    end
    
    local resPath = "effect/role_train.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create("role_train_anim")

    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:setPosition(ccp(0,0))
    effect:setScale(0.6)
    self.successEffect = effect    
    self.successEffect:playByIndex(0, -1, -1, 0)
    self.panel_kong[self.index].btn_icon:addChild(effect)

    effect:addMEListener(TFARMATURE_COMPLETE,function()
        effect:removeFromParent()
        self.successEffect = nil
    end)
end

function XinFaMingXinLayer:brushPointInfo()
    for k, v in ipairs(self.panel_kong) do
        local pointData = self.XinFainfo:getChongzhuDataByIdx(k) or {}
        if nil == v.effect then
            v.effect = self:getPointEffectByQuality(pointData.quality or 0)
            if v.effect then
                v.btn_icon:addChild(v.effect)
                v.effect:playByIndex(0, -1, -1, 1)
            end
        else
            if v.effect.quality ~= pointData.quality then
                v.effect:removeFromParent()
                v.effect = self:getPointEffectByQuality(pointData.quality or 0)
                if v.effect then
                    v.btn_icon:addChild(v.effect)
                    v.effect:playByIndex(0, -1, -1, 1)
                end
            end
        end
    end
end
function XinFaMingXinLayer:getPointEffectByQuality(quality)
    if quality <= 0 then 
        return nil 
    end
    TFResourceHelper:instance():addArmatureFromJsonFile('effect/lianti'..quality..'.xml')
    local effect = TFArmature:create('lianti'..quality..'_anim')
    effect.quality = quality
    return effect
end

function XinFaMingXinLayer.onShowItemClickHandle(sender)
    Public:ShowItemTipLayer(sender.itemId, sender.itemTypeId)
end
function XinFaMingXinLayer.onHelpClickHandle(sender)
    CommonManager:showRuleLyaer("kongfumethodreforge")
end
return XinFaMingXinLayer