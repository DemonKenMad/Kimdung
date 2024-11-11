-- client side IslandPrize.lua
--[[
 * @Description: 东瀛岛抽卡界面

 ]]
-- script writer wuqi
-- creation time 2016-12-15

local IslandPrize = class("IslandPrize", BaseLayer)

function IslandPrize:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.island.IslandPrize")
    self.leftTimes      = JapanIslandManager.defaultLotTimes or 2
    self.selectIdx      = 1
    self.bCanClickCard  = true
    self.getCardIdxList = {}
    self.objList        = {}
    self.firstShow = true
end

function IslandPrize:initUI(ui)
    self.super.initUI(self, ui)

    self.btn_queding        = TFDirector:getChildByPath(ui, 'btn_queding')
    self.btn_queding.logic  = self
    self.btn_getall         = TFDirector:getChildByPath(ui, 'btn_getall')
    self.btn_getall.logic   = self

    self.img_price_bg       = TFDirector:getChildByPath(ui, 'img_price_bg')
    self.txt_numb           = TFDirector:getChildByPath(ui, 'txt_numb')
    self.txt_tips2          = TFDirector:getChildByPath(ui, 'txt_tips2')
    local txt_tips1         = TFDirector:getChildByPath(ui, 'txt_tips1')
    txt_tips1:setText(localizable.JapanIsland_tips4)
    self.txt_tips2:setVisible(false)
    self.prizeBtn           = TFDirector:getChildByPath(ui, 'btn_choujiang')
    self.prizeBtn.logic     = self
    self.prizeBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onlickPrizeBtn));

    self.txt_sy = TFDirector:getChildByPath(ui, "txt_sy")

    self.ItemList = {}
    for i = 1, 4 do
        -- img_award
        self.ItemList[i] = {}
        self.ItemList[i].node         = TFDirector:getChildByPath(ui, "img_award"..i)
        self.ItemList[i].img_quality  = TFDirector:getChildByPath(ui, "img_quality"..i)
        self.ItemList[i].img_goods    = TFDirector:getChildByPath(ui, "img_goods"..i)
        self.ItemList[i].txt_num      = TFDirector:getChildByPath(ui, "txt_num"..i)

        self.ItemList[i].img_goods.index = i
        self.ItemList[i].img_goods.logic = self
        self.ItemList[i].img_goods:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onlickPrize))
    end
    self.timeResultId = {}

    self.count = 0
    self.initPos = {}
    for i = 1, 4 do
        self.initPos[i] = self.ItemList[i].node:getPosition()
        self.ItemList[i].node:setVisible(false)
    end

    self.prizeBtn:setVisible(false)

    self:playShuffleEffect()
end

function IslandPrize:registerEvents(ui)
    self.super.registerEvents(self)
    self.btn_queding:addMEListener(TFWIDGET_CLICK, audioClickfun(self.closeBtnClickHandle));
    self.btn_getall:addMEListener(TFWIDGET_CLICK, audioClickfun(self.buyAllItem));

    self.updateBox = function(event)
        self.leftTimes                      = self.leftTimes - 1
        self.getBoxData                     = event.data[1][1]
        self.showAwardList                  = event.data[1][2] or nil
        self.getCardIdxList[self.selectIdx] = true
        if (self.timeIdr) then
            TFDirector:removeTimer(self.timeIdr)
            self.timeIdr = nil
        end
        self.ItemList[self.selectIdx].node:setVisible(false)
        self.ItemList[self.selectIdx].node:setGrayEnabled(false)
        self:playEffect2(self.selectIdx, self.getBoxData)
    end
    TFDirector:addMEGlobalListener(JapanIslandManager.LOTTERY_RESPONSE, self.updateBox)
end

--
function IslandPrize:showAward()
    if (self.showAwardList) then
        local count = 1
        for i=1,4 do
            if (self.getCardIdxList[i] ~= true) then
                if (self.showAwardList[count]) then
                    self.getCardIdxList[i] = true
                    self:playEffect2(i, self.showAwardList[count], true)
                    count = count + 1
                end
            end
        end
    end
end

--
function IslandPrize:removeEvents()
    self.super.removeEvents(self)
    if (self.timeIdr) then
        TFDirector:removeTimer(self.timeIdr)
        self.timeIdr = nil
    end
    TFDirector:removeMEGlobalListener(JapanIslandManager.LOTTERY_RESPONSE, self.updateBox )
    self.updateBox = nil

    if self.timeResultId then
        for i = 1, 4 do
            if self.timeResultId[index] and self.timeResultId[index].timeId then
                TFDirector:removeTimer(self.timeResultId[index].timeId)
                self.timeResultId[index].timeId = nil
            end
        end
    end

    if self.timeId then
        TFDirector:removeTimer(self.timeId)
        self.timeId = nil
    end

    for k,v in pairs(self.objList) do 
        TFDirector:removeTimer(v.timeId)
        v.timeId = nil
    end
end

function IslandPrize:playEffect2(prizeIndex, bData, isShow)

    local resPath = "effect/ui/island_turn_card.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create("island_turn_card_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)

    local node1          = self.ItemList[prizeIndex].node
    local nodeParent1    = node1:getParent()
    nodeParent1:addChild(effect, 3)
    effect:setPosition(node1:getPosition())
    effect:setAnchorPoint(ccp(0.5, 0.5))

    local node = self.ItemList[prizeIndex].node
    local nodeParent = node:getParent()
    local pos = node:getPosition()
    effect:setPosition(ccp(pos.x + 475, pos.y + 140))
    effect:playByIndex(0, -1, -1, 0)
    --
    self.objList                        = self.objList or {}
    self.objList[prizeIndex]            = self.objList[prizeIndex] or {}
    self.objList[prizeIndex].effectNode = node

    self.objList[prizeIndex].timeId = TFDirector:addTimer(500, 1, function ()
                                                                    self:updateEffect(prizeIndex, bData, isShow)
                                                                  end, nil)
end
function IslandPrize:updateEffect(prizeIndex, bData, isShow)
    local obj = self.objList[prizeIndex]
    if (obj == nil) then
        return
    end
    TFDirector:removeTimer(obj.timeId)
    obj.timeId = nil
    obj.effectNode:setVisible(true)
    obj.effectNode = nil
    self.bCanClickCard = true
    
    local itemInfo = BaseDataManager:getReward(bData)
    local boxInfo = itemInfo
    if itemInfo.type == EnumDropType.ROLE then
        local role      = RoleData:objectByID(itemInfo.itemId)
        local headIcon  = role:getIconPath()
        self.ItemList[prizeIndex].img_goods:setTexture(headIcon)
    else
        self.ItemList[prizeIndex].img_goods:setTexture(itemInfo.path)
    end

    local path = GetColorIconByQuality(itemInfo.quality)
    
    if boxInfo.type == EnumDropType.GOODS then
        local itemDetail = ItemData:objectByID(itemInfo.itemId)
        if itemDetail ~= nil and itemDetail.type == EnumGameItemType.Piece then
            path =  GetBackgroundForFragmentByQuality(itemInfo.quality)
        else
            path =  GetColorIconByQuality(itemInfo.quality)
        end
    end

    local function cb()
        Public:ShowItemTipLayer(boxInfo.itemid, boxInfo.type)
    end

    self.ItemList[prizeIndex].img_goods:addMEListener(TFWIDGET_CLICK, audioClickfun(cb))

    self.ItemList[prizeIndex].txt_num:setText(string.format("%d", boxInfo.number))
    self.ItemList[prizeIndex].img_quality:setTexture(path)

    Public:addPieceImg(self.ItemList[prizeIndex].img_goods,{type = boxInfo.type, itemid = boxInfo.itemId or boxInfo.itemid})


    self.ItemList[prizeIndex].img_quality:setVisible(true)
    self.ItemList[prizeIndex].img_goods:setVisible(true)
    self.ItemList[prizeIndex].txt_num:setVisible(true)
    self:refreshUI()
    if (isShow == nil) then
        self:showPrizeResult(prizeIndex, bData)
    end
    self.objList[prizeIndex] = nil
end
function IslandPrize:showPrizeResult(index, bData)
    if self.timeResultId[index] == nil then
        self.timeResultId[index] = {}

        self.timeResultId[index].fun = function(delta)
            if self.timeResultId == nil then
                return
            end
            TFDirector:removeTimer(self.timeResultId[index].timeId);
            self.timeResultId[index] = nil
            local rewardInfo = BaseDataManager:getReward(bData)
            RewardManager:toastRewardMessage(rewardInfo)
        end
        local timeId = TFDirector:addTimer(1000, -1, nil, self.timeResultId[index].fun)
        self.timeResultId[index].timeId = timeId
    end
end


function IslandPrize.closeBtnClickHandle(sender)
    AlertManager:close(AlertManager.TWEEN_1);
end

--
function IslandPrize.buyAllItem(sender)
    local self = sender.logic
    if (self.showAwardList == nil) then
        return
    end
    local chapData = JapanTeamChapterData:objectByID(tonumber(self.boxIndex))
    if (chapData) then
        local costMoney = chapData.price * #self.showAwardList
        if (MainPlayer:getSycee() < costMoney) then
            toastMessage(localizable.factionMail_noSycee)
            return
        end
        sender:setTouchEnabled(false)
        sender:setGrayEnabled(true)
        self:buyVisible(false)
        self.isBuy = true

        JapanIslandManager:requestByAllItem()
    end
end

function IslandPrize:loadBoxData(chap, data)
    data = data or MEArray:new()
    self.boxIndex = chap

    self.boxData = {}
    for v in data:iterator() do
        table.insert( self.boxData, v )
    end
end

function IslandPrize:onShow()
    self.super.onShow(self)
    self:refreshUI();
end
function IslandPrize:buyVisible(show)
    if (self.isBuy) then
        return
    end
    self.img_price_bg:setVisible(show)
    self.txt_numb:setVisible(show)
end
function IslandPrize:refreshUI()
    if self.boxData == nil then
        return
    end
    if self.leftTimes <= 0 then
        self.btn_queding:setVisible(true)
        if not self.isShowBuy then
            self:showAward()
            self.isShowBuy = true
        end
        if (self.showAwardList) then
            local chapData = JapanTeamChapterData:objectByID(tonumber(self.boxIndex))
            if (chapData) then
                self.txt_numb:setText(chapData.price * #self.showAwardList)
            end
        end
        self.btn_getall:setVisible(true)
        self:buyVisible(true)
    else
        self.btn_queding:setVisible(false)
        self.btn_getall:setVisible(false)
        self:buyVisible(false)
    end
    self.txt_sy:setText( stringUtils.format( localizable.JapanIsland_txt_card_times, self.leftTimes ) )

    if self.firstShow then
        self.firstShow = false
        for i = 1, 4 do
            local img_goodsIcon = self.ItemList[i].img_goods
            local txt_num       = self.ItemList[i].txt_num
            local img_itemBg    = self.ItemList[i].img_quality
            local itemInfo      = self.boxData[i]
            local boxInfo       = itemInfo
            
            if boxInfo.type == EnumDropType.ROLE then
                local role      = RoleData:objectByID(itemInfo.itemid)
                local headIcon  = role:getIconPath()
                img_goodsIcon:setTexture(headIcon)
            else
                img_goodsIcon:setTexture(itemInfo.path)
            end

            local path = GetColorIconByQuality(itemInfo.quality)
           
            if boxInfo.type == EnumDropType.GOODS then
                local itemDetail = ItemData:objectByID(boxInfo.itemid)
                if itemDetail ~= nil and itemDetail.type == EnumGameItemType.Piece then
                    path =  GetBackgroundForFragmentByQuality(itemInfo.quality)
                else
                    path =  GetColorIconByQuality(itemInfo.quality)
                end
            end

            txt_num:setText(string.format("%d", boxInfo.number))
            img_itemBg:setTexture(path)
            
            Public:addPieceImg(img_goodsIcon,{type = boxInfo.type, itemid = boxInfo.itemid})

            img_goodsIcon:setVisible(false)
            img_itemBg:setVisible(false)
            txt_num:setVisible(false)
        end 
    end
end 


function IslandPrize:playEffect()
    if self.ChooseEffect == nil then
        local resPath = "effect/bloodfight1.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("bloodfight1_anim")

        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(self:getSize().width/2-7,self:getSize().height/2-1))

        self:addChild(effect, 2)

        effect:addMEListener(TFARMATURE_COMPLETE,function()
            local boxIndex = self.boxIndex
            if effect then
                effect:removeFromParent()
                effect = nil
            end

            for i = 1, 4 do
                self.ItemList[i].img_quality:setVisible(false)
                self.ItemList[i].img_goods:setVisible(false)
                self.ItemList[i].txt_num:setVisible(false)
                self.ItemList[i].node:setVisible(true)

                self.ItemList[i].node:removeMEListener(TFWIDGET_CLICK) 
                self.ItemList[i].node.index = i
                self.ItemList[i].node.logic = self
                self.ItemList[i].node:setTouchEnabled(true)
                self.ItemList[i].node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectBox))
            end

        end)

        self.ChooseEffect = effect
    end

    self.ChooseEffect:playByIndex(0, -1, -1, 0)
end

function IslandPrize:moveNode(node, pos)
    local function onCompleteCallback()
        self.count = self.count + 1

        if self.count == 4 then
            for i = 1, 4 do
                self.ItemList[i].node:setVisible(false)
            end

            self:playEffect()
            return
        end
    end

    local toastTween = {
        target = node,
        {
            duration = 0.4,
            x = pos.x,    -- x坐标
            y = pos.y,    -- y坐标
        },
        {
            duration = 0,
            delay = 1 / 60;
            onComplete = onCompleteCallback;
        }
    }

    TFDirector:toTween(toastTween);
end

function IslandPrize.onlickPrizeBtn(sender)
    local self = sender.logic

    self.count = 0
    self.initPos = {}
    for i = 1, 4 do
        self.initPos[i] = self.ItemList[i].node:getPosition()
        self.ItemList[i].node:setVisible(false)
    end

    self.prizeBtn:setVisible(false)

    self:playShuffleEffect()
end

function IslandPrize:playShuffleEffect()
    if self.shufEffect == nil then
        local resPath = "effect/ui/island_shuffle.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("island_shuffle_anim")

        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(self:getSize().width/2-2,self:getSize().height/2-7))

        self:addChild(effect, 2)

        effect:addMEListener(TFARMATURE_COMPLETE,function()
            if effect then
                effect:removeFromParent()
                effect = nil
            end
            
            for i = 1, 4 do
                self.ItemList[i].img_quality:setVisible(false)
                self.ItemList[i].img_goods:setVisible(false)
                self.ItemList[i].txt_num:setVisible(false)
                self.ItemList[i].node:setVisible(true)

                self.ItemList[i].node:removeMEListener(TFWIDGET_CLICK) 
                self.ItemList[i].node.index = i
                self.ItemList[i].node.logic = self
                self.ItemList[i].node:setTouchEnabled(true)
                self.ItemList[i].node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectBox))
            end
        end)

        self.shufEffect = effect
    end

    self.shufEffect:playByIndex(0, -1, -1, 0)
end


function IslandPrize.onlickPrize(sender)
    local prizeIndex = sender.index
    local self       = sender.logic
   
    local prizeData = self.boxData[prizeIndex]
    --print("prizeData ===>> ", prizeData)
    Public:ShowItemTipLayer(prizeData.itemid, prizeData.type)
end


function IslandPrize.onSelectBox(sender)
    local self = sender.logic
    local prizeIndex = sender.index

    if self.leftTimes <= 0 or self.getCardIdxList[prizeIndex] then
        toastMessage(localizable.common_data_error)
        return
    end
    -- toastMessage("dd")
    sender:setGrayEnabled(true)
    self.selectIdx = prizeIndex
    local self = sender.logic
    if self.bCanClickCard then
        self.bCanClickCard = false
        JapanIslandManager:requestLottery(0)

        --for test
        -- local event = {}
        -- event.data = {}
        -- event.data.obtain = {
        --     type = 1,
        --     itemId = 1,
        --     number = 2
        -- }
        -- JapanIslandManager:onLotteryResponse(event)
        
        else
            toastMessage(stringUtils.format(localizable.common_error_1, localizable.UILayer_tips_25))
            if (self.timeIdr) then
                TFDirector:removeTimer(self.timeIdr)
                self.timeIdr = nil
            end
            self.timeIdr = TFDirector:addTimer(6000, 1, function( )
                AlertManager:closeLayerByName("lua.logic.japanIsland.IslandPrize")
            end, nil)
        end

end

return IslandPrize