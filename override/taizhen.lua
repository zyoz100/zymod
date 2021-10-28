local taizhenImproveXX = GetModConfigData("taizhenImproveXX") or 0;
local taizhenMaxPill = GetModConfigData("taizhenMaxPill") or 0;
if taizhenImproveXX >0 then
    AddComponentPostInit("tz_xx",
            function(self)
                local function onsetnet(self,num)
                    if self.inst.tz_xx ~= nil then
                        local dengji = self.dengji or 0
                        local jieduan = self.jieduan or 1
                        local ba = self.ba or 0
                        local sh =  self.sh or 0
                        local hd =  self.hd or 0
                        local kz = self.kz or 0
                        local jd_1 = self.jd_1 or 0
                        local jd_2 = self.jd_2 or 0
                        local jd_3 = self.jd_3 or 0
                        local jd_4 = self.jd_4 or 0
                        self.inst.tz_xx:set({dengji,jieduan,ba,sh,hd,kz,jd_1,jd_2,jd_3,jd_4})
                    end
                end

                local function onba(self,ba)
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
                            inst.components.health.externalabsorbmodifiers:SetModifier("tzxx", 0.005*_ba) --减伤+0.5%
                        end
                        if inst.components.eater then
                            inst.components.eater:SetAbsorptionModifiers(1+0.01*_ba, 1+0.01*_ba, 1+0.01*_ba) --食用食物回复效率+1%
                        end
                        if inst.components.hunger then
                            local hunger_percent = inst.components.hunger:GetPercent() --饥饿度上限+2  ba
                            inst.components.hunger.max = math.ceil(150 + _ba*2)
                            inst.components.hunger:SetPercent(hunger_percent)
                        end
                        onsetnet(self)
                    end
                end

                local function onsh(self,sh)
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

                local function onhd(self,hd)
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

                local function onkz(self,kz)
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
                            inst.components.combat.externaldamagemultipliers:SetModifier("tzxx", 1 + _kz*0.02)
                        end
                        onsetnet(self)
                    end
                end
                addsetter(self,"ba",onba)
                addsetter(self,"sh",onsh)
                addsetter(self,"hd",onhd)
                addsetter(self,"kz",onkz)
            end
    )
end

if taizhenMaxPill > 0 then
    AddComponentPostInit("tz_bighealth",
            function(self)
                local oldAddBuff = self.AddBuff
                function self:AddBuff()
                    if self.rate <  taizhenMaxPill then
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
