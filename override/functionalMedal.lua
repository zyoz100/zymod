local _G = GLOBAL
local monsterBookChessPieceNotRemove = GetModConfigData("monsterBookChessPieceNotRemove") or false;

if monsterBookChessPieceNotRemove then
    AddSimPostInit(function()
        if GLOBAL.Prefabs.monster_book then
            local def = up.Get(GLOBAL.Prefabs.monster_book.fn, "def")

            if def then
                local doSacrifice = up.Get(def.readfn, "doSacrifice")
                local spawnFX = up.Get(doSacrifice, "spawnFX")
                local GetMedalRandomItem = up.Get(doSacrifice, "GetMedalRandomItem") or _G.GetMedalRandomItem
                up.Set(def.readfn, "doSacrifice", function(inst, player, itemlist, summonedlist)
                    local chance_list = _G.deepcopy(summonedlist)--权重统计表
                    local weight_add_list = {}--权重加成表
                    --获取玩家坐标并对周围献祭品进行统计
                    local x, y, z = player.Transform:GetWorldPosition()
                    local ents = _G.TheSim:FindEntities(x, y, z, _G.TUNING_MEDAL.BOOK_SACRIFICE_RADIUS, nil, { "INLIMBO", "player" })
                    --显示范围圈
                    if #ents > 0 then
                        for i, v in ipairs(ents) do
                            --如果献祭品列表里有对应献祭品，则对权重进行增值
                            if itemlist[v.prefab] then
                                --部分物品不能在洞穴里献祭
                                if not (itemlist[v.prefab].nocave and _G.TheWorld and _G.TheWorld:HasTag("cave")) then
                                    --需要有特定标签才能献祭
                                    if not itemlist[v.prefab].notag or not v:HasTag(itemlist[v.prefab].notag) then
                                        local itemnum = v.components.stackable and v.components.stackable:StackSize() or 1--献祭品数量
                                        local consumenum = itemnum--祭品需消耗数量
                                        --权重增值登记
                                        if weight_add_list[itemlist[v.prefab].key] then
                                            if itemlist[v.prefab].maxnum then
                                                consumenum = math.min(itemnum, itemlist[v.prefab].maxnum - weight_add_list[itemlist[v.prefab].key].num)
                                            end
                                            if consumenum > 0 then
                                                weight_add_list[itemlist[v.prefab].key].num = weight_add_list[itemlist[v.prefab].key].num + consumenum
                                                weight_add_list[itemlist[v.prefab].key].weight = weight_add_list[itemlist[v.prefab].key].weight + itemlist[v.prefab].chance * consumenum
                                            end
                                        else
                                            if itemlist[v.prefab].maxnum then
                                                consumenum = math.min(itemnum, itemlist[v.prefab].maxnum)
                                            end
                                            weight_add_list[itemlist[v.prefab].key] = {
                                                num = consumenum,
                                                weight = itemlist[v.prefab].chance * consumenum
                                            }
                                        end

                                        if consumenum > 0 then
                                            --播放献祭动画
                                            if itemlist[v.prefab].fx then
                                                spawnFX(itemlist[v.prefab].fx, v)
                                            end
                                            --移除献祭品
                                            if v.components.stackable then
                                                v.components.stackable:Get(consumenum):Remove()
                                            else
                                                --v:Remove()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    --权重增值
                    for k, v in ipairs(chance_list) do
                        if weight_add_list[v.key] then
                            v.weight = v.weight + weight_add_list[v.key].weight
                        end
                    end
                    return GetMedalRandomItem(chance_list, inst.medal_destiny_num)--返回权重增值后的随机ke
                end)
            end
        end
    end)
end