-- client side CrossArrayOrganLayer.lua
--[[
 * @Description: BUFF显示界面
 ]]
-- script writer chikui
-- creation time 2016-08-13


local CrossArrayOrganLayer = class("CrossArrayOrganLayer", BaseLayer);


function CrossArrayOrganLayer:ctor(data)
    self.super.ctor(self,data);
    self:init("lua.uiconfig_mango_new.crossarray.CrossArrayRandom");
end


function CrossArrayOrganLayer:initUI(ui)
    self.super.initUI(self,ui);

    self.img_bad         = TFDirector:getChildByPath(ui, 'img_bad');
    self.img_good        = TFDirector:getChildByPath(ui, 'img_good');
    self.txt_bad         = TFDirector:getChildByPath(ui, 'txt_bad');
    self.txt_good        = TFDirector:getChildByPath(ui, 'txt_good');
    
end

function CrossArrayOrganLayer:onShow()
    self.super.onShow(self)
end

function CrossArrayOrganLayer:refreshUI()
    if not self.isShow then
        return;
    end
end

function CrossArrayOrganLayer:setInfo(value,desc)
    if value > 0 then
        self.img_good:setVisible(true)
        self.txt_good:setVisible(true)
        self.img_bad:setVisible(false)
        self.txt_bad:setVisible(false)
        self.txt_good:setText(desc .. '+' .. value .. "%")
    else
        self.img_good:setVisible(false)
        self.txt_good:setVisible(false)
        self.img_bad:setVisible(true)
        self.txt_bad:setVisible(true)
        self.txt_bad:setText(desc .. value .. "%")
    end
end


function CrossArrayOrganLayer:removeUI()
    self.super.removeUI(self);

end

function CrossArrayOrganLayer:registerEvents()
    self.super.registerEvents(self);
end

function CrossArrayOrganLayer:removeEvents()
    self.super.removeEvents(self);
end

return CrossArrayOrganLayer;
