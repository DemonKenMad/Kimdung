--[[
******英雄志管理类*******
]]


local HeroListManager = class("HeroListManager")
HeroListManager.OPEN_HERO_AMBITION     = "HeroListManager.OPEN_HERO_AMBITION";
HeroListManager.UPDATE_STARTEGY_POS     = "HeroListManager.UPDATE_STARTEGY_POS";



function HeroListManager:ctor()
	TFDirector:addProto(s2c.OPEN_HERO_AMBITION, self, self.refreshHerolistAmbition)
	TFDirector:addProto(s2c.BUY_STRENGTH, self, self.refreshHerolistStremgth)
	

	self.rewardList = HeroIcAmbitionData:getRewardList()
	--关卡数
	self.MaxBoss = #self.rewardList
	--已开启的关卡数
	self.OpenBoss = 1
	--上次的打的关卡
	self.LastBoss = 1
	--最多的免费次数
	self.MaxFreeNum = 0
	--已使用免费挑战次数
	self.UsedFreeNum = 0
	--最多购买次数
	self.MaxPurchaseNum = 0
	--已购买挑战次数
	self.PurchasedNum = 0
	--最大的挑战次数
	self.MaxNum = 0
	--已挑战的次数
	self.challengeCount = 0
	--剩余挑战次数
	self.residualCount = 0
	--昨天剩余的体力
	self.leftChallengeCount = 0
	--当前阵型排列
	self.strategylist 	= {}	
	
end
function HeroListManager:dispose()
	self.strategylist  	= nil;
end
function HeroListManager:restart()

end
function HeroListManager:getLastBoss()
	return self.LastBoss or 1
end
function HeroListManager:getMapId()
	return self.rewardList[self.LastBoss].fight_bg or 1
end
function HeroListManager:getBossInfo()
	local info = HeroIcAmbitionData:getHeroicBossInfo(self:getLastBoss())
	return info
end

function HeroListManager:refreshstrategylist()
	self.strategylist = StrategyManager:getList()
    local roleList = self.strategylist
    for index,roleGmId in pairs(roleList) do
    	local role = CardRoleManager:getRoleByGmid(roleGmId);
    	if (role) then
    		self:setRoleIndex( index, role ,0);
    		-- self:setRoleIndex(0, role ,0);
    		role.blood_tag = 0
    	else
    		local mercenary = EmployManager:getMyHireRoleDetailsByType( EnumFightStrategyType.StrategyType_BLOOY )
			if mercenary and mercenary.instanceId == roleGmId then
				self:setRoleIndex( index, mercenary ,1);
	    		mercenary.blood_tag 		= 0
			end
    	end
    end
    self:updateAllFate(false)
end
--[[
更新所有战阵的角色的缘分
]]
function HeroListManager:updateAllFate(showMessage)
	for i=1,10 do
		if self.strategylist[i] and self.strategylist[i] ~= 0 then
			local role = CardRoleManager:getRoleByGmid(self.strategylist[i])
			if role then
				role:updateFate(showMessage,false)
			end
		end
	end
end

function HeroListManager:setRoleIndex( index,role,isMercenary)
	--print("BloodFightManager:setRoleIndex = ", index)
	--print(self.strategylist)
    --安全判断
    if role == nil then
        self.strategylist[index] = 0;
        --print("shit = ")
        return;
    end

    --仅仅将卡牌下阵
	if index == 0 then
		if role.blood_pos and role.blood_pos ~= 0 then
        	self.strategylist[role.blood_pos] = 0
        	TFDirector:dispatchGlobalEventWith(self.UPDATE_STARTEGY_POS,role.blood_pos);
        	role.blood_pos = nil;
        	if isMercenary == 0 then
				role:setPosByFightType(EnumFightStrategyType.StrategyType_BLOOY, index)
			end
    	end
		return;
	end
    
    --已经在阵上，先下阵(要到新的位置去)
	if role.blood_pos and role.blood_pos ~= 0 then
    	self.strategylist[role.blood_pos] = 0;
		TFDirector:dispatchGlobalEventWith(self.UPDATE_STARTEGY_POS,role.blood_pos);
	end

    --原先的位置上有卡牌，先将其下阵（替换）
	local oldRole ,mercenary = self:getRoleByIndex(index);
	if oldRole then
	    oldRole.blood_pos = 0;
	    if mercenary == 0 then
	    	oldRole:setPosByFightType(EnumFightStrategyType.StrategyType_BLOOY, 0)
		end
	end


	self.strategylist[index] = role.gmId or role.instanceId;



	TFDirector:dispatchGlobalEventWith(self.UPDATE_STARTEGY_POS,index);

	role.blood_pos = index;
	if isMercenary == 0 then
		role:setPosByFightType(EnumFightStrategyType.StrategyType_BLOOY, index)
	end
	role.blood_tag = 1;

end
function HeroListManager:refreshHerolistAmbition(event)
	self.MaxFreeNum,self.MaxPurchaseNum,self.MaxNum = HeroIcData:getRewardNumbByLevel(MainPlayer:getLevel())
	if event.data.lastChallengeBoss and event.data.lastChallengeBoss ~= 0 then
		self.LastBoss = event.data.lastChallengeBoss
	else
		self.LastBoss = 1
	end

	self.OpenBoss = event.data.lastBrokenBoss
	self.UsedFreeNum = event.data.freeChallengeCount
	self.PurchasedNum = event.data.buyChallengeCount
	self.challengeCount = event.data.challengeCount
	self.leftChallengeCount = event.data.leftChallengeCount
	self.residualCount =  self.MaxFreeNum + self.PurchasedNum - self.challengeCount + self.leftChallengeCount
	TFDirector:dispatchGlobalEventWith(HeroListManager.OPEN_HERO_AMBITION, {})

end
function HeroListManager:refreshHerolistStremgth()
	self.MaxFreeNum,self.MaxPurchaseNum,self.MaxNum = HeroIcData:getRewardNumbByLevel(MainPlayer:getLevel())
	self.PurchasedNum = self.PurchasedNum + 1
	self.residualCount =  self.MaxFreeNum + self.PurchasedNum - self.challengeCount + self.leftChallengeCount
end

function HeroListManager:showHeroListLayer()
	self:refreshstrategylist()
	-- hideLoading()
	local layer = AlertManager:addLayerByFile("lua.logic.herolist.HeroListMainLayer",AlertManager.BLOCK_AND_GRAY,AlertManager.TWEEN_1);
    -- layer:loadData(event.data);
    AlertManager:show()
end

function HeroListManager:showHeroListVSLayer(index)
	hideLoading()
	if self.residualCount == 0 then 
		if self.PurchasedNum < self.MaxPurchaseNum then
			self:sendbutStrength()
			return
		end
	end
	local time = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.PUSH_MAP)
	if time:getLeftChallengeTimes() < self.rewardList[index].consume then
		local layer = AlertManager:addLayerToQueueAndCacheByFile("lua.logic.common.ReplyLayer",AlertManager.BLOCK_AND_GRAY_CLOSE,AlertManager.TWEEN_1);
		layer:setType(EnumRecoverableResType.PUSH_MAP,true);
		AlertManager:show()
		return
	end
	local layer = AlertManager:addLayerByFile("lua.logic.herolist.HeroListVSLayer",AlertManager.BLOCK_AND_GRAY, AlertManager.TWEEN_1);
	layer:setUserData(self.rewardList[index])
    AlertManager:show()
end
function HeroListManager:getRoleByIndex(index)
	local gmId = self.strategylist[index];
	-- ----print("gmid = ", gmId)
	if gmId == nil or gmId == 0 then
		return nil;
	end
	local role = CardRoleManager:getRoleByGmid(gmId);
	if role then
		return role , 0;
	end
	local mercenary = EmployManager:getMyHireRoleDetailsByType( EnumFightStrategyType.StrategyType_BLOOY )
	if mercenary and mercenary.instanceId == gmId then
		return mercenary , 1
	end
end

function HeroListManager:sendopenheroAmbition()
	TFDirector:send(c2s.OPEN_HERO_AMBITION,{})
end
function HeroListManager:sendChallengeHero(idx,type)
	local Msg = {
		idx,
		type
	}
	TFDirector:send(c2s.CHALLENGE_HERO_AMBITION,Msg)
	AlertManager:close();
end
function HeroListManager:sendbutStrength()
	if self.MaxPurchaseNum > self.PurchasedNum then
    	local num = HeroIcData:getSYCEEByLevelandnum(MainPlayer:getLevel(),self.PurchasedNum)
    	CommonManager:showOperateSureLayer(function()
    	   TFDirector:send(c2s.BUY_STRENGTH,{})
    	end,
    	nil,
    	{   
    	    title = localizable.replayLayer_buy_HeroList,
    	    msg = stringUtils.format(localizable.replayLayer_buy_HeroList_tips,num).."\n"..stringUtils.format(localizable.replayLayer_today_left_times,self.MaxPurchaseNum - self.PurchasedNum)
    	})
    else
    	toastMessage(localizable.replayLayer_tips)
    end
end
return HeroListManager:new()