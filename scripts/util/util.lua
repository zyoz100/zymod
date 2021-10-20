local modDir = GLOBAL.KnownModIndex:GetModsToLoad(true)
local enableMods = {}

for k, dir in pairs(modDir) do
    local info = GLOBAL.KnownModIndex:GetModInfo(dir)
    local name = info and info.name or "unknown"
    enableMods[dir] = name
end

--	MOD是否开启 by 风铃
function isModEnableByName(name)
    for k, v in pairs(enableMods) do
        if v and (k:match(name) or v:match(name)) then
            return true
        end
    end
    return false
end

function isModEnableById(Id)
    for k, dir in pairs(modDir) do
        if dir and (dir:match(Id)) then
            return true
        end
    end
    return false
end

GLOBAL.isModEnableByName = isModEnableByName
GLOBAL.isModEnableById = isModEnableById

--	later function  by 风铃
local laterfn = {}
function AddLaterFnCopy(fn)
    ---重命名避免重名导致的问题
    if fn and type(fn) == "function" then
        table.insert(laterfn, fn)
    end
end

local oldTranslateStringTable = GLOBAL.TranslateStringTable -- modmain运行完之后就是 TranslateStringTable 在这儿下钩子 哈哈 by 风铃
GLOBAL.TranslateStringTable = function(...)
    for k, v in pairs(laterfn) do
        if v and type(v) == "function" then
            v()
        end
    end
    return oldTranslateStringTable(...)
end

GLOBAL.AddLaterFnCopy = AddLaterFnCopy;

local isNumber = function(num)
    return type(num) == "number"
end

local isString = function(num)
    return type(num) == "string"
end

GLOBAL.ZyUtil = {
    isNumber = isNumber,
    isString = isString
}


