-- client side JiayuanBaseLayer.lua
--[[
 * @Description: 家园主界面
 ]]
-- script writer wuqi
-- creation time 2016-07-15

local JiayuanBaseLayer = class("JiayuanBaseLayer", BaseLayer)
local HelpDesc = localizable.InFriendLayerNew_desc;

JiayuanBaseLayer.kDaojuMaxNum = 4

JiayuanBaseLayer.DAOJU_ID = {30149, 30150, 30151, 30152}

function JiayuanBaseLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.qiyu.FamilyBaseLayer")   
    self.attr_layer_show = false   
end

function JiayuanBaseLayer:initUI(ui)
    self.super.initUI(self, ui)
    
    self.btn_return = TFDirector:getChildByPath(ui, "btn_return")
    self.btn_return.logic = self
    self.btn_help = TFDirector:getChildByPath(ui, "btn_bangzu")
    self.btn_help.logic = self
    self.btn_zhuanpan = TFDirector:getChildByPath(ui, "btn_zp")
    self.btn_zhuanpan.logic = self
    self.btn_jyzjc = TFDirector:getChildByPath(ui, "btn_jyzjc")
    self.btn_jyzjc.logic = self
    self.btn_hyph = TFDirector:getChildByPath(ui, "btn_hyph")
    self.btn_hyph.logic = self
    self.btn_fkjl = TFDirector:getChildByPath(ui, "btn_fkjl")
    self.btn_fkjl.logic = self

    self.panel_ac = TFDirector:getChildByPath(ui, "panel_ac")
    self.btn_baoxiang = TFDirector:getChildByPath(ui, "btn_baoxiang")
    self.btn_zan_1 = TFDirector:getChildByPath(ui, "btn_zan_1")
    self.btn_zan_1:setVisible(false)
    --家园总加成
    self.panel_jyzjc = TFDirector:getChildByPath(ui, "panel_jyzjc")
    self.img_attr_di = TFDirector:getChildByPath(self.panel_jyzjc, "Img_bg")

    -- 基本属性
    local panel_arr = TFDirector:getChildByPath(ui, "panel_jingmaixiangqing")
    self.txt_arr_base = {}
    self.txt_arr_base[EnumAttributeType.Blood]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_qixue"),"txt_base")
    self.txt_arr_base[EnumAttributeType.Force]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_wuli"),"txt_base")
    self.txt_arr_base[EnumAttributeType.Defence] =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_fangyu"),"txt_base")
    self.txt_arr_base[EnumAttributeType.Magic]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_neili"),"txt_base")
    self.txt_arr_base[EnumAttributeType.Agility] =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_shenfa"),"txt_base")

    self.txt_arr_add = {}
    self.txt_arr_add[EnumAttributeType.Blood]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_qixue"),"txt_add")
    self.txt_arr_add[EnumAttributeType.Force]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_wuli"),"txt_add")
    self.txt_arr_add[EnumAttributeType.Defence] =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_fangyu"),"txt_add")
    self.txt_arr_add[EnumAttributeType.Magic]   =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_neili"),"txt_add")
    self.txt_arr_add[EnumAttributeType.Agility] =  TFDirector:getChildByPath(TFDirector:getChildByPath(panel_arr, "img_shenfa"),"txt_add")
    self.rightPanel_arr = TFDirector:getChildByPath(ui, "panel_attr")
    -- self.rightPanel_extendedArr  = TFDirector:getChildByPath(ui, "panel_extendedattribute")
    self.rightPanel_firend  = TFDirector:getChildByPath(ui, "Panel_hyph")
    self.cellModel = TFDirector:getChildByPath(self.rightPanel_firend, "img_liebiaobg")
    self.cellModel:retain()
    self.cellModel:removeFromParent()
    --拓展属性
    for i = EnumAttributeType.Crit, EnumAttributeType.Miss do
        local node = TFDirector:getChildByPath(ui, "panel_shuxing" .. i)
        if node then
            local percentNode = TFDirector:getChildByPath(node, "txt_percent")
            print("percentNode = ", percentNode)
            if percentNode then
                local posX = percentNode:getPositionX()
                percentNode:setPositionX(posX + 20)
            end
        end
    end

    --上面进度条
    self.img_level = TFDirector:getChildByPath(ui, "img_level")
    local txt_mylevel = TFDirector:getChildByPath(ui, "txt_mylevel")
    self.txt_jiayuanLv_0 = TFDirector:getChildByPath(txt_mylevel, "txt_number")
    --家园等级
    self.txt_jiayuanLv = TFDirector:getChildByPath(self.img_level, "txt_num")
    self.txt_jiayuanLv:setText("Lv" .. "0")
    self.btn_lvAdd = TFDirector:getChildByPath(self.img_level, "btn_djjc")
    self.btn_lvAdd.logic = self
    self.bar_exp = TFDirector:getChildByPath(self.img_level, "bar_exp1")
    self.txt_jindu = TFDirector:getChildByPath(self.img_level, "txt_jindu")
    self.txt_jiayuan_name = TFDirector:getChildByPath(self.img_level, "txt_name")
    self.txt_jiayuan_name:setText(localizable.Jiayuan_home_name_1)
    --下面材料
    self.panel_daoju = {}
    for i = 1, self.kDaojuMaxNum do
        self.panel_daoju[i] = TFDirector:getChildByPath(ui, "panel_daoju" .. i)
        self.panel_daoju[i].img_quality = TFDirector:getChildByPath(self.panel_daoju[i], "img_quality")
        self.panel_daoju[i].img_icon = TFDirector:getChildByPath(self.panel_daoju[i], "img_icon")
        self.panel_daoju[i].txt_num_daoju = TFDirector:getChildByPath(self.panel_daoju[i], "txt_number")
        self.panel_daoju[i].img_jyan = TFDirector:getChildByPath(self.panel_daoju[i], "img_jyan")
        self.panel_daoju[i].txt_num_exp = TFDirector:getChildByPath(self.panel_daoju[i].img_jyan, "txt_num")
    end

    self.origin_pos_x = self.img_attr_di:getPositionX()

    self.img_heidi = TFDirector:getChildByPath(ui, "img_heidi")
    self.btn_djjc = TFDirector:getChildByPath(self.img_heidi, "btn_djjc")
    self.btn_djjc.logic = self

    self.message_layer_model = createUIByLuaNew("lua.uiconfig_mango_new.common.ToastMessage")
    self.message_layer_model:retain()

    self.sprite_mode = CCSprite:create('ui_new/qiyu/family/img_sjcg.png')
    self.sprite_mode:retain()

    TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/equipment_refining.xml")
    self.effect_model = TFArmature:create("equipment_refining_anim")
    self.effect_model:setAnimationFps(GameConfig.ANIM_FPS)
    self.effect_model:retain()

    self.isMoved = false
    self.isShowStart = false
    self.isShowing = false
end

function JiayuanBaseLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function JiayuanBaseLayer:registerEvents(ui)
    print("JiayuanBaseLayer:registerEvents-------->>>>>>>>>>>>>")
    self.super.registerEvents(self)

    function onTouchBegin(widget,pos,offset)
        self.touchLongToolNum = 1
        self.touchLongToolId = widget.goodId
        self.touchLongBtnIndex = widget.showIndex
        self.isSendDataToServer = false
        self:createLongTouch(widget.showIndex)
    end
    function onTouchEnd(widget,pos)
        self:deleteTouch()
    end    
    for i = 1, self.kDaojuMaxNum do 
        self.panel_daoju[i].img_quality:setTouchEnabled(true) 
        self.panel_daoju[i].img_quality:addMEListener(TFWIDGET_TOUCHBEGAN, onTouchBegin)
        self.panel_daoju[i].img_quality:addMEListener(TFWIDGET_TOUCHENDED, onTouchEnd)              
        self.panel_daoju[i].img_quality.logic = self
        self.panel_daoju[i].img_quality.showIndex = i
    end

    self.btn_return:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onReturnClickHandle), 1)
    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onHelpClickHandle), 1)
    self.btn_zhuanpan:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onZhuanpanClickHandle), 1)
    self.btn_hyph:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShowFriendClickHandle), 1)
    self.btn_jyzjc:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onAttrAddClickHandle), 1)
    self.btn_lvAdd:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onLvAddClickHandle), 1)
    self.btn_djjc:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onOneKeyLvUpClick), 1)
    self.btn_baoxiang:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBoxClickClick), 1)
    self.btn_fkjl:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRecordClick), 1)
    self.onReceiveFriendPraiseRanks = function (event)
        self:reloadFriendList()
    end
    TFDirector:addMEGlobalListener(QiyuManager.Receive_Friend_Praise_Ranks, self.onReceiveFriendPraiseRanks)

    self.onReceiveFriendPraiseFresh = function (event)
        self:reloadFriendList()
    end
    TFDirector:addMEGlobalListener(QiyuManager.Receive_Friend_Praise_Fresh, self.onReceiveFriendPraiseFresh)

    self.onReceiveDrawHomeAwardScuess = function (event)
        self:showBox()
    end
    TFDirector:addMEGlobalListener(QiyuManager.Receive_Draw_HomeAward_Scuess, self.onReceiveDrawHomeAwardScuess)

    self.updateUserDataCallBack = function(event)
        self:refreshZanInfo()
    end
    TFDirector:addMEGlobalListener(MainPlayer.ChallengeTimesChange ,self.updateUserDataCallBack)
    self.friendUpdateList = function(event)
        QiyuManager:requestFriendPraiseRanks()
    end
    TFDirector:addMEGlobalListener(FriendManager.UpdateList, self.friendUpdateList)
end

function JiayuanBaseLayer:removeUI()
    if self.cellModel then
        self.cellModel:release()
        self.cellModel = nil
    end
    if self.message_layer_model then
        self.message_layer_model:release()
        self.message_layer_model = nil
    end

    if self.sprite_mode then
        self.sprite_mode:release()
        self.sprite_mode = nil
    end

    if self.effect_model then
        self.effect_model:release()
        self.effect_model = nil
    end
end
function JiayuanBaseLayer:removeEvents()
    print("JiayuanBaseLayer:removeEvents()-->>>")
    self.super.removeEvents(self)
    TFDirector:removeMEGlobalListener(QiyuManager.Receive_Friend_Praise_Ranks, self.onReceiveFriendPraiseRanks)
    TFDirector:removeMEGlobalListener(QiyuManager.Receive_Friend_Praise_Fresh, self.onReceiveFriendPraiseFresh)
    TFDirector:removeMEGlobalListener(QiyuManager.Receive_Draw_HomeAward_Scuess, self.onReceiveDrawHomeAwardScuess)
    TFDirector:removeMEGlobalListener(MainPlayer.ChallengeTimesChange ,self.updateUserDataCallBack)
    TFDirector:removeMEGlobalListener(FriendManager.UpdateList, self.friendUpdateList)
    self.onReceiveFriendPraiseRanks = nil
    self.onReceiveDrawHomeAwardScuess = nil
    self.updateUserDataCallBack = nil
    self.friendUpdateList = nil
end

function JiayuanBaseLayer:deleteTouch()
    if self.delayLongTouchTimer then
        TFDirector:removeTimer(self.delayLongTouchTimer)
        self.delayLongTouchTimer = nil
    end
    if self.touchLongTimer then
        TFDirector:removeTimer(self.touchLongTimer)
        self.touchLongTimer = nil
    end

    if self.isSendDataToServer == false then
        local curr_num = BagManager:getItemNumById( self.touchLongToolId )
        if QiyuManager:getJiayuanLevel() >= QiyuManager.Jiayuan_MaxLevel then
            toastMessage(localizable.Jiayuan_level_max)
        elseif curr_num >= self.touchLongToolNum then
            local function flyMoveCallBack()
            end

            local data = {}
            local tab = {}
            --tab.id = self.touchLongToolId
            --tab.num = self.touchLongToolNum
            tab[1] = self.touchLongToolId
            tab[2] = self.touchLongToolNum
            table.insert(data, tab)
            QiyuManager:requestJiayuanLevelUp(data)

            self:showFlyBegin(self.touchLongBtnIndex, flyMoveCallBack)
        else
            toastMessage(localizable.Jiayuan_daoju_not_enough)
        end
    end
    self.isSendDataToServer = true    
end

function JiayuanBaseLayer:showFlyBegin(pos, flyMoveCallBack)
    play_chuangonghunpoyidong()

    local topos = self.panel_daoju[pos].img_quality:convertToWorldSpace(ccp(0, 0))
    local resPath = "effect/role_transfer_begin.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local flyPic = TFArmature:create("role_transfer_begin_anim")

    flyPic:setAnimationFps(GameConfig.ANIM_FPS)
    flyPic:setPosition(ccp(topos.x + 80 , topos.y - 55))
    flyPic:setScale(0.8)

    self:addChild(flyPic,100)
    self.isMoved = false
    self.isShowStart = true
    self.isShowing = false
    flyPic:addMEListener(TFARMATURE_COMPLETE,function()
        flyPic:removeFromParentAndCleanup(true)
        flyPic:removeMEListener(TFARMATURE_COMPLETE) 
    end)
    local temp = 0
    flyPic:addMEListener(TFARMATURE_UPDATE,function()
        temp = temp + 1
        if temp == 2 then
            self:showFlyMove(pos,flyMoveCallBack)
        end
    end)

    flyPic:playByIndex(0, -1, -1, 0)
end

function JiayuanBaseLayer:showFlyMove(pos, flyMoveCallBack)
    play_chuangonghunpoyidong()

    local topos = self.panel_daoju[pos].img_quality:convertToWorldSpace(ccp(0,0))

    local resPath = "effect/role_transfer_move.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local moveEffect = TFArmature:create("role_transfer_move_anim")

    moveEffect:setAnimationFps(GameConfig.ANIM_FPS)
    moveEffect:setPosition(ccp(topos.x + 70, topos.y))

    self:addChild(moveEffect,100)

    moveEffect:playByIndex(0, -1, -1, 1)

    local toPos = self.bar_exp:convertToWorldSpace(ccp(0,0))
    local tween = 
    {
        target = moveEffect,
        {
            ease = {type=TFEaseType.EASE_IN_OUT, rate=9},
            duration = 0.2,
            x = toPos.x - 270,
            y = toPos.y,
            onComplete = function ()
                self.isMoved = true
                if self.isShowing == true then
                    self:showFlyEnd()
                end

                moveEffect:removeFromParentAndCleanup(true)
                flyMoveCallBack()
            end,
        },
    }
    TFDirector:toTween(tween)
end

function JiayuanBaseLayer:showFlyEnd()
    self.isMoved = false
    self.isShowing = false
    self.isShowStart = false
    if self.endEffect == nil then
        local resPath = "effect/role_transfer_end.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local endEffect = TFArmature:create("role_transfer_end_anim")

        endEffect:setAnimationFps(GameConfig.ANIM_FPS)
        endEffect:setPosition(ccp(100, 275))
        self.bar_exp:addChild(endEffect,100)
        
        endEffect:addMEListener(TFARMATURE_COMPLETE,function()
            endEffect:removeMEListener(TFARMATURE_COMPLETE) 
            endEffect:removeFromParentAndCleanup(true)
            self.endEffect = nil
        end)
        endEffect:playByIndex(0, -1, -1, 0)
        self.endEffect = endEffect
        local callFuncN = CCCallFuncN:create( function()
            if self.equipLevelUpEffect == nil then
                self:refreshJindu()
            end
        end)
        local acArr = TFVector:create()
        local delayAc = CCDelayTime:create(0.2)
        acArr:addObject(delayAc)
        acArr:addObject(callFuncN)
        self.endEffect:runAction(CCSequence:create(acArr))
    end
end

function JiayuanBaseLayer:playeLevelUpEffect()
    self.isMoved = false
    self.isShowing = false
    self.isShowStart = false
    if self.endEffect then
        self.endEffect:removeMEListener(TFARMATURE_COMPLETE) 
        self.endEffect:removeFromParentAndCleanup(true)
        self.endEffect = nil
    end

    if self.equipLevelUpEffect then
        self.equipLevelUpEffect:removeMEListener(TFARMATURE_COMPLETE) 
        self.equipLevelUpEffect:removeFromParentAndCleanup(true)
        self.equipLevelUpEffect = nil
    end
    local level = self.level - 1
    local currExp = self.exp
    local maxExp = FamilyData:getExpByLevel(self.level)

    self.bar_exp:setPercent(100)
    self.txt_jindu:setText(( maxExp + currExp ) .. '/' .. maxExp)

    self.txt_jiayuanLv:setText("Lv" .. level)

    TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
    local effect = TFArmature:create("equipIntensify_3_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    local width = self.bar_exp:getContentSize().width
    effect:setPosition(ccp(-width/2,-60))
    effect:setScaleX(1.15)
    self.bar_exp:addChild(effect,100)

    effect:addMEListener(TFARMATURE_COMPLETE,function()
        effect:removeMEListener(TFARMATURE_COMPLETE) 
        effect:removeFromParentAndCleanup(true)
        self.equipLevelUpEffect = nil
        self:refreshJindu()
    end)

    effect:playByIndex(0, -1, -1, 0)

    self.equipLevelUpEffect = effect

    if self.equipLevelUpAcNode ~= nil then
        self.equipLevelUpAcNode:removeFromParentAndCleanup(true)
    end
    self.equipLevelUpAcNode = CCNode:create()
    self.panel_ac:addChild(self.equipLevelUpAcNode,10)

    local effect0 = self.effect_model:clone()
    effect0:setPosition(ccp(-32,260))
    effect0:playByIndex(0, -1, -1, 0)
    self.equipLevelUpAcNode:addChild(effect0)
    local effect1 = self.effect_model:clone()
    effect1:setPosition(ccp(338,260))
    effect1:playByIndex(0, -1, -1, 0)
    self.equipLevelUpAcNode:addChild(effect1)
    local effect2 = self.effect_model:clone()
    effect2:setPosition(ccp(708,260))
    effect2:playByIndex(0, -1, -1, 0)
    self.equipLevelUpAcNode:addChild(effect2)
    local effect3 = self.effect_model:clone()
    effect3:setPosition(ccp(1078,260))
    effect3:playByIndex(0, -1, -1, 0)
    self.equipLevelUpAcNode:addChild(effect3)

    local spriteNode = self.sprite_mode:clone()
    spriteNode:setPosition(ccp(1136*0.5,640*0.5 + 60))
    spriteNode:setOpacity(0)
    spriteNode:setScale(0)
    self.equipLevelUpAcNode:addChild(spriteNode,100)
    local acArr = TFVector:create()

    local scale = CCScaleTo:create(0.3,1.2)
    local fade = CCFadeIn:create(0.3)
    local spa = CCSpawn:createWithTwoActions(scale,fade)
    acArr:addObject(spa)
    scale = CCScaleTo:create(0.1,0.8)
    acArr:addObject(scale)
    scale = CCScaleTo:create(0.1,1.0)
    acArr:addObject(scale)
    local delay = CCDelayTime:create(0.5)
    acArr:addObject(delay)

    local move = CCMoveBy:create(0.3,ccp(0,50))
    fade = CCFadeOut:create(0.3)
    spa = CCSpawn:createWithTwoActions(move,fade)
    acArr:addObject(spa)
    local callFuncN = CCCallFuncN:create( function()
        
    end)
    acArr:addObject(callFuncN)
    spriteNode:runAction(CCSequence:create(acArr))

    local item = FamilyData:getItemByLevel(self.level)
    local totalTab = {}
    local tab = string.split( item.attribute, "|" )
    for i = 1, #tab do
        local str = tab[i]
        local temp = string.split( str, "_" )
        local key = tonumber(temp[1])
        local value = tonumber(temp[2])
        
        totalTab[key] = totalTab[key] or 0
        totalTab[key] = totalTab[key] + value
    end

    local attrAddName = nil
    self.attrAdd = {}

    for k, v in pairs(totalTab) do
        local value = v
        if k >= 18 then
            value = value..'%'
        end
        self.attrAdd[#self.attrAdd + 1] = stringUtils.format(localizable.Jiayuan_level_up1, AttributeTypeStr[k], value)
    end
    if item.breach_attribute and item.breach_attribute ~= "" then
        totalTab = {}
        tab = string.split( item.breach_attribute, "|" )
        for i = 1, #tab do
            print('tabtabtabtabtab = , ',tab)
            local str = tab[i]
            local temp = string.split( str, "_" )
            local key = tonumber(temp[1])
            local value = tonumber(temp[2])
            
            totalTab[key] = totalTab[key] or 0
            totalTab[key] = totalTab[key] + value
        end
        for k, v in pairs(totalTab) do
            local value = v
            if k >= 18 then
                value = value..'%'
            end
            self.attrAdd[#self.attrAdd + 1] = stringUtils.format(localizable.Jiayuan_level_up2, AttributeTypeStr[k], value)
        end
    end
    for i=1,#self.attrAdd do
        local toastMessageLayer = self.message_layer_model:clone()
        toastMessageLayer:setPosition(ccp(1136*0.5,640*0.5 - 80 - 65 * (i-1)));

        TFDirector:getChildByPath(toastMessageLayer, 'text'):setText(self.attrAdd[i]);
        TFDirector:getChildByPath(toastMessageLayer, 'text'):setFontSize(28);
        local bgImg = TFDirector:getChildByPath(toastMessageLayer, 'bg');
        bgImg:setSize(ccs(math.max(math.min(bgImg:getSize().width * string.utf8len(self.attrAdd[i])/20, bgImg:getSize().width),300)  ,bgImg:getSize().height))
        local toY = toastMessageLayer:getPosition().y + 80;
        local toX = toastMessageLayer:getPosition().x;
        
        if toY > 640 - 50 then
           toY = 640 - 50;
        end
        self.equipLevelUpAcNode:addChild(toastMessageLayer,50)
        toastMessageLayer:setOpacity(0)
        local bclear = false
        if i == #self.attrAdd then
            bclear = true
        end
        local toastTween = self:getTween(toastMessageLayer,toY,toX,i,bclear)
        TFDirector:toTween(toastTween)
    end
    
end

function JiayuanBaseLayer:getTween( layer ,toY , toX , dt , bclear)
    local toastTween = {
        target = layer,
        {
            duration = 0,
            delay = 0.8 +  0.3 * (dt-1)
        },
        {
            duration = 0.1,
            x = toX,
            y = toY,
            alpha = 0.9,
        },
        {
            duration = 0.05,
            y = toY +2,
        },
        {
            duration = 0.05,
            y = toY -1,
        },
        {
            duration = 0.1,
            alpha = 1,
        },
        { 
            duration = 0,
            delay = 1 
        },
        {
            duration = 0.1,
            y = toY - 4,
            alpha = 0.7,
        },
        {
            duration = 0.1,
            y = toY + 2,

        },
        {
            duration = 0,

        },
        {
             duration = 0.1,
             alpha = 0,
             y = toY + 100,
        },
        {
            duration = 0,
            onComplete = function() 
                layer:removeFromParentAndCleanup(true)
                if bclear == true then
                    self.equipLevelUpAcNode:removeFromParentAndCleanup(true)
                    self.equipLevelUpAcNode = nil
                end
            end
        }
    }
    return toastTween
end

function JiayuanBaseLayer.onBoxClickClick(sender)
    QiyuManager:requestDrawHomeAward()
end

function JiayuanBaseLayer.onRecordClick(sender)
    QiyuManager:RequestAccessRecord()
end

function JiayuanBaseLayer.onOneKeyLvUpClick(sender)
    local self = sender.logic
    local level = self.level
    local currExp = self.exp
    local maxExp = self.needExp
    local toolList = self.DAOJU_ID
    local needExp = maxExp - currExp
    local msg = nil
    for i = 1, self.kDaojuMaxNum do
        if toolList[i] then
            local goodsId = tonumber(toolList[i])
            local bagNumber = BagManager:getItemNumById( goodsId )
            local itemData = ItemData:objectByID(goodsId)   
            local needNumber = math.ceil(needExp / itemData.provide_exp)
            if bagNumber > 0 then
                msg = msg or {}
                if needNumber > bagNumber then
                    needExp = needExp - itemData.provide_exp * bagNumber
                    msg[goodsId] = bagNumber
                else
                    msg[goodsId] = needNumber
                    break
                end     
            end 
        end
    end
    if msg then
        local data = {}
        for k, v in pairs(msg) do
            local tab = {}
            --tab.id = k
            --tab.num = v
            tab[1] = k
            tab[2] = v
            table.insert(data, tab)
        end
        QiyuManager:requestJiayuanLevelUp(data)
    else
        toastMessage(localizable.Jiayuan_daoju_not_enough)
    end
end

function JiayuanBaseLayer:createLongTouch(btnIndex)
    if self.delayLongTouchTimer then
        TFDirector:removeTimer(self.delayLongTouchTimer)
        self.delayLongTouchTimer = nil
    end
    if self.touchLongTimer then
        TFDirector:removeTimer(self.touchLongTimer)
        self.touchLongTimer = nil
    end
    self.delayLongTouchTimer = TFDirector:addTimer(300, -1, nil,
        function ()
            if self.delayLongTouchTimer then
                TFDirector:removeTimer(self.delayLongTouchTimer)
                self.delayLongTouchTimer = nil
            end
            self.touchLongTimer = TFDirector:addTimer(66, -1, nil,
                function ()
                    local btn = self.panel_daoju[btnIndex].img_quality
                    local showNum = btn.goodNum - self.touchLongToolNum
                    --self.cloneEquip:setAddOrderExp(btn.goodExp)                 
                    local maxExp = self.needExp
                    local currExp = self.exp
                    self:refreshJindu()
                    if showNum > 0 and currExp < maxExp then
                        self.touchLongToolNum = self.touchLongToolNum + 1
                        --showNum = showNum - 1
                        --btn.txtNum:setText(showNum)
                        local function flyMoveCallBack()                            
                        end                     
                        self:showFlyBegin(self.touchLongBtnIndex, flyMoveCallBack)
                    else
                        self:deleteTouch()
                    end
                end)
        end)    
end

function JiayuanBaseLayer:reShow()
    self.super.onShow(self)
    self.isShowStart = false
end


function JiayuanBaseLayer:reloadFriendList()
    if self.friendList == nil then
        local table_content = TFDirector:getChildByPath(self.rightPanel_firend,"Panel_paihang")
        local tableview = TFTableView:create()
        print("table_content:getContentSize()",table_content:getContentSize())
        tableview:setTableViewSize(table_content:getContentSize())
        tableview:setDirection(TFTableView.TFSCROLLVERTICAL)
        tableview:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
        tableview:setPosition(table_content:getPosition())
        self.rightPanel_firend:addChild(tableview)
        -- tableview:setPosition(ccp(0,-250))
        self.friendList = tableview
        self.friendList.logic = self

        self.friendList:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
        self.friendList:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
        self.friendList:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
        -- self.friendList:reloadData()
    end
    self.friendList:reloadData()
    self:refresMyPaiHangInfo()
end

function JiayuanBaseLayer:refreshUI(isChangeLvl)
    self.jiayuanData = QiyuManager:getJiayuanData()
    self.level = self.jiayuanData.level or 1
    self.exp = self.jiayuanData.exp or 0

    local needLevel = math.min(FamilyData:length(), self.level + 1)
    self.needExp = FamilyData:getExpByLevel(needLevel)
    if self.level >= FamilyData:length() then
        self.exp = self.needExp
    end
    self:refreshDaoju()  
    self:refreshAttr()   
    self:refreshZanInfo()
    self:showBox()
    if isChangeLvl == true or self.equipLevelUpEffect ~= nil then
        self:playeLevelUpEffect()
        QiyuManager:requestFriendPraiseRanks()
        return
    end
    if self.isShowStart == true then
        self.isShowing = true
        self.isShowStart = false
        if self.isMoved == true then
            self:showFlyEnd()
        end
        return
    end
    self:refreshJindu()
    CommonManager:setRedPoint( self.btn_zhuanpan, QiyuManager:checkJiayuanRedPoint(), "zhuanpan", ccp(-7, -13) )
end

function JiayuanBaseLayer:refreshAttr()
    self.attrTab = QiyuManager:getJiayuanAttr()
    print("self.attrTab >> ", self.attrTab)
    for index, txt_arr in pairs(self.txt_arr_base) do
        local arrStr = self.attrTab[index] or 0
        txt_arr:setText(arrStr)
    end

    for index, txt_arr in pairs(self.txt_arr_add) do
        txt_arr:setVisible(false)
    end

    self.txt_percent = {}
    self.txt_arr = {}

    for i = EnumAttributeType.Crit, EnumAttributeType.Miss do
        local node = TFDirector:getChildByPath(self, "panel_shuxing" .. i)
        if node then
            self.txt_arr[i]     = TFDirector:getChildByPath(node, "txt_shuxingzhi")
            self.txt_percent[i] = TFDirector:getChildByPath(node, "txt_percent")
        end
    end

    --角色属性
    for index, txt_a in pairs(self.txt_arr) do        
        local arrStr = self.attrTab[index] or 0

        if txt_a then
            txt_a:setText(covertToDisplayValue(index, arrStr))
        end
    end

    for index, txt_b in pairs(self.txt_percent) do
        local newIndex = index
        if index == EnumAttributeType.Crit then
            newIndex = index + 4
        elseif index == EnumAttributeType.Preciseness then
            newIndex = index + 3
        end

        local arrStr = self.attrTab[newIndex]

        if txt_b then
            local percent = arrStr or 0

            txt_b:setVisible(false)
            if percent > 0 then
                txt_b:setVisible(true)
                -- covertToDisplayValue(newIndex, percent)
                local percentValue = string.format("%.2f", percent / 100) .. '%'
                txt_b:setText("+"..percentValue)
            end
        end
    end
end

function JiayuanBaseLayer:refreshJindu()
    local per = 0
    if self.needExp and self.needExp ~= 0 then
        per = self.exp / self.needExp * 100
    end
    self.bar_exp:setPercent(per)
    self.txt_jindu:setText(self.exp .. "/" .. self.needExp)

    self.txt_jiayuanLv:setText("Lv" .. self.level)
    self.txt_jiayuanLv_0:setText(QiyuManager:getJiayuanLevel())
end

function JiayuanBaseLayer:refreshDaoju()
    for i = 1, self.kDaojuMaxNum do
        local itemId = self.DAOJU_ID[i]
        local daojuItem = ItemData:objectByID(itemId)
        local curNum = BagManager:getItemNumById(itemId)

        self.panel_daoju[i].img_quality.goodId = itemId
        self.panel_daoju[i].img_quality.goodNum = curNum
        self.panel_daoju[i].img_quality:setTexture( GetColorIconByQuality(daojuItem.quality) )
        self.panel_daoju[i].img_icon:setTexture( daojuItem:GetPath() )
        self.panel_daoju[i].txt_num_daoju:setText(curNum)
        self.panel_daoju[i].txt_num_exp:setText('+' .. daojuItem.provide_exp)
    end
end

function JiayuanBaseLayer:checkCanLevelUp()

end

function JiayuanBaseLayer.onReturnClickHandle(sender)
    local self = sender.logic
    AlertManager:close()
end

function JiayuanBaseLayer.onHelpClickHandle(sender)
    local self = sender.logic
    print("onHelpClickHandle")
    CommonManager:showRuleLyaer('jiayuan')
end

function JiayuanBaseLayer.onZhuanpanClickHandle(sender)
    local self = sender.logic

    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.qiyu.JiayuanLunpanLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1)
    layer.logiclayer = self
    AlertManager:show()
end
function JiayuanBaseLayer:zhuanpanClick()
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.qiyu.JiayuanLunpanLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1)
    layer.logiclayer = self
    AlertManager:show()
end

function JiayuanBaseLayer:openFriendPanel()
    print("JiayuanBaseLayer:openFriendPanel(")
    self.rightPanel_arr:setZOrder(4)
    -- self.rightPanel_extendedArr:setVisible(false)
    self.rightPanel_firend:setZOrder(10)
    if not self.attr_layer_show then
        self:openRightPanel()
    end
    self.btn_hyph:setTextureNormal("ui_new/qiyu/family/btn_hyph_l.png")
    self.btn_jyzjc:setTextureNormal("ui_new/qiyu/family/btn_jyzjc_h.png")
    self.rightPanel_type = 1
    -- self:refresMyPaiHangInfo()
    -- self:refreshZanInfo()

end

function JiayuanBaseLayer.onShowFriendClickHandle(sender)
    print("onShowFriendClickHandle")
    local self = sender.logic
    self.rightPanel_type = self.rightPanel_type or 0
    if self.rightPanel_type == 1 then
        if self.attr_layer_show then
            self.btn_hyph:setTextureNormal("ui_new/qiyu/family/btn_hyph_h.png")
        else
            self.btn_hyph:setTextureNormal("ui_new/qiyu/family/btn_hyph_l.png")
        end
        self:openRightPanel()

    else
        if not self.attr_layer_show then
            self:openRightPanel()
        end
        self.btn_hyph:setTextureNormal("ui_new/qiyu/family/btn_hyph_l.png")
        self.btn_jyzjc:setTextureNormal("ui_new/qiyu/family/btn_jyzjc_h.png")
    end
    self.rightPanel_arr:setZOrder(4)
    -- self.rightPanel_extendedArr:setVisible(false)
    self.rightPanel_firend:setZOrder(10)
    -- self:refresMyPaiHangInfo()
    -- self:refreshZanInfo()
    -- self:reloadFriendList()
    self.rightPanel_type = 1
end

function JiayuanBaseLayer.onAttrAddClickHandle(sender)
    print("onAttrAddClickHandle")
    local self = sender.logic
    self.rightPanel_type = self.rightPanel_type or 0
    if self.rightPanel_type == 2 then
        if self.attr_layer_show then
            self.btn_jyzjc:setTextureNormal("ui_new/qiyu/family/btn_jyzjc_h.png")
        else
            self.btn_jyzjc:setTextureNormal("ui_new/qiyu/family/btn_jyzjc.png")
        end
        self:openRightPanel()
    else
        if not self.attr_layer_show then
            self:openRightPanel()
        end
        self.btn_jyzjc:setTextureNormal("ui_new/qiyu/family/btn_jyzjc.png")
        self.btn_hyph:setTextureNormal("ui_new/qiyu/family/btn_hyph_h.png")
    end
    self.rightPanel_arr:setZOrder(10)
    -- self.rightPanel_extendedArr:setVisible(true)
    self.rightPanel_firend:setZOrder(4)
    self.rightPanel_type = 2
end
function JiayuanBaseLayer:openRightPanel()
    if self.attr_tween then
        TFDirector:killTween(self.attr_tween)
    end
    if self.attr_layer_show then
        self.attr_tween = {
            target = self.img_attr_di,
            {
                duration = 0.3,
                ease = {type=TFEaseType.EASE_IN_OUT, rate=3},
                x = self.origin_pos_x,
            },
        }
        self.attr_layer_show = false
    else
        self.attr_tween = {
            target = self.img_attr_di,
            {
                duration = 0.3,
                ease = {type=TFEaseType.EASE_IN_OUT, rate=3},
                x = -455,
            },
        }
        self.attr_layer_show = true
    end
    TFDirector:toTween(self.attr_tween)
end

function JiayuanBaseLayer.onLvAddClickHandle(sender)
    local self = sender.logic

    print("onLvAddClickHandle")
    AlertManager:addLayerToQueueAndCacheByFile("lua.logic.qiyu.JiayuanLevelAddLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1)
    AlertManager:show()
end

function JiayuanBaseLayer.numberOfCellsInTableView(table)
    if QiyuManager.homeFriendPraiseRanks then
        return QiyuManager.homeFriendPraiseRanks:length()
    end
    return 0
end

function JiayuanBaseLayer.cellSizeForTable(table, idx)
    return 95,440
end

function JiayuanBaseLayer.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    local node = nil
    if nil == cell then
        cell = TFTableViewCell:create()
        node = self.cellModel:clone()
        node:setVisible(true)
        node:setPosition(ccp(220,48))
        cell:addChild(node)
        cell.panel = node
        node.logic = self
    end
    local firendInfo = QiyuManager.homeFriendPraiseRanks:getObjectAt(idx+1)
    -- print("---------firendInfo-->",firendInfo)
    if firendInfo then
        cell.panel:setVisible(true)
        self:showFirendPanelInfo(cell.panel , firendInfo , idx+1)
    else
        cell.panel:setVisible(false)
    end
    return cell
end

function JiayuanBaseLayer:showFirendPanelInfo(panel, firendInfo,index)
    if panel.txt_name == nil then
        panel.img_paihang = TFDirector:getChildByPath(panel,"img_paihang")
        panel.img_liebiaobg = TFDirector:getChildByPath(panel,"img_liebiaobg")
        panel.bg_head = TFDirector:getChildByPath(panel,"bg_head")
        panel.Img_icon = TFDirector:getChildByPath(panel,"Img_icon")
        panel.txt_name = TFDirector:getChildByPath(panel,"txt_name")
        panel.btn_canguan = TFDirector:getChildByPath(panel,"btn_canguan")
        panel.txt_number = TFDirector:getChildByPath(panel,"txt_number")
        panel.btn_zan = TFDirector:getChildByPath(panel,"btn_zan")
        panel.txt_zannumber = TFDirector:getChildByPath(panel,"txt_zannumber")
        panel.txt_paimingnumber = TFDirector:getChildByPath(panel,"txt_paimingnumber")
        panel.img_liebiaobg:setTouchEnabled(true)
        panel.img_liebiaobg:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onCanGuanClickHandle), 1)
        panel.btn_zan:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onZanFriendClickHandle), 1)
        panel.node_state = {}
        for i=1,3 do
            panel.node_state[i] = TFDirector:getChildByPath(panel,"btn_bs" .. i)
            panel.node_state[i]:setTouchEnabled(false)
            panel.node_state[i]:setVisible(false)
        end
    end
    if self.pos_zero == nil then
        self.pos_zero = panel.node_state[1]:getPositionX()
    end
    local temp = 0
    for i=1,3 do
        local state = self:getEventState(firendInfo.events,i)
        if state == true then
            panel.node_state[i]:setVisible(true)
            panel.node_state[i]:setPositionX(temp * 21 + self.pos_zero)
            temp = temp + 1
        else
            panel.node_state[i]:setVisible(false)
        end
    end
    panel.btn_canguan:setVisible(false)
    panel.img_liebiaobg.index = index
    panel.img_liebiaobg.logic = self
    panel.btn_zan.index = index
    panel.txt_name:setText(firendInfo.name)
    panel.txt_number:setText(firendInfo.homeLevel)
    panel.txt_zannumber:setText(stringUtils.format(localizable.common_zan,firendInfo.praiseCount))
    local roleData =  RoleData:objectByID(firendInfo.icon)
    if roleData then
        panel.Img_icon:setTexture(roleData:getIconPath())
        Public:addFrameImg(panel.Img_icon,firendInfo.headPicFrame,true)
    end
    if index <= 3 then
        panel.txt_paimingnumber:setVisible(false)
        panel.img_paihang:setVisible(true)
        panel.img_paihang:setTexture("ui_new/leaderboard/no"..index..".png")
    else
        panel.img_paihang:setVisible(false)
        panel.txt_paimingnumber:setVisible(true)
        panel.txt_paimingnumber:setText(index)
    end
    if firendInfo.playerId == MainPlayer:getPlayerId() then
        panel.btn_zan:setVisible(false)
        Public:addInfoListen(panel.Img_icon,false)
    else
        Public:addInfoListen(panel.Img_icon,true,4,firendInfo.playerId)
        panel.btn_zan:setVisible(true)
    end
    local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.JIAYUAN_ZAN)
    local nowTimes = tonumber(challengeInfo:getLeftChallengeTimes())
    if nowTimes <= 0 then
        panel.btn_zan:setGrayEnabled(true)
        panel.btn_zan:setTouchEnabled(false)
        return
    else
        panel.btn_zan:setGrayEnabled(false)
        panel.btn_zan:setTouchEnabled(true)
    end
    local jiayuanData = QiyuManager:getJiayuanData()
    if jiayuanData.praiseFriends[firendInfo.playerId] and jiayuanData.praiseFriends[firendInfo.playerId] == 1 then
        -- panel.btn_zan:setVisible(false)
        panel.btn_zan:setGrayEnabled(true)
        panel.btn_zan:setTouchEnabled(false)
    end
    
end

function JiayuanBaseLayer:getEventState( eventMsg ,eventId)
    if eventMsg == nil then
        return false
    end
    for i,v in ipairs(eventMsg) do
        if v.eventId == eventId then
            if v.state == 0 then
                if v.eventId == 2 and v.count >= 3 then
                    return false
                end
                if v.eventId == 3 and v.count >= v.totleCount then
                    return false
                end
                if v.players then
                    local myPlayerId = MainPlayer:getPlayerId()
                    for _i,_v in ipairs(v.players) do
                        if _v == myPlayerId then
                            return false
                        end
                    end
                end
                return true
            end
            return false
        end
    end
    return false
end

function JiayuanBaseLayer:refresMyPaiHangInfo()
    local txt_mypaiming = TFDirector:getChildByPath(self.ui,"txt_mypaiming")
    local txt_mypaiming_num = TFDirector:getChildByPath(txt_mypaiming,"txt_number")
    local index = 1
    for firendInfo in QiyuManager.homeFriendPraiseRanks:iterator() do
        if firendInfo.playerId == MainPlayer:getPlayerId() then
            txt_mypaiming_num:setText(index)
            return
        end
        index = index + 1
    end
end

function JiayuanBaseLayer:refreshZanInfo()
    local txt_mybzcs = TFDirector:getChildByPath(self.ui,"txt_mybzcs")
    local txt_mybzcs_num = TFDirector:getChildByPath(txt_mybzcs,"txt_number")
    local jiayuanData = QiyuManager:getJiayuanData()
    txt_mybzcs_num:setText(jiayuanData.praiseCount)


    local txt_sydz = TFDirector:getChildByPath(self.ui,"txt_sydz")
    local txt_sydz_num = TFDirector:getChildByPath(txt_sydz,"txt_number")
    local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.JIAYUAN_ZAN)
    local nowTimes = tonumber(challengeInfo:getLeftChallengeTimes())
    txt_sydz_num:setText(nowTimes)
end

function JiayuanBaseLayer.onCanGuanClickHandle( sender )
    local self = sender.logic
    local index = sender.index
    local firendInfo = QiyuManager.homeFriendPraiseRanks:getObjectAt(index)
    local myPlayerId = MainPlayer:getPlayerId()
    if firendInfo and self.logic then
        if firendInfo.playerId == myPlayerId then
        else
            self.logic:showFriendLayer(firendInfo)
        end
    end
end

function JiayuanBaseLayer.onZanFriendClickHandle( sender )
    local index = sender.index
    local firendInfo = QiyuManager.homeFriendPraiseRanks:getObjectAt(index)
    if firendInfo then
        QiyuManager:requestHomePraise(firendInfo.playerId)
    end
end

function JiayuanBaseLayer:showBox()
    local jiayuanData = QiyuManager:getJiayuanData()
    local praiseData = HomePraiseAwardData:objectByID(1)
    if praiseData == nil then
        self.btn_baoxiang:setVisible(false)
        return
    end
    if jiayuanData.drawCount >= math.floor(jiayuanData.praiseCount/praiseData.praise) then
        self.btn_baoxiang:setVisible(false)
        return
    end
    self.btn_baoxiang:setVisible(true)
    self:showRewardEffect(true)
end

function JiayuanBaseLayer:showRewardEffect(bShow)
    if bShow == true then
        if self.EscortingEffect == nil then
            local resPath = "effect/escorting.xml"
            TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
            local effect = TFArmature:create("escorting_anim")
            local node   = self.btn_baoxiang
            effect:setAnimationFps(GameConfig.ANIM_FPS)
            node:addChild(effect, 1)
            local size = node:getContentSize()
            effect:setPosition(ccp(0, -17))
            -- effect:setAnchorPoint(ccp(0.5, 0.5))
            effect:setScale(1.2)
            self.EscortingEffect = effect
            self.EscortingEffect:playByIndex(1, -1, -1, 1)
        end
    else
        if self.EscortingEffect ~= nil then
            self.EscortingEffect:removeFromParent()
            self.EscortingEffect = nil
        end
    end
end
return JiayuanBaseLayer