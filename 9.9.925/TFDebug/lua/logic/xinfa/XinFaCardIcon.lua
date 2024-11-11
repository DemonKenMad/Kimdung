-- client side XinFaCardIcon.lua
--[[    
 * @Description: 心法icon
 ]]

local XinFaCardIcon = class("XinFaCardIcon", BaseLayer)

function XinFaCardIcon:ctor(gmId)
    self.super.ctor(self, gmId)
    self.gmId = gmId
    self:init("lua.uiconfig_mango_new.smithy.SmithyEquipIcon")
end

function XinFaCardIcon:initUI(ui)
    self.super.initUI(self,ui)

    self.img_quality        = TFDirector:getChildByPath(ui, 'img_quality')
    self.img_icon           = TFDirector:getChildByPath(ui, 'img_icon')
    self.txt_name           = TFDirector:getChildByPath(ui, 'txt_name')
    self.lbl_power          = TFDirector:getChildByPath(ui, 'lbl_power')
    self.txt_power          = TFDirector:getChildByPath(ui, 'txt_power')
    self.txt_intensify_lv   = TFDirector:getChildByPath(ui, 'txt_intensify_lv')
    self.img_gem = {}
    self.img_gembg = {}
    for i=1,EquipmentManager.kGemMergeTargetNum do
        self.img_gem[i]            = TFDirector:getChildByPath(ui, 'img_gem'..i)
        self.img_gembg[i]          = TFDirector:getChildByPath(ui, 'img_gembg'..i)
        self.img_gem[i]:setVisible(false)
        self.img_gembg[i]:setVisible(false)
    end
    self.bg                 = TFDirector:getChildByPath(ui, 'bg')

    --提示性控件
    self.img_improve        = TFDirector:getChildByPath(ui, 'img_improve')
    self.img_equiped        = TFDirector:getChildByPath(ui, 'img_equiped')
    self.txt_equiped_name   = TFDirector:getChildByPath(ui, 'txt_equiped_name')
    self.img_improve:setVisible(false)
    
    --星级，目前设定为屏蔽不显示
    self.panel_star         = TFDirector:getChildByPath(ui, 'panel_star')
    self.panel_star:setVisible(false)
    self.img_star = {}
    for i=1,EquipmentManager.kMaxStarLevel do
        local str           = "img_star_"..i
       self.img_star[i]     = TFDirector:getChildByPath(ui, str)
    end
    self.panel_star_xinfa = TFDirector:getChildByPath(ui, 'panel_star_xinfa')
    self.txt_starlv = TFDirector:getChildByPath(self.panel_star_xinfa, 'txt_starlv')
    self.xinfaimg_star   = TFDirector:getChildByPath(self.panel_star_xinfa, 'img_star')
    self.panel_star_xinfa:setVisible(true)
    self.bg.logic = self

    --显示空白网格逻辑添加
    self.panel_empty            = TFDirector:getChildByPath(ui, 'panel_empty')
    self.panel_info             = TFDirector:getChildByPath(ui, 'panel_info')

    --选择标识
    self.panel_select = TFDirector:getChildByPath(ui, 'panel_select')
    self.Image_select = TFDirector:getChildByPath(ui, 'Image_select')

    self.img_zhanli = TFDirector:getChildByPath(ui, "img_zhanli")
    self.img_zhanli:setVisible(false)

    self.img_splash = TFDirector:getChildByPath(ui, "img_splash")
    self.img_splash:setVisible(false)
end

function XinFaCardIcon:removeUI()
    self.super.removeUI(self)
end

function XinFaCardIcon:setLogic( layer )
    self.logic = layer
end

function XinFaCardIcon:setEquipGmId( gmId )
    self.gmId = gmId
    self:refreshUI()
end

function XinFaCardIcon:refreshUI()
    if not self.gmId then
        self.panel_empty:setVisible(true)
        self.panel_info:setVisible(false)
        return
    end

    local equip = XinFaManager:getXinFaByGmId(self.gmId)
    if equip == nil  then
        self.panel_empty:setVisible(true)
        self.panel_info:setVisible(false)
        return
    end

    self.panel_empty:setVisible(false)
    self.panel_info:setVisible(true)
    self.img_icon:setTexture(equip.config:GetPath())
    self.img_quality:setTexture(GetColorIconByQuality_118(equip.config.quality))
    self.txt_name:setText(equip.config.name)
    self.txt_name:setScale(0.9)

    self.txt_power:setVisible(false)
    if equip.level <= 1 then  
        self.txt_intensify_lv:setVisible(false)
    else
        self.txt_intensify_lv:setText("+"..equip.level)
        self.txt_intensify_lv:setVisible(true)
    end 
    print("equip.star",equip.star)
    if equip.star <= 0 then 
        self.txt_starlv:setVisible(false)
        self.xinfaimg_star:setVisible(false)
    else
        self.txt_starlv:setVisible(true)
        self.xinfaimg_star:setVisible(true)
        self.txt_starlv:setText(equip.star)
    end

    self.txt_equiped_name:setVisible(false)
    if equip.equip then
        self.txt_equiped_name:setText(CardRoleManager:getRoleById(equip.equip).name)
        self.txt_equiped_name:setVisible(true)
        self.img_equiped:setVisible(true)
    else
        self.img_equiped:setVisible(false)
    end
    self.bg:addMEListener(TFWIDGET_CLICK, audioClickfun(self.iconClickHandle))
end

function XinFaCardIcon.iconClickHandle(sender)
    local self = sender.logic

    if self.logic ~= nil then 
        self.logic:setSelectId(self.gmId)
    end
end

function XinFaCardIcon:registerEvents()
    self.super.registerEvents(self)
end

function XinFaCardIcon:removeEvents()
    self.bg:removeMEListener(TFWIDGET_CLICK)
    self.super.removeEvents(self)
end

function XinFaCardIcon:setDuigouVisiable( enable )
    if enable then
        self.panel_select:setVisible(true)
        self.Image_select:setVisible(true)
    else
        self.panel_select:setVisible(false)
        self.Image_select:setVisible(false)
    end        
end


function XinFaCardIcon:getDuigouVisiable()
    return self.panel_select:isVisible()
end

function XinFaCardIcon:getEquipGmId()
    return self.gmId
end



return XinFaCardIcon
