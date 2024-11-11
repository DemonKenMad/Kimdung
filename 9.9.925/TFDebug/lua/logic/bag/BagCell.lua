--[[
******背包物品tableview的cell*******
]]

local BagCell = class("BagCell", BaseLayer)

function BagCell:ctor(data)
    self.super.ctor(self,data)
    self.id = 0
    self:init("lua.uiconfig_mango_new.bag.BagCell")
end

function BagCell:initUI(ui)
	self.super.initUI(self,ui)

	self.txt_number			= TFDirector:getChildByPath(ui, 'txt_number')
	self.lbl_num_delim		= TFDirector:getChildByPath(ui, 'lbl_num_delim')
	self.txt_num_max		= TFDirector:getChildByPath(ui, 'txt_num_max')
	self.img_icon	 		= TFDirector:getChildByPath(ui, 'img_icon')
	self.img_soul	 		= TFDirector:getChildByPath(ui, 'img_soul')
	self.img_select	 		= TFDirector:getChildByPath(ui, 'img_selected_fg')

	self.img_already_had	 		= TFDirector:getChildByPath(ui, 'img_already_had')

	self.lbl_num_delim:setText("/")

	self.btn_node 		= TFDirector:getChildByPath(ui, 'btn_node')

	self.btn_node.logic = self

	--显示空白网格逻辑添加
    self.panel_empty            = TFDirector:getChildByPath(ui, 'panel_empty')
    self.panel_info             = TFDirector:getChildByPath(ui, 'panel_info')
    self.txt_qianghualv             = TFDirector:getChildByPath(ui, 'txt_qianghualv')
    self.txt_qianghualv2             = TFDirector:getChildByPath(ui, 'txt_qianghualv2')
    self.txt_qianghualv2:setVisible(false)
    self.panel_star             = TFDirector:getChildByPath(ui, 'panel_star')

    self.img_baoshicao = TFDirector:getChildByPath(ui, "img_baoshicao1")
    self.img_gem = TFDirector:getChildByPath(self.img_baoshicao, "img_gem")

    self.img_baoshicao2 = TFDirector:getChildByPath(ui, "img_baoshicao2")
    self.img_gem2 = TFDirector:getChildByPath(self.img_baoshicao2, "img_gem")

    self.txt_qianghualv3            = TFDirector:getChildByPath(ui, 'txt_qianghualv3')
    self.txt_starlv 				= TFDirector:getChildByPath(ui, 'txt_starlv')
    self.img_xinfastar					= TFDirector:getChildByPath(ui, 'img_star')
    self.txt_qianghualv3:setVisible(false)
    self.txt_starlv:setVisible(false)
    self.img_xinfastar:setVisible(false)
end

function BagCell:removeUI()
	self.super.removeUI(self)

	self.txt_number			= nil
	self.img_icon  			= nil
	self.img_soul  			= nil
	self.img_select  		= nil
	self.img_star  			= nil
	self.id 				= nil
	self.lbl_num_delim 		= nil
	self.txt_num_max 		= nil
	self.img_already_had	= nil
	self.itemUpdateCallBack = nil
end

function BagCell:setData( item_type,id,isStrategyPiece )
	self.id = id
	self.item_type = item_type 
	self.isStrategyPiece = isStrategyPiece
	self:refreshUI()
end

function BagCell:setLogic(logiclayer)
	self.logic = logiclayer
end

function BagCell:hideRedPoint()
	CommonManager:removeRedPoint(self)
end

function BagCell:refreshRedPoint(value)
	if value ~= nil then
		self:hideRedPoint()
	end

	if not self.item then
		self:hideRedPoint()
		return
	end

	local status = false
	local _type = self.item.itemdata.type
	local _kind = self.item.itemdata.kind
    if _type == EnumGameItemType.Item or _type == EnumGameItemType.Box or _type == EnumGameItemType.RandomPack then
        status = BagManager:isCanPropQuick(self.item)
    elseif _type == EnumGameItemType.Book then
        status = false
    elseif _type == EnumGameItemType.Soul then
        status = BagManager:isRecruitEnabled(self.item)
    elseif _type == EnumGameItemType.Piece and _kind < 6 then
        status = BagManager:isCanMerge(self.item)
    elseif _type == EnumGameItemType.HeadPicFrame then
    	status = BagManager:CanMergeFrame(self.item.itemdata.usable)
    elseif _type == EnumGameItemType.ItemPiece then
    	status,_ = BagManager:CanMergeItem(self.item.itemdata.id)
    -- elseif _type == EnumGameItemType.StrategyPiece then
    	--status = BagManager:CanMergeFrame(self.item.itemdata.usable)
    	-- local maxNum = self:calculateMaxNumberForPiece()
    	-- local currNum = self.item.num
		-- if currNum >= maxNum  then
			-- status = true
		-- end
    else
        status = false
    end

	CommonManager:updateRedPoint(self, status ,ccp(self:getSize().width/2,self:getSize().height/2))
	local timeNow = MainPlayer:getNowtime()
    if self.item.limitTimestamp and self.item.limitTimestamp > 0 and self.item.limitTimestamp - timeNow <= 3600 * 24 then
        CommonManager:updateRedPoint(self, true,ccp(self:getSize().width/2,self:getSize().height/2))
        CommonManager:setRedPointMode(self,2,ccp(self:getSize().width/2,self:getSize().height/2))
    else
        CommonManager:setRedPointMode(self,1,ccp(self:getSize().width/2,self:getSize().height/2))
    end
end
function BagCell:refreshSkyBookRedPoint(value)
	if value ~= nil then
		self:hideRedPoint()
	end

	if not self.item then
		self:hideRedPoint()
		return
	end

	local status = false
	-- local _type = self.item.itemdata.type
	-- local _kind = self.item.itemdata.kind
 --    if _type == EnumGameItemType.Item or _type == EnumGameItemType.Box or _type == EnumGameItemType.RandomPack then
 --        status = BagManager:isCanPropQuick(self.item)
 --    elseif _type == EnumGameItemType.Book then
 --        status = false
 --    elseif _type == EnumGameItemType.Soul then
 --        status = BagManager:isRecruitEnabled(self.item)
 --    elseif _type == EnumGameItemType.Piece and _kind < 6 then
 --        status = BagManager:isCanMerge(self.item)
 --    elseif _type == EnumGameItemType.HeadPicFrame then
 --    	status = BagManager:CanMergeFrame(self.item.itemdata.usable)
 --    else
 --        status = false
 --    end

	CommonManager:updateRedPoint(self, status ,ccp(self:getSize().width/2,self:getSize().height/2))
end

function BagCell:calculateMaxNumberForSoul()
	local roleData = RoleData:objectByID(self.item.itemdata.usable)
	if roleData then
		return roleData.merge_card_num
	else
		return 0
	end
end

function BagCell:calculateMaxNumberForPiece()
	local itemdata= self.item.itemdata
	if itemdata.type == EnumGameItemType.StrategyPiece then
		local num = BattleArrayData:getComposeNumByPieceId( itemdata.id )
		print("itemdata.id = ",itemdata.id)
		print("num = ",num)
		return num
	elseif itemdata.kind < 6 then
		local equipmentTemplate = EquipmentTemplateData:findByPieceId(itemdata.id)
		if equipmentTemplate ~= nil then
			return equipmentTemplate.merge_num
		else
			return 0
		end
	elseif itemdata.kind == 10 then
		local martialTemplate,tmpNum = MartialData:findByMaterial(itemdata.id)
		if martialTemplate ~= nil then
			return tmpNum
		else
			return 0
		end
	elseif itemdata.kind == 25 then
		local itemPieceData = ItemPieceMergeData:getObjectByPieceId(itemdata.id)
		if itemPieceData ~= nil then
			return itemPieceData.fragment_num
		else
			return 0
		end
	end
	local id = itemdata.id or 0
	toastMessage(stringUtils.format(localizable.common_error, "id  "..id))
	return 0
end

function BagCell:isPiece()
	local _type = self.item.itemdata.type
	if _type == EnumGameItemType.Piece or _type == EnumGameItemType.Soul then
		return true
	end
	return false
end

function BagCell:showNumber()
	local _type = self.item.itemdata.type
	self.txt_num_max:setVisible(true)
	if _type == EnumGameItemType.Piece or _type == EnumGameItemType.StrategyPiece then
        self.txt_number:setVisible(true)
        self.lbl_num_delim:setVisible(true)
        self.txt_num_max:setText(self:calculateMaxNumberForPiece())
		self.txt_number:setText(self.item.num)
	elseif _type == EnumGameItemType.Soul then
		if self.item.itemdata.kind == 3 then
			self.txt_number:setVisible(false)
        	self.lbl_num_delim:setVisible(false)
        	self.txt_num_max:setText(self.item.num)
		else
			self.txt_number:setVisible(true)
        	self.lbl_num_delim:setVisible(true)
        	self.txt_num_max:setText(self:calculateMaxNumberForSoul())
			self.txt_number:setText(self.item.num)
		end
		
    else
    	self.txt_number:setVisible(false)
        self.lbl_num_delim:setVisible(false)
        self.txt_num_max:setText(self.item.num)
	end
end

function BagCell:updateIcon()
	local item = self.item
	self.btn_node:setTextureNormal(GetColorIconByQuality_82(item:getData().quality))

	local rewardItem = {itemid = item.id}

	if item.type == EnumGameItemType.Soul and item.kind ~= 3 then
		self:updateIconForSoul()
	else
		self.img_already_had:setVisible(false)
		self.img_icon:setTexture(item:GetTextrue())
	end
	Public:addPieceImg(self.img_icon,rewardItem,nil,1.0)
end

function BagCell:updateIconForSoul()
	local item = self.item
	if item.kind == 2 then
		self.img_icon:setTexture(MainPlayer:getIconPath())
	else
		local role = RoleData:objectByID(item.itemdata.usable)
		if role == nil then
			self.img_icon:setTexture(item:GetTextrue())
		else
			self.img_icon:setTexture(role:getIconPath())
		end
	end
	--验证是否已经拥有该角色
	local partner = CardRoleManager:getRoleById(item.itemdata.usable)
	if partner then
		self.img_already_had:setVisible(true)
	else
		self.img_already_had:setVisible(false)
	end
end

function BagCell:updateSelectedImg()
	--是否选中
	if self.logic  and self.logic.selectId and self.logic.selectId == self.id  then
		self.img_select:setVisible(true)
	else
		self.img_select:setVisible(false)
	end
end

function BagCell:refreshUI()
	if not self.id then
        self.panel_empty:setVisible(true)
        self.panel_info:setVisible(false)
        self:hideRedPoint()
        return false
    end
    self.img_baoshicao:setVisible(false)
    self.img_baoshicao2:setVisible(false)
    self.img_gem:setVisible(false)
    self.img_gem2:setVisible(false)
    self.txt_qianghualv2:setVisible(false)
    self.txt_qianghualv3:setVisible(false)
    self.txt_starlv:setVisible(false)
    self.img_xinfastar:setVisible(false)
    if self.item_type == EnumGameItemType.SkyBook then
		self:refreshSkyBookByInstance(self.id)
	elseif self.item_type == EnumGameItemType.StrategyCard then
		self:refreshStrategyCardByInstance(self.id)
	elseif self.item_type == EnumGameItemType.XinFa or self.item_type == EnumGameItemType.XinFaPiece then 
		self:refreshXinFaByInstance(self.id)
	elseif self.item_type == EnumGameItemType.MiYao then
		self:refreshMiYaoInstance(self.id, self.item_type)
    else
		self:refreshItemById(self.id)
    end
end

function BagCell:refreshItemById(id  )
	local item = BagManager:getItemById(id)
	if item == nil  then
		self.panel_empty:setVisible(true)
        self.panel_info:setVisible(false)
        self:hideRedPoint()
		return false
	end
	self.item = item

	self.panel_empty:setVisible(false)
    self.panel_info:setVisible(true)
	self:updateIcon()
	self:showNumber()
	self:updateSelectedImg()
	self:refreshRedPoint()
	self.txt_qianghualv:setVisible(false)
	self.panel_star:setVisible(false)
	Public:addStarImg(self.img_icon, 0)
end
function BagCell:refreshSkyBookByInstance( instanceId )
	local item = SkyBookManager:getItemByInstanceId(instanceId)
	if item == nil  then
		self.panel_empty:setVisible(true)
        self.panel_info:setVisible(false)
		return false
	end
	self.item = item
	self.panel_empty:setVisible(false)
    self.panel_info:setVisible(true)

	--self:updateIcon()
	--self:showNumber()
    self.img_icon:setTexture(item:GetTextrue())


    local rewardItem = {itemid = item.id}

	Public:addPieceImg(self.img_icon,rewardItem,false)
	local _quality = SkyBookManager:GetUpQuality(item.quality, item.tupoLevel)
    self.btn_node:setTextureNormal(GetColorIconByQuality_82(_quality))
    --self.txt_number:setText(SkyBookManager:getNumByInstanceId(item.instanceId))
    -- self.txt_number:setVisible(true)
    if item.level == 0 then
        self.txt_qianghualv:setVisible(false)
    else
        --self.txt_qianghualv:setText(EnumSkyBookLevelType[item.level] .. "重")
        local str = stringUtils.format(localizable.common_chong, EnumSkyBookLevelType[item.level])
        self.txt_qianghualv:setText(str)
        self.txt_qianghualv:setVisible(true)
    end

    Public:addStarImg(self.img_icon, item.tupoLevel)

	self:updateSelectedImg()
    self.txt_number:setVisible(false)
	self:refreshSkyBookRedPoint()

	self.txt_num_max:setVisible(false)
    self.lbl_num_delim:setVisible(false)
    self.img_already_had:setVisible(false)

    --若天书中无精要,则不显示重数
    local status = 0
    for i = 1, item.maxStoneNum do        
        if item:getStonePos(i) and self.item:getStonePos(i) > 0 then
            status = 1
        end
    end
    if status == 0 and item.level == 1 then
        self.txt_qianghualv:setVisible(false) 
    end

    self.img_baoshicao:setScale(0.8)
    self.img_baoshicao:setVisible(false)
    self.img_baoshicao2:setScale(0.8)
    self.img_baoshicao2:setVisible(false)

    self.img_gem:setVisible(true)
    self.img_gem2:setVisible(true)
    if item:getGemPos(1) and item:getGemPos(1) ~= 0 then
        local gemId = item:getGemPos(1)
        self.img_baoshicao:setVisible(true)
        local item1 = ItemData:objectByID(gemId)
        self.img_gem:setTexture(item1:GetPath())
    end
    if item:getGemPos(2) and item:getGemPos(2) ~= 0 then
        local gemId = item:getGemPos(2)
        self.img_baoshicao2:setVisible(true)
        local item1 = ItemData:objectByID(gemId)
        self.img_gem2:setTexture(item1:GetPath())
    end
end

function BagCell:refreshStrategyCardByInstance( instanceId )
	local item = StrategyCardManager:getStrategyCardByGmid(instanceId)
	if item == nil  then
		self.panel_empty:setVisible(true)
        self.panel_info:setVisible(false)
		return false
	end
	self.item = item
	self.panel_empty:setVisible(false)
    self.panel_info:setVisible(true)
    self.img_icon:setTexture(item:getPath())

    local rewardItem = {itemid = item.id}

	Public:addPieceImg(self.img_icon,rewardItem,false)
    self.btn_node:setTextureNormal(GetColorIconByQuality_82(item:getQuality()))
    self.txt_qianghualv:setVisible(false)

    Public:addStarImg(self.img_icon, item.starLevel,47)

	if item.level == 0 then
        self.txt_qianghualv2:setVisible(false)
    else
        self.txt_qianghualv2:setText("+"..item.level)
        self.txt_qianghualv2:setVisible(true)
    end

	self:updateSelectedImg()
    self.txt_number:setVisible(false)
	self:refreshSkyBookRedPoint()


	self.txt_num_max:setVisible(false)
    self.lbl_num_delim:setVisible(false)
    self.img_already_had:setVisible(false)


    self.img_baoshicao:setVisible(false)
    self.img_gem:setVisible(false)
end
--心法
function BagCell:refreshXinFaByInstance( instanceId )
	local item = XinFaManager:getXinFaByGmId(instanceId)
	if item == nil  then
		self.panel_empty:setVisible(true)
        self.panel_info:setVisible(false)
		return false
	end
	self.item = item
	self.panel_empty:setVisible(false)
    self.panel_info:setVisible(true)
    self.img_icon:setTexture(item.config:GetPath())
    self.txt_starlv:setVisible(false)

    local rewardItem = {itemid = item.config.id}

	Public:addPieceImg(self.img_icon,rewardItem,nil)
    self.btn_node:setTextureNormal(GetColorIconByQuality_82(item.config.quality))
    self.txt_qianghualv:setVisible(false)

    Public:addStarImg(self.img_icon, 0)

	self:updateSelectedImg()
    self.txt_number:setVisible(false)
	self:refreshSkyBookRedPoint()


	self.txt_num_max:setVisible(false)
    self.lbl_num_delim:setVisible(false)
    self.img_already_had:setVisible(false)


    self.img_baoshicao:setVisible(false)
    self.img_gem:setVisible(false)
    if item.config.type == 36 then 
    	self.txt_num_max:setVisible(true)
    	self.txt_num_max:setText(item.number)
    elseif  item.config.type == 35 then 
    	 if item.level > 1 then
    	 	self.txt_qianghualv3:setVisible(true)
    	 	self.txt_qianghualv3:setText("+"..item.level)
    	 end
    	 if item.star > 0 then
    		self.txt_starlv:setVisible(true)
    		self.img_xinfastar:setVisible(true)
    		self.txt_starlv:setText(item.star)
    	 end
    end
end

--秘要
function BagCell:refreshMiYaoInstance( instanceId,typeId )
	local item =BagManager:getMiYaoByType(0, instanceId)
	if item == nil  then
		self.panel_empty:setVisible(true)
        self.panel_info:setVisible(false)
		return false
	end
	
	self.item = item.itemdata
	self.panel_empty:setVisible(false)
    self.panel_info:setVisible(true)
    self.img_icon:setTexture(self.item:GetPath())
    self.img_xinfastar:setVisible(false)


    local rewardItem = {itemid = self.item.id}

	Public:addPieceImg(self.img_icon,rewardItem,false)
    self.btn_node:setTextureNormal(GetColorIconByQuality_82(self.item.quality))
    self.txt_qianghualv:setVisible(false)

	self:updateSelectedImg()
    self.txt_number:setVisible(false)
	self:refreshSkyBookRedPoint()
	self.txt_qianghualv:setVisible(false)
	if (item.level > 0) then
		local str = stringUtils.format(localizable.Tianshu_MiYai_Tips1, numberToChinese(item.level))
		self.txt_qianghualv:setText(str)
		self.txt_qianghualv:setVisible(true)
	end

	self.txt_num_max:setVisible(false)
    self.lbl_num_delim:setVisible(false)
    self.img_already_had:setVisible(false)


    self.img_baoshicao:setVisible(false)
    self.img_gem:setVisible(false)
	--
	Public:addStarImg(self.img_icon, 0)
end

function BagCell.iconBtnClickHandle(sender)
	local self = sender.logic
	if self.logic then
		self.logic:tableCellClick(self)
	end
end


function BagCell:setChoice( b )
    self.img_select:setVisible(b)
end

function BagCell:registerEvents()
	self.super.registerEvents(self)

	self.itemUpdateCallBack = function (event)
       if event.data[1] ==  self.id then
            self:refreshUI()
        end
    end
    TFDirector:addMEGlobalListener(BagManager.ItemChange,self.itemUpdateCallBack)
    self.btn_node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.iconBtnClickHandle,play_xuanz))
end
function BagCell:removeEvents()
    self.super.removeEvents(self)
    TFDirector:removeMEGlobalListener(BagManager.ItemChange,self.itemUpdateCallBack)
    self.btn_node:removeMEListener(TFWIDGET_CLICK)
end

function BagCell:getSize()
	return self.ui:getSize()
end

return BagCell
