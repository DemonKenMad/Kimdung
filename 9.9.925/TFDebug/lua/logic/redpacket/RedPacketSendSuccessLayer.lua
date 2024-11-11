-- client side RedPacketSendSuccessLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2016-08-06


local RedPacketSendSuccessLayer = class("RedPacketSendSuccessLayer", BaseLayer)

CREATE_PANEL_FUN(RedPacketSendSuccessLayer)


function RedPacketSendSuccessLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.faction.Factionfahbsuccess")
end

function RedPacketSendSuccessLayer:initUI(ui)
	self.super.initUI(self,ui)

	--操作按钮
	self.btn_queren				= TFDirector:getChildByPath(ui, 'btn_queren')
	self.txt_time				= TFDirector:getChildByPath(ui, 'txt_time')
	self.firstShow = true
end

function RedPacketSendSuccessLayer:setInfo( gmid )
	self.gmid = gmid
end

function RedPacketSendSuccessLayer:removeUI()
	self.super.removeUI(self)
end


function RedPacketSendSuccessLayer:onShow()
	self.super.onShow(self)
    self:refreshUI();
	if self.firstShow == true then
        self.ui:runAnimation("Action0", 1);
        local resPath = "effect/role_starup1.xml"
	    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
	    effect = TFArmature:create("role_starup1_anim")
	  
	    effect:setAnimationFps(GameConfig.ANIM_FPS)
	    effect:setPosition(ccp(self:getSize().width/2,self:getSize().height/2))
	    self:addChild(effect,2)
	    effect:playByIndex(0, -1, -1, 0)
        self.firstShow = false
    end
end

function RedPacketSendSuccessLayer:refreshUI()
	local redPacket = RedPacketManager:getRedPacketByGmId( self.gmid )
	if redPacket == nil then
		AlertManager:close()
	end
	local value = ConstantData:objectByID('RedpacketLastTime').value
	if redPacket.type == 1 then
        value = ConstantData:objectByID('ActivityRedpacketLastTime').value
    end
	local time = redPacket.startTime * 0.001 + value
	local tTime = GetCorrectDate('*t',time)
	local str = stringUtils.format( localizable.common_time_8_ex, tTime.month , tTime.day ) 
	str = str .. string.format("%d:%02d:%02d",tTime.hour ,tTime.min ,tTime.sec)
	self.txt_time:setText(str)
end

function RedPacketSendSuccessLayer:registerEvents()
	self.super.registerEvents(self)
	self.btn_queren:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnCloseClickHandle),1)
end

function RedPacketSendSuccessLayer.OnCloseClickHandle( sender )
	AlertManager:close()
end

function RedPacketSendSuccessLayer:removeEvents()
    self.super.removeEvents(self)
end

return RedPacketSendSuccessLayer;
