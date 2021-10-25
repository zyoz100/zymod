local _G = GLOBAL;
local flyknifeGiveNum = GetModConfigData("flyknifeGiveNum") or 0;
local yuanziMaxLevel = GetModConfigData("yuanziMaxLevel") or 0;
local yuanziMoreUse = GetModConfigData("yuanziMoreUse") or 0;
local yuanziRepairMore = GetModConfigData("yuanziRepairMore") or 0;
local yuanziOverlordMoreDamage = GetModConfigData("yuanziOverlordMoreDamage") or 0;
local yuanziPickMore = GetModConfigData("yuanziPickMore") or 0;

if flyknifeGiveNum > 0 then
    if _G.AllRecipes["yuanzi_flyknife"] then
        _G.AllRecipes["yuanzi_flyknife"].numtogive = flyknifeGiveNum
    end
end

if yuanziMaxLevel > 0 then
    AddPrefabPostInit("yuanzi", function(player)
        player.max_level = yuanziMaxLevel
    end)
end

if yuanziMoreUse > 0 then
    local weapons = {
        "yuanzi_spear_lv1",
        "yuanzi_spear_lv2",
    }
    for k, v in pairs(weapons) do
        AddPrefabPostInit(v, function(weapon)
            if weapon.components.finiteuses then
                local total = weapon.components.finiteuses.total;
                weapon.components.finiteuses:SetMaxUses(total * yuanziMoreUse)
                weapon.components.finiteuses:SetPercent(1)
            end
        end)
    end

    local armors = {
        "yuanzi_armor_lv1",
        "yuanzi_armor_lv2",
    }
    for k, v in pairs(armors) do
        AddPrefabPostInit(v, function(armor)
            if armor.components.armor then
                local maxcondition = armor.components.armor.maxcondition;
                local condition = armor.components.armor.condition;
                armor.components.armor.maxcondition = maxcondition * yuanziMoreUse;
                armor.components.armor.condition = condition * yuanziMoreUse;
            end
        end)
    end

end

if yuanziRepairMore > 0 then
    local weapons = {
        "yuanzi_spear_lv1",
        "yuanzi_spear_lv2",
    }
    for k, v in pairs(weapons) do
        AddPrefabPostInit(v, function(weapon)
            if weapon.components.trader then
                weapon.components.trader.onaccept = function(inst)
                    if inst.components.finiteuses ~= nil then
                        local total = weapon.components.finiteuses.total;
                        inst.components.finiteuses:Use(-yuanziRepairMore * total)
                    end
                end
            end
        end)
    end

    local armors = {
        "yuanzi_armor_lv1",
        "yuanzi_armor_lv2",
    }
    for k, v in pairs(armors) do
        AddPrefabPostInit(v, function(armor)
            if armor.components.armor then
                if weapon.components.trader then
                    weapon.components.trader.onaccept = function(inst)
                        if inst.components.armor ~= nil then
                            local condition = inst.components.armor.condition
                            local maxcondition = inst.components.armor.maxcondition
                            inst.components.armor:SetCondition(condition + maxcondition * yuanziRepairMore)
                        end
                    end
                end
            end
        end)
    end
end

if yuanziOverlordMoreDamage > 0 then
    AddPrefabPostInit("yuanzi", function(player)
        player:ListenForEvent("onattackother", function(inst, data)
            local target = data.target
            if inst:HasTag("yuanzi_overlord")
                    and target
                    and target:IsValid()
                    and target.components.health
                    and inst.components.sanity
                    and not target.components.health:IsDead() then
                local damage = inst.components.sanity.current * yuanziOverlordMoreDamage;
                local mul = inst.components.combat.externaldamagemultipliers:Get();
                if mul > 1 then
                    damage = ((mul - 1) * 0.1 + 1) * damage
                end
                target.components.combat:GetAttacked(inst, damage, nil, "yuanzi_ignoredebuff")
            end
        end)
    end)
end

if yuanziPickMore > 0 then
    local notpick = {statueglommer = 1, neverfadebush = 1,plant_certificate=1}
    local function onpick(inst, data)
        if data.object
                and data.object.components.pickable
                and not data.object.components.trader
                and inst.components.pigeonenergy
        then
            local num = math.floor(inst.components.pigeonenergy.level * yuanziPickMore)
            if num >= 1 then
                -- by sora of FL(风铃)
                if data.object.plant_def
                        and data.object.components.plantresearchable
                        and data.object.components.pickable.use_lootdropper_for_product then
                    local loot = {}
                    for _, prefab in ipairs(data.object.components.lootdropper:GenerateLoot()) do
                        local item = data.object.components.lootdropper:SpawnLootPrefab(prefab);
                        if item.components.stackable then
                            local stacksize = item.components.stackable.stacksize or 1;
                            loot.components.stackable:SetStackSize(stacksize * num)
                        end
                        table.insert(loot, item)
                    end
                    for i, item in ipairs(loot) do
                        if item.components.inventoryitem ~= nil then
                            inst.components.inventory:GiveItem(item, nil, inst:GetPosition())
                        end
                    end
                elseif data.object.components.pickable.product ~= nil and
                        not notpick[data.object.prefab] then
                    local item = SpawnPrefab(data.object.components.pickable.product)
                    if item.components.stackable then
                        item.components.stackable:SetStackSize(
                                data.object.components.pickable.numtoharvest * num)
                    end
                    inst.components.inventory:GiveItem(item, nil,
                            data.object:GetPosition())
                    if (data.object.prefab == "cactus" or data.object.prefab ==
                            "oasis_cactus") and data.object.has_flower then
                        local item2 = SpawnPrefab("cactus_flower")
                        if item2.components.stackable then
                            item2.components.stackable:SetStackSize(num)
                        end
                        inst.components.inventory:GiveItem(item2, nil,
                                data.object:GetPosition())
                    end
                end
            end
        end
    end

    AddPrefabPostInit("yuanzi", function(player)
        inst:ListenForEvent("picksomething", onpick)
    end)
end