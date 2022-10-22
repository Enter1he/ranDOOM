-- ranDOOOM.lua
-- a lua library for generating numbers with DOOM-style table algorithm


local rDm = {}

local seed = os.time()

local function random(s, e)
    local x = seed
    x = x ~ (x << 13);
	x = x ~ (x >> 7);
	x = x ~ (x << 17);
    seed = x
    x = (x % e) + s
    return x
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

    for i = 1, n do
        local pos = random(1,n)
        t[pos], t[i] = t[i], t[pos]
    end
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

function rDm.preRand(t, n, start)
    if type(n) ~= "number" and math.type(n) ~= "integer" then
        error"rDm.preRand number of table indices should be integer"
    end
    if type(start) == "number" and math.type(start) ~= "integer" then
        error"rDm.preRand starts from integer position"
    end
    local t = t or rDm.genTable(n)
    local i = start or 1
    return function() -- rand function generated
        local x = t[i]
        i = i + 1
        return x
    end
end

local t = rDm.genTable(50)

rDm.print(t)
local rand = rDm.preRand(t, 50, 5)
print(rand())
print(rand())