--[[
    宠物主界面
    -- by fei
    -- 2017/03/01
]]

local CardEudemon      = require('lua.gamedata.base.CardEudemon');
local EudemonMainLayer = class("EudemonMainLayer", BaseLayer)

function EudemonMainLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.pet.PetMain")
end
function EudemonMainLayer:setData(eudemonId, fightType, isShow, eudemonItemId)
    self.eudemonId      = tonumber(eudemonId)
    self.isShowEudemon  = isShow
    self.eudemonItemId  = eudemonItemId
    print("----EudemonMainLayer-setData----",fightType)
    self.fightType      = fightType or EnumFightStrategyType.StrategyType_PVE
    self:initList()
end

--
function EudemonMainLayer:initList()
    self.eudemonList = TFArray:new()-- clone(EudemonManager:getEudemonList())
    local tempList = TFArray:new()
    local fightEudemonId = EudemonManager:getEudemonByFightId(self.fightType)
    --if (fightEudemonId) then
        for info in EudemonManager:getEudemonList():iterator() do
            if (info:getId() == fightEudemonId) then
                tempList:push(info)
            else
                self.eudemonList:push(info)
            end
        end
    --end
    EudemonManager:sortLevelList(self.eudemonList)
    for info in tempList:iterator() do
        self.eudemonList:pushFront(info)
    end
    tempList:clear()
end
--
function EudemonMainLayer:initUI(ui)
    --
	self.super.initUI(self, ui)
	--通用头部   
    self.generalHead        = CommonManager:addGeneralHead(self)
    self.generalHead:setData(ModuleType.Eudemon, {HeadResType.COIN, HeadResType.SYCEE})
    self.Panel_pet          = TFDirector:getChildByPath(ui, "Panel_pet")
    self.btn_help           = TFDirector:getChildByPath(ui, "btn_help")
    self.img_zhushuxing     = TFDirector:getChildByPath(ui, "img_zhushuxing")
    self.icon_level         = TFDirector:getChildByPath(ui, "icon_level")
    self.img_fight          = TFDirector:getChildByPath(ui, "img_zhan")
    self.btn_xunlianshi     = TFDirector:getChildByPath(ui, "btn_xunlianshi")
    self.txt_eudemonName    = TFDirector:getChildByPath(ui, "txt_eudemonName")
    self.btn_yulan          = TFDirector:getChildByPath(ui, "btn_yulan")
    self.img_levelbg        = TFDirector:getChildByPath(ui, "img_levelbg")
    -- 左右按钮
    self.btn_jnzs           = TFDirector:getChildByPath(ui, 'btn_jnzs')
    self.btn_left           = TFDirector:getChildByPath(ui, 'btn_zuo')
    self.btn_right          = TFDirector:getChildByPath(ui, 'btn_you')
    self.img_peticonbig     = TFDirector:getChildByPath(ui, 'img_peticonbig')
    local bg                = TFDirector:getChildByPath(ui, 'bg')
    bg:setVisible(true)
    ViewSizeCheck(bg)
    local img_peticonbig    = TFDirector:getChildByPath(ui, 'img_peticonbig')
    if (img_peticonbig) then
        img_peticonbig:setVisible(false)
    end
     --属性
    local panel_fightInfo = TFDirector:getChildByPath(ui, "img_petinfo")
    self.fight_attr = {}
    local count = 0
    for i,v in pairs(EudemonAttributeTypeList) do
        count = count + 1
        local child = TFDirector:getChildByPath(panel_fightInfo, "img_attr" .. count)
        if (child) then
            child:setVisible(false)
            self.fight_attr[count] = child
            self.fight_attr[count].txt_name = TFDirector:getChildByPath(child, "txt_name")
            self.fight_attr[count].txt_base = TFDirector:getChildByPath(child, "txt_base")  
        end
    end
    local teamBg = TFDirector:getChildByPath(ui, "bg_quanduijiacheng")
    self.team_attr = {}
    for i = 1, 9 do
        local child = TFDirector:getChildByPath(teamBg, "img_teamAttr" .. i)
        if (child) then
            child:setVisible(false)
            self.team_attr[i] = child
            self.team_attr[i].txt_name = TFDirector:getChildByPath(child, "txt_name")
            self.team_attr[i].txt_base = TFDirector:getChildByPath(child, "txt_base") 
        end
    end
    self.starList = {}
    for i=1,5 do
        local starbg    = TFDirector:getChildByPath(ui, "img_starbg" .. i)
        local img_star  = TFDirector:getChildByPath(starbg, "img_star")
        img_star:setVisible(false)
        self.starList[i] = {}
        self.starList[i].starbg   = starbg
        self.starList[i].img_star = img_star
    end
    --技能--2个技能以下
    self.skillList = {}
    self.img_skillinfo = TFDirector:getChildByPath(ui, "img_skillinfo")
    for i=1,2 do
        local img_skillbg = TFDirector:getChildByPath(self.img_skillinfo, "img_skillbg"..i)
        img_skillbg.txt_skillname   = TFDirector:getChildByPath(img_skillbg, "txt_skillname")
        img_skillbg.txt_zhudong     = TFDirector:getChildByPath(img_skillbg, "txt_zhudong")
        img_skillbg.btn_skill       = TFDirector:getChildByPath(img_skillbg, "btn_skill")
        img_skillbg.icon_skill      = TFDirector:getChildByPath(img_skillbg, "icon_skill")
        self.skillList[i] = img_skillbg
    end
    --3个技能时
    self.img_skillinfo_shenhua = TFDirector:getChildByPath(ui, "img_skillinfo_shenhua")
    self.skillList_super = {}
    for i=1,3 do
        local img_skillbg = TFDirector:getChildByPath(self.img_skillinfo_shenhua, "img_skillbg"..i)
        img_skillbg.txt_skillname   = TFDirector:getChildByPath(img_skillbg, "txt_skillname")
        img_skillbg.txt_zhudong     = TFDirector:getChildByPath(img_skillbg, "txt_zhudong")
        img_skillbg.btn_skill       = TFDirector:getChildByPath(img_skillbg, "btn_skill")
        img_skillbg.icon_skill      = TFDirector:getChildByPath(img_skillbg, "icon_skill")
        self.skillList_super[i] = img_skillbg
    end
    self.img_skillinfo_shenhua:setVisible(false)

    self.btn_tupo           = TFDirector:getChildByPath(ui, "btn_tupo")
    self.btn_xunhua         = TFDirector:getChildByPath(ui, "btn_xunhua")
    self.btn_xunyu          = TFDirector:getChildByPath(ui, "btn_xunyu")
    self.eudemonList        = TFArray:new()
    self.eudemonInfo        = nil
    self.firstShow = true
end

function EudemonMainLayer:initEudemonListPageView()
    if (self.pageView) then
        return
    end
    local pageView = TPageView:create()
    self.pageView = pageView
    pageView:setTouchEnabled(true)
    pageView:setBackGroundColorType(TF_LAYOUT_COLOR_NONE)
    pageView:setSize(self.Panel_pet:getContentSize())
    pageView:setAnchorPoint(self.Panel_pet:getAnchorPoint())
    pageView:setBounceEnabled(false);
    local function onPageChange()
        self:onPageChange();
        print("------onPageChange-----------",self.pageView:_getCurPageIndex())
    end
    pageView:setChangeFunc(onPageChange)

    local function itemAdd(index)
        print("------ADD-----------",index)
        return  self:addPage(index);
    end 
    pageView:setAddFunc(itemAdd)
    self.Panel_pet:addChild(pageView);
end
function EudemonMainLayer:initEudemonList(pageIndex)
    self.pageView:_removeAllPages()
    self.pageView:setMaxLength(self.eudemonList:length())
    self.pageView:InitIndex(pageIndex);   
end

function EudemonMainLayer:onPageChange()
    self:refreshEudemonInfo()
end

function EudemonMainLayer:onShow()
    self.super.onShow(self)
    if (self.generalHead) then
        self.generalHead:onShow()
    end
    -- if (self.firstShow) then
    --     self:refreshUI()
    --     self.firstShow = false
    -- end
    self:refreshUI()
end

function EudemonMainLayer:refreshUI()
  -- self.eudemonList:clear()
    local index = 1
    if (self.isShowEudemon) then
        --查看下self.eudemonId为 模板ID
        if (self.eudemonId == nil) then
            return
        end
        local cardEudemon = CardEudemon:new(self.eudemonId);
        if (cardEudemon) then
            local data = { templateId = self.eudemonId}
            local itemData = ItemData:objectByID(self.eudemonItemId)
            if (itemData) then
                data.quality = itemData.quality
            end
            cardEudemon:setData(data)
            self.eudemonList = TFArray:new()
            self.eudemonList:push(cardEudemon)
        end
    else
        -- self.eudemonList = clone(EudemonManager:getEudemonList())
        -- EudemonManager:sortLevelList(self.eudemonList)
        -- local fightEudemonId = EudemonManager:getEudemonByFightId(self.fightType)
        -- if (fightEudemonId) then
        --     for info in self.eudemonList:iterator() do
        --         if (info:getId() == fightEudemonId) then
        --             local aa = clone(info)
        --             self.eudemonList:removeObject(info)

        --             local bb = clone(EudemonManager:getEudemonById(fightEudemonId))
        --             self.eudemonList:pushFront(bb)
        --             break
        --         end
        --     end
        -- end
        --
        if (self.eudemonId) then
            local count = 0
            for info in self.eudemonList:iterator() do
                count = count + 1
                if (info:getId() == self.eudemonId) then
                    break
                end
            end
            index = count
            --index = EudemonManager:getEudemonById(self.eudemonId, true)
            --self.eudemonId = nil
        end
    end
    self:initEudemonListPageView()
    self:initEudemonList(index)
    self:refreshEudemonInfo()
end
--
function EudemonMainLayer:refreshBtn()
    local pageCount = self.eudemonList:length()
    local pageIndex = self.pageView:_getCurPageIndex()
    if (pageCount > 1) then
        self.btn_left:setVisible(pageIndex > 1)
        self.btn_right:setVisible(pageIndex < pageCount)
    else
        self.btn_left:setVisible(false)
        self.btn_right:setVisible(false)
    end
    --
    --self.btn_tupo:setTouchEnabled(true)
    --self.btn_tupo:setGrayEnabled(false)
    if EudemonManager:isOpenXunhua() then  
        self.btn_xunhua.isOpen = true
    end
    if  self.btn_xunhua.isOpen == false then 
        self.btn_xunhua:setGrayEnabled(true)
    else 
        self.btn_xunhua:setGrayEnabled(false)
    end
    if MainPlayer:getServerSwitchStatue(ServerSwitchType.XunHua) then
        self.btn_xunhua:setVisible(true)
    else
        self.btn_xunhua:setVisible(false)
    end

    self.btn_xunyu:setVisible(EudemonManager:isOpenXunYu())

    if (self.eudemonInfo:getStarLevel() == EudemonManager.MAX_STAR_LEVEL) then
        --该条件下升品
        self.btn_tupo.isQuality = true
        self.btn_tupo:setTextureNormal("ui_new/qimengdun/btn_shengpin.png")
        -- if (self.eudemonInfo:getQuality() == EudemonManager.MAX_QUALITY) then
        --     self.btn_tupo:setTouchEnabled(false)
        --     self.btn_tupo:setGrayEnabled(true)
        -- end
    else
        self.btn_tupo.isQuality = false
        self.btn_tupo:setTextureNormal("ui_new/qimengdun/btn_tupo.png")
    end
    if (self.isShowEudemon) then
        self.btn_tupo:setTextureNormal("ui_new/handbook/tj_huoqutujingbtn.png")
        self.btn_jnzs:setVisible(true)
    else
        self.btn_jnzs:setVisible(false)
        CommonManager:setRedPoint(self.btn_tupo, EudemonManager:isShowEudemonRedPoint(self.eudemonInfo:getId()),"btn_tupo",ccp(0,0))
    end
    self.img_levelbg:setTexture("ui_new/role/bg-n"..self.eudemonInfo:getQuality()..".png")
    
    
end

--驯养师相关
function EudemonMainLayer:refreshTrainingInfo()
    if (self.eudemonInfo == nil) then
        print("**ERROR************EudemonMainLayer:refreshTrainingInfo()*************")
        return
    end
    local img_suo       = TFDirector:getChildByPath(self.btn_xunlianshi, 'img_suo')
    local img_jia       = TFDirector:getChildByPath(self.btn_xunlianshi, 'img_jia')
    local btn_icon1     = TFDirector:getChildByPath(self.btn_xunlianshi, 'btn_icon1')
    local img_gantan    = TFDirector:getChildByPath(self.btn_xunlianshi, 'img_gantan')
    local img_touxiang  = TFDirector:getChildByPath(btn_icon1, 'img_touxiang')
    img_gantan:setVisible(false)
    CommonManager:setRedPoint(self.btn_xunlianshi, false, "btn_icon1", ccp(-20, -20))
    local isOpenTraining = self.eudemonInfo:isOpenTraining()
    if (isOpenTraining == false) then
        self.btn_xunlianshi.isOpen = false
        img_suo:setVisible(true)
        img_jia:setVisible(false)
        btn_icon1:setVisible(false)
        return
    end
    img_suo:setVisible(false)
    local trainingRoleId = self.eudemonInfo:getTrainingRoleId()
    if (trainingRoleId ~= 0) then
        img_jia:setVisible(false)
        img_touxiang:setVisible(true)
        btn_icon1:setVisible(true)
        btn_icon1:setTouchEnabled(false)
        local roleInfo = CardRoleManager:getRoleByGmid(trainingRoleId)
        if (roleInfo) then
            img_touxiang:setTexture(roleInfo:getHeadPath())
            btn_icon1:setTextureNormal(GetColorRoadIconByQualitySmall(roleInfo.quality))
        else
            print("**ERROR******udemonMainLayer:refreshTrainingInfo()*****trainingRoleId***",trainingRoleId)
        end
        if (EudemonManager:isEudemonRoleIdFight(trainingRoleId, self.fightType)) then
            --驯养师不起作用
            img_gantan:setVisible(true)
        end
        if (self.isPlayEffct) then
            self:addEffectEudeom(btn_icon1)
        end
    else
        btn_icon1:setVisible(false)
        img_jia:setVisible(true)
        if (self.isShowEudemon) then
            img_jia:setVisible(false)
            self.btn_xunlianshi:setTouchEnabled(false)
        else
            if (self.eudemonInfo:isHelpFight(self.fightType)) then
                local isRedPoint = EudemonManager:isShowRedPointOpenTraining(self.fightType)
                CommonManager:setRedPoint(self.btn_xunlianshi, isRedPoint, "btn_icon1", ccp(-20, -20))
            end
        end
    end
    self.btn_xunlianshi.isOpen = true
end

--出战属性
function EudemonMainLayer:refreshFightAttrText()
    local totalAttr = self.eudemonInfo:getFightAttribute(self.fightType)
    local count = 0
    for i,attrId in pairs(EudemonAttributeTypeList) do
        local attrValue = totalAttr.attribute[attrId] or 0
        count = count + 1
        local attr = self.fight_attr[count]
        if (attr and attrValue ~= 0) then
            attr.txt_name:setText(AttributeTypeStr[attrId])
            attr.txt_base:setText(covertToDisplayValue(attrId, attrValue, true))
            attr:setVisible(true)
        else
            print("*ERROR********EudemonMainLayer:refreshFightAttrText()***********",attrId)
        end
    end
end

--团队属性
function EudemonMainLayer:refreshTeamAttrText()
    local totalAttr = self.eudemonInfo:getTeamAttribute()
    local count = 0
    for attrId,attrValue in pairs(totalAttr.attribute) do
        count = count + 1
        local attr = self.team_attr[count]
        if (attr and attrValue ~= 0 ) then
            attr.txt_name:setText(AttributeTypeStr[attrId])
            attr.txt_base:setText(math.ceil(covertToDisplayValue(attrId, attrValue, true)))
            attr:setVisible(true)
        else
            print("*ERROR******EudemonMainLayer:refreshTeamAttrText()********attrId*",attrId, " attrValue ",attrValue)
        end
    end
    count = count + 1
    for i=count,9 do
        local attr = self.team_attr[i]
        if (attr) then
            attr:setVisible(false)
        end
    end
end
--刷新宠物星级
function EudemonMainLayer:refreshEudemonStar()
    
    if (self.eudemonInfo == nil) then
        return
    end
    local starLevel = self.eudemonInfo:getStarLevel()
    for i=1,5 do
        local star = self.starList[i]
        if (star.img_star) then
            star.img_star:setVisible(i <= starLevel)
        end
    end
end
--刷新宠物技能
function EudemonMainLayer:refreshEudemonSkill()
    if (self.eudemonInfo == nil) then
        return
    end
    local skillList = self.eudemonInfo:getSkillList()
    local skillNum  = #skillList
    local iconList  
    if skillNum ~= 3 then
        if (skillNum == 2) then
            self.skillList[1]:setPositionY(140)
            self.skillList[2]:setVisible(true)      
        else
            self.skillList[1]:setPositionY(100)
            self.skillList[2]:setVisible(false)
        end
        self.img_skillinfo_shenhua:setVisible(false)
        self.img_skillinfo:setVisible(true)
        iconList = self.skillList
    else
        self.img_skillinfo_shenhua:setVisible(true)
        self.img_skillinfo:setVisible(false)
        iconList = self.skillList_super
    --
    end
    for i,v in ipairs(iconList) do
        local skillid   = tonumber(skillList[i])

        local skillInfo = SkillBaseData:objectByID(skillid)
        if (skillInfo) then
            if (v.txt_skillname) then
                v.txt_skillname:setText(skillInfo.name)
            end
            if (v.txt_zhudong) then
                if skillInfo.hidden_skill == 1 then
                    v.txt_zhudong:setText(localizable.SkillDetail_reactive_skill);
                elseif skillInfo.hidden_skill == 2 then
                     v.txt_zhudong:setText(localizable.SkillDetail_fightBegin_skill)
                else
                    v.txt_zhudong:setText(SkillTypeStr[skillInfo.type]);
                end
            end
            if (v.icon_skill) then
                v.icon_skill:setTexture(skillInfo:GetPath())
            end
            if (v.btn_skill) then
                v.btn_skill.skillId = skillid
                v.btn_skill.logic   = self
                v.btn_skill:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowSkillClickHandle),1)
            end
        end
    end
end
--刷新宠物信息
function EudemonMainLayer:refreshEudemonInfo()
    -- body
    local index = self.pageView:_getCurPageIndex()
    if (index <= 0 or index > self.eudemonList:length()) then
        print("**ERROR********EudemonMainLayer:refreshEudemonInfo1**********",index, ",",self.eudemonList:length())
        return
    end
    self.eudemonInfo     = self.eudemonList:objectAt(index) or nil

    if (self.eudemonInfo == nil) then
        print("**ERROR********EudemonMainLayer:refreshEudemonInfo2**********",eudemonId)
        return
    end
    self.img_zhushuxing:setTexture(EudemonManager.ImgEudemonType[self.eudemonInfo:getFightTypeId()])
    self.icon_level:setTexture(EudemonManager.img_quality[self.eudemonInfo:getQuality()])
    self.img_fight:setVisible(self.eudemonInfo:isHelpFight(self.fightType))
    self.txt_eudemonName:setText(self.eudemonInfo:getName())
    --
    self:refreshBtn()
    self:refreshFightAttrText()
    self:refreshTeamAttrText()
    self:refreshTrainingInfo()
    self:refreshEudemonStar()
    self:refreshEudemonSkill()
end

function EudemonMainLayer:removeUI()
	self.super.removeUI(self)
end

--销毁方法
function EudemonMainLayer:dispose()
	if self.generalHead then
		self.generalHead:dispose()
		self.generalHead = nil
	end

    self.super.dispose(self)
end

function EudemonMainLayer:registerEvents()
	self.super.registerEvents(self)
    self.btn_left.logic     = self
    self.btn_yulan.logic    = self
    self.btn_right.logic    = self
    self.btn_help.logic     = self
    self.btn_right.isRight  = true
    self.btn_left:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMoveClickHandle),1)
    self.btn_right:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMoveClickHandle),1)
    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onHelpClickHandle),1)
    self.btn_yulan:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onYuLanClickHandle),1)
    --
    self.btn_tupo.logic     = self
    self.btn_tupo.index     = EudemonManager.select_type_1
    self.btn_tupo:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onTrainingClickHandle),1)
    self.btn_xunhua.logic   = self
    self.btn_xunhua.index   = EudemonManager.select_type_2
    self.btn_xunhua.isOpen  = false
    self.btn_xunhua:addMEListener(TFWIDGET_CLICK,   audioClickfun(self.onTameClickHandle),1)
    self.btn_xunyu.logic   = self
    self.btn_xunyu.index   = EudemonManager.select_type_3
    self.btn_xunyu.isOpen  = true
    self.btn_xunyu:addMEListener(TFWIDGET_CLICK,   audioClickfun(self.onMoreTameClickHandle),1)
    
    self.btn_xunlianshi.logic     = self
    self.btn_xunlianshi:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onTrainingRoleClickHandle),1)

    self.btn_jnzs.logic     = self
    self.btn_jnzs:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onPetSkillShowClickHandle),1)
    --
    self.receiveInfo = function(event)
        -- self:refreshEudemonInfo()
        if (self.eudemonInfo) then
            self.eudemonId = self.eudemonInfo:getId()
        end
        self.isPlayEffct = true
        self:refreshUI()
        self.isPlayEffct = false
    end
    TFDirector:addMEGlobalListener(EudemonManager.EudemonRole, self.receiveInfo)

    if self.generalHead then
        self.generalHead:registerEvents()
    end
end
--品质预览
function EudemonMainLayer.onYuLanClickHandle(sender)
    local self = sender.logic;
    self.eudemonId = self.eudemonInfo:getId()
    EudemonManager:openPreviewLayer(self.eudemonInfo:getEudemonTypeId(), self.eudemonInfo:getQuality())
end
--查看技能
function EudemonMainLayer.onShowSkillClickHandle(sender)
    local self = sender.logic;
    local skillId = sender.skillId
    local eudemonId = self.eudemonInfo:getId()
    self.eudemonId = eudemonId
    EudemonManager:openSkillInfo(skillId)
end
--驯养师
function EudemonMainLayer.onTrainingRoleClickHandle(sender)
    local self = sender.logic;
    if (sender.isOpen == false) then
        toastMessage(localizable.Eudemon_not_open)
        return
    end
    local eudemonId = self.eudemonInfo:getId()
    self.eudemonId = eudemonId
    EudemonManager:openEudemonRoleSelectLayer(self.eudemonInfo:getId(), self.eudemonInfo:getTrainingRoleId(), self.fightType)
end

function EudemonMainLayer.onMoveClickHandle(sender)
    local self = sender.logic;
    local pageIndex = self.pageView:getCurPageIndex()
    if (sender.isRight) then
        self.pageView:scrollToPage(pageIndex + 1)
    else
        self.pageView:scrollToPage(pageIndex - 1)
    end  
end

--技能展示
function EudemonMainLayer.onPetSkillShowClickHandle(sender)
    local cardEudemon = sender.logic.eudemonList:objectAt(1)
    -- local petId = sender.logic.eudemonId
    FightManager:BeginPetSkillShowFight(cardEudemon:getId(),cardEudemon:getQuality())
end


--打开培养
function EudemonMainLayer.onTrainingClickHandle(sender)
    local self = sender.logic
    if (self.isShowEudemon) then
        local itemData = ItemData:objectByID(self.eudemonItemId)
        if (itemData) then
            IllustrationManager:showOutputList({output = itemData.show_way})
        end
        return
    end
    local pageIndex = 0
    local eudemonId = self.eudemonInfo:getId()
    self.eudemonId = eudemonId
    EudemonManager:OpemEudemonTrainingLayer(eudemonId, sender.index, self.fightType)
end

--打开驯化
function EudemonMainLayer.onTameClickHandle(sender)
    local self = sender.logic
    local openLevel = FunctionOpenConfigure:getOpenLevel(2224) or 78
    if sender.isOpen == false then 
        sender:setGrayEnabled(true)
    end
    if MainPlayer:getServerSwitchStatue(ServerSwitchType.XunHua) == false then
        toastMessage(localizable.commom_no_open2)
        return
    end
    if EudemonManager:isOpenXunhua() == false then
        toastMessage(stringUtils.format(localizable.common_openlevel_text1,openLevel))
        return
    else
        sender.isOpen = true
    end
    sender:setGrayEnabled(false)   
    if (self.isShowEudemon) then
        local itemData = ItemData:objectByID(self.eudemonItemId)
        if (itemData) then
            IllustrationManager:showOutputList({output = itemData.show_way})
        end
        return
    end
    local pageIndex = 1
    local eudemonId = self.eudemonInfo:getId()
    self.eudemonId = eudemonId
    EudemonManager:OpemEudemonXunHuaLayer(eudemonId, sender.index, self.fightType)
end
--打开驯驭
function EudemonMainLayer.onMoreTameClickHandle(sender)
    local self = sender.logic
    -- local openLevel = FunctionOpenConfigure:getOpenLevel(2224) or 78
    -- if sender.isOpen == false then 
    --     sender:setGrayEnabled(true)
    -- end
    -- if MainPlayer:getServerSwitchStatue(ServerSwitchType.XunHua) == false then
    --     toastMessage(localizable.commom_no_open2)
    --     return
    -- end
    -- if EudemonManager:isOpenXunhua() == false then
    --     toastMessage(stringUtils.format(localizable.common_openlevel_text1,openLevel))
    --     return
    -- else
    --     sender.isOpen = true
    -- end
    -- sender:setGrayEnabled(false)   
    if (self.isShowEudemon) then
        local itemData = ItemData:objectByID(self.eudemonItemId)
        if (itemData) then
            IllustrationManager:showOutputList({output = itemData.show_way})
        end
        return
    end
    local pageIndex = 1
    local eudemonId = self.eudemonInfo:getId()
    self.eudemonId = eudemonId
    EudemonManager:OpemEudemonXunHuaLayer(eudemonId, sender.index, self.fightType)
end
--
function EudemonMainLayer.onHelpClickHandle(sender)
    local self = sender.logic
    local eudemonId = self.eudemonInfo:getId()
    self.eudemonId = eudemonId
    CommonManager:showRuleLyaer("zhanchong")
end

--
function EudemonMainLayer:removeEvents()
    self.super.removeEvents(self)

    if self.generalHead then
        self.generalHead:removeEvents()
    end
    TFDirector:removeMEGlobalListener(EudemonManager.EudemonRole, self.receiveInfo)
    self.receiveInfo = nil
end
function EudemonMainLayer:addPage(pageIndex)
    if (pageIndex <= 0 or pageIndex > self.eudemonList:length()) then
        print("**ERROR*************EudemonMainLayer:addPage********pageIndex*****",pageIndex)
        return
    end
    
    local page = TFPanel:create();
    page:setSize(self.Panel_pet:getContentSize())
    page:setAnchorPoint(ccp(0.5, 0.5))
    local cardEudemon  = self.eudemonList:objectAt(pageIndex)
    local img_eudemon    = TFImage:create(cardEudemon:getBigImagePath())
    if (img_eudemon == nil) then
        print("**ERROR***EudemonMainLayer:addPage**********",cardEudemon:getBigImagePath())
        return
    end
  --  img_eudemon:setFlipX(true)
    page:addChild(img_eudemon)
    --img_eudemon:setAnchorPoint(ccp(0.5, 0))
    local size = self.Panel_pet:getContentSize()
    --img_eudemon:setPosition(ccp(0,-(size.height) / 2))
    img_eudemon:setPosition(self.img_peticonbig:getPosition())

    --local factor =1
    --img_eudemon:setScale(factor)
    img_eudemon:setName("img_eudemon")
    return page;
end

function EudemonMainLayer:addEffectEudeom(node)
    self.isPlayEffct = false
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/assistOpen.xml")
    local effect = TFArmature:create("assistOpen_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:playByIndex(0, -1, -1, 0)
    effect:setVisible(true)
    node:addChild(effect,100)
    local size = node:getSize()
    -- effect:setPosition(ccp(-size.width / 2, -size.height / 2))
    effect:addMEListener(TFARMATURE_COMPLETE, function ()
        effect:removeMEListener(TFARMATURE_COMPLETE) 
        effect:removeFromParent()
        effect = nil
    end)
end
return EudemonMainLayer