-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script:WaitForChild("Types"))
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local v_u_3 = Instance.new("Animation", nil)
v_u_3.AnimationId = "rbxassetid://103823379066850"
v_u_3.Name = "FLAG_IDLE"
return m_Observers.observeTag("Flag", function(p4)
    -- upvalues: (copy) v_u_3
    p4:WaitForChild("csFlag"):WaitForChild("AnimationController"):WaitForChild("Animator")
    local v_u_5 = p4.csFlag.AnimationController.Animator:LoadAnimation(v_u_3)
    v_u_5:Play()
    return function()
        -- upvalues: (copy) v_u_5
        v_u_5:Destroy()
    end
end, { workspace })
