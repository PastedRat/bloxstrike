-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
require(script:WaitForChild("Types"))
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local function v_u_14(p5, p6) -- name: CreateTween
    -- upvalues: (copy) TweenService
    if not (p6 and (p6.Parent and p6:IsDescendantOf(workspace))) then
        return
    end
    local PointA = p6:WaitForChild("PointA", 5)
    local PointB = p6:WaitForChild("PointB", 5)
    if not (PointA and PointB) then
        warn((("[VertigoCar] Model \"%*\" is missing PointA or PointB attachments"):format(p6.Name)))
        return
    end
    if not (p6 and (p6.Parent and p6:IsDescendantOf(workspace))) then
        return
    end
    local WorldPosition = PointA.WorldPosition
    local WorldPosition_0 = PointB.WorldPosition
    local Magnitude = (WorldPosition_0 - WorldPosition).Magnitude
    if Magnitude <= 0 then
        return
    end
    local v12 = Magnitude / 42
    local v13 = TweenService:Create(p6, TweenInfo.new(v12, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
        ["Position"] = WorldPosition_0
    })
    p5:Add(v13, "Cancel")
    while p6 and (p6.Parent and p6:IsDescendantOf(workspace)) do
        p6.Position = WorldPosition
        if not (p6 and (p6.Parent and p6:IsDescendantOf(workspace))) then
            break
        end
        v13:Play()
        v13.Completed:Wait()
        if not (p6 and (p6.Parent and p6:IsDescendantOf(workspace))) then
            break
        end
    end
end
return m_Observers.observeTag("VertigoCar", function(p_u_15)
    -- upvalues: (copy) m_Janitor, (copy) v_u_14
    p_u_15.Anchored = true
    if not p_u_15:IsDescendantOf(workspace) then
        return function() end
    end
    local v_u_16 = m_Janitor.new()
    v_u_16:Add(p_u_15)
    v_u_16:Add(task.spawn(function()
        -- upvalues: (ref) v_u_14, (copy) v_u_16, (copy) p_u_15
        v_u_14(v_u_16, p_u_15)
    end))
    return function()
        -- upvalues: (copy) v_u_16
        v_u_16:Destroy()
    end
end)
