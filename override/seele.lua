local _G = GLOBAL
local seeleMaxLevel = GetModConfigData("seeleMaxLevel") or 0;
local seeleDayMaxLevel = GetModConfigData("seeleDayMaxLevel") or 0;
local seeleStrengthByLevel = GetModConfigData("seeleStrengthByLevel") or 0;
local seeleReaperMaxLevel = GetModConfigData("seeleReaperMaxLevel") or 0;
local seeleReaperCritUnlockRatio = GetModConfigData("seeleReaperCritUnlockRatio") or 0;
if seeleMaxLevel > 0 then
    AddPrefabPostInit('seele', function(inst)
        inst.max_level = seeleMaxLevel
    end)
end

if seeleDayMaxLevel > 0 then
    local OnSeeleExpFunctionName = "o5e6fP"
    local OnSeeleStateFunctionName = "bb"
    AddSimPostInit(function()
        if GLOBAL.Prefabs.seele then
            local OnSeeleState = up.Get(GLOBAL.Prefabs.seele.fn, OnSeeleStateFunctionName, 'seele.lua')
            local OnSeeleExp = function(player, amount)
                if player.components.seelebase.dayLevelDay ~= _G.TheWorld.state.cycles then
                    player.components.seelebase.dayLevelDelta = 0;
                    player.components.seelebase.dayLevelDay = _G.TheWorld.state.cycles;
                end
                player.components.seelebase.current = player.components.seelebase.current + amount
                local isLevelUp = false;
                while true do
                    local levelExp = 25 * (player.components.seelebase.level + 1);
                    if player.components.seelebase.level >= player.max_level then
                        player.components.seelebase.current = 0
                        break ;
                    elseif player.components.seelebase.dayLevelDelta >= seeleDayMaxLevel then
                        player.components.seelebase.current = math.min(player.components.seelebase.current, levelExp - 1)
                        break ;
                    elseif player.components.seelebase.current > levelExp then
                        player.components.seelebase.level = player.components.seelebase.level + 1
                        player.components.seelebase.dayLevelDelta = player.components.seelebase.dayLevelDelta + 1
                        player.components.seelebase.current = player.components.seelebase.current - levelExp
                        isLevelUp = true;
                    else
                        break ;
                    end
                end
                if isLevelUp then
                    player.restrict = true
                    OnSeeleState(player)
                    player.components.talker:Say(_G.STRINGS.SEELE_LEVELUP)
                end
            end
            up.Set(GLOBAL.Prefabs.seele.fn, OnSeeleExpFunctionName, OnSeeleExp, 'seele.lua')
        end
    end)
    AddComponentPostInit("seelebase", function(com)
        com.dayLevelDelta = 0
        com.dayLevelDay = 0
        local oldOnSave = com.OnSave;
        com.OnSave = function(self, ...)
            local data = oldOnSave(self, ...)
            data.dayLevelDelta = self.dayLevelDelta
            data.dayLevelDay = self.dayLevelDay
            return data;
        end

        local oldOnLoad = com.OnLoad;
        com.OnLoad = function(self, data, ...)
            local result = oldOnLoad(self, data, ...)
            self.dayLevelDelta = data.dayLevelDelta
            self.dayLevelDay = data.dayLevelDay
            return result;
        end

        if seeleStrengthByLevel > 0 then
            local oldUseStrength = com.UseStrength
            com.UseStrength = function(self, amount)
                local addMaxlevel = math.floor(self.level / seeleStrengthByLevel);
                if amount ~= nil then
                    self.strength = math.max(
                            math.min(
                                    self.strength + amount,
                                    (_G.TUNING.SEELEDATA.VOLITIONLAYERS == 2 and 21 or 31) + addMaxlevel
                            ),
                            self.inst.components.inventory:EquipHasTag("seele_uniform") and 11 or 1
                    )
                end
                oldUseStrength(self)
            end
        end
    end)
end

if seeleReaperMaxLevel > 0 then
    local onGluttonyChangeName = "G5BuU5";
    AddSimPostInit(function()
        if GLOBAL.Prefabs.seele_reaper then
            local onGluttonyChange = up.Get(GLOBAL.Prefabs.seele_reaper.fn, onGluttonyChangeName, 'abysmal_category.lua')
            up.Set(GLOBAL.Prefabs.seele_reaper.fn, onGluttonyChangeName, function(weapon, amount, use)
                if amount ~= nil then
                    weapon.components.seelereaper.gluttony = math.min(math.max(weapon.components.seelereaper.gluttony + amount, 0), seeleReaperMaxLevel)
                end
                onGluttonyChange(weapon, nil, use);
            end, 'abysmal_category.lua')
        end
    end)
end

if seeleReaperCritUnlockRatio > 0 then
    AddPrefabPostInit('seele_reaper', function(inst)
        if inst.components.weapon then
            inst.components.weapon:SetOnAttack(function(weapon, attacker, target)
                if weapon.gluttony then
                    local critUnlockGluttony = math.ceil((seeleReaperMaxLevel or 30) * seeleReaperCritUnlockRatio)
                    local crit = math.max(inst.gluttony - critUnlockGluttony, 0);
                    if crit > 0 and math.random() <= crit / 100 and not target:HasTag("wall") and target.components.combat then
                        local damage = attacker.components.combat:CalcDamage(target, inst, crit / 100 + 1)
                        target.components.combat:GetAttacked(attacker, damage)
                        if target.SoundEmitter ~= nil then
                            target.SoundEmitter:PlaySound("dontstarve/common/whip_large")
                        end
                    end
                end
            end)
        end
    end)
end

