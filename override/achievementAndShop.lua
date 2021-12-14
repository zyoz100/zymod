local canNotSellItemsBySora = GetModConfigData("canNotSellItemsBySora") or false;
local soraSellNotHalf = GetModConfigData("soraSellNotHalf") or false;
local soraSellPriceByLevel = GetModConfigData("soraSellPriceByLevel") or false;
local achievementGetMorePoints = GetModConfigData("achievementGetMorePoints") or 0;
local achievementMaxBuy = GetModConfigData("achievementMaxBuy") or 0;
local achievementMaxBuyMode = GetModConfigData("achievementMaxBuyMode") or 0
local achievementMaxBuyRate = GetModConfigData("achievementMaxBuyRate")
local achievementShowInfo = GetModConfigData("achievementShowInfo") or false
local achievementBuyCD = GetModConfigData("achievementBuyCD") or false
if type(achievementMaxBuyRate) ~= "number" then
    achievementMaxBuyRate = 0.01
end
if achievementMaxBuyRate < 0 then
    achievementMaxBuyRate = 0.01
end

if (canNotSellItemsBySora or canNotSellItemsBySora or soraSellPriceByLevel) and GLOBAL.isModEnableById("1638724235") then
    AddPrefabPostInit("goldstaff", function(inst)
        if inst and inst.components.spellcaster and inst.components.spellcaster.spell then
            local function goldstafffn(staff, target, pos)
                local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 2.7)
                local caster = staff.components.inventoryitem.owner
                local talkprice = 0
                local pass = 1
                local noprice = true

                for k, v in pairs(ents) do
                    local soraValid = true;
                    if canNotSellItemsBySora then
                        soraValid = v.prefab ~= "mandrake" and v.prefab ~= "butter"
                    end
                    if v.components.inventoryitem
                            and v.components.inventoryitem.owner == nil
                            and v.prefab ~= "secoin"
                            and v.prefab ~= "chester_eyebone"
                            and v.prefab ~= "glommerflower"
                            and v.prefab ~= "hutch_fishbowl"
                            --千年狐铃铛没了崩服
                            and v.prefab ~= "mihobell"
                            --不要再点天体灵球了
                            and v.prefab ~= "moonrockseed"
                            --因为穹的空白 有些东西不能卖
                            and soraValid
                            and v.prefab ~= "sorapacker"
                            and staff.components.finiteuses.current >= 1 then
                        local price = 0
                        local stacksize = 1
                        if v.components.stackable then
                            stacksize = v.components.stackable.stacksize
                        end
                        for i, j in pairs(GLOBAL.TUNING.allgoods) do
                            if v.prefab == j.name then
                                price = j.price / GLOBAL.TUNING.goldstaffordinary * stacksize
                            end
                        end
                        for i, j in pairs(GLOBAL.TUNING.selist_low) do
                            if v.prefab == j.name then
                                price = j.price / GLOBAL.TUNING.goldstaffprecious * stacksize
                            end
                        end

                        if v.prefab == "thousandcoin" then
                            price = 1000 * stacksize
                        end

                        if price == 0 then
                            price = math.random(1, 5)
                        else
                            noprice = false
                        end

                        if v.components.finiteuses and v.prefab ~= "vipcard" then
                            local percent = v.components.finiteuses:GetPercent()
                            price = price * percent
                        end
                        if v.components.fueled and v.prefab ~= "vipcard" then
                            local percent = v.components.fueled:GetPercent()
                            price = price * percent
                        end
                        if v.components.armor and v.components.armor.maxcondition > 0 and v.prefab ~= "vipcard" then
                            local percent = v.components.armor:GetPercent()
                            price = price * percent
                        end

                        local soraExclude = false;
                        if soraSellNotHalf then
                            soraExclude = caster:HasTag("sora") and caster.soralevel and caster.soralevel:value() > 24;
                        end

                        if caster.components.builder and GLOBAL.AllRecipes[v.prefab] and not soraExclude then
                            price = price * caster.components.builder.ingredientmod
                        end

                        if soraSellPriceByLevel and caster:HasTag("sora") and caster.soralevel then
                            local percent = 0.4 + caster.soralevel:value() / 50;
                            price = price * percent
                        end

                        price = math.ceil(price)

                        talkprice = talkprice + price

                        local pt = GLOBAL.Point(v.Transform:GetWorldPosition())
                        local secoin = GLOBAL.SpawnPrefab("secoin")
                        secoin.components.secoin.amount = price
                        local angle = math.random() * 2 * GLOBAL.PI
                        secoin.Transform:SetPosition(pt.x, pt.y, pt.z)
                        secoin.Physics:SetVel(2 * math.cos(angle), 10, 2 * math.sin(angle))
                        secoin:DoTaskInTime(pass * GLOBAL.FRAMES * 3 + .3, function()
                            caster.components.seplayerstatus:givesecoin(secoin)
                        end)
                        pass = pass + 1

                        staff.components.inventoryitem.owner.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")
                        if v.components.inventory then
                            v.components.inventory:DropEverything()
                        end
                        if v.components.container then
                            v.components.container:DropEverything()
                        end
                        staff.components.finiteuses:Use(1)
                        v:Remove()
                    else
                        --staff.components.inventoryitem.owner.components.talker:Say("那东西不能转化成金币")
                    end
                end
                if talkprice > 0 then
                    GLOBAL.SpawnPrefab("explode_small_slurtle").Transform:SetPosition(pos:Get())
                    caster:DoTaskInTime(pass * GLOBAL.FRAMES * 3 + .4, function()
                        caster.components.talker:Say(GLOBAL.STRINGS.SIMPLEECONOMY[10] .. talkprice .. GLOBAL.STRINGS.SIMPLEECONOMY[19])
                        if noprice == true then
                            caster:DoTaskInTime(1, function()
                                caster.components.talker:Say(GLOBAL.STRINGS.SIMPLEECONOMY[11])
                            end)
                        end
                    end)
                else
                    caster.components.talker:Say(GLOBAL.STRINGS.SIMPLEECONOMY[12])
                end
            end
            inst.components.spellcaster:SetSpellFn(goldstafffn)
        end
    end)
end

if achievementGetMorePoints > 0 then
    local all_achievement_cold_get = {
        --ACHIEVEMENTS
        --Food
        ["firsteat"] = 100,
        ["supereat"] = 1000,
        ["danding"] = 300,
        ["alldiet"] = 5000,
        ["eathot"] = 1000,
        ["eatcold"] = 1000,
        ["eatfish"] = 300,
        ["eatturkey"] = 300,
        ["eatpepper"] = 300,
        ["eatbacon"] = 300,
        ["eatmole"] = 300,
        --Life
        ["noob"] = 100,
        ["tooyoung"] = 1000,
        ["killme"] = 400,
        ["rot"] = 600,
        ["deathalot"] = 1300,
        ["secondchance"] = 1200,
        ["messiah"] = 3000,
        ["sleeptent"] = 1500,
        ["sleepsiesta"] = 1500,
        ["reviveamulet"] = 600,
        ["feedplayer"] = 5000,
        --Work
        ["nature"] = 50000,
        ["fishmaster"] = 30000,
        ["pickappren"] = 30000,
        ["pickmaster"] = 60000,
        ["chopappren"] = 35000,
        ["chopmaster"] = 70000,
        ["mineappren"] = 20000,
        ["minemaster"] = 40000,
        ["cookappren"] = 10000,
        ["cookmaster"] = 20000,
        ["buildappren"] = 50000,
        ["buildmaster"] = 100000,
        --Have
        ["emerald"] = 3000,
        ["citrin"] = 3000,
        ["amber"] = 3000,
        ["saddle"] = 200,
        ["banana"] = 1000,
        ["spore"] = 200,
        ["blueprint"] = 1000,
        ["boat"] = 2000,
        ["moonrock"] = 200,
        ["gnome"] = 4000000,
        ["mosquito"] = 2000,
        ["bathbomb"] = 200,
        --Like
        ["goodman"] = 500,
        ["brother"] = 600,
        ["catperson"] = 1000,
        ["rocklob"] = 1000,
        ["spooder"] = 2000,
        ["evil"] = 2000,
        ["birdclop"] = 10000,
        ["pet"] = 100,
        ["shadowchester"] = 5000,
        ["snowchester"] = 5000,
        ["musichutch"] = 5000,
        ["lavae"] = 50000,
        --Pain
        ["burn"] = 300,
        ["freeze"] = 400,
        ["sleep"] = 2000,
        ["starve"] = 40000,
        ["nosanity"] = 10000,
        ["icebody"] = 20000,
        ["firebody"] = 20000,
        ["moistbody"] = 25000,
        ["evilflower"] = 1000,
        ["roses"] = 1000,
        ["drown"] = 1000,
        --Fight
        ["angry"] = 10000,
        ["tank"] = 10000,
        ["dmgnodmg"] = 30000,
        ["bullkelp"] = 30000,
        ["butcher"] = 3000,
        ["horrorhound"] = 30000,
        ["slurtle"] = 3000,
        ["werepig"] = 2000,
        ["fruitdragon"] = 1000,
        ["sick"] = 300,
        ["coldblood"] = 300,
        ["hutch"] = 3000,
        --Hunt
        ["goatperd"] = 3000,
        ["mossling"] = 4000,
        ["weetusk"] = 25000,
        ["snake"] = 3000,
        ["black"] = 10000,
        ["hentai"] = 2000,
        ["treeguard"] = 2000,
        ["spiderqueen"] = 2000,
        ["varg"] = 20000,
        ["koaelefant"] = 1000,
        ["monkey"] = 1000,
        --Boss
        ["santa"] = 20000,
        ["dragonfly"] = 400000,
        ["malbatross"] = 20000,
        ["crabking"] = 25000,
        ["knight"] = 180000,
        ["bishop"] = 180000,
        ["rook"] = 180000,
        ["minotaur"] = 230000,
        ["ancient"] = 240000,
        ["rigid"] = 400000,
        ["queen"] = 290000,
        ["king"] = 500000,
        --Misc
        ["intogame"] = 0,
        ["superstar"] = 200,
        ["trader"] = 200,
        ["fuzzy"] = 4000,
        ["knowledge"] = 4000,
        ["dance"] = 4000,
        ["teleport"] = 4000,
        ["luck"] = 20000,
        ["lightning"] = 600,
        ["birchnut"] = 200000,
        --Mile
        ["all"] = 6000 * 10000,
        ["longage"] = 100000,
        ["oldage"] = 1000000,
        ["walkalot"] = 100000,
        ["stopalot"] = 50000,
        ["caveage"] = 50000,
        ["rider"] = 400000,
        ["fullsanity"] = 100000,
        ["fullhunger"] = 100000,
        ["pacifist"] = 100000,
    }
    AddComponentPostInit("allachivevent", function(self)
        function self:seffc(inst, tag)
            GLOBAL.SpawnPrefab("seffc").entity:SetParent(inst.entity)
            local str0 = GLOBAL.STRINGS.ALLACHIVCURRENCY
            local strname = GLOBAL.STRINGS.ALLACHIVNAME
            local strinfo = GLOBAL.STRINGS.ALLACHIVINFO
            local strcoin = GLOBAL.STRINGS.ALLACHIVCOIN
            local announceStr = "";
            local talkerStr = str0[6] .. strname[tag] .. str0[2] .. "\n" .. str0[4] .. GLOBAL.allachiv_coinget[tag] .. str0[5]
            if tag == "intogame" and self.all == true then
                announceStr = inst:GetDisplayName() .. "   " .. strinfo["intogameafterall"] .. str0[3] .. str0[1] .. strname[tag] .. str0[2];
            else
                announceStr = inst:GetDisplayName() .. "   " .. strinfo[tag] .. str0[3] .. str0[1] .. strname[tag] .. str0[2];
            end
            local gold = all_achievement_cold_get[tag] or 0;
            local extraCoin = 0;
            if gold > 0 then
                extraCoin = math.ceil(gold / 20000 * achievementGetMorePoints)
                announceStr = announceStr .. "额外成就点：" .. extraCoin
                talkerStr = talkerStr .. "\n额外成就点：" .. extraCoin
            end
            GLOBAL.TheNet:Announce(announceStr);
            inst.components.talker:Say(talkerStr)
            inst.components.allachivcoin:coinDoDelta(GLOBAL.allachiv_coinget[tag] + extraCoin)
        end
    end
    )
end

if achievementMaxBuy > 0 or achievementBuyCD > 0 then
    local namespace = "SimpleEconomy";
    local buyHandle = GLOBAL.MOD_RPC_HANDLERS[namespace][GLOBAL.MOD_RPC[namespace]["buy_fix"].id];
    AddComponentPostInit("seplayerstatus", function(self)
        local oldOnSave = self.OnSave;
        local oldOnLoad = self.OnLoad;
        function self:OnSave()
            local res = oldOnSave(self);
            res.totalBuyCoin = self.totalBuyCoin or 0;
            res.dayOfBuy = self.dayOfBuy or 0;
            res.dayBuyCoin = self.dayBuyCoin or 0;
            return res;
        end
        function self:OnLoad(data)
            oldOnLoad(self, data);
            self.totalBuyCoin = data.totalBuyCoin or 0;
            self.dayOfBuy = data.dayOfBuy or 0;
            self.dayBuyCoin = data.dayBuyCoin or 0;
        end
    end)
    GLOBAL.MOD_RPC_HANDLERS[namespace][GLOBAL.MOD_RPC[namespace]["buy_fix"].id] = function(player, i, title, more)
        if achievementBuyCD > 0 then
            local lastBuyTime = player.components.seplayerstatus.lastBuyTime or 0;
            if GLOBAL.GetTime() - lastBuyTime < achievementBuyCD then
                player.components.talker:Say("购买冷却" .. achievementBuyCD .. "秒")
                return ;
            end
        end
        if achievementMaxBuy > 0 then
            local list = {};
            local ii = 1;
            if title == "food" then
                list = GLOBAL.TUNING.selist_food
                ii = i
            end
            if title == "cloth" then
                list = GLOBAL.TUNING.selist_cloth
                ii = i
            end
            if title == "smithing" then
                list = GLOBAL.TUNING.selist_smithing
                ii = i
            end
            if title == "resource" then
                list = GLOBAL.TUNING.selist_resource
                ii = i
            end
            --if title == "precious" then list = TUNING.selist_precious end
            if title == "precious" then
                local secp = player.components.seplayerstatus.precious
                list = GLOBAL.selist_precious
                ii = secp[i]
            end
            if title == "special" then
                list = GLOBAL.TUNING.selist_special
                ii = i
            end

            local iiname = list[ii].name
            local iprice = list[ii].price
            local amount = 1
            if more then
                amount = 10
            end
            local discount = player.components.seplayerstatus.discount;
            local cycles = GLOBAL.TheWorld.state.cycles or 1;
            local age = (player.components.age:GetAgeInDays() or 0) + 1;
            local cost = iprice * discount * amount;
            if iiname == "achievementsecoin" then
                cost = cost / 10;
                if player.components.totooriastatus ~= nil then
                    cost = 0;
                end
            end
            local continue = true;
            if player.components.seplayerstatus.coin >= math.ceil(iprice * discount * amount) and cost > 0 then
                if achievementMaxBuyMode == 0 then
                    local maxBuy = math.ceil((1 + cycles * achievementMaxBuyRate) * achievementMaxBuy * 1000);
                    local dayOfBuy = (player.components.seplayerstatus.dayOfBuy or 0)
                    if dayOfBuy ~= GLOBAL.TheWorld.state.cycles then
                        player.components.seplayerstatus.dayBuyCoin = 0;
                        player.components.seplayerstatus.dayOfBuy = GLOBAL.TheWorld.state.cycles
                    end
                    local dayBuyCoin = (player.components.seplayerstatus.dayBuyCoin or 0)
                    if dayOfBuy == GLOBAL.TheWorld.state.cycles and dayBuyCoin > maxBuy then
                        player.components.talker:Say("您今天已经消费到上限（" .. dayBuyCoin .. "/" .. maxBuy .. "）")
                        continue = false;
                    else
                        player.components.seplayerstatus.dayBuyCoin = dayBuyCoin + cost;
                        if achievementBuyCD > 0 then
                            player.components.seplayerstatus.lastBuyTime = GLOBAL.GetTime();
                        end
                    end
                elseif achievementMaxBuyMode == 1 then
                    local maxBuy = math.ceil((age + age * age * achievementMaxBuyRate / 2) * achievementMaxBuy * 1000); --偷懒算法
                    local totalBuyCoin = (player.components.seplayerstatus.totalBuyCoin or 0)
                    if totalBuyCoin > maxBuy then
                        player.components.talker:Say("您已经消费到上限（" .. totalBuyCoin .. "/" .. maxBuy .. "）")
                        continue = false;
                    else
                        player.components.seplayerstatus.totalBuyCoin = totalBuyCoin + cost;
                        if achievementBuyCD > 0 then
                            player.components.seplayerstatus.lastBuyTime = GLOBAL.GetTime();
                        end
                    end
                end
            end
            if continue then
                buyHandle(player, i, title, more);
            end
        else
            if achievementBuyCD > 0 then
                player.components.seplayerstatus.lastBuyTime = GLOBAL.GetTime();
            end
            buyHandle(player, i, title, more);
        end

    end
end

if achievementShowInfo then
    local OldNetworking_Say = GLOBAL.Networking_Say
    local talkerMsg = function(player)
        if player and player.components and player.components.talker then
            local msg = "";
            local cycles = GLOBAL.TheWorld.state.cycles or 1;
            if achievementMaxBuy and player.components.seplayerstatus then
                if achievementMaxBuyMode == 0 then
                    msg = msg .. string.format("当日消费信息：%d/%d", player.components.seplayerstatus.dayBuyCoin or 0, math.ceil((1 + cycles * achievementMaxBuyRate) * achievementMaxBuy * 1000))
                else
                    local age = (player.components.age:GetAgeInDays() or 0) + 1;
                    msg = msg .. string.format("消费信息：%d/%d", player.components.seplayerstatus.totalBuyCoin or 0, math.ceil((age + age * age * achievementMaxBuyRate / 2) * achievementMaxBuy * 1000))
                end
            end

            if msg == "" then
                msg = "没啥可以显示的！"
            end
            player.components.talker:Say(msg, 5)
        end
    end
    GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote)
        local r = OldNetworking_Say(guid, userid, name, prefab, message, colour, whisper, isemote);
        if string.sub(message, 1, 1) == "#" then
            local player = GLOBAL.Ents[guid]
            local code = string.sub(message, 2)
            if code == "info" then
                talkerMsg(player);
            end
        end
        return r;
    end
    local function onuse (inst)
        if inst.components.inventoryitem and inst.components.inventoryitem.owner then
            talkerMsg(inst.components.inventoryitem.owner);
        end
        return false
    end
    AddPrefabPostInit("vipcard", function(inst)
        inst:AddComponent("useableitem")
        inst.components.useableitem:SetOnUseFn(onuse)
    end)
end

