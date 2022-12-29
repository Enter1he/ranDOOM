-- test.lua

local rdm = require"ranDOOM"

local t = rdm.genTableNV({[3] = 3, [5] = 5})

rdm.print(t)