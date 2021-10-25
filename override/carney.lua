local carneyUseSetGold = GetModConfigData("carneyUseSetGold") or false;
local carneyWindyKnifeMaxDamage = GetModConfigData("carneyWindyKnifeMaxDamage") or 90;
local carneyGoldPerDamage = GetModConfigData("carneyGoldPerDamage") or 5;
local carneyIaido = GetModConfigData("carneyIaido") or 0;
local carneyIaidoRemove = GetModConfigData("carneyIaidoRemove") or 0;
local wkBaseDamage = 27;
if carneyUseSetGold then
    --交易组件相关（穹妹的升级/修复支持一次一组）
    AddComponentPostInit("trader", function(Trader)
        local oldAcceptGift = Trader.AcceptGift
        function Trader:AcceptGift(giver, item, count)
            if self.inst:HasTag("windyknife") and item.components.stackable and count == nil then
                if self.inst.cantrader then
                    count = self.inst:cantrader(giver, item)
                else
                    count = item.components.stackable.stacksize
                end
                if count < 1 then
                    count = 1
                end
            end
            return oldAcceptGift(self, giver, item, count)
        end
    end)

    local function ItemTradeTest(inst, item)
        if item == nil then
            return false
        elseif item.prefab ~= "goldnugget" then
            return false
        end
        return true
    end

    local function TraderCount(inst, giver, item)
        local levelUpCost = 9999;
        local repairCost = math.ceil((1 - inst.components.finiteuses.current / inst.components.finiteuses.total) * 100 / 20);
        if carneyWindyKnifeMaxDamage and carneyWindyKnifeMaxDamage > 0 then
            return math.ceil(((carneyWindyKnifeMaxDamage - wkBaseDamage) * carneyGoldPerDamage - inst.components.windyknifestatus.level))
        else
            return 9999
        end
        if item.prefab == "goldnugget" then
            return math.max(levelUpCost, repairCost);
        end
        return 1
    end

    local function valuecheck(inst)
        local level = inst.components.windyknifestatus.level
        local damage = wkBaseDamage + math.floor(level / carneyGoldPerDamage);
        if carneyWindyKnifeMaxDamage > 0 then
            damage = math.min(carneyWindyKnifeMaxDamage, damage);
        end
        inst.components.weapon:SetDamage(damage)

        if inst.components.finiteuses then
            inst.components.finiteuses:SetMaxUses(200 + level * 5)
        end

        local m = math.ceil(15 - level / 100 * 15)
        if m <= 1 then
            m = 1
        end
        inst.components.tool:SetAction(GLOBAL.ACTIONS.CHOP, 15 / m)
        if carneyWindyKnifeMaxDamage and carneyWindyKnifeMaxDamage > 0 then
            if inst.components.windyknifestatus.level >= (carneyWindyKnifeMaxDamage - wkBaseDamage) * carneyGoldPerDamage and inst.components.finiteuses then
                inst.components.finiteuses.current = inst.components.finiteuses.total
                inst:RemoveComponent("finiteuses")
                inst:RemoveComponent("trader")
            end
        end
    end

    local function repair(inst, percent)
        if inst.components.finiteuses then
            local repair = inst.components.finiteuses.current / inst.components.finiteuses.total + percent / 100;
            if repair >= 1 then
                repair = 1
            end
            inst.components.finiteuses:SetUses(math.floor(repair * inst.components.finiteuses.total))
            inst.components.windyknifestatus.use = inst.components.finiteuses.current
        end
    end

    local function OnGemGiven(inst, giver, item)
        if item ~= nil and item.prefab then
            local stacksize = 1;
            if item.components.stackable then
                stacksize = math.max(item.components.stackable.stacksize, 1)
            end
            local level = 0;
            level = stacksize
            inst.components.windyknifestatus:DoDeltaLevel(level * 10);
            inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace");
            valuecheck(inst);
            repair(inst, stacksize * 20)
        end
    end
    up.Set(Prefabs.windyknife.fn, "valuecheck", valuecheck, 'windyknife.lua')
    AddPrefabPostInit("windyknife", function(inst)
        inst.cantrader = TraderCount
        inst.components.trader:SetAcceptTest(ItemTradeTest)
        inst.components.trader.onaccept = OnGemGiven
    end)

end
if carneyIaido > 0 then
    AddComponentPostInit("carneystatus", function(com)
        com.Iaido = 0;
        local oldOnSave = com.OnSave
        function com:OnSave(...)
            local data = oldOnSave(self, ...)
            data.Iaido = self.Iaido or 0;
            return data;
        end

        local oldOnLoad = com.OnLoad
        function com:OnLoad(data, ...)
            local result = oldOnLoad(self, data, ...)
            self.Iaido = data.Iaido or 0;
            self:DoDeltaIaido(0);
            return result;
        end

        function com:DoDeltaIaido(value)
            local amount = self.Iaido + (value or 0);
            if amount < 0 then
                amount = 0;
            end
            self.Iaido = amount;
            if self.inst and self.inst.components and self.inst.component.combat then
                self.inst.components.combat.externaldamagemultipliers:SetModifier("carneyIaido", 1 + amount * carneyIaido)
            end
            return amount;
        end
    end)
    AddPrefabPostInit("carney", function(inst)
        local oldAttacked = inst.components.combat.GetAttacked;
        function inst.components.combat:GetAttacked(...)
            if self.components
                    and self.components.carneystatus
                    and self.components.carneystatus.miss == 1 then
                self.components.carneystatus:DoDeltaIaido(1);
            end
            return oldAttacked(self, ...)
        end

        inst:ListenForEvent("attacked", function(player, data)
            if player.components ~= nil
                    and player.components.health ~= nil
                    and not player.components.health:IsDead() then
                if carneyIaidoRemove > 0 then
                    self.components.carneystatus:DoDeltaIaido(-carneyIaidoRemove);
                else
                    self.components.carneystatus:DoDeltaIaido(-self.components.carneystatus.Iaido or 0);
                end
            end
        end)

        local namespace = "workshop-949808360"
        if Global.MOD_RPC_HANDLERS[namespace]
                and Global.MOD_RPC[namespace]
                and Global.MOD_RPC[namespace]["Check"]
                and Global.MOD_RPC[namespace]["Check"].id
                and Global.MOD_RPC_HANDLERS[namespace][Global.MOD_RPC[namespace]["Check"].id] then
            Global.MOD_RPC_HANDLERS[namespace][Global.MOD_RPC[namespace]["Check"].id] = function(player)
                if not player:HasTag("playerghost") and player.components.carneystatus then
                    local msg = string.format(
                            "等级：%d 经验：(%d/%d)\n 闪避加成：%d%",
                            player.components.carneystatus.level or 0,
                            math.floor(player.components.carneystatus.exp or 0),
                            player.components.carneystatus.maxexp,
                            (player.components.carneystatus.Iaido or 0) * carneyIaido * 100
                    )
                    player.components.talker:Say(msg)
                end
            end
        end
    end)
end
