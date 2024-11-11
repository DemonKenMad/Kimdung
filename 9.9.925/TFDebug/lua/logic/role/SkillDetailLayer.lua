--[[
******技能详情*******

	-- by haidong.gan
	-- 2013/12/5
]]

local SkillDetailLayer = class("SkillDetailLayer", BaseLayer)


--CREATE_SCENE_FUN(SkillDetailLayer)
CREATE_PANEL_FUN(SkillDetailLayer)

function SkillDetailLayer:ctor()
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.role.SkillDetailLayer")

end

function SkillDetailLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.btn_close          = TFDirector:getChildByPath(ui, 'btn_close')

    self.btn_dianfeng       = TFDirector:getChildByPath(ui, 'btn_wl1');
    self.btn_chushi         = TFDirector:getChildByPath(ui, 'btn_wl2');
    self.txt_jihuo          = TFDirector:getChildByPath(ui, 'txt_jihuo');
    self.btn_chushi:setVisible(false)
    self.btn_dianfeng:setVisible(true)
    self.txt_jihuo:setVisible(false)

    self.txt_name             = TFDirector:getChildByPath(ui, 'txt_name');
    self.img_skillkuang       = TFDirector:getChildByPath(ui, 'img_skillkuang');
    self.img_skill            = TFDirector:getChildByPath(ui, 'img_skill');

    self.txt_skill_type       = TFDirector:getChildByPath(ui, 'txt_skill_type');
    self.txt_attack_type      = TFDirector:getChildByPath(ui, 'txt_attack_type');

    self.txt_level    = TFDirector:getChildByPath(ui, 'txt_level');
    self.txt_need     = TFDirector:getChildByPath(ui, 'txt_need');

    self.panel_des1      = TFDirector:getChildByPath(ui, 'panel_des1');
    self.panel_des2      = TFDirector:getChildByPath(ui, 'panel_des2');
    self.panel_des3      = TFDirector:getChildByPath(ui, 'panel_des3');
    self.img_petkill     = TFDirector:getChildByPath(ui, 'img_petkill');
    self.img_petkill:setVisible(false)
    self:setCascadeOpacityEnabled(false)
    local richText_1 = TFRichText:create(self.panel_des1:getSize())
    -- richText_1:setTouchEnabled(true)
    richText_1:setPosition(ccp(0,0))
    richText_1:setAnchorPoint(ccp(0, 0.5))
    self.panel_des1:removeAllChildren()
    self.panel_des1:addChild(richText_1)

    self.txt_des1      = richText_1;

    local richText_2 = TFRichText:create(self.panel_des2:getSize())
    -- richText_2:setTouchEnabled(true)
    richText_2:setPosition(ccp(0,0))
    richText_2:setAnchorPoint(ccp(0, 0.5))
    self.panel_des2:removeAllChildren()
    self.panel_des2:addChild(richText_2)

    self.txt_des2      = richText_2;

    local richText_3 = TFRichText:create(self.panel_des3:getSize())
    -- richText_3:setTouchEnabled(true)
    richText_3:setPosition(ccp(0,0))
    richText_3:setAnchorPoint(ccp(0, 0.5))
    self.panel_des3:removeAllChildren()
    self.panel_des3:addChild(richText_3)

    self.txt_des3      = richText_3;
end

function SkillDetailLayer:loadData(cardrole_id,spellInfo,spellLevelInfo,index, isPet,star,XinFaSpecialAttribute, quality)
    if star == nil then
        star = 0
    end
    -- self.skillId = spellInfo.id
    -- self.spellInfo = spellInfo
    -- self.spellLevelInfo  = spellLevelInfo;
    -- self.cardrole_id = cardrole_id
    -- local replaceSkillId ,jihuo_star = self.skillId , star
    -- if index and index == 4 then
    --     replaceSkillId ,jihuo_star = CardRoleManager:isSkillReplace(cardrole_id, star, self.skillId,0)
    -- else
    --     replaceSkillId ,jihuo_star = CardRoleManager:isSkillReplace(cardrole_id, star, self.skillId)
    -- end
    -- if replaceSkillId ~= self.skillId then
    --     self.spellLevelInfo = SkillLevelData:getInfoBySkillAndLevel( replaceSkillId , self.spellLevelInfo.level);
    -- end
    

    -- self.spellInfo = SkillBaseData:objectByID(replaceSkillId);
    -- self.index = index
    -- self.isPet = isPet
    -- self.jihuo_star = jihuo_star
    self.quality = quality
    self.inside = 0
    self.outside = 0
    self.skillId = spellInfo.id
    self.cardrole_id = cardrole_id
    self.spellInfo   = spellInfo;
    self.spellLevelInfo  = spellLevelInfo;
    self.index = index
    self.isPet = isPet
    self.XinFaSpecialAttribute = XinFaSpecialAttribute
    if (IllustrationManager.isOpenTuJian == true) then
        self:onChuShiClick()
    else
        self:refreshUI();
    end
    
end

function SkillDetailLayer:loadDataById(star)
    if star == nil then
        star = 0
    end
    local spellLv = self.spellLevelInfo.level
    --这里必须要初始化一下,不然,嘿嘿
    self.spellLevelInfo = nil
    self.spellInfo = nil
    self.jihuo_star = nil
    local replaceSkillId ,jihuo_star = self.skillId , 0

    if self.index and self.index == 4 then
        if (star == 10) then star = 2 -- 第四个技能必须要有准确的星级,而第四个技能的巅峰是 + 2
        elseif (star == 15) then star = 3 end
        replaceSkillId ,jihuo_star = CardRoleManager:isSkillReplace(self.cardrole_id , star, self.skillId, star, self.quality)
    else
        replaceSkillId ,jihuo_star = CardRoleManager:isSkillReplace(self.cardrole_id , star, self.skillId, nil, self.quality)
    end
    self.spellLevelInfo = SkillLevelData:getInfoBySkillAndLevel( replaceSkillId , spellLv); 

    self.jihuo_star = jihuo_star
    self.spellInfo   = SkillBaseData:objectByID(replaceSkillId);
    self:refreshUI();
end

function SkillDetailLayer:onShow()
    self.super.onShow(self)
    self:refreshBaseUI();
end

function SkillDetailLayer:refreshBaseUI()

end

function SkillDetailLayer:refreshUI()
    -- if not self.isShow then
    --     return;
    -- end
    self.txt_name:setText(self.spellInfo.name);
    self.img_skill:setTexture(self.spellInfo:GetPath());  

    if self.spellInfo.hidden_skill == 1 then
        --self.txt_skill_type:setText("被动技能");
        self.txt_skill_type:setText(localizable.SkillDetail_reactive_skill);
    elseif self.spellInfo.hidden_skill == 2 then
        --self.txt_skill_type:setText("被动技能");
         self.txt_skill_type:setText(localizable.SkillDetail_fightBegin_skill)
    else
        self.txt_skill_type:setText(SkillTypeStr[self.spellInfo.type]);
    end

    self.txt_attack_type:setText(SkillTargetTypeStr[self.spellInfo.target_type]);
    if (self.isPet ~= true) then
        self.img_petkill:setVisible(false)
        self.txt_level:setVisible(true)
        self.txt_need:setVisible(true)
        self.txt_level:setText(self.spellLevelInfo.level);
    --self.txt_need:setText(self.spellInfo.trigger_anger .. "点怒气");

        if self.index ~= 4 then
            self.txt_need:setText(stringUtils.format(localizable.SkillDetail_nuqi,self.spellInfo.trigger_anger));
        else
            self.txt_need:setText(stringUtils.format(localizable.SkillDetail_shayi,self.spellInfo.trigger_anger));
        end
        if self.spellInfo.trigger_anger < 1 then
            if self.spellInfo.hidden_skill ~= 3 then
                --self.txt_need:setText("不消耗怒气");
                self.txt_need:setText(localizable.SkillDetail_not_nuqi);
            else
                --self.txt_need:setText("不消耗点战意");
                self.txt_need:setText(localizable.SkillDetail_shayi_0);
            end
        end
    else
        self.img_petkill:setVisible(true)
        self.txt_level:setVisible(false)
        self.txt_need:setVisible(false)
    end
    self:AddXinFaSpecialAttribute()
    self.txt_des1:setText(self.spellInfo:getTichTextDes(self.spellLevelInfo,self.spellInfo.description))
    --print("self.outside,self.inside",self.outside,self.inside)
    self.txt_des2:setText(self.spellInfo:getTichTextDes(self.spellLevelInfo,self.spellInfo.power,nil,self.outside,self.inside))
    self.txt_des3:setText(self.spellInfo:getTichTextDes(self.spellLevelInfo,self.spellInfo.skill_add))
    if (IllustrationManager.isOpenTuJian ~= true) then
        self.btn_dianfeng:setVisible(false)
        self.btn_chushi:setVisible(false)
        self.txt_jihuo:setVisible(false)
    else
        local jiHuoStr = stringUtils.format(localizable.SkillDetail_jihuo,EnumWuxueLevelType[self.jihuo_star])
        self.txt_jihuo:setText(jiHuoStr)
    end

--     [[<p style="text-align:left margin:5px">
-- <font color="#000000" fontSize = "20">对敌方全体造成</font>
-- <font color="#000000" fontSize = "20">51% </font>
-- <font color="#FF0000" fontSize = "20" fontSize = "20">（+0 %）</font>
-- <font color="#000000" fontSize = "20">的武力，</font>
-- <font color="#000000" fontSize = "20">41% </font>
-- <font color="#FF0000" fontSize = "20">（+0 %）</font>
-- <font color="#000000" fontSize = "20">的内力，</fon
-- t>
-- <font color="#F
-- F0000">140% </font>
-- <font color="#FF0000" fontSize = "20">（+10 %）</font>
-- <font color="#FF0000">的火属性伤害，一定概率使对方烧伤。</font>
-- </p>]]
end

--巅峰效果
function SkillDetailLayer.onDianFengClick(sender)
    local self = sender.logic
    self.btn_chushi:setVisible(true)
    self.btn_dianfeng:setVisible(false)
    --终极技能不需要显示激活星级
    if (self.index ~= 4) then
        self.txt_jihuo:setVisible(true)
    else
        self.txt_jihuo:setVisible(false)
    end
    self.quality = CardRoleManager:getMaxQualityByCard(self.cardrole_id) or self.quality
    local star = 10
    if (self.quality and self.quality == 7) then
        star = 15
    end
    
    self:loadDataById(star)

end
--初始效果
function SkillDetailLayer.onChuShiClick(sender)
    local self = sender.logic
    self.btn_chushi:setVisible(false)
    self.btn_dianfeng:setVisible(true)
    self.txt_jihuo:setVisible(false)
    self:loadDataById(0)

end
function SkillDetailLayer:removeUI()
	self.super.removeUI(self)
end

function SkillDetailLayer:registerEvents(ui)
    self.super.registerEvents(self);

    self.btn_dianfeng:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onDianFengClick),1)
    self.btn_dianfeng.logic = self
    self.btn_chushi:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onChuShiClick),1)
    self.btn_chushi.logic = self
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)    
end

function SkillDetailLayer:removeEvents()
	self.super.removeEvents(self)
end
function SkillDetailLayer:AddXinFaSpecialAttribute()
    if self.XinFaSpecialAttribute and self.XinFaSpecialAttribute.attribute ~= nil then 
        if self.XinFaSpecialAttribute.attribute[501] ~= nil  and self.index == 1 then
            if self.spellLevelInfo.outside ~= 0 then
                self.outside = self.spellLevelInfo.outside + self.XinFaSpecialAttribute.attribute[501]/10000
            end 
            if self.spellLevelInfo.inside ~= 0 then
                self.inside = self.spellLevelInfo.inside + self.XinFaSpecialAttribute.attribute[501]/10000
            end 
        end
        if self.XinFaSpecialAttribute.attribute[502] ~= nil  and self.index == 1 then
            if self.spellLevelInfo.outside ~= 0 then
                self.outside = self.spellLevelInfo.outside + self.XinFaSpecialAttribute.attribute[502]/10000
            end 
        end
        if self.XinFaSpecialAttribute.attribute[504] ~= nil  and self.index == 1 then
            if self.spellLevelInfo.inside ~= 0 then
                self.inside = self.spellLevelInfo.inside + self.XinFaSpecialAttribute.attribute[504]/10000
            end 
        end
        if self.XinFaSpecialAttribute.attribute[505] ~= nil  and self.index == 4 then
            if self.spellLevelInfo.outside ~= 0 then
                self.outside = self.spellLevelInfo.outside + self.XinFaSpecialAttribute.attribute[505]/10000
            end 
            if self.spellLevelInfo.inside ~= 0 then
                self.inside = self.spellLevelInfo.inside + self.XinFaSpecialAttribute.attribute[505]/10000
            end 
        end
    end
end
return SkillDetailLayer

