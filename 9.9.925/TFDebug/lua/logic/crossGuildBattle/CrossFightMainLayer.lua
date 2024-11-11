-- client side CrossFightMainLayer.lua
--[[
 * @Description: 跨服帮派争锋主界面
 ]]
-- script writer Stephen.tao
-- creation time 2016-05-23

local CrossFightMainLayer = class("CrossFightMainLayer",BaseLayer)

function CrossFightMainLayer:ctor(data)

	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.crossfight.CrossFightYuXuan")

end

function CrossFightMainLayer:initUI( ui )

	self.super.initUI(self, ui)

    self.generalHead = CommonManager:addGeneralHead(self)
    self.generalHead:setData(ModuleType.CrossGuildBattle,{HeadResType.SYCEE})
    ViewSizeCheck(TFDirector:getChildByPath(ui,'bg'))

    local panel_Content = TFDirector:getChildByPath(ui,'Panel_Content')
    self.imgTips_endShow = TFDirector:getChildByPath(panel_Content,'img_result')
    self.imgTips_beginShow = TFDirector:getChildByPath(panel_Content,'img_hongdi')



    self.panel_yuxuan = TFDirector:getChildByPath(ui, 'panel_yuxuan')
    self.panel_qizhi1_cell = TFDirector:getChildByPath(self.panel_yuxuan,"panel_qizhi1")
    self.panel_qizhi1_cell:retain()
    self.panel_qizhi1_cell:removeFromParent(true)
    self.panel_qizhi1_cell:setVisible(false)

    self.panel_result = TFDirector:getChildByPath(ui, 'panel_result')
    self.panel_myInfo = TFDirector:getChildByPath(ui, 'panel_myInfo')

    self.btn_fangshou = TFDirector:getChildByPath(ui, 'btn_buzhen')
    self.btn_kfsd = TFDirector:getChildByPath(ui, 'btn_kfsd')
    self.btn_jiangli = TFDirector:getChildByPath(ui, 'btn_jiangli')
    self.btn_guizhe = TFDirector:getChildByPath(ui, 'btn_guizhe')
end

function CrossFightMainLayer:removeUI()
    if self.panel_qizhi1_cell then
        self.panel_qizhi1_cell:release()
        self.panel_qizhi1_cell = nil
    end
	self.super.removeUI(self)
end

function CrossFightMainLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow()
    -- self:addBgEffect()
end

function CrossFightMainLayer:registerEvents()
	self.super.registerEvents(self)

    if self.generalHead then
        self.generalHead:registerEvents()
    end

    self.btn_fangshou:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onDefBtnClick))
    self.btn_kfsd:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShopBtnClick))
    self.btn_jiangli:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRewardBtnClick))
    self.btn_guizhe:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRuleBtnClick))

    self.guildBattleCurrentStateCallBack = function (event)
        if CrossGuildBattleManager.state == CrossGuildBattleManager.ActivityState_1 then
            CrossGuildBattleManager:gainQualifyingInfoList()
            return
        elseif CrossGuildBattleManager.state == CrossGuildBattleManager.ActivityState_4 then
            self:showCrossFightInfo()
            return
        end
        CrossGuildBattleManager:openCurrLayer(true)
    end
    TFDirector:addMEGlobalListener(CrossGuildBattleManager.GuildBattleCurrentStateNotice, self.guildBattleCurrentStateCallBack)
end

function CrossFightMainLayer:removeEvents()
    self.super.removeEvents(self)
	if self.generalHead then
        self.generalHead:removeEvents()
    end
    if self.countDownTimer then
        TFDirector:removeTimer(self.countDownTimer)
        self.countDownTimer = nil
    end

    if self.guildBattleCurrentStateCallBack then
        TFDirector:removeMEGlobalListener(CrossGuildBattleManager.GuildBattleCurrentStateNotice, self.guildBattleCurrentStateCallBack)    
        self.guildBattleCurrentStateCallBack = nil
    end
end

function CrossFightMainLayer:dispose()
	self.super.dispose(self)
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
end

function CrossFightMainLayer:showCrossFightInfo()
    self:setMyGuildInfo()
    local state = CrossGuildBattleManager:getActivityState()
    if state == CrossGuildBattleManager.ActivityState_1 then
        self:showYuXuanInfoLayer()
    elseif state == CrossGuildBattleManager.ActivityState_4 then
        self:showShowWinInfoLayer()
    else
        CrossGuildBattleManager:openCurrLayer(true)
    end
end

function CrossFightMainLayer:caculateLastTime()
    local currTime = CrossGuildBattleManager:getCurrSecond()
    local countDown = CrossGuildBattleManager:getSwitchLayerTime()
    self.lastTime = countDown - currTime
    print("self.lastTime ========>",self.lastTime)
end

function CrossFightMainLayer:showYuXuanInfoLayer()
    self.imgTips_endShow:setVisible(false)
    self.imgTips_beginShow:setVisible(true)
    self.panel_yuxuan:setVisible(true)
    self.panel_result:setVisible(false)
    local scrollView_yuxuan = TFDirector:getChildByPath(self.panel_yuxuan,"scrollView_yuxuan")
    scrollView_yuxuan:setDirection(TFTableView.TFSCROLLBOTH)
    
    self.yuxuan_cell_list = self.yuxuan_cell_list or {}
    local myRank = 0

    local cell_num = #CrossGuildBattleManager.qualifyingInfoList
    local cell_positonX = 0
    if cell_num <= 4 then
        cell_positonX = 1136/2 -cell_num/2*235
    -- else
    --     cell_positonX = -1136/2
    end
    for i=1, cell_num do
        if self.yuxuan_cell_list[i] == nil then
            self.yuxuan_cell_list[i] = self.panel_qizhi1_cell:clone()
            scrollView_yuxuan:addChild(self.yuxuan_cell_list[i])
        end
        self.yuxuan_cell_list[i]:setPosition(ccp(cell_positonX + (i-1)*235,30))
        self:setYuXuanGuildInfo(self.yuxuan_cell_list[i],CrossGuildBattleManager.qualifyingInfoList[i])
        if CrossGuildBattleManager.qualifyingInfoList[i].guildInfo.guildId == FactionManager.personalInfo.guildId then
            myRank = i
        end
    end
    scrollView_yuxuan:setInnerContainerSize(CCSizeMake(math.max(235*cell_num,1136),291))

    for i=cell_num + 1,#self.yuxuan_cell_list do
        self.yuxuan_cell_list[i]:removeFromParent()
    end

    -- local panel_gj = TFDirector:getChildByPath(self.panel_yuxuan,"panel_gj")
    -- self:setYuXuanGuildInfo(panel_gj,CrossGuildBattleManager.qualifyingInfoList[1])
    -- local panel_bf = TFDirector:getChildByPath(self.panel_yuxuan,"panel_bf")
    -- self:setYuXuanGuildInfo(panel_bf,CrossGuildBattleManager.qualifyingInfoList[2])
    local img_bangpai = TFDirector:getChildByPath(self.panel_myInfo,"img_bangpai")
    local txt_shunxu = TFDirector:getChildByPath(img_bangpai,"txt_shunxu")
    local txt_weicanyu = TFDirector:getChildByPath(img_bangpai,"txt_weicanyu")
    -- local myRank = 0
    -- for i=1,#CrossGuildBattleManager.qualifyingInfoList do
    --     if CrossGuildBattleManager.qualifyingInfoList[i].guildInfo.guildId == FactionManager.personalInfo.guildId then
    --         myRank = i
    --     end
    -- end
    if myRank == 0 then
        txt_shunxu:setVisible(false)
        txt_weicanyu:setVisible(true)
    else
        txt_shunxu:setVisible(true)
        txt_weicanyu:setVisible(false)
        txt_shunxu:setText(myRank)
    end
    local txt_tips = TFDirector:getChildByPath(self.imgTips_beginShow,"txt_tips1")
    txt_tips:setText(localizable.CrossFightBattle_ShowTxt1)

    self:caculateLastTime()

    local txt_time1 = TFDirector:getChildByPath(self.panel_myInfo,"txt_time1")
    local txt_num1 = TFDirector:getChildByPath(txt_time1,"txt_num1")
    txt_time1:setVisible(true)
    if self.countDownTimer == nil then
        self.countDownTimer = TFDirector:addTimer(1000, -1, nil, function ()
            if self.lastTime <= 0 then
                if self.countDownTimer then
                    TFDirector:removeTimer(self.countDownTimer)
                    self.countDownTimer = nil
                end
                txt_time1:setVisible(false)
            else
                txt_time1:setVisible(true)
                self.lastTime = self.lastTime - 1
                txt_num1:setText(FactionFightManager:getTimeString( self.lastTime ))
            end
        end)
    end

end

function CrossFightMainLayer:setYuXuanGuildInfo( widget , guildInfos )
    if guildInfos == nil then
        widget:setVisible(false)
        return
    else
        widget:setVisible(true)
    end
    local guildInfo = guildInfos.guildInfo
    local members = guildInfos.members
    local txt_name = TFDirector:getChildByPath(widget,"txt_name")
    txt_name:setText(guildInfo.guildName)
    txt_name:setRotationX(180)
    local img_qizhi = TFDirector:getChildByPath(widget,"img_qizhi")
    img_qizhi:setTexture(FactionManager:getGuildBannerBgPath(guildInfo.bannerId))
    local img_biaozhi = TFDirector:getChildByPath(widget,"img_biaozhi")
    img_biaozhi:setTexture(FactionManager:getGuildBannerIconPath(guildInfo.bannerId))
    local panel_role = TFDirector:getChildByPath(widget,"panel_role")
    for i=1,3 do
        local role_bg = TFDirector:getChildByPath(panel_role,"role"..i.."_bg")
        if members and members[i] then
            role_bg:setVisible(true)
            local lbRoleName = TFDirector:getChildByPath(role_bg,"txt_servername")
            lbRoleName:setText(members[i].name)
            -- local img_frameId = TFDirector:getChildByPath(role_bg,"img_di")
            -- local frameRes  = "ui_new/team/img_frame"..members[i].headPicFrame..".png";
            -- img_frameId:setTexture(frameRes)
            local img_useCoin = TFDirector:getChildByPath(role_bg,"icon_head")
            local role = RoleData:objectByID(members[i].useIcon)
            if role then
                img_useCoin:setTexture(role:getIconPath())
                Public:addFrameImg(img_useCoin,members[i].headPicFrame,true)
            end
        else
            role_bg:setVisible(false)
        end
    end
end

function CrossFightMainLayer:setMyGuildInfo()
    local img_qizhimy = TFDirector:getChildByPath(self.panel_myInfo,"img_qizhimy")
    img_qizhimy:setTexture(FactionManager:getMyBannerBgPath())
    local img_biaozhi = TFDirector:getChildByPath(img_qizhimy,"img_biaozhi")
    img_biaozhi:setTexture(FactionManager:getMyBannerIconPath())
end

function CrossFightMainLayer:showShowWinInfoLayer()
    self.imgTips_beginShow:setVisible(false)
    self.imgTips_endShow:setVisible(true)
    self.panel_yuxuan:setVisible(false)
    self.panel_result:setVisible(true)

    self:setTime(self.imgTips_endShow, CrossGuildBattleManager.previousCrossInfo.lastOpenTime)

    self.lastTime = 0
    if self.countDownTimer then
        TFDirector:removeTimer(self.countDownTimer)
        self.countDownTimer = nil
    end

    local txt_time1 = TFDirector:getChildByPath(self.panel_myInfo,"txt_time1")
    local txt_num1 = TFDirector:getChildByPath(txt_time1,"txt_num1")
    txt_time1:setVisible(false)

    
    if CrossGuildBattleManager.previousCrossInfo == nil  or CrossGuildBattleManager.previousCrossInfo.infos == nil then
        CrossGuildBattleManager:gainLastRankInfo(true)
        return
    end

    local panel_gj = TFDirector:getChildByPath(self.panel_result,"panel_gj")
    self:setShowWinGuildInfo(panel_gj,CrossGuildBattleManager.previousCrossInfo.infos[1],CrossGuildBattleManager.previousCrossInfo.members)
    local panel_yj = TFDirector:getChildByPath(self.panel_result,"panel_yj")
    self:setShowWinGuildInfo(panel_yj,CrossGuildBattleManager.previousCrossInfo.infos[2])
    local panel_jj = TFDirector:getChildByPath(self.panel_result,"panel_jj")
    self:setShowWinGuildInfo(panel_jj,CrossGuildBattleManager.previousCrossInfo.infos[3])
    local panel_bf = TFDirector:getChildByPath(self.panel_result,"panel_bf")
    self:setShowMyServerWinGuildInfo(panel_bf,CrossGuildBattleManager.previousCrossInfo.serverInfo)

    local img_bangpai = TFDirector:getChildByPath(self.panel_myInfo,"img_bangpai")
    local txt_shunxu = TFDirector:getChildByPath(img_bangpai,"txt_shunxu")
    local txt_weicanyu = TFDirector:getChildByPath(img_bangpai,"txt_weicanyu")
    local myRank = CrossGuildBattleManager.previousCrossInfo.myRank or 0
    if myRank == 0 then
        txt_shunxu:setVisible(false)
        txt_weicanyu:setVisible(true)
    else
        txt_shunxu:setVisible(true)
        txt_weicanyu:setVisible(false)
        txt_shunxu:setText(myRank)
    end


    -- local txt_time1 = TFDirector:getChildByPath(self.panel_myInfo,"txt_time1")
    -- local txt_num1 = TFDirector:getChildByPath(txt_time1,"txt_num1")
    -- txt_time1:setVisible(false)
end

function CrossFightMainLayer:setShowMyServerWinGuildInfo( widget , guildInfo)
    if guildInfo == nil then
        widget:setVisible(false)
        return
    else
        widget:setVisible(true)
    end
    -- local guildInfo = guildInfos.guildInfo
    local txt_name = TFDirector:getChildByPath(widget,"txt_name")
    txt_name:setText(guildInfo.guildName)
    local img_qizhi = TFDirector:getChildByPath(widget,"img_qizhi")
    img_qizhi:setTexture(FactionManager:getGuildBannerBgPath(guildInfo.bannerId))
    local img_biaozhi = TFDirector:getChildByPath(widget,"img_biaozhi")
    img_biaozhi:setTexture(FactionManager:getGuildBannerIconPath(guildInfo.bannerId))
    local txt_paiming = TFDirector:getChildByPath(widget,"txt_paiming")
    if CrossGuildBattleManager.previousCrossInfo.serverRank and CrossGuildBattleManager.previousCrossInfo.serverRank ~= 0 then
        txt_paiming:setText(stringUtils.format(localizable.multiFight_myRank, CrossGuildBattleManager.previousCrossInfo.serverRank))
    else
        txt_paiming:setText(localizable.common_not_rank)
    end
    -- txt_paiming:setText(CrossGuildBattleManager.previousCrossInfo.)
end

function CrossFightMainLayer:setShowWinGuildInfo( widget , guildInfo , members )
    if guildInfo == nil then
        widget:setVisible(false)
        return
    else
        widget:setVisible(true)
    end
    -- local guildInfo = guildInfos.guildInfo
    local txt_name = TFDirector:getChildByPath(widget,"txt_name")
    txt_name:setText(guildInfo.guildName)
    local txt_fwq = TFDirector:getChildByPath(widget,"txt_fwq")
    txt_fwq:setText(guildInfo.serverName)
    local img_qizhi = TFDirector:getChildByPath(widget,"img_qizhi")
    img_qizhi:setTexture(FactionManager:getGuildBannerBgPath(guildInfo.bannerId))
    local img_biaozhi = TFDirector:getChildByPath(widget,"img_biaozhi")
    img_biaozhi:setTexture(FactionManager:getGuildBannerIconPath(guildInfo.bannerId))

    if members then
        local panel_role = TFDirector:getChildByPath(widget,"panel_role")
        for i=1,3 do
            local role_bg = TFDirector:getChildByPath(panel_role,"role"..i.."_bg")
            if members and members[i] then
                role_bg:setVisible(true)
                local lbRoleName = TFDirector:getChildByPath(role_bg,"txt_servername")
                lbRoleName:setText(members[i].playerName)
                -- local img_frameId = TFDirector:getChildByPath(role_bg,"img_di")
                -- local frameRes  = "ui_new/team/img_frame"..members[i].frameId..".png";
                -- img_frameId:setTexture(frameRes)
                local img_useCoin = TFDirector:getChildByPath(role_bg,"icon_head")
                local role = RoleData:objectByID(members[i].useCoin)
                if role then
                    img_useCoin:setTexture(role:getIconPath())
                    Public:addFrameImg(img_useCoin,members[i].frameId,true)
                end
            else
                role_bg:setVisible(false)
            end
        end
    end
end

function CrossFightMainLayer.onDefBtnClick(btn)
   CrossGuildBattleManager:btnArmyClick()
end
function CrossFightMainLayer.onShopBtnClick(btn)
   MallManager:openMallLayerByType(EnumMallType.HonorMall,1)
end
function CrossFightMainLayer.onRewardBtnClick(btn)
   CrossGuildBattleManager:openRewardLayer()
end
function CrossFightMainLayer.onRuleBtnClick(btn)
   CrossGuildBattleManager:openRuleLayer()
end

function CrossFightMainLayer:addBgEffect()
    if self.bgEffect == nil then
        local bg = TFDirector:getChildByPath(self.ui, 'bg')
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/zhengbasai_jifen_bg.xml")
        local effect = TFArmature:create("zhengbasai_jifen_bg_anim")
        effect:setPosition(ccp(568,320))
        bg:addChild(effect,100)
        self.bgEffect = effect
        effect:playByIndex(0,-1,-1,1)
    end
    return self.bgEffect
end


function CrossFightMainLayer:setTime(panel, lastTime)
    local txt_time1 = TFDirector:getChildByPath(panel,"txt_tips1")
    if lastTime == nil or lastTime == 0 then
        txt_time1:setText(localizable.multiFight_result_timetxt)
    else
        lastTime = lastTime/1000
        local feedTime = ConstantData:objectByID("Guild.Battle.Cycle").value * 24 * 60 * 60
        local time1 = lastTime + feedTime
        local timeData = GetCorrectDate("*t",time1)
        txt_time1:setText(stringUtils.format(localizable.CrossFightBattle_opentime,timeData.month,timeData.day))
    end
end

return CrossFightMainLayer