--[[
******游戏静态数据管理类*******

    -- by Stephen.tao
    -- by haidong.gan
    -- 2013/12/4
]]


-- 上线前基础数据打包优化步骤
-- 1、使用MEMapArray方式导出：t_s_npc_instance，t_s_spell_level，t_s_buffer 三张表
-- 2、打包lua_table_zip
-- 3、去掉MEDirector:LoadChunksFromZIP("lua/table/lua_table_zip.zip") 的注释
-- 4、上传最新lua_table_zip.zip

local BaseDataManager = class('BaseDataManager')
-- 优化读取文件


function BaseDataManager:ctor(...)

    -- self:BindItemData()
    -- self:BindRoleData()
    -- self:BindNPCData()
    -- self:BindLevelData();

    -- self:BindDropData()
    -- self:BindDropGroupData()
    -- self:BindRewardConfigureData()

    -- self:BindIntensifyData()
    -- self:BindGemPosData()
    -- self:BindGemData()
    -- self:BindEquipmentTemplateData()
    -- self:BindShopData()
    -- self:BindGiftPackData()
    -- self:BindProtagonistData()
    -- self:BindRoleTrainData()
    -- self:BindRoleFateData()
    -- self:BindConstantData()

    -- self:BindSkillBaseData()
    -- self:BindSkillLevelData()
    -- -- self:BindSkillAttributeData()
    -- self:BindLeadingRoleSpellData()
    -- self:BindRandomShopData()

    -- self:BindVipDataData()
    -- self:BindEscortingDataFunc()
    -- self:BindPlayerGuideData()
    -- self:BindPlayerGuideStepData()

    -- self:BindMartial()
    -- self:BindMartialRoleConfigure()
    -- self:BindMartialEnchant()

    -- self:BindDiet()
    -- self:BindPlayerResConfigure()

    -- self:BindMeridianConfigure()

    -- self:BindMoHeYaConfigure()
    -- self:BindClimbRuleConfigure()
    -- self:BindFightFailGuide()
    -- self:BindFightLoadingGuide()
    -- self:BindMenuBtnOpenData()
    -- self:BindRoleSoundData()
    -- self:BindMartialLevelExchangeData()

    -- self:FunctionOpenConfigureBindings()

    -- self:BindRoleTalentData()

    -- self:BindWorshipPlan()
    -- self:BindGuildWorship()
    -- self:BindChampionsAwardData()
    -- self:BindChampionsBoxData()

    -- self:BindAcupointBreachData()

    -- self:BindAgreeRuleData()
    -- self:BindAgreeAttributeData()
    -- self:BindBattleLimitedData()

    -- self:BindGuildZoneData()
    -- self:BindGuildZoneCheckPointData()
    -- self:BindGuildZoneDpsAwardData()

    -- self:BindGuildPracticePosData()
    -- self:BindGuildPracticeData()
    -- self:BindGuildPracticeStudyData()
    -- self:BindGuildPracticeRuleData()

    -- self:BindEquipmentRecastSubAddData()
    -- self:BindEquipmentRecastConditionData()
    -- self:BindEquipmentRecastData()
    -- self:BindMercenaryConfig()

    -- self:BindQimenConfigData()
    -- self:BindQimenBreachConfigData()
    -- self:BindGambleTypeData()
    -- self:BindGambleZxData()

    -- self:BindBibleData()
    -- self:BindBibleBreachData()
    -- self:BindAdventureRandomEventData()

    -- self:BindAdventureEventNpc()

    -- self:BindLianTiData()

    -- self:BindLianTiExtraData()

    -- self:BindPowerCompareData()

    -- self:BindQianXiuAttributeData()

    -- self:BindFundData()

    -- self:BindPeakData()

    -- self:BindZhuanJiData()

    -- self:BindZhuanJiCondData()
    -- self:BindBibleGemData()


    -- self:BindEquipmentThroughExpData()
    -- self:BindEquipmentThroughAttribData()
    -- self:BindEquipmentSpecialAttribData()

    -- self:BindFamilyData()
    -- self:BindMonthCardBuffData()
    -- self:BindBattleArrayData()
    -- self:BindBattleArrayStarData()
    -- self:BindBattleArrayLevelData()
    -- self:BindRedPacketData()
    -- self:BindRedPacketAchievementData()
    -- self:BindGetRolePriceData()
    -- self:BindEquipRecastConsumeData()

    -- self:BindPowerCompareMaxData()

end



--[[
--获取奖励物品解析
--返回 物品的名字
--返回 物品的品质
--返回 物品的数量
--返回 物品的图片路径
--]]
function BaseDataManager:getReward(data)
    local result = { };
    if data.itemId == nil and data.itemid then
        data.itemId = data.itemid
    end
    if (data.type == EnumDropType.GOODS or data.type == EnumDropType.BIBLE) and data.itemId then
        local item = ItemData:objectByID(data.itemId)
        if item == nil then
            print("获取奖励物品失败，没有找到此物品，id == " .. data.itemId)
            return
        end
        if item.type == EnumGameItemType.Soul and item.kind == 2 then
            result = {
                name = item.name,
                quality = item.quality,
                number = data.number or 1,
                path = MainPlayer:getProfessionIconPath(),
                desc = item.details
            }
        else
            result = {
                name = item.name,
                quality = item.quality,
                number = data.number or 1,
                path = item:GetPath(),
                desc = item.details
            }
        end
    elseif data.type == EnumDropType.ROLE and data.itemId then
        local role = RoleData:objectByID(data.itemId)
        if role == nil then
            print("获取奖励物品(角色卡牌)失败，没有找到此角色卡牌，id == " .. data.itemId)
            return
        end
        result = {
            name = role.name,
            quality = role.quality,
            number = data.number or 1,
            path = role:getIconPath(),
            desc = role.description
        }
    elseif data.type == EnumDropType.COIN then
        result = {
            name = "Đồng tiền xu",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/qhp_tb_icon.png",
            desc = "Các đồng xu là các thiết bị để tăng cường, vai trò của thói quen. chơi một sự tiêu thụ nguồn lực"
        }
    elseif data.type == EnumDropType.SYCEE then
        result = {
            name = "Nguyên bảo",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/qhp_yb_icon.png",
            desc = "Các Nguyên bảo có thể ở trung Tâm tuyển dụng thẻ và mua hàng"
        }
    elseif data.type == EnumDropType.GENUINE_QI then
        result = {
            name = "Chân Khí",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/icon_zhenqi.png",
            desc = "Chân Khí có thể được sử dụng để nâng cao vai trò của các tuyến"
        }
    elseif data.type == EnumDropType.HERO_SCORE then
        result = {
            name = "Điểm Quần hào phổ",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/qhp_jifen.png",
            desc = "Điểm Quần hào phổ có thể được sử dụng để ở trong một nhóm Hồ quang phổ mua hàng"
        }
    elseif data.type == EnumDropType.EXP then
        result = {
            name = "Kinh nghiệm đội",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/icon_exp.png",
            desc = "Kinh nghiệm đội"
        }
    elseif data.type == EnumDropType.ROLE_EXP then
        result = {
            name = "Kinh nghiệm nhân vật",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/icon_exp.png",
            desc = "Kinh nghiệm nhân vật"
        }

    elseif data.type == EnumDropType.VIP_SCORE then
        result = {
            name = "VIP积分",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/icon_vip.png",
            desc = "VIP积分"
        }

    elseif data.type == EnumDropType.XIAYI then
        result = {
            name = "Hào hiệp giá trị",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/icon_xiayi2.png",
            desc = "Hào hiệp giá trị"
        }

    elseif data.type == EnumDropType.PUSH_MAP then
        result = {
            name = "Thể lực",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/img_tili.png",
            desc = "Thể lực"
        }
    elseif data.type == EnumDropType.RECRUITINTEGRAL then
        result = {
            name = "Điểm hoạt động",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/lianchoujifen.png",
            desc = "Bằng cách tham gia trong tương ứng hoạt động được, trả lại cho nhiều phần thưởng miễn phí"
        }
    elseif data.type == EnumDropType.VESSELBREACH then
        result = {
            name = "Tinh lộ",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/climb/wl_jinglu.png",
            desc = "Tinh lộ có thể được sử dụng cho Xung đột phá"
        }
    elseif data.type == EnumDropType.FACTION_GX then
        result = {
            name = "Cống hiến Bang",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/faction/icon_gongxianbig.png",
            desc = "Tham gia trong Bang phái để chơi phương pháp để có được có thể được sử dụng trong những Bang phái cửa hàng để mua hiếm đạo cụ."
        }
    elseif data.type == EnumDropType.CLIMBSTAR then
        result = {
            name = "Bát quái tinh nguyên",
            quality = 4,
            number = data.number or 1,
            path = "ui_new/climb/wl_xx.png",
            desc = "Vô đỉnh núi đạt trong tương ứng thách thức ra có thể được sử dụng để lẻ cửa, để khám phá những nhân vật chính của nền văn hóa."
        }
    elseif data.type == EnumDropType.YUELI then
        result = {
            name = localizable.youli_drop_tips1,
            quality = 4,
            number = data.number or 1,
            path = "ui_new/tianshu/yuelibig.png",
            desc = localizable.youli_yueli_des
        }
    elseif data.type == EnumDropType.SHALU_VALUE then
        result = {
            name = localizable.youli_drop_tips2,
            quality = 4,
            number = data.number or 1,
            path = "ui_new/youli/icon_skillscore.png",
            desc = localizable.youli_shalu_des
        }
    elseif data.type == EnumDropType.TEMP_COIN then
        result = {
            name = localizable.youli_drop_tips3,
            quality = 4,
            number = data.number or 1,
            path = "ui_new/common/qhp_tb_icon.png",
            desc = localizable.youli_coin_des
        }
    elseif data.type == EnumDropType.TEMP_YUELI then
        result = {
            name = localizable.youli_drop_tips1,
            quality = 4,
            number = data.number or 1,
            path = "ui_new/tianshu/yuelibig.png",
            desc = localizable.youli_yueli_des
        }
    elseif data.type == EnumDropType.LOWHONOR then
        result = {
            name = localizable.multiFight_lowhonor,
            quality = 4,
            number = data.number or 1,
            path = "ui_new/wulin/icon_ryl2.png",
            desc = localizable.multiFight_lowhonor_des
        }
    elseif data.type == EnumDropType.HIGHTHONOR then
        result = {
            name = localizable.multiFight_highthonor,
            quality = 5,
            number = data.number or 1,
            path = "ui_new/wulin/icon_ryl.png",
            desc = localizable.multiFight_highthonor_des
        }
    elseif data.type == EnumDropType.PEAK_SCORE then
        result = {
            name = localizable.ResourceName[data.type],
            quality = 4,
            number = data.number or 1,
            path = "ui_new/lunjian/img_score.png",
            desc = localizable.LunJianFeng_peak_score_des
        }
    elseif data.type == EnumDropType.TIANXIANG_COIN then
        result = {
            name = localizable.ResourceName[data.type],
            quality = 4,
            number = data.number or 1,
            path = "ui_new/climb/icon_txb_big.png",
            desc = localizable.Xiling_txt_res_desc2
        }
    elseif data.type == EnumDropType.TIANJI_COIN then
        result = {
            name = localizable.ResourceName[data.type],
            quality = 5,
            number = data.number or 1,
            path = "ui_new/climb/icon_tjb_big.png",
            desc = localizable.Xiling_txt_res_desc3
        }
    elseif data.type == EnumDropType.RECHARGE_TICKET then
        local itemId = 1
        if data.itemId then
            if data.itemId > 0 and data.itemId <= 6 then
                itemId = data.itemId
            elseif data.itemId <= 12 then
                itemId = data.itemId - 6
            end
        end

        -- result = {
        --     name = localizable.ResourceName[data.type],
        --     quality = 5,
        --     number = data.number or 1,
        --     path = "ui_new/pay/ticket_icon" .. itemId .. ".png",
        --     desc = localizable.RechargeTicket_desc1
        -- }
        local item = RechargeTicketData:objectByID(data.itemId)
        result = {
            name = localizable.ResourceName[data.type],
            quality = 5,
            number = data.number or 1,
            path = "ui_new/pay/ticket_icon" .. itemId .. ".png",
            desc = item.desc
        }
    end

    result.itemid = data.itemId;
    result.type = data.type;

    return result
end

-- 绑定侠客升星表函数
function BaseDataManager:BindRoleTalentData()

    function RoleTalentData:GetRoleSupperStarInfoByRoleId(role_id)
        -- 获取神技技能
        local RoleStarInfoArray = { }
        for v in RoleTalentData:iterator() do
            if v.role_id == role_id and v.break_type == 2 then
                table.insert(RoleStarInfoArray, v)
            end
        end
        table.sort(RoleStarInfoArray, function(a, b)
            return a.star_lv < b.star_lv
        end )
        return RoleStarInfoArray
    end

    function RoleTalentData:GetRoleStarInfoByRoleId(role_id)
        local RoleStarInfoArray = MEArray:new()
        for v in RoleTalentData:iterator() do
            if v.role_id == role_id then
                RoleStarInfoArray:push(v)
            end
        end
        return RoleStarInfoArray
    end
    function RoleTalentData:GetRoleStarOtherGoods(role_id, star_lv)
        local RoleOtherGoods = { }
        for v in RoleTalentData:iterator() do
            if v.role_id == role_id and v.star_lv == star_lv then
                if #v.other_goods_id > 0 then
                    local activity = string.split(v.other_goods_id, '_')
                    local propId = tonumber(activity[1])
                    local propNum = tonumber(activity[2])
                    RoleOtherGoods[propId] = propNum
                    return RoleOtherGoods;
                end
            end
        end
        return nil
    end
end

-- 绑定物品数据的函数
function BaseDataManager:BindItemData()

    -- 通过装备类型获得此类型的装备集合
    --ItemData = _G["ItemData"]
    function ItemData:GetEquipmentByEquipType(equiptype)
        local EquipmentArray = MEArray:new()
        for v in ItemData:iterator() do
            if v.type == 1 and v.kind == equiptype then
                EquipmentArray:push(v)
            end
        end
        return EquipmentArray
    end

    -- 通过物品类型获得此类型的物品集合（分道具及装备）
    function ItemData:GetArrayByType(ItemType)
        local ItemArray = MEArray:new()
        for v in ItemData:iterator() do
            if v.type == ItemType then
                ItemArray:push(v)
            end
        end
        return ItemArray
    end

    -- 通过道具类型获得此类型的道具集合
    function ItemData:GetItemByType(ItemType, ItemKind)
        local ItemArray = MEArray:new()
        for v in ItemData:iterator() do
            if v.type == ItemType and v.kind == ItemKind then
                ItemArray:push(v)
            end
        end
        return ItemArray
    end

    -- 通过道具类型获得此类型的道具集合
    function ItemData:GetItemByTypeAndQuality(ItemType, ItemKind, quality)
        local ItemArray = MEArray:new()
        for v in ItemData:iterator() do
            if v.type == ItemType and v.kind == ItemKind and v.quality == quality then
                ItemArray:push(v)
            end
        end
        return ItemArray
    end

    -- 绑定单个装备数据的函数
    local equipmentitem_mt = { }
    equipmentitem_mt.__index = equipmentitem_mt
    function equipmentitem_mt:GetPath()
        local path = "icon/item/" ..(self.display) .. ".png"
        return path
    end

    function equipmentitem_mt:getKind()
        return self.kind
    end

    function equipmentitem_mt:getType()
        return self.type
    end

    -- 绑定单个道具数据的函数
    local item_mt = { }
    item_mt.__index = item_mt
    -- 获得道具的图片路径
    function item_mt:GetPath()
        local path = "icon/item/" .. self.display .. ".png"
        if self.type == EnumGameItemType.Soul then
            if self.kind == 2 then
                path = MainPlayer:getProfessionIconPath()
            else
                path = "icon/roleicon/" .. self.display .. ".png"
            end
        end
        return path
    end

    function item_mt:GetHeadPath()
        local path = "icon/item/" .. self.display .. ".png"
        if self.type == EnumGameItemType.Soul then
            path = "icon/head/" .. self.display .. ".png"
        end
        return path
    end

    function item_mt:getType()
        return self.type
    end

    function item_mt:getKind()
        return self.kind
    end

    -- 判断物品是否为碎片
    function item_mt:isFragment()
        if self.type == EnumGameItemType.Soul then
            return true
        end
        if self.type == EnumGameItemType.Piece then
            return true
        end
        return false
    end

    -- 对所有的数据进行函数绑定
    for item in ItemData:iterator() do
        if item.type == EnumGameItemType.Equipment then
            item.__index = equipmentitem_mt
            setmetatable(item, equipmentitem_mt)
        else
            item.__index = item_mt
            setmetatable(item, item_mt)
        end
    end
end

-- 绑定角色数据的函数
function BaseDataManager:BindRoleData()
    -- 绑定单个角色的函数
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:GetAttr()
        return GetAttrByString(self.attribute)
    end

    function item_mt:getOutline()

        local list = { };
        local strArr = string.split(self.outline, '、');
        for i, str in ipairs(strArr) do
            list[i] = str;
        end
        return list;
    end

    function item_mt:getLeadingSpellSkillConfig()
        -- 主角特殊处理 主角第四个技能

        if (ProtagonistData:IsMainPlayer(self.id)) then
            for spellInfoConfig in LeadingRoleSpellData:iterator() do
                if spellInfoConfig.role_id == self.id and spellInfoConfig.type == 4 then
                    return spellInfoConfig
                end
            end
        end
        return nil
    end


    function item_mt:getLeadingSpellInfoConfigList()
        -- 主角特殊处理
        local spellInfoConfigList = MEArray:new();
        if (ProtagonistData:IsMainPlayer(self.id)) then
            for spellInfoConfig in LeadingRoleSpellData:iterator() do
                if spellInfoConfig.role_id == self.id then
                    spellInfoConfigList:push(spellInfoConfig)
                end
            end
        end
        return spellInfoConfigList;
    end

    function item_mt:getLeadingSpellInfoList()
        -- 主角特殊处理
        local spellInfoList = MEArray:new();
        if (ProtagonistData:IsMainPlayer(self.id)) then
            for spellInfoConfig in LeadingRoleSpellData:iterator() do
                if spellInfoConfig.role_id == self.id then
                    local spellInfoItem = SkillBaseData:objectByID(spellInfoConfig.spell_id);
                    spellInfoList:push(spellInfoItem)
                end
            end
        end
        return spellInfoList;
    end

    function item_mt:getSpellInfoList()
        -- 主角特殊处理
        local spellInfoList = MEArray:new();


        if (not ProtagonistData:IsMainPlayer(self.id)) then
            spellInfoList:push(SkillBaseData:objectByID(self.skill));

            local skillIdArr = string.split(self.passive_skill, ',');
            for i, skillId in ipairs(skillIdArr) do
                spellInfoList:push(SkillBaseData:objectByID(tonumber(skillId)));
            end
            if self.skill_2 ~= 0 then
                spellInfoList:push(SkillBaseData:objectByID(tonumber(self.skill_2)));
            end
        end
        return spellInfoList;
    end

    -- 获得角色的属性系数
    function item_mt:GetAttrLevelUp()
        return GetAttrByString(self.level_up)
    end
    -- 获取角色图片
    function item_mt:getHeadPath()
        return "icon/head/" .. self.image .. ".png"
    end
    function item_mt:getIconPath()
        return "icon/roleicon/" .. self.image .. ".png"
    end
    function item_mt:getBigImagePath()
        return "icon/rolebig/" .. self.image .. ".png"
    end
    -- function item_mt:getImagePath()
    --  return  "icon/role/" .. self.image ..".png"
    -- end

    RoleData.item_mt = item_mt;
    for item in RoleData:iterator() do
        if type(item) == "table" then
            item.__index = item_mt
            setmetatable(item, item_mt)
            -- local new_name = roleSql:getData(item.id)
            -- if new_name ~= nil then
            --  item.name = new_name
            -- end
        end
    end
end

function BaseDataManager:BindNPCData()

    function NPCData:GetNPCListByIds(idsStr)
        local list = { };
        local idArr = string.split(idsStr, ',');
        for i, id in ipairs(idArr) do
            local item = self:objectByID(tonumber(id));
            list[i] = item;
        end
        return list;
    end


    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getHeadPath()
        return "icon/head/" .. self.image .. ".png"
    end
    function item_mt:getIconPath()
        return "icon/roleicon/" .. self.image .. ".png"
    end
    -- function item_mt:getImagePath()
    --  return  "icon/role/".. self.image..".png"
    -- end

    NPCData.item_mt = item_mt;

    for item in NPCData:iterator() do
        if type(item) == "table" then
            item.__index = item_mt
            setmetatable(item, item_mt)
        end
    end
end

function BaseDataManager:BindLevelData()
    function LevelData:getTotalRoleExp(level)
        local totalExp = 0;
        for v in LevelData:iterator() do
            if v.lv < level then
                totalExp = totalExp + v.role_exp;
            end
        end
        return totalExp;
    end
    function LevelData:getMaxRoleExp(level)
        local levelItem = self:getObjectAt(level)
        if levelItem then
            return levelItem.role_exp
        end
        return 0;
    end

    function LevelData:getTotalPlayerExp(level)
        local totalExp = 0;
        for v in LevelData:iterator() do
            if v.lv < level then
                totalExp = totalExp + v.player_exp;
            end
        end
        return totalExp;
    end
    function LevelData:getMaxPlayerExp(level)
        local levelItem = self:getObjectAt(level)
        if levelItem then
            return levelItem.player_exp
        end
        return 0;
    end
end

-- 绑定掉落表数据
function BaseDataManager:BindDropData()
    -- 绑定单个掉落表数据
    local item_mt = { }
    item_mt.__index = item_mt
    -- 获得对应的掉落物品
    function item_mt:GetBaseItem()
        local temptb = { };
        temptb.itemid = self.itemid;
        temptb.type = self.type;
        temptb.number = self.maxamount;

        return BaseDataManager:getReward(temptb);

        -- if self.type == EnumDropType.GOODS then
        --  --装备
        --  local item = ItemData:objectByID(self.itemid);
        --  if math.floor(item.type/10) == EnumGameItemType.Equipment then
        --      return item;
        --  end
        --  return nil;
        -- elseif self.type == EnumDropType.ROLE then
        --  --角色
        --  return ItemData:objectByID(self.itemid);
        -- end
    end


    for item in DropData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

-- 绑定掉落组表数据
function BaseDataManager:BindDropGroupData()

    function DropGroupData:GetDropItemListByIdsStr(idsStr)
        local dropItemList = MEArray:new();

        local dropGroupArr = string.split(idsStr, ',');
        for i, dropGroupId in ipairs(dropGroupArr) do
            local dropGroupItem = self:objectByID(tonumber(dropGroupId));
            if dropGroupItem then
                local list = dropGroupItem:GetDropItemList();
                for dropItem in list:iterator() do
                    dropItemList:push(dropItem);
                end
            end
        end
        return dropItemList;
    end

    function DropGroupData:GetShowDropItemByIdsStr(idsStr)
        local dropItemList = self:GetDropItemListByIdsStr(idsStr);
        return dropItemList:front();
    end

    -- 绑定单个掉落组数据
    local item_mt = { }
    item_mt.__index = item_mt
    -- 获得建议显示的掉落物品
    function item_mt:GetShowDropItem()
        local dropItemList = self:GetDropItemList();
        return dropItemList:front();
    end

    function item_mt:GetDropItemList()
        local dropItemList = MEArray:new();
        local dropidmakeupArr = string.split(self.dropidmakeup, ',')
        for i, dropId in ipairs(dropidmakeupArr) do
            local dropItem = DropData:objectByID(tonumber(dropId));
            if dropItem then
                local baseItem = dropItem:GetBaseItem();
                if baseItem then
                    dropItemList:push(baseItem);
                end
            end
        end
        return dropItemList;
    end


    for item in DropGroupData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

-- 绑定奖励配置表的函数
function BaseDataManager:BindRewardConfigureData()

    function RewardConfigureData:GetRewardItemListById(id)
        local rewardConfig = RewardConfigureData:objectByID(id);
        if rewardConfig then
            return rewardConfig:getReward();
        end
    end

    -- 绑定单个奖励配置的函数
    local item_mt = { }
    item_mt.__index = item_mt
    -- 获得奖励配置
    function item_mt:getReward()
        local rewardList = MEArray:new()
        local temptbl = string.split(self.reward_conf, ',')
        -- 分解"|"
        for k, v in pairs(temptbl) do
            local reward = RewardItemData:objectByID(tonumber(v))
            if reward then
                local commonReward = { }
                commonReward.type = reward.type;
                commonReward.itemId = reward.item_id;
                commonReward.number = reward.number;
                rewardList:push(BaseDataManager:getReward(commonReward))
            end
        end
        return rewardList
    end


    -- 对所有的数据进行函数绑定
    for item in RewardConfigureData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

-- 绑定三十六天罡奖励的函数
function BaseDataManager:BindThirtySixRewardData()
    ThirtySixRewardData.RewardArray = { }
    ThirtySixRewardData.RewardArray[1] = MEArray:new()
    ThirtySixRewardData.RewardArray[2] = MEArray:new()
    ThirtySixRewardData.RewardArray[3] = MEArray:new()

    function ThirtySixRewardData:getRewardByindex(type, index)
        if self.RewardArray[type] then
            return self.RewardArray[type]:getObjectAt(index)
        end
    end

    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    -- 获得奖励
    function item_mt:getReward()
        local rewardConfigure = RewardConfigureData:objectByID(self.reward_id)
        if rewardConfigure then
            return rewardConfigure:getReward()
        end
    end


    for item in ThirtySixRewardData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
        ThirtySixRewardData.RewardArray[(item.type + 1)]:push(item)
    end
end

-- 绑定强化数据的函数
function BaseDataManager:BindIntensifyData()
    -- 获取强化消耗（目前为铜币）
    function IntensifyData:getConsumeByIntensifyLevel(intensifyLevel, quality)
        local data = IntensifyData:objectByID(intensifyLevel)
        if data then
            if quality == 5 then
                return data.shen
            elseif quality == 4 then
                return data.jia
            elseif quality == 3 then
                return data.yi
            elseif quality == 2 then
                return data.bing
            elseif quality == 1 then
                return data.ding
            else
                return nil
            end
        end
        return nil
    end

    -- --绑定单个强化的函数
    -- local item_mt = {}
    -- item_mt.__index = item_mt

    -- --对所有的数据进行函数绑定
    -- for item in IntensifyData:iterator() do
    --  item.__index = item_mt
    --  setmetatable(item, item_mt)
    -- end
end

-- 绑定宝石数据的函数
function BaseDataManager:BindGemData()
    -- 绑定单个宝石的函数
    local item_mt = { }
    item_mt.__index = item_mt
    -- 获得强化的初始金钱及每级的递增值
    function item_mt:getAttribute()
        local attribute = string.split(self.attribute, '_')
        if attribute == nil then
            print("Viên ngọc không thuộc tính")
            return
        end
        return tonumber(attribute[1]), tonumber(attribute[2])
    end

    -- 对所有的数据进行函数绑定
    for item in GemData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end
-- 绑定宝石位置数据的函数
function BaseDataManager:BindGemPosData()
    -- 绑定单个宝石的函数
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getGemKind()
        local attribute = string.split(self.kind, '_')
        if attribute == nil then
            print("Viên ngọc không thuộc tính")
            return nil
        end
        return attribute
    end

    function GemPosData:getConfigByTypeAndPos(equip_type, pos)
        -- print("equip_type , pos = ",equip_type , pos)
        for item in GemPosData:iterator() do
            if equip_type == item.id and pos == item.pos then
                return item
            end
        end
    end

    -- 对所有的数据进行函数绑定
    for item in GemPosData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

-- 绑定打造数据的函数
function BaseDataManager:BindEquipmentTemplateData()

    function EquipmentTemplateData:findByPieceId(pieceId)
        for v in EquipmentTemplateData:iterator() do
            if v.fragment_id == pieceId then
                return v;
            end
        end
        return nil
    end

    -- 绑定单个打造的函数
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAttribute()
        local max_attribute = { }
        local base_attribute = GetAttrByString(self.base_attribute)
        local base_interval = GetAttrByString(self.base_interval)
        for i = 1, EnumAttributeType.Max - 1 do
            if base_attribute[i] then
                local interval = base_interval[i] or 0
                max_attribute[i] = base_attribute[i] + interval
            end
        end
        return base_attribute, max_attribute
    end

    function item_mt:getExtraAttribute(tupoLevel)
        local max_attribute = { }
        local extra_attribute = GetAttrByString(self.extra_attribute)
        local extra_interval = self:getExtraInterval(tupoLevel)
        for i = 1, EnumAttributeType.Max - 1 do
            if extra_attribute[i] then
                local interval = extra_interval[i] or 0
                max_attribute[i] = extra_attribute[i] + interval
            end
        end
        return extra_attribute, max_attribute, extra_interval
    end

    function item_mt:getExtraAttributeIndex(index, value)
        local len = self.extraIntervalArray:length()
        local count = 0

        for v in self.extraIntervalArray:iterator() do
            count = count + 1
            local att = v[index] or 0
            if value < att then
                return count - 1, len
            end
        end

        return count, len
    end

    --[[
    获取装备附加属性精炼进度配置，按照精炼等级分段配置
    ]]
    function item_mt:getExtraIntervalTable()
        return self.extraIntervalArray
        -- if self.extraIntervalArray then
        --  return self.extraIntervalArray
        -- end
        -- local tbl = MEArray:new()
        -- local temptbl = string.split(self.extra_interval,';')            --分解";"
        -- for k,v in pairs(temptbl) do
        --  if v and string.len(v) > 0 then
        --      local extra_interval = GetAttrByString(v)
        --      tbl:pushBack(extra_interval)
        --  end
        -- end
        -- self.extraIntervalArray = tbl
        -- return tbl
    end

    --[[
    根据精炼等级获取精炼进度配置
    ]]
    function item_mt:getExtraInterval(refineLevel)
        if refineLevel == nil then
            print("refineLevel is nil ")
            return { }
        end

        -- print("refineLevel is  ", refineLevel)

        self:getExtraIntervalTable()

        local attribute = { }

        -- if not self.extraIntervalArray or self.extraIntervalArray:length() < 1 then
        --  return nil
        -- end
        local len = self.extraIntervalArray:length()
        if len == 0 or refineLevel < 0 then
            return { }
        end

        if len <=(refineLevel + 1) then
            attribute = self.extraIntervalArray:back()
        else
            attribute = self.extraIntervalArray:objectAt(refineLevel + 1)
        end

        return attribute
        -- GetAttrByString(attribute)
    end

    function item_mt:getStarUpCost(level)
        if self.starUpCost == nil then
            self.starUpCost = self:initStarUpCost()
        end
        return self.starUpCost[level]
    end

    function item_mt:initStarUpCost()
        local tbl = { }
        local temptbl = string.split(self.star_level_up_consume, ',')
        -- 分解"|"
        for k, v in pairs(temptbl) do
            tbl[k] = tonumber(v)
        end
        return tbl
    end

    -- 对所有的数据进行函数绑定
    for item in EquipmentTemplateData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)

        local tbl = MEArray:new()
        local temptbl = string.split(item.extra_interval, ';')
        -- 分解";"
        for k, v in pairs(temptbl) do
            if v and string.len(v) > 0 then
                local extra_interval = GetAttrByString(v)
                tbl:pushBack(extra_interval)
            end
        end
        item.extraIntervalArray = tbl
    end
end


-- 绑定静态商店数据的函数
function BaseDataManager:BindShopData()
    -- 绑定单个商店的函数
    local item_mt = { }
    item_mt.__index = item_mt

    -- 是否有限制
    function item_mt:isLimited()
        return self.is_is_limited ~= 0 and self.limit_type ~= 0 and self.max_type ~= 0
    end

    -- 是否购买次数限制
    function item_mt:isLimiteCount()
        if not self:isLimited() then return false end
        if bit_and(self.limit_type, 1) == 1 then
            return true
        end
        return false
    end

    -- 是否购买时间限制
    function item_mt:isLimiteTime()
        if not self:isLimited() then return false end
        if bit_and(self.limit_type, 2) == 2 then
            return true
        end
        return false
    end

    -- 是否VIP等级限制
    function item_mt:isLimiteVip()
        if not self:isLimited() then return false end
        if bit_and(self.limit_type, 4) == 4 then
            return true
        end
        return false
    end

    --[[
    是否按照VIP等级购买次数不一样
    ]]
    function item_mt:isVipBuyCount()
        if not self:isLimiteCount() then return false end
        if self.max_type == 3 or self.max_type == 4 then
            return true
        end
        return false
    end

    --[[
    是否VIP等级提升后可以购买更多
    @return true or false
    ]]
    function item_mt:isVipLevelUpIncreaseNum(vip)
        if vip >= 15 then
            return false
        end

        if not self:isVipBuyCount() then
            return false
        end

        if self.max_num_table == nil then
            self:initMaxNum()
        end

        local currentNum = self.max_num_table[vip]
        if not currentNum then
            return false
        end

        for i = vip, 15 do
            if self.max_num_table[i] and self.max_num_table[i] > currentNum then
                return true
            end
        end
        return false
    end

    -- 获取限制购买数量
    function item_mt:getMaxNum(vip)
        if self:isLimited() then
            if self:isVipBuyCount() then
                if self.max_num_table == nil then
                    self:initMaxNum()
                end
                return self.max_num_table[vip]
            else
                return self.max_num
            end
        end
        return 0
    end

    function item_mt:initMaxNum()
        if self:isLimited() and self:isVipBuyCount() then
            local tal = GetAttrByString(self.vip_max_num_map)
            local temp = 0
            for i = 0, 15 do
                tal[i] = tal[i] or temp
                temp = tal[i]
            end
            self.max_num_table = tal
        end
    end

    -- 验证当前商品是否物品类型
    function item_mt:isGoods()
        if self.res_type == EnumDropType.GOODS then
            return true
        end
        return false
    end

    -- 验证当前商品是否角色（完整）类型
    function item_mt:isRole()
        if self.res_type == EnumDropType.ROLE then
            return true
        end
        return false
    end

    --[[
        获取商品的数据模板，如果商品类型为物品则返回t_s_goods表格中的数据，如果为角色则返回t_s_role表格中的数据
    ]]
    function item_mt:getTemplate()
        if self:isGoods() then
            return ItemData:objectByID(self.res_id)
        elseif self:isRole() then
            return RoleData:objectByID(self.res_id)
        end
        return nil
    end

    -- 对所有的数据进行函数绑定
    for item in ShopData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

-- 绑定打造数据的函数
function BaseDataManager:BindForgingData()
    -- 绑定单个打造的函数

    function ForgingData:getForgingByLevelAndKind(level, kind)
        for v in ForgingData:iterator() do
            if v.level == level and v.product_type == kind then
                return v
            end
        end
        return nil
    end

    -- local item_mt = {}
    -- item_mt.__index = item_mt
    -- for item in ForgingData:iterator() do
    --  item.__index = item_mt
    --  setmetatable(item, item_mt)
    -- end
end

-- 绑定基础常量配置
function BaseDataManager:BindConstantData()
    function ConstantData:getValue(key)
        if ConstantData:objectByID(key) == nil then
            return 0
        end
        return ConstantData:objectByID(key).value;
    end

    function ConstantData:getResID(key)
        if ConstantData:objectByID(key) == nil then
            return 0
        end
        return ConstantData:objectByID(key).res_id;
    end
end



-- 绑定技能数据的函数
function BaseDataManager:BindSkillBaseData()
    -- 绑定单个技能的函数
    local item_mt = { }
    item_mt.__index = item_mt



    function item_mt:GetLevelItem(level)
        return SkillLevelData:getInfoBySkillAndLevel(self.id, level)
        -- for id,v in pairs(SkillLevelData:getMap()) do
        --  if math.floor(id/100) == self.id and math.floor(id%100) == level  then
        --      return SkillLevelData:getTableObj(v)
        --  end
        -- end
        -- local level_info = SkillAttributeData:objectByID(level)
        -- local tbl = clone(self)
        -- tbl.uplevel_cost = level_info.uplevel_cost
        -- if type(tbl.target_num ) == "string" then
        --  tbl.target_num = GetVauleByStringRange( tbl.target_num , level)
        -- end
        -- if tbl.attr_add ~= "" then
        --  tbl.attr_add = splitLevelAttrAdd(tbl.attr_add , level)
        -- end

        -- if tbl.type == 2 then
        --  tbl.effect_value = tbl.effect_value * level_info.attr_add_1
        -- else
        --  if type(tbl.effect_value) ~= "string" then
        --      tbl.effect_value = splitLevelValue(tbl.effect_value ,level )
        --  end
        -- end
        -- if type(tbl.effect_rate) == "string" then
        --  tbl.effect_rate = splitLevelValue(tbl.effect_rate ,level)
        -- end
        -- if type(tbl.trigger_hp) == "string" then
        --  tbl.trigger_hp = splitLevelValue(tbl.trigger_hp ,level)
        -- end

        -- if tbl.extra_hurt ~= 0 then
        --  tbl.extra_hurt = tbl.extra_hurt * level_info.extra_hurt
        -- end
        -- if type(tbl.buff_targetnum ) == "string" then
        --  tbl.buff_targetnum = GetVauleByStringRange( tbl.buff_targetnum , level)
        -- end
        -- if type(tbl.buff_rate) == "string" then
        --  tbl.buff_rate = splitLevelValue(tbl.buff_rate ,level)
        -- end
        -- if tbl.power_zhanli ~= 0 then
        --  tbl.power_zhanli = tbl.power_zhanli * level_info.power
        -- end
        -- return tbl;
    end

    function item_mt:getChangeStr()
        return string.split(self.level_up_change, ',');
    end

    function item_mt:GetPath()
        return "icon/skill/" .. self.icon_id .. ".png"
    end

    function item_mt:getTichTextDes(spellLevelInfo, description)

        if self.hidden_skill == 1 then
            description = description:gsub("#type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Kỹ năng thụ động" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Kỹ năng thụ động" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        else
            description = description:gsub("#type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. SkillTypeStr[self.type] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. SkillTypeStr[self.type] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        description = description:gsub("#target_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. SkillTargetTypeStr[self.target_type] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&target_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. SkillTargetTypeStr[self.target_type] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        if self.target_sex and self.target_sex ~= 0 then
            description = description:gsub("#target_sex#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. SkillSexStr[self.target_sex] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&target_sex&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. SkillSexStr[self.target_sex] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if self.effect and self.effect ~= 0 then
            description = description:gsub("#effect#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. SkillEffectStr[self.effect] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&effect&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. SkillEffectStr[self.effect] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        if self.trigger_rate and self.trigger_rate ~= 0 then
            description = description:gsub("#trigger_rate#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] ..(self.trigger_rate / 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&trigger_rate&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] ..(self.trigger_rate / 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        description = description:gsub("#target_num#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. spellLevelInfo.target_num .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&target_num&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. spellLevelInfo.target_num .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        if spellLevelInfo.effect_rate and spellLevelInfo.effect_rate ~= 0 then
            description = description:gsub("#effect_rate#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] ..(spellLevelInfo.effect_rate / 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&effect_rate&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] ..(spellLevelInfo.effect_rate / 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        if spellLevelInfo.buff_hurt and spellLevelInfo.buff_hurt ~= 0 then
            description = description:gsub("#buff_hurt#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. SkillBuffHurtStr[spellLevelInfo.buff_hurt] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&buff_hurt&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. SkillBuffHurtStr[spellLevelInfo.buff_hurt] .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        description = description:gsub("#extra_hurt#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. spellLevelInfo.extra_hurt .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_hurt&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. spellLevelInfo.extra_hurt .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#outside#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] ..(spellLevelInfo.outside * 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&outside&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] ..(spellLevelInfo.outside * 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#inside#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] ..(spellLevelInfo.inside * 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inside&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] ..(spellLevelInfo.inside * 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#ice#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. spellLevelInfo.ice .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&ice&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. spellLevelInfo.ice .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#fire#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. spellLevelInfo.fire .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&fire&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. spellLevelInfo.fire .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#poison#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. spellLevelInfo.poison .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&poison&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. spellLevelInfo.poison .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#effect_value_#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] ..(spellLevelInfo.effect_value / 100) .. [[%%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&effect_value_&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] ..(spellLevelInfo.effect_value / 100) .. [[%%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#effect_value#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. spellLevelInfo.effect_value .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&effect_value&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. spellLevelInfo.effect_value .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#trigger_hp#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. spellLevelInfo.trigger_hp .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&trigger_hp&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. spellLevelInfo.trigger_hp .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#triggerSkill_rate#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] ..(spellLevelInfo.triggerSkill_rate / 100) .. [[%%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&triggerSkill_rate&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] ..(spellLevelInfo.triggerSkill_rate / 100) .. [[%%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        -- print("spellLevelInfo:",spellLevelInfo)

        if spellLevelInfo.buff_rate and spellLevelInfo.buff_rate ~= 0 then
            description = description:gsub("#buff_rate#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] ..(spellLevelInfo.buff_rate / 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&buff_rate&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] ..(spellLevelInfo.buff_rate / 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if spellLevelInfo.buff_id and spellLevelInfo.buff_id ~= 0 then
            description = BaseDataManager:getbuffDes(spellLevelInfo, description)
        end
        if spellLevelInfo.extra_buffid and spellLevelInfo.extra_buffid ~= 0 then
            description = BaseDataManager:getExtrabuffDes(spellLevelInfo, description)
            description = description:gsub("#extra_targe_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. SkillTargetTypeStr[self.extra_targe_type] .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_targe_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. SkillTargetTypeStr[self.extra_targe_type] .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

            description = description:gsub("#extra_buff_targetnum#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. spellLevelInfo.extra_buff_targetnum .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_buff_targetnum&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. spellLevelInfo.extra_buff_targetnum .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            if spellLevelInfo.extra_buff_rate and spellLevelInfo.extra_buff_rate ~= 0 then
                description = description:gsub("#extra_buff_rate#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] ..(spellLevelInfo.extra_buff_rate / 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
                description = description:gsub("&extra_buff_rate&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] ..(spellLevelInfo.extra_buff_rate / 100) .. "%" .. [[%</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            end
        end


        local attr_add = spellLevelInfo.attr_add
        -- string.split(spellLevelInfo.attr_add, '|');

        local index = 1;

        local tempAddArr0 = { };
        local tempAddArr = { };


        for i = 1, EnumAttributeType.Max do
            if attr_add[i] and attr_add[i] ~= "" then
                tempAddArr0[index] = i
                tempAddArr[index] = attr_add[i]

                index = index + 1
            end
        end
        -- for i,addStr in pairs(attr_add) do
        --  print("===========fuck"..i,addStr)
        --  if addStr and addStr~="" then
        --      tempAddArr0[index] =  i
        --      tempAddArr[index] =  addStr

        --      index = index + 1
        --  end
        -- end
        local addDes = ""

        for i, v in ipairs(tempAddArr0) do
            if tempAddArr[i] and v ~= "" then
                if i > 1 then
                    if tonumber(tempAddArr[i]) > 0 then
                        if isPercentAttr(v) then
                            addDes = addDes .. "," .. AttributeTypeStr[v] .. "Tăng" .. math.abs(math.floor(tonumber(tempAddArr[i]) / 100)) .. '%%';
                        else
                            addDes = addDes .. "," .. AttributeTypeStr[v] .. "Tăng" .. math.abs(tonumber(tempAddArr[i]));
                        end
                    end
                    if tonumber(tempAddArr[i]) < 0 then
                        if isPercentAttr(v) then
                            addDes = addDes .. "," .. AttributeTypeStr[v] .. "Giảm" .. math.abs(math.floor(tonumber(tempAddArr[i]) / 100)) .. '%%';
                        else
                            addDes = addDes .. "," .. AttributeTypeStr[v] .. "Giảm" .. math.abs(tonumber(tempAddArr[i]));
                        end
                    end
                else
                    if tonumber(tempAddArr[i]) > 0 then
                        if isPercentAttr(v) then
                            addDes = addDes .. AttributeTypeStr[v] .. "Tăng" .. math.abs(math.floor(tonumber(tempAddArr[i]) / 100)) .. '%%';
                        else
                            addDes = addDes .. AttributeTypeStr[v] .. "Tăng" .. math.abs(tonumber(tempAddArr[i]));
                        end
                    end
                    if tonumber(tempAddArr[i]) < 0 then
                        if isPercentAttr(v) then
                            addDes = addDes .. AttributeTypeStr[v] .. "Giảm" .. math.abs(math.floor(tonumber(tempAddArr[i]) / 100)) .. '%%';
                        else
                            addDes = addDes .. AttributeTypeStr[v] .. "Giảm" .. math.abs(tonumber(tempAddArr[i]));
                        end
                    end
                end
            end
        end

        description = description:gsub("#attr_add#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. addDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&attr_add&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. addDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#br#", [[</font><br></br><img src="ui_new/role/jsxx_point2_img.png"></img><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        local immuneDes = ""
        for k, v in pairs(spellLevelInfo.immune) do
            if immuneDes ~= "" and v ~= 0 then
                immuneDes = immuneDes .. ","
            end
            if v > 0 then
                immuneDes = immuneDes .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                immuneDes = immuneDes .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        local effect_extraDes = ""
        for k, v in pairs(spellLevelInfo.effect_extra) do
            if effect_extraDes ~= "" and v ~= 0 then
                effect_extraDes = effect_extraDes .. ","
            end
            if v > 0 then
                effect_extraDes = effect_extraDes .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                effect_extraDes = effect_extraDes .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        local be_effect_extraDes = ""
        for k, v in pairs(spellLevelInfo.be_effect_extra) do
            if be_effect_extraDes ~= "" and v ~= 0 then
                be_effect_extraDes = be_effect_extraDes .. ","
            end
            if v > 0 then
                be_effect_extraDes = be_effect_extraDes .. "Bởi" .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                be_effect_extraDes = be_effect_extraDes .. "Bởi" .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end

        description = description:gsub("#immune#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. immuneDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&immune&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. immuneDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#effect_extra#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&effect_extra&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#be_effect_extra#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. be_effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&be_effect_extra&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. be_effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        local des = [[<p style="text-align:left margin:5px">]];
        -- des = des .. [[<img src="ui_new/role/jsxx_point2_img.png"></img>]]
        des = des .. [[<font face = "simhei" color="#3D3D3D" fontSize = "20">]]
        des = des .. description
        des = des .. [[</font>]]
        des = des .. [[</p>]]
        return des
    end

    -- 对所有的数据进行函数绑定
    for item in SkillBaseData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:getbuffDes(spellLevelInfo, description)
    local buff = SkillLevelData:getBuffInfo(spellLevelInfo.buff_id, spellLevelInfo.level)
    -- print("buff:",buff)
    if buff and spellLevelInfo.buff_rate > 0 then
        description = description:gsub("#buff_id#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.name .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&buff_id&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.name .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#last_num#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.last_num .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&last_num&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.last_num .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#params#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.params .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&params&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.params .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        if buff.last_type and buff.last_type == 1 then
            description = description:gsub("#last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Vòng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Vòng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 2 then
            description = description:gsub("#last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần có một Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần có một Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 3 then
            description = description:gsub("#last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 4 then
            description = description:gsub("#last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần riêng của họ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần riêng của họ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 5 then
            description = description:gsub("#last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần liên minh Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần liên minh Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        if buff.is_repeat and buff.is_repeat == 1 then
            description = description:gsub("#is_repeat#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Có thể được chồng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&is_repeat&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Có thể được chồng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.is_repeat and buff.is_repeat == 0 then
            description = description:gsub("#is_repeat#", "");
            description = description:gsub("&is_repeat&", "");
        end

        if buff.buff_rate and buff.buff_rate > 0 then
            description = description:gsub("#buff_trigger_rate#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.buff_rate .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&buff_trigger_rate&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.buff_rate .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        local valueDes = ""
        local attr_value1 = string.split(buff.value, '|');

        for k, value in pairs(attr_value1) do
            if value and value ~= "" then
                if valueDes ~= "" then
                    valueDes = valueDes .. "，";
                end
                local attr_values = string.split(value, '_');

                if #attr_values > 1 then
                    -- if isPercentAttr(index)

                    local attr_index = tonumber(attr_values[1])
                    local attr_value = tonumber(attr_values[2])

                    if attr_value > 0 then
                        if isPercentAttr(attr_index) then
                            valueDes = valueDes .. "Trả lời" .. AttributeTypeStr[attr_index] .. math.abs(attr_value) .. '%%';
                        else
                            valueDes = valueDes .. "Trả lời" .. AttributeTypeStr[attr_index] .. math.abs(attr_value) .. '%%';
                        end
                    end
                    if attr_value < 0 then
                        if isPercentAttr(attr_index) then
                            valueDes = valueDes .. "Giảm" .. AttributeTypeStr[attr_index] .. math.abs(attr_value) .. '%%';
                        else
                            valueDes = valueDes .. "Giảm" .. AttributeTypeStr[attr_index] .. covertToDisplayValue(attr_index, math.abs(attr_value));
                        end
                    end
                else
                    local temp = tonumber(attr_values[1])
                    if buff.type == 61 then
                        local _tempss = temp / 100 .. '%%'
                        valueDes = valueDes .. _tempss;
                    else
                        if temp >= 10000 then
                            description = BaseDataManager:getbuffInBuffDes(temp, spellLevelInfo.level, description)
                        else
                            valueDes = valueDes .. value;
                        end
                    end
                end
            end
        end
        description = description:gsub("#value#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. valueDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&value&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. valueDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        local attr_changeDes = ""
        local attr_attr_change1 = string.split(buff.attr_change, '|');
        for k, attr_change in pairs(attr_attr_change1) do

            if attr_change and attr_change ~= "" then
                if attr_changeDes ~= "" then
                    attr_changeDes = attr_changeDes .. "，";
                end
                local attr_attr_changes = string.split(attr_change, '_');

                if #attr_attr_changes > 1 then
                    -- if isPercentAttr(index)
                    local attr_index = tonumber(attr_attr_changes[1])
                    local attr_attr_change = tonumber(attr_attr_changes[2])

                    if attr_attr_change > 0 then
                        if isPercentAttr(attr_index) then
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_attr_change) .. '%%';
                        else
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_attr_change);
                        end
                    end
                    if attr_attr_change < 0 then
                        if isPercentAttr(attr_index) then
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Giảm" .. math.abs(attr_attr_change) .. '%%';
                        else
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Giảm" .. covertToDisplayValue(attr_index, math.abs(attr_attr_change));
                        end
                    end
                else
                    attr_changeDes = attr_changeDes .. attr_change;
                end
            end
        end
        description = description:gsub("#attr_change#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. attr_changeDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&attr_change&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. attr_changeDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        local immuneDes = ""
        for k, v in pairs(buff.immune) do
            if immuneDes ~= "" and v ~= 0 then
                immuneDes = immuneDes .. ","
            end
            if v > 0 then
                immuneDes = immuneDes .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                immuneDes = immuneDes .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        local effect_extraDes = ""
        for k, v in pairs(buff.effect_extra) do
            if effect_extraDes ~= "" and v ~= 0 then
                effect_extraDes = effect_extraDes .. ","
            end
            if v > 0 then
                effect_extraDes = effect_extraDes .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                effect_extraDes = effect_extraDes .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        local be_effect_extraDes = ""
        for k, v in pairs(buff.be_effect_extra) do
            if be_effect_extraDes ~= "" and v ~= 0 then
                be_effect_extraDes = be_effect_extraDes .. ","
            end
            if v > 0 then
                be_effect_extraDes = be_effect_extraDes .. "Bởi" .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                be_effect_extraDes = be_effect_extraDes .. "Bởi" .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        description = description:gsub("#buff_immune#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. immuneDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&buff_immune&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. immuneDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#buff_effect_extra#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&buff_effect_extra&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#buff_be_effect_extra#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. be_effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&buff_be_effect_extra&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. be_effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

    end
    return description
end


function BaseDataManager:getbuffInBuffDes(buff_id, level, description)
    local buff = SkillLevelData:getBuffInfo(buff_id, level)
    print("buff:", buff)
    if buff then
        description = description:gsub("#inbuff_buff_id#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.name .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inbuff_buff_id&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.name .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#inbuff_last_num#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.last_num .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inbuff_last_num&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.last_num .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#inbuff_params#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.params .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inbuff_params&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.params .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        if buff.last_type and buff.last_type == 1 then
            description = description:gsub("#inbuff_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Vòng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&inbuff_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Vòng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 2 then
            description = description:gsub("#inbuff_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần có một Hiệp sĩ bắn khi các khóa máu" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&inbuff_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần có một Hiệp sĩ bắn khi các khóa máu" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 3 then
            description = description:gsub("#inbuff_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&inbuff_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 4 then
            description = description:gsub("#inbuff_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần riêng của họ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&inbuff_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần riêng của họ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        if buff.last_type and buff.last_type == 5 then
            description = description:gsub("#inbuff_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần liên minh Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&inbuff_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần liên minh Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        if buff.is_repeat and buff.is_repeat == 1 then
            description = description:gsub("#inbuff_is_repeat#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Có thể được chồng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&inbuff_is_repeat&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Có thể được chồng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.is_repeat and buff.is_repeat == 0 then
            description = description:gsub("#inbuff_is_repeat#", "");
            description = description:gsub("&inbuff_is_repeat&", "");
        end

        local valueDes = ""
        local attr_value1 = string.split(buff.value, '|');

        for k, value in pairs(attr_value1) do
            if value and value ~= "" then
                if valueDes ~= "" then
                    valueDes = valueDes .. "，";
                end
                local attr_values = string.split(value, '_');

                if #attr_values > 1 then
                    -- if isPercentAttr(index)

                    local attr_index = tonumber(attr_values[1])
                    local attr_value = tonumber(attr_values[2])

                    if attr_value > 0 then
                        if isPercentAttr(attr_index) then
                            valueDes = valueDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_value) .. '%%';
                        else
                            valueDes = valueDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_value);
                        end
                    end
                    if attr_value < 0 then
                        if isPercentAttr(attr_index) then
                            valueDes = valueDes .. AttributeTypeStr[attr_index] .. "Giảm" .. math.abs(attr_value) .. '%%';
                        else
                            valueDes = valueDes .. AttributeTypeStr[attr_index] .. "Giảm" .. covertToDisplayValue(attr_index, math.abs(attr_value));
                        end
                    end
                else
                    valueDes = valueDes .. value;
                end
            end
        end
        description = description:gsub("#inbuff_value#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. valueDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inbuff_value&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. valueDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        local attr_changeDes = ""
        local attr_attr_change1 = string.split(buff.attr_change, '|');
        print("==================buff.attr_change", buff.attr_change)
        for k, attr_change in pairs(attr_attr_change1) do

            if attr_change and attr_change ~= "" then
                if attr_changeDes ~= "" then
                    attr_changeDes = attr_changeDes .. "，";
                end
                local attr_attr_changes = string.split(attr_change, '_');

                if #attr_attr_changes > 1 then
                    -- if isPercentAttr(index)
                    local attr_index = tonumber(attr_attr_changes[1])
                    local attr_attr_change = tonumber(attr_attr_changes[2])

                    if attr_attr_change > 0 then
                        if isPercentAttr(attr_index) then
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_attr_change) .. '%%';
                        else
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_attr_change);
                        end
                    end
                    if attr_attr_change < 0 then
                        if isPercentAttr(attr_index) then
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Giảm" .. math.abs(attr_attr_change) .. '%%';
                        else
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Giảm" .. covertToDisplayValue(attr_index, math.abs(attr_attr_change));
                        end
                    end
                else
                    attr_changeDes = attr_changeDes .. attr_change;
                end
            end
        end
        description = description:gsub("#inbuff_attr_change#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. attr_changeDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inbuff_attr_change&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. attr_changeDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        local immuneDes = ""
        for k, v in pairs(buff.immune) do
            if immuneDes ~= "" and v ~= 0 then
                immuneDes = immuneDes .. ","
            end
            if v > 0 then
                immuneDes = immuneDes .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                immuneDes = immuneDes .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        local effect_extraDes = ""
        for k, v in pairs(buff.effect_extra) do
            if effect_extraDes ~= "" and v ~= 0 then
                effect_extraDes = effect_extraDes .. ","
            end
            if v > 0 then
                effect_extraDes = effect_extraDes .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                effect_extraDes = effect_extraDes .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        local be_effect_extraDes = ""
        for k, v in pairs(buff.be_effect_extra) do
            if be_effect_extraDes ~= "" and v ~= 0 then
                be_effect_extraDes = be_effect_extraDes .. ","
            end
            if v > 0 then
                be_effect_extraDes = be_effect_extraDes .. "Bởi" .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                be_effect_extraDes = be_effect_extraDes .. "Bởi" .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        description = description:gsub("#inbuff_immune#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. immuneDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inbuff_immune&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. immuneDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#inbuff_effect_extra#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inbuff_effect_extra&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#inbuff_be_effect_extra#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. be_effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&inbuff_be_effect_extra&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. be_effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

    end
    return description
end



function BaseDataManager:getExtrabuffDes(spellLevelInfo, description)
    local buff = SkillLevelData:getBuffInfo(spellLevelInfo.extra_buffid, spellLevelInfo.level)
    -- print("buff:",buff)
    if buff and spellLevelInfo.extra_buff_rate > 0 then
        description = description:gsub("#extra_buff_id#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.name .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_buff_id&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.name .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#extra_last_num#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.last_num .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_last_num&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.last_num .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#extra_params#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.params .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_params&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.params .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        if buff.last_type and buff.last_type == 1 then
            description = description:gsub("#extra_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Vòng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Vòng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 2 then
            description = description:gsub("#extra_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần có một Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần có một Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 3 then
            description = description:gsub("#extra_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 4 then
            description = description:gsub("#extra_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần riêng của họ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần riêng của họ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.last_type and buff.last_type == 5 then
            description = description:gsub("#extra_last_type#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Lần liên minh Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_last_type&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Lần liên minh Hiệp sĩ bắn khi có hiệu lực" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        if buff.is_repeat and buff.is_repeat == 1 then
            description = description:gsub("#extra_is_repeat#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. "Có thể được chồng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_is_repeat&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. "Có thể được chồng" .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end
        if buff.is_repeat and buff.is_repeat == 0 then
            description = description:gsub("#extra_is_repeat#", "");
            description = description:gsub("&extra_is_repeat&", "");
        end

        if buff.buff_rate and buff.buff_rate > 0 then
            description = description:gsub("#extra_buff_trigger_rate#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. buff.buff_rate .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
            description = description:gsub("&extra_buff_trigger_rate&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. buff.buff_rate .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        end

        local valueDes = ""
        local attr_value1 = string.split(buff.value, '|');

        for k, value in pairs(attr_value1) do
            if value and value ~= "" then
                if valueDes ~= "" then
                    valueDes = valueDes .. "，";
                end
                local attr_values = string.split(value, '_');

                if #attr_values > 1 then
                    -- if isPercentAttr(index)

                    local attr_index = tonumber(attr_values[1])
                    local attr_value = tonumber(attr_values[2])

                    if attr_value > 0 then
                        if isPercentAttr(attr_index) then
                            valueDes = valueDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_value) .. '%%';
                        else
                            valueDes = valueDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_value);
                        end
                    end
                    if attr_value < 0 then
                        if isPercentAttr(attr_index) then
                            valueDes = valueDes .. AttributeTypeStr[attr_index] .. "Giảm" .. math.abs(attr_value) .. '%%';
                        else
                            valueDes = valueDes .. AttributeTypeStr[attr_index] .. "Giảm" .. covertToDisplayValue(attr_index, math.abs(attr_value));
                        end
                    end
                else
                    local temp = tonumber(attr_values[1])
                    if temp >= 10000 then
                        description = BaseDataManager:getbuffInBuffDes(temp, spellLevelInfo.level, description)
                    else
                        valueDes = valueDes .. value;
                    end
                end
            end
        end
        description = description:gsub("#extra_value#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. valueDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_value&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. valueDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        local attr_changeDes = ""
        local attr_attr_change1 = string.split(buff.attr_change, '|');
        for k, attr_change in pairs(attr_attr_change1) do

            if attr_change and attr_change ~= "" then
                if attr_changeDes ~= "" then
                    attr_changeDes = attr_changeDes .. "，";
                end
                local attr_attr_changes = string.split(attr_change, '_');

                if #attr_attr_changes > 1 then
                    -- if isPercentAttr(index)
                    local attr_index = tonumber(attr_attr_changes[1])
                    local attr_attr_change = tonumber(attr_attr_changes[2])

                    if attr_attr_change > 0 then
                        if isPercentAttr(attr_index) then
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_attr_change) .. '%%';
                        else
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Tăng" .. math.abs(attr_attr_change);
                        end
                    end
                    if attr_attr_change < 0 then
                        if isPercentAttr(attr_index) then
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Giảm" .. math.abs(attr_attr_change) .. '%%';
                        else
                            attr_changeDes = attr_changeDes .. AttributeTypeStr[attr_index] .. "Giảm" .. covertToDisplayValue(attr_index, math.abs(attr_attr_change));
                        end
                    end
                else
                    attr_changeDes = attr_changeDes .. attr_change;
                end
            end
        end
        description = description:gsub("#extra_attr_change#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. attr_changeDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_attr_change&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. attr_changeDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

        local immuneDes = ""
        for k, v in pairs(buff.immune) do
            if immuneDes ~= "" and v ~= 0 then
                immuneDes = immuneDes .. ","
            end
            if v > 0 then
                immuneDes = immuneDes .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                immuneDes = immuneDes .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        local effect_extraDes = ""
        for k, v in pairs(buff.effect_extra) do
            if effect_extraDes ~= "" and v ~= 0 then
                effect_extraDes = effect_extraDes .. ","
            end
            if v > 0 then
                effect_extraDes = effect_extraDes .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                effect_extraDes = effect_extraDes .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        local be_effect_extraDes = ""
        for k, v in pairs(buff.be_effect_extra) do
            if be_effect_extraDes ~= "" and v ~= 0 then
                be_effect_extraDes = be_effect_extraDes .. ","
            end
            if v > 0 then
                be_effect_extraDes = be_effect_extraDes .. "Bởi" .. SkillBuffHurtStr[k] .. "Tăng" .. math.abs(math.floor(v / 100)) .. '%%';
            elseif v < 0 then
                be_effect_extraDes = be_effect_extraDes .. "Bởi" .. SkillBuffHurtStr[k] .. "Giảm" .. math.abs(math.floor(v / 100)) .. '%%';
            end
        end
        description = description:gsub("#extra_buff_immune#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. immuneDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_buff_immune&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. immuneDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#extra_buff_effect_extra#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_buff_effect_extra&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("#extra_buff_be_effect_extra#", [[</font><font face = "simhei" color="#FF0000" fontSize = "20">]] .. be_effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);
        description = description:gsub("&extra_buff_be_effect_extra&", [[</font><font face = "simhei" color="#01941D" fontSize = "20">]] .. be_effect_extraDes .. [[</font><font face = "simhei" color="#3D3D3D" fontSize = "20">]]);

    end
    return description
end




-- 绑定主角技能数据的函数
function BaseDataManager:BindLeadingRoleSpellData()
    -- 绑定单个技能的函数
    local item_mt = { }
    item_mt.__index = item_mt

    -- 获得是否已达到开放品质
    function item_mt:GetQualityIsOpen(quality)
        return quality >= self.enable_quality;
    end

    -- 获得是否已达到开放等级
    function item_mt:GetLevelIsOpen(level)
        return level >= self.enable_level;
    end

    function item_mt:GetSpellInfo()
        return SkillBaseData:objectByID(self.spell_id);
    end

    for item in LeadingRoleSpellData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end



-- --绑定技能数据的函数
-- function BaseDataManager:BindSkillAttributeData()
--  function SkillAttributeData:getSkillAttribute( level ,tbl)
--      local table = clone( SkillAttributeData:objectByID(level))

--  end
-- end
function BaseDataManager:BindSkillLevelData()

    -- function SkillLevelData:getSkillByIdAndLevel( skillid , level)
    --  -- local id = skillid + level
    --  return SkillLevelData:objectByID(skillid)
    -- end

    -- --绑定单个技能的函数
    -- local item_mt = {}
    -- item_mt.__index = item_mt

    -- --获得技能的伤害属性
    -- function item_mt:GetNormalHurttypeAndNum()
    --  if self.outside and self.outside ~= 1 then
    --      return "Ngoại công" , self.outside
    --  elseif self.inside and self.inside ~= 1 then
    --      return "Nội công" , self.inside
    --  end
    -- end

    -- --获得技能的伤害属性
    -- function item_mt:GetMagicHurttypeAndNum()
    --  if self.ice and self.ice ~= 0 then
    --      return "Hệ Băng" , self.ice
    --  elseif self.fire and self.fire ~= 0 then
    --      return "Hệ Hỏa" , self.fire
    --  elseif self.poison and self.poison ~= 0 then
    --      return "Hệ Độc" , self.poison
    --  end
    -- end

    -- function item_mt:GetPath()
    --  return "icon/skill/"..self.icon_id..".png"
    -- end

    -- --对所有的数据进行函数绑定
    -- for item in SkillLevelData:iterator() do
    --  item.__index = item_mt
    --  setmetatable(item, item_mt)
    -- end
end

function BaseDataManager:GetSkillBaseInfo(skillId)
    return SkillBaseData:objectByID(skillId.skillId)
end


-- 绑定随机商店数据的函数
function BaseDataManager:BindRandomShopData()
    -- 绑定单个商店的函数
    local item_mt = { }
    item_mt.__index = item_mt
    -- 验证当前商品是否物品类型
    function item_mt:isGoods()
        if self.res_type == EnumDropType.GOODS then
            return true
        end
        return false
    end

    -- 验证当前商品是否角色（完整）类型
    function item_mt:isRole()
        if self.res_type == EnumDropType.ROLE then
            return true
        end
        return false
    end

    --[[
        获取商品的数据模板，如果商品类型为物品则返回t_s_goods表格中的数据，如果为角色则返回t_s_role表格中的数据
    ]]
    function item_mt:getTemplate()
        if self.res_type == EnumDropType.GOODS then
            return ItemData:objectByID(self.res_id)
        elseif self.res_type == EnumDropType.ROLE then
            return RoleData:objectByID(self.res_id)
        end
        return nil
    end

    -- 对所有的数据进行函数绑定
    for item in RandomShopData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end


-- 绑定商店数据的函数
function BaseDataManager:BindGiftPackData()
    -- 绑定单个商店的函数
    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getGiftList()
        if self.giftList == nil then
            self.giftList = self:initGiftList()
        end
        return self.giftList
    end

    function item_mt:initGiftList()
        local tbl = MEArray:new()
        local temptbl = string.split(self.goods, '|')
        -- 分解"|"
        for k, v in pairs(temptbl) do
            local temp = string.split(v, '_')
            -- 分解'_',集合为 key，vaule 2个元素
            local gift = { }
            gift.type = tonumber(temp[1])
            gift.itemId = tonumber(temp[2])
            gift.number = tonumber(temp[3])
            tbl:pushBack(gift)
        end
        return tbl
    end


    -- 对所有的数据进行函数绑定
    for item in GiftPackData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end


-- 绑定主角数据的函数
function BaseDataManager:BindProtagonistData()
    function ProtagonistData:getProtagonistById(id)
        for v in ProtagonistData:iterator() do
            if v.role_id == id then
                return v
            end
        end
    end

    function ProtagonistData:IsMainPlayer(id)
        for v in ProtagonistData:iterator() do
            if v.role_id == id then
                return true
            end
        end
        return false
    end

    -- 绑定单个主角的函数
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getProtagonistSKill()
        if self.skillList == nil then
            self.skillList = GetAttrByString(self.skill)
        end
        return self.skillList
    end

    -- 对所有的数据进行函数绑定
    for item in ProtagonistData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

-- 绑定主角升星数据的函数
function BaseDataManager:BindRoleTrainData()
    -- type1
    RoleTrainData.RoleQualityMap = { }
    -- type2
    RoleTrainData.RoleRedMap = { }

    function RoleTrainData:getRoleTrainByQuality(quality, level, qualityOne)
        if qualityOne == nil then
            qualityOne = 1
        end
        if qualityOne == 1 then
            local tbl = self.RoleQualityMap[quality]
            if level then
                return tbl[level]
            else
                return tbl
            end
        else
            local tbl = self.RoleRedMap[quality]
            if level then
                return tbl[level]
            else
                return tbl
            end
        end
    end
    --[[
    function RoleTrainData:getRoleTrainByQuality( quality , level, type)
        local tbl = self.RoleQualityMap[quality]
        local roleTrainInfo = tbl[1]
        for v in tbl do
            if not type then
                type = 1
            end     
            if v.level == level and v.type == type then
                roleTrainInfo = v
                print("getRoleTrainByType-------------------------------zhaodaola")
            end 
        end 
        return roleTrainInfo
    end
]]

    -- 红色侠客
    function RoleTrainData:getRoleTrainByType(quality, level, type)
        local tbl = self.RoleQualityMap[quality]
        local roleTrainInfo = tbl[1]
        for v in tbl do
            if v.level == level and v.type == type then
                roleTrainInfo = v
                print("getRoleTrainByType-------------------------------zhaodaola")
            end
        end
        return roleTrainInfo
    end



    -- 绑定单个主角升星的函数
    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getPath()
        local str = "icon/skill/" .. self.icon_id .. ".png"
        return str
    end


    -- 对所有的数据进行函数绑定
    for item in RoleTrainData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
        if item.type == 1 then
            local tbl = RoleTrainData.RoleQualityMap[item.quality] or { }
            tbl[item.star_level] = item
            RoleTrainData.RoleQualityMap[item.quality] = tbl
        else
            local tbl = RoleTrainData.RoleRedMap[item.quality] or { }
            tbl[item.star_level] = item
            RoleTrainData.RoleRedMap[item.quality] = tbl
        end
    end
end

-- 1000 获得铜币时，可额外多获得n%
-- 2000 关卡战斗每日可用元宝恢复挑战次数n次
-- 2005 群豪谱每日挑战次数升至n次
-- 3000 购买vip礼包n(仅作为描述存在，礼包的vip相关设置在商城有)
-- 3001 购买宝箱，和宝箱钥匙 -铜
-- 3002 购买宝箱，和宝箱钥匙 -银
-- 3003 购买宝箱，和宝箱钥匙 -金
-- 3004 可在商城使用连续招募10次角色功能
-- 4000 装备强化出现暴击，额外提升n级
-- 5000 经脉强化出现暴击，额外提升n级
-- 6000 好友上限达n人
-- 绑定VIP数据的函数
function BaseDataManager:BindVipDataData()
    
    function VipData:getVipListByVip(vip)
        local list = MEArray:new()
        for v in VipData:iterator() do
            if v.vip_level == vip then
                list:push(v)
            end
        end
        return list;
    end

    function VipData:getVipListByType(viptype)
        local list = MEArray:new()
        for v in VipData:iterator() do
            if v.benefit_code == viptype then
                list:push(v)
            end
        end
        return list;
    end

    function VipData:getVipItemByTypeAndVip(viptype, vip)
        if vip == -1 then
            return nil
        end
        local temp = nil
        for v in VipData:iterator() do
            if v.benefit_code == viptype then
                if v.vip_level == vip then
                    return v
                end
                if (v.vip_level < vip and(temp == nil or v.vip_level > temp.vip_level)) then
                    temp = v
                end
            end
        end
        return temp
    end


    -- 取得下一个能够提升特权的vip
    function VipData:getVipNextAddValueVip(viptype, vip)
        vip = vip or 0;
        local currentVip = self:getVipItemByTypeAndVip(viptype, vip);
        for v in VipData:iterator() do
            if v.benefit_code == viptype and v.vip_level >= vip then

                if (currentVip == nil and v.benefit_value > 0) or(currentVip ~= nil and v.benefit_value > currentVip.benefit_value) then
                    return v
                end
            end
        end
        return nil;
    end

    --[[
    出现特定特权的最低vip等级
    @code 特权定义
    @return vip等级，找不到返回-1
    ]]
    function VipData:getMinLevelDeclear(code)
        local item = nil;
        for v in VipData:iterator() do
            if v.benefit_code == code then
                if not item then
                    item = v
                else
                    if item.vip_level > v.vip_level then
                        item = v
                    end
                end
            end
        end
        if not item then
            return -1
        end
        return item.vip_level
    end
end

-- 绑定主角升星数据的函数
function BaseDataManager:BindRoleFateData()

    RoleFateData.RoleFateMap = { }
    function RoleFateData:getRoleFateById(id)
        local tbl = self.RoleFateMap[id]
        return tbl or MEArray:new()
    end

    -- 绑定单个主角升星的函数
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAttr()
        local temptbl = string.split(self.attribute, '_')
        -- 分解"_"
        return tonumber(temptbl[1]), tonumber(temptbl[2])
    end

    function item_mt:gettarget()
        if self.targetList == nil then
            self:initTarget()
        end
        return self.targetList
    end

    function item_mt:initTarget()
        self.targetList = { }
        local tempnum = 1
        local temptbl = string.split(self.target, '|')
        -- 分解"|"
        for k, v in pairs(temptbl) do
            local temp = string.split(v, ',')
            -- 分解',',集合为 key，vaule 2个元素
            if temp[1] and temp[2] then
                self.targetList[tempnum] = { fateType = tonumber(temp[1]), fateId = tonumber(temp[2]) }
                tempnum = tempnum + 1
            end
        end
    end
    function item_mt:getCommondTarget()
        if self.commondTargetList == nil then
            self:initCommondTarget()
        end
        return self.commondTargetList
    end

    function item_mt:initCommondTarget()
        self.commondTargetList = { }
        if self.common_target == nil then
            return
        end
        local tempnum = 1
        local temptbl = string.split(self.common_target, '|')
        -- 分解"|"
        for k, v in pairs(temptbl) do
            local temp = string.split(v, ',')
            -- 分解',',集合为 key，vaule 2个元素
            if temp[1] and temp[2] then
                self.commondTargetList[tempnum] = { fateType = tonumber(temp[1]), fateId = tonumber(temp[2]) }
                tempnum = tempnum + 1
            end
        end
    end

    -- 对所有的数据进行函数绑定
    for item in RoleFateData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
        local array = RoleFateData.RoleFateMap[item.role_id] or MEArray:new()
        array:pushBack(item)
        RoleFateData.RoleFateMap[item.role_id] = array
    end
end

--[[
绑定护驾奖励
]]
function BaseDataManager:BindEscortingDataFunc()

    function EscortingReward:getByTypeAndIndex(type, index)
        for v in EscortingReward:iterator() do
            if v.type == type and v.index == index then
                return v
            end
        end
        return nil
    end

end


function BaseDataManager:BindPlayerGuideData()

    function PlayerGuideData:getByLayerName(layer_name)
        return PlayerGuideData.layers[layer_name]
    end

    PlayerGuideData.layers = { }
    for info in PlayerGuideData:iterator() do
        if info.trigger_layer then
            PlayerGuideData.layers[info.trigger_layer] = PlayerGuideData.layers[info.trigger_layer] or { }
            table.insert(PlayerGuideData.layers[info.trigger_layer], info)
        end
    end
end


function BaseDataManager:BindPlayerGuideStepData()
    -- PlayerGuideData.layers = {}
    -- for info in PlayerGuideData:iterator() do
    --  if info.layer_name then
    --      PlayerGuideData.layers[info.layer_name] = PlayerGuideData.layers[info.layer_name] or {}
    --      table.insert(PlayerGuideData.layers[info.layer_name], info)
    --  end
    -- end
end

-- 绑定角色武学配置表函数
function BaseDataManager:BindMartialRoleConfigure()
    MartialRoleConfigure.roleArray = { }

    function MartialRoleConfigure:findByRoleId(roleId)
        return self.roleArray[roleId]
    end

    function MartialRoleConfigure:findByRoleIdAndMartialLevel(roleId, martialLevel)
        if self.roleArray[roleId] then
            return self.roleArray[roleId][martialLevel]
        end
    end

    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    --[[
    获得属性加成
    @return 属性table。格式:{index=value,……} 如 {1=40,2=33}
    ]]
    function item_mt:getAttributeTable()
        if not self.attributeTable then
            self.attributeTable = GetAttrByString(self.attribute)
        end
        return self.attributeTable
    end

    --[[
    获取可装备的武学
    @return 武学table
    ]]
    function item_mt:getMartialTable()
        if not self.martialTable then
            self.martialTable = stringToNumberTable(self.martial_id, '|')
        end
        return self.martialTable
    end


    for item in MartialRoleConfigure:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)

        -- 将配置信息按照角色id归类，提高访问速度
        local tbl = MartialRoleConfigure.roleArray[item.role_id]
        if not tbl then
            tbl = { }
            MartialRoleConfigure.roleArray[item.role_id] = tbl
        end
        tbl[item.level] = item
    end
end

-- 绑定武学附魔配置表函数
function BaseDataManager:BindMartialEnchant()
    MartialEnchant.levelArray = { }

    function MartialEnchant:findByLevel(level)
        return self.levelArray[level]
    end

    function MartialEnchant:findByRoleIdAndMartialLevel(level, enchantLevel)
        if self.levelArray[level] then
            return self.levelArray[level][enchantLevel]
        end
    end

    for item in MartialEnchant:iterator() do
        -- item.__index = item_mt
        -- setmetatable(item, item_mt)

        -- 将配置信息按照角色id归类，提高访问速度
        local tbl = MartialEnchant.levelArray[item.level]
        if not tbl then
            tbl = { }
            tbl.config = { }
            tbl.maxLevel = 0
            MartialEnchant.levelArray[item.level] = tbl
        end
        tbl.config[item.enchant_level] = item
        if tbl.maxLevel then
            if tbl.maxLevel < item.enchant_level then
                tbl.maxLevel = item.enchant_level
            end
        else
            tbl.maxLevel = item.enchant_level
        end
    end
end

-- 绑定武学
function BaseDataManager:BindMartial()
    --[[
        通过材料ID查找合成目标，首个找到的马上返回，主要用于图谱残片ID查找图谱
        @id 图谱残片id
    ]]
    function MartialData:findByMaterial(id)
        local materialTable = nil
        for item in MartialData:iterator() do
            materialTable = item:getMaterialTable()
            if materialTable then
                for _k, _v in pairs(materialTable) do
                    if _k == id then
                        return item, _v
                    end
                end
            end
        end
    end

    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    --[[
    获得属性加成
    @return 属性table。格式:{index=value,……} 如 {1=40,2=33}
    ]]
    function item_mt:getAttributeTable()
        if not self.attributeTable then
            self.attributeTable = GetAttrByString(self.attribute)
        end

        return self.attributeTable
    end

    --[[
    获得材料Table
    @return materialTable,indexTable。其中materialTable格式为{id=num,……},如：{333=2,304=5};indexTable格式{index=id},如{1=333,2=304}
    ]]
    function item_mt:getMaterialTable()
        if not self.materialTable then
            self.materialTable, self.indexTable = GetAttrByStringForExtra(self.material)
        end
        return self.materialTable, self.indexTable
    end

    for item in MartialData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
        item.goodsTemplate = ItemData:objectByID(item.id)
    end
end

-- 绑定御膳房
function BaseDataManager:BindDiet()
    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    --[[
    获取现在开放的御膳
    @return 御膳配置，如果没有御膳开放返回nil
    ]]
    function DietData:getCurrentDiet()
        for item in DietData:iterator() do
            if item:getStatus() == 2 then
                return item
            end
        end
    end

    --[[
    获取御膳房状态
    @lastTime 玩家最后一次用膳时间，用字符串格式表达。表达式：yyyy-MM-dd HH:mm:ss
    @return 1:未准备好；2:就绪；3:已经用餐；4:超时
    ]]
    function item_mt:getStatus(lastTime, time)
        local current = time
        if current == nil then
            current = GetCorrectTime()
        end

        current = GetCorrectDate('*t', current)
        -- 获得当前时间的table表存储格式
        if not self.start_table then
            self.start_table = split(self.start_time, ":")
            self.end_table = split(self.end_time, ":")
            if self.start_table then
                for k, v in pairs(self.start_table) do
                    self.start_table[k] = tonumber(v)
                end
            end
            if self.end_table then
                for k, v in pairs(self.end_table) do
                    self.end_table[k] = tonumber(v)
                end
            end
        end

        if current['hour'] < self.start_table[1] then
            return 1
        end
        if current['hour'] > self.end_table[1] then
            return 4
        end

        if current['hour'] == self.start_table[1] and current['min'] < self.start_table[2] then
            return 1
        end
        if current['hour'] == self.end_table[1] and current['min'] > self.end_table[2] then
            return 4
        end

        -- 是否已经用膳
        if lastTime and lastTime ~= '' then
            local dateTime = getDateByString(lastTime)
            if tonumber(dateTime['year']) == current['year'] and tonumber(dateTime['month']) == current['month'] and tonumber(dateTime['day']) == current['day'] and tonumber(dateTime['hour']) >= self.start_table[1] and tonumber(dateTime['hour']) <= self.end_table[1] then
                return 3
            end
        end

        -- if lastTime == nil then
        -- local dateTime = current
        -- if tonumber(dateTime['year']) == current['year'] and tonumber(dateTime['month']) == current['month'] and tonumber(dateTime['day']) == current['day'] and tonumber(dateTime['hour']) >= self.start_table[1] and tonumber(dateTime['hour']) <= self.end_table[1] then
        --  return 3
        -- end
        -- end

        return 2
    end

    for item in DietData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

-- 绑定玩家资源配置表函数
function BaseDataManager:BindPlayerResConfigure()

    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    --[[
    获得重置等待时间价格列表
    @return 属性table。格式:{index=value,……} 如 {1=40,2=33}
    ]]
    function item_mt:getResetWaitPriceTable()
        if not self.resetWaitPriceTable then
            if self.reset_wait_price then
                self.resetWaitPriceTable = stringToNumberTable(self.reset_wait_price, ',')
            else
                self.resetWaitPriceTable = { }
            end
        end
        return self.resetWaitPriceTable
    end

    --[[
    获取重置等待时间价格
    @index 第几次购买
    @return 价格
    ]]
    function item_mt:getResetWaitPrice(index)
        local priceTab = self:getResetWaitPriceTable()
        if not priceTab then
            return nil
        elseif #priceTab < 1 then
            return nil
        end

        local length = #priceTab
        if index > length then
            index = length
        end
        return priceTab[index]
    end

    --[[
    获得价格列表
    @return 属性table。格式:{index=value,……} 如 {1=40,2=33}
    ]]
    function item_mt:getPriceTable()
        if not self.priceTable then
            self.priceTable = stringToNumberTable(self.price, ',')
        end
        return self.priceTable
    end

    --[[
    获取价格
    @index 第几次购买
    @return 价格
    ]]
    function item_mt:getPrice(index)
        local priceTab = self:getPriceTable()
        if not priceTab then
            return nil
        elseif #priceTab < 1 then
            return nil
        end

        local length = #priceTab
        if index > length then
            index = length
        end
        return priceTab[index]
    end

    --[[
    获取购买资源最低vip等级
    @return 最低购买资源的vip等级
    ]]
    function item_mt:getMinVipLevelForBuy()
        if not self.buy_vip_rule or self.buy_vip_rule == 0 then
            return -1
        end
        return VipData:getMinLevelDeclear(self.buy_vip_rule)
    end

    --[[
    获取最大购买次数
    @vipLevel vip等级
    @return 最大购买次数，如果找不到返回0
    ]]
    function item_mt:getMaxBuyTime(vipLevel)
        if not self.buy_vip_rule or self.buy_vip_rule == 0 then
            return 0
        end
        local rule = VipData:getVipItemByTypeAndVip(self.buy_vip_rule, vipLevel)
        if not rule then
            return 0
        end
        return rule.benefit_value
    end

    --[[
    获取资源最大值
    @vipLevel VIP等级
    @return 资源最大值
    ]]
    function item_mt:getMaxValue(vipLevel)
        if not self.max_vip_rule or self.max_vip_rule == 0 then
            return self.max_value
        end
        local rule = VipData:getVipItemByTypeAndVip(self.max_vip_rule, vipLevel)
        if not rule then
            return self.max_value
        end
        return rule.benefit_value + self.max_value
    end

    -- 绑定方法
    for item in PlayerResConfigure:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

-- 绑定经脉配置表函数
function BaseDataManager:BindMeridianConfigure()

    function MeridianConfigure:findByRoleId(roleId)
        return MeridianConfigure:objectByID(roleId)
    end

    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    --[[
    获取成长值
    @index 索引，1~n
    @return 成长值
    ]]
    function item_mt:getFactor(index)
        return self.factorTable[index]
    end

    --[[
    获得属性类型
    @index 索引，1~n
    @return 成长值
    ]]
    function item_mt:getAttributeKey(index)
        return self.keyTable[index]
    end

    --[[
    获取属性加成
    @return 属性类型1~n,成长值
    ]]
    function item_mt:getAttribute(index)
        return self.keyTable[index], self.factorTable[index]
    end

    --[[
    获取穴位个数
    ]]
    function item_mt:acupointLength()
        return self.len
    end

    for item in MeridianConfigure:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)

        -- 解析属性加成
        if item.attributes then
            local length = 0
            item.keyTable, length = stringToNumberTable(item.attributes, ',')
            item.factorTable = stringToNumberTable(item.factors, ',')
            item.len = length
            item.attributeTable = { }
            for i = 1, length do
                local key = item.keyTable[i]
                local value = item.factorTable[i]
                item.attributeTable[key] = value
            end
        end
    end
end

-- 绑定失败指引
function BaseDataManager:BindFightFailGuide()
    function FightFailGuide:getGuildeListByLevel(level)
        local list = TFArray:new()
        for guide in FightFailGuide:iterator() do
            if guide.minLevel <= level and level <= guide.maxLevel then
                list:push(guide)
            end
        end
        return list
    end
end
-- 绑定失败指引
function BaseDataManager:BindFightLoadingGuide()
    function FightLoadingGuide:getGuildeListByLevel(level)
        local list = { }
        -- TFArray:new()
        for guide in FightLoadingGuide:iterator() do
            if guide.minLevel <= level and level <= guide.maxLevel then
                list[guide.tip_type] = list[guide.tip_type] or TFArray:new()
                list[guide.tip_type]:push(guide)
            end
        end
        return list
    end
end

function BaseDataManager:BindMenuBtnOpenData()
    function MenuBtnOpenData:getOpenBtnByLevel(level)
        local list = TFArray:new()
        for info in MenuBtnOpenData:iterator() do
            if info.level and info.level == level then
                list:push(info)
            end
        end
        return list
    end
end
function BaseDataManager:BindMartialLevelExchangeData()
    function MartialLevelExchangeData:getRewardListByLevel(level)
        self.rewardList = self.rewardList or { }
        if self.rewardList[level] == nil then
            local list = { }
            local reward = MartialLevelExchangeData:objectByID(level).resources
            if reward ~= "" then
                if reward == nil or reward == 0 or reward == "0" or reward == "" then
                    return { }
                end

                local temptbl = string.split(reward, '|')
                -- 分解"|"
                for k, v in pairs(temptbl) do
                    local temp = string.split(v, ':')
                    -- 分解'_',集合为 key，vaule 2个元素
                    if temp[1] and temp[2] then
                        list[tonumber(temp[1])] = tonumber(temp[2])
                    end
                end
            end
            self.rewardList[level] = list
        end
        return self.rewardList[level]
    end
end
function BaseDataManager:BindRoleSoundData()
    function RoleSoundData:stopEffect()
        if self.handle ~= nil then
            TFAudio.stopEffect(self.handle)
            self.handle = nil
        end
    end
    function RoleSoundData:playSoundByIndex(roleId, index)
        if PlayerGuideManager.isPlayEffect == true then
            return
        end
        local soundInfo = RoleSoundData:objectByID(roleId)
        if soundInfo == nil then
            print("该角色没有声音文件  roleId == ", roleId)
            return
        end
        if index == 0 then
            print("该角色没有该声音文件  roleId == index = ", roleId, index)
            return
        end
        if index ~= nil and index ~= soundInfo.fight_index and index > soundInfo.sound_num then
            print("该角色没有该声音文件  roleId == index = ", roleId, index)
            return
        end
        local _index = index or math.random(1, soundInfo.sound_num)
        local music = soundInfo["sound_" .. _index]
        if music == nil or music == "" then
            print("没有配置该声音 roleId == index = ", roleId, index)
            return
        end
        if self.handle ~= nil then
            TFAudio.stopEffect(self.handle)
            self.handle = nil
        end
        self.handle = TFAudio.playEffect("sound/role/" .. soundInfo["sound_" .. _index], false)
        return self.handle
    end
    function RoleSoundData:playFightSoundByIndex(roleId)
        local soundInfo = RoleSoundData:objectByID(roleId)
        if soundInfo == nil then
            print("该角色没有声音文件  roleId == ", roleId)
            return
        end
        if soundInfo.fight_index == nil then
            print("该角色没有战斗声音文件  soundInfo.fight_index == nil ")
            return
        end
        RoleSoundData:playSoundByIndex(roleId, soundInfo.fight_index)
    end
end

-- 绑定摩诃衍配置表函数
function BaseDataManager:BindMoHeYaConfigure()

    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    --[[
        判断是否开放状态
    ]]
    function item_mt:isOpen()
        -- 没有设置开放时间，则每天都开放
        if not self.openLength or self.openLength < 1 then
            return true
        end

        -- local weekDay = tonumber(GetCorrectDate('%w',GetCorrectTime()))        --获得当前时间的table表存储格式
        -- quanhuan change
        local weekDay = tonumber(GetCorrectDate('%w', MainPlayer:getNowtime()))

        if weekDay == 0 then
            weekDay = 7
        end

        for k, v in ipairs(self.openTable) do
            if weekDay == v then
                return true
            end
        end
        return false
    end

    for item in MoHeYaConfigure:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)

        if item.open_date then
            item.openTable, item.openLength = stringToNumberTable(item.open_date, ',')
        end
    end
end

function BaseDataManager:FunctionOpenConfigureBindings()
    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    --[[
        判断是否开放状态
    ]]
    function FunctionOpenConfigure:isFuctionOpen(id)
        local config = FunctionOpenConfigure:objectByID(id)
        local teamLev = MainPlayer:getLevel()

        if config == nil then
            print("找不到该功能id ---- ", id)
        end

        if teamLev >= config.level then
            return true
        end

        return false
    end

    function FunctionOpenConfigure:getOpenLevel(id)
        local config = FunctionOpenConfigure:objectByID(id)
        if config == nil then
            return nil
        end
        return config.level
    end

    -- for item in FunctionOpenConfigure:iterator() do
    --  item.__index = item_mt
    --  setmetatable(item, item_mt)
    -- end
end

-- 绑定忠义堂数据
function BaseDataManager:BindWorshipPlan()
    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    function WorshipPlanConfig:getDataByLevel(level)
        for guide in WorshipPlanConfig:iterator() do
            if guide.level == level then
                return guide
            end
        end
    end
end

-- 绑定忠义堂数据
function BaseDataManager:BindGuildWorship()
    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    function GuildWorshipConfig:getDataByLevel(level)
        local tmp = { }

        for guide in GuildWorshipConfig:iterator() do
            if guide.level == level then
                table.insert(tmp, guide)
            end
        end

        return tmp
    end
end
function BaseDataManager:BindChampionsAwardData()
    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    function ChampionsAwardData:getRewardData(type, rank)
        for data in ChampionsAwardData:iterator() do
            if type == data.type and(rank >= data.min_rank and rank <= data.max_rank) then
                return data
            end
        end
    end

    function ChampionsAwardData:getAllRewardDataByType(type)
        local dataList = { }
        for data in ChampionsAwardData:iterator() do
            if type == data.type then
                dataList[#dataList + 1] = data
            end
        end
        return dataList
    end

    for item in ChampionsAwardData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
    function item_mt:getReward()
        if self.rewardList == nil then
            self.rewardList = { }
            local tbl, len = stringToTable(self.award, '|')
            for i = 1, len do
                local reward = stringToNumberTable(tbl[i], '_')
                self.rewardList[i] = { itemid = reward[2], number = reward[3] }
                self.rewardList[i].type = reward[1]
            end
        end
        return self.rewardList
    end
end
function BaseDataManager:BindChampionsBoxData()
    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt

    for item in ChampionsBoxData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
        ChampionsBoxData.map[item.type * 1000 + item.index] = item
    end
end

function BaseDataManager:BindClimbRuleConfigure()
    -- 绑定单个奖励的函数
    local item_mt = { }
    item_mt.__index = item_mt
    ClimbRuleConfigure.RuleMap = { }


    function ClimbRuleConfigure:getRuleDataByType(type, id, deviation)
        if ClimbRuleConfigure.RuleMap[type] == nil then
            return nil
        end
        local array = ClimbRuleConfigure.RuleMap[type][id]
        if array == nil then
            print("配表没有 ID=", id)
            return nil
        end
        local temp_deviation = 0
        local ruleData = nil
        for data in array:iterator() do
            if deviation >= data.deviation and temp_deviation <= data.deviation then
                ruleData = data
                temp_deviation = data.deviation
            end
        end
        return ruleData
    end

    function ClimbRuleConfigure:getRuleData(id, deviation)
        return self:getRuleDataByType(5, id, deviation)
    end

    function ClimbRuleConfigure:getNorthRuleData(id, deviation)
        return self:getRuleDataByType(16, id, deviation)
    end

    for item in ClimbRuleConfigure:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)

        ClimbRuleConfigure.RuleMap[item.type] = ClimbRuleConfigure.RuleMap[item.type] or { }
        local typeArray = ClimbRuleConfigure.RuleMap[item.type]
        local array = typeArray[item.mountId] or MEArray:new()
        array:pushBack(item)
        ClimbRuleConfigure.RuleMap[item.type][item.mountId] = array

    end
end

function BaseDataManager:BindAcupointBreachData()

    function AcupointBreachData:getData(attr_idx, level)
        for data in AcupointBreachData:iterator() do
            if attr_idx == data.attribute_key and level == data.level then
                return data
            end
        end
    end
    function AcupointBreachData:getConsumeMinByLevel(attr_idx, level)
        local cost = 0
        for data in AcupointBreachData:iterator() do
            if attr_idx == data.attribute_key and level >= data.level then
                cost = cost + data:getConsume()
            end
        end
        return cost
    end

    function AcupointBreachData:getMaxLevelByLevel(attr_idx, level)
        local lvl = 0
        for data in AcupointBreachData:iterator() do
            if attr_idx == data.attribute_key and level >= data.min_level then
                if lvl < data.level then
                    lvl = data.level
                end
            end
        end
        return lvl
    end

    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getConsume()
        if self.vesselbreachCost == nil then
            local data = string.split(self.consume, '_')
            self.vesselbreachCost = tonumber(data[3])
        end
        return self.vesselbreachCost
    end


    for item in AcupointBreachData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end



function BaseDataManager:BindAgreeRuleData()

    function AgreeRuleData:GetPercentValue(level)
        local percent = { [1] = 0, [2] = 0 }
        for v in AgreeRuleData:iterator() do
            if v.level == level then
                percent[1] = v.value
                percent[2] = v.sub_value
            end
        end
        return percent
    end

    function AgreeRuleData:GetDataInfo(level)
        for v in AgreeRuleData:iterator() do
            if v.level == level then
                return v
            end
        end
        return nil
    end

    -- 绑定单个道具数据的函数
    local item_mt = { }
    item_mt.__index = item_mt
    -- 获得道具的图片路径
    function item_mt:GetItemInfo()
        local itemList = { }
        local data = string.split(self.consume, '|')
        for k, v in pairs(data) do
            itemList[k] = { }
            local details = string.split(v, '_')
            itemList[k].type = tonumber(details[1])
            itemList[k].id = tonumber(details[2])
            itemList[k].num = tonumber(details[3])
        end
        return itemList
    end

    -- 对所有的数据进行函数绑定
    for item in AgreeRuleData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindAgreeAttributeData()

    function AgreeAttributeData:GetAttrTblIndex(level, pos)
        local attrTable = { }
        for v in AgreeAttributeData:iterator() do
            if v.level == level and v.pos == pos then
                local baseAttr = string.split(v.attribute, ',')
                attrTable[1] = baseAttr
                if AssistFightManager.QiheMaxLevelSwitch == false then
                    if level == 5 then
                        return attrTable
                    end
                end
                if v.sub_attribute ~= "" then
                    local subAttrTable = string.split(v.sub_attribute, ',')
                    attrTable[2] = subAttrTable
                end
                return attrTable
            end
        end
        return attrTable
    end
end
function BaseDataManager:BindBattleLimitedData()

    -- 绑定单个道具数据的函数
    local item_mt = { }
    item_mt.__index = item_mt
    -- 获得描述
    -- 类型：1、属性更改；2、在X回合内通关；3、上阵侠客存活X个；4、我方侠客技能怒气消耗增加X点；5、我方所有侠客以X%以上血量通关；6、战斗中使用技能不超过X次
    function item_mt:getDescribe()
        if self.describe == nil then
            if self.type == 1 then
                local attribute_list = GetAttrByString(self.attribute_percent)
                self.describe = "Trong chiến đấu, tất Cả các Hiệp khách"
                for k, v in pairs(attribute_list) do
                    local vaule = math.abs(math.floor(v / 100))
                    if isPercentAttr(k) then
                        vaule = vaule .. "%"
                    end
                    if v > 0 then
                        self.describe = self.describe .. AttributeTypeStr[k] .. "Tăng" .. vaule .. "Hạ thông quan"
                    else
                        self.describe = self.describe .. AttributeTypeStr[k] .. "Giảm" .. vaule .. "Hạ thông quan"
                    end
                end
            elseif self.type == 2 then
                self.describe = "Trong" .. self.value .. "Hiệp nội thông quan"
            elseif self.type == 3 then
                self.describe = "Hiếp khách ra trận sống sót ít nhất" .. self.value .. "Cái thông quan"
            elseif self.type == 4 then
                self.describe = "Hiếp khách bên ta, kỹ năng nộ gia tăng" .. self.value .. "Điểm hạ thông quan"
            elseif self.type == 5 then
                self.describe = "Tất cả Hiệp khách bên ta" .. self.value .. "% đả thông huyết mạch"
            elseif self.type == 6 then
                self.describe = "Không dùng thêm kỹ năng nào trong chiến đấu" .. self.value .. "Thứ hạ thông quan"
            end
        end
        return self.describe
    end

    -- 对所有的数据进行函数绑定
    for item in BattleLimitedData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindGuildZoneData()

    function GuildZoneData:GetInfoByZoneId(zone_id)
        for v in GuildZoneData:iterator() do
            if v.zone_id == zone_id then
                return v
            end
        end
        return nil
    end

    function GuildZoneData:GetZoneMaxNum()
        local num = GuildZoneData:size() or 0
        return num
    end
end

--

function BaseDataManager:BindGuildZoneCheckPointData()

    local item_mt = { }
    item_mt.__index = item_mt

    function GuildZoneCheckPointData:GetInfoByZoneId(zone_id)
        local infoData = { }
        for v in GuildZoneCheckPointData:iterator() do
            if v.zone_id == zone_id then
                local index = #infoData + 1
                infoData[index] = v
            end
        end
        return infoData
    end


    function GuildZoneCheckPointData:GetInfoByZoneIdAndPoint(zone_id, index)
        local infoData = self:GetInfoByZoneId(zone_id)
        if infoData == nil then
            return nil
        end
        return infoData[index]
    end

    function GuildZoneCheckPointData:GetRecommendPower(zone_id, checkpoint_id)
        local infoData = self:GetInfoByZoneId(zone_id) or { }
        for k, v in pairs(infoData) do
            if v.checkpoint_id == checkpoint_id then
                return v.power
            end
        end
        return 100
    end


    function item_mt:getNPCIdList()
        if self.formationsList == nil then
            self.formationsList = stringToNumberTable(self.formations, ',')
        end
        return self.formationsList
    end

    function item_mt:getHpList()
        if self.hpList == nil then
            self.hpList = { }
            local infoData = self:getNPCIdList()
            for i = 1, 9 do
                local npcId = infoData[i]
                local blood = 0
                if npcId and npcId > 0 then
                    local npc = NPCData:objectByID(tonumber(npcId))
                    if npc and npc.attribute then
                        local attr = { }
                        local attributeTbl = stringToTable(npc.attribute, '|')
                        for _, v in pairs(attributeTbl) do
                            local item = string.split(v, '_')
                            if item[1] and item[2] then
                                attr[tonumber(item[1])] = tonumber(item[2])
                            end
                        end
                        blood = attr[1] or 0
                    end
                end
                self.hpList[i] = blood
            end
        end
        return self.hpList
    end

    function item_mt:getHpTotal()
        if self.hpTotal == nil then
            local hpList = self:getHpList()
            self.hpTotal = 0
            for i = 1, 9 do
                local hp = hpList[i] or 0
                self.hpTotal = self.hpTotal + hp
            end
        end
        return self.hpTotal
    end

    for item in GuildZoneCheckPointData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindGuildZoneDpsAwardData()

    function GuildZoneDpsAwardData:GetInfoByZoneId(zone_id)
        local dataInfo = { }
        for v in GuildZoneDpsAwardData:iterator() do
            if v.zone_id == zone_id then
                local index = #dataInfo + 1
                dataInfo[index] = v
            end
        end
        return dataInfo
    end

    local item_mt = { }
    item_mt.__index = item_mt


    function item_mt:getRewardInfo()
        if self.RewardInfo == nil then
            local awardData = stringToNumberTable(self.award, '_')
            self.RewardInfo = { }
            self.RewardInfo.type = awardData[1]
            self.RewardInfo.itemId = awardData[2]
            self.RewardInfo.number = awardData[3]
        end
        return self.RewardInfo
    end

    for item in GuildZoneDpsAwardData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindGuildPracticePosData()

    function GuildPracticePosData:isOpen(pos, teamLevel, guildLevel)
        for v in GuildPracticePosData:iterator() do
            if v.id == pos then
                if v.team_level <= teamLevel and v.guild_level <= guildLevel then
                    return true
                else
                    return false
                end
            end
        end
        return false
    end

    function GuildPracticePosData:getOpenDescr(pos)
        local strDescr = ""
        for v in GuildPracticePosData:iterator() do
            if v.id == pos then
                if v.team_level ~= 0 then
                    strDescr = "Cấp đội" .. v.team_level .. "Mở ra"
                else
                    strDescr = "Cấp Bang phái" .. v.guild_level .. "Mở ra"
                end
                return strDescr
            end
        end
        return strDescr
    end
end

function BaseDataManager:BindGuildPracticeData()
    function GuildPracticeData:getGuildPracticeByType(typeId, profession)
        local guildpracticeByIdInfo = { }
        for v in GuildPracticeData:iterator() do
            if v.type == typeId and v.profession == profession then
                table.insert(guildpracticeByIdInfo, v)
            end
        end
        return guildpracticeByIdInfo
    end

    function GuildPracticeData:getGuildPracticeTypeNum(pageIndex, profession)
        local guildtype = { }
        for v in GuildPracticeData:iterator() do
            if v.page == pageIndex and v.profession == profession then
                if next(guildtype) == 0 then
                    table.insert(guildtype, v.type)
                else
                    local ishave = false
                    for m, n in pairs(guildtype) do
                        if n == v.type then
                            ishave = true
                        end
                    end
                    if ishave == false then
                        table.insert(guildtype, v.type)
                    end
                end
            end
        end
        return #guildtype
    end
    function GuildPracticeData:getNowConfigByLevel(typeId, level, profession)
        local guildByTypeInfo = GuildPracticeData:getGuildPracticeByType(typeId, profession)
        local attributestring = nil
        local config = 0
        local isPrecent = false
        if level <= #guildByTypeInfo and level > 0 then
            if guildByTypeInfo[level].attribute ~= "" then
                attributestring = guildByTypeInfo[level].attribute

            elseif guildByTypeInfo[level].immune_rate ~= "" then
                attributestring = guildByTypeInfo[level].immune_rate
                isPrecent = true
            elseif guildByTypeInfo[level].effect_active ~= "" then
                attributestring = guildByTypeInfo[level].effect_active
                isPrecent = true
            elseif guildByTypeInfo[level].effect_passive ~= "" then
                attributestring = guildByTypeInfo[level].effect_passive
                isPrecent = true
            end
            local fig = string.split(attributestring, '_')
            config = tonumber(fig[2])
            return config, isPrecent
        else
            return config, isPrecent
        end
    end
    function GuildPracticeData:getPracticeInfoByTypeAndLevel(type, level, profession)
        for v in GuildPracticeData:iterator() do
            if (v.type == type and v.level == level) and v.profession == profession then
                return v
            end
        end
        return nil
    end
    function GuildPracticeData:getPracticeInfoByTbl(tbl)
        for v in GuildPracticeData:iterator() do
            if (v.type == tbl.type and v.level == tbl.level) and v.profession == tbl.profession then
                return v
            end
        end
        return nil
    end

    local item_mt = { }
    item_mt.__index = item_mt


    function item_mt:getAttributeValue()
        if self.attributeValue == nil then
            self.attributeValue = { percent = true, value = 0 }
            if self.attribute ~= '' then
                local awardData = stringToNumberTable(self.attribute, '_')
                if awardData[1] < 18 then
                    self.attributeValue.percent = false
                    self.attributeValue.value = awardData[2]
                else
                    self.attributeValue.percent = true
                    self.attributeValue.value = awardData[2]
                end
                return self.attributeValue
            elseif self.immune_rate ~= '' then
                local awardData = stringToNumberTable(self.immune_rate, '_')
                self.attributeValue.percent = true
                self.attributeValue.value = awardData[2]
                return self.attributeValue
            elseif self.effect_active ~= '' then
                local awardData = stringToNumberTable(self.effect_active, '_')
                self.attributeValue.percent = true
                self.attributeValue.value = awardData[2]
                return self.attributeValue
            else
                local awardData = stringToNumberTable(self.effect_passive, '_')
                self.attributeValue.percent = true
                self.attributeValue.value = awardData[2] or 0
                return self.attributeValue
            end
        end
        return self.attributeValue
    end

    for item in GuildPracticeData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindGuildPracticeStudyData()
    function GuildPracticeStudyData:getGuildPracticeStudyByType(typeId)
        local StudyinfoByType = { }
        for v in GuildPracticeStudyData:iterator() do
            if v.attribute_type == typeId then
                table.insert(StudyinfoByType, v)
            end
        end
        return StudyinfoByType
    end
    function GuildPracticeStudyData:getPracticeInfoByTypeAndLevel(type, level)
        for v in GuildPracticeStudyData:iterator() do
            if v.attribute_type == type and v.attribute_level == level then
                return v
            end
        end
        return nil
    end

    local item_mt = { }
    item_mt.__index = item_mt


    function item_mt:getConsumes()
        if self.consumesInfo == nil then
            self.consumesInfo = { }
            local awardData = stringToNumberTable(self.consumes, '_')
            self.consumesInfo.type = awardData[1]
            self.consumesInfo.id = awardData[2]
            self.consumesInfo.value = awardData[3]
        end
        return self.consumesInfo
    end

    for item in GuildPracticeStudyData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindGuildPracticeRuleData()
    function GuildPracticeRuleData:getRuleInfoByPracticelevel(level)
        local ruleinfo = { }
        for v in GuildPracticeRuleData:iterator() do
            if v.practice_level == level then
                table.insert(ruleinfo, v)
            end
        end
        return ruleinfo
    end

    function GuildPracticeRuleData:getStudyMaxLevel(level, typeId)
        local maxlevel = 0
        local ruleinfo = GuildPracticeRuleData:getRuleInfoByPracticelevel(level)
        -- maxlevel = ruleinfo[#ruleinfo].attribute_level
        for k, v in pairs(ruleinfo) do
            if typeId == v.attribute_type then
                maxlevel = v.attribute_level
            end
        end
        return maxlevel
    end
end


function BaseDataManager:BindEquipmentRecastData()
    function EquipmentRecastData:getInfoByquality(quality)
        for v in EquipmentRecastData:iterator() do
            if v.quality == quality then
                return v
            end
        end
        return nil
    end

    function EquipmentRecastData:getDescribe(quality)
        for v in EquipmentRecastData:iterator() do
            if v.quality == quality then
                -- return v.title
                return v.title
            end
        end
    end
    -- function EquipmentRecastData:getDescribeBySubtype(sub_type)
    --     for v in EquipmentRecastData:iterator() do
    --         if v.sub_type == sub_type then
    --             -- return v.title
    --             return v.describe_title
    --         end
    --     end
    --     return nil
    -- end
    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getMaxPercent()
        if self.maxPercent == nil then
            self.maxPercent = 0
            local awardData = string.split(self.attribute, '|') or { }
            for k, v in pairs(awardData) do
                local data = stringToNumberTable(v, '_') or { }
                if data[1] > self.maxPercent then
                    self.maxPercent = data[1]
                end
            end
        end
        return self.maxPercent
    end

    for item in EquipmentRecastData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end

end

function BaseDataManager:BindEquipmentRecastConditionData()
    function EquipmentRecastConditionData:getInfoByPos(pos)
        for v in EquipmentRecastConditionData:iterator() do
            if v.icon == pos then
                return v
            end
        end
    end
end

function BaseDataManager:BindEquipmentRecastSubAddData()
    function EquipmentRecastSubAddData:getInfoByPos(id)
        for v in EquipmentRecastSubAddData:iterator() do
            if v.id == pos then
                return v
            end
        end
    end
    function EquipmentRecastSubAddData:getDescribeBySubtype(sub_type)
        for v in EquipmentRecastSubAddData:iterator() do
            if v.sub_type == sub_type then
                -- return v.title
                return v.describe_title
            end
        end
        return nil
    end
end

function BaseDataManager:BindMercenaryConfig()
    function MercenaryConfig:getEmployRoleConfigByIndex(index)
        for v in MercenaryConfig:iterator() do
            if v.type == 1 and v.index == index then
                return v
            end
        end
        return nil
    end

    function MercenaryConfig:getEmployRoleConfigNum()
        if self.employRoleNum == nil then
            self.employRoleNum = 0
            for v in MercenaryConfig:iterator() do
                if v.type == 1 then
                    self.employRoleNum = self.employRoleNum + 1
                end
            end
        end
        return self.employRoleNum
    end
end

function BaseDataManager:BindQimenConfigData()
    function QimenConfigData:getInfoById(id)
        for v in QimenConfigData:iterator() do
            if v.id == id then
                return v
            end
        end
        return nil
    end

    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getAttributeValue()
        if self.attributeValue == nil then
            self.attributeValue = { type = 1, percent = true, index = 1, value = 0 }
            if self.attribute ~= '' then
                local awardData = stringToNumberTable(self.attribute, '_')
                if awardData[1] < 18 then
                    self.attributeValue.percent = false
                else
                    self.attributeValue.percent = true
                end
                self.attributeValue.index = awardData[1]
                self.attributeValue.value = awardData[2]
                self.attributeValue.type = 1
                return self.attributeValue
            elseif self.immune_rate ~= '' then
                local awardData = stringToNumberTable(self.immune_rate, '_')
                self.attributeValue.percent = true
                self.attributeValue.index = awardData[1]
                self.attributeValue.value = awardData[2]
                self.attributeValue.type = 2
                return self.attributeValue
            elseif self.effect_active ~= '' then
                local awardData = stringToNumberTable(self.effect_active, '_')
                self.attributeValue.percent = true
                self.attributeValue.index = awardData[1]
                self.attributeValue.value = awardData[2]
                self.attributeValue.type = 2
                return self.attributeValue
            else
                local awardData = stringToNumberTable(self.effect_passive, '_')
                self.attributeValue.percent = true
                self.attributeValue.index = awardData[1] or 0
                self.attributeValue.value = awardData[2] or 0
                self.attributeValue.type = 2
                return self.attributeValue
            end
        end
        return self.attributeValue
    end

    for item in QimenConfigData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end


function BaseDataManager:BindQimenBreachConfigData()
    function QimenBreachConfigData:getInfoById(id)
        for v in QimenBreachConfigData:iterator() do
            if v.id == id then
                return v
            end
        end
        return nil
    end

    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getAttributeValue()
        if self.attributeValue == nil then
            self.attributeValue = { }
            if self.attribute ~= '' then
                local dataBuff = string.split(self.attribute, '|')
                for i = 1, #dataBuff do
                    local awardData = stringToNumberTable(dataBuff[i], '_')
                    self.attributeValue[i] = { }
                    if awardData[1] < 18 then
                        self.attributeValue[i].percent = false
                    else
                        self.attributeValue[i].percent = true
                    end
                    self.attributeValue[i].index = awardData[1]
                    self.attributeValue[i].value = awardData[2]
                    self.attributeValue[i].type = 1
                end
                return self.attributeValue
            elseif self.immune_rate ~= '' then
                local dataBuff = string.split(self.immune_rate, '|')
                for i = 1, #dataBuff do
                    local awardData = stringToNumberTable(dataBuff[i], '_')
                    self.attributeValue[i] = { }
                    self.attributeValue[i].percent = true
                    self.attributeValue[i].index = awardData[1]
                    self.attributeValue[i].value = awardData[2]
                    self.attributeValue[i].type = 2
                end
                return self.attributeValue
            elseif self.effect_active ~= '' then
                local dataBuff = string.split(self.effect_active, '|')
                for i = 1, #dataBuff do
                    local awardData = stringToNumberTable(dataBuff[i], '_')
                    self.attributeValue[i] = { }
                    self.attributeValue[i].percent = true
                    self.attributeValue[i].index = awardData[1]
                    self.attributeValue[i].value = awardData[2]
                    self.attributeValue[i].type = 2
                end
                return self.attributeValue
            else
                local dataBuff = string.split(self.effect_passive, '|')
                for i = 1, #dataBuff do
                    local awardData = stringToNumberTable(dataBuff[i], '_')
                    self.attributeValue[i] = { }
                    self.attributeValue[i].percent = true
                    self.attributeValue[i].index = awardData[1]
                    self.attributeValue[i].value = awardData[2]
                    self.attributeValue[i].type = 2
                end
                return self.attributeValue
            end
        end
        return self.attributeValue
    end

    for item in QimenBreachConfigData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end


function BaseDataManager:BindGambleTypeData()
    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getConsumes()
        if self.consumesInfo == nil then
            self.consumesInfo = { }
            local awardData = stringToNumberTable(self.consume, '_')
            self.consumesInfo.type = awardData[1]
            self.consumesInfo.id = awardData[2]
            self.consumesInfo.value = awardData[3]
        end
        return self.consumesInfo
    end
    function item_mt:getToken()
        if self.token == nil or self.token == "" or self.token == "0" then
            return nil
        end
        if self.tokenInfo == nil then
            self.tokenInfo = { }
            local awardData = stringToNumberTable(self.token, '_')
            self.tokenInfo.type = awardData[1]
            self.tokenInfo.id = awardData[2]
            self.tokenInfo.value = awardData[3]
        end
        return self.tokenInfo
    end
    for item in GambleTypeData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end


function BaseDataManager:BindGambleZxData()
    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getConsumes()
        if self.consumesInfo == nil then
            self.consumesInfo = { }
            local awardData = stringToNumberTable(self.consume, '_')
            self.consumesInfo.type = awardData[1]
            self.consumesInfo.id = awardData[2]
            self.consumesInfo.value = awardData[3]
        end
        return self.consumesInfo
    end
    function item_mt:getToken()
        if self.token == nil or self.token == "" or self.token == "0" then
            return nil
        end
        if self.tokenInfo == nil then
            self.tokenInfo = { }
            local awardData = stringToNumberTable(self.token, '_')
            self.tokenInfo.type = awardData[1]
            self.tokenInfo.id = awardData[2]
            self.tokenInfo.value = awardData[3]
        end
        return self.tokenInfo
    end
    for item in GambleZxData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindAdventureRandomEventData()

    function AdventureRandomEventData:getInfoById(id)
        for v in AdventureRandomEventData:iterator() do
            if v.id == id then
                return v
            end
        end
        return nil
    end

    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:checkIsTalk()
        if self.type == 128 then
            -- 128需要战斗支持
            return false
        else
            -- 9998 只有对话
            return true
        end
    end

    function item_mt:getCoordinate()
        if self.coordinateData == nil then
            self.coordinateData = { }
            local data = stringToNumberTable(self.coordinate, ",")
            self.coordinateData.x = data[1]
            self.coordinateData.y = data[2]
        end
        return self.coordinateData
    end

    for item in AdventureRandomEventData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end
function BaseDataManager:BindBibleData()
    BibleData.bookArray = { }

    function BibleData:getBibleInfoByIdAndLevel(id, level)
        if BibleData.bookArray[id] == nil then
            return nil
        end
        return BibleData.bookArray[id][level]
    end

    function BibleData:getMaxLevel(id)
        return #BibleData.bookArray[id]
    end

    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getHoleAttr(hole)
        if self.holeAttr == nil then
            self.holeAttr = { }
            local essentialAtt = string.split(self.essential_att, '|')
            local i = 0
            for k, v in pairs(essentialAtt) do
                i = i + 1
                local tbl = string.split(v, '_')
                self.holeAttr[i] = { key = tonumber(tbl[1]), value = tonumber(tbl[2]) }
            end
        end
        return self.holeAttr[hole]
    end


    for item in BibleData:iterator() do
        item.__index = item_mt
        BibleData.bookArray[item.id] = BibleData.bookArray[item.id] or { }
        BibleData.bookArray[item.id][item.level] = item
        setmetatable(item, item_mt)
    end
end
function BaseDataManager:BindBibleBreachData()
    BibleBreachData.breachArray = { }

    function BibleBreachData:getBreachInfo(quality, times)
        if BibleBreachData.breachArray[quality] == nil then
            return nil
        end
        return BibleBreachData.breachArray[quality][times]
    end

    local item_mt = { }
    item_mt.__index = item_mt



    for item in BibleBreachData:iterator() do
        item.__index = item_mt
        BibleBreachData.breachArray[item.quality] = BibleBreachData.breachArray[item.quality] or { }
        BibleBreachData.breachArray[item.quality][item.times] = item
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindAdventureEventNpc()
    function adventureEventNpc:getPowerByLevelAndOccupation(level, occupation)
        for v in adventureEventNpc:iterator() do
            if v.level == level and v.occupation == occupation then
                return v.power
            end
        end
        return 0
    end
end

function BaseDataManager:BindLianTiData()
    function LianTiData:getTotalAttributeByType(quality, type, level)
        local attributeTabel = { }
        for item in LianTiData:iterator() do
            if item.acupoint == type and item.level <= level then
                local att = item:getAttributeValue(quality)
                if att then
                    attributeTabel[att.index] = attributeTabel[att.index] or 0
                    attributeTabel[att.index] = attributeTabel[att.index] + att.value
                end
            end
        end
        return attributeTabel
    end

    function LianTiData:getPointQuality(type, level)
        for item in LianTiData:iterator() do
            if item.acupoint == type and item.level == level then
                return item.quality
            end
        end
        return 0
    end

    function LianTiData:getConsume(type, level, quality)
        for item in LianTiData:iterator() do
            if item.acupoint == type and item.level == level then
                return item:getConsume(quality)
            end
        end
    end

    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getAttributeValue(quality)
        self.attributeValue = self.attributeValue or { }
        if self.attributeValue[quality] == nil then
            local attribute = nil
            if quality == 4 then
                attribute = self.attribute_violet
            elseif quality == 5 then
                attribute = self.attribute_orange
            elseif quality == 6 then
                attribute = self.attribute_red
            else
                return nil
            end
            if attribute ~= '' then
                self.attributeValue[quality] = { type = 1, percent = true, index = 1, value = 0 }
                local awardData = stringToNumberTable(attribute, '_')
                if awardData[1] < 18 then
                    self.attributeValue[quality].percent = false
                else
                    self.attributeValue[quality].percent = true
                end
                self.attributeValue[quality].index = awardData[1]
                self.attributeValue[quality].value = awardData[2]
                self.attributeValue[quality].type = 1
                return self.attributeValue[quality]
            end
        end
        return self.attributeValue[quality]
    end

    function item_mt:getConsume(quality)
        self.consumeValue = self.consumeValue or { }
        if self.consumeValue[quality] == nil then
            local consume = nil
            if quality == 4 then
                consume = self.consume_violet
            elseif quality == 5 then
                consume = self.consume_orange
            elseif quality >= 6 then
                consume = self.consume_red
            else
                return nil
            end
            if consume ~= '' then
                self.consumeValue[quality] = { }
                local consumeDataTabel = stringToTable(consume, ',')
                for k, v in ipairs(consumeDataTabel) do
                    self.consumeValue[quality][k] = self.consumeValue[quality][k] or { }
                    local consumeData = stringToNumberTable(v, '_')
                    self.consumeValue[quality][k].type = consumeData[1]
                    self.consumeValue[quality][k].id = consumeData[2]
                    self.consumeValue[quality][k].num = consumeData[3]
                end
                return self.consumeValue[quality]
            end
        end
        return self.consumeValue[quality]
    end

    for item in LianTiData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindLianTiExtraData()
    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getAttributeValue()
        if self.attributeValue == nil then
            self.attributeValue = { }
            if self.attribute ~= '' and self.attribute ~= '0' then
                local tbl, len = stringToTable(self.attribute, '|')
                for i = 1, len do
                    local awardData = stringToNumberTable(tbl[i], '_')
                    if awardData[1] then
                        local index = awardData[1]
                        self.attributeValue[index] = self.attributeValue[index] or { percent = true, value = 0 }
                        if awardData[1] < 18 then
                            self.attributeValue[index].percent = false
                            self.attributeValue[index].value = awardData[2]
                        else
                            self.attributeValue[index].percent = true
                            self.attributeValue[index].value = awardData[2]
                        end
                    end
                end
                return self.attributeValue
            end
        end
        return self.attributeValue
    end

    for item in LianTiExtraData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end
 
function BaseDataManager:BindPowerCompareData()
    PowerCompareData.array = { }

    function PowerCompareData:getItemByTypeAndKind(type, kind)
        if PowerCompareData.array[type] == nil then
            return nil
        end
        return PowerCompareData.array[type][kind]
    end

    local item_mt = { }
    item_mt.__index = item_mt

    for item in PowerCompareData:iterator() do
        item.__index = item_mt
        PowerCompareData.array[item.type] = PowerCompareData.array[item.type] or { }
        PowerCompareData.array[item.type][item.kind] = item
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindPowerCompareMaxData()
    function PowerCompareMaxData:getLimit(type, kind, teamLevel, index)
        if ( not type ) or ( not kind ) or ( not teamLevel ) or ( not PowerCompareMaxData.array[type] ) or ( not PowerCompareMaxData.array[type][kind] ) then
            return 0
        end
        index = index or 1

        local item = PowerCompareMaxData.array[type][kind][teamLevel] or {}
        if index == 2 then
            return item.max_max or 0
        else
            return item.one_max or 0
        end
    end
    PowerCompareMaxData.array = {}

    local item_mt = { }
    item_mt.__index = item_mt

    for item in PowerCompareMaxData:iterator() do
        item.__index = item_mt
        PowerCompareMaxData.array[item.type] = PowerCompareMaxData.array[item.type] or {}
        PowerCompareMaxData.array[item.type][item.kind] = PowerCompareMaxData.array[item.type][item.kind] or {}
        PowerCompareMaxData.array[item.type][item.kind][item.level] = item or {}
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindQianXiuAttributeData()
    function QianXiuAttributeData:getMaxAttriByLvl(lvl, quality)
        for item in QianXiuAttributeData:iterator() do
            if item.role_level == lvl and item.role_quality == quality then
                return item:getAttributeValue()
            end
        end
        return nil
    end
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAttributeValue()
        if self.attributeValue == nil then
            self.attributeValue = { }
            if self.attributes ~= '' and self.attributes ~= '0' then
                local tbl, len = stringToTable(self.attributes, ',')
                for i = 1, len do
                    local awardData = stringToNumberTable(tbl[i], '_')
                    if awardData[1] then
                        local index = awardData[1]
                        self.attributeValue[index] = self.attributeValue[index] or { percent = true, value = 0 }
                        if awardData[1] < 18 then
                            self.attributeValue[index].percent = false
                            self.attributeValue[index].value = awardData[2]
                        else
                            self.attributeValue[index].percent = true
                            self.attributeValue[index].value = awardData[2]
                        end
                    end
                end
                return self.attributeValue
            end
        end
        return self.attributeValue
    end
    for item in QianXiuAttributeData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindFundData()
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getReward()
        -- local rewardList = MEArray:new()
        -- local temptbl = string.split(self.return_reward,',')         --分解"|"     
        -- for k,v in pairs(temptbl) do
        --  local reward = RewardItemData:objectByID(tonumber(v))
        --  if reward then
        --      local commonReward = {}
        --      commonReward.type = reward.type;
        --      commonReward.itemId = reward.item_id;
        --      commonReward.number = reward.number;
        --      rewardList:push(BaseDataManager:getReward(commonReward))
        --  end
        -- end
        -- return rewardList
        local rewardList = RewardConfigureData:GetRewardItemListById(tonumber(self.return_reward))
        return rewardList
    end
    for item in FundData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindPeakData()
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getData()
        if self.data == nil then
            local tData = { }
            local temptbl = stringToTable(self.integral_time, ',')
            for k, v in pairs(temptbl) do
                local tbl = stringToNumberTable(v, '_')
                tData[k] = { }
                tData[k].beginTime = tbl[1]
                tData[k].endTime = tbl[2]
                tData[k].percent =(tbl[3] or 0) / 10000
                if tData[k].percent == 1 then
                    tData[k].type = 1
                elseif tData[k].percent < 1 then
                    tData[k].type = 0
                elseif tData[k].percent > 1 then
                    tData[k].type = 2
                end
            end
            self.data = tData
        end
        return self.data
    end
    for item in PeakData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindZhuanJiData()
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAttribute()
        if self.attributeTable == nil then
            self.attributeTable = { }
            local str = self.attribute
            local temptbl = stringToTable(str, '|')
            for k, v in pairs(temptbl) do
                local tbl = stringToNumberTable(v, '_')
                self.attributeTable[tbl[1]] = tbl[2]
            end
        end
        return self.attributeTable
    end
    function item_mt:getRoleIdList()
        if self.roleList == nil then
            local str = self.roles
            self.roleList = stringToNumberTable(str, ',') or { }
        end
        return self.roleList
    end
    for item in ZhuanJiData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindZhuanJiCondData()
    function ZhuanJiCondData:getDataByCategory(iCategory)
        for item in ZhuanJiCondData:iterator() do
            if iCategory == item.category then
                return item
            end
        end
        return nil
    end
end

function BaseDataManager:BindBibleGemData()
    function BibleGemData:getItemByStarAndQuality(star, quality)
        for item in BibleGemData:iterator() do
            if item.star == star and item.quality == quality then
                return item
            end
        end
        return nil
    end
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getDesc()
        return self.desc
    end
    function item_mt:getNextDesc()
        return self.next_desc
    end
    function item_mt:getGemMaxLevel()
        return self.gem_max_level or 0
    end
    for item in BibleGemData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindEquipmentThroughExpData()

    function EquipmentThroughExpData:getExpByQualityLevel(quality, level)
        for item in EquipmentThroughExpData:iterator() do
            if item.level == level and item.quality == quality then
                return item.exp
            end
        end
        return 0
    end

    function EquipmentThroughExpData:getTotalExpByQualityLevel(quality, level)
        local total = 0
        for item in EquipmentThroughExpData:iterator() do
            if item.level <= level and item.quality == quality then
                total = total + item.exp
            end
        end
        return total
    end

    function EquipmentThroughExpData:getToolListByQualityLevel(quality, level)
        for item in EquipmentThroughExpData:iterator() do
            if item.level == level and item.quality == quality then
                local consumes = string.split(item.consumes, ",")
                return consumes
            end
        end
        return { }
    end
end

function BaseDataManager:BindEquipmentThroughAttribData()
    function EquipmentThroughAttribData:getCurrAttrByQualityLevel(equipment_type, quality, level)
        for item in EquipmentThroughAttribData:iterator() do
            if item.equipment_type == equipment_type and item.level == level and item.quality == quality then
                local attribute = string.split(item.attribute, "_")
                local attrIndex = tonumber(attribute[1])
                local attrNum = tonumber(attribute[2])
                return attrIndex, attrNum
            end
        end
        return nil
    end

    function EquipmentThroughAttribData:getTotalAttrByQualityLevel(equipment_type, quality, level)
        local attrList = { }
        for item in EquipmentThroughAttribData:iterator() do
            if item.equipment_type == equipment_type and item.quality == quality and item.level <= level then
                local attribute = string.split(item.attribute, "_")
                attrList[tonumber(attribute[1])] = attrList[tonumber(attribute[1])] or 0
                attrList[tonumber(attribute[1])] = attrList[tonumber(attribute[1])] + tonumber(attribute[2])
            end
        end
        return attrList
    end
end

function BaseDataManager:BindEquipmentSpecialAttribData()
    function EquipmentSpecialAttribData:getDetailsByQualityLevel(equipment_type, quality, level)
        for item in EquipmentSpecialAttribData:iterator() do
            if item.equipment_type == equipment_type and item.through_level == level and item.quality == quality then
                return item
            end
        end
        return nil
    end
    function EquipmentSpecialAttribData:getConsumesByQualityLevel(equipment_type, quality, level)
        local consumesList = { }
        local item = EquipmentSpecialAttribData:getDetailsByQualityLevel(equipment_type, quality, level)
        if item then
            consumes = string.split(item.consumes, "_")
            consumesList.type = tonumber(consumes[1])
            consumesList.id = tonumber(consumes[2])
            consumesList.num = tonumber(consumes[3])
        end
        return consumesList
    end
end

function BaseDataManager:BindFamilyData()
    function FamilyData:getShowListTableByLevel(level)
        local item = self:getItemByLevel(level)
        local str = item.show_list
        local tab = string.split(str, ",")

        for i = 1, #tab do
            if tab[i] and tab[i] ~= "" then
                tab[i] = "img_wujian_" .. tab[i]
            end
        end

        return tab
    end

    function FamilyData:getItemByLevel(level)
        for v in FamilyData:iterator() do
            if v.level == level then
                return v
            end
        end
    end

    function FamilyData:getExpByLevel(level)
        for v in FamilyData:iterator() do
            if v.level == level then
                return v.exp
            end
        end
        return 0
    end

    function FamilyData:getTotalAttr1(level)
        local totalTab = { }
        if level == nil then
            level = 1
        end
        for v in FamilyData:iterator() do
            if v.level <= level then
                local tab = string.split(v.attribute, "|")
                for i = 1, #tab do
                    local str = tab[i]
                    local temp = string.split(str, "_")
                    local key = tonumber(temp[1])
                    local value = tonumber(temp[2])

                    totalTab[key] = totalTab[key] or 0
                    totalTab[key] = totalTab[key] + value
                end
            end

            if v.level <= level and v.breach_attribute and v.breach_attribute ~= "" then
                local tab = string.split(v.breach_attribute, "|")
                for i = 1, #tab do
                    local str = tab[i]
                    local temp = string.split(str, "_")
                    local key = tonumber(temp[1])
                    local value = tonumber(temp[2])

                    totalTab[key] = totalTab[key] or 0
                    totalTab[key] = totalTab[key] + value
                end
            end
        end
        return totalTab
    end

    function FamilyData:getAttrStateTab()
        local achieveList = { }
        for v in FamilyData:iterator() do
            if v.breach_attribute and v.breach_attribute ~= "" then
                local tab = { }
                tab[1] = v.level
                tab[2] = v.breach_attribute
                table.insert(achieveList, tab)
            end
        end
        table.sort(achieveList, function(a, b)
            return a[1] < b[1]
        end )
        return achieveList
    end

    function FamilyData:getTotalAttr(level)
        return self.attrTab[level] or { }
    end

    local function initAttrTab()
        FamilyData.attrTab = { }
        for v in FamilyData:iterator() do
            FamilyData.attrTab[v.level] = FamilyData:getTotalAttr1(v.level)
        end
    end
    initAttrTab()
end


function BaseDataManager:BindMonthCardBuffData()
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAbsolute()
        if self.absoluteConfig == nil then
            self.absoluteConfig = { }
            local absoluteConfig = stringToTable(self.absolute, "|")
            for k, v in pairs(absoluteConfig) do
                local config, _ = stringToNumberTable(v, "_")
                if config[1] ~= nil then
                    local index = config[1]
                    local baseAdd = config[2]
                    self.absoluteConfig[index] = baseAdd
                end
            end
        end
        return self.absoluteConfig
    end
    function item_mt:getLevelUp()
        if self.levelUpConfig == nil then
            self.levelUpConfig = { }
            local levelUpConfig = stringToTable(self.level_up, "|")
            for k, v in pairs(levelUpConfig) do
                local config, _ = stringToNumberTable(v, "_")
                if config[1] ~= nil then
                    local index = config[1]
                    local baseAdd = config[2]
                    self.levelUpConfig[index] = baseAdd
                end
            end
        end
        return self.levelUpConfig
    end
    for item in MonthCardBuffData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindBattleArrayData()

    function BattleArrayData:getComposeNumByPieceId(pieceId)
        for v in BattleArrayData:iterator() do
            if v.fragment_id == pieceId then
                return v:getComposeNum()
            end
        end
        return 0
    end

    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getBaseAttrTable()
        if self.attributeTable == nil then
            self.attributeTable = { }
            local attributeConfig = stringToTable(self.base_attribute, "|")
            for k, v in pairs(attributeConfig) do
                local attrInfo = string.split(v, "_")
                self.attributeTable[tonumber(attrInfo[1])] = tonumber(attrInfo[2])
            end
        end
        return self.attributeTable
    end
    function item_mt:getGrowAttrTable()
        if self.growTable == nil then
            self.growTable = { }
            local growTable = stringToTable(self.grow, "|")
            for k, v in pairs(growTable) do
                local attrInfo = string.split(v, "_")
                self.growTable[tonumber(attrInfo[1])] = tonumber(attrInfo[2])
            end
        end
        return self.growTable
    end
    function item_mt:getAttrByLevel(level)
        local base = self:getBaseAttrTable()
        local grow = self:getGrowAttrTable()
        local attribute = { }
        for k, v in pairs(base) do
            local value = grow[k] or 0
            attribute[k] = v + value * level
        end
        return attribute
    end
    function item_mt:getComposeNum()
        if self.composeNum == nil then
            local attrInfo = string.split(self.compose, "_")
            self.composeNum = tonumber(attrInfo[3])
        end
        return self.composeNum
    end
    for item in BattleArrayData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindBattleArrayStarData()

    function BattleArrayStarData:getItemInfo(id, starLevel)
        for v in BattleArrayStarData:iterator() do
            if v.item == id and v.star == starLevel then
                return v
            end
        end
    end

    function BattleArrayStarData:getTotalConsume(id, starLevel)
        local starItemTbl = { }
        for v in BattleArrayStarData:iterator() do
            if v.item == id and v.star <= starLevel then
                if v.consume ~= "" then
                    local tab1 = string.split(v.consume, "|")
                    for _, tab2 in pairs(tab1) do
                        local info = string.split(tab2, "_")
                        starItemTbl[tonumber(info[2])] = starItemTbl[tonumber(info[2])] or 0
                        starItemTbl[tonumber(info[2])] = starItemTbl[tonumber(info[2])] + tonumber(info[3])
                    end
                end
            end
        end
        return starItemTbl
    end

    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAttributeByPos(pos)
        self.posAttribute = self.posAttribute or { }
        if self.posAttribute[pos] == nil then
            self.posAttribute[pos] = { }
            local attrStr = self.position_1
            if pos == 1 then
                attrStr = self.position_1
            elseif pos == 2 then
                attrStr = self.position_2
            elseif pos == 3 then
                attrStr = self.position_3
            elseif pos == 4 then
                attrStr = self.position_4
            elseif pos == 5 then
                attrStr = self.position_5
            end
            local attributeConfig = stringToTable(attrStr, "|")
            for k, v in pairs(attributeConfig) do
                local attrInfo = string.split(v, "_")
                self.posAttribute[pos][tonumber(attrInfo[1])] = tonumber(attrInfo[2])
            end
        end
        return self.posAttribute[pos]
    end

    function item_mt:getBreachChipInfo()
        if self.chipInfo == nil then
            self.chipInfo = { }
            item = BattleArrayData:objectByID(self.item)
            self.chipInfo.id = item.fragment_id
            self.chipInfo.num = 0

            local consume = stringToTable(self.consume, "|")
            for k, v in pairs(consume) do
                local consumeItem = string.split(v, "_")
                if tonumber(consumeItem[2]) == item.fragment_id then
                    self.chipInfo.num = tonumber(consumeItem[3])
                    break
                end
            end
        end
        return self.chipInfo
    end
    for item in BattleArrayStarData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindBattleArrayLevelData()
    function BattleArrayLevelData:getItemByLevelAndQuality(level, quality)
        for v in BattleArrayLevelData:iterator() do
            if v.level == level and v.quality == quality then
                return v
            end
        end
    end

    function BattleArrayLevelData:getTotalExpByLevelAndQuality(level, quality)
        local totalExp = 0
        for v in BattleArrayLevelData:iterator() do
            if v.level <= level and v.quality == quality then
                totalExp = totalExp + v.exp
            end
        end
        return totalExp
    end

    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getConsumeTab()
        local consumes = self.consumes or ""
        local tab = string.split(consumes, ",")
        for i = 1, #tab do
            tab[i] = tonumber(tab[i])
        end
        return tab
    end

    function item_mt:getNeedExp()
        return self.exp
    end

    for item in BattleArrayLevelData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindRedPacketData()
    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAttribute()
        if self.attributeTable == nil then
            self.attributeTable = { }
            local str = self.attribute
            local temptbl = stringToTable(str, '|')
            for k, v in pairs(temptbl) do
                local tbl = stringToNumberTable(v, '_')
                self.attributeTable[tbl[1]] = tbl[2]
            end
        end
        return self.attributeTable
    end

    function item_mt:getPrice()
        if self.priceTabel == nil then
            self.priceTabel = { }
            local str = self.price
            local temptbl = stringToTable(str, '_')
            self.priceTabel.type = tonumber(temptbl[1])
            self.priceTabel.itemId = tonumber(temptbl[2])
            self.priceTabel.number = tonumber(temptbl[3])
        end
        return self.priceTabel
    end

    for item in RedPacketData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindRedPacketAchievementData()
    function RedPacketAchievementData:getAttributeByid(id)
        local tAttri = { }
        local tEffectActiveAttri = { }
        local tEffectPassive = { }
        for item in RedPacketAchievementData:iterator() do
            if item.id <= id then
                local attribute = item:getAttribute()
                for k, v in pairs(attribute) do
                    tAttri[k] = tAttri[k] or 0
                    tAttri[k] = tAttri[k] + v
                end
                attribute = item:getEffectActive()
                for k, v in pairs(attribute) do
                    tEffectActiveAttri[k] = tEffectActiveAttri[k] or 0
                    tEffectActiveAttri[k] = tEffectActiveAttri[k] + v
                end
                attribute = item:getEffectPassive()
                for k, v in pairs(attribute) do
                    tEffectPassive[k] = tEffectPassive[k] or 0
                    tEffectPassive[k] = tEffectPassive[k] + v
                end
            end
        end
        return tAttri, tEffectActiveAttri, tEffectPassive
    end

    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAttribute()
        if self.attributeTable == nil then
            self.attributeTable = { }
            local str = self.attribute
            local temptbl = stringToTable(str, '|')
            for k, v in pairs(temptbl) do
                local tbl = stringToNumberTable(v, '_')
                self.attributeTable[tbl[1]] = tbl[2]
            end
        end
        return self.attributeTable
    end

    function item_mt:getEffectActive()
        if self.effectActiveTable == nil then
            self.effectActiveTable = { }
            local str = self.effect_active
            local temptbl = stringToTable(str, '|')
            for k, v in pairs(temptbl) do
                local tbl = stringToNumberTable(v, '_')
                self.effectActiveTable[tbl[1]] = tbl[2]
            end
        end
        return self.effectActiveTable
    end

    function item_mt:getEffectPassive()
        if self.effectPassiveTable == nil then
            self.effectPassiveTable = { }
            local str = self.effect_passive
            local temptbl = stringToTable(str, '|')
            for k, v in pairs(temptbl) do
                local tbl = stringToNumberTable(v, '_')
                self.effectPassiveTable[tbl[1]] = tbl[2]
            end
        end
        return self.effectPassiveTable
    end

    for item in RedPacketAchievementData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindGetRolePriceData()
    function GetRolePriceData:getNowPrice(type, times)
        if times == nil then
            times = 0
        end
        local temp = nil
        for v in GetRolePriceData:iterator() do
            if v.type == type then
                if v.count == times then
                    return v.price
                end
                if (v.count < times and(temp == nil or v.count > temp.count)) then
                    temp = v
                end
            end
        end
        if temp == nil then
            return 0
        end
        return temp.price
    end
end

function BaseDataManager:BindEquipRecastConsumeData()
    function EquipRecastConsumeData:getConsumeItem(recastLevel, quality)
        for item in EquipRecastConsumeData:iterator() do
            if item.level == recastLevel and item.quality == quality then
                return item
            end
        end
        return nil
    end

    local item_mt = { }
    item_mt.__index = item_mt

    function item_mt:getConsume()
        local rewardList = TFArray:new()
        local consume = self.consume or ""
        local tab1 = string.split(consume, "|")
        for i = 1, #tab1 do
            local temp = tab1[i]
            local tab2 = string.split(temp, "_")
            local rewardTab = { }
            rewardTab.type = tonumber(tab2[1])
            rewardTab.itemId = tonumber(tab2[2])
            rewardTab.number = tonumber(tab2[3])
            rewardList:push(BaseDataManager:getReward(rewardTab))
        end
        return rewardList
    end

    -- 是否可以用本体代替
    function item_mt:getChange()
        local bCan = false
        if self.change and self.change > 0 then
            bCan = true
        end
        return bCan
    end

    for item in EquipRecastConsumeData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindJapanTeamChapterData()
    function JapanTeamChapterData:getAttributeByid(id)
        local tAttri = { }
        -- local tEffectActiveAttri = { }
        -- local tEffectPassive = { }
        for item in JapanTeamChapterData:iterator() do
            if item.chapter_id <= id then
                local attribute = item:getAttribute()
                for k, v in pairs(attribute) do
                    tAttri[k] = tAttri[k] or 0
                    tAttri[k] = tAttri[k] + v
                end
                -- attribute = item:getEffectActive()
                -- for k, v in pairs(attribute) do
                --     tEffectActiveAttri[k] = tEffectActiveAttri[k] or 0
                --     tEffectActiveAttri[k] = tEffectActiveAttri[k] + v
                -- end
                -- attribute = item:getEffectPassive()
                -- for k, v in pairs(attribute) do
                --     tEffectPassive[k] = tEffectPassive[k] or 0
                --     tEffectPassive[k] = tEffectPassive[k] + v
                -- end
            end
        end
        --return tAttri, tEffectActiveAttri, tEffectPassive
        return tAttri
    end

    function JapanTeamChapterData:objectByID(id)
        return self.itemList[id]
    end

    local item_mt = { }
    item_mt.__index = item_mt
    function item_mt:getAttribute()
        if self.attributeTable == nil then
            self.attributeTable = { }
            local str = self.achievement_attribute
            if str and str ~= "" then
                local temptbl = stringToTable(str, '|')
                for k, v in pairs(temptbl) do
                    local tbl = stringToNumberTable(v, '_')
                    self.attributeTable[tbl[1]] = tbl[2]
                end
            end
        end
        return self.attributeTable
    end

    function item_mt:getEffectActive()
        if self.effectActiveTable == nil then
            self.effectActiveTable = { }
            local str = self.effect_active
            if str and str ~= "" then
                local temptbl = stringToTable(str, '|')
                for k, v in pairs(temptbl) do
                    local tbl = stringToNumberTable(v, '_')
                    self.effectActiveTable[tbl[1]] = tbl[2]
                end
            end
        end
        return self.effectActiveTable
    end

    function item_mt:getEffectPassive()
        if self.effectPassiveTable == nil then
            self.effectPassiveTable = { }
            if str and str ~= "" then
                local str = self.effect_passive
                local temptbl = stringToTable(str, '|')
                for k, v in pairs(temptbl) do
                    local tbl = stringToNumberTable(v, '_')
                    self.effectPassiveTable[tbl[1]] = tbl[2]
                end
            end
        end
        return self.effectPassiveTable
    end

    JapanTeamChapterData.itemList = {}

    for item in JapanTeamChapterData:iterator() do
        JapanTeamChapterData.itemList[item.chapter_id] = item
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end

function BaseDataManager:BindJapanTeamCopyData()
    local item_mt = { }
    item_mt.__index = item_mt

    function JapanTeamCopyData:GetInfoByZoneId(chapter_id)
        local infoData = { }
        for v in JapanTeamCopyData:iterator() do
            if v.chapter_id == chapter_id then
                local index = #infoData + 1
                infoData[index] = v
            end
        end
        return infoData
    end

    function JapanTeamCopyData:GetInfoByZoneIdAndPoint(chapter_id, index)
        local infoData = self:GetInfoByZoneId(chapter_id)
        if infoData == nil then
            return nil
        end
        return infoData[index]
    end

    function item_mt:getNPCIdList()
        if self.formationsList == nil then
            self.formationsList = stringToNumberTable(self.formations, ',')
        end
        return self.formationsList
    end

    for item in JapanTeamCopyData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt)
    end
end



function BaseDataManager:BindBiblePracticeData()
    function BiblePracticeData:getItem(bibleQuality, pos, level)
        for v in BiblePracticeData:iterator() do
            if v.bible_quality == bibleQuality and v.position == pos and v.level == level then
                return v
            end
        end
        return nil
    end

    function BiblePracticeData:getTotalBaseAttribute(bibleQuality, pos, level)
        local attributeTable = {}
        if bibleQuality and pos and level and bibleQuality > 0 and pos > 0 and level > 0 then
            for v in BiblePracticeData:iterator() do
                if v.bible_quality == bibleQuality and v.position == pos and v.level <= level then
                    local att = v.attribute
                    if att ~= '' then
                        local tab = stringToNumberTable(att, '_')
                        local index = tab[1]
                        local num = tab[2]
                        attributeTable[index] = attributeTable[index] or 0
                        attributeTable[index] = attributeTable[index] + num
                    end
                end
            end
        end
        return attributeTable
    end

    function BiblePracticeData:getTotalPercent(bibleQuality, pos, level)
        local per = 0
        if bibleQuality and pos and level and bibleQuality > 0 and pos > 0 and level > 0 then
            for v in BiblePracticeData:iterator() do
                if v.bible_quality == bibleQuality and v.position == pos and v.level <= level then
                    local tempPer = v.extra_attribute
                    if tempPer and tempPer ~= "" then
                        tempPer = tonumber(tempPer)
                        per = per + tempPer
                    end
                end
            end
        end
        return per
    end

    function BiblePracticeData:getChongzhuMaxLevel(bibleQuality, pos)
        local maxLev = 0
        for v in BiblePracticeData:iterator() do
            if v.bible_quality == bibleQuality and v.position == pos then
                if v.level > maxLev then
                    maxLev = v.level
                end
            end
        end
        return maxLev
    end

    local item_mt = {} 
    item_mt.__index = item_mt

    function item_mt:getQuality()
        return self.quality
    end

    function item_mt:getConsume()
        local consumeList = {}
        local consume = self.consume
        if consume and consume ~= "" then
            local tab1 = stringToTable(consume, ",")
            for k, v in pairs(tab1) do
                local tab2 = stringToTable(v, "_")
                local temp = {}
                temp.type = tonumber(tab2[1])
                temp.id = tonumber(tab2[2])
                temp.num = tonumber(tab2[3])
                table.insert(consumeList, temp)
            end
        end
        return consumeList
    end

    for item in BiblePracticeData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt) 
    end
end

function BaseDataManager:BindBiblePracticeExtraData()
    local item_mt = {} 
    item_mt.__index = item_mt

    function BiblePracticeExtraData:getExtraItems(bibleId)
        local tab = {}
        for v in self:iterator() do
            if v.bible_id == bibleId then
                table.insert(tab, v)
            end
        end
        return tab
    end

    for item in BiblePracticeExtraData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt) 
    end
end


function BaseDataManager:BindBattlePetData()
    --通过装备类型获得此类型的装备集合
    function BattlePetData:GetPetAttrByEquipId( id )
        local team_attribute = {}
        for v in BattlePetData:iterator() do
            if v.id == id then
                local attrList  = string.split(v.team_attribute,'|')
                for _,info in ipairs(attrList) do
                    local attr      = string.split(info,'_')
                    local attrId    = tonumber(attr[1])
                    local attrValue = tonumber(attr[2])
                    team_attribute[attrId] = team_attribute[attrId] or 0
                    team_attribute[attrId] = attrValue + team_attribute[attrId]
                end
                return team_attribute
            end
        end
        return nil
    end

    local item_mt = {} 
    item_mt.__index = item_mt
    function item_mt:getIconPath(quality)
        if self.iconList == nil then
            self.iconList = string.split(self.icon, ",")
        end
        return "icon/item/".. self.iconList[quality]  .. ".png"
    end
    function item_mt:getIcon(quality)
        if self.iconList == nil then
            self.iconList = string.split(self.icon, ",")
        end
        return self.iconList[quality]
    end
    for item in BattlePetData:iterator() do
        item.__index = item_mt
        setmetatable(item, item_mt) 
    end
end
EffectExtraDataModel ={}
GameObjectModel    ={}
RoleEquipmentModel ={}
GameAttributeDataModel ={}
RoleEffectExtraDataModel ={}
EquipRefineBreachData  ={}
ItemData ={}
GemData ={}
EquipmentTemplateData ={}
IntensifyData ={}
GemPosData ={}
IntensifyVipData ={}
RoleData ={}
NPCData ={}
LevelData ={}
EquipStarExchangeData={}
SkillBaseData ={}
SkillAttributeData ={}
SkillLevelData ={}
SkillDisplayData ={}
LeadingRoleSpellData  ={}
SkillBufferData ={}
PlayerGuideData ={}
PlayerGuideStepData ={}
DropData ={}
DropGroupData ={}
RewardConfigureData ={}
RewardItemData ={}
ConstantData ={}
ShopData ={}
RandomShopData ={}
GiftPackData ={}
ProtagonistData ={}
RoleTrainData ={}
RoleFateData ={}
TaskData ={}
BoxKeyCouple  ={}
VipData ={}
EscortingNpc ={}
EscortingReward ={}
EscortingSetting ={}
OnlineReward={}
LogonReward={}
TeamLevelUpReward={}
MartialData={}
MartialEnchant ={}
MartialRoleConfigure ={}
DietData ={}
MenuBtnOpenData ={}
PlayerResConfigure ={}
MeridianConfigure ={}
MeridianConsume={}
AcupointBreachData={}
ClimbConfigure={}
ClimbRuleConfigure={}
MoHeYaConfigure ={}
FunctionOpenConfigure ={}
RandomMallConfigure={}
FightFailGuide={}
FightLoadingGuide={}
RoleSoundData={}
MartialLevelExchangeData={}
RoleTalentData          ={}
WorshipPlanConfig ={}
GuildWorshipConfig ={}
ChampionsAwardData ={}
ChampionsBoxData ={}
AgreeAttributeData ={}
AgreeRuleData ={}
GameRuleData ={}
RuleInfoData ={}
NorthCaveData ={}
NorthCaveNpcData ={}
BattleLimitedData ={}
NorthCaveExterAttrData ={}
GuildZoneData ={}
GuildZoneCheckPointData ={}
GuildZoneDpsAwardData ={}
GuildPracticePosData ={}
GuildPracticeData ={}
GuildPracticeStudyData ={}
GuildPracticeRuleData ={}
FactionLevelUpData ={}
EquipmentRecastData ={}
EquipmentRecastConditionData ={}
EquipmentRecastSubAddData ={}
QimenConfigData ={}
QimenBreachConfigData ={}
MercenaryConfig={}
ClimbLimitConfig={}
ClimbPassLimitConfig={}
QualityDevelopConfig={}
HeadPicFrameData ={}
GambleTypeData ={}
GambleZxData ={}
MonthCardBuffData ={}
EquipmentCCData ={}
BibleData ={}
EssentialData ={}
BibleBreachData ={}
AdventureRandomEventData ={}
adventureEventNpc ={}
AdventureShopData ={}
LianTiData ={}
LianTiExtraData ={}
LianTiOpenData ={}
InvocatoryRewardData ={}
PowerCompareData ={}
CrossGuildBattleCityData ={}
QianXiuConsumeData ={}
QianXiuAttributeData ={}
FundData ={}
PeakData ={}
EquipStarAttrAddData ={}
ZhuanJiData  ={}
ZhuanJiCondData  ={}
BibleGemData ={}
XilingData ={}
XilingExtraRewardData ={}
EquipmentThroughExpData ={}
EquipmentThroughAttribData ={}
EquipmentSpecialAttribData ={}
FamilyTurnTemplate ={}
FamilyData ={}
BattleArrayData ={}
BattleArrayStarData ={}
BattleArrayLevelData ={}
RedPacketData ={}
RedPacketAchievementData ={}
RechargeTicketData ={}
GetRolePriceData ={}
MoiveScriptData ={}
EquipRecastConsumeData ={}
VersionLockData ={}
MissionPrologueData ={}
PowerCompareMaxData = {}
JapanTeamChapterData = {}
JapanTeamCopyData = {}
BuffFightDisplayData = {}
BiblePracticeData = {}
BiblePracticeExtraData = {}
BattlePetData = {}
-- requireNameList ={
-- "lua.gamedata.base.EffectExtraData",
-- "lua.gamedata.base.GameObject",
-- "lua.gamedata.base.RoleEquipment",
-- "lua.gamedata.base.GameAttributeData",
-- "lua.gamedata.base.RoleEffectExtraData",
-- "lua.table.t_s_refine_breach",
-- "lua.table.t_s_goods",
-- "lua.table.t_s_gem",
-- "lua.table.t_s_equip_template",
-- "lua.table.t_s_equip_intensify",
-- "lua.table.t_s_gem_pos",
-- "lua.table.t_s_equip_intensify_vip",
-- "lua.table.t_s_role",
-- "lua.table.t_s_npc_instance",
-- "lua.table.t_s_unit_exp",
-- "lua.table.t_s_equip_star_exchange",
-- "lua.table.t_s_spell",
-- "lua.table.t_s_spell_attribute",
-- "lua.gamedata.SkillLevelData",
-- "lua.table.t_s_skill_display",
-- "lua.table.t_s_leading_role_spell",
-- "lua.table.t_s_buffer_2",
-- "lua.table.t_s_player_guide",
-- "lua.table.t_s_player_guideStep",
-- "lua.table.t_s_item_drop",
-- "lua.table.t_s_item_dropgroup",
-- "lua.table.t_s_reward_configure",
-- "lua.table.t_s_reward_item",
-- "lua.table.t_s_constant",
-- "lua.table.t_s_gift_shop",
-- "lua.table.t_s_goods_shop",
-- "lua.table.t_s_goods_gift_pack",
-- "lua.table.t_s_protagonist",
-- "lua.table.t_s_role_train",
-- "lua.table.t_s_role_fate",
-- "lua.table.t_s_mission_template",
-- "lua.table.t_s_goods_box_key_couple",
-- "lua.table.t_s_vip_rule",
-- "lua.table.t_s_escorting_npc",
-- "lua.table.t_s_escorting_reward",
-- "lua.table.t_s_escorting_setting",
-- "lua.table.t_s_open_service_ol",
-- "lua.table.t_s_open_service_sign",
-- "lua.table.t_s_open_service_team_lv_up",
-- "lua.table.t_s_martial",
-- "lua.table.t_s_martial_enchant",
-- "lua.table.t_s_martial_role",
-- "lua.table.t_s_diet",
-- "lua.table.t_s_menubtn",
-- "lua.table.t_s_resource",
-- "lua.table.t_s_meridian_conf",
-- "lua.table.t_s_meridian_consume",
-- "lua.table.t_s_acupoint_breach",
-- "lua.table.t_s_climb",
-- "lua.table.t_s_climb_rule",
-- "lua.table.t_s_climb_wanneng",
-- "lua.table.t_s_functionopen",
-- "lua.table.t_s_random_mall",
-- "lua.table.t_s_fightFail",
-- "lua.table.t_s_fight_load",
-- "lua.table.t_s_sound",
-- "lua.table.t_s_martial_level_exchange",
-- "lua.table.t_s_role_talent",
-- "lua.table.t_s_worship_plan",
-- "lua.table.t_s_guild_worship",
-- "lua.table.t_s_champions_award",
-- "lua.table.t_s_champions_box",
-- "lua.table.t_s_agree_attribute",
-- "lua.table.t_s_agree_rule",
-- "lua.table.t_s_rule",
-- "lua.table.t_s_rule_info",
-- "lua.table.t_s_north_cave",
-- "lua.table.t_s_north_cave_npc",
-- "lua.table.t_s_battle_limited",
-- "lua.table.t_s_north_cave_extra_attr",
-- "lua.table.t_s_guild_zone",
-- "lua.table.t_s_guild_zone_checkpoint",
-- "lua.table.t_s_guild_zone_dps_award",
-- "lua.table.t_s_guild_practice_pos",
-- "lua.table.t_s_guild_practice",
-- "lua.table.t_s_guild_practice_study",
-- "lua.table.t_s_guild_practice_rule",
-- "lua.table.t_s_guild_rule",
-- "lua.table.t_s_equipment_recast",
-- "lua.table.t_s_equipment_recast_condition",
-- "lua.table.t_s_equipment_recast_subadd",
-- "lua.table.t_s_qimen_config",
-- "lua.table.t_s_qimen_breach_config",
-- "lua.table.t_s_mercenary_conf",
-- "lua.table.t_s_climb_limit",
-- "lua.table.t_s_climb_pass_limit",
-- "lua.table.t_s_develop_quality",
-- "lua.table.t_s_head_pic_frame",
-- "lua.table.t_s_gambling_type",
-- "lua.table.t_s_gambling_zx",
-- "lua.table.t_s_month_card_buff_conf",
-- "lua.table.t_s_equipment_cc",
-- "lua.table.t_s_bible",
-- "lua.table.t_s_essential",
-- "lua.table.t_s_bible_breach",
-- "lua.table.t_s_adventure_event",
-- "lua.table.t_s_adventure_event_npc",
-- "lua.table.t_s_adventure_shop",
-- "lua.table.t_s_forging",
-- "lua.table.t_s_forging_extra",
-- "lua.table.t_s_forging_open",
-- "lua.table.t_s_invocatory_reward",
-- "lua.table.t_s_power_compare",
-- "lua.table.t_s_cross_guild_battle_city",
-- "lua.table.t_s_potential_practice",
-- "lua.table.t_s_potential_practice_attribute",
-- "lua.table.t_s_fund",
-- "lua.table.t_s_peak",
-- "lua.table.t_s_equipment_star_conn",
-- "lua.table.t_s_hero_pu",
-- "lua.table.t_s_hero_pu_cond",
-- "lua.table.t_s_bible_gem",
-- "lua.table.t_s_serdang",
-- "lua.table.t_s_serdang_extra_attr",
-- "lua.table.t_s_equipment_through_exp",
-- "lua.table.t_s_equipment_through_attrib",
-- "lua.table.t_s_equipment_special_attrib",
-- "lua.table.t_s_home_turntable",
-- "lua.table.t_s_home",
-- "lua.table.t_s_battle_array.lua",
-- "lua.table.t_s_battle_array_star.lua",
-- "lua.table.t_s_battle_array_level.lua",
-- "lua.table.t_s_red_packet",
-- "lua.table.t_s_red_packet_achievement",
-- "lua.table.t_s_recharge_ticket",
-- "lua.table.t_s_recruit_price",
-- "lua.table.t_s_moive_script",
-- "lua.table.t_s_equipment_recast_consume",
-- "lua.table.t_s_version_lock",
-- "lua.table.t_s_prologue",
-- "lua.table.t_s_power_compare_max"
-- }


-- functions ={
-- "EffectExtraDataModel",
-- "GameObjectModel",
-- "RoleEquipmentModel",
-- "GameAttributeDataModel",
-- "RoleEffectExtraDataModel",
-- "EquipRefineBreachData",
-- "ItemData",
-- "GemData",
-- "EquipmentTemplateData",
-- "IntensifyData",
-- "GemPosData",
-- "IntensifyVipData",
-- "RoleData",
-- "NPCData",
-- "LevelData",
-- "EquipStarExchangeData",
-- "SkillBaseData",
-- "SkillAttributeData",
-- "SkillLevelData",
-- "SkillDisplayData",
-- "LeadingRoleSpellData",
-- "SkillBufferData",
-- "PlayerGuideData",
-- "PlayerGuideStepData",
-- "DropData",
-- "DropGroupData",
-- "RewardConfigureData",
-- "RewardItemData",
-- "ConstantData",
-- "ShopData",
-- "RandomShopData",
-- "GiftPackData",
-- "ProtagonistData",
-- "RoleTrainData",
-- "RoleFateData",
-- "TaskData",
-- "BoxKeyCouple",
-- "VipData",
-- "EscortingNpc",
-- "EscortingReward",
-- "EscortingSetting",
-- "OnlineReward",
-- "LogonReward",
-- "TeamLevelUpReward",
-- "MartialData",
-- "MartialEnchant",
-- "MartialRoleConfigure",
-- "DietData",
-- "MenuBtnOpenData",
-- "PlayerResConfigure",
-- "MeridianConfigure",
-- "MeridianConsume",
-- "AcupointBreachData",
-- "ClimbConfigure",
-- "ClimbRuleConfigure",
-- "MoHeYaConfigure",
-- "FunctionOpenConfigure",
-- "RandomMallConfigure",
-- "FightFailGuide",
-- "FightLoadingGuide",
-- "RoleSoundData",
-- "MartialLevelExchangeData",
-- "RoleTalentData",
-- "WorshipPlanConfig",
-- "GuildWorshipConfig",
-- "ChampionsAwardData",
-- "ChampionsBoxData",
-- "AgreeAttributeData",
-- "AgreeRuleData",
-- "GameRuleData",
-- "RuleInfoData",
-- "NorthCaveData",
-- "NorthCaveNpcData",
-- "BattleLimitedData",
-- "NorthCaveExterAttrData",
-- "GuildZoneData",
-- "GuildZoneCheckPointData",
-- "GuildZoneDpsAwardData",
-- "GuildPracticePosData",
-- "GuildPracticeData",
-- "GuildPracticeStudyData",
-- "GuildPracticeRuleData",
-- "FactionLevelUpData",
-- "EquipmentRecastData",
-- "EquipmentRecastConditionData",
-- "EquipmentRecastSubAddData",
-- "QimenConfigData",
-- "QimenBreachConfigData",
-- "MercenaryConfig",
-- "ClimbLimitConfig",
-- "ClimbPassLimitConfig",
-- "QualityDevelopConfig",
-- "HeadPicFrameData",
-- "GambleTypeData",
-- "GambleZxData",
-- "MonthCardBuffData",
-- "EquipmentCCData",
-- "BibleData",
-- "EssentialData",
-- "BibleBreachData",
-- "AdventureRandomEventData",
-- "adventureEventNpc",
-- "AdventureShopData",
-- "LianTiData",
-- "LianTiExtraData",
-- "LianTiOpenData",
-- "InvocatoryRewardData",
-- "PowerCompareData",
-- "CrossGuildBattleCityData",
-- "QianXiuConsumeData",
-- "QianXiuAttributeData",
-- "FundData",
-- "PeakData",
-- "EquipStarAttrAddData",
-- "ZhuanJiData",
-- "ZhuanJiCondData",
-- "BibleGemData",
-- "XilingData",
-- "XilingExtraRewardData",
-- "EquipmentThroughExpData",
-- "EquipmentThroughAttribData",
-- "EquipmentSpecialAttribData",
-- "FamilyTurnTemplate",
-- "FamilyData",
-- "BattleArrayData",
-- "BattleArrayStarData",
-- "BattleArrayLevelData",
-- "RedPacketData",
-- "RedPacketAchievementData",
-- "RechargeTicketData",
-- "GetRolePriceData",
-- "MoiveScriptData",
-- "EquipRecastConsumeData",
-- "VersionLockData",
-- "MissionPrologueData",
-- "PowerCompareMaxData"
-- }

m_baseDataConfig = {
    {"EffectExtraDataModel"         ,"lua.gamedata.base.EffectExtraData"            ,nil},
    {"GameObjectModel"              ,"lua.gamedata.base.GameObject"                 ,nil},
    {"RoleEquipmentModel"           ,"lua.gamedata.base.RoleEquipment"              ,nil},
    {"GameAttributeDataModel"       ,"lua.gamedata.base.GameAttributeData"          ,nil},
    {"RoleEffectExtraDataModel"     ,"lua.gamedata.base.RoleEffectExtraData"        ,nil},
    {"EquipRefineBreachData"        ,"lua.table.t_s_refine_breach"                  ,nil},
    {"ItemData"                     ,"lua.table.t_s_goods"                          ,BaseDataManager.BindItemData},
    {"GemData"                      ,"lua.table.t_s_gem"                            ,BaseDataManager.BindGemData},
    {"EquipmentTemplateData"        ,"lua.table.t_s_equip_template"                 ,BaseDataManager.BindEquipmentTemplateData},
    {"IntensifyData"                ,"lua.table.t_s_equip_intensify"                ,BaseDataManager.BindIntensifyData},
    {"GemPosData"                   ,"lua.table.t_s_gem_pos"                        ,BaseDataManager.BindGemPosData},
    {"IntensifyVipData"             ,"lua.table.t_s_equip_intensify_vip"            ,nil},
    {"RoleData"                     ,"lua.table.t_s_role"                           ,BaseDataManager.BindRoleData},
    {"NPCData"                      ,"lua.table.t_s_npc_instance"                   ,BaseDataManager.BindNPCData},
    {"LevelData"                    ,"lua.table.t_s_unit_exp"                       ,BaseDataManager.BindLevelData},
    {"EquipStarExchangeData"        ,"lua.table.t_s_equip_star_exchange"            ,nil},
    {"SkillBaseData"                ,"lua.table.t_s_spell"                          ,BaseDataManager.BindSkillBaseData},
    {"SkillAttributeData"           ,"lua.table.t_s_spell_attribute"                ,nil},
    {"SkillLevelData"               ,"lua.gamedata.SkillLevelData"                  ,BaseDataManager.BindSkillLevelData},
    {"SkillDisplayData"             ,"lua.table.t_s_skill_display"                  ,nil},
    {"LeadingRoleSpellData"         ,"lua.table.t_s_leading_role_spell"             ,BaseDataManager.BindLeadingRoleSpellData},
    {"SkillBufferData"              ,"lua.table.t_s_buffer_2"                       ,nil},
    {"PlayerGuideData"              ,"lua.table.t_s_player_guide"                   ,BaseDataManager.BindPlayerGuideData},
    {"PlayerGuideStepData"          ,"lua.table.t_s_player_guideStep"               ,BaseDataManager.BindPlayerGuideStepData},
    {"DropData"                     ,"lua.table.t_s_item_drop"                      ,BaseDataManager.BindDropData},
    {"DropGroupData"                ,"lua.table.t_s_item_dropgroup"                 ,BaseDataManager.BindDropGroupData},
    {"RewardConfigureData"          ,"lua.table.t_s_reward_configure"               ,BaseDataManager.BindRewardConfigureData},
    {"RewardItemData"               ,"lua.table.t_s_reward_item"                    ,nil},
    {"ConstantData"                 ,"lua.table.t_s_constant"                       ,BaseDataManager.BindConstantData},
    {"ShopData"                     ,"lua.table.t_s_gift_shop"                      ,BaseDataManager.BindShopData},
    {"RandomShopData"               ,"lua.table.t_s_goods_shop"                     ,BaseDataManager.BindRandomShopData},
    {"GiftPackData"                 ,"lua.table.t_s_goods_gift_pack"                ,BaseDataManager.BindGiftPackData},
    {"ProtagonistData"              ,"lua.table.t_s_protagonist"                    ,BaseDataManager.BindProtagonistData},
    {"RoleTrainData"                ,"lua.table.t_s_role_train"                     ,BaseDataManager.BindRoleTrainData},
    {"RoleFateData"                 ,"lua.table.t_s_role_fate"                      ,BaseDataManager.BindRoleFateData},
    {"TaskData"                     ,"lua.table.t_s_mission_template"               ,nil},
    {"BoxKeyCouple"                 ,"lua.table.t_s_goods_box_key_couple"           ,nil},
    {"VipData"                      ,"lua.table.t_s_vip_rule"                       ,BaseDataManager.BindVipDataData},
    {"EscortingNpc"                 ,"lua.table.t_s_escorting_npc"                  ,nil},
    {"EscortingReward"              ,"lua.table.t_s_escorting_reward"               ,BaseDataManager.BindEscortingDataFunc},
    {"EscortingSetting"             ,"lua.table.t_s_escorting_setting"              ,nil},
    {"OnlineReward"                 ,"lua.table.t_s_open_service_ol"                ,nil},
    {"LogonReward"                  ,"lua.table.t_s_open_service_sign"              ,nil},
    {"TeamLevelUpReward"            ,"lua.table.t_s_open_service_team_lv_up"            ,nil},
    {"MartialData"                  ,"lua.table.t_s_martial"                        ,BaseDataManager.BindMartial},
    {"MartialEnchant"               ,"lua.table.t_s_martial_enchant"                ,BaseDataManager.BindMartialEnchant},
    {"MartialRoleConfigure"         ,"lua.table.t_s_martial_role"                   ,BaseDataManager.BindMartialRoleConfigure},
    {"DietData"                     ,"lua.table.t_s_diet"                           ,BaseDataManager.BindDiet},
    {"MenuBtnOpenData"              ,"lua.table.t_s_menubtn"                        ,BaseDataManager.BindMenuBtnOpenData},
    {"PlayerResConfigure"           ,"lua.table.t_s_resource"                       ,BaseDataManager.BindPlayerResConfigure},
    {"MeridianConfigure"            ,"lua.table.t_s_meridian_conf"                  ,BaseDataManager.BindMeridianConfigure},
    {"MeridianConsume"              ,"lua.table.t_s_meridian_consume"               ,nil},
    {"AcupointBreachData"           ,"lua.table.t_s_acupoint_breach"                ,BaseDataManager.BindAcupointBreachData},
    {"ClimbConfigure"               ,"lua.table.t_s_climb"                          ,nil},
    {"ClimbRuleConfigure"           ,"lua.table.t_s_climb_rule"                     ,BaseDataManager.BindClimbRuleConfigure},
    {"MoHeYaConfigure"              ,"lua.table.t_s_climb_wanneng"                  ,BaseDataManager.BindMoHeYaConfigure},
    {"FunctionOpenConfigure"            ,"lua.table.t_s_functionopen"               ,BaseDataManager.FunctionOpenConfigureBindings},
    {"RandomMallConfigure"          ,"lua.table.t_s_random_mall"                    ,nil},
    {"FightFailGuide"               ,"lua.table.t_s_fightFail"                      ,BaseDataManager.BindFightFailGuide},
    {"FightLoadingGuide"            ,"lua.table.t_s_fight_load"                     ,BaseDataManager.BindFightLoadingGuide},
    {"RoleSoundData"                ,"lua.table.t_s_sound"                          ,BaseDataManager.BindRoleSoundData},
    {"MartialLevelExchangeData"         ,"lua.table.t_s_martial_level_exchange"         ,BaseDataManager.BindMartialLevelExchangeData},
    {"RoleTalentData"               ,"lua.table.t_s_role_talent"                    ,BaseDataManager.BindRoleTalentData},
    {"WorshipPlanConfig"            ,"lua.table.t_s_worship_plan"                   ,BaseDataManager.BindWorshipPlan},
    {"GuildWorshipConfig"           ,"lua.table.t_s_guild_worship"                  ,BaseDataManager.BindGuildWorship},
    {"ChampionsAwardData"           ,"lua.table.t_s_champions_award"                ,BaseDataManager.BindChampionsAwardData},
    {"ChampionsBoxData"             ,"lua.table.t_s_champions_box"                  ,BaseDataManager.BindChampionsBoxData},
    {"AgreeAttributeData"           ,"lua.table.t_s_agree_attribute"                ,BaseDataManager.BindAgreeAttributeData},
    {"AgreeRuleData"                ,"lua.table.t_s_agree_rule"                     ,BaseDataManager.BindAgreeRuleData},
    {"GameRuleData"                 ,"lua.table.t_s_rule"                           ,nil},
    {"RuleInfoData"                 ,"lua.table.t_s_rule_info"                      ,nil},
    {"NorthCaveData"                ,"lua.table.t_s_north_cave"                     ,nil},
    {"NorthCaveNpcData"             ,"lua.table.t_s_north_cave_npc"                 ,nil},
    {"BattleLimitedData"            ,"lua.table.t_s_battle_limited"                 ,BaseDataManager.BindBattleLimitedData},
    {"NorthCaveExterAttrData"           ,"lua.table.t_s_north_cave_extra_attr"          ,nil},
    {"GuildZoneData"                ,"lua.table.t_s_guild_zone"                     ,BaseDataManager.BindGuildZoneData},
    {"GuildZoneCheckPointData"          ,"lua.table.t_s_guild_zone_checkpoint"          ,BaseDataManager.BindGuildZoneCheckPointData},
    {"GuildZoneDpsAwardData"            ,"lua.table.t_s_guild_zone_dps_award"           ,BaseDataManager.BindGuildZoneDpsAwardData},
    {"GuildPracticePosData"         ,"lua.table.t_s_guild_practice_pos"             ,BaseDataManager.BindGuildPracticePosData},
    {"GuildPracticeData"            ,"lua.table.t_s_guild_practice"                 ,BaseDataManager.BindGuildPracticeData},
    {"GuildPracticeStudyData"           ,"lua.table.t_s_guild_practice_study"           ,BaseDataManager.BindGuildPracticeStudyData},
    {"GuildPracticeRuleData"            ,"lua.table.t_s_guild_practice_rule"            ,BaseDataManager.BindGuildPracticeRuleData},
    {"FactionLevelUpData"           ,"lua.table.t_s_guild_rule"                     ,nil},
    {"EquipmentRecastData"          ,"lua.table.t_s_equipment_recast"               ,BaseDataManager.BindEquipmentRecastData},
    {"EquipmentRecastConditionData"     ,"lua.table.t_s_equipment_recast_condition"     ,BaseDataManager.BindEquipmentRecastConditionData},
    {"EquipmentRecastSubAddData"        ,"lua.table.t_s_equipment_recast_subadd"        ,BaseDataManager.BindEquipmentRecastSubAddData},
    {"QimenConfigData"              ,"lua.table.t_s_qimen_config"                   ,BaseDataManager.BindQimenConfigData},
    {"QimenBreachConfigData"            ,"lua.table.t_s_qimen_breach_config"            ,BaseDataManager.BindQimenBreachConfigData},
    {"MercenaryConfig"              ,"lua.table.t_s_mercenary_conf"                 ,BaseDataManager.BindMercenaryConfig},
    {"ClimbLimitConfig"             ,"lua.table.t_s_climb_limit"                    ,nil},
    {"ClimbPassLimitConfig"         ,"lua.table.t_s_climb_pass_limit"               ,nil},
    {"QualityDevelopConfig"         ,"lua.table.t_s_develop_quality"                ,nil},
    {"HeadPicFrameData"             ,"lua.table.t_s_head_pic_frame"                 ,nil},
    {"GambleTypeData"               ,"lua.table.t_s_gambling_type"                  ,BaseDataManager.BindGambleTypeData},
    {"GambleZxData"                 ,"lua.table.t_s_gambling_zx"                    ,BaseDataManager.BindGambleZxData},
    {"MonthCardBuffData"            ,"lua.table.t_s_month_card_buff_conf"           ,BaseDataManager.BindMonthCardBuffData},
    {"EquipmentCCData"              ,"lua.table.t_s_equipment_cc"                   ,nil},
    {"BibleData"                    ,"lua.table.t_s_bible"                          ,BaseDataManager.BindBibleData},
    {"EssentialData"                ,"lua.table.t_s_essential"                      ,nil},
    {"BibleBreachData"              ,"lua.table.t_s_bible_breach"                   ,BaseDataManager.BindBibleBreachData},
    {"AdventureRandomEventData"         ,"lua.table.t_s_adventure_event"            ,BaseDataManager.BindAdventureRandomEventData},
    {"adventureEventNpc"            ,"lua.table.t_s_adventure_event_npc"            ,BaseDataManager.BindAdventureEventNpc},
    {"AdventureShopData"            ,"lua.table.t_s_adventure_shop"                 ,nil},
    {"LianTiData"                   ,"lua.table.t_s_forging"                        ,BaseDataManager.BindLianTiData},
    {"LianTiExtraData"              ,"lua.table.t_s_forging_extra"                  ,BaseDataManager.BindLianTiExtraData},
    {"LianTiOpenData"               ,"lua.table.t_s_forging_open"                   ,nil},
    {"InvocatoryRewardData"         ,"lua.table.t_s_invocatory_reward"              ,nil},
    {"PowerCompareData"             ,"lua.table.t_s_power_compare"                  ,BaseDataManager.BindPowerCompareData},
    {"CrossGuildBattleCityData"         ,"lua.table.t_s_cross_guild_battle_city"        ,nil},
    {"QianXiuConsumeData"           ,"lua.table.t_s_potential_practice"             ,nil},
    {"QianXiuAttributeData"         ,"lua.table.t_s_potential_practice_attribute"       ,BaseDataManager.BindQianXiuAttributeData},
    {"FundData"                     ,"lua.table.t_s_fund"                           ,BaseDataManager.BindFundData},
    {"PeakData"                     ,"lua.table.t_s_peak"                           ,BaseDataManager.BindPeakData},
    {"EquipStarAttrAddData"         ,"lua.table.t_s_equipment_star_conn"            ,nil},
    {"ZhuanJiData"                  ,"lua.table.t_s_hero_pu"                        ,BaseDataManager.BindZhuanJiData},
    {"ZhuanJiCondData"              ,"lua.table.t_s_hero_pu_cond"                   ,BaseDataManager.BindZhuanJiCondData},
    {"BibleGemData"                 ,"lua.table.t_s_bible_gem"                      ,BaseDataManager.BindBibleGemData},
    {"XilingData"                   ,"lua.table.t_s_serdang"                        ,nil},
    {"XilingExtraRewardData"            ,"lua.table.t_s_serdang_extra_attr"         ,nil},
    {"EquipmentThroughExpData"          ,"lua.table.t_s_equipment_through_exp"          ,BaseDataManager.BindEquipmentThroughExpData},
    {"EquipmentThroughAttribData"       ,"lua.table.t_s_equipment_through_attrib"       ,BaseDataManager.BindEquipmentThroughAttribData},
    {"EquipmentSpecialAttribData"       ,"lua.table.t_s_equipment_special_attrib"       ,BaseDataManager.BindEquipmentSpecialAttribData},
    {"FamilyTurnTemplate"           ,"lua.table.t_s_home_turntable"                 ,nil},
    {"FamilyData"                   ,"lua.table.t_s_home"                           ,BaseDataManager.BindFamilyData},
    {"BattleArrayData"              ,"lua.table.t_s_battle_array.lua"               ,BaseDataManager.BindBattleArrayData},
    {"BattleArrayStarData"          ,"lua.table.t_s_battle_array_star.lua"          ,BaseDataManager.BindBattleArrayStarData},
    {"BattleArrayLevelData"         ,"lua.table.t_s_battle_array_level.lua"         ,BaseDataManager.BindBattleArrayLevelData},
    {"RedPacketData"                ,"lua.table.t_s_red_packet"                     ,BaseDataManager.BindRedPacketData},
    {"RedPacketAchievementData"         ,"lua.table.t_s_red_packet_achievement"         ,BaseDataManager.BindRedPacketAchievementData},
    {"RechargeTicketData"           ,"lua.table.t_s_recharge_ticket"                ,nil},
    {"GetRolePriceData"             ,"lua.table.t_s_recruit_price"                  ,BaseDataManager.BindGetRolePriceData},
    {"MoiveScriptData"              ,"lua.table.t_s_moive_script"                   ,nil},
    {"EquipRecastConsumeData"       ,"lua.table.t_s_equipment_recast_consume"       ,BaseDataManager.BindEquipRecastConsumeData},
    {"VersionLockData"              ,"lua.table.t_s_version_lock"                   ,nil},
    {"MissionPrologueData"          ,"lua.table.t_s_prologue"                       ,nil},
    {"PowerCompareMaxData"          ,"lua.table.t_s_power_compare_max"              ,BaseDataManager.BindPowerCompareMaxData},
    {"JapanTeamChapterData"         ,"lua.table.t_s_team_chapter"                   ,BaseDataManager.BindJapanTeamChapterData},
    {"JapanTeamCopyData"            ,"lua.table.t_s_team_copy"                      ,BaseDataManager.BindJapanTeamCopyData},
    {"BuffFightDisplayData"         ,"lua.table.t_s_buff_display"                   ,nil},
    {"HomePraiseAwardData"          ,"lua.table.t_s_home_praise_award"                   ,nil},
    {"StarHeroRewardData"           ,"lua.table.t_s_star_hero_reward"                   ,nil},
    {"BiblePracticeData"            ,"lua.table.t_s_bible_practice"                 ,BaseDataManager.BindBiblePracticeData},
    {"BiblePracticeExtraData"       ,"lua.table.t_s_bible_practice_extra"           ,BaseDataManager.BindBiblePracticeExtraData},
    {"BattlePetData"                ,"lua.table.t_s_battle_pet"                     ,BaseDataManager.BindBattlePetData},
}

BaseDataManager = BaseDataManager:new()
functionId = 1
size = #m_baseDataConfig
local loadInfo      = GetLoadFileList()
local bar_load      = nil
local txt_update    = nil
TFDirector:addTimer(10,size, 
        function ()
            TFDirector:dispatchGlobalEventWith("BaseDataManager.LoadOver", {})
        end,
        function()     
               --local str =  _G[functionId]  
               local name       =   m_baseDataConfig[functionId][1]
               local config     =   m_baseDataConfig[functionId][2]
               local configDataFunc = m_baseDataConfig[functionId][3]
               --name = {}                   
               _G[name]   = require(config)  
               if configDataFunc then
                    configDataFunc(BaseDataManager)
               end
              -- print("requirename-----------------"..requireNameList[functionId])
               functionId = functionId + 1  
               --print("functionid-------"..functionId)

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
                local addLoadNum    = loadInfo[2] or 0
                local maxSize       = loadInfo[1] or size
                local currLoad      = addLoadNum + functionId
                if (bar_load) then
                    bar_load:setPercent((currLoad / maxSize) * 100)
                end
               
                if (txt_update) then
                    txt_update:setText(stringUtils.format(localizable.updateLaye_loading_lua, currLoad, maxSize))
                end
        end
        )


return BaseDataManager

