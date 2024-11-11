
require('TFFramework.net.TFClientUpdate')
local UpdateLayer = class("UpdateLayer", BaseLayer)
CREATE_SCENE_FUN(UpdateLayer)
CREATE_PANEL_FUN(UpdateLayer)

-- 外网更新地址
 local versionPath   = "http://192.168.10.107:8080/mhqx/test/"
 local filePath      = "http://192.168.10.107:8080/mhqx/test/source/"


-- local versionPath   = "http://10.10.16.108:8080/qx/download/hunfu/ios/"
-- local filePath      = "http://7road-2031-w.7road.com:8080/qx/download/hunfu/ios/source/"

if VERSION_DEBUG == true then

    -- -- --本地
    versionPath = "http://192.168.10.115/mhqx/"
    filePath    = "http://192.168.10.115/mhqx/source/"

    ---------测试外网
    versionPath = "http://112.74.111.206/mhqx/beta/"
    filePath    = "http://112.74.111.206/mhqx/beta/source/"

else
    -- -- -- ---------黑桃外网
    -- versionPath = "http://120.131.3.218/mhqx/heitao/"
    -- filePath    = "http://120.131.3.218/mhqx/heitao/source/"
    local system = ""-- pc
    if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
        system = "ios"
    elseif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
        system = "android"
    end

    versionPath = "http://120.131.3.218/mhqx/" .. system .."/"
    filePath    = "http://120.131.3.218/mhqx/" .. system .."/source/"


    -- appstore 资源更新地址
    versionPath = "http://cdn.pic.jyqxz2015.com/mhqx/appstore/"
    filePath    = "http://cdn.pic.jyqxz2015.com/mhqx/appstore/source/"
end

versionPath = TFPlugins.versionPath
filePath    = TFPlugins.filePath

function UpdateLayer:ctor(data)
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.login.UpdateLayer")
end

function UpdateLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.ui = ui

    self.bar_update     = TFDirector:getChildByPath(ui, 'bar_update')
    self.bar_update_bg  = TFDirector:getChildByPath(ui, 'bg_bar')
    self.bar_update:setPercent(0);

    self.txt_update     = TFDirector:getChildByPath(ui, 'txt_update')
    self.txt_loading    = TFDirector:getChildByPath(ui, 'txt_loading')
    self.txt_chat       = TFDirector:getChildByPath(ui, 'txt_chat')
    self.img_bg         = TFDirector:getChildByPath(ui, 'bg')
    self.img_title      = TFDirector:getChildByPath(ui, 'img_title')
    self.txt_version    = TFDirector:getChildByPath(ui, 'txt_version')

    self.img_liang = TFDirector:getChildByPath(ui, "img_liang")
    self.initPosX = self.img_liang:getPositionX()

    self.img_liang:setPositionX(self.initPosX)
    if self.img_liang then
        self.img_liang:setVisible(false)
    end

    if self.img_title then
        self.img_title:setVisible(false)
    end

    self.bar_update_bg:setVisible(false)
    self.txt_update:setVisible(true)
    -- self.img_point:setVisible(false)
    self.bar_update:setVisible(false)


    self.bar_load  = TFDirector:getChildByPath(ui, 'bar_load')
    self.bar_load:setVisible(true)
    local index     = 1;
    local timeCount = 1;
    local loadingStr = "";

        self.bar_update_bg:setVisible(true)
        self.bar_load:setPercent(0)

    function change()
        --省略号动起来
        loadingStr = loadingStr .. ".";
        index = index + 1;
        if index > 5 then
            loadingStr = "";
            index = 1;
        end

        self.txt_loading:setText(loadingStr)

        --动态显示小贴士
        timeCount = timeCount + 1
        if timeCount > 10 then
            timeCount = 1
            self:showHelpText()
        end
    end

    self.loadingTimeId = TFDirector:addTimer(500, -1, nil, change)
    self.txt_loading:setText("")

    --self.txt_update:setText("正在检测最新资源")
    self.txt_update:setText(localizable.updateLaye_check_resource)

    --self:playEffect()
    
    --self:LoadingEffect()

    -- 显示小贴士
    self:showHelpText()
    -- 开始更新版本
    self:updateVision()

    local wifiType = TFDeviceInfo:getNetWorkType()
    print("--------------------网络类型     =", wifiType)
    print("--------------------versionPath  = ", versionPath)
    print("--------------------filePath     = ", filePath)
end

function UpdateLayer:removeUI()
    self.super.removeUI(self)
    TFDirector:removeTimer(self.loadingTimeId);
end

function UpdateLayer:registerEvents()
    self.super.registerEvents(self)

    -- ADD_KEYBOARD_CLOSE_LISTENER(self, self.ui)
end

function UpdateLayer:removeEvents()
    self.super.removeEvents(self)

    ADD_KEYBOARD_CLOSE_LISTENER(self, self.ui)
end


function UpdateLayer:showHelpText()
    if self.TipsList == nil then
        self.TipsList    = require("lua.table.t_s_help_tips")
    end
    local nLen = self.TipsList:length()
    local nIndex = math.random(1, nLen)
    local content = self.TipsList:getObjectAt(nIndex).tips
    
    self.txt_chat:setText(content)
end

function UpdateLayer:updateVision()
    print("TFUpdate updateVision!")
    local nMax = 0
    local sizeX = self.bar_load:getSize().width
    -- 回调当前更新的文件进度
    local function RecvCallBack(szversion, szName, nLen, nLeft, bResult)
        -- if nMax == 0 and nLeft == 0 then

        -- 下载更新失败
        if bResult == false then
            -- print("---------下载成功--------")
            if self.bShowFailDaig == nil or self.bShowFailDaig == false then
                self:showFailDiag(2)
                self.bShowFailDaig = true
            end
            return
        end

        if nLeft == 0 then
            print("更新文件完成 szversion = ", szversion)
            restartLuaEngine("CompleteUpdate")
            -- self:Complete()
            --self:CompleteUpdate()
            return
        end

        if nMax == 0 then
            nMax = nLeft
            print("需要更新的文件个数： ", nMax)
            -- self:showUpdateDialog()
        end

        print("当前更新文件：", szName)
        print("nLen：        ", nLen)
        print("nLeft         ", nLeft)
        print("szversion     ", szversion)

        print("shit = ", self.bar_load)

        --更新进度条
        -- nRate = ((nMax - nLeft + 1)/nMax)*100
        -- self.bar_load:setPercent(nRate)
        -- if nRate >= 100 then
        --     nMax = 0;
        -- end

        --更新显示文字
        local nUpdateSize   = self.insUpdate:GetHasUpdateSize()
        local nTotalSize    = self.insUpdate:GetTotSize()
        nRate = (nUpdateSize / nTotalSize)*100
        
        if nRate > 100 then
            nRate = 100
        end

        self.img_liang:setPositionX(self.initPosX + sizeX * nRate / 100)

        if nRate >= 96 then
            self.img_liang:setVisible(false)
        else
            self.img_liang:setVisible(true)
        end

        self.bar_load:setPercent(nRate)


        nRate       = math.floor(nRate)
        nUpdateSize = math.floor(nUpdateSize/1024)
        nTotalSize  = math.floor(nTotalSize/1024)
        --local desc  = string.format("正在更新，已下载%d%%  (%dKB/%dKB)", nRate, nUpdateSize, nTotalSize)
        local desc  = stringUtils.format(localizable.updateLaye_update_tips, nRate, nUpdateSize, nTotalSize)
        self.txt_update:setText(desc)

    end

    --回调当前的更新大小进度
    local function hasUpdateSizeCallBack(nHasUpdateSize)
        print("---------hasUpdateSizeCallBack", nHasUpdateSize)
    end

    local function VersionCallBack(szversion,szName , nLen ,nLeft,bResult)

        if bResult == false then
            -- toastMessage("检查资源更新失败")
            self:showFailDiag(1)
            return
        end

        local curVersion = TFClientUpdate:getCurVersion()
            print("================curVersion--"..curVersion.."--szversion--"..szversion,nLen,bResult)
        if szversion ~= nil and curVersion ~= szversion then
             --更新显示文字
            local nTotalSize    = self.insUpdate:GetTotSize()
            nTotalSize = nTotalSize/1000000
            -- nTotalSize = math.floor(nTotalSize/1000000)
            -- print("nTotalSize = ", nTotalSize)

            local desc = "";
            if nTotalSize >= 0.1 then
                desc = string.format(" %0.1fMB", nTotalSize);
            else
                desc = string.format(" %0.1fKB", nTotalSize * 1000);
            end
            --will return "2G,3G,4G,5G,WIFI,NO"
            local wifiType = TFDeviceInfo:getNetWorkType()
            print("====网络类型 ====", wifiType)
            if wifiType then
                if wifiType == "WIFI" then
                    print("Wifi环境下直接更新")
                    local path = "../Library/"
                    -- "../../Resource/debug/"
                    TFClientUpdate:UpdateToLastVersion(true,path,RecvCallBack, hasUpdateSizeCallBack)
                    return
                end
            end


            local layer = self:showOperateSureLayer(
                function()
                    print("开始更新")
                    local path = "../Library/"
                    -- "../../Resource/debug/"
                    TFClientUpdate:UpdateToLastVersion(true,path,RecvCallBack, hasUpdateSizeCallBack)
                end,
                function()
                    print("取消更新")
                    AlertManager:closeAll();
                    --暂时测试
                    -- self:CompleteUpdate()
                    --toastMessage("资源更新失败")
                    toastMessage(localizable.updateLaye_update_fail)
                end,
                {
                    --msg = "检测到新资源，共计".. desc .. "\n\n是否马上更新？" ,
                    msg = stringUtils.format(localizable.updateLaye_update_desc,desc) ,
                    --title = "更新资源啦",
                    title = localizable.updateLaye_update_lala,
                    showtype = AlertManager.BLOCK_AND_GRAY,
                    --okText = "更新",
                    okText = localizable.updateLaye_update_ok,
                    uiconfig = "lua.uiconfig_mango_new.common.OperateSure2"
                }
            )
            layer.isCanNotClose = true;
            return
        end

        if szversion ~= nil and curVersion == szversion then
            -- self:Complete()
            print("没有检测到最新的版本")
            self:CompleteUpdate()
        end
    end


    print("----------version----",TFClientUpdate:getCurVersion()) 
    local projectName =  TFConfigInfo:GetProjectName() 
    self.insUpdate = TFClientUpdate
    TFClientUpdate:StartUpdate(versionPath,
                       filePath,
                       nil, 
                       VersionCallBack) 

    local projectName   = TFConfigInfo:GetProjectName()
    local version       = self.insUpdate:getCurVersion();
    -- print("version", version)
    -- print("projectName", projectName)

    if  self.txt_version ~= nil then
        --self.txt_version:setText("资源版本:"..version)
        self.txt_version:setText(stringUtils.format(localizable.updateLaye_resource_version,version))
    end
end

function UpdateLayer:showOperateSureLayer(okhandle,cancelhandle,param)
    param = param or {}

    param.showtype = param.showtype or AlertManager.BLOCK_AND_GRAY_CLOSE;
    param.tweentype = param.tweentype or AlertManager.TWEEN_1;

    param.uiconfig = param.uiconfig or "lua.uiconfig_mango_new.common.OperateSure";


    -- local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.common.OperateSure",param.showtype,param.tweentype);
    local layer = AlertManager:addLayerByFile("lua.logic.common.OperateSure",param.showtype,param.tweentype);
    layer.toScene = Public:currentScene();

    layer:setUIConfig(param.uiconfig);

    layer:setBtnHandle(okhandle, cancelhandle);
    layer:setData(param.data);
    layer:setTitle(param.title);
    layer:setMsg(param.msg);
    layer:setTitleImg(param.titleImg);

    layer:setBtnOkText(param.okText);
    layer:setBtnCancelText(param.cancelText);

    AlertManager:show()

    return layer;
end

-- type == 1检查失败 type == 2 更新失败
function UpdateLayer:showFailDiag(errorType)
    --local displayTitle   = "检查资源更新"
    local displayTitle   = localizable.updateLaye_check_resource_update
    --local displayContent = "检查资源更新失败，是否重试"
    local displayContent = localizable.updateLaye_check_resource_update_fail
    
    if errorType and errorType == 2 then
        --displayTitle   = "更新失败"
        displayTitle   = localizable.updateLaye_update_fail
        --displayContent = "资源更新失败，请检查你的网络后重试"
        displayContent = localizable.updateLaye_update_fail_check_net
    end

    local function restart()
        local UpdateLayer   = require("lua.logic.login.UpdateLayer")
        AlertManager:changeScene(UpdateLayer:scene())
    end

    local layer = self:showOperateSureLayer(
                function()
                    AlertManager:closeAll()
                    self.bShowFailDaig = false

                    restart()
                end,
                function()
                    AlertManager:closeAll()
                    self.bShowFailDaig = false
                end,
                {
                    msg = displayContent,
                    showtype = AlertManager.BLOCK_AND_GRAY,
                    title = displayTitle,
                    --okText = "重试",
                    okText = localizable.updateLaye_reset,
                    uiconfig = "lua.uiconfig_mango_new.common.OperateSure2"
                }
    )
    layer.isCanNotClose = true
end

function UpdateLayer:EnterGame()
    --卸掉之前的已载入的lua代码
    -- TFDirector:unRequire('lua.table.TFMapArray')
    -- TFDirector:unRequire('lua.public.AlertManager')
    -- TFDirector:unRequire("lua.public.Public")
    -- TFDirector:unRequire('lua.logic.BaseLayer')
    -- TFDirector:unRequire('lua.logic.BaseScene')
    -- TFDirector:unRequire('lua.logic.SceneType')
    -- TFDirector:unRequire('lua.logic.common.GameConfig')
    -- TFDirector:unRequire("lua.logic.common.AudioFun")
    -- TFDirector:unRequire("lua.logic.common.LoadingLayer")

    -- --重新载入lua 并进入登录界面
    -- require('lua.gameinit')
    -- AlertManager:changeScene(SceneType.LOGIN)

    restartLuaEngine("CompleteUpdate")

end

function UpdateLayer:CompleteUpdate()
    if self.timeId == nil then
        local function update(delta)
            me.Director:getScheduler():unscheduleScriptEntry(self.timeId)
            self.timeId = nil
            self:EnterGame()
        end
        self.timeId = me.Scheduler:scheduleScriptFunc(update, 0.5, false)
    end
end

function UpdateLayer:playEffect()

    if not self.img_bg then
        return
    end
    if 1 then
        return
    end
    --419渠道做特殊处理
    if (HeitaoSdk.getplatformId() == 419) then
        self.img_bg:setTexture("ui_new/login/img_bg_419.jpg")
    end
    if self.ChooseEffect == nil then
        local resPath = "effect/logineffect.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("logineffect_anim")

        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(self.img_bg:getPositionX(),self.img_bg:getSize().height/2))

        self.img_bg:addChild(effect, 1)

       
        effect:addMEListener(TFARMATURE_COMPLETE,function()
            -- effect:removeMEListener(TFARMATURE_COMPLETE) 
            -- effect:removeFromParent()
            -- self.ChooseEffect:playByIndex(1, -1, -1, 1)
        end)

        self.ChooseEffect = effect
    end

    self.ChooseEffect:playByIndex(0, -1, -1, 1)
end

function UpdateLayer:LoadingEffect()

    if not self.img_bg then
        return
    end
    --419渠道做特殊处理
    if (HeitaoSdk and HeitaoSdk.getplatformId() == 419) then
        self.img_bg:setTexture("ui_new/login/img_bg_419.jpg")
    end
    if self.loading == nil then
        local resPath = "effect/loading.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("loading_anim")

        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(self.img_bg:getPositionX(), 250))

        -- self.img_bg:addChild(effect, 1)

        self.img_bg:getParent():addChild(effect, 1)

        effect:addMEListener(TFARMATURE_COMPLETE,function()
            -- effect:removeMEListener(TFARMATURE_COMPLETE)
            -- effect:removeFromParent()
            -- self.loading:playByIndex(1, -1, -1, 1)
        end)

        self.loading = effect
    end

    self.loading:playByIndex(1, -1, -1, 1)
    self.loading:setVisible(true)
end


return UpdateLayer

    -- require('lua.table.TFMapArray')
    -- AlertManager        = require('lua.public.AlertManager')
    -- Public              = require("lua.public.Public")
    -- BaseLayer           = require('lua.logic.BaseLayer')
    -- BaseScene           = require('lua.logic.BaseScene')
    -- SceneType           = require('lua.logic.SceneType');
    -- GameConfig          = require('lua.logic.common.GameConfig');
    -- LoadingLayer        = require("lua.logic.common.AudioFun")
    -- LoadingLayer        = require("lua.logic.common.LoadingLayer")
