local LoginXiuFu = class("LoginXiuFu", BaseLayer)
function LoginXiuFu:ctor(data)
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.login.LoginXiuFu")
end

function LoginXiuFu:initUI(ui)
	self.super.initUI(self,ui)
	self.txt_wenben1 = TFDirector:getChildByPath(ui, 'txt_wenben1')
	self.btn_close = TFDirector:getChildByPath(ui, 'btn_close')
	self.btn_xiufu = TFDirector:getChildByPath(ui, 'btn_xiufu1')
	if (self.btn_xiufu == nil) then
		self.btn_xiufu = TFDirector:getChildByPath(ui, 'btn_xiufu')
	end
	self.btn_xiufuAll = TFDirector:getChildByPath(ui, 'btn_xiufu2')
	self.txt_wenben1:setText(localizable.Repair_Text)
end

function LoginXiuFu:removeUI()
	self.super.removeUI(self)

end

function LoginXiuFu:registerEvents()
	self.super.registerEvents(self)


	ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);

	self.btn_xiufu.logic = self
	self.btn_xiufu:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnXiuFuClick))
	if (self.btn_xiufuAll) then
		self.btn_xiufuAll.logic = self
		self.btn_xiufuAll:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnXiuFuAllClick))
	end
end

function LoginXiuFu:removeEvents()
end

function LoginXiuFu.onBtnXiuFuClick(btn)
	-- local TFClientUpdate =  TFClientResourceUpdate:GetClientResourceUpdate()
	btn.logic:removeUpdata()
	-- TFClientUpdate:ResetVersionAndDownloadNewResource()
	-- MainPlayer:reset()
    -- AlertManager:clearAllCache()
    -- CommonManager:closeConnection()

	-- local UpdateLayer   = require("lua.logic.login.UpdateLayer_new")
	-- AlertManager:changeScene(UpdateLayer:scene())
	-- TFDirector:changeScene(SceneType.DEFAULT)
end
function LoginXiuFu.onBtnXiuFuAllClick(btn)
	-- local TFClientUpdate =  TFClientResourceUpdate:GetClientResourceUpdate()
	-- TFClientUpdate:ResetVersionAndDownloadNewResource()
	btn.logic:removeUpdata(true)
	-- MainPlayer:reset()
    -- AlertManager:clearAllCache()
    -- CommonManager:closeConnection()

	-- local UpdateLayer   = require("lua.logic.login.UpdateLayer_new")
	-- AlertManager:changeScene(UpdateLayer:scene())
	-- TFDirector:changeScene(SceneType.DEFAULT)
end
function LoginXiuFu:removePackage()
	local sdPath        = ""
    local sPackName     = ""
    local updatePath    = ""

	if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
		sdPath      = TFDeviceInfo.getSDPath()  
		sPackName   = TFDeviceInfo.getPackageName()
		updatePath  = sdPath .."playmore/" .. sPackName .. "/"
		CCFileUtils:sharedFileUtils():removeDirectory(updatePath)
	else
		return
    end
    -- print("updatePath = ",updatePath)
    -- if bClear then
    
    -- else
    --     updatePath = updatePath .. "downloadCache/"
    --     CCFileUtils:sharedFileUtils():removeDirectory(updatePath)
    -- end
end

function LoginXiuFu:removeUpdata(bAll)
	local sdPath        = ""
	local sPackName     = ""
	local updatePath    = ""
	local bDel = true
	if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
		updatePath = CCFileUtils:sharedFileUtils():getWritablePath()
		updatePath = updatePath .. '../Library/'
	elseif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
		sdPath      = TFDeviceInfo.getSDPath()  
		sPackName   = TFDeviceInfo.getPackageName()
		updatePath  = sdPath .."playmore/" .. sPackName .. "/"
		bDel = bAll
	else
		updatePath = updatePath .. "../Library/"
	end
	if (bDel) then
		CCFileUtils:sharedFileUtils():removeDirectory(updatePath)
	end
	CCFileUtils:sharedFileUtils():purgeCachedEntries()

	local oldVersion = "1.0.00"
	local content = io.readfile("TFFramework/net/TFClientUpdate.lua") or 'newUpdateFun:SetUpdateDefaultVersion("1.0.00")'
	string.gsub(content, 'SetUpdateDefaultVersion%("(.-)"%)', function(version)
		oldVersion = version
	end)
	local TFClientUpdateNew =  TFClientResourceUpdate:GetClientResourceUpdate()
	TFClientUpdateNew:SetUpdateDefaultVersion(oldVersion)
	TFClientUpdateNew:ResetVersionAndDownloadNewResource()
	--
	AlertManager:clearAllCache()
    CommonManager:closeConnection()
	restartLuaEngine("")
end
return LoginXiuFu;
