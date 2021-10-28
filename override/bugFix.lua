local _G = GLOBAL;
--璇儿装备bug --xe_knife
if _G.isModEnableById("2582670245") then
    AddPrefabPostInit("xe_scabbard", function(inst)
        if inst
                and inst.components
                and inst.components.equippable
                and inst.components.equippable.onequipfn
                and inst.components.equippable.onunequipfn
        then
            local oldonequipfn = inst.components.equippable.onequipfn;
            local oldonunequipfn = inst.components.equippable.onunequipfn;
            inst.components.equippable:SetOnEquip(function(inst, owner)
                if owner and owner.prefab == "xuaner" then
                    oldonequipfn(inst, owner);
                else
                    owner:DoTaskInTime(0, function()
                        if owner.components.inventory then
                            owner.components.inventory:GiveItem(inst)
                        end
                        if owner.components.talker then
                            owner.components.talker:Say("这是璇儿的剑鞘！")
                        end
                    end)
                    --
                end
            end)

            inst.components.equippable:SetOnUnequip(function(inst, owner)
                if owner and owner.prefab == "xuaner" then
                    oldonunequipfn(inst, owner);
                end
            end)
        end
    end)
    local fuList = {
        "xe_fu_yazi",
        "xe_fu_zouwu",
        "xe_fu_mingyue",
        "xe_fu_yushi",
        "xe_fu_tieyu",
    }
    for k, v in pairs(fuList) do
        AddPrefabPostInit(v, function(fu)
            fu.components.finiteuses:SetOnFinished(function(inst)
                local player = inst.components.inventoryitem:GetGrandOwner()
                inst:Remove()
                if player then
                    player:DoTaskInTime(_G.FRAMES, function(player)
                        if player and not player:HasTag("playerghost") then
                            local scabbard = player.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
                            if scabbard
                                    and scabbard:IsValid()
                                    and scabbard.prefab == "xe_scabbard"
                                    and scabbard.components.container
                            then
                                --选取相同的符
                                local inventoryFu = player.components.inventory:FindItem(function(item)
                                    if item.prefab == inst.prefab then
                                        return true
                                    end
                                    return false
                                end)
                                --退而求其次
                                if not inventoryFu then
                                    inventoryFu = player.components.inventory:FindItem(function(item)
                                        if item:HasTag("xe_fu") then
                                            return true
                                        end
                                        return false
                                    end)
                                end
                                for i = 1, scabbard.components.container:GetNumSlots() do
                                    if scabbard.components.container:GetItemInSlot(i) == nil and inventoryFu then
                                        scabbard.components.container:GiveItem(inventoryFu.components.inventoryitem:RemoveFromOwner(scabbard.components.container.acceptsstacks), i, nil, false)
                                        inventoryFu = nil
                                        break ;
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end)
    end
end
--希尔
if _G.isModEnableById("1757943227") then
    if not _G.overtask then
        _G.overtask = function(inst)
            inst.components.seelebase.levelabsorb = nil
            inst.components.combat.externaldamagemultipliers:RemoveModifier(inst, "level_damage")
            inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst, "level_armor")
            inst._hurttask:Cancel()
            inst._hurttask = nil
            inst._overtask = nil
        end
    end
end
