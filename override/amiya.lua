local amyMachiningCenterAutoStack = GetModConfigData("amyMachiningCenterAutoStack") or false
local amyHeChengDisappear = GetModConfigData("amyHeChengDisappear") or 0
local amyWeaponDamageGrowthRate = GetModConfigData("amyWeaponDamageGrowthRate") or 0
local amyWeaponMaxLevel = GetModConfigData("amyWeaponMaxLevel") or -1
--amy_hecheng
if amyMachiningCenterAutoStack then
    local function Put(item, target)
        if target
                and target ~= item
                and target.prefab == item.prefab
                and item.components.stackable
                and not item.components.stackable:IsFull()
                and target.components.stackable
                and not target.components.stackable:IsFull()
        then
            item.components.stackable:Put(target)
        end
    end
    AddPrefabPostInit("amy_machining_center", function(inst)
        inst:WatchWorldState("cycles", function(center)
            local pt = center:GetPosition()
            local x, y, z = pt:Get()
            local ents = GLOBAL.TheSim:FindEntities(x, y, z, 8, { "_inventoryitem" }, { "INLIMBO", "NOCLICK", "catchable", "fire", "bee", "butterfly" })
            for _, objBase in pairs(ents) do
                if objBase:IsValid() and objBase.components.stackable and not objBase.components.stackable:IsFull() then
                    for _, obj in pairs(ents) do
                        if obj:IsValid() then
                            Put(objBase, obj)
                        end
                    end
                end
            end
        end)

    end)
end

if amyHeChengDisappear > 0 then
    -- 参照Yeo的代码 https://github.com/zYeoman/DST_mod/blob/master/postinit/c_lootdropper.lua
    local CancelDisappear = function(inst)
        if inst._disappear then
            inst._disappear:Cancel()
        end
        if inst._disappear_anim then
            inst._disappear_anim:Cancel()
        end
        inst._disappear = nil;
        inst._disappear_anim = nil;
        inst.AnimState:SetMultColour(1, 1, 1, 1)
    end
    local disappear = function(loot)
        loot:ListenForEvent("onpickup", function()
            CancelDisappear(loot)
        end)
        loot:ListenForEvent("onputininventory", function()
            CancelDisappear(loot)
        end)
        loot._disappear = loot:DoTaskInTime(amyHeChengDisappear, function()
            if loot:IsValid() and loot.components.inventoryitem and not loot.components.inventoryitem:GetContainer() then
                loot:Remove()
            end
        end)
        loot._disappear_anim = loot:DoTaskInTime(amyHeChengDisappear - 40, function()
            for j = 1, 30, 2 do
                for i = 10, 3, -1 do
                    loot:DoTaskInTime(j - i / 10, function()
                        loot.AnimState:SetMultColour(i / 10, i / 10, i / 10, i / 10)
                    end)
                    loot:DoTaskInTime(j + i / 10, function()
                        loot.AnimState:SetMultColour(i / 10, i / 10, i / 10, i / 10)
                    end)
                end
            end
            for i = 10, 3, -1 do
                loot:DoTaskInTime(31 - i / 10, function()
                    loot.AnimState:SetMultColour(i / 10, i / 10, i / 10, i / 10)
                end)
            end
        end)
    end
    AddPrefabPostInit("amy_hecheng", function(inst)
        disappear(inst);
    end)
end

if amyWeaponDamageGrowthRate > 0 then
    local weapons = {
        "amy_yizhiqi1",
        "amy_yizhiqi2",
        "amy_yizhiqi3",
    }
    for k, v in pairs(weapons) do
        AddPrefabPostInit(v, function(weapon)
            if not weapon.components.zy_weapon_attack then
                weapon:AddComponent("zy_weapon_attack")
                weapon.components.zy_weapon_attack:SetDamageRatePerLevel(amyWeaponDamageGrowthRate/100);
                if amyWeaponMaxLevel > 0 then
                    weapon.components.zy_weapon_attack:SetMaxLevel(amyWeaponMaxLevel);
                end
                weapon.components.zy_weapon_attack:update();
            end
        end)
    end
    AddPrefabPostInit("amiya", function(inst)
        inst:ListenForEvent("onattackother",function(inst,data)
            if data.weapon and table.contains(weapons,data.weapon.prefab) and data.weapon.components.zy_weapon_attack then
                data.weapon.components.zy_weapon_attack:DoDeltaExp(1)
            end
        end)
    end)
    --onattackother
end