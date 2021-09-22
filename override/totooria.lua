local cooking = require("cooking")
local totooriaMultipleStewer = GetModConfigData("totooriaMultipleStewer") or 0;
local totooriaMultipleStewerWithHeadchefCertificate = GetModConfigData("totooriaMultipleStewerWithHeadchefCertificate") or 0;
local totooriaMultipleStewerFur = GetModConfigData("totooriaMultipleStewerFur") or false;
local totooriaPhilosopherstoneEatLimit = GetModConfigData("totooriaPhilosopherstoneEatLimit") or 0;
local totooriaPhilosopherstoneKJKLimit = GetModConfigData("totooriaPhilosopherstoneKJKLimit") or false;
local totooriaPhilosopherstoneLimit = GetModConfigData("totooriaPhilosopherstoneLimit") or false

--	托托莉
--		多倍收锅
if totooriaMultipleStewer > 0 then
    local stewerFood = function(harvester, _self, num)
        local loot = GLOBAL.SpawnPrefab(_self.product)
        if loot ~= nil then
            local recipe = cooking.GetRecipe(_self.inst.prefab, _self.product)
            local stacksize = recipe and recipe.stacksize or 1

            if stacksize > 1 then
                loot.components.stackable:SetStackSize(stacksize)
            end
            if _self.spoiltime ~= nil and loot.components.perishable ~= nil then
                local spoilpercent = _self:GetTimeToSpoil() / _self.spoiltime
                loot.components.perishable:SetPercent(_self.product_spoilage * spoilpercent)
                loot.components.perishable:StartPerishing()
            end
            if harvester ~= nil and harvester.components.inventory ~= nil then
                harvester.components.inventory:GiveItem(loot, nil, _self.inst:GetPosition())
            else
                GLOBAL.LaunchAt(loot, _self.inst, nil, 1, 1)
            end
        end
    end
    for k, mod in pairs(GLOBAL.ModManager.mods) do
        -- 遍历已开启的mod
        if mod and mod.modinfo.author == "柴柴" and mod.modinfo.name:match("托托莉") then
            -- 托托莉
            if mod.postinitfns.ComponentPostInit.stewer and mod.postinitfns.ComponentPostInit.stewer[1] ~= nil then
                -- hook了stewer
                mod.postinitfns.ComponentPostInit.stewer[1] = function(self)
                    local oold_harvest = self.Harvest
                    function self:Harvest(harvester)
                        if harvester ~= nil and harvester.components.totooriastatus ~= nil and harvester:HasTag("teji_dachu") then
                            if self.done then
                                if self.product ~= nil then
                                    local count = 0;
                                    if harvester.components and harvester.components.health then
                                        count = count + harvester.components.health.maxhealth;
                                    end
                                    if harvester.components and harvester.components.sanity then
                                        count = count + harvester.components.sanity.max;
                                    end
                                    if harvester.components and harvester.components.hunger then
                                        count = count + harvester.components.hunger.max;
                                    end
                                    if totooriaMultipleStewerWithHeadchefCertificate > 0 then
                                        local headchef_certificate = harvester.components.inventory
                                                and harvester.components.inventory.EquipMedalWithName
                                                and harvester.components.inventory:EquipMedalWithName("headchef_certificate")
                                        if headchef_certificate then
                                            count = count * (totooriaMultipleStewerWithHeadchefCertificate + 1);
                                        end
                                    end
                                    count = math.floor(count / totooriaMultipleStewer);
                                    count = math.max(count,2);
                                    for i = 1, count - 1 do
                                        stewerFood(harvester, self)
                                    end
                                end
                            end
                        end
                        return oold_harvest(self, harvester)
                    end
                end
            end
        end
    end
end ;

if totooriaMultipleStewerFur and totooriaMultipleStewer > 0 then
    --多倍炼丹
    local canStewerFur = {
        "condensed_pill", --凝味丹
        "armor_pill", --壮骨
        "fly_pill", --腾云
        "bloodthirsty_pill", --嗜血
    }

    local stewerFurFood = function(picker, _self)
        local loot = GLOBAL.SpawnPrefab(_self.product)
        if loot ~= nil then
            if picker ~= nil and picker.components.inventory ~= nil then
                picker.components.inventory:GiveItem(loot, nil, _self.inst:GetPosition())
            else
                GLOBAL.LaunchAt(loot, _self.inst, nil, 1, 1)
            end
        end
    end

    --多倍炼丹--神话书说
    AddComponentPostInit("stewer_fur",
            function(hav, inst)
                local oldHarvest = hav.Harvest
                hav.Harvest = function(self, picker, ...)
                    if picker ~= nil and self.done and picker.components.totooriastatus and picker:HasTag("teji_dachu") then
                        if self.product ~= nil and table.contains(canStewerFur, self.product) then
                            local count = 0;
                            if picker.components and picker.components.health then
                                count = count + picker.components.health.maxhealth;
                            end
                            if picker.components and picker.components.sanity then
                                count = count + picker.components.sanity.max;
                            end
                            if picker.components and picker.components.hunger then
                                count = count + picker.components.hunger.max;
                            end
                            if totooriaMultipleStewerWithHeadchefCertificate > 0 then
                                local headchef_certificate = picker.components.inventory
                                        and picker.components.inventory.EquipMedalWithName
                                        and picker.components.inventory:EquipMedalWithName("headchef_certificate")
                                if headchef_certificate then
                                    count = count * (totooriaMultipleStewerWithHeadchefCertificate + 1);
                                end
                            end
                            count = math.floor(count / totooriaMultipleStewer / 3)
                            count = math.max(count,2);
                            for i = 1, count do
                                stewerFurFood(picker, self)
                            end
                        end
                    end
                    return oldHarvest(self, picker, ...)
                end
            end
    )
end

if totooriaPhilosopherstoneEatLimit == true then
    totooriaPhilosopherstoneEatLimit = 1;
end

if totooriaPhilosopherstoneEatLimit>0 then
    AddPrefabPostInit("philosopherstone", function(inst)
        if inst ~= nil and
                inst.components ~= nil and
                inst.components.equippable ~= nil and
                inst.components.equippable.onequipfn ~= nil then
            local oldonequipfn = inst.components.equippable.onequipfn;
            local DeltaUse = up.Get(oldonequipfn, "DeltaUse")
            local checkspeak = up.Get(oldonequipfn, "checkspeak")
            inst.components.equippable.onequipfn = function(inst, owner)
                oldonequipfn(inst, owner)
                if not owner or not owner.components.eater then
                    return
                end
                owner.components.eater.oneatfn = function(owner, food)
                    if not food or not food.components.edible or food.prefab == "mandrake" then
                        return owner.components.eater.oldttreatfn(owner, food)
                    end

                    local value = 0
                    local table = {
                        ["plantmeat"] = 20,
                        ["plantmeat_cooked"] = 20,
                        ["royal_jelly"] = 20,
                        ["cookedmandrake"] = 20,
                        ["mandrakesoup"] = 20,
                        ["tallbirdegg"] = 20,
                        ["tallbirdegg_cooked"] = 20,
                        ["tallbirdegg_cracked"] = 20,
                        ["wormlight"] = 20,

                        ["butter"] = 60,
                        ["jellybean"] = 10,
                        ["deerclops_eyeball"] = 100,
                        ["minotaurhorn"] = 200,
                    }
                    for k, v in pairs(table) do
                        if food.prefab == k then
                            value = v
                        end
                    end
                    if food and food.components.edible and value == 0 then
                        local hunger = math.abs(food.components.edible:GetHunger())
                        local sanity = math.abs(food.components.edible:GetSanity())
                        local health = math.abs(food.components.edible:GetHealth())
                        value = math.ceil((hunger + sanity + health) * .04)
                    end

                    local multiplier= 1;
                    if owner.components.totooriastatus then
                        multiplier = 2
                    end

                    DeltaUse(inst, math.min( 20 * totooriaPhilosopherstoneEatLimit, value) * multiplier, owner)
                    checkspeak(inst, owner)
                    if owner.components.eater.oldttreatfn then
                        return owner.components.eater.oldttreatfn(owner, food)
                    end
                end
            end
        end
    end)
end

if totooriaPhilosopherstoneLimit then
    AddPrefabPostInit("philosopherstone", function(inst)
        if inst ~= nil and inst.components.finiteuses ~= nil then
            inst.components.finiteuses.SetPercent = function()

            end
        end
    end)
end

if totooriaPhilosopherstoneKJKLimit then
    AddPrefabPostInit("philosopherstone", function(inst)
        if inst.components.lrhc_wxnj then
            inst:RemoveComponent('lrhc_wxnj')
        end
    end)
end

--武器攻击范围随装备角色的脑残上限变化
local function rangechange(inst)
    if inst.components.inventoryitem.owner ~= nil then
        if inst.components.inventoryitem.owner.components.sanity then
            local ownersanity = inst.components.inventoryitem.owner.components.sanity.max
            local rangemodifer = math.min(((ownersanity / 200) ^ 4 + 1) / 1.5, 20)
            inst.components.weapon:SetRange(rangemodifer, rangemodifer + 2)
        end
    end
end

local setRange = function(inst)
    if inst ~= nil and
            inst.components ~= nil and
            inst.components.equippable ~= nil and
            inst.components.equippable.onequipfn ~= nil then
        local oldonequipfn = inst.components.equippable.onequipfn;
        inst.components.equippable.onequipfn = function(inst, owner)
            oldonequipfn(inst, owner)
            rangechange(inst)
        end
    end
end

AddPrefabPostInit("totooriastaff5green", setRange)
AddPrefabPostInit("totooriastaff5orange", setRange)
AddPrefabPostInit("totooriastaff5yellow", setRange)
AddPrefabPostInit("totooriastaff3", setRange)
AddPrefabPostInit("totooriastaff4", setRange)