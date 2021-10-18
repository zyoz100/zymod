local soraRemoveDeathExpByLevel = GetModConfigData("soraRemoveDeathExpByLevel") or -1;
local soraRemoveRollExpByLevel = GetModConfigData("soraRemoveRollExpByLevel") or -1;
local soraHealDeath = GetModConfigData("soraHealDeath") or false;
local soraRepairerToPhilosopherStoneLimit = GetModConfigData("soraRepairerToPhilosopherStoneLimit") or 0;
local soraFastMaker = GetModConfigData("soraFastMaker") or false;
local soraDoubleMaker = GetModConfigData("soraDoubleMaker") or -1;
local soraRemoveExpLimit = GetModConfigData("soraRemoveExpLimit") or -1;
local soraPackLimit = GetModConfigData("soraPackLimit") or false;
local soraPackFL = GetModConfigData("soraPackFL") or false;
if soraRemoveDeathExpByLevel > 0 then
    -- 穹一定等级后死亡不掉落经验
    AddPrefabPostInit('sora', function(inst)
        if not __DeathExp and GLOBAL.DeathExp then
            __DeathExp = GLOBAL.DeathExp
            GLOBAL.DeathExp = function(a)
                if a >= soraRemoveDeathExpByLevel then
                    return 0
                end
                return __DeathExp(a)
            end
        end
    end)
end

if soraRemoveRollExpByLevel > 0 then
    -- 穹2换人不掉落经验
    AddComponentPostInit("soraexpsave",
            function(self)
                __GetExp = self.GetExp;
                function self:GetExp(userid)
                    local level = GLOBAL.exptolev(self.exps[userid] or 0);
                    local loseExp = level >= soraRemoveRollExpByLevel and 0 or 1000;
                    return userid and self.exps[userid] and math.max(0, self.exps[userid] - loseExp) or -1
                end
            end
    )
end

if soraHealDeath then
    local heal = function(inst)
        --怪物冰冻
        if inst._heal then
            local pos = inst:GetPosition()
            local entc = TheSim:FindEntities(pos.x, pos.y, pos.z, 4, nil, { "player", "sora2lm" })
            for i, v in ipairs(entc) do
                if v:IsValid() and v.entity:IsVisible() and not v:IsInLimbo() and v.components.health and v.components.health:IsDead() then
                    v.components.health:DoDelta(30)
                end
            end
        end
    end

    -- 穹愈可以治疗死人
    AddPrefabPostInit("sorahealstar", function(inst)
        local oldStart = inst.Start;
        inst.Start = function(inst, ...)
            oldStart(inst, ...)
            inst:DoPeriodicTask(0.5, heal)
        end
    end)
end

if soraRepairerToPhilosopherStoneLimit > 0 then
    --缝纫包
    AddComponentPostInit("sorarepairer",
            function(self)
                local oldDoRepair = self.DoRepair;
                function self:DoRepair(inst, target, doer)
                    if target.prefab == "philosopherstone" then
                        target.components.finiteuses:Use(-1 * math.max(math.ceil(soraRepairerToPhilosopherStoneLimit * target.components.finiteuses.total), 5))
                        doer:PushEvent("sorarepair", { inst = inst, target = target, doer = doer, type = "finiteuses" })
                        return true;
                    else
                        return oldDoRepair(self, inst, target, doer)
                    end
                end
            end
    )
end

if soraFastMaker then
    --快速制作
    AddStategraphPostInit("wilson", function(sg)
        local state_domediumaction = sg.states["domediumaction"]
        state_domediumaction.onenter = function(inst)
            local isSora = inst:HasTag("sora");
            local isEquipSora2amulet = inst.soratasgs and not isSora; --使用飞云术
            local isEquipHandyCertificate = inst.components.inventory
                    and inst.components.inventory.EquipMedalWithName
                    and inst.components.inventory:EquipMedalWithName("handy_certificate")
            local soraLevel = 0;
            local timeout = .5
            if isSora and isEquipHandyCertificate and inst.soralevel ~= nil then
                soraLevel = inst.soralevel:value();
                if soraLevel > 29 then
                    timeout = 2 *  GLOBAL.FRAMES
                else
                    timeout = 5 *  GLOBAL.FRAMES
                end
            elseif isEquipSora2amulet and isEquipHandyCertificate then
                timeout = 10 *  GLOBAL.FRAMES
            end
            inst.sg:GoToState("dolongaction", timeout)
        end
    end)
end

if soraDoubleMaker > 0 then
    local function GiveOrDropItem(inst, recipe, item, pt)
        if recipe.dropitem then
            local angle = (inst.Transform:GetRotation() + GLOBAL.GetRandomMinMax(-65, 65)) * GLOBAL.DEGREES
            local r = item:GetPhysicsRadius(0.5) +inst:GetPhysicsRadius(0.5) + 0.1
            item.Transform:SetPosition(pt.x + r * math.cos(angle), pt.y, pt.z - r * math.sin(angle))
            item.components.inventoryitem:OnDropped()
        else
            inst.components.inventory:GiveItem(item, nil, pt)
        end
    end
    -- 30级双倍制作
    local function onbuilditem(inst, data)
        if inst:HasTag("sora") and inst.soralevel:value() >= soraDoubleMaker then
            local recipe = data.recipe;
            local skin = data.skin;
            local prod = GLOBAL.SpawnPrefab(recipe.product, recipe.chooseskin or skin, nil, inst.userid) or nil;
            if prod ~= nil then
                local pt = inst:GetPosition()
                if prod.components.inventoryitem ~= nil then
                    if inst.components.inventory ~= nil then
                        if recipe.numtogive <= 1 then
                            GiveOrDropItem(inst, recipe, prod, pt)
                        elseif prod.components.stackable ~= nil then
                            --The item is stackable. Just increase the stack size of the original item.
                            prod.components.stackable:SetStackSize(recipe.numtogive)
                            GiveOrDropItem(inst, recipe, prod, pt)
                        else
                            GiveOrDropItem(inst, recipe, prod, pt)
                            for i = 1, recipe.numtogive do
                                local addt_prod = GLOBAL.SpawnPrefab(recipe.product)
                                GiveOrDropItem(inst, recipe, addt_prod, pt)
                            end
                        end
                    end
                end
            end
        end
    end

    AddPrefabPostInit("sora", function(inst)
        inst:ListenForEvent("builditem", onbuilditem)
    end)
end

if soraRemoveExpLimit > 0 then
    --当前穹上限为120
    local originalExpMax = 120;
    --根据选项给出一个等价的初始判断值
    local getInitExp = function(isOut)
        return originalExpMax - (isOut and soraRemoveExpLimit * 0.5 or soraRemoveExpLimit);
    end

    local limit = {
        kill=50,
        attack=50,
        emote=20,
    }
    AddPrefabPostInit("sora", function(inst)
        inst.FixExpVersion = 1
        inst:WatchWorldState("startday", function()
            local t = GLOBAL.TheWorld.state.cycles
            local olddayexp = inst.soradayexp or {}-- getexppatch
            inst.soradayexp = {}
            for k, v in pairs(olddayexp) do
                local maxexp = limit[k] or soraRemoveExpLimit
                if k and v and v >= (maxexp) then
                    inst.soradayexp[k] = getInitExp(true)
                else
                    inst.soradayexp[k] = getInitExp(false)
                end
            end
            inst.soraday = t
        end)
    end)
end

if soraPackLimit then
    local packPostInit = function(inst)
        if inst and inst.components and inst.components.sorapacker then
            local oldCanPackFn = inst.components.sorapacker.canpackfn
            inst.components.sorapacker:SetCanPackFn(function(target, inst2)
                if target:HasTag("multiplayer_portal") --天体门
                    or target.prefab == "pigking" --猪王
                    or target.prefab == "beequeenhivegrown"--蜂王窝-底座
                    or target.prefab == "statueglommer"--格罗姆雕像
                    or target.prefab == "oasislake"--绿洲

                    or target.prefab == "elecourmaline"--电器台
                    or target.prefab == "elecourmaline_keystone" --

                    or target.prefab == "myth_rhino_desk"--电器台
                then
                    return false;
                else
                    return oldCanPackFn(target, inst2);
                end
            end)
        end
    end
    AddPrefabPostInit("sorapacker", packPostInit)
end

if soraPackFL then
    AddComponentPostInit("sorafl", function(self)
        local oldInit = self.Init;
        function self:Init()
            if not self.has  then
                local fl = GLOBAL.SpawnPrefab("sora_fl")
                fl.components.sorabind:Bind(self.inst.userid)
                local pack = GLOBAL.SpawnPrefab("sorapacker")
                local valid = false;
                if pack and pack.components.sorapacker:Pack(fl,self.inst,true) then
                    self.inst.components.inventory:GiveItem(pack)
                    valid = true
                end
                if valid then
                    self.has = true
                    return fl
                else
                    if fl and fl.Remove then
                        fl:Remove()
                    end
                    if pack and pack.Remove then
                        pack:Remove()
                    end
                    return oldInit(self)
                end
            end
        end
    end)
end







