-- client side CrossZhengBaRankLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2017-02-28



local CrossZhengBaRankLayer = class("CrossZhengBaRankLayer", BaseLayer)


function CrossZhengBaRankLayer:ctor()
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.crosszhenba.CrossZhenBaList")
end

function CrossZhengBaRankLayer:initUI(ui)
	self.super.initUI(self,ui)
    self.btn_close = TFDirector:getChildByPath(ui, 'btn_fanhui')

    self.panel_role_list = {}
    for i=1,3 do
        local rootNode = TFDirector:getChildByPath(ui, 'panel_role'..i)
        self.panel_role_list[i] = rootNode
        self.panel_role_list[i].panel_role  = TFDirector:getChildByPath(rootNode, 'panel_role')
        self.panel_role_list[i].img_role    = TFDirector:getChildByPath(rootNode, 'img_role')
        self.panel_role_list[i].txt_name    = TFDirector:getChildByPath(rootNode, 'txt_name')
        self.panel_role_list[i].txt_power   = TFDirector:getChildByPath(rootNode, 'txt_power')
        self.panel_role_list[i].txt_dj  = TFDirector:getChildByPath(rootNode, 'txt_dj')
        self.panel_role_list[i].img_dw  = TFDirector:getChildByPath(rootNode, 'img_dw')
        self.panel_role_list[i].txt_no  = TFDirector:getChildByPath(rootNode, 'txt_no')
        self.panel_role_list[i].img_level  = TFDirector:getChildByPath(rootNode, 'img_level')
        self.panel_role_list[i].img_heidi  = TFDirector:getChildByPath(rootNode, 'img_heidi')
        self.panel_role_list[i].armature = nil
    end

     self.img_bg         = TFDirector:getChildByPath(ui, 'img_bg')
    self.bg_wddw        = TFDirector:getChildByPath(ui, 'bg_wddw')
    self.img_dw         = TFDirector:getChildByPath(self.bg_wddw, 'img_dw') 
    self.img_level      = TFDirector:getChildByPath(self.img_dw, 'img_level')
    self.img_bg         = TFDirector:getChildByPath(ui, 'img_bg')
    self.txt_cishu      = TFDirector:getChildByPath(self.bg_wddw, 'txt_cishu')
    self.txt_star       = TFDirector:getChildByPath(self.txt_cishu, 'txt_star')
    self.txt_rank           = TFDirector:getChildByPath(self.bg_wddw, 'txt_rank')
    local myChallengeInfo   = CrossZhengBaManager:getMyChallengeInfo()
    local path              = CrossZhengBaManager:getGradeImg(myChallengeInfo.grade)
    local itemData          = CrossZhengBaManager:getData(myChallengeInfo.grade)
    local path1             = CrossZhengBaManager:getGradeLevelTag(myChallengeInfo.grade)
    
    self.img_level:setTexture(path1)
    self.txt_star:setText("X" .. myChallengeInfo.star)
    self.img_dw:setTexture(path)
    self.txt_cishu:setText(itemData.name)
   
    local myRankInfo = CrossZhengBaManager:getMyRankInfo()
    if (myRankInfo and myRankInfo.rank) then
        local txt_num           = TFDirector:getChildByPath(self.txt_rank, 'txt_num')
        txt_num:setText(myRankInfo.rank)
    end

    local resPath = "effect/crosszhengba_rank_effect.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create("crosszhengba_rank_effect_anim")
    self.img_bg:addChild(effect,100,100)
    effect:setPosition(ccp(1136*0.5,320))
    effect:playByIndex(0,-1,-1,1)   

    self.panel_list = TFDirector:getChildByPath(ui, 'panel_paihang')

    self.rank_cell_model = TFDirector:getChildByPath(ui, 'img_heidi1')
    self.rank_cell_model:removeFromParent(false)
    self.rank_cell_model:retain()
    self.tabView = nil
    self.armatureList = {}
 
end

function CrossZhengBaRankLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function CrossZhengBaRankLayer:dispose()
    self.super.dispose(self)
end

function CrossZhengBaRankLayer:refreshUI()
    self:showTopThree()
    self:showMyInfo()
    self:refreshTableView()
end

function CrossZhengBaRankLayer:showMyInfo()
    local myRankNum = StarHeroManager:getMyRank()
    -- if myRankNum == nil or myRankNum <= 0 then
    --     self.txt_myrank:setText(localizable.shalu_info_txt1)
    -- else
    --     self.txt_myrank:setText(myRankNum)
    -- end
end

function CrossZhengBaRankLayer:refreshTableView()
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
    end
    self.tableView:reloadData()
end

function CrossZhengBaRankLayer.cellSizeForTable(table,idx)
    local self = table.logic
    return 48, 960
end

function CrossZhengBaRankLayer.numberOfCellsInTableView(table)
    local num = CrossZhengBaManager:getRankInfoSize()
    if num >= 3 then
        num = num - 3
    else
        num = 0
    end
    return num
end

function CrossZhengBaRankLayer.tableCellAtIndex(table, idx)
    local self = table.logic

    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.rank_cell_model:clone()
        panel:setPositionY(20)
        panel:setVisible(true)
        cell:addChild(panel)
        cell.panel = panel
    end
    cell.panel:setVisible(true) 
    local rankInfo = CrossZhengBaManager:getRankInfo(idx + 1 + 3)
    self:setPanelRankInfo(cell.panel, rankInfo, idx + 1 + 3)   
    return cell
end

function CrossZhengBaRankLayer:setPanelRankInfo(panel, rankInfo, rank)

    local txt_name = TFDirector:getChildByPath(panel, "txt_name")
    local txt_power = TFDirector:getChildByPath(panel, "txt_zhanli")
    local txt_ServerName = TFDirector:getChildByPath(panel, "txt_bangpai")
    local txt_rank = TFDirector:getChildByPath(panel, "txt_shunxu")
    local txt_dw = TFDirector:getChildByPath(panel, "txt_dw")
    local img_dw = TFDirector:getChildByPath(panel, "img_dw")
    local img_star = TFDirector:getChildByPath(panel, "img_star")
    local txt_star = TFDirector:getChildByPath(panel, "txt_star")

    if rankInfo ~= nil then
        txt_name:setText(rankInfo.name)
        txt_ServerName:setText(rankInfo.serverName)
        txt_power:setText(rankInfo.power)
        txt_rank:setText(rank)
        local itemData = CrossZhengBaManager:getData(rankInfo.grade)
        txt_dw:setText(itemData.name)
        img_dw:setTexture("ui_new/crosszhenba/" .. itemData.icon .. ".png")
        if rankInfo.star > 0 then
            img_star:setVisible(true)
            txt_star:setVisible(true)
            txt_star:setText("x" .. rankInfo.star)
            local posX = txt_dw:getPositionX() + txt_dw:getContentSize().width
            img_star:setPositionX(posX)
            posX = posX + img_star:getContentSize().width * img_star:getScale()
            txt_star:setPositionX(posX)
        else
            img_star:setVisible(false)
            txt_star:setVisible(false)
        end
        local serverId = math.floor(rankInfo.playerId)
        serverId = math.floor(serverId/131072)
        if CrossZhengBaManager:getRankServerSwitchStatue() == true then
            Public:addInfoListen(panel,true,11,rankInfo.playerId,serverId)
        end
    else
        Public:addInfoListen(panel,false)
        txt_name:setText("")
        txt_power:setText("")
        txt_ServerName:setText("")
        txt_rank:setText("")
        txt_dw:setText("")
        img_dw:setVisible(false)
        img_star:setVisible(false)
        txt_star:setText("")
    end
      
end

function CrossZhengBaRankLayer:CreateArmature(roleID)
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
    -- GameResourceManager:addRole( roleID, armature)

    self.armatureList[roleID] = armature
    armature:retain()
    return armature
end

function CrossZhengBaRankLayer:AddRoleFootEffect(roleArmature)
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role.xml")
    local effect = TFArmature:create("main_role_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        roleArmature:addChild(effect)
    end

    -- TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role2.xml")
    -- local effect2 = TFArmature:create("main_role2_anim")
    -- if effect2 ~= nil then
    --     effect2:setAnimationFps(GameConfig.ANIM_FPS)
    --     effect2:playByIndex(0, -1, -1, 1)
    --     effect2:setZOrder(-1)
    --     effect2:setPosition(ccp(0, -10))
    --     roleArmature:addChild(effect2)
    -- end
end

function CrossZhengBaRankLayer:RemoveNoUseArmature()
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

function CrossZhengBaRankLayer:IsUsedArmature(roleID)
    local roleList = CardRoleManager:getUsedCardList()
    local roleNum = roleList:length()
    for i=1,roleNum do
        local cardRole = roleList:getObjectAt(i)
        if cardRole ~= nil and cardRole.id == roleID then
            return true
        end
    end
    local challengeList = CrossZhengBaManager:getChallengeInfo()
    for i,v in ipairs(challengeList) do
        if roleID == v.useIcon then
            return true
        end
    end
    return false
end

function CrossZhengBaRankLayer:showTopThree()
    local scaleXList = {1,-0.9,0.9}
    local scaleYList = {1,0.9,0.9}
    local posYList = {90,80,80}
    for i = 1,3 do
        local rankInfo = CrossZhengBaManager:getRankInfo(i)
        if rankInfo then
            self.panel_role_list[i]:setVisible(true)
            if rankInfo.useIcon == nil or rankInfo.useIcon == 0 then
                rankInfo.useIcon = 77
            end
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
                pos.y = pos.y - posYList[i]
                armature:setPosition(pos)
                armature:setName("armature")
                armature:play("stand", -1, -1, 1)
                armature:setScaleX(scaleXList[i])
                armature:setScaleY(scaleYList[i])
                self:AddRoleFootEffect(armature)
            end
            if armature then
                self.panel_role_list[i].armature = armature
            end
            self.panel_role_list[i].img_role:setVisible(false)
            self.panel_role_list[i].panel_role:setTouchEnabled(true)
            local serverId = math.floor(rankInfo.playerId)
            serverId = math.floor(serverId/131072)
            if CrossZhengBaManager:getRankServerSwitchStatue() == true then
                Public:addInfoListen(self.panel_role_list[i].panel_role,true,11,rankInfo.playerId,serverId)
            end
			serverId = math.mod(serverId,1000)
            self.panel_role_list[i].txt_name:setText('S' .. serverId .. rankInfo.name)
            self.panel_role_list[i].txt_power:setText('' .. rankInfo.power)
            self.panel_role_list[i].txt_dj:setText(stringUtils.format(localizable.common_LV,rankInfo.level))
            local path = CrossZhengBaManager:getGradeImg(rankInfo.grade)
            self.panel_role_list[i].img_dw:setTexture(path)
            self.panel_role_list[i].txt_no:setText("X" .. rankInfo.star)

            local path = CrossZhengBaManager:getGradeLevelTag(rankInfo.grade)
            if path and path ~= "" then
                self.panel_role_list[i].img_level:setVisible(true)
                self.panel_role_list[i].img_level:setTexture(path)
                self.panel_role_list[i].img_heidi:setVisible(true)
            else
                self.panel_role_list[i].img_level:setVisible(false)
                self.panel_role_list[i].img_heidi:setVisible(false)
            end
        else
            self.panel_role_list[i]:setVisible(false)
        end
    end
end

function CrossZhengBaRankLayer:removeUI()
    self.super.removeUI(self)
    if self.rank_cell_model then
        self.rank_cell_model:release()
        self.rank_cell_model = nil
    end
    self:RemoveNoUseArmature()
end

function CrossZhengBaRankLayer:registerEvents()
	self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);

    -- self.thumbTimesBrushCallBack = function (event)
    --     local resType = event.data[1]
    -- end
    -- TFDirector:addMEGlobalListener(MainPlayer.ChallengeTimesChange,self.thumbTimesBrushCallBack)
end

function CrossZhengBaRankLayer:removeEvents()

    -- TFDirector:removeMEGlobalListener(MainPlayer.ChallengeTimesChange,self.thumbTimesBrushCallBack)

    self.super.removeEvents(self)
end

return CrossZhengBaRankLayer
