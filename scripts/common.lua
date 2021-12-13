local createItems = function(name,num)
    local res;
    if GLOBAL.PrefabExists(name) then
        res = {};
        local item = GLOBAL.SpawnPrefab(name)
        local maxStackSize = 1;
        if item.components and item.components.stackable then
            maxStackSize = item.components.stackable.maxsize or 1
        end
        local totalStackSize = (GLOBAL.tonumber(num) or 1)
        while totalStackSize > 0 do
            local s = math.min(totalStackSize,maxStackSize);
            if  item.components.stackable then
                item.components.stackable:SetStackSize(s)
            end
            table.insert(res,item)
            totalStackSize = totalStackSize-s;
        end
    end
    return res;
end
return {
    createItems = createItems
}