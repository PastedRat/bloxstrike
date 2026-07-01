-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local m_Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
return {
    ["Replication"] = "All",
    ["Finisher"] = nil,
    ["Finisher"] = function(p3, p4) -- name: Finisher
        -- upvalues: (copy) m_Ragdoll
        local v_u_5 = m_Ragdoll.new(p3, p4)
        return {
            ["OnDestroy"] = v_u_5.OnDestroy,
            ["Destroy"] = function() -- name: Destroy
                -- upvalues: (copy) v_u_5
                v_u_5:Destroy()
            end
        }
    end
}
