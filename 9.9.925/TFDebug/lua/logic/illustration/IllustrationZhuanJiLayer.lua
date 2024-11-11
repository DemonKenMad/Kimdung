-- client side IllustrationZhuanJiLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2016-07-01

local IllustrationZhuanJiLayer = class("IllustrationZhuanJiLayer", BaseLayer)
function IllustrationZhuanJiLayer:ctor(equipid)
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.handbook.QunXiaZhuanJi")
end

function IllustrationZhuanJiLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.btn_close          = TFDirector:getChildByPath(ui, 'btn_close')
    self.btn_help           = TFDirector:getChildByPath(ui, 'btn_help')
    self.Panel_all          = TFDirector:getChildByPath(ui, 'Panel_all')
    self.Panel_star          = TFDirector:getChildByPath(ui, 'Panel_star')
    self.panel_list = {}
    self.star_list  = {}
    for i=1,5 do
        self.panel_list[i] = {}
        local rootNode = TFDirector:getChildByPath(self.Panel_all, 'Panel_level' .. i)
        self.panel_list[i].btn              = TFDirector:getChildByPath(rootNode, 'btn')
        self.panel_list[i].txt_num          = TFDirector:getChildByPath(rootNode, 'txt_num')
        self.panel_list[i].img_lock         = TFDirector:getChildByPath(rootNode, 'img_lock')
        self.panel_list[i].txt_weijiesuo    = TFDirector:getChildByPath(rootNode, 'txt_weijiesuo')
        self.panel_list[i].img_redpoint     = TFDirector:getChildByPath(rootNode, 'img_hongdian')
        self.panel_list[i].btn.idx      = i
        self.panel_list[i].btn.logic    = self

        local starNode = TFDirector:getChildByPath(self.Panel_star, 'Panel_level' .. i)
        self.star_list[i] = {}
        self.star_list[i].starNode        = starNode
        self.star_list[i].btn_xiang       = TFDirector:getChildByPath(starNode, 'btn_xiang')
        self.star_list[i].txt_num         = TFDirector:getChildByPath(starNode, 'txt_num')
        self.star_list[i].btn_xiang.idx   = i
        self.star_list[i].btn_xiang.logic = self
    end
    self.panel_attri = TFDirector:getChildByPath(ui, 'img_improvebg')
    self.panel_attri_model = TFDirector:getChildByPath(ui, 'img_cell1')
    self.panel_attri_model:retain()
    self.panel_attri_model:removeFromParent(true)
    self.panel_attri_model:setVisible(false)
end

function IllustrationZhuanJiLayer:registerEvents(ui)
    self.super.registerEvents(self)
    
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)
    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnRuleClick))
    self.btn_help.logic = self

    self.onUpdataZhuanJiHandler = function(event)
        self.isNeedBrush = true
    end;
    TFDirector:addMEGlobalListener(IllustrationManager.UpdateZhuanJiInfo ,self.onUpdataZhuanJiHandler)
end

function IllustrationZhuanJiLayer:removeEvents()
    TFDirector:removeMEGlobalListener(IllustrationManager.UpdateZhuanJiInfo ,self.onUpdataZhuanJiHandler)
    self.super.removeEvents(self)
end

function IllustrationZhuanJiLayer:dispose()
    self.super.dispose(self)
end

function IllustrationZhuanJiLayer:removeUI()
    if self.panel_attri_model then
        self.panel_attri_model:release()
        self.panel_attri_model = nil
    end
end

function IllustrationZhuanJiLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function IllustrationZhuanJiLayer:refreshUI()
    self:drawZhuanjiInfo()
    self:drawAttriInfo()
    self:drawUpInfo()
end
function IllustrationZhuanJiLayer:drawUpInfo()
    --self.infoList = IllustrationManager:getZhuanJiInfoBycategory()
    for i=1,5 do
        local starNode = self.star_list[i].starNode
        local starNum = IllustrationManager:getByCategoryZhuanJiStarNum(i)
        if (starNode) then
            if (starNum >= 0) then
                starNode:setVisible(true)
                local btn_xiang        = self.star_list[i].btn_xiang
                local txt_num          = self.star_list[i].txt_num
                txt_num:setText(starNum)
                btn_xiang:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnHelpClick))
            else
                starNode:setVisible(false)
            end
        end
    end
end
function IllustrationZhuanJiLayer:drawZhuanjiInfo()
    self.infoList = IllustrationManager:getZhuanJiInfoBycategory()
    for i=1,5 do
        self.infoList[i] = self.infoList[i] or {}
        local data = ZhuanJiCondData:getDataByCategory(i)
        local isUnlocked = self.infoList[i].isUnlocked

        self.panel_list[i].btn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnCategoryClick))
        self.panel_list[i].btn.isUnlocked = isUnlocked
        if isUnlocked == true then
            self.panel_list[i].btn:setColor(ccc3(255,255,255))
            self.panel_list[i].txt_num:setVisible(true)
            if self.panel_list[i].txt_weijiesuo then
                self.panel_list[i].txt_weijiesuo:setVisible(false)
            end
            if self.panel_list[i].img_lock then
                self.panel_list[i].img_lock:setVisible(false)
            end
            local maxNum = 0
            if self.infoList[i].dataList then
                maxNum = #(self.infoList[i].dataList)
            end
            self.panel_list[i].txt_num:setText(self.infoList[i].unLockedNum .. '/' .. maxNum)
            local isRedPoint = IllustrationManager:checkRedPointByCategory(i)
            self.panel_list[i].img_redpoint:setVisible(isRedPoint)
        elseif isUnlocked == false then
            self.panel_list[i].btn:setColor(ccc3(128,128,128))
            self.panel_list[i].txt_num:setVisible(false)
            self.panel_list[i].img_redpoint:setVisible(false)
            if self.panel_list[i].txt_weijiesuo then
                self.panel_list[i].txt_weijiesuo:setVisible(true)
            end
            if self.panel_list[i].img_lock then
                self.panel_list[i].img_lock:setVisible(true)
            end
        end
        
    end
end

function IllustrationZhuanJiLayer:drawAttriInfo()
    local tempWidth = 166
    local tempHeight = 43
    local tempX = -332
    local tempY = 10
    local posX = tempX
    local posY = tempY
    local index = 0
    local attributeTable = IllustrationManager:getZhuanJiAllAttri()
    local node = self.panel_attri:getChildByTag(100)
    if node == nil then
        node = CCNode:create()
        self.panel_attri:addChild(node,1,100)
    else
        node:removeAllChildren()
    end
    for i = EnumAttributeType.Blood,EnumAttributeType.PrecisenessPercent do
        if attributeTable[i] and attributeTable[i] > 0 then
            index = index + 1
            if index > 5 then
                index = 1
                posY = posY - tempHeight
            end
            posX = tempX + tempWidth*(index - 1)
            local panel = self.panel_attri_model:clone()
            panel:setVisible(true)
            node:addChild(panel,10)
            panel:setPosition(ccp(posX,posY))
            local txt_cell = TFDirector:getChildByPath(panel, 'txt_cell')
            txt_cell:setText(AttributeTypeStr[i] .. '+' .. attributeTable[i])
        end
    end
end
function IllustrationZhuanJiLayer.OnHelpClick( sender )
    local layer  = require("lua.logic.illustration.IllustrationUpStarLayer"):new(sender.idx)
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show()
end

function IllustrationZhuanJiLayer.OnCategoryClick( sender )
    local self = sender.logic
    if sender.isUnlocked == false then
        local data = ZhuanJiCondData:getDataByCategory(sender.idx)
        local unLockedNum = data.num
        local needData = ZhuanJiCondData:getDataByCategory(data.cond_category)
        toastMessage(stringUtils.format(localizable.ZhuanJi_txt2,needData.name,unLockedNum))
        return
    end
    local layer  = require("lua.logic.illustration.IllustrationZhuanJiTabsLayer"):new()
    layer:setInfo(self.infoList[sender.idx],sender.idx)
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show()
end

function IllustrationZhuanJiLayer.OnRuleClick( sender )
    CommonManager:showRuleLyaer('qunxiazhuanji')
end

return IllustrationZhuanJiLayer