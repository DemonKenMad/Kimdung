-- client side OtherXinFaLayer.lua
--[[
 * @Description: 查看他人心法界面
 ]]
-- script writer wuqi
-- creation time 2016-11-03

local OtherXinFaLayer = class("OtherXinFaLayer", BaseLayer)

function OtherXinFaLayer:ctor()
    self.super.ctor(self,data)
    
    self.isfirst = true
    self:init("lua.uiconfig_mango_new.Leaderboard.LeaderboarddressLayer")
end

function OtherXinFaLayer:loadData(bible)
    self.bible = bible;
end

function OtherXinFaLayer:onShow()
    self.super.onShow(self)

    self:refreshUI();
    if self.isfirst == true then
        self.isfirst = false
        self.ui:runAnimation("Action0", 1)
    end
end

function OtherXinFaLayer:initUI(ui)
    self.super.initUI(self, ui)
    self.panel_close = TFDirector:getChildByPath(ui, 'panel_close')
    self.panel_chuandaizhuangbei = TFDirector:getChildByPath(ui, 'panel_chuandaizhuangbei')
    self.img_baoshicao1          = TFDirector:getChildByPath(self.panel_chuandaizhuangbei,'img_baoshicao1')
    self.img_baoshicao2          = TFDirector:getChildByPath(self.panel_chuandaizhuangbei,'img_baoshicao2')
    self.img_baoshicao1:setVisible(false)
    self.img_baoshicao2:setVisible(false)
    self.panel_equip = TFDirector:getChildByPath(ui, "Panel_Equip")
    self.panel_tianshu = TFDirector:getChildByPath(ui, "Panel_tianshu") 
    self.panel_tianshu:setVisible(false)
    self.panel_tianshu = TFDirector:getChildByPath(ui, "panel_xinfa") 
    self.panel_tianshu:setPositionX(87)
    self.panel_equip:setVisible(false)
    self.panel_tianshu:setVisible(true)
end

function OtherXinFaLayer:refreshUI()
    self:initAttr(self.panel_chuandaizhuangbei, self.bible);
end

function OtherXinFaLayer:initAttr(panel_node, equip)
    local img_zhuangbeibeijing_bg = TFDirector:getChildByPath(panel_node, 'img_zhuangbeibeijing_bg');
    local img_icon = TFDirector:getChildByPath(img_zhuangbeibeijing_bg, 'img_skill_icon');
    img_icon:setTexture(equip.config:GetPath());
    local img_quality = TFDirector:getChildByPath(img_zhuangbeibeijing_bg, 'btn_equip');
    img_quality:setTextureNormal(GetColorIconByQuality(equip.config.quality));
    XinFaManager:BindEffectOnEquip(img_quality, equip)

    local txt_name = TFDirector:getChildByPath(img_zhuangbeibeijing_bg, 'txt_zhuangbeiming');
    txt_name:setText(equip.config.name);
    local txt_qianghualv = TFDirector:getChildByPath(img_zhuangbeibeijing_bg, 'txt_qianghualv');
    -- if equip.level <= 1 then
        txt_qianghualv:setVisible(false)
    -- else
    --     --txt_qianghualv:setText(EnumXinFaLevelType[equip.level] .. "重")  common_chong
    --     txt_qianghualv:setText(equip.level)
    --     txt_qianghualv:setVisible(true)
    -- end

    local img_arrow = TFDirector:getChildByPath(img_zhuangbeibeijing_bg, 'img_jiantousheng');
    img_arrow:setVisible(false);
   
    --战力值
    local txt_power         = TFDirector:getChildByPath(panel_node, 'txt_zhanlizhi')
    txt_power:setVisible(false)
    local img_zhanlidi      = TFDirector:getChildByPath(panel_node, 'img_zhanlidi')
    local img_zhanlizhi     = TFDirector:getChildByPath(panel_node, 'img_zhandouli')
    img_zhanlizhi:setVisible(false)
    img_zhanlidi:setVisible(false)
    txt_power = TFDirector:getChildByPath(panel_node, 'txt_Xzhanlizhi')
    txt_power:setVisible(true)
    img_zhanlidi      = TFDirector:getChildByPath(panel_node, 'img_Xzhanlidi')
    img_zhanlidi:setVisible(true)
    img_zhanlizhi     = TFDirector:getChildByPath(panel_node, 'img_Xzhandouli')
    img_zhanlizhi:setVisible(true)


    txt_power:setText(equip:getpower())

    --Public:addStarImg(img_icon, equip.star)
	
	local img_baoshicao1 = TFDirector:getChildByPath(img_zhuangbeibeijing_bg, "img_baoshicao1")
	local img_gem1 = TFDirector:getChildByPath(img_baoshicao1, "img_gem")
    local img_baoshicao2 = TFDirector:getChildByPath(img_zhuangbeibeijing_bg, "img_baoshicao2")
    local img_gem2 = TFDirector:getChildByPath(img_baoshicao2, "img_gem")

    img_baoshicao1:setVisible(false)
    img_baoshicao2:setVisible(false)
    img_gem1:setVisible(false)
    img_gem2:setVisible(false)
    local txt_power = TFDirector:getChildByPath(panel_node, 'txt_zhanlizhi');
    --
    local txt_yanxiu = TFDirector:getChildByPath(self.panel_tianshu, "txt_extraattr_1") 
    local txt_yanxiu_num = TFDirector:getChildByPath(txt_yanxiu, "txt_extraattr_num_1")
    txt_yanxiu:setText(localizable.practiceResult_level..':')
    txt_yanxiu_num:setText(equip.level)
    local txt_can       = TFDirector:getChildByPath(self.panel_tianshu, "txt_extraattr_2")
    local txt_can_level = TFDirector:getChildByPath(txt_can, "txt_extraattr_num_1")
    txt_can:setText(localizable.XinFaTuPoLevel)
    txt_can_level:setText(equip.star)
    local txt_ninglian = TFDirector:getChildByPath(self.panel_tianshu, "txt_extraattr_3")
    local txt_ninglian_num = TFDirector:getChildByPath(txt_ninglian, "txt_extraattr_num_1")
    local ninglianlevel = 0
    for i = 1, 5 do
        ninglianlevel = ninglianlevel + (equip:getGemPosLevel(i) or 0)
    end
    txt_ninglian_num:setText(ninglianlevel)

    for i = 1, 5 do
        local img_baoshicao         =   TFDirector:getChildByPath(self.panel_tianshu, 'img_baoshicao'..i)
        img_baoshicao.img_baoshi    = TFDirector:getChildByPath(img_baoshicao, 'img_baoshi')
        img_baoshicao.txt_baoshishuxing     = TFDirector:getChildByPath(img_baoshicao, 'txt_baoshishuxing')
        img_baoshicao.txt_shuxingzhi        = TFDirector:getChildByPath(img_baoshicao, 'txt_shuxingzhi')
        local gemId = equip:getGemPos(i)
        local stone = ItemData:objectByID(gemId)
        local gemAttr = GemData:objectByID(gemId)
        if gemId ~= nil then
            img_baoshicao.img_baoshi:setTexture("icon/item/"..gemId..".png")
            img_baoshicao.img_baoshi:setVisible(true)
            img_baoshicao.txt_baoshishuxing:setText(localizable.AttributeTypeStr[stone.kind])
            img_baoshicao.txt_baoshishuxing:setVisible(true)
            if gemAttr.attribute and gemAttr.attribute ~= "" then 
                local attributekind , attributenum = gemAttr:getAttribute()
                local IsExtra, value = equip:getGemPosIsExtra(i)
                if IsExtra ~= 0 then
                    attributenum = attributenum * (1 + value)
                end
                img_baoshicao.txt_shuxingzhi:setText("+" .. attributenum)
                img_baoshicao.txt_shuxingzhi:setVisible(true)
            end
        else
            img_baoshicao.img_baoshi:setVisible(false)
            img_baoshicao.txt_baoshishuxing:setVisible(false)
            img_baoshicao.txt_shuxingzhi:setVisible(false)
        end
    end
end

function OtherXinFaLayer:removeUI()
	self.super.removeUI(self)
end

function OtherXinFaLayer:registerEvents(ui)
    self.super.registerEvents(self);
end

function OtherXinFaLayer:removeEvents()
	self.super.removeEvents(self)
    self.isfirst = true
end

return OtherXinFaLayer