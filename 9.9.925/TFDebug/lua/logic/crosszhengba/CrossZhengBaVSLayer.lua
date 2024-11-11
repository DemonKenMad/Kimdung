-- client side CrossZhengBaVSLayer.lua
--[[
 * @Description: Description
 ]]
-- script writer chikui
-- creation time 2017-03-01

local CrossZhengBaVSLayer = class("BossFightArmyVSLayer", BaseLayer)

CREATE_SCENE_FUN(CrossZhengBaVSLayer)
CREATE_PANEL_FUN(CrossZhengBaVSLayer)

CrossZhengBaVSLayer.LIST_ITEM_WIDTH = 200 

function CrossZhengBaVSLayer:ctor(data)
    self.super.ctor(self,data)
    self:init("lua.uiconfig_mango_new.crosszhenba.CrossZhenBaVS")
end

function CrossZhengBaVSLayer:initUI(ui)
    self.super.initUI(self,ui)

    self.generalHead = CommonManager:addGeneralHead( self )
    self.generalHead:setData(ModuleType.CrossZhengBa,{HeadResType.COIN,HeadResType.SYCEE})

    self.panel_left   = TFDirector:getChildByPath(ui, 'Panel_1')
    self.panel_right   = TFDirector:getChildByPath(ui, 'Panel_2')

    
    self.btn_army       = TFDirector:getChildByPath(ui, 'btn_tz')
    self.btn_buzhen     = TFDirector:getChildByPath(ui, 'btn_buzhen')


    self.btn_tingzhan   = TFDirector:getChildByPath(ui, 'btn_tingzhan')
    self.txt_tip        = TFDirector:getChildByPath(self.btn_tingzhan, 'txt_tips')

    self.txt_name       = TFDirector:getChildByPath(ui, 'txt_mingcheng_word')

    self.txt_rank       = TFDirector:getChildByPath(ui, 'txt_paiming_word')
    self.txt_power      = TFDirector:getChildByPath(ui, 'txt_zhandouli_word')
    self.txt_winRate    = TFDirector:getChildByPath(ui, 'txt_shenglv_word')

    self.txt_szrs    = TFDirector:getChildByPath(ui, 'txt_szrs')

    self.img_rolebg = {}
    self.img_role = {}
    self.img_role_quility = {}


    --local resPath = "effect/arena_attack.xml"
    --TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    --local effect = TFArmature:create("arena_attack_anim")

    --effect:setAnimationFps(GameConfig.ANIM_FPS)
    --effect:setPosition(ccp(self:getSize().width/2 - 15,self:getSize().height/2 - 40))

    --self:addChild(effect,20)

    --effect:playByIndex(0, -1, -1, 0)

    self.fightType = EnumFightStrategyType.StrategyType_CROSSZHENGBA

    self.isFirstShow = true
end

function CrossZhengBaVSLayer:setUserData(userData)
    self.userData = userData
    -- print("self.userData = ", self.userData)
end

function CrossZhengBaVSLayer:loadData(userData,grade)
    self.userData = userData
    self.grade = grade
    -- print("self.userData = ", self.userData)
end

function CrossZhengBaVSLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow();
    self:refreshBaseUI()
    self:refreshUI()
    self:drawLeftArea()
    self:drawRightArea()

    Public:addZhenFaIconForArmy(self.panel_left, self.fightType)

    if self.isFirstShow == true then
        self.isFirstShow = false
        self.ui:runAnimation("Action0",1)
    end
end

function CrossZhengBaVSLayer:refreshBaseUI()
    local challengeInfo = CrossZhengBaManager:getMyChallengeInfo()
    local itemData = CrossZhengBaManager:getData(challengeInfo.grade)
    self.txt_tip:setText(stringUtils.format(localizable.CrossZhengBa_vs_Layer_tip2,itemData.stop_battle_count - challengeInfo.stopBattleCount))
end

function CrossZhengBaVSLayer:refreshUI()
    if not self.isShow then
        return
    end
end

function CrossZhengBaVSLayer:getRightRolePos(pos)
    if self.userData == nil then
        return nil
    end
    if self.userData.warside == nil then
        return
    end

    local idx = 0
    for _,v in pairs(self.userData.warside) do
        local cardRole = RoleData:objectByID(v.id)
        -- print("getRightRolePos = ", v)
        local idx = v.warIndex + 1
        if idx == pos then
            cardRole.maxHp  = 100
            cardRole.currHp = 100
            return cardRole
        end
    end
end

function CrossZhengBaVSLayer:getRightRoleInfoByPos(pos)
    if self.userData == nil then
        return nil
    end
    if self.userData.warside == nil then
        return
    end

    local idx = 0
    for _,v in pairs(self.userData.warside) do
        local cardRole = RoleData:objectByID(v.id)
        -- print("getRightRolePos = ", v)
        local idx = v.warIndex + 1
        if idx == pos then
            return v
        end
    end
end

function CrossZhengBaVSLayer.cellClickHandle(sender)
    local self = sender.logic
    local cardRoleId = sender.cardRoleId

    -- OtherPlayerManager:openRoleInfo(self.userData, cardRoleId)
    -- Public:ShowItemTipLayer(sender.role.id, EnumDropType.ROLE, 1,sender.role.level)
end

function CrossZhengBaVSLayer.onArmyClickHandle(sender)
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

function CrossZhengBaVSLayer:getChangeBtn()
    return self.btn_challenge
end

--注册事件
function CrossZhengBaVSLayer:registerEvents()
   self.super.registerEvents(self)
   -- ADD_ALERT_CLOSE_LISTENER(self,self.btn_close)
   -- self.btn_close:setClickAreaLength(100)
    
   
    self.btn_army.logic = self
    self.btn_army:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnAttackClickHandle),1)

    self.btn_tingzhan.logic = self
    self.btn_tingzhan:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onStopAttackClickHandle),1)


    local function enterStarge(sender)
        -- BloodFightManager:openRoleList(self.userData.section)
        ZhengbaManager:openArmyLayer(self.fightType, false)
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
    self.updateEudemonSucess = function(event)
        self:drawLeftArea()
    end;
    TFDirector:addMEGlobalListener(EudemonManager.EquipTeamEudemon ,self.updateEudemonSucess ) ;
    if self.generalHead then
        self.generalHead:registerEvents()
    end
end

function CrossZhengBaVSLayer:removeEvents()

    TFDirector:removeMEGlobalListener(ZhengbaManager.UPDATEFORMATIONSUCESS ,self.updatePosCallBack ) 
    self.updatePosCallBack = nil
    TFDirector:removeMEGlobalListener(EudemonManager.EquipTeamEudemon ,self.updateEudemonSucess)
    self.updateEudemonSucess = nil;
    if self.generalHead then
        self.generalHead:removeEvents()
    end
    self.super.removeEvents(self)
end


function CrossZhengBaVSLayer:drawLeftArea()
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
        self.button[i].img_type     = TFDirector:getChildByPath(self.button[i],"img_zhiye")


        self.button[i].quality = TFDirector:getChildByPath(self.panel_left, btnName)

        -- local role = self:getRightRolePos(i)
        self.button[i].bg.gmid = 0
        -- local role = BloodFightManager:getRoleByIndex(i)
        local role = ZhengbaManager:getRoleByIndex(self.fightType,i)

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
        
            local maxHp = 100--role.blood_maxHp
            local curHp = 100--role.blood_curHp

            self.button[i].img_type:setVisible(true)            
            self.button[i].icon:setVisible(true)
            self.button[i].bg:setVisible(true)

            self.button[i].icon:setFlipX(true)

            Public:addLianTiEffect(self.button[i].icon,role:getMaxLianTiQua(),true)
        else
            self.button[i].icon:setVisible(false)
            self.button[i].bg:setVisible(false)
            self.button[i].img_type:setVisible(false)
            Public:addLianTiEffect(self.button[i].icon,0,false)
        end
    end

    local txt_name = TFDirector:getChildByPath(self.panel_left, "txt_name")
    local txt_zhanli = TFDirector:getChildByPath(self.panel_left, "txt_zhanli")
    local img_dw = TFDirector:getChildByPath(self.panel_left, "img_dw")
    local txt_dw = TFDirector:getChildByPath(self.panel_left, "txt_dw")
    txt_name:setText(MainPlayer:getPlayerName())
    txt_zhanli:setText(AssistFightManager:getStrategyPower(self.fightType))
    local myChallengeInfo = CrossZhengBaManager:getMyChallengeInfo()
    local grade = 1
    if myChallengeInfo and myChallengeInfo.grade then
        grade = myChallengeInfo.grade
    end
    print("myChallengeInfo = ",myChallengeInfo)
    img_dw:setTexture(CrossZhengBaManager:getGradeImg(grade))
    self.txt_szrs:setText(ZhengbaManager:getFightRoleNum(self.fightType) .. "/" .. ZhengbaManager:getMaxNum(self.fightType))

    local img_headIcon = TFDirector:getChildByPath(self.panel_left, "img_role")         --pck change head icon and head icon frame
    img_headIcon:setTexture(MainPlayer:getIconPath())
    img_headIcon:setFlipX(true)
    Public:addFrameImg(img_headIcon,MainPlayer:getHeadPicFrameId())                     --end

    local itemData = CrossZhengBaManager:getData(grade)
    if itemData then
        txt_dw:setText(itemData.name)
    else
        txt_dw:setText("")
    end
end

function CrossZhengBaVSLayer:drawRightArea()
    self.button = {}
    for i=1,9 do
        local btnName = "panel_item" .. i
        self.button[i] = TFDirector:getChildByPath(self.panel_right, btnName)

        btnName = "btn_icon"..i
        self.button[i].bg = TFDirector:getChildByPath(self.panel_right, btnName)
        self.button[i].bg:setVisible(false)

        self.button[i].icon = TFDirector:getChildByPath(self.button[i].bg ,"img_touxiang")
        self.button[i].icon:setVisible(false)
        self.button[i].img_type     = TFDirector:getChildByPath(self.button[i],"img_zhiye")
        self.button[i].img_zf     = TFDirector:getChildByPath(self.button[i],"img_zf"..i)
        self.button[i].img_zf:setVisible(false)
        self.button[i].quality = TFDirector:getChildByPath(self.panel_right, btnName)

        local role = self:getRightRolePos(i)
        local role_info = self:getRightRoleInfoByPos(i)
        if  role ~= nil then
            self.button[i].icon:setVisible(true)
            self.button[i].icon:setTexture(role:getHeadPath())

            self.button[i].bg:setVisible(true)
            self.button[i].quality:setTextureNormal(GetColorRoadIconByQualitySmall(role_info.quality))
            -- self.button[i].quality:setTextureNormal(GetRoleBgByWuXueLevel_circle_small(role.martialLevel))

            self.button[i].bg.cardRoleId = role.id
            self.button[i].bg.role = role

            self.button[i].img_type:setVisible(true)
            self.button[i].img_type:setTexture("ui_new/fight/zhiye_".. role.outline ..".png")
            Public:addLianTiEffect(self.button[i].icon,role_info.forgingQuality,true)
        else
            self.button[i].icon:setVisible(false)
            self.button[i].bg:setVisible(false)     
        
            self.button[i].img_type:setVisible(false)
            Public:addLianTiEffect(self.button[i].icon,0,false)
        end
    end

    local txt_name = TFDirector:getChildByPath(self.panel_right, "txt_name")
    local txt_zhanli = TFDirector:getChildByPath(self.panel_right, "txt_zhanli")
    local img_dw = TFDirector:getChildByPath(self.panel_right, "img_dw")
    local txt_dw = TFDirector:getChildByPath(self.panel_right, "txt_dw")

    txt_zhanli:setVisible(true)
    txt_name:setText(self.userData.name)
    txt_zhanli:setText(self.userData.power)
    local playerId   = self.userData.playerId
    local grade = self.grade
    local path = CrossZhengBaManager:getGradeImg(grade)
    img_dw:setTexture(path)

    local img_headIcon = TFDirector:getChildByPath(self.panel_right, "img_role")
    local roleConfig = RoleData:objectByID(self.userData.icon)
    if roleConfig == nil then
        roleConfig = RoleData:objectByID(77)
    end
    img_headIcon:setTexture(roleConfig:getIconPath())
    Public:addFrameImg(img_headIcon,self.userData.headPicFrame) 
    local serverId = math.floor(playerId)
    serverId = math.floor(serverId/131072)
    serverId = math.mod(serverId,1000)
    self.txt_server = TFDirector:getChildByPath(self.panel_right, 'txt_name-Copy1')
    self.txt_server:setText("S" .. serverId)

    local itemData = CrossZhengBaManager:getData(grade)
    if itemData then
        txt_dw:setText(itemData.name)
    else
        txt_dw:setText("")
    end
end


function CrossZhengBaVSLayer.onBtnAttackClickHandle(sender)
    local self      = sender.logic
    local curNum = ZhengbaManager:getFightRoleNum(self.fightType)
    local maxNum = ZhengbaManager:getMaxNum(self.fightType)
    if curNum > maxNum then
        --"当前上阵人数不符"
        toastMessage(localizable.CrossZhengBa_Main_Layer_tip4)
        return
    end
    if CrossZhengBaManager.break_start_cost_tip == true then
        self:Attack()
        return
    end

    if curNum < maxNum then
        local myChallengeInfo = CrossZhengBaManager:getMyChallengeInfo()
        local itemData = CrossZhengBaManager:getData(myChallengeInfo.grade)
        local warningMsg = stringUtils.format(localizable.CrossZhengBa_vs_Layer_tip4,itemData.name,maxNum)
        CommonManager:showOperateSureTipLayer(
            function(data, widget)
                self:Attack()
                CrossZhengBaManager.break_start_cost_tip = widget:getSelectedState() or false;
            end,
            nil,
            {
                title=localizable.common_tips,
                msg=warningMsg,
                showtype = AlertManager.BLOCK_AND_GRAY_CLOSE
            }
        )
        return
    end
    self:Attack()
end

function CrossZhengBaVSLayer:Attack()
    local playerId   = self.userData.playerId
    AlertManager:closeLayer(self)
    local challengeInfo , index= CrossZhengBaManager:getChallengeInfoById( playerId )
    if challengeInfo and index then
        CrossZhengBaManager:requestFight(index - 1)
    end
end

function CrossZhengBaVSLayer.onStopAttackClickHandle( sender )
    local self      = sender.logic
    local playerId   = self.userData.playerId

    local warningMsg = localizable.CrossZhengBa_vs_Layer_tip
    local challengeInfo = CrossZhengBaManager:getMyChallengeInfo()
    local itemData = CrossZhengBaManager:getData(challengeInfo.grade)
    if challengeInfo.stopBattleCount + 1 >= itemData.stop_battle_count then
        warningMsg = localizable.CrossZhengBa_vs_Layer_tip1

        local timeNow = MainPlayer:getNowtime()
        local time = ConstantData:objectByID("Personal.Ladder.Battle.Cycle").value
        time = time * 24 * 3600
        local lastTime = CrossZhengBaManager:getLastFinishTime()
        local totalSec = lastTime + time - timeNow

        if totalSec < 23 * 3600 and challengeInfo and challengeInfo.star <= 0 then
            warningMsg = localizable.CrossZhengBa_vs_Layer_tip5
        end
    end
        
    CommonManager:showOperateSureLayer(
        function()
            AlertManager:closeLayer(self)
            local challengeInfo , index= CrossZhengBaManager:getChallengeInfoById( playerId )
            if challengeInfo and index then
                CrossZhengBaManager:requestStop(index - 1)
            end
        end,
        nil,
        {
            msg = warningMsg
        }
    )
    
end

function CrossZhengBaVSLayer.cellTouchBeganHandle(cell)
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

function CrossZhengBaVSLayer.cellTouchMovedHandle(cell)
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


function CrossZhengBaVSLayer.cellTouchEndedHandle(cell)
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

function CrossZhengBaVSLayer:removeLongTouchTimer()
    if (self.longTouchTimerId) then
        TFDirector:removeTimer(self.longTouchTimerId)
        self.longTouchTimerId = nil
    end
end

function CrossZhengBaVSLayer:createSelectCussor(cell,pos)
    play_press()

    cell.isClick = false

    self.lastPoint = pos

    local role = CardRoleManager:getRoleByGmid(cell.gmId)
    self.selectCussor = TFImage:create()
    self.selectCussor:setFlipX(true)
    self.selectCussor:setTexture(role:getHeadPath())
    self.selectCussor:setScale(1)
    self.selectCussor:setPosition(ccpAdd(pos,ccp(0,-0)) )
    self:addChild(self.selectCussor)
    self.selectCussor:setZOrder(100)
   
    self.curIndex = cell.posIndex
    
end

function CrossZhengBaVSLayer:moveSelectCussor(cell,pos)
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

function CrossZhengBaVSLayer:releaseSelectCussor(cell,pos)
    if cell.isClick == false  then
        if (self.curIndex == nil) then
            return
        end
        local dargRole      = CardRoleManager:getRoleByGmid(cell.gmId)
        local toReplaceRole = ZhengbaManager:getRoleByIndex(self.fightType,self.curIndex);
        --在阵中释放
        if (self.curIndex ~= -1) then 
            --从列表中拖到阵中
            if (cell.posIndex == -1) then
                --本来已经在阵中
                if dargRole.pos and dargRole.pos ~= 0 then
                    --且不是本角色目前所在的位置，做位置变更
                    if (toReplaceRole == nil or (toReplaceRole and toReplaceRole.gmId ~= dargRole.gmId)) then
                        ZhengbaManager:ChangePos(self.fightType ,dargRole.pos , self.curIndex ,nil)
                        
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
                    ZhengbaManager:OnBattle(self.fightType ,cell.gmId, ( self.curIndex ), nil)
                    play_buzhenyidong()

                end

            --阵中操作，更换位置   
            else
                ZhengbaManager:ChangePos(self.fightType ,cell.posIndex , self.curIndex ,nil)
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
                    ZhengbaManager:OutBattle(self.fightType ,cell.gmId, nil)
                    play_buzhenluoxia()
                --end
            end
        end
    end


end

return CrossZhengBaVSLayer
