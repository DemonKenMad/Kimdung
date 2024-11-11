-- client side StarHeroLayer.lua
--[[
 * @Description: 名人堂界面
 ]]
-- script writer chikui
-- creation time 2016-10-22


local StarHeroLayer = class("StarHeroLayer", BaseLayer)


function StarHeroLayer:ctor()
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.fame.FameMain")
end

function StarHeroLayer:initUI(ui)
	self.super.initUI(self,ui)
    self.panelDesPos = -525
    self.btn_help         = TFDirector:getChildByPath(ui, 'btn_help')
    self.btn_close = TFDirector:getChildByPath(ui, 'btn_fanhui')

    self.panel_role_list = {}
    for i=1,5 do
        local rootNode = TFDirector:getChildByPath(ui, 'panel_role'..i)
        self.panel_role_list[i] = rootNode
        self.panel_role_list[i].panel_role = TFDirector:getChildByPath(rootNode, 'panel_role')
        self.panel_role_list[i].img_role = TFDirector:getChildByPath(rootNode, 'img_role')
        self.panel_role_list[i].txt_name = TFDirector:getChildByPath(rootNode, 'txt_name')
        self.panel_role_list[i].txt_power = TFDirector:getChildByPath(rootNode, 'txt_power')
        self.panel_role_list[i].txt_dj = TFDirector:getChildByPath(rootNode, 'txt_dj')
        self.panel_role_list[i].txt_num = TFDirector:getChildByPath(rootNode, 'txt_no')
        self.panel_role_list[i].img_num = TFDirector:getChildByPath(rootNode, 'img_ci')
        self.panel_role_list[i].btn_mobai = TFDirector:getChildByPath(rootNode, 'btn_mobai')
        self.panel_role_list[i].armature = nil
    end

    self.panel_myinfo = TFDirector:getChildByPath(ui, 'bg_yazhushijian')

    self.btn_box = TFDirector:getChildByPath(self.panel_myinfo, 'btn_bx')
    local txt_rank = TFDirector:getChildByPath(self.panel_myinfo, 'txt_rank')
    self.txt_myrank = TFDirector:getChildByPath(txt_rank, 'txt_num')

    local txt_cishu = TFDirector:getChildByPath(self.panel_myinfo, 'txt_cishu')
    self.txt_lefttime = TFDirector:getChildByPath(txt_cishu, 'txt_num')

    self.panel_more = TFDirector:getChildByPath(ui, 'panel_more')
    self.panel_list = TFDirector:getChildByPath(ui, 'panel_huadong')
    self.btn_rank = TFDirector:getChildByPath(ui, 'btn_more')

    self.rank_cell_model = TFDirector:getChildByPath(ui, 'bg_1')
    self.rank_cell_model:removeFromParent(false)
    self.rank_cell_model:retain()
    self.tabView = nil
    self.oldRankIndex = nil
    self.isDoGotoRank = false
    self.armatureList = {}
end

function StarHeroLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
    self:showLeftTimes()
end

function StarHeroLayer:dispose()
    self.super.dispose(self)
end

function StarHeroLayer:refreshUI()
    self:showTopFive()
    self:showMyInfo()
    self:refreshTableView()
end

function StarHeroLayer:showMyInfo()
    local myRankNum = StarHeroManager:getMyRank()
    if myRankNum == nil or myRankNum <= 0 then
        self.txt_myrank:setText(localizable.shalu_info_txt1)
    else
        self.txt_myrank:setText(myRankNum)
    end

    if StarHeroManager:IsCanGetReward() == true then
        self.btn_box:setVisible(true)
        self:showRewardEffect(true)
    else
        self.btn_box:setVisible(false)
    end
end

function StarHeroLayer:showLeftTimes()
    local times = 0
    local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.STAR_HERO_THUMB)
    if challengeInfo then
        times = challengeInfo:getLeftChallengeTimes()
    end
    self.txt_lefttime:setText(stringUtils.format(localizable.common_times,times))
end

function StarHeroLayer.onGetRewardClick(sender)
    local self = sender.logic
    StarHeroManager:requestGetReward()
end

function StarHeroLayer:refreshTableView()
    if self.tableView == nil then
        local tabView =  TFTableView:create()
        tabView:setTableViewSize(self.panel_list:getContentSize())
        tabView:setDirection(TFTableView.TFSCROLLVERTICAL)
        tabView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
        tabView.logic = self
        self.panel_list:addChild(tabView)
        tabView:setPosition(ccp(0, 0))
        self.tableView = tabView

        self.tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
        self.tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
        self.tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
        self.tableView:reloadData()
    else
        self.tableView:reloadData()
    end
    local num = StarHeroManager:getRankSize()
    if num <= 5 then
        self.panel_more:setVisible(false)
    else
        self.panel_more:setVisible(true)
    end
    if self.oldRankIndex ~= nil then
        local size = self.tableView:getTableViewSize()
        local size2 = self.tableView:getContentSize()
        if size2.height > size.height then
            local posY = -( self.numberOfCellsInTableView() - self.oldRankIndex ) * 74
            local pos = self.tableView:getContentOffset()
            if posY < size.height - size2.height then
                posY = size.height - size2.height
            end
            pos.y = posY
            self.tableView:setContentOffset(pos)
            self.oldRankIndex = nil
        end
    elseif self.isDoGotoRank == true then
        local size = self.tableView:getTableViewSize()
        local size2 = self.tableView:getContentSize()
        local myRank = StarHeroManager:getMyRank()
        if myRank == nil or myRank <= 0 or myRank > 50 then
            return
        end
        if myRank <= 5 then
            return
        end
        local curNum = self.numberOfCellsInTableView()
        if curNum <= 0 then
            return
        end
        curNum = curNum + 5
        posY = (curNum - myRank)*74
        posY = size.height - posY
        if posY > 0 then
            posY = 0
        end
        if posY < size.height - size2.height then
            posY = size.height - size2.height
        end
        local pos = self.tableView:getContentOffset()
        pos.y = posY
        self.tableView:setContentOffset(pos)

        self.panelDesPos = 0
        local posX = self.panel_more:getPositionX()
        local acMove = CCMoveTo:create(0.3,ccp(posX,self.panelDesPos))
        self.panel_more:runAction(acMove)
        self.isDoGotoRank = false
    end
end

function StarHeroLayer.cellSizeForTable(table,idx)
    local self = table.logic
    local num = self.numberOfCellsInTableView()
    if idx == num then
        return 74,700
    end
    return 74, 700
end

function StarHeroLayer.numberOfCellsInTableView(table)
    local num = StarHeroManager:getRankSize()
    if num > 5 then
        if num < 50 then
            num = num + 1
        end
        num = num - 5
    else
        num = 0
    end
    return num
end

function StarHeroLayer.tableCellAtIndex(table, idx)
    local self = table.logic

    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.rank_cell_model:clone()
        panel:setPosition(ccp(6,0))
        panel:setVisible(true)
        cell:addChild(panel)
        cell.panel = panel
    end
    cell.panel:setVisible(true) 
    if idx + 1 + 5 > StarHeroManager:getRankSize() then
        self:setPanelRankInfo(cell.panel, nil, -1)
    else
        local rankInfo = StarHeroManager:getRankInfo(idx + 1 + 5)
        self:setPanelRankInfo(cell.panel, rankInfo, idx + 1 + 5)
    end
    return cell
end

function StarHeroLayer:setPanelRankInfo(panel, rankInfo, rank)
    local playerName = TFDirector:getChildByPath(panel, "txt_name")
    local txt_power = TFDirector:getChildByPath(panel, "txt_zhanli")
    local txt_num = TFDirector:getChildByPath(panel, "txt_num")
    local txt_ServerName = TFDirector:getChildByPath(panel, "txt_fwq")
    local btn_mobai = TFDirector:getChildByPath(panel, "btn_mobai")
    local bg_more = TFDirector:getChildByPath(panel, "bg_more")
    local img_rank = TFDirector:getChildByPath(panel, "img_shunxu")
    local txt_rank = TFDirector:getChildByPath(panel, "txt_shunxu")
    local txt_dj = TFDirector:getChildByPath(panel, "txt_dj")
    if rankInfo ~= nil then
        btn_mobai.idx = rank
        btn_mobai.playerId = rankInfo.playerId
        btn_mobai:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onThumbClick),1)
        playerName:setText(rankInfo.name)
        txt_ServerName:setText(rankInfo.serverName)
        txt_power:setText(rankInfo.power)
        txt_num:setText(stringUtils.format(localizable.common_times,rankInfo.praise))
        btn_mobai:setVisible(true)
        txt_dj:setText(stringUtils.format(localizable.common_LV,rankInfo.level))

        if StarHeroManager:isCanThumb(rankInfo.playerId) == false then
            btn_mobai:setTouchEnabled(false)
            btn_mobai:setGrayEnabled(true)
        else
            btn_mobai:setTouchEnabled(true)
            btn_mobai:setGrayEnabled(false)
        end
        
        if rank <= 3 then
            img_rank:setVisible(true)
            txt_rank:setVisible(false)
            img_rank:setTexture("ui_new/leaderboard/no"..rank..".png")
        else
            img_rank:setVisible(false)
            txt_rank:setVisible(true)
            txt_rank:setText(rank)
        end
        bg_more:setVisible(false)
        Public:addInfoListen(panel,true,8,rankInfo.playerId,rankInfo.serverId)
    else
        Public:addInfoListen(panel,false)
        playerName:setText('')
        txt_power:setText('')
        txt_num:setText('')
        txt_ServerName:setText('')
        txt_rank:setText('')
        txt_dj:setText('')
        img_rank:setVisible(false)
        btn_mobai:setVisible(false)
        bg_more:setVisible(false)
        if rank == -1 then
            bg_more:setVisible(true)
            bg_more.logic = self
            bg_more:setTouchEnabled(true)
            bg_more:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRankMoreClick))
        end
    end
    
end

function StarHeroLayer.onRankMoreClick(sender)
    local self = sender.logic
    local index = sender.index
    self.oldRankIndex = self.numberOfCellsInTableView()
    local oldNum = StarHeroManager:getRankSize() + 1
    local requestNum = math.ceil( oldNum / 10 ) * 10

    if requestNum >= 50 then
        requestNum = 50
    end
    self.isDoGotoRank = false
    StarHeroManager:requestRankingInfo(requestNum)
end

function StarHeroLayer.onShowRankClick(sender)
    local self = sender.logic
    if self.panelDesPos == 0 then
        self.panelDesPos = -525
    else
        self.panelDesPos = 0
    end
    local posX = self.panel_more:getPositionX()
    local acMove = CCMoveTo:create(0.3,ccp(posX,self.panelDesPos))
    self.panel_more:runAction(acMove)
end

function StarHeroLayer:CreateArmature(roleID)
    local roleTableData = RoleData:objectByID(roleID)
    if roleTableData == nil then
        return nil
    end

    local resID = roleTableData.image
	
	local resPathXML = "armature/"..resID..".xml"
	local resPathAlats = "armature/".. resID .. ".atlas" 
	local armature
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "armature/".. resID
		armature = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		armature = TFArmature:create(resID.."_anim")
	else
		resID = 10006
		TFResourceHelper:instance():addArmatureFromJsonFile("armature/"..resID..".xml")
		armature = TFArmature:create(resID.."_anim")
	end
	
	if armature == nil then
		assert(false, "armature"..resID.."create error")
		return
	end
    GameResourceManager:addRole( roleID, armature)

    self.armatureList[roleID] = armature
    armature:retain()
    return armature
end

function StarHeroLayer:AddRoleFootEffect(roleArmature)
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

function StarHeroLayer:RemoveNoUseArmature()
    local needRemove = false
    for roleID, armature in pairs(self.armatureList) do
        if armature then
            armature:release()
        end
        if not self:IsUsedArmature(roleID)  then
            GameResourceManager:removeRole( roleID )
            needRemove = true
        end
    end
    self.armatureList = {}
    if needRemove then
        me.ArmatureDataManager:removeUnusedArmatureInfo()
    end
end

function StarHeroLayer:IsUsedArmature(roleID)
    local roleList = CardRoleManager:getUsedCardList()
    local roleNum = roleList:length()
    for i=1,roleNum do
        local cardRole = roleList:getObjectAt(i)
        if cardRole ~= nil and cardRole.id == roleID then
            return true
        end
    end

    return false
end

function StarHeroLayer:showTopFive()
    local scaleXList = {1,1,-1,1,-1}
    for i = 1,5 do
        local rankInfo = StarHeroManager:getRankInfo(i)
        if rankInfo then
            self.panel_role_list[i]:setVisible(true)
            self.panel_role_list[i].btn_mobai.playerId = rankInfo.playerId
             
            local showBig = false
            if rankInfo.useIcon and rankInfo.useIcon ~= 0 then
                local armature = self.panel_role_list[i].armature
                if armature == nil or armature.roleId ~= rankInfo.useIcon then
                    if armature then
                        armature:removeFromParent()
                        self.panel_role_list[i].armature = nil
                    end
                    if self.armatureList[rankInfo.useIcon] ~= nil then
                        armature = self.armatureList[rankInfo.useIcon]:clone()
                    else
                        local armatureModel = self:CreateArmature(rankInfo.useIcon)
                        armature = armatureModel:clone()
                    end
                    armature.roleId = rankInfo.useIcon
                    self.panel_role_list[i].armature = armature
                    self.panel_role_list[i].panel_role:addChild(armature,10)
                    local pos = self.panel_role_list[i].img_role:getPosition()
                    pos.y = pos.y - 90
                    armature:setPosition(pos)
                    armature:setName("armature")
                    armature:play("stand", -1, -1, 1)
                    armature:setScaleX(scaleXList[i])
                    self:AddRoleFootEffect(armature)
                end
                if armature then
                    showBig = true
                    self.panel_role_list[i].armature = armature
                end
            end
            self.panel_role_list[i].img_role:setVisible(false)
            self.panel_role_list[i].panel_role:setTouchEnabled(true)
            Public:addInfoListen(self.panel_role_list[i].panel_role,true,8,rankInfo.playerId,rankInfo.serverId)
			local serverName = rankInfo.serverName
			-- serverId = math.mod(serverId,1000)
            self.panel_role_list[i].txt_name:setText(serverName .. rankInfo.name)
            self.panel_role_list[i].txt_power:setText('' .. rankInfo.power)
            self.panel_role_list[i].txt_dj:setText(stringUtils.format(localizable.common_LV,rankInfo.level))
            self.panel_role_list[i].txt_num:setText(rankInfo.praise)
            local size = self.panel_role_list[i].txt_num:getContentSize()
            local scaleX = self.panel_role_list[i].txt_num:getScaleX()
            local size0 = self.panel_role_list[i].img_num:getContentSize()
            local scaleX0 = self.panel_role_list[i].img_num:getScaleX()
            local posX = self.panel_role_list[i].btn_mobai:getPositionX()
            posX = posX - (size.width * scaleX + size0.width * scaleX0) *0.5
            self.panel_role_list[i].txt_num:setPositionX(posX)

            self.panel_role_list[i].img_num:setPositionX(size.width * scaleX + posX)
            if StarHeroManager:isCanThumb(rankInfo.playerId) == false then
                self.panel_role_list[i].btn_mobai:setTouchEnabled(false)
                self.panel_role_list[i].btn_mobai:setGrayEnabled(true)
            else
                self.panel_role_list[i].btn_mobai:setTouchEnabled(true)
                self.panel_role_list[i].btn_mobai:setGrayEnabled(false)
            end
        else
            self.panel_role_list[i]:setVisible(false)
            self.panel_role_list[i].btn_mobai.playerId = nil
        end
    end
end

function StarHeroLayer:showRewardEffect(bShow)
    if bShow == true then
        if self.EscortingEffect == nil then
            local resPath = "effect/escorting.xml"
            TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
            local effect = TFArmature:create("escorting_anim")
            local node   = self.btn_box
            effect:setAnimationFps(GameConfig.ANIM_FPS)
            node:addChild(effect, 1)
            local size = node:getContentSize()
            effect:setPosition(ccp(size.width * 0.5, size.height * 0.5 -17))
            effect:setAnchorPoint(ccp(0.5, 0.5))
            effect:setScale(1.2)
            self.EscortingEffect = effect
            self.EscortingEffect:playByIndex(1, -1, -1, 1)
        end
    else
        if self.EscortingEffect ~= nil then
            self.EscortingEffect:removeFromParent()
            self.EscortingEffect = nil
        end
    end
end

function StarHeroLayer:removeUI()
    self.super.removeUI(self)
    if self.rank_cell_model then
        self.rank_cell_model:release()
        self.rank_cell_model = nil
    end
    self:RemoveNoUseArmature()
end

function StarHeroLayer.onThumbClick(sender)
    local self = sender.logic
    local rank = sender.idx
    if sender.idx and sender.playerId then
        StarHeroManager:requestThumb(sender.idx,sender.playerId)
    end
end

function StarHeroLayer.OnRuleClick( sender )
    CommonManager:showRuleLyaer('halloffame')
end

function StarHeroLayer.OnGoToMyRank( sender )
    local self = sender.logic
    local myRank = StarHeroManager:getMyRank()
    if myRank == nil or myRank <= 0 or myRank > 50 then
        toastMessage(localizable.star_hero_goto_rank_tip2)
        return
    end
    if myRank <= 5 then
        toastMessage(localizable.star_hero_goto_rank_tip1)
        return
    end
    local requestNum = math.ceil(myRank/10) * 10
    StarHeroManager:requestRankingInfo(requestNum)
    self.isDoGotoRank = true
    self.oldRankIndex = nil
end

function StarHeroLayer:registerEvents()
	self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);
    self.btn_box:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onGetRewardClick),1)
    self.btn_box.logic = self

    self.btn_rank:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShowRankClick),1)
    self.btn_rank.logic = self

    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnRuleClick))
    self.btn_help.logic = self

    self.panel_myinfo:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnGoToMyRank))
    self.panel_myinfo:setTouchEnabled(false)
    self.panel_myinfo.logic = self

    for i = 1,5 do
        self.panel_role_list[i].btn_mobai.idx = i
        self.panel_role_list[i].btn_mobai:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onThumbClick),1)
    end

    self.StarHeroLayerGetRewardCallBack = function (event)
        self:refreshUI()
        local rank = event.data[1].rank
        if rank and rank > 0 and rank <= 5 then

        end
    end
    TFDirector:addMEGlobalListener(StarHeroManager.RECEIVE_GET_REWARD,self.StarHeroLayerGetRewardCallBack)


    self.StarHeroLayerRankInfoCallBack = function (event)
        self:refreshUI()
    end
    TFDirector:addMEGlobalListener(StarHeroManager.RECEIVE_RANKING_INFO,self.StarHeroLayerRankInfoCallBack)

    self.thumbTimesBrushCallBack = function (event)
        local resType = event.data[1]
        if resType == 0 or resType == EnumRecoverableResType.STAR_HERO_THUMB then
            self:showLeftTimes()
        end
    end
    TFDirector:addMEGlobalListener(MainPlayer.ChallengeTimesChange,self.thumbTimesBrushCallBack)
end

function StarHeroLayer:removeEvents()
    TFDirector:removeMEGlobalListener(StarHeroManager.RECEIVE_GET_REWARD,self.StarHeroLayerGetRewardCallBack)

    TFDirector:removeMEGlobalListener(StarHeroManager.RECEIVE_RANKING_INFO,self.StarHeroLayerRankInfoCallBack)

    TFDirector:removeMEGlobalListener(MainPlayer.ChallengeTimesChange,self.thumbTimesBrushCallBack)

    self.super.removeEvents(self)
end

return StarHeroLayer
