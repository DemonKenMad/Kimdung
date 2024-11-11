-- client side KingWarEntranceLayer.lua
--[[
 * @Description: 王者争霸-入口 
 ]]
-- script writer Happy.All
-- creation time 2016-11-2 12:07:18

local KingWarEntranceLayer = class("KingWarEntranceLayer",BaseLayer)

function KingWarEntranceLayer:ctor(data)
	self.super.ctor(self, data)
	self:init("lua.uiconfig_mango_new.crossarena.CrossArenaEntrance")	
	
	KingOfWarManager:requestContestHistory()
end

function KingWarEntranceLayer:initUI( ui )
	self.super.initUI(self, ui)

	self.btn_help       = TFDirector:getChildByPath(ui, 'btn_help');
	self.panel_no_open = TFDirector:getChildByPath(ui,"panel_weikaiqi") --还没有记录战  虚席以待
	self.panel_no_open:setVisible(true)
	self.panel_open = TFDirector:getChildByPath(ui,"panel_kaiqi") --上一届获胜队伍
	self.panel_open:setVisible(true)
	self.panel_open_condition = TFDirector:getChildByPath(ui,"img_kaiqi")
	self.btn_apply = TFDirector:getChildByPath(ui,"btn_baoming")

	self.txt_lianleinum = TFDirector:getChildByPath(ui, "txt_lianleinum")
	self.txt_lianleinum:setText(stringUtils.format(localizable.KingWarLianLei,0))

	self.txt_tips = TFDirector:getChildByPath(ui, "txt_tips")
	self.txt_tips:setText(localizable.KingWarFightEndTips)

	-- self.img_tips = TFDirector:getChildByPath(self.panel_open,"img_tips")
	-- self.img_tips:setText(localizable.KingWarFightEndTips)
	self.icon_battletime = {}

	for i=1,2 do
		self.icon_battletime[i] = TFDirector:getChildByPath(ui,"icon_battletime"..i)
		self.icon_battletime[i]:setVisible(false)
	end

	--成员信息
	self.memberNode = {}
	for i=1,3 do
		local member = {}
		local localNode = TFDirector:getChildByPath(self.panel_open, "panel_role"..i)
		member.imgRole = TFDirector:getChildByPath(localNode, "img_role")
		member.imgRole:setVisible(false)
		member.imgNameBg = TFDirector:getChildByPath(localNode, "bg_name")
		member.txtName = TFDirector:getChildByPath(localNode, "txt_name")
		member.txtRedPack = TFDirector:getChildByPath(localNode, "txt_redpack")
		table.insert(self.memberNode, member)
	end
end

function KingWarEntranceLayer:removeUI()
   	self.super.removeUI(self)   
end

function KingWarEntranceLayer:onShow()
    self.super.onShow(self)
end

function KingWarEntranceLayer:registerEvents()
    if self.registerEventCallFlag then
        return
    end	
	self.super.registerEvents(self)
    self.btn_help:addMEListener(TFWIDGET_CLICK,  audioClickfun(self.onRuleClick))
    self.btn_apply:addMEListener(TFWIDGET_CLICK,audioClickfun(self.onBtnApply))

    self.updateLastHistoryCallBack = function (event)
        self:showDetailsInfo() 
    end
    TFDirector:addMEGlobalListener(KingOfWarManager.UpdateLastHistoryMsg, self.updateLastHistoryCallBack)
end

function KingWarEntranceLayer:removeEvents()

    self.btn_apply:removeMEListener(TFWIDGET_CLICK)

    if self.updateLastHistoryCallBack then
        TFDirector:removeMEGlobalListener(KingOfWarManager.UpdateLastHistoryMsg, self.updateLastHistoryCallBack)  
        self.updateLastHistoryCallBack = nil
    end 
    if self.roleAnimId then
        for k,v in pairs(self.roleAnimId) do
            GameResourceManager:deleRoleAniById(v)
        end
        self.roleAnimId = nil
    end

    self.super.removeEvents(self)

    self.registerEventCallFlag = nil  
end

function KingWarEntranceLayer:dispose()
    self.super.dispose(self)
end


function KingWarEntranceLayer.onBtnApply()
	KingOfWarManager:openMainLayer()
end

function KingWarEntranceLayer:dataReady()
	
end

function KingWarEntranceLayer:showDetailsInfo()
	local state = KingOfWarManager:getActivityState()
	local winner = KingOfWarManager:getLastHistoryInfo() or {}
	print("state = ",state)
	print("winner = ",winner)

    self.icon_battletime[1]:setVisible(false)
	self.icon_battletime[2]:setVisible(false)
    if state == KingOfWarManager.ActivityState_SignUp or KingOfWarManager.ActivityState_Score == state then
    	self.icon_battletime[1]:setVisible(true)
    elseif state == KingOfWarManager.ActivityState_Betting or state == KingOfWarManager.ActivityState_Final then
    	self.icon_battletime[2]:setVisible(true)
    end    
	if state == KingOfWarManager.ActivityState_unOpen then
		self.panel_no_open:setVisible(true)
		self.panel_open:setVisible(false)		
		self.btn_apply:setVisible(false)
	elseif winner.leizhu == nil then
		self.panel_no_open:setVisible(true)
		self.panel_open:setVisible(false)		
		self.btn_apply:setVisible(true)
	else
		local teamInfo = winner.leizhu
		self.panel_no_open:setVisible(false)
		self.panel_open:setVisible(true)
		self.btn_apply:setVisible(true)

		local leizhuCount = winner.leizhuCount or 0
		self.txt_lianleinum:setText(stringUtils.format(localizable.KingWarLianLei,leizhuCount))

		--跨服冠军
		local txtTeamName = TFDirector:getChildByPath(self.panel_open,"txt_teamname")
		txtTeamName:setText(teamInfo.name)

		local serverInfo = SaveManager:getServerInfo(teamInfo.serverId) or {}

		local txtTeamSever = TFDirector:getChildByPath(self.panel_open,"txt_fwqname")
		txtTeamSever:setText(serverInfo.name or "")

		if (teamInfo.member) then
			local memberInfo = {}
			local memberIdx = 2
		
			for k,v in pairs(teamInfo.member) do
				if v.playerId == teamInfo.leaderId then
					memberInfo[1] = v
				else
					memberInfo[memberIdx] = v
					memberIdx = memberIdx + 1
				end
			end

			if memberIdx == 5 then
				memberInfo[1] = memberInfo[4]
			end
			self.roleAnimId = {}		
			if self.roleAnimTbl then
				for k,v in pairs(self.roleAnimTbl) do
					v:removeFromParent()
				end
				self.roleAnimTbl = nil
			end
			for i=1,3 do
				self.memberNode[i].imgRole:setVisible(false)
				self.memberNode[i].imgNameBg:setVisible(true)
				self.memberNode[i].txtRedPack:setVisible(true)
				self.memberNode[i].txtName:setText(memberInfo[i].name)
				self.memberNode[i].txtRedPack:setText(stringUtils.format(localizable.KingWarSendRedPack,memberInfo[i].redPacket))			
				self:showRoleAnim(self.memberNode[i].imgNameBg, memberInfo[i].roleId)
			end
		else
			for i=1,3 do
				self.memberNode[i].imgRole:setVisible(true)
				self.memberNode[i].imgRole:setColor(ccc3(0,0,0))
				self.memberNode[i].imgNameBg:setVisible(false)
				self.memberNode[i].txtRedPack:setVisible(false)
			end
			
		end
	end
end

function KingWarEntranceLayer:showRoleAnim( node, roleId )

	local playerNode = node:getParent()
	-- local playerNode = playerNode1:getParent()

    local idx = #self.roleAnimId + 1
    local roleAnim = GameResourceManager:getRoleAniById(roleId)
    roleAnim:setPosition(node:getPosition())
    roleAnim:play("stand", -1, -1, 1) 
    roleAnim:setZOrder(-1)
    playerNode:addChild(roleAnim)

    self.roleAnimTbl = self.roleAnimTbl or {}
    self.roleAnimTbl[#self.roleAnimTbl + 1] = roleAnim
            
    self.roleAnimId[idx] = roleId
        -- 加阴影
    TFResourceHelper:instance():addArmatureFromJsonFile("effect/main_role2.xml")
    local effect2 = TFArmature:create("main_role2_anim")
    if effect2 ~= nil then
        effect2:setAnimationFps(GameConfig.ANIM_FPS)
        effect2:playByIndex(0, -1, -1, 1)
        effect2:setZOrder(-1)
        effect2:setPosition(ccp(0, -20))
        roleAnim:addChild(effect2)
    end	
end

function KingWarEntranceLayer.onRuleClick( sender )
    CommonManager:showRuleLyaer('wangzheleitai')
end
return KingWarEntranceLayer