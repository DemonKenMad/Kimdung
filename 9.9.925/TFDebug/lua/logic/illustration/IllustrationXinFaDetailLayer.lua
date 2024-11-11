--[[
******图鉴层*******

]]

local IllustrationXinFaDetailLayer = class("IllustrationXinFaDetailLayer", BaseLayer)

function IllustrationXinFaDetailLayer:ctor(equipid)
    self.super.ctor(self)
    print("equipid = ", equipid)
    self.equipid = equipid
    self:init("lua.uiconfig_mango_new.handbook.HandXinFaDetail")
    
    -- self:removeUnuseTexEnabled(true);
end

function IllustrationXinFaDetailLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.closeBtn           = TFDirector:getChildByPath(ui, 'btn_close')
    self.btn_huodetujin     = TFDirector:getChildByPath(ui, 'btn_huodetujin')
    self.btn_huodetujin.logic = self
    self.img_pinzhiditu     = TFDirector:getChildByPath(ui, 'img_pinzhiditu')
    self.img_touxiang       = TFDirector:getChildByPath(ui, 'img_touxiang')
    self.img_touxiang:setScaleX(-1.0)
    self.txt_name           = TFDirector:getChildByPath(ui, 'txt_name')
    local txt_zsx           = TFDirector:getChildByPath(ui, 'txt_zsx')
    local txt_ts            = TFDirector:getChildByPath(ui, 'txt_ts')
    self.txt_zsx            = TFDirector:getChildByPath(txt_zsx, 'txt_num')
    self.txt_ts             = TFDirector:getChildByPath(txt_ts, 'txt_num')
    self.txt_des            = TFDirector:getChildByPath(ui, 'txt_des')
    self.txt_ts2            = TFDirector:getChildByPath(ui, 'txt_attr_miyao')
    --图鉴控制
    local role  = ItemData:objectByID(self.equipid)
    self.output = role.show_way

    self.btn_huodetujin:setVisible(false)
    if self.output and string.len(self.output) > 0 then
        self.btn_huodetujin:setVisible(true)
    end

    self:refreshUI()
end

function IllustrationXinFaDetailLayer:refreshUI()
    local info = ItemData:objectByID(self.equipid)
    local KongfuData = KongfuComData:objectByKongfuId(self.equipid)
    self.txt_name:setText(info.name)
    self.img_pinzhiditu:setTexture(GetColorIconByQuality(info.quality))
    self.img_touxiang:setTexture(info:GetPath())
    if info.usable ~= 0 then 
        self.txt_zsx:setText(AttributeTypeStr[info.usable])
    else
        self.txt_zsx:setText(KongfuData.desc2)
    end
    self.txt_ts:setText(KongfuData.desc1)
    self.txt_ts2:setText(KongfuData.desc2)
    self.txt_des:setText(info.details)
end

function IllustrationXinFaDetailLayer:registerEvents(ui)
    self.super.registerEvents(self)
    self.btn_huodetujin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onclikOutPut),1)
    
    ADD_ALERT_CLOSE_LISTENER(self, self.closeBtn)
end

function IllustrationXinFaDetailLayer:removeEvents()
    self.super.removeEvents(self)

end

function IllustrationXinFaDetailLayer.onclikOutPut(sender)
    local self = sender.logic
 
    IllustrationManager:showOutputList({output = self.output, id = 2})
end


return IllustrationXinFaDetailLayer