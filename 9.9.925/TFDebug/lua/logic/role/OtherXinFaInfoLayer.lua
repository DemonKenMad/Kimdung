-- client side OtherSkyBookInfoLayer.lua
--[[
 * @Description: 查看他人心法右侧信息界面
 ]]
-- script writer wuqi
-- creation time 2016-11-07

local RoleXinFaInfoLayer = class("RoleXinFaInfoLayer", BaseLayer)

RoleXinFaInfoLayer.MAX_ATTR_SIZE = 11

function RoleXinFaInfoLayer:ctor(gmId)
    self.super.ctor(self, data);

    self.isfirst = true
    self:init("lua.uiconfig_mango_new.Leaderboard.LeaderboardListLayer");
end

function RoleXinFaInfoLayer:loadData(equip, type)
    self.equip = equip;
    self.type = type;
end

function RoleXinFaInfoLayer:onShow()
    self.super.onShow(self)
    
    self:refreshBaseUI();
    self:refreshUI();
    if self.isfirst then
        self.isfirst = false
        self.ui:runAnimation("Action0", 1)
    end
end

function RoleXinFaInfoLayer:refreshBaseUI()

end

function RoleXinFaInfoLayer:refreshUI()
    if not self.equip then
        return
    end

    local totalAttr = self.equip:getTotalAttribute().attribute
    print(totalAttr)
    local count = 0
    for i = 1, EnumAttributeType.Max - 1 do
        if totalAttr[i] and totalAttr[i] ~= 0 and count < self.MAX_ATTR_SIZE then
            count = count + 1
            if i == 32 or i == 33 then
                self.txt_attr[count]:setText(AttributeTypeStr[i]..' + '..totalAttr[i]/100 ..'%')
            else
                self.txt_attr[count]:setText(AttributeTypeStr[i].." + " .. covertToDisplayValue(i, totalAttr[i], true))
            end
            self.txt_attr_num[count]:setText("")
            self.txt_attr[count]:setVisible(true)
            self.txt_attr_num[count]:setVisible(true)
        end
    end

    local immuneAttr = self.equip:getTupoAttribute().attribute
    for k, v in pairs(immuneAttr) do
        if v and k > 500 then
            count = count + 1
            self.txt_attr[count]:setText(localizable.XinFaSpecialbuteTypeStr[k]..' + '..v/100 ..'%')
            self.txt_attr_num[count]:setText("")
            self.txt_attr[count]:setVisible(true)
            self.txt_attr_num[count]:setVisible(true)
        end
    end
    self:openEquipDetail()
end

function RoleXinFaInfoLayer:initUI(ui)
    self.super.initUI(self, ui)
    self.btn_close = TFDirector:getChildByPath(ui, 'btn_close');

    self.panel_move_zhuangbei = TFDirector:getChildByPath(ui, "panel_move_zhuangbei")
    self.panel_move_tianshu = TFDirector:getChildByPath(ui, "panel_move_tianshu")
    self.panel_move_zhuangbei:setVisible(false)
    self.panel_move_tianshu:setVisible(true)
    local panel_node = self.panel_move_tianshu

    self.txt_attr = {}
    self.txt_attr_num = {}
    -- for i = 1, self.MAX_ATTR_SIZE do
    --     self.txt_attr[i] = TFDirector:getChildByPath(panel_node, "txt_attr" .. tostring(i))
    --     self.txt_attr_num[i] = TFDirector:getChildByPath(self.txt_attr[i], "txt_attr" .. tostring(i) .. "_num")
    --     self.txt_attr[i]:setVisible(false)
    --     self.txt_attr_num[i]:setVisible(false)
    -- end 
    local count = 1
    local childrenArr = panel_node:getChildren()
    for i=0,childrenArr:count()-1 do
        local child = TFDirector:getChildByPath(panel_node,'txt_attr'..count)
        if (child) then
            self.txt_attr[count] = child
            self.txt_attr_num[count] = TFDirector:getChildByPath(child, "txt_attr" .. count .. "_num")
            child:setVisible(false)
            self.txt_attr_num[count]:setVisible(false)
            count = count + 1
        end
    end
end

function RoleXinFaInfoLayer:openEquipDetail() 
    if self.curLayer then
        self.curLayer:getParent():removeLayer(self.curLayer, not self.curLayer.isCache);
    end
    local layer = AlertManager:getLayerFromCacheByName("lua.logic.role.OtherXinFaLayer")
    if not layer then
        layer = require("lua.logic.role.OtherXinFaLayer"):new();
    end
    layer.isfirst = self.isfirst
    layer:loadData(self.equip);
    layer:onShow();
    layer:setZOrder(0);
    self:addLayer(layer);
    self.curLayer = layer;
end

function RoleXinFaInfoLayer:registerEvents(ui)
    self.super.registerEvents(self);
end

function RoleXinFaInfoLayer:removeEvents()
    self.super.removeEvents(self);
    self.isfirst = true
end

return RoleXinFaInfoLayer