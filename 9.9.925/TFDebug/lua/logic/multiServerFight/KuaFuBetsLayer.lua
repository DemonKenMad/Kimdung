--[[
******跨服个人战-淘汰赛*******

	-- by quanhuan
	-- 2016/2/22
	
]]

local KuaFuBetsLayer = class("KuaFuBetsLayer",BaseLayer)


function KuaFuBetsLayer:ctor(data)

	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.kuafuwulin.KuaFuBets")
end

function KuaFuBetsLayer:initUI( ui )

	self.super.initUI(self, ui)

    self.panelData = {}
    for i=1,2 do
        self.panelData[i] = {}
        local panelNode = TFDirector:getChildByPath(ui, 'img_kuang'..i)

        self.panelData[i].panel_reward1 = TFDirector:getChildByPath(panelNode, 'panel_reward1')
        local img_quality1 = TFDirector:getChildByPath(self.panelData[i].panel_reward1, "img_quality")
        img_quality1:setVisible(false)
        local txt_num1 = TFDirector:getChildByPath(self.panelData[i].panel_reward1, "txt_num")
        txt_num1:setVisible(false)

        self.panelData[i].panel_reward2 = TFDirector:getChildByPath(panelNode, 'panel_reward2')
        local img_quality2 = TFDirector:getChildByPath(self.panelData[i].panel_reward2, "img_quality")
        img_quality2:setVisible(false)
        local txt_num2 = TFDirector:getChildByPath(self.panelData[i].panel_reward2, "txt_num")
        txt_num2:setVisible(false)

        self.panelData[i].btnYazhu = TFDirector:getChildByPath(panelNode, 'Btn_buy')
        self.panelData[i].txt_price = TFDirector:getChildByPath(panelNode, 'txt_price')        
    end
    self.panel_di2          = TFDirector:getChildByPath(ui, 'panel_di2')
    self.img_hongdi2        = TFDirector:getChildByPath(ui, 'img_hongdi2')
    self.txt_1              = TFDirector:getChildByPath(ui, 'txt_1')
    self.txt_2              = TFDirector:getChildByPath(ui, 'txt_2')
    self.txt_sl1            = TFDirector:getChildByPath(ui, 'txt_sl1')
    self.txt_sl2            = TFDirector:getChildByPath(ui, 'txt_sl2')
    self.panel_bs = {}
    for i = 1,2 do 
        local panel_bs          = TFDirector:getChildByPath(ui, 'panel_bs'..i)
        panel_bs.txt_sl         = TFDirector:getChildByPath(panel_bs, 'txt_sl')
        panel_bs.logic = self
        self.panel_bs[i]        = panel_bs
    end
end

function KuaFuBetsLayer:removeUI()
	self.super.removeUI(self)
end

function KuaFuBetsLayer:onShow()
    self.super.onShow(self)

    for i=1,2 do
        self.panelData[i].txt_price:setText(self.rewardData[i].price)
        if self.panelData[i].panel_reward1.node1 == nil then
            local node1 = Public:createIconNumNode(reward)
            node1:setScale(0.65)
            node1:setPosition(ccp(0, 0))
            self.panelData[i].panel_reward1:addChild(node1)
            self.panelData[i].panel_reward1.node1 = node1
            local rewardItem = self.rewardData[i].rewardList:getObjectAt(1)
            Public:loadIconNode(node1,rewardItem)
        end
        if self.panelData[i].panel_reward2.node2 == nil then
            local node2 = Public:createIconNumNode(reward)
            node2:setScale(0.65)
            node2:setPosition(ccp(0, 0))
            self.panelData[i].panel_reward2:addChild(node2)
            self.panelData[i].panel_reward2.node2 = node2
            local rewardItem = self.rewardData[i].rewardList:getObjectAt(2)
            Public:loadIconNode(node2,rewardItem)
        end
    end
    if self.BetRate then
        self.txt_sl1:setText(self.BetRate / 100 .."%")
        if self.BetRate >= 4000 then
            self.txt_sl2:setText("100%")
            for i = 1,2 do
                self.panel_bs[i].txt_sl:setText(1)
            end 
        else
            self.txt_sl2:setText("150%")
            for i = 1,2 do
                self.panel_bs[i].txt_sl:setText(1.5)
            end 
        end
    end
end

function KuaFuBetsLayer:registerEvents()

    if self.registerEventCallFlag then
        return
    end
	self.super.registerEvents(self)

    for i=1,2 do
        self.panelData[i].btnYazhu:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnYazhuClick))
        self.panelData[i].btnYazhu.logic = self
        self.panelData[i].btnYazhu.coin = i
    end

    self.registerEventCallFlag = true 
end

function KuaFuBetsLayer:removeEvents()

    self.super.removeEvents(self)

	if self.generalHead then
        self.generalHead:removeEvents()
    end	

    for i=1,2 do
        self.panelData[i].btnYazhu:removeMEListener(TFWIDGET_CLICK)
    end

    self.registerEventCallFlag = nil  
end

function KuaFuBetsLayer:dispose()
	self.super.dispose(self)
end

function KuaFuBetsLayer:setData(playerId, round,index,betRate)
    self.BetRate = betRate
    self.playerId = playerId
    self.round = round
    self.index = index
    self.rewardData = {}
    self.rewardData[1] = {}
    local rewardId = ConstantData:objectByID("Personal.Battle.Bet.Reward").value
    self.rewardData[1].rewardList = RewardConfigureData:GetRewardItemListById(rewardId)
    self.rewardData[1].price = ConstantData:objectByID("Personal.Battle.Bet.Coins").value
    self.rewardData[2] = {}
    rewardId = ConstantData:objectByID("Personal.Battle.Bet.BigReward").value
    self.rewardData[2].rewardList = RewardConfigureData:GetRewardItemListById(rewardId)
    self.rewardData[2].price = ConstantData:objectByID("Personal.Battle.Bet.Gold").value
end

function KuaFuBetsLayer.onBtnYazhuClick( btn )
    local self = btn.logic
    local priceType = btn.coin
    local number = self.rewardData[priceType].price or 0
    if priceType == 1 then
        if number > MainPlayer:getCoin() then
            toastMessage(localizable.multiFight_bet_coin)
            return
        end
    else
        if number > MainPlayer:getSycee() then
            toastMessage(localizable.multiFight_bet_sycee)
            return
        end
    end
    MultiServerFightManager:requestCrossBet(self.round, self.index, btn.coin, self.playerId)
end
return KuaFuBetsLayer