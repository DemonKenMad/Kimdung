local MainPlayer = class("MainPlayer")

GameObject = require('lua.gamedata.base.GameObject')

--require("lua.config.ClientInfo")
--utf8字符集处理
require("lua.character_set.utf8")
--url编码
require("lua.character_set.urlCodec")
--[[
第三方SDK
]]
--SDK = require("SDK.PP.SDK")

CrossZhengBaManager = require("lua.gamedata.CrossZhengBaManager")
--通知资源更新，多条
MainPlayer.ResourceUpdateNotifyBatch 	= "MainPlayer.ResourceUpdateNotifyBatch"  		--通用资源更新通知
MainPlayer.ChallengeTimesChange			= "MainPlayer.ChallengeTimesChange"
MainPlayer.RE_CONNECT_COMPLETE			= "MainPlayer.RE_CONNECT_COMPLETE"
MainPlayer.GAME_RESET					= "MainPlayer.GAME_RESET" --游戏重置
MainPlayer.ServerSwitchChange			= "MainPlayer.ServerSwitchChange" --服务器开关变更
MainPlayer.MultipleOutputNotifyMessage			= "MainPlayer.MultipleOutputNotifyMessage" --服务器开关变更

MainPlayer.VIP_RULE_INFO_RESPONSE = "MainPlayer.VIP_RULE_INFO_RESPONSE"
MainPlayer.SERVER_SWITCH_INFO_RESULT = "MainPlayer.SERVER_SWITCH_INFO_RESULT"



MainPlayer.ExpChange 		= "MainPlayer.ExpChange" 			--团队经验
MainPlayer.LevelChange 		= "MainPlayer.LevelChange"     		--团队等级
MainPlayer.VipLevelChange 	= "MainPlayer.VipLevelChange"       --VIP等级
MainPlayer.TotalRechargeChange 	= "MainPlayer.TotalRechargeChange"       --VIP等级
MainPlayer.SyceeChange 		= "MainPlayer.SyceeChange"			--元宝
MainPlayer.CoinChange 		= "MainPlayer.CoinChange"           --铜币
MainPlayer.GenuineQiChange 	= "MainPlayer.GenuineQiChange" 		--悟性点

--david.dai add
MainPlayer.RoleExp 			= "MainPlayer.RoleExp"				--角色经验（未使用）
MainPlayer.QunHaoScore 		= "MainPlayer.QunHaoScore"  		--群豪谱积分
MainPlayer.ErrantryChange 		= "MainPlayer.ErrantryChange"  		--侠义值

DaNianShouManager = require("lua.gamedata.DaNianShouManager") --打年兽

function MainPlayer:ctor(...)
	self:init()
end

function MainPlayer:init()
	self:registerEvents()
	self.vipLevel	= 0 			--vip等级
	self.name  		= 0 			--角色名
	self.curExp 	= 0 			--当前经验
	self.sex 		= 0 			--性别
	self.maxExp		= 0 			--升级所需经验
	self.level 		= 0 			--等级
	self.playerId	= 0 			--玩家id
	self.profession = 1 			--职业
	self.useIcon	= 0 			--头像id
	self.frameId	= 0 			--头像框id
	self.sycee 		= 0 			-- 元宝 （rmb）
	self.coin 		= 0 			-- 铜币	（游戏金钱）
	self.genuine_qi	= 100 			-- 真气
	self.qunHaoScore = 0 			--群豪谱积分
	self.dedication = 0				--帮派贡献值
	self.totalRecharge = 0
	self.firstLoginMark = true 		--标记是否首次登陆

	self.recruitIntegral = 0 		--招募积分 
	-- self.payOpen  = false			--充值是否开启


	self.bIsEnterGame = false       --是否已经进入游戏

	self.chatUsed 		  = 0       --用了的聊天次数
	self.chatFree 		  = 0		--免费聊天次数
	self.serverChatUsed 		  = 0       --用了的聊天次数
	self.serverChatFree 		  = 0		--免费聊天次数
	self.chapterSweepFree = 0		--免费扫荡次数

	self.vesselBreachValue = 0		--经脉突破 精露资源类型

	self.climbStar = 0 				--无量山星星
	self.yueliNum = 0 				--阅历
	self.lowHonor = 0 				--虎令
	self.seniorHonor = 0 			--龙令
	self.peakScore  = 0				--论剑峰积分
	self.zhuxinCoin = 0 			--珠心币
	self.huixinCoin = 0 			--慧心币
	self.weiwang = 0 				--威望值
	self.Special_qi = 0 			--灵气
	self.JINGPO = 0 			    --精魄
	self.FengYunLing = 0 			    --风云令
	--登录时间 
	self.loginTime = 0
	self.pushTime = {}

	-- 是否为新角色
	self.bIsNewRole = false

	self.serverSwitch = {}
	self.multipleOutputList = {}
	self.vipruleTimes = {}

	self.qq		   = ""
	self.tel	   = ""
	
	--added by wuqi
	self.bFirstLogin = false

	self.tianxiangCoin = 0
	self.tianjiCoin = 0
	self.bVipScoreRed = nil


	-- self.file = assert(io.open("Chinese_1.log", 'w+'))
	-- -- self.print_table = {}

	-- -- self:printString(nil,localizable)
	-- local Chinese_l = require("language.Chinese")
	-- self:printString(nil,Chinese_l)
	-- self.file:close()

	-- self:readFanyiTextIndexToWrite()

end

function MainPlayer:printString( __string,_table )
	for k,v in pairs(_table) do
		local _string = k
		if __string then
			_string = __string .."&".. k
		end
		if type(v) == "table" and k ~= "_M" then
			self:printString(_string,v)
		elseif type(v) ~= "table" and v ~= "" then
			-- print(_string , v)
			--self.print_table[_string] = v
			local temp = string.gsub(v, "\n", "&")
			temp = string.gsub(temp, "\t", "$")
			local str = _string .. "\t" ..temp
			self.file:write(str.."\n")
		end
	end
end


function MainPlayer:readFanyiTextIndexToWrite()
	local Chinese_index = require("language.textIndex")
	local index_chinese = {}
	local key_table = {}
	for k,v in pairs(Chinese_index) do
		index_chinese[tonumber(v)] = k
		key_table[#key_table+1] = tonumber(v)
	end
	local file = assert(io.open("textIndex.txt"))
	local table_all = {}
	for line in file:lines() do 
		local table_line = string.split(line,'\t')
		local key = tonumber(table_line[1])
		table_all[key] = table_line[2]
		
	end
	file:close()

	local file_1 = assert(io.open("language_textIndex.lua",'w+'))
	table.sort(key_table)
	file_1:write("local Index = require('language.textIndex')\nlocal texts = {}\n")
	for i=1,#key_table do
		if table_all[key_table[i]] then
			file_1:write("texts[Index."..index_chinese[key_table[i]].."] \t = '".. table_all[key_table[i]].."'\n")
		else
			print("key_table[i]",key_table[i])
		end
	end
	-- for k,v in pairs(Chinese_index) do
	-- 	file_1:write("texts[Index."..k.."] \t = '".. table_all[v].."'\n")
	-- end
	file_1:close()
end

function MainPlayer:getTaskRewardConfig()
	local rewardItemTbl = {}
	for v in TaskData:iterator() do
		if v.category == 1 then
			local rewardConfig = RewardConfigureData:objectByID(v.reward_id);
			if rewardConfig then
				local temptbl = string.split(rewardConfig.reward_conf, ',')
				for k, config in pairs(temptbl) do
					rewardItemTbl[tonumber(config)] = 1
				end
			end
		end
	end	
	local file = assert(io.open("task_config.log", 'w+'))
	for k,v in pairs(rewardItemTbl) do
		file:write(k.."\n")
	end
	file:close()
end

function MainPlayer:getFanyiValue(value )
	-- local str = string.gsub(value, "$", "\\t")
	local str = string.gsub(value, "&", "\\n")
	str = string.gsub(str, "%$", "\\t")
	return str
end

function MainPlayer:readFanyiToWrite()
	local file = assert(io.open("tip_taiwan.txt"))
	local table_all = {}
	for line in file:lines() do 
		local table_line = string.split(line,'\t')
		local key = table_line[1]
		if string.find(key,'&') then
			local table_key = string.split(key,'&')
			local _key = table_all
			for i=1,#table_key - 1 do
				_key[table_key[i]] = _key[table_key[i]] or {}
				_key = _key[table_key[i]]
			end
			_key[table_key[#table_key]] = self:getFanyiValue(table_line[2])
		else
			table_all[key] = self:getFanyiValue(table_line[2])
		end
	end
	file:close()

	local file_1 = assert(io.open("tip_taiwan.lua","w+"))

	self:writeTipToLog( file_1 , table_all ,false)

	file_1:close()
end


function MainPlayer:writeTipToLog( file , _table ,include)
	for k,v in pairs(_table) do
		if type(v) == "table" and k ~= "_M" then
			local str = k
			if include then
				str = "["..k.."]"
			end
			file:write(str.."= {\n")
			self:_writeTipToLog( file , v ,true)
			file:write("} \n")
		elseif type(v) ~= "table" and v ~= "" then
			local str = k
			if include then
				str = "["..k.."]"
			end
			if string.find(v,'"') then
				file:write(str.."=	[["..v.."]]\n")
			else
				file:write(str.."=	\""..v.."\"\n")
			end
		end
	end
end
function MainPlayer:_writeTipToLog( file , _table ,include)
	local key_table = {}  
	--取出所有的键  
	for key,_ in pairs(_table) do  
	    table.insert(key_table,key)  
	end  
	--对所有键进行排序  
	table.sort(key_table,function ( a,b )
		local _a = tonumber(a) or 0
		local _b = tonumber(b) or 0
		return _a < _b
	end)  
	for _,key in pairs(key_table) do  
		local v = _table[key]
	    if type(v) == "table" then
			local str = key
			if include then
				str = "["..key.."]"
			end
			file:write(str.."= {\n")
			table.sort(v)
			self:_writeTipToLog( file , v ,true)
			file:write("} ,\n")
		elseif type(v) ~= "table" and v ~= "" then
			local str = key
			if include and tonumber(key) then
				str = "["..key.."]"
			end
			if string.find(v,'"') then
				file:write(str.."=	[["..v.."]] ,\n")
			else
				file:write(str.."=	\""..v.."\",\n")
			end
		end
	end  
end

function MainPlayer:getMisssionRewardConfig()
	local rewardItemTbl = {}
	for v in MissionManager.missionList:iterator() do

		local dropGroupArr = string.split(v.first_drop, ',');
        for i, dropGroupId in ipairs(dropGroupArr) do
            local dropGroupItem = DropGroupData:objectByID(tonumber(dropGroupId));
            if dropGroupItem then
            	local dropidmakeupArr = string.split(dropGroupItem.dropidmakeup, ',')
		        for i, dropId in ipairs(dropidmakeupArr) do
		        	if dropId and dropId ~= "" then
            			rewardItemTbl[tonumber(dropId)] = 1
            		end
		        end

            end
        end
		local _dropGroupArr = string.split(v.drop, ',');
        for i, dropGroupId in ipairs(_dropGroupArr) do
            local dropGroupItem = DropGroupData:objectByID(tonumber(dropGroupId));
            if dropGroupItem then
            	local dropidmakeupArr = string.split(dropGroupItem.dropidmakeup, ',')
		        for i, dropId in ipairs(dropidmakeupArr) do
            		if dropId and dropId ~= "" then
            			rewardItemTbl[tonumber(dropId)] = 1
            		end
		        end
            end
        end
	end	
	local file = assert(io.open("mission_config.log", 'w+'))
	for k,v in pairs(rewardItemTbl) do
		file:write(k.."\n")
	end
	file:close()
end

function MainPlayer:dispose()
	self:removeEvents()
end

function MainPlayer:registerEvents()
	TFDirector:addProto(s2c.PLAYER_INFO, self, self.playerMsgHandle)
	TFDirector:addProto(s2c.ENTER_GAME, self, self.enterGame)
	TFDirector:addProto(s2c.RESOURCE_UPDATE, self, self.UpdateRescourse)
	TFDirector:addProto(s2c.RECHARGE_INFO, self, self.RechargeInfo)
	TFDirector:addProto(s2c.CHALLENGE_TIME_LIST, self, self.ChallengeTimesListMsg)
	TFDirector:addProto(s2c.CHALLENGE_TIME, self, self.ChallengeTimesMsg)
	TFDirector:addProto(s2c.TEAM_LEVEL_CHANGE_NOTIFY,self,self.onTeamLevelChangedEvent)


	TFDirector:addProto(s2c.PERDAY_RESET_PROPERTIES, self, self.onReceiveFreeTimes)

	-- 登录
	TFDirector:addProto(s2c.BEFORE_ENTER_GAME, self, self.onReceiveLoginData)
	TFDirector:addProto(s2c.BEFORE_RECONNECT, self, self.onReceiveReLoginData)
	TFDirector:addProto(s2c.RESET_DAILY_NOTIFY, self, self.onReceiveGameResetEvent) -- 游戏到点重置

	TFDirector:addProto(s2c.SERVER_SWITCH_INFO_RESULT, self, self.ServerSwitchInfoResult) -- 服务器开关
	TFDirector:addProto(s2c.SERVER_SWITCH_INFO, self, self.ServerSwitchInfo) -- 服务器开关

	TFDirector:addProto(s2c.SERVER_INFO, self, self.ServerOpenTimeInfo) -- 服务器开关

	TFDirector:addProto(s2c.VIPINFOMATION, self, self.recvVipInfo)
	-- MissionManager:registerResetEvent()
	-- QiyuManager:registerResetEvent()
	TFDirector:addProto(s2c.MULTIPLE_OUTPUT_LIST_NOTIFY, self, self.MultipleOutputListNotify)
	TFDirector:addProto(s2c.MULTIPLE_OUTPUT_NOTIFY, self, self.MultipleOutputNotify)

	--added by wuqi
	TFDirector:addProto(s2c.FIRST_ONLINE_PROMPT, self, self.onFirstOnlinePrompt)

	TFDirector:addProto(s2c.VIP_RULE_INFO_RESPONSE, self, self.vipRuleInfoResponse)
	TFDirector:addProto(s2c.DRAW_VIPSCORE_SUCESS, self, self.vipScoreResponse)
	TFDirector:addProto(s2c.HEART_BEAT_RESPONSE, self, self.recvHeartBeatEvent)
end

function MainPlayer:removeEvents()
	TFDirector:removeProto(s2c.PLAYER_INFO, self, self.playerMsgHandle)
	TFDirector:removeProto(s2c.ENTER_GAME, self, self.enterGame)
	TFDirector:removeProto(s2c.RESOURCE_UPDATE, self, self.UpdateRescourse)
	TFDirector:removeProto(s2c.RECHARGE_INFO, self, self.RechargeInfo)
	TFDirector:removeProto(s2c.CHALLENGE_TIME_LIST, self, self.ChallengeTimesListMsg)
	TFDirector:removeProto(s2c.CHALLENGE_TIME, self, self.ChallengeTimesMsg)
	TFDirector:removeProto(s2c.TEAM_LEVEL_CHANGE_NOTIFY, self, self.onTeamLevelChangedEvent)


	TFDirector:removeProto(s2c.PERDAY_RESET_PROPERTIES, self, self.onReceiveFreeTimes)

	TFDirector:removeProto(s2c.BEFORE_ENTER_GAME, self, self.onReceiveLoginData)
	TFDirector:removeProto(s2c.BEFORE_RECONNECT, self, self.onReceiveReLoginData)
	TFDirector:removeProto(s2c.RESET_DAILY_NOTIFY, self, self.onReceiveGameResetEvent) -- 游戏到点重置


	TFDirector:removeProto(s2c.SERVER_SWITCH_INFO_RESULT, self, self.ServerSwitchInfoResult) -- 服务器开关
	TFDirector:removeProto(s2c.SERVER_SWITCH_INFO, self, self.ServerSwitchInfo) -- 服务器开关


	TFDirector:removeProto(s2c.SERVER_INFO, self, self.ServerOpenTimeInfo) -- 服务器开关

	TFDirector:removeProto(s2c.VIPINFOMATION, self, self.recvVipInfo)

	TFDirector:removeProto(s2c.MULTIPLE_OUTPUT_LIST_NOTIFY, self, self.MultipleOutputListNotify)
	TFDirector:removeProto(s2c.MULTIPLE_OUTPUT_NOTIFY, self, self.MultipleOutputNotify)

	--added by wuqi
	TFDirector:removeProto(s2c.FIRST_ONLINE_PROMPT, self, self.onFirstOnlinePrompt)
	TFDirector:removeProto(s2c.VIP_RULE_INFO_RESPONSE, self, self.vipRuleInfoResponse)
end

function MainPlayer:reset()
	self.bIsEnterGame = false       --是否已经进入游戏

	self.guideList = nil
	self.guideStep = nil
	self.qq		   = nil
	self.tel	   = nil

	for k,v in pairs(self.serverSwitch) do
		if v.beginTimer then
			TFDirector:removeTimer(v.beginTimer)
			v.beginTimer = nil 
		end
		if v.endTimer then
			TFDirector:removeTimer(v.endTimer)
			v.endTimer = nil 
		end
	end
	self.serverSwitch = {}
	self.vipruleTimes = {}
	self.multipleOutputList = {}

	PlayerGuideManager:restart()

	OperationActivitiesManager:reset()
	RewardManager:restart()
	self.bVipScoreRed = nil

	--停止心跳
	self:stopHeartBeat()

	if self.VersionGatherTimer then
		TFDirector:removeTimer(self.VersionGatherTimer)
		self.VersionGatherTimer = nil 
	end
end

function MainPlayer:playerMsgHandle(event)
	local mainPlayerInfo = event.data
	print("mainPlayerInfo >>>> ", mainPlayerInfo)
	self.playerId   = mainPlayerInfo.playerId 		--玩家id
	self.profession = mainPlayerInfo.profession	 	--职业
	self.useIcon	= mainPlayerInfo.useIcon or 0 	--头像
	self.frameId	= mainPlayerInfo.headPicFrame or 0
	self.sex 		= mainPlayerInfo.sex	 		--性别
	self.name  		= mainPlayerInfo.name 	 		--角色名
	self.level 		= mainPlayerInfo.level 	 		--等级
	print("playRole Level = ",self.level)
	self.coin 		= mainPlayerInfo.coin 	 		--铜币
	self.zhuxinCoin = mainPlayerInfo.tenchu
	self.huixinCoin = mainPlayerInfo.wisdom		
	self.weiwang 	= mainPlayerInfo.prestige or 0
	self.sycee   	= mainPlayerInfo.sycee 	 		--元宝
	self.curExp 	= mainPlayerInfo.exp 	 		--当前经验
	self.vipLevel	= mainPlayerInfo.vipLevel 		--vip等级
	self.genuine_qi	= mainPlayerInfo.inspiration 	--真气
	self.JINGPO		= mainPlayerInfo.jingPo 	--精魄
	self.FengYunLing = mainPlayerInfo.windCloudCoin 	--风云令
	-- self.soul		= mainPlayerInfo.soul 			--魂魄
	-- self.iron 		= mainPlayerInfo.iron 	 		--铸铁
	self.errantry 		= mainPlayerInfo.errantry 	 		--侠义
	self.totalRecharge = mainPlayerInfo.totalRecharge	--总充值元宝
	self.maxExp		= LevelData:getMaxPlayerExp(self.level) 	--升级所需经验
	self.registTime = math.ceil(mainPlayerInfo.registTime/1000)			--注册时间

	self.vesselBreachValue = mainPlayerInfo.jingLu or 0
	self.climbStar = mainPlayerInfo.climbStar or 0
	self.yueliNum = mainPlayerInfo.experience or 0

	self.lowHonor = mainPlayerInfo.lowHonor or 0
	self.seniorHonor = mainPlayerInfo.seniorHonor or 0

	self.tianxiangCoin = mainPlayerInfo.serdangTianXiangCoin or 0
	self.tianjiCoin = mainPlayerInfo.serdangTianJiCoin or 0

	self.guideList = mainPlayerInfo.openlist or ""		--玩法开放列表
	PlayerGuideManager:initGuideLayers()
	
	self.recruitIntegral = mainPlayerInfo.integral

	if self.guideStep == nil then
		self.guideStep = mainPlayerInfo.beginnersGuide	--新手引导步骤
	end
	if self.guideStep == 0 and self.level == 1 and self.curExp == 0 then
		self.guideStep = 10
	end

	self.qunHaoScore = 0

	local serverTime = math.ceil(mainPlayerInfo.serverTime/1000)	--服务器时间
	self.timeDifference = serverTime - os.time()
	--时区计算
	-- local timeArea = GetCorrectDate("*t", 0).hour
	-- local _timeArea = 8
	-- print("_timeArea - timeArea :",_timeArea - timeArea)
	-- self.timeDifference = self.timeDifference - (_timeArea - timeArea)*3600


	ActivityManager:AddNormalActivity()
	WulinManager:AddNormalActivity()
	
	local role = CardRoleManager:getRoleById(self.profession)
	if role then
		role.name = self.name
	end
	local roleinfo = RoleData:objectByID(self.profession)
	if roleinfo then
		self.sex = roleinfo.sex
	end
	if self.level >= 1 then
		FightManager.fightSpeed = 2
	end
	-- PlayerGuideManager:saveGuideStep_test()

	-- 登录时间
	self.loginTime = serverTime

	self.verticalName = toVerticalString(self.name)
	-- print("fuck Name : ",self.verticalName)

	self.bIsWeixinRedPoint = true

	self.playerProperties = mainPlayerInfo.properties

	print("self.recruitIntegral = ", self.recruitIntegral)

	EmployManager:queryEmployTeamCount() --获取雇佣他人队伍列表
	EmployManager:queryEmployTeamList()
	EmployManager:QueryEmployRoleCount() -- 查询已经雇佣的角色次数信息
	EmployManager:QueryEmployRoleList() -- 查询已雇佣角色列表
	PlayBackManager:requestQueryRecallTaskInfo() --请求老玩家回归任务信息
	MallManager:loadingMyPurchasedLogs(function()  end) --商店购买日志
	IllustrationManager:RequestIllustration()

	--jason add 设置蝮蛇宝血icon
	self:resetFushebaoxueIcon()	
	--add end
	--改名字
	local id = self.playerId or 0
	local dbPath = string.format("playmore_db/role_name/%s.db", tostring(id))
	roleSql = TFSqliteUtils:create(dbPath)
	for item in RoleData:iterator() do
		if type(item) == "table" then
			if not item.default_name then 
				item.default_name = item.name
			end
			local new_name = roleSql:getData(item.id)
			if new_name ~= nil then
				item.name = new_name
			else
				item.name = item.default_name
			end
		end
	end
	
	-- 新功能开启标记
	self.LEVEL_OPEN_HISTORY = nil
	-- 开启心跳包
	--self:startHeartBeat()
	self:VersionGather()
end

function MainPlayer:getBattleArrayMaxLevel()
	local info = ConstantData:objectByID("BattleArrayMaxLevel")
	if (info) then
		return info.value
	end
	return 150
end

function MainPlayer:getPlayerId()
	return self.playerId
end

function MainPlayer:getPlayerName()
	return self.name
end

function MainPlayer:setPlayerName(newName)
	self.name = newName
	local role = CardRoleManager:getRoleById(self.profession)
	if role then
		role.name = self.name
	end

	self.verticalName = toVerticalString(self.name)
end

--[[
	通过资源类型获取资源数值
]]
function MainPlayer:getResValueByType(resType)
	if resType == EnumDropType.COIN then
		return self.coin
	elseif resType == EnumDropType.SYCEE then
		return self.sycee
	elseif resType == EnumDropType.GENUINE_QI then
		return self.genuine_qi
	elseif resType == EnumDropType.EXP then
		return self.curExp
	elseif resType == EnumDropType.HERO_SCORE then
		return self.qunHaoScore
	elseif resType == EnumDropType.XIAYI then
		return self.errantry
	elseif resType == EnumDropType.FACTION_GX then
		return self.dedication
	elseif resType == EnumDropType.recruitIntegral then
		return self.recruitIntegral
	elseif resType == EnumDropType.VESSELBREACH then
		return self.vesselBreachValue	
	elseif resType == EnumDropType.LOWHONOR then
		return self.lowHonor
	elseif resType == EnumDropType.HIGHTHONOR then
		return self.seniorHonor
	elseif resType == EnumDropType.PEAK_SCORE then
		return self.peakScore
	elseif resType == EnumDropType.TIANXIANG_COIN then
		return self.tianxiangCoin
	elseif resType == EnumDropType.TIANJI_COIN then
		return self.tianjiCoin
	elseif resType == EnumDropType.ZHUXIN then
		return self.zhuxinCoin
	elseif resType == EnumDropType.HUIXIN then
		return self.huixinCoin
	elseif resType == EnumDropType.WEIWANG then
		return self.weiwang
	elseif resType == EnumDropType.SPECIAL_QI then
		return self.Special_qi
	elseif resType == EnumDropType.JINGPO then
		return self.JINGPO
	elseif resType == EnumDropType.FengYunLing then
		return self.FengYunLing
	end
	print("unknow res type : ",resType)
	return 0
end

--[[
	通过资源类型获取资源数值的表达式，显示样式，会根据数值范围自动转换成特定表达式，例如：10000000返回为1000w
]]
function MainPlayer:getResValueExpressionByType(resType)
	local value = self:getResValueByType(resType)

	if value > 1000000 then
		local fuck  = value/10000
		local floatValue = string.format("%.0f",fuck)
		-- return floatValue .."万"
		return stringUtils.format(localizable.MainPlayer_money_desc, floatValue)
	else 
		return value
	end
end

--真气
function MainPlayer:getZhenqi()
	return self.genuine_qi
end

--元宝数量
function MainPlayer:getSycee()
	return self.sycee
end

--铜币数量
function MainPlayer:getCoin()
	return self.coin
end

function MainPlayer:getProfession()
	return self.profession
end

function MainPlayer:getLevel()
	return self.level
end

--vip等级
function MainPlayer:getVipLevel()
	return self.vipLevel
end

function MainPlayer:getExpCur()
	return self.curExp 			-- 当前经验
end

function MainPlayer:getExpMax()
	return self.maxExp 			-- 当前总经验
end
function MainPlayer:getLevelMax()
	local info = ConstantData:objectByID("Player.Level.Max")
	if (info) then
		return info.value
	end
	return 170
end

function MainPlayer:getRoleSkillMax()
	local info = ConstantData:objectByID("RoleSkill.Max.Level")
	if (info) then
		return info.value
	end
	return 170
end

function MainPlayer:getBattleArrayMaxLevel()
	local info = ConstantData:objectByID("BattleArrayMaxLevel")
	if (info) then
		return info.value
	end
	return 170
end


function MainPlayer:bMaxLevel() --是否是最大经验值
    local bMax = false
    if self.level >= 100 and self.curExp >= self.maxExp then
        bMax = true
    end
    return bMax
end


function MainPlayer:getTotalRecharge()
	return self.totalRecharge 			-- 总充值元宝
end

function MainPlayer:getHeadPath()
	if self.useIcon ==nil or self.useIcon <= 0 then
		self.useIcon = self.profession
	end
	local role = RoleData:objectByID(self.useIcon)
	if role then
		return role:getHeadPath()
	end
end

function MainPlayer:getIconPath()
	if self.useIcon ==nil or self.useIcon <= 0 then
		self.useIcon = self.profession
	end
	local role = RoleData:objectByID(self.useIcon)
	if role then
		return role:getIconPath()
	end
	return ""
end

function MainPlayer:getProfessionIconPath()
	local role = RoleData:objectByID(self.profession)
	if role then
		return role:getIconPath()
	end
	return ""
end

--获取蝮蛇宝血图标
function MainPlayer:getProfessionBloodIcon()
	local profession = self.profession or 77
	local imgId = 5000+profession
	local imgIcon = "icon/item/".. imgId..".png"
	return imgIcon
end
function MainPlayer:resetFushebaoxueIcon()
	local profession = self.profession or 77
	local imgId = 5000+profession
	local fusheIcon = ItemData:objectByID(5000)

	fusheIcon.display = imgId
end

function MainPlayer:getBigImagePath()
	local role = RoleData:objectByID(self.profession)
	if role then
		return role:getBigImagePath()
	end
end

-- function MainPlayer:getImagePath()
-- 	local role = RoleData:objectByID(self.profession)
-- 	if role then
-- 		return role:getImagePath()
-- 	end
-- end

function MainPlayer:getPower()
	return StrategyManager:getPower()
end

--获取解锁宝石孔的等级
function MainPlayer:getGemOpenLevel( index )
	local GemOpenLevel = { 20 ,30,40,50}
	if index and GemOpenLevel[index] then
		return GemOpenLevel[index]
	end
	return GemOpenLevel
end

function MainPlayer:enterGame(event)
	TFDeviceInfo:setOpenAccelerometer(false)
	self.bIsEnterGame = true
	-- CardRoleManager.freshLock = false
	-- CardRoleManager:refreshAllRolePower()

	-- if CommonManager:checkServerVersion(event.data.resVersion) then
		self:addLayerToCache();
		AlertManager:changeScene(SceneType.HOME)
		self.firstLoginMark = false
		-- OperationActivitiesManager:openHomeLayer()
	-- end
	-- 		
	if self.bIsNewRole then
		print("该角色为首次创建 进入游戏")
	else
		print("该角色非首次创建 进入游戏")
	end
	-- if TFIMManager then
	-- 	TFIMManager:LoginToServer(self.playerId,true)
	-- end
	if HeitaoSdk then
		local isNewRole = 0

		if self.bIsNewRole then
			isNewRole = 1
		end

		HeitaoSdk.enterGame(self.playerId, self.name, self.level, isNewRole)

	end
	
	-- 是否是新角色
	self.bIsNewRole = false

	if TFPushServer then
		local tags 		 = ""
		local platformid = ""

		if HeitaoSdk then
			if HeitaoSdk.serverid ~= nil then
				tags = ""..HeitaoSdk.serverid
			end
			platformid = HeitaoSdk.getplatformId()

			tags = tags ..",".. platformid
		end

		if CC_TARGET_PLATFORM == CC_PLATFORM_IOS then
	    	tags = tags .. ",ios"
		elseif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID then
			tags = tags .. ",android"
		end

		-- tags = tags .. self.playerId

		-- print("push tags = ", tags)

		TFPushServer.setAccount(""..self.playerId)
		TFPushServer.setTags(tags)
	end
	CommonManager.TryReLoginFailTimes = 0
	-- TFWebView.removeWebView()
end

function MainPlayer:getNowtime()
	self.timeDifference = self.timeDifference or 0
	return os.time() + self.timeDifference
end

function MainPlayer:getLogintime()
	return self.loginTime
end

function MainPlayer:setLogintime(time)
	self.loginTime = time
end


--充值信息更新通知
function MainPlayer:RechargeInfo( event )
	local data = event.data
	local num = self.totalRecharge or 0
	self.totalRecharge = data.totalRecharge
	if num == 0 and	self.totalRecharge~= 0 then
		TFDirector:dispatchGlobalEventWith(MainPlayer.TotalRechargeChange , 0)
	end
	if data.vipLevel ~= self.vipLevel then
		self.vipLevel = data.vipLevel
		local cardrole = CardRoleManager:getRoleById(self.profession)
		if cardrole then
			cardrole:updateTotalAttr()
		end
		TFDirector:dispatchGlobalEventWith(MainPlayer.VipLevelChange , 0)
	end
end

-- required int32 type = 1; 								//1-推图体力；2-群豪谱体力；3-爬塔体力； 4-技能点;5-摩诃衍1；6-摩诃衍2；7-摩诃衍3
-- required int32 maxValue = 2; 							//默认每日可挑战次数
-- required int32 todayUse = 3;  							//今日已经挑战次数
-- required int32 currentValue = 4;							//今日剩余可挑战次数
-- required int32 todayBuyTime = 5;							//每日已购买次数
-- required int64 cooldownRemain = 6;						//下次恢复体力剩余时间
-- required int32 waitTimeRemain = 7;						//剩余等待时间
--体力挑战次数更新
function MainPlayer:ChallengeTimesListMsg(event)
	-- print("ChallengeTimesListMsg：",event.data.records)
	self.challengeTimesInfo = {}
	local count = #event.data.records
	for i=1,count do
	    local timesInfo =  event.data.records[i]
		self:setRecoverableRes(timesInfo)
	end

	TFDirector:dispatchGlobalEventWith(MainPlayer.ChallengeTimesChange , 0)
end


function MainPlayer:setChangllengTimePush( resType , time , coolTime)
	if resType ~= 1 and resType ~= 4 then
		return
	end
	local nowTime = GetCorrectTime()
	if self.pushTime[resType] ~= nil then
		if self.pushTime[resType].time >= nowTime then
			TFPushServer.cancelLocalTimer(self.pushTime[resType].time , self.pushTime[resType].notifyText,self.pushTime[resType].key)
		end
		self.pushTime[resType] = nil
	end
	if time == nil then
		return
	end
	self.pushTime[resType] = {}
	self.pushTime[resType].time = time + nowTime
	if resType == 1 then
		self.pushTime[resType].notifyText = localizable.MainPlayer_tili_tixing --"体力值都满了，再不使用就都浪费了！"
		self.pushTime[resType].key = localizable.MainPlayer_tili_name --"推图体力"

	elseif resType == 4 then
		self.pushTime[resType].notifyText = localizable.MainPlayer_jinengdian_tixing --"大侠，技能点都回满了，快去升级技能吧！"
		self.pushTime[resType].key = localizable.MainPlayer_jinengdian_name --"技能点"
	end
	-- print("self.pushTime[resType].time",self.pushTime[resType].time)
	-- print("time",time)
	-- print("nowTime",nowTime)
	-- print("GetCorrectTime = ",GetCorrectTime())
	TFPushServer.setLocalTimer(self.pushTime[resType].time , self.pushTime[resType].notifyText,self.pushTime[resType].key)
end

function MainPlayer:setRecoverableRes(info)
	info.timestamp = GetCorrectTime()
	local resType = info.type
	local configure = PlayerResConfigure:objectByID(resType)
	if configure == nil then
		print("resType 找不到配置 == ",resType)
		return
	end
	local coolTime = configure.cooldown * 1000
	--自动恢复定时器
	if coolTime > 0  and info.maxValue > info.currentValue then
		local leftCoolTimeSum = (info.maxValue - info.currentValue)*coolTime
		local cdLeaveTimeOjb = TimeRecoverProperty:create(math.ceil(leftCoolTimeSum/1000), math.ceil((coolTime - info.cooldownRemain)/1000),math.ceil(coolTime/1000))
		info.cdLeaveTimeOjb = cdLeaveTimeOjb
		self:setChangllengTimePush(resType ,math.ceil(leftCoolTimeSum/1000),configure.cooldown )
		function info:getLeftChallengeTimes()
			return self.currentValue + self.cdLeaveTimeOjb:getCurValue()
		end
	else
		--local cdLeaveTimeOjb = TimeRecoverProperty:create(0, 0,0)
		--info.cdLeaveTimeOjb = cdLeaveTimeOjb
		self:setChangllengTimePush(resType)
		function info:getLeftChallengeTimes()
			return self.currentValue
		end
	end

	-- print("self.timestamp : ",self.timestamp,self.waitTimeRemain)
	--等待方法绑定
	--[[
	获取剩余多少等待时间，单位/秒
	@return 剩余等待时间，单位/秒
	]]
	function info:getWaitRemaining()
		-- if not configure.wait_time then
		-- 	return 0
		-- end

		-- if configure.wait_time <= 0 then
		-- 	return 0
		-- end

		if not self.waitTimeRemain then
			return 0
		end

		if self.waitTimeRemain <= 0 then
			return 0
		end
		
		--过去了多长时间，单位/秒
		local timePassed = GetCorrectTime() - self.timestamp
		local remaining = math.max(0,self.waitTimeRemain/1000 - timePassed)
		return remaining
	end
	
	--[[
	获取剩余时间表达式
	@delim 分割符，默认':'
	@return 时间表达式，格式：小时:分钟:秒
	]]
	function info:getWaitTimeExpression(delim)
		local remaining = self:getWaitRemaining()
		if remaining <= 0 then
			return nil
		end
		
		if not delim then
			delim = ':'
		end
		
		local seconds = math.floor(remaining % 60)
		local minutes = math.floor(remaining / 60 % 60)
		local hours = math.floor(remaining / 60 / 60)

		local expression = ''
		if hours < 10 then
			expression = 0 .. hours .. delim
		else
			expression = hours .. delim
		end

		if minutes < 10 then
			expression = expression .. 0 .. minutes .. delim
		else
			expression = expression .. minutes .. delim
		end

		if seconds < 10 then
			expression = expression .. 0 .. seconds
		else
			expression = expression .. seconds
		end
		return expression
	end
	
	self.challengeTimesInfo[resType] = info
end

function MainPlayer:ChallengeTimesMsg(event)
	-- print("~~~~~~~~~~~~~~ChallengeTimesMsg",event.data)
    local timesInfo =  event.data
	self:setRecoverableRes(timesInfo)
	TFDirector:dispatchGlobalEventWith(MainPlayer.ChallengeTimesChange , timesInfo.type)
end

function MainPlayer:GetChallengeTimesInfo(type)
	if self.challengeTimesInfo == nil then
		return nil
	end
	
	return self.challengeTimesInfo[type]
end

function MainPlayer:onTeamLevelChangedEvent(event)
	print("player team level change : ",event.data)
	local data = event.data
	local oldLevel = self.level
	self.level 		=  oldLevel + data.levelUp
	self.maxExp		= LevelData:getMaxPlayerExp(self.level) 	

	if HeitaoSdk then
		HeitaoSdk.GameLevelChanged(self.level)
	end

	OperationActivitiesManager:levelChanged(self.level)

	TFDirector:dispatchGlobalEventWith(MainPlayer.LevelChange, data)
	CommonManager:showLevelUpLayer(data)
	self.levelUpForTrustOneKey = true
	-- 月卡 属性角色刷新
	CardRoleManager:refreshAllRolePower()
end

function MainPlayer:UpdateRescourse( event )

	local data = event.data	
	for _,v in pairs(data.resource) do
		if v.resource == EnumDropType.COIN then
			self.coin = v.num
			TFDirector:dispatchGlobalEventWith(MainPlayer.CoinChange , 0)
		elseif v.resource == EnumDropType.SYCEE then
			-- 元宝更新
			-- 记录消费
			-- 消耗了多少元宝
			if v.num < self.sycee then
				OperationActivitiesManager:SysceeExpend(self.sycee - v.num)
			end

			self.sycee = v.num
			TFDirector:dispatchGlobalEventWith(MainPlayer.SyceeChange , 0)
		elseif v.resource == EnumDropType.GENUINE_QI then
			self.genuine_qi = v.num
			TFDirector:dispatchGlobalEventWith(MainPlayer.GenuineQiChange , 0)
		elseif v.resource == EnumDropType.EXP then
			self.curExp = v.num		
			TFDirector:dispatchGlobalEventWith(MainPlayer.ExpChange , 0)
		-- elseif v.resource == EnumDropType.LEVEL then --单独通过团队等级变更指令更新
		-- 	self:levelUp(v.num)
		elseif v.resource == EnumDropType.HERO_SCORE then
			self.qunHaoScore = v.num
			TFDirector:dispatchGlobalEventWith(MainPlayer.QunHaoScore , 0)
		elseif v.resource == EnumDropType.XIAYI then
			self.errantry = v.num
			TFDirector:dispatchGlobalEventWith(MainPlayer.ErrantryChange , 0)
		elseif v.resource == EnumDropType.FACTION_GX then
			self.dedication = v.num		
		elseif v.resource == EnumDropType.RECRUITINTEGRAL then
			self.recruitIntegral = v.num
		elseif v.resource == EnumDropType.VESSELBREACH then
			self.vesselBreachValue = v.num
		elseif v.resource == EnumDropType.CLIMBSTAR then
			self.climbStar = v.num			
		elseif v.resource == EnumDropType.YUELI then
			self.yueliNum = v.num
		elseif v.resource == EnumDropType.LOWHONOR then
			self.lowHonor = v.num	
		elseif v.resource == EnumDropType.HIGHTHONOR then
			self.seniorHonor = v.num
		elseif v.resource == EnumDropType.PEAK_SCORE then
			self.peakScore = v.num
		elseif v.resource == EnumDropType.TIANXIANG_COIN then
			self.tianxiangCoin = v.num
		elseif v.resource == EnumDropType.TIANJI_COIN then
			self.tianjiCoin = v.num
		elseif v.resource == EnumDropType.ZHUXIN then
			self.zhuxinCoin = v.num
		elseif v.resource == EnumDropType.HUIXIN then
			self.huixinCoin = v.num
		elseif v.resource == EnumDropType.WEIWANG then
			self.weiwang = v.num
		elseif v.resource == EnumDropType.SPECIAL_QI then
			self.Special_qi = v.num
			TFDirector:dispatchGlobalEventWith(JiSiManager.StateChangeMessage,{}); 
		elseif v.resource == EnumDropType.JINGPO then
			self.JINGPO = v.num
		elseif v.resource == EnumDropType.FengYunLing then
			self.FengYunLing = v.num
		else
			print("unknow res type2 : ",v.resource,v.num)
		end
	end
	TFDirector:dispatchGlobalEventWith(MainPlayer.ResourceUpdateNotifyBatch , data.resource)
end

function MainPlayer:setLevel( level ,exp )
	self.curExp = exp	
	self.level = level
	print("playRole Level = ",self.level)
	self.maxExp	= LevelData:getMaxPlayerExp(self.level) 	--升级所需经验
	
	ActivityManager:AddNormalActivity()
	WulinManager:AddNormalActivity()
	if self.level >= 8 then
		if TFPlugins.isCompletePack == nil or TFPlugins.isCompletePack == true then
			return
		else
			if HeitaoSdk then
				HeitaoSdk.setIsOldPlayer()
			end
		end
	end
end

function MainPlayer:setExpCur( exp )
	self.curExp = exp	
	TFDirector:dispatchGlobalEventWith(MainPlayer.ExpChange , 0)
end

function MainPlayer:isEnoughTimes( type ,num , needToast ,isCanAdd)
	local timesInfo = self:GetChallengeTimesInfo(type);
	if timesInfo:getLeftChallengeTimes() >= num and not isCanAdd then 
		return true
	end
	if needToast then 
		VipRuleManager:showReplyLayer(type,false);
	end
	return false
end


function MainPlayer:isEnoughCoin( coin , needToast)
	if self.coin >= coin then 
		return true
	end
	if needToast then 
		CommonManager:showNeedCoinComfirmLayer();
	end
	return false
end

function MainPlayer:isEnoughZhuxin( coin , needToast)
	if self.zhuxinCoin >= coin then 
		return true
	end
	if needToast then 
		CommonManager:showNeedCoinComfirmLayer();
	end
	return false
end

function MainPlayer:isEnoughWeiWang( coin , needToast)
	if self.weiwang >= coin then 
		return true
	end
	if needToast then 
		CommonManager:showNeedCoinComfirmLayer();
	end
	return false
end

function MainPlayer:isEnoughSycee( sycee , needToast)
	if self.sycee >= sycee then 
		return true
	end
	if needToast then 
	   	PayManager:showNeedSycee();
	end
	return false
end

function MainPlayer:isEnoughVip( vipLevel , needToast)
	if self.vipLevel >= vipLevel then 
		return true
	end
	if needToast then 
		-- toastMessage("VIP等级不足")
		toastMessage(localizable.common_vip_level_buzu)
	end
	return false
end

function MainPlayer:isEnoughLevel( level , needToast)
	if self.level >= level then 
		return true
	end
	if needToast then 
		-- toastMessage("等级不足")
		toastMessage(localizable.common_level_buzu)
	end
	return false
end

--是否加入了帮派
function MainPlayer:hasGang()
	return self:getGangId() ~= nil
end

--获取新手指引步骤
function MainPlayer:getGuideStep()
	return self.guideStep
end
--获取帮派ID
function MainPlayer:getGangId()
	return nil
end

function MainPlayer:isEnoughGenuineQi( genuine_qi , needToast )
	if self.genuine_qi >= genuine_qi then 
		return true
	end
	if needToast then
		local num_1 = BagManager:getItemNumById( 30022 );
		if num_1 > 0 then
			BagManager:useItem( 30022 ,false)
			return false
		end
		local num_2 = BagManager:getItemNumById( 30023 );
		if num_2 > 0 then
			BagManager:useItem( 30023 ,false)
			return false
		end
		local num_3 = BagManager:getItemNumById( 30024 );
		if num_3 > 0 then
			BagManager:useItem( 30024 ,false)
			return false
		end
		local itemList = {}
		itemList[1] = {30022,EnumDropType.GOODS}
		itemList[2] = {30023,EnumDropType.GOODS}
		itemList[3] = {30024,EnumDropType.GOODS}
		if ResGetWayManager:openResGetLayerByList(itemList) == true then
            return false
        end
		CommonManager:showNeedZhenqiComfirmLayer()
	end
	return false
end

function MainPlayer:isEnoughYueLi( yueli , needToast)
	if self.yueliNum >= yueli then 
		return true
	end
	if needToast then
		local num_1 = BagManager:getItemNumById( 30122 );
		if num_1 > 0 then
			BagManager:useItem( 30122 ,false)
			return false
		end
		local num_2 = BagManager:getItemNumById( 30123 );
		if num_2 > 0 then
			BagManager:useItem( 30123 ,false)
			return false
		end
		-- local num_3 = BagManager:getItemNumById( 30024 );
		-- if num_3 > 0 then
		-- 	BagManager:useItem( 30024 ,false)
		-- 	return false
		-- end
		-- CommonManager:showNeedZhenqiComfirmLayer()
		toastMessage(localizable.Tianshu_rongru_text2)
	end
	return false
end
--[[
add by david.dai
验证资源是否足够
@param resType 资源类型
@param value 资源数量
@return 是否足够
]]
function MainPlayer:isEnough(resType,value)
	--print("MainPlayer:isEnough(resType,value) : ",resType,value,EnumDropType)
	if resType == EnumDropType.COIN then
		return self:isEnoughCoin(value,true)
	elseif resType == EnumDropType.SYCEE then
		return self:isEnoughSycee(value,true)
	elseif resType == EnumDropType.GENUINE_QI then
		return self:isEnoughGenuineQi(value,true)
	--elseif resType == EnumDropType.EXP then
	--	return self:isEnoughSycee(value)
	--elseif resType == EnumDropType.STARSHARDS then
	--	return self:isEnoughSycee(value)
	elseif resType == EnumDropType.YUELI then
		return self:isEnoughYueLi(value,true)
	end

	local has = self:getResValueByType(resType)
	if has < value then
		-- toastMessage("您没有足够的" .. GetResourceName(resType))
		toastMessage(stringUtils.format(localizable.Common_good_buzu, GetResourceName(resType)))
		return false
	end
	return true
end


function MainPlayer:restart()
	ErrorCodeManager:restart()
	RewardManager:restart()
	ActivityManager:restart()
	WulinManager:restart()
	EquipmentManager:restart()
	BagManager:restart()
	StrategyManager:restart()
	OtherPlayerManager:restart()
	FightManager:restart()
	CardRoleManager:restart()

	ViewDataCache:restart()
	MissionManager:restart()
	ArenaManager:restart()
	ClimbManager:restart()
	NorthClimbManager:restart()
	PayManager:restart()
	CommonManager:restart()

	AlertManager:restart()
	SettingManager:restart()
	NotifyManager:reset()
	TaskManager:restart()
	QiyuManager:restart()
	MonthCardManager:restart()
	MallManager:restart()

	BloodFightManager:restart()
	OperationActivitiesManager:restart()
	SevenDaysManager:restart()
	self:reset()
	NiuBilityManager:restart()
	IllustrationManager:restart()
	FateManager:restart()

	RankManager:restart()
	WeekRaceManager:restart()
	FactionManager:reConnect()
	FactionPracticeManager:restart()
	FactionJiShiTangManager:restart()
	MultiServerFightManager:restart()

	ChatManager:restart()
	BossFightManager:restart()
	ZhengbaManager:restart()
	HoushanManager:restart()
	MiningManager:restart()
	EmployManager:restart()
	PlayBackManager:restart()
	QiYuanManager:restart()
	QianXiuManager:restart()

	FactionFightManager:restart()
	CrossGuildBattleManager:restart()
	SevenDayPowerManager:restart()
	GambleManager:restart()
	EverydayNoticeManager:restart()
	--added by wuqi
	SkyBookManager:restart()

	LongMenPoManager:restart()
	CustomSkillAiManage:restart()
	GetCardManager:restart()
	self.logonTime = nil

	WestClimbManager:restart()
	ChuangzhenManager:restart()
	TianJiLunManager:restart()
	StrategyCardManager:restart()
	RechargeTicketManager:restart()

	RedPacketManager:restart()
	SevenDayRankManager:restart()
	JapanIslandManager:restart()
	KnightManager:restart()
	StarHeroManager:restart()
	KingOfWarManager:restart()
	WoodActivityManager:restart()
	CrossZhengBaManager:restart()
	EudemonManager:restart()
	ActivityTipManager:restart()

	BiaoCheManager:restart()
	WuLinEnemyManager:restart()
	FanLiZhuanPanManager:restart()
	LangHuanManager:restart()
	AnniversaryManager:restart()
	AdventureTreasureManager:restart()
	GoldenCardManager:restart()
	XinFaManager:restart()
	HeroMeetingManager:restart()
	JiSiManager:restart()
	TianMingManager:restart()
end

function MainPlayer:reload()
	-- EquipmentManager:restart()
	-- StrategyManager:restart()
	-- CardRoleManager:restart()
	-- BagManager:restart()
	-- ChatManager:restart()
	
	-- OperationActivitiesManager:restart()

	ActivityManager:restart()
	RewardManager:restart()
	WulinManager:restart()
	EquipmentManager:restart()
	BagManager:restart()
	StrategyManager:restart()
	OtherPlayerManager:restart()
	-- FightManager:restart()
	CardRoleManager:restart()

	ViewDataCache:restart()
	MissionManager:restart()
	ArenaManager:restart()
	-- ClimbManager:restart()
	PayManager:restart()
	CommonManager:restart()
	FateManager:restart()
	-- AlertManager:restart()
	SettingManager:restart()
	NotifyManager:reset()
	NiuBilityManager:restart()
	TaskManager:restart()
	QiyuManager:restart()
	MonthCardManager:restart()
	--MallManager:restart()

	BloodFightManager:restart()
	OperationActivitiesManager:restart()
	-- MainPlayer:reset()

	WeekRaceManager:restart()
	FactionManager:reConnect()
	FactionPracticeManager:restart()
	FactionJiShiTangManager:restart()
	MultiServerFightManager:restart()
	ChatManager:restart()
	EmployManager:restart()
	GambleManager:restart()
	EverydayNoticeManager:restart()
	GetCardManager:restart()

	
	IllustrationManager:restart()
	--added by wuqi
	SkyBookManager:restart()

	CustomSkillAiManage:restart()
	
	StrategyCardManager:restart()
	
	PeakManager:restart()
	ChuangzhenManager:restart()
	RechargeTicketManager:restart()

	-----------------------------------
	IllustrationManager:RequestIllustration()
	JapanIslandManager:restart()
	KnightManager:restart()
	KingOfWarManager:restart()
	WoodActivityManager:restart()
	EudemonManager:restart()
	ActivityTipManager:restart()
	BiaoCheManager:restart()
	WuLinEnemyManager:restart()
	LangHuanManager:restart()
	AnniversaryManager:restart()
	AdventureTreasureManager:restart()
	GoldenCardManager:restart()
	XinFaManager:restart()
	HeroMeetingManager:restart()
	JiSiManager:restart()
end

function MainPlayer:addLayerToCache()
	 -- MissionManager:addLayerToCache();
    -- CardRoleManager:addLayerToCache();
    -- ArenaManager:addLayerToCache();
    -- ClimbManager:addLayerToCache();
    -- PayManager:addLayerToCache();
    -- SettingManager:addLayerToCache(); 
end

--[[
获取最大的角色等级，角色最大可升级等级
]]
function MainPlayer:getMaxRoleLevel()
	return self.level
end

--[[
获取装备最高强化等级
]]
function MainPlayer:getMaxIntensifyLevel()
	return self.level
end

--是否开启充值
function MainPlayer:isPayOpen()
	if self.serverSwitch[ServerSwitchType.Pay] == nil then
		return true
	end
	return self.serverSwitch[ServerSwitchType.Pay].open or true
end

function MainPlayer:setPayOpen(open)
	--self.payOpen = open
end


function MainPlayer:onReceiveFreeTimes(event)
-- //每日重置属性
-- message PerdayResetProperties
-- {
-- 	required int32 chatFree = 1;			//免费聊天次数
-- 	required int32 chapterSweepFree = 2;	//免费扫荡次数
-- 	required int64 lastUpdate = 3;			//最后更新时间，时间轴
-- }
	local data = event.data

	self.chatUsed 		  = data.chatFree				--免费聊天次数
	self.chapterSweepFree = data.chapterSweepFree		--免费扫荡次数
	self.serverChatUsed = data.crossFreeChat or 0		--免费扫荡次数
	
	print("mainplayer data.vipDeclaration : ", data.vipDeclaration)
	--added by wuqi
	self.vipDeclarationFree = data.vipDeclaration or 0
	
	--NiuBilityManager:restart()
end

function MainPlayer:getVipDeclarationFreeTimes()
    if not self.vipDeclarationFree then
        return 0
    end
	if self.vipDeclarationFree <= 0 then
		return 0
	else
		return self.vipDeclarationFree
	end
end

function MainPlayer:getChatUsedTimes()
	return self.chatUsed or 0
end
function MainPlayer:getServerChatUsedTimes()
	return self.serverChatUsed or 0
end

-- 剩余的聊天次数
function MainPlayer:getChatFreeTimes()
	local vipChat  = VipData:getVipItemByTypeAndVip(5000, self:getVipLevel()) 
    local vipChatTimes = (vipChat and vipChat.benefit_value) or 0

    local levelChatTimes   = 0
    local defaultChatLevel = ConstantData:getValue("Chat.Public.Level")--15
    local defaultChatTimes = ConstantData:getValue("Chat.Public.num")--5
    local ChatTimerPerLevel = ConstantData:getValue("Chat.Public.num2")--5

-- Chat.Public.Level 		开放等级之前有
-- Chat.Public.VipLevel 	这个是开放VIP
-- Chat.Public.num  		聊天功能开始的初始聊天次数
-- Chat.Public.num2 		聊天功能开启后，此后每级递增的次数
    if self.level >= defaultChatLevel then
    	levelChatTimes = defaultChatTimes

    	levelChatTimes = levelChatTimes + (self.level - defaultChatLevel) * ChatTimerPerLevel
    end

    -- self.chatFree = vipChatTimes - self.chatUsed
    self.chatFree = levelChatTimes + vipChatTimes - self.chatUsed

    if self.chatFree < 0 then
    	self.chatFree = 0
    end


    return self.chatFree
end
-- 剩余的聊天次数
function MainPlayer:getServerChatFreeTimes()
	local vipChat  = VipData:getVipItemByTypeAndVip(5001, self:getVipLevel()) 
    local vipChatTimes = (vipChat and vipChat.benefit_value) or 0

    local levelChatTimes   = 0
    local defaultChatLevel = ConstantData:getValue("Chat.Server.Level")--15
    local defaultChatTimes = ConstantData:getValue("Chat.Server.num")--5
    local ChatTimerPerLevel = ConstantData:getValue("Chat.Server.num2")--5

-- Chat.Server.Level 		开放等级之前有
-- Chat.Server.VipLevel 	这个是开放VIP
-- Chat.Server.num  		聊天功能开始的初始聊天次数
-- Chat.Server.num2 		聊天功能开启后，此后每级递增的次数
    if self.level >= defaultChatLevel then
    	levelChatTimes = defaultChatTimes

    	levelChatTimes = levelChatTimes + (self.level - defaultChatLevel) * ChatTimerPerLevel
    end
    -- self.serverChatFree = vipChatTimes - self.chatUsed
    self.serverChatFree = levelChatTimes + vipChatTimes - self.serverChatUsed

    if self.serverChatFree < 0 then
    	self.serverChatFree = 0
    end


    return self.serverChatFree
end

function MainPlayer:getChapterSweepTimes()
	return self.chapterSweepFree
end

function MainPlayer:isChallengeTimesFull( type )
	local pointInfo =  self:GetChallengeTimesInfo(type);
	if pointInfo == nil then
		return false
	end
	local leftChallengeTimes = pointInfo:getLeftChallengeTimes();
	return leftChallengeTimes  >= pointInfo.maxValue
end

function MainPlayer:onReceiveLoginData(event)

	print("--------------开始登录游戏----------------")

--[[
	[1] = {--BeforeEnterGame
		[1] = 'int64':serverStartup	[服务器启动时间轴]
		[2] = 'int64':lastLogon	[最后一次走登录流程的时间轴]
	}
--]]
	self:restart()
	local data = event.data
	local time = math.max(data.serverStartup , data.lastLogon)
	self.logonTime = time
end


function MainPlayer:onReceiveReLoginData(event)
	print("--------------重新登录游戏----------------")

	self:reload()
	local data = event.data
	local time = math.max(data.serverStartup , data.lastLogon)
	-- if TFIMManager then
	-- 	TFIMManager:LoginToServer(self.playerId)
	-- end
	if time ~= self.logonTime then
		self:reset()
    	CommonManager:closeConnection()
		AlertManager:changeSceneForce(SceneType.LOGIN)

		-- 检查资源更新
		-- CommonManager:checkResourceVersion()
	end
end

function MainPlayer:onReceiveGameResetEvent(event)
	print("--------------游戏到点重置----------------")

	-- TFDirector:dispatchGlobalEventWith(MainPlayer.GAME_RESET, 0)
	MissionManager:resetMissionData()
	QiyuManager:resetQiyuData()
	NiuBilityManager:restart()
	self.chatUsed 		  = 0				--免费聊天次数
	self.chapterSweepFree = 0		--免费扫荡次数
	self.vipruleTimes = {}
	--added by wuqi
	self.vipDeclarationFree = 0
	self:setFirstLogin(true)
	self:setVipScoreRed(true)

	-- MallManager:UpdateCoinNumCallback(event)
	MallManager:resetBuyCoinNum()
	MallManager:resetBuyXiaYiNum()
	-- 12点重置
	BossFightManager:resetData12oClock()

	-- 重新拉取好友列表
	FriendManager:reloadFriendList()

	-- 12刷新月卡状态 
	MonthCardManager:refreshMonthCard()

	--24点重置信息
	FactionManager:resetDataInfo_24()
	FactionJiShiTangManager:reset_24()
	AssistFightManager:resetDataInfo_24()
	AdventureManager:resetData_24()

	OperationActivitiesManager:autoReset()

	GoldEggManager:resetFreeTime()
	PayManager:resetFreeTime()
	-- TreasureManager:resetFreeTime()
	
	NorthClimbManager:resetByDay()

	EmployManager:resetByDay()

	QiYuanManager:restart()

	RechargeTicketManager:resetAnotherDay()

	GetCardManager:resetData_24()

	KnightManager:requestKnightAllInfo_24()
	
	StarHeroManager:reset_24()

	CrossZhengBaManager:reset_24()
	AnniversaryManager:restart_24()

	TFDirector:dispatchGlobalEventWith(MainPlayer.GAME_RESET, {})
end


function MainPlayer:ServerSwitchInfoResult(event)
	local count = #event.data.switchList
	--print(" ServerSwitchInfoResult event.data",event)
	for i=1,count do
		local data =  event.data.switchList[i]
		self:_ServerSwitchInfo(data)
	end
	WulinManager:restart()
	WulinManager:AddNormalActivity()
	TFDirector:dispatchGlobalEventWith(MainPlayer.SERVER_SWITCH_INFO_RESULT, {})
end

function MainPlayer:ServerSwitchInfo(event)
	local data = event.data
	-- print("ServerSwitchInfo data",event)
	self:_ServerSwitchInfo(data )
	WulinManager:restart()
	WulinManager:AddNormalActivity()
end

--modify by wkdai
function MainPlayer:getServerSwitchStatue(key )
	if not key or not self.serverSwitch[key] then
		return false
	end

	return self.serverSwitch[key].open --or true
end

function MainPlayer:ServerOpenTimeInfo(event)
	local data = event.data
 	local openTime = data.openTime

	if openTime then
		if openTime == 0 then
			openTime = self.registTime
			return
		end
		
		openTime = math.ceil(openTime/1000)

		local t2 = GetCorrectDate("*t",openTime)
	    t2.hour = 0
	    t2.min = 0
	    t2.sec = 0
	    local startTime = GetCorrectTime(t2)
	    print("startTime = ", startTime)
	    print("------------开服时间：", GetCorrectDate("%c", startTime))
		self.serverOpenTime = startTime
	else
		self.serverOpenTime = self.registTime
	end

	-- print("self.serverOpenTime111 = ", self.serverOpenTime)
end

function MainPlayer:ServerOpenTime()
	-- print("self.serverOpenTime222 = ", self.serverOpenTime)
	return self.serverOpenTime
end

function MainPlayer:_ServerSwitchInfo(data )
	if self.serverSwitch[data.switchType] == nil then
		self.serverSwitch[data.switchType] = {}
	end
	local nowTime  = self:getNowtime()*1000
	self.serverSwitch[data.switchType].open = data.open
	if self.serverSwitch[data.switchType].beginTimer then
		TFDirector:removeTimer(self.serverSwitch[data.switchType].beginTimer)
		self.serverSwitch[data.switchType].beginTimer = nil
	end
	if self.serverSwitch[data.switchType].endTimer then
		TFDirector:removeTimer(self.serverSwitch[data.switchType].endTimer)
		self.serverSwitch[data.switchType].endTimer = nil
	end
	if self.serverSwitch[data.switchType].open == false then
		TFDirector:dispatchGlobalEventWith(MainPlayer.ServerSwitchChange, data.switchType)
		return
	end
	if data.beginTime ~= nil and data.beginTime > nowTime then
		self.serverSwitch[data.switchType].open = false
		self.serverSwitch[data.switchType].beginTimer = TFDirector:addTimer(data.beginTime - nowTime ,1 ,nil,
			function ()
				self.serverSwitch[data.switchType].open = true
				TFDirector:dispatchGlobalEventWith(MainPlayer.ServerSwitchChange, data.switchType)
				self.serverSwitch[data.switchType].beginTimer = nil
			end)
		TFDirector:dispatchGlobalEventWith(MainPlayer.ServerSwitchChange, data.switchType)
		return
	end
	if data.endTime ~= nil and data.endTime > nowTime then
		self.serverSwitch[data.switchType].endTimer = TFDirector:addTimer(data.endTime - nowTime ,1 ,nil,
			function ()
				self.serverSwitch[data.switchType].open = false
				TFDirector:dispatchGlobalEventWith(MainPlayer.ServerSwitchChange, data.switchType)
				self.serverSwitch[data.switchType].endTimer = nil
			end)
	end
	if  data.endTime ~= nil and data.endTime ~= 0 and data.endTime <= nowTime then
		if self.serverSwitch[data.switchType].endTimer then
			TFDirector:removeTimer(self.serverSwitch[data.switchType].endTimer)
			self.serverSwitch[data.switchType].endTimer = nil
		end
		if self.serverSwitch[data.switchType].open == true then
			self.serverSwitch[data.switchType].open = false
		end
	end
	TFDirector:dispatchGlobalEventWith(MainPlayer.ServerSwitchChange, data.switchType)
end

function MainPlayer:getRegisterTime()
	return self.registTime
end

function MainPlayer:getRegisterDay()
    local secInOneDay = 24 * 60 * 60
    local nowTime    = self:getNowtime()
    -- local registTime = self.registTime
    local registTime = self.serverOpenTime
    -- local t1 = GetCorrectDate("*t",nowTime)
    local t2 = GetCorrectDate("*t",registTime)
    -- print(" t1 : ",t1)
    -- print(" t2 : ",t2)

    t2.hour = 0
    t2.min = 0
    t2.sec = 0
    local startTime = GetCorrectTime(t2)
    -- print(" startTime : ",startTime)
    local days = 0
    while days < SevenDaysManager.constDayNum do
    	if nowTime > startTime then
    		days = days + 1
    		startTime = startTime+secInOneDay
    	else
    		break;
    	end
    end

    -- print("days : ",days)
    return days
end

function MainPlayer:WeixinBePressed()
	self.bIsWeixinRedPoint = false
end

function MainPlayer:getWeixinStatus()
	return self.bIsWeixinRedPoint
end


-- -- 足够返回 true
-- ├┄┄number=1,
-- ├┄┄itemid=0,
-- ├┄┄type=3,
-- }
function MainPlayer:getGoodsIsEnough(data)

	if data.type == EnumDropType.GOODS and data.itemid then
		local bagItem = BagManager:getItemById(data.itemid)
		--折扣券特殊处理当我不需要背包里面的物品,直接用折扣券兑换时
		if (data.isDiscount == true and bagItem == nil and data.number == 0) then
	        return true
	    end
	    if bagItem == nil then
	        print("该道具不存在背包 id =="..data.itemid)
	        return false
	    end
	    
	    if bagItem.num < data.number then
	    	return false
	    end

	elseif data.type == EnumDropType.COIN then
		if self.coin < data.number then
	    	return false
	    end

	elseif data.type == EnumDropType.SYCEE then
		if self.sycee < data.number then
	    	return false
	    end

	elseif data.type == EnumDropType.RECRUITINTEGRAL then
		if self.recruitIntegral < data.number then
	    	return false
	    end
	elseif data.type == EnumDropType.LOWHONOR then
		if self.lowHonor < data.number then
	    	return false
	    end
	elseif data.type == EnumDropType.HIGHTHONOR then
		if self.seniorHonor < data.number then
	    	return false
	    end
   elseif data.type == EnumDropType.ZHUXIN then
		if self.zhuxinCoin < data.number then
	    	return false
	    end	    
	elseif data.type == EnumDropType.HUIXIN then
		if self.huixinCoin < data.number then
	    	return false
	    end	
	elseif data.type == EnumDropType.FACTION_GX then
		if self.dedication < data.number then
	    	return false
	    end	 
	elseif data.type == EnumDropType.WEIWANG then
		if self.weiwang < data.number then
	    	return false
	    end	      
	else
		return false
	end

	return true
end

function MainPlayer:getGoodsNum(data)

	if data.type == EnumDropType.GOODS and data.itemid then
		local bagItem = BagManager:getItemById(data.itemid)
		if bagItem == nil then
			print("can't fint item in bag , ", data.itemid)
	        return 0
	    end
		return bagItem.num

	elseif data.type == EnumDropType.COIN then
		return self.coin

	elseif data.type == EnumDropType.SYCEE then
		return self.sycee

	elseif data.type == EnumDropType.RECRUITINTEGRAL then
		return self.recruitIntegral

	elseif data.type == EnumDropType.LOWHONOR then
		return self.lowHonor

	elseif data.type == EnumDropType.HIGHTHONOR then
		return self.seniorHonor
	elseif data.type == EnumDropType.HUIXIN then
		return self.huixinCoin

	elseif data.type == EnumDropType.ZHUXIN then
		return self.zhuxinCoin
		
	elseif data.type == EnumDropType.WEIWANG then
		return self.weiwang
	else
		return 0
	end

	return 0
end

function MainPlayer:updateDedication( value )
	self.dedication = value
end

function MainPlayer:getDedication()
	return self.dedication
end


function MainPlayer:recvVipInfo( event )
    print("event data = ", event.data)
-- ├┄┄QQ="12314",
-- ├┄┄telphone="NULL"
    self.qq		   = event.data.QQ
	self.tel	   = event.data.telphone
end
function MainPlayer:MultipleOutputListNotify( event )
    print("event data = ", event.data)
    local data = event.data
    self.multipleOutputList = {}
    if data.list == nil then
		return
    end
    for i=1,#data.list do
		local notify = data.list[i]
		self.multipleOutputList[notify.type] = notify
    end
    TFDirector:dispatchGlobalEventWith(MainPlayer.MultipleOutputNotifyMessage, {})
end

function MainPlayer:MultipleOutputNotify( event )
    print("event data = ", event.data)
    local data = event.data
    self.multipleOutputList[data.type] = self.multipleOutputList[data.type] or {}
    self.multipleOutputList[data.type] = data
    TFDirector:dispatchGlobalEventWith(MainPlayer.MultipleOutputNotifyMessage, {})
end

function MainPlayer:showMultipleOutputInfo(type)
	if self.multipleOutputList[type] and self.multipleOutputList[type].endTime >= self:getNowtime() then
		local layer =  AlertManager:addLayerByFile("lua.logic.common.TipsMessage", AlertManager.BLOCK_AND_GRAY_CLOSE)
		local title = localizable.MainPlayer_double_exp --"多倍经验"
		-- local content = "恭喜玩家获得多倍经验加成！\n双倍时间内从关卡获得的团队与侠客\n经验奖励提高为 " ..( self.multipleOutputList[type].multiple/100 ).." 倍"
		local content = stringUtils.format(localizable.MainPlayer_double_desx, ( self.multipleOutputList[type].multiple/100 ))
		layer:setText(title, content,self.multipleOutputList[type].endTime - self:getNowtime())
		AlertManager:show()
	else
		-- toastMessage("没有多倍经验加成")
		toastMessage(localizable.MainPlayer_no_double_exp)
	end
end
function MainPlayer:getPlayerProperties()
	return self.playerProperties
end

function MainPlayer:getVesselBreachValue()
	return self.vesselBreachValue
end

function MainPlayer:getClimbStarValue()
	return self.climbStar
end

function MainPlayer:getYueliValue()
	return self.yueliNum
end

--设置职业id
function MainPlayer:setProfession(professionid)
	self.profession = professionid
end

function MainPlayer:setHeadIconId(iconId)
	self.useIcon = iconId
end

function MainPlayer:getHeadIconId()
	return self.useIcon
end

function MainPlayer:getHeadPicFrameId()
	if HeadPicFrameManager:checkFrameTime(self.frameId) == false then
		self.frameId = 1
	end
	return self.frameId
end

function MainPlayer:setHeadPicFrameId(frameId)
	self.frameId = frameId
end

function MainPlayer:getHeadPicFramePath()
	return nil -- GetHeadPicFrameById(self.frameId)
end

function MainPlayer:vipRuleInfoResponse(event)
	local data = event.data
	print("vipRuleInfoResponse ==>>",data)
	-- self.vipruleTimes = {}
	if data.type == nil or data.useCount == nil  then
		return
	end
	for i=1,#data.type do
		self.vipruleTimes[data.type[i]] = data.useCount[i] or 0
	end
end

function MainPlayer:vipScoreResponse(event)
	hideLoading()
	local data = event.data
	print("MainPlayer:vipScoreResponse(event) ==== >>> ", event.data)
	local time = data.time or 0
	local bVipScoreRed = true
	if time ~= 0 then
		local nowTime = GetCorrectDate("*t", self:getNowtime())

		-- local timeArea = GetCorrectDate("*t", 0).hour
		-- local _timeArea = 8
		-- time = time - (_timeArea - timeArea)*3600
		local lastTime = GetCorrectDate("*t", time)
		print("nowTime tab === >> ", nowTime)
		print("lastTime tab === >> ", lastTime)

		if nowTime.year == lastTime.year and nowTime.month == lastTime.month and nowTime.day == lastTime.day then
			bVipScoreRed = false
		end
	end
	self.bVipScoreRed = bVipScoreRed
	CommonManager:setRedPointStateByKey( "vipScore", self.bVipScoreRed )
	TFDirector:dispatchGlobalEventWith(MainPlayer.VIP_RULE_INFO_RESPONSE, {bVipScoreRed})
end

function MainPlayer:setVipScoreRed(bRed)
	self.bVipScoreRed = bRed
end

function MainPlayer:getVipScoreRed()
	local state = false
	print("type(self.bVipScoreRed) >> ", type(self.bVipScoreRed))
	if type(self.bVipScoreRed) == "nil" or self.bVipScoreRed then
		state = true
	end
	return state
end

function MainPlayer:getVipRuleTimesByCode( code )
	self.vipruleTimes[code] = self.vipruleTimes[code] or 0
	return self.vipruleTimes[code] 
end

function MainPlayer:addVipRuleTimeByCode( code , time )
	if time == nil then
		time = 1
	end
	self.vipruleTimes[code] = self.vipruleTimes[code] or 0
	self.vipruleTimes[code] = self.vipruleTimes[code] + time
end

--added by wuqi
function MainPlayer:onFirstOnlinePrompt(event)
	local type = event.data.type
	local isPrompt = event.data.isPrompt

	print("MainPlayer:onFirstOnlinePrompt(event)")
	print("type:", type)
	print("isPrompt:", isPrompt)

	if type == 1 then
		-- 0:不要提示,1:要提示
		if isPrompt == 1 then
			self.bFirstLogin = true
		elseif isPrompt == 0 then
			self.bFirstLogin = false
		end
	end
end

function MainPlayer:setFirstLogin(b)
	self.bFirstLogin = b
end

function MainPlayer:getFirstLogin()
	return self.bFirstLogin
end

function MainPlayer:getTianxiangCoin()
	return self.tianxiangCoin or 0
end

function MainPlayer:getTianjiCoin()
	return self.tianjiCoin or 0
end
function MainPlayer:getHeiTaoUrl()
	return "smi.heitao.com/jhhd"
end
--用于更换周年庆称号
function MainPlayer:isOneYearBirth()
	return true
end

-------------------------------------------------心跳
function MainPlayer:startHeartBeat()
	print("------------------开启心跳包发送")
	if self.sendHeartBeatTime == nil  and self.recvHeartBeatTime == nil then
		self.sendHeartBeatTime = MainPlayer:getNowtime()
		self.recvHeartBeatTime = MainPlayer:getNowtime()
	end

    if  self.HeartBeatTimer == nil then
        
        self.HeartBeatTimer = TFDirector:addTimer(1000 * 20, -1, nil, 
        function() 
        	print("------------------心跳包发送。。。。。")
            TFDirector:send(c2s.HEART_BEAT_REQUEST, {})

            self.sendHeartBeatTime = MainPlayer:getNowtime()

			-- 
		    if  self.CheckHeartBeatTimer == nil then
		        self.CheckHeartBeatTimer = TFDirector:addTimer(1000 * 15, -1, nil, 
		        function() 
		        	
		            local nowTime      = MainPlayer:getNowtime()
		            local timeGap 	   = self.sendHeartBeatTime - self.recvHeartBeatTime
		            print("检查是否有收到心跳包回应")
		            print("self.sendHeartBeatTime = ",self.sendHeartBeatTime)
		            print("self.recvHeartBeatTime = ",self.recvHeartBeatTime)
		            if timeGap >= 10 then
		            	-- 超过10s没有收到心跳消息，按断线处理
		            	print("超过10s没有收到心跳消息，按断线处理")
		            	CommonManager:heartBeatcloseConnection()
		            	CommonManager:loginServer()
		            end

		           	if self.CheckHeartBeatTimer then
						print("------------------关闭心跳包检查轮询")
				        TFDirector:removeTimer(self.CheckHeartBeatTimer)
				        self.CheckHeartBeatTimer = nil
				    end

		        end)
		    end 
        end)
    end

end

function MainPlayer:stopHeartBeat()

	print("------------------关闭心跳包发送轮询")
	if self.HeartBeatTimer then
        TFDirector:removeTimer(self.HeartBeatTimer)
        self.HeartBeatTimer = nil
    end

    if self.CheckHeartBeatTimer then
		print("------------------关闭心跳包检查轮询")
        TFDirector:removeTimer(self.CheckHeartBeatTimer)
        self.CheckHeartBeatTimer = nil
    end

    self.sendHeartBeatTime = nil
    self.recvHeartBeatTime = nil
end

function MainPlayer:recvHeartBeatEvent(event)

	print("------------------收到心跳包")		
	self.recvHeartBeatTime = MainPlayer:getNowtime()
end

--版本收集 Time_7-26|defaultV_1.0.2|AppV_1.02
function MainPlayer:VersionGather()
	if CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 then
		return
	end
	if self.VersionGatherTimer then
		-- TFDirector:removeTimer(self.VersionGatherTimer)
		-- self.VersionGatherTimer = nil 
		return
	end
	local haveKey = "VersionGatherlastTime"
	local lastTime = CCUserDefault:sharedUserDefault():getStringForKey(haveKey)
	local sT = GetCorrectTime()
	if (lastTime and lastTime ~= "") then
		lastTime = tonumber(lastTime)
		local diff = sT - lastTime
		print(lastTime, " VersionGather  ",sT, " = ",diff)
		if (diff < 24 * 60 * 60) then
			return
		end
	end
	self.VersionGatherTimer = TFDirector:addTimer( math.ceil(math.random(1000, 10000)), 1, 
	function ()
		local sendStr = ""
		local defaultVersion = "0"
		local appverison = "0"
	
		local date = GetCorrectDate("*t", GetCorrectTime())
		local timeStr = date.month.."-"..date.day
		local TFClientUpdate =  TFClientResourceUpdate:GetClientResourceUpdate()
		if TFClientUpdate then
			defaultVersion = TFClientUpdate:GetUpdateDefaultVersion() or "0"
			appverison = TFDeviceInfo.getCurAppVersion() or "0"	
		end
		sendStr = "Time_"..timeStr.."|defaultV_"..defaultVersion.."|AppV_"..appverison
		print("VersionGather sendStr: ",sendStr)

		local msg = {sendStr}
		TFDirector:send(c2s.GAME_VERSION_REQEST, msg)
		if self.VersionGatherTimer then
			TFDirector:removeTimer(self.VersionGatherTimer)
			self.VersionGatherTimer = nil 
		end
		
		CCUserDefault:sharedUserDefault():setStringForKey(haveKey, sT)
    	CCUserDefault:sharedUserDefault():flush()
	end, nil)
	
end

--MainPalyer
ErrorCodeManager={}
CardRoleManager={}
BagManager={}
EquipmentManager={}
StrategyManager={}
FightManager={}
RewardManager={}
ActivityManager={}
WulinManager={}
OtherPlayerManager={}
PlayerGuideManager={}
ViewDataCache={}
MissionManager={}
ArenaManager={}
ClimbManager={}
NorthClimbManager={}
RankManager={}
MonthCardManager={}
FactionManager={}
FactionFightManager={}
FactionJiShiTangManager={}
AssistFightManager={}
WeekRaceManager={}
FactionPracticeManager={}
MallManager={}
ChatManager={}
GetCardManager={}
PayManager={}
NotifyManager={}
SettingManager={}
TaskManager={}
CommonManager={}
QiyuManager={}
RedPointManager={}
IllustrationManager={}
BloodFightManager={}
SevenDaysManager={}
GameResourceManager={}
NiuBilityManager={}
SaveManager={}
OperationActivitiesManager={}
VipRuleManager={}
MartialManager={}
BossFightManager={}
FriendManager={}
ZhengbaManager={}
FateManager={}
GoldEggManager={}
HoushanManager={}
MiningManager={}
PlayBackManager={}
EmployManager={}
QiYuanManager={}
PlayerHeadIconManager={}
HeadPicFrameManager={}
GambleManager={}
EverydayNoticeManager={}
TreasureManager={}
RecruitTalkManager={}
SkyBookManager={}
ResYesterdayManager={}
AdventureManager={}
AdventureMissionManager={}
MultiServerFightManager={}
XiaKeExchangeManager={}
LianTiManager={}
CrossGuildBattleManager={}
QianXiuManager={}
KaojiaoManager={}
LongMenPoManager={}
SevenDayPowerManager={}
CustomSkillAiManage={}
PeakManager={}
WestClimbManager={}
TianJiLunManager={}
StrategyCardManager={}
RedPacketManager={}
ChuangzhenManager={}
RechargeTicketManager={}
ResGetWayManager={}
DownResourceManager={}
SevenDayRankManager = {}
KnightManager = {}
JapanIslandManager = {}
StarHeroManager = {}
WoodActivityManager = {}
KingOfWarManager ={}
EudemonManager = {}
ActivityTipManager = {}
AutoTestManager = {}
GuildBossManager = {}
BiaoCheManager = {}
WuLinEnemyManager = {}
FanLiZhuanPanManager = {}
LangHuanManager = {}
AnniversaryManager = {}
AdventureTreasureManager = {}
GoldenCardManager = {}
XinFaManager = {}
NianShouManager = {}
HeroMeetingManager = {}
FactionDanFangManager = {}
JiangHuJuHuiManager = {}
JiSiManager = {}
TianMingManager = {}
IdentifyMainManager = {}
HeroListManager = {}
FengYunLuManager = {}
DaTiManager = {}


MPFunctions ={

---------------------
"ErrorCodeManager",
"CardRoleManager",
"BagManager",
"EquipmentManager",
"StrategyManager",
"FightManager",
"RewardManager",
"ActivityManager",
"WulinManager",
"OtherPlayerManager",
"PlayerGuideManager",
"ViewDataCache",
"MissionManager",
"ArenaManager",
"ClimbManager",
"NorthClimbManager",
"RankManager",
"MonthCardManager",
"FactionManager",
"FactionFightManager",
"FactionJiShiTangManager",
"AssistFightManager",
"WeekRaceManager",
"FactionPracticeManager",
"MallManager",
"ChatManager",
"GetCardManager",
"PayManager",
"NotifyManager",
"SettingManager",
"TaskManager",
"CommonManager",
"QiyuManager",
"RedPointManager",
"IllustrationManager",
"BloodFightManager",
"SevenDaysManager",
"GameResourceManager",
"NiuBilityManager",
"SaveManager",
"OperationActivitiesManager",
"VipRuleManager",
"MartialManager",
"BossFightManager",
"FriendManager",
"ZhengbaManager",
"FateManager",
"GoldEggManager",
"HoushanManager",
"MiningManager",
"PlayBackManager",
"EmployManager",
"QiYuanManager",
"PlayerHeadIconManager",
"HeadPicFrameManager",
"GambleManager",
"EverydayNoticeManager",
"TreasureManager",
"RecruitTalkManager",
"SkyBookManager",
"ResYesterdayManager",
"AdventureManager",
"AdventureMissionManager",
"MultiServerFightManager",
"XiaKeExchangeManager",
"LianTiManager",
"CrossGuildBattleManager",
"QianXiuManager",
"KaojiaoManager",
"LongMenPoManager",
"SevenDayPowerManager",
"CustomSkillAiManage",
"PeakManager",
"WestClimbManager",
"TianJiLunManager",
"StrategyCardManager",
"RedPacketManager",
"ChuangzhenManager",
"RechargeTicketManager",
"ResGetWayManager",
"DownResourceManager",
"SevenDayRankManager",
"KnightManager",
"JapanIslandManager",
"StarHeroManager",
"WoodActivityManager",
"KingOfWarManager",
"EudemonManager",
"ActivityTipManager",
"GuildBossManager",
"AutoTestManager",
"BiaoCheManager",
"WuLinEnemyManager",
"FanLiZhuanPanManager",
"LangHuanManager",
"AnniversaryManager",
"AdventureTreasureManager",
"GoldenCardManager",
"XinFaManager",
"NianShouManager",
"HeroMeetingManager",
"FactionDanFangManager",
"JiangHuJuHuiManager",
"JiSiManager",
"TianMingManager",
"IdentifyMainManager",
"HeroListManager",
"FengYunLuManager",
"DaTiManager",
}





MPFuncId = 1
local maxLoadNum    = BaseDataManager:getLoadNum()
local bar_load      = nil
local txt_update    = nil
local currLoad		= 0
local functionId    = 1
local isCompleted   = false
local oldLoadNum 	= 0
local MPRequireFile = BaseDataManager:GetMPRequireFile()
MPSize = #MPRequireFile

--
local function loadImpl()
    if functionId > MPSize then 
        isCompleted = true
        return 1 
    end
	local tb = TFLuaTime:clock()

    --local str =  _G[functionId]  
	local name = MPFunctions[functionId]
	if (name == nil) then
		return 0
	end  
    _G[name]   = require(MPRequireFile[functionId])  
    -- print("requirename-----------------"..requireNameList[functionId])
	
	local loadTime = TFLuaTime:clock() - tb
	print(currLoad, " ",name, " ",loadTime,functionId)
	functionId = functionId + 1  
	return TFLuaTime:clock() - tb
end

local function loadCompleted()
	if (bar_load) then
		bar_load:setPercent(100)
	end
	if (txt_update) then
		txt_update:setText(stringUtils.format(localizable.updateLaye_loading_lua_over))
	end
	_G["MainPlayer"] = MainPlayer:new()
	if not isCompleted then 
		isCompleted = true
		TFDirector:dispatchGlobalEventWith("MainPlayer.LoadOver", {})
	end
end
--
local TID = -1
TID = TFDirector:addTimer(0,MPSize, 
        function ()
        	loadCompleted()           
        end,
        function()    
        	--    TFLuaTime:begin()
            --    local name = MPFunctions[MPFuncId]
			--    if (name == nil) then
			--    		return
			--    end
            --    --print(MPFuncId)          
            --    _G[name]   = require(MPRequireFile[MPFuncId])  
            --    MPFuncId = MPFuncId + 1  
            --    --print("functionid-------"..functionId)
            --    TFLuaTime:endToLua(name)
			local dt = 0
			while dt <= 0.023 do 
				dt = dt + loadImpl() 
			end
			
			if (txt_update == nil or bar_load == nil) then
				local currentScene = TFDirector:currentScene();
				local childrenArr = currentScene:getChildren()
				for i=0,childrenArr:count()-1 do
					local child = childrenArr:objectAtIndex(i);
					local updateLayer = child:getChildByName("UpdateLayer_new")
					if (updateLayer) then
							local ui = updateLayer:getChildByName("ui")
							if (ui) then
								bar_load    = ui:getChildByName("bar_load")
								txt_update  = ui:getChildByName("txt_update")
							end
						end
					end
			end
			local maxSize       = maxLoadNum
			if (bar_load) then
				if (oldLoadNum == 0) then
					oldLoadNum 		= math.ceil(bar_load:getPercent() / 100 * maxSize)
					-- currLoad		= currLoad + 1
				end
				-- currLoad = currLoad or 0
				currLoad = functionId + oldLoadNum
				bar_load:setPercent((currLoad / maxSize) * 100)
			end
			
			if (txt_update) then
				if (bar_load:getPercent() >= 100) then
					txt_update:setText(stringUtils.format(localizable.updateLaye_loading_lua_over))
				else
					txt_update:setText(stringUtils.format(localizable.updateLaye_loading_lua, currLoad, maxSize))
				end
			end
			--
			if isCompleted then 
				loadCompleted()
                TFDirector:dispatchGlobalEventWith("MainPlayer.LoadOver", {})
                TFDirector:removeTimer(TID)
            end
        end
        )
return MainPlayer