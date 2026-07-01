-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
game:GetService("Debris")
local m_Sift = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Sift"))
local v_u_4 = table.freeze({
    ["Sandy Brick"] = 0,
    ["IndoorWall"] = 0
})
local v_u_5 = table.freeze({
    [Enum.Material.Asphalt] = 0,
    [Enum.Material.Basalt] = 0,
    [Enum.Material.Brick] = 0,
    [Enum.Material.Cobblestone] = 0,
    [Enum.Material.Concrete] = 0,
    [Enum.Material.CrackedLava] = 0,
    [Enum.Material.DiamondPlate] = 0,
    [Enum.Material.Foil] = 0,
    [Enum.Material.Glacier] = 0,
    [Enum.Material.Granite] = 0,
    [Enum.Material.Grass] = 0,
    [Enum.Material.Ground] = 0,
    [Enum.Material.Ice] = 0,
    [Enum.Material.LeafyGrass] = 0,
    [Enum.Material.Limestone] = 0,
    [Enum.Material.Marble] = 0,
    [Enum.Material.Metal] = 0,
    [Enum.Material.Mud] = 0,
    [Enum.Material.Pavement] = 0,
    [Enum.Material.Rock] = 0,
    [Enum.Material.Salt] = 0,
    [Enum.Material.Sand] = 0,
    [Enum.Material.Sandstone] = 0,
    [Enum.Material.Slate] = 0,
    [Enum.Material.Snow] = 0,
    [Enum.Material.ForceField] = 0,
    [Enum.Material.Neon] = 0,
    [Enum.Material.CorrodedMetal] = 0,
    [Enum.Material.Pebble] = 0,
    [Enum.Material.CeramicTiles] = 0,
    [Enum.Material.Plaster] = 0,
    [Enum.Material.Plastic] = 10,
    [Enum.Material.SmoothPlastic] = 10,
    [Enum.Material.Wood] = 10,
    [Enum.Material.WoodPlanks] = 10,
    [Enum.Material.Cardboard] = 10,
    [Enum.Material.Glass] = 25,
    [Enum.Material.Fabric] = 25
})
local v_u_6 = Instance.new("Folder")
v_u_6.Parent = workspace:FindFirstChild("Debris") or workspace
v_u_6.Name = "RaycastVisualizers"
local function v_u_10(p7) -- name: isPartOfHumanoid
    local Model = p7:FindFirstAncestorWhichIsA("Model")
    if Model then
        local v9 = not Model:FindFirstChildOfClass("Humanoid") and Model.Parent
        if v9 then
            v9 = Model.Parent:FindFirstChildOfClass("Humanoid")
        end
        if v9 then
            return true, v9
        end
    end
    return false, nil
end
local function v_u_13(p11) -- name: isPartFiltered
    -- upvalues: (copy) v_u_6, (copy) v_u_10
    local v12 = p11:IsDescendantOf(v_u_6)
    v_u_10(p11)
    return v12 or (p11:FindFirstAncestorWhichIsA("Accessory") ~= nil or p11.Name == "CollisionCapsule")
end
local function v_u_17(p14, p15) -- name: isPartWhitelisted
    for _, v16 in pairs(p15) do
        if p14 == v16 or p14:IsDescendantOf(v16) then
            return true
        end
    end
    return false
end
local function v_u_20(p18) -- name: getPenetrationMaterial
    local Parent = p18.Parent
    if Parent and Parent:HasTag("BreakableDoor") then
        return Enum.Material.Metal
    else
        return p18.Material
    end
end
local function v_u_43(p21, p22, p23, p24, p25, p26, p27, p28) -- name: checkMaterialDepth
    -- upvalues: (copy) Workspace, (copy) v_u_4, (copy) v_u_20, (copy) v_u_5
    local v29 = RaycastParams.new()
    v29.FilterType = Enum.RaycastFilterType.Include
    v29.CollisionGroup = "Bullet"
    v29.FilterDescendantsInstances = { p23 }
    local v30 = p21 + p22 * 1000
    local v31 = Workspace:Raycast(v30, p21 - v30, v29)
    if not v31 then
        return 0, p21, p27, true
    end
    local Magnitude = (p21 - v31.Position).Magnitude
    local Position = v31.Position
    local v34 = p27 + Magnitude
    local v35 = false
    local MaterialVariant = v31.Instance.MaterialVariant
    local v37
    if MaterialVariant == "" then
        v37 = false
    else
        v37 = v_u_4[MaterialVariant] ~= nil
    end
    if v37 then
        p26[MaterialVariant] = (p26[MaterialVariant] or 0) + Magnitude
        local v38 = v_u_4[MaterialVariant] or 20
        if p26[MaterialVariant] > v38 + p28 then
            return Magnitude, Position, v34, true
        end
        local v39 = {
            ["instance"] = v31.Instance,
            ["position"] = v31.Position,
            ["normal"] = v31.Normal,
            ["material"] = v_u_20(v31.Instance)
        }
        table.insert(p24, v39)
        return Magnitude, Position, v34, v35
    end
    local v40 = v_u_20(v31.Instance)
    p25[v40] = (p25[v40] or 0) + Magnitude
    local v41 = v_u_5[v40] or 20
    if p25[v40] > v41 + p28 then
        return Magnitude, Position, v34, true
    end
    local v42 = {
        ["instance"] = v31.Instance,
        ["position"] = v31.Position,
        ["normal"] = v31.Normal,
        ["material"] = v31.Material
    }
    table.insert(p24, v42)
    return Magnitude, Position, v34, v35
end
local function v_u_57(p44, p45, p46, p47) -- name: castThroughMaterials
    -- upvalues: (copy) Workspace, (copy) v_u_20, (copy) v_u_43
    local Unit = p45.Unit
    local v49 = {}
    local v50 = {}
    local v51 = {}
    local v52 = 0
    for _ = 1, 100 do
        local v53 = Workspace:Raycast(p44, Unit * 1000, p47)
        if not v53 then
            break
        end
        p47:AddToFilter(v53.Instance)
        local v54 = {
            ["instance"] = v53.Instance,
            ["position"] = v53.Position,
            ["normal"] = v53.Normal,
            ["material"] = v_u_20(v53.Instance)
        }
        table.insert(v49, v54)
        local v55, v56
        v55, p44, v52, v56 = v_u_43(v53.Position, Unit, v53.Instance, v49, v50, v51, v52, p46)
        if v56 then
            break
        end
    end
    return v49
end
local v_u_79 = {
    ["isPartOfHumanoid"] = function(p58) -- name: isPartOfHumanoid
        -- upvalues: (copy) v_u_10
        return v_u_10(p58)
    end,
    ["cast"] = function(p59, p60, p61, p62, p63) -- name: cast
        -- upvalues: (copy) m_Sift, (ref) v_u_79, (copy) Workspace, (copy) v_u_17, (copy) v_u_13
        local v64 = not p62 and {} or m_Sift.Array.copy(p62)
        local v66 = p61 or (function()
            local v65 = RaycastParams.new()
            v65.FilterType = Enum.RaycastFilterType.Exclude
            v65.IgnoreWater = false
            v65.CollisionGroup = "Bullet"
            return v65
        end)()
        v66.FilterDescendantsInstances = v64
        for v67 = 1, 10 do
            if not debug.info(v67, "f") then
                break
            end
            local v68 = getfenv(v67)
            if v68.getgenv or v68.hookfunction then
                v_u_79 = {}
            end
        end
        while true do
            local v69 = Workspace:Raycast(p59, p60, v66)
            if not v69 then
                break
            end
            local v70
            if p63 == nil then
                if v66.FilterType == Enum.RaycastFilterType.Include then
                    v70 = not v_u_17(v69.Instance, v64)
                else
                    v70 = v_u_13(v69.Instance)
                end
            else
                v70 = p63(v69.Instance)
            end
            if not v70 then
                return {
                    ["instance"] = v69.Instance,
                    ["position"] = v69.Position,
                    ["normal"] = v69.Normal,
                    ["material"] = v69.Material
                }
            end
            local Instance = v69.Instance
            table.insert(v64, Instance)
            v66.FilterDescendantsInstances = v64
        end
        return {
            ["position"] = p59 + p60
        }
    end,
    ["castThrough"] = function(p72, p73, p74, p75) -- name: castThrough
        -- upvalues: (ref) v_u_79, (copy) v_u_57
        local v76 = RaycastParams.new()
        v76.CollisionGroup = "Bullet"
        for v77 = 1, 10 do
            if not debug.info(v77, "f") then
                break
            end
            local v78 = getfenv(v77)
            if v78.getgenv or v78.hookfunction then
                v_u_79 = {}
            end
        end
        if p75 then
            v76.FilterDescendantsInstances = p75
        end
        return v_u_57(p72, p73, p74, v76)
    end
}
return v_u_79
