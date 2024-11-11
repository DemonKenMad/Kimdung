local t = 
{
	version = 1,
	components = 
	{
		
		{
			anchorPoint = "False",
			anchorPointX = "0",
			anchorPointY = "0",
			backGroundScale9Enable = "False",
			bgColorOpacity = "50",
			bIsOpenClipping = "False",
			classname = "MEPanel",
			colorType = "0;SingleColor:#FFE6E6E6;GraduallyChangingColorStart:#FFFFFFFF;GraduallyChangingColorEnd:#FFFFFFFF;vectorX:0;vectorY:0",
			DesignHeight = "640",
			DesignType = "0",
			DesignWidth = "960",
			dstBlendFunc = "771",
			height = "719",
			ignoreSize = "False",
			name = "Panel",
			PanelRelativeSizeModel = 
			{
				PanelRelativeEnable = true,
			},
			sizepercentx = "0",
			sizepercenty = "0",
			sizeType = "0",
			srcBlendFunc = "1",
			touchAble = "False",
			UILayoutViewModel = 
			{
				nType = 3,
			},
			uipanelviewmodel = 
			{
				Layout="Relative",
				nType = "3"
			},
			width = "994",
			ZOrder = "1",
			components = 
			{
				
				{
					anchorPoint = "False",
					anchorPointX = "0.5",
					anchorPointY = "0.5",
					backGroundScale9Enable = "False",
					bgColorOpacity = "50",
					bIsOpenClipping = "False",
					classname = "MEPanel",
					colorType = "0;SingleColor:#FFE6E6E6;GraduallyChangingColorStart:#FFFFFFFF;GraduallyChangingColorEnd:#FFFFFFFF;vectorX:0;vectorY:0",
					DesignHeight = "640",
					DesignType = "0",
					DesignWidth = "960",
					dstBlendFunc = "771",
					height = "640",
					ignoreSize = "False",
					name = "Panel_Content",
					sizepercentx = "0",
					sizepercenty = "0",
					sizeType = "0",
					srcBlendFunc = "1",
					touchAble = "False",
					UILayoutViewModel = 
					{
						PositionX = 480,
						PositionY = 320,
						relativeToName = "Panel",
						nType = 3,
						nGravity = 6,
						nAlign = 5
					},
					uipanelviewmodel = 
					{
						Layout="Absolute",
						nType = "0"
					},
					width = "960",
					ZOrder = "1",
					components = 
					{
						
						{
							anchorPoint = "False",
							anchorPointX = "0.5",
							anchorPointY = "0.5",
							backGroundScale9Enable = "True;capInsetsX:0;capInsetsY:0;capInsetsWidth:0;capInsetsHeight:0",
							classname = "MEImage",
							dstBlendFunc = "771",
							height = "380",
							ignoreSize = "False",
							name = "img_dibg",
							sizepercentx = "0",
							sizepercenty = "0",
							sizeType = "0",
							srcBlendFunc = "1",
							texturePath = "ui_new/common/bg_h.png",
							touchAble = "False",
							UILayoutViewModel = 
							{
								relativeToName = "Panel",
							},
							width = "700",
							ZOrder = "1",
							components = 
							{
								
								{
									anchorPoint = "False",
									anchorPointX = "0.5",
									anchorPointY = "0.5",
									backGroundScale9Enable = "False",
									classname = "MEImage",
									dstBlendFunc = "771",
									height = "81",
									ignoreSize = "False",
									name = "img_tiao",
									scaleX = "0.82",
									sizepercentx = "0",
									sizepercenty = "0",
									sizeType = "0",
									srcBlendFunc = "1",
									texturePath = "ui_new/common/bg_biaoti2.png",
									touchAble = "False",
									UILayoutViewModel = 
									{
										PositionX = -1,
										PositionY = 171,
									},
									width = "855",
									ZOrder = "1",
								},
								{
									anchorPoint = "False",
									anchorPointX = "0.5",
									anchorPointY = "0.5",
									backGroundScale9Enable = "False",
									classname = "MEButton",
									ClickHighLightEnabled = "True",
									dstBlendFunc = "771",
									flipX = "False",
									flipY = "False",
									height = "54",
									HitType = 
									{
										nHitType = 2,
										nRadius = 100,
									},
									ignoreSize = "True",
									name = "btn_close",
									normal = "ui_new/common/common_close2_icon.png",
									sizepercentx = "0",
									sizepercenty = "0",
									sizeType = "0",
									srcBlendFunc = "1",
									touchAble = "True",
									UILayoutViewModel = 
									{
										PositionX = 312,
										PositionY = 182,
										LeftPositon = 240,
										TopPosition = 382,
										relativeToName = "Panel",
									},
									UItype = "Button",
									width = "54",
									ZOrder = "1",
								},
								{
									anchorPoint = "False",
									anchorPointX = "0.5",
									anchorPointY = "0.5",
									backGroundScale9Enable = "False",
									classname = "MEImage",
									dstBlendFunc = "771",
									height = "63",
									ignoreSize = "True",
									name = "img_wenben",
									sizepercentx = "0",
									sizepercenty = "0",
									sizeType = "0",
									srcBlendFunc = "1",
									texturePath = "ui_new/qiyu/family/img_sycg.png",
									touchAble = "False",
									UILayoutViewModel = 
									{
										PositionY = 184,
										LeftPositon = -97,
										TopPosition = 388,
										relativeToName = "Panel",
									},
									width = "194",
									ZOrder = "1",
								},
								{
									anchorPoint = "False",
									anchorPointX = "0.5",
									anchorPointY = "0.5",
									classname = "METextArea",
									ColorMixing = "#FF3D3D3D",
									dstBlendFunc = "771",
									fontName = "simhei",
									fontShadow = 
									{
										IsShadow = false,
										ShadowColor = "#FFFFFFFF",
										ShadowAlpha = 255,
										OffsetX = 0,
										OffsetY = 0,
									},
									fontSize = "22",
									fontStroke = 
									{
										IsStroke = false,
										StrokeColor = "#FFE6E6E6",
										StrokeSize = 1,
									},
									hAlignment = "0",
									height = "79",
									ignoreSize = "False",
									name = "txt_shouyao",
									sizepercentx = "0",
									sizepercenty = "0",
									sizeType = "0",
									srcBlendFunc = "1",
									text = "恭喜您受邀成功！过完新手指引后可在邮件中获得以下所有奖励！",
									touchAble = "False",
									touchScaleEnable = "False",
									UILayoutViewModel = 
									{
										PositionX = 6,
										PositionY = 69,
									},
									vAlignment = "0",
									width = "520",
									ZOrder = "1",
								},
							},
						},
						{
							anchorPoint = "False",
							anchorPointX = "0",
							anchorPointY = "0",
							backGroundScale9Enable = "False",
							bgColorOpacity = "50",
							bIsOpenClipping = "False",
							classname = "MEPanel",
							colorType = "0;SingleColor:#FFE6E6E6;GraduallyChangingColorStart:#FFFFFFFF;GraduallyChangingColorEnd:#FFFFFFFF;vectorX:0;vectorY:0",
							DesignHeight = "640",
							DesignType = "0",
							DesignWidth = "960",
							dstBlendFunc = "771",
							height = "206",
							ignoreSize = "False",
							name = "panel_reward",
							sizepercentx = "0",
							sizepercenty = "0",
							sizeType = "0",
							srcBlendFunc = "1",
							touchAble = "False",
							UILayoutViewModel = 
							{
								PositionX = -322,
								PositionY = -166,
							},
							uipanelviewmodel = 
							{
								Layout="Absolute",
								nType = "0"
							},
							width = "629",
							ZOrder = "1",
						},
						{
							anchorPoint = "False",
							anchorPointX = "0",
							anchorPointY = "0",
							backGroundScale9Enable = "False",
							bgColorOpacity = "50",
							bIsOpenClipping = "False",
							classname = "MEPanel",
							colorType = "0;SingleColor:#FFE6E6E6;GraduallyChangingColorStart:#FFFFFFFF;GraduallyChangingColorEnd:#FFFFFFFF;vectorX:0;vectorY:0",
							DesignHeight = "640",
							DesignType = "0",
							DesignWidth = "960",
							dstBlendFunc = "771",
							height = "140",
							ignoreSize = "False",
							name = "panel_item",
							sizepercentx = "0",
							sizepercenty = "0",
							sizeType = "0",
							srcBlendFunc = "1",
							touchAble = "False",
							UILayoutViewModel = 
							{
								PositionX = -560,
								PositionY = -350,
								LeftPositon = 1,
								TopPosition = 568,
								relativeToName = "Panel",
							},
							uipanelviewmodel = 
							{
								Layout="Absolute",
								nType = "0"
							},
							width = "140",
							ZOrder = "1",
							components = 
							{
								
								{
									anchorPoint = "False",
									anchorPointX = "0",
									anchorPointY = "0",
									backGroundScale9Enable = "False",
									classname = "MEButton",
									ClickHighLightEnabled = "True",
									dstBlendFunc = "771",
									flipX = "False",
									flipY = "False",
									height = "140",
									ignoreSize = "True",
									name = "bg_icon",
									normal = "ui_new/roleequip/js_zblv_icon.png",
									sizepercentx = "0",
									sizepercenty = "0",
									sizeType = "0",
									srcBlendFunc = "1",
									touchAble = "True",
									UILayoutViewModel = 
									{
										PositionY = 1,
									},
									UItype = "Button",
									width = "140",
									ZOrder = "1",
								},
								{
									anchorPoint = "False",
									anchorPointX = "0.5",
									anchorPointY = "0.5",
									backGroundScale9Enable = "False",
									classname = "MEImage",
									dstBlendFunc = "771",
									height = "64",
									ignoreSize = "True",
									name = "img_icon",
									sizepercentx = "0",
									sizepercenty = "0",
									sizeType = "0",
									srcBlendFunc = "1",
									texturePath = "ui/common/img_general_icon.png",
									touchAble = "False",
									UILayoutViewModel = 
									{
										PositionX = 68,
										PositionY = 71,
									},
									width = "64",
									ZOrder = "1",
								},
								{
									anchorPoint = "False",
									anchorPointX = "1",
									anchorPointY = "0",
									classname = "MELabelBMFont",
									dstBlendFunc = "771",
									fileNameData = "font/num_202.fnt",
									height = "27",
									ignoreSize = "True",
									name = "txt_num",
									sizepercentx = "0",
									sizepercenty = "0",
									sizeType = "0",
									srcBlendFunc = "1",
									text = "X30",
									touchAble = "False",
									UILayoutViewModel = 
									{
										PositionX = 122,
										PositionY = 8,
									},
									width = "45",
									ZOrder = "1",
								},
								{
									anchorPoint = "False",
									anchorPointX = "0.5",
									anchorPointY = "0.5",
									classname = "MELabel",
									compPath = "luacomponents.common.MEIconLabel",
									dstBlendFunc = "771",
									FontColor = "#FFFFFFFF",
									fontName = "simhei",
									fontShadow = 
									{
										IsShadow = false,
										ShadowColor = "#FFFFFFFF",
										ShadowAlpha = 255,
										OffsetX = 0,
										OffsetY = 0,
									},
									fontSize = "24",
									fontStroke = 
									{
										IsStroke = true,
										StrokeColor = "#FF000000",
										StrokeSize = 2,
									},
									height = "24",
									IconLayout = "1",
									ignoreSize = "True",
									name = "txt_name",
									nGap = "0",
									nIconAlign = "1",
									nTextAlign = "1",
									sizepercentx = "0",
									sizepercenty = "0",
									sizeType = "0",
									srcBlendFunc = "1",
									text = "倚天屠龙刀",
									touchAble = "False",
									touchScaleEnable = "False",
									UILayoutViewModel = 
									{
										PositionX = 69,
										PositionY = -7,
									},
									visible = "False",
									width = "120",
									ZOrder = "1",
								},
							},
						},
					},
				},
			},
		},
	},
	actions = 
	{
		
	},
	respaths = 
	{
		textures = 
		{
			"ui_new/common/bg_h.png",
			"ui_new/common/bg_biaoti2.png",
			"ui_new/common/common_close2_icon.png",
			"ui_new/qiyu/family/img_sycg.png",
			"ui_new/roleequip/js_zblv_icon.png",
			"ui/common/img_general_icon.png",
		},
		armatures = 
		{
			
		},
		movieclips = 
		{
			
		},
	},
}
return t

