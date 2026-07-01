-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local LocalPlayer = Players.LocalPlayer
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local v_u_6 = m_Sound.new("Finishers")
return {
    ["Replication"] = "All",
    ["Finisher"] = nil,
    ["Finisher"] = function(p7, p8) -- name: Finisher
        -- upvalues: (copy) m_Ragdoll, (copy) LocalPlayer, (copy) v_u_6
        local new = m_Ragdoll.new
        local v10 = {
            ["DirectionMultiplier"] = math.random(25, 40)
        }
        for v11, v12 in pairs(v10) do
            p8[v11] = v12
        end
        local v_u_13 = new(p7, p8)
        local Victim = p8.Victim
        local UserId = LocalPlayer.UserId
        if Victim == tostring(UserId) then
            v_u_6:play({
                ["Parent"] = nil,
                ["Name"] = "Fling",
                ["Parent"] = LocalPlayer.PlayerGui
            })
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
