local zyPlayerSaveData = Class(function(self, inst)
    self.inst = inst
    self.carneyData = nil
end)

--carney 卡尼猫
function zyPlayerSaveData:saveCarneyData(player)
    if player
        and player.components
            and player.components.carneystatus
    then
        self.carneyData = player.components.carneystatus:OnSave()
    end
end

function zyPlayerSaveData:loadCarneyData(player)
    if player
            and player.components
            and player.components.carneystatus
        and self.carneyData
    then
        player.components.carneystatus:OnLoad(self.carneyData)
        self.carneyData = nil
    end
end

function zyPlayerSaveData:OnSave()
    return {
        carneyData = self.carneyData
    }
end

function zyPlayerSaveData:OnLoad(data)
    if data then
        self.carneyData = data.carneyData
    end
end

return zyPlayerSaveData