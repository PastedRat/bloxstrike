-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
return {
    ["IsEnabled"] = function(p3) -- name: IsEnabled
        -- upvalues: (copy) ReplicatedStorage
        return ReplicatedStorage:GetAttribute("Debug_" .. p3) == true
    end,
    ["SetEnabled"] = function(p4, p5) -- name: SetEnabled
        -- upvalues: (copy) RunService, (copy) ReplicatedStorage
        if RunService:IsServer() or RunService:IsClient() then
            ReplicatedStorage:SetAttribute("Debug_" .. p4, p5)
        end
    end,
    ["GetAttributeName"] = function(p6) -- name: GetAttributeName
        return "Debug_" .. p6
    end
}
