-- ///////////////////////////////////////////////////
-- @Author:             shenjingjie
-- @Create Date:        2016-12-15 11:43:11
-- @Title:              Type_ZhouNianQ
-- @Describe:           周年庆签到活动
-- ///////////////////////////////////////////////////

local Type_ZhouNianQ = class("Type_ZhouNianQ", BaseLayer)

Type_ZhouNianQ.col = 4
Type_ZhouNianQ.itemWidth = 135
Type_ZhouNianQ.itemHeight = 144


function Type_ZhouNianQ:ctor(type)
    self.super.ctor(self)
    self.id = type
    local activityInfo = AnniversaryManager:getActivityInfo(self.id)
    if activityInfo ~= nil then
        self.type   = activityInfo.type
    end
    
    self:init("lua.uiconfig_mango_new.operatingactivities.011")
end

function Type_ZhouNianQ:initUI(ui)
    self.super.initUI(self,ui)
    self.img_award              = TFDirector:getChildByPath(ui, 'img_award')

    self.scroll_view            = TFDirector:getChildByPath(ui, 'scroll_view')
    self.panel_content          = TFDirector:getChildByPath(ui, 'panel_content')
    self.txt_time               = TFDirector:getChildByPath(ui, 'txt_time')
    self.txt_content            = TFDirector:getChildByPath(ui, 'txt_content')
    self.img_yichongzhi         = TFDirector:getChildByPath(ui, 'img_yichongzhi')
    self.img_yixiaofei          = TFDirector:getChildByPath(ui, 'img_yixiaofei')
    self.img_denglu             = TFDirector:getChildByPath(ui, 'img_denglu')

    self.img_reward             = TFDirector:getChildByPath(ui, 'img_reward')

    local pos = self.img_reward:getPosition()

    local height = 0

    local activity      = AnniversaryManager:getActivityInfo(self.id)

    self.lastTime = activity.signTime
    self.nowDayIndex = activity.progress
    --init reward information
    self.rewardWidgetArray = {}
    local position = ccp(20, self.img_reward:getPosition().y-160)
    local CarniValSigninData = CarniValSigninData:getCarniValSignData()
    local topY = position.y
    local index = 0
    for i,v in pairs(CarniValSigninData) do
        local widget = createUIByLuaNew("lua.uiconfig_mango_new.qiyu.SignEntity");
        position.x = ( index % self.col ) * self.itemWidth + 35
        position.y = topY - ( math.floor(index / self.col) ) * self.itemHeight
        widget:setPosition(ccp(position.x,position.y))
        self.panel_content:addChild(widget)
        widget.index = i
        if (i <= self.nowDayIndex) then
        	widget.isSign = true 
        else
        	widget.isSign = false 
        end
        
        table.insert(self.rewardWidgetArray, i, widget)
        
        -- if (i = self.col - 1) then
        -- 	position.y = position.y - ( i / self.col ) * self.itemHeight
        -- 	height = position.y - ( i / self.col ) * self.itemHeight
        -- end
        self:drawSignItem(i)
        index = index + 1
    end
    height = position.y

    -- 动态调整高度
    height = 0 - height
    local scrollViewContentsize = self.scroll_view:getContentSize().height
    if height < scrollViewContentsize then
        height = scrollViewContentsize
    end

    -- self.rewardWidgetArray = rewardWidgetArray

    -- self:resortReward()
    self:refreshUI()

    local size = self.scroll_view:getInnerContainerSize()

    -- print("size1 = ", size)
    -- print("height = ", height)
    self.scroll_view:setInnerContainerSize(CCSizeMake(size.width, height))
    size = self.scroll_view:getInnerContainerSize()
    -- print("size2 = ", size)

    -- 重设高度
    self.panel_content:setPosition(ccp(0, height))


    -- 
    self.img_yichongzhi:setVisible(false)
    self.img_yixiaofei:setVisible(false)
    self.img_denglu:setVisible(false)
end
function Type_ZhouNianQ:removeUI()
    self.super.removeUI(self)
end

function Type_ZhouNianQ:onShow()
    self.super.onShow(self)
    self:refreshUI()

end

function Type_ZhouNianQ:dispose()
    self.super.dispose(self)
end

function Type_ZhouNianQ:refreshUI()   
   
    local activity = AnniversaryManager:getActivityInfo(self.id)

    if not activity then
        self.txt_time:setText("")
        self.txt_content:setText("")

    else
        self.txt_time:setText(localizable.Anniversary_Time[self.id])   
        self.txt_content:setText(activity.details)
    end

end
function Type_ZhouNianQ:registerEvents()
    print("Type_ZhouNianQ:registerEvents()------------------")
    self.super.registerEvents(self)
    self.receiveInfo = function (event)
    --     local CarniValList = CarniValShopData:getCarniValShopData()

    --     for i,v in pairs(CarniValList) do
    --         local rewardId = v.id
    --         local widget = self.rewardWidgetArray:objectByID(rewardId)
    --         local activityReward = AnniversaryManager:getActivityInfo(self.id).activityReward
    --         local progress = activityReward:objectByID(rewardId).progress
    --         widget:setStatus(progress)
    --     end
    --     -- local rewardId = event.data[1][1].id
    --     -- local progress = event.data[1][1].progress
    --     -- local widget = self.rewardWidgetArray:objectByID(rewardId)
        
    --     self:resortReward()
        local activity      = AnniversaryManager:getActivityInfo(self.id)

        self.lastTime = activity.signTime
        self.nowDayIndex = activity.progress
        local widget = self.rewardWidgetArray[self.nowDayIndex]
        local img_sign      = TFDirector:getChildByPath(widget, 'img_yiqiandao')
        self:playSignEffect(widget, false)
        img_sign:setVisible(true)
    end

    TFDirector:addMEGlobalListener(AnniversaryManager.MSG_SIGN_UPDATE,self.receiveInfo)
    
end

function Type_ZhouNianQ:removeEvents()
    print("Type_ZhouNianQ:removeEvents()------------------")
    TFDirector:removeMEGlobalListener(AnniversaryManager.MSG_SIGN_UPDATE,self.receiveInfo)
    self.receiveInfo = nil

    self.super.removeEvents(self)
end

function Type_ZhouNianQ:drawSignItem(id)

	local node = self.rewardWidgetArray[id]
 	local singNode  = TFDirector:getChildByPath(node, 'panel_wuping')
    singNode.Parent = node
    singNode.logic  = self
    singNode:addMEListener(TFWIDGET_CLICK, audioClickfun(self.touchSignNode))

    local panel_info = TFDirector:getChildByPath(node, 'panel_info')

    --没有双倍,隐藏
    local img_vipBg     = TFDirector:getChildByPath(node, 'img_vipdi')
    img_vipBg:setVisible(false)

    local lbl_goodsNum  = TFDirector:getChildByPath(node, 'txt_num')
    local lbl_goodsName = TFDirector:getChildByPath(node, 'txt_name')
    local img_goodsIcon = TFDirector:getChildByPath(node, 'img_wuping')
    local img_sign      = TFDirector:getChildByPath(node, 'img_yiqiandao')
    local img_choose    = TFDirector:getChildByPath(node, 'img_xuanzhong')
    local img_itemBg    = TFDirector:getChildByPath(node, 'img_pinzhikuang')
    local img_zhezhao   = TFDirector:getChildByPath(node, 'img_zhezhao')
    local img_di        = TFDirector:getChildByPath(node, 'img_di')
    local img_di1       = TFDirector:getChildByPath(node, 'img_di1')

    img_di1:setVisible(false)

    --控制已签到标签的隐藏 
    if (id > self.nowDayIndex) then
        img_sign:setVisible(false)
    end

    -- 控制遮罩的隐藏
	img_zhezhao:setVisible(node.isSign)

	--绘制选中框
    local bThisNodeNeedSign = false
    img_choose:setVisible(false)
    --判断今天是否签到
    local nowTiem = os.date("*t", MainPlayer:getNowtime())
    local lastTiemDate = os.date("*t", self.lastTime * 0.001)
    -- if (nowTiem.yday ~= lastTiemDate.yday) then
    -- 未签到的最后一个
    if (id == (self.nowDayIndex + 1) and node.isSign == false and nowTiem.yday ~= lastTiemDate.yday) then
        -- img_choose:setVisible(true)
        img_di1:setVisible(true)
        bThisNodeNeedSign = true
    end
    self:playSignEffect(node, bThisNodeNeedSign)

    -- 已签到的最后一个
    if (id == self.nowDayIndex and node.isSign == true and nowTiem.yday == lastTiemDate.yday) then
        img_di1:setVisible(true)
        -- img_gouxuan:setVisible(false)
        img_sign:setVisible(true)
    end

    img_di:setVisible(not img_di1:isVisible())

    if img_di1:isVisible() then
        lbl_goodsName:setColor(ccc3(0,0,0))
    else
        lbl_goodsName:setColor(ccc3(0x3d,0x3d,0x3d))
    end

    local signData = CarniValSigninData:objectByID(id)
	local tmp = stringToNumberTable(signData.award, '_')
    local rewardItem = {type = tmp[1], itemid = tmp[2], number = tmp[3] }

    local itemInfo = BaseDataManager:getReward(rewardItem)
    if (itemInfo == nil) then
        print("ERROR--> ",rewardItem)
        toastMessage(localizable.common_data_error_tips)
        return
    end
     -- 绘制物品icon 及 名称
    if rewardItem.type == EnumDropType.ROLE then
        local role      = RoleData:objectByID(rewardItem.itemid)
        local headIcon  = role:getIconPath()
        img_goodsIcon:setTexture(headIcon)
        
    else
        img_goodsIcon:setTexture(itemInfo.path)
    end
    Public:addPieceImg(img_goodsIcon, {type = rewardItem.type, itemid = rewardItem.itemid},false);
    lbl_goodsNum:setText(rewardItem.number)

    img_itemBg:setTexture(GetColorIconByQuality(itemInfo.quality))
    lbl_goodsName:setText(stringUtils.format(localizable.common_index_day, id))


end 
function Type_ZhouNianQ.touchSignNode(sender)
    local self = sender.logic
    local node  = sender.Parent --.index
    print("Type_ZhouNianQ.touchSignNode tag = %d", node.index)
    local id = node.index 
    if sender.Parent.isVsible == false then
        print("Type_ZhouNianQ.touchSignNode")
        return
    end

    local showItem = true
    local nowTiem = os.date("*t", MainPlayer:getNowtime())
    local lastTiemDate = os.date("*t", self.lastTime * 0.001)
    if (nowTiem.yday ~= lastTiemDate.yday) then
        if (id ~= self.nowDayIndex + 1) then
            showItem = true       
        else            
            AnniversaryManager:SignRequest(id)
            showItem = false
        end
    -- else
    --     toastMessage(localizable.Anniversary_tis1)    
    end
    -- -- 今天已经签过到了
    -- if (node.isSign and id == (self.nowDayIndex + 1)) then
    --     print("今天已经签过到了")
    --     -- toastMessage("今天已经签过到了")
    -- elseif (id == (self.nowDayIndex + 1)) then
    --     print("请求签到")
    --     AnniversaryManager:SignRequest(id)
    --     showItem = false
    -- end

    if showItem then
        print("showItem ---", node.index)
        local signData = CarniValSigninData:objectByID(id)
		local tmp = stringToNumberTable(signData.award, '_')
    	local reward_item = {type = tmp[1], itemid = tmp[2], number = tmp[3] }

        Public:ShowItemTipLayer(reward_item.itemid, reward_item.type)
    end
end
function Type_ZhouNianQ:playSignEffect(titleNode, playEffect)
    if titleNode == nil then
        return
    end

    if playEffect == false then
        if titleNode.signEffect then
            titleNode.signEffect:removeFromParent()
            titleNode.signEffect = nil
        end
        return
    end

    if titleNode.signEffect then
        titleNode.signEffect:removeFromParent()
        titleNode.signEffect = nil
    end


    if playEffect == true and titleNode.signEffect == nil then
        print("add effect ")
        local resPath = "effect/sign.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("sign_anim")

        effect:setAnimationFps(GameConfig.ANIM_FPS)

        titleNode:addChild(effect,2)
        effect:setPosition(ccp(55, 25))

        effect:setAnchorPoint(ccp(0.5, 0.5))
        titleNode.signEffect = effect
    end

        print("play effect ")
    titleNode.signEffect:playByIndex(0, -1, -1, 1)
end

return Type_ZhouNianQ