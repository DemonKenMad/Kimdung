-- client side IllustrationZhuanJiTabsLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2016-07-04

local IllustrationZhuanJiTabsLayer = class("IllustrationZhuanJiTabsLayer", BaseLayer)
function IllustrationZhuanJiTabsLayer:ctor(equipid)
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.handbook.QunXiaZhuanTabs")
end

function IllustrationZhuanJiTabsLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.btn_close          = TFDirector:getChildByPath(ui, 'btn_close')
    self.btn_help           = TFDirector:getChildByPath(ui, 'btn_help')
    self.panel_list         = TFDirector:getChildByPath(ui, 'Panel_cell1')
    self.img_tittle         = TFDirector:getChildByPath(ui, 'img_title')
    self.TittlePath         = {'ui_new/handbook/img_jhxg.png','ui_new/handbook/img_xmyb.png','ui_new/handbook/img_wlmx.png',
                                'ui_new/handbook/img_ydzs.png','ui_new/handbook/img_shcs.png'}
    self.panel_cell_model = createUIByLuaNew("lua.uiconfig_mango_new.handbook.QunXiaTabsCell1")
    self.panel_cell_model:retain()

    self.panel_hero_model = createUIByLuaNew("lua.uiconfig_mango_new.handbook.QunXiaTabsCell2")
    self.panel_hero_model:retain()
    self.lookedList = {}
    self.firstShowIndex = 0
    self.isNeedBrush = true
    self.isNeedReset = false
end

function IllustrationZhuanJiTabsLayer:registerEvents(ui)
    self.super.registerEvents(self)
    
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)

    self.onUpdataZhuanJiHandler = function(event)
        self.isNeedBrush = true
        self.isNeedReset = true
    end;
    TFDirector:addMEGlobalListener(IllustrationManager.UpdateZhuanJiInfo ,self.onUpdataZhuanJiHandler)

    self.onRolePraciceHandler = function(event)
        self.isNeedBrush = true
        self.isNeedReset = true
    end;
    TFDirector:addMEGlobalListener(CardRoleManager.ROLE_PRACTICE_RESULT ,self.onRolePraciceHandler)
    
end

function IllustrationZhuanJiTabsLayer:removeEvents()
    TFDirector:removeMEGlobalListener(IllustrationManager.UpdateZhuanJiInfo ,self.onUpdataZhuanJiHandler)
    TFDirector:removeMEGlobalListener(CardRoleManager.ROLE_PRACTICE_RESULT ,self.onRolePraciceHandler)
    self.super.removeEvents(self)

end

function IllustrationZhuanJiTabsLayer:dispose()
    self.super.dispose(self)
end

function IllustrationZhuanJiTabsLayer:removeUI()
    if self.panel_cell_model then
        self.panel_cell_model:release()
        self.panel_cell_model = nil
    end
    if self.panel_hero_model then
        self.panel_hero_model:release()
        self.panel_hero_model = nil
    end
    local msgList = {}
    for k,v in pairs(self.lookedList) do
        if v == true then
            table.insert(msgList,k)
        end
    end
    if #msgList > 0 then
        IllustrationManager:RequestSetRedPoint(msgList)
    end
end

function IllustrationZhuanJiTabsLayer:onShow()
    self.super.onShow(self)
    if self.isNeedBrush == true then
        if self.isNeedReset == true then
            self.isNeedReset = false
            self:resetStarUpInfo()
        end
        self.isNeedBrush = false
        self:refreshUI()
    end
end

function IllustrationZhuanJiTabsLayer:refreshUI()
    if self.tableView == nil then
        self:initTableView()
    else
        self.tableView:reloadData()
    end
end

function IllustrationZhuanJiTabsLayer:resetStarUpInfo()
    if self.roleStarUpList == nil then
        self.roleStarUpList = {}
    end
    local clearList = {}
    for k,v in pairs(self.roleStarUpList) do
        if v == true then
            clearList[#clearList + 1] = k
        end
    end
    for i=1,#clearList do
        local roleId = clearList[i]
        self.roleStarUpList[roleId] = nil
    end
    -- for i=1,#self.dataList do
    --     local info = self.dataList[i]
    --     local id = nil
    --     if info.curStar > -1 and info.dataList[info.curStar + 1].isActive == true then
    --         id = info.dataList[info.curStar + 1].id
    --     else
    --         id = info.dataList[1].id
    --     end
    --     local item = ZhuanJiData:objectByID(id)
    --     local roleList = item:getRoleIdList()
    --     for j=1,#roleList do
    --         local roleId = roleList[j]
    --         if self.roleStarUpList[roleId] == nil then
    --             self.roleStarUpList[roleId] = self:isRoleCanStarUp(roleId)
    --         end
    --     end
    -- end
end

function IllustrationZhuanJiTabsLayer:setInfo( data , index)
    self.unLockedNum = data.unLockedNum
    self.roleStarUpList = {}
    local list1 = {}
    local list2 = {}
    if data.dataList and next(data.dataList) ~= nil then
        for i=1,#data.dataList do
            local info = data.dataList[i]
            local id = nil
            if info.curStar > -1 and info.dataList[info.curStar + 1].isActive == true then
                table.insert(list1,info)
                if info.redPoint == true and self.firstShowIndex == 0 then
                    self.firstShowIndex = #list1
                end
                id = info.dataList[info.curStar + 1].id
            else
                    table.insert(list2,info)
                id = info.dataList[1].id
            end
        
            local item = ZhuanJiData:objectByID(id)
            local roleList = item:getRoleIdList()
            for j=1,#roleList do
                local roleId = roleList[j]
                self.roleStarUpList[roleId] = self:isRoleCanStarUp(roleId,info.maxStar)
            end
        end
    end
    for i,v in ipairs(list2) do
        table.insert(list1,v)
    end
    self.dataList = list1
    if self.firstShowIndex == 0 then
        for i=1,#self.dataList do
            local info = self.dataList[i]
            local id = nil
            if info.curStar > -1 and info.dataList[info.curStar + 1].isActive == true then
                id = info.dataList[info.curStar + 1].id
            else
                id = info.dataList[1].id
            end
            local item = ZhuanJiData:objectByID(id)
            local roleList = item:getRoleIdList()
            for j=1,#roleList do
                local roleId = roleList[j]
                if self.roleStarUpList[roleId] == true then
                    self.firstShowIndex = i
                    break
                end
            end
            if self.firstShowIndex ~= 0 then
                break
            end
        end
    end

    self.img_tittle:setTexture(self.TittlePath[index])
end

function IllustrationZhuanJiTabsLayer:isRoleCanStarUp(roleId,maxStar)
    local role = CardRoleManager:getRoleById(roleId)
    if role then
        if role.starlevel >= role.maxStar then
            return false
        end
        -- if maxStar and role.starlevel >= maxStar then
        --     return false
        -- end
        local roleInfoList = RoleTalentData:GetRoleStarInfoByRoleId( role.id, role.quality)
        local RoleStarLevelInfo = roleInfoList:getObjectAt(role.starlevel+1)
        local levelLimit = RoleStarLevelInfo.role_level or 0

        if role.level < levelLimit then
            return false
        end
        if RoleStarLevelInfo.other_goods_id and RoleStarLevelInfo.other_goods_id ~= "" then
            local activity  = string.split(RoleStarLevelInfo.other_goods_id,'_')
            local itemGood = {}
            itemGood.id  = tonumber(activity[1]) or 0
            itemGood.num = tonumber(activity[2]) or 0
            local itemNumInBag = BagManager:getItemNumById( itemGood.id )
            if itemNumInBag < itemGood.num then
                return false
            end
        end

        local roleConfig = RoleData:objectByID(role.id)
        local hasSoul = role:getHaveSoulNum()
        if hasSoul < role:getUpstarNeedSoulNum() then
            return false
        end
        return true
    end
    return false
end

function IllustrationZhuanJiTabsLayer:initTableView()
    local  tableView =  TFTableView:create()

    self.tableView = tableView
    tableView:setTableViewSize(self.panel_list:getContentSize())
    tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
    tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)

    self.tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, handler(self.cellSizeForTable,self))
    self.tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, handler(self.tableCellAtIndex,self))
    self.tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, handler(self.numberOfCellsInTableView,self))
    --self.tableView:addMEListener(TFTABLEVIEW_SCROLL, handler(self.tableScroll,self))
    self.panel_list:addChild(tableView)
    self.tableView:reloadData()
    if self.firstShowIndex > 0 then
        local height = self.panel_list:getContentSize().height
        local maxNum = self:numberOfCellsInTableView(self.tableView)
        if maxNum * 200 + 20 > height then
            local offsetY = height - ( maxNum - self.firstShowIndex + 1 ) *200 - 20
            if offsetY > 0 then
                offsetY = 0
            end
            local offsetPoint = self.tableView:getContentOffset()
            offsetPoint.y = offsetY
            self.tableView:setContentOffset(offsetPoint)
            self.firstShowIndex = 0
        end
    end
end

function IllustrationZhuanJiTabsLayer:cellSizeForTable(table,idx)
    local maxNum = self:numberOfCellsInTableView(table)
    if idx == maxNum -1 then
        return 220,780
    end
    return 200,780
end

function IllustrationZhuanJiTabsLayer:tableCellAtIndex(table, idx)
    idx = idx + 1
    local cell = table:dequeueCell()
    if nil == cell then
        cell = TFTableViewCell:create()
        local node = self.panel_cell_model:clone()
        node:setVisible(true)
        cell:addChild(node,1,101)
    end
    self:setCellInfo(cell,idx)
    return cell
end

function IllustrationZhuanJiTabsLayer:numberOfCellsInTableView(table)
    local num = #(self.dataList)
    if num < 0 then num = 0 end
    return num
end

function IllustrationZhuanJiTabsLayer:setCellInfo(cell,idx)
    local info = self.dataList[idx]
    if info == nil then
        cell:getChildByTag(101):setVisible(false)
        return
    end
    cell:getChildByTag(101):setVisible(true)
    local maxNum = self:numberOfCellsInTableView(table)
    if idx == maxNum then
        cell:getChildByTag(101):setPosition(ccp(3,20))
    else
        cell:getChildByTag(101):setPosition(ccp(3,0))
    end
    local img_bg_jihuo      = TFDirector:getChildByPath(cell, 'img_bg_jihuo')
    local img_bg_weijihuo   = TFDirector:getChildByPath(cell, 'img_bg_weijihuo')
    if info.curStar > -1 and info.dataList[info.curStar + 1].isActive == true then
        img_bg_jihuo:setVisible(true)
        img_bg_weijihuo:setVisible(false)
        self:setJiHuoInfo(img_bg_jihuo,info)
    else
        img_bg_jihuo:setVisible(false)
        img_bg_weijihuo:setVisible(true)
        self:setWeiJiHuoInfo(img_bg_weijihuo,info)
    end
end

function IllustrationZhuanJiTabsLayer:setJiHuoInfo( panel , data )
    local starList = {}
    for i=1,5 do
        local node = TFDirector:getChildByPath(panel, 'img_starbg' .. i)
        starList[i] = TFDirector:getChildByPath(node, 'img_star')
        if i <= data.curStar then
            starList[i]:setVisible(true)
            if i <= data.curStar - 5 then
                starList[i]:setTexture("ui_new/BeStrong/hongxing2.png")
            else
                starList[i]:setTexture("ui_new/BeStrong/hongxing.png")
            end
        else
            starList[i]:setVisible(false)
        end
    end

    local txt_cellname = TFDirector:getChildByPath(panel, 'txt_cellname')
    local txt_jiacheng = TFDirector:getChildByPath(panel, 'txt_jiacheng')
    local btn_xiangqing = TFDirector:getChildByPath(panel, 'btn_xiangqing')
    local img_redpoint = TFDirector:getChildByPath(panel, 'img_hongdian')
    img_redpoint:setVisible(data.redPoint or false)
    btn_xiangqing.type = data.type
    btn_xiangqing:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnXiangQingClick))
    local panel_cell = TFDirector:getChildByPath(panel, 'Panel_cell2')
    local itemId = data.dataList[data.curStar + 1].id
    local item = ZhuanJiData:objectByID(itemId)
    if data.redPoint == true then
        self.lookedList[itemId] = true
    end
    local attributeTabel = item:getAttribute()
    local attributeIndex = 1
    local attributeNum = 0
    for k,v in pairs(attributeTabel) do
        if v > 0 then
            attributeIndex = k
            attributeNum = v
            break
        end
    end
    txt_cellname:setText(item.name)
    txt_jiacheng:setText(localizable.ZhuanJi_txt1 .. AttributeTypeStr[attributeIndex] .. '+' .. attributeNum)
    local node = panel_cell:getChildByTag(101)
    if node == nil then
        node = CCNode:create()
        panel_cell:addChild(node,1,101)
    else
        node:removeAllChildren()
    end
    local roleList = item:getRoleIdList()
    for i,v in ipairs(roleList) do
        self:getHeroNodeWithData(node,v,i,data.maxStar)
    end
end

function IllustrationZhuanJiTabsLayer:setWeiJiHuoInfo( panel , data )
    local txt_cellname = TFDirector:getChildByPath(panel, 'txt_cellname')
    local txt_jiacheng = TFDirector:getChildByPath(panel, 'txt_jiacheng')
    local btn_xiangqing = TFDirector:getChildByPath(panel, 'btn_xiangqing')
    btn_xiangqing.type = data.type
    btn_xiangqing:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnXiangQingClick))
    local panel_cell = TFDirector:getChildByPath(panel, 'Panel_cell2')
    local itemId = data.dataList[1].id
    local item = ZhuanJiData:objectByID(itemId)
    local attributeTabel = item:getAttribute()
    local attributeIndex = 1
    local attributeNum = 0
    for k,v in pairs(attributeTabel) do
        if v > 0 then
            attributeIndex = k
            attributeNum = v
            break
        end
    end
    txt_cellname:setText(item.name)
    txt_jiacheng:setText(localizable.ZhuanJi_txt1 .. AttributeTypeStr[attributeIndex] .. '+' .. attributeNum)
    local node = panel_cell:getChildByTag(101)
    if node == nil then
        node = CCNode:create()
        panel_cell:addChild(node,1,101)
    else
        node:removeAllChildren()
    end
    local roleList = item:getRoleIdList()
    for i,v in ipairs(roleList) do
        self:getHeroNodeWithData(node,v,i,data.maxStar)
    end
end

function IllustrationZhuanJiTabsLayer:getHeroNodeWithData(panel,roleId,idx,maxStar)
    local cell = self.panel_hero_model:clone()
    cell:setVisible(true)
    cell:setPosition(ccp(105*(idx - 1) + 13,2))
    panel:addChild(cell)
    local roleItem = RoleData:objectByID(roleId)
    local star = IllustrationManager:getRoleStarById(roleId)
    local btn_quality = TFDirector:getChildByPath(cell, 'btn_quality')
    local img_icon = TFDirector:getChildByPath(cell, 'img_icon')
    local img_zhiye = TFDirector:getChildByPath(cell, 'img_zhiye')
    local txt_name = TFDirector:getChildByPath(cell, 'txt_name')
    btn_quality:setTextureNormal(GetColorIconByQuality(roleItem.quality))
    btn_quality.roleId = roleId
    btn_quality:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnHeroClick))
    img_icon:setTexture(roleItem:getIconPath())
    img_zhiye:setTexture("ui_new/fight/zhiye_".. roleItem.outline ..".png")
    txt_name:setText(roleItem.name)
    local starList = {}
    for i=1,5 do
        local node = TFDirector:getChildByPath(cell, 'img_starbg' .. i)
        starList[i] = TFDirector:getChildByPath(node, 'img_star')
        starList[i]:setVisible(false)
    end
   
    CardRoleManager:SetRoleStarTexture(star, starList)
    local bisPossess = IllustrationManager:checkRoleIsPossess(roleId)
    if bisPossess == true then
        btn_quality:setColor(ccc3(255,255,255))
    else
        btn_quality:setColor(ccc3(128,128,128))
    end
    local isRoleCanStarUp = self.roleStarUpList[roleId]
    if isRoleCanStarUp == nil then
        self.roleStarUpList[roleId] = self:isRoleCanStarUp(roleId,maxStar)
        isRoleCanStarUp = self.roleStarUpList[roleId]
    end
    CommonManager:setRedPoint(img_icon, isRoleCanStarUp, "isRoleCanStarUp",   ccp(12,10))

    
    return cell
end

function IllustrationZhuanJiTabsLayer.OnXiangQingClick( sender )
    local type = sender.type
    local layer  = require("lua.logic.illustration.IllustrationZhuanJiTabsInfoLayer"):new()
    layer:setInfo(type)
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
    AlertManager:show()
end

function IllustrationZhuanJiTabsLayer.OnHeroClick(sender)
    local roleId = sender.roleId
    local starLevel = IllustrationManager:getStarLevelByRoelId(roleId)
    local role = CardRoleManager:getRoleById(roleId)
    if role ~= nil then
        local fightType = EnumFightStrategyType.StrategyType_PVE
        local roleList = TFArray:new()
        roleList:push(roleId)
        local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.role_new.RoleInfoLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
        layer:loadSelfData(1,fightType,roleList);
        AlertManager:show();
    else
        local CardRole      = require('lua.gamedata.base.CardRole')
        local cardRole = CardRole:new(roleId)
        cardRole:setLevel(1)
        cardRole:setStarlevel(starLevel)
        cardRole.attribute = {}
        local baseAttr = cardRole.totalAttribute.attribute
        
        local attribute = baseAttr

        for i=1,(EnumAttributeType.Max-1) do
            cardRole.totalAttribute[i] = attribute[i] or 0
        end

        local roleList = TFArray:new()
        roleList:clear()
        roleList:push(cardRole)


       local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.role_new.RoleInfoLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
       local selectIndex = roleList:indexOf(cardRole)
       layer:loadOtherData(selectIndex, roleList)
       layer.bShowTuPu = true
       AlertManager:show()
    end
end

return IllustrationZhuanJiTabsLayer