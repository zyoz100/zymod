local zyWeapon = Class(function(self, inst)
    self.inst = inst
    self.original_name = STRINGS.NAMES[string.upper(self.inst.prefab)] or self.inst.name
    self.exp = 0
    self.level = 0
    self.max_level = -1

    self.inst:AddTag("zy_weapon")

    if not self.inst.components.named then
        -----------用named组件来显示附魔
        self.inst:AddComponent("named")
    end
end)

function zyWeapon:SetExp(exp)
    local level = self:GetLevel();
    self.exp = math.clamp(tonumber(exp) or 0, 0, self:GetLevelExp(level));
end

function zyWeapon:GetExp()
    return self.exp
end

function zyWeapon:SetLevel(level)
    local max_level = self:GetMaxLevel();
    if max_level > 0 then
        self.level = math.clamp(tonumber(level) or 0, 0, max_level);
    else
        self.level = math.max(tonumber(level) or 0, 0);
    end
end

function zyWeapon:GetLevel()
    return self.level
end

function zyWeapon:SetMaxLevel(max_level)
    self.max_level = math.max(tonumber(max_level) or -1, -1);
end

function zyWeapon:GetMaxLevel()
    return self.max_level
end

function zyWeapon:GetLevelExp(level)
    local _level = level;
    local max_level = self:GetMaxLevel();
    if _level == nil then
        _level = self:GetLevel()
    end
    if _level >= max_level then
        return 0;
    else
        return (_level + 1) * 1000
    end

end

function zyWeapon:DoDeltaExp(value)
    local level = self:GetLevel()
    local max_level = self:GetMaxLevel()
    if max_level < 0 and level >= max_level then
        self:SetLevel(max_level)
        self:SetExp(0);
    else
        local exp = self:GetExp() + value;
        while true do
            if exp > self:GetLevelExp(level) then
                if level < max_level then
                    level = level + 1;
                    exp = exp - self:GetLevelExp(level)
                else
                    level = max_level;
                    exp = 0;
                end
            elseif exp < 0 then
                if level > 0 then
                    level = level - 1;
                    exp = exp + self:GetLevelExp(level)
                else
                    level = 0;
                    exp = 0;
                end
            else
                break ;
            end
        end
        self:SetLevel(level);
        self:SetExp(exp);
    end
    self:update();
end

function zyWeapon:update()

end

return zyWeapon