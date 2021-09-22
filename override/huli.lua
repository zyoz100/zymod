local _G = GLOBAL;
local huliShopFix = GetModConfigData("huliShopFix") or true;
if huliShopFix then
    local namespace = "huli_rpc";
    local namespace2 = "huli_storeRPC";
    local oldSpawnRechargeNPC = _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["SpawnRechargeNPC"].id];
    _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["SpawnRechargeNPC"].id] = function(...)
        if GLOBAL.HULI_STORE_SET > 0 then
            return
        end
        oldSpawnRechargeNPC(...)
    end

    local oldItemBuyFn = _G.MOD_RPC_HANDLERS[namespace2][_G.MOD_RPC[namespace2]["ItemBuyFn"].id];
    _G.MOD_RPC_HANDLERS[namespace2][_G.MOD_RPC[namespace2]["ItemBuyFn"].id] = function(...)
        if GLOBAL.HULI_STORE_SET > 0 then
            return
        end
        oldItemBuyFn(...)
    end


    local oldLuckDrawFn = _G.MOD_RPC_HANDLERS[namespace2][_G.MOD_RPC[namespace2]["LuckDrawFn"].id];
    _G.MOD_RPC_HANDLERS[namespace2][_G.MOD_RPC[namespace2]["LuckDrawFn"].id] = function(...)
        if GLOBAL.HULI_STORE_SET > 0 then
            return
        end
        oldLuckDrawFn(...)
    end
end
