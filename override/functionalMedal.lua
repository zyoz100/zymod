local _G = GLOBAL
local monsterBookChessPieceNotRemove = GetModConfigData("monsterBookChessPieceNotRemove") or false;

if monsterBookChessPieceNotRemove then
    AddSimPostInit(function()
        if GLOBAL.Prefabs.monster_book then
            local def = up.Get(GLOBAL.Prefabs.monster_book.fn, "def")
            if def then
                local spawnFX = up.Get(def.readfn, "spawnFX","medal_fx_defs.lua")
                up.Set(def.readfn, "doSacrifice", function(player, itemlist, summonedlist)
                    local chance_list = {}--权重统计表
                    --记录召唤物表初始权重
                    for k, v in pairs(summonedlist) do
                        chance_list[k] = type(v) == "table" and v.chance or v
                    end
                    --获取玩家坐标并对周围献祭品进行统计
                    local x, y, z = player.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x, y, z, _G.TUNING_MEDAL.MONSTER_BOOK_RADIUS, nil, { "INLIMBO", "player" })
                    --显示范围圈
                    if #ents > 0 then
                        for i, v in ipairs(ents) do
                            --如果献祭品列表里有对应献祭品，则对权重进行增值
                            if itemlist[v.prefab] then
                                --部分物品不能在洞穴里献祭
                                if not (itemlist[v.prefab].nocave and _G.TheWorld and _G.TheWorld:HasTag("cave")) then
                                    --需要有特定标签才能献祭
                                    if not itemlist[v.prefab].notag or not v:HasTag(itemlist[v.prefab].notag) then
                                        local maxchance = itemlist[v.prefab].maxchance or math.huge--最大权重
                                        local itemnum = 1--献祭品数量
                                        if v.components.stackable then
                                            itemnum = v.components.stackable:StackSize()
                                        end
                                        --权重增值
                                        if chance_list[itemlist[v.prefab].key] < maxchance then
                                            chance_list[itemlist[v.prefab].key] = math.min(chance_list[itemlist[v.prefab].key] + itemlist[v.prefab].chance * itemnum, maxchance)
                                            --播放献祭动画
                                            if itemlist[v.prefab].fx then
                                                spawnFX(itemlist[v.prefab].fx, v)
                                            end
                                            --移除献祭品
                                            --v:Remove() --不再移除
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return _G.weighted_random_choice(chance_list)--返回权重增值后的随机key
                end)
            end
        end
    end)
end