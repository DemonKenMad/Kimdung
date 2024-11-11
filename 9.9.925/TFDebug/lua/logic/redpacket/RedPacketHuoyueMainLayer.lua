-- client side RedPacketMainLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2016-08-06

local RedPacketMainLayer = class("RedPacketMainLayer", BaseLayer)

function RedPacketMainLayer:ctor(data)
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.faction.FactionHyHongbao")
end

function RedPacketMainLayer:initUI(ui)
	self.super.initUI(self,ui)
    self.CardList = {}
    for i=1,2 do
        self.CardList[i] = {}
        local panel     = TFDirector:getChildByPath(ui, 'btn_card'..i)
        self.CardList[i].txt_zyz    = TFDirector:getChildByPath(panel, 'txt_zyz')
        self.CardList[i].img_huise  = TFDirector:getChildByPath(panel, 'img_huise')
        self.CardList[i].img_yff    = TFDirector:getChildByPath(panel, 'img_yff')
        self.CardList[i].btn        = panel
    end
    --策划要求说这个东西是固定的
    self.needNum = {120,250}
    self.RedPacketStatus = {}
    self.RedPacketStatus[1] = 0
    self.RedPacketStatus[2] = 0
    self.secondlyProgress = 0
    self.txt_jifenshu = TFDirector:getChildByPath(ui, 'txt_jifenshu')
    self.btn_help = TFDirector:getChildByPath(ui, 'btn_help')
    self.btn_close = TFDirector:getChildByPath(ui, 'Btn_Close')
end


function RedPacketMainLayer:removeUI()
    self.super.removeUI(self)
end

function RedPacketMainLayer:registerEvents()
    self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);
    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnRuleClick))
    self.btn_help.logic = self
    for i=1,2 do
        self.CardList[i].btn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnRedPacketClick))
        self.CardList[i].btn.idx = i
        self.CardList[i].btn.logic = self
    end
    
    -----------------------------------------------------------------------------------------
    self.onMyZhongYiInfoHandler = function(event)
        local data = event.data[1][1].data
        self.RedPacketStatus[1] = data.smallStatus
        self.RedPacketStatus[2] = data.bigStatus
        self.secondlyProgress = data.secondlyProgress
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(RedPacketManager.RECEIVE_MY_ACTIVITY_RED_PACKET_INFO ,self.onMyZhongYiInfoHandler)

    self.onMyRedPacketInfoHandler = function(event)
        local data = event.data[1][1].data
        self.RedPacketStatus[data.type] = data.sendStatus
        self:refreshUI()
    end
    self.onMyRedPacketOverHandler = function(event)
        toastMessage(localizable.RedPacket_over)
        local data = event.data[1][1].data
        self.RedPacketStatus[1] = data.smallStatus
        self.RedPacketStatus[2] = data.bigStatus
        self.secondlyProgress = data.secondlyProgress
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(RedPacketManager.SEND_GUILD_ACTIVE_RED_PACKET ,self.onMyRedPacketInfoHandler)
    TFDirector:addMEGlobalListener(RedPacketManager.RECEIVE_ACTIVE_RED_PACKET_OVER ,self.onMyRedPacketOverHandler)
end

function RedPacketMainLayer:removeEvents()
    TFDirector:removeMEGlobalListener(RedPacketManager.RECEIVE_MY_ACTIVITY_RED_PACKET_INFO ,self.onMyZhongYiInfoHandler)
    self.onMyZhongYiInfoHandler = nil
    TFDirector:removeMEGlobalListener(RedPacketManager.SEND_GUILD_ACTIVE_RED_PACKET ,self.onMyRedPacketInfoHandler)
    self.onMyRedPacketInfoHandler = nil
    TFDirector:removeMEGlobalListener(RedPacketManager.RECEIVE_ACTIVE_RED_PACKET_OVER ,self.onMyRedPacketOverHandler)
    self.onMyRedPacketOverHandler = nil
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
    local competence = FactionManager:getPersonalInfo().competence
    if competence ~= 2 and competence ~= 1 then
        toastMessage(localizable.RedPacket_quanxian)
        return
    end
    -- CommonManager:showOperateSureLayer(
    --         function()
    --             RedPacketManager:requestBuyRedPacket(idx)
    --         end,
    --         nil,
    --         {
    --             title = localizable.RedPacket_buy_tittle,
    --             msg = msg
    --         }
    -- )
    -- RedPacketManager:openSendLayer(idx,true)
    RedPacketManager:requestOpenSendActiveRedPacket(idx)
end

function RedPacketMainLayer.OnRuleClick( sender )
    CommonManager:showRuleLyaer('guildactiveredpacket')
end

function RedPacketMainLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function RedPacketMainLayer:refreshUI()
    self.txt_jifenshu:setText(localizable.RedPacket_daibi4 .. self.secondlyProgress)

    for i=1,2 do
        self.CardList[i].txt_zyz:setText(stringUtils.format( localizable.RedPacket_targetzhongyi, self.needNum[i] ) )
        self.CardList[i].img_yff:setVisible(false)
        if self.secondlyProgress >= self.needNum[i] then
            self.CardList[i].img_huise:setVisible(false)
            self.CardList[i].btn:setTouchEnabled(true)
        else
            self.CardList[i].img_huise:setVisible(true)
            self.CardList[i].btn:setTouchEnabled(false)
        end
        if self.RedPacketStatus[i] == 2 then
            self.CardList[i].btn:setTouchEnabled(false)
            self.CardList[i].img_huise:setVisible(true)
            self.CardList[i].img_yff:setVisible(true)
        end
    end
end

function RedPacketMainLayer:dispose()
    self.super.dispose(self)
end

return RedPacketMainLayer
