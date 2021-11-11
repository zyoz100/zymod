local _G = GLOBAL;
local randomSizeEnhance = GetModConfigData("randomSizeEnhance") or 0;
if randomSizeEnhance > 0 then
    local List = {
        "moose","antlion","bearger","deerclops","beequeen","dragonfly",
        "shadow_rook","shadow_bishop","shadow_knight",
        "minotaur","toadstool","toadstool_dark","stalker_atrium",
        "spat","warg","spiderqueen","leif","leif_sparse"
    }
    local function Strong(inst)
        if inst.components.health then
            inst.components.health.maxhealth = inst.components.health.maxhealth * randomSizeEnhance
            inst.components.health:DoDelta(inst.components.health.maxhealth * 2)
        end
        inst.Transform:SetScale(1,1,1)
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
            _G.TUNING.SHADOW_KNIGHT.DAMAGE[1]*randomSizeEnhance,
            _G.TUNING.SHADOW_KNIGHT.DAMAGE[2]*randomSizeEnhance,
            _G.TUNING.SHADOW_KNIGHT.DAMAGE[3]*randomSizeEnhance,
        }
        _G.TUNING.SHADOW_KNIGHT.HEALTH = {
            _G.TUNING.SHADOW_KNIGHT.HEALTH[1]*randomSizeEnhance,
            _G.TUNING.SHADOW_KNIGHT.HEALTH[2]*randomSizeEnhance,
            _G.TUNING.SHADOW_KNIGHT.HEALTH[3]*randomSizeEnhance,
        }
        _G.TUNING.SHADOW_ROOK.DAMAGE = {
            _G.TUNING.SHADOW_ROOK.DAMAGE[1]*randomSizeEnhance,
            _G.TUNING.SHADOW_ROOK.DAMAGE[2]*randomSizeEnhance,
            _G.TUNING.SHADOW_ROOK.DAMAGE[3]*randomSizeEnhance,
        }
        _G.TUNING.SHADOW_ROOK.HEALTH = {
            _G.TUNING.SHADOW_ROOK.HEALTH[1]*randomSizeEnhance,
            _G.TUNING.SHADOW_ROOK.HEALTH[2]*randomSizeEnhance,
            _G.TUNING.SHADOW_ROOK.HEALTH[3]*randomSizeEnhance,
        }
        _G.TUNING.SHADOW_BISHOP.DAMAGE = {
            _G.TUNING.SHADOW_BISHOP.DAMAGE[1]*randomSizeEnhance,
            _G.TUNING.SHADOW_BISHOP.DAMAGE[2]*randomSizeEnhance,
            _G.TUNING.SHADOW_BISHOP.DAMAGE[3]*randomSizeEnhance,
        }
        _G.TUNING.SHADOW_BISHOP.HEALTH = {
            _G.TUNING.SHADOW_BISHOP.HEALTH[1]*randomSizeEnhance,
            _G.TUNING.SHADOW_BISHOP.HEALTH[2]*randomSizeEnhance,
            _G.TUNING.SHADOW_BISHOP.HEALTH[3]*randomSizeEnhance,
        }
    end
    for k,v in pairs(List) do
        AddPrefabPostInit(v, Strong)
    end
    _G.TUNING.KLAUS_HEALTH = _G.TUNING.ANTLION_HEALTH * randomSizeEnhance
    --_G.TUNING.ANTLION_HEALTH = _G.TUNING.ANTLION_HEALTH * randomSizeEnhance
    --_G.TUNING.LEIF_HEALTH = _G.TUNING.LEIF_HEALTH * randomSizeEnhance
    --_G.TUNING.LEIF_DAMAGE = _G.TUNING.LEIF_DAMAGE * randomSizeEnhance
end