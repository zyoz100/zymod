local _G = GLOBAL;
local bugFixXuaner = GetModConfigData("bugFixXuaner") or false
local bugFixLy = GetModConfigData("bugFixLy") or false
local bugFixLevelAndAchievement = GetModConfigData("bugFixLevelAndAchievement") or false
--璇儿装备bug --xe_knife
if bugFixXuaner and _G.isModEnableById("2582670245") then
    AddPrefabPostInit("xe_scabbard", function(inst)
        if inst
                and inst.components
                and inst.components.equippable
                and inst.components.equippable.onequipfn
                and inst.components.equippable.onunequipfn
        then
            local oldonequipfn = inst.components.equippable.onequipfn;
            local oldonunequipfn = inst.components.equippable.onunequipfn;
            inst.components.equippable:SetOnEquip(function(inst, attacker)
                if attacker and attacker.prefab == "xuaner" then
                    oldonequipfn(inst, attacker);
                else
                    attacker:DoTaskInTime(0, function()
                        if attacker.components.inventory then
                            attacker.components.inventory:GiveItem(inst)
                        end
                        if attacker.components.talker then
                            attacker.components.talker:Say("这是璇儿的剑鞘！")
                        end
                    end)
                    --
                end
            end)

            inst.components.equippable:SetOnUnequip(function(inst, attacker)
                if attacker and attacker.prefab == "xuaner" then
                    oldonunequipfn(inst, attacker);
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
            if fu and fu.components.finiteuses and fu.components.finiteuses.SetOnFinished then
                fu.components.finiteuses:SetOnFinished(function(inst)
                    local player = inst.components.inventoryitem:GetGrandOwner()
                    inst:Remove()
                    if player then
                        player:DoTaskInTime(_G.FRAMES, function(player)
                            if player and not player:HasTag("playerghost") then
                                local scabbard = player.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
                                if scabbard

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
                                            scabbard.components.container:GiveItem(inventoryFu.components.inventoryitem:RemoveFromattacker(scabbard.components.container.acceptsstacks), i, nil, false)
                                            inventoryFu = nil
                                            break ;
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end)
            end

        end)
    end
    AddPrefabPostInit("xe_knife", function(inst)
        if inst
                and inst.components.weapon
        then
            inst.components.weapon:SetOnAttack(function(weapon, attacker, target)
                if weapon
                        and attacker
                        and target then
                    attacker.components.sanity:DoDelta(-0.5, true)
                    if attacker.sjsx then
                        if target.components.health and target.components.combat then
                            local damage = target.components.health.maxhealth / 100
                            local x, y, z = target.Transform:GetWorldPosition()
                            if attacker.sjsx.xe_jie_zhongzhan == 0 then
                                target.components.combat:GetAttacked(attacker, damage)
                            end
                            if attacker.sjsx.xe_jie_taotie == 0 then
                                attacker.components.health:DoDelta(attacker.components.health.maxhealth / 100)
                            end
                            if attacker.sjsx.xe_jie_taowu == 0 then
                                if target.components.health:GetPercent() < 0.85 then
                                    local tx = _G.SpawnPrefab("xe_bomb"):set(0.45)
                                    tx.Transform:SetPosition(x, y, z)
                                    target.components.combat:GetAttacked(attacker, inst.components.weapon.damage * attacker.components.combat.damagemultiplier * 1.5)

                                    if attacker.sjsx.xe_jie_zhongzhan == 0 then
                                        target.components.combat:GetAttacked(attacker, damage)
                                    end
                                    if attacker.sjsx.xe_jie_taotie == 0 then
                                        attacker.components.health:DoDelta(attacker.components.health.maxhealth / 0x64)
                                    end
                                end
                            end
                            if attacker.sjsx.xe_jie_qiongqi == 0 then
                                if target.components.health:GetPercent() < 0.65 then
                                    local fx = _G.SpawnPrefab("xe_laser"):set(0.4, attacker, inst.components.weapon:GetDamage(attacker, target) * attacker.components.combat.damagemultiplier * 1.2, 4)
                                    fx.Transform:SetPosition(x, y, z)
                                    if attacker.sjsx.xe_jie_zhongzhan == 0x0 then
                                        target.components.combat:GetAttacked(attacker, damage)
                                    end
                                    if attacker.sjsx.xe_jie_taotie == 0x0 then
                                        attacker.components.health:DoDelta(attacker.components.health.maxhealth / 0x64)
                                    end
                                end
                            end
                        end
                    end
                    local bodyEquip = attacker.components.inventory:GetEquippedItem(_G.EQUIPSLOTS.BODY)
                    if bodyEquip and bodyEquip.wqgjjc and target.components.combat then
                        target.components.combat:GetAttacked(attacker, inst.components.weapon.damage * bodyEquip.wqgjjc)
                    end
                end
            end)
        end
    end)

    local fxList = {
        "xe_bomb",
        "laser_ring_fx",
    }
    for k, v in pairs(fxList) do
        AddPrefabPostInit(v, function(fx)
            fx.set = function(inst, scale, duration, source, damage, radius)
                if inst then
                    if scale then
                        inst.Transform:SetScale(scale, scale, scale)
                    end
                    if duration then
                        inst:DoTaskInTime(duration, inst.Remove)
                    else
                        inst:ListenForEvent("animover", inst.Remove)
                    end
                    if damage then
                        inst:DoTaskInTime(0.2, function()
                            local x, y, z = inst.Transform:GetWorldPosition()
                            local ents = _G.TheSim:FindEntities(x, y, z, radius, { "_combat" }, { "player", "wall", "INLIMBO" })
                            for k, v in pairs(ents) do
                                if v and v.components.health and not v.components.health:IsDead() and v.components.combat then
                                    v.components.combat:GetAttacked(source, damage)
                                end
                            end
                        end)
                    end
                end
                return inst
            end
        end)
    end

    AddPrefabPostInit("xe_laser", function(fx)
        fx.set = function(inst, scale, source, damage, radius)
            if inst then
                if scale then
                    inst.Transform:SetScale(scale, scale, scale)
                end
                if damage then
                    inst:DoTaskInTime(1.1, function()
                        local x, y, z = inst.Transform:GetWorldPosition()
                        local ents = _G.TheSim:FindEntities(x, y, z, radius, { "_combat" }, { "player", "wall", "INLIMBO" })
                        for k, v in pairs(ents) do
                            if v and v.components.health and not v.components.health:IsDead() and v.components.combat then
                                v.components.combat:GetAttacked(source, damage)
                            end
                        end
                    end)
                end
            end
            return inst
        end
    end)
end
--附魔
if bugFixLy then
    AddPrefabPostInit("ly_magical_shadow", function(inst)
        if inst.Attack then
            local oldAttack = inst.Attack;
            inst.Attack = function(self)
                if self.target.components.combat then
                    oldAttack(self)
                end
            end
        end
    end)
end
--等级成就
if bugFixLevelAndAchievement and _G.isModEnableById("1840284484") then
    AddComponentPostInit("blinkstaff", function(com)
        if com.ResetSoundFX then
            com:ResetSoundFX()
        end

        function com:ResetSoundFX()
            com.presound = "dontstarve/common/staff_blink"
            com.postsound = "dontstarve/common/staff_blink"
        end

        function com:SetSoundFX(presound, postsound)
            com.presound = presound or com.presound
            com.postsound = postsound or com.postsound
        end
    end)

    AddComponentPostInit("levelsystem", function(levelsystem)
        function levelsystem:onkilledother(inst)
            inst:ListenForEvent("killed", function(killer, data)
                if _G.KILLXP ~= true then return end
                local victim = data.victim
                if victim and victim.components.health and killer:HasTag("player") and
                        not victim:HasTag("veggie") and
                        not victim:HasTag("structure") and
                        not victim:HasTag("wall") and
                        not victim:HasTag("balloon") and
                        not victim:HasTag("groundspike") and
                        not victim:HasTag("smashable") and
                        not victim:HasTag("companion") then
                    local xp = math.floor(victim.components.health.maxhealth*0.1+0.5)
                    if victim:HasTag("epic") then xp = math.floor(victim.components.health.maxhealth*0.25+0.5) end
                    xp = math.min(xp,100000)
                    local pos = Vector3(victim.Transform:GetWorldPosition())
                    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 15)

                    local playercount = 0
                    for k,v in pairs(ents) do
                        if v:HasTag("player") then
                            playercount = playercount + 1
                        end
                    end

                    for k,v in pairs(ents) do
                        if v:HasTag("player") then
                            v.components.levelsystem:xpDoDelta(math.ceil(xp*_G.EXPMULT/playercount), v)
                        end
                    end
                end
            end)
        end
    end)


end