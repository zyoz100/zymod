local _G = GLOBAL
local shopSellRate = GetModConfigData("shopSellRate") or 0;
local shopSellValidBySora = GetModConfigData("shopSellValidBySora") or 0;
local shopCoolDown = GetModConfigData("shopCoolDown") or 0;
local shopCanByHSH = GetModConfigData("shopCanByHSH") or false;

if shopSellRate > 0 then
    local findGoods = function(name)
        local res;
        if GLOBAL.TUNING.STORE_GOODS and type(GLOBAL.TUNING.STORE_GOODS["allgoods"]) == "table" then
            for i, item in pairs(GLOBAL.TUNING.STORE_GOODS["allgoods"]) do
                if res then
                    break ;
                end
                if item.name == name then
                    res = item
                end
            end
        end
        return res;
    end

    if shopSellValidBySora > 0 then
        local DEFAULT_SELL_PRICE = 2;
        -- copy from sora
        local changelist = {
            ice = "charcoal",
            charcoal = "ice",
            --岩石->燧石->硝石
            rocks = "flint",
            flint = "nitre",
            nitre = "rocks",
            --宝石
            redgem = "bluegem",
            bluegem = "redgem",
            orangegem = "yellowgem",
            yellowgem = "orangegem",
            purplegem = "greengem",
            greengem = "purplegem",
            --金子->元宝
            goldnugget = "lucky_goldnugget",
            lucky_goldnugget = "goldnugget",
            --蘑菇系列
            --孢子
            spore_small = "spore_medium",
            spore_medium = "spore_tall",
            spore_tall = "spore_small",
            --蘑菇
            red_mushroom = "green_mushroom",
            green_mushroom = "blue_mushroom",
            blue_mushroom = "red_mushroom",
            --蘑菇树
            mushtree_small = "mushtree_medium",
            mushtree_medium = "mushtree_tall",
            mushtree_tall = "mushtree_small",
            mushtree_small_stump = "mushtree_medium_stump",
            mushtree_medium_stump = "mushtree_tall_stump",
            mushtree_tall_stump = "mushtree_small_stump",
            --采下的蘑菇
            red_cap = "green_cap",
            green_cap = "blue_cap",
            blue_cap = "red_cap",
            --烤蘑菇
            red_cap_cooked = "green_cap_cooked",
            green_cap_cooked = "blue_cap_cooked",
            blue_cap_cooked = "red_cap_cooked",
            --荧光花
            flower_cave = "flower_cave_double",
            flower_cave_double = "flower_cave_triple",
            flower_cave_triple = "flower_cave",

            --花
            flower = "flower_evil",
            flower_evil = "flower",
            petals = "petals_evil",
            petals_evil = "petals",
            --浆果丛
            berrybush = "berrybush2",
            berrybush2 = "berrybush_juicy",
            berrybush_juicy = "berrybush",
            --树苗 月树苗
            sapling = "sapling_moon",
            sapling_moon = "sapling",
            dug_berrybush = "dug_berrybush2",
            dug_berrybush2 = "dug_berrybush_juicy",
            dug_berrybush_juicy = "dug_berrybush",
            --浆果
            berries = "berries_juicy",
            berries_juicy = "berries",
            berries_cooked = "berries_juicy_cooked",
            berries_juicy_cooked = "berries_cooked",
            --蛙腿鸡腿
            froglegs = "drumstick",
            drumstick = "froglegs",
            --牛角电羊角海象牙
            horn = "walrus_tusk",
            walrus_tusk = "lightninggoathorn",
            lightninggoathorn = "horn",
            --羽毛
            feather_crow = "feather_robin",
            feather_robin = "feather_robin_winter",
            feather_robin_winter = "feather_crow",
            --蜂刺狗牙
            stinger = "houndstooth",
            houndstooth = "stinger",
            --牛毛蜘蛛丝
            silk = "beefalowool",
            beefalowool = "silk",
            --蜘蛛腺 蚊子血囊
            spidergland = "mosquitosack",
            mosquitosack = "spidergland",
            --猪皮兔毛触手皮
            tentaclespots = "manrabbit_tail",
            manrabbit_tail = "pigskin",
            pigskin = "tentaclespots",
            --冰狗火狗
            firehound = "icehound",
            icehound = "firehound",
            --龙鳞魔蛤皮
            shroom_skin = "dragon_scales",
            dragon_scales = "shroom_skin",
            --粪便-鸟粪
            poop = "guano",
            guano = "poop",
            --骨片-化石碎片
            boneshard = "fossil_piece",
            fossil_piece = "boneshard",
            --玻璃 月亮石
            moonglass = "moonrocknugget",
            moonrocknugget = "moonglass",
            --蝴蝶-月娥
            butterfly = "moonbutterfly",
            moonbutterfly = "butterfly",
            --翅膀-黄油
            butterflywings = "butter",
            moonbutterflywings = "butter",

            --蒜粉 辣椒 糖

            spice_chili = "spice_garlic",

            spice_garlic = "spice_chili",
            spice_sugar = "spice_salt",
            spice_salt = "spice_sugar",
            --大蒜->洋葱->辣椒
            garlic = "onion",
            onion = "pepper",
            pepper = "garlic",

            evergreen = "evergreen_sparse_tall",
            evergreen_sparse = "rock_petrified_tree_tall",
            rock_petrified_tree = "evergreen_tall",

            --大理石--玄武岩
            marbleshrub = "marbletree",
            marbletree = "basalt",
            basalt = "basalt_pillar",
            basalt_pillar = "marblepillar",
            marblepillar = "statueharp",
            statueharp = "statue_marble_pawn",
            statue_marble = "statuemaxwell",
            statuemaxwell = "marbleshrub",

            moonbase = "moondial",
            moondial = "moonbase",
            --胡萝卜-胡萝卜鼠-曼德拉草
            carrot_planted = "carrat_planted",
            carrat_planted = "mandrake_planted",
            carrat = "mandrake_planted",
            mandrake_planted = "carrot_planted",
            --地毯-贝壳
            turf_carpetfloor = "turf_shellbeach",
            turf_shellbeach = "turf_carpetfloor",
            --邪天翁羽毛-鹅毛
            malbatross_feather = "goose_feather",
            goose_feather = "malbatross_feather",
            --蜂巢 杀人蜂巢
            wasphive = "beehive",
            beehive = "wasphive",
            --壳碎片 饼干切割机壳
            slurtle_shellpieces = "cookiecuttershell",
            cookiecuttershell = "slurtle_shellpieces",
            --棋盘-卵石路
            turf_road = "turf_checkerfloor",
            turf_checkerfloor = "turf_road",
        }
        GLOBAL.TUNING.ZY_STORE_SELL_LIST = {};
        for k, v in pairs(changelist) do
            local from = findGoods(k);
            if from then
                local b = {};
                while true do
                    if table.contains(b, v) then
                        break ;
                    end
                    local to = findGoods(v);
                    if to and to.price * shopSellRate * shopSellValidBySora > from.price then
                        local sellPrice = GLOBAL.TUNING.ZY_STORE_SELL_LIST[to.name] or to.price or DEFAULT_SELL_PRICE;
                        GLOBAL.TUNING.ZY_STORE_SELL_LIST[to.name] = math.min(sellPrice, to.price * shopSellRate * shopSellValidBySora)
                    end
                    table.insert(b, v);
                end
            end
        end
    end

    local shopNameSpace = "store";
    local ShopSellKey = "sell";
    _G.MOD_RPC_HANDLERS[shopNameSpace][_G.MOD_RPC[shopNameSpace][ShopSellKey].id] = function(player)
        if not _G.TheWorld.ismastersim then
            return
        end
        if player.store_container ~= nil
                and player.store_container.components.container ~= nil
                and player.store_container.components.container:IsOpenedBy(player) then
            local ctn = player.store_container.components.container
            local getcoins = 0
            for i = 1, ctn:GetNumSlots() do
                local item = ctn:GetItemInSlot(i)
                if item ~= nil then
                    local stacksize = 1
                    if item.components.stackable then
                        stacksize = item.components.stackable:StackSize()
                    end
                    if item.prefab == "store_coin1" then
                        getcoins = getcoins + stacksize * 10000
                        ctn:RemoveItemBySlot(i)
                        item:Remove()
                    elseif item.prefab == "store_coin2" then
                        getcoins = getcoins + stacksize * 5000
                        ctn:RemoveItemBySlot(i)
                        item:Remove()
                    elseif item:IsValid()
                            and item.prefab ~= "chester_eyebone"
                            and item.prefab ~= "glommerflower"
                            and item.prefab ~= "hutch_fishbowl"
                            --千年狐铃铛没了崩服
                            and item.prefab ~= "mihobell"
                            --不要再点天体灵球了
                            and item.prefab ~= "moonrockseed"
                            and item.components.leader == nil
                            and not (item:HasTag("irreplaceable")
                            and item.prefab ~= "atrium_key"
                            or item:HasTag("bundle")) then
                        local info = findGoods(item.prefab)
                        if info then
                            local sellPrice = GLOBAL.TUNING.ZY_STORE_SELL_LIST[info.name] or info.price * shopSellRate;
                            getcoins = getcoins + stacksize * sellPrice
                        else
                            getcoins = getcoins + stacksize * DEFAULT_SELL_PRICE
                        end

                        ctn:RemoveItemBySlot(i)
                        item:Remove()
                    end
                end
            end
            if getcoins ~= 0 then
                if player.components.playercoin ~= nil then
                    player.components.playercoin:DoDelta(getcoins)
                end
            else
                player.components.talker:Say("请放入可出售的物品!")
            end
        end
    end
end

if shopCoolDown > 0 then
    local shopNameSpace = "store";
    local ShopBuyKey = "store_b";
    local oldFn = _G.MOD_RPC_HANDLERS[shopNameSpace][_G.MOD_RPC[shopNameSpace][ShopBuyKey].id]
    _G.MOD_RPC_HANDLERS[shopNameSpace][_G.MOD_RPC[shopNameSpace][ShopBuyKey].id] = function(player, k, goodstype, mode)
        local lastShopBuyTime = player.lastShopBuyTime or 0;
        if GLOBAL.GetTime() - lastShopBuyTime < shopCoolDown then
            player.components.talker:Say("购买冷却" .. shopCoolDown .. "秒")
            return ;
        end
        player.lastShopBuyTime = GLOBAL.GetTime();
        oldFn(player, k, goodstype, mode);
    end
end

if shopCanByHSH then
    local ach_cost = GLOBAL.TUNING.STORE_GOODS_ACH_COST * 2

    table.insert(GLOBAL.TUNING.STORE_GOODS["other"], 1, {
        name = "2点血上限",
        type = "health",
        price = ach_cost
    })
    table.insert(GLOBAL.TUNING.STORE_GOODS["other"], 1, {
        name = "2点san上限",
        type = "san",
        price = ach_cost
    })
    table.insert(GLOBAL.TUNING.STORE_GOODS["other"], 1, {
        name = "2点饥饿上限",
        type = "hungry",
        price = ach_cost
    })

    AddComponentPostInit("playercoin", function(com)
        com.healthAmount = 0;
        com.sanAmount = 0;
        com.hungryAmount = 0;
        function com:DoDeltaHealthAmount(value)
            local inst = com.inst;
            local _v = tonumber(value) or 0;
            com.healthAmount = com.healthAmount + _v
            local health_percent = inst.components.health:GetPercent()
            inst.components.health.maxhealth = math.max(inst.components.health.maxhealth + _v * 2, 10)
            inst.components.health:SetPercent(health_percent)
            com.healthmax = inst.components.health.maxhealth;
        end

        function com:DoDeltaSanAmount(value)
            local inst = com.inst;
            local _v = tonumber(value) or 0;
            com.sanAmount = com.sanAmount + _v
            local sanity_percent = inst.components.sanity:GetPercent()
            inst.components.sanity:SetMax(math.max(inst.components.sanity.max + _v * 2, 10))
            inst.components.sanity:SetPercent(sanity_percent)
            com.sanitymax = inst.components.sanity.max
        end

        function com:DoDeltaHungryAmount(value)
            local inst = com.inst;
            local _v = tonumber(value) or 0;
            com.hungryAmount = com.hungryAmount + _v
            local hunger_percent = inst.components.hunger:GetPercent()
            inst.components.hunger:SetMax(math.max(inst.components.hunger.max + _v * 2, 10))
            inst.components.hunger:SetPercent(hunger_percent)
            com.hungermax = inst.components.hunger.max
        end

        local oldOnSave = com.OnSave
        function com:OnSave(...)
            local data = oldOnSave(com, ...)
            data.healthAmount = com.healthAmount or 0;
            data.sanAmount = com.sanAmount or 0;
            data.hungryAmount = com.hungryAmount or 0;
            return data;
        end

        local oldOnLoad = com.OnLoad
        function com:OnLoad(data, ...)
            local result = oldOnLoad(com, data, ...)
            com.healthAmount = data.healthAmount or 0;
            com.sanAmount = data.sanAmount or 0;
            com.hungryAmount = data.hungryAmount or 0;
            return result;
        end
        function com:updateStatus()
            local inst = com.inst;
            if com.hungermax ~= inst.components.hunger.max then
                local hunger_percent = inst.components.hunger:GetPercent()
                inst.components.hunger:SetMax(inst.components.hunger.max + com.hungryAmount * 2)
                inst.components.hunger:SetPercent(hunger_percent)
                com.hungermax = inst.components.hunger.max
            end

            if com.sanitymax ~= inst.components.sanity.max then
                local sanity_percent = inst.components.sanity:GetPercent()
                inst.components.sanity:SetMax(inst.components.sanity.max + com.sanAmount * 2)
                inst.components.sanity:SetPercent(sanity_percent)
                com.sanitymax = inst.components.sanity.max
            end

            if com.healthmax ~= inst.components.health.maxhealth then
                local health_percent = inst.components.health:GetPercent()
                inst.components.health.maxhealth = inst.components.health.maxhealth + com.healthAmount * 2
                inst.components.health:SetPercent(health_percent)
                com.healthmax = inst.components.health.maxhealth
            end
        end

        com.inst:DoPeriodicTask(GLOBAL.FRAMES * 3, function()
            com:updateStatus()
        end)
    end)

    local shopNameSpace = "store";
    local ShopBuyKey = "store_b";
    local oldFn = _G.MOD_RPC_HANDLERS[shopNameSpace][_G.MOD_RPC[shopNameSpace][ShopBuyKey].id]
    _G.MOD_RPC_HANDLERS[shopNameSpace][_G.MOD_RPC[shopNameSpace][ShopBuyKey].id] = function(player, k, goodstype, mode)
        if k ~= nil and goodstype ~= nil then
            if TUNING.STORE_GOODS[goodstype] ~= nil and TUNING.STORE_GOODS[goodstype][k] ~= nil then
                local name = TUNING.STORE_GOODS[goodstype][k][1] ~= nil and TUNING.STORE_GOODS[goodstype][k][1] or TUNING.STORE_GOODS[goodstype][k].name
                local price = TUNING.STORE_GOODS[goodstype][k][2] ~= nil and TUNING.STORE_GOODS[goodstype][k][2] or TUNING.STORE_GOODS[goodstype][k].price
                local type = TUNING.STORE_GOODS[goodstype][k][3] ~= nil and TUNING.STORE_GOODS[goodstype][k][2] or TUNING.STORE_GOODS[goodstype][k].type
                if type == "health" or type == "san" or type == "hungry" then
                    local coin = player.components.playercoin:GetCoin();
                    local num = 1;
                    if mode then
                        num = math.min(math.ceil(coin / ach_cost), 10)
                    end
                    if num > 0 and coin >= num * ach_cost then
                        if type == "health" then
                            player.components.playercoin:DoDeltaHealthAmount(num)
                        end
                        if type == "san" then
                            player.components.playercoin:DoDeltaSanAmount(num)
                        end
                        if type == "hungry" then
                            player.components.playercoin:DoDeltaHungryAmount(num)
                        end
                        player.components.playercoin:Reduce(num * ach_cost)
                        return ;
                    end
                    return
                end
            end
        end
        oldFn(player, k, goodstype, mode);
    end
end







