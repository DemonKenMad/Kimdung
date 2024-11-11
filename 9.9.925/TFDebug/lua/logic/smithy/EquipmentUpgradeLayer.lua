-- client side EquipmentUpgradeLayer.lua
--[[
 * @Description: 装备升阶
 ]]
-- script writer Happy.All
-- creation time 2016-07-08


local EquipmentUpgradeLayer = class("EquipmentUpgradeLayer", BaseLayer)

local TotalAttrCount = 2
local CellH = 80
local MaxBreachLevel = 10
function EquipmentUpgradeLayer:ctor(gmId)
    self.super.ctor(self,data)
    self.gmId = gmId
    
    self:init("lua.uiconfig_mango_new.smithy.EquipmentUpgrade")
end

function EquipmentUpgradeLayer:initUI(ui)
	self.super.initUI(self,ui)
	--左侧详情
	self.scroll_left			= TFDirector:getChildByPath(ui, 'scroll_left')
	self.info_panel				= require('lua.logic.smithy.EquipInfoPanel'):new(self.gmId)
	self.scroll_left:addChild(self.info_panel)

	self.btn_help = TFDirector:getChildByPath(ui, "btn_help")

	--右侧信息
	self.scroll_right			= TFDirector:getChildByPath(ui, 'scroll_right')
	self.scroll_right:setVisible(false)
	self.img_notice = TFDirector:getChildByPath(ui, 'img_notice')
	self.img_notice:setVisible(false)
	--总属性
	self.totalAttr = {}
	for i=1,TotalAttrCount do 
		self.totalAttr[i] = TFDirector:getChildByPath(self.scroll_right, 'txt_shuxing'..i)
	end
	--升阶效果
	self.currUpGradeEffect = TFDirector:getChildByPath(self.scroll_right, 'txt_benjiexiaoguo')
	self.nextUpGradeEffect = TFDirector:getChildByPath(self.scroll_right, 'txt_xiajiexiaoguo')
	self.limitUpGrade = TFDirector:getChildByPath(self.scroll_right, 'txt_shuoming')

	--当前升阶等级
	self.txt_shengjielevel = TFDirector:getChildByPath(self.scroll_right, 'txt_shengjielevel')
	--附魔进度条
	self.bar_jindu = TFDirector:getChildByPath(self.scroll_right, 'bar_jindu')
	self.bar_jindu:setDirection(TFLOADINGBAR_LEFT)
	self.txt_shuzhi = TFDirector:getChildByPath(self.scroll_right, 'txt_shuzhi')
	self.img_nextlevel = TFDirector:getChildByPath(self.scroll_right, 'img_nextlevel')
	self.img_max = TFDirector:getChildByPath(self.scroll_right, 'img_max')
	self.img_yimanji = TFDirector:getChildByPath(self.scroll_right, 'img_yimanji')
	--一键附魔按钮
	self.btnLevelUp = TFDirector:getChildByPath(self.scroll_right, 'btn_refining')
	self.btnUpGrade = TFDirector:getChildByPath(self.scroll_right, "btn_tupo")




	--道具按钮
	self.btnToolList = {}
	self.btnToilListNode = TFDirector:getChildByPath(ui, "Panel_cailiao")
	for i=1,3 do
		self.btnToolList[i] = TFDirector:getChildByPath(self.btnToilListNode, "btn_tool"..i)
		self.btnToolList[i].btnImg = TFDirector:getChildByPath(self.btnToilListNode, "img_tool"..i)
		self.btnToolList[i].txtNum = TFDirector:getChildByPath(self.btnToilListNode, "txt_num"..i)
		self.btnToolList[i].txtTipsExp = TFDirector:getChildByPath(self.btnToilListNode, "txt_number"..i)
	end
	self.txt_zhushi = TFDirector:getChildByPath(ui, "txt_zhushi")

    self.cellModel  = createUIByLuaNew("lua.uiconfig_mango_new.smithy.EquipmentUpCell")
    self.cellModel:retain()

    self:setEquipGmId(self.gmId)
end

function EquipmentUpgradeLayer:onShow()
	self.super.onShow(self)
    self:refreshUI()
    self.info_panel:onShow()
end

function EquipmentUpgradeLayer:dispose()
	self.info_panel:dispose()
	self.super.dispose(self)
end

function EquipmentUpgradeLayer:refreshUI()
	
    self.info_panel:setEquipGmId(self.gmId)
end

function EquipmentUpgradeLayer:removeUI()
	self.super.removeUI(self)
	if self.cellModel then
	   	self.cellModel:release()
	   	self.cellModel = nil
	end

	if self.delayLongTouchTimer then
    	TFDirector:removeTimer(self.delayLongTouchTimer)
		self.delayLongTouchTimer = nil
    end
    if self.touchLongTimer then
    	TFDirector:removeTimer(self.touchLongTimer)
		self.touchLongTimer = nil
    end
end

function EquipmentUpgradeLayer:setEquipGmId(gmId)
	self.gmId = gmId
	self.gradeLevelStart = 0

	if self.tableViewEffect then
		self.tableViewEffect:removeMEListener(TFARMATURE_COMPLETE) 
		self.tableViewEffect:removeFromParent()  			
		self.tableViewEffect = nil
	end

	self.scroll_right:setVisible(false)
	self.img_notice:setVisible(false)

    local equip = EquipmentManager:getEquipByGmid(gmId)
    if equip == nil then
    	self.cloneEquip = nil
    	return
    end

    self:refreshUI()
	if equip.quality >= 4 then
    	self.scroll_right:setVisible(true)
    else
    	self.img_notice:setVisible(true)
    	return
    end

	local currEquipGradeLevel = equip:getOrderLevel()
	local integerLevel = math.modf(currEquipGradeLevel/10)

	if self:checkCanBreach() then
		self.gradeLevelStart = (integerLevel-1)*10
	else
		self.gradeLevelStart = (integerLevel)*10
	end

	self.cloneEquip = clone(equip)
	
	self:showAttributeInfo()
	self:showLoadingBarInfo()    
end


function EquipmentUpgradeLayer:checkCanBreach()

    local equip = EquipmentManager:getEquipByGmid(self.gmId)
    if equip == nil then
    	return false
    end
    local currBreachLevel = equip:getorderBreachLevel()
	local currEquipGradeLevel = equip:getOrderLevel()
	local integerLevel = math.modf(currEquipGradeLevel/10)
	local modLevel = math.mod(currEquipGradeLevel, 10)
	if currEquipGradeLevel > 0 and (modLevel == 0 and integerLevel ~= currBreachLevel) then
		return true
	end	
	return false
end

function EquipmentUpgradeLayer:registerEvents()

	if self.registerEventCallFlag then
		return
	end

	function onTouchBegin(widget,pos,offset)

		local curr_num = BagManager:getItemNumById( widget.goodId ) or 0
		if curr_num < 1 then
			toastMessage(localizable.EquipToolsNot)
			self.isSendDataToServer = true
		else
			self.touchLongToolNum = 1
			self.touchLongToolId = widget.goodId
			self.touchLongBtnIndex = widget.showIndex
			self.isSendDataToServer = false
			self:createLongTouch(widget.showIndex)
		end
    end
    function onTouchEnd(widget,pos)
    	self:deleteTouch()
    end    
	for i=1,3 do
	    -- self.btnToolList[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnToolClick))		
	    self.btnToolList[i]:addMEListener(TFWIDGET_TOUCHBEGAN, onTouchBegin)
	    self.btnToolList[i]:addMEListener(TFWIDGET_TOUCHMOVED, onTouchMove)
	    self.btnToolList[i]:addMEListener(TFWIDGET_TOUCHENDED, onTouchEnd)				
		self.btnToolList[i].logic = self
		self.btnToolList[i].showIndex = i
	end

	self.btnLevelUp:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnOneKeyClick))
	self.btnLevelUp.logic = self

	self.btnUpGrade:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnUpGradeClick))
	self.btnUpGrade.logic = self

	self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onbtnHelpClick))
	self.btn_help.logic = self

	self.equipUpdateCallBack = function (event)
		hideLoading()

		local equip = EquipmentManager:getEquipByGmid(self.gmId)
	    if equip == nil then
    		return
    	end
    	
    	if equip.orderBreachLevel ~= self.cloneEquip.orderBreachLevel then
    		self:playUpGradeEffect()
    		self:setEquipGmId(self.gmId)
    	elseif equip.orderLevel ~= self.cloneEquip.orderLevel then
    		self:playeLevelUpEffect()	    
    		self:showToolsInfo()
    	else
    		self.cloneEquip = clone(equip)
    		self:showLoadingBarInfo()
    		self:showToolsInfo()
    	end		
    end
    TFDirector:addMEGlobalListener(BagManager.EQUIP_UPDATE, self.equipUpdateCallBack) 

	self.super.registerEvents(self)

    self.registerEventCallFlag = true
end


function EquipmentUpgradeLayer:removeEvents()

    if self.equipUpdateCallBack then
    	TFDirector:removeMEGlobalListener(BagManager.EQUIP_UPDATE, self.equipUpdateCallBack) 
    	self.equipUpdateCallBack = nil
    end
    self.super.removeEvents(self)
    self.registerEventCallFlag = nil
end


function EquipmentUpgradeLayer.cellSizeForTable(table,idx)
    return CellH,270
end

function EquipmentUpgradeLayer.numberOfCellsInTableView(table)
    return 10
end

function EquipmentUpgradeLayer.tableCellAtIndex(table, idx)

	local self = table.logic
	local cell = table:dequeueCell()

	local panel = nil
	if cell == nil then
	    cell = TFTableViewCell:create()
		panel = self.cellModel:clone()
		panel:setPosition(ccp(0,0))
		cell:addChild(panel)
		cell.panel = panel
	else
		panel = cell.panel
	end

	idx = idx + 1

	self:showCellInfo(panel, idx)
    return cell
end

function EquipmentUpgradeLayer:showCellInfo(panel, idx)
	local Panel_yijihuo = TFDirector:getChildByPath(panel, 'Panel_yijihuo')
	Panel_yijihuo:setVisible(false)
	local Panel_weijihuo = TFDirector:getChildByPath(panel, 'Panel_weijihuo')
	Panel_weijihuo:setVisible(false)
	local currEquipGradeLevel = self.cloneEquip:getOrderLevel()
	local dataIndex = self.gradeLevelStart + idx

	if dataIndex > currEquipGradeLevel then
		--未激活
		Panel_weijihuo:setVisible(true)
		local attrIndex,attrNum = EquipmentThroughAttribData:getCurrAttrByQualityLevel(self.cloneEquip.equipType, self.cloneEquip.quality, dataIndex)
		if attrIndex == nil or attrNum == nil then
			return
		end
		local txt_jiacheng = TFDirector:getChildByPath(Panel_weijihuo, 'txt_jiacheng')
		txt_jiacheng:setText(AttributeTypeStr[attrIndex].." +" ..covertToDisplayValue(attrIndex,attrNum))
		local img_fumokong = TFDirector:getChildByPath(Panel_weijihuo, 'img_fumokong')
		img_fumokong:setTexture('ui_new/smithy/img_'..idx..'_h.png')
	else
		if self.needShowEffectIndex and self.needShowEffectIndex == dataIndex then
			Panel_weijihuo:setVisible(true)
			local attrIndex,attrNum = EquipmentThroughAttribData:getCurrAttrByQualityLevel(self.cloneEquip.equipType, self.cloneEquip.quality, dataIndex)
			if attrIndex == nil or attrNum == nil then
				return
			end
			local txt_jiacheng = TFDirector:getChildByPath(Panel_weijihuo, 'txt_jiacheng')
			txt_jiacheng:setText(AttributeTypeStr[attrIndex].." +" ..covertToDisplayValue(attrIndex,attrNum))
			local img_fumokong = TFDirector:getChildByPath(Panel_weijihuo, 'img_fumokong')
			img_fumokong:setTexture('ui_new/smithy/img_'..idx..'_h.png')

			if self.tableViewEffect then
				self.tableViewEffect:removeMEListener(TFARMATURE_COMPLETE) 
				self.tableViewEffect:removeFromParent()  			
				self.tableViewEffect = nil
			end

			TFResourceHelper:instance():addArmatureFromJsonFile("effect/upGrade.xml")
			local effect = TFArmature:create("upGrade_anim")
			effect:setAnimationFps(GameConfig.ANIM_FPS)	
			effect:setPosition(ccp(140,38))
			panel:addChild(effect,100)
			self.needShowEffectIndex = nil
			local temp = 0
			effect:addMEListener(TFARMATURE_UPDATE,function()
		        temp = temp + 1
		        if temp == 7 then
					Panel_yijihuo:setVisible(true)
					Panel_weijihuo:setVisible(false)
					local attrIndex,attrNum = EquipmentThroughAttribData:getCurrAttrByQualityLevel(self.cloneEquip.equipType, self.cloneEquip.quality, dataIndex)
					local txt_jiacheng = TFDirector:getChildByPath(Panel_yijihuo, 'txt_jiacheng')
					txt_jiacheng:setText(AttributeTypeStr[attrIndex].." +" ..covertToDisplayValue(attrIndex,attrNum))
					local img_fumokong = TFDirector:getChildByPath(Panel_yijihuo, 'img_fumokong')
					img_fumokong:setTexture('ui_new/smithy/img_'..idx..'_l.png')
		        end
		    end)
			effect:addMEListener(TFARMATURE_COMPLETE,function()
				print('TFARMATURE_COMPLETE = TFARMATURE_COMPLETE')
				effect:removeMEListener(TFARMATURE_COMPLETE) 
				effect:removeFromParent()        
		        effect = nil   
		        self.tableViewEffect = nil
		    end)
		    self.tableViewEffect = effect
		    effect:playByIndex(0, -1, -1, 0)
		else
			Panel_yijihuo:setVisible(true)
			local attrIndex,attrNum = EquipmentThroughAttribData:getCurrAttrByQualityLevel(self.cloneEquip.equipType, self.cloneEquip.quality, dataIndex)
			local txt_jiacheng = TFDirector:getChildByPath(Panel_yijihuo, 'txt_jiacheng')
			txt_jiacheng:setText(AttributeTypeStr[attrIndex].." +" ..covertToDisplayValue(attrIndex,attrNum))
			local img_fumokong = TFDirector:getChildByPath(Panel_yijihuo, 'img_fumokong')
			img_fumokong:setTexture('ui_new/smithy/img_'..idx..'_l.png')
		end
	end
end

function EquipmentUpgradeLayer:showAttributeInfo()
	
	if self.cloneEquip == nil  then
        print("equipment not found .",self.gmId)
        return
    end

    if self.fumoTabView == nil then
		self.fumoTabViewUI = TFDirector:getChildByPath(self.scroll_right, "Panel_fumokong")
	    self.fumoTabView =  TFTableView:create()
	    self.fumoTabView:setTableViewSize(self.fumoTabViewUI:getContentSize())
	    self.fumoTabView:setDirection(TFTableView.TFSCROLLVERTICAL)    
	    self.fumoTabView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
	    self.fumoTabView.logic = self
	    self.fumoTabViewUI:addChild(self.fumoTabView)
	    self.fumoTabView:setPosition(ccp(0,0))

    	self.fumoTabView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
	    self.fumoTabView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
	    self.fumoTabView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
    end

    --总属性
    self.totalAttr[1]:setVisible(true)
    self.totalAttr[1]:setText(localizable.EquipGradeNone)
    self.totalAttr[2]:setVisible(false)
    local extraAttr = self.cloneEquip:getOrderLevelAttribute():getAttribute()
    if extraAttr then
    	local notEmptyIndex = 1
        for k,v in pairs(extraAttr) do
            self.totalAttr[notEmptyIndex]:setVisible(true)
            self.totalAttr[notEmptyIndex]:setText(AttributeTypeStr[k].." +" ..covertToDisplayValue(k,v))
            notEmptyIndex = notEmptyIndex + 1
        end
	end 
	--特殊属性
	local currBreachLevel = self.cloneEquip:getorderBreachLevel()
	local CurrSpecialInfo = EquipmentSpecialAttribData:getDetailsByQualityLevel(self.cloneEquip.equipType, self.cloneEquip.quality, currBreachLevel)
	local NextSpecialInfo = EquipmentSpecialAttribData:getDetailsByQualityLevel(self.cloneEquip.equipType, self.cloneEquip.quality, currBreachLevel+1)
	if CurrSpecialInfo then
		self.currUpGradeEffect:setVisible(true)
    	self.currUpGradeEffect:setText(CurrSpecialInfo.des)
    else
    	self.currUpGradeEffect:setVisible(true)
    	self.currUpGradeEffect:setText(localizable.EquipGradeNone)
    end
    if NextSpecialInfo then
    	self.nextUpGradeEffect:setVisible(true)
    	self.nextUpGradeEffect:setText(NextSpecialInfo.des)
	    local limitTips = stringUtils.format(localizable.EquipGradeTips,NextSpecialInfo.equip_star_limit, NextSpecialInfo.through_level)
	    if NextSpecialInfo.equip_star_limit > self.cloneEquip.star then
		    self.limitUpGrade:setVisible(true)
			self.limitUpGrade:setText(limitTips)
		else
			self.limitUpGrade:setVisible(false)
		end
    else
    	self.limitUpGrade:setVisible(false)
    	self.nextUpGradeEffect:setVisible(true)
    	self.nextUpGradeEffect:setText(localizable.EquipGradeNone)
    end

    self:showToolsInfo()

    if currBreachLevel >= EquipmentManager.kMaxUpgradeLevel then
    	self.fumoTabViewUI:setVisible(false)
    	self.btnLevelUp:setVisible(false)
    	self.txt_zhushi:setVisible(false)
		self.img_max:setVisible(true)
		self.img_yimanji:setVisible(true)
		self.txt_shuzhi:setVisible(false)
		self.img_nextlevel:setVisible(false)
		self.bar_jindu:setPercent(100)
    	return
    end
    self.txt_shuzhi:setVisible(true)
	self.img_max:setVisible(false)
	self.img_yimanji:setVisible(false)
    self.img_nextlevel:setVisible(true)
    self.fumoTabViewUI:setVisible(true)
    self.fumoTabView:reloadData()
    local level = self.cloneEquip:getOrderLevel()
	local panelHight = self.fumoTabViewUI:getContentSize().height
	local offsetIndex = math.mod(level,10)
	if level == 0 then
		offsetIndex = 1
	elseif offsetIndex == 0 then
		if self:checkCanBreach() then
			offsetIndex = 9
		else
			offsetIndex = 1
		end
	end
	local viewHeight = (10-offsetIndex+1)*CellH - panelHight
    if viewHeight < 0 then
        viewHeight = 0
    end
    self.fumoTabView:setContentOffset(ccp(0,-viewHeight))
end

function EquipmentUpgradeLayer:showToolsInfo()

	local level = self.cloneEquip:getOrderLevel()
	local breachLevel = self.cloneEquip:getorderBreachLevel()
	local quality = self.cloneEquip.quality
	local currExp = self.cloneEquip:getCurrExp()
	local equipType = self.cloneEquip.equipType

	self.txt_shengjielevel:setText(stringUtils.format(localizable.EquipGradeUpCount,breachLevel))	

	if self:checkCanBreach() then
		--能够突破
		self.txt_zhushi:setVisible(false)
		self.btnLevelUp:setVisible(false)
		self.btnUpGrade:setVisible(true)
		for i=1,3 do
			self.btnToolList[i]:setVisible(false)
			self.btnToolList[i].txtTipsExp:setVisible(false)			
		end

		local icon = nil
		local item = EquipmentSpecialAttribData:getConsumesByQualityLevel(equipType, quality, breachLevel+1)
		local curr_num = BagManager:getItemNumById( item.id )
		if self.iconTupo == nil then			
	    	icon = require('lua.logic.role_new.RoleStarUpPreviewNumCell'):new()
	    	local pos = self.btnToolList[3]:getPosition()
	    	local contentSize = icon:getContentSize()
	    	icon:setPosition(ccp(pos.x-contentSize.width/2,pos.y-contentSize.height/2))
	    	self.btnToilListNode:addChild(icon)
	    	self.iconTupo = icon
	    	print("iconTupoiconTupoiconTupoiconTupo")
	    else
	    	icon = self.iconTupo
	    end
	    icon:setVisible(true)
	    icon:setData(item.id,curr_num,item.num)
	else
		self.txt_zhushi:setVisible(true)
		self.btnLevelUp:setVisible(true)
		self.btnUpGrade:setVisible(false)		

		if self.iconTupo then
			self.iconTupo:setVisible(false)
		end
		local toolList = EquipmentThroughExpData:getToolListByQualityLevel(quality, level+1)
		for i=1,3 do
			if toolList[i] then
				self.btnToolList[i]:setVisible(true)
				self.btnToolList[i].txtTipsExp:setVisible(true)
				
				local goodsId = tonumber(toolList[i])
				local itemData = ItemData:objectByID(goodsId)	
				local bagNumber = BagManager:getItemNumById( goodsId )

				self.btnToolList[i].goodId = goodsId
				self.btnToolList[i].goodNum = bagNumber
				self.btnToolList[i].goodExp = itemData.provide_exp
				local str = stringUtils.format(localizable.EquipGradeExp,itemData.provide_exp)
				self.btnToolList[i].txtTipsExp:setText(str)

						
				self.btnToolList[i]:setTextureNormal(GetColorIconByQuality(itemData.quality));
				self.btnToolList[i].btnImg:setTexture(itemData:GetPath())
				self.btnToolList[i].txtNum:setText(bagNumber)
			else
				self.btnToolList[i]:setVisible(false)
				self.btnToolList[i].txtTipsExp:setVisible(false)
			end
		end
	end
end

function EquipmentUpgradeLayer:showLoadingBarInfo()

	local level = self.cloneEquip:getOrderLevel()
	local breachLevel = self.cloneEquip:getorderBreachLevel()
	local quality = self.cloneEquip.quality
	local currExp = self.cloneEquip:getCurrExp()

	if breachLevel >= MaxBreachLevel then
		return
	end

	if self:checkCanBreach() then
		--能够突破
		self.img_nextlevel:setTexture('ui_new/smithy/img_10_l.png')
		local maxExp = EquipmentThroughExpData:getExpByQualityLevel(quality, level)
		self.bar_jindu:setPercent(100)
		self.txt_shuzhi:setText(maxExp..'/'..maxExp)
	else
		local maxExp = EquipmentThroughExpData:getExpByQualityLevel(quality, level+1)
		local percent = math.floor(currExp*100/maxExp)	
		self.bar_jindu:setPercent(percent)
		self.txt_shuzhi:setText(currExp..'/'..maxExp)

		local idx = math.mod(level+1, 10)
		if idx == 0 then
			idx = 10
		end
		self.img_nextlevel:setTexture('ui_new/smithy/img_'..idx..'_h.png')	
	end	
end

function EquipmentUpgradeLayer:createLongTouch(btnIndex)
	if self.delayLongTouchTimer then
    	TFDirector:removeTimer(self.delayLongTouchTimer)
		self.delayLongTouchTimer = nil
    end
    if self.touchLongTimer then
    	TFDirector:removeTimer(self.touchLongTimer)
		self.touchLongTimer = nil
    end
	self.delayLongTouchTimer = TFDirector:addTimer(300, -1,nil,
        function ()
            if self.delayLongTouchTimer then
            	TFDirector:removeTimer(self.delayLongTouchTimer)
        		self.delayLongTouchTimer = nil
            end
            self.touchLongTimer = TFDirector:addTimer(66, -1,nil,
            	function ()
            		local btn = self.btnToolList[btnIndex] 
            		local showNum = btn.goodNum - self.touchLongToolNum
            		self.cloneEquip:setAddOrderExp(btn.goodExp)            		
            		local maxExp = EquipmentThroughExpData:getExpByQualityLevel(self.cloneEquip.quality, self.cloneEquip:getOrderLevel()+1)
            		local currExp = self.cloneEquip:getCurrExp()
            		self:showLoadingBarInfo()
                	if showNum > 0 and currExp < maxExp then
                		self.touchLongToolNum = self.touchLongToolNum + 1
                		showNum = showNum - 1
                		btn.txtNum:setText(showNum)
                		local function flyMoveCallBack()                			
                		end                		
                		self:showFlyBegin(self.touchLongBtnIndex, flyMoveCallBack)
                	else
                		self:deleteTouch()
                	end
                end)
        end)	
end

function EquipmentUpgradeLayer:deleteTouch()
	if self.delayLongTouchTimer then
    	TFDirector:removeTimer(self.delayLongTouchTimer)
		self.delayLongTouchTimer = nil
    end
    if self.touchLongTimer then
    	TFDirector:removeTimer(self.touchLongTimer)
		self.touchLongTimer = nil
    end

    if self.isSendDataToServer == false then
	    local curr_num = BagManager:getItemNumById( self.touchLongToolId )
		if curr_num >= self.touchLongToolNum then
			local function flyMoveCallBack()
			end
				local msg = {}
				msg[self.touchLongToolId] = self.touchLongToolNum
				EquipmentManager:equipIncreaseExp(self.gmId, msg)
			self:showFlyBegin(self.touchLongBtnIndex, flyMoveCallBack)
		else
			toastMessage(localizable.EquipToolsNot)
		end
	end
	self.isSendDataToServer = true    
end

function EquipmentUpgradeLayer.onBtnOneKeyClick( btn )
	local self = btn.logic

	-- if self.tableViewEffect or self.equipLevelUpEffect then
	-- 	return
	-- end
	if self.tableViewEffect then
		self.tableViewEffect:removeMEListener(TFARMATURE_COMPLETE)
		self.tableViewEffect:removeFromParent()
	end
	if self.equipLevelUpEffect then
		self.equipLevelUpEffect:removeMEListener(TFARMATURE_COMPLETE)
		self.equipLevelUpEffect:removeFromParent()
	end
	if self.tableViewEffect or self.equipLevelUpEffect then
		self.tableViewEffect = nil
		self.equipLevelUpEffect = nil
		self:setEquipGmId(self.gmId)
	end


	local level = self.cloneEquip:getOrderLevel()
	local breachLevel = self.cloneEquip:getorderBreachLevel()
	local quality = self.cloneEquip.quality
	local currExp = self.cloneEquip:getCurrExp()
	local maxExp = EquipmentThroughExpData:getExpByQualityLevel(quality, level+1)
	local toolList = EquipmentThroughExpData:getToolListByQualityLevel(quality, level+1)
	local needExp = maxExp - currExp
	local msg = nil
	for i=1,3 do
		if toolList[i] then
			local goodsId = tonumber(toolList[i])
			local bagNumber = BagManager:getItemNumById( goodsId )
			local itemData = ItemData:objectByID(goodsId)	
			local needNumber = math.ceil(needExp/itemData.provide_exp)
			if bagNumber > 0 then
				msg = msg or {}
				if needNumber > bagNumber then
					needExp = needExp - itemData.provide_exp*bagNumber
					msg[goodsId] = bagNumber
				else
					msg[goodsId] = needNumber
					break
				end		
			end	
		end
	end
	if msg then
		local equip = EquipmentManager:getEquipByGmid(self.gmId)
		self.cloneEquip = clone(equip)
		EquipmentManager:equipIncreaseExp(self.gmId, msg)
	else
		toastMessage(localizable.EquipToolsNot)
	end
end

function EquipmentUpgradeLayer.onBtnUpGradeClick( btn )
	local self = btn.logic
	local breachLevel = self.cloneEquip:getorderBreachLevel()
	local quality = self.cloneEquip.quality
	local equipType = self.cloneEquip.equipType
	local item = EquipmentSpecialAttribData:getConsumesByQualityLevel(equipType, quality, breachLevel+1)
	local curr_num = BagManager:getItemNumById( item.id )
	local detailInfo = EquipmentSpecialAttribData:getDetailsByQualityLevel(equipType, quality, breachLevel+1)


	if curr_num < item.num then
		toastMessage(localizable.common_prop_not_enough)
		return
	end

	if self.cloneEquip.star < detailInfo.equip_star_limit then
		local str = stringUtils.format(localizable.equip_star_not_enough,detailInfo.equip_star_limit)
		toastMessage(str)
		return
	end

	CommonManager:showOperateSureLayer(
            function()
                EquipmentManager:equipStepsThrough(self.gmId)
            end,
            function()
                AlertManager:close()
            end,
            {
            title = localizable.common_tips,
            msg = localizable.EquipGradeSureTips,
            }
        )
	
end

function EquipmentUpgradeLayer:showFlyBegin(pos,flyMoveCallBack)
    play_chuangonghunpoyidong()

    local topos = self.btnToolList[pos]:convertToWorldSpace(ccp(0,0))

    local resPath = "effect/role_transfer_begin.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local flyPic = TFArmature:create("role_transfer_begin_anim")

    flyPic:setAnimationFps(GameConfig.ANIM_FPS)
    flyPic:setPosition(ccp(topos.x-70 , topos.y-90))
    flyPic:setScale(0.8)

    self:addChild(flyPic,100)
    
    flyPic:addMEListener(TFARMATURE_COMPLETE,function()
        flyPic:removeFromParentAndCleanup(true)
        flyPic:removeMEListener(TFARMATURE_COMPLETE) 
    end)
    local temp = 0
    flyPic:addMEListener(TFARMATURE_UPDATE,function()
        temp = temp + 1
        if temp == 2 then
            self:showFlyMove(pos,flyMoveCallBack)
        end
    end)

    flyPic:playByIndex(0, -1, -1, 0)
end

function EquipmentUpgradeLayer:showFlyMove(pos, flyMoveCallBack)
    play_chuangonghunpoyidong()

    local topos = self.btnToolList[pos]:convertToWorldSpace(ccp(0,0))

    local resPath = "effect/role_transfer_move.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local moveEffect = TFArmature:create("role_transfer_move_anim")

    moveEffect:setAnimationFps(GameConfig.ANIM_FPS)
    moveEffect:setPosition(ccp(topos.x-100, topos.y))

    self:addChild(moveEffect,100)

    moveEffect:playByIndex(0, -1, -1, 1)

    local toPos = self.bar_jindu:convertToWorldSpace(ccp(0,0))
    local tween = 
    {
        target = moveEffect,
        {
            ease = {type=TFEaseType.EASE_IN_OUT, rate=9},
            duration = 0.2,
            x = toPos.x-370,
            y = toPos.y,
            onComplete = function ()

            	if self.endEffect == nil then
	            	local resPath = "effect/role_transfer_end.xml"
	                TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
	                local endEffect = TFArmature:create("role_transfer_end_anim")

	                endEffect:setAnimationFps(GameConfig.ANIM_FPS)
	                endEffect:setPosition(ccp(100, 280))
	                self.bar_jindu:addChild(endEffect,100)
	                -- endEffect:setScaleX(1.6)
	                
	                endEffect:addMEListener(TFARMATURE_COMPLETE,function()
	                    endEffect:removeMEListener(TFARMATURE_COMPLETE) 
	                    endEffect:removeFromParentAndCleanup(true)
	                    self.endEffect = nil
	                end)
	                endEffect:playByIndex(0, -1, -1, 0)
	                self.endEffect = endEffect
	            end

                moveEffect:removeFromParentAndCleanup(true)
                flyMoveCallBack()
            end,
        },
    }
    TFDirector:toTween(tween)

end

function EquipmentUpgradeLayer:playeLevelUpEffect()

	if self.endEffect then
		self.endEffect:removeMEListener(TFARMATURE_COMPLETE) 
        self.endEffect:removeFromParentAndCleanup(true)
        self.endEffect = nil
	end

	if self.equipLevelUpEffect then
		self.equipLevelUpEffect:removeMEListener(TFARMATURE_COMPLETE) 
        self.equipLevelUpEffect:removeFromParentAndCleanup(true)
        self.equipLevelUpEffect = nil
	end

	local equip = EquipmentManager:getEquipByGmid(self.gmId)
	local currExp = equip:getCurrExp()
	local maxExp = EquipmentThroughExpData:getExpByQualityLevel(self.cloneEquip.quality, self.cloneEquip:getOrderLevel()+1)
    self.bar_jindu:setPercent(100)
	self.txt_shuzhi:setText((maxExp+currExp)..'/'..maxExp)

	TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
	local effect = TFArmature:create("equipIntensify_3_anim")
	effect:setAnimationFps(GameConfig.ANIM_FPS)
	local width = self.bar_jindu:getContentSize().width
	effect:setPosition(ccp(-width/2,-60))
	effect:setScaleX(1.12)
	self.bar_jindu:addChild(effect,100)

	effect:addMEListener(TFARMATURE_COMPLETE,function()
		effect:removeMEListener(TFARMATURE_COMPLETE) 
        effect:removeFromParentAndCleanup(true)
        self.equipLevelUpEffect = nil

        if self.equiIntensify == nil then
	        TFResourceHelper:instance():addArmatureFromJsonFile("effect/equiIntensify.xml")
			local equiIntensify = TFArmature:create("equiIntensify_anim")
			equiIntensify:setAnimationFps(GameConfig.ANIM_FPS)
			equiIntensify:setScale(0.5)
			equiIntensify:setPosition(ccp(660,130))
			self.img_nextlevel:getParent():addChild(equiIntensify,100)
			self.equiIntensify = equiIntensify
		end
		self.equiIntensify:playByIndex(0, -1, -1, 0)
		self:setEquipGmId(self.gmId)
    end)

    effect:playByIndex(0, -1, -1, 0)

    self.equipLevelUpEffect = effect

    local equip = EquipmentManager:getEquipByGmid(self.gmId)
    self.needShowEffectIndex = equip.orderLevel
end

function EquipmentUpgradeLayer:playUpGradeEffect()
--播放进阶特效
	-- print("播放进阶特效")
	if self.UpGradeEffect == nil then
		TFResourceHelper:instance():addArmatureFromJsonFile("effect/equiIntensify.xml")
		local effect = TFArmature:create("equiIntensify_anim")
		effect:setAnimationFps(GameConfig.ANIM_FPS)
		local img_icon = TFDirector:getChildByPath(self.info_panel, 'img_icon')
		effect:setPosition(ccp(360,-35))
		img_icon:addChild(effect)
		self.UpGradeEffect = effect
	end
	self.UpGradeEffect:playByIndex(0, -1, -1, 0)

	if self.UpGradeEffectRight == nil then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/equipment_refining.xml")
        local effect = TFArmature:create("equipment_refining_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        self.scroll_right:addChild(effect)
        effect:setScaleX(1.5)
        effect:setPosition(ccp(215,280))
        effect:setZOrder(10)
        self.UpGradeEffectRight = effect
    end
    self.UpGradeEffectRight:playByIndex(0, -1, -1, 0)
end

function EquipmentUpgradeLayer.onbtnHelpClick( btn )
	CommonManager:showRuleLyaer( "zhuangbeishengjie" )
end
return EquipmentUpgradeLayer;
