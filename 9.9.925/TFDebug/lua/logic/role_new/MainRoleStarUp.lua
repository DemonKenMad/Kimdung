--[[
******主角升星*******
    -- by quanhuan
    -- 2016/1/25
]]

local MainRoleStarUp = class("MainRoleStarUp",BaseLayer)

-- qimenPositionData = require('lua.table.t_s_qimen_position')

function MainRoleStarUp:ctor(data)

	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.climb.qimendun")
end

function MainRoleStarUp:initUI( ui )
	self.super.initUI(self, ui)

    self.generalHead = CommonManager:addGeneralHead(self)
    self.generalHead:setData(ModuleType.Qimendun,{HeadResType.CLIMBSTAR,HeadResType.COIN,HeadResType.SYCEE})


    self.img_bagua2 = TFDirector:getChildByPath(ui, 'img_bagua2')
    self.img_bagua = TFDirector:getChildByPath(ui, 'img_bagua')
    self.btn_bagua = TFDirector:getChildByPath(ui, 'btn_bagua')

    self.bnt_details = TFDirector:getChildByPath(ui, 'bnt_details')
    self.btn_bangzu = TFDirector:getChildByPath(ui, 'btn_bangzu')
    self.txt_power = TFDirector:getChildByPath(ui, 'txt_power')
    self.img_head = TFDirector:getChildByPath(ui, 'img_head')
    self.txt_consume = TFDirector:getChildByPath(ui, 'txt_consume')
    self.btn_zhuru = TFDirector:getChildByPath(ui, 'btn_zhuru')
    self.bnt_shengpin = TFDirector:getChildByPath(ui, 'bnt_shengpin')

    local oldNode = TFDirector:getChildByPath(ui, 'txt_tianchong2')
    self.oldDes = TFDirector:getChildByPath(ui, 'txt_tianchong2')
    self.oldLevel = TFDirector:getChildByPath(oldNode, 'txt_lv')
    self.oldAttrName = TFDirector:getChildByPath(oldNode, 'txt_wuli')
    self.oldAttrValue = TFDirector:getChildByPath(oldNode, 'Label_qimendun_1')

    local newNode = TFDirector:getChildByPath(ui, 'txt_tianchong1')
    self.newDes = TFDirector:getChildByPath(ui, 'txt_tianchong1')
    self.newLevel = TFDirector:getChildByPath(newNode, 'txt_lv')
    self.newAttrName = TFDirector:getChildByPath(newNode, 'txt_wuli')
    self.newAttrValue = TFDirector:getChildByPath(newNode, 'Label_qimendun_1')

    self.img_zhibiao = TFDirector:getChildByPath(ui, 'img_zhibiao')

    self.txtNumTbl = {}
    for i = 1, 3 do
        self.txtNumTbl[i] = {}
        for j=1,i do
            self.txtNumTbl[i][j] = TFDirector:getChildByPath(ui, 'txtNum'..i..j)
        end
    end

    local selectPosY = {10,10,10}
    local selectPosX = {-2,-4,-6}
    self.effectSelect = {}
    for i=1,3 do
        local abc = i-1
        local filePath = "effect/mainrole/select.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(filePath)
        local effect = TFArmature:create("select_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(abc, -1, -1, 1)
        effect:setVisible(true)
        local contentSize = self.img_zhibiao:getContentSize()
        local offsetX = contentSize.width/2
        local offsetY = contentSize.height/2
        effect:setPosition(ccp(offsetX+selectPosX[i],offsetY+210+selectPosY[i]))
        self.img_zhibiao:addChild(effect,100)
        self.effectSelect[i] = effect
    end

    self.effectBuf = {}
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/mainrole/light.xml")
    local effectMode = TFArmature:create("light_anim")
    for i=1,24 do
        local abc = math.ceil(i/8) - 1
        local effect = effectMode:clone()
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(abc, -1, -1, 1)
        effect:setVisible(false)
        effect:setRotation(360-(i-1)%8*45)
        effect:setPosition(ccp(0,0))
        self.btn_bagua:addChild(effect)
        self.effectBuf[i] = effect
    end
end

function MainRoleStarUp:removeUI()
	self.super.removeUI(self)
end

function MainRoleStarUp:onShow()
    self.super.onShow(self)

    self.generalHead:onShow()

    local info = CardRoleManager:getQimenInfo()
    if info then
        self:setDataInfoAll(info.idx, info.level)
        self:showMainPlayerInfo()
        self:showRightDetails(info.idx+1, info.level)
        self:showTitleName() 
    end

end

function MainRoleStarUp:registerEvents()

    if self.registerEventCallFlag then
        return
    end
	self.super.registerEvents(self)

    if self.generalHead then
        self.generalHead:registerEvents()
    end
    self.btn_zhuru:setTouchEnabled(true)

    self.btn_bagua:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onTopuBtnClickHandle),1)
    self.btn_bagua.logic = self
    self.bnt_details:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onDetailsClickHandle),1)
    self.bnt_details.logic = self
    self.btn_bangzu:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onHelpClickHandle),1)
    self.btn_bangzu.logic = self
    self.btn_zhuru:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onZhuruClickHandle),1)
    self.btn_zhuru.logic = self

    self.bnt_shengpin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShenPinBtnClickHandle),1)
    self.bnt_shengpin.logic = self
    
    local cardRole = CardRoleManager:getRoleById(MainPlayer.profession)

    local bCanGradeUp = CardRoleManager:getShengPingByCard(cardRole)
    if bCanGradeUp then
        self.bnt_shengpin:setVisible(true)
        if self.bnt_shengpin.effect == nil then
            local cardRole = CardRoleManager:getRoleById(MainPlayer.profession)
            local config = QualityDevelopConfig:objectByID(cardRole.id)
            local info = CardRoleManager:getQimenInfo() or {}
            local currLevel = info.level or 0

            if currLevel >= config.qimen and cardRole.starlevel >= config.star_level then
                local effect = Public:addBtnWaterEffect(self.bnt_shengpin, true,1)
                effect:setScale(0.7)
                -- self.bnt_shengpin.effect = effect
            end
        end
    else
        self.bnt_shengpin:setVisible(false)
    end

    self.qimenInjectCallBack = function (event)

        play_chongxue()

        local info = CardRoleManager:getQimenInfo()
        self.btn_zhuru:setTouchEnabled(false)
        if self.injectEffect then
            self.injectEffect:removeMEListener(TFARMATURE_UPDATE) 
            self.injectEffect:removeMEListener(TFARMATURE_COMPLETE)
            self.injectEffect:removeFromParent()
            self.injectEffect = nil
        end
        local currIdx = (math.floor((info.idx-1)/8))%3
        local selectPosY = {16,6,10}
        local selectPosX = {-5,6,-4}
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/mainrole/zhuru.xml")
        local effect = TFArmature:create("zhuru_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(currIdx, -1, -1, 0)
        effect:setVisible(true)
        local contentSize = self.img_zhibiao:getContentSize()
        local offsetX = contentSize.width/2
        local offsetY = contentSize.height/2
        effect:setPosition(ccp(offsetX+selectPosX[currIdx+1],offsetY+210+selectPosY[currIdx+1]))        
        self.img_zhibiao:addChild(effect,100)
        self.injectEffect = effect
        local frameIdx = 0
        self.injectEffect:addMEListener(TFARMATURE_UPDATE, function ()
            frameIdx = frameIdx + 1
            -- print('frameIdx = ',frameIdx)
            if frameIdx == 10 then
                self:setDataInfoForLevel(info.idx, info.level)
                self:showMainPlayerInfo()
            end
        end)
        self.injectEffect:addMEListener(TFARMATURE_COMPLETE, function ()                
                -- toastMessage('开始旋转')
                play_baguazhuandong()

                self.injectEffect:removeMEListener(TFARMATURE_UPDATE)
                self.injectEffect:removeMEListener(TFARMATURE_COMPLETE) 
                self.injectEffect:removeFromParent()
                self.injectEffect = nil
                self:playRotateAnim()            
        end)
        local str = TFLanguageManager:getString(ErrorCodeData.Gossip_Upgrade_success)
        local templete = QimenConfigData:getObjectAt(info.idx)
        str = string.format(str, templete.name)
        toastMessage(str)

        self:addResultEffect(self.btn_zhuru,'equipment_refining')
        if (self.generalHead) then
            self.generalHead:refreshUI()
        end
    end
    TFDirector:addMEGlobalListener(CardRoleManager.QIMEN_INJECT_SUCCESS, self.qimenInjectCallBack)  



    self.roleStarUpResultCallBack = function (event)
        Public:addBtnWaterEffect(self.bnt_shengpin, false,1)
        local cardRole = CardRoleManager:getRoleById(MainPlayer.profession)

        local bCanGradeUp = CardRoleManager:getShengPingByCard(cardRole)
        self.bnt_shengpin:setVisible(bCanGradeUp)
    end
    TFDirector:addMEGlobalListener(CardRoleManager.ROLE_BREAKTHROUGH_RESULT,self.roleStarUpResultCallBack)


    self.registerEventCallFlag = true 
end

function MainRoleStarUp:refreshRole()
    local cardRole = CardRoleManager:getRoleByGmid( self.gmId )
    self.cardRole = clone(cardRole)
    if (self.generalHead) then
        self.generalHead:refreshUI()
    end
end

function MainRoleStarUp:removeEvents()

    self.super.removeEvents(self)

	if self.generalHead then
        self.generalHead:removeEvents()
    end
 	
    TFDirector:removeMEGlobalListener(CardRoleManager.QIMEN_INJECT_SUCCESS, self.qimenInjectCallBack)  
    self.qimenInjectCallBack = nil

    TFDirector:removeMEGlobalListener(CardRoleManager.ROLE_BREAKTHROUGH_RESULT,self.roleStarUpResultCallBack)
    self.roleStarUpResultCallBack = nil

    if self.injectEffect then
        self.injectEffect:removeMEListener(TFARMATURE_UPDATE) 
        self.injectEffect:removeMEListener(TFARMATURE_COMPLETE)        
        self.injectEffect:removeFromParent()
        self.injectEffect = nil
    end

    if self.rightEffect then
        self.rightEffect:removeMEListener(TFARMATURE_COMPLETE)
        self.rightEffect:removeFromParent()
        self.rightEffect = nil
    end

    if self.soundTimer then
        TFDirector:removeTimer(self.soundTimer)
        self.soundTimer = nil
    end

    self.registerEventCallFlag = nil  
end

function MainRoleStarUp:dispose()
	self.super.dispose(self)
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
end

function MainRoleStarUp.onCloseClickHandle( btn )
    AlertManager:close()
end
function MainRoleStarUp.onStartClickHandle( btn )
    local self = btn.logic
    self:playRotateAnim()
end

function MainRoleStarUp:playRotateAnim()
    --setRotation
    local currRotate = self.img_bagua2:getRotation()
    currRotate = currRotate + 45
    self.tweenEquipA = {
        target = self.img_bagua2,
        {
            duration = 0.5,
            rotate = currRotate,
        },
        {
            duration = 0,                
            onComplete = function ()
                TFDirector:killTween(self.tweenEquipA)
                self.btn_zhuru:setTouchEnabled(true)
                local info = CardRoleManager:getQimenInfo()
                -- self:showRightDetails(info.idx+1, info.level)
                self:showMainPlayerInfo()
                if CardRoleManager:checkCanBreach(info.idx, info.level) then
                    for i=1,3 do
                        self.effectSelect[i]:setVisible(false)
                    end
                else
                    local currIdx = (math.floor(info.idx/8))%3 + 1
                    for i=1,3 do
                        if i == currIdx then
                            self.effectSelect[i]:setVisible(true)
                        else
                            self.effectSelect[i]:setVisible(false)
                        end
                    end
                end
            end,
        },
    }
    self.tweenEquipB = {
        target = self.btn_bagua,
        {
            duration = 0.5,
            rotate = currRotate,
        },
        {
            duration = 0,                
            onComplete = function ()
                TFDirector:killTween(self.tweenEquipB)
                self.btn_zhuru:setTouchEnabled(true)
            end,
        },
    }
    TFDirector:toTween(self.tweenEquipA)
    TFDirector:toTween(self.tweenEquipB)
end

function MainRoleStarUp:setDataInfoAll(idx, level)

    -- print('idx = ',idx)
    -- print('level = ',level)
    local currIdx = idx%24
    if self.breachViewEffect == nil then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/mainrole/breachview.xml")
        local effect = TFArmature:create("breachview_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        effect:setVisible(true)
        self.btn_bagua:addChild(effect,101)
        self.breachViewEffect = effect        
    end
    self.breachViewEffect:setVisible(false)
    self:playEffectAudio(false)
    if CardRoleManager:checkCanBreach(idx, level) then
        currIdx = 30
        self.breachViewEffect:setVisible(true)
        self:playEffectAudio(true)
    end
    for i=1,24 do
        if i <= currIdx then
            self.effectBuf[i]:setVisible(true)
        else
            self.effectBuf[i]:setVisible(false)
        end
    end
    if CardRoleManager:checkCanBreach(idx, level) then
        for i=1,3 do
            self.effectSelect[i]:setVisible(false)
        end
    else
        local currIdx = (math.floor(idx/8))%3 + 1
        for i=1,3 do
            if i == currIdx then
                self.effectSelect[i]:setVisible(true)
            else
                self.effectSelect[i]:setVisible(false)
            end
        end
    end

    self.btn_bagua:setRotation((idx%8)*45)
    self.img_bagua2:setRotation((idx%8)*45)   
end


function MainRoleStarUp:setDataInfoForLevel(idx, level)
    local currIdx = idx%24
    if self.breachViewEffect == nil then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/mainrole/breachview.xml")
        local effect = TFArmature:create("breachview_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        effect:setVisible(true)
        self.btn_bagua:addChild(effect,101)
        self.breachViewEffect = effect        
    end
    self.breachViewEffect:setVisible(false)
    self:playEffectAudio(false)
    if CardRoleManager:checkCanBreach(idx, level) then
        currIdx = 30
        self.breachViewEffect:setVisible(true)

        self:playEffectAudio(true)
    end

    --先加特效
    for i=1,24 do
        if i <= currIdx then
            self.effectBuf[i]:setVisible(true)
        else
            self.effectBuf[i]:setVisible(false)
        end
    end
    for i=1,3 do
        self.effectSelect[i]:setVisible(false)
    end    
end

function MainRoleStarUp:showMainPlayerInfo()
    local roleid = MainPlayer:getProfession()
    local role = CardRoleManager:getRoleById(roleid)

    self.img_head:setTexture(role:getBigImagePath())
    self.txt_power:setText(role:getpower())
end
function MainRoleStarUp.onTopuBtnClickHandle(btn)
    local self = btn.logic
    local layer  = require("lua.logic.role_new.qimenduntupoLayer"):new()
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    AlertManager:show()
end
function MainRoleStarUp.onShenPinBtnClickHandle(btn)
    -- local layer  = AlertManager:addLayerByFile("lua.logic.role_new.RoleQualityUpLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    -- AlertManager:show()
    local self = btn.logic
    local cardRole = CardRoleManager:getRoleById(MainPlayer.profession)
    local layer =  AlertManager:addLayerByFile("lua.logic.role_new.RoleGradeUp", AlertManager.BLOCK_AND_GRAY)
    layer:loadData(cardRole.gmId,self)
    AlertManager:show()

end
function MainRoleStarUp.onDetailsClickHandle(btn)
    local roleid = MainPlayer:getProfession()
    local cardRole = CardRoleManager:getRoleById(roleid)
    CardRoleManager:openMainPlayerShuxingLayer(cardRole)
end
function MainRoleStarUp.onHelpClickHandle(btn)
    CommonManager:showRuleLyaer( 'qimendun' )
end
function MainRoleStarUp.onZhuruClickHandle(btn)
    local self = btn.logic
    local info = CardRoleManager:getQimenInfo()
    if CardRoleManager:checkCanBreach(info.idx, info.level) then
        toastMessage(localizable.Gossip_Breach)
        return
    end    
    local newInfo = QimenConfigData:getObjectAt(info.idx+1) or {}
    if newInfo.climb_star > MainPlayer:getClimbStarValue() then
        toastMessage(localizable.Gossip_No_Prop)
        return
    end
    CardRoleManager:requestQimenInject()
    -- CardRoleManager:test()
end
function MainRoleStarUp:getAttrDes(type, attrIdx)
    local str = ''
    if type == 1 then
        str = AttributeTypeStr[attrIdx]
    else
        str = SkillBuffHurtStr[attrIdx]
    end
    return str
end
function MainRoleStarUp:showRightDetails(idx, level)

    local newInfo = QimenConfigData:getObjectAt(idx+24)
    local oldInfo = QimenConfigData:getObjectAt(idx)
    if idx > QimenConfigData:length() then
        self.newDes:setVisible(false)        
        self.oldDes:setVisible(false)
        self.btn_zhuru:setTouchEnabled(false)
        self.btn_zhuru:setGrayEnabled(true)
        return
    end
    if idx <= 24 then
        oldInfo = nil
        newInfo = QimenConfigData:getObjectAt(idx)
    end
    if newInfo == nil then
        self.newDes:setVisible(false)        
        self.oldDes:setVisible(true)
        local attrInfo = oldInfo:getAttributeValue()
        if attrInfo.percent then
            self.oldAttrValue:setText(math.floor(math.abs(attrInfo.value/100)) .. '%')
        else
            self.oldAttrValue:setText(attrInfo.value)
        end        
        self.oldDes:setText(oldInfo.name)
        self.oldLevel:setText('LV +'.. level)
        self.oldAttrName:setText(self:getAttrDes(attrInfo.type, attrInfo.index))        
    elseif oldInfo == nil then
        self.newDes:setVisible(true)        
        self.oldDes:setVisible(true)
        local attrInfo = newInfo:getAttributeValue()
        if attrInfo.percent then
            self.oldAttrValue:setText(math.floor(0/100) .. '%')
            self.newAttrValue:setText(math.floor(math.abs(attrInfo.value/100)) .. '%')
        else
            self.oldAttrValue:setText(0)
            self.newAttrValue:setText(attrInfo.value)
        end        
        self.oldDes:setText(newInfo.name)
        self.oldLevel:setText('LV +'.. level)    
        self.oldAttrName:setText(self:getAttrDes(attrInfo.type, attrInfo.index))
        self.newDes:setText(newInfo.name)
        self.newLevel:setText('LV +'.. level+1)    
        self.newAttrName:setText(self:getAttrDes(attrInfo.type, attrInfo.index))        
    else
        
        local newAttrInfo = newInfo:getAttributeValue()
        local oldAttrInfo = oldInfo:getAttributeValue()

        if newAttrInfo.percent then
            self.newAttrValue:setText(math.floor(math.abs(newAttrInfo.value/100)) .. '%')
        else
            self.newAttrValue:setText(newAttrInfo.value)
        end
        self.newDes:setVisible(true)      
        self.newDes:setText(newInfo.name)  
        self.newLevel:setText('LV +'.. newInfo.level-1)    
        self.newAttrName:setText(self:getAttrDes(newAttrInfo.type, newAttrInfo.index))

        if oldAttrInfo.percent then
            self.oldAttrValue:setText(math.floor(math.abs(oldAttrInfo.value/100)) .. '%')
        else
            self.oldAttrValue:setText(oldAttrInfo.value)
        end
        self.oldDes:setVisible(true)     
        self.oldDes:setText(oldInfo.name)   
        self.oldLevel:setText('LV +'.. oldInfo.level-1)    
        self.oldAttrName:setText(self:getAttrDes(oldAttrInfo.type, oldAttrInfo.index))
    end
    local consume = 0
    if newInfo and newInfo.climb_star then
        consume = newInfo.climb_star
    elseif oldInfo and oldInfo.climb_star then
        consume = oldInfo.climb_star
    end
    self.txt_consume:setText(consume)
end

function MainRoleStarUp:showTitleName()
    local info = CardRoleManager:getQimenInfo() or {}
    local currLevel = info.level or 0
    currLevel = currLevel + 1
    local strLevel = numberToChineseTable(currLevel)   
    local strLength = #strLevel
    for i=1,3 do
        self.txtNumTbl[i][1]:setVisible(true)
        if i == strLength then
            for j=1,i do
                self.txtNumTbl[i][j]:setText(strLevel[j])
            end            
        else
            self.txtNumTbl[i][1]:setVisible(false)
        end
    end
end

function MainRoleStarUp:addResultEffect( widget, effectName ) 

    if self.rightEffect then
        self.rightEffect:removeMEListener(TFARMATURE_COMPLETE)
        self.rightEffect:removeFromParent()
        self.rightEffect = nil
    end

    TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/"..effectName..".xml")
    local effect = TFArmature:create(effectName.."_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    widget:getParent():addChild(effect)
    effect:setPosition(ccp(widget:getPositionX()-20,widget:getPositionY()+150))
    effect:setScaleX(0.5)
    effect:setZOrder(100)
    self.rightEffect = effect
    self.rightEffect:playByIndex(0, -1, -1, 0)

    effect:addMEListener(TFARMATURE_COMPLETE,function()
        self.rightEffect:removeFromParent()
        self.rightEffect = nil
        local info = CardRoleManager:getQimenInfo()
        self:showRightDetails(info.idx+1, info.level)
    end)
end

function MainRoleStarUp:playEffectAudio( enable )
    if self.soundTimer then
        TFDirector:removeTimer(self.soundTimer)
        self.soundTimer = nil
    end
    if enable == false then
        return
    end
    TFAudio.playEffect("sound/effect/chuangong-hunpoyidong.mp3",false)
    self.soundTimer = TFDirector:addTimer(3000,-1,nil,function ( )
        if self:getTopLayer() == self then
            TFAudio.playEffect("sound/effect/chuangong-hunpoyidong.mp3",false)
        else
            TFDirector:removeTimer(self.soundTimer)
            self.soundTimer = nil
        end
    end)
end

function MainRoleStarUp:getTopLayer()
    local currentScene = Public:currentScene()
    if currentScene ~= nil and currentScene.getTopLayer then
        return currentScene:getTopLayer()
    else
        return nil
    end
end
return MainRoleStarUp