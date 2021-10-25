local _G = GLOBAL
local dogheadSkillDamageImprove = GetModConfigData("dogheadSkillDamageImprove") or 0;
local dogheadSkillGetMoreSoul = GetModConfigData("dogheadSkillGetMoreSoul") or 0;
if dogheadSkillDamageImprove > 0 or dogheadSkillGetMoreSoul > 0 then
    AddPrefabPostInit("doghead", function(player)
        local fn = up.GetEventHandle(player, "onhitother", "doghead.lua")
        if fn then
            player:RemoveEventCallback("onhitother", fn)
        end

        local function soulHarvest(inst, target)
            if not target:HasTag("veggie")
                    and not target:HasTag("structure")
                    and not target:HasTag("wall") then
                local targetH = target.components.health.maxhealth
                if dogheadSkillGetMoreSoul > 0 then
                    inst.soul = inst.soul + math.floor(math.sqrt(targetH, 2) / dogheadSkillGetMoreSoul)
                else
                    if targetH >= 100 then
                        inst.soul = inst.soul + 1
                    end
                    if targetH >= 300 then
                        inst.soul = inst.soul + 1
                    end
                    if targetH >= 500 then
                        inst.soul = inst.soul + 1
                    end
                    if targetH >= 1000 then
                        inst.soul = inst.soul + 7
                    end
                end

            end
        end
        local function onAttack(inst, data)
            if inst.attackTime == false then
                return
            end
            inst.attackTime = false
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) == nil or inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab ~= "soul_harvester" then
                inst.attackTime = true
                return
            end
            if inst.cooling == 3 then
                inst.SoundEmitter:PlaySound("hit/hit/hit")
                local sword_thud = SpawnPrefab("groundpound_fx")
                sword_thud.entity:SetParent(data.target.entity)
                sword_thud.Transform:SetPosition(0, 0, 0)
                sword_thud.Transform:SetScale(0.7, 0.7, 0.7)
                inst.components.health:DoDelta(3 + inst.soul / 5)
                inst.attackTime = false
                if not data.target.components.health:IsDead() then
                    local damage = (20 + inst.soul);
                    if dogheadSkillDamageImprove > 0 then
                        local mul = inst.components.combat.externaldamagemultipliers:Get()
                        data.target.components.combat:GetAttacked(inst, damage * mul * dogheadSkillDamageImprove)
                    else
                        data.target.components.combat:GetAttacked(inst, damage)
                    end
                end
                --inst.attackTime=true
                if data.target.components.health:IsDead() then
                    soulHarvest(inst, data.target)
                end
                if inst.big == false then
                    inst.cooling = 1
                    --inst.SoundEmitter:PlaySound("doghead/doghead/hit2")
                    inst.AnimState:OverrideSymbol("swap_object", "swap_soul_harvester", "swap_soul_harvester")
                    inst:DoTaskInTime(--[[Duration]] Q_coolingtime, function()
                        if inst.big == false and inst.cooling == 1 and (inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).prefab == "soul_harvester") then
                            inst.cooling = 2
                            inst.AnimState:OverrideSymbol("swap_object", "swap_soul_harvesterR", "swap_soul_harvesterR")
                        end
                    end)
                end
            end
            inst.attackTime = true
        end
        player:ListenForEvent("onhitother", onAttack)
    end)
end