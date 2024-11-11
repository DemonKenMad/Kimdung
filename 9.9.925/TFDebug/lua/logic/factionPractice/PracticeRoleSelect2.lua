

local PracticeRoleSelect2 = class("PracticeRoleSelect2",BaseLayer)

local columnNumber = 4

function PracticeRoleSelect2:ctor(data)

	self.super.ctor(self, data)
	self.isFirst = true
    -- if data == 1 , then show from left
    if data == 1 then
        self:init("lua.uiconfig_mango_new.smithy.SmritiAccept")        
    else
        columnNumber = 4
	    self:init("lua.uiconfig_mango_new.faction.PracticeRoleSelect2")
    end
end

function PracticeRoleSelect2:initUI( ui )

	self.super.initUI(self, ui)
	self.panel_cardregional = TFDirector:getChildByPath(ui, 'panel_cardregional')
	self.txt_zhiyin1 = TFDirector:getChildByPath(ui, 'txt_zhiyin1')
	self.btn_shousuo = TFDirector:getChildByPath(ui, 'btn_shousuo')

	self.cellModel = createUIByLuaNew("lua.uiconfig_mango_new.role.ArmyRoleItem")
    self.cellModel:retain()

    self.img_di1 = TFDirector:getChildByPath(ui, "img_di2")
    self.img_di2 = TFDirector:getChildByPath(ui, "img_di")

    --self.img_di1:setZOrder(20)
    self.img_di1:setVisible(false)

    self.img_di2:setZOrder(20)
    self.img_di2:setVisible(true)

    self.btn_shousuo:setZOrder(30)
end

function PracticeRoleSelect2:tableScroll(table)
    local self = table.logic

    local size = self.tableView:getTableViewSize()
    local size2 = self.tableView:getContentSize()
    local pos = self.tableView:getContentOffset()
    if pos.y == size.height - size2.height then
        self.img_di1:setVisible(false)
    else
        self.img_di1:setVisible(true)
    end
    if pos.y == 0 then
        self.img_di2:setVisible(false)
    else
        self.img_di2:setVisible(true)
    end
end


function PracticeRoleSelect2:initDate( role_list, showText,clickCallBack)
	self.roleList = role_list
	self.showText = showText
	self.clickCallBack = clickCallBack

	if self.tableView == nil then
		self:creatTableView()
	end
	self.tableView:reloadData()

	if self.showText == nil or self.showText == "" then
		self.txt_zhiyin1:setVisible(false)
	else
		self.txt_zhiyin1:setVisible(true)
		self.txt_zhiyin1:setText(self.showText)
	end
 
end

function PracticeRoleSelect2:initDateByFilter( role_list, filter_list,showText,clickCallBack)
	self.roleList = self.roleList or TFArray:new()
	self.roleList:clear()

	for v in role_list:iterator() do
		if filter_list:indexOf(v) == -1 then
			self.roleList:pushBack(v)
		end
	end

	self.showText = showText
	self.clickCallBack = clickCallBack

	if self.tableView == nil then
		self:creatTableView()
	end
	self.tableView:reloadData()

	if self.showText == nil or self.showText == "" then
		self.txt_zhiyin1:setVisible(false)
	else
		self.txt_zhiyin1:setVisible(true)
		self.txt_zhiyin1:setText(self.showText)
	end
end




function PracticeRoleSelect2:creatTableView()
	local  tableView =  TFTableView:create()
    -- tableView:setName("btnTableView")
    tableView:setTableViewSize(self.panel_cardregional:getContentSize())
    tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
    tableView:setVerticalFillOrder(0)
    tableView:setPosition(self.panel_cardregional:getPosition())
    --tableView:setPosition(ccp(self.panel_cardregional:getPosition().x, self.panel_cardregional:getPosition().y - 20))
    self.tableView = tableView
     
    self.tableView.logic = self

    tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, PracticeRoleSelect2.cellSizeForTable)
    tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, PracticeRoleSelect2.tableCellAtIndex)
    tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, PracticeRoleSelect2.numberOfCellsInTableView)
    tableView:addMEListener(TFTABLEVIEW_SCROLL, handler(PracticeRoleSelect2.tableScroll,self))

    self.panel_cardregional:getParent():addChild(self.tableView,1)
end


function PracticeRoleSelect2.cellSizeForTable(table,cell)
	return 173,600
    --return 193,600
end

function PracticeRoleSelect2.tableCellAtIndex(table,idx)
	local self = table.logic
    local cell = table:dequeueCell()
    self.allPanels = self.allPanels or {}

    if cell == nil then
        cell = TFTableViewCell:create()
        local newIndex = #self.allPanels + 1
        self.allPanels[newIndex] = cell

        for i=1,columnNumber do
            local panel = self.cellModel:clone()
            --panel:setPosition(ccp(0 + 136 * (i - 1) ,0))
            panel:setPosition(ccp(10 + 145 * (i - 1) ,0))
            cell:addChild(panel)
            panel:setTag(i)
        end
    end
    for i=1,columnNumber do
        local panel = cell:getChildByTag(i)
        self:cellInfoSet(panel, idx*columnNumber+i)
    end

    return cell
end



function PracticeRoleSelect2:cellInfoSet( panel, idx )

    if panel.boundData == nil then
        panel.boundData = true
        panel.panelEmpty = TFDirector:getChildByPath(panel, "panel_empty")
        panel.panelInfo = TFDirector:getChildByPath(panel, "panel_info")
        panel.btn = TFDirector:getChildByPath(panel, "btn_pingzhianniu")
        panel.img_pinzhiditu = TFDirector:getChildByPath(panel, "img_pinzhiditu")
        panel.img_touxiang = TFDirector:getChildByPath(panel, "img_touxiang")
        panel.txt_lv_word = TFDirector:getChildByPath(panel, "txt_lv_word")
        panel.img_zhan = TFDirector:getChildByPath(panel, "img_zhan")
        panel.txt_name = TFDirector:getChildByPath(panel, "txt_name")
        panel.img_zhiye = TFDirector:getChildByPath(panel, "img_zhiye")
        panel.img_quality = TFDirector:getChildByPath(panel, "img_quality")
        panel.img_fate = TFDirector:getChildByPath(panel, "img_fate")

        panel.btn:addMEListener(TFWIDGET_CLICK,audioClickfun(self.cellButtonClick))
        panel.btn.logic = self
    end
 
    panel.btn.idx = idx
    local roleId = self.roleList:objectAt(idx);
    local roleItem = CardRoleManager:getRoleById(roleId)
    if  roleItem then
        panel.panelEmpty:setVisible(true)
        panel.panelInfo:setVisible(true)

        panel.img_touxiang:setTexture(roleItem:getIconPath())    
        panel.img_pinzhiditu:setTexture(GetColorIconByQuality(roleItem.quality))
        local roleStar = ""
        if roleItem.starlevel > 0 then
            roleStar = roleStar .. " +" .. roleItem.starlevel
        end
        panel.txt_name:setText(roleItem.name..roleStar)
        panel.img_zhiye:setTexture("ui_new/fight/zhiye_".. roleItem.outline ..".png")
        panel.img_quality:setTexture(GetFightRoleIconByWuXueLevel(roleItem.martialLevel))   
        panel.img_zhan:setVisible(false)
        -- --print("roleItem = ",roleItem.fateid)
        -- if roleItem.fateid ~= 0 then
        --     panel.img_fate:setVisible(true)
        -- else
        panel.img_fate:setVisible(false)
        -- end

        panel.txt_lv_word:setText(roleItem.level)
    else
        panel.panelEmpty:setVisible(true)
        panel.panelInfo:setVisible(false)
    end
end

function PracticeRoleSelect2.numberOfCellsInTableView(table,cell)
    local self = table.logic
	if self.roleList == nil then
		return 0
	end
	return math.ceil(self.roleList:length()/columnNumber)
end


function PracticeRoleSelect2.cellButtonClick( btn )
    local self = btn.logic
    local roleId = self.roleList:objectAt(btn.idx)
    local roleItem = CardRoleManager:getRoleById(roleId)
    TFFunction.call(self.clickCallBack,roleItem)
    -- self.clickCallBack(self.role_list:objectAt(btn.idx))
end

function PracticeRoleSelect2:removeUI()
	self.super.removeUI(self)

	if self.cellModel then
        self.cellModel:release()
        self.cellModel = nil
    end
end

function PracticeRoleSelect2:onShow()
    self.super.onShow(self)

    if self.isFirst then
    	self:moveIn()
    	self.isFirst = false
    end
end



function PracticeRoleSelect2.closeBtnClick(btn)
    local self = btn.logic
    self:moveOut()
end


function PracticeRoleSelect2:moveIn()
    self.ui:runAnimation("Action0",1)
end
function PracticeRoleSelect2:moveOut()
    self.ui:runAnimation("Action1",1)
    self.ui:setAnimationCallBack("Action1", TFANIMATION_END, function()
        AlertManager:close()
        end)
end

function PracticeRoleSelect2:registerEvents()
	self.btn_shousuo.logic = self
	self.ui.logic = self
    self.ui:setTouchEnabled(true)
	self.btn_shousuo:addMEListener(TFWIDGET_CLICK, audioClickfun(self.closeBtnClick))
	self.ui:addMEListener(TFWIDGET_CLICK, audioClickfun(self.closeBtnClick))
	self.super.registerEvents(self)
end

function PracticeRoleSelect2:removeEvents()
	self.isFirst = true
    self.super.removeEvents(self)
end

function PracticeRoleSelect2:dispose()

	self.super.dispose(self)
end


return PracticeRoleSelect2