-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local v_u_5 = Instance.new("Animation", nil)
v_u_5.AnimationId = "rbxassetid://130065050998927"
v_u_5.Name = "HOSTAGE_IDLE"
local v_u_6 = Instance.new("Animation", nil)
v_u_6.AnimationId = "rbxassetid://84183418979817"
v_u_6.Name = "HOSTAGE_CARRYING"
local function v_u_11(p7) -- name: updateAnimation
    -- upvalues: (copy) v_u_6, (copy) v_u_5
    local Humanoid = p7:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        return nil
    end
    local Animator = Humanoid:WaitForChild("Animator")
    local v10 = p7:GetAttribute("State") == "Carrying" and Animator:LoadAnimation(v_u_6) or (p7:GetAttribute("State") == "Idle" and Animator:LoadAnimation(v_u_5) or nil)
    if v10 then
        v10:Play()
    end
    return v10
end
return m_Observers.observeTag("Hostage", function(p_u_12)
    -- upvalues: (copy) m_Janitor, (copy) m_Sound, (copy) v_u_11
    local HumanoidRootPart = p_u_12:WaitForChild("HumanoidRootPart", 10)
    local Humanoid_0 = p_u_12:FindFirstChildOfClass("Humanoid")
    if not Humanoid_0 then
        local v15 = tick()
        repeat
            task.wait(0.1)
            Humanoid_0 = p_u_12:FindFirstChildOfClass("Humanoid")
        until Humanoid_0 or tick() - v15 > 10
    end
    local v16 = p_u_12:WaitForChild("Head", 10) or (Humanoid_0 or HumanoidRootPart)
    if v16 then
        if not p_u_12:IsDescendantOf(workspace) then
            return function() end
        end
        local v_u_17 = m_Janitor.new()
        local v_u_18 = m_Sound.new("Hostage")
        local v_u_19 = nil
        v_u_18:playOneTime({
            ["Name"] = "Hostage Idle",
            ["Parent"] = nil,
            ["Parent"] = v16
        })
        v_u_17:Add(p_u_12:GetAttributeChangedSignal("State"):Connect(function()
            -- upvalues: (ref) v_u_19, (ref) v_u_11, (copy) p_u_12
            if v_u_19 then
                v_u_19:Stop()
                v_u_19 = nil
            end
            v_u_19 = v_u_11(p_u_12)
        end))
        v_u_19 = v_u_11(p_u_12)
        v_u_17:Add(function()
            -- upvalues: (copy) v_u_18
            v_u_18:destroy()
        end)
        return function()
            -- upvalues: (copy) v_u_17
            v_u_17:Destroy()
        end
    end
end)
