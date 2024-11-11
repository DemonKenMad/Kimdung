-- client side RedPacketLuckRankLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2016-08-06


local RedPacketLuckRankLayer = class("RedPacketLuckRankLayer",BaseLayer)

function RedPacketLuckRankLayer:ctor(data)
	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.faction.Factionhbsqph")
end

function RedPacketLuckRankLayer:initUI( ui )
	self.super.initUI(self, ui)

    self.btn_close = TFDirector:getChildByPath(ui, "btn_close")
    self.panel_list = TFDirector:getChildByPath(ui, "Panel_paiming")    
    self.img_title = TFDirector:getChildByPath(ui, "img_title")

    self.txt_myscore = TFDirector:getChildByPath(ui, "txt_lingqunumber")
    self.txt_weilingqu = TFDirector:getChildByPath(ui, "txt_weilingqu")
    self.txt_weilingqu:setVisible(false)
    self.panel_cell = TFDirector:getChildByPath(ui, "img_paimingbg")
    self.panel_cell:setAnchorPoint(ccp(0,0))
    self.panel_cell:retain()
    self.panel_cell:removeFromParent()
    self.panel_cell:setVisible(false)

    self.img_linedi = TFDirector:getChildByPath(ui, "img_yinying")
    self.img_linedi:setVisible(false)


    self:createTableView()
end

function RedPacketLuckRankLayer:removeUI()
    if self.panel_cell then
        self.panel_cell:release()
        self.panel_cell = nil
    end
	self.super.removeUI(self)    
end

function RedPacketLuckRankLayer:onShow()
    self.super.onShow(self)
    self:refreshUI()
end

function RedPacketLuckRankLayer:setInfo( gmid )
    self.gmid = gmid
    self.redPacket = RedPacketManager:getRedPacketByGmId(self.gmid)
    if self.redPacket.type == 1 then
        self.img_title:setTexture("ui_new/faction/hongbao/title_hyhbsqph.png")
    end
    RedPacketManager:sortRedPacketLucky(self.redPacket)
end

function RedPacketLuckRankLayer:refreshUI()   
    if self.redPacket == nil then
        AlertManager:close()
        return
    end
    self.tableView:reloadData()

    local myScore = self.redPacket.myNum or 0
    if myScore and myScore <= 0 then
        self.txt_weilingqu:setVisible(true)
        self.txt_myscore:setText("")
    else
        self.txt_weilingqu:setVisible(false)
        self.txt_myscore:setText(myScore)
    end
end

function RedPacketLuckRankLayer:createTableView()
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

function RedPacketLuckRankLayer:registerEvents()
	self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)

end

function RedPacketLuckRankLayer:removeEvents()
    self.super.removeEvents(self)
end

function RedPacketLuckRankLayer:dispose()
	self.super.dispose(self)
end

function RedPacketLuckRankLayer.cellSizeForTable(table,idx)
    return 66, 550
end

function RedPacketLuckRankLayer.numberOfCellsInTableView(table)
    local self = table.logic
    if self.redPacket and self.redPacket.receiver then
        return #self.redPacket.receiver
    end
    return 0
end

function RedPacketLuckRankLayer.tableCellAtIndex(table, idx)
    local self = table.logic

    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.panel_cell:clone()
        panel:setPosition(ccp(19,0))
        panel:setVisible(true)
        cell:addChild(panel)
        cell.panel = panel
    end
    local rankInfo = self.redPacket.receiver[idx + 1]
    self:setPanelRankInfo(cell.panel, rankInfo, idx + 1)
    return cell
end

function RedPacketLuckRankLayer:setPanelRankInfo(panel, rankInfo, rank)
    local txt_rank = TFDirector:getChildByPath(panel, "LabelBMFont_Factionhbpaihang_1")
    local txt_name = TFDirector:getChildByPath(panel, "txt_playername")
    local txt_num = TFDirector:getChildByPath(panel, "txt_jine")
    txt_name:setText(rankInfo.name)
    txt_num:setText(rankInfo.sycee)
    txt_rank:setText(rank)
end

function RedPacketLuckRankLayer.tableScroll(table)
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

return RedPacketLuckRankLayer