local RoleGradeUp = class("RoleGradeUp",BaseLayer)

function RoleGradeUp:ctor(data)
	self.super.ctor(self, data)
    self.cardRole = CardRoleManager:getRoleById(MainPlayer.profession)
	self.isItemFull = true
	self:init("lua.uiconfig_mango_new.role_new.RoleGradeUp")
end

function RoleGradeUp:initUI( ui )
	self.super.initUI(self,ui)
    self.generalHead = CommonManager:addGeneralHead( self )
    self.generalHead:setData(ModuleType.QualityUp,{HeadResType.COIN,HeadResType.SYCEE})

    self.txt_wannengxiahun = TFDirector:getChildByPath(ui, "txt_wannengxiahun")
    self.Panel_left = TFDirector:getChildByPath(ui, 'Panel_left');
    self.bg_jineng = TFDirector:getChildByPath(ui, 'bg_jineng');
    self.bg_shuxing = TFDirector:getChildByPath(ui, 'bg_shuxing');

    self.btn_help = TFDirector:getChildByPath(ui, "btn_help")

    local panel_name_list = {"Panel_qixue","Panel_wuli","Panel_fangyu","Panel_neili","Panel_shenfa"}
    self.img_attr = {}
	for i=1,5 do
		self.img_attr[i] = TFDirector:getChildByPath(ui,panel_name_list[i])
		self.img_attr[i].txt_curr = TFDirector:getChildByPath(self.img_attr[i],"txt_base")
		self.img_attr[i].txt_next = TFDirector:getChildByPath(self.img_attr[i],"txt_new")
		self.img_attr[i].Img_to = TFDirector:getChildByPath(self.img_attr[i],"Img_to")
	end

	self.txt_chu1 = TFDirector:getChildByPath(ui, "txt_chu2")
	self.txt_chu1:setText("/")
	self.txt_chu2 = TFDirector:getChildByPath(ui, "txt_chu1")
	self.txt_chu2:setText("/")
	self.icon_panel = {}
	self.iconDx = 0
	for i=1,4 do
		self.icon_panel[i] = TFDirector:getChildByPath(ui,"panel_info"..i)
	end
	self.iconDx = self.icon_panel[4]:getPositionX() - self.icon_panel[3]:getPositionX()

	self.conditions = {}
	self.conditions[1] = {}
	self.conditions[2] = {}
	self.conditions[1].des =TFDirector:getChildByPath(ui,"txt_tiaojian1")
	self.conditions[2].des =TFDirector:getChildByPath(ui,"txt_tiaojian2")
	self.conditions[1].num =TFDirector:getChildByPath(ui,"txt_tiaojian3")
	self.conditions[2].num =TFDirector:getChildByPath(ui,"txt_tiaojian4")

	self.btn_starup = TFDirector:getChildByPath(ui,"btn_shengpin")
	self.btn_starup.logic = self

	self.img_skill = TFDirector:getChildByPath(ui,"img_skill")
	self.txt_skillname = TFDirector:getChildByPath(ui,"txt_skillname")
	self.txt_skilldetails = TFDirector:getChildByPath(ui,"txt_skilldetails")

	self.star = {}
	for i=1,5 do
		self.star[i] = TFDirector:getChildByPath(ui, "img_star_light_"..i)
		self.star[i]:setVisible(false)
	end
	self.heroPanel = TFDirector:getChildByPath(ui,"Panel_Role")

	self.roleNode = {}
	local roleNode = {"panel_roleinfo", "panel_roleinfo2"}
	for i=1,2 do
		local localNode = TFDirector:getChildByPath(ui, roleNode[i])
		self.roleNode[i] = {}

		self.roleNode[i].quality = TFDirector:getChildByPath(localNode, 'img_quality')
		self.roleNode[i].icon = TFDirector:getChildByPath(localNode, 'img_icon')
		self.roleNode[i].zhiye = TFDirector:getChildByPath(localNode, 'img_zhiye')
		self.roleNode[i].martialLevel = TFDirector:getChildByPath(localNode, 'img_martialLevel')
		self.roleNode[i].level = TFDirector:getChildByPath(localNode, 'txt_lv')
		self.roleNode[i].imgLevel = TFDirector:getChildByPath(localNode, 'img_level')
	end

	self.txt_fushenumber = TFDirector:getChildByPath(ui, "txt_fushenumber")
end

function RoleGradeUp:loadData(gmId,parent)
	self.gmId = gmId
	self.parent = parent
	local cardRole = CardRoleManager:getRoleByGmid( self.gmId )
	self.cardRole = clone(cardRole)
	self.old_quality 	= cardRole.quality
	self.old_starlevel 	= cardRole.starlevel
	self.roleInfoList = RoleTalentData:GetRoleStarInfoByRoleId( self.cardRole.id, self.cardRole.quality)
	self:refreshUI()
end

function RoleGradeUp:refreshUI()
	self:refreshLeftUI()
	self:refreshCenterUI()
	self:refreshRightUI()
	self:showHeadInfo()
end

function RoleGradeUp:refreshLeftUI()

	--主角四星升五星 隐藏技能提示
	
	if (self.cardRole.quality == 6) then
		self.Panel_left:setVisible(false)
		return
	end
	if self.cardRole.quality == 4 then
		self.bg_jineng:setVisible(false)
		self.bg_shuxing:setPosition(ccp(158,-20))

	elseif self.cardRole.quality == 5 then 
		self.bg_jineng:setVisible(true)
		self.bg_shuxing:setPosition(ccp(158,-84))
	end
	--[[
    local roleType = 1 
    local bQuailtyUp =  CardRoleManager:getShengPingByCard(self.cardRole)
    --红色侠客升品 成长系数不同

    if bQuailtyUp and self.cardRole.quality == 6 then
    	roleType = 2
    end	
	]]
	-- local nextStartLevel = self.cardRole.starlevel
	
	local trainItem_curr = RoleTrainData:getRoleTrainByQuality(self.cardRole.quality, self.cardRole.starlevel,self.cardRole.qualityOne)
    local trainItem_next = RoleTrainData:getRoleTrainByQuality(CardRoleManager:GetMaxQuality(self.cardRole.quality+1), self.cardRole.starlevel,self.cardRole.qualityOne)
	
	local newCardRoleData = RoleData:objectByID(self.cardRole.id)
    local level_up        = newCardRoleData:GetAttrLevelUp()
	for i=1,5 do
		local currStar = trainItem_curr.streng_then * level_up[i]
		local nextStar = trainItem_next.streng_then * level_up[i]
		self.img_attr[i].txt_curr:setText(currStar)
		self.img_attr[i].txt_next:setText(nextStar)
    end

    --显示技能
    if (not self.cardRole:getIsMainPlayer()) then
        local spellInfo = self.cardRole.spellInfoList:objectAt(4)
        if spellInfo then 
        	self.img_skill:setTexture(spellInfo:GetPath()) 
        	self.txt_skillname:setText(spellInfo.name)
        	self.txt_skilldetails:setText(spellInfo.description)
        end	
    else
    	local spellInfo = self.cardRole.leadingSpellInfoConfigList:objectAt(10)
    	print('self.cardRole.leadingSpellInfoConfigList = ',self.cardRole.leadingSpellInfoConfigList)
    	local replaceSpellInfo = SkillBaseData:objectByID(spellInfo.spell_id)
        if replaceSpellInfo then
        	self.img_skill:setTexture(replaceSpellInfo:GetPath()) 
        	self.txt_skillname:setText(replaceSpellInfo.name)
        	self.txt_skilldetails:setText(replaceSpellInfo.description)
        end
    end
end

--中间UI
function RoleGradeUp:refreshCenterUI()
	for i=1,5 do
		self.star[i]:setVisible(false)
	end

	CardRoleManager:SetRoleStarTexture(self.cardRole.starlevel, self.star)
	if self.heroPanel.img then
		self.heroPanel.img:setTexture(self.cardRole:getBigImagePath())
	else
		local img_role = TFImage:create(self.cardRole:getBigImagePath())
	    img_role:setScale(0.65)
	    img_role:setFlipX(true)
	    img_role:setAnchorPoint(ccp(0.5,0.5))
	    img_role:setPosition(ccp(0,0))
	    self.heroPanel.img = img_role
		self.heroPanel:addChild(img_role)
	end
end


--刷新右边
function RoleGradeUp:refreshRightUI()
	local config
    for v in QualityDevelopConfig:iterator() do
    	if v.id == self.cardRole.id and v.quality == self.cardRole.quality then
    		config = v
    	end 
    end		
    local currLevel = 0

	if self.cardRole:getIsMainPlayer() then
		local qimen_table = numberToChineseTable(config.qimen)
	    local qimen_str = ""
	    for i=1,#qimen_table do
	    	qimen_str = qimen_str .. qimen_table[i]
	    end
		--self.conditions[1].des:setText("突破奇门遁"..qimen_str.."重")
		self.conditions[1].des:setText(stringUtils.format(localizable.roleQualityUp_tupo1,qimen_str))

		local star_level_table = numberToChineseTable(config.star_level)
	    local star_level_str = ""
	    for i=1,#star_level_table do
	    	star_level_str = star_level_str .. star_level_table[i]
	    end
		--self.conditions[2].des:setText("主角突破至"..star_level_str.."星")
		self.conditions[2].des:setText(stringUtils.format(localizable.roleQualityUp_tupo2, star_level_str))

		local info = CardRoleManager:getQimenInfo() or {}
	    currLevel = info.level or 0
	    

	    local txt_num_widget = TFDirector:getChildByPath(self.ui,"txt_tiaojian3_num")
		self.conditions[1].num:setText(config.qimen)
		txt_num_widget:setText(currLevel)
		if currLevel >= config.qimen  then
			txt_num_widget:setColor(ccc3(0,0,0))
		else
			txt_num_widget:setColor(ccc3(255,0,4))
		end

	    txt_num_widget = TFDirector:getChildByPath(self.ui,"txt_tiaojian4_num")
		self.conditions[2].num:setText(config.star_level)
		txt_num_widget:setText(self.cardRole.starlevel)
		if self.cardRole.starlevel >= config.star_level  then
			txt_num_widget:setColor(ccc3(0,0,0))
		else
			txt_num_widget:setColor(ccc3(255,0,4))
		end	
		self.txt_chu1:setVisible(true)
		self.txt_chu2:setVisible(true)
	else
		local star_level_table = numberToChineseTable(config.star_level)
	    local star_level_str = ""
	    for i=1,#star_level_table do
	    	star_level_str = star_level_str .. star_level_table[i]
	    end
		self.conditions[1].des:setText(stringUtils.format(localizable.roleQualityUp_tupo3, star_level_str))

		local info = CardRoleManager:getQimenInfo() or {}
	    currLevel = info.level or 0

	    local txt_num_widget = TFDirector:getChildByPath(self.ui,"txt_tiaojian3_num")
		self.conditions[1].num:setText(config.star_level)
		txt_num_widget:setText(self.cardRole.starlevel)
		if self.cardRole.starlevel >= config.star_level  then
			txt_num_widget:setColor(ccc3(0,0,0))
		else
			txt_num_widget:setColor(ccc3(255,0,4))
		end

		self.conditions[2].des:setVisible(false)
		self.conditions[2].num:setVisible(false)
		self.txt_chu1:setVisible(true)
		self.txt_chu2:setVisible(false)
		txt_num_widget = TFDirector:getChildByPath(self.ui,"txt_tiaojian4_num") 
		txt_num_widget:setVisible(false)   
	end

	if currLevel >= config.qimen and self.cardRole.starlevel >= config.star_level then
		self.btn_starup:setGrayEnabled(false)
		self.btn_starup:setTouchEnabled(true)
		Public:addBtnWaterEffect(self.btn_starup, true,1)
	else
		self.btn_starup:setGrayEnabled(true)
		self.btn_starup:setTouchEnabled(false)
		Public:addBtnWaterEffect(self.btn_starup, false,1)
	end
	self.isItemFull = true

	local cost_material = GetAttrByString(config.items)
	local index = 1
	for k,v in pairs(cost_material) do
		if self.icon_panel[index].icon == nil then
			local icon = require('lua.logic.role_new.RoleStarUpPreviewNumCell'):new()
			icon:setScale(0.85)
			self.icon_panel[index]:addChild(icon)
			self.icon_panel[index].icon = icon
		end
		self.icon_panel[index].icon:setPositionX(-5)
		self.icon_panel[index].icon:setVisible(true)
		local curr_num = BagManager:getItemNumById( k )
		self.icon_panel[index].icon:setData(k,curr_num,v)
		if curr_num < v then
			if k == config.sweep_item then
				local commNum = BagManager:getFushebaoxueNum()
				if (curr_num + commNum) < v then
					self.isItemFull = false
				end
			else
				self.isItemFull = false
			end
		end
		index = index + 1
	end
	local moveDx = (5-index)*(self.iconDx/2)

	for i=1,4 do
		if self.icon_panel[i].icon then
			self.icon_panel[i].icon:setPositionX(self.icon_panel[i].icon:getPositionX() + moveDx)
		end
	end
	for i=index,4 do
		if self.icon_panel[i].icon then
			self.icon_panel[i].icon:setVisible(false)
		end
	end
	
	local roleConfig = RoleData:objectByID(self.cardRole.id)
	local omnipotentSoulNum = BagManager:getOmnipotentSoulNumByQuality(roleConfig.quality)
	local str = stringUtils.format(localizable.roleGradeUpXiahunNunber, omnipotentSoulNum)
	self.txt_wannengxiahun:setText(str)
	-- self.txt_fushenumber:setText(stringUtils.format(localizable.roleGradeUpFusheNunber, BagManager:getFushebaoxueNum()))
	self.txt_fushenumber:setVisible(false)
end

function RoleGradeUp.onQualityUpClickHandle( sender )
	local self = sender.logic
	-- self:onUpStarUpCompelete()
	local config
    for v in QualityDevelopConfig:iterator() do
    	if v.id == self.cardRole.id and v.quality == self.cardRole.quality then
    		config = v
    		break
    	end 
    end		
	
	local cost_material = GetAttrByString(config.items)
	local needNumber = 0
	local needFusheNumber = 0
	local omnipotentSoulNum
	local omnipotentSoulList
	local omnipotentSoul
	-- print("cost_material = ",cost_material)
	-- print("self.cardRole.id = ",self.cardRole.id)
	for id,num in pairs(cost_material) do
		local numInBag = BagManager:getItemNumById( id )
		if numInBag < num then
			
			if id == tonumber(config.sweep_item) then
				local commNum = BagManager:getFushebaoxueNum()
				if(numInBag + commNum) < num then
					if ResGetWayManager:openResGetLayer(id, EnumDropType.GOODS) == true then
						return
					end
					toastMessage(localizable.roleQualityUp_notenough)
					return
				else
					needFusheNumber = num - numInBag
				end	
			elseif id == 2000 or self.cardRole.soul_card_id == id then
				local roleConfig = RoleData:objectByID(self.cardRole.id)
				omnipotentSoulNum, omnipotentSoulList = BagManager:getOmnipotentSoulNumByQuality(roleConfig.quality)
				omnipotentSoul = omnipotentSoulList:getObjectAt(1)
				if(numInBag + omnipotentSoulNum) < num then
					if ResGetWayManager:openResGetLayer(id, EnumDropType.GOODS) == true then
						return
					end
					toastMessage(localizable.roleQualityUp_notenough)
					return
				else
					needNumber = num - numInBag
				end
			else
				if ResGetWayManager:openResGetLayer(id, EnumDropType.GOODS) == true then
					return
				end
				toastMessage(localizable.roleQualityUp_notenough)
				return
			end
		end
	end
	
	if needNumber == 0 and needFusheNumber == 0 then
		self.oldarr = {}
		for i = 1, EnumAttributeType.Max do
			self.oldarr[i] = self.cardRole:getTotalAttribute(i)
		end
		CardRoleManager:roleBreakthrough(self.cardRole.gmId)
	else
		local msgStr
		if needNumber ~= 0 and needFusheNumber ~= 0 then
			msgStr = stringUtils.format(localizable.roleGradeUp_useAll,omnipotentSoul.name.."x"..needNumber, needFusheNumber)
		elseif needFusheNumber ~= 0 then
			msgStr = stringUtils.format(localizable.roleGradeUp_useFushebaoxue,needFusheNumber)
		else
			msgStr = stringUtils.format(localizable.roleGradeUp_useOmnipotentSoul,omnipotentSoul.name.."x"..needNumber)
		end

		CommonManager:showOperateSureLayer(
				function()
				    self.oldarr = {}
				    for i=1,EnumAttributeType.Max do
				        self.oldarr[i] = self.cardRole:getTotalAttribute(i)
				    end
				    CardRoleManager:roleBreakthrough( self.cardRole.gmId  )
				end,
				nil,
				{
					msg = msgStr
				}
			)
	end
end

function RoleGradeUp:onUpStarUpCompelete()
	--AlertManager:close()
    local cardRole = CardRoleManager:getRoleByGmid( self.gmId )
	self.cardRole = clone(cardRole)
	local old_quality 	= self.old_quality
	local old_starlevel = self.old_starlevel
	local gmId 			= self.gmId
	if self.cardRole.quality >= 6 then 
    	self.parent:refreshRole()
		AlertManager:close()	
	else
		self:refreshUI()
    end
	local layer = CardRoleManager:openRoleUpLayer(CardRoleManager.upEffectType.roleUpGrade)
	layer:initRoleGradeUpData(gmId, old_quality, old_starlevel, nil)
	AlertManager:show();
    -- local layer =  AlertManager:addLayerByFile("lua.logic.role_new.QualityUpResultLayer", AlertManager.BLOCK_AND_GRAY_CLOSE)
    -- layer:playEffect(cardRole)
    -- AlertManager:show()
end

function RoleGradeUp:removeUI()
   	self.super.removeUI(self)  
end

function RoleGradeUp:onShow()
    self.super.onShow(self)
    self.generalHead:onShow()
end

function RoleGradeUp:registerEvents()
	self.super.registerEvents(self)
	if self.generalHead then
        self.generalHead:registerEvents()
    end

    self.btn_starup:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onQualityUpClickHandle),1)

    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onHelpClickHandle),1)

     self.RoleStarUpResultCallBack = function (event)
        self:onUpStarUpCompelete()
    end
    TFDirector:addMEGlobalListener(CardRoleManager.ROLE_BREAKTHROUGH_RESULT,self.RoleStarUpResultCallBack)

end

function RoleGradeUp:removeEvents()
	self.super.removeEvents(self)
	if self.generalHead then
        self.generalHead:removeEvents()
    end

	self.btn_starup:removeMEListener(TFWIDGET_CLICK)
	TFDirector:removeMEGlobalListener(CardRoleManager.ROLE_BREAKTHROUGH_RESULT,self.RoleStarUpResultCallBack)
    self.RoleStarUpResultCallBack = nil
end


function RoleGradeUp:dispose()
    self.super.dispose(self)
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
end

function RoleGradeUp:showHeadInfo()
	local cardRole = CardRoleManager:getRoleByGmid( self.gmId )
	if cardRole == nil then
		return
	end
	--left
	self.roleNode[1].quality:setTexture(GetColorIconByQuality(cardRole.quality))
	self.roleNode[1].imgLevel:setTexture(GetFontByQuality(cardRole.quality))
	--right
	self.roleNode[2].quality:setTexture(GetColorIconByQuality(cardRole.quality+1))
	self.roleNode[2].imgLevel:setTexture(GetFontByQuality(cardRole.quality+1))

	for i=1,2 do
		self.roleNode[i].icon:setTexture(cardRole:getIconPath())
		self.roleNode[i].zhiye:setTexture("ui_new/fight/zhiye_".. cardRole.outline ..".png");
		self.roleNode[i].martialLevel:setTexture(GetFightRoleIconByWuXueLevel( cardRole.martialLevel ))
		self.roleNode[i].level:setText(cardRole.level)
	end
end

function RoleGradeUp.onHelpClickHandle( btn )
	CommonManager:showRuleLyaer( "zhujueshenghong" )
end

return RoleGradeUp