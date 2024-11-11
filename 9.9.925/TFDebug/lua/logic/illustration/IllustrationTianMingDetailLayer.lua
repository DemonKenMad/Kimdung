
local IllustrationTianMingDetailLayer = class("IllustrationTianMingDetailLayer", BaseLayer)
local CardTianMing      = require('lua.gamedata.base.CardTianMing')
local GameAttributeData = require('lua.gamedata.base.GameAttributeData')
function IllustrationTianMingDetailLayer:ctor(tianMingId)
    self.super.ctor(self)
    self.tianMingId = tianMingId
    self:init("lua.uiconfig_mango_new.handbook.HandTianMing")
    
    -- self:removeUnuseTexEnabled(true);
end

function IllustrationTianMingDetailLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.closeBtn           = TFDirector:getChildByPath(ui, 'btn_close')
    self.txt_title          = TFDirector:getChildByPath(ui, 'txt_name1')
    self.img_touxiang       = TFDirector:getChildByPath(ui, 'img_tm')

    -- self.txt_des            = TFDirector:getChildByPath(ui, 'txt_des')
    self.img_pinzhiditu     = TFDirector:getChildByPath(ui, 'img_pz')
    self.btn_huodetujin     = TFDirector:getChildByPath(ui, 'btn_jisi')

    self.attr_list_panel        = {}
    for i=1,6 do
        local attrPanelCtrl = TFDirector:getChildByPath(ui, "img_attr" .. i)

        self.attr_list_panel[i]     = {}
        self.attr_list_panel[i].txt = TFDirector:getChildByPath(attrPanelCtrl, 'txt_name')
        self.attr_list_panel[i].num = TFDirector:getChildByPath(attrPanelCtrl, 'txt_base')
    end


    self.btn_huodetujin.logic = self

    self:draw()




end

function IllustrationTianMingDetailLayer:registerEvents(ui)
    self.super.registerEvents(self)
    self.btn_huodetujin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onclikOutPut),1)

    ADD_ALERT_CLOSE_LISTENER(self, self.closeBtn)
end

function IllustrationTianMingDetailLayer:removeEvents()
    self.super.removeEvents(self)

end

function IllustrationTianMingDetailLayer.onclikOutPut(sender)
    JiSiManager:openJiSiMainLayer()
end

function IllustrationTianMingDetailLayer:draw()
    local tTianMingModel  = ItemData:objectByID(self.tianMingId)
    if tTianMingModel == nil then
        return
    end
    self.txt_title:setText(tTianMingModel.name)
    -- self.txt_des:setText(tTianMingModel.details)
    self.img_touxiang:setTexture(tTianMingModel:GetPath())
    local qualityIcon   = GetColorIconByQuality(tTianMingModel.quality)
    self.img_pinzhiditu:setTexture(qualityIcon)
    self.img_touxiang:setFlipX(false)
     -- 属性描述

    local tianMingCard = CardTianMing:new(self.tianMingId)
    tianMingCard:setData({templateId = self.tianMingId, quality = tTianMingModel.quality, level = 0})

    local attribute = {}
    for k,v in pairs(tianMingCard.totalAttribute.attribute) do
        table.insert(attribute,{id = k,value = v})
    end
    table.sort(attribute,function (a,b)
         return a.id < b.id
    end)

    for i=1,6 do
        self.attr_list_panel[i].txt:setVisible(false)
        self.attr_list_panel[i].num:setVisible(false)
    end
    local i = 1
    for k,v in pairs(attribute) do
        if i <= 6 then
            self.attr_list_panel[i].txt:setVisible(true)
            self.attr_list_panel[i].num:setVisible(true)

            if v.id == 44 or v.id == 41 or v.id == 42 or v.id == 40 then 
                if v.value < 0 then
                    self.attr_list_panel[i].txt:setText(localizable.TianMingAttributeTypeStr[v.id]..localizable.TianMing_tips10)
                    self.attr_list_panel[i].num:setText("+"..math.abs(v.value/100) .."%")
                else
                    self.attr_list_panel[i].txt:setText(localizable.TianMingAttributeTypeStr[v.id]..localizable.TianMing_tips9)
                    self.attr_list_panel[i].num:setText("+"..v.value/100 .."%")
                end
            else
                self.attr_list_panel[i].txt:setText(localizable.TianMingAttributeTypeStr[v.id])
                if v.id <= 15 then
                    self.attr_list_panel[i].num:setText("+"..v.value)
                else
                    self.attr_list_panel[i].num:setText("+"..v.value/100 .."%")
                end
            end
            i = i + 1
        end
    end

end

function IllustrationTianMingDetailLayer:getAttrName( kind )
    local tKind = {}
    while(kind > 0) do
        tKind[#tKind + 1] = math.mod(kind,100)
        kind = math.floor(kind/100)
    end
    local attrStr = ""
    for i=#tKind,1,-1 do
        if attrStr ~= "" then
            attrStr = attrStr .. "、"
        end
        local index = tKind[i]
        attrStr = attrStr .. AttributeTypeStr[index]
    end
    return attrStr
end


return IllustrationTianMingDetailLayer