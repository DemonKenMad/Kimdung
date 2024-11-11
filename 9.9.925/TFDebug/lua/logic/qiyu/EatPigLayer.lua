
local EatPigLayer = class("EatPigLayer", BaseLayer)

function EatPigLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.qiyu.EatPigLayer")
end

function EatPigLayer:onShow()
    -- print("EatPigLayer onShow")
    self.super.onShow(self)
      
    self:RefreshBtn()

end

function EatPigLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.eatBtn1 = TFDirector:getChildByPath(ui, 'eatBtn1')
    self.eatBtn1:setVisible(false)
    self.eatTip1 = TFDirector:getChildByPath(ui, 'eatTip1')

    self.eatBtn2 = TFDirector:getChildByPath(ui, 'eatBtn2')
    self.eatBtn2:setVisible(false)
    self.eatTip2 = TFDirector:getChildByPath(ui, 'eatTip2')
    self.eatBtn2:setVisible(false)

    self.eatBtn3 = TFDirector:getChildByPath(ui, 'eatBtn3')
    self.eatBtn3:setVisible(false)

    self.pigImg = TFDirector:getChildByPath(ui, "pigImg")
end

function EatPigLayer:registerEvents(ui)
    self.super.registerEvents(self)
    QiyuManager:SengQueryEatPigMsg()
    
    self.eatBtn1:addMEListener(TFWIDGET_CLICK, audioClickfun(self.eatBtnClickHandle),1)
    self.eatBtn2:addMEListener(TFWIDGET_CLICK, audioClickfun(self.eatBtnClickHandle),1)
    self.eatBtn3:addMEListener(TFWIDGET_CLICK, audioClickfun(self.eatBtnClickHandle),1)
    self.eatBtn1.logic = self
    self.eatBtn2.logic = self
    self.eatBtn3.logic = self
    TFDirector:addMEGlobalListener("eatPigInfo", function() 
        self:stopPigEffect()
        self:RefreshBtn()
        local timer = QiyuManager:getEatPigCutDown()
        if timer then
            if self.nTimerId then
                TFDirector:removeTimer(self.nTimerId)
                self.nTimerId = nil
            end            
            self.nTimerId = TFDirector:addTimer(1000, -1, nil, function(event)
                timer = timer - 1
                if timer <= 0 then
                    QiyuManager:SengQueryEatPigMsg()
                    TFDirector:removeTimer(self.nTimerId)
                    self.nTimerId = nil
                end
            end)             
        end
    end)
end

function EatPigLayer:removeEvents()
    TFDirector:removeMEGlobalListener("eatPigInfo")
    if self.nTimerId then
        TFDirector:removeTimer(self.nTimerId)
        self.nTimerId = nil
    end
    self.super.removeEvents(self)
end

function EatPigLayer:RefreshBtn()
    self.eatBtn1:setVisible(true)
    self.eatBtn2:setVisible(true)
    self.eatBtn3:setVisible(true)

    if self.effect then
        self.effect:removeFromParent()
        self.effect = nil
    end

    --disable all buttons
    self.eatBtn1:setGrayEnabled(true)
    self.eatBtn1:setTouchEnabled(false)
    self.eatBtn2:setGrayEnabled(true)
    self.eatBtn2:setTouchEnabled(false)
    self.eatBtn3:setGrayEnabled(true)
    self.eatBtn3:setTouchEnabled(false)

    for i=1,3 do
        local state = QiyuManager:getEatPigState(i)
        -- print("i = ",i)
        -- print("status = ",status)
        if i == 1 and state == 2 then
            self.eatBtn1:setGrayEnabled(false)
            self.eatBtn1:setTouchEnabled(true)
            self:addeffect("btn_common",self.eatBtn1)
        elseif i == 2 and state == 2 then
            self.eatBtn2:setGrayEnabled(false)
            self.eatBtn2:setTouchEnabled(true)
            self:addeffect("btn_common",self.eatBtn2)
        elseif i == 3 and state == 2 then
            self.eatBtn3:setGrayEnabled(false)
            self.eatBtn3:setTouchEnabled(true)
            self:addeffect("btn_common",self.eatBtn3)
        end
    end

    local tipImg = {"ui_new/qiyu/sjwd.png", "ui_new/qiyu/kyyc.png", "ui_new/qiyu/yyc.png", "ui_new/qiyu/sjgl.png"}
    self.eatTip1:setTexture(tipImg[DietData:objectByID(1):getStatus(QiyuManager.lastDietTime)])
    self.eatTip2:setTexture(tipImg[DietData:objectByID(2):getStatus(QiyuManager.lastDietTime)])

    if self.logic then
        self.logic:redraw()
    end   
end

function EatPigLayer:addeffect( effectName ,btn )
    if self.effect == nil then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/"..effectName..".xml")
        local effect = TFArmature:create(effectName.."_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        btn:addChild(effect , 100)
        self.effect = effect
    end



    self:addPigEffect()
end

function EatPigLayer:addPigEffect()
    if self.pig_effect == nil then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/eat_pig_effect.xml")
        local effect = TFArmature:create("eat_pig_effect_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(583/2 + 2, 381/2 + 2))
        effect:playByIndex(0, -1, -1, 1)
        self.pigImg:addChild(effect , 100)
        self.pig_effect = effect
    end
end

function EatPigLayer:stopPigEffect()
    if self.pig_effect then
        self.pig_effect:removeFromParent()
        self.pig_effect = nil
    end
end

function EatPigLayer.eatBtnClickHandle(sender)
    TFDirector:send(c2s.DINING_REQUEST, {})
    sender:setGrayEnabled(true)
    sender:setTouchEnabled(false)
    local self = sender.logic
    if self.effect then
        self.effect:removeFromParent()
        self.effect = nil
    end

    self:stopPigEffect()
end

return EatPigLayer