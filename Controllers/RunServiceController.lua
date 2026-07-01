-- Decompiled with Medal

local v_u_1 = {}
local RunService = game:GetService("RunService")
local v_u_3 = {}
local v_u_4 = 0
local v_u_5 = 0
local function v7(p6) -- name: newScheduler
    return {
        ["EventName"] = nil,
        ["Bindings"] = nil,
        ["BindingsByName"] = nil,
        ["StepBindings"] = nil,
        ["RenderPriorityBindings"] = nil,
        ["Connection"] = nil,
        ["RenderStepNames"] = nil,
        ["NeedsCompact"] = false,
        ["NeedsSort"] = false,
        ["Stepping"] = false,
        ["EventName"] = p6,
        ["Bindings"] = {},
        ["BindingsByName"] = {},
        ["StepBindings"] = {},
        ["RenderPriorityBindings"] = {},
        ["RenderStepNames"] = {}
    }
end
local v_u_8 = {
    ["Heartbeat"] = v7("Heartbeat"),
    ["RenderStepped"] = v7("RenderStepped"),
    ["Stepped"] = v7("Stepped"),
    ["PostSimulation"] = v7("PostSimulation")
}
local function v_u_10(p9) -- name: getTraceback
    return debug.traceback(tostring(p9), 2)
end
local function v_u_15(p11) -- name: syncSchedulerConnections
    -- upvalues: (copy) RunService
    if p11.EventName == "RenderStepped" then
        if #p11.StepBindings == 0 and p11.Connection then
            p11.Connection:Disconnect()
            p11.Connection = nil
        end
        for v12, v13 in pairs(p11.RenderStepNames) do
            local v14 = p11.RenderPriorityBindings[v12]
            if not v14 or #v14 == 0 then
                RunService:UnbindFromRenderStep(v13)
                p11.RenderStepNames[v12] = nil
            end
        end
    elseif #p11.StepBindings == 0 and p11.Connection then
        p11.Connection:Disconnect()
        p11.Connection = nil
    end
end
local function v_u_28(p16) -- name: rebuildScheduler
    -- upvalues: (copy) v_u_15
    local v17 = 1
    for v18 = 1, #p16.Bindings do
        local v19 = p16.Bindings[v18]
        if v19.Connected then
            p16.Bindings[v17] = v19
            v17 = v17 + 1
        end
    end
    for v20 = v17, #p16.Bindings do
        p16.Bindings[v20] = nil
    end
    table.sort(p16.Bindings, function(p21, p22)
        if p21.Priority == p22.Priority then
            return p21.Sequence < p22.Sequence
        else
            return p21.Priority < p22.Priority
        end
    end)
    table.clear(p16.StepBindings)
    table.clear(p16.RenderPriorityBindings)
    if p16.EventName == "RenderStepped" then
        for _, v23 in ipairs(p16.Bindings) do
            if v23.UsesRenderPriority then
                local v24 = p16.RenderPriorityBindings[v23.Priority]
                if not v24 then
                    v24 = {}
                    p16.RenderPriorityBindings[v23.Priority] = v24
                end
                table.insert(v24, v23)
            else
                local StepBindings = p16.StepBindings
                table.insert(StepBindings, v23)
            end
        end
    else
        for _, v26 in ipairs(p16.Bindings) do
            local StepBindings_0 = p16.StepBindings
            table.insert(StepBindings_0, v26)
        end
    end
    p16.NeedsCompact = false
    p16.NeedsSort = false
    v_u_15(p16)
end
local function v_u_32(p29, ...) -- name: invokeBinding
    -- upvalues: (copy) v_u_10
    local v30, v31 = xpcall(p29.Callback, v_u_10, ...)
    if not v30 then
        warn((("[RunServiceController] %* binding \"%*\" failed:\n%*"):format(p29.EventName, p29.Name, v31)))
    end
end
local function v_u_38(p33, p34, ...) -- name: stepScheduler
    -- upvalues: (copy) v_u_28, (copy) v_u_3, (copy) v_u_32
    if p33.NeedsCompact or p33.NeedsSort then
        v_u_28(p33)
    end
    p33.Stepping = true
    local v35
    if p33.EventName == "RenderStepped" then
        if p34 == nil then
            v35 = p33.StepBindings
        else
            v35 = p33.RenderPriorityBindings[p34] or v_u_3
        end
    else
        v35 = p33.StepBindings
    end
    for v36 = 1, #v35 do
        local v37 = v35[v36]
        if v37 and v37.Connected then
            v_u_32(v37, ...)
        end
    end
    p33.Stepping = false
    if p33.NeedsCompact or p33.NeedsSort then
        v_u_28(p33)
    end
end
local function v_u_49(p_u_39, p_u_40, p41) -- name: ensureSchedulerConnection
    -- upvalues: (copy) RunService, (copy) v_u_38
    if p_u_39.EventName == "RenderStepped" then
        if p41 then
            if not p_u_39.RenderStepNames[p_u_40] then
                local v42 = ("RunServiceController.RenderStepped.%*"):format(p_u_40)
                p_u_39.RenderStepNames[p_u_40] = v42
                RunService:BindToRenderStep(v42, p_u_40, function(p43)
                    -- upvalues: (ref) v_u_38, (copy) p_u_39, (copy) p_u_40
                    v_u_38(p_u_39, p_u_40, p43)
                end)
            end
        else
            if not (p_u_39.Connection and p_u_39.Connection.Connected) then
                p_u_39.Connection = RunService.RenderStepped:Connect(function(p44)
                    -- upvalues: (ref) v_u_38, (copy) p_u_39
                    v_u_38(p_u_39, nil, p44)
                end)
            end
            return
        end
    elseif p_u_39.Connection and p_u_39.Connection.Connected then
        return
    elseif p_u_39.EventName == "Heartbeat" then
        p_u_39.Connection = RunService.Heartbeat:Connect(function(p45)
            -- upvalues: (ref) v_u_38, (copy) p_u_39
            v_u_38(p_u_39, nil, p45)
        end)
        return
    elseif p_u_39.EventName == "Stepped" then
        p_u_39.Connection = RunService.Stepped:Connect(function(p46, p47)
            -- upvalues: (ref) v_u_38, (copy) p_u_39
            v_u_38(p_u_39, nil, p46, p47)
        end)
    elseif p_u_39.EventName == "PostSimulation" then
        p_u_39.Connection = RunService.PostSimulation:Connect(function(p48)
            -- upvalues: (ref) v_u_38, (copy) p_u_39
            v_u_38(p_u_39, nil, p48)
        end)
    end
end
local function v_u_66(p50, p51, p52, p53, p54) -- name: createBinding
    -- upvalues: (copy) v_u_8, (copy) v_u_28, (ref) v_u_4, (copy) v_u_49
    local v55
    if type(p51) == "string" then
        v55 = p51 ~= ""
    else
        v55 = false
    end
    assert(v55, "RunServiceController binding name must be a non-empty string")
    local v56 = type(p52) == "number"
    assert(v56, "RunServiceController binding priority must be a number")
    local v57 = type(p53) == "function"
    assert(v57, "RunServiceController callback must be a function")
    local v_u_58 = v_u_8[p50]
    local v59 = v_u_58.BindingsByName[p51]
    if v59 and v59.Connected then
        v59.Connected = false
        if v_u_58.BindingsByName[v59.Name] == v59 then
            v_u_58.BindingsByName[v59.Name] = nil
        end
        v_u_58.NeedsCompact = true
        if not v_u_58.Stepping then
            v_u_28(v_u_58)
        end
    end
    v_u_4 = v_u_4 + 1
    local v_u_64 = {
        ["Name"] = nil,
        ["EventName"] = nil,
        ["Priority"] = nil,
        ["Connected"] = true,
        ["Callback"] = nil,
        ["Sequence"] = nil,
        ["UsesRenderPriority"] = nil,
        ["Name"] = p51,
        ["EventName"] = p50,
        ["Priority"] = p52,
        ["Callback"] = p53,
        ["Sequence"] = v_u_4,
        ["UsesRenderPriority"] = p54,
        ["Disconnect"] = function(_) -- name: Disconnect
            -- upvalues: (copy) v_u_58, (copy) v_u_64, (ref) v_u_28
            local v60 = v_u_58
            local v61 = v_u_64
            if v61.Connected then
                v61.Connected = false
                if v60.BindingsByName[v61.Name] == v61 then
                    v60.BindingsByName[v61.Name] = nil
                end
                v60.NeedsCompact = true
                if not v60.Stepping then
                    v_u_28(v60)
                end
            end
        end,
        ["Destroy"] = function(_) -- name: Destroy
            -- upvalues: (copy) v_u_58, (copy) v_u_64, (ref) v_u_28
            local v62 = v_u_58
            local v63 = v_u_64
            if v63.Connected then
                v63.Connected = false
                if v62.BindingsByName[v63.Name] == v63 then
                    v62.BindingsByName[v63.Name] = nil
                end
                v62.NeedsCompact = true
                if not v62.Stepping then
                    v_u_28(v62)
                end
            end
        end
    }
    local Bindings = v_u_58.Bindings
    table.insert(Bindings, v_u_64)
    v_u_58.BindingsByName[p51] = v_u_64
    v_u_58.NeedsSort = true
    v_u_49(v_u_58, p52, p54)
    return v_u_64
end
function v_u_1.CreateBindingName(p67) -- name: CreateBindingName
    -- upvalues: (ref) v_u_5
    local v68
    if type(p67) == "string" then
        v68 = p67 ~= ""
    else
        v68 = false
    end
    assert(v68, "RunServiceController binding prefix must be a non-empty string")
    v_u_5 = v_u_5 + 1
    return ("%*.%*"):format(p67, v_u_5)
end
function v_u_1.BindToHeartbeat(p69, p70, p71) -- name: BindToHeartbeat
    -- upvalues: (copy) v_u_66
    return v_u_66("Heartbeat", p69, p71 or 0, p70, false)
end
function v_u_1.BindToRenderStep(p72, p73, p74) -- name: BindToRenderStep
    -- upvalues: (copy) v_u_66
    local v75, v76
    if p74 == nil then
        v75 = 0
        v76 = false
    else
        v75 = p73
        p73 = p74
        v76 = true
    end
    return v_u_66("RenderStepped", p72, v75, p73, v76)
end
function v_u_1.BindToStepped(p77, p78, p79) -- name: BindToStepped
    -- upvalues: (copy) v_u_66
    return v_u_66("Stepped", p77, p79 or 0, p78, false)
end
function v_u_1.BindToPostSimulation(p80, p81, p82) -- name: BindToPostSimulation
    -- upvalues: (copy) v_u_66
    return v_u_66("PostSimulation", p80, p82 or 0, p81, false)
end
function v_u_1.Unbind(p83, p84) -- name: Unbind
    -- upvalues: (copy) v_u_8, (copy) v_u_28
    local v85 = v_u_8[p83].BindingsByName[p84]
    if v85 then
        local v86 = v_u_8[p83]
        if not v85.Connected then
            return
        end
        v85.Connected = false
        if v86.BindingsByName[v85.Name] == v85 then
            v86.BindingsByName[v85.Name] = nil
        end
        v86.NeedsCompact = true
        if not v86.Stepping then
            v_u_28(v86)
        end
    end
end
function v_u_1.UnbindFromRenderStep(p87) -- name: UnbindFromRenderStep
    -- upvalues: (copy) v_u_1
    v_u_1.Unbind("RenderStepped", p87)
end
return v_u_1
