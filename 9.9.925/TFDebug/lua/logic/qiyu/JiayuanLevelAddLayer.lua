-- client side JiayuanLevelAddLayer.lua
--[[
 * @Description: 家园等级加成界面
 ]]
-- script writer wuqi
-- creation time 2016-07-18

local JiayuanLevelAddLayer = class("JiayuanLevelAddLayer", BaseLayer)
local cellH = 85
local achieveMax = 5

function JiayuanLevelAddLayer:ctor(data)
    self.super.ctor(self, data)

    self.stateTab = FamilyData:getAttrStateTab()
    self:init("lua.uiconfig_mango_new.qiyu.FamilyLevelAdd")
end

function JiayuanLevelAddLayer:initUI(ui)
	self.super.initUI(self, ui) 

    self.img_qdi = TFDirector:getChildByPath(ui, "img_qdi")
    self.txt_lv1 = TFDirector:getChildByPath(self.img_qdi, "txt_Lv1")
    self.txt_lv2 = TFDirector:getChildByPath(self.img_qdi, "txt_Lv2")

    self.txt_shuxing1 = TFDirector:getChildByPath(self.img_qdi, "txt_shuxing1")
    self.txt_shuxing2 = TFDirector:getChildByPath(self.img_qdi, "txt_shuxing2")

    self.bg_t1 = TFDirector:getChildByPath(ui, "bg_t1")
    self.bg_t2 = TFDirector:getChildByPath(ui, "bg_t2")
    self.bg_t1:setVisible(false)
    self.bg_t2:setVisible(false)

    self.img_di = TFDirector:getChildByPath(ui, "img_di")
    
    self.TabViewUI = TFDirector:getChildByPath(ui, "panel_huadong")
    self.TabView =  TFTableView:create()
    self.TabView:setTableViewSize(self.TabViewUI:getContentSize())
    self.TabView:setDirection(TFTableView.TFSCROLLVERTICAL)    
    self.TabView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    self.TabView.logic = self    
    self.TabView:setPosition(ccp(0, 0))  

    self.cellModel = createUIByLuaNew("lua.uiconfig_mango_new.ZhuZhan.QiheCell")
    self.cellModel:retain() 

    self.TabView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
    self.TabView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
    self.TabView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
    self.TabView:addMEListener(TFTABLEVIEW_SCROLL, self.tableScroll)

    self.TabViewUI:addChild(self.TabView)
end

function JiayuanLevelAddLayer:onShow()
    self.super.onShow(self)
    self:refreshBaseUI();
    self:refreshUI();
end

function JiayuanLevelAddLayer:refreshBaseUI()

end

function JiayuanLevelAddLayer:refreshUI()
    self.jiayuanLevel = QiyuManager:getJiayuanLevel()
    local nextLevel = math.min(self.jiayuanLevel + 1, FamilyData:length())
    --self.txt_lv1:setText("Lv" .. self.jiayuanLevel) 
    --self.txt_lv2:setText("Lv" .. nextLevel)

    --local attrList1 = QiyuManager:getJiayuanAttr()
    --local attrList2 = QiyuManager:getJiayuanNextAttr()


    local item1 = FamilyData:getItemByLevel(self.jiayuanLevel) or {}
    local item2 = FamilyData:getItemByLevel(nextLevel) or {}
    local attr1 = item1.attribute or ""
    local attr2 = item2.attribute or ""
    local tab1 = string.split(attr1, "_")
    local tab2 = string.split(attr2, "_")

    local key1 = tonumber(tab1[1])
    local key2 = tonumber(tab2[1])
    local value1 = tonumber(tab1[2])
    local value2 = tonumber(tab2[2])

    self.txt_shuxing1:setVisible(true)
    if self.jiayuanLevel == 0 then
        self.txt_shuxing1:setText(localizable.common_no)
    else
        self.txt_shuxing1:setText(AttributeTypeStr[key1] .. "+ " .. value1)
    end    
    self.txt_shuxing2:setText(AttributeTypeStr[key2] .. "+ " .. value2)
    
    --self.TabView:scrollToYTop(0)
    if self.TabView then
        self.TabView:reloadData()

        local totalCount = 0
        local achieveTab = FamilyData:getAttrStateTab()        
        local currNum = QiyuManager:getJiayuanLevel()
        for i = 1, #self.stateTab do
            local item = achieveTab[i]
            local level = item[1]
            if currNum >= level then
                totalCount = totalCount + 1
            end
        end

        local max = #self.stateTab
        if totalCount <= 0 then
            totalCount = 1
        end
        local offsetMax = cellH * max - self.TabViewUI:getContentSize().height
        local offset = offsetMax - (totalCount-1)*cellH
        if offset < 0 then
            offset = 0
        end

        self.TabView:reloadData()
        self.TabView:setContentOffset(ccp(0,-(offset)))
    end
end


function JiayuanLevelAddLayer:removeUI()
    self.super.removeUI(self)
end

function JiayuanLevelAddLayer:registerEvents()
    self.super.registerEvents(self)
    self.ui:setTouchEnabled(true)
    ADD_ALERT_CLOSE_LISTENER(self, self.ui)

    --Public:bindScrollFun(self.TabView)    
end


function JiayuanLevelAddLayer:removeEvents()
    self.super.removeEvents(self)

    self.TabView:removeMEListener(TFTABLEVIEW_SIZEFORINDEX)
    self.TabView:removeMEListener(TFTABLEVIEW_SIZEATINDEX)
    self.TabView:removeMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW)
    self.TabView:removeMEListener(TFTABLEVIEW_SCROLL)
end

function JiayuanLevelAddLayer.cellSizeForTable(table,idx)
    return cellH, 416
end

function JiayuanLevelAddLayer.numberOfCellsInTableView(table)
    local self = table.logic
    return #self.stateTab
end

function JiayuanLevelAddLayer.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()

    local panel = nil
    if cell == nil then
        cell = TFTableViewCell:create()

        panel = self.cellModel:clone()
        local offset_x = self.TabViewUI:getContentSize().width - panel:getContentSize().width
        panel:setPosition(ccp(offset_x / 2, 0))
        cell:addChild(panel)
        cell.panelNode = panel
    else
        panel = cell.panelNode
    end

    idx = idx + 1
    self:cellInfoSet(cell, panel, idx)

    return cell
end

function JiayuanLevelAddLayer:cellInfoSet(cell, panel, idx)
    local bgOff = TFDirector:getChildByPath(panel, 'bg_t1')
    local titleOff = TFDirector:getChildByPath(bgOff, 'txt_title')
    local shuomingOff = TFDirector:getChildByPath(bgOff, 'txt_shuoming')
    local jinduOff = TFDirector:getChildByPath(bgOff, 'txt_jindu')

    local bgOn = TFDirector:getChildByPath(panel, 'bg_t2')
    local titleOn = TFDirector:getChildByPath(bgOn, 'txt_title')
    local shuomingOn = TFDirector:getChildByPath(bgOn, 'txt_shuoming')
    local jinduOn = TFDirector:getChildByPath(bgOn, 'txt_jindu')
    local icon_jihuo = TFDirector:getChildByPath(bgOn, 'icon_jihuo')

    local achieveTab = FamilyData:getAttrStateTab()
    local item = achieveTab[idx]
    item.currNum = QiyuManager:getJiayuanLevel()

    titleOff:setText( stringUtils.format(localizable.Jiayuan_achieve1, item[1]) )
    titleOn:setText( stringUtils.format(localizable.Jiayuan_achieve1, item[1]) )

    local attrTab = {}
    local tab = string.split( item[2], "|" )
    for i = 1, #tab do
        local str = tab[i]
        local temp = string.split( str, "_" )
        local key = tonumber(temp[1])
        local value = tonumber(temp[2])
        
        attrTab[key] = attrTab[key] or 0
        attrTab[key] = attrTab[key] + value
    end

    --local attrTab = string.split(item[2], "_")
    local attrAddName = nil
    for k, v in pairs(attrTab) do
        --[[
        local k = tonumber(attrTab[1])
        local value = attrTab[2]
        if k >= 18 then
            --value = math.floor(value/100)
            value = value .. '%'
        end
        if attrAddName then
            attrAddName = attrAddName..' '..AttributeTypeStr[k]..'+'..value
        else
            attrAddName =stringUtils.format(localizable.Jiayuan_up_all, AttributeTypeStr[k], value)
        end
        ]]
        local value = v
        if k >= 18 then
            value = value..'%'
        end
        if attrAddName then
            attrAddName = attrAddName..' '..AttributeTypeStr[k]..'+'..value
        else
            attrAddName =stringUtils.format(localizable.Jiayuan_achieve2, AttributeTypeStr[k],value)
        end
    end

    shuomingOff:setText(attrAddName)
    shuomingOn:setText(attrAddName)
    
    jinduOff:setText(item.currNum..'/'..item[1])
    jinduOn:setText(item.currNum..'/'..item[1])

    if item.currNum >= item[1] then
        bgOff:setVisible(false)
        bgOn:setVisible(true)
        icon_jihuo:setVisible(true)
        --[[
        if self.needAchieveEffect then
            self.effectNode[3] = panel
            self.iconJihuo = icon_jihuo
        end
        ]]
    else
        bgOff:setVisible(true)
        bgOn:setVisible(false)
    end
end

function JiayuanLevelAddLayer.tableScroll(table)
    local self = table.logic
    
    if self.TabView then
        local offsetMax = self.TabViewUI:getContentSize().height - cellH * achieveMax
        local currPosition = self.TabView:getContentOffset()
        if currPosition.y < 0 and offsetMax >= currPosition.y then
            self.img_di:setVisible(true)
        else
            self.img_di:setVisible(false)
        end
    end
end


return JiayuanLevelAddLayer
