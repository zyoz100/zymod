local achievementAllReward = GetModConfigData("achievementAllReward") or false;

if achievementAllReward > 0 then
    AddComponentPostInit("achievementmanager", function(self)
        local oldSeffc = self.seffc
        function self:seffc(inst, tag)
            oldSeffc(self,inst, tag);
            if tag == "all" then
                inst.components.achievementability:coinDoDelta(achievementAllReward)
                TheNet:Announce(string.format("%s：成功毕业！获得%d点额外成就！",inst:GetDisplayName(),achievementAllReward))
            end
        end
    end
    )
end
