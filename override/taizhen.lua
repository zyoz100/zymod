local taizhenImproveXX = GetModConfigData("taizhenImproveXX") or 0;
local taizhenMaxPill = GetModConfigData("taizhenMaxPill") or 0;
local taizhenTfSwordSkillRate = GetModConfigData("taizhenTfSwordSkillRate") or -1;
if taizhenImproveXX > 0 then
    AddComponentPostInit("tz_xx",
            function(self)
                local function onsetnet(self, num)
                    if self.inst.tz_xx ~= nil then
                        local dengji = self.dengji or 0
                        local jieduan = self.jieduan or 1
                        local ba = self.ba or 0
                        local sh = self.sh or 0
                        local hd = self.hd or 0
                        local kz = self.kz or 0
                        local jd_1 = self.jd_1 or 0
                        local jd_2 = self.jd_2 or 0
                        local jd_3 = self.jd_3 or 0
                        local jd_4 = self.jd_4 or 0
                        self.inst.tz_xx:set({ dengji, jieduan, ba, sh, hd, kz, jd_1, jd_2, jd_3, jd_4 })
                    end
                end

                local function onba(self, ba)
                    local inst = self.inst
                    if ba ~= 0 then
                        local modifer = 1;
                        if taizhenImproveXX == 1 then
                            modifer = ba;
                        else
                            modifer = taizhenImproveXX;
                        end
                        local _ba = ba * modifer;
                        if inst.components.health then
                            inst.components.health.externalabsorbmodifiers:SetModifier("tzxx", 0.005 * _ba) --减伤+0.5%
                        end
                        if inst.components.eater then
                            inst.components.eater:SetAbsorptionModifiers(1 + 0.01 * _ba, 1 + 0.01 * _ba, 1 + 0.01 * _ba) --食用食物回复效率+1%
                        end
                        if inst.components.hunger then
                            local hunger_percent = inst.components.hunger:GetPercent() --饥饿度上限+2  ba
                            inst.components.hunger.max = math.ceil(150 + _ba * 2)
                            inst.components.hunger:SetPercent(hunger_percent)
                        end
                        onsetnet(self)
                    end
                end

                local function onsh(self, sh)
                    local inst = self.inst
                    if sh ~= 0 then
                        local modifer = 1;
                        if taizhenImproveXX == 1 then
                            modifer = sh;
                        else
                            modifer = taizhenImproveXX;
                        end
                        local _sh = sh * modifer;
                        if inst.components.tzsama then
                            inst.components.tzsama.addrate = _sh --撒麻值回复+1/min
                        end
                        self.shanbi = 0.005 * _sh --对攻击闪避几率+0.5%
                        if inst.components.health then
                            local health_percent = inst.components.health:GetPercent() --生命值上限+1
                            inst.components.health.maxhealth = math.ceil(75 + _sh)
                            inst.components.health:SetPercent(health_percent)
                        end
                        onsetnet(self)
                    end
                end

                local function onhd(self, hd)
                    local inst = self.inst
                    if hd ~= 0 then
                        local modifer = 1;
                        if taizhenImproveXX == 1 then
                            modifer = hd;
                        else
                            modifer = taizhenImproveXX;
                        end
                        local _hd = hd * modifer;
                        if inst.components.tzsama then
                            inst.components.tzsama.addrate = _hd --撒麻值回复+1/min
                        end
                        self.xixue = 0.001 * _hd --吸血
                        if inst.components.sanity then
                            local sanity_percent = inst.components.sanity:GetPercent() --脑力值上限+1
                            inst.components.sanity.max = math.ceil(200 + _hd)
                            inst.components.sanity:SetPercent(sanity_percent)
                        end
                        onsetnet(self)
                    end
                end

                local function onkz(self, kz)
                    local inst = self.inst
                    if kz ~= 0 then
                        local modifer = 1;
                        if taizhenImproveXX == 1 then
                            modifer = kz / 2;
                        else
                            modifer = taizhenImproveXX;
                        end
                        local _kz = kz * modifer;
                        if inst.components.tzsama then
                            inst.components.tzsama.addrate = _kz --撒麻值回复+1/min
                        end
                        self.xisanity = 0.001 * _kz --吸精神
                        if inst.components.combat then
                            inst.components.combat.externaldamagemultipliers:SetModifier("tzxx", 1 + _kz * 0.02)
                        end
                        onsetnet(self)
                    end
                end
                GLOBAL.addsetter(self, "ba", onba)
                GLOBAL.addsetter(self, "sh", onsh)
                GLOBAL.addsetter(self, "hd", onhd)
                GLOBAL.addsetter(self, "kz", onkz)
            end
    )
end

if taizhenMaxPill > 0 then
    AddComponentPostInit("tz_bighealth",
            function(self)
                local oldAddBuff = self.AddBuff
                function self:AddBuff()
                    if self.rate < taizhenMaxPill then
                        oldAddBuff(self)
                    else
                        if self.task ~= nil then
                            self.task:Cancel()
                        end
                        self.task = self.inst:DoTaskInTime(self.time, function()
                            self:RemoveBuff()
                        end, self)
                        if self.inst.apingbighealthtime ~= nil then
                            self.inst.apingbighealthtime:set_local(0)
                            self.inst.apingbighealthtime:set(self.time)
                        end
                    end
                end
            end
    )
end

if taizhenTfSwordSkillRate > -1 then

    local function ReticuleTargetFn()
        local player = GLOBAL.ThePlayer
        local ground = GLOBAL.TheWorld.Map
        local pos = GLOBAL.Vector3()
        --Cast range is 8, leave room for error
        --4 is the aoe range
        for r = 7, 0, -.25 do
            pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
            if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
                return pos
            end
        end
        return pos
    end

    local function onspell(inst, doer, pos)

        local x, y, z = pos:Get()
        --print(x,y,z)
        local r = 7
        if doer.components.playercontroller ~= nil then
            doer.components.playercontroller:Enable(false)
        end
        if doer.components.health ~= nil then
            doer.components.health:SetInvincible(true)
        end
        if doer.DynamicShadow ~= nil then
            doer.DynamicShadow:Enable(false)
        end
        doer:Hide()
        local mul = 1;
        if doer.components.combat then
            mul = doer.components.combat.externaldamagemultipliers:Get()
        end
        local damage = ((mul - 1) * taizhenTfSwordSkillRate * (doer.prefab == "taizhen" and 2 or 1) + 1) * 55;

        if doer._fenshenzhan == nil then
            doer._fenshenzhan = doer:DoPeriodicTask(0.2, function()
                local ents = GLOBAL.TheSim:FindEntities(x, y, z, 7, { "_health", "_combat" }, { "INLIMBO", "wall", "playerghost", "player", "companion" })
                for i, v in ipairs(ents) do
                    if v and v:IsValid() and not v:IsInLimbo() then
                        if v.components.combat ~= nil then
                            v.components.combat:GetAttacked(doer, damage, inst)
                        end
                    end
                end
            end)
        end
        doer:DoTaskInTime(12 / 45 + 1.4, function()
            if doer._fenshenzhan ~= nil then
                doer._fenshenzhan:Cancel()
                doer._fenshenzhan = nil
            end
        end)
        doer:DoTaskInTime(12 / 45 + 2, function()
            if doer.components.playercontroller ~= nil then
                doer.components.playercontroller:Enable(true)
            end
            if doer.components.health ~= nil then
                doer.components.health:SetInvincible(false)
            end
            if doer.DynamicShadow ~= nil then
                doer.DynamicShadow:Enable(true)
            end
            doer:Show()
        end)
        doer:StartThread(function()
            for k = 1, 8 do
                local g = k * 45 + math.random(-15, 15)
                local fx = GLOBAL.SpawnPrefab("tz_cccanying")
                if fx then
                    fx.AnimState:SetBuild(doer.prefab)
                    fx.Transform:SetPosition(x + r * math.cos(2 * math.pi / 360 * g), 0, z + r * math.sin(2 * math.pi / 360 * g))
                    GLOBAL.SpawnPrefab("statue_transition_2").Transform:SetPosition(fx.Transform:GetWorldPosition())
                    fx:ForceFacePoint(x, 0, z)
                    fx:DoTaskInTime(0.1, function()
                        fx:Yichu(12 / 45 + (8 - k) * 0.2 + 0.5)
                        fx.Physics:SetMotorVel(40, 0, 0)
                        fx.SoundEmitter:PlaySound("dontstarve/wilson/attack_nightsword")
                        fx:DoTaskInTime(14 / 40, function()
                            fx.Physics:Stop()
                            fx.Physics:SetMotorVel(0, 0, 0)
                        end)
                    end)
                end
                GLOBAL.Sleep(.2)
            end
        end)
        inst.components.rechargeable:StartRecharge()
        if inst.components.tz_firelvl then
            inst.components.tz_firelvl:DoDelta(-15)
        end
        if doer._tflight ~= nil then
            doer._tflight:Remove()
            doer._tflight = nil
            if doer.components.combat ~= nil then
                doer.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            end
        end

    end

    AddPrefabPostInit("tz_tfsword", function(inst)
        inst:AddTag("rechargeable")

        inst:AddComponent("aoetargeting")
        inst.components.aoetargeting.reticule.reticuleprefab = "reticuleaoesummon"
        inst.components.aoetargeting.reticule.pingprefab = "reticuleaoesummonping"
        inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
        inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
        inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
        inst.components.aoetargeting.reticule.ease = true
        inst.components.aoetargeting.reticule.mouseenabled = true

        inst:AddComponent("tz_aoespell")
        inst.components.aoespell = inst.components.tz_aoespell
        inst.components.aoespell.canuseonpoint = true
        inst.components.aoespell:SetSpellFn(onspell)
        inst:RegisterComponentActions("aoespell")

        inst:AddComponent("tz_rechargeable")
        inst.components.rechargeable = inst.components.tz_rechargeable
        inst.components.rechargeable:SetRechargeTime(30)
        inst:RegisterComponentActions("rechargeable")
    end)
end
