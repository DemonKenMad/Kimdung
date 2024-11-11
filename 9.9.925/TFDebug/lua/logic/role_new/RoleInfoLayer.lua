--[[
******角色详情*******
    -- by king
    -- 2015/4/17
]]

local RoleInfoLayer = class("RoleInfoLayer", BaseLayer)

--added by wuqi
RoleInfoLayer.TAG_TIANSHU   = 16
RoleInfoLayer.TAG_XINFA     = 7
RoleInfoLayer.TAG_TOUSHI    = 6

function RoleInfoLayer:ctor(data)
    self.super.ctor(self,data)
    self.isClickSkyBook = false
    self.isClickXinFa   = false
    self.fightType = EnumFightStrategyType.StrategyType_PVE
    CardRoleManager.openArmyIndex = self.fightType
    self.isAcc = true
    self:init("lua.uiconfig_mango_new.role_new.RoleInfoLayer")
end

function RoleInfoLayer:loadSelfData(selectIndex,fightType,roleList)
    self.selectIndex    = selectIndex
    self.cardRoleId     = nil
    self.type           = "self"
    self.fightType      = fightType or EnumFightStrategyType.StrategyType_PVE
    self.roleList       = roleList or ZhengbaManager:getSortStrategy(self.fightType) -- add by king 
    CardRoleManager.openArmyIndex = self.fightType
    self.bShowTuPu     = false
    self.firstShowSound = true

    if self.type == "self" and self.bg_wxbtn then
        --self.bg_wxbtn:setVisible(true)
        self.bg_wxbtn:setVisible(false)
    end

end

function RoleInfoLayer:loadOtherData(selectIndex,roleList,otherInfo, quality, bibleLevel,xinfaquality,xinfabibleLevel)
    self.selectIndex  = selectIndex
    self.cardRoleId   = nil
    self.roleList     = roleList
    self.otherInfo   = otherInfo
    self.type         = "other"
    self.fightType = EnumFightStrategyType.StrategyType_PVE
    self.bShowTuPu   = false
    self.firstShowSound = true
    self.biblePracticeQuality = quality
    self.bibleLevel = bibleLevel
    self.xinfaquality = xinfaquality
    self.xinfabibleLevel = xinfabibleLevel
    if self.type == "other" and self.bg_wxbtn then
        self.bg_wxbtn:setVisible(false)
    end
end
function RoleInfoLayer:loadFengYunLuData(selectIndex,roleList)
    self.selectIndex  = selectIndex
    self.cardRoleId   = nil
    self.roleList     = roleList
    self.type         = LayerType.fengyunluType
    if self.type ==LayerType.fengyunluType and self.bg_wxbtn then
        self.bg_wxbtn:setVisible(false)
    end
end
-- 增加血战的详细角色查看 add by king
function RoleInfoLayer:loadBloodyData(selectIndex,roleList)
    self.selectIndex  = selectIndex
    self.cardRoleId   = nil
    self.roleList     = roleList

    self.type         = "self"
    self.fightType = EnumFightStrategyType.StrategyType_PVE
    self.bShowTuPu   = false
    self.firstShowSound = true

    if self.type == "self" and self.bg_wxbtn then
        --self.bg_wxbtn:setVisible(true)
        self.bg_wxbtn:setVisible(false)
    end
end

function RoleInfoLayer:onShow()
    self.super.onShow(self)
      
    self:refreshBaseUI()
    self:refreshUI()
    TFDeviceInfo:setOpenAccelerometer(true)
end


function RoleInfoLayer:refreshBaseUI()

end

function RoleInfoLayer:refreshUI()
    if not self.isShow then
        return
    end
    local rolePanel = TFDirector:getChildByPath(self, 'rolePanel')
    if rolePanel then
        rolePanel:setZOrder(1)
    end
    self:hideNamePanel()
    self:drawDefault()

    if self.type == "self" then
        if self.cardRoleId then
            --local cardRole = CardRoleManager:getRoleById(self.cardRoleId);
            self.selectIndex = self.roleList:indexOf(self.cardRoleId);
        end
        EquipmentManager:getIsHaveEquip(1,true)
        --added by wuqi
        self.isHaveSkyBook = false
        local bookList = SkyBookManager:getAllUnEquippedBook()
        if bookList and bookList:length() > 0 then
            self.isHaveSkyBook = true
        end
        self.isHaveXinFa = false
        local xinfaList = XinFaManager:getAllUnEquippedXinFa()
        if xinfaList and xinfaList:length() > 0 then
            self.isHaveXinFa = true
        end
    end
    self:refreshRoleList(self.selectIndex)
    
    local function needShowTaoZhuangBtn(tbl)
        tbl = tbl or {}
        for k,v in pairs(tbl) do
            if v and v > 0 then
                return true
            end
        end
        return false
    end

    self.btn_taozhaung:setVisible(false)
    if IllustrationManager.isOpenTuJian == false and FengYunLuManager.isOpenFengYunLu == false then
        if CardRoleManager:getRoleByGmid(self.cardRole.gmId) then
            self.data = EquipmentManager:getSuitEquipInfo( self.cardRole.gmId )
            self.btn_taozhaung:setVisible(needShowTaoZhuangBtn(self.data))
        elseif OtherPlayerManager:getRoleByid( self.cardRoleId) then
            self.data = EquipmentManager:getSuitEquipInfo(  self.cardRoleId,2 )
            self.btn_taozhaung:setVisible(needShowTaoZhuangBtn(self.data))
        end
    end
    --套装按钮加特效
    if self.texiaokind == 1 then
        local resPath = "effect/ui/taozhuang.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("taozhuang_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(-60,50))
        effect:setScale(1.3)
        self.btn_taozhaung:addChild(effect,1)
        effect:playByIndex(0, -1, -1, 1)
        self.texiaokind = 0
    end
    -- self:drawDefault()
    self:drawTuPuInfo()

    if self.newIndex and self.newIndex == 2 then
        self.bg_right:setVisible(false)
        self.LayerList[self.btnCurIndex].layer:setVisible(false)
    end
end

function RoleInfoLayer:initUI(ui)
    self.super.initUI(self,ui)

    self.panel_content  = TFDirector:getChildByPath(ui, 'pan_content')
    self.panel_content:setZOrder(100)
    -- 关闭按钮
    self.btn_close      = TFDirector:getChildByPath(ui, 'btn_close')

    -- 下面培养三个按钮
    self.btn_py           = TFDirector:getChildByPath(ui, 'btn_py')
    self.btn_sx           = TFDirector:getChildByPath(ui, 'btn_sx')
    self.btn_yf           = TFDirector:getChildByPath(ui, 'btn_yf')
    -- 套装按钮
    self.btn_taozhaung           = TFDirector:getChildByPath(ui, 'btn_taozhaung')

    
    self.btn_py.index      = 1
    self.btn_sx.index      = 2
    self.btn_yf.index      = 3

    self.btn_py.logic     = self
    self.btn_sx.logic     = self
    self.btn_yf.logic     = self
    
    -- 
    self.BtnSetting = {}
    self.BtnSetting[1] = {}
    self.BtnSetting[1].btn      = self.btn_py
    self.BtnSetting[1].normal   = "ui_new/role/btn_py.png"
    self.BtnSetting[1].select   = "ui_new/role/btn_py_hl.png"

    self.BtnSetting[2] = {}
    self.BtnSetting[2].btn      = self.btn_sx
    self.BtnSetting[2].normal   = "ui_new/role/btn_sx.png"
    self.BtnSetting[2].select   = "ui_new/role/btn_sx_hl.png"

    self.BtnSetting[3] = {}
    self.BtnSetting[3].btn      = self.btn_yf
    self.BtnSetting[3].normal   = "ui_new/role/btn_yf.png"
    self.BtnSetting[3].select   = "ui_new/role/btn_yf_hl.png"


    -- 对应按钮的索引
    self.btnCurIndex            = 1

    -- 右边三个界面的layer列表
    self.LayerList              = {}    

    self.LayerList[1]           = {}
    self.LayerList[1].layer     = nil
    self.LayerList[1].path      = "lua.logic.role_new.RoleInfoLayer_py"

    self.LayerList[2]           = {}
    self.LayerList[2].layer     = nil
    self.LayerList[2].path      = "lua.logic.role_new.RoleInfoLayer_sx"

    self.LayerList[3]           = {}
    self.LayerList[3].layer     = nil
    self.LayerList[3].path      = "lua.logic.role_new.RoleInfoLayer_yf"

    -- 基本属性
    self.img_namebg     = TFDirector:getChildByPath(ui, 'img_namebg')
    self.txt_name       = TFDirector:getChildByPath(ui, 'txt_name')
    self.img_type       = TFDirector:getChildByPath(ui, 'img_zhiye')
    self.img_quality    = TFDirector:getChildByPath(ui, 'img_pinzhi')
    self.txt_power      = TFDirector:getChildByPath(ui, 'txt_power')
    self.img_isfight    = TFDirector:getChildByPath(ui, 'img_isfight');
    self.img_fightpower = TFDirector:getChildByPath(ui, 'img_fightpower')
    self.img_ditu       = TFDirector:getChildByPath(ui, 'img_ditu')
    --self.img_isfight:setPositionX(513)
    -- 装备列表
    self.panel_equip     = TFDirector:getChildByPath(ui, 'panel_zhuangbei')
    self.img_equipList = {}
    self.img_equipQualityList = {}
    self.img_equipEmptyList = {}
    self.img_gemBg = {}
    self.img_gem = {}
    self.img_add = {}
    self.img_lock = {}

    for i=1,6 do
        local panel_equip = TFDirector:getChildByPath(ui, "panel_equip_"..i)


        self.img_equipList[i] = TFDirector:getChildByPath(panel_equip, "img_equip")

        self.img_equipQualityList[i] = TFDirector:getChildByPath(panel_equip, "img_quality")
        self.img_equipQualityList[i]:setTag(i)
        self.img_equipQualityList[i].logic = self
        self.img_equipQualityList[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onEquipIconClickHandle,play_xuanze))
        self.img_equipQualityList[i].type = "Quality"

        self.img_equipEmptyList[i] = TFDirector:getChildByPath(panel_equip, "img_bg")
        self.img_equipEmptyList[i]:setTag(i)
        self.img_equipEmptyList[i].logic = self
        self.img_equipEmptyList[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onEquipIconClickHandle,play_xuanze))
        self.img_equipEmptyList[i].type = "Empty"


        self.img_gemBg[i] = {}
        self.img_gem[i] = {}
        for j=1,EquipmentManager.kGemMergeTargetNum do
            self.img_gemBg[i][j] = TFDirector:getChildByPath(panel_equip, "img_baoshicao"..j)
            self.img_gem[i][j] = TFDirector:getChildByPath(panel_equip, "img_gem"..j)
        end
        self.img_add[i]     = TFDirector:getChildByPath(panel_equip, "img_add")
        self.img_lock[i]    = TFDirector:getChildByPath(panel_equip, "img_lock")

    end

    -- added by wuqi
    -- 天书装备位
    self.panel_tianshu = TFDirector:getChildByPath(ui, "panel_equip_16")
    self.panel_tianshu.img_equip = TFDirector:getChildByPath(self.panel_tianshu, "img_equip")
    self.panel_tianshu.img_quality = TFDirector:getChildByPath(self.panel_tianshu, "img_quality")
    self.panel_tianshu.img_quality:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onTianshuIconClickHandle, play_xuanze))
    self.panel_tianshu.img_quality:setTag(self.TAG_TIANSHU)
    self.panel_tianshu.img_quality.logic = self
    self.panel_tianshu.img_empty = TFDirector:getChildByPath(self.panel_tianshu, "img_bg")
    self.panel_tianshu.img_empty:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onTianshuIconClickHandle, play_xuanze))
    self.panel_tianshu.img_empty:setTag(self.TAG_TIANSHU)
    self.panel_tianshu.img_empty.logic = self
    self.panel_tianshu.txt_qianghualv = TFDirector:getChildByPath(self.panel_tianshu, "txt_qianghualv")
    self.panel_tianshu.img_add = TFDirector:getChildByPath(self.panel_tianshu, "img_add")
    self.panel_tianshu.img_lock = TFDirector:getChildByPath(self.panel_tianshu, "img_lock")
	self.panel_tianshu.img_baoshicao1 = TFDirector:getChildByPath(self.panel_tianshu, "img_baoshicao1")
	self.panel_tianshu.img_gem1 = TFDirector:getChildByPath(self.panel_tianshu, "img_gem1")
    self.panel_tianshu.img_baoshicao2 = TFDirector:getChildByPath(self.panel_tianshu, "img_baoshicao2")
    self.panel_tianshu.img_gem2 = TFDirector:getChildByPath(self.panel_tianshu.img_baoshicao2, "img_gem2")

    self.panel_xinfa                = TFDirector:getChildByPath(ui, "panel_equip_7")
    self.panel_xinfa.img_quality    = TFDirector:getChildByPath(self.panel_xinfa, "img_quality") 
    self.panel_xinfa.img_empty      = TFDirector:getChildByPath(self.panel_xinfa, "img_bg")
    self.panel_xinfa.img_quality:setTag(self.TAG_XINFA)
    self.panel_xinfa.img_empty:setTag(self.TAG_XINFA)
    self.panel_xinfa.img_quality.logic  = self
    self.panel_xinfa.img_empty.logic    = self
    self.panel_xinfa.img_quality:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onXinfaIconClickHandle, play_xuanze))
    self.panel_xinfa.img_empty:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onXinfaIconClickHandle, play_xuanze))
    self.panel_xinfa.img_equip      = TFDirector:getChildByPath(self.panel_xinfa, 'img_equip')
    self.panel_xinfa.img_add        = TFDirector:getChildByPath(self.panel_xinfa, 'img_add')
    self.panel_xinfa.img_lock       = TFDirector:getChildByPath(self.panel_xinfa, 'img_lock')
    self.panel_xinfa.txt_qianghualv = TFDirector:getChildByPath(self.panel_xinfa, 'txt_qianghualv')



    local posX = self.panel_tianshu:getPositionX()
    local glView = CCDirector:sharedDirector():getOpenGLView()
    local frameSize = glView:getFrameSize()
    local designSize = glView:getDesignResolutionSize()
    self.panel_tianshu.posX = (posX - 460) + designSize.width - (1136 - 460)
    -- posX = posX - 460 * (designSize.width / designSize.height * frameSize.height - frameSize.width) / designSize.width
    self.panel_tianshu:setPositionX(self.panel_tianshu.posX)
    self.panel_xinfa:setPositionX(self.panel_tianshu.posX)

    local verLock = VersionLockData:objectByID(EnumVersionLockType.SkyBook_Lock)
    if verLock and verLock.open == 0 then
        self.panel_tianshu:setVisible(false)
    end
    -- 星级
    self.img_starList = {}
    for i=1,5 do
        self.img_starList[i] = TFDirector:getChildByPath(ui, "img_star_light_"..i)
        self.img_starList[i]:setVisible(false)
    end

    -- 角色列表
    self.panel_list     = TFDirector:getChildByPath(ui, 'panel_list')
    local pageView = TPageView:create()
    self.pageView = pageView

    pageView:setTouchEnabled(true)
    pageView:setBackGroundColorType(TF_LAYOUT_COLOR_NONE)
    pageView:setSize(self.panel_list:getContentSize())
    pageView:setAnchorPoint(self.panel_list:getAnchorPoint())

    local function onPageChange()
        local delay0 = CCDelayTime:create(0.1)
        local callFunc = CCCallFunc:create(function()
            self:onPageChange();
        end)
        pageView:runAction(CCSequence:createWithTwoActions(delay0, callFunc))

        --self:onPageChange();
    end
    pageView:setChangeFunc(onPageChange)

    local function itemAdd(index)
        return  self:addPage(index)
    end 
    pageView:setAddFunc(itemAdd)

    self.panel_list:addChild(pageView,2);

    -- 左右按钮
    self.btn_left           = TFDirector:getChildByPath(ui, 'btn_pageleft')
    self.btn_right          = TFDirector:getChildByPath(ui, 'btn_pageright')
    self.positiony          = self.btn_right:getPosition().y


    -- 武学按钮
    self.bg_wxbtn           = TFDirector:getChildByPath(ui, 'bg_wxbtn')
    self.btn_cxwx           = TFDirector:getChildByPath(ui, 'btn_cxwx')
    self.btn_cxwx.logic     = self
    -- self:drawDefault()

    local nViewHeight = GameConfig.WS.height
    local nViewWidth = GameConfig.WS.width
    local touchPanel = TFPanel:create()
    touchPanel:setSize(ccs(nViewWidth, nViewHeight))
    -- touchPanel:setBackGroundColorType(TF_LAYOUT_COLOR_SOLID)
    -- -- touchPanel:setBackGroundColor(ccc3(0, 0, 0))
    -- touchPanel:setTouchEnabled(true)
    touchPanel:setZOrder(1000)
    ui:addChild(touchPanel)

    self.touchPanel = touchPanel

    self.panel_left = TFDirector:getChildByPath(ui, "panel_left")
    self.panel_center = TFDirector:getChildByPath(ui, "panel_juesexingxiang")
    self.panel_center:setZOrder(2)
    self.bg_right = TFDirector:getChildByPath(ui, "bg_right-Copy2")

    self:addBgEffect()

    self.bg_move = {}
    self.initBgPos = {}
    self.curPos = {}
    for i = 1, 1 do
        self.bg_move[i] = TFDirector:getChildByPath(ui, "bg")
        --self.bg_move[i]:setPositionY(self.bg_move[i]:getPositionY() - 10)
        self.bg_move[i]:setScale(1.1)
        self.initBgPos[i] = self.bg_move[i]:getPosition()
        self.curPos[i] = self.bg_move[i]:getPosition()
    end
    self.panel_equplist = TFDirector:getChildByPath(ui, "panel_equplist")
    self.panel_equplist:setZOrder(100)
    --角色改名
    self.btn_gaiming = TFDirector:getChildByPath(ui, "btn_gaiming")
    self.btn_gaiming.logic = self
    self.panel_changename = TFDirector:getChildByPath(self.panel_center, "Panel_changename")
    self.panel_changename.logic = self
    self.txt_input = TFDirector:getChildByPath(self.panel_changename, "txt_input")
    self.playernameInput = TFDirector:getChildByPath(self.panel_changename, "playernameInput")
    self.playernameInput:setCursorEnabled(true)
    self.btn_huanyuan = TFDirector:getChildByPath(self.panel_changename, "btn_huanyuan")
    self.btn_queding = TFDirector:getChildByPath(self.panel_changename, "btn_queding")
    self.btn_huanyuan.logic = self
    self.btn_queding.logic = self
    self.txt_input:setVisible(false)
    self.panel_changename:setTouchEnabled(true)
    self.panel_changename:setVisible(false)
    
    self.texiaokind = 1
end

function RoleInfoLayer:registerEvents(ui)
    self.super.registerEvents(self)
    -- 关闭按钮
    self.btn_close.logic    = self;
    self.btn_close:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onCloseClickHandle),1)
    self.btn_close:setClickAreaLength(100)

    self.btn_py:addMEListener(TFWIDGET_CLICK, audioClickfun(self.BtnClickHandle))
    self.btn_sx:addMEListener(TFWIDGET_CLICK, audioClickfun(self.BtnClickHandle))
    self.btn_yf:addMEListener(TFWIDGET_CLICK, audioClickfun(self.BtnClickHandle))
    --套装
    self.btn_taozhaung.logic     = self
    self.btn_taozhaung:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onTaoZhuangClickHandle))

    -- 
    self.btn_left.logic = self;
    self.btn_left:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onLeftClickHandle),1)
    self.btn_right.logic = self;
    self.btn_right:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRightClickHandle),1)

    self:registerEquipEvent()

    self.MartialLevelUpEventCallBak = function(event)
        -- toastMessage("进阶成功")
        -- self:showJinJieResult()
        -- self:showJinJieEffect()
        -- self:refreshUI()
        local roleId = event.data[1][1]
        --self:showJinJieEffect()
        local cardRole = CardRoleManager:getRoleById(roleId)
        if cardRole == nil then
            return
        end
        local layer = CardRoleManager:openRoleUpLayer(CardRoleManager.upEffectType.roleUpBartial)
        layer:initRoleUpBartialData(cardRole, self.fightType, self.beforeMartialUpPower, self.beforeMartialLevel, self:effectEndCall())
        AlertManager:show();
    end
    TFDirector:addMEGlobalListener(MartialManager.MSG_MartialLevelUp ,self.MartialLevelUpEventCallBak)

    if self.LayerList then 
        for i=1,3 do
            local layer = self.LayerList[i].layer
            if layer then
                layer:registerEvents()
            end
        end
    end

    -- add by king  大月卡增加属性
    self.monthCardUpdateAttr = function (event)
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(MonthCardManager.MONTH_CARD_RefeshAttr,self.monthCardUpdateAttr)
    -- end

    self.MoveRoleListToLeftFun = function (event)
        local index = event.data[1].pageIndex
        local pageIndex = self.pageView:getCurPageIndex() ;
        self.pageView:scrollToPage(pageIndex + index);
        -- self.onLeftClickHandle(self.btn_left)
    end
    TFDirector:addMEGlobalListener("MoveRoleListToLeft", self.MoveRoleListToLeftFun)

    self.MoveRoleListToRoleFun = function (event)
        local roleId = event.data[1].roleId
        self.cardRoleId = roleId
    end
    TFDirector:addMEGlobalListener("MoveRoleListToRole", self.MoveRoleListToRoleFun)

    self.MoveRoleListToRightFun = function (event)
        self.onRightClickHandle(self.btn_right)
    end
    TFDirector:addMEGlobalListener("MoveRoleListToRight", self.MoveRoleListToRightFun)

    -- 
    self.btn_cxwx:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onPreviewClickHandle),1)


    self.updateFateMessageCallBack = function (event)
        local data = event.data[1]
        if self.cardRole and self.cardRole.gmId == data[1] then
            local oldpower = tonumber(self.txt_power:getText())
            if oldpower ~= 0 and oldpower ~= self.cardRole:getPowerByFightType(self.fightType) then
                self:textChange(oldpower,self.cardRole:getPowerByFightType(self.fightType))
                -- self.txt_power:setText(self.cardRole:getPowerByFightType(self.fightType))
            end
        end
    end
    TFDirector:addMEGlobalListener(CardRoleManager.updateFateMessage, self.updateFateMessageCallBack) 

    self.accelerometerUpdateCallBack = function(event)
        local data = event.data[1]
        if self and self.didAccelerate then
            self:didAccelerate(data)
        end
    end

    TFDirector:addMEGlobalListener("HeitaoSdk.ACCELEROMETER_UPDATE"  ,self.accelerometerUpdateCallBack)
    --
    self.panel_changename:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onPanelNameClickHandle), 1)
    self.btn_huanyuan:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onHuanyuanClickHandle), 1)
    self.btn_queding:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onQuedingClickHandle), 1)
    self.playernameInput:setMaxLengthEnabled(true)
    self.playernameInput:setMaxLength(10)
    self.playernameInput:setKeyBoardType(0)
    self.btn_gaiming.logic    = self;
    self.btn_huanyuan.logic    = self;
    self.btn_queding.logic    = self;
    local function onTextFieldDetachHandle(input)
        self.playernameInput:closeIME()
    end
    self.checkNameResult = function(event)
        local result = event.data[1][1]
        if result and result == 0 then
            self:onChangeNameSuccess()
        else
            toastMessage(localizable.player_invalide_name)
        end
    end
    TFDirector:addMEGlobalListener(CardRoleManager.CHECK_SENSITIVE_VOCABULARY_RESPONSE, self.checkNameResult)

    self.playernameInput:addMEListener(TFTEXTFIELD_DETACH, onTextFieldDetachHandle)
    self.btn_gaiming.logic    = self;
    self.btn_gaiming:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onGaimingClickHandle), 1)
end

--确定
function RoleInfoLayer.onQuedingClickHandle(sender)
    local self = sender.logic
    if not self.cardRole then
        return
    end
    local self = sender.logic
    local name = self.playernameInput:getText()

    if Public:isRoleNameLegal(name) then
        CardRoleManager:requestCheckName(name)
    end
end

function RoleInfoLayer:onChangeNameSuccess()
    local name = self.playernameInput:getText()
    self.cardRole:changeName(name)
    print("name ++++")
    self:hideNamePanel()
    self.txt_name:setText(name)
end
function RoleInfoLayer:hideNamePanel()
    self.panel_changename:setVisible(false)
end

--还原
function RoleInfoLayer.onHuanyuanClickHandle(sender)
    local self = sender.logic
    if not self.cardRole then
        return
    end
    local defaultName = self.cardRole:getDefaultName()
    self.playernameInput:setText(defaultName)
end

function RoleInfoLayer.onPanelNameClickHandle(sender)
    local self = sender.logic
    self.playernameInput:closeIME()
    self:hideNamePanel()
end
function RoleInfoLayer:removeEvents()
    self.btnCurIndex            = 1
    -- 移除进阶特效
    self:removeJinJieEffect()

    self:removeEquipEvent()

    TFDirector:removeMEGlobalListener(MartialManager.MSG_MartialLevelUp, self.MartialLevelUpEventCallBak )
    self.MartialLevelUpEventCallBak = nil

    -- add by king  大月卡增加属性
    TFDirector:removeMEGlobalListener(MonthCardManager.MONTH_CARD_RefeshAttr,self.monthCardUpdateAttr)
    self.monthCardUpdateAttr = nil
    -- end


    TFDirector:removeMEGlobalListener("MoveRoleListToLeft", self.MoveRoleListToLeftFun)
    self.MoveRoleListToLeftFun = nil

    TFDirector:removeMEGlobalListener("MoveRoleListToRole", self.MoveRoleListToRoleFun)
    self.MoveRoleListToRoleFun = nil

    TFDirector:removeMEGlobalListener("MoveRoleListToRight", self.MoveRoleListToRightFun)
    self.MoveRoleListToRightFun = nil


    TFDirector:removeMEGlobalListener(CardRoleManager.updateFateMessage, self.updateFateMessageCallBack)  
    self.updateFateMessageCallBack = nil

    TFDirector:removeMEGlobalListener(CardRoleManager.CHECK_SENSITIVE_VOCABULARY_RESPONSE, self.checkNameResult)  
    self.checkNameResult = nil

    -- self.ui:updateToFrame("power_change",100)
    if self.toastLabelList then
        for k,v in pairs(self.toastLabelList) do
            v:removeFromParent()
            v = nil
        end
        self.toastLabelList = nil
    end

    if self.toastTimeId ~= nil then
        TFDirector:removeTimer(self.toastTimeId);
        self.toastTimeId = nil
    end

    if self.power_effect then
        self.power_effect:setVisible(false)
    end
    self:setTouchPanelEnabled(false)
    if self.LayerList then 
        for i=1,3 do
            local layer = self.LayerList[i].layer
            if layer then
                layer:removeEvents()
            end
        end
    end

    if self.skyBookEquipTimer then
        TFDirector:removeTimer(self.skyBookEquipTimer)
        self.skyBookEquipTimer = nil
    end

    if self.updateTimerID then
        TFDirector:removeTimer(self.updateTimerID)
        self.updateTimerID = nil
    end

    TFDirector:removeMEGlobalListener("HeitaoSdk.ACCELEROMETER_UPDATE", self.accelerometerUpdateCallBack)    
    self.accelerometerUpdateCallBack = nil

    self.super.removeEvents(self)
end


function RoleInfoLayer.onCloseClickHandle(sender)
    local self = sender.logic;

    if (self.img_select) then
        self:removeSelectIcon();
        self:closeEquipListLayer();
       return;
    end 
    IllustrationManager.isOpenTuJian = false
    FengYunLuManager.isOpenFengYunLu = false
    AlertManager:close(AlertManager.TWEEN_1);
end

-- 绘制默认的ui  培养
function RoleInfoLayer:drawDefault()
    
    -- 处理缓存的现场
    if self.LayerList then 
        for i=1,3 do
            local layer = self.LayerList[i].layer
            if layer then
                layer:setVisible(false)
            end
        end
    end
    
    if  self.BtnSetting then
        for i=1,3 do
            local btnInfo = self.BtnSetting[i]
            btnInfo.btn:setTextureNormal(btnInfo.normal)
        end

    end
    -- end

    self.btnCurIndex = self.btnCurIndex or 1
    self:drawContentWithIndex(self.btnCurIndex, false)
end

function RoleInfoLayer:drawContentWithIndex(index, action)
    -- if self.btnCurIndex == index then
    --     return
    -- end

    -- 绘制上面的按钮
    local LastIndex = self.btnCurIndex

    if self.btnCurIndex and self.btnCurIndex > 0 then
        local btnInfo = self.BtnSetting[self.btnCurIndex]
        btnInfo.btn:setTextureNormal(btnInfo.normal)
        btnInfo.btn:setZOrder(1)
    end

    self.btnCurIndex  = index

    local curBtnInfo = self.BtnSetting[self.btnCurIndex]
    curBtnInfo.btn:setTextureNormal(curBtnInfo.select)
    curBtnInfo.btn:setZOrder(3)

    -- action 是否有动画
    -- -- 呼出对应的界面
    self:showListLayer(index, LastIndex, action)
end

function RoleInfoLayer.BtnClickHandle(sender)
    local self  = sender.logic
    local index = sender.index

    if self.btnCurIndex == index then
        return
    end

    self:drawContentWithIndex(index, true)

end
function RoleInfoLayer:showNamePanel()
    if not self.cardRole then
        return
    end
    self.panel_changename:setVisible(true)
    local name = self.cardRole.name or ""
    self.playernameInput:setPlaceHolder(self.cardRole.name or "")
    self.playernameInput:setText(name)
end

function RoleInfoLayer.onTaoZhuangClickHandle(sender)
    local self = sender.logic  
    local layer =  AlertManager:addLayerByFile("lua.logic.role_new.RoleTaoZhuang", AlertManager.BLOCK_AND_GRAY_CLOSE)
    layer:loadData(self.data)
    AlertManager:show()
end

--改名
function RoleInfoLayer.onGaimingClickHandle(sender)
    local self = sender.logic
    self:showNamePanel()
end
function RoleInfoLayer:showListLayer(index, LastIndex, action)
    if self.bg_wxbtn and self.type ~= "self" and index ~= 1 then
        self.bg_wxbtn:setVisible(false)
    end

    if self.type == "other" then
        self.bg_wxbtn:setVisible(false)
    end
    self.bg_wxbtn:setPosition(ccp(642, 350))
    self.bg_wxbtn:setZOrder(120)

    -- 没有则创建
    if self.LayerList[index].layer == nil then
        local path = self.LayerList[index].path
        local newLayer = require(path):new()
        self.panel_content:addChild(newLayer)
        self.LayerList[index].layer = newLayer
    end

    self.LayerList[index].layer.type = self.type
    self.LayerList[index].layer.fightType = self.fightType
    self.LayerList[index].layer:setCardRole(self.cardRole)
    

    if LastIndex == nil then
        self.LayerList[index].layer:setVisible(true)
    else
        -- self.LayerList[LastIndex].layer:setVisible(false)
        for i=1,3 do
            if self.LayerList[i].layer then
                self.LayerList[i].layer:stopAllActions()
                if i ~= index and i ~= LastIndex then
                    self.LayerList[i].layer:setVisible(false)
                end
            end
        end
        self.LayerList[index].layer:setVisible(true)
        self.LayerList[index].layer:setPosition(ccp(0, 0))

        self.LayerList[LastIndex].layer:setZOrder(1)
        self.LayerList[LastIndex].layer:setVisible(true)
        self.LayerList[index].layer:setZOrder(2)

        if action == nil or action == false then
            return
        end

        -- 动画
        local layer = self.LayerList[LastIndex].layer
        --local tox = -200
        local tox = 0
        local toy = 0
        -- layer:setPosition(ccp(0, 0))
        -- -- 隐藏界面
        -- local tween1 = 
        -- {
        --     target = layer,
        --     {
        --         ease = {type=TFEaseType.EASE_IN_OUT, rate=5},
        --         duration = 0.1,
        --         x = tox,
        --         y = toy,
        --         onComplete = function ()
        --             print("move complete")
        --         end,
        --     },
        -- }
        -- TFDirector:toTween(tween1)
        self.lastLayer = layer

        -- 打开界面
        layer = self.LayerList[index].layer
        tox = 0
        toy = 0
        --layer:setPosition(ccp(-400, 0))
        layer:setPosition(ccp(1000, 0))
        local tween2 = 
        {
            target = layer,
            {   
                -- ease = {type=TFEaseType.EASE_IN_OUT, rate=5},
                ease = {type=TFEaseType.EASE_IN_OUT, rate=3}, --由慢到快
                duration = 0.3,
                x = tox,
                y = toy,
                onComplete = function ()
                    print("move complete")
                    if self.lastLayer then
                        self.lastLayer:setVisible(false)
                        self.lastLayer = nil
                    end

                    -- 增加图鉴按钮 self.type
                    if self.bg_wxbtn and index == 1 and self.type == "self" then
                        --self.bg_wxbtn:setVisible(true)
                        self.bg_wxbtn:setVisible(false)
                    else
                        self.bg_wxbtn:setVisible(false)
                    end
                    -- self.LayerList[LastIndex].layer:setVisible(false)
                end,
            },

        }
        TFDirector:toTween(tween2)
    end

    self.LayerList[index].layer:onShow()

end

function RoleInfoLayer.onLeftClickHandle(sender)
    local self = sender.logic;
    local pageIndex = self.pageView:getCurPageIndex() ;
    self.pageView:scrollToPage(pageIndex - 1);
end

function RoleInfoLayer.onRightClickHandle(sender)
    local self = sender.logic;
    local pageIndex = self.pageView:getCurPageIndex() ;
    self.pageView:scrollToPage(pageIndex + 1);
end

function RoleInfoLayer:refreshRoleList(pageIndex)
    self.pageView:_removeAllPages();

    self.pageView:setMaxLength(self.roleList:length())

    self.pageList        = {};

    self:showInfoForPage(pageIndex);

    self.pageView:InitIndex(pageIndex);      
end

function RoleInfoLayer:onPageChange()
    local pageIndex = self.pageView:_getCurPageIndex() ;
    self:showInfoForPage(pageIndex);
    if self.soundHandle then
        TFAudio.stopEffect(self.soundHandle)
    end
    self.soundHandle = RoleSoundData:playSoundByIndex(self.cardRoleId)
end

function RoleInfoLayer:addBgEffect()
    if self.bg_effect then
        return
    end

    local effectName = "role_bg_panel"
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/" .. effectName .. ".xml")
    local effect = TFArmature:create(effectName .. "_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        effect:setZOrder(1)
        -- local size = self.ui:getSize()
        -- effect:setPosition( ccp(size.width / 2, size.height / 2) )
        -- self.ui:addChild(effect)

        local bg = TFDirector:getChildByPath(self, "bg")

        local size = bg:getSize()
        effect:setPosition( ccp(size.width / 2, size.height / 2) )
        bg:addChild(effect)

        self.bg_effect = effect
    end
end

function RoleInfoLayer:addPage(pageIndex) 
    local page = TFPanel:create();
    page:setSize(self.panel_list:getContentSize())


    local cardRole = self.roleList:objectAt(pageIndex)
    if self.type == "self" then
        local cardRoleId   = self.roleList:objectAt(pageIndex)
        cardRole = CardRoleManager:getRoleById(cardRoleId);
    end

    local img_role = TFImage:create(cardRole:getBigImagePath())
    if (img_role == nil) then
        img_role = TFImage:create("icon/rolebig/10001.png")
        local tips = localizable.common_error..(cardRole.name or "")
        toastMessage(tips)
    end
    --img_role:setScale(0.65)
    img_role:setFlipX(true)
    Public:addRoleBgEffect(1, img_role, cardRole.starlevel, cardRole.quality)
    --img_role:setAnchorPoint(ccp(0.5,0.5))
    --img_role:setPosition(ccp(320/2,500/2))

    local sizeX = self.panel_list:getContentSize().width
    img_role:setPosition(ccp(sizeX/2,500/2 - 130))

    local data = { scale = 0.75, posDown = ccp(sizeX / 2, 500 / 2 - 150) }
    Public:addRoleBgEffect(2, page, cardRole.starlevel, cardRole.quality, data)
    page:addChild(img_role)

    img_role:setAnchorPoint(ccp(0.5, 0.1))
    --img_role:setPosition(ccp(320/2 + 40,500/2 - 130))
    
    --img_role:setScale(2)
    local factor = 0.8
    img_role:setScale(factor)

    local totalTime = 1.2
    local maxScaleY = 1.03
    local maxScaleX = 1.01
    local tweenScale = {
          target = img_role,
          repeated = -1,
          {
            duration = 0,
            scaleY = 1 * factor,
            scaleX = 1 * factor,
          },
          {
            duration = totalTime / 6 * 1.5,
            scaleY = 1.01 * factor,
            scaleX = 1.003 * factor,
          },
          {
            duration = totalTime / 6 * 1.5,
            scaleY = 1.02 * factor,
            scaleX = 1.006 * factor,
          },
          {
            duration = totalTime / 6 * 3,
            scaleY = maxScaleY * factor,
            scaleX = maxScaleX * factor,
          },
          { 
            duration = totalTime / 6 * 3,
            scaleY = 1.02 * factor,
            scaleX = 1.006 * factor,
          },
          {
             duration = totalTime / 6 * 1.5,
             scaleY = 1.01 * factor,
             scaleX = 1.003 * factor,
          },
          {
            duration = totalTime / 6 * 1.5,
            scaleY = 1 * factor,
          },
    }

    TFDirector:toTween(tweenScale)
  
    self.pageList[cardRole.id] = page

    return page;
end

function RoleInfoLayer:showInfoForPage(pageIndex)
    self.selectIndex = pageIndex;

    self:refreshRoleInfo()
    local pageCount = self.roleList:length()

    self.btn_left:setPosition(ccp(self.btn_left:getPosition().x,1000))
    self.btn_right:setPosition(ccp(self.btn_right:getPosition().x,1000))

    if pageIndex < pageCount and pageCount > 1 then
        self.btn_right:setPosition(ccp(self.btn_right:getPosition().x,self.positiony))
    end 

    if pageIndex > 1 and pageCount > 1  then
        self.btn_left:setPosition(ccp(self.btn_left:getPosition().x,self.positiony))
    end

end

function RoleInfoLayer:refreshRoleInfo()
    if self.type == "self" then
        self.cardRoleId   = self.roleList:objectAt(self.selectIndex);
        self.cardRole     = CardRoleManager:getRoleById(self.cardRoleId);
    elseif  self.type == LayerType.fengyunluType then
        self.cardRole   = self.roleList.m_list[self.selectIndex]
        self.cardRoleId = self.cardRole.id;
    else
        self.cardRole   = self.roleList:objectAt(self.selectIndex);
        if (not self.cardRole)then
            toastMessage(localizable.common_data_error)
            return
        end
        self.cardRoleId = self.cardRole.id;
    end
    
    local martialLevel = self.cardRole.martialLevel or 0
    
    if self.firstShowSound == true then
        if self.soundHandle then
            TFAudio.stopEffect(self.soundHandle)
        end
        self.soundHandle = RoleSoundData:playSoundByIndex(self.cardRoleId)
        self.firstShowSound = false
    end
    

    if self.type == "self" and self.cardRole.level == 1 and self.cardRole.curExp == 0 and self.cardRole.pos ~= 0 and self.LayerList[1].layer and self.LayerList[1].layer:isVisible() == true then
        PlayerGuideManager:doGuideByGuideID(2000)
    else
        PlayerGuideManager:closeGuideByGuideID(2000)
    end
    if self.type == "self" and self.cardRole:getHaveSoulNum() >= self.cardRole:getUpstarNeedSoulNum() and self.LayerList[1].layer and self.LayerList[1].layer:isVisible() == true then
        PlayerGuideManager:doGuideByGuideID(20)
    else
        PlayerGuideManager:closeGuideByGuideID(20)
    end
    --角色信息
    self.img_type:setTexture("ui_new/common/img_role_type" .. self.cardRole.outline .. ".png")
    self.txt_name:setText(self.cardRole.name)
    
    -- 20151105修改了怎么显示角色名字
    if self.type == "self" then
        print("主角。。。。。 ")
        self.btn_gaiming:setVisible(true)
        if ProtagonistData:IsMainPlayer(self.cardRoleId) then
            self.txt_name:setText(MainPlayer:getPlayerName())
            self.btn_gaiming:setVisible(false)
        end
    else
        self.btn_gaiming:setVisible(false)
    end

    if self.type == "other" and self.otherInfo then
        if ProtagonistData:IsMainPlayer( self.cardRoleId ) then
            self.txt_name:setText(self.otherInfo)
        end
    end

   
    self.img_quality:setTexture(GetFontByQuality(self.cardRole.quality))
    self.txt_power:setText(self.cardRole:getPowerByFightType(self.fightType))

    if self.cardRole.pos and self.cardRole.pos ~= 0 then 
        self.img_isfight:setVisible(true)
    else
        self.img_isfight:setVisible(false)
    end

    self.img_namebg:setTexture(GetRoleNameBgByQuality(self.cardRole.quality))
    -- self.img_namebg:setTexture("ui_new/role/bg-n" .. EnumWuxueBGType[martialLevel] .. ".png")
    --星级
    -- for i=1, 5 do
    --     if (i <= self.cardRole.starlevel) then
    --         self.img_starList[i]:setVisible(true)
    --     else
    --         self.img_starList[i]:setVisible(false)  
    --     end
    -- end    
    for i=1,5 do
        self.img_starList[i]:setVisible(false)
    end
    if self.type ==LayerType.fengyunluType then
        self.cardRole.starlevel = 10
    end
    -- for i=1,self.cardRole.starlevel do
    --     local starIdx = i
    --     local starTextrue = 'ui_new/common/xl_dadian22_icon.png'
    --     if i > 5 then
    --         starTextrue = 'ui_new/common/xl_dadian23_icon.png'
    --         starIdx = i - 5
    --     end
    --     self.img_starList[starIdx]:setTexture(starTextrue)
    --     self.img_starList[starIdx]:setVisible(true)
    -- end
    CardRoleManager:SetRoleStarTexture(self.cardRole.starlevel, self.img_starList)
    self:refreshEquipIcon()
    self:refreshInfoArea(self.cardRole)

    self.martialLevel = martialLevel


    self.panel_equip:setVisible(true)
    if FengYunLuManager.isOpenFengYunLu == false then
        self.panel_equip:setVisible(true)
        self.img_isfight:setVisible(true)
        self.txt_power:setVisible(true)
        self.img_fightpower:setVisible(true)
        self.img_ditu:setVisible(true)
    else
        self.panel_equip:setVisible(false)
        self.img_isfight:setVisible(false)
        self.txt_power:setVisible(false)
        self.img_fightpower:setVisible(false)
        self.img_ditu:setVisible(false)
    end
    local level = FunctionOpenConfigure:getOpenLevel(800)
    if level then
        local teamLev = MainPlayer:getLevel()
        if level > teamLev then
            self.panel_equip:setVisible(false)
        end
    end
    -- local status = MissionManager:getMissionPassStatus(1001);
    -- if status ~= MissionManager.STATUS_PASS then
    --     self.panel_equip:setVisible(false)
    -- end
end

function RoleInfoLayer:refreshInfoArea(cardRole)
    -- self.btnCurIndex
    -- if self.LayerList[index]

    for i=1,3 do
        local  layer = self.LayerList[i].layer

        if layer then
            layer:setCardRole(cardRole)
            layer.type  = self.type
            layer.logic = self
            if layer:isVisible() then
                layer:onShow()
            end
        end
    end
end

function RoleInfoLayer:refreshEquipIcon()

    if FengYunLuManager.isOpenFengYunLu == false then
        self.panel_equip:setVisible(true)
        for i=1, 6 do
            self.img_equipList[i]:setFlipX(false)
            self.img_equipEmptyList[i]:setFlipX(false)
            self.img_add[i]:setVisible(false)
            self.img_lock[i]:setVisible(false)
            CommonManager:setRedPoint(self.img_equipEmptyList[i]:getParent(), false,"IsHaveEquip")

            local equipInfo = self.cardRole:getEquipment():GetEquipByType(i)
            for j=1,EquipmentManager.kGemMergeTargetNum do
                self.img_gemBg[i][j]:setVisible(false);
            end
            if equipInfo == nil then
                -- print('equipInfo = ',equipInfo)
                self.img_equipList[i]:setVisible(false)
                self.img_equipQualityList[i]:setVisible(false)
                -- self.img_gemBg[i]:setVisible(false)
                for j=1,EquipmentManager.kGemMergeTargetNum do
                    self.img_gemBg[i][j]:setVisible(false);
                end
                self.img_equipEmptyList[i]:setVisible(true)

                -- 是否是被锁住的
                if self:equipIsLock(i) then
                    self.img_lock[i]:setVisible(true)
                else
                    if EquipmentManager:getIsHaveEquip(i,nil) == true then
                        self.img_add[i]:setVisible(true)
                        CommonManager:setRedPoint(self.img_equipEmptyList[i]:getParent(), true,"IsHaveEquip",ccp(40,60),nil,0.8)
                    else
                        self.img_add[i]:setVisible(false)
                        CommonManager:setRedPoint(self.img_equipEmptyList[i]:getParent(), false,"IsHaveEquip")
                    end
                end

            else
                self.img_equipList[i]:setVisible(true);
                self.img_equipQualityList[i]:setVisible(true)
                -- self.img_equipEmptyList[i]:setVisible(false);
                
                -- print('equipInfo.gemid = ',equipInfo.gemid)
                for j=1,EquipmentManager.kGemMergeTargetNum do
                    -- print('equipInfo.gemid = ',equipInfo.gemid)
                    local gemid = nil
                    if self.type == "self" then
                        gemid = equipInfo:getGemPos(j)
                    else
                        for _,gemInfo in pairs(equipInfo.gemid) do
                            if gemInfo.pos == j then
                                gemid = gemInfo.id
                                break
                            end
                        end
                    end
                    -- if j == 2 and self.type ~= "self" then
                    --     self.img_gemBg[i][j]:setVisible(false);
                    --     break
                    -- end
    
                    if gemid ~= nil and gemid ~= 0 then
                        self.img_gemBg[i][j]:setVisible(true);
                        -- print(gem,gemid)
                        local gem = ItemData:objectByID(gemid)
                        self.img_gem[i][j]:setTexture(gem:GetPath())
                    end                   
                end
                -- if self.type == "self" then
                --     gemid = equipInfo:getGemPos(1)
                -- else
                --     gemid = equipInfo.gemid
                -- end
    
                -- if gemid ~= nil and gemid ~= 0 then
                --     self.img_gemBg[i]:setVisible(true)
                --     -- print(gem,gemid)
                --     local gem = ItemData:objectByID(gemid)
                --     self.img_gem[i]:setTexture(gem:GetPath())
                -- end
                self.img_equipList[i]:setTexture(equipInfo.textrueName)
                self.img_equipQualityList[i]:setTextureNormal(GetColorIconByQuality(equipInfo.quality))
                EquipmentManager:BindEffectOnEquip(self.img_equipQualityList[i], equipInfo)
            end
        end

        -- added by wuqi
        self:refreshTianshuIcon()
        self:refreshXinfaIcon()
        -- 观察其他玩家信息的时候不能点击
        if self.type == "other" then
            for i=1,6 do
                self.img_equipQualityList[i]:setTouchEnabled(false)
                self.img_equipEmptyList[i]:setTouchEnabled(false)
                self.img_add[i]:setVisible(false)
                self.img_lock[i]:setVisible(false)
                CommonManager:setRedPoint(self.img_equipEmptyList[i]:getParent(), false,"IsHaveEquip")
            end
            -- added by wuqi
            self.panel_tianshu.img_quality:setTouchEnabled(false)
            self.panel_tianshu.img_empty:setTouchEnabled(false)
            self.panel_tianshu.img_add:setVisible(false)
            self.panel_tianshu.img_lock:setVisible(false)
            self.panel_xinfa.img_quality:setTouchEnabled(false)
            self.panel_xinfa.img_empty:setTouchEnabled(false)
            self.panel_xinfa.img_add:setVisible(false)
            self.panel_xinfa.img_lock:setVisible(false)
        elseif self.type == "self" then
            for i=1,6 do
                self.img_equipQualityList[i]:setTouchEnabled(true)
                self.img_equipEmptyList[i]:setTouchEnabled(true)
            end
            -- added by wuqi
            self.panel_tianshu.img_quality:setTouchEnabled(true)
            self.panel_tianshu.img_empty:setTouchEnabled(true)
            self.panel_xinfa.img_quality:setTouchEnabled(true)
            self.panel_xinfa.img_empty:setTouchEnabled(true)
        end
    else
        self.panel_equip:setVisible(false)
    end
end

-- added by wuqi
function RoleInfoLayer:refreshTianshuIcon()
    --self.panel_tianshu.img_equip:setFlipX(true)
    --self.panel_tianshu.img_empty:setFlipX(true)
    self.panel_tianshu.img_add:setVisible(false)
    self.panel_tianshu.img_lock:setVisible(false)

    local bookInfo = self.cardRole:getSkyBook()
    
    if bookInfo == nil then
        self.panel_tianshu.img_equip:setVisible(false)
        self.panel_tianshu.img_quality:setVisible(false)
        self.panel_tianshu.img_empty:setVisible(true)
        self.panel_tianshu.txt_qianghualv:setVisible(false)
		self.panel_tianshu.img_baoshicao1:setVisible(false)
        self.panel_tianshu.img_baoshicao2:setVisible(false)

        -- 是否是被锁住的
        if self:equipIsLock(self.TAG_TIANSHU) then
            self.panel_tianshu.img_lock:setVisible(true)
        else
            if self.isHaveSkyBook then
                self.panel_tianshu.img_add:setVisible(true)
            else
                self.panel_tianshu.img_add:setVisible(false)
            end
        end
    else
        self.panel_tianshu.img_equip:setVisible(true)
        self.panel_tianshu.img_quality:setVisible(true)
        self.panel_tianshu.txt_qianghualv:setVisible(true)

        self.panel_tianshu.img_equip:setTexture(bookInfo:GetTextrue())
        local _quality = SkyBookManager:GetUpQuality(bookInfo.quality, bookInfo.tupoLevel)
        self.panel_tianshu.img_quality:setTextureNormal(GetColorIconByQuality(_quality))

        self.panel_tianshu.txt_qianghualv:setVisible(true)
        --self.panel_tianshu.txt_qianghualv:setText(EnumSkyBookLevelType[bookInfo.level] .. "重")
        local str = stringUtils.format(localizable.Tianshu_chong_text, EnumSkyBookLevelType[bookInfo.level])
        self.panel_tianshu.txt_qianghualv:setText(str) 

		self.panel_tianshu.img_baoshicao1:setVisible(false)
        self.panel_tianshu.img_baoshicao2:setVisible(false)
        self.panel_tianshu.img_gem1:setVisible(true)
        self.panel_tianshu.img_gem2:setVisible(true)
		if bookInfo:getGemPos(1) and bookInfo:getGemPos(1) ~= 0 then
			local gemId = bookInfo:getGemPos(1)
			self.panel_tianshu.img_baoshicao1:setVisible(true)
			local item = ItemData:objectByID(gemId)
			self.panel_tianshu.img_gem1:setTexture(item:GetPath())
		end

        if bookInfo:getGemPos(2) and bookInfo:getGemPos(2) ~= 0 then
            local gemId = bookInfo:getGemPos(2)
            self.panel_tianshu.img_baoshicao2:setVisible(true)
            local item = ItemData:objectByID(gemId)
            self.panel_tianshu.img_gem2:setTexture(item:GetPath())
        end

        --Public:addStarImg(self.panel_tianshu.img_equip, bookInfo.tupoLevel)
        --EquipmentManager:BindEffectOnEquip(self.img_equipQualityList[i], equipInfo)
        if self.type ~= "other" then
            SkyBookManager:BindEffectOnEquip(self.panel_tianshu.img_quality, bookInfo)
        else
            local quality = self.biblePracticeQuality
            if quality == nil then
                local role = self.roleList:objectAt(self.selectIndex)
                local SkyBookInfo = role:getSkyBook()
                
                local level =0
                for i =1,#SkyBookInfo.chongzhuData do
                    if level < SkyBookInfo.chongzhuData[i].level then
                        level = SkyBookInfo.chongzhuData[i].level
                        quality = SkyBookInfo.chongzhuData[i].quality
                    end
                end
            end
            SkyBookManager:BindEffectOnEquip(self.panel_tianshu.img_quality, self.biblePracticeQuality, 2)
        end
        
    end
end
function RoleInfoLayer:refreshXinfaIcon()
    self.panel_xinfa.img_add:setVisible(false)
    self.panel_xinfa.img_lock:setVisible(false)

    local bookInfo = self.cardRole:getXinFa()
    
    if bookInfo == nil then
        self.panel_xinfa.img_equip:setVisible(false)
        self.panel_xinfa.img_quality:setVisible(false)
        self.panel_xinfa.img_empty:setVisible(true)
        self.panel_xinfa.txt_qianghualv:setVisible(false)

        -- 是否是被锁住的
        if self:equipIsLock(self.TAG_XINFA) then
            self.panel_xinfa.img_lock:setVisible(true)
            self.panel_xinfa:setVisible(false)
        else
            self.panel_xinfa:setVisible(true)
            if self.isHaveXinFa then
                self.panel_xinfa.img_add:setVisible(true)
            else
                self.panel_xinfa.img_add:setVisible(false)
            end
        end
    else
        self.panel_xinfa.img_equip:setVisible(true)
        self.panel_xinfa.img_quality:setVisible(true)
        self.panel_xinfa.txt_qianghualv:setVisible(true)

        self.panel_xinfa.img_equip:setTexture(bookInfo.config:GetPath())
        self.panel_xinfa.img_quality:setTextureNormal(GetColorIconByQuality(bookInfo.config.quality))

        self.panel_xinfa.txt_qianghualv:setVisible(true)
        --self.panel_xinfa.txt_qianghualv:setText(EnumSkyBookLevelType[bookInfo.level] .. "重")
        if bookInfo.level == 1 then
            self.panel_xinfa.txt_qianghualv:setVisible(false)
        else
            self.panel_xinfa.txt_qianghualv:setVisible(true)
        end
        self.panel_xinfa.txt_qianghualv:setText('+'..bookInfo.level) 
 
        -- if self.type ~= "other" then
        --     SkyBookManager:BindEffectOnEquip(self.panel_xinfa.img_quality, bookInfo)
        -- else
        --     print("self.cardRole.biblePracticeQuality ==== >>> ", self.biblePracticeQuality)
        --     SkyBookManager:BindEffectOnEquip(self.panel_xinfa.img_quality, self.biblePracticeQuality, 2)
        -- end
        if self.type ~= "other" then
            XinFaManager:BindEffectOnEquip(self.panel_xinfa.img_quality, bookInfo)
        else
            local role = self.roleList:objectAt(self.selectIndex)
            local bibleInfo = role:getXinFa()
            local quality = 0
            local level =0
            for i =1,#bibleInfo.chongzhuData do
                if level < bibleInfo.chongzhuData[i].level then
                    level = bibleInfo.chongzhuData[i].level
                end
            end
            quality = KongfuRefineData:getQualityBylevel(level)
            XinFaManager:BindEffectOnEquip(self.panel_xinfa.img_quality, quality, 2)
        end
    end
end

function RoleInfoLayer.onEquipIconClickHandle(sender)
    local self = sender.logic
    local index = sender:getTag()

    -- 判断是否是开启的状态
    if  self:equipIsLock(index) then
        local level = FunctionOpenConfigure:getOpenLevel(800 + index)
        --toastMessage("团队等级达到"..level.."开启")
        toastMessage(stringUtils.format(localizable.common_function_openlevel,level))
        return
    end


    local laseIndex = nil
    if (self.img_select) then
       laseIndex = self.img_select:getTag()
    end 
    self:removeSelectIcon()

    if (laseIndex == index) then
        --选择了同一个，直接返回
        self:closeEquipListLayer()
        return
    end

    local index = sender:getTag()
    local equipItem = self.cardRole:getEquipmentByIndex(index)
    local equipList = EquipmentManager:GetEquipByType(index)
    
    if  equipList:length() > 0 or equipItem then
        self:addSelectIcon(index)
        self:showEquipListLayer(index)
    else

        -- self:closeEquipListLayer()
        -- CommonManager:showNeedEquipComfirmLayer()
    
        self:addSelectIcon(index)
        self:showEquipListLayer(index)
    end
end

-- added by wuqi
function RoleInfoLayer.onTianshuIconClickHandle(sender)
    local self = sender.logic
    local index = sender:getTag()
    
    local lastIndex = nil
    if (self.img_select) then
       lastIndex = self.img_select:getTag()
    end 
    self:removeSelectIcon()

    if (lastIndex == index) then
        --选择了同一个，直接返回
        self:closeEquipListLayer()
        return
    end
    local equipItem = self.cardRole:getSkyBook()
    local equipList = SkyBookManager:getAllSkyBook()  

    self:addSelectIcon(index)
    self:showEquipListLayer(index)  

    self.isClickSkyBook = true
    self:MoveToClick(self.panel_equip)

    --SkyBookManager:testTupo()
    --SkyBookManager:testExplode()
    --SkyBookManager:testReset()
end
function RoleInfoLayer.onXinfaIconClickHandle(sender)
    local self = sender.logic
    local index = sender:getTag()
    
    local lastIndex = nil
    if (self.img_select) then
       lastIndex = self.img_select:getTag()
    end 
    self:removeSelectIcon()

    if self.type and self.type == "self" then
        if (lastIndex == index) then
            --选择了同一个，直接返回
            self:closeEquipListLayer()
            return
        end
        --local equipItem = self.cardRole:getSkyBook()
        local equipList = XinFaManager:getAllXinFa()  

        self:addSelectIcon(index)
        self:showEquipListLayer(index)  
    else
        local role = self.roleList:objectAt(self.selectIndex)
        local bibleInfo = role:getXinFa()
        print("心法隐藏",bibleInfo)
        if bibleInfo and bibleInfo.equipHide then
            toastMessage( localizable.OtherPlayerManager_equip_hide )
            return
        end
        if (lastIndex == index) then
            self:closeOtherEquipLayer()
            return
        end
        self:addSelectIcon(index)
        local role = self.roleList:objectAt(self.selectIndex)
        local bibleInfo = role:getXinFa()
        self:closeOtherEquipLayer()
        local layer = require("lua.logic.role.OtherXinFaInfoLayer"):new()
        layer:setZOrder(100)
        layer:loadData(bibleInfo, EnumGameItemType.XinFa)
        layer:onShow();
        self:addLayer(layer);
        self.curLayer = layer
    end

    self.isClickXinFa = true
    self:MoveToClickXinfa(self.panel_equip)
end

function RoleInfoLayer:addSelectIcon(index)
    self:removeSelectIcon();

    local img_select = TFImage:create("ui_new/roleequip/js_zbkxuanzhong_icon.png")
    img_select:setTag(index);

    --added by wuqi
    if index == self.TAG_TIANSHU then
        img_select:setPosition(self.panel_tianshu.img_empty:getPosition())
        self.panel_tianshu.img_empty:getParent():addChild(img_select, 10)
        self.img_select = img_select
        return
    end

    if index == self.TAG_XINFA then
        img_select:setPosition(self.panel_tianshu.img_empty:getPosition())
        self.panel_xinfa.img_empty:getParent():addChild(img_select, 10)
        self.img_select = img_select
        return
    end

    img_select:setPosition(self.img_equipEmptyList[index]:getPosition());
    self.img_equipEmptyList[index]:getParent():addChild(img_select,10);

    self.img_select = img_select;
end

function RoleInfoLayer:removeSelectIcon()
    if (self.img_select) then
       self.img_select:removeFromParent();
       self.img_select = nil;
    end 
end

-- 进入装备界面
function RoleInfoLayer:showEquipListLayer(index)
    self:closeEquipListLayer()
    --if (self.equipLayer == nil) then
    self.btnCurIndex = self.btnCurIndex or 1
    local equipLayer = nil
    self.panel_left:setVisible(false)
    self.panel_equip:setPositionX(30)
    self.LayerList[self.btnCurIndex].layer:setVisible(false)
    self.newIndex = 2
    self.bg_right:setVisible(false)

    if index == self.TAG_TIANSHU then
        equipLayer = require("lua.logic.role.RoleSkyBookInfoLayer"):new()
    elseif index == self.TAG_XINFA then
        equipLayer = require("lua.logic.role.RoleXinFaInfoLayer"):new()
    else
        equipLayer = require("lua.logic.role.RoleEquipInfoLayer"):new()
    end
    equipLayer.logic = self
    equipLayer:setTag(10086)
    equipLayer:setZOrder(2)
    equipLayer:setPosition(ccp(100, 0))
    self.panel_equplist:addChild(equipLayer)

    local btn_close = TFDirector:getChildByPath(equipLayer,"btn_close")
    btn_close.logic     = self
    btn_close:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onEquipCloseClickHandle),1)

    self.equipLayer = equipLayer
    self.equipLayer.logic = self
    --end

    self.btn_left:setVisible(false)
    self.btn_right:setVisible(false)
    --传入角色id, 部位id
    self.equipLayer:loadData(self.cardRole.gmId,index)
    self.equipLayer:onShow()
    
end


function RoleInfoLayer:SetGuideMode(visible)

    self.btn_left:setVisible(not visible)
    self.btn_right:setVisible(not visible)
end


function RoleInfoLayer:closeEquipListLayer( isRunAnimation)
    if self.equipLayer then
        --self:removeLayer(self.equipLayer,true)
        TFFunction.call(self.equipLayer.dispose, self.equipLayer);
        self.panel_equplist:removeChild(self.equipLayer);
        self.equipLayer = nil
    end
    if isRunAnimation == nil then
        isRunAnimation = true
    end
    if self.isClickSkyBook == true and isRunAnimation == true then
        self.isClickSkyBook = false
        self:MoveToRetuen(self.panel_equip)
    end

    if self.isClickXinFa == true and isRunAnimation == true then
        self.isClickXinFa = false
        self:MoveToRetuen(self.panel_equip)
    end

    self.btn_left:setVisible(true)
    self.btn_right:setVisible(true)

    self.btnCurIndex = self.btnCurIndex or 1
    self.panel_left:setVisible(true)
    self.panel_equip:setPositionX(99)
    self.LayerList[self.btnCurIndex].layer:setVisible(true)
    self.bg_right:setVisible(false)
    self.newIndex = 1
end
function RoleInfoLayer:closeOtherEquipLayer(isRunAnimation)
    if self.curLayer then
        self:removeLayer(self.curLayer, true)
        self.curLayer = nil
    end
    if isRunAnimation == nil then
        isRunAnimation = true
    end
    if self.isClickSkyBook == true and isRunAnimation == true then
        self.isClickSkyBook = false
        self:MoveToRetuen(self.panel_equip)
    end

    if self.isClickXinFa == true and isRunAnimation == true then
        self.isClickXinFa = false
        self:MoveToRetuen(self.panel_equip)
    end

    self.btn_left:setVisible(true)
    self.btn_right:setVisible(true)
end

function RoleInfoLayer:runAnimationBack()
    -- self.isClickSkyBook = false
    -- self.ui:runAnimation("Action1",1)
end
function RoleInfoLayer:registerEquipEvent()
    self.EquipUpdateCallBack = function(event)
        self:removeSelectIcon();
        self:closeEquipListLayer();
        self:refreshUI();
    end
    TFDirector:addMEGlobalListener(EquipmentManager.EQUIP_OPERATION,  self.EquipUpdateCallBack)
    TFDirector:addMEGlobalListener(EquipmentManager.UNEQUIP_OPERATION ,  self.EquipUpdateCallBack)
    TFDirector:addMEGlobalListener(XinFaManager.EQUIP_OPERATION,  self.EquipUpdateCallBack)
    TFDirector:addMEGlobalListener(XinFaManager.UNEQUIP_OPERATION ,  self.EquipUpdateCallBack)
	--added by wuqi
    self.SkyBookUpdateCallBack = function(event)
        self:removeSelectIcon();
        self:closeEquipListLayer(false);
        self:refreshUI();
        if self.skyBookEquipTimer then
            TFDirector:removeTimer(self.skyBookEquipTimer)
            self.skyBookEquipTimer = nil
        end
        self.skyBookEquipTimer = TFDirector:addTimer(1,1,nil,function ()
            if self.isClickSkyBook == true then
                self.isClickSkyBook = false
                self:MoveToRetuen(self.panel_equip)
            end
            TFDirector:removeTimer(self.skyBookEquipTimer)
            self.skyBookEquipTimer = nil
        end)
    end
	TFDirector:addMEGlobalListener(SkyBookManager.EQUIP_OPERATION,  self.SkyBookUpdateCallBack)
    TFDirector:addMEGlobalListener(SkyBookManager.UNEQUIP_OPERATION ,  self.SkyBookUpdateCallBack)
 
    self.EquipmentChangeBeginCallBack = function (event)
        self.cardRole     = CardRoleManager:getRoleById(self.cardRoleId);
        if self.cardRole == nil then
            return
        end
        self.oldarr = {}

        --角色属性
        for i=1,EnumAttributeType.Max do
            self.oldarr[i] = self.cardRole:getTotalAttribute(i)
        end
        self.isAuto = event.data[1].isAuto

        self.oldpower = self.cardRole:getPowerByFightType(self.fightType)
    end
    TFDirector:addMEGlobalListener("EquipmentChangeBegin",self.EquipmentChangeBeginCallBack)
	TFDirector:addMEGlobalListener("SkyBookChangeBegin",self.EquipmentChangeBeginCallBack)
    TFDirector:addMEGlobalListener("XinFaChangeBegin",self.EquipmentChangeBeginCallBack)
    self.EquipmentChangeEndCallBack = function (event)

        if self.isAuto then
            return
        end

        local  newarr = {}
        --角色属性
        for i=1,EnumAttributeType.Max do
            newarr[i] = self.cardRole:getTotalAttribute(i)
        end

        if self.oldarr and newarr then
            self:arrChange( self.oldarr,newarr)
        end

        local newpower = self.cardRole:getPowerByFightType(self.fightType)
        self:textChange(self.oldpower,newpower)

        -- self.newpower = newpower
    end
    TFDirector:addMEGlobalListener("EquipmentChangeEnd",self.EquipmentChangeEndCallBack)
	TFDirector:addMEGlobalListener("SkyBookChangeEnd",self.EquipmentChangeEndCallBack)
    TFDirector:addMEGlobalListener("XinFaChangeEnd",self.EquipmentChangeEndCallBack)
end

function RoleInfoLayer:removeEquipEvent()
    TFDirector:removeMEGlobalListener(EquipmentManager.EQUIP_OPERATION, self.EquipUpdateCallBack)
    TFDirector:removeMEGlobalListener(EquipmentManager.UNEQUIP_OPERATION, self.EquipUpdateCallBack)
	TFDirector:removeMEGlobalListener(XinFaManager.EQUIP_OPERATION,  self.EquipUpdateCallBack)
    TFDirector:removeMEGlobalListener(XinFaManager.UNEQUIP_OPERATION ,  self.EquipUpdateCallBack)
    TFDirector:removeMEGlobalListener(SkyBookManager.EQUIP_OPERATION, self.SkyBookUpdateCallBack)
    TFDirector:removeMEGlobalListener(SkyBookManager.UNEQUIP_OPERATION, self.SkyBookUpdateCallBack)
    self.SkyBookUpdateCallBack = nil
    TFDirector:removeMEGlobalListener("EquipmentChangeBegin",self.EquipmentChangeBeginCallBack)
    TFDirector:removeMEGlobalListener("EquipmentChangeEnd",self.EquipmentChangeEndCallBack)
	TFDirector:removeMEGlobalListener("SkyBookChangeBegin",self.EquipmentChangeBeginCallBack)
    TFDirector:removeMEGlobalListener("SkyBookChangeEnd",self.EquipmentChangeEndCallBack)
    TFDirector:removeMEGlobalListener("XinFaChangeBegin",self.EquipmentChangeBeginCallBack)
    TFDirector:removeMEGlobalListener("XinFaChangeEnd",self.EquipmentChangeEndCallBack)
end

function RoleInfoLayer:arrChange(oldarr,newarr)
    local changeArrTemp = {}
    local changeLength = 0;
    for i=1,EnumAttributeType.Max do
        local offset = newarr[i] - oldarr[i];
        if offset ~= 0 then
            changeLength = changeLength + 1;
            changeArrTemp[changeLength] = {i,offset};

        end
    end

    local changeArr = {}

    local index = 0;
    for i=1,#changeArrTemp do
        local offsetTb = changeArrTemp[i];
        if offsetTb[2] > 0 then
            index = index + 1;
            changeArr[index] = offsetTb;
        end
    end

    for i=1,#changeArrTemp do
        local offsetTb = changeArrTemp[i];
        if offsetTb[2] < 0 then
            index = index + 1;
            changeArr[index] = offsetTb;
        end
    end


    local index = 1;
    function addToast()
        if #changeArr < 1 then
            return;
        end

        local offsetTb = changeArr[index];

        -- print("offset:",AttributeTypeStr[offsetTb[1]],offsetTb[2])


        local label = TFLabelBMFont:create();
        label:setPosition(ccp(306,30));
        self.panel_center:addChild(label,10);

        self.toastLabelList = self.toastLabelList or {}
        self.toastLabelList[offsetTb[1]] = label

        if offsetTb[2] > 0 then
            label:setFntFile("font/num_100.fnt")
            -- label:setColor(ccc3(  0, 255,   0));
            label:setText(AttributeTypeStr[offsetTb[1]] .. "+" .. covertToDisplayValue(offsetTb[1],offsetTb[2]));
        end

        if offsetTb[2] < 0 then
            label:setFntFile("font/num_99.fnt")
            -- label:setColor(ccc3(255,   0,   0));
            label:setText(AttributeTypeStr[offsetTb[1]] .. covertToDisplayValue(offsetTb[1],offsetTb[2]));
        end
        -- local toY = label:getPosition().y + (changeLength - index + 2) * 40;
        local toY = label:getPosition().y + 167;
        local toX = label:getPosition().x;
        
        label:setScale(0.5)
        label:setOpacity(0.1);
        local toastTween = {
              target = label,
              {
                duration = 7/24,
                x = toX,
                y = toY,
                scale = 1,
                alpha = 1,
              },
              {
                duration = 17/24,
                x = toX,
                y = toY+114,
                alpha = 0,
                onComplete = function() 
                    if self.toastLabelList then
                        self.toastLabelList[offsetTb[1]] = nil
                    end
                    label:removeFromParent();
               end
              }
            }
 
        TFDirector:toTween(toastTween);
        index = index + 1;
    end

    function addToastCom()
        TFDirector:removeTimer(self.toastTimeId);
        self.toastTimeId = nil;
    end

    addToast();

    if self.toastTimeId ~= nil then
        TFDirector:removeTimer(self.toastTimeId);
        self.toastTimeId = nil
    end
    if  changeLength > 1 then
        self.toastTimeId = TFDirector:addTimer(334, changeLength -1, addToastCom, addToast);
    end
end

function RoleInfoLayer:textChange(oldValue,newValue)
    if not oldValue or not newValue then
        return;
    end
    
    self.txt_power:setText(oldValue);

    local changeSum = newValue - oldValue

    if self.power_effect == nil then
        local resPath = "effect/ui/power_change.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        effect = TFArmature:create("power_change_anim")

        self.txt_power:addChild(effect,2)
        self.power_effect = effect
        self.power_effect:setVisible(false)
    end

    local frame = 1
    self.txt_power:setScale(1)
    self.ui:setAnimationCallBack("power_change", TFANIMATION_FRAME, function()
        if frame == 11 then
            if newValue > oldValue then
                play_shuzibiandong()
            end
            self.power_effect:setVisible(true)
            self.power_effect:playByIndex(0, -1, -1, 0)
        end
        if frame >= 11 and frame < 34 then
            local tempValue = oldValue + (frame - 11) *(changeSum/23)
            self.txt_power:setText(math.floor(tempValue));
        end
        if frame == 34 then
            self.power_effect:removeFromParent()
            self.power_effect = nil
            self.txt_power:setText(newValue);
        end
        frame = frame + 1
    end)
    self.ui:runAnimation("power_change",1);
end

function RoleInfoLayer:beginMartialLevelUp()
    self.beforeMartialUpPower = self.cardRole:getPowerByFightType(self.fightType)
    self.beforeMartialLevel   = self.cardRole.martialLevel
end

function RoleInfoLayer:showJinJieEffect()
    local effect = self.effect
    if effect == nil then
        local resPath = "effect/book_jinjie_effect.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        effect = TFArmature:create("book_jinjie_effect_anim")

        -- effect:setAnimationFps(GameConfig.ANIM_FPS)

        self:addJinJieEffect(effect)

        self.effect = effect

        self.effectCompelte = false
        effect:addMEListener(TFARMATURE_COMPLETE,function()
            self.EquipmentChangeEndCallBack()
            self:showJinJieResult()
            self:refreshUI()
            self.effectCompelte = true
            self:setTouchPanelEnabled(false)
            if self.effect then
                self.effect:setVisible(false)
            end
        end)
    end

    local frame_num = 1
    effect:addMEListener(TFARMATURE_UPDATE, function ()
        frame_num = frame_num + 1
        if frame_num > 10 then
            effect:removeMEListener(TFARMATURE_UPDATE)
            local layer = self.LayerList[1].layer
            if layer and self.cardRole then
                layer:refreshMartialLevel(self.cardRole.martialLevel)
            end
        end
    end)

    effect:setVisible(true)
    self:setTouchPanelEnabled(true)
    effect:playByIndex(0, -1, -1, 0)
end

function RoleInfoLayer:removeJinJieEffect()
    if self.effect then
        self.effect:setVisible(false)
    end
end

function RoleInfoLayer:showJinJieResult()
    local layer  = require("lua.logic.role_new.RoleBreakResultLayer"):new()
    layer:setRole(self.cardRole)
    layer:setPower(self.beforeMartialUpPower,self.fightType)
    layer:setOldMartialLevel(self.beforeMartialLevel)
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY_CLOSE, AlertManager.TWEEN_1)
    AlertManager:show() 
end


function RoleInfoLayer:getJinjieEffectResult()
    return true
    -- if self.effectCompelte == nil then
    --     return true
    -- end

    -- return self.effectCompelte
end

function RoleInfoLayer:drawTuPuInfo()
    local bDisplay = false

    if  self.bShowTuPu ~= nil and  self.bShowTuPu then
        bDisplay = true
    end
    local  layer = self.LayerList[1].layer

    if layer then
        layer.bShowTuPu = bDisplay
        layer:showTuPuButton(bDisplay)
    end
end

function RoleInfoLayer:equipIsLock(equipIndex)
    --added by wuqi
    --test
    if equipIndex == self.TAG_TIANSHU then
        return false
    end
    if equipIndex == self.TAG_XINFA then
        return not FunctionOpenConfigure:isFuctionOpen(2231)
    end
	if equipIndex == self.TAG_TOUSHI then
        return false
    end

    return not FunctionOpenConfigure:isFuctionOpen(800 + equipIndex)
    -- return true
end

function RoleInfoLayer:setTouchPanelEnabled(enable)
    if self.touchPanel == nil then
        return
    end

    
    self.touchPanel:setTouchEnabled(enable)
    if enable == true then
        self.touchPanel:addMEListener(TFWIDGET_CLICK,
        function()
        end)

    else
        self.touchPanel:removeMEListener(TFWIDGET_CLICK)
    end
end

function RoleInfoLayer.onPreviewClickHandle(sender)
    local self   = sender.logic
    local martialLevel = self.cardRole.martialLevel
    local MaxLevel = ConstantData:getValue("wuxue.MaxLevel")
    if martialLevel >= MaxLevel then
        --toastMessage("当前武学已达最大重")
        toastMessage(localizable.roleInfoLayer_max)
        return
    end

    print("self.cardRole.id = ", self.cardRole.id)
    local layer  = require("lua.logic.rolebook.RoleBook_Preview"):new({self.cardRole.gmId})
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY_CLOSE, AlertManager.TWEEN_1)
    AlertManager:show() 
end

function RoleInfoLayer:MoveToClick(target)
    for i=1,6 do
        local panel = TFDirector:getChildByPath(target,"panel_equip_"..i)
        local tween = {
            target = panel;
            {
                duration = 0.1,
                alpha = 0,
                onComplete = function ()
                    panel:setVisible(false)
                end
             }
         }

        TFDirector:toTween(tween)
    end

    local panel = TFDirector:getChildByPath(target,"panel_equip_16")
    panel:setPosition(ccp(self.panel_tianshu.posX,130))
    local tween = {
        target = panel;
        {
            duration = 0.05,
            x = self.panel_tianshu.posX,
            y = 130,
        },
        {
            duration = 0.05,
            x = 7,
            y = 130,
        }
    }

    TFDirector:toTween(tween)
end
function RoleInfoLayer:MoveToRetuen(target)
    for i=1,6 do
        local panel = TFDirector:getChildByPath(target,"panel_equip_"..i)
        local tween = {
            target = panel;
            {
                duration = 0.1,
                alpha = 1,
                onComplete = function ()
                    panel:setVisible(true)
                end
             }
         }

        TFDirector:toTween(tween)
    end
    local panel = TFDirector:getChildByPath(target,"panel_equip_16")
    panel:setPosition(ccp(7,130))
    local tween = {
        target = panel;
        {
            duration = 0.05,
            x = 9,
            y = 130,
        },
        {
            duration = 0.05,
            x = self.panel_tianshu.posX,
            y = 130,
        }
    }

    TFDirector:toTween(tween)
    panel = TFDirector:getChildByPath(target,"panel_equip_7")
    panel:setPosition(ccp(7,223))
    tween = {
        target = panel;
        {
            duration = 0.05,
            x = 9,
            y = 223,
        },
        {
            duration = 0.05,
            x = self.panel_tianshu.posX,
            y = 223,
        }
    }

    TFDirector:toTween(tween)
end

function RoleInfoLayer:addJinJieEffect(effect)
    local pos = self.panel_content:getPosition()
    pos = ccp(pos.x+560,pos.y+320)
    effect:setPosition(pos)
    self:addChild(effect,101)
end

function RoleInfoLayer:didAccelerate(data)
    if not data then
        return
    end

    if not self.bg_move then
        return
    end

    data.y = data.y - 5
    local deltaMax = 5
    if data.x > deltaMax then
        data.x = deltaMax
    elseif data.y > deltaMax then
        data.y = deltaMax
    elseif data.x < -deltaMax then
        data.x = -deltaMax
    elseif data.y < -deltaMax then
        data.y = -deltaMax
    end

    if data and data.y then
        data.y = -data.y
    end

    if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
        data.x = -data.x
    end

    --加速计的敏感值    
    local sensitivityX = 1.8  
    local sensitivityY = 0.9

    local maxDeltaX = 23
    local maxDeltaY = 33

    local scaleTab = {1}

    local deltaX = data.x / 5 * maxDeltaX * sensitivityX 
    local deltaY = data.y / 5 * maxDeltaY * sensitivityY 

    self.pTabX = {}
    self.pTabY = {}
    for i = 1, 1 do
        self.curPos[i] = self.initBgPos[i]
        self.pTabX[i] = self.curPos[i].x + deltaX * scaleTab[i]
        self.pTabY[i] = self.curPos[i].y + deltaY * scaleTab[i]
    end

    --防抖动像素值
    local deltaX = 10
    local deltaY = 10

    self.newX = nil
    self.newY = nil
    if math.abs( self.pTabX[1] - self.bg_move[1]:getPositionX() ) > deltaX then
        self.newX = clone( self.pTabX ) 
    end
    if math.abs( self.pTabY[1] - self.bg_move[1]:getPositionY() ) > deltaY then
        self.newY = clone( self.pTabY ) 
    end

    if self.updateTimerID == nil then
        self.updateTimerID = TFDirector:addTimer(30, -1, nil, 
        function()
            for i = 1, 1 do
                local curppps = self.bg_move[i]:getPosition()
                
                if self.newX then
                    local disX = self.newX[i] - curppps.x
                    if math.abs(disX * 0.3) >= 1 then
                        self.bg_move[i]:setPositionX(curppps.x + disX * 0.06)
                    else
                        self.bg_move[i]:setPositionX(self.newX[i])
                    end
                end

                if self.newY then
                    local disY = self.newY[i] - curppps.y
                    if math.abs(disY * 0.3) >= 1 then
                        self.bg_move[i]:setPositionY(curppps.y + disY * 0.06)
                    else
                        self.bg_move[i]:setPositionY(self.newY[i])
                    end
                end
            end
        end)
    end
end

--
function RoleInfoLayer:effectEndCall()
    self.EquipmentChangeEndCallBack()

    -- self:showJinJieResult()
    self:refreshUI()
    self.effectCompelte = true
    self:setTouchPanelEnabled(false)
    if self.effect then
        self.effect:setVisible(false)
    end
end
function RoleInfoLayer:MoveToClickXinfa(target)
    for i=1,6 do
        local panel = TFDirector:getChildByPath(target,"panel_equip_"..i)
        local tween = {
            target = panel;
            {
                duration = 0.1,
                alpha = 0,
                onComplete = function ()
                    panel:setVisible(false)
                end
             }
         }

        TFDirector:toTween(tween)
    end

    local panel = TFDirector:getChildByPath(target,"panel_equip_7")
    panel:setPosition(ccp(336,223))
    local tween = {
        target = panel;
        {
            duration = 0.05,
            x = 339,
            y = 223,
        },
        {
            duration = 0.05,
            x = 7,
            y = 223,
        }
    }

    TFDirector:toTween(tween)
end
return RoleInfoLayer
