--	MenuLayer
-- Stephen.tao
-- Date: 2014-03-04 16:07:01
--

local MenuLayer = class("MenuLayer", BaseLayer)
local LevelOpen = require('lua.table.t_s_open')             --等级开放配置表

local pointerPic = {"ui_new/home/main_genduo2_btn.png", "ui_new/home/main_genduo3_btn.png"}

local chengjiuBtnPic = { "ui_new/home/main_chengjiu_btn_1.png", "ui_new/home/main_chengjiu_btn.png" }
local paihangBtnPic = { "ui_new/home/zjm_paihang_icon1.png", "ui_new/home/zjm_paihang_icon.png" }
local friendBtnPic = { "ui_new/home/main_haoyou_btn1.png", "ui_new/home/main_haoyou_btn.png" }

ActivityBtn = {
	kfFight = 1,
	crossGuild = 2,
	kingWar = 3,
	wuLinEnemy = 4,
	biaoChe = 5,
	fengyunLu = 6,
	dati = 7,
}
function MenuLayer:ctor(data)
	if (CC_TARGET_PLATFORM ~= CC_PLATFORM_WIN32) then
		CCLog_setDebugFileEnabled(0)
	end
	local fileName = CCFileUtils:sharedFileUtils():getWritablePath().."../../Resource/"
	me.TextureCache:removeTextureForKey(fileName.."spine/fm.png")
	me.TextureCache:removeTextureForKey(fileName.."spine/fm2.png")
	me.TextureCache:removeTextureForKey(fileName.."spine/fm3.png")
	--
	self.armatureList = {}
	self.posEffList = {}
	self.playerBackBtn = nil
	self.isLoadRoleList = true
    self.super.ctor(self,data)

    self.checkRedPoint = {}
    self.totalPower = 0
    self.isAcc = true
    self:init("lua.uiconfig_mango_new.main.MenuLayer")
    --TFDeviceInfo:setOpenAccelerometer(true)
	-- self:initNightScene()
	--------
	self.showDelayTimer_1 = nil
	self.addLoadTimer_2 = nil
	
	self:delayedLoad("addLoadTimer_2", self.delayedLoadScene)
end
--延时
function MenuLayer:delayedLoadScene(loadCount, loadTime)
	-- -- -- TFLuaTime:begin()
	local function initScen()
		local date = GetCorrectDate("*t", MainPlayer:getNowtime())
		local isnight = false
		if date.hour < 6 or date.hour >= 18 then
			isnight = true
		end
		self:initNightScene(isnight)
	end
	
	local function AddResEffect()
		self:AddResEffect(self.img_chaungguanling, "main_res_effect", 86, 27, 2)
		self:AddResEffect(self.img_tongbi, "main_res_effect", 80, 27, 1)
		self:AddResEffect(self.img_yuanbao, "main_res_effect", 83, 26, 0)
	end
	local function AddButtonEffect()
		self:AddButtonEffect(self.btn_pay, "main_pay", 0, 0)
		self:AddButtonEffect(self.btn_firstpay, "main_firstpay", 0, -4)
		self:AddButtonEffect(self.btn_youfang, "main_youfang", 0, 6)
		-- self:AddButtonEffect(self.btn_down, "main_download", 0, 1)
		self:AddButtonEffect(self.pveBtn, "pveBtnEffect", 5, -76,1)
	end
	local loadFuncList = 
	{
		-- self.AddBgImgEffect,
		self.addMainBgEffect,
		initScen,
		self.showChatBubble,
		self.delayedLoad_1,
		AddResEffect,
		AddButtonEffect
	}
	local tb = TFLuaTime:clock()
	if (loadCount <= #loadFuncList) then
		local func = loadFuncList[loadCount]
		if (func) then
			func(self)	
			loadCount = loadCount + 1
		end
	else
		loadCount = -1
	end
	loadTime = loadTime + (TFLuaTime:clock() - tb)

	return loadCount, loadTime
end
function MenuLayer:initUI(ui)
	self.super.initUI(self,ui)
	self.ui = ui
	-- self.root_bg = TFDirector:getChildByPath(self, 'bg')
	local chatNode = TFDirector:getChildByPath(self, 'bg_chat')
	self.bubbleNode = TFDirector:getChildByPath(self, 'bg_chat')
	self.bubblePanel = TFDirector:getChildByPath(self, 'panel_chatclip')
	self.txtBubble = TFDirector:getChildByPath(chatNode, 'txt_chat')
	self.txtBubbleTitle = TFDirector:getChildByPath(chatNode, 'txt_chattitle')

	self.bg 		= TFDirector:getChildByPath(self, 'bg')
	self.bg:setVisible(false)
	self.bg_front  = TFDirector:getChildByPath(self, 'bg_front')
	self.rolePanel 	= TFDirector:getChildByPath(self, 'rolePanel')
	self.txt_level 	= TFDirector:getChildByPath(self, 'txt_level')
	self.txt_vip 	= TFDirector:getChildByPath(self, 'txt_vip')
	
	--added by wuqi
	self.img_vip = TFDirector:getChildByPath(self, "img_vip")

	self.btn_kaojiao = TFDirector:getChildByPath(ui, "btn_kaojiao")

	self.btn_head   = TFDirector:getChildByPath(self, 'btn_touxiang')
	self.btn_head.logic = self
	self.headImg	= TFDirector:getChildByPath(self, 'headImg')

	self.btn_chat 	= TFDirector:getChildByPath(self, 'btn_chat')
	self.setingBtn 	= TFDirector:getChildByPath(self, 'setingBtn')

	local Particle_SHENGDANxuehua = TFDirector:getChildByPath(ui, "Particle_SHENGDANxuehua")
	Particle_SHENGDANxuehua:setVisible(false)

    self.btn_buytime            = TFDirector:getChildByPath(ui, 'btn_add_1')
    self.btn_buycion            = TFDirector:getChildByPath(ui, 'btn_add_2')
    self.btn_buysycee           = TFDirector:getChildByPath(ui, 'btn_add_3')

    self.txt_tilipoint          = TFDirector:getChildByPath(ui, 'txt_number_1')
    self.txt_tongbipoint        = TFDirector:getChildByPath(ui, 'txt_number_2')
    self.txt_yuanbaopoint       = TFDirector:getChildByPath(ui, 'txt_number_3')
    self.txt_power       		= TFDirector:getChildByPath(ui, 'txt_zhanlizhi')
    self.img_power       		= TFDirector:getChildByPath(ui, 'img_zhanlidi')
    self.txt_systemtime       		= TFDirector:getChildByPath(ui, 'txt_time')
	self.roleBtn    = TFDirector:getChildByPath(self, 'roleBtn')
	self.equipBtn 	= TFDirector:getChildByPath(self, 'equipBtn')
	self.bagBtn 	= TFDirector:getChildByPath(self, 'bagBtn')
	self.mallBtn 	= TFDirector:getChildByPath(self, 'mallBtn')
	self.zhaomuBtn 	= TFDirector:getChildByPath(self, 'zhaomuBtn')
	self.taskBtn 	= TFDirector:getChildByPath(self, 'taskBtn')
	self.infoBtn	= TFDirector:getChildByPath(self, 'infoBtn')

	self.pvpBtn 	= TFDirector:getChildByPath(self, 'pvpBtn')
	self.pvpBtnPos = self.pvpBtn:getPosition()
	self.pveBtn 	= TFDirector:getChildByPath(self, 'pveBtn')
	self.qiyuBtn	= TFDirector:getChildByPath(self, 'qiyuBtn')
	self.btn_youli  = TFDirector:getChildByPath(self, 'btn_youli')
	self.btnYouliPos=self.btn_youli:getPosition()

	-- 前期奖励
	self.panel_1 		= TFDirector:getChildByPath(self, 'panel_1')
	self.panel_1:setVisible(false);

	self.btn_tianjilun = TFDirector:getChildByPath(self, 'btn_tianjilun')
	self.btn_murenzhuang = TFDirector:getChildByPath(self, 'btn_murenzhuang')

	self.btn_pay	= TFDirector:getChildByPath(self, 'btn_pay')
	self.btn_firstpay    = TFDirector:getChildByPath(self, 'btn_firstpay')
	self.btn_weixin    = TFDirector:getChildByPath(self, 'WeixinBtn')
	self.btn_sign	= TFDirector:getChildByPath(self, 'btn_qiandao')
	self.btn_yueka	= TFDirector:getChildByPath(self, 'btn_yueka')
	self.btn_vip	= TFDirector:getChildByPath(self, 'btn_vip')
	self.btn_wulin	= TFDirector:getChildByPath(self, 'btn_wulin')
	self.btn_down	= TFDirector:getChildByPath(self, 'btn_down')
	self.btn_zhengbasai	= TFDirector:getChildByPath(self, 'btn_zhengbasai')
	self.btn_kfFight	= TFDirector:getChildByPath(self, 'btn_kfFight')
	self.btn_kfFightXY  = self.btn_kfFight:getPosition()
	self.btn_crossGuildBattle	= TFDirector:getChildByPath(self, 'btn_crossGuildBattle')
	self.btn_crossGuildBattleXY  = self.btn_crossGuildBattle:getPosition()
	self.btn_gonglue	= TFDirector:getChildByPath(self, 'btn_gonglue')
	self.btn_youfang	= TFDirector:getChildByPath(self, 'btn_youfang')
	self.btn_longmenpo 	= TFDirector:getChildByPath(self, 'btn_longmenpo')
	self.btn_sevenDayPower 	= TFDirector:getChildByPath(self, 'btn_sevenDayPower')

	self.btn_sevenDayRank 	= TFDirector:getChildByPath(self, 'btn_sevenDayRank')

	self.btn_tujian = TFDirector:getChildByPath(self, 'btn_tujian')

	self.taskPanel = TFDirector:getChildByPath(self, 'taskPanel')
	self.dailyTaskBtn = TFDirector:getChildByPath(self, 'openBtn')

	self.btn_employ = TFDirector:getChildByPath(self, 'btn_employ')
	
	self.btn_eudemon = TFDirector:getChildByPath(self, 'btn_zhanchong')

	self.btn_paihang = TFDirector:getChildByPath(self, 'btn_paihang')
	self.btn_huodong = TFDirector:getChildByPath(self, 'btn_huodong')
	self.btn_import_huodong = TFDirector:getChildByPath(self, 'btn_import_huodong')

	self.btnTimeLimitMall = self.btn_import_huodong:clone()
	self.btnTimeLimitMall:setTextureNormal("ui_new/home/main_xinhuodong1.png")
	self.btn_import_huodong:getParent():addChild(self.btnTimeLimitMall)

	self.btn_zaixian = TFDirector:getChildByPath(self, 'btn_zaixian')
	self.txt_time 	 = TFDirector:getChildByPath(self, 'txt_onlinetime')
	self.btn_friends 	 = TFDirector:getChildByPath(self, 'btn_friends')
	self.btn_faction	= TFDirector:getChildByPath(self, 'btn_faction')
	self.btn_change	= TFDirector:getChildByPath(self, 'btn_change')
	self.btn_fyl	= TFDirector:getChildByPath(self, 'btn_fyl')
	self.btn_fylXY = self.btn_fyl:getPosition()
	self.btn_daTi  = TFDirector:getChildByPath(self, 'btn_jhyj')
	self.btn_daTi:setVisible(false)
	--self.btn_change	= TFDirector:getChildByPath(self, 'btn_more')
	self.btn_change:setVisible(false)
	self.panel_rightDown	= TFDirector:getChildByPath(self, 'panel_rightDown')
	self.img_change = TFDirector:getChildByPath(self.btn_change, "img_change")
	self.img_change:setTexture(pointerPic[1])


	self.img_di = TFDirector:getChildByPath(self, "img_di")
	self.img_di:setVisible(true)
	self.img_di:setZOrder(-10000)
	self.btn_goldEgg	= TFDirector:getChildByPath(self, 'btn_goldEgg')
	self.btn_xunbao	= TFDirector:getChildByPath(self, 'btn_xunbao')

	self.btn_sevenday = TFDirector:getChildByPath(self, 'sevenday')

	-- self.btn_nextopen = TFDirector:getChildByPath(self, 'btn_nextopen')
	-- self.img_nextopenbg = TFDirector:getChildByPath(self, 'img_nextopenbg')
	-- self.txt_neirong = TFDirector:getChildByPath(self, 'txt_neirong')

	-- self:addNextOpenEffect(self.btn_nextopen)

	self.panel_opennew = TFDirector:getChildByPath(self, "panel_opennew")
	self.img_opennew = TFDirector:getChildByPath(self, "img_opennew")
	self.txt_newopen = TFDirector:getChildByPath(self, "txt_newopen")
	self.txt_openlevel = TFDirector:getChildByPath(self, "txt_openlevel")
	self.btn_opennew = TFDirector:getChildByPath(self, "btn_opennew")
	self.btnLimitExchange = TFDirector:getChildByPath(self, "btn_limitExchange")
	self.btn_starhero = TFDirector:getChildByPath(self, 'btn_mingrentang')
	self.btn_fcm 			= TFDirector:getChildByPath(self, "btn_fcm")
	self.img_fcm			= TFDirector:getChildByPath(self.btn_fcm, "img_fcm")

	self.btn_opennew.initPos = self.btn_opennew:getPosition()

	self.img_chaungguanling = TFDirector:getChildByPath(self, 'img_res_bg_1')
	self.img_tongbi 	 	= TFDirector:getChildByPath(self, 'img_res_bg_2')
	self.img_yuanbao 	 	= TFDirector:getChildByPath(self, 'img_res_bg_3')
	
	self.img_qipao		= TFDirector:getChildByPath(self, 'img_qipao')

	self.btn_chat:setClickAreaLength(100);
	self.setingBtn:setClickAreaLength(100);
	self.infoBtn:setClickAreaLength(100);
	self.btn_buytime:setClickAreaLength(100);
	self.btn_buycion:setClickAreaLength(100);
	self.btn_buysycee:setClickAreaLength(100);
	self.btn_youfang:setTextureNormal("")

	self.btn_knight = self.btn_zaixian:clone()
	self.btn_knight:stopAllActions()
	self.btn_knight:setTextureNormal("ui_new/home/main_langren.png")
	self.ui:addChild(self.btn_knight, 999)
	self.btn_knight:setVisible(false)
	--添加2144社区按钮
	self.cmt2144Btn = self.btn_starhero:clone()
	self.btn_starhero:getParent():addChild(self.cmt2144Btn,999)
	self.cmt2144Btn:stopAllActions()
	self.cmt2144Btn:setTextureNormal("ui_new/home/main_yxsq.png")
	self.cmt2144Btn:setVisible(false)
	-- 添加开服大礼
	self.btn_kfdl = self.btn_weixin:clone()
	self.btn_kfdl:stopAllActions()
	self.btn_kfdl:setTextureNormal("ui_new/home/main_kfdl.png")
	self.ui:addChild(self.btn_kfdl)
	self.btn_kfdl:setVisible(false)
	--添加返利转盘按钮
	self.btn_flzp = self.btn_weixin:clone()
	self.btn_flzp:stopAllActions()
	self.btn_flzp:setTextureNormal("ui_new/home/main_flzp.png")
	self.ui:addChild(self.btn_flzp)
	self.btn_flzp:setVisible(false)

	--琅环btn
	self.btn_langHuan = self.btn_weixin:clone()
	self.btn_langHuan:stopAllActions()
	self.btn_langHuan:setTextureNormal("ui_new/home/main_lhfd.png")
	self.ui:addChild(self.btn_langHuan)
	self.btn_langHuan:setVisible(false)
	-- self.btn_gonglue:getParent():addChild(self.btn_langHuan)
    
    --周年庆btn
	self.btn_zhouNianQing = self.btn_weixin:clone()
	self.btn_zhouNianQing:stopAllActions()
	self.btn_zhouNianQing:setTextureNormal("ui_new/home/main_cjhd.png")
	self.ui:addChild(self.btn_zhouNianQing)
	self.btn_zhouNianQing:setVisible(false)
	 --至尊金卡
	self.btn_goldenCard = self.btn_gonglue:clone()
	self.btn_goldenCard:setTextureNormal("ui_new/home/main_zzjk.png")
	self.btn_goldenCard:setVisible(false)
	self.btn_gonglue:getParent():addChild(self.btn_goldenCard)

	--添加赶年兽
	self.btn_gns = self.btn_gonglue:clone()
	self.btn_gns:setTextureNormal("ui_new/home/main_gns.png")
	self.btn_gns:setVisible(false)
	self.btn_gonglue:getParent():addChild(self.btn_gns)

	--添加打年兽
	self.btn_dns = self.btn_gonglue:clone()
	self.btn_dns:setTextureNormal("ui_new/home/main_dns.png")
	self.btn_dns:setVisible(false)
	self.btn_gonglue:getParent():addChild(self.btn_dns)
  	
  	-- 步步高升（江湖聚惠）
    self.btn_jhjh = self.btn_gonglue:clone()
    self.btn_jhjh:setTextureNormal("ui_new/home/main_jhjh.png")
    self.btn_jhjh:setVisible(false)
    self.btn_gonglue:getParent():addChild(self.btn_jhjh)
	
	self.btn_list = {
		self.btn_pay,
		self.btn_yueka,
		self.btn_firstpay,
		self.btn_weixin,
		self.btn_vip,
		self.btn_goldEgg,
		self.btn_xunbao,
		self.btn_longmenpo,
		self.btn_tianjilun,
		self.btn_youfang,
		self.btn_sevenDayPower,
		self.btn_import_huodong,
		self.btn_gonglue,
		self.btn_down,
		self.btn_sevenDayRank,
		self.btnTimeLimitMall,
		self.btn_knight,
		self.btnLimitExchange,
		self.btn_starhero,
		self.btn_murenzhuang,
		self.btn_fcm,
		self.cmt2144Btn,
		self.btn_flzp,
		self.btn_kfdl ,
		self.btn_langHuan ,
		self.btn_zhouNianQing,
		self.btn_goldenCard,
		self.btn_gns,
		self.btn_dns,
		self.btn_jhjh,
	}
	self.btn_youfang:setVisible(false)
	self.btn_gonglue:setVisible(false)
	self.btn_longmenpo:setVisible(false)
	self.btn_tianjilun:setVisible(false)
	self.btnTimeLimitMall:setVisible(false)
	self.btnLimitExchange:setVisible(false)
	self.btn_starhero:setVisible(false)
	self.btn_murenzhuang:setVisible(false)
	-- local resetPosY = self.btn_list[1]:getPositionY()
	-- for i=1,#self.btn_list do
	-- 	self.btn_list[i]:setPositionY(resetPosY)
	-- end

	if SettingManager:getFCMServerSwitch() == false or SettingManager.getReward == 1 then
		self.btn_fcm:setVisible(false)
	else
		self.btn_fcm:setVisible(true)
	end
	-- self.btn_list[4]:setVisible(false)
	self.btn_list_pos = (self.btn_pay:getPositionX() -  self.btn_pay:getContentSize().width/2)
	self.leftDownBtnList = {
		self.roleBtn,
		self.equipBtn,
		self.bagBtn,
		self.mallBtn,
		self.zhaomuBtn,
		self.taskBtn,
		self.btn_friends,
		self.btn_faction,
		self.btn_paihang,
		self.btn_employ,
		self.btn_eudemon,
	}
	self.leftDownPage = 1
	-- for i=1,#self.leftDownBtnList do
	for i,downBtn in ipairs(self.leftDownBtnList) do
		downBtn:setAnchorPoint(ccp(0.5,0.5))

		downBtn:setPositionY(downBtn:getPositionY()+downBtn:getContentSize().height/2 )
		
		downBtn.isOpen = false
	end
	self.leftDownBtnList_pos = 10
	self.leftDownBtnList_pos_y1 = 20
	self.leftDownBtnList_pos_y2 = 170

	self.rightMiddleBtnList = {}
	-- self.rightMiddleBtnList[1] = self.dailyTaskBtn
	self.rightMiddleBtnList[1] = self.qiyuBtn
	self.rightMiddleBtnList[2] = self.btn_huodong
	self.rightMiddleBtnList[3] = self.btn_wulin

	self.rightMiddleBtnList_pos = self.rightMiddleBtnList[1]:getPositionY() + self.rightMiddleBtnList[1]:getContentSize().height/2


	--公告框
	local function update(delta)
		if self.timeId then
			TFDirector:removeTimer(self.timeId)
			self.timeId = nil
		end
		if PlayerGuideManager:IsGuidePanelVisible() == false then
			-- CommonManager:openSecondDayDrawing()
			-- CommonManager:openFirstDrawing()
			CommonManager:openWeixinDrawing()
			CommonManager:openEverydayNotice()
			CommonManager:openEverydayHaiBao()
		end
		-- if QiyuManager:IsSignToday() and QiyuManager:SignIsOpen() then
		-- 	QiyuManager:OpenSignLayer()
		-- end
		if MainPlayer:getLevel() > 1 then
			CommonManager:openNoticeLayer()
		end
		if (MainPlayer:getServerSwitchStatue(ServerSwitchType.KaiFuDaLi) == true) then
			CommonManager:openKaiFuDaLiLayer()
		end
	end
	-- self.timeId = me.Scheduler:scheduleScriptFunc(update, 0.5, false)
	self.timeId = TFDirector:addTimer(500, 1, nil, update)
	
	TFDirector:stopTimer(self.timeId)
	-- update(0)

	self.timeCount = 0
	self.onlineRewardCount = 0
	self.btn_zaixian:setVisible(false)

	-- local function loginOutCallBack()
	-- 	TFSdk:setLoginOutCallBack(nil)

	-- 	SettingManager:gotoLoginLayer()
	-- end

	-- -- 离开游戏 注销 
	-- if not TFSdk:getSdkName() then
	-- 	self.btn_friends:setVisible(false)
	-- else
	-- 	TFSdk:setLoginOutCallBack(loginOutCallBack)
	-- 	TFSdk:setLeavePlatCallBack(nil)
	-- end

	-- self.btn_friends:setVisible(false)
	-- if TFSdk:getSdkName() == "pp" then
	-- 	self.btn_friends:setVisible(true)
	-- end

	-- if TFPlugins.getChannelId() ~= "" and TFPlugins.isLogined() == true then
	if TFPlugins.isPluginExist() and TFPlugins.isLogined() == true then
		TFPlugins.showToolBar(ToolBarPlace.kToolBarBottomLeft)
	end

	if HeitaoSdk then
		HeitaoSdk.ShowFunctionMenu(true)
	end

	--添加玩家回归活动按钮
	self.playerBackBtn = self.btn_sevenday:clone()
	self.btn_sevenday:getParent():addChild(self.playerBackBtn)
	self.playerBackBtn:setPosition(self.btn_sevenday:getPosition())
	self.playerBackBtn:setTextureNormal("ui_new/home/icon_huigui.png")

	-- self:refreshUIPayBtn()
	self:refreshZhengbaBtn()
	-- --self:showChatBubble()

	self.panel_bg1 = TFDirector:getChildByPath(ui, "panel_bg_1")
	self.bg_move = {}
	self.initBgPos = {}
	self.curPos = {}
	self.antiState = 0
	for i = 1, 4 do
		self.bg_move[i] = TFDirector:getChildByPath(self.panel_bg1, "img_" .. i)
		self.initBgPos[i] = self.bg_move[i]:getPosition()
		self.curPos[i] = self.bg_move[i]:getPosition()
	end

	self.leftPanelPosX = TFDirector:getChildByPath(self.ui, 'Panel_MenuLayer_1'):getPositionX()

	-- self:addMainBgEffect()

	if not menuInFirst then
		Public:preloadLayerChangeEffect()
		menuInFirst = true
	end

	-- Public:addDownBtnEffect(self.btn_down)
	self.canPowerEffect = 2

	local tiaoBg = TFImage:create("ui_new/home/ZJM_dixiafang.png")
	tiaoBg:setPosition(ccp(0,0))
	tiaoBg:setAnchorPoint(ccp(0,0))
	self.ui:addChild(tiaoBg)
	self:AddBgImgEffect()
end

-- function MenuLayer:addNextOpenEffect(btn)
-- 	local effectName = "btn_wenhao"
-- 	TFResourceHelper:instance():addArmatureFromJsonFile("effect/" .. effectName .. ".xml")
-- 	local effect = TFArmature:create(effectName .. "_anim")
-- 	if effect ~= nil then
-- 		effect:setAnimationFps(GameConfig.ANIM_FPS)
-- 		effect:playByIndex(0, -1, -1, 1)
-- 		btn:addChild(effect)
-- 	end
-- end

function MenuLayer:addMainBgEffect()
	self.bg_move = self.bg_move or {}

	--春节主场景不要main_bg_1的光
	for i = 2, 4 do
		local effectName = "main_bg_" .. i
		
		local resPathXML = "effect/ui/mainbg/" .. effectName .. ".xml"
		local resPathAlats = "effect/ui/mainbg/" .. effectName .. ".atlas"
		local effect
		if TFFileUtil:existFile(resPathAlats) then		
			TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/mainbg/" .. effectName .. ".atlas")
			local resPath = "effect/ui/mainbg/" .. effectName
			effect = SkeletonAnimation:create(resPath)
		elseif TFFileUtil:existFile(resPathXML) then		
			TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/mainbg/" .. effectName .. ".xml")
			effect = TFArmature:create(effectName .. "_anim")
		end
		
		if effect ~= nil then
			effect:setAnimationFps(GameConfig.ANIM_FPS)
			effect:playByIndex(0, -10, -10, 1)
			effect:setZOrder(11)
			local size = self.bg_move[i]:getSize()
			effect:setPosition(ccp(0, 0))
			self.bg_move[i]:addChild(effect)
			self.bg_move[i].effect = effect
		end
	end
end


function MenuLayer:refreshBtnList()
	local num = 0
	local pos_x = self.btn_list_pos
	for i=1,#self.btn_list do
		if self.btn_list[i]:isVisible() then
			pos_x = pos_x + self.btn_list[i]:getContentSize().width/2
			self.btn_list[i]:setPositionX(pos_x)-- , pos_y + self.btn_list[i]:getContentSize().height/2) )
			pos_x = pos_x + self.btn_list[i]:getContentSize().width/2
			if num >= 6 then
				self.btn_list[i]:setPositionY(self.btn_list[1]:getPositionY()-80)
			else
				self.btn_list[i]:setPositionY(self.btn_list[1]:getPositionY())
			end
			if self.btn_list[i] == self.btn_down then
				local tempX = self.btn_list[i]:getPositionX()
				local tempY = self.btn_list[i]:getPositionY()
				self.btn_list[i]:setPositionX(tempX + 4)
				self.btn_list[i]:setPositionY(tempY - 3)
			end
			num = num + 1
			if num == 6 then
				pos_x = self.btn_list_pos
			end
		end
	end
end

--added by wuqi
function MenuLayer:addVipEffect(btn)
    if btn.effect then
        btn.effect:removeFromParent()
        btn.effect = nil
    end
    local vipLevel = MainPlayer:getVipLevel()
    if vipLevel <= 15 or vipLevel > 18 then
        return
    end
    local resPath = "effect/ui/vip_" .. vipLevel .. ".xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create("vip_" .. vipLevel .. "_anim")
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    effect:setPosition(ccp(btn:getContentSize().width / 2, btn:getContentSize().height / 2))
    effect:setVisible(true) 
    effect:setScale(0.8)
    effect:playByIndex(0, -1, -1, 1)
    btn:addChild(effect, 200)
    btn.effect = effect
end

function MenuLayer:refreshLeftDownBtnList()
	local num = 0
	local pos_x = self.leftDownBtnList_pos
	local pos_y = self.leftDownBtnList_pos_y1
	local isFirst = true
	for i=1,#self.leftDownBtnList do
		if self.leftDownBtnList[i].isOpen == true then
			num = num + 1
			self.leftDownBtnList[i]:setVisible(true)
			
			if self.leftDownPage == 1 and num > 5 then
				self.leftDownBtnList[i]:setVisible(false)
			else
				pos_x = pos_x + self.leftDownBtnList[i]:getContentSize().width/2
				self.leftDownBtnList[i]:setPositionX( pos_x )
				self.leftDownBtnList[i]:setPositionY( pos_y )
				pos_x = pos_x + self.leftDownBtnList[i]:getContentSize().width/2
				if num >= 5 and isFirst then
					--pos_x = -280
					pos_x = -50
					pos_y = self.leftDownBtnList_pos_y2
					isFirst = false
				end
			end

			if self.leftDownBtnList[i] == self.taskBtn then
				if num > 5 then
					self.taskBtn:setTextureNormal(chengjiuBtnPic[2])
				else
					self.taskBtn:setTextureNormal(chengjiuBtnPic[1])
				end
			end

			if self.leftDownBtnList[i] == self.btn_paihang then
				if num > 5 then
					self.btn_paihang:setTextureNormal(paihangBtnPic[2])
				else
					self.btn_paihang:setTextureNormal(paihangBtnPic[1])
				end
			end

			if self.leftDownBtnList[i] == self.btn_friends then
				if num > 5 then
					self.btn_paihang:setTextureNormal(friendBtnPic[2])
				else
					self.btn_paihang:setTextureNormal(friendBtnPic[1])
				end
			end
		else
			self.leftDownBtnList[i]:setVisible(false)
		end
	end
	local panel = TFDirector:getChildByPath(self.ui, 'Panel_MenuLayer_1')
	panel:setPositionY(30)
	if num > 5 then
		self.btn_change:setVisible(true)
		panel:setPositionX(self.leftPanelPosX)
	else
		self.btn_change:setVisible(false)
		panel:setPositionX(self.leftPanelPosX - 90)
	end
	if self.leftDownPage == 1 then
		self.img_di:setVisible(false)
	else
		self.img_di:setVisible(true)
	end
	self:updateChangeBtnRedPoint()
end
function MenuLayer:refreshRightMiddleBtnList()
	local num = 0
	local pos_y = self.rightMiddleBtnList_pos 
	for i=1,#self.rightMiddleBtnList do
		if self.rightMiddleBtnList[i]:isVisible() then
			pos_y = pos_y - self.rightMiddleBtnList[i]:getContentSize().height/2
			self.rightMiddleBtnList[i]:setPositionY( pos_y )
			pos_y = pos_y - self.rightMiddleBtnList[i]:getContentSize().height/2
			num = num + 1
		end
	end

	if FunctionOpenConfigure:isFuctionOpen(1001) then
		self.dailyTaskBtn:setVisible(true)
	else
		self.dailyTaskBtn:setVisible(false)
	end

	local verLock = VersionLockData:objectByID(EnumVersionLockType.WuLin_Lock)
    if verLock and verLock.open == 0 then
        self.btn_wulin:setVisible(false)
    end
end



function MenuLayer:refreshUIPayBtn()

	self.btn_firstpay:setVisible(false)

	if PayManager:IsUserFirstPay() == true then
		self.btn_firstpay:setVisible(true)
    end

    if PayManager:getFirstChargeState() then
 		self.btn_firstpay:setVisible(true)
    end
    self.btn_vip:setVisible(false)
   
    if ((PayManager:IsFirstPayMore(198) or PayManager:getTotalRecharge() >= 1000) or PayManager.IsAuthenticateUser == true) then
		-- print("PayManager:getTotalRecharge() = ",PayManager:getTotalRecharge())
		-- self.btn_vip:setVisible(true)
		self.btn_vip:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.VipIcon))
    end

    CommonManager:setRedPoint(self.btn_firstpay, PayManager:isOpenFirstPay() or PayManager:getFirstChargeState(),"getFirstChargeState",ccp(0,0))

    self:refreshBtnList()
end

function MenuLayer:onShow()
	self.super.onShow(self)
	if not self.isShow then
        return;
    end

	self.canPowerEffect = self.canPowerEffect - 1
	print('---------------------onShow---------------->>>>222')

	self.panel_rightDown:setPositionX(0)
	self:delayedLoad("showDelayTimer_1", self.onShowDelayedLoad)
end


function MenuLayer:onShowDelayedLoad(loadCount, loadTime)
	-- local xx = os.clock()
	-- TFLuaTime:begin()
	local function checkRedPacketState()
		if CommonManager:checkLoginCompleteState() then
			PlayerGuideManager:doGuide()
			if (self.timeId) then
				TFDirector:startTimer(self.timeId)
			end
		end
		
		hideAllLoading();
		KingOfWarManager:checkRedPacketState(self)
		local function cb()
			TFDeviceInfo:setOpenAccelerometer(true)
		end
		local acArr = TFVector:create()
		local delayAc = CCDelayTime:create(0.1)
		local callFunc = CCCallFunc:create(cb)
		acArr:addObject(delayAc)
		acArr:addObject(callFunc)
		self:runAction(CCSequence:create(acArr))
	end
	local loadFuncList = 
	{
		self.refreshActivityBubbles,
		
		self.refreshUI,
		self.refreshTaskInfo,
		self.refreshZhengbaBtn,
		self.onShowRefresPower,
		checkRedPacketState,
		self.refreshUIPayBtn,
		self.refreshReward,
		self.refreshIslandRed,
		self.knightBtnShow,
		self.refreshBaseUI,
	}
	local tb = TFLuaTime:clock()
	if (loadCount <= #loadFuncList) then
		local func = loadFuncList[loadCount]
		if (func) then
			func(self)	
			loadCount = loadCount + 1
		end
	else
		loadCount = -1
	end
	loadTime = loadTime + (TFLuaTime:clock() - tb)
	-- print(loadCount, "   BBBBBBBBBBBBBBBBBBBB    ",loadTime)
	return loadCount, loadTime
end

function MenuLayer:onShowRefresPower()
	if CommonManager:checkLoginCompleteState() == false and CardRoleManager.freshLock == false then
		CommonManager:setLoginCompleteState( true )
		CardRoleManager:refreshAllRolePower()
		CardRoleManager:reSortStrategy();
	end

end
function MenuLayer:refreshReward()
	self.panel_1:setVisible(false);
	local currentmission_1 = MissionManager:getCurrentMission(1);
	local currentmission_2 = MissionManager:getCurrentMission(2);
	local missionId_1 = MissionManager:getSpecialDropStarNextMissionId(1,currentmission_1.id);
	local missionId_2 = MissionManager:getSpecialDropStarNextMissionId(2,currentmission_2.id);
	local specialDropList;
	for i = 1,2 do
		if i == 1 then 
			specialDropList = MissionManager:getSpecialDropList(i)
			if next(specialDropList) ~= nil then
				for specialDropMission in specialDropList:iterator() do
					if not missionId_1 or missionId_1 > specialDropMission.id then
						missionId_1 = specialDropMission.id
						break;
					end
				end
			end
		else
			specialDropList = MissionManager:getSpecialDropList(i)
			if next(specialDropList) ~= nil then
				for specialDropMission in specialDropList:iterator() do
					if not missionId_2 or missionId_2 > specialDropMission.id then
						missionId_2 = specialDropMission.id
						break;
					end
				end
			end
		end
	end
	local showFlag,missionId,mission
	if (not missionId_1) and (not missionId_2) then
		showFlag = nil;
	elseif missionId_1 and (not missionId_2) then
		missionId = missionId_1;
		showFlag = 1;
	elseif (not missionId_1) and missionId_2 then
		missionId = missionId_2;
		showFlag = 1;
	elseif missionId_1 and missionId_2 then
		showFlag = 1;
		local mission_1 =	MissionManager:getMissionById(missionId_1);
		local mission_2 =	MissionManager:getMissionById(missionId_2);
		if mission_1.mapid > (mission_2.mapid - 1000) then
			missionId = missionId_2;
		elseif mission_1.mapid < (mission_2.mapid - 1000) then
			missionId = missionId_1;
		elseif mission_1.mapid == (mission_2.mapid - 1000) then
			if math.abs(mission_1.stageid - currentmission_1.stageid) > math.abs(mission_2.stageid - currentmission_2.stageid)then
				missionId = missionId_2;
			elseif math.abs(mission_1.stageid - currentmission_1.stageid) < math.abs(mission_2.stageid - currentmission_2.stageid) then
				missionId = missionId_1;
			elseif math.abs(mission_1.stageid - currentmission_1.stageid) == math.abs(mission_2.stageid - currentmission_2.stageid) then
				missionId = missionId_1;
			end
		end
	end

	if showFlag then
		self.panel_1:setVisible(true);
		local specialDropBase = MissionManager:getSpecialDropItemByMissionId(missionId)
		if specialDropBase then 
    		local specialDrop = BaseDataManager:getReward({itemId = tonumber(specialDropBase[2]),type = tonumber(specialDropBase[1]),number = tonumber(specialDropBase[3])})
			local img_bg  = TFDirector:getChildByPath(self.panel_1, 'img_bg');
    		local txt_1   = TFDirector:getChildByPath(self.panel_1, 'txt_1');
    		local btn_iconjump  = TFDirector:getChildByPath(self.panel_1, 'btn_iconjump');
			btn_iconjump:setTextureNormal(GetColorIconByQuality(specialDrop.quality));
			mission =	MissionManager:getMissionById(missionId);
			local mapid = mission.mapid;
			local getReward = localizable.getRewardWordDifficulty0;
			if mapid > 1000 then
				mapid = mapid - 1000;
				getReward = localizable.getRewardWordDifficulty1;
			end
			txt_1:setText(stringUtils.format(getReward, mapid , mission.stageid));
    		local img_icon  = TFDirector:getChildByPath(self.panel_1, 'img_icon');
			local txt_num1  = TFDirector:getChildByPath(self.panel_1, 'txt_num1');
			local txt_num2  = TFDirector:getChildByPath(self.panel_1, 'txt_num2');
			txt_num1:setVisible(false);
			txt_num2:setText(specialDrop.number);
    		img_icon:setTexture(specialDrop.path);
    		btn_iconjump.self = self;
    		btn_iconjump:addMEListener(TFWIDGET_CLICK,audioClickfun(function() 
			local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.mission.MissionLayer");
    			layer:loadData(missionId,1);
    			AlertManager:show();
			end));
		else
			self.panel_1:setVisible(false);
		end
	end

	-- 添加主界面显示时间限制
	if self.panel_1:isVisible() and (MainPlayer:getLevel() < mission.reqiure_level) then
		local nowTimes = MainPlayer:getNowtime()
		local loginTimes = MainPlayer:getLogintime()
		if (nowTimes - 10) > loginTimes then
			self.panel_1:setVisible(false);
		else
			self.panel_1:setVisible(true);
			if self.addpanel_1Time then
				TFDirector:removeTimer(self.addpanel_1Time)
				self.addpanel_1Time = nil
			end
			self.addpanel_1Time = TFDirector:addTimer((loginTimes + 10 - nowTimes)*1000, 1, nil, 
			function() 
				if self.panel_1 then
					self.panel_1:setVisible(false);
				end
				TFDirector:removeTimer(self.addpanel_1Time)
				self.addpanel_1Time = nil
			end)
		end
	end
end

function MenuLayer:refreshBaseUI(isOnlyResource)
    local currentScene = Public:currentScene()
    -- if currentScene ~= nil and currentScene.getTopLayer and currentScene:getTopLayer() and currentScene:getTopLayer().__cname == "MenuLayer" then
    	if isOnlyResource == nil then
			isOnlyResource = false
		end
		print("MenuLayer:refreshBaseUI==========>>>>>>>>>")
		local times = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.PUSH_MAP);
	    self.txt_tilipoint:setText(times:getLeftChallengeTimes()  .. "/" .. times.maxValue);
	    self.txt_tongbipoint:setText(MainPlayer:getResValueExpressionByType(EnumDropType.COIN))
	    self.txt_yuanbaopoint:setText(MainPlayer:getResValueExpressionByType(EnumDropType.SYCEE))
	    self:setInfo()
	    if isOnlyResource == true and self.isLoadRoleList == false then
	    	return
	    end
	    self.isLoadRoleList = false
		self:InitRoleList()
    -- end
end

function MenuLayer:checkRedPointByKey( key, currTime )
	if self.checkRedPoint[key] == nil then
		self.checkRedPoint[key] = {}
		self.checkRedPoint[key].refreshTime = currTime + 5000
		return true
	end
	if self.checkRedPoint[key].refreshTime > currTime then
		return true
	end
	return false
end

function MenuLayer:refreshUI()
    if not self.isShow then
        return;
    end
    print(" ------------- MenuLayer:refreshUI")
    local currTime = MainPlayer:getNowtime()
    self.btn_yueka:setVisible(QiyuManager:MonthCardIsOpen())

	self.qiyuBtn:setVisible(QiyuManager:QiyuFuctionIsOpen())

    self.btn_zaixian:setVisible(QiyuManager:ActivityFuctionOnlineReward())
    self.btn_huodong:setVisible(QiyuManager:ActivityFuctionIsOpen())

    -- if QiyuManager:ActivityFuctionOnlineReward() then
    -- 	self.btn_zaixian:setVisible(not OperationActivitiesManager:isGetAllOnlineReward())
    -- end

    -- if OperationActivitiesManager:ActivitgIsOpen(EnumActivitiesType.ONLINE_REWARD_NEW) then
    if OperationActivitiesManager:ActivityOnlineIsOpen() then
		self.btn_zaixian:setVisible(not OperationActivitiesManager:AllOnlineRewardIsReceived())

	else
		self.btn_zaixian:setVisible(false)
	end

	if SettingManager:getFCMServerSwitch() == false or SettingManager.getReward == 1 then
		self.btn_fcm:setVisible(false)
	else
		self.btn_fcm:setVisible(true)
	end

	local activityIndex1, activityNum1 = OperationActivitiesManager:getOpenAndShowActivityList(2)
	if activityNum1 == 0 then
		self.btnTimeLimitMall:setVisible(false)
	else
		self.btnTimeLimitMall:setVisible(true)
	end

	if CommonManager:checkRedPointByKey("equipBtnRedPoint",currTime) then
		local redPointState = EquipmentManager:checkPVEStrategyEquip()
		CommonManager:setRedPointStateByKey( "equipBtnRedPoint", redPointState )
		CommonManager:setRedPoint(self.equipBtn, redPointState,"equipBtnRedPoint",ccp(0,0))
	end
	
	if CommonManager:checkRedPointByKey("bagBtnRedPoint",currTime) then
		local redPointState = BagManager:checkBagRedPoint()
		if (redPointState) then
			redPointState = BagManager:isBagRedPoint()
		end
		CommonManager:setRedPointStateByKey( "bagBtnRedPoint", redPointState )
		CommonManager:setRedPoint(self.bagBtn, redPointState,"bagBtnRedPoint",ccp(0,0))
	end

	-- CommonManager:setRedPoint(self.taskBtn, TaskManager:isCanGetRewardForType(1),"isCanGetRewardForType",ccp(0,0))
	if CommonManager:checkRedPointByKey("taskBtnRedPoint",currTime) then
		local redPointState = TaskManager:isCanGetRewardForType(1)
		CommonManager:setRedPointStateByKey( "taskBtnRedPoint", redPointState )
		CommonManager:setRedPoint(self.taskBtn, redPointState,"taskBtnRedPoint",ccp(0,0))
	end


	-- 日常添加等级判断
	if FunctionOpenConfigure:isFuctionOpen(1001) then
		-- CommonManager:setRedPoint(self.dailyTaskBtn, TaskManager:isCanGetRewardForType(0),"isCanGetRewardForType",ccp(0,0))
		if CommonManager:checkRedPointByKey("dailyTaskBtnRedPoint",currTime) then
			local redPointState = TaskManager:isCanGetRewardForType(0)
			CommonManager:setRedPointStateByKey( "dailyTaskBtnRedPoint", redPointState )
			CommonManager:setRedPoint(self.dailyTaskBtn, redPointState,"dailyTaskBtnRedPoint",ccp(0,0))
		end	
	end

	-- CommonManager:setRedPoint(self.zhaomuBtn, GetCardManager:isHaveGetCardFree(),"isHaveGetCardFree",ccp(0,0))
	if CommonManager:checkRedPointByKey("isHaveGetCardFree",currTime) then
		local redPointState = GetCardManager:isHaveGetCardFree() or GetCardManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "isHaveGetCardFree", redPointState )
		CommonManager:setRedPoint(self.zhaomuBtn, redPointState,"isHaveGetCardFree",ccp(0,0))
	end	
	-- CommonManager:setRedPoint(self.zhaomuBtn, QiYuanManager:isHaveQiYuanFree(),"isHaveQiYuanFree",ccp(0,0))
	if CommonManager:checkRedPointByKey("isHaveQiYuanFree",currTime) then
		local redPointState = QiYuanManager:isHaveQiYuanFree()
		CommonManager:setRedPointStateByKey( "isHaveQiYuanFree", redPointState )
		CommonManager:setRedPoint(self.zhaomuBtn, redPointState,"isHaveQiYuanFree",ccp(0,0))
	end
	-- print("MallManager.bFirstOpen===============>>",MallManager.bFirstOpen)
	if MallManager.bFirstOpen then
		CommonManager:setRedPoint(self.mallBtn, true,"bFirstOpen",ccp(0,0))
	else
		CommonManager:setRedPoint(self.mallBtn, false,"bFirstOpen",ccp(0,0))
	end

	-- CommonManager:setRedPoint(self.infoBtn, NotifyManager:isHaveUnReadMail(),"isHaveUnReadMail",ccp(0,0))
	if CommonManager:checkRedPointByKey("isHaveUnReadMail",currTime) then
		local redPointState = NotifyManager:isHaveUnReadMail()
		CommonManager:setRedPointStateByKey( "isHaveUnReadMail", redPointState )
		CommonManager:setRedPoint(self.infoBtn, redPointState,"isHaveUnReadMail",ccp(0,0))
	end
	-- CommonManager:setRedPoint(self.btn_chat, ChatManager:isHaveNewChat(),"isHaveNewChat",ccp(0,0))
	if CommonManager:checkRedPointByKey("isHaveNewChat",currTime) then
		local redPointState = ChatManager:isHaveNewChat()
		CommonManager:setRedPointStateByKey( "isHaveNewChat", redPointState )
		CommonManager:setRedPoint(self.btn_chat, redPointState,"isHaveNewChat",ccp(0,0))
	end

	-- CommonManager:setRedPoint(self.btn_sign, QiyuManager:IsSignToday(),"IsSignToday",ccp(-10,-10))
	if CommonManager:checkRedPointByKey("IsSignToday",currTime) then
		local redPointState = QiyuManager:IsSignToday()
		CommonManager:setRedPointStateByKey( "IsSignToday", redPointState )
		CommonManager:setRedPoint(self.btn_sign, redPointState,"IsSignToday",ccp(-10,-10))
	end

	--CommonManager:setRedPoint(self.btn_yueka, QiyuManager:IsMonthCardCanGet(),"IsMonthCardCanGet",ccp(-10,-10))
	-- CommonManager:setRedPoint(self.btn_yueka, MonthCardManager:IsMonthCardCanGet(),"IsMonthCardCanGet",ccp(-10,0))
	if CommonManager:checkRedPointByKey("IsMonthCardCanGet",currTime) then
		local redPointState = MonthCardManager:IsMonthCardCanGet()
		CommonManager:setRedPointStateByKey( "IsMonthCardCanGet", redPointState )
		CommonManager:setRedPoint(self.btn_yueka, redPointState,"IsMonthCardCanGet",ccp(-10,0))
	end



	-- 布阵红点
	if CommonManager:checkRedPointByKey("isHaveBook",currTime) then
		local redPointState = CardRoleManager:isHaveBook()
		CommonManager:setRedPointStateByKey( "isHaveBook", redPointState )
		CommonManager:setRedPoint(self.roleBtn, redPointState,	"isHaveBook",	ccp(0,0))
	end

	-- CommonManager:setRedPoint(self.qiyuBtn, QiyuManager:isHaveRedPoint(),"isCodeCanGetReward",ccp(0,0))
	if CommonManager:checkRedPointByKey("isCodeCanGetReward",currTime) then
		local redPointState = QiyuManager:isHaveRedPoint()
		CommonManager:setRedPointStateByKey( "isCodeCanGetReward", redPointState )
		CommonManager:setRedPoint(self.qiyuBtn, redPointState,"isCodeCanGetReward",ccp(0,0))
	end		
	

	-- CommonManager:setRedPoint(self.btn_huodong, OperationActivitiesManager:isHaveRewardCanGet(),"OperationActivitiesManager",ccp(0,0))
	if CommonManager:checkRedPointByKey("OperationActivitiesManager",currTime) then
		local redPointState = OperationActivitiesManager:isHaveRewardCanGet(0)
		CommonManager:setRedPointStateByKey( "OperationActivitiesManager", redPointState )
		CommonManager:setRedPoint(self.btn_huodong, redPointState,"OperationActivitiesManager",ccp(0,0))
	end	

	if CommonManager:checkRedPointByKey("OperationActivitiesManager_outside",currTime) then
		local redPointState = OperationActivitiesManager:isHaveRewardCanGet(1)
		CommonManager:setRedPointStateByKey( "OperationActivitiesManager_outside", redPointState )
		CommonManager:setRedPoint(self.btn_import_huodong, redPointState,"OperationActivitiesManager_outside",ccp(0,0))
	end		

	-- 周年庆
	if CommonManager:checkRedPointByKey("btn_zhouNianQing",currTime) then
		local redPointState = AnniversaryManager:isHaveRewardCanGet()
		CommonManager:setRedPointStateByKey( "btn_zhouNianQing", redPointState )
		CommonManager:setRedPoint(self.btn_zhouNianQing, redPointState,"btn_zhouNianQing",ccp(0,0))
	end		
	--至尊金卡
	if CommonManager:checkRedPointByKey("goldenCard",currTime) then
		local redPointState = GoldenCardManager:isRedPoint()
		CommonManager:setRedPointStateByKey( "goldenCard", redPointState )
		CommonManager:setRedPoint(self.btn_goldenCard, redPointState,"goldenCard",ccp(0,0))
	end
	--至尊金卡
	local bShowGoldenCard = GoldenCardManager:isShowGoldenCard()
	self.btn_goldenCard:setVisible(bShowGoldenCard)

	-- CommonManager:setRedPoint(self.btn_sevenday, SevenDaysManager:checkRedPoint(),"isCodeCanGetReward",ccp(0,0))
	if CommonManager:checkRedPointByKey("isCodeCanGetReward1",currTime) then
		local redPointState = SevenDaysManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "isCodeCanGetReward1", redPointState )
		CommonManager:setRedPoint(self.btn_sevenday, redPointState,"isCodeCanGetReward1",ccp(0,0))
	end		

	-- CommonManager:setRedPoint(self.btn_weixin, MainPlayer:getWeixinStatus(),"isCodeCanGetReward",ccp(0,0))
	if CommonManager:checkRedPointByKey("btn_weixin",currTime) then
		local redPointState = MainPlayer:getWeixinStatus()
		CommonManager:setRedPointStateByKey( "btn_weixin", redPointState )
		CommonManager:setRedPoint(self.btn_weixin, redPointState,"btn_weixin",ccp(0,0))
	end		

	-- CommonManager:setRedPoint(self.btn_friends, FriendManager:isShowRedPoint(), "isShowRedPoint", ccp(0,0))
	if CommonManager:checkRedPointByKey("btn_friends",currTime) then
		local redPointState = FriendManager:isShowRedPoint()
		CommonManager:setRedPointStateByKey( "btn_friends", redPointState )
		CommonManager:setRedPoint(self.btn_friends, redPointState,"btn_friends",ccp(0,0))
	end		
	if CommonManager:checkRedPointByKey("btn_youli",currTime) then
		local redPointState = AdventureManager:isShowRedPoint()
		CommonManager:setRedPointStateByKey( "btn_youli", redPointState )
		CommonManager:setRedPoint(self.btn_youli, redPointState,"btn_youli",ccp(0,0))
	end
	
	if CommonManager:checkRedPointByKey("btn_eudemon",currTime) then
		local redPointState = EudemonManager:isShowRedPoint()
		CommonManager:setRedPointStateByKey( "btn_eudemon", redPointState )
		CommonManager:setRedPoint(self.btn_eudemon, redPointState,"btn_eudemon",ccp(0,0))
	end		

	-- CommonManager:setRedPoint(self.btn_faction, FactionManager:canViewRedPointInMainLayer(), "isFactionRedPoint", ccp(0,0))
	if CommonManager:checkRedPointByKey("btn_faction",currTime) then
		local redPointState = FactionManager:canViewRedPointInMainLayer() or GuildBossManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "btn_faction", redPointState )
		CommonManager:setRedPoint(self.btn_faction, redPointState,"btn_faction",ccp(0,0))
	end		

	-- CommonManager:setRedPoint(self.pvpBtn, MiningManager:redPoint(), "MiningManager", ccp(0,0))
	if CommonManager:checkRedPointByKey("pvpBtn",currTime) then
		local redPointState = MiningManager:redPoint()
		CommonManager:setRedPointStateByKey( "pvpBtn", redPointState )
		CommonManager:setRedPoint(self.pvpBtn, redPointState,"pvpBtn",ccp(0,0))
	end		

	if CommonManager:checkRedPointByKey("btn_fcm",currTime) then
		local redPointState = SettingManager.AntiaddictionCode == SettingManager.AntiCode_None or ( SettingManager.AntiaddictionCode == SettingManager.AntiCode_Adult and SettingManager.getReward == 0 )
		CommonManager:setRedPointStateByKey( "btn_fcm", redPointState )
		CommonManager:setRedPoint(self.btn_fcm, redPointState,"btn_fcm",ccp(0,0))
	end
	if CommonManager:checkRedPointByKey("peakHaveTimes",currTime) then
		local redPointState = PeakManager:checkRedPoint() or HeroMeetingManager:getRedPointState()
		CommonManager:setRedPointStateByKey( "peakHaveTimes", redPointState )
		CommonManager:setRedPoint(self.btn_wulin, redPointState,"peakHaveTimes",ccp(0,0))
	end
	-- CommonManager:setRedPoint(self.playerBackBtn, PlayBackManager:checkRedPoint(),"isCodeCanGetReward",ccp(0,0))
	if CommonManager:checkRedPointByKey("playerBackBtn",currTime) then
		local redPointState = PlayBackManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "playerBackBtn", redPointState )
		CommonManager:setRedPoint(self.playerBackBtn, redPointState,"playerBackBtn",ccp(0,0))
	end		
	-- self:refreshUIPayBtn()
	self:refreshBtnVisible()

	self.btn_sevenday:setVisible(true)

	if SevenDaysManager:sevenDaysOpenSatus() == 0 then
		self.btn_sevenday:setVisible(false)
	end

	if PlayBackManager:playerBackOpenSatus() == false then
		self.playerBackBtn:setVisible(false)
	else
		self.playerBackBtn:setVisible(true)
		self.btn_sevenday:setVisible(false)
	end
	if MainPlayer:getServerSwitchStatue(ServerSwitchType.Comminuty_2144) == true then
		self.cmt2144Btn:setVisible(true)
	else
		self.cmt2144Btn:setVisible(false)
	end
		
	--self.btn_sevenday:setVisible(false)
	--self.playerBackBtn:setVisible(true)

	self:refreshBuffEffectShow()

	-- CommonManager:setRedPoint(self.btn_goldEgg, GoldEggManager:isRedPoint(), "isGoldEggRedPoint", ccp(0,0))
	if CommonManager:checkRedPointByKey("btn_goldEgg",currTime) then
		local redPointState = GoldEggManager:isRedPoint()
		CommonManager:setRedPointStateByKey( "btn_goldEgg", redPointState )
		CommonManager:setRedPoint(self.btn_goldEgg, redPointState,"btn_goldEgg",ccp(0,0))
	end	
	-- CommonManager:setRedPoint(self.btn_xunbao, TreasureManager:isRedPoint(), "isGoldEggRedPoint", ccp(0,0))
	if CommonManager:checkRedPointByKey("btn_xunbao",currTime) then
		local redPointState = TreasureManager:isRedPoint()
		CommonManager:setRedPointStateByKey( "btn_xunbao", redPointState )
		CommonManager:setRedPoint(self.btn_xunbao, redPointState,"btn_xunbao",ccp(0,0))
	end	
	if CommonManager:checkRedPointByKey("btn_longmenpo",currTime) then
		local redPointState = LongMenPoManager:haveFreeChance()
		CommonManager:setRedPointStateByKey( "btn_longmenpo", redPointState )
		CommonManager:setRedPoint(self.btn_longmenpo, redPointState,"btn_longmenpo",ccp(0,0))
	end
	if CommonManager:checkRedPointByKey("btn_tianjilun",currTime) then
		local redPointState = TianJiLunManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "btn_tianjilun", redPointState )
		CommonManager:setRedPoint(self.btn_tianjilun, redPointState,"btn_tianjilun",ccp(0,0))
	end
	if CommonManager:checkRedPointByKey("btn_starhero",currTime) then
		local redPointState = StarHeroManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "btn_starhero", redPointState )
		CommonManager:setRedPoint(self.btn_starhero, redPointState,"btn_starhero",ccp(0,0))
	end

	if CommonManager:checkRedPointByKey("btn_sevenDayRank", currTime) then
		local redPointState = SevenDayRankManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "btn_sevenDayRank", redPointState )
		CommonManager:setRedPoint(self.btn_sevenDayRank, redPointState, "btn_sevenDayRank", ccp(0,0))
	end	

	if CommonManager:checkRedPointByKey("btn_murenzhuang", currTime) then
		local redPointState = WoodActivityManager:isRedPoint()
		CommonManager:setRedPointStateByKey( "btn_murenzhuang", redPointState )
		CommonManager:setRedPoint(self.btn_murenzhuang, redPointState,"btn_murenzhuang",ccp(0,0))
	end	

    -- 开服大礼
	if CommonManager:checkRedPointByKey("btn_kfdl",currTime) then
		local redPointState = SevenDaysManager:isKaiFuDaLiRedPoint()
		CommonManager:setRedPointStateByKey( "btn_kfdl", redPointState )
		CommonManager:setRedPoint(self.btn_kfdl, redPointState,"btn_kfdl",ccp(0,0))
	end	

	-- 赶年兽
	if CommonManager:checkRedPointByKey("btn_gns",currTime) then
		local redPointState = NianShouManager:getBeastRedPoint()
		CommonManager:setRedPointStateByKey( "btn_gns", redPointState )
		CommonManager:setRedPoint(self.btn_gns, redPointState,"btn_gns",ccp(0,0))
	end

	-- 打年兽
	if CommonManager:checkRedPointByKey("btn_dns",currTime) then
		local redPointState = DaNianShouManager:getBeastRedPoint()
		CommonManager:setRedPointStateByKey( "btn_dns", redPointState )
		CommonManager:setRedPoint(self.btn_dns, redPointState,"btn_dns",ccp(0,0))
	end	

	-- 返利转盘
	if CommonManager:checkRedPointByKey("btn_flzp",currTime) then
		local redPointState = FanLiZhuanPanManager:isRedPoint()
		CommonManager:setRedPointStateByKey( "btn_flzp", redPointState )
		CommonManager:setRedPoint(self.btn_flzp, redPointState,"btn_flzp",ccp(0,0))
	end	

	--琅环
	local bShowLangHuan = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_LangHuan)
	self.btn_langHuan:setVisible(bShowLangHuan)

	-- 打开金蛋icon
	local bShowEgg = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Hit_Egg)
	local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2217)
    if teamLev < openLev then
    	bShowEgg = false
    end
	self.btn_goldEgg:setVisible(bShowEgg)
	-- print(" ------------- MenuLayer:555555555555")

	local bShowXunBao = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Active_XunBao)
	teamLev = MainPlayer:getLevel()
    openLev = FunctionOpenConfigure:getOpenLevel(2215)
    if teamLev < openLev then
    	bShowXunBao = false
    end
	self.btn_xunbao:setVisible(bShowXunBao)


	local bShowSevenRank = (MainPlayer:getServerSwitchStatue(ServerSwitchType.SevenDayRank) and SevenDayRankManager:getOpenSatus() ~= SevenDayRankManager.EnumOpenStatus.CLOSE)
	local bShowRankNew = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Sevenday_Rank)
	self.btn_sevenDayRank:setVisible(bShowSevenRank and bShowRankNew)
	---test by wuqi
	--self.btn_sevenDayRank:setVisible(true)

	local bShowLMP = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_LongMenPo)
	teamLev = MainPlayer:getLevel()
    openLev = FunctionOpenConfigure:getOpenLevel(2208)
    if teamLev < openLev then
    	bShowLMP = false
    end
	self.btn_longmenpo:setVisible(bShowLMP)

	local bShowTJL = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Tian_Ji_Lun)
	teamLev = MainPlayer:getLevel()
    openLev = FunctionOpenConfigure:getOpenLevel(2216)
    if teamLev < openLev then
    	bShowTJL = false
    end
	self.btn_tianjilun:setVisible(bShowTJL)

	local bShowMRZ = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Xia_Ke_Xing)
	teamLev = MainPlayer:getLevel()
    openLev = FunctionOpenConfigure:getOpenLevel(2221)
    if teamLev < openLev then
    	bShowMRZ = false
    end
	self.btn_murenzhuang:setVisible(bShowMRZ)

	local bShowStarHero = StarHeroManager:IsOpen()
	self.btn_starhero:setVisible(bShowStarHero)

	self.btn_jhjh:setVisible( OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_JiangHuJuHui) )

	self.btn_kaojiao:setVisible(true)
	if MainPlayer:getLevel() < FunctionOpenConfigure:getOpenLevel(2207) or not MainPlayer:getServerSwitchStatue(ServerSwitchType.KaoJiao) then
		self.btn_kaojiao:setVisible(false)
	end

	if CommonManager:checkRedPointByKey("sevenDayPower",currTime) then
		local redPointState = SevenDayPowerManager:getRedPoint()
		CommonManager:setRedPointStateByKey( "sevenDayPower", redPointState )
		CommonManager:setRedPoint(self.btn_sevenDayPower, redPointState,"sevenDayPower",ccp(0,0))
	end

	if CommonManager:checkRedPointByKey("peakHaveTimes",currTime) then
		local redPointState = PeakManager:checkRedPoint() or HeroMeetingManager:getRedPointState()
		CommonManager:setRedPointStateByKey( "peakHaveTimes", redPointState )
		CommonManager:setRedPoint(self.btn_wulin, redPointState,"peakHaveTimes",ccp(0,0))
	end
	
	if CommonManager:checkRedPointByKey("illustrationZhuanji",currTime) then
		local redPointState = IllustrationManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "illustrationZhuanji", redPointState )
		CommonManager:setRedPoint(self.btn_tujian, redPointState,"illustrationZhuanji",ccp(0,0))
	end	

	if CommonManager:checkRedPointByKey("vipScore",currTime) then
		local redPointState = MainPlayer:getVipScoreRed()
		CommonManager:setRedPointStateByKey( "vipScore", redPointState )
		CommonManager:setRedPoint(self.btn_pay, redPointState,"vipScore",ccp(0,0))
	end
	
	if CommonManager:checkRedPointByKey("rechargeTicket",currTime) then
		local redPointState = RechargeTicketManager:haveTodayUse()
		CommonManager:setRedPointStateByKey( "rechargeTicket", redPointState )
		CommonManager:setRedPoint(self.btn_pay, redPointState,"rechargeTicket",ccp(0,0))
	end	
	local downLock = nil
	if TFPlugins.isCompletePack == nil or TFPlugins.isCompletePack then
		downLock = VersionLockData:objectByID(EnumVersionLockType.DownGift_Lock_Big)
	else
		downLock = VersionLockData:objectByID(EnumVersionLockType.DownGift_Lock)
	end
    if downLock and downLock.open == 0 then
        self.btn_down:setVisible(false)
    else
       	self.btn_down:setVisible(DownResourceManager.isShowBtn)
    end


    local bShowLGuide = (not MissionManager:checkIsPassGuideMission()) and PlayerGuideManager:shouldLongTimeGuideShow(1)
	PlayerGuideManager:addLongTimeGuide(self, self.pveBtn, 1, bShowLGuide )

	self:refreshBtnList()
	self:showTipBox()
end

function MenuLayer.onBuyTimeClickHandle(sender)
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.common.ReplyLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1);
    layer:setType(EnumRecoverableResType.PUSH_MAP,true);
    AlertManager:show()
	-- VipRuleManager:showReplyLayer(EnumRecoverableResType.PUSH_MAP)
	-- PayManager:showVipChangeLayer()
end

function MenuLayer.onBuyCionClickHandle(sender)
    local self = sender.logic;
    CommonManager:showNeedCoinComfirmLayer();
end

function MenuLayer.onBuySyceeClickHandle(sender)
    local self = sender.logic;
    PayManager:showPayLayer();
end

function MenuLayer:setNextOpenShow(bShow)
	if (not self.panel_opennew) or ( not self.panel_opennew:isVisible() ) then
		return
	end

	local index = 2
	if bShow then
		index = 1
	end

	local initActTime = {0.5, 0.5}
	local destActTime = {0.5, 0.5}
	local initScaleX = {0.1, 1}
	local destScaleX = {1, 0.1}
	local initPosX = self.btn_opennew.initPos.x
	local intPosTab = {initPosX + 130, initPosX}
	local destPosTab = {initPosX, initPosX + 130}
	local initShowTab = {false, false}
	local destShowTab = {true, false}

	TFDirector:killAllTween(self.img_opennew)
	TFDirector:killAllTween(self.btn_opennew)

	self:setNextTxtShow(initShowTab[index])
	self.img_opennew:setScaleX(initScaleX[index])
	local tween1 = 
	{
		target = self.img_opennew,
		{
	        duration = initActTime[index],
	        scaleX = destScaleX[index],
	    },
	}

	local tween2 = 
	{
		target = self.btn_opennew,
		{
	        duration = 0,
	        x = intPosTab[index],
	    },
	    {
	        duration = destActTime[index],
	        x = destPosTab[index],
	    },
	    {
	    	duration = 0,
	    	onComplete = function() 
                self:setNextTxtShow(destShowTab[index])
            end
		},
	}

	if index == 2 then
		self.posRight = true
	else
		self.posRight = false
	end

	TFDirector:toTween(tween1)
	TFDirector:toTween(tween2)

	if index == 1 then
		self.txt_newopen:stopAllActions()
		local actArr = TFVector:create()
    	local act1 = CCDelayTime:create(6)
    	local act2 = CCCallFuncN:create( function()
			if not self.posRight then
            	self:setNextOpenShow(false)
            end
        end)
	    actArr:addObject(act1)
	    actArr:addObject(act2)
    	self.txt_newopen:runAction( CCSequence:create(actArr) )
    end
end

function MenuLayer.onNextOpenNewClickHandle(sender)
	local self = sender.logic
	local bShow = not self.txt_newopen:isVisible()

	-- if not visible == true then
	-- 	self.img_opennew:stopAllActions()
	-- 	local ac1 = CCDelayTime:create(30)
	-- 	local ac2 = CCSequence:createWithTwoActions(ac1,CCHide:create())

	-- 	self.img_opennew:runAction(ac2)
	-- end
	self:setNextOpenShow(bShow)
end

function MenuLayer.payBtnClickHandle(sender)
	--埋点id:13 充值
	local playerLv = MainPlayer:getLevel()
	if (playerLv == 4) then
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {13})
	end
    PayManager:showPayHomeLayer(AlertManager.NONE);
end

function MenuLayer.firstPayBtnClickHandle(sender)
    --埋点id:15 首充
    local playerLv = MainPlayer:getLevel()
	if (playerLv == 4) then
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {15})
	end
	PayManager.openFirstPay = false
    PayManager:showFirstPayLayer();
end

function MenuLayer.weixinBtnClickHandle(sender)

	MainPlayer:WeixinBePressed()
	CommonManager:setRedPointStateByKey( "btn_weixin", false )
    local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.home.WeixinLayer",AlertManager.BLOCK_AND_GRAY,tween);
    AlertManager:show();
end

function MenuLayer.knightBtnClickHandle(sender)
	KnightManager:openKnightLayer()
end

function MenuLayer.knightShareBtnClickHandle(sender)
	--KnightManager:openKnightFriendHelpLayer()
end

function MenuLayer.guibingBtnClickHandle(sender)
	 local layer  = require("lua.logic.pay.VipQQLayer"):new()
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show() 
end

function MenuLayer.zhengbasaiBtnClickHandle(sender)
	if ZhengbaManager:getActivityStatus() ~= 1 and MainPlayer:getLevel() >= 35 then
		ZhengbaManager:openZhengbaMainLayer()
	else
		FactionFightManager:openCurrLayer()
	end
end

function MenuLayer.onWuLinEnemyBtnClick(sender)
	WuLinEnemyManager:openMainLayer()
end

function MenuLayer.kfFightClickHandle(sender)
	local state = MultiServerFightManager:getActivityState()
	if state and (state >= 1 and state < 9) then
		MultiServerFightManager:openCurrLayer()
	end
end
function MenuLayer.crossGuildBattleClickHandle(sender)
	local state = CrossGuildBattleManager:getActivityState()
	if state >= 1 and state <= 3 then
		CrossGuildBattleManager:openCurrLayer(false)
    end
end

function MenuLayer.onKingWarBtnClick(sender)
	KingOfWarManager:openMainLayer()
end

function MenuLayer.onGuildBossBtnClick(sender)
	GuildBossManager:openMainLayer()
end

function MenuLayer.onBiaoCheBtnClick(sender)
	BiaoCheManager:openMainLayer()
end

function MenuLayer.wulinBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "peakHaveTimes", false )
	WulinManager:showLayer(WulinManager.TAP_ZhengBaSai)
end

function MenuLayer.fcmClick( sender )
	CommonManager:setRedPointStateByKey( "btn_fcm", false )
	SettingManager:openFcmLayer()
end

function MenuLayer.downBtnClickHandle(sender)
	DownResourceManager:openDownLayer()
end


function MenuLayer:refreshStamina()
	local times = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.PUSH_MAP);
    self.txt_tilipoint:setText(times:getLeftChallengeTimes()  .. "/" .. times.maxValue);
end

function MenuLayer.onUIClickHandle(sender)
	local self = sender.logic
	--self.img_di:setVisible(false)
	--self.leftDownPage = 1

	if self:getLeftDownWidgetShowNum() <= 5 then
		return
	end
	if self.leftDownPage == 2 then
		sender.logic:turnChange()
	end
end

function MenuLayer:refreshAnti()
	-- print("<<<<================================================>>>>")
	-- print("SettingManager.AntiaddictionCode = ",SettingManager.AntiaddictionCode)
	-- print("SettingManager:getTotalSec() = ",SettingManager:getTotalSec())
	-- print("SettingManager.GameTime = ",SettingManager.GameTime)
	if SettingManager:getFCMServerSwitch() == false or
	   SettingManager.AntiaddictionCode == nil or 
	   SettingManager.AntiaddictionCode <= SettingManager.AntiCode_Adult then
	   	-- set default state 1
	   	self.antiState = 1
	   	if self.btn_fcm:isVisible() then
	   		self.img_fcm:setTexture("ui_new/home/img_sy1.png")
	   	end
		return
	end
	local currentScene = Public:currentScene()
    if currentScene.__cname ~= "HomeScene" then
        return
    end
    local state = nil
    local totalSec = SettingManager:getTotalSec()
    if totalSec >= 3 * 3600 and totalSec < 5 * 3600 then
    	state = 2
    	-- set half state 2
    elseif totalSec >= 5 * 3600 then
    	state = 3
    	-- set zero state 3
    else
    	-- set normal state 1
    	state = 1
    end
    if state == self.antiState then
    	return
    end
    self.antiState = state
    local tipmsg = nil
    if state == 2 then
    	tipmsg = localizable.Anti_Tip_time3
    	if self.btn_fcm:isVisible() then
	   		self.img_fcm:setTexture("ui_new/home/img_sy2.png")
	   	end
    elseif state == 3 then
    	tipmsg = localizable.Anti_Tip_time5
    	if self.btn_fcm:isVisible() then
	   		self.img_fcm:setTexture("ui_new/home/img_sy3.png")
	   	end
	elseif state == 1 then	
		if self.btn_fcm:isVisible() then
	   		self.img_fcm:setTexture("ui_new/home/img_sy1.png")
	   	end
	   	return
	else
		return
    end
    CommonManager:showOperateSureLayer(
        function()                
        end,
        function()
            AlertManager:close()
        end,
        {
	        title = localizable.common_tips ,
	        msg = tipmsg,
	        uiconfig = "lua.uiconfig_mango_new.common.OperateSure1"
        }
    )
end

function MenuLayer:registerEvents()
    self.super.registerEvents(self)

    AssistFightManager:refreshRoleQiheAttr()
    AdventureManager:requestHomeLayerData()

    self.btn_buytime.logic = self;
    self.btn_buytime:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onBuyTimeClickHandle),1);
    self.btn_buycion.logic = self;
    self.btn_buycion:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onBuyCionClickHandle),1);
    self.btn_buysycee.logic = self;
    self.btn_buysycee:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onBuySyceeClickHandle),1);
    -- self.btn_nextopen.logic = self;
    -- self.btn_nextopen:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onNextOpenClickHandle),1);

    self.btn_opennew.logic = self
    self.btn_opennew:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onNextOpenNewClickHandle),1);

    --
    self.ui:setTouchEnabled(true)
    self.ui.logic = self
    self.ui:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onUIClickHandle),1);

	self.btn_head:addMEListener(TFWIDGET_CLICK, audioClickfun(self.headClickHandle));
	self.btn_chat:addMEListener(TFWIDGET_CLICK, audioClickfun(self.chatClickHandle),1);
	self.btn_chat.logic = self

    self.setingBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.shezhiClickHandle),1);
    self.infoBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.infoBtnClickHandle),1);

    self.roleBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.roleBtnClickHandle),1);
    self.roleBtn.logic = self
	self.equipBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.equipBtnClickHandle),1);
    self.bagBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.bagBtnClickHandle),1);
    self.bagBtn.logic = self
    self.btn_employ:addMEListener(TFWIDGET_CLICK, audioClickfun(self.employBtnClickHandle),1);
    self.btn_eudemon:addMEListener(TFWIDGET_CLICK, audioClickfun(self.eudemonBtnClickHandle),1);
    self.mallBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.mallBtnClickHandle),1);
    self.zhaomuBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.zhaomuBtnClickHandle),1);
    self.taskBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.taskBtnClickHandle),1);
    self.dailyTaskBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.dailyTaskBtnClickHandle),1);

    self.btn_youli:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBtnYouliClick),1);
    self.pvpBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.pvpBtnClickHandle),1);
    self.pveBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.pveBtnClickHandle),1);
    self.qiyuBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.qiyuBtnClickHandle),1);
    self.btn_pay:addMEListener(TFWIDGET_CLICK, audioClickfun(self.payBtnClickHandle),1);
    self.btn_firstpay:addMEListener(TFWIDGET_CLICK, audioClickfun(self.firstPayBtnClickHandle),1);
    self.btn_weixin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.weixinBtnClickHandle),1);
    -- self.btn_weixin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onclickMoive),1);
    self.btn_yueka:addMEListener(TFWIDGET_CLICK, audioClickfun(self.yuekaBtnClickHandle),1);
    self.btn_sign:addMEListener(TFWIDGET_CLICK, audioClickfun(self.signBtnClickHandle),1);
    self.btn_tujian:addMEListener(TFWIDGET_CLICK, audioClickfun(self.tujianBtnClickHandle),1);
    self.btn_gonglue:addMEListener(TFWIDGET_CLICK, audioClickfun(self.gonglueBtnClickHandle),1);
    self.btn_youfang:addMEListener(TFWIDGET_CLICK, audioClickfun(self.youfangMallBtnClickHandle),1);
    self.btn_vip:addMEListener(TFWIDGET_CLICK, audioClickfun(self.guibingBtnClickHandle),1);
    self.btn_zhengbasai:addMEListener(TFWIDGET_CLICK, audioClickfun(self.zhengbasaiBtnClickHandle),1);
    self.btn_kfFight:addMEListener(TFWIDGET_CLICK, audioClickfun(self.kfFightClickHandle),1);
    self.btn_crossGuildBattle:addMEListener(TFWIDGET_CLICK, audioClickfun(self.crossGuildBattleClickHandle),1);
    self.btn_wulin:addMEListener(TFWIDGET_CLICK, audioClickfun(self.wulinBtnClickHandle),1);
    self.btn_down:addMEListener(TFWIDGET_CLICK, audioClickfun(self.downBtnClickHandle),1);
    self.btn_goldEgg:addMEListener(TFWIDGET_CLICK, audioClickfun(self.goldEggBtnClickHandle),1);
    self.btn_xunbao:addMEListener(TFWIDGET_CLICK, audioClickfun(self.xunBaoBtnClickHandle),1);
    self.btn_longmenpo:addMEListener(TFWIDGET_CLICK, audioClickfun(self.longmenpoBtnClickHandle),1);
    self.btn_tianjilun:addMEListener(TFWIDGET_CLICK, audioClickfun(self.tianjilunBtnClickHandle),1);
    self.btn_starhero:addMEListener(TFWIDGET_CLICK, audioClickfun(self.starheroBtnClickHandle),1);
    self.btn_sevenDayRank:addMEListener(TFWIDGET_CLICK, audioClickfun(self.sevenRankBtnClickHandle),1);
    self.btn_murenzhuang:addMEListener(TFWIDGET_CLICK, audioClickfun(self.murenzhuangBtnClickHandle),1);
    self.cmt2144Btn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.cmt2144BtnClickHandle),1);
    self.btn_kfdl:addMEListener(TFWIDGET_CLICK, audioClickfun(self.kaiFuDaLiClickHandle),1);
    self.btn_flzp:addMEListener(TFWIDGET_CLICK, audioClickfun(self.fanLiZhuanPanClickHandle),1);
    self.btn_langHuan:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onLangHuanClickHandle),1);
    self.btn_zhouNianQing:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onZhouNianQingClickHandle),1);
	self.btn_goldenCard:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onGoldenCardClickHandle),1);
	self.btn_gns:addMEListener(TFWIDGET_CLICK, audioClickfun(self.ganNianShouClickHandle),1);
	self.btn_dns:addMEListener(TFWIDGET_CLICK, audioClickfun(self.DaNianShouClickHandle),1);
	self.btn_jhjh:addMEListener(TFWIDGET_CLICK, audioClickfun(self.jianghujuhuiClickHandle), 1)
	self.btn_fyl:addMEListener(TFWIDGET_CLICK, audioClickfun(self.FengYunLuBtnClickHandle),1);
	self.btn_daTi:addMEListener(TFWIDGET_CLICK, audioClickfun(self.DaTiBtnClickHandle),1);

    self.btn_paihang:addMEListener(TFWIDGET_CLICK, audioClickfun(self.paihangBtnClickHandle),1);
	self.btn_huodong:addMEListener(TFWIDGET_CLICK, audioClickfun(self.huodongBtnClickHandle),1);
	self.btn_import_huodong:addMEListener(TFWIDGET_CLICK, audioClickfun(self.huodongImportBtnClickHandle),1);
	self.btnLimitExchange:addMEListener(TFWIDGET_CLICK, audioClickfun(self.huodongExchageBtnClickHandle),1);
	self.btnTimeLimitMall:addMEListener(TFWIDGET_CLICK, audioClickfun(self.btnTimeLimitMallClick),1);
	self.btn_zaixian.logic = self
	self.btn_zaixian:addMEListener(TFWIDGET_CLICK, audioClickfun(self.OnlineBtnClickHandle),1);
	self.btn_fcm.logic = self
	self.btn_fcm:addMEListener(TFWIDGET_CLICK, audioClickfun(self.fcmClick),1);

	self.btn_sevenday.logic = self
	self.btn_sevenday:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onclickSevenDay),1);
	-- self.btn_sevenday:setVisible(false)
	-- pp
	self.btn_friends.logic = self
	self.btn_friends:addMEListener(TFWIDGET_CLICK, audioClickfun(self.friendBtnClickHandle),1);

	self.btn_faction.logic = self
	self.btn_faction:addMEListener(TFWIDGET_CLICK, audioClickfun(self.factionBtnClickHandle),1);
	self.btn_change.logic = self
	self.btn_change:addMEListener(TFWIDGET_CLICK, audioClickfun(self.changeBtnClickHandle),1);

	self.img_qipao.logic = self
	self.img_qipao:addMEListener(TFWIDGET_CLICK, audioClickfun(self.img_qipaoClickHandle),1);

	self.playerBackBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.playBackBtnClickHandle),1);
	if (self.btn_knight) then
		self.btn_knight:addMEListener(TFWIDGET_CLICK, audioClickfun(self.knightBtnClickHandle),1);
		--self.btn_knightShare:addMEListener(TFWIDGET_CLICK, audioClickfun(self.knightShareBtnClickHandle),1);
	end
		-- pp
	-- self.btn_huodong:addMEListener(TFWIDGET_CLICK, audioClickfun(self.PlatformBtnClickHandle),1);

	--added by wuqi
	self.btn_kaojiao.logic = self
	self.btn_kaojiao:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onKaojiaoClickHandle), 1);

	self.btn_sevenDayPower.logic = self
	self.btn_sevenDayPower:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onSevenDayPowerClickHandle), 1);

	self.changeProfessionCallBack = function(event)
        -- self.isLoadRoleList = false
        self:refreshBaseUI(true)
    end
	TFDirector:addMEGlobalListener(SettingManager.changeProfessionSuccess ,self.changeProfessionCallBack)

	self.updateUserDataCallBack = function(event)
        -- self.isLoadRoleList = false
        self:refreshBaseUI(true)
    end

	TFDirector:addMEGlobalListener(MainPlayer.ResourceUpdateNotifyBatch ,self.updateUserDataCallBack)
	TFDirector:addMEGlobalListener(MainPlayer.ChallengeTimesChange ,self.updateUserDataCallBack)

	self.updateRedPacketAttriCallBack = function(event)
        --self:refreshBaseUI(true)
        self:refreshBuffEffectShow()
    end
	TFDirector:addMEGlobalListener(RedPacketManager.RECEIVE_SEND_ATTRIBUTE_BRUSH ,self.updateRedPacketAttriCallBack)
	
	-- self.updateRedPacketAcheivAttriCallBack = function(event)
 --        self:refreshBaseUI(true)
 --    end
	-- TFDirector:addMEGlobalListener(RedPacketManager.RECEIVE_MY_RED_PACKET_INFO ,self.updateRedPacketAcheivAttriCallBack)

	self.updateStrategyFormation = function (event)
		self.isLoadRoleList = true
	end
	TFDirector:addMEGlobalListener(StrategyManager.UPDATE_GENERRAL_LIST ,self.updateStrategyFormation)

	self.updateActivityStateCB = function(event)
        self:refreshZhengbaBtn()
    end
	TFDirector:addMEGlobalListener(MultiServerFightManager.updateActivityState ,self.updateActivityStateCB)

	self.upadteChampionsStatus = function(event)
        self:refreshZhengbaBtn()
    end
	TFDirector:addMEGlobalListener(ZhengbaManager.UPADTECHAMPIONSSTATUS ,self.upadteChampionsStatus)
	
	self.activityStateChangeCB = function(event)
        self:refreshZhengbaBtn()
    end
	TFDirector:addMEGlobalListener(FactionFightManager.activityStateChange ,self.activityStateChangeCB)
	TFDirector:addMEGlobalListener(KingOfWarManager.NeedSwitchLayerMsg ,self.activityStateChangeCB)
	TFDirector:addMEGlobalListener(GuildBossManager.RECEIVE_ACTIVITY_STATE ,self.activityStateChangeCB)
	TFDirector:addMEGlobalListener(FengYunLuManager.UPDATE_STATE ,self.activityStateChangeCB)

	self.levelVhangeCallBack = function(event)
        self:refreshBtnVisibleWithLevel()
        self:refreshZhengbaBtn()
    end
	TFDirector:addMEGlobalListener(MainPlayer.LevelChange ,self.levelVhangeCallBack)

	self.chatNewMarkChange = function(event)
        -- CommonManager:setRedPoint(self.btn_chat, ChatManager:isHaveNewChat(),"isHaveNewChat",ccp(0,0))
    	if CommonManager:checkRedPointByKey("isHaveNewChat",MainPlayer:getNowtime()) then
			local redPointState = ChatManager:isHaveNewChat()
			CommonManager:setRedPointStateByKey( "isHaveNewChat", redPointState )
			CommonManager:setRedPoint(self.btn_chat, redPointState,"isHaveNewChat",ccp(0,0))
		end
    end

	TFDirector:addMEGlobalListener(ChatManager.NewMarkChange  ,self.chatNewMarkChange)

	self.onUpdateSevenDay = function(event)
		local redPointState = SevenDaysManager:checkRedPoint()
		CommonManager:setRedPointStateByKey( "isCodeCanGetReward1", redPointState )
		CommonManager:setRedPoint(self.btn_sevenday, redPointState,"isCodeCanGetReward1",ccp(0,0))	
		local kaiFuDaLiredPointState = SevenDaysManager:isKaiFuDaLiRedPoint()
		CommonManager:setRedPointStateByKey( "btn_kfdl", kaiFuDaLiredPointState )
		CommonManager:setRedPoint(self.btn_kfdl, kaiFuDaLiredPointState,"btn_kfdl",ccp(0,0))	
	end
	TFDirector:addMEGlobalListener(SevenDaysManager.UpdateRedPoint, 	self.onUpdateSevenDay)

	self.onUpdateGanNianShou = function(event)
		local ganNianShouredPointState = NianShouManager:getBeastRedPoint()
		CommonManager:setRedPointStateByKey( "btn_gns", kaiFuDaLiredPointState )
		CommonManager:setRedPoint(self.btn_gns, kaiFuDaLiredPointState,"btn_gns",ccp(0,0))	
	end
	TFDirector:addMEGlobalListener(NianShouManager.UpdateRedPoint,self.onUpdateGanNianShou)
	
	self.onUpdateFLZP = function(event)	
		local fanLiZhuanPanredPointState = FanLiZhuanPanManager:isRedPoint()
		CommonManager:setRedPointStateByKey( "btn_flzp", fanLiZhuanPanredPointState )
		CommonManager:setRedPoint(self.btn_flzp, fanLiZhuanPanredPointState,"btn_flzp",ccp(0,0))	
	end
	TFDirector:addMEGlobalListener(FanLiZhuanPanManager.UpdateRedPoint, self.onUpdateFLZP)

	self.updateNewMsg = function(event)
        self:chatRedPoint(MainPlayer:getNowtime())
        self:refreshIslandRed()
    end
	TFDirector:addMEGlobalListener(JapanIslandManager.UpdateNewChatMsg, self.updateNewMsg)
	TFDirector:addMEGlobalListener(JapanIslandManager.UpdateInvitationMsg, self.updateNewMsg)

	self.onUpdateZNQ = function(event)	
		local ZNQPointState = AnniversaryManager:isHaveRewardCanGet()
		CommonManager:setRedPointStateByKey( "btn_zhouNianQing", ZNQPointState )
		CommonManager:setRedPoint(self.btn_zhouNianQing, ZNQPointState,"btn_zhouNianQing",ccp(0,0))	
	end
	TFDirector:addMEGlobalListener(AnniversaryManager.MSG_ACTIVITY_UPDATE,self.onUpdateZNQ)
	TFDirector:addMEGlobalListener(AnniversaryManager.MSG_SIGN_UPDATE, self.onUpdateZNQ)
	self.updateKingOfWarNewMsg = function(event)
        self:chatRedPoint(MainPlayer:getNowtime())
    end
	TFDirector:addMEGlobalListener(KingOfWarManager.UpdateNewChatMsg, self.updateKingOfWarNewMsg)
	TFDirector:addMEGlobalListener(KingOfWarManager.UpdateInvitationMsg, self.updateKingOfWarNewMsg)

	-- 在线倒计时奖励
	local function onlineReWard(event)
		-- self:getOnlineRewardUpdate(event.data[1])
	end
	TFDirector:addMEGlobalListener(OperationActivitiesManager.GET_ACITIVTY_REWARD_SUCCESS, 	onlineReWard)
	TFDirector:addMEGlobalListener(OperationActivitiesManager.ACITIVTY_REWARD_RECORD, 		onlineReWard)
	
	local function onlineRewardTimer(sender)
		-- print("desc = ", sender.desc)
		if self.txt_time == nil then
			return
		end
		self.txt_time:setText(sender.desc)
		self.btn_zaixian:setVisible(true)
		-- 开启在线奖励特效
		if sender.bPrize == true and sender.timeCount == 0 then
			self.txt_time:setVisible(false)
			self:playOnlineEffect()
		-- 结束
		else
			self.txt_time:setVisible(true)
			self:stopOnlineEffect()
		end
		-- v.timeCount	= self.timeCount
		-- v.bPrize	= self.bOnlineRewardOnTime  --当前的在线奖励是否可领
	end

	-- -- if QiyuManager:ActivityFuctionOnlineReward() then 
	-- 	OperationActivitiesManager:setOnlineRewardTimer(self, 1001, onlineRewardTimer)
	-- -- end

	OperationActivitiesManager:addOnlineRewardListener(self, 1001, onlineRewardTimer)

	self.onSdkPlatformLogout = function (event)
		-- self:timeOut(function()

  --       	TFLOGERROR("self.onSdkPlatformLogout")
		-- 	-- toastMessage("---------MenuLayer.onSdkPlatformLogout ")
		-- 	SettingManager:gotoLoginLayer()
		-- end, 1000)
		-- print('MenuLayer.onSdkPlatformLogout call')
			--刷新体力
		self.LoginOutFunction = function()
			TFLOGERROR("self.onSdkPlatformLogout")
			SettingManager:gotoLoginLayer()
		end

		if not self.nTimerLoginOut then

        	self.nTimerLoginOut = TFDirector:addTimer(1000, -1, nil, self.LoginOutFunction); 
    	end
	end

	self.onSdkPlatformLeave = function (event)
		-- toastMessage("---------MenuLayer.onSdkPlatformLeave ")
		print('MenuLayer.onSdkPlatformLeave call')
	end

	-- TFDirector:addMEGlobalListener("onSdkPlatformLogout", self.onSdkPlatformLogout)
	-- TFDirector:addMEGlobalListener("onSdkPlatformLeave", self.onSdkPlatformLeave)
	
	if HeitaoSdk then
		self.onSdkPlatformLogout = function()
			self:timeOut(function()
	        	print("self.onSdkPlatformLogout")
				SettingManager:gotoLoginLayer()
			end, 0)
		end
		-- HeitaoSdk.setLoginOutCallBack(self.onSdkPlatformLogout)
	end

	ADD_KEYBOARD_CLOSE_LISTENER(self, self.ui)

	--刷新体力
	self.onUpdated = function()
		if (self and not tolua.isnull(self) and self.onUpdated) then
		else
			toastMessage("****error***")
			return
		end
		self:refreshStamina()
		self:refreshAnti()
		--超级牛逼的运营说要加个服务器时间
		local date = GetCorrectDate("*t", MainPlayer:getNowtime())
		local timeStr =  string.format("%.2d:%.2d",date.hour,date.min) --..":"..date.sec
		self.txt_systemtime:setText(timeStr)
		local isnight = false
		if date.hour < 6 or date.hour >= 18 then
			isnight = true
		end
		self:initNightScene(isnight)

		if MallManager.travelBusiness and MallManager.travelBusiness.info and MallManager.travelBusiness.beginTime and MallManager.travelBusiness.endTime then
			local nowTime = MainPlayer:getNowtime()
			if nowTime >= MallManager.travelBusiness.beginTime and nowTime <= MallManager.travelBusiness.endTime then
				if self.btn_youfang:isVisible() == false then
					self.btn_youfang:setVisible(true)
					self:refreshBtnList()
				end
			else
				if self.btn_youfang:isVisible() then
					self.btn_youfang:setVisible(false)
					self:refreshBtnList()
				end
			end
		else
			if self.btn_youfang:isVisible() then
				self.btn_youfang:setVisible(false)
				self:refreshBtnList()
			end
		end
		-- -- local armature = TFDirector:getChildByPath(self.ui, "armature1")
		-- local skillopenLevel = FunctionOpenConfigure:getOpenLevel(201)
  --       if MainPlayer:getLevel() < skillopenLevel then
		-- 	CommonManager:setRedPoint(self.rolePanel, false,"isSkillFull",ccp(85,-55))
  --       else
		-- 	CommonManager:setRedPoint(self.rolePanel, MainPlayer:isChallengeTimesFull(EnumRecoverableResType.SKILL_POINT),"isSkillFull",ccp(85,-55))
  --       end
	end
    -- 刷新活动提示
    self.onUpdatedActivityTip=function()
		local TotalSec=SettingManager:getTotalSec()
		if math.floor(TotalSec/2700)>=ActivityTipManager.tipNumber then--在线45分钟
			ActivityTipManager.isCanTip=true
			self:refreshActivityBubbles()
			ActivityTipManager.tipNumber=ActivityTipManager.tipNumber+1
		end
	end
	if not  self.activityTipTimerId then
        self.activityTipTimerId = TFDirector:addTimer(60000, -1, nil, self.onUpdatedActivityTip); 
    end

	if not  self.nTimerId then
        self.nTimerId = TFDirector:addTimer(1000, -1, nil, self.onUpdated); 
    end

      --监听VIP等级更改
    self.totalRechargeChangeCallback = function(event)
    	self:refreshUIPayBtn()
	end
	TFDirector:addMEGlobalListener(MainPlayer.TotalRechargeChange, self.totalRechargeChangeCallback)


      --服务器开关变更
    self.serverSwitchChange = function(event)
		if event.data[1] == ServerSwitchType.WeiXin then
			self.btn_weixin:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.WeiXin))
			self:refreshBtnList()
			return
		elseif event.data[1] == ServerSwitchType.GongLv then
			self.btn_gonglue:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.GongLv))
			self:refreshBtnList()
			return
		elseif event.data[1] == ServerSwitchType.MonthCard then
			self.btn_yueka:setVisible(QiyuManager:MonthCardIsOpen())
			self:refreshBtnList()
			return
		elseif event.data[1] == ServerSwitchType.KaoJiao then
			self.btn_kaojiao:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.KaoJiao))
			return
		elseif event.data[1] == ServerSwitchType.SevenDayPower then
			self.btn_sevenDayPower:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.SevenDayPower) and SevenDayPowerManager:sevenDaysOpenSatus() ~= 0)
			return
		elseif event.data[1] == ServerSwitchType.VipIcon then
			self.btn_vip:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.VipIcon))
			return
		elseif event.data[1] == ServerSwitchType.KingOfWar then
			self.kingWarBtn:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.KingOfWar))
			return
		elseif event.data[1] == ServerSwitchType.Eudemon then
		    self:refreshLeftDownBtnList()
			return
		elseif event.data[1] == ServerSwitchType.FangCM then
			if SettingManager:getFCMServerSwitch() == false or SettingManager.getReward == 1 then
				self.btn_fcm:setVisible(false)
			else
				self.antiState = 0
				self.btn_fcm:setVisible(true)
			end
			self:refreshBtnList()
			return
		elseif event.data[1] == ServerSwitchType.Comminuty_2144 then
			if MainPlayer:getServerSwitchStatue(ServerSwitchType.Comminuty_2144) == true then
				self.cmt2144Btn:setVisible(true)
			else
				self.cmt2144Btn:setVisible(false)
			end
			self:refreshBtnList()
			return
		elseif event.data[1] == ServerSwitchType.Anniversary then
			local isShow = AnniversaryManager:isShowInMenu()
			self.btn_zhouNianQing:setVisible(isShow)
		elseif event.data[1] == ServerSwitchType.XinFaNingLian then
			XinFaManager:ServerSwitchChange()
		elseif event.data[1] == ServerSwitchType.HeroMeeting or event.data[1] == ServerSwitchType.BiaoCheSwitch then
			WulinManager:AddNormalActivity()
		end
		self.qiyuBtn:setVisible(QiyuManager:QiyuFuctionIsOpen())

	end
	TFDirector:addMEGlobalListener(MainPlayer.ServerSwitchChange, self.serverSwitchChange)



    self.activityUpdateCallBack = function(event)
        OperationActivitiesManager:addOnlineRewardListener(self, 1001, onlineRewardTimer)

		-- 砸蛋活动
		local bShowEgg = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Hit_Egg)
		-- local bShowEgg = OperationActivitiesManager:bShowGoldEgg()
		local teamLev = MainPlayer:getLevel()
	    local openLev = FunctionOpenConfigure:getOpenLevel(2217)
	    if teamLev < openLev then
	    	bShowEgg = false
	    end
		self.btn_goldEgg:setVisible(bShowEgg)

		local bShowXunBao = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Active_XunBao)
		teamLev = MainPlayer:getLevel()
	    openLev = FunctionOpenConfigure:getOpenLevel(2215)
	    if teamLev < openLev then
	    	bShowXunBao = false
	    end
		self.btn_xunbao:setVisible(bShowXunBao)

		local bShowSevenRank = (MainPlayer:getServerSwitchStatue(ServerSwitchType.SevenDayRank) and SevenDayRankManager:getOpenSatus() ~= SevenDayRankManager.EnumOpenStatus.CLOSE)
		self.btn_sevenDayRank:setVisible(bShowSevenRank)

		local activityIndex, activityNum = OperationActivitiesManager:getOpenAndShowActivityList(1)
		if activityNum == 0 then
			self.btn_import_huodong:setVisible(false)
		else
			self.btn_import_huodong:setVisible(true)
		end

		local activityIndex1, activityNum1 = OperationActivitiesManager:getOpenAndShowActivityList(2)
		if activityNum1 == 0 then
			self.btnTimeLimitMall:setVisible(false)
		else
			self.btnTimeLimitMall:setVisible(true)
		end
		local activityIndex3, activityNum3 = OperationActivitiesManager:getOpenAndShowActivityList(3)
		if activityNum3 == 0 then
			self.btnLimitExchange:setVisible(false)
		else
			self.btnLimitExchange:setVisible(true)
		end

		local bShowLMP = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_LongMenPo)
		teamLev = MainPlayer:getLevel()
	    openLev = FunctionOpenConfigure:getOpenLevel(2208)
	    if teamLev < openLev then
	    	bShowLMP = false
	    end
		self.btn_longmenpo:setVisible(bShowLMP)

		local bShowTJL = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Tian_Ji_Lun)
		teamLev = MainPlayer:getLevel()
	    openLev = FunctionOpenConfigure:getOpenLevel(2216)
	    if teamLev < openLev then
	    	bShowTJL = false
	    end
		self.btn_tianjilun:setVisible(bShowTJL)

		local bShowMRZ = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Xia_Ke_Xing)
		teamLev = MainPlayer:getLevel()
	    openLev = FunctionOpenConfigure:getOpenLevel(2221)
	    if teamLev < openLev then
	    	bShowMRZ = false
	    end
		self.btn_murenzhuang:setVisible(bShowMRZ)

		local bShowStarHero = StarHeroManager:IsOpen()
		self.btn_starhero:setVisible(bShowStarHero)

		local bShowFanLiZhuanPan = FanLiZhuanPanManager:isShowInMenuLayer()
		self.btn_flzp:setVisible(bShowFanLiZhuanPan)

		self.btn_jhjh:setVisible( OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_JiangHuJuHui) )

		self:refreshBtnList()
    end

    TFDirector:addMEGlobalListener(OperationActivitiesManager.MSG_ACTIVITY_UPDATE, self.activityUpdateCallBack) 



    self.playerGuideButtonOpen = function(event)
		local widget = event.data[1]
		if widget:isVisible() then
			return
		end
		if self:showLeftDownButtonOpenAni(widget) == false then
			self:showRightMiddeleButtonOpenAni(widget)
		end
    end

	TFDirector:addMEGlobalListener(PlayerGuideManager.BUTTON_OPEN  ,self.playerGuideButtonOpen)



	local function sevenDayTimerEvent(sender)
		-- print("sender = ", sender)

	end

	SevenDaysManager:addSevenDaysEvent(self, 1001, sevenDayTimerEvent)


	self.Game_12_oClock_reset = function(event)
		self.antiState = 0
		self:refreshUI()
    end

	TFDirector:addMEGlobalListener(MainPlayer.GAME_RESET, self.Game_12_oClock_reset)

	self.newGuildApplyCallBack = function(event)
		CommonManager:setRedPoint(self.btn_faction, FactionManager:canViewRedPointInMainLayer(), "isFactionRedPoint", ccp(0,0))
	end
	TFDirector:addMEGlobalListener(FactionManager.newGuildApply, self.newGuildApplyCallBack)


	-- 请求帮派邀请
	FactionManager:gainGuildInvitation()

	self.newChatMsgCallBack = function(event)
		-- if ChatManager:checkInChatLayer() then
		-- 	return
		-- end
		self:showChatBubble()
	end
	TFDirector:addMEGlobalListener(ChatManager.ShowBubbleMsg, self.newChatMsgCallBack)
    TFDirector:addMEGlobalListener(PayManager.updateRecordList ,self.totalRechargeChangeCallback ) ;

    self.mailNumCallBack = function(event)
    	local currTime = MainPlayer:getNowtime()
		if CommonManager:checkRedPointByKey("isHaveUnReadMail",currTime) then
			local redPointState = NotifyManager:isHaveUnReadMail()
			CommonManager:setRedPointStateByKey( "isHaveUnReadMail", redPointState )
			CommonManager:setRedPoint(self.infoBtn, redPointState,"isHaveUnReadMail",ccp(0,0))
		end
	end
	TFDirector:addMEGlobalListener(NotifyManager.RETURN_NOTIFY_NUM, self.mailNumCallBack)

	self.inviteCodeCallBack = function(event)
		-- local InviteCodeInfo = QiyuManager:GetInviteCodeData() or {}
		-- local Invited = InviteCodeInfo.invited
		-- if MainPlayer:getServerSwitchStatue(ServerSwitchType.JiaYuan) and Invited and MainPlayer:getLevel() <= 1 then
		-- 	QiyuManager:openInviteSuccessLayer()
		-- end
	end
	TFDirector:addMEGlobalListener("UpdateInviteCodeInfo", self.inviteCodeCallBack)

	self.illustrationCallBack = function(event)
		self:setInfo()
	end
	TFDirector:addMEGlobalListener(IllustrationManager.IllustrationUpdate, self.illustrationCallBack)

	self.headPicFrameInitCallBack = function(event)
		self:setInfo()
	end
	TFDirector:addMEGlobalListener(HeadPicFrameManager.Init_Data, self.headPicFrameInitCallBack)

	self.accelerometerUpdateCallBack = function(event)
		local layer = AlertManager:getLayerByName("lua.logic.role_new.RoleInfoLayer")
		if layer then
			return
		end
		local currentScene = Public:currentScene()
        if currentScene ~= nil and currentScene.getTopLayer and currentScene:getTopLayer() then
            if self.didAccelerate and currentScene:getTopLayer().__cname == "MenuLayer" then
            	local data = event.data[1]
				self:didAccelerate(data)
            end
        end
    end

	TFDirector:addMEGlobalListener("HeitaoSdk.ACCELEROMETER_UPDATE"  ,self.accelerometerUpdateCallBack)
	
	self.knightShareCallBack = function(event)
        self:knightBtnShow()
    end
	TFDirector:addMEGlobalListener(KnightManager.KnightShareInfo, self.knightShareCallBack)

	self.UpdateRedWood = function()
		CommonManager:setRedPointStateByKey( "btn_murenzhuang", false )
	end
	TFDirector:addMEGlobalListener(WoodActivityManager.WOOD_MAN_PROGRESS, self.UpdateRedWood)

	self.UpdateRedPacketMsgCallBack = function()
		KingOfWarManager:checkRedPacketState(self)
	end
	TFDirector:addMEGlobalListener(KingOfWarManager.UpdateRedPacketMsg, self.UpdateRedPacketMsgCallBack)
end

function MenuLayer:getLeftDownWidgetShowNum()
	local num = 0
	for i=1,#self.leftDownBtnList do
		if self.leftDownBtnList[i].isOpen == true then
			num = num + 1
		end
	end
	return num
end

function MenuLayer:getWidgetInLeftDownPageIndex( widget )
	local num = 1
	for i=1,#self.leftDownBtnList do
		if self.leftDownBtnList[i] == widget then
			return num
		end
		if self.leftDownBtnList[i].isOpen == true then
			num = num + 1
		end
	end
	return 0
end

function MenuLayer:showLeftDownButtonOpenAni( widget )
	local widget_index = self:getWidgetInLeftDownPageIndex( widget )
	if widget_index == 0 then
		return false
	end
	local page = math.ceil(widget_index/5)
	if self.leftDownPage == page then
		self:_showLeftDownButtonOpenAni( widget )
	else
		self:turnChangeToIndex( page)
		self:_showLeftDownButtonOpenAni( widget )
	end
	return true
end

function MenuLayer:_showLeftDownButtonOpenAni( widget )
	
	local index = 0
	local num = 0
	local pos_x = self.leftDownBtnList_pos

	local bFirst = true

	for i=1,#self.leftDownBtnList do
		if self.leftDownBtnList[i] == widget then
			num = num + 1
			index = i
			pos_x = pos_x + self.leftDownBtnList[i]:getContentSize().width/2
			self.leftDownBtnList[i]:setPositionX(pos_x)
			pos_x = pos_x + self.leftDownBtnList[i]:getContentSize().width/2 + 10
			widget.isOpen = true
		else
			if self.leftDownBtnList[i].isOpen == true and index == 0 then
				num = num + 1
				if num > (self.leftDownPage - 1)*5 and num <= self.leftDownPage*5 then
					pos_x = pos_x + self.leftDownBtnList[i]:getContentSize().width + 10
				end
			end
			if self.leftDownBtnList[i].isOpen == true and index ~= 0 then
				num = num + 1
				if num > (self.leftDownPage - 1)*5 and num <= self.leftDownPage*5 then
					pos_x = pos_x + self.leftDownBtnList[i]:getContentSize().width/2
					local tween = {
						target = self.leftDownBtnList[i],
						{
								duration = 1,
								x = pos_x,
						}
					}
					TFDirector:toTween(tween)
					pos_x = pos_x + self.leftDownBtnList[i]:getContentSize().width/2 + 10
				else
					self.leftDownBtnList[i]:setVisible(false)
				end
			end
		end

		if num >= 5 and bFirst then
			pos_x = -50
			bFirst = false
		end
	end
	
	-- return index
end

function MenuLayer:showRightMiddeleButtonOpenAni( widget )
	local index = 0
	local pos_y = self.rightMiddleBtnList_pos
	for i=1,#self.rightMiddleBtnList do
		if self.rightMiddleBtnList[i] == widget then
			index = i
			pos_y = pos_y - self.rightMiddleBtnList[i]:getContentSize().height/2
			self.rightMiddleBtnList[i]:setPositionY(pos_y)
			pos_y = pos_y - self.rightMiddleBtnList[i]:getContentSize().height/2 - 10
			-- TFDirector:addTimer(1000,1,nil,function ()
			-- 			self.rightMiddleBtnList[i]:setVisible(true)
			-- 			self:refreshrightMiddleBtnList()
			-- 		end)
		else
			if self.rightMiddleBtnList[i]:isVisible() and index == 0 then
				pos_y = pos_y - self.rightMiddleBtnList[i]:getContentSize().height - 10
			end
			if self.rightMiddleBtnList[i]:isVisible() and index ~= 0 then
				pos_y = pos_y - self.rightMiddleBtnList[i]:getContentSize().height/2
				local tween = {
					target = self.rightMiddleBtnList[i],
					{
							duration = 1,
							y = pos_y,
					}
				}
				TFDirector:toTween(tween)
				pos_y = pos_y - self.rightMiddleBtnList[i]:getContentSize().height/2 - 10
			end
		end
	end
	return index
end
function MenuLayer:removeEvents()
    self.super.removeEvents(self)

    
	if self.onUpdateSevenDay then
		TFDirector:removeMEGlobalListener(SevenDaysManager.UpdateRedPoint,self.onUpdateSevenDay)	
		self.onUpdateSevenDay = nil
	end

    if self.UpdateRedPacketMsgCallBack then
    	TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateRedPacketMsg,self.UpdateRedPacketMsgCallBack)
		self.UpdateRedPacketMsgCallBack = nil
	end


    TFDirector:removeMEGlobalListener(SettingManager.changeProfessionSuccess ,self.changeProfessionCallBack)
    TFDirector:removeMEGlobalListener(StrategyManager.UPDATE_GENERRAL_LIST ,self.updateStrategyFormation)
	TFDirector:removeMEGlobalListener(MainPlayer.ResourceUpdateNotifyBatch ,self.updateUserDataCallBack)
	TFDirector:removeMEGlobalListener(MainPlayer.LevelChange ,self.levelVhangeCallBack)
	TFDirector:removeMEGlobalListener(RedPacketManager.RECEIVE_SEND_ATTRIBUTE_BRUSH ,self.updateRedPacketAttriCallBack)
	-- TFDirector:removeMEGlobalListener(RedPacketManager.RECEIVE_MY_RED_PACKET_INFO ,self.updateRedPacketAcheivAttriCallBack)
	self.levelVhangeCallBack = nil
	TFDirector:removeMEGlobalListener(ZhengbaManager.UPADTECHAMPIONSSTATUS ,self.upadteChampionsStatus)
	self.upadteChampionsStatus = nil
	TFDirector:removeMEGlobalListener(FactionFightManager.activityStateChange ,self.activityStateChangeCB)
	TFDirector:removeMEGlobalListener(KingOfWarManager.NeedSwitchLayerMsg ,self.activityStateChangeCB)
	self.upadteChampionsStatus = nil
	TFDirector:removeMEGlobalListener(MultiServerFightManager.updateActivityState ,self.updateActivityStateCB)
	TFDirector:removeMEGlobalListener(GuildBossManager.RECEIVE_ACTIVITY_STATE ,self.activityStateChangeCB)
	TFDirector:removeMEGlobalListener(FengYunLuManager.UPDATE_STATE ,self.activityStateChangeCB)
	self.updateActivityStateCB = nil

	TFDirector:removeMEGlobalListener(MainPlayer.ChallengeTimesChange ,self.updateUserDataCallBack)

	TFDirector:removeMEGlobalListener(OperationActivitiesManager.GET_ACITIVTY_REWARD_SUCCESS)
	TFDirector:removeMEGlobalListener(OperationActivitiesManager.ACITIVTY_REWARD_RECORD)

	-- OperationActivitiesManager:stopOnlineRewardTimer(1001)
	OperationActivitiesManager:removeOnlineRewardTimer(1001)

	TFDirector:removeMEGlobalListener("onSdkPlatformLogout", self.onSdkPlatformLogout)
	TFDirector:removeMEGlobalListener("onSdkPlatformLeave", self.onSdkPlatformLeave)


	TFDirector:removeMEGlobalListener(ChatManager.NewMarkChange  ,self.chatNewMarkChange)
	self.chatNewMarkChange = nil


	TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateNewChatMsg, self.updateKingOfWarNewMsg)
	TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateInvitationMsg, self.updateKingOfWarNewMsg)
	TFDirector:removeMEGlobalListener(AnniversaryManager.MSG_ACTIVITY_UPDATE,self.onUpdateZNQ)
	TFDirector:removeMEGlobalListener(AnniversaryManager.MSG_SIGN_UPDATE, self.onUpdateZNQ)
	self.updateKingOfWarNewMsg = nil

    TFDirector:removeMEGlobalListener(MainPlayer.TotalRechargeChange, self.totalRechargeChangeCallback)
    TFDirector:removeMEGlobalListener(PayManager.updateRecordList, self.totalRechargeChangeCallback)
    self.totalRechargeChangeCallback = nil

    TFDirector:removeMEGlobalListener(MainPlayer.ServerSwitchChange, self.serverSwitchChange)
    self.serverSwitchChange = nil

	if self.timeId then
        TFDirector:removeTimer(self.timeId)
        self.timeId = nil
    end

    if self.nTimerId then
        TFDirector:removeTimer(self.nTimerId)
        self.nTimerId = nil
        self.onUpdated = nil
    end

    if self.nTimerLoginOut then
    	TFDirector:removeTimer(self.nTimerLoginOut)
        self.nTimerLoginOut = nil
    end
    if self.addpanel_1Time then
    	TFDirector:removeTimer(self.addpanel_1Time)
		self.addpanel_1Time = nil
    end
	if (self.showRole) then
		TFDirector:removeTimer(self.showRole)
		self.showRole = nil
	end
    if HeitaoSdk then
		-- HeitaoSdk.setLoginOutCallBack(nil)
	end

	if self.activityTipTimerId then
        TFDirector:removeTimer(self.activityTipTimerId)
        self.activityTipTimerId = nil
        self.onUpdatedActivityTip = nil
    end
	
    TFDirector:removeMEGlobalListener(OperationActivitiesManager.MSG_ACTIVITY_UPDATE, self.activityUpdateCallBack)
    TFDirector:removeMEGlobalListener(PlayerGuideManager.BUTTON_OPEN  ,self.playerGuideButtonOpen)
    self.activityUpdateCallBack = nil

    SevenDaysManager:removeOnlineRewardTimer(1001)

    TFDirector:removeMEGlobalListener(MainPlayer.GAME_RESET, self.Game_12_oClock_reset)
    self.Game_12_oClock_reset = nil

    TFDirector:removeMEGlobalListener(FactionManager.newGuildApply, self.newGuildApplyCallBack)
    self.newGuildApplyCallBack = nil

    TFDirector:removeMEGlobalListener(JapanIslandManager.UpdateNewChatMsg, self.updateNewMsg)
	TFDirector:removeMEGlobalListener(JapanIslandManager.UpdateInvitationMsg, self.updateNewMsg)
	self.updateNewMsg = nil


	if self.bubbleDelayTime then
        TFDirector:removeTimer(self.bubbleDelayTime)
        self.bubbleDelayTime = nil
    end
    if self.bubbleMoveTime then
        TFDirector:removeTimer(self.bubbleMoveTime)
        self.bubbleMoveTime = nil
    end
	TFDirector:removeMEGlobalListener(ChatManager.ShowBubbleMsg, self.newChatMsgCallBack)
	self.newChatMsgCallBack = nil

	TFDirector:removeMEGlobalListener(NotifyManager.RETURN_NOTIFY_NUM, self.mailNumCallBack)
	self.mailNumCallBack = nil

	TFDirector:removeMEGlobalListener("UpdateInviteCodeInfo", self.inviteCodeCallBack)
	self.inviteCodeCallBack = nil

	TFDirector:removeMEGlobalListener(FanLiZhuanPanManager.UpdateRedPoint, self.onUpdateFLZP)
	self.onUpdateFLZP = nil

	TFDirector:removeMEGlobalListener(IllustrationManager.IllustrationUpdate, self.illustrationCallBack)
	self.illustrationCallBack = nil

	TFDirector:removeMEGlobalListener(HeadPicFrameManager.Init_Data, self.headPicFrameInitCallBack)
	self.headPicFrameInitCallBack = nil
	
	TFDeviceInfo:setOpenAccelerometer(false)
	TFDirector:removeMEGlobalListener("HeitaoSdk.ACCELEROMETER_UPDATE"  ,self.accelerometerUpdateCallBack)
	self.accelerometerUpdateCallBack = nil
	TFDirector:removeMEGlobalListener(KnightManager.KnightShareInfo, self.knightShareCallBack)
	self.knightShareCallBack = nil

	if self.updateTimerID then
		TFDirector:removeTimer(self.updateTimerID)
		self.updateTimerID = nil
	end
	if (self.subTimer) then
		TFDirector:removeTimer(self.subTimer)
		self.subTimer = nil
	end

	KnightManager:deleteKnightOnLineTime("MenuLayer")

	
	TFDirector:removeMEGlobalListener(WoodActivityManager.WOOD_MAN_PROGRESS, self.UpdateRedWood)
	self.UpdateRedWood = nil
end

function MenuLayer:setInfo()
	self.txt_vip:setVisible(true)
	self.img_vip:setVisible(false)

	self.txt_level:setText(MainPlayer:getLevel() .. "d")
	self.txt_vip:setText("o"..MainPlayer:getVipLevel())
	local totalPower = StrategyManager:getPower()
	--战力浮动不正确的原因
	-- if self.totalPower ~= totalPower then
	-- 	self.totalPower = totalPower
	-- 	CardRoleManager:reSortStrategy();
	-- end

	if self.totalPower ~= totalPower then
		self.totalPower = totalPower
		CardRoleManager:reSortStrategy();
	end
	self.txt_power:setText(self.totalPower)
	ZhengbaManager:setTotalPower(self.totalPower)
	--self.headImg:setTexture(MainPlayer:getIconPath())

	self.headImg:setTexture(MainPlayer:getIconPath())
    Public:addFrameImg(self.headImg,MainPlayer:getHeadPicFrameId())

	-- or ( CommonManager:isTuhao() and CommonManager:getTuhaoFreeTimes() > 0 )
	CommonManager:setRedPoint(self.headImg, HeadPicFrameManager:haveFirstGetFrame() or ( CommonManager:isTuhao() and CommonManager:getTuhaoFreeTimes() > 0 and MainPlayer:getFirstLogin() == true ),"isFirstGet",ccp(15,-5))
	local vipLevel = MainPlayer:getVipLevel()
	if vipLevel > 15 then
		self.txt_vip:setVisible(false)
		self.img_vip:setVisible(true)
		self:addVipEffect(self.img_vip)
	end
end

function MenuLayer:powerChange(oldPower,newPower)
	if self.toastLabel then
        self.toastLabel:removeFromParent();
    end

    local changeArrTemp = {}
    local changeLength = 0;
    local offset = newPower - oldPower;

    if offset == 0 then
        return;
    end
    
    local label = TFLabelBMFont:create();
    local img_path = "ui_new/home/zhandouli0.png"
    if offset > 0 then
        label:setFntFile("font/num_100.fnt")
        label:setText("+" .. offset);
        img_path = "ui_new/home/zhandouli.png"
    end

    if offset < 0 then
        label:setFntFile("font/num_99.fnt");
        label:setText(offset);
    end
    local sprite = CCSprite:create(img_path);

    local conSize = sprite:getContentSize();
    local conSize0 = label:getSize();

    local pos = self.img_power:getPosition();
    local anp = ccp((conSize.width + conSize0.width)*0.5/conSize.width,0.5)
    local posX0 = (1 - anp.x) * conSize.width + conSize0.width * 0.5 
    label:setPosition(posX0,0);

    sprite:setAnchorPoint(anp);

    sprite:setPosition(pos);
    sprite:addChild(label);
    self:addChild(sprite,10);
    self.toastLabel = sprite



    local toY = sprite:getPosition().y + 167;
    local toX = sprite:getPosition().x;
    
    sprite:setScale(0.5)
    sprite:setOpacity(0.1);
    local toastTween = {
          target = sprite,
          {
            duration = 7/24,
            x = toX,
            y = toY,
            scale = 1,
            alpha = 1,
          },
          {
            duration = 17/24,
            x = toX,
            y = toY+114,
            alpha = 0,
            onComplete = function() 
                if self.toastLabel then
                    self.toastLabel = nil
                end
                sprite:removeFromParent();
           end
          }
        }

    TFDirector:toTween(toastTween);

    self.txt_power:setText(oldPower);

    local changeSum = offset

    if self.power_effect == nil then
        local resPath = "effect/ui/power_change.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        effect = TFArmature:create("power_change_anim")

        self.txt_power:addChild(effect,2)
        self.power_effect = effect
        self.power_effect:setVisible(false)
    end

    local frame = 1
    self.txt_power:setScale(1)
    self.ui:setAnimationCallBack("Action1", TFANIMATION_FRAME, function()
        if frame == 11 then
            if newPower > oldPower then
                play_shuzibiandong()
            end
            self.power_effect:setVisible(true)
            self.power_effect:playByIndex(0, -1, -1, 0)
        end
        if frame >= 11 and frame < 34 then
            local tempValue = oldPower + (frame - 11) *(changeSum/23)
            self.txt_power:setText(math.floor(tempValue));
        end
        if frame == 34 then
            self.power_effect:removeFromParent()
            self.power_effect = nil
            self.txt_power:setText(newPower);
        end
        frame = frame + 1
    end)
    self.ui:runAnimation("Action1",1);
end

function MenuLayer:refreshTaskInfo()
	local firstDailyTask = TaskManager:GetFirstDailyTask()

	if firstDailyTask == nil then
		local textImg = TFDirector:getChildByPath(self.taskPanel, 'textImg')
		textImg:setVisible(false)
	else
		local textImg = TFDirector:getChildByPath(self.taskPanel, 'textImg')
		textImg:setVisible(true)

		local nameLabel = TFDirector:getChildByPath(self.taskPanel, 'nameLabel')
		nameLabel:setText(firstDailyTask.desc)

		local goBtn = TFDirector:getChildByPath(self.taskPanel, 'goBtn')
		if TaskManager:CanGoToLayer(firstDailyTask, false) then
			goBtn:setVisible(true)
			goBtn:addMEListener(TFWIDGET_CLICK, function() TaskManager:CanGoToLayer(firstDailyTask, true) end)
		else
			goBtn:setVisible(false)
		end
	end
end

--0是DB，1是Spine
function MenuLayer:AddButtonEffect(button, effName, posX, posY , animType)
	if animType == nil then
		animType = 0
	end
	local effect = button:getChildByName(effName)
	if (effect) then
		return
	end
	
	if animType == 0 then
		local resPath = "effect/"..effName..".xml"
		if not TFFileUtil:existFile(resPath) then
			print("anim is null path = ",resPath)
			return
		end
		TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
		effect = TFArmature:create(effName.."_anim")
		if effect == nil then
			return
		end
	else
		local resPath = "spine/"..effName..".json"
		if not TFFileUtil:existFile(resPath) then
			return
		end
		effect = SkeletonAnimation:create("spine/"..effName)
		if effect == nil then
			return
		end
	end

	effect:setAnimationFps(GameConfig.ANIM_FPS)
	effect:playByIndex(0, -1, -1, 1)
	effect:setPosition(ccp(posX, posY))
	effect:setName(effName)
	button:addChild(effect)
end

function MenuLayer:AddResEffect(button, effName, posX, posY, index)
	local effect = button:getChildByName(effName)
	if (effect) then
		return
	end
	TFResourceHelper:instance():addArmatureFromJsonFile("effect/"..effName..".xml")
	local effect = TFArmature:create(effName.."_anim")
	if effect == nil then
		return
	end

	-- effect:setAnimationFps(GameConfig.ANIM_FPS)
	effect:playByIndex(index, -1, -1, 1)
	effect:setName(effName)
	effect:setPosition(ccp(posX, posY))
	button:addChild(effect)
end

function MenuLayer:InitRoleList()
	-- local roleList = CardRoleManager:getUsedCardList()
	-- local roleNum = roleList:length()
	-- for i=1,roleNum do
	-- 	local cardRole = roleList:getObjectAt(i)
	-- 	self:AddRole(cardRole, i)
	-- end

	-- self:RemoveNoUseArmature()
	-- self:AddRolePosEffect()
	--
	if (self.showRole) then
		TFDirector:removeTimer(self.showRole)
		self.showRole = nil
	end
	local roleList = CardRoleManager:getUsedCardList()
	local roleNum = roleList:length()

	local isLoadDelay = false
	if (self.haveLoadList == nil) then
		isLoadDelay = true
	else
		local haveNum = 0
		for role in roleList:iterator() do
			if (self.haveLoadList[role.id]) then
				haveNum = haveNum + 1
			end
		end
		if (roleNum - haveNum > 2) then
			isLoadDelay = true
		end
	end

	local function addRoleComplete()
		self:RemoveNoUseArmature()
		self:AddRolePosEffect()
		if (self.showRole) then
			TFDirector:removeTimer(self.showRole)
			self.showRole = nil
		end
	end
	local function addRole(index)
		local cardRole = roleList:getObjectAt(index)
		if (cardRole) then
			self:AddRole(cardRole, index)
			self.haveLoadList[cardRole.id] = true
		else
			toastMessage(localizable.UITips_2)
		end
	end
	if (isLoadDelay) then
		self.haveLoadList = {}
		local addRoleIndex = 1
		self.showRole = TFDirector:addTimer(200, roleNum, addRoleComplete, 
						function()
							if (addRoleIndex > roleNum) then
								if (self.showRole) then
									TFDirector:removeTimer(self.showRole)
									self.showRole = nil
								end
								return 
							end
							addRole(addRoleIndex)
							addRoleIndex = addRoleIndex + 1
						end) 
	else
		self.haveLoadList = {}
		for i=1,roleNum do
			local cardRole = roleList:getObjectAt(i)
			self:AddRole(cardRole, i)
			self.haveLoadList[cardRole.id] = true
		end

		self:RemoveNoUseArmature()
		self:AddRolePosEffect()
	end
end

function MenuLayer:CreateArmature(roleID)
	local roleTableData = RoleData:objectByID(roleID)
	if roleTableData == nil then
		return nil
	end

	local resID = roleTableData.image
	
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
    GameResourceManager:addRole( roleID, armature)

	self.armatureList[roleID] = armature

	self.rolePanel:addChild(armature)

	return armature
end

function MenuLayer:RemoveNoUseArmature()
	local needRemove = false
	for roleID, armature in pairs(self.armatureList) do
		if not self:IsUsedArmature(roleID) then
			armature:removeFromParent()
			self.armatureList[roleID] = nil
			GameResourceManager:removeRole( roleID )
			needRemove = true
		end
	end
	if needRemove then
		me.ArmatureDataManager:removeUnusedArmatureInfo()
	end
end

function MenuLayer:IsUsedArmature(roleID)
	local roleList = CardRoleManager:getUsedCardList()
	local roleNum = roleList:length()
	for i=1,roleNum do
		local cardRole = roleList:getObjectAt(i)
		if cardRole ~= nil and cardRole.id == roleID then
			return true
		end
	end

	return false
end

function MenuLayer:HaveAnim(armature,animName)
    animName = animName..";"
    local movNames = armature:getMovementNameStrings()
    movNames = movNames..";"
    if string.find(movNames, animName) then
        return true
    else
        return false
    end
end

function MenuLayer:AddRole(roleInfo, pos)
	if pos > 5 then
		return
	end
	if (not roleInfo) then
		return
	end
	local newRole = false
	local armature = nil
	if self.armatureList[roleInfo.id] ~= nil then
		armature = self.armatureList[roleInfo.id]
	else
		armature = self:CreateArmature(roleInfo.id)
		newRole = true
	end

	if armature == nil then
		return
	end

	local posX = {0, -150, 150, -290, 290,}
	local posY = {-80, -50, -50, -10, -10, }
	local scale = {1.2, 1.1, 1.1, 1.0, 1.0,}

	local armaturePos = armature:getPosition()
	if armaturePos.x == posX[pos] and armaturePos.y == posY[pos] then
		return
	end

	armature:setPosition(ccp(posX[pos], posY[pos]))
	armature:setScale(scale[pos])
	armature:setZOrder(10-pos)
	armature:setName("armature"..pos)
	-- armature:play("stand", -1, -1, 1)

	if self:HaveAnim(armature,"stand") then
        armature:play("stand", -1, -1, 1)
    elseif self:HaveAnim(armature,"standl") then
        armature:play("standl", -1, -1, 1)
    end



	local role = CardRoleManager:getRoleById(roleInfo.id)
	local data = { scale = 0.5, posUp = ccp(0, 40) }
	Public:addRoleBgEffect(1, armature, role.starlevel, role.quality, data)
	local data1 = { scale = 0.5, posDown = ccp( 0, 0 ), zorder = -1 }
	Public:addRoleBgEffect(2, armature, role.starlevel, role.quality, data1)

	if  newRole  then
		self:AddRoleFootEffect(armature)
		armature:setTouchEnabled(true)
		local gmId = roleInfo.gmId
		armature:addMEListener(TFWIDGET_CLICK, audioClickfun(function() self.rolePanel:setZOrder(0) CardRoleManager:openRoleInfo(gmId) end))
	end
end

function MenuLayer:AddRoleFootEffect(roleArmature)
	TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role.xml")
	local effect = TFArmature:create("main_role_anim")
	if effect ~= nil and (not roleArmature.bgUpEffect) then
		effect:setAnimationFps(GameConfig.ANIM_FPS)
		effect:playByIndex(0, -1, -1, 1)
		roleArmature:addChild(effect)
	end

	TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role2.xml")
	local effect2 = TFArmature:create("main_role2_anim")
	-- if effect2 ~= nil and (not roleArmature.bgDownEffect) then
	if effect2 ~= nil then
		effect2:setAnimationFps(GameConfig.ANIM_FPS)
		effect2:playByIndex(0, -1, -1, 1)
		effect2:setZOrder(-2)
		effect2:setPosition(ccp(0, -10))
		roleArmature:addChild(effect2)
	end
end

function MenuLayer:AddRolePosEffect()
	local posX = {0, -150, 150, -290, 290,}
	local posY = {20, 50, 50, 90,90, }

	local fightRoleNum = StrategyManager:getFightRoleNum() 
	local maxNum = StrategyManager:getMaxNum()

	for i=1, 5 do
		local posEffect = self.posEffList[i]
		if i <= fightRoleNum then
			if posEffect ~= nil then
				posEffect:removeFromParent()
				self.posEffList[i] = nil
			end
		elseif i > fightRoleNum and i <= maxNum then
			if posEffect ~= nil and posEffect.index ~= 0 then
				posEffect:playByIndex(0, -1, -1, 1)
				posEffect.index = 0
				posEffect:addMEListener(TFWIDGET_CLICK, audioClickfun(function() CardRoleManager:openRoleList() end))
			end
			if posEffect == nil then
				posEffect = self:CreatePosEffect(i, "main_effect",0)
				posEffect:setPosition(ccp(posX[i], posY[i]))
			end
		else
			if posEffect ~= nil and posEffect.index ~= 1 then
				posEffect:playByIndex(1, -1, -1, 1)
				posEffect.index = 1
				local needLevel = FunctionOpenConfigure:getOpenLevel(700 + i)
				
				--posEffect:addMEListener(TFWIDGET_CLICK, audioClickfun(function() toastMessage("团队等级达到"..needLevel.."级开启该阵位") end))
				posEffect:addMEListener(TFWIDGET_CLICK, audioClickfun(function() toastMessage(stringUtils.format(localizable.common_open_position,needLevel) ) end))
			elseif posEffect == nil then
				posEffect = self:CreatePosEffect(i, "main_effect",1)
				posEffect:setPosition(ccp(posX[i], posY[i]))
			end
		end
	end
end

function MenuLayer:CreatePosEffect(pos, effName,index)
	
	local resPathXML = "effect/"..effName..".xml"
	local resPathAlats = "effect/"..effName..".atlas" 
	local effect
	
	if TFFileUtil:existFile(resPathAlats) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathAlats)
		local resPath = "effect/".. effName
		effect = SkeletonAnimation:create(resPath)
	elseif TFFileUtil:existFile(resPathXML) then
		TFResourceHelper:instance():addArmatureFromJsonFile(resPathXML)
		effect = TFArmature:create(effName.."_anim")
	else
		return
	end
	if effect == nil then
		print("CreatePosEffect == nil ",pos, effName,index)
		return nil
	end

	effect:setName("armature"..pos)
	effect:setAnimationFps(GameConfig.ANIM_FPS)
	effect:playByIndex(index, -1, -1, 1)
	effect.index = index
	self.posEffList[pos] = effect
	self.rolePanel:addChild(effect)

	effect:setTouchEnabled(true)
	if index == 0 then
		effect:addMEListener(TFWIDGET_CLICK, audioClickfun(function() CardRoleManager:openRoleList() end))
	else
		-- local posLev = {1, 1, 1, 4, 9}
		local needLevel = FunctionOpenConfigure:getOpenLevel(700 + pos)
		--effect:addMEListener(TFWIDGET_CLICK, audioClickfun(function() toastMessage("团队等级达到"..needLevel.."级开启该阵位") end))
		effect:addMEListener(TFWIDGET_CLICK, audioClickfun(function() toastMessage(stringUtils.format(localizable.common_open_position,needLevel)) end))
	end

	return effect
end

function MenuLayer.headClickHandle(sender)
	local self = sender.logic
	self:requestFirstLogin()
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.main.MainPlayerLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show();
end

function MenuLayer:requestFirstLogin()
	if MainPlayer:getFirstLogin() then
		TFDirector:send(c2s.FIRST_ONLINE_PROMPT_REQUEST, {})
		MainPlayer:setFirstLogin(false)
	end
end

function MenuLayer.roleBtnClickHandle(sender)
	--埋点id:9 点击布阵
	local PlayerGuideMgr = require("lua.gamedata.PlayerGuideManager")
    if (PlayerGuideMgr.now_step == 316) then
        TFDirector:send(c2s.DATA_COLLECT_REQUEST, {9})  
    end
	local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(1202)
    CommonManager:setRedPointStateByKey( "isHaveBook", false )
    if teamLev < openLev then
        CardRoleManager:openRoleList()
    else
        local layer = require("lua.logic.army.ArmyNewLayer"):new()
	    AlertManager:addLayer(layer)
	    layer:setOpenInfo(true)
	    AlertManager:show()
    end
end

function MenuLayer.equipBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "equipBtnRedPoint", false )
	EquipmentManager:OpenSmithyMainLaye()
end

function MenuLayer.onSevenDayPowerClickHandle(sender)
	SevenDayPowerManager:openSevenDaysPowerLayer()
end

function MenuLayer.bagBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "bagBtnRedPoint", false )
	BagManager:ShowBagLayer(0, 1)
end

function MenuLayer.employBtnClickHandle(sender)
	-- EmployManager:openHireTeamLayer(1)
	EmployManager:openEmployLayer()
end

function MenuLayer.eudemonBtnClickHandle(sender)
	-- EmployManager:openHireTeamLayer(1)
	EudemonManager:openEudemonListLayer()
end

function MenuLayer.shezhiClickHandle(sender)
	local layer = require("lua.logic.setting.SettingLayer"):new()
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show()
end

function MenuLayer.infoBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "isHaveUnReadMail", false )
	NotifyManager:ShowNotifyInfoLayer()
end

function MenuLayer.mallBtnClickHandle(sender)
	MallManager.bFirstOpen = false
	CommonManager:setRedPointStateByKey( "bFirstOpen", false )
	-- CommonManager:setRedPointStateByKey( "isHaveNewGoods", false )
	MallManager:openMallLayer()
end
function MenuLayer.zhaomuBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "isHaveGetCardFree", false )
	CommonManager:setRedPointStateByKey( "isHaveQiYuanFree", false )
	local PlayerGuideMgr = require("lua.gamedata.PlayerGuideManager")
    if (PlayerGuideMgr.now_step == 301) then
        --埋点id:8 点击主界面酒馆
        TFDirector:send(c2s.DATA_COLLECT_REQUEST, {8}) 
    end
	MallManager:openRecruitLayer()
end

function MenuLayer.chatClickHandle(sender)
	-- local self = sender.logic
	-- if self.bubbleDelayTime then
 --        TFDirector:removeTimer(self.bubbleDelayTime)
 --        self.bubbleDelayTime = nil
 --    end
 --    if self.bubbleMoveTime then
 --        TFDirector:removeTimer(self.bubbleMoveTime)
 --        self.bubbleMoveTime = nil
 --    end   
 --    self.bubbleNode:setVisible(false)
 	JapanIslandManager:setChatRedState(false)

	CommonManager:setRedPointStateByKey( "isHaveNewChat", false )
	ChatManager:showChatLayer()
end

function MenuLayer.taskBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "taskBtnRedPoint", false )
	TaskManager:ShowTaskLayer(1)
end

function MenuLayer.dailyTaskBtnClickHandle(sender)
	local teamLev   = MainPlayer:getLevel()
    local openLevel = FunctionOpenConfigure:getOpenLevel(1001)
    --  等级开发之后奇遇才会有红点
    if openLevel > teamLev then
    	--toastMessage("团队等级达到"..openLevel.."级开启")
		toastMessage(stringUtils.format(localizable.common_function_openlevel,openLevel))

        return
    end

    CommonManager:setRedPointStateByKey( "dailyTaskBtnRedPoint", false )
	TaskManager:ShowTaskLayer(0)
end

function MenuLayer.pvpBtnClickHandle(sender)
	local PlayerGuideMgr = require("lua.gamedata.PlayerGuideManager")
	if (PlayerGuideMgr.now_step == 801) then
		--埋点id:20 点击挑战
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {20})
	end

	CommonManager:setRedPointStateByKey( "pvpBtn", false )
	ActivityManager:showLayer(ActivityManager.TAP_Arena);
end

function MenuLayer.onBtnYouliClick( sender )
	local function callBack()
		CommonManager:setRedPointStateByKey( "btn_youli", false )
		AdventureManager:openHomeLayer()
	end
	Public:addChangeLayerEffect(callBack)
end

function MenuLayer.pveBtnClickHandle(sender)
	--埋点id:10 点击闯关按钮
	local playerLv = MainPlayer:getLevel()
	if (playerLv == 4) then
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {10})  
	end
	if DownResourceManager:needShowLayerForce() and MissionManager:isNeedForceDown() then
		DownResourceManager:openDownLayer()
		return
	end
	Public:addChangeLayerEffect(MissionManager.showHomeLayer)
 	-- MissionManager:showHomeLayer()
end

function MenuLayer.qiyuBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "isCodeCanGetReward", false )
	QiyuManager:OpenHomeLayer()
end

function MenuLayer.goldEggBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "btn_goldEgg", false )
	GoldEggManager:openGoldEggMainLayer()
end

function MenuLayer.xunBaoBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "btn_xunbao", false )
    TreasureManager:requestConfigMessage()
end

function MenuLayer.cmt2144BtnClickHandle( sender )
	if HeitaoSdk and HeitaoSdk.open2144Community then
		if type( HeitaoSdk.open2144Community ) == "function" then
			HeitaoSdk.open2144Community()
		end
	end
end

function MenuLayer.murenzhuangBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "btn_murenzhuang", false )
    WoodActivityManager:requestActivityInfo(true)
end

function MenuLayer.longmenpoBtnClickHandle( sender )
	CommonManager:setRedPointStateByKey( "btn_longmenpo", false )
	LongMenPoManager:openMainLayer()
end

function MenuLayer.signBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "IsSignToday", false )
    local layer  = require("lua.logic.qiyu.SignLayer"):new()
    AlertManager:addLayer(layer,AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
    AlertManager:show()
end

function MenuLayer.yuekaBtnClickHandle(sender)
	--埋点id:14 月卡
	local playerLv = MainPlayer:getLevel()
	if (playerLv == 4) then
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {14})
	end
	CommonManager:setRedPointStateByKey( "IsMonthCardCanGet", false )
	MonthCardManager:openMonthCardLayer()	
end

function MenuLayer.starheroBtnClickHandle(sender)
	if StarHeroManager:isOnValidTime() == false then
		toastMessage(localizable.star_hero_invalid_time_tip)
		return
	end
	CommonManager:setRedPointStateByKey( "btn_starhero", false )
	StarHeroManager:openMainLayer()
end

function MenuLayer.tianjilunBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "btn_tianjilun", false )
	TianJiLunManager:requestTianJiLunInfo(true)	
end

function MenuLayer.sevenRankBtnClickHandle(sender)
	--埋点id:16 大比拼
	local playerLv = MainPlayer:getLevel()
	if (playerLv == 4) then
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {16})
	end

	CommonManager:setRedPointStateByKey( "btn_sevenDayRank", false )
	--SevenDayRankManager:openSevenDaysRankLayer()
	SevenDayRankManager:requestGetConfig(true)
end


function MenuLayer.tujianBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "illustrationZhuanji", false )
	IllustrationManager:openIllustrationLayer()
end
function MenuLayer.youfangMallBtnClickHandle(sender)
	MallManager:openYouFangLayer()
end

function MenuLayer.gonglueBtnClickHandle(sender)
	local platformid = nil
	local userId 	 = nil

	if HeitaoSdk then
		platformid = HeitaoSdk.getplatformId()
		userId 	   = HeitaoSdk.getuserid()
	else
		platformid = "win2015"
		userId 	   = TFPlugins.getUserID()
	end
	local url = "http://"..MainPlayer:getHeiTaoUrl().."/curinfo/index"--?pfid="..platformid.."&psid=222&uid=333"
	if platformid then
		url = url.."?pfid="..platformid
	end
	local userInfo = SaveManager:getUserInfo()
    if userInfo.currentServer then
        psid = tonumber(userInfo.currentServer)
        url = url.."&psid="..psid
    end
	if userId then
		url = url.."&uid="..userId
	end
	TFDeviceInfo:openHeitaoWebUrl(url)
	-- 
end
-- 
function MenuLayer.onclickMoive(sender)
	local UserCenterHttpClient = TFClientNetHttp:GetInstance()
	local url = "http://hd.heitao.com/jh/survey/ajax_get_key"

    local userId 	 = nil
	if HeitaoSdk then
		userId	   = HeitaoSdk.getuserid()
	else
		userId	   = TFPlugins.getUserID()
	end
	-- userId		=11252894

	local httpPostCallback = function (type, ret, data)
		-- print("type = ",type)
		-- print("ret = ",ret)
		-- print("data = ",data)
		local post_data = json.decode(data)
		-- print("post_data = ",post_data)
		if post_data and post_data.md5 then
			local _url = string.format("http://hd.heitao.com/jh/survey?rid=%s&md5=%s",userId,post_data.md5)
			-- print("openUrl--------->>>>>",_url)
			TFDeviceInfo:openUrl(url)
		end
    end

	local vip = MainPlayer:getVipLevel()
	local level = MainPlayer:getLevel()
    -- rid,vip,level
    local sendData = string.format("rid=%s&vip=%d&level=%d",userId,vip,level)
    UserCenterHttpClient:addMERecvListener(httpPostCallback)
    -- print("requestServerList : ",TFHTTP_TYPE_POST,url,sendData)
	UserCenterHttpClient:httpRequest(TFHTTP_TYPE_POST,url,sendData)

	-- local url = "http://v.qq.com/iframe/player.html?vid=d0310e6oz2f&tiny=0&auto=0"
	-- TFDeviceInfo:openUrl(url)
end

function MenuLayer.onclickSevenDay(sender)
	--埋点id:12 七日活动奖励
	local playerLv = MainPlayer:getLevel()
	if (playerLv == 4) then
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {12})
	end
	CommonManager:setRedPointStateByKey( "isCodeCanGetReward1", false )
	SevenDaysManager:enterSevenDaysLayer()
end



function MenuLayer.paihangBtnClickHandle(sender)
	-- OperationActivitiesManager:openleaderBoard()
	local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.leaderboard.Leaderboard.lua")
	layer:setIndex(1)
    AlertManager:show();
end

function MenuLayer.huodongBtnClickHandle(sender)
	print("-------------MenuLayer.huodongBtnClickHandle")
	-- 埋点id:17.29  活动
	local playerLv = MainPlayer:getLevel()
	if (playerLv == 4 or playerLv == 20) then
		local buriedId = 0
		if (playerLv == 4) then
			buriedId = 17
		elseif (playerLv == 20) then 
			buriedId = 29
		end
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {buriedId})
	end
	
	CommonManager:setRedPointStateByKey( "OperationActivitiesManager", false )
	OperationActivitiesManager:openHomeLayer(0)
end
function MenuLayer.huodongImportBtnClickHandle(sender)
	print("-------------MenuLayer.huodongImportBtnClickHandle")
	CommonManager:setRedPointStateByKey( "OperationActivitiesManager_outside", false )
	OperationActivitiesManager:openHomeLayer(1)
end
--限时兑换
function MenuLayer.huodongExchageBtnClickHandle(sender)
	print("-------------MenuLayer.huodongExchageBtnClickHandle")
	OperationActivitiesManager:openHomeLayer(3)
end
function MenuLayer.btnTimeLimitMallClick(sender)
	-- print("-------------MenuLayer.huodongImportBtnClickHandle")
	-- CommonManager:setRedPointStateByKey( "OperationActivitiesManager_outside", false )
	OperationActivitiesManager:openHomeLayer(2)
end

function MenuLayer.OnlineBtnClickHandle(sender)
	-- OperationActivitiesManager:getOnlineReward()
	--埋点id:11 在线礼包奖励
	local playerLv = MainPlayer:getLevel()
	if (playerLv == 4) then
		TFDirector:send(c2s.DATA_COLLECT_REQUEST, {11})
	end
	OperationActivitiesManager:requestReceiveOnlineReward()
end

-- 在线奖励
function MenuLayer:getOnlineRewardUpdate(data)
	if data and data.onlineRewardCount then
		self.onlineRewardCount = data.onlineRewardCount + 1
		self.timeCount = 45
	end
	-- self.timeCount = 45
end

function MenuLayer:AddBgImgEffect()
	TFResourceHelper:instance():addArmatureFromJsonFile("effect/ui/mainbg/main_bg_1.xml")
	local effect = TFArmature:create("main_bg_1_anim")
	effect:setAnimationFps(GameConfig.ANIM_FPS)
	effect:playByIndex(0, -1, -1, 1)
	local uiSize = self.bg:getSize()
	-- effect:setPosition(ccp(uiSize.width/2, uiSize.height/2))
	effect:setPosition(ccp(0, 0))
	ViewSizeCheck(effect, 0.2)
	self.noonEffect_1 = effect
	self.bg_front:addChild(effect)

	TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_bg1.xml")
	local eff2 = TFArmature:create("main_bg1_anim")
	eff2:setAnimationFps(GameConfig.ANIM_FPS)
	eff2:playByIndex(0, -1, -1, 1)
	eff2:setZOrder(1000)
	eff2:setVisible(false)
	ViewSizeCheck(eff2, 0.2)
	self.noonEffect_2 = eff2
	self.rolePanel:addChild(eff2)
end
function MenuLayer:initNightScene(isnight)
	self.isnightShow = self.isnightShow or false
	if self.isnightShow == isnight then
		return
	end
	self.isnightShow = isnight
	if isnight == false then
		self.noonEffect_1:setVisible(true)
		self.noonEffect_2:setVisible(true)
		if self.nightEffect_1 then
			self.nightEffect_1:setVisible(false)
			self.nightEffect_2:setVisible(false)
		end
		self.bg:setTexture("ui_new/home/main_bg.png")
		return
	end
	self.noonEffect_1:setVisible(false)
	self.noonEffect_2:setVisible(false)

	if self.nightEffect_1 == nil then
		TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_bg_night_1.xml")
		local effect = TFArmature:create("main_bg_night_1_anim")
		effect:setAnimationFps(GameConfig.ANIM_FPS)
		effect:playByIndex(0, -1, -1, 1)
		local uiSize = self.bg:getSize()
		effect:setPosition(ccp(uiSize.width/2, uiSize.height/2))
		self.bg:addChild(effect)
		self.nightEffect_1 = effect

		TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_bg_night_2.xml")
		local _effect = TFArmature:create("main_bg_night_2_anim")
		_effect:setAnimationFps(GameConfig.ANIM_FPS)
		_effect:playByIndex(0, -1, -1, 1)
		_effect:setPosition(ccp(uiSize.width/2, uiSize.height/2))
		self.bg:addChild(_effect)
		self.nightEffect_2 = _effect
	end
	self.nightEffect_1:setVisible(true)
	self.nightEffect_2:setVisible(true)
	self.bg:setTexture("ui_new/home/main_bg_night.png")
end

function MenuLayer:playOnlineEffect()
	
	if self.OnlineEffect == nil  then
        local resPath = "effect/onlinereward.xml"
        TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
        local effect = TFArmature:create("onlinereward_anim")
        local node   = self.btn_zaixian --:getParent() --node:getPosition()

        effect:setAnimationFps(GameConfig.ANIM_FPS)

        node:addChild(effect,2)
        -- effect:setPosition(ccp(0,-36))
        --effect:setPosition(ccp(1,-62))
        effect:setPosition(ccp(3,-60))

        effect:setAnchorPoint(ccp(0.5, 0.5))
        self.OnlineEffect = effect
    

    	self.OnlineEffect:playByIndex(0, -1, -1, 1)
	end
end

-- 结束
function MenuLayer:stopOnlineEffect()
	if self.OnlineEffect then
		self.OnlineEffect:removeFromParent()
        self.OnlineEffect = nil
	end

	-- if OperationActivitiesManager:isGetAllOnlineReward() then
	if OperationActivitiesManager:AllOnlineRewardIsReceived() then
		self.btn_zaixian:setVisible(false)
	end
end

-- pp
function MenuLayer.PlatformBtnClickHandle(sender)
	-- if TFPlugins.getChannelId() ~= "" then
	if TFPlugins.isPluginExist() then
		TFPlugins.EnterPlatform()
		return
	else

	end
end
function MenuLayer.friendBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "btn_friends", false )
	FriendManager:openFriendMainLayer()
end
function MenuLayer.factionBtnClickHandle(btn)
	CommonManager:setRedPointStateByKey( "btn_faction", false )

	local function callBack()
		FactionManager:openFactionFromHomeIcon()
	end
	if FactionManager:isJoinFaction() then
		Public:addChangeLayerEffect(callBack)
	else
		callBack()
	end
end

--开服大礼活动按钮回调
function MenuLayer:kaiFuDaLiClickHandle()
	SevenDaysManager:openKaiFuDaLiLayer()
end

--赶年兽活动按钮回调
function MenuLayer:ganNianShouClickHandle()
	NianShouManager:requestOpenNianShouMainLayer()
end

--打年兽活动按钮回调
function MenuLayer:DaNianShouClickHandle()
	DaNianShouManager:requireRankRefresh()
	DaNianShouManager:requestOpenDaNianShouMainLayer()
end

-- 江湖聚惠
function MenuLayer:jianghujuhuiClickHandle(  )
	JiangHuJuHuiManager:openJiangHuJuHuiLayer()
end
--返利转盘活动按钮回调
function MenuLayer:fanLiZhuanPanClickHandle()
	FanLiZhuanPanManager:requireZhuanPanInfo()
end
--琅嬛福地活动按钮回调
function MenuLayer.onLangHuanClickHandle(sender)
	LangHuanManager:openLangHuanMainLayer()
end
--至尊金卡回调
function MenuLayer.onGoldenCardClickHandle(sender)
	GoldenCardManager:openMainLayer()
end
--风云录
function MenuLayer.FengYunLuBtnClickHandle(sender)
	FengYunLuManager:senderFengYunLuInfo()
end
--答题
function MenuLayer.DaTiBtnClickHandle(sender)
	DaTiManager:openDaTiMainLayer()
end
function MenuLayer.onZhouNianQingClickHandle(sender)
	AnniversaryManager:openHomeLayer()
end

function MenuLayer.changeBtnClickHandle(sender)
	local self = sender.logic

	if self:getLeftDownWidgetShowNum() <= 5 then
		return
	end

	sender.logic:turnChange()
end

function MenuLayer.playBackBtnClickHandle(sender)
	CommonManager:setRedPointStateByKey( "playerBackBtn", false )
	PlayBackManager:showPlayerBackMainLayer()
end

function MenuLayer:turnChangeToIndex( index)
	self.leftDownPage = index
    self:refreshLeftDownBtnList()
    --self.ischang = false
    --local pic = TFDirector:getChildByPath(self, 'img_change')
	--local ratato = (2 - self.leftDownPage )*45
	--pic:setRotation(ratato)

	self.btn_change:setVisible(true)
	if self.leftDownPage == 2 then
		self.img_di:setVisible(true)
	else
		self.img_di:setVisible(false)
	end

	self.img_change:setTexture(pointerPic[self.leftDownPage])
end
function MenuLayer:turnChangeTowidget( widget)
	PlayerGuideManager:addLongTimeGuide(self, self.pveBtn, 1, false )
	local widget_index = self:getWidgetInLeftDownPageIndex( widget )
	if widget_index == 0 then
		return
	end
	local page = math.ceil(widget_index/5)
	if self.leftDownPage == page then
	else
		self:turnChangeToIndex( page)
	end
end

function MenuLayer:turnChange(func)
	--[[
	if self.ischang == true then
		-- if func then
		-- 	func()
		-- end
		return
	end
	self.btn_change:setVisible(true)
	self.ischang = true
	local tween = {
		target = self.panel_rightDown,
		{
			duration = 0.3,
			x = -560,
			onComplete = function()
                self.leftDownPage = 3 - self.leftDownPage
                self:refreshLeftDownBtnList()
                self.btn_change:setVisible(true)
            end
		},
		{
			duration = 0.3,
			x = 0,
			onComplete = function()
                self.ischang = false
                if func then
					func()
                end
            end
		}
	}
	TFDirector:toTween(tween)

	local pic = TFDirector:getChildByPath(self, 'img_change')
	local ratato = (2 - self.leftDownPage )*45
	local pic_tween = {
		target = pic,
		{
			duration = 0.6,
			rotate = ratato,
			onComplete = function()
                pic:setRotation(ratato)
            end
		},
	}
	TFDirector:toTween(pic_tween)
	]]

	self.btn_change:setVisible(true)
	self.ischang = true

	self.leftDownPage = 3 - self.leftDownPage
    self:refreshLeftDownBtnList()
    self.btn_change:setVisible(true)
    if func then
		func()
    end

	local pic = TFDirector:getChildByPath(self, 'img_change')

	if self.leftDownPage == 2 then
		self.img_di:setVisible(true)
	else
		self.img_di:setVisible(false)
	end

	--self.btn_change:setTextureNormal(pointerPic[self.leftDownPage])
	self.img_change:setTexture(pointerPic[self.leftDownPage])
end

function MenuLayer:gotoLayerByType( layer_type )
	AlertManager:closeAll()
	if layer_type == 1 then  			--酒馆
		MallManager:openRecruitLayer()		
	elseif layer_type == 2 then  			--侠客属性面板
		CardRoleManager:openRoleInfo(CardRoleManager:getRoleById(MainPlayer:getProfession()).gmId)
	elseif layer_type == 3 then  			--布阵
		CardRoleManager:openRoleList()
	elseif layer_type == 4 then  			--装备强化界面
		EquipmentManager:OpenSmithyMainLaye()		
	elseif layer_type == 5 then   			--考校
		KaojiaoManager:openKaojiaoLayer()
	end
end

function MenuLayer:isButtonOpen( info )
	if info.level then
		local level = MainPlayer:getLevel()
		if level < info.level then
			return false
		end
	end
	if info.guide then
		if PlayerGuideManager:isFunctionOpen(info.guide) == false then
			return false
		end
	end
	return true
end

function MenuLayer:refreshBtnVisible()
	local factionLock = VersionLockData:objectByID(EnumVersionLockType.Faction_Lock)
	for info in MenuBtnOpenData:iterator() do
		local widget = TFDirector:getChildByPath(self, info.btnName)
		if widget then
			if widget.isOpen or self:isButtonOpen(info) then
				widget:setVisible(true)
				widget.isOpen = true
				if widget == self.qiyuBtn and QiyuManager:QiyuFuctionIsOpen() == false then
					widget:setVisible(false)
				elseif widget == self.btn_sevenday and SevenDaysManager:sevenDaysOpenSatus() == 0 then
					widget:setVisible(false)
				elseif widget == self.btn_faction and factionLock and factionLock.open == 0 then
					widget.isOpen = false
				elseif widget == self.btn_eudemon and MainPlayer:getServerSwitchStatue(ServerSwitchType.Eudemon) == false then
					widget:setVisible(false)
				end
			else
				widget:setVisible(false)
				widget.isOpen = false
			end
		else
			print("widget == nil btnName == ",info.btnName)
		end
	end
	self:refreshYouliButton()
	self:refreshLeftDownBtnList()
	self:refreshRightMiddleBtnList()

end

function MenuLayer:refreshBtnVisibleWithLevel()
	local level = MainPlayer:getLevel()
	for info in MenuBtnOpenData:iterator() do
		local widget = TFDirector:getChildByPath(self, info.btnName)
		if widget then
			if info.level and info.level == level then
				widget:setVisible(true)
			end
		else
			print("widget == nil btnName == ",info.btnName)
		end
	end
end

function MenuLayer:refreshActivityBubbles()
	
	if  not ActivityTipManager.isCanTip then
		return
	end
	ActivityTipManager:sortByStatus()
	local activityData=ActivityTipManager:getMostRventNotice()
	TFDirector:getChildByPath(self.img_qipao, 'txt_time'):setText(stringUtils.format(localizable.activity_time_tip, activityData.TimeBegin[1], activityData.TimeBegin[2],activityData.TimeEnd[1],activityData.TimeEnd[2]))
	TFDirector:getChildByPath(self.img_qipao, 'txt_miaoshu'):setText(activityData.name)
	ActivityTipManager.isCanTip=false
	local toastTween = {
              target = self.img_qipao,
              {
                duration = 0,
                alpha = 0,
              },
              {
                duration = 0,
                onComplete = function() 
                    self.img_qipao:setVisible(true)
                end
              },
              { 
                duration = 0,
                delay = 1
              },
              {
                duration = 0.5,
                alpha = 1,
              },
              { 
                duration = 0.5,
                alpha = 0,
                delay = 20
              },
              {
                duration = 0,
                onComplete = function() 
                    self.img_qipao:setVisible(false)
                end
              }
        }
    TFDirector:toTween(toastTween);
end
-- 计算左下角快捷图标位置
function MenuLayer:setActivityBtnPosX( index )
	
	function getActivityCount( index )
		local addCount = 0
		if (self.btn_zhengbasai and self.btn_zhengbasai:isVisible()) then
			addCount = addCount + 1
		end
		if (index == ActivityBtn.kfFight) then 
			return addCount 
		end
		if (self.btn_kfFight and self.btn_kfFight:isVisible()) then
			addCount = addCount + 1
		end
		if (index == ActivityBtn.crossGuild) then 
			return addCount 
		end
		if (self.btn_crossGuildBattle and self.btn_crossGuildBattle:isVisible()) then
			addCount = addCount + 1
		end
		if (index == ActivityBtn.kingWar) then 
			return addCount 
		end
		if (self.kingWarBtn and self.kingWarBtn:isVisible()) then
			addCount = addCount + 1
		end
		if (index == ActivityBtn.wuLinEnemy) then 
			return addCount 
		end
		if (self.btn_wulinenemy and self.btn_wulinenemy:isVisible()) then
			addCount = addCount + 1			
		end
		if (index == ActivityBtn.biaoChe) then 
			return addCount 
		end
		if (self.btn_biaoche and self.btn_biaoche:isVisible()) then
			addCount = addCount + 1			
		end
		if (index == ActivityBtn.fengyunLu) then 
			return addCount 
		end 
		if (self.btn_fyl and self.btn_fyl:isVisible()) then
			addCount = addCount + 1	
		end
		if (index == ActivityBtn.dati) then
			return addCount 
		end

	end
	local btnCount = getActivityCount( index )
	local posX = self.btn_zhengbasai:getPosition().x
	posX = posX + btnCount*80
	return posX
end

function MenuLayer:refreshZhengbaBtn()
	
	self.btn_zhengbasai:setVisible(false)
	
    if ZhengbaManager:getActivityStatus() ~= 1 and MainPlayer:getLevel() >= 35 then
    	local verLock = VersionLockData:objectByID(EnumVersionLockType.Zhengba_Lock)
		if verLock == nil or verLock.open ~= 0 then
			self.btn_zhengbasai:setTextureNormal("ui_new/home/main_wldh_btn.png")
			self.btn_zhengbasai:setVisible(true)
		end
	elseif FactionFightManager:getActivityState() == FactionFightManager.ActivityState_3 then
		local verLock = VersionLockData:objectByID(EnumVersionLockType.FactionFight_Lock)
		if verLock == nil or verLock.open ~= 0 then
			local nowDate = GetCorrectDate("*t",MainPlayer:getNowtime())
			local sec = nowDate.hour*60*60 + nowDate.min*60
			local desSec = 19*60*60 + 30*60
			if nowDate.wday == 6 and (sec < desSec) then
				self.btn_zhengbasai:setTextureNormal("ui_new/home/main_bpzf_btn.png")
				self.btn_zhengbasai:setVisible(true)
			end
		end
    end
	
    self:refreshKfFightBtn()
    self:refreshCrossGuildBattleBtn()
    self:refreshKingWarBattleBtn()
    self:refreshWuLinEnemyBtn()
    self:refreshGuildBossBtn()
    self:refreshBiaoCheBtn()
    self:refreshFengYunLuBtn()
    self:refreshDaTiBtn()
end

function MenuLayer:refreshGuildBossBtn()
	if self.btn_guildBoss == nil then
		self.btn_guildBoss = self.btn_crossGuildBattle:clone()
		local parent = self.btn_crossGuildBattle:getParent()
		parent:addChild(self.btn_guildBoss)
		self.btn_guildBoss:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onGuildBossBtnClick),1)
		self.btn_guildBoss:setTextureNormal("ui_new/home/main_ywc.png")
	end
	
	self.btn_guildBoss:setVisible(false)

	local openLevel = ConstantData:objectByID("GuildBoss.OpenLevel").value
    local factionInfo = FactionManager:getFactionInfo()
    if factionInfo == nil or factionInfo.level == nil then  
        return
    end
    print("refreshGuildBossBtn")
	if GuildBossManager:getServerSwitch() ~= true then
		return
	end
    if factionInfo.level < openLevel then
    	return
    end
    local btnList = {self.btn_zhengbasai,
	    self.btn_kfFight,
	    self.btn_crossGuildBattle,
	    self.kingWarBtn,
	    self.btn_wulinenemy,
	    self.btn_biaoche,
	    self.btn_fyl,
	    self.btn_daTi
	}
	local state = GuildBossManager:getActivityState()
    if state == GuildBossManager.ActivityState_3 then
		local addCount = 0
		for i,v in ipairs(btnList) do
			if v:isVisible() then
				addCount = addCount + 1
			end
		end
		local pos = self.btn_zhengbasai:getPosition()
		pos.x = pos.x + addCount*105
		self.btn_guildBoss:setPosition(pos)
		self.btn_guildBoss:setVisible(true)
    end
end

--
function MenuLayer:refreshKfFightBtn()
	
	-- local verLock = VersionLockData:objectByID(EnumVersionLockType.MultiServerFight_Lock)
 --    if verLock == nil or verLock.open ~= 0 then
	-- 	if self.btn_zhengbasai:isVisible() then
	-- 		self.btn_kfFight:setPosition(self.btn_kfFightXY)
	-- 	else
	-- 		self.btn_kfFight:setPosition(self.btn_zhengbasai:getPosition())
	-- 	end
	-- 	local state = MultiServerFightManager:getActivityState()
	-- 	if state and (state >= 1 and state < 9) then
	-- 		self.btn_kfFight:setVisible(true)
	--     end
	-- end
	self.btn_kfFight:setVisible(false)	
	local verLock = VersionLockData:objectByID(EnumVersionLockType.MultiServerFight_Lock)
    if verLock == nil or verLock.open ~= 0 then
		local state = MultiServerFightManager:getActivityState()
		if state and (state >= 1 and state < 9) then
			self.btn_kfFight:setVisible(true)
			local posX = self:setActivityBtnPosX(ActivityBtn.kfFight)
			self.btn_kfFight:setPositionX(posX)		
	    end
	end
end

function MenuLayer:refreshCrossGuildBattleBtn()
	self.btn_crossGuildBattle:setVisible(false)
	local verLock = VersionLockData:objectByID(EnumVersionLockType.CrossFight_Lock)
    if verLock == nil or verLock.open ~= 0 then
		local state = CrossGuildBattleManager:getActivityState()
		if state and (state >= 1 and state <= 3) then
			local posX = self:setActivityBtnPosX(ActivityBtn.crossGuild)
			self.btn_crossGuildBattle:setPositionX(posX)
			self.btn_crossGuildBattle:setVisible(true)
	    end
	end
end

function MenuLayer:refreshWuLinEnemyBtn()
	if self.btn_wulinenemy == nil then
		self.btn_wulinenemy = self.btn_crossGuildBattle:clone()
		local parent = self.btn_crossGuildBattle:getParent()
		parent:addChild(self.btn_wulinenemy)
		self.btn_wulinenemy:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onWuLinEnemyBtnClick),1)
		self.btn_wulinenemy:setTextureNormal("ui_new/home/btn_wlgdentrance.png")
	end
	
	self.btn_wulinenemy:setVisible(false)
	local state = WuLinEnemyManager:getActivityState()

	local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2229)
   
    if teamLev >= openLev and state == WuLinEnemyManager.ActivityState_1 then
		self.btn_wulinenemy:setVisible(true)
		local posX = self:setActivityBtnPosX(ActivityBtn.wuLinEnemy)
		self.btn_wulinenemy:setPositionX(posX)		
    end

end

function MenuLayer:refreshKingWarBattleBtn()
	if self.kingWarBtn == nil then
		self.kingWarBtn = self.btn_crossGuildBattle:clone()
		local parent = self.btn_crossGuildBattle:getParent()
		parent:addChild(self.kingWarBtn)
		self.kingWarBtn:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onKingWarBtnClick),1)
		self.kingWarBtn:setTextureNormal("ui_new/home/main_kingw.png")
	end
	
	self.kingWarBtn:setVisible(false)
	local state = KingOfWarManager:getActivityState()
	local open 	= MainPlayer:getServerSwitchStatue(ServerSwitchType.KingOfWar)
	if open and state and (state >= KingOfWarManager.ActivityState_SignUp and state <= KingOfWarManager.ActivityState_Result) then
		self.kingWarBtn:setVisible(true)
		local posX = self:setActivityBtnPosX(ActivityBtn.kingWar)
		self.kingWarBtn:setPositionX(posX)		
    end
end
--刷新镖车按钮
function MenuLayer:refreshBiaoCheBtn()
	if (self.btn_biaoche == nil) then
		self.btn_biaoche = self.btn_crossGuildBattle:clone()
		local parent = self.btn_crossGuildBattle:getParent()
		parent:addChild(self.btn_biaoche)
		self.btn_biaoche:addMEListener(TFWIDGET_CLICK, audioClickfun(self.onBiaoCheBtnClick),1)
		self.btn_biaoche:setTextureNormal("ui_new/home/main_bxtx_btn.png")
	end
	
	self.btn_biaoche:setVisible(false)

	if (MainPlayer:getServerSwitchStatue(ServerSwitchType.BiaoCheSwitch ) ==false) then
		return
	end
	local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2220)
    if (teamLev < openLev) then
    	return
    end

	local state = BiaoCheManager:getActivityState()
    if (state == BiaoCheManager.ActivityState_1 or state == BiaoCheManager.ActivityState_2) then
		self.btn_biaoche:setVisible(true)
		local posX = self:setActivityBtnPosX(ActivityBtn.biaoChe)
		self.btn_biaoche:setPositionX(posX)	
    end
end
-- 刷新风云录按钮
function MenuLayer:refreshFengYunLuBtn()
	self.btn_fyl:setVisible(false)
	local state = FengYunLuManager:getStartOrClose()
	if state and state == 1 then
		local posX = self:setActivityBtnPosX(ActivityBtn.fengyunLu)
		self.btn_fyl:setPositionX(posX)
		self.btn_fyl:setVisible(true)
	end
end
-- 刷新答题按钮
function MenuLayer:refreshDaTiBtn()
	self.btn_daTi:setVisible(false)
	local state = DaTiManager:getStartOrClose()
	if state then
		local posX = self:setActivityBtnPosX(ActivityBtn.dati)
		self.btn_daTi:setPositionX(posX)
		self.btn_daTi:setVisible(true)
	end
end

function MenuLayer:refreshBuffEffectShow()
	local effectList = {}
	effectList[#effectList+1] = self:refreshYueCardMonthBuff()
	effectList[#effectList+1] = self:refreshRedPacketBuff()

	for i=1,#effectList do
		if effectList[i] then
			local posx = - 40 - (#effectList - 1) * 0.5 * 100   + (i - 1) * 100
			effectList[i]:setPosition(posx,200)
		end
	end
end

function MenuLayer:refreshRedPacketBuff()
	local bRedPacket = RedPacketManager:IsHaveSendAttri()

	print("------MonthCard status= ", bOwnMonth)
	if self.RedPacketBuffEffect == nil then
		if bRedPacket == true then
			local resPath = "effect/effect_main_rp_buff.xml"
			TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
			local effect = TFArmature:create("effect_main_rp_buff_anim")
			if effect == nil then
				return nil
			end

			effect:setAnimationFps(GameConfig.ANIM_FPS)
			effect:setZOrder(10)
			effect:playByIndex(0, -1, -1, 1)
			effect:setPosition(ccp(-40,220))
			self.rolePanel:addChild(effect)

			effect:setTouchEnabled(true)
			effect:addMEListener(TFWIDGET_CLICK, audioClickfun(function() self:openRedPacketTips() end))

			self.RedPacketBuffEffect = effect
		end
	else
		if bRedPacket == false then
			self.RedPacketBuffEffect:removeFromParent()
			self.RedPacketBuffEffect = nil
		end
	end
	return self.RedPacketBuffEffect
end

function MenuLayer:openRedPacketTips()
	local sendData = RedPacketManager.curSendData
	if sendData == nil or sendData.id == nil then
		print('sendData == nil or sendData.id == nil')
		return
	end

	local title = localizable.RedPacket_buff_tittle
	if title[sendData.id] == "" then
		print('title[sendData.id] == \"\"')
		return
	end
	local content = localizable.RedPacket_buff_content
	local layer =  AlertManager:addLayerByFile("lua.logic.common.TipsMessage", AlertManager.BLOCK_AND_GRAY_CLOSE)
    layer:setText(title[sendData.id], content[sendData.id])
    AlertManager:show()
end


function MenuLayer:refreshYueCardMonthBuff()
	local bOwnMonth = MonthCardManager:isExistMonthCard(MonthCardManager.CARD_TYPE_2)

	print("------MonthCard status= ", bOwnMonth)
	if self.MonthCardBuffEffect == nil then
		-- MonthCardManager:isExistMonthCard(MonthCardManager.CARD_TYPE_2)
		-- 有月卡 创建
		print("111111111111111")
		if bOwnMonth == true then
			local resPath = "effect/effect_main_role_buf.xml"
			TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
			local effect = TFArmature:create("effect_main_role_buf_anim")
			if effect == nil then
				return nil
			end

			effect:setAnimationFps(GameConfig.ANIM_FPS)
			effect:setZOrder(10)
			effect:playByIndex(0, -1, -1, 1)
			effect:setPosition(ccp(-40,220))
			self.rolePanel:addChild(effect)

			effect:setTouchEnabled(true)
			effect:addMEListener(TFWIDGET_CLICK, audioClickfun(function() self:openMonthCardTips() end))

			self.MonthCardBuffEffect = effect
		end
	else

		print("222222222")
		if bOwnMonth == false then
			self.MonthCardBuffEffect:removeFromParent()
			self.MonthCardBuffEffect = nil
		end
	end
	return self.MonthCardBuffEffect
end

function MenuLayer:openMonthCardTips()
-- 	-- toastMessage("12")
-- 	月卡TIPS调整：
-- 您是尊贵的豪侠月卡会员，月卡持续时间内主角 武力、内力+500 每级额外+5点
-- 武力 =  500 + 团队等级*5
-- 内力 =  500 + 团队等级*5
	local layer =  AlertManager:addLayerByFile("lua.logic.common.TipsMessage", AlertManager.BLOCK_AND_GRAY_CLOSE)
	--local title = "豪侠月卡"
	local title = localizable.menuLayer_monthcard
	--local content = "您是尊贵的豪侠月卡会员，月卡持续时间内主角额外获得：\n武力 =  500 + 团队等级*5\n内力 =  500 + 团队等级*5"
	local content = localizable.menuLayer_monthcard_addattr
    layer:setText(title, content)

    AlertManager:show()
end

-- function MenuLayer.onSdkPlatformLogout(event)
-- 	-- toastMessage("---------MenuLayer.onSdkPlatformLogout ")
-- 	SettingManager:gotoLoginLayer()
-- end

-- function MenuLayer.onSdkPlatformLeave(event)
-- 	toastMessage("---------MenuLayer.onSdkPlatformLeave ")
-- 	-- toastMessage("---------MenuLayer.onSdkPlatformLeave ")
-- end
--[[
self.leftDownBtnList = {
		self.roleBtn,
		self.equipBtn,
		self.bagBtn,
		self.taskBtn,
		self.mallBtn,
		self.zhaomuBtn,
		self.btn_friends,
		self.btn_faction,
	}
]]
function MenuLayer:updateChangeBtnRedPoint()
	CommonManager:removeRedPoint(self.btn_change)

	local index = 3-self.leftDownPage
	local num = 0

	for i=1,#self.leftDownBtnList do
		if self.leftDownBtnList[i].isOpen == true then
			num = num + 1
			--if num > 5 then
			if num > (index - 1)*5 and num <= index*5 then
				if self.leftDownBtnList[i] == self.roleBtn then
					CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "isHaveBook" ),	"btn_change",	ccp(-25,50))
				elseif self.leftDownBtnList[i] == self.bagBtn then
					local redPointState = CommonManager:getRedPointStateByKey( "bagBtnRedPoint" )
					if (redPointState) then
						redPointState = BagManager:isBagRedPoint()
					end
					CommonManager:setRedPoint(self.btn_change, redPointState, "btn_change", ccp(-25,50))
					-- CommonManager:setRedPoint(self.btn_change, BagManager:isHaveCanZhaomu(),"isHaveCanZhaomu",ccp(-25,50))
					-- CommonManager:setRedPoint(self.btn_change, BagManager:isHaveCanPiece(3),"isHaveCanPiece",ccp(-25,50))
					-- CommonManager:setRedPoint(self.btn_change, BagManager:isHaveCanProp(),"isHaveCanProp",ccp(-25,50))
					-- CommonManager:setRedPoint(self.btn_change, BagManager:isHaveCanGift(),"isHaveCanGift",ccp(-25,50))
				elseif self.leftDownBtnList[i] == self.taskBtn then
					--CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "taskBtnRedPoint" ),	"btn_change",	ccp(-25,50))
					local bRed = CommonManager:getRedPointStateByKey( "taskBtnRedPoint" )
					if bRed then
						CommonManager:setRedPoint(self.btn_change, bRed,	"btn_change",	ccp(-25,50))
						return
					end

					-- CommonManager:setRedPoint(self.btn_change, TaskManager:isCanGetRewardForType(1),"isCanGetRewardForType",ccp(-25,50))
				elseif self.leftDownBtnList[i] == self.mallBtn then
					CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "isHaveNewGif" ),	"btn_change",	ccp(-25,50))
					CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "isHaveNewGoods" ),	"btn_change",	ccp(-25,50))
					-- CommonManager:setRedPoint(self.btn_change, MallManager:isHaveNewGif(),"isHaveNewGif",ccp(-25,50))
					-- CommonManager:setRedPoint(self.btn_change, MallManager:isHaveNewGoods(),"isHaveNewGoods",ccp(-25,50))
				elseif self.leftDownBtnList[i] == self.zhaomuBtn then
					-- CommonManager:setRedPoint(self.btn_change, GetCardManager:isHaveGetCardFree(),"isHaveGetCardFree",ccp(-25,50))
					CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "isHaveGetCardFree" ),	"btn_change",	ccp(-25,50))
				elseif self.leftDownBtnList[i] == self.btn_faction then
					--CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "btn_faction" ),	"btn_change",	ccp(-25,50))

					local bRed = CommonManager:getRedPointStateByKey( "btn_faction" )
					if bRed then
						CommonManager:setRedPoint(self.btn_change, bRed, "btn_faction", ccp(-25,50))
						return
					end

				elseif self.leftDownBtnList[i] == self.btn_friends then
					-- CommonManager:setRedPoint(self.btn_change, FriendManager:isShowRedPoint(), "isShowRedPoint", ccp(-25,50))
					CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "btn_friends" ),	"btn_change",	ccp(-25,50))
				end
			--end
			end
		end
	end
	

	for i = 1, #self.leftDownBtnList do
		if self.leftDownBtnList[i].isOpen == true then
			num = num + 1
			if num > 5 then
				if self.leftDownBtnList[i] == self.taskBtn then
					local bRed = CommonManager:getRedPointStateByKey( "taskBtnRedPoint" )
					if bRed then
						CommonManager:setRedPoint(self.btn_change, bRed, "btn_change",	ccp(-25,50))
						return
					end
				elseif self.leftDownBtnList[i] == self.btn_faction then
					--CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "btn_faction" ),	"btn_change",	ccp(-25,50))

					local bRed = CommonManager:getRedPointStateByKey( "btn_faction" )
					if bRed then
						CommonManager:setRedPoint(self.btn_change, bRed, "btn_change", ccp(-25,50))
						return
					end

				elseif self.leftDownBtnList[i] == self.btn_friends then
					--CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "btn_friends" ),	"btn_change",	ccp(-25,50))

					local bRed = CommonManager:getRedPointStateByKey( "btn_friends" )
					if bRed then
						CommonManager:setRedPoint(self.btn_change, bRed, "btn_change", ccp(-25,50))
						return
					end
				elseif self.leftDownBtnList[i] == self.btn_eudemon then
					CommonManager:setRedPoint(self.btn_change, CommonManager:getRedPointStateByKey( "btn_eudemon" ),	"btn_change",	ccp(-25,50))
				end
			end
		end
	end
end
--[[
message ChatInfo
{
	required int32 chatType = 1;	// 聊天类型；1、公共，2、私聊；3、帮派； 
	required string message = 2;	//消息;
	required int32 playerId = 3;	//说话人的id 
	required string name = 4;		//说话人的名字 
}
]]
function MenuLayer:showChatBubble()
	local newMsg = ChatManager:getLatestMsg()
	
	if newMsg == nil then
		self.bubbleNode:setVisible(false)
		return
	end
	if newMsg.playerId == nil or  newMsg.playerId == 0 then
        self.bubbleNode:setVisible(false)
		return
	end

	--整理
	local msgTemplete = '%s:%s'
	--local preFixStr = '[江湖]'
	local preFixStr = localizable.menuLayer_chat1
	if newMsg.chatType == EnumChatType.Public then
		--preFixStr = '[江湖]'
		preFixStr = localizable.menuLayer_chat1
	elseif newMsg.chatType == EnumChatType.Gang then
		--preFixStr = '[帮派]'
		preFixStr = localizable.menuLayer_chat2
	elseif newMsg.chatType == EnumChatType.PrivateChat then
		--preFixStr = '[好友]'		
		preFixStr = localizable.menuLayer_chat3		
	else
        self.bubbleNode:setVisible(false)
		return
	end
	local str = string.format(msgTemplete, newMsg.name, newMsg.content)
	self.txtBubbleTitle:setText(preFixStr)	

	if self.bubbleDelayTime then
        TFDirector:removeTimer(self.bubbleDelayTime)
        self.bubbleDelayTime = nil
    end
    if self.bubbleMoveTime then
        TFDirector:removeTimer(self.bubbleMoveTime)
        self.bubbleMoveTime = nil
    end

    self.txtBubble:setPosition(ccp(0,0))
    self.txtBubble:setText(str)
    self.bubbleNode:setVisible(true)

    self.bubbleDelayTime = TFDirector:addTimer(30000, 1, function () 
		 	if self.bubbleDelayTime then
		        TFDirector:removeTimer(self.bubbleDelayTime)
		        self.bubbleDelayTime = nil
		    end
		    if self.bubbleMoveTime then
		        TFDirector:removeTimer(self.bubbleMoveTime)
		        self.bubbleMoveTime = nil
		    end
		    self.bubbleNode:setVisible(false)
		   	print('font move end ----------------------')
        end)

    local clipWidth = self.bubblePanel:getContentSize().width
    local fontWidth = self.txtBubble:getContentSize().width

    if clipWidth < fontWidth then
        local moveX = 10
        local times = math.ceil((fontWidth - clipWidth)/10)

        local function fontMove()
        	local moveTimes = 0
            self.txtBubble:setPosition(ccp(0,0))           
            self.bubbleMoveTime = TFDirector:addTimer(300, times+8, 
                function()
                   fontMove()
                end,
                function()
                    --每次进来
                    moveTimes = moveTimes + 1
                    if moveTimes < 4 then
                    	self.txtBubble:setPosition(ccp(0,0))
                    elseif moveTimes <= (times+4) then                    	
	                    local currX = self.txtBubble:getPositionX()
	                    currX = currX - 10
	                    self.txtBubble:setPositionX(currX)
	                end
                end)
        end
        fontMove()
    end
end

function MenuLayer:refreshYouliButton()
	
	local verLock = VersionLockData:objectByID(EnumVersionLockType.Adventure_Lock)
    if verLock and verLock.open == 0 then
        self.btn_youli:setVisible(false)
		self.pvpBtn:setPosition(self.btnYouliPos)
		return
    end
	local openLevel = FunctionOpenConfigure:getOpenLevel(2203)
	local currLevel = MainPlayer:getLevel()

	if currLevel >= openLevel then
		self.btn_youli:setVisible(true)
		self.btn_youli:setPosition(self.btnYouliPos)
		self.pvpBtn:setPosition(self.pvpBtnPos)
		CommonManager:setRedPoint(self.btn_youli, AdventureManager:isYouLiRedPoint(), "btn_youli")
	else
		self.btn_youli:setVisible(false)
		self.pvpBtn:setPosition(self.btnYouliPos)
	end
end

function MenuLayer.onKaojiaoClickHandle(sender)
    local layer = require("lua.logic.kaojiao.KaojiaoLayer"):new()
    AlertManager:addLayer(layer, AlertManager.BLOCK_AND_GRAY)
    AlertManager:show()

    TFDirector:send(c2s.POWER_EXAM_LOG_REQUEST, {})
end

-- function MenuLayer:showTipBox()
-- 	if self.btn_nextopen:isVisible() == false then
-- 		self.btn_nextopen:setVisible(false)
-- 		self.img_nextopenbg:setVisible(false)
-- 		return
-- 	end
-- 	local playerlevel = MainPlayer:getLevel()
-- 	local curOpenInfo = nil
-- 	for openInfo in LevelOpen:iterator() do
-- 		if openInfo.level > playerlevel and openInfo.show == 1 then
-- 			curOpenInfo = openInfo
-- 			break
-- 		end
-- 	end
-- 	if curOpenInfo == nil then
-- 		self.btn_nextopen:setVisible(false)
-- 		self.img_nextopenbg:setVisible(false)
-- 		return
-- 	end
-- 	local tbl = stringToTable(curOpenInfo.openfunction,"|")
-- 	self.txt_neirong:setText(stringUtils.format(localizable.menuLayer_nextopen,curOpenInfo.level,tbl[1]))
-- 	local width = self.txt_neirong:getContentSize().width + 15 * 2
-- 	self.img_nextopenbg:setContentSize(CCSizeMake(width,36))
-- 	self.txt_neirong:setPositionX(width*0.5 * -1)
-- 	self.btn_nextopen:setVisible(true)
-- 	self.img_nextopenbg:setVisible(true)

-- 	self.img_nextopenbg:stopAllActions()
-- 	local ac1 = CCDelayTime:create(30)
-- 	local ac2 = CCSequence:createWithTwoActions(ac1,CCHide:create())

-- 	self.img_nextopenbg:runAction(ac2)
-- end

function MenuLayer:showTipBox()
	if self.panel_opennew:isVisible() == false then
		self.panel_opennew:setVisible(false)
		return
	end
	local playerlevel = MainPlayer:getLevel()
	local curOpenInfo = nil
	for openInfo in LevelOpen:iterator() do
		if openInfo.level > playerlevel and openInfo.show and openInfo.show == 1 then
			curOpenInfo = openInfo
			break
		end
	end
	if curOpenInfo == nil then
		self.panel_opennew:setVisible(false)
		return
	end
	local tbl = stringToTable(curOpenInfo.openfunction,"|")
	self.txt_newopen:setText(tbl[1])
	self.txt_openlevel:setText( stringUtils.format(localizable.menuLayer_txt_level_open, curOpenInfo.level) )

	local path = curOpenInfo.path
	if path then
		path = "ui_new/home/" .. path
	else
		path = "ui_new/home/imgnew_xin.png"
	end
	self.panel_opennew:setVisible(true)
	self.btn_opennew:setTextureNormal(path)
	self.btn_opennew:setVisible(true)

	MainPlayer.LEVEL_OPEN_HISTORY = MainPlayer.LEVEL_OPEN_HISTORY or {}
	if not MainPlayer.LEVEL_OPEN_HISTORY[playerlevel] then
		MainPlayer.LEVEL_OPEN_HISTORY[playerlevel] = true
		self:setNextTxtShow(false)
		self:setNextOpenShow(true)
	end

	-- local actTime1 = 0.5
	-- local actTime2 = 1

	-- local destPosX = self.btn_opennew.initPos.x
	-- local destPosY = self.btn_opennew.initPos.y
	-- local initPosX = self.btn_opennew.initPos.x + 20
	-- TFDirector:killAllTween(self.img_opennew)
	-- TFDirector:killAllTween(self.btn_opennew)
	-- self.img_opennew:setScaleX(0.6)
	-- local tween1 = 
	-- {
	-- 	target = self.img_opennew,
	-- 	{
	--         duration = actTime1,
	--         scaleY = 1,
	--         scaleX = 1,
	--     },
	-- }

	-- local tween2 = 
	-- {
	-- 	target = self.btn_opennew,
	-- 	{
	--         duration = 0,
	--         x = initPosX,
	--     },
	--     {
	--         duration = actTime2,
	--         x = destPosX,
	--     },
	--     {
	--     	duration = 0,
	--     	onComplete = function() 
 --                self:setNextTxtShow(true)
 --            end
	-- 	},
	-- }

	-- TFDirector:toTween(tween1)
	-- TFDirector:toTween(tween2)

	-- local act1 = CCScaleTo:create(0.1, 1)

	-- self.img_opennew:stopAllActions()
	-- local ac1 = CCDelayTime:create(30)
	-- local ac2 = CCSequence:createWithTwoActions(ac1,CCHide:create())

	-- self.img_opennew:runAction(ac2)
end

function MenuLayer:setNextTxtShow(bShow)
	self.txt_newopen:setVisible(bShow)
	self.txt_openlevel:setVisible(bShow)
end
--浪人武士
function MenuLayer:knightBtnShow()
	if (self.btn_knight == nil) then
		return
	end
	local knightLock = VersionLockData:objectByID(EnumVersionLockType.Knight_Lock)
	if knightLock and knightLock.open == 0 then
		self.btn_knight:setVisible(false)
		return
	end
	--self.btn_knightShare:setVisible(KnightManager:isShowShareButton())
	KnightManager:setKnightRedPoint(self.btn_chat, KnightManager:isShowShareButton(), ccp(-5, 0))
	KnightManager:setAutoShowKnight(false)
	if (KnightManager:isShowKnight() == false) then
		self.btn_knight:setVisible(false)
		return
	end
	self.btn_knight:setVisible(true)
	local txt_time 	= TFDirector:getChildByPath(self.btn_knight, 'txt_onlinetime')
	txt_time:setColor(ccc3(61, 61, 61))
	local data    	= {}
    data.name     	= "MenuLayer"
    data.txt      	= txt_time
    data.funcCall 	= function() self.btn_knight:setVisible(false) end
    KnightManager:updateKnightOnLineTime(data)
end

function MenuLayer:refreshIslandRed()
	JapanIslandManager:setIslandRedPoint(self.btn_chat, JapanIslandManager:needShowChatRed(), ccp(-5, 0))
end

function MenuLayer:didAccelerate(data)
	if not data then
		return
	end

	if not self.bg_move then
		return
	end

	data.y = data.y - 5
	local deltaMax = 5
	if data.x > deltaMax then
		data.x = deltaMax
	elseif data.y > deltaMax then
		data.y = deltaMax
	elseif data.x < -deltaMax then
		data.x = -deltaMax
	elseif data.y < -deltaMax then
		data.y = -deltaMax
	end

	-- if data and data.x then
	-- 	data.x = -data.x
	-- end

	if data and data.y then
		data.y = -data.y
	end

    if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
        data.x = -data.x
    end

    --加速计的敏感值    
    local sensitivityX = 1.2
    local sensitivityY = 0.9

    local maxDeltaX = 38
    local maxDeltaY = 70

    local scaleTab = {1.5, 0, 0.7, 1.2}

    --local curPos = self.bg_move[8]:getPosition()
    local deltaX = data.x / 5 * maxDeltaX * sensitivityX 
    local deltaY = data.y / 5 * maxDeltaY * sensitivityY 

    self.pTabX = {}
    self.pTabY = {}
    for i = 1, 4 do
    	self.curPos[i] = self.initBgPos[i]
    	if i == 1 then
    		self.pTabX[i] = self.curPos[i].x - deltaX * scaleTab[i]
    		self.pTabY[i] = self.curPos[i].y - deltaY * scaleTab[i]
    	else
	    	self.pTabX[i] = self.curPos[i].x + deltaX * scaleTab[i]
	    	self.pTabY[i] = self.curPos[i].y + deltaY * scaleTab[i]
	    end
    end


 --    self.tweenBgMove = self.tweenBgMove or {}
 --    for i = 1, #self.tweenBgMove do
 --    	if self.tweenBgMove[i] then
	--     	TFDirector:killTween(self.tweenBgMove[i])
	--     	self.tweenBgMove[i] = nil
	--     end
 --    end
 --    for i = 1, 4 do
	--     self.tweenBgMove[i] = 
	--     {
	--         target = self.bg_move[i],
	--         {
	--             duration = 0.2,
	--             x = newX[i],
	--             y = newY[i],
	--         },
	--     }
	--     TFDirector:toTween(self.tweenBgMove[i])
	-- end

	--防抖动像素值
	local deltaX = 10
	local deltaY = 10

	self.newX = nil
	self.newY = nil
	if math.abs( self.pTabX[4] - self.bg_move[4]:getPositionX() ) > deltaX then
		self.newX = clone( self.pTabX ) 
	end
	if math.abs( self.pTabY[4] - self.bg_move[4]:getPositionY() ) > deltaY then
		self.newY = clone( self.pTabY ) 
	end

	if self.updateTimerID == nil then
	    self.updateTimerID = TFDirector:addTimer(30, -1, nil, 
	    function()
	    	for i = 1, 4 do
	    		local curppps = self.bg_move[i]:getPosition()
	    		
	    		if self.newX then
		    		local disX = self.newX[i] - curppps.x
		    		if math.abs(disX * 0.5) >= 1 then
		    			self.bg_move[i]:setPositionX(curppps.x + disX * 0.05)
		    		else
		    			self.bg_move[i]:setPositionX(self.newX[i])
		    		end
		    	end

		    	if self.newY then
		    		local disY = self.newY[i] - curppps.y
		    		if math.abs(disY * 0.5) >= 1 then
		    			self.bg_move[i]:setPositionY(curppps.y + disY * 0.05)
		    		else
		    			self.bg_move[i]:setPositionY(self.newY[i])
		    		end
		    	end
	    	end
	    end)
	end
end

--聊天按钮红点
function MenuLayer:chatRedPoint(time)
	if CommonManager:checkRedPointByKey("isHaveNewChat", time) then
		local redPointState = ChatManager:isHaveNewChat() or JapanIslandManager:getTeamChatRedState()
		redPointState = redPointState or KingOfWarManager:getTeamChatRedState()
		CommonManager:setRedPointStateByKey("isHaveNewChat", redPointState )
		CommonManager:setRedPoint(self.btn_chat, redPointState,"isHaveNewChat",ccp(0,0))
	end
end

function MenuLayer.img_qipaoClickHandle(sender)
	local self=sender.logic
	local toastTween = {
              target = self.img_qipao,
              {
                duration = 0.5,
                alpha = 0,
              },
              
              {
                duration = 0,
                onComplete = function() 
                    self.img_qipao:setVisible(false)
                end
              }
        }
    TFDirector:toTween(toastTween);
end


function MenuLayer:delayedLoad(showDelayTimer, callFunc)
	
	if (self[showDelayTimer] == nil) then
		local addLoadCount 	= 1
		local isLoad 		= false
		local loadTime 		= 0
		local function onShowDelayedLoad(time)
			if (isLoad) then
				isLoad = false
				loadTime = 0
				return
			end
			addLoadCount, loadTime = callFunc(self, addLoadCount, loadTime)
			if (loadTime > 0.04) then
				isLoad = true
			end
			if (addLoadCount == -1) then
				if self[showDelayTimer] then
					TFDirector:removeTimer(self[showDelayTimer])
					self[showDelayTimer] = nil
				end
			end			
		end
		self[showDelayTimer] = TFDirector:addTimer(0,-1, nil,onShowDelayedLoad)
	end
end

function MenuLayer:delayedLoad_1()
	local activityIndex, activityNum = OperationActivitiesManager:getOpenAndShowActivityList(1)
	if activityNum == 0 then
		self.btn_import_huodong:setVisible(false)
	else
		self.btn_import_huodong:setVisible(true)
	end

	local isShow = AnniversaryManager:isShowInMenu()
	print("周年庆活动",isShow)
	self.btn_zhouNianQing:setVisible(isShow)

	local activityIndex1, activityNum1 = OperationActivitiesManager:getOpenAndShowActivityList(2)
	if activityNum1 == 0 then
		self.btnTimeLimitMall:setVisible(false)
	else
		self.btnTimeLimitMall:setVisible(true)
	end

	local activityIndex3, activityNum3 = OperationActivitiesManager:getOpenAndShowActivityList(3)
	if activityNum3 == 0 then
		self.btnLimitExchange:setVisible(false)
	else
		self.btnLimitExchange:setVisible(true)
	end

	print("WeiXin : ",MainPlayer:getServerSwitchStatue(ServerSwitchType.WeiXin))
	self.btn_weixin:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.WeiXin))
	self.btn_gonglue:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.GongLv))
	self.btn_kaojiao:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.KaoJiao))
	self.btn_sevenDayPower:setVisible(MainPlayer:getServerSwitchStatue(ServerSwitchType.SevenDayPower) and SevenDayPowerManager:sevenDaysOpenSatus() ~= 0)
	-- self.btn_sevenDayPower:setVisible(true)

	local bShowEgg = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Hit_Egg)
	local teamLev = MainPlayer:getLevel()
    local openLev = FunctionOpenConfigure:getOpenLevel(2217)
    if teamLev < openLev then
    	bShowEgg = false
    end
	self.btn_goldEgg:setVisible(bShowEgg)

	local bShowXunBao = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Active_XunBao)
	teamLev = MainPlayer:getLevel()
    openLev = FunctionOpenConfigure:getOpenLevel(2215)
    if teamLev < openLev then
    	bShowXunBao = false
    end
	self.btn_xunbao:setVisible(bShowXunBao)

	local bShowLMP = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_LongMenPo)
	teamLev = MainPlayer:getLevel()
    openLev = FunctionOpenConfigure:getOpenLevel(2208)
    if teamLev < openLev then
    	bShowLMP = false
    end
	self.btn_longmenpo:setVisible(bShowLMP)

	local bShowTJL = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Tian_Ji_Lun)
	teamLev = MainPlayer:getLevel()
    openLev = FunctionOpenConfigure:getOpenLevel(2216)
    if teamLev < openLev then
    	bShowTJL = false
    end
	self.btn_tianjilun:setVisible(bShowTJL)



	local bShowMRZ = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Xia_Ke_Xing)
	teamLev = MainPlayer:getLevel()
    openLev = FunctionOpenConfigure:getOpenLevel(2221)
    if teamLev < openLev then
    	bShowMRZ = false
    end
	self.btn_murenzhuang:setVisible(bShowMRZ)

	local bShowSevenRank = (MainPlayer:getServerSwitchStatue(ServerSwitchType.SevenDayRank) and SevenDayRankManager:getOpenSatus() ~= SevenDayRankManager.EnumOpenStatus.CLOSE)
	local bShowRankNew = OperationActivitiesManager:ActivityTypeIsOpen(OperationActivitiesManager.Type_Sevenday_Rank)
	self.btn_sevenDayRank:setVisible(bShowSevenRank and bShowRankNew)

	local bShowKaiFuDaLi = MainPlayer:getServerSwitchStatue(ServerSwitchType.KaiFuDaLi)
	local isOpen = SevenDaysManager:isOpenStatue()
	self.btn_kfdl:setVisible(bShowKaiFuDaLi and isOpen)

	local isOpen = NianShouManager:activityOpenBool(true)
	self.btn_gns:setVisible(isOpen)

	local isOpen = DaNianShouManager:activityOpenBool(true)
	self.btn_dns:setVisible(isOpen)

	local bShowFanLiZhuanPan = FanLiZhuanPanManager:isShowInMenuLayer()
	self.btn_flzp:setVisible(bShowFanLiZhuanPan)
end
return MenuLayer
