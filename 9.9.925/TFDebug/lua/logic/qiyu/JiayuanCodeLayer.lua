local JiayuanCodeLayer = class("JiayuanCodeLayer", BaseLayer)

function JiayuanCodeLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.qiyu.CodeLayer")
end

function JiayuanCodeLayer:initUI(ui)
    self.super.initUI(self, ui)

    self.btn_go = TFDirector:getChildByPath(ui, "btn_go")
    self.btn_go.logic = self
end

function JiayuanCodeLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function JiayuanCodeLayer:registerEvents(ui)
    self.super.registerEvents(self)
    self.btn_go:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnGoClickHandle), 1)
end

function JiayuanCodeLayer:removeEvents()
    self.super.removeEvents(self)
end

function JiayuanCodeLayer:refreshUI()
    if self.logic then
        self.logic:redraw()
    end  
end

function JiayuanCodeLayer.onBtnGoClickHandle(sender)
    local self = sender.logic
    --[[
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.qiyu.JiayuanLayer", AlertManager.BLOCK_AND_GRAY)
    AlertManager:show()
    ]]

    QiyuManager:requestOpenJiayuan()
end

return JiayuanCodeLayer