-- client side TianMingPanelLayer.lua
--[[
 * @Description: 天命物背景界面
 ]]
-- script writer fei
-- creation time 2017-03-02

local TianMingPanelLayer = class("TianMingPanelLayer", BaseLayer)

--Tab页个数
TianMingPanelLayer.kTabNumber = 2

--[[
	Tab按钮未按下的图片地址
]]
local tabNormalPaths = 
{
	"ui_new/tianming/tab_sj.png",
	"ui_new/tianming/tab_xx.png",
}
local tabPressedPaths1 = 
{
	"ui_new/tianming/tab_sj_h.png",
	"ui_new/tianming/tab_xx_h.png",
}
--
local layerDeclear = {
	"lua.logic.role_new.TianMingShengJiLayer",
	"lua.logic.role_new.TianMingXiangXingLayer",
}

function TianMingPanelLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.role_new.TianMingPanel")
    self.selectedIndex = 1
    self.oldTabIndex = 0
end

function TianMingPanelLayer:loadData(gmId, index)
    self.TianMingList 	= TianMingManager:getTianMingList()
    self.selectedIndex 	= index
    self.tianming 		= TianMingManager:getTianMingByGmId(gmId) 
end

function TianMingPanelLayer:initUI(ui)
	self.super.initUI(self,ui)
	--通用头部
    self.generalHead = CommonManager:addGeneralHead( self )
    self.generalHead:setData(ModuleType.TianMing,{HeadResType.JINGPO,HeadResType.COIN,HeadResType.SYCEE})

    --Tab按钮
    self.btn_tab = {}
	for i = 1, self.kTabNumber do
		local btn_tab = TFDirector:getChildByPath(ui, "tab_" .. i)
		if (btn_tab) then
			btn_tab.index 		= i
			btn_tab.logic 		= self
			btn_tab.redPoint 	= TFDirector:getChildByPath(btn_tab, "img_splats_" .. i)
			self.btn_tab[i] = btn_tab
		end
	end

	--内容图层
	self.panel_content  	= TFDirector:getChildByPath(ui, 'panel_content')
	self.panel_touch_event 	= TFDirector:getChildByPath(ui, 'panel_touch_event')
	self.panel_touch_event:setVisible(true)
	--设置为事件穿透
	self.panel_touch_event:setSwallowTouch(false)
	
	--切换界面按钮
	-- self.btn_left 		= TFDirector:getChildByPath(ui, 'btn_left')
	-- self.btn_right 		= TFDirector:getChildByPath(ui, 'btn_right')
	--层容器
	self.operationLayer = {}
end

function TianMingPanelLayer:onShow()
	self.super.onShow(self)
	if (self.generalHead) then
		self.generalHead:onShow()
	end
	self:selectedTabType(self.selectedIndex, true)

end

function TianMingPanelLayer:selectedTabType(selectedIndex, isUpdata)
	self.selectedIndex = selectedIndex
	--还原之前选中的按钮
	
	self:refreshBtnTab()
	if (self.tianming == nil) then
		print("**ERROR*********TianMingPanelLayer:selectedTabType***************")
		return
	end
	if self.btn_tab[TianMingManager.select_type_2] then
		if TianMingManager:isOpenTianMingStar() == false or self.tianming.quality < 4 then 
			self.btn_tab[TianMingManager.select_type_2]:setVisible(false)
		else 
			self.btn_tab[TianMingManager.select_type_2]:setVisible(true)
		end
	end
	-- self:refreshLeftRightBtn()
	--
	local layer = self.operationLayer[selectedIndex]
	if (layer) then
		layer:setVisible(true)
		layer:setTianMingData(self.tianming.instanceId)
		layer:onShow()
	else
		local layerName = layerDeclear[selectedIndex]
		if (layerName == nil) then
			print("**ERROR********TianMingPanelLayer:selectedTabType************",selectedIndex)
			return
		end
		local newLayer = require(layerName):new()
		newLayer:setPosition(ccp(newLayer:getPositionX() - 110, newLayer:getPositionY() - 10))
		self.operationLayer[selectedIndex] = newLayer
		self.panel_content:addChild(newLayer)
		newLayer:setTianMingData(self.tianming.instanceId)
		newLayer:onShow()
	end
	--
	if (self.oldTabIndex == self.selectedIndex) then
		return
	end
	--if (self.oldTabIndex ~= 0 and self.oldTabIndex ~= self.selectedIndex) then
		local oldLayer = self.operationLayer[self.oldTabIndex]
		if (oldLayer) then
			oldLayer:setVisible(false)
		end
	--end
	self.oldTabIndex = self.selectedIndex
end
--
-- function TianMingPanelLayer:refreshLeftRightBtn()
--     local pageCount = self.eudemonList:length()
--     local pageIndex =  self.pageIndex
--     if (pageCount > 1) then
--         self.btn_left:setVisible(pageIndex > 1)
--         self.btn_right:setVisible(pageIndex < pageCount)
--     else
--         self.btn_left:setVisible(false)
--         self.btn_right:setVisible(false)
--     end
-- end
function TianMingPanelLayer:refreshBtnTab()
	if (self.oldTabIndex == self.selectedIndex) then
		return
	end
	
	local btn_tab = self.btn_tab[self.selectedIndex]
	if btn_tab then
		btn_tab:setTextureNormal(tabPressedPaths1[self.selectedIndex])
		btn_tab:setTouchEnabled(false)
	end

	local old_btn_tab = self.btn_tab[self.oldTabIndex]
	if (old_btn_tab) then
		old_btn_tab:setTextureNormal(tabNormalPaths[self.oldTabIndex])
		old_btn_tab:setTouchEnabled(true)
	end
end
function TianMingPanelLayer:removeUI()
	self.super.removeUI(self)
end

--销毁方法
function TianMingPanelLayer:dispose()
	for i = 1,#layerDeclear do
		if self.operationLayer[i] then
			self.operationLayer[i]:dispose()
		end
	end

	if self.generalHead then
		self.generalHead:dispose()
		self.generalHead = nil
	end

    self.super.dispose(self)
end

--顶部按钮点击事件
function TianMingPanelLayer.tabButtonClickHandle(sender)
	local self = sender.logic

	self:selectedTabType(sender.index)
end

function TianMingPanelLayer:registerEvents()
	self.super.registerEvents(self)
	for k,btn in pairs(self.btn_tab) do
	    btn:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.tabButtonClickHandle),1)
	end
	-- self.btn_left.logic 	= self
	-- self.btn_right.logic 	= self
	-- self.btn_right.isRight 	= true
	-- self.btn_left:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMoveClickHandle),1)
	-- self.btn_right:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMoveClickHandle),1)
	-- self.receiveInfo1 = function(event)
 --    	self:refreshBtnTab()
 --    end
 --    TFDirector:addMEGlobalListener(EudemonManager.upStarTupo, self.receiveInfo1)
	
end

function TianMingPanelLayer:removeEvents()
	self.super.removeEvents(self)
 	if self.selectedIndex and self.operationLayer[self.selectedIndex] then
    	self.operationLayer[self.selectedIndex]:removeEvents()
	end
end

return TianMingPanelLayer;