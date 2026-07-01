-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(script:WaitForChild("Types"))
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local v_u_4 = {
    "Map Voting",
    "Game Ending",
    "Warmup",
    "Round In Progress",
    "Buy Period",
    "Intermission"
}
return {
    ["GetState"] = function() -- name: GetState
        return workspace:GetAttribute("GameState")
    end,
    ["SetState"] = function(p5) -- name: SetState
        -- upvalues: (copy) RunService, (copy) v_u_4
        local v6 = RunService:IsServer()
        assert(v6, "This method is only available to the server.")
        local v7 = table.find(v_u_4, p5)
        local v8 = ("\"%*\" is not a valid state!"):format(p5)
        assert(v7, v8)
        if true then
            workspace:SetAttribute("GameState", p5)
        end
    end,
    ["ListenToState"] = function(p_u_9) -- name: ListenToState
        -- upvalues: (copy) m_Observers
        local v_u_10 = nil
        return m_Observers.observeAttribute(workspace, "GameState", function(p11)
            -- upvalues: (copy) p_u_9, (ref) v_u_10
            p_u_9(v_u_10, p11)
            v_u_10 = p11
        end)
    end
}
