--[[
  套装显示
]]

local RoleTaoZhuang = class("RoleTaoZhuang", BaseLayer)

function RoleTaoZhuang:ctor(data)
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.role_new.RoleTaoZhuang")
end

function RoleTaoZhuang:initUI(ui)
    self.super.initUI(self, ui)
    -- self.txt_1 = TFDirector:getChildByPath(ui, "txt_1")
    -- self.txt_shuxing1 = TFDirector:getChildByPath(ui, "txt_shuxing1")
    -- -- self.txt_shuxing2 = TFDirector:getChildByPath(ui, "txt_shuxing2")
	-- -- self.txt_taitou = TFDirector:getChildByPath(ui, "txt_taitou")
    -- self.img_dian = TFDirector:getChildByPath(ui, "img_dian")
    self.panel_1 = TFDirector:getChildByPath(ui, "panel_1")
    self.panel_huadong = TFDirector:getChildByPath(ui, "panel_huadong")
    self.panel_1:removeFromParent()
    self.panel_1:retain()
    self.btn_close = TFDirector:getChildByPath(ui, "btn_close")
	self.btn_close:setVisible(false)
	self.num = {}
	self.Maxnum = {}
	self.suitName ={}
	-- self.panel_huadong:setBounceEnabled(true)
end

function RoleTaoZhuang:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function RoleTaoZhuang:loadData(data)
    self.data = data
    -- self:refreshUI()
end

function RoleTaoZhuang:refreshUI()	
	self.desc = {}
	print("self.data",self.data)
	self.cellSize = self.panel_1:getContentSize()
	local m = 1
	for k,v in pairs(self.data) do
		self.num[m] = v
		self.Maxnum[m] = SuitsData:getSuitMixnum( k )
		self.suitName[m] = SuitsData:getSuitName( k )
		for i = 1,self.Maxnum[m]-1 do
			local des = SuitsData:getSuitDescInfo( k, i+1 )
			table.insert(self.desc, des[1])
		end
		m = m+1
	end
	self.fortxt1 = {localizable.Taozhuang_text1,localizable.Taozhuang_text2,localizable.Taozhuang_text3,localizable.Taozhuang_text4}

	self:refreshTableView()
end

function RoleTaoZhuang:refreshTableView()
	if self.tableView == nil then
		self.tableView = TFTableView:create()
		self.tableView.logic = self
		self.tableView:setTableViewSize(self.panel_huadong:getContentSize())	
		self.tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
		self.tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
		

		self.tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, handler(self.cellSizeForTable, self))
		-- self.tableView:addMEListener(TFTABLEVIEW_SCROLL, self.tableScroll);
		self.tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, handler(self.tableCellAtIndex, self))
		self.tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, handler(self.numberOfCellsInTableView, self))
		
		self.panel_huadong:addChild(self.tableView)
	end
	
	self.tableView:reloadData()
	
end

function RoleTaoZhuang:cellSizeForTable(table, idx)
	return 114,self.cellSize.width + 10
end

function RoleTaoZhuang:tableCellAtIndex(table, idx)
	idx = idx + 1
	local cell = table:dequeueCell()
	if nil == cell then
		cell = TFTableViewCell:create()
	
		local node = self.panel_1:clone()
		node:setVisible(true)
		node:setPosition(ccp(0,80))
		cell:addChild(node,1)
		cell.panel = node	
	end
	self:setCellInfo(cell,idx)
	
	return cell
end

function RoleTaoZhuang:setCellInfo(cell,idx)
	local panel = cell.panel

	local txt11 = TFDirector:getChildByPath(panel, "txt_1")
	local txt22 = TFDirector:getChildByPath(panel, "txt_shuxing1")
	local txt33 = TFDirector:getChildByPath(panel, "txt_shuxing2")
	local dian = TFDirector:getChildByPath(panel, "img_dian")
	local txt_taitou = TFDirector:getChildByPath(panel, "txt_taitou")
	local left = TFDirector:getChildByPath(panel, "img_tiao1")
	local right = TFDirector:getChildByPath(panel, "img_tiao2")
	
	local function getRichTextString(_des, _name)
		local textLabel = panel:getChildByName(_name)
		if (not textLabel) then
			textLabel = TFLabel:create()
			panel:addChild(textLabel)
		end
		-- _des:removeAllChildren()
		textLabel:setPosition(_des:getPosition())
		textLabel:setAnchorPoint(_des:getAnchorPoint())
		textLabel:setName(_name)
		_des:setVisible(false)
		return textLabel
	end
	local txt1 = getRichTextString(txt11, "txt11")
	local txt2 = getRichTextString(txt22, "txt22")
	local txt3 = getRichTextString(txt33, "txt33")
	
	txt_taitou:setVisible(false)
	left:setVisible(false)
	right:setVisible(false)
	txt3:setVisible(false)
	dian:setVisible(false)
	txt1:setVisible(true)
	txt2:setVisible(true)

	txt1:setVisible(true)
	txt2:setVisible(true)	
	

	-- txt_taitou:setPositionY(self.cellSize.height-25)
	-- txt1:setPositionY(self.cellSize.height-75)
	-- dian:setPositionY(self.cellSize.height-75)
	-- txt2:setPositionY(self.cellSize.height-100)
	-- txt3:setPositionY(self.cellSize.height-125)

	-- left:setPositionY(self.cellSize.height-25)
	-- right:setPositionY(self.cellSize.height-25)

	local des = string.split(self.desc[idx],"，")
	if idx <= (self.Maxnum[1]-1) then
		txt1:setText(self.fortxt1[idx])
	elseif (idx - (self.Maxnum[1]-1)) <= (self.Maxnum[2]-1) and (idx - (self.Maxnum[1]-1))>0 then
		txt1:setText(self.fortxt1[idx - (self.Maxnum[1]-1)])
	end
	txt2:setText(des[1])
	if des[2] then
		txt3:setVisible(true)
		txt3:setText(des[2])
	end
	dian:setVisible(false)
	txt2:setColor(ccc3(61,61,61))
	txt1:setColor(ccc3(61,61,61))
	txt3:setColor(ccc3(61,61,61))	

	if (self.Maxnum[1]-1) >= idx then
		if self.num[1] > idx then
			dian:setVisible(true)
			txt2:setColor(ccc3(13,125,24))
			txt1:setColor(ccc3(13,125,24))
			txt3:setColor(ccc3(13,125,24))
		end
	elseif (self.Maxnum[2]-1) >= idx - (self.Maxnum[1]-1) then
		if self.num[2] > (idx - (self.Maxnum[1]-1)) then
			dian:setVisible(true)
			txt2:setColor(ccc3(13,125,24))
			txt1:setColor(ccc3(13,125,24))
			txt3:setColor(ccc3(13,125,24))
		end

	end


	if idx == 1 then
		txt_taitou:setVisible(true)
		left:setVisible(true)
		right:setVisible(true)
		txt_taitou:setText(self.suitName[1])
		-- txt_taitou:setPositionY(self.cellSize.height/2)
		-- left:setPositionY(self.cellSize.height/2)
		-- right:setPositionY(self.cellSize.height/2)
	elseif idx == self.Maxnum[1] then
		txt_taitou:setVisible(true)
		left:setVisible(true)
		right:setVisible(true)
		txt_taitou:setText(self.suitName[2])
	end
	txt1:setColor(ccc3(13,125,24))
end


function RoleTaoZhuang:numberOfCellsInTableView(table)
	return #self.desc 

end

function RoleTaoZhuang:removeUI()
    if self.panel_1 then
        self.panel_1:release()
        self.panel_1 = nil
    end
    self.super.removeUI(self)
end

--注册事件
function RoleTaoZhuang:registerEvents()
   self.super.registerEvents(self)

   ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)
end

function RoleTaoZhuang:removeEvents()
    self.super.removeEvents(self)
end

return RoleTaoZhuang