
local RoleSkillUpCell = class("RoleSkillUpCell", BaseLayer)

function RoleSkillUpCell:ctor(data)

	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.role_new.RoleSkillUpCell")

end

function RoleSkillUpCell:initUI( ui )
	self.super.initUI(self, ui)

	self.panel_hui_shenjitupo = TFDirector:getChildByPath(ui,"panel_hui_shenjitupo")
	self.img_bg = TFDirector:getChildByPath(ui,"img_bg")
	self.bg_qianli = TFDirector:getChildByPath(ui,"bg_qianli")
	self.txt_name = TFDirector:getChildByPath(ui,"txt_name")
	self.txt_condition = TFDirector:getChildByPath(ui,"txt_condition")
	self.img_yijihuo = TFDirector:getChildByPath(ui,"img_yijihuo")
	self.txt_yuanfen_word = TFDirector:getChildByPath(ui,"txt_yuanfen_word")

end

function RoleSkillUpCell:removeUI()
	
	self.super.removeUI(self)

end

function RoleSkillUpCell:dispose()
	 if self.end_timerID then
        TFDirector:removeTimer(self.end_timerID)
        self.end_timerID = nil
    end
	self.super.dispose(self)
end

function RoleSkillUpCell:registerEvents()
	self.super.registerEvents(self)
end

function RoleSkillUpCell:removeEvents()

    self.super.removeEvents(self)
end

function RoleSkillUpCell:setData(cardRole,item)
	local curr_star = cardRole.skillStarLevel
	if not  curr_star then 
		curr_star = 0
	end	
	
	if curr_star < item.star_lv then
		self.txt_condition:setVisible(true)
		self.img_yijihuo:setVisible(false)
		self.img_bg:setTexture("ui_new/rolerisingstar/bg_ql1.png")
		self.bg_qianli:setTexture("ui_new/rolerisingstar/bg_qianli1.png")

		self.txt_name:setColor(ccc3(0x00,0x00,0x00))

	else
		self.txt_condition:setVisible(false)
		self.img_yijihuo:setVisible(true)
		self.img_bg:setTexture("ui_new/rolerisingstar/bg_ql2.png")
		self.bg_qianli:setTexture("ui_new/rolerisingstar/bg_qianli2.png")
		self.txt_name:setColor(ccc3(0xff,0xff,0xff))
	end	
	self.txt_name:setText(item.name)
	self.txt_yuanfen_word:setText(item.desc)


end


function RoleSkillUpCell:PlayEffect()
	-- body
	local filePath = "effect/ui/qihe3.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(filePath)

    local effect = TFArmature:create("qihe3_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:playByIndex(0, -1, -1, 0)
    effect:setScaleX(1.1)
    effect:setScaleY(1.35)
    effect:setVisible(true)
    effect:setPosition(ccp(225,59))
    self.panel_hui_shenjitupo:addChild(effect,100)
    
    self.effect = effect
    --[[
    effect:addMEListener(TFARMATURE_COMPLETE,function()
        self.effect:removeMEListener(TFARMATURE_COMPLETE) 
        self.effect:setVisible(false)   		
    end)
	]]

	if  self.end_timerID == nil then
        self.end_timerID = TFDirector:addTimer(1000, -1, nil, 
        function() 
            if self.end_timerID ~= nil then
                self.effect:setVisible(false) 
            end
        end)
    end

end


return RoleSkillUpCell