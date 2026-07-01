-- Decompiled with Medal

local LocalPlayer = game:GetService("Players").LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local Debris = workspace:WaitForChild("Debris")
return function()
    -- upvalues: (copy) Debris, (copy) CurrentCamera, (copy) LocalPlayer
    local v4 = {}
    local v5 = Debris
    table.insert(v4, v5)
    local v6 = CurrentCamera
    table.insert(v4, v6)
    local Map = workspace:FindFirstChild("Map")
    if Map then
        local Cameras = Map:FindFirstChild("Cameras")
        local Barriers = Map:FindFirstChild("Barriers")
        local Ambience = Map:FindFirstChild("Ambience")
        if Cameras then
            table.insert(v4, Cameras)
        end
        if Barriers then
            table.insert(v4, Barriers)
        end
        if Ambience then
            table.insert(v4, Ambience)
        end
        local Zones = Map:FindFirstChild("Zones")
        if Zones then
            local Spawns = Zones:FindFirstChild("Spawns")
            local Sites = Zones:FindFirstChild("Sites")
            if Spawns then
                table.insert(v4, Spawns)
            end
            if Sites then
                table.insert(v4, Sites)
            end
        end
    end
    if LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:IsDescendantOf(workspace)) then
        local Character = LocalPlayer.Character
        table.insert(v4, Character)
    end
    return v4
end
