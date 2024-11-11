local FengYunLuHomeLayer = class("FengYunLuHomeLayer", BaseLayer);

CREATE_SCENE_FUN(FengYunLuHomeLayer);
CREATE_PANEL_FUN(FengYunLuHomeLayer);

--[[
******风云录-欢迎界面*******

    -- by jiawei.miao
    -- 2018/1/5
]]

function FengYunLuHomeLayer:ctor(data)
    self.super.ctor(self,data);
    self:init("lua.uiconfig_mango_new.fengyunlu.FengYunLuEntrance");
    FengYunLuManager:sendHomeLayerInfo()

end

function FengYunLuHomeLayer:loadHomeData(data)
    self.homeInfo = data
    self:refreshUI()
end

function FengYunLuHomeLayer:onShow()
    self.super.onShow(self)
    -- self:refreshBaseUI()
    self:refreshUI()
end

function FengYunLuHomeLayer:refreshUI()
    -- self.icon_battletime1
    if self.lastBestInfo then
        self.panel_weikaiqi:setVisible(false)
        self.panel_kaiqi:setVisible(true)
        self.bg_name1.txt_name:setText(self.lastBestInfo.serverId .. self.lastBestInfo.serverName)
        self.txt_servername:setText(self.lastBestInfo.playerName)
        -- self.icon_head:setTexture("icon/head/".. self.lastBestInfo.playerName ..".png")
    else
        self.panel_weikaiqi:setVisible(true)
        self.panel_kaiqi:setVisible(false)
        return
    end
    if self.lastBestInfo.formation then
        local list = string.split(self.lastBestInfo.formation, ",")
        local num = 1
        for _,k in pairs(list) do
            if k and tonumber(k) ~= 0 then
                local role = FYRecordData:getRoleinfoByid(tonumber(k))
                if role then
                    local armature = self:getArmature(role.image);
                    self:AddRoleFootEffect(armature);
                    self.posRole[num]:setVisible(true)
                    if self.posRole[num].armature ~= nil then
                        self.posRole[num].armature:removeFromParent()
                        self.posRole[num].armature = nil
                    end
                    self.posRole[num].armature = armature
                    self.posRole[num]:addChild(armature,1)
                    num = num +1
                end
            end
        end
    end
end
function FengYunLuHomeLayer:getArmature(image)

	local resPathXML = "armature/"..image..".xml"
	local resPathAlats = "armature/".. image .. ".atlas" 
	local armature
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "armature/".. image
		armature = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		armature = TFArmature:create(image.."_anim")
	else
		image = 10006
		TFResourceHelper:instance():addArmatureFromJsonFile("armature/"..image..".xml")
		armature = TFArmature:create(image.."_anim")
	end
	
	if armature == nil then
		assert(false, "armature"..image.."create error")
		return
	end
    armature:setScaleX(-1)
    -- armature:setPositionX(150)
    armature:setAnimationFps(GameConfig.ANIM_FPS)
    armature:playByIndex(0, -1, -1, 1)
    return armature
end
function FengYunLuHomeLayer:AddRoleFootEffect(roleArmature)
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role.xml")
    local effect = TFArmature:create("main_role_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        roleArmature:addChild(effect)
    end

    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role2.xml")
    local effect2 = TFArmature:create("main_role2_anim")
    if effect2 ~= nil then
        effect2:setAnimationFps(GameConfig.ANIM_FPS)
        effect2:playByIndex(0, -1, -1, 1)
        effect2:setZOrder(-1)
        effect2:setPosition(ccp(0, -10))
        roleArmature:addChild(effect2)
    end
end
function FengYunLuHomeLayer:initUI(ui)
    self.super.initUI(self,ui);
    self.btn_help      = TFDirector:getChildByPath(ui, 'btn_help');

    self.btn_baoming         = TFDirector:getChildByPath(ui, 'btn_baoming');

    self.panel_weikaiqi         = TFDirector:getChildByPath(ui, 'panel_weikaiqi');
    self.panel_kaiqi = TFDirector:getChildByPath(ui, 'panel_kaiqi');  

    self.bg_name1               = TFDirector:getChildByPath(ui, 'bg_name1');
    self.bg_name1.txt_name      = TFDirector:getChildByPath(self.bg_name1, 'txt_name');
    self.txt_servername         = TFDirector:getChildByPath(ui, 'txt_servername');
    self.bg_zhanli              = TFDirector:getChildByPath(ui, 'bg_zhanli');
    self.bg_zhanli:setVisible(false)
    self.img_di                  = TFDirector:getChildByPath(ui, 'img_di');
    self.icon_head                  = TFDirector:getChildByPath(self.img_di, 'icon_head');

    self.icon_battletime1           = TFDirector:getChildByPath(ui, 'icon_battletime1');
    self.posRole = {}
    for i=1,5 do
        self.posRole[i] = TFDirector:getChildByPath(ui, 'role'..i)
        self.posRole[i]:setVisible(false)
    end
    
    self.lastBestInfo = nil
    self.startTime = 0
end

--填充主页信息
function FengYunLuHomeLayer:loadHomeInfo()

end


function FengYunLuHomeLayer.onGoClickHandle(sender)
   local self = sender.logic
   if MainPlayer:getServerSwitchStatue(ServerSwitchType.FengYunLu) == true and MainPlayer:getLevel() >= 50 then
        if self:startFengYunLu() == 1 then
            FengYunLuManager:senderFengYunLuInfo()
        else
            self:output()
        end
    else 
        toastMessage(localizable.commom_no_open2)
    end
   
end

function FengYunLuHomeLayer:removeUI()
    self.super.removeUI(self);

end

function FengYunLuHomeLayer:registerEvents()
    self.super.registerEvents(self);
    
    self.btn_baoming.logic    = self
    self.btn_baoming:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onGoClickHandle),1)
    self.btn_help.logic    = self
    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRuleClick),1)


    self.refresh = function (event)
        self.startTime = event.data[1][1].startTime
        if event.data[1][1].lastBestInfo then
            self.lastBestInfo = event.data[1][1].lastBestInfo
        end
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(FengYunLuManager.GAIN_LAST_BEST_INFO,  self.refresh)
end
function FengYunLuHomeLayer.onRuleClick( sender )
    CommonManager:showRuleLyaer('fengyunlu')
end
function FengYunLuHomeLayer:removeEvents()
    self.super.removeEvents(self);

    TFDirector:removeMEGlobalListener(FengYunLuManager.GAIN_LAST_BEST_INFO, self.refresh)
    self.refresh = nil
end

function FengYunLuHomeLayer:showHeroList( data )
    self.roleAnimId = {}
    if data then      
        for i = 1,#data do
            if data[i].roleId ~= 0 then
                self.Img_nobody:setVisible(false)
                local idx = #self.roleAnimId + 1
                local roleAnim = GameResourceManager:getRoleAniById(data[i].roleId)
                roleAnim:setScale(0.8)
                roleAnim:setPosition(ccp(25,0))
                roleAnim:play("stand", -1, -1, 1)
                self.posRole[idx]:setZOrder(20-idx)
                self.posRole[idx]:addChild(roleAnim)
                
                self.roleAnimId[idx] = data[i].roleId
                --加阴影
                TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role2.xml")
                local effect2 = TFArmature:create("main_role2_anim")
                if effect2 ~= nil then
                    effect2:setAnimationFps(GameConfig.ANIM_FPS)
                    effect2:playByIndex(0, -1, -1, 1)
                    effect2:setZOrder(-1)
                    effect2:setPosition(ccp(0, -10))
                    roleAnim:addChild(effect2)
                end
                --加套装特效
                if  data[i].suitNum ~= nil then 
                    Public:OtherPlayEffectOnRole(roleAnim,data[i].suitNum)
                end
            end
        end
    end
end
function FengYunLuHomeLayer:startFengYunLu()
    local StartMonthNum = os.date("%W",self.startTime/1000)
    local MyMonthNum = os.date("%W",MainPlayer:getNowtime())
    if StartMonthNum ~= MyMonthNum then
        return 0
    end
    return 1
end
function FengYunLuHomeLayer:output()
    local currTime = MainPlayer:getNowtime()
    local timestemp = self.startTime / 1000 - currTime
    local year = math.floor( timestemp / 86400 )
    timestemp = timestemp % 86400
    local hour = math.floor( timestemp / 3600 )
    timestemp = timestemp % 3600
    local min = math.floor( timestemp / 60 )
    timestemp = timestemp % 60
    local sec = math.floor(timestemp)
    local timeStr = stringUtils.format(localizable.tipsMessage_lefttime3,year,hour,min,sec)
    toastMessage(timeStr)
end
return FengYunLuHomeLayer;
