local _G = GLOBAL
local LAMaxHSH = GetModConfigData("LAMaxHSH") or 0;
local LAGetMorePoints = GetModConfigData("LAGetMorePoints") or 0;

if LAMaxHSH > 0 then
    local namespace = "DSTAchievement";
    local oldHungerUp = _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["hungerup"].id]
    _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["hungerup"].id] = function(player)
        if  player.components.allachivcoin.hungerupamount < LAMaxHSH then
            oldHungerUp(player)
        end
    end
    local oldSanityUp = _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["sanityup"].id]
    _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["sanityup"].id] = function(player)
        if  player.components.allachivcoin.sanityupamount < LAMaxHSH then
            oldSanityUp(player)
        end
    end
    local oldHealthUp = _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["healthup"].id]
    _G.MOD_RPC_HANDLERS[namespace][_G.MOD_RPC[namespace]["healthup"].id] = function(player)
        if  player.components.allachivcoin.healthupamount < LAMaxHSH then
            oldHealthUp(player)
        end
    end
end

if LAGetMorePoints > 0 then
    local all_achievement_cold_get = {
        --ACHIEVEMENTS
        --Food
        ["firsteat"] = 100,
        ["supereat"] = 1000,
        ["danding"] = 300,
        ["alldiet"] = 5000,
        ["eathot"] = 1000,
        ["eatcold"] = 1000,
        ["eatfish"] = 300,
        ["eatturkey"] = 300,
        ["eatpepper"] = 300,
        ["eatbacon"] = 300,
        ["eatmole"] = 300,
        --Life
        ["noob"] = 100,
        ["tooyoung"] = 1000,
        ["killme"] = 400,
        ["rot"] = 600,
        ["deathalot"] = 1300,
        ["secondchance"] = 1200,
        ["messiah"] = 3000,
        ["sleeptent"] = 1500,
        ["sleepsiesta"] = 1500,
        ["reviveamulet"] = 600,
        ["feedplayer"] = 5000,
        --Work
        ["nature"] = 50000,
        ["fishmaster"] = 30000,
        ["pickappren"] = 30000,
        ["pickmaster"] = 60000,
        ["chopappren"] = 35000,
        ["chopmaster"] = 70000,
        ["mineappren"] = 20000,
        ["minemaster"] = 40000,
        ["cookappren"] = 10000,
        ["cookmaster"] = 20000,
        ["buildappren"] = 50000,
        ["buildmaster"] = 100000,
        --Have
        ["emerald"] = 3000,
        ["citrin"] = 3000,
        ["amber"] = 3000,
        ["saddle"] = 200,
        ["banana"] = 1000,
        ["spore"] = 200,
        ["blueprint"] = 1000,
        ["boat"] = 2000,
        ["moonrock"] = 200,
        ["gnome"] = 4000000,
        ["mosquito"] = 2000,
        ["bathbomb"] = 200,
        --Like
        ["goodman"] = 500,
        ["brother"] = 600,
        ["catperson"] = 1000,
        ["rocklob"] = 1000,
        ["spooder"] = 2000,
        ["evil"] = 2000,
        ["birdclop"] = 10000,
        ["pet"] = 100,
        ["shadowchester"] = 5000,
        ["snowchester"] = 5000,
        ["musichutch"] = 5000,
        ["lavae"] = 50000,
        --Pain
        ["burn"] = 300,
        ["freeze"] = 400,
        ["sleep"] = 2000,
        ["starve"] = 40000,
        ["nosanity"] = 10000,
        ["icebody"] = 20000,
        ["firebody"] = 20000,
        ["moistbody"] = 25000,
        ["evilflower"] = 1000,
        ["roses"] = 1000,
        ["drown"] = 1000,
        --Fight
        ["angry"] = 10000,
        ["tank"] = 10000,
        ["dmgnodmg"] = 30000,
        ["bullkelp"] = 30000,
        ["butcher"] = 3000,
        ["horrorhound"] = 30000,
        ["slurtle"] = 3000,
        ["werepig"] = 2000,
        ["fruitdragon"] = 1000,
        ["sick"] = 300,
        ["coldblood"] = 300,
        ["hutch"] = 3000,
        --Hunt
        ["goatperd"] = 3000,
        ["mossling"] = 4000,
        ["weetusk"] = 25000,
        ["snake"] = 3000,
        ["black"] = 10000,
        ["hentai"] = 2000,
        ["treeguard"] = 2000,
        ["spiderqueen"] = 2000,
        ["varg"] = 20000,
        ["koaelefant"] = 1000,
        ["monkey"] = 1000,
        --Boss
        ["santa"] = 20000,
        ["dragonfly"] = 400000,
        ["malbatross"] = 20000,
        ["crabking"] = 25000,
        ["knight"] = 180000,
        ["bishop"] = 180000,
        ["rook"] = 180000,
        ["minotaur"] = 230000,
        ["ancient"] = 240000,
        ["rigid"] = 400000,
        ["queen"] = 290000,
        ["king"] = 500000,
        --Misc
        ["intogame"] = 0,
        ["superstar"] = 200,
        ["trader"] = 200,
        ["fuzzy"] = 4000,
        ["knowledge"] = 4000,
        ["dance"] = 4000,
        ["teleport"] = 4000,
        ["luck"] = 20000,
        ["lightning"] = 600,
        ["birchnut"] = 200000,
        --Mile
        ["all"] = 6000 * 10000,
        ["longage"] = 100000,
        ["oldage"] = 1000000,
        ["walkalot"] = 100000,
        ["stopalot"] = 50000,
        ["caveage"] = 50000,
        ["rider"] = 400000,
        ["fullsanity"] = 100000,
        ["fullhunger"] = 100000,
        ["pacifist"] = 100000,
    }
    AddComponentPostInit("allachivevent", function(self)
        function self:seffc(inst, tag)

            _G.SpawnPrefab("seffc").entity:SetParent(inst.entity)
            local strname = _G.STRINGS.ACHIEVEMENTS[tag].name
            local strinfo = _G.STRINGS.ACHIEVEMENTS[tag].info

            local gold = all_achievement_cold_get[tag] or 0;
            local extraCoin = 0;
            if gold > 0 then
                extraCoin = math.ceil(gold / 20000 * LAGetMorePoints)
            end

            if _G.NOTIFICATION then
                local announceStr = inst:GetDisplayName().."   "..strinfo.._G.STRINGS.GUI["space"].._G.STRINGS.GUI["complA"]..strname.._G.STRINGS.GUI["br2"];
                if extraCoin > 0 then
                    announceStr = announceStr .. "额外成就点：" .. extraCoin
                end
                _G.TheNet:Announce(announceStr)
            end
            if _G.NOAWARDS ~= true then
                inst.components.allachivcoin:coinDoDelta(_G.allachiv_coinget[tag] + extraCoin)
                local talkerStr = _G.STRINGS.GUI["br1"]..strname.._G.STRINGS.GUI["br2"].."\n".._G.STRINGS.GUI["obt"].._G.allachiv_coinget[tag].._G.STRINGS.GUI["points"]
                if extraCoin > 0 then
                    talkerStr = talkerStr .. "额外成就点：" .. extraCoin
                end
                inst.components.talker:Say(talkerStr)
            else
                inst.components.talker:Say(_G.STRINGS.GUI["br1"]..strname.._G.STRINGS.GUI["br2"])
            end
        end
    end
    )
end
