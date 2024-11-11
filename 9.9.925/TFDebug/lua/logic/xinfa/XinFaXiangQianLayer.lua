--[[
 * @Description: 心法镶嵌界面
 ]]
-- script writer fei
-- creation time 2017-10-20
local XinFaXiangQianLayer = class("XinFaXiangQianLayer", BaseLayer)

columnNumber = 4

function XinFaXiangQianLayer:ctor(gmId)
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.xinfa.XinFaXiangQian")
    self.gmId = gmId
    self.selectId = nil
end

function XinFaXiangQianLayer:initUI( ui )
    self.super.initUI(self, ui)
    
    self.img_fz                 = TFDirector:getChildByPath(ui, "img_fz")
    self.img_quality            = TFDirector:getChildByPath(self.img_fz, "img_quality")
    self.img_icon               = TFDirector:getChildByPath(self.img_fz, "img_icon")
    self.txt_intensify_lv       = TFDirector:getChildByPath(self.img_fz, "txt_intensify_lv")
    self.txt_name               = TFDirector:getChildByPath(self.img_fz, "txt_name")
    self.img_equiped            = TFDirector:getChildByPath(self.img_fz, "img_equiped")
    self.txt_equiped_name       = TFDirector:getChildByPath(self.img_fz, "txt_equiped_name")
    self.panel_star             = TFDirector:getChildByPath(ui, "img_star")
    self.txt_starlv             = TFDirector:getChildByPath(ui, "txt_starlv")
    self.panel_star1            = TFDirector:getChildByPath(self.img_quality, 'panel_star')

    self.btn_help               = TFDirector:getChildByPath(ui, 'btn_help')

    self.panel_huadong          = TFDirector:getChildByPath(ui, 'panel_huadong')
    self.gempos                 = nil

    self.btn_mosaic             = TFDirector:getChildByPath(ui, 'btn_xq')
    self.btn_xiexia             = TFDirector:getChildByPath(ui, 'btn_xiexia')

    self.panel_bs               = {}
    for i = 1, 5 do
        local panel_bs              = TFDirector:getChildByPath(ui, 'panel_bs'..i)
        panel_bs.btn_icon           = TFDirector:getChildByPath(panel_bs, 'btn_icon')
        panel_bs.btn_icon.index     = i
        panel_bs.img_icon           = TFDirector:getChildByPath(panel_bs, 'img_icon')
        panel_bs.img_jiahao         = TFDirector:getChildByPath(panel_bs, 'img_jiahao')
        panel_bs.txt_level          = TFDirector:getChildByPath(panel_bs, 'txt_level')
        panel_bs.img_suo            = TFDirector:getChildByPath(panel_bs, 'img_suo')
        panel_bs.img_tips           = TFDirector:getChildByPath(panel_bs, 'img_tips')
        panel_bs.icon_xuanzhong     = TFDirector:getChildByPath(panel_bs, 'icon_xuanzhong')
        self.panel_bs[i] = panel_bs
    end
    local panel_kw                  = TFDirector:getChildByPath(ui, 'panel_kw')
    panel_kw:setVisible(true)
    panel_kw:setPositionY(panel_kw:getPositionY() + 15)
    self.panel_kw = {}
    for i = 1, 2 do
        local panel_kw          = TFDirector:getChildByPath(ui, 'panel_kw'..i)
        panel_kw.txt_kwxf       = TFDirector:getChildByPath(panel_kw, 'txt_kwxf')
        panel_kw.txt_kwxf_bs    = TFDirector:getChildByPath(panel_kw, 'txt_kwxf_bs')
        panel_kw.txt_nextHurtDerate     = TFDirector:getChildByPath(panel_kw, 'txt_nextHurtDerate')
        panel_kw.txt_nextHurtDerate:setTextAreaSize(CCSizeMake(175, 100))
        panel_kw.txt_kwxf_bs:setPositionX(panel_kw.txt_kwxf_bs:getPositionX() + 15)
        self.panel_kw[i] = panel_kw
        if (i == 2) then
            panel_kw:setPositionY(panel_kw:getPositionY() - 15)
        end
    end

    self.txt_tips1              = TFDirector:getChildByPath(ui, 'txt_tips1')
    self.panel_zjc              = TFDirector:getChildByPath(ui, 'panel_zjc')
    self.panel_gem = {}
    for i = 1, 5 do
        local panel_gem                 = TFDirector:getChildByPath(self.panel_zjc, 'panel_gem'..i)
        panel_gem.img_gem1              = TFDirector:getChildByPath(panel_gem, 'img_gem1')
        panel_gem.txt_attr_gem1         = TFDirector:getChildByPath(panel_gem, 'txt_attr_gem1')
        panel_gem.txt_attr_gem_val1     = TFDirector:getChildByPath(panel_gem, 'txt_attr_gem_val1')
        self.panel_gem[i]       = panel_gem
    end

    self.holebgtxt              = {"qx","wl","fy","nl","sf"}

    self:initTableview()
end

function XinFaXiangQianLayer:isTouchInTableView(position)
    local _parent = self.tableView
    local rootPos = _parent:convertToWorldSpaceAR(self.tableView:getPosition())
    local size = self.tableView:getTableViewSize()
    if position.x > rootPos.x and position.x < rootPos.x+size.width 
        and position.y <rootPos.y + size.height and position.y > rootPos.y then
        return true
    end
    return false
end

function XinFaXiangQianLayer:checkGemValid(Gemlevel)
    if Gemlevel <= self.XinFainfo:getGemPosMaxGemLevel(self.selectHoleIndex) then
        return true
    end
    return false
end
function XinFaXiangQianLayer.cellSizeForTable(table,idx)
    return 170, 540
end

function XinFaXiangQianLayer.tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local self = table.logic
    self.allPanels = self.allPanels or {}
    if nil == cell then
        table.cells = table.cells or {}
        cell = TFTableViewCell:create()
        table.cells[cell] = true
        for i = 1, columnNumber do
            local gem_panel = require('lua.logic.smithy.SmithyGemIcon'):new(2)
            gem_panel:setPosition(ccp(10+137*(i-1), 0))
            gem_panel:setLogic( self )
            cell:addChild(gem_panel)
            cell.gem_panel = cell.gem_panel or {}
            cell.gem_panel[i] = gem_panel
            local newIndex = #self.allPanels + 1
            self.allPanels[newIndex] = gem_panel
        end
    end
    for i=1,columnNumber do
        if (idx * columnNumber + i) <= self.gemlist:length() then
            local gem = self.gemlist:objectAt(idx * columnNumber + i)
            local valid = self:checkGemValid(gem.level)
            local bShowBlack = not valid
            cell.gem_panel[i]:setGemid(gem.id, bShowBlack)      
        else
            cell.gem_panel[i]:setGemid(nil)     
        end
    end
    cell:setScale(0.9)
    return cell
end

function XinFaXiangQianLayer.numberOfCellsInTableView(table)
    local self = table.logic
    if self.gemlist and self.gemlist:length() > 0 then
        local num = math.ceil(self.gemlist:length()/columnNumber)
        if num < 2 then
            return 2
        else
            return num
        end
    end
    return 0
end

function XinFaXiangQianLayer:initTableview()
    local  tableView =  TFTableView:create()
    tableView:setTableViewSize(self.panel_huadong:getContentSize())
    tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
    tableView:setVerticalFillOrder(0)
    self.tableView = tableView
    self.tableView:setZOrder(10)
    self.tableView.logic = self
    tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, XinFaXiangQianLayer.cellSizeForTable)
    tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, XinFaXiangQianLayer.tableCellAtIndex)
    tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, XinFaXiangQianLayer.numberOfCellsInTableView)

    self.panel_huadong:addChild(tableView)
end

function XinFaXiangQianLayer:setXinFaData(data)
    local tmp = self.gmId
    self.gmId = data
    self.XinFainfo = XinFaManager:getXinFaByGmId(self.gmId)
    if tmp ~= data then
        self:selectHole(1)
    end
    self:refreshUI()
end

--[[
    全部cell都重置为未选中
]]
function XinFaXiangQianLayer:unselectedAllCellPanels()
    if self.allPanels == nil then
        return
    end

    for r=1,#self.allPanels do
        local panel = self.allPanels[r]
        if self.selectId and panel.id == self.selectId then
            panel:setChoice(false)
        end
    end
end

function XinFaXiangQianLayer:updateSelectCell()
    if self.allPanels == nil then
        return
    end

    for r=1,#self.allPanels do
        local panel = self.allPanels[r]
        panel:refreshUI()
    end
end

function XinFaXiangQianLayer:updateUnMosaicButtonEnabled()
    local equip = self.XinFainfo
    if equip == nil  then
        print("equipment not found .",self.gmId)
        return
    end

    local existGemId = equip:getGemPos(self.selectHoleIndex)

    --卸除按钮是否可点击判定
    if existGemId then
        self.btn_xiexia:setGrayEnabled(false)
        self.btn_xiexia:setTouchEnabled(true)
    else
        self.btn_xiexia:setGrayEnabled(true)
        self.btn_xiexia:setTouchEnabled(false)
    end
end

--[[
    更新镶嵌按钮状态
]]
function XinFaXiangQianLayer:updateButtonMosaicEnabled()
    self:refreshGemList()
    local equip = self.XinFainfo
    if equip == nil  then
        print("equipment not found .",self.gmId)
        return false
    end

    if self.selectId == nil then
        self.btn_mosaic:setTouchEnabled(false)
        self.btn_mosaic:setGrayEnabled(true)
        return
    end
    if self.gempos == nil then
        self:iconBtnClick(self.allPanels[1])
    end

    local existGemId = equip:getGemPos(self.selectHoleIndex)
    if existGemId then
        if existGemId == self.selectId then
            self.btn_mosaic:setTouchEnabled(false)
            self.btn_mosaic:setGrayEnabled(true)
            return
        end
    end

    self.btn_mosaic:setTouchEnabled(true)
    self.btn_mosaic:setGrayEnabled(false)
end

function XinFaXiangQianLayer:refreshGemList( )
    self:updateTableSource()
    self.tableView:reloadData()
end

function XinFaXiangQianLayer:removeUI()
    self.super.removeUI(self)
end

function XinFaXiangQianLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function XinFaXiangQianLayer:refreshUI()
    if self.XinFainfo == nil then
        print('cannot find the card gmId = ',self.gmId)
        return
    end
    self.img_quality:setTexture(GetColorIconByQuality_118(self.XinFainfo.config.quality))
    XinFaManager:BindEffectOnEquip(self.img_quality,self.XinFainfo)
    self.img_icon:setTexture("icon/item/"..self.XinFainfo.config.display..".png")
    if self.XinFainfo.star == 0 then
        self.panel_star1:setVisible(false)
    else 
        self.panel_star1:setVisible(true)
        self.txt_starlv:setText(self.XinFainfo:getStar())
    end
    if self.XinFainfo.level == 1 then
        self.txt_intensify_lv:setVisible(false)
    else
        self.txt_intensify_lv:setVisible(true)
    end
    self.txt_intensify_lv:setText("+"..self.XinFainfo.level)
    self.txt_name:setText(self.XinFainfo.config.name)
    if self.XinFainfo.equip then
        self.txt_equiped_name:setText(CardRoleManager:getRoleById(self.XinFainfo.equip).name)
        self.img_equiped:setVisible(true)
    else
        self.img_equiped:setVisible(false)
    end

    for i = 1, 5 do
        local holeLevel = self.XinFainfo:getGemPosLevel(i)
        local gemId = self.XinFainfo:getGemPos(i)
        if gemId ~= nil then
            self.panel_bs[i].img_icon:setTexture("icon/item/"..gemId..".png")
            self.panel_bs[i].img_icon:setVisible(true)
        else
            self.panel_bs[i].img_icon:setVisible(false)
        end
        -- if i ~= 1 then
        -- print(">>>>>>>>>>",i,self.XinFainfo:IsGemPosOpen(i))
        if self.XinFainfo:IsGemPosOpen(i) == true then
            self.panel_bs[i].img_suo:setVisible(false)
            self.panel_bs[i].img_tips:setVisible(false)
            self.panel_bs[i].isOpen = true
        else
            self.panel_bs[i].img_suo:setVisible(true)
            self.panel_bs[i].img_tips:setVisible(true)
            self.panel_bs[i].isOpen = false
        end
        -- end
        if holeLevel == 0 then
            self.panel_bs[i].txt_level:setVisible(false)
        else
            self.panel_bs[i].txt_level:setVisible(true)
        end
        self.panel_bs[i].txt_level:setText(stringUtils.format(localizable.commonTxt_level,holeLevel))
    end

    for i = 1, 5 do
        local gemId = self.XinFainfo:getGemPos(i)
        if gemId ~= nil then
            local stone = ItemData:objectByID(gemId)
            self.panel_gem[i].img_gem1:setTexture("icon/item/"..gemId..".png")
            self.panel_gem[i].txt_attr_gem1:setText(localizable.AttributeTypeStr[stone.kind])
            local gemAttr = GemData:objectByID(gemId)
            if gemAttr.attribute and gemAttr.attribute ~= "" then 
                local attributekind , attributenum = gemAttr:getAttribute()
                local IsExtra, value = self.XinFainfo:getGemPosIsExtra(i)
                if IsExtra ~= 0 then
                    attributenum = attributenum * (1 + value)
                end
                self.panel_gem[i].txt_attr_gem_val1:setText("+" .. attributenum)
            end
            self.panel_gem[i].img_gem1:setVisible(true)
            self.panel_gem[i].txt_attr_gem_val1:setVisible(true)
        else
            self.panel_gem[i].txt_attr_gem1:setText(localizable.Open_Choice_Box_txt_weixiangqian)
            self.panel_gem[i].img_gem1:setVisible(false)
            self.panel_gem[i].txt_attr_gem_val1:setVisible(false)
        end
    end
    self:updateTableSource()
    self:updateUnMosaicButtonEnabled()
    self:updateButtonMosaicEnabled()
    self:refreshGemInfo()
end

function XinFaXiangQianLayer:refreshGemInfo()
    local rule = KongfuGemRuleData:GemRuleByPos(self.selectHoleIndex)
    local index = self.XinFainfo:getGemPosIsExtra(self.selectHoleIndex)
    for i = 1, 2 do
        self.panel_kw[i].txt_kwxf_bs:setText(stringUtils.format(localizable.Gem, AttributeTypeStr[tonumber(rule[i][1])]))
        self.panel_kw[i].txt_nextHurtDerate:setText(localizable.Extra_Gem_Add..'+'..tonumber(rule[i][2]) / 100 .. '%')
        if i == index then
            self.panel_kw[i].txt_nextHurtDerate:setColor(ccc3(0,128,0))
        else
            self.panel_kw[i].txt_nextHurtDerate:setColor(ccc3(0,0,0))
        end
    end
    
end

function XinFaXiangQianLayer:updateTableSource()

    local gemlisttmp = BagManager:getItemByType(EnumGameItemType.Gem)
    local gemlist = TFArray:new()
    for v in gemlisttmp:iterator() do
        if v.kind <= 5 and v.kind >= 1 then
            gemlist:push(v)
        end
    end
    local function sortlist(src,target)
        if src.itemdata.level < target.itemdata.level then
            return false
        elseif src.itemdata.level == target.itemdata.level and src.itemdata.id < target.itemdata.id then
            return false
        else
            return true
        end
    end
    local level = self.XinFainfo:getGemPosMaxGemLevel(self.selectHoleIndex)
    self.gemlist = TFArray:new()
    local newList = TFArray:new()
    for v in gemlist:iterator() do
        if v.level <= level then
            self.gemlist:push(v)
        else
            newList:push(v)
        end
    end
    self.gemlist:sort(sortlist)
    newList:sort(sortlist)

    for v in newList:iterator() do
        self.gemlist:push(v)
    end

    self.tableView:reloadData()

    if self.selectId == nil and self.gemlist:length() > 0 then
        self.selectId = self.gemlist:objectAt(1).id
        print("self.selectId == ",self.selectId)
    end
end

function XinFaXiangQianLayer:registerEvents()
    self.super.registerEvents(self)

    for i = 1, 5 do
        self.panel_bs[i].btn_icon:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onHoleClickHandle),1)
        self.panel_bs[i].btn_icon.logic = self
    end

    self.btn_xiexia:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onUmMosaicClickHandle),1)
    self.btn_xiexia.logic = self

    self.btn_mosaic:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMosaicClickHandle),1)
    self.btn_mosaic.logic = self

    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onHelpClickHandle),1)
    self.btn_help.logic = self

    self.receiveInfo = function(event)     
        print("self.receiveInfo",event.data)
        if event.data[1][1].itemId ~= 0 then --装备宝石
            self.XinFainfo:setGemPos(event.data[1][1].pos, event.data[1][1].itemId)
            self:mosaicAction(event.data[1][1].itemId,self.gempos)
            self:refreshUI()
        else
            -- self.XinFainfo:setGemPos(event.data[1][1].pos, nil)
            self:unMosaicAction(self.XinFainfo:getGemPos(event.data[1][1].pos))
            self:refreshUI()
        end
    end
    TFDirector:addMEGlobalListener(XinFaManager.GemInfo, self.receiveInfo)
    
end

function XinFaXiangQianLayer:selectHole(index)
    for i = 1,5 do
        if i ~= index then
            self.panel_bs[i].icon_xuanzhong:setVisible(false)
        else
            self.panel_bs[i].icon_xuanzhong:setVisible(true)
        end
    end
    self.selectHoleIndex = index
    self.txt_tips1:setText(stringUtils.format(localizable.MaxGemLevel,self.XinFainfo:getGemPosMaxGemLevel(self.selectHoleIndex)))
    self:updateTableSource()
    self:refreshGemInfo()
end


function XinFaXiangQianLayer:iconBtnClick(cell)
    print("--------------iconBtnClick------------")
    play_xuanze();
    self.selectId  = cell.id
    self.gempos = cell:getEffectPosition()
    self.gempos.x = self.gempos.x - 107
    self.gempos.y = self.gempos.y + 20
    self:updateSelectCell()
    --更新镶嵌按钮状态
    self:updateButtonMosaicEnabled()

    --PlayerGuideManager:showNextGuideStep()
end

function XinFaXiangQianLayer.onMosaicClickHandle( sender )
    local self = sender.logic
    -- print("onHoleClickHandle")
    local gem = ItemData:objectByID(self.selectId)
    if gem == nil  then
        return
    end
    if self:checkGemValid(gem.level) == false then
        toastMessage(localizable.GemOverLevel)
        return
    end
    XinFaManager:sendHeartMethodGemMosaic(self.gmId, self.selectId, self.selectHoleIndex)
end

function XinFaXiangQianLayer.onUmMosaicClickHandle( sender )
    local self = sender.logic
    -- print("onHoleClickHandle")
    XinFaManager:sendHeartMethodGemUnMosaic(self.gmId, self.selectHoleIndex)
end

function XinFaXiangQianLayer.onHoleClickHandle( sender )
    local self = sender.logic
    local index = sender.index
    -- print("onHoleClickHandle")
    local Isopen, openKind = self.XinFainfo:IsGemPosOpen(index)
    if Isopen == false then
        print(localizable.XinFaXuanGuan,AttributeTypeStr[index])
        if index == 1 then
            toastMessage(localizable.XinFaXuanGuan1)
            return
        end
        toastMessage(stringUtils.format(localizable.XinFaXuanGuan,AttributeTypeStr[openKind],AttributeTypeStr[index]))
        return
    end
    self:selectHole(index)
    
    self:updateButtonMosaicEnabled()
    self:updateUnMosaicButtonEnabled()
end

--[[
播放镶嵌宝石动画
]]
function XinFaXiangQianLayer:playEffect(x,y)
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/gem_click.xml")
    local effect = TFArmature:create("gem_click_anim")
    if effect == nil then
        return
    end

    effect:setZOrder(100)
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:playByIndex(0, -1, -1, 0)

    effect:setPosition(ccp(x, y))

    self.ui:addChild(effect)
    effect:addMEListener(TFARMATURE_COMPLETE,
    function()
        self.ui:removeChild(effect)
    end)
end

--[[
    镶嵌宝石
]]
function XinFaXiangQianLayer:mosaicAction(id,pos)
    local gem = ItemData:objectByID(id)
    if gem == nil  then
        return
    end
    local pic = TFImage:create()
    pic:setTexture(gem:GetPath())
    pic:setZOrder(100)
    pic:setPosition(ccp(pos.x, pos.y))
    self.ui:getParent():addChild(pic)
    local _parent = self.panel_bs[self.selectHoleIndex].img_icon:getParent()
    local worldPos = _parent:convertToWorldSpaceAR(self.panel_bs[self.selectHoleIndex].img_icon:getPosition())
    _parent = self.ui:getParent():getParent()
    local rootPos = _parent:convertToWorldSpaceAR(self.ui:getParent():getPosition())
    worldPos.x = worldPos.x - rootPos.x
    worldPos.y = worldPos.y - rootPos.y
    local tween = {
        target = pic,
            {
                ease = {type=TFEaseType.EASE_IN_OUT, rate=3},
                duration = 0.6,
                x = worldPos.x,
                y = worldPos.y,
                onComplete = function ()
                    pic:removeFromParentAndCleanup(true)
                    pic = nil
                    self:playEffect(worldPos.x,worldPos.y)
                    -- self:updateInfo()
                    self:showSuccessDialog()
                end,
            },
    }

    self:playEffect(pos.x,pos.y)
    TFDirector:toTween(tween)
end

--[[
    移除已经镶嵌的宝石
]]
function XinFaXiangQianLayer:unMosaicAction(id)
    local gem = ItemData:objectByID(id)
    if gem == nil  then
        return
    end
    local pic = TFImage:create()
    pic:setTexture(gem:GetPath())
    pic:setZOrder(100)

    self.ui:getParent():addChild(pic)
    local _parent = self.panel_bs[self.selectHoleIndex].img_icon:getParent()
    local worldPos = _parent:convertToWorldSpaceAR(self.panel_bs[self.selectHoleIndex].img_icon:getPosition())
    _parent = self.ui:getParent():getParent()
    local rootPos = _parent:convertToWorldSpaceAR(self.ui:getParent():getPosition())
    worldPos.x = worldPos.x - rootPos.x
    worldPos.y = worldPos.y - rootPos.y
    pic:setPosition(ccp(worldPos.x,worldPos.y))
    self.XinFainfo:setGemPos(self.selectHoleIndex,nil)
    self:playEffect(worldPos.x,worldPos.y)

    _parent = self.panel_huadong:getParent()
    worldPos = _parent:convertToWorldSpaceAR(self.panel_huadong:getPosition())
    local size = self.panel_huadong:getContentSize()
    worldPos.x = worldPos.x - rootPos.x + size.width/2
    worldPos.y = worldPos.y - rootPos.y + size.height/2
    local tween = {
        target = pic,
            {
                ease = {type=TFEaseType.EASE_IN_OUT, rate=3},
                duration = 0.6,
                x = worldPos.x,
                y = worldPos.y,
                onComplete = function ()
                    pic:removeFromParentAndCleanup(true)
                    pic = nil
                end,
            },
    }

    TFDirector:toTween(tween)
end

--显示升星成功对话框
function XinFaXiangQianLayer:showSuccessDialog()
    if self.layer_result == nil then
        self.layer_result = TFImage:create("ui_new/smithy/xiangqian_word.png")
        self.layer_result:setAnchorPoint(ccp(0.5,0.5))
        self.layer_result:setPosition(ccp(self.ui:getParent():getContentSize().width/2,self.ui:getParent():getContentSize().height/2))
        self.ui:getParent():addChild(self.layer_result)
    end

    TFDirector:killAllTween(self.layer_result)
    self.layer_result:setVisible(true)
    self.layer_result:setZOrder(100)
    self.layer_result:setScale(0.1)
    local tween = {
        target = self.layer_result,
            {
                duration = 0.1,
                scale = 1,
            },
            {
                duration = 0.1,
                scale = 0.8,
            },
            {
                duration = 0.1,
                scale = 1,
            },
            {
                duration = 0,
                delay = 1,
                onComplete = function ()
                    self.layer_result:setVisible(false)
                end,
            },
    }
    TFDirector:toTween(tween)
end

function XinFaXiangQianLayer:removeEvents()
    self.super.removeEvents(self)

    TFDirector:removeMEGlobalListener(XinFaManager.GemInfo, self.receiveInfo)
    self.receiveInfo = nil
end

function XinFaXiangQianLayer.onHelpClickHandle( btn )
    CommonManager:showRuleLyaer("kongfumethodjewel")
end

function XinFaXiangQianLayer.onShowItemClickHandle(sender)
    local self = sender.logic;
    if sender.itemId == nil then
        Public:ShowItemTipLayer(nil, sender.itemTypeId)
    else
        Public:ShowItemTipLayer(sender.itemId, sender.itemTypeId,XinFaManager:getIdenticalXinFaStuffNum(sender.itemId,self.gmId))
    end
end
return XinFaXiangQianLayer