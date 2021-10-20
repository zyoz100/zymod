local _G = GLOBAL;
local flyknifeGiveNum = GetModConfigData("flyknifeGiveNum") or 0;
if flyknifeGiveNum > 0 then
    if _G.AllRecipes["yuanzi_flyknife"] then
        _G.AllRecipes["yuanzi_flyknife"].numtogive = flyknifeGiveNum
    end
end
