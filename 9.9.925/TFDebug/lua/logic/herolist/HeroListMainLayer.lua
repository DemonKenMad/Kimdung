local HeroListMainLayer = class("HeroListMainLayer", BaseLayer);

CREATE_SCENE_FUN(HeroListMainLayer);
CREATE_PANEL_FUN(HeroListMainLayer);

--[[
英雄志
]]
HeroListMainLayer.TEXTURE_HISTORY = "ui_new/spectrum/herolist/img_tsdl.png"
function HeroListMainLayer:ctor(data)
    self.super.ctor(self,data);
    
    self:init("lua.uiconfig_mango_new.herolist.HeroListMain");
end


function HeroListMainLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow();
    self:refreshUI();
end


function HeroListMainLayer:initUI(ui)
    self.super.initUI(self,ui);
    self.generalHead = CommonManager:addGeneralHead(self)

    self.generalHead:setData(ModuleType.HeroList,{HeadResType.PUSH_MAP,HeadResType.COIN,HeadResType.SYCEE})
    self.bg             = TFDirector:getChildByPath(ui, "bg")
    ViewSizeCheck(self.bg)
    self.Boss               = TFDirector:getChildByPath(ui, "panel_boss") 
    self.panel_xinxi        = TFDirector:getChildByPath(ui, "panel_xinxi") 
    self.Info               = TFDirector:getChildByPath(self.panel_xinxi, "Info") 
    self.panel_name         = TFDirector:getChildByPath(ui, "panel_name") 
    --左边tableview
    self.view               = TFDirector:getChildByPath(ui, "panel_button") 
    self.view:retain()
    self.view:removeFromParent()
    --右边奖励
    self.panel_reward       = TFDirector:getChildByPath(ui, "panel_reward") 
    --选中table表
    self.xztypeClick = {}

    self.txt_cishu          = TFDirector:getChildByPath(ui, "txt_cishu")
    self.txt_cishu2          = TFDirector:getChildByPath(ui, "txt_cishu2")
    self.btn_buy          = TFDirector:getChildByPath(ui, "btn_buy")
    self.btn_buy.logic = self
    self.btn_jia            = TFDirector:getChildByPath(ui, "btn_jia")
    self.Btn_guizhe          = TFDirector:getChildByPath(ui, "Btn_guizhe")
    self.Btn_guizhe:setVisible(false)
    self.Btn_guizhe.logic = self
    self.txt_num            = TFDirector:getChildByPath(ui, "txt_num")
    self.txt_xxxxx           = TFDirector:getChildByPath(ui, "txt_xxxxx")
    self.txt_xxxxx:setText(localizable.replayLayer_tips4)
    

    self.rewardList = HeroListManager.rewardList
    --选择
    self.index = HeroListManager.LastBoss
    --开启关卡个数
    self.beginnum = HeroListManager.OpenBoss
    self.bqPath = {"ui_new/spectrum/herolist/img_tz5.png", "ui_new/spectrum/herolist/img_tz2.png", "ui_new/spectrum/herolist/img_tz1.png", "ui_new/spectrum/herolist/img_tz4.png","ui_new/spectrum/herolist/img_tz3.png"}
end

function HeroListMainLayer:refreshUI()
    self.index = HeroListManager.LastBoss
    self.beginnum = HeroListManager.OpenBoss
    self:refreshReward()
    self:refreshTabelView()
    self:refreshBoss()  
    self.xztypeClick[self.index]:setVisible(true)
    self.txt_cishu:setText(HeroListManager.residualCount.."/")
    self.txt_cishu2:setText(HeroListManager.MaxFreeNum)
    if HeroListManager.PurchasedNum == HeroListManager.MaxPurchaseNum then
        self.btn_jia:setGrayEnabled(true)
        self.btn_jia:setTouchEnabled(false)
    else
        self.btn_jia:setGrayEnabled(false)
        self.btn_jia:setTouchEnabled(true)
    end

    if HeroListManager.challengeCount >=  HeroListManager.MaxNum then
        self.btn_buy:setGrayEnabled(true)
        self.btn_buy:setTouchEnabled(false)
    else
        self.btn_buy:setGrayEnabled(false)
        self.btn_buy:setTouchEnabled(true)
    end
end
    
function HeroListMainLayer:refreshReward()
    self.dropList  = TFArray:new();
    if self.rewardList[self.index].exp then
        local rewardInfo = {}
        rewardInfo.type = EnumDropType.EXP
        rewardInfo.number = math.floor(self.rewardList[self.index].exp * MainPlayer:getLevel())
        local _rewardInfo = BaseDataManager:getReward(rewardInfo)
        self.dropList:push(_rewardInfo);
    end
    if self.rewardList[self.index].money then
        local rewardInfo = {}
        rewardInfo.type = EnumDropType.COIN
        rewardInfo.number = math.floor(self.rewardList[self.index].money)
        local _rewardInfo = BaseDataManager:getReward(rewardInfo)
        self.dropList:push(_rewardInfo);
    end
    if self.rewardList[self.index].additional_drop then
        local rewardInfo = {}
        rewardInfo.type = EnumDropType.GOODS
        rewardInfo.number = 1
        rewardInfo.itemId = tonumber(self.rewardList[self.index].additional_drop)
        local _rewardInfo = BaseDataManager:getReward(rewardInfo)
        self.dropList:push(_rewardInfo);
    end
    local droplist = DropGroupData:GetDropItemListByIdsStr(self.rewardList[self.index].drop)--self.rewardList[self.index].drop
    for reward in droplist:iterator() do
        local rewardInfo = {}
        rewardInfo.type = EnumDropType.GOODS
        rewardInfo.itemId = reward.itemid
        rewardInfo.number = reward.number
        local _rewardInfo = BaseDataManager:getReward(rewardInfo)
        self.dropList:push(_rewardInfo);
    end
    self.txt_num:setText(self.rewardList[self.index].consume)
end

function HeroListMainLayer:refreshBoss()
    --Boss
    local armature = self:getArmature(self.rewardList[self.index].image);
    armature:setScale(1.4)
    armature:setPosition(ccp(170,80))
    -- self.Boss:removeAllChildrenWithCleanup(true);
    if self.Boss.armature ~= nil then
        self.Boss.armature:removeFromParent()
        self.Boss.armature = nil
    end

    self.Boss.armature = armature
    self.Boss:addChild(armature,1)
    if self.Bosseffect == nil then

        local resPath1 = "effect/HeroicBossDown.xml"
        local resPath2 = "effect/HeroicBossDown2.xml"
        local resPath3 = "effect/HeroicBossUp2.xml"
        local resPath4 = "effect/HeroicBossUp.xml"

        TFResourceHelper:instance():addArmatureFromJsonFile(resPath1)
        local effect = TFArmature:create("HeroicBossDown_anim")
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(160,130))
        -- effect:setZOrder(10000)
        self.Bosseffect = effect   
        self.Boss:addChild(effect)
        effect:playByIndex(0, -1, -1, 1)
        effect:setVisible(true)


        -- TFResourceHelper:instance():addArmatureFromJsonFile(resPath2)
        -- effect = TFArmature:create("HeroicBossDown2_anim")
    
        -- effect:setAnimationFps(GameConfig.ANIM_FPS)
        -- effect:setPosition(ccp(150,100))
        -- -- effect:setZOrder(10000)
        -- effect:setVisible(true)
        -- self.BosseffectDown= effect    
        -- self.BosseffectDown:playByIndex(0, -1, -1, 1)
        -- self.Boss:addChild(effect)

        -- TFResourceHelper:instance():addArmatureFromJsonFile(resPath3)
        -- effect = TFArmature:create("HeroicBossUp2_anim")
    
        -- effect:setAnimationFps(GameConfig.ANIM_FPS)
        -- effect:setPosition(ccp(180,200))
        -- effect:setVisible(true)
        -- -- effect:setZOrder(10000)
        -- self.BosseffectUp = effect    
        -- self.BosseffectUp:playByIndex(0, -1, -1, 1)
        -- self.Boss:addChild(effect)

        TFResourceHelper:instance():addArmatureFromJsonFile(resPath4)
        effect = TFArmature:create("HeroicBossUp_anim")
    
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:setPosition(ccp(180,110))
        effect:setVisible(true)
        effect:setZOrder(10000)
        self.BosseffectUp2 = effect    
        self.BosseffectUp2:playByIndex(0, -1, -1, 1)
        self.Boss:addChild(effect)
    end
    --介绍
    self.Info:setTexture(self.bqPath[self.index])
end

function HeroListMainLayer:getArmature(image)

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

    armature:setPositionX(100)
    armature:setAnimationFps(GameConfig.ANIM_FPS)
    armature:playByIndex(0, -1, -1, 1)
    return armature
end

function HeroListMainLayer:refreshTabelView()
    if self.titleTableView == nil then
        local  titleTableView =  TFTableView:create()
        local Size = self.panel_name:getSize()
        titleTableView:setTableViewSize(CCSizeMake(Size.width, Size.height))
        titleTableView:setDirection(TFTableView.TFSCROLLVERTICAL)
        titleTableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
        self.titleTableView = titleTableView
        self.titleTableView.logic = self
    
        titleTableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
        titleTableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
        titleTableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
        self.panel_name:addChild(self.titleTableView)  
    end

    self.titleTableView:reloadData()

    if self.dropTableView == nil then
        local  dropTableView =  TFTableView:create()
        local Size = self.panel_reward:getSize()
        dropTableView:setTableViewSize(CCSizeMake(Size.width, Size.height))
        dropTableView:setDirection(TFTableView.TFSCROLLVERTICAL)
        dropTableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
        self.dropTableView = dropTableView
        self.dropTableView.logic = self
    
        dropTableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable1)
        dropTableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex1)
        dropTableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView1)
        self.panel_reward:addChild(self.dropTableView)  
    end

    self.dropTableView:reloadData()
end
function HeroListMainLayer.cellSizeForTable(table,idx)
    return 85,100
end
function HeroListMainLayer.numberOfCellsInTableView(table,idx)
    local self = table.logic
    return #self.rewardList
end

function HeroListMainLayer.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.view:clone()
        panel.logic = self
        cell.panel = panel
        cell:addChild(panel)
    end
    cell.panel:setPosition(ccp(0,-510))
    self:setCellData(idx+1, cell.panel)

    return cell
end

function HeroListMainLayer:setCellData(idx, panel)
    local  btn_pt             = TFDirector:getChildByPath(panel, "btn_pt") 
    btn_pt.txt_name    = TFDirector:getChildByPath(btn_pt, "txt_name") 
    local  btn_xz             = TFDirector:getChildByPath(panel, "btn_xz")
    btn_xz.txt_name    = TFDirector:getChildByPath(btn_xz, "txt_name") 
    local  btn_wkq            = TFDirector:getChildByPath(panel, "btn_wkq")
    btn_wkq.txt_name   = TFDirector:getChildByPath(btn_wkq, "txt_name")
    local num = self.beginnum 
    -- if self.beginnum == 0 then
    --     num = 1
    -- else
    --     num = 
    -- end
    if idx > num +1 or MainPlayer:getLevel() < self.rewardList[idx].required_level then
        btn_wkq:setVisible(true)
    else
        btn_wkq:setVisible(false)
    end
    self.xztypeClick[idx] = btn_xz
    if self.index ~= idx then
        btn_xz:setVisible(false)
    else
        btn_xz:setVisible(true)
    end
    btn_wkq.txt_name:setText(self.rewardList[idx].stagename)
    btn_xz.txt_name:setText(self.rewardList[idx].stagename)
    btn_pt.txt_name:setText(self.rewardList[idx].stagename)
    btn_pt:addMEListener(TFWIDGET_CLICK, 
    audioClickfun(function()    
        if self.index ~= idx then
            self.index = idx
            HeroListManager.LastBoss = idx 
            for i= 1,#self.xztypeClick do 
                self.xztypeClick[i]:setVisible(false)
            end
            btn_xz:setVisible(true)
            self:refreshBoss()
            self:refreshReward()
            self:refreshTabelView()
        end
    end))
    btn_wkq:addMEListener(TFWIDGET_CLICK, 
    audioClickfun(function()    
        if MainPlayer:getLevel() < self.rewardList[idx].required_level then
            toastMessage(localizable.replayLayer_tips2)
        else
            toastMessage(localizable.replayLayer_tips3)
        end
    end))
end

function HeroListMainLayer.cellSizeForTable1(table,idx)
    return 80,70
end

function HeroListMainLayer.numberOfCellsInTableView1(table,idx)
    local self = table.logic
    return self.dropList:length()/4
end

function HeroListMainLayer.tableCellAtIndex1(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()

    if cell == nil then

        cell = TFTableViewCell:create()
        local item_node = TFPanel:create();
        cell:addChild(item_node);
        cell.item_node = item_node;

        for i = 1,4 do
            local node = TFTableViewCell:create()
            local reward = self.dropList:getObjectAt(idx*4+i);
            local reward_item = Public:createIconNumNode(reward);
            reward_item:setScale(0.55)
            reward_item:setPosition(ccp(0+78*(i-1),0))
            reward_item:setName("reward_item" .. i);
            node:addChild(reward_item);
            item_node:addChild(node)
            if idx*4 + i == 3 then
                local img = nil
                img = TFImage:create("ui_new/spectrum/herolist/img_tsdl.png")   
                if img then
                    img:setScale(1.8)
                    local widgetSize = reward_item:getSize()
                    local pos = ccp(widgetSize.width / 2, widgetSize.height-5)
                    img:setPosition(pos)
                    reward_item:addChild(img, 100)
                    reward_item.img = img
                end
            end
        end
    else
        for i = 1,4 do
            local roleIndex = idx*4 + i;
            local m_node = TFDirector:getChildByPath(cell.item_node, 'reward_item' .. i);
            local reward = self.dropList:getObjectAt(idx*4+i);
            Public:loadIconNode(m_node,reward)
            if m_node.img then
                m_node.img:setVisible(false)
            end
            if roleIndex == 3 then
                if m_node.img then
                    m_node.img:setVisible(true)
                else
                    local img = nil
                    img = TFImage:create("ui_new/spectrum/herolist/img_tsdl.png")   
                    if img then
                        img:setScale(1.8)
                        local widgetSize = m_node:getSize()
                        local pos = ccp(widgetSize.width / 2, widgetSize.height-5)
                        img:setPosition(pos)
                        m_node:addChild(img, 100)
                        m_node.img = img
                    end
                end
            end
        end
    end

    return cell
end

function HeroListMainLayer.onGoClickHandle(sender)
    local self = sender.logic;

end

function HeroListMainLayer:removeUI()
    self.super.removeUI(self);
    
end

function HeroListMainLayer:registerEvents()
    self.super.registerEvents(self);

    if self.generalHead then
        self.generalHead:registerEvents()
    end
    self.btn_buy:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnAttackClickHandle),1)
    self.btn_jia:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnbutStrengthClickHandle),1)
    self.Btn_guizhe:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnHelp),1)

    self.refreshlist = function(event)
        self:refreshUI()
    end

    TFDirector:addMEGlobalListener(HeroListManager.OPEN_HERO_AMBITION, self.refreshlist)
end

function HeroListMainLayer.onBtnAttackClickHandle(sender)
    local self = sender.logic
    HeroListManager:showHeroListVSLayer(self.index) 
end
function HeroListMainLayer.onBtnbutStrengthClickHandle(sender)
    local self = sender.logic
    HeroListManager:sendbutStrength()
end
function HeroListMainLayer.onBtnHelp()
    CommonManager:showRuleLyaer('yingxiongzhi')
end
function HeroListMainLayer:removeEvents()
    self.super.removeEvents(self);
    if self.generalHead then
        self.generalHead:removeEvents()
    end

    TFDirector:removeMEGlobalListener(HeroListManager.OPEN_HERO_AMBITION, self.refreshlist)
    self.refreshlist = nil

    
end
function HeroListMainLayer:dispose()
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
    self.super.dispose(self)
end

return HeroListMainLayer;
