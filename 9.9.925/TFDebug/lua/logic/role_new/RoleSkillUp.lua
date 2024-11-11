local RoleSkillUp = class("RoleSkillUp",BaseLayer)

function RoleSkillUp:ctor(data)
	self.super.ctor(self, data)
	self.cardRole = CardRoleManager:getRoleById(MainPlayer.profession)
	self:init("lua.uiconfig_mango_new.role_new.RoleSkillUp")
end


function RoleSkillUp:initUI( ui )
	self.super.initUI(self,ui)
	self.ui = ui

	self.img_skillicon = TFDirector:getChildByPath(ui,"img_skillicon")
	self.txt_skillname = TFDirector:getChildByPath(ui,"txt_skillname")
	self.txt_jinengmiaoshu = TFDirector:getChildByPath(ui,"txt_jinengmiaoshu")
	self.icon_panel = TFDirector:getChildByPath(ui,"icon_panel")
	--self.Panel_tupo = TFDirector:getChildByPath(ui,"Panel_tupo")
	self.btn_starup = TFDirector:getChildByPath(ui,"Btn_tupo")
	self.btn_starup.logic = self

	self.txt_suoxu = TFDirector:getChildByPath(ui, "txt_suoxu")

	self.btn_skill = TFDirector:getChildByPath(ui,"btn_skilliconbg")
	self.btn_skill.logic = self
	--tableView  
	self.TabViewUI = TFDirector:getChildByPath(ui, "Panel_tupo")
    self.TabView =  TFTableView:create()
    self.TabView:setTableViewSize(self.TabViewUI:getContentSize())
    self.TabView:setDirection(TFTableView.TFSCROLLVERTICAL)    
    self.TabView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    self.TabView.logic = self
    self.TabViewUI:getParent():addChild(self.TabView)
    self.TabView:setPosition(self.TabViewUI:getPosition())
    self.TabViewUI_size = self.TabViewUI:getContentSize()

    self.RoleStarInfoArray = MEArray:new()
    self.cells ={}
end

function RoleSkillUp:loadData(cardRole)
	self.gmId = cardRole.gmId
    if self.gmId ~= 0 then 
       local cardRole  =  CardRoleManager:getRoleByGmid( self.gmId )
       self.cardRole = clone(cardRole)
    else
    	-- local cardRole  =  CardRoleManager:getRoleByGmid( self.gmId )
	    self.cardRole = clone(cardRole)
    end
	
    local roleInfoList = RoleTalentData:GetRoleStarInfoByRoleId(self.cardRole.id)
	self.RoleStarInfoArray:clear()
	local quality = self.cardRole.quality
	if (self.cardRole.quality == 7) then
		quality = 7
	end
	for v in roleInfoList:iterator() do
		if v.break_type == 2 then  --红色技能突破
			local bAdd = true
			if (quality) then
				bAdd = false
				if(quality == v.quality) then
					bAdd = true
				end
			end
			if (bAdd) then
				self.RoleStarInfoArray:push(v)
			end
		end
	end
	self.size = self.RoleStarInfoArray:length()
	self:refreshUI()
end


function RoleSkillUp:refreshUI()
	local spellInfo = self.cardRole.spellInfoList:objectAt(4)

	if self.cardRole:getIsMainPlayer() then
		local spellInfoConfig = self.cardRole.leadingSpellInfoConfigList:objectAt(10)
		spellInfo = SkillBaseData:objectByID(spellInfoConfig.spell_id);
	end
	self.spellInfo = spellInfo
    if spellInfo then 
       	self.img_skillicon:setTexture(spellInfo:GetPath()) 
        self.txt_skillname:setText(spellInfo.name)
        self.txt_jinengmiaoshu:setText(spellInfo.description)
    end	

    if self.TabView then
		self.TabView:reloadData()
		self.TabView:setScrollToBegin()
	end

	if self.TabView then
    	local offset_position = {}--= {6,6,5,4,3,2,1,0,0}
    	for i=1,self.size do
    		if i == 1 or i == 2 then
    			offset_position[i] = self.size - 2
    		else
    			offset_position[i] = self.size - i
    		end    		
    	end
    	offset_position[self.size + 1] = 0
    	local level = self.cardRole.skillStarLevel
    	if not level then 
			level = 0
    	end	
    	local offset = offset_position[level+1] or 0
    	self.TabView:setContentOffset(ccp(-5,-(118*offset) + 70))
    end


	local roleStarInfo = self.RoleStarInfoArray:getObjectAt(self.cardRole.skillStarLevel + 1 )
	if roleStarInfo then 
		self.isItemFull = true
		local cost_material = GetAttrByString(roleStarInfo.other_goods_id)
		local index = 1
		self.icon_panel:setVisible(true)
		for k,v in pairs(cost_material) do
			if self.icon_panel.icon == nil then
				local icon = require('lua.logic.role_new.RoleStarUpPreviewNumCell'):new()
				icon:setScale(0.85)
				self.icon_panel:addChild(icon)
				self.icon_panel.icon = icon
			end
			self.icon_panel.icon:setVisible(true)
			local curr_num = BagManager:getItemNumById( k )

			print("curr_num = ",curr_num)
			self.icon_panel.icon:setData(k,curr_num,v)
			if curr_num < v then
				self.isItemFull = false
			end
			index = index + 1
		end
	elseif self.icon_panel.icon then
		self.icon_panel.icon:setVisible(false)
	end
	if self.isItemFull then
		self.btn_starup:setGrayEnabled(false)
		self.btn_starup:setTouchEnabled(true)
	else
		self.btn_starup:setGrayEnabled(true)
		self.btn_starup:setTouchEnabled(false)
	end
	if not self.cardRole.skillStarLevel then 
		return
	end	
	if self.cardRole.skillStarLevel >= self.size then
		self.btn_starup:setGrayEnabled(true)
		self.btn_starup:setTouchEnabled(false)
		self.icon_panel:setVisible(false)
	end
    if self.cardRole.gmId == 0 then 
        self.btn_starup:setVisible(false)
		self.icon_panel:setVisible(false)
		self.txt_suoxu:setVisible(false)
    else
        self.btn_starup:setVisible(true)
		self.icon_panel:setVisible(true)
		self.txt_suoxu:setVisible(true)
    end 
end


function RoleSkillUp.cellSizeForTable(table,idx)
    return 118,465
end

function RoleSkillUp.tableCellAtIndex(table, idx)

	local self = table.logic
	local cell = table:dequeueCell()

	if cell == nil then
		cell = TFTableViewCell:create()		
	    local panel = require('lua.logic.role_new.RoleSkillUpCell'):new()        	    	   
		panel:setPosition(ccp(20,0))		
	    cell:addChild(panel)
    	cell.panel = panel
    	self.cells[idx+1] = cell
	end
	cell.panel:setData(self.cardRole,self.RoleStarInfoArray:getObjectAt(idx+1))
	--[[
	if idx+1 == 1 then 
		cell.panel:PlayEffect()
	end
	]]
    return cell
end

function RoleSkillUp.numberOfCellsInTableView(table)
	local self = table.logic
    return self.RoleStarInfoArray:length()
end


function RoleSkillUp.onTuPoClickHandle( sender )
	local self = sender.logic
	print("onTuPoClickHandle")
	CardRoleManager:roleStarUp( self.cardRole.gmId,0, 2)
end


function RoleSkillUp.onCloseClickHandle( sender )
	AlertManager:close(AlertManager.TWEEN_NONE)
end


-- 三个技能事件
function RoleSkillUp.onSkillItemClickHandle(sender)
    local self = sender.logic 
    if self.spellInfo then
	    local spellInfo = self.spellInfo
	    local replaceSkillId = CardRoleManager:isSkillReplace(self.cardRole.id, self.cardRole.starlevel, spellInfo.id ,self.cardRole.skillStarLevel, self.cardRole.quality)                 
	            
	    if replaceSkillId ~= spellInfo.id then
	        spellInfo = SkillBaseData:objectByID(replaceSkillId)
	    end       
	    --local spellLevelInfo = spellInfo:GetLevelItem(sender.level)            
	    local spellLevelInfo = spellInfo:GetLevelItem(1)            
	    CardRoleManager:openSkillInfo(self.cardRole.id, spellInfo,spellLevelInfo ,4,self.cardRole.XinFaSpecialAttribute)
	end
end


function RoleSkillUp:onUpStarUpCompelete()
    local cardRole = CardRoleManager:getRoleByGmid( self.gmId )
    if cardRole == nil then 
    	return
    end
	self.cardRole = clone(cardRole)
	self:refreshUI()
	self:PlayEffect()
	local star_lv = self.cardRole.skillStarLevel
	if self.cells[star_lv] then
		self.cells[star_lv].panel:PlayEffect()
	end	
end


function RoleSkillUp:PlayEffect()
	-- body
	local resPath = "effect/ui/level_role_up.xml"
   	TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
   	if self.effect then
   		self.effect:playByIndex(0, -1, -1, 0)
   	else	
	    local effect = TFArmature:create("level_role_up_anim")
	    effect:setAnimationFps(GameConfig.ANIM_FPS)
	    effect:setPosition(ccp(400,300))
	    effect:setVisible(true)
	    effect:setScale(0.8)
	    self.ui:getParent():addChild(effect,4)        
	    effect:playByIndex(0, -1, -1, 0)
	    self.effect = effect
	end
end

function RoleSkillUp:removeUI()
   	self.super.removeUI(self)  
end

function RoleSkillUp:onShow()
    self.super.onShow(self)
    if not self.bFirst then
    	self.bFirst = true
    	self.ui:runAnimation("Action0",1)
    end	

end

function RoleSkillUp:registerEvents()
	self.super.registerEvents(self)
    self.btn_starup:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onTuPoClickHandle),1)
    self.TabView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
    self.TabView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
    self.TabView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)

     self.RoleStarUpResultCallBack = function (event)
        self:onUpStarUpCompelete()
    end
    TFDirector:addMEGlobalListener(CardRoleManager.ROLE_PRACTICE_RESULT_SKILL,self.RoleStarUpResultCallBack)

    self.btn_skill:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSkillItemClickHandle))
    self.btn_skill.logic = self
end

function RoleSkillUp:removeEvents()
	self.super.removeEvents(self)

	self.TabView:removeMEListener(TFTABLEVIEW_SIZEFORINDEX)
    self.TabView:removeMEListener(TFTABLEVIEW_SIZEATINDEX)
    self.TabView:removeMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW)
    TFDirector:removeMEGlobalListener(CardRoleManager.ROLE_PRACTICE_RESULT_SKILL,self.RoleStarUpResultCallBack)
    self.RoleStarUpResultCallBack = nil

    self.firstAdd = nil
end


function RoleSkillUp:dispose()
    self.super.dispose(self)
end

return RoleSkillUp