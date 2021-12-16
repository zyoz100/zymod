local _G = GLOBAL
up = require("util/upvaluehelper")
CreateDisappearFn = function(disappearTime)
    local _disappearTime = _G.tonumber(disappearTime) or 60;
    local CancelDisappear = function(inst)
        if inst._disappear then
            inst._disappear:Cancel()
        end
        if inst._disappear_anim then
            inst._disappear_anim:Cancel()
        end
        inst._disappear = nil;
        inst._disappear_anim = nil;
        inst.AnimState:SetMultColour(1, 1, 1, 1)
    end
    return function(loot)
        loot:ListenForEvent("onpickup", function()
            CancelDisappear(loot)
        end)
        loot:ListenForEvent("onputininventory", function()
            CancelDisappear(loot)
        end)
        loot._disappear = loot:DoTaskInTime(_disappearTime, function()
            if loot:IsValid() and loot.components.inventoryitem and not loot.components.inventoryitem:GetContainer() then
                loot:Remove()
            end
        end)
        loot._disappear_anim = loot:DoTaskInTime(math.max(_disappearTime - 40, 0), function()
            for j = 1, 30, 2 do
                for i = 10, 3, -1 do
                    loot:DoTaskInTime(j - i / 10, function()
                        loot.AnimState:SetMultColour(i / 10, i / 10, i / 10, i / 10)
                    end)
                    loot:DoTaskInTime(j + i / 10, function()
                        loot.AnimState:SetMultColour(i / 10, i / 10, i / 10, i / 10)
                    end)
                end
            end
            for i = 10, 3, -1 do
                loot:DoTaskInTime(31 - i / 10, function()
                    loot.AnimState:SetMultColour(i / 10, i / 10, i / 10, i / 10)
                end)
            end
        end)
    end
end
local createItems = function(name,num)
    local res;
    if _G.PrefabExists(name) then
        res = {};
        local item = _G.SpawnPrefab(name)
        local maxStackSize = 1;
        if item.components and item.components.stackable then
            maxStackSize = item.components.stackable.maxsize or 1
        end
        local totalStackSize = (_G.tonumber(num) or 1)
        while totalStackSize > 0 do
            if not item then
                item = _G.SpawnPrefab(name)
            end
            local s = math.min(totalStackSize,maxStackSize);
            if  item.components.stackable then
                item.components.stackable:SetStackSize(s)
            end
            table.insert(res,item)
            totalStackSize = totalStackSize-s;
            item = nil;
        end
    end
    return res;
end
commonHandle = {
    createItems = createItems
}
--util
modimport("scripts/util/util")

--原版修正
modimport("override/base")

--修正一些奇奇怪怪的问题
modimport("override/bugFix")

--神话 myth
if _G.isModEnableById("1991746508") then
    modimport("override/myth")
end

--成就商店
if _G.isModEnableById("2121078176") then
    modimport("override/achievementAndShop")
end

--托托莉
if _G.isModEnableById("899583698") then
    modimport("override/totooria")
end

--虚空假面
if _G.isModEnableById("2245132201") then
    modimport("override/chogath")
end

--狗头
if _G.isModEnableById("2002991372") then
    modimport("override/dogHead")
end

--小穹
if _G.isModEnableById("1638724235") then
    modimport("override/sora")
end

--卡尼猫
if _G.isModEnableById("949808360") then
    modimport("override/carney")
end

--太真
if _G.isModEnableById("2066838067") then
    modimport("override/taizhen")
end

--狐狸
if _G.isModEnableById("1694540893")
        or _G.isModEnableById("2259379465")
        or _G.isModEnableById("2215151821") then
    modimport("override/huli")
end

--怠惰科技
if _G.isModEnableById("2347908689") then
    modimport("override/lazyTechnology")
end

if _G.isModEnableById("2019613520") then
    modimport("override/randomSized")
end

if _G.isModEnableById("2299268435") then
    modimport("override/randomSizedData")
end

--legion
if _G.isModEnableById("1392778117") then
    modimport("override/legion")
end

--yuanzi
if _G.isModEnableById("1645013096") then
    modimport("override/yuanzi")
end

--yuanzi
if _G.isModEnableById("1892210190") then
    modimport("override/amiya")
end

--seele
if _G.isModEnableById("1757943227") then
    modimport("override/seele")
end

--shop
if _G.isModEnableById("2467471767") then
    modimport("override/shop")
end

--functional medal
if _G.isModEnableById("1909182187") then
    modimport("override/functionalMedal")
end




