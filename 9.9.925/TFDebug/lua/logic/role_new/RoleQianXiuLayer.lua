-- client side RoleQianXiuLayer.lua
--[[
 * @Description: 潜修图层
 ]]
-- script writer chikui
-- creation time 2016-05-26

local RoleQianXiuLayer = class("RoleQianXiuLayer", BaseLayer)
RoleQianXiuLayer.img_path = {{"ui_new/role/btn_kuxing_d.png",       "ui_new/role/btn_kuxing_u.png"},
                             {"ui_new/role/btn_zhengnian_d.png",    "ui_new/role/btn_zhengnian_u.png"},
                             {"ui_new/role/btn_kuxing_d.png",       "ui_new/role/btn_kuxing_u.png"}
                            }
RoleQianXiuLayer.ModuleTypeShow= {
                                    [3]     = {HeadResType.COIN, 1},
                                    [4]     = {HeadResType.SYCEE, 2,},
                                    [30286] = {HeadResType.LIULI, 4, "ui_new/common/icon_liuli.png"},
                                    [30125] = {HeadResType.SELIZI, 3, "ui_new/common/icon_selizi.png"}
}
function RoleQianXiuLayer:ctor(data)
    self.super.ctor(self,data);
    self.fightType = EnumFightStrategyType.StrategyType_PVE
    self.currSelectStage = 1
    self:init("lua.uiconfig_mango_new.role_new.QianXiuLayer")
end

function RoleQianXiuLayer:initUI(ui)
	self.super.initUI(self,ui)

    self.generalHead = CommonManager:addGeneralHead( self )
    self.generalHead:setData(ModuleType.QianXiu,{})

    self.panel_role     = TFDirector:getChildByPath(ui, 'panel_r1')
    self.panel_content  = TFDirector:getChildByPath(ui, 'panel_content')
    self.panel_jingmai  = TFDirector:getChildByPath(ui, 'Panel_jingmai')

    self.img_role       = TFDirector:getChildByPath(self.panel_role, 'img_role')
    --self.txt_level      = TFDirector:getChildByPath(self.panel_role, 'txt_level')
    self.txt_name       = TFDirector:getChildByPath(self.panel_role, 'txt_name')
    self.img_quality    = TFDirector:getChildByPath(self.panel_role, 'img_quality_icon')
    self.txt_power      = TFDirector:getChildByPath(self.panel_content, 'txt_power')
    self.img_type       = TFDirector:getChildByPath(self.panel_role, 'img_zhiye')
    self.img_diwen1     = TFDirector:getChildByPath(self.panel_role, 'img_diwen1')
    self.img_starList = {}
    for i=1,5 do
        local starNode       = TFDirector:getChildByPath(self.panel_role, "img_star"..i)
        self.img_starList[i] = TFDirector:getChildByPath(starNode, "img_starliang")
        self.img_starList[i]:setVisible(false)
    end
    self.btn_Type = {}
    for i=1,3 do
        local rootNode              = TFDirector:getChildByPath(ui, 'panel_x' .. i)
        self.btn_Type[i]            = {}
        self.btn_Type[i].btn        = TFDirector:getChildByPath(rootNode, 'btn_1')
        self.btn_Type[i].img_select = TFDirector:getChildByPath(rootNode, 'btn_2')
        self.btn_Type[i].rootNode   = rootNode
        self.btn_Type[i].res        = {}
        for j=1,2 do
            self.btn_Type[i].res[j] = {}
            local node = TFDirector:getChildByPath(rootNode, 'img_res_icon' .. j)
            self.btn_Type[i].res[j].icon = node
            self.btn_Type[i].res[j].num  = TFDirector:getChildByPath(rootNode, 'txt_cost_'..j)
            -- if nil ~= node then  
            --     self.btn_Type[i].res[j].icon = node
            --     self.btn_Type[i].res[j].num  = TFDirector:getChildByPath(node, 'txt_cost')
            -- end
        end
    end

    self.attribute_Nodes = {}
    self.LockCostData = ConstantData:objectByID("PotentialPracticeLockCost1")
    for i=1,5 do
        local rootNode = TFDirector:getChildByPath(ui, 'panel_shuxing' .. i)
        self.attribute_Nodes[i] = {}
        self.attribute_Nodes[i].txt_name        = TFDirector:getChildByPath(rootNode, 'txt_shuxing1')
        self.attribute_Nodes[i].txt_num         = TFDirector:getChildByPath(rootNode, 'txt_tupostep')
        self.attribute_Nodes[i].bar_per         = TFDirector:getChildByPath(rootNode, 'bar_percent')
        self.attribute_Nodes[i].img_di          = TFDirector:getChildByPath(rootNode, 'img_di')
        self.attribute_Nodes[i].img_add         = TFDirector:getChildByPath(rootNode, 'icon_1')
        self.attribute_Nodes[i].txt_add         = TFDirector:getChildByPath(rootNode, 'txt_numb1')
        self.attribute_Nodes[i].panel_suo       = TFDirector:getChildByPath(rootNode, 'panel_suo')
        self.attribute_Nodes[i].img_lockCost    = TFDirector:getChildByPath(rootNode, 'img_yuanbao1')
        self.attribute_Nodes[i].check_attr      = TFDirector:getChildByPath(rootNode, 'check_attr')
        self.attribute_Nodes[i].txt_cost        = TFDirector:getChildByPath(rootNode, 'txt_cost')
        self.attribute_Nodes[i].txt_cost:setText(self.LockCostData.value .. '') 
    end
    self.btn_stage = {}
    for i=1,2 do
        self.btn_stage[i]   = TFDirector:getChildByPath(ui, 'btn_stage_'..i)
        self.btn_stage[i].logic = self
    end
    -- 左右按钮
    self.btn_left           = TFDirector:getChildByPath(ui, 'btn_pageleft')
    self.btn_right          = TFDirector:getChildByPath(ui, 'btn_pageright')
    self.panel_list         = TFDirector:getChildByPath(ui, 'panel_rolelist')

    self.btn_qianxiu        = TFDirector:getChildByPath(ui, 'btn_qianxiu')
    self.btn_tihuan         = TFDirector:getChildByPath(ui, 'btn_tihuan')
    self.btn_onekeyqx       = TFDirector:getChildByPath(ui, 'btn_yijianqianxiu')
    self.btn_help           = TFDirector:getChildByPath(ui, 'btn_help')
    self.panel_wkq          = TFDirector:getChildByPath(ui, 'panel_wkq')

    self.selectType         = 1
    self.countType          = 0
    self:drawRoleList()
end

function RoleQianXiuLayer:removeUI()
    self.super.removeUI(self)
end

function RoleQianXiuLayer:dispose()
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end

    self.super.dispose(self)
end

function RoleQianXiuLayer:loadData(roleGmId,fightType)
    self.roleGmId  = roleGmId
    self.fightType = fightType
end

function RoleQianXiuLayer:onShow()
	self.super.onShow(self)
	self.generalHead:onShow()
    self:refreshUI()
end

function RoleQianXiuLayer:refreshUI()
    self.cardRole = CardRoleManager:getRoleByGmid(self.roleGmId);
    self.maxOpenStage = self.cardRole.maxQianXiuStage
    self.selectIndex = self.roleList:indexOf(self.cardRole.id)
    self:refreshRoleList(self.selectIndex) 
end

function RoleQianXiuLayer:registerEvents(ui)
	self.super.registerEvents(self)
    self.btn_left.logic     = self;
    self.btn_left:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onLeftClickHandle),1)
    self.btn_right.logic    = self;
    self.btn_right:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRightClickHandle),1)

    self.btn_qianxiu:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onQianXiuClickHandle),1)
    self.btn_qianxiu.logic = self;    
    self.btn_tihuan:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onTiHuanClickHandle),1)
    self.btn_tihuan.logic = self;
    self.btn_onekeyqx:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onOneKeyQXClickHandle),1)
    self.btn_onekeyqx.logic = self;

    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnRuleClick))
    self.btn_help.logic = self

    for i=1,3 do
        self.btn_Type[i].btn:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onBtnTypeClickHandle),1)
        self.btn_Type[i].btn.idx = i	
        self.btn_Type[i].btn.logic = self
    end
    for i,btn in ipairs(self.btn_stage) do
        btn:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onBtnsSelectStageClickHandle),1)
        btn.selectStage = i
        btn.logic = self
    end
    self.qianxiuCallBack = function (event)
        self:drawQianXiuInfo()
        self:addResultEffect()
        if (self.generalHead) then
            self.generalHead:refreshUI()
        end
    end
    TFDirector:addMEGlobalListener(QianXiuManager.qianxiuResult,self.qianxiuCallBack)
    self.tihuanCallBack = function (event)
        local currStage = self.cardRole.maxQianXiuStage
        if (self.maxOpenStage < currStage) then
            toastMessage(localizable.RoleQianXiuLayer_Tip2)
        end
        self.maxOpenStage = currStage
        self:drawQianXiuInfo()
        local oldpower = tonumber(self.txt_power:getText())
        if oldpower ~= 0 and oldpower ~= self.cardRole:getPowerByFightType(self.fightType) then
            self:textChange(oldpower,self.cardRole:getPowerByFightType(self.fightType))
        end
    end
    TFDirector:addMEGlobalListener(QianXiuManager.tihuanResult,self.tihuanCallBack)
end

--标签按钮
function RoleQianXiuLayer.onBtnsSelectStageClickHandle(sender)
    local self = sender.logic;
    sender:setTouchEnabled(true)
    sender:setTextureNormal(RoleQianXiuLayer.img_path[sender.selectStage][1])
    
    self:selectStage(sender.selectStage)
end

--
function RoleQianXiuLayer:selectStage(stage)
    local selectBtn = self.btn_stage[stage]
    if (selectBtn) then
        selectBtn:setTextureNormal(RoleQianXiuLayer.img_path[stage][1])
        selectBtn:setTouchEnabled(false)
    end
    --
    if (stage ~= self.currSelectStage) then
        local oldSelectBtn = self.btn_stage[self.currSelectStage]
        if (oldSelectBtn) then
            oldSelectBtn:setTextureNormal(RoleQianXiuLayer.img_path[self.currSelectStage][2])
            oldSelectBtn:setTouchEnabled(true)
        end
    end
    
    self.currSelectStage = stage
    self.LockCostData = ConstantData:objectByID("PotentialPracticeLockCost"..stage)
    self:drawQianXiuInfo(stage)
    self:initConsumeData()
end

function RoleQianXiuLayer:removeEvents()
    local pageIndex = self.pageView:_getCurPageIndex()
    TFDirector:dispatchGlobalEventWith("MoveRoleListToRole",{roleId = self.roleList:objectAt(pageIndex)})
    ------------------------->>>>>>>>>>>>>>>>>>>>>>>>
    self.super.removeEvents(self)
    TFDirector:removeMEGlobalListener(QianXiuManager.qianxiuResult,self.qianxiuCallBack)
    TFDirector:removeMEGlobalListener(QianXiuManager.tihuanResult,self.tihuanCallBack)
    if self.generalHead then
        self.generalHead:removeEvents()
    end
end

function RoleQianXiuLayer.onLeftClickHandle(sender)
    local self = sender.logic;
    local pageIndex = self.pageView:getCurPageIndex() ;
    self.pageView:scrollToPage(pageIndex - 1);
end

function RoleQianXiuLayer.onRightClickHandle(sender)
    local self = sender.logic;
    local pageIndex = self.pageView:getCurPageIndex() ;
    self.pageView:scrollToPage(pageIndex + 1);
end

function RoleQianXiuLayer.OnRuleClick( sender )
    CommonManager:showRuleLyaer('qianxiu')
end

function RoleQianXiuLayer:drawRoleList()
    local pageView = TPageView:create()

    self.pageView = pageView

    pageView:setTouchEnabled(true)
    pageView:setBackGroundColorType(TF_LAYOUT_COLOR_NONE)
    pageView:setSize(self.panel_list:getContentSize())
    pageView:setAnchorPoint(self.panel_list:getAnchorPoint())

    local function onPageChange()
        self:onPageChange();
    end
    pageView:setChangeFunc(onPageChange)

    local function itemAdd(index)
        return  self:addPage(index)
    end 
    pageView:setAddFunc(itemAdd)

    self.panel_list:addChild(pageView,2)
end


function RoleQianXiuLayer:addPage(pageIndex) 
    local page = TFPanel:create();
    page:setSize(self.panel_list:getContentSize())

    local roleId = self.roleList:objectAt(pageIndex)
    local cardRole = CardRoleManager:getRoleById(roleId)

    local img_role = TFImage:create(cardRole:getBigImagePath())

    img_role:setScale(0.6)
    img_role:setFlipX(true)
    img_role:setAnchorPoint(ccp(0.5,0.5))
    img_role:setPosition(ccp(320/2 - 20,500/2 + 10))
    page:addChild(img_role)
  
    self.pageList[cardRole.id] = page

    return page;
end

function RoleQianXiuLayer:onPageChange()
    local pageIndex = self.pageView:_getCurPageIndex()
    self:showInfoForPage(pageIndex);
end

function RoleQianXiuLayer:showInfoForPage(pageIndex)
    self.selectIndex = pageIndex;

    local pageCount = self.roleList:length()

    self.btn_left:setVisible(false)
    self.btn_right:setVisible(false)

    if pageIndex < pageCount and pageCount > 1 then
        self.btn_right:setVisible(true)
    end 

    if pageIndex > 1 and pageCount > 1  then
        self.btn_left:setVisible(true)
    end
    self:drawRole()
end

function RoleQianXiuLayer:refreshRoleList(pageIndex)
    self.pageView:_removeAllPages();

    self.pageView:setMaxLength(self.roleList:length())

    self.pageList        = {};

    self:showInfoForPage(pageIndex);

    self.pageView:InitIndex(pageIndex);      
end

function RoleQianXiuLayer:setRoleList(roleList)
    self.roleList =  TFArray:new()
    for roleId in roleList:iterator() do
        local role = CardRoleManager:getRoleById(roleId)
        if role and role.quality >= 4 then
            self.roleList:push(roleId)
        end
    end
end

function RoleQianXiuLayer:drawRole()
    local roleId    = self.roleList:objectAt(self.selectIndex);
    self.cardRole   = CardRoleManager:getRoleById(roleId)
    self.roleGmId   = self.cardRole.gmId;

    self.countType  = QianXiuManager:getRoleQianXiuType(roleId)
    local cardRole  = self.cardRole

    self.txt_power:setText(cardRole:getPowerByFightType(self.fightType))

    --左侧角色信息显示
    self.img_role:setVisible(false)
    self.txt_name:setText(cardRole.name)
    self.img_diwen1:setTexture(GetRoleNameBgByQuality(cardRole.quality))
    self.img_quality:setTexture(GetFontByQuality(cardRole.quality))

    self.img_type:setTexture("ui_new/common/img_role_type" .. cardRole.outline .. ".png")
    for i=1,5 do
        self.img_starList[i]:setVisible(false)
    end
    CardRoleManager:SetRoleStarTexture(cardRole.starlevel, self.img_starList)
    self:selectStage(self.currSelectStage)
end

function RoleQianXiuLayer:initConsumeData()
    self.consumeList = {}
    local costList = {}
    print(self.currSelectStage, "  self.currSelectStage ")
    for v in QianXiuConsumeData:iterator() do
        if (v.stage == self.currSelectStage) then
            table.insert( costList, v )
        end
    end
    local list = {}
    local tempList = {}
    for i,v in ipairs(costList) do
        local itemdata = v
        self.consumeList[i] = {}
        if itemdata and itemdata.consume then
            local tbl,len = stringToTable(itemdata.consume,'|')
            if (len == 2 and self.btn_Type[i].res[1]) then
                self.btn_Type[i].res[1].icon:setPositionY(85)
                self.btn_Type[i].res[1].num:setPositionY(85)
            elseif (self.btn_Type[i].res[1]) then
                self.btn_Type[i].res[1].icon:setPositionY(65)
                self.btn_Type[i].res[1].num:setPositionY(65)
            end
            for j=1,2 do
                if (tbl[j]) then
                    local consumeData = stringToNumberTable(tbl[j], '_')
                    local item = {}
                    item.type   = consumeData[1]
                    item.itemid = tonumber(consumeData[2])
                    item.number = consumeData[3]
                    local tempId = item.itemid
                    if (item.type ~= 0 and item.type ~= 1) then
                        --金币或者元宝
                        tempId = item.type
                    end
                    if (tempList[tempId] ~= true and RoleQianXiuLayer.ModuleTypeShow[tempId]) then
                        tempList[tempId] = true
                        table.insert(list, RoleQianXiuLayer.ModuleTypeShow[tempId])
                    end
                    self.consumeList[i][j] = BaseDataManager:getReward(item)
                    if self.btn_Type[i].res[j] ~= nil then
                        local path = "ui_new/common/icon_selizi.png"
                        if item.type ~= 1 then
                            path = GetResourceIcon(item.type)
                            self.btn_Type[i].res[j].icon:setScale(0.8)
                        else
                            if (RoleQianXiuLayer.ModuleTypeShow[tempId]) then
                                path = RoleQianXiuLayer.ModuleTypeShow[tempId][3] or "ui_new/common/icon_selizi.png"
                            end
                            self.btn_Type[i].res[j].icon:setScale(0.72)
                        end
                        self.btn_Type[i].res[j].icon:setTexture(path)
                        local backStr = item.number .. ''
                        if item.number >= 100000 then
                            backStr = stringUtils.format(localizable.fun_wan_desc,item.number/10000)
                        end
                        self.btn_Type[i].res[j].num:setText('X' .. backStr)
                        self.btn_Type[i].res[j].icon:setVisible(true)
                        self.btn_Type[i].res[j].num:setVisible(true)
                    end
                else
                    self.btn_Type[i].res[j].icon:setVisible(false)
                    self.btn_Type[i].res[j].num:setVisible(false)
                end
            end
        end
    end
    if (self.generalHead) then
        self.generalHead.buyButtonEventBound = nil
        local function sortQ(a, b)
            return a[2] < b[2]
        end
        table.sort( list, sortQ )
        local aa = {}
        for i,v in ipairs(list) do
            table.insert( aa, v[1] )
        end
        self.generalHead:setData(ModuleType.QianXiu,aa)
    end
    self:brushSelectBtnState()
end

function RoleQianXiuLayer:brushSelectBtnState()
    for i=1,3 do
        if self.selectType == i then
            self.btn_Type[i].btn:setVisible(false)
            self.btn_Type[i].img_select:setVisible(true)
        else
            self.btn_Type[i].btn:setVisible(true)
            self.btn_Type[i].img_select:setVisible(false)
        end
    end
end

function RoleQianXiuLayer.onBtnTypeClickHandle( sender )
    local self = sender.logic
    if self.selectType == sender.idx then
        return
    end
    self.selectType = sender.idx
    self:brushSelectBtnState()
end

function RoleQianXiuLayer:drawQianXiuInfo(stage)
    stage = stage or self.currSelectStage
    local roleQianXiuAttri  = self.cardRole:getQianXiuAttriTable(stage)
    local roleQXChangeAttri = self.cardRole:getQianXiuChangeAttriTable(stage)

    local maxAttriTable = QianXiuAttributeData:getMaxAttriByLvl(self.cardRole.level,self.cardRole.quality, stage) or {}
    local bAllPositive = true
    local constData = ConstantData:objectByID("PotentialPracticeStage"..stage)
    local addType = 1
    if (constData) then
        addType = tonumber(constData.value)
    end
    for i=1,5 do
        local maxAttri      = maxAttriTable[i] or {}
        local maxAttriValue = maxAttri.value or 0
        local attriValue    = roleQianXiuAttri[i] or 0
        local str_attri     = attriValue .. '/' .. maxAttriValue
        if (addType == 2) then
            str_attri = (covertToPercentNotZero(attriValue)).. '/' .. (covertToPercentNotZero(maxAttriValue))
        end
        self.attribute_Nodes[i].txt_num:setText(str_attri)
        local fpercent = 0
        if maxAttriValue ~= 0 then
            fpercent = 100 * ( attriValue / maxAttriValue )
        end
        self.attribute_Nodes[i].bar_per:setPercent(fpercent)
        local changeAttriValue = roleQXChangeAttri[i]
        if self.countType ~= 0 then
            changeAttriValue = changeAttriValue or attriValue
        end
        self:setAddInfo(self.attribute_Nodes[i],attriValue,changeAttriValue, addType == 2)
        if not changeAttriValue or attriValue > changeAttriValue then
            bAllPositive = false
        end
        self.attribute_Nodes[i].txt_cost:setText(self.LockCostData.value .. '')
        local lockCostId = self.LockCostData.res_id
        --local itemData = ItemData:objectByID(tonumber(lockCostId))
        if (RoleQianXiuLayer.ModuleTypeShow[lockCostId]) then
            self.attribute_Nodes[i].img_lockCost:setTexture(RoleQianXiuLayer.ModuleTypeShow[lockCostId][3])
        end
    end

    local isOpen, sum, openNum = self.cardRole:isOpenStage(stage)
    
    for i,v in ipairs(self.btn_Type) do
        if (v.rootNode) then
            v.rootNode:setVisible(isOpen)
        end
    end
    for i,v in ipairs(self.attribute_Nodes) do
        if (v.panel_suo) then
            v.panel_suo:setVisible(isOpen)
            v.img_di:setVisible(isOpen)
        end
    end
    if (isOpen) then
        if self.cardRole.quality >= 4 then
            self.btn_qianxiu:setVisible(true)
            self.btn_onekeyqx:setVisible(true)
            if #roleQXChangeAttri <= 0 then
                self.btn_tihuan:setVisible(false)
            else
                self.btn_tihuan:setVisible(true)
                if bAllPositive == true then
                    self.btn_qianxiu:setVisible(false)
                    self.btn_onekeyqx:setVisible(false)
                end
            end
        else
            self.btn_qianxiu:setVisible(false)
            self.btn_onekeyqx:setVisible(false)
            self.btn_tihuan:setVisible(false)
        end
        self.panel_wkq:setVisible(false)
    else
        self:refreshNotOpen(stage,sum, openNum)
        self.panel_wkq:setVisible(true)
        self.btn_onekeyqx:setVisible(false)
        self.btn_qianxiu:setVisible(false)
        self.btn_tihuan:setVisible(false)
    end
end

--未解锁显示
function RoleQianXiuLayer:refreshNotOpen(stage,sum, openNum)
    local txt_num = TFDirector:getChildByPath(self.panel_wkq, 'txt_num')
    if (txt_num) then
        txt_num:setText(sum.."/"..openNum)
    end
    local bar_percent = TFDirector:getChildByPath(self.panel_wkq, 'bar_percent')
    if (bar_percent) then
        bar_percent:setPercent(sum / openNum * 100)
    end
    --
    local txt_open_1 = TFDirector:getChildByPath(self.panel_wkq, 'txt_open_1')
    if (txt_open_1) then
        txt_open_1:setText(localizable.RoleQianXiuLayer_Tip1)
    end
end
function RoleQianXiuLayer:setAddInfo(tNode,num,numChange, isAddType)
    if nil == numChange then
        tNode.txt_add:setText('')
        tNode.img_add:setVisible(false)
        tNode.img_di:setVisible(true)
        return
    end
    tNode.img_add:setVisible(true)
    tNode.img_di:setVisible(true)
    local referencePoint = tNode.img_di:getPosition()
    local nAddNum = numChange - num
    local imgAddWidth = 0
    if nAddNum >= 0 then
        if (isAddType) then
            nAddNum = covertToPercentNotZero(nAddNum)
        end
        tNode.txt_add:setText('+' .. nAddNum)
        tNode.img_add:setRotation( -90 )
        tNode.img_add:setTexture('ui_new/rolebreakthrough/xl_jiantou_icon.png')
        imgAddWidth = tNode.img_add:getContentSize().height
        tNode.txt_add:setColor(ccc3(30,130,8))
    else
        if (isAddType) then
            nAddNum = covertToPercentNotZero(nAddNum)
        end
        tNode.txt_add:setText('' .. nAddNum)
        tNode.img_add:setRotation( 0 )
        tNode.img_add:setTexture('ui_new/role/img_jiantou2.png')
        imgAddWidth = tNode.img_add:getContentSize().width
        tNode.txt_add:setColor(ccc3(200,5,2))
    end
    local addWidth = imgAddWidth + tNode.txt_add:getContentSize().width + 1
    local posX = referencePoint.x - addWidth * 0.5
    tNode.txt_add:setPositionX( posX )
    posX = referencePoint.x + addWidth * 0.5 - imgAddWidth * 0.5
    tNode.img_add:setPositionX( posX )
end

function RoleQianXiuLayer:getLockMsg()
    local msg = {}
    for i=1,5 do
        msg[i] = {
            [1] = i,
            [2] = 0
        }
        if self.attribute_Nodes[i].check_attr:getSelectedState() == true then
            msg[i][2] = 1
        end
    end
    return msg
end

function RoleQianXiuLayer.onQianXiuClickHandle( sender )
    local self = sender.logic
    local roleId = self.cardRole.gmId
    local count,shortMsg,lockCount = self:getQianXiuCount()
    if count <= 0 then
        return
    end
    count = 1
    if self.countType > 1 then
        local warningMsg = localizable.RoleQianXiuLayer_Tip
        
        CommonManager:showOperateSureLayer(
            function()
                if lockCount > 0 and QianXiuManager.break_start_cost_tip == false then
                    self:ConfirmLockCost(count,shortMsg,lockCount,1)
                    return
                end
                self.countType = 1
                QianXiuManager:setRoleQianXiuType(self.cardRole.id,self.countType)
                local lockMsg = self:getLockMsg()
                QianXiuManager:requestQianXiu(roleId,self.selectType,count,lockMsg, self.currSelectStage)
            end,
            nil,
            {
                msg = warningMsg
            }
        )
        return
    end 
    if lockCount > 0 and QianXiuManager.break_start_cost_tip == false then
        self:ConfirmLockCost(count,shortMsg,lockCount,1)
        return
    end
    self.countType = 1
    QianXiuManager:setRoleQianXiuType(self.cardRole.id,self.countType)
    local lockMsg = self:getLockMsg()
    QianXiuManager:requestQianXiu(roleId,self.selectType,count,lockMsg, self.currSelectStage)
end

function RoleQianXiuLayer:ConfirmLockCost( count,shortMsg,lockCount,type )
    local worningMsg = ""
    local itemId = self.LockCostData.res_id
    local itemName = ""
    local itemData = ItemData:objectByID(itemId)
    if (itemData) then
        itemName = itemData.name
    end
    if type == 1 then
        worningMsg = stringUtils.format(localizable.RoleQianXiuLayer_Tip_lock1,self.LockCostData.value * lockCount * count, itemName)
        CommonManager:showOperateSureTipLayer(
            function(data, widget)
                self.countType = type
                QianXiuManager:setRoleQianXiuType(self.cardRole.id,self.countType)
                local lockMsg = self:getLockMsg()
                QianXiuManager:requestQianXiu(self.cardRole.gmId,self.selectType,count,lockMsg, self.currSelectStage)
                QianXiuManager.break_start_cost_tip = widget:getSelectedState() or false;
            end,
            function(data, widget)
                AlertManager:close()
                QianXiuManager.break_start_cost_tip = widget:getSelectedState() or false;
            end,
            {
                title=localizable.TreasureMain_tips1,
                msg=worningMsg,
                -- showtype = AlertManager.BLOCK_AND_GRAY
            }
        )
    elseif type == 2 then
        worningMsg = stringUtils.format(localizable.RoleQianXiuLayer_Tip_lock1,self.LockCostData.value * lockCount * count, itemName)
        CommonManager:showOperateSureLayer(
            function()
                self.countType = type
                QianXiuManager:setRoleQianXiuType(self.cardRole.id,self.countType)
                local lockMsg = self:getLockMsg()
                QianXiuManager:requestQianXiu(self.cardRole.gmId,self.selectType,count,lockMsg, self.currSelectStage)
            end,
            nil,
            {
                title=localizable.TreasureMain_tips1,
                msg=worningMsg,
            }
        )
    end
    
end

function RoleQianXiuLayer:isAllBad()
    local roleQianXiuAttri  = self.cardRole:getQianXiuAttriTable(self.currSelectStage)
    local roleQXChangeAttri = self.cardRole:getQianXiuChangeAttriTable(self.currSelectStage)
    for i=1,5 do
        if roleQianXiuAttri[i] == nil or roleQXChangeAttri[i] == nil or (roleQianXiuAttri[i]<roleQXChangeAttri[i]) then
            return false
        end
    end
    return true    
end

function RoleQianXiuLayer.onTiHuanClickHandle( sender )
    local self = sender.logic
    local roleId = self.cardRole.gmId
    if self:isAllBad() then
        CommonManager:showOperateSureLayer(
            function()
                self.countType = 0
                QianXiuManager:setRoleQianXiuType(self.cardRole.id,self.countType)
                QianXiuManager:requestTiHuan(roleId, self.currSelectStage)
            end,
            nil,
            {
                msg = localizable.RoleQianXiuLayer_TipAllBad
            }
        )
    else
        self.countType = 0
        QianXiuManager:setRoleQianXiuType(self.cardRole.id,self.countType)
        QianXiuManager:requestTiHuan(roleId, self.currSelectStage)
    end
end

function RoleQianXiuLayer.onOneKeyQXClickHandle( sender )
    local self = sender.logic
    local roleId = self.cardRole.gmId
    local count,shortMsg,lockCount = self:getQianXiuCount()
    if count <= 0 then
        return
    end
    if lockCount > 0 then
        self:ConfirmLockCost(count,shortMsg,lockCount,2)
        return
    end
    local warningMsg = localizable.RoleQianXiuLayer_TipOneKey
        
    CommonManager:showOperateSureLayer(
        function()
            self.countType = 2
            QianXiuManager:setRoleQianXiuType(self.cardRole.id,self.countType)
            local lockMsg = self:getLockMsg()
            QianXiuManager:requestQianXiu(roleId,self.selectType,count,lockMsg, self.currSelectStage)
        end,
        nil,
        {
            msg = warningMsg
        }
    )
end

function RoleQianXiuLayer:getQianXiuCount()
    local lockCount = 0
    for i = 1,5 do
        if self.attribute_Nodes[i].check_attr:getSelectedState() == true then
            lockCount = lockCount + 1
        end
    end
    local consumeData = self.consumeList[self.selectType]
    local shortRes = ''
    local canCount = 10
    local costItem = {}
    for i=1,#consumeData do
        local holdNum = 0
        local resName = consumeData[i].name
        local itemId = consumeData[i].itemid
        if consumeData[i].type == 1 then
            holdNum = BagManager:getItemNumById(itemId)
        else
            holdNum = MainPlayer:getResValueByType(consumeData[i].type)
        end
        local lockCostNum = 0
        if lockCount > 0                                     and
           consumeData[i].type == self.LockCostData.res_type and
           itemId == self.LockCostData.res_id then

            lockCostNum = lockCount * self.LockCostData.value
        end
        local curCount = math.floor(holdNum/(consumeData[i].number + lockCostNum))
        if curCount <= 0 then
            if shortRes == '' then
                shortRes = '' .. resName
            else
                shortRes = shortRes .. '、' .. resName
            end
            local info = {}
            info.itemId = itemId
            info.resName = resName
            table.insert( costItem, info)
        end
        if curCount < canCount then
            canCount = curCount
        end
    end
    if canCount <= 0 then
        
        local costGoodsId = 0
        for i,info in ipairs(costItem) do
            shortRes = info.resName
            if (info.itemId == 30125) then
                --舍利子优先
                costGoodsId = info.itemId
                break
            else
                costGoodsId = info.itemId
                break
            end
        end
        
        if ResGetWayManager:openResGetLayer(costGoodsId,EnumDropType.GOODS) == true then
            return 0
        else
            toastMessage(stringUtils.format(localizable.Common_good_buzu, shortRes))
        end
    end
    return canCount,shortRes,lockCount
end

function RoleQianXiuLayer:addResultEffect() 

    if self.qianxiuEffect then
        self.qianxiuEffect:removeMEListener(TFARMATURE_COMPLETE)
        self.qianxiuEffect:removeFromParent()
        self.qianxiuEffect = nil
    end

    TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/equipment_refining.xml")
    local effect = TFArmature:create("equipment_refining_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    self.panel_content:addChild(effect)
    effect:setPosition(ccp(544,320))
    effect:setScaleY(0.8)
    effect:setZOrder(100)
    self.qianxiuEffect = effect
    self.qianxiuEffect:playByIndex(0, -1, -1, 0)
    self.effect = effect
    effect:addMEListener(TFARMATURE_COMPLETE,function()
        effect:removeFromParent()
        self.qianxiuEffect = nil
    end)
end

function RoleQianXiuLayer:textChange(oldValue,newValue)
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
    self.ui:setAnimationCallBack("Action0", TFANIMATION_FRAME, function()
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
    self.ui:runAnimation("Action0",1);
end

return RoleQianXiuLayer
