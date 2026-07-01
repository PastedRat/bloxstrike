-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
return function(p2)
    -- upvalues: (copy) ReplicatedStorage
    local v3 = ReplicatedStorage.Database.Custom.Weapons:FindFirstChild(p2)
    if v3 then
        return require(v3)
    else
        return nil
    end
end
