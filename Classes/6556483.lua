-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script:WaitForChild("Types"))
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Signal = require(ReplicatedStorage.Packages.Signal)
local m_PartMultipliers = require(script.Configuration.PartMultipliers)
local Debris = workspace:WaitForChild("Debris")
local DefaultRagdoll = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Characters"):WaitForChild("DefaultRagdoll")
local v_u_11 = table.freeze({
    ["Accessory"] = true,
    ["Shirt"] = true,
    ["Pants"] = true,
    ["ShirtGraphic"] = true,
    ["BodyColors"] = true,
    ["CharacterMesh"] = true,
    ["WrapLayer"] = true,
    ["WrapTarget"] = true
})
local function v_u_16(p12) -- name: CleanupAttachments
    -- upvalues: (copy) Debris
    for _, v13 in { ("%*_Weapon"):format(p12.Name), (("%*_WeaponAttachments"):format(p12.Name)) } do
        local v14 = Debris:FindFirstChild(v13)
        if v14 then
            v14:Destroy()
        end
    end
    local CharacterModel_0 = p12:FindFirstChild("CharacterModel")
    if CharacterModel_0 then
        CharacterModel_0:Destroy()
    end
end
local function v_u_19(p17) -- name: ReapplyRagdollBodyCollisions
    for _, v18 in p17:QueryDescendants("BasePart") do
        if not v18:HasTag("CharacterAccessory") then
            v18.CollisionGroup = "Debris"
            v18.CanQuery = false
            v18.CanTouch = false
        end
    end
end
local function v_u_24(p20, p21) -- name: GetRelativePath
    local v22 = {}
    while p21 and p21 ~= p20 do
        local Name = p21.Name
        table.insert(v22, 1, Name)
        p21 = p21.Parent
    end
    if p21 == p20 then
        return v22
    else
        return nil
    end
end
local function v_u_38(p25, p26) -- name: CloneCharacterArmor
    -- upvalues: (copy) v_u_24
    local CharacterArmor = p25:FindFirstChild("CharacterArmor")
    local CharacterArmor_0 = p26:FindFirstChild("CharacterArmor")
    local v29 = {}
    if not CharacterArmor then
        return v29
    end
    if not CharacterArmor_0 then
        CharacterArmor_0 = Instance.new("Folder")
        CharacterArmor_0.Name = "CharacterArmor"
        CharacterArmor_0.Parent = p26
    end
    for _, v30 in CharacterArmor_0:GetChildren() do
        v30:Destroy()
    end
    for _, v31 in CharacterArmor:GetChildren() do
        local v32 = v31:Clone()
        if v31:IsA("BasePart") and v32:IsA("BasePart") then
            v29[v31] = v32
            v32.Massless = true
        end
        for _, v33 in v31:QueryDescendants("BasePart") do
            local v34 = v_u_24(v31, v33)
            if v34 then
                local v35 = v32
                for _, v36 in v34 do
                    v32 = v32:FindFirstChild(v36)
                    if not v32 then
                        v32 = nil
                        break
                    end
                end
                if v32 and v32:IsA("BasePart") then
                    v29[v33] = v32
                    v32.Massless = true
                    v32 = v35
                else
                    v32 = v35
                end
            end
        end
        for _, v37 in v32:QueryDescendants("Weld, WeldConstraint, Motor6D") do
            v37:Destroy()
        end
        v32.Parent = CharacterArmor_0
    end
    return v29
end
local function v_u_44(p39, p40) -- name: CopyPartVisuals
    for _, v41 in p39:GetChildren() do
        if v41:IsA("BasePart") then
            local v42 = p40:FindFirstChild(v41.Name)
            if v42 and v42:IsA("BasePart") then
                v42.Color = v41.Color
                for _, v43 in v41:GetChildren() do
                    if v43:IsA("Decal") or v43:IsA("SurfaceAppearance") then
                        v43:Clone().Parent = v42
                    end
                end
            end
        end
    end
end
local function v_u_48(p45, p46) -- name: CopyTopLevelAppearance
    -- upvalues: (copy) v_u_11
    for _, v47 in p45:GetChildren() do
        if v_u_11[v47.ClassName] then
            v47:Clone().Parent = p46
        end
    end
end
local function v_u_74(p49, p50, p51) -- name: ReattachCharacterArmorWelds
    -- upvalues: (copy) v_u_24
    local CharacterArmor_1 = p49:FindFirstChild("CharacterArmor")
    local function v59(p53, p54, p55) -- name: CloneJoint
        if p53:IsA("Weld") then
            local v56 = Instance.new("Weld")
            v56.Name = p53.Name
            v56.C0 = p53.C0
            v56.C1 = p53.C1
            v56.Part0 = p54
            v56.Part1 = p55
            v56.Parent = p54
            return
        elseif p53:IsA("WeldConstraint") then
            local v57 = Instance.new("WeldConstraint")
            v57.Name = p53.Name
            v57.Part0 = p54
            v57.Part1 = p55
            v57.Parent = p54
        elseif p53:IsA("Motor6D") then
            local v58 = p55:FindFirstChild(p53.Name)
            if not (v58 and (v58:IsA("Motor6D") and v58)) then
                v58 = Instance.new("Motor6D")
            end
            v58.Name = p53.Name
            v58.C0 = p53.C0
            v58.C1 = p53.C1
            v58.Part0 = p54
            v58.Part1 = p55
            v58.Parent = p55
        end
    end
    for _, v60 in p49:QueryDescendants("Weld, WeldConstraint, Motor6D") do
        local Part0 = v60.Part0
        local Part1 = v60.Part1
        local v63
        if Part0 == nil or CharacterArmor_1 == nil then
            v63 = false
        else
            v63 = Part0:IsDescendantOf(CharacterArmor_1)
        end
        if v63 then
            ::l7::
            local v64, v65
            if Part0 then
                v64 = p51[Part0]
                if v64 then
                    v65 = p50
                else
                    local v66 = v_u_24(p49, Part0)
                    if v66 then
                        v65 = p50
                        for _, v67 in v66 do
                            p50 = p50:FindFirstChild(v67)
                            if not p50 then
                                p50 = nil
                                break
                            end
                        end
                        if p50 and p50:IsA("BasePart") then
                            v64 = p50
                        else
                            v64 = nil
                        end
                    else
                        v65 = p50
                        v64 = nil
                    end
                end
            else
                v65 = p50
                v64 = nil
            end
            if Part1 then
                local v68 = p51[Part1]
                if v68 then
                    p50 = v65
                    v65 = v68
                else
                    local v69 = v_u_24(p49, Part1)
                    if v69 then
                        p50 = v65
                        for _, v70 in v69 do
                            v65 = v65:FindFirstChild(v70)
                            if not v65 then
                                v65 = nil
                                break
                            end
                        end
                        if not (v65 and v65:IsA("BasePart")) then
                            v65 = nil
                        end
                    else
                        p50 = v65
                        v65 = nil
                    end
                end
            else
                p50 = v65
                v65 = nil
            end
            if v64 and v65 then
                v59(v60, v64, v65)
            end
        else
            local v71
            if Part1 == nil or CharacterArmor_1 == nil then
                v71 = false
            else
                v71 = Part1:IsDescendantOf(CharacterArmor_1)
            end
            if v71 then
                goto l7
            end
            local v72
            if Part0 == nil then
                v72 = false
            else
                v72 = Part0:HasTag("CharacterAccessory")
            end
            if v72 then
                goto l7
            end
            local v73
            if Part1 == nil then
                v73 = false
            else
                v73 = Part1:HasTag("CharacterAccessory")
            end
            if v73 then
                goto l7
            end
        end
    end
end
function v_u_1.Impulse(p_u_75, p76) -- name: Impulse
    -- upvalues: (copy) m_GetWeaponProperties, (copy) m_PartMultipliers, (copy) m_RunServiceController
    local v77 = p_u_75.CharacterModel:FindFirstChild(p76.Part)
    if v77 then
        local v78 = m_GetWeaponProperties(p76.Weapon)
        if v78 then
            local DirectionMultiplier = (v78.RagdollMultiplier or 45) * p76.DirectionMultiplier
            if m_PartMultipliers[p76.Part] then
                local v80 = m_PartMultipliers[p76.Part]
                DirectionMultiplier = DirectionMultiplier * (math.random(v80.Minimum, v80.Maximum) / 100)
            end
            local Unit = p76.Direction.Unit
            local v82 = 2.5 + (p76.Part == "Head" and 1 or 0)
            v77.AssemblyLinearVelocity = (Unit * DirectionMultiplier + Vector3.new(-0, -5, -0)) * v82
            p_u_75.Janitor:Add(task.delay(5, function()
                -- upvalues: (copy) p_u_75, (ref) m_RunServiceController
                local CharacterModel = p_u_75.CharacterModel
                if CharacterModel and (CharacterModel.PrimaryPart and CharacterModel.Parent) then
                    local v_u_84 = CharacterModel:QueryDescendants("BasePart:not(.CharacterAccessory)")
                    if v_u_84 and #v_u_84 ~= 0 then
                        local v_u_85 = 0
                        local v_u_86 = 0
                        local v87 = m_RunServiceController.CreateBindingName("Classes.Ragdoll.WaitForSettle")
                        p_u_75.Janitor:Add(m_RunServiceController.BindToHeartbeat(v87, function(p88)
                            -- upvalues: (copy) CharacterModel, (ref) p_u_75, (ref) v_u_86, (copy) v_u_84, (ref) v_u_85
                            if CharacterModel and (CharacterModel.PrimaryPart and CharacterModel.Parent) then
                                v_u_86 = v_u_86 + p88
                                local v89 = 0
                                local v90 = true
                                for _, v91 in v_u_84 do
                                    if v91 and v91.Parent then
                                        v89 = v89 + 1
                                        if not v91.Anchored then
                                            local v92
                                            if v91.AssemblyLinearVelocity.Magnitude < 0.13 then
                                                v92 = v91.AssemblyAngularVelocity.Magnitude < 0.13
                                            else
                                                v92 = false
                                            end
                                            if not v92 then
                                                v90 = false
                                            end
                                        end
                                    end
                                end
                                if v89 == 0 then
                                    p_u_75.Janitor:Remove("WaitForSettle")
                                    return
                                else
                                    if v90 then
                                        v_u_85 = v_u_85 + p88
                                    else
                                        v_u_85 = 0
                                    end
                                    if v_u_85 >= 0.2 or v_u_86 >= 2.5 then
                                        for _, v93 in v_u_84 do
                                            if v93 and v93.Parent then
                                                v93.Anchored = true
                                            end
                                        end
                                        p_u_75.Janitor:Remove("WaitForSettle")
                                    end
                                end
                            else
                                p_u_75.Janitor:Remove("WaitForSettle")
                                return
                            end
                        end), "Disconnect", "WaitForSettle")
                    end
                else
                    return
                end
            end))
        end
    else
        return
    end
end
function v_u_1.CloneCharacterModel(_, p94) -- name: CloneCharacterModel
    -- upvalues: (copy) DefaultRagdoll, (copy) v_u_38, (copy) v_u_44, (copy) v_u_48, (copy) v_u_74, (copy) v_u_16, (copy) Debris
    local v95 = DefaultRagdoll:Clone()
    v95.Name = p94.Name
    local UpperTorso = v95:FindFirstChild("UpperTorso")
    local UpperTorso_0 = p94:FindFirstChild("UpperTorso")
    if UpperTorso and UpperTorso_0 then
        UpperTorso.AssemblyLinearVelocity = UpperTorso_0.AssemblyLinearVelocity
    end
    local v98 = v_u_38(p94, v95)
    v_u_44(p94, v95)
    v_u_48(p94, v95)
    v_u_74(p94, v95, v98)
    v_u_16(p94)
    v95:PivotTo(p94:GetPivot())
    local Humanoid = v95:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.Sit = true
        Humanoid.PlatformStand = true
    end
    v95.Parent = Debris
    v95:AddTag("Ragdoll")
    if p94.Parent then
        p94:Destroy()
    end
    return v95
end
function v_u_1.SetupCharacterAppearance(p_u_100) -- name: SetupCharacterAppearance
    -- upvalues: (copy) v_u_19
    for _, v_u_101 in p_u_100.CharacterModel:GetChildren() do
        if v_u_101:IsA("Accessory") or (v_u_101:IsA("Clothing") or v_u_101:IsA("ShirtGraphic")) then
            v_u_101.Parent = nil
            task.defer(function()
                -- upvalues: (copy) v_u_101, (copy) p_u_100
                v_u_101.Parent = p_u_100.CharacterModel
            end)
        end
    end
    task.defer(function()
        -- upvalues: (copy) p_u_100, (ref) v_u_19
        if p_u_100.CharacterModel and p_u_100.CharacterModel.Parent then
            v_u_19(p_u_100.CharacterModel)
        end
    end)
end
function v_u_1.new(p102, p_u_103) -- name: new
    -- upvalues: (copy) v_u_1, (copy) m_Janitor, (copy) m_Signal, (copy) m_GameState
    local v104 = v_u_1
    local v_u_105 = setmetatable({}, v104)
    v_u_105.Janitor = m_Janitor.new()
    v_u_105.CharacterModel = v_u_105.Janitor:Add(v_u_105:CloneCharacterModel(p102))
    v_u_105.OnDestroy = v_u_105.Janitor:Add(m_Signal.new())
    v_u_105.IsDestroyed = false
    task.defer(function()
        -- upvalues: (ref) m_GameState, (copy) v_u_105, (copy) p_u_103
        local v106
        if m_GameState.GetState() == "Warmup" then
            v106 = workspace:GetAttribute("Gamemode") == "Deathmatch"
        else
            v106 = false
        end
        v_u_105:SetupCharacterAppearance()
        v_u_105:Impulse(p_u_103)
        task.delay(v106 and 10 or 15, function()
            -- upvalues: (ref) v_u_105
            v_u_105:Destroy()
        end)
    end)
    return v_u_105
end
function v_u_1.Destroy(p107) -- name: Destroy
    if not p107.IsDestroyed then
        p107.IsDestroyed = true
        p107.OnDestroy:Fire()
        task.defer(p107.Janitor.Destroy, p107.Janitor)
    end
end
return v_u_1
