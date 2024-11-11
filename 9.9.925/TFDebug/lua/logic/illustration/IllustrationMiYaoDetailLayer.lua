
local IllustrationMiYaoDetailLayer = class("IllustrationMiYaoDetailLayer", BaseLayer)
function IllustrationMiYaoDetailLayer:ctor(itemId)
    self.super.ctor(self)
    self.itemId = itemId
    self:init("lua.uiconfig_mango_new.handbook.MiYaoDetail")
    
    -- self:removeUnuseTexEnabled(true);
end

function IllustrationMiYaoDetailLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.closeBtn           = TFDirector:getChildByPath(ui, 'btn_close')
    self.txt_title          = TFDirector:getChildByPath(ui, 'txt_name')
    self.img_touxiang       = TFDirector:getChildByPath(ui, 'img_touxiang')

    self.txt_des            = TFDirector:getChildByPath(ui, 'txt_des')
    

    self.img_pinzhiditu     = TFDirector:getChildByPath(ui, 'img_pinzhiditu')
    self.btn_huodetujin     = TFDirector:getChildByPath(ui, 'btn_huodetujin')
    
    -- 成长武力
    self.panel_des      = TFDirector:getChildByPath(ui, 'txt_attr_miyao');
    self.panel_des:setText("")
    local size = self.panel_des:getSize()
    local richText = TFRichText:create(self.panel_des:getSize())
    -- richText:setTouchEnabled(true)
    richText:setPosition(ccp( -size.width * 0.5, size.height * 0.5))
    richText:setAnchorPoint(ccp(0, 1))
    self.panel_des:removeAllChildren()
    self.panel_des:addChild(richText)

    self.txt_attr_miyao      = richText;

    self.Panel_quality2           = TFDirector:getChildByPath(ui, 'Panel_quality2')
    self.Panel_quality2:setVisible(false)

    self.btn_huodetujin.logic = self

    self:draw()

    --图鉴控制
    local itemData  = ItemData:objectByID(self.itemId)
    self.output = itemData.show_way

    self.btn_huodetujin:setVisible(false)
    if self.output and string.len(self.output) > 0 then
        self.btn_huodetujin:setVisible(true)
    end


end

function IllustrationMiYaoDetailLayer:registerEvents(ui)
    self.super.registerEvents(self)
    self.btn_huodetujin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onclikOutPut),1)

    ADD_ALERT_CLOSE_LISTENER(self, self.closeBtn)
end

function IllustrationMiYaoDetailLayer:removeEvents()
    self.super.removeEvents(self)

end

function IllustrationMiYaoDetailLayer.onclikOutPut(sender)
    local self = sender.logic

    
    IllustrationManager:showOutputList({output = self.output, id = 2})
end

function IllustrationMiYaoDetailLayer:draw()
    local itemData  = ItemData:objectByID(self.itemId)
    if itemData == nil then
        return
    end
    self.txt_title:setText(itemData.name)
    self.txt_title:setScale(0.8)
    self.txt_des:setText(itemData.details)
    self.img_touxiang:setTexture(itemData:GetPath())
    local qualityIcon   = GetColorIconByQuality(itemData.quality)
    self.img_pinzhiditu:setTexture(qualityIcon)
    self.img_touxiang:setFlipX(false)
     -- 属性描述
    local bibleKeyInfo = BibleKeyQualityData:GetKeyInfoById(self.itemId,0)
    local skillInfo = SkillBaseData:objectByID(bibleKeyInfo.spell_id)
    if (skillInfo == nil) then
        return
    end
    local spellInfo         = skillInfo
    local spellLevelInfo    = spellInfo:GetLevelItem(0)
    local des = spellInfo:getTichTextDes(spellLevelInfo,spellInfo.skill_add)
    self.txt_attr_miyao:setText(des)
end


return IllustrationMiYaoDetailLayer