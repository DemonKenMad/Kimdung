-- client side BiaoCheHistoryLayer.lua
--[[
 * @Description: 开车界面
 ]]
-- script writer chikui


local BiaoCheHistoryLayer = class("BiaoCheHistoryLayer",BaseLayer)

function BiaoCheHistoryLayer:ctor(data)

    self.super.ctor(self, data)
    self:init("lua.uiconfig_mango_new.faction.BiaocheMain")
end

function BiaoCheHistoryLayer:initUI( ui )

    self.super.initUI(self, ui)
    self.generalHead = CommonManager:addGeneralHead( self )
    self.generalHead:setData(ModuleType.BiaoChe,{HeadResType.SYCEE})
    ViewSizeCheck(TFDirector:getChildByPath(ui,'bg'))

    self.txt_tips1 = TFDirector:getChildByPath(ui, 'txt_tips1')
    self.btn_reward = TFDirector:getChildByPath(ui, 'btn_guizhe')
    self.btn_rule = TFDirector:getChildByPath(ui, 'btn_jiangli')

    self.panel_best_list = {}
    local panel_name = {'panel_gj','panel_yj','panel_jj','panel_bf'}
    local factionList = {}
    for i=1,4 do
        factionList[i] = {}
        local rootNode = TFDirector:getChildByPath(ui, panel_name[i])
        factionList[i].rootNode = rootNode
        factionList[i].txt_name = TFDirector:getChildByPath(rootNode, 'txt_name')
        factionList[i].txt_serverName = TFDirector:getChildByPath(rootNode, 'txt_fwq')
        factionList[i].img_flag = TFDirector:getChildByPath(rootNode, 'img_qizhi')
        factionList[i].img_tag = TFDirector:getChildByPath(rootNode, 'img_biaozhi')
        factionList[i].txt_rank = TFDirector:getChildByPath(rootNode, 'txt_paiming')
    end
    self.panel_best_list[1] = factionList

    local role_name = {'role1_bg','role2_bg','role3_bg','role_bf'}
    local roleList = {}
    for i=1,4 do
        roleList[i] = {}
        local rootNode = TFDirector:getChildByPath(ui, role_name[i])
        roleList[i].rootNode = rootNode
        roleList[i].txt_name = TFDirector:getChildByPath(rootNode, 'txt_servername')
        roleList[i].txt_name:setText("")
        roleList[i].txt_factionname = TFDirector:getChildByPath(rootNode, 'txt_factionname')
        roleList[i].txt_fn_pos = roleList[i].txt_factionname:getPositionX()
        roleList[i].txt_killnumber = TFDirector:getChildByPath(rootNode, 'txt_killnumber')
    end
    self.panel_best_list[2] = roleList

    self.panel_myInfo = TFDirector:getChildByPath(ui, 'panel_myInfo')
    self.txt_guildRank = TFDirector:getChildByPath(self.panel_myInfo, 'txt_pmnumber')
    self.txt_killRank = TFDirector:getChildByPath(self.panel_myInfo, 'txt_num1')
end

function BiaoCheHistoryLayer:removeUI()
    self.super.removeUI(self)
end

function BiaoCheHistoryLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow();
    self:refreshUI()
end

function BiaoCheHistoryLayer:refreshUI()
    self:refreshFactionInfo()
    self:refreshRoleInfo()
    self:refreshMyInfo()
    self:setNextTime()
end

function BiaoCheHistoryLayer:refreshFactionInfo()
    local rankList = BiaoCheManager:getHistoryRankInfo(BiaoCheManager.RankType_1)
    local nodeList = self.panel_best_list[1]
    for i=1,3 do
        local rankInfo = rankList[i]
        local node = nodeList[i]
        if rankInfo then
            node.rootNode:setVisible(true)
            node.txt_name:setText(rankInfo.guildName)
            node.txt_serverName:setText(rankInfo.serverName)
            local strBannerInfo = rankInfo.cardInfo.bannerId
            node.img_flag:setTexture(FactionManager:getGuildBannerBgPath(strBannerInfo))
            node.img_tag:setTexture(FactionManager:getGuildBannerIconPath(strBannerInfo))
        else
            node.rootNode:setVisible(true)
            node.txt_name:setText(localizable.common_wait)
            node.txt_serverName:setText("")
            local strBannerInfo = nil
            node.img_flag:setTexture(FactionManager:getGuildBannerBgPath(strBannerInfo))
            node.img_tag:setTexture(FactionManager:getGuildBannerIconPath(strBannerInfo))
        end
    end

    local serverBestNode = nodeList[4]
    local rankInfo = BiaoCheManager:getServerBestRankInfo(BiaoCheManager.RankType_1)
    if rankInfo == nil or rankInfo.rank <= 0 then
        serverBestNode.txt_rank:setText("")
        serverBestNode.txt_name:setText(localizable.common_wait)
        serverBestNode.img_flag:setTexture(FactionManager:getGuildBannerBgPath(nil))
        serverBestNode.img_tag:setTexture(FactionManager:getGuildBannerIconPath(nil))
    else
        serverBestNode.txt_name:setText(rankInfo.guildName)
        serverBestNode.txt_rank:setText(stringUtils.format(localizable.multiFight_myRank,rankInfo.rank))
        local strBannerInfo = rankInfo.bannerId
        serverBestNode.img_flag:setTexture(FactionManager:getGuildBannerBgPath(strBannerInfo))
        serverBestNode.img_tag:setTexture(FactionManager:getGuildBannerIconPath(strBannerInfo))
    end
end

function BiaoCheHistoryLayer:refreshRoleInfo()
    local rankList = BiaoCheManager:getHistoryRankInfo(BiaoCheManager.RankType_2)
    local nodeList = self.panel_best_list[2]
    for i=1,3 do
        local rankInfo = rankList[i]
        local node = nodeList[i]
        if rankInfo then
            -- print("getServerBestRankInfo = ",rankInfo)
            node.rootNode:setVisible(true)
            node.txt_name:setText(rankInfo.playerName)
            node.txt_factionname:setText(stringUtils.format(localizable.friendInfoLayer_faction,rankInfo.guildName))
            node.txt_factionname:setPositionX(node.txt_fn_pos)
            node.txt_killnumber:setText(localizable.BiaocheHistorylayer_jipo ..  rankInfo.killCount)
        else
            node.txt_name:setText("")
            node.txt_factionname:setText(localizable.common_wait)
            node.txt_factionname:setPositionX(node.txt_fn_pos + 32)
            node.txt_killnumber:setText("")
        end
    end
    local node = nodeList[4]
    local rankInfo = BiaoCheManager:getServerBestRankInfo(BiaoCheManager.RankType_2)
    -- print("getServerBestRankInfo = ",rankInfo)
    if rankInfo == nil or rankInfo.rank <= 0 then
        node.txt_name:setText("")
        node.txt_factionname:setText(localizable.common_wait)
        node.txt_factionname:setPositionX(node.txt_fn_pos + 32)
        node.txt_killnumber:setText("")
    else
        node.txt_name:setText(rankInfo.playerName)
        node.txt_factionname:setText(stringUtils.format(localizable.friendInfoLayer_faction,rankInfo.guildName))
        node.txt_factionname:setPositionX(node.txt_fn_pos)
        node.txt_killnumber:setText(localizable.BiaocheHistorylayer_jipo ..  rankInfo.lastScore)
    end
end

function BiaoCheHistoryLayer:refreshMyInfo()
    local guildRankInfo = BiaoCheManager:getMyHistoryRankInfo(BiaoCheManager.RankType_1)
    if guildRankInfo and guildRankInfo.rank > 0 then
        self.txt_guildRank:setText(guildRankInfo.rank)
    else
        self.txt_guildRank:setText(localizable.shalu_info_txt1)
    end
    
    local killRankInfo = BiaoCheManager:getMyHistoryRankInfo(BiaoCheManager.RankType_2)
    if killRankInfo and killRankInfo.rank > 0 then
        self.txt_killRank:setText(stringUtils.format(localizable.multiFight_myRank,killRankInfo.rank))
    else
        self.txt_killRank:setText(localizable.shalu_info_txt1)
    end
end

function BiaoCheHistoryLayer:setNextTime()
    local timeNow = MainPlayer:getNowtime()
    local tTime = GetCorrectDate("*t",timeNow)
    print("tTime = ",tTime)
    local weakday = tTime.wday
    if weakday == 1 then
        weakday = 8
    end
    weakday = 5 - (weakday - 1) + 7
    weakday = math.mod(weakday,7)
    if weakday == 0 and tTime.hour > 10 then
        weakday = 7
    end
    timeNow = timeNow + weakday * 24 * 3600
    tTime = GetCorrectDate("*t",timeNow)
    self.txt_tips1:setText(stringUtils.format(localizable.BiaoCheBaoNextTime_txt,tTime.month,tTime.day))
end

function BiaoCheHistoryLayer.onRuleClick( sender )
    CommonManager:showRuleLyaer('biaoxingtianxia1')
end

function BiaoCheHistoryLayer.onRewardClick( sender )
    BiaoCheManager:openRewardLayer() 
end

function BiaoCheHistoryLayer:registerEvents()
    self.super.registerEvents(self)
    self.btn_rule:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRuleClick))
    self.btn_reward:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onRewardClick))
    if self.generalHead then
        self.generalHead:registerEvents()
    end
end

function BiaoCheHistoryLayer:removeEvents()
    if self.generalHead then
        self.generalHead:removeEvents()
    end
    self.super.removeEvents(self)
end

return BiaoCheHistoryLayer