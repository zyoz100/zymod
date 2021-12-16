local _G = GLOBAL;
local randomSizeEnhance = GetModConfigData("randomSizeEnhance") or 0;
local randomSizeRemoveShadowMeteorToOther = GetModConfigData("randomSizeRemoveShadowMeteorToOther") or 0;
if randomSizeEnhance > 0 then
    local List = {
        "moose", "antlion", "bearger", "deerclops",
        "klaus", "beequeen", "dragonfly",
        "shadow_rook", "shadow_bishop", "shadow_knight",
        "minotaur", "toadstool", "toadstool_dark", "stalker_atrium",
        "spat", "warg", "spiderqueen", "leif", "leif_sparse"
    }
    local function Strong(inst)
        if inst.components.health then
            inst.components.health.maxhealth = inst.components.health.maxhealth * randomSizeEnhance
            inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
        end
        inst.Transform:SetScale(1, 1, 1)
        _G.TUNING.WARG_DAMAGE = _G.TUNING.WARG_DAMAGE * randomSizeEnhance;
        _G.TUNING.SPIDERQUEEN_DAMAGE = _G.TUNING.SPIDERQUEEN_DAMAGE * randomSizeEnhance;
        _G.TUNING.MOOSE_DAMAGE = _G.TUNING.MOOSE_DAMAGE * randomSizeEnhance;
        _G.TUNING.BEARGER_DAMAGE = _G.TUNING.BEARGER_DAMAGE * randomSizeEnhance;
        _G.TUNING.DEERCLOPS_DAMAGE = _G.TUNING.DEERCLOPS_DAMAGE * randomSizeEnhance;
        _G.TUNING.DRAGONFLY_DAMAGE = _G.TUNING.DRAGONFLY_DAMAGE * randomSizeEnhance;
        _G.TUNING.DRAGONFLY_FIRE_DAMAGE = _G.TUNING.DRAGONFLY_FIRE_DAMAGE * randomSizeEnhance;
        _G.TUNING.BEEQUEEN_DAMAGE = _G.TUNING.BEEQUEEN_DAMAGE * randomSizeEnhance;
        _G.TUNING.KLAUS_DAMAGE = _G.TUNING.KLAUS_DAMAGE * randomSizeEnhance;
        _G.TUNING.MINOTAUR_DAMAGE = _G.TUNING.MINOTAUR_DAMAGE * randomSizeEnhance;
        _G.TUNING.MINOTAUR_DAMAGE = _G.TUNING.MINOTAUR_DAMAGE * randomSizeEnhance;
        _G.TUNING.SHADOW_KNIGHT.DAMAGE = {
            _G.TUNING.SHADOW_KNIGHT.DAMAGE[1] * randomSizeEnhance,
            _G.TUNING.SHADOW_KNIGHT.DAMAGE[2] * randomSizeEnhance,
            _G.TUNING.SHADOW_KNIGHT.DAMAGE[3] * randomSizeEnhance,
        }
        _G.TUNING.SHADOW_KNIGHT.HEALTH = {
            _G.TUNING.SHADOW_KNIGHT.HEALTH[1] * randomSizeEnhance,
            _G.TUNING.SHADOW_KNIGHT.HEALTH[2] * randomSizeEnhance,
            _G.TUNING.SHADOW_KNIGHT.HEALTH[3] * randomSizeEnhance,
        }
        _G.TUNING.SHADOW_ROOK.DAMAGE = {
            _G.TUNING.SHADOW_ROOK.DAMAGE[1] * randomSizeEnhance,
            _G.TUNING.SHADOW_ROOK.DAMAGE[2] * randomSizeEnhance,
            _G.TUNING.SHADOW_ROOK.DAMAGE[3] * randomSizeEnhance,
        }
        _G.TUNING.SHADOW_ROOK.HEALTH = {
            _G.TUNING.SHADOW_ROOK.HEALTH[1] * randomSizeEnhance,
            _G.TUNING.SHADOW_ROOK.HEALTH[2] * randomSizeEnhance,
            _G.TUNING.SHADOW_ROOK.HEALTH[3] * randomSizeEnhance,
        }
        _G.TUNING.SHADOW_BISHOP.DAMAGE = {
            _G.TUNING.SHADOW_BISHOP.DAMAGE[1] * randomSizeEnhance,
            _G.TUNING.SHADOW_BISHOP.DAMAGE[2] * randomSizeEnhance,
            _G.TUNING.SHADOW_BISHOP.DAMAGE[3] * randomSizeEnhance,
        }
        _G.TUNING.SHADOW_BISHOP.HEALTH = {
            _G.TUNING.SHADOW_BISHOP.HEALTH[1] * randomSizeEnhance,
            _G.TUNING.SHADOW_BISHOP.HEALTH[2] * randomSizeEnhance,
            _G.TUNING.SHADOW_BISHOP.HEALTH[3] * randomSizeEnhance,
        }
    end
    for k, v in pairs(List) do
        AddPrefabPostInit(v, Strong)
    end
    --_G.TUNING.ANTLION_HEALTH = _G.TUNING.ANTLION_HEALTH * randomSizeEnhance
    --_G.TUNING.LEIF_HEALTH = _G.TUNING.LEIF_HEALTH * randomSizeEnhance
    --_G.TUNING.LEIF_DAMAGE = _G.TUNING.LEIF_DAMAGE * randomSizeEnhance
end

if randomSizeRemoveShadowMeteorToOther > 0 then
    local function DoSpawnMeteor(target)
        if target and target.components.health and target.components.health:IsDead() then
            if target.components.health and target.components.health:IsDead() then
                return false
            else
                local pt = target:GetPosition()
                local theta = math.random() * 2 * _G.PI
                local radius = target:HasTag("playerghost") and
                        math.random(math.random(1, 3) + 1, 15 + math.random(1, 3) * 2) or
                        math.random(math.random(1, 3) - 1, 5 + math.random(1, 3) * 2)
                local offset = _G.FindWalkableOffset(pt, theta, radius, 12, true)
                if offset ~= nil then
                    pt.x = pt.x + offset.x
                    pt.z = pt.z + offset.z
                end
                _G.SpawnPrefab("shadowmeteor").Transform:SetPosition(pt.x, 0, pt.z)
            end
        end

    end
    local function SpawnEndMeteors(inst,maxmeteors)
        for n = 1, math.random(maxmeteors or 150) do
            local x, y, z = inst.Transform:GetWorldPosition()
            local range = randomSizeRemoveShadowMeteorToOther
            local ents = _G.TheSim:FindEntities(x, y, z, range,{"player"})
            for i, v in pairs(ents) do
                if v:HasTag("player")  then
                    if n <= 10 then
                        v:DoTaskInTime((0.5 + math.random() * 0.5), DoSpawnMeteor)
                    end
                    v:DoTaskInTime((math.random() + .33) * n * .5, DoSpawnMeteor)
                end
            end
        end
    end
    local function SpawnStartMeteors(inst,maxmeteors,time)
        if inst.persists and inst.components.combat ~= nil then
            local delaytime = math.floor((math.random() * 0.5 + 0.5) * 2 + (time or 20))
            inst:DoTaskInTime(delaytime, function(inst)
                SpawnEndMeteors(inst,(maxmeteors or 1))
            end)
        end
    end

    local function strongantlion(inst, data)
        inst.components.health:SetAbsorptionAmount(0.35)
        if inst.components.freezable then
            inst.components.freezable:SetResistance(100)
        end
        inst:RemoveEventCallback("attacked", strongantlion)
        SpawnStartMeteors(inst,150)
        SpawnStartMeteors(inst,1)
        SpawnStartMeteors(inst,1)
        SpawnStartMeteors(inst,1)
        SpawnStartMeteors(inst,1,60)
    end

    local function delayfreeze(inst)
        inst:ListenForEvent("attacked", strongantlion)
    end
    AddPrefabPostInit("antlion", function(inst)
        local fn = up.GetEventHandle(inst, "onacceptfighttribute", "jq_jq")
        inst:RemoveEventCallback("onacceptfighttribute", fn)
        inst:ListenForEvent("onacceptfighttribute", delayfreeze)
    end)
end