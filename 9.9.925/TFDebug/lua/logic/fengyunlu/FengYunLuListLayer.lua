local FengYunLuListLayer = class("FengYunLuListLayer", BaseLayer);

CREATE_SCENE_FUN(FengYunLuListLayer);
CREATE_PANEL_FUN(FengYunLuListLayer);

--[[
风云录排行榜
]]
local path  = {"ui_new/fengyunlu/tab_gk1.png","ui_new/fengyunlu/tab_gk2.png","ui_new/fengyunlu/tab_gk3.png","ui_new/fengyunlu/tab_gk4.png"}
local path1 = {"ui_new/fengyunlu/tab_gk1_h.png","ui_new/fengyunlu/tab_gk2_h.png","ui_new/fengyunlu/tab_gk3_h.png","ui_new/fengyunlu/tab_gk4_h.png"}
local path2 = {"ui_new/leaderboard/no1.png", "ui_new/leaderboard/no2.png", "ui_new/leaderboard/no3.png"}
local cell_add_num = 10
local cell_h = 100
function FengYunLuListLayer:ctor(data)
    self.super.ctor(self,data);
    
    self:init("lua.uiconfig_mango_new.fengyunlu.FengYunLuList");
end


function FengYunLuListLayer:onShow()
    self.super.onShow(self)
    self.generalHead:onShow();
    -- self:refreshUI();
end


function FengYunLuListLayer:initUI(ui)
    self.super.initUI(self,ui);
    self.generalHead = CommonManager:addGeneralHead(self)

    self.generalHead:setData(ModuleType.FengYunBang,{HeadResType.COIN,HeadResType.SYCEE})
    --关卡选择
    self.Panel_sv                  = TFDirector:getChildByPath(ui, "Panel_sv") 
    self.guankabtn                 = {}  
    for i =1,4 do
        local btn = TFDirector:getChildByPath(ui, "btn_gk"..i)
        btn.index = i
        btn.logic = self
        self.guankabtn[i] = btn
    end
    --左边
    self.bgLeft1        = TFDirector:getChildByPath(ui, "bgLeft1") 
    self.txtName        = TFDirector:getChildByPath(self.bgLeft1, "txtName") 
    self.txtlv          = TFDirector:getChildByPath(self.bgLeft1, "txtlv") 
    self.bg_touxiang    = TFDirector:getChildByPath(self.bgLeft1, "bg_touxiang") 
    self.img_head       = TFDirector:getChildByPath(self.bg_touxiang, "img_head")
    self.bg_name        = TFDirector:getChildByPath(self.bgLeft1, "bg_name")  
    

    self.role = {}
    for i =1 ,9 do 
        local panel_role    = TFDirector:getChildByPath(self.bgLeft1, "Panel_Role"..i) 
        self.role[i]        = panel_role
    end

    --右边
    self.bgRight            = TFDirector:getChildByPath(ui, "bgRight") 
    self.panel_list         = TFDirector:getChildByPath(self.bgRight, "panel_list") 
    self.img_empty          = TFDirector:getChildByPath(self.bgRight, "img_empty") 
    self.Txt                = TFDirector:getChildByPath(self.img_empty, "Txt") 
    self.img_empty:setVisible(false)
    self.paiming            =  TFDirector:getChildByPath(self.bgRight, "paiming") 
    self.txt_cscs_num       =  TFDirector:getChildByPath(self.bgRight, "txt_cscs_num")
    self.txt_cssj_time      =  TFDirector:getChildByPath(self.bgRight, "txt_cssj_time")
    self.index = 1
    self.panerlindex = 1

    self.bg = createUIByLuaNew("lua.uiconfig_mango_new.fengyunlu.FengYunLucell")
    self.bg:retain()
    self.bg:setVisible(false)
    self.bg:removeFromParent()

    --用于回到上次看到的位置
    self.cell_curr_max = 0
    --用于判断又没有切换排行榜
    self.isFalse = false
    --tableview
    self.tableViewType = {}

end

function FengYunLuListLayer:refreshUI()
    self.tableViewType = {}
    self.panerlindex = 1
    self:refreshStartLabel()
    self.RankList  = FengYunLuManager.RankList[self.index] or nil

    self:refreshTableView()
    self:refreshMyInfo()
    self:LeftRoleInfo()
end
function FengYunLuListLayer:refreshStartLabel()
    for i =1 ,4 do
        self.guankabtn[i]:setTextureNormal(path[i])
    end
    self.guankabtn[self.index]:setTextureNormal(path1[self.index])
end
function FengYunLuListLayer.onGoClickHandle(sender)
    local self = sender.logic;

end
function FengYunLuListLayer:LeftRoleInfo()
    for i = 1,9 do 
        self.role[i]:setVisible(false)
    end
    self.loadTemp = false
    if self.RankList and self.RankList.rankInfo and self.RankList.rankInfo[self.panerlindex] then
        local list = self.RankList.rankInfo[self.panerlindex]
        if list.formation then
            local base = string.split(list.formation,',')
            for v,k in pairs(base) do
                v = tonumber(v)
                k = tonumber(k)
                if v > 9 then
                    break
                end
                if k and k ~= 0 then
                    local role = FYRecordData:getRoleinfoByid(k)
                    if role then
                        local armature
                        -- IOS做特殊处理
                        if CC_TARGET_PLATFORM == CC_PLATFORM_IOS and GameConfig.HD then
                            armature = self:getArmature_ios(role.image);
                        else
                            armature = self:getArmature(role.image);
                        end
                        self.role[v]:setVisible(true)
                        if self.role[v].armature ~= nil then
                            self.role[v].armature:removeFromParent()
                            self.role[v].armature = nil
                        end
                        self.role[v].armature = armature
                        self.role[v]:addChild(armature,1)
                    end
                end
            end
            self.txtName:setVisible(true)
            self.txtlv:setVisible(true)
            self.bg_touxiang:setVisible(true)
            self.bg_name:setVisible(true)
            self.txtName:setText(self.RankList.rankInfo[self.panerlindex].playerName)
            self.txtlv:setVisible(false)--setText(self.RankList.rankInfo[self.panerlindex].level)
            local role_info = RoleData:objectByID(self.RankList.rankInfo[self.panerlindex].useIcon)
            if role_info then
                self.img_head:setTexture(role_info:getIconPath())
            end
        end
    else
        self.bg_name:setVisible(false)
        self.txtName:setVisible(false)
        self.txtlv:setVisible(false)
        self.bg_touxiang:setVisible(false)
    end
end

function FengYunLuListLayer:getArmature(image)

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
            if armature.tag == self.index  and self.updataArmature then
                self:updataArmature(image,armature)
            end
        end)
    end
    return armature
end
function FengYunLuListLayer:updataArmature(image,armature)
    armature:setArmature(image.."_anim")
    armature:setScaleX(0.95)
    -- armature:setPositionX(100)
    armature:setAnimationFps(GameConfig.ANIM_FPS)
    armature:playByIndex(0, -1, -1, 1)
    if (not self.loadTemp and not self.bLoadRole) then
        TFDirector:addTimer(1300, 1, nil, function ()
            self.bLoadRole = true
        end) 
    end
    self.loadTemp = true
end

function FengYunLuListLayer:getArmature_ios(image,i)

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

    armature:setScaleX(0.95)
    -- armature:setPositionX(100)
    armature:setAnimationFps(GameConfig.ANIM_FPS)
    armature:playByIndex(0, -1, -1, 1)
    return armature

end

function FengYunLuListLayer:refreshMyInfo() 
    if self.RankList and next(self.RankList) ~= nil and self.RankList.myRankInfo then
        if self.RankList.myRankInfo.myRanking and self.RankList.myRankInfo.myRanking ~= -1 then
            self.paiming:setText(self.RankList.myRankInfo.myRanking) 
        else
            self.paiming:setText(localizable.shalu_info_txt1)
        end         
        if self.RankList.myRankInfo.myAchievement and self.RankList.myRankInfo.myAchievement ~= -1 then
            self.txt_cscs_num:setText(self.RankList.myRankInfo.myAchievement)      
        else
            self.txt_cscs_num:setText(localizable.FengYunLu_tips2)
        end 
        if self.RankList.myRankInfo.challengeTime then
            self.txt_cssj_time:setText(strTime(self.RankList.myRankInfo.challengeTime)) 
        else
            self.txt_cssj_time:setText(localizable.FengYunLu_tips2)
        end

    else
        self.paiming:setText(localizable.shalu_info_txt1)
        self.paiming:setText(localizable.FengYunLu_tips2)
        self.txt_cssj_time:setText(localizable.FengYunLu_tips2)
    end
end

function FengYunLuListLayer:refreshTableView()
    if self.RankList and next(self.RankList) ~= nil and self.RankList.rankInfo then
        if #self.RankList.rankInfo == 0 then
            self.img_empty:setVisible(true)
            self.Txt:setText(localizable.common_wait)
        else
            self.img_empty:setVisible(false)
        end
    else
        self.img_empty:setVisible(true)
        self.Txt:setText(localizable.common_wait)
    end
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

    self.RecordList:addMEListener(TFTABLEVIEW_SIZEFORINDEX, FengYunLuListLayer.cellSizeForTable)
    self.RecordList:addMEListener(TFTABLEVIEW_SIZEATINDEX, FengYunLuListLayer.tableCellAtIndex)
    self.RecordList:addMEListener(TFTABLEVIEW_NUMOFCELLSINTABLEVIEW, FengYunLuListLayer.numberOfCellsInTableView)
    self.panel_list:addChild(self.RecordList)
    self.RecordList:reloadData()
end
function FengYunLuListLayer.cellSizeForTable(table,idx)
    return 100,754
end
function FengYunLuListLayer.numberOfCellsInTableView(table,idx)
    local self = table.logic
    if self.RankList and next(self.RankList) ~= nil and self.RankList.rankInfo then
        local Remainder = #self.RankList.rankInfo %10
        if Remainder == 0 and FengYunLuManager.ListType == true then
            return #self.RankList.rankInfo + 1 or 0
        else
            return #self.RankList.rankInfo or 0
        end
    else
        return 0
    end
    
end

function FengYunLuListLayer.tableCellAtIndex(table, idx)
    local self = table.logic
    local cell = table:dequeueCell()
    if cell == nil then
        cell = TFTableViewCell:create()
        local panel = self.bg:clone()
        panel:setVisible(true)
        cell.panel = panel
        cell:addChild(panel)
    end
    cell.panel:setPosition(ccp(0,0))
    self:setCellData(cell.panel,idx + 1)
    return cell
end

function FengYunLuListLayer:setCellData(panel,index)
    local bg_select = TFDirector:getChildByPath(panel, "bg_select") 
    local Img_paiming = TFDirector:getChildByPath(panel, "Img_paiming") 
    local txt_paiming = TFDirector:getChildByPath(panel, "txt_paiming")
    local txt_name = TFDirector:getChildByPath(panel, "txt_name") 
    local txt_cscs = TFDirector:getChildByPath(panel, "txt_cscs") 
    local txt_cssj = TFDirector:getChildByPath(panel, "txt_cssj") 
    local txt_cscs_word = TFDirector:getChildByPath(panel, "txt_cscs_word")
    local txt_cssj_word = TFDirector:getChildByPath(panel, "txt_cssj_word")
    local txt_cbgk = TFDirector:getChildByPath(panel, "txt_cbgk")
    local txt_cbgk = TFDirector:getChildByPath(panel, "txt_cbgk")
    local txt_cbgk_word = TFDirector:getChildByPath(panel, "txt_cbgk_word")
    local Btn_huifang = TFDirector:getChildByPath(panel, "Btn_huifang")

    txt_cssj:setText(localizable.UILayer_tips_44)
    txt_cscs:setText(localizable.UILayer_tips_43)
    txt_cbgk:setText(localizable.UILayer_tips_45)
    if index > #self.RankList.rankInfo then
        Img_paiming:setVisible(false)
        txt_paiming:setVisible(true)
        bg_select:setVisible(false)
        txt_name:setVisible(false)
        txt_cscs_word:setVisible(false)
        txt_cssj_word:setVisible(false)
        Btn_huifang:setVisible(false)
        txt_cscs:setVisible(false)
        txt_cssj:setVisible(false)
        panel:setTouchEnabled(true)
        txt_paiming:setText(localizable.FengYunLu_tips6)
        txt_paiming:setPositionX(-20)
        panel:addMEListener(TFWIDGET_CLICK,audioClickfun(function() 
            self.cell_curr_max = #self.RankList.rankInfo
            self:UpdateList() 
        end))
        return
    end
    if self.panerlindex  == index then
        bg_select:setVisible(true)
    else
        bg_select:setVisible(false)
    end

    if index <= 3 then
        Img_paiming:setVisible(true)
        Img_paiming:setTexture(path2[index])
        txt_paiming:setVisible(false)
    else
        Img_paiming:setVisible(false)
        txt_paiming:setVisible(true)
        txt_paiming:setText(index)
    end

    txt_name:setText(self.RankList.rankInfo[index].playerName)
    txt_cscs_word:setText(self.RankList.rankInfo[index].achievement)
    txt_cssj_word:setText(strTime(self.RankList.rankInfo[index].challengeTime))
    txt_paiming:setPositionX(-202)
    txt_cscs:setVisible(true)
    txt_cssj:setVisible(true)
    txt_name:setVisible(true)
    txt_cscs_word:setVisible(true)
    txt_cssj_word:setVisible(true)
    if self.RankList.rankInfo[index].joinRanks then
        txt_cbgk:setVisible(true)
        txt_cbgk_word:setVisible(true)
        txt_cbgk_word:setText(self.RankList.rankInfo[index].joinRanks)
    else
        txt_cbgk:setVisible(false)
        txt_cbgk_word:setVisible(false)
    end
    if self.RankList.rankInfo[index].replayId then
        Btn_huifang:setVisible(true)
        Btn_huifang:setTouchEnabled(true)
        Btn_huifang:addMEListener(TFWIDGET_CLICK,audioClickfun(function() 
            if (not self.bLoadRole) then
                toastMessage(localizable.common_wait)
                return
            end
            FengYunLuManager:sendRePlay(self.RankList.rankInfo[index].replayId)
        end))
    else
        Btn_huifang:setVisible(false)
        Btn_huifang:setTouchEnabled(false)
    end
    self.tableViewType[index] = bg_select
    panel.index = index
    panel:setTouchEnabled(true)
    panel:addMEListener(TFWIDGET_CLICK,audioClickfun(function() 
        self.panerlindex = panel.index
        for i = 1,#self.tableViewType do 
            self.tableViewType[i]:setVisible(false)
        end
        bg_select:setVisible(true)
        self:LeftRoleInfo()
    end))

end
function FengYunLuListLayer:removeUI()
    self.super.removeUI(self);
    
end

function FengYunLuListLayer:registerEvents()
    self.super.registerEvents(self);

    if self.generalHead then
        self.generalHead:registerEvents()
    end
    for i = 1, 4 do
        self.guankabtn[i]:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onClickHandle),1)
    end
    -- self.btn_lszr:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnAttackClickHandle),1)
    -- self.btn_phjl:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnbutStrengthClickHandle),1)
    -- self.btn_fyb:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnHelp),1)
    -- self.btn_tz:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnHelp),1)

    self.refreshlist = function(event)
        if self.isFalse == false then
            self:refreshUI()
        else
            self.RankList  = FengYunLuManager.RankList[self.index] or nil
            self.RecordList:reloadData()
            local numDx = cell_h * ( #self.RankList.rankInfo - self.cell_curr_max )
            self.RecordList:reloadData()
            self.RecordList:setContentOffset(ccp(0,-numDx))
        end
    end

    TFDirector:addMEGlobalListener(FengYunLuManager.SEND_RANKING_LIST, self.refreshlist)

end

function FengYunLuListLayer.onClickHandle(sender)
    local self = sender.logic
    self.index = sender.index
    if FengYunLuManager.RankList[self.index] == nil or next(FengYunLuManager.RankList[self.index]) == nil then
        FengYunLuManager:sendRankingList(sender.index,0,10)
    else
        self:refreshUI()
    end
    self.isFalse = false
end
function FengYunLuListLayer:UpdateList()
    self.isFalse = true
    FengYunLuManager:sendRankingList(self.index,self.cell_curr_max,cell_add_num)
end
function FengYunLuListLayer:removeEvents()
    self.super.removeEvents(self);
    if self.generalHead then
        self.generalHead:removeEvents()
    end
    TFDirector:removeMEGlobalListener(FengYunLuManager.SEND_RANKING_LIST, self.refreshlist)
    self.refreshlist = nil
    FengYunLuManager:deleteRankList()

    
end
function FengYunLuListLayer:dispose()
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end
    self.super.dispose(self)
end
function strTime(time)
    local data = os.date("*t",time/1000)
    local str = ""
    if data.hour < 10 then
        str = str.."0"..data.hour..":"
    else
        str = str..data.hour..":"
    end
    if data.min < 10 then
        str = str.."0"..data.min..":"
    else
        str = str..data.min..":"
    end
    if data.sec < 10 then
        str = str.."0"..data.sec
    else
        str = str..data.sec
    end 
    return str
end 
return FengYunLuListLayer;
