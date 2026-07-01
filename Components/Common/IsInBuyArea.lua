-- Decompiled with Medal

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
return function(p3)
    -- upvalues: (copy) CollectionService
    local v4 = p3:GetAttribute("Team")
    local Character = p3.Character
    if Character and Character:IsDescendantOf(workspace) then
        local v6 = CollectionService:GetTagged("BuyArea")
        for _, v7 in ipairs(v6) do
            local PrimaryPart = Character.PrimaryPart
            if not PrimaryPart then
                return false
            end
            if v7:GetAttribute("Team") == v4 and v7:IsDescendantOf(workspace) then
                local Position = PrimaryPart.Position
                local CFrame = v7.CFrame
                local Size = v7.Size
                local v12 = CFrame:PointToObjectSpace(Position)
                local v13 = v12.X
                local v14
                if math.abs(v13) <= Size.X / 2 then
                    local v15 = v12.Y
                    if math.abs(v15) <= Size.Y / 2 then
                        local v16 = v12.Z
                        v14 = math.abs(v16) <= Size.Z / 2
                    else
                        v14 = false
                    end
                else
                    v14 = false
                end
                if v14 then
                    return true
                end
            end
        end
    end
    return workspace:GetAttribute("Gamemode") == "Deathmatch"
end
