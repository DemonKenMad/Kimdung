-- dec江湖新贵
-- script writer fei
-- creation time 2017-01-17
local IllustrationUpStarLayer = class("IllustrationUpStarLayer", BaseLayer)
IllustrationUpStarLayer.titleImg = {
    "ui_new/handbook/img_jhxgxj.png",
    "ui_new/handbook/img_xmybxj.png",
    "ui_new/handbook/img_wlmxxj.png",
    "ui_new/handbook/img_ydzsxj.png",
    "ui_new/handbook/img_shcsxj.png"
}
function IllustrationUpStarLayer:ctor(type)
    self.super.ctor(self)
    self.type = type
    self:init("lua.uiconfig_mango_new.handbook.QunXiaTabsInfo2")
end

function IllustrationUpStarLayer:initUI(ui)
    self.super.initUI(self,ui)
    self.btn_close          = TFDirector:getChildByPath(ui, 'btn_close')
    local scrollView        = TFDirector:getChildByPath(ui, 'panel_list1')
    local img_title         = TFDirector:getChildByPath(ui, 'img_title')
    img_title:setTexture(IllustrationUpStarLayer.titleImg[self.type])
    self.scrollView = scrollView
    self.mode = {}
    for i=1,2 do
        self.mode[i] = TFDirector:getChildByPath(ui, 'Panel_'..i )
        self.mode[i]:setVisible(false)
        self.mode[i]:removeFromParent()
        self.mode[i]:retain()
    end
    self.modeSize = self.mode[1]:getContentSize()

    self.haveStarNum     = IllustrationManager:getByCategoryZhuanJiStarNum(self.type)
    self.attrList        = IllustrationManager:getByCategoryStarList(self.type)
 
    self:initTableView(scrollView)
end

function IllustrationUpStarLayer:registerEvents(ui)
    self.super.registerEvents(self)
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close)
end

function IllustrationUpStarLayer:removeEvents()
    self.super.removeEvents(self)

end

function IllustrationUpStarLayer:removeUI()
    for i,v in ipairs(self.mode) do
        if (v) then
            v:release()
            v = nil
        end
    end
end

function IllustrationUpStarLayer:onShow()
    self.super.onShow(self)
end

function IllustrationUpStarLayer:initTableView(panel_list)
    if self.tableView == nil then
        local  tableView =  TFTableView:create()
        tableView:setTableViewSize(panel_list:getContentSize())
        tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
        tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
        tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, IllustrationUpStarLayer.cellSizeForTable)
        tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, IllustrationUpStarLayer.tableCellAtIndex)
        tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, IllustrationUpStarLayer.numberOfCellsInTableView)
        tableView:setPosition(panel_list:getPosition())
        panel_list:getParent():addChild(tableView, 99)
       -- tableView:setBounceable(false);
        self.tableView = tableView
        self.tableView.logic = self
    end
    self.tableView:reloadData()
end


function IllustrationUpStarLayer.cellSizeForTable(table,idx)
    local self = table.logic
    return (self.modeSize.height - 20), self.modeSize.width
end

function IllustrationUpStarLayer.tableCellAtIndex(table, idx)
    idx = idx + 1
    local self = table.logic
    local cell = table:dequeueCell()
    if nil == cell then
        cell = TFTableViewCell:create()
        local panelList = {}
        for i=1,2 do
            local node = self.mode[i]:clone()
            node:setVisible(false)
            cell:addChild(node)
            panelList[i] = node
        end
        cell.panelList = panelList
    end
    self:setCellInfo(cell, idx)
    return cell
end

function IllustrationUpStarLayer.numberOfCellsInTableView(table)
    local self = table.logic
    return #self.attrList
end

function IllustrationUpStarLayer:setCellInfo(cell,idx)
    idx = tonumber(idx)
    
    local node      = cell.panel_1
    local info      = self.attrList[idx]
    if (info) then
        local starNum   = tonumber(info.star)
        for i=1,2 do
            cell.panelList[i]:setVisible(false)
        end
        local id = 1
        if (self.haveStarNum >= starNum) then
            id = 2
        end

        local node = cell.panelList[id]
        node:setVisible(true)
        local txt_numb  = TFDirector:getChildByPath(node, 'txt_numb')
        local txt_1     = TFDirector:getChildByPath(node, 'txt_1')
        local txt_2     = TFDirector:getChildByPath(node, 'txt_2')
        local txt_numb  = TFDirector:getChildByPath(node, 'txt_numb')
        local arrtTab   = string.split(info.attribute, "_")
        local arrtId    = tonumber(arrtTab[1]) or 0
        local arrtValue = tonumber(arrtTab[2]) or 0

        txt_1:setText(stringUtils.format(localizable.IllustrationUpStar_tips1, starNum))
        txt_2:setText(stringUtils.format(localizable.IllustrationUpStar_tips2, AttributeTypeStr[arrtId], arrtValue))
        txt_numb:setVisible(id == 1)
        txt_numb:setText(self.haveStarNum.."/"..starNum)
    end
end
return IllustrationUpStarLayer