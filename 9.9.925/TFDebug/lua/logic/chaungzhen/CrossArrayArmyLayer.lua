--[[
******布阵*******

    -- by Stephen.tao

]]


local CrossArrayArmyLayer = class("CrossArrayArmyLayer", BaseLayer);

CREATE_SCENE_FUN(CrossArrayArmyLayer);
CREATE_PANEL_FUN(CrossArrayArmyLayer);

-- CrossArrayArmyLayer.LIST_ITEM_HEIGHT = 200; 
CrossArrayArmyLayer.LIST_ITEM_HEIGHT = 180;

function CrossArrayArmyLayer:ctor(data)
    self.super.ctor(self,data);
    -- EmployManager:initHireRoleList()
    self.fightType = EnumFightStrategyType.StrategyType_CHUANGZHEN

    -- self.roleList = CardRoleManager.cardRoleList
    self:initRoleList()

    self:init("lua.uiconfig_mango_new.yongbing.ChooseMercenary");

    Public:addBtnWaterEffect(self.btn_challenge, true,1)
end

function CrossArrayArmyLayer:onShow()
    self.super.onShow(self)
    self:refreshUI();

    if self.assistFightView then
        self.assistFightView:onShow()
    end
    self.btn_skill_tips:setVisible(CustomSkillAiManage:checkShowTipsIcon( self.fightType ))
    Public:addZhenFaIconForArmy(self.zhenfaNode, self.currLineUpType)
end


function CrossArrayArmyLayer:initRoleList()
    self.roleList = CardRoleManager.cardRoleList
end

function CrossArrayArmyLayer:refreshUI()
    if not self.isShow then 
        return;
    end

    local  armylist = ZhengbaManager:getFightList(self.fightType)
    print("armylist ",armylist)
    for pos in pairs(armylist) do
        self:updateIcon(pos)
    end
    self:updateStrategyBaseMsg();

    if not self.table_roleList then
        ZhengbaManager:reSortStrategy(self.fightType,self.roleList,self.currSortType)
        -- CardRoleManager:setSortBloodStrategyForQuality()
        -- CardRoleManager:setSortStrategyForQuality(self.fightType,self.roleList);
        local  tableView   =  TFTableView:create();
        self.table_roleList  = tableView;

        tableView.logic    = self;
        tableView:setTableViewSize(self.bg_table:getContentSize());
        tableView:setDirection(TFTableView.TFSCROLLVERTICAL);
        tableView:setVerticalFillOrder(0);

        tableView:addMEListener(TFTABLEVIEW_SIZEFORINDEX, self.cellSizeForTable);
        -- tableView:addMEListener(TFTABLEVIEW_SCROLL, self.scrollForTable);
        tableView:addMEListener(TFTABLEVIEW_SIZEATINDEX, self.tableCellAtIndex);
        tableView:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, self.numberOfCellsInTableView);
        Public:bindScrollFun(tableView);
        self.bg_table:addChild(tableView,2);
        self.table_roleList:reloadData();
        self.table_roleList:scrollToYTop(0);
        -- self.table_roleList:setVisible(false)
    else
        self:refreshTable();
    end
    if self.roleList:length() == 0 then
        toastMessage(localizable.CrossArrayArmyLayer_join)
    end
end

function CrossArrayArmyLayer:updateStrategyBaseMsg()
    self.txt_RoleNum:setText(ZhengbaManager:getFightRoleNum( self.fightType ) .. "/" .. ChuangzhenManager:getMaxNum());
    -- self.txt_power:setText(BloodFightManager:getPower());
    self.txt_power:setText(ZhengbaManager:getPower(self.fightType));
end

function CrossArrayArmyLayer:initUI(ui)
	self.super.initUI(self,ui);


    self.currLineUpType = LineUpType.LineUp_CHUANGZHEN
    -- self.currLineUpType = LineUpType.LineUp_HIRE_TEAM
    self.assistFightView = CommonManager:addAssistFightView(self,self.currLineUpType)

    self.zhenfaNode = TFDirector:getChildByPath(ui, "panel_buzhen")
    
    
    self.btn_close      = TFDirector:getChildByPath(ui, 'btn_close');

    self.txt_RoleNum = TFDirector:getChildByPath(ui, 'txt_shangzhenrenshu');
    self.txt_power   = TFDirector:getChildByPath(ui, 'txt_zhanlizhi_word');
    self.btn_auto    = TFDirector:getChildByPath(ui, 'btn_yijianshangzhen');

    self.button = {};
    for i=1,9 do
        local btnName = "panel_item" .. i;
        self.button[i] = TFDirector:getChildByPath(ui, btnName);

        btnName = "btn_icon"..i;
        self.button[i].bg = TFDirector:getChildByPath(ui, btnName);
        self.button[i].bg:setVisible(false);

        self.button[i].icon = TFDirector:getChildByPath(self.button[i].bg ,"img_touxiang");
        self.button[i].icon:setVisible(false);
        -- self.button[i].icon:setFlipX(true);

        self.button[i].quality  = TFDirector:getChildByPath(ui, btnName);
        self.button[i].img_zhiye = TFDirector:getChildByPath(self.button[i], "img_zhiye");
        self.button[i].img_zhiye:setVisible(false);

        self.button[i].img_death = TFDirector:getChildByPath(ui, "img_death"..i);
        self.button[i].img_death:setVisible(false);

        self.button[i].img_yong = TFDirector:getChildByPath(self.button[i], "img_yong");
        self.button[i].img_yong:setVisible(false);

        self.button[i].bg.logic = self;
        self.button[i].bg.posIndex = i;
        self.button[i].bg.hasRole = false;

        self.button[i].logic = self;
        self.button[i].posIndex = i;
        self.button[i].hasRole = false;
    end

    self.bg_table      = TFDirector:getChildByPath(ui, 'panel_cardregional');

    self.btn_sort            = TFDirector:getChildByPath(ui, 'btn_xiala');
    self.btn_sort_pos        = TFDirector:getChildByPath(ui, 'btn_zhuangbei');
    self.btn_sort_power      = TFDirector:getChildByPath(ui, 'btn_zhanli');
    self.btn_sort_quality    = TFDirector:getChildByPath(ui, 'btn_pinzhi');
    self.img_select          = TFDirector:getChildByPath(ui, 'img_select');

    self.img_quality_select          = TFDirector:getChildByPath(ui, 'btn_pinzhi-press');
    self.img_power_select          = TFDirector:getChildByPath(ui, 'btn_zhanli-press');
    
    self.bg_sort             = TFDirector:getChildByPath(ui, 'panel_bg');
    -- self.bg_sort:setSwallowTouch(false);
    self.node_menu           = TFDirector:getChildByPath(ui, 'panel_menu');
    self.groupButtonManager  = GroupButtonManager:new( {[1] = self.btn_sort_power, [2] = self.btn_sort_quality});
    
    self.groupButtonManager:selectBtn(self.btn_sort_power);

    self.node_menu:setVisible(false);
    self.btn_sort:setVisible(true);

    --挑战
    self.btn_challenge       = TFDirector:getChildByPath(ui, 'btn_challenge');

    

    self.cellModel = createUIByLuaNew("lua.uiconfig_mango_new.bloodybattle.BloodybattleArmyRoleItem")
    self.cellModel:retain()


    self.btn_xiake       = TFDirector:getChildByPath(ui, 'btn_xiake');
    self.btn_yongbing       = TFDirector:getChildByPath(ui, 'btn_yongbing');
    self.btn_xiake:setTouchEnabled(false)
    self.btn_yongbing:setTouchEnabled(false)
    self.btn_yongbing:setTextureNormal("ui_new/yongbing/tab_8h.png")
    self.btn_xiake:setVisible(false)


    self.btn_type_choice = self.btn_yongbing

    self.btn_equipchange = TFDirector:getChildByPath(ui, 'Button_ArmyLayer_1');

    self.img_quality_select:setVisible(false);
    self.img_power_select:setVisible(false);
    self.currSortType = CardRoleManager:getSortType() or ZhengbaManager.sortByQuality
    if self.currSortType == ZhengbaManager.sortByPower then
        self.img_power_select:setVisible(true);
    elseif self.currSortType == ZhengbaManager.sortByQuality then
        self.img_quality_select:setVisible(true);
    end
    self.btn_skill = TFDirector:getChildByPath(ui, "btn_skill")
    self.btn_skill.logic = self
    self.btn_skill_tips = TFDirector:getChildByPath(ui, "btn_skill_tips")
    self.btn_skill_tips:setVisible(CustomSkillAiManage:checkShowTipsIcon( self.fightType ))

end

function CrossArrayArmyLayer.onShowSortMenuClickHandle(sender)
    local self = sender.logic;
    self.node_menu:setVisible(not self.node_menu:isVisible());

end

function CrossArrayArmyLayer.onSortSelectClickHandle(sender)
    local self = sender.logic;

    self.node_menu:setVisible(false);

    if (self.groupButtonManager:getSelectButton() == sender) then
       return;
    end

    self.img_quality_select:setVisible(false);
    self.img_power_select:setVisible(false);

   if sender == self.btn_sort_pos then
        -- CardRoleManager:setSortStrategyForPos(self.fightType,self.roleList);
        self.img_power_select:setVisible(true);
        -- self:sortMercenaryList( 1 )
   elseif sender == self.btn_sort_power then
        -- CardRoleManager:setSortStrategyForPower(self.fightType,self.roleList);
        self.img_power_select:setVisible(true);
        self.currSortType = ZhengbaManager.sortByPower
        -- self:sortMercenaryList( 1 )
   elseif sender == self.btn_sort_quality then
        -- CardRoleManager:setSortStrategyForQuality(self.fightType,self.roleList);
        self.img_quality_select:setVisible(true);
        self.currSortType = ZhengbaManager.sortByQuality
        -- self:sortMercenaryList( 2 )
   end

   self.groupButtonManager:selectBtn(sender);
   self:refreshTable();
end

function CrossArrayArmyLayer.onSortCancelClickHandle(sender)
    local self = sender.logic;
    self.node_menu:setVisible(false);
    self.btn_sort:setVisible(true);
end


-- function CrossArrayArmyLayer.scrollForTable(tableView)
--     local self = tableView.logic;
--     -- self:removeLongTouchTimer();
-- end

function CrossArrayArmyLayer.cellSizeForTable(tableView,idx)
    return CrossArrayArmyLayer.LIST_ITEM_HEIGHT,960
end

function CrossArrayArmyLayer.tableCellAtIndex(tableView, idx)
    local self = tableView.logic;
    local cell = tableView:dequeueCell()
    if nil == cell then
        tableView.cells = tableView.cells or {}
        cell = TFTableViewCell:create()
        tableView.cells[cell] = true

        local item_node = TFPanel:create();
        cell:addChild(item_node);
        cell.item_node = item_node;

        for i=1,3 do
            -- local m_node = createUIByLuaNew("lua.uiconfig_mango_new.role.ArmyRoleItem")
            local m_node = self.cellModel:clone()

            m_node.panel_empty = TFDirector:getChildByPath(m_node, 'panel_empty');
            m_node.panel_info  = TFDirector:getChildByPath(m_node, 'panel_info');
            m_node.bar_xuetiao = TFDirector:getChildByPath(m_node, 'bar_xuetiao');
            m_node.img_xuetiao = TFDirector:getChildByPath(m_node, 'img_xuetiao');
            m_node.img_xuetiao:setVisible(false)
            m_node:setName("m_role" .. i);
            m_node:setPosition(ccp(20 + 140 * (i - 1) ,0));

            item_node:addChild(m_node);
            item_node.m_node = m_node;
        end
    end

    for i=1,3 do
        local roleIndex = idx*3 + i;

        local m_node = TFDirector:getChildByPath(cell.item_node, 'm_role' .. i);
        local roleId = self.roleList:objectAt(roleIndex);
        local roleItem = CardRoleManager:getRoleById(roleId)
        if  roleItem then
            m_node.panel_empty:setVisible(true);
            m_node.panel_info:setVisible(true);
            self:loadItemNode(m_node,roleItem);
     
        else
            m_node.panel_empty:setVisible(true);
            m_node.panel_info:setVisible(false);
        end

    end

    return cell
end

function CrossArrayArmyLayer.numberOfCellsInTableView(tableView)
    local self = tableView.logic;
    return math.max(math.ceil(self.roleList:length()/3)  ,3);
end




--添加玩家节点
function CrossArrayArmyLayer:loadItemNode(item_node,roleItem)
    
    local btn_icon = TFDirector:getChildByPath(item_node, 'btn_pingzhianniu');
    btn_icon.logic = self;
    btn_icon:setTag(roleItem.gmId);

    btn_icon:addMEListener(TFWIDGET_TOUCHBEGAN, self.cellTouchBeganHandle);
    btn_icon:addMEListener(TFWIDGET_TOUCHMOVED, self.cellTouchMovedHandle);
    btn_icon:addMEListener(TFWIDGET_TOUCHENDED, self.cellTouchEndedHandle);
    btn_icon:addMEListener(TFWIDGET_CLICK,  self.cellClickHandle);

    btn_icon.posIndex = -1;  
    btn_icon.hasRole = true;  
    btn_icon.gmId  = roleItem.gmId;
    btn_icon.roleId  = roleItem.id;

    local img_icon = TFDirector:getChildByPath(item_node, 'img_touxiang');

    -- img_icon:setTexture(roleItem:getHeadPath());
    img_icon:setTexture(roleItem:getIconPath());
    local img_quality = TFDirector:getChildByPath(item_node, 'img_pinzhiditu');
    img_quality:setTexture(GetColorIconByQuality(roleItem.quality));
    -- img_quality:setTexture(GetRoleBgByWuXueLevel(roleItem.martialLevel));


    local txt_name = TFDirector:getChildByPath(item_node, 'txt_name');
    local roleStar = ""
    if roleItem.starlevel > 0 then
        roleStar = roleStar .. " +" .. roleItem.starlevel
    end
    txt_name:setText(roleItem.name..roleStar);

    -- txt_name:setColor(GetColorByQuality(roleItem.quality))

    local img_zhiye = TFDirector:getChildByPath(item_node, 'img_zhiye');
    img_zhiye:setTexture("ui_new/fight/zhiye_".. roleItem.outline ..".png");



    local img_fight = TFDirector:getChildByPath(item_node, 'img_zhan');
    local role_pos = ZhengbaManager:getIndexByRole(self.fightType,roleItem.gmId )
    if role_pos and role_pos ~= 0 then
        img_fight:setVisible(true);
    else
        img_fight:setVisible(false);
    end
    --添加助战标识
    local img_zhu = TFDirector:getChildByPath(item_node, 'img_zhu')
    if AssistFightManager:isInAssist( self.currLineUpType, roleItem.gmId ) then
        img_zhu:setVisible(true)
    else
        img_zhu:setVisible(false)
    end
    
    local txt_level = TFDirector:getChildByPath(item_node, 'txt_lv_word');
    txt_level:setText(roleItem.level);

    item_node.img_xuetiao:setVisible(true)

    local img_wuxuelevel = TFDirector:getChildByPath(item_node, 'img_wuxuelevel');
    img_wuxuelevel:setTexture(GetFightRoleIconByWuXueLevel(roleItem.martialLevel))

    local percent = ChuangzhenManager:getRoleStateById( roleItem.gmId )
    item_node.bar_xuetiao:setPercent(percent * 100)

    local bGray = false
    if percent <= 0 then
        bGray = true
    end
    img_icon:setGrayEnabled(bGray)

end

function CrossArrayArmyLayer:removeUI()
	self.super.removeUI(self);

	self.button      = nil;
    self.btn_close   = nil;
    self.lastPoint   = nil;
    self.curIndex    = nil;

    if self.cellModel then
        self.cellModel:release()
        self.cellModel = nil
    end
    if self.cellMercenaryModel then
        self.cellMercenaryModel:release()
        self.cellMercenaryModel = nil
    end
end


function CrossArrayArmyLayer.cellClickHandle(sender)
    local self = sender.logic;
    local gmId = sender.gmId;

    if sender.isClick == true then
        play_press()
    end
end


function CrossArrayArmyLayer.cellTouchBeganHandle(cell)
    local self = cell.logic;
    if cell.hasRole ~= true then
        print(" == nil ")
        return;
    end

    cell.isClick = true;
    cell.isDrag  = false;
    self.isMove = false;

    -- self.offest = self.table_roleList:getContentOffset();

    self.onLongTouch = function(event)
        if self.isMove == false then
            return;
        end

        local pos = cell:getTouchMovePos();
          
        local v = ccpSub(cell:getTouchStartPos(), cell:getTouchMovePos());
       
        if (v.x < 30 and v.y < 30 )  then
            -- if (v.x < 0 or v.y < 0 ) then
            --     self:removeLongTouchTimer();  
            --     cell.isDrag  = false;
            -- end
            -- self:removeLongTouchTimer();
            -- self.longTouchTimerId = TFDirector:addTimer(0.001, 1, nil, self.onLongTouch); 

        else 
            self:removeLongTouchTimer();    
            if (v.x - v.y > -10) then
                cell.isDrag  = true;
                self.table_roleList:setTouchEnabled(false);
                -- self.table_mercenaryList:setTouchEnabled(false);
            else
                cell.isDrag  = false;
                self.table_roleList:setTouchEnabled(true);
                -- self.table_mercenaryList:setTouchEnabled(true);
            end
        end
    end;

    if (cell.posIndex == -1) then
        self:removeLongTouchTimer();
        self.longTouchTimerId = TFDirector:addTimer(0.001, -1, nil, self.onLongTouch); 
    end

end

function CrossArrayArmyLayer.cellTouchMovedHandle(cell)
    local self = cell.logic;
    self.isMove = true;

    if cell.hasRole ~= true then
        return;
    end

  
    local v = ccpSub(cell:getTouchStartPos(), cell:getTouchMovePos());

    if (v.y < 30) then
        -- self.table_roleList:setContentOffset(self.offest );
    end

    local pos = cell:getTouchMovePos();

    if self.selectCussor == nil then
        if (cell.posIndex ~= -1 or cell.isDrag == true ) then
            self:createSelectCussor(cell,pos);
        end
    end

    if cell.isClick == true then
        return;
    end
    -- self.table_roleList:setContentOffset(self.offest );
    self:moveSelectCussor(cell,pos);
end


function CrossArrayArmyLayer.cellTouchEndedHandle(cell)
    local self = cell.logic;
    if self.selectCussor then
        self.selectCussor:removeFromParentAndCleanup(true);
        self.selectCussor = nil;
    end

    if cell.hasRole ~= true then
        return;
    end

    self:removeLongTouchTimer();

    local pos = cell:getTouchEndPos();

    self:releaseSelectCussor(cell,pos);
    self.table_roleList:setTouchEnabled(true);
    -- self.table_mercenaryList:setTouchEnabled(true);
end

function CrossArrayArmyLayer:removeLongTouchTimer()
    if (self.longTouchTimerId) then
        TFDirector:removeTimer(self.longTouchTimerId);
        self.longTouchTimerId = nil;
    end
end

function CrossArrayArmyLayer:createSelectCussor(cell,pos)
    play_press();

    cell.isClick = false;

    self.lastPoint = pos;

    local role = RoleData:objectByID(cell.roleId);
    print("cell.roleId=",cell.roleId)
    -- local role = CardRoleManager:getRoleByGmid(cell.gmId);
    self.selectCussor = TFImage:create();
    self.selectCussor:setFlipX(true);
    self.selectCussor:setTexture(role:getHeadPath());
    self.selectCussor:setScale(20 / 15.0);
    self.selectCussor:setPosition(pos);
    self:addChild(self.selectCussor);
    self.selectCussor:setZOrder(100);
   
    self.curIndex = cell.posIndex;
    
end

function CrossArrayArmyLayer:moveSelectCussor(cell,pos)
    local v = ccpSub(pos, self.lastPoint);
    self.lastPoint = pos;
    local scp = ccpAdd(self.selectCussor:getPosition(), v);
    self.selectCussor:setPosition(scp);
    self.selectCussor:setVisible(true);

    self.curIndex = nil;
    if  self.bg_table:hitTest(pos) then
        self.curIndex = -1;
    end
    for i=1,9 do
        if  self.button[i]:hitTest(pos) then
            self.curIndex = self.button[i].posIndex;
            break;
        end
    end

end

function CrossArrayArmyLayer:releaseSelectCussor(cell,pos)

    if cell.isClick == false  then
        if (self.curIndex == nil) then
            return;
        end

        local dargRole      = CardRoleManager:getRoleByGmid(cell.gmId);
        local toReplaceRole =  ZhengbaManager:getRoleByIndex(self.fightType,self.curIndex);
    
        --在阵中释放
        if (self.curIndex ~= -1) then 

            --从列表中拖到阵中
            if (cell.posIndex == -1) then
                local role_pos = ZhengbaManager:getIndexByRole(self.fightType,cell.gmId )
                --本来已经在阵中
                if role_pos and role_pos ~= 0 then

                    --且不是本角色目前所在的位置，做位置变更
                    if (toReplaceRole == nil or (toReplaceRole and toReplaceRole.gmId ~= dargRole.gmId)) then
                        self:ChangePos((role_pos ), (self.curIndex ))

                        play_buzhenyidong()

                    end
                --要上阵，但是已经到达上限
                elseif (toReplaceRole == nil and not ZhengbaManager:canAddFightRole(self.fightType)) then
                    if ZhengbaManager:getMaxNum() == 5 then
                        toastMessage(localizable.common_function_number_out);  
                    else
                        local needLevel = FunctionOpenConfigure:getOpenLevel(700 + (ZhengbaManager:getMaxNum() + 1))
                        if MainPlayer:getLevel() < needLevel then
                            toastMessage(stringUtils.format(localizable.common_function_up_number,needLevel, (BloodFightManager.maxNum + 1)) )
                        end
                    end
                else
                    --check是否为助战侠客
                    if AssistFightManager:isInAssist( self.currLineUpType, cell.gmId ) then
                        CommonManager:showOperateSureLayer(
                                        function()
                                            AssistFightManager:updateRoleOff(self.currLineUpType, cell.gmId)
                                            self:OnBattle(cell.gmId, (self.curIndex ))
                                            play_buzhenyidong()
                                        end,
                                        function()
                                            AlertManager:close()
                                        end,
                                        {
                                        title = localizable.common_tips ,
                                        msg = localizable.common_tips_zhuzhan,
                                        }
                                    )
                    else
                        self:OnBattle(cell.gmId, (self.curIndex ))

                        play_buzhenyidong()
                    end

                end

            --阵中操作，更换位置   
            else
                self:ChangePos((cell.posIndex ), (self.curIndex ))

                play_buzhenyidong()
            end

            return;
        end

        --在右边列表释放
        if (self.curIndex == -1) then

            if (cell.posIndex == -1 ) then
                --放弃上阵，不做操作

            else

                    self:OutBattle(cell.gmId)

                    play_buzhenluoxia();
                --end
            end
        end
    end

    if cell:hitTest(pos) then     
        -- CrossArrayArmyLayer.cellClickHandle(cell);
    end
end


function CrossArrayArmyLayer:registerEvents()
    self.super.registerEvents(self);

    ADD_ALERT_CLOSE_LISTENER(self,self.btn_close);
    self.btn_close:setClickAreaLength(100);

    for i=1,9 do
        self.button[i].bg:addMEListener(TFWIDGET_CLICK,  self.cellClickHandle,1);
        self.button[i].bg:addMEListener(TFWIDGET_TOUCHBEGAN, self.cellTouchBeganHandle,1);
        self.button[i].bg:addMEListener(TFWIDGET_TOUCHMOVED, self.cellTouchMovedHandle);
        self.button[i].bg:addMEListener(TFWIDGET_TOUCHENDED, self.cellTouchEndedHandle);
    end

    self.btn_skill:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSkillBtnClick))
    if CustomSkillAiManage:checkIsOpen() then
        self.btn_skill:setVisible(true)
    else
        self.btn_skill:setVisible(false)
    end
    self.btn_sort.logic = self;
    -- self.btn_sort_pos.logic = self;
    self.btn_sort_power.logic = self;
    self.btn_sort_quality.logic = self;
    self.bg_sort.logic = self;

    self.btn_sort:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowSortMenuClickHandle));
    -- self.btn_sort_pos:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSortSelectClickHandle),1);
    self.btn_sort_power:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSortSelectClickHandle),1);
    self.btn_sort_quality:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSortSelectClickHandle),1);
    -- self.bg_sort:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSortCancelClickHandle));


    self.btn_challenge.logic = self
    self.btn_challenge:addMEListener(TFWIDGET_CLICK,audioClickfun(self.onBtnAttackClickHandle))

    self.btn_xiake.logic = self
    self.btn_xiake:addMEListener(TFWIDGET_CLICK,audioClickfun(self.onBtnXiaKeChoiceClickHandle))

    self.btn_yongbing.logic = self
    self.btn_yongbing:addMEListener(TFWIDGET_CLICK,audioClickfun(self.onBtnYongBingChoiceClickHandle))

    self.callEquipChange = function(sender)
        XiaKeExchangeManager:openEquipChangeLayer(self.fightType,self.roleList)
    end
    self.btn_equipchange:addMEListener(TFWIDGET_CLICK,audioClickfun(self.callEquipChange))

    if self.assistFightView then
        self.assistFightView:registerEvents()
    end

    self.updatePosCallBack = function(event)
        self:refreshUI()
        self.btn_skill_tips:setVisible(CustomSkillAiManage:checkShowTipsIcon( self.fightType ))
    end;
    TFDirector:addMEGlobalListener(ZhengbaManager.UPDATEFORMATIONSUCESS ,self.updatePosCallBack ) ;

    self.updateEudemonSucess = function(event)
        self:refreshUI()
    end;
    TFDirector:addMEGlobalListener(EudemonManager.EquipTeamEudemon ,self.updateEudemonSucess )
    --
    if XiaKeExchangeManager:IsOpenEquipChange() == true then
        self.btn_equipchange:setVisible(true)
    else
        self.btn_equipchange:setVisible(false)
    end
end


function CrossArrayArmyLayer:refreshTable()
    if self.table_roleList == nil then
        return
    end
    ZhengbaManager:reSortStrategy(self.fightType ,self.roleList ,self.currSortType)
    local tb_pos = self.table_roleList:getContentOffset();
    self.table_roleList:reloadData();
    local currentSize = self.table_roleList:getContentSize()
    local tabSize = self.table_roleList:getSize()
    tb_pos.y = math.max(tb_pos.y , tabSize.height - currentSize.height)
    self.table_roleList:setContentOffset(tb_pos);
end

function CrossArrayArmyLayer:removeEvents()
    self.super.removeEvents(self)

    if self.assistFightView then
        self.assistFightView:removeEvents()
    end
    TFDirector:removeMEGlobalListener(ZhengbaManager.UPDATEFORMATIONSUCESS, self.updatePosCallBack );
    self.updatePosCallBack = nil;


    TFDirector:removeMEGlobalListener(EudemonManager.EquipTeamEudemon ,self.updateEudemonSucess)
    self.updateEudemonSucess = nil;
end

function CrossArrayArmyLayer:updateIcon( index )
    local role = ZhengbaManager:getRoleByIndex( self.fightType ,index)
    if role then
        self.button[index].icon:setVisible(true);
        self.button[index].icon:setTexture(role:getHeadPath());

        self.button[index].bg:setVisible(true);
        self.button[index].quality:setTextureNormal(GetColorRoadIconByQuality(role.quality));
        -- self.button[index].quality:setTextureNormal(GetRoleBgByWuXueLevel_circle(role.martialLevel))

        self.button[index].img_zhiye:setVisible(true);
        self.button[index].img_zhiye:setTexture("ui_new/fight/zhiye_".. role.outline ..".png");

        self.button[index].img_yong:setVisible(false);

        self.button[index].bg.hasRole = true;
        self.button[index].bg.gmId  = role.gmId;
        self.button[index].bg.roleId  = role.id;

        local  percent = ChuangzhenManager:getRoleStateById( role.gmId )
        local bGray = false
        if percent <= 0 then
            bGray = true
        end
        self.button[index].icon:setGrayEnabled(bGray)
        self.button[index].img_death:setVisible(bGray)
        Public:addLianTiEffect(self.button[index].icon,role:getMaxLianTiQua(),true)
        return
    end
    self.button[index].img_zhiye:setVisible(false);
    self.button[index].icon:setVisible(false);
    self.button[index].img_yong:setVisible(false);
    self.button[index].bg:setVisible(false);
    self.button[index].bg.hasRole = false;
    self.button[index].icon:setGrayEnabled(false)
    self.button[index].img_death:setVisible(false)
    Public:addLianTiEffect(self.button[index].icon,0,false)
end


-- 上阵
function CrossArrayArmyLayer:OnBattle(gmid, posIndex)
    local  percent = ChuangzhenManager:getRoleStateById( gmid )
    if percent <= 0 then
        toastMessage(localizable.common_dead)
        return
    end
    ZhengbaManager:OnBattle(EnumFightStrategyType.StrategyType_CHUANGZHEN,gmid, posIndex, nil)
end
-- 下阵
function CrossArrayArmyLayer:OutBattle(gmid)
    ZhengbaManager:OutBattle(EnumFightStrategyType.StrategyType_CHUANGZHEN,gmid, nil)
end

-- 换位置
function CrossArrayArmyLayer:ChangePos(oldPos, newPos)
    ZhengbaManager:ChangePos(EnumFightStrategyType.StrategyType_CHUANGZHEN ,oldPos, newPos,nil)
end


function CrossArrayArmyLayer:isEmptyArmy()
    local list = ZhengbaManager:getFightList(self.fightType)
    for i=1,10 do
        if list[i] and list[i] ~= 0 then
            return false
        end
    end
    return true
end

function CrossArrayArmyLayer.onBtnAttackClickHandle(sender)
    local self      = sender.logic
    local gridIndex   = self.gridIndex
    -- if BloodFightManager:CheckAllRuleReachBeforeAttack() == false then
    --     return
    -- end
        AlertManager:close(AlertManager.TWEEN_NONE)
    AlertManager:close(AlertManager.TWEEN_NONE)
    ChuangzhenManager:OpenPoint( gridIndex )
    -- BloodFightManager:Attack(section)

end



function CrossArrayArmyLayer.onSkillBtnClick( btn )
    local self = btn.logic
    CustomSkillAiManage:openCustomSkillAiLayer(self.fightType)
end

return CrossArrayArmyLayer;