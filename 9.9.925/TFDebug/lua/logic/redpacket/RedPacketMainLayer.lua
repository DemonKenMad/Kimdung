-- client side RedPacketMainLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2016-08-06

local RedPacketMainLayer = class("RedPacketMainLayer", BaseLayer)

function RedPacketMainLayer:ctor(data)
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.faction.FactionhbMain")
end

function RedPacketMainLayer:initUI(ui)
	self.super.initUI(self,ui)
    self.CardList = {}
    for i=1,3 do
        self.CardList[i] = {}
        local panel = TFDirector:getChildByPath(ui, 'btn_card'..i)
        self.CardList[i].btn     = panel
        self.CardList[i].txt_havenum = TFDirector:getChildByPath(panel, 'txt_havenum')
        self.CardList[i].txt_buynum = TFDirector:getChildByPath(panel, 'txt_buynum')
    end
    self.txt_jifenshu = TFDirector:getChildByPath(ui, 'txt_jifenshu')
    self.btn_help = TFDirector:getChildByPath(ui, 'btn_help')
    self.btn_close = TFDirector:getChildByPath(ui, 'Btn_Close')
    self.btn_tuhaobang = TFDirector:getChildByPath(ui, 'btn_tuhaobang')
    self.btn_chengjiu = TFDirector:getChildByPath(ui, 'btn_chengjiu')
end


function RedPacketMainLayer:removeUI()
    self.super.removeUI(self)
end

function RedPacketMainLayer:registerEvents()
    self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);
    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnRuleClick))
    self.btn_help.logic = self
    for i=1,3 do
        self.CardList[i].btn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnRedPacketClick))
        self.CardList[i].btn.idx = i
        self.CardList[i].btn.logic = self
    end
    self.btn_tuhaobang:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnRankClick))
    self.btn_tuhaobang.logic = self
    self.btn_chengjiu:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnAchievementClick))
    self.btn_chengjiu.logic = self
    
    -----------------------------------------------------------------------------------------
    self.onMyRedPacketInfoHandler = function(event)
        self:refreshUI()
    end;
    TFDirector:addMEGlobalListener(RedPacketManager.RECEIVE_MY_RED_PACKET_INFO ,self.onMyRedPacketInfoHandler)
end

function RedPacketMainLayer:removeEvents()
    TFDirector:removeMEGlobalListener(RedPacketManager.RECEIVE_MY_RED_PACKET_INFO ,self.onMyRedPacketInfoHandler)
    
    self.super.removeEvents(self)
end
--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--------
function RedPacketMainLayer.OnRedPacketClick( sender )
    local self = sender.logic
    local idx = sender.idx
    local factionInfo = FactionManager:getFactionInfo()
    local memberNum = 0
    if factionInfo then
        memberNum = factionInfo.memberCount
        if factionInfo.state == 2 then
            toastMessage(localizable.RedPacket_main_txt4)
            return
        end
    else
        toastMessage(localizable.RedPacket_main_txt3)
        return
    end
    local minNum = ConstantData:objectByID('RedpacketMinNum').value
    if memberNum < minNum then
        toastMessage(stringUtils.format(localizable.RedPacket_send_txt1,minNum))
        return
    end

    local holdNum = RedPacketManager:getRedPacketNumByType(idx)
    if holdNum <= 0 then
        local holdCy = RedPacketManager:getCurrenCy()
        local item = RedPacketData:objectByID(idx)
        if nil == item then
            return
        end
        local price = item:getPrice()
        local itemConfig =  BaseDataManager:getReward(price)
        if holdCy < itemConfig.number then
            toastMessage(localizable.RedPacket_daibi3)
            return
        end
        local str = stringUtils.format(localizable.RedPacket_daibi1,itemConfig.number)
        local itemId = RedPacketManager:getItemIdByType(idx)
        local rpItem = ItemData:objectByID(itemId)
        local msg = stringUtils.format(localizable.RedPacket_buy_msg,str,rpItem.name);
        CommonManager:showOperateSureLayer(
                function()
                    RedPacketManager:requestBuyRedPacket(idx)
                end,
                nil,
                {
                    title = localizable.RedPacket_buy_tittle,
                    msg = msg
                }
        )
        return
    end
    RedPacketManager:openSendLayer(idx)
end

function RedPacketMainLayer.OnRuleClick( sender )
    CommonManager:showRuleLyaer('redpacket')
end

function RedPacketMainLayer.OnRankClick( sender )
    RedPacketManager:requestGetRankInfo(10,true)
end

function RedPacketMainLayer.OnAchievementClick( sender )
    RedPacketManager:openAchievementLayer()
end
--------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>--------
function RedPacketMainLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function RedPacketMainLayer:refreshUI()
    local num = RedPacketManager:getCurrenCy()
    self.txt_jifenshu:setText(localizable.RedPacket_daibi2 .. num)
    for i=1,3 do
        local haveNum = RedPacketManager:getRedPacketNumByType(i)
        local str = stringUtils.format( localizable.RedPacket_main_txt1, haveNum ) 
        self.CardList[i].txt_havenum:setText(str)
        local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType['RED_PACKET_BUY_TIMES_' .. i])
        local times = challengeInfo:getLeftChallengeTimes() or 0
        local str = stringUtils.format( localizable.RedPacket_main_txt2, times ) 
        self.CardList[i].txt_buynum:setText(str)
    end
end

function RedPacketMainLayer:dispose()
    self.super.dispose(self)
end

return RedPacketMainLayer
