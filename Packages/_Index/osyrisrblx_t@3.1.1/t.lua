-- Decompiled with Medal

local v_u_8 = {
    ["type"] = function(p_u_1) -- name: type
        return function(p2)
            -- upvalues: (copy) p_u_1
            local v3 = type(p2)
            if v3 == p_u_1 then
                return true
            else
                return false, string.format("%s expected, got %s", p_u_1, v3)
            end
        end
    end,
    ["typeof"] = function(p_u_4) -- name: typeof
        return function(p5)
            -- upvalues: (copy) p_u_4
            local v6 = typeof(p5)
            if v6 == p_u_4 then
                return true
            else
                return false, string.format("%s expected, got %s", p_u_4, v6)
            end
        end
    end,
    ["any"] = function(p7) -- name: any
        if p7 == nil then
            return false, "any expected, got nil"
        else
            return true
        end
    end
}
v_u_8.boolean = v_u_8.typeof("boolean")
v_u_8.buffer = v_u_8.typeof("buffer")
v_u_8.thread = v_u_8.typeof("thread")
v_u_8.callback = v_u_8.typeof("function")
v_u_8["function"] = v_u_8.callback
v_u_8.none = v_u_8.typeof("nil")
v_u_8["nil"] = v_u_8.none
v_u_8.string = v_u_8.typeof("string")
v_u_8.table = v_u_8.typeof("table")
v_u_8.userdata = v_u_8.type("userdata")
v_u_8.vector = v_u_8.type("vector")
function v_u_8.number(p9) -- name: number
    local v10 = typeof(p9)
    if v10 == "number" then
        if p9 == p9 then
            return true
        else
            return false, "unexpected NaN value"
        end
    else
        return false, string.format("number expected, got %s", v10)
    end
end
function v_u_8.nan(p11) -- name: nan
    local v12 = typeof(p11)
    if v12 == "number" then
        if p11 == p11 then
            return false, "unexpected non-NaN value"
        else
            return true
        end
    else
        return false, string.format("number expected, got %s", v12)
    end
end
v_u_8.Axes = v_u_8.typeof("Axes")
v_u_8.BrickColor = v_u_8.typeof("BrickColor")
v_u_8.CatalogSearchParams = v_u_8.typeof("CatalogSearchParams")
v_u_8.CFrame = v_u_8.typeof("CFrame")
v_u_8.Color3 = v_u_8.typeof("Color3")
v_u_8.ColorSequence = v_u_8.typeof("ColorSequence")
v_u_8.ColorSequenceKeypoint = v_u_8.typeof("ColorSequenceKeypoint")
v_u_8.DateTime = v_u_8.typeof("DateTime")
v_u_8.DockWidgetPluginGuiInfo = v_u_8.typeof("DockWidgetPluginGuiInfo")
v_u_8.Enum = v_u_8.typeof("Enum")
v_u_8.EnumItem = v_u_8.typeof("EnumItem")
v_u_8.Enums = v_u_8.typeof("Enums")
v_u_8.Faces = v_u_8.typeof("Faces")
v_u_8.FloatCurveKey = v_u_8.typeof("FloatCurveKey")
v_u_8.Font = v_u_8.typeof("Font")
v_u_8.Instance = v_u_8.typeof("Instance")
v_u_8.NumberRange = v_u_8.typeof("NumberRange")
v_u_8.NumberSequence = v_u_8.typeof("NumberSequence")
v_u_8.NumberSequenceKeypoint = v_u_8.typeof("NumberSequenceKeypoint")
v_u_8.OverlapParams = v_u_8.typeof("OverlapParams")
v_u_8.PathWaypoint = v_u_8.typeof("PathWaypoint")
v_u_8.PhysicalProperties = v_u_8.typeof("PhysicalProperties")
v_u_8.Random = v_u_8.typeof("Random")
v_u_8.Ray = v_u_8.typeof("Ray")
v_u_8.RaycastParams = v_u_8.typeof("RaycastParams")
v_u_8.RaycastResult = v_u_8.typeof("RaycastResult")
v_u_8.RBXScriptConnection = v_u_8.typeof("RBXScriptConnection")
v_u_8.RBXScriptSignal = v_u_8.typeof("RBXScriptSignal")
v_u_8.Rect = v_u_8.typeof("Rect")
v_u_8.Region3 = v_u_8.typeof("Region3")
v_u_8.Region3int16 = v_u_8.typeof("Region3int16")
v_u_8.TweenInfo = v_u_8.typeof("TweenInfo")
v_u_8.UDim = v_u_8.typeof("UDim")
v_u_8.UDim2 = v_u_8.typeof("UDim2")
v_u_8.Vector2 = v_u_8.typeof("Vector2")
v_u_8.Vector2int16 = v_u_8.typeof("Vector2int16")
v_u_8.Vector3 = v_u_8.typeof("Vector3")
v_u_8.Vector3int16 = v_u_8.typeof("Vector3int16")
function v_u_8.literal(...) -- name: literal
    -- upvalues: (copy) v_u_8
    local v13 = select("#", ...)
    if v13 == 1 then
        local v_u_14 = ...
        return function(p15)
            -- upvalues: (copy) v_u_14
            if p15 == v_u_14 then
                return true
            end
            local v16 = v_u_14
            return false, string.format("expected %s, got %s", tostring(v16), (tostring(p15)))
        end
    end
    local v17 = {}
    for v18 = 1, v13 do
        local v19 = select(v18, ...)
        v17[v18] = v_u_8.literal(v19)
    end
    return v_u_8.union(table.unpack(v17, 1, v13))
end
v_u_8.exactly = v_u_8.literal
function v_u_8.keyOf(p20) -- name: keyOf
    -- upvalues: (copy) v_u_8
    local v21 = 0
    local v22 = {}
    for v23 in pairs(p20) do
        v21 = v21 + 1
        v22[v21] = v23
    end
    return v_u_8.literal(table.unpack(v22, 1, v21))
end
function v_u_8.valueOf(p24) -- name: valueOf
    -- upvalues: (copy) v_u_8
    local v25 = 0
    local v26 = {}
    for _, v27 in pairs(p24) do
        v25 = v25 + 1
        v26[v25] = v27
    end
    return v_u_8.literal(table.unpack(v26, 1, v25))
end
function v_u_8.integer(p28) -- name: integer
    -- upvalues: (copy) v_u_8
    local v29, v30 = v_u_8.number(p28)
    if v29 then
        if p28 % 1 == 0 then
            return true
        else
            return false, string.format("integer expected, got %s", p28)
        end
    else
        return false, v30 or ""
    end
end
function v_u_8.numberMin(p_u_31) -- name: numberMin
    -- upvalues: (copy) v_u_8
    return function(p32)
        -- upvalues: (ref) v_u_8, (copy) p_u_31
        local v33, v34 = v_u_8.number(p32)
        if v33 then
            if p_u_31 <= p32 then
                return true
            else
                return false, string.format("number >= %s expected, got %s", p_u_31, p32)
            end
        else
            return false, v34 or ""
        end
    end
end
function v_u_8.numberMax(p_u_35) -- name: numberMax
    -- upvalues: (copy) v_u_8
    return function(p36)
        -- upvalues: (ref) v_u_8, (copy) p_u_35
        local v37, v38 = v_u_8.number(p36)
        if v37 then
            if p36 <= p_u_35 then
                return true
            else
                return false, string.format("number <= %s expected, got %s", p_u_35, p36)
            end
        else
            return false, v38
        end
    end
end
function v_u_8.numberMinExclusive(p_u_39) -- name: numberMinExclusive
    -- upvalues: (copy) v_u_8
    return function(p40)
        -- upvalues: (ref) v_u_8, (copy) p_u_39
        local v41, v42 = v_u_8.number(p40)
        if v41 then
            if p_u_39 < p40 then
                return true
            else
                return false, string.format("number > %s expected, got %s", p_u_39, p40)
            end
        else
            return false, v42 or ""
        end
    end
end
function v_u_8.numberMaxExclusive(p_u_43) -- name: numberMaxExclusive
    -- upvalues: (copy) v_u_8
    return function(p44)
        -- upvalues: (ref) v_u_8, (copy) p_u_43
        local v45, v46 = v_u_8.number(p44)
        if v45 then
            if p44 < p_u_43 then
                return true
            else
                return false, string.format("number < %s expected, got %s", p_u_43, p44)
            end
        else
            return false, v46 or ""
        end
    end
end
v_u_8.numberPositive = v_u_8.numberMinExclusive(0)
v_u_8.numberNegative = v_u_8.numberMaxExclusive(0)
function v_u_8.numberConstrained(p47, p48) -- name: numberConstrained
    -- upvalues: (copy) v_u_8
    local number = v_u_8.number
    assert(number(p47))
    local number_0 = v_u_8.number
    assert(number_0(p48))
    local v_u_51 = v_u_8.numberMin(p47)
    local v_u_52 = v_u_8.numberMax(p48)
    return function(p53)
        -- upvalues: (copy) v_u_51, (copy) v_u_52
        local v54, v55 = v_u_51(p53)
        if v54 then
            local v56, v57 = v_u_52(p53)
            if v56 then
                return true
            else
                return false, v57 or ""
            end
        else
            return false, v55 or ""
        end
    end
end
function v_u_8.numberConstrainedExclusive(p58, p59) -- name: numberConstrainedExclusive
    -- upvalues: (copy) v_u_8
    local number_1 = v_u_8.number
    assert(number_1(p58))
    local number_2 = v_u_8.number
    assert(number_2(p59))
    local v_u_62 = v_u_8.numberMinExclusive(p58)
    local v_u_63 = v_u_8.numberMaxExclusive(p59)
    return function(p64)
        -- upvalues: (copy) v_u_62, (copy) v_u_63
        local v65, v66 = v_u_62(p64)
        if v65 then
            local v67, v68 = v_u_63(p64)
            if v67 then
                return true
            else
                return false, v68 or ""
            end
        else
            return false, v66 or ""
        end
    end
end
function v_u_8.match(p_u_69) -- name: match
    -- upvalues: (copy) v_u_8
    local string = v_u_8.string
    assert(string(p_u_69))
    return function(p71)
        -- upvalues: (ref) v_u_8, (copy) p_u_69
        local v72, v73 = v_u_8.string(p71)
        if v72 then
            if string.match(p71, p_u_69) == nil then
                return false, string.format("%q failed to match pattern %q", p71, p_u_69)
            else
                return true
            end
        else
            return false, v73
        end
    end
end
function v_u_8.optional(p_u_74) -- name: optional
    -- upvalues: (copy) v_u_8
    local callback = v_u_8.callback
    assert(callback(p_u_74))
    return function(p76)
        -- upvalues: (copy) p_u_74
        if p76 == nil then
            return true
        else
            local v77, v78 = p_u_74(p76)
            if v77 then
                return true
            else
                return false, string.format("(optional) %s", v78 or "")
            end
        end
    end
end
function v_u_8.tuple(...) -- name: tuple
    local v_u_79 = { ... }
    return function(...)
        -- upvalues: (copy) v_u_79
        local v80 = { ... }
        for v81, v82 in ipairs(v_u_79) do
            local v83, v84 = v82(v80[v81])
            if v83 == false then
                return false, string.format("Bad tuple index #%s:\n\t%s", v81, v84 or "")
            end
        end
        return true
    end
end
function v_u_8.keys(p_u_85) -- name: keys
    -- upvalues: (copy) v_u_8
    local callback_0 = v_u_8.callback
    assert(callback_0(p_u_85))
    return function(p87)
        -- upvalues: (ref) v_u_8, (copy) p_u_85
        local v88, v89 = v_u_8.table(p87)
        if v88 == false then
            return false, v89 or ""
        end
        for v90 in pairs(p87) do
            local v91, v92 = p_u_85(v90)
            if v91 == false then
                return false, string.format("bad key %s:\n\t%s", tostring(v90), v92 or "")
            end
        end
        return true
    end
end
function v_u_8.values(p_u_93) -- name: values
    -- upvalues: (copy) v_u_8
    local callback_1 = v_u_8.callback
    assert(callback_1(p_u_93))
    return function(p95)
        -- upvalues: (ref) v_u_8, (copy) p_u_93
        local v96, v97 = v_u_8.table(p95)
        if v96 == false then
            return false, v97 or ""
        end
        for v98, v99 in pairs(p95) do
            local v100, v101 = p_u_93(v99)
            if v100 == false then
                return false, string.format("bad value for key %s:\n\t%s", tostring(v98), v101 or "")
            end
        end
        return true
    end
end
function v_u_8.map(p102, p103) -- name: map
    -- upvalues: (copy) v_u_8
    local callback_2 = v_u_8.callback
    assert(callback_2(p102))
    local callback_3 = v_u_8.callback
    assert(callback_3(p103))
    local v_u_106 = v_u_8.keys(p102)
    local v_u_107 = v_u_8.values(p103)
    return function(p108)
        -- upvalues: (copy) v_u_106, (copy) v_u_107
        local v109, v110 = v_u_106(p108)
        if v109 then
            local v111, v112 = v_u_107(p108)
            if v111 then
                return true
            else
                return false, v112 or ""
            end
        else
            return false, v110 or ""
        end
    end
end
function v_u_8.set(p113) -- name: set
    -- upvalues: (copy) v_u_8
    return v_u_8.map(p113, v_u_8.literal(true))
end
local v_u_114 = v_u_8.keys(v_u_8.integer)
function v_u_8.array(p115) -- name: array
    -- upvalues: (copy) v_u_8, (copy) v_u_114
    local callback_4 = v_u_8.callback
    assert(callback_4(p115))
    local v_u_117 = v_u_8.values(p115)
    return function(p118)
        -- upvalues: (ref) v_u_114, (copy) v_u_117
        local v119, v120 = v_u_114(p118)
        if v119 == false then
            return false, string.format("[array] %s", v120 or "")
        else
            local v121 = 0
            for _ in ipairs(p118) do
                v121 = v121 + 1
            end
            for v122 in pairs(p118) do
                if v122 < 1 or v121 < v122 then
                    return false, string.format("[array] key %s must be sequential", (tostring(v122)))
                end
            end
            local v123, v124 = v_u_117(p118)
            if v123 then
                return true
            else
                return false, string.format("[array] %s", v124 or "")
            end
        end
    end
end
function v_u_8.strictArray(...) -- name: strictArray
    -- upvalues: (copy) v_u_8, (copy) v_u_114
    local v_u_125 = { ... }
    local v126 = v_u_8.array(v_u_8.callback)
    assert(v126(v_u_125))
    return function(p127)
        -- upvalues: (ref) v_u_114, (copy) v_u_125
        local v128, v129 = v_u_114(p127)
        if v128 == false then
            return false, string.format("[strictArray] %s", v129 or "")
        end
        if #v_u_125 < #p127 then
            return false, string.format("[strictArray] Array size exceeds limit of %d", #v_u_125)
        end
        for v130, v131 in pairs(v_u_125) do
            local v132, v133 = v131(p127[v130])
            if not v132 then
                return false, string.format("[strictArray] Array index #%d - %s", v130, v133)
            end
        end
        return true
    end
end
local v_u_134 = v_u_8.array(v_u_8.callback)
function v_u_8.union(...) -- name: union
    -- upvalues: (copy) v_u_134
    local v_u_135 = { ... }
    local v136 = v_u_134
    assert(v136(v_u_135))
    return function(p137)
        -- upvalues: (copy) v_u_135
        for _, v138 in ipairs(v_u_135) do
            if v138(p137) then
                return true
            end
        end
        return false, "bad type for union"
    end
end
v_u_8.some = v_u_8.union
function v_u_8.intersection(...) -- name: intersection
    -- upvalues: (copy) v_u_134
    local v_u_139 = { ... }
    local v140 = v_u_134
    assert(v140(v_u_139))
    return function(p141)
        -- upvalues: (copy) v_u_139
        for _, v142 in ipairs(v_u_139) do
            local v143, v144 = v142(p141)
            if not v143 then
                return false, v144 or ""
            end
        end
        return true
    end
end
v_u_8.every = v_u_8.intersection
local v_u_145 = v_u_8.map(v_u_8.any, v_u_8.callback)
function v_u_8.interface(p_u_146) -- name: interface
    -- upvalues: (copy) v_u_145, (copy) v_u_8
    local v147 = v_u_145
    assert(v147(p_u_146))
    return function(p148)
        -- upvalues: (ref) v_u_8, (copy) p_u_146
        local v149, v150 = v_u_8.table(p148)
        if v149 == false then
            return false, v150 or ""
        end
        for v151, v152 in pairs(p_u_146) do
            local v153, v154 = v152(p148[v151])
            if v153 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(v151), v154 or "")
            end
        end
        return true
    end
end
function v_u_8.strictInterface(p_u_155) -- name: strictInterface
    -- upvalues: (copy) v_u_145, (copy) v_u_8
    local v156 = v_u_145
    assert(v156(p_u_155))
    return function(p157)
        -- upvalues: (ref) v_u_8, (copy) p_u_155
        local v158, v159 = v_u_8.table(p157)
        if v158 == false then
            return false, v159 or ""
        end
        for v160, v161 in pairs(p_u_155) do
            local v162, v163 = v161(p157[v160])
            if v162 == false then
                return false, string.format("[interface] bad value for %s:\n\t%s", tostring(v160), v163 or "")
            end
        end
        for v164 in pairs(p157) do
            if not p_u_155[v164] then
                return false, string.format("[interface] unexpected field %q", (tostring(v164)))
            end
        end
        return true
    end
end
function v_u_8.instanceOf(p_u_165, p166) -- name: instanceOf
    -- upvalues: (copy) v_u_8
    local string_0 = v_u_8.string
    assert(string_0(p_u_165))
    local v_u_168
    if p166 == nil then
        v_u_168 = nil
    else
        v_u_168 = v_u_8.children(p166)
    end
    return function(p169)
        -- upvalues: (ref) v_u_8, (copy) p_u_165, (ref) v_u_168
        local v170, v171 = v_u_8.Instance(p169)
        if not v170 then
            return false, v171 or ""
        end
        if p169.ClassName ~= p_u_165 then
            return false, string.format("%s expected, got %s", p_u_165, p169.ClassName)
        end
        if v_u_168 then
            local v172, v173 = v_u_168(p169)
            if not v172 then
                return false, v173
            end
        end
        return true
    end
end
v_u_8.instance = v_u_8.instanceOf
function v_u_8.instanceIsA(p_u_174, p175) -- name: instanceIsA
    -- upvalues: (copy) v_u_8
    local string_1 = v_u_8.string
    assert(string_1(p_u_174))
    local v_u_177
    if p175 == nil then
        v_u_177 = nil
    else
        v_u_177 = v_u_8.children(p175)
    end
    return function(p178)
        -- upvalues: (ref) v_u_8, (copy) p_u_174, (ref) v_u_177
        local v179, v180 = v_u_8.Instance(p178)
        if not v179 then
            return false, v180 or ""
        end
        if not p178:IsA(p_u_174) then
            return false, string.format("%s expected, got %s", p_u_174, p178.ClassName)
        end
        if v_u_177 then
            local v181, v182 = v_u_177(p178)
            if not v181 then
                return false, v182
            end
        end
        return true
    end
end
function v_u_8.enum(p_u_183) -- name: enum
    -- upvalues: (copy) v_u_8
    local Enum = v_u_8.Enum
    assert(Enum(p_u_183))
    return function(p185)
        -- upvalues: (ref) v_u_8, (copy) p_u_183
        local v186, v187 = v_u_8.EnumItem(p185)
        if not v186 then
            return false, v187
        end
        if p185.EnumType == p_u_183 then
            return true
        end
        local format = string.format
        local v189 = p_u_183
        local v190 = tostring(v189)
        local EnumType = p185.EnumType
        return false, format("enum of %s expected, got enum of %s", v190, (tostring(EnumType)))
    end
end
local v_u_192 = v_u_8.tuple(v_u_8.callback, v_u_8.callback)
function v_u_8.wrap(p_u_193, p_u_194) -- name: wrap
    -- upvalues: (copy) v_u_192
    local v195 = v_u_192
    assert(v195(p_u_193, p_u_194))
    return function(...)
        -- upvalues: (copy) p_u_194, (copy) p_u_193
        local v196 = p_u_194
        assert(v196(...))
        return p_u_193(...)
    end
end
function v_u_8.strict(p_u_197) -- name: strict
    return function(...)
        -- upvalues: (copy) p_u_197
        local v198 = p_u_197
        assert(v198(...))
    end
end
local v_u_199 = v_u_8.map(v_u_8.string, v_u_8.callback)
function v_u_8.children(p_u_200) -- name: children
    -- upvalues: (copy) v_u_199, (copy) v_u_8
    local v201 = v_u_199
    assert(v201(p_u_200))
    return function(p202)
        -- upvalues: (ref) v_u_8, (copy) p_u_200
        local v203, v204 = v_u_8.Instance(p202)
        if not v203 then
            return false, v204 or ""
        end
        local v205 = {}
        for _, v206 in ipairs(p202:GetChildren()) do
            local Name = v206.Name
            if p_u_200[Name] then
                if v205[Name] then
                    return false, string.format("Cannot process multiple children with the same name %q", Name)
                end
                v205[Name] = v206
            end
        end
        for v208, v209 in pairs(p_u_200) do
            local v210, v211 = v209(v205[v208])
            if not v210 then
                return false, string.format("[%s.%s] %s", p202:GetFullName(), v208, v211 or "")
            end
        end
        return true
    end
end
return v_u_8
