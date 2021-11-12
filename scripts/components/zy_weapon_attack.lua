local zyWeapon = require "components/zy_weapon";

local zyWeaponAttack = Class(zyWeapon, function(self, inst)
    zyWeapon._ctor(self, inst)
    self.baseDamage = 10;
    self.damageRatePerLevel = 0.4;
    if self.inst.components.weapon then
        ----------修改OnAttack以方便监听
        local oldOnAttack = self.inst.components.weapon.OnAttack
        self.inst.components.weapon.OnAttack = function(weapon, attacker, target, projectile)
            oldOnAttack(weapon, attacker, target, projectile)
            weapon:PushEvent("onattack:zyWeapon", { attacker = attacker, target = target, projectile = projectile })
        end
        self.inst:ListenForEvent("onattack:zyWeapon", function()
            self:DoDeltaExp(1)
        end)
        self.baseDamage = self.inst.components.weapon:GetDamage();
    end
    self:update();
end)

function zyWeaponAttack:SetDamageRatePerLevel(value)
    self.damageRatePerLevel = math.max(tonumber(value) or 0, 0);
end

function zyWeaponAttack:update()
    local level = self:GetLevel();
    local exp = self:GetExp();
    local levelExp = self:GetLevelExp();
    if self.inst.components.weapon then
        self.inst.components.weapon:SetDamage((level * self.damageRatePerLevel + 1) * self.baseDamage)
    end
    if self.inst.components.named then
        self.inst.components.named:SetName(string.format(
                "%s\n等级：%d (%d/%d)\n攻击力提高：%d%%",
                self.original_name,
                level,
                exp,
                levelExp,
                math.ceil(level * self.damageRatePerLevel  * 100)
        ))
    end
end

return zyWeaponAttack