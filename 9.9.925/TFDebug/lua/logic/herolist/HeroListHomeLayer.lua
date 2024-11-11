local HeroListHomeLayer = class("HeroListHomeLayer", BaseLayer);
--[[
英雄志
]]

function HeroListHomeLayer:ctor(data)
    self.super.ctor(self,data);
    
    self:init("lua.uiconfig_mango_new.herolist.HeroListHome");
end

function HeroListHomeLayer:loadHomeData(data)
    self.homeInfo = data;
    self:refreshUI();
end

function HeroListHomeLayer:onShow()
    self.super.onShow(self)
    self:refreshBaseUI();
end

function HeroListHomeLayer:refreshBaseUI()

end

function HeroListHomeLayer:refreshUI()
    if not self.isShow then
        return;
    end

end

function HeroListHomeLayer:initUI(ui)
    self.super.initUI(self,ui);

    self.btn_go         = TFDirector:getChildByPath(ui, 'btn_go');
    self.btn_help       = TFDirector:getChildByPath(ui, 'btn_help');
end

--填充主页信息
function HeroListHomeLayer:loadHomeInfo()

end


function HeroListHomeLayer.onGoClickHandle(sender)
    local self = sender.logic;
    if MainPlayer:getServerSwitchStatue(ServerSwitchType.HeroList) == false then
        toastMessage(localizable.WeekRaceManager_huodong_weikaishi)
        return
    end
    HeroListManager:sendopenheroAmbition()
    HeroListManager:showHeroListLayer()
end

function HeroListHomeLayer:removeUI()
    self.super.removeUI(self);
    
end

function HeroListHomeLayer:registerEvents()
    self.super.registerEvents(self);

    self.btn_go.logic    = self;   
    self.btn_go:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onGoClickHandle),1);
    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRuleClick),1)

end

function HeroListHomeLayer:removeEvents()
    self.super.removeEvents(self);
end
function HeroListHomeLayer.onRuleClick( sender )
    CommonManager:showRuleLyaer('yingxiongzhi')
end
return HeroListHomeLayer;
