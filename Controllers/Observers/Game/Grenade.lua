-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
game:GetService("UserInputService")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_GrenadeSimulator = require(ReplicatedStorage.Shared.GrenadeSimulator)
local Debris = workspace:WaitForChild("Debris")
local v_u_10 = {}
for _, v11 in ipairs(script.Executions:GetChildren()) do
    v_u_10[v11.Name] = require(v11)
end
local v_u_12 = {}
local function v_u_18(p13, p14) -- name: createRaycastParams
    -- upvalues: (copy) Debris, (copy) LocalPlayer
    local v15 = RaycastParams.new()
    v15.FilterType = Enum.RaycastFilterType.Exclude
    local v16 = { p13, Debris }
    if LocalPlayer and LocalPlayer.Character then
        local Character = LocalPlayer.Character
        table.insert(v16, Character)
    end
    v15.FilterDescendantsInstances = v16
    v15.RespectCanCollide = false
    v15.IgnoreWater = true
    if p14 then
        v15.CollisionGroup = p14
    end
    return v15
end
local function v_u_23(p19, p20, p21) -- name: reconcileState
    local Magnitude = (p19.state.position - p20).Magnitude
    if Magnitude > 8 then
        p19.state.position = p20
        p19.state.velocity = p21
        p19.visualPosition = p20
    elseif Magnitude > 2 then
        p19.state.position = p19.state.position:Lerp(p20, 0.08)
        p19.state.velocity = p19.state.velocity:Lerp(p21, 0.08)
    end
end
m_Remotes.Projectile.Spawn.Listen(function(p_u_24)
    -- upvalues: (copy) ReplicatedStorage, (copy) Debris, (copy) m_Janitor, (copy) v_u_18, (copy) v_u_12, (copy) m_RunServiceController, (copy) m_GrenadeSimulator
    local Id = p_u_24.Id
    local State = p_u_24.State
    local Physics = p_u_24.Physics
    task.defer(function()
        -- upvalues: (ref) ReplicatedStorage, (copy) p_u_24, (copy) Id, (copy) State, (ref) Debris, (ref) m_Janitor, (copy) Physics, (ref) v_u_18, (ref) v_u_12, (ref) m_RunServiceController, (ref) m_GrenadeSimulator
        local Character_0 = ReplicatedStorage.Assets.Weapons:FindFirstChild(p_u_24.Weapon)
        if Character_0 then
            Character_0 = Character_0:FindFirstChild("Character")
        end
        if Character_0 then
            local v29 = Character_0:Clone()
            v29.Name = Id
            v29:PivotTo(CFrame.new(State.Position))
            v29:SetAttribute("GrenadeName", p_u_24.Weapon)
            v29:AddTag("Grenade")
            v29.Parent = Debris
            for _, v30 in v29:GetDescendants() do
                if v30:IsA("BasePart") then
                    v30.Anchored = true
                    v30.CanCollide = false
                end
            end
            local v31 = m_Janitor.new()
            v31:Add(v29, "Destroy")
            local v32 = {
                ["position"] = nil,
                ["velocity"] = nil,
                ["angularVelocity"] = Vector3.new(0, 0, 0),
                ["timestamp"] = nil,
                ["simulationTime"] = 0,
                ["bounceCount"] = 0,
                ["isGrounded"] = false,
                ["isAtRest"] = false,
                ["hasTouched"] = false,
                ["accumulatedTime"] = 0,
                ["isJumpThrow"] = nil,
                ["position"] = State.Position,
                ["velocity"] = State.Velocity,
                ["timestamp"] = State.StartTime or workspace:GetServerTimeNow(),
                ["isJumpThrow"] = State.IsJumpThrow or false
            }
            local v33 = p_u_24.Weapon == "Molotov" and true or p_u_24.Weapon == "Incendiary Grenade"
            local v34 = {
                ["radius"] = nil,
                ["restitution"] = nil,
                ["maxBounces"] = nil,
                ["fuseTime"] = nil,
                ["minimumFuseTime"] = nil,
                ["explodeOnFloorImpact"] = nil,
                ["rangeScale"] = 1,
                ["isNearThrow"] = false,
                ["radius"] = Physics.Radius,
                ["restitution"] = Physics.Restitution,
                ["maxBounces"] = Physics.MaxBounces
            }
            local v35
            if Physics.FuseTime > 0 then
                v35 = Physics.FuseTime
            else
                v35 = nil
            end
            v34.fuseTime = v35
            v34.minimumFuseTime = v33 and 0.1 or nil
            v34.explodeOnFloorImpact = v33 and true or nil
            local Velocity = State.Velocity
            local v37
            if Velocity.Magnitude > 1 then
                local v38 = Velocity:Cross(Vector3.new(0, 1, 0))
                v37 = (v38.Magnitude <= 0.1 and Vector3.new(1, 0, 0) or v38.Unit) * Velocity.Magnitude * 0.5
            else
                v37 = Vector3.new(0, 0, 0)
            end
            local v_u_39 = {
                ["id"] = nil,
                ["model"] = nil,
                ["state"] = nil,
                ["config"] = nil,
                ["raycastParams"] = nil,
                ["visualPosition"] = nil,
                ["visualRotation"] = nil,
                ["angularVelocity"] = nil,
                ["isResolved"] = false,
                ["janitor"] = nil,
                ["id"] = Id,
                ["model"] = v29,
                ["state"] = v32,
                ["config"] = v34,
                ["raycastParams"] = v_u_18(v29, Physics.CollisionGroup),
                ["visualPosition"] = State.Position,
                ["visualRotation"] = CFrame.identity,
                ["angularVelocity"] = v37,
                ["janitor"] = v31
            }
            v_u_12[Id] = v_u_39
            local v_u_40 = nil
            v_u_40 = m_RunServiceController.BindToRenderStep(("Observers.Game.Grenade.%*.Predict"):format(v_u_39.id), function(p41)
                -- upvalues: (copy) v_u_39, (ref) v_u_40, (ref) m_GrenadeSimulator
                if v_u_39.isResolved then
                    v_u_40:Disconnect()
                    return
                elseif v_u_39.model.Parent then
                    v_u_39.state = m_GrenadeSimulator.simulate(v_u_39.state, v_u_39.config, v_u_39.raycastParams, p41).state
                    local v42 = p41 * 20
                    local v43 = math.min(1, v42)
                    v_u_39.visualPosition = v_u_39.visualPosition:Lerp(v_u_39.state.position, v43)
                    local Magnitude_0 = v_u_39.state.velocity.Magnitude
                    if Magnitude_0 < 2 then
                        local v45 = v_u_39
                        local angularVelocity = v_u_39.angularVelocity
                        local v47 = 1 - p41 * 8
                        v45.angularVelocity = angularVelocity * math.max(0, v47)
                    elseif Magnitude_0 < 5 then
                        local v48 = v_u_39
                        local angularVelocity_0 = v_u_39.angularVelocity
                        local v50 = 1 - p41 * 3
                        v48.angularVelocity = angularVelocity_0 * math.max(0, v50)
                    end
                    if v_u_39.angularVelocity.Magnitude > 0.01 then
                        local angularVelocity_1 = v_u_39.angularVelocity
                        local v52 = angularVelocity_1.Magnitude * p41
                        local Unit = angularVelocity_1.Unit
                        local v54 = CFrame.fromAxisAngle(Unit, v52)
                        v_u_39.visualRotation = v_u_39.visualRotation * v54
                    end
                    if v_u_39.model.PrimaryPart then
                        v_u_39.model:PivotTo(CFrame.new(v_u_39.visualPosition) * v_u_39.visualRotation)
                    end
                else
                    v_u_40:Disconnect()
                    v_u_39.isResolved = true
                end
            end)
            v_u_39.janitor:Add(v_u_40, "Disconnect")
        else
            warn("[Client Grenade] Base model not found for:", p_u_24.Weapon)
        end
    end)
end)
m_Remotes.Projectile.Bounce.Listen(function(p55)
    -- upvalues: (copy) v_u_12, (copy) v_u_23
    local v56 = v_u_12[p55.Id]
    if v56 then
        v_u_23(v56, p55.Position, p55.Velocity)
        v56.state.bounceCount = p55.BounceIndex
        v56.state.hasTouched = true
        local velocity = v56.state.velocity
        local Velocity_0 = p55.Velocity
        local v59 = Velocity_0 - velocity
        if v59.Magnitude > 1 then
            local v60 = v59:Cross(Velocity_0)
            local v61
            if v60.Magnitude > 0.1 then
                v61 = v60.Unit
            else
                local v62 = Velocity_0:Cross(Vector3.new(0, 1, 0))
                v61 = v62.Magnitude <= 0.1 and Vector3.new(1, 0, 0) or v62.Unit
            end
            local v63 = v61 * v59.Magnitude * 0.5
            v56.angularVelocity = v56.angularVelocity + v63
        end
    end
end)
m_Remotes.Projectile.Resolve.Listen(function(p64)
    -- upvalues: (copy) v_u_12
    local v65 = v_u_12[p64.Id]
    if v65 then
        v65.state.position = p64.Position
        v65.state.isAtRest = true
        v65.isResolved = true
        v65.angularVelocity = Vector3.new(0, 0, 0)
        if v65.model.PrimaryPart then
            v65.model:PivotTo(CFrame.new(p64.Position) * v65.visualRotation)
        end
        v65.model:SetAttribute("SimulationFinished", true)
        v_u_12[p64.Id] = nil
    end
end)
return m_Observers.observeTag("Grenade", function(p_u_66)
    -- upvalues: (copy) v_u_10, (copy) m_Janitor, (copy) v_u_12
    local v67 = p_u_66:GetAttribute("GrenadeName")
    if v67 then
        local v_u_68 = v_u_10[v67]
        local v_u_69 = m_Janitor.new()
        v_u_69:Add(p_u_66:GetAttributeChangedSignal("SimulationFinished"):Connect(function()
            -- upvalues: (copy) p_u_66, (copy) v_u_68, (copy) v_u_69
            local PrimaryPart = p_u_66.PrimaryPart
            if PrimaryPart and p_u_66:GetAttribute("SimulationFinished") then
                if v_u_68 then
                    v_u_68(v_u_69, PrimaryPart.Position, p_u_66)
                    return
                end
                for _, v71 in p_u_66:GetDescendants() do
                    if v71:IsA("BasePart") then
                        v71.Transparency = 1
                        v71.CanCollide = false
                    end
                end
                task.delay(0.5, function()
                    -- upvalues: (ref) p_u_66
                    if p_u_66 and p_u_66.Parent then
                        p_u_66:Destroy()
                    end
                end)
            end
        end))
        return function()
            -- upvalues: (copy) p_u_66, (ref) v_u_12, (copy) v_u_69
            local Name = p_u_66.Name
            if v_u_12[Name] then
                v_u_12[Name].isResolved = true
                v_u_12[Name] = nil
            end
            v_u_69:Destroy()
        end
    end
end)
