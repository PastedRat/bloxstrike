-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local m_GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local v11 = m_GetUserPlatform()
local v_u_12
if table.find(v11, "Mobile") == nil then
    v_u_12 = false
else
    v_u_12 = #v11 <= 1
end
local GamepadEnabled = UserInputService.GamepadEnabled
local v14
if table.find(v11, "Console") == nil then
    v14 = false
else
    v14 = table.find(v11, "PC") == nil
end
local v15 = table.find(m_Constants.AIM_ASSIST_WHITELIST, LocalPlayer.UserId) ~= nil
local v_u_16
if v_u_12 then
    v_u_16 = v_u_12
elseif GamepadEnabled then
    v_u_16 = v14 or v15
else
    v_u_16 = v15
end
local CurrentCamera = Workspace.CurrentCamera
local v_u_18 = false
local PLAYER = v15 and m_Constants.AIM_ASSIST_CONFIGS.DEVELOPER or m_Constants.AIM_ASSIST_CONFIGS.PLAYER
local function v_u_51(p20, p21, p22) -- name: doesRaycastIntersectSmoke
    -- upvalues: (copy) Workspace
    local function v45(p23, p24, p25, p26, p27) -- name: rayIntersectsAABB
        local v28 = 0
        local v29 = p24.X
        local v30, v31
        if math.abs(v29) < 0.0001 then
            if p23.X < p25.X or p23.X > p26.X then
                return false
            end
            v30 = p27
            v31 = v28
        else
            local v32 = 1 / p24.X
            v30 = (p25.X - p23.X) * v32
            v31 = (p26.X - p23.X) * v32
            if v31 >= v30 then
                local v33 = v30
                v30 = v31
                v31 = v33
            end
            if v28 >= v31 then
                v31 = v28
            end
            if v30 >= p27 then
                v30 = p27
            end
            if v30 < v31 then
                return false
            end
        end
        local v34 = p24.Y
        if math.abs(v34) < 0.0001 then
            if p23.Y < p25.Y or p23.Y > p26.Y then
                return false
            end
        else
            local v35 = 1 / p24.Y
            local v36 = (p25.Y - p23.Y) * v35
            local v37 = (p26.Y - p23.Y) * v35
            if v37 >= v36 then
                local v38 = v36
                v36 = v37
                v37 = v38
            end
            if v31 >= v37 then
                v37 = v31
            end
            if v36 >= v30 then
                v36 = v30
            end
            if v36 < v37 then
                return false
            end
            v30 = v36
            v31 = v37
        end
        local v39 = p24.Z
        if math.abs(v39) < 0.0001 then
            if p23.Z < p25.Z or p23.Z > p26.Z then
                return false
            end
        else
            local v40 = 1 / p24.Z
            local v41 = (p25.Z - p23.Z) * v40
            local v42 = (p26.Z - p23.Z) * v40
            if v42 >= v41 then
                local v43 = v41
                v41 = v42
                v42 = v43
            end
            if v31 >= v42 then
                v42 = v31
            end
            if v41 >= v30 then
                v41 = v30
            end
            if v41 < v42 then
                return false
            end
            v31 = v42
        end
        local v44
        if v31 >= 0 then
            v44 = v31 <= p27
        else
            v44 = false
        end
        return v44
    end
    local Debris = Workspace:FindFirstChild("Debris")
    if not Debris then
        return false
    end
    for _, v47 in ipairs(Debris:GetChildren()) do
        if v47.Name:match("^VoxelSmoke_") and v47:IsA("Folder") then
            for _, v48 in ipairs(v47:GetChildren()) do
                if v48:IsA("BasePart") and v48.Name == "SmokeVoxel" then
                    local Size = v48.Size
                    local Position = v48.Position
                    if v45(p20, p21, Position - Size / 2, Position + Size / 2, p22) then
                        return true
                    end
                end
            end
        end
    end
    return false
end
local function v_u_57(p52, p53) -- name: isEnemyValid
    if p52 and p53 then
        local v54 = p52:GetAttribute("Team")
        local v55 = p53:GetAttribute("Team")
        if v54 and v55 then
            local v56 = {
                ["Counter-Terrorists"] = true,
                ["Terrorists"] = true
            }
            if v56[v54] and v56[v55] then
                return workspace:GetAttribute("Gamemode") == "Deathmatch" and true or v54 ~= v55
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end
local function v_u_65(p58, p59) -- name: isTargetVisible
    -- upvalues: (copy) v_u_51, (copy) LocalPlayer, (copy) Workspace
    if not (p58 and p58.PrimaryPart) then
        return false
    end
    local Position_0 = not (p58 and p58.PrimaryPart) and Vector3.new(0, 0, 0) or p58.PrimaryPart.Position
    local Unit = (Position_0 - p59).Unit
    local Magnitude = (Position_0 - p59).Magnitude
    if v_u_51(p59, Unit, Magnitude) then
        return false
    end
    local v63 = RaycastParams.new()
    v63.FilterType = Enum.RaycastFilterType.Exclude
    v63.FilterDescendantsInstances = { LocalPlayer.Character }
    local v64 = Workspace:Raycast(p59, Unit * Magnitude, v63)
    return not v64 and true or (p58:IsAncestorOf(v64.Instance) and true or false)
end
local function v_u_81(p66) -- name: findBestTarget
    -- upvalues: (copy) Players, (copy) LocalPlayer, (copy) v_u_57, (copy) PLAYER, (copy) v_u_65
    local v67 = 0
    local v68 = nil
    for _, v69 in ipairs(Players:GetPlayers()) do
        if v69 ~= LocalPlayer and v_u_57(LocalPlayer, v69) then
            local Character = v69.Character
            if Character and Character.PrimaryPart then
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                if Humanoid and (Humanoid.Health > 0 and Character:GetAttribute("Dead") ~= true) then
                    local Position_1 = not (Character and Character.PrimaryPart) and Vector3.new(0, 0, 0) or Character.PrimaryPart.Position
                    local Position_2 = p66.Position
                    local Magnitude_0 = (Position_1 - Position_2).Magnitude
                    if PLAYER.TargetSelection.MaxDistance >= Magnitude_0 then
                        local Position_3 = p66.Position
                        local v76 = p66.LookVector:Dot((Position_1 - Position_3).Unit)
                        local v77 = math.clamp(v76, -1, 1)
                        local v78 = math.acos(v77)
                        if PLAYER.TargetSelection.MaxAngle >= v78 and v_u_65(Character, Position_2) then
                            local MaxAngle = v78 / PLAYER.TargetSelection.MaxAngle
                            local v80 = 1 / (Magnitude_0 + 1) * (1 - MaxAngle)
                            if v67 < v80 then
                                v68 = Character
                                v67 = v80
                            end
                        end
                    end
                end
            end
        end
    end
    return v68
end
local function v_u_95(p82, p83) -- name: calculateFrictionMultiplier
    -- upvalues: (copy) PLAYER, (copy) CurrentCamera
    if PLAYER.Friction.Enabled and p83 then
        if CurrentCamera and p83.PrimaryPart then
            local Position_4 = not (p83 and p83.PrimaryPart) and Vector3.new(0, 0, 0) or p83.PrimaryPart.Position
            local Position_5 = p82.Position
            local v86, v87 = CurrentCamera:WorldToViewportPoint(Position_4)
            if v87 and v86.Z >= 0 then
                local v88 = CurrentCamera.ViewportSize / 2
                local v89 = Vector2.new(v88.X, v88.Y)
                local Magnitude_1 = (Vector2.new(v86.X, v86.Y) - v89).Magnitude
                local Magnitude_2 = (Position_4 - Position_5).Magnitude
                local v92 = 2 / Magnitude_2 * v88.Y * 2
                local v93 = PLAYER.Friction.BubbleRadius * (v88.Y / Magnitude_2) * 2
                if v93 + v92 / 2 < Magnitude_1 then
                    return PLAYER.Friction.MaxSensitivity
                else
                    local v94 = Magnitude_1 - v92 / 2
                    if math.max(0, v94) <= v93 then
                        return PLAYER.Friction.MinSensitivity
                    else
                        return PLAYER.Friction.MaxSensitivity
                    end
                end
            else
                return PLAYER.Friction.MaxSensitivity
            end
        else
            return PLAYER.Friction.MaxSensitivity
        end
    else
        return PLAYER.Friction.MaxSensitivity
    end
end
function v1.IsEnabled() -- name: IsEnabled
    -- upvalues: (ref) v_u_18
    return v_u_18
end
function v1.SetEnabled(p96) -- name: SetEnabled
    -- upvalues: (ref) v_u_18
    v_u_18 = p96
end
function v1.GetBestTarget() -- name: GetBestTarget
    -- upvalues: (copy) v_u_16, (ref) v_u_18, (copy) PLAYER, (copy) m_FlashEffect, (copy) CurrentCamera, (copy) LocalPlayer, (copy) v_u_81
    if v_u_16 then
        if v_u_18 and PLAYER.TargetSelection.Enabled then
            if m_FlashEffect.IsFlashed() then
                return nil
            elseif CurrentCamera and LocalPlayer.Character then
                return v_u_81(CurrentCamera.CFrame)
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end
function v1.GetFrictionMultiplier() -- name: GetFrictionMultiplier
    -- upvalues: (copy) v_u_16, (copy) PLAYER, (ref) v_u_18, (copy) m_FlashEffect, (copy) CurrentCamera, (copy) LocalPlayer, (copy) v_u_81, (copy) v_u_95
    if not v_u_16 then
        return PLAYER.Friction.MaxSensitivity
    end
    if not (v_u_18 and PLAYER.Friction.Enabled) then
        return PLAYER.Friction.MaxSensitivity
    end
    if m_FlashEffect.IsFlashed() then
        return PLAYER.Friction.MaxSensitivity
    end
    if not (CurrentCamera and LocalPlayer.Character) then
        return PLAYER.Friction.MaxSensitivity
    end
    local CFrame = CurrentCamera.CFrame
    return v_u_95(CFrame, (v_u_81(CFrame)))
end
local function v_u_114(p98) -- name: findTargetWithRaycast
    -- upvalues: (copy) PLAYER, (copy) LocalPlayer, (copy) Workspace, (copy) Players, (copy) v_u_57, (copy) v_u_51
    local Position_6 = p98.Position
    local MaxDistance = PLAYER.Magnetism.MaxDistance
    local v101 = RaycastParams.new()
    v101.FilterType = Enum.RaycastFilterType.Exclude
    v101.FilterDescendantsInstances = { LocalPlayer.Character }
    local v102 = PLAYER.Magnetism.MaxAngleHorizontal / 2
    local v103 = PLAYER.Magnetism.MaxAngleVertical / 2
    for v104 = -1, 1 do
        for v105 = -1, 1 do
            local v106 = v104 * v102
            local v107 = v105 * v103
            local LookVector = (p98 * CFrame.Angles(v107, v106, 0)).LookVector
            local v109 = Workspace:Raycast(Position_6, LookVector * MaxDistance, v101)
            if v109 then
                local Model = v109.Instance:FindFirstAncestorOfClass("Model")
                if Model and Model:FindFirstChildOfClass("Humanoid") then
                    local v111 = Players:GetPlayerFromCharacter(Model)
                    if v111 and v_u_57(LocalPlayer, v111) then
                        local Humanoid_0 = Model:FindFirstChildOfClass("Humanoid")
                        if Humanoid_0 and (Humanoid_0.Health > 0 and Model:GetAttribute("Dead") ~= true) then
                            local Magnitude_3 = (v109.Position - Position_6).Magnitude
                            if Magnitude_3 <= MaxDistance and not v_u_51(Position_6, LookVector, Magnitude_3) then
                                return Model
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end
local function v_u_140(p115, p116, p117) -- name: calculateMagnetismRotation
    -- upvalues: (copy) PLAYER
    if p116 and p116.PrimaryPart then
        local Position_7 = not (p116 and p116.PrimaryPart) and Vector3.new(0, 0, 0) or p116.PrimaryPart.Position
        local Position_8 = p115.Position
        local LookVector_0 = p115.LookVector
        if (Position_7 - Position_8).Magnitude > PLAYER.Magnetism.MaxDistance then
            return Vector2.zero
        else
            local Unit_0 = (Position_7 - Position_8).Unit
            local v122 = LookVector_0.X
            local v123 = LookVector_0.Z
            local Unit_1 = Vector3.new(v122, 0, v123).Unit
            local v125 = Unit_0.X
            local v126 = Unit_0.Z
            local v127 = Unit_1:Dot(Vector3.new(v125, 0, v126).Unit)
            local v128 = math.clamp(v127, -1, 1)
            local v129 = math.acos(v128)
            if PLAYER.Magnetism.MaxAngleHorizontal < v129 then
                return Vector2.zero
            elseif v129 <= PLAYER.Magnetism.StopThreshold then
                return Vector2.zero
            elseif v129 > 1.5707963267948966 then
                return Vector2.zero
            else
                local v130 = -LookVector_0.X
                local v131 = -LookVector_0.Z
                local v132 = math.atan2(v130, v131)
                local v133 = -Unit_0.X
                local v134 = -Unit_0.Z
                local v135 = math.atan2(v133, v134) - v132
                if v135 > 3.141592653589793 then
                    v135 = v135 - 6.283185307179586
                elseif v135 < -3.141592653589793 then
                    v135 = v135 + 6.283185307179586
                end
                local v136 = math.abs(v135)
                if v136 < 0.001 then
                    return Vector2.zero
                else
                    local v137 = PLAYER.Magnetism.PullStrength * p117
                    local v138 = math.min(v137, v136)
                    local v139 = v135 > 0 and 1 or -1
                    if v139 == v139 then
                        return Vector2.new(v139 * v138, 0)
                    else
                        return Vector2.zero
                    end
                end
            end
        end
    else
        return Vector2.zero
    end
end
local function v_u_161(p141, p142, p143, p144) -- name: calculateVerticalMagnetismRotation
    -- upvalues: (copy) PLAYER
    local Head = p142:FindFirstChild("Head")
    local v146
    if Head then
        v146 = Head.Position
    else
        v146 = nil
    end
    if not v146 then
        return 0
    end
    local VerticalMagnetism = PLAYER.VerticalMagnetism
    local Position_9 = p141.Position
    local LookVector_1 = p141.LookVector
    if (v146 - Position_9).Magnitude > VerticalMagnetism.MaxDistance then
        return 0
    end
    local Unit_2 = (v146 - Position_9).Unit
    local v151 = LookVector_1.Y
    local v152 = math.clamp(v151, -1, 1)
    local v153 = math.asin(v152)
    local v154 = Unit_2.Y
    local v155 = math.clamp(v154, -1, 1)
    local v156 = math.asin(v155) - v153
    local v157 = math.abs(v156)
    if not p144 and VerticalMagnetism.MaxAngleVertical < v157 then
        return 0
    end
    if v157 <= VerticalMagnetism.StopThreshold then
        return 0
    end
    if v157 < 0.001 then
        return 0
    end
    local v158 = VerticalMagnetism.PullStrength * p143
    local v159 = math.min(v158, v157)
    local v160 = v156 > 0 and 1 or -1
    return v160 ~= v160 and 0 or v160 * v159
end
function v1.GetMagnetismRotation(p162) -- name: GetMagnetismRotation
    -- upvalues: (copy) v_u_16, (ref) v_u_18, (copy) PLAYER, (copy) m_FlashEffect, (copy) CurrentCamera, (copy) LocalPlayer, (copy) v_u_81, (copy) v_u_114, (copy) v_u_140, (copy) v_u_161, (copy) GamepadEnabled
    if not v_u_16 then
        return Vector2.zero
    end
    if not (v_u_18 and PLAYER.Magnetism.Enabled) then
        return Vector2.zero
    end
    if m_FlashEffect.IsFlashed() then
        return Vector2.zero
    end
    if not (CurrentCamera and LocalPlayer.Character) then
        return Vector2.zero
    end
    local v163 = p162 or 0.016666666666666666
    local CFrame_0 = CurrentCamera.CFrame
    local v165 = v_u_81(CFrame_0) or v_u_114(CFrame_0)
    if not v165 then
        return Vector2.zero
    end
    local v166 = v_u_140(CFrame_0, v165, v163)
    local v167 = v166.X
    local v168 = math.abs(v167) > 0.0001
    local v169 = not PLAYER.VerticalMagnetism.Enabled and 0 or v_u_161(CFrame_0, v165, v163, v168)
    local v170 = Vector2.new(v166.X, v169)
    if GamepadEnabled then
        v170 = v170 * 0.5
    end
    return v170
end
function v1.GetRecoilAssistMultiplier() -- name: GetRecoilAssistMultiplier
    -- upvalues: (copy) v_u_16, (ref) v_u_18, (copy) PLAYER, (copy) m_FlashEffect, (copy) CurrentCamera, (copy) LocalPlayer, (copy) v_u_81
    if not v_u_16 then
        return 0
    end
    if not (v_u_18 and PLAYER.RecoilAssist.Enabled) then
        return 0
    end
    if m_FlashEffect.IsFlashed() then
        return 0
    end
    if PLAYER.RecoilAssist.RequiresTarget then
        if not (CurrentCamera and LocalPlayer.Character) then
            return 0
        end
        if not v_u_81(CurrentCamera.CFrame) then
            return 0
        end
    end
    return PLAYER.RecoilAssist.ReductionAmount
end
function v1.Initialize() -- name: Initialize
    -- upvalues: (ref) v_u_18, (copy) v_u_16, (copy) m_DataController, (copy) LocalPlayer, (copy) v_u_12, (copy) GamepadEnabled
    v_u_18 = v_u_16
    m_DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Mobile Aim Assist", function(p171)
        -- upvalues: (ref) v_u_12, (ref) v_u_18
        if v_u_12 then
            v_u_18 = p171 ~= false
        end
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Game.Other.Controller Aim Assist", function(p172)
        -- upvalues: (ref) GamepadEnabled, (ref) v_u_18
        if GamepadEnabled then
            v_u_18 = p172 ~= false
        end
    end)
end
return v1
