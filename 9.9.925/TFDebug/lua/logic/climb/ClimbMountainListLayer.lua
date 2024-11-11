--[[
******无量山-关卡列表*******

    -- by haidong.gan
    -- 2013/12/27
]]
local ClimbMountainListLayer = class("ClimbMountainListLayer", BaseLayer);

ClimbMountainListLayer.LIST_ITEM_HEIGHT = 640; 

CREATE_SCENE_FUN(ClimbMountainListLayer);
CREATE_PANEL_FUN(ClimbMountainListLayer);

function ClimbMountainListLayer:ctor(mountainItem)
    self.super.ctor(self,mountainItem);

    self.clickMountainItem_id = 1;
    self:init("lua.uiconfig_mango_new.climb.ClimbMountainListLayer");
end

function ClimbMountainListLayer:initUI(ui)
    self.super.initUI(self,ui);
    -- self.btn_close        = TFDirector:getChildByPath(ui, 'btn_close');
    self.txt_curIndex   = TFDirector:getChildByPath(ui, 'txt_curIndex');
    self.img_cur        = TFDirector:getChildByPath(ui, 'img_cur');
    -- self.txt_star_num        = TFDirector:getChildByPath(self.img_cur, 'txt_num');
    self.btn_qubeiku        = TFDirector:getChildByPath(ui, 'btn_qubeiku');

    local verLock = VersionLockData:objectByID(EnumVersionLockType.NorthClimb_Lock)
    if verLock and verLock.open == 0 then
        self.btn_qubeiku:setVisible(false)
    end

    self.generalHead = CommonManager:addGeneralHead( self )

    self.generalHead:setData(ModuleType.Climb,{HeadResType.CLIMB,HeadResType.COIN,HeadResType.SYCEE}, true)

    self.bg_table  = TFDirector:getChildByPath(ui, 'list_mountain');
    self.btn_soul  = TFDirector:getChildByPath(ui, 'btn_soul');

    local  tableView =  TFTableView:create()
    self.table_mountain = tableView
    Public:bindScrollFun(tableView);

    tableView.logic = self;
    tableView:setTableViewSize(CCSizeMake(self:getSize().width,self.bg_table:getSize().height))
    tableView:setDirection(TFTableView.TFSCROLLVERTICAL)
    tableView:setVerticalFillOrder(0)
    tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable)
    tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex)
    tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView)
    tableView:addMEListener(TFTABLEVIEW_SCROLL, self.tableScroll)
    tableView:setBounceable(false);
    self.bg_table:addChild(tableView)

    self.detailLayer    = require('lua.logic.climb.ClimbMountainDetailLayer'):new()
    -- self.ui:setVisible(false)


    self.detailLayer:setZOrder(10)
    self:addLayer(self.detailLayer)
    self.slider_gundongtiao  = TFDirector:getChildByPath(ui, 'slider_gundongtiao');
    self.slider_gundongtiao.logic = self
    -- self.slider_gundongtiao:addMEListener(TFWIDGET_TOUCHBEGAN, audioClickfun(self.sliderTouchMoveHandle),1)
    -- self.slider_gundongtiao:addMEListener(TFWIDGET_TOUCHMOVED, audioClickfun(self.sliderTouchMoveHandle),1)
    self.slider_gundongtiao:addMEListener(TFWIDGET_TOUCHENDED, audioClickfun(self.sliderTouchMoveHandle),1)

    self.img_slider  = TFDirector:getChildByPath(ui, 'img_slider');
    -- local pos = self.detailLayer:getPosition()
    -- self.img_slider:setPosition(ccp(pos.x+680,pos.y+300))
end

function ClimbMountainListLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow()
    self:refreshBaseUI()
end

function ClimbMountainListLayer:refreshBaseUI()

end


function ClimbMountainListLayer.sliderTouchMoveHandle(sender)
    local self = sender.logic;
    local percent = sender:getPercent()*self.table_mountain:getContentSize().height/100
    
    self.table_mountain:setContentOffset(ccp(0,percent*-1) , 0)
end

function ClimbMountainListLayer.cellSizeForTable(tableView,idx)
    return ClimbMountainListLayer.LIST_ITEM_HEIGHT,960
end


function ClimbMountainListLayer.tableScroll(tableView)
    local self = tableView.logic;
    local percent = tableView:getScrollYPercent()
    -- print("percent = ",percent)
    self.slider_gundongtiao:setPercent(percent)
end

function ClimbMountainListLayer.tableCellAtIndex(tableView, idx)

    local self = tableView.logic;
    local cell = tableView:dequeueCell()
    if nil == cell then

        tableView.cells = tableView.cells or {}
        cell = TFTableViewCell:create()
        tableView.cells[cell] = true

        local mountain_node = createUIByLuaNew("lua.uiconfig_mango_new.climb.ClimbMountainItem");

        cell:addChild(mountain_node);
        cell.mountain_node = mountain_node;

        for i=1,3 do
            local node = TFDirector:getChildByPath(mountain_node, 'node' .. i);
            local m_node = createUIByLuaNew("lua.uiconfig_mango_new.climb.ClimbMountainItemNode");

            local Panel_Content = TFDirector:getChildByPath(m_node, 'Panel_Content');
            Panel_Content:setVisible(false)
            Panel_Content = TFDirector:getChildByPath(m_node, 'Panel_Content1');
            Panel_Content:setVisible(true)
            for j=1,3 do
                local img_star        = TFDirector:getChildByPath(Panel_Content, 'img_star'..j);
                img_star:setVisible(false)
            end
             m_node:setName("m_node" .. i);

             m_node:setPosition(node:getPosition());
             node:getParent():addChild(m_node);
             mountain_node.m_node = m_node;
        end
    end
    for i=1,3 do
        local cellNum = math.ceil(self.mountainList:length()/3);
        local offset = cellNum*3 - self.mountainList:length();

        local mountainIndex = self.mountainList:length() - idx*3 + i + offset;

        local m_node = TFDirector:getChildByPath(cell.mountain_node, 'm_node' .. i);
        local mountainItem = self.mountainList:objectAt(mountainIndex);
        if  mountainItem then
            m_node:setVisible(true);
            self:loadMountainNode(m_node,mountainItem);
            if mountainIndex == self.clickMountainItem_id then
                print("======================111111=========================",mountainIndex,self.clickMountainItem_id)
                if self.cur_mountainItem then
                    self.detailLayer:loadData(self.cur_mountainItem,self.homeInfo,false);
                else
                    self.detailLayer:loadData(self.mountainList:back(),self.homeInfo,false);
                end
            end
        else
            m_node:setVisible(false);
        end
    end


    return cell
end


function ClimbMountainListLayer.numberOfCellsInTableView(tableView)
    local self = tableView.logic;
    return math.ceil(self.mountainList:length()/3) + 1;
end


function ClimbMountainListLayer:getShowMountainList()
    local list = TFArray:new();
    local index = 1;
    local curIndex = self:getMountainIndexById(self.homeInfo.curId);
    local cellNum = math.ceil((curIndex + 19)/3);
    local length = math.min(ClimbConfigure:length() , cellNum * 3);

    for v in ClimbConfigure:iterator() do
        if index <= length then
            list:push(v);
        end
        index = index +1;
    end
    return list;
end

function ClimbMountainListLayer:loadHomeData(data)
    self.homeInfo = data;
    self.cur_mountainItem = nil;
    -- if self.homeInfo.curId > ClimbConfigure:back().id then
    --     self.img_cur:setVisible(false);
    -- end
    local floor_num = math.min(self.homeInfo.curId , ClimbConfigure:back().id)
    self.txt_curIndex:setText(floor_num);

    self.mountainList = self:getShowMountainList();

    self.table_mountain:reloadData()
    -- self.txt_star_num:setText(ClimbManager.climStarNum)

    self.clickMountainItem_id = math.min(self.homeInfo.curId,ClimbConfigure:length());
    
    self.table_mountain:scrollToCenterForPositionY(ClimbMountainListLayer.LIST_ITEM_HEIGHT / 3 * self:getMountainIndexById(self.homeInfo.curId) , 0);
end

function ClimbMountainListLayer:updateCurMountain(data)
    -- local prevCurId = self.homeInfo.curId;
    -- self.clickMountainItem_id = math.min(self.homeInfo.curId,ClimbConfigure:length());
    -- self.homeInfo = data;
    -- self.cur_mountainItem = nil;
    -- -- self.txt_curIndex:setText("当前闯关层数为：" .. self.homeInfo.curId .. "层");
    -- if self.homeInfo.curId > ClimbConfigure:back().id then
    --     self.img_cur:setVisible(false);
    -- end
    -- self.txt_curIndex:setText(self.homeInfo.curId);

    self.mountainList = self:getShowMountainList();
    local floor_num = math.min(data.curId , ClimbConfigure:back().id)
    self.txt_curIndex:setText(floor_num);
    -- self.txt_curIndex:setText(data.curId);

    self.table_mountain:reloadData()
    -- self.txt_star_num:setText(ClimbManager.climStarNum)

    -- self.table_mountain:scrollToCenterForPositionY(ClimbMountainListLayer.LIST_ITEM_HEIGHT / 3 * self:getMountainIndexById(prevCurId) , 0);
    self.table_mountain:scrollToCenterForPositionY(ClimbMountainListLayer.LIST_ITEM_HEIGHT / 3 * self:getMountainIndexById(self.clickMountainItem_id) , 0);
end
function ClimbMountainListLayer:updateStar()
    self.table_mountain:reloadData()
    -- self.txt_star_num:setText(ClimbManager.climStarNum)

    -- self.table_mountain:scrollToCenterForPositionY(ClimbMountainListLayer.LIST_ITEM_HEIGHT / 3 * self:getMountainIndexById(prevCurId) , 0);
    self.table_mountain:scrollToCenterForPositionY(ClimbMountainListLayer.LIST_ITEM_HEIGHT / 3 * self:getMountainIndexById(self.clickMountainItem_id) , 0);
end

function ClimbMountainListLayer:getMountainIndexById(mountainId)
    local index = 0;
    for item in ClimbConfigure:iterator() do
        if item.id > mountainId then
            break;
        end
        index = index + 1;
    end
    return index;
end

--添加关卡节点
function ClimbMountainListLayer:loadMountainNode(mountain_node, mountainItem)

    -- local txt_name = TFDirector:getChildByPath(mountain_node, 'txt_name');
    -- txt_name:setText(mountainItem.name);

    local img_icon = TFDirector:getChildByPath(mountain_node, 'img_icon');
    -- local npcs = NPCData:GetNPCListByIds(mountainItem.npc);
    -- for i,v in pairs(npcs) do
    --     if i > 1 and v ~= nil then
    --        img_icon:setTextureNormal(v:getImagePath());
    --        img_icon.image = v.image;
    --        break;
    --     end
    -- end
    img_icon:setTextureNormal("icon/rolebig/" .. mountainItem.image .. ".png");
    -- img_icon:removeUnuseTexEnabled(true);
    img_icon.image = mountainItem.image;

    local img_lock = TFDirector:getChildByPath(mountain_node, 'img_lock');
    -- local img_pass = TFDirector:getChildByPath(mountain_node, 'img_pass');

    local img_floor_bg = TFDirector:getChildByPath(mountain_node, 'img_floor_bg');

    local img_arrow = TFDirector:getChildByPath(mountain_node, 'img_arrow');

    local img_flag = TFDirector:getChildByPath(mountain_node, 'img_flag');
    
    local txt_index = TFDirector:getChildByPath(mountain_node, 'txt_floor');
    -- txt_index:setText("第" .. mountainItem.id .. "层");
    txt_index:setText(stringUtils.format(localizable.ClimbMountainListLayer_floor_desc, mountainItem.id))

    if self.clickMountainItem_id == mountainItem.id then
        self.clickMountainItem = mountain_node
        txt_index:setColor(ccc3(255,255,255))
        img_floor_bg:setTexture("ui_new/climb/wl_kaiqi.png");
    else
        txt_index:setColor(ccc3(0,0,0))
        img_floor_bg:setTexture("ui_new/climb/wls_cengshu_bg.png");
    end 

    img_icon.logic = self;
    img_icon:setTag(mountainItem.id);
    -- img_icon:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMountainItemClickHandle));

    local Panel_Content = TFDirector:getChildByPath(mountain_node, 'Panel_Content1');
    for i=1,3 do
        local img_star        = TFDirector:getChildByPath(Panel_Content, 'img_star'..i);
        img_star:setVisible(false)
    end
    if ClimbManager.climbStarInfo[mountainItem.id] then
        local star_num = ClimbManager.climbStarInfo[mountainItem.id].star or 0
        for i=1,3 do
            local img_star        = TFDirector:getChildByPath(Panel_Content, 'img_star'..i);
            img_star:setVisible(true)
            local img_star_show        = TFDirector:getChildByPath(img_star, 'img_star');
            if i <= star_num then
                img_star_show:setVisible(true)
            else
                img_star_show:setVisible(false)
            end
        end
    end

    mountain_node.logic = self;
    mountain_node:setTag(mountainItem.id);
    mountain_node:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMountainItemClickHandle));

    img_floor_bg.logic = self;
    img_floor_bg:setTag(mountainItem.id);
    -- img_floor_bg:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMountainItemClickHandle));

    img_icon:setTouchEnabled(false);
    mountain_node:setTouchEnabled(true);
    img_floor_bg:setTouchEnabled(false);

    img_lock:setVisible(false);
    -- img_pass:setVisible(false);
    img_flag:setVisible(false);
    img_arrow:setVisible(false);
    img_icon:setColor(ccc3(255,255,255));  

    if  mountainItem.id < self.homeInfo.curId then
        -- img_pass:setVisible(true);
        -- img_floor_bg:setTexture("ui_new/climb/wls_cengshu_bg1.png");
        img_flag:setTexture("ui_new/climb/wl_qizi1.png");
        img_icon:setVisible(true);
        img_flag:setVisible(true);
        -- mountain_node:setTouchEnabled(true);   

        -- mountain_node:setShaderProgram("GrayShader", true)

        if img_icon.armature then
            img_icon.armature:removeFromParent(true);
            img_icon.armature = nil;
        end
        
    elseif mountainItem.id == self.homeInfo.curId then
        -- mountain_node:setTouchEnabled(true);  

        -- img_arrow:setVisible(true);
        img_icon:setVisible(false);
        img_flag:setVisible(true);
        -- img_floor_bg:setTexture("ui_new/climb/wls_cengshu_bg1.png");
        img_flag:setTexture("ui_new/climb/wl_qizi.png");
        -- img_icon:setShaderProgram("HighLight", true)
   
        -- local img_arrow = TFImage:create("ui_new/climb/wls_arrow_img.png");
        -- img_arrow:setPosition(ccp(img_icon:getPosition().x,img_icon:getPosition().y + 65));
        -- img_icon:getParent():addChild(img_arrow,2)

        -- local oldPosition = ccp(100,174);

        -- if self.img_attackingTween then
        --     TFDirector:killTween(self.img_attackingTween)
        --     img_icon.armature = nil;
        -- end
            
        -- self.img_attackingTween = {
        --     target = img_arrow,
        --     repeated = -1,
        --     {
        --         duration = 1,
        --         y = oldPosition.y - 2,
        --         scale = 0.8,
        --     },
        --     { 
        --         duration = 1,
        --         y = oldPosition.y + 2,
        --         scale = 1.0,
        --     }
        -- }
        -- TFDirector:toTween(self.img_attackingTween)
        if mountainItem.id == self.homeInfo.curId then
            self.cur_mountainItem = mountainItem;
        end
        if img_icon.armature then
            img_icon.armature:removeFromParent(true);
            img_icon.armature = nil;
        end
        
        local armature = self:getArmatureByImage(img_icon.image);
        armature:setPosition(ccp(img_icon:getPosition().x,img_icon:getPosition().y - img_icon:getSize().height/2 * img_icon:getScaleY()+ 10));
        img_icon:getParent():addChild(armature)
        img_icon.armature = armature;

        armature.logic = self;
        armature:setTag(mountainItem.id);
        -- armature:setTouchEnabled(true)
        -- armature:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onMountainItemClickHandle));

        -- mountain_node:setShaderProgramDefault(true);

    elseif mountainItem.id > self.homeInfo.curId then
        img_icon:setColor(ccc3(166,166,166));  
        img_lock:setVisible(true);
        img_icon:setVisible(true);
        img_flag:setVisible(false);
        -- img_floor_bg:setTexture("ui_new/climb/wls_cengshu_bg.png");
        -- mountain_node:setShaderProgramDefault(true)
        -- mountain_node:setTouchEnabled(true);  

        if img_icon.armature then
            img_icon.armature:removeFromParent(true);
            img_icon.armature = nil;
        end
    end

    -- if self.cur_mountainItem then
    --     self.detailLayer:loadData(self.cur_mountainItem,self.homeInfo,false);
    -- else
    --     self.detailLayer:loadData(self.mountainList:back(),self.homeInfo,false);
    -- end

    if mountain_node.rewardNode then
        mountain_node.rewardNode:removeFromParent();
        mountain_node.rewardNode = nil;
    end
    -- if  mountainItem.id >= self.homeInfo.curId then
    --     local firstRewardList =  ClimbManager:getFirstRewardItemList(mountainItem.id);

    --     local index = 1;
    --     for reward in firstRewardList:iterator() do
    --         local rewardNode = Public:createIconNumNode(reward)
    --         rewardNode:setScale(0.3);
    --         rewardNode:setPosition(80 + index * 40,25)
            
    --         mountain_node:addChild(rewardNode);
    --         mountain_node.rewardNode = rewardNode;

    --         index = index + 1;
    --         break;
    --     end
    -- end

end


function ClimbMountainListLayer:HaveAnim(armature,animName)
    animName = animName..";"
    local movNames = armature:getMovementNameStrings()
    movNames = movNames..";"
    if string.find(movNames, animName) then
        return true
    else
        return false
    end
end

function ClimbMountainListLayer:getArmatureByImage(image)
    local resID = image
	
	local resPathXML = "armature/"..resID..".xml"
	local resPathAlats = "armature/".. resID .. ".atlas" 
	local armature
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "armature/".. resID
		armature = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		armature = TFArmature:create(resID.."_anim")
	else
		resID = 10006
		TFResourceHelper:instance():addArmatureFromJsonFile("armature/"..resID..".xml")
		armature = TFArmature:create(resID.."_anim")
	end
	
	if armature == nil then
		assert(false, "armature"..resID.."create error")
		return
	end

    if self:HaveAnim(armature,"stand") then
        armature:play("stand", -1, -1, 1)
        armature:setRotationY(180);
    elseif self:HaveAnim(armature,"standl") then

        armature:play("standl", -1, -1, 1)
    end
    armature:setScale(0.9)
    -- armature:removeUnuseTexEnabled(true);
    return armature
end

function ClimbMountainListLayer.onMountainItemClickHandle(sender)
    local self = sender.logic;

    local mountainId = sender:getTag();
    local mountainItem = ClimbConfigure:objectByID(mountainId);

    if self.clickMountainItem:getTag() == self.clickMountainItem_id then
        local txt_index = TFDirector:getChildByPath(self.clickMountainItem, 'txt_floor');
        txt_index:setColor(ccc3(0,0,0))
        local img_floor_bg = TFDirector:getChildByPath(self.clickMountainItem, 'img_floor_bg');
        img_floor_bg:setTexture("ui_new/climb/wls_cengshu_bg.png");
    end
    local txt_index = TFDirector:getChildByPath(sender, 'txt_floor');
    txt_index:setColor(ccc3(255,255,255))
    local img_floor_bg = TFDirector:getChildByPath(sender, 'img_floor_bg');
    img_floor_bg:setTexture("ui_new/climb/wl_kaiqi.png");

    self.clickMountainItem = sender
    self.clickMountainItem_id = sender:getTag()
    -- if  mountainItem.id <= self.homeInfo.curId then
        self.detailLayer:loadData(mountainItem,self.homeInfo);

    -- elseif mountainItem.id > self.homeInfo.curId then
    --     toastMessage("未开放")
    -- end

    -- ClimbManager:showDetail(mountainItem,self.homeInfo);
end


function ClimbMountainListLayer:removeUI()
    self.super.removeUI(self);
end

function ClimbMountainListLayer:dispose()
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
    self.super.dispose(self)
end

function ClimbMountainListLayer:registerEvents()
    self.super.registerEvents(self);    
   self.btn_soul.logic = self;
   self.btn_soul:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSoulClickHandle));

   self.btn_qubeiku:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onClickNorthMountain));

    self.updateHomeInfoCallBack = function(event)
        self:loadHomeData(event.data[1])
    end;
    TFDirector:addMEGlobalListener(ClimbManager.CLIMB_INFORMATION ,self.updateHomeInfoCallBack ) ;

    self.attackCompeleteCallBack = function(event)
        self:updateCurMountain(event.data[1]);
    end;
    TFDirector:addMEGlobalListener(ClimbManager.EVENT_ATTACK_COMPELETE ,self.attackCompeleteCallBack ) ;

    self.LeaveFightForOneKeyCallBack = function(event)
        self.detailLayer.hasLoad = false

        self:loadHomeData(ClimbManager.climbInfo)

        local mountainId = self.clickMountainItem_id
        local mountainItem = ClimbConfigure:objectByID(mountainId)
        self.detailLayer:loadData(mountainItem,self.homeInfo)
    end;
    TFDirector:addMEGlobalListener(FightManager.LeaveFightForOneKey ,self.LeaveFightForOneKeyCallBack )
    
    self.AddClimbStarInfoMessageCallBack = function(event)
        self:updateStar();
    end;
    TFDirector:addMEGlobalListener(ClimbManager.AddClimbStarInfoMessage ,self.AddClimbStarInfoMessageCallBack ) ;
    

    if self.generalHead then
        self.generalHead:registerEvents()
    end
 end

function ClimbMountainListLayer.onSoulClickHandle(sender)
    local self = sender.logic;
    local needLevelIndex = ConstantData:getValue("Climb.Carbon.NeedLevelIndex1");

    if self.homeInfo.curId < needLevelIndex then
        --toastMessage("无量山到第" .. needLevelIndex .. "层开放")
        toastMessage(stringUtils.format(localizable.carbonMountainList_open, needLevelIndex))
        return;
    end
    ClimbManager:showCarbonListLayer();
end


function ClimbMountainListLayer.onClickNorthMountain(sender)
    local self = sender.logic;
    local needLevelIndex = ConstantData:getValue("North.Cave.Open.Floor");
    if ClimbManager:getClimbFloorNum() < needLevelIndex then
        
        -- local str = TFLanguageManager:getString(ErrorCodeData.BEIKU_OPEN_NOT_ENOUGH_LEVEL)
        -- str = string.format(str,needLevelIndex)        
        local str = stringUtils.format(localizable.BEIKU_OPEN_NOT_ENOUGH_LEVEL,needLevelIndex)
        
        toastMessage(str)
        return;
    end
    NorthClimbManager:showNorthMountainLayer();
end


function ClimbMountainListLayer:removeEvents()
    self.super.removeEvents(self);

    TFDirector:removeMEGlobalListener(ClimbManager.CLIMB_INFORMATION ,self.updateHomeInfoCallBack);
    TFDirector:removeMEGlobalListener(ClimbManager.EVENT_ATTACK_COMPELETE ,self.attackCompeleteCallBack);
    TFDirector:removeMEGlobalListener(ClimbManager.AddClimbStarInfoMessage ,self.AddClimbStarInfoMessageCallBack);
    TFDirector:removeMEGlobalListener(FightManager.LeaveFightForOneKey ,self.LeaveFightForOneKeyCallBack )
    self.LeaveFightForOneKeyCallBack = nil
    self.AddClimbStarInfoMessageCallBack = nil

    
    if self.generalHead then
        self.generalHead:removeEvents()
    end
end


return ClimbMountainListLayer;
