-- client side ItemMergeMore.lua
--[[
 * @Description: 批量合成道具碎片
 ]]
-- script writer chikui
-- creation time 2016-12-07


local ItemMergeMore = class("ItemMergeMore", BaseLayer)

CREATE_PANEL_FUN(ItemMergeMore)


function ItemMergeMore:ctor(more_info)
    self.super.ctor(self,more_info)
    self.id = more_info.itemid
    self.maxNum = more_info.maxNum

    self:init("lua.uiconfig_mango_new.common.OpenMore")
end

function ItemMergeMore:initUI(ui)
	self.super.initUI(self,ui)

	--操作按钮
	self.img_quality		= TFDirector:getChildByPath(ui, 'img_quality')
	self.img_icon			= TFDirector:getChildByPath(ui, 'img_icon')
	self.txt_name			= TFDirector:getChildByPath(ui, 'txt_name')
	self.btn_use			= TFDirector:getChildByPath(ui, 'btn_qianghua')
	self.btn_close			= TFDirector:getChildByPath(ui, 'btn_close')
	self.txt_info			= TFDirector:getChildByPath(ui, 'txt_info')
	self.slider_ItemMergeMore	= TFDirector:getChildByPath(ui, 'Slider_OpenMore')
	self.bg_jindushuzhi		= TFDirector:getChildByPath(ui, 'bg_jindushuzhi')
	self.txt_num			= TFDirector:getChildByPath(ui, 'txt_num')
	self.btn_jia			= TFDirector:getChildByPath(ui, 'btn_jia')
	self.btn_jian			= TFDirector:getChildByPath(ui, 'btn_jian')
	self.txt_maxnum			= TFDirector:getChildByPath(ui, 'txt_maxnum')
	self.txt_numnow			= TFDirector:getChildByPath(ui, 'txt_numnow')
	self.txt_num22			= TFDirector:getChildByPath(ui, 'txt_num22')
	self.txt_boxnum			= TFDirector:getChildByPath(ui, 'txt_boxnum')


	--为按钮绑定处理逻辑属性，指向self
	self.btn_use.logic = self
	self.btn_jia.logic = self
	self.btn_jian.logic = self
	self.slider_ItemMergeMore.logic = self
	self.slider_ItemMergeMore:setZOrder(10)
	self:initInfo(self.id)
end

function ItemMergeMore:removeUI()
	self.img_quality		= nil
	self.img_icon			= nil
	self.txt_name			= nil
	self.btn_use			= nil
	self.btn_close			= nil
	self.txt_info			= nil
	self.slider_ItemMergeMore	= nil
	self.bg_jindushuzhi		= nil
	self.txt_num			= nil
	self.btn_jia			= nil
	self.btn_jian			= nil
	self.txt_maxnum			= nil
	self.txt_numnow			= nil

	--调用父类方法
	self.super.removeUI(self)
end


function ItemMergeMore:onShow()
	self.super.onShow(self)
    self:refreshUI()
end

function ItemMergeMore:setIconInfo( itemInfo )
	
	self.img_quality:setTexture(GetColorIconByQuality(itemInfo.quality))
	self.img_icon:setTexture(itemInfo:GetPath())

	local rewardItem = {itemid = itemInfo.id}	
    Public:addPieceImg(self.img_icon,rewardItem,nil,1.0)
    
	self.txt_name:setText(itemInfo.name)
	self.txt_info:setText(itemInfo.describe2)
end

function ItemMergeMore:initInfo( id )
	local itemInfo = BagManager:getItemById(id)
	if itemInfo == nil then
		print("背包没有该物品 id == ",id)
		return
	end
	self.itemInfo = itemInfo

	self:setIconInfo(itemInfo)

	self.txt_num22:setVisible(false)
	if self.maxNum == nil then
		self.maxNum = self.itemInfo.num
	end
	self.choiceNum = self.maxNum
	self:refreshUI()
end

function ItemMergeMore:setNum( num )
	self.txt_num:setText(num)
	self.txt_numnow:setText(num .."/"..self.maxNum)
	local percent = math.ceil(num/self.maxNum*100)
	self.slider_ItemMergeMore:setPercent(percent)
end


function ItemMergeMore:refreshUI()
	local itemInfo = self.itemInfo
    self.txt_maxnum:setText(itemInfo.num)
	self:setNum(self.choiceNum)
	self.bg_jindushuzhi:setVisible(false)

	self:freshButtonState()
end

function ItemMergeMore.reduceButtonClickHandle(sender)
	local self = sender.logic
	self.choiceNum = self.choiceNum - 1
	if self.choiceNum > 0 then
		sender.logic:setNum(self.choiceNum)
	end
	self:freshButtonState()
end

function ItemMergeMore.addButtonClickHandle(sender)
	local self = sender.logic
	self.choiceNum = self.choiceNum + 1
	sender.logic:setNum(self.choiceNum)
	self:freshButtonState()
end

function ItemMergeMore.useButtonClickHandle(sender)
	local self = sender.logic
	if self.choiceNum < 1 then
		--toastMessage("数量不能为0");
		--toastMessage(stringUtils.format(localizable.ItemMergeMore_number_no_zero,0));

		return
	end
	local item = ItemPieceMergeData:getObjectByPieceId(self.id)
	BagManager:requestItemMerge( item.id ,self.choiceNum)
	AlertManager:close()
end

function ItemMergeMore.sliderTouchBeginHandle(sender)
	local self = sender.logic
	self.bg_jindushuzhi:setVisible(true)
	self:freshSliderNum()
end

function ItemMergeMore.sliderTouchMoveHandle(sender)
	local self = sender.logic
	self:freshSliderNum()
end

function ItemMergeMore.sliderTouchEndHandle(sender)
	local self = sender.logic

	local percent = math.ceil(self.choiceNum /self.maxNum*100)
	self.slider_ItemMergeMore:setPercent(percent)

	self.bg_jindushuzhi:setVisible(false)
	self:freshButtonState()
end

function ItemMergeMore:freshSliderNum()
	local percent = self.slider_ItemMergeMore:getPercent()/100
	local num = math.ceil(percent*self.maxNum)
	self.choiceNum = math.max(num,1)
	self.txt_num:setText(self.choiceNum)
	self.txt_numnow:setText(self.choiceNum .."/"..self.maxNum)
	local width = self.slider_ItemMergeMore:getSize().width
	local temp = math.ceil(width*percent)
	self.bg_jindushuzhi:setPositionX(temp - width/2)
end

--设置按钮状态
function ItemMergeMore:freshButtonState()
	if self.choiceNum >= self.maxNum then
		self.btn_jia:setTouchEnabled(false)
		self.btn_jia:setGrayEnabled(true)
	else
		self.btn_jia:setTouchEnabled(true)
		self.btn_jia:setGrayEnabled(false)
	end

	if self.choiceNum > 1 then
		self.btn_jian:setTouchEnabled(true)
		self.btn_jian:setGrayEnabled(false)
	else
		self.btn_jian:setTouchEnabled(false)
		self.btn_jian:setGrayEnabled(true)
	end
end

--刷新回调
function ItemMergeMore:refreshCallback()
    self:refreshUI()
end

function ItemMergeMore:registerEvents()
	self.super.registerEvents(self)

	ADD_ALERT_CLOSE_LISTENER(self,self.btn_close)
	self.btn_close:setClickAreaLength(100);

	self.btn_use:addMEListener(TFWIDGET_CLICK, audioClickfun(self.useButtonClickHandle),1)
	self.btn_jia:addMEListener(TFWIDGET_CLICK, audioClickfun(self.addButtonClickHandle),1)
	self.btn_jian:addMEListener(TFWIDGET_CLICK, audioClickfun(self.reduceButtonClickHandle),1)
	self.slider_ItemMergeMore:addMEListener(TFWIDGET_TOUCHBEGAN, audioClickfun(self.sliderTouchBeginHandle),1)
	self.slider_ItemMergeMore:addMEListener(TFWIDGET_TOUCHMOVED, audioClickfun(self.sliderTouchMoveHandle),1)
	self.slider_ItemMergeMore:addMEListener(TFWIDGET_TOUCHENDED, audioClickfun(self.sliderTouchEndHandle),1)


end

function ItemMergeMore:removeEvents()
    self.btn_jia:removeMEListener(TFWIDGET_CLICK)
	self.btn_jian:removeMEListener(TFWIDGET_CLICK)
	self.btn_use:removeMEListener(TFWIDGET_CLICK)

	self.slider_ItemMergeMore:removeMEListener(TFWIDGET_TOUCHBEGAN)
	self.slider_ItemMergeMore:removeMEListener(TFWIDGET_TOUCHMOVED)
	self.slider_ItemMergeMore:removeMEListener(TFWIDGET_TOUCHENDED)

    self.super.removeEvents(self)
end

return ItemMergeMore;
