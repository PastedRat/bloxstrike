-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script:WaitForChild("Types"))
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local v_u_3 = Instance.new("Animation", nil)
v_u_3.AnimationId = "rbxassetid://75914758947993"
v_u_3.Name = "CRANE_IDLE"
return m_Observers.observeTag("VertigoCrane", function(p4)
    -- upvalues: (copy) v_u_3
    p4:WaitForChild("AnimationController"):WaitForChild("Animator")
    if not p4:IsDescendantOf(workspace) then
        return function() end
    end
    local v_u_5 = p4.AnimationController.Animator:LoadAnimation(v_u_3)
    v_u_5:Play()
    return function()
        -- upvalues: (copy) v_u_5
        v_u_5:Destroy()
    end
end)
