
--通过品质获得颜色 
function GetColorByQuality( quality )
	if quality == QUALITY_DING then	
		return ccc3(190,189,189)
	elseif quality == QUALITY_BING then
		return ccc3(27,212,53)
	elseif quality == QUALITY_YI then
		return ccc3(72,88,255)
	elseif quality == QUALITY_CHUANSHUO then
		return ccc3(231,138,6)
	elseif quality == QUALITY_JIA then
		return ccc3(189,10,228)	
	elseif quality >= QUALITY_SHENHUA then
	 	return ccc3(255,68,68)	
	elseif quality >= QUALITY_SHENHUA_7 then
	 	return ccc3(255,68,68)	
	end
	print("quality 不正确",quality)
	return ccc3(190,189,189)
end

QUALITY_SHENHUA_7 = 7
QUALITY_SHENHUA = 6
QUALITY_CHUANSHUO  = 5;
QUALITY_JIA  = 4;
QUALITY_YI 	 = 3;
QUALITY_BING = 2;
QUALITY_DING = 1;


--[[
QUALITY_STR = {}
QUALITY_STR[QUALITY_JIA] 	= "甲";
QUALITY_STR[QUALITY_YI] 	= "乙";
QUALITY_STR[QUALITY_BING] 	= "丙";
QUALITY_STR[QUALITY_DING]	= "丁";
]]
QUALITY_STR = localizable.QUALITY_STR

--通过品质获得颜色图标 (外框)
function GetColorKuangByQuality( quality )
	if quality == QUALITY_DING then	
		return "ui_new/array/js_baikuang_icon.png"
	elseif quality == QUALITY_BING then
		return "ui_new/array/js_lvkuang_icon.png"
	elseif quality == QUALITY_YI then
		return "ui_new/array/js_lankuang_icon.png"
	elseif quality == QUALITY_JIA then
		return "ui_new/array/js_zikuang_icon.png"
	elseif quality == QUALITY_SHENHUA then
		return "ui_new/array/js_hongkuang_icon.png"
	elseif quality == QUALITY_SHENHUA_7 then
		return "ui_new/array/js_hongkuang_icon.png"
	end
	
	print("quality 不正确",quality)
	return "ui_new/array/js_baikuang_icon.png" 
end


--通过品质获得颜色图标 (圆圈)
function GetColorRoadIconByQuality( quality )
	if quality == QUALITY_DING then	
		return "ui_new/array/js_shangzhenweibai_icon.png"
	elseif quality == QUALITY_BING then
		return "ui_new/array/js_shangzhenweilv_icon.png"
	elseif quality == QUALITY_YI then
		return "ui_new/array/js_shangzhenweilan_icon.png"
	elseif quality == QUALITY_JIA then
		return "ui_new/array/js_shangzhenweizi_icon.png"
	elseif quality == QUALITY_CHUANSHUO then
		return "ui_new/array/js_shangzhenweich_icon.png"
	elseif quality == QUALITY_SHENHUA then
		return "ui_new/array/js_shangzhenweihong_icon.png"
	elseif quality == QUALITY_SHENHUA_7 then
		return "ui_new/array/js_shangzhenweihong_icon.png"
	end
	print("quality 不正确",quality)
	return "ui_new/array/js_shangzhenweibai_icon.png"
end
function GetColorRoadIconByQualitySmall( quality )
    if quality == QUALITY_DING then 
        return "ui_new/common/gk_head_ding_bg.png"
    elseif quality == QUALITY_BING then
        return "ui_new/common/gk_head_bing_bg.png"
    elseif quality == QUALITY_YI then
        return "ui_new/common/gk_head_yi_bg.png"
    elseif quality == QUALITY_JIA then
        return "ui_new/common/gk_head_jia_bg.png"
	elseif quality == QUALITY_CHUANSHUO then
		return "ui_new/common/gk_head_ch_bg.png"
	elseif quality == QUALITY_SHENHUA then
		return "ui_new/common/gk_head_h_bg.png"
	elseif quality == QUALITY_SHENHUA_7 then
		return "ui_new/common/gk_head_h_bg.png"
    end
    print("quality 不正确",quality)
    return "ui_new/common/gk_head_jia_bg.png"
end

--通过品质获得颜色图标  124
function GetColorIconByQuality( quality )
	local basePath = "ui_new/common/icon_bg"
	if quality == QUALITY_DING then
		return basePath .. "/pz_bg_ding_124.png"
	elseif quality == QUALITY_BING then
		return basePath .. "/pz_bg_bing_124.png"
	elseif quality == QUALITY_YI then
		return basePath .. "/pz_bg_yi_124.png"
	elseif quality == QUALITY_JIA then
		return basePath .. "/pz_bg_jia_124.png"
	elseif quality == QUALITY_CHUANSHUO then
		return basePath .. "/cheng_124.png"
	elseif quality == QUALITY_SHENHUA then
		return basePath .. "/hong_124.png"
	elseif quality == QUALITY_SHENHUA_7 then
		return basePath .. "/hong_124.png"
	end
	print("quality 不正确",quality)
	return basePath .. "/pz_bg_ding_124.png"
end
--通过品质获得颜色图标  124
function GetColorIconByQuality_118( quality )
	local basePath = "ui_new/common/icon_bg"
	if quality == QUALITY_DING then
		return basePath .. "/pz_bg_ding_118.png"
	elseif quality == QUALITY_BING then
		return basePath .. "/pz_bg_bing_118.png"
	elseif quality == QUALITY_YI then
		return basePath .. "/pz_bg_yi_118.png"
	elseif quality == QUALITY_JIA then
		return basePath .. "/pz_bg_jia_118.png"
	elseif quality == QUALITY_CHUANSHUO then
		return basePath .. "/cheng_118.png"
	elseif quality == QUALITY_SHENHUA then
		return basePath .. "/hong_118.png"
	elseif quality == QUALITY_SHENHUA_7 then
		return basePath .. "/hong_118.png"
	end
	print("quality 不正确",quality)
	return basePath .. "/pz_bg_ding_118.png"
end
--通过品质获得颜色图标  82
function GetColorIconByQuality_82( quality )
	local basePath = "ui_new/common/icon_bg"
	if quality == QUALITY_DING then
		return basePath .. "/pz_bg_ding_82.png"
	elseif quality == QUALITY_BING then
		return basePath .. "/pz_bg_bing_82.png"
	elseif quality == QUALITY_YI then
		return basePath .. "/pz_bg_yi_82.png"
	elseif quality == QUALITY_JIA then
		return basePath .. "/pz_bg_jia_82.png"
	elseif quality == QUALITY_CHUANSHUO then
		return basePath .. "/cheng_82.png"
	elseif quality == QUALITY_SHENHUA then
		return basePath .. "/hong_82.png"
	elseif quality == QUALITY_SHENHUA_7 then
		return basePath .. "/hong_82.png"
	end
	print("quality 不正确",quality)
	return basePath .. "/pz_bg_ding_82.png"
end
--通过品质获得颜色图标  58
function GetColorIconByQuality_58( quality )
	local basePath = "ui_new/common"
	if quality == QUALITY_DING then
		return basePath .. "/58_baibiankuang_icon.png"
	elseif quality == QUALITY_BING then
		return basePath .. "/58_lvbiankuang_icon.png"
	elseif quality == QUALITY_YI then
		return basePath .. "/58_lanbiankuang_icon.png"
	elseif quality == QUALITY_JIA then
		return basePath .. "/58_zibiankuang_icon.png"
	elseif quality == QUALITY_CHUANSHUO then
		return basePath .. "/58_chengbiankuang_icon.png"
	elseif quality >= QUALITY_SHENHUA then
		return basePath .. "/58_hongbiankuang_icon.png"
	elseif quality >= QUALITY_SHENHUA_7 then
		return basePath .. "/58_hongbiankuang_icon.png"
	end
	print("quality 不正确",quality)
	return basePath .. "/58_baibiankuang_icon.png"
end
--获取默认图标背景图片路径
function GetDefaultIconBackground()
	return "ui_new/common/icon_bg/pz_bg_jia_124.png"
end

--获取默认图标图片路径(找不到图标或者图标缺失情况下使用)
function GetDefaultIcon()
	return "icon/notfound.png"
end

--通过品质获得碎片图标 
function GetBackgroundForFragmentByQuality( quality )
	local basePath = "ui_new/common/icon_bg"
	if quality == QUALITY_DING then
		return basePath .. "/pz_bg_ding_124.png"
	elseif quality == QUALITY_BING then
		return basePath .. "/pz_bg_bing_124.png"
	elseif quality == QUALITY_YI then
		return basePath .. "/pz_bg_yi_124.png"
	elseif quality == QUALITY_CHUANSHUO then
		return basePath .. "/cheng_124.png"
	elseif quality == QUALITY_JIA then
		return basePath .. "/pz_bg_jia_124.png"
	elseif quality >= QUALITY_SHENHUA then
		return basePath .. "/hong_124.png"
	elseif quality >= QUALITY_SHENHUA_7 then
		return basePath .. "/hong_124.png"
	end
	print("quality 不正确",quality)
end

--通过品质获得颜色图标 
function GetBackgroundForGoods( goodsData )
	return GetColorIconByQuality(goodsData.quality)
end

--通过品质获得品质字 
function GetFontByQuality( quality )
	if (quality == 7) then
		quality = 6
	end
	return "ui_new/common/role_p".. quality .. ".png"
	-- if quality == QUALITY_DING then	
	-- 	return "ui_new/common/ding.png"
	-- elseif quality == QUALITY_BING then
	-- 	return "ui_new/common/bing.png"
	-- elseif quality == QUALITY_YI then
	-- 	return "ui_new/common/yi.png"
	-- elseif quality >= QUALITY_JIA then
	-- 	return "ui_new/common/jia.png"
	-- end
	--print("quality 不正确",quality)
end

--通过品质获得布阵里面品质图片 
function GetArmyPicByQuality( quality )
	if (quality == 7) then
		quality = 6
	end
	return "ui_new/array/array_ps".. quality .. ".png"
end

function GetFontSmallByQuality( quality )
	if quality == QUALITY_DING then	
		return "ui_new/common/dingxiao.png"
	elseif quality == QUALITY_BING then
		return "ui_new/common/bingxiao.png"
	elseif quality == QUALITY_YI then
		return "ui_new/common/yixiao.png"
	elseif quality >= QUALITY_JIA then
		return "ui_new/common/jiaxiao.png"
	elseif quality >= QUALITY_SHENHUA then
		return "ui_new/common/jiaxiao.png"
	elseif quality >= QUALITY_SHENHUA_7 then
		return "ui_new/common/jiaxiao.png"
	end
	print("quality 不正确"..quality)
end
--通过属性系数获得属性颜色 
function GetCoefficientColorByNum( num )
	if num >= 0 and num < 0.5  then	
		return ccc3(255,255,255)
	elseif num >= 0.5 and num < 1 then
		return ccc3(0,255,0)
	elseif num >= 1 and num < 1.5 then
		return ccc3(0,0,255)
	elseif num >= 1.5 then
		return ccc3(153,50,205)
	end
	print("quality 不正确",quality)
end


function GetEquiptypeStrByType( equiptype )
	--[[
	if equiptype == 1 then
		return "武器"
	elseif equiptype == 2 then
		return "衣服"
	elseif equiptype == 3 then
		return "戒指"
	elseif equiptype == 4 then
		return "腰带"
	elseif equiptype == 5 then
		return "靴子"
	end
	print("equiptype 不正确",equiptype)
	]]
	return localizable.Equip_Des[equiptype]

end

--[[
字符串转换为table
@expression 表达式
@delim 分隔符
@return table,length
]]
function stringToTable(expression,delim)
	local tbl = {}

	if expression == nil or expression == 0 or expression == "0" or expression == "" then
		return tbl,0
	end

	delim = delim or '|'

	local temptbl = string.split(expression,delim)
	local i = 0
	for k,v in pairs(temptbl) do
		i = i + 1
		tbl[i] = v
	end

	return tbl,i
end

--[[
字符串转换为table
@expression 表达式
@delim 分隔符
@return table,length
]]
function stringToNumberTable(expression,delim)
	local tbl = {}

	if expression == nil or expression == 0 or expression == "0" or expression == "" then
		return tbl,0
	end

	delim = delim or '|'

	local temptbl = string.split(expression,delim)
	local i = 0
	for k,v in pairs(temptbl) do
		i = i + 1
		tbl[i] = tonumber(v)
	end

	return tbl,i
end


--通过字符串获得属性的table表
function GetAttrByString(str)
	local tbl = {}

	if str == nil or str == 0 or str == "0" or str == "" then
		return tbl
	end

	local temptbl = string.split(str,'|')			--分解"|"
	for k,v in pairs(temptbl) do
		local temp = string.split(v,'_')				--分解'_',集合为 key，vaule 2个元素
		if temp[1] and temp[2] then
			tbl[tonumber(temp[1])] = tonumber(temp[2])
			--print( temp[1] .. "tbl[temp[1]] = " .. tbl[temp[1]])
		end		
	end

	return tbl
end

--为了解决附加属性按照固定顺序显示添加
function GetAttrByStringForExtra(str)
	local tbl = {}
	local tbl2 = {}

	if str == nil or str == 0 or str == "0" or str == "" then
		return tbl,tbl2
	end

	local index = 1
	local temptbl = string.split(str,'|')			--分解"|"
	for k,v in pairs(temptbl) do
		local temp = string.split(v,'_')				--分解'_',集合为 key，vaule 2个元素
		if temp[1] and temp[2] then
			tbl[tonumber(temp[1])] = tonumber(temp[2])
			tbl2[index] = tonumber(temp[1])
			index = index + 1
		end
	end
	tbl = tbl or {};
	tbl2 = tbl2 or {};
	return tbl,tbl2
end

--[[
战斗力 = 生命*0.1 + (其他所有属性总和)*0.5
]]
function GetPowerByAttribute( attribute )
	local value = attribute[1]
	local result = 0
	if value then
		result = value * 0.1
	end

	for i = 2,15 do
		value = attribute[i]
		if value then
			result = result + value * 0.5
		end
	end

	power = math.floor(result)
	return power
end

--[[
装备战斗力计算 =（生命*0.1 + 武力 * 0.5+ 内力*0.5+ 身法*0.5 +防御*0.5 + 冰伤*0.5 + 毒伤*0.5+ 火伤*0.5+冰抗 *0.5+ 火抗*0.5+ 毒抗*0.5 +命中*0.5+闪避*0.5 +暴击*0.5+抗暴.5）*（1+武力%+内力%+身法%+防御%+气血%）
]]
function CalculateEquipPower( attribute )
	local value = attribute[1]
	local result = 0
	if value then
		result = value * 0.1
	end

	for i = 2,15 do
		value = attribute[i]
		if value then
			result = result + value * 0.5
		end
	end

	local mutil = 1.00
	for i = 18,28 do
		value = attribute[i]
		if value then
			mutil = mutil + value / 10000
		end
	end
	result = result * mutil
	power = math.floor(result)
	return power
end

--[[
装备战斗力计算 =（生命*0.1 + 武力 * 0.5+ 内力*0.5+ 身法*0.5 +防御*0.5 + 冰伤*0.5 + 毒伤*0.5+ 火伤*0.5+冰抗 *0.5+ 火抗*0.5+ 毒抗*0.5 +命中*0.5+闪避*0.5 +暴击*0.5+抗暴.5）*（1+武力%+内力%+身法%+防御%+气血%）
]]
function CalculateGemPower(idx,val)
	if idx == 1 then
		return math.floor(val * 0.1)
	elseif idx < 16 then
		return math.floor(val * 0.5)
	else
		return 0
	end
end

function GetCoinIcon()
	return "ui_new/common/qhp_tb_icon.png"
end

function GetSyceeIcon()
	return "ui_new/common/qhp_yb_icon.png"
end

function GetVitalityIcon()
	return "ui_new/common/qhp_tb_icon.png"
end
function GetHuiXinCoinIcon()
	return "ui_new/shixintai/icon_hxb.png"
end
function GetZhuXinCoinIcon()
	return "ui_new/shixintai/icon_zxb.png"
end
function GetWeiWangCoinIcon()
	return "ui_new/hero/icon_wwz.png"
end
function GetJingPoCoinIcon()
	return "ui_new/common/icon_jingpo3.png"
end
--[[
获取品质背景品质图标
]]
function GetResourceQualityBG(resType)
	local basePath = "ui_new/common/icon_bg"
	if resType == EnumDropType.COIN then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.SYCEE then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.GENUINE_QI then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.EXP then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.ROLE_EXP then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.HERO_SCORE then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.CLIMBSTAR then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.YUELI then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.SHALU_VALUE then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.TEMP_COIN then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.TEMP_YUELI then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.LOWHONOR then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.HIGHTHONOR then
		return basePath .. "/cheng_124.png"
	elseif resType == EnumDropType.TIANXIANG_COIN then
		return basePath .. "/pz_bg_jia_124.png"
	elseif resType == EnumDropType.TIANJI_COIN then
		return basePath .. "/cheng_124.png"
	elseif resType == EnumDropType.RECHARGE_TICKET then
		return basePath .. "/cheng_124.png"
	elseif resType == EnumDropType.WEIWANG then
		return basePath .. "/cheng_124.png"
	elseif resType == EnumDropType.FengYunLing then
		return basePath .. "/pz_bg_jia_124.png"
	end
	print("Not Define : ",resType)
	return basePath .. "/pz_bg_jia_124.png"
end

function GetResourceQualityBG82(resType)
	local basePath = "ui_new/common/icon_bg"
	if resType == EnumDropType.COIN then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.SYCEE then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.GENUINE_QI then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.EXP then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.ROLE_EXP then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.HERO_SCORE then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.CLIMBSTAR then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.YUELI then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.SHALU_VALUE then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.TEMP_COIN then
		return basePath .. "/pz_bg_jia_82.png"
	elseif resType == EnumDropType.TEMP_YUELI then
		return basePath .. "/pz_bg_jia_82.png"
	end
	print("Not Define : ",resType)
	return basePath .. "/pz_bg_jia_82.png"
end

function GetResourceQuality(resType)
	if resType == EnumDropType.COIN then
		return QualityType.Jia
	elseif resType == EnumDropType.SYCEE then
		return QualityType.Jia
	elseif resType == EnumDropType.GENUINE_QI then
		return QualityType.Jia
	elseif resType == EnumDropType.EXP then
		return QualityType.Jia
	elseif resType == EnumDropType.ROLE_EXP then
		return QualityType.Jia
	elseif resType == EnumDropType.HERO_SCORE then
		return QualityType.Jia
	elseif resType == EnumDropType.CLIMBSTAR then
		return QualityType.Jia
	end
	print("Not Define : ",resType)
	return QualityType.Jia
end

--[[
	获取资源图标，这里的资源指的是玩家数值数据，例如铜币、元宝、悟性点等
]]
function GetResourceIcon(resType)
	if resType == EnumDropType.COIN then
		return "ui_new/common/icon_coin.png"
	elseif resType == EnumDropType.SYCEE then
		return "ui_new/common/icon_sycee.png"
	elseif resType == EnumDropType.GENUINE_QI then
		return "ui_new/common/xx_xingliandian_icon.png"
	elseif resType == EnumDropType.EXP then
		return "ui_new/common/icon_exp.png"
	elseif resType == EnumDropType.ROLE_EXP then
		return "ui_new/common/icon_exp.png"
	elseif resType == EnumDropType.HERO_SCORE then
		return "ui_new/spectrum/qh_jifenda_icon.png"

	-- vip积分
	elseif resType == EnumDropType.VIP_SCORE then
		return "ui_new/common/icon_vip.png"
	elseif resType == EnumDropType.XIAYI then
		return "ui_new/common/icon_xiayi.png"
	elseif resType == EnumDropType.FACTION_GX then
		return "ui_new/faction/icon_gongxian.png"
	elseif resType == EnumDropType.VESSELBREACH then
		return "ui_new/climb/wl_jinglu_s.png"
	elseif resType == EnumDropType.CLIMBSTAR then
		return "ui_new/climb/wl_xingxing.png"
	elseif resType == EnumDropType.YUELI then
		return "ui_new/tianshu/img_yueli.png"
	elseif resType == EnumDropType.SHALU_VALUE then
		return "ui_new/youli/skillscore.png"
	elseif resType == EnumDropType.TEMP_COIN then
		return "ui_new/common/icon_coin.png"
	elseif resType == EnumDropType.TEMP_YUELI then
		return "ui_new/tianshu/img_yueli.png"
	elseif resType == EnumDropType.LOWHONOR then
		return "ui_new/wulin/icon_ryl4.png"
	elseif resType == EnumDropType.HIGHTHONOR then
		return "ui_new/wulin/icon_ryl3.png"
	elseif resType == EnumDropType.PEAK_SCORE then
		return "ui_new/lunjian/img_score_s.png"
	elseif resType == EnumDropType.TIANXIANG_COIN then
		return "ui_new/climb/icon_txb.png"
	elseif resType == EnumDropType.TIANJI_COIN then
		return "ui_new/climb/icon_tjb.png"
	elseif resType == HeadResType.ZHUXIN then
		return "ui_new/common/icon_zxb.png"
	elseif resType == HeadResType.HUIXIN then
		return "ui_new/common/icon_hxb.png"
	elseif resType == HeadResType.VIPJF then
		return "ui_new/pay/img_gbjf.png"
	elseif resType == HeadResType.HERO then
		return "ui_new/common/icon_yxl.png"
	elseif resType == HeadResType.WEIWANG then
		return "ui_new/common/icon_wwz.png"
	elseif resType == HeadResType.SPECIAL_QI then
		return "ui_new/qiyu/jisi/img_lq.png"
	elseif resType == HeadResType.JINGPO then
		return "ui_new/common/icon_jingpo1.png"
	elseif resType == HeadResType.FengYunLing then
		return "ui_new/fengyunlu/icon_fyl.png"
	end

	
	print("没有这个资源类型的图片 : ",resType)
	return GetDefaultIcon()
end

function GetResourceName(resType)
	--[[
	if resType == EnumDropType.COIN then
		return "铜币"
	elseif resType == EnumDropType.SYCEE then
		return "元宝"
	elseif resType == EnumDropType.GENUINE_QI then
		return "悟性点"
	elseif resType == EnumDropType.EXP then
		return "团队经验"
	elseif resType == EnumDropType.LEVEL then
		return "团队等级"
	elseif resType == EnumDropType.ROLE_EXP then
		return "角色经验"
	elseif resType == EnumDropType.XIAYI then
		return "侠义值"
	elseif resType == EnumDropType.HERO_SCORE then
		return "群豪谱积分"
	elseif resType == EnumDropType.FACTION_GX then
		return "个人贡献"
	elseif resType == EnumDropType.CLIMBSTAR then
		return "八卦精元"
	elseif resType == EnumDropType.LOWHONOR then
		return "虎令"
	elseif resType == EnumDropType.HIGHTHONOR then
		return "龙令"
	end
	print("resType not found : ",resType)
	return "未知"
	]]
	return localizable.ResourceName[resType]
end

function GetPlayerRoleList()
	local list = {77,78,79,80}
	return list
end

function IsPlayerRole(id)
	local list = {77,78,79,80}
	for i=1,4 do
		if list[i] == id then
			return true
		end
	end
	return false
end

function GetServerTime()
	if MainPlayer == nil then
		return os.time()
	end
	return MainPlayer:getNowtime()
end

function GetGameTime()
	return GetServerTime()
end

function timestampTodata( str )
	local tbl = {}
	tbl.year , tbl.month , tbl.day , tbl.hour , tbl.min ,tbl.sec = string.match(str,"(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)")
	local data = GetCorrectTime(tbl)
	return data
end

function GetGrowNumByKind( kind ,level)
	if kind == EnumAttributeType.Force then
		return math.floor(level/20)+1
	elseif kind == EnumAttributeType.Defence then
		return math.floor(level/20)+1
	elseif kind == EnumAttributeType.Magic then
		return math.floor(level/20)+1
	elseif kind == EnumAttributeType.Blood then
		return math.floor(level/8)+3
	elseif kind == EnumAttributeType.Agility then
		return math.floor(level/20)+1
	end
end

--计算装备成长值
function GetTotalGrowNumByKind( kind ,level)
	if kind == EnumAttributeType.Force then
		--local num = level * 1 + math.floor(level/20)*level-(math.floor(level/20)*20+math.floor(level/20)*(math.floor(level/20)-1)*10)
		--return num
		return level * 7;
	elseif kind == EnumAttributeType.Defence then
		--local num = level * 1 + math.floor(level/20)*level-(math.floor(level/20)*20+math.floor(level/20)*(math.floor(level/20)-1)*10)
		--return num
		return level * 7;
	elseif kind == EnumAttributeType.Magic then
		--local num = level * 1 + math.floor(level/20)*level-(math.floor(level/20)*20+math.floor(level/20)*(math.floor(level/20)-1)*10)
		--return num
		return level * 7;
	elseif kind == EnumAttributeType.Blood then
		--local num = level * 3 + math.floor(level/8)*level-(math.floor(level/8)*8+math.floor(level/8)*(math.floor(level/8)-1)*4)
		--return num
		return level * 35;
	elseif kind == EnumAttributeType.Agility then
		--local num = level * 1 + math.floor(level/20)*level-(math.floor(level/20)*20+math.floor(level/20)*(math.floor(level/20)-1)*10)
		--return num
		return level * 7;
	end
end

--[[
判断属性是否为百分比属性
]]
function isPercentAttr(index)
	if index > 15 and index < 29 then
		return true
	elseif index >= 40 and index <= 45 then
		return true
	elseif index == 105 then
		return true
	elseif index == EnumAttributeType.CritAdditionPercent or index == EnumAttributeType.CritSubitionPercent then
		return true
	end
	return false
end

--[[
转换为百分比数值，用于显示。例如：830，应该显示为83%
]]
function covertToPercentNotZero(value,ratio)
	local str 		= value
	local str1 		= string.format("%.1f",value / 10)
	local strList 	= string.split(str1, ".")
	str 			= strList[1]
	if (strList[2]) then
		local tempStr = tostring(strList[2])
		local pos = string.len( tempStr )
		for i=string.len( tempStr ), 1, -1 do
			if (tonumber(string.sub(tempStr, i )) ~= 0) then
				pos = i
				print(i," ",string.sub(tempStr, 1, (i) ))
				str = str .. ".".. string.sub(tempStr, 1, i)
				break
			end
		end
	end
	str = str .. '%'
	return str
end
--[[
转换为百分比数值，用于显示。例如：834，应该显示为8.34%
]]
function covertToPercentValue(index,value,bAbs)
	local percentValue = value
	if bAbs == true then
	 	percentValue = math.abs(value)/100 .. '%'
	else
		percentValue = string.format("%.2f",value / 100) .. '%'
	end
	return percentValue
end
--[[
转换为显示格式，主要是将百分比属性，转换为百分比数值，用于显示。例如：834，应该显示为8.34%
]]
function covertToDisplayValue(index,value,bAbs)
	if isPercentAttr(index) then
		return covertToPercentValue(index,value,bAbs)
	end
	if bAbs == true then
		return math.abs(value)
	end
	return value
end

--[[
转换为显示格式，主要是将百分比属性，去除最后的零。例如：8300，返回83
]]
function covertToDisplayZeroValue(index,value)
	local tempValue = math.abs(value)
	local factor 	= 100
	if isPercentAttr(index) then
		local str 		= tostring(value)
		local len 		= string.len(str)
		local idx 		= 0
		local tempStr   = ""
		for i = len, len - 1, -1 do

			if (str[i] ~= "0") then
				tempStr = string.sub(str, 1, i)
				break
			else
				idx 	= i - 1
				factor 	= (factor / 10)
			end
		end
		if (factor == 1) then
			tempStr = string.sub(str, 1, idx)
		end
		tempValue = tonumber(tempStr) or 0
	end
	return (tempValue / factor)
end

--[[
	获取资源图标，这里的资源指的是玩家数值数据，例如铜币、元宝、悟性点等
]]
function GetResourceIconForGeneralHead(resType, resId)
	if (not resId and resId == HeadResType.RESID1 or resId == HeadResType.RESID2) then
		return "ui_new/youli/icon_cy6.png"
	end
	if resType == HeadResType.COIN then
		return "ui_new/common/icon_coin.png"
	elseif resType == HeadResType.SYCEE then
		return "ui_new/common/icon_sycee.png"
	elseif resType == HeadResType.GENUINE_QI then
		return "ui_new/common/xx_xingliandian_icon.png"
	elseif resType == HeadResType.EXP then
		return "ui_new/common/xx_xingliandian_icon.png"
	elseif resType == HeadResType.ROLE_EXP then
		return "icon/notfound.png"
	elseif resType == HeadResType.HERO_SCORE then
		return "ui_new/spectrum/qh_jifenda_icon.png"
	elseif resType == HeadResType.PUSH_MAP then
		return "ui_new/common/img_tili.png"
	elseif resType == HeadResType.QUNHAO then
		return "ui_new/spectrum/qh_tiaozhancishu_icon.png"
	elseif resType == HeadResType.CLIMB then
		return "ui_new/climb/wls_stone.png"
	elseif resType == HeadResType.SKILL_POINT then
		return "ui_new/skilltree/skill_point_icon.png"	

	-- vip积分
	-- elseif resType == EnumDropType.VIP_SCORE then
	-- 	return "ui_new/common/icon_vip.png"
	-- 侠义
	elseif resType == HeadResType.XIAYI then
		return "ui_new/common/icon_xiayi.png"
	elseif resType == HeadResType.FACTION_GX then
		return "ui_new/faction/icon_gongxian.png"
		
	-- 抽卡积分
	elseif resType == HeadResType.RECRUITINTEGRAL then
		return "ui_new/common/lianchoujifen_s.png"

	-- 无量山钻
	elseif resType == HeadResType.CLIMBDIAMOD then
		return "ui_new/climb/icon_wlsz.png"
	--劫矿令
	elseif resType == HeadResType.JIEKUANGLING then
		return "ui_new/mining/icon_jkl.png"
	elseif resType == HeadResType.CLIMBSTAR then
		return "ui_new/climb/wl_xingxing.png"
	--阅历(天书)
	elseif resType == HeadResType.YUELI then
		return "ui_new/tianshu/img_yueli.png"
	--游历-包子
	elseif resType == HeadResType.BAOZI then
		return "ui_new/youli/icon_baozi.png"
	--珍本残页
	elseif resType == HeadResType.ZHENBCY then
		return "ui_new/youli/icon_cy1.png"
	--善本残页
	elseif resType == HeadResType.SHANBCY then
		return "ui_new/youli/icon_cy2.png"
	--全本残页
	elseif resType == HeadResType.QUANBCY then
		return "ui_new/youli/icon_cy3.png"
	--抄本残页
	elseif resType == HeadResType.CHAOBCY then
		return "ui_new/youli/icon_cy4.png"
	--残本残页
	elseif resType == HeadResType.CANBCY then
		return "ui_new/youli/icon_cy5.png"
	--低阶荣誉令牌
	elseif resType == HeadResType.LOWHONOR then
		return "ui_new/wulin/icon_ryl4.png"
	--告诫荣誉令牌
	elseif resType == HeadResType.HIGHTHONOR then
		return "ui_new/wulin/icon_ryl3.png"
	elseif resType == HeadResType.LIULI then
	-- 潜修琉璃子
		return "ui_new/common/icon_liuli.png"
	elseif resType == HeadResType.SELIZI then
	-- 潜修舍利子
		return "ui_new/common/icon_selizi.png"
	elseif resType == HeadResType.KUNLUNYU then
		return "ui_new/longmenpo/img_kly.png"
	elseif resType == HeadResType.XIHUANGDIE then
		return "ui_new/longmenpo/img_xhd.png"
	--论剑峰挑战次数
	elseif resType == HeadResType.PEAK then
		return "ui_new/wulin/icon_ryl3.png"
	--西岭挑战次数
	elseif resType == HeadResType.XILINGSTONE then
		return "ui_new/climb/img_emengstone.png"
	elseif resType == HeadResType.TIANXIANG then
		return "ui_new/climb/icon_txb.png"
	elseif resType == HeadResType.TIANJI then
		return "ui_new/climb/icon_tjb.png"

	elseif resType == HeadResType.CHUANGZHEN then
		return "ui_new/climb/icon_tjb.png"
	elseif resType == HeadResType.CAN_WU_RANK_4 then
		return "ui_new/tianshu/canwu/icon_zi.png"
	elseif resType == HeadResType.CAN_WU_RANK_5 then
		return "ui_new/tianshu/canwu/icon_cheng.png"
	--周年庆天书残页
	elseif resType == HeadResType.ZNQBCY then
		return "ui_new/youli/icon_cyznq.png"
	--珠心币
	elseif resType == HeadResType.ZHUXIN then
		return "ui_new/common/icon_zxb.png"
	--慧心币
	elseif resType == HeadResType.HUIXIN then
		return "ui_new/common/icon_hxb.png"
	--vip商城积分
	elseif resType == HeadResType.VIPJF then
		return "ui_new/pay/img_gbjf.png"
	elseif resType == HeadResType.WEIWANG then
		return "ui_new/common/icon_wwz.png"
	elseif resType == HeadResType.HERO then
		return "ui_new/common/icon_yxl.png"
	--灵气
	elseif resType == HeadResType.SPECIAL_QI then
		return "ui_new/qiyu/jisi/img_lq2.png"
	--精魄
	elseif resType == HeadResType.JINGPO then
		return "ui_new/common/icon_jingpo2.png"
	-- 风云令
	elseif resType == HeadResType.FengYunLing then
		return "ui_new/fengyunlu/icon_fyl_m.png"
	end
	
	print("没有这个资源类型的图片 : ",resType)
	return GetDefaultIcon()
end

function GetResourceNameForGeneralHead(resType)
	return localizable.ResourceNameForGeneralHead[resType]
end

--[[
	通过资源类型获取资源数值
]]
function getResValueByTypeForGH(resType)
	if resType == HeadResType.COIN then
		return MainPlayer.coin
	elseif resType == HeadResType.SYCEE then
		return MainPlayer.sycee
	elseif resType == HeadResType.GENUINE_QI then
		return MainPlayer.genuine_qi
	elseif resType == HeadResType.EXP then
		return MainPlayer.curExp
	elseif resType == HeadResType.XIAYI then
		return MainPlayer.errantry
	elseif resType == HeadResType.HERO_SCORE then
		return MainPlayer.qunHaoScore
	elseif resType == HeadResType.PUSH_MAP then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.PUSH_MAP)
		return challengeInfo:getLeftChallengeTimes() .. "/" .. challengeInfo.maxValue; 
	elseif resType == HeadResType.QUNHAO then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.QUNHAO)
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.CLIMB then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.CLIMB)
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.SKILL_POINT then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.SKILL_POINT)
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.FACTION_GX then
		return MainPlayer.dedication

	elseif resType == HeadResType.CLIMBDIAMOD then
		return NorthClimbManager.northDiamod
		
	elseif resType == HeadResType.RECRUITINTEGRAL then
		return MainPlayer.recruitIntegral
	elseif resType == HeadResType.CLIMBSTAR then
		return MainPlayer.climbStar

	elseif resType == HeadResType.JIEKUANGLING then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.MINE)
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.BAOZI then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.BAOZI)
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.YUELI then
		return MainPlayer:getYueliValue()
	--珍本残页
	elseif resType == HeadResType.ZHENBCY then
		return BagManager:getItemNumById(30099)
	--善本残页
	elseif resType == HeadResType.SHANBCY then
		return BagManager:getItemNumById(30098)
	--全本残页
	elseif resType == HeadResType.QUANBCY then
		return BagManager:getItemNumById(30097)
	--抄本残页
	elseif resType == HeadResType.CHAOBCY then
		return BagManager:getItemNumById(30096)
	--残本残页
	elseif resType == HeadResType.CANBCY then
		return BagManager:getItemNumById(30095)
	--低阶荣誉令牌
	elseif resType == HeadResType.LOWHONOR then
		return MainPlayer.lowHonor or 0
	--高阶荣誉令牌
	elseif resType == HeadResType.HIGHTHONOR then
		return MainPlayer.seniorHonor or 0
	elseif resType == HeadResType.LIULI then
		return BagManager:getItemNumById(30286)
	elseif resType == HeadResType.SELIZI then
		return BagManager:getItemNumById(30125)
	elseif resType == HeadResType.KUNLUNYU then
		return BagManager:getItemNumById(30133)
	elseif resType == HeadResType.XIHUANGDIE then
		return BagManager:getItemNumById(30134)
	elseif resType == HeadResType.PEAK then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.PEAK)
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.XILINGSTONE then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.XILING)
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.TIANXIANG then
		return MainPlayer:getTianxiangCoin() or 0
	elseif resType == HeadResType.TIANJI then
		return MainPlayer:getTianjiCoin() or 0
	elseif resType == HeadResType.CAN_WU_RANK_4 then
		--参悟丹
		return BagManager:getItemNumById(30237)
	elseif resType == HeadResType.CAN_WU_RANK_5 then
		--参悟丹
		return BagManager:getItemNumById(30238)
	elseif resType == HeadResType.CHUANGZHEN then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.CHUANGZHEN)
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.HUIXIN then
		return MainPlayer.huixinCoin
	elseif resType == HeadResType.ZHUXIN then
		return MainPlayer.zhuxinCoin
	elseif resType == HeadResType.HERO then
		local challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.HERO)
		if (challengeInfo == nil) then
			return 0
		end
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.WEIWANG then
		return MainPlayer.weiwang
	elseif resType == HeadResType.SPECIAL_QI then
		challengeInfo = MainPlayer:GetChallengeTimesInfo(EnumRecoverableResType.SPECIAL_QI)
		if (challengeInfo == nil) then
			return 0
		end
		return challengeInfo:getLeftChallengeTimes()
	elseif resType == HeadResType.JINGPO then
		return MainPlayer.JINGPO
	elseif resType == HeadResType.FengYunLing then
		return MainPlayer.FengYunLing
	end
	print("unknow res type : ",resType)
	return 0
end

--[[
	通过资源类型获取资源数值的表达式，显示样式，会根据数值范围自动转换成特定表达式，例如：10000000返回为1000w
]]
function getResValueExpressionByTypeForGH(resType)
	local value = getResValueByTypeForGH(resType)
	if value and type(value) == "number" and value > 1000000 then
		local fuck  = value/10000
		local floatValue = string.format("%.0f",fuck)
		--return floatValue .."万"
		floatValue = stringUtils.format(localizable.fun_wan_desc,floatValue)
		return floatValue
	else 
		return value
	end
end

--判断资源是否可以购买
function canBuyResource(resType)
	if resType == HeadResType.COIN then
		return true
	elseif resType == HeadResType.SYCEE then
		return true
	elseif resType == HeadResType.PUSH_MAP then
		return true
	elseif resType == HeadResType.QUNHAO then
		return true
	elseif resType == HeadResType.CLIMB then
		return true  --界面逻辑优化建议 2015/10/10
	elseif resType == HeadResType.SKILL_POINT then
		return true
		
	elseif resType == HeadResType.JIEKUANGLING then
		return true
	elseif resType == HeadResType.BAOZI then
		return true
	elseif resType == HeadResType.KUNLUNYU then
		return true
	elseif resType == HeadResType.XIHUANGDIE then
		return true
	elseif resType == HeadResType.PEAK then
		return true
	elseif resType == HeadResType.XILINGSTONE then
		return true
	elseif resType == HeadResType.XIAYI then
		return true
	elseif resType == HeadResType.HERO then
		return true
	elseif resType == HeadResType.SPECIAL_QI then
		return true
	end
	return false
end

--[[
获取IOS系统tokens
]]
function getIOSDeviceTokens()
	return CCApplication:sharedApplication():getDeviceTokenID()
end

--[[
将table转换为字符串
]]
function sz_T2S(_t)  
    local szRet = "{"  
    function doT2S(_i, _v)  
        if "number" == type(_i) then  
            szRet = szRet .. "[" .. _i .. "] = "  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. sz_T2S(_v) .. ","  
            else  
                szRet = szRet .. "nil,"  
            end  
        elseif "string" == type(_i) then  
            szRet = szRet .. '["' .. _i .. '"] = '  
            if "number" == type(_v) then  
                szRet = szRet .. _v .. ","  
            elseif "string" == type(_v) then  
                szRet = szRet .. '"' .. _v .. '"' .. ","  
            elseif "table" == type(_v) then  
                szRet = szRet .. sz_T2S(_v) .. ","  
            else  
                szRet = szRet .. "nil,"  
            end  
        end  
    end  
    table.foreach(_t, doT2S)  
    szRet = szRet .. "}"  
    return szRet  
end

--function url_encode(str)
--  	if (str) then
--  	  	str = string.gsub (str, "\n", "\r\n")
--  	  	str = string.gsub (str, "([^%w ])",
--  	  	    function (c) return string.format ("%%%02X", string.byte(c)) end)
--  	  	      	str = string.gsub (str, " ", "+")
--  	  	    end
--  	return str    
--end

--function url_decode(str)
--  	str = string.gsub (str, "+", " ")
--  	str = string.gsub (str, "%%(%x%x)",
--  	    function(h) return string.char(tonumber(h,16)) end)
--  	str = string.gsub (str, "\r\n", "\n")
--  	return str
--end

--[[
日期格式转换函数
]]
-- Compatibility: Lua-5.1
function split(str, pat)
   	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   	local fpat = "(.-)" .. pat
    local last_end = 1   
    local s, e, cap = str:find(fpat, 1)   
    while s do      
    	if s ~= 1 or cap ~= "" then
    	    table.insert(t,cap)
    	end      
    	last_end = e+1      
    	s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
      	cap = str:sub(last_end)
      	table.insert(t, cap)
    end
    return t
end


---- 通过日期获取秒 yyyy-MM-dd HH:mm:ss
function getTimeByDate(expression,correct)
    local a = split(expression, " ")
    local b = split(a[1], "-")
    local c = split(a[2], ":")
    local t = os.time({year=b[1],month=b[2],day=b[3], hour=c[1], min=c[2], sec=c[3]})-- time correct
    if correct ~= false then
    	t = t - getTimeAreaDifSec()
    end
    return t
end

function getTimeAreaDifSec() -- time correct
	local tTimeZero = os.date("*t", 0)
	local timeArea = tTimeZero.hour
	local timeAreaMin = tTimeZero.min
	if tTimeZero.year < 1970 then
		timeArea = timeArea - 24
	end
	-- if timeArea > 12 then
	-- 	timeArea = timeArea - 24
	-- end
	local _timeArea = 8
	local _timeDifference = (_timeArea - timeArea)*3600 - timeAreaMin * 60
	return _timeDifference
end

---- 通过日期获取秒 yyyy-MM-dd HH:mm:ss
function getDateByString(expression)
    local a = split(expression, " ")
    local b = split(a[1], "-")
    local c = split(a[2], ":")
    return {year=b[1],month=b[2],day=b[3], hour=c[1], min=c[2], sec=c[3]}
end

function GetCorrectDate(format,sec)-- time correct
	-- print("sec1 = ",sec)
	sec = sec + getTimeAreaDifSec()
	sec = math.max(0,sec)
	-- print("sec2 = ",sec)
	return os.date(format,sec)
end

function GetCorrectTime(format)-- time correct
	if format == nil then
		return GetGameTime()
	end
	return os.time(format) - getTimeAreaDifSec()
end

function getBookBackgroud(quality)
    local bgPic    = "ui_new/role/bg_book_empty.png"
    if quality == 5 then
        bgPic    = "ui_new/role/bg_book_cheng.png"
    elseif quality == 4 then
        bgPic    = "ui_new/role/bg_book_jia.png"
    elseif quality == 3 then
        bgPic    = "ui_new/role/bg_book_yi.png"
    elseif quality == 2 then
        bgPic    = "ui_new/role/bg_book_bing.png"
    elseif quality == 1 then
        bgPic    = "ui_new/role/bg_book_ding.png"
    end

    return bgPic
end

--通过武学等级获取背景
function GetRoleBgByWuXueLevel( level )
	local bgIndex = EnumWuxueBGType[level]

	-- return GetColorIconByQuality(bgIndex)

	if level == 1 then	
		return "ui_new/array/js_baikuang_icon.png"
	elseif level == 2 then
		return "ui_new/array/js_lvkuang_icon.png"
	elseif level == 3 then
		return "ui_new/array/js_lvkuang2_icon.png"
	elseif level == 4 then
		return "ui_new/array/js_lankuang_icon.png"
	elseif level == 5 then
		return "ui_new/array/js_lankuang2_icon.png"
	elseif level == 6 then
		return "ui_new/array/js_lankuang3_icon.png"
	elseif level == 7 then
		return "ui_new/array/js_zikuang_icon.png"
	elseif level == 8 then
		return "ui_new/array/js_zikuang2_icon.png"
	elseif level == 9 then
		return "ui_new/array/js_zikuang3_icon.png"
	end

	print("level 不正确", level)
	
	return "ui_new/array/js_baikuang_icon.png"

end


function GetRoleBgByWuXueLevel_circle( level )
	local bgIndex = EnumWuxueBGType[level]

	-- return GetColorRoadIconByQuality(bgIndex)


	if level == 1 then	
		return "ui_new/array/js_shangzhenweibai_icon.png"
	elseif level == 2 then
		return "ui_new/array/js_shangzhenweilv_icon.png"
	elseif level == 3 then
		return "ui_new/array/js_shangzhenweilv2_icon.png"
	elseif level == 4 then
		return "ui_new/array/js_shangzhenweilan_icon.png"
	elseif level == 5 then
		return "ui_new/array/js_shangzhenweilan2_icon.png"
	elseif level == 6 then
		return "ui_new/array/js_shangzhenweilan3_icon.png"
	elseif level == 7 then
		return "ui_new/array/js_shangzhenweizi_icon.png"
	elseif level == 8 then
		return "ui_new/array/js_shangzhenweizi2_icon.png"
	elseif level == 9 then
		return "ui_new/array/js_shangzhenweizi3_icon.png"
	end

	print("level 不正确", level)
	
	return "ui_new/array/js_shangzhenweibai_icon.png"

end

function GetRoleBgByWuXueLevel_circle_small( level )

	-- return GetColorRoadIconByQualitySmall(bgIndex)
	if level == 1 then	
		return "ui_new/common/gk_head_ding_bg.png"
	elseif level == 2 then
		return "ui_new/common/gk_head_bing_bg.png"
	elseif level == 3 then
		return "ui_new/common/gk_head_bing2_bg.png"
	elseif level == 4 then
		return "ui_new/common/gk_head_yi_bg.png"
	elseif level == 5 then
		return "ui_new/common/gk_head_yi2_bg.png"
	elseif level == 6 then
		return "ui_new/common/gk_head_yi3_bg.png"
	elseif level == 7 then
		return "ui_new/common/gk_head_jia_bg.png"
	elseif level == 8 then
		return "ui_new/common/gk_head_jia2_bg.png"
	elseif level == 9 then
		return "ui_new/common/gk_head_jia3_bg.png"
	end

	print("level 不正确", level)
	
	return "ui_new/common/gk_head_ding_bg.png"
end

function GetFightRoleBgByWuXueLevel( level )

	-- return GetColorRoadIconByQualitySmall(bgIndex)
	if level == 1 then	
		return "ui_new/fight/roleBg1.png"
	elseif level == 2 then
		return "ui_new/fight/roleBg2.png"
	elseif level == 3 then
		return "ui_new/fight/roleBg3.png"
	elseif level == 4 then
		return "ui_new/fight/roleBg4.png"
	elseif level == 5 then
		return "ui_new/fight/roleBg5.png"
	elseif level == 6 then
		return "ui_new/fight/roleBg6.png"
	elseif level == 7 then
		return "ui_new/fight/roleBg7.png"
	elseif level == 8 then
		return "ui_new/fight/roleBg8.png"
	elseif level == 9 then
		return "ui_new/fight/roleBg9.png"
	end

	print("level 不正确", level)
	
	return "ui_new/common/gk_head_ding_bg.png"
end

-- 通过区间获得值
function GetVauleByStringRange( str , index )
	-- local index_tbl , vaule_tbl = GetAttrByStringForExtra(str)
	-- print("index_tbl = ",index_tbl)
	-- print("vaule_tbl = ",vaule_tbl)
	-- local temp = 1
	-- for i=1,#index_tbl do
	-- 	if index_tbl[i] <= index and (( i < #index_tbl and index_tbl[i+1] > index) or i ==  #index_tbl) then
	-- 		return vaule_tbl[index_tbl[i]]
	-- 	end
	-- end
	-- print("GetVauleByStringRange error")
	-- return 0

	if string.find(str, "_") then
		local tbl = GetAttrByString(str)
		local temp = 0
		for k,v in pairs(tbl) do
			if index >= k then
				temp = tonumber(v)
			end
		end
		return temp
	else
		return tonumber(str)
	end
end

function GetStringByTbl( tbl )
	local str = ""
	for k,v in pairs(tbl) do
		if str == "" then
		else
			str = str.."|"
		end
		str = str .. k .. "_" .. v
	end
	return str
end

function GetXiaYiBySoulIdAndNum( id , num )
	local item = ItemData:objectByID(id)
	if item == nil then
		print("没有此侠魂 id== ",id)
		return
	end
	return item.xiayi*num
end

--字符串转table(反序列化,异常数据直接返回nil)  
function t_S2T(_szText)  
    --栈  
    function stack_newStack()  
        local first = 1  
        local last = 0  
        local stack = {}  
        local m_public = {}  
        function m_public.pushBack(_tempObj)  
            last = last + 1  
            stack[last] = _tempObj  
        end  
        function m_public.temp_getBack()  
            if m_public.bool_isEmpty() then  
                return nil  
            else  
                local val = stack[last]  
                return val  
            end  
        end  
        function m_public.popBack()  
            stack[last] = nil  
            last = last - 1  
        end  
        function m_public.bool_isEmpty()  
            if first > last then  
                first = 1  
                last = 0  
                return true  
            else  
                return false  
            end  
        end  
        function m_public.clear()  
            while false == m_public.bool_isEmpty() do  
                stack.popFront()  
            end  
        end  
        return m_public  
    end  
    function getVal(_szVal)  
        local s, e = string.find(_szVal,'"',1,string.len(_szVal))  
        if nil ~= s and nil ~= e then  
            --return _szVal  
            return string.sub(_szVal,2,string.len(_szVal)-1)  
        else  
            return tonumber(_szVal)  
        end  
    end  
  
    local m_szText = _szText  
    local charTemp = string.sub(m_szText,1,1)  
    if "{" == charTemp then  
        m_szText = string.sub(m_szText,2,string.len(m_szText))  
    end  
    function doS2T()  
        local tRet = {}  
        local tTemp = nil  
        local stackOperator = stack_newStack()  
        local stackItem = stack_newStack()  
        local val = ""  
        while true do  
            local dLen = string.len(m_szText)  
            if dLen <= 0 then  
                break  
            end  
  
            charTemp = string.sub(m_szText,1,1)  
            if "[" == charTemp or "=" == charTemp then  
                stackOperator.pushBack(charTemp)  
                m_szText = string.sub(m_szText,2,dLen)  
            elseif '"' == charTemp then  
                local s, e = string.find(m_szText, '"', 2, dLen)  
                if nil ~= s and nil ~= e then  
                    val = val .. string.sub(m_szText,1,s)  
                    m_szText = string.sub(m_szText,s+1,dLen)  
                else  
                    return nil  
                end  
            elseif "]" == charTemp then  
                if "[" == stackOperator.temp_getBack() then  
                    stackOperator.popBack()  
                    stackItem.pushBack(val)  
                    val = ""  
                    m_szText = string.sub(m_szText,2,dLen)  
                else  
                    return nil  
                end  
            elseif "," == charTemp then  
                if "=" == stackOperator.temp_getBack() then  
                    stackOperator.popBack()  
                    local Item = stackItem.temp_getBack()  
                    Item = getVal(Item)  
                    stackItem.popBack()  
                    if nil ~= tTemp then  
                        tRet[Item] = tTemp  
                        tTemp = nil  
                    else  
                        tRet[Item] = getVal(val)  
                    end  
                    val = ""  
                    m_szText = string.sub(m_szText,2,dLen)  
                else  
                    return nil  
                end  
            elseif "{" == charTemp then  
                m_szText = string.sub(m_szText,2,string.len(m_szText))  
                local t = doS2T()  
                if nil ~= t then  
                    szText = sz_T2S(t)  
                    tTemp = t  
                    --val = val .. szText  
                else  
                    return nil  
                end  
            elseif "}" == charTemp then  
                m_szText = string.sub(m_szText,2,string.len(m_szText))  
                return tRet  
            elseif " " ~= charTemp then  
                val = val .. charTemp  
                m_szText = string.sub(m_szText,2,dLen)  
            else  
                m_szText = string.sub(m_szText,2,dLen)  
            end  
        end  
        return tRet  
    end  
    local t = doS2T()  
    return t  
end

--[[
转换为垂直显示字符串
]]
function toVerticalString(s)
	-- argument checking
	if type(s) ~= "string" then
		error("bad argument #1 to 'utf8len' (string expected, got ".. type(s).. ")")
	end

	local pos = 1
	local bytes = s:len()
	local len = 0

	local verticalString = ''
	local empty = true
	while pos <= bytes do
		len = len + 1
		local charBytes = utf8charbytes(s, pos)
		local charValue = string.sub(s,pos,pos + charBytes - 1)
		print("toVerticalString : ",charValue,pos,charBytes,s)
		pos = pos + charBytes
		if empty then
			empty = false
		else
			verticalString = verticalString .. '\n'
		end
		verticalString = verticalString .. charValue

	end

	return verticalString
end


function GetFightRoleIconByWuXueLevel( level )
	return "ui_new/array/c"..level..".png"
end
function GetRoleNameBgByQuality( level )
	if (level == 7) then
		level = 6
	end
	return "ui_new/role/bg-n".. level ..".png"
end

function GetBibleNameBgByQuality( level )
	return "ui_new/tianshu/bg-n".. level ..".png"
end

--[[
计算当前天是第几天，相对于1970-01-01 00:00:00。
]]
function calculateDayNumber(seconds)
	--0秒时间为1970-01-01 08:00:00
	local difference = 8 * 60 * 60
	local perdaySeconds = 24 * 60 * 60
	local value = seconds + difference
	return math.floor(value / perdaySeconds)
end



function displayAttributeString(attribute)
	local string = ""
	for i=1,(EnumAttributeType.Max-1) do
		local x = attribute[i]
		if x and x ~= 0 then
			string = string .. AttributeTypeStr[i] .. "：" .. x .. ","
		end
	end
	return string
end


function getColorByString( string )
	local r = ('0x' .. string['2:3']) + 0
	local g = ('0x' .. string['4:5']) + 0
	local b = ('0x' .. string['6:7']) + 0
	return ccc3(r, g, b)
end

function GetColorStringByQuality(quality)
	local tab = GetColorTableByQuality(quality)
	local r = tab[1]
	local g = tab[2]
	local b = tab[3]
	
	local str1 = string.format("%02x", r)
	local str2 = string.format("%02x", g)
	local str3 = string.format("%02x", b)

	return "#" .. str1 .. str2 .. str3
end

--通过品质获得颜色table
function GetColorTableByQuality(quality)
	if quality == QUALITY_DING then	
		return {190,189,189}
	elseif quality == QUALITY_BING then
		return {27,212,53}
	elseif quality == QUALITY_YI then
		return {72,88,255}
	elseif quality == QUALITY_CHUANSHUO then
		return {231,138,6}
	elseif quality == QUALITY_JIA then
		return {189,10,228}
	elseif quality == QUALITY_SHENHUA then
		return {255,68,68}
	end

	return {190,189,189}
end
function Lua_fightWriteFileAuto(file_name, strMode, ...)
	if CC_TARGET_PLATFORM ~= CC_PLATFORM_WIN32 then
		return
	end
	
	if (FightManager.bCheckBug or (AutoTestManager and AutoTestManager.isAutoTest)) then
		local date 		= os.date("*t", os.time())
		-- local timeStr 	= date.month..""..date.day .."--"..date.hour.."_"..date.min.."_"
		local timeStr 	= date.month.."-"..date.day .."--"..date.hour.."_"..date.min.."_"
		strMode = strMode or 'a+'
		local fileName = CCFileUtils:sharedFileUtils():getWritablePath().."\\".."FightReport\\"..timeStr..file_name
		
		local f = io.open(fileName, strMode)
		if (f) then
			local arg = {...}
			for k, v in pairs(arg) do
				local str = serialize(v)
				f:write(str)
			end
			f:write("\n")
			f:close()
		end
	end
end
function Lua_writeFile(file_name,addTime,...)
	if CC_TARGET_PLATFORM ~= CC_PLATFORM_WIN32 then
		return
	end
	if addTime == true then
		local date = GetCorrectDate("*t", GetCorrectTime())
		print("date",date)
		local timeStr = date.year.."_"..date.month.."_"..date.day .."_"..date.hour.."_"..date.min.."_"..date.sec
		file_name = file_name..timeStr
	end
	file_name = file_name..".log"
	local f = assert(io.open(file_name, 'a+'))

	local arg = {...}
	-- local ret = ''
	for k, v in pairs(arg) do
		local str = serialize(v)
		-- ret = ret .. '   ' .. str
		f:write(str)
	end
	f:close()
end

--
function Lua_fightWriteFile(file_name, strMode, ...)
	if CC_TARGET_PLATFORM ~= CC_PLATFORM_WIN32 then
		return
	end
	-- local file_name = CCFileUtils:sharedFileUtils():getWritablePath().."\\".."FightReport\\"
	-- local date = os.date("*t", os.time())-- time correct can revert
	-- local timeStr = date.year.."-"..date.month..""..date.day .."--"..date.hour.."_"..date.min.."_"..date.sec
	-- file_name = file_name..timeStr
	-- FightManager.log_fileName = "F:\\Git\\ClientForDevelop\\bin\\Debug.win32\\FightReport\\"
	if (FightManager and FightManager.log_fileName) then
		local fileName = FightManager.log_fileName..file_name
		strMode = strMode or 'a+'
		local f = io.open(fileName, strMode)
		if (f) then
			local addStr = ""
			if (file_name == EnumFight_Log.HP or file_name == EnumFight_Log.BUFF) then
				local date 		= os.date("*t", os.time())
				local timeStr 	= "["..date.month.."/"..date.day .."/"..date.hour..":"..date.min..":"..date.sec.." - "..os.clock().."] "
				addStr = timeStr
			end
			local arg = {addStr, ...}
			for k, v in pairs(arg) do
				local str = serialize(v)
				f:write(str)
			end
			f:write("\n")
			f:close()
		end
	end
end

--
function Lua_FightPrint(...)
	if (FightManager and FightManager.savePrint) then
		FightManager.savePrint("Fight",...)
	end
	
	if CC_TARGET_PLATFORM ~= CC_PLATFORM_WIN32 then
		return
	end
	local file_name = FightManager.log_fileName
	if (file_name == nil or file_name == "") then
		return
	end
	file_name = file_name.."_print.log"
	local f = io.open(file_name, 'a+')
	if (f) then
		local ____debug_2 = debug.getinfo(2)
		local addStr = ""
		local strFile = string.split(____debug_2.source, "/")
		local fileName = strFile[#strFile] or " _function "
		addStr = "["..fileName.." "..____debug_2.currentline.."]   "
		--
		local date 		= os.date("*t", os.time())
		local timeStr 	= "["..date.month.."/"..date.day .."/"..date.hour..":"..date.min..":"..date.sec.."] "
		addStr = timeStr .. addStr
		--
		local arg = {addStr,...}
		for k, v in pairs(arg) do
			local str = serialize(v)
			f:write(str)
		end
		f:write("\n")
		f:close()
	end
end
function numberToChinese( baseNum )
	baseNum 		= tonumber(baseNum)
    local templete1 = localizable.ChineseNum
    local templete2 = localizable.ChineseNumRank
    local templete3 = localizable.ChineseNumRank1
	-- print("baseNum ", baseNum)
	local aa = ""
	local dd = 0
	local cc = 0
    local function f1(a, b, c)
		if (b > 1) then
			c = math.floor(c/10)
		end
		if (a >= 10) then
			f1(math.floor(a/10) ,b + 1, c);
		end
		local moreA = math.floor(a % 10)
		if (moreA == 0) then
			if (b > 0) then
				if (b % 4 == 0) then
					if (cc == 0) then
						aa = aa ..templete3[math.floor(b / 4)]
						cc = 1
					end
					dd = 0
				else
					if (dd == 0) then
						local tampC = math.floor(c % 10)
						if (tampC > 0) then
							aa = aa ..templete1[moreA + 1]
							dd = 1
						end
					end
				end
			end
		else
			aa = aa ..templete1[moreA + 1]
			if (b > 0) then
				aa = aa .. templete2[b]
			end
			dd = 0
			cc = 0
		end
		-- print(a..'  <<<<<   ' ..b)	
	end
	
	if (baseNum == 0) then
		aa = templete1[1]
	else
		f1(baseNum, 0, baseNum)
	end
	-- print('aa   '..aa)
	return aa
end

function numberToChineseTable( num )

    --local templete = {'一','二','三','四','五','六','七','八','九'}
    local templete =localizable.EnumWuxueLevelType
    
    local shiwei = math.floor(num/10)
    local gewei = num%10
    local str = {}
    if (num == 100) then
		str[1] = templete[1]
		str[2] = localizable.functions_bai
	else
	    if shiwei >= 2 then
	      str[#str + 1] = templete[shiwei]
	      str[#str + 1] = localizable.functions_text1
	    elseif shiwei == 1 then
	      str[#str + 1] = localizable.functions_text1
	    end

	    if gewei > 0 then
	    	str[#str + 1] = templete[gewei]
	    end
	end
    return str  
end

function getFightStrategyNameByType(type)
	if type == 1 then
		return localizable.FightStrategyName_Attack
	elseif type == 5 then
		return localizable.FightStrategyName_Defense
	elseif type == 10 then
		return localizable.FightStrategyName_DOUBLE1
	elseif type == 11 then
		return localizable.FightStrategyName_DOUBLE2
	end
	return localizable.FightStrategyName_Attack
end

function getBeEffectInfo(beEffectExtraAttr)
    local attrInfo = {}
    for k,v in pairs(beEffectExtraAttr) do
        local attrName = BeEffectExtraStr[k]
        if (k == 45 or k == 102) then
            --受疗
            attrName = localizable.Sky_book_tips_2
        end
        if (attrInfo[attrName] == nil) then
            attrInfo[attrName] = {}
            attrInfo[attrName].percentAttr = 0
            attrInfo[attrName].constAttr = 0
        end
       
        if (isPercentAttr(k)) then
             attrInfo[attrName].percentAttr   = attrInfo[attrName].percentAttr + math.abs(covertToDisplayZeroValue(k, v))
        else
            attrInfo[attrName].constAttr     = attrInfo[attrName].constAttr + math.abs(v)
        end
    end
    return attrInfo
end

--分离utf8字符串
function getStringTable(str)
	if type(str) ~= "string" then
		error("bad argument #1 to 'utf8len' (string expected, got ".. type(str).. ")")
	end

	local function utf8CharSize(char)
        if not char then
            return 0
        elseif char > 240 then
            return 4
        elseif char > 225 then
            return 3
        elseif char > 192 then
            return 2
        else
            return 1
        end
    end
    local pos = 1
    local len = str:len()
    local strTab = {}
    while pos <= len do
        local char = string.byte(str, pos)
        local delta = utf8CharSize(char)
        table.insert( strTab, str:sub(pos, pos + delta - 1) )
        pos = pos + delta 
    end
    return strTab
end

function GetRewardByString( str )
    local tbl = stringToNumberTable(str,"_")
    local rewardConfig = {
        type = tbl[1],
        itemId = tbl[2],
        number = tbl[3],
    }
    local rewardItem = BaseDataManager:getReward(rewardConfig)
    return rewardItem
end

--
function getServerShortStrByName( str )
	if type(str) ~= "string" then
		error("bad argument #1 to 'utf8len' (string expected, got ".. type(str).. ")")
		return
	end

	local function utf8CharSize(char)
        if not char then
            return 0
        elseif char > 240 then
            return 4
        elseif char > 225 then
            return 3
        elseif char > 192 then
            return 2
        else
            return 1
        end
    end
    local pos = 1
    local len = str:len()
    local strTab = {}
    while pos <= len do
        local char = string.byte(str, pos)
        local delta = utf8CharSize(char)
        if char > 127 then
        	break
        end
        pos = pos + delta 
    end
    return str:sub(0, pos - 1)
end

function ServerDataErrorTips(delayTime, nCount)
	delayTime = delayTime or 500
	nCount = nCount or 1
	local _timerId = -1
	local function _cellBackFunc(  )
		toastMessage(localizable.common_data_error)
		TFDirector:removeTimer(_timerId)
	end
	
	_timerId = TFDirector:addTimer(delayTime, nCount, _cellBackFunc, nil)
end
function getSkillRichtextModelText(color, addStr)
	if (addStr == "") then
		return addStr
	end
	local str1 = [[</font><font face = "simhei" color="M1" fontSize = "20">]]
	local str2 = [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]
	local str = str1:gsub("M1", color)..addStr..str2
	return str
end

function getSkillStrKeyRichtext(str, bUp, key, addStr, strColor)
	if (addStr == nil) then
		return str
	end
	if ( addStr and addStr ~= false) then
		local replaceKeyStr = "#"..key.."#"
		if (bUp) then
			replaceKeyStr = "&"..key.."&"
		end
		str = str:gsub(replaceKeyStr, getSkillRichtextModelText(strColor, addStr));
	end
	return str
end
function ResetLoadFightLua( )
	
	local fileList = {
		"lua.logic.fight.BaseFightAction",
		"lua.logic.fight.BaseFightRole",
		"lua.logic.fight.FightAction",
		"lua.logic.fight.FightOutAction",
		"lua.logic.fight.FightRole",
		"lua.logic.fight.fightPauseLayer",
		"lua.logic.fight.FightUiLayer",
		"lua.logic.fight.FightLoadingLayer",
		"lua.logic.fight.RoleLayer",
		"lua.logic.fight.FightResultLayer",
		"lua.logic.fight.FightResultScene",
		"lua.logic.fight.FightScene",
		"lua.logic.fight.Shanghaitongji",
		"lua.logic.fight.MapLayer",
		"lua.logic.fight.FightPublic",
		--------------------------------------
		"lua.logic.fight.FightAI",
		"lua.logic.fight.FightRoundManager",
		"lua.logic.fight.FightRoleManager",
		"lua.logic.fight.FightReplayManager",
		--------------------------------------
		"lua.logic.battle.BattleAction",
		"lua.logic.battle.BattleMapLayer",
		"lua.logic.battle.BattleRoleLayer",
		"lua.logic.battle.BattleUiLayer",
		"lua.logic.battle.BattleScene",
		"lua.logic.battle.BattleHurtCount",
		
		"lua.logic.battle.BattleResultLayer",
		"lua.logic.battle.BattleResultScene",
		"lua.logic.battle.BattleRoleDisplay",
		"lua.logic.battle.BattleRoleManager",
		"lua.logic.battle.BattleReplayManager",
		--------------------------------------
		"lua.gamedata.base.EnumFight",
		"lua.table.t_s_spell",
		"lua.table.t_s_buffer_2",
	}
	for i,v in ipairs(fileList) do
	
		package.loaded[v] = nil
	end

	require('lua.gamedata.base.EnumFight')
	-- _G["FightManager"] = require('lua.gamedata.FightManager')
	SkillBaseData = require('lua.table.t_s_spell')
	BaseDataManager:BindSkillBaseData()
	SkillLevelData:restart( )
	FightManager.isClearFight = true
	FightManager:restartLoaded()
	FightManager:Reset()

	FightManager:RegisterEvents()
	--
end

function ResetLoadLuaFile(isFight, isLoadTable)
	if (VERSION_DEBUG == true and CC_TARGET_PLATFORM == CC_PLATFORM_WIN32) then
		hideAllLoading()
		-- AlertManager:restart()
		
		-- local refreshTag = string.split("lua.logic",".")
		--重载文件夹
		local refreshList = {
								string.split("lua.logic","."),
								string.split("lua.uiconfig_mango_new",".")
							}
		--重载文件夹下不需要重载文件夹
		local ridTagList = {}
		if (isFight) then
			ResetLoadFightLua()
			return
		elseif (isLoadTable) then
			-- refreshTag = string.split("lua.table",".")
			refreshList = {string.split("lua.table",".")}
		else
		AlertManager:clearAllCacheLayer()
			ridTagList =  {
				"lua.logic.fight",
				"lua.logic.battle"
			}
		end
		for k,v in pairs(package.loaded) do
			str = string.split(k,".")
			local needClear = true
			
			for _k,tag in ipairs(str) do
				if (_k > 2) then
					break
				end
				local b1 ,b2
				if(refreshList[1]) then
					--for ____,_Tag in ipairs(refreshList[1]) do
					if tag ~= refreshList[1][_k] then
						b1 = true
						break
					end
				end
				if(refreshList[2]) then
				--	for ____,_Tag in ipairs(refreshList[2]) do
					if tag ~= refreshList[2][_k] then
						b2 = true
						break
					end
				end
				if (b1 and b2) then
					needClear = false
					break
				end
			end
			if needClear and str[2] ~= nil then
				for _,ridstr in pairs(ridTagList) do
					ridTag = string.split(ridstr,".")
					local breaked = false
					for kk,rid in pairs(ridTag) do
						if str[kk] ~= rid then
							breaked = true
							break
						end
					end
					if breaked == false then
						needClear = false
						break
					end
				end
				if needClear then
					package.loaded[k] = nil
				end
			end
		end
		if (isLoadTable) then
			-- SkillLevelData:restart( )
			-- package.loaded['lua.gamedata.BaseDataManager'] = nil
			-- BaseDataManager = require('lua.gamedata.BaseDataManager')
			--
			package.loaded['lua.gamedata.base.functions'] = nil
			
			require('lua.gamedata.base.functions')
		end
		
	end
end
-- mapTextureCache = {}
function Debug_OutMemLog(addFighleName)
	addFighleName = addFighleName or ""
	--
	if (me.TextureCache.getTexturesMap == nil) then
		return
	end
	local tmap = me.TextureCache:getTexturesMap()
	local nLen = tmap:size()
	local keys = tmap:keys()

	local nUsed = 0
	local nMem = 0
	local nUsedMem = 0
	local nUsedMem1 = 0
	local fileName = CCFileUtils:sharedFileUtils():getWritablePath().."\\log\\"
	local date 		= os.date("*t", os.time())
	local timeStr 	= date.month.."-"..date.day .."--"..date.hour.."_"..date.min.."_OutMemLog"..addFighleName
	fileName 	= fileName..timeStr
	local sortList = {}
	local sortList2 = {}
	for i = 0, nLen - 1 do 
		local name = keys:at(i)
		local cs = name:getCString()
		
		local tex = tmap:objectForKey(name:getCString())
		local bpp = tex:bitsPerPixelForFormat()
		local bytes = tex:getPixelsWide() * tex:getPixelsHigh() * bpp / 8 / 1024
		nMem = nMem + bytes
			local Count = tex:retainCount()
			if Count > 1 then 
				nUsed = nUsed + 1 
				nUsedMem = nUsedMem + bytes
				-- if (not mapTextureCache[cs]) then
				-- 	local info = { size = (bytes / 1024), _name = cs, nCount = Count}
				-- 	table.insert( sortList, info )
				-- 	-- mapTextureCache[cs] = true
				-- end
			else
				if (not mapTextureCache[cs]) then
					local info = { size = (bytes / 1024), _name = cs, nCount = 0}
					table.insert( sortList2, info )
					-- mapTextureCache[cs] = true
				end
			end
			
		
	end
	local function sortFuc(a, b)
		return a.size > b.size
	end
	table.sort( sortList, sortFuc )
	table.sort( sortList2, sortFuc )
	--
	local rate = (nUsed/nLen*100).."%"
	Lua_writeFile(fileName,nil,  rate.." ----------nUsed------------ \n")
	local sun = 0
	for i,v in ipairs(sortList) do
		sun = sun + v.size
		Lua_writeFile(fileName,nil, string.format("\n%.4fM  -  %.4fM  nCount=%d ", v.size, sun, v.nCount)..v._name)
	end
	Lua_writeFile(fileName,nil, " \n---------------------- \n--------------\n")
	sun = 0
	for i,v in ipairs(sortList2) do
		sun = sun + v.size
		Lua_writeFile(fileName,nil, string.format("\n%.4fM  -  %.4fM  nCount=%d ", v.size, sun, v.nCount)..v._name)
	end
	
	Lua_writeFile(fileName,nil,  "\n ---------------------- \n"..(nUsedMem / 1024))
	Lua_writeFile(fileName,nil, (nMem / 1024).."\n")
end

function ViewSizeCheck(view, addSc, bX, bY, Pos, bMin, bScale)
	if (VIEW_SCALE and view) then
		local typeView = view:getDescription()
		if (typeView == "TFArmature") then
			bScale = true
		end
	
		addSc = addSc or 0
		local size = view:getSize()
		print("----ViewSizeCheck  ", size)
		local xxx = GameConfig.WS.width / size.width
		local yyy = GameConfig.WS.height / size.height
		
		if (bX) then
			if (bScale) then
				view:setScaleX(xxx+ addSc)
			else
				view:setSize(CCSizeMake(size.width * xxx, size.height))
			end
		end
		if (bY) then
			view:setScaleY(yyy + addSc)
		end
		if (not bX and not bY) then
			local scXY =   math.max( xxx,yyy ) + addSc
			if (bMin) then
				scXY =   math.min( xxx,yyy ) + addSc
			end
			if (bScale) then
				if (scXY > 1) then
					view:setScale(scXY)
				end
			else
				view:setSize(CCSizeMake(size.width * scXY + addSc, size.height * scXY + addSc))
			end
		end
		if (Pos and type(Pos) == "table") then
			view:setPosition(Pos)
		end
	end
end
