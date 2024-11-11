local StringUtils = {}
StringUtils.format = function(formatStr, ...) 
	--example 
	--StringUtils.format("start {p1} is {p2} not {p3} end", "superman", "hero", "badguy")
--	if (not formatStr) then
--		ErrorCodeManager:MakeError()
--		formatStr = "tips error"
--		return formatStr
--	end
	local params = {}
	for k, v in ipairs{...} do
		table.insert(params, v)
	end

	local len = string.len(formatStr)

	local strs = {}
	local paramNum = {}
	local paramTemps = {}
	local preEndPos = 0

	for i = 1, len do 
		local charTemp1 = formatStr[i]
		if(charTemp1 == '{') then
			local charTemp2 = formatStr[i + 1]
			local charTemp3 = formatStr[i + 2]
			local charTemp4 = formatStr[i + 3]
			if charTemp2 == 'p' and charTemp4 == '}' and tonumber(charTemp3) then
				--table.insert(paramNum, tonumber(charTemp3))
				local paramTemp = params[tonumber(charTemp3)]
				if not paramTemp then
					return nil
				end
				table.insert(paramTemps, paramTemp)
				
				local str = string.sub(formatStr, preEndPos + 1, i - 1)
				table.insert(strs, str)

				i = i + 3 
				preEndPos = i

			--VIP特殊处理
			elseif charTemp2 == 'v' and charTemp4 == '}' and tonumber(charTemp3) then
				--table.insert(paramNum, tonumber(charTemp3))
				local vipLevel = params[tonumber(charTemp3)]
				if not vipLevel then
					return nil
				end
				
				local paramTemp
				if vipLevel <= 15 then 
					paramTemp = StringUtils.format(localizable.VIP_UNDER_15, vipLevel)
				elseif vipLevel == 16 then
					paramTemp = localizable.VIP16
				elseif vipLevel == 17 then
					paramTemp = localizable.VIP17
				elseif vipLevel == 18 then
					paramTemp = localizable.VIP18
				elseif vipLevel == 19 then
					paramTemp = localizable.VIP19
				elseif vipLevel == 20 then
					paramTemp = localizable.VIP20
				end

				table.insert(paramTemps, paramTemp)
				local str = string.sub(formatStr, preEndPos + 1, i - 1)
				table.insert(strs, str)

				i = i + 3 
				preEndPos = i
			end			
		end

		i = i + 1
	end

	local strEnd = string.sub(formatStr, preEndPos + 1, len)
	table.insert(strs, strEnd)

	local count = table.getn(strs)

	local ret = ""
	for i = 1, count do
		if i ~= count then
			--local paramTemp = params[paramNum[i]]
			--ret = ret .. strs[i] .. paramTemp
			ret = ret .. strs[i] .. paramTemps[i]
		else 
			ret = ret .. strs[i]
		end
	end

	-- print('string.format:', ret)
	return ret
end

--  富文本格式 #R2XXX#
StringUtils.richText = function(formatStr)
	local text 			= [[<p style="text-align:left; margin:5px" >]];
	local defaultColor 	= [[<font color="#3D3D3D" face = "simhei">]]
	local arrColor = {
						"#FFFFFF",	--白1
						"#FF0000",	--红2
						"#FFA500",	--橙3
						"#FFFF00",	--黄4
						"#00FF00",	--绿5
						"#006400",	--青6
						"#0000FF",	--蓝7
						"#A020F0",	--紫8
						"#BEBDBD",	--装备等级1颜色9
						"#1BD435",	--装备等级2颜色10
						"#4858FF",	--装备等级3颜色11
						"#BD0AE4",	--装备等级4颜色12
						"#E78A06",	--装备等级5颜色13
						"#FF4444",	--装备等级6颜色14
						-- ccc3(190,189,189)
						-- ccc3(27,212,53)
						-- ccc3(72,88,255)
						-- ccc3(189,10,228)
						-- ccc3(231,138,6)
						-- ccc3(255,68,68)
					}
	local function getColorText(idColor, _text)
		local des = (idColor == 0) and defaultColor or string.gsub(defaultColor, "#3D3D3D", arrColor[tonumber(idColor)])
	    des = des .. _text
	    des = des .. [[</font>]]
		return des
	end
	
	local desInfo 	= string.split(formatStr, "#")
	local len 		= table.getn(desInfo)
	for i = 1, len do 
		local strTemp 		= desInfo[i]
		local idColor 		= tonumber(strTemp[2])
		local typeColor 	= strTemp[1]
		
		if(type(idColor) == "number" and typeColor == "R") then
			text = text .. getColorText(idColor, string.sub(strTemp, 3))
		else
			--默认黑色
			text = text .. getColorText(0, strTemp)
		end
	end
	text = text .. [[</p>]]
	return text
end

--  富文本格式 #R2XXX#
StringUtils.richText2 = function(formatStr)
	local text 			= [[<p style="text-align:left; margin:5px" >]];
	local defaultColor 	= [[<font color="#3D3D3D" face = "simhei">]]
	local arrColor = {
						"#FFFFFF",	--白1
						"#FF0000",	--红2
						"#FFA500",	--橙3
						"#FFFF00",	--黄4
						"#00FF00",	--绿5
						"#006400",	--青6
						"#0000FF",	--蓝7
						"#A020F0",	--紫8
						"#BEBDBD",	--装备等级1颜色9
						"#1BD435",	--装备等级2颜色10
						"#4858FF",	--装备等级3颜色11
						"#BD0AE4",	--装备等级4颜色12
						"#E78A06",	--装备等级5颜色13
						"#FF4444",	--装备等级6颜色14
						-- ccc3(190,189,189)
						-- ccc3(27,212,53)
						-- ccc3(72,88,255)
						-- ccc3(189,10,228)
						-- ccc3(231,138,6)
						-- ccc3(255,68,68)
					}
	local function getColorText(idColor, _text)
		local des = (idColor == 0) and defaultColor or string.gsub(defaultColor, "#3D3D3D", arrColor[tonumber(idColor)])
	    des = des .. _text
	    des = des .. [[</font>]]
		return des
	end
	
	local desInfo 	= string.split(formatStr, "#")
	local len 		= table.getn(desInfo)
	for i = 1, len do 
		local strTemp 		= desInfo[i]
		local strInfo		= string.split(strTemp, "-")		
		local idColor 		= tonumber(strInfo[2])
		local typeColor 	= strTemp[1]
		
		if(type(idColor) == "number" and typeColor == "R") then
			local deleteByte = 5
			if idColor >= 10 then
				deleteByte = 6
			end
			text = text .. getColorText(idColor, string.sub(strTemp, deleteByte))
		else
			--默认黑色
			text = text .. getColorText(0, strTemp)
		end
	end
	text = text .. [[</p>]]
	return text
end

--  富文本格式 #R2XXX#
StringUtils.richText3 = function(formatStr)
	local text 			= [[<p style="text-align:left; margin:5px" >]];
	local defaultColor 	= [[<font color="#FFFFFF" fontSize="20" face = "simhei">]]
	local arrColor = {
						"#FFF100",	--金1
						"#FF0000"
					}
	local arrSize = {
						"25",
						"30",
						"35",
						"40",
					}				
	local function getColorText(idColor,idSize, _text)
		local des
		if idColor ~= 0 then
			des = (idColor == 0) and defaultColor or string.gsub(defaultColor, "#FFFFFF", arrColor[tonumber(idColor)])
			des = (idSize == 0) and des or string.gsub(des, "20", arrSize[tonumber(idSize)])
		else
			des = (idColor == 0) and defaultColor or string.gsub(defaultColor, "#FFFFFF", arrColor[tonumber(idColor)])
		end
	    des = des .. _text
	    des = des .. [[</font>]]
		return des
	end
	
	local desInfo 	= string.split(formatStr, "#")
	local len 		= table.getn(desInfo)
	for i = 1, len do 
		local strTemp 		= desInfo[i]
		local strInfo		= string.split(strTemp, "-")		
		local idColor 		= tonumber(strInfo[2])
		local idSize 		= tonumber(strInfo[3])
		local typeColor 	= strTemp[1]
		
		if(type(idColor) == "number" and type(idColor) == "number" and typeColor == "R") then
			local deleteByte = 7
			if idColor >= 10 then
				deleteByte = 8
			end
			text = text .. getColorText(idColor,idSize, string.sub(strTemp, deleteByte))
		else
			--默认白色
			text = text .. getColorText(0,0, strTemp)
		end
	end
	text = text .. [[</p>]]
	return text
end

--  富文本格式 #R2XXX#
StringUtils.richTextAndTouch = function(formatStr, targetIdList)
	local text 			= [[<p style="text-align:left; margin:5px" >]];
	local defaultTouch	= [[<button id ="touchId">]]
	local defaultColor 	= [[<font color="#3D3D3D" >]]
	local arrColor = {
						"#FFFFFF",	--白1
						"#FF0000",	--红2
						"#F17700",	--橙3
						"#FFFF00",	--黄4
						"#00FF00",	--绿5
						"#006400",	--青6
						"#0000FF",	--蓝7
						"#A020F0",	--紫8
					}
	local function getColorText(idColor, _text,touchID)
		local des;
		if idColor ~= 0 then
			des = (idColor == 0) and defaultTouch or string.gsub(defaultTouch, "touchId", touchID)
			des = des .. ((idColor == 0) and defaultColor or string.gsub(defaultColor, "#3D3D3D", arrColor[tonumber(idColor)]))
		else
			des = (idColor == 0) and defaultColor or string.gsub(defaultColor, "#3D3D3D", arrColor[tonumber(idColor)])
		end
	    des = des .. _text
		des = des .. [[</font>]]
		if idColor ~= 0 then
			des = des .. [[</button>]]
		end
		return des
	end
	local touchIdList = targetIdList
	local desInfo 	= string.split(formatStr, "#")
	local len 		= table.getn(desInfo)
	local index		= 0;
	for i = 1, len do 
		local strTemp 		= desInfo[i]
		local idColor 		= tonumber(strTemp[2])
		local typeColor 	= strTemp[1]
		
		if(type(idColor) == "number" and typeColor == "R") then
			index = index + 1 
			text = text .. getColorText(idColor, string.sub(strTemp, 3), touchIdList[index])
			-- text = text .. [[<on click="]] .. getColorText(idColor, string.sub(strTemp, 3)) .. [["> click me! </on>]]
		else
			--默认黑色
			text = text .. getColorText(0, strTemp)
		end
	end
	
	text = text .. [[</p>]]
	return text
end


return StringUtils