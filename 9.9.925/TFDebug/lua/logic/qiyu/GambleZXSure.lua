--[[
******操作确定层*******

    -- by Stephen.tao
    -- 2014/2/27
]]

local GambleZXSure = class("GambleZXSure", BaseLayer)

--CREATE_SCENE_FUN(GambleZXSure)
CREATE_PANEL_FUN(GambleZXSure)


function GambleZXSure:ctor(data)
    self.super.ctor(self,data)
end

function GambleZXSure:initUI(ui)
	self.super.initUI(self,ui)

    self.btn_ok             = TFDirector:getChildByPath(ui, 'btn_ok')
    self.btn_cancel         = TFDirector:getChildByPath(ui, 'btn_cancel')
    self.txt_message        = TFDirector:getChildByPath(ui, 'txt_message')
    self.txt_title          = TFDirector:getChildByPath(ui, 'txt_title')
    self.img_title          = TFDirector:getChildByPath(ui, 'img_title')
    self.img_title          = TFDirector:getChildByPath(ui, 'img_title')
    self.checkbox_tip          = TFDirector:getChildByPath(ui, 'CheckBox_Game_1')
    self.txt_price          = TFDirector:getChildByPath(ui, 'txt_price')
    self.img_res_icon        = TFDirector:getChildByPath(ui, 'img_res_icon')
    self.img_res_icon2        = TFDirector:getChildByPath(ui, 'img_res_icon2')
    self.img_res_icon2:setVisible(false)
    self.img_res_icon:setVisible(true)
    self.sure_num_txt        = TFDirector:getChildByPath(ui, 'txt_numb')
    if self.sure_num_txt then
        self.sure_num_txt:setVisible(false)
    end
end

function GambleZXSure:removeUI()
	self.super.removeUI(self)

    self.btn_ok             = nil
    self.btn_cancel         = nil
end


function GambleZXSure:showSureTip(tips )
    self.sure_num_txt:setVisible(true)
    self.sure_num_txt:setText(tips)
end
function GambleZXSure:setData( data )
    self.data = data
end

function GambleZXSure:setUIConfig( uiconfig )
    self:init(uiconfig)
end

function GambleZXSure:setTitleImg( path )
    if self.img_title and path then
        self.img_title:setTexture(path)
    end
end

function GambleZXSure:setBtnOkText( text )
    if self.btn_ok and text then
        self.btn_ok:setText(text)
    end
end

function GambleZXSure:setBtnCancelText( text )
    if self.btn_cancel and text then
        self.btn_cancel:setText(text)
    end
end

function GambleZXSure:setTitle( title )
    if self.txt_title and title then
        self.txt_title:setText(title)
    end
end

function GambleZXSure:setMsg( msg )
    if self.txt_message and msg then
        self.txt_message:setText(msg)
    end
end

function GambleZXSure:setCostShow(costValue)
	if self.txt_price then
		self.txt_price:setText(costValue)
	end
end

function GambleZXSure:setBtnPic(btnPic)
	if btnPic and self.btn_ok then
		self.btn_ok:setTextureNormal(btnPic)
		self.btn_ok:setTexturePressed(btnPic)
	end
end

function GambleZXSure:setCostPic(costType)
	self.img_res_icon:setTexture(costType)
end

function GambleZXSure:setBtnHandle(okhandle, cancelhandle)
    if self.btn_ok then
        self.btn_ok.logic       = self
        self.btn_ok:addMEListener(TFWIDGET_CLICK,audioClickfun(function()
            local data = self.data;
            AlertManager:close()
            okhandle(data,self.checkbox_tip)
        end),1)
    end
    if self.btn_cancel then
        self.btn_cancel.logic   = self
        if cancelhandle then
            self.btn_cancel:addMEListener(TFWIDGET_CLICK, audioClickfun(function()
                cancelhandle(self.data,self.checkbox_tip)
            end),1)
        else
            self.btn_cancel:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onCancelBtnClickHandle),1)
        end
    end
end

function GambleZXSure.onCancelBtnClickHandle(sender)
    AlertManager:close(AlertManager.TWEEN_1);
end

function GambleZXSure:registerEvents()
    self.super.registerEvents(self)
end


return GambleZXSure
