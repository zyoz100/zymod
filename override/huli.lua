local _G = GLOBAL;
local huliShopFix = GetModConfigData("huliShopFix") or true;
local getHuliStoreSet = function()
    return ( GLOBAL.HULI_STORE_SET == 0)
            or (GLOBAL.HULI_STORE_SET == "开启")
end
if huliShopFix and not getHuliStoreSet() then
    local namespace = "huli_rpc";
    local namespace2 = "huli_storeRPC";
    local oldSpawnRechargeNPC = _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["SpawnRechargeNPC"].id];
    _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["SpawnRechargeNPC"].id] = function(...)
        if getHuliStoreSet() then
            oldSpawnRechargeNPC(...)
        end
    end

    local oldItemBuyFn = _G.MOD_RPC_HANDLERS[namespace2][_G.MOD_RPC[namespace2]["ItemBuyFn"].id];
    _G.MOD_RPC_HANDLERS[namespace2][_G.MOD_RPC[namespace2]["ItemBuyFn"].id] = function(...)
        if getHuliStoreSet() then
            oldItemBuyFn(...)
        end
    end


    local oldLuckDrawFn = _G.MOD_RPC_HANDLERS[namespace2][_G.MOD_RPC[namespace2]["LuckDrawFn"].id];
    _G.MOD_RPC_HANDLERS[namespace2][_G.MOD_RPC[namespace2]["LuckDrawFn"].id] = function(...)
        if getHuliStoreSet() then
            oldLuckDrawFn(...)
        end
    end
end
