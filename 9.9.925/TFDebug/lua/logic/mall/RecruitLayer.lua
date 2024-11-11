--[[
******购物中心图层*******

	-- by david.dai
	-- 2014/6/11
]]

local RecruitLayer = class("RecruitLayer", BaseLayer)

function RecruitLayer:ctor(defaultIndex)
    self.super.ctor(self,defaultIndex)
    self:init("lua.uiconfig_mango_new.shop.Recruit")
end

function RecruitLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.panel_head     = TFDirector:getChildByPath(ui, 'panel_head');
    self.generalHead = CommonManager:addGeneralHead( self )

    self.generalHead:setData(ModuleType.Recruit,{HeadResType.COIN,HeadResType.SYCEE})
    ViewSizeCheck(TFDirector:getChildByPath(ui,'bgImg'))

    self.panel_list    = TFDirector:getChildByPath(ui, 'panel_list')
    self.btn_guiyin    = TFDirector:getChildByPath(ui, 'btn_guiyin')
    self.btn_guiyin.logic = self
    self.btn_qiyuan    = TFDirector:getChildByPath(ui, 'btn_qiyuan')
    self.img_tishi     = TFDirector:getChildByPath(self.btn_qiyuan, 'img_tishi')
    self.img_tishi:setVisible(false)
   
    self.QiYuanPos     = self.btn_qiyuan:getPosition()
    self.btn_box       = TFDirector:getChildByPath(ui, 'btn_xiangzi')
    self.txt_des     = TFDirector:getChildByPath(self.btn_box, 'txt_des')
    self.btn_box:setVisible(false)
    local verLock = VersionLockData:objectByID(EnumVersionLockType.QiYuan_Lock)
    if verLock and verLock.open == 0 then
        self.btn_qiyuan:setVisible(false)
    else
        self.btn_qiyuan:setVisible(true)
    end
    self.btn_zhuanhuan = TFDirector:getChildByPath(ui, "btn_zhuanhuan")
    self.btn_zhuanhuan.logic = self
    if self.btn_qiyuan:isVisible() == false then
        local posY = self.btn_qiyuan:getPositionY()
        self.btn_zhuanhuan:setPositionY(posY)
    end
    self.panel_jiangli = TFDirector:getChildByPath(ui, "Panel_jiangli")
    self.txt_count = TFDirector:getChildByPath(ui, "txt_200")
    self.tRewardNode = {}
    for i=1,3 do
        self.tRewardNode[i] = {}
        self.tRewardNode[i].img_tag = TFDirector:getChildByPath(self.panel_jiangli, "img_ylq"..i)
        self.tRewardNode[i].txt = TFDirector:getChildByPath(self.panel_jiangli, "txt_"..i)
        self.tRewardNode[i].txt_num = TFDirector:getChildByPath(self.panel_jiangli, "txt_s"..i)
        self.tRewardNode[i].btn = TFDirector:getChildByPath(self.panel_jiangli, "btn_"..i)
        self.tRewardNode[i].box = TFDirector:getChildByPath(self.panel_jiangli, "img_sbox"..i)
        self.tRewardNode[i].box.idx = i
        self.tRewardNode[i].btn.idx = i
    end
    self:selectRecruit()
end

function RecruitLayer:removeUI()
    self.super.removeUI(self)
    self.panel_list         = nil
    self.btn_guiyin         = nil
end

function RecruitLayer:registerEvents()
    self.super.registerEvents(self)
    if self.generalHead then
        self.generalHead:registerEvents()
    end
    self.btn_guiyin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.guiYinClickHandle))
    self.btn_qiyuan:addMEListener(TFWIDGET_CLICK, audioClickfun(self.qiYuanClick))
    self.btn_zhuanhuan:addMEListener(TFWIDGET_CLICK, audioClickfun(self.zhuanhuanClick))
    --self.btn_box:addMEListener(TFWIDGET_CLICK, audioClickfun(self.boxClick))

    for i=1,3 do
        self.tRewardNode[i].box:addMEListener(TFWIDGET_CLICK, audioClickfun(self.boxClick))
        self.tRewardNode[i].box:setTouchEnabled(true)
        self.tRewardNode[i].btn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.boxClick))
        self.tRewardNode[i].box.logic = self
        self.tRewardNode[i].btn.logic = self
    end

    self.queryStateMsgCallBack = function(event)
        self:refreshRewardNodeInfo()
    end

    TFDirector:addMEGlobalListener(GetCardManager.Event_QueryStateMsg ,self.queryStateMsgCallBack)

    self.getRewardCallBack = function(event)
        self:refreshRewardNodeInfo()
    end

    TFDirector:addMEGlobalListener(GetCardManager.Event_GetRewardResult ,self.getRewardCallBack)

    self.getRoleResultCallBack = function(event)
        self:refreshRewardNodeState()
    end

    TFDirector:addMEGlobalListener(GetCardManager.Event_GetRoleResult ,self.getRoleResultCallBack)
    
end

function RecruitLayer:removeEvents()
    if self.generalHead then
        self.generalHead:removeEvents()
    end
    TFDirector:removeMEGlobalListener(GetCardManager.Event_QueryStateMsg ,self.queryStateMsgCallBack)
    TFDirector:removeMEGlobalListener(GetCardManager.Event_GetRoleResult ,self.getRoleResultCallBack)
    TFDirector:removeMEGlobalListener(GetCardManager.Event_GetRewardResult ,self.getRewardCallBack)
    self.super.removeEvents(self)
    if self.showRewardTween then
        TFDirector:killTween(self.showRewardTween)
        self.showRewardTween = nil
    end
end

function RecruitLayer:showTenState()
    --self.btn_box:setVisible(true)
    local str = GetCardManager:getTenInfo()
    self.txt_des:setText(str)
    self:showRewardDay()
    if 1 then
        return
    end
    if self.showRewardTween then
        return
    end
    local roleList = GetCardManager:getRoleListInTen()
    local index = 1
    local rewardItem = roleList:objectAt(index)
    if rewardItem == nil then
        return
    end
    if self.showRewardImg == nil then
        self.showRewardImg = Public:createIconNumNode(rewardItem,false)
        self.showRewardImg:setAnchorPoint(ccp(0.5,0.5))
        self.showRewardImg:setPosition(ccp( 0,0))
        self.showRewardImg:setVisible(true)
        self.btn_box:addChild(self.showRewardImg)
        self.showRewardImg:setAlpha(0.3)
        self.showRewardImg:setScale(0.5)
    end
    self.showRewardTween = {
        target = self.showRewardImg,
        repeated = -1,
        {
            duration = 2,
            alpha = 1,
        },
        {
            duration = 0,
            delay = 4, 
        },
        { 
            duration = 2,
            alpha = 0,
            onComplete = function()
                index = index + 1
                if index > roleList:length() then
                    index = 1
                end
                local _rewardItem = roleList:objectAt(index)
                Public:loadIconNode(self.showRewardImg,_rewardItem,false,false)
            end 
        }
    }
    TFDirector:toTween(self.showRewardTween)
    -- if self.showRewardTimer then
    --     return
    -- end
    -- self.showRewardTimer = TFDirector:addTimer(100)
end

function RecruitLayer:showRewardDay()
    local count = GetCardManager.tenCardcount or 0
    if count >= 10 then
        if self.EscortingEffect == nil then
            local resPath = "effect/escorting.xml"
            TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
            local effect = TFArmature:create("escorting_anim")
            local node   = self.btn_box
            effect:setAnimationFps(GameConfig.ANIM_FPS)
            node:addChild(effect, 1)
            effect:setPosition(ccp(0, -17))
            effect:setAnchorPoint(ccp(0.5, 0.5))
            effect:setScale(1.2)
            self.EscortingEffect = effect
        end
        self.EscortingEffect:playByIndex(1, -1, -1, 1)
    else
        if self.EscortingEffect ~= nil then
            self.EscortingEffect:removeFromParent()
            self.EscortingEffect = nil
        end
    end
end

function RecruitLayer:refreshRewardNodeInfo()
    local round = GetCardManager:getRecruitRound()
    local lastData = GetCardManager:getRewardBoxData(6)
    local num = (round - 1) * lastData.target_count
    local baseID = 1
    if GetCardManager:isFrontThreeGot() == true then
        baseID = 4
    end
    for i=1,3 do
        local idx = baseID - 1 + i
        local data = GetCardManager:getRewardBoxData(idx)
        local totalNum = num + data.target_count
        self.tRewardNode[i].totalNum = totalNum
        self.tRewardNode[i].box.idx = idx
        local rewardItem = GetRewardByString(data.reward)
        self.tRewardNode[i].btn:setTextureNormal(rewardItem.path)
        self.tRewardNode[i].btn.idx = idx
        self.tRewardNode[i].txt:setText(totalNum)
        self.tRewardNode[i].txt_num:setText("X" .. rewardItem.number)
        if totalNum > 99 then
            self.tRewardNode[i].txt:setScale(0.4)
        else
            self.tRewardNode[i].txt:setScale(0.6)
        end
    end
    self:refreshRewardNodeState()
end

function RecruitLayer:refreshRewardNodeState()
    local currCount = GetCardManager:getRecruitCount()
    for i=1,3 do
        local isCan = false
        if currCount == nil then
            currCount = 0;
        end
        if self.tRewardNode[i].totalNum == nil then
            self.tRewardNode[i].totalNum = 0;
        end
        if self.tRewardNode[i].totalNum <= currCount then
            isCan = true
        end
        local bGot = GetCardManager:isBoxGot(self.tRewardNode[i].box.idx)
        if bGot == true then
            isCan = false
            self.tRewardNode[i].img_tag:setVisible(true)
            --self.tRewardNode[i].btn:setTouchEnabled(false)
            --self.tRewardNode[i].box:setTouchEnabled(false)
        else
            self.tRewardNode[i].img_tag:setVisible(false)
            self.tRewardNode[i].btn:setTouchEnabled(true)
            self.tRewardNode[i].box:setTouchEnabled(true)
        end
        self.tRewardNode[i].btn.isCan = isCan
        self.tRewardNode[i].box.isCan = isCan
        if isCan == true then
            if self.tRewardNode[i].box.effect then
                self.tRewardNode[i].box.effect:setVisible(true)
            else
                local resPath = "effect/escorting.xml"
                TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
                local effect = TFArmature:create("escorting_anim")
                local node   = self.tRewardNode[i].box
                effect:setAnimationFps(GameConfig.ANIM_FPS)
                node:addChild(effect, 1)
                local size = node:getContentSize()
                effect:setPosition(ccp(0 + size.width * 0.5, -17 + size.height * 0.5))
                effect:setAnchorPoint(ccp(0.5, 0.5))
                effect:setScale(1.2)
                self.tRewardNode[i].box.effect = effect
            end
            self.tRewardNode[i].box.effect:playByIndex(1, -1, -1, 1)
        elseif self.tRewardNode[i].box.effect then
            self.tRewardNode[i].box.effect:setVisible(false)
        end
    end
    self.txt_count:setText(currCount)
end

function RecruitLayer.qiYuanClick(sender)
    QiYuanManager:OpenQiYuanLayer()
end

function RecruitLayer.guiYinClickHandle(sender)
    local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2201)
    if teamLev < openLev then
        --toastMessage("团队等级达到"..openLev.."级开启")
        toastMessage(stringUtils.format(localizable.common_function_openlevel,openLev))
    else
        local layer =  AlertManager:addLayerByFile("lua.logic.hermit.HermitLayer");
        AlertManager:show();
    end
end

function RecruitLayer.zhuanhuanClick(sender)
    local layer =  AlertManager:addLayerByFile("lua.logic.mall.XiaKeZhuanHuanLayer");
    AlertManager:show();
end

function RecruitLayer.boxClick(sender)
    local self = sender.logic
    local idx = sender.idx
    local currCount = GetCardManager:getRecruitCount()
    local idx0 = idx
    if idx0  > 3 then
        idx0 = idx0 - 3
    end
    if sender.isCan == false then
        if sender == self.tRewardNode[idx0].btn then
            local data = GetCardManager:getRewardBoxData(idx)
            local tbl = stringToNumberTable(data.reward,"_")
            Public:ShowItemTipLayer(tbl[2], tbl[1]);
            return
        end
        if self.tRewardNode[idx0].totalNum > currCount then
            toastMessage(localizable.getRoleLayer_txt2)
            return
        end
        return
    end
    GetCardManager:requestBoxReward(idx)
end

function RecruitLayer:selectRecruit()
    --创建显示内容图层
    GetCardManager:SendQueryStateMsg()
    self.recruitPage = require("lua.logic.shop.GetRoleLayer"):new()
    self.panel_list:addChild(self.recruitPage,10)

end

-----断线重连支持方法
function RecruitLayer:onShow()
    self.super.onShow(self)
    if self.recruitPage then
        self.recruitPage:onShow()
    end
    self.generalHead:onShow();
    --[[local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2201)
    if teamLev < openLev then
        self.btn_guiyin:setVisible(false)
        self.btn_qiyuan:setPosition(self.btn_guiyin:getPosition())
    else
        self.btn_guiyin:setVisible(true)
        self.btn_qiyuan:setPosition(self.QiYuanPos)
    end
    if QiYuanManager:isUnLockQiYuan() then
        self.img_tishi:setVisible(false)
    else
        self.img_tishi:setVisible(true)
    end]]
    CommonManager:setRedPoint(self.btn_qiyuan, QiYuanManager:isHaveQiYuanFree(),"isHaveQiYuanFree",ccp(0,0))
end

function RecruitLayer:dispose()
    if self.recruitPage then
        self.recruitPage:dispose()
        self.recruitPage = nil
    end

    if generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
    self.super.dispose(self)
end

return RecruitLayer