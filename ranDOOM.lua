-- ranDOOOM.lua
-- a lua library for generating numbers with DOOM-style table algorithm


local rDm = {}

local seed = os.time()

local function randomseed(sd)
    seed = sd
end

local function random(s, e)
    local x = seed
    x = x ~ (x << 13);
	x = x ~ (x >> 7);
	x = x ~ (x << 17);
    seed = x
    x = (x % e) + s
    return x
end

function rDm.ShuffleTable(t, rand)
    rand = rand or random
    local n = #t
    for i = 1, n do
        for i = 1, n do
            local pos = random(1,n)
            t[pos], t[i] = t[i], t[pos]
        end
    end
end

function rDm.genTable(n)
    local t = {}
    if type(n) ~= "number" then
        if math.type(n) ~= "integer" then
            error"ranDOOM.genTable accepts only integers!"
        end
    end
    if n < 0 then
        error"ranDOOM.genTable accepts only integers bigger than 1!!"
    end

    for i = 1, n do
        t[i] = i
    end

    rDm.ShuffleTable(t, random)
    return t
end

function rDm.print(t)
    if type(t) ~= "table" then
        error"rDm.print expected table!!"
    end
    local l = #t
    if l < 2 then
        error"rDm.print no table values to operate"
    end
    for i = 1, #t do
        print(i, t[i])        
    end
end

--[[
    rDm.makeRand (t : table, n, start : integer )
    Creates new randomizing function based on table 't',
    number of indicies 'n' and starting position 'start'
]]
function rDm.makeRand(t, n, start)
    if type(n) ~= "number" and math.type(n) ~= "integer" then
        error"rDm.preRand number of table indices should be integer"
    end
    if type(start) == "number" and math.type(start) ~= "integer" then
        error"rDm.preRand starts from integer position"
    end
    local t = t or rDm.genTable(n)
    local l = #t
    local i = start or 1
    return function() -- rand function generated
        
        if i < l then
            i = i + 1
        else
            i = 1    
        end
        local x = t[i]
        return x
    end
end

function rDm.saveTable(t, folder)
    if type(t) ~= "table" then
        error"rDm.saveTable accepts only tables to save"
    end
    if type(folder) ~= "string" then
        error"rDm.saveTable folder should be a string value"
    end
    
    local f = io.open(folder, "w+")
    if not f then
        error"rDm.saveTable error opening file to save"
    end
    f:write(string.format("return {\n"))
    local l = #t
    local j, m = 1, 1
    local n = 10
    
    for i = 1, l, 1 do
        f:write(t[i]..", ")
    end
    
    f:write(string.format("\n};"))
    f:close()
end

local t = rDm.genTable(15)

rDm.print(t)
local rand = rDm.makeRand(t, 15, 5)
rDm.saveTable(t, "savet.lua")
print(rand())
print(rand())