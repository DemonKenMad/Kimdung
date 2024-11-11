--角色突破
local RoleStarUpPreviewLayer = class("RoleStarUpPreviewLayer", BaseLayer)

function RoleStarUpPreviewLayer:ctor(data)

	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.role_new.RoleStarUpPreview")

end

function RoleStarUpPreviewLayer:initUI( ui )

	self.super.initUI(self, ui)
	self.Panel_RoleStarUp = TFDirector:getChildByPath(ui,"Panel_RoleStarUp")

	local panel_list_btn = TFDirector:getChildByPath(ui,"panel_list_btn")


	self.Btn_tupo = TFDirector:getChildByPath(panel_list_btn,"Btn_tupo")
	self.Btn_tupo.logic = self
	self.btn_close = TFDirector:getChildByPath(ui, "btn_close")
	self.btn_close.logic = self

	self.btn_shengpin = TFDirector:getChildByPath(ui, "btn_shengpin")
	self.btn_shengpin.logic = self

	--超级技能
	self.btn_superSkill = TFDirector:getChildByPath(ui, "btn_superSkill")
	self.btn_superSkill.logic = self

	self.txt_suoxu = TFDirector:getChildByPath(ui,'txt_suoxu')

	self.star = {}
	for i=1,5 do
		self.star[i] = TFDirector:getChildByPath(ui, "img_star_light_"..i)
		self.star[i]:setVisible(false)
	end
	self.heroPanel = TFDirector:getChildByPath(ui,"panel_list1")
	self.panel_list_btn = TFDirector:getChildByPath(ui,"panel_list_btn")

	--detail
	self.img_attr = {}
	for i=1,5 do
		self.img_attr[i] = TFDirector:getChildByPath(ui,"img_attr"..i)
		self.img_attr[i].txt_curr = TFDirector:getChildByPath(self.img_attr[i],"txt_base")
		self.img_attr[i].txt_next = TFDirector:getChildByPath(self.img_attr[i],"txt_new")
		self.img_attr[i].Img_to = TFDirector:getChildByPath(self.img_attr[i],"Img_to")
	end

	self.icon_panel = TFDirector:getChildByPath(panel_list_btn,"icon_panel")

	self.txt_levelLimit = TFDirector:getChildByPath(ui,"txt_levelLimit")
	self.txt_wnxiahun = TFDirector:getChildByPath(ui,"txt_wnxiahun")

	--创建TabView
	self.right_panel = TFDirector:getChildByPath(ui,"bg_tupo")
    self.TabViewUI = TFDirector:getChildByPath(self.right_panel, "panel_list")
    self.TabView =  TFTableView:create()
    self.TabView:setTableViewSize(self.TabViewUI:getContentSize())
    self.TabView:setDirection(TFTableView.TFSCROLLVERTICAL)    
    self.TabView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    self.TabView.logic = self
    --self.TabViewUI:getParent():addChild(self.TabView)
    self.TabViewUI:addChild(self.TabView)
    self.TabViewUI_size = self.TabViewUI:getContentSize()

    self.iconBuff = {}

    self.skillUpLayerVisible = false
end

function RoleStarUpPreviewLayer:removeUI()
	
	self.super.removeUI(self)

end

function RoleStarUpPreviewLayer:dispose()

end

function RoleStarUpPreviewLayer:onShow()
	self:refreshUI()
	if self.firstShow == true then
    	self.ui:runAnimation("Action0",1);
    	self.firstShow = false

        if self.skillUpLayer then
        	self.skillUpLayer:setVisible(false)
        	self.skillUpLayerVisible = false
 			self.panel_list_btn:setVisible(true)
        end	 
    end

    if self.TabView then
    	local offset_position = {}--= {6,6,5,4,3,2,1,0,0}
    	for i=1,self.cardRole.maxStar do
    		if i == 1 or i == 2 then
    			offset_position[i] = self.cardRole.maxStar - 2
    		else
    			offset_position[i] = self.cardRole.maxStar - i
    		end    		
    	end
        
    	offset_position[self.cardRole.maxStar + 1] = 0
        local lev = math.min(self.cardRole.maxStar, self.cardRole.starlevel+1)
    	local offset = offset_position[lev]

    	self.TabView:setContentOffset(ccp(0,-(118*offset)))
    end
end

function RoleStarUpPreviewLayer:refreshUI()

	if self.roleGoodsList == nil then
		self.roleGoodsList = TFArray:new()
	else
		self.roleGoodsList:clear()
	end
	if self.cardRole.starlevel < self.cardRole.maxStar then
		local RoleStarLevelInfo = self.roleInfoList:getObjectAt(self.cardRole.starlevel+1)
		local item = {}
		item.id = self.cardRole.soul_card_id
		item.num = RoleStarLevelInfo.soul_num
		self.roleGoodsList:push(item)
		if #RoleStarLevelInfo.other_goods_id > 0 then
			local activity	= string.split(RoleStarLevelInfo.other_goods_id,'_')
			local itemGood = {}
			itemGood.id	 = tonumber(activity[1])
			itemGood.num = tonumber(activity[2])
			self.roleGoodsList:push(itemGood)
		end

		self.levelLimit = RoleStarLevelInfo.role_level or 0
		--self.txt_levelLimit:setText("需求等级:"..self.levelLimit)
		self.txt_levelLimit:setText(stringUtils.format(localizable.roleStartupPre_needlevel,self.levelLimit))
	end

	local roleConfig = RoleData:objectByID(self.cardRole.id)
	local omnipotentSoulNum , omnipotentSoulList = BagManager:getOmnipotentSoulNumByQuality(roleConfig.quality)
	if omnipotentSoulNum > 0 then
		self.txt_wnxiahun:setVisible(true)
		local txt = stringUtils.format(localizable.roleStartupPre_omnipotentSoulNum,omnipotentSoulList:getObjectAt(1).name , omnipotentSoulNum)
		self.txt_wnxiahun:setText(txt)
	else
		self.txt_wnxiahun:setVisible(false)
	end


	self:onShowLeftInfo()
	self:onShowRightInfo()

	if self.TabView then
		self.TabView:reloadData()
		self.TabView:setScrollToBegin()
	end
	
end

function RoleStarUpPreviewLayer:registerEvents()
	self.super.registerEvents(self)

	self.Btn_tupo:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onTupoClickHandle),1)
	self.btn_close:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onCloseClickHandle),1)
	self.btn_shengpin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShengpingClickHandle),1)
	self.btn_superSkill:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSuperSkillClickHandle),1)

	--注册TabView事件
    self.TabView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
    self.TabView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
    self.TabView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)

    self.RoleStarUpResultCallBack = function (event)
        self:onUpStarUpCompelete()
    end
    TFDirector:addMEGlobalListener(CardRoleManager.ROLE_PRACTICE_RESULT,self.RoleStarUpResultCallBack)

    self.RoleBreakthroughResultCallBack = function (event)
    	if self.refreshRole then
        	self:refreshRole()
        end
    end
    TFDirector:addMEGlobalListener(CardRoleManager.ROLE_BREAKTHROUGH_RESULT,self.RoleBreakthroughResultCallBack)
end

function RoleStarUpPreviewLayer:removeEvents()
    self.super.removeEvents(self)
  	self.Btn_tupo:removeMEListener(TFWIDGET_CLICK)
	self.btn_close:removeMEListener(TFWIDGET_CLICK)
	self.btn_shengpin:removeMEListener(TFWIDGET_CLICK)
	self.btn_superSkill:removeMEListener(TFWIDGET_CLICK)

	self.TabView:removeMEListener(TFTABLEVIEW_SIZEFORINDEX)
    self.TabView:removeMEListener(TFTABLEVIEW_SIZEATINDEX)
    self.TabView:removeMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW)

    TFDirector:removeMEGlobalListener(CardRoleManager.ROLE_PRACTICE_RESULT,self.RoleStarUpResultCallBack)
    self.RoleStarUpResultCallBack = nil

    TFDirector:removeMEGlobalListener(CardRoleManager.ROLE_BREAKTHROUGH_RESULT,self.RoleBreakthroughResultCallBack)
    self.RoleBreakthroughResultCallBack = nil
end

function RoleStarUpPreviewLayer:SetData(gmId)
	self.gmId = gmId
	self.firstShow = true
	self.bShowTuPu = nil

	local cardRole = CardRoleManager:getRoleByGmid( self.gmId )
	self.cardRole = clone(cardRole)
	self.roleInfoList = RoleTalentData:GetRoleStarInfoByRoleId( self.cardRole.id, self.cardRole.quality)

	self.Btn_tupo:setVisible(true)
	self.txt_suoxu:setVisible(true)
	self.txt_levelLimit:setVisible(true)
	-- self.txt_wnxiahun:setVisible(true)
	self.icon_panel:setVisible(true)

	local roleConfig = RoleData:objectByID(self.cardRole.id)
	local omnipotentSoulNum , omnipotentSoulList = BagManager:getOmnipotentSoulNumByQuality(roleConfig.quality)
	if omnipotentSoulNum > 0 then
		self.txt_wnxiahun:setVisible(true)
		local txt = stringUtils.format(localizable.roleStartupPre_omnipotentSoulNum,omnipotentSoulList:getObjectAt(1).name , omnipotentSoulNum)
		self.txt_wnxiahun:setText(txt)
	else
		self.txt_wnxiahun:setVisible(false)
	end
	local verLock = VersionLockData:objectByID(EnumVersionLockType.RoleGradeUp_Lock)
    if verLock and verLock.open == 0 then
        self.btn_shengpin:setVisible(false)
    else
    	local bQualityUp = CardRoleManager:getShengPingByCard(self.cardRole)
		self.btn_shengpin:setVisible(bQualityUp)
		local bCanGradeUp = CardRoleManager:checkCanGradeUp( self.cardRole )
		print('bCanGradeUp = ',bCanGradeUp)
		Public:addBtnWaterEffect(self.btn_shengpin, bCanGradeUp,1)
    end
	
end

function RoleStarUpPreviewLayer:setDataInTupu(cardRole)
	self.bShowTuPu = true
	self.firstShow = true

	self.cardRole = cardRole
	self.roleInfoList = RoleTalentData:GetRoleStarInfoByRoleId( self.cardRole.id, self.cardRole.quality)

	self.Btn_tupo:setVisible(false)
	self.txt_suoxu:setVisible(false)
	self.txt_levelLimit:setVisible(false)
	self.txt_wnxiahun:setVisible(false)
	self.icon_panel:setVisible(false)

	self.btn_shengpin:setVisible(false)
end

function RoleStarUpPreviewLayer.onTupoClickHandle( sender )
	local self = sender.logic

	if self.cardRole.level < self.levelLimit then   
        CommonManager:showOperateSureLayer(
            function()                
            end,
            function()
                AlertManager:close()
            end,
            {
            --title = "提示" ,
            --msg = "侠客等级不足",
            title = localizable.common_tips ,
            msg = localizable.roleStartupPre_player,
            uiconfig = "lua.uiconfig_mango_new.common.OperateSure1"
            }
        )
	    return
    end
	
	local roleConfig = RoleData:objectByID(self.cardRole.id)
	local omnipotentSoulNum , omnipotentSoulList = BagManager:getOmnipotentSoulNumByQuality(roleConfig.quality)
	local hasSoul = self.cardRole:getHaveSoulNum() + omnipotentSoulNum
    if hasSoul < self.cardRole:getUpstarNeedSoulNum() then

        if self.cardRole:getIsMainPlayer() then
            --self:gotoEmploy()
            --toastMessage("请前往摩诃崖获取更多的主角侠魂")
            toastMessage(localizable.roleInfoLayer_py_goto)
        else
        	if self.cardRole.quality == 5 and self.cardRole.id ~= 2 and self.cardRole.id ~= 13 then
			    if ResGetWayManager:openResGetLayer(roleConfig.soul_card_id,EnumDropType.GOODS,{19,2}) == true then
		    		return
		    	end

		    elseif self.cardRole.quality == 4 then
			    if ResGetWayManager:openResGetLayer(roleConfig.soul_card_id,EnumDropType.GOODS,{19}) == true then
		    		return
		    	end

		    elseif self.cardRole.quality < 4  then
			    if ResGetWayManager:openListShow({19}) == true then
		    		return
		    	end

            end
            --CommonManager:showNeedRoleComfirmLayer()
            local layer = AlertManager:addLayerByFile("lua.logic.common.NoticeLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1);
		    --layer:setTitle("侠魂不足")
		    layer:setTitle(localizable.roleStartupPre_xiahun)
		    --[[
		    local Msg = {
		    	"1.可使用侠义值在酒馆侠魂商店中兑换",
		    	"2.可在商店中购买",
		    	"3.可在群豪谱处使用积分兑换",
		    	"4.可在宗师关卡中获得",
		    	"5.可在雁门关、摩诃崖获得侠魂"
			}
			]]
			local Msg = localizable.roleStartupPre_msg
			if self.cardRole.quality >= 6 or self.cardRole.id == 2 or self.cardRole.id == 13 then
				Msg = localizable.roleStartupPre_msg_0
			end
			layer:setMsg(Msg);
			layer:setBtnHandle(function ()			    
		    end,function ()
		    end);
		    AlertManager:show();
        end
        return
    end

    local goodsItem = self.roleGoodsList:getObjectAt(2)
    if goodsItem then
	    local itemNumInBag = BagManager:getItemNumById( goodsItem.id )
	    if itemNumInBag < goodsItem.num then
            if ResGetWayManager:openResGetLayer(goodsItem.id,EnumDropType.GOODS) == true then
                return
            end
			CommonManager:showOperateSureLayer(
	            function()                
	            end,
	            function()
	                AlertManager:close()
	            end,
	            {
	            --title = "提示" ,
	            title = localizable.common_tips ,
	           -- msg = "突破道具不足",
	            msg = localizable.roleStartupPre_pro,
	            uiconfig = "lua.uiconfig_mango_new.common.OperateSure1"
	            }
	        )	
		    return    	
	    end
	end


    self.oldarr = {}
    --角色属性
    for i=1,EnumAttributeType.Max do
        self.oldarr[i] = self.cardRole:getTotalAttribute(i)
    end

    self.old_quality = self.cardRole.quality
    self.old_starlevel = self.cardRole.starlevel
    self.old_power = self.cardRole.power
	Maxstar = self.cardRole.maxStar
	if (self.old_starlevel >= Maxstar and self.old_quality < CardRoleManager.MaxQuality ) then
		toastMessage(localizable.roleStartupPre_pro_tips)
		return
	end

    if self.cardRole:getHaveSoulNum() < self.cardRole:getUpstarNeedSoulNum() and omnipotentSoulNum > 0 then
		local omnipotentSoul = omnipotentSoulList:getObjectAt(1)
		local needNum = self.cardRole:getUpstarNeedSoulNum() - self.cardRole:getHaveSoulNum()
		CommonManager:showOperateSureLayer(
			function()
				CardRoleManager:roleStarUp( self.cardRole.gmId ,0,1,1)
			end,
			nil,
			{
				msg = stringUtils.format(localizable.roleStartupPre_useOmnipotentSoul,omnipotentSoul.name.."x"..needNum)
			}
		)
			return
    else
		CardRoleManager:roleStarUp( self.cardRole.gmId  )
    end
    -- local layer =  AlertManager:addLayerByFile("lua.logic.role_new.RoleStarUpResultNewLayer", AlertManager.BLOCK_AND_GRAY)
    -- layer:loadData(self.cardRole.gmId,self.oldarr,self.old_power)
    -- layer:setOldValue(self.old_quality, self.old_starlevel)
    -- AlertManager:show()
end

function RoleStarUpPreviewLayer.onCloseClickHandle( sender )
	local self = sender.logic
	
	if self.skillUpLayerVisible then 
    	--隐藏
        local layer = self.skillUpLayer
    	self.skillUpLayerVisible = false  
 		self.panel_list_btn:setVisible(true)
	    layer.ui:runAnimation("Action1",1);
	            layer.ui:setAnimationCallBack("Action1", TFANIMATION_END, function()
        		layer:setVisible(false)
        	end)
	else
		AlertManager:close(AlertManager.TWEEN_NONE)
	end
end

function RoleStarUpPreviewLayer.onShengpingClickHandle(sender)
	print("onShengpingClickHandle")
	local self = sender.logic
	local layer =  AlertManager:addLayerByFile("lua.logic.role_new.RoleGradeUp", AlertManager.BLOCK_AND_GRAY)
    layer:loadData(self.cardRole.gmId,self)
    AlertManager:show()
end

function RoleStarUpPreviewLayer.onSuperSkillClickHandle( sender )
	print("onSuperSkillClickHandle")
	local self = sender.logic
	--local layer =  AlertManager:addLayerByFile("lua.logic.role_new.RoleSkillUp", AlertManager.BLOCK,AlertManager.TWEEN_NONE)
	local layer
	if self.skillUpLayer then 
		layer = self.skillUpLayer
	else 		
		layer = require("lua.logic.role_new.RoleSkillUp"):new()	
	  	self.Panel_RoleStarUp:addChild(layer,100)
        self.skillUpLayer = layer
    end
    layer:loadData(self.cardRole)
    if self.skillUpLayerVisible then 
    	--隐藏
    	self.skillUpLayerVisible = false  
 		self.panel_list_btn:setVisible(true)
        layer.ui:runAnimation("Action1",1)
         layer.ui:setAnimationCallBack("Action1", TFANIMATION_END, function()
        		layer:setVisible(false)
        	end)

	    --layer:show()
    else
    	--显示
    	self.skillUpLayerVisible = true 	
    	layer:setVisible(true)
	    layer.ui:runAnimation("Action0",1);
	    layer.ui:setAnimationCallBack("Action0", TFANIMATION_END, function()
        	self.panel_list_btn:setVisible(false) 
        	end)
	    layer:show()
    end	  
   
end


function RoleStarUpPreviewLayer:refreshRole()
	local cardRole = CardRoleManager:getRoleByGmid( self.gmId )
	self.cardRole = clone(cardRole)
	self:refreshUI()
end

function RoleStarUpPreviewLayer:onShowLeftInfo()
	if self.cardRole == nil then
		print("cannot find the role card by gmId",self.gmId)
		return;
	end
	-- for i=1,5 do
	-- 	if i <= self.cardRole.starlevel then
	-- 		self.star[i]:setVisible(true)
	-- 	else
	-- 		self.star[i]:setVisible(false)
	-- 	end
	-- end	
	for i=1,5 do
		self.star[i]:setVisible(false)
	end

	CardRoleManager:SetRoleStarTexture(self.cardRole.starlevel, self.star)
	if self.heroPanel.img then
		self.heroPanel.img:setTexture(self.cardRole:getBigImagePath())
	else
		local img_role = TFImage:create(self.cardRole:getBigImagePath())
	    --img_role:setScale(0.65)
        img_role:setScale(0.8)
	    img_role:setFlipX(true)
	    img_role:setAnchorPoint(ccp(0.5,0.5))
        local size = self.heroPanel:getContentSize()
	    img_role:setPosition(ccp(size.width/2,size.height/2 + 40))
	    self.heroPanel.img = img_role
		self.heroPanel:addChild(img_role)
	end

	local verLock = VersionLockData:objectByID(EnumVersionLockType.RedCardRole_Lock)
    if verLock and verLock.open == 0 then
        self.btn_superSkill:setVisible(false)
    else
	if self.cardRole.quality >= 6 then 
			self.btn_superSkill:setVisible(true)
		else
			self.btn_superSkill:setVisible(false)
		end 
    end
			

	if self.bShowTuPu == nil then
		local verLock = VersionLockData:objectByID(EnumVersionLockType.RoleGradeUp_Lock)
	    if verLock and verLock.open == 0 then
	        self.btn_shengpin:setVisible(false)
	    else
		local bQualityUp = CardRoleManager:getShengPingByCard(self.cardRole, true)
			self.btn_shengpin:setVisible(bQualityUp)
	    end
	else
		local verLock = VersionLockData:objectByID(EnumVersionLockType.RedCardRole_Lock)
	    if verLock and verLock.open == 0 then
	        self.btn_superSkill:setVisible(false)
	    else
			if CardRoleManager:getShengPingByCard( self.cardRole ) then
				self.btn_superSkill:setVisible(true)
			end
		end
	end
end

function RoleStarUpPreviewLayer:onShowRightInfo()

	local trainItem_curr = RoleTrainData:getRoleTrainByQuality(self.cardRole.quality, self.cardRole.starlevel,self.cardRole.qualityOne)
    local newCardRoleData = RoleData:objectByID(self.cardRole.id)
    local level_up        = newCardRoleData:GetAttrLevelUp()

    for k,v in pairs(self.iconBuff) do
    	v:removeFromParent()
    end
    self.iconBuff = {}
	local maxStar = self.cardRole.maxStar
	if (self.cardRole.quality < CardRoleManager.MaxQuality) then
		maxStar = self.cardRole.maxStar
	end
	if self.cardRole.starlevel >= maxStar then
		--达到5星最大值
		for i=1,5 do
			local currStar = trainItem_curr.streng_then * level_up[i]	   
			self.img_attr[i].txt_curr:setText(currStar)
			self.img_attr[i].txt_next:setVisible(false)
			self.img_attr[i].Img_to:setVisible(false)
		end
		self.Btn_tupo:setGrayEnabled(true)
		self.Btn_tupo:setTouchEnabled(false)
		self.txt_levelLimit:setVisible(false)
		return;
	else
		for i=1,5 do
			self.img_attr[i].txt_next:setVisible(true)
			self.img_attr[i].Img_to:setVisible(true)
		end
		self.Btn_tupo:setGrayEnabled(false)
		self.Btn_tupo:setTouchEnabled(true)
		self.txt_levelLimit:setVisible(true)
	end	

    local trainItem_next = RoleTrainData:getRoleTrainByQuality(self.cardRole.quality, self.cardRole.starlevel+1 ,self.cardRole.qualityOne) 
	for i=1,5 do        
	    local currStar = trainItem_curr.streng_then * level_up[i]
	    local nextStar = trainItem_next.streng_then * level_up[i]
		self.img_attr[i].txt_curr:setText(currStar)
		self.img_attr[i].txt_next:setText(nextStar)
    end

    if self.bShowTuPu == nil then
	    for i=1,self.roleGoodsList:size() do
	    	local item = self.roleGoodsList:getObjectAt(i)
	    	print("self.roleGoodsList = ",self.roleGoodsList.m_list)
	    	local icon = require('lua.logic.role_new.RoleStarUpPreviewNumCell'):new()
	    	icon:setPosition(ccp((i-1)*(self.icon_panel:getContentSize().width + 10), 0))
	    	local curr_num = BagManager:getItemNumById( item.id )
	    	icon:setData(item.id,curr_num,item.num)
	    	self.icon_panel:addChild(icon)
	    	local index = #self.iconBuff
	    	self.iconBuff[index+1] = icon
	    end
	end
end

function RoleStarUpPreviewLayer.cellSizeForTable(table,idx)
    --return 118,465
    return 116.5, 468
end

function RoleStarUpPreviewLayer.tableCellAtIndex(table, idx)

	local self = table.logic
	local cell = table:dequeueCell()

	if cell == nil then
		cell = TFTableViewCell:create()		
	    local panel = require('lua.logic.role_new.RoleStarUpPreviewCell'):new()        

	    local offset_x = self.TabViewUI:getContentSize().width-panel:getContentSize().width

		panel:setPosition(ccp(offset_x/2,0))
	    cell:addChild(panel)
    	cell.panel = panel
	end
	cell.panel:setData(self.cardRole,self.roleInfoList:getObjectAt(idx+1))
    return cell
end

function RoleStarUpPreviewLayer.numberOfCellsInTableView(table)
	local self = table.logic
    return self.cardRole.maxStar
end

function RoleStarUpPreviewLayer:onUpStarUpCompelete()
    -- local layer =  AlertManager:addLayerByFile("lua.logic.role_new.RoleStarUpResultNewLayer", AlertManager.BLOCK_AND_GRAY)
    -- layer:loadData(self.cardRole.gmId,self.oldarr,self.old_power)
    -- layer:setOldValue(self.old_quality, self.old_starlevel)
    -- AlertManager:show()

    local cardRole = CardRoleManager:getRoleByGmid( self.gmId )
	self.cardRole = clone(cardRole)
	local layer = CardRoleManager:openRoleUpLayer(CardRoleManager.upEffectType.roleUpStar)
	layer:initRoleUpStarData(self.gmId, self.old_quality, self.old_starlevel, nil)
	AlertManager:show();
end


return RoleStarUpPreviewLayer