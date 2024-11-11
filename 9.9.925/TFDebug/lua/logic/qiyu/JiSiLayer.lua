
local JiSiLayer = class("JiSiLayer", BaseLayer)

function JiSiLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.qiyu.Jisi")
    -- QiyuManager:SengQueryEatPigMsg()
end

function JiSiLayer:onShow()
    self.super.onShow(self)
end

function JiSiLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.btn_go = TFDirector:getChildByPath(ui, 'btn_go')
end

function JiSiLayer:registerEvents(ui)
    self.super.registerEvents(self)
    self.btn_go:addMEListener(TFWIDGET_CLICK, audioClickfun(self.goBtnClickHandle),1)
end

function JiSiLayer:removeEvents()
    self.super.removeEvents(self)
end

function JiSiLayer.goBtnClickHandle(sender)
    JiSiManager:openJiSiMainLayer()
end

return JiSiLayer