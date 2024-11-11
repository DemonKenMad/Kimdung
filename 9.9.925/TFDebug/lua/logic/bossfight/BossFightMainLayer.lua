local BossFightMainLayer = class("BossFightMainLayer", BaseLayer)

CREATE_SCENE_FUN(BossFightMainLayer)
CREATE_PANEL_FUN(BossFightMainLayer)

local tex_p1 = {"ui_new/demond/tab1_d.png", "ui_new/demond/tab1_u.png"}
local tex_p2 = {"ui_new/demond/tab2_u.png", "ui_new/demond/tab2_d.png"}

function BossFightMainLayer:ctor(data)
    self.super.ctor(self,data)
    
    self:init("lua.uiconfig_mango_new.demond.DemondMainLayer")
    self.selectIndex = 1
end

function BossFightMainLayer:dispose()
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end

    self.super.dispose(self)
end

function BossFightMainLayer:onShow()
    self.super.onShow(self)
    if self.generalHead then
        self.generalHead:onShow()
    end
    self:refreshBaseUI()
    self:refreshUI()
end

function BossFightMainLayer:refreshBaseUI()

end

function BossFightMainLayer:refreshUI()
    if not self.isShow then
        return
    end

    local bossInfo = BossFightManager:getBossFightInfo()
    -- boss id 不一样了
    if self.bossId ~= bossInfo.boss_id then
        if self.boosEffect then
            self.boosEffect:removeFromParentAndCleanup(true)
            self.boosEffect = nil
        end

        local bossInfo = BossFightManager:getBossFightInfo()
        self.img_info:setTexture("ui_new/demond/"..bossInfo.imgdesc)
    end
    self.bossId = bossInfo.boss_id

    -- BossFightManager:getBossFightTotalInfo()
    self:drawFightInfo()
    self:drawFightRank()
    self:drawFightReward()
    BossFightManager:requestBossDieCount()

    local data = BossFightManager:getBossFightInfo()
    self.txt_RewardTime:setText( stringUtils.format(localizable.fumo_reward_time, data.settlement_time) )

    self:refreshPageInfo()
end

function BossFightMainLayer:initUI(ui)
    self.super.initUI(self,ui)
    -- self.btn_close      = TFDirector:getChildByPath(ui, 'btn_close')
    self.btn_rule = TFDirector:getChildByPath(ui, 'Btn_guizhe')

    self.btn_fight       = TFDirector:getChildByPath(ui, 'Btn_star')
    self.btn_rank        = TFDirector:getChildByPath(ui, 'Btn_paihangbang')

    self.txt_timesinfo      = TFDirector:getChildByPath(ui, 'txt_timesinfo')
    self.txt_times          = TFDirector:getChildByPath(ui, 'txt_times')
    self.txt_bettleinfo     = TFDirector:getChildByPath(ui, 'txt_bettleinfo')


    self.txt_myRank         = TFDirector:getChildByPath(ui, 'txt_myRank')
    -- 今日总伤害
    self.txt_damage         = TFDirector:getChildByPath(ui, 'txt_damage') 
    self.txt_Reward         = TFDirector:getChildByPath(ui, 'txt_Reward')
    self.txt_RewardTime     = TFDirector:getChildByPath(ui, 'txt_Rewardinfo')
    self.txt_damage2        = TFDirector:getChildByPath(ui, 'txt_damage2')

    self.img_info       = TFDirector:getChildByPath(ui, 'Info')

    -- img_no1
    self.rankNodeList = {}
    for i=1,3 do
        self.rankNodeList[i] = {}
        self.rankNodeList[i].img_rank = TFDirector:getChildByPath(ui, 'img_no'..i)
        self.rankNodeList[i].txt_name = TFDirector:getChildByPath(ui, 'txt_no'..i)
    end

    self.rewardNodeList = {}
    for i=1,2 do
        self.rewardNodeList[i] = {}
        self.rewardNodeList[i].txt_reward = TFDirector:getChildByPath(ui, 'txt_Reward'..i)
    end

    self.generalHead = CommonManager:addGeneralHead( self )

    self.generalHead:setData(ModuleType.BossFight,{HeadResType.COIN,HeadResType.SYCEE})


    self.txt_weirubang =  TFDirector:getChildByPath(ui, 'txt_weirubang')


    -- self.img_info:setVisible(false)

    local bossInfo = BossFightManager:getBossFightInfo()
    print("bossInfo.desc = ", bossInfo.imgdesc)
    self.img_info:setTexture("ui_new/demond/"..bossInfo.imgdesc)

    self.bossId = bossInfo.boss_id

    self.txt_duanshu = TFDirector:getChildByPath(ui, "txt_duanshu")
    self.img_duanshubg = TFDirector:getChildByPath(ui, "img_duanshubg")
    self.txt_bossjieduan = TFDirector:getChildByPath(ui, "txt_bossjieduan")

    self.Panel_shanghai = TFDirector:getChildByPath(ui, "Panel_shanghai")
    self.Panel_jieduanjisha = TFDirector:getChildByPath(ui, "Panel_jieduanjisha")
    self.Btn_paihangbang = TFDirector:getChildByPath(self.Panel_jieduanjisha, "Btn_paihangbang")
    self.Btn_paihangbang.logic = self

    self.btn_shanghai = TFDirector:getChildByPath(ui, "btn_shanghai")
    self.btn_gejieduan = TFDirector:getChildByPath(ui, "btn_gejieduan")
    self.btn_shanghai.logic = self
    self.btn_gejieduan.logic = self

    self.panel_list = TFDirector:getChildByPath(self.Panel_jieduanjisha, "Panel_shoushengzhe")
    self.cellModel = TFDirector:getChildByPath(self.panel_list, "txt_jisha")
    self.cellModel:setVisible(true)
    self.cellModel:retain()
    self.cellModel:removeFromParent()
end

--填充主页信息
function BossFightMainLayer:loadHomeInfo()

end


function BossFightMainLayer.onGoClickHandle(sender)
    local self = sender.logic

    -- -- local openLevel = 13
    -- -- local guideInfo = PlayerGuideData:objectByID(1601)
    -- -- if guideInfo then
    -- --     openLevel = guideInfo.open_lev
    -- -- end

    -- -- local openLevel = PlayerGuideManager:GetBloodFightOpenLevel()
    -- local openLevel = FunctionOpenConfigure:getOpenLevel(501)
    -- if MainPlayer:getLevel() < openLevel then
    --     toastMessage("血战将在"..openLevel.."级开放")
    --     return
    -- end

    toastMessage("11111111111")
    -- BloodFightManager:EnterBlood()
end

function BossFightMainLayer:removeUI()
    self.super.removeUI(self)

end

function BossFightMainLayer:registerEvents()
    self.super.registerEvents(self)

    self.btn_rule.logic    = self   
    self.btn_rule:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRuleClickHandle),1)

    self.btn_fight.logic    = self   
    self.btn_fight:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onFightClickHandle),1)

    self.btn_rank.logic    = self   
    self.btn_rank:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRankClickHandle),1)

    self.btn_shanghai:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onPageClick1),1)
    self.btn_gejieduan:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onPageClick2),1)

    self.Btn_paihangbang:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onServerRankClickHandle),1)

    if self.generalHead then
        self.generalHead:registerEvents()
    end

    self.updateDaily = function(event)
        print("boss fight 到点更新了")
        if self.boosEffect then
            self.boosEffect:removeFromParentAndCleanup(true)
            self.boosEffect = nil
        end

        local bossInfo = BossFightManager:getBossFightInfo()
        self.img_info:setTexture("ui_new/demond/"..bossInfo.imgdesc)

        self:refreshUI() 
    end

    TFDirector:addMEGlobalListener(BossFightManager.UPDATEDAILY, self.updateDaily)

    self.updateBossDieCount = function(event)
        local count = BossFightManager:getBossDieCount()
        count = count + 1
        local str = stringUtils.format(localizable.fumo_boss_jieduan, numberToChinese( count ))

        if not self.txt_duanshu then
            self.txt_duanshu = TFDirector:getChildByPath(self.ui, "txt_duanshu")
        end
        self.txt_duanshu:setText(str)
    end

    TFDirector:addMEGlobalListener(BossFightManager.GAIN_BOSS_DIE_RESP, self.updateBossDieCount)

    self.updateJieduanInfo = function(event)
        --self:refreshUI()
        self:refreshPage2()
    end

    TFDirector:addMEGlobalListener(BossFightManager.WORLD_BOSS_RANK, self.updateJieduanInfo)
end

function BossFightMainLayer:removeEvents()
    self.super.removeEvents(self)

    if self.generalHead then
        self.generalHead:removeEvents()
    end

    TFDirector:removeMEGlobalListener(BossFightManager.UPDATEDAILY, self.updateDaily)
    self.updateDaily = nil

    TFDirector:removeMEGlobalListener(BossFightManager.GAIN_BOSS_DIE_RESP, self.updateBossDieCount)
    self.updateBossDieCount = nil

    TFDirector:removeMEGlobalListener(BossFightManager.WORLD_BOSS_RANK, self.updateJieduanInfo)
    self.updateJieduanInfo = nil
end

--伤害排名
function BossFightMainLayer.onPageClick1(sender)
    local self = sender.logic
    self:selectPage(1)
end

--阶段首胜
function BossFightMainLayer.onPageClick2(sender)
    local self = sender.logic
    self:selectPage(2)
end

function BossFightMainLayer:selectPage(index)
    if index == 1 then
        self:selectPage1()
    elseif index == 2 then
        self:selectPage2()
    end
end

function BossFightMainLayer:selectPage1()
    self.Panel_shanghai:setVisible(true)
    self.Panel_jieduanjisha:setVisible(false)
    self.btn_shanghai:setTextureNormal(tex_p1[2])
    self.btn_gejieduan:setTextureNormal(tex_p2[1])
    self.selectIndex = 1
end

function BossFightMainLayer:selectPage2()
    self.Panel_shanghai:setVisible(false)
    self.Panel_jieduanjisha:setVisible(true)
    self.btn_shanghai:setTextureNormal(tex_p1[1])
    self.btn_gejieduan:setTextureNormal(tex_p2[2])
    
    self.selectIndex = 2
end

function BossFightMainLayer:refreshPageInfo()
    self.Panel_shanghai:setVisible(false)
    self.Panel_jieduanjisha:setVisible(false)

    self:refreshPage1()
    self:refreshPage2()
    self:selectPage(self.selectIndex)
end

function BossFightMainLayer:refreshPage1()
    for i=1,3 do
        self.rankNodeList[i].img_rank:setVisible(false)
        self.rankNodeList[i].txt_name:setVisible(false)
    end

    local rankInfo = BossFightManager:getBossFightRankInfo()

    local rankList = rankInfo.rankInfo
    if not rankList then
        return
    end

    for i=1,3 do
        local item = rankList[i]
        if item then
            self.rankNodeList[i].img_rank:setVisible(true)
            self.rankNodeList[i].txt_name:setVisible(true)

            self.rankNodeList[i].txt_name:setText(item.name)
        end
    end
end

function BossFightMainLayer:refreshPage2()
    if self.tableView then
        self.tableView:reloadData()
        return
    end
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
    Public:bindScrollFun(self.tableView)
    self.tableView:reloadData()
end

function BossFightMainLayer.cellSizeForTable(table, idx)
    return 30, 270
end

function BossFightMainLayer.numberOfCellsInTableView(table)
    return #BossFightManager:getJieduanInfo()
end

function BossFightMainLayer.tableCellAtIndex(table, idx)
    local self = table.logic

    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.cellModel:clone()
        panel:setPosition(ccp(144, 0))
        panel:setVisible(true)
        cell:addChild(panel)
        cell.panel = panel
    end

    local temp = BossFightManager:getJieduanInfo()
    local rankInfo = temp[idx + 1]
    cell.panel:setVisible(true) 
    self:setPanelRankInfo(cell.panel, rankInfo, idx + 1)
    
    return cell
end

function BossFightMainLayer:setPanelRankInfo(panel, rankInfo, rank)
    local id = rankInfo.id
    local name = rankInfo.name

    local txt_jisha = panel
    local txt_name = TFDirector:getChildByPath(panel, "txt_no1")
    txt_jisha:setText( stringUtils.format(localizable.fumo_txt_shoushengzhe, numberToChinese(id)) )
    txt_name:setText(name)
end

function BossFightMainLayer.onServerRankClickHandle(sender)
    local self = sender.logic
    local info = BossFightManager:getBossFightInfo()
    BossFightManager:requestCrossRank(info.id)
end

function BossFightMainLayer.onRuleClickHandle(sender)
    -- local layer = AlertManager:addLayerByFile("lua.logic.bossfight.BossFightRuleLayer", AlertManager.BLOCK_AND_GRAY_CLOSE, AlertManager.TWEEN_1)

    -- AlertManager:show()

    CommonManager:showRuleLyaer("fumolu")
end

function BossFightMainLayer.onFightClickHandle(sender)

    local self = sender.logic

    -- 
    if BossFightManager:isBossFightOpen() == false then

        --toastMessage("伏魔录已关闭！")
        toastMessage(localizable.bossFightMainLayer_close)
        return
    end
    -- 

    local layer = AlertManager:addLayerByFile("lua.logic.bossfight.BossFightArmyVSLayer", AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1)
    -- layer:setBossId(5)
    -- BossFightManager:getBossFightInfo()
    layer:setBossData(BossFightManager:getBossFightInfo())
    AlertManager:show()
end


function BossFightMainLayer.onRankClickHandle(sender)

    local self = sender.logic

    BossFightManager:enterBossRank()
end


function BossFightMainLayer:drawFightInfo()
    -- self.txt_times  
    local bossData = BossFightManager:getBossFightInfo()
    print("bossData.max_times = ", bossData.max_times)
    print("BossFightManager.bossFightInfo.todayTimes = ", BossFightManager.bossFightInfo.todayTimes)
    
    self.txt_times:setText(bossData.max_times - BossFightManager.bossFightInfo.todayTimes)

    local effectPath = bossData.effect
    local x = bossData.effectx
    local y = bossData.effecty
    -- effect_boss1
    if self.boosEffect == nil then
        -- TFResourceHelper:instance():addArmatureFromJsonFile("effect/effect_boss1.xml")
        -- local effect = TFArmature:create("effect_boss1_anim")
        TFResourceHelper:instance():addArmatureFromJsonFile(effectPath..".xml")
        local tbl = stringToTable(effectPath,"/")
        effectName = tbl[#tbl]
        local effect = TFArmature:create(effectName.."_anim")

        effect:setAnimationFps(GameConfig.ANIM_FPS)
        if bossData.effect_name and bossData.effect_name ~= "" then
            effect:play(bossData.effect_name, -1, -1, 1)
        else
            effect:playByIndex(0, -1, -1, 1)
        end
        -- self.btn_qxkl:addChild(effect , 100)
        self:addChild(effect , 100)
        -- effect:setPosition(ccp(262+270+40, 110+139+82))
        print("x = ", x)
        print("y = ", y)
        effect:setPosition(ccp(x, y))
        self.boosEffect = effect
    end
end

function BossFightMainLayer:drawFightRank()
    local rankInfo = BossFightManager:getBossFightRankInfo()

    local rankList = rankInfo.rankInfo
    -- myRanking
    -- 我的排名
    self.txt_myRank:setVisible(true)
    self.txt_myRank:setText(rankInfo.myRanking)
    if rankInfo.myRanking == 0 then
        -- self.txt_myRank:setVisible(false)
        -- self.rewardNodeList[1].txt_reward:setText("今日未挑战")
    end

    -- 今日总伤害
    self.txt_damage:setText(rankInfo.myBestValue)


    if rankInfo.myRanking == 1 then
        --self.txt_damage2:setText("您已到达第一名")
        self.txt_damage2:setText(localizable.bossFightMainLayer_first)
    else
        -- 差多少入
        if rankInfo.betterRewardValue == 0 then
            --self.txt_damage2:setText("0伤害")
            self.txt_damage2:setText(stringUtils.format(localizable.bossFightMainLayer_hurt,0))

        else
            local HurtGap = rankInfo.betterRewardValue - rankInfo.myBestValue
            self.txt_damage2:setText(stringUtils.format(localizable.bossFightMainLayer_hurt,HurtGap))
        end
    end
    self.myRank = rankInfo.myRanking

    -- 今日未入榜
    if rankInfo.myRanking == 0 then
        self.txt_weirubang:setVisible(true)
        self.txt_myRank:setVisible(false)
        
    -- 今日入榜
    else
        self.txt_weirubang:setVisible(false)
        self.txt_myRank:setVisible(true)
    end

    if rankInfo.myBestValue == 0 then
        self.txt_myRank:setVisible(false)
        --self.rewardNodeList[1].txt_reward:setText("今日未挑战")
        --self.txt_damage2:setText("今日未挑战")
        self.rewardNodeList[1].txt_reward:setText(localizable.bossFightMainLayer_no_fight)
        self.txt_damage2:setText(localizable.bossFightMainLayer_no_fight)
    else
        if rankInfo.myRanking == 0 then
            -- self.txt_myRank:setVisible(false)
            -- self.rewardNodeList[1].txt_reward:setText("今日未入榜")
            -- self.txt_myRank:setText("今日未入榜")
        end
    end
end

function BossFightMainLayer:drawFightReward()
    local reward_id = 0

    -- local BossFightRewardConfig = require("lua.table.t_s_boss_battle_reward")

    -- for v in BossFightRewardConfig:iterator() do
    --     if v.min_pos <= self.myRank and self.myRank <= v.min_pos then
    --         reward_id = v.reward_id
    --     end
    -- end

    -- if reward_id == 0 then
    local rankInfo = BossFightManager:getBossFightRankInfo()


    reward_id = BossFightManager:getRankRewards(self.myRank)
    if reward_id == 0 or rankInfo.myBestValue == 0 then
        print("排名找不到对应的奖励 self.myRank = ", self.myRank)

        self.rewardNodeList[2].txt_reward:setVisible(false)

        return
    end

    print("排名对应的奖励 reward_id = ", reward_id)

    local itemList = RewardConfigureData:GetRewardItemListById(reward_id)


    -- 绘制奖励
    if itemList then
        for index=1,2 do
        -- for v in itemList:iterator() do
            -- local rewardItem = v
            local rewardItem = itemList:objectAt(index)
            if rewardItem == nil then
                return
            end

            local itemInfo  = BaseDataManager:getReward(rewardItem)

            -- print("itemInfo = ", itemInfo)
            local content = itemInfo.name .. "X" .. itemInfo.number
            self.rewardNodeList[index].txt_reward:setText(content)

            self.rewardNodeList[index].txt_reward:setVisible(true)
        end

    end
end



return BossFightMainLayer
