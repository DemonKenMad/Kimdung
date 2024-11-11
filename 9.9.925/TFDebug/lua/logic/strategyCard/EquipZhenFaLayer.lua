-- client side EquipZhenFaLayer.lua
--[[
 * @Description: 阵法穿戴
 ]]
-- script writer Happy.All
-- creation time 2016-08-01


local EquipZhenFaLayer = class("EquipZhenFaLayer", BaseLayer);

local NumPerRow = 2
local MenuString = {
    "ui_new/zhenfa/img_zbdj2.png",
    "ui_new/zhenfa/img_sxdj2.png",
}

function EquipZhenFaLayer:ctor(data)
    self.super.ctor(self,data);
    self.LineUpType = data

    self.cardList = StrategyCardManager:getCardList(1,self.LineUpType)
    if self.cardList:length() < 1 then
        self.selectGmId = 0
    else
        local card = self.cardList:objectAt(1)
        self.selectGmId = card.gmId
    end
    self:init("lua.uiconfig_mango_new.role.EquipZhenFa");
end

function EquipZhenFaLayer:initUI(ui)
    self.super.initUI(self,ui);

    self.btn_zhuangpei = TFDirector:getChildByPath(ui, "btn_zhuangpei")
    self.btn_yanxi = TFDirector:getChildByPath(ui, "btn_yanxi")
    self.btn_xiexia = TFDirector:getChildByPath(ui, "btn_xiexia")
    self.btn_genghuan = TFDirector:getChildByPath(ui, "btn_genghuan")
    
    self.btn_back = TFDirector:getChildByPath(ui, "btn_back")

    local leftPanel = TFDirector:getChildByPath(ui, "panel_left")
    self.leftPanel = leftPanel
    --阵法基本信息
    self.img_object = TFDirector:getChildByPath(leftPanel, "img_object")
    local baseNode = TFDirector:getChildByPath(leftPanel, "img_zhenfa")
    self.baseQuality = TFDirector:getChildByPath(baseNode, "btn_equip")
    self.baseIcon = TFDirector:getChildByPath(baseNode, "img_skill_icon")
    self.baseLevel = TFDirector:getChildByPath(baseNode, "txt_qianghualv")
    self.baseName = TFDirector:getChildByPath(baseNode, "txt_zhuangbeiming")
    --阵法强化信息
    local intensifyNode = TFDirector:getChildByPath(leftPanel, "panel_move")
    self.intensifyAttr = {}
    for i=1,5 do
        local attrNode = TFDirector:getChildByPath(intensifyNode, "txt_attr"..i)
        self.intensifyAttr[i] = {}
        self.intensifyAttr[i].attrName = TFDirector:getChildByPath(intensifyNode, "txt_attr"..i)
        self.intensifyAttr[i].attrNum = TFDirector:getChildByPath(attrNode, "txt_attr"..i.."_num")
    end
    --阵法升星信息
    local starPositionNode = TFDirector:getChildByPath(leftPanel, "img_dizy")
    self.texturePos = {}
    for i=1,9 do
        self.texturePos[i] = TFDirector:getChildByPath(starPositionNode, "img_zy"..i)
        self.texturePos[i]:setVisible(false)
    end
    
    self.starAttr = {}
    for i=1,3 do
        self.starAttr[i] = TFDirector:getChildByPath(leftPanel, "panel_zhenwei"..i)
        self.starAttr[i].attr = {}
        local starAttr = {}
        starAttr.attrNode = TFDirector:getChildByPath(self.starAttr[i], "txt_attr1")
        starAttr.attrName = TFDirector:getChildByPath(starAttr.attrNode, "txt_attr1")
        starAttr.attrNum = TFDirector:getChildByPath(starAttr.attrNode, "txt_attr1_num")
        table.insert(self.starAttr[i].attr, starAttr)
        local starAttr2 = {}
        starAttr2.attrNode = TFDirector:getChildByPath(self.starAttr[i], "txt_attr2")
        starAttr2.attrName = TFDirector:getChildByPath(starAttr2.attrNode, "txt_attr2")
        starAttr2.attrNum = TFDirector:getChildByPath(starAttr2.attrNode, "txt_attr2_num")
        table.insert(self.starAttr[i].attr, starAttr2)        
    end
    
    local specialEffectNode = TFDirector:getChildByPath(leftPanel, "txt_zhenwei")
    specialEffectNode:setText(localizable.UILayer_tips_31)
    self.specialEffect = TFDirector:getChildByPath(specialEffectNode, "txt_num")

    --空阵法列表
    self.panelLeftEmpty = TFDirector:getChildByPath(ui, "panel_left_empty")
    self.emptyDes =  TFDirector:getChildByPath(self.panelLeftEmpty, "Text1")
    self.emptyDes:setText(localizable.StrategyCard_empty)

    if self.cardList:length() < 1 then
        self.leftPanel:setVisible(false)
        self.panelLeftEmpty:setVisible(true)
    else
        self.leftPanel:setVisible(true)
        self.panelLeftEmpty:setVisible(false)
    end

    --右边tableView
    self.TabViewUI = TFDirector:getChildByPath(ui, "panel_huadong")
    self.TabView =  TFTableView:create()
    self.TabView:setTableViewSize(self.TabViewUI:getContentSize())
    self.TabView:setDirection(TFTableView.TFSCROLLVERTICAL)    
    self.TabView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    self.TabView.logic = self
    self.TabViewUI:addChild(self.TabView)
    self.TabView:setPosition(ccp(0,0))

    self.cellModel  = createUIByLuaNew("lua.uiconfig_mango_new.role.EquipItemZhenFa")
    self.cellModel:retain()

    --获取路径tableview
    self.pathTabViewUI = TFDirector:getChildByPath(ui, "panel_outlist")
    self.pathTabView =  TFTableView:create()
    self.pathTabView:setTableViewSize(self.pathTabViewUI:getContentSize())
    self.pathTabView:setDirection(TFTableView.TFSCROLLVERTICAL)    
    self.pathTabView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    self.pathTabView.logic = self
    self.pathTabViewUI:addChild(self.pathTabView)
    self.pathTabView:setPosition(ccp(0,0))

    self.pathCellModel = TFDirector:getChildByPath(self.panelLeftEmpty, "bg_cell")
    self.pathCellModel:setVisible(false)

    --下拉框
    self.btn_listType = TFDirector:getChildByPath(ui, "btn_listType")
    self.panel_choice = TFDirector:getChildByPath(ui, "panel_choice")
    self.panel_choice:setVisible(false)
    self.btn_choice_1 = TFDirector:getChildByPath(ui, "btn_choice_1")
    self.btn_choice_2 = TFDirector:getChildByPath(ui, "btn_choice_2")
    self.img_listType = TFDirector:getChildByPath(ui, "img_listType")
    self.img_listType:setTexture(MenuString[1])
    panel_xialakuang = TFDirector:getChildByPath(ui, "panel_xialakuang")
    panel_xialakuang:setVisible(true)

    --左下角小图标
    self.btnLB = TFDirector:getChildByPath(ui, "btn_zhenfa")
    self.btnQualityLB = TFDirector:getChildByPath(self.btnLB, "img_quality")
    self.btnQualityLB:setVisible(false)
    self.btnIconLB = TFDirector:getChildByPath(self.btnLB, "img_equip")
    self.btnIconLB:setVisible(false)
    self.img_add = TFDirector:getChildByPath(self.btnLB, "img_add")
    self.img_add:setVisible(false)
    

    Public:addSelectIconForStrategyCard(self.btnLB, true)
end

function EquipZhenFaLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()  

    if self.firstShow == nil then
        self.ui:runAnimation("Action0",1);
        self.firstShow = true
    end     
end

function EquipZhenFaLayer:refreshUI()
    self:checkListShowLayer()
    self:refreshLBButtonInfo()
end

function EquipZhenFaLayer:checkListShowLayer()

    self.cardList = StrategyCardManager:getCardList(self.btnIndex,self.LineUpType)
    if self.cardList:length() < 1 then
        self.leftPanel:setVisible(false)
        self.panelLeftEmpty:setVisible(true)
    else
        self.leftPanel:setVisible(true)
        self.panelLeftEmpty:setVisible(false)
        self.TabView:reloadData()
        self:refreshLeft()
        self:refreshButton()
    end

end

function EquipZhenFaLayer:refreshLeft()
    --阵法基本信息
    local selectCardInfo = StrategyCardManager:getStrategyCardByGmid(self.selectGmId)
    if selectCardInfo == nil then
        print('cannot find the card gmId = ',self.gmId)
        return
    end
    self.baseQuality:setTextureNormal(GetColorIconByQuality_118(selectCardInfo:getQuality()))
    self.baseIcon:setTexture(selectCardInfo:getPath())
    self.baseLevel:setText("+"..selectCardInfo:getLevel())
    self.baseName:setText(selectCardInfo:getName())
    --阵法强化信息
    local extraAttr = selectCardInfo:getTotalAttr()
    local notEmptyIndex = 1
    for k,v in pairs(extraAttr) do
        print("notEmptyIndex = ",notEmptyIndex)
        self.intensifyAttr[notEmptyIndex].attrName:setVisible(true)
        self.intensifyAttr[notEmptyIndex].attrName:setText(AttributeTypeStr[k])
        self.intensifyAttr[notEmptyIndex].attrNum:setText("+ " .. covertToDisplayValue(k,v))
        notEmptyIndex = notEmptyIndex + 1
    end
    for i=notEmptyIndex,5 do
        self.intensifyAttr[i].attrName:setVisible(false)
    end
    --阵法升星信息
    local posNumber = selectCardInfo:getOpenPositionNumber()
    for i=1,9 do
        self.texturePos[i]:setVisible(false)
    end
    local strategyPos = selectCardInfo:getSrategyPos()
    for k,v in pairs(strategyPos) do
        if v <= posNumber then
            self.texturePos[k]:setVisible(true) 
            self.texturePos[k]:setTexture("ui_new/zhenfa/img_"..v..".png")
        end
    end

    for i=1,3 do
        local attribute = selectCardInfo:getPositonAttributeByPos(i)--selectCardInfo:getStarAttributeByStarPos(i)
        if i <= posNumber then
            local attrTbl = attribute:getAttribute()
            self.starAttr[i]:setVisible(true)            
            local attrIndex = 1
            for k,v in pairs(attrTbl) do
                self.starAttr[i].attr[attrIndex].attrNode:setVisible(true)
                self.starAttr[i].attr[attrIndex].attrName:setText(AttributeTypeStr[k])
                self.starAttr[i].attr[attrIndex].attrNum:setText("+ " .. covertToDisplayValue(k,v))
                attrIndex = attrIndex + 1
            end
            for j=attrIndex,2 do
                self.starAttr[i].attr[j].attrNode:setVisible(false)
            end
        else
            self.starAttr[i]:setVisible(false)
        end
    end

    local effectAttrInfo = selectCardInfo:getZhenWeiSpecialAdd()
    local nextEffectInfo = BattleArrayResearchExtraData:getShenYanEffect(selectCardInfo.id, 0) 
    local effectDes = StrategyCardManager:zhenWeiSpecialAddStr( nextEffectInfo.desc, effectAttrInfo)
    self.specialEffect:setText(effectDes)

    Public:addStarImg(self.baseIcon, selectCardInfo:getStarLevel())
end

function EquipZhenFaLayer:refreshLBButtonInfo()
    local currCard = StrategyCardManager:getStrategyCardByStrategyType(self.LineUpType)
    if currCard then
        self.btnQualityLB:setVisible(true)
        self.btnQualityLB:setTextureNormal(GetColorIconByQuality_118(currCard:getQuality()))
        self.btnIconLB:setVisible(true)
        self.btnIconLB:setTexture(currCard:getPath())
    else
        self.btnQualityLB:setVisible(false)
        self.btnIconLB:setVisible(false)
    end

    local allCard = StrategyCardManager:getAllStrategyCard():length()
    if allCard ~= 0 then
        self.img_add:setVisible(true)
    else
        self.img_add:setVisible(false)
    end
end

function EquipZhenFaLayer:refreshButton()

    self.btn_zhuangpei:setVisible(false)
    self.btn_yanxi:setVisible(false)
    self.btn_xiexia:setVisible(false)
    self.btn_genghuan:setVisible(false)
    local selectCardInfo = StrategyCardManager:getStrategyCardByGmid(self.selectGmId)
    local currCard = StrategyCardManager:getStrategyCardByStrategyType(self.LineUpType)
    if selectCardInfo == nil then
        return
    end
    if currCard then
        if currCard.gmId == selectCardInfo.gmId then
            self.btn_xiexia:setVisible(true)            
            self.btn_yanxi:setVisible(true)
            self.img_object:setTexture("ui_new/roleequip/js_dangqian.png")
        else
            self.btn_genghuan:setVisible(true)            
            self.img_object:setTexture("ui_new/roleequip/js_mubiao.png")
        end
    else
        self.btn_zhuangpei:setVisible(true)
    end
end

function EquipZhenFaLayer:removeUI()
    self.super.removeUI(self);
    if self.cellModel then
        self.cellModel:release()
        self.cellModel = nil
    end
end

--注册事件
function EquipZhenFaLayer:registerEvents()
    self.super.registerEvents(self);

    ADD_ALERT_CLOSE_LISTENER(self,self.btn_back);

    self.btn_zhuangpei:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onZhuangbeiClick),1)
    self.btn_zhuangpei.logic = self
    
    self.btn_yanxi:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onYanxiClick),1)
    self.btn_yanxi.logic = self

    self.btn_xiexia:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onXiexiaClick),1)
    self.btn_xiexia.logic = self    

    self.btn_genghuan:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onZhuangbeiClick),1)
    self.btn_genghuan.logic = self    

    self.TabView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
    self.TabView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
    self.TabView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
    self.TabView:reloadData()
    self.TabView:setScrollToBegin()

    self.pathTabView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTablePath)
    self.pathTabView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableViewPath)
    self.pathTabView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndexPath)
    self.pathTabView:reloadData()
    self.pathTabView:setScrollToBegin()

    self.btn_listType:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onXialaClick),1)
    self.btn_listType.logic = self
    self.btn_choice_1:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMenuClick),1)
    self.btn_choice_1.logic = self
    self.btn_choice_1.index = 1
    self.btn_choice_2:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMenuClick),1)    
    self.btn_choice_2.logic = self
    self.btn_choice_2.index = 2

    self.cardEquipHandleCallBack = function(event)
        -- print("event = ",event)
        -- local handleType = event.data[1][1]
        -- self:refreshUI()
        -- if handleType == StrategyCardManager.handleDress then
        AlertManager:close(AlertManager.TWEEN_NONE)
    end
    TFDirector:addMEGlobalListener(StrategyCardManager.UpdateStrategyMessage,self.cardEquipHandleCallBack)
end

function EquipZhenFaLayer:removeEvents()
    self.super.removeEvents(self)

    self.TabView:removeMEListener(TFTABLEVIEW_SIZEFORINDEX)
    self.TabView:removeMEListener(TFTABLEVIEW_SIZEATINDEX)
    self.TabView:removeMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW)

    self.pathTabView:removeMEListener(TFTABLEVIEW_SIZEFORINDEX)
    self.pathTabView:removeMEListener(TFTABLEVIEW_SIZEATINDEX)
    self.pathTabView:removeMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW)

    if self.cardEquipHandleCallBack then
        TFDirector:removeMEGlobalListener(StrategyCardManager.UpdateStrategyMessage,self.cardEquipHandleCallBack)
        self.cardEquipHandleCallBack = nil
    end
end

function EquipZhenFaLayer.onZhuangbeiClick( btn )
    local self = btn.logic
    StrategyCardManager:sendDressHandleMsg( self.selectGmId, self.LineUpType )
end

function EquipZhenFaLayer.onYanxiClick( btn )
    local self = btn.logic
    StrategyCardManager:openZhenFaMainLayer(self.selectGmId)
end

function EquipZhenFaLayer.onXiexiaClick( btn )
    local self = btn.logic
    StrategyCardManager:sendUnDressHandleMsg( self.LineUpType )
end

function EquipZhenFaLayer.cellSizeForTable(table,idx)
    local self = table.logic
    return 160,140
end

function EquipZhenFaLayer.numberOfCellsInTableView(table)
    local self = table.logic
    local length = self.cardList:length()

    return math.ceil(length/NumPerRow)
end

function EquipZhenFaLayer.tableCellAtIndex(table, idx)

    local self = table.logic
    local cell = table:dequeueCell()
    
    if cell == nil then
        cell = TFTableViewCell:create()
        cell.panel = {}
        for i=1,NumPerRow do
            local panel = self.cellModel:clone()
            panel:setPosition(ccp((i-1)*150+20,0))
            cell:addChild(panel)
            cell.panel[i] = panel
            panel.panel_empty = TFDirector:getChildByPath(panel, "panel_empty")
            panel.panel_info = TFDirector:getChildByPath(panel, "panel_info")
            panel.btn_node = TFDirector:getChildByPath(panel, "btn_node")
            panel.img_xuanzhong = TFDirector:getChildByPath(panel, "img_xuanzhong")
            panel.btnQuality = TFDirector:getChildByPath(panel, "btn_equip")
            panel.btnIcon = TFDirector:getChildByPath(panel, "img_skill_icon")
            panel.img_jiantousheng = TFDirector:getChildByPath(panel, "img_jiantousheng")
            panel.img_jiantousheng:setVisible(false)
            panel.txt_qianghualv = TFDirector:getChildByPath(panel, "txt_qianghualv")
            panel.img_equiped = TFDirector:getChildByPath(panel,"img_equiped")

            panel.btn_node:setTouchEnabled(false)
            panel.btn_node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onCellBtnClick))
            panel.btn_node.logic = self
            panel.btnQuality.logic = self
            panel.btnQuality:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onCellBtnClick))
        end
    end
    -- idx = idx + 1
    
    for i=1,NumPerRow do
        local panel = cell.panel[i]
        local index = idx*NumPerRow + i
        local cardInfo = self.cardList:getObjectAt(index)
        if cardInfo then
            panel.panel_empty:setVisible(false)
            panel.panel_info:setVisible(true)
            if self.selectGmId == cardInfo.gmId then
                panel.img_xuanzhong:setVisible(true)
            else
                panel.img_xuanzhong:setVisible(false)
            end
            panel.btnQuality:setTextureNormal(GetColorIconByQuality_118(cardInfo:getQuality()))
            panel.btnIcon:setTexture(cardInfo:getPath())
            panel.txt_qianghualv:setText("+"..cardInfo:getLevel())
            panel.btn_node.gmId = cardInfo.gmId
            panel.btnQuality.gmId = cardInfo.gmId

            if cardInfo:checkInStrategyByType(self.LineUpType) then
                panel.img_equiped:setVisible(true)
            else
                panel.img_equiped:setVisible(false)
            end

            Public:addStarImg(panel.btnIcon, cardInfo:getStarLevel())
        else
            panel.panel_empty:setVisible(true)
            panel.panel_info:setVisible(false)
        end
    end

    return cell
end

function EquipZhenFaLayer.onXialaClick(btn)
    local self = btn.logic
    if self.panel_choice:isVisible() then
        self.panel_choice:setVisible(false)
    else
        self.panel_choice:setVisible(true)
    end
end

function EquipZhenFaLayer.onMenuClick(btn)
    local self = btn.logic
    local index = btn.index

    self.btnIndex = index
    self.cardList = StrategyCardManager:getCardList(index,self.LineUpType)
    if self.cardList:length() < 1 then
        self.selectGmId = 0
    else
        local card = self.cardList:objectAt(1)
        self.selectGmId = card.gmId
    end
    self.panel_choice:setVisible(false)
    self.img_listType:setTexture(MenuString[index])
    

    self:refreshUI()
    self.TabView:reloadData()
    self.TabView:setScrollToBegin()
end

function EquipZhenFaLayer.onCellBtnClick( btn )
    local self = btn.logic
    local gmId = btn.gmId
    if self.selectGmId == gmId then
        return
    end
    self.selectGmId = gmId
    self:refreshUI()
    self.TabView:reloadData()
end


function EquipZhenFaLayer.cellSizeForTablePath(table,idx)
    local self = table.logic
    return 67,360
end

function EquipZhenFaLayer.numberOfCellsInTableViewPath(table)
    local self = table.logic
    
    return 1
end

function EquipZhenFaLayer.tableCellAtIndexPath(table, idx)

    local self = table.logic
    local cell = table:dequeueCell()
    local panel = nil
    if cell == nil then
        cell = TFTableViewCell:create()        
        panel = self.pathCellModel:clone()
        panel:setPosition(ccp(180,35))
        cell:addChild(panel)
        cell.panel = panel
    else
        panel = cell.panel
    end

    local txt_leveldesc  = TFDirector:getChildByPath(panel, "txt_leveldesc")
    local txt_levelopen  = TFDirector:getChildByPath(panel, "txt_levelopen")

    txt_leveldesc:setText(localizable.StrategyCard_path)

    panel:setVisible(true)
    panel:setTouchEnabled(true)
    panel:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onPathCellBtnClick),1)
    panel.logic = self

    local level = FunctionOpenConfigure:getOpenLevel(2214)
    if MainPlayer:getLevel() >= level then
        txt_leveldesc:setColor(ccc3(0,0,0))
        txt_levelopen:setColor(ccc3(0,0,0))
        panel:setTexture("ui_new/rolebook/bg_cell.png")
    else
        txt_leveldesc:setColor(ccc3(141,141,141))
        txt_levelopen:setColor(ccc3(141,141,141))
        panel:setTexture("ui_new/rolebook/bg_cell2.png")
    end

    txt_levelopen:setVisible(false)

    return cell
end

function EquipZhenFaLayer.onPathCellBtnClick(sender)
    local self = sender.logic

    local level = FunctionOpenConfigure:getOpenLevel(2214)
    local needLevel = level
    if MainPlayer:getLevel() < needLevel then
        --toastMessage(needLevel .. "级解锁")
        toastMessage(stringUtils.format(localizable.common_level_unlock,needLevel))
        return
    end

    ChuangzhenManager:openMainLayer(true)
end

return EquipZhenFaLayer
