-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script:WaitForChild("Types"))
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local v_u_3 = Instance.new("Animation")
v_u_3.AnimationId = "rbxassetid://82806563298602"
return m_Observers.observeTag("Ceiling Fan", function(p4)
    -- upvalues: (copy) v_u_3
    p4:WaitForChild("AnimationController"):WaitForChild("Animator")
    if p4:IsDescendantOf(workspace) then
        local v_u_5 = p4.AnimationController.Animator:LoadAnimation(v_u_3)
        v_u_5:Play()
        return function()
            -- upvalues: (copy) v_u_5
            v_u_5:Destroy()
        end
    end
end)
