-- Decompiled with Medal

local RunService = game:GetService("RunService")
local v_u_2 = newproxy()
local v_u_3 = newproxy()
local v_u_4 = table.freeze({
    "Destroy",
    "Disconnect",
    "destroy",
    "disconnect"
})
local function v_u_10(p5, p6) -- name: GetObjectCleanupFunction
    -- upvalues: (copy) v_u_2, (copy) v_u_3, (copy) v_u_4
    local v7 = typeof(p5)
    if v7 == "function" then
        return v_u_2
    end
    if v7 == "thread" then
        return v_u_3
    end
    if p6 then
        return p6
    end
    if v7 == "Instance" then
        return "Destroy"
    end
    if v7 == "RBXScriptConnection" then
        return "Disconnect"
    end
    if v7 == "table" then
        for _, v8 in v_u_4 do
            local v9 = p5[v8]
            if typeof(v9) == "function" then
                return v8
            end
        end
    end
    error(("failed to get cleanup function for object %*: %*"):format(v7, p5), 3)
end
local v_u_11 = {}
v_u_11.__index = v_u_11
function v_u_11.new() -- name: new
    -- upvalues: (copy) v_u_11
    local v12 = v_u_11
    local v13 = setmetatable({}, v12)
    v13._objects = {}
    v13._cleaning = false
    return v13
end
function v_u_11.Add(p14, p15, p16) -- name: Add
    -- upvalues: (copy) v_u_10
    if p14._cleaning then
        error("cannot call trove:Add() while cleaning", 2)
    end
    local v17 = v_u_10(p15, p16)
    local _objects = p14._objects
    table.insert(_objects, { p15, v17 })
    return p15
end
function v_u_11.Clone(p19, p20) -- name: Clone
    if p19._cleaning then
        error("cannot call trove:Clone() while cleaning", 2)
    end
    return p19:Add(p20:Clone())
end
function v_u_11.Construct(p21, p22, ...) -- name: Construct
    if p21._cleaning then
        error("Cannot call trove:Construct() while cleaning", 2)
    end
    local v23 = nil
    local v24 = type(p22)
    if v24 == "table" then
        v23 = p22.new(...)
    elseif v24 == "function" then
        v23 = p22(...)
    end
    return p21:Add(v23)
end
function v_u_11.Connect(p25, p26, p27) -- name: Connect
    if p25._cleaning then
        error("Cannot call trove:Connect() while cleaning", 2)
    end
    return p25:Add(p26:Connect(p27))
end
function v_u_11.BindToRenderStep(p28, p_u_29, p30, p31) -- name: BindToRenderStep
    -- upvalues: (copy) RunService
    if p28._cleaning then
        error("cannot call trove:BindToRenderStep() while cleaning", 2)
    end
    RunService:BindToRenderStep(p_u_29, p30, p31)
    p28:Add(function()
        -- upvalues: (ref) RunService, (copy) p_u_29
        RunService:UnbindFromRenderStep(p_u_29)
    end)
end
function v_u_11.AddPromise(p_u_32, p_u_33) -- name: AddPromise
    if p_u_32._cleaning then
        error("cannot call trove:AddPromise() while cleaning", 2)
    end
    if typeof(p_u_33) == "table" then
        local getStatus = p_u_33.getStatus
        if typeof(getStatus) == "function" then
            local finally = p_u_33.finally
            if typeof(finally) == "function" then
                local cancel = p_u_33.cancel
                if typeof(cancel) == "function" then
                    ::l7::
                    if p_u_33:getStatus() == "Started" then
                        p_u_33:finally(function()
                            -- upvalues: (copy) p_u_32, (copy) p_u_33
                            if not p_u_32._cleaning then
                                p_u_32:_findAndRemoveFromObjects(p_u_33, false)
                            end
                        end)
                        p_u_32:Add(p_u_33, "cancel")
                    end
                    return p_u_33
                end
            end
        end
    end
    error("did not receive a promise as an argument", 3)
    goto l7
end
function v_u_11.Remove(p37, p38) -- name: Remove
    if p37._cleaning then
        error("cannot call trove:Remove() while cleaning", 2)
    end
    return p37:_findAndRemoveFromObjects(p38, true)
end
function v_u_11.Extend(p39) -- name: Extend
    -- upvalues: (copy) v_u_11
    if p39._cleaning then
        error("cannot call trove:Extend() while cleaning", 2)
    end
    return p39:Construct(v_u_11)
end
function v_u_11.Clean(p40) -- name: Clean
    if not p40._cleaning then
        p40._cleaning = true
        for _, v41 in p40._objects do
            p40:_cleanupObject(v41[1], v41[2])
        end
        table.clear(p40._objects)
        p40._cleaning = false
    end
end
function v_u_11.WrapClean(p_u_42) -- name: WrapClean
    return function()
        -- upvalues: (copy) p_u_42
        p_u_42:Clean()
    end
end
function v_u_11._findAndRemoveFromObjects(p43, p44, p45) -- name: _findAndRemoveFromObjects
    local _objects_0 = p43._objects
    for v47, v48 in _objects_0 do
        if v48[1] == p44 then
            local v49 = #_objects_0
            _objects_0[v47] = _objects_0[v49]
            _objects_0[v49] = nil
            if p45 then
                p43:_cleanupObject(v48[1], v48[2])
            end
            return true
        end
    end
    return false
end
function v_u_11._cleanupObject(_, p50, p51) -- name: _cleanupObject
    -- upvalues: (copy) v_u_2, (copy) v_u_3
    if p51 == v_u_2 then
        task.spawn(p50)
        return
    elseif p51 == v_u_3 then
        pcall(task.cancel, p50)
    else
        p50[p51](p50)
    end
end
function v_u_11.AttachToInstance(p_u_52, p53) -- name: AttachToInstance
    if p_u_52._cleaning then
        error("cannot call trove:AttachToInstance() while cleaning", 2)
    elseif not p53:IsDescendantOf(game) then
        error("instance is not a descendant of the game hierarchy", 2)
    end
    return p_u_52:Connect(p53.Destroying, function()
        -- upvalues: (copy) p_u_52
        p_u_52:Destroy()
    end)
end
function v_u_11.Destroy(p54) -- name: Destroy
    p54:Clean()
end
return {
    ["new"] = v_u_11.new
}
