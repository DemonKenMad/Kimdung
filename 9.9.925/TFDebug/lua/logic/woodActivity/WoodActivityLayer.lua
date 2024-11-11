-- client side WoodActivityLayer.lua
--[[
 * @Description: 木人桩活动
 ]]
-- script writer wuqi
-- creation time 2016-11-16

local WoodActivityLayer = class("WoodActivityLayer", BaseLayer)

WoodActivityLayer.BG_DIS = 5   --每一屏对应的前进距离
WoodActivityLayer.BG_WIDTH = 1136
WoodActivityLayer.MoveSpeed = { 60, 120, 200 }    --三档移动速度
WoodActivityLayer.BOX_HIDE_DIS = 600
WoodActivityLayer.EFFECT_BEGIN_X = 500

WoodActivityLayer.EnumYMoveState = 
{
    UP = 1,
    DOWN = 2,
    FALL = 3,
    DIE = 4
}

local bgPathTab = {"img_Begin", "img_zhuzikaishi", "img_zhuziNojiasu", "img_zhuziJianbian", "img_zhuziJiasu", "img_baoxiang", "img_smbxicon"}

WoodActivityLayer.bgShowPath = 
{
    [1] = { bgPathTab[1], bgPathTab[2] },
    [2] = { bgPathTab[4], bgPathTab[6], bgPathTab[7] },
    [3] = { bgPathTab[5], bgPathTab[6], bgPathTab[7] },
    [4] = { bgPathTab[5], bgPathTab[6], bgPathTab[7] }
}

WoodActivityLayer.roleIdList = { 81, 94, 2 }    --三个人物形象id
WoodActivityLayer.REQUEST_DIS = { 1, 10, 30 }   --三档请求距离
WoodActivityLayer.boxNumTab = { 1, 10, 30 }    --每一档最多可获得宝箱数
WoodActivityLayer.BEGIN_MOVE_SPEED = 1         --选人界面背景移动速度 pixel per frame
WoodActivityLayer.fallSpeed = 20    --掉落速度
WoodActivityLayer.bgSpeedFactor = 0.25
WoodActivityLayer.frameConfig = {8, 8, 10}

function WoodActivityLayer:ctor()
    self.super.ctor(self, mountainItem);
    self:init("lua.uiconfig_mango_new.xiakexing.XiakexingMain");
    self.pageId = 1
    TFAudio.preloadEffect("sound/effect/chuangong-hunpoyidong.mp3")
end

function WoodActivityLayer:initUI(ui)
    self.super.initUI(self, ui);

    self.bg_table = TFDirector:getChildByPath(ui, 'Panel_bg');
    self.Panel_begin = TFDirector:getChildByPath(ui, "Panel_begin")
    self.Panel_flying = TFDirector:getChildByPath(ui, "Panel_flying")
    self.Panel_bg2 = TFDirector:getChildByPath(ui, 'Panel_bg2');

    self:initBeginPanel(self.Panel_begin)
    self:initFlyPanel(self.Panel_flying)
    self:showBeginPage()

    self.time = math.ceil(WoodActivityManager.leftTime / 1000 )
    local activity = OperationActivitiesManager:ActivityWithType(OperationActivitiesManager.Type_Xia_Ke_Xing)
    if activity then
        self.time = activity.endTime - MainPlayer:getNowtime()
        if self.time <= 0 then
            self.time = 0 
        end    
    end
    if self.end_timerID == nil then
        self.end_timerID = TFDirector:addTimer(1000, -1, nil, 
        function() 
            if self.end_timerID ~= nil then
                self:showNextTimer()
            end
        end)
    end
    self:showNextTimer()
end

function WoodActivityLayer:showNextTimer()
    self.time = self.time - 1
    if self.time <=  0 then
        if self.end_timerID then
            TFDirector:removeTimer(self.end_timerID)
            self.end_timerID = nil
        end
        toastMessage(localizable.treasureMain_tiemout)
        AlertManager:close()
    end 
end

function WoodActivityLayer:initBeginPanel(node)
    self.btn_help = TFDirector:getChildByPath(self.ui, "btn_help")
    self.btn_help.logic = self

    self.Panel_smbx = TFDirector:getChildByPath(self.ui, "Panel_smbx")
    self.img_julitiao = TFDirector:getChildByPath(self.Panel_smbx, "img_julitiao")
    self.txt_new_juli = TFDirector:getChildByPath(self.Panel_smbx, "txt_juli")
    self.img_smbxicon = TFDirector:getChildByPath(self.Panel_smbx, "img_smbxicon")

    self.btn_close = TFDirector:getChildByPath(self.ui, "btn_close")
    self.btn_close.logic = self
    --当前距离和历史最佳
    self.img_dangqian = TFDirector:getChildByPath(node, "img_dangqian")
    self.img_lishi = TFDirector:getChildByPath(node, "img_lishi")
    self.txt_juli = TFDirector:getChildByPath(self.img_dangqian, "txt_juli")
    self.txt_lishijuli = TFDirector:getChildByPath(self.img_lishi, "txt_lishijuli")
    self.btn_history = TFDirector:getChildByPath(self.ui,'btn_title1')

    self.img_bg = {}
    self.btn_select = {}
    local strBtn = { "btn_feiyanzoubi", "btn_taxuewuhen", "btn_yufengshenxing" }
    for i = 1, 3 do
        self.img_bg[i] = TFDirector:getChildByPath(node, "img_bg" .. i)
        --self.img_bg[i].img_role = TFDirector:getChildByPath(self.img_bg[i], "img_role" .. i)
        self.img_bg[i].txt_reward = TFDirector:getChildByPath(self.img_bg[i], "txt_reward")
        self.btn_select[i] = TFDirector:getChildByPath(self.img_bg[i], strBtn[i])
        self.btn_select[i].index = i
        self.btn_select[i].logic = self
        self.img_bg[i].img_res_icon = TFDirector:getChildByPath(self.img_bg[i], "img_res_icon")
        self.img_bg[i].txt_price = TFDirector:getChildByPath(self.img_bg[i], "txt_price" .. i)
        self.img_bg[i].txt_have = TFDirector:getChildByPath(self.img_bg[i], "txt_numb_have")
    end

    self.img_yantu_bg = TFDirector:getChildByPath(node, "img_bg")
    local iconModel = TFDirector:getChildByPath(self.img_yantu_bg, "bg_icon")
    local Panel_icons = TFDirector:getChildByPath(self.img_yantu_bg, "Panel_icons")
    iconModel:removeFromParent()
    local iconSize = iconModel:getSize()
    local iconBasePos = iconModel:getPosition()
    self.yantu_icon_tab = {}
    local posYTab = {58, 0}

    local list_reward = TFScrollView:create()
    list_reward:setPosition(ccp(0,0))
    list_reward:setDirection(SCROLLVIEW_DIR_HORIZONTAL)
    list_reward:setBackGroundColorType(TF_LAYOUT_COLOR_NONE)
    list_reward:setSize(Panel_icons:getSize())
    list_reward:setInnerContainerSize(CCSizeMake(Panel_icons:getSize().width + 100, Panel_icons:getSize().height))
    list_reward:setBounceEnabled(true);
    Panel_icons:addChild(list_reward)

    for i = 1, 16 do
        local row = math.ceil(i / 8)
        self.yantu_icon_tab[i] = iconModel:clone()
        self.yantu_icon_tab[i]:setVisible(false)
        local idx = i
        if row == 2 then
            idx = idx - 8
        end
        self.yantu_icon_tab[i]:setPosition( ccp( iconBasePos.x + 10 + (idx - 1) * iconSize.width * iconModel:getScaleX(), posYTab[row]) )
        --Panel_icons:addChild( self.yantu_icon_tab[i] )
        list_reward:addChild( self.yantu_icon_tab[i] )
    end
    --iconModel:release()
    iconModel = nil

    self.Panel_julibaoxiang = TFDirector:getChildByPath(node, "Panel_julibaoxiang")
    self.panel_boxes = {}
    for i = 1, 5 do
        self.panel_boxes[i] = {}
        local boxNode = TFDirector:getChildByPath(self.Panel_julibaoxiang, 'panel_box'..i)
        self.panel_boxes[i].rootNode = boxNode
        self.panel_boxes[i].btn = TFDirector:getChildByPath(boxNode, "btn_baoxiang_s" .. i)
        self.panel_boxes[i].txt_num = TFDirector:getChildByPath(boxNode, 'txt_juli')
    end

    self.panelItem = self.panelItem or {}
    if self.panelItem and #self.panelItem <= 0 then
        local node = createUIByLuaNew("lua.uiconfig_mango_new.xiakexing.Xiakexingbg")
        for i = 1, 2 do
            self.panelItem[i] = node:clone()
        end
    end
    for i = 1, 2 do
        local bg = TFDirector:getChildByPath(self.panelItem[i], "bg")
        local posX = bg:getSize().width * (i - 1)
        self.panelItem[i]:setPositionX(posX)
        self.Panel_bg2:addChild(self.panelItem[i])
        self.bgPanelWidth = bg:getSize().width
    end  

    self.Panel_Paihang = TFDirector:getChildByPath(self.ui, 'Panel_Paihang')
    self.Panel_Paihang:setVisible(true)
    self.img_di = TFDirector:getChildByPath(self.Panel_Paihang, 'img_di')
    self.btn_jifen = TFDirector:getChildByPath(self.Panel_Paihang, 'btn_jifen')
    self.btn_jifen.logic = self
    self.btn_shuaxin = TFDirector:getChildByPath(self.Panel_Paihang, 'btn_shuaxin')
    self.btn_shuaxin.logic = self
    self.panel_rank = TFDirector:getChildByPath(self.Panel_Paihang, 'panel_rank')
    self.panel_rank_2 = TFDirector:getChildByPath(self.Panel_Paihang, 'panel_rank_2')
    self.panel_gun = TFDirector:getChildByPath(self.Panel_Paihang, 'panel_gun')

    self.panel_rank:retain()
    self.panel_rank:removeFromParent(true)
    self.panel_rank:setVisible(false)
    self.panel_rank_2:retain()
    self.panel_rank_2:removeFromParent(true)
    self.panel_rank_2:setVisible(false)
    self.img_di:setPositionX(0)
    self.rankLayer_show = false

    self.isCrossServer = false
    local activity_score = OperationActivitiesManager:ActivityWithType(OperationActivitiesManager.Type_Xia_Ke_Xing_SCORE)
    if activity_score then
        self.isCrossServer = activity_score.multiSever
    end

    WoodActivityManager:requestRefreshRank()
end

function WoodActivityLayer:initFlyPanel(node)
    local img_dangqianbg = TFDirector:getChildByPath(node, "img_dangqianbg")
    self.txt_dis = TFDirector:getChildByPath(img_dangqianbg, "txt_number")
    self.img_rewardbg = TFDirector:getChildByPath(self.ui, "img_rewardbg")
    self.txt_box_num = TFDirector:getChildByPath(self.ui, "txt_box_num9")
    self.img_box = TFDirector:getChildByPath(self.ui, "img_baoxiang9")
    self.txt_dis:setText(0)
    self.txt_box_num:setText("X0")

    self.nodeItem = self.nodeItem or {}
    if self.nodeItem and #self.nodeItem <= 0 then
        local node = createUIByLuaNew("lua.uiconfig_mango_new.xiakexing.Xiakexingbg2")
        for i = 1, 2 do
            self.nodeItem[i] = node:clone()
        end
    end
    self.nodeItemBg = self.nodeItemBg or {}
    if self.nodeItemBg and #self.nodeItemBg <= 0 then
        local node = createUIByLuaNew("lua.uiconfig_mango_new.xiakexing.Xiakexingbg")
        for i = 1, 2 do
            self.nodeItemBg[i] = node:clone()
        end
    end

    for i = 1, 2 do
        local bg1 = TFDirector:getChildByPath(self.nodeItemBg[i], "bg")
        local posX1 = bg1:getSize().width * (i - 1)
        self.nodeItemBg[i]:setPositionX(posX1)
        self.bg_table:addChild(self.nodeItemBg[i])

        local bg = TFDirector:getChildByPath(self.nodeItem[i], "img_Begin")
        local posX = bg:getSize().width * (i - 1)
        self.nodeItem[i]:setPositionX(posX)
        self.bg_table:addChild(self.nodeItem[i])
        self.bgWidth = bg:getSize().width
        self:refreshNodeItem(self.nodeItem[i], i)
    end  
end

function WoodActivityLayer:showBeginPage()
    self.bg_table:setVisible(false)
    self.Panel_flying:setVisible(false)
    self.Panel_begin:setVisible(true)
    self.Panel_Paihang:setVisible(true)
    self.btn_help:setVisible(true)
    self.Panel_smbx:setVisible(true)
    self.btn_close:setVisible(true)
    self.Panel_bg2:setVisible(true)
    self.btn_history:setVisible(true)
    if self.img_rewardbg then
        self.img_rewardbg:setVisible(false)
    end
    self.pageId = 1
    if self.updateTimerID then
        TFDirector:removeTimer(self.updateTimerID)
        self.updateTimerID = nil
    end

    self:clearFastEffect()
    
    self.txt_juli:setText( WoodActivityManager:getTotalDis() or 0 )
    self.txt_lishijuli:setText(WoodActivityManager:getHistoryBest() or 0)
    local nextNew, sta = WoodActivityManager:getNextNewDis()

    if nextNew then
        self.img_smbxicon:setTouchEnabled(true)
        self.img_smbxicon.logic = self
        self.img_smbxicon.data = nextNew
        self.img_smbxicon.sta = sta
        
        if sta and sta == 1 then
            WoodActivityManager.bRedSpecial = true
            CommonManager:setRedPoint(self.img_smbxicon, true, "WoodSpeacialAward", ccp(0,-15))
        else
            WoodActivityManager.bRedSpecial = false
            CommonManager:setRedPoint(self.img_smbxicon, false, "WoodSpeacialAward", ccp(0,-15))
        end

        self.img_julitiao:setVisible(true)
        self.txt_new_juli:setText( stringUtils.format(localizable.WoodActivityLayer_tips8, nextNew[1].length) ) 
    else
        WoodActivityManager.bRedSpecial = false
        CommonManager:setRedPoint(self.img_smbxicon, false, "WoodSpeacialAward", ccp(0,-15))
        self.img_julitiao:setVisible(false)
        self.img_smbxicon:setTouchEnabled(true)
        self.img_smbxicon.isActivityEnd = true
    end 
    self.img_smbxicon:addMEListener( TFWIDGET_CLICK, self.specialIconCallback ) 
    local configList = WoodActivityManager:getConfigList()
    for i = 1, 16 do
        local data = configList[i]
        if data then
            local img_quality = self.yantu_icon_tab[i]
            img_quality:setVisible(true)
            local img_content = TFDirector:getChildByPath(img_quality, "img_icon")
            local txt_num = TFDirector:getChildByPath(img_quality, "txt_num")
            img_quality:setTexture( GetColorIconByQuality(data.quality) )
            img_content:setTexture(data.path)
            Public:addPieceImg(img_content, data)
            txt_num:setText("X" .. data.number)

            img_quality:setTouchEnabled(true)
            img_quality:addMEListener(TFWIDGET_CLICK,
                audioClickfun(function()
                    Public:ShowItemTipLayer(data.itemid, data.type)
                end)
            )
        end
    end

    self:refreshBoxInfo()
    for i = 1, #self.img_bg do
        -- local strPath = string.format("icon/rolebig/100%2d.png", self.roleIdList[i])
        -- self.img_bg[i].img_role:setTexture(strPath)
        self.img_bg[i].txt_reward:setText( stringUtils.format(localizable.WoodActivityLayer_tips3, self.boxNumTab[i]) )
        self.img_bg[i].txt_price:setText( WoodActivityManager.priceTab[i] )
    end

    self.historyDis = WoodActivityManager:getTotalDis()
    self:refreshBtns()
    self:addBeginScrollTimer()
end

function WoodActivityLayer:addBeginScrollTimer()
    if self.updateBeginTimerID then
        TFDirector:removeTimer(self.updateBeginTimerID)
        self.updateBeginTimerID = nil
    end

    if self.panelItem then
        for i = 1, #self.panelItem do
            self.panelItem[i]:setPositionX( self.bgPanelWidth * (i - 1) )
        end
    end
    self.updateBeginTimerID = TFDirector:addTimer(30, -1, nil,
        function()
            self:scrollBeginBg()
        end
    )
end

function WoodActivityLayer:scrollBeginBg()
    local idxTab1 = {1, 2}
    local idxTab2 = {2, 1}
    local idxTab = {idxTab1, idxTab2}
    for i = 1, 2 do
        self.panelItem[i]:setPositionX(self.panelItem[i]:getPositionX() - self.BEGIN_MOVE_SPEED)
    end

    for i = 1, 2 do
        if self.panelItem[ idxTab[i][1] ]:getPositionX() <= -self.bgPanelWidth then
            self.panelItem[ idxTab[i][1] ]:setPositionX(self.panelItem[ idxTab[i][2] ]:getPositionX() + self.bgPanelWidth)
        end
    end
end

function WoodActivityLayer:refreshBtns()
    local goodsTab = WoodActivityManager:getGoodsTab()
    local priceTab = WoodActivityManager:getPriceTab()
    for i = 1, 3 do
        local tool = BagManager:getItemById(tonumber(goodsTab[i]))
        self.img_bg[i].img_res_icon:setVisible(true)
        if tool and tool.num >= 1 then
            self.img_bg[i].img_res_icon:setTexture(tool:GetPath()) 
            self.img_bg[i].img_res_icon:setScale(0.4)
            self.img_bg[i].txt_price:setText("1") 
            self.img_bg[i].txt_have:setVisible(true)
            self.img_bg[i].txt_have:setText(stringUtils.format(localizable.changetProLayer_have ,tool.num))
        else
            self.img_bg[i].img_res_icon:setTexture("ui_new/common/xx_yuanbao_icon.png")
            self.img_bg[i].img_res_icon:setScale(1)
            self.img_bg[i].txt_price:setText(priceTab[i])
            self.img_bg[i].txt_have:setVisible(false)
        end    
    end

    local boxIndex = WoodActivityManager:getBoxIndex()
    local round = WoodActivityManager:getRound()
    local boxCounts = WoodActivityManager:getBoxCounts()
    if boxIndex >= 0 and boxIndex <= 5 then
        if boxIndex == 5 then
            boxIndex = 0
            round = round + 1
        end   
        local nextBoxCount = boxCounts[boxIndex + 1] + round * boxCounts[5]   
        local open_state = true
        if WoodActivityManager:getTotalDis() < nextBoxCount then
            open_state = false
        end 
        WoodActivityManager.bRed = open_state
    end    

    local freeTimes = WoodActivityManager:getFreeTimes()
    if freeTimes > 0 then
        self.img_bg[1].img_res_icon:setVisible(false)
        self.img_bg[1].txt_price:setText(localizable.WoodActivityLayer_tips5)
        WoodActivityManager.bFreeRed = true
        self.img_bg[1].txt_have:setVisible(false)
    else
        WoodActivityManager.bFreeRed = false   
    end  
    CommonManager:setRedPoint(self.btn_select[1], WoodActivityManager.bFreeRed, "boxOpen", ccp(2, 5))  
end

function WoodActivityLayer:refreshBoxInfo()
    local boxRewardList = WoodActivityManager:getBoxRewardList()
    local boxIndex = WoodActivityManager:getBoxIndex()
    local boxCounts = WoodActivityManager:getBoxCounts()
    local round = WoodActivityManager:getRound()
    local listCount = #boxRewardList
    for i = 1, listCount do
        self.panel_boxes[i].rootNode:setVisible(true)
        if i > boxIndex then
            local count = boxCounts[i] + round * boxCounts[5]
            self.panel_boxes[i].txt_num:setText( stringUtils.format(localizable.WoodActivityLayer_tips4 ,count))                      
            self.panel_boxes[i].btn.count = count
        else
            local count = boxCounts[i] + (round + 1) * boxCounts[5]
            self.panel_boxes[i].txt_num:setText(stringUtils.format(localizable.WoodActivityLayer_tips4 ,count)) 
            self.panel_boxes[i].btn.count = count
        end   
    end
    for i = listCount + 1, 5 do
        self.panel_boxes[i].rootNode:setVisible(false)
    end

    self.new_btn_boxs = {}
    for i = boxIndex + 1, listCount do
        table.insert(self.new_btn_boxs, self.panel_boxes[i])
    end
    for i = 1, boxIndex do
        table.insert(self.new_btn_boxs, self.panel_boxes[i])
    end

    for i = 1, listCount do
        local posX = 100 + ( i - 1 ) * 113
        self.new_btn_boxs[i].rootNode:setPositionX(posX)    
    end

    self:brushBoxRedPoint()
end

function WoodActivityLayer:brushBoxRedPoint()
    local open_state = true 
    local dis = WoodActivityManager:getTotalDis()
    local count = self.new_btn_boxs[1].btn.count
    if dis < count then
        open_state = false
    end 
    CommonManager:setRedPoint(self.new_btn_boxs[1].btn, open_state, "boxOpen", ccp(-6, -12)) 
    
    for i = 2, 5 do
        CommonManager:setRedPoint(self.new_btn_boxs[i].btn, false, "boxOpen", ccp(-6, -12)) 
    end
end

function WoodActivityLayer:onShow()
    self.super.onShow(self)
    self:refreshBaseUI()

    if self.rankLayer_show then
        self.img_di:setPositionX(-228)
    else
        self.img_di:setPositionX(0)
    end
    --self:showBeginPage()
end

function WoodActivityLayer:changeDis(dis)
    self.txt_dis:setText(dis)
end

function WoodActivityLayer:changeGetBoxNum(num)
    if not self.bStopNum then
        self.txt_box_num:setText("X" .. num)
    end
end

function WoodActivityLayer:showFlyPage(roleId)
    self.roleId = roleId
    self.bg_table:setVisible(true)
    self.Panel_flying:setVisible(true)
    self.Panel_begin:setVisible(false)
    self.Panel_Paihang:setVisible(false)
    self.btn_help:setVisible(false)
    self.Panel_smbx:setVisible(false)
    self.btn_close:setVisible(false)
    self.Panel_bg2:setVisible(false)
    self.img_rewardbg:setVisible(true)
    self.btn_history:setVisible(false)
    self.pageId = 2
    self.dis = WoodActivityManager.disOneTime or 0
    local dis = self.dis % self.BG_DIS
    self.bPreStart = true
    self.disOneTime = 0

    if self.updateBeginTimerID then
        TFDirector:removeTimer(self.updateBeginTimerID)
        self.updateBeginTimerID = nil
    end
    self:clearFastEffect()
    self:initFastEffect()
    self:changeDis(self.historyDis)
    self:changeGetBoxNum(0)
    if self.historyDis % self.BG_DIS == 0 then
        self.needDis = 0
    else
        self.needDis = self.BG_DIS - self.historyDis % self.BG_DIS
    end
    self.totalWidth = self.BG_WIDTH / self.BG_DIS * WoodActivityManager.disOneTime
    self.totalWidth1 = self.BG_WIDTH / self.BG_DIS * (WoodActivityManager.disOneTime + self.historyDis)
    self.bStartMove = false
    self.firstUp = true
    self:initRole()
    self:resetBg()
    self:moveToStandPos()
    self:addScrollTimer()
end 

function WoodActivityLayer:resetBg()
    for i = 1, 2 do
        self.nodeItem[i]:setTag(i)
        self.nodeItem[i]:setPositionX( (i - 1) * self.bgWidth )
        for j = 1, #bgPathTab do
            local img = TFDirector:getChildByPath(self.nodeItem[i], bgPathTab[j])
            img:setVisible(false)
        end
        for j = 1, #self.bgShowPath[i] do
            local img = TFDirector:getChildByPath(self.nodeItem[i], self.bgShowPath[i][j])
            img:setVisible(true)
        end
        self.nodeItemBg[i]:setPositionX( (i - 1) * self.bgWidth )
    end

    self.offsetBgX = 0
    local nextDis = self.historyDis % 5
    local newDis = self.historyDis + 5 - nextDis
    self.newBoxStartDis = newDis

    if self.needDis > 0 then
        local img_box = TFDirector:getChildByPath( self.nodeItem[1], bgPathTab[6] )
        local img_box_new = TFDirector:getChildByPath( self.nodeItem[1], bgPathTab[7] )
        img_box:setVisible(true)

        if WoodActivityManager:isNewBox(newDis) then
            img_box_new:setVisible(true)
        else
            img_box_new:setVisible(false)
        end

        local posX = 568
        self.offsetBgX = self.needDis / self.BG_DIS * self.BG_WIDTH
        img_box:setPositionX( posX + self.offsetBgX ) 
        img_box_new:setPositionX( posX + self.offsetBgX )

        local box2 = TFDirector:getChildByPath( self.nodeItem[2], bgPathTab[6] )
        local box3 = TFDirector:getChildByPath( self.nodeItem[2], bgPathTab[7] )
        box2:setVisible(true)
        box2:setPositionX(self.offsetBgX + posX)
        if WoodActivityManager:isNewBox(newDis) then
            box3:setVisible(true)
        else
            box3:setVisible(false)
        end
        box3:setPositionX(self.offsetBgX + posX)
    else
        local img_box = TFDirector:getChildByPath( self.nodeItem[1], bgPathTab[6] )
        local img_box_new = TFDirector:getChildByPath( self.nodeItem[1], bgPathTab[7] )
        img_box:setVisible(false)
        img_box_new:setVisible(false)

        local posX = 568
        img_box:setPositionX( posX ) 
        img_box_new:setPositionX( posX ) 

        local box2 = TFDirector:getChildByPath( self.nodeItem[2], bgPathTab[6] )
        box2:setVisible(true)
        box2:setPositionX(posX)
        local box3 = TFDirector:getChildByPath( self.nodeItem[2], bgPathTab[7] )
        box3:setPositionX(posX)
        --box3:setVisible(false)

        if WoodActivityManager:isNewBox(newDis) then
            box3:setVisible(true)
        else
            box3:setVisible(false)
        end
    end
end

function WoodActivityLayer:refreshNodeItem(node, index)
    index = index or 1
    for i = 1, #bgPathTab do
        local img = TFDirector:getChildByPath(node, bgPathTab[i])
        img:setVisible(false)
    end
    for i = 1, #self.bgShowPath[index] do
        local img = TFDirector:getChildByPath(node, self.bgShowPath[index][i])
        img:setVisible(true)
    end
end

--初始化运动角色
function WoodActivityLayer:initRole()
    local roleId = self.roleId or 81
    local isNpc = false
    if roleId == 0 then
        roleId = MainPlayer:getProfession()
    end
    local roleTableData = nil
    if isNpc then
        roleTableData = NPCData:objectByID(roleId)
    else
        roleTableData = RoleData:objectByID(roleId)
    end
    if not self.rolePanel then
        self.rolePanel = self:createRoleArmature(roleId, roleTableData.image)
        self.bg_table:addChild(self.rolePanel)
    end
    local rolePanel = self.rolePanel 
    rolePanel:setZOrder(800)
    --self.rolePanel = rolePanel

    --local posY = self.bg_table:getPositionY() + self.bg_table:getSize().height / 2 - 100
    local posY = 320
    self.originY = posY
    self.rolePanel:setPosition( ccp( -300, posY ) )
    --self.bg_table:addChild(self.rolePanel)
end

function WoodActivityLayer:moveToStandPos()
    local armature = self.rolePanel.armature
    armature:play("move")
    local moveTween = {
        target = self.rolePanel,
        {
            duration = 0.5,
            x = 100,
            y = 320,
            onComplete = function()
                if self.selectIdx ~= 3 then
                    armature:play("stand", -1, -1, 1)
                else

                end
                TFDirector:killTween(moveTween)
                moveTween = nil
                self:onMoveToStandEnd()
            end,
        }
    }
    TFDirector:toTween(moveTween)
end

function WoodActivityLayer:onMoveToStandEnd()
    local function onDelayEnd()
        local armature = self.rolePanel.armature
        -- local moveTween = {
        --     target = self.rolePanel,
        --     {
        --         duration = 0.5,
        --         x = self.BG_WIDTH / 2,
        --         y = self.rolePanel:getPositionY(),
        --         onComplete = function()
        --             TFDirector:killTween(moveTween)
        --             moveTween = nil

        --             self.rolePanel:stopAllActions()
        --             TFDirector:killAllTween(self.rolePanel)

        --             self.bStartMove = true
        --         end,
        --     }
        -- }

        local function callFunc()
            self.rolePanel:stopAllActions()
            TFDirector:killAllTween(self.rolePanel)

            self.bStartMove = true
        end

        local frame = 1
        armature:addMEListener(TFARMATURE_UPDATE, function() 
            if frame <= self.frameConfig[self.selectIdx] then  
                frame = frame + 1
            elseif frame == self.frameConfig[self.selectIdx] + 1 then
                armature:removeMEListener(TFARMATURE_UPDATE)
                armature:play("move") 
                local moveTo = CCMoveTo:create(0.3, ccp( self.BG_WIDTH / 2, 320 ))
                local seq = CCSequence:createWithTwoActions(moveTo, CCCallFunc:create(callFunc))
                self.rolePanel:runAction(seq)
            end
        end)  
        if self.selectIdx == 3 then
            armature:play("skill") 
        else
            armature:play("attack") 
        end  
    end

    local delayTween = {
        target = self.rolePanel,
        {
            duration = 0.1,
            x = self.rolePanel:getPositionX(),
            onComplete = function()
                TFDirector:killTween(delayTween)
                delayTween = nil
                onDelayEnd()
            end,
        }
    }
    TFDirector:toTween(delayTween)
end

function WoodActivityLayer:createRoleArmature( roleId, armatureID )

	local resPathXML = "armature/"..armatureID..".xml"
	local resPathAlats = "armature/".. armatureID .. ".atlas" 
	local armature
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "armature/".. armatureID
		armature = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		armature = TFArmature:create(armatureID.."_anim")
	else
		armatureID = 10006
		TFResourceHelper:instance():addArmatureFromJsonFile("armature/"..armatureID..".xml")
		armature = TFArmature:create(armatureID.."_anim")
	end
	
	if armature == nil then
		assert(false, "armature"..armatureID.."create error")
		return
	end
    armature:setAnimationFps(GameConfig.ANIM_FPS)
    armature:setPosition(ccp(0, 0))
    armature:play("move", -1, -1, 1)

    local rolePanel = TFPanel:create()
    rolePanel:setSize(armature:getContentSize())
    rolePanel:addChild(armature)
    rolePanel.armature = armature
    return rolePanel
end

function WoodActivityLayer:addScrollTimer()
    if self.updateTimerID then
        TFDirector:removeTimer(self.updateTimerID)
        self.updateTimerID = nil
    end
    self.dis = 0
    self.vy = 1
    self.disY = 10
    self.getBoxOffsetX = 30
    self.modeTab = nil
    self.stateY = self.EnumYMoveState.UP
    self.bStopNum = false
    self:changeGetBoxNum(0)
    self.originX = 520 + 40
    self.skipOne = true
    local node = TFDirector:getChildByPath(self.nodeItem[2], bgPathTab[6]) 
    node:setVisible(true)
    self.updateTimerID = TFDirector:addTimer(30, -1, nil,
        function()
            self:scrollBg()
        end
    )
end

function WoodActivityLayer:scrollBg()
    if not self.bStartMove then
        return
    end
    self.rolePanel:setPositionX(self.originX)
    local idxTab1 = {1, 2}
    local idxTab2 = {2, 1}
    local idxTab = {idxTab1, idxTab2}
    
    local v = self.MoveSpeed[self.selectIdx]
    
    for i = 1, 2 do
        self.nodeItem[i]:setPositionX(self.nodeItem[i]:getPositionX() - v)
        self.nodeItemBg[i]:setPositionX(self.nodeItemBg[i]:getPositionX() - v * self.bgSpeedFactor)
    end
    local dis = math.floor( self.disOneTime / (self.BG_WIDTH / self.BG_DIS) ) + self.historyDis
    if self.disOneTime <= self.totalWidth then
        self:changeDis(dis)
        self.disOneTime = self.disOneTime + v
    end

    local iidx = math.floor(self.disOneTime / self.BG_WIDTH)
    if iidx % 2 == 0 then
        self.iidx = 1
    else
        self.iidx = 2
    end

    self.nodeItem[self.iidx]:setZOrder(30)
    self.nodeItem[3 - self.iidx]:setZOrder(20)

    if self.skipOne and self.needDis ~= 0 and self.disOneTime >= self.needDis * self.BG_WIDTH / self.BG_DIS then
        self:playHitBox( self.nodeItem[ self.iidx ], 1 )
        self.skipOne = false
    elseif self.disOneTime >= self.BG_WIDTH  then
        local modNum = math.floor( (self.disOneTime - self.needDis * self.BG_WIDTH / self.BG_DIS) / self.BG_WIDTH)
        self:playHitBox( self.nodeItem[ self.iidx ], modNum + 1 )
    end

    for i = 1, 2 do
        if self.nodeItem[ idxTab[i][1] ]:getPositionX() <= -self.bgWidth then
            self:refreshNodeBg(self.disOneTime, self.nodeItem[ idxTab[i][1] ])
            self.nodeItem[ idxTab[i][1] ]:setPositionX(self.nodeItem[ idxTab[i][2] ]:getPositionX() + self.bgWidth)
        end
        if self.nodeItemBg[ idxTab[i][1] ]:getPositionX() <= -self.bgWidth then
            self.nodeItemBg[ idxTab[i][1] ]:setZOrder(10)
            self.nodeItemBg[ idxTab[i][1] ]:setPositionX(self.nodeItemBg[ idxTab[i][2] ]:getPositionX() + self.bgWidth)
        end
    end

    self.vy = self.vy or 1
    local pY = self.rolePanel:getPositionY()
    if pY >= self.originY + self.disY then
        self.stateY = self.EnumYMoveState.DOWN
    end
    local strAct = "move"
    if pY <= self.originY - self.disY then
        self.stateY = self.EnumYMoveState.UP
    end

    local disFall = self.totalWidth
    if self.disOneTime >= disFall then
        self.stateY = self.EnumYMoveState.FALL
    end 
    --self.rolePanel.armature:play("move")
    
    if self.stateY == self.EnumYMoveState.UP then
        self.rolePanel:setPositionY( pY + self.vy )
    elseif self.stateY == self.EnumYMoveState.DOWN then
        self.rolePanel:setPositionY( pY - self.vy )
    elseif self.stateY == self.EnumYMoveState.FALL then
    --     self.vy = self.fallSpeed
    --     self.rolePanel:setPositionY( pY - self.vy )
    -- elseif self.stateY == self.EnumYMoveState.DIE then
        if self.rolePanel then 
            if self.rolePanel:getPositionY() < -50 then
                if self.updateTimerID then
                    TFDirector:removeTimer(self.updateTimerID)
                    self.updateTimerID = nil
                end
                self:showReward( self, self.showBeginPage )
            else
                self.vy = self.fallSpeed
                self.rolePanel:setPositionY( pY - self.vy )
            end 
        end
    end

    if self.stateY < self.EnumYMoveState.FALL then
        self:playFastEffect( true )
        for i = 1, 2 do
            local boxNode = TFDirector:getChildByPath(self.nodeItem[i], "img_baoxiang")
            local boxNodeNew = TFDirector:getChildByPath(self.nodeItem[i], "img_smbxicon")
            local pos = boxNode:convertToWorldSpace(ccp(0, 0))
            if pos.x < self.BOX_HIDE_DIS then
                boxNode:setVisible(false)
                --change1
                boxNodeNew:setVisible(false)
            end
        end
    else
        self:playFastEffect( false )
    end
end

function WoodActivityLayer:playHitBox( node, modNum )
    if (not modNum) or ( modNum > WoodActivityManager:getBoxNum() + 1 ) then
        return
    end
    self.modeTab = self.modeTab or {}
    if not self.modeTab[modNum] then
        self.modeTab[modNum] = true
        local function callback()
            if self.stateY < self.EnumYMoveState.FALL then
                self:changeGetBoxNum(modNum)
            end
        end
        local iiidx = 1
        local p1 = self.nodeItem[1]:getPositionX()
        local p2 = self.nodeItem[2]:getPositionX()
        if p2 > p1 then
            iiidx = 2
        end
        for i = 1, 2 do
            local boxNode1 = TFDirector:getChildByPath(self.nodeItem[i], "img_baoxiang")
            boxNode1:setVisible(true)
            local boxNode2 = TFDirector:getChildByPath(self.nodeItem[i], "img_smbxicon")
            boxNode2:setVisible(false)

            if WoodActivityManager:isNewBox(self.newBoxStartDis + modNum * 5) and iiidx == i then
                boxNode2:setVisible(true)
            end
        end
        local boxNode = TFDirector:getChildByPath(node, "img_baoxiang")
        boxNode:setVisible(false)
        local img_smbxicon = TFDirector:getChildByPath(node, "img_smbxicon")
        img_smbxicon:setVisible(false)
        self:showNumChangeEffect(boxNode, callback)

        -- local countNum = self.newBoxStartDis + (modNum + 1) * 5
        -- if self.needDis == 0 then
        --     countNum = self.newBoxStartDis + modNum * 5
        -- end

        -- print("WoodActivityManager.totalDiskkkkkk ==>> ", WoodActivityManager.totalDis)
        -- if WoodActivityManager:isNewBox(countNum) then
        --     --self:showNumChangeEffect(img_smbxicon, callback)
        -- end
    end
end

function WoodActivityLayer:showNumChangeEffect(boxNode, callback)
    local pos = boxNode:convertToWorldSpace(ccp(0, 0))
    pos.x = self.EFFECT_BEGIN_X
    self:showFlyBegin(pos, callback)
end

function WoodActivityLayer:showFlyBegin(pos, flyMoveCallBack)
    play_chuangonghunpoyidong()

    local topos = pos
    local resPath = "effect/box_get_start.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local flyPic = TFArmature:create("box_get_start_anim")
    flyPic:setAnimationFps(GameConfig.ANIM_FPS)
    --flyPic:setPosition(ccp(topos.x + 80 , topos.y - 55))
    flyPic:setPosition(ccp(topos.x + 160, topos.y + 30))
    --flyPic:setScale(0.8)

    self:addChild(flyPic, 100)
    self.isMoved = false
    self.isShowStart = true
    self.isShowing = false
    flyPic:addMEListener(TFARMATURE_COMPLETE,function()
        flyPic:removeFromParentAndCleanup(true)
        flyPic:removeMEListener(TFARMATURE_COMPLETE) 
    end)
    local temp = 0
    flyPic:addMEListener(TFARMATURE_UPDATE,function()
        temp = temp + 1
        if temp == 2 then
            self:showFlyMove(pos, flyMoveCallBack)
        end
    end)

    flyPic:playByIndex(0, -1, -1, 0)
end

function WoodActivityLayer:showFlyMove(pos, flyMoveCallBack)
    play_chuangonghunpoyidong()


    --local topos = self.img_box:convertToWorldSpace(ccp(0, 0))
    local topos = pos

    local resPath = "effect/role_transfer_move.xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local moveEffect = TFArmature:create("role_transfer_move_anim")

    moveEffect:setAnimationFps(GameConfig.ANIM_FPS)
    --moveEffect:setPosition(ccp(topos.x + 220, topos.y))
    moveEffect:setPosition(ccp(topos.x + 160, topos.y + 40))

    self:addChild(moveEffect,100)

    moveEffect:playByIndex(0, -1, -1, 1)

    local designsize = CCDirector:sharedDirector():getOpenGLView():getDesignResolutionSize()
    local newx = designsize.width - 1136

    local toPos = topos
    local tween = 
    {
        target = moveEffect,
        {
            ease = {type=TFEaseType.EASE_IN_OUT, rate=9},
            duration = 0.5,
            --x = toPos.x + 470 + newx,
            x = toPos.x + 480 + newx,
            y = toPos.y - 230,
            onComplete = function ()
                self.isMoved = true
                self:showFlyEnd(flyMoveCallBack)
                moveEffect:removeFromParentAndCleanup(true)
            end,
        },
    }
    TFDirector:toTween(tween)
end

function WoodActivityLayer:showFlyEnd(cbFunc)
    self.isMoved = false
    self.isShowing = false
    self.isShowStart = false

    if self.endEffect == nil then
        local resPath = "effect/box_get_end.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local endEffect = TFArmature:create("box_get_end_anim")

        local idx = self.selectIdx or 1
        endEffect:setAnimationFps(GameConfig.ANIM_FPS * idx)
        --endEffect:setPosition(ccp(400, 330))
        local size = endEffect:getSize()
        endEffect:setPosition(ccp(size.width / 2, size.height / 2))
        self.img_box:addChild(endEffect, 100)
        
        endEffect:addMEListener(TFARMATURE_COMPLETE,function()
            endEffect:removeMEListener(TFARMATURE_COMPLETE) 
            endEffect:removeFromParentAndCleanup(true)
            self.endEffect = nil
        end)
        endEffect:playByIndex(0, -1, -1, 0)
        self.endEffect = endEffect
        local callFuncN = CCCallFuncN:create( function()
            cbFunc()
        end)
        local acArr = TFVector:create()
        local delayAc = CCDelayTime:create(0.2)
        acArr:addObject(delayAc)
        acArr:addObject(callFuncN)
        self.endEffect:runAction(CCSequence:create(acArr))
    end
end

function WoodActivityLayer:refreshNodeBg(dis, node)
    local index = 2
    local num = math.floor(dis / self.BG_WIDTH)
    local curIdx = math.min(index + num, 4)
    for i = 1, #bgPathTab do
        local widget = TFDirector:getChildByPath(node, bgPathTab[i])
        widget:setVisible(false)
    end
    for i = 1, #self.bgShowPath[curIdx] do
        print(self.bgShowPath[curIdx][i])
        local widget = TFDirector:getChildByPath(node, self.bgShowPath[curIdx][i])
        widget:setVisible(true)
    end
    local widget = TFDirector:getChildByPath(node, bgPathTab[6])
    widget:setVisible(true)
    widget:setPositionX( 568 + self.offsetBgX ) 

    local widget1 = TFDirector:getChildByPath(node, bgPathTab[7])
    widget1:setVisible(false)
    widget1:setPositionX( 568 + self.offsetBgX ) 
end

function WoodActivityLayer:stopAction()
    if self.updateTimerID then
        TFDirector:removeTimer(self.updateTimerID)
        self.updateTimerID = nil
    end
end

function WoodActivityLayer.onBgClickHandle(sender)
    local self = sender.logic
    AlertManager:close()
end

function WoodActivityLayer:refreshBaseUI()

end

function WoodActivityLayer:refreshUI()
    
end

function WoodActivityLayer.onBoxClickHandle(sender)
    local self = sender.logic
end

function WoodActivityLayer:removeUI()
    self.super.removeUI(self);
end

function WoodActivityLayer:dispose()
    self.super.dispose(self)
    --TFAudio.unloadEffect("sound/effect/chuangong-hunpoyidong.mp3")

    if self.end_timerID then
        TFDirector:removeTimer(self.end_timerID)
        self.end_timerID = nil
    end
end

function WoodActivityLayer:registerEvents()
    self.super.registerEvents(self);  
     
    self.ui:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBgClickHandle)) 

    for i = 1, 3 do
        self.btn_select[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSelectBtnClickHandle)) 
    end

    for k, v in pairs(self.panel_boxes) do
        v.btn.logic = self
        v.btn.index = k
        v.btn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnGetBox))
    end
    self.btn_history.logic = self
    self.btn_history:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onHistoryClick))

    self.btn_close:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnCloseClickHandle))
    self.btn_help:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnHelpClickHandle))   
    self.btn_jifen:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnclikOpenRankLayer), 1)
    self.btn_shuaxin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnclikRefreshRankLayer), 1)
    self.Panel_flying:setTouchEnabled(true)
    self.Panel_flying:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onPanelFlyingClickHandle))
    self.Panel_flying.logic = self

    self.onSelectResult = function(event)
        local idx = self.selectIdx or 1
        local roleId = self.roleIdList[idx]
        self:showFlyPage(roleId)
    end
    TFDirector:addMEGlobalListener(WoodActivityManager.WOOD_MAN_RESULT, self.onSelectResult)

    self.RefreshRankListCallBack = function(event)
        self:refreshRankList()
    end
    TFDirector:addMEGlobalListener(WoodActivityManager.FRESH_WOOD_MAN_RANK_RESULT, self.RefreshRankListCallBack)

    self.onBoxResult = function(event)
        --self:showBeginPage()
        self:refreshBoxInfo()
    end
    TFDirector:addMEGlobalListener(WoodActivityManager.WOOD_MAN_EXTRA_REWARD, self.onBoxResult)

    self.onSpecialBoxResult = function(event)
        self:showBeginPage()
    end
    TFDirector:addMEGlobalListener(WoodActivityManager.WOOD_MAN_SPECIAL_REWARD_RESULT, self.onSpecialBoxResult)
end

function WoodActivityLayer:refreshRankList()
    if self.tableView == nil then
        local  tableView =  TFTableView:create()
        tableView:setTableViewSize(self.panel_gun:getContentSize())
        tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
        tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
        tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.rank_cellSizeForTable)
        tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.rank_tableCellAtIndex)
        tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.rank_numberOfCellsInTableView)
        self.tableView = tableView
        self.tableView.logic = self
        self.panel_gun:addChild(tableView)
    end
    self.tableView:reloadData()

    local txt_paiming = TFDirector:getChildByPath(self.img_di, 'txt_paiming')
    local rank_txt = TFDirector:getChildByPath(txt_paiming, 'txt_num')
    local txt_jifen = TFDirector:getChildByPath(self.img_di, 'txt_jifen')
    local txt_score = TFDirector:getChildByPath(txt_jifen, 'txt_num')
    if WoodActivityManager.myRank.rank > 0 and WoodActivityManager.myRank.rank <= 50 then
        rank_txt:setText(WoodActivityManager.myRank.rank)
    else
        rank_txt:setText(localizable.shalu_info_txt1)
    end
    txt_score:setText(WoodActivityManager.myRank.score)
end

function WoodActivityLayer.rank_numberOfCellsInTableView(table)
    return WoodActivityManager.rankList:length()
end

function WoodActivityLayer.rank_cellSizeForTable(table, idx)
    local self = table.logic
    if self.isCrossServer then
        return 80,190
    else
        return 60,190
    end
    return 60,190
end

function WoodActivityLayer.rank_tableCellAtIndex(table, idx)
    local cell = table:dequeueCell()
    local self = table.logic
    if nil == cell then
        cell = TFTableViewCell:create()
        local panel_rank = nil
        if self.isCrossServer then
            panel_rank = self.panel_rank:clone()
        else
            panel_rank = self.panel_rank_2:clone()
        end
        panel_rank:setVisible(true)
        panel_rank:setPosition(ccp(0,0))
        cell:addChild(panel_rank)
        cell.panel_rank = panel_rank
    end
    local rankInfo = WoodActivityManager.rankList:getObjectAt(idx+1)
    if rankInfo then
        self:loadRankInfo( rankInfo , cell.panel_rank )
    else
        cell.panel_rank:setVisible(false)
    end
    return cell
end

function WoodActivityLayer:loadRankInfo(rankInfo, panel)
    panel:setVisible(true)

    local txt_name = TFDirector:getChildByPath(panel, 'txt_name')
    local txt_num = TFDirector:getChildByPath(panel, 'txt_num')
    local txt_xuhao = TFDirector:getChildByPath(panel, 'txt_xuhao')
    txt_name:setText(rankInfo.name)
    txt_num:setText(rankInfo.score)
    txt_xuhao:setText(rankInfo.rank)
    --print("self.isCrossServer = ",self.isCrossServer)
    if self.isCrossServer then
        local txt_server = TFDirector:getChildByPath(panel, 'txt_server')
        if txt_server then
            txt_server:setText("（"..rankInfo.serverName.."）")
        end
    end
end

function WoodActivityLayer.onSelectBtnClickHandle(sender)
    local self = sender.logic
    local index = sender.index
    self.selectIdx = index

    local tool = BagManager:getItemById(tonumber(WoodActivityManager.consumeGoodsTab[index]))  
    self.freeTimes = WoodActivityManager:getFreeTimes()
    --首先判断免费次数
    if self.freeTimes > 0 and index == 1 then 
        self:requestInfo(1, 0) 
        --self.freeTimes = self.freeTimes - 1   
    elseif tool and tool.num > 0 then --物品不足
        self:requestInfo(index, tool.num)
    else
        if MainPlayer:isEnoughSycee(tonumber(WoodActivityManager.priceTab[index]), true) then--物品不足 判断元宝
            self:requestInfo(index, 0)
        end            
    end   
end

function WoodActivityLayer:requestInfo(index, toolNumber)
    if index == 1 then  --一次
        WoodActivityManager:requestSelectWood( self.REQUEST_DIS[index] )
    elseif index == 2 then
        WoodActivityManager:requestSelectWood( self.REQUEST_DIS[index] )
    elseif index == 3 then
        if toolNumber == 0 then
            if WoodActivityManager.bTips == false then
                CommonManager:showOperateSureTipLayer(
                    function(data, widget)
                        WoodActivityManager:requestSelectWood( self.REQUEST_DIS[index] )
                        WoodActivityManager.bTips = widget:getSelectedState() or false;
                    end,
                    function(data, widget)
                        AlertManager:close()
                        WoodActivityManager.bTips = widget:getSelectedState() or false;
                    end,
                    {
                        title = localizable.WoodActivityLayer_tips1,
                        msg = stringUtils.format(localizable.WoodActivityLayer_tips2, WoodActivityManager.priceTab[3]),
                        showtype = AlertManager.BLOCK_AND_GRAY
                    }
                ) 
            else
                WoodActivityManager:requestSelectWood( self.REQUEST_DIS[index] )
            end
        else
            WoodActivityManager:requestSelectWood( self.REQUEST_DIS[index] )
        end
    end 
end

function WoodActivityLayer.onHistoryClick(sender)
    local layer  = require("lua.logic.woodActivity.WoodRecordLayer"):new()
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show()
end

function WoodActivityLayer.onBtnGetBox(sender)
    local self = sender.logic
    local idx = sender.index
    local count = sender.count
    local boxIndex = WoodActivityManager:getBoxIndex()

    local dis = WoodActivityManager:getTotalDis()
    local newcount = self.new_btn_boxs[1].btn.count

    if boxIndex + 1 ~= idx or ( boxIndex + 1 == idx and dis < newcount ) then
        WoodActivityManager:openBoxDetailLayer(idx, count)
        return
    end 
    WoodActivityManager:requestGetExtraReward(sender.index)
end

function WoodActivityLayer.specialIconCallback(sender)
    local self = sender.logic
    local sta = sender.sta
    local data = sender.data
    if (sender.isActivityEnd) then
        toastMessage(localizable.smritiMain_tips1)
        return
    end
    WoodActivityManager:openChoiceLayer(data, sta)
end

function WoodActivityLayer.onBtnCloseClickHandle(sender)
    AlertManager:close()
end

function WoodActivityLayer.onBtnHelpClickHandle(sender)
    CommonManager:showRuleLyaer( 'heroontherun' )
end

function WoodActivityLayer.OnclikRefreshRankLayer(sender)
    WoodActivityManager:requestRefreshRank()
end

function WoodActivityLayer.onPanelFlyingClickHandle(sender)
    local self = sender.logic
    self:showReward( self, self.showBeginPage ) 
end

function WoodActivityLayer.OnclikOpenRankLayer(sender)
    local self = sender.logic
    if self.rank_tween ~= nil then
        TFDirector:killTween(self.rank_tween)
    end
    if self.rankLayer_show then
        self.rank_tween = {
            target = self.img_di,
            {
                duration = 0.3,
                ease = {type=TFEaseType.EASE_IN_OUT, rate=3},
                x = 0,
            },
        }
        self.rankLayer_show = false
    else
        self.rank_tween = {
            target = self.img_di,
            {
                duration = 0.3,
                ease = {type=TFEaseType.EASE_IN_OUT, rate=3},
                x = -228,
            },
        }
        self.rankLayer_show = true
    end
    TFDirector:toTween(self.rank_tween)
end

function WoodActivityLayer:showReward( logic, func )
    if self.updateTimerID then
        TFDirector:removeTimer(self.updateTimerID)
        self.updateTimerID = nil
    end

    self:playFastEffect(false)

    if self.rolePanel then
        self.rolePanel:stopAllActions()
        self.rolePanel:removeFromParent()
        self.rolePanel = nil
    end
    self:changeGetBoxNum( WoodActivityManager:getBoxNum() )
    self.bStopNum = true
    self:changeDis( WoodActivityManager:getTotalDis() )
    WoodActivityManager:openResultLayer( logic, func )
end

function WoodActivityLayer:removeEvents()
    self.super.removeEvents(self)

    TFDirector:removeMEGlobalListener(WoodActivityManager.FRESH_WOOD_MAN_RANK_RESULT, self.RefreshRankListCallBack)
    self.RefreshRankListCallBack = nil

    TFDirector:removeMEGlobalListener(WoodActivityManager.WOOD_MAN_RESULT, self.onSelectResult)
    self.onSelectResult = nil

    TFDirector:removeMEGlobalListener(WoodActivityManager.WOOD_MAN_EXTRA_REWARD, self.onBoxResult)
    self.onBoxResult = nil

    TFDirector:removeMEGlobalListener(WoodActivityManager.WOOD_MAN_SPECIAL_REWARD_RESULT, self.onSpecialBoxResult)
    self.onSpecialBoxResult = nil

    if self.updateTimerID then
        TFDirector:removeTimer(self.updateTimerID)
        self.updateTimerID = nil
    end

    if self.updateBeginTimerID then
        TFDirector:removeTimer(self.updateBeginTimerID)
        self.updateBeginTimerID = nil
    end
end

function WoodActivityLayer:initFastEffect()
    for i = 1, 3 do
        if not self.upeffect[i] then
            local str = "xiakexing_fast_up"
            local resPath = "effect/ui/" .. str .. ".xml"
            TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
            local effect = TFArmature:create(str .. "_anim")
            local fps = GameConfig.ANIM_FPS
            if i == 2 then
                fps = fps * self.selectIdx
            elseif i == 3 then
                fps = fps * 0.5
            end
            effect:setAnimationFps(fps)
            effect:setPosition(ccp(GameConfig.WS.width / 2, GameConfig.WS.height / 2))
            effect:setVisible(false)
            self.upeffect[i] = effect
            self.bg_table:addChild(effect, 200)
        end
    end
    for i = 1, 3 do
        if not self.downeffect[i] then
            local str = "xiakexing_fast_down"
            local resPath = "effect/ui/" .. str .. ".xml"
            TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
            local effect = TFArmature:create(str .. "_anim")
            local fps = GameConfig.ANIM_FPS
            if i == 2 then
                fps = fps * self.selectIdx
            elseif i == 3 then
                fps = fps * 0.5
            end
            effect:setAnimationFps(fps)
            effect:setPosition(ccp(GameConfig.WS.width / 2, GameConfig.WS.height / 2))
            effect:setVisible(false)
            self.downeffect[i] = effect
            self.bg_table:addChild(effect, 31)
        end
    end
    self.effectState = {false, false}
end

function WoodActivityLayer:playFastEffect( bStart )
    local effTab = { self.upeffect, self.downeffect }
    if bStart then
        if not self.effectState[1] then
            for i = 1, 2 do
                for j = 1, 3 do
                    if j == 1 then 
                        effTab[i][j]:setVisible(true)
                    else
                        effTab[i][j]:setVisible(false)
                    end
                end
            end
            self.effectState[1] = true
            self:playFastEffectUp()
        end
    else
        if not self.effectState[2] then
            for i = 1, 2 do
                for j = 1, 3 do
                    if j == 3 then 
                        effTab[i][j]:setVisible(true)
                    else
                        effTab[i][j]:setVisible(false)
                    end
                end
            end
            self.effectState[2] = true
            self:playFastEffectDown()
        end
    end
end

function WoodActivityLayer:playFastEffectUp()
    local effTab = { self.upeffect, self.downeffect }
    for i = 1, 2 do
        effTab[i][1]:setVisible(true)
        effTab[i][1]:playByIndex(0, -1, -1, 0)
        effTab[i][1]:addMEListener(TFARMATURE_COMPLETE, function()
            effTab[i][1]:removeMEListener(TFARMATURE_COMPLETE)
            effTab[i][1]:setVisible(false)
            effTab[i][2]:setVisible(true)
            effTab[i][2]:playByIndex(1, -1, -1, 1)
        end)
    end
end

function WoodActivityLayer:playFastEffectDown()
    local effTab = { self.upeffect, self.downeffect }
    for i = 1, 2 do
        effTab[i][3]:setVisible(true)
        effTab[i][3]:playByIndex(2, -1, -1, 0)
        effTab[i][3]:addMEListener(TFARMATURE_COMPLETE, function()
            effTab[i][3]:removeMEListener(TFARMATURE_COMPLETE)
            effTab[i][3]:setVisible(false)
            self:clearFastEffect()
        end)
    end
end

function WoodActivityLayer:clearFastEffect()
    self.downeffect = self.downeffect or {}
    for k, v in pairs(self.downeffect) do
        if v then
            v:removeFromParent()
            v = nil
        end
    end
    self.upeffect = self.upeffect or {}
    for k, v in pairs(self.upeffect) do
        if v then
            v:removeFromParent()
            v = nil
        end
    end
    self.downeffect = {}
    self.upeffect = {}
end

return WoodActivityLayer;