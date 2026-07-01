-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local v_u_3 = {}
local v_u_4 = {}
function v1.GetMissionDefinition(p5) -- name: GetMissionDefinition
    -- upvalues: (copy) v_u_3
    return v_u_3[p5]
end
function v1.GetMissionCategory(p6) -- name: GetMissionCategory
    -- upvalues: (copy) v_u_3
    local v7 = v_u_3[p6]
    if v7 and v7.Category then
        return v7.Category
    else
        return nil
    end
end
function v1.GetMissionDisplayName(p8) -- name: GetMissionDisplayName
    -- upvalues: (copy) v_u_3
    local v9 = v_u_3[p8]
    if v9 then
        p8 = v9.DisplayName or p8
    end
    return p8
end
function v1.GetMissionDefinitions() -- name: GetMissionDefinitions
    -- upvalues: (copy) v_u_4
    return table.clone(v_u_4)
end
function v1.IsMissionAvailableForGamemode(p10, p11, p12) -- name: IsMissionAvailableForGamemode
    if not p10.Gamemodes then
        return true
    end
    if not p11 then
        return p12 == true
    end
    for _, v13 in ipairs(p10.Gamemodes) do
        if v13 == p11 then
            return true
        end
    end
    return false
end
for _, v14 in ipairs(script:GetDescendants()) do
    if v14:IsA("ModuleScript") then
        local v15 = require(v14)
        if v15 and v15.MissionId then
            v_u_3[v15.MissionId] = v15
            table.insert(v_u_4, v15)
        end
    end
end
return v1
