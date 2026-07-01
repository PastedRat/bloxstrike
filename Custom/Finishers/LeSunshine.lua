-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local LocalPlayer = Players.LocalPlayer
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local v_u_6 = m_Sound.new("Finishers")
local function v_u_10(p_u_7, _) -- name: Activate
    -- upvalues: (copy) LocalPlayer, (copy) v_u_6
    local v8 = p_u_7.Janitor:Add(script.FinisherGui:Clone(), "Destroy", "FinisherGui")
    v8.Parent = LocalPlayer.PlayerGui
    local v9 = v_u_6:play({
        ["Parent"] = nil,
        ["Name"] = "LeSunshine",
        ["Parent"] = v8
    })
    if v9 then
        p_u_7.Janitor:Add(v9.Ended:Once(function()
            -- upvalues: (copy) p_u_7
            p_u_7.Janitor:Remove("FinisherGui")
        end))
    end
end
return {
    ["Replication"] = "All",
    ["Finisher"] = nil,
    ["Finisher"] = function(p11, p12) -- name: Finisher
        -- upvalues: (copy) m_Ragdoll, (copy) LocalPlayer, (copy) v_u_10
        local v_u_13 = m_Ragdoll.new(p11, p12)
        local Victim = p12.Victim
        local UserId = LocalPlayer.UserId
        if Victim == tostring(UserId) then
            v_u_10(v_u_13, p12)
        end
        return {
            ["OnDestroy"] = v_u_13.OnDestroy,
            ["Destroy"] = function() -- name: Destroy
                -- upvalues: (copy) v_u_13
                v_u_13:Destroy()
            end
        }
    end
}
