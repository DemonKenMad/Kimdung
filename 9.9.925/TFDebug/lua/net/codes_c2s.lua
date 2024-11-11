local c2s = {}
--[[
	[1] = {--Worship
		[1] = 'int32':type	[祭拜类型]
	}
--]]
c2s.WORSHIP = 0x440d

--[[
	[1] = {--DrawMakePlayerAward
	}
--]]
c2s.DRAW_MAKE_PLAYER_AWARD = 0x4410

--[[
	[1] = {--LockPlayerMine
		[1] = 'int32':minePlayerId	[被劫矿的玩家]
		[2] = 'int32':id	[1,矿1,2,矿2]
	}
--]]
c2s.LOCK_PLAYER_MINE = 0x5009

--[[
	[1] = {--RequestExchangeGifts
		[1] = 'string':code	[礼包码]
	}
--]]
c2s.REQUEST_EXCHANGE_GIFTS = 0x3500

--[[
	[1] = {--BibleLevelUpRequest
		[1] = 'int64':instanceId	[id]
	}
--]]
c2s.BIBLE_LEVEL_UP_REQUEST = 0x6010

--[[
	[1] = {--GetActivityReward
		[1] = 'int32':type	[活动类型]
		[2] = 'int32':rewardId	[奖励配置表的ID]
	}
--]]
c2s.GET_ACTIVITY_REWARD = 0x3305

--[[
	[1] = {--PeakRankingHistoryRequest
	}
--]]
c2s.PEAK_RANKING_HISTORY_REQUEST = 0x7109

--[[
	[1] = {--IncreaseStepsExp
		[1] = {--repeated StepGoods
			[1] = 'int32':id
			[2] = 'int32':num
		},
		[2] = 'int64':equipmentId
	}
--]]
c2s.INCREASE_STEPS_EXP = 0x1057

--[[
	[1] = {--MountBookMsg
		[1] = 'int64':bookObjID	[book实例id]
		[2] = 'int64':roleID	[角色id]
		[3] = 'int32':position	[位置]
		[4] = 'bool':mount	[1 穿上 0卸下]
	}
--]]
c2s.MOUNT_BOOK = 0x1607

--[[
	[1] = {--AllTreasureInfo
		[1] = 'int32':rowId	[初始化玩家图标位置时,玩家所在的行数]
		[2] = 'int32':columnId	[初始化玩家图标位置时,玩家所在的列数]
	}
--]]
c2s.ALL_TREASURE_INFO = 0x5930

--[[
	[1] = {--QueryEmployRoleByUse
		[1] = 'int32':useType	[使用类型,客户端定义]
	}
--]]
c2s.QUERY_EMPLOY_ROLE_BY_USE = 0x5112

--[[
	[1] = {--BuyBackInfoRequest
	}
--]]
c2s.BUY_BACK_INFO_REQUEST = 0x5b01

--[[
	[1] = {--UpdateGuildName
		[1] = 'string':Name	[新的名称]
	}
--]]
c2s.UPDATE_GUILD_NAME = 0x4428

--[[
	[1] = {--ContestTeamInspireRequest
		[1] = 'int64':id	[ 队伍唯一标识]
		[2] = 'int32':playerId	[ 被鼓舞的玩家ID]
		[3] = 'int32':sycee	[ 鼓舞消耗的元宝]
	}
--]]
c2s.CONTEST_TEAM_INSPIRE_REQUEST = 0x6e10

--[[
	[1] = {--SerdangSweepRequest
		[1] = 'int32':floorId	[层数]
		[2] = 'int32':times	[扫荡次数]
	}
--]]
c2s.SERDANG_SWEEP_REQUEST = 0x7203

--[[
	[1] = {--SwapCurrentChatPlayer
		[1] = 'int32':playerId	[玩家编号]
	}
--]]
c2s.SWAP_CURRENT_CHAT_PLAYER = 0x1b04

--[[
	[1] = {--BloodySweepRequest
	}
--]]
c2s.BLOODY_SWEEP_REQUEST = 0x3230

--[[
	[1] = {--TeamChatRequest
		[1] = 'string':msg	[ 聊天信息]
	}
--]]
c2s.TEAM_CHAT_REQUEST = 0x5923

--[[
	[1] = {--RolePractice
		[1] = 'int64':userid	[所需要修炼的角色实例id]
		[2] = 'int32':oneKey	[一键突破 0否 1是]
		[3] = 'int32':breakType	[突破类型]
		[4] = 'int32':isUseGeneral	[是否使用万能侠魂 0否 1是]
	}
--]]
c2s.ROLE_PRACTICE = 0x1509

--[[
	[1] = {--GuildDanFangInfoRequest
	}
--]]
c2s.GUILD_DAN_FANG_INFO_REQUEST = 0x5e01

--[[
	[1] = {--RequestAllActivityInfo
	}
--]]
c2s.REQUEST_ALL_ACTIVITY_INFO = 0x2301

--[[
	[1] = {--CreateGuild
		[1] = 'string':name	[名称]
		[2] = 'string':bannerId	[旗帜id]
	}
--]]
c2s.CREATE_GUILD = 0x4401

--[[
	[1] = {--GangGetBuffInfo
	}
--]]
c2s.GANG_GET_BUFF_INFO = 0x1815

--[[
	[1] = {--BattleArrayExchangeRequest
		[1] = 'int64':instanceId	[ 阵法唯一ID 1]
		[2] = 'int64':exInstanceId	[ 阵法唯一ID 2]
		[3] = 'bool':challengeStar
	}
--]]
c2s.BATTLE_ARRAY_EXCHANGE_REQUEST = 0x6a07

--[[
	[1] = {--EssentialUnMosaicRequest
		[1] = 'int64':bible	[精要的天书id]
		[2] = 'int32':pos	[卸下的精要的位置]
	}
--]]
c2s.ESSENTIAL_UN_MOSAIC_REQUEST = 0x6005

--[[
	[1] = {--queryBloodyBox
		[1] = 'int32':section	[关卡号(从1开始)    //关卡号(从1开始)]
	}
--]]
c2s.QUERY_BLOODY_BOX = 0x3211

--[[
	[1] = {--RequestRefineBreach
		[1] = 'int64':instanceId	[装备实例ID]
	}
--]]
c2s.REQUEST_REFINE_BREACH = 0x1080

--[[
	[1] = {--GameVersionReqest
		[1] = 'string':version	[版本]
	}
--]]
c2s.GAME_VERSION_REQEST = 0x7f33

--[[
	[1] = {--GetRebateTurntableRequest
	}
--]]
c2s.GET_REBATE_TURNTABLE_REQUEST = 0x7d02

--[[
	[1] = {--EquipmentRefining
		[1] = 'int64':equipment	[装备userid]
		[2] = 'repeated int32':lock_attr	[锁定的属性行]
	}
--]]
c2s.EQUIPMENT_REFINING = 0x1019

--[[
	[1] = {--GuildGiveAchievementRequest
	}
--]]
c2s.GUILD_GIVE_ACHIEVEMENT_REQUEST = 0x4c06

--[[
	[1] = {--LongMenBreakUseXuanJiJingRequest
		[1] = 'int32':floor	[ 层数]
		[2] = 'int32':goodsId	[道具id]
	}
--]]
c2s.LONG_MEN_BREAK_USE_XUAN_JI_JING_REQUEST = 0x6903

--[[
	[1] = {--RequestSacrificeByType
		[1] = 'int32':type	[赌石类型,1.试刀;2.切割;4.打磨;8.精工;16.雕琢]
	}
--]]
c2s.REQUEST_SACRIFICE_BY_TYPE = 0x3e00

--[[
	[1] = {--BattlePetEquipFormationRequest
		[1] = 'int64':instanceId	[战宠id]
		[2] = 'int32':formationType	[阵型类型]
		[3] = 'int32':type	[1 装备 2 卸下]
	}
--]]
c2s.BATTLE_PET_EQUIP_FORMATION_REQUEST = 0x4f04

--[[
	[1] = {--StepsThrough
		[1] = 'int64':equipmentId
	}
--]]
c2s.STEPS_THROUGH = 0x1058

--[[
	[1] = {--GainAssistantInfo
	}
--]]
c2s.GAIN_ASSISTANT_INFO = 0x4601

--[[
	[1] = {--ApplyCrossGuildBattle
		[1] = 'int32':index
	}
--]]
c2s.APPLY_CROSS_GUILD_BATTLE = 0x443a

--[[
	[1] = {--ToBattle
		[1] = {--RoleConfigure
			[1] = 'int64':userId
			[2] = 'int32':index
		},
	}
--]]
c2s.TO_BATTLE = 0x0e21

--[[
	[1] = {--GetMinRequest
		[1] = 'int32':type	[类型]
	}
--]]
c2s.GET_MIN_REQUEST = 0x3309

--[[
	[1] = {--BuyRemanentReward
	}
--]]
c2s.BUY_REMANENT_REWARD = 0x592b

--[[
	[1] = {--ExecApplyFriend
		[1] = 'int32':type	[ 类型 1同意单个 2 同意全部 3 忽略单个 4 忽略全部]
		[2] = 'int32':playerId
	}
--]]
c2s.EXEC_APPLY_FRIEND = 0x4304

--[[
	[1] = {--ResetChallengeMine
		[1] = 'int32':type	[矿洞]
		[2] = 'int32':minePlayerId	[被重置的玩家id]
	}
--]]
c2s.RESET_CHALLENGE_MINE = 0x500f

--[[
	[1] = {--GrouponBuyRequest
		[1] = 'int32':goodsId	[商品id]
		[2] = 'int32':num	[商品数量]
	}
--]]
c2s.GROUPON_BUY_REQUEST = 0x5c02

--[[
	[1] = {--ChallengeNorthCave
		[1] = 'int32':sectionId	[目标关卡ID,1~N]
		[2] = 'int32':choice	[挑战关卡选项]
		[3] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.CHALLENGE_NORTH_CAVE = 0x4901

--[[
	[1] = {--EquipDestiny
		[1] = 'int64':instanceId	[天命实例id]
		[2] = 'int32':pos	[位置]
		[3] = 'int64':roldId	[镶嵌角色id]
	}
--]]
c2s.EQUIP_DESTINY = 0x3f02

--[[
	[1] = {--ReConnectRequest
		[1] = 'string':accountId	[帐号id]
		[2] = 'string':validateCode	[登录完成后获得的校验码]
		[3] = 'int32':serverId	[服务器唯一标识]
		[4] = 'string':token	[设备token]
		[5] = 'string':deviceName	[设备名称]
		[6] = 'string':osName	[设备系统名称]
		[7] = 'string':osVersion	[设备系统版本]
		[8] = 'string':channel	[渠道]
		[9] = 'string':sdk	[第三方接入类型.如:PP.91等]
		[10] = 'string':deviceid	[设备ID唯一标识]
		[11] = 'string':sdkVersion	[SDK版本]
		[12] = 'string':MCC	[移动设备国家码]
		[13] = 'string':IP	[联网IP地址]
	}
--]]
c2s.RE_CONNECT_REQUEST = 0x0d10

--[[
	[1] = {--GainGuildInfo
		[1] = 'int32':guildId
	}
--]]
c2s.GAIN_GUILD_INFO = 0x4406

--[[
	[1] = {--BreachAllDestiny
		[1] = 'int64':instanceId
		[2] = 'bool':isHish	[ 高级:true,普通:false]
	}
--]]
c2s.BREACH_ALL_DESTINY = 0x3f07

--[[
	[1] = {--GetBrokerage
	}
--]]
c2s.GET_BROKERAGE = 0x5005

--[[
	[1] = {--ContestBetRequest
		[1] = 'int32':coin	[ 押注的铜币数]
		[2] = 'int32':sycee	[ 押注的元宝数]
		[3] = 'int32':type	[ 0押注上一届擂主 1押注这一届挑战者]
	}
--]]
c2s.CONTEST_BET_REQUEST = 0x6e11

--[[
	[1] = {--GetFixedStore
	}
--]]
c2s.GET_FIXED_STORE = 0x1901

--[[
	[1] = {--DatiStartRequest
	}
--]]
c2s.DATI_START_REQUEST = 0x3b01

--[[
	[1] = {--TestChallengeSection
		[1] = 'int32':sectionId
	}
--]]
c2s.TEST_CHALLENGE_SECTION = 0xee00

--[[
	[1] = {--GainGuildZoneInfo
		[1] = 'int32':zoneId
	}
--]]
c2s.GAIN_GUILD_ZONE_INFO = 0x4421

--[[
	[1] = {--ChallengeMiningPoint
		[1] = 'int32':type	[宝藏类型.1:连城宝藏;2:闯王宝藏;3:大清龙脉]
		[2] = 'int32':index	[宝藏挖掘点索引,第几个位置.1--n    //宝藏挖掘点索引,第几个位置.1--n]
		[3] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.CHALLENGE_MINING_POINT = 0x2200

--[[
	[1] = {--ViewNotice
	}
--]]
c2s.VIEW_NOTICE = 0x4431

--[[
	[1] = {--UnequipBibleRequest
		[1] = 'int64':roleId	[角色实例id]
		[2] = 'int64':bible	[要脱下的天书userid]
	}
--]]
c2s.UNEQUIP_BIBLE_REQUEST = 0x6002

--[[
	[1] = {--GetSettlementRewardInfoRequest
	}
--]]
c2s.GET_SETTLEMENT_REWARD_INFO_REQUEST = 0x6f0a

--[[
	[1] = {--AdventurePlayerBattle
		[1] = 'int32':type	[ 类型 20.杀戮21.复仇22.挑战排行榜]
		[2] = 'int32':playerId	[ 玩家ID]
	}
--]]
c2s.ADVENTURE_PLAYER_BATTLE = 0x5911

--[[
	[1] = {--Impeachment
		[1] = 'string':desc	[弹劾描述]
	}
--]]
c2s.IMPEACHMENT = 0x4450

--[[
	[1] = {--SendGuildMail
		[1] = 'string':title	[標題]
		[2] = 'string':content	[內容]
	}
--]]
c2s.SEND_GUILD_MAIL = 0x4432

--[[
	[1] = {--ChallengeMission
		[1] = 'int32':missionId
		[2] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.CHALLENGE_MISSION = 0x1201

--[[
	[1] = {--EquipRequest
		[1] = 'int64':roleId	[角色实例id]
		[2] = 'int64':equipment	[装备到身上的装备userid]
	}
--]]
c2s.EQUIP_REQUEST = 0x1011

--[[
	[1] = {--GrouponInfoRequest
	}
--]]
c2s.GROUPON_INFO_REQUEST = 0x5c01

--[[
	[1] = {--ShuffleBloodyBox
		[1] = 'int32':section	[关卡号(从1开始)    //关卡号(从1开始)]
		[2] = 'int32':index	[奖品索引号(客户端:1-6 服务端4-24)    //奖品索引号(客户端:1-6 服务端4-24)]
	}
--]]
c2s.SHUFFLE_BLOODY_BOX = 0x3213

--[[
	[1] = {--ExLoadDestiny
		[1] = 'repeated int64':instanceId
	}
--]]
c2s.EX_LOAD_DESTINY = 0x3f05

--[[
	[1] = {--BloodyOffBattle
		[1] = 'int64':roleId	[角色id]
	}
--]]
c2s.BLOODY_OFF_BATTLE = 0x3203

--[[
	[1] = {--HomeLevelUpRequest
		[1] = {--repeated ConsumeItem
			[1] = 'int32':id	[ 道具的id]
			[2] = 'int32':num	[ 道具的数量]
		},
	}
--]]
c2s.HOME_LEVEL_UP_REQUEST = 0x7401

--[[
	[1] = {--GainGuildActiveRedPacketInfo
	}
--]]
c2s.GAIN_GUILD_ACTIVE_RED_PACKET_INFO = 0x4445

--[[
	[1] = {--GainLadderFormation
		[1] = 'int32':index
	}
--]]
c2s.GAIN_LADDER_FORMATION = 0x7906

--[[
	[1] = {--GetGoldenCardDailyReward
	}
--]]
c2s.GET_GOLDEN_CARD_DAILY_REWARD = 0x7c02

--[[
	[1] = {--ArenaChallengePlayer
		[1] = 'int32':playerId
	}
--]]
c2s.ARENA_CHALLENGE_PLAYER = 0x1304

--[[
	[1] = {--GangRefleshBuffInfo
	}
--]]
c2s.GANG_REFLESH_BUFF_INFO = 0x1816

--[[
	[1] = {--PowerExamLogRequest
	}
--]]
c2s.POWER_EXAM_LOG_REQUEST = 0x1d43

--[[
	[1] = {--AdventureInterface
	}
--]]
c2s.ADVENTURE_INTERFACE = 0x5900

--[[
	[1] = {--BuriedTreasure
		[1] = 'int32':rowId	[挖宝物时,服务器需要的坐标行id]
		[2] = 'int32':columnId	[挖宝物时,服务器需要的坐标列id]
		[3] = 'int32':isHiddenName	[玩家是否匿名埋宝]
		[4] = 'int64':id	[玩家背包宝箱实例ID]
	}
--]]
c2s.BURIED_TREASURE = 0x5932

--[[
	[1] = {--PurchaseOrderForHeroStore
		[1] = 'int32':commodityId	[购买商品的id]
		[2] = 'int32':num	[购买商品的个数]
	}
--]]
c2s.PURCHASE_ORDER_FOR_HERO_STORE = 0x1906

--[[
	[1] = {--EmployTeamDetailsQuery
		[1] = 'int32':playerId	[目标玩家ID]
		[2] = 'int32':useType	[使用类型]
	}
--]]
c2s.EMPLOY_TEAM_DETAILS_QUERY = 0x5161

--[[
	[1] = {--BuyBackBuyRequest
		[1] = 'int32':goodsId	[商品id]
		[2] = 'int32':num	[数量]
	}
--]]
c2s.BUY_BACK_BUY_REQUEST = 0x5b02

--[[
	[1] = {--RequestActivityProgressList
	}
--]]
c2s.REQUEST_ACTIVITY_PROGRESS_LIST = 0x2303

--[[
	[1] = {--RequestMercenaryTeamListOutline
		[1] = 'int32':startIndex	[起始索引]
		[2] = 'int32':length	[单次请求数据条目的数量]
	}
--]]
c2s.REQUEST_MERCENARY_TEAM_LIST_OUTLINE = 0x5150

--[[
	[1] = {--QueryPlayer
		[1] = 'string':name
	}
--]]
c2s.QUERY_PLAYER = 0x430d

--[[
	[1] = {--SendRedPoint
	}
--]]
c2s.SEND_RED_POINT = 0x5939

--[[
	[1] = {--QueryActivityRankList
		[1] = 'int32':type	[排行榜类型.0:全部]
	}
--]]
c2s.QUERY_ACTIVITY_RANK_LIST = 0x3303

--[[
	[1] = {--TreasureDetails
		[1] = 'int32':mapId	[(挖埋)宝箱记录的实例ID    //(挖埋)宝箱记录的实例ID]
	}
--]]
c2s.TREASURE_DETAILS = 0x5936

--[[
	[1] = {--CheckSensitiveVocabularyRequest
		[1] = 'string':name	[ 名字]
	}
--]]
c2s.CHECK_SENSITIVE_VOCABULARY_REQUEST = 0x0e9e

--[[
	[1] = {--UpdateCrossApply
		[1] = {--repeated ApplyCrossTeam
			[1] = 'repeated int32':members
			[2] = 'int32':flag
		},
	}
--]]
c2s.UPDATE_CROSS_APPLY = 0x4442

--[[
	[1] = {--RequestMartialSynthesis
		[1] = 'int32':martialId	[合成产出的武学]
		[2] = 'bool':autoSynthesis	[是否自动合成,只有在没有该武学,但是又拥有足够材料的情况下才为true,可以节省用户合成所需要的操作,由客户端进行智能验证填写,如果客户端不支持智能校验则填写为false]
	}
--]]
c2s.REQUEST_MARTIAL_SYNTHESIS = 0x3404

--[[
	[1] = {--GetMHYPassInfoRequest
	}
--]]
c2s.GET_MHYPASS_INFO_REQUEST = 0x1721

--[[
	[1] = {--OneKeyMergeGoodsMsg
		[1] = 'int32':type	[物品类型,0.全部;1.秘籍.武学碎片;2.装备碎片]
	}
--]]
c2s.ONE_KEY_MERGE_GOODS = 0x1065

--[[
	[1] = {--GangGetExchangeList
	}
--]]
c2s.GANG_GET_EXCHANGE_LIST = 0x1811

--[[
	[1] = {--DataCollectRequest
		[1] = 'int32':type	[类型]
	}
--]]
c2s.DATA_COLLECT_REQUEST = 0x5d01

--[[
	[1] = {--SignerRequest
		[1] = 'int32':rewardId	[奖励索引]
	}
--]]
c2s.SIGNER_REQUEST = 0x7e05

--[[
	[1] = {--HomePraise
		[1] = 'int32':friendId
	}
--]]
c2s.HOME_PRAISE = 0x7407

--[[
	[1] = {--UnEquipBattleArrayRequest
		[1] = 'int32':type	[ 阵容类型]
	}
--]]
c2s.UN_EQUIP_BATTLE_ARRAY_REQUEST = 0x6a01

--[[
	[1] = {--BattlePetTameUpdateRequest
		[1] = 'int64':instanceId	[战宠Id]
		[2] = 'int32':holeId	[孔位]
		[3] = 'int32':type	[属性类型]
	}
--]]
c2s.BATTLE_PET_TAME_UPDATE_REQUEST = 0x4f0a

--[[
	[1] = {--SweepSection
		[1] = 'int32':missionId	[关卡Id]
		[2] = 'int32':time	[扫荡次数]
	}
--]]
c2s.SWEEP_SECTION = 0x1205

--[[
	[1] = {--ProvideFriendAssistant
		[1] = 'repeated int32':friendIds	[提供给你人]
	}
--]]
c2s.PROVIDE_FRIEND_ASSISTANT = 0x4311

--[[
	[1] = {--RequestSacrificePick
	}
--]]
c2s.REQUEST_SACRIFICE_PICK = 0x3e02

--[[
	[1] = {--DrawDpsAward
		[1] = 'int32':zoneId
		[2] = 'int32':awardId
	}
--]]
c2s.DRAW_DPS_AWARD = 0x4420

--[[
	[1] = {--GainRankInfo
	}
--]]
c2s.GAIN_RANK_INFO = 0x4509

--[[
	[1] = {--ChallengeWorldBoss
		[1] = 'int32':targetId	[目标BOSS配置ID]
		[2] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
		[3] = 'int32':isAllOut	[是否全力一击的标识,大于0为全力一击]
	}
--]]
c2s.CHALLENGE_WORLD_BOSS = 0x4200

--[[
	[1] = {--LongMenBreakPushRewardRequest
	}
--]]
c2s.LONG_MEN_BREAK_PUSH_REWARD_REQUEST = 0x6908

--[[
	[1] = {--GainRecommendFriend
	}
--]]
c2s.GAIN_RECOMMEND_FRIEND = 0x4302

--[[
	[1] = {--GangGetDynamicInfo
	}
--]]
c2s.GANG_GET_DYNAMIC_INFO = 0x1802

--[[
	[1] = {--GangExit
	}
--]]
c2s.GANG_EXIT = 0x1809

--[[
	[1] = {--OneKeyEquipRefine
		[1] = 'int64':instanceId	[装备实例ID]
		[2] = 'repeated int32':lock_attr	[锁定的属性行]
	}
--]]
c2s.ONE_KEY_EQUIP_REFINE = 0x1081

--[[
	[1] = {--GetCardContractDailyReward
	}
--]]
c2s.GET_CARD_CONTRACT_DAILY_REWARD = 0x2803

--[[
	[1] = {--RoleRebirth
		[1] = 'int64':userid	[所需要重生的角色实例id]
		[2] = 'bool':force	[是否强制重生]
	}
--]]
c2s.ROLE_REBIRTH = 0x1511

--[[
	[1] = {--RequestHeartExchange
		[1] = 'int64':instanceId	[置换天书1]
		[2] = 'int64':exInstanceId	[置换天书2]
	}
--]]
c2s.REQUEST_HEART_EXCHANGE = 0x7b14

--[[
	[1] = {--GagPlayerRequest
		[1] = 'int32':targetId	[目标玩家ID]
		[2] = 'int32':type	[操作类型]
	}
--]]
c2s.GAG_PLAYER_REQUEST = 0x7f30

--[[
	[1] = {--OpenWorshipBox
		[1] = 'int32':num	[宝箱值]
	}
--]]
c2s.OPEN_WORSHIP_BOX = 0x440e

--[[
	[1] = {--ClimbGetHomeInfo
	}
--]]
c2s.CLIMB_GET_HOME_INFO = 0x1702

--[[
	[1] = {--ImpeachmentMsgRequest
	}
--]]
c2s.IMPEACHMENT_MSG_REQUEST = 0x4451

--[[
	[1] = {--OpenHomeRequest
	}
--]]
c2s.OPEN_HOME_REQUEST = 0x7400

--[[
	[1] = {--RequestHeartMethodPractice
		[1] = 'bool':isOneKey	[ 一键合成(true),否(false)    // 一键合成(true),否(false)]
		[2] = 'int32':id	[ 	当前心法修炼ID]
		[3] = 'int64':instanceId	[ 心法实例ID]
	}
--]]
c2s.REQUEST_HEART_METHOD_PRACTICE = 0x7b06

--[[
	[1] = {--OpenPoint
		[1] = 'int32':point
	}
--]]
c2s.OPEN_POINT = 0x7604

--[[
	[1] = {--DrawDropGoods
		[1] = 'int32':index	[掉落的物品组下标]
	}
--]]
c2s.DRAW_DROP_GOODS = 0x6111

--[[
	[1] = {--GetPayRecordList
	}
--]]
c2s.GET_PAY_RECORD_LIST = 0x1a04

--[[
	[1] = {--EscortAgencyRestRequest
		[1] = 'int32':updateFormation	[0:否  1:同步阵容]
	}
--]]
c2s.ESCORT_AGENCY_REST_REQUEST = 0x5f05

--[[
	[1] = {--ContestWatchReplayRequest
		[1] = 'int32':id	[ 录像ID]
	}
--]]
c2s.CONTEST_WATCH_REPLAY_REQUEST = 0x6e16

--[[
	[1] = {--DigHistory
	}
--]]
c2s.DIG_HISTORY = 0x5935

--[[
	[1] = {--ContestTeamInviteRequest
		[1] = 'int64':id	[ 队伍唯一标识]
		[2] = 'repeated int32':playerId	[ 当playerId 在邀请列表的时候为取消邀请]
	}
--]]
c2s.CONTEST_TEAM_INVITE_REQUEST = 0x6e04

--[[
	[1] = {--QueryBloodyEnemyInfo
		[1] = 'int32':section	[关卡号(从1开始)    //关卡号(从1开始)]
	}
--]]
c2s.QUERY_BLOODY_ENEMY_INFO = 0x3208

--[[
	[1] = {--FreshMineList
	}
--]]
c2s.FRESH_MINE_LIST = 0x5007

--[[
	[1] = {--SummonPaladin
		[1] = 'int32':soulId	[侠魂ID]
	}
--]]
c2s.SUMMON_PALADIN = 0x0e90

--[[
	[1] = {--BibleGemUnMosaic
		[1] = 'int64':bibleId	[卸下的天书id]
		[2] = 'int32':pos	[卸下的位置]
	}
--]]
c2s.BIBLE_GEM_UN_MOSAIC = 0x6013

--[[
	[1] = {--GuildDanFangLevelUpRequest
		[1] = 'int32':id	[原材料id]
	}
--]]
c2s.GUILD_DAN_FANG_LEVEL_UP_REQUEST = 0x5e02

--[[
	[1] = {--GoinDownLoadRequest
	}
--]]
c2s.GOIN_DOWN_LOAD_REQUEST = 0x2074

--[[
	[1] = {--RequestResetArenaCD
	}
--]]
c2s.REQUEST_RESET_ARENA_CD = 0x1308

--[[
	[1] = {--RoleHermit
		[1] = 'repeated int64':dogfoodlist	[消耗角色实例id]
		[2] = {--repeated RoleSoulInfo
			[1] = 'int32':id	[角色的id]
			[2] = 'int32':num	[角色魂魄的数量]
		},
		[3] = 'bool':force	[是否强制归隐]
	}
--]]
c2s.ROLE_HERMIT = 0x1510

--[[
	[1] = {--GainGuildBattleWarInfos
		[1] = 'int32':cityId
	}
--]]
c2s.GAIN_GUILD_BATTLE_WAR_INFOS = 0x4439

--[[
	[1] = {--HomeLevelShareRequest
	}
--]]
c2s.HOME_LEVEL_SHARE_REQUEST = 0x7405

--[[
	[1] = {--DrawDailyMissionProgressAward
		[1] = 'int32':id
	}
--]]
c2s.DRAW_DAILY_MISSION_PROGRESS_AWARD = 0x2075

--[[
	[1] = {--PurchaseOrderForLongMenBreak
		[1] = 'int32':goodsId	[购买商品的id]
		[2] = 'int32':number	[购买数量]
	}
--]]
c2s.PURCHASE_ORDER_FOR_LONG_MEN_BREAK = 0x1913

--[[
	[1] = {--GemBulid
		[1] = 'int32':itemId	[id]
		[2] = 'bool':isTuhao	[是否是土豪合成]
	}
--]]
c2s.GEM_BULID = 0x1050

--[[
	[1] = {--QueryGuildBattleLastWiner
	}
--]]
c2s.QUERY_GUILD_BATTLE_LAST_WINER = 0x5707

--[[
	[1] = {--RequestPraise
		[1] = 'int32':targetId	[目标玩家ID]
	}
--]]
c2s.REQUEST_PRAISE = 0x4060

--[[
	[1] = {--RequestAllEmailRewards
	}
--]]
c2s.REQUEST_ALL_EMAIL_REWARDS = 0x1d11

--[[
	[1] = {--EscortAgencyTargetRequest
		[1] = 'int32':type	[类型 0:集火 1:取消集火]
		[2] = 'int32':targetId	[集火帮派id]
	}
--]]
c2s.ESCORT_AGENCY_TARGET_REQUEST = 0x5f04

--[[
	[1] = {--RealNameRewardRequest
	}
--]]
c2s.REAL_NAME_REWARD_REQUEST = 0x1e04

--[[
	[1] = {--ResetClimbState
	}
--]]
c2s.RESET_CLIMB_STATE = 0x1700

--[[
	[1] = {--GainCrossOtherInfo
		[1] = 'int32':playerId
		[2] = 'int32':serverId
	}
--]]
c2s.GAIN_CROSS_OTHER_INFO = 0x0e99

--[[
	[1] = {--UnlockPlayerMine
		[1] = 'int32':minePlayerId	[被劫矿的玩家]
		[2] = 'int32':id	[1,矿1,2,矿2]
	}
--]]
c2s.UNLOCK_PLAYER_MINE = 0x500a

--[[
	[1] = {--RequestCountBuyCoin
		[1] = 'int32':count	[购买次数]
	}
--]]
c2s.REQUEST_COUNT_BUY_COIN = 0x1930

--[[
	[1] = {--VisitMasterMsg
		[1] = 'bool':visitall	[ 1 表示一键拜访]
	}
--]]
c2s.VISIT_MASTER = 0x1601

--[[
	[1] = {--SerdangSeasonInfoRequest
	}
--]]
c2s.SERDANG_SEASON_INFO_REQUEST = 0x7200

--[[
	[1] = {--GemMosaic
		[1] = 'int64':equipment	[镶嵌的装备id]
		[2] = 'int32':itemId	[宝石id]
		[3] = 'int32':pos	[镶嵌的位置]
	}
--]]
c2s.GEM_MOSAIC = 0x1051

--[[
	[1] = {--QueryOpenServiceActivityRewardRecord
	}
--]]
c2s.QUERY_OPEN_SERVICE_ACTIVITY_REWARD_RECORD = 0x3302

--[[
	[1] = {--ChallengeHeroDuelRequest
		[1] = 'int32':playerId	[挑战玩家id]
		[2] = 'string':reportId	[反击录像]
	}
--]]
c2s.CHALLENGE_HERO_DUEL_REQUEST = 0x6f06

--[[
	[1] = {--challengeBloodyEnemy
		[1] = 'int32':section	[关卡号(从1开始)    //关卡号(从1开始)]
	}
--]]
c2s.CHALLENGE_BLOODY_ENEMY = 0x3210

--[[
	[1] = {--QueryGetSystemNotifyItem
		[1] = 'int32':notifyid	[消息ID]
	}
--]]
c2s.QUERY_GET_SYSTEM_NOTIFY_ITEM = 0x1d10

--[[
	[1] = {--TeamDataRequest
		[1] = 'int32':chapterId	[ 章节ID 0代表查看所有队伍]
	}
--]]
c2s.TEAM_DATA_REQUEST = 0x5920

--[[
	[1] = {--KnightFriendBattleStart
		[1] = 'int64':instanceId	[所挑战武士实例ID]
		[2] = 'int32':sharePlayerId	[ 分享者ID]
	}
--]]
c2s.KNIGHT_FRIEND_BATTLE_START = 0x7a06

--[[
	[1] = {--GuildGiveChangeRequest
		[1] = 'int32':type	[类型:7侠魂 8碎片]
		[2] = 'int32':templateId	[模版id]
		[3] = 'int32':num	[数量]
	}
--]]
c2s.GUILD_GIVE_CHANGE_REQUEST = 0x4c02

--[[
	[1] = {--GainChatInfo
		[1] = 'int32':type	[类型 1世界.2公会]
	}
--]]
c2s.GAIN_CHAT_INFO = 0x1b07

--[[
	[1] = {--TreasureHuntResult
		[1] = 'int32':count	[寻宝次数]
	}
--]]
c2s.TREASURE_HUNT_RESULT = 0x6301

--[[
	[1] = {--RequestActivityInfo
		[1] = 'int32':id	[活动ID]
	}
--]]
c2s.REQUEST_ACTIVITY_INFO = 0x2300

--[[
	[1] = {--BuyStrength
	}
--]]
c2s.BUY_STRENGTH = 0x3902

--[[
	[1] = {--GainGuildInvitation
	}
--]]
c2s.GAIN_GUILD_INVITATION = 0x4412

--[[
	[1] = {--UpdateHosting
		[1] = 'bool':hosting
	}
--]]
c2s.UPDATE_HOSTING = 0x4522

--[[
	[1] = {--FriendChallenge
		[1] = 'int32':friendId
	}
--]]
c2s.FRIEND_CHALLENGE = 0x430c

--[[
	[1] = {--RefreshRandomStore
		[1] = 'int32':type	[随机商店类型,为了兼容多种随机商店]
	}
--]]
c2s.REFRESH_RANDOM_STORE = 0x1903

--[[
	[1] = {--ComposeBookMsg
		[1] = 'int64':objID	[book实例id]
		[2] = 'repeated int64':composedBookList	[被吞噬booklist]
		[3] = 'bool':composeAll	[是否一键合成]
	}
--]]
c2s.COMPOSE_BOOK = 0x1606

--[[
	[1] = {--GetContractDailyReward
		[1] = 'int32':id	[契约模板ID]
	}
--]]
c2s.GET_CONTRACT_DAILY_REWARD = 0x2802

--[[
	[1] = {--RequestDelEmail
		[1] = 'int32':notifyid	[消息ID, 0:为删除所有,其他为删除特定邮件]
	}
--]]
c2s.REQUEST_DEL_EMAIL = 0x1d12

--[[
	[1] = {--GangGetAddMemberList
	}
--]]
c2s.GANG_GET_ADD_MEMBER_LIST = 0x1804

--[[
	[1] = {--DeleteApply
		[1] = 'int32':playerId
	}
--]]
c2s.DELETE_APPLY = 0x4404

--[[
	[1] = {--QueryLeftChallengeTimes
		[1] = 'int32':battleType	[1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点    //1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点]
	}
--]]
c2s.QUERY_LEFT_CHALLENGE_TIMES = 0x2101

--[[
	[1] = {--RequestHeartMethodSellPrice
		[1] = 'int64':instanceId	[ 出售的心法唯一id]
	}
--]]
c2s.REQUEST_HEART_METHOD_SELL_PRICE = 0x7b07

--[[
	[1] = {--SettingSaveConfig
		[1] = 'bool':isOpenMusic	[是否打开音乐 true or flase]
		[2] = 'bool':isOpenVolume	[是否打开音效 true or flase]
		[3] = 'bool':isOpenChat	[是否打开聊天 true or flase]
		[4] = 'bool':vipVisible	[是否显示VIP]
	}
--]]
c2s.SETTING_SAVE_CONFIG = 0x1e01

--[[
	[1] = {--UnlockZone
		[1] = 'int32':zoneId
	}
--]]
c2s.UNLOCK_ZONE = 0x441e

--[[
	[1] = {--ReportPlayerRequest
		[1] = 'int32':targetId	[目标玩家ID]
		[2] = 'int32':type	[操作类型]
	}
--]]
c2s.REPORT_PLAYER_REQUEST = 0x7f31

--[[
	[1] = {--RequestEquipMartial
		[1] = 'int64':roleId	[角色id]
		[2] = 'int32':martialId	[武学id]
		[3] = 'int32':position	[武学装备位置]
		[4] = 'bool':autoSynthesis	[是否自动合成,只有在没有该武学,但是又拥有足够材料的情况下才为true,可以节省用户合成所需要的操作,由客户端进行智能验证填写,如果客户端不支持智能校验则填写为false]
	}
--]]
c2s.REQUEST_EQUIP_MARTIAL = 0x3401

--[[
	[1] = {--OffWarSide
		[1] = 'int32':rankType	[副本类型]
		[2] = 'int32':templateId	[侠客ID]
	}
--]]
c2s.OFF_WAR_SIDE = 0x2d04

--[[
	[1] = {--EssentialMosaicAll
		[1] = 'int64':roleId	[角色实例id]
	}
--]]
c2s.ESSENTIAL_MOSAIC_ALL = 0x6011

--[[
	[1] = {--GangGetStaticInfo
	}
--]]
c2s.GANG_GET_STATIC_INFO = 0x1801

--[[
	[1] = {--StarHeroPraiseRequest
		[1] = 'int32':ranking	[ 排名]
		[2] = 'int32':playerId	[ 玩家ID]
	}
--]]
c2s.STAR_HERO_PRAISE_REQUEST = 0x6d01

--[[
	[1] = {--GainGuildMember
	}
--]]
c2s.GAIN_GUILD_MEMBER = 0x4407

--[[
	[1] = {--GainQualifyingInfoList
	}
--]]
c2s.GAIN_QUALIFYING_INFO_LIST = 0x4433

--[[
	[1] = {--UpdateCity
		[1] = 'int32':cityId
	}
--]]
c2s.UPDATE_CITY = 0x443d

--[[
	[1] = {--GainPrivateChatListRequster
	}
--]]
c2s.GAIN_PRIVATE_CHAT_LIST_REQUSTER = 0x1b05

--[[
	[1] = {--GuildGiveRequest
	}
--]]
c2s.GUILD_GIVE_REQUEST = 0x4c01

--[[
	[1] = {--RequestBibleBreachRequest
		[1] = 'int64':instanceId	[天书实例ID]
	}
--]]
c2s.REQUEST_BIBLE_BREACH_REQUEST = 0x6006

--[[
	[1] = {--GetReward
		[1] = 'int32':indexId	[卡槽位置id]
	}
--]]
c2s.GET_REWARD = 0x5402

--[[
	[1] = {--RequestCrossBetRadioInfo
		[1] = 'int32':roundId
		[2] = 'int32':index
		[3] = 'int32':betPlayerId
	}
--]]
c2s.REQUEST_CROSS_BET_RADIO_INFO = 0x4525

--[[
	[1] = {--ApplyRecallInviteCode
		[1] = 'string':inviteCode	[邀请码]
	}
--]]
c2s.APPLY_RECALL_INVITE_CODE = 0x5323

--[[
	[1] = {--TreasureHuntHistoryList
		[1] = 'int32':curCount	[当前数量]
		[2] = 'int32':count	[拉取数量]
		[3] = 'int32':type	[1个人历史2玩家历史]
	}
--]]
c2s.TREASURE_HUNT_HISTORY_LIST = 0x6302

--[[
	[1] = {--GoldEggResult
		[1] = 'int32':type	[1金蛋2银蛋3彩蛋]
		[2] = 'int32':count	[砸蛋次数]
	}
--]]
c2s.GOLD_EGG_RESULT = 0x4702

--[[
	[1] = {--LockedZone
		[1] = 'int32':zoneId
	}
--]]
c2s.LOCKED_ZONE = 0x441d

--[[
	[1] = {--uesInvocatoryGoods
		[1] = 'int32':roleId	[祈愿的侠客模板id]
	}
--]]
c2s.UES_INVOCATORY_GOODS = 0x5404

--[[
	[1] = {--StartPeakBattleRequest
		[1] = 'int32':playerId	[ 要复仇的玩家ID]
		[2] = 'int32':serverId	[ 要复仇的玩家的服务器ID]
		[3] = 'int32':result	[ 是否回复2次确认框 0不回复 1回复]
		[4] = 'int32':pos	[ 位置]
		[5] = 'int32':layer	[ 层数]
	}
--]]
c2s.START_PEAK_BATTLE_REQUEST = 0x7106

--[[
	[1] = {--RequestPick
	}
--]]
c2s.REQUEST_PICK = 0x5802

--[[
	[1] = {--QueryTeammateHp
		[1] = 'int32':playerId
	}
--]]
c2s.QUERY_TEAMMATE_HP = 0x592a

--[[
	[1] = {--BeforeSendGuildActiveRedPacket
		[1] = 'int32':type	[发送活跃红包类型]
	}
--]]
c2s.BEFORE_SEND_GUILD_ACTIVE_RED_PACKET = 0x4447

--[[
	[1] = {--ChallengeGuildCheckpoint
		[1] = 'int32':zoneId
		[2] = 'int32':checkpointId
		[3] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.CHALLENGE_GUILD_CHECKPOINT = 0x441f

--[[
	[1] = {--RequestSetFuncState
		[1] = {--repeated FunctionState
			[1] = 'int32':functionId	[功能ID,客户端定义,服务器只做存储,无任何逻辑需求]
			[2] = 'bool':newMark	[状态标记,true:新状态,false:无]
		},
	}
--]]
c2s.REQUEST_SET_FUNC_STATE = 0x7f21

--[[
	[1] = {--CheckJoin
	}
--]]
c2s.CHECK_JOIN = 0x4510

--[[
	[1] = {--LevelUpAgree
		[1] = 'int32':pos
	}
--]]
c2s.LEVEL_UP_AGREE = 0x4604

--[[
	[1] = {--LongMenBreakReviverRequest
		[1] = 'int32':floor	[ 层数]
		[2] = 'int32':isReviver	[ 是否复活(0:否 1:是)    // 是否复活(0:否 1:是)]
		[3] = 'int32':goodsId	[ 道具id]
	}
--]]
c2s.LONG_MEN_BREAK_REVIVER_REQUEST = 0x6905

--[[
	[1] = {--QueryCrossGuildBattleMemberInfo
	}
--]]
c2s.QUERY_CROSS_GUILD_BATTLE_MEMBER_INFO = 0x4441

--[[
	[1] = {--BuyContract
		[1] = 'int32':id	[契约合同ID]
	}
--]]
c2s.BUY_CONTRACT = 0x2801

--[[
	[1] = {--GetHeroDuelDetailsRequest
		[1] = 'int32':targetId	[玩家id]
	}
--]]
c2s.GET_HERO_DUEL_DETAILS_REQUEST = 0x6f0f

--[[
	[1] = {--EquipBattleArrayRequest
		[1] = 'int64':instanceId	[ 阵法唯一ID]
		[2] = 'int32':type	[ 阵容类型]
	}
--]]
c2s.EQUIP_BATTLE_ARRAY_REQUEST = 0x6a00

--[[
	[1] = {--GuildGiveRankRequest
	}
--]]
c2s.GUILD_GIVE_RANK_REQUEST = 0x4c04

--[[
	[1] = {--EquipmentBuild
		[1] = 'int32':forgingId	[图谱id]
	}
--]]
c2s.EQUIPMENT_BUILD = 0x1013

--[[
	[1] = {--CallMasterMsg
	}
--]]
c2s.CALL_MASTER = 0x1604

--[[
	[1] = {--GainGuildApply
	}
--]]
c2s.GAIN_GUILD_APPLY = 0x440a

--[[
	[1] = {--AnniversaryRequest
	}
--]]
c2s.ANNIVERSARY_REQUEST = 0x7e01

--[[
	[1] = {--GainCityBattleInfos
		[1] = 'int32':cityId
	}
--]]
c2s.GAIN_CITY_BATTLE_INFOS = 0x4435

--[[
	[1] = {--SingleSweepSection
		[1] = 'int32':missionId	[关卡Id]
	}
--]]
c2s.SINGLE_SWEEP_SECTION = 0x1204

--[[
	[1] = {--ContestHistoryAllLeiZhuRequest
	}
--]]
c2s.CONTEST_HISTORY_ALL_LEI_ZHU_REQUEST = 0x6e09

--[[
	[1] = {--ReceiveBoxRewardRequest
		[1] = 'int32':rewardId	[奖励id]
	}
--]]
c2s.RECEIVE_BOX_REWARD_REQUEST = 0x6f09

--[[
	[1] = {--EquipLevelUp
		[1] = 'int64':userId	[装备实例id]
		[2] = 'int32':ratioItemId	[概率加成工具(炼器宝典)    //概率加成工具(炼器宝典)]
	}
--]]
c2s.EQUIP_LEVEL_UP = 0x1054

--[[
	[1] = {--FreshEggRank
	}
--]]
c2s.FRESH_EGG_RANK = 0x4704

--[[
	[1] = {--OpenHomeEvent
		[1] = 'int32':targetPlayerId
		[2] = 'int32':eventId
	}
--]]
c2s.OPEN_HOME_EVENT = 0x7409

--[[
	[1] = {--ChatMsg
		[1] = 'int32':chatType	[ 聊天类型;1.公共,2.帮派;3.GM;4.私聊]
		[2] = 'string':content	[消息;]
		[3] = 'string':playerName	[私聊对象的name]
		[4] = 'int32':playerId	[私聊玩家编号]
		[5] = 'int32':audioTime	[语音时长]
		[6] = 'string':audioId	[语音Id]
	}
--]]
c2s.CHAT = 0x1b01

--[[
	[1] = {--ReceiveRedPacketRequest
		[1] = 'int64':id	[ 帮派红包唯一ID]
	}
--]]
c2s.RECEIVE_RED_PACKET_REQUEST = 0x6b02

--[[
	[1] = {--SerdangRankRequest
	}
--]]
c2s.SERDANG_RANK_REQUEST = 0x7206

--[[
	[1] = {--GainAccessRecords
	}
--]]
c2s.GAIN_ACCESS_RECORDS = 0x7410

--[[
	[1] = {--RequestHeartRecast
		[1] = 'int64':instanceId	[心法id]
		[2] = 'int32':pos	[重铸心法孔位]
	}
--]]
c2s.REQUEST_HEART_RECAST = 0x7b15

--[[
	[1] = {--OperatingTeamRequest
		[1] = 'int32':type	[ 0加入队伍 1退出队伍 2邀请玩家 3准备或取消准备 4拒绝 5发送到公屏邀请]
		[2] = 'int64':teamId	[ 队伍ID]
		[3] = 'int32':playerId	[ 邀请的玩家ID]
		[4] = 'int32':isAssist	[是否助战]
	}
--]]
c2s.OPERATING_TEAM_REQUEST = 0x5922

--[[
	[1] = {--RequestHeartMethodBreach
		[1] = 'int32':id	[   当前心法突破id]
		[2] = 'int64':instanceId	[心法实例ID]
	}
--]]
c2s.REQUEST_HEART_METHOD_BREACH = 0x7b05

--[[
	[1] = {--GetMyTGTime
	}
--]]
c2s.GET_MY_TGTIME = 0x1314

--[[
	[1] = {--ContestFinalsRequest
	}
--]]
c2s.CONTEST_FINALS_REQUEST = 0x6e12

--[[
	[1] = {--GetSevenDaysGoalTaskReward
		[1] = 'int32':taskid	[成就id 0代表领取全部奖励]
	}
--]]
c2s.GET_SEVEN_DAYS_GOAL_TASK_REWARD = 0x2052

--[[
	[1] = {--HeadPicFrameRequest
	}
--]]
c2s.HEAD_PIC_FRAME_REQUEST = 0x0e94

--[[
	[1] = {--PlayArenaTopBattleReport
		[1] = 'int32':reportId	[战报ID]
	}
--]]
c2s.PLAY_ARENA_TOP_BATTLE_REPORT = 0x1d41

--[[
	[1] = {--EssentialMosaicRequest
		[1] = 'int64':bible	[镶嵌的天书id]
		[2] = 'int32':essential	[精要id]
		[3] = 'int32':pos	[镶嵌的位置]
	}
--]]
c2s.ESSENTIAL_MOSAIC_REQUEST = 0x6004

--[[
	[1] = {--TestPackage
		[1] = {--TPAType(enum)
			'v4':TPAType
		},
		[2] = 'int32':goodsId
		[3] = 'int32':number
	}
--]]
c2s.TEST_PACKAGE = 0xee01

--[[
	[1] = {--ChallengeClimbWanneng
		[1] = 'int32':id	[副本索引]
		[2] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.CHALLENGE_CLIMB_WANNENG = 0x1705

--[[
	[1] = {--BibleResetRequest
		[1] = 'int64':instanceId	[id]
	}
--]]
c2s.BIBLE_RESET_REQUEST = 0x6008

--[[
	[1] = {--UpdateEmployFormation
		[1] = 'int32':type	[阵形类型,9.推图阵形]
		[2] = {--repeated MercenaryRoleInfo
			[1] = 'int64':instanceId	[角色实例ID]
			[2] = 'int32':position	[位置,0~8]
		},
		[3] = {--repeated MercenaryRoleInfo
			[1] = 'int64':instanceId	[角色实例ID]
			[2] = 'int32':position	[位置,0~8]
		},
	}
--]]
c2s.UPDATE_EMPLOY_FORMATION = 0x5130

--[[
	[1] = {--GainBossDie
		[1] = 'int32':bossId
	}
--]]
c2s.GAIN_BOSS_DIE = 0x4203

--[[
	[1] = {--ChangeIndex
		[1] = 'int32':from
		[2] = 'int32':target
	}
--]]
c2s.CHANGE_INDEX = 0x0e22

--[[
	[1] = {--shareKnight
		[1] = 'int32':knightType	[分享武士类型]
	}
--]]
c2s.SHARE_KNIGHT = 0x7a07

--[[
	[1] = {--GainChampions
	}
--]]
c2s.GAIN_CHAMPIONS = 0x4501

--[[
	[1] = {--UpdateApply
		[1] = {--repeated ApplyTeam
			[1] = 'repeated int32':members
			[2] = 'int32':flag
		},
	}
--]]
c2s.UPDATE_APPLY = 0x5708

--[[
	[1] = {--LongMenBreakRefreshRequest
	}
--]]
c2s.LONG_MEN_BREAK_REFRESH_REQUEST = 0x6904

--[[
	[1] = {--RequestAcupointLevelUp
		[1] = 'int64':instanceId
		[2] = 'int32':pos	[穴位位置]
	}
--]]
c2s.REQUEST_ACUPOINT_LEVEL_UP = 0x1502

--[[
	[1] = {--QueryRank
		[1] = 'int32':startIndex	[起始索引,1开始;0表示请求玩家所在哪一页]
		[2] = 'int32':length	[获取的数据条目数量]
	}
--]]
c2s.QUERY_RANK = 0x1404

--[[
	[1] = {--BibleNoteRequest
		[1] = 'int64':bibleId	[注解的天书id]
		[2] = 'int32':type	[注解类型 1普通注解 2开启总述]
	}
--]]
c2s.BIBLE_NOTE_REQUEST = 0x6023

--[[
	[1] = {--RefreshDigHistory
	}
--]]
c2s.REFRESH_DIG_HISTORY = 0x5938

--[[
	[1] = {--BattlePetTameGetHoleRequest
		[1] = 'int64':instanceId	[战宠Id]
	}
--]]
c2s.BATTLE_PET_TAME_GET_HOLE_REQUEST = 0x4f09

--[[
	[1] = {--QueryContract
	}
--]]
c2s.QUERY_CONTRACT = 0x2800

--[[
	[1] = {--RequestBetWinCount
		[1] = 'int32':roundId
	}
--]]
c2s.REQUEST_BET_WIN_COUNT = 0x4526

--[[
	[1] = {--BattleArrayStarUpRequest
		[1] = 'int64':instanceId	[ 阵法唯一ID]
	}
--]]
c2s.BATTLE_ARRAY_STAR_UP_REQUEST = 0x6a03

--[[
	[1] = {--ClimbSweepRequest
		[1] = 'int32':id	[层数]
		[2] = 'int32':times	[扫荡次数]
	}
--]]
c2s.CLIMB_SWEEP_REQUEST = 0x1710

--[[
	[1] = {--FirstOnlinePromptRequest
	}
--]]
c2s.FIRST_ONLINE_PROMPT_REQUEST = 0x0e34

--[[
	[1] = {--EquipmentIntensify
		[1] = 'int64':equipment	[装备userid]
	}
--]]
c2s.EQUIPMENT_INTENSIFY = 0x1014

--[[
	[1] = {--ItemUsed
		[1] = 'int32':itemId	[id]
	}
--]]
c2s.ITEM_USED = 0x1018

--[[
	[1] = {--ContestTeamSignUpRequest
		[1] = 'int32':type	[ 0为报名 1为取消报名]
	}
--]]
c2s.CONTEST_TEAM_SIGN_UP_REQUEST = 0x6e06

--[[
	[1] = {--RequestHeartMethodInfo
		[1] = 'int64':instanceId	[ 心法id]
		[2] = 'int32':itemId	[ 模板id]
		[3] = 'int32':progress	[ 进度]
	}
--]]
c2s.REQUEST_HEART_METHOD_INFO = 0x7b02

--[[
	[1] = {--BibleGemMosaic
		[1] = 'int64':bibleId	[镶嵌的天书id]
		[2] = 'int32':itemId	[宝石id]
		[3] = 'int32':pos	[镶嵌的位置]
	}
--]]
c2s.BIBLE_GEM_MOSAIC = 0x6012

--[[
	[1] = {--ResetBloodyRequest
	}
--]]
c2s.RESET_BLOODY_REQUEST = 0x3220

--[[
	[1] = {--RequestBuyMoneyShop
		[1] = 'int32':type	[通宝类型]
		[2] = 'int32':activityId	[活动Id]
	}
--]]
c2s.REQUEST_BUY_MONEY_SHOP = 0x2305

--[[
	[1] = {--GotActivityReward
		[1] = 'int32':id	[活动ID]
		[2] = 'int32':index	[奖励索引,从1开始,第几个奖励]
		[3] = 'int32':couponId	[折扣券id]
		[4] = 'string':targetItem	[目标物品]
		[5] = 'int32':count	[购买商品数量]
	}
--]]
c2s.GOT_ACTIVITY_REWARD = 0x2304

--[[
	[1] = {--MakePlayer
		[1] = 'int32':type	[类型]
		[2] = 'int32':playerId	[结交的玩家编号]
	}
--]]
c2s.MAKE_PLAYER = 0x440f

--[[
	[1] = {--RequestOneKeyEnchant
		[1] = 'int64':roleId	[角色id]
		[2] = 'int32':position	[武学装备位置]
	}
--]]
c2s.REQUEST_ONE_KEY_ENCHANT = 0x3407

--[[
	[1] = {--PotentialPracticeReplaceRequest
		[1] = 'int64':roleId	[ 角色实例id]
		[2] = 'int32':stage	[ 阶段]
	}
--]]
c2s.POTENTIAL_PRACTICE_REPLACE_REQUEST = 0x6801

--[[
	[1] = {--EscortAgencyRankHistoryRequest
	}
--]]
c2s.ESCORT_AGENCY_RANK_HISTORY_REQUEST = 0x5f10

--[[
	[1] = {--ChangeContestTeamPositionRequest
		[1] = 'int64':id	[ 队伍唯一标识]
		[2] = 'repeated int32':playerId	[ 站位信息 发长度为三的数据 该位置没有人就为0]
	}
--]]
c2s.CHANGE_CONTEST_TEAM_POSITION_REQUEST = 0x6e02

--[[
	[1] = {--BattlePetFreeRequest
		[1] = 'repeated int64':instanceId	[战宠id]
	}
--]]
c2s.BATTLE_PET_FREE_REQUEST = 0x4f05

--[[
	[1] = {--RequestGetCaveChestReward
		[1] = 'int32':index	[层数,1~N,最后一个属性可以传0]
	}
--]]
c2s.REQUEST_GET_CAVE_CHEST_REWARD = 0x4925

--[[
	[1] = {--ArenaGetRandList
		[1] = 'int32':startIndex	[起始索引,1开始;0表示请求玩家所在哪一页]
		[2] = 'int32':length	[获取的数据条目数量]
	}
--]]
c2s.ARENA_GET_RAND_LIST = 0x1301

--[[
	[1] = {--GangUpLevelBuff
	}
--]]
c2s.GANG_UP_LEVEL_BUFF = 0x1818

--[[
	[1] = {--GuildBossHelpRequest
		[1] = 'int32':playerId	[玩家id]
		[2] = 'int32':npcId	[npcid]
		[3] = 'int32':type	[操作类型(1:添加 2移除)    //操作类型(1:添加 2移除)]
	}
--]]
c2s.GUILD_BOSS_HELP_REQUEST = 0x4b04

--[[
	[1] = {--BibleComprehendReplaceRequest
		[1] = 'int64':bibleId	[ 天书 id 1]
		[2] = 'int32':stage	[ 阶段id]
	}
--]]
c2s.BIBLE_COMPREHEND_REPLACE_REQUEST = 0x6022

--[[
	[1] = {--GainApplySimpleInfo
	}
--]]
c2s.GAIN_APPLY_SIMPLE_INFO = 0x443f

--[[
	[1] = {--RushSweeping
		[1] = 'int32':zoneId
	}
--]]
c2s.RUSH_SWEEPING = 0x7607

--[[
	[1] = {--RewardRequest
		[1] = 'int32':rewardId	[奖励索引]
		[2] = 'int32':activityType	[任务类型]
		[3] = 'int32':missionType	[任务种类]
	}
--]]
c2s.REWARD_REQUEST = 0x7e02

--[[
	[1] = {--BibleKeyUnMosaicRequest
		[1] = 'int64':bibleId	[天书id]
	}
--]]
c2s.BIBLE_KEY_UN_MOSAIC_REQUEST = 0x6025

--[[
	[1] = {--GangDissolve
	}
--]]
c2s.GANG_DISSOLVE = 0x180a

--[[
	[1] = {--LongMenBreakClickRequest
		[1] = 'int32':floor	[ 层数]
		[2] = 'int32':index	[ 点击的下标]
	}
--]]
c2s.LONG_MEN_BREAK_CLICK_REQUEST = 0x6902

--[[
	[1] = {--QueryEmployTeamCount
	}
--]]
c2s.QUERY_EMPLOY_TEAM_COUNT = 0x5164

--[[
	[1] = {--StartBattleRequest
		[1] = 'int32':copyId	[ 副本ID 0为进入副本开始战斗]
	}
--]]
c2s.START_BATTLE_REQUEST = 0x5924

--[[
	[1] = {--RequestOneKeyEquipMartial
		[1] = 'int64':instanceId	[角色实例ID]
	}
--]]
c2s.REQUEST_ONE_KEY_EQUIP_MARTIAL = 0x3410

--[[
	[1] = {--QueryReplayFight
		[1] = 'int32':reportId	[战报ID]
	}
--]]
c2s.QUERY_REPLAY_FIGHT = 0x1d09

--[[
	[1] = {--RequestChangeProfession
		[1] = 'int32':roleId	[角色id]
	}
--]]
c2s.REQUEST_CHANGE_PROFESSION = 0x5500

--[[
	[1] = {--RequestBetRadioInfo
		[1] = 'int32':roundId
		[2] = 'int32':index
		[3] = 'int32':betPlayerId
	}
--]]
c2s.REQUEST_BET_RADIO_INFO = 0x4524

--[[
	[1] = {--RewardFundRequest
		[1] = 'int32':fundId	[ 领取奖励的基金ID]
	}
--]]
c2s.REWARD_FUND_REQUEST = 0x2071

--[[
	[1] = {--RequestActivityProgress
		[1] = 'int32':id	[活动ID]
	}
--]]
c2s.REQUEST_ACTIVITY_PROGRESS = 0x2302

--[[
	[1] = {--RequestHeartGemUnMosaic
		[1] = 'int64':instanceId	[卸下的天书id]
		[2] = 'int32':pos	[卸下的位置]
	}
--]]
c2s.REQUEST_HEART_GEM_UN_MOSAIC = 0x7b12

--[[
	[1] = {--AdventureChallenge
		[1] = 'int32':id	[ 副本的ID]
	}
--]]
c2s.ADVENTURE_CHALLENGE = 0x5901

--[[
	[1] = {--GainPeakGuildRanks
		[1] = 'int32':startRank
	}
--]]
c2s.GAIN_PEAK_GUILD_RANKS = 0x7112

--[[
	[1] = {--Match
	}
--]]
c2s.MATCH = 0x4502

--[[
	[1] = {--UpgradeVIPInfo
		[1] = 'string':QQ	[QQ号码]
		[2] = 'string':telphone	[手机号]
	}
--]]
c2s.UPGRADE_VIPINFO = 0x1a20

--[[
	[1] = {--ChallengeByEmploy
		[1] = {--UpdateEmployFormation
			[1] = 'int32':type	[阵形类型,9.推图阵形]
			[2] = {--repeated MercenaryRoleInfo
				[1] = 'int64':instanceId	[角色实例ID]
				[2] = 'int32':position	[位置,0~8]
			},
			[3] = {--repeated MercenaryRoleInfo
				[1] = 'int64':instanceId	[角色实例ID]
				[2] = 'int32':position	[位置,0~8]
			},
		},
		[2] = 'int32':battleType	[战斗类型]
		[3] = 'string':params	[额外参数,每种战斗挑战时的附加参数不一致]
	}
--]]
c2s.CHALLENGE_BY_EMPLOY = 0x5131

--[[
	[1] = {--EquipmentSell
		[1] = 'repeated int64':equipment	[装备userid]
	}
--]]
c2s.EQUIPMENT_SELL = 0x1015

--[[
	[1] = {--GainFriendList
	}
--]]
c2s.GAIN_FRIEND_LIST = 0x4300

--[[
	[1] = {--DatiInfoRequest
	}
--]]
c2s.DATI_INFO_REQUEST = 0x3b04

--[[
	[1] = {--MerceanryTeamOperation
		[1] = 'int32':operation	[操作符,1.领取;2.归队]
	}
--]]
c2s.MERCEANRY_TEAM_OPERATION = 0x5153

--[[
	[1] = {--GangSendBulletin
		[1] = 'string':bulletin
	}
--]]
c2s.GANG_SEND_BULLETIN = 0x1810

--[[
	[1] = {--GangAppointSecondMaster
		[1] = 'int32':playerId
	}
--]]
c2s.GANG_APPOINT_SECOND_MASTER = 0x1806

--[[
	[1] = {--SendBigcompetRequest
	}
--]]
c2s.SEND_BIGCOMPET_REQUEST = 0x3306

--[[
	[1] = {--GangApplyAdd
		[1] = 'int32':gangId
	}
--]]
c2s.GANG_APPLY_ADD = 0x180b

--[[
	[1] = {--RefreshWorldBeast
	}
--]]
c2s.REFRESH_WORLD_BEAST = 0x6110

--[[
	[1] = {--RequestClearYabiaoCD
	}
--]]
c2s.REQUEST_CLEAR_YABIAO_CD = 0x3004

--[[
	[1] = {--GuildDanFangReciverRequest
	}
--]]
c2s.GUILD_DAN_FANG_RECIVER_REQUEST = 0x5e04

--[[
	[1] = {--RequestWinCount
	}
--]]
c2s.REQUEST_WIN_COUNT = 0x6e19

--[[
	[1] = {--RefreshYabiao
	}
--]]
c2s.REFRESH_YABIAO = 0x3001

--[[
	[1] = {--GangGetRankList
	}
--]]
c2s.GANG_GET_RANK_LIST = 0x1800

--[[
	[1] = {--Yabiao
	}
--]]
c2s.YABIAO = 0x3002

--[[
	[1] = {--OperateInvitation
		[1] = 'int32':type	[ 1同意申请 2忽略]
		[2] = 'int32':guildId	[0为全部忽略]
	}
--]]
c2s.OPERATE_INVITATION = 0x4414

--[[
	[1] = {--XiaKeHereditary
		[1] = 'int64':roleId	[ 角色实例id]
		[2] = 'int64':hereditaryId	[ 接受传承的角色实例id]
	}
--]]
c2s.XIA_KE_HEREDITARY = 0x6501

--[[
	[1] = {--FightRerort
		[1] = 'int32':packetIndex
		[2] = {--repeated FightAction
			[1] = 'bool':bManualAction	[是否主动技能]
			[2] = 'int32':roundIndex	[当前回合]
			[3] = 'int32':attackerpos	[攻击者位置]
			[4] = 'int32':skillid	[技能id]
			[5] = 'int32':skillLevel	[技能id]
			[6] = 'bool':bBackAttack	[是否反击]
			[7] = {--repeated TargetInfo
				[1] = 'int32':targetpos	[受击者位置]
				[2] = 'int32':effect	[受击效果]
				[3] = 'int64':hurt	[受击伤害]
				[4] = 'int32':triggerBufferID	[触发bufferID]
				[5] = 'int32':triggerBufferLevel	[触发bufferID]
				[6] = 'int32':passiveEffect	[被动效果类型]
				[7] = 'int32':passiveEffectValue	[被动效果值]
				[8] = 'int32':activeEffect	[主动效果类型]
				[9] = 'int32':activeEffectValue	[主动效果值]
			},
			[8] = {--repeated StateInfo
				[1] = 'int32':frompos	[状态产生自谁行为发起者还是目标]
				[2] = 'int32':targetpos	[获得状态的目标]
				[3] = 'int32':stateId	[触发的状态ID,触发了哪个状态.始终是frompos对应角色身上的状态列表中的状态]
				[4] = 'int32':skillId	[状态时由哪个技能触发的.始终是frompos对应角色身上的技能]
				[5] = 'int32':skillLevel	[技能id]
				[6] = 'int32':bufferId	[targetpos的角色获得的状态ID]
				[7] = 'int32':bufferLevel	[技能id]
			},
			[9] = 'int32':triggerType	[触发技能类型87]
		},
	}
--]]
c2s.FIGHT_RERORT = 0x0f25

--[[
	[1] = {--BibleComprehendInfoRequest
		[1] = 'int64':bibleId	[ 天书 id 1]
	}
--]]
c2s.BIBLE_COMPREHEND_INFO_REQUEST = 0x6020

--[[
	[1] = {--RondomBloodyBox
		[1] = 'int32':section	[关卡号(从1开始)    //关卡号(从1开始)]
	}
--]]
c2s.RONDOM_BLOODY_BOX = 0x3212

--[[
	[1] = {--HomeTurntableRequest
	}
--]]
c2s.HOME_TURNTABLE_REQUEST = 0x7402

--[[
	[1] = {--BattleArrayDeduce
		[1] = 'int64':instanceId
		[2] = 'repeated int32':goodsId
		[3] = 'repeated int32':num
		[4] = 'int32':pos
	}
--]]
c2s.BATTLE_ARRAY_DEDUCE = 0x6a08

--[[
	[1] = {--RequestHeartConcise
		[1] = 'int64':instanceId	[凝练的天书id]
		[2] = 'int32':pos	[凝练的位置]
	}
--]]
c2s.REQUEST_HEART_CONCISE = 0x7b13

--[[
	[1] = {--ClearChallengeCD
	}
--]]
c2s.CLEAR_CHALLENGE_CD = 0x7806

--[[
	[1] = {--EscortAgencyUpdateQualityRequest
		[1] = 'int32':qualityId	[品质id]
	}
--]]
c2s.ESCORT_AGENCY_UPDATE_QUALITY_REQUEST = 0x5f07

--[[
	[1] = {--ChallengeWulinEnemies
	}
--]]
c2s.CHALLENGE_WULIN_ENEMIES = 0x7802

--[[
	[1] = {--Encouraging
	}
--]]
c2s.ENCOURAGING = 0x4504

--[[
	[1] = {--SendReplay
		[1] = 'int32':replayId	[录像ID]
	}
--]]
c2s.SEND_REPLAY = 0x2d10

--[[
	[1] = {--PeakRevengeRequest
		[1] = 'int32':playerId	[ 要复仇的玩家ID]
		[2] = 'int32':pos	[ 位置]
		[3] = 'int32':layer	[ 层数]
	}
--]]
c2s.PEAK_REVENGE_REQUEST = 0x7105

--[[
	[1] = {--RebateTurntableRequest
	}
--]]
c2s.REBATE_TURNTABLE_REQUEST = 0x7d03

--[[
	[1] = {--GuildBossDamageRankRequest
	}
--]]
c2s.GUILD_BOSS_DAMAGE_RANK_REQUEST = 0x4b09

--[[
	[1] = {--GainCrossWorldBossRank
		[1] = 'int32':bossId
	}
--]]
c2s.GAIN_CROSS_WORLD_BOSS_RANK = 0x4205

--[[
	[1] = {--GainWorldBossRank
		[1] = 'int32':bossId
	}
--]]
c2s.GAIN_WORLD_BOSS_RANK = 0x4204

--[[
	[1] = {--WoodManExtraReward
		[1] = 'int32':id	[宝箱档次id]
	}
--]]
c2s.WOOD_MAN_EXTRA_REWARD = 0x6310

--[[
	[1] = {--WoodManOwnProgressMsg
	}
--]]
c2s.WOOD_MAN_OWN_PROGRESS = 0x6307

--[[
	[1] = {--ResetZone
		[1] = 'int32':zoneId
	}
--]]
c2s.RESET_ZONE = 0x441c

--[[
	[1] = {--QueryEmployRoleList
	}
--]]
c2s.QUERY_EMPLOY_ROLE_LIST = 0x5111

--[[
	[1] = {--LockBookMsg
		[1] = 'int64':objID	[实例id]
	}
--]]
c2s.LOCK_BOOK = 0x1605

--[[
	[1] = {--FreshWoodManRank
	}
--]]
c2s.FRESH_WOOD_MAN_RANK = 0x6311

--[[
	[1] = {--NetChatProps
		[1] = 'int32':type
	}
--]]
c2s.NET_CHAT_PROPS = 0x1b08

--[[
	[1] = {--PurchaseOrderForMysteryStore
		[1] = 'int32':commodityId	[购买商品的id]
	}
--]]
c2s.PURCHASE_ORDER_FOR_MYSTERY_STORE = 0x1911

--[[
	[1] = {--WoodManHistoryRequest
		[1] = 'int32':curCount	[当前数量]
		[2] = 'int32':count	[拉取数量]
		[3] = 'int32':type	[1个人历史2玩家历史]
	}
--]]
c2s.WOOD_MAN_HISTORY_REQUEST = 0x6309

--[[
	[1] = {--CancelApply
		[1] = 'int32':guildId	[公会编号]
	}
--]]
c2s.CANCEL_APPLY = 0x440b

--[[
	[1] = {--GainLongMenTypeInfoRequest
	}
--]]
c2s.GAIN_LONG_MEN_TYPE_INFO_REQUEST = 0x6910

--[[
	[1] = {--QueryQuestMsg
	}
--]]
c2s.QUERY_QUEST = 0x1400

--[[
	[1] = {--QueryGoFight
		[1] = 'int32':gotype	[ 1 血闯, 2 勇闯, 3 力闯]
		[2] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.QUERY_GO_FIGHT = 0x1403

--[[
	[1] = {--RequestRecall
		[1] = 'int32':playerId	[被召回的目标玩家ID]
	}
--]]
c2s.REQUEST_RECALL = 0x5320

--[[
	[1] = {--RequestUnequipHeartMehod
		[1] = 'int64':roleId	[ 角色Id]
		[2] = 'int64':heartMid	[ 心法唯一id]
	}
--]]
c2s.REQUEST_UNEQUIP_HEART_MEHOD = 0x7b04

--[[
	[1] = {--AbandonPeakRequest
	}
--]]
c2s.ABANDON_PEAK_REQUEST = 0x7102

--[[
	[1] = {--WoodManRequest
		[1] = 'int32':count	[木人桩档次 1/10/30]
	}
--]]
c2s.WOOD_MAN_REQUEST = 0x6308

--[[
	[1] = {--ViewWulinEnemiesReplay
		[1] = 'int32':replayId
	}
--]]
c2s.VIEW_WULIN_ENEMIES_REPLAY = 0x7805

--[[
	[1] = {--DrawAssistantAward
		[1] = 'int32':friendId
	}
--]]
c2s.DRAW_ASSISTANT_AWARD = 0x4313

--[[
	[1] = {--SendGuildInvitation
		[1] = 'int32':playerId
	}
--]]
c2s.SEND_GUILD_INVITATION = 0x4413

--[[
	[1] = {--ChallengeCopy
		[1] = 'int32':rankType	[副本类型]
	}
--]]
c2s.CHALLENGE_COPY = 0x2d07

--[[
	[1] = {--TianJiLunInfoRequest
	}
--]]
c2s.TIAN_JI_LUN_INFO_REQUEST = 0x7500

--[[
	[1] = {--GetHeroDuelReportRequest
		[1] = 'int32':reportGroup	[战报分组]
	}
--]]
c2s.GET_HERO_DUEL_REPORT_REQUEST = 0x6f07

--[[
	[1] = {--RequestChallengeCopy
	}
--]]
c2s.REQUEST_CHALLENGE_COPY = 0x2d12

--[[
	[1] = {--DrawBeastMoney
		[1] = 'int32':index	[元宝下标]
	}
--]]
c2s.DRAW_BEAST_MONEY = 0x6103

--[[
	[1] = {--ContestTeamRemoveMemberRequest
		[1] = 'int64':id	[ 队伍唯一标识]
		[2] = 'int32':playerId	[ 当playerId等于操作者 为退出队伍 然则为踢出某玩家]
	}
--]]
c2s.CONTEST_TEAM_REMOVE_MEMBER_REQUEST = 0x6e03

--[[
	[1] = {--RebateConvertRewardRequest
		[1] = 'int32':convertId	[兑换id]
	}
--]]
c2s.REBATE_CONVERT_REWARD_REQUEST = 0x6f0d

--[[
	[1] = {--SendRankingList
		[1] = 'int32':rankType	[副本类型]
		[2] = 'int32':startIndex	[开始索引,0~N]
		[3] = 'int32':length	[获取信息长度]
	}
--]]
c2s.SEND_RANKING_LIST = 0x2d09

--[[
	[1] = {--GetHeroDuelVideoRequest
		[1] = 'string':reportId	[录像id]
	}
--]]
c2s.GET_HERO_DUEL_VIDEO_REQUEST = 0x6f10

--[[
	[1] = {--RefreshHeroPool
		[1] = 'int32':rankType	[副本类型]
	}
--]]
c2s.REFRESH_HERO_POOL = 0x2d05

--[[
	[1] = {--GetRandomStore
		[1] = 'int32':type	[随机商店类型,为了兼容多种随机商店]
	}
--]]
c2s.GET_RANDOM_STORE = 0x1902

--[[
	[1] = {--QueryMine
	}
--]]
c2s.QUERY_MINE = 0x5000

--[[
	[1] = {--BuyInVipShop
		[1] = 'int32':goodId	[商品ID]
		[2] = 'int32':number	[购买数量]
	}
--]]
c2s.BUY_IN_VIP_SHOP = 0x4a02

--[[
	[1] = {--BuyCount
		[1] = 'int32':type	[1为挑战次数  2为刷新次数]
		[2] = 'int32':rankType	[副本类型]
	}
--]]
c2s.BUY_COUNT = 0x2d08

--[[
	[1] = {--PurchaseOrderForFixedStore
		[1] = 'int32':commodityId	[购买商品的id]
		[2] = 'int32':num	[购买商品的个数]
	}
--]]
c2s.PURCHASE_ORDER_FOR_FIXED_STORE = 0x1900

--[[
	[1] = {--EmployRoleOperation
		[1] = 'int64':roleId	[角色实例id]
		[2] = 'int32':operation	[操作符,1表示增加,2表示移除,3表示领取]
		[3] = 'int32':indexId	[位置id]
	}
--]]
c2s.EMPLOY_ROLE_OPERATION = 0x5101

--[[
	[1] = {--OpenWindCloudRecord
	}
--]]
c2s.OPEN_WIND_CLOUD_RECORD = 0x2d00

--[[
	[1] = {--BattleArrayIntensifyRequest
		[1] = 'int64':instanceId	[ 阵法唯一ID]
		[2] = {--repeated IntensifyConsumeItem
			[1] = 'int32':id	[ 道具的id]
			[2] = 'int32':num	[ 道具的数量]
		},
	}
--]]
c2s.BATTLE_ARRAY_INTENSIFY_REQUEST = 0x6a02

--[[
	[1] = {--BuyRedPacketRequest
		[1] = 'int32':id	[ 模板ID]
	}
--]]
c2s.BUY_RED_PACKET_REQUEST = 0x6b00

--[[
	[1] = {--SendRankAwardRequest
	}
--]]
c2s.SEND_RANK_AWARD_REQUEST = 0x3307

--[[
	[1] = {--AutoWarMatix
	}
--]]
c2s.AUTO_WAR_MATIX = 0x0e24

--[[
	[1] = {--DrawGiveGifi
		[1] = 'int32':friendId
	}
--]]
c2s.DRAW_GIVE_GIFI = 0x4306

--[[
	[1] = {--HostingRequest
		[1] = 'int32':type	[ 0托管 1取消托管]
	}
--]]
c2s.HOSTING_REQUEST = 0x5925

--[[
	[1] = {--OpenZone
		[1] = 'int32':zoneId
	}
--]]
c2s.OPEN_ZONE = 0x441b

--[[
	[1] = {--GangCreate
		[1] = 'string':gangName
	}
--]]
c2s.GANG_CREATE = 0x180c

--[[
	[1] = {--OutBattle
		[1] = 'int64':userId
	}
--]]
c2s.OUT_BATTLE = 0x0e23

--[[
	[1] = {--RefreshVipShop
	}
--]]
c2s.REFRESH_VIP_SHOP = 0x4a03

--[[
	[1] = {--GangRefleshExchangeList
	}
--]]
c2s.GANG_REFLESH_EXCHANGE_LIST = 0x1812

--[[
	[1] = {--GetInvocatoryReward
		[1] = 'int32':roleId	[祈愿的侠客模板id]
	}
--]]
c2s.GET_INVOCATORY_REWARD = 0x5401

--[[
	[1] = {--RequestVipShop
	}
--]]
c2s.REQUEST_VIP_SHOP = 0x4a01

--[[
	[1] = {--GuardMinePlayer
	}
--]]
c2s.GUARD_MINE_PLAYER = 0x5010

--[[
	[1] = {--GetOtherRoleDetails
		[1] = 'int32':playerId	[玩家ID]
		[2] = 'int64':instanceId	[角色实例ID]
	}
--]]
c2s.GET_OTHER_ROLE_DETAILS = 0x0e73

--[[
	[1] = {--UpEquipDestiny
		[1] = 'int64':instanceId	[天命实例id]
		[2] = 'int32':pos	[位置]
		[3] = 'int64':roldId	[镶嵌角色id]
	}
--]]
c2s.UP_EQUIP_DESTINY = 0x3f03

--[[
	[1] = {--GainSimpleInfo
		[1] = 'int32':playerId
	}
--]]
c2s.GAIN_SIMPLE_INFO = 0x0e98

--[[
	[1] = {--StartSecondBattle
	}
--]]
c2s.START_SECOND_BATTLE = 0x5915

--[[
	[1] = {--GetHeroDuelMyReportRequest
	}
--]]
c2s.GET_HERO_DUEL_MY_REPORT_REQUEST = 0x6f08

--[[
	[1] = {--QueryAllBloodyEnemySimpleInfoList
	}
--]]
c2s.QUERY_ALL_BLOODY_ENEMY_SIMPLE_INFO_LIST = 0x3207

--[[
	[1] = {--GetPlayerBaseInfo
		[1] = 'int32':playerId	[玩家id]
	}
--]]
c2s.GET_PLAYER_BASE_INFO = 0x0e70

--[[
	[1] = {--QimenInjectBreach
	}
--]]
c2s.QIMEN_INJECT_BREACH = 0x5203

--[[
	[1] = {--GetNorthCaveDetails
	}
--]]
c2s.GET_NORTH_CAVE_DETAILS = 0x4902

--[[
	[1] = {--StarHeroPraiseRewardRequest
	}
--]]
c2s.STAR_HERO_PRAISE_REWARD_REQUEST = 0x6d02

--[[
	[1] = {--OpenWorldBeast
	}
--]]
c2s.OPEN_WORLD_BEAST = 0x6107

--[[
	[1] = {--AdventureMassacreRanking
	}
--]]
c2s.ADVENTURE_MASSACRE_RANKING = 0x5908

--[[
	[1] = {--GetBookMsg
		[1] = 'int32':bookpos	[ pos为0拾取所有]
	}
--]]
c2s.GET_BOOK = 0x1602

--[[
	[1] = {--RequestMyEmployInfo
	}
--]]
c2s.REQUEST_MY_EMPLOY_INFO = 0x5100

--[[
	[1] = {--GainPlayerLadderMessage
	}
--]]
c2s.GAIN_PLAYER_LADDER_MESSAGE = 0x7901

--[[
	[1] = {--UpdatePlayerName
		[1] = 'string':Name	[新的名称]
	}
--]]
c2s.UPDATE_PLAYER_NAME = 0x0e11

--[[
	[1] = {--GainCrossPlayerDefRequest
		[1] = 'int32':playerId
		[2] = 'int32':serverId
	}
--]]
c2s.GAIN_CROSS_PLAYER_DEF_REQUEST = 0x0e9d

--[[
	[1] = {--QueryScoreRankInfos
	}
--]]
c2s.QUERY_SCORE_RANK_INFOS = 0x4516

--[[
	[1] = {--GuildBossRankRequest
		[1] = 'int32':type	[类型(1:阶段榜 2:首次击破阶段榜)    //类型(1:阶段榜 2:首次击破阶段榜)]
	}
--]]
c2s.GUILD_BOSS_RANK_REQUEST = 0x4b06

--[[
	[1] = {--UpdateBeginnersGuideSetpRequest
		[1] = 'int32':beginnersGuide	[新手进度]
		[2] = 'string':openlist	[已开放玩法列表]
	}
--]]
c2s.UPDATE_BEGINNERS_GUIDE_SETP_REQUEST = 0x0e80

--[[
	[1] = {--DeleteFriend
		[1] = 'int32':friendId
	}
--]]
c2s.DELETE_FRIEND = 0x4307

--[[
	[1] = {--GainGuildDynamic
	}
--]]
c2s.GAIN_GUILD_DYNAMIC = 0x4419

--[[
	[1] = {--GetInfoTG
		[1] = 'int32':type	[天罡星等级类型.0:初级;1:中级;2:高级]
		[2] = 'int32':begin	[座位索引,第几位.0~n]
		[3] = 'int32':end	[座位索引,第几位.0~n]
	}
--]]
c2s.GET_INFO_TG = 0x1311

--[[
	[1] = {--ChangeIconRequest
		[1] = 'int32':iconId	[更换的头像ID]
	}
--]]
c2s.CHANGE_ICON_REQUEST = 0x0e91

--[[
	[1] = {--LangBlessedSeletRequest
		[1] = {--repeated LangBlessedItem
			[1] = 'int32':id	[id]
			[2] = 'int32':index	[坐标]
			[3] = 'int32':kind	[类型 1精品 2珍品]
		},
	}
--]]
c2s.LANG_BLESSED_SELET_REQUEST = 0x4d02

--[[
	[1] = {--QueryEmployRoleCount
	}
--]]
c2s.QUERY_EMPLOY_ROLE_COUNT = 0x5110

--[[
	[1] = {--GainCrossPlayerByAssistantType
		[1] = 'int32':playerId
		[2] = 'int32':serverId
		[3] = 'int32':formationType
	}
--]]
c2s.GAIN_CROSS_PLAYER_BY_ASSISTANT_TYPE = 0x0e9f

--[[
	[1] = {--WatchServerBattleReplay
		[1] = 'int32':replayId
	}
--]]
c2s.WATCH_SERVER_BATTLE_REPLAY = 0x0f23

--[[
	[1] = {--EscortAgencyDeployRequest
		[1] = 'int32':playerId	[玩家id]
		[2] = 'int32':type	[飙车部位类型1:护甲 2:镖旗3:轮子 4:车厢]
		[3] = 'int32':index	[位置下标(0开始)    //位置下标(0开始)]
	}
--]]
c2s.ESCORT_AGENCY_DEPLOY_REQUEST = 0x5f03

--[[
	[1] = {--SevenDaysPrompt
		[1] = 'int32':days
	}
--]]
c2s.SEVEN_DAYS_PROMPT = 0x2057

--[[
	[1] = {--GetHeroDuelGuildRankRequest
	}
--]]
c2s.GET_HERO_DUEL_GUILD_RANK_REQUEST = 0x6f05

--[[
	[1] = {--QueryTupuList
	}
--]]
c2s.QUERY_TUPU_LIST = 0x3100

--[[
	[1] = {--GetMiningPointListAroundMine
		[1] = 'int32':type	[宝藏类型.1:连城宝藏;2:闯王宝藏;3:大清龙脉]
		[2] = 'int32':begin	[起始索引,宝藏挖掘点索引,第几个位置.1--n    //起始索引,宝藏挖掘点索引,第几个位置.1--n]
		[3] = 'int32':end	[结束索引,宝藏挖掘点索引,第几个位置.1--n    //结束索引,宝藏挖掘点索引,第几个位置.1--n]
	}
--]]
c2s.GET_MINING_POINT_LIST_AROUND_MINE = 0x2202

--[[
	[1] = {--QueryInvocatory
	}
--]]
c2s.QUERY_INVOCATORY = 0x5400

--[[
	[1] = {--StarHeroRankingRequest
		[1] = 'int32':id	[ 序号 1代表1-10 2代表11-20 以此类推    // 序号 1代表1-10 2代表11-20 以此类推]
	}
--]]
c2s.STAR_HERO_RANKING_REQUEST = 0x6d00

--[[
	[1] = {--DatiRankInfoRequest
	}
--]]
c2s.DATI_RANK_INFO_REQUEST = 0x3b00

--[[
	[1] = {--OpenTreasureBox
		[1] = 'int32':index	[开启的宝箱索引,1----n]
	}
--]]
c2s.OPEN_TREASURE_BOX = 0x2205

--[[
	[1] = {--UpdateHeroPuWatchs
		[1] = 'string':val
	}
--]]
c2s.UPDATE_HERO_PU_WATCHS = 0x3102

--[[
	[1] = {--QuerySevenDaysGoalTask
	}
--]]
c2s.QUERY_SEVEN_DAYS_GOAL_TASK = 0x2051

--[[
	[1] = {--RegistData
		[1] = 'string':name	[昵称]
		[2] = {--Sex(enum)
			'v4':Sex
		},
		[3] = 'int32':profession	[选中的卡牌类型(相当于职业)    //选中的卡牌类型(相当于职业)]
		[4] = 'int32':invitationCode	[ 邀请码]
		[5] = 'string':equipmentCode	[ 设备码]
	}
--]]
c2s.REGIST_DATA = 0x0d01

--[[
	[1] = {--ChooseExtraAwayTreasureBox
	}
--]]
c2s.CHOOSE_EXTRA_AWAY_TREASURE_BOX = 0x2206

--[[
	[1] = {--RequestAcupointBreachRate
	}
--]]
c2s.REQUEST_ACUPOINT_BREACH_RATE = 0x150b

--[[
	[1] = {--QueryMyTreasureInfo
	}
--]]
c2s.QUERY_MY_TREASURE_INFO = 0x2203

--[[
	[1] = {--OpenHeroAmbition
	}
--]]
c2s.OPEN_HERO_AMBITION = 0x3900

--[[
	[1] = {--TreasureHuntConfig
	}
--]]
c2s.TREASURE_HUNT_CONFIG = 0x6300

--[[
	[1] = {--RequestAllEmployInfo
	}
--]]
c2s.REQUEST_ALL_EMPLOY_INFO = 0x5104

--[[
	[1] = {--TreasureHuntExtraReward
		[1] = 'int32':id	[宝箱档次id]
	}
--]]
c2s.TREASURE_HUNT_EXTRA_REWARD = 0x6303

--[[
	[1] = {--Study
		[1] = 'int32':attributeType
	}
--]]
c2s.STUDY = 0x4423

--[[
	[1] = {--RequestBetInfo
		[1] = 'int32':type	[ 0押注上一届擂主 1押注这一届挑战者]
	}
--]]
c2s.REQUEST_BET_INFO = 0x6e18

--[[
	[1] = {--RequestChoiceCaveAttribute
		[1] = 'int32':targetId	[选中的属性ID]
		[2] = 'int32':index	[层数,1~N,最后一个属性可以传0]
	}
--]]
c2s.REQUEST_CHOICE_CAVE_ATTRIBUTE = 0x4920

--[[
	[1] = {--DriveBeast
		[1] = 'int64':id	[年兽实例id]
	}
--]]
c2s.DRIVE_BEAST = 0x6102

--[[
	[1] = {--GainChampionsWarInfo
	}
--]]
c2s.GAIN_CHAMPIONS_WAR_INFO = 0x4511

--[[
	[1] = {--TianJiLunBonusPoolRequest
	}
--]]
c2s.TIAN_JI_LUN_BONUS_POOL_REQUEST = 0x7504

--[[
	[1] = {--GoIntoBattle
		[1] = 'int32':rankType	[副本类型]
		[2] = 'int32':templateId	[侠客ID]
		[3] = 'int32':targetIndex	[需要放到目标阵位]
	}
--]]
c2s.GO_INTO_BATTLE = 0x2d02

--[[
	[1] = {--UpdateEliteGuildBattle
		[1] = 'int32':index
		[2] = 'int32':playerId
	}
--]]
c2s.UPDATE_ELITE_GUILD_BATTLE = 0x5702

--[[
	[1] = {--TianJiLunRankRequest
	}
--]]
c2s.TIAN_JI_LUN_RANK_REQUEST = 0x7503

--[[
	[1] = {--QueryRewardRequest
		[1] = 'int32':type	[0:未知或者普通情况下显示提示的类型;1.豪杰榜;2铜人阵;3.天罡星等----]
	}
--]]
c2s.QUERY_REWARD_REQUEST = 0x7f01

--[[
	[1] = {--StartRush
		[1] = 'int32':zoneId
	}
--]]
c2s.START_RUSH = 0x7603

--[[
	[1] = {--GetTGEnemyDetails
		[1] = 'int32':playerId	[玩家id]
	}
--]]
c2s.GET_TGENEMY_DETAILS = 0x1315

--[[
	[1] = {--VerifyInviteCode
		[1] = 'string':inviteCode	[需要验证的邀请码]
	}
--]]
c2s.VERIFY_INVITE_CODE = 0x2601

--[[
	[1] = {--GetMyTGRank
	}
--]]
c2s.GET_MY_TGRANK = 0x1312

--[[
	[1] = {--ChallengeTG
		[1] = 'int32':type	[天罡星等级类型.0:初级;1:中级;2:高级]
		[2] = 'int32':seatIndex	[座位索引,第几位.0~n]
		[3] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.CHALLENGE_TG = 0x1310

--[[
	[1] = {--RedPacketRankingRequest
		[1] = 'int32':startRanking	[ 其实排名]
	}
--]]
c2s.RED_PACKET_RANKING_REQUEST = 0x6b03

--[[
	[1] = {--TestGetPartner
		[1] = 'int32':templateId
	}
--]]
c2s.TEST_GET_PARTNER = 0xee02

--[[
	[1] = {--GainFriendAssistantInfoList
	}
--]]
c2s.GAIN_FRIEND_ASSISTANT_INFO_LIST = 0x4312

--[[
	[1] = {--QueryBeRecalledInviteList
	}
--]]
c2s.QUERY_BE_RECALLED_INVITE_LIST = 0x5321

--[[
	[1] = {--EscortAgencyOneInfoRequest
		[1] = 'int32':guildId	[工会id]
		[2] = 'int32':type	[类型]
	}
--]]
c2s.ESCORT_AGENCY_ONE_INFO_REQUEST = 0x5f08

--[[
	[1] = {--QueryQualificationInfos
	}
--]]
c2s.QUERY_QUALIFICATION_INFOS = 0x4514

--[[
	[1] = {--RequestHeartMethodSell
		[1] = 'repeated int64':instanceId	[ 心法唯一id]
	}
--]]
c2s.REQUEST_HEART_METHOD_SELL = 0x7b08

--[[
	[1] = {--GetRecallTaskReward
		[1] = 'int32':taskid	[成就id 0代表领取全部奖励]
	}
--]]
c2s.GET_RECALL_TASK_REWARD = 0x5301

--[[
	[1] = {--WoodManRewardConfigMsg
	}
--]]
c2s.WOOD_MAN_REWARD_CONFIG = 0x6306

--[[
	[1] = {--PurchaseOrderForRandomStore
		[1] = 'int32':type	[商店类型]
		[2] = 'int32':commodityId	[购买商品的id]
		[3] = 'int32':num	[购买商品的个数]
	}
--]]
c2s.PURCHASE_ORDER_FOR_RANDOM_STORE = 0x1905

--[[
	[1] = {--LongMenBreakStartRequest
	}
--]]
c2s.LONG_MEN_BREAK_START_REQUEST = 0x6901

--[[
	[1] = {--UpdateAssistantRole
		[1] = 'int32':type	[类型]
		[2] = 'repeated int64':roles	[阵容上的人]
	}
--]]
c2s.UPDATE_ASSISTANT_ROLE = 0x4603

--[[
	[1] = {--RoleBreakthrough
		[1] = 'int64':userid	[角色实例id]
	}
--]]
c2s.ROLE_BREAKTHROUGH = 0x1505

--[[
	[1] = {--FightEndRequest
		[1] = 'int32':fighttype	[战斗类型.1:推图;2:铜人阵;3:豪杰榜;4:天罡星;5:无量山;6:大宝藏;7:护驾]
		[2] = 'bool':win	[战斗是否在客户端判断为胜利]
		[3] = {--repeated FightAction
			[1] = 'bool':bManualAction	[是否主动技能]
			[2] = 'int32':roundIndex	[当前回合]
			[3] = 'int32':attackerpos	[攻击者位置]
			[4] = 'int32':skillid	[技能id]
			[5] = 'int32':skillLevel	[技能id]
			[6] = 'bool':bBackAttack	[是否反击]
			[7] = {--repeated TargetInfo
				[1] = 'int32':targetpos	[受击者位置]
				[2] = 'int32':effect	[受击效果]
				[3] = 'int64':hurt	[受击伤害]
				[4] = 'int32':triggerBufferID	[触发bufferID]
				[5] = 'int32':triggerBufferLevel	[触发bufferID]
				[6] = 'int32':passiveEffect	[被动效果类型]
				[7] = 'int32':passiveEffectValue	[被动效果值]
				[8] = 'int32':activeEffect	[主动效果类型]
				[9] = 'int32':activeEffectValue	[主动效果值]
			},
			[8] = {--repeated StateInfo
				[1] = 'int32':frompos	[状态产生自谁行为发起者还是目标]
				[2] = 'int32':targetpos	[获得状态的目标]
				[3] = 'int32':stateId	[触发的状态ID,触发了哪个状态.始终是frompos对应角色身上的状态列表中的状态]
				[4] = 'int32':skillId	[状态时由哪个技能触发的.始终是frompos对应角色身上的技能]
				[5] = 'int32':skillLevel	[技能id]
				[6] = 'int32':bufferId	[targetpos的角色获得的状态ID]
				[7] = 'int32':bufferLevel	[技能id]
			},
			[9] = 'int32':triggerType	[触发技能类型87]
		},
		[4] = {--repeated LiveRole
			[1] = 'int32':posindex	[位置]
			[2] = 'int32':currhp	[剩余血量]
			[3] = 'int32':anger
		},
		[5] = 'int32':angerSelf	[己方怒气]
		[6] = 'int32':angerEnemy	[对方怒气]
		[7] = {--repeated RoleHurtCount
			[1] = 'int32':posindex	[位置]
			[2] = 'int32':hurt	[伤害计算]
		},
	}
--]]
c2s.FIGHT_END_REQUEST = 0x0f02

--[[
	[1] = {--GetRebateConvertInfoRequest
	}
--]]
c2s.GET_REBATE_CONVERT_INFO_REQUEST = 0x6f0c

--[[
	[1] = {--RequestAcupointBreach
		[1] = 'int64':instanceId
		[2] = 'int32':pos	[穴位位置]
	}
--]]
c2s.REQUEST_ACUPOINT_BREACH = 0x150a

--[[
	[1] = {--BuyFundRequest
		[1] = 'int32':fundId	[ 购买的基金ID]
	}
--]]
c2s.BUY_FUND_REQUEST = 0x2070

--[[
	[1] = {--QueryRecallInviteList
	}
--]]
c2s.QUERY_RECALL_INVITE_LIST = 0x5322

--[[
	[1] = {--ApplyReturnGift
	}
--]]
c2s.APPLY_RETURN_GIFT = 0x5324

--[[
	[1] = {--QueryRecallTask
	}
--]]
c2s.QUERY_RECALL_TASK = 0x5300

--[[
	[1] = {--GetMiningPointList
		[1] = 'int32':type	[宝藏类型.1:连城宝藏;2:闯王宝藏;3:大清龙脉]
		[2] = 'int32':begin	[起始索引,宝藏挖掘点索引,第几个位置.1--n    //起始索引,宝藏挖掘点索引,第几个位置.1--n]
		[3] = 'int32':end	[结束索引,宝藏挖掘点索引,第几个位置.1--n    //结束索引,宝藏挖掘点索引,第几个位置.1--n]
	}
--]]
c2s.GET_MINING_POINT_LIST = 0x2201

--[[
	[1] = {--BloodyInspire
		[1] = 'int32':resType	[鼓舞资源类型]
	}
--]]
c2s.BLOODY_INSPIRE = 0x3215

--[[
	[1] = {--RequestMergeAuto
	}
--]]
c2s.REQUEST_MERGE_AUTO = 0x5804

--[[
	[1] = {--UnUseProtagonistSkill
		[1] = 'int32':pos	[技能的位置]
	}
--]]
c2s.UN_USE_PROTAGONIST_SKILL = 0x1f07

--[[
	[1] = {--TianJiLunOpenRequest
	}
--]]
c2s.TIAN_JI_LUN_OPEN_REQUEST = 0x7502

--[[
	[1] = {--WatchCrossServerBattleReplay
		[1] = 'int32':replayId
	}
--]]
c2s.WATCH_CROSS_SERVER_BATTLE_REPLAY = 0x0f24

--[[
	[1] = {--GuildGiveReceiveRequest
	}
--]]
c2s.GUILD_GIVE_RECEIVE_REQUEST = 0x4c03

--[[
	[1] = {--ContestTeamRequest
		[1] = 'int32':type	[ 0随机匹配 1自定义队伍]
		[2] = 'string':name	[ 队伍名称]
	}
--]]
c2s.CONTEST_TEAM_REQUEST = 0x6e01

--[[
	[1] = {--GetSignRequest
	}
--]]
c2s.GET_SIGN_REQUEST = 0x2701

--[[
	[1] = {--GetMineReward
		[1] = 'int32':id	[1,领取矿1的奖励,2,领取矿2的奖励]
	}
--]]
c2s.GET_MINE_REWARD = 0x5003

--[[
	[1] = {--ChampionsBet
		[1] = 'int32':roundId
		[2] = 'int32':index
		[3] = 'int32':coin
		[4] = 'int32':betPlayerId
	}
--]]
c2s.CHAMPIONS_BET = 0x4512

--[[
	[1] = {--SignRequest
	}
--]]
c2s.SIGN_REQUEST = 0x2702

--[[
	[1] = {--ChallengeLadder
		[1] = 'int32':index	[要挑战的索引 0开始]
	}
--]]
c2s.CHALLENGE_LADDER = 0x7903

--[[
	[1] = {--ChangeWarSide
		[1] = 'int32':rankType	[副本类型]
		[2] = 'int32':fromIndex	[来源阵位]
		[3] = 'int32':targetIndex	[需要放到目标阵位]
	}
--]]
c2s.CHANGE_WAR_SIDE = 0x2d03

--[[
	[1] = {--DispatchMercenaryTeam
		[1] = {--repeated MercenaryRoleInfo
			[1] = 'int64':instanceId	[角色实例ID]
			[2] = 'int32':position	[位置,0~8]
		},
		[2] = {--repeated MercenaryRoleInfo
			[1] = 'int64':instanceId	[角色实例ID]
			[2] = 'int32':position	[位置,0~8]
		},
	}
--]]
c2s.DISPATCH_MERCENARY_TEAM = 0x5151

--[[
	[1] = {--QueryCrossChampionsWarInfos
	}
--]]
c2s.QUERY_CROSS_CHAMPIONS_WAR_INFOS = 0x4517

--[[
	[1] = {--MergeEquipment
		[1] = 'int32':fragmentId	[碎片ID]
	}
--]]
c2s.MERGE_EQUIPMENT = 0x1060

--[[
	[1] = {--RequestHeartGemMosaic
		[1] = 'int64':instanceId	[镶嵌的天书id]
		[2] = 'int32':itemId	[宝石id]
		[3] = 'int32':pos	[镶嵌的位置]
	}
--]]
c2s.REQUEST_HEART_GEM_MOSAIC = 0x7b11

--[[
	[1] = {--QueryTask
	}
--]]
c2s.QUERY_TASK = 0x2001

--[[
	[1] = {--RequestBuyCoin
	}
--]]
c2s.REQUEST_BUY_COIN = 0x1920

--[[
	[1] = {--RandomMallWish
		[1] = 'int32':commodityId	[许愿商品的id]
	}
--]]
c2s.RANDOM_MALL_WISH = 0x1910

--[[
	[1] = {--EquipmentRecast
		[1] = 'int64':equipmentId
		[2] = 'bool':lock
		[3] = 'int64':recastEquipmentId
		[4] = 'int32':index
	}
--]]
c2s.EQUIPMENT_RECAST = 0x1082

--[[
	[1] = {--CrossChampionsBet
		[1] = 'int32':roundId
		[2] = 'int32':index
		[3] = 'int32':coin
		[4] = 'int32':betPlayerId
	}
--]]
c2s.CROSS_CHAMPIONS_BET = 0x4518

--[[
	[1] = {--GainCrossGuildBattleReplayInfos
		[1] = 'int32':warId
	}
--]]
c2s.GAIN_CROSS_GUILD_BATTLE_REPLAY_INFOS = 0x4436

--[[
	[1] = {--GuildDanFangHelperRequest
		[1] = 'int32':toPlayer	[助力玩家id]
	}
--]]
c2s.GUILD_DAN_FANG_HELPER_REQUEST = 0x5e03

--[[
	[1] = {--SettingGetConfig
	}
--]]
c2s.SETTING_GET_CONFIG = 0x1e00

--[[
	[1] = {--GainAllCityInfo
	}
--]]
c2s.GAIN_ALL_CITY_INFO = 0x4440

--[[
	[1] = {--BibleKeyLevelUpRequest
		[1] = 'int64':itemId	[秘钥实例id]
	}
--]]
c2s.BIBLE_KEY_LEVEL_UP_REQUEST = 0x6027

--[[
	[1] = {--QueryOpenServiceActivityStatus
		[1] = 'int32':type	[类型.0:全部]
	}
--]]
c2s.QUERY_OPEN_SERVICE_ACTIVITY_STATUS = 0x3300

--[[
	[1] = {--EmployOtherInfo
	}
--]]
c2s.EMPLOY_OTHER_INFO = 0x5103

--[[
	[1] = {--RealNameRequest
		[1] = 'int32':AntiaddictionCode	[实名状态 0是实名并且成年1是未成年2是未实名]
	}
--]]
c2s.REAL_NAME_REQUEST = 0x1e03

--[[
	[1] = {--GainFriendApplyList
	}
--]]
c2s.GAIN_FRIEND_APPLY_LIST = 0x4301

--[[
	[1] = {--HeadPicFrameSet
		[1] = 'int32':id
	}
--]]
c2s.HEAD_PIC_FRAME_SET = 0x0e96

--[[
	[1] = {--FormationRequest
		[1] = 'int32':type	[类型 1单阵容攻击 2单阵容防守 3双阵容攻击1阵容 4双阵容攻击2阵容]
		[2] = 'repeated int64':roleId	[侠客站位]
	}
--]]
c2s.FORMATION_REQUEST = 0x6700

--[[
	[1] = {--UpdateDemand
		[1] = 'int64':id
	}
--]]
c2s.UPDATE_DEMAND = 0x430e

--[[
	[1] = {--RequestMatchFate
		[1] = 'int64':instanceId	[角色实例ID]
		[2] = 'int32':roleFateId	[角色缘分id]
		[3] = 'int32':goodsId	[道具id]
		[4] = 'int32':goodsNum	[道具使用个数]
	}
--]]
c2s.REQUEST_MATCH_FATE = 0x5601

--[[
	[1] = {--EscortAgencyEnrollRequest
		[1] = 'int32':type	[飙车部位类型1:护甲 2:镖旗3:轮子 4:车厢]
	}
--]]
c2s.ESCORT_AGENCY_ENROLL_REQUEST = 0x5f02

--[[
	[1] = {--GangInviteMember
		[1] = 'int32':playerId
	}
--]]
c2s.GANG_INVITE_MEMBER = 0x1805

--[[
	[1] = {--ApplyFriend
		[1] = 'repeated int32':playerIds
	}
--]]
c2s.APPLY_FRIEND = 0x4303

--[[
	[1] = {--ChallengeEscorting
		[1] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.CHALLENGE_ESCORTING = 0x2900

--[[
	[1] = {--ApplyCrossChampions
	}
--]]
c2s.APPLY_CROSS_CHAMPIONS = 0x4523

--[[
	[1] = {--SerdangBoxRequest
	}
--]]
c2s.SERDANG_BOX_REQUEST = 0x7207

--[[
	[1] = {--QueryBloodyDetail
	}
--]]
c2s.QUERY_BLOODY_DETAIL = 0x3209

--[[
	[1] = {--SerdangChallengeRequest
		[1] = 'int32':floorId	[层id]
		[2] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
	}
--]]
c2s.SERDANG_CHALLENGE_REQUEST = 0x7202

--[[
	[1] = {--SerdangBuyChallengeCountRequest
		[1] = 'int32':count	[购买次数]
	}
--]]
c2s.SERDANG_BUY_CHALLENGE_COUNT_REQUEST = 0x7205

--[[
	[1] = {--QueryAttrAddMsg
	}
--]]
c2s.QUERY_ATTR_ADD = 0x1402

--[[
	[1] = {--QueryQimenMsg
	}
--]]
c2s.QUERY_QIMEN = 0x5200

--[[
	[1] = {--RequestSacrificePickup
		[1] = 'int32':index	[拾取的目标索引,0表示全部拾取]
	}
--]]
c2s.REQUEST_SACRIFICE_PICKUP = 0x3e03

--[[
	[1] = {--BattlePetTameUplevelRequest
		[1] = 'int64':instanceId	[战宠Id]
		[2] = 'int32':type	[属性类型]
	}
--]]
c2s.BATTLE_PET_TAME_UPLEVEL_REQUEST = 0x4f0b

--[[
	[1] = {--RequestSacrificeMergeAuto
	}
--]]
c2s.REQUEST_SACRIFICE_MERGE_AUTO = 0x3e04

--[[
	[1] = {--RefreshMine
		[1] = 'int32':id	[1,刷新矿1,2,刷新矿2]
	}
--]]
c2s.REFRESH_MINE = 0x5001

--[[
	[1] = {--RequestGetLingQi
	}
--]]
c2s.REQUEST_GET_LING_QI = 0x3e08

--[[
	[1] = {--AdventureShopBuy
		[1] = 'int32':type	[ 类型 1.珍本 2.善本 3.全本 4.抄本 5.残本]
		[2] = 'int32':goodsId	[ 购买货物的ID]
		[3] = 'int32':buyNum	[ 购买的数量]
	}
--]]
c2s.ADVENTURE_SHOP_BUY = 0x5904

--[[
	[1] = {--RequestMartialEnchant
		[1] = 'int64':roleId	[角色id]
		[2] = 'int32':position	[武学装备位置]
		[3] = {--repeated EnchantMaterial
			[1] = 'int32':id	[id]
			[2] = 'int32':number	[个数]
		},
	}
--]]
c2s.REQUEST_MARTIAL_ENCHANT = 0x3405

--[[
	[1] = {--GainRushZoneInfo
	}
--]]
c2s.GAIN_RUSH_ZONE_INFO = 0x7601

--[[
	[1] = {--GainRushCheckPoint
	}
--]]
c2s.GAIN_RUSH_CHECK_POINT = 0x7602

--[[
	[1] = {--QueryChallengeTimes
	}
--]]
c2s.QUERY_CHALLENGE_TIMES = 0x1405

--[[
	[1] = {--RoleStarUp
		[1] = 'int64':userid	[角色实例id]
		[2] = 'repeated int64':dogfoodlist	[消耗角色实例id]
		[3] = {--repeated RoleSoulInfo
			[1] = 'int32':id	[角色的id]
			[2] = 'int32':num	[角色魂魄的数量]
		},
	}
--]]
c2s.ROLE_STAR_UP = 0x1504

--[[
	[1] = {--SpellLevelUpRequest
		[1] = 'int64':userid	[目标角色的实例ID]
		[2] = 'int32':spellId	[技能ID,对应技能当前等级的唯一ID.为t_s_spell_level表格主键]
	}
--]]
c2s.SPELL_LEVEL_UP_REQUEST = 0x1520

--[[
	[1] = {--GuardMine
		[1] = 'int32':friendId	[护矿好友id]
		[2] = 'int32':id	[1,矿1,2,矿2]
	}
--]]
c2s.GUARD_MINE = 0x5008

--[[
	[1] = {--BattlePetTrainerReplaceRequest
		[1] = 'int64':instanceId	[战宠id]
		[2] = 'int64':xiakeId	[侠客id]
	}
--]]
c2s.BATTLE_PET_TRAINER_REPLACE_REQUEST = 0x4f03

--[[
	[1] = {--GetCardRoleMsg
		[1] = 'int32':cardType	[ 1 最高得乙, 2 最高得甲, 3 连抽十次]
		[2] = 'bool':free	[ 是否免费]
	}
--]]
c2s.GET_CARD_ROLE = 0x1c01

--[[
	[1] = {--RequestBatchBetAuto
		[1] = 'int32':count	[自动赌石次数.0表示服务器控制]
	}
--]]
c2s.REQUEST_BATCH_BET_AUTO = 0x5801

--[[
	[1] = {--QueryBloodyInfo
	}
--]]
c2s.QUERY_BLOODY_INFO = 0x3200

--[[
	[1] = {--GetTaskReward
		[1] = 'int32':taskid	[成就id 0代表领取全部奖励]
	}
--]]
c2s.GET_TASK_REWARD = 0x2002

--[[
	[1] = {--RoleTransfer
		[1] = 'int64':userid	[角色实例id]
		[2] = 'repeated int64':dogfoodlist	[消耗角色实例id]
		[3] = {--repeated RoleSoulInfo
			[1] = 'int32':id	[角色的id]
			[2] = 'int32':num	[角色魂魄的数量]
		},
	}
--]]
c2s.ROLE_TRANSFER = 0x1508

--[[
	[1] = {--QuitBattleRequest
	}
--]]
c2s.QUIT_BATTLE_REQUEST = 0x5929

--[[
	[1] = {--SettingSendBug
		[1] = 'string':content	[bug内容]
	}
--]]
c2s.SETTING_SEND_BUG = 0x1e02

--[[
	[1] = {--GetHeroDuelInfoRequest
	}
--]]
c2s.GET_HERO_DUEL_INFO_REQUEST = 0x6f02

--[[
	[1] = {--EmployTeamRequest
		[1] = 'int32':playerId	[目标玩家ID]
		[2] = 'int32':useType	[使用类型]
	}
--]]
c2s.EMPLOY_TEAM_REQUEST = 0x5160

--[[
	[1] = {--GainBattleVideo
		[1] = 'int32':replayId
		[2] = 'int32':reportId
	}
--]]
c2s.GAIN_BATTLE_VIDEO = 0x5013

--[[
	[1] = {--QueryGuildBattleWarInfos
	}
--]]
c2s.QUERY_GUILD_BATTLE_WAR_INFOS = 0x5704

--[[
	[1] = {--GetMyTGReward
	}
--]]
c2s.GET_MY_TGREWARD = 0x1313

--[[
	[1] = {--RequestBatchSacrificeAuto
		[1] = 'int32':count	[自动赌石次数.0表示服务器控制]
		[2] = 'bool':isHish	[ 高级:true,普通:false]
	}
--]]
c2s.REQUEST_BATCH_SACRIFICE_AUTO = 0x3e01

--[[
	[1] = {--LangBlessedConfigRequest
	}
--]]
c2s.LANG_BLESSED_CONFIG_REQUEST = 0x4d01

--[[
	[1] = {--HomeShareRequest
	}
--]]
c2s.HOME_SHARE_REQUEST = 0x7403

--[[
	[1] = {--BuyResRequest
		[1] = 'int32':id	[ 模板ID]
	}
--]]
c2s.BUY_RES_REQUEST = 0x6c00

--[[
	[1] = {--EscortAgencyAttackRequest
		[1] = 'int32':guildId	[帮派id]
		[2] = 'int32':type	[位置]
	}
--]]
c2s.ESCORT_AGENCY_ATTACK_REQUEST = 0x5f06

--[[
	[1] = {--SendRedPacketRequest
		[1] = 'int32':id	[ 模板ID]
		[2] = 'string':desc	[ 红包的发放描述]
		[3] = 'int32':num	[ 红包可领取数量]
	}
--]]
c2s.SEND_RED_PACKET_REQUEST = 0x6b01

--[[
	[1] = {--ContestTeamRankingRequest
	}
--]]
c2s.CONTEST_TEAM_RANKING_REQUEST = 0x6e08

--[[
	[1] = {--GetRebateTurntableRecordRequest
	}
--]]
c2s.GET_REBATE_TURNTABLE_RECORD_REQUEST = 0x7d01

--[[
	[1] = {--RewardBoxWulin
		[1] = 'int32':isReward	[请求领取:1,请求状态为:0]
	}
--]]
c2s.REWARD_BOX_WULIN = 0x7807

--[[
	[1] = {--GetEquipmentStarUpFail
	}
--]]
c2s.GET_EQUIPMENT_STAR_UP_FAIL = 0x1021

--[[
	[1] = {--QueryRankingBaseInfo
		[1] = 'int32':type	[排行榜类型]
		[2] = 'int32':startIndex	[开始索引,0~N]
		[3] = 'int32':length	[获取信息长度]
		[4] = 'int32':guildZoneType	[公会副本类型 1查看副本通关时间 2查看副本伤害]
		[5] = 'int32':guildZoneId	[公会副本编号]
		[6] = 'int32':guildCheckpoint	[公会关卡编号]
	}
--]]
c2s.QUERY_RANKING_BASE_INFO = 0x4050

--[[
	[1] = {--GainCityBattleSimpleInfo
	}
--]]
c2s.GAIN_CITY_BATTLE_SIMPLE_INFO = 0x4437

--[[
	[1] = {--StartPractice
		[1] = 'int32':pos
		[2] = 'int64':instanceId
		[3] = 'int32':attributeType
	}
--]]
c2s.START_PRACTICE = 0x4424

--[[
	[1] = {--GemUnMosaic
		[1] = 'int64':equipment	[卸下的装备id]
		[2] = 'int32':pos	[卸下的位置]
	}
--]]
c2s.GEM_UN_MOSAIC = 0x1052

--[[
	[1] = {--ArenaGetTopPlayerList
	}
--]]
c2s.ARENA_GET_TOP_PLAYER_LIST = 0x1306

--[[
	[1] = {--FactionSwithRequest
	}
--]]
c2s.FACTION_SWITH_REQUEST = 0x2503

--[[
	[1] = {--EquipmentTranslateRequest
		[1] = 'int64':srcId	[源装备实例ID]
		[2] = 'int64':targetId	[目标装备实例ID]
	}
--]]
c2s.EQUIPMENT_TRANSLATE_REQUEST = 0x1090

--[[
	[1] = {--GetDiningRequest
	}
--]]
c2s.GET_DINING_REQUEST = 0x2501

--[[
	[1] = {--BattlePetUpHoleRequest
		[1] = 'int64':instanceId	[战宠Id]
		[2] = 'int32':type	[孔位类型]
	}
--]]
c2s.BATTLE_PET_UP_HOLE_REQUEST = 0x4f08

--[[
	[1] = {--AdventureBattleLog
	}
--]]
c2s.ADVENTURE_BATTLE_LOG = 0x5909

--[[
	[1] = {--RequestHeartMethodSynthesis
		[1] = 'int32':itemId	[   待合成的心法模板id]
	}
--]]
c2s.REQUEST_HEART_METHOD_SYNTHESIS = 0x7b09

--[[
	[1] = {--DiningRequest
	}
--]]
c2s.DINING_REQUEST = 0x2502

--[[
	[1] = {--GetInvocatoryDayReward
	}
--]]
c2s.GET_INVOCATORY_DAY_REWARD = 0x5403

--[[
	[1] = {--AdventureEvent
		[1] = 'int32':eventId	[ 事件ID]
		[2] = 'int32':employType	[佣兵阵型类型,不使用佣兵阵型时为0]
	}
--]]
c2s.ADVENTURE_EVENT = 0x5910

--[[
	[1] = {--StarLevelDestiny
		[1] = 'int64':instanceId
	}
--]]
c2s.STAR_LEVEL_DESTINY = 0x3f08

--[[
	[1] = {--EquipBilbleRequest
		[1] = 'int64':roleId	[角色实例id]
		[2] = 'int64':bible	[装备到身上的天书userid]
		[3] = 'int32':itemid	[装备到身上的天书的模板id]
	}
--]]
c2s.EQUIP_BILBLE_REQUEST = 0x6001

--[[
	[1] = {--QimenBreachMsg
	}
--]]
c2s.QIMEN_BREACH = 0x5202

--[[
	[1] = {--GetPlayerDetails
		[1] = 'int32':playerId	[玩家id]
		[2] = 'int32':type	[类型]
	}
--]]
c2s.GET_PLAYER_DETAILS = 0x0e71

--[[
	[1] = {--SerdangReplayRequest
		[1] = 'int32':playerId	[玩家ID]
	}
--]]
c2s.SERDANG_REPLAY_REQUEST = 0x7208

--[[
	[1] = {--GetKnightInfo
	}
--]]
c2s.GET_KNIGHT_INFO = 0x7a08

--[[
	[1] = {--PotentialPracticeRequest
		[1] = 'int64':roleId	[ 角色实例id]
		[2] = 'int32':stage	[ 潜修阶段]
		[3] = 'int32':configId	[ 潜修配置id]
		[4] = 'int32':count	[ 次数]
		[5] = {--repeated LockAttInfo
			[1] = 'int32':attIndex	[属性下标]
			[2] = 'int32':lock	[0:不锁 1:锁]
		},
	}
--]]
c2s.POTENTIAL_PRACTICE_REQUEST = 0x6800

--[[
	[1] = {--PeakRankingRequest
		[1] = 'int32':startRank	[ 其实排名的10组数据]
	}
--]]
c2s.PEAK_RANKING_REQUEST = 0x7107

--[[
	[1] = {--ContestTeamJoinRequest
		[1] = 'int64':id	[ 队伍唯一标识]
		[2] = 'int32':type	[ 0接受 1拒绝]
	}
--]]
c2s.CONTEST_TEAM_JOIN_REQUEST = 0x6e05

--[[
	[1] = {--OccupiedPeakRequest
		[1] = 'int32':layer	[ 层数]
		[2] = 'int32':pos	[ 位置]
		[3] = 'int32':playerId	[ 要攻击的玩家ID 为0时为占领]
	}
--]]
c2s.OCCUPIED_PEAK_REQUEST = 0x7101

--[[
	[1] = {--OpenPeakRequest
		[1] = 'int32':layer	[ 层数 层数为0的时候 为默认打开论剑峰]
		[2] = 'int32':page	[ 页数]
	}
--]]
c2s.OPEN_PEAK_REQUEST = 0x7100

--[[
	[1] = {--PeakBattleLogRequest
	}
--]]
c2s.PEAK_BATTLE_LOG_REQUEST = 0x7104

--[[
	[1] = {--GainWulinEnemiesInfo
	}
--]]
c2s.GAIN_WULIN_ENEMIES_INFO = 0x7801

--[[
	[1] = {--PayGetBillNo
		[1] = 'int32':id	[商品ID]
		[2] = 'int32':source	[来源标识(0:未知,1:招募)    //来源标识(0:未知,1:招募)]
	}
--]]
c2s.PAY_GET_BILL_NO = 0x1a00

--[[
	[1] = {--CustomSkillInfoClient
		[1] = 'int32':strategyType	[阵型]
		[2] = 'bool':isUse	[是否使用自定义]
		[3] = 'repeated int32':baseOrder	[常规顺序]
		[4] = {--repeated SpecialOrderInfoClient
			[1] = 'int32':roleId	[角色ID]
			[2] = 'bool':isCheckBox	[是否勾选]
			[3] = 'int32':specialOrderType
			[4] = 'int32':percentNum	[百分比数字]
		},
	}
--]]
c2s.CUSTOM_SKILL_INFO_CLIENT = 0x0f2b

--[[
	[1] = {--LotteryRequest
		[1] = 'int32':type	[ 0正常抽奖 1关闭抽奖界面服务器一次性抽取剩余奖励]
	}
--]]
c2s.LOTTERY_REQUEST = 0x5926

--[[
	[1] = {--Mine
		[1] = 'int32':id	[1,挖矿1,2,挖矿2]
		[2] = 'int32':friendId	[护矿玩家id]
	}
--]]
c2s.MINE = 0x5002

--[[
	[1] = {--VoteImpeachment
		[1] = 'int32':type	[1:赞成 2:反对]
	}
--]]
c2s.VOTE_IMPEACHMENT = 0x4449

--[[
	[1] = {--ExitGuild
	}
--]]
c2s.EXIT_GUILD = 0x4405

--[[
	[1] = {--GetFirstRechargeReward
	}
--]]
c2s.GET_FIRST_RECHARGE_REWARD = 0x1a10

--[[
	[1] = {--RequestChangeCaveOption
		[1] = 'int32':sectionId	[选中的关卡ID]
	}
--]]
c2s.REQUEST_CHANGE_CAVE_OPTION = 0x4923

--[[
	[1] = {--AgreedApply
		[1] = 'int32':playerId
	}
--]]
c2s.AGREED_APPLY = 0x4403

--[[
	[1] = {--BreachDestiny
		[1] = 'int64':instanceId	[天命实例id]
		[2] = 'repeated int64':targetId	[吞噬目标天命id集合]
	}
--]]
c2s.BREACH_DESTINY = 0x3f04

--[[
	[1] = {--RequestResetNorthCave
	}
--]]
c2s.REQUEST_RESET_NORTH_CAVE = 0x4900

--[[
	[1] = {--OneKeySweepRequest
	}
--]]
c2s.ONE_KEY_SWEEP_REQUEST = 0x4930

--[[
	[1] = {--ResetChallengeCountRequest
		[1] = 'int32':missionId	[关卡Id]
	}
--]]
c2s.RESET_CHALLENGE_COUNT_REQUEST = 0x1203

--[[
	[1] = {--GuildBossHelpBattleRequest
	}
--]]
c2s.GUILD_BOSS_HELP_BATTLE_REQUEST = 0x4b05

--[[
	[1] = {--getEscortingReward
	}
--]]
c2s.GET_ESCORTING_REWARD = 0x2903

--[[
	[1] = {--OpenChapterBoxRequest
		[1] = 'int32':chapterId	[章节ID]
		[2] = 'int32':difficulty	[难度]
		[3] = 'int32':boxId	[奖励的宝箱id,对应t_s_stage_box表格中的id字段.此字段为了兼容一个关卡多个宝箱的需求]
	}
--]]
c2s.OPEN_CHAPTER_BOX_REQUEST = 0x1202

--[[
	[1] = {--GuardRecordList
		[1] = 'int32':curCount	[当前数量]
	}
--]]
c2s.GUARD_RECORD_LIST = 0x5006

--[[
	[1] = {--ChallengeMine
		[1] = 'int32':playerId	[打劫的玩家]
		[2] = 'int32':type	[打劫的矿洞]
		[3] = 'int32':challengeIndex	[打劫的所有 1挖矿的人 2 护矿的人]
	}
--]]
c2s.CHALLENGE_MINE = 0x500c

--[[
	[1] = {--ExpTransferMsg
		[1] = 'int64':fromId	[被传承角色实例id]
		[2] = 'int64':targetId	[传陈角色实例id]
		[3] = 'int32':type	[1 初级传承 2 中级 3 高级]
	}
--]]
c2s.EXP_TRANSFER = 0x1503

--[[
	[1] = {--BattlePetUpRequest
		[1] = 'int32':type	[1升品,2升星]
		[2] = 'int64':instanceId	[战宠id]
	}
--]]
c2s.BATTLE_PET_UP_REQUEST = 0x4f02

--[[
	[1] = {--QueryDiscountShopItem
	}
--]]
c2s.QUERY_DISCOUNT_SHOP_ITEM = 0x2060

--[[
	[1] = {--GainRelpys
	}
--]]
c2s.GAIN_RELPYS = 0x500d

--[[
	[1] = {--UnlockMine
	}
--]]
c2s.UNLOCK_MINE = 0x5004

--[[
	[1] = {--GetVipRewardList
	}
--]]
c2s.GET_VIP_REWARD_LIST = 0x1a05

--[[
	[1] = {--AutoMergeGemRequest
		[1] = 'int32':maxLevel	[最高自动合成到什么等级]
	}
--]]
c2s.AUTO_MERGE_GEM_REQUEST = 0x1056

--[[
	[1] = {--QueryArenaTopBattleReport
	}
--]]
c2s.QUERY_ARENA_TOP_BATTLE_REPORT = 0x1d40

--[[
	[1] = {--ResetChallengeTimes
		[1] = 'int32':battleType	[1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点    //1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点]
	}
--]]
c2s.RESET_CHALLENGE_TIMES = 0x2104

--[[
	[1] = {--RoleAuthenticateRequest
	}
--]]
c2s.ROLE_AUTHENTICATE_REQUEST = 0x2a01

--[[
	[1] = {--QueryMyArenaChallengeBattleReport
	}
--]]
c2s.QUERY_MY_ARENA_CHALLENGE_BATTLE_REPORT = 0x1d42

--[[
	[1] = {--QueryFightNotify
		[1] = 'bool':unread	[是否请求未读消息.如果是则只返回未读消息,否则返回全部消息]
	}
--]]
c2s.QUERY_FIGHT_NOTIFY = 0x1d06

--[[
	[1] = {--LadderStopBattle
		[1] = 'int32':index	[要挑战的索引 0开始]
	}
--]]
c2s.LADDER_STOP_BATTLE = 0x7904

--[[
	[1] = {--QuerySystemNotify
		[1] = 'bool':unread	[是否请求未读消息.如果是则只返回未读消息,否则返回全部消息]
	}
--]]
c2s.QUERY_SYSTEM_NOTIFY = 0x1d08

--[[
	[1] = {--ErrorReport
		[1] = 'string':errorMessage	[错误消息]
	}
--]]
c2s.ERROR_REPORT = 0x7ffe

--[[
	[1] = {--GiveUpRush
	}
--]]
c2s.GIVE_UP_RUSH = 0x7605

--[[
	[1] = {--OpenBox
		[1] = 'int32':type	[类型]
	}
--]]
c2s.OPEN_BOX = 0x4508

--[[
	[1] = {--RequestMartialLevelUp
		[1] = 'int64':roleId	[角色id]
	}
--]]
c2s.REQUEST_MARTIAL_LEVEL_UP = 0x3403

--[[
	[1] = {--LongMenBreakResetRequest
		[1] = 'int32':floor	[ 层数]
		[2] = 'int32':goodsId	[道具id]
	}
--]]
c2s.LONG_MEN_BREAK_RESET_REQUEST = 0x6906

--[[
	[1] = {--GangGetBuff
	}
--]]
c2s.GANG_GET_BUFF = 0x1817

--[[
	[1] = {--QimenInjectMsg
	}
--]]
c2s.QIMEN_INJECT = 0x5201

--[[
	[1] = {--BuriedHistory
	}
--]]
c2s.BURIED_HISTORY = 0x5934

--[[
	[1] = {--GangCancelAppointSecondMaster
		[1] = 'int32':playerId
	}
--]]
c2s.GANG_CANCEL_APPOINT_SECOND_MASTER = 0x180e

--[[
	[1] = {--SelectAttrAddMsg
		[1] = 'int32':attr	[ 1 血量加成, 2 内功加成, 3 外功加成, 4 内防加成, 5 外防加成 6 冰火毒伤加成]
	}
--]]
c2s.SELECT_ATTR_ADD = 0x1401

--[[
	[1] = {--GangGetMemberList
	}
--]]
c2s.GANG_GET_MEMBER_LIST = 0x1803

--[[
	[1] = {--OpenDriveBeastInfo
	}
--]]
c2s.OPEN_DRIVE_BEAST_INFO = 0x6101

--[[
	[1] = {--LongMenBreakInfoRequest
	}
--]]
c2s.LONG_MEN_BREAK_INFO_REQUEST = 0x6900

--[[
	[1] = {--GuildPracticeInfo
	}
--]]
c2s.GUILD_PRACTICE_INFO = 0x4422

--[[
	[1] = {--DrowLadderMission
		[1] = 'int32':id
	}
--]]
c2s.DROW_LADDER_MISSION = 0x7905

--[[
	[1] = {--RefreshColorEggRequest
	}
--]]
c2s.REFRESH_COLOR_EGG_REQUEST = 0x4708

--[[
	[1] = {--HeartBeatRequest
	}
--]]
c2s.HEART_BEAT_REQUEST = 0xd23

--[[
	[1] = {--LoginMsg
		[1] = 'string':accountId	[帐号id]
		[2] = 'string':validateCode	[登录完成后获得的校验码]
		[3] = 'int32':serverId	[服务器唯一标识]
		[4] = 'string':token	[设备token]
		[5] = 'string':deviceName	[设备名称]
		[6] = 'string':osName	[设备系统名称]
		[7] = 'string':osVersion	[设备系统版本]
		[8] = 'string':channel	[渠道]
		[9] = 'string':sdk	[第三方接入类型.如:PP.91等]
		[10] = 'string':deviceid	[设备ID唯一标识]
		[11] = 'string':sdkVersion	[SDK版本]
		[12] = 'string':MCC	[移动设备国家码]
		[13] = 'string':IP	[联网IP地址]
		[14] = 'string':version	[版本号]
	}
--]]
c2s.LOGIN = 0x0d00

--[[
	[1] = {--DriveWorldBeast
		[1] = 'int32':type	[1:鞭炮类型  2:冲天炮类型]
	}
--]]
c2s.DRIVE_WORLD_BEAST = 0x6108

--[[
	[1] = {--LimitHotBuyRequest
		[1] = 'int32':goodsId	[商品id]
		[2] = 'int32':num	[数量]
	}
--]]
c2s.LIMIT_HOT_BUY_REQUEST = 0x5a02

--[[
	[1] = {--CheckBoxUsed
		[1] = 'int32':itemId	[id]
		[2] = 'repeated int32':indexId	[选中道具位置id]
		[3] = 'int32':number	[使用数量]
	}
--]]
c2s.CHECK_BOX_USED = 0x1030

--[[
	[1] = {--ItemSell
		[1] = 'int32':itemId	[id]
		[2] = 'int32':num	[num]
	}
--]]
c2s.ITEM_SELL = 0x1017

--[[
	[1] = {--SendWorldBeastRank
	}
--]]
c2s.SEND_WORLD_BEAST_RANK = 0x6109

--[[
	[1] = {--QueryNextRecoverTime
		[1] = 'int32':battleType	[1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点    //1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点]
	}
--]]
c2s.QUERY_NEXT_RECOVER_TIME = 0x2102

--[[
	[1] = {--LimitHotInfoRequest
	}
--]]
c2s.LIMIT_HOT_INFO_REQUEST = 0x5a01

--[[
	[1] = {--OperateGuild
		[1] = 'int32':type	[ 1 禅让 2 提升为副帮主 3降级为成员 4请离 5弹劾 6解散 7 取消解散 8升级工会 9取消禅让 10取消弹劾]
		[2] = 'int32':playerId
	}
--]]
c2s.OPERATE_GUILD = 0x4409

--[[
	[1] = {--DrawVIPScore
	}
--]]
c2s.DRAW_VIPSCORE = 0x0e9b

--[[
	[1] = {--LangBlessedHistoryRequest
		[1] = 'int32':type	[获取玩家记录历史类型  1为该玩家的记录  2为其他玩家的记录]
	}
--]]
c2s.LANG_BLESSED_HISTORY_REQUEST = 0x4d04

--[[
	[1] = {--GuildStatInfo
	}
--]]
c2s.GUILD_STAT_INFO = 0x440c

--[[
	[1] = {--LangBlessedPrayRequest
		[1] = 'int32':type	[祈福类型  单值抽取次数]
	}
--]]
c2s.LANG_BLESSED_PRAY_REQUEST = 0x4d03

--[[
	[1] = {--QueryGuildBattleMemberInfo
	}
--]]
c2s.QUERY_GUILD_BATTLE_MEMBER_INFO = 0x5703

--[[
	[1] = {--NorthCaveSweepRequest
		[1] = 'int32':length	[层数,0表示扫荡到最高的3星通关层数]
	}
--]]
c2s.NORTH_CAVE_SWEEP_REQUEST = 0x4910

--[[
	[1] = {--GainLadderRank
	}
--]]
c2s.GAIN_LADDER_RANK = 0x7902

--[[
	[1] = {--LadderSweep
		[1] = 'repeated int32':index
	}
--]]
c2s.LADDER_SWEEP = 0x7908

--[[
	[1] = {--ApplyGuild
		[1] = 'repeated int32':guildIds
	}
--]]
c2s.APPLY_GUILD = 0x4402

--[[
	[1] = {--SelectSpellRequest
		[1] = 'int32':spellId	[技能等级ID,选择的技能ID]
	}
--]]
c2s.SELECT_SPELL_REQUEST = 0x0e0c

--[[
	[1] = {--KnightRankList
		[1] = 'int32':type	[武士类型]
		[2] = 'int32':startIndex	[排行]
		[3] = 'int32':length	[请求数量]
	}
--]]
c2s.KNIGHT_RANK_LIST = 0x7a02

--[[
	[1] = {--KnightBattleStart
	}
--]]
c2s.KNIGHT_BATTLE_START = 0x7a03

--[[
	[1] = {--UpdateGuildBanner
		[1] = 'string':bannerId	[旗帜id]
	}
--]]
c2s.UPDATE_GUILD_BANNER = 0x4429

--[[
	[1] = {--DatiAnswerRequest
		[1] = 'int32':id	[题目id]
		[2] = 'int32':answerId	[答案id]
	}
--]]
c2s.DATI_ANSWER_REQUEST = 0x3b02

--[[
	[1] = {--SendHistory
	}
--]]
c2s.SEND_HISTORY = 0x6112

--[[
	[1] = {--UnapplyGuildBattle
	}
--]]
c2s.UNAPPLY_GUILD_BATTLE = 0x5701

--[[
	[1] = {--CreateTeamRequest
		[1] = 'int32':chapterId	[ 章节ID]
		[2] = 'int32':minLevel	[ 最小等级]
		[3] = 'int32':maxLevel	[ 最大等级]
		[4] = 'int32':show	[ 0对所有人展示 1仅对帮派成员和好友展示]
	}
--]]
c2s.CREATE_TEAM_REQUEST = 0x5921

--[[
	[1] = {--EndPractice
		[1] = 'int32':pos
		[2] = 'bool':finish
	}
--]]
c2s.END_PRACTICE = 0x4425

--[[
	[1] = {--QueryYabiao
	}
--]]
c2s.QUERY_YABIAO = 0x3000

--[[
	[1] = {--GangTransferMaster
	}
--]]
c2s.GANG_TRANSFER_MASTER = 0x1808

--[[
	[1] = {--EquipmentIntensifyToTop
		[1] = 'int64':equipment	[装备userid]
	}
--]]
c2s.EQUIPMENT_INTENSIFY_TO_TOP = 0x1022

--[[
	[1] = {--GainPreviousCrossInfo
	}
--]]
c2s.GAIN_PREVIOUS_CROSS_INFO = 0x4520

--[[
	[1] = {--ResetPlayerTime
	}
--]]
c2s.RESET_PLAYER_TIME = 0x5914

--[[
	[1] = {--ChangePositionRequest
		[1] = 'int64':instanceId	[ 阵法唯一ID]
		[2] = 'repeated int32':position	[ 锁定位置]
	}
--]]
c2s.CHANGE_POSITION_REQUEST = 0x6a04

--[[
	[1] = {--EquipPractice
		[1] = 'int64':equipment	[装备userid]
		[2] = 'repeated int32':lock_attr	[锁定的属性行]
	}
--]]
c2s.EQUIP_PRACTICE = 0x1023

--[[
	[1] = {--GainAssistantRole
		[1] = 'int32':friendId
		[2] = 'int32':roleId
	}
--]]
c2s.GAIN_ASSISTANT_ROLE = 0x4310

--[[
	[1] = {--BuyChallengeTimes
		[1] = 'int32':battleType	[1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点    //1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点]
		[2] = 'int32':times	[购买次数]
	}
--]]
c2s.BUY_CHALLENGE_TIMES = 0x2103

--[[
	[1] = {--ItembatchUsed
		[1] = 'int32':itemId	[道具ID]
		[2] = 'int32':num	[道具数量]
	}
--]]
c2s.ITEMBATCH_USED = 0x1061

--[[
	[1] = {--StudyProtagonistSkill
		[1] = 'int32':skillId	[技能的id]
	}
--]]
c2s.STUDY_PROTAGONIST_SKILL = 0x1f02

--[[
	[1] = {--GetVipReward
		[1] = 'int32':id	[vipID]
	}
--]]
c2s.GET_VIP_REWARD = 0x1a06

--[[
	[1] = {--QueryMyMercenaryTeam
	}
--]]
c2s.QUERY_MY_MERCENARY_TEAM = 0x5152

--[[
	[1] = {--RequestPickup
		[1] = 'int32':index	[拾取的目标索引,0表示全部拾取]
	}
--]]
c2s.REQUEST_PICKUP = 0x5803

--[[
	[1] = {--EscortAgencyRequest
	}
--]]
c2s.ESCORT_AGENCY_REQUEST = 0x5f01

--[[
	[1] = {--EquipmentStarUp
		[1] = 'int64':equipment	[装备userid]
		[2] = 'repeated int64':eat_equipment	[吞噬的装备userid]
		[3] = {--repeated StuffStruct
			[1] = 'int32':id	[物品ID]
			[2] = 'int32':number	[数量]
		},
	}
--]]
c2s.EQUIPMENT_STAR_UP = 0x1020

--[[
	[1] = {--getRecruitChest
		[1] = 'int32':chestId
	}
--]]
c2s.GET_RECRUIT_CHEST = 0x1c04

--[[
	[1] = {--CompositeItemRequest
		[1] = 'int32':compositeId	[ 合成ID]
		[2] = 'int32':compositeNum	[ 合成数量]
	}
--]]
c2s.COMPOSITE_ITEM_REQUEST = 0x1091

--[[
	[1] = {--ContestTeamChatRequest
		[1] = 'int64':id	[ 队伍唯一标识]
		[2] = 'string':msg	[ 聊天信息]
	}
--]]
c2s.CONTEST_TEAM_CHAT_REQUEST = 0x6e07

--[[
	[1] = {--GangCancelApplyAdd
		[1] = 'int32':gangId
	}
--]]
c2s.GANG_CANCEL_APPLY_ADD = 0x180d

--[[
	[1] = {--UseProtagonistSkill
		[1] = 'int32':skillId	[技能的id]
		[2] = 'int32':pos	[技能的位置]
	}
--]]
c2s.USE_PROTAGONIST_SKILL = 0x1f06

--[[
	[1] = {--QueryRecruitIntegralOutlineRank
	}
--]]
c2s.QUERY_RECRUIT_INTEGRAL_OUTLINE_RANK = 0x4011

--[[
	[1] = {--QueryGuildBattleReplayInfos
		[1] = 'int32':round
		[2] = 'int32':index
	}
--]]
c2s.QUERY_GUILD_BATTLE_REPLAY_INFOS = 0x5705

--[[
	[1] = {--SendGuildActiveRedPacket
		[1] = 'int32':type	[发送活跃红包类型]
		[2] = 'int32':num	[红包发放可领取数量]
		[3] = 'string':desc	[红包描述]
	}
--]]
c2s.SEND_GUILD_ACTIVE_RED_PACKET = 0x4446

--[[
	[1] = {--AdventureMassacre
	}
--]]
c2s.ADVENTURE_MASSACRE = 0x5907

--[[
	[1] = {--UpdateEliteCrossGuildBattle
		[1] = 'int32':index
		[2] = 'int32':playerId
	}
--]]
c2s.UPDATE_ELITE_CROSS_GUILD_BATTLE = 0x443c

--[[
	[1] = {--TianJiLunCoinRequest
		[1] = 'int32':type
	}
--]]
c2s.TIAN_JI_LUN_COIN_REQUEST = 0x7501

--[[
	[1] = {--ArenaGetPlayerList
	}
--]]
c2s.ARENA_GET_PLAYER_LIST = 0x1300

--[[
	[1] = {--GuildBossAttackRankRequest
	}
--]]
c2s.GUILD_BOSS_ATTACK_RANK_REQUEST = 0x4b11

--[[
	[1] = {--DrawActivityReward
		[1] = 'int32':activityId	[活动id]
	}
--]]
c2s.DRAW_ACTIVITY_REWARD = 0x3801

--[[
	[1] = {--GoldEggInfo
	}
--]]
c2s.GOLD_EGG_INFO = 0x4701

--[[
	[1] = {--OneKeyEquip
		[1] = 'int64':roleId	[目标角色的实例ID.即对那个角色使用一键穿装]
	}
--]]
c2s.ONE_KEY_EQUIP = 0x101e

--[[
	[1] = {--ModifyEmployTeamFormation
		[1] = 'int32':playerId	[目标玩家ID]
		[2] = 'int32':useType	[使用类型]
		[3] = {--repeated MercenaryRoleInfo
			[1] = 'int64':instanceId	[角色实例ID]
			[2] = 'int32':position	[位置,0~8]
		},
	}
--]]
c2s.MODIFY_EMPLOY_TEAM_FORMATION = 0x5162

--[[
	[1] = {--XieKeExchangeEquip
		[1] = 'int64':roleId	[ 角色实例id]
		[2] = 'int64':exchangeId	[ 互换的角色实例id]
	}
--]]
c2s.XIE_KE_EXCHANGE_EQUIP = 0x6500

--[[
	[1] = {--ArenaGetHomeInfo
	}
--]]
c2s.ARENA_GET_HOME_INFO = 0x1305

--[[
	[1] = {--BibleResolveRequest
		[1] = 'int64':instanceId	[实例id]
	}
--]]
c2s.BIBLE_RESOLVE_REQUEST = 0x6029

--[[
	[1] = {--UnapplyCrossGuildBattle
	}
--]]
c2s.UNAPPLY_CROSS_GUILD_BATTLE = 0x443b

--[[
	[1] = {--GuildGiveRecordRequest
	}
--]]
c2s.GUILD_GIVE_RECORD_REQUEST = 0x4c05

--[[
	[1] = {--GiveGifi
		[1] = 'int32':friendId
	}
--]]
c2s.GIVE_GIFI = 0x4305

--[[
	[1] = {--ComposeRequest
		[1] = 'int32':fragmentId	[ 碎片ID]
	}
--]]
c2s.COMPOSE_REQUEST = 0x6a05

--[[
	[1] = {--BloodyChangeStation
		[1] = 'int32':fromIndex	[原来的战阵索引]
		[2] = 'int32':targetIndex	[新的战阵索引]
	}
--]]
c2s.BLOODY_CHANGE_STATION = 0x3202

--[[
	[1] = {--GuildBossChallengeRequest
		[1] = 'int32':npcId	[npcId]
	}
--]]
c2s.GUILD_BOSS_CHALLENGE_REQUEST = 0x4b03

--[[
	[1] = {--UpdateFormation
		[1] = 'int32':type	[类型 0进攻  1防守]
		[2] = 'repeated int64':formations	[阵容]
	}
--]]
c2s.UPDATE_FORMATION = 0x4505

--[[
	[1] = {--QueryEmployTeamList
	}
--]]
c2s.QUERY_EMPLOY_TEAM_LIST = 0x5163

--[[
	[1] = {--BattleArrayResearch
		[1] = 'int64':instanceId	[阵法唯一ID]
		[2] = 'int32':pos	[深研位置]
	}
--]]
c2s.BATTLE_ARRAY_RESEARCH = 0x6a09

--[[
	[1] = {--RequestDestiny
	}
--]]
c2s.REQUEST_DESTINY = 0x3f01

--[[
	[1] = {--GetSendReward
		[1] = 'int32':id	[奖励配置ID,详情请见t_s_invite_code_reward_config表]
	}
--]]
c2s.GET_SEND_REWARD = 0x2602

--[[
	[1] = {--ClimbChallengeMountain
		[1] = 'int32':mountainId
		[2] = 'int32':employType	[佣兵阵形类型,如果不是使用佣兵为0]
		[3] = 'bool':status	[是否屏蔽团队增益,是:1.否:0]
	}
--]]
c2s.CLIMB_CHALLENGE_MOUNTAIN = 0x1701

--[[
	[1] = {--AdventureEnemy
	}
--]]
c2s.ADVENTURE_ENEMY = 0x5905

--[[
	[1] = {--SaleBattleArrayRequest
		[1] = 'int64':instanceId	[ 阵法唯一ID]
	}
--]]
c2s.SALE_BATTLE_ARRAY_REQUEST = 0x6a06

--[[
	[1] = {--ForgingTheBodyRequest
		[1] = 'int64':roleId	[角色实例id]
		[2] = 'int32':acupoint	[穴位]
	}
--]]
c2s.FORGING_THE_BODY_REQUEST = 0x6600

--[[
	[1] = {--BibleExchangeRequest
		[1] = 'int64':bibleId	[ 置换的天书 id 1]
		[2] = 'int64':exBibleId	[ 置换的天书 id 2]
	}
--]]
c2s.BIBLE_EXCHANGE_REQUEST = 0x6019

--[[
	[1] = {--ReceiveSettlementRewardRequest
		[1] = 'int32':rewardId	[奖励id]
	}
--]]
c2s.RECEIVE_SETTLEMENT_REWARD_REQUEST = 0x6f0b

--[[
	[1] = {--ReceivePowerRewardRequest
		[1] = 'int32':activityId	[活动Id]
	}
--]]
c2s.RECEIVE_POWER_REWARD_REQUEST = 0x2306

--[[
	[1] = {--ClimbGetCarbonList
	}
--]]
c2s.CLIMB_GET_CARBON_LIST = 0x1704

--[[
	[1] = {--UpdateProvide
		[1] = 'repeated int64':ids
	}
--]]
c2s.UPDATE_PROVIDE = 0x430f

--[[
	[1] = {--WoodManSpecialReward
		[1] = 'int32':id	[宝箱标识id]
		[2] = 'int32':length	[该档次定位距离]
	}
--]]
c2s.WOOD_MAN_SPECIAL_REWARD = 0x6312

--[[
	[1] = {--RefreshNextBeast
	}
--]]
c2s.REFRESH_NEXT_BEAST = 0x6105

--[[
	[1] = {--RequestBetByType
		[1] = 'int32':type	[赌石类型,1.试刀;2.切割;4.打磨;8.精工;16.雕琢]
	}
--]]
c2s.REQUEST_BET_BY_TYPE = 0x5800

--[[
	[1] = {--DrawHomeAward
	}
--]]
c2s.DRAW_HOME_AWARD = 0x7408

--[[
	[1] = {--BiblePracticeRequest
		[1] = 'int64':bibleId	[ 研修的天书id]
		[2] = 'int32':position	[ 位置]
	}
--]]
c2s.BIBLE_PRACTICE_REQUEST = 0x6015

--[[
	[1] = {--GetBloodyBox
		[1] = 'int32':section	[关卡号(从1开始)    //关卡号(从1开始)]
		[2] = 'int32':index	[宝箱索引(从1开始)    //宝箱索引(从1开始)]
		[3] = 'int32':getType	[1:免费领取 2:购买]
	}
--]]
c2s.GET_BLOODY_BOX = 0x3214

--[[
	[1] = {--BloodyToBattle
		[1] = {--C2SBloodyRoleStation
			[1] = 'int64':roleId	[角色ID]
			[2] = 'int32':index	[战阵索引(从0开始,-1表示未上阵)    //战阵索引(从0开始,-1表示未上阵)]
		},
	}
--]]
c2s.BLOODY_TO_BATTLE = 0x3201

--[[
	[1] = {--GainGuildBattleCurrentState
	}
--]]
c2s.GAIN_GUILD_BATTLE_CURRENT_STATE = 0x4438

--[[
	[1] = {--GainFriendPraiseRanks
	}
--]]
c2s.GAIN_FRIEND_PRAISE_RANKS = 0x7406

--[[
	[1] = {--SellBookMsg
		[1] = 'int32':bookpos
	}
--]]
c2s.SELL_BOOK = 0x1603

--[[
	[1] = {--QueryGoldenCard
	}
--]]
c2s.QUERY_GOLDEN_CARD = 0x7c01

--[[
	[1] = {--RefreshHeroDuelPlayersRequest
	}
--]]
c2s.REFRESH_HERO_DUEL_PLAYERS_REQUEST = 0x6f03

--[[
	[1] = {--GetHeroDuelLastRequest
	}
--]]
c2s.GET_HERO_DUEL_LAST_REQUEST = 0x6f01

--[[
	[1] = {--ArenaGetRewardInfo
	}
--]]
c2s.ARENA_GET_REWARD_INFO = 0x1302

--[[
	[1] = {--GuildBossStageRequest
		[1] = 'int32':stage	[阶段id]
	}
--]]
c2s.GUILD_BOSS_STAGE_REQUEST = 0x4b02

--[[
	[1] = {--GainLastBestInfo
	}
--]]
c2s.GAIN_LAST_BEST_INFO = 0x2d01

--[[
	[1] = {--Inheritance
		[1] = 'int64':instanceId
		[2] = 'int32':attributeType
		[3] = 'int64':inheritanceInstanceIdId
	}
--]]
c2s.INHERITANCE = 0x4426

--[[
	[1] = {--GangExpelMember
		[1] = 'int32':playerId
	}
--]]
c2s.GANG_EXPEL_MEMBER = 0x1807

--[[
	[1] = {--GetHeroDuelRankRequest
		[1] = 'int32':rankGroup	[排行分组]
	}
--]]
c2s.GET_HERO_DUEL_RANK_REQUEST = 0x6f04

--[[
	[1] = {--challengeHeroAmbition
		[1] = 'int32':bossId	[玩家挑战的bossId]
		[2] = 'int32':HireFormationType	[玩家租用阵容]
	}
--]]
c2s.CHALLENGE_HERO_AMBITION = 0x3901

--[[
	[1] = {--FreshTreasureHuntRank
	}
--]]
c2s.FRESH_TREASURE_HUNT_RANK = 0x6304

--[[
	[1] = {--GetAllRandomStore
	}
--]]
c2s.GET_ALL_RANDOM_STORE = 0x1904

--[[
	[1] = {--GainCityInfo
		[1] = 'int32':cityId
	}
--]]
c2s.GAIN_CITY_INFO = 0x4434

--[[
	[1] = {--TreasureBag
	}
--]]
c2s.TREASURE_BAG = 0x5937

--[[
	[1] = {--EssentialExplodeRequest
		[1] = {--repeated EssentialExplodeStruct
			[1] = 'int32':itemId	[分解模板id]
			[2] = 'int32':number	[分解的数量]
		},
	}
--]]
c2s.ESSENTIAL_EXPLODE_REQUEST = 0x6007

--[[
	[1] = {--GainMineBattleReport
		[1] = 'int32':id
	}
--]]
c2s.GAIN_MINE_BATTLE_REPORT = 0x500e

--[[
	[1] = {--RequestEquipHeartMethod
		[1] = 'int64':roleId	[ 角色Id]
		[2] = 'int64':heartMid	[ 心法唯一id]
		[3] = 'int32':itemId	[ 心法模板Id]
	}
--]]
c2s.REQUEST_EQUIP_HEART_METHOD = 0x7b03

--[[
	[1] = {--GetRewardRequest
		[1] = 'int32':type	[0:未知或者普通情况下显示提示的类型;1.豪杰榜;2铜人阵;3.天罡星等----]
	}
--]]
c2s.GET_REWARD_REQUEST = 0x7f00

--[[
	[1] = {--ExchangeRewardRequest
		[1] = 'int32':rewardId	[兑换奖励索引]
	}
--]]
c2s.EXCHANGE_REWARD_REQUEST = 0x7e03

--[[
	[1] = {--BibleKeyMosaicRequest
		[1] = 'int64':bibleId	[镶嵌的天书id]
		[2] = 'int64':itemId	[实例id]
	}
--]]
c2s.BIBLE_KEY_MOSAIC_REQUEST = 0x6024

--[[
	[1] = {--HeadPicFrameOpen
	}
--]]
c2s.HEAD_PIC_FRAME_OPEN = 0x0e95

--[[
	[1] = {--EggRecordList
		[1] = 'int32':curCount	[当前数量]
		[2] = 'int32':count	[拉取数量]
		[3] = 'int32':type	[1个人历史2玩家历史]
	}
--]]
c2s.EGG_RECORD_LIST = 0x4703

--[[
	[1] = {--GuildZoneInfo
	}
--]]
c2s.GUILD_ZONE_INFO = 0x441a

--[[
	[1] = {--OtherContestTeamRequest
		[1] = 'int64':teamId	[ 队伍ID]
		[2] = 'int32':serverId	[ 服务器ID]
	}
--]]
c2s.OTHER_CONTEST_TEAM_REQUEST = 0x6e17

--[[
	[1] = {--UpdateGuildInfo
		[1] = 'int32':type	[类型 1公告 2 宣言]
		[2] = 'string':mess	[消息]
	}
--]]
c2s.UPDATE_GUILD_INFO = 0x4408

--[[
	[1] = {--VerifyNewInviteCode
		[1] = 'int32':inviteCode	[需要验证的邀请码]
		[2] = 'string':equipmentCode	[ 设备码]
	}
--]]
c2s.VERIFY_NEW_INVITE_CODE = 0x2605

--[[
	[1] = {--WarMatixConf
		[1] = {--repeated RoleConfigure
			[1] = 'int64':userId
			[2] = 'int32':index
		},
	}
--]]
c2s.WAR_MATIX_CONF = 0x0e20

--[[
	[1] = {--HasBuried
	}
--]]
c2s.HAS_BURIED = 0x5933

--[[
	[1] = {--UnequipRequest
		[1] = 'int64':roleId	[角色实例id]
		[2] = 'int64':equipment	[装备到身上的装备userid]
	}
--]]
c2s.UNEQUIP_REQUEST = 0x1012

--[[
{}
--]]
c2s.BATTLE_PET_GET_HOLE_REQUEST = 0x4f07

--[[
	[1] = {--ApplyGuildBattle
		[1] = 'int32':index
	}
--]]
c2s.APPLY_GUILD_BATTLE = 0x5700

--[[
	[1] = {--SerdangInfoRequest
	}
--]]
c2s.SERDANG_INFO_REQUEST = 0x7201

--[[
	[1] = {--QueryGetRoleMsg
	}
--]]
c2s.QUERY_GET_ROLE = 0x1c00

--[[
	[1] = {--SendRankRequest
		[1] = 'int32':id	[第几个排行榜]
	}
--]]
c2s.SEND_RANK_REQUEST = 0x3308

--[[
	[1] = {--BattlePetExchangeRequest
		[1] = 'int64':instanceId	[战宠id]
		[2] = 'int64':exInstanceId	[战宠id]
	}
--]]
c2s.BATTLE_PET_EXCHANGE_REQUEST = 0x4f06

--[[
	[1] = {--RequestResetWaitTime
		[1] = 'int32':type	[1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点    //1-推图体力;2-群豪谱体力;3-爬塔体力; 4-江湖宝藏体力; 5-技能点]
	}
--]]
c2s.REQUEST_RESET_WAIT_TIME = 0x2105

--[[
	[1] = {--GuildGiveDonateRequest
		[1] = 'int32':playerId	[要捐赠的玩家id]
		[2] = 'int32':num	[要捐赠的数量]
	}
--]]
c2s.GUILD_GIVE_DONATE_REQUEST = 0x4c07

--[[
	[1] = {--RefreshProtagonistSkill
	}
--]]
c2s.REFRESH_PROTAGONIST_SKILL = 0x1f05

--[[
	[1] = {--GetYabiaoReward
	}
--]]
c2s.GET_YABIAO_REWARD = 0x3003

--[[
	[1] = {--RequestCountBuyXiayi
	}
--]]
c2s.REQUEST_COUNT_BUY_XIAYI = 0x1931

--[[
	[1] = {--OpenAssistantGrid
		[1] = 'int32':index	[要开启的格子]
	}
--]]
c2s.OPEN_ASSISTANT_GRID = 0x4602

--[[
	[1] = {--GuildBossHelpListRequest
	}
--]]
c2s.GUILD_BOSS_HELP_LIST_REQUEST = 0x4b08

--[[
	[1] = {--EquipmentExplode
		[1] = 'int64':equipment	[装备userid]
	}
--]]
c2s.EQUIPMENT_EXPLODE = 0x1016

--[[
	[1] = {--ContestHistoryLeiZhuRequest
	}
--]]
c2s.CONTEST_HISTORY_LEI_ZHU_REQUEST = 0x6e00

--[[
	[1] = {--GangExchange
		[1] = 'int32':index	[索引]
	}
--]]
c2s.GANG_EXCHANGE = 0x1813

--[[
	[1] = {--GainLastChampion
	}
--]]
c2s.GAIN_LAST_CHAMPION = 0x4513

--[[
	[1] = {--EmploySingleRoleRequest
		[1] = 'int32':playerId	[雇佣的角色属于哪个玩家]
		[2] = 'int64':instanceId	[角色实例ID]
		[3] = 'int32':useType	[使用类型,客户端定义,这里可以是战斗类型]
	}
--]]
c2s.EMPLOY_SINGLE_ROLE_REQUEST = 0x5120

--[[
	[1] = {--QuerySocialNotify
		[1] = 'bool':unread	[是否请求未读消息.如果是则只返回未读消息,否则返回全部消息]
	}
--]]
c2s.QUERY_SOCIAL_NOTIFY = 0x1d07

--[[
	[1] = {--BibleComprehendRequest
		[1] = 'int64':bibleId	[ 天书 id 1]
		[2] = 'int32':stage	[ 阶段id]
	}
--]]
c2s.BIBLE_COMPREHEND_REQUEST = 0x6021

--[[
	[1] = {--DatiEndRequest
	}
--]]
c2s.DATI_END_REQUEST = 0x3b03

--[[
	[1] = {--ContestRedPacketRequest
		[1] = 'int64':id	[ 红包ID]
	}
--]]
c2s.CONTEST_RED_PACKET_REQUEST = 0x6e14

--[[
	[1] = {--ArenaReceiveReward
	}
--]]
c2s.ARENA_RECEIVE_REWARD = 0x1303

--[[
	[1] = {--GangUpLevelExchange
	}
--]]
c2s.GANG_UP_LEVEL_EXCHANGE = 0x1814

--[[
	[1] = {--MHYSweepRequest
		[1] = 'int32':id	[目标关卡ID]
		[2] = 'int32':count	[扫荡次数]
	}
--]]
c2s.MHYSWEEP_REQUEST = 0x1720

--[[
	[1] = {--UnlockEquipmentHole
		[1] = 'int64':equipment	[解锁的装备id]
	}
--]]
c2s.UNLOCK_EQUIPMENT_HOLE = 0x1053

--[[
	[1] = {--UpdatePowerRequest
	}
--]]
c2s.UPDATE_POWER_REQUEST = 0x2307

--[[
	[1] = {--QueryCrossChampionsInfos
	}
--]]
c2s.QUERY_CROSS_CHAMPIONS_INFOS = 0x4515

--[[
	[1] = {--ChallengeChampions
	}
--]]
c2s.CHALLENGE_CHAMPIONS = 0x4503

--[[
	[1] = {--DigTreasure
		[1] = 'int32':rowId	[挖宝物时,服务器需要的坐标行id]
		[2] = 'int32':columnId	[挖宝物时,服务器需要的坐标列id]
	}
--]]
c2s.DIG_TREASURE = 0x5931

--[[
	[1] = {--GainLastRankInfo
	}
--]]
c2s.GAIN_LAST_RANK_INFO = 0x443e

--[[
	[1] = {--GuildBossRequest
	}
--]]
c2s.GUILD_BOSS_REQUEST = 0x4b01

return c2s