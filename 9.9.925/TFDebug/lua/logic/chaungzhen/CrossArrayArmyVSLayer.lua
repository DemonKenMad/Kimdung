-- client side CrossArrayArmyVSLayer.lua
--[[
 * @Description: 闯阵战斗准备节目
 ]]
-- script writer Stephen.tao
-- creation time 2016-08-13

local CrossArrayArmyVSLayer = class("CrossArrayArmyVSLayer", BaseLayer)
CREATE_SCENE_FUN(CrossArrayArmyVSLayer)
CREATE_PANEL_FUN(CrossArrayArmyVSLayer)

function CrossArrayArmyVSLayer:ctor(data)
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.crossarray.CrossArrayArmyVSLayer")
end

function CrossArrayArmyVSLayer:initUI(ui)
    self.super.initUI(self,ui)

    self.panel_left   = TFDirector:getChildByPath(ui, 'panel_buzhen')
    self.panel_right   = TFDirector:getChildByPath(ui, 'panel_buzhen1')

    self.btn_close      = TFDirector:getChildByPath(ui, 'btn_close')
    
    self.btn_army       = TFDirector:getChildByPath(ui, 'btn_challenge')
    self.btn_buzhen     = TFDirector:getChildByPath(ui, 'btn_buzhen')


    self.btn_close      = TFDirector:getChildByPath(ui, 'btn_close')

    self.txt_name       = TFDirector:getChildByPath(ui, 'txt_mingcheng_word')

    self.txt_rank       = TFDirector:getChildByPath(ui, 'txt_paiming_word')
    self.txt_power      = TFDirector:getChildByPath(ui, 'txt_zhandouli_word')
    self.txt_winRate    = TFDirector:getChildByPath(ui, 'txt_shenglv_word')


    self.img_rolebg = {}
    self.img_role = {}
    self.img_role_quility = {}
end

function CrossArrayArmyVSLayer:setBossData(userData , gridIndex)
    self.BossData = userData
    self.gridIndex = gridIndex
end

function CrossArrayArmyVSLayer:onShow()
    self.super.onShow(self)
    self:refreshBaseUI()
    self:refreshUI()
    self:drawLeftArea()
    self:drawRightArea()
    Public:addZhenFaIconForArmy(self.panel_left, EnumFightStrategyType.StrategyType_CHUANGZHEN)
end

function CrossArrayArmyVSLayer:refreshBaseUI()

end

function CrossArrayArmyVSLayer:refreshUI()
    if not self.isShow then
        return
    end

end

function CrossArrayArmyVSLayer:getRoleBtPos(pos)
    local temptbl = string.split(self.BossData.formation,',')
    local idx = 0
    for k,v in pairs(temptbl) do
    -- for _,v in pairs(self.BossData.posInfo) do
        idx = idx + 1
        local roleId = tonumber(v)
        if idx == pos and roleId > 0 then
            local NpcId = tonumber(v)

            local npcInfo = NPCData:objectByID(NpcId)
            if npcInfo then
                local cardRole = RoleData:objectByID(npcInfo.role_id)
                -- self.cardRole   = CardRole:new(self.roleid)
                print("roleId = ", roleId)
                return cardRole
            end
        end
    end
    -- if pos == 5 then
    --         local roleId = self.bossId
    --         local cardRole = RoleData:objectByID(roleId)
    --         -- self.cardRole   = CardRole:new(self.roleid)
    --         cardRole.level  = 100
    --         cardRole.maxHp  = 100
    --         cardRole.currHp = 100
    --         return cardRole
    -- end
end

function CrossArrayArmyVSLayer.cellClickHandle(sender)
    local self = sender.logic
    local cardRoleId = sender.cardRoleId
    Public:ShowItemTipLayer(sender.role.id, EnumDropType.ROLE, 1,sender.role.level)
end

function CrossArrayArmyVSLayer.onArmyClickHandle(sender)
    local self = sender.logic
    local gmid = sender.gmid

    if sender.isClick == false then
        return
    end

--     print("gmid = ", gmid)
--     if gmid > 0 then
--         -- CardRoleManager:setSortBloodStrategyForQuality()
--         CardRoleManager:openRoleInfo(gmid)
--     end
end

function CrossArrayArmyVSLayer:getChangeBtn()
    return self.btn_challenge
end

--注册事件
function CrossArrayArmyVSLayer:registerEvents()
   self.super.registerEvents(self)
   ADD_ALERT_CLOSE_LISTENER(self,self.btn_close)
   self.btn_close:setClickAreaLength(100)
    
   
    self.btn_army.logic = self
    self.btn_army:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnAttackClickHandle),1)


    local function enterStarge(sender)
        ChuangzhenManager:openRoleList(self.gridIndex or 1)
    end
    self.btn_buzhen:addMEListener(TFWIDGET_CLICK,  audioClickfun(enterStarge),1)

   for i=1,9 do
        local bg = TFDirector:getChildByPath(self.panel_right, "btn_icon"..i)
        bg.logic = self
        bg:addMEListener(TFWIDGET_CLICK, audioClickfun(self.cellClickHandle),1)
    end

    for i=1,9 do
        local bg = TFDirector:getChildByPath(self.panel_left, "btn_icon"..i)
        bg.logic = self
        bg.posIndex = i

        bg:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onArmyClickHandle),1)

        bg:addMEListener(TFWIDGET_TOUCHBEGAN, self.cellTouchBeganHandle,1)
        bg:addMEListener(TFWIDGET_TOUCHMOVED, self.cellTouchMovedHandle)
        bg:addMEListener(TFWIDGET_TOUCHENDED, self.cellTouchEndedHandle)   
    end

    self.updatePosCallBack = function(event)
        self:drawLeftArea()
    end
    TFDirector:addMEGlobalListener(ZhengbaManager.UPDATEFORMATIONSUCESS ,self.updatePosCallBack )
    --
    self.updateEudemonSucess = function(event)
        self:drawLeftArea()
    end
    TFDirector:addMEGlobalListener(EudemonManager.EquipTeamEudemon ,self.updateEudemonSucess ) ;
end

function CrossArrayArmyVSLayer:removeEvents()

    TFDirector:removeMEGlobalListener(ZhengbaManager.UPDATEFORMATIONSUCESS ,self.updatePosCallBack ) 
    self.updatePosCallBack = nil

    TFDirector:removeMEGlobalListener(EudemonManager.EquipTeamEudemon ,self.updateEudemonSucess)
    self.updateEudemonSucess = nil;
    self.super.removeEvents(self)
end


function CrossArrayArmyVSLayer:drawLeftArea()
    self.button_self = {}
    self.button = {}
    for i=1,9 do
        local btnName = "panel_item" .. i
        self.button[i] = TFDirector:getChildByPath(self.panel_left, btnName)

        self.button_self[i] = self.button[i]
        self.button_self[i].posIndex = i

        btnName = "btn_icon"..i
        self.button[i].bg = TFDirector:getChildByPath(self.panel_left, btnName)
        self.button[i].bg:setVisible(false)

        self.button[i].icon = TFDirector:getChildByPath(self.button[i].bg ,"img_touxiang")
        self.button[i].icon:setVisible(false)

        self.button[i].bar_bg       = TFDirector:getChildByPath(self.button[i],"img_xuetiao"..i)
        self.button[i].bar_hp       = TFDirector:getChildByPath(self.button[i],"bar_xuetiao"..i)
        self.button[i].img_type     = TFDirector:getChildByPath(self.button[i],"img_zhiye")
        self.button[i].img_death    = TFDirector:getChildByPath(self.button[i],"img_death"..i)


        self.button[i].quality = TFDirector:getChildByPath(self.panel_left, btnName)

        self.button[i].img_death:setVisible(false)

        self.button[i].bg.gmid = 0

        local role = ZhengbaManager:getRoleByIndex( EnumFightStrategyType.StrategyType_CHUANGZHEN ,i)

        self.button[i].bg.hasRole = false
        self.button[i].bg.gmId = 0
        if  role ~= nil then

            self.button[i].bg.gmId = role.gmId
            self.button[i].bg.hasRole = true
            self.button[i].bg.gmid = role.gmId
            
            self.button[i].icon:setVisible(true)
            self.button[i].icon:setTexture(role:getHeadPath())

            self.button[i].bg:setVisible(true)
            self.button[i].quality:setTextureNormal(GetColorRoadIconByQualitySmall(role.quality))
            -- self.button[i].quality:setTextureNormal(GetRoleBgByWuXueLevel_circle_small(role.martialLevel))

            self.button[i].bg.cardRoleId = role.id
            self.button[i].bg.role = role

            self.button[i].img_type:setVisible(true)
            self.button[i].img_type:setTexture("ui_new/fight/zhiye_".. role.outline ..".png")
        
            local percent  = ChuangzhenManager:getRoleStateById( role.gmId )

            if percent <= 0 then
                self.button[i].img_death:setVisible(true)
                self.button[i].icon:setShaderProgram("GrayShader", true)
            else
                self.button[i].img_death:setVisible(false)
                self.button[i].icon:setShaderProgramDefault(true)
                -- self.button[i].icon:setShaderProgram("GrayShader", false)
            end

            self.button[i].bar_hp:setPercent(percent*100 )

            self.button[i].bar_bg:setVisible(true)
            self.button[i].img_type:setVisible(true)            
            self.button[i].icon:setVisible(true)
            self.button[i].bg:setVisible(true)

            self.button[i].icon:setFlipX(true)
            Public:addLianTiEffect(self.button[i].icon,role:getMaxLianTiQua(),true)
        else
            self.button[i].icon:setVisible(false)
            self.button[i].bg:setVisible(false)     
        
            self.button[i].bar_bg:setVisible(false)
            self.button[i].img_type:setVisible(false)
            Public:addLianTiEffect(self.button[i].icon,0,false)
        end
    end

    local txt_name = TFDirector:getChildByPath(self.panel_left, "txt_name")
    local txt_zhanli = TFDirector:getChildByPath(self.panel_left, "txt_zhanli")
    txt_name:setText(MainPlayer:getPlayerName())
    txt_zhanli:setText(ZhengbaManager:getPower(EnumFightStrategyType.StrategyType_CHUANGZHEN))

end

function CrossArrayArmyVSLayer:drawRightArea()
    self.button = {}
    for i=1,9 do
        local btnName = "panel_item" .. i
        self.button[i] = TFDirector:getChildByPath(self.panel_right, btnName)

        btnName = "btn_icon"..i
        self.button[i].bg = TFDirector:getChildByPath(self.panel_right, btnName)
        self.button[i].bg:setVisible(false)

        self.button[i].icon = TFDirector:getChildByPath(self.button[i].bg ,"img_touxiang")
        self.button[i].icon:setVisible(false)

        self.button[i].bar_bg       = TFDirector:getChildByPath(self.button[i],"img_xuetiao"..i)
        self.button[i].bar_hp       = TFDirector:getChildByPath(self.button[i],"bar_xuetiao"..i)
        self.button[i].img_type     = TFDirector:getChildByPath(self.button[i],"img_zhiye")
        self.button[i].img_death    = TFDirector:getChildByPath(self.button[i],"img_death"..i)

        self.button[i].quality = TFDirector:getChildByPath(self.panel_right, btnName)

        self.button[i].img_death:setVisible(false)

        local role = self:getRoleBtPos(i)
        if  role ~= nil then
            self.button[i].icon:setVisible(true)
            self.button[i].icon:setTexture(role:getHeadPath())

            self.button[i].bg:setVisible(true)
            self.button[i].quality:setTextureNormal(GetColorRoadIconByQualitySmall(role.quality))
            -- self.button[i].quality:setTextureNormal(GetRoleBgByWuXueLevel_circle_small(role.martialLevel))

            self.button[i].bg.cardRoleId = role.id
            self.button[i].bg.role = role

            self.button[i].img_type:setVisible(true)
            self.button[i].img_type:setTexture("ui_new/fight/zhiye_".. role.outline ..".png")

            self.button[i].bar_hp:setPercent( 100 )
        else
            self.button[i].icon:setVisible(false)
            self.button[i].bg:setVisible(false)     
        
            self.button[i].bar_bg:setVisible(false)
            self.button[i].img_type:setVisible(false)
        end
    end

    local txt_name = TFDirector:getChildByPath(self.panel_right, "txt_name")
    local txt_zhanli = TFDirector:getChildByPath(self.panel_right, "txt_zhanli")


    local txt_weizhizhandouli    = TFDirector:getChildByPath(self.panel_right, 'txt_weizhizhandouli')
    txt_weizhizhandouli:setVisible(false)
    txt_zhanli:setVisible(true)

    txt_name:setText(self.BossData.name)
    txt_zhanli:setText(self.BossData.power)
end


function CrossArrayArmyVSLayer.onBtnAttackClickHandle(sender)
    local self      = sender.logic
    self:Attack()
end

function CrossArrayArmyVSLayer:Attack()

    local gridIndex   = self.gridIndex 
    print("开始挑战")
    AlertManager:close(AlertManager.TWEEN_NONE)
    ChuangzhenManager:OpenPoint( gridIndex )

end


function CrossArrayArmyVSLayer.cellTouchBeganHandle(cell)
    local self = cell.logic
    if cell.hasRole ~= true then
        return
    end

    cell.isClick = true
    cell.isDrag  = false
    self.isMove = false


    self.onLongTouch = function(event)
        if self.isMove == false then
            return
        end

        local pos = cell:getTouchMovePos()
          
        local v = ccpSub(cell:getTouchStartPos(), cell:getTouchMovePos())
       
        if (v.x < 30 and v.y < 30 )  then
            -- if (v.x < 0 or v.y < 0 ) then
            --     self:removeLongTouchTimer()  
            --     cell.isDrag  = false
            -- end
            -- self:removeLongTouchTimer()
            -- self.longTouchTimerId = TFDirector:addTimer(0.001, 1, nil, self.onLongTouch) 

        else 
            self:removeLongTouchTimer()    
            if (v.x - v.y > -10) then
                cell.isDrag  = true
            else
                cell.isDrag  = false
            end
        end
    end

    if (cell.posIndex == -1) then
        self:removeLongTouchTimer()
        self.longTouchTimerId = TFDirector:addTimer(0.001, -1, nil, self.onLongTouch) 
    end

end

function CrossArrayArmyVSLayer.cellTouchMovedHandle(cell)
    local self = cell.logic
    self.isMove = true

    if cell.hasRole ~= true then
        return
    end

           
    local v = ccpSub(cell:getTouchStartPos(), cell:getTouchMovePos())



    local pos = cell:getTouchMovePos()

    if self.selectCussor == nil then

        if (cell.posIndex ~= -1) then
            if (v.y < 30 and v.y > -30) and  (v.x < 30 and v.x > -30)  then
               return
            end
        end

        if (cell.posIndex ~= -1 or cell.isDrag == true ) then
            self:createSelectCussor(cell,pos)
        end
    end

    if cell.isClick == true then
        return
    end

    self:moveSelectCussor(cell,pos)
end


function CrossArrayArmyVSLayer.cellTouchEndedHandle(cell)
    local self = cell.logic
    if self.selectCussor then
        self.selectCussor:removeFromParentAndCleanup(true)
        self.selectCussor = nil
    end

    if cell.hasRole ~= true then
        return
    end

    self:removeLongTouchTimer()
    local pos = cell:getTouchEndPos()
    self:releaseSelectCussor(cell,pos)
end

function CrossArrayArmyVSLayer:removeLongTouchTimer()
    if (self.longTouchTimerId) then
        TFDirector:removeTimer(self.longTouchTimerId)
        self.longTouchTimerId = nil
    end
end

function CrossArrayArmyVSLayer:createSelectCussor(cell,pos)
    play_press()

    cell.isClick = false

    self.lastPoint = pos

    local role = CardRoleManager:getRoleByGmid(cell.gmId)
    self.selectCussor = TFImage:create()
    self.selectCussor:setFlipX(true)
    self.selectCussor:setTexture(role:getHeadPath())
    self.selectCussor:setScale(1)
    self.selectCussor:setPosition(ccpAdd(pos,ccp(-80,-0)) )
    self:addChild(self.selectCussor)
    self.selectCussor:setZOrder(100)
   
    self.curIndex = cell.posIndex
    
end

function CrossArrayArmyVSLayer:moveSelectCussor(cell,pos)
    local v = ccpSub(pos, self.lastPoint)
    self.lastPoint = pos
    local scp = ccpAdd(self.selectCussor:getPosition(), v)
    self.selectCussor:setPosition(scp)
    self.selectCussor:setVisible(true)

    self.curIndex = nil

    for i=1,9 do
        if  self.button_self[i]:hitTest(pos) then
            self.curIndex = self.button_self[i].posIndex
            break
        end
    end

end

function CrossArrayArmyVSLayer:releaseSelectCussor(cell,pos)
    if cell.isClick == false  then
        if (self.curIndex == nil) then
            return
        end
        local dargRole      = CardRoleManager:getRoleByGmid(cell.gmId)
        local toReplaceRole = ZhengbaManager:getRoleByIndex(EnumFightStrategyType.StrategyType_CHUANGZHEN,self.curIndex);
        --在阵中释放
        if (self.curIndex ~= -1) then 
            --从列表中拖到阵中
            if (cell.posIndex == -1) then
                --本来已经在阵中
                if dargRole.pos and dargRole.pos ~= 0 then
                    --且不是本角色目前所在的位置，做位置变更
                    if (toReplaceRole == nil or (toReplaceRole and toReplaceRole.gmId ~= dargRole.gmId)) then
                        ZhengbaManager:ChangePos(EnumFightStrategyType.StrategyType_CHUANGZHEN ,dargRole.pos , self.curIndex ,nil)
                        
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
                --上阵，如果目标存在角色，将其下阵
                else
                    ZhengbaManager:OnBattle(EnumFightStrategyType.StrategyType_CHUANGZHEN,cell.gmId, ( self.curIndex ), nil)
                    play_buzhenyidong()

                end

            --阵中操作，更换位置   
            else
                ZhengbaManager:ChangePos(EnumFightStrategyType.StrategyType_CHUANGZHEN ,cell.posIndex , self.curIndex ,nil)
                play_buzhenyidong()
            end

            return
        end

        --在右边列表释放
        if (self.curIndex == -1) then

            if (cell.posIndex == -1 ) then
                --放弃上阵，不做操作

            else
                    print("下阵:",dargRole.name)
                    ZhengbaManager:OutBattle(EnumFightStrategyType.StrategyType_CHUANGZHEN,cell.gmId, nil)
                    play_buzhenluoxia()
                --end
            end
        end
    end


end

return CrossArrayArmyVSLayer
