-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local Debris = workspace:WaitForChild("Debris")
local CurrentCamera = Workspace.CurrentCamera
local CharacterAnimations = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("CharacterAnimations")
local m_GetMovementAnimation = require(script.Components.GetMovementAnimation)
local m_CharacterAnimator = require(script.Classes.CharacterAnimator)
local m_InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Signal = require(ReplicatedStorage.Packages.Signal)
local v_u_20 = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
local v_u_21 = RaycastParams.new()
v_u_21.FilterType = Enum.RaycastFilterType.Exclude
v_u_21.RespectCanCollide = true
local v_u_22 = RaycastParams.new()
v_u_22.FilterType = Enum.RaycastFilterType.Exclude
v_u_22.RespectCanCollide = true
local v_u_23 = {
    Vector3.new(0, 0, 0),
    Vector3.new(0.8, 0, 0),
    Vector3.new(-0.8, 0, 0),
    Vector3.new(0, 0, 0.8),
    Vector3.new(0, 0, -0.8)
}
local v_u_24 = { Debris, Debris, Debris }
local v_u_25 = { Debris, Debris, Debris }
if not LocalPlayer:GetAttribute("DefaultCameraOffset") then
    LocalPlayer:SetAttribute("DefaultCameraOffset", Vector3.new(0, -0.15, 0))
end
if not LocalPlayer:GetAttribute("CrouchCameraOffset") then
    LocalPlayer:SetAttribute("CrouchCameraOffset", Vector3.new(0, -1.4, 0))
end
local v_u_26 = {
    ["SSG 08"] = 13.6,
    ["SG 553"] = 12,
    ["AWP"] = 8,
    ["AUG"] = 12,
    ["SCAR-20"] = 8,
    ["G3SG1"] = 8
}
local function v_u_32() -- name: BuildMovementAnimationNameCache
    -- upvalues: (copy) CharacterAnimations
    local Crouch = CharacterAnimations:FindFirstChild("Crouch")
    local v28 = CharacterAnimations:FindFirstChild("Movement")
    if v28 then
        v28 = v28:FindFirstChild("Walking")
    end
    if not (Crouch and v28) then
        return nil
    end
    local v29 = {
        ["CharacterIdle"] = true
    }
    for _, v30 in ipairs(Crouch:GetDescendants()) do
        if v30:IsA("Animation") then
            v29[v30.Name] = true
        end
    end
    for _, v31 in ipairs(v28:GetDescendants()) do
        if v31:IsA("Animation") then
            v29[v31.Name] = true
        end
    end
    return v29
end
local v_u_33 = nil
local v_u_34 = {
    ["CharacterIdle"] = true
}
local function v_u_49(p35, p36, p37) -- name: ClipVelocity
    local v38 = p35:Dot(p36) * p37
    if v38 >= 0 then
        return p35
    end
    local v39 = p35 - p36 * v38
    local v40 = v39.X
    if math.abs(v40) < 0.1 then
        local v41 = v39.Y
        local v42 = v39.Z
        v39 = Vector3.new(0, v41, v42)
    end
    local v43 = v39.Y
    if math.abs(v43) < 0.1 then
        local v44 = v39.X
        local v45 = v39.Z
        v39 = Vector3.new(v44, 0, v45)
    end
    local v46 = v39.Z
    if math.abs(v46) < 0.1 then
        local v47 = v39.X
        local v48 = v39.Y
        v39 = Vector3.new(v47, v48, 0)
    end
    return v39
end
local function v_u_51(p50) -- name: ResetSpawnHumanoidState
    p50.PlatformStand = false
    p50.Sit = false
    p50.Jump = false
    p50:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    p50:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    p50:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    p50:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
    p50:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    p50:ChangeState(Enum.HumanoidStateType.Running)
end
function v_u_1.GetMaxSpeed(p52) -- name: GetMaxSpeed
    -- upvalues: (copy) m_GameState, (copy) LocalPlayer, (copy) m_InventoryController, (copy) v_u_26
    if m_GameState.GetState() == "Buy Period" then
        return 0
    elseif LocalPlayer:GetAttribute("IsDefusingBomb") then
        return 0
    elseif LocalPlayer:GetAttribute("IsRescuingHostage") then
        return 0
    else
        local v53 = LocalPlayer:GetAttribute("IsCarryingHostage") and 0.75 or 1
        local v54 = m_InventoryController.getCurrentEquipped()
        if v54 and (v54.Properties.Class == "C4" and v54.IsPlanting) then
            return 0
        else
            local v55 = 20
            if v54 and v54.Properties then
                if v54.CurrentWalkSpeedOverride then
                    v55 = v54.CurrentWalkSpeedOverride
                elseif v54.Properties.WalkSpeed then
                    v55 = v54.Properties.WalkSpeed
                end
            end
            local v56 = v54 and (v54.IsAiming and v_u_26[v54.Name])
            if v56 then
                local v57 = p52.IsClimbing and 0.5 or 1
                local v58 = p52.IsWalking and 0.52 or 1
                local v59 = p52.IsCrouching and not p52.IsJumping and 0.34 or 1
                return v56 * v58 * v57 * v59
            else
                local v60 = p52.IsCrouching and not p52.IsJumping and 0.34 or (p52.IsWalking and 0.52 or 1)
                local v61 = p52.IsClimbing and 0.5 or 1
                if p52.CanceledInertia then
                    v55 = 2.424
                elseif p52.IsJumping and not (p52.IsAirStrafing or p52.CanceledInertia) then
                    local Magnitude = p52.LocalVelocityOnJump.Magnitude
                    v55 = math.max(Magnitude, 2.424)
                end
                return v55 * v60 * v61 * v53 * (tick() < p52.ShotSlowUntil and p52.ShotSlowMultiplier or 1)
            end
        end
    end
end
function v_u_1.ValidateHumanoidRootPart(p63) -- name: ValidateHumanoidRootPart
    local HumanoidRootPart = p63.HumanoidRootPart
    if HumanoidRootPart and (HumanoidRootPart.Parent and HumanoidRootPart:IsDescendantOf(workspace)) then
        return HumanoidRootPart
    else
        return nil
    end
end
function v_u_1.TakeStamina(p65, p66) -- name: TakeStamina
    local v67 = p65.Stamina - p66
    p65.Stamina = math.clamp(v67, 0, 100)
end
function v_u_1.ApplyFriction(p68, p69) -- name: ApplyFriction
    if p68.IsJumping then
        return
    else
        local Magnitude_0 = p68.GlobalVelocity.Magnitude
        if Magnitude_0 >= 0.001 then
            local v71
            if p68.GlobalDirection.Magnitude < 0.1 then
                v71 = math.max(Magnitude_0, 5)
            else
                v71 = Magnitude_0
            end
            local v72 = Magnitude_0 - v71 * 6 * p69
            local v73 = math.max(v72, 0)
            if v73 ~= Magnitude_0 then
                if v73 == 0 then
                    p68.GlobalVelocity = Vector3.new(0, 0, 0)
                    return
                end
                p68.GlobalVelocity = p68.GlobalVelocity.Unit * v73
            end
        end
    end
end
function v_u_1.Accelerate(p74, p75, p76, p77, p78) -- name: Accelerate
    local v79 = p76 - p74.GlobalVelocity:Dot(p75)
    if v79 > 0 then
        local v80 = p77 * p78 * p76
        local v81 = math.min(v80, v79)
        p74.GlobalVelocity = p74.GlobalVelocity + p75 * v81
    end
end
function v_u_1.AirAccelerate(p82, p83, p84, p85) -- name: AirAccelerate
    local v86 = math.min(p84, 2.5)
    local v87 = v86 - p82.GlobalVelocity:Dot(p83)
    if v87 > 0 then
        local v88 = v86 * 100 * p85
        if v87 >= v88 then
            v87 = v88
        end
        p82.GlobalVelocity = p82.GlobalVelocity + p83 * v87
    end
end
function v_u_1.CheckGroundContact(p89) -- name: CheckGroundContact
    -- upvalues: (copy) Workspace, (copy) v_u_25, (copy) Debris, (copy) v_u_22, (copy) v_u_23
    if not p89.HumanoidRootPart then
        return false, nil, nil
    end
    local CurrentCamera_0 = Workspace.CurrentCamera
    v_u_25[1] = p89.Character
    v_u_25[2] = CurrentCamera_0 or Debris
    v_u_22.FilterDescendantsInstances = v_u_25
    local v91 = p89.Player:GetAttribute("Team")
    if v91 and workspace:GetAttribute("VIPPlayerCollisionsEnabled") ~= true then
        v_u_22.CollisionGroup = v91
    else
        v_u_22.CollisionGroup = "Default"
    end
    local Position = p89.HumanoidRootPart.Position
    for _, v93 in ipairs(v_u_23) do
        local v94 = Position + v93
        local v95 = workspace:Raycast(v94, Vector3.new(0, -3.1, 0), v_u_22)
        if v95 and (v95.Normal.Y > 0.7 and v95.Instance.CanCollide) then
            return true, v95.Instance, v95.Normal
        end
    end
    return false, nil, nil
end
function v_u_1.SetTargetMoveDirection(p96, p97) -- name: SetTargetMoveDirection
    if not p97:FuzzyEq(p96.TargetMoveDirection, 0.001) then
        p96.TargetMoveDirection = p97
        p96.MoveDirectionChanged:Fire(p97)
    end
end
function v_u_1.Jump(p98) -- name: Jump
    -- upvalues: (copy) m_GameState, (copy) LocalPlayer, (copy) m_InventoryController
    if m_GameState.GetState() == "Buy Period" then
        return
    elseif LocalPlayer:GetAttribute("IsDefusingBomb") then
        return
    else
        local v99 = m_InventoryController.getCurrentEquipped()
        if v99 and (v99.Properties.Class == "C4" and v99.IsPlanting) then
            return
        elseif p98.Character and (p98.Humanoid and p98.HumanoidRootPart) then
            local LastJumpTick = tick() - p98.LastJumpTick
            local v101 = tick() - p98.LastLandTick <= 0.5
            if LastJumpTick < 0.15 and (p98.LastJumpTick > 0 and (not v101 or (p98.LastAirTime or 0) < 0.15)) then
                p98.IsJumpRequested = false
                return
            else
                if not p98.IsClimbing then
                    local v102 = p98.Humanoid:GetState()
                    if v102 == Enum.HumanoidStateType.Freefall or v102 == Enum.HumanoidStateType.Jumping then
                        p98.IsJumpRequested = false
                        return
                    end
                end
                local HumanoidRootPart_0 = p98.HumanoidRootPart
                if p98.IsClimbing and (p98.IsJumpRequested and not p98.JumpedOffLadder) then
                    local v104 = tick()
                    p98.LastJumpTick = v104
                    p98.LastFreefallTick = v104
                    p98.PeakFallVelocity = 0
                    p98.LandingVelocityY = nil
                    p98.LastLadderJumpTick = tick()
                    p98.JumpedOffLadder = true
                    local Unit = Vector3.new(0, 0, 1)
                    local LadderZone = p98.LadderZone
                    if LadderZone then
                        local v107 = p98:GetLadderCFrame(LadderZone)
                        if v107 then
                            local Position_0 = HumanoidRootPart_0.Position
                            local Position_1 = v107.Position
                            local v110 = Position_1.X - Position_0.X
                            local v111 = Position_1.Z - Position_0.Z
                            local v112 = Vector3.new(v110, 0, v111)
                            if v112.Magnitude > 0.1 then
                                Unit = -v112.Unit
                            end
                        end
                    end
                    local v113 = p98.LadderClimbPercentage or 0.5
                    local v114 = -1 - v113 * 2
                    local v115 = Unit.X * 12
                    local v116 = Unit.Z * 12
                    local v117 = Vector3.new(v115, v114, v116)
                    print("[Ladder Debug] Jumping off ladder", "climb%:", string.format("%.2f", v113), "jumpVel:", v117)
                    p98.ClimbEnded:Fire(p98.LadderZone, true)
                    local v118
                    if v117 == v117 then
                        v118 = v117.Magnitude < 10000
                    else
                        v118 = false
                    end
                    if v118 then
                        HumanoidRootPart_0.AssemblyLinearVelocity = v117
                        local v119 = v117.X
                        local v120 = v117.Z
                        p98.GlobalVelocity = Vector3.new(v119, 0, v120)
                    end
                    p98.ReadyToJump = false
                    p98.Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                elseif not p98.IsClimbing and (not p98.IsJumping and (p98.IsJumpRequested and p98.Stamina >= 20)) then
                    p98.Humanoid.JumpPower = 19.5
                    if p98.AgainstWall then
                        p98.GlobalVelocity = Vector3.new(0, 0, 0)
                    end
                    local v121 = p98.HumanoidRootPart.AssemblyLinearVelocity.X
                    local v122 = p98.HumanoidRootPart.AssemblyLinearVelocity.Z
                    local v123 = Vector3.new(v121, 0, v122)
                    local MoveDirection = p98.Humanoid.MoveDirection
                    if v123.Magnitude < 1 and MoveDirection.Magnitude > 0.1 then
                        local v125 = RaycastParams.new()
                        v125.FilterType = Enum.RaycastFilterType.Exclude
                        v125.FilterDescendantsInstances = { p98.Character }
                        local v126 = workspace:Raycast(p98.HumanoidRootPart.Position, MoveDirection * 2, v125)
                        if v126 then
                            local v127 = v126.Normal.Y
                            if math.abs(v127) < 0.5 then
                                local v128 = v126.Normal.X
                                local v129 = v126.Normal.Z
                                local v130 = Vector3.new(v128, 0, v129).Unit * 400
                                local HumanoidRootPart_1 = p98.HumanoidRootPart
                                local v132 = v130.X
                                local v133 = p98.HumanoidRootPart.AssemblyLinearVelocity.Y
                                local v134 = v130.Z
                                HumanoidRootPart_1:ApplyImpulse((Vector3.new(v132, v133, v134)))
                            end
                        end
                    end
                    if p98.HumanoidRootPart.AssemblyLinearVelocity.Y > 5 then
                        local AssemblyLinearVelocity = p98.HumanoidRootPart.AssemblyLinearVelocity
                        local HumanoidRootPart_2 = p98.HumanoidRootPart
                        local v137 = AssemblyLinearVelocity.X
                        local v138 = AssemblyLinearVelocity.Z
                        HumanoidRootPart_2.AssemblyLinearVelocity = Vector3.new(v137, 0, v138)
                    end
                    p98.Humanoid.Jump = true
                    p98.IsJumping = true
                    p98.LastJumpTick = tick()
                    p98.ReadyToJump = false
                    p98.IsJumpRequested = false
                    p98.Jumping:Fire()
                    p98.CharacterAnimator:play("Jump", 0.2)
                end
            end
        else
            return
        end
    end
end
function v_u_1.AddLadder(p139, p140) -- name: AddLadder
    if not p139.LadderZones[p140] then
        p140.Anchored = true
        p140.CollisionGroup = "Debris"
        p140.CastShadow = false
        p140.CanCollide = false
        p140.CanTouch = false
        p140.Transparency = 1
        p139.LadderZones[p140] = {
            ["CFrame"] = p140.CFrame,
            ["Extents"] = p140.Size / 2,
            ["Part"] = p140
        }
    end
end
function v_u_1.RemoveLadder(p141, p142) -- name: RemoveLadder
    p141.LadderZones[p142] = nil
end
function v_u_1.GetLadderCFrame(_, p143) -- name: GetLadderCFrame
    if p143.Part and p143.Part.Parent then
        return p143.Part.CFrame
    else
        return nil
    end
end
function v_u_1.ForceExitLadder(p144, p145) -- name: ForceExitLadder
    if p144.IsClimbing then
        print("[Ladder Debug] ForceExitLadder reason:", p145 or "unknown")
        p144.VectorForce.Enabled = false
        p144.IsClimbing = false
        p144.LadderZone = nil
        p144.LadderClimbPercentage = 0
        p144.LastLadderJumpTick = tick()
        if p144.Humanoid then
            p144.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        end
        p144.Climbing:Fire()
    end
end
function v_u_1.GetLadderClimbPercentage(p146, p147) -- name: GetLadderClimbPercentage
    local v148 = p146:ValidateHumanoidRootPart()
    if not v148 then
        return 0
    end
    local v149 = p146:GetLadderCFrame(p147)
    if not v149 then
        return 0
    end
    local v150 = p147.Extents.Y * 2
    if v150 <= 0 then
        warn("[Character] Invalid ladder height:", v150)
        return 0.5
    end
    local Position_2 = v149.Position
    local v152 = p147.Extents.Y
    local v153 = Position_2 - Vector3.new(0, v152, 0)
    local Position_3 = v148.Position
    if Position_3 ~= Position_3 or v153 ~= v153 then
        warn("[Character] Invalid positions in climb calculation")
        return 0.5
    end
    local v155 = (Position_3.Y - v153.Y) / v150
    local v156 = math.clamp(v155, 0, 1)
    return v156 ~= v156 and 0.5 or v156
end
function v_u_1.CheckLadderOverlap(p157, p158) -- name: CheckLadderOverlap
    local v159 = p157:ValidateHumanoidRootPart()
    if v159 then
        local v160 = p157:GetLadderCFrame(p158)
        if v160 then
            local Position_4 = v159.Position
            local Extents = p158.Extents
            local v163 = v160:Inverse() * Position_4
            local v164 = v163.X
            local v165 = math.abs(v164)
            local v166 = v163.Z
            local v167 = math.abs(v166)
            local v168 = v163.Y >= Extents.Y - 1
            local v169 = p157.Character:FindFirstChildOfClass("Humanoid")
            if v169 then
                v169 = v169.FloorMaterial ~= Enum.Material.Air
            end
            if v168 and v169 then
                return false
            else
                local v170
                if Extents.X > Extents.Z then
                    if Extents.Z * 0.5 <= v167 then
                        v170 = v167 <= Extents.Z + 2
                    else
                        v170 = false
                    end
                elseif Extents.X * 0.5 <= v165 then
                    v170 = v165 <= Extents.X + 2
                else
                    v170 = false
                end
                if v163.Y <= Extents.Y + 0.8 + (v170 and 3 or 0.5) and v163.Y >= -(Extents.Y + 0.8 + 3) then
                    if Extents.X > Extents.Z then
                        if Extents.X + 0.8 < v165 then
                            return false
                        elseif Extents.X < v165 and v167 < Extents.Z * 2 then
                            return false
                        else
                            return v167 <= Extents.Z + 2
                        end
                    elseif Extents.Z + 0.8 < v167 then
                        return false
                    elseif Extents.Z < v167 and v165 < Extents.X * 2 then
                        return false
                    else
                        return v165 <= Extents.X + 2
                    end
                else
                    return false
                end
            end
        else
            return false
        end
    else
        return false
    end
end
function v_u_1.FindNearestLadder(p171) -- name: FindNearestLadder
    local v172 = p171:ValidateHumanoidRootPart()
    if not v172 then
        return nil
    end
    local Position_5 = v172.Position
    local v174 = 0
    local v175 = (1 / 0)
    local v176 = nil
    for _, v177 in pairs(p171.LadderZones) do
        v174 = v174 + 1
        local v178 = p171:GetLadderCFrame(v177)
        if v178 then
            local v179 = Position_5.X - v178.Position.X
            local v180 = Position_5.Z - v178.Position.Z
            local Magnitude_1 = Vector3.new(v179, 0, v180).Magnitude
            if Magnitude_1 <= 2 and (p171:CheckLadderOverlap(v177) and Magnitude_1 < v175) then
                v176 = v177
                v175 = Magnitude_1
            end
        end
    end
    local _ = v174 == 0
    return v176
end
function v_u_1.ResolveGroundedFreefall(p182, p183, p184) -- name: ResolveGroundedFreefall
    local v185 = p183 or p182:ValidateHumanoidRootPart()
    if not v185 then
        return false
    end
    if p182.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        return false
    end
    if p184 == nil then
        p184 = p182:CheckGroundContact()
    end
    if not p184 then
        return false
    end
    if v185.AssemblyLinearVelocity.Y > 1 then
        return false
    end
    local AssemblyLinearVelocity_0 = v185.AssemblyLinearVelocity
    local v187 = AssemblyLinearVelocity_0.X
    local v188 = AssemblyLinearVelocity_0.Z
    local v189 = Vector3.new(v187, 0, v188)
    local v190
    if v189 == v189 then
        v190 = v189.Magnitude < 10000
    else
        v190 = false
    end
    if v190 then
        v185.AssemblyLinearVelocity = v189
    end
    p182.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    p182.IsJumping = false
    p182.IsLanded = true
    p182.ReadyToJump = true
    p182.LockedAirDirection = nil
    return true
end
function v_u_1.MoveFunction(p191, p192, p193) -- name: MoveFunction
    -- upvalues: (copy) CurrentCamera, (copy) Workspace, (copy) v_u_24, (copy) Debris, (copy) v_u_21, (copy) v_u_49, (copy) m_MenuState, (copy) v_u_20
    local v194 = p191:ValidateHumanoidRootPart()
    if not v194 then
        if p191.IsClimbing then
            p191:ForceExitLadder("Invalid HumanoidRootPart at MoveFunction start")
        end
        return
    end
    local v195 = tick()
    local LastMoveUpdate = v195 - p191.LastMoveUpdate
    local v197, _, _ = p191:CheckGroundContact()
    p191:ResolveGroundedFreefall(v194, v197)
    local v198 = p191:GetMaxSpeed()
    p191.MaxSpeed = v198
    if v198 <= 0 then
        p191.GlobalDirection = Vector3.new(0, 0, 0)
        p191.LocalVelocity = Vector3.new(0, 0, 0)
        p191.GlobalVelocity = Vector3.new(0, 0, 0)
        local v199 = v194.AssemblyLinearVelocity.Y
        v194.AssemblyLinearVelocity = Vector3.new(0, v199, 0)
        v194.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        p191.Humanoid.WalkSpeed = 0
        p191.LastMoveUpdate = v195
        return
    end
    p191.GlobalDirection = Vector3.new(0, 0, 0)
    local v200 = Vector3.new(0, 0, 0)
    local LastJumpTick_0 = tick() - p191.LastJumpTick
    if p191.IsJumping and (v197 and LastJumpTick_0 >= 0.15) then
        local v202 = v194.AssemblyLinearVelocity.Y
        if v202 <= 1 then
            p191.LastAirTime = tick() - (p191.LastFreefallTick or p191.LastJumpTick)
            p191.LandingVelocityY = p191.PeakFallVelocity or v202
            p191.IsJumping = false
            p191.IsLanded = true
            p191.LandAtPosition = v194.CFrame.Position
            p191.LastLandTick = tick()
            p191.ReadyToJump = true
            p191.LockedAirDirection = nil
            p191.CharacterAnimator:stop("Jump", 0.2)
            p191.Landed:Fire()
        end
    end
    local v203 = p191.Humanoid:GetState()
    if v203 == Enum.HumanoidStateType.Freefall and true or v203 == Enum.HumanoidStateType.Jumping then
        if not p191.LastFreefallTick then
            p191.LastFreefallTick = tick()
            p191.PeakFallVelocity = 0
        end
        local v204 = v194.AssemblyLinearVelocity.Y
        if v204 < (p191.PeakFallVelocity or 0) then
            p191.PeakFallVelocity = v204
        end
    end
    local CFrame = CurrentCamera.CFrame
    local Position_6 = CFrame.Position
    local v207, v208, v209 = CFrame:ToEulerAnglesXYZ()
    local v210 = CFrame.new(Position_6) * CFrame.fromEulerAnglesXYZ(v207, v208, v209)
    if p192.Magnitude > 0 then
        if p193 then
            p191.GlobalDirection = v210:VectorToWorldSpace(p192)
        else
            p191.GlobalDirection = p192
            p192 = v210:VectorToObjectSpace(p192)
        end
    else
        p192 = v200
    end
    local v211 = v210.LookVector.X
    local v212 = v210.LookVector.Z
    local v213 = Vector3.new(v211, 0, v212)
    local v214 = p191.LastCameraCFrame.LookVector.X
    local v215 = p191.LastCameraCFrame.LookVector.Z
    local v216 = Vector3.new(v214, 0, v215):Cross(v213).Y
    p191.LocalVelocity = v210:VectorToObjectSpace(p191.GlobalVelocity)
    local v217 = p191.LocalVelocity:Angle(p192, Vector3.new(0, 1, 0))
    local _ = v217 == v217
    v213.Unit:Angle(p191.GlobalDirection, Vector3.new(0, 1, 0))
    local v218 = p191.GlobalDirection:Angle(p191.GlobalVelocity, Vector3.new(0, 1, 0))
    math.abs(v218)
    local v219 = p192.X
    local v220 = math.abs(v219) > 0.1
    local v221 = p192.Z <= 0
    local v222 = math.abs(v216) > 0.02
    local v223 = p192.X
    local v224 = math.sign(v223)
    local v225 = math.sign(v216)
    local IsJumping = p191.IsJumping
    if IsJumping then
        if v220 then
            if v221 then
                if v222 then
                    v222 = v224 == -v225
                end
            else
                v222 = v221
            end
        else
            v222 = v220
        end
    else
        v222 = IsJumping
    end
    p191.IsAirStrafing = v222
    local v227
    if p191.GlobalDirection.Magnitude > 0 then
        v227 = p191.GlobalDirection.Unit
    else
        v198 = 0
        v227 = Vector3.new(0, 0, 0)
    end
    if p191.IsJumping then
        local AssemblyLinearVelocity_1 = v194.AssemblyLinearVelocity
        local v229 = AssemblyLinearVelocity_1.X
        local v230 = AssemblyLinearVelocity_1.Z
        p191.GlobalVelocity = Vector3.new(v229, 0, v230)
        if v198 > 0 then
            p191:AirAccelerate(v227, v198, LastMoveUpdate)
        end
        if p191.IsAirStrafing then
            local Magnitude_2 = p191.GlobalVelocity.Magnitude
            if Magnitude_2 > 0.1 then
                local v232 = v213.X
                local v233 = v213.Z
                local v234 = Vector3.new(v232, 0, v233)
                if v234.Magnitude > 0 then
                    local Unit_0 = v234.Unit
                    local Unit_1 = p191.GlobalVelocity.Unit
                    local v237 = 5 * LastMoveUpdate * 10
                    local v238 = math.min(1, v237)
                    local v239 = Unit_1 + (Unit_0 - Unit_1) * v238
                    if v239.Magnitude > 0 then
                        p191.GlobalVelocity = v239.Unit * Magnitude_2
                    end
                end
            end
        end
        local Magnitude_3 = p191.GlobalVelocity.Magnitude
        if Magnitude_3 > 24.5 then
            local v241 = 24.5 / Magnitude_3
            p191.GlobalVelocity = p191.GlobalVelocity * v241
        end
        local v242 = p191.GlobalVelocity.X
        local v243 = AssemblyLinearVelocity_1.Y
        local v244 = p191.GlobalVelocity.Z
        local v245 = Vector3.new(v242, v243, v244)
        local v246
        if v245 == v245 then
            v246 = v245.Magnitude < 10000
        else
            v246 = false
        end
        if v246 then
            v194.AssemblyLinearVelocity = v245
        end
    else
        local v247
        if tick() - p191.LastLandTick < 0.5 then
            v247 = p191.IsJumpRequested
        else
            v247 = false
        end
        if not v247 then
            p191:ApplyFriction(LastMoveUpdate)
        end
        if v198 > 0 then
            p191:Accelerate(v227, math.min(v198, 24.5), 6, LastMoveUpdate)
        end
    end
    local v248 = p191.GlobalVelocity.X
    local v249 = p191.GlobalVelocity.Z
    local Magnitude_4 = Vector3.new(v248, 0, v249).Magnitude
    local _ = p191.IsJumping or p191.IsBhopAttempt
    local v251 = 24.5
    if v251 < Magnitude_4 then
        local v252 = v251 / Magnitude_4
        local v253 = p191.GlobalVelocity.X * v252
        local v254 = p191.GlobalVelocity.Y
        local v255 = p191.GlobalVelocity.Z * v252
        p191.GlobalVelocity = Vector3.new(v253, v254, v255)
    end
    p191.Humanoid.WalkSpeed = p191.LocalVelocity.Magnitude
    local CurrentCamera_1 = Workspace.CurrentCamera
    v_u_24[1] = p191.Character
    v_u_24[2] = CurrentCamera_1 or Debris
    v_u_21.FilterDescendantsInstances = v_u_24
    local v257 = p191.Player:GetAttribute("Team")
    if v257 and workspace:GetAttribute("VIPPlayerCollisionsEnabled") ~= true then
        v_u_21.CollisionGroup = v257
    else
        v_u_21.CollisionGroup = "Default"
    end
    p191.AgainstWall = false
    p191.WallNormal = nil
    if p191.IsJumping then
        local AssemblyLinearVelocity_2 = v194.AssemblyLinearVelocity
        local v259 = AssemblyLinearVelocity_2.X
        local v260 = AssemblyLinearVelocity_2.Z
        local v261 = Vector3.new(v259, 0, v260)
        local Magnitude_5 = v261.Magnitude
        local Position_7 = v194.Position
        local v264 = tick()
        if p191.LastWallNormal and v264 - p191.LastWallHitTime < 0.15 then
            local LastWallNormal = p191.LastWallNormal
            local v266 = LastWallNormal.X
            local v267 = LastWallNormal.Z
            local v268 = v261:Dot((Vector3.new(v266, 0, v267)))
            if v268 > 0.5 then
                local v269 = LastWallNormal.X
                local v270 = LastWallNormal.Z
                AssemblyLinearVelocity_2 = AssemblyLinearVelocity_2 - Vector3.new(v269, 0, v270) * v268
                local v271
                if AssemblyLinearVelocity_2 == AssemblyLinearVelocity_2 then
                    v271 = AssemblyLinearVelocity_2.Magnitude < 10000
                else
                    v271 = false
                end
                if v271 then
                    v194.AssemblyLinearVelocity = AssemblyLinearVelocity_2
                end
                local v272 = AssemblyLinearVelocity_2.X
                local v273 = AssemblyLinearVelocity_2.Z
                v261 = Vector3.new(v272, 0, v273)
                Magnitude_5 = v261.Magnitude
            end
        end
        local v274 = { Vector3.new(0, 0, 0), v194.CFrame.RightVector * 1 * 0.8, -v194.CFrame.RightVector * 1 * 0.8 }
        local v275 = {}
        if Magnitude_5 > 0.5 then
            local Unit_2 = v261.Unit
            table.insert(v275, Unit_2)
        end
        local v277 = p191.GlobalDirection.X
        local v278 = p191.GlobalDirection.Z
        local v279 = Vector3.new(v277, 0, v278)
        if v279.Magnitude > 0.1 then
            local Unit_3 = v279.Unit
            table.insert(v275, Unit_3)
        end
        for _, v281 in ipairs(v275) do
            for _, v282 in ipairs(v274) do
                local v283 = Position_7 + v282
                local v284 = v281 * (0.5 + (Magnitude_5 > 0.5 and (Magnitude_5 * 0.02 or 0.3) or 0.3))
                local v285 = workspace:Raycast(v283, v284, v_u_21)
                if v285 then
                    local Normal = v285.Normal
                    local v287 = Normal.Y
                    if math.abs(v287) < 0.7 then
                        p191.AgainstWall = true
                        p191.WallNormal = Normal
                        p191.LastWallNormal = Normal
                        p191.LastWallHitTime = v264
                        local v288 = v_u_49(AssemblyLinearVelocity_2, Normal, 1)
                        local v289 = v288.X
                        local v290 = v288.Z
                        local v291 = Vector3.new(v289, 0, v290)
                        if v291.Magnitude < Magnitude_5 * 0.3 then
                            local v292 = AssemblyLinearVelocity_2.Y
                            v288 = Vector3.new(0, v292, 0)
                            p191.GlobalVelocity = Vector3.new(0, 0, 0)
                        else
                            p191.GlobalVelocity = v291
                        end
                        local v293
                        if v288 == v288 then
                            v293 = v288.Magnitude < 10000
                        else
                            v293 = false
                        end
                        if v293 then
                            v194.AssemblyLinearVelocity = v288
                        end
                        break
                    end
                end
            end
            if p191.AgainstWall then
                break
            end
        end
    end
    if v194 and (p191.IsCrouching and not p191.CrouchInputDown) then
        p191.CrouchHeadBlocked = workspace:Spherecast(v194.CFrame.Position, 1.5, Vector3.new(0, 1, 0), v_u_21) ~= nil
    end
    if v194 then
        if p191.IsClimbing then
            local LadderZone_0 = p191.LadderZone
            if LadderZone_0 then
                local v295 = p191:GetLadderCFrame(LadderZone_0)
                if not v295 then
                    p191:ForceExitLadder("Ladder part removed")
                    return
                end
                local Position_8 = v194.Position
                local v297 = Position_8.Y - 2.5
                local Position_9 = v295.Position
                local v299 = Position_9.Y - LadderZone_0.Extents.Y
                local v300 = Position_9.Y + LadderZone_0.Extents.Y
                local v301 = v300 - v299
                local v302 = (v297 - v299) / v301
                local v303 = math.clamp(v302, 0, 1)
                p191.LadderClimbPercentage = v303
                local v304 = Position_8.X - Position_9.X
                local v305 = Position_8.Z - Position_9.Z
                local Magnitude_6 = Vector3.new(v304, 0, v305).Magnitude
                if Magnitude_6 > 50 then
                    print("[Ladder Debug] Sanity check failed - distance:", string.format("%.2f", Magnitude_6))
                    p191:ForceExitLadder("Distance sanity check failed")
                    return
                end
                local v307 = v303 <= 0.15
                local v308 = v303 >= 0.98
                local v309 = Magnitude_6 > 2.5
                local GlobalDirection = p191.GlobalDirection
                local v311 = GlobalDirection.X
                local v312 = GlobalDirection.Z
                local Unit_4 = Vector3.new(v311, 0, v312)
                if Unit_4.Magnitude > 0.1 then
                    Unit_4 = Unit_4.Unit
                end
                local v314 = v210.LookVector.X
                local v315 = v210.LookVector.Z
                local Unit_5 = Vector3.new(v314, 0, v315)
                if Unit_5.Magnitude > 0 then
                    Unit_5 = Unit_5.Unit
                end
                local v317 = Unit_4:Dot(Unit_5)
                local v318 = Position_9.X - Position_8.X
                local v319 = Position_9.Z - Position_8.Z
                local v320 = Vector3.new(v318, 0, v319)
                if v320.Magnitude > 0.1 and Unit_5:Dot(v320.Unit) <= 0 then
                    v317 = -v317
                end
                local v321 = v317 > 0.1
                local v322 = v317 < -0.1
                local v323 = tick() - (p191.LastLadderAttachTick or 0) >= 0.1
                if v309 then
                    v323 = v309
                elseif not (v307 and (v322 and v323)) then
                    if v308 then
                        if not v321 then
                            v323 = v321
                        end
                    else
                        v323 = v308
                    end
                end
                if v300 + 0.5 <= v297 and true or v323 then
                    print("[Ladder Debug] Detaching", "reason:", v309 and "TooFar" or (v307 and v322 and "BottomExit" or (v308 and v321 and "TopExit" or "FeetAboveTop")), "climb%:", string.format("%.2f", v303), "dist:", string.format("%.2f", Magnitude_6), "verticalInput:", string.format("%.2f", v317))
                    if v308 and v321 then
                        local v324 = Unit_5 * 8
                        local v325 = v324.X
                        local v326 = v324.Z
                        local v327 = Vector3.new(v325, 2, v326)
                        local v328
                        if v327 == v327 then
                            v328 = v327.Magnitude < 10000
                        else
                            v328 = false
                        end
                        if v328 then
                            v194.AssemblyLinearVelocity = v327
                            p191.GlobalVelocity = v324
                        end
                    end
                    p191.ClimbEnded:Fire(LadderZone_0, false)
                end
            end
        else
            local v329 = tick() - (p191.LastLadderJumpTick or 0) > (p191.JumpedOffLadder and 0.5 or 0.25) and p191:FindNearestLadder()
            if v329 then
                p191.ClimbBegan:Fire(v329)
            end
        end
    end
    local v330 = Vector3.new(0, 0, 0)
    if p191.IsClimbing and not p191.JumpedOffLadder then
        local LadderZone_1 = p191.LadderZone
        p191.GlobalVelocity = Vector3.new(0, 0, 0)
        if LadderZone_1 and v194 then
            local GlobalDirection_0 = p191.GlobalDirection
            local v333 = GlobalDirection_0.X
            local v334 = GlobalDirection_0.Z
            local Unit_6 = Vector3.new(v333, 0, v334)
            local v336 = v210.LookVector.X
            local v337 = v210.LookVector.Z
            local v338 = Vector3.new(v336, 0, v337)
            local v339 = v210.RightVector.X
            local v340 = v210.RightVector.Z
            local Unit_7 = Vector3.new(v339, 0, v340)
            if Unit_6.Magnitude > 0.1 then
                Unit_6 = Unit_6.Unit
            end
            local Unit_8 = v338.Magnitude <= 0 and Vector3.new(0, 0, -1) or v338.Unit
            if Unit_7.Magnitude > 0 then
                Unit_7 = Unit_7.Unit
            end
            local v343 = p191.LadderClimbPercentage or 0
            local v344 = v343 >= 0.98
            local v345 = v343 <= 0.15
            local v346 = Unit_6:Dot(Unit_8)
            local v347 = Unit_6:Dot(Unit_7)
            local v348 = GlobalDirection_0.Magnitude > 0.1
            local v349 = p191:GetLadderCFrame(LadderZone_1)
            if not v349 then
                p191:ForceExitLadder("Ladder part removed during climb")
                return
            end
            local Position_10 = v194.Position
            local Position_11 = v349.Position
            local v352 = Position_11.X - Position_10.X
            local v353 = Position_11.Z - Position_10.Z
            local v354 = Vector3.new(v352, 0, v353)
            if v354.Magnitude > 0.1 and Unit_8:Dot(v354.Unit) <= 0 then
                v346 = -v346
            end
            local v355 = tick() - (p191.LastLadderAttachTick or 0) >= 0.1
            if v344 and (v346 > 0.1 and v355) then
                print("[Ladder Debug] Auto-detach at top", "climb%:", string.format("%.2f", v343), "verticalInput:", string.format("%.2f", v346))
                local v356 = Unit_8 * 8
                local v357 = v356.X
                local v358 = v356.Z
                local v359 = Vector3.new(v357, 2, v358)
                local v360
                if v359 == v359 then
                    v360 = v359.Magnitude < 10000
                else
                    v360 = false
                end
                if v360 then
                    v194.AssemblyLinearVelocity = v359
                    p191.GlobalVelocity = v356
                end
                p191.ClimbEnded:Fire(LadderZone_1, false)
                return
            end
            if v345 and (v346 < -0.1 and v355) then
                print("[Ladder Debug] Auto-detach at bottom", "climb%:", string.format("%.2f", v343), "verticalInput:", string.format("%.2f", v346))
                p191.ClimbEnded:Fire(LadderZone_1, false)
                return
            end
            if v348 then
                if math.abs(v346) > 0.1 then
                    local v361 = 14 * v346
                    if math.abs(v347) > 0.1 then
                        v361 = v361 * 1.15
                    end
                    v330 = Vector3.new(0, v361, 0)
                end
                if math.abs(v347) > 0.1 then
                    local v362 = p191:GetLadderCFrame(LadderZone_1)
                    if not v362 then
                        p191:ForceExitLadder("Ladder part removed during strafe")
                        return
                    end
                    local RightVector = v362.RightVector
                    local v364 = v362:VectorToObjectSpace(Position_10 - Position_11).X
                    local v365 = LadderZone_1.Extents.X * 0.8
                    local v366 = v364 + v347 * 0.5
                    if math.abs(v366) < v365 then
                        v330 = v330 + RightVector * (5.6000000000000005 * v347)
                    end
                end
            end
        end
        local PrimaryPart = v194 and p191.Character.PrimaryPart
        if PrimaryPart then
            local v368
            if v330 == v330 then
                v368 = v330.Magnitude < 10000
            else
                v368 = false
            end
            if v368 then
                PrimaryPart.AssemblyLinearVelocity = v330
            end
        end
    end
    local v369 = m_MenuState.GetMenuFrame()
    local v370
    if v369 and v369.Visible and true or m_MenuState.GetCurrentScreen() ~= nil then
        v370 = false
    else
        v370 = not v_u_20.activeController:GetIsJumping() and v_u_20.touchJumpController
        if v370 then
            v370 = v_u_20.touchJumpController:GetIsJumping()
        end
    end
    if v370 and not (p191.IsJumping or p191.IsJumpRequested) then
        p191.IsJumpRequested = true
    elseif not v370 then
        p191.IsJumpRequested = false
    end
    p191:Jump()
    p191.LastCameraCFrame = v210
    p191.Humanoid:MoveTo(p191.HumanoidRootPart.Position + p191.GlobalVelocity)
    p191.LastMoveUpdate = v195
end
function v_u_1.StopMovementAnimations(p371) -- name: StopMovementAnimations
    -- upvalues: (ref) v_u_33, (copy) v_u_32, (copy) v_u_34
    local v372
    if v_u_33 then
        v372 = v_u_33
    else
        v372 = v_u_32()
        if v372 then
            v_u_33 = v372
        else
            v372 = v_u_34
        end
    end
    for v373, v374 in pairs(p371.CharacterAnimator.Animations) do
        if v373 ~= "Jump" and (v372[v373] and v374.IsPlaying) then
            p371.CharacterAnimator:stop(v373, 0.2)
        end
    end
end
function v_u_1.ToggleWalkState(p375, p376) -- name: ToggleWalkState
    -- upvalues: (copy) m_Remotes
    if p376 ~= p375.IsWalking then
        p375.IsWalking = p376
        m_Remotes.Character.UpdateWalkState.Send(p375.IsWalking)
        p375.Walking:Fire(p375.IsWalking)
    end
end
function v_u_1.ToggleCrouchInput(p377, p378) -- name: ToggleCrouchInput
    p377.CrouchInputDown = p378
end
function v_u_1.PlantBomb(p379) -- name: PlantBomb
    -- upvalues: (copy) TweenService
    if not p379.IsPlantingBomb then
        p379.IsPlantingBomb = true
        if p379.BombPlantTween then
            p379.BombPlantTween:Cancel()
            p379.BombPlantTween = nil
        end
        p379.BombPlantTween = p379.Janitor:Add(TweenService:Create(p379.Humanoid, TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            ["CameraOffset"] = Vector3.new(0, -0.9, 0) + p379.DefaultCameraOffset
        }))
        p379.BombPlantTween:Play()
    end
end
function v_u_1.CancelBombPlant(p380) -- name: CancelBombPlant
    -- upvalues: (copy) TweenService
    if p380.IsPlantingBomb then
        p380.IsPlantingBomb = false
        if p380.BombPlantTween then
            p380.BombPlantTween:Cancel()
            p380.BombPlantTween = nil
        end
        p380.Janitor:Add(TweenService:Create(p380.Humanoid, TweenInfo.new(0.35, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            ["CameraOffset"] = p380.DefaultCameraOffset
        })):Play()
    end
end
function v_u_1.ToggleCrouchState(p381, p382) -- name: ToggleCrouchState
    -- upvalues: (copy) m_InventoryController, (copy) m_Remotes, (copy) TweenService
    local v383 = m_InventoryController.getCurrentEquipped()
    if v383 and (v383.Properties.Class == "C4" and v383.IsPlanting) then
        return
    elseif p382 ~= p381.IsCrouching then
        local v384 = tick()
        p381.IsCrouching = p382
        m_Remotes.Character.UpdateCrouchState.Send(p381.IsCrouching)
        if p381.CrouchTween then
            p381.CrouchTween:Cancel()
            p381.CrouchTween = nil
        end
        if p381.IsCrouching then
            p381.CrouchCount = p381.CrouchCount + 1
            if v384 - p381.LastCrouchTick > 0.5 then
                p381.CrouchCount = 0
            end
            local v385 = p381.CrouchCount * 0.05 + 0.15
            local v386 = math.min(v385, 0.4)
            p381.LastCrouchTick = v384
            p381.CrouchTween = p381.Janitor:Add(TweenService:Create(p381.Humanoid, TweenInfo.new(v386, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                ["CameraOffset"] = p381.CrouchCameraOffset + p381.DefaultCameraOffset
            }))
            p381.CrouchTween:Play()
        else
            local v387 = p381.CrouchCount * 0.05 + 0.15
            local v388 = math.min(v387, 0.4)
            p381.CrouchTween = p381.Janitor:Add(TweenService:Create(p381.Humanoid, TweenInfo.new(v388, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                ["CameraOffset"] = p381.DefaultCameraOffset
            }))
            p381.CrouchTween:Play()
        end
        p381.LastCrouchTick = v384
        p381.Crouching:Fire(p381.IsCrouching)
    end
end
function v_u_1.UpdateCharacterAnimations(p389, _) -- name: UpdateCharacterAnimations
    -- upvalues: (copy) m_GetMovementAnimation
    if p389.IsJumping then
        p389.CurrentMovementAnimation = nil
        p389:StopMovementAnimations()
    else
        local v390 = p389.CharacterAnimator:getAnimation("CrouchIdle")
        local v391 = m_GetMovementAnimation(p389.Character)
        local v392
        if p389.IsCrouching then
            if p389.GlobalDirection.Magnitude <= 0.1 then
                if not v390.IsPlaying then
                    p389.CurrentMovementAnimation = nil
                    p389:StopMovementAnimations()
                    local CharacterAnimator = p389.CharacterAnimator
                    local v394 = p389.CrouchCount * 0.05 + 0.15
                    CharacterAnimator:play("CrouchIdle", (math.min(v394, 0.4)))
                end
                return
            end
            v392 = ("Crouch%*"):format(v391)
            if v390.IsPlaying then
                local CharacterAnimator_0 = p389.CharacterAnimator
                local v396 = p389.CrouchCount * 0.05 + 0.15
                CharacterAnimator_0:stop("CrouchIdle", (math.min(v396, 0.4)))
            end
        else
            if v390.IsPlaying then
                local CharacterAnimator_1 = p389.CharacterAnimator
                local v398 = p389.CrouchCount * 0.05 + 0.15
                CharacterAnimator_1:stop("CrouchIdle", (math.min(v398, 0.4)))
            end
            v392 = v391 or "CharacterIdle"
        end
        local v399 = p389.CharacterAnimator:getAnimation(v392)
        if v399 and v392 ~= "CharacterIdle" then
            v399:AdjustSpeed((p389.HumanoidRootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude / (p389.IsCrouching and 12 or 16))
        end
        if p389.CurrentMovementAnimation ~= v392 then
            p389.CurrentMovementAnimation = v392
            p389:StopMovementAnimations()
            if v399 then
                v399:Play(0.15)
                return
            end
        end
    end
end
function v_u_1.new(p_u_400, p401, p_u_402) -- name: new
    -- upvalues: (copy) v_u_1, (copy) m_Janitor, (copy) LocalPlayer, (copy) m_CharacterAnimator, (copy) v_u_51, (copy) CurrentCamera, (copy) m_Signal, (copy) v_u_20, (copy) m_Remotes, (copy) m_RunServiceController, (copy) CollectionService
    local v403 = v_u_1
    local v_u_404 = setmetatable({}, v403)
    v_u_404.Janitor = m_Janitor.new()
    v_u_404.DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15, 0)
    v_u_404.CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.4, 0)
    v_u_404.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("DefaultCameraOffset"):Connect(function()
        -- upvalues: (copy) v_u_404, (ref) LocalPlayer
        v_u_404.DefaultCameraOffset = LocalPlayer:GetAttribute("DefaultCameraOffset") or Vector3.new(0, -0.15, 0)
    end))
    v_u_404.Janitor:Add(LocalPlayer:GetAttributeChangedSignal("CrouchCameraOffset"):Connect(function()
        -- upvalues: (copy) v_u_404, (ref) LocalPlayer
        v_u_404.CrouchCameraOffset = LocalPlayer:GetAttribute("CrouchCameraOffset") or Vector3.new(0, -1.4, 0)
    end))
    v_u_404.CharacterAnimator = m_CharacterAnimator.new(p_u_400)
    v_u_404.HumanoidRootPart = p401
    v_u_404.Character = p_u_400
    v_u_404.Humanoid = p_u_402
    v_u_404.Player = LocalPlayer
    v_u_404.Janitor:Add(p401.AncestryChanged:Connect(function(_, p405)
        -- upvalues: (copy) v_u_404
        if not p405 then
            if v_u_404.IsClimbing then
                v_u_404:ForceExitLadder("HumanoidRootPart removed")
            end
            v_u_404.HumanoidRootPart = nil
        end
    end))
    v_u_404.Humanoid.WalkSpeed = 20
    v_u_404.Humanoid.AutoRotate = false
    v_u_404.Humanoid.MaxSlopeAngle = 90
    if LocalPlayer:GetAttribute("SV_ACCELERATE") == nil then
        LocalPlayer:SetAttribute("SV_ACCELERATE", 6)
    end
    if LocalPlayer:GetAttribute("SV_STOPSPEED") == nil then
        LocalPlayer:SetAttribute("SV_STOPSPEED", 5)
    end
    if LocalPlayer:GetAttribute("SV_FRICTION") == nil then
        LocalPlayer:SetAttribute("SV_FRICTION", 6)
    end
    local function v_u_407(p406) -- name: setupPartCollision
        if p406.Name == "CollisionCapsule" then
            p406.CanCollide = false
            return
        elseif p406.Name == "HumanoidRootPart" and p406:IsA("Part") then
            p406.CanCollide = true
            p406.Size = Vector3.new(2, 2, 2)
            p406.Shape = Enum.PartType.Ball
            p406.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0, 1, 1)
            return
        elseif p406.Name == "Head" then
            p406.CanCollide = true
            return
        elseif p406.Name == "UpperTorso" or p406.Name == "LowerTorso" then
            p406.CanCollide = false
        else
            p406.CanCollide = false
        end
    end
    for _, v408 in ipairs(p_u_400:GetDescendants()) do
        if v408:IsA("BasePart") then
            v_u_407(v408)
        end
    end
    v_u_404.Janitor:Add(p_u_400.DescendantAdded:Connect(function(p409)
        -- upvalues: (copy) v_u_407
        if p409:IsA("BasePart") then
            v_u_407(p409)
        end
    end))
    v_u_404.Humanoid.UseJumpPower = true
    v_u_404.Humanoid.JumpPower = 19.5
    v_u_51(v_u_404.Humanoid)
    v_u_404.GlobalVelocity = Vector3.new(0, 0, 0)
    v_u_404.LocalVelocity = Vector3.new(0, 0, 0)
    v_u_404.LocalVelocityOnJump = Vector3.new(0, 0, 0)
    v_u_404.GlobalDirection = Vector3.new(0, 0, 0)
    v_u_404.LastCameraCFrame = CFrame.new()
    v_u_404.LastMoveUpdate = 0
    v_u_404.JumpCooldownActive = false
    v_u_404.ReadyToJump = false
    v_u_404.LastJumpTick = 0
    v_u_404.JumpCount = 0
    v_u_404.LastWallHitTick = 0
    v_u_404.WallJumpCooldown = false
    v_u_404.LockedAirDirection = nil
    v_u_404.LastAirDirectionChangeTick = 0
    v_u_404.LastLandTick = 0
    v_u_404.LastFreefallTick = nil
    v_u_404.LastAirTime = 0
    v_u_404.PeakFallVelocity = 0
    v_u_404.LandingVelocityY = nil
    v_u_404.LastCrouchTick = 0
    v_u_404.CrouchCount = 0
    v_u_404.CrouchHeadBlocked = false
    v_u_404.CrouchInputDown = false
    v_u_404.CurrentMovementAnimation = nil
    v_u_404.LadderZones = {}
    v_u_404.LadderPart = nil
    v_u_404.LadderZone = nil
    v_u_404.LadderClimbPercentage = 0
    v_u_404.LastLadderJumpTick = 0
    v_u_404.LastLadderAttachTick = 0
    local _, v410, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ()
    v_u_404.CurrentYRotation = v410
    v_u_404.TargetYRotation = v410
    local RootAttachment = p401:FindFirstChild("RootAttachment")
    if not RootAttachment then
        warn("[Character] RootAttachment not found - creating one")
        RootAttachment = Instance.new("Attachment")
        RootAttachment.Name = "RootAttachment"
        RootAttachment.Parent = p401
    end
    local AssemblyMass = p401.AssemblyMass
    if AssemblyMass ~= AssemblyMass or AssemblyMass <= 0 then
        warn("[Character] Invalid initial AssemblyMass:", AssemblyMass, "- using fallback")
        AssemblyMass = 10
    end
    v_u_404.VectorForce = v_u_404.Janitor:Add(Instance.new("VectorForce"))
    local VectorForce = v_u_404.VectorForce
    local Gravity = AssemblyMass * workspace.Gravity
    VectorForce.Force = Vector3.new(0, Gravity, 0)
    v_u_404.VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
    v_u_404.VectorForce.Enabled = false
    v_u_404.VectorForce.ApplyAtCenterOfMass = false
    v_u_404.VectorForce.Attachment0 = RootAttachment
    v_u_404.VectorForce.Parent = p401
    v_u_404.AlignOrientation = v_u_404.Janitor:Add(Instance.new("AlignOrientation"))
    v_u_404.AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    v_u_404.AlignOrientation.Attachment0 = p401:FindFirstChild("RootAttachment")
    v_u_404.AlignOrientation.RigidityEnabled = true
    v_u_404.AlignOrientation.MaxTorque = (1 / 0)
    v_u_404.AlignOrientation.Responsiveness = 200
    v_u_404.AlignOrientation.CFrame = CFrame.Angles(0, v_u_404.CurrentYRotation, 0)
    v_u_404.AlignOrientation.Parent = p401
    v_u_404.JumpedOffLadder = false
    v_u_404.IsPlantingBomb = false
    v_u_404.IsCrouching = false
    v_u_404.IsClimbing = false
    v_u_404.IsJumping = false
    v_u_404.IsWalking = false
    v_u_404.IsLanded = false
    v_u_404.IsBhopAttempt = false
    v_u_404.AgainstWall = false
    v_u_404.WallNormal = nil
    v_u_404.LastWallHitTime = 0
    v_u_404.LastWallNormal = nil
    v_u_404.Stamina = 100
    v_u_404.CurrentMoveDirection = Vector3.new(0, 0, 0)
    v_u_404.TargetMoveDirection = Vector3.new(0, 0, 0)
    v_u_404.MaxSpeed = 20
    v_u_404.ShotSlowUntil = 0
    v_u_404.ShotSlowMultiplier = 1
    v_u_404.LastLookAngle = 0
    v_u_404.LastVerticalLook = 0
    v_u_404.LastLookAngleUpdate = 0
    v_u_404.MoveDirectionChanged = v_u_404.Janitor:Add(m_Signal.new())
    v_u_404.Crouching = v_u_404.Janitor:Add(m_Signal.new())
    v_u_404.ClimbBegan = v_u_404.Janitor:Add(m_Signal.new())
    v_u_404.ClimbEnded = v_u_404.Janitor:Add(m_Signal.new())
    v_u_404.Climbing = v_u_404.Janitor:Add(m_Signal.new())
    v_u_404.Jumping = v_u_404.Janitor:Add(m_Signal.new())
    v_u_404.Walking = v_u_404.Janitor:Add(m_Signal.new())
    v_u_404.Landed = v_u_404.Janitor:Add(m_Signal.new())
    v_u_404.Janitor:Add(function()
        -- upvalues: (copy) v_u_404
        if v_u_404.CharacterAnimator then
            v_u_404.CharacterAnimator:destroy()
        end
    end)
    v_u_404.Janitor:Add(v_u_404.Humanoid.StateChanged:Connect(function(p415, p416)
        -- upvalues: (copy) v_u_404, (ref) v_u_51
        if (p416 == Enum.HumanoidStateType.Ragdoll or p416 == Enum.HumanoidStateType.FallingDown) and v_u_404.Humanoid.Health > 0 then
            v_u_51(v_u_404.Humanoid)
        else
            local Freefall = p416 == Enum.HumanoidStateType.Jumping and true or p416 == Enum.HumanoidStateType.Freefall
            local v418
            if p415 == Enum.HumanoidStateType.Freefall then
                v418 = not Freefall
            else
                v418 = false
            end
            if p416 == Enum.HumanoidStateType.Freefall then
                v_u_404.LastFreefallTick = tick()
                v_u_404.PeakFallVelocity = 0
            end
            if v418 then
                v_u_404.LastAirTime = tick() - (v_u_404.LastFreefallTick or 0)
                local v419 = v_u_404.HumanoidRootPart and v_u_404.HumanoidRootPart.AssemblyLinearVelocity.Y or 0
                local v420 = v_u_404
                local v421 = v_u_404.PeakFallVelocity or 0
                v420.LandingVelocityY = math.min(v419, v421)
                v_u_404.IsJumping = false
                v_u_404.IsLanded = true
                v_u_404.LandAtPosition = v_u_404.HumanoidRootPart.CFrame.Position
                v_u_404.LastLandTick = tick()
                v_u_404.ReadyToJump = true
                v_u_404.LockedAirDirection = nil
                v_u_404.CharacterAnimator:stop("Jump", 0.2)
                v_u_404.Landed:Fire()
            end
        end
    end))
    v_u_404.OriginalMoveFunction = v_u_20.moveFunction
    v_u_404.IsDestroyed = false
    task.delay(0.15, function()
        -- upvalues: (copy) v_u_404, (ref) LocalPlayer, (copy) p_u_400, (copy) p_u_402, (ref) v_u_51
        if not v_u_404.IsDestroyed then
            if LocalPlayer.Character == p_u_400 and (p_u_402.Parent and p_u_402.Health > 0) then
                v_u_51(p_u_402)
            end
        end
    end)
    local v_u_422 = setmetatable({
        ["instance"] = v_u_404
    }, {
        ["__mode"] = "v"
    })
    v_u_404._characterRef = v_u_422
    function v_u_20.moveFunction(_, ...)
        -- upvalues: (copy) v_u_422, (ref) v_u_20
        local instance = v_u_422.instance
        if instance and not instance.IsDestroyed then
            instance:MoveFunction(...)
        elseif instance and instance.OriginalMoveFunction then
            v_u_20.moveFunction = instance.OriginalMoveFunction
        end
    end
    v_u_404.Janitor:Add(function()
        -- upvalues: (copy) v_u_422, (copy) v_u_404, (ref) v_u_20
        if v_u_422 then
            v_u_422.instance = nil
        end
        if not v_u_404.IsDestroyed then
            v_u_404.IsDestroyed = true
            if v_u_404.OriginalMoveFunction then
                v_u_20.moveFunction = v_u_404.OriginalMoveFunction
                v_u_404.OriginalMoveFunction = nil
            end
        end
    end, true, "MoveFunctionCleanup")
    v_u_404.Janitor:Add(v_u_404.Landed:Connect(function()
        -- upvalues: (copy) v_u_404, (ref) m_Remotes
        local v424 = v_u_404.LandingVelocityY or v_u_404.HumanoidRootPart.AssemblyLinearVelocity.Y
        v_u_404.CanceledInertia = false
        v_u_404.IsCrouchJumping = false
        v_u_404.JumpedOffLadder = false
        if v_u_404.HumanoidRootPart then
            local AssemblyLinearVelocity_3 = v_u_404.HumanoidRootPart.AssemblyLinearVelocity
            local v426 = AssemblyLinearVelocity_3.X
            local v427 = AssemblyLinearVelocity_3.Z
            local v428 = Vector3.new(v426, 0, v427)
            local Magnitude_7 = v428.Magnitude
            if Magnitude_7 > 19 then
                local v430 = 1 - (0.1 + (Magnitude_7 - 19) * 0.03)
                local v431 = v428 * math.max(0.4, v430)
                v_u_404.GlobalVelocity = v431
                local HumanoidRootPart_3 = v_u_404.HumanoidRootPart
                local v433 = v431.X
                local v434 = AssemblyLinearVelocity_3.Y
                local v435 = v431.Z
                HumanoidRootPart_3.AssemblyLinearVelocity = Vector3.new(v433, v434, v435)
            end
        end
        if v424 <= -42 then
            local LastJumpTick_1 = v_u_404.LastFreefallTick or v_u_404.LastJumpTick
            if v_u_404.LastLandTick - LastJumpTick_1 >= 0.3 then
                local Send = m_Remotes.Character.FallDamage.Send
                local v438 = (v424 - -42) / -35 * 100
                Send((math.abs(v438)))
                v_u_404:TakeStamina(100)
            end
        end
        v_u_404.LandingVelocityY = nil
        v_u_404.LastFreefallTick = nil
    end), "Disconnect")
    v_u_404.Janitor:Add(v_u_404.Jumping:Connect(function()
        -- upvalues: (copy) v_u_404, (ref) CurrentCamera
        v_u_404.LocalVelocityOnJump = CurrentCamera.CFrame:VectorToObjectSpace(v_u_404.GlobalVelocity)
        v_u_404.GlobalDirectionOnJump = v_u_404.GlobalDirection
        v_u_404.ReadyToJump = false
    end), "Disconnect")
    v_u_404.Janitor:Add(v_u_404.ClimbBegan:Connect(function(p439)
        -- upvalues: (copy) v_u_404
        if p439 and (p439.Part and p439.Part.Parent) then
            local v440 = v_u_404:GetLadderCFrame(p439)
            if v440 then
                local Position_12 = v440.Position
                if Position_12 == Position_12 then
                    local v442 = Position_12.X
                    if math.abs(v442) <= 50000 then
                        local v443 = Position_12.Y
                        if math.abs(v443) <= 50000 then
                            local v444 = Position_12.Z
                            if math.abs(v444) <= 50000 then
                                local v445 = v_u_404:ValidateHumanoidRootPart()
                                if v445 then
                                    local Position_13 = v445.Position
                                    if Position_13 == Position_13 then
                                        local v447 = Position_13.X
                                        if math.abs(v447) <= 50000 then
                                            local v448 = Position_13.Y
                                            if math.abs(v448) <= 50000 then
                                                local v449 = Position_13.Z
                                                if math.abs(v449) <= 50000 then
                                                    v_u_404.GlobalVelocity = Vector3.new(0, 0, 0)
                                                    local AssemblyLinearVelocity_4 = v445.AssemblyLinearVelocity
                                                    if AssemblyLinearVelocity_4 == AssemblyLinearVelocity_4 then
                                                        v445.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                                        v445.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                                    else
                                                        warn("[Ladder Debug] HRP velocity was already NaN before climbing! Attempting recovery...")
                                                        v445.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                                        v445.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                                    end
                                                    if v_u_404.VectorForce.Attachment0 and v_u_404.VectorForce.Attachment0.Parent then
                                                        local AssemblyMass_0 = v445.AssemblyMass
                                                        if AssemblyMass_0 ~= AssemblyMass_0 or (AssemblyMass_0 <= 0 or AssemblyMass_0 > 10000) then
                                                            warn("[Ladder Debug] Invalid AssemblyMass:", AssemblyMass_0, "- using fallback")
                                                            AssemblyMass_0 = 10
                                                        end
                                                        local Gravity_0 = AssemblyMass_0 * workspace.Gravity
                                                        local v453 = Vector3.new(0, Gravity_0, 0)
                                                        if v453 == v453 and v453.Magnitude <= 100000 then
                                                            v_u_404.VectorForce.Force = v453
                                                            task.defer(function()
                                                                -- upvalues: (ref) v_u_404
                                                                if v_u_404.IsDestroyed or not v_u_404.IsClimbing then
                                                                    return
                                                                else
                                                                    local v454 = v_u_404:ValidateHumanoidRootPart()
                                                                    if v454 then
                                                                        local Position_14 = v454.Position
                                                                        if Position_14 == Position_14 then
                                                                            v_u_404.VectorForce.Enabled = true
                                                                        else
                                                                            warn("[Ladder Debug] Position became NaN during defer - aborting")
                                                                            v_u_404:ForceExitLadder("Position NaN during defer")
                                                                        end
                                                                    else
                                                                        v_u_404:ForceExitLadder("HRP invalid after defer")
                                                                        return
                                                                    end
                                                                end
                                                            end)
                                                            v_u_404.LadderZone = p439
                                                            v_u_404.IsClimbing = true
                                                            v_u_404.LastLadderAttachTick = tick()
                                                            v_u_404.LadderClimbPercentage = v_u_404:GetLadderClimbPercentage(p439)
                                                            v_u_404.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
                                                            local v456 = v_u_404:GetLadderClimbPercentage(p439)
                                                            local Part = p439.Part
                                                            print("[Ladder Debug] ClimbBegan", "part:", Part and Part.Name or "nil", "pos:", v440 and v440.Position or "nil", "climb%:", string.format("%.2f", v456), "mass:", AssemblyMass_0, "force:", v453)
                                                            v_u_404.IsJumping = false
                                                            v_u_404.IsJumpRequested = false
                                                            v_u_404.JumpedOffLadder = false
                                                            v_u_404.LastFreefallTick = nil
                                                            v_u_404.PeakFallVelocity = 0
                                                            v_u_404.LandingVelocityY = nil
                                                            v_u_404.Climbing:Fire()
                                                        else
                                                            warn("[Ladder Debug] Invalid counter-gravity force:", v453, "- aborting climb")
                                                        end
                                                    else
                                                        warn("[Ladder Debug] VectorForce has no valid Attachment0 - aborting climb")
                                                        return
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    warn("[Ladder Debug] ClimbBegan rejected - invalid player position:", Position_13)
                                else
                                    warn("[Ladder Debug] ClimbBegan rejected - no valid HumanoidRootPart")
                                end
                            end
                        end
                    end
                end
                warn("[Ladder Debug] ClimbBegan rejected - invalid ladder position:", Position_12)
            else
                warn("[Ladder Debug] ClimbBegan rejected - could not get ladder CFrame")
            end
        else
            warn("[Ladder Debug] ClimbBegan rejected - invalid ladder zone")
            return
        end
    end), "Disconnect")
    v_u_404.Janitor:Add(v_u_404.ClimbEnded:Connect(function(p458, p459)
        -- upvalues: (copy) v_u_404
        local v460 = v_u_404.LadderClimbPercentage or 0
        local v461
        if v_u_404.HumanoidRootPart then
            v461 = v_u_404.HumanoidRootPart.AssemblyLinearVelocity
        else
            v461 = nil
        end
        print("[Ladder Debug] ClimbEnded", p459 and "jumpedOff" or "walkedOff", "climb%:", string.format("%.2f", v460), "velocity:", v461, "ladder:", p458 and (p458.Part and p458.Part.Name) or "nil")
        v_u_404.VectorForce.Enabled = false
        v_u_404.IsClimbing = false
        v_u_404.LadderZone = nil
        v_u_404.LadderClimbPercentage = 0
        v_u_404.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
        v_u_404.LastLadderJumpTick = tick()
        if p459 then
            v_u_404.JumpedOffLadder = true
        end
        v_u_404.Climbing:Fire()
    end), "Disconnect")
    local v462 = m_RunServiceController.CreateBindingName("Classes.Character.Update")
    v_u_404.Janitor:Add(m_RunServiceController.BindToStepped(v462, function(_, p463)
        -- upvalues: (copy) v_u_404, (ref) CurrentCamera, (ref) m_Remotes
        if v_u_404.IsDestroyed then
            return
        end
        if v_u_404.HumanoidRootPart and v_u_404.HumanoidRootPart.Parent then
            local Position_15 = v_u_404.HumanoidRootPart.Position
            if Position_15 == Position_15 then
                local v465 = Position_15.X
                if math.abs(v465) <= 50000 then
                    local v466 = Position_15.Y
                    if math.abs(v466) <= 50000 then
                        local v467 = Position_15.Z
                        if math.abs(v467) > 50000 then
                            goto l7
                        end
                        goto l4
                    end
                end
            end
            ::l7::
            warn("[Character] Detected invalid HumanoidRootPart position:", Position_15, "- forcing ladder exit and resetting velocity")
            if v_u_404.IsClimbing then
                v_u_404:ForceExitLadder("Invalid position detected")
            end
            if (Vector3.new(0, 0, 0)).Magnitude < 10000 then
                v_u_404.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                v_u_404.GlobalVelocity = Vector3.new(0, 0, 0)
            end
        else
            ::l4::
            v_u_404:UpdateCharacterAnimations(p463)
            if v_u_404.CrouchInputDown then
                v_u_404:ToggleCrouchState(true)
            elseif not v_u_404.CrouchHeadBlocked then
                v_u_404:ToggleCrouchState(false)
            end
            if not v_u_404.IsClimbing and v_u_404.Humanoid:GetState() == Enum.HumanoidStateType.Climbing then
                v_u_404.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
                v_u_404.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            v_u_404:ResolveGroundedFreefall(v_u_404.HumanoidRootPart)
            if v_u_404.IsClimbing and v_u_404.LadderZone then
                v_u_404.LadderClimbPercentage = v_u_404:GetLadderClimbPercentage(v_u_404.LadderZone)
            end
            if v_u_404.Stamina < 100 then
                local v468 = v_u_404
                local v469 = v_u_404.Stamina + p463 * 100
                v468.Stamina = math.min(v469, 100)
            end
            local _, v470, _ = CurrentCamera.CFrame:ToEulerAnglesYXZ()
            v_u_404.TargetYRotation = v470
            local v471 = v_u_404.GlobalVelocity.X
            local v472 = v_u_404.GlobalVelocity.Z
            if (Vector3.new(v471, 0, v472).Magnitude > 0.1 or v_u_404.Humanoid.MoveDirection.Magnitude > 0.1) and true or v_u_404.IsClimbing then
                local CurrentYRotation = v_u_404.TargetYRotation - v_u_404.CurrentYRotation
                if CurrentYRotation == CurrentYRotation and math.abs(CurrentYRotation) ~= (1 / 0) then
                    local v474 = 0
                    while CurrentYRotation > 3.141592653589793 and v474 < 10 do
                        CurrentYRotation = CurrentYRotation - 6.283185307179586
                        v474 = v474 + 1
                    end
                    local v475 = 0
                    while CurrentYRotation < -3.141592653589793 and v475 < 10 do
                        CurrentYRotation = CurrentYRotation + 6.283185307179586
                        v475 = v475 + 1
                    end
                else
                    warn("[Character] Detected invalid rotation values - resetting. TargetY:", v_u_404.TargetYRotation, "CurrentY:", v_u_404.CurrentYRotation)
                    v_u_404.CurrentYRotation = v470
                    v_u_404.TargetYRotation = v470
                    CurrentYRotation = 0
                end
                local v476 = p463 * 20
                local v477 = math.min(1, v476)
                v_u_404.CurrentYRotation = v_u_404.CurrentYRotation + CurrentYRotation * v477
                v_u_404.AlignOrientation.RigidityEnabled = true
                v_u_404.AlignOrientation.MaxTorque = (1 / 0)
                v_u_404.AlignOrientation.Enabled = true
            else
                if v470 ~= v470 or math.abs(v470) == (1 / 0) then
                    warn("[Character] Detected invalid camera rotation - skipping stationary rotation update")
                    return
                end
                v_u_404.CurrentYRotation = v_u_404.TargetYRotation
                v_u_404.AlignOrientation.Enabled = false
                if v_u_404.HumanoidRootPart and v_u_404.HumanoidRootPart.Parent then
                    local Position_16 = v_u_404.HumanoidRootPart.Position
                    if Position_16 == Position_16 then
                        local v479 = Position_16.X
                        if math.abs(v479) < 50000 then
                            local v480 = Position_16.Y
                            if math.abs(v480) < 50000 then
                                local v481 = Position_16.Z
                                if math.abs(v481) < 50000 then
                                    v_u_404.HumanoidRootPart.CFrame = CFrame.new(Position_16) * CFrame.Angles(0, v_u_404.CurrentYRotation, 0)
                                end
                            end
                        end
                    end
                end
            end
            if v_u_404.CurrentYRotation == v_u_404.CurrentYRotation then
                local CurrentYRotation_0 = v_u_404.CurrentYRotation
                if math.abs(CurrentYRotation_0) < 100 then
                    v_u_404.AlignOrientation.CFrame = CFrame.Angles(0, v_u_404.CurrentYRotation, 0)
                end
            end
            local v483 = tick()
            if v483 - v_u_404.LastLookAngleUpdate >= 0.05 then
                local v484 = CurrentCamera.CFrame.LookVector.Y
                local LastLookAngle = v470 - v_u_404.LastLookAngle
                local v486 = math.abs(LastLookAngle)
                local LastVerticalLook = v484 - v_u_404.LastVerticalLook
                local v488 = math.abs(LastVerticalLook)
                if v486 > 0.1 or v488 > 0.1 then
                    v_u_404.LastLookAngle = v470
                    v_u_404.LastVerticalLook = v484
                    v_u_404.LastLookAngleUpdate = v483
                    m_Remotes.Character.UpdateLookAngle.Send({
                        ["HorizontalAngle"] = v470,
                        ["VerticalLook"] = v484
                    })
                end
            end
        end
    end))
    local v489 = CollectionService:GetTagged("Ladder")
    for _, v490 in pairs(v489) do
        v_u_404:AddLadder(v490)
    end
    local v491 = 0
    for _ in pairs(v_u_404.LadderZones) do
        v491 = v491 + 1
    end
    v_u_404.Janitor:Add(CollectionService:GetInstanceAddedSignal("Ladder"):Connect(function(p492)
        -- upvalues: (copy) v_u_404
        if p492:IsA("BasePart") then
            v_u_404:AddLadder(p492)
        end
    end))
    v_u_404.Janitor:Add(CollectionService:GetInstanceRemovedSignal("Ladder"):Connect(function(p493)
        -- upvalues: (copy) v_u_404
        if p493:IsA("BasePart") then
            v_u_404:RemoveLadder(p493)
        end
    end))
    v_u_404._deadAttributeConnection = p_u_400:GetAttributeChangedSignal("Dead"):Connect(function()
        -- upvalues: (copy) p_u_400, (copy) v_u_404
        if p_u_400:GetAttribute("Dead") and not v_u_404.IsDestroyed then
            v_u_404:Destroy()
        end
    end)
    return v_u_404
end
function v_u_1.Destroy(p494) -- name: Destroy
    -- upvalues: (copy) v_u_20
    if not p494.IsDestroyed then
        p494.IsDestroyed = true
        if p494.CharacterAnimator then
            p494.CharacterAnimator:destroy()
            p494.CharacterAnimator = nil
        end
        if p494._characterRef then
            p494._characterRef.instance = nil
            p494._characterRef = nil
        end
        if p494.OriginalMoveFunction then
            v_u_20.moveFunction = p494.OriginalMoveFunction
            p494.OriginalMoveFunction = nil
        end
        if p494._deadAttributeConnection then
            p494._deadAttributeConnection:Disconnect()
            p494._deadAttributeConnection = nil
        end
        if p494.MoveDirectionChanged then
            p494.MoveDirectionChanged:Destroy()
            p494.MoveDirectionChanged = nil
        end
        if p494.Crouching then
            p494.Crouching:Destroy()
            p494.Crouching = nil
        end
        if p494.ClimbBegan then
            p494.ClimbBegan:Destroy()
            p494.ClimbBegan = nil
        end
        if p494.ClimbEnded then
            p494.ClimbEnded:Destroy()
            p494.ClimbEnded = nil
        end
        if p494.Climbing then
            p494.Climbing:Destroy()
            p494.Climbing = nil
        end
        if p494.Jumping then
            p494.Jumping:Destroy()
            p494.Jumping = nil
        end
        if p494.Walking then
            p494.Walking:Destroy()
            p494.Walking = nil
        end
        if p494.Landed then
            p494.Landed:Destroy()
            p494.Landed = nil
        end
        if p494.LadderZones then
            table.clear(p494.LadderZones)
            p494.LadderZones = nil
        end
        p494.Character = nil
        p494.HumanoidRootPart = nil
        p494.Humanoid = nil
        p494.LadderZone = nil
        p494.LadderPart = nil
        if p494.VectorForce then
            p494.VectorForce = nil
        end
        if p494.AlignOrientation then
            p494.AlignOrientation = nil
        end
        if p494.BombPlantTween then
            p494.BombPlantTween = nil
        end
        if p494.CrouchTween then
            p494.CrouchTween = nil
        end
        p494.DefaultCameraOffset = nil
        p494.CrouchCameraOffset = nil
        p494.GlobalVelocity = nil
        p494.LocalVelocity = nil
        p494.LocalVelocityOnJump = nil
        p494.GlobalDirection = nil
        p494.TargetMoveDirection = nil
        p494.CurrentMoveDirection = nil
        p494.WallNormal = nil
        p494.LastWallNormal = nil
        p494.LandingVelocityY = nil
        p494.LockedAirDirection = nil
        p494.Janitor:Destroy()
        p494.Janitor = nil
    end
end
return v_u_1
