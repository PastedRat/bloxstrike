-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
require(script:WaitForChild("Types"))
local m_RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray)
local v_u_7 = require(ReplicatedStorage.Packages.Signal).new()
v_u_1.OnCasesUpdated = v_u_7
local v_u_8 = RunService:IsStudio()
local v_u_9 = {}
local v_u_10 = 0
local function v_u_15(p11) -- name: ParseUnixTimestamp
    if p11 == nil then
        return nil
    end
    if typeof(p11) == "number" then
        if p11 <= 10000000000 then
            return math.floor(p11)
        end
        local v12 = p11 / 1000
        return math.floor(v12)
    end
    local v13 = tonumber(p11)
    if not v13 then
        return DateTime.fromIsoDate(p11).UnixTimestamp
    end
    if v13 <= 10000000000 then
        return math.floor(v13)
    end
    local v14 = v13 / 1000
    return math.floor(v14)
end
local function v_u_21() -- name: GetNextCaseBoundaryTimestamp
    -- upvalues: (copy) Workspace, (ref) v_u_9, (copy) v_u_15
    local v16 = Workspace:GetServerTimeNow()
    local v17 = math.floor(v16)
    local v18 = nil
    for _, v19 in ipairs(v_u_9) do
        local v20 = v_u_15(v19.releaseDate)
        if not v20 or (v17 >= v20 or v18 ~= nil and v20 >= v18) then
            v20 = v18
        end
        v18 = v_u_15(v19.discontinueDate)
        if not v18 or (v17 >= v18 or v20 ~= nil and v18 >= v20) then
            v18 = v20
        end
    end
    return v18
end
local function v_u_28() -- name: ScheduleCasesUpdateAtNextBoundary
    -- upvalues: (copy) v_u_8, (ref) v_u_10, (copy) Workspace, (copy) v_u_21, (copy) v_u_7, (ref) v_u_9, (copy) v_u_28
    if v_u_8 then
        return
    else
        v_u_10 = v_u_10 + 1
        local v_u_22 = v_u_10
        local v23 = Workspace:GetServerTimeNow()
        local v24 = math.floor(v23)
        local v25 = v_u_21()
        if v25 then
            local v26 = v25 - v24
            local v27 = math.max(v26, 0)
            task.delay(v27, function()
                -- upvalues: (copy) v_u_22, (ref) v_u_10, (ref) v_u_7, (ref) v_u_9, (ref) v_u_28
                if v_u_22 == v_u_10 then
                    if #v_u_7:GetConnections() > 0 then
                        v_u_7:Fire(v_u_9)
                    end
                    v_u_28()
                end
            end)
        end
    end
end
local function v_u_34(p29) -- name: IsCaseEnabled
    -- upvalues: (copy) Workspace, (copy) v_u_8, (copy) v_u_15
    local v30 = Workspace:GetServerTimeNow()
    local v31 = math.floor(v30)
    if v_u_8 then
        return true
    end
    if p29.status == "inactive" or (p29.status == "discontinued" or not p29.isEnabled) then
        return false
    end
    if not (p29.releaseDate or p29.discontinueDate) then
        return true
    end
    if p29.releaseDate then
        local v32 = v_u_15(p29.releaseDate)
        if v32 and v31 < v32 then
            return false
        end
    end
    if p29.discontinueDate then
        local v33 = v_u_15(p29.discontinueDate)
        if v33 and v33 <= v31 then
            return false
        end
    end
    return true
end
function v_u_1.IsCaseEnabled(p35) -- name: IsCaseEnabled
    -- upvalues: (copy) v_u_1, (copy) v_u_34
    local v36 = v_u_1.GetCase(p35)
    if v36 then
        return v_u_34(v36)
    else
        return false
    end
end
function v_u_1.GetCaseByName(p37) -- name: GetCaseByName
    -- upvalues: (ref) v_u_9
    if not v_u_9 then
        return nil
    end
    for _, v38 in ipairs(v_u_9) do
        if v38.name == p37 then
            return v38
        end
    end
    return nil
end
function v_u_1.GetCase(p39) -- name: GetCase
    -- upvalues: (ref) v_u_9
    if not v_u_9 then
        return nil
    end
    for _, v40 in ipairs(v_u_9) do
        if v40.caseId == p39 then
            return v40
        end
    end
    return nil
end
function v_u_1.GetFeaturedCases(p_u_41) -- name: GetFeaturedCases
    -- upvalues: (ref) v_u_9, (copy) v_u_34, (copy) m_RemoveFromArray
    local v42 = {}
    for _, v43 in ipairs(v_u_9) do
        if v43.isFeatured and v_u_34(v43) then
            table.insert(v42, v43)
        end
    end
    table.sort(v42, function(p44, p45)
        return p44.displayOrder < p45.displayOrder
    end)
    m_RemoveFromArray(v42, function(p46, _)
        -- upvalues: (copy) p_u_41
        return p_u_41 < p46
    end)
    return v42
end
function v_u_1.GetCases() -- name: GetCases
    -- upvalues: (ref) v_u_9, (copy) v_u_34
    local v47 = {}
    for _, v48 in ipairs(v_u_9) do
        if v_u_34(v48) then
            table.insert(v47, v48)
        end
    end
    table.sort(v47, function(p49, p50)
        return p49.displayOrder < p50.displayOrder
    end)
    return v47
end
function v_u_1.ObserveAvailableCases(p51) -- name: ObserveAvailableCases
    -- upvalues: (copy) v_u_7, (ref) v_u_9
    local v_u_52 = v_u_7:Connect(p51)
    if v_u_9 then
        p51(v_u_9)
    end
    return function()
        -- upvalues: (copy) v_u_52
        v_u_52:Disconnect()
    end
end
if ReplicatedStorage:GetAttribute("AvaiableCases") then
    v_u_9 = HttpService:JSONDecode((ReplicatedStorage:GetAttribute("AvaiableCases")))
    v_u_28()
    if #v_u_7:GetConnections() > 0 then
        v_u_7:Fire(v_u_9)
    end
end
ReplicatedStorage:GetAttributeChangedSignal("AvaiableCases"):Connect(function()
    -- upvalues: (copy) ReplicatedStorage, (ref) v_u_9, (copy) HttpService, (copy) v_u_28, (copy) v_u_7
    local v53 = ReplicatedStorage:GetAttribute("AvaiableCases")
    if v53 then
        v_u_9 = HttpService:JSONDecode(v53)
        v_u_28()
        if #v_u_7:GetConnections() > 0 then
            v_u_7:Fire(v_u_9)
        end
    else
        return
    end
end)
return v_u_1
