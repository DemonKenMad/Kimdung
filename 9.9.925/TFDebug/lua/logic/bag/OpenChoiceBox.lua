
local OpenChoiceBox = class("OpenChoiceBox", BaseLayer);

CREATE_SCENE_FUN(OpenChoiceBox);
CREATE_PANEL_FUN(OpenChoiceBox);

OpenChoiceBox.LIST_ITEM_HEIGHT = 90; 

function OpenChoiceBox:ctor(data)
    self.super.ctor(self,data);
    self:init("lua.uiconfig_mango_new.bag.BagGiftChoose");
end

function OpenChoiceBox:initUI(ui)
    self.super.initUI(self,ui);

    self.btn_close  = TFDirector:getChildByPath(self, 'btn_close');
    self.btn_get    = TFDirector:getChildByPath(self, 'btn_get');
    self.layer_list = TFDirector:getChildByPath(self, 'Panel_Gift');
    self.choiceList = {}
    self.nodeList = {}
    self.cellNode = createUIByLuaNew("lua.uiconfig_mango_new.bag.BagGiftChooseCell");
    self.cellNode:retain()
end

function OpenChoiceBox:setData(itemid)
    self.id = itemid
    local giftPackData = GiftPackData:objectByID(itemid)

    self.choiceNum = giftPackData.select_count
    self.giftGoodsList = split(giftPackData.goods, "|")
    print("---self.giftGoodsList----",self.giftGoodsList)

    local giftData    = self.giftGoodsList[1] or ""
    local giftDataInfo  = split(giftData, "_")
    self.itemId    = tonumber(giftDataInfo[2])
    self.data = ItemData:objectByID(self.itemId)

    self:drawBoxItemList()
    if #self.giftGoodsList > 4 then
        self.tableView:setTouchEnabled(true)
    else
        self.tableView:setTouchEnabled(false)
    end
end

function OpenChoiceBox:onShow()
    self.super.onShow(self)
end


function OpenChoiceBox:removeUI()
    self.super.removeUI(self);
    if self.cellNode then
        self.cellNode:release()
        self.cellNode = nil
    end   
end


--注册事件
function OpenChoiceBox:registerEvents()
    self.super.registerEvents(self);
    ADD_ALERT_CLOSE_LISTENER(self, self.btn_close);

    self.btn_get.logic = self
    self.btn_get:addMEListener(TFWIDGET_CLICK, audioClickfun(self.getBtnClickHandle))
end


function OpenChoiceBox:drawBoxItemList()
    if self.tableView ~= nil then
        self.tableView:reloadData()
        -- self.tableView:setScrollToBegin(false)
        return
    end

    local  tableView =  TFTableView:create()
    tableView:setTableViewSize(self.layer_list:getContentSize())
    tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
    tableView:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)
    tableView:setPosition(ccp(0,0))
    self.tableView = tableView
    self.tableView.logic = self

    tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, OpenChoiceBox.cellSizeForTable)
    tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, OpenChoiceBox.tableCellAtIndex)
    tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, OpenChoiceBox.numberOfCellsInOpenChoiceBox)
    tableView:reloadData()

    self.layer_list:addChild(self.tableView,1)
end

function OpenChoiceBox.cellSizeForTable(table, idx)
    --return 175,660
    local self = table.logic
    if self.data and self.data.type and self.data.type == EnumGameItemType.Gem then
        return 225, 660
    else
        return 175,660
    end
end

function OpenChoiceBox.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    local node = nil
    if nil == cell then
        table.cells = table.cells or {}
        cell = TFTableViewCell:create()
        table.cells[cell] = true

        
        for i=1,4 do
            local node = self.cellNode:clone()
            --node:setPosition(ccp(((i-1)*150+30), -5))
            if self.data and self.data.type and self.data.type == EnumGameItemType.Gem then
                if idx == 0 then
                    node:setPosition(ccp(((i-1)*150+30), 35))
                else
                    node:setPosition(ccp(((i-1)*150+30), 50))
                end
            else
                node:setPosition(ccp(((i-1)*150+30), -10))
            end
            cell:addChild(node);
            cell.nodeList = cell.nodeList or {}
            local btn_node      =  TFDirector:getChildByPath(node, 'btn_node')
            local btn_icon = TFDirector:getChildByPath(node, 'btn_icon')
            btn_icon:setTouchEnabled(false)
            cell.nodeList[i] = btn_node
            self.nodeList[#self.nodeList+1] = btn_node
            btn_node.logic = self
            btn_node:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btn_nodeClickHandle),1)
        end

    end
    self:drawNode(cell,idx)
    return cell
end

function OpenChoiceBox.numberOfCellsInOpenChoiceBox(table)
    local self = table.logic
    return math.ceil(#self.giftGoodsList / 4)
  
end

function OpenChoiceBox:drawNode(node,index)
    for i =1, 4 do
        self:drawGift(node.nodeList[i], 4*index+i)
    end
end


function OpenChoiceBox:removeEvents()

end

function OpenChoiceBox:isChoice( index )
    for k,v in pairs(self.choiceList) do
        if v == index then
            return true
        end
    end
    return false
end

function OpenChoiceBox:getChoiceIndex( index )
    for k,v in pairs(self.choiceList) do
        if v == index then
            return k
        end
    end
    return 0
end

function OpenChoiceBox:drawGift(node, index)
    -- local btn_node      =  TFDirector:getChildByPath(node, 'btn_node')
    local btn_icon      =  TFDirector:getChildByPath(node, 'btn_icon')
    local img_icon      =  TFDirector:getChildByPath(node, 'img_icon')
    local txt_number    =  TFDirector:getChildByPath(node, 'txt_number')
    local txt_name      =  TFDirector:getChildByPath(node, 'txt_name')
    local img_xuanzhong =  TFDirector:getChildByPath(node, 'img_xuanzhong')

    -- added by wuqi 2016/11/14 增加显示已穿戴的同类宝石最低等级
    local panel_bs = TFDirector:getChildByPath(node, "panel_bs")
    local txt_yxq = TFDirector:getChildByPath(node, "txt_yxq")
    local txt_level = TFDirector:getChildByPath(node, "txt_level")
    local txt_level1 = TFDirector:getChildByPath(node, "txt_level1")

    panel_bs:setVisible(false)
    
    if index > #self.giftGoodsList then
        node:setVisible(false)
        return
    end
    node:setVisible(true)
    if self:isChoice(index) then
        img_xuanzhong:setVisible(true)
    else
        img_xuanzhong:setVisible(false)
    end


    local giftData    = self.giftGoodsList[index]
    local giftDataInfo  = split(giftData, "_")
    local itemType    = tonumber(giftDataInfo[1])
    local itemId_     = tonumber(giftDataInfo[2])
    local itemNum     = tonumber(giftDataInfo[3])
    local item = {type = itemType, number = itemNum, itemId = itemId_}
    local reward = BaseDataManager:getReward(item)
    

    txt_number:setText(reward.number)
    txt_name:setText(reward.name)
    img_icon:setTexture(reward.path)
    btn_icon:setTextureNormal(GetColorIconByQuality(reward.quality))
    if itemType == EnumDropType.GOODS then
        local itemInfo = ItemData:objectByID(itemId_)
        if itemInfo.type == EnumGameItemType.Soul or itemInfo.type == EnumGameItemType.Piece then
            Public:addPieceImg(img_icon,reward,true)
        else
            Public:addPieceImg(img_icon,reward,nil,1.0)
            if itemInfo.type == EnumGameItemType.Gem then
                local minLv = ZhengbaManager:getGemMinLevel(itemInfo) or 0
                panel_bs:setVisible(true)
                if minLv > 0 then
                    txt_yxq:setVisible(true)
                    txt_level:setVisible(true)
                    txt_level1:setVisible(true)
                    txt_yxq:setText( localizable.Open_Choice_Box_txt_yxq )
                    txt_level:setText( stringUtils.format( localizable.Open_Choice_Box_txt_level, EnumGemLevelType[minLv] ) )
                    txt_level1:setText(localizable.Open_Choice_Box_txt_level1)
                    if minLv < itemInfo.level then
                        txt_level:setColor( ccc3(193, 56, 11) )
                    else
                        txt_level:setColor( ccc3(0, 0, 0) )
                    end
                else
                    txt_yxq:setVisible(true)
                    txt_yxq:setText(localizable.Open_Choice_Box_txt_weixiangqian)
                    txt_level:setVisible(false)
                    txt_level1:setVisible(false)
                end
            end
        end
    end
    node.choiceId = index
end

function OpenChoiceBox.btn_nodeClickHandle(sender)
    local self = sender.logic
    local btn_node = sender
    local choiceId = sender.choiceId
    if self:isChoice(choiceId) then
        self:unChoiceBtn(sender)
        return
    end
    if #self.choiceList >= self.choiceNum then
        self:unChoiceFirstBtn()
    end
    self:choiceBtn(sender)
end


function OpenChoiceBox:choiceBtn(btn)
    self.choiceList[#self.choiceList+1] = btn.choiceId
    local img_xuanzhong =  TFDirector:getChildByPath(btn, 'img_xuanzhong')
    img_xuanzhong:setVisible(true)
end
function OpenChoiceBox:unChoiceBtn(btn)
    local pos = self:getChoiceIndex(btn.choiceId)
    table.remove(self.choiceList,pos)
    local img_xuanzhong =  TFDirector:getChildByPath(btn, 'img_xuanzhong')
    img_xuanzhong:setVisible(false)
end
function OpenChoiceBox:unChoiceFirstBtn()
    local index = self.choiceList[1]
    if index == nil then
        return
    end
    table.remove(self.choiceList,1)
    for i=1,#self.nodeList do
        local node = self.nodeList[i]
        if node.choiceId == index then
            local img_xuanzhong =  TFDirector:getChildByPath(node, 'img_xuanzhong')
            img_xuanzhong:setVisible(false)
            table.remove(self.choiceList,1)
            return
        end
    end
end

function OpenChoiceBox.getBtnClickHandle(sender)
    local self = sender.logic
    local choiceId = {}

    if self.choiceList ~= nil  and #self.choiceList > 0 then
        local itemNum = BagManager:getItemNumById(self.id)
        if itemNum == 1 then
            BagManager:goChoice(self.id, self.choiceList,1)
            AlertManager:close()
        else
            -- AlertManager:close()
            BagManager:openUseMore( self.id ,self.choiceList)
        end
    else
        toastMessage(localizable.common_please_check_one)
    end
end

  
return OpenChoiceBox;


