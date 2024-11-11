--[[
******帮派丹房材料选择界面*******

	-- by sjj
	-- 2018/4/26
	
]]

local FactionDanFangSelectLayer = class("FactionDanFangSelectLayer",BaseLayer)
local column = 4

function FactionDanFangSelectLayer:ctor(data)

	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.faction.DanFangSelect")
end


function FactionDanFangSelectLayer:initUI( ui )
	self.super.initUI(self, ui)
	self.ui:runAnimation("Action0",1)
	-- self:setZOrder(1);
	self.btn_lianHua = TFDirector:getChildByPath(ui, "btn_shouqu")
	self.btn_shousuo = TFDirector:getChildByPath(ui, "btn_shousuo")
	self.btn_close = TFDirector:getChildByPath(ui, "btn_return")

	self.panel_list = TFDirector:getChildByPath(ui, "panel_cardregional")

	self.scrollView_list = TFDirector:getChildByPath(ui, "ScrollView_DanFangSelect_1")

	self.myMaterialData = FactionDanFangManager:getMyMaterialData()


	self.scrollView_list:setInnerContainerSize(CCSizeMake(self.scrollView_list:getSize().width, 5 + 130 * math.ceil(#self.myMaterialData / 4)))
	
	self.allItemIcon = {}
	self:setScrollView()

	if (#self.myMaterialData > 0) then
		self.btn_lianHua:setVisible(true)
	else
		self.btn_lianHua:setVisible(false)
	end
end
-- function FactionDanFangSelectLayer:onShow( )
-- 	self.super.onShow(self)
-- 	self.ui:runAnimation("Action0",1)
-- end
function FactionDanFangSelectLayer:setParentLayer( layer, idx )
	self.parentLayer = layer
	self.selectId = idx
	self:refreshSelectStatu()
end
function FactionDanFangSelectLayer:removeUI()
    self.super.removeUI(self)
end

function FactionDanFangSelectLayer:registerEvents()
	self.super.registerEvents(self)
	-- ADD_ALERT_CLOSE_LISTENER(self,self.btn_close,AlertManager.TWEEN_NONE)
	self.btn_lianHua:addMEListener(TFWIDGET_CLICK,  audioClickfunWithDelegate(self, self.lianHuaButtonClickHandle),1);
	self.btn_close:addMEListener(TFWIDGET_CLICK,  audioClickfunWithDelegate(self, self.onCloseButtonClickHandle),1);
	self.btn_shousuo:addMEListener(TFWIDGET_CLICK,  audioClickfunWithDelegate(self, self.onCloseButtonClickHandle),1);
end
function FactionDanFangSelectLayer:removeEvents()
	self.super.removeEvents(self)
end

--关闭按钮回调
function FactionDanFangSelectLayer:shouSuoButtonClickHandle( sender )
	-- local self = sender.logic
	self.ui:setAnimationCallBack("Action1", TFANIMATION_END, function()
        AlertManager:closeLayer(self)
    end)
    self.ui:runAnimation("Action1",1);
end

--炼化按钮回调
function FactionDanFangSelectLayer:lianHuaButtonClickHandle( sender )
	local levelUpInfo = self.myMaterialData[self.selectId]
	if (not self.selectId == nil or not levelUpInfo) then
		toastMessage(localizable.smithy_EquipmentStarUp_check)
		return
	end
	local caiLiaoInfo = BaseDataManager:getReward({type = EnumDropType.GOODS, itemId = levelUpInfo.itemId})

	local heigItemInfo = BaseDataManager:getReward({type = EnumDropType.GOODS, itemId = levelUpInfo.upId})

	local str = stringUtils.format(localizable.DanFang_tips,caiLiaoInfo.name, levelUpInfo.needNum, heigItemInfo.name, levelUpInfo.needNum)
	CommonManager:showOperateSureLayer(
		function()
			FactionDanFangManager:sendMaterialUp( levelUpInfo.id )
			self.ui:setAnimationCallBack("Action1", TFANIMATION_END, function()
		        AlertManager:closeLayer(self)
		    end)
			self.ui:runAnimation("Action1",1);
    	end,
    	nil,
    	{
			msg = str,
    	})

end
-- function FactionDanFangSelectLayer:refreshTableView()
-- 	if (self.myMaterialData) then
-- 		if self.tableView == nil then
-- 	        local tableView =  TFTableView:create()
-- 	        tableView:setTableViewSize(self.panel_list:getContentSize())
-- 	        tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
-- 	        tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
-- 	        tableView:setPosition(ccp(0, 0))
-- 	        self.tableView = tableView
-- 	        -- self.tableView.logic = self

-- 	        -- tableView:addMEListener(TFTABLEVIEW_TOUCHED, NewSignLayer.tableCellTouched)
-- 	        -- tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, handler(self.cellSizeForTable,self))
-- 	        -- tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, handler(self.tableCellAtIndex,self))
-- 	        -- tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW,handler(self.numberOfCellsInTableView,self))
-- 	        tableView:reloadData()
-- 	        self.panel_list:addChild(self.tableView,1)
--     	end
--     	self.tableView:reloadData()
-- 	end
    
-- end
-- function FactionDanFangSelectLayer:cellSizeForTable(table, idx)
-- 	return 130,545
-- end

-- function FactionDanFangSelectLayer:tableCellAtIndex(table, idx)
-- 	idx = idx + 1
-- 	local cell = table:dequeueCell()
	
-- 	if nil == cell then
-- 		cell = TFTableViewCell:create()
-- 	end
-- 	self:setCell(cell, idx)
-- 	return cell
-- end

-- function FactionDanFangSelectLayer:numberOfCellsInTableView(table)
-- 	local num = 0
-- 	if self.myMaterialData ~= nil then
-- 		num = #self.myMaterialData
-- 	end
-- 	return math.ceil(num/column)--
-- end

-- function FactionDanFangSelectLayer:setCell(cell, idx)
-- 	for i=1,column do 
-- 		local materialID = (idx - 1) * column + i
-- 		local panel = cell:getChildByTag(materialID)	

-- 		local itemInfo = self.myMaterialData[materialID]
-- 		print("setCell",materialID,itemInfo)
-- 		if (itemInfo) then
-- 			if (panel == nil) then
-- 				panel = createUIByLuaNew("lua.uiconfig_mango_new.faction.DanFangCell")
-- 				local size = panel:getSize()
-- 				panel:setAnchorPoint(ccp(0,0))
-- 				panel:setScale(0.95)
-- 				panel:setPosition(ccp(18+(i - 1) * size.width * 0.85,-5))
-- 				self.allItemIcon[materialID] = panel
-- 				self.allItemIcon[materialID].img_selected_fg = TFDirector:getChildByPath(panel, 'img_selected_fg')
-- 				cell:addChild(panel,1,materialID)
-- 			end
-- 			panel:setVisible(true)
-- 			local btn_iconbg = TFDirector:getChildByPath(panel, 'btn_icon')
-- 			btn_iconbg:setTouchEnabled(true)
-- 			btn_iconbg.materialID = materialID
-- 			btn_iconbg.logic = self
-- 			local img_icon = TFDirector:getChildByPath(panel, 'img_icon')
-- 			local txt_iconnumber = TFDirector:getChildByPath(panel, 'txt_number')
-- 			local txt_iconnumber2 = TFDirector:getChildByPath(panel, 'txt_number2')

-- 			if (self.selectId == materialID) then
-- 				self.allItemIcon[materialID].img_selected_fg:setVisible(true)
-- 			else
-- 				self.allItemIcon[materialID].img_selected_fg:setVisible(false)
-- 			end

-- 			local iconInfo = BaseDataManager:getReward({type = EnumDropType.GOODS, itemId = itemInfo.itemId})
-- 			img_icon:setTexture(iconInfo.path)
-- 			btn_iconbg:setTextureNormal(GetColorIconByQuality(iconInfo.quality))

			
-- 			txt_iconnumber:setText("/"..itemInfo.needNum)
-- 			txt_iconnumber2:setText(itemInfo.hasNum)
-- 			txt_iconnumber2:setPositionX(txt_iconnumber:getPositionX() - txt_iconnumber:getContentSize().width)
-- 			if (itemInfo.isCanUp) then
-- 				txt_iconnumber2:setColor(ccc3(255,255,255))
-- 			else
-- 				txt_iconnumber2:setColor(ccc3(255,0,0))
-- 			end

-- 			btn_iconbg:addMEListener(TFWIDGET_CLICK, audioClickfunWithDelegate(self, self.onButtonClickHandle),1)
-- 		end

-- 	end

-- end


function FactionDanFangSelectLayer:setScrollView()
	for k,item in ipairs(self.myMaterialData) do
		local panel = createUIByLuaNew("lua.uiconfig_mango_new.faction.DanFangCell")
		local size = panel:getSize()
		panel:setAnchorPoint(ccp(0,0))
		panel:setScale(0.95)
		panel:setTag(item.id)
		local img_selected_fg = TFDirector:getChildByPath(panel, 'img_selected_fg')
		img_selected_fg:setVisible(false)

		local btn_iconbg = TFDirector:getChildByPath(panel, 'btn_icon')
		btn_iconbg:setTouchEnabled(true)
		btn_iconbg.materialID = k
		-- btn_iconbg.logic = self
		local img_icon = TFDirector:getChildByPath(panel, 'img_icon')
		local txt_iconnumber = TFDirector:getChildByPath(panel, 'txt_number')
		local txt_iconnumber2 = TFDirector:getChildByPath(panel, 'txt_number2')

		local iconInfo = BaseDataManager:getReward({type = EnumDropType.GOODS, itemId = item.itemId})
		img_icon:setTexture(iconInfo.path)
		btn_iconbg:setTextureNormal(GetColorIconByQuality(iconInfo.quality))

		
		txt_iconnumber:setText("/"..item.needNum)
		txt_iconnumber2:setText(item.hasNum)
		txt_iconnumber2:setPositionX(txt_iconnumber:getPositionX() - txt_iconnumber:getContentSize().width)
		if (item.isCanUp) then
			txt_iconnumber2:setColor(ccc3(255,255,255))
		else
			txt_iconnumber2:setColor(ccc3(255,0,0))
		end

		btn_iconbg:addMEListener(TFWIDGET_CLICK, audioClickfunWithDelegate(self, self.onButtonClickHandle),1)


		self.scrollView_list:addChild(panel)

	end
end

function FactionDanFangSelectLayer:onButtonClickHandle(sender)
	local materialID = sender.materialID
	-- local layer = AlertManager:getLayerFromCacheByName("lua.logic.faction.FactionDanFangLayer")

    self.parentLayer:setMaterialLevelUpInfo( materialID )
    local itemInfo = self.myMaterialData[materialID]
    self.btn_lianHua:setTouchEnabled(itemInfo.isCanUp)
    self.btn_lianHua:setGrayEnabled(not itemInfo.isCanUp)
    self.selectId = materialID
    self:refreshSelectStatu()
end
function FactionDanFangSelectLayer:refreshSelectStatu()
	for idx, selectIcon in ipairs(self.myMaterialData) do
		local panel = self.scrollView_list:getChildByTag(selectIcon.id)
		local img_selected_fg = TFDirector:getChildByPath(panel, 'img_selected_fg')
		if (idx == self.selectId) then
			img_selected_fg:setVisible(true)
		else
			img_selected_fg:setVisible(false)
		end
	end
end

function FactionDanFangSelectLayer:onCloseButtonClickHandle()
	self.ui:setAnimationCallBack("Action1", TFANIMATION_END, function()
        AlertManager:closeLayer(self)
    end)
    self.ui:runAnimation("Action1",1);
end

return FactionDanFangSelectLayer