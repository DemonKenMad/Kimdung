local FriendTeam = class("FriendTeam", BaseLayer)
local friendInfoList = {}

function FriendTeam:ctor(data)
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.friends.FriendTeam")
    self.name = "FriendTeam"
end



function FriendTeam:initUI(ui)
	self.super.initUI(self,ui)
    self.generalHead = CommonManager:addGeneralHead(self, 10)
    self.generalHead:setData(ModuleType.Friend, {HeadResType.COIN, HeadResType.SYCEE})
    --
    --self.txt_friendLen  = TFDirector:getChildByPath(ui, "txt_sl")
    local panel_content     = TFDirector:getChildByPath(ui, "panel_content")

    self.txt_friendLen      = TFDirector:getChildByPath(ui, "txt_hysl")
    local txt_sl = TFDirector:getChildByPath(ui, "txt_sl")
    txt_sl:setVisible(false)


    -- table view
    local tableViewPanel = TFDirector:getChildByPath(ui, "Panel_List")
    self.tableViewPanel = tableViewPanel

    local tableView = TFTableView:create()
    tableView:setTableViewSize(tableViewPanel:getContentSize())
    tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
    tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    tableViewPanel:addChild(tableView)
    self.tableView = tableView
end



function FriendTeam:onShow()
    self.super.onShow(self)
    if self.generalHead then
        self.generalHead:onShow()
    end
    -- self:refreshUI()
end

function FriendTeam:registerEvents()
    self.super.registerEvents(self);
    if self.generalHead then
        self.generalHead:registerEvents()
    end
    FriendManager:requestFriendList()
    --KingOfWarManager:requestJoinTeam()
    self.tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, FriendTeam.cellSizeForTable)
    self.tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, FriendTeam.tableCellAtIndex)
    self.tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, FriendTeam.numberOfCellsInTableView)

    self.onUpdateList = function(event)
        local friends= FriendManager:getFriendInfoList()
        local openLevel = FunctionOpenConfigure:getOpenLevel(2217)
        friendInfoList = {}
        friendLen = 0
        for i, v in ipairs(friends) do
            -- v.info.give = v.give
            if v.info.level >= openLevel and KingOfWarManager:checkIsInMyTeamByPlayerID(v.info.playerId) == false then
                local fInfo = v.info                
                fInfo.isInvitation = KingOfWarManager:checkInvitationFriendTable(fInfo.playerId)
                if fInfo.isInvitation == false then
                    friendLen = friendLen + 1
                end
                table.insert(friendInfoList, fInfo)
            end
        end

        -- self.txt_friendLen:setText(#friendInfoList .. "/" .. #friendInfoList)
        self.txt_friendLen:setText(localizable.KingWarFriendNum..friendLen)
        self.tableView:reloadData()
    end
    TFDirector:addMEGlobalListener(FriendManager.UpdateList, self.onUpdateList)
   
    -- self.onUpdateTeamInfo = function(event)
    --     self:refreshUI()
    -- end
    --TFDirector:addMEGlobalListener(KingOfWarManager.UpdateTeamInfoMsg, self.onUpdateTeamInfo)
end

function FriendTeam:refreshUI()    
    -- local friends= FriendManager:getFriendInfoList()
    -- for i, v in ipairs(friends) do
    --     v.info.give = v.give
    --     friendInfoList[i] = v.info
    -- end
    -- self.txt_friendLen:setText(#friends .. "/" .. #friends)
    -- self.tableView:reloadData()
end

function FriendTeam.tableCellAtIndex(table, idx)        
    local cell = table:dequeueCell()
    local self = table.logic
    local messagePanel = nil
    local idChat = idx + 1
    if nil == cell then
        cell = TFTableViewCell:create()
        local friendCell = require("lua.logic.friends.FriendCell"):new()
        cell.friendCell = friendCell
        cell:addChild(friendCell)
    end
    cell.friendCell:setInfo(4, friendInfoList[idChat])
    -- cell.friendCell:setTeamListInfo(friendInfoList[idChat].isInvitation)
    return cell
end

function FriendTeam.cellSizeForTable(table,idx)
   return 148,731
end

function FriendTeam.numberOfCellsInTableView(tableV)
   -- local self = tableV.logic
    return #friendInfoList
end

function FriendTeam:createChatInfo(idx)
    local messagePanel = require('lua.logic.chat.PublicMessageCell'):new()
    messagePanel:setPosition(ccp(0,0))
    messagePanel:setLogic(self)
    messagePanel.txt_msg:setVisible(true)
   return messagePanel
end

function FriendTeam:refreshChatInfo(messagePanel, idx)
    messagePanel.txt_msg:setText(self.charList[idx])
    messagePanel.txt_vip:setText("o"..MainPlayer:getVipLevel())
    messagePanel.txt_name:setText(MainPlayer:getPlayerName())
    messagePanel.txt_level:setText(MainPlayer:getLevel())

    local role = RoleData:objectByID(MainPlayer:getHeadIconId()) 
    if role then
        messagePanel.img_icon:setTexture(role:getIconPath())
    end
    messagePanel.txt_position:setVisible(false)
end

function FriendTeam:tableCellClick(cell)

end

function FriendTeam:removeEvents()
    if self.generalHead then
        self.generalHead:removeEvents()
    end
    TFDirector:removeMEGlobalListener(FriendManager.UpdateList, self.onUpdateList)
    self.onUpdateList = nil
--    TFDirector:removeMEGlobalListener(FriendManager.UpdateTeamInfoMsg, self.onUpdateTeamInfo)
--    self.onUpdateTeamInfo = nil
    self.super.removeEvents(self)
end

function FriendTeam:dispose()
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
    self.super.dispose(self)
end

function FriendTeam:onHide()   

end

function BaseLayer:removeUI()
    self.ui = nil;
end

function FriendTeam.closeBtnClickHandle(sender)
    AlertManager:close(AlertManager.TWEEN_1);
end

return FriendTeam

