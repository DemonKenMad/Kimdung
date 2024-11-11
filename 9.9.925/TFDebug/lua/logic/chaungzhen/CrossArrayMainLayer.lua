-- client side CrossArrayMainLayer.lua
--[[
 * @Description: 闯阵主界面
 ]]
-- script writer Stephen.tao
-- creation time 2016-08-10

local CrossArrayMainLayer = class("CrossArrayMainLayer", BaseLayer);


function CrossArrayMainLayer:ctor(data)
    self.super.ctor(self,data);
    self.isShowBuffEffect = false
    self:init("lua.uiconfig_mango_new.crossarray.CrossArrayMain");
end


function CrossArrayMainLayer:initUI(ui)
    self.super.initUI(self,ui);

    self.btn_fanhui         = TFDirector:getChildByPath(ui, 'btn_fanhui');
    self.btn_help         = TFDirector:getChildByPath(ui, 'btn_help');
    self.txt_ceng         = TFDirector:getChildByPath(ui, 'txt_ceng');
    self.txt_name         = TFDirector:getChildByPath(ui, 'txt_name');

    self.txt_sx          = TFDirector:getChildByPath(ui, 'txt_sx');
    self.txt_sx:setText(localizable.UILayer_tips_32)
    self.txt_buff_List_1 = {};
    self.txt_buff_List_1[1]      = TFDirector:getChildByPath(self.txt_sx, 'txt_effect1');
    self.txt_buff_List_1[2]      = TFDirector:getChildByPath(self.txt_sx, 'txt_effect2');
    self.txt_sx2         = TFDirector:getChildByPath(ui, 'txt_sx2');
    self.txt_buff_List_2 = {};
    self.txt_buff_List_2[1]      = TFDirector:getChildByPath(self.txt_sx2, 'txt_effect1');
    self.txt_buff_List_2[2]      = TFDirector:getChildByPath(self.txt_sx2, 'txt_effect2');

    self.btn_click        = TFDirector:getChildByPath(ui, 'btn_click');
    self.btn_zhenwei      = TFDirector:getChildByPath(ui, 'btn_zhenwei');
    self.btn_hufa         = TFDirector:getChildByPath(ui, 'btn_hufa');
    self.btn_box          = TFDirector:getChildByPath(ui, 'btn_box');
    self.panel_yun        = TFDirector:getChildByPath(ui, 'panel_yun');

    self.btn_reset        = TFDirector:getChildByPath(ui, 'btn_cz');
    
    self.btn_click:setVisible(false)
    self.btn_click:retain()
    self.btn_click:removeFromParent()

    self.btn_zhenwei:setVisible(false)
    self.btn_zhenwei:setTouchEnabled(false)
    self.btn_zhenwei:retain()
    self.btn_zhenwei:removeFromParent()

    self.btn_hufa:setVisible(false)
    self.btn_hufa:setTouchEnabled(false)
    self.btn_hufa:retain()
    self.btn_hufa:removeFromParent()
    self.btn_grid = {}
    self.bShowReward = false

    self.btn_box:setVisible(false)
    self.btn_box:setTouchEnabled(false)
    self.btn_box:retain()
    self.btn_box:removeFromParent()

    local resPath = "effect/crossarray.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    self.effect_model = TFArmature:create("crossarray_anim")
    self.effect_model:retain()
    self.effect_model:setVisible(false)
    resPath = "effect/crossarray_box.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    self.effect_box_model = TFArmature:create("crossarray_box_anim")
    self.effect_box_model:retain()
    self.effect_box_model:setVisible(false)
end

function CrossArrayMainLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function CrossArrayMainLayer:refreshUI()
    if not self.isShow then
        return;
    end
    if self.bShowReward == true then
        self.bShowReward = false
        ChuangzhenManager:openCrossArraySuccessLayer(self.itemList or {},self.isLast or 0)
    end
end

function CrossArrayMainLayer:initMap()
    local length = ChuangzhenManager.mapData.width * ChuangzhenManager.mapData.high
    for i=1,length do
        if self.btn_grid[i] == nil then
            self.btn_grid[i] = self.btn_click:clone()
            self.btn_grid[i]:setVisible(true)
            self.btn_grid[i]:setTouchEnabled(true)
            self.btn_grid[i]:setPosition(ChuangzhenManager:getPositionByIndex(i))
            self.panel_yun:addChild(self.btn_grid[i])
            self.btn_grid[i].img_item = TFDirector:getChildByPath(self.btn_grid[i], 'img_item');
            self.btn_grid[i].img_close = TFDirector:getChildByPath(self.btn_grid[i], 'img_close');
            self.btn_grid[i].logic = self
            self.btn_grid[i].index = i
            self.btn_grid[i]:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onGridBtnClick))
        end
    end
    for i=1,length do
        self:setGridState(i,nil,nil)
    end

    local zoneInfo = ChuangzhenManager:getZoneInfo(ChuangzhenManager.type)
    self.txt_name:setText(zoneInfo.name)
    local mapInfo = ChuangzhenManager:getMapGridInfo(ChuangzhenManager.type,ChuangzhenManager.level)
    self.txt_ceng:setText(stringUtils.format(localizable.LunJianFeng_txt_bpbuff_layer, EnumWuxueLevelType[mapInfo.floor]))
    self:freshBuff()
    -- self:freshAttr()
end

function CrossArrayMainLayer:freshBuff()
    local value = ChuangzhenManager:getOrganBuffByType(1).value or 0
    if value ~= 0 then
        self.txt_sx:setVisible(true)
        local str = value .. "%"
        if value > 0 then
            str = "+" .. str
            self.txt_buff_List_1[1]:setVisible(true)
            self.txt_buff_List_1[2]:setVisible(false)
            self.txt_buff_List_1[1]:setText(str)
        else
            self.txt_buff_List_1[1]:setVisible(false)
            self.txt_buff_List_1[2]:setVisible(true)
            self.txt_buff_List_1[2]:setText(str)
        end
    else
        self.txt_sx:setVisible(false)
    end

    value = ChuangzhenManager:getOrganBuffByType(2).value or 0
    if value ~= 0 then
        self.txt_sx2:setVisible(true)
        local str = value .. "%"
        if value > 0 then
            str = "+" .. str
            self.txt_buff_List_2[1]:setVisible(true)
            self.txt_buff_List_2[2]:setVisible(false)
            self.txt_buff_List_2[1]:setText(str)
        else
            self.txt_buff_List_2[1]:setVisible(false)
            self.txt_buff_List_2[2]:setVisible(true)
            self.txt_buff_List_2[2]:setText(str)
        end
    else
        self.txt_sx2:setVisible(false)
    end
end

-- function CrossArrayMainLayer:freshAttr()
--     self.txt_sx:setVisible(false)
--     for k,v in pairs(ChuangzhenManager.attribute) do
--         self.txt_sx:setVisible(true)
--         self.txt_sx:setText(localizable.AttributeTypeStr[k])
--         local txt_effect1 = TFDirector:getChildByPath(self.txt_sx,"txt_effect1")
--         local txt_effect2 = TFDirector:getChildByPath(self.txt_sx,"txt_effect2")
--         if v > 0 then
--             txt_effect1:setVisible(true)
--             txt_effect2:setVisible(false)
--             -- txt_effect1:setText("+"..v*100.."%")
--         else
--             txt_effect1:setVisible(false)
--             txt_effect2:setVisible(true)
--             -- txt_effect2:setText("-"..v*100.."%")
--         end
--     end
-- end

function CrossArrayMainLayer:setGridState( index , buffType , stateChanged )
    if self.btn_grid[index].effect then
        self.btn_grid[index].effect:removeFromParent()
        self.btn_grid[index].effect = nil
    end
    if self.btn_grid[index].box then
        self.btn_grid[index].box:removeFromParent()
        self.btn_grid[index].box = nil
    end
    self.btn_grid[index].img_item:setScale(1)
    if ChuangzhenManager.mapState[index] == ChuangzhenManager.GridStateClosed then
        self.btn_grid[index].img_item:setVisible(true)
        self.btn_grid[index].img_item:setTexture("ui_new/crossarray/img_yun.png")
        if ChuangzhenManager.choiceState[index] == ChuangzhenManager.DisTouch then
            self.btn_grid[index].img_close:setVisible(true)
            print("ChuangzhenManager.DisTouch65555555555556  stateChanged = ",stateChanged)
            if stateChanged == true then
                print("ChuangzhenManager.DisTouch")
                --self.btn_grid[index].img_close:setScale(2)
                self.btn_grid[index].img_close:setVisible(false)
                self.btn_grid[index].img_close:setScale(1)
                local acArr = TFVector:create()
                local delayAc = CCDelayTime:create(0.4)
                acArr:addObject(delayAc)
                local show = CCShow:create()
                acArr:addObject(show)
                local scaleAc = CCScaleTo:create(0.1,2.3)
                acArr:addObject(scaleAc)
                scaleAc = CCScaleTo:create(0.05,0.8)
                acArr:addObject(scaleAc)
                scaleAc = CCScaleTo:create(0.1,1.1)
                acArr:addObject(scaleAc)
                scaleAc = CCScaleTo:create(0.05,1)
                acArr:addObject(scaleAc)
                self.btn_grid[index].img_close:runAction(CCSequence:create(acArr))
            end
        else
            self.btn_grid[index].img_close:setVisible(false)
            self.btn_grid[index].img_close:stopAllActions()
        end

        if not ChuangzhenManager:canTouchOpen(index) then
            self.btn_grid[index].img_item:setTexture("ui_new/crossarray/img_yun2.png")
        end
        if self.btn_grid[index].npc then
            self.btn_grid[index].npc:removeFromParent()
            self.btn_grid[index].npc = nil
        end
    elseif ChuangzhenManager.mapState[index] == ChuangzhenManager.GridStateOpen then
        self.btn_grid[index].img_close:setVisible(false)
        self.btn_grid[index].img_close:stopAllActions()
        local elementType = ChuangzhenManager.ElementNone
        local elementId = 0
        if ChuangzhenManager.mapItemId[index] then
            elementType = ChuangzhenManager.mapItemId[index].type
            elementId = ChuangzhenManager.mapItemId[index].assId
        end
        if elementType == ChuangzhenManager.ElementBox then
            self.btn_grid[index].img_item:setVisible(false)
            if not self.btn_grid[index].box then
                self.btn_grid[index].box = self.btn_box:clone()
                self.btn_grid[index].box:setVisible(true)
                self.btn_grid[index]:addChild(self.btn_grid[index].box)
            end
            if self.btn_grid[index].npc then
                self.btn_grid[index].npc:removeFromParent()
                self.btn_grid[index].npc = nil
            end
        elseif elementType == ChuangzhenManager.ElementGuard then
            self.btn_grid[index].img_item:setVisible(false)
            if self.btn_grid[index].npc and self.btn_grid[index].npc.gridAttr ~= "guard" then
                self.btn_grid[index].npc:removeFromParent()
                self.btn_grid[index].npc = nil
            end
            if not self.btn_grid[index].npc then
                self.btn_grid[index].npc = self.btn_zhenwei:clone()
                self.btn_grid[index].npc:setTouchEnabled(false)
                self.btn_grid[index].npc:setVisible(true)
                self.btn_grid[index]:addChild(self.btn_grid[index].npc)
                self.btn_grid[index].npc.gridAttr = "guard"
            end
            self:setGuardInfo( self.btn_grid[index].npc , elementId)
        elseif elementType == ChuangzhenManager.ElementBoss then
            self.btn_grid[index].img_item:setVisible(false)
            if self.btn_grid[index].npc and self.btn_grid[index].npc.gridAttr ~= "boss" then
                self.btn_grid[index].npc:removeFromParent()
                self.btn_grid[index].npc = nil
            end
            if not self.btn_grid[index].npc then
                self.btn_grid[index].npc = self.btn_hufa:clone()
                self.btn_grid[index].npc:setTouchEnabled(false)
                self.btn_grid[index].npc:setVisible(true)
                self.btn_grid[index]:addChild(self.btn_grid[index].npc)
                self.btn_grid[index].npc.gridAttr = "boss"
            end
            self:setGuardInfo( self.btn_grid[index].npc , elementId)
        elseif elementType == ChuangzhenManager.ElementBuff then
            self.btn_grid[index].img_item:setVisible(true)
            self.btn_grid[index].img_item:setTexture("ui_new/crossarray/img_suiji1.png")
            if self.btn_grid[index].npc then
                self.btn_grid[index].npc:removeFromParent()
                self.btn_grid[index].npc = nil
            end
        else
            self.btn_grid[index].img_item:setVisible(false)
            if self.btn_grid[index].npc then
                self.btn_grid[index].npc:removeFromParent()
                self.btn_grid[index].npc = nil
            end
        end
        if buffType ~= nil and stateChanged == true then
            local acNode = nil
            local acArr = TFVector:create()
            if self.btn_grid[index].npc and self.btn_grid[index].npc:isVisible() == true then
                acNode = self.btn_grid[index].npc
            elseif self.btn_grid[index].box and self.btn_grid[index].box:isVisible() == true then
                acNode = self.btn_grid[index].box
                -- acNode:setVisible(false)
                -- acNode:setScale(0.9)
                -- acNode:setOpacity(0)
                -- local delayAc = CCDelayTime:create(0.8)
                -- acArr:addObject(delayAc)
                -- local show = CCShow:create()
                -- acArr:addObject(show)
                -- local fade = CCFadeIn:create(0.5)
                -- acArr:addObject(fade)
            end
            if acNode then
                acNode:setVisible(false)
                acNode:setScale(1)
                local delayAc = CCDelayTime:create(0.4)
                acArr:addObject(delayAc)
                local show = CCShow:create()
                acArr:addObject(show)
                local scaleAc = CCScaleTo:create(0.1,2.3)
                acArr:addObject(scaleAc)
                scaleAc = CCScaleTo:create(0.05,0.8)
                acArr:addObject(scaleAc)
                scaleAc = CCScaleTo:create(0.1,1.1)
                acArr:addObject(scaleAc)
                scaleAc = CCScaleTo:create(0.05,1)
                acArr:addObject(scaleAc)
                self.btn_grid[index].effect = self.effect_model:clone()
                local pos = ChuangzhenManager:getPositionByIndex(index)
                pos.x = pos.x + 4
                pos.y = pos.y - 10
                self.btn_grid[index].effect:setPosition(pos)
                self.btn_grid[index].effect:setVisible(true)
                self.panel_yun:addChild(self.btn_grid[index].effect,1000)
                self.btn_grid[index].effect:playByIndex(0,-1,-1,0)
                self.btn_grid[index].effect:addMEListener(TFARMATURE_COMPLETE,function()
                    self.btn_grid[index].effect:removeFromParent()
                    self.btn_grid[index].effect = nil
                end)
                acNode:runAction(CCSequence:create(acArr))
            end
        end
    elseif ChuangzhenManager.mapState[index] == ChuangzhenManager.GridStateGet then
        self.btn_grid[index].img_close:setVisible(false)
        self.btn_grid[index].img_close:stopAllActions()
        self.btn_grid[index].img_item:setVisible(false) 
        if self.btn_grid[index].npc then
            print("-1111111111111---------------------",index)
            self.btn_grid[index].npc:removeFromParent()
            self.btn_grid[index].npc = nil
        end
        if buffType ~= nil and stateChanged == true then
            local elementType = nil
            local elementId = nil
            if ChuangzhenManager.mapItemId[index] then
                elementType = ChuangzhenManager.mapItemId[index].type
                elementId = ChuangzhenManager.mapItemId[index].assId
            end
            if elementType ~= ChuangzhenManager.ElementBox then

                self.btn_grid[index].effect = self.effect_model:clone()
                local pos = ChuangzhenManager:getPositionByIndex(index)
                pos.x = pos.x + 4
                pos.y = pos.y - 10
                self.btn_grid[index].effect:setPosition(pos)
                self.btn_grid[index].effect:setVisible(true)
                self.panel_yun:addChild(self.btn_grid[index].effect,1000)
                self.btn_grid[index].effect:playByIndex(buffType,-1,-1,0)
                if buffType > 0 then
                    self.isShowBuffEffect = true
                end
                self.btn_grid[index].effect:addMEListener(TFARMATURE_COMPLETE,function()
                    if elementId and buffType > 0 then
                        ChuangzhenManager:openCrossArrayOrganLayer(elementId)
                        self.isShowBuffEffect = false
                    end
                    self.btn_grid[index].effect:removeFromParent()
                    self.btn_grid[index].effect = nil
                end)
            else
                self.btn_grid[index].effect = self.effect_box_model:clone()
                local pos = ChuangzhenManager:getPositionByIndex(index)
                pos.x = pos.x + 4
                pos.y = pos.y + 20
                self.btn_grid[index].effect:setPosition(pos)
                self.btn_grid[index].effect:setVisible(true)
                self.panel_yun:addChild(self.btn_grid[index].effect,1000)
                self.btn_grid[index].effect:playByIndex(0,-1,-1,0)
                self.btn_grid[index].effect:addMEListener(TFARMATURE_COMPLETE,function()
                    self.btn_grid[index].effect:removeFromParent()
                    self.btn_grid[index].effect = nil
                end)
            end
        end
    end
end

function CrossArrayMainLayer:setGuardInfo(npcItem , elementId)
    if elementId and elementId > 0 then
        local npcInfo = ChuangzhenManager:getNpcInfoById(elementId)
        local headIcon = TFDirector:getChildByPath(npcItem, 'img_touxiang');
        headIcon:setTexture("icon/head/".. npcInfo.image..".png")
    end
end

function CrossArrayMainLayer:onRuleClick( sender )
    CommonManager:showRuleLyaer('chuangzhen')
end

function CrossArrayMainLayer.onGridBtnClick(sender)
    local self = sender.logic;
    local index = sender.index
    if self.isShowBuffEffect == true then
        return
    end
    if ChuangzhenManager.mapState[index] == ChuangzhenManager.GridStateGet then
        print("----------------------打开的")
        return
    end
    if ChuangzhenManager.mapState[index] == ChuangzhenManager.GridStateClosed then
        if ChuangzhenManager.choiceState[index] == ChuangzhenManager.DisTouch then
            toastMessage(localizable.CrossArray_PleasePassGuard)
            return
        end
        if not ChuangzhenManager:canTouchOpen(index) then
            toastMessage(localizable.CrossArray_PleaseOpenGuard)
            return
        end
    end
    if ChuangzhenManager.mapState[index] == ChuangzhenManager.GridStateOpen then
        if ChuangzhenManager.mapItemId[index] then
            if ChuangzhenManager.mapItemId[index].type == ChuangzhenManager.ElementNone then
                print("----------------------打开的")
                return
            end
            if ChuangzhenManager.mapItemId[index].type == ChuangzhenManager.ElementGuard or ChuangzhenManager.mapItemId[index].type == ChuangzhenManager.ElementBoss then
                ChuangzhenManager:openCrossArrayArmyVsLayer(ChuangzhenManager.mapItemId[index].assId,index)
                return
            end
        end
    end
    
    ChuangzhenManager:OpenPoint( index )
end

function CrossArrayMainLayer.onResetBtnClick( sender )
    local self = sender.logic
    if self.isShowBuffEffect == true then
        return
    end
    CommonManager:showOperateSureLayer(function()
        ChuangzhenManager:GiveUpRush()
        AlertManager:close()
        end,
        nil,
        {
            msg = localizable.CrossArray_PleaseResetInfo
        })
end

function CrossArrayMainLayer:removeUI()
    self.super.removeUI(self);

    if self.btn_click then
        self.btn_click:release()
        self.btn_click = nil
    end
    if self.btn_zhenwei then
        self.btn_zhenwei:release()
        self.btn_zhenwei = nil
    end
    if self.btn_hufa then
        self.btn_hufa:release()
        self.btn_hufa = nil
    end
    if self.btn_box then
        self.btn_box:release()
        self.btn_box = nil
    end
    if self.effect_model then
        self.effect_model:release()
        self.effect_model = nil
    end
    if self.effect_box_model then
        self.effect_box_model:release()
        self.effect_box_model = nil
    end
    
end

function CrossArrayMainLayer:registerEvents()
    self.super.registerEvents(self);
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_fanhui);
    self.btn_reset.logic = self
    self.btn_reset:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onResetBtnClick))
    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRuleClick))

    self.receiveGridElementCallBack = function (event)
        local pos = event.data[1][1]
        local buffType = event.data[1][2]
        local stateChanged = event.data[1][3]
        self:setGridState( pos , buffType , stateChanged )
    end
    TFDirector:addMEGlobalListener(ChuangzhenManager.ReceiveGridElement,self.receiveGridElementCallBack)

    self.receiveOrganBuffCallBack = function (event)
        local assid = event.data[1][1]
        self:freshBuff()
        --ChuangzhenManager:openCrossArrayOrganLayer(assid)
    end
    TFDirector:addMEGlobalListener(ChuangzhenManager.ReceiveBuffElement,self.receiveOrganBuffCallBack)

    self.receiveSuccessCallBack = function (event)
        self.itemList = event.data[1][1]
        self.isLast = event.data[1][2]
        self.bShowReward = true
        if self.isShow == true then
            self.bShowReward = false
            ChuangzhenManager:openCrossArraySuccessLayer(self.itemList,self.isLast)
        end
    end
    TFDirector:addMEGlobalListener(ChuangzhenManager.ReceiveSuccess,self.receiveSuccessCallBack)

    self.receiveCloudBrushCallBack = function (event)
        local index = event.data[1][1]
        self.btn_grid[index].img_item:setTexture("ui_new/crossarray/img_yun.png")
    end
    TFDirector:addMEGlobalListener(ChuangzhenManager.ReceiveCloudBrush,self.receiveCloudBrushCallBack)
end

function CrossArrayMainLayer:removeEvents()
    self.super.removeEvents(self);
    TFDirector:removeMEGlobalListener(ChuangzhenManager.ReceiveGridElement,self.receiveGridElementCallBack)
    TFDirector:removeMEGlobalListener(ChuangzhenManager.ReceiveBuffElement,self.receiveOrganBuffCallBack)
    TFDirector:removeMEGlobalListener(ChuangzhenManager.ReceiveSuccess,self.receiveSuccessCallBack)
    TFDirector:removeMEGlobalListener(ChuangzhenManager.ReceiveCloudBrush,self.receiveCloudBrushCallBack)
    self.receiveGridElementCallBack =nil
    self.receiveOrganBuffCallBack =nil
end

return CrossArrayMainLayer;
