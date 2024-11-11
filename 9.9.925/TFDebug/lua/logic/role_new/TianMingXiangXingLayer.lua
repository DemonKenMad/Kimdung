-- client side TianMingXiangXingLayer.lua
--[[
 * @Description: 天命镶星界面
 ]]

local GameAttributeData = require('lua.gamedata.base.GameAttributeData')
local TianMingXiangXingLayer = class("TianMingXiangXingLayer", BaseLayer)
local EffectExtraData = clone(EffectExtraDataModel)
local columnNumber = 4
local BrightBall = "ui_new/tianming/img_zhuzi1.png"
local DarkBall = "ui_new/tianming/img_zhuzi2.png"
function TianMingXiangXingLayer:ctor(data)
    self.super.ctor(self,data);
    self:init("lua.uiconfig_mango_new.role_new.TianMingXiangXing")
end

function TianMingXiangXingLayer:initUI(ui)
    self.super.initUI(self,ui)


    self.panel_kong                 = TFDirector:getChildByPath(ui, 'panel_kong')
    self.txt_name                   = TFDirector:getChildByPath(self.panel_kong, 'txt_name')
    self.img_kong                   = TFDirector:getChildByPath(self.panel_kong, 'img_kong')
    self.img_pz                     = TFDirector:getChildByPath(self.img_kong, 'img_pz')
    self.img_tm                     = TFDirector:getChildByPath(self.img_kong, 'img_tm')

    self.panel_star                 = TFDirector:getChildByPath(self.panel_kong, 'panel_star')
    self.panel_star:setVisible(false)
    self.txt_starlv                 = TFDirector:getChildByPath(self.panel_star, 'txt_starlv')

    self.sxLayer = {}
    local panel_sx          = TFDirector:getChildByPath(ui, 'panel_kongsx')
    for i = 1,6 do
        local img_sx         = TFDirector:getChildByPath(panel_sx, 'img_sx'..i)
        img_sx.img_to       = TFDirector:getChildByPath(img_sx, 'img_to')
        img_sx.txt_curlv    = TFDirector:getChildByPath(img_sx, 'txt_current_lv')
        img_sx.txt_nextlv   = TFDirector:getChildByPath(img_sx, 'txt_next_lv')
        img_sx.txt_name     = TFDirector:getChildByPath(img_sx, 'txt_name')
        img_sx.txt_numLv_effect = TFDirector:getChildByPath(img_sx, 'txt_numLv_effect')
        img_sx.txt_numLv_effect:setVisible(false)
        self.sxLayer[i]     = img_sx
        self.sxLayer[i]:setVisible(false) 
    end 

    self.cost = {}
    local cailiao = TFDirector:getChildByPath(ui, 'Panel_cailiao')
    for i = 1 ,2 do 
        local btn_tool      = TFDirector:getChildByPath(cailiao, 'btn_tool'..i) 
        btn_tool.img_tool  = TFDirector:getChildByPath(btn_tool, 'img_tool'..i) 
        btn_tool.txt_num1  = TFDirector:getChildByPath(btn_tool, 'txt_num'..i.."_1") 
        btn_tool.txt_num2  = TFDirector:getChildByPath(btn_tool, 'txt_num'..i.."_2")     
        btn_tool:setVisible(false)
        self.cost[i] = btn_tool
    end

    self.XXBall = {}
    local img_xxbg = TFDirector:getChildByPath(ui, 'img_xxbg')
    for i = 1,10 do
        local ball = TFDirector:getChildByPath(img_xxbg, 'img_kong'..i)
        ball:setTexture(DarkBall)
        self.XXBall[i] = ball
    end
    self.img_xxjc = TFDirector:getChildByPath(ui, 'img_xxjc')
    self.txt_qhs  = TFDirector:getChildByPath(self.img_xxjc, 'txt_qhs')
    self.btn_sj   = TFDirector:getChildByPath(ui, 'btn_sj')
    self.img_background = TFDirector:getChildByPath(ui, 'img_background')
    self.PlayOpenEffect = {}
    self.rightEffect = {}

end
function TianMingXiangXingLayer:setTianMingData(gmId)
    self.instanceId = gmId
end

function TianMingXiangXingLayer:loadData(instanceId)
    self.instanceId = instanceId
end

function TianMingXiangXingLayer:onShow()
    self.super.onShow(self)
    self:refreshUI() 
end
function TianMingXiangXingLayer:refreshUI()
    local tianming = TianMingManager:getTianMingByGmId(self.instanceId)
    if tianming then
        self.txt_name:setText(tianming.config.name)
        self.img_pz:setTexture(GetColorRoadIconByQuality(tianming.quality))
        self.img_tm:setTexture(tianming.config:GetPath())
        self.panel_star:setVisible(false)
        --镶星
        if tianming.starLevel > 0 or tianming.starnum > 0 then
            self.panel_star:setVisible(true)
            self.txt_starlv:setText(tianming.starnum)
        end

        local attribute1 = tianming.totalAttribute.attribute
        for i=1,6 do
            self.sxLayer[i]:setVisible(false)
        end
        local attribute = {}
        local nextattribute = {}
        for k,v in pairs(attribute1) do
            table.insert(attribute,{id = k,vaule = v})
        end
        table.sort(attribute,function (a,b)
             return a.id < b.id
        end)
        local i = 1
        for k,v in pairs(attribute) do
            if i <= 6 then
                self.sxLayer[i]:setVisible(true)
                if v.id == 44 or v.id == 41 or v.id == 42 or v.id == 40 then 
                    if v.vaule < 0 then
                        self.sxLayer[i].txt_name:setText(localizable.TianMingAttributeTypeStr[v.id]..localizable.TianMing_tips10)
                        self.sxLayer[i].txt_curlv:setText("+"..math.abs(v.vaule/100) .."%")
                    else
                        self.sxLayer[i].txt_name:setText(localizable.TianMingAttributeTypeStr[v.id]..localizable.TianMing_tips9)
                        self.sxLayer[i].txt_curlv:setText("+"..v.vaule/100 .."%")
                    end
                else
                    self.sxLayer[i].txt_name:setText(localizable.TianMingAttributeTypeStr[v.id])
                    if v.id <= 15 then
                        self.sxLayer[i].txt_curlv:setText("+"..v.vaule)
                    else
                        self.sxLayer[i].txt_curlv:setText("+"..v.vaule/100 .."%")
                    end
                end
                i = i + 1    
            end
        end
        self:addXuanzhongEffect(self.XXBall[1],"Tianming_effect_1",true)
        local starLevel = tianming.starLevel
        local starnum = starLevel % 10
        if tianming.starLevel == 0 then
            for i = 1,10 do
                self.XXBall[i]:setTexture(DarkBall)
            end
            self:addXuanzhongEffect(self.XXBall[1],"Tianming_effect_1")
        elseif tianming.starLevel == 10 then
            for i = 1,10 do
                self.XXBall[i]:setTexture(BrightBall)
            end
        else
            for i = 1,10 do
                if i <= starnum then
                    self.XXBall[i]:setTexture(BrightBall)
                else
                    self.XXBall[i]:setTexture(DarkBall)
                end 
                self:addXuanzhongEffect(self.XXBall[starnum + 1],"Tianming_effect_1")
            end 
        end 
        self.txt_qhs:setText(tianming.starPercent/100 .."%")
    end
    -- 材料消耗
    local bool = true
    local costnum = 1
    local level = tianming.starLevel
    local star = tianming.starnum
    if level  < 10 then
        level = level + 1
    elseif level == 10 then
        star = star + 1
        level = 0
    end
    for i = 1,2 do
        self.cost[costnum]:setVisible(false)
    end
    local cost1,cost2 =  DesTinyStarData:getConsumeByLevelandStarQuality(tianming.quality,level,star)
    if next(cost1)== nil and next(cost2) == nil then
        bool = false
    end
    if next(cost1) ~= nil then
        local num = TianMingManager:getTianmingNumByKindandQuality(tianming.instanceId,tianming.config.kind,cost1.quality)
        --天命id的获取
        local id = 30623 --废弃天命
        id  = id + (cost1.quality - 2)*27 + tianming.config.kind
        
        if id < 30623 then
            id = 30624
        elseif id > 30762 then
            id = 30762
        end

        local TianMing1 = ItemData:objectByID(id)
        --TianMingManager:getTianmingByKindandQuality(tianming.config.kind,cost1.quality)

        if TianMing1 then
            self.cost[costnum]:setVisible(true)
            self.cost[costnum].img_tool:setTexture(TianMing1:GetPath())
            self.cost[costnum].txt_num1:setText(num.."/")
            self.cost[costnum].txt_num2:setText(cost1.num)
            self.cost[costnum]:setTextureNormal(GetColorIconByQuality(TianMing1.quality))
            self.cost[costnum].itemId = TianMing1.id
            self.cost[costnum].itemTypeId = 1
            self.cost[costnum].itemnum = num
            costnum = costnum + 1
            if num < cost1.num then 
                bool = false
            end
        end
    end
    if next(cost2) ~= nil then
        for i =1 ,#cost2 do
            if costnum > 2 then
                costnum = 2
            end
            if cost2[i].atrrType == EnumDropType.GOODS then
                local item = ItemData:objectByID(cost2[i].atrrId)
                if (item) then
                    local iconStr = item:GetPath()
                    self.cost[costnum].img_tool:setTexture(iconStr)
                    self.cost[costnum]:setTextureNormal(GetColorIconByQuality(item.quality))
                end
                local num = BagManager:getItemNumById(cost2[i].atrrId)
                self.cost[costnum].txt_num1:setText(num.."/")
                self.cost[costnum].txt_num2:setText(cost2[i].atrrNum)
                self.cost[costnum].itemId = cost2[i].atrrId
                self.cost[costnum].itemTypeId = EnumDropType.GOODS
                self.cost[costnum]:setVisible(true)
                costnum = costnum + 1
                if num < cost2[i].atrrNum then 
                    bool = false
                end
            elseif cost2[i].atrrType == EnumDropType.JINGPO then
                local num =MainPlayer:getResValueByType(EnumDropType.JINGPO)
                self.cost[costnum].img_tool:setTexture(GetJingPoCoinIcon())
                self.cost[costnum]:setTextureNormal(GetColorIconByQuality(4))
                self.cost[costnum].txt_num1:setText(num.."/")
                self.cost[costnum].txt_num2:setText(cost2[i].atrrNum)
                self.cost[costnum].itemId = cost2[i].atrrId
                self.cost[costnum].itemTypeId = EnumDropType.JINGPO
                self.cost[costnum]:setVisible(true)
                costnum = costnum + 1
                if num < cost2[i].atrrNum then 
                    bool = false
                end
            end
        end
    end
    if tianming.starLevel == 10 then
        self.btn_sj:setTextureNormal("ui_new/tianming/btn_shengxing.png")
    else
        self.btn_sj:setTextureNormal("ui_new/tianming/btn_xx.png")
    end
    if tianming.starnum == 5 then
        self.btn_sj:setGrayEnabled(true)
        self.btn_sj:setTouchEnabled(false)
    else
        self.btn_sj:setGrayEnabled(false)
        self.btn_sj:setTouchEnabled(true)
    end
    self:addRefiningEffect(tianming) 
end
function TianMingXiangXingLayer.onShowItemClickHandle(sender)
    local self = sender.logic;
    if sender.itemId == nil then
        Public:ShowItemTipLayer(nil, sender.itemTypeId)
    else
        Public:ShowItemTipLayer(sender.itemId, sender.itemTypeId,sender.itemnum)
    end
end
function TianMingXiangXingLayer:dispose()
    self.super.dispose(self)
end

function TianMingXiangXingLayer:registerEvents()
    self.super.registerEvents(self)
    self.btn_sj.logic = self
    self.btn_sj:addMEListener(TFWIDGET_CLICK, audioClickfun(self.sendTianMingXX),1)
    for i =1 ,2 do
        self.cost[i].logic = self
        self.cost[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShowItemClickHandle),1)
    end
    self.updatatianming = function(event)
    local tianming = TianMingManager:getTianMingByGmId(self.instanceId)
        if tianming.starLevel ~= 0 then
            self:addSuccessEffect(self.XXBall[tianming.starLevel])
        else
            self:addResultEffect() 
        end
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(TianMingManager.REPONSE_STAR_LEVEL_DESTINY,self.updatatianming)
end
function TianMingXiangXingLayer.sendTianMingXX(sender)
    local self = sender.logic
    TianMingManager:sendStarLevelDetiny(self.instanceId)
end
function TianMingXiangXingLayer:removeEvents()
    self.super.removeEvents(self)
    TFDirector:removeMEGlobalListener(TianMingManager.REPONSE_STAR_LEVEL_DESTINY,self.updatatianming)
    self.updatatianming = nil
end

function TianMingXiangXingLayer:dispose()
    self.super.dispose(self)
    TFDirector:unRequire('lua.gamedata.base.GameAttributeData')
end

function TianMingXiangXingLayer:addXuanzhongEffect( widget , effectName, isShow)
    if (self.xuanzhong_effect ~= nil) then
        self.xuanzhong_effect:removeFromParent()
        self.xuanzhong_effect = nil
    end
    if (isShow) then
        return
    end
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/"..effectName..".xml")
    local effect = TFArmature:create(effectName.."_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:playByIndex(0, -1, -1, 1)
    -- effect:setScale(0.68)
    local pos = widget:getPosition()
    effect:setPosition(ccp(25, 26))
    self.xuanzhong_effect = effect
    widget:addChild(effect)
end

function TianMingXiangXingLayer:addSuccessEffect( widget )
    if self.successEffect then
        self.successEffect:removeMEListener(TFARMATURE_COMPLETE)
        self.successEffect:removeFromParent()
        self.successEffect = nil
    end
    if (widget == nil) then
        return
    end
    local resPath = "effect/TianMing_xuanzuan.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create("TianMing_xuanzuan_anim")

    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:setPosition(ccp(30, 28))
    effect:setZOrder(100)
    self.successEffect = effect    
    self.successEffect:playByIndex(0, -1, -1, 0)
    widget:addChild(effect)

    effect:addMEListener(TFARMATURE_COMPLETE,function()
        effect:removeFromParent()
        self.successEffect = nil
    end)
end
function TianMingXiangXingLayer:addResultEffect() 
    for i = 1,10 do 
        if self.rightEffect and self.rightEffect[i] then
            self.rightEffect[i]:removeMEListener(TFARMATURE_COMPLETE)
            self.rightEffect[i]:removeFromParent()
            self.rightEffect[i] = nil
        end
        --
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/Tianming_effect_3.xml")
        local effect = TFArmature:create("Tianming_effect_3_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        self.XXBall[i]:addChild(effect)
        effect:setPosition(ccp(26,26))
        effect:setZOrder(100)
        self.rightEffect[i] = effect
        self.rightEffect[i]:playByIndex(0, -1, -1, 0)
    
        effect:addMEListener(TFARMATURE_COMPLETE,function()
            effect:removeFromParent()
            self.rightEffect[i] = nil
        end)  
    end
end
function TianMingXiangXingLayer:addRefiningEffect(tianming) 
    for i = 1,10 do 
        if self.PlayOpenEffect and self.PlayOpenEffect[i] then
            self.PlayOpenEffect[i]:removeMEListener(TFARMATURE_COMPLETE)
            self.PlayOpenEffect[i]:removeFromParent()
            self.PlayOpenEffect[i] = nil
        end
        if tianming.starLevel >= i then
            TFResourceHelper:instance():addArmatureFromJsonFile("effect/Tianming_effect_2.xml")
            local effect = TFArmature:create("Tianming_effect_2_anim")
            effect:setAnimationFps(GameConfig.ANIM_FPS)
            self.XXBall[i]:addChild(effect)
            effect:setPosition(ccp(25,25))
            effect:setZOrder(100)
            self.PlayOpenEffect[i] = effect
            self.PlayOpenEffect[i]:playByIndex(0, -1, -1, 1)
        end
    end

end
return TianMingXiangXingLayer