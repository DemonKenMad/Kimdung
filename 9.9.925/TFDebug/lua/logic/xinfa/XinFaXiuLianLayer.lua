--[[
 * @Description: 心法修炼界面
 ]]
-- script writer fei
-- creation time 2017-03-02
local XinFaXiuLianLayer = class("XinFaXiuLianLayer", BaseLayer)

function XinFaXiuLianLayer:ctor()
	self.super.ctor(self)
	self:init("lua.uiconfig_mango_new.xinfa.XinFaXiuLian")
end

function XinFaXiuLianLayer:initUI( ui )
	self.super.initUI(self, ui)
	self.img_icon      = TFDirector:getChildByPath(ui, 'img_icon')
  self.panel_star    = TFDirector:getChildByPath(ui, 'panel_star')
	self.txt_starlv    = TFDirector:getChildByPath(ui, 'txt_starlv')
	self.txt_lv 	   = TFDirector:getChildByPath(ui, 'txt_intensify_lv')
	self.txt_name 	        = TFDirector:getChildByPath(ui, 'txt_name')
  self.img_fz             = TFDirector:getChildByPath(ui, 'img_fz')
	self.img_quality 	    = TFDirector:getChildByPath(ui,'img_quality')
	local panel_sx 		    = TFDirector:getChildByPath(ui, 'panel_sx')
	
	self.img_lv             = TFDirector:getChildByPath(panel_sx, 'img_intensify_lv')
	self.img_lv.txt_curlv 	= TFDirector:getChildByPath(self.img_lv, 'txt_current_lv')
	self.img_lv.txt_nextlv	= TFDirector:getChildByPath(self.img_lv, 'txt_next_lv')
	self.img_lv.img_to 		= TFDirector:getChildByPath(self.img_lv, 'img_to')
	self.img_lv.txt_numLv_effect	= TFDirector:getChildByPath(self.img_lv, 'txt_numLv_effect')
	self.img_lv.txt_numLv_effect:setVisible(false)
	self.btn_xiulian 		= TFDirector:getChildByPath(ui, 'btn_yjxls-Copy1')
	self.btn_superxiulian 	= TFDirector:getChildByPath(ui, 'btn_yjxls')
    self.txt_power_details 	= TFDirector:getChildByPath(ui, 'txt_power_details')
    local img_zhandouli 		    = TFDirector:getChildByPath(ui, 'img_zhandouli')
    img_zhandouli:setPositionX(img_zhandouli:getPositionX() - 40)

    self.img_equiped        = TFDirector:getChildByPath(ui, 'img_equiped')
    self.txt_equiped_name   = TFDirector:getChildByPath(ui, 'txt_equiped_name')
	self.sxLayer = {}
	for i = 1, 5 do
		local img_sx 		= TFDirector:getChildByPath(panel_sx, 'img_sx'..i)
		img_sx.img_to 		= TFDirector:getChildByPath(img_sx, 'img_to')
		img_sx.txt_curlv	= TFDirector:getChildByPath(img_sx, 'txt_current_lv')
		img_sx.txt_nextlv 	= TFDirector:getChildByPath(img_sx, 'txt_next_lv')
		img_sx.txt_name 	= TFDirector:getChildByPath(img_sx, 'txt_name')
		img_sx.txt_numLv_effect = TFDirector:getChildByPath(img_sx, 'txt_numLv_effect')
		img_sx.txt_numLv_effect:setVisible(false)
		self.sxLayer[i] 	= img_sx
		self.sxLayer[i]:setVisible(false) 
	end
	local CailiaoPanel 		= TFDirector:getChildByPath(ui, 'Panel_cailiao')
	self.costLayer = {}
	for i = 1, 3 do
		local btn_tool = TFDirector:getChildByPath(CailiaoPanel, 'btn_tool'..i)
		btn_tool.img_tool = TFDirector:getChildByPath(btn_tool, 'img_tool'..i)
		btn_tool.txt_num1 = TFDirector:getChildByPath(btn_tool, 'txt_num'..i)
		self.costLayer[i] = btn_tool
		self.costLayer[i]:setVisible(false)
	end
    self.txt_qhs            = TFDirector:getChildByPath(ui, 'txt_qhs')
end

function XinFaXiuLianLayer:setXinFaData(data)
	self.gmId = data
	self.XinFainfo = XinFaManager:getXinFaByGmId(self.gmId)
	self:refreshUI()
end

function XinFaXiuLianLayer:removeUI()
	self.super.removeUI(self)
end

function XinFaXiuLianLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function XinFaXiuLianLayer:refreshUI()
	if self.XinFainfo == nil then
		print('cannot find the card gmId = ',self.gmId)
		return
	end
  self.img_quality:setTexture(GetColorIconByQuality_118(self.XinFainfo.config.quality))
  XinFaManager:BindEffectOnEquip(self.img_quality,self.XinFainfo)
	self.img_icon:setTexture("icon/item/"..self.XinFainfo.config.display..".png")
	if self.XinFainfo.star == 0 then
      self.panel_star:setVisible(false)
    else 
      self.panel_star:setVisible(true)
      self.txt_starlv:setText(self.XinFainfo:getStar())
    end
    if self.XinFainfo.level == 1 then
        self.txt_lv:setVisible(false)
    else
        self.txt_lv:setVisible(true)
    end
	self.txt_lv:setText('+'..self.XinFainfo.level)
	self.txt_name:setText(self.XinFainfo.config.name)
	self.img_lv.txt_curlv:setText(self.XinFainfo.level)
    if self.XinFainfo.equip then
        self.txt_equiped_name:setText(CardRoleManager:getRoleById(self.XinFainfo.equip).name)
        self.img_equiped:setVisible(true)
    else
        self.img_equiped:setVisible(false)
    end
	--隐藏材料按钮
	for i = 1, 3 do
		self.costLayer[i]:setVisible(false)
	end
	--隐藏属性面板
	for i = 1, 5 do
		self.sxLayer[i]:setVisible(false) 
	end
	self:refreshShuXingPanel()
	-- 等级未达到满级
	if self.XinFainfo.level < XinFaManager.MAX_LEVEL then
		self.img_lv.img_to:setVisible(true)
		self.img_lv.txt_nextlv:setVisible(true)
		self.img_lv.txt_nextlv:setText(self.XinFainfo.level + 1)
		--print(self.XinFainfo:GetQuality(),self.XinFainfo)
		self:refreshCost(self.XinFainfo.config)
	else
		self.img_lv.txt_nextlv:setVisible(false)
		self.img_lv.img_to:setVisible(false)
        self:refreshCost(self.XinFainfo.config)
	end
	--材料刷新
end

function XinFaXiuLianLayer:refreshShuXingPanel()
	print("refreshShuXingPanel")
	--print(self.XinFainfo)
	--print(self.XinFainfo:getXiuLianAttribute().attribute)
	local upbefor_lv_attr = {}
	if self.XinFainfo:getDifferlevel() ~= 0 then 
		-- print("......",self.XinFainfo.differlevel)
		upbefor_lv_attr 	= KongfuXiuLianData:GetXiuLianAttrByQualityAndLv(self.XinFainfo.config.quality, self.XinFainfo.level - self.XinFainfo.differlevel, self.XinFainfo.config.usable)
		self.img_lv.txt_numLv_effect:setText("+"..self.XinFainfo:getDifferlevel())
		self:UpLevelNumEffect(self.img_lv.txt_numLv_effect)
        self:intensifyEquipEffect()
	end

  local next_lv_attr      = self.XinFainfo:getDiffTotalAttribute(2, self.XinFainfo.level + 1)
    
	local count = 0
	for attrId,attrValue in pairs(self.XinFainfo:getTotalAttribute().attribute) do
		local differattr = (next_lv_attr and next_lv_attr.attribute[attrId] or 0 ) - (attrValue or 0)
        if attrValue ~= 0 and attrId < 18 then
            count = count + 1
            local attr = self.sxLayer[count]
            if (attr) then
                attr.txt_name:setText(AttributeTypeStr[attrId]..":")
                attr.txt_curlv:setText("+"..covertToDisplayValue(attrId, math.floor(attrValue), true))
                if next_lv_attr and #next_lv_attr.attribute >= 1 then
                	if self.XinFainfo:getDifferlevel() ~= 0 then
            			attr.txt_numLv_effect:setText(next_lv_attr.attribute[attrId] or 0 - attrValue or 0)
                		self:UpLevelNumEffect(attr.txt_numLv_effect)
                	end
                  attr.txt_nextlv:setVisible(true)
                	attr.txt_nextlv:setText("+"..math.floor(next_lv_attr.attribute[attrId]) or 0)
                else
                    attr.img_to:setVisible(false)	 
                    attr.txt_nextlv:setVisible(false)      	
                end
                attr:setVisible(true)      
            else
                print("*ERROR*********EudemonTupoLayer:refreshjiachengEudemonInfo***************attrId*",attrId, " attrValue ",attrValue)
            end
        end 
    end
    -- end
    self.XinFainfo:setdifferLevel(self.XinFainfo.levelid)
    -- print("self.XinFainfo:getXiuLianAttribute():getPower()",self.XinFainfo:getXiuLianAttribute():getPower())
    self.txt_power_details:setText(self.XinFainfo:getTotalAttribute():getPower())
end

function XinFaXiuLianLayer:intensifyEquipEffect()
    if self.equipEffect == nil then
      TFResourceHelper:instance():addArmatureFromJsonFile("effect/equiIntensify.xml")
      local effect = TFArmature:create("equiIntensify_anim")
      effect:setAnimationFps(GameConfig.ANIM_FPS)
    
      local img_icon = self.img_fz
      effect:setPosition(ccp(430, 70))
      effect:setZOrder(100)
      img_icon:addChild(effect)
      self.equipEffect = effect
    end
    self.equipEffect:playByIndex(0, -1, -1, 0)
    if self.levelEffect == nil then
      TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
      local effect = TFArmature:create("equipIntensify_3_anim")
      effect:setAnimationFps(GameConfig.ANIM_FPS)
    
      local img_icon = self.img_lv.txt_curlv
      effect:setPosition(ccp(-40, -50))
      effect:setZOrder(100)
      img_icon:addChild(effect)
      self.levelEffect = effect
    end
    self.levelEffect:playByIndex(0, -1, -1, 0)

    self.shuaguang_effect = self.shuaguang_effect or {}
    for i = 1, #self.sxLayer do
        if not self.shuaguang_effect[i] then
            TFResourceHelper:instance():addArmatureFromJsonFile("effect/equipIntensify_3.xml")
            local effect = TFArmature:create("equipIntensify_3_anim")
            effect:setAnimationFps(GameConfig.ANIM_FPS)

            local img_intensify_lv = self.sxLayer[i]
            effect:setPosition(ccp(70, -60))
            img_intensify_lv:addChild(effect)
            self.shuaguang_effect[i] = effect
        end
        self.shuaguang_effect[i]:playByIndex(0, -1, -1, 0)
    end
end

function XinFaXiuLianLayer:refreshCost(itemdata)
	local costList = KongfuXiuLianData:GetCostByQualityAndLv(itemdata.quality,self.XinFainfo.level + 1,self.XinFainfo.config.usable)
	-- print("xinfaxiaohao",costList)
    self.btn_xiulian:setGrayEnabled(false)
    self.btn_xiulian:setTouchEnabled(true)
    self.btn_superxiulian:setGrayEnabled(false)
    self.btn_superxiulian:setTouchEnabled(true)
    if costList == nil or #costList == 0 then
        self.btn_xiulian:setGrayEnabled(true)
        self.btn_xiulian:setTouchEnabled(false)
        self.btn_superxiulian:setGrayEnabled(true)
        self.btn_superxiulian:setTouchEnabled(false)
        return
    end
	for i,data in ipairs(costList) do
      	if (data and data ~= "") then
      	    local info          = string.split(data, "_")
      	    local itemTypeId    = tonumber(info[1])
      	    local itemId        = tonumber(info[2])
      	    local itemNum       = tonumber(info[3])
      	    local btn           = self.costLayer[i]
            if costList[2] == "" then
              btn = self.costLayer[3]
            end
      	    if (btn) then
      	        btn:setVisible(true)
      	        btn.itemId          = itemId
      	        btn.itemTypeId      = itemTypeId
      	        -- print('itemType',itemTypeId)
                btn.logic = self
      	        btn:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowItemClickHandle),1)
      	        if itemTypeId == EnumDropType.GOODS then 
      	        	local item = ItemData:objectByID(itemId)
      	        	if (item) then
      	        	    local iconStr = item:GetPath()
      	        	    btn.img_tool:setTexture(iconStr)
      	        	    btn:setTextureNormal(GetColorIconByQuality(item.quality))
      	        	end
      	        	local num = XinFaManager:getIdenticalXinFaStuffNum(itemId,self.gmId)
      	        	btn.txt_num1:setText(num.."/"..itemNum)
      	    	    --btn.txt_num2:setText("/"..itemNum)
      	    	    -- if (num >= itemNum) then
      	    	    --     btn.txt_num1:setColor(ccc3(255,255,255))
      	    	    -- else
      	    	    --     btn.txt_num1:setColor(ccc3(255,0,0))
      	    	    -- end	
      	    	elseif itemTypeId == EnumDropType.ZHUXIN then
                    local num = MainPlayer:getResValueByType(EnumDropType.ZHUXIN)
      	    	    btn.img_tool:setTexture(GetZhuXinCoinIcon())
      	    	    btn:setTextureNormal(GetColorIconByQuality(4))
      	    	    btn.txt_num1:setText(num.."/"..itemNum)
      	    	end
      		end
   		end
   	end
end

function XinFaXiuLianLayer:UpLevelNumEffect(widget )
    TFDirector:killAllTween(widget)
    widget:setVisible(true)
    widget:setScale(0.1)
    local tween = {
        target = widget,
            {
                duration = 0.1,
                scale = 1,
            },
            {
                duration = 0.1,
                scale = 0.8,
            },
            {
                duration = 0.1,
                scale = 1,
            },
            {
                duration = 0,
                delay = 1,
                onComplete = function ()
                    widget:setVisible(false)

                end,
            },
    }
    TFDirector:toTween(tween)

end

function XinFaXiuLianLayer.OnXiuLianClick(sender)
	local self = sender.logic 
    -- 珠心币数量
    local zhuXinBi = MainPlayer:getResValueByType(EnumDropType.ZHUXIN)
    local huiXinBi = MainPlayer:getResValueByType(EnumDropType.HUIXIN)
    local needTip = false
    local itemNum = 0   --本子消耗数量
    local costNum = 0   --珠心币消耗数量
    local itemId = 0
    local tmpindex = 0  --用于判断需要升几级
    local upNum = 0     --实际可以升几级

    --是否是一键修炼(一键修炼只修炼5级)
    if (sender.isOneKey == true) then
        tmpindex = 5
    else
        tmpindex = 1
    end

    
    for i = 1,tmpindex do 
        if self.XinFainfo.level + i > XinFaManager.MAX_LEVEL then
            break
        end
        local costList = KongfuXiuLianData:GetCostByQualityAndLv(self.XinFainfo.config.quality,self.XinFainfo.level + i,self.XinFainfo.config.usable)
        costNum = tonumber(string.split(costList[1], "_")[3]) + costNum
        if (zhuXinBi + huiXinBi < costNum) then
            break
        end
        if (costList[2] ~= "") then
            local info          = string.split(costList[2], "_")
            itemId              = tonumber(info[2])
            local tmpItemNum    = tonumber(info[3])
            
            local bagHasItemNum = XinFaManager:getIdenticalXinFaStuffNum(itemId,self.gmId)
            if (bagHasItemNum < tmpItemNum) then               
                break
            end

            itemNum = itemNum + tmpItemNum
        end

        upNum = i
    end

    if (upNum == 0) then
        --提示:"物品不足"
        toastMessage(localizable.smithy_EquipmentRefining_pro)
        return
    elseif (itemNum > 0) then
        --提示:"升级需消耗多少本子"
        needTip = true
    else
        --普通珠心币升级,向服务器发送修炼请求
        XinFaManager:sendHeartMethodXiuLian(sender.isOneKey, self.XinFainfo.levelid, self.gmId)
    end


    --提示需要花费本子
  	if (needTip) then
        local item = ItemData:objectByID(itemId)
        CommonManager:showOperateSureLayer(
            function()
                XinFaManager:sendHeartMethodXiuLian(sender.isOneKey, self.XinFainfo.levelid, self.gmId)
            end,
            nil,
            {
                msg = stringUtils.format(localizable.Xinfa_tips_xiulian, itemNum, item.name),
            }
        )
        return true
    end

end

function XinFaXiuLianLayer.onShowItemClickHandle(sender)
    local self = sender.logic;
    if sender.itemId == 0 then
        Public:ShowItemTipLayer(nil, sender.itemTypeId)
    else
    	Public:ShowItemTipLayer(sender.itemId, sender.itemTypeId,XinFaManager:getIdenticalXinFaStuffNum(sender.itemId,self.gmId))
    end
end

function XinFaXiuLianLayer:registerEvents()
	self.super.registerEvents(self)
	self.btn_xiulian.logic = self
	self.btn_xiulian.isOneKey = false
	self.btn_xiulian:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnXiuLianClick),1)
	self.btn_superxiulian.logic = self
	self.btn_superxiulian.isOneKey = true
	self.btn_superxiulian:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnXiuLianClick),1)

	self.receiveInfo = function(event)     
    	self:refreshUI()
    end
    --升级完成事件
    TFDirector:addMEGlobalListener(XinFaManager.UpLevel, self.receiveInfo)
end

function XinFaXiuLianLayer:removeEvents()
    self.super.removeEvents(self)
    TFDirector:removeMEGlobalListener(XinFaManager.UpLevel, self.receiveInfo)
    self.receiveInfo = nil
end

return XinFaXiuLianLayer