--[[
******PVE推图-关卡*******

    -- by haidong.gan
    -- 2013/11/27
]]
local MissionLayer = class("MissionLayer", BaseLayer);

CREATE_SCENE_FUN(MissionLayer);
CREATE_PANEL_FUN(MissionLayer);

MissionLayer.LIST_ITEM_WIDTH = 200;

function MissionLayer:ctor()
    self.super.ctor(self);
    self:init("lua.uiconfig_mango_new.mission.MissionLayer");
    self.showAttackTipMissionId = nil; 
end

function MissionLayer:loadData(missionId,difficulty)
    self.missionId = missionId;
    self.difficulty = difficulty;
    
    if self.missionId then
        local toMission = MissionManager:getMissionById(self.missionId);
        self.selectDifficulty = toMission.difficulty;
        local map = MissionManager:getMapById(toMission.difficulty,toMission.mapid);
        self.selectIndex = MissionManager:getMapList(self.selectDifficulty):indexOf(map);
    else

        self.selectDifficulty = self.difficulty;

        local map = MissionManager:getCurrentMap(self.selectDifficulty);
        self.selectIndex = nil;
        if map then
            self.selectIndex = MissionManager:getMapList(difficulty):indexOf(map);
        else
            self.selectIndex = MissionManager:getMapList(difficulty):length();
        end

        if self.selectDifficulty ~= MissionManager.DIFFICULTY0 and map and self.selectIndex == MissionManager:getMapList(difficulty):indexOf(map) then
            self.selectIndex = math.max( self.selectIndex - 1,1);
        end
    end
    self:refreshMissionList(self.selectIndex);

    self.groupButtonManager:selectIndex(self.selectDifficulty);
    -- local img_select = TFImage:create("ui_new/mission/gk_duihao.png");
    -- -- self.groupButtonManager:getSelectButton():removeChildByTag(10086,true);
    -- self.groupButtonManager:getSelectButton().highlight:setVisible(false)

    -- add by king, 修改了缓存关卡之后 宗师和普通切换的问题
    self.groupButtonManager.btnDic[1].highlight:setVisible(false);
    self.groupButtonManager.btnDic[2].highlight:setVisible(false);
    -- end

    -- img_select:setTag(10086);
    -- img_select:setPosition(ccp(50,0))
    self.groupButtonManager:getSelectButton().highlight:setVisible(true)

    -- 隐藏宗师管卡
    local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2001)
    if teamLev < openLev then
        self.btn_sort_level1:setVisible(false)
    else
        self.btn_sort_level1:setVisible(true)
    end
end

function MissionLayer:initUI(ui)
    self.super.initUI(self,ui);

    self.addMapTimer = {}
    self.addMissionTimer = {}

    self.penel_block     = TFDirector:getChildByPath(ui, 'penel_block')
    self.panel_head      = TFDirector:getChildByPath(ui, 'panel_head');
    self.generalHead = CommonManager:addGeneralHead( self )
    self.generalHead:setData(ModuleType.None,{HeadResType.COIN,HeadResType.SYCEE,HeadResType.PUSH_MAP}, true)

    self.panel_list         = TFDirector:getChildByPath(ui, 'panel_list')

    self.btn_onekey = TFDirector:getChildByPath(ui, 'btn_onekey')

    -- self.txt_pagenum       = TFDirector:getChildByPath(ui, 'txt_pagenum')
    -- self.txt_star           = TFDirector:getChildByPath(ui, 'txt_starpoint')
    self.txt_name           = TFDirector:getChildByPath(ui, 'txt_chapter')

    self.btn_left           = TFDirector:getChildByPath(ui, 'btn_pageleft')
    self.btn_right          = TFDirector:getChildByPath(ui, 'btn_pageright')
    self.positiony          = self.btn_right:getPosition().y;

    --self.btn_reward         = TFDirector:getChildByPath(ui, 'img_box')
    self.panelBoxView       = TFDirector:getChildByPath(ui, 'panelBoxView')
    self.mapBoxView = require("lua.logic.mission.MissionStarBox"):new()

    self.panel_2            = TFDirector:getChildByPath(ui, 'panel_2')
    self.panel_2:setVisible(false);
    self.panel_2:setZOrder(10086);

    self.panelBoxView:addChild(self.mapBoxView)

    local pageView = TPageView:create()
    self.pageView = pageView

    pageView:setBounceEnabled(false)
    pageView:setTouchEnabled(true)
    pageView:setBackGroundColorType(TF_LAYOUT_COLOR_NONE)
    pageView:setSize(self.panel_list:getContentSize())
    pageView:setPosition(self.panel_list:getPosition())
    pageView:setAnchorPoint(self.panel_list:getAnchorPoint())

    local function onPageChange()
        self:onPageChange();
    end
    pageView:setChangeFunc(onPageChange)

    local function itemAdd(index)
        return  self:addPage(index);
    end
    pageView:setAddFunc(itemAdd)

    self.panel_list:addChild(pageView,2);
  -- self.btn_sort            = TFDirector:getChildByPath(ui, 'btn_xiala');
    self.btn_sort_level0     = TFDirector:getChildByPath(ui, 'btn_putong');
    self.btn_sort_level0.highlight     = TFDirector:getChildByPath(ui, 'Img_putong2');
    self.btn_sort_level0.difficulty = MissionManager.DIFFICULTY0;
    self.btn_sort_level0.highlight:setVisible(false)
    
    -- self.btn_sort_level1     = TFDirector:getChildByPath(ui, 'btn_gaoshou');
    self.btn_sort_level1     = TFDirector:getChildByPath(ui, 'btn_zongshi');
    self.btn_sort_level1.highlight     = TFDirector:getChildByPath(ui, 'Img_zongshi2');
    self.btn_sort_level1.difficulty = MissionManager.DIFFICULTY1
    self.btn_sort_level1.highlight:setVisible(false)
    -- self.img_select          = TFDirector:getChildByPath(ui, 'img_select');

    self.btn_sortArr = {}
    self.btn_sortArr[MissionManager.DIFFICULTY0] = self.btn_sort_level0;
    self.btn_sortArr[MissionManager.DIFFICULTY1] = self.btn_sort_level1;

    -- self.bg_sort             = TFDirector:getChildByPath(ui, 'panel_bg');
    -- self.bg_sort:setSwallowTouch(false);
    -- self.node_menu           = TFDirector:getChildByPath(ui, 'panel_menu');
    self.groupButtonManager  = GroupButtonManager:new( {[1] = self.btn_sort_level0, [2] = self.btn_sort_level1});


    -- self.img_select:setTexture("ui_new/mission/gk_putong_icon.png");

    -- self.node_menu:setVisible(false);
    -- self.btn_sort:setVisible(true);
    self:setGuideBlockViisble(true,false)

        --公告框
    local function update(delta)
        self:setGuideBlockViisble(false,false)
    end
    local timeId = TFDirector:addTimer(100, 1, nil, update)
    -- self.Common_locked  = createUIByLuaNew("lua.uiconfig_mango_new.mission.Common_locked")
    -- self.Boss_locked    = createUIByLuaNew("lua.uiconfig_mango_new.mission.Boss_locked")
    self.Boss_locked  = TFDirector:getChildByPath(ui, "panel_boss")
    self.Boss_locked:setVisible(false)
    self.Common_locked  = TFDirector:getChildByPath(ui, "panel_comm")
    self.Common_locked:setVisible(false)

    self.pageMapNode = nil

    -- self.Common_locked:retain()
    -- self.Boss_locked:retain()

    self.btn_jingyan = TFDirector:getChildByPath(ui, 'btn_jingyan')
    self.btn_jingyan:setVisible(true)
    self.posX_jingyan = self.btn_jingyan:getPositionX()

    self.panel_stronger = TFDirector:getChildByPath(ui, 'panel_stronger')
    self.panel_stronger:setVisible(false)


    self:addStrongerEffect(self.panel_stronger)

    -- local acArr = TFVector:create()
    -- local delayAc = CCDelayTime:create(0.4)
    -- acArr:addObject(delayAc)
    -- local scaleAc = CCScaleTo:create(0.1,1.3)
    -- acArr:addObject(scaleAc)
    -- scaleAc = CCScaleTo:create(0.1,1)
    -- acArr:addObject(scaleAc)
   
    -- local seq = CCSequence:create(acArr)
    -- self.btn_canStronger:runAction(CCRepeatForever:create(seq))
end

function MissionLayer:addStrongerEffect(panel)
    local effectName = "mission_stronger"
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/" .. effectName .. ".xml")
    local effect = TFArmature:create(effectName .. "_anim")
    if effect ~= nil then
        effect:setAnimationFps(GameConfig.ANIM_FPS)
        effect:playByIndex(0, -1, -1, 1)
        local size = panel:getSize()
        effect:setPosition( ccp(size.width / 2, size.height / 2) )
        panel:addChild(effect)
        panel:setTouchEnabled(true)
        panel:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onStrongerClickHandle),1);
    end
end

function MissionLayer:setGuideBlockViisble(isVisible,force)
    if force == nil then
        force = true
    end


    if force == false and self.force == true then
        return
    end
    if isVisible == true and force == true then
        self.force = true
    else
        self.force = false
    end


    self.penel_block:setVisible(isVisible);
    if self.pageView.setScrollEnabled then
        self.pageView:setScrollEnabled(not isVisible);
    end
    if isVisible then
        self.btn_left:setColor(ccc3(166, 166, 166));
        self.btn_right:setColor(ccc3(166, 166, 166));
        -- self.btn_sort:setColor(ccc3(166, 166, 166));
        -- self.img_select:setColor(ccc3(166, 166, 166));
    else
        self.btn_left:setColor(ccc3(255, 255, 255));
        self.btn_right:setColor(ccc3(255, 255, 255));
        -- self.btn_sort:setColor(ccc3(255, 255, 255));
        -- self.img_select:setColor(ccc3(255, 255, 255));
    end
    -- if isVisible then
    --     local guidePanel = TFPanel:create()
    --     guidePanel:setSize(self.panel_head:getSize())
    --     guidePanel:setPosition(self.panel_head:getPosition())

    --     guidePanel:setBackGroundColorType(TF_LAYOUT_COLOR_SOLID)
    --     guidePanel:setBackGroundColorOpacity(0)
    --     guidePanel:setBackGroundColor(ccc3(0,0,0))
    --     guidePanel:setZOrder(100)
    --     guidePanel:setTouchEnabled(true)
    --     self:addChild(guidePanel)
    --     self.guidePanel = guidePanel
    -- else
    --     if not tolua.isnull(self.guidePanel) then
    --         self.guidePanel:removeFromParent()
    --         self.guidePanel = nil
    --     end
    -- end
end

function MissionLayer:removeUI()
    print("---------MissionLayer:removeUI()--------------------")
    self.super.removeUI(self)

    -- if self.Common_locked then
    --     self.Common_locked:release()
    --     self.Common_locked = nil
    -- end
    -- if self.Boss_locked then
    --     self.Boss_locked:release()
    --     self.Boss_locked = nil
    -- end
    

    if self.pageMapNode then
        self.pageMapNode:release()
        self.pageMapNode = nil
    end
end

function MissionLayer:dispose()
    if self.generalHead then
        self.generalHead:dispose()
        self.generalHead = nil
    end

    self.super.dispose(self)
end

function MissionLayer:onShow()
    self.super.onShow(self)
    if self.generalHead then
        self.generalHead:onShow();
    end
    -- self:refreshBaseUI();
    self:refreshUI();
    -- 隐藏宗师管卡
    local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2001)
    if teamLev < openLev then
        self.btn_sort_level1:setVisible(false)
    else
        self.btn_sort_level1:setVisible(true)
    end
    if MissionManager:isInTrustOnekey() == false then
        self:knightShow()
    end
    -- if self.isFirstIn then
    -- end
    -- ----------------------------------------
    -- local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionSkipLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);        
    --         layer:loadData(1,1)
    --         AlertManager:show();  
end

function MissionLayer:refreshReward(mapId)
	-- self.panel_2
    self.panel_2:setVisible(false);
    local k,missionId,showFlag,mapIdChangeId,mapIdChangeMaxId
    
    if mapId < 1000 then 
        mapIdChangeId = (mapId - 1) * 10 + 1;
        missionId = MissionManager:getSpecialDropStarNextMissionId(1,mapIdChangeId)
        mapIdChangeMaxId = mapId * 10
    else 
        mapIdChangeId = (mapId - 1001) * 3 + 1001;
        missionId = MissionManager:getSpecialDropStarNextMissionId(2,mapIdChangeId)
        mapIdChangeMaxId = (mapId - 1000) * 3 + 1000
    end
    if missionId then
        if mapIdChangeMaxId < missionId then
            showFlag = 1;
        end
    end
	if showFlag then
		self.panel_2:setVisible(true);
		local specialDropBase = MissionManager:getSpecialDropItemByMissionId(missionId)
		if specialDropBase then 
    		local specialDrop = BaseDataManager:getReward({itemId = tonumber(specialDropBase[2]),type = tonumber(specialDropBase[1]),number = tonumber(specialDropBase[3])})
			local img_bg  = TFDirector:getChildByPath(self.panel_2, 'img_bg');
    		local txt_1   = TFDirector:getChildByPath(self.panel_2, 'txt_1');
    		local btn_icon  = TFDirector:getChildByPath(self.panel_2, 'btn_icon');
            btn_icon:setTextureNormal(GetColorIconByQuality(specialDrop.quality));
            local mission =	MissionManager:getMissionById(missionId);
			local mapid = mission.mapid;
			local getReward = localizable.getRewardWordDifficulty0;
			if mapid > 1000 then
				mapid = mapid - 1000;
				getReward = localizable.getRewardWordDifficulty1;
			end
			txt_1:setText(stringUtils.format(getReward, mapid, mission.stageid));
    		local img_icon  = TFDirector:getChildByPath(self.panel_2, 'img_icon');
            local txt_num1  = TFDirector:getChildByPath(self.panel_2, 'txt_num1');
			local txt_num2  = TFDirector:getChildByPath(self.panel_2, 'txt_num2');
			txt_num1:setVisible(false);
			txt_num2:setText(specialDrop.number);
    		img_icon:setTexture(specialDrop.path);
			-- btn_icon:addMEListener(TFWIDGET_CLICK,audioClickfun(function() Public:ShowItemTipLayer(specialDrop.itemid, specialDrop.type);end));
    		btn_icon.self = self;
    		btn_icon:addMEListener(TFWIDGET_CLICK,audioClickfun(function() 
			local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionLayer");
    			layer:loadData(missionId,1);
    			AlertManager:show();
			end));
        else    
            self.panel_2:setVisible(false);
		end
	end
end

function MissionLayer:refreshBaseUI()

end

function MissionLayer:refreshUI()
    if not self.isShow then
        return;
    end
    self.panel_stronger:setVisible(CardRoleManager:isHaveBook())
    if MainPlayer.multipleOutputList[1] and MainPlayer.multipleOutputList[1].endTime >= MainPlayer:getNowtime() then
        self.btn_jingyan:setVisible(true)
        if self.panel_stronger:isVisible() == true then
            self.btn_jingyan:setPositionX(self.posX_jingyan)
        else
            local posX = self.panel_stronger:getPositionX()
            self.btn_jingyan:setPositionX(posX)
        end
    else
        self.btn_jingyan:setVisible(false)
    end
end
function MissionLayer:showInfoForPage(pageIndex)
    -- self.txt_pagenum:setText(pageIndex.. "/" .. MissionManager:getMapList():length())
    local map = MissionManager:getMapList(self.selectDifficulty):objectAt(pageIndex);
    self.mapBoxView.mapid = map.id
    self.mapBoxView:loadData(map.id,self.selectDifficulty)

    self.txt_name:setText(map.name);

    local curStar = MissionManager:getStarlevelCount(map.id,self.selectDifficulty);
    local maxStar = MissionManager:getMaxStarlevelCount(map.id,self.selectDifficulty);

    local mapBox = MissionManager:getBoxByMapIdAndDifficulty(map.id,self.selectDifficulty);
    
    self:refreshReward(map.id)


    -->>>>>>>>>>>>>>>>> quanhuan close 2015-9-24 13:30:11
    -- self.btn_reward:removeChildByTag(10086,true);
    -- if mapBox then
    --     if mapBox.isAlreadyOpen then
    --         self.btn_reward:setTextureNormal("ui_new/mission/gk_pass1.png");
    --         self.btn_reward:setShaderProgram("GrayShader", true)
    --     else
    --         self.btn_reward:setTextureNormal("ui_new/mission/gk_pass.png");
    --         -- self.txt_star:setText(curStar .. "/" .. maxStar);
    --         if (curStar == maxStar and mapBox and maxStar >= mapBox.need_star ) then
    --             self.btn_reward:setTouchEnabled(true);
    --             self.btn_reward:setShaderProgramDefault(true);

    --             local resPath = "effect/ui_mission_get_reward.xml"
    --             TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    --             local effect = TFArmature:create("ui_mission_get_reward_anim")

    --             effect:setAnimationFps(GameConfig.ANIM_FPS)

    --             -- effect:setPosition(ccp(0,-self.btn_reward:getSize().height/2))
    --             effect:setPosition(ccp(0, 0))
    --             self.btn_reward:addChild(effect,100)

    --             effect:addMEListener(TFARMATURE_COMPLETE,function()

    --             end)
    --             effect:playByIndex(0, -1, -1, 1)
    --             effect:setTag(10086);
    --         else
    --             self.btn_reward:setShaderProgram("GrayShader", true)
    --             self.btn_reward:setTouchEnabled(false);
    --         end
    --     end

    --     self.btn_reward:setVisible(true);
    -- else
    --     self.btn_reward:setVisible(false);
    -- end
    --<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



    local pageCount = MissionManager:getMapList(self.selectDifficulty):length();

    self.btn_left:setPosition(ccp(self.btn_left:getPosition().x,1000));
    self.btn_right:setPosition(ccp(self.btn_right:getPosition().x,1000));

    if pageIndex < pageCount and pageCount > 1 then
        self.btn_right:setPosition(ccp(self.btn_right:getPosition().x,self.positiony));
    end

    if pageIndex > 1 and pageCount > 1  then
        self.btn_left:setPosition(ccp(self.btn_left:getPosition().x,self.positiony));
    end
end

function MissionLayer:onPageChange()
    local pageIndex = self.pageView:_getCurPageIndex() ;
    self:showInfoForPage(pageIndex);
end

function MissionLayer:refreshMissionList(pageIndex)
    self.pageView:_removeAllPages();

    self.pageView:setMaxLength(MissionManager:getMapList(self.selectDifficulty):length())

    self.missionNodeList = {};
    self.pageList        = {};


    self:showInfoForPage(pageIndex);
    local mission = MissionManager:getCurrentMission(self.selectDifficulty);
    print("mission = ", mission)
    self.pageView:InitIndex(pageIndex);
end


function MissionLayer:addPage(pageIndex)
    local pagepanel = TFPanel:create();
    local map = MissionManager:getMapList(self.selectDifficulty):objectAt(pageIndex);
    local missionlist = MissionManager:getMissionListByMapId(map.id);
    local curMissionlist = missionlist[self.selectDifficulty];
    local page = nil;

    local function addMap()
        if self.pageMapNode == nil then
            page = createUIByLuaNew("lua.uiconfig_mango_new.mission.MapItem");
            self.pageMapNode = page
            self.pageMapNode:retain()
        end

        page = self.pageMapNode:clone()

        page:setSize(self.panel_list:getContentSize())
        page:setName("page")
        pagepanel:addChild(page);


        local img_map = TFDirector:getChildByPath(page, 'img_map');
        img_map:setTexture("bg_jpg/" .. map.map_img .. ".jpg");

        local battlePoint = TFImage:create("bg_jpg/battlepoint/" .. map.point_imp .. ".png")
        if battlePoint then
            battlePoint:setAnchorPoint(CCPointMake(0.5,0.5))
            battlePoint:setPosition(CCPointMake(0,0))
            img_map:addChild(battlePoint)
        end
        
        local contentSize = self.panel_list:getContentSize()

        img_map:setPosition(ccp(contentSize.width/2,contentSize.height/2))

        -- print("getAnchorPoint = ",img_map:getAnchorPoint())
        -- print("getSize = ",img_map:getSize())
        -- print("getContentSize = ",img_map:getContentSize())
        -- print("getPosition = ",img_map:getPosition())
        -- print("page==================")
        -- print("page = ",page:getPosition())

    end

    if self.addMapTimer[pageIndex] then
        TFDirector:removeTimer(self.addMapTimer[pageIndex])
        self.addMapTimer[pageIndex] = nil
    end
    if self.addMissionTimer[pageIndex] then
        TFDirector:removeTimer(self.addMissionTimer[pageIndex])
        self.addMissionTimer[pageIndex] = nil
    end
    if pageIndex ~= self.selectIndex then

        local index = 1;
        local function onOnceCom()
            if index == 1 then

            else
                local mission = curMissionlist:objectAt(index - 1);
                self:addMissionNode(page,mission);
            end
            index = index + 1;
        end

        self.addMapTimer[pageIndex] = TFDirector:addTimer(0.5, 1, function ()
            local length = curMissionlist:length();
            self.addMissionTimer[pageIndex] = TFDirector:addTimer(0.1, length + 1, nil, onOnceCom);
        end, addMap);

    else
        self.addMapTimer[pageIndex] = TFDirector:addTimer(0, 1, function ()
            for mission in curMissionlist:iterator()  do
                self:addMissionNode(page,mission);
            end   
        end, addMap);

        -- addMap();
        -- -- local function onCom()
        --     --添加关卡
        --     for mission in curMissionlist:iterator()  do
        --         self:addMissionNode(page,mission.id);
        --     end
        -- -- end

        -- TFDirector:addTimer(0.0001, 1, onCom, nil);
    end
    self.pageList[map.id] = pagepanel;
    return pagepanel;
end

function MissionLayer:getMissionIdBool(difficulty,missionId)
    local k = difficulty;
    for i = 2,3 do
		local starList = MissionManager:getSpecialDropStarMissionList(k,i);
		if not starList then 
			for star in starList:iterator() do
                if missionId == star.id then 
		            local starMission =	MissionManager:getMissionById(star.id);
				    if starMission.starLevel < i then
					    return true;
				    end
                end
			end
		end
	end
    return false;
end
--添加关卡节点
function MissionLayer:addMissionNode(page,mission)
    local missionId = mission.id
    local missionlist = MissionManager:getMissionListByMapId(mission.mapid);

    local nextMission = MissionManager:getNextMissionById(mission.mapid,mission.difficulty,mission.id);
    local attackingMission = MissionManager:getCurrentMissionInMapByDifficulty(mission.mapid,mission.difficulty);


    local curMissionlist = missionlist[mission.difficulty];
    local index = curMissionlist:indexOf(mission);
    -- if mission.difficulty == 2 then
    --     print("mission = ",mission)
    --     p.p = 1
    -- end
    local posList = MissionManager:gePosListByMapId(mission.mapid);
    local img_map = TFDirector:getChildByPath(page, 'img_map');

    local posItem = posList:objectAt(index);
    local roadImg = nil;
    if not posItem then
        print("找不到位置信息 第 " .. mission.mapid  .. "章节，难度：" .. mission.difficulty .. "，第" .. index .. "关卡")
        return;
    end
    if posItem.road_img ~= "" then
        roadImg = TFImage:create("ui_new/mission/" .. posItem.road_img .. ".png");
        if not roadImg then
            print("找不到图片：" .. "ui_new/mission/" .. posItem.road_img .. ".png")
            return;
        end
        roadImg:setPosition(ccp(posItem.roadPosX - 480 , posItem.roadPosY - 320));
        img_map:addChild(roadImg);
    end


    local status = MissionManager:getMissionPassStatus(missionId);

    -- MissionManager.STATUS_PASS  = 1;--已通过
    -- MissionManager.STATUS_CUR   = 2;--当前
    -- MissionManager.STATUS_CLOSE = 3;--未开放

    local mission_node = nil;
    if mission.type == MissionManager.TYPE_COMMON then
        mission_node = self.Common_locked:clone()
    else
        mission_node = self.Boss_locked:clone()
    end
    mission_node:setVisible(true)
    local img_chain = TFDirector:getChildByPath(mission_node, "img_chain")
    local panel_star = TFDirector:getChildByPath(mission_node, "panel_star")
    if status == MissionManager.STATUS_PASS then
        --已通关
        -- img_map:addChild(mission_node)
        panel_star:setVisible(true)
        img_chain:setVisible(false)
        mission_node:setGrayEnabled(false)
    elseif status == MissionManager.STATUS_CUR then
        --增加等级限制添加，by wk.dai
        panel_star:setVisible(false)
        img_chain:setVisible(false)
        if mission.reqiure_level > MainPlayer:getLevel() then
            mission_node:setGrayEnabled(true)
        end
        -- img_map:addChild(mission_node,10)
    end
    if status == MissionManager.STATUS_CLOSE or status == MissionManager.STATUS_NEED_DIFFICULTY0 then
        --未开放
        panel_star:setVisible(false)
        img_chain:setVisible(true)
        -- img_map:addChild(mission_node)
    end
    if mission.type == MissionManager.TYPE_COMMON then
        img_map:addChild(mission_node)
    else
        img_map:addChild(mission_node,10086)
    end

    

     --处理按钮事件
    local btn_attack = TFDirector:getChildByPath(mission_node, 'btn_base');
    btn_attack.logic = self;
    btn_attack:setTag(mission.id);
    btn_attack:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onBtnAttackClickHandle));
    btn_attack:addMEListener(TFWIDGET_TOUCHENDED, self.onBtnAttackTouchEndedHandle);
    

    mission_node.panel_1 = TFDirector:getChildByPath(mission_node, 'panel_1');
    if mission_node.panel_1 then
        mission_node.panel_1:setZOrder(10086);
        local missionId = mission.id;
        local currentMission,showFlag,missionIdBool,difficulty
        if missionId < 1000 then 
            difficulty = MissionManager.DIFFICULTY0;
        else 
            difficulty = MissionManager.DIFFICULTY1;     
        end
        missionIdBool = MissionManager:getSpecialDropListBool(difficulty,missionId);
        -- print("this is missionIdBool,missionId--------",missionIdBool,missionId);
        if missionIdBool then
            showFlag = 1;
        else
            currentMission = MissionManager:getCurrentMission(difficulty);
            local starBool = self.getMissionIdBool(difficulty,missionId);
            if starBool or currentMission.id < missionId then 
		        showFlag = 1;
	        end
        end
        if showFlag then
            local specialDropBase = MissionManager:getSpecialDropItemByMissionId(missionId)
            if specialDropBase then
                -- local specialDrop = BaseDataManager:getSpecialReward({itemId = specialDropBase[2],type = specialDropBase[1],number = specialDropBase[3]})
                local specialDrop = BaseDataManager:getReward({itemId = tonumber(specialDropBase[2]),type = tonumber(specialDropBase[1]),number = tonumber(specialDropBase[3])})
            
                mission_node.panel_1.img_bg  = TFDirector:getChildByPath(mission_node.panel_1, 'img_bg');
                mission_node.panel_1.txt_1   = TFDirector:getChildByPath(mission_node.panel_1, 'txt_1');
                mission_node.panel_1.btn_icon  = TFDirector:getChildByPath(mission_node.panel_1, 'btn_icon');
                mission_node.panel_1.btn_icon:setTextureNormal(GetColorIconByQuality(specialDrop.quality));
            
                local SpecialDropStar = MissionManager:getSpecialDropStarByMissionId(missionId);

                if not SpecialDropStar then
                    mission_node.panel_1.txt_1:setText(localizable.crossLevelstar1);
                elseif tonumber(SpecialDropStar) == 1 then
                    mission_node.panel_1.txt_1:setText(localizable.crossLevelstar1);
                elseif tonumber(SpecialDropStar) == 2 then
                    mission_node.panel_1.txt_1:setText(localizable.crossLevelstar2);
                elseif tonumber(SpecialDropStar) == 3 then
                    mission_node.panel_1.txt_1:setText(localizable.crossLevelstar3);
                end
        
                mission_node.panel_1.img_icon  = TFDirector:getChildByPath(mission_node.panel_1, 'img_icon');
                mission_node.panel_1.txt_num1  = TFDirector:getChildByPath(mission_node.panel_1, 'txt_num1');
			    mission_node.panel_1.txt_num2  = TFDirector:getChildByPath(mission_node.panel_1, 'txt_num2');
			    mission_node.panel_1.txt_num1:setVisible(false);
			    mission_node.panel_1.txt_num2:setText(specialDrop.number);
                mission_node.panel_1.img_icon:setTexture(specialDrop.path);--1_40064

                self.onClick = function( sender )
    	            Public:ShowItemTipLayer(specialDrop.itemid, specialDrop.type);
                end
                mission_node.panel_1.btn_icon:addMEListener(TFWIDGET_CLICK,audioClickfun(self.onClick));
            else
                mission_node.panel_1:setVisible(false);
            end
        else
            mission_node.panel_1:setVisible(false);
        end
    end
        
    -- mission_node:setScale(0.4);
    mission_node:setPosition(ccp(posItem.missonPosX - 480 - btn_attack:getSize().width/2 ,posItem.missonPosY - 320 - btn_attack:getSize().height/2 ));
    mission_node.logic = self;
    mission_node:setTag(mission.id);
    mission_node:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onBtnAttackClickHandle));

    self.missionNodeList[mission.id] = mission_node;


    local img_num = TFDirector:getChildByPath(mission_node, 'img_num');
    img_num:setTexture("ui_new/mission/gk_" .. index .. ".png")

    local txt_name = TFDirector:getChildByPath(mission_node, 'txt_name');
    local img_boss = TFDirector:getChildByPath(mission_node, 'img_boss');
    if img_boss then
        img_boss:setTexture("icon/head/" .. mission.image .. ".png")
    end

    --已通关，属性填充
    if status == MissionManager.STATUS_PASS then
        mission_node:setName("pre_mission_"..index)

        if mission.starLevel  <  3 then
            --txt_name:setText("第" .. index  .. "回");
            txt_name:setText(stringUtils.format(localizable.common_index_hui ,index));
        else
           --txt_name:setText("可扫荡");
           txt_name:setText(localizable.common_sweep);
        end
        for i=1, 3 do
            local img_star = TFDirector:getChildByPath(mission_node, 'img_star' .. i);
            if mission.starLevel  <  i then
                img_star:setVisible(false);
            end
        end
    end

    --已经开放的关卡，属性填充
    if status == MissionManager.STATUS_CUR then
        -- self.standingMissionId = mission.id;
        mission_node:setName("cur_mission")

        --txt_name:setText("可挑战");
        txt_name:setText(localizable.missionDetail_fight);

        local resPath = "effect/mission_attacking.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("mission_attacking_anim")

        effect:setAnimationFps(GameConfig.ANIM_FPS)
        if mission.type > MissionManager.TYPE_COMMON then
            effect:setPosition(ccp(btn_attack:getPosition().x,btn_attack:getPosition().y-2));
        else
            effect:setPosition(ccp(btn_attack:getPosition().x,btn_attack:getPosition().y-2));
        end
        btn_attack:getParent():addChild(effect,1)
        self.btn_attack = btn_attack
        effect:setScale(0.5)
        -- effect:addMEListener(TFARMATURE_COMPLETE,function()
        --     effect:removeMEListener(TFARMATURE_COMPLETE)
        --     effect:removeFromParent()
        -- end)
        effect:playByIndex(0, -1, -1, 1)
        -- self.playAutoMatixTimeId = TFDirector:addTimer(600, 1, nil, function()
        --     self:playAutoMatixComEffect()
        -- end);

        -- armature:setShaderProgram("HighLight", true)
        if roadImg then
            roadImg:setShaderProgram("GrayShader", true)
        end

        --增加等级限制添加，by wk.dai
        if mission.reqiure_level > MainPlayer:getLevel() then
            effect:setShaderProgram("GrayShader", true)
        end

        -- local bShow = ( MissionManager:checkIsInCurMap(self.selectIndex) ) and ( mission.difficulty == 1 ) and PlayerGuideManager:shouldLongTimeGuideShow(2)
        -- --andorid上有点偏移，暂时关掉
        -- PlayerGuideManager:addLongTimeGuide(page, btn_attack, 2, bShow)
    end

    --未开放的关卡，属性填充
    if status == MissionManager.STATUS_CLOSE  or status == MissionManager.STATUS_NEED_DIFFICULTY0 then
        --txt_name:setText("第" .. index  .. "回");
        txt_name:setText(stringUtils.format(localizable.common_index_hui,index));

        local img_general = TFDirector:getChildByPath(mission_node, 'img_general');
        local img_city = TFDirector:getChildByPath(mission_node, 'img_city');

        if img_num then
            mission_node.img_num = img_num
            img_num:setShaderProgram("GrayShader", true)
        end
        if txt_name then
            mission_node.txt_name = txt_name
            txt_name:setShaderProgram("GrayShader", true)
        end
        if img_boss then
            mission_node.img_boss = img_boss
            img_boss:setShaderProgram("GrayShader", true)
        end
        if btn_attack then
            mission_node.btn_attack = btn_attack
            btn_attack:setShaderProgram("GrayShader", true)
        end
        if img_general then
            mission_node.img_general = img_general
            img_general:setShaderProgram("GrayShader", true)
        end
        if img_city then
            mission_node.img_city = img_city
            img_city:setShaderProgram("GrayShader", true)
        end

        if(roadImg) then
            mission_node.roadImg = roadImg
            roadImg:setShaderProgram("GrayShader", true)
        end
    end

    if self.showAttackTipMissionId and  self.showAttackTipMissionId == missionId then
        local resPath = "effect/guide.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("guide_anim")

        effect:setAnimationFps(GameConfig.ANIM_FPS)

        effect:setPosition(ccp(btn_attack:getPosition().x  ,btn_attack:getPosition().y + 10));
        effect:setTag(100)
        btn_attack:getParent():addChild(effect,1)

        -- effect:addMEListener(TFARMATURE_COMPLETE,function()
        --     effect:removeMEListener(TFARMATURE_COMPLETE)
        --     effect:removeFromParent()
        -- end)
        effect:playByIndex(0, -1, -1, 1)
        -- self.playAutoMatixTimeId = TFDirector:addTimer(600, 1, nil, function()
        --     self:playAutoMatixComEffect()
        -- end);
    end
end

function MissionLayer:showAttackTip(missionId)
    self.showAttackTipMissionId = missionId;
end

function MissionLayer:getArmatureByImage(image)
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
    armature:play("stand", -1, -1, 1)
    armature:setScale(0.6)
    return armature
end

--删除节点
function MissionLayer:removeMissionNode(missionId)
    local mission_node = self.missionNodeList[missionId];
    if mission_node then
        mission_node:removeFromParentAndCleanup(true);
        self.missionNodeList[missionId] = nil;
    end
end

function MissionLayer.onLeftClickHandle(sender)
    local self = sender.logic;
    local pageIndex = self.pageView:getCurPageIndex() ;

    self.pageView:scrollToPage(pageIndex - 1);
end

function MissionLayer.onRightClickHandle(sender)
    local self = sender.logic;
    local pageIndex = self.pageView:getCurPageIndex() ;

    self.pageView:scrollToPage(pageIndex + 1);
end

function MissionLayer.onJingyanClickHandle(sender)
    MainPlayer:showMultipleOutputInfo(1)
end

function MissionLayer.onStrongerClickHandle(sender)
    local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(1202)
    CommonManager:setRedPointStateByKey( "isHaveBook", false )
    if teamLev < openLev then
        CardRoleManager:openRoleList()
    else
        local layer = AlertManager:addLayerByFile("lua.logic.army.ArmyNewLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
        layer:setOpenInfo(true)
        AlertManager:show()
    end
end

function MissionLayer.onShowSortMenuClickHandle(sender)
    local self = sender.logic;
    self.node_menu:setVisible(not self.node_menu:isVisible());
    -- self.btn_sort:setVisible(false);
end

function MissionLayer.onSortSelectClickHandle(sender)
    local self = sender.logic;

    -- self.node_menu:setVisible(false);
    -- self.btn_sort:setVisible(true);

    if (self.groupButtonManager:getSelectButton() == sender) then
        return;
    end

    self:changeDifficulty(sender.difficulty);

end

function MissionLayer:changeDifficulty(difficulty)
    self.selectDifficulty = difficulty;
    local btn_select = self.btn_sortArr[difficulty];

    for k,v in pairs(self.addMapTimer) do
        TFDirector:removeTimer(v)
    end
    for k,v in pairs(self.addMissionTimer) do
        TFDirector:removeTimer(v)
    end

    if self.scrollPageTimer then
        TFDirector:removeTimer(self.scrollPageTimer);
        self.scrollPageTimer = nil;
    end

    self.addMapTimer = {}
    self.addMissionTimer = {}

    -- local img_select = TFImage:create("ui_new/mission/gk_duihao.png");
    -- self.groupButtonManager:getSelectButton():removeChildByTag(10086,true);
    -- img_select:setPosition(ccp(50,0))
    -- img_select:setTag(10086);
    -- btn_select:addChild(img_select);

    self.groupButtonManager:getSelectButton().highlight:setVisible(false)
    btn_select.highlight:setVisible(true)
    self.groupButtonManager:selectBtn(btn_select);

    self.selectIndex = self.pageView:_getCurPageIndex();
    local map = MissionManager:getCurrentMap(difficulty);

    -- if difficulty == MissionManager.DIFFICULTY0 then
        if map then
            self.selectIndex = MissionManager:getMapList(self.selectDifficulty):indexOf(map);
        else
            self.selectIndex = MissionManager:getMapList(self.selectDifficulty):length();
        end
    -- end
    self:refreshMissionList(self.selectIndex);


    -- if difficulty ~= MissionManager.DIFFICULTY0 and map and self.selectIndex == MissionManager:getMapList():indexOf(map) then
    --     local function scrollPage()
    --         local pageIndex = self.pageView:getCurPageIndex() ;
    --         self.pageView:scrollToPage(pageIndex - 1);
    --     end
    --     self.scrollPageTimer = TFDirector:addTimer(0, 1, scrollPage, nil);
    -- end
end

function MissionLayer.onSortCancelClickHandle(sender)
    local self = sender.logic;
    self.node_menu:setVisible(false);
    self.btn_sort:setVisible(true);
end

--   local status = MissionManager:getMissionPassStatus(missionId);
function MissionLayer.onBtnAttackClickHandle(sender)

        -- local self = sender.logic;
        -- local resPath = "effect/mission_open.xml"
        -- TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        -- local effect = TFArmature:create("mission_open_anim")

        -- effect:setAnimationFps(GameConfig.ANIM_FPS)
        -- effect:setPosition(ccp(self:getSize().width/2,self:getSize().height/2))

        -- self:addChild(effect,2)

        -- effect:addMEListener(TFARMATURE_COMPLETE,function()
        --     effect:removeMEListener(TFARMATURE_COMPLETE)
        --     effect:removeFromParent()
        -- end)
        -- effect:playByIndex(0, -1, -1, 0)
        -- -- self.playAutoMatixTimeId = TFDirector:addTimer(600, 1, nil, function()
        -- --     self:playAutoMatixComEffect()
        -- -- end);
   
    local self = sender.logic;
    local missionId = sender:getTag();
    if self.showAttackTipMissionId and self.showAttackTipMissionId == missionId then
        self.showAttackTipMissionId = nil
        local widget = sender:getParent():getChildByTag(100)
        if widget then
            widget:removeFromParent()
        end
    end
    self:setGuideBlockViisble(false,true)
    --PlayerGuideManager:ShowGuideLayer(nil)

    local status = MissionManager:getMissionPassStatus(missionId);
    local mission = MissionManager:getMissionById(missionId);

    --add by david.dai
    if status == MissionManager.STATUS_CUR then
        if mission.reqiure_level > MainPlayer:getLevel() then
            --toastMessage('你的团队等级不足，请提升到'..mission.reqiure_level..'级，再尝试')
            toastMessage(stringUtils.format(localizable.common_team_level_notenough,mission.reqiure_level))
            return
        end
    end

    if status == MissionManager.STATUS_CLOSE  or status == MissionManager.STATUS_NEED_DIFFICULTY0 then
        local msg = "";

        if mission.difficulty == MissionManager.DIFFICULTY0 then
            local currentMission = MissionManager:getCurrentMission(mission.difficulty);
            local missionlist = MissionManager:getMissionListByMapId(currentMission.mapid);
            local curMissionlist = missionlist[currentMission.difficulty];
            local index = curMissionlist:indexOf(currentMission);
            --初级难度
            --msg = "请先通关\"" .. MissionManager.DIFFICULTY_STR[currentMission.difficulty] .. currentMission.mapid .. "-" .. index .. "\"!";
            msg = stringUtils.format(localizable.missionLayer_please, MissionManager.DIFFICULTY_STR[currentMission.difficulty] , currentMission.mapid , index )
        end

        if mission.difficulty == MissionManager.DIFFICULTY1  then
            local currentMission = MissionManager:getCurrentMission(mission.difficulty);
            local missionlist = MissionManager:getMissionListByMapId(currentMission.mapid);
            local curMissionlist = missionlist[currentMission.difficulty];
            local index = curMissionlist:indexOf(currentMission);
            if status == MissionManager.STATUS_CLOSE then
                --msg = "请先通关\"" .. MissionManager.DIFFICULTY_STR[currentMission.difficulty] .. currentMission.mapid .. "-" .. index .. "\"!";
                local curMapId = tonumber(currentMission.mapid)
                curMapId = math.mod(curMapId,100)
                msg = stringUtils.format(localizable.missionLayer_please, MissionManager.DIFFICULTY_STR[currentMission.difficulty] , curMapId, index )
            elseif status == MissionManager.STATUS_NEED_DIFFICULTY0 then
                local currentMission0 = MissionManager:getCurrentMission(MissionManager.DIFFICULTY0);

                if currentMission0 and  currentMission.mapid >= currentMission0.mapid then
                    --msg = "请先通关\"" .. MissionManager.DIFFICULTY_STR[currentMission0.difficulty] .. currentMission0.mapid .. "-" .. index .. "\"!";
                    msg = stringUtils.format(localizable.missionLayer_please, MissionManager.DIFFICULTY_STR[currentMission0.difficulty] , currentMission0.mapid , index )
                   
                else
                    --msg = "请先通关\"" .. MissionManager.DIFFICULTY_STR[currentMission.difficulty] .. currentMission.mapid .. "-" .. index .. "\"!";
                    msg = stringUtils.format(localizable.missionLayer_please, MissionManager.DIFFICULTY_STR[currentMission.difficulty] , currentMission.mapid , index )
                    
                end

            end
        end
        sender:setGrayEnabled(true)


        -- if mission.difficulty == MissionManager.DIFFICULTY1 then
        --     local attackingMission = MissionManager:getCurrentMissionInMapByDifficulty(mission.mapid,mission.difficulty);

        --     if attackingMission and MissionManager:getMissionPassStatus(attackingMission.id) == MissionManager.STATUS_CUR then
        --         local missionlist = MissionManager:getMissionListByMapId(attackingMission.mapid);
        --         local curMissionlist = missionlist[attackingMission.difficulty];
        --         local index = curMissionlist:indexOf(attackingMission);

        --         --上一关未通过
        --         msg = "请先通关__\"" .. MissionManager.DIFFICULTY_STR[attackingMission.difficulty] .. attackingMission.mapid .. "-" .. index .. "\"!";
        --     else
        --         local currentMission = MissionManager:getCurrentMission(MissionManager.DIFFICULTY0);
        --         local missionlist = MissionManager:getMissionListByMapId(currentMission.mapid);
        --         local curMissionlist = missionlist[currentMission.difficulty];
        --         local index = curMissionlist:indexOf(currentMission);
        --         --初级难度
        --         msg = "请先通关==\"" .. MissionManager.DIFFICULTY_STR[currentMission.difficulty] .. currentMission.mapid .. "-" .. index .. "\"!";
        --     end
        -- end

        -- if mission.difficulty == MissionManager.DIFFICULTY2 then
        --   if attackingMission and MissionManager:getMissionPassStatus(attackingMission.id) == MissionManager.STATUS_CUR then
        --       local missionlist = MissionManager:getMissionListByMapId(attackingMission.mapid);
        --       local curMissionlist = missionlist[attackingMission.difficulty];
        --       local index = curMissionlist:indexOf(attackingMission);

        --       --上一关未通过
        --       msg = "请先通关\"" .. MissionManager.DIFFICULTY_STR[attackingMission.difficulty] .. attackingMission.mapid .. "-" .. index .. "\"!";
        --   else
        --       local attackingMission1 = MissionManager:getCurrentMissionInMapByDifficulty(mission.mapid,MissionManager.DIFFICULTY1);
        --       if attackingMission1 and MissionManager:getMissionPassStatus(attackingMission1.id) == MissionManager.STATUS_CUR then

        --             local missionlist = MissionManager:getMissionListByMapId(attackingMission1.mapid);
        --             local curMissionlist = missionlist[attackingMission1.difficulty];
        --             local index = curMissionlist:indexOf(attackingMission1);

        --             msg = "请先通关\"" .. MissionManager.DIFFICULTY_STR[attackingMission1.difficulty] .. attackingMission1.mapid .. "-" .. index .. "\"!";
        --       else
        --           local currentMission = MissionManager:getCurrentMission(mission.difficulty);
        --           local missionlist = MissionManager:getMissionListByMapId(currentMission.mapid);
        --           local curMissionlist = missionlist[currentMission.difficulty];
        --           local index = curMissionlist:indexOf(currentMission);

        --           msg = "请先通关\"" .. MissionManager.DIFFICULTY_STR[currentMission.difficulty] .. currentMission.mapid .. "-" .. index .. "\"!";
        --       end
        --   end
        -- end

      toastMessage(msg)
      return;
    end
    if (mission.mapid == 2 and mission.stageid ==1) then
        --埋点id:18 点击第二章第一关
        local playerLv = MainPlayer:getLevel()
        if (playerLv == 4) then
            TFDirector:send(c2s.DATA_COLLECT_REQUEST, {18})
        end
    end
    MissionManager:showDetailLayer(missionId);
end

function MissionLayer:onClickHandleForTrustLayer()

    local newMission = MissionManager:getCurrentMission(self.selectDifficulty)
    if newMission == nil or (newMission.id >= 10000 or newMission.starLevel ~= MissionManager.STARLEVEL0) then
        toastMessage(localizable.TrustOneKey_Nomore)
        MissionManager:stopTrustOnekey()
        return
    end

    if MainPlayer:getLevel() < newMission.reqiure_level then
        toastMessage(stringUtils.format(localizable.common_function_openlevel, newMission.reqiure_level))
        MissionManager:stopTrustOnekey()
        return
    end

    MissionManager:showDetailLayer(newMission.id);
end

function MissionLayer:onAttackCompeleteHandle(event)
    local missionId                = event.data[1].missionId;
    local isFirstTimesPass         = event.data[1].isFirstTimesPass;
    local isFirstTimesToStarLevel3 = event.data[1].isFirstTimesToStarLevel3;

    local mission = MissionManager:getMissionById(missionId);

    -- if self.standingMissionId then
    --     local standingMission = MissionManager:getMissionById( self.standingMissionId );
    --     self:removeMissionNode(self.standingMissionId);
    --     self:addMissionNode(self.pageList[standingMission.mapid],self.standingMissionId)
    --     self.standingMissionId  = nil;
    -- end

    --更新当前节点
    self:removeMissionNode(missionId);
    self:addMissionNode(self.pageList[mission.mapid],mission)

    --更新体力恢复节点
    if MissionManager:isHasPassAllMissionForDifficulty(mission.mapid,mission.difficulty) then
        -- self:removeUseEnergyNode();
        -- self:addUseEnergyNode();
    end

    --首次胜利，判断：开放下一关卡
    if isFirstTimesPass then
        local nextMission = MissionManager:getNextMissionById(mission.mapid,mission.difficulty,missionId);
        local currentMission = MissionManager:getCurrentMission(mission.difficulty);

        if nextMission then
            self:removeMissionNode(nextMission.id);
            self:addMissionNode(self.pageList[nextMission.mapid],nextMission);
        elseif currentMission then
            if MissionManager:isInTrustOnekey() then
                self:removeMissionNode(currentMission.id);
                self:addMissionNode(self.pageList[currentMission.mapid],currentMission);
                local pageIndex = self.pageView:getCurPageIndex() ;
                self.pageView:scrollToPage(pageIndex + 1);
                return
            end
            local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionSkipNewLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);        
            layer:loadData(mission.mapid,mission.difficulty);     
            layer:setBtnHandle(
                function ()
                    --继续闯关
                    self:removeMissionNode(currentMission.id);
                    self:addMissionNode(self.pageList[currentMission.mapid],currentMission);
                    local pageIndex = self.pageView:getCurPageIndex() ;
                    self.pageView:scrollToPage(pageIndex + 1);
                end,
                function ()
                    --我要满星
                    self:removeMissionNode(currentMission.id);
                    self:addMissionNode(self.pageList[currentMission.mapid],currentMission);
                    local missionlist = MissionManager:getMissionListByMapId(mission.mapid);
                    local curMissionlist = missionlist[self.selectDifficulty];
                    local function getFirstNo3StarLevel()
                        for k,v in pairs(curMissionlist.m_list) do
                            if v.starLevel < 3 then
                                return v.id
                            end                       
                        end
                        return nil
                    end

                    local firstNo3StarMissionId = getFirstNo3StarLevel()
                    if firstNo3StarMissionId then
                        MissionManager:showDetailLayer(firstNo3StarMissionId);
                    end
                end)  
            AlertManager:show();  
        end
    end
end


function MissionLayer.onOpenBoxClickHandle(sender)
    local self = sender.logic;
    local pageIndex = self.pageView:_getCurPageIndex();
    local map = MissionManager:getMapList(self.selectDifficulty):objectAt(pageIndex);
    local mapBox = MissionManager:getBoxByMapIdAndDifficulty(map.id,self.selectDifficulty);

    local curStar = MissionManager:getStarlevelCount(map.id,self.selectDifficulty);
    local maxStar = MissionManager:getMaxStarlevelCount(map.id,self.selectDifficulty);
    if (curStar == maxStar and mapBox  and maxStar >= mapBox.need_star ) then

    else
        --toastMessage("要全部三星哦");
        toastMessage(localizable.missionLayer_start);
        return;
    end

    if mapBox.isAlreadyOpen then
        --toastMessage("已领取");
        toastMessage(localizable.common_get);
        return;
    end

    MissionManager:openBox(mapBox.id);


end

function MissionLayer.onBtnPlayerTipClickHandle(sender)
    local self = sender.logic;
    -- local lastMission = MissionManager:getLastMissionByMapIdAndDifficulty(self:getCurMap().id, MissionManager.DIFFICULTY0);
    -- self:playerTip(lastMission.id);
end


--注册事件
function MissionLayer:registerEvents()

    self.super.registerEvents(self);
    -- ADD_ALERT_CLOSE_LISTENER(self,self.btn_close);
    -- self.btn_close:setClickAreaLength(100);
    -- self.btn_sort.logic = self;
    self.btn_sort_level0.logic = self;
    -- self.btn_sort_level1.logic = self;
    self.btn_sort_level1.logic = self;
    -- self.bg_sort.logic = self;

    -- self.btn_sort:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onShowSortMenuClickHandle));
    self.btn_sort_level0:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSortSelectClickHandle));
    -- self.btn_sort_level1:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSortSelectClickHandle));
    self.btn_sort_level1:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSortSelectClickHandle));
    -- self.bg_sort:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onSortCancelClickHandle));

    --quanhuan close 2015-9-24 13:30:53
    --self.btn_reward.logic = self;
    --self.btn_reward:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onOpenBoxClickHandle),1);


    self.btn_left.logic = self;
    self.btn_left:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onLeftClickHandle),1);
    self.btn_right.logic = self;
    self.btn_right:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRightClickHandle),1);

    self.btn_onekey.logic = self
    self.btn_onekey:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onBtnOneKeyClick),1);

    self.btn_jingyan:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onJingyanClickHandle),1);

    self.updateMissionCallBack = function(event)
        self:onAttackCompeleteHandle(event);
        self:refreshUI(event);
        local pageIndex = self.pageView:_getCurPageIndex() ;
        self:showInfoForPage(pageIndex);
    end;
    TFDirector:addMEGlobalListener(MissionManager.EVENT_UPDATE_MISSION ,self.updateMissionCallBack ) ;

    self.updateBoxCallBack = function(event)
        self:refreshUI(event);
        local pageIndex = self.pageView:_getCurPageIndex() ;
        self:showInfoForPage(pageIndex);
    end;
    --TFDirector:addMEGlobalListener(MissionManager.EVENT_UPDATE_BOX ,self.updateBoxCallBack ) ;

    -- self.updateUserDataCallBack = function(event)
    --     self:refreshBaseUI();
    -- end;
    -- TFDirector:addMEGlobalListener(MainPlayer.CoinChange ,self.updateUserDataCallBack ) ;
    -- TFDirector:addMEGlobalListener(MainPlayer.SyceeChange ,self.updateUserDataCallBack ) ;
    -- TFDirector:addMEGlobalListener(MainPlayer.ChallengeTimesChange ,self.updateUserDataCallBack ) ;
    self.leaveFightCallBack = function(event)
        if MainPlayer.levelUpForTrustOneKey then
            MissionManager:stopTrustOnekey()
            MainPlayer.levelUpForTrustOneKey = nil
        end
        MissionManager:checkTrustOnekeyLayer(self,true)
    end
    TFDirector:addMEGlobalListener(FightManager.LeaveFightForOneKey ,self.leaveFightCallBack )

    

    if self.generalHead then
        self.generalHead:registerEvents()
    end

    if self.mapBoxView then
        self.mapBoxView:callRegisterEvents()
    end
end

--浪人武士
function MissionLayer:knightShow()
    KnightManager:showShare()
    if (KnightManager:getAutoShowKnight()) then
        KnightManager:openKnightLayer(self)
        return true
    end
    return false
end

function MissionLayer:removeEvents()

    TFDirector:removeMEGlobalListener(MissionManager.EVENT_UPDATE_MISSION ,self.updateMissionCallBack);
    self.updateMissionCallBack = nil;

    --TFDirector:removeMEGlobalListener(MissionManager.EVENT_UPDATE_BOX ,self.updateBoxCallBack);
    self.updateBoxCallBack = nil;

    TFDirector:removeMEGlobalListener(FightManager.LeaveFightForOneKey ,self.leaveFightCallBack )
    self.leaveFightCallBack = nil
    -- TFDirector:removeMEGlobalListener(MainPlayer.CoinChange ,self.updateUserDataCallBack);
    -- TFDirector:removeMEGlobalListener(MainPlayer.SyceeChange ,self.updateUserDataCallBack);
    -- TFDirector:removeMEGlobalListener(MainPlayer.ChallengeTimesChange ,self.updateUserDataCallBack ) ;

 --   self.updateUserDataCallBack = nil;

    for k,v in pairs(self.addMapTimer) do
        TFDirector:removeTimer(v)
    end
    for k,v in pairs(self.addMissionTimer) do
        TFDirector:removeTimer(v)
    end
    if self.scrollPageTimer then
        TFDirector:removeTimer(self.scrollPageTimer);
        self.scrollPageTimer = nil;
    end
    
    if self.generalHead then
        self.generalHead:removeEvents()
    end
    -- end
    self.showAttackTipMissionId = nil

    if self.mapBoxView then
        self.mapBoxView:callRemoveEvents()
    end
end

function MissionLayer.onBtnAttackTouchEndedHandle(sender)
local self = sender.logic
    local missionId = sender:getTag()
    local status = MissionManager:getMissionPassStatus(missionId)
    if status == MissionManager.STATUS_CLOSE  or status == MissionManager.STATUS_NEED_DIFFICULTY0 then
        print("onBtnAttackTouchEndedHandle")
        local mission_node = self.missionNodeList[missionId]
        if mission_node then
            if mission_node.btn_attack then
                mission_node.btn_attack:setShaderProgram("GrayShader", true)
            end
        end
    end
end

function MissionLayer.onBtnOneKeyClick(sender)
    local self = sender.logic

    local newMission = MissionManager:getCurrentMission(self.selectDifficulty)

    if newMission == nil or (newMission.id >= 10000 or newMission.starLevel ~= MissionManager.STARLEVEL0) then
        toastMessage(localizable.TrustOneKey_Nomore)
        MissionManager:stopTrustOnekey()
        return
    end

    if MainPlayer:getLevel() < newMission.reqiure_level then
        -- toastMessage(stringUtils.format(localizable.common_function_openlevel, newMission.reqiure_level))
        toastMessage(localizable.TrustOneKey_Nomore)
        MissionManager:stopTrustOnekey()
        return
    end

    self:changeDifficulty(self.selectDifficulty)
    
    MissionManager:startTrustOnekey(self,true)
end
return MissionLayer;
