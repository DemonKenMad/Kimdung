--[[
******帮派丹房主界面*******

	-- by sjj
	-- 2018/4/26
	
]]

local FactionDanFangLayer = class("FactionDanFangLayer",BaseLayer)

local column = 3
local itemWight = 169
local itemHeight = 255

function FactionDanFangLayer:ctor(data)

	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.faction.DanFangMain")
end

function FactionDanFangLayer:initUI( ui )

	self.super.initUI(self, ui)
	self.generalHead = CommonManager:addGeneralHead(self)
    self.generalHead:setData(ModuleType.DanFang,{HeadResType.COIN,HeadResType.SYCEE}, true) 
    self.generalHead.bShowEffect = false
    self.btn_help = TFDirector:getChildByPath(ui, "btn_help")

    self.img_jiantou = TFDirector:getChildByPath(ui, "img_jiantou")
    self.btn_emptyCailiao = TFDirector:getChildByPath(ui, "btn_cailiao")
    self.btn_shouqu = TFDirector:getChildByPath(ui, "btn_shouqu")
    --基础材料
    self.iconbg_cailiao = TFDirector:getChildByPath(ui, "iconbg_cailiao")
    self.imgIcon_cailiao = TFDirector:getChildByPath(self.iconbg_cailiao, "img_icon")
    self.txtIcon_cailiao = TFDirector:getChildByPath(self.iconbg_cailiao, "txt_iconsl")
    --进化材料
    self.bg_effect = TFDirector:getChildByPath(ui, "bg_icon")
    self.bg_danlu = TFDirector:getChildByPath(ui, "Panel_zuo")
    self.iconbg_High = TFDirector:getChildByPath(self.bg_danlu, "iconbg")
    self.imgIcon_High = TFDirector:getChildByPath(self.iconbg_High, "img_icon")
    self.txtIcon_High = TFDirector:getChildByPath(self.iconbg_High, "txt_iconsl")
    -- self.iconbg_High:setScale(0.75)
    -- self.bg_effect:setScale(0.75)

    --进度条
    self.img_jindudi = TFDirector:getChildByPath(TFDirector:getChildByPath(ui, "Panel_zuo"), "img_jindudi")
    self.img_loadDi = TFDirector:getChildByPath(self.img_jindudi, "load_di")
    self.txt_myTime = TFDirector:getChildByPath(self.img_jindudi, "txt_time")
    
    
    --今日可助力次数:
    self.txt_cishu = TFDirector:getChildByPath(ui, "txt_cishu")
    -- 丹炉
    self.img_danlu = TFDirector:getChildByPath(ui, "img_danlu")

	self.panel_list = TFDirector:getChildByPath(ui, "Panel_you")
	self.panel_cell_model = TFDirector:getChildByPath(ui, 'img_cellbg' )
    self.panel_cell_model:removeFromParent()
    self.panel_cell_model:retain()




    self.otherLevelUpInfo = clone(FactionDanFangManager:getOtherInfo())
    self.otherPanelData = {}
    -- self.myMaterialData = FactionDanFangManager:getMyMaterialData()
    self:refreshTableView()
    self:refreshMyDanLuUI()
    self:refreshEffect()

    
end

function FactionDanFangLayer:removeUI()
	if self.panel_cell_model then
        self.panel_cell_model:release()
        self.panel_cell_model = nil
    end


    self.super.removeUI(self)
end
function FactionDanFangLayer:onShow()
    self.super.onShow(self)

    -- self:refreshMyDanLuUI()
    self:refreshTableView()
    self:refreshMyTimeNum()
end

function FactionDanFangLayer:registerEvents()
	self.super.registerEvents(self)
	-- ADD_ALERT_CLOSE_LISTENER(self,self.btn_close,AlertManager.TWEEN_NONE)

	self.iconbg_High:addMEListener(TFWIDGET_CLICK,  audioClickfunWithDelegate(self, self.rewardIconButtonClickHandle),1);
	self.iconbg_cailiao:addMEListener(TFWIDGET_CLICK,  audioClickfunWithDelegate(self, self.addMaterialButtonClickHandle),1);
	self.btn_emptyCailiao:addMEListener(TFWIDGET_CLICK,  audioClickfunWithDelegate(self, self.addMaterialButtonClickHandle),1);
	self.btn_shouqu:addMEListener(TFWIDGET_CLICK,  audioClickfunWithDelegate(self, self.collectMaterialButtonClickHandle),1);
	self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfunWithDelegate(self, self.onHelpClick))

	self.onesUpdateCallBack = function(event)
		self:refreshMyTimeNum()
		local refreshId = event.data[1][1]

		self.otherLevelUpInfo = clone(FactionDanFangManager:getOtherInfo())
		self.otherPanelData = {}
		self:refreshTableView()

	end
	TFDirector:addMEGlobalListener(FactionDanFangManager.refreshDanFangMsg, self.onesUpdateCallBack)

	self.myDateCallBack = function(event)
		
		self:refreshMyDanLuUI()	
		self:refreshEffect()	
	end
	TFDirector:addMEGlobalListener(FactionDanFangManager.refreshMyDanFangMsg, self.myDateCallBack)

	if self.generalHead then
     	self.generalHead:registerEvents()
  	end
	self.updateEndTime = TFDirector:addTimer(1000, -1, nil,
        function()
            self:refreshTimeUI(self.myDanFangInfo, self.txt_myTime, self.img_loadDi)
    end)
end

function FactionDanFangLayer:removeEvents()
	self.super.removeEvents(self)

	if self.effect1 then
		self.effect1:removeFromParent()
		self.effect1 = nil
	end
	if self.effect2 then
		self.effect2:removeFromParent()
		self.effect2 = nil
	end
	if self.effect3 then
		self.effect3:removeFromParent()
		self.effect3 = nil
	end
	TFDirector:removeMEGlobalListener(FactionDanFangManager.refreshDanFangMsg, self.onesUpdateCallBack)
	self.onesUpdateCallBack = nil
	TFDirector:removeMEGlobalListener(FactionDanFangManager.refreshMyDanFangMsg, self.myDateCallBack)
	self.myDateCallBack = nil

	if self.updateEndTime then
        TFDirector:removeTimer(self.updateEndTime)
        self.updateEndTime = nil
    end

    if self.generalHead then
        self.generalHead:removeEvents()
    end
end


function FactionDanFangLayer:refreshMyDanLuUI()
	self.myDanFangInfo = FactionDanFangManager:getMyInfo()
	-- print(" FactionDanFangLayer:refreshMyDanLuUI" , self.myDanFangInfo)
	self.iconbg_cailiao:setVisible(false)
	self.iconbg_High:setVisible(false)
	self.btn_shouqu:setVisible(false)
	self.img_jindudi:setVisible(false)
	self.img_loadDi:setVisible(false)
	self.txt_myTime:setVisible(false)
	self.btn_emptyCailiao:setVisible(false)
	self.iconbg_cailiao:setVisible(false)
	self.img_jiantou:setVisible(false)


	--self.myDanFangInfo.state == 1为已领取状态
	if (self.myDanFangInfo == nil or self.myDanFangInfo.id == 0 or self.myDanFangInfo.state == 1) then
		self.btn_emptyCailiao:setVisible(true)
		self.img_jiantou:setVisible(true)
	else
		
		local DanFangInfo = DanFangData:objectByID(self.myDanFangInfo.id)
		
		local heigItemInfo = BaseDataManager:getReward({type = EnumDropType.GOODS, itemId = DanFangInfo.id_shouhuo})
		self.iconbg_High:setTextureNormal(GetColorIconByQuality(heigItemInfo.quality))
		self.imgIcon_High:setTexture(heigItemInfo.path)
		self.iconbg_High:setVisible(true)
		self.txtIcon_High:setText(DanFangInfo.num)
		self.iconbg_High.itemId = DanFangInfo.id_shouhuo
		self.iconbg_High.itemType = EnumDropType.GOODS

		if (MainPlayer:getNowtime() > self.myDanFangInfo.endTime * 0.001) then
		    --可领取
		    self.txt_myTime:setText("00:00:00")
		    self.img_loadDi:setPercent(100)
		    self.btn_shouqu:setVisible(true)
		    self.btn_shouqu:setTouchEnabled(true)
			self.btn_shouqu:setGrayEnabled(false)
		else
			self.btn_shouqu:setVisible(true)
			self.img_jindudi:setVisible(true)
			self.img_loadDi:setVisible(true)
			self.txt_myTime:setVisible(true)
			self.btn_shouqu:setTouchEnabled(false)
			self.btn_shouqu:setGrayEnabled(true)
			self:refreshTimeUI()
		-- else
		-- 	--正在炼化中,不可领取
		-- 	--计算剩余时间
		-- 	local nowTime = MainPlayer:getNowtime()
		--     -- local endDate = math.floor(self.myDanFangInfo.endTime * 0.001 - nowTime)

		--     -- local day = math.floor(endDate / (60 * 60 * 24))
		--     -- local hour = math.floor(endDate / (60 * 60 )% 24)
		--     -- local min = math.floor(endDate / 60 % 60)
		--     -- self.txt_myTime:setText(stringUtils.format(localizable.common_time_3, day, hour, min))
		--     --计算进度条
		-- 	-- self.myDanFangInfo.totalTime
			


		end
	end

end

function FactionDanFangLayer:refreshMyTimeNum()
    local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.DANFANGHELPNUM)
    local times = challengeInfo.currentValue or 0
    self.txt_cishu:setText(times)
end

function FactionDanFangLayer:refreshTimeUI(dataInfo, txt_time, img_loadDi)
	local nowTime = MainPlayer:getNowtime()

	if (dataInfo and dataInfo.endTime) then
		--print("自己的时间",nowTime,self.myDanFangInfo.endTime * 0.001)
		if(nowTime < dataInfo.endTime * 0.001) then
			local endDate = math.floor(dataInfo.endTime * 0.001 - nowTime)
		    local hour = math.floor(endDate / (60 * 60 )% 24)
		    local min = math.floor(endDate / 60 % 60)
		    local sec = math.floor(endDate % 60)
		    txt_time:setVisible(true)
		    txt_time:setText(hour..":"..min..":"..sec)

		    local currTime = nowTime - dataInfo.createTime * 0.001
			local percent = math.ceil(currTime/dataInfo.totalTime*100)
			img_loadDi:setVisible(true)
			img_loadDi:setPercent(percent)
		else
			txt_time:setText("00:00:00")
			img_loadDi:setPercent(100)
			if (dataInfo.playerId == MainPlayer:getPlayerId()) then
				self.btn_shouqu:setTouchEnabled(true)
				self.btn_shouqu:setGrayEnabled(false)
				if (FactionDanFangManager.danFangRedPoint == false) then
					FactionDanFangManager.danFangRedPoint = true
					TFDirector:dispatchGlobalEventWith(FactionManager.updateRedPoint ,{})
				end
			end
		end

	end

    
	-- 别人的时间
	-- if (#self.otherPanelData > 0) then
	-- 	for k,otherInfo in pairs(self.otherLevelUpInfo) do
			
	-- 		if (otherInfo and otherInfo.endTime and self.otherPanelData[otherInfo.key]) then
	-- 			if (nowTime < otherInfo.endTime * 0.001) then
	-- 				local endDate = math.floor(otherInfo.endTime * 0.001 - nowTime)
	-- 			    local hour = math.floor(endDate / (60 * 60)% 24)
	-- 			    local min = math.floor(endDate / 60 % 60)
	-- 			    local sec = math.floor(endDate % 60)

	-- 				local currTime = nowTime - otherInfo.createTime * 0.001
	-- 				local percent = currTime/otherInfo.totalTime*100
	-- 				if (self.otherPanelData[otherInfo.key].load_di) then
	-- 					self.otherPanelData[otherInfo.key].load_di:setPercent(percent)
	-- 				end
	-- 				if (self.otherPanelData[otherInfo.key].txt_time) then
	-- 					self.otherPanelData[otherInfo.key].txt_time:setText(hour..":"..min..":"..sec)
	-- 				end
	-- 				if (self.otherPanelData[otherInfo.key].btn_juanxian) then
	-- 					self.otherPanelData[otherInfo.key].btn_juanxian:setGrayEnabled(false)
	-- 				end
	-- 			else
	-- 				if (self.otherPanelData[otherInfo.key].load_di) then
	-- 					self.otherPanelData[otherInfo.key].load_di:setPercent(100)
	-- 				end
	-- 				if (self.otherPanelData[otherInfo.key].txt_time) then
	-- 					self.otherPanelData[otherInfo.key].txt_time:setText("00:00:00")
	-- 				end
	-- 				if (self.otherPanelData[otherInfo.key].btn_juanxian) then
	-- 					self.otherPanelData[otherInfo.key].btn_juanxian:setGrayEnabled(true)
	-- 				end

	-- 			end
	-- 		end
	-- 	end
	-- end
   
end
function FactionDanFangLayer:refreshTableView()
    if self.tableView == nil then
        local  tableView =  TFTableView:create()
        tableView:setTableViewSize(self.panel_list:getContentSize())
        tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
        tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
        tableView:setPosition(ccp(0, 0))
        self.tableView = tableView
        -- self.tableView.logic = self

        -- tableView:addMEListener(TFTABLEVIEW_TOUCHED, NewSignLayer.tableCellTouched)
        tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, handler(self.cellSizeForTable,self))
        tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, handler(self.tableCellAtIndex,self))
        tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW,handler(self.numberOfCellsInTableView,self))
        -- tableView:reloadData()
        self.panel_list:addChild(self.tableView,1)
    end
    self.tableView:reloadData()
end

function FactionDanFangLayer:cellSizeForTable(table, idx)
	return itemHeight,544
end

function FactionDanFangLayer:tableCellAtIndex(table, idx)
	idx = idx + 1
	local cell = table:dequeueCell()
	
	if nil == cell then
		cell = TFTableViewCell:create()
	end
	cell:removeAllChildren()
	cell:setTag(idx)
	self:setCell(cell, idx)
	return cell
end

function FactionDanFangLayer:numberOfCellsInTableView(table)

	local num = #self.otherLevelUpInfo
	return math.ceil(num/3)--
end

function FactionDanFangLayer:setCell(cell, idx)
	-- local panel = cell.panel

	--for otherInfo in pairs(self.otherLevelUpInfo) do
	
	
	for i=1,column do 
		local helpID = (idx - 1) * column + i
		local panel = cell:getChildByTag(helpID)
		
		local helpInfo = self.otherLevelUpInfo[helpID]
		if (helpInfo) then
			if (panel == nil) then
				panel = self.panel_cell_model:clone() 
				
				panel:setAnchorPoint(ccp(0,0))
				panel:setPosition(ccp((i - 1) * itemWight + 20,0))
				self.otherPanelData[helpInfo.key] = {}
				self.otherPanelData[helpInfo.key].load_di = TFDirector:getChildByPath(panel, 'load_di')
				self.otherPanelData[helpInfo.key].txt_time = TFDirector:getChildByPath(panel, 'txt_time')
				self.otherPanelData[helpInfo.key].btn_juanxian = TFDirector:getChildByPath(panel, 'btn_juanxian')
				self.otherPanelData[helpInfo.key].btn_juanxian.playerId = helpInfo.playerId
				self.otherPanelData[helpInfo.key].btn_juanxian.logic = self
				self.otherPanelData[helpInfo.key].btn_juanxian:addMEListener(TFWIDGET_CLICK,  audioClickfunWithDelegate(self, self.helpOtherButtonClickHandle),1);
				self:refreshTimeUI(helpInfo,self.otherPanelData[helpInfo.key].txt_time, self.otherPanelData[helpInfo.key].load_di)
				cell:addChild(panel,1,helpID)

				local delayTween = {
					target = panel,
					repeated = -1,

					{
						duration = 0,
						delay = 0.5,
						onComplete = function (  )
							-- 刷新时间
							self:refreshTimeUI(helpInfo,self.otherPanelData[helpInfo.key].txt_time, self.otherPanelData[helpInfo.key].load_di)
						end
					}
				}

				TFDirector:toTween( delayTween )
			end
			
			local txt_name = TFDirector:getChildByPath(panel, 'txt_name')
			local btn_iconbg = TFDirector:getChildByPath(panel, 'btn_iconbg')
			local img_icon = TFDirector:getChildByPath(panel, 'img_icon')
			local txt_iconnumber = TFDirector:getChildByPath(panel, 'txt_iconnumber')
			

			-- txt_name:setVisible(false)
			-- btn_iconbg:setVisible(false)
			-- img_icon:setVisible(false)
			-- txt_iconnumber:setVisible(false)
			self.otherPanelData[helpInfo.key].load_di:setVisible(false)
			self.otherPanelData[helpInfo.key].txt_time:setVisible(false)
			self.otherPanelData[helpInfo.key].btn_juanxian:setVisible(false)


			self.otherPanelData[helpInfo.key].load_di:setVisible(true)
			self.otherPanelData[helpInfo.key].txt_time:setVisible(true)
			self.otherPanelData[helpInfo.key].btn_juanxian:setVisible(true)

			txt_name:setText(helpInfo.playerName)
			
			local itemInfo = DanFangData:objectByID(helpInfo.id)
			local iconInfo = BaseDataManager:getReward({type = EnumDropType.GOODS, itemId = itemInfo.id_shouhuo})
			img_icon:setTexture(iconInfo.path)
			btn_iconbg:setTextureNormal(GetColorIconByQuality(iconInfo.quality))
			btn_iconbg:addMEListener(TFWIDGET_CLICK, audioClickfunWithDelegate(self, self.rewardIconButtonClickHandle),1);
			btn_iconbg.itemId = itemInfo.id_shouhuo
			btn_iconbg.itemType = EnumDropType.GOODS
			txt_iconnumber:setText(itemInfo.num)
			if (helpInfo.isHelp) then
				self.otherPanelData[helpInfo.key].btn_juanxian:setTouchEnabled(false)
				self.otherPanelData[helpInfo.key].btn_juanxian:setTextureNormal("ui_new/faction/danfang/btn_yzli.png")
			else
				self.otherPanelData[helpInfo.key].btn_juanxian:setTouchEnabled(true)
				self.otherPanelData[helpInfo.key].btn_juanxian:setTextureNormal("ui_new/faction/danfang/btn_zhuli.png")
			end

			if (helpInfo.endTime * 0.001 <= MainPlayer:getNowtime()) then
				self.otherPanelData[helpInfo.key].btn_juanxian:setGrayEnabled(true)
				self.otherPanelData[helpInfo.key].btn_juanxian:setTouchEnabled(false)
			end
		-- else
		-- 	if (panel) then
		-- 		panel:setVisible(false)

		-- 		txt_name:setVisible(false)
		-- 		btn_iconbg:setVisible(false)
		-- 		img_icon:setVisible(false)
		-- 		txt_iconnumber:setVisible(false)
		-- 		self.otherPanelData[helpInfo.key].load_di:setVisible(false)
		-- 		self.otherPanelData[helpInfo.key].txt_time:setVisible(false)
		-- 		self.otherPanelData[helpInfo.key].btn_juanxian:setVisible(false)


		-- 	end
		end
	end

end

function FactionDanFangLayer:setMaterialLevelUpInfo( levelUpId )
	self.selectId = levelUpId
	local levelUpInfo = FactionDanFangManager:getMyMaterialDataById(levelUpId)

	self.iconbg_cailiao:setVisible(true)
	self.imgIcon_cailiao:setVisible(true)
	self.txtIcon_cailiao:setVisible(true)
	self.iconbg_High:setVisible(true)
	self.imgIcon_High:setVisible(true)
	self.txtIcon_High:setVisible(true)
	self.img_jiantou:setVisible(true)

	local caiLiaoInfo = BaseDataManager:getReward({type = EnumDropType.GOODS, itemId = levelUpInfo.itemId})
	self.iconbg_cailiao:setTextureNormal(GetColorIconByQuality(caiLiaoInfo.quality))
	self.imgIcon_cailiao:setTexture(caiLiaoInfo.path)
	self.txtIcon_cailiao:setText(levelUpInfo.hasNum.."/"..levelUpInfo.needNum)
	if (levelUpInfo.isCanUp) then
		self.txtIcon_cailiao:setColor(ccc3(255,255,255))
	else
		self.txtIcon_cailiao:setColor(ccc3(255,0,0))
	end


	local heigItemInfo = BaseDataManager:getReward({type = EnumDropType.GOODS, itemId = levelUpInfo.upId})
	self.iconbg_High:setTextureNormal(GetColorIconByQuality(heigItemInfo.quality))
	self.imgIcon_High:setTexture(heigItemInfo.path)
	self.txtIcon_High:setText(levelUpInfo.needNum)
	self.iconbg_High.itemId = levelUpInfo.upId
	self.iconbg_High.itemType = EnumDropType.GOODS

end
--查看详细信息
function FactionDanFangLayer:rewardIconButtonClickHandle( sender )
	local itemId = sender.itemId
	local itemType = sender.itemType
	Public:ShowItemTipLayer(itemId, itemType)
end
-- 添加低级耗材
function FactionDanFangLayer:addMaterialButtonClickHandle()

	-- FactionDanFangManager:openMaterialSelectLayer()
	local layer = AlertManager:getLayerByName("lua.logic.faction.FactionDanFangSelectLayer")
	if (layer == nil) then
		FactionDanFangManager:setMyMaterialData()
		local layer = AlertManager:addLayerByFile("lua.logic.faction.FactionDanFangSelectLayer",AlertManager.BLOCK)
		layer:setParentLayer(self, self.selectId)
		AlertManager:show()
		layer.blockUI:setTouchEnabled(false);
	end
end
--领取高级耗材
function FactionDanFangLayer:collectMaterialButtonClickHandle()
	FactionDanFangManager:sendReceiveMsg()
end
--为别人助力
function FactionDanFangLayer:helpOtherButtonClickHandle( sender )
	local playerId = sender.playerId

	local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.DANFANGHELPNUM)
    local times = challengeInfo.currentValue or 0

    if (times <= 0) then
    	toastMessage(localizable.DanFang_tips2)
    else
		FactionDanFangManager:sendHelpInfo( playerId )
	end
end

function FactionDanFangLayer:onHelpClick()
    FactionDanFangManager:showRuleLayer()
end

--正在炼丹的时候添加特效
function FactionDanFangLayer:refreshEffect()

	if (self.myDanFangInfo and self.myDanFangInfo.endTime and
		MainPlayer:getNowtime() < self.myDanFangInfo.endTime * 0.001) then


		TFResourceHelper:instance():addArmatureFromJsonFile("effect/liandan_dowm_effect.xml")
	    local effect1 = TFArmature:create("liandan_dowm_effect_anim")
	    if effect1 == nil then
	        return
	    end
	    effect1:setAnimationFps(GameConfig.ANIM_FPS)
	    effect1:playByIndex(0, -1, -1, 1)
	    effect1:setPosition(ccp(180,200))
	    -- effect1:setAnchorPoint(ccp(0,0))

	    self.bg_danlu:addChild(effect1, 1)
	    --设置层级
    	self.img_danlu:setZOrder(1)
    	self.iconbg_High:setZOrder(1)
    	self.img_jindudi:setZOrder(1)
		self.img_loadDi:setZOrder(1)
		self.txt_myTime:setZOrder(1)

	    -- effect1:setZOrder(0)
	    self.effect1 = effect1
	    -- self.effect1:playByIndex(0, -1, -1, 0)

	    TFResourceHelper:instance():addArmatureFromJsonFile("effect/liandan_up_effect.xml")
	    local effect2 = TFArmature:create("liandan_up_effect_anim")
	    if effect2 == nil then
	        return
	    end
	    effect2:setAnimationFps(GameConfig.ANIM_FPS)
	    effect2:playByIndex(0, -1, -1, 1)
	    effect2:setPosition(ccp(179,199))
	    -- effect2:setAnchorPoint(ccp(0,0))
	    self.img_danlu:addChild(effect2)
	    self.effect2 = effect2
	    -- self.effect2:playByIndex(0, -1, -1, 0)

	    TFResourceHelper:instance():addArmatureFromJsonFile("effect/liandan_icon_effect.xml")
	    local effect3 = TFArmature:create("liandan_icon_effect_anim")
	    if effect3 == nil then
	        return
	    end
	    effect3:setAnimationFps(GameConfig.ANIM_FPS)
	    effect3:playByIndex(0, -1, -1, 1)
	    effect3:setPosition(ccp(180,148))
	    -- effect3:setAnchorPoint(ccp(0,0))
	    self.img_danlu:addChild(effect3)
	    self.effect3 = effect3
	    -- self.effect3:playByIndex(0, -1, -1, 0)

	else
		if self.effect1 then
   			self.effect1:removeFromParent()
   			self.effect1 = nil
   		end
   		if self.effect2 then
   			self.effect2:removeFromParent()
   			self.effect2 = nil
   		end
		if self.effect3 then
   			self.effect3:removeFromParent()
   			self.effect3 = nil
   		end
		
	end

end


return FactionDanFangLayer