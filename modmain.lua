local _G = GLOBAL
up = require("util/upvaluehelper")


--util
modimport("scripts/util/util")

--原版修正
modimport("override/base")

--修正一些奇奇怪怪的问题
modimport("override/bugFix")

--神话 myth
if _G.isModEnableByName("Myth Words") then
    modimport("override/myth")
end

--成就商店
if _G.isModEnableById("2121078176") then
    modimport("override/achievementAndShop")
end

--托托莉
if _G.isModEnableById("899583698") then
    modimport("override/totooria")
end

--虚空假面
if _G.isModEnableById("2245132201") then
    modimport("override/chogath")
end

--[[--狗头
if _G.isModEnableById("2002991372") then
    modimport("override/dogHead")
end]]

--小穹
if _G.isModEnableById("1638724235") then
    modimport("override/sora")
end

--卡尼猫
if _G.isModEnableById("949808360") then
    modimport("override/carney")
end

--太真
if _G.isModEnableById("2066838067") then
    modimport("override/taizhen")
end

--狐狸
if _G.isModEnableById("1694540893")
        or  _G.isModEnableById("2259379465")
        or  _G.isModEnableById("2215151821") then
    modimport("override/huli")
end

--怠惰科技
if _G.isModEnableById("2347908689") then
    modimport("override/lazyTechnology")
end

if _G.isModEnableById("2019613520") then
    modimport("override/randomSized")
end

if _G.isModEnableById("2299268435") then
    modimport("override/randomSizedData")
end

--legion
if _G.isModEnableById("1392778117") then
    modimport("override/legion")
end

--yuanzi
if _G.isModEnableById("1645013096") then
    modimport("override/yuanzi")
end

--错误追踪
bugtracker_config = {
    email = "zyoz300@163.com",
    upload_client_log = true,
    upload_server_log = true,
    upload_other_mods_crash_log = true,
}




