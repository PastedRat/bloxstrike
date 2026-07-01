-- Decompiled with Medal

local v_u_1 = {}
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local MainGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui")
require(script:WaitForChild("Types"))
local m_SceneRegistry = require(script:WaitForChild("SceneRegistry"))
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local CurrentCamera = workspace.CurrentCamera
local v_u_17 = false
local v_u_18 = nil
local v_u_19 = nil
local v_u_20 = nil
local v_u_21 = nil
local v_u_22 = m_Janitor.new()
local v_u_23 = false
local v_u_24 = nil
local v_u_25 = {}
local v_u_26 = false
local v_u_27 = nil
local CFrame = nil
local v_u_29 = 0
local v_u_30 = nil
local v_u_31 = {}
local v_u_32 = nil
local v_u_33 = nil
local function v_u_34(...) -- name: DebugLog end
local v_u_35 = false
local v_u_36 = nil
local Position = nil
local Position_0 = nil
local v_u_39 = 0
local Magnitude = 1
local Length = 0
local v_u_42 = nil
local v_u_43 = false
local v_u_44 = false
local function v_u_50() -- name: hideMenuFrames
    -- upvalues: (copy) m_MenuState, (ref) v_u_17, (copy) m_MenuSceneController
    m_MenuState.EnterCaseScene()
    local v45 = m_MenuState.GetMenuFrame()
    if v45 then
        v_u_17 = m_MenuSceneController.IsActive()
        if v_u_17 then
            m_MenuSceneController.HideMenuScene(true, true)
            m_MenuSceneController.SetMusicVolumeMultiplier(0.5, 0.5)
        end
        m_MenuState.SetBlurEnabled(false)
        v45.BackgroundTransparency = 1
        local Pattern = v45:FindFirstChild("Pattern")
        if Pattern then
            Pattern.Visible = false
        end
        local Top = v45:FindFirstChild("Top")
        if Top then
            Top.Visible = false
        end
        local Store = v45:FindFirstChild("Store")
        if Store then
            Store.Visible = true
        end
        for _, v49 in v45:GetChildren() do
            if v49:IsA("Frame") and (v49.Name ~= "Top" and (v49.Name ~= "Store" and v49.Name ~= "OpenCase")) then
                v49.Visible = false
            end
        end
    end
end
local function v_u_54(p51) -- name: hideViewmodel
    -- upvalues: (ref) v_u_25
    for _, v52 in p51:GetDescendants() do
        if v52:IsA("BasePart") then
            if v52.Transparency < 1 then
                v52:SetAttribute("_CaseScenePrevTransparency", v52.Transparency)
                v52.Transparency = 1
            end
        elseif v52:IsA("SurfaceGui") then
            if v52.Enabled then
                v52:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", true)
                v52.Enabled = false
            end
        elseif v52:IsA("Texture") and v52.Transparency < 1 then
            v52:SetAttribute("_CaseScenePrevTransparency", v52.Transparency)
            v52.Transparency = 1
        end
    end
    local v53 = v_u_25
    table.insert(v53, p51)
end
local function v_u_57() -- name: hideViewmodels
    -- upvalues: (ref) v_u_25, (ref) v_u_20, (copy) CurrentCamera, (copy) v_u_54
    v_u_25 = {}
    local v55 = v_u_20 and v_u_20.AssetFolder or nil
    for _, v56 in CurrentCamera:GetChildren() do
        if v56:IsA("Model") and v56.Name ~= v55 then
            v_u_54(v56)
        end
    end
end
local function v_u_62() -- name: showViewmodels
    -- upvalues: (ref) v_u_25
    for _, v58 in v_u_25 do
        if v58 and v58.Parent then
            for _, v59 in v58:GetDescendants() do
                if v59:IsA("BasePart") then
                    local v60 = v59:GetAttribute("_CaseScenePrevTransparency")
                    if v60 ~= nil then
                        v59.Transparency = v60
                        v59:SetAttribute("_CaseScenePrevTransparency", nil)
                    end
                elseif v59:IsA("SurfaceGui") then
                    if v59:GetAttribute("_CaseScenePrevSurfaceGuiEnabled") ~= nil then
                        v59.Enabled = true
                        v59:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", nil)
                    end
                elseif v59:IsA("Texture") then
                    local v61 = v59:GetAttribute("_CaseScenePrevTransparency")
                    if v61 == nil then
                        v59.Transparency = 0.3
                    else
                        v59.Transparency = v61
                        v59:SetAttribute("_CaseScenePrevTransparency", nil)
                    end
                end
            end
        end
    end
    v_u_25 = {}
end
local function v_u_66(p63) -- name: applyCaseFog
    -- upvalues: (copy) Lighting
    local CaseFog = p63:FindFirstChild("CaseFog", true)
    if CaseFog and CaseFog:IsA("Atmosphere") then
        for _, v65 in Lighting:GetChildren() do
            if v65:IsA("Atmosphere") then
                v65:Destroy()
            end
        end
        CaseFog:Clone().Parent = Lighting
    end
end
local function v_u_76() -- name: restoreMenuFrames
    -- upvalues: (copy) m_MenuState, (ref) v_u_17, (copy) m_MenuSceneController
    local v67 = m_MenuState.GetMenuFrame()
    if v67 and v67.Visible then
        local v68 = m_MenuState.GetScreenBeforeCaseScene()
        local v69 = v_u_17
        v_u_17 = false
        m_MenuState.ExitCaseScene()
        if v69 then
            m_MenuSceneController.ShowMenuScene()
            m_MenuSceneController.SetMusicVolumeMultiplier(1, 0.5)
        else
            m_MenuSceneController.ApplyMapLighting()
        end
        local Top_0 = v67:FindFirstChild("Top")
        if Top_0 then
            Top_0.Visible = true
        end
        if v68 then
            local v71 = v67:FindFirstChild(v68)
            if v71 then
                v71.Visible = true
                local v72
                if v68 == "Dashboard" then
                    v72 = false
                else
                    v72 = v68 ~= "Play"
                end
                m_MenuState.SetBlurEnabled(v72)
                v67.BackgroundTransparency = v72 and 0.15 or 1
                local Pattern_0 = v67:FindFirstChild("Pattern")
                if Pattern_0 then
                    Pattern_0.Visible = not v72
                    return
                end
            end
        else
            local Dashboard = v67:FindFirstChild("Dashboard")
            if Dashboard then
                Dashboard.Visible = true
            end
            m_MenuState.SetBlurEnabled(false)
            v67.BackgroundTransparency = 1
            local Pattern_1 = v67:FindFirstChild("Pattern")
            if Pattern_1 then
                Pattern_1.Visible = true
            end
        end
    else
        v_u_17 = false
        m_MenuState.ExitCaseScene()
        m_MenuSceneController.ApplyMapLighting()
    end
end
local function v_u_84(p77, p78) -- name: setupCaseModel
    -- upvalues: (copy) ReplicatedStorage
    local CaseMod = p77:FindFirstChild("CaseMod")
    if CaseMod and CaseMod:GetAttribute("IsDynamicModel") then
        CaseMod:Destroy()
    end
    local CaseModels = ReplicatedStorage.Assets:FindFirstChild("CaseModels")
    if CaseModels then
        local v81 = CaseModels:FindFirstChild(p78)
        if v81 then
            local v82 = v81:Clone()
            v82.Name = "CaseMod"
            v82:SetAttribute("IsDynamicModel", true)
            local CasePivot = p77:FindFirstChild("CasePivot")
            if CasePivot then
                v82:PivotTo(CasePivot.CFrame)
                v82.Parent = p77
                return v82
            else
                warn("[CaseSceneController]: CasePivot not found in CaseScene")
                v82.Parent = p77
                return v82
            end
        else
            warn("[CaseSceneController]: Case model not found for case: " .. p78)
            return nil
        end
    else
        warn("[CaseSceneController]: CaseModels folder not found in ReplicatedStorage.Assets")
        return nil
    end
end
local function v_u_90(p85, p86) -- name: findAnimationController
    local v87
    if p86.InteractionType == "Drag" then
        v87 = p85:FindFirstChild("Pack")
    else
        v87 = p85:FindFirstChild("CaseMod")
    end
    if not v87 then
        return nil
    end
    local AnimationController = v87:FindFirstChildOfClass("AnimationController")
    if not AnimationController then
        return nil
    end
    local Animator = AnimationController:FindFirstChildOfClass("Animator")
    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = AnimationController
    end
    return Animator
end
local function v_u_100(p91, p92, p93) -- name: loadAnimations
    -- upvalues: (copy) v_u_90, (ref) v_u_32, (ref) v_u_31
    local v94
    if p92.InteractionType == "Click" and p93 then
        local AnimationController_0 = p93:FindFirstChildOfClass("AnimationController")
        v94 = not AnimationController_0 or AnimationController_0:FindFirstChildOfClass("Animator")
        if not v94 then
            v94 = Instance.new("Animator")
            v94.Parent = AnimationController_0
        end
    else
        v94 = nil
    end
    local v96 = v94 or v_u_90(p91, p92)
    if v96 then
        v_u_32 = v96
        for v97, v98 in p92.Animations do
            if v98 then
                local v99 = Instance.new("Animation")
                v99.AnimationId = v98
                v_u_31[v97] = v96:LoadAnimation(v99)
                v99:Destroy()
            end
        end
    else
        warn("[CaseSceneController]: No animator found for scene")
    end
end
local function v_u_104(p101, p102) -- name: setEffectsEnabled
    if p101 then
        for _, v103 in p101:GetDescendants() do
            if v103:IsA("Beam") or v103:IsA("ParticleEmitter") then
                v103.Enabled = p102
            end
        end
    end
end
local function v_u_106() -- name: enableCaseEffects
    -- upvalues: (ref) v_u_18, (copy) v_u_104
    local CaseMod_0 = v_u_18
    if CaseMod_0 then
        CaseMod_0 = v_u_18:FindFirstChild("CaseMod")
    end
    if CaseMod_0 then
        v_u_104(CaseMod_0:FindFirstChild("IdleEffect"), true)
        v_u_104(CaseMod_0:FindFirstChild("OpeningEffect"), false)
        v_u_104(CaseMod_0:FindFirstChild("EffectsPart"), true)
    end
end
local function v_u_108() -- name: disableCaseEffects
    -- upvalues: (ref) v_u_18, (copy) v_u_104
    local CaseMod_1 = v_u_18
    if CaseMod_1 then
        CaseMod_1 = v_u_18:FindFirstChild("CaseMod")
    end
    if CaseMod_1 then
        v_u_104(CaseMod_1:FindFirstChild("IdleEffect"), false)
        v_u_104(CaseMod_1:FindFirstChild("OpeningEffect"), false)
        v_u_104(CaseMod_1:FindFirstChild("EffectsPart"), false)
    end
end
local function v_u_113(p109, p110) -- name: setupKeyframeSounds
    -- upvalues: (copy) m_Router, (copy) v_u_22
    for v111, v_u_112 in p110 do
        v_u_22:Add((p109:GetMarkerReachedSignal(v111):Connect(function()
            -- upvalues: (ref) m_Router, (copy) v_u_112
            m_Router.broadcastRouter("RunStoreSound", v_u_112)
        end)))
    end
end
local function v_u_120() -- name: playInspectAnimations
    -- upvalues: (ref) v_u_31, (copy) v_u_106, (ref) v_u_20, (copy) v_u_113, (copy) m_Router, (copy) v_u_22, (ref) v_u_18
    if v_u_31.CaseFall and v_u_31.CloseIdle then
        v_u_106()
        local CaseFall = v_u_31.CaseFall
        local v115 = v_u_20 and v_u_20.AnimationKeyframeSounds
        if v115 then
            v115 = v_u_20.AnimationKeyframeSounds.CaseFall
        end
        if v115 then
            v_u_113(CaseFall, v115)
        else
            local v_u_116 = v_u_20 and (v_u_20.Sounds and v_u_20.Sounds.Drop) or "Case Fall"
            v_u_22:Add((CaseFall:GetMarkerReachedSignal("Dropped"):Connect(function()
                -- upvalues: (ref) m_Router, (copy) v_u_116
                m_Router.broadcastRouter("RunStoreSound", v_u_116)
            end)))
        end
        v_u_22:Add((CaseFall:GetMarkerReachedSignal(v115 and v115.Drop and "Drop" or "Dropped"):Connect(function()
            -- upvalues: (ref) v_u_18
            local DropParticle = v_u_18 and v_u_18:FindFirstChild("DropParticle")
            if DropParticle then
                for _, v118 in DropParticle:GetChildren() do
                    if v118:IsA("ParticleEmitter") then
                        local v119 = v118:GetAttribute("EmitCount")
                        if typeof(v119) == "number" and v119 > 0 then
                            v118:Emit(v119)
                        end
                    end
                end
            end
        end)))
        CaseFall:Play()
        v_u_31.CloseIdle.Looped = true
        v_u_31.CloseIdle:Play()
    end
end
local function v_u_125() -- name: playOpeningAnimations
    -- upvalues: (ref) v_u_31, (ref) v_u_20, (copy) v_u_113, (copy) m_Router, (ref) v_u_18, (copy) v_u_104
    if v_u_31.CaseOpening then
        if v_u_31.CloseIdle then
            v_u_31.CloseIdle:Stop()
        end
        local CaseOpening = v_u_31.CaseOpening
        local v122 = v_u_20 and v_u_20.AnimationKeyframeSounds
        if v122 then
            v122 = v_u_20.AnimationKeyframeSounds.CaseOpening
        end
        if v122 then
            v_u_113(CaseOpening, v122)
        else
            local v123 = v_u_20 and (v_u_20.Sounds and v_u_20.Sounds.Opening) or "Case Opening"
            m_Router.broadcastRouter("RunStoreSound", v123)
        end
        local CaseMod_2 = v_u_18
        if CaseMod_2 then
            CaseMod_2 = v_u_18:FindFirstChild("CaseMod")
        end
        if CaseMod_2 then
            v_u_104(CaseMod_2:FindFirstChild("OpeningEffect"), true)
            v_u_104(CaseMod_2:FindFirstChild("IdleEffect"), false)
        end
        CaseOpening:Play()
        if v_u_31.OpenIdle then
            v_u_31.OpenIdle.Looped = true
            v_u_31.OpenIdle:Play()
        end
    end
end
local function v_u_127() -- name: stopAllAnimations
    -- upvalues: (ref) v_u_31, (ref) v_u_33
    for _, v126 in v_u_31 do
        if v126.IsPlaying then
            v126:Stop()
        end
    end
    if v_u_33 then
        v_u_33:Stop()
        v_u_33:Destroy()
        v_u_33 = nil
    end
end
local function v_u_135() -- name: finishCharmOpeningAndStartRoll
    -- upvalues: (copy) v_u_34, (ref) v_u_33, (ref) Position_0, (ref) v_u_42, (copy) MainGui, (ref) v_u_31, (ref) v_u_36, (ref) v_u_20, (copy) m_Router
    v_u_34("finishCharmOpeningAndStartRoll called")
    if v_u_33 then
        v_u_33:Stop()
    end
    Position_0 = nil
    if v_u_42 then
        v_u_42.Enabled = false
    end
    local CameraPerspective = MainGui:FindFirstChild("CameraPerspective")
    if CameraPerspective then
        CameraPerspective.Interactable = true
    end
    local PackOpening = v_u_31.PackOpening
    v_u_34("  packOpeningTrack:", PackOpening and "exists" or "nil")
    v_u_34("  CharmDragCallback:", v_u_36 and "exists" or "nil")
    if PackOpening then
        local DragLoop = not (v_u_20 and (v_u_20.Sounds and v_u_20.Sounds.DragLoop)) and "Charm Drag Loop" or v_u_20.Sounds.DragLoop
        m_Router.broadcastRouter("RunStoreSound", DragLoop)
        if not PackOpening.IsPlaying then
            PackOpening:Play()
        end
        PackOpening:AdjustSpeed(1)
        PackOpening.Looped = false
        local v131 = PackOpening.Length - PackOpening.TimePosition - 0.1
        local v132 = math.max(0, v131)
        task.delay(v132, function()
            -- upvalues: (copy) PackOpening, (ref) v_u_36
            if PackOpening.IsPlaying then
                PackOpening:AdjustSpeed(0)
                PackOpening.TimePosition = PackOpening.Length * 0.99
                if v_u_36 then
                    local v133 = v_u_36
                    v_u_36 = nil
                    v133()
                end
            end
        end)
    else
        v_u_34("  No packOpeningTrack, calling callback directly")
        if v_u_36 then
            local v134 = v_u_36
            v_u_36 = nil
            v_u_34("  Calling CharmDragCallback")
            v134()
        end
    end
end
local function v_u_144(p136, p137) -- name: updateCharmAnimationProgress
    -- upvalues: (ref) v_u_31, (ref) Length, (ref) v_u_35, (copy) v_u_135, (ref) v_u_33, (ref) Position_0, (ref) v_u_39
    local PackOpening_1 = v_u_31.PackOpening
    if PackOpening_1 then
        local v139 = math.clamp(p136, 0, 1)
        local v140
        if Length > 0 then
            v140 = Length
        else
            v140 = PackOpening_1.Length
        end
        local v141 = v140 * v139
        if not PackOpening_1.IsPlaying then
            PackOpening_1:Play()
            PackOpening_1:AdjustSpeed(0)
        end
        PackOpening_1.TimePosition = v141
        if v139 >= 1 then
            v_u_35 = false
            v_u_135()
        end
        if v_u_33 and p137 then
            local Magnitude_0 = not Position_0 and 0 or (p137 - Position_0).Magnitude
            Position_0 = p137
            if Magnitude_0 > 0.001 then
                v_u_39 = tick()
                if not v_u_33.IsPlaying then
                    v_u_33:Play()
                end
                local v143 = Magnitude_0 * 20
                v_u_33.PlaybackSpeed = math.clamp(v143, 0, 0.7) + 0.8
            end
        end
    end
end
local function v_u_175(p145) -- name: setupCharmDragDetector
    -- upvalues: (ref) v_u_18, (copy) ContextActionService, (ref) v_u_43, (ref) v_u_36, (ref) v_u_35, (ref) Position, (ref) Magnitude, (ref) v_u_31, (ref) v_u_20, (ref) Length, (copy) MainGui, (ref) v_u_42, (copy) v_u_22, (ref) v_u_44, (copy) m_RunServiceController, (ref) Position_0, (ref) v_u_39, (ref) v_u_33, (copy) ReplicatedStorage, (copy) v_u_135, (copy) v_u_144, (copy) UserInputService, (ref) v_u_23, (ref) v_u_24, (copy) m_Router
    if v_u_18 then
        local Pack = v_u_18:FindFirstChild("Pack")
        if Pack then
            local Drag = Pack:FindFirstChild("Drag")
            if Drag then
                local DragDetector = Drag:FindFirstChildOfClass("DragDetector")
                if DragDetector then
                    ContextActionService:UnbindAction("Fire")
                    ContextActionService:UnbindAction("Secondary Fire")
                    v_u_43 = true
                    v_u_36 = p145
                    v_u_35 = false
                    Position = Drag.Position
                    Magnitude = DragDetector.MaxDragTranslation.Magnitude
                    if Magnitude <= 0 then
                        Magnitude = 1
                    end
                    local PackOpening_0 = v_u_31.PackOpening
                    if PackOpening_0 then
                        local EndKeyframe = not (v_u_20 and (v_u_20.DragSettings and v_u_20.DragSettings.EndKeyframe)) and "DragEndPoint" or v_u_20.DragSettings.EndKeyframe
                        local v151, v152 = pcall(function()
                            -- upvalues: (copy) PackOpening_0, (ref) EndKeyframe
                            return PackOpening_0:GetTimeOfKeyframe(EndKeyframe)
                        end)
                        if v151 and v152 then
                            Length = v152
                        else
                            Length = PackOpening_0.Length
                            warn("[CaseSceneController]: " .. EndKeyframe .. " keyframe not found, using full animation length")
                        end
                    end
                    DragDetector.Enabled = true
                    local CameraPerspective_0 = MainGui:FindFirstChild("CameraPerspective")
                    if CameraPerspective_0 then
                        CameraPerspective_0.Interactable = false
                    end
                    local SurfaceGui = Drag:FindFirstChildOfClass("SurfaceGui")
                    if SurfaceGui then
                        SurfaceGui.Enabled = true
                        v_u_42 = SurfaceGui
                        local Frame = SurfaceGui:FindFirstChildOfClass("Frame")
                        local ImageLabel = Frame and Frame:FindFirstChildOfClass("ImageLabel")
                        if ImageLabel then
                            v_u_22:Add(Frame.MouseEnter:Connect(function()
                                -- upvalues: (ref) v_u_44, (copy) ImageLabel
                                v_u_44 = true
                                ImageLabel.ImageTransparency = 1
                            end), "Disconnect", "CharmImageHoverEnter")
                            v_u_22:Add(Frame.MouseLeave:Connect(function()
                                -- upvalues: (ref) v_u_44, (copy) ImageLabel
                                v_u_44 = false
                                ImageLabel.ImageTransparency = 0
                            end), "Disconnect", "CharmImageHoverLeave")
                            local v_u_157 = 0
                            v_u_22:Add(m_RunServiceController.BindToRenderStep("CaseSceneController.CharmImageBreathing", function(p158)
                                -- upvalues: (ref) v_u_44, (ref) v_u_157, (copy) ImageLabel
                                if not v_u_44 then
                                    v_u_157 = v_u_157 + p158 * 2
                                    local v159 = v_u_157
                                    ImageLabel.ImageTransparency = (math.sin(v159) + 1) / 2 * 0.2
                                end
                            end), "Disconnect", "CharmImageBreathing")
                        end
                    end
                    v_u_22:Add(DragDetector.DragStart:Connect(function()
                        -- upvalues: (ref) v_u_35, (ref) Position_0, (copy) Drag, (ref) v_u_39, (ref) v_u_33, (ref) v_u_20, (ref) ReplicatedStorage, (copy) Pack, (ref) v_u_22
                        v_u_35 = true
                        Position_0 = Drag.Position
                        v_u_39 = tick()
                        if not v_u_33 then
                            local DragStart = not (v_u_20 and (v_u_20.Sounds and v_u_20.Sounds.DragStart)) and "Charm Drag Start" or v_u_20.Sounds.DragStart
                            local v161 = require(ReplicatedStorage.Database.Audio.Store)[DragStart]
                            if v161 and (v161.Identifiers and v161.Identifiers[1]) then
                                local v162 = Instance.new("Sound")
                                v162.Name = "DragProgress"
                                v162.SoundId = "rbxassetid://" .. v161.Identifiers[1]
                                v162.Volume = v161.Properties.Volume or 1
                                v162.Looped = true
                                v162.PlaybackSpeed = 0.8
                                v162.Parent = Pack
                                v_u_33 = v162
                                v_u_22:Add(v162, "Destroy")
                            end
                        end
                    end), "Disconnect", "CharmDragStart")
                    v_u_22:Add(m_RunServiceController.BindToHeartbeat("CaseSceneController.CharmDragSoundCheck", function()
                        -- upvalues: (ref) v_u_35, (ref) v_u_33, (ref) v_u_39
                        if v_u_35 and (v_u_33 and (v_u_33.IsPlaying and tick() - v_u_39 > 0.05)) then
                            v_u_33:Stop()
                        end
                    end), "Disconnect", "CharmDragSoundCheck")
                    v_u_22:Add(DragDetector.DragContinue:Connect(function()
                        -- upvalues: (ref) v_u_35, (ref) Position, (copy) Drag, (ref) Magnitude, (ref) v_u_20, (copy) DragDetector, (ref) v_u_135, (ref) v_u_144
                        if v_u_35 and Position then
                            local v163 = (Drag.Position - Position).Magnitude / Magnitude
                            local v164 = math.clamp(v163, 0, 1)
                            if (not (v_u_20 and (v_u_20.DragSettings and v_u_20.DragSettings.Threshold)) and 0.5 or v_u_20.DragSettings.Threshold) <= v164 then
                                v_u_35 = false
                                DragDetector.Enabled = false
                                if Position then
                                    Drag.Position = Position
                                end
                                v_u_135()
                            else
                                v_u_144(v164, Drag.Position)
                            end
                        else
                            return
                        end
                    end), "Disconnect", "CharmDragContinue")
                    v_u_22:Add(DragDetector.DragEnd:Connect(function()
                        -- upvalues: (ref) v_u_35, (ref) Position, (ref) v_u_33, (copy) Drag, (ref) Magnitude, (ref) v_u_20, (copy) DragDetector, (ref) v_u_135, (ref) v_u_31, (ref) Position_0
                        if v_u_35 and Position then
                            v_u_35 = false
                            if v_u_33 then
                                v_u_33:Stop()
                            end
                            local v165 = (Drag.Position - Position).Magnitude / Magnitude
                            local v166 = math.clamp(v165, 0, 1)
                            Drag.Position = Position
                            local v167
                            if v_u_20 and (v_u_20.DragSettings and v_u_20.DragSettings.Threshold) then
                                local Threshold = v_u_20.DragSettings.Threshold
                                v167 = math.max(Threshold, 0.8)
                            else
                                v167 = 0.8
                            end
                            if v167 <= v166 then
                                DragDetector.Enabled = false
                                v_u_135()
                            else
                                local PackOpening_2 = v_u_31.PackOpening
                                if PackOpening_2 then
                                    PackOpening_2.TimePosition = 0
                                end
                                Position_0 = nil
                            end
                        else
                            return
                        end
                    end), "Disconnect", "CharmDragEnd")
                    v_u_22:Add(UserInputService.InputBegan:Connect(function(p170, p171)
                        -- upvalues: (ref) v_u_23, (ref) v_u_24, (copy) DragDetector, (ref) v_u_35, (ref) Position, (copy) Drag, (ref) v_u_33, (ref) v_u_20, (ref) m_Router, (ref) v_u_135
                        if v_u_23 and v_u_24 == "Unboxing" then
                            local v172 = p170.UserInputType == Enum.UserInputType.Gamepad1
                            local v173 = p170.UserInputType == Enum.UserInputType.Keyboard
                            if not (v173 and p171) then
                                if v172 then
                                    v172 = p170.KeyCode == Enum.KeyCode.ButtonX and true or p170.KeyCode == Enum.KeyCode.ButtonA
                                end
                                if v173 then
                                    v173 = p170.KeyCode == Enum.KeyCode.Return and true or p170.KeyCode == Enum.KeyCode.Space
                                end
                                if v172 or v173 then
                                    DragDetector.Enabled = false
                                    if v_u_35 then
                                        v_u_35 = false
                                        if Position then
                                            Drag.Position = Position
                                        end
                                    end
                                    if v_u_33 then
                                        v_u_33:Stop()
                                    end
                                    local DragStart_0 = not (v_u_20 and (v_u_20.Sounds and v_u_20.Sounds.DragStart)) and "Charm Drag Start" or v_u_20.Sounds.DragStart
                                    m_Router.broadcastRouter("RunStoreSound", DragStart_0)
                                    v_u_135()
                                end
                            end
                        else
                            return
                        end
                    end), "Disconnect", "CharmControllerSkip")
                else
                    warn("[CaseSceneController]: DragDetector not found on Drag part")
                end
            else
                warn("[CaseSceneController]: Drag part not found in Pack")
                return
            end
        else
            warn("[CaseSceneController]: Pack not found in CharmScene")
            return
        end
    else
        return
    end
end
function v_u_1.ShowCaseScene(p176, p177) -- name: ShowCaseScene
    -- upvalues: (copy) v_u_34, (ref) v_u_23, (copy) m_SceneRegistry, (ref) v_u_19, (ref) v_u_20, (ref) v_u_21, (ref) v_u_18, (ref) v_u_24, (copy) CurrentCamera, (copy) v_u_50, (ref) v_u_17, (copy) m_MenuSceneController, (copy) v_u_66, (copy) v_u_57, (copy) v_u_22, (copy) v_u_54, (copy) v_u_84, (copy) v_u_100, (copy) v_u_120, (copy) m_CameraController, (copy) m_RunServiceController, (ref) v_u_26, (ref) v_u_27, (ref) CFrame, (ref) v_u_29, (copy) TweenService, (ref) v_u_30, (copy) v_u_108, (ref) v_u_43, (copy) m_Router, (ref) v_u_35, (ref) v_u_36, (ref) Position, (ref) Position_0, (ref) v_u_39, (ref) Magnitude, (ref) Length, (ref) v_u_42, (ref) v_u_44, (copy) v_u_127, (ref) v_u_31, (ref) v_u_32
    v_u_34("ShowCaseScene called")
    v_u_34("  caseType:", p176 or "nil")
    v_u_34("  caseName:", p177 or "nil")
    v_u_34("  IsCaseSceneActive:", v_u_23)
    if v_u_23 then
        v_u_34("  BLOCKED: Scene already active")
        return
    else
        local v178 = m_SceneRegistry.GetSceneForCaseType(p176 or "Case")
        v_u_34("  sceneName:", v178)
        local v_u_179 = m_SceneRegistry.GetConfig(v178)
        if v_u_179 then
            v_u_34("  config.AssetFolder:", v_u_179.AssetFolder)
            v_u_34("  config.InteractionType:", v_u_179.InteractionType)
            v_u_19 = v178
            v_u_20 = v_u_179
            v_u_21 = p177
            local v180 = workspace:FindFirstChild(v_u_179.AssetFolder)
            if v180 then
                v_u_18 = v180
                local Pack_0 = v_u_179.InteractionType == "Drag" and v180:FindFirstChild("Pack")
                if Pack_0 then
                    local Drag_0 = Pack_0:FindFirstChild("Drag")
                    local SurfaceGui_0 = Drag_0 and Drag_0:FindFirstChildOfClass("SurfaceGui")
                    if SurfaceGui_0 then
                        SurfaceGui_0.Enabled = false
                    end
                end
                v_u_24 = "Inspecting"
                local v184
                if v_u_18 then
                    local Camera = v_u_18:FindFirstChild("Camera")
                    if Camera then
                        v184 = Camera:FindFirstChild("Inspecting")
                    else
                        v184 = nil
                    end
                else
                    v184 = nil
                end
                if v184 then
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = v184.CFrame
                    CurrentCamera.Focus = v184.CFrame
                    v_u_50()
                    if not v_u_17 then
                        m_MenuSceneController.ApplyMenuSceneLighting()
                    end
                    v_u_66(v180)
                    v_u_57()
                    v_u_22:Add(CurrentCamera.ChildAdded:Connect(function(p186)
                        -- upvalues: (copy) v_u_179, (ref) v_u_54
                        if p186:IsA("Model") and p186.Name ~= v_u_179.AssetFolder then
                            v_u_54(p186)
                        end
                    end), "Disconnect", "ViewmodelListener")
                    local v187
                    if p177 and v_u_179.InteractionType == "Click" then
                        v187 = v_u_84(v180, p177)
                    else
                        v187 = nil
                    end
                    v_u_100(v180, v_u_179, v187)
                    if v_u_179.InteractionType == "Click" then
                        v_u_120()
                    end
                    m_CameraController.setFOVLock("CaseScene", true, 50)
                    m_CameraController.setForceLockOverride("CaseScene", true)
                    local v188 = Enum.RenderPriority.Camera.Value + 10
                    m_RunServiceController.BindToRenderStep("CaseSceneController.CameraUpdate", v188, function()
                        -- upvalues: (ref) v_u_18, (ref) CurrentCamera, (ref) v_u_26, (ref) v_u_27, (ref) CFrame, (ref) v_u_29, (ref) TweenService, (ref) v_u_30, (ref) v_u_24
                        if v_u_18 then
                            CurrentCamera.CameraType = Enum.CameraType.Scriptable
                            if v_u_26 and (v_u_27 and CFrame) then
                                local v189 = (tick() - v_u_29) / 0.8
                                local v190 = math.min(v189, 1)
                                CurrentCamera.CFrame = v_u_27:Lerp(CFrame, (TweenService:GetValue(v190, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)))
                                CurrentCamera.Focus = CurrentCamera.CFrame
                                if v190 >= 1 then
                                    v_u_26 = false
                                    CurrentCamera.CFrame = CFrame
                                    if v_u_30 then
                                        local v191 = v_u_30
                                        v_u_30 = nil
                                        v191()
                                    end
                                    v_u_27 = nil
                                    CFrame = nil
                                    return
                                end
                            else
                                local v192 = v_u_24
                                local v193
                                if v_u_18 then
                                    local Camera_0 = v_u_18:FindFirstChild("Camera")
                                    if Camera_0 then
                                        if v192 == "Inspecting" then
                                            v193 = Camera_0:FindFirstChild("Inspecting")
                                        elseif v192 == "Unboxing" then
                                            v193 = Camera_0:FindFirstChild("Unboxing")
                                        else
                                            v193 = nil
                                        end
                                    else
                                        v193 = nil
                                    end
                                else
                                    v193 = nil
                                end
                                if v193 then
                                    CurrentCamera.CFrame = v193.CFrame
                                    CurrentCamera.Focus = v193.CFrame
                                end
                            end
                        end
                    end)
                    v_u_22:Add(function()
                        -- upvalues: (ref) m_RunServiceController
                        m_RunServiceController.UnbindFromRenderStep("CaseSceneController.CameraUpdate")
                    end, true, "CameraUpdate")
                    v_u_22:Add(function()
                        -- upvalues: (ref) v_u_34, (ref) v_u_24, (ref) v_u_26, (ref) v_u_27, (ref) CFrame, (ref) v_u_30, (ref) v_u_108, (ref) v_u_43, (ref) m_Router, (ref) v_u_35, (ref) v_u_36, (ref) Position, (ref) Position_0, (ref) v_u_39, (ref) Magnitude, (ref) Length, (ref) v_u_42, (ref) v_u_44, (ref) v_u_18, (ref) v_u_127, (ref) v_u_31, (ref) v_u_32
                        v_u_34("CaseSceneCleanup running")
                        v_u_24 = nil
                        v_u_26 = false
                        v_u_27 = nil
                        CFrame = nil
                        v_u_30 = nil
                        v_u_108()
                        if v_u_43 then
                            m_Router.broadcastRouter("RebindKeybinds")
                            v_u_43 = false
                        end
                        v_u_35 = false
                        v_u_36 = nil
                        Position = nil
                        Position_0 = nil
                        v_u_39 = 0
                        Magnitude = 1
                        Length = 0
                        v_u_42 = nil
                        v_u_44 = false
                        if v_u_18 then
                            local CaseMod_3 = v_u_18:FindFirstChild("CaseMod")
                            if CaseMod_3 and CaseMod_3:GetAttribute("IsDynamicModel") then
                                CaseMod_3:Destroy()
                            end
                        end
                        v_u_127()
                        v_u_31 = {}
                        v_u_32 = nil
                        v_u_34("CaseSceneCleanup complete")
                    end, true, "CaseSceneCleanup")
                    v_u_23 = true
                    v_u_34("ShowCaseScene complete, IsCaseSceneActive = true")
                else
                    warn("[CaseSceneController]: Scene missing Camera.Inspecting")
                    v_u_18 = nil
                    v_u_19 = nil
                    v_u_20 = nil
                    v_u_24 = nil
                end
            else
                warn("[CaseSceneController]: Scene not found in workspace: " .. v_u_179.AssetFolder)
                v_u_19 = nil
                v_u_20 = nil
                v_u_21 = nil
                return
            end
        else
            warn("[CaseSceneController]: No config found for scene: " .. v178)
            v_u_34("  BLOCKED: No config found")
            return
        end
    end
end
function v_u_1.TransitionToUnboxing(p_u_196) -- name: TransitionToUnboxing
    -- upvalues: (copy) v_u_34, (ref) v_u_23, (ref) v_u_18, (ref) v_u_20, (ref) v_u_24, (copy) v_u_125, (copy) CurrentCamera, (ref) v_u_26, (ref) v_u_27, (ref) CFrame, (ref) v_u_29, (ref) v_u_30, (copy) v_u_175
    v_u_34("TransitionToUnboxing called")
    v_u_34("  IsCaseSceneActive:", v_u_23)
    v_u_34("  CurrentScene:", v_u_18 and "exists" or "nil")
    v_u_34("  CurrentSceneConfig:", v_u_20 and "exists" or "nil")
    v_u_34("  CurrentCaseSceneState:", v_u_24 or "nil")
    v_u_34("  callback:", p_u_196 and "provided" or "nil")
    if v_u_23 and (v_u_18 and v_u_20) then
        if v_u_24 == "Unboxing" then
            v_u_34("  BLOCKED: Already in Unboxing state")
            return
        else
            local v197
            if v_u_18 then
                local Camera_1 = v_u_18:FindFirstChild("Camera")
                if Camera_1 then
                    v197 = Camera_1:FindFirstChild("Unboxing")
                else
                    v197 = nil
                end
            else
                v197 = nil
            end
            if v197 then
                v_u_34("  InteractionType:", v_u_20.InteractionType)
                if v_u_20.InteractionType == "Click" then
                    v_u_34("  Playing opening animations and starting camera lerp")
                    v_u_125()
                    local v199 = v_u_24
                    local v200
                    if v_u_18 then
                        local Camera_2 = v_u_18:FindFirstChild("Camera")
                        if Camera_2 then
                            if v199 == "Inspecting" then
                                v200 = Camera_2:FindFirstChild("Inspecting")
                            elseif v199 == "Unboxing" then
                                v200 = Camera_2:FindFirstChild("Unboxing")
                            else
                                v200 = nil
                            end
                        else
                            v200 = nil
                        end
                    else
                        v200 = nil
                    end
                    local v202
                    if v200 then
                        v202 = v200.CFrame
                    else
                        v202 = CurrentCamera.CFrame
                    end
                    v_u_26 = true
                    v_u_27 = v202
                    CFrame = v197.CFrame
                    v_u_29 = tick()
                    v_u_30 = p_u_196
                else
                    v_u_34("  Starting camera lerp, will setup drag detector after")
                    local function v203()
                        -- upvalues: (ref) v_u_34, (ref) v_u_175, (copy) p_u_196
                        v_u_34("  Camera lerp complete, setting up drag detector")
                        v_u_175(p_u_196)
                    end
                    local v204 = v_u_24
                    local v205
                    if v_u_18 then
                        local Camera_3 = v_u_18:FindFirstChild("Camera")
                        if Camera_3 then
                            if v204 == "Inspecting" then
                                v205 = Camera_3:FindFirstChild("Inspecting")
                            elseif v204 == "Unboxing" then
                                v205 = Camera_3:FindFirstChild("Unboxing")
                            else
                                v205 = nil
                            end
                        else
                            v205 = nil
                        end
                    else
                        v205 = nil
                    end
                    local v207
                    if v205 then
                        v207 = v205.CFrame
                    else
                        v207 = CurrentCamera.CFrame
                    end
                    v_u_26 = true
                    v_u_27 = v207
                    CFrame = v197.CFrame
                    v_u_29 = tick()
                    v_u_30 = v203
                end
                v_u_24 = "Unboxing"
                v_u_34("  TransitionToUnboxing complete, CurrentCaseSceneState = Unboxing")
            else
                warn("[CaseSceneController]: Scene missing Camera.Unboxing")
                v_u_34("  BLOCKED: Missing Camera.Unboxing")
            end
        end
    else
        v_u_34("  BLOCKED: Scene not active or missing config")
        return
    end
end
function v_u_1.TransitionToInspecting(p208) -- name: TransitionToInspecting
    -- upvalues: (ref) v_u_23, (ref) v_u_18, (ref) v_u_24, (copy) CurrentCamera, (ref) v_u_26, (ref) v_u_27, (ref) CFrame, (ref) v_u_29, (ref) v_u_30
    if v_u_23 and v_u_18 then
        if v_u_24 == "Inspecting" then
            return
        else
            local v209
            if v_u_18 then
                local Camera_4 = v_u_18:FindFirstChild("Camera")
                if Camera_4 then
                    v209 = Camera_4:FindFirstChild("Inspecting")
                else
                    v209 = nil
                end
            else
                v209 = nil
            end
            if v209 then
                local v211 = v_u_24
                local v212
                if v_u_18 then
                    local Camera_5 = v_u_18:FindFirstChild("Camera")
                    if Camera_5 then
                        if v211 == "Inspecting" then
                            v212 = Camera_5:FindFirstChild("Inspecting")
                        elseif v211 == "Unboxing" then
                            v212 = Camera_5:FindFirstChild("Unboxing")
                        else
                            v212 = nil
                        end
                    else
                        v212 = nil
                    end
                else
                    v212 = nil
                end
                local v214
                if v212 then
                    v214 = v212.CFrame
                else
                    v214 = CurrentCamera.CFrame
                end
                v_u_26 = true
                v_u_27 = v214
                CFrame = v209.CFrame
                v_u_29 = tick()
                v_u_30 = p208
                v_u_24 = "Inspecting"
            else
                warn("[CaseSceneController]: Scene missing Camera.Inspecting")
            end
        end
    else
        return
    end
end
function v_u_1.HideCaseScene(p215) -- name: HideCaseScene
    -- upvalues: (copy) v_u_34, (ref) v_u_23, (copy) v_u_22, (copy) CurrentCamera, (copy) m_CameraController, (copy) m_Constants, (copy) ReplicatedStorage, (copy) v_u_76, (copy) m_MenuSceneController, (ref) v_u_17, (copy) m_MenuState, (copy) v_u_62, (ref) v_u_18, (ref) v_u_19, (ref) v_u_20, (ref) v_u_21, (ref) v_u_24
    v_u_34("HideCaseScene called")
    v_u_34("  IsCaseSceneActive:", v_u_23)
    v_u_34("  skipFrameRestore:", p215 or false)
    if v_u_23 then
        v_u_34("  Running CaseSceneJanitor:Cleanup()")
        v_u_22:Cleanup()
        CurrentCamera.CameraType = Enum.CameraType.Custom
        m_CameraController.setFOVLock("CaseScene", false)
        m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
        local v216 = require(ReplicatedStorage.Controllers.SpectateController).GetCurrentSpectateInstance()
        if v216 then
            v216:UpdateScopeState()
        end
        m_CameraController.setForceLockOverride("CaseScene", false)
        if p215 then
            if workspace:FindFirstChild("Map") then
                m_MenuSceneController.ApplyMapLighting()
            elseif v_u_17 then
                m_MenuSceneController.ApplyMenuSceneLighting()
            end
            m_MenuState.ExitCaseScene()
            v_u_17 = false
        else
            v_u_76()
        end
        v_u_62()
        v_u_18 = nil
        v_u_19 = nil
        v_u_20 = nil
        v_u_21 = nil
        v_u_23 = false
        v_u_24 = nil
        v_u_34("HideCaseScene complete, IsCaseSceneActive = false")
    else
        v_u_34("  BLOCKED: Scene not active")
    end
end
function v_u_1.IsActive() -- name: IsActive
    -- upvalues: (ref) v_u_23
    return v_u_23
end
function v_u_1.GetCurrentState() -- name: GetCurrentState
    -- upvalues: (ref) v_u_24
    return v_u_24
end
function v_u_1.GetSceneName() -- name: GetSceneName
    -- upvalues: (ref) v_u_19
    return v_u_19
end
function v_u_1.GetSceneConfig() -- name: GetSceneConfig
    -- upvalues: (ref) v_u_20
    return v_u_20
end
function v_u_1.ApplyCaseSceneLighting() -- name: ApplyCaseSceneLighting
    -- upvalues: (ref) v_u_23, (ref) v_u_18, (copy) m_MenuSceneController, (copy) v_u_66
    if v_u_23 and v_u_18 then
        m_MenuSceneController.ApplyMenuSceneLighting()
        v_u_66(v_u_18)
    end
end
function v_u_1.WaitForOpeningAnimation() -- name: WaitForOpeningAnimation
    -- upvalues: (ref) v_u_31
    local CaseOpening_0 = v_u_31.CaseOpening
    if CaseOpening_0 then
        if CaseOpening_0.IsPlaying then
            CaseOpening_0.Stopped:Wait()
        end
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) ReplicatedStorage, (copy) m_SceneRegistry, (copy) UserInputService, (ref) v_u_23, (copy) v_u_1, (copy) m_Router
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    if Assets then
        local function v224(p219) -- name: setupScene
            -- upvalues: (copy) Assets
            local v220 = Assets:FindFirstChild(p219)
            if not v220 then
                return
            end
            local v221 = nil
            for _, v222 in v220:GetChildren() do
                if v222:IsA("Model") then
                    v221 = v222
                    break
                end
            end
            if v221 then
                local v223 = v221:Clone()
                v223.Name = p219
                v223.Parent = workspace
            else
                warn("[CaseSceneController]: No model found in Assets." .. p219)
            end
        end
        for _, v225 in m_SceneRegistry.GetAllSceneNames() do
            local v226 = m_SceneRegistry.GetConfig(v225)
            if v226 then
                v224(v226.AssetFolder)
            end
        end
        UserInputService.InputBegan:Connect(function(p227, p228)
            -- upvalues: (ref) v_u_23, (ref) v_u_1
            if not p228 then
                if p227.KeyCode == Enum.KeyCode.Escape and v_u_23 then
                    v_u_1.HideCaseScene()
                end
            end
        end)
        m_Router.observerRouter("CaseSceneShow", function(p229, p230)
            -- upvalues: (ref) v_u_1
            v_u_1.ShowCaseScene(p229, p230)
        end)
        m_Router.observerRouter("CaseSceneUnboxing", function(p231)
            -- upvalues: (ref) v_u_1
            v_u_1.TransitionToUnboxing(p231)
        end)
        m_Router.observerRouter("CaseSceneClose", function()
            -- upvalues: (ref) v_u_1
            v_u_1.HideCaseScene()
        end)
        m_Router.observerRouter("CaseSceneCloseForGameEnd", function()
            -- upvalues: (ref) v_u_1
            v_u_1.HideCaseScene(true)
        end)
    else
        warn("[CaseSceneController]: Assets folder not found in ReplicatedStorage")
    end
end
function v_u_1.Start() -- name: Start end
m_Router.observerRouter("IsCaseSceneRolling", function()
    -- upvalues: (copy) v_u_1
    local v232 = v_u_1.IsActive()
    if v232 then
        v232 = v_u_1.GetCurrentState() == "Unboxing"
    end
    return v232
end)
return v_u_1
