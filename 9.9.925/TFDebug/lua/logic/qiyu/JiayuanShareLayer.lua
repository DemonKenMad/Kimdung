-- client side JiayuanShareLayer.lua
--[[
 * @Description: 家园分享界面
 ]]
-- script writer wuqi
-- creation time 2016-07-18

local JiayuanShareLayer = class("JiayuanShareLayer", BaseLayer)

JiayuanShareLayer.SHARE_INDEX = 
{
    PYQ = 1,
    KJ = 2,
    WB = 3,
    WX = 4,    
    QQ = 5 
}

function JiayuanShareLayer:ctor(data)
    self.super.ctor(self, data)
    self:init("lua.uiconfig_mango_new.qiyu.FamilyFenXiang")
end

function JiayuanShareLayer:initUI(ui)
	self.super.initUI(self, ui) 

    local tab = {"btn_pyq", "btn_kj", "btn_wb", "btn_wx", "btn_qq"}

    self.btn_share_tab = {}
    for i = 1, #tab do
        self.btn_share_tab[i] = TFDirector:getChildByPath(ui, tab[i])
        self.btn_share_tab[i].index = i
        self.btn_share_tab[i].logic = self
        self.btn_share_tab[i]:setTouchEnabled(true)
    end
end

function JiayuanShareLayer:onShow()
    self.super.onShow(self)
    self:refreshBaseUI();
    self:refreshUI();
end

function JiayuanShareLayer:refreshBaseUI()

end

function JiayuanShareLayer:refreshUI()
    
end


function JiayuanShareLayer:removeUI()
    self.super.removeUI(self)
end

function JiayuanShareLayer:registerEvents()
    self.super.registerEvents(self)
    self.ui:setTouchEnabled(true)
    ADD_ALERT_CLOSE_LISTENER(self, self.ui)

    for i = 1, #self.btn_share_tab do
        self.btn_share_tab[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShareClick))
    end 
end

function JiayuanShareLayer.onShareClick(sender)
    local self = sender.logic

    local index = sender.index

    if index == self.SHARE_INDEX.KJ then
        toastMessage(localizable.Jiayuan_qq_not_enable)
        return
    end
    QiyuManager:share(index)
end


function JiayuanShareLayer:removeEvents()
    self.super.removeEvents(self)  
end


return JiayuanShareLayer
