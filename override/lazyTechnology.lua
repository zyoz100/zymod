local lazyTechKJKLimit = GetModConfigData("lazyTechKJKLimit") or "";
if lazyTechKJKLimit then
    local disableKjk = function(inst)
        if inst.components.lrhc_wxnj then
            local isEquippable = inst.components.equippable ~= nil;
            local isWeapon = inst.components.weapon ~= nil;  --判断是不是武器
            local isArmor = inst.components.armor ~= nil; --判断是不是护甲
            local isBody = false;
            local isHead = false;
            if isEquippable then
                isBody = inst.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.BODY;
                isHead = inst.components.equippable.equipslot == GLOBAL.EQUIPSLOTS.HEAD;
            end
            local isClothing = isEquippable and (isBody or isHead);
            local valid = false;
            if lazyTechKJKLimit == "equipment" then
                valid = isEquippable;
            elseif lazyTechKJKLimit == "weaponAndClothing" then
                valid = isWeapon or isClothing;
            elseif lazyTechKJKLimit == "clothing" then
                valid = isClothing;
            elseif lazyTechKJKLimit == "weapon" then
                valid = isWeapon;
            end
            if not valid and inst.components.lrhc_wxnj then
                inst:RemoveComponent('lrhc_wxnj')
            end
        end
    end
    AddPrefabPostInitAny(function(inst)
        if inst and inst.components.lrhc_wxnj then
            disableKjk(inst);
        end
    end)
end