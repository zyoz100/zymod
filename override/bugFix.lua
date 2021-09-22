local _G = GLOBAL;
--璇儿装备bug --xe_knife
if _G.isModEnableById("2582670245") then
    AddPrefabPostInit("xe_scabbard",function(inst)
        if inst
                and inst.components
                and inst.components.equippable
                and inst.components.equippable.onequipfn
                and inst.components.equippable.onunequipfn
        then
            local oldonequipfn = inst.components.equippable.onequipfn;
            local oldonunequipfn = inst.components.equippable.onunequipfn;
            inst.components.equippable:SetOnEquip(function(inst, owner)
                if owner  and owner.prefab == "xuaner" then
                    oldonequipfn(inst, owner);
                else
                    owner:DoTaskInTime(0, function()
                        if owner.components.inventory  then
                            owner.components.inventory :GiveItem(inst)
                        end
                        if  owner.components.talker then
                            owner.components.talker:Say("这是璇儿的剑鞘！")
                        end
                    end)
                    --
                end
            end)

            inst.components.equippable:SetOnUnequip(function(inst, owner)
                if owner  and owner.prefab == "xuaner" then
                    oldonunequipfn(inst, owner);
                end
            end)
        end
    end)
end