local _G = GLOBAL
local chogathSkillOneGetMoreSoul = GetModConfigData("chogathSkillOneGetMoreSoul") or 0;
local chogathSkillOneCDImprove = GetModConfigData("chogathSkillOneCDImprove") or 1;
local chogathSkillOneDamageImprove = GetModConfigData("chogathSkillOneDamageImprove") or false;

if chogathSkillOneCDImprove < 1 or chogathSkillOneGetMoreSoul > 0 or chogathSkillOneDamageImprove then

    local namespace = "workshop-2245132201"

    local function launchitem(item, angle)
        local speed = math.random() * 4 + 2
        angle = (angle + math.random() * 300 - 30) * _G.DEGREES
        item.Physics:SetVel(speed * math.cos(angle), math.random() * 2 + 8, speed * math.sin(angle))
    end
    local function OnKilledOther(inst, victim)
        if victim and victim.components.lootdropper then

            victim.components.lootdropper.DropLoot = function(self, pt)
            end

            if victim and victim.components.health then
                --把血量大于等于2000的都归为boss吧
                local maxHealth = victim.components.health.maxhealth;
                if chogathSkillOneGetMoreSoul > 0 then
                    local healthRate = math.max(math.sqrt(maxHealth, 2) / chogathSkillOneGetMoreSoul, 1)
                    inst.level = inst.level + healthRate
                else
                    if maxHealth >= 2000 then
                        inst.level = inst.level + 5
                    else
                        inst.level = inst.level + 1
                    end
                end

            end
            if not victim:HasTag("structure") and victim.prefab ~= "lureplant" and victim.prefab ~= "mushgnome" then
                local x, y, z = victim.Transform:GetWorldPosition()

                local loots = victim.components.lootdropper:GenerateLoot()
                local item = nil
                for k, v in pairs(loots) do
                    if v ~= nil then
                        item = _G.SpawnPrefab(v)
                    end

                    if item ~= nil and not (victim.prefab == "klaus" and not victim:IsUnchained()) then
                        --吞掉第一个形态的克劳斯不会有掉落物
                        item.Transform:SetPosition(x, 3.5, z)
                        launchitem(item, 180 - inst:GetAngleToPoint(x, 0, z))
                    end
                end
                if victim and victim.prefab and victim.prefab ~= "klaus" and victim.prefab ~= "mushgnome" then
                    if victim.Transform then
                        victim.Transform:SetScale(0, 0, 0)
                    end
                    if victim.DynamicShadow then
                        victim.DynamicShadow:Enable(false)
                    end
                end
            end
        end
    end
    _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["Skill_One"].id] = function(inst, target)
        if inst.SkillOneUse and target then
            local basemultiplier = inst.components.combat.damagemultiplier or 1;
            local externaldamagemultipliers = 1;
            if chogathSkillOneDamageImprove and inst.components.combat and inst.components.combat.externaldamagemultipliers then
                externaldamagemultipliers = inst.components.combat.externaldamagemultipliers:Get() or 1;
            end
            local damageNum = (100 + inst.level * 20) * externaldamagemultipliers * basemultiplier --伤害计算 100+层数*20 *攻击倍率
            inst.sg:GoToState("chogath_eat")
            inst.SkillOneUse = false
            inst._canuseskill1:set(false)

            local fx = _G.SpawnPrefab("redpouch_yotc_unwrap")  --红色花瓣特效，类似于血肉横飞的效果
            fx.Transform:SetScale(2, 2, 2)  --特效放大
            fx.Transform:SetPosition(target.Transform:GetWorldPosition())

            target.components.health:DoDelta(-damageNum, nil, (inst.nameoverride or inst.prefab), true, inst, true)  --直接强制扣血，无视防御
            target:PushEvent("attacked", { attacker = inst, damage = damageNum, weapon = nil })

            inst:PushEvent("onhitother", { target = target, damage = damageNum, damageresolved = damageNum, weapon = nil })  --人物发出攻击事件

            if target.components.health:IsDead() then
                --如果目标正好死亡的话
                inst.components.timer:StartTimer("skillone", _G.TUNING.R_COOLING)
                inst:PushEvent("killed", { victim = target }) --人物发出击杀事件

                -- local fx2 = SpawnPrefab("halloween_moonpuff")
                local fx2 = _G.SpawnPrefab("round_puff_fx_lg")  --其他组织爆炸的效果
                fx2.Transform:SetPosition(target.Transform:GetWorldPosition())

                OnKilledOther(inst, target)
                inst:levelup(inst) --执行人物相关函数,全部写在Modmain里有点乱,所以这里放在人物prefab里面处理
            else
                inst.components.timer:StartTimer("skillone", _G.TUNING.R_COOLING * chogathSkillOneCDImprove)
            end
        end
    end
end