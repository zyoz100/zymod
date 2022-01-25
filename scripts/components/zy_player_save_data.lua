--参见神话的saveinfo

local zyPlayerSaveData = Class(function(self, inst)
    assert(TheWorld.ismastersim, "好好学习天天向上")

    self.inst = inst

    local _world = TheWorld
    local _ismastershard = _world.ismastershard

    self._savedata = {}

    --下面开始瞎编
    if _ismastershard then
        inst:ListenForEvent("ms_newplayerspawned", function(world, player)
            self:LoadPlayerSaveData(player)
        end)
    end

    inst:ListenForEvent("ms_playerdespawnanddelete", function(inst, player)
        local res = self:SetPlayerSaveDataByPlayer(player)
        if next(res) ~= nil then
            local success, a = pcall(json.encode, res)
            if success then
                SendModRPCToShard(SHARD_MOD_RPC["zy"]["player_save_data"], player.userid, a)
            end
        end
    end)

    self.inst = inst
end)

function zyPlayerSaveData:SetPlayerSaveDataByPlayer(player)
    if player and player.userid then
        self._savedata[player.userid] = self._savedata[player.userid] or {}
        if player.prefab == 'carney' then
            self._savedata[player.userid]["carney"] = player.components.carneystatus:OnSave()
        elseif player.prefab == 'chogath' then
            self._savedata[player.userid]["chogath"] = player:OnSave()
        elseif player.prefab == 'doghead' then
            self._savedata[player.userid]["doghead"] = player.soul
        elseif player.prefab == 'yuanzi' then
            self._savedata[player.userid]["yuanzi"] = player.components.pigeonenergy:OnSave()
        elseif player.prefab == 'seele' then
            self._savedata[player.userid]["seele"] = {
                level = player.components.seelebase.level,
                current = player.components.seelebase.current,
            }
        elseif player.prefab == 'taizhen' then
            self._savedata[player.userid]["taizhen"] = player.components.tz_xx:OnSave()
        end
    end
    return self._savedata[player.userid]
end

function zyPlayerSaveData:LoadPlayerSaveData(player)
    if player and player.userid and self._savedata[player.userid] then
        if player.prefab == 'carney' and self._savedata[player.userid]["carney"] then
            player.components.carneystatus:OnLoad(self._savedata[player.userid]["carney"])
            self._savedata[player.userid]["carney"] = nil;
        elseif player.prefab == 'chogath' and self._savedata[player.userid]["chogath"] then
            player:OnPreLoad(self._savedata[player.userid]["chogath"])
            self._savedata[player.userid]["chogath"] = nil
        elseif player.prefab == 'doghead' and self._savedata[player.userid]["doghead"] then
            player.soul = tonumber(self._savedata[player.userid]["doghead"]) or 0
            self._savedata[player.userid]["doghead"] = player.level
        elseif player.prefab == 'yuanzi' and self._savedata[player.userid]["yuanzi"] and player.OnYuanzitatus then
            player.components.pigeonenergy:OnLoad(self._savedata[player.userid]["yuanzi"])
            player:OnYuanzitatus()
            self._savedata[player.userid]["yuanzi"] = nil;
        elseif player.prefab == 'seele' and self._savedata[player.userid]["seele"] and player.OnSeeleState then
            player.components.seelebase.level = tonumber(self._savedata[player.userid]["seele"].level) or 0
            player.components.seelebase.current = tonumber(self._savedata[player.userid]["seele"].current) or 0
            player:OnSeeleState()
            self._savedata[player.userid]["seele"] = nil;
        elseif player.prefab == 'taizhen' and self._savedata[player.userid]["taizhen"] then
            player.components.tz_xx:OnLoad(self._savedata[player.userid]["taizhen"])
            self._savedata[player.userid]["taizhen"] = nil
        end
    end
end

function zyPlayerSaveData:SetPlayerSaveDataByUserId(userid, data)
    self._savedata[player.userid] = data
end

function zyPlayerSaveData:OnSave()
    return {
        _savedata = self._savedata
    }
end

function zyPlayerSaveData:OnLoad(data)
    if data then
        self._savedata = data._savedata
    end
end

return zyPlayerSaveData