--[[
******英雄大会-奖励*******

    -- by jiawei.miao
    -- 2018/1/5
]]
local HeroRewardLayer = class("HeroRewardLayer", BaseLayer);

CREATE_SCENE_FUN(HeroRewardLayer);
CREATE_PANEL_FUN(HeroRewardLayer);

function HeroRewardLayer:ctor(data)
    self.super.ctor(self,data);
    HeroMeetingManager:GetSettlementRewardInfoRequest()
    self:init("lua.uiconfig_mango_new.hero.HeroReward");
end

function HeroRewardLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function HeroRewardLayer:refreshUI()

end

function HeroRewardLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.panel_tiaomu    = TFDirector:getChildByPath(ui, 'panel_jiesuanjiangli')
    self.bg             = TFDirector:getChildByPath(self.panel_tiaomu, 'bg_wdpm')

    self.bg:retain()
    self.bg:removeFromParent()
    self.bg:setVisible(false)

    local panel_meirijiangli    = TFDirector:getChildByPath(ui, 'panel_meirijiangli')
    panel_meirijiangli:setVisible(true)

    self.bg2            = TFDirector:getChildByPath(panel_meirijiangli, 'bg_wdpm')
    self.bg2:retain()
    self.bg2:removeFromParent()
    self.bg2:setVisible(false)
    self.btn_close      = TFDirector:getChildByPath(ui, 'btn_close')

    self.panel_zrjspm   = TFDirector:getChildByPath(ui, 'panel_zrjspm')
    self.panel_wdpm     = TFDirector:getChildByPath(ui, 'panel_wdpm')
    self.txt_mrpm       = TFDirector:getChildByPath(self.panel_wdpm, 'txt_listnum')
    self.txt_jspm       = TFDirector:getChildByPath(self.panel_zrjspm, 'txt_listnum')

    self.tab_meiri      = TFDirector:getChildByPath(ui, 'tab_meiri')
    self.tab_jsjl       = TFDirector:getChildByPath(ui, 'tab_jsjl')
    self.txt_meiri      = TFDirector:getChildByPath(ui, 'txt_meiri')
    self.txt_jiesuan    = TFDirector:getChildByPath(ui, 'txt_jiesuan')

    self.meiriRewardList = ChampionsAwardData:getAllRewardDataByType(27)

    self.jiesuanRewardList = HeroDuelRewardData:getRewardList(HeroMeetingManager.HeroJieSuanReward)
    -- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",self.jiesuanRewardList)
    --0可领取，1未达到条件，2已领取
    for i,v in pairs(self.jiesuanRewardList) do
        v.status = 1
    end
    self:refreshList()
    self:selectTab(1)
end
--选择标签
function HeroRewardLayer:selectTab(index)
    self:reSetTab()
    if index == 1 then
        self.tab_meiri:setTextureNormal("ui_new/hero/tab_mrjlh.png")
        self.tab_meiri:setTouchEnabled(false)
        self.panel_wdpm:setVisible(true)
        self.panel_zrjspm:setVisible(false)
        self.txt_meiri:setVisible(true)
        self.txt_jiesuan:setVisible(false)
        if self.RewardList then
            self.RewardList2:setVisible(true)
            self.RewardList:setVisible(false) 
        end
    elseif index == 2 then
        self.tab_jsjl:setTextureNormal("ui_new/hero/tab_jsjlh.png")
        self.tab_jsjl:setTouchEnabled(false)
        self.panel_wdpm:setVisible(false)
        self.panel_zrjspm:setVisible(true)
        self.txt_meiri:setVisible(false)
        self.txt_jiesuan:setVisible(true)
        if self.RewardList then
            self.RewardList2:setVisible(false)
            self.RewardList:setVisible(true)           
        end
    end
end
--刷新按钮为普通状态
function HeroRewardLayer:reSetTab()
    self.tab_meiri:setTextureNormal("ui_new/hero/tab_mrjl.png")
    self.tab_jsjl:setTextureNormal("ui_new/hero/tab_jsjl.png")
    self.tab_meiri:setTouchEnabled(true)
    self.tab_jsjl:setTouchEnabled(true)
end

function HeroRewardLayer:refreshList()
    if self.RewardList == nil then
        self.RewardList = TFTableView:create()
        self.RewardList.logic = self
        local Size = self.panel_tiaomu:getSize()
        self.RewardList:setTableViewSize(CCSizeMake(Size.width, Size.height))
        self.RewardList:setDirection(TFTableView.TFSCROLLVERTICAL)
        self.RewardList:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)

        self.RewardList:addMEListener(TFTABLEVIEW_SIZEFORINDEX, HeroRewardLayer.cellSizeForTable)
        self.RewardList:addMEListener(TFTABLEVIEW_SIZEATINDEX, HeroRewardLayer.tableCellAtIndex)
        self.RewardList:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, HeroRewardLayer.numberOfCellsInTableView)
        self.panel_tiaomu:addChild(self.RewardList)
    end
    self.RewardList:reloadData()
    if self.RewardList2 == nil then
        self.RewardList2 = TFTableView:create()
        self.RewardList2.logic = self
        local Size = self.panel_tiaomu:getSize()
        self.RewardList2:setTableViewSize(CCSizeMake(Size.width, Size.height))
        self.RewardList2:setDirection(TFTableView.TFSCROLLVERTICAL)
        self.RewardList2:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)

        self.RewardList2:addMEListener(TFTABLEVIEW_SIZEFORINDEX, HeroRewardLayer.cellSizeForTable2)
        self.RewardList2:addMEListener(TFTABLEVIEW_SIZEATINDEX, HeroRewardLayer.tableCellAtIndex2)
        self.RewardList2:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, HeroRewardLayer.numberOfCellsInTableView2)
        self.panel_tiaomu:addChild(self.RewardList2)
    end
    self.RewardList2:reloadData()
end
function HeroRewardLayer:refreshIcon(itemId,Type,num,icon,icon1,txt_num)
    txt_num:setScale(1.2)
    if Type == EnumDropType.GOODS then 
        local item = ItemData:objectByID(itemId)
        if (item) then
            local iconStr = item:GetPath()
            icon1:setTexture(iconStr)
            icon:setTexture(GetColorIconByQuality(item.quality))
            txt_num:setText(num)
        end
    elseif Type == EnumDropType.ZHUXIN then
        icon1:setTexture(GetZhuXinCoinIcon())
        icon:setTexture(GetColorIconByQuality(4))
        txt_num:setText(num)
    elseif Type == EnumDropType.COIN then
        icon1:setTexture(GetCoinIcon())
        icon:setTexture(GetColorIconByQuality(4))
        txt_num:setText(num)
    elseif Type == EnumDropType.WEIWANG then
        icon1:setTexture(GetWeiWangCoinIcon())
        icon:setTexture(GetColorIconByQuality(5))
        txt_num:setText(num)
    elseif Type == EnumDropType.SYCEE then
        icon1:setTexture(GetSyceeIcon())
        icon:setTexture(GetColorIconByQuality(4))
        txt_num:setText(num)
    end
end

function HeroRewardLayer.cellSizeForTable(table,idx)
    return 141,100
end
function HeroRewardLayer.numberOfCellsInTableView(table,idx)
    local self = table.logic
    return #self.jiesuanRewardList
end

function HeroRewardLayer.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.bg:clone()
        panel.logic = self
        panel:setVisible(true)
        cell.panel = panel
        cell:addChild(panel)
    end

    cell.panel:setPosition(ccp(305,60))
    self:setCellData(idx+1, cell.panel)

    return cell
end

function HeroRewardLayer:setCellData(idx, panel)
    local self = panel.logic
    if self.jiesuanRewardList[idx] == nil then
        panel:setVisible(false)
        return
    end
    local function sortByIdAndStatus( v1, v2 )
        if v1.status < v2.status then
            return true
        elseif v1.status > v2.status then
                return false
        elseif v1.id < v2.id then
            return true
        else
            return false
        end
    end
    table.sort(self.jiesuanRewardList, sortByIdAndStatus)
    local txt_pm    = TFDirector:getChildByPath(panel, 'txt_pm')
    local btn_get   = TFDirector:getChildByPath(panel, 'btn_get')
    local img_ylq   = TFDirector:getChildByPath(panel, 'img_ylq')
    local state = false
    if self.jiesuanRewardList[idx].status ~= 0 then
        btn_get:setGrayEnabled(true)
        btn_get:setTouchEnabled(false)
        btn_get:setVisible(false)
    else
        state = true
        btn_get:setTouchEnabled(true)
        btn_get:setGrayEnabled(false)
        btn_get:setVisible(true)
    end
    HeroMeetingManager.settlement = state
    btn_get:addMEListener(TFWIDGET_CLICK,
    audioClickfun(function()
        showLoading()
        TFDirector:send(c2s.RECEIVE_SETTLEMENT_REWARD_REQUEST, {self.jiesuanRewardList[idx].id})
    end))
    if self.jiesuanRewardList[idx].status == 2 then
        img_ylq:setVisible(true)
    else
        img_ylq:setVisible(false)
    end
    if self.jiesuanRewardList[idx].param1 == self.jiesuanRewardList[idx].param2 then
        txt_pm:setText(stringUtils.format(localizable.arenaplaylistlayer_list,self.jiesuanRewardList[idx].param1))
    else
        txt_pm:setText(stringUtils.format(localizable.arenarewardlayer_list,self.jiesuanRewardList[idx].param1,self.jiesuanRewardList[idx].param2))
    end
    local awardList = string.split(self.jiesuanRewardList[idx].rewards, '|')
    if awardList == nil then
        return
    end
    for i = 1, 3 do
        local img_icon      = TFDirector:getChildByPath(panel, 'img_icon'..i)
        img_icon:setVisible(false)
    end
    for i,v in pairs(awardList) do
        local img_icon      = TFDirector:getChildByPath(panel, 'img_icon'..i)
        img_icon:setVisible(true)
        local img_icon1     = TFDirector:getChildByPath(img_icon, 'img_icon')
        local txt_num       = TFDirector:getChildByPath(img_icon, 'txt_num')
        local info          = string.split(v, "_")
        local itemTypeId    = tonumber(info[1])
        local itemId        = tonumber(info[2])
        local itemNum       = tonumber(info[3])
        img_icon:setTouchEnabled(true)
        img_icon.itemId          = itemId
        img_icon.itemTypeId      = itemTypeId
        img_icon:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowItemClickHandle),1)
        self:refreshIcon(itemId,itemTypeId,itemNum,img_icon,img_icon1,txt_num)
    end
end

function HeroRewardLayer.cellSizeForTable2(table,idx)
    return 141,100
end
function HeroRewardLayer.numberOfCellsInTableView2(table,idx)
    local self = table.logic
    return #self.meiriRewardList
end

function HeroRewardLayer.tableCellAtIndex2(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.bg2:clone()
        panel.logic = self
        panel:setVisible(true)
        cell.panel = panel
        cell:addChild(panel)
    end

    cell.panel:setPosition(ccp(305,60))

    self:setCellData2(idx+1, cell.panel)

    return cell
end

function HeroRewardLayer:setCellData2(idx, panel)
    local self = panel.logic
    if self.meiriRewardList[idx] == nil then
        panel:setVisible(false)
        return
    end
    local txt_pm    = TFDirector:getChildByPath(panel, 'txt_pm')
    if self.meiriRewardList[idx].min_rank == self.meiriRewardList[idx].max_rank then
        txt_pm:setText(stringUtils.format(localizable.arenaplaylistlayer_list,self.meiriRewardList[idx].min_rank))
    else
        txt_pm:setText(stringUtils.format(localizable.arenarewardlayer_list,self.meiriRewardList[idx].min_rank,self.meiriRewardList[idx].max_rank))
    end
    local awardList = string.split(self.meiriRewardList[idx].award, '|')
    if awardList == nil then
        return
    end
    for i = 1, 3 do
        local img_icon      = TFDirector:getChildByPath(panel, 'img_icon'..i)
        img_icon:setVisible(false)
    end
    for i,v in pairs(awardList) do
        local img_icon      = TFDirector:getChildByPath(panel, 'img_icon'..i)
        if (img_icon) then
            img_icon:setVisible(true)
            local img_icon1     = TFDirector:getChildByPath(img_icon, 'img_icon')
            local txt_num       = TFDirector:getChildByPath(img_icon, 'txt_num')
            local info          = string.split(v, "_")
            local itemTypeId    = tonumber(info[1])
            local itemId        = tonumber(info[2])
            local itemNum       = tonumber(info[3])
            img_icon:setTouchEnabled(true)
            img_icon.itemId          = itemId
            img_icon.itemTypeId      = itemTypeId
            img_icon:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowItemClickHandle),1)
            self:refreshIcon(itemId,itemTypeId,itemNum,img_icon,img_icon1,txt_num)
        end
    end
end

function HeroRewardLayer:removeUI()
    if self.bg then
        self.bg:release()
        self.bg = nil
    end
    if self.bg2 then
        self.bg2:release()
        self.bg2 = nil
    end
    self.super.removeUI(self);
end

function HeroRewardLayer:registerEvents()
    self.super.registerEvents(self);

    ADD_ALERT_CLOSE_LISTENER(self,self.btn_close)

    self.tab_meiri.logic = self
    self.tab_jsjl.logic = self
    self.tab_meiri:addMEListener(TFWIDGET_CLICK, audioClickfun(handler(self.DaliyClickHandle,self)))
    self.tab_jsjl:addMEListener(TFWIDGET_CLICK, audioClickfun(handler(self.AccountsClickHandle,self)))

    self.receiveInfo = function(event)     
        if event.data[1][1].currentRank then
            self.txt_mrpm:setText(event.data[1][1].currentRank)
            if event.data[1][1].currentRank == 0 then
                self.txt_mrpm:setText(localizable.houshanRank_rank)
            end
        else
            self.txt_mrpm:setText(localizable.houshanRank_rank)
        end
        if event.data[1][1].yesterdayRank then
            self.txt_jspm:setText(event.data[1][1].yesterdayRank)
            if event.data[1][1].yesterdayRank == 0 then
                self.txt_jspm:setText(localizable.houshanRank_rank)
            end
        else
            event.data[1][1].yesterdayRank = 0
            self.txt_jspm:setText(localizable.houshanRank_rank)
        end
        self.jiesuanRewardList = HeroDuelRewardData:getRewardList(HeroMeetingManager.HeroJieSuanReward)
        print("GET_HERO_REWARD_INFO",self.jiesuanRewardList)
        for k,r in pairs(self.jiesuanRewardList) do
            if event.data[1][1].yesterdayRank <= r.param2 then
                r.status = 0
            end
            if event.data[1][1].yesterdayRank == 0 then
                r.status = 1
            end
        end
        if event.data[1][1].rewardIds then
            for k,r in pairs(self.jiesuanRewardList) do
                for i,v in pairs(event.data[1][1].rewardIds) do
                    if v == r.id then
                        r.status = 2
                    end
                end     
            end           
        end
        self:refreshList()
    end
    --我的奖励
    TFDirector:addMEGlobalListener(HeroMeetingManager.GET_HERO_REWARD_INFO, self.receiveInfo)

    self.receiveInfo1 = function(event)     
        -- print(event.data[1][1],self,"    1",self.jiesuanRewardList)
        if event.data[1][1].rewardId then
            for k,r in pairs(self.jiesuanRewardList) do
                if r.id == event.data[1][1].rewardId then
                   r.status = 2
                end
            end           
        end
        self:refreshList()
    end
    --我的奖励
    TFDirector:addMEGlobalListener(HeroMeetingManager.RECEIVE_REWARD, self.receiveInfo1)
end

function HeroRewardLayer.DaliyClickHandle(sender)
    local self = sender.logic
    self:selectTab(1)
end

function HeroRewardLayer.AccountsClickHandle(sender)
    local self = sender.logic
    self:selectTab(2)
end

function HeroRewardLayer.onShowItemClickHandle(sender)
    local self = sender.logic;
    if sender.itemId == nil then
        Public:ShowItemTipLayer(nil, sender.itemTypeId)
    else
        Public:ShowItemTipLayer(sender.itemId, sender.itemTypeId)
    end
end

function HeroRewardLayer:removeEvents()
    -- TFDirector:removeMEGlobalListener(ClimbManager.updateInfo ,self.updateInfoCallBack);
    TFDirector:removeMEGlobalListener(HeroMeetingManager.GET_HERO_REWARD_INFO, self.receiveInfo)
    self.receiveInfo = nil
    TFDirector:removeMEGlobalListener(HeroMeetingManager.RECEIVE_REWARD, self.receiveInfo1)
    self.receiveInfo1 = nil
    self.super.removeEvents(self);
end

return HeroRewardLayer;
