--[[
******帮派济世堂数据管理类*******

	-- by luoconghai
	-- 2017-5-9 
]]
local FactionJiShiTangManager	= class("FactionJiShiTangManager")
GiveAchievementData			= require('lua.table.t_s_guild_give_achievement')

FactionJiShiTangManager.INFO_ME	= 1		--我的需求（信息）
FactionJiShiTangManager.INFO_MEMBER = 2		--其他帮派成员的需求（信息）

FactionJiShiTangManager.TYPE_NEED   = 2		--我的需求类型（用于捐献界面是捐献还是发布）
FactionJiShiTangManager.TYPE_GIVE	= 1		--给别人东西类型

FactionJiShiTangManager.BTN_STATUS_NOTCANGET	= 1		--不可领取
FactionJiShiTangManager.BTN_STATUS_CANGET		= 2		--可领取状态
FactionJiShiTangManager.BTN_STATUS_GET			= 3		--已领状态


FactionJiShiTangManager.RECEIVE_JISHITANG_MAIN_INFO = "FactionJiShiTangManager.RECEIVE_JISHITANG_MAIN_INFO"
FactionJiShiTangManager.MONTH_CARD_INFO_UPDATE 		= "FactionJiShiTangManager.MONTH_CARD_INFO_UPDATE"
FactionJiShiTangManager.MONTH_CARD_RefeshAttr 		= "FactionJiShiTangManager.MONTH_CARD_RefeshAttr"
FactionJiShiTangManager.GIVE_ACHIEVEMENT 			= "FactionJiShiTangManager.GIVE_ACHIEVEMENT"
FactionJiShiTangManager.REFRESH_JISHIBANG_INFO		= "FactionJiShiTangManager.REFRESH_JISHIBANG_INFO"
FactionJiShiTangManager.REFRESH_SHOUZENGJILU_INFO	= "FactionJiShiTangManager.REFRESH_SHOUZENGJILU_INFO"
FactionJiShiTangManager.RESTART_24	                = "FactionJiShiTangManager.RESTART_24"
FactionJiShiTangManager.RECEIVE_GIVE_OR_NEED_REWARD = "FactionJiShiTangManager.RECEIVE_GIVE_OR_NEED_REWARD"
function FactionJiShiTangManager:ctor(data)
	--帮派需求
	TFDirector:addProto(s2c.GUILD_GIVE_RESPONSE, self, self.receiveJiShiTangInfo)
	--排行榜
	TFDirector:addProto(s2c.GUILD_GIVE_RANK_RESPONSE, self, self.rankResponse)
	--受赠
	TFDirector:addProto(s2c.GUILD_GIVE_RECORD_RESPONSE, self, self.giveRecordResponse)
	--成就
	TFDirector:addProto(s2c.GUILD_GIVE_ACHIEVEMENT_RESPONSE, self, self.giveAchievementResponse)
	--领奖
	TFDirector:addProto(s2c.GUILD_GIVE_RECEIVE_RESPONSE, self, self.receiveRewardResponse)

	self.myRankInfo 			= {}
	self.giveAchievementIdList	= 0
	self:restart()
end

function FactionJiShiTangManager:restart()
	self.DataTable = {}
	self.giveAchievementIdList	= 0
	self.typeGive=nil
	self.oldAchievementId = nil
	self.CheckBoxStatus=false
end

function FactionJiShiTangManager:reset_24()
	self.DataTable = {}
	self.giveAchievementIdList	= 0
	self.typeGive=nil
	self.oldAchievementId = nil
end

function FactionJiShiTangManager:isopenJiShiTangByFactionLevel()
	local needFactionLevel= ConstantData:objectByID("GuildGive.OpenLevel").value or 2
	local factionInfo=FactionManager:getFactionInfo()
	if  factionInfo.level>=needFactionLevel then
		return true
	end
	return false
end

function FactionJiShiTangManager:getIsOpenJiShiTangBYServent()
	if MainPlayer:getServerSwitchStatue(ServerSwitchType.JiShiTang) == true then
        return true
    end
    return false
end


--------------发送请求协议-----------------
function FactionJiShiTangManager:requireJiShiTangInfo()
	--c2s.GUILD_GIVE_REQUEST 0x4c01
	TFDirector:send(c2s.GUILD_GIVE_REQUEST, {})
	showLoading();
end

--请求排行
function FactionJiShiTangManager:requireRankInfo()
	--c2s.GUILD_GIVE_RANK_REQUEST 0x4c04 
	showLoading();
	TFDirector:send(c2s.GUILD_GIVE_RANK_REQUEST, {})
	
end

--受赠
function FactionJiShiTangManager:requireRecord()
	--c2s.GUILD_GIVE_RECORD_REQUEST = 0x4c05
	showLoading();
	TFDirector:send(c2s.GUILD_GIVE_RECORD_REQUEST, {})
end

function FactionJiShiTangManager:requireHelp(itemType, templateId, num)
	--c2s.GUILD_GIVE_RECORD_REQUEST = 0x4c02
	showLoading();
	self.typeGive=FactionJiShiTangManager.TYPE_NEED
	local msg = {itemType, templateId, num}
	TFDirector:send(c2s.GUILD_GIVE_CHANGE_REQUEST, msg)
end

function FactionJiShiTangManager:requireGive(playerId,num)
	--c2s.GUILD_GIVE_RECORD_REQUEST = 0x4c02
	-- print("FactionJiShiTangManager:requireGive(playerId,num)",playerId,num)
	showLoading();
	self.typeGive=FactionJiShiTangManager.TYPE_GIVE
	local msg = {playerId,num}
	TFDirector:send(c2s.GUILD_GIVE_DONATE_REQUEST, msg)
end

--成就
function FactionJiShiTangManager:requireChengjiuInfo()
	showLoading();
	local msg = {}
	TFDirector:send(c2s.GUILD_GIVE_ACHIEVEMENT_REQUEST, msg)
end

--领取奖励
function FactionJiShiTangManager:requireReWard()
	showLoading();
	local msg = {}
	TFDirector:send(c2s.GUILD_GIVE_RECEIVE_REQUEST, msg)
end




------------------------收到协议返回-----------------
function FactionJiShiTangManager:receiveJiShiTangInfo(event)

	hideLoading();
	print("receiveJiShiTangInfo")
	self.DataTable = {}
	if event.data then
		self.DataTable[FactionJiShiTangManager.INFO_ME]		= event.data.myInfo
		local memberInfo=event.data.memberInfo
		if type(memberInfo)=="table" then
			for i,v in ipairs(memberInfo) do
				if v.currentNum+v.receiveNum==v.limitNum then
					v.status=2
					v.sortId=1000+i
				else
					v.status=1
					v.sortId=1000-i
				end
			end
			local function sortByStatus(v1, v2)
				if v1.status~=v2.status then
					return v1.status < v2.status
				else
					return v1.sortId < v2.sortId
				end
			end
			table.sort( memberInfo, sortByStatus )
		end
			self.DataTable[FactionJiShiTangManager.INFO_MEMBER] = memberInfo
	end

	if self.typeGive==FactionJiShiTangManager.TYPE_NEED then
		toastMessage(localizable.jishitang_need_reward)
		TFDirector:dispatchGlobalEventWith(FactionJiShiTangManager.RECEIVE_GIVE_OR_NEED_REWARD, {})
	elseif self.typeGive==FactionJiShiTangManager.TYPE_GIVE then
		toastMessage(localizable.jishitang_give_reward)
		TFDirector:dispatchGlobalEventWith(FactionJiShiTangManager.RECEIVE_GIVE_OR_NEED_REWARD, {})
	end
	self.typeGive=nil
	TFDirector:dispatchGlobalEventWith(FactionJiShiTangManager.RECEIVE_JISHITANG_MAIN_INFO, {})
	
end

function FactionJiShiTangManager:receiveRewardResponse(event)
	-- print("receiveRewardResponse",event.data)
	hideLoading();
	self.DataTable[FactionJiShiTangManager.INFO_ME].currentNum=	event.data.currentNum
	self.DataTable[FactionJiShiTangManager.INFO_ME].receiveNum=0
	-- toastMessage(localizable.zhengba_ZhengbaLayer_no_prize)
	TFDirector:dispatchGlobalEventWith(FactionJiShiTangManager.RECEIVE_JISHITANG_MAIN_INFO, {})
end



--排行信息
function FactionJiShiTangManager:rankResponse(event)
	--
	hideLoading();
	self.myRankInfo	= {}
	self.fctionRankInfo = {}
	local info = event.data
	if info then
		self.myRankInfo.myRanking	= info.myRanking		--我的排名
		self.myRankInfo.myErrantry	= info.myErrantry		--我的侠义值
		self.myRankInfo.myGuildName = info.myGuildName		--我的帮派名称
		self.myRankInfo.myName		= info.myName 			--我的名字
		self.myRankInfo.myUseCoin	= info.myUseCoin		--我的头像
		self.myRankInfo.myFrameId	= info.myFrameId		--我的头像框
		self.fctionRankInfo		= info.guildGiveRank
	end
	TFDirector:dispatchGlobalEventWith(self.REFRESH_JISHIBANG_INFO, {})
end

--受赠
function FactionJiShiTangManager:giveRecordResponse(event)
	--
	hideLoading();
	self.giveRecordInfo	= {}
	local info = event.data
	if (info and info.record ~= nil) then
		local recodeData = info.record
		table.sort(recodeData,function(a,b)	return a.time>b.time end)
		local lastTimeData = GetCorrectDate("*t", recodeData[1].time)
		local timeStr = lastTimeData.year..'-'..lastTimeData.month..'-'..lastTimeData.day
		self.giveRecordInfo[1] = {spilt = true,time = timeStr}
		for i = 1, #recodeData , 1 do 
			local timeData = GetCorrectDate("*t",recodeData[i].time)
			if (timeData.yday ~= lastTimeData.yday or timeData.year ~= lastTimeData.year) then
				local timeStr = timeData.year..'-'..timeData.month..'-'..timeData.day
				lastTimeData = timeData
				table.insert(self.giveRecordInfo,{spilt = true,time = timeStr})
			end
			table.insert(self.giveRecordInfo,recodeData[i])
		end
	end
	TFDirector:dispatchGlobalEventWith(self.REFRESH_SHOUZENGJILU_INFO, {})
end

--成就
function FactionJiShiTangManager:giveAchievementResponse(event)
	--
	hideLoading();
	self.giveAchievementIdList	= 0
	local info = event.data
	if info then
		self.giveAchievementIdList		= tonumber(info.templateId)
	end
	if self.oldAchievementId == nil then
		self.oldAchievementId = self.giveAchievementIdList
	end
	-- TFDirector:dispatchGlobalEventWith(FactionJiShiTangManager.GIVE_ACHIEVEMENT, {})
end


------------------------获取信息---------------------

function FactionJiShiTangManager:setTipsStatus(widget)
	local status= widget:getSelectedState()
	self.TipsStatus=status
end

function FactionJiShiTangManager:getTipsStatus()
	return self.TipsStatus or false
end

function FactionJiShiTangManager:setCheckBoxStatus(status)
	self.CheckBoxStatus=status
end

function FactionJiShiTangManager:getCheckBoxStatus()
	return self.CheckBoxStatus or false
end

function FactionJiShiTangManager:getJiShiTangInfoByindex(index)
	return self.DataTable[index] or {}
end

--
function FactionJiShiTangManager:getMyRankInfo()
	return self.myRankInfo
end

function FactionJiShiTangManager:getHelpStatue()
	--可需求为true--不可需求为false
	if self.DataTable[FactionJiShiTangManager.INFO_ME] and self.DataTable[FactionJiShiTangManager.INFO_ME].updateTime>0 then
		local updateTime=GetCorrectDate("*t",self.DataTable[FactionJiShiTangManager.INFO_ME].updateTime)
		local nowTime=GetCorrectDate("*t",MainPlayer:getNowtime())
		if nowTime.year>updateTime.year then
			return true
		elseif nowTime.year==updateTime.year then
			if nowTime.month>updateTime.month then
				return true
			elseif nowTime.month==updateTime.month then
				if nowTime.day>updateTime.day then
				  	return true
				end
			end
		end
	end
	return false
end
--帮派排行信息
function FactionJiShiTangManager:getFactionRankInfo()
	return self.fctionRankInfo
end

function FactionJiShiTangManager:getMemberInfoByPlayerID(playerId)
	local MemberData=self.DataTable[FactionJiShiTangManager.INFO_MEMBER]
	if MemberData then
		for k,v in pairs(MemberData) do
			if v.playerId==playerId then
				return v
			end
		end
	end
	return {}
end

function FactionJiShiTangManager:isCanGive(playerId)
	local data=self:getMemberInfoByPlayerID(playerId)
	if next(data)~=nil then
		if data.currentNum+ data.receiveNum< data.limitNum then
			return true
		end
	end
	return false
end

-- 通过下标获取排行榜的的单个信息
function FactionJiShiTangManager:getFactionRankInfoByIdx(idx)
	local rankInfo = self.fctionRankInfo[idx]
	return rankInfo
end

--受赠
function FactionJiShiTangManager:getFactionGiveRecordInfo()
	return self.giveRecordInfo
end

function FactionJiShiTangManager:updateOldAchieveId()
	self.oldAchievementId = self.giveAchievementIdList
end

function FactionJiShiTangManager:getOldAchieveId()
	if self.oldAchievementId then
		return self.oldAchievementId;
	end
	return 0;
end

--捐赠返回侠义值数量
function FactionJiShiTangManager:getGiveArawdByItemNum(itemId, itemType, itemQuality, itemNum)
	local str 	= "GuildGive.Goods"..itemType.."_"..itemQuality
	local data 	= ConstantData:objectByID(str)
	local num 	= 0
	if (data) then
		num = tonumber(data.value) * itemNum
	end
	return num
end

--获取我的侠义值
function FactionJiShiTangManager:getMyErrantry()
	return self.myRankInfo.myErrantry
end
--
function FactionJiShiTangManager:getGiveAchievementAttr(fightType)
	if not self:getIsOpenJiShiTangBYServent() then
		return {}
	end
	-- GiveAchievementData
	if (fightType ~= EnumFightStrategyType.StrategyType_PVE and 
		fightType ~= EnumFightStrategyType.StrategyType_CHAMPIONS_DEF and
		fightType ~= EnumFightStrategyType.StrategyType_CROSSZHENGBA) then
		return {}
	end
	local attrList		= {}
	local beAttrList	= {}
	local effectAttrList = {}
	local power = 0
	if(self.giveAchievementIdList > 0) then
		-- for i, id in ipairs(self.giveAchievementIdList) do
		-- 	local data = GiveAchievementData:objectByID(tonumber(id))
		-- 	if (data) then
		-- 		local attr1 = string.split(data.attribute, "|")
		-- 		for _, v in ipairs(attr1) do
		-- 			local attr2 = string.split(v, "_")
		-- 			local atrrId 		= tonumber(attr2[1])
		-- 			local atrrValue 	= tonumber(attr2[2]) or 0
		-- 			attrList[atrrId] = attrList[atrrId] or {}
		-- 			attrList[atrrId] = attrList[atrrId] + atrrValue
		-- 		end
		-- 	end
		-- end
		for i=1,self.giveAchievementIdList do
			local data = GiveAchievementData:objectByID(tonumber(i))
			if (data) then
				if (data.attribute ~= nil and data.attribute ~= "") then
					local attr1 = string.split(data.attribute, "|")
					for _, v in ipairs(attr1) do
						local attr2 = string.split(v, "_")
						local atrrId 		= tonumber(attr2[1])
						local atrrValue 	= tonumber(attr2[2]) or 0
						attrList[atrrId] = attrList[atrrId] or 0
						attrList[atrrId] = attrList[atrrId] + atrrValue
					end
				end
				if (data.effect_active ~= nil and data.effect_active ~= "") then
					local attr1 = string.split(data.effect_active, "|")
					for _, v in ipairs(attr1) do
						local attr2 = string.split(v, "_")
						local atrrId 		= tonumber(attr2[1])
						local atrrValue 	= tonumber(attr2[2]) or 0
						effectAttrList[atrrId] = effectAttrList[atrrId] or 0
						effectAttrList[atrrId] = effectAttrList[atrrId] + atrrValue
					end
				end
				if (data.effect_passive ~= nil and data.effect_passive ~= "") then
					local attr1 = string.split(data.effect_passive, "|")
					for _, v in ipairs(attr1) do
						local attr2 = string.split(v, "_")
						local atrrId 		= tonumber(attr2[1])
						local atrrValue 	= tonumber(attr2[2]) or 0
						beAttrList[atrrId] = beAttrList[atrrId] or 0
						beAttrList[atrrId] = beAttrList[atrrId] + atrrValue
					end
				end
			end
			power = power + data.power
		end
	end
	return attrList,beAttrList, power, effectAttrList
end


function FactionJiShiTangManager:getRedPiontStatus()
	if self.DataTable[FactionJiShiTangManager.INFO_ME] and self.DataTable[FactionJiShiTangManager.INFO_ME].receiveNum>0 then
		return true
	end
	return false
end

--
function FactionJiShiTangManager:openJiShiTameMainLayer()

	if not self:getIsOpenJiShiTangBYServent() then
		toastMessage(localizable.jishitang_unOpen)
		return
	end
	if not self:isopenJiShiTangByFactionLevel() then
		local needFactionLevel= ConstantData:objectByID("GuildGive.OpenLevel").value or 2
		toastMessage(stringUtils.format(localizable.jishitang_open,needFactionLevel))
		return
	end
	FactionJiShiTangManager:requireJiShiTangInfo()
	AlertManager:addLayerByFile('lua.logic.faction.JiShiTangMainLayer', AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1)
	AlertManager:show()
end

function FactionJiShiTangManager:openJiShiTangChooseLayer()
	
	local layer=AlertManager:addLayerByFile('lua.logic.faction.JiShiTangChooseLayer',AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_NONE)
	layer:loadData()
    AlertManager:show()
end


function FactionJiShiTangManager:openJiShiTangGiveLayer(data,type,CheckBoxStatus)
	local layer=AlertManager:addLayerByFile('lua.logic.faction.JiShiTangNumberLayer',AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1)
	layer:loadData(data,type,CheckBoxStatus)
    AlertManager:show()
end

-- 济世堂排行
function FactionJiShiTangManager:openJiShiBangLayer()
	self:requireRankInfo()
	AlertManager:addLayerByFile("lua.logic.faction.JiShiBang",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
	AlertManager:show()
end

-- 济世堂获赠记录
function FactionJiShiTangManager:openShouZengJiLuLayer()
	self:requireRecord()
	AlertManager:addLayerByFile("lua.logic.faction.ShouZengJiLu",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
	AlertManager:show()
end

function FactionJiShiTangManager:openChengjiuLayer()
	self:requireRankInfo()
	AlertManager:addLayerByFile("lua.logic.faction.JiShiTangchengjiuLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1)
	AlertManager:show()
end

return FactionJiShiTangManager:new() 