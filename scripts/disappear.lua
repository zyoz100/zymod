local CreateDisappearFn = function(disappearTime)
    local _disappearTime = tonumber(disappearTime) or 60;
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
return CreateDisappearFn