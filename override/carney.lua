local carneyUseSetGold = GetModConfigData("carneyUseSetGold")
local carneyWindyKnifeMaxDamage = GetModConfigData("carneyWindyKnifeMaxDamage")
local carneyGoldPerDamage = GetModConfigData("carneyGoldPerDamage");
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
        local damage = wkBaseDamage + math.floor(level/carneyGoldPerDamage);
        if carneyWindyKnifeMaxDamage >0  then
            damage = math.min(carneyWindyKnifeMaxDamage,damage);
        end
        inst.components.weapon:SetDamage(damage)

        if inst.components.finiteuses then
            inst.components.finiteuses:SetMaxUses(200+level*5)
        end

        local m = math.ceil(15-level/100*15)
        if m <= 1 then m = 1 end
        inst.components.tool:SetAction(GLOBAL.ACTIONS.CHOP, 15/m)
        if carneyWindyKnifeMaxDamage and carneyWindyKnifeMaxDamage>0  then
            if inst.components.windyknifestatus.level >= (carneyWindyKnifeMaxDamage - wkBaseDamage) * carneyGoldPerDamage  and inst.components.finiteuses then
                inst.components.finiteuses.current = inst.components.finiteuses.total
                inst:RemoveComponent("finiteuses")
                inst:RemoveComponent("trader")
            end
        end
    end

    local function repair(inst,percent)
        if inst.components.finiteuses then
            local repair = inst.components.finiteuses.current/inst.components.finiteuses.total + percent/100;
            if repair >= 1 then repair = 1 end
            inst.components.finiteuses:SetUses(math.floor(repair*inst.components.finiteuses.total))
            inst.components.windyknifestatus.use = inst.components.finiteuses.current
        end
    end

    local function OnGemGiven(inst, giver, item)
        if item ~=nil and item.prefab then
            local stacksize = 1;
            if item.components.stackable then
                stacksize = math.max(item.components.stackable.stacksize,1)
            end
            local level = 0;
            level = stacksize
            inst.components.windyknifestatus:DoDeltaLevel(level * 10);
            inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace");
            valuecheck(inst);
            repair(inst,stacksize * 20)
        end
    end
    up.Set(Prefabs.windyknife.fn, "valuecheck", valuecheck, 'windyknife.lua')
    AddPrefabPostInit("windyknife", function(inst)
        inst.cantrader = TraderCount
        inst.components.trader:SetAcceptTest(ItemTradeTest)
        inst.components.trader.onaccept = OnGemGiven
    end)

end
