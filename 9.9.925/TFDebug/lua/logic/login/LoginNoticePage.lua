
local LoginNoticePage = class("LoginNoticePage", BaseLayer)
local serverList = require('lua.config.server')
if LogonHelper == nil then
LogonHelper = require('lua.manager.LogonHelper')
end

CREATE_SCENE_FUN(LoginNoticePage)
CREATE_PANEL_FUN(LoginNoticePage)

local auto_refresh_time = 1000 * 60 --秒



function LoginNoticePage:ctor(data)
    self.super.ctor(self,data)
    self.isAcc = true
    self:init("lua.uiconfig_mango_new.login.LoginNoticePage")
    TFDeviceInfo:setOpenAccelerometer(true)
end

function LoginNoticePage:initUI(ui)
	self.super.initUI(self,ui)
	self.ui = ui
	LoginNoticePage.ui = ui

	self.btn_login 			= TFDirector:getChildByPath(ui, 'btn_login')
	
	LoginNoticePage.panel_close 			= TFDirector:getChildByPath(ui, 'panel_close')

    local resPath = "effect/loading_simple.xml"

    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local skillEff = TFArmature:create("loading_simple_anim")
    skillEff:setPosition(ccp(GameConfig.WS.width/2,300))

    -- skillEff:setPosition(ccp(effPosX, effPosY))
    skillEff:setAnimationFps(GameConfig.ANIM_FPS)
    skillEff:playByIndex(0, -1, -1, 1)
    LoginNoticePage.panel_close:addChild(skillEff,2)


    self.img_gonggaodi      = TFDirector:getChildByPath(ui, 'img_gonggaodi')

	self.btn_selectServer	= TFDirector:getChildByPath(ui, 'btn_selectServer')

	self.btn_register	 	= TFDirector:getChildByPath(ui, 'btn_register')
	self.btn_register.logic = self

	self.txt_area	 = TFDirector:getChildByPath(ui, 'txt_area')
	self.input_name  = TFDirector:getChildByPath(ui, 'input_name')
	self.lb_name     = TFDirector:getChildByPath(ui, 'lb_name')

	self.btn_selectAcount = TFDirector:getChildByPath(ui, 'btn_selectAcount')

	self.input_name:setCursorEnabled(true)

	self.img_bg 	= TFDirector:getChildByPath(ui, 'bg')

	--add by david.dai
	self.img_input_bg = TFDirector:getChildByPath(ui, 'img_input_bg')

	self.input_pos_mark = self.img_input_bg:getPosition()


	self.input_name:setVisible(true);
	self.lb_name:setVisible(false);
	self.btn_selectAcount:setTouchEnabled(false);
	self:initDefault()

	LoginNoticePage.input_name = self.input_name



	LoginNoticePage.txt_area   = self.txt_area

	self.panel_effect = {}
	for i=1,3 do
		self.panel_effect[i] = TFDirector:getChildByPath(ui, 'panel_ef' .. 1)
	end

	-- 公共相关
	self.list_help   = TFDirector:getChildByPath(ui, 'list_help');
    self.list_help:setBounceEnabled(true);
    Public:bindScrollFun(self.list_help);
    self.txt_content      = TFDirector:getChildByPath(ui, 'txt_content');
    self:drawNotice()

    self.btn_fanhui = TFDirector:getChildByPath(ui, 'btn_fanhui');
    -- end
    -- local rect = self.btn_fanhui:boundingBox()

    -- local size = self:getContentSize()
    -- local newWidth 	= 0 - size.width/2
    -- local newHeight = size.height/2
    -- local x = newWidth + rect.size.width/2
    -- local y = newHeight - rect.size.height/2

    -- self.btn_fanhui:setPosition(ccp(x, y))


    self:drawDefaultServerName()

    if TFPlugins.isPluginExist() then
		TFPlugins.hideToolBar()
	end




	if HeitaoSdk then
		self.btn_fanhui:setVisible(false)
	-- 	-- LogonHelper:requestServerList(TFPlugins.serverList_url)
	-- 	local function LogincallBack(result, msg)
	-- 		print("------- LogincallBack ----")
	-- 		if result == HeitaoSdk.LOGIN_IN_SUC then
	-- 			-- local userId = HeitaoSdk.getplatformUserId()
	-- 	  --   	self.userName = userId
	-- 		elseif result == HeitaoSdk.LOGIN_IN_FAIL then
	-- 			toastMessage(msg)
 --        	end

	-- 		-- HeitaoSdk.init()
	-- 	end
	-- 	HeitaoSdk.setLogincallback(LogincallBack)
	-- 	HeitaoSdk.login()
		-- HeitaoSdk.ShowFunctionMenu(false)

		self:playEffect()

		self.img_gonggaodi:setVisible(false)

		--   显示出名字log begin
		self.img_title = TFDirector:getChildByPath(ui, 'img_title')
	 
		self.img_title:setVisible(false)
		-- end
	end

	self:startAutoRefresh()

	self:playBgEffect()
end

function LoginNoticePage:initDefault()
	local userInfo  = SaveManager:getUserInfo()
	local username = userInfo.userName
	if username then
		self.input_name:setText(username)
	end
	local currentServer = SaveManager:getCurrentSelectedServer()
	if currentServer then
		self.txt_area:setText(SaveManager:getServerName(currentServer))
		if userInfo and not userInfo.currentServer then
			userInfo.currentServer = tostring(currentServer.serverId)
		end
	end
end

function LoginNoticePage:removeUI()
	self:stopAutoRefresh()
	TFDeviceInfo:setOpenAccelerometer(false)
	self.super.removeUI(self)
end

function LoginNoticePage:registerEvents()


	if self.registerEventCallFlag then
		return
	end
	self.super.registerEvents(self)

	self.btn_login.logic = self
	self.txt_area.logic = self
	self.btn_selectServer.logic = self
	self.lb_name.logic = self

	self.btn_login:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onLoginClickHandle),1)
	self.btn_login:setTouchEnabled(true)
	self.txt_area:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectServerClickHandle))
	self.btn_selectServer:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectServerClickHandle))
	self.btn_register:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRegisterClickHandle),1)
	self.btn_selectAcount:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectAccountClickHandle))
	self.lb_name:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectAccountClickHandle))

	TFDirector:addProto(s2c.LOGIN_RESULT, self, self.loginHandle)

	local function onTextFieldChangedHandle(input)
        self.img_input_bg:setPosition(ccp(self.input_pos_mark.x,self.input_pos_mark.y+240))
    end

	--add by david.dai
	--添加输入账号时输入框上移逻辑
	local function onTextFieldAttachHandle(input)
        self.img_input_bg:setPosition(ccp(self.input_pos_mark.x,self.input_pos_mark.y+240))
        self.input_name:addMEListener(TFTEXTFIELD_TEXTCHANGE, onTextFieldChangedHandle)
    end
    self.input_name:addMEListener(TFTEXTFIELD_ATTACH, onTextFieldAttachHandle)

    local function onTextFieldDetachHandle(input)
        self.img_input_bg:setPosition(ccp(self.input_pos_mark.x,self.input_pos_mark.y))
        self.input_name:removeMEListener(TFTEXTFIELD_TEXTCHANGE)
    end

    self.input_name:addMEListener(TFTEXTFIELD_DETACH, onTextFieldDetachHandle)

	self.btn_fanhui:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBackLastPage))

	self.severlist_requestCallback = function (events)
		local currentServer = SaveManager:getCurrentSelectedServer()
		if currentServer then
			LoginNoticePage.txt_area:setText(SaveManager:getServerName(currentServer))
			if userInfo and not userInfo.currentServer then
				userInfo.currentServer = tostring(currentServer.serverId)
			end
		end
	end
	TFDirector:addMEGlobalListener(LogonHelper.MSG_DOWNLOAD_SEVERLIST,self.severlist_requestCallback)


	ADD_KEYBOARD_CLOSE_LISTENER(self, self.ui)

	self.accelerometerUpdateCallBack = function(event)
		local data = event.data[1]
		if self.ui then
			self:didAccelerate(data)
		end
    end

	TFDirector:addMEGlobalListener("HeitaoSdk.ACCELEROMETER_UPDATE"  ,self.accelerometerUpdateCallBack)
	self.registerEventCallFlag = true
end

function LoginNoticePage:removeEvents()
	TFDirector:removeProto(s2c.LOGIN_RESULT, self, self.loginHandle)

	TFDirector:removeMEGlobalListener(LogonHelper.MSG_DOWNLOAD_SEVERLIST, self.severlist_requestCallback)
	self.severlist_requestCallback = nil

	TFDirector:removeMEGlobalListener("HeitaoSdk.ACCELEROMETER_UPDATE", self.accelerometerUpdateCallBack)
	self.accelerometerUpdateCallBack = nil

	if self.updateTimerID then
		TFDirector:removeTimer(self.updateTimerID)
		self.updateTimerID = nil
	end

	self.registerEventCallFlag = nil
	-- -- remove platform event
	-- TFDirector:removeMEGlobalListener("onSdkPlatformLogout", self.onSdkPlatformLogout)
 --    TFDirector:removeMEGlobalListener("onSdkPlatformLeave", self.onSdkPlatformLeave)

 --    --print("re LoginNoticePage:onSdkPlatformLogout = ", self.onSdkPlatformLogout)
	-- --print("re LoginNoticePage:onSdkPlatformLeave = ", self.onSdkPlatformLeave)
end

--[[
模拟器登录
]]
function LoginNoticePage:onLoginForPC()
	play_jinruyouxi()
	-- local userName = LoginNoticePage.input_name:getText()
	print("------- onclick enter game -------")
	if HeitaoSdk then
		if HeitaoSdk.startGame() == true then
			self.userName = HeitaoSdk.getplatformUserId()
		else
			-- HeitaoSdk.login()
			return
		end
	end

	local userName = self.userName
	if userName == nil or userName == "" then
		--toastMessage("请输入账号")
		toastMessage(localizable.loginLayer_input_account)
		return
	end

	if SaveManager:getServerList() == nil then
		--toastMessage("请选择区服")
		toastMessage(localizable.loginNoticePage_check_server)
		return
	end

	local userInfo = SaveManager:getUserInfo()

	if SaveManager:checkServerIsOpen() == false then
		-- 
		print("当前的服务器是关闭状态")
		return
	end

	userInfo.userName = userName
    SaveManager:saveUserInfo()
    CommonManager:loginServer();

    if HeitaoSdk then
    	local serverInfo = SaveManager:getCurrentSelectedServer()
    	if serverInfo then
			HeitaoSdk.setServerInfo(serverInfo.serverId, serverInfo.name)
		end
	end
end



local function changeAccount()

end

function LoginNoticePage.onRegisterClickHandle(btn)

end

function LoginNoticePage.onSelectAccountClickHandle(btn)
	local self = btn.logic;
	-- if TFSdk then
	-- 	changeAccount()
	-- end
end



function LoginNoticePage.onLoginClickHandle(btn)

	local self = btn.logic
	MainPlayer:restart()
	CommonManager:clearRedPoint()
	CommonManager:setLoginCompleteState( false )
	CommonManager:setAutoConnect(true)

	self.btn_login:setTouchEnabled(false)
	CommonManager:checkResourceVersion(function ()
		if self.btn_login == nil then
			return
		end
		self.btn_login:setTouchEnabled(true)
		if not self.mode then
			self:onLoginForPC()
		else
			self:onLoginFor3Parts()
		end
	end)
end

function LoginNoticePage:onLoginFor3Parts()
	play_jinruyouxi()
	--local userName = self.sessionId
	-- local userName = LoginNoticePage.input_name:getText()
	local userName = self.userName
	if userName == nil or userName == "" then
		--toastMessage("请登录账号")
		toastMessage(localizable.loginNoticePage_please_login)
		return
	end

	local userInfo = SaveManager:getUserInfo()
	print("userInfo = ", userInfo)
	userInfo.userName = userName
    SaveManager:saveUserInfo()
    CommonManager:loginServer();
end

function LoginNoticePage:loginHandle(event)
	--print("event = ", event)
	if event.data.statusCode == 0 then
		if event.data.empty then
			hideAllLoading()
			local currentScene = Public:currentScene()
			if currentScene == nil or currentScene.__cname == "CreatePlayerScene" then
				return
			end

			if PlayerGuideManager.isPlayGuideVideo or FightManager.isFighting then
				return
			end

			if not PlayerGuideManager:ShowGameBeginVideo(self.ui) then
				AlertManager:changeScene(SceneType.CREATEPLAYER)
			end
		end
	else
		hideAllLoading()
		--toastMessage("登陆失败")
		toastMessage(localizable.loginNoticePage_login_fail)
	end
end

function LoginNoticePage.onSelectServerClickHandle(btn)
	local self = btn.logic;


	-- if 0 then--TFPlugins.getChannelId() == "" then
	-- 	local layer = require('lua.logic.login.ServerChoice'):new()
	-- 	AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE)
	-- 	AlertManager:show()
	-- 	return
	-- end
	
	-- if not TFSdk:getSdkName() then
		-- local layer = require('lua.logic.login.ServerChoice'):new()
		-- AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE)
		-- AlertManager:show()
	-- else
	-- 	local serverList = SaveManager:getDynamicServerList()
	-- 	if serverList and #serverList > 0 then
	-- 		local layer = require('lua.logic.login.ServerChoice'):new()
	-- 		AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE)
	-- 		AlertManager:show()
	-- 	else
	-- 		toastMessage("没有可以选择的服务器，请等待服务器列表返回")
	-- 	end
	-- end

	-- if USE_LOCAL_SERVERLIST then
	-- 	SaveManager:setDynamicServerList(serverList)
	-- end

	local serverList = SaveManager:getDynamicServerList()

	

	-- print("LoginNoticePage request serverList again = ", serverList)

	if serverList and #serverList > 0 then
		-- if #serverList < 2 then
		-- 	toastMessage("没有更多的服务器可以选择")
		-- 	return
		-- end
		--注册选择通知监听事件
		local layer = require('lua.logic.login.ServerChoice'):new()
		layer.logic = self
		-- AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY_CLOSE)
		AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY)
		AlertManager:show()
	else
		-- toastMessage("没有可以选择的服务器，请等待服务器列表返回")
		CommonManager:showOperateSureLayer(
            function()
                -- LogonHelper:requestServerList(TFPlugins.serverList_url)
                LogonHelper:requestServerListAgain()
                AlertManager:close()
				showLoading()
            end,
            function()
                AlertManager:close()
            end,
            {
                --msg = "获取区服列表失败,是否重试?",
                msg = localizable.loginNoticePage_getserver_fail,
                showtype = AlertManager.BLOCK_AND_GRAY
            }
        )
	end
end


function LoginNoticePage:ServerChoice(serverInfo)
	local userInfo = SaveManager:getUserInfo()
	userInfo.currentServer = tostring(serverInfo.serverId)
	self.txt_area:setText(SaveManager:getServerName(serverInfo))

	if HeitaoSdk then
		HeitaoSdk.setServerInfo(serverInfo.serverId, serverInfo.name)
	end
end

function LoginNoticePage:playEffect()
	--[[
	if not self.img_bg then
		return
	end

	if self.ChooseEffect == nil then
		local resPath = "effect/logineffect.xml"
	    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
	    local effect = TFArmature:create("logineffect_anim")

	    effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(self.img_bg:getSize().width/2,self.img_bg:getSize().height/2 - 22))

        self.img_bg:addChild(effect, 1)


	    effect:addMEListener(TFARMATURE_COMPLETE,function()
	        -- effect:removeMEListener(TFARMATURE_COMPLETE)
	        -- effect:removeFromParent()
	        -- self.ChooseEffect:playByIndex(1, -1, -1, 1)
	    end)

	    self.ChooseEffect = effect
   	end

    self.ChooseEffect:playByIndex(0, -1, -1, 1)



	if self.titleEffect == nil then
		local resPath = "effect/titleeffect.xml"
	    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
	    local effect = TFArmature:create("titleeffect_anim")

	    effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(self.img_bg:getSize().width/2,self.img_bg:getSize().height/2 - 22))

        self.img_bg:addChild(effect, 2)


	    effect:addMEListener(TFARMATURE_COMPLETE,function()
	        -- effect:removeMEListener(TFARMATURE_COMPLETE)
	        -- effect:removeFromParent()
	        -- self.titleEffect:playByIndex(1, -1, -1, 1)
	    end)

	    self.titleEffect = effect
   	end

    self.titleEffect:playByIndex(0, -1, -1, 1)
    ]]
    self.img_title = TFDirector:getChildByPath(self.ui, 'img_title')
    self.img_title:setVisible(true)
end

function LoginNoticePage:playBgEffect()
	--419渠道做特殊处理
	if (HeitaoSdk and HeitaoSdk.getplatformId() == 419) then
		self.img_bg:setVisible(true)
		self.img_bg:setTexture("ui_new/login/img_bg_419.jpg")
		self.img_title = TFDirector:getChildByPath(self.ui, 'img_title')
		self.img_title:setTexture("ui_new/login/logo_419.png")
	else
		local panel_size = self.panel_effect[1]:getSize()

		self.img_bg:setVisible(true)
		self.img_bg:setTexture("ui_new/login/img_bg.jpg")
	    if self.effect_bg == nil then
			local resPath = "effect/login_effect_bg.xml"
		    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
		    self.effect_bg = TFArmature:create("login_effect_bg_anim")	    
		    self.effect_bg:setAnimationFps(GameConfig.ANIM_FPS)
		    self.effect_bg:setPosition(ccp(panel_size.width/2,panel_size.height/2))
	        self.effect_bg:setName("effect3")
		    self.panel_effect[1]:addChild(self.effect_bg, 1)
		end
	    self.effect_bg:playByIndex(0, -1, -1, 1)

	 --    if self.effect_bg2 == nil then
	 --        local resPath = "effect/login_effect_bg2.xml"
	 --        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
	 --        self.effect_bg2 = TFArmature:create("login_effect_bg2_anim")      
	 --        self.effect_bg2:setAnimationFps(GameConfig.ANIM_FPS)
	 --        self.effect_bg2:setPosition(ccp(panel_size.width/2,panel_size.height/2))
	 --        self.effect_bg2:setName("effect4")
	 --        self.panel_effect[1]:addChild(self.effect_bg2, 1)
	 --    end
	 --    self.effect_bg2:playByIndex(0, -1, -1, 1)

	 --    if self.effect_house == nil then
		--     local resPath = "effect/login_effect_house.xml"
		--     TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
		--     self.effect_house = TFArmature:create("login_effect_house_anim")
		--     self.effect_house:setAnimationFps(GameConfig.ANIM_FPS)
		--     self.effect_house:setPosition(ccp(panel_size.width/2,panel_size.height/2 - 5))
	 --        self.effect_house:setName("effect2")
		--     self.panel_effect[1]:addChild(self.effect_house, 1)
	 --    end
	 --    self.effect_house:playByIndex(0, -1, -1, 1)

	 --    if self.effect1 == nil then
	 --        self.effect1 = SkeletonAnimation:create("spine/fm")
	 --        self.effect1:setScale(0.45)
	 --        self.effect1:setAnimationFps(GameConfig.ANIM_FPS)
	 --        self.effect1:setPosition(ccp(panel_size.width/2,-15))
	 --        self.panel_effect[1]:addChild(self.effect1, 1)
	 --    end

	 --    if self.effect2 == nil then
		--     self.effect2 = SkeletonAnimation:create("spine/fm")
		--     self.effect2:setScale(0.45)
	 --        self.effect2:setName("effect1")
		--     self.effect2:setAnimationFps(GameConfig.ANIM_FPS)
		--     self.effect2:setPosition(ccp(panel_size.width/2,-15))
		--     self.panel_effect[1]:addChild(self.effect2, 1)
		-- end
	 --    self.effect2:setVisible(false)

	 --    self.effect1:playByIndex(0, -1, -1, 0)
	 --    self.effect1:addMEListener(TFARMATURE_COMPLETE, function ()
	 --        self.effect1:removeMEListener(TFARMATURE_COMPLETE)
	 --        self.effect1:removeFromParent()
	 --        self.effect1 = nil
	 --        self.effect2:setVisible(true)
	 --        self.effect2:playByIndex(1, -1, -1, 1)
	 --    end)

    -- self.effect2:addMEListener(TFARMATURE_COMPLETE, function ()
    --     self.effect2:removeMEListener(TFARMATURE_COMPLETE)
    --     self.effect2:playByIndex(1, -1, -1, 1)
    -- end)
    
 --    self.effect2:setVisible(false)

 --    self.effect1:addMEListener(TFARMATURE_COMPLETE, function ()
 --    	self.effect1:removeMEListener(TFARMATURE_COMPLETE)
 --    	self.effect1:setVisible(false)
 --    	self.effect2:setVisible(true)
 --    	self.effect2:playByIndex(1, -1, -1, 1)
	-- end)
	-- local resPath = "effect/login_effect_bg.xml"
 --    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
 --    local effect = TFArmature:create("login_effect_bg_anim")
 --    local panel_size = self.panel_effect[1]:getSize()
 --    effect:setAnimationFps(GameConfig.ANIM_FPS)
 --    effect:setPosition(ccp(panel_size.width/2,panel_size.height/2))
 --    self.panel_effect[1]:addChild(effect, 1)
 --    effect:setName("effect3")
 --    effect:playByIndex(0, -1, -1, 1)


 --    resPath = "effect/login_effect_house.xml"
 --    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
 --    effect = TFArmature:create("login_effect_house_anim")
 --    effect:setAnimationFps(GameConfig.ANIM_FPS)
 --    effect:setPosition(ccp(panel_size.width/2,panel_size.height/2))
 --    self.panel_effect[1]:addChild(effect, 1)
 --    effect:setName("effect2")
 --    effect:playByIndex(0, -1, -1, 1)
    
 --    resPath = "effect/login_effect_role.xml"
 --    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
 --    effect = TFArmature:create("login_effect_role_anim")
 --    effect:setAnimationFps(GameConfig.ANIM_FPS)
 --    effect:setPosition(ccp(panel_size.width/2,panel_size.height/2))
 --    self.panel_effect[1]:addChild(effect, 1)
 --    effect:setName("effect1")
 --    effect:playByIndex(0, -1, -1, 1)

		-- self.bg_move = {}
		-- self.initBgPos = {}
		-- self.curPos = {}
		-- for i = 1, 4 do
		-- 	self.bg_move[i] = TFDirector:getChildByName(self.panel_effect[1], "effect" .. i)
		-- 	self.initBgPos[i] = self.bg_move[i]:getPosition()
		-- 	self.curPos[i] = self.bg_move[i]:getPosition()
		-- end
	end
end

function LoginNoticePage:drawNotice()
	local content = require("lua.table.t_s_notice")
	
    self.txt_content:setText(content)
    local contentSize = self.txt_content:getContentSize()
    local scorSize    = self.list_help:getInnerContainerSize()
    --如果显示内容超出了 则调整位置
    if contentSize.height > scorSize.height then
        self.txt_content:setPositionY(contentSize.height)
        self.list_help:setInnerContainerSize(contentSize)
    end
end


function LoginNoticePage.onBackLastPage(sender)
	AlertManager:changeScene(SceneType.LOGIN)
end

function LoginNoticePage:drawDefaultServerName()

	-- 没有获取到服务器列表 显示选择
	if SaveManager:getServerList() == nil then
		--LoginNoticePage.txt_area:setText("请选择区服")
		LoginNoticePage.txt_area:setText(localizable.loginNoticePage_check_server)
		LoginNoticePage.txt_area:setTouchEnabled(true)
		return
	end

	local currentServer = SaveManager:getCurrentSelectedServer()
	if currentServer then
		LoginNoticePage.txt_area:setText(SaveManager:getServerName(currentServer))
		if userInfo and not userInfo.currentServer then
			userInfo.currentServer = tostring(currentServer.serverId)
		end
	else
		--LoginNoticePage.txt_area:setText("请选择区服")
		LoginNoticePage.txt_area:setText(localizable.loginNoticePage_check_server)
	end

	LoginNoticePage.txt_area:setTouchEnabled(true)
end

function LoginNoticePage:startAutoRefresh()
	-- --公告框
	-- local function autoUpdate()
	-- 	self:requestServerList()
	-- end

	-- if self.autoRefreshTimer == nil then
	-- 	self.autoRefreshTimer = TFDirector:addTimer(auto_refresh_time, -1, nil, autoUpdate)
	-- end

end

function LoginNoticePage:stopAutoRefresh()
	-- print("--- LoginNoticePage:stopAutoRefresh")
	
	-- if self.autoRefreshTimer then
	-- 	TFDirector:removeTimer(self.autoRefreshTimer)
	-- 	self.autoRefreshTimer = nil
	-- end

end

function LoginNoticePage:requestServerList()
	local platformid = nil
	local userId 	 = nil

	if HeitaoSdk then
		platformid = HeitaoSdk.getplatformId()
		userId 	   = HeitaoSdk.getuserid()
	else
		platformid = "win2015"
		userId 	   = TFPlugins.getUserID()
	end

	local serverList_url = TFPlugins.serverList_url
	local system = 0 	-- pc
	if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
    	system = 1 		--ios
	elseif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
		system = 2 		--android
	end

	serverList_url = serverList_url .. "?system=" .. system
	if platformid ~= nil then
		serverList_url = serverList_url .. "&channel=" .. platformid
	end
	if userId ~= nil then
		serverList_url = serverList_url .. "&userid=" .. userId
	end
	
	-- add version
	serverList_url = serverList_url .. "&appverison=" .. TFDeviceInfo.getCurAppVersion()
	-- TFPlugins.serverList_url = serverList_url

	LogonHelper:requestServerList(serverList_url)
end

function LoginNoticePage:didAccelerate(data)
	if not data then
		return
	end
	-- data.y = data.y - 5
	-- local deltaMax = 5
	-- if data.x > deltaMax then
	-- 	data.x = deltaMax
	-- elseif data.y > deltaMax then
	-- 	data.y = deltaMax
	-- elseif data.x < -deltaMax then
	-- 	data.x = -deltaMax
	-- elseif data.y < -deltaMax then
	-- 	data.y = -deltaMax
	-- end

 --    if data and data.y then
 --        data.y = -data.y
 --    end

 --    if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
 --        data.x = -data.x
 --        data.y = -data.y
 --    elseif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
 --        data.y = -data.y
 --    end

 --    --加速计的敏感值    
 --    local sensitivityX = 1
 --    local sensitivityY = 1.4
 --    --最大移动距离    
 --    -- local maxDeltaX = 170 
 --    -- local maxDeltaY = 400

 --    local maxDeltaX = 60
 --    local maxDeltaY = 80

 --    --local scaleTab = {0, 0, 0.7}
 --    local scaleTab = {0, 0, 1, 0.4}

 --    --local curPos = self.bg_move[8]:getPosition()
 --    local deltaX = data.x / 5 * maxDeltaX * sensitivityX 
 --    local deltaY = data.y / 5 * maxDeltaY * sensitivityY 

 --    self.pTabX = {}
 --    self.pTabY = {}
 --    for i = 1, 4 do
 --    	self.curPos[i] = self.initBgPos[i]
 --    	if i >= 3 then
 --    		self.pTabX[i] = self.curPos[i].x - deltaX * scaleTab[i]
 --    		self.pTabY[i] = self.curPos[i].y - deltaY * scaleTab[i]
 --    	else
	--     	self.pTabX[i] = self.curPos[i].x + deltaX * scaleTab[i]
	--     	self.pTabY[i] = self.curPos[i].y + deltaY * scaleTab[i]
	--     end
 --    end

	-- --防抖动像素值
	-- local deltaX = 5
	-- local deltaY = 5

	-- self.newX = nil
	-- self.newY = nil
	-- if math.abs( self.pTabX[3] - self.bg_move[3]:getPositionX() ) > deltaX then
	-- 	self.newX = clone( self.pTabX ) 
	-- end
	-- if math.abs( self.pTabY[3] - self.bg_move[3]:getPositionY() ) > deltaY then
	-- 	self.newY = clone( self.pTabY ) 
	-- end

	-- if self.updateTimerID == nil then
	--     self.updateTimerID = TFDirector:addTimer(30, -1, nil, 
	--     function()
	--     	for i = 1, 4 do
	--     		local curppps = self.bg_move[i]:getPosition()
	    		
	--     		if self.newX then
	-- 	    		local disX = self.newX[i] - curppps.x
	-- 	    		if math.abs(disX * 0.3) >= 1 then
	-- 	    			self.bg_move[i]:setPositionX(curppps.x + disX * 0.05)
	-- 	    		else
	-- 	    			self.bg_move[i]:setPositionX(self.newX[i])
	-- 	    		end
	-- 	    	end

	-- 	    	if self.newY then
	-- 	    		local disY = self.newY[i] - curppps.y
	-- 	    		if math.abs(disY * 0.3) >= 1 then
	-- 	    			self.bg_move[i]:setPositionY(curppps.y + disY * 0.05)
	-- 	    		else
	-- 	    			self.bg_move[i]:setPositionY(self.newY[i])
	-- 	    		end
	-- 	    	end
	--     	end
	--     end)
	-- end
end
function LoginNoticePage:dispose()
    self.super.dispose(self)
    print("LoginNoticePageDispose")
end
return LoginNoticePage;

