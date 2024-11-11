local FengYunLuMainLayer = class("FengYunLuMainLayer", BaseLayer);

CREATE_SCENE_FUN(FengYunLuMainLayer);
CREATE_PANEL_FUN(FengYunLuMainLayer);

--[[
风云录主界面
]]
-- 1~3为关卡 正常 点击 挑战完毕 状态图
local path1 ={"ui_new/fengyunlu/tab_title.png","ui_new/fengyunlu/tab_title2.png","ui_new/fengyunlu/tab_title3.png"}
local path2 ={"ui_new/fengyunlu/tab_title_h.png","ui_new/fengyunlu/tab_title2_h.png","ui_new/fengyunlu/tab_title3_h.png"}
local path3 ={"ui_new/fengyunlu/tab_title_hui.png","ui_new/fengyunlu/tab_title2_hui.png","ui_new/fengyunlu/tab_title3_hui.png"}
--排名
local path4 = {"ui_new/leaderboard/no1.png", "ui_new/leaderboard/no2.png", "ui_new/leaderboard/no3.png"}
function FengYunLuMainLayer:ctor(data)
    self.super.ctor(self,data);
    
    self:init("lua.uiconfig_mango_new.fengyunlu.FengYunLuMain");
end


function FengYunLuMainLayer:onShow()
    self.super.onShow(self)
    if (self.generalHead) then
        self.generalHead:onShow();
    end
    self:refreshUI();
end


function FengYunLuMainLayer:initUI(ui)
    self.super.initUI(self,ui);
    self.generalHead = CommonManager:addGeneralHead(self)

    self.generalHead:setData(ModuleType.FengYunLu,{HeadResType.COIN,HeadResType.SYCEE})
    --按钮
    ViewSizeCheck(TFDirector:getChildByPath(ui, "bg"))
    self.btn_lszr               = TFDirector:getChildByPath(ui, "btn_lszr") 
    self.btn_phjl               = TFDirector:getChildByPath(ui, "btn_phjl") 
    self.btn_fyb                = TFDirector:getChildByPath(ui, "btn_fyb") 
    self.btn_fyg                = TFDirector:getChildByPath(ui, "btn_fyg") 
    self.panel_tiaozhan         = TFDirector:getChildByPath(ui, "panel_tiaozhan") 
    self.btn_tz                 = TFDirector:getChildByPath(self.panel_tiaozhan, "btn_tz") 

    self.txt_num                = TFDirector:getChildByPath(self.panel_tiaozhan, "txt_num") 
    self.txt_time               = TFDirector:getChildByPath(self.panel_tiaozhan, "txt_time") 
    self.panel_paihang          = TFDirector:getChildByPath(ui, "panel_paihang")  
    --我的排名 
    self.txt_paiming            = TFDirector:getChildByPath(ui, "txt_paiming")
    self.txt_paiming:setPositionY(self.txt_paiming:getPositionY() - 10)
    self.txt_wsb                = TFDirector:getChildByPath(ui, "txt_wsb") 
    --我的出手次数
    self.txt_jifen            = TFDirector:getChildByPath(self.panel_paihang, "txt_jifen1") 
    self.txt_jifen:setPositionY(self.txt_jifen:getPositionY() - 10)
    self.txt_wcs                = TFDirector:getChildByPath(ui, "txt_wcs")
    --已获得
    self.img_yhd                = TFDirector:getChildByPath(ui, "img_yhd")
    --
    self.txt_ktz                = TFDirector:getChildByPath(ui, "txt_ktz")
    local txt_tzkqsj                = TFDirector:getChildByPath(ui, "txt_tzkqsj")
    self.txt_ktz:setText(localizable.UILayer_tips_32)
    txt_tzkqsj:setText(localizable.UILayer_tips_33)
    self.btn_help                = TFDirector:getChildByPath(self.panel_paihang, "btn_help")
    
    --阵容显示
    self.panel_roleList ={}
    for i =1 ,9 do 
        local panel         = TFDirector:getChildByPath(ui, "panel_role"..i) 
        panel.img_role      = TFDirector:getChildByPath(panel, "img_role") 
        panel.img_xuetiao1  = TFDirector:getChildByPath(panel, "img_xuetiao1") 
        panel.img_zhiye     = TFDirector:getChildByPath(panel, "img_zhiye") 
        panel.img_role:setVisible(false)
        panel.img_zhiye:setVisible(false)
        panel.img_xuetiao1:setVisible(false)
        panel:setVisible(false)
        self.panel_roleList[i] = panel
        local num = i % 3
        if num == 0 then
            num = 3
        end
        panel:setPositionX(num * 150 - 200 )
    end
    --首次奖励
    self.panel_reward = {}
    for i = 1,3 do
        local reward         = TFDirector:getChildByPath(ui, "btn_tool"..i) 
        reward.img_tool1     = TFDirector:getChildByPath(reward, "img_tool1") 
        reward.txt_num1      = TFDirector:getChildByPath(reward, "txt_num1") 
        self.panel_reward[i] = reward
    end
    --关卡btn
    self.panel_button = TFDirector:getChildByPath(ui, "panel_button")
    self.guankabtn = {}
    self.guankabtnClose = {}
    for i = 1,3 do 
        local btn         = TFDirector:getChildByPath(self.panel_button, "btn_gk"..i) 
        btn.index = i
        btn.logic = self
        self.guankabtn[i]    = btn
        btn         = TFDirector:getChildByPath(self.panel_button, "btn_gk"..i.."_yjs")
        btn.img_yjs = TFDirector:getChildByPath(btn, "img_yjs")
        btn:setVisible(false) 
        btn.index = i
        btn.logic = self
        self.guankabtnClose[i]    = btn
        
    end
    --排行榜
    self.panel_list = TFDirector:getChildByPath(ui, "panel_list")
    self.panel_list:setAnchorPoint(ccp(0,0))
    self.panel_list:setPositionX(-252)
    self.bg = TFDirector:getChildByPath(self.panel_list, "bg_0")
    self.bg:retain()
    self.bg:removeFromParent()
    self.RankList = {}
    self.index = FengYunLuManager.day
    if FengYunLuManager.day == 0 then
        self.index = 1
    end
end

function FengYunLuMainLayer:refreshUI()
    self.RankList  = FengYunLuManager.MianRankList[self.index] or nil
    self:refreshBtn()
    self:refreshBoss()
    self:refreshTableView()
    self.txt_num:setText(FengYunLuManager.challengeCount)
    self.txt_time:setText(localizable.FengYunLu_Time[self.index])
    if FengYunLuManager.isPass[self.index] == 1 then
        self.img_yhd:setVisible(true)
    else
        self.img_yhd:setVisible(false)
    end

end
function FengYunLuMainLayer:refreshTableView()
    if self.RecordList ~= nil then
        self.RecordList:removeFromParent()
        self.RecordList = nil
    end
    self.RecordList = TFTableView:create()
    self.RecordList.logic = self
    local Size = self.panel_list:getSize()
    self.RecordList:setTableViewSize(CCSizeMake(Size.width, Size.height))
    self.RecordList:setDirection(TFTableView.TFSCROLLVERTICAL)
    self.RecordList:setVerticalFillOrder(TFTableView.TFTabViewFILLTOPDOWN)

    self.RecordList:addMEListener(TFTABLEVIEW_SIZEFORINDEX, FengYunLuMainLayer.cellSizeForTable)
    self.RecordList:addMEListener(TFTABLEVIEW_SIZEATINDEX, FengYunLuMainLayer.tableCellAtIndex)
    self.RecordList:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, FengYunLuMainLayer.numberOfCellsInTableView)
    self.panel_list:addChild(self.RecordList)
    self.RecordList:reloadData()

end

function FengYunLuMainLayer.cellSizeForTable(table,idx)
    return 61,754
end

function FengYunLuMainLayer.numberOfCellsInTableView(table,idx)
    local self = table.logic
    if self.RankList and next(self.RankList) ~= nil then
        return #self.RankList or 0
    else
        return 0
    end
    
end

function FengYunLuMainLayer.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.bg:clone()
        panel:setVisible(true)
        cell.panel = panel
        cell:addChild(panel)
    end
    cell.panel:setPosition(ccp(250,0))
    self:setCellData(cell.panel,idx + 1)
    return cell
end

function FengYunLuMainLayer:setCellData(panel,index)
   local img_no =  TFDirector:getChildByPath(panel, "img_no") 
   local txt_shunxu =  TFDirector:getChildByPath(panel, "txt_shunxu") 
   if index <= 3 then
        img_no:setVisible(true)
        img_no:setTexture(path4[index])
        txt_shunxu:setVisible(false)
    else
        img_no:setVisible(false)
        txt_shunxu:setVisible(true)
        txt_shunxu:setText(index)
    end
    local txt_no1 =  TFDirector:getChildByPath(panel, "txt_no1") 
    txt_no1:setText(self.RankList[index].playerName)
    local txt_jifen =  TFDirector:getChildByPath(panel, "txt_jifen")
    txt_jifen:setText(localizable.FengYunLu_tips1 ..self.RankList[index].achievement)
    
    
end
function FengYunLuMainLayer:refreshBtn()
    for i =1, 3 do 
        if i < FengYunLuManager.day then
            self.guankabtnClose[i]:setVisible(true)
            self.guankabtn[i]:setVisible(false)
            self.guankabtnClose[i].img_yjs:setTexture("ui_new/fengyunlu/img_yjs.png")
            if i == self.index then
                self.guankabtnClose[i]:setVisible(false)
                self.guankabtn[i]:setVisible(true)
                self.guankabtn[i]:setTextureNormal(path1[i])
            end
        elseif i == FengYunLuManager.day then
            self.guankabtnClose[i]:setVisible(false)
            self.guankabtn[i]:setVisible(true)
            self.guankabtn[i]:setTextureNormal(path1[i])
        else
            self.guankabtnClose[i]:setVisible(true)
            self.guankabtn[i]:setVisible(false)
            self.guankabtnClose[i]:setTextureNormal(path3[i])
            self.guankabtnClose[i].img_yjs:setTexture("ui_new/fengyunlu/img_wkq.png")
        end 
    end
    self.guankabtnClose[self.index]:setVisible(false)
    self.guankabtn[self.index]:setVisible(true)
    self.guankabtn[self.index]:setTextureNormal(path2[self.index])


    if self.index ~= FengYunLuManager.day then
        self.btn_tz:setTouchEnabled(false)
        self.btn_tz:setGrayEnabled(true)
        self.txt_ktz:setVisible(false)
    else
        local data = os.date("*t",MainPlayer:getNowtime())
        if data.hour < 10 or data.hour > 21 then
            self.btn_tz:setTouchEnabled(false)
            self.btn_tz:setGrayEnabled(true)
            self.txt_ktz:setVisible(false)
        else
            self.btn_tz:setGrayEnabled(false)
            self.btn_tz:setTouchEnabled(true)
            self.txt_ktz:setVisible(true)
        end
    end
    if FengYunLuManager.rankid == -1 then
        self.btn_tz:setTouchEnabled(false)
        self.btn_tz:setGrayEnabled(true)
        self.txt_ktz:setVisible(false)
    end
    if FengYunLuManager.challengeCount < 0 then
        self.btn_tz:setTextureNormal("ui_new/fengyunlu/btn_cztz.png")
    else
        self.btn_tz:setTextureNormal("ui_new/spectrum/herolist/btn_tz.png")
    end

     --我的排名
    if FengYunLuManager.MyInfoinpass[self.index] and FengYunLuManager.MyInfoinpass[self.index].myRanking and FengYunLuManager.MyInfoinpass[self.index].myRanking ~= -1 then
        self.txt_paiming:setText(FengYunLuManager.MyInfoinpass[self.index].myRanking)
        self.txt_paiming:setVisible(true)
        self.txt_wsb:setVisible(false)
    else
        self.txt_wsb:setVisible(true)
        self.txt_paiming:setVisible(false)
    end
    --我的出手次数
    if FengYunLuManager.MyInfoinpass[self.index] and FengYunLuManager.MyInfoinpass[self.index].myAchievement and FengYunLuManager.MyInfoinpass[self.index].myAchievement ~=-1  then
        self.txt_jifen:setText(FengYunLuManager.MyInfoinpass[self.index].myAchievement)
        self.txt_jifen:setVisible(true)
        self.txt_wcs:setVisible(false)
    else
        self.txt_jifen:setVisible(false)
        self.txt_wcs:setVisible(true)
    end
end

function FengYunLuMainLayer:refreshLoadBoss()
    self.bLoadRole = true
    local list = FYRecordlineUoData:getNpcposandRoleBystageandday(FengYunLuManager.ranktype,self.index)
    if(not list) then
        toastMessage(localizable.common_error)
        return
    end
    if (self.lastList) then
        local bLoad = true
        for k,v in pairs(self.lastList) do
            if (v ~= list[k]) then
                bLoad = false
                break
            end
        end
        if (bLoad) then
            return
        end
    end
    self.lastList = list
    -- for i = 1,#list do
    --     self.panel_roleList[i]:setVisible(false)
    --     if list[i] and tonumber(list[i]) ~= 0 then
    --         local role = FYRecordData:getRoleinfoByid(tonumber(list[i]))
    --         if role then
    --             local armature = self:getArmature_ios(role.image,i);
    --             -- IOS做特殊处理
    --             -- if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
    --             --     armature = self:getArmature_ios(role.image,i);
    --             -- else
    --             --     armature = self:getArmature(role.image,i);
    --             -- end
                
    --             self:AddRoleFootEffect(armature);
    --             self.panel_roleList[i]:setVisible(true)
    --             if self.panel_roleList[i].armature ~= nil then
    --                 self.panel_roleList[i].armature:removeFromParent()
    --                 self.panel_roleList[i].armature = nil
    --             end
    
    --             self.panel_roleList[i].armature = armature
    --             self.panel_roleList[i]:addChild(armature,1,i)
    --         end
    --     end
    -- end
    TFDirector:removeTimer(self.loadRoleTimer)
    self.loadRoleTimer = nil
    for i,v in ipairs(self.panel_roleList) do
        v:setVisible(false)
    end
    local loacMax = #list
    local nLocaIndex = 1
    local function loadCompleteFun()
        TFDirector:removeTimer(self.loadRoleTimer)
        self.loadRoleTimer = nil
        --

    end
    local lastLoadCount = 0
    local function loadRoleFun(index)

        if (nLocaIndex == lastLoadCount) then
            return
        end
        if (nLocaIndex > loacMax) then
            TFDirector:removeTimer(self.loadRoleTimer)
            self.loadRoleTimer = nil
            return
        end
        index = list[nLocaIndex]
        local role = FYRecordData:getRoleinfoByid(tonumber(index))
        local panelRole = self.panel_roleList[nLocaIndex]
        if (role and panelRole and tonumber(index)  ~= 0) then
            if (panelRole.armature) then
                if (panelRole.armature.imageId == role.image) then
                    lastLoadCount = nLocaIndex
                    nLocaIndex = nLocaIndex + 1
                    panelRole:setVisible(true)
                    return
                end
                panelRole.armature:removeFromParent(true)
                panelRole.armature = nil
            end

            local armature = self:getArmature_ios(role.image, index);
            if (armature) then
                panelRole:setVisible(true)
                panelRole.armature = armature
                panelRole:addChild(armature, 1, index)
                self:AddRoleFootEffect(armature);
                lastLoadCount = nLocaIndex
                nLocaIndex = nLocaIndex + 1
            end
        else
            nLocaIndex = nLocaIndex + 1
        end
    end
    
    self.loadRoleTimer = TFDirector:addTimer(100, loacMax * 5, loadCompleteFun, 
    function(i) 
        loadRoleFun() 
    end)
end
function FengYunLuMainLayer:refreshBoss()
    self.loadTemp = false
    self:refreshLoadBoss()
    --奖励
    
    local list = FYRecordlineUoData:getInfoBystageandday(FengYunLuManager.ranktype,self.index)
    local droplist = DropGroupData:GetDropItemListByIdsStr(list.drop)
    local num = 1 
    for i =1 ,3 do 
        self.panel_reward[i]:setVisible(false)
    end
    if droplist:length() == 1 then
        num = 2 
    end
    for reward in droplist:iterator() do
        if num < 4 then
            if reward.type == EnumDropType.GOODS then
                local item = ItemData:objectByID(reward.itemid)
                if (item) then
                    local iconStr = item:GetPath()
                    self.panel_reward[num].img_tool1:setTexture(iconStr)
                    self.panel_reward[num]:setTextureNormal(GetColorIconByQuality(item.quality))
                    self.panel_reward[num].txt_num1:setText(reward.number)
                    self.panel_reward[num]:setVisible(true)
                    self.panel_reward[num].type = reward.type
                    self.panel_reward[num].itemId = reward.itemid
                end
            elseif reward.type == EnumDropType.FengYunLing then 
                self.panel_reward[num].img_tool1:setTexture("ui_new/fengyunlu/ui_fyl.png")
                self.panel_reward[num]:setTextureNormal(GetColorIconByQuality(4))
                self.panel_reward[num].txt_num1:setText(reward.number)
                self.panel_reward[num]:setVisible(true)
                self.panel_reward[num]:setTouchEnabled(true)
                self.panel_reward[num].type = reward.type
                self.panel_reward[num].itemId = reward.itemid
            end
            num = num + 1
        end
    end

end

function FengYunLuMainLayer:getArmature(image,i)

    local resPath = "armature/"..image..".xml"
    if not TFFileUtil:existFile(resPath) then
        image = 10006
        resPath = "armature/"..image..".xml"
    end

    local armature = TFArmature:create()
    armature.tag = self.index

    if TFArmatureDataManager:getInstance():getArmatureData(image.."_anim") then
        self:updataArmature(image,armature)
    else
        TFResourceHelper:instance():addArmatureFromFileAsync(resPath,function ()
            if armature.tag == self.index and self.updataArmature then
                self:updataArmature(image,armature)
            end
        end)
    end
    return armature
end
function FengYunLuMainLayer:updataArmature(image,armature)
    armature:setArmature(image.."_anim")
    armature:setScaleX(-1)
    armature:setPositionX(100)
    armature:setAnimationFps(GameConfig.ANIM_FPS)
    armature:playByIndex(0, -1, -1, 1)
   
    
end

function FengYunLuMainLayer:getArmature_ios(image, i)
   
	local resPathXML = "armature/"..image..".xml"
	local resPathAlats = "armature/".. image .. ".atlas" 
	local armature
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "armature/".. image
		armature = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		armature = TFArmature:create(image.."_anim")
	else
		image = 10006
		TFResourceHelper:instance():addArmatureFromJsonFile("armature/"..image..".xml")
		armature = TFArmature:create(image.."_anim")
	end
	
	if armature == nil then
		assert(false, "armature"..image.."create error")
		return
	end

    armature:setScaleX(-1)
    armature:setPositionX(100)
    armature:setAnimationFps(GameConfig.ANIM_FPS)
    armature:playByIndex(0, -1, -1, 1)
    armature.imageId = image
    return armature

end

function FengYunLuMainLayer.onGoClickHandle(sender)
    local self = sender.logic;

end

function FengYunLuMainLayer:removeUI()
    
    self.super.removeUI(self);
    
end

function FengYunLuMainLayer:registerEvents()
    self.super.registerEvents(self);
    
    if self.generalHead then
        self.generalHead:registerEvents()
    end
    for i = 1, 3 do
        self.guankabtn[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onClickHandle),1)
        self.guankabtnClose[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onClickHandle),1)
    end
    for i = 1,3 do 
         self.panel_reward[i].logic = self
        self.panel_reward[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onShowItemClickHandle),1)
    end
    self.btn_lszr:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onOpenLszr),1)
    self.btn_phjl:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onOpenPhjl),1)
    self.btn_fyb.logic    = self
    self.btn_fyb:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnfybList),1)
    self.btn_tz.logic    = self
    self.btn_tz:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnTiaoZhan),1)
    self.btn_fyg:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnBtnClickShangcheng),1)

   
    self.btn_help.logic    = self
    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRuleClick),1)

    self.refreshNumText = function(event)
        self.txt_num:setText(FengYunLuManager.challengeCount)             
    end
    TFDirector:addMEGlobalListener(FengYunLuManager.BUY_COUNT_ChallengeCount, self.refreshNumText)
    self.refreshAll = function(event)
    if FengYunLuManager.day ~= 0 then
        self.index = FengYunLuManager.day
    else
        self.index = 1
    end
        self:refreshUI()            
    end
    TFDirector:addMEGlobalListener(FengYunLuManager.OPEN_WIND_CLOUD_RECORD, self.refreshAll)

end
function FengYunLuMainLayer.onShowItemClickHandle(sender)
    -- local self = sender.logic;
    if sender.itemId == nil then
        Public:ShowItemTipLayer(nil, sender.type)
    else
        Public:ShowItemTipLayer(sender.itemId,sender.type)
    end
end
function FengYunLuMainLayer.onClickHandle(sender)
    local self = sender.logic 
    self.index =sender.index
    self:refreshUI()

end
function FengYunLuMainLayer.onOpenLszr()
    FengYunLuManager:OpenFengYunLuHistoryLayer()
end

function FengYunLuMainLayer.onOpenPhjl()
    FengYunLuManager:OpenFengYunLuRewardLayer()
end

function FengYunLuMainLayer.onBtnfybList( sender )
    local self = sender.logic 
    if (self.bLoadRole) then
        FengYunLuManager:sendRankingList(1,0,10)
        FengYunLuManager:OpenFengYunLuListLayer()
    else
        toastMessage(localizable.common_wait)
    end
end
function FengYunLuMainLayer.onBtnTiaoZhan( sender )
    local self = sender.logic;
    if (self.bLoadRole) then
        FengYunLuManager:OpenFengYunLuVSLayer()
        -- FengYunLuManager:OpenFengYunLuArmyLayer()
    else
        toastMessage(localizable.common_wait)
    end
    
end

function FengYunLuMainLayer.onRuleClick( sender )
    CommonManager:showRuleLyaer('fengyunlu')
end

function FengYunLuMainLayer:removeEvents()
    self.super.removeEvents(self);
    if self.generalHead then
        self.generalHead:removeEvents()
    end
    TFDirector:removeTimer(self.loadRoleTimer)
    self.loadRoleTimer = nil

    TFDirector:removeMEGlobalListener(FengYunLuManager.BUY_COUNT_ChallengeCount, self.refreshNumText)
    self.refreshNumText = nil
    TFDirector:removeMEGlobalListener(FengYunLuManager.OPEN_WIND_CLOUD_RECORD, self.refreshAll)
    self.refreshAll = nil
    
end

function FengYunLuMainLayer.OnBtnClickShangcheng()
    MallManager:openMallLayerByType(EnumMallType.FengYunLuMall,1)
end
function FengYunLuMainLayer:AddRoleFootEffect(roleArmature)
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role.xml")
    local effect = TFArmature:create("main_role_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        roleArmature:addChild(effect)
    end

    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role2.xml")
    local effect2 = TFArmature:create("main_role2_anim")
    if effect2 ~= nil then
        effect2:setAnimationFps(GameConfig.ANIM_FPS)
        effect2:playByIndex(0, -1, -1, 1)
        effect2:setZOrder(-1)
        effect2:setPosition(ccp(0, -10))
        roleArmature:addChild(effect2)
    end
end
function FengYunLuMainLayer:dispose()
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
    self.super.dispose(self)
end

return FengYunLuMainLayer;
