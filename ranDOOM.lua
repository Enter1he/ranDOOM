-- ranDOOOM.lua
-- a lua library for generating numbers with DOOM-style table algorithm


local rDm = {}

local seed = os.time()

local function randomseed(sd)
    seed = sd
end
-- actually a xorshift algorithm
local function random(s, e)
    local x = seed
    x = x ~ (x << 13);
	x = x ~ (x >> 7);
	x = x ~ (x << 17);
    seed = x
    x = (x % e) + s
    return x
end
local min, max = function()end, function()end --some private variables' names 

--[[
    ranDOOM.ShuffleTable(t: table, rand: function(m, n: integer))
    Shuffles already created ranDOOM table using 'rand' function.
    The function should be like math.random from Lua stadard library.
]]
function rDm.ShuffleTable(t, rand)
    rand = rand or random
    local n = t[max]
    local m = t[min]
    for i = m, n do
        for i = m, n do
            local pos = rand(m,n)
            t[pos], t[i] = t[i], t[pos]
        end
    end
end

--[[
    ranDOOM.genTable (m, n: integer)
    generates ranDOOM table from minimum ('m') and maximum ('n') values
]]
function rDm.genTable(m,n)
    local t = {}
    if type(n) ~= "number" or type(m) ~= "number" then
        if math.type(n) ~= "integer" or math.type(m) ~= "integer" then
            error"ranDOOM.genTable accepts only integers!"
        end
    end
    if m >= n then
        error"ranDOOM.genTable 1st value can't be bigger than 2nd!!"
    end

    for i = m, n do
        t[i] = i
    end
    t[min] = m
    t[max] = n
    rDm.ShuffleTable(t, random)
    return t
end

--[[
    ranDOOM.print ( t : table )
    prints the contents of ranDOOM table
]]
function rDm.print(t)
    if type(t) ~= "table" then
        error"ranDOOOM.print expected table!!"
    end
    if l < 2 then
        error"ranDOOOM.print no table values to operate"
    end
    for i = t[min], t[max] do
        print(i, t[i])        
    end
end

--[[
    rDm.makeRand (t : table, n, start : integer )
    Creates new randomizing function based on table 't',
    number of indicies 'n' and starting position 'start'
]]
function rDm.makeRand(t, m, n, start)
    if type(n) ~= "number" and math.type(n) ~= "integer" or type(m) ~= "number" and math.type(m) ~= "integer" then
        error"ranDOOM.makeRand number of table indices should be integer"
    end
    if m >= n then
        error"ranDOOM.makeRand 1st value can't be bigger than 2nd!!"
    end
    if type(start) == "number" and math.type(start) ~= "integer" then
        error"ranDOOM.makeRand starts from integer position"
    end
    if start > n or start < m then
        error"ranDOOOM.makeRand can't start from outside of table!!"
    end
    local t = t or rDm.genTable(m,n)
    local i = start or 1
    return function() -- rand function generated
        
        if i < t[max] then
            i = i + 1
        else
            i = t[min]
        end
        return t[i]
    end
end

--[[
    ranDOOM.saveTable(t: table, folder: string)
    Saves ranDOOM table into file at folder.
]]
function rDm.saveTable(t, folder)
    if type(t) ~= "table" then
        error"ranDOOOM.saveTable accepts only tables to save"
    end
    if type(folder) ~= "string" then
        error"ranDOOOM.saveTable folder should be a string value"
    end
    
    local f = io.open(folder, "w+")
    if not f then
        error"ranDOOOM.saveTable error opening file to save"
    end
    f:write(string.format("return {\n"))
    
    for i = t[min], t[max], 1 do
        f:write(t[i]..", ")
    end
    
    f:write(string.format("\n};"))
    f:close()
end

return rDn;