--[[
******品质提升结果*******

    -- by fei
    -- 2014/4/16
]]

local RoleBreakResultNewLayer = class("RoleBreakResultNewLayer", BaseLayer)
local uiActivity = {
                    "shengjie",     --武学升阶
                    "tupo",
                    "shengpin",
                    "tianshu",
                   };
local trainNames = localizable.role_train_names

function RoleBreakResultNewLayer:ctor(playType)
    self.super.ctor(self,data)
    self.playType   = playType
    -- self.targetId   = targetId
    -- self.func       = func
    self:init("lua.uiconfig_mango_new.role.RoleBreakResultNew")
end

function RoleBreakResultNewLayer:initUI(ui)
	self.super.initUI(self,ui)
    self.Panel_Role             = TFDirector:getChildByPath(ui, 'Panel_Role')
    self.Panel_all              = TFDirector:getChildByPath(ui, 'Panel_all')
    self.img_role               =  TFDirector:getChildByPath(ui, 'img_role')
    self.Panel_num_shengjie     = TFDirector:getChildByPath(ui, 'Panel_num_shengjie')
    self.Panel_num_tupo         = TFDirector:getChildByPath(ui, 'Panel_num_tupo')
    self.panel_star             = TFDirector:getChildByPath(ui, 'panel_star')
    self.img_tiao               = TFDirector:getChildByPath(ui, 'img_tiao')
    self.Panel_shengjie         = TFDirector:getChildByPath(self.img_tiao, 'Panel_shengjie')
    self.Panel_tupo             = TFDirector:getChildByPath(self.img_tiao, 'Panel_tupo')
    self.panel_tianshustar      = TFDirector:getChildByPath(ui, 'panel_tianshustar')
    self.img_title              = TFDirector:getChildByPath(ui, 'img_title')
    self.img_rolelevel          = TFDirector:getChildByPath(ui, 'img_rolelevel')
    self.img_clicktoclose          = TFDirector:getChildByPath(ui, 'img_clicktoclose')
    self.Panel_Touch          = TFDirector:getChildByPath(ui, 'Panel_Touch')
    --
    self.img_tiao:setVisible(false)
    self.Panel_shengjie:setVisible(false)
    self.Panel_tupo:setVisible(false)
    self.img_role:setZOrder(3)
    self.Panel_Role:setZOrder(2)
    self.Panel_Touch:setTouchEnabled(false)
    --
    -- self.playType = CardRoleManager.upEffectType.skyBookUp
    --
    local isPlay = false
    for i,v in pairs(CardRoleManager.upEffectType) do
        if (self.playType == v) then
            isPlay = true
            break
        end
    end
    if (isPlay == false) then
        AlertManager:close()
        return
    end
    -- local b= me.TextureCache:getTexturesMap():objectForKey("effect/book_down.png")
    self:playRoleUpEffect()
    
end
--
function RoleBreakResultNewLayer:moveIn()
    self:initVisible()
    self.Panel_Role:setVisible(true)
    self.ui:runAnimation(uiActivity[self.playType],1)
    self.img_clicktoclose:setVisible(true)
    local effect = self:createEffect("book_particle_down", 0, self.Panel_Role, -1)
    effect:setPositionY(effect:getPositionY() - 50)
    if (effect and self.playType == CardRoleManager.upEffectType.skyBookUp) then
        effect:setScale(0.8)
    end
end
function RoleBreakResultNewLayer:initVisible()
    self.Panel_Touch:setTouchEnabled(true)
    if (self.playType == CardRoleManager.upEffectType.roleUpBartial) then
        self.Panel_num_shengjie:setVisible(true)
        self.img_tiao:setVisible(self.Panel_shengjie:isVisible())
        self.img_title:setVisible(true)
    elseif (self.playType == CardRoleManager.upEffectType.roleUpStar) then
        self.img_tiao:setVisible(true)
        self.Panel_num_tupo:setVisible(true)
        self.panel_star:setVisible(true)
        self.Panel_tupo:setVisible(true)
        self.img_title:setVisible(true)
        self:createEffect("role_line", 4)
    elseif (self.playType == CardRoleManager.upEffectType.roleUpGrade) then
        self.img_tiao:setVisible(self.Panel_shengjie:isVisible())
        self.Panel_num_tupo:setVisible(true)
        self.img_rolelevel:setVisible(true)
        self.img_title:setVisible(true)
        self:createEffect("role_line", 4)
        self:createEffect("role_up_1", 5, self.img_rolelevel)
        
    elseif (self.playType == CardRoleManager.upEffectType.skyBookUp) then
        self.panel_tianshustar:setVisible(true)
        self.Panel_num_tupo:setVisible(true)
    elseif (self.playType == CardRoleManager.upEffectType.factionUp) then
    end
end

--武学
function RoleBreakResultNewLayer:initRoleUpBartialData(cardRole, fightType, oldPower, oldMartialLevel, func)
    if (cardRole == nil) then
        return
    end
    self.func       = func
    --
    
    local Panel_info_1      = TFDirector:getChildByPath(self.Panel_num_shengjie, 'Panel_info_1')
    local Panel_info_2      = TFDirector:getChildByPath(self.Panel_num_shengjie, 'Panel_info_2')
    local txt_xiuweiqian1   = TFDirector:getChildByPath(Panel_info_1, 'txt_xiuweiqian')
    local txt_xiuweihou1    = TFDirector:getChildByPath(Panel_info_1, 'txt_xiuweihou')
    local txt_xiuweiqian2   = TFDirector:getChildByPath(Panel_info_2, 'txt_xiuweiqian')
    local txt_xiuweihou2    = TFDirector:getChildByPath(Panel_info_2, 'txt_xiuweihou')
    txt_xiuweiqian1:setText(EnumWuxueDescType[oldMartialLevel])
    txt_xiuweihou1:setText(EnumWuxueDescType[cardRole.martialLevel])
    txt_xiuweiqian2:setText(oldPower)
    local power = cardRole.power
    if fightType then
        power = cardRole:getPowerByFightType(fightType)
    end
    txt_xiuweihou2:setText(power)
    self.img_role:setTexture(cardRole:getBigImagePath())
    self.img_title:setTexture("ui_new/role/title_shengjie.png")
    --
    local txt_skillname      = TFDirector:getChildByPath(self.Panel_shengjie, 'txt_skillname')
    local txt_skillInfo      = TFDirector:getChildByPath(self.Panel_shengjie, 'txt_skillInfo')
    local bIsMainPlayer      = cardRole:getIsMainPlayer()

    -- 1, 2, 2, 3, 3, 3, 4, 4, 4
    -- 1  2  4
    local openQuality = EnumSkillLock
    local function drawOpenSkill(index)
        local spellInfo = cardRole.spellInfoList:objectAt(index)
        if spellInfo then
            txt_skillname:setText(spellInfo.name)
            txt_skillInfo:setText(spellInfo.description)
        end
    end

    local function drawMainPlayerOpenSkill(index)
        local openLevel = openQuality[index]
        local desc = ""
        local description = ""
        for i=1,9 do
            local spellInfo = cardRole.leadingSpellInfoConfigList:objectAt(i)
            desc = ""
            description = ""
            if spellInfo.enable_quality == openLevel then
                -- print("spellInfo = ", spellInfo)
                local spell = {skillId = spellInfo.spell_id ,level = 1}
                local levelInfo = SkillLevelData:objectByID(spell)
                -- print("levelInfo",levelInfo)
                desc = desc .. levelInfo.name
                description = description .. levelInfo.description
            end
        end
        txt_skillInfo:setText(description)
        txt_skillname:setText(desc)
    end

    if oldMartialLevel ~= cardRole.martialLevel then
        local level1 = openQuality[2] - 1
        local level2 = openQuality[2]
        if oldMartialLevel == level1 and cardRole.martialLevel== level2 then
            
            if bIsMainPlayer then
               -- drawMainPlayerOpenSkill(2)
            else
                drawOpenSkill(2)
                self.Panel_shengjie:setVisible(true)
            end
            return
        end

        local level1 = openQuality[3] - 1
        local level2 = openQuality[3]
        if oldMartialLevel == level1 and cardRole.martialLevel == level2 then
            if bIsMainPlayer then
               -- drawMainPlayerOpenSkill(3)
            else
                drawOpenSkill(3)
                self.Panel_shengjie:setVisible(true)
            end
            return
        end
    end
    
end

--
--侠客升星
function RoleBreakResultNewLayer:initRoleUpStarData(cardRoleGmId, oldQuality, oldStarlevel, func)
    local cardRole = CardRoleManager:getRoleByGmid( cardRoleGmId )
    if (cardRole == nil) then
        return
    end
    self.func       = func
    --
    local trainItem_old = RoleTrainData:getRoleTrainByQuality(oldQuality, oldStarlevel, cardRole.qualityOne)
    local trainItem_new = RoleTrainData:getRoleTrainByQuality(cardRole.quality, cardRole.starlevel,cardRole.qualityOne)

    local newCardRoleData = RoleData:objectByID(cardRole.id)
    local level_up        = newCardRoleData:GetAttrLevelUp()
    --local attr_desc = {"气血成长", "武力成长", "防御成长", "内力成长", "身法成长"}
    local attr_desc = localizable.roleStartupPre_desc
    for i = 1, 5 do
        local Panel_info      = TFDirector:getChildByPath(self.Panel_num_tupo, 'Panel_info_'..i)
        if (Panel_info) then
            local txt_attr_name = TFDirector:getChildByPath(Panel_info, 'txt_xiuweiup')
            local txt_old_attr  = TFDirector:getChildByPath(Panel_info, 'txt_xiuweiqian')
            local txt_new_attr  = TFDirector:getChildByPath(Panel_info, 'txt_xiuweihou')
            --
            local old = trainItem_old.streng_then * level_up[i]
            local new = trainItem_new.streng_then * level_up[i]
            if new ~= old then
                txt_attr_name:setText(attr_desc[i])
                txt_old_attr:setText(""..old)
                txt_new_attr:setText(""..new)   
            end
        end
    end

    --
    local starlevel         = cardRole.starlevel
   
    local starImg = {'ui_new/common/xl_dadian22_icon.png', 'ui_new/common/xl_dadian23_icon.png', 'ui_new/common/xl_dadian33_icon.png'}
    local starRank = math.floor( starlevel / 5 ) 
    local starNum = math.fmod(starlevel, 5)
    if (starlevel > 0 and starNum == 0) then
        starNum = 5
        starRank = starRank - 1
    end
    for i=1,5 do
        local img_starliang      = TFDirector:getChildByPath(self.panel_star, 'img_starliang'..i)
        if (img_starliang) then
            img_starliang:setVisible(true)
            local starIdx = i
            local starTextrue = starImg[starRank]
            if i <= starNum then
                starTextrue = starImg[starRank + 1]
            end
            img_starliang:setTexture(starTextrue)
            img_starliang:setVisible(true)
        end
    end
    --激活
    local Panel_star    = TFDirector:getChildByPath(self.Panel_tupo, 'Panel_star')
    
    for i = 1, 5 do
        local img_star          = TFDirector:getChildByPath(Panel_star, 'img_star_'..i)
        local img_star_light    = TFDirector:getChildByPath(Panel_star, 'img_star_light_'..i)
        img_star_light:setVisible(false)
        if i <= starNum then
            img_star_light:setTexture(starImg[starRank + 1])
            img_star_light:setVisible(true)
        end
        img_star:setTexture(starImg[starRank])
    end
    local txt_name          = TFDirector:getChildByPath(Panel_star, 'txt_name')
    local txt_skillInfo     = TFDirector:getChildByPath(Panel_star, 'txt_skillInfo')
    --
    local roleInfoList  = RoleTalentData:GetRoleStarInfoByRoleId( cardRole.id, cardRole.quality)
    local newFunInfo    = roleInfoList:getObjectAt(cardRole.starlevel)
    local txt_skillInfo = TFDirector:getChildByPath(self.Panel_tupo, 'txt_skillInfo')
    local txt_name      = TFDirector:getChildByPath(self.Panel_tupo, 'txt_name')
    if newFunInfo then
        txt_name:setText(newFunInfo.name)
        txt_skillInfo:setText(newFunInfo.desc)
    end
    self.img_role:setTexture(cardRole:getBigImagePath())
    self.img_title:setTexture("ui_new/role/title_tupo.png")
    -- self.img_rolelevel:setTexture(GetFontByQuality(cardRole.quality))
end

--侠客升品
function RoleBreakResultNewLayer:initRoleGradeUpData(cardRoleGmId, oldQuality, oldStarlevel, func)
    local cardRole = CardRoleManager:getRoleByGmid( cardRoleGmId )
    if (cardRole == nil) then
        return
    end
    self.func       = func
    --
    local trainItem_old = RoleTrainData:getRoleTrainByQuality(oldQuality, oldStarlevel, cardRole.qualityOne)
    local trainItem_new = RoleTrainData:getRoleTrainByQuality(cardRole.quality, cardRole.starlevel,cardRole.qualityOne)

    local newCardRoleData = RoleData:objectByID(cardRole.id)
    local level_up        = newCardRoleData:GetAttrLevelUp()
    local oldarr = {}
    local newarr = {}
    local count = 0
    --local attr_desc = {"气血成长", "武力成长", "防御成长", "内力成长", "身法成长"}
    local attr_desc = localizable.roleStartupPre_desc
    for i = 1, 5 do
        local Panel_info      = TFDirector:getChildByPath(self.Panel_num_tupo, 'Panel_info_'..i)
        if (Panel_info) then
            local txt_attr_name = TFDirector:getChildByPath(Panel_info, 'txt_xiuweiup')
            local txt_old_attr  = TFDirector:getChildByPath(Panel_info, 'txt_xiuweiqian')
            local txt_new_attr  = TFDirector:getChildByPath(Panel_info, 'txt_xiuweihou')
            --
            local old = trainItem_old.streng_then * level_up[i]
            local new = trainItem_new.streng_then * level_up[i]
            -- if new ~= old then
                count = count + 1
                txt_attr_name:setText(attr_desc[i])
                txt_old_attr:setText(""..old)
                txt_new_attr:setText(""..new)   
            -- end
        end
    end
    local txt_skillname      = TFDirector:getChildByPath(self.Panel_shengjie, 'txt_skillname')
    local txt_skillInfo      = TFDirector:getChildByPath(self.Panel_shengjie, 'txt_skillInfo')
    --主角四星升五星 隐藏技能提示
    if cardRole.quality == 4 or cardRole.quality == 5 then
        self.Panel_shengjie:setVisible(false)
    else
        self.Panel_shengjie:setVisible(true)
         --显示技能
        if (not cardRole:getIsMainPlayer()) then
            local spellInfo = cardRole.spellInfoList:objectAt(4)
            if spellInfo then 
                txt_skillname:setText(spellInfo.name)
                txt_skillInfo:setText(spellInfo.description)
            end	
        else
            local spellInfo         = cardRole.leadingSpellInfoConfigList:objectAt(10)
            local replaceSpellInfo  = SkillBaseData:objectByID(spellInfo.spell_id)
            if replaceSpellInfo then
                txt_skillname:setText(replaceSpellInfo.name)
                txt_skillInfo:setText(replaceSpellInfo.description)
            end
        end
    end
    --
    self.img_role:setTexture(cardRole:getBigImagePath())
    self.img_title:setTexture("ui_new/role/title_shengpin.png")
    self.img_rolelevel:setTexture(GetFontByQuality(cardRole.quality))
end
--帮派修练
function RoleBreakResultNewLayer:initFactionData(cardRole, fightType, oldPower, oldMartialLevel, func)
    
end
--天书突破
function RoleBreakResultNewLayer:initSkyBookData(cardRole, fightType, oldPower, oldMartialLevel, func)
    --下个版本再做  2017.4.14 fei
    -- for i = 1, 5 do
    --     local img_star          = TFDirector:getChildByPath(self.panel_tianshustar, 'img_starliang'..i)
    --     img_star:setVisible(false)
    -- end
    -- --
    -- --local attr_desc = {"气血成长", "武力成长", "防御成长", "内力成长", "身法成长"}
    -- local attr_desc = localizable.roleStartupPre_desc
    -- for i = 1, 5 do
    --     local Panel_info      = TFDirector:getChildByPath(self.Panel_num_tupo, 'Panel_info_'..i)
    --     if (Panel_info) then
    --         local txt_attr_name = TFDirector:getChildByPath(Panel_info, 'txt_xiuweiup')
    --         local txt_old_attr  = TFDirector:getChildByPath(Panel_info, 'txt_xiuweiqian')
    --         local txt_new_attr  = TFDirector:getChildByPath(Panel_info, 'txt_xiuweihou')
    --         --
    --         local old = trainItem_old.streng_then * level_up[i]
    --         local new = trainItem_new.streng_then * level_up[i]
    --         if new ~= old then
    --             count = count + 1
    --             txt_attr_name:setText(attr_desc[i])
    --             txt_old_attr:setText(""..old)
    --             txt_new_attr:setText(""..new)   
    --         end
    --     end
    -- end
end
function RoleBreakResultNewLayer:onShow()
    self.super.onShow(self)
 
end

function RoleBreakResultNewLayer:refreshBaseUI()

end

function RoleBreakResultNewLayer:refreshUI()
  
end
--
function RoleBreakResultNewLayer:createEffect(effectName, zOrder, node, playCount)
  
    local resPath = "effect/"..effectName..".xml"
    TFResourceHelper:instance():addArmatureFromJsonFile(resPath)
    local effect = TFArmature:create(effectName.."_anim")
    if (effect == nil) then
        return nil
    end
    node = node or self.Panel_all
    node:addChild(effect, zOrder)
    local size = node:getSize()
    effect:setPosition(ccp(size.width / 2, size.height / 2))
    effect:setAnimationFps(GameConfig.ANIM_FPS)
    playCount = playCount or 0
    effect:playByIndex(0, -1, -1, playCount)
    effect:setVisible(true)

    -- self.effectList[effectName] = effect
    return effect
end

function RoleBreakResultNewLayer:playRoleUpEffect()

    self:createEffect("book_down", 0)
    self:createEffect("book_up", 4)
    self:createEffect("book_particle_for", 4, self.img_role, -1)

    self:createRoleActivity1()
end

function RoleBreakResultNewLayer:createRoleActivity1(roleGmId)

    local factor    = 1
    local diff      = 0.3
    local diff1     = 0
    if (self.playType == CardRoleManager.upEffectType.skyBookUp) then
        diff1 = -1
    end
    local time = 0.35
    if (CardRoleManager.addPlayEffect ~= true) then
        time = 0.09
    end
    CardRoleManager.addPlayEffect = true
    self.img_role:setScale(factor - diff - diff1)
    local size = self.Panel_all:getSize()
    local pos   = self.img_role:getPosition()
    self.img_role:setPosition(ccp(size.width / 2, size.height / 2))
    local tweenScale = 
    {
          target = self.img_role,
          {
            duration = (52 - 31) / 24,--0.9,
            scaleY = 1.1 - diff - diff1,
            scaleX = 1.1 - diff - diff1,
          },
          { 
            delay = time,--(64 - 53) / 24,--0.38,
            duration = 0,	
			scaleY = 1.461 - diff - diff1,
            scaleX = 1.461 - diff - diff1,
		  },
          {
            duration = (81 - 67) / 24,--0.5,
            scaleY = 1.6 - diff - diff1,
            scaleX = 1.6 - diff - diff1,
          },
          {
            delay = (33 - 32) / 24,--1/8,
            duration = 0,	
            scaleY = 0.55 - diff1,
            scaleX = 0.55 - diff1,
            x = pos.x, 
			y = pos.y,
            onComplete = function ()
				self:moveIn()
            end,
          },
          {
            duration = (89 - 84) / 24,--0.3,
            scaleY = 0.65 - diff1,
            scaleX = 0.65 - diff1,
          },
    }
    TFDirector:toTween(tweenScale)
end

function RoleBreakResultNewLayer:removeUI()
    self.super.removeUI(self)
    if (self.func) then
        self.func()
    end
end

function RoleBreakResultNewLayer:registerEvents()
    self.super.registerEvents(self)
    self.Panel_Touch:addMEListener(TFWIDGET_CLICK, function()
                        AlertManager:close();
                    end)
end

function RoleBreakResultNewLayer:removeEvents()
    self.super.removeEvents(self)
end


return RoleBreakResultNewLayer
