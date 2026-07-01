-- Decompiled with Medal

local v1 = {}
local HttpService = game:GetService("HttpService")
local v_u_3 = Random.new()
local function v_u_24(p4, p5) -- name: Sync
    -- upvalues: (copy) v_u_24
    local v6 = type(p4) == "table"
    assert(v6, "First argument must be a table")
    local v7 = type(p5) == "table"
    assert(v7, "Second argument must be a table")
    local v8 = table.clone(p4)
    for v9, v10 in pairs(v8) do
        local v11 = p5[v9]
        if v11 == nil then
            v8[v9] = nil
        elseif type(v10) == type(v11) then
            if type(v10) == "table" then
                v8[v9] = v_u_24(v10, v11)
            end
        elseif type(v11) == "table" then
            local function v_u_16(p12) -- name: DeepCopy
                -- upvalues: (copy) v_u_16
                local v13 = table.clone(p12)
                for v14, v15 in v13 do
                    if type(v15) == "table" then
                        v13[v14] = v_u_16(v15)
                    end
                end
                return v13
            end
            v8[v9] = v_u_16(v11)
        else
            v8[v9] = v11
        end
    end
    for v17, v18 in pairs(p5) do
        if v8[v17] == nil then
            if type(v18) == "table" then
                local function v_u_23(p19) -- name: DeepCopy
                    -- upvalues: (copy) v_u_23
                    local v20 = table.clone(p19)
                    for v21, v22 in v20 do
                        if type(v22) == "table" then
                            v20[v21] = v_u_23(v22)
                        end
                    end
                    return v20
                end
                v8[v17] = v_u_23(v18)
            else
                v8[v17] = v18
            end
        end
    end
    return v8
end
local function v_u_43(p25, p26) -- name: Reconcile
    -- upvalues: (copy) v_u_43
    local v27 = type(p25) == "table"
    assert(v27, "First argument must be a table")
    local v28 = type(p26) == "table"
    assert(v28, "Second argument must be a table")
    local v29 = table.clone(p25)
    for v30, v31 in p26 do
        local v32 = p25[v30]
        if v32 == nil then
            if type(v31) == "table" then
                local function v_u_37(p33) -- name: DeepCopy
                    -- upvalues: (copy) v_u_37
                    local v34 = table.clone(p33)
                    for v35, v36 in v34 do
                        if type(v36) == "table" then
                            v34[v35] = v_u_37(v36)
                        end
                    end
                    return v34
                end
                v29[v30] = v_u_37(v31)
            else
                v29[v30] = v31
            end
        elseif type(v32) == "table" then
            if type(v31) == "table" then
                v29[v30] = v_u_43(v32, v31)
            else
                local function v_u_42(p38) -- name: DeepCopy
                    -- upvalues: (copy) v_u_42
                    local v39 = table.clone(p38)
                    for v40, v41 in v39 do
                        if type(v41) == "table" then
                            v39[v40] = v_u_42(v41)
                        end
                    end
                    return v39
                end
                v29[v30] = v_u_42(v32)
            end
        end
    end
    return v29
end
local function v_u_51(p44, p45) -- name: Map
    local v46 = type(p44) == "table"
    assert(v46, "First argument must be a table")
    local v47 = type(p45) == "function"
    assert(v47, "Second argument must be a function")
    local v48 = table.create(#p44)
    for v49, v50 in p44 do
        v48[v49] = p45(v50, v49, p44)
    end
    return v48
end
function v1.Copy(p52, p53) -- name: Copy
    if not p53 then
        return table.clone(p52)
    end
    local function v_u_58(p54) -- name: DeepCopy
        -- upvalues: (copy) v_u_58
        local v55 = table.clone(p54)
        for v56, v57 in v55 do
            if type(v57) == "table" then
                v55[v56] = v_u_58(v57)
            end
        end
        return v55
    end
    return v_u_58(p52)
end
v1.Sync = v_u_24
v1.Reconcile = v_u_43
function v1.SwapRemove(p59, p60) -- name: SwapRemove
    local v61 = #p59
    p59[p60] = p59[v61]
    p59[v61] = nil
end
function v1.SwapRemoveFirstValue(p62, p63) -- name: SwapRemoveFirstValue
    local v64 = table.find(p62, p63)
    if v64 then
        local v65 = #p62
        p62[v64] = p62[v65]
        p62[v65] = nil
    end
    return v64
end
v1.Map = v_u_51
function v1.Filter(p66, p67) -- name: Filter
    local v68 = type(p66) == "table"
    assert(v68, "First argument must be a table")
    local v69 = type(p67) == "function"
    assert(v69, "Second argument must be a function")
    local v70 = table.create(#p66)
    if #p66 <= 0 then
        for v71, v72 in p66 do
            if p67(v72, v71, p66) then
                v70[v71] = v72
            end
        end
        return v70
    end
    local v73 = 0
    for v74, v75 in p66 do
        if p67(v75, v74, p66) then
            v73 = v73 + 1
            v70[v73] = v75
        end
    end
    return v70
end
function v1.Reduce(p76, p77, p78) -- name: Reduce
    local v79 = type(p76) == "table"
    assert(v79, "First argument must be a table")
    local v80 = type(p77) == "function"
    assert(v80, "Second argument must be a function")
    if #p76 > 0 then
        local v81
        if p78 == nil then
            p78 = p76[1]
            v81 = 2
        else
            v81 = 1
        end
        for v82 = v81, #p76 do
            p78 = p77(p78, p76[v82], v82, p76)
        end
        return p78
    else
        local v83
        if p78 == nil then
            v83 = next(p76)
            p78 = v83
        else
            v83 = nil
        end
        for v84, v85 in next, p76, v83 do
            p78 = p77(p78, v85, v84, p76)
        end
        return p78
    end
end
function v1.Assign(p86, ...) -- name: Assign
    local v87 = table.clone(p86)
    for _, v88 in { ... } do
        for v89, v90 in v88 do
            v87[v89] = v90
        end
    end
    return v87
end
function v1.Extend(p91, p92) -- name: Extend
    local v93 = table.clone(p91)
    for _, v94 in p92 do
        table.insert(v93, v94)
    end
    return v93
end
function v1.Reverse(p95) -- name: Reverse
    local v96 = #p95
    local v97 = table.create(v96)
    for v98 = 1, v96 do
        v97[v98] = p95[v96 - v98 + 1]
    end
    return v97
end
function v1.Shuffle(p99, p100) -- name: Shuffle
    -- upvalues: (copy) v_u_3
    local v101 = type(p99) == "table"
    assert(v101, "First argument must be a table")
    local v102 = table.clone(p99)
    if typeof(p100) ~= "Random" then
        p100 = v_u_3
    end
    for v103 = #p99, 2, -1 do
        local v104 = p100:NextInteger(1, v103)
        local v105 = v102[v104]
        local v106 = v102[v103]
        v102[v103] = v105
        v102[v104] = v106
    end
    return v102
end
function v1.Sample(p107, p108, p109) -- name: Sample
    -- upvalues: (copy) v_u_3
    local v110 = type(p107) == "table"
    assert(v110, "First argument must be a table")
    local v111 = type(p108) == "number"
    assert(v111, "Second argument must be a number")
    local v112 = #p107
    if v112 == 0 then
        return {}
    end
    local v113 = table.clone(p107)
    local v114 = table.create(p108)
    if typeof(p109) ~= "Random" then
        p109 = v_u_3
    end
    local v115 = math.clamp(p108, 1, v112)
    for v116 = 1, v115 do
        local v117 = p109:NextInteger(v116, v112)
        local v118 = v113[v117]
        local v119 = v113[v116]
        v113[v116] = v118
        v113[v117] = v119
    end
    table.move(v113, 1, v115, 1, v114)
    return v114
end
function v1.Flat(p120, p121) -- name: Flat
    local v_u_122 = type(p121) ~= "number" and 1 or p121
    local v_u_123 = table.create(#p120)
    local function v_u_128(p124, p125) -- name: Scan
        -- upvalues: (copy) v_u_122, (copy) v_u_128, (copy) v_u_123
        for _, v126 in p124 do
            if type(v126) == "table" and p125 < v_u_122 then
                v_u_128(v126, p125 + 1)
            else
                local v127 = v_u_123
                table.insert(v127, v126)
            end
        end
    end
    v_u_128(p120, 0)
    return v_u_123
end
function v1.FlatMap(p129, p130) -- name: FlatMap
    -- upvalues: (copy) v_u_51
    local v131 = v_u_51(p129, p130)
    local v_u_132 = table.create(#v131)
    local v_u_133 = 1
    local function v_u_138(p134, p135) -- name: Scan
        -- upvalues: (copy) v_u_133, (copy) v_u_138, (copy) v_u_132
        for _, v136 in p134 do
            if type(v136) == "table" and p135 < v_u_133 then
                v_u_138(v136, p135 + 1)
            else
                local v137 = v_u_132
                table.insert(v137, v136)
            end
        end
    end
    v_u_138(v131, 0)
    return v_u_132
end
function v1.Keys(p139) -- name: Keys
    local v140 = table.create(#p139)
    for v141 in p139 do
        table.insert(v140, v141)
    end
    return v140
end
function v1.Values(p142) -- name: Values
    local v143 = table.create(#p142)
    for _, v144 in p142 do
        table.insert(v143, v144)
    end
    return v143
end
function v1.Find(p145, p146) -- name: Find
    for v147, v148 in p145 do
        if p146(v148, v147, p145) then
            return v148, v147
        end
    end
    return nil, nil
end
function v1.Every(p149, p150) -- name: Every
    for v151, v152 in p149 do
        if not p150(v152, v151, p149) then
            return false
        end
    end
    return true
end
function v1.Some(p153, p154) -- name: Some
    for v155, v156 in p153 do
        if p154(v156, v155, p153) then
            return true
        end
    end
    return false
end
function v1.Truncate(p157, p158) -- name: Truncate
    local v159 = #p157
    local v160 = math.clamp(p158, 1, v159)
    if v160 == v159 then
        return table.clone(p157)
    else
        return table.move(p157, 1, v160, 1, table.create(v160))
    end
end
function v1.Zip(...) -- name: Zip
    local v161 = select("#", ...) > 0
    assert(v161, "Must supply at least 1 table")
    local function v169(p162, p163) -- name: ZipIteratorArray
        local v164 = p163 + 1
        local v165 = {}
        for v166, v167 in p162 do
            local v168 = v167[v164]
            if v168 == nil then
                return nil, nil
            end
            v165[v166] = v168
        end
        return v164, v165
    end
    local function v176(p170, p171) -- name: ZipIteratorMap
        local v172 = {}
        for v173, v174 in p170 do
            local v175 = next(v174, p171)
            if v175 == nil then
                return nil, nil
            end
            v172[v173] = v175
        end
        return p171, v172
    end
    local v177 = { ... }
    if #v177[1] > 0 then
        return v169, v177, 0
    else
        return v176, v177, nil
    end
end
function v1.Lock(p178) -- name: Lock
    local function v_u_182(p179) -- name: Freeze
        -- upvalues: (copy) v_u_182
        for v180, v181 in pairs(p179) do
            if type(v181) == "table" then
                p179[v180] = v_u_182(v181)
            end
        end
        return table.freeze(p179)
    end
    return v_u_182(p178)
end
function v1.IsEmpty(p183) -- name: IsEmpty
    return next(p183) == nil
end
function v1.EncodeJSON(p184) -- name: EncodeJSON
    -- upvalues: (copy) HttpService
    return HttpService:JSONEncode(p184)
end
function v1.DecodeJSON(p185) -- name: DecodeJSON
    -- upvalues: (copy) HttpService
    return HttpService:JSONDecode(p185)
end
return v1
