-- Decompiled with Medal

local v_u_1 = nil
local function v_u_4(p2, ...) -- name: acquireRunnerThreadAndCallEventHandler
    -- upvalues: (ref) v_u_1
    local v3 = v_u_1
    v_u_1 = nil
    p2(...)
    v_u_1 = v3
end
local function v_u_5(...) -- name: runEventHandlerInFreeThread
    -- upvalues: (copy) v_u_4
    v_u_4(...)
    while true do
        v_u_4(coroutine.yield())
    end
end
local v_u_6 = {}
v_u_6.__index = v_u_6
function v_u_6.Disconnect(p7) -- name: Disconnect
    if p7.Connected then
        p7.Connected = false
        if p7._signal._handlerListHead == p7 then
            p7._signal._handlerListHead = p7._next
        else
            local v8 = p7._signal._handlerListHead
            while v8 and v8._next ~= p7 do
                v8 = v8._next
            end
            if v8 then
                v8._next = p7._next
            end
        end
    else
        return
    end
end
v_u_6.Destroy = v_u_6.Disconnect
setmetatable(v_u_6, {
    ["__index"] = function(_, p9) -- name: __index
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p9))), 2)
    end,
    ["__newindex"] = function(_, p10, _) -- name: __newindex
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p10))), 2)
    end
})
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new() -- name: new
    -- upvalues: (copy) v_u_11
    local v12 = v_u_11
    return setmetatable({
        ["_handlerListHead"] = false,
        ["_proxyHandler"] = nil,
        ["_yieldedThreads"] = nil
    }, v12)
end
function v_u_11.Wrap(p13) -- name: Wrap
    -- upvalues: (copy) v_u_11
    local v14 = typeof(p13) == "RBXScriptSignal"
    local v15 = "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(p13)
    assert(v14, v15)
    local v_u_16 = v_u_11.new()
    v_u_16._proxyHandler = p13:Connect(function(...)
        -- upvalues: (copy) v_u_16
        v_u_16:Fire(...)
    end)
    return v_u_16
end
function v_u_11.Is(p17) -- name: Is
    -- upvalues: (copy) v_u_11
    local v18
    if type(p17) == "table" then
        v18 = getmetatable(p17) == v_u_11
    else
        v18 = false
    end
    return v18
end
function v_u_11.Connect(p19, p20) -- name: Connect
    -- upvalues: (copy) v_u_6
    local v21 = v_u_6
    local v22 = setmetatable({
        ["Connected"] = true,
        ["_signal"] = nil,
        ["_fn"] = nil,
        ["_next"] = false,
        ["_signal"] = p19,
        ["_fn"] = p20
    }, v21)
    if not p19._handlerListHead then
        p19._handlerListHead = v22
        return v22
    end
    v22._next = p19._handlerListHead
    p19._handlerListHead = v22
    return v22
end
function v_u_11.ConnectOnce(p23, p24) -- name: ConnectOnce
    return p23:Once(p24)
end
function v_u_11.Once(p25, p_u_26) -- name: Once
    local v_u_27 = nil
    local v_u_28 = false
    v_u_27 = p25:Connect(function(...)
        -- upvalues: (ref) v_u_28, (ref) v_u_27, (copy) p_u_26
        if not v_u_28 then
            v_u_28 = true
            v_u_27:Disconnect()
            p_u_26(...)
        end
    end)
    return v_u_27
end
function v_u_11.GetConnections(p29) -- name: GetConnections
    local v30 = p29._handlerListHead
    local v31 = {}
    while v30 do
        table.insert(v31, v30)
        v30 = v30._next
    end
    return v31
end
function v_u_11.DisconnectAll(p32) -- name: DisconnectAll
    local v33 = p32._handlerListHead
    while v33 do
        v33.Connected = false
        v33 = v33._next
    end
    p32._handlerListHead = false
    local v34 = rawget(p32, "_yieldedThreads")
    if v34 then
        for v35 in v34 do
            if coroutine.status(v35) == "suspended" then
                warn(debug.traceback(v35, "signal disconnected; yielded thread cancelled", 2))
                task.cancel(v35)
            end
        end
        table.clear(p32._yieldedThreads)
    end
end
function v_u_11.Fire(p36, ...) -- name: Fire
    -- upvalues: (ref) v_u_1, (copy) v_u_5
    local v37 = p36._handlerListHead
    while v37 do
        if v37.Connected then
            if not v_u_1 then
                v_u_1 = coroutine.create(v_u_5)
            end
            task.spawn(v_u_1, v37._fn, ...)
        end
        v37 = v37._next
    end
end
function v_u_11.FireDeferred(p38, ...) -- name: FireDeferred
    local v_u_39 = p38._handlerListHead
    while v_u_39 do
        task.defer(function(...)
            -- upvalues: (copy) v_u_39
            if v_u_39.Connected then
                v_u_39._fn(...)
            end
        end, ...)
        v_u_39 = v_u_39._next
    end
end
function v_u_11.Wait(p40) -- name: Wait
    local v_u_41 = rawget(p40, "_yieldedThreads")
    if not v_u_41 then
        v_u_41 = {}
        rawset(p40, "_yieldedThreads", v_u_41)
    end
    local v_u_42 = coroutine.running()
    v_u_41[v_u_42] = true
    p40:Once(function(...)
        -- upvalues: (ref) v_u_41, (copy) v_u_42
        v_u_41[v_u_42] = nil
        if coroutine.status(v_u_42) == "suspended" then
            task.spawn(v_u_42, ...)
        end
    end)
    return coroutine.yield()
end
function v_u_11.Destroy(p43) -- name: Destroy
    p43:DisconnectAll()
    local v44 = rawget(p43, "_proxyHandler")
    if v44 then
        v44:Disconnect()
    end
end
setmetatable(v_u_11, {
    ["__index"] = function(_, p45) -- name: __index
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p45))), 2)
    end,
    ["__newindex"] = function(_, p46, _) -- name: __newindex
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p46))), 2)
    end
})
return table.freeze({
    ["new"] = v_u_11.new,
    ["Wrap"] = v_u_11.Wrap,
    ["Is"] = v_u_11.Is
})
