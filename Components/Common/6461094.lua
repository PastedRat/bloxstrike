-- Decompiled with Medal

local v_u_1 = {}
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local LocalPlayer = Players.LocalPlayer
local v_u_8 = RaycastParams.new()
v_u_8.FilterType = Enum.RaycastFilterType.Exclude
v_u_8.IgnoreWater = true
local v_u_9 = 0
local v_u_10 = -1
local v_u_11 = nil
local v_u_12 = nil
local v_u_13 = nil
local v_u_14 = 0
local v_u_15 = nil
m_RunServiceController.BindToHeartbeat("Components.CenterScreenRaycast.InvalidateCache", function()
    -- upvalues: (ref) v_u_9
    v_u_9 = v_u_9 + 1
end)
local function v_u_21(p16) -- name: ResolveRaycast
    -- upvalues: (copy) Workspace, (copy) LocalPlayer, (ref) v_u_10, (ref) v_u_11, (ref) v_u_12, (ref) v_u_13, (ref) v_u_14, (ref) v_u_15, (ref) v_u_9, (copy) v_u_8
    local CurrentCamera = Workspace.CurrentCamera
    local Character = LocalPlayer.Character
    if not (CurrentCamera and Character) then
        v_u_10 = -1
        v_u_11 = nil
        v_u_12 = nil
        v_u_13 = nil
        v_u_14 = 0
        v_u_15 = nil
        return nil
    end
    local CFrame = CurrentCamera.CFrame
    local v20
    if v_u_10 == v_u_9 and (v_u_11 == CurrentCamera and (v_u_13 == Character and v_u_12 == CFrame)) then
        v20 = p16 <= v_u_14
    else
        v20 = false
    end
    if v20 then
        return v_u_15
    end
    v_u_8.FilterDescendantsInstances = { Character, CurrentCamera }
    v_u_15 = Workspace:Raycast(CFrame.Position, CFrame.LookVector * p16, v_u_8)
    v_u_10 = v_u_9
    v_u_11 = CurrentCamera
    v_u_12 = CFrame
    v_u_13 = Character
    v_u_14 = p16
    return v_u_15
end
function v_u_1.GetResult(p22) -- name: GetResult
    -- upvalues: (copy) v_u_21
    local v23 = p22 or 10
    local v24 = v_u_21(v23)
    if v24 then
        if v23 < v24.Distance then
            return nil
        else
            return v24
        end
    else
        return nil
    end
end
function v_u_1.GetInstance(p25) -- name: GetInstance
    -- upvalues: (copy) v_u_1
    local v26 = v_u_1.GetResult(p25)
    if v26 then
        return v26.Instance
    else
        return nil
    end
end
function v_u_1.FindAncestor(p27, p28) -- name: FindAncestor
    -- upvalues: (copy) v_u_1
    local v29 = v_u_1.GetResult(p28)
    if not v29 then
        return nil
    end
    local v30 = v29.Instance
    while v30 do
        if p27(v30) then
            return v30
        end
        v30 = v30.Parent
    end
    return nil
end
function v_u_1.FindTaggedAncestor(p_u_31, p32) -- name: FindTaggedAncestor
    -- upvalues: (copy) v_u_1, (copy) CollectionService
    return v_u_1.FindAncestor(function(p33)
        -- upvalues: (ref) CollectionService, (copy) p_u_31
        return CollectionService:HasTag(p33, p_u_31)
    end, p32)
end
function v_u_1.GetHoveredHostage(p34) -- name: GetHoveredHostage
    -- upvalues: (copy) LocalPlayer, (copy) v_u_1
    if LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" then
        local v35 = v_u_1.FindTaggedAncestor("Hostage", p34 or 5)
        if v35 and v35:IsA("Model") then
            if v35:GetAttribute("CanRescue") == true then
                local v36 = v35:GetAttribute("RescuingPlayer")
                if v36 and v36 ~= LocalPlayer.Name then
                    return nil
                elseif v35:GetAttribute("CarryingPlayer") then
                    return nil
                else
                    return v35
                end
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end
function v_u_1.Invalidate() -- name: Invalidate
    -- upvalues: (ref) v_u_10, (ref) v_u_11, (ref) v_u_12, (ref) v_u_13, (ref) v_u_14, (ref) v_u_15
    v_u_10 = -1
    v_u_11 = nil
    v_u_12 = nil
    v_u_13 = nil
    v_u_14 = 0
    v_u_15 = nil
end
return v_u_1
