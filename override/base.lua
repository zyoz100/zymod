local _G = GLOBAL;
local baseCombatCanAttackDeath = GetModConfigData("baseCombatCanAttackDeath") or false;
local baseBossGrowth = GetModConfigData("baseBossGrowth") or 2;
local baseRandomDamageLow = GetModConfigData("baseRandomDamageLow") or 0;
local baseDropDisappear = GetModConfigData("baseDropDisappear") or 0;
local baseReduceAnnounce = GetModConfigData("baseReduceAnnounce") or 0;
local baseSavePlayerDataEX = GetModConfigData("baseSavePlayerDataEX") or 0;
if baseCombatCanAttackDeath then
    AddComponentPostInit("combat", function(self)
        -- 我是伞兵 不会hook
        function self:GetAttacked(attacker, damage, weapon, stimuli)
            --兼容乃木园子
            if self.inst:HasTag("chongshenbuff") then
                return false
            end
            if weapon ~= nil and weapon.prefab == "yuanzi_spear_lv2" or stimuli == "yuanzi_ignoredebuff" then
                self.inst.yuanzi_ignoredebuff = true
                damage = damage / self.externaldamagetakenmultipliers:Get()
            end


            if self.inst:HasTag("player") and self.inst.components.health and self.inst.components.health:IsDead() then
                return true
            end
            self.lastwasattackedtime = GLOBAL.GetTime()
            --print ("ATTACKED", self.inst, attacker, damage)
            --V2C: redirectdamagefn is currently only used by either mounting or parrying,
            --     but not both at the same time.  If we use it more, then it really needs
            --     to be refactored.
            local blocked = false
            local damageredirecttarget = self.redirectdamagefn ~= nil and self.redirectdamagefn(self.inst, attacker, damage, weapon, stimuli) or nil
            local damageresolved = 0

            self.lastattacker = attacker

            if self.inst.components.health ~= nil and damage ~= nil and damageredirecttarget == nil then
                if self.inst.components.inventory ~= nil then
                    damage = self.inst.components.inventory:ApplyDamage(damage, attacker, weapon)
                end
                damage = damage * self.externaldamagetakenmultipliers:Get()
                if damage > 0 and not self.inst.components.health:IsInvincible() then
                    --Bonus damage only applies after unabsorbed damage gets through your armor
                    if attacker ~= nil and attacker.components.combat ~= nil and attacker.components.combat.bonusdamagefn ~= nil then
                        damage = (damage + attacker.components.combat.bonusdamagefn(attacker, self.inst, damage, weapon)) or 0
                    end

                    local cause = attacker == self.inst and weapon or attacker
                    --V2C: guess we should try not to crash old mods that overwrote the health component
                    damageresolved = self.inst.components.health:DoDelta(-damage, nil, cause ~= nil and (cause.nameoverride or cause.prefab) or "NIL", nil, cause)
                    damageresolved = damageresolved ~= nil and -damageresolved or damage
                    if self.inst.components.health:IsDead() then
                        if attacker ~= nil then
                            attacker:PushEvent("killed", { victim = self.inst })
                        end
                        if self.onkilledbyother ~= nil then
                            self.onkilledbyother(self.inst, attacker)
                        end
                    end
                else
                    blocked = true
                end
            end

            local redirect_combat = damageredirecttarget ~= nil and damageredirecttarget.components.combat or nil
            if redirect_combat ~= nil then
                redirect_combat:GetAttacked(attacker, damage, weapon, stimuli)
            end

            if self.inst.SoundEmitter ~= nil and not self.inst:IsInLimbo() then
                local hitsound = self:GetImpactSound(damageredirecttarget or self.inst, weapon)
                if hitsound ~= nil then
                    self.inst.SoundEmitter:PlaySound(hitsound)
                end
                if damageredirecttarget ~= nil then
                    if redirect_combat ~= nil and redirect_combat.hurtsound ~= nil then
                        self.inst.SoundEmitter:PlaySound(redirect_combat.hurtsound)
                    end
                elseif self.hurtsound ~= nil then
                    self.inst.SoundEmitter:PlaySound(self.hurtsound)
                end
            end

            if not blocked then
                self.inst:PushEvent("attacked", { attacker = attacker, damage = damage, damageresolved = damageresolved, weapon = weapon, stimuli = stimuli, redirected = damageredirecttarget, noimpactsound = self.noimpactsound })

                if self.onhitfn ~= nil then
                    self.onhitfn(self.inst, attacker, damage)
                end

                if attacker ~= nil then
                    attacker:PushEvent("onhitother", { target = self.inst, damage = damage, damageresolved = damageresolved, stimuli = stimuli, weapon = weapon, redirected = damageredirecttarget })
                    if attacker.components.combat ~= nil and attacker.components.combat.onhitotherfn ~= nil then
                        attacker.components.combat.onhitotherfn(attacker, self.inst, damage, stimuli)
                    end
                end
            else
                self.inst:PushEvent("blocked", { attacker = attacker })
            end

            if self.target == nil or self.target == attacker then
                self.lastwasattackedbytargettime = self.lastwasattackedtime
            end

            return not blocked
        end
    end)
end

if baseBossGrowth > 0 then
    local knockBack = function(knocker, target, rate, radius, propsmashed)

        if knocker and target and rate > 0 and radius > 0 then
            local ningxuebuff = target.components.health.ningxuebuff;
            local nostiff = target:HasTag("nostiff");
            local isEquipValkyrieCertificate = target.components.inventory
                    and target.components.inventory.EquipMedalWithName
                    and target.components.inventory:EquipMedalWithName("valkyrie_certificate");
            local isKnockBack = not (ningxuebuff or nostiff or isEquipValkyrieCertificate)
            if isKnockBack and math.random() < rate then
                target:PushEvent("knockback", {
                    knocker = knocker,
                    radius = radius,
                    propsmashed = propsmashed
                })
            end
        end


    end
    --[[
        龙蝇
            稍微加强
                每次攻击有30%概率 击退2格
            一般加强
                每次攻击有60%概率 击退3格
                每次击退有15%概率 缴械（掉落武器）
            困难加强
                每次攻击有90%概率 击退4格
                每次击退有30%概率 缴械（掉落武器）
    ]]
    AddPrefabPostInit("dragonfly", function(inst)
        local function OnHitOther(inst, data)
            if data.target ~= nil then
                knockBack(
                        inst,
                        data.target,
                        baseBossGrowth * 0.3,
                        1 + baseBossGrowth,
                        math.random() < (baseBossGrowth - 1) * 0.15
                )
            end
        end
        inst:ListenForEvent("onhitother", OnHitOther)
    end)
    --[[
        熊大
            稍微加强
                每次收到攻击有10%概率 催眠攻击者2s
            一般加强
                每次收到攻击有20%概率 催眠攻击者4s
            困难加强
                每次收到攻击有30%概率 催眠攻击者6s
    ]]
    AddPrefabPostInit("bearger", function(inst)
        local function OnAttacked(inst, data)
            if data.attacker ~= nil then
                if math.random() < baseBossGrowth * 0.1 then
                    data.attacker:PushEvent("yawn", { grogginess = 4, knockoutduration = baseBossGrowth * 2 })
                end
            end
        end
        inst:ListenForEvent("attacked", OnAttacked)
    end)
    --[[
        巨鹿
            稍微加强
                击中玩家造成无视一切的伤害 20 (真伤)
            一般加强
                击中玩家造成无视一切的伤害 40 (真伤)
            困难加强
                击中玩家造成无视一切的伤害 60 (真伤)
    ]]
    AddPrefabPostInit("deerclops", function(inst)
        local function OnHitOther(inst, data)
            local target = data.target;
            if target ~= nil and target:IsValid()
                    and not target:HasTag("alwaysblock")    --有了这个标签，什么天神都伤害不了
                    and target.prefab ~= "laozi"        --无法伤害神话书说里的太上老君
                    and target.components.health ~= nil
                    and not target.components.health:IsDead() --已经死亡则不再攻击
            then
                target.components.health:DoDelta(-baseBossGrowth * 20, nil, (inst.nameoverride or inst.prefab), true, inst, true)
                if target.components.health:IsDead() then
                    inst:PushEvent("killed", { victim = target })
                    if target.components.combat ~= nil and target.components.combat.onkilledbyother ~= nil then
                        target.components.combat.onkilledbyother(target, inst)
                    end
                end
            end
        end
        inst:ListenForEvent("onhitother", OnHitOther)
    end)
    --[[
        犀牛
            稍微加强
                每次攻击有15%概率 击退2格
            一般加强
                每次攻击有30%概率 击退3格
            困难加强
                每次攻击有45%概率 击退4格
    ]]
    AddPrefabPostInit("minotaur", function(inst)
        local function OnHitOther(inst, data)
            if data.target ~= nil then
                knockBack(
                        inst,
                        data.target,
                        baseBossGrowth * 0.15,
                        1 + baseBossGrowth,
                        false
                )
            end
        end
        inst:ListenForEvent("onhitother", OnHitOther)
    end)
    --[[
        鹿鸭
            稍微加强
                闪避15%的攻击（没有伤害切无硬直）
            一般加强
                闪避25%的攻击
            困难加强
                闪避35%的攻击
    ]]
    AddPrefabPostInit("moose", function(inst)
        inst.components.combat.oldAttacked = inst.components.combat.GetAttacked
        function inst.components.combat:GetAttacked(...)
            if inst.components and math.random() < baseBossGrowth * 0.1 + 0.15 then
                local fx = GLOBAL.SpawnPrefab("shadow_shield3")
                fx.entity:SetParent(inst.entity)
                fx.entity:AddFollower()
                fx.Follower:FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
            else
                return inst.components.combat:oldAttacked(...)
            end
        end
    end)

    --[[
        蜂后
            稍微加强
                10%被攻击回复被击中伤害的血量 * 2
            一般加强
                15%被攻击回复被击中伤害的血量 * 2
            困难加强
                20%被攻击回复被击中伤害的血量 * 2
    ]]
    AddPrefabPostInit("beequeen", function(inst)
        local function OnAttacked(inst, data)
            if data.attacker ~= nil
                    and inst.components ~= nil
                    and inst.components.health ~= nil
                    and not inst.components.health:IsDead()
            then
                if math.random() < baseBossGrowth * 0.05 + 0.05 then
                    local damageresolved = data.damageresolved or 0;
                    inst.components.health:DoDelta(damageresolved * 2);
                end
            end
        end
        inst:ListenForEvent("attacked", OnAttacked)
    end)

    --[[
        蛤蟆
            稍微加强
                10%被攻击回复缺失血量的20%
            一般加强
                15%被攻击回复缺失血量的25%
            困难加强
                20%被攻击回复缺失血量的30%
    ]]
    local toadstoolPostInit = function(inst)
        local function OnAttacked(inst, data)
            if inst.components ~= nil and inst.components.health ~= nil and not inst.components.health:IsDead() then
                if math.random() < baseBossGrowth * 0.05 + 0.05 then
                    local maxHealth = inst.components.health.maxhealth or 100;
                    local currenthealth = inst.components.health.currenthealth or 1;
                    local healHealth = (maxHealth - currenthealth) * (baseBossGrowth * 0.05 + 0.15);
                    inst.components.health:DoDelta(math.max(healHealth, 0));
                end
            end
        end
        inst:ListenForEvent("attacked", OnAttacked)
    end
    AddPrefabPostInit("toadstool", toadstoolPostInit)
    AddPrefabPostInit("toadstool_dark", toadstoolPostInit)

    --[[
        克劳斯
            稍微加强
                每次攻击有20%概率 击退2格
            一般加强
                每次攻击有25%概率 击退3格
            困难加强
                每次攻击有30%概率 击退4格
    ]]
    local toadstoolPostInit = function(inst)
        local function OnHitOther(inst, data)
            if data.target ~= nil then
                knockBack(
                        inst,
                        data.target,
                        baseBossGrowth * 0.05 + 0.15,
                        1 + baseBossGrowth,
                        false
                )
            end
        end
        inst:ListenForEvent("onhitother", OnHitOther)
    end
    AddPrefabPostInit("klaus", toadstoolPostInit)
end

if baseRandomDamageLow > 0 then
    --基本照抄全面加强
    AddPrefabPostInitAny(function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return nil
        end
        if not (inst:HasTag("FX") or inst:HasTag("DECOR") or inst:HasTag("INLIMBO"))
                and not (inst:HasTag("player") or inst:HasTag("abigail") or inst:HasTag("shadowminion"))
        then
            local function external_combat(inst, data)
                if data ~= nil and inst.components.health and inst.components.health.externalabsorbmodifiers then
                    inst.components.health.externalabsorbmodifiers:SetModifier("zyMod", math.random() * baseRandomDamageLow, "key_random_damagetaken")
                end
            end
            inst:ListenForEvent("onattackother", external_combat)
            inst:ListenForEvent("attacked", external_combat)
            if inst.components.combat then
                external_combat(inst, true)
            end
        end
    end)
end

if baseDropDisappear > 0 then
    -- 参照Yeo的代码 https://github.com/zYeoman/DST_mod/blob/master/postinit/c_lootdropper.lua

    local disappear = CreateDisappearFn(baseDropDisappear)

    AddPrefabPostInitAny(function(inst)
        if inst and inst.components.inventoryitem then
            inst:ListenForEvent("on_loot_dropped", function(loot, data)
                disappear(loot, data);
            end)
        end
    end)
end

if baseReduceAnnounce > 0 then
    _G.announceList = {}
    local net = GLOBAL.getmetatable(GLOBAL.TheNet)
    local oldAnnounce = GLOBAL.TheNet.Announce
    net.__index.Announce = function(Net, text, ...)
        local valid = true;
        local announceList = {}
        for k, v in ipairs(_G.announceList) do
            if _G.GetTime() - v.time < baseReduceAnnounce then
                table.insert(announceList, v)
            end
        end

        for k, v in ipairs(announceList) do
            if v.text == text then
                valid = false
            end
        end
        if valid then
            _G.announceList = announceList
            table.insert(_G.announceList, {
                time = _G.GetTime(),
                text = text,
            })
            SendModRPCToShard(SHARD_MOD_RPC["zy"]["announce"], text, _G.GetTime())
            return oldAnnounce(Net, text, ...)
        else
            _G.announceList = announceList
        end

    end

    AddShardModRPCHandler("zy", "announce", function(value, time)
        if value and type(value) == "string" then
            _G.announceList = _G.announceList or {};
            table.insert(_G.announceList, {
                time = time,
                text = value,
            })
        end
    end)
end

if baseSavePlayerDataEX then
    AddPrefabPostInit("world", function(inst)
        if not _G.TheWorld.ismastersim then
            return
        end
        inst:AddComponent("zy_player_save_data")
    end)

    AddShardModRPCHandler( "zy", "player_save_data", function(userid,dataString)
        if dataString and type(dataString) == "string" then
            local zy_player_save_data = TheWorld and TheWorld.components.zy_player_save_data or nil
            if zy_player_save_data and  zy_player_save_data.AddPlayerInfo ~= nil then
                local success, b = pcall(json.decode,value)
                if success and b ~= nil then
                    zy_player_save_data:SetPlayerSaveDataByUserId(userid, b)
                end
            end
        end
    end)
end