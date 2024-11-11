--[[
******背包物品tableview的cell*******
]]

local GambleChoose = class("GambleChoose", BaseLayer)

function GambleChoose:ctor(data)
    self.super.ctor(self,data)
    self.id = 0
    self:init("lua.uiconfig_mango_new.qiyu.DushiChoose")
end

function GambleChoose:initUI(ui)
	self.super.initUI(self,ui)

	self.btn_close			= TFDirector:getChildByPath(ui, 'btn_close')
	self.txt_tips			= TFDirector:getChildByPath(ui, 'txt_tips')
	self.btn_cishu = {}
	for i=1,3 do
		self.btn_cishu[i] = TFDirector:getChildByPath(ui, 'btn_cishu'..i)
		local txt_lv = TFDirector:getChildByPath(self.btn_cishu[i], 'txt_lv')
		local oneKeyTime =  ConstantData:objectByID("GambleOneKeyTime"..i).value --GambleOneKeyTime1
		self.btn_cishu[i].oneKeyTime = oneKeyTime
		txt_lv:setText(oneKeyTime)
	end
end

function GambleChoose:removeUI()
	self.super.removeUI(self)

end

function GambleChoose:refreshUI()

end

function GambleChoose.iconBtnClickHandle(sender)
	local times = sender.oneKeyTime
	AlertManager:close();
	GambleManager:requestBatchBetAuto(times)
end


function GambleChoose:registerEvents()
	self.super.registerEvents(self)
	ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);
	for i=1,3 do
		self.btn_cishu[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.iconBtnClickHandle))
	end
end
function GambleChoose:removeEvents()
    self.super.removeEvents(self)
end

return GambleChoose
