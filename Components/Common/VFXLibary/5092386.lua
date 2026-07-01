-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = Workspace.CurrentCamera
local Debris = Workspace:WaitForChild("Debris")
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Signal = require(ReplicatedStorage.Packages.Signal)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local v_u_13 = Color3.new(1, 1, 1)
local v_u_14 = RaycastParams.new()
v_u_14.CollisionGroup = "Barriers"
v_u_14.FilterType = Enum.RaycastFilterType.Exclude
v_u_14.IgnoreWater = true
local v_u_15 = nil
local v_u_16 = nil
local v_u_17 = nil
local v_u_18 = nil
local v_u_19 = nil
local v_u_20 = nil
local v_u_21 = nil
local v_u_22 = nil
local v_u_23 = nil
local v_u_24 = nil
local v_u_25 = 0
local v_u_26 = nil
local v_u_27 = m_Signal.new()
local v_u_28 = m_Signal.new()
local function v_u_30(_, ...) -- name: FlashDebug
    -- upvalues: (copy) LocalPlayer
    local v29 = LocalPlayer:GetAttribute("DebugFlashbang")
    if typeof(v29) == "boolean" and not v29 then
    end
end
local function v_u_33() -- name: CreateFlashGui
    -- upvalues: (copy) v_u_13, (copy) PlayerGui
    local v31 = Instance.new("ScreenGui")
    v31.Name = "FlashbangEffect"
    v31.DisplayOrder = 999
    v31.IgnoreGuiInset = true
    v31.ResetOnSpawn = false
    local v32 = Instance.new("Frame")
    v32.Name = "FlashOverlay"
    v32.Size = UDim2.new(1, 0, 1, 0)
    v32.Position = UDim2.new(0, 0, 0, 0)
    v32.BackgroundColor3 = v_u_13
    v32.BackgroundTransparency = 1
    v32.BorderSizePixel = 0
    v32.ZIndex = 999
    v32.Parent = v31
    v31.Parent = PlayerGui
    return v31, v32
end
local function v_u_44(p34) -- name: StartDriver
    -- upvalues: (ref) v_u_25, (ref) v_u_22, (ref) v_u_23, (ref) v_u_24, (ref) v_u_15, (ref) v_u_16, (ref) v_u_17, (copy) v_u_33, (copy) Lighting, (ref) v_u_18, (ref) v_u_19, (copy) v_u_27, (copy) TweenService, (copy) v_u_28
    task.wait(0.05)
    while v_u_25 == p34 do
        local v35 = v_u_22
        local v36 = v_u_23
        local v37 = v_u_24
        if not (v35 and (v36 and v37)) then
            break
        end
        local v38 = os.clock()
        if v35 <= v38 then
            break
        end
        local v39 = v_u_15
        local v40 = v_u_16
        local v41 = v_u_17
        if not (v39 and v40) then
            v39, v40 = v_u_33()
            v_u_15 = v39
            v_u_16 = v40
        end
        if not v41 then
            v41 = Instance.new("ColorCorrectionEffect")
            v41.Name = "FlashbangColorCorrection"
            v41.Brightness = 0
            v41.Contrast = 0
            v41.Saturation = 0
            v41.TintColor = Color3.new(1, 1, 1)
            v41.Parent = Lighting
            v_u_17 = v41
        end
        if v38 < v36 then
            if v_u_18 then
                v_u_18:Cancel()
                v_u_18 = nil
            end
            if v_u_19 then
                v_u_19:Cancel()
                v_u_19 = nil
            end
            v40.BackgroundTransparency = 1 - v37
            v41.Brightness = v37
            v41.Saturation = -v37
            task.wait()
        else
            local v42 = v35 - v38
            if v42 <= 0 then
                break
            end
            v_u_27:Fire()
            if v_u_18 then
                v_u_18:Cancel()
                v_u_18 = nil
            end
            if v_u_19 then
                v_u_19:Cancel()
                v_u_19 = nil
            end
            v_u_18 = TweenService:Create(v40, TweenInfo.new(v42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["BackgroundTransparency"] = 1
            })
            v_u_19 = TweenService:Create(v41, TweenInfo.new(v42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Brightness"] = 0,
                ["Saturation"] = 0
            })
            v_u_18:Play()
            v_u_19:Play()
            while v_u_25 == p34 do
                local v43 = os.clock()
                if v35 <= v43 or v_u_23 and v43 < v_u_23 then
                    break
                end
                task.wait(0.05)
            end
        end
    end
    if v_u_25 == p34 then
        if v_u_18 then
            v_u_18:Cancel()
            v_u_18 = nil
        end
        if v_u_19 then
            v_u_19:Cancel()
            v_u_19 = nil
        end
        if v_u_15 then
            v_u_15:Destroy()
            v_u_15 = nil
            v_u_16 = nil
        end
        if v_u_17 then
            v_u_17:Destroy()
            v_u_17 = nil
        end
        v_u_22 = nil
        v_u_23 = nil
        v_u_24 = nil
        v_u_28:Fire()
    end
end
local function v_u_55(p45, p46, p47) -- name: CalculateFlashDuration
    if p46.Magnitude <= 0 then
        return 0, 0, 0, "zero_direction", 0
    end
    local v48 = 3 - p47 * 0.01309090909090909
    if v48 <= 0 then
        return 0, 0, v48, "zero_strength", 0
    end
    local v49 = p45:Dot(p46.Unit)
    local v50 = math.clamp(v49, -1, 1)
    local v51, v52, v53
    if v50 >= 0.6 then
        v51 = v48 * 2.5
        v52 = v48 * 1.25
        v53 = "front"
    elseif v50 >= 0.3 then
        v51 = v48 * 1.75
        v52 = v48 * 0.8
        v53 = "side_front"
    elseif v50 >= -0.2 then
        v51 = v48 * 1
        v52 = v48 * 0.5
        v53 = "side_back"
    else
        v51 = v48 * 0.5
        v52 = v48 * 0.25
        v53 = "back"
    end
    local v54 = v51 <= 0 and 0 or v52 / v51
    return v51 / 1.4, v50, v48, v53, v54
end
local v_u_56 = { -0.5, 0, 0.5 }
local Barriers = nil
local function v_u_71(p58, p59) -- name: HasLineOfSight
    -- upvalues: (copy) Debris, (copy) LocalPlayer, (ref) Barriers, (copy) Workspace, (copy) v_u_14, (copy) v_u_56
    debug.profilebegin("VFX.Flash.HasLineOfSight")
    local v60 = { Debris }
    local Character = LocalPlayer.Character
    if Character then
        table.insert(v60, Character)
    end
    local Map = not Barriers and Workspace:FindFirstChild("Map")
    if Map then
        Barriers = Map:FindFirstChild("Barriers")
    end
    local v63 = Barriers
    if v63 then
        table.insert(v60, v63)
    end
    v_u_14.FilterDescendantsInstances = v60
    for _, v64 in ipairs(v_u_56) do
        for _, v65 in ipairs(v_u_56) do
            for _, v66 in ipairs(v_u_56) do
                local v67 = p58 + Vector3.new(v64, v65, v66)
                local v68 = p59 - v67
                local Magnitude = v68.Magnitude
                if Magnitude < 0.1 then
                    return true
                end
                local v70 = Workspace:Raycast(v67, v68, v_u_14)
                if not v70 or v70.Distance >= Magnitude - 0.5 then
                    debug.profileend()
                    return true
                end
            end
        end
    end
    debug.profileend()
    return false
end
return {
    ["OnFlashRecoveryStarted"] = v_u_27,
    ["OnFlashCleared"] = v_u_28,
    ["Flash"] = function(p72) -- name: Flash
        -- upvalues: (copy) v_u_30, (copy) CurrentCamera, (copy) v_u_71, (copy) v_u_55, (ref) v_u_20, (ref) v_u_21, (copy) m_Sound, (copy) m_RunServiceController, (ref) v_u_22, (ref) v_u_26, (ref) v_u_24, (ref) v_u_23, (ref) v_u_15, (ref) v_u_16, (ref) v_u_17, (copy) v_u_33, (copy) Lighting, (ref) v_u_18, (ref) v_u_19, (copy) TweenService, (ref) v_u_25, (copy) v_u_44
        debug.profilebegin("VFX.Flash")
        local Position = p72.Position
        local v74 = not p72.Duration and "nil" or string.format("%.3f", p72.Duration)
        local v75 = v_u_30
        local v76 = Position.X
        local v77 = Position.Y
        local v78 = Position.Z
        local AttackerUserId = p72.AttackerUserId
        v75("recv pos=(%.2f, %.2f, %.2f) netDuration=%s attacker=%s", v76, v77, v78, v74, (tostring(AttackerUserId)))
        local Position_0 = CurrentCamera.CFrame.Position
        local LookVector = CurrentCamera.CFrame.LookVector
        local v_u_82 = 0
        local v_u_83
        if p72.Duration then
            v_u_83 = p72.Duration
            v_u_30("spectator_duration=%.3f", v_u_83)
        else
            local v84 = Position - Position_0
            local Magnitude_0 = v84.Magnitude
            if Magnitude_0 > 229.16666666666669 then
                v_u_30("skip=out_of_range distance=%.3f radius=%.3f", Magnitude_0, 229.16666666666669)
                debug.profileend()
                return false
            end
            if not v_u_71(Position, Position_0) then
                v_u_30("skip=no_los distance=%.3f", Magnitude_0)
                debug.profileend()
                return false
            end
            debug.profilebegin("VFX.Flash.CalculateDuration")
            local v86, v87, v88, v89, v90 = v_u_55(LookVector, v84, Magnitude_0)
            debug.profileend()
            v_u_83 = v86
            v_u_82 = v90
            v_u_30("calc distance=%.3f dot=%.3f bucket=%s strength=%.3f duration=%.3f sourceHold=%.3f", Magnitude_0, v87, v89, v88, v_u_83, v_u_82)
        end
        if v_u_83 < 0.01 then
            v_u_30("skip=below_threshold duration=%.3f threshold=0.010", v_u_83)
            debug.profileend()
            return false
        end
        debug.profilebegin("VFX.Flash.Sound")
        if v_u_20 then
            if v_u_21 then
                v_u_21:Disconnect()
                v_u_21 = nil
            end
            if v_u_20.Parent then
                v_u_20:Stop()
                v_u_20:Destroy()
            end
            v_u_20 = nil
        end
        local v91 = {
            ["Parent"] = nil,
            ["Name"] = "Flashed",
            ["Parent"] = CurrentCamera
        }
        local v_u_92 = m_Sound.new("Flashbang"):play(v91)
        if v_u_92 then
            v_u_20 = v_u_92
            local v_u_93 = tick()
            local Volume = v_u_92.Volume
            v_u_21 = m_RunServiceController.BindToHeartbeat("VFX.FlashEffect.SoundFade", function()
                -- upvalues: (copy) v_u_93, (ref) v_u_21, (copy) v_u_92, (ref) v_u_20, (copy) Volume
                local v95 = tick() - v_u_93
                if v95 >= 4 then
                    if v_u_21 then
                        v_u_21:Disconnect()
                        v_u_21 = nil
                    end
                    if v_u_92 and v_u_92.Parent then
                        v_u_92:Stop()
                        v_u_92:Destroy()
                    end
                    if v_u_20 == v_u_92 then
                        v_u_20 = nil
                        return
                    end
                else
                    if v_u_92 and v_u_92.Parent then
                        v_u_92.Volume = Volume * (v95 >= 4 and 0 or 1 - v95 * 0.225)
                        return
                    end
                    if not (v_u_92 and v_u_92.Parent) then
                        if v_u_21 then
                            v_u_21:Disconnect()
                            v_u_21 = nil
                        end
                        if v_u_20 == v_u_92 then
                            v_u_20 = nil
                        end
                    end
                end
            end)
        end
        debug.profileend();
        (function() -- name: applyFlashEffect
            -- upvalues: (ref) v_u_22, (ref) v_u_83, (ref) v_u_30, (ref) v_u_82, (ref) v_u_26, (ref) v_u_24, (ref) v_u_23, (ref) v_u_15, (ref) v_u_16, (ref) v_u_17, (ref) v_u_33, (ref) Lighting, (ref) v_u_18, (ref) v_u_19, (ref) TweenService, (ref) v_u_25, (ref) v_u_44
            debug.profilebegin("VFX.Flash.Apply")
            local v96 = os.clock()
            local v97
            if v_u_22 then
                local v98 = v_u_22 - v96
                v97 = math.max(0, v98) or 0
            else
                v97 = 0
            end
            local v99 = v_u_83
            local v100 = math.max(v97, v99)
            local v101 = v100 - 3
            local v102 = math.max(0, v101)
            local v103
            if v100 > 3 then
                v103 = 1
            else
                local v104 = (v100 / 3) ^ 0.6
                v103 = math.clamp(v104, 0, 1)
            end
            v_u_30("apply incoming=%.3f remaining=%.3f result=%.3f holdWindow=%.3f peakAlpha=%.3f sourceHold=%.3f", v_u_83, v97, v100, v102, v103, v_u_82)
            v_u_26 = v96
            v_u_22 = v96 + v100
            v_u_24 = v103
            local v105 = v96 + 0.05 + v102
            local v106 = v_u_22
            local v107 = v_u_23 or 0
            local v108 = math.max(v107, v105)
            v_u_23 = math.min(v106, v108)
            local v109 = v_u_15
            local v110 = v_u_16
            local v111 = v_u_17
            if not (v109 and v110) then
                v109, v110 = v_u_33()
                v_u_15 = v109
                v_u_16 = v110
            end
            if not v111 then
                v111 = Instance.new("ColorCorrectionEffect")
                v111.Name = "FlashbangColorCorrection"
                v111.Brightness = 0
                v111.Contrast = 0
                v111.Saturation = 0
                v111.TintColor = Color3.new(1, 1, 1)
                v111.Parent = Lighting
                v_u_17 = v111
            end
            debug.profilebegin("VFX.Flash.Apply.CreateTweens")
            if v_u_18 then
                v_u_18:Cancel()
                v_u_18 = nil
            end
            if v_u_19 then
                v_u_19:Cancel()
                v_u_19 = nil
            end
            local v112 = TweenService:Create(v110, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["BackgroundTransparency"] = 1 - v103
            })
            local v113 = TweenService:Create(v111, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Brightness"] = v103,
                ["Saturation"] = -v103
            })
            v112:Play()
            v113:Play()
            debug.profileend()
            v_u_25 = v_u_25 + 1
            local v_u_114 = v_u_25
            task.spawn(function()
                -- upvalues: (ref) v_u_44, (copy) v_u_114
                v_u_44(v_u_114)
            end)
            debug.profileend()
        end)()
        debug.profileend()
        return true
    end,
    ["CancelFlash"] = function() -- name: CancelFlash
        -- upvalues: (copy) v_u_30, (ref) v_u_25, (ref) v_u_18, (ref) v_u_19, (ref) v_u_15, (ref) v_u_16, (ref) v_u_17, (ref) v_u_22, (ref) v_u_23, (ref) v_u_24, (copy) v_u_28, (ref) v_u_26, (ref) v_u_21, (ref) v_u_20
        debug.profilebegin("VFX.Flash.Cancel")
        v_u_30("cancel")
        v_u_25 = v_u_25 + 1
        if v_u_18 then
            v_u_18:Cancel()
            v_u_18 = nil
        end
        if v_u_19 then
            v_u_19:Cancel()
            v_u_19 = nil
        end
        if v_u_15 then
            v_u_15:Destroy()
            v_u_15 = nil
            v_u_16 = nil
        end
        if v_u_17 then
            v_u_17:Destroy()
            v_u_17 = nil
        end
        v_u_22 = nil
        v_u_23 = nil
        v_u_24 = nil
        v_u_28:Fire()
        v_u_26 = nil
        if v_u_21 then
            v_u_21:Disconnect()
            v_u_21 = nil
        end
        if v_u_20 and v_u_20.Parent then
            v_u_20:Stop()
            v_u_20:Destroy()
        end
        v_u_20 = nil
        debug.profileend()
    end,
    ["IsFlashed"] = function() -- name: IsFlashed
        -- upvalues: (ref) v_u_22
        if v_u_22 then
            return os.clock() < v_u_22
        else
            return false
        end
    end,
    ["GetAudioFadeMultiplier"] = function() -- name: GetAudioFadeMultiplier
        -- upvalues: (ref) v_u_26
        if not v_u_26 then
            return 1
        end
        local v115 = os.clock() - v_u_26
        if v115 >= 1.5 then
            return 1
        end
        if v115 < 0.5 then
            return 0
        end
        local v116 = (v115 - 0.5) / 1
        return math.clamp(v116, 0, 1)
    end
}
