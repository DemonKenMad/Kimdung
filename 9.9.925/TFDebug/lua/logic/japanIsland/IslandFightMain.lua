-- client side IslandFightMain.lua
--[[
 * @Description: 东瀛岛选关界面

 ]]
-- script writer wuqi
-- creation time 2016-12-16

local IslandFightMain = class("IslandFightMain", BaseLayer);

function IslandFightMain:ctor(data)
    self.super.ctor(self, data);
    JapanIslandManager.isEnterFightMain = true
    self.firstShow = true
    self.firstIn = true
    self:init("lua.uiconfig_mango_new.island.IslandFightMain");
end

function IslandFightMain:initUI(ui)
    self.super.initUI(self, ui)

    self.btnChat = TFDirector:getChildByPath(ui, "btn_teamchat")
    self.btn_fanhui = TFDirector:getChildByPath(ui, "btn_fanhui")
    self.btn_wddw = TFDirector:getChildByPath(ui, "btn_wddw")
    self.btn_yjtg = TFDirector:getChildByPath(ui, "btn_yjtg")
    self.panel_mysx = TFDirector:getChildByPath(ui, "panel_mysx")
    self.panel_mysx.txt_sx = TFDirector:getChildByPath(self.panel_mysx, "txt_sx")
    self.txt_teamname = TFDirector:getChildByPath(ui, "txt_teamname")
    self.panel_role = TFDirector:getChildByPath(ui, "panel_role")

    self.type_btn = {}
    local length = JapanIslandManager.MAX_SEC
    for i = 1, length do
        self.type_btn[i] = TFDirector:getChildByPath(ui, "panel_role" .. i)
        self.type_btn[i].icon_yijisha = TFDirector:getChildByPath(self.type_btn[i], "icon_yijisha")
        self.type_btn[i].txt_name = TFDirector:getChildByPath(self.type_btn[i], "txt_name")
        self.type_btn[i].img_role = TFDirector:getChildByPath(self.type_btn[i], "img_role")
        self.type_btn[i].img_zztz = TFDirector:getChildByPath(self.type_btn[i], "img_zztz")
        self.type_btn[i].bar_xuetiao1 = TFDirector:getChildByPath(self.type_btn[i], "bar_xuetiao1")
        self.type_btn[i].bg_1 = TFDirector:getChildByPath(self.type_btn[i], "bg_1")
        self.type_btn[i].panel_tj = TFDirector:getChildByPath(self.type_btn[i], "panel_tj")
        self.type_btn[i].panel_jibaizhe = TFDirector:getChildByPath(self.type_btn[i], "panel_jibaizhe")
        self.type_btn[i].txt_jibaizhe = TFDirector:getChildByPath(self.type_btn[i].panel_jibaizhe, "txt_player") 
        self.type_btn[i].txt_name:setVisible(false)
        local nowChap = JapanIslandManager:getChallengingChapId() or 1
        local copyInfo = JapanTeamCopyData:GetInfoByZoneIdAndPoint(nowChap, i)
        if (copyInfo == nil) then
            local errrInfo = nowChap or ""
            errrInfo = errrInfo.."__"..i
            toastMessage(stringUtils.format(localizable.common_error_1, errrInfo))
        end
        local offsetX = copyInfo.offsetX or 0
        local offsetY = copyInfo.offsetY or 0
        local nowPos = self.type_btn[i].img_role:getPosition()
        self.type_btn[i].img_role:setPosition( ccp( nowPos.x + offsetX, nowPos.y + offsetY ) )

        self.type_btn[i].index = i
        self.type_btn[i].logic = self
    end
end

function IslandFightMain:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function IslandFightMain:refreshUI()
    self.nowChap = JapanIslandManager:getChallengingChapId()
    self.attrLess = JapanIslandManager:getMyAttrLess() or 0
    if math.abs(self.attrLess) == 0 then
        self.panel_mysx:setVisible(false)
    else
        self.panel_mysx:setVisible(true)
    end
    self.panel_mysx.txt_sx:setText("-" .. self.attrLess .. "%")
    local chapInfo = JapanTeamChapterData:objectByID(self.nowChap)
    if not chapInfo then
        if JapanIslandManager:getTeamStatus() >= 2 then
            for i = 1, JapanIslandManager.MAX_SEC do
                self.type_btn[i].bg_1:setGrayEnabled(true)
                self.type_btn[i].bg_1:setTouchEnabled(false)
                self.type_btn[i].icon_yijisha:setVisible(true)
                self.type_btn[i].txt_name:setVisible(false)
                self.type_btn[i].img_zztz:setVisible(false)
                self.type_btn[i].panel_tj:setVisible(false)
                self:setFightEffect(self.type_btn[i], false)
                self.type_btn[i].panel_jibaizhe:setVisible(false)
            end
        end
        return
    end

    self.myTeamData = JapanIslandManager:getMyTeamData() or {}
    local str = stringUtils.format( localizable.JapanIsland_lev_range, self.myTeamData.minLevel or 0, self.myTeamData.maxLevel or 0 )
    -- self.txt_teamname:setText(chapInfo.name .. "  " .. str)
    self.txt_teamname:setText(chapInfo.name)

    local function findIdx(cpId)
        local dataInfo = JapanIslandManager.enemyList[self.nowChap].copy or {}
        for k, v in pairs(dataInfo) do
            if v.copyId == cpId then
                return k
            end
        end
        return cpId
    end

    for i = 1, JapanIslandManager.MAX_SEC do
        local copyInfo = JapanTeamCopyData:GetInfoByZoneIdAndPoint(self.nowChap, i)
        local copyId = copyInfo.copy_id
        local status, nname = JapanIslandManager:getSecStatus(self.nowChap, copyId)
        self.type_btn[i].bg_1:setGrayEnabled(false)
        local RoleIcon = RoleData:objectByID(copyInfo.icon)
        self.type_btn[i].img_role:setTexture(RoleIcon:getBigImagePath())
        self.type_btn[i].txt_name:setText(copyInfo.name)
        self.type_btn[i].icon_yijisha:setVisible(false)
        self.type_btn[i].txt_name:setVisible(false)
        self.type_btn[i].panel_jibaizhe:setVisible(false)
        self.type_btn[i].txt_jibaizhe:setVisible(true)

        local dataInfo = JapanIslandManager.enemyList[self.nowChap].copy or {}
        local iidx = findIdx(copyId)
        local info = dataInfo[iidx] or {}
        local monsInfo = info.monster or {}
        local bossIdx = copyInfo[ tonumber(copyInfo.boss_index) ] or 1
        local hp = 1
        local maxHp = 1
        local bossInfo = monsInfo[bossIdx]
        for j = 1, #monsInfo do
            if monsInfo[j].index == bossIdx then
                hp = monsInfo[j].hp
                maxHp = monsInfo[j].maxHp
            end
        end
        
        local per = math.floor( (hp / maxHp) * 100 ) or 100
        self.type_btn[i].bar_xuetiao1:setPercent(per)

        self.type_btn[i].bg_1:setTouchEnabled(true)
        self.type_btn[i].bg_1:setGrayEnabled(false)
        self.type_btn[i].bg_1.logic = self
        self.type_btn[i].bg_1.idx = i
        self.type_btn[i].bg_1.copy_id = copyId

        self.type_btn[i].bg_1:addMEListener(TFWIDGET_CLICK, self.cellSectionClick)
        -- local killName = nname or ""
        local killName = info.killName or nname or ""
        self.type_btn[i].img_zztz:setTexture("ui_new/island/img_zztz.png")

        if JapanIslandManager:getTeamStatus() >= 2 then
            status = JapanIslandManager.EnumCopyStatus.PASSED
        end

        if status == JapanIslandManager.EnumCopyStatus.PASSED then
            self:setFightEffect(self.type_btn[i], false)
            self.type_btn[i].bg_1:setGrayEnabled(true)
            self.type_btn[i].bg_1:setTouchEnabled(false)
            self.type_btn[i].icon_yijisha:setVisible(true)
            self.type_btn[i].txt_name:setVisible(false)
            -- self.type_btn[i].txt_name:setText(killName)
            self.type_btn[i].img_zztz:setVisible(false)
            self.type_btn[i].panel_tj:setVisible(false)

            self.type_btn[i].panel_jibaizhe:setVisible(true)
            self.type_btn[i].txt_jibaizhe:setText(killName)
        elseif status == JapanIslandManager.EnumCopyStatus.TRUSTING then
            self:setFightEffect(self.type_btn[i], true)
            self.type_btn[i].img_zztz:setVisible(true)
            self.type_btn[i].txt_name:setVisible(true)
            self.type_btn[i].txt_name:setText(killName)
            self.type_btn[i].img_zztz:setTexture("ui_new/island/img_zztg.png")
            self.type_btn[i].panel_tj:setVisible(false)
        elseif status == JapanIslandManager.EnumCopyStatus.CHALLENGING then
            self:setFightEffect(self.type_btn[i], true)
            self.type_btn[i].txt_name:setVisible(true)
            self.type_btn[i].img_zztz:setVisible(true)
            self.type_btn[i].txt_name:setText(killName)
            self.type_btn[i].panel_tj:setVisible(false)
        elseif status == JapanIslandManager.EnumCopyStatus.NOT_CHALLENGE then
            self:setFightEffect(self.type_btn[i], false)
            self.type_btn[i].txt_name:setText(localizable.JapanIsland_tuijian_zhanli)
            self.type_btn[i].txt_name:setVisible(true)
            self.type_btn[i].img_zztz:setVisible(false)
            self.type_btn[i].panel_tj:setVisible(true)
            local txt_zhanli = TFDirector:getChildByPath(self.type_btn[i].panel_tj, "txt_zhanli")
            txt_zhanli:setVisible(true)
            txt_zhanli:setText(copyInfo.power or 0)
        end
    end

    if self.firstShow then
        self.firstShow = false
        self.ui:runAnimation("Action0", 1);
    end
end

function IslandFightMain.onChatClick( btn )
    local self = btn.logic
    JapanIslandManager:setTeamChatRedState(false)
    CommonManager:setRedPoint(self.btnChat, JapanIslandManager:getTeamChatRedState(),"btnChat",ccp(0,0))
    --self:onShow()
    JapanIslandManager:openChatLayer()
end

function IslandFightMain.onSignOutClick(btn)
    --AlertManager:close()
    -- local self = btn.logic
    -- local myTeamId = JapanIslandManager:getMyTeamId() or 0
    -- if (myTeamId == nil or myTeamId == 0) then
    --     toastMessage(localizable.JapanIsland_tips1)
    --     JapanIslandManager:requestOperateTeam(1, myTeamId, MainPlayer:getPlayerId())
    --     AlertManager:closeLayer(self)
    --     return
    -- end
    CommonManager:showOperateSureLayer(
        function()
            JapanIslandManager:requestOperateTeam(1, JapanIslandManager:getMyTeamId() or 0, MainPlayer:getPlayerId())
        end,
        function()
            AlertManager:close()
        end,
        {
            title = localizable.common_tips,
            msg = localizable.JapanIsland_quit_fight_sure,
            showtype = AlertManager.BLOCK_AND_GRAY,
        }
    )
end

function IslandFightMain.onOneKeyClick(sender)
    local self = sender.logic

    if MissionManager.trustOneKeyState then
        print("already in one key state")
        self:quitOneKey()
        return
    end

    -- JapanIslandManager:requestHosting(0)
    MissionManager:startTrustOnekey(self, true)
end

function IslandFightMain:quitOneKey()
    -- JapanIslandManager:requestHosting(1)
    MissionManager:stopTrustOnekey()
end

function IslandFightMain:onClickHandleForTrustLayer()
    self.myTeamData = JapanIslandManager:getMyTeamData()

    --print("JapanIslandManager:getTeamStatus() +++++++++ ", JapanIslandManager:getTeamStatus())
    if JapanIslandManager:getTeamStatus() >= 2 then
        print("JapanIslandManager:getTeamStatus() >= 2")
        --self:quitOneKey()
        MissionManager:stopTrustOnekey()
        return 
    end

    if not self.myTeamData then
        print("self.myTeamData == nil")
        self:quitOneKey()
        return 
    end
    self.nowChap = JapanIslandManager:getChallengingChapId()
    if not self.nowChap then
        print(" nowChap == nil ")
        self:quitOneKey()
        return
    end
    self.sectionData = JapanIslandManager:getSectionInfoByChapId(self.nowChap)
    if not self.sectionData then
        print(" sectionData == nil ")
        self:quitOneKey()
        return
    end
    -- 逆序
    table.sort( self.sectionData, function(sec1, sec2)
        return sec1.copy_id > sec2.copy_id
    end )
    self.memberData = self.myTeamData.member
    self.passedChapList = JapanIslandManager:getPassedSecList(chapId)
    -- 优先挑战没有人挑战的BOSS
    local cleanSecList = {}
    local passedCount = 0
    for i = 1, #self.sectionData do
        local secInfo = self.sectionData[i]
        local copyStatus = JapanIslandManager:getSecStatus(self.nowChap, secInfo.copy_id)
        if copyStatus == JapanIslandManager.EnumCopyStatus.NOT_CHALLENGE then
            table.insert(cleanSecList, secInfo.copy_id)
        elseif copyStatus == JapanIslandManager.EnumCopyStatus.PASSED then
            passedCount = passedCount + 1
        end
    end
    if passedCount >= #self.sectionData then
        print(" all section passed!! ")
        self:quitOneKey()
        return
    end
    if #cleanSecList == 0 then
        for i = 1, #self.sectionData do
            local secInfo = self.sectionData[i]
            local copyStatus = JapanIslandManager:getSecStatus(self.nowChap, secInfo.copy_id)
            if copyStatus < JapanIslandManager.EnumCopyStatus.PASSED then
                table.insert(cleanSecList, secInfo.copy_id)
            end
        end
        if #cleanSecList == 0 then
            toastMessage(localizable.TrustOneKey_Nomore)
            self:quitOneKey()
        else
            local temp = { chapId = self.nowChap, secId = cleanSecList[1] }
            JapanIslandManager:openVSLayer(temp)
        end
    else
        local temp = { chapId = self.nowChap, secId = cleanSecList[1] }
        JapanIslandManager:openVSLayer(temp)
    end
end

function IslandFightMain.onMyTeamClick(btn)
    local self = btn.logic
    --AlertManager:close()
    JapanIslandManager:openMyTeamShowLayer()
end


function IslandFightMain.onGoClickHandle(sender)
    local self = sender.logic
    local index = sender.index
    local copy_id = sender.copy_id

    print("MissionManager:isInTrustOnekey() ==>> ", MissionManager:isInTrustOnekey())
    if not MissionManager:isInTrustOnekey() then
        self:quitOneKey()
    end
    
    JapanIslandManager:openVSLayer({ chapId = self.nowChap, secId = copy_id })
end

function IslandFightMain:removeUI()
    self.super.removeUI(self);
    JapanIslandManager.isEnterFightMain = false
end

function IslandFightMain:registerEvents()
    self.super.registerEvents(self);

    self.btnChat.logic = self
    self.btnChat:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onChatClick))

    self.btn_fanhui.logic = self
    self.btn_fanhui:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSignOutClick))

    self.btn_wddw.logic = self
    self.btn_wddw:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onMyTeamClick))

    self.btn_yjtg.logic = self
    self.btn_yjtg:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onOneKeyClick))

    self.UpdateTeamInfoMsgCallBack = function(event)
        local status = JapanIslandManager:getTeamStatus()
        if status then
            if (status == 3 or status == 4) then
                AlertManager:closeLayer(self)
            else
                self:refreshUI()
            end
        else
            self:refreshUI()
        end
    end
    TFDirector:addMEGlobalListener(JapanIslandManager.MY_TEAM_REPONSE, self.UpdateTeamInfoMsgCallBack) 

    self.leaveFightCallBack = function(event)
        --同步托管状态
        MissionManager:checkTrustOnekeyLayer(self, true)

        -- if not MissionManager:isInTrustOnekey() then
        --     JapanIslandManager:requestHosting(0)
        -- end
    end
    TFDirector:addMEGlobalListener(FightManager.LeaveFightForOneKey ,self.leaveFightCallBack )

    self.lastRefresh = function()
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(JapanIslandManager.REFRESH_LAST_TIME ,self.lastRefresh )   

    self.redChange = function()
        CommonManager:setRedPoint(self.btnChat, JapanIslandManager:getTeamChatRedState(), "btnChat", ccp(0,0))
    end
    TFDirector:addMEGlobalListener(JapanIslandManager.UpdateNewChatMsg ,self.redChange )

    self.chapRefreshCallBack = function(event)
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(JapanIslandManager.CHAPTER_STATUS_DATA_RESPONSE, self.chapRefreshCallBack) 

    if HeitaoSdk then
        HeitaoSdk.disableDeviceSleep(true)
    end
end

function IslandFightMain:removeEvents()
    TFDirector:removeMEGlobalListener(JapanIslandManager.MY_TEAM_REPONSE,self.UpdateTeamInfoMsgCallBack)
    self.UpdateTeamInfoMsgCallBack = nil

    TFDirector:removeMEGlobalListener(FightManager.LeaveFightForOneKey ,self.leaveFightCallBack )
    self.leaveFightCallBack = nil

    TFDirector:removeMEGlobalListener(JapanIslandManager.REFRESH_LAST_TIME ,self.lastRefresh )
    self.lastRefresh = nil

    TFDirector:removeMEGlobalListener(JapanIslandManager.UpdateNewChatMsg ,self.redChange )
    self.redChange = nil

    TFDirector:removeMEGlobalListener(JapanIslandManager.CHAPTER_STATUS_DATA_RESPONSE ,self.chapRefreshCallBack )
    self.chapRefreshCallBack = nil
    
    self.super.removeEvents(self);

    if HeitaoSdk then
        HeitaoSdk.disableDeviceSleep(false)
    end
end

function IslandFightMain.cellSectionClick(btn)
    local self = btn.logic
    local idx = btn.idx
    local copyId = btn.copy_id


    JapanIslandManager:openVSLayer( { chapId = self.nowChap, secId = copyId } )
end

function IslandFightMain:setFightEffect(node, bShow)
    if node.fighteffect == nil then
        TFResourceHelper:instance():addArmatureFromJsonFile("effect/mission_attacking.xml")
        node.fighteffect = TFArmature:create("mission_attacking_anim")
        if node.fighteffect == nil then
            return
        end
        node.fighteffect:setScale(0.5)
        local size = node:getSize()
        node.fighteffect:setAnimationFps(GameConfig.ANIM_FPS)
        node.fighteffect:playByIndex(0, -1, -1, 1)
        node.fighteffect:setZOrder(10)
        node.fighteffect:setPosition(ccp(size.width / 2 - 40, size.height / 2))
        node:addChild(node.fighteffect)
    end
    if bShow then
        node.fighteffect:setVisible(true)
    else
        node.fighteffect:setVisible(false)
    end
end


return IslandFightMain;