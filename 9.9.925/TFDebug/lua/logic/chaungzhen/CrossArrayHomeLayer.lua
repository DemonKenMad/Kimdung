-- client side CrossArrayHomeLayer.lua
--[[
 * @Description: 闯阵进入界面
 ]]
-- script writer chikui
-- creation time 2016-08-16


local CrossArrayHomeLayer = class("CrossArrayHomeLayer", BaseLayer);

CREATE_SCENE_FUN(CrossArrayHomeLayer);
CREATE_PANEL_FUN(CrossArrayHomeLayer);

function CrossArrayHomeLayer:ctor(data)
    self.super.ctor(self, data);   
    self:init("lua.uiconfig_mango_new.crossarray.CrossArrayHomeLayer");
end

function CrossArrayHomeLayer:loadHomeData(data)
    self.homeInfo = data;
    self:refreshUI();
end

function CrossArrayHomeLayer:onShow()
    self.super.onShow(self)
    self:refreshBaseUI();
end

function CrossArrayHomeLayer:refreshBaseUI()

end

function CrossArrayHomeLayer:refreshUI()
    
end

function CrossArrayHomeLayer:initUI(ui)
    self.super.initUI(self,ui);
    self.btn_go = TFDirector:getChildByPath(ui, 'btn_go');
    self.btn_help         = TFDirector:getChildByPath(ui, 'btn_help');
end

--填充主页信息
function CrossArrayHomeLayer:loadHomeInfo()

end

function CrossArrayHomeLayer.onGoClickHandle(sender)
    local self = sender.logic;
    ChuangzhenManager:openMainLayer(true)
end

function CrossArrayHomeLayer:removeUI()
    self.super.removeUI(self);

end

function CrossArrayHomeLayer:registerEvents()
    self.super.registerEvents(self);

    self.btn_go.logic    = self;   
    self.btn_go:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onGoClickHandle),1);
    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRuleClick))
end

function CrossArrayHomeLayer:removeEvents()
    self.super.removeEvents(self);
end
function CrossArrayHomeLayer:onRuleClick( sender )
    CommonManager:showRuleLyaer('chuangzhen')
end
return CrossArrayHomeLayer;
