-- Decompiled with Medal

local v_u_1 = {
    ["__mode"] = "k"
}
local function v7(p_u_2, p3) -- name: makeEnum
    local v4 = {}
    for _, v5 in ipairs(p3) do
        v4[v5] = v5
    end
    return setmetatable(v4, {
        ["__index"] = function(_, p6) -- name: __index
            -- upvalues: (copy) p_u_2
            error(string.format("%s is not in %s!", p6, p_u_2), 2)
        end,
        ["__newindex"] = function() -- name: __newindex
            -- upvalues: (copy) p_u_2
            error(string.format("Creating new members in %s is not allowed!", p_u_2), 2)
        end
    })
end
local v_u_8 = {
    ["Kind"] = v7("Promise.Error.Kind", {
        "ExecutionError",
        "AlreadyCancelled",
        "NotResolvedInTime",
        "TimedOut"
    })
}
v_u_8.__index = v_u_8
function v_u_8.new(p9, p10) -- name: new
    -- upvalues: (ref) v_u_8
    local v11 = p9 or {}
    local v12 = {}
    local error = v11.error
    v12.error = tostring(error) or "[This error has no error text.]"
    v12.trace = v11.trace
    v12.context = v11.context
    v12.kind = v11.kind
    v12.parent = p10
    v12.createdTick = os.clock()
    v12.createdTrace = debug.traceback()
    local v14 = v_u_8
    return setmetatable(v12, v14)
end
function v_u_8.is(p15) -- name: is
    if type(p15) == "table" then
        local v16 = getmetatable(p15)
        if type(v16) == "table" then
            local v17
            if rawget(p15, "error") == nil then
                v17 = false
            else
                local v18 = rawget(v16, "extend")
                v17 = type(v18) == "function"
            end
            return v17
        end
    end
    return false
end
function v_u_8.isKind(p19, p20) -- name: isKind
    -- upvalues: (ref) v_u_8
    local v21 = p20 ~= nil
    assert(v21, "Argument #2 to Promise.Error.isKind must not be nil")
    local v22 = v_u_8.is(p19)
    if v22 then
        v22 = p19.kind == p20
    end
    return v22
end
function v_u_8.extend(p23, p24) -- name: extend
    -- upvalues: (ref) v_u_8
    local v25 = p24 or {}
    v25.kind = v25.kind or p23.kind
    return v_u_8.new(v25, p23)
end
function v_u_8.getErrorChain(p26) -- name: getErrorChain
    local v27 = { p26 }
    while v27[#v27].parent do
        local parent = v27[#v27].parent
        table.insert(v27, parent)
    end
    return v27
end
function v_u_8.__tostring(p29) -- name: __tostring
    local v30 = { string.format("-- Promise.Error(%s) --", p29.kind or "?") }
    for _, v31 in ipairs(p29:getErrorChain()) do
        local concat = table.concat
        local v33 = { v31.trace or v31.error, v31.context }
        table.insert(v30, concat(v33, "\n"))
    end
    return table.concat(v30, "\n")
end
local function v_u_34(...) -- name: pack
    return select("#", ...), { ... }
end
local function v_u_36(p35, ...) -- name: packResult
    return p35, select("#", ...), { ... }
end
local function v_u_43(p_u_37, p38, ...) -- name: runExecutor
    -- upvalues: (copy) v_u_36, (ref) v_u_8
    local v39 = v_u_36
    local v40 = xpcall
    local v41 = p_u_37 ~= nil
    assert(v41)
    return v39(v40(p38, function(p42)
        -- upvalues: (ref) v_u_8, (copy) p_u_37
        if type(p42) == "table" then
            return p42
        else
            return v_u_8.new({
                ["error"] = p42,
                ["kind"] = v_u_8.Kind.ExecutionError,
                ["trace"] = debug.traceback(tostring(p42), 2),
                ["context"] = "Promise created at:\n\n" .. p_u_37
            })
        end
    end, ...))
end
local v_u_44 = {
    ["Error"] = v_u_8,
    ["Status"] = v7("Promise.Status", {
        "Started",
        "Resolved",
        "Rejected",
        "Cancelled"
    }),
    ["_getTime"] = os.clock,
    ["_timeEvent"] = game:GetService("RunService").Heartbeat,
    ["prototype"] = {}
}
v_u_44.__index = v_u_44.prototype
function v_u_44._new(p45, p_u_46, p47) -- name: _new
    -- upvalues: (copy) v_u_44, (copy) v_u_1, (copy) v_u_43
    if p47 ~= nil and not v_u_44.is(p47) then
        error("Argument #2 to Promise.new must be a promise or nil", 2)
    end
    local v_u_48 = {
        ["_source"] = nil,
        ["_status"] = nil,
        ["_values"] = nil,
        ["_valuesLength"] = -1,
        ["_unhandledRejection"] = true,
        ["_queuedResolve"] = nil,
        ["_queuedReject"] = nil,
        ["_queuedFinally"] = nil,
        ["_cancellationHook"] = nil,
        ["_parent"] = nil,
        ["_consumers"] = nil,
        ["_source"] = p45,
        ["_status"] = v_u_44.Status.Started,
        ["_queuedResolve"] = {},
        ["_queuedReject"] = {},
        ["_queuedFinally"] = {},
        ["_parent"] = p47
    }
    local v49 = v_u_1
    v_u_48._consumers = setmetatable({}, v49)
    if p47 and p47._status == v_u_44.Status.Started then
        p47._consumers[v_u_48] = true
    end
    local v50 = v_u_44
    setmetatable(v_u_48, v50)
    local function v_u_51(...) -- name: resolve
        -- upvalues: (copy) v_u_48
        v_u_48:_resolve(...)
    end
    local function v_u_52(...) -- name: reject
        -- upvalues: (copy) v_u_48
        v_u_48:_reject(...)
    end
    local function v_u_54(p53) -- name: onCancel
        -- upvalues: (copy) v_u_48, (ref) v_u_44
        if p53 then
            if v_u_48._status == v_u_44.Status.Cancelled then
                p53()
            else
                v_u_48._cancellationHook = p53
            end
        end
        return v_u_48._status == v_u_44.Status.Cancelled
    end
    coroutine.wrap(function()
        -- upvalues: (ref) v_u_43, (copy) v_u_48, (copy) p_u_46, (copy) v_u_51, (copy) v_u_52, (copy) v_u_54
        local v55, _, v56 = v_u_43(v_u_48._source, p_u_46, v_u_51, v_u_52, v_u_54)
        if not v55 then
            v_u_52(v56[1])
        end
    end)()
    return v_u_48
end
function v_u_44.new(p57) -- name: new
    -- upvalues: (copy) v_u_44
    return v_u_44._new(debug.traceback(nil, 2), p57)
end
function v_u_44.__tostring(p58) -- name: __tostring
    return string.format("Promise(%s)", p58:getStatus())
end
function v_u_44.defer(p_u_59) -- name: defer
    -- upvalues: (copy) v_u_44, (copy) v_u_43
    local v_u_60 = debug.traceback(nil, 2)
    return v_u_44._new(v_u_60, function(p_u_61, p_u_62, p_u_63)
        -- upvalues: (ref) v_u_44, (ref) v_u_43, (copy) v_u_60, (copy) p_u_59
        local v_u_64 = nil
        v_u_64 = v_u_44._timeEvent:Connect(function()
            -- upvalues: (ref) v_u_64, (ref) v_u_43, (ref) v_u_60, (ref) p_u_59, (copy) p_u_61, (copy) p_u_62, (copy) p_u_63
            v_u_64:Disconnect()
            local v65, _, v66 = v_u_43(v_u_60, p_u_59, p_u_61, p_u_62, p_u_63)
            if not v65 then
                p_u_62(v66[1])
            end
        end)
    end)
end
v_u_44.async = v_u_44.defer
function v_u_44.resolve(...) -- name: resolve
    -- upvalues: (copy) v_u_34, (copy) v_u_44
    local v_u_67, v_u_68 = v_u_34(...)
    return v_u_44._new(debug.traceback(nil, 2), function(p69)
        -- upvalues: (copy) v_u_68, (copy) v_u_67
        local v70 = v_u_68
        local v71 = v_u_67
        p69(unpack(v70, 1, v71))
    end)
end
function v_u_44.reject(...) -- name: reject
    -- upvalues: (copy) v_u_34, (copy) v_u_44
    local v_u_72, v_u_73 = v_u_34(...)
    return v_u_44._new(debug.traceback(nil, 2), function(_, p74)
        -- upvalues: (copy) v_u_73, (copy) v_u_72
        local v75 = v_u_73
        local v76 = v_u_72
        p74(unpack(v75, 1, v76))
    end)
end
function v_u_44._try(p77, p_u_78, ...) -- name: _try
    -- upvalues: (copy) v_u_34, (copy) v_u_44
    local v_u_79, v_u_80 = v_u_34(...)
    return v_u_44._new(p77, function(p81)
        -- upvalues: (copy) p_u_78, (copy) v_u_80, (copy) v_u_79
        local v82 = v_u_80
        local v83 = v_u_79
        p81(p_u_78(unpack(v82, 1, v83)))
    end)
end
function v_u_44.try(...) -- name: try
    -- upvalues: (copy) v_u_44
    return v_u_44._try(debug.traceback(nil, 2), ...)
end
function v_u_44._all(p84, p_u_85, p_u_86) -- name: _all
    -- upvalues: (copy) v_u_44
    if type(p_u_85) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3)
    end
    for v87, v88 in pairs(p_u_85) do
        if not v_u_44.is(v88) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(v87))), 3)
        end
    end
    if #p_u_85 == 0 or p_u_86 == 0 then
        return v_u_44.resolve({})
    else
        return v_u_44._new(p84, function(p_u_89, p_u_90, p91)
            -- upvalues: (copy) p_u_86, (copy) p_u_85
            local v_u_92 = {}
            local v_u_93 = {}
            local v_u_94 = 0
            local v_u_95 = 0
            local v_u_96 = false
            local function v_u_99(p97, ...) -- name: resolveOne
                -- upvalues: (ref) v_u_96, (ref) v_u_94, (ref) p_u_86, (copy) v_u_92, (ref) p_u_85, (copy) p_u_89, (copy) v_u_93
                if not v_u_96 then
                    v_u_94 = v_u_94 + 1
                    if p_u_86 == nil then
                        v_u_92[p97] = ...
                    else
                        v_u_92[v_u_94] = ...
                    end
                    if v_u_94 >= (p_u_86 or #p_u_85) then
                        v_u_96 = true
                        p_u_89(v_u_92)
                        for _, v98 in ipairs(v_u_93) do
                            v98:cancel()
                        end
                    end
                end
            end
            p91(function() -- name: cancel
                -- upvalues: (copy) v_u_93
                for _, v100 in ipairs(v_u_93) do
                    v100:cancel()
                end
            end)
            local v_u_101 = v_u_96
            for v_u_102, v103 in ipairs(p_u_85) do
                v_u_93[v_u_102] = v103:andThen(function(...)
                    -- upvalues: (copy) v_u_99, (copy) v_u_102
                    v_u_99(v_u_102, ...)
                end, function(...)
                    -- upvalues: (ref) v_u_95, (ref) p_u_86, (ref) p_u_85, (copy) v_u_93, (ref) v_u_101, (copy) p_u_90
                    v_u_95 = v_u_95 + 1
                    if p_u_86 == nil or #p_u_85 - v_u_95 < p_u_86 then
                        for _, v104 in ipairs(v_u_93) do
                            v104:cancel()
                        end
                        v_u_101 = true
                        p_u_90(...)
                    end
                end)
            end
            if v_u_101 then
                for _, v105 in ipairs(v_u_93) do
                    v105:cancel()
                end
            end
        end)
    end
end
function v_u_44.all(p106) -- name: all
    -- upvalues: (copy) v_u_44
    return v_u_44._all(debug.traceback(nil, 2), p106)
end
function v_u_44.some(p107, p108) -- name: some
    -- upvalues: (copy) v_u_44
    local v109 = type(p108) == "number"
    assert(v109, "Bad argument #2 to Promise.some: must be a number")
    return v_u_44._all(debug.traceback(nil, 2), p107, p108)
end
function v_u_44.any(p110) -- name: any
    -- upvalues: (copy) v_u_44
    return v_u_44._all(debug.traceback(nil, 2), p110, 1):andThen(function(p111)
        return p111[1]
    end)
end
function v_u_44.allSettled(p_u_112) -- name: allSettled
    -- upvalues: (copy) v_u_44
    if type(p_u_112) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2)
    end
    for v113, v114 in pairs(p_u_112) do
        if not v_u_44.is(v114) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(v113))), 2)
        end
    end
    if #p_u_112 == 0 then
        return v_u_44.resolve({})
    else
        return v_u_44._new(debug.traceback(nil, 2), function(p_u_115, _, p116)
            -- upvalues: (copy) p_u_112
            local v_u_117 = {}
            local v_u_118 = {}
            local v_u_119 = 0
            local function v_u_121(p120, ...) -- name: resolveOne
                -- upvalues: (ref) v_u_119, (copy) v_u_117, (ref) p_u_112, (copy) p_u_115
                v_u_119 = v_u_119 + 1
                v_u_117[p120] = ...
                if v_u_119 >= #p_u_112 then
                    p_u_115(v_u_117)
                end
            end
            p116(function()
                -- upvalues: (copy) v_u_118
                for _, v122 in ipairs(v_u_118) do
                    v122:cancel()
                end
            end)
            for v_u_123, v124 in ipairs(p_u_112) do
                v_u_118[v_u_123] = v124:finally(function(...)
                    -- upvalues: (copy) v_u_121, (copy) v_u_123
                    v_u_121(v_u_123, ...)
                end)
            end
        end)
    end
end
function v_u_44.race(p_u_125) -- name: race
    -- upvalues: (copy) v_u_44
    local v126 = type(p_u_125) == "table"
    local format = string.format
    assert(v126, format("Please pass a list of promises to %s", "Promise.race"))
    for v128, v129 in pairs(p_u_125) do
        local v130 = v_u_44.is(v129)
        local format_0 = string.format
        local v132 = tostring(v128)
        assert(v130, format_0("Non-promise value passed into %s at index %s", "Promise.race", v132))
    end
    return v_u_44._new(debug.traceback(nil, 2), function(p_u_133, p_u_134, p135)
        -- upvalues: (copy) p_u_125
        local v_u_136 = {}
        local v_u_137 = false
        if not p135(function(...)
            -- upvalues: (copy) v_u_136, (ref) v_u_137, (copy) p_u_134
            for _, v138 in ipairs(v_u_136) do
                v138:cancel()
            end
            v_u_137 = true
            return p_u_134(...)
        end) then
            local v_u_139 = v_u_137
            for v140, v141 in ipairs(p_u_125) do
                v_u_136[v140] = v141:andThen(function(...)
                    -- upvalues: (copy) v_u_136, (ref) v_u_139, (copy) p_u_133
                    for _, v142 in ipairs(v_u_136) do
                        v142:cancel()
                    end
                    v_u_139 = true
                    return p_u_133(...)
                end, function(...)
                    -- upvalues: (copy) v_u_136, (ref) v_u_139, (copy) p_u_134
                    for _, v143 in ipairs(v_u_136) do
                        v143:cancel()
                    end
                    v_u_139 = true
                    return p_u_134(...)
                end)
            end
            if v_u_139 then
                for _, v144 in ipairs(v_u_136) do
                    v144:cancel()
                end
            end
        end
    end)
end
function v_u_44.each(p_u_145, p_u_146) -- name: each
    -- upvalues: (copy) v_u_44, (ref) v_u_8
    local v147 = type(p_u_145) == "table"
    local format_1 = string.format
    assert(v147, format_1("Please pass a list of promises to %s", "Promise.each"))
    local v149 = type(p_u_146) == "function"
    local format_2 = string.format
    assert(v149, format_2("Please pass a handler function to %s!", "Promise.each"))
    return v_u_44._new(debug.traceback(nil, 2), function(p151, p152, p153)
        -- upvalues: (copy) p_u_145, (ref) v_u_44, (ref) v_u_8, (copy) p_u_146
        local v154 = {}
        local v_u_155 = {}
        local v_u_156 = false
        p153(function()
            -- upvalues: (ref) v_u_156, (copy) v_u_155
            v_u_156 = true
            for _, v157 in ipairs(v_u_155) do
                v157:cancel()
            end
        end)
        local v158 = v_u_156
        local v159 = {}
        for v160, v161 in ipairs(p_u_145) do
            if v_u_44.is(v161) then
                if v161:getStatus() == v_u_44.Status.Cancelled then
                    for _, v162 in ipairs(v_u_155) do
                        v162:cancel()
                    end
                    return p152(v_u_8.new({
                        ["error"] = "Promise is cancelled",
                        ["kind"] = nil,
                        ["context"] = nil,
                        ["kind"] = v_u_8.Kind.AlreadyCancelled,
                        ["context"] = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", v160, v161._source)
                    }))
                end
                if v161:getStatus() == v_u_44.Status.Rejected then
                    for _, v163 in ipairs(v_u_155) do
                        v163:cancel()
                    end
                    return p152(select(2, v161:await()))
                end
                local v164 = v161:andThen(function(...)
                    return ...
                end)
                table.insert(v_u_155, v164)
                v159[v160] = v164
            else
                v159[v160] = v161
            end
        end
        for v165, v168 in ipairs(v159) do
            if v_u_44.is(v168) then
                local v167, v168 = v168:await()
                if not v167 then
                    for _, v169 in ipairs(v_u_155) do
                        v169:cancel()
                    end
                    return p152(v168)
                end
            end
            if v158 then
                return
            end
            local v170 = v_u_44.resolve(p_u_146(v168, v165))
            table.insert(v_u_155, v170)
            local v171, v172 = v170:await()
            if not v171 then
                for _, v173 in ipairs(v_u_155) do
                    v173:cancel()
                end
                return p152(v172)
            end
            v154[v165] = v172
        end
        p151(v154)
    end)
end
function v_u_44.is(p174) -- name: is
    -- upvalues: (copy) v_u_44
    if type(p174) == "table" then
        local v175 = getmetatable(p174)
        if v175 == v_u_44 then
            return true
        elseif v175 == nil then
            local andThen = p174.andThen
            return type(andThen) == "function"
        else
            if type(v175) == "table" then
                local v177 = rawget(v175, "__index")
                if type(v177) == "table" then
                    local v178 = rawget(v175, "__index")
                    local v179 = rawget(v178, "andThen")
                    if type(v179) == "function" then
                        return true
                    end
                end
            end
            return false
        end
    else
        return false
    end
end
function v_u_44.promisify(p_u_180) -- name: promisify
    -- upvalues: (copy) v_u_44
    return function(...)
        -- upvalues: (ref) v_u_44, (copy) p_u_180
        return v_u_44._try(debug.traceback(nil, 2), p_u_180, ...)
    end
end
local next = nil
local v_u_182 = nil
function v_u_44.delay(p183) -- name: delay
    -- upvalues: (copy) v_u_44, (ref) v_u_182, (ref) next
    local v184 = type(p183) == "number"
    assert(v184, "Bad argument #1 to Promise.delay, must be a number.")
    local v_u_185 = (p183 < 0.016666666666666666 or p183 == (1 / 0)) and 0.016666666666666666 or p183
    return v_u_44._new(debug.traceback(nil, 2), function(p186, _, p187)
        -- upvalues: (ref) v_u_44, (ref) v_u_185, (ref) v_u_182, (ref) next
        local v188 = v_u_44._getTime()
        local v189 = v188 + v_u_185
        local v_u_190 = {
            ["resolve"] = p186,
            ["startTime"] = v188,
            ["endTime"] = v189
        }
        if v_u_182 == nil then
            next = v_u_190
            v_u_182 = v_u_44._timeEvent:Connect(function()
                -- upvalues: (ref) v_u_44, (ref) next, (ref) v_u_182
                local v191 = v_u_44._getTime()
                while next ~= nil and next.endTime < v191 do
                    local v192 = next
                    next = v192.next
                    if next == nil then
                        v_u_182:Disconnect()
                        v_u_182 = nil
                    else
                        next.previous = nil
                    end
                    v192.resolve(v_u_44._getTime() - v192.startTime)
                end
            end)
        elseif next.endTime < v189 then
            local v193 = next
            local next_0 = v193.next
            while next_0 ~= nil and next_0.endTime < v189 do
                local next_1 = next_0.next
                v193 = next_0
                next_0 = next_1
            end
            v193.next = v_u_190
            v_u_190.previous = v193
            if next_0 ~= nil then
                v_u_190.next = next_0
                next_0.previous = v_u_190
            end
        else
            v_u_190.next = next
            next.previous = v_u_190
            next = v_u_190
        end
        p187(function()
            -- upvalues: (copy) v_u_190, (ref) next, (ref) v_u_182
            local next_2 = v_u_190.next
            if next == v_u_190 then
                if next_2 == nil then
                    v_u_182:Disconnect()
                    v_u_182 = nil
                else
                    next_2.previous = nil
                end
                next = next_2
            else
                local previous = v_u_190.previous
                previous.next = next_2
                if next_2 ~= nil then
                    next_2.previous = previous
                end
            end
        end)
    end)
end
local function v202(p198, p_u_199, p_u_200) -- name: timeout
    -- upvalues: (copy) v_u_44, (ref) v_u_8
    local v_u_201 = debug.traceback(nil, 2)
    return v_u_44.race({ v_u_44.delay(p_u_199):andThen(function()
            -- upvalues: (ref) v_u_44, (copy) p_u_200, (ref) v_u_8, (copy) p_u_199, (copy) v_u_201
            return v_u_44.reject(p_u_200 == nil and v_u_8.new({
                ["kind"] = nil,
                ["error"] = "Timed out",
                ["context"] = nil,
                ["kind"] = v_u_8.Kind.TimedOut,
                ["context"] = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", p_u_199, v_u_201)
            }) or p_u_200)
        end), p198 })
end
v_u_44.prototype.timeout = v202
function v_u_44.prototype.getStatus(p203) -- name: getStatus
    return p203._status
end
local function v228(p_u_204, p_u_205, p_u_206, p_u_207) -- name: _andThen
    -- upvalues: (copy) v_u_44, (copy) v_u_43, (ref) v_u_8
    p_u_204._unhandledRejection = false
    return v_u_44._new(p_u_205, function(p_u_208, p_u_209)
        -- upvalues: (copy) p_u_206, (copy) p_u_205, (ref) v_u_43, (copy) p_u_207, (copy) p_u_204, (ref) v_u_44, (ref) v_u_8
        local v210
        if p_u_206 then
            local v_u_211 = p_u_205
            local v_u_212 = p_u_206
            v210 = function(...)
                -- upvalues: (ref) v_u_43, (copy) v_u_211, (copy) v_u_212, (copy) p_u_208, (copy) p_u_209
                local v213, v214, v215 = v_u_43(v_u_211, v_u_212, ...)
                if v213 then
                    p_u_208(unpack(v215, 1, v214))
                else
                    p_u_209(v215[1])
                end
            end
        else
            v210 = p_u_208
        end
        local v216
        if p_u_207 then
            local v_u_217 = p_u_205
            local v_u_218 = p_u_207
            v216 = function(...)
                -- upvalues: (ref) v_u_43, (copy) v_u_217, (copy) v_u_218, (copy) p_u_208, (copy) p_u_209
                local v219, v220, v221 = v_u_43(v_u_217, v_u_218, ...)
                if v219 then
                    p_u_208(unpack(v221, 1, v220))
                else
                    p_u_209(v221[1])
                end
            end
        else
            v216 = p_u_209
        end
        if p_u_204._status == v_u_44.Status.Started then
            local _queuedResolve = p_u_204._queuedResolve
            table.insert(_queuedResolve, v210)
            local _queuedReject = p_u_204._queuedReject
            table.insert(_queuedReject, v216)
            return
        elseif p_u_204._status == v_u_44.Status.Resolved then
            local _values = p_u_204._values
            local _valuesLength = p_u_204._valuesLength
            v210(unpack(_values, 1, _valuesLength))
            return
        elseif p_u_204._status == v_u_44.Status.Rejected then
            local _values_0 = p_u_204._values
            local _valuesLength_0 = p_u_204._valuesLength
            v216(unpack(_values_0, 1, _valuesLength_0))
        elseif p_u_204._status == v_u_44.Status.Cancelled then
            p_u_209(v_u_8.new({
                ["error"] = "Promise is cancelled",
                ["kind"] = nil,
                ["context"] = nil,
                ["kind"] = v_u_8.Kind.AlreadyCancelled,
                ["context"] = "Promise created at\n\n" .. p_u_205
            }))
        end
    end, p_u_204)
end
v_u_44.prototype._andThen = v228
function v_u_44.prototype.andThen(p229, p230, p231) -- name: andThen
    local v232 = p230 == nil and true or type(p230) == "function"
    local format_3 = string.format
    assert(v232, format_3("Please pass a handler function to %s!", "Promise:andThen"))
    local v234 = p231 == nil and true or type(p231) == "function"
    local format_4 = string.format
    assert(v234, format_4("Please pass a handler function to %s!", "Promise:andThen"))
    return p229:_andThen(debug.traceback(nil, 2), p230, p231)
end
function v_u_44.prototype.catch(p236, p237) -- name: catch
    local v238 = p237 == nil and true or type(p237) == "function"
    local format_5 = string.format
    assert(v238, format_5("Please pass a handler function to %s!", "Promise:catch"))
    return p236:_andThen(debug.traceback(nil, 2), nil, p237)
end
function v_u_44.prototype.tap(p240, p_u_241) -- name: tap
    -- upvalues: (copy) v_u_44, (copy) v_u_34
    local v242 = type(p_u_241) == "function"
    local format_6 = string.format
    assert(v242, format_6("Please pass a handler function to %s!", "Promise:tap"))
    return p240:_andThen(debug.traceback(nil, 2), function(...)
        -- upvalues: (copy) p_u_241, (ref) v_u_44, (ref) v_u_34
        local v244 = p_u_241(...)
        if not v_u_44.is(v244) then
            return ...
        end
        local v_u_245, v_u_246 = v_u_34(...)
        return v244:andThen(function()
            -- upvalues: (copy) v_u_246, (copy) v_u_245
            local v247 = v_u_246
            local v248 = v_u_245
            return unpack(v247, 1, v248)
        end)
    end)
end
function v_u_44.prototype.andThenCall(p249, p_u_250, ...) -- name: andThenCall
    -- upvalues: (copy) v_u_34
    local v251 = type(p_u_250) == "function"
    local format_7 = string.format
    assert(v251, format_7("Please pass a handler function to %s!", "Promise:andThenCall"))
    local v_u_253, v_u_254 = v_u_34(...)
    return p249:_andThen(debug.traceback(nil, 2), function()
        -- upvalues: (copy) p_u_250, (copy) v_u_254, (copy) v_u_253
        local v255 = v_u_254
        local v256 = v_u_253
        return p_u_250(unpack(v255, 1, v256))
    end)
end
function v_u_44.prototype.andThenReturn(p257, ...) -- name: andThenReturn
    -- upvalues: (copy) v_u_34
    local v_u_258, v_u_259 = v_u_34(...)
    return p257:_andThen(debug.traceback(nil, 2), function()
        -- upvalues: (copy) v_u_259, (copy) v_u_258
        local v260 = v_u_259
        local v261 = v_u_258
        return unpack(v260, 1, v261)
    end)
end
function v_u_44.prototype.cancel(p262) -- name: cancel
    -- upvalues: (copy) v_u_44
    if p262._status == v_u_44.Status.Started then
        p262._status = v_u_44.Status.Cancelled
        if p262._cancellationHook then
            p262._cancellationHook()
        end
        if p262._parent then
            p262._parent:_consumerCancelled(p262)
        end
        for v263 in pairs(p262._consumers) do
            v263:cancel()
        end
        p262:_finalize()
    end
end
function v_u_44.prototype._consumerCancelled(p264, p265) -- name: _consumerCancelled
    -- upvalues: (copy) v_u_44
    if p264._status == v_u_44.Status.Started then
        p264._consumers[p265] = nil
        if next(p264._consumers) == nil then
            p264:cancel()
        end
    end
end
function v_u_44.prototype._finally(p_u_266, p_u_267, p_u_268, p_u_269) -- name: _finally
    -- upvalues: (copy) v_u_44, (copy) v_u_43
    if not p_u_269 then
        p_u_266._unhandledRejection = false
    end
    return v_u_44._new(p_u_267, function(p_u_270, p_u_271)
        -- upvalues: (copy) p_u_268, (copy) p_u_267, (ref) v_u_43, (copy) p_u_269, (copy) p_u_266, (ref) v_u_44
        local v_u_272
        if p_u_268 then
            local v_u_273 = p_u_267
            local v_u_274 = p_u_268
            v_u_272 = function(...)
                -- upvalues: (ref) v_u_43, (copy) v_u_273, (copy) v_u_274, (copy) p_u_270, (copy) p_u_271
                local v275, v276, v277 = v_u_43(v_u_273, v_u_274, ...)
                if v275 then
                    p_u_270(unpack(v277, 1, v276))
                else
                    p_u_271(v277[1])
                end
            end
        else
            v_u_272 = p_u_270
        end
        local v278 = p_u_269 and function(...)
            -- upvalues: (ref) p_u_266, (ref) v_u_44, (copy) p_u_270, (copy) v_u_272
            if p_u_266._status == v_u_44.Status.Rejected then
                return p_u_270(p_u_266)
            else
                return v_u_272(...)
            end
        end or v_u_272
        if p_u_266._status == v_u_44.Status.Started then
            local _queuedFinally = p_u_266._queuedFinally
            table.insert(_queuedFinally, v278)
        else
            v278(p_u_266._status)
        end
    end, p_u_266)
end
function v_u_44.prototype.finally(p280, p281) -- name: finally
    local v282 = p281 == nil and true or type(p281) == "function"
    local format_8 = string.format
    assert(v282, format_8("Please pass a handler function to %s!", "Promise:finally"))
    return p280:_finally(debug.traceback(nil, 2), p281)
end
function v_u_44.prototype.finallyCall(p284, p_u_285, ...) -- name: finallyCall
    -- upvalues: (copy) v_u_34
    local v286 = type(p_u_285) == "function"
    local format_9 = string.format
    assert(v286, format_9("Please pass a handler function to %s!", "Promise:finallyCall"))
    local v_u_288, v_u_289 = v_u_34(...)
    return p284:_finally(debug.traceback(nil, 2), function()
        -- upvalues: (copy) p_u_285, (copy) v_u_289, (copy) v_u_288
        local v290 = v_u_289
        local v291 = v_u_288
        return p_u_285(unpack(v290, 1, v291))
    end)
end
function v_u_44.prototype.finallyReturn(p292, ...) -- name: finallyReturn
    -- upvalues: (copy) v_u_34
    local v_u_293, v_u_294 = v_u_34(...)
    return p292:_finally(debug.traceback(nil, 2), function()
        -- upvalues: (copy) v_u_294, (copy) v_u_293
        local v295 = v_u_294
        local v296 = v_u_293
        return unpack(v295, 1, v296)
    end)
end
function v_u_44.prototype.done(p297, p298) -- name: done
    local v299 = p298 == nil and true or type(p298) == "function"
    local format_10 = string.format
    assert(v299, format_10("Please pass a handler function to %s!", "Promise:done"))
    return p297:_finally(debug.traceback(nil, 2), p298, true)
end
function v_u_44.prototype.doneCall(p301, p_u_302, ...) -- name: doneCall
    -- upvalues: (copy) v_u_34
    local v303 = type(p_u_302) == "function"
    local format_11 = string.format
    assert(v303, format_11("Please pass a handler function to %s!", "Promise:doneCall"))
    local v_u_305, v_u_306 = v_u_34(...)
    return p301:_finally(debug.traceback(nil, 2), function()
        -- upvalues: (copy) p_u_302, (copy) v_u_306, (copy) v_u_305
        local v307 = v_u_306
        local v308 = v_u_305
        return p_u_302(unpack(v307, 1, v308))
    end, true)
end
function v_u_44.prototype.doneReturn(p309, ...) -- name: doneReturn
    -- upvalues: (copy) v_u_34
    local v_u_310, v_u_311 = v_u_34(...)
    return p309:_finally(debug.traceback(nil, 2), function()
        -- upvalues: (copy) v_u_311, (copy) v_u_310
        local v312 = v_u_311
        local v313 = v_u_310
        return unpack(v312, 1, v313)
    end, true)
end
function v_u_44.prototype.awaitStatus(p314) -- name: awaitStatus
    -- upvalues: (copy) v_u_44
    p314._unhandledRejection = false
    if p314._status == v_u_44.Status.Started then
        local v_u_315 = Instance.new("BindableEvent")
        p314:finally(function()
            -- upvalues: (copy) v_u_315
            v_u_315:Fire()
        end)
        v_u_315.Event:Wait()
        v_u_315:Destroy()
    end
    if p314._status == v_u_44.Status.Resolved then
        local _status = p314._status
        local _values_1 = p314._values
        local _valuesLength_1 = p314._valuesLength
        return _status, unpack(_values_1, 1, _valuesLength_1)
    end
    if p314._status ~= v_u_44.Status.Rejected then
        return p314._status
    end
    local _status_0 = p314._status
    local _values_2 = p314._values
    local _valuesLength_2 = p314._valuesLength
    return _status_0, unpack(_values_2, 1, _valuesLength_2)
end
local function v_u_323(p322, ...) -- name: awaitHelper
    -- upvalues: (copy) v_u_44
    return p322 == v_u_44.Status.Resolved, ...
end
function v_u_44.prototype.await(p324) -- name: await
    -- upvalues: (copy) v_u_323
    return v_u_323(p324:awaitStatus())
end
local function v_u_326(p325, ...) -- name: expectHelper
    -- upvalues: (copy) v_u_44
    if p325 ~= v_u_44.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3)
    end
    return ...
end
function v_u_44.prototype.expect(p327) -- name: expect
    -- upvalues: (copy) v_u_326
    return v_u_326(p327:awaitStatus())
end
v_u_44.prototype.awaitValue = v_u_44.prototype.expect
function v_u_44.prototype._unwrap(p328) -- name: _unwrap
    -- upvalues: (copy) v_u_44
    if p328._status == v_u_44.Status.Started then
        error("Promise has not resolved or rejected.", 2)
    end
    local Resolved = p328._status == v_u_44.Status.Resolved
    local _values_3 = p328._values
    local _valuesLength_3 = p328._valuesLength
    return Resolved, unpack(_values_3, 1, _valuesLength_3)
end
local function v340(p_u_332, ...) -- name: _resolve
    -- upvalues: (copy) v_u_44, (ref) v_u_8, (copy) v_u_34
    if p_u_332._status == v_u_44.Status.Started then
        if v_u_44.is((...)) then
            if select("#", ...) > 1 then
                local v333 = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", p_u_332._source)
                warn(v333)
            end
            local v_u_334 = ...
            local v336 = v_u_334:andThen(function(...)
                -- upvalues: (copy) p_u_332
                p_u_332:_resolve(...)
            end, function(...)
                -- upvalues: (copy) v_u_334, (ref) v_u_8, (copy) p_u_332
                local v335 = v_u_334._values[1]
                if v_u_334._error then
                    v335 = v_u_8.new({
                        ["error"] = nil,
                        ["kind"] = nil,
                        ["context"] = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                        ["error"] = v_u_334._error,
                        ["kind"] = v_u_8.Kind.ExecutionError
                    })
                end
                if v_u_8.isKind(v335, v_u_8.Kind.ExecutionError) then
                    return p_u_332:_reject(v335:extend({
                        ["error"] = "This Promise was chained to a Promise that errored.",
                        ["trace"] = "",
                        ["context"] = nil,
                        ["context"] = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", p_u_332._source)
                    }))
                end
                p_u_332:_reject(...)
            end)
            if v336._status == v_u_44.Status.Cancelled then
                p_u_332:cancel()
            elseif v336._status == v_u_44.Status.Started then
                p_u_332._parent = v336
                v336._consumers[p_u_332] = true
            end
        else
            p_u_332._status = v_u_44.Status.Resolved
            local v337, v338 = v_u_34(...)
            p_u_332._valuesLength = v337
            p_u_332._values = v338
            for _, v339 in ipairs(p_u_332._queuedResolve) do
                coroutine.wrap(v339)(...)
            end
            p_u_332:_finalize()
            return
        end
    else
        if v_u_44.is((...)) then
            (...):_consumerCancelled(p_u_332)
        end
        return
    end
end
v_u_44.prototype._resolve = v340
function v_u_44.prototype._reject(p_u_341, ...) -- name: _reject
    -- upvalues: (copy) v_u_44, (copy) v_u_34
    if p_u_341._status == v_u_44.Status.Started then
        p_u_341._status = v_u_44.Status.Rejected
        local v342, v343 = v_u_34(...)
        p_u_341._valuesLength = v342
        p_u_341._values = v343
        local _queuedReject_0 = p_u_341._queuedReject
        if next(_queuedReject_0) == nil then
            local v_u_345 = tostring((...))
            coroutine.wrap(function()
                -- upvalues: (ref) v_u_44, (copy) p_u_341, (copy) v_u_345
                v_u_44._timeEvent:Wait()
                if p_u_341._unhandledRejection then
                    local v346 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", v_u_345, p_u_341._source)
                    if not v_u_44.TEST then
                        warn(v346)
                    end
                else
                    return
                end
            end)()
        else
            for _, v347 in ipairs(p_u_341._queuedReject) do
                coroutine.wrap(v347)(...)
            end
        end
        p_u_341:_finalize()
    end
end
function v_u_44.prototype._finalize(p348) -- name: _finalize
    -- upvalues: (copy) v_u_44
    for _, v349 in ipairs(p348._queuedFinally) do
        coroutine.wrap(v349)(p348._status)
    end
    p348._queuedFinally = nil
    p348._queuedReject = nil
    p348._queuedResolve = nil
    if not v_u_44.TEST then
        p348._parent = nil
        p348._consumers = nil
    end
end
local function v354(p350, p351) -- name: now
    -- upvalues: (copy) v_u_44, (ref) v_u_8
    local v352 = debug.traceback(nil, 2)
    if p350:getStatus() == v_u_44.Status.Resolved then
        return p350:_andThen(v352, function(...)
            return ...
        end)
    end
    local reject = v_u_44.reject
    if p351 == nil then
        p351 = v_u_8.new({
            ["kind"] = nil,
            ["error"] = "This Promise was not resolved in time for :now()",
            ["context"] = nil,
            ["kind"] = v_u_8.Kind.NotResolvedInTime,
            ["context"] = ":now() was called at:\n\n" .. v352
        }) or p351
    end
    return reject(p351)
end
v_u_44.prototype.now = v354
function v_u_44.retry(p_u_355, p_u_356, ...) -- name: retry
    -- upvalues: (copy) v_u_44
    local v357 = type(p_u_355) == "function"
    assert(v357, "Parameter #1 to Promise.retry must be a function")
    local v358 = type(p_u_356) == "number"
    assert(v358, "Parameter #2 to Promise.retry must be a number")
    local v_u_359 = { ... }
    local v_u_360 = select("#", ...)
    return v_u_44.resolve(p_u_355(...)):catch(function(...)
        -- upvalues: (copy) p_u_356, (ref) v_u_44, (copy) p_u_355, (copy) v_u_359, (copy) v_u_360
        if p_u_356 <= 0 then
            return v_u_44.reject(...)
        end
        local v361 = v_u_359
        local v362 = v_u_360
        return v_u_44.retry(p_u_355, p_u_356 - 1, unpack(v361, 1, v362))
    end)
end
function v_u_44.fromEvent(p_u_363, p364) -- name: fromEvent
    -- upvalues: (copy) v_u_44
    local v_u_365 = p364 or function()
        return true
    end
    return v_u_44._new(debug.traceback(nil, 2), function(p_u_366, _, p367)
        -- upvalues: (copy) p_u_363, (ref) v_u_365
        local v_u_368 = nil
        local v_u_369 = false
        local function v370() -- name: disconnect
            -- upvalues: (ref) v_u_368
            v_u_368:Disconnect()
            v_u_368 = nil
        end
        v_u_368 = p_u_363:Connect(function(...)
            -- upvalues: (ref) v_u_365, (copy) p_u_366, (ref) v_u_368, (ref) v_u_369
            local v371 = v_u_365(...)
            if v371 == true then
                p_u_366(...)
                if v_u_368 then
                    v_u_368:Disconnect()
                    v_u_368 = nil
                else
                    v_u_369 = true
                end
            else
                if type(v371) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean")
                end
                return
            end
        end)
        if v_u_369 and v_u_368 then
            return v370()
        end
        p367(function()
            -- upvalues: (ref) v_u_368
            v_u_368:Disconnect()
            v_u_368 = nil
        end)
    end)
end
return v_u_44
