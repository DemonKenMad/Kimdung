-- client side RedPacketRankLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2016-08-06

local RedPacketRankLayer = class("RedPacketRankLayer",BaseLayer)

function RedPacketRankLayer:ctor(data)
	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.faction.Factionhbpaihang")
end

function RedPacketRankLayer:initUI( ui )
	self.super.initUI(self, ui)

    self.btn_close = TFDirector:getChildByPath(ui, "btn_close")
    self.panel_list = TFDirector:getChildByPath(ui, "Panel_paiming")    
    
    self.txt_myrank = TFDirector:getChildByPath(ui, "txt_rank")
    self.txt_weirubang = TFDirector:getChildByPath(ui, "txt_weirubang")
    self.txt_myscore = TFDirector:getChildByPath(ui, "txt_shuliang")
    
    self.panel_cell = TFDirector:getChildByPath(ui, "img_paimingbg")
    self.panel_cell:retain()
    self.panel_cell:removeFromParent()
    self.panel_cell:setVisible(false)

    self.btn_more = TFDirector:getChildByPath(ui, "btn_more")
    self.btn_more:retain()
    self.btn_more:removeFromParent()
    self.btn_more:setVisible(false)

    self.img_linedi = TFDirector:getChildByPath(ui, "img_yinying")
    self.img_linedi:setVisible(false)


    self:createTableView()
end

function RedPacketRankLayer:removeUI()
    if self.panel_cell then
        self.panel_cell:release()
        self.panel_cell = nil
    end

    if self.btn_more then
        self.btn_more:release()
        self.btn_more = nil
    end
	self.super.removeUI(self)    
end

function RedPacketRankLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function RedPacketRankLayer:refreshUI()   
    self.tableView:reloadData()

    local myRank = RedPacketManager:getMyRankInfo().rank or 0
    if myRank > 0 then
        self.txt_weirubang:setVisible(false)
        self.txt_myrank:setText(myRank)
    else
        self.txt_weirubang:setVisible(true)
        self.txt_myrank:setText("")
    end
    local myScore = RedPacketManager:getMyIntegral() or 0
    self.txt_myscore:setText(myScore)
    
end

function RedPacketRankLayer:createTableView()
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
    self.tableView:addMEListener(TFTABLEVIEW_SCROLL, self.tableScroll)
end

function RedPacketRankLayer:registerEvents()
	self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)

    self.onBrushRankInfoHandler = function(event)
        self:refreshUI()
    end;
    TFDirector:addMEGlobalListener(RedPacketManager.RECEIVE_RANK_INFO ,self.onBrushRankInfoHandler)
end

function RedPacketRankLayer:removeEvents()
    TFDirector:removeMEGlobalListener(RedPacketManager.RECEIVE_RANK_INFO ,self.onBrushRankInfoHandler)
    
    self.super.removeEvents(self)
end

function RedPacketRankLayer:dispose()
	self.super.dispose(self)
end

function RedPacketRankLayer.cellSizeForTable(table,idx)
    local num = RedPacketRankLayer.numberOfCellsInTableView()
    if idx + 1 == num then
        return 70,630
    end
    return 85, 630
end

function RedPacketRankLayer.numberOfCellsInTableView(table)
    local num = #RedPacketManager:getRankList() + 1
    return num
end

function RedPacketRankLayer.tableCellAtIndex(table, idx)
    local self = table.logic

    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        cell.btn_more = nil
        cell.panel = nil
    end

    local rankList = RedPacketManager:getRankList()
    local rankInfo = rankList[idx + 1]
    if idx + 1 > #rankList then
        self:setBtnMoreInfo(cell, idx)
    else
        self:setPanelRankInfo(cell, rankInfo, idx + 1)
    end
    return cell
end

function RedPacketRankLayer.ongBtnMoreHanle(sender)
    local self = sender.logic
    local index = sender.index
    local num = #RedPacketManager:getRankList()
    num = math.ceil(num / 10) + 10
    RedPacketManager:requestGetRankInfo(num)
end

function RedPacketRankLayer:setBtnMoreInfo(cell, idx )
    if cell.btn_more == nil then
        local btn_more = self.btn_more:clone()
        btn_more:setPosition(ccp(648 * 0.5,33))
        btn_more:setVisible(true)
        cell:addChild(btn_more)
        cell.btn_more = btn_more
        cell.btn_more:addMEListener(TFWIDGET_CLICK, audioClickfun(self.ongBtnMoreHanle))
    end
    cell.btn_more:setVisible(true)
    if cell.panel then
        cell.panel:setVisible(false)
    end 
end

function RedPacketRankLayer:setPanelRankInfo(cell, rankInfo, rank)
    if cell.panel == nil then
        local panel = self.panel_cell:clone()
        panel:setPosition(ccp(648 * 0.5,40))
        panel:setVisible(true)
        cell:addChild(panel)
        cell.panel = panel
    end
    cell.panel:setVisible(true)
    if cell.btn_more then
        cell.btn_more:setVisible(false)
    end
    local playerName = TFDirector:getChildByPath(cell.panel, "txt_playername")
    local guildName = TFDirector:getChildByPath(cell.panel, "txt_bangpai")
    local lbScore = TFDirector:getChildByPath(cell.panel, "txt_jine")
    local bg_icon = TFDirector:getChildByPath(cell.panel, "bg_touxiang")
    local img_head = TFDirector:getChildByPath(cell.panel, "img_head")
    if rankInfo ~= nil then
        local roleConfig = RoleData:objectByID(rankInfo.icon)                     --pck change head icon and head icon frame
        if nil == roleConfig then
            roleConfig = RoleData:objectByID(1)
        end
        img_head:setTexture(roleConfig:getIconPath())
        Public:addFrameImg(img_head,rankInfo.frame)                    --end
        Public:addInfoListen(img_head,true,1,rankInfo.playerId)
        bg_icon:setVisible(true)
        playerName:setText(rankInfo.name or '')
        guildName:setText(rankInfo.guildName or '')
        lbScore:setText(rankInfo.sycee)
    else
        playerName:setText('')
        guildName:setText('')
        lbScore:setText('')
        bg_icon:setVisible(false)
    end

    local img_rank = TFDirector:getChildByPath(cell.panel, "img_mingci")
    local txt_rank = TFDirector:getChildByPath(cell.panel, "txt_paiming")
    if rank <= 3 then
        img_rank:setVisible(true)
        txt_rank:setVisible(false)
        img_rank:setTexture("ui_new/leaderboard/no"..rank..".png")
    else
        img_rank:setVisible(false)
        txt_rank:setVisible(true)
        txt_rank:setText(rank)
    end
end

function RedPacketRankLayer.tableScroll(table)
    local self = table.logic
    local currPosY = self.tableView:getContentOffset().y
    local sizeHeight = self.tableView:getContentSize().height
    local size = self.tableView:getSize().height

    if currPosY >= 0 then
        self.img_linedi:setVisible(false)
    else
        self.img_linedi:setVisible(true)
    end
end

return RedPacketRankLayer