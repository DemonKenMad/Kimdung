
local LoginLayer = class("LoginLayer", BaseLayer)
-- local serverList = require('lua.config.server')
LogonHelper = require('lua.manager.LogonHelper')

LoginLayer.loginStatus = 123
LoginLayer.NO_LOGIN   = 0
LoginLayer.LOGIN_SUC  = 1
LoginLayer.LOGIN_FAIL = 2

function LoginLayer:ctor(data)
    self.super.ctor(self,data)
	LoginLayer.loginStatus = LoginLayer.NO_LOGIN
    self:init("lua.uiconfig_mango_new.login.LoginLayer")
end

function LoginLayer:initUI(ui)
	self.super.initUI(self,ui)
	self.ui = ui
	LoginLayer.ui = ui

	LoginLayer.panel_close 			= TFDirector:getChildByPath(ui, 'panel_close')

    local resPath = "effect/loading_simple.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local skillEff = TFArmature:create("loading_simple_anim")
    skillEff:setPosition(ccp(GameConfig.WS.width/2,300))

    skillEff:setAnimationFps(GameConfig.ANIM_FPS)
    skillEff:playByIndex(0, -1, -1, 1)
    LoginLayer.panel_close:addChild(skillEff,2)

	self.input_name  = TFDirector:getChildByPath(ui, 'input_name')
	self.lb_name     = TFDirector:getChildByPath(ui, 'lb_name')
	self.btn_selectAcount = TFDirector:getChildByPath(ui, 'btn_selectAcount')

	self.input_name:setCursorEnabled(true)

	self.img_bg 	= TFDirector:getChildByPath(ui, 'bg')
	
	self.input_pwd			= TFDirector:getChildByPath(ui, 'input_pwd')
	
	self.panel_effect = {}
	for i=1,3 do
		self.panel_effect[i] = TFDirector:getChildByPath(ui, 'panel_ef' .. 1)
	end
	--add by david.dai
	self.img_input_bg = TFDirector:getChildByPath(ui, 'img_input_bg')

	self.input_pos_mark = self.img_input_bg:getPosition()

--   显示出名字log begin
	self.img_title = TFDirector:getChildByPath(ui, 'img_title')
 
	-- self.img_title:setVisible(true)
	self.img_title:setVisible(false)
-- end

	self.input_name:setVisible(true);
	self.input_pwd:setVisible(true);
	self.lb_name:setVisible(false);
	-- self.btn_selectAcount:setTouchEnabled(false);
	self:initDefault()

	LoginLayer.input_name = self.input_name
	LoginLayer.input_pwd = self.input_pwd
	
	LoginLayer.btn_ok 		  	= TFDirector:getChildByPath(self, 'btn_ok')

	self.panel_touch 	= TFDirector:getChildByPath(ui, 'panel_touch')
	self.panel_touch:setTouchEnabled(true)
	-- self:playEffect()


	-- LogincallBack
	self.LogincallBack =  function (code, msg)
		    --处理回调函数	
		if code == UserActionResultCode.kLoginSuccess  then   --登陆成功回调
		    --登陆成功后，游戏相关处理
		    local userId = TFPlugins.getUserID()
		    --print("UserActionResultCode.kLoginSuccess userId = ", userId)
		    self.input_name:setText(userId)

		    if TFIMManager then
		        TFIMManager:initSDk(userId)
		    end
		end
		if code == UserActionResultCode.kLoginTimeOut  then   --登陆失败回调
		    --登陆失败后，游戏相关处理

		end
		if code == UserActionResultCode.kLoginCancel   then   --登陆取消回调
		    --登陆失败后，游戏相关处理

		end
		if code == UserActionResultCode.kLoginFail     then   --登陆失败回调
		    --登陆失败后，游戏相关处理

		end

	end

		
	-- if TFPlugins.ge tChannelId() ~= "" and TFPlugins.isLogined() ~= true then
	if TFPlugins.isPluginExist() then
		TFPlugins.hideToolBar()
	 	if TFPlugins.isLogined() ~= true then
			TFPlugins.Login(self.LogincallBack)
		end
	end


	self:showWebViewNotice()
end

function LoginLayer:initDefault()
	local userInfo  = SaveManager:getUserInfo()
	local username = userInfo.userName
	if username then
		self.input_name:setText(username)
	end
end

function LoginLayer:removeUI()
	self.super.removeUI(self)
end

function LoginLayer:registerEvents()
	self.super.registerEvents(self)

	self.lb_name.logic = self

	self.btn_selectAcount:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectAccountClickHandle))
	self.lb_name:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectAccountClickHandle))
	self:registerNotification()
	--self.btn_ok:addMEListener(TFWIDGET_CLICK,audioClickfun(self.onClickOKHandle,nil,self))
    self.panel_touch:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onClickTouchPanelHandle,nil,self))

	local function onTextFieldChangedHandle(input)
        self.img_input_bg:setPosition(ccp(self.input_pos_mark.x,self.input_pos_mark.y+300))
    end

	--add by david.dai
	--添加输入账号时输入框上移逻辑
	local function onTextFieldAttachHandle(input)
        self.img_input_bg:setPosition(ccp(self.input_pos_mark.x,self.input_pos_mark.y+300))
        self.input_name:addMEListener(TFTEXTFIELD_TEXTCHANGE, onTextFieldChangedHandle)
    end
    self.input_name:addMEListener(TFTEXTFIELD_ATTACH, onTextFieldAttachHandle)

    local function onTextFieldDetachHandle(input)
		local text = input:getText()
        local new_text = string.gsub(text, "[^a-zA-Z0-9]", "")
        input:setText(new_text)
        self.img_input_bg:setPosition(ccp(self.input_pos_mark.x,self.input_pos_mark.y))
        self.input_name:removeMEListener(TFTEXTFIELD_TEXTCHANGE)
    end

    self.input_name:addMEListener(TFTEXTFIELD_DETACH, onTextFieldDetachHandle)

	self:registerNotification()
	--[[if HeitaoSdk == nil then
		self.panel_touch:addMEListener(TFWIDGET_CLICK, audioClickfun(self.enterNextPage))
	else
		self.panel_touch:addMEListener(TFWIDGET_CLICK, audioClickfun(self.enterNextPage))
	end]]--
	self.panel_touch.logic = self 
	ADD_KEYBOARD_CLOSE_LISTENER(self, self.ui)
end

function LoginLayer:removeEvents()
end

function LoginLayer:onSelectAccountClickHandle(sender)
end
function LoginLayer:onClickOKHandle(sender)
	if LoginLayer.loginStatus~=LoginLayer.LOGIN_SUC then return end
	LoginLayer:enterNextPage()
end
function LoginLayer:onClickTouchPanelHandle(sender)
	
	if LoginLayer.loginStatus==LoginLayer.NO_LOGIN then
		LoginLayer:login()
		return
	end
	if LoginLayer.loginStatus==LoginLayer.LOGIN_FAIL then
		LoginLayer:login()
		return
	end

	if LoginLayer.loginStatus==LoginLayer.LOGIN_SUC then
		if LoginLayer.img_gonggaodi:isVisible() then
			return 
		end
		LoginLayer:enterNextPage()
	end
end

function LoginLayer:login()
	if HeitaoSdk then
		LoginLayer:loginSDK()
	else
		LoginLayer:loginWin()
	end
end

function LoginLayer:loginSDK()
	-- 已经登陆成功
	if HeitaoSdk.startGame() == true then
		HeitaoSdk.logincallback = nil
		self.loginStatus = self.LOGIN_SUC
		self:setLoginInfo()
		self:showWebViewNotice()
		self:requestServerList()
	else
		self:setLoginCallback()
		HeitaoSdk.login()
	end
end
function LoginLayer:loginWin()

	local self = LoginLayer 
	local userName = LoginLayer.input_name:getText()
	local password = LoginLayer.input_pwd:getText()
	--local platformid = "NAN"
	
	if string.len(userName) < 6 then
		toastMessage("Tài khoản ngắn quá")
		return
	end
	if string.len(password) < 6 then
		toastMessage("Mật khẩu ngắn quá")
		return
	end
	local version  =  TFClientUpdate:getCurVersion()
	local UserCenterHttpClient = TFClientNetHttp:GetInstance()
    local url = "http://103.90.225.183:81/login/login.php?userName="..userName.."&password="..password.."&version="..version
	self.serverListCallback = function (type, ret, data)
		local server_data = json.decode(data)
		if server_data then
			if server_data.status == 2 then
				--TFPlugins.setPlatformID(platformid)
				self.loginStatus = LoginLayer.LOGIN_SUC
				LoginLayer:enterNextPage()
				toastMessage(server_data.msg)
			else
				toastMessage(server_data.msg)
				return
			end
		else
			toastMessage("Không thể kiểm tra đăng nhập")
			return
		end
	end
	UserCenterHttpClient:addMERecvListener(self.serverListCallback)
	UserCenterHttpClient:httpRequest(TFHTTP_TYPE_GET,url)
end

function LoginLayer:playEffect()
	-- toastMessage("playEffect")
    local panel_size = self.panel_effect[1]:getSize()
    --419渠道做特殊处理
    if (HeitaoSdk and HeitaoSdk.getplatformId() == 419) then
    	self.img_bg:setVisible(true)
    	self.img_bg:setTexture("ui_new/login/img_bg_419.jpg")
    	self.img_title = TFDirector:getChildByPath(ui, 'img_title')
    	self.img_title:setTexture("ui_new/login/logo_419.png")
    else
    	self.img_bg:setVisible(true)
	    if self.effect_bg == nil then
			local resPath = "effect/login_effect_bg.xml"
		    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
		    self.effect_bg = TFArmature:create("login_effect_bg_anim")	    
		    self.effect_bg:setAnimationFps(GameConfig.ANIM_FPS)
		    self.effect_bg:setPosition(ccp(panel_size.width/2,panel_size.height/2))
		    self.panel_effect[1]:addChild(self.effect_bg, 1)
		end
	    self.effect_bg:playByIndex(0, -1, -1, 1)

	 --    if self.effect_house == nil then
		--     local resPath = "effect/login_effect_house.xml"
		--     TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
		--     self.effect_house = TFArmature:create("login_effect_house_anim")
		--     self.effect_house:setAnimationFps(GameConfig.ANIM_FPS)
		--     self.effect_house:setPosition(ccp(panel_size.width/2,panel_size.height/2))
		--     self.panel_effect[1]:addChild(self.effect_house, 1)
	 --    end
	 --    self.effect_house:playByIndex(0, -1, -1, 1)
		-- self.img_title:setVisible(true)

		-- if self.effect1 == nil then
		-- 	self.effect1 = SkeletonAnimation:create("spine/fm")
		--     self.effect1:setScale(0.45)
		--     self.effect1:setAnimationFps(GameConfig.ANIM_FPS)
		--     self.effect1:setPosition(ccp(panel_size.width/2,-10))
		--     self.panel_effect[1]:addChild(self.effect1, 1)
		-- end
		-- if self.effect2 == nil then
		--     self.effect2 = SkeletonAnimation:create("spine/fm")
		--     self.effect2:setScale(0.45)
		--     self.effect2:setAnimationFps(GameConfig.ANIM_FPS)
		--     self.effect2:setPosition(ccp(panel_size.width/2,-10))
		--     self.panel_effect[1]:addChild(self.effect2, 1)
		-- end
		-- self.effect1:setVisible(false)
		-- self.effect2:setVisible(false)
		-- self.effect2:playByIndex(1, -1, -1, 1)
	end

end

function LoginLayer:playBgEffect( cbFunc )
	-- self.img_gonggaodi:setVisible(false)
	-- self.effect1:removeMEListener(TFARMATURE_COMPLETE)
 --    self.effect1:playByIndex(0, -1, -1, 0)
 --    self.effect1:setVisible(true)
 --    self.effect2:setVisible(false)

 --    self.effect1:addMEListener(TFARMATURE_COMPLETE, function ()
 --    	self.effect1:removeMEListener(TFARMATURE_COMPLETE)
 --    	self.effect1:setVisible(false)
 --    	self.effect2:setVisible(true)
 --    	self.effect2:playByIndex(1, -1, -1, 1)
 --    	if cbFunc then
 --    		cbFunc()
 --    	end
	-- end)

	if cbFunc then
		cbFunc()
	end
end

function LoginLayer:hideEffect()

	if self.ChooseEffect then
		self.ChooseEffect:setVisible(false)
	end
end


function LoginLayer.enterNextPage(sender)
	local self = sender.logic 
	
	TFWebView.removeWebView()
	


	local LoginNoticePage   = require("lua.logic.login.LoginNoticePage")

	local function cbFunc()
		AlertManager:changeScene(LoginNoticePage:scene())
	end

	if HeitaoSdk then
		if HeitaoSdk.startGame() == true then
			-- self.userName = HeitaoSdk.getplatformUserId()
		    --AlertManager:changeScene(LoginNoticePage:scene())
		    self.panel_touch:setTouchEnabled(false)
			if self.img_input_bg then
				self.img_input_bg:setVisible(false)
			end

			if self.img_dengru then
				self.img_dengru:setVisible(false)
			end
			if self.Button_Gonggao_1 then
				self.Button_Gonggao_1:setTouchEnabled(false)
			end

		    self:playBgEffect(cbFunc)
		else
			-- HeitaoSdk.login()
		end

		return
	end

	local userName = LoginLayer.input_name:getText()
	
	
	-- if TFSdk:getSdkName() then
	-- 	if not TFSdk:getUserIsLogin() then
	-- 		changeAccount()
	-- 		return
	-- 	end
	-- end
	if TFPlugins.isPluginExist() then
	 	if TFPlugins.isLogined() ~= true then
			TFPlugins.Login(LoginLayer.LogincallBack)
			return
		end
	end
	if HeitaoSdk == nil then
		TFPlugins.setUserID(userName)
		LoginLayer:requestServerList(nil)
	end
	LoginNoticePage.userName = userName
    --AlertManager:changeScene(LoginNoticePage:scene())
    LoginLayer:playBgEffect(cbFunc)
end

function LoginLayer:registerNotification()

	local function getNowtime()
	-- MainPlayer:getNowtime()
		return os.time()
	end

	local  function startDateNotification(key, desc, date, repeatType)
		if date == nil then
			return
		end
		
		local nowTime 	= getNowtime()
		local nextTime 	= getTimeByDate(date)
		local delay 	= nextTime - nowTime
		if nowTime < nextTime then
			--print("还未到达时间")
			--print("delay = ", delay/3600)

			-- TFNotificationManager:getInstance():notification(desc, delay, repeatType, key)
			if TFPushServer then
				TFPushServer.setLocalTimer(nextTime, desc, key)
			end
			return
		end

		--print("该事件的已过期 ---- ", date)
	end

	-- date 时间
	local  function startDailyNotification(key, desc, eventdate, repeatType)
		local nowTime 	= getNowtime()
		local date 		= os.date("*t", os.time())
		
		local nextDate  = getDateByString(eventdate)

		-- 把当前的事件置为每天的目标时间
		date.hour = nextDate.hour
		date.min  = nextDate.min
		date.sec  = nextDate.sec

		-- date.
		local nextTime 	= os.time(date)
		local delay = 0
		-- 还未到达今日目的时间
		if nowTime < nextTime then
			--print("时间还未到达1")
			delay = nextTime - nowTime

		-- 今日目的时间已过, 明天再执行
		else
			--print("时间已过，等待下次到达")
			nextTime = 24 * 3600 + nextTime
			delay = nextTime - nowTime
		end

		--print("delay = ", delay/3600)
		date = os.date("*t", nextTime)
		--print("下次到达时间", date)
		-- TFNotificationManager:getInstance():notification(desc, delay, repeatType, key)

		if TFPushServer then
			TFPushServer.setLocalTimer(nextTime, desc, key)
		end

	end

	-- -- 先移除所有事件
	-- TFNotificationManager:getInstance():removeNotification()
	if TFPushServer then
		TFPushServer.cancelAllLocalTimer()
	end

	-- 开启所有推送
	local eventList = require("lua.table.t_s_events")

    -- 
    for v in eventList:iterator() do
		--print("v = ", v)
		local nextDate = getDateByString(v.date)
		-- print("----------------------------")
		-- print("事件名称：", v.name)
		-- print("事件描述：", v.desc)
		-- print("事件执行的时间点  = ", v.date)
		if nextDate.year == "0" and nextDate.month == "0" and nextDate.day == "0" then
			--print("每天都要重复的事件")
			startDailyNotification(""..v.id, v.desc, v.date, 1)
		else
			--print("只执行一次的事件")
			startDateNotification(""..v.id, v.desc, v.date, 0)
		end
		--print("----------------------------")

    end

	-- if TFPushServer then
	-- 	TFPushServer.setLocalTimer(getNowtime() + 10, "本地推送测试", "test")
	-- 	TFPushServer.cancelLocalTimer(nil, nil, "1")
	-- end
	-- -- name date hour repeat 

	-- -- ("大侠请留步，用餐时间已到，小宝喊你回游戏吃花雕茯苓猪！", timeDelay, 1, "eatpig1")
	-- startDailyNotification("eatpig1", "大侠请留步，用餐时间已到，小宝喊你回游戏吃花雕茯苓猪！", 12, 1)
	-- startDailyNotification("eatpig2", "大侠请留步，用餐时间已到，小宝喊你回游戏吃花雕茯苓猪！", 18, 1)
end

function LoginLayer:showWebViewNotice()

    self.img_gonggaodi      = TFDirector:getChildByPath(self, 'img_gonggaodi')
	self.img_dengru 		= TFDirector:getChildByPath(self, 'img_dengru')
	self.Button_Gonggao_1 	= TFDirector:getChildByPath(self, 'Button_Gonggao_1')

	-- if HeitaoSdk == nil then
		
		--self.img_title:setVisible(false)
		self.img_gonggaodi:setVisible(false)
		self:playEffect()
		-- return
	-- end

	if HeitaoSdk then

		self.img_input_bg:setVisible(false)

		local function LogincallBack(result, msg)
			if result == HeitaoSdk.LOGIN_IN_SUC then
				local platformid = HeitaoSdk.getplatformId()

				local notice_url = "http://103.90.225.183/thongbao/index.html"
				local designsize = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
				local newx = (designsize.width - 960) / 2 + 145
				local newy = 100
				--self:playBgEffect(notice_url, newx)

				if notice_url and newx then
		    		self.img_gonggaodi:setVisible(true)
		    		TFWebView.showWebView(notice_url, newx, 135, 660, 350)
		    	end

				-- TFWebView.showWebView(notice_url, newx, 135, 660, 350)


				self:requestServerList(platformid)

				self:hideEffect()

				self.img_title:setVisible(false)
				self.img_input_bg:setVisible(false)
				--self.img_gonggaodi:setVisible(true)
				self.img_dengru:setVisible(false)

				local userId = HeitaoSdk.getuserid()
			    if TFIMManager then
			        TFIMManager:initSDk(userId)
			    end

				HeitaoSdk.logincallback = nil

			elseif result == HeitaoSdk.LOGIN_IN_FAIL then
				-- toastMessage(msg)
				--self:playBgEffect()
				self.panel_touch:addMEListener(TFWIDGET_CLICK, audioClickfun(self.enterNextPage))
        	end

			-- HeitaoSdk.init()
		end


		if HeitaoSdk.startGame() == true then
			-- self.userName = HeitaoSdk.getplatformUserId()
		    self.panel_touch:addMEListener(TFWIDGET_CLICK, audioClickfun(self.enterNextPage))
		    
			HeitaoSdk.logincallback = nil

			self:initLoginInfo()
			
			local platformid = HeitaoSdk.getplatformId()
			self:requestServerList(platformid)
		else		
			HeitaoSdk.setLogincallback(LogincallBack)
			-- HeitaoSdk.login()
			HeitaoSdk.ShowFunctionMenu(false)

			self.Button_Gonggao_1.logic = self
			self.Button_Gonggao_1:addMEListener(TFWIDGET_CLICK, audioClickfun(self.enterNextPage))

		end
	else
		--self:playBgEffect()
		-- local platformid = nil
		-- if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
		-- 	platformid = "win2015"
		-- end
		-- self:requestServerList(platformid)
	end

				-- local notice_url = "http://"..MainPlayer:getHeiTaoUrl().."/affiche?pfid="..HeitaoSdk.getplatformId()
				-- local designsize = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
				-- local newx = (designsize.width - 960) / 2 + 145
				-- local newy = 100
				-- TFWebView.showWebView(notice_url, newx, 135, 660, 350)
	if HeitaoSdk then

	end

end

-- function LoginLayer:requestServerList(platformid)
-- 	-- local serverList_url = "http://120.131.3.51:9000/server/list.do"


-- 	-- -- 内网测试
-- 	-- if VERSION_DEBUG == true then
-- 	-- 	serverList_url = "http://112.74.111.206:9000/server/list.do"
-- 	-- end
	
-- 	-- -- 内网测试
-- 	-- serverList_url = "http://192.168.10.115:9000/server/list.do"

-- 	local serverList_url = TFPlugins.serverList_url

-- 	local system = 0 	-- pc
-- 	if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
--     	system = 1 		--ios
-- 	elseif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
-- 		system = 2 		--android
-- 	end

-- 	serverList_url = serverList_url .. "?system=" .. system
-- 	if platformid ~= nil then
-- 		serverList_url = serverList_url .. "&channel=" .. platformid
-- 	end

-- 	local userId = nil
-- 	if HeitaoSdk then
-- 		userId            = HeitaoSdk.getuserid()
-- 	else
-- 		if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
-- 			userId = "pcTest001"
-- 		end
-- 	end

-- 	if userId ~= nil then
-- 		serverList_url = serverList_url .. "&userid=" .. userId
-- 	end
	
-- 	TFPlugins.serverList_url = serverList_url
	
-- 	print("LoginLayer:requestServerList = ",TFPlugins.serverList_url)

-- 	LogonHelper:requestServerList(TFPlugins.serverList_url)
-- end


function LoginLayer:requestServerList(none)
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
	-- userId          = "31834462"
	-- platformid      = "173"
	-- system          = 1
	-- serverList_url  = "http://120.92.15.251:9001/server/list.do?system="..system.."&channel=".. platformid .."&userid=".. userId .."&appverison=2.03"
	-- TFPlugins.setSdkName(platformid)
	-- TFPlugins.setUserID(userId)

	print("请求服务器列表 = ", serverList_url)
	AutoTestManager:sendAutoTestmsg("serverList", serverList_url)
	LogonHelper:requestServerList(serverList_url)
end

function LoginLayer:initLoginInfo()
	if HeitaoSdk == nil or TFPlugins == nil then
		return
	end

    local userId            = HeitaoSdk.getuserid()
    local platformUserId    = HeitaoSdk.getplatformUserId()
    local platformid        = HeitaoSdk.getplatformId()
    local token             = HeitaoSdk.gettoken()    
    local sdkVersion        = HeitaoSdk.getSDKVersion()

    print("______________ long in success ___________________")
    print("userId           = ", userId)
    print("platformUserId   = ", platformUserId)
    print("platformid       = ", platformid)
    print("token            = ", token)                
    print("sdkVersion       = ", sdkVersion)
    print("______________ long in end ___________________")

    TFPlugins.setSdkVersion(sdkVersion)
    TFPlugins.setSdkName(platformid)
    TFPlugins.setUserID(userId)
    TFPlugins.setToken(token)
end

return LoginLayer;
