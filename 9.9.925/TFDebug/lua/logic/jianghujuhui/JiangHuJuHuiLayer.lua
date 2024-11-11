-- @Author: crb
-- @Date:   2018-04-08 15:44:21
-- @Last Modified by:   cc
-- @Last Modified time: 2018-04-10 14:38:09

local JiangHuJuHuiLayer = class("JiangHuJuHuiLayer", BaseLayer)

function JiangHuJuHuiLayer:ctor(  )
	self.super.ctor( self )

	self:init("lua.uiconfig_mango_new.operatingactivities.JiangHuJuHui")
end

function JiangHuJuHuiLayer:initUI( ui )
	self.super.initUI(self, ui)

	self.btn_close = TFDirector:getChildByPath(ui, "btn_close")

	self.scrollview_jhjh = TFDirector:getChildByPath(ui, "scrollview_jhjh")

	self.btn_zc_origin = TFDirector:getChildByPath(ui, "btn_zc")
	self.btn_yigoumai_origin = TFDirector:getChildByPath(ui, "btn_yigoumai")
	self.btn_weikaiqi_origin = TFDirector:getChildByPath(ui, "btn_weikaiqi")
	self.btn_zc_origin:setVisible(false)
	self.btn_yigoumai_origin:setVisible(false)
	self.btn_weikaiqi_origin:setVisible(false)

	self.panel_yihang_origin = TFDirector:getChildByPath(ui, "panel_yihang")
	self.panel_yihang_origin:setVisible(false)

	self.txt_time = TFDirector:getChildByPath(ui, "txt_time")

	self:showGoodsView()
end

function JiangHuJuHuiLayer:registerEvents(  )
	self.btn_close:addMEListener(TFWIDGET_CLICK, function (  )
		AlertManager:close()
	end)

	self.activityProcessUpdateCallBack = function (  )
		print("JiangHuJuHuiLayer:activityProcessUpdateCallBack....")
		self:showGoodsView()
	end
	TFDirector:addMEGlobalListener(OperationActivitiesManager.MSG_ACTIVITY_PROGRESS_UPDATE, self.activityProcessUpdateCallBack)
end

function JiangHuJuHuiLayer:removeEvents(  )
	TFDirector:removeMEGlobalListener(OperationActivitiesManager.MSG_ACTIVITY_PROGRESS_UPDATE, self.activityProcessUpdateCallBack)

	if self.nRemainingTimerID then
		TFDirector:removeTimer(self.nRemainingTimerID)
		self.nRemainingTimerID = nil
	end
end

function JiangHuJuHuiLayer:showGoodsView(  )
	self.scrollview_jhjh:removeAllChildren()

	local tActivityInfo = OperationActivitiesManager:getActivityInfoByType(OperationActivitiesManager.Type_JiangHuJuHui)
	local tProgress = tActivityInfo.progress

	local row, index, nCurProcess, nCurRow = 0, 0, 0, 0
	local btn_init, panel_yihang, panel_row
	for i,v in ipairs(tActivityInfo.activityReward.map) do
		row = math.floor( (i - 1) / 4 ) + 1
		index = (i - 1) % 4 + 1

		if tProgress[ row ] == 0 then
			nCurProcess = 0
		else
			nCurProcess = (tProgress[ row ] - 1) % 4 + 1
		end

		if nCurRow < row then
			panel_yihang = self.panel_yihang_origin:clone()
			panel_row = TFDirector:getChildByPath( panel_yihang, "panel_row" )

			panel_yihang:setVisible(true)
			self.scrollview_jhjh:addChild(panel_yihang)

			nCurRow = row
		end

		if index - 1 < nCurProcess then
			-- 已购买
			-- btn_init = self.btn_yigoumai_origin:clone()
			btn_init = self:createGoods(0, v)
		elseif index - 1 == nCurProcess then
			-- 当前购买
			-- btn_init = self.btn_zc_origin:clone()
			btn_init = self:createGoods(1, v)
			
		else
			-- 不能购买
			-- btn_init = self.btn_weikaiqi_origin:clone()
			btn_init = self:createGoods(2, v)
		end

		btn_init:setVisible(true)

		panel_row:addChild( btn_init )
	end

	self.scrollview_jhjh:setInnerContainerSize( CCSizeMake(766, 276 * row) )

	self:refreshTime(tActivityInfo.endTime)

	if self.nRemainingTimerID then
		TFDirector:removeTimer(self.nRemainingTimerID)
		self.nRemainingTimerID = nil
	end

	self.nRemainingTimerID = TFDirector:addTimer(1000, -1, nil, function (  )
		self:refreshTime(tActivityInfo.endTime)
	end)

end

function JiangHuJuHuiLayer:createGoods( btn_type, tGoodsInfo )
	local btn

	if btn_type == 0 then
		btn = self.btn_yigoumai_origin:clone()

	elseif btn_type == 1 then
		btn = self.btn_zc_origin:clone()

	elseif btn_type == 2 then
		btn = self.btn_weikaiqi_origin:clone()

	end

	local tRet = BaseDataManager:getReward(tGoodsInfo)

	local bg_icon           = TFDirector:getChildByPath(btn, "bg_icon")
	local img_icon          = TFDirector:getChildByPath(btn, "img_icon")
	local txt_num           = TFDirector:getChildByPath(btn, "txt_num")
	local txt_name          = TFDirector:getChildByPath(btn, "txt_name")
	local img_zhekou        = TFDirector:getChildByPath(btn, "img_zhekou")
	local txt_price         = TFDirector:getChildByPath(btn, "txt_price")
	local txt_price_yuanjia = TFDirector:getChildByPath(btn, "txt_price_yuanjia")

	bg_icon:setTextureNormal(GetColorIconByQuality(tRet.quality))
	txt_name:setText(tRet.name)
	txt_num:setText(tGoodsInfo.nCount)
	img_icon:setTexture(tRet.path)
	txt_price:setText(tGoodsInfo.nDiscount / 10 * tGoodsInfo.nPrice)
	txt_price_yuanjia:setText(tGoodsInfo.nPrice)

	local isPiece = Public:isPiece(tRet)
	if isPiece then
		bg_icon:setVisible(false)
	end

	Public:addPieceImg(img_icon, tRet, isPiece, 1)

	if tGoodsInfo.nDiscount > 9 then
		img_zhekou:setVisible(false)
	else
		img_zhekou:setTexture("ui_new/operatingactivities/z" .. tGoodsInfo.nDiscount .. ".png")
	end

	btn:addMEListener(TFWIDGET_CLICK, function (  )
		local layer = require('lua.logic.jianghujuhui.JiangHuJuHuiShopLayer'):new( tGoodsInfo, btn_type == 1 )
		AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
		AlertManager:show()

		-- OperationActivitiesManager:sendMsgToGetActivityReward(tActivityInfo.id, i, nil, nil, nil, v.nCount)
	end)

	return btn
end

function JiangHuJuHuiLayer:refreshTime( nEndTime )
	local nRemainingTime = nEndTime - GetCorrectTime()

	local d = math.floor( nRemainingTime / 3600 / 24 )
	local h = math.floor( nRemainingTime / 3600 ) - d * 24
	local m = math.floor( nRemainingTime % 3600 / 60 )
	local s = math.floor( nRemainingTime % 60 )

	local str = ""
	if d > 0 then
		str = str .. tostring(d) .. "天"
	end

	if d > 0 or h > 0 then
		str = str .. tostring(h) .. "小时"
	end

	if d > 0 or h > 0 or m > 0 then
		str = str .. tostring(m) .. "分"
	end


	self.txt_time:setText( str .. s .. "秒" )
end


return JiangHuJuHuiLayer
