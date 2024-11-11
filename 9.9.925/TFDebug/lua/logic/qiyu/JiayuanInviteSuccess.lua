local JiayuanInviteSuccess = class("JiayuanInviteSuccess", BaseLayer)

function JiayuanInviteSuccess:ctor()
    self.super.ctor(self)
    self:init("lua.uiconfig_mango_new.qiyu.FamilyInviteSuccess")
end

function JiayuanInviteSuccess:initUI(ui)
    self.super.initUI(self,ui)

    self.img_reward = TFDirector:getChildByPath(ui, 'panel_item')
    self.panel_reward = TFDirector:getChildByPath(ui, 'panel_reward')
    self.img_reward:setVisible(false)
    self.btn_Close = TFDirector:getChildByPath(ui, "btn_close")
end

function JiayuanInviteSuccess:registerEvents(ui)
    self.super.registerEvents(self)

    ADD_ALERT_CLOSE_LISTENER(self, self.btn_Close)
end

function JiayuanInviteSuccess:removeEvents()
    self.super.removeEvents(self)
end

function JiayuanInviteSuccess:onShow()
    self.super.onShow(self)
    self:refreshUI()
end


function JiayuanInviteSuccess:refreshUI()
    -- required int32 myCode = 1;                   //自己的邀请码
    -- required bool invited = 2;                   //自己是否验证过别人的邀请码
    -- required bool invitedAward = 3;              //是否已领受邀奖
    -- required int32 inviteCount = 4;          //邀请好友次数
    -- required string getRewardRecord = 5;         //邀请领奖记录，格式:id_达到条件次数_已领次数&id_次数...

    self.InviteCodeInfo = QiyuManager:GetInviteCodeData()
    self.Invited = self.InviteCodeInfo.Invited
    local beInvitedRewardId = ConstantData:getValue("Invite.Receive.RewardId")

    self.rewardList = RewardConfigureData:GetRewardItemListById(beInvitedRewardId)

    --if self.InviteCodeInfo.Invited then
        self:drawRewardList()
    --end
end

function JiayuanInviteSuccess:drawRewardList()
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
end


function JiayuanInviteSuccess.numberOfCellsInTableView(table)
    local self  = table.logic

    return self.rewardList:length()
end

function JiayuanInviteSuccess.cellSizeForTable(table,idx)
    return 200, 120
end

function JiayuanInviteSuccess.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    local node = nil
    if nil == cell then
        table.cells = table.cells or {}
        cell = TFTableViewCell:create()
        table.cells[cell] = true

        node = self.img_reward:clone()
        node:setScale(0.8)

        node:setPosition(ccp(65, 90))
        cell:addChild(node)
        node:setTag(617)
        node.logic = self
    end

    node = cell:getChildByTag(617)
    node.index = idx + 1
    self:drawInviteNode(node)

    node:setVisible(true)
    return cell
end


function JiayuanInviteSuccess:drawInviteNode(node)
    local index =  node.index
    local rewardItem = self.rewardList:objectAt(index)

    Public:loadIconNode(node,rewardItem)
end

return JiayuanInviteSuccess