-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = workspace:WaitForChild("Debris")
local m_DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
return function()
    -- upvalues: (copy) Debris, (copy) Players, (copy) m_DebugFlags
    local v5 = 0
    local v6 = 0
    for _, v_u_7 in Debris:GetChildren() do
        if not v_u_7:IsA("Folder") then
            local v8
            if v_u_7:GetAttribute("PersistentDebris") == true then
                v8 = true
            else
                local Name = v_u_7.Name
                v8 = string.sub(Name, -7) == "_Weapon" and true or string.find(v_u_7.Name, "_WeaponAttachments", 1, true) ~= nil
            end
            if v8 then
                v5 = v5 + 1
            else
                v6 = v6 + 1
                if Players:FindFirstChild(v_u_7.Name) then
                    task.delay(0.5, function()
                        -- upvalues: (copy) v_u_7
                        if v_u_7 and v_u_7.Parent then
                            v_u_7:Destroy()
                        end
                    end)
                else
                    v_u_7:Destroy()
                end
            end
        end
    end
    if m_DebugFlags.IsEnabled("DebrisCleanup") then
        warn(("[DebrisCleanup][Client] CleanupDebris received: destroyed=%d skipped=%d"):format(v6, v5))
    end
end
