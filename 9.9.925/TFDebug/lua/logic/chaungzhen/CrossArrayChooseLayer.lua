-- client side CrossArrayChooseLayer.lua
--[[
 * @Description: 闯阵选择
 ]]
-- script writer Stephen.tao
-- creation time 2016-08-10

local CrossArrayChooseLayer = class("CrossArrayChooseLayer", BaseLayer);
CrossArrayChooseLayer.OpemMaxNum = 5
function CrossArrayChooseLayer:ctor(data)
    self.super.ctor(self,data);
    self:init("lua.uiconfig_mango_new.crossarray.CrossArrayChoose");
    self.touchLongTimer = nil
end


function CrossArrayChooseLayer:initUI(ui)
    self.super.initUI(self,ui);

    self.panel_head         = TFDirector:getChildByPath(ui, 'panel_head');
    self.generalHead = CommonManager:addGeneralHead( self )
    self.generalHead:setData(ModuleType.ChuangZhen,{HeadResType.COIN,HeadResType.SYCEE})

    self.type_btn = {}
    local length = ChuangzhenManager.crossArrayRushZoneData:length()
    print("length ===",length)
    for i=1,length do
        local node                      = TFDirector:getChildByPath(ui, 'btn_'..i);
        self.type_btn[i]                = node
        self.type_btn[i].txt_tips       = TFDirector:getChildByPath(self.type_btn[i] , 'txt_tips1');
        self.type_btn[i].img_suo        = TFDirector:getChildByPath(self.type_btn[i] , 'img_suo');
        self.type_btn[i].txt_cz         = TFDirector:getChildByPath(self.type_btn[i] , 'txt_cz');
        self.type_btn[i].txt_ytg        = TFDirector:getChildByPath(self.type_btn[i] , 'txt_ytg');
        self.type_btn[i].index = i
        self.type_btn[i].logic = self
        node:setVisible(i <= CrossArrayChooseLayer.OpemMaxNum)
    end
    self.btn_pageleft    = TFDirector:getChildByPath(ui, 'btn_pageleft');
    self.btn_pageright   = TFDirector:getChildByPath(ui, 'btn_pageright');
    self.ScrollView      = TFDirector:getChildByPath(ui, 'ScrollView');
    self.txt_cishu       = TFDirector:getChildByPath(ui, 'txt_cishu');
    self.txt_num         = TFDirector:getChildByPath(self.txt_cishu, 'txt_num');
    self.firstShow = true
    
    
    self.ScrollView:setSize(CCSizeMake(1300, self.ScrollView:getSize().height))
    self.ScrollView:setInnerContainerSize(CCSizeMake(1300, self.ScrollView:getSize().height))
    --self.ScrollView:setInnerContainerSize(CCSizeMake(1600 + 260, self.ScrollView:getSize().height))
    self.ScrollView:setTouchEnabled(true)
    self.ScrollView:setClippingEnabled(false)
end

function CrossArrayChooseLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
    if self.firstShow == true then
        self.ui:runAnimation("Action0", 1);
        self.firstShow = false

        self.touchLongTimer = TFDirector:addTimer(800, -1, nil,
            function ()
                self.ScrollView:setPositionX(-87)
                local childrenArr = self.ScrollView:getChildren();
                for i=0,childrenArr:count()-1 do
                    local child = childrenArr:objectAtIndex(i);
                    child:setPosition(ccp(child:getPosition().x + 87, child:getPosition().y));
                    child:setVisible(i < CrossArrayChooseLayer.OpemMaxNum)
                end
                if self.touchLongTimer then
                    TFDirector:removeTimer(self.touchLongTimer)
                    self.touchLongTimer = nil
                end
            end)
    end
end

function CrossArrayChooseLayer:refreshUI()
    if not self.isShow then
        return;
    end
    local length = ChuangzhenManager.crossArrayRushZoneData:length()
    for i=1,length do
        if (i <= CrossArrayChooseLayer.OpemMaxNum) then
            local zoneInfo = ChuangzhenManager:getZoneInfo(i)
            local des = stringUtils.format(localizable.common_open_level, zoneInfo.open_level)
            self.type_btn[i].txt_tips:setText(des)
            self.type_btn[i].txt_tips:setVisible(false)
            self.type_btn[i].img_suo:setVisible(false)
            self.type_btn[i].txt_cz:setVisible(false)
            self.type_btn[i].txt_ytg:setVisible(false)
            if i > ChuangzhenManager.maxType then
                self.type_btn[i].txt_tips:setVisible(true)
                if i == ChuangzhenManager.maxType + 1 and zoneInfo.open_level <= MainPlayer:getLevel() then
                    self.type_btn[i].txt_tips:setText(localizable.commom_open)
                else
                    self.type_btn[i].img_suo:setVisible(true)
                    if zoneInfo.open_level <= MainPlayer:getLevel() then
                        self.type_btn[i].txt_tips:setText("")
                    end
                end
            else
                if i ~= ChuangzhenManager.type then
                    self.type_btn[i].txt_ytg:setVisible(true)
                end
            end
            if i == ChuangzhenManager.type then
                self.type_btn[i].txt_cz:setVisible(true)
                self.type_btn[i].txt_tips:setVisible(false)
            end
        end
    end
    --1600 960
    local width1        = self.ScrollView:getSize().width
    local width2        = self.ScrollView:getInnerContainerSize().width
    local endX  = -(width2 - width1)
    local moveX = -(ChuangzhenManager.maxType - 1) * 200
    if (moveX < endX) then
        moveX = endX
    end

    self.ScrollView:setContentOffset(ccp(moveX, 0))
    -- print(openNum, 'ChuangzhenManager.maxType = ',ChuangzhenManager.maxType)
    -- print('ChuangzhenManager.type = ',ChuangzhenManager.type)
    self:setChallengeTime()
    self:isShowBut()
end

function CrossArrayChooseLayer:setChallengeTime()
    local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.CHUANGZHEN)
    local challengeTime = challengeInfo:getLeftChallengeTimes()
    self.txt_num:setText(challengeTime)
end


function CrossArrayChooseLayer.onGoClickHandle(sender)
    local self = sender.logic;
    local index = sender.index
    local zoneInfo = ChuangzhenManager:getZoneInfo(index)
    if index > ChuangzhenManager.maxType + 1 then
        toastMessage(localizable.CrossArray_PleasePassBefore)
        return 
    end
    if index == ChuangzhenManager.maxType  + 1 and zoneInfo.open_level > MainPlayer:getLevel() then
        toastMessage(stringUtils.format(localizable.common_function_openlevel,zoneInfo.open_level))
        return 
    end
    if ChuangzhenManager.type == 0 then
        ChuangzhenManager:openCrossArrayChooseDetailLayer(index)
        return
    end
    if index == ChuangzhenManager.type then
        ChuangzhenManager:GainRushCheckPoint()
        return
    end
    ChuangzhenManager:openCrossArrayChooseDetailLayer(index)
    -- CommonManager:showOperateSureLayer(function()
    --         ChuangzhenManager:GiveUpRush()
    --         ChuangzhenManager:openCrossArrayChooseDetailLayer(index)
    --     end,
    --     nil,
    --     {
    --         msg = localizable.CrossArray_PleaseCancelType
    --     })
end

function CrossArrayChooseLayer:removeUI()
    if self.touchLongTimer then
        TFDirector:removeTimer(self.touchLongTimer)
        self.touchLongTimer = nil
    end
    self.super.removeUI(self);

end

function CrossArrayChooseLayer:registerEvents()
    self.super.registerEvents(self);
    function onTouchMove(widget,pos,offset)
        self:isShowBut()
    end
    local length = ChuangzhenManager.crossArrayRushZoneData:length()
    for i=1,length do
        if (i <= CrossArrayChooseLayer.OpemMaxNum) then
            self.type_btn[i]:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onGoClickHandle),1);
            self.type_btn[i]:addMEListener(TFWIDGET_TOUCHMOVED, audioClickfun(onTouchMove),1)
        end
    end

    if self.generalHead then
        self.generalHead:registerEvents()
    end

    self.receiveGiveUpSuccessCallBack = function (event)
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(ChuangzhenManager.ReceiveGiveUpSuccess,self.receiveGiveUpSuccessCallBack)

    -- self.btn_pageleft:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMoveClickHandle),1);
    -- self.btn_pageright:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMoveClickHandle),1);
    -- self.btn_pageright.isRight  = true
    -- self.btn_pageleft.logic     = self
    -- self.btn_pageright.logic    = self
    --
    --self.ScrollView:addMEListener(TFWIDGET_TOUCHMOVED, audioClickfun(onTouchMove),1)
    --
    self.btn_pageright:setVisible(false)
    self.btn_pageleft:setVisible(false)
end
--
function CrossArrayChooseLayer:isShowBut()
    local pos           = self.ScrollView:getContentOffset()
    local width1        = self.ScrollView:getSize().width
    local width2        = self.ScrollView:getInnerContainerSize().width
    local isShowLeft    = (pos.x <= -187)
    local isShowRight   = (pos.x > (-(width2 - width1) + 100))
    self.btn_pageright:setVisible(isShowRight)
    self.btn_pageleft:setVisible(isShowLeft)
end

function CrossArrayChooseLayer.onMoveClickHandle(sender)
    local self = sender.logic;
    local width1        = self.ScrollView:getSize().width
    local width2        = self.ScrollView:getInnerContainerSize().width
    local endX          = -(width2 - width1)

    local currX = self.ScrollView:getContentOffset().x
    local currY = self.ScrollView:getContentOffset().y

    if (sender.isRight) then
        currX = currX - 200
        if (currX < endX) then
            currX = endX
        end
    else
        currX = currX + 200
        if (currX > 0) then
            currX = 0
        end
    end
    self.ScrollView:setContentOffset(ccp(currX, 0),0.3);
    self.onButTimer = TFDirector:addTimer(301, -1, nil,
        function ()
            self:isShowBut()
            if self.onButTimer then
                TFDirector:removeTimer(self.onButTimer)
                self.onButTimer = nil
            end
        end)
end
function CrossArrayChooseLayer:removeEvents()
    if self.generalHead then
        self.generalHead:removeEvents()
    end
    TFDirector:removeMEGlobalListener(ChuangzhenManager.ReceiveGiveUpSuccess,self.receiveGiveUpSuccessCallBack)
    self.super.removeEvents(self);
end

return CrossArrayChooseLayer;
