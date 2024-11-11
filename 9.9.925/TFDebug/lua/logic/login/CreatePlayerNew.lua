
local CreatePlayerNew = class("CreatePlayerNew", BaseLayer)

CREATE_SCENE_FUN(CreatePlayerNew)
CREATE_PANEL_FUN(CreatePlayerNew)


--local firstName = {"雪山","飞狐","七道","双剑","江湖","虾米","剑客","刀郎","情剑",}
--local secondName = {"戴神","甘道","医胃","何小","杨大","郭菜","李四","陶大"}
local firstName = localizable.createPlayer_firstname
local secondName = localizable.createPlayer_secondName

local RoleIdList = GetPlayerRoleList()

function CreatePlayerNew:ctor(data)
    self.super.ctor(self,data)
    self.isAcc = true
    self:init("lua.uiconfig_mango_new.login.CreatePlayerNew")
    TFDeviceInfo:setOpenAccelerometer(true)
end

function CreatePlayerNew:initUI(ui)
	self.super.initUI(self,ui)

	   	-- 名字配置
    self.nameList = require("lua.table.t_s_name")
	self.familyNameNum 	= 0
	self.ManNameNum 	= 0
	self.WomanNameNum 	= 0

    -- 统计姓 名的个数
    for v in self.nameList:iterator() do
        if v.familyname ~= "" then
        	self.familyNameNum = self.familyNameNum + 1
        end

        if v.manname ~= "" then
        	self.ManNameNum = self.ManNameNum + 1
        end

        if v.womanname ~= "" then
        	self.WomanNameNum = self.WomanNameNum + 1
        end
    end

	self.btn_role 		= {}
	self.OkBtn 			= TFDirector:getChildByPath(ui, 'Btn_star')
	self.bg 			= TFDirector:getChildByPath(ui, 'bg')
	self.txt_desc1		= TFDirector:getChildByPath(ui, 'TextDesc1')
	self.txt_desc2		= TFDirector:getChildByPath(ui, 'TextDesc2')
	self.img_role 		= TFDirector:getChildByPath(ui, 'role_big')
	self.btn_roll 		= TFDirector:getChildByPath(ui, 'Btn_rename')
	self.Img_zhiye		= TFDirector:getChildByPath(ui, 'Img_zhiye')
	self.anim_panel		= TFDirector:getChildByPath(ui, 'anim_panel')
	self.playernameInputbg 	= TFDirector:getChildByPath(ui, 'bg_name')
	self.playernameInput = TFDirector:getChildByPath(ui, 'playernameInput')
	self.playernameInput:setCursorEnabled(true)

	self.btn_tianxie = TFDirector:getChildByPath(ui, "btn_tianxie")
	self.btn_tianxie.logic = self

	for i=1,4 do
		local str = "Button_CreatePlayerNew_" .. i
		self.btn_role[i] 	= TFDirector:getChildByPath(ui, str)
		self.btn_role[i]:setTag(i)
		self.btn_role[i].logic = self
	end


	self.roleNormalTextures = {'ui_new/createplayer/g1b.png','ui_new/createplayer/g3b.png','ui_new/createplayer/g4b.png','ui_new/createplayer/g2b.png'}
	self.roleSelectedTextures = {'ui_new/createplayer/g1.png','ui_new/createplayer/g3.png','ui_new/createplayer/g4.png','ui_new/createplayer/g2.png'}
	self.zhiyeTextures = {'ui_new/common/img_role_type1.png','ui_new/common/img_role_type3.png','ui_new/common/img_role_type4.png','ui_new/common/img_role_type2.png'}

	self.OkBtn.logic = self
	self.btn_roll.logic = self

	--print("------------------------CreatePlayerNew----------------------")
	math.randomseed(GetCorrectTime())	
    self.selectRoleIndex = 1 + math.ceil(math.random()*100)%4
	self.RoleBtnClickHandle(self.btn_role[self.selectRoleIndex])
	self:RollName()

	self.btn_tianxie:setVisible(false)
	-- if MainPlayer:getServerSwitchStatue(ServerSwitchType.JiaYuan) then
	-- 	self.btn_tianxie:setVisible(true)
	-- end
	-- self.btn_tianxie:setVisible(true)

	self.panel_flower = TFDirector:getChildByPath(ui, "panel_flower")
	self:playEffect()

	self.img_house_bg = TFDirector:getChildByPath(ui, "img_house_bg")

	local effectName = "create_player_bg"
	self:addBgEffect(effectName)
	effectName = "create_player_forebg"
	self:addBgEffect(effectName, 2)

	self.bg_move = {}
	self.initBgPos = {}
	self.curPos = {}
	for i = 1, 1 do
		self.bg_move[i] = TFDirector:getChildByPath(ui, "bg")
		self.initBgPos[i] = self.bg_move[i]:getPosition()
		self.curPos[i] = self.bg_move[i]:getPosition()
	end
	self.img_wuyan = TFDirector:getChildByPath(ui, "img_wuyan")
	self.img_wuyan:setVisible(false)
end

function CreatePlayerNew:addBgEffect(effectName, effectType)
	local size = self.bg:getSize()
	effectName = effectName or "create_player_bg"
	TFResourceHelper:instance():addArmatureFromJsonFile("effect/" .. effectName .. ".xml")
	local effect = TFArmature:create(effectName .. "_anim")
	if effect ~= nil then
		effect:setAnimationFps(GameConfig.ANIM_FPS)
		effect:playByIndex(0, -1, -1, 1)
		effect:setZOrder(11)
		effect:setPosition(ccp(size.width/2, size.height/2))
		if effectType and effectType == 2 then
			size = self.img_house_bg:getSize()
			-- effect:setPosition(ccp(size.width/2 - 43, size.height/2 - 10))
			effect:setPosition(ccp(size.width/2 - 130, size.height/2 - 40))
			self.img_house_bg:addChild(effect)
			return
		end
		self.bg:addChild(effect)
		self.bg.effect = effect
	end
end

function CreatePlayerNew:onRoleButtonSelect( index )
	for i=1,4 do
		self.btn_role[i]:setTextureNormal(self.roleNormalTextures[i])
	end
	self.btn_role[index]:setTextureNormal(self.roleSelectedTextures[index])
	self.Img_zhiye:setTexture(self.zhiyeTextures[index])

	self:playAnimByRoleId(index)
end


-- self.armature:play("move")
-- self.armature:play("back")
-- self.armature:play("attack", -1, -1, 0)
-- self.armature:play("skill", -1, -1, 0)
-- self.armature:play("stand", -1, -1, 1)
-- self.armature:play("hit", -1, -1, 0)


function CreatePlayerNew:playAnimByRoleId( index )

	local roleid = RoleIdList[index]
	if self.currEffect then
		self.currEffect:removeFromParent()
		self.currEffect = nil
	end

	if self.preRoleAnim then
		self.preRoleAnim:removeFromParent()
		self.preRoleAnim = nil
	end

	if self.reardTimeId then
    	TFDirector:removeTimer(self.reardTimeId);
        self.reardTimeId = nil
	end
	
	if self.currRoleAnim then
		self.preRoleAnim = self.currRoleAnim
		self.preRoleAnim:setVisible(true)
		self.preRoleAnim:play("move")
		self.currRoleAnim = nil
	end

	self.currRoleAnim = GameResourceManager:getRoleAniById(roleid)
	self.currRoleAnim.step = 1
	self.currRoleAnim:setPosition(ccp(0,0))
    self.currRoleAnim:play("move")
    self.currRoleAnim:setScale(1.3)
    self.anim_panel:addChild(self.currRoleAnim)
    self:SaveRoleID(roleid)

    --加阴影
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role3.xml")
	local effect2 = TFArmature:create("main_role3_anim")
	if effect2 ~= nil then
		effect2:setAnimationFps(GameConfig.ANIM_FPS)
		effect2:playByIndex(0, -1, -1, 1)
		effect2:setZOrder(-1)
		effect2:setPosition(ccp(-20, 100))
		self.currRoleAnim:addChild(effect2)
	end

    self.currEffect = self:getEffectByRoleId(index)
    self.currEffect:setPosition(ccp(0,0))
    self.anim_panel:addChild(self.currEffect)

	if self.attackSoundTimerID then
		TFDirector:removeTimer(self.attackSoundTimerID)
		self.attackSoundTimerID = nil
	end

    local moveDx = 380
    local movePreDx = nil

    if self.preRoleAnim then
    	print("----------self.preRoleAnim:getPositionX()-----------",self.preRoleAnim:getPositionX())
    	if self.preRoleAnim:getPositionX() >= 370 then
	    	movePreDx = 1
	    	self.currRoleAnim:setVisible(false)
	    else
			self.preRoleAnim:removeFromParent()
			self.preRoleAnim = nil
	    end
    end

	local function moveToPositonIn()
		if movePreDx then
			movePreDx = movePreDx * 3
		else
			moveDx = math.floor(moveDx/2)
		end
		

		if moveDx > 0 then	
			if self.preRoleAnim then
				self.preRoleAnim:setPositionX(self.preRoleAnim:getPositionX() + movePreDx)
				if movePreDx > 800 then
					movePreDx = nil
					self.preRoleAnim:removeFromParent()
					self.preRoleAnim = nil
					self.currRoleAnim:setVisible(true)
				end
			else
				self.currRoleAnim:setPositionX(self.currRoleAnim:getPositionX() + moveDx)
			end

		else
			if self.reardTimeId then
		    	TFDirector:removeTimer(self.reardTimeId);
		        self.reardTimeId = nil
		    end

			if self.preRoleAnim then
				self.preRoleAnim:removeFromParent()
				self.preRoleAnim = nil
			end
			self.currRoleAnim.step = self.currRoleAnim.step + 1
			self.currRoleAnim:play(self.currEffect.skillName, -1, -1, 0)
			if self.soundStartTime ~= nil and self.soundStartTime > 0 then
				self.attackSoundTimerID = TFDirector:addTimer(self.soundStartTime / FightManager.fightSpeed, 1, nil, 
				function() 
					if self.attackSoundTimerID then
						TFDirector:removeTimer(self.attackSoundTimerID)
						self.attackSoundTimerID = nil
					end
					self.attackSoundTimerID = nil
					TFAudio.playEffect(self.soundFile, false)
				end)
			else
				TFAudio.playEffect(self.soundFile, false)
			end

			self.currEffect:setPosition(self.currRoleAnim:getPosition())
			self.currEffect:playByIndex(0, -1, -1, 0)
			self.currRoleAnim:addMEListener(TFARMATURE_COMPLETE,
				function()
					self.currRoleAnim:removeMEListener(TFARMATURE_COMPLETE)
					self.currRoleAnim:play("stand", -1, -1, 1)
			end)
		end
	end
	-- moveToPositonIn()
	self.reardTimeId = TFDirector:addTimer(66, -1 , nil, moveToPositonIn)
end


function CreatePlayerNew:playEffect()

	TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_bg1.xml")
	local eff2 = TFArmature:create("main_bg1_anim")
	eff2:setPosition(ccp(self.bg:getSize().width/2,self.bg:getSize().height/2))
	eff2:setAnimationFps(GameConfig.ANIM_FPS)
	eff2:playByIndex(0, -1, -1, 1)
	eff2:setZOrder(1000)

	--self.bg:addChild(eff2)
	eff2:setPosition(ccp(300, 300))
	self.panel_flower:addChild(eff2)
end

function CreatePlayerNew:getEffectByRoleId( index )


	local roleid = RoleIdList[index]
	local spell_id = nil
	local descr1 = nil
	local descr2 = nil
	if index == 1 then
		spell_id = 7707		--杨过
		descr1 = localizable.createPlayer_namelist[1]
		descr2 = localizable.createPlayer_desc[1]
	elseif index == 2 then
		spell_id = 7807		--张无忌
		descr1 = localizable.createPlayer_namelist[2]
		descr2 =localizable.createPlayer_desc[2]
	elseif index == 3 then
		spell_id = 7907		--周芷若
		descr1 = localizable.createPlayer_namelist[3]
		descr2 = localizable.createPlayer_desc[3]
	else
		spell_id = 8007		--黄蓉
		descr1 = localizable.createPlayer_namelist[4]
		descr2 = localizable.createPlayer_desc[4]
	end
	TFAudio.stopAllEffects()
	RoleSoundData:playSoundByIndex(roleid)

	self.txt_desc1:setText(descr1)
	self.txt_desc2:setText(descr2)


	local spellInfo = SkillBaseData:objectByID(spell_id);
	local skillInfo = SkillDisplayData:objectByID(spellInfo.display_id)
	if skillInfo == nil then
		print("can't find "..spellInfo.display_id.." display_id")
		return
	end
	
	local nEffectID = skillInfo.attackEff[1]
	local resPathXML = "effect/"..nEffectID..".xml"
	local resPathAlats = "effect/"..nEffectID..".atlas" 
	local skillEff
	
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "effect/".. nEffectID
		skillEff = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		skillEff = TFArmature:create(nEffectID.."_anim")
	else
		return
	end
	if skillEff == nil then
		return
	end
	skillEff.skillName = skillInfo.attackAnim


	--sound
	local attackSoundID = skillInfo.attackSound
	if attackSoundID == nil or attackSoundID == 0 then
		return
	end
	self.soundFile = "sound/skill/"..attackSoundID..".mp3"
	self.soundStartTime = skillInfo.attackSoundTime	

	return skillEff
end

function CreatePlayerNew:SaveRoleID( id )
	local size = 1
	self.StorageRoleID = self.StorageRoleID or {}
	for k,v in pairs(self.StorageRoleID) do
		if v == id then
			return
		end
		size = size + 1
	end

	self.StorageRoleID[size] = id
end

function CreatePlayerNew:ReleaseRoleID()	
	for k,v in pairs(self.StorageRoleID) do
		GameResourceManager:deleRoleAniById(v)
	end
end

function CreatePlayerNew:registerEvents(ui)	

	self.super.registerEvents(self)

	for i=1,4 do
		self.btn_role[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.RoleBtnClickHandle))
	end

	self.OkBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OkBtnClickHandle),1)
	self.btn_roll:addMEListener(TFWIDGET_CLICK, audioClickfun(self.RollBtnClickHandle),1)
	TFDirector:addProto(s2c.CREATE_PLAYER_RESULT, self, self.createPlayerHandle)

	self.btn_tianxie:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onTianxieClickHandle),1)

	local pos = self.playernameInputbg:getPosition()
	print("pos(%d, %d)", pos.x, pos.y)

	--添加输入账号时输入框上移逻辑
	local function onTextFieldAttachHandle(input)
		print("onTextFieldAttachHandle")
        self.playernameInputbg:setPosition(ccp(pos.x,440))
    end
    
    self.playernameInput:addMEListener(TFTEXTFIELD_ATTACH, onTextFieldAttachHandle)

    local function onTextFieldChangedHandle(input)
		--self.playernameInputbg:setPosition(ccp(pos.x, pos.y))
		--self.playernameInput:closeIME()
    end
    self.playernameInput:addMEListener(TFTEXTFIELD_TEXTCHANGE, onTextFieldChangedHandle)

    local function onTextFieldDetachHandle(input)
        self.playernameInputbg:setPosition(ccp(pos.x, pos.y))
        self.playernameInput:closeIME()
    end
    self.playernameInput:addMEListener(TFTEXTFIELD_DETACH, onTextFieldDetachHandle)
    self.playernameInput:setMaxLengthEnabled(true)
    self.playernameInput:setMaxLength(10)

    local function spaceAreaClick(sender)
    	self.playernameInputbg:setPosition(ccp(pos.x, pos.y))
    	self.playernameInput:closeIME()
	end
    self.ui:setTouchEnabled(true)
    self.ui:addMEListener(TFWIDGET_CLICK, spaceAreaClick)


    ADD_KEYBOARD_CLOSE_LISTENER(self, self.ui)
    TFDirector:addProto(s2c.LOGIN_RESULT, self, self.loginHandle)

	self.switchCallBack = function(data)
		-- if MainPlayer:getServerSwitchStatue(ServerSwitchType.JiaYuan) then
		-- 	self.btn_tianxie:setVisible(true)
		-- else
		-- 	self.btn_tianxie:setVisible(false)
		-- end
	end    
    TFDirector:addMEGlobalListener(MainPlayer.SERVER_SWITCH_INFO_RESULT, self.switchCallBack)

    self.accelerometerUpdateCallBack = function(event)
		local data = event.data[1]
		if self and self.didAccelerate then
			self:didAccelerate(data)
		end
    end

	TFDirector:addMEGlobalListener("HeitaoSdk.ACCELEROMETER_UPDATE"  ,self.accelerometerUpdateCallBack)
end

function CreatePlayerNew:removeEvents()
	TFDirector:removeProto(s2c.CREATE_PLAYER_RESULT, self, self.createPlayerHandle)    
	TFDirector:removeProto(s2c.LOGIN_RESULT, self, self.loginHandle)

	self.super.removeEvents(self)
	for i=1,4 do
		self.btn_role[i]:removeMEListener(TFWIDGET_CLICK)
	end
	self.OkBtn:removeMEListener(TFWIDGET_CLICK)
	self.btn_roll:removeMEListener(TFWIDGET_CLICK)
    self.playernameInput:removeMEListener(TFTEXTFIELD_ATTACH)
    self.playernameInput:removeMEListener(TFTEXTFIELD_TEXTCHANGE)
    self.playernameInput:removeMEListener(TFTEXTFIELD_DETACH)
    self.ui:removeMEListener(TFWIDGET_CLICK)

    TFDirector:removeMEGlobalListener(MainPlayer.SERVER_SWITCH_INFO_RESULT, self.switchCallBack)    
  	self.switchCallBack = nil

  	if self.updateTimerID then
		TFDirector:removeTimer(self.updateTimerID)
		self.updateTimerID = nil
	end

  	TFDirector:removeMEGlobalListener("HeitaoSdk.ACCELEROMETER_UPDATE", self.accelerometerUpdateCallBack)    
  	self.accelerometerUpdateCallBack = nil
end

function CreatePlayerNew:removeUI()
	self.super.removeUI(self)

	self.btn_role			= nil
	--self.img_icon			= nil
	self.OkBtn				= nil
	self.img_role			= nil
	self.btn_roll			= nil
	--self.img_choice			= nil
	self.playernameInput	= nil
	self.selectRoleIndex    = nil
	TFDeviceInfo:setOpenAccelerometer(false)
	if self.attackSoundTimerID then
		TFDirector:removeTimer(self.attackSoundTimerID)
		self.attackSoundTimerID = nil
	end
	if self.reardTimeId then
    	TFDirector:removeTimer(self.reardTimeId);
        self.reardTimeId = nil
	end

	self:ReleaseRoleID()

	if self.currEffect then
		self.currEffect:removeFromParent()
		self.currEffect = nil
	end

	if self.preRoleAnim then
		self.preRoleAnim:removeFromParent()
		self.preRoleAnim = nil
	end

	if self.currRoleAnim then
		self.preRoleAnim = self.currRoleAnim
		self.preRoleAnim:removeFromParent()
		self.currRoleAnim = nil
	end
end

function CreatePlayerNew:loginHandle(event)
		-- print("event = ", event)
	if event.data.statusCode == 0 then
		if event.data.empty then
			hideAllLoading()
		end
	else
		--toastMessage("登陆失败")
		toastMessage(localizable.loginNoticePage_login_fail)
	end
end

function CreatePlayerNew:playChooseAction(index)
	-- local self = logic
	local pos = self.img_role:getPosition()
	if self.ChooseEffect == nil then
		local resPath = "effect/createroleaction.xml"
	    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
	    local effect = TFArmature:create("createroleaction_anim")

	    effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(self:getSize().width/2,self:getSize().height/2))

        self:addChild(effect,2)
       
	    self.ChooseEffect = effect
   	end
   	TFAudio.playEffect("sound/bgmusic/choose.mp3", false)
    self.ChooseEffect:playByIndex(index, -1, -1, 0)
end

function CreatePlayerNew.RoleBtnClickHandle(sender)
	local self = sender.logic
	if self == nil then return end
	
	-- 如果性别 有变化则重新随机名字
	local newTag = sender:getTag()
	local oldTag = self.selectRoleIndex
	self.selectRoleIndex = sender:getTag()

	self:onRoleButtonSelect(self.selectRoleIndex)

	if newTag > 2 and oldTag <= 2 then
		self:RollName()
	elseif newTag <= 2 and oldTag > 2 then
		self:RollName()
	end

	self.img_role:setTexture("ui_new/createplayer/role_"..self.selectRoleIndex..".png")
	--self:playChooseAction(self.selectRoleIndex-1)
end

function CreatePlayerNew.RollBtnClickHandle(sender)
	local self = sender.logic
	if self == nil then return end
	self:RollName()
end


function CreatePlayerNew.onTianxieClickHandle(sender)
	local self = sender.logic
	
	QiyuManager:openLoginAcceptLayer()
end

function CreatePlayerNew:RollName()
	local x = 0--math.random(0,100)%2
	local name = 0
	-- if x == 0 then
	-- 	local f1 = math.random(1,#firstName)
	-- 	local f2 = math.random(1,#secondName)
	-- 	name = firstName[f1] .. secondName[f2]
	-- else
	-- 	local f1 = math.random(1,#firstName)
	-- 	local f2 = math.random(1,#secondName)
	-- 	name = secondName[f2] ..firstName[f1] 
	-- end

	-- 
	local f1 			= math.random(1, self.familyNameNum)
	local familyname 	= self.nameList:getObjectAt(f1).familyname
	local name 			= ""
	-- 男
	if self.selectRoleIndex <= 2 then
		local f2 = math.random(1, self.ManNameNum)
		name = self.nameList:getObjectAt(f2).manname

	-- 女
	else
		local f2 = math.random(1, self.WomanNameNum)
		name = self.nameList:getObjectAt(f2).womanname
	end

	-- print("familyname = %s,len = %d", familyname, string.len(familyname))
	-- print("name = %s", name)
	self.playernameInput:setText(familyname..name)
end

function CreatePlayerNew.OkBtnClickHandle(btn)
	if btn.logic.selectRoleIndex == nil then
		--toastMessage("请选择角色")
		toastMessage(localizable.createPlayer_check_player)
		return
	end

	local playerName = btn.logic.playernameInput:getText()
	if playerName == nil or playerName == "" then
		--toastMessage("请输入角色名")
		toastMessage(localizable.createPlayer_input_player)
		return
	end

	local roleid = RoleIdList[btn.logic.selectRoleIndex]
	local roleInfo = RoleData:objectByID(roleid)
	if roleInfo == nil then
		--toastMessage("角色不存在")
		toastMessage(localizable.createPlayer_not_player)
		return
	end
	
	if CommonManager:getConnectionStatus() == false then
		print("创建角色的时候网络是关闭的， 重新连接")
		CommonManager:loginServer()
		return
	end

	local inviteCodeInfo = QiyuManager:GetInviteCodeData()

	local inviteCode = 0
	local deviceId = TFDeviceInfo.getMachineOnlyID() or "NULL"

	local code = QiyuManager:getLoginAcceptCode()
	if code and string.find(tostring(code), "^-?[1-9]%d*$") and tonumber(code) < math.pow(2, 31) then
		inviteCode = code
	end

	if inviteCode == 0 then
		local content = TFDeviceInfo:getClipBoardText()
		if content then 
			if string.find(tostring(content), "^-?[1-9]%d*$") then 
				if tonumber(content) < math.pow(2, 31) then
					inviteCode = content
				end
			elseif string.find(tostring(content), "%b##") then
				local a1, a2 = string.find(tostring(content), "%b##")
                if a1 and a2 then
                    local str = string.sub(tostring(content), a1 + 1, a2 - 1)
                    if string.find(tostring(str), "^-?[1-9]%d*$") and tonumber(str) < math.pow(2, 31) then
                        inviteCode = str
                    end
                end
			end
		end
	end

	local sex = {1,1,0,0}
	local createPlayerMsg = 			
	{
		playerName,
		sex[btn.logic.selectRoleIndex],
		roleInfo.id,
		tonumber(inviteCode),
		deviceId
	}
    showLoading();
	TFDirector:send(c2s.REGIST_DATA, createPlayerMsg)

	print("login inviteCode, deviceId = ", inviteCode, deviceId)
end

function CreatePlayerNew:createPlayerHandle(event)
	if event.data.statusCode ~= 0 then
		hideLoading();
		--toastMessage("创建角色失败")
		toastMessage(localizable.createPlayer_create_fail)
	else
		if HeitaoSdk then
			HeitaoSdk.trackCreateCharacter()
		end
		MainPlayer.bIsNewRole = true
		print("创建角色成功")
	end
end

function CreatePlayerNew:didAccelerate(data)
	if not data then
		return
	end

	if not self.bg_move then
		return
	end

	data.y = data.y - 5
	local deltaMax = 5
	if data.x > deltaMax then
		data.x = deltaMax
	elseif data.y > deltaMax then
		data.y = deltaMax
	elseif data.x < -deltaMax then
		data.x = -deltaMax
	elseif data.y < -deltaMax then
		data.y = -deltaMax
	end

	if data and data.y then
        data.y = -data.y
    end

    if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
        data.x = -data.x
    end

    --加速计的敏感值    
    local sensitivityX = 1.8  
    local sensitivityY = 0.9

    local maxDeltaX = 33
    local maxDeltaY = 40

    local scaleTab = {1}

    local deltaX = data.x / 5 * maxDeltaX * sensitivityX 
    local deltaY = data.y / 5 * maxDeltaY * sensitivityY 

    self.pTabX = {}
    self.pTabY = {}
    for i = 1, 1 do
    	self.curPos[i] = self.initBgPos[i]
    	self.pTabX[i] = self.curPos[i].x + deltaX * scaleTab[i]
    	self.pTabY[i] = self.curPos[i].y + deltaY * scaleTab[i]
    end

	--防抖动像素值
	local deltaX = 7
	local deltaY = 7

	self.newX = nil
	self.newY = nil
	if math.abs( self.pTabX[1] - self.bg_move[1]:getPositionX() ) > deltaX then
		self.newX = clone( self.pTabX ) 
	end
	if math.abs( self.pTabY[1] - self.bg_move[1]:getPositionY() ) > deltaY then
		self.newY = clone( self.pTabY ) 
	end

	if self.updateTimerID == nil then
	    self.updateTimerID = TFDirector:addTimer(30, -1, nil, 
	    function()
	    	for i = 1, 1 do
	    		local curppps = self.bg_move[i]:getPosition()
	    		
	    		if self.newX then
		    		local disX = self.newX[i] - curppps.x
		    		if math.abs(disX * 0.3) >= 1 then
		    			self.bg_move[i]:setPositionX(curppps.x + disX * 0.05)
		    		else
		    			self.bg_move[i]:setPositionX(self.newX[i])
		    		end
		    	end

		    	if self.newY then
		    		local disY = self.newY[i] - curppps.y
		    		if math.abs(disY * 0.3) >= 1 then
		    			self.bg_move[i]:setPositionY(curppps.y + disY * 0.05)
		    		else
		    			self.bg_move[i]:setPositionY(self.newY[i])
		    		end
		    	end
	    	end
	    end)
	end
end


return CreatePlayerNew;
