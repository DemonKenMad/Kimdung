--[[
******枚举*******

	-- by feng
	-- 2017/10/20
]]
------------------------------Enum战斗相关----------------------------------------
--战斗类型  HD不要用此枚举 此枚举HDk跟江湖不一样
EnumFightType = {
	type_1 				= 1,				--推图
	type_2 				= 2,				--铜人阵
	HaoJie 				= 3,				--豪杰榜
	type_4 				= 4,				--天罡星
	type_5 				= 5,				--无量山
	type_6 				= 6,				--大宝藏
	type_7 				= 7,				--无量山万能副本、摩诃崖
	HuJia 				= 8,				--护驾
	type_11 			= 11,				--好友战斗
	WulingDaHui 		= 12,				--武林大会
	RushChallenge 		= 26,				--闯阵挑战
	--
	YanmenGuan  		= 9,				--雁门关
	Boss  				= 10,				--世界BOSS 伏魔录
	FactionFight 		= 15, 				--帮派战
	Wuling 				= 28,				--武林公敌
	FactionFightShan 	= 17, 				--帮派后山
	--
	Adventure_Copy 		= 19,				--奇遇副本
	Adventure_Massacre 	= 20,				--奇遇杀戮(游历-挑战过客)
	Adventure_Revenge 	= 21,				--奇遇复仇(游历-还击敌人)
	Adventure_Challenge = 22,				--奇遇挑战(游历-切磋榜挑战)
	Adventure_Event 	= 23,				--奇遇事件战斗
	--只有一个版本有的战斗类型
	XinTai				= 33, 				--试心台 HD没有
	Knight 				= -1,				--国服没得
	Knight_32			= -1, 				--国服没得
	LadderOneKey		= 35, 				--天梯一键挑战 HD没有
}
if (GameConfig.Old_Jian) then
	EnumFightType.NorthClimb 			= 16 				--无量山 北窟
	EnumFightType.JianFeng 				= 24 				--论剑峰
	EnumFightType.KingOfWar				= 27 				--王者擂台
	EnumFightType.Dartcar 				= 29  				--镖车
	EnumFightType.RankKing 				= 30 				--天梯争霸
	EnumFightType.Kuang					= 31 				--劫矿
	EnumFightType.YanWu					= 32 				--演武
	EnumFightType.HeroConference 		= 34 				--英雄大会
	EnumFightType.LadderOneKey			= 35 				--天梯一键挑战
	EnumFightType.HeroicBoss 			= 38 				--英雄志
	EnumFightType.FYRecord 				= 39  				--风云录
	EnumFightType.JapanIsland 			= 40  				--东瀛岛
	--
	EnumFightType.FightType_9999 		= 9999 				--别人帮助  待定
	
elseif (GameConfig.HD) then
	EnumFightType.NorthClimb			= 16 				--无量山 北窟
	EnumFightType.Kuang					= 18 				--劫矿
	EnumFightType.JianFeng				= 24 				--论剑峰
	EnumFightType.JapanIsland			= 30  				--东瀛岛
	EnumFightType.Knight 				= 31				--浪人武士
	EnumFightType.Knight_32				= 32 				--浪人武士 别人帮助
	EnumFightType.KingOfWar				= 33 				--王者擂台
	EnumFightType.RankKing				= 34 				--天梯争霸
	EnumFightType.YanWu					= 35 				--演武
	EnumFightType.Dartcar				= 36  				--镖车
	EnumFightType.HeroConference		= 37 				--英雄大会
	EnumFightType.HeroicBoss			= 39 				--英雄志
	EnumFightType.FYRecord				= 40  				--风云录
end

--分摊伤害系数
EnumFightMorePepleHurtParams = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0}

--技能类型
EnumFightSkillType = {
	type_1 				= 1,					--正常伤害技
	type_2 				= 2,					--治疗
	type_3 				= 3,					--净化
	type_7 				= 7,					--被动技能
	type_8 				= 8,					--主动加buff
	type_9 				= 9,					--内力转武力
	type_10 			= 10,					--复活
	type_12 			= 12,					--西施主动
	type_13				= 13,					--酒桶主动 召唤
	type_14 			= 14,					--金蛇复活
	type_15 			= 15,					--治疗加净化
}
--LastType
EnumFightBuffLastType = {
	last_Type_2 			= 2,				--有侠客出手
	last_Type_3 			= 3,				--
	last_Type_10 			= 10,				--风恕
	last_Type_11 			= 11,				--携带BUFF者施放主动技或神技
	last_Type_12 			= 12,				--使用时扣次数
	last_Type_13 			= 13,				--敌方出手次数
}

--被动Effec值
EnumFightPassiveEffectType = {
	effect_7			= 7,					--化解
	effect_9 			= 9,					--复活
	effect_25 			= 25,					--闭气神功
	effect_39			= 39,					--超过XX血量上限就回血
	effect_56			= 56,					--血刀老祖 回血
	effect_72			= 72,					--超过XX血量上限就回血
	effect_100			= 100,					--为服务器战斗 免死时播放特效使用 兼容（九煞、药王的免死） ...
}

--排除特殊技能
EnumFightFilterEffectType = {
	effect_23 		= 23,		--吸功神力
	effect_25       = 25,		--闭气神功
	effect_55       = 55,		--解意孤霜
	effect_57       = 57, 		--罡气护体
	effect_37       = 37,		--暗香疏影
	effect_80       = 80,  		--借尸伏毒
}

--t_s_spell effect 附带效果	
EnumFightSpellEffect = {
	effect_5 			= 5,					--还治其身 自身被攻击有机率触发效果,反弹伤害
	effect_7 			= 7,					--化解
	effect_9 			= 9,					--复活
	effect_10 			= 10,					--净化
	effect_12 			= 12,					--免疫
	effect_25 			= 25,					--闭气神功
	effect_26 			= 26,					--斩杀 赵敏
	effect_27 			= 27,					--受到减益状态时有#effect_rate#机率反弹给对方
	effect_29 			= 29,					--狂龙乱舞 十字型溅射伤害
	effect_32 			= 32,					--九天掌法 吸血
	effect_37 			= 37,					--免死
	effect_39			= 39,					--超过XX血量上限就回血
	effect_57       	= 57, 					--罡气护体
	effect_58       	= 58, 					--血衣大法 吸血
	effect_59 			= 59,					--风恕
	effect_60 			= 60,					--西施 令已方侠客进入主动技能待发状态
	effect_61 			= 61,					--斗酒罗汉 主动技 召唤
	effect_62			= 62,					--斗酒罗汉 神技
	effect_63			= 63,					--金蛇复活队友 自己受伤标识
	effect_64			= 64,					--无视防御
	effect_65			= 65,					--狂风快剑 令我方侠客施放技能时无视身
	effect_66			= 66,					--光环技,，初始yy属性减少xx点
	effect_67			= 67,					--给对面加恕 不能被miss
	effect_68			= 68,					--香香公主 援护
	effect_69			= 69,					--香香公主 治疗越血量上限
	effect_70			= 70,					--爆魂诀自身的攻击产生暴击时，最终伤害值随机翻倍
	effect_71			= 71,					--额外附带自己气血上限X%的伤害（自己不扣血）
	effect_72			= 72,					--超过XX血量上限就回血
	effect_73			= 73,					--斩杀
	effect_75			= 75,					--减少目标战意
	effect_76			= 76,					--先天罡气（光环技，令己方所有上阵侠客单次承受伤害不会超过自身生命上限的X%）
	effect_77			= 77,					--天池神功治疗 恢复血量点上限百分百
	effect_78			= 78,					--恢复被动
	effect_79			= 79,					--十字型溅射伤害
	effect_80			= 80,					--借尸伏毒
	effect_81			= 81,					--三圣 回血被动
	effect_82			= 82,					--三圣 雄文侠客受击 免伤
	effect_84			= 84,					--技能施放无视身法 类剑神的effect_65
	effect_85			= 85,					--当自身被施加减益状态的时候，触发&effect&效果，扣除自己&effect_value&%的气血解除此状态。当自身血量低于30%时，不再触发
	effect_100			= 100,					--特殊值
}

--与服务器协调的ActiveEffect及EffectType值
EnumFightActiveEffectType = {
	effect_8 			= 8,					--主动加BUFF
	effect_9 			= 9,					--复活
	effect_10 			= 10,					--伤害传递 （黄容灵魂链接、东方恐惧BUFF）
	effect_26 			= 26,					--斩杀 赵敏
	effect_29 			= 29,					--狂龙乱舞 十字型溅射伤害
	effect_30 			= 30,					--狂龙乱舞 十字型被溅射伤害目录
	effect_31 			= 31,					--恢复次数
	effect_37 			= 37,					--免死
	effect_58       	= 58, 					--血衣大法 吸血
	effect_60 			= 60,					--西施主动
	effect_61 			= 61,					--斗酒罗汉 主动技 召唤
	effect_62 			= 62,					--金蛇 复活
	effect_63			= 63,					--金蛇复活队友 自己受伤标识
	effect_65			= 65,					--狂风快剑 令我方侠客施放技能时无视身
	effect_67			= 67,					--扣恕
	effect_68			= 68,					--香香公主 援护
	effect_70			= 70,					--爆魂诀
	effect_71			= 71,					--额外附带自己气血上限X%的伤害（自己不扣血）
	effect_72			= 72,					--超过XX血量上限就回血
	effect_73			= 73,					--斩杀
	effect_75			= 75,					--减少目标战意
	effect_77			= 77,					--天池神功治疗 恢复血量点上限百分百
	effect_78			= 78,					--恢复被动
	effect_79			= 79,					--十字型溅射伤害
	effect_80			= 80,					--借尸伏毒
	effect_81			= 81,					--三圣 回血被动
	effect_82			= 82,					--三圣 雄文侠客受击 免伤
	effect_83			= 83,					--三圣 分摊伤害
	effect_85			= 85,					--当自身被施加减益状态的时候，触发&effect&效果，扣除自己&effect_value&%的气血解除此状态。当自身血量低于30%时，不再触发
	effect_100			= 100,					--特殊值
}

--t_s_buffer_2 type 
EnumFightBufferType = {
	type_1 				= 1,					--中毒
	type_10 			= 10,					--混乱
	type_14 			= 14,					--冻结
	type_18 			= 18,					--挑衅
	type_19 			= 19,					--反弹
	type_27 			= 27,					--乾坤互换
	type_33 			= 33,					--不死不休
	type_54 			= 54,					--毒蟾功
	type_56 			= 56,					--不死
	type_59 			= 59,					--御剑 出手后跟随
	type_61 			= 61,					--小昭 援护
	type_62 			= 62,					--损心 自己
	type_63 			= 63,					--损心 目标
	type_64 			= 64,					--伤害转治疗
	type_68 			= 68,					--御龙在天
	type_69 			= 69,					--摄魂 黄容 自己
	type_70 			= 70,					--摄魂 黄容 对手
	type_71 			= 71,					--破招
	type_76 			= 76,					--倍耗
	type_81 			= 81,					--碎心(治疗转伤害)
	type_83 			= 83,					--还施
	type_84 			= 84,					--星移 miss
	type_88 			= 88,					--素问
	type_92 			= 92,					--恐惧(自己)
	type_93 			= 93,					--恐惧(对手)
	type_94 			= 94,					--风恕
	type_95 			= 95,					--灵武(自己)
	type_96 			= 96,					--灵武(队友)
	type_97 			= 97,					--真元护体(自己)
	type_98 			= 98,					--真元护体(队友)
	type_98 			= 98,					--真元护体(队友)
	type_99 			= 99,					--金蛇游身()
	type_501 			= 501,					--金蛇狂舞()
	type_502 			= 502,					--蛇毒
	type_503 			= 503,					--剑神
	type_504 			= 504,					--香意
	type_505 			= 505,					--神力 可上限
	type_506 			= 506,					--散功 自己
	type_507 			= 507,					--散功 目标
	type_508 			= 508,					--诛心 目标
	type_509 			= 509,					--诛心 目标
	type_510 			= 510,					--沁心
	type_511 			= 511,					--灵霄
	type_512 			= 512,					--避邪
	type_513 			= 513,					--流血
	type_514 			= 514,					--无敌
	type_515 			= 515,					--每次我方主动施放主动技能或神技后，所有侠客都会恢复其自身已损失血量xx%的气血
	type_516 			= 516,					--紊乱
	type_517 			= 517,					--玄素(自己)
	type_518 			= 518,					--玄素（目标）每次我方主动施放主动技能或神技后，对目标攻击
	type_519 			= 519,					--剑气
	type_520 			= 520,					--麻痹 同 昏睡
	type_521 			= 521,					--离间
	type_522 			= 522,					--混元功(自己)
	type_523 			= 523,					--混元功(队友)
	type_524 			= 524,					--吸星大法
	type_525 			= 525,					--吸星大法
}


--
EnumFightTriggerHurtType = {
	type_4 				= 4,					--道法自然张三丰
	type_12 			= 12,					--慕容龙城反击技能
	type_14 			= 14,					--攻击追加一次主动攻击
	type_15 			= 15,					--斗酒僧傀儡给斗酒僧加BUFF
	type_16 			= 16,					--被打追加一次反击
	type_17 			= 17,					--东邪 神技专用
	type_18 			= 18,					--香香公主 援护技能
	type_19 			= 19,					--攻击追加一次主动攻击
	type_20 			= 20,					--攻击结束触发类型
	type_21 			= 21,					--多个effect类型攻击
	type_22 			= 22,					--技能触发技能（无限循环）
	type_23 			= 23,					--当友方侠客被施加负面效果时，治疗该侠客并抵挡该负面状态
	type_24 			= 24,					--当我方侠客使用主动技能或杀意技能时，所有友方侠客都能恢复已损失气血的X%
	type_25 			= 25,					--回血 
}

--攻击effect 
EnumFightHurtEffect = {
	effect_1 			= 1,					--普通攻击
	effect_2 			= 2,					--暴击
	effect_3 			= 3,					--miss
	effect_4 			= 4,					--治疗
	effect_5 			= 5,					--净化
	effect_6 			= 6,					--乾坤挪移
	effect_7 			= 7,					--主动加buff
	effect_8 			= 8,					---额外的buff触发
	effect_9 			= 9,					--援护
	effect_10 			= 10,					--标记伤害
	effect_11 			= 11,					--复活
	effect_12 			= 12,					--西施主动技
	effect_13 			= 13,					--酒桶加血(召唤系技能ID)
	effect_14 			= 14,					--酒桶召唤
	effect_15 			= 15,					--金蛇 复活队友
	effect_16 			= 16,					--治疗加净化
	effect_100 			= 100,					--特殊值 方便客户端做动作不卡死 服务器战斗才会有
}

--技能类型对应的伤害effect
EnumFightSkill_HurtEffect = {
	[EnumFightSkillType.type_2] 	= EnumFightHurtEffect.effect_4,
	[EnumFightSkillType.type_3] 	= EnumFightHurtEffect.effect_5,
	[EnumFightSkillType.type_8] 	= EnumFightHurtEffect.effect_7,
	[EnumFightSkillType.type_10] 	= EnumFightHurtEffect.effect_11,
	[EnumFightSkillType.type_12] 	= EnumFightHurtEffect.effect_12,
	[EnumFightSkillType.type_13] 	= EnumFightHurtEffect.effect_13,
	[EnumFightSkillType.type_15] 	= EnumFightHurtEffect.effect_16,
}

--开场给已方队友上唯一BUFF 
EnumFightTeammateBuff = {
	[EnumFightBufferType.type_95] = EnumFightBufferType.type_96,
	[EnumFightBufferType.type_97] = EnumFightBufferType.type_98,
	[EnumFightBufferType.type_522] = EnumFightBufferType.type_523
}

--召唤物吸引敌方所有目标为单体的技能攻击
EnumFightSummonedSkillTargetType = {
	1,					--单体技能
	6,					--敌方血最少
	7,					--敌方防最少
	12,					--敌方防最高
	13,					--敌方内力最高
	14,					--敌方内力最少
	15,					--敌方武力最高
	16,					--敌方武力最少
	23,					--敌方身法最高
	24,					--敌方身法最少
}
--吸引敌方所有目标为群攻的技能攻击
EnumFightSkillTargetMostType = {
	2,					--全屏技能
	3,					--横排贯穿技能
	4,					--竖排穿刺技能
	5,					--敌方随机
	21,					--横排贯穿技能
	22,					--竖排穿刺技能
	25,					--正前方十字
}

EnumFightEnemyMapLift 	= {0,1,2,3,4,5,6,7,8}
EnumFightEnemyMapRight 	= {9,10,11,12,13,14,15,16,17}

--在敌方出手后攻击的BUFF *****有序遍历
EnumFightEnemyEndAttackBuff = 
{
	EnumFightBufferType.type_68,
	EnumFightBufferType.type_501,
	EnumFightBufferType.type_504
}
--主动技或神技时触发 false 代表打的不是自己人
EnumFightManualActionAttackBuff = 
{
	[EnumFightBufferType.type_518] = false
}

--阵容只能有一个buff
EnumFightTeamOnlyBuff = 
{
	EnumFightBufferType.type_521,
}

EnumFightHaloEffect = {
	-- [EnumFightSpellEffect.effect_76] = true
}

--endActionList 
EnumFightEndActionSortLevel = {
	level_1 = 1,
	level_Max = 1,
}
----deepHurt 伤害加深对应的特效
EnumFightDeepHurtEffectMap =
{
	[1] = "zhongdubaoji",
	[2] = "zhuoshaobaoji",
	[3] = "pozhanbaoji",
	[4] = "xuruobaoji",
	[5] = "zhongshangbaoji",
	[6] = "chihuanbaoji",
	[7] = "shimingbaoji",
	[10] = "hunluanbaoji",
	[11] = "sangongbaoji",
	[12] = "dianxunbaoji",
	[13] = "xuanyunbaoji",
	[15] = "hunshuibaoji",
	[16] = "diluobaoji",
	[34] = "suodingbaoji",
	[37] = "danqiebaoji",
	[50] = "liuxuebaoji"
}
----Active对应的特效
EnumFightActiveEffectMap =
{
	[1] = "xinu",
	[2] = "jiannu",
	[3] = "jianu",
	[4] = "xixue",
	[11] = "zhisi",
	[12] = "dianxunbaoji",
	[13] = "xuanyunbaoji",
	[14] = "zhongji",
	[26] = "zhimingyiji",
	[32] = "xixue",
	[58] = "xixue",
	[EnumFightActiveEffectType.effect_67] = "jianu_1"
}
EnumFightError =
{
	Error_A = "Error_A_[{p1}]--[{p2}]--[{p3}]"
}

--不需要怒气侠客
EnumFight_FreeRoleAnger ={}

----跳过战斗 此枚举HDk跟江湖不一样 true 显示跳过
EnumFightNeedQuicList =
{
	[EnumFightType.type_1] = true,
	[EnumFightType.HaoJie] = true,
	[EnumFightType.HuJia] = true,
	[EnumFightType.Kuang] = true,
	[EnumFightType.Adventure_Event] = true,
	[EnumFightType.RushChallenge] = true,
	[EnumFightType.Adventure_Massacre] = true,
	[EnumFightType.RankKing] = true,
	[EnumFightType.YanWu] = true,
	[EnumFightType.HeroConference] = true,
	[EnumFightType.HeroicBoss] = true,
	[EnumFightType.FYRecord] = true,
	[EnumFightType.KingOfWar] = true,
}
if (GameConfig.HD) then
	EnumFightNeedQuicList[EnumFightType.JapanIsland] = true
	EnumFightNeedQuicList[EnumFightType.Knight_32] = true
	EnumFightNeedQuicList[EnumFightType.Knight] = true
end
----暂停 此枚举HD跟江湖不一样
EnumFightNeedPauseList =
{
	[EnumFightType.WulingDaHui] = false,
	[EnumFightType.FactionFightShan] = false,
	[EnumFightType.Kuang] = false,
	[EnumFightType.HeroConference] = false,
	[EnumFightType.HeroicBoss] = false,
	[EnumFightType.FYRecord] = false,
}

--超过XX血量上限就回血
EnumFight_BackBloodEffect =
{
	[EnumFightPassiveEffectType.effect_39] = true,
	[EnumFightPassiveEffectType.effect_72] = true,
}
------特殊BUFF特效显示 章熙熙搞事情
--[[
	[buffrr的ID] = "特效资源名字"   此枚举HDk跟江湖不一样
]]
EnumFight_Buff_Res = {}
if (GameConfig.Old_Jian) then
	EnumFight_Buff_Res =
	{
		[34104] = "59_1",
		[34114] = "59_1",
		[34124] = "59_1",
		[33102] = "64_1",
		[33902] = "64_1",
		[34744] = "71_1",
		[34754] = "71_1",
		[34764] = "71_1",
		[34774] = "68_1",
		[34784] = "68_1",
		[34794] = "68_1",
		[32332] = "63",
		[31404] = "68_2",
		[31414] = "68_2",
		[31424] = "68_2",
		[33701] = "99_1",
		[33711] = "99_1",
		[33721] = "99_1",
		[33731] = "99_1",
	}
else
	EnumFight_Buff_Res =
	{
		[31404] = "68_1",
		[31414] = "68_1",
		[31424] = "68_1",
		[33102] = "64_1",
		[33902] = "64_1",
	}
end

EnumFight_Log =
{
	HP            	= "_HP.log",
	FightAct    	= "_Fight_data.log",
	FightOutAct 	= "_FightOut_data.log",
	BUFF          	= "-------BUFF.log",
	Battle          = "_Battle_data.log",
	Replay          = "_Replay_data.log",
	AutoTest        = "_AutoTest.log",
}