local JiayuanLoginCodeLayer = class("JiayuanLoginCodeLayer", BaseLayer)

function JiayuanLoginCodeLayer:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.qiyu.CodeLayerAccept")
end

function JiayuanLoginCodeLayer:initUI(ui)
    self.super.initUI(self,ui)
    
    self.input_Verification1     = TFDirector:getChildByPath(ui, 'txt_shurukuang1')
    self.txt_inviteddesc1        = TFDirector:getChildByPath(ui, 'txt_inviteddesc')
    self.btn_Verification            = TFDirector:getChildByPath(ui, 'btn_woyao')
    self.btn_reward             = TFDirector:getChildByPath(ui, 'btn_reward')
    self.btn_Close              = TFDirector:getChildByPath(ui, 'btn_close')
    self.img_di1 = TFDirector:getChildByPath(ui, "img_di1")
    self.txt_wenben1 = TFDirector:getChildByPath(ui, "txt_wenben1")
    self.txt_wenben1:setVisible(false)

    self.img_reward = TFDirector:getChildByPath(ui, 'panel_item')
    self.panel_reward = TFDirector:getChildByPath(ui, 'panel_reward')
    self.img_reward:setVisible(false)

    self.input_Verification1:setVisible(false)
    self.txt_inviteddesc1:setVisible(false)
    self.btn_Verification:setVisible(false)
    self.btn_reward:setVisible(false)
    self.btn_Close:setVisible(true)
    self.img_di1:setVisible(false)

    self.txt_wenben2 = TFDirector:getChildByPath(ui, "txt_wenben2")
    self.panel_code = TFDirector:getChildByPath(ui, "panel_code")
    self.btn_queding = TFDirector:getChildByPath(ui, "btn_queding")
    self.btn_queding.logic = self
    self.img_di2 = TFDirector:getChildByPath(ui, "img_di2")

    self.txt_wenben2:setVisible(true)
    self.panel_code:setVisible(true)
    self.btn_queding:setVisible(true)
    self.img_di2:setVisible(true)

    self.input_Verification = TFDirector:getChildByPath(ui, 'txt_shurukuang2')
    self.txt_inviteddesc = TFDirector:getChildByPath(ui, 'txt_inviteddesc2')

    self.input_Verification:setMaxLengthEnabled(true)
    self.input_Verification:setMaxLength(12)

    self.bFirstTouchInInput = false
    local function onTextFieldAttachHandle(input)
        if self.bFirstTouchInInput == false then
            self.bFirstTouchInInput = true
            self.input_Verification:setText("")
        end
    end

    self.input_Verification:addMEListener(TFTEXTFIELD_ATTACH, onTextFieldAttachHandle)
end

function JiayuanLoginCodeLayer:registerEvents(ui)
    self.super.registerEvents(self)

    ADD_ALERT_CLOSE_LISTENER(self, self.btn_Close)
    self.btn_queding.logic = self
    self.btn_queding:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onClickQueding),1)
end

function JiayuanLoginCodeLayer:removeEvents()
    self.super.removeEvents(self)
end


function JiayuanLoginCodeLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end


function JiayuanLoginCodeLayer:refreshUI()
    -- required int32 myCode = 1;                   //自己的邀请码
    -- required bool invited = 2;                   //自己是否验证过别人的邀请码
    -- required bool invitedAward = 3;              //是否已领受邀奖
    -- required int32 inviteCount = 4;          //邀请好友次数
    -- required string getRewardRecord = 5;         //邀请领奖记录，格式:id_达到条件次数_已领次数&id_次数...

    self.InviteCodeInfo = QiyuManager:GetInviteCodeData()


    self.Invited = self.InviteCodeInfo.Invited

     -- 已被邀请
    if self.InviteCodeInfo.Invited then
        self.btn_Verification:setTouchEnabled(false)
        self.btn_Verification:setGrayEnabled(true)
        self.input_Verification:setVisible(false)
        self.txt_inviteddesc:setVisible(true)
        --self.txt_inviteddesc:setText("你已被邀请")
        self.txt_inviteddesc:setText(localizable.InFriendAccLayer_invite)
        print("已被邀请")
    else
        print("没有被邀请")
        self.txt_inviteddesc:setVisible(false)
        self.input_Verification:setVisible(true)
        --self.input_Verification:setPlaceHolder("请输入邀请码")
        --self.input_Verification:setPlaceHolder(localizable.InFriendAccLayer_input_invite_code)
        
        local code = QiyuManager:getLoginAcceptCode()
        print(">>>>> get code: ??? ", code)

        if code and code == 0 then
            code = TFDeviceInfo:getClipBoardText()
            --print(">>>>> TFDeviceInfo:getClipBoardText() >>>  ", code)
        end

        if code and code ~= 0 then 
            if string.find(tostring(code), "^-?[1-9]%d*$") then
                self.input_Verification:setPlaceHolder(code) 
            elseif string.find(tostring(code), "%b##") then
                local a1, a2 = string.find(tostring(code), "%b##")
                if a1 and a2 then
                    local str = string.sub(tostring(code), a1 + 1, a2 - 1)
                    if string.find(tostring(str), "^-?[1-9]%d*$") then
                        self.input_Verification:setPlaceHolder(str)
                    end
                end
            end          
        else
            self.input_Verification:setPlaceHolder(localizable.InFriendAccLayer_input_invite_code)
        end  
    end

    -- local bIsGetReward = self.InviteCodeInfo.invitedAward
    -- self.btn_reward:setGrayEnabled(bIsGetReward)
    -- self.btn_reward:setTouchEnabled(not bIsGetReward)

    self.btn_reward:setVisible(false)

    local beInvitedRewardId = ConstantData:getValue("Invite.Receive.RewardId")

    self.rewardList = RewardConfigureData:GetRewardItemListById(beInvitedRewardId)

    self:drawRewardList()
end

function JiayuanLoginCodeLayer.onClickQueding(sender)
    local self = sender.logic
    local str = self.input_Verification:getText()
    print("JiayuanLoginCodeLayer.onClickQueding(sender) >>> ", str)
    QiyuManager:setLoginAcceptCode(str)
    AlertManager:close()
end

--[[
function JiayuanLoginCodeLayer.onclickVerification(sender)
    local self = sender.logic

    if self.Invited ~= true then
        local code = self.input_Verification:getText()
        if string.len(code) == 0 then
            --toastMessage("请输入邀请码")
            toastMessage(localizable.InFriendAccLayer_input_invite_code)
        else

            if string.find(code, "^-?[1-9]%d*$") then
                QiyuManager:VerifyInviteCode(code)
            else
                --toastMessage("输入的邀请码包含了非法字符")
                toastMessage(localizable.InFriendAccLayer_char)
            end
        end
    else
        --toastMessage("已经被邀请过了")
        toastMessage(localizable.InFriendAccLayer_already)
    end
end
]]

function JiayuanLoginCodeLayer:drawRewardList()
    if self.titleTableView ~= nil then
        self.titleTableView:reloadData()
        return
    end

    local  titleTableView =  TFTableView:create()
    titleTableView:setTableViewSize(self.panel_reward:getContentSize())
    titleTableView:setDirection(TFTableView.TFSCROLLHORIZONTAL)
    titleTableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    titleTableView:setPosition(self.panel_reward:getPosition())
    self.titleTableView = titleTableView
    self.titleTableView.logic = self

    titleTableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
    titleTableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
    titleTableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
    titleTableView:reloadData()

    self.panel_reward:getParent():addChild(self.titleTableView,1)

    print("self.panel_reward:getContentSize() = ", self.panel_reward:getContentSize())
end


function JiayuanLoginCodeLayer.numberOfCellsInTableView(table)
    local self  = table.logic
    -- local num   = #self.titleList

    return self.rewardList:length()
end

function JiayuanLoginCodeLayer.cellSizeForTable(table,idx)
    return 200, 120
end

function JiayuanLoginCodeLayer.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    local node = nil
    if nil == cell then
        table.cells = table.cells or {}
        cell = TFTableViewCell:create()
        table.cells[cell] = true

        node = self.img_reward:clone()
        node:setScale(0.8)

        node:setPosition(ccp(0, 90))
        cell:addChild(node)
        node:setTag(617)
        node.logic = self
        -- node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onClickTitle))
    end

    node = cell:getChildByTag(617)
    node.index = idx + 1
    self:drawInviteNode(node)

    node:setVisible(true)
    return cell
end


function JiayuanLoginCodeLayer:drawInviteNode(node)
    local index =  node.index
    local rewardItem = self.rewardList:objectAt(index)

    Public:loadIconNode(node,rewardItem)
end

return JiayuanLoginCodeLayer