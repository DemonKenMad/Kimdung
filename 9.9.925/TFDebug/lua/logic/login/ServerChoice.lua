
local ServerChoice = class("ServerChoice", BaseLayer)

function ServerChoice:ctor()
    self.super.ctor(self)
    self:initZoneList()
    self:init("lua.uiconfig_mango_new.login.ServerChoice")

end

function ServerChoice:initUI(ui)
	self.super.initUI(self,ui)

	self.btn_close 		= TFDirector:getChildByPath(ui, 'btn_close')
	self.laye_Scroll 	= TFDirector:getChildByPath(ui, 'laye_Scroll')
	self.laye_zuijin 	= TFDirector:getChildByPath(ui, 'laye_zuijin')

	self.layer_list		= TFDirector:getChildByPath(ui, 'panel_zone')
	self.btn_zone		= TFDirector:getChildByPath(ui, 'btn_zone')

	self.btn_zone:setVisible(false)

    self.cellModel  = TFDirector:getChildByPath(ui, 'btn_Choice')
    self.cellModel:setVisible(false)
    self.cellModel:removeFromParent()
    self.cellModel:retain()

    self.areaModel  = TFDirector:getChildByPath(ui, 'btn_tab')
    self.areaModel:removeFromParent()
    self.areaModel:retain()
    -- self.areaModel:setVisible(false)

	--最近登录的列表
	self.historyServerList = TFArray:new()
	

	local zone = self.ZoneList:getObjectAt(1)
	if zone then
		self:drawServerListWithZoneId(zone.labId)
	end
	
	-- print("self.historyServerList",self.historyServerList,"zoneList",self.ZoneList)
	self:drawZoneList()

end

--区块选择
function ServerChoice:drawZoneList()

    if self.currentTableView == nil then
	    local TabView =  TFTableView:create()
	    TabView:setTableViewSize(self.laye_zuijin:getContentSize())
	    TabView:setDirection(TFTableView.TFSCROLLHORIZONTAL)    
	    TabView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
	    TabView.logic = self
	    self.laye_zuijin:addChild(TabView)
	    -- TabView:setPosition(self.layer_list:getPosition())
	    TabView:setPosition(ccp(0,0))
	    
	    TabView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForAreaServerTable)
	    TabView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInAreaServerTable)
	    TabView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)

	    self.currentTableView = TabView
	end
	self.currentTableView:reloadData()
	
end

function ServerChoice.cellSizeForAreaServerTable(table)
	return 50,163
end

function ServerChoice.numberOfCellsInAreaServerTable(table)
	local self = table.logic
    return self.ZoneList:length()
end
function ServerChoice.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    local node = nil
    if nil == cell then
        table.cells = table.cells or {}
        cell = TFTableViewCell:create()
        table.cells[cell] = true

        node = self.areaModel:clone()

        node:setPosition(ccp(0, 15))
        cell:addChild(node)
        node:setTag(617)
        node.logic = self
        node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.touchZoneEvent))
    end

    node = cell:getChildByTag(617)
    node.index = idx + 1
    self:drawOutNode(node,idx)

    node:setVisible(true)
    return cell
end

function ServerChoice:drawOutNode(node, idx)

	-- local node = table.panelTbl
	local index = node.index
    local txt_name  = TFDirector:getChildByPath(node, "txt_1")

    local zone = self.ZoneList:getObjectAt(index)
	if zone then
		txt_name:setText(zone.labName)

		local cellPicName = "ui_new/login/tab_1.png"
		txt_name:setColor(ccc3(0,0,0))
		if self.zoneid == zone.labId then
			cellPicName = "ui_new/login/tab_2.png"
			txt_name:setColor(ccc3(255,255,255))
		end
		node:setTextureNormal(cellPicName)
	end

end
function ServerChoice.touchZoneEvent(sender)
    local self = sender.logic

    local index = sender.index

    local zone = self.ZoneList:getObjectAt(index)
	if zone then
		self:drawServerListWithZoneId(zone.labId)
	end
    
	self:drawZoneList()
end

function ServerChoice:getServerBtn(serverItem)

	local openServer = serverItem.openServer

	--新服 > 推荐 > 火爆 -- 
	local mark = serverItem.mark
	-- print("mark = ", mark)
    -- 1110 -- 火爆 --  推荐 -- 新服
	-- print("mark1 = ", bit_and(mark,2)) -- 0010 -- 新服
	-- print("mark2 = ", bit_and(mark,4)) -- 0100 -- 推荐
	-- print("mark3 = ", bit_and(mark,8)) -- 1000 -- 火爆

	local tag1 = bit_and(mark,2)
	local tag2 = bit_and(mark,4)
	local tag3 = bit_and(mark,8)

	local node = self.cellModel:clone()
	node:setVisible(true)
	node.serverInfo = serverItem
	node.logic 		= self
	node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onclickServerNode))


	-- 人物等级
	local txt_level = TFDirector:getChildByPath(node, "txt_3")
	if (serverItem.level and serverItem.level > 0) then
		txt_level:setText("(Lv."..serverItem.level..")")
	else
		txt_level:setVisible(false)
	end

	local serverName = SaveManager:getServerName(serverItem)
	node:setTouchEnabled(true)
	node:setGrayEnabled(false)
	if openServer == false then
		--serverName = serverName.."(维护中)"
		serverName = stringUtils.format(localizable.serverChoice_stop,serverName)

		node:setTouchEnabled(false)
		node:setGrayEnabled(true)

	end
	local txtServerName = TFDirector:getChildByPath(node, "txt_2")
	txtServerName:setText(serverName)
	

	local imgFlag = TFDirector:getChildByPath(node, "img_baov")
	if tag1 ~= 0 then
		imgFlag:setVisible(true)
		imgFlag:setTexture("ui_new/login/xf_new.png")
	elseif tag2 ~= 0 then
		imgFlag:setVisible(true)
		imgFlag:setTexture("ui_new/login/xf_jian.png")
	elseif tag3 ~= 0 then
		imgFlag:setVisible(true)
		imgFlag:setTexture("ui_new/login/xf_bao.png")
	else
		imgFlag:setVisible(false)
	end

	node:setAnchorPoint(ccp(0,0))
	
	return node
end

function ServerChoice:removeUI()
	self.super.removeUI(self)

	self.laye_Scroll = nil
	if self.areaModel then
        self.areaModel:release()
        self.areaModel = nil
    end
    if self.cellModel then
        self.cellModel:release()
        self.cellModel = nil
    end
end

function ServerChoice:registerEvents()
	ADD_ALERT_CLOSE_LISTENER(self,self.btn_close)

	self.severlist_requestCallback = function (events)
		self:initZoneList()	
		local zone = self.ZoneList:getObjectAt(1)
		if zone then
			self:drawServerListWithZoneId(zone.labId)
		end

		self:drawZoneList()
	end
	
	TFDirector:addMEGlobalListener(LogonHelper.MSG_DOWNLOAD_SEVERLIST,self.severlist_requestCallback)

end

function ServerChoice:removeEvents()
	TFDirector:removeMEGlobalListener(LogonHelper.MSG_DOWNLOAD_SEVERLIST, self.severlist_requestCallback)
	self.severlist_requestCallback = nil
end

function ServerChoice:initZoneList()
	self.ZoneList = TFArray:new()
	self.ZoneList:clear()

	local zoneList = SaveManager:getZoneList()
	if (zoneList == nil) then
		toastMessage(localizable.common_no_server)
		return
	end
	
	local history = {
		channel = "",
		labName = localizable.ServerChoiceTips,
		labId = 10086
	}

	-- table.insert( zoneList, history )
	for k,v in pairs(zoneList) do
		if (v.labId ~= 10086) then
			self.ZoneList:push(v)
		end

		
	end
	self.ZoneList:push(history)
	local function zoneSort(zone1, zone2)
		if zone1.labId >= zone2.labId then
			return true
		end

		return false
	end

	self.ZoneList:sort(zoneSort)
	self.zoneid = -1
end

function ServerChoice:initServerList(zoneid)

	self.serverList = TFArray:new()
	local serverList = SaveManager:getServerList()

	local historyList = {}
	
	for k,v in pairs(serverList) do
		if v.labId == zoneid then
			self.serverList:push(v)
		end
	end
	--添加最新登录	
	if (zoneid == 10086) then
		local userInfo 		= SaveManager:getUserInfo()
		for k,ip in pairs(userInfo.serverHistory) do
			local serverItem = SaveManager:getServerInfo(ip)
			if serverItem then
				local newServer = clone(serverItem)
				newServer.labId = 10086
				self.serverList:push(newServer)
			end
		end
	end

	-- print("self.serverList = ", self.serverList,zoneid)
	if self.serverList:length() < 1 then
		print("no zoneid server")
		return
	end

	local function ServerSort(zone1, zone2)
		if zone1.labId >= zone2.labId then
			return true
		end

		return false
	end

	-- self.serverList:sort(ServerSort)
end


function ServerChoice:drawServerListWithZoneId(zoneid)
	local userInfo 		= SaveManager:getUserInfo()
	local serverList 	= SaveManager:getServerList()

	if self.zoneid == zoneid then
		return
	end

	self:initServerList(zoneid)

	self.zoneid = zoneid

	-- local scrollView = self.laye_Scroll:getChildByTag(167)
	if self.scrollView then
		self.scrollView:removeFromParentAndCleanup(true)
		self.scrollView = nil
	-- else
	end
	

	local length = self.serverList:length()


	if length < 1 then
		return
	end

	local row = math.ceil(length/2)

	local scrollView = TFScrollView:create()
	scrollView:setPosition(ccp(0,0))
	scrollView:setBackGroundColorType(TF_LAYOUT_COLOR_NONE)


	scrollView:setSize(self.laye_Scroll:getSize())
	local height = self.laye_Scroll:getSize().height
	local height2 =  75 * row + 40
	-- if height2 < height then
	-- 	height2 = height
	-- end

	scrollView:setInnerContainerSize(CCSizeMake(self.laye_Scroll:getSize().width , height2))
	self.laye_Scroll:addChild(scrollView)
	scrollView:setBounceEnabled(true)
	scrollView:setTag(617)

	self.scrollView = scrollView

	-- for k = 1, length in pairs(serverList) do
	for k = 1, length do
		local i = math.floor((k - 1)/2)
		local j = (k - 1) % 2
		local serverItem = self.serverList:getObjectAt(k)
		-- print('serverItem = ', serverItem)
		local btn_server = self:getServerBtn(serverItem)
		print("ServerChoice",i,height,height2)
		btn_server:setPosition(ccp(15 +j * 355, height - (i + 1) * 75))
		if ( length > 8) then
			btn_server:setPosition(ccp(15 +j * 355, (row - i - 1) * 75 + 40))
		end
		--btn_server:setPosition(ccp(15 +j * 355, (row - i - 1) * 70 + 30))
		print("scrollView",btn_server:getPosition())
		scrollView:addChild(btn_server)
	end

	scrollView:scrollToTop()
end



function ServerChoice.onclickServerNode(sender)
	local self = sender.logic
	
	local serverInfo = sender.serverInfo

	-- print("serverInfo = ", serverInfo)
	if serverInfo == nil then
		toastMessage(localizable.serverChoice_serverstop)
		return
	end
	local open = serverInfo.openServer
	if serverInfo and open ~= nil and open == false then
		--local msg = "服务器维护中"
		local msg = localizable.serverChoice_serverstop
		if serverInfo.upkeepMessage then
			msg = serverInfo.upkeepMessage
		end

		toastMessage(msg)
		return
	end
	if self.logic == nil then
		toastMessage(localizable.serverChoice_serverstop)
		return
	end
	if (self.logic.ServerChoice) then
		self.logic:ServerChoice(serverInfo)
	end
	AlertManager:close()
	CommonManager:closeConnection()
end

return ServerChoice
