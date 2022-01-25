local _G = GLOBAL
local mythBlackBearRockClearTime = GetModConfigData("mythBlackBearRockClearTime") or 0
local mythFlyingSpeedMultiplier = GetModConfigData("mythFlyingSpeedMultiplier") or 0
local mythProtector = GetModConfigData("mythProtector") or false

if mythBlackBearRockClearTime > 0 then
    AddPrefabPostInit("blackbear_rock", function(inst)
        -- 黑熊岩石清理
        if not _G.TheWorld.ismastersim then
            return
        end
        if inst._clearTask and inst._clearTask.Cancel then
            inst._clearTask:Cancel();
            inst._clearTask = nil;
        end
        inst._clearTask = inst:DoTaskInTime(mythBlackBearRockClearTime, function(inst)
            inst:Remove()
        end)
    end)
end

if mythFlyingSpeedMultiplier > 0 then
    AddComponentPostInit("locomotor", function(self)
        local oldGetRunSpeed = self.GetRunSpeed;
        function self:GetRunSpeed(...)
            if self.inst.components.mk_flyer ~= nil and self.inst.components.mk_flyer:IsFlying() then

                local speedMultiplier = self:GetSpeedMultiplier() - 1;
                if speedMultiplier > 0 then
                    speedMultiplier = speedMultiplier * mythFlyingSpeedMultiplier + 1;
                else
                    speedMultiplier = 1;
                end
                return self.inst.components.mk_flyer.runspeed * speedMultiplier
            end
            return oldGetRunSpeed(self, ...)
        end
    end)
end

if mythProtector then
    local weapons = {
        "amy_yizhiqi1",
        "amy_yizhiqi2",
        "amy_yizhiqi3",
    }
    for k, v in pairs(weapons) do
        AddPrefabPostInit(v, function(weapon)
            inst:DoTaskInTime(.3,function ()
                -- 生长保存
                if inst.components.protector
                        and inst.components.protector.userid ~= nil
                        and inst.components.deployable == nil
                        and inst.components.inventoryitem == nil
                then
                    inst:ListenForEvent("onremove",  function()
                        tool.ReSetName(inst)
                    end)
                end
            end)
        end)
    end
end
