-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_EndScreenController = nil
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = workspace.CurrentCamera
local MenuScenes = nil
local Lighting_0 = ReplicatedStorage.Assets.Lighting
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps
local Characters = ReplicatedStorage.Assets.Characters
local v_u_21 = {
    ["CT"] = {
        ["Entrance"] = "rbxassetid://96240248165206",
        ["Idle"] = "rbxassetid://77870220857645"
    },
    ["T"] = {
        ["Entrance"] = "rbxassetid://100747011940776",
        ["Idle"] = "rbxassetid://99540873384647"
    }
}
local v_u_22 = {
    ["CT"] = {
        ["Character"] = "IDF",
        ["Weapon"] = "M4A1-S",
        ["Glove"] = "CT Glove"
    },
    ["T"] = {
        ["Character"] = "Anarchist",
        ["Weapon"] = "AK-47",
        ["Glove"] = "T Glove"
    }
}
local m_AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter)
local v_u_24 = nil
local v_u_25 = nil
local v_u_26 = nil
local v_u_27 = nil
local v_u_28 = m_Janitor.new()
local v_u_29 = false
local v_u_30 = nil
local v_u_31 = nil
local v_u_32 = 1
local v_u_33 = nil
local GlobalShadows = nil
local function v_u_43() -- name: applyMapLighting
    -- upvalues: (copy) Maps, (ref) GlobalShadows, (copy) Lighting, (copy) m_DataController, (copy) LocalPlayer
    local Map = workspace:FindFirstChild("Map")
    if Map then
        local v36 = Map:GetAttribute("MapName")
        if v36 and typeof(v36) == "string" then
            local v37 = Maps:FindFirstChild(v36)
            if v37 and v37:IsA("ModuleScript") then
                local v38 = require(v37)
                if v38.Lighting then
                    local Properties = v38.Lighting.Properties
                    if Properties then
                        GlobalShadows = Properties.GlobalShadows
                        Lighting.Ambient = Properties.Ambient
                        Lighting.Brightness = Properties.Brightness
                        Lighting.ColorShift_Bottom = Properties.ColorShift_Bottom
                        Lighting.ColorShift_Top = Properties.ColorShift_Top
                        Lighting.EnvironmentDiffuseScale = Properties.EnvironmentDiffuseScale
                        Lighting.EnvironmentSpecularScale = Properties.EnvironmentSpecularScale
                        Lighting.GlobalShadows = Properties.GlobalShadows
                        Lighting.OutdoorAmbient = Properties.OutdoorAmbient
                        Lighting.ShadowSoftness = Properties.ShadowSoftness
                        Lighting.ClockTime = Properties.ClockTime
                        Lighting.GeographicLatitude = Properties.GeographicLatitude
                        Lighting.ExposureCompensation = Properties.ExposureCompensation
                    end
                    for _, v40 in ipairs(Lighting:GetChildren()) do
                        if v40.Name ~= "Menu" then
                            v40:Destroy()
                        end
                    end
                    local Assets = v38.Lighting.Assets
                    if Assets then
                        for _, v42 in ipairs(Assets:GetChildren()) do
                            v42:Clone().Parent = Lighting
                        end
                    end
                    if m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
                        if GlobalShadows ~= nil then
                            Lighting.GlobalShadows = GlobalShadows
                        end
                    else
                        Lighting.GlobalShadows = false
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
local function v_u_51(p44) -- name: applySceneLighting
    -- upvalues: (copy) Lighting_0, (copy) Maps, (ref) GlobalShadows, (copy) Lighting, (copy) m_DataController, (copy) LocalPlayer
    local v45 = Lighting_0:FindFirstChild(p44)
    if v45 then
        local v46 = Maps:FindFirstChild(p44)
        if v46 and v46:IsA("ModuleScript") then
            local v47 = require(v46)
            if v47.Lighting and v47.Lighting.Properties then
                local Properties_0 = v47.Lighting.Properties
                GlobalShadows = Properties_0.GlobalShadows
                Lighting.Ambient = Properties_0.Ambient
                Lighting.Brightness = Properties_0.Brightness
                Lighting.ColorShift_Bottom = Properties_0.ColorShift_Bottom
                Lighting.ColorShift_Top = Properties_0.ColorShift_Top
                Lighting.EnvironmentDiffuseScale = Properties_0.EnvironmentDiffuseScale
                Lighting.EnvironmentSpecularScale = Properties_0.EnvironmentSpecularScale
                Lighting.GlobalShadows = Properties_0.GlobalShadows
                Lighting.OutdoorAmbient = Properties_0.OutdoorAmbient
                Lighting.ShadowSoftness = Properties_0.ShadowSoftness
                Lighting.ClockTime = Properties_0.ClockTime
                Lighting.GeographicLatitude = Properties_0.GeographicLatitude
                Lighting.ExposureCompensation = Properties_0.ExposureCompensation
            end
        end
        for _, v49 in ipairs(Lighting:GetChildren()) do
            if v49.Name ~= "Menu" then
                v49:Destroy()
            end
        end
        for _, v50 in ipairs(v45:GetChildren()) do
            v50:Clone().Parent = Lighting
        end
        if m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
            if GlobalShadows ~= nil then
                Lighting.GlobalShadows = GlobalShadows
            end
        else
            Lighting.GlobalShadows = false
        end
    else
        warn((("[MenuSceneController]: No lighting found for scene \"%*\""):format(p44)))
        return
    end
end
local function v_u_65() -- name: shouldShowMenuScene
    -- upvalues: (copy) ReplicatedStorage, (ref) m_EndScreenController, (copy) PlayerGui, (copy) LocalPlayer
    local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
    if m_EndScreenController and m_EndScreenController.IsActive() then
        return false
    end
    if m_MenuState.IsInspectActive() then
        return false
    end
    if workspace:FindFirstChild("InspectScene") then
        return false
    end
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    if MainGui then
        local v54 = MainGui:FindFirstChild("Gameplay")
        if v54 then
            v54 = v54:FindFirstChild("Middle")
        end
        if v54 then
            v54 = v54:FindFirstChild("TeamSelection")
        end
        if v54 and v54.Visible then
            return false
        end
    end
    local v55 = LocalPlayer:GetAttribute("IsSpectating")
    local v56 = LocalPlayer:GetAttribute("Team")
    local v57 = require(ReplicatedStorage.Database.Components.GameState).GetState()
    if v57 == "Game Ending" or v57 == "Map Voting" then
        if v56 == "Counter-Terrorists" or v56 == "Terrorists" then
            return false
        end
        local Character = LocalPlayer.Character
        local v59
        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid")
            v59 = Humanoid and Humanoid.Health > 0 and true or false
        else
            v59 = false
        end
        return not v59
    end
    if v56 == "Counter-Terrorists" or v56 == "Terrorists" then
        return false
    end
    if LocalPlayer.Character then
        return false
    end
    local Character_0 = LocalPlayer.Character
    local v62
    if Character_0 and Character_0:IsDescendantOf(workspace) then
        local Humanoid_0 = Character_0:FindFirstChild("Humanoid")
        v62 = Humanoid_0 and Humanoid_0.Health > 0 and true or false
    else
        v62 = false
    end
    local v64 = not v62
    if v64 then
        v64 = not v55
    end
    return v64
end
local function v_u_84(p66, p67, p68) -- name: attachGlovesToCharacter
    -- upvalues: (copy) ReplicatedStorage, (copy) m_DataController, (copy) LocalPlayer, (copy) v_u_22, (copy) m_AttachGlovesToCharacter
    local m_Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
    local Name = nil
    local Skin = nil
    local Float = nil
    if p68 then
        local v73 = p67 == "CT" and "Counter-Terrorists" or "Terrorists"
        m_DataController.WaitForDataLoaded(LocalPlayer)
        local v74 = m_DataController.Get(LocalPlayer, "Loadout")
        if v74 and (type(v74) == "table" and v74[v73]) then
            local v75 = v74[v73]
            if v75 and (type(v75) == "table" and v75.Equipped) then
                local v76 = v75.Equipped["Equipped Gloves"]
                if v76 and (v76 ~= "" and type(v76) == "string") then
                    local v77 = m_DataController.Get(LocalPlayer, "Inventory")
                    if v77 and type(v77) == "table" then
                        for _, v78 in ipairs(v77) do
                            if v78 and v78._id == v76 then
                                Name = v78.Name
                                Skin = v78.Skin
                                Float = v78.Float
                                p66:SetAttribute("EquippedGloves", game:GetService("HttpService"):JSONEncode({
                                    ["SkinIdentifier"] = v76
                                }))
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    local Glove = Name or v_u_22[p67].Glove
    local v80
    if Skin and (Float and Glove) then
        v80 = m_Skins.GetGloves(Glove, Skin, Float)
    else
        v80 = nil
    end
    local v81 = v80 or ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Weapons"):FindFirstChild(Glove)
    if v81 then
        local CharacterArmor = p66:FindFirstChild("CharacterArmor")
        if not CharacterArmor then
            CharacterArmor = Instance.new("Folder")
            CharacterArmor.Name = "CharacterArmor"
            CharacterArmor.Parent = p66
        end
        local v83
        if v80 then
            v83 = v80:GetChildren()
        else
            if not v81 then
                warn((("[MenuSceneController]: No glove model or folder available for \"%*\""):format(Glove)))
                return
            end
            v83 = v81:GetChildren()
        end
        m_AttachGlovesToCharacter(v83, p66, CharacterArmor)
        if v80 and v80.Name == "" then
            v80:Destroy()
        end
    else
        warn((("[MenuSceneController]: Glove folder not found for \"%*\""):format(Glove)))
    end
end
local function v_u_112(p85, p86, p87) -- name: attachWeaponToCharacter
    -- upvalues: (copy) ReplicatedStorage, (copy) m_DataController, (copy) LocalPlayer, (copy) v_u_22
    local m_Skins_0 = require(ReplicatedStorage.Database.Components.Libraries.Skins)
    local Name_0 = nil
    local Skin_0 = nil
    local Float_0 = nil
    local NameTag = nil
    if p87 then
        local v93 = p86 == "CT" and "Counter-Terrorists" or "Terrorists"
        local v94 = p86 == "CT" and "M4A1-S" or "AK-47"
        m_DataController.WaitForDataLoaded(LocalPlayer)
        local v95 = m_DataController.Get(LocalPlayer, "Loadout")
        local v96 = m_DataController.Get(LocalPlayer, "Inventory")
        if v95 and (type(v95) == "table" and v95[v93]) then
            local v97 = v95[v93]
            if v97 and (type(v97) == "table" and v97.Loadout) then
                local Rifles = v97.Loadout.Rifles
                if Rifles and Rifles.Options then
                    local Options = Rifles.Options
                    if type(Options) == "table" and (v96 and type(v96) == "table") then
                        for _, v100 in ipairs(Rifles.Options) do
                            if v100 and (v100 ~= "" and type(v100) == "string") then
                                for _, v101 in ipairs(v96) do
                                    if v101 and (v101._id == v100 and v101.Name == v94) then
                                        Name_0 = v101.Name
                                        Skin_0 = v101.Skin
                                        Float_0 = v101.Float
                                        local _ = v101.StatTrack
                                        NameTag = v101.NameTag
                                        break
                                    end
                                end
                                if Name_0 then
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    local Weapon = Name_0 or v_u_22[p86].Weapon
    if Weapon then
        local v103
        if Skin_0 and (typeof(Skin_0) == "string" and (Skin_0 ~= "" and Weapon)) then
            v103 = m_Skins_0.GetCharacterModel(Weapon, Skin_0, Float_0, nil, NameTag)
        else
            v103 = nil
        end
        local v104 = v103 or m_Skins_0.GetBaseWeaponModel(Weapon, "Character")
        if v104 then
            v104.Name = Weapon
            local RightHand = p85:FindFirstChild("RightHand")
            if RightHand then
                if not v104.PrimaryPart then
                    local v106 = v104:FindFirstChild("Weapon")
                    if v106 then
                        v106 = v106:FindFirstChild("Insert")
                    end
                    if not v106 then
                        warn("[MenuSceneController]: Weapon model has no PrimaryPart or Insert")
                        v104:Destroy()
                        return
                    end
                    v104.PrimaryPart = v106
                end
                for _, v107 in ipairs(v104:GetDescendants()) do
                    if v107:IsA("BasePart") then
                        v107.CanCollide = false
                        v107.CanQuery = false
                        v107.CanTouch = false
                        v107.Anchored = false
                        v107.Massless = true
                    end
                end
                v104.Parent = p85
                local v108 = Instance.new("Motor6D")
                v108.Name = "WeaponAttachment"
                v108.Part0 = RightHand
                v108.Part1 = v104.PrimaryPart
                v108.Parent = RightHand
                if Weapon == "AK-47" then
                    v108.C0 = CFrame.new(-0.251, 0.806, -0.406) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966)
                    return v104
                end
                local Properties_1 = v104:FindFirstChild("Properties")
                if Properties_1 then
                    local C0 = Properties_1:FindFirstChild("C0")
                    if C0 then
                        v108.C0 = C0.Value
                    end
                    local C1 = Properties_1:FindFirstChild("C1")
                    if C1 then
                        v108.C1 = C1.Value
                    end
                end
                return v104
            end
            warn("[MenuSceneController]: Character missing RightHand")
            v104:Destroy()
        else
            warn((("[MenuSceneController]: Failed to get weapon model for \"%*\""):format(Weapon)))
        end
    else
        warn("[MenuSceneController]: No weapon name available")
        return
    end
end
local function v_u_117(p113) -- name: configureMenuDisplayCharacter
    local Humanoid_1 = p113:FindFirstChild("Humanoid")
    local HumanoidRootPart = p113:FindFirstChild("HumanoidRootPart")
    for _, v116 in ipairs(p113:GetDescendants()) do
        if v116:IsA("BasePart") then
            v116.CanCollide = false
            v116.CanQuery = false
            v116.CanTouch = false
            v116.Massless = true
        end
    end
    if Humanoid_1 then
        Humanoid_1.AutoRotate = false
    end
    if HumanoidRootPart then
        HumanoidRootPart.Anchored = true
    end
end
local function v_u_131(p118) -- name: spawnMenuCharacter
    -- upvalues: (copy) v_u_22, (copy) v_u_21, (copy) Characters, (ref) v_u_25, (ref) v_u_26, (ref) v_u_27, (copy) v_u_112, (copy) v_u_84, (copy) v_u_117, (copy) v_u_28, (ref) v_u_29
    local PlayerPart = p118:FindFirstChild("PlayerPart")
    if PlayerPart then
        local v120 = math.random(1, 2) == 1 and "CT" or "T"
        local v121 = v_u_22[v120]
        local v122 = v_u_21[v120]
        local v123 = Characters:FindFirstChild(v121.Character)
        if v123 then
            local v124 = v123:Clone()
            v124.Name = "MenuCharacter"
            v_u_25 = v124
            v_u_26 = v120
            v_u_27 = v_u_112(v124, v120, true)
            v_u_84(v124, v120, true)
            v_u_117(v124)
            v124.Parent = p118
            v124:PivotTo(PlayerPart.CFrame)
            local Humanoid_2 = v124:FindFirstChild("Humanoid")
            if Humanoid_2 then
                local Animator = Humanoid_2:FindFirstChildOfClass("Animator")
                if not Animator then
                    Animator = Instance.new("Animator")
                    Animator.Parent = Humanoid_2
                end
                local v127 = Instance.new("Animation")
                v127.AnimationId = v122.Entrance
                local v128 = Instance.new("Animation")
                v128.AnimationId = v122.Idle
                local v129 = Animator:LoadAnimation(v127)
                local v_u_130 = Animator:LoadAnimation(v128)
                v_u_28:Add(v127, "Destroy", "EntranceAnimation")
                v_u_28:Add(v128, "Destroy", "IdleAnimation")
                v_u_28:Add(v129, "Stop", "EntranceTrack")
                v_u_28:Add(v_u_130, "Stop", "IdleTrack")
                v129.Priority = Enum.AnimationPriority.Action
                v129:Play()
                v129.Stopped:Once(function()
                    -- upvalues: (ref) v_u_29, (copy) v_u_130
                    if v_u_29 and v_u_130 then
                        v_u_130.Looped = true
                        v_u_130.Priority = Enum.AnimationPriority.Idle
                        v_u_130:Play()
                    end
                end)
                v_u_28:Add(function()
                    -- upvalues: (ref) v_u_25, (ref) v_u_26, (ref) v_u_27
                    if v_u_25 then
                        v_u_25:Destroy()
                        v_u_25 = nil
                        v_u_26 = nil
                        v_u_27 = nil
                    end
                end, true, "MenuCharacterCleanup")
            else
                warn("[MenuSceneController]: Character missing Humanoid")
            end
        else
            warn((("[MenuSceneController]: Character \"%*\" not found"):format(v121.Character)))
            return
        end
    else
        return
    end
end
local function v_u_134() -- name: updateMenuMusicVolume
    -- upvalues: (ref) v_u_31, (copy) m_DataController, (copy) LocalPlayer, (ref) v_u_32
    if v_u_31 and v_u_31.Parent then
        local v132 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100) / 100
        local v133 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
        v_u_31.Volume = (v_u_31:GetAttribute("BaseVolume") or v_u_31.Volume) * v132 * v133 * v_u_32
    end
end
function v_u_1.ShowMenuScene() -- name: ShowMenuScene
    -- upvalues: (copy) LocalPlayer, (ref) v_u_29, (copy) m_CameraController, (copy) ReplicatedStorage, (ref) MenuScenes, (ref) v_u_24, (copy) v_u_51, (copy) v_u_43, (copy) CurrentCamera, (copy) v_u_28, (copy) m_RunServiceController, (copy) v_u_1, (copy) v_u_131, (ref) v_u_31, (copy) m_DataController, (copy) m_Sound, (ref) v_u_30, (copy) PlayerGui, (ref) v_u_32
    local Character_1 = LocalPlayer.Character
    local v136
    if Character_1 and Character_1:IsDescendantOf(workspace) then
        local Humanoid_3 = Character_1:FindFirstChild("Humanoid")
        v136 = Humanoid_3 and Humanoid_3.Health > 0 and true or false
    else
        v136 = false
    end
    if v136 then
        return
    elseif v_u_29 then
        m_CameraController.updateCameraFOV(50)
        m_CameraController.setMouseEnabled(true)
        return
    elseif workspace:FindFirstChild("InspectScene") then
        return
    else
        local m_MenuState_0 = require(ReplicatedStorage.Interface.MenuState)
        if m_MenuState_0.IsInspectActive() then
            return
        elseif m_MenuState_0.IsCaseSceneActive() then
            return
        else
            local v139
            if MenuScenes then
                v139 = MenuScenes
            else
                local Assets_0 = ReplicatedStorage:FindFirstChild("Assets")
                if Assets_0 then
                    MenuScenes = Assets_0:WaitForChild("MenuScenes", 10)
                end
                v139 = MenuScenes
            end
            local v141
            if v139 then
                local v142 = v139:GetChildren()
                if #v142 > 0 then
                    v141 = v142[math.random(1, #v142)]
                else
                    v141 = nil
                end
            else
                v141 = nil
            end
            if v141 then
                local v143 = v141:Clone()
                v143.Parent = workspace
                v_u_24 = v143
                v_u_51(v141.Name)
                local CamPart = v143:FindFirstChild("CamPart")
                if CamPart then
                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = CamPart.CFrame
                    CurrentCamera.Focus = CamPart.CFrame
                    m_CameraController.updateCameraFOV(50)
                    m_CameraController.setMouseEnabled(true)
                    v_u_28:Add(m_RunServiceController.BindToRenderStep("MenuSceneController.CameraUpdate", function()
                        -- upvalues: (ref) v_u_24, (copy) CamPart, (ref) CurrentCamera
                        if v_u_24 and CamPart then
                            CurrentCamera.CFrame = CamPart.CFrame
                            CurrentCamera.Focus = CamPart.CFrame
                        end
                    end), "Disconnect", "CameraUpdate")
                    v_u_28:Add(function()
                        -- upvalues: (ref) v_u_24
                        if v_u_24 then
                            v_u_24:Destroy()
                            v_u_24 = nil
                        end
                    end, true, "MenuSceneCleanup")
                    v_u_29 = true
                    v_u_28:Add(m_RunServiceController.BindToHeartbeat("MenuSceneController.AliveGuard", function()
                        -- upvalues: (ref) LocalPlayer, (ref) v_u_1
                        local Character_2 = LocalPlayer.Character
                        local v146
                        if Character_2 and Character_2:IsDescendantOf(workspace) then
                            local Humanoid_4 = Character_2:FindFirstChild("Humanoid")
                            v146 = Humanoid_4 and Humanoid_4.Health > 0 and true or false
                        else
                            v146 = false
                        end
                        if v146 then
                            v_u_1.HideMenuScene()
                        end
                    end), "Disconnect", "AliveGuard")
                    v_u_131(v143)
                    if not (v_u_31 and v_u_31.IsPlaying) then
                        local v148 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100) / 100
                        local v149 = m_Sound.new("Main Menu")
                        v_u_30 = v149
                        local v_u_150 = v149:play({
                            ["Name"] = "Main Menu Music",
                            ["Parent"] = nil,
                            ["Parent"] = PlayerGui
                        }, v148)
                        v_u_31 = v_u_150
                        if v_u_150 then
                            local v151 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                            local Volume = v_u_150.Volume
                            if v148 > 0 and v151 > 0 then
                                Volume = Volume / (v148 * v151) or Volume
                            end
                            v_u_150:SetAttribute("BaseVolume", Volume)
                            v_u_150:SetAttribute("AmbienceVolumeMultiplier", v148)
                            if v_u_32 ~= 1 then
                                v_u_150.Volume = v_u_150.Volume * v_u_32
                            end
                            v_u_150.Destroying:Once(function()
                                -- upvalues: (ref) v_u_31, (copy) v_u_150
                                if v_u_31 == v_u_150 then
                                    v_u_31 = nil
                                end
                            end)
                        end
                    end
                else
                    warn("[MenuSceneController]: Menu scene missing CamPart")
                    v143:Destroy()
                    v_u_24 = nil
                    v_u_43()
                end
            else
                m_CameraController.setMouseEnabled(true)
                return
            end
        end
    end
end
function v_u_1.HideMenuScene(p153, p154) -- name: HideMenuScene
    -- upvalues: (ref) v_u_29, (copy) ReplicatedStorage, (copy) v_u_28, (copy) v_u_43, (copy) CurrentCamera, (copy) m_CameraController, (copy) m_Constants, (ref) v_u_31, (ref) v_u_30
    if v_u_29 then
        if require(ReplicatedStorage.Interface.MenuState).IsInspectActive() or workspace:FindFirstChild("InspectScene") then
            p154 = true
            p153 = true
        end
        v_u_28:Cleanup()
        if not p154 then
            v_u_43()
        end
        if not p154 then
            CurrentCamera.CameraType = Enum.CameraType.Custom
            m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
        end
        v_u_29 = false
        if not p153 then
            if v_u_31 then
                v_u_31:Stop()
                v_u_31 = nil
            end
            if v_u_30 then
                v_u_30:destroy()
                v_u_30 = nil
            end
        end
    end
end
function v_u_1.IsActive() -- name: IsActive
    -- upvalues: (ref) v_u_29
    return v_u_29
end
function v_u_1.StopMenuMusic() -- name: StopMenuMusic
    -- upvalues: (ref) v_u_31, (ref) v_u_30
    if v_u_31 then
        v_u_31:Stop()
        v_u_31 = nil
    end
    if v_u_30 then
        v_u_30:destroy()
        v_u_30 = nil
    end
end
function v_u_1.IsMusicPlaying() -- name: IsMusicPlaying
    -- upvalues: (ref) v_u_31
    local v155
    if v_u_31 == nil then
        v155 = false
    else
        v155 = v_u_31.IsPlaying
    end
    return v155
end
function v_u_1.SetMusicVolumeMultiplier(p156, p157) -- name: SetMusicVolumeMultiplier
    -- upvalues: (ref) v_u_32, (ref) v_u_31, (ref) v_u_33, (copy) m_DataController, (copy) LocalPlayer, (copy) TweenService
    v_u_32 = p156
    if v_u_31 then
        if v_u_33 then
            v_u_33:Cancel()
            v_u_33 = nil
        end
        local v158 = v_u_31:GetAttribute("BaseVolume") or 0.1
        local v159 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume") or 100) / 100
        local v160 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
        local v161 = v158 * v159 * v160 * v_u_32
        if p157 and p157 > 0 then
            local v162 = TweenService:Create(v_u_31, TweenInfo.new(p157, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Volume"] = v161
            })
            v_u_33 = v162
            v162:Play()
        else
            v_u_31.Volume = v161
        end
    else
        return
    end
end
function v_u_1.ApplyMapLighting() -- name: ApplyMapLighting
    -- upvalues: (copy) v_u_43
    v_u_43()
end
function v_u_1.ApplyMenuSceneLighting() -- name: ApplyMenuSceneLighting
    -- upvalues: (ref) MenuScenes, (copy) ReplicatedStorage, (copy) v_u_51, (copy) Lighting
    local v163
    if MenuScenes then
        v163 = MenuScenes
    else
        local Assets_1 = ReplicatedStorage:FindFirstChild("Assets")
        if Assets_1 then
            MenuScenes = Assets_1:WaitForChild("MenuScenes", 10)
        end
        v163 = MenuScenes
    end
    local v165
    if v163 then
        local v166 = v163:GetChildren()
        if #v166 > 0 then
            v165 = v166[math.random(1, #v166)]
        else
            v165 = nil
        end
    else
        v165 = nil
    end
    if v165 then
        v_u_51(v165.Name)
        Lighting.GlobalShadows = true
    end
end
function v_u_1.GetMenuCharacter() -- name: GetMenuCharacter
    -- upvalues: (ref) v_u_25
    return v_u_25
end
function v_u_1.CreateStandaloneCharacter(p167) -- name: CreateStandaloneCharacter
    -- upvalues: (copy) v_u_22, (copy) Characters, (copy) ReplicatedStorage, (copy) v_u_84
    local v168 = p167 or (math.random(1, 2) == 1 and "CT" or "T")
    local v169 = v_u_22[v168]
    local v170 = Characters:FindFirstChild(v169.Character)
    if not v170 then
        warn((("[MenuSceneController]: Character \"%*\" not found"):format(v169.Character)))
        return nil
    end
    local v171 = v170:Clone()
    v171.Name = "StandaloneCharacter"
    v171.Parent = ReplicatedStorage
    v_u_84(v171, v168, true)
    return v171
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer, (copy) Lighting, (ref) GlobalShadows, (copy) v_u_134, (copy) v_u_65, (copy) v_u_1, (ref) m_EndScreenController, (copy) ReplicatedStorage, (copy) m_Observers, (ref) v_u_25, (ref) v_u_26, (ref) v_u_27, (copy) v_u_112, (copy) v_u_84, (copy) v_u_117, (copy) v_u_28
    m_DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function()
        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (ref) Lighting, (ref) GlobalShadows
        if m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
            if GlobalShadows ~= nil then
                Lighting.GlobalShadows = GlobalShadows
            end
        else
            Lighting.GlobalShadows = false
        end
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Main Menu Ambience Volume", v_u_134)
    m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", v_u_134)
    if v_u_65() then
        v_u_1.ShowMenuScene()
    end
    task.defer(function()
        -- upvalues: (ref) m_EndScreenController, (ref) ReplicatedStorage
        if not m_EndScreenController then
            m_EndScreenController = require(ReplicatedStorage.Controllers.EndScreenController)
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function(p172)
        -- upvalues: (ref) v_u_1, (ref) v_u_65
        v_u_1.StopMenuMusic()
        v_u_1.HideMenuScene()
        local Humanoid_5 = p172:FindFirstChildOfClass("Humanoid")
        if not Humanoid_5 then
            local v174 = tick()
            repeat
                task.wait(0.1)
                Humanoid_5 = p172:FindFirstChildOfClass("Humanoid")
            until Humanoid_5 or tick() - v174 > 5
        end
        if Humanoid_5 then
            Humanoid_5.Died:Connect(function()
                -- upvalues: (ref) v_u_65, (ref) v_u_1
                task.delay(0.1, function()
                    -- upvalues: (ref) v_u_65, (ref) v_u_1
                    if v_u_65() then
                        v_u_1.ShowMenuScene()
                    end
                end)
            end)
        end
    end)
    LocalPlayer.CharacterRemoving:Connect(function()
        -- upvalues: (ref) v_u_65, (ref) v_u_1
        task.delay(0.1, function()
            -- upvalues: (ref) v_u_65, (ref) v_u_1
            if v_u_65() then
                v_u_1.ShowMenuScene()
            end
        end)
    end)
    m_Observers.observeAttribute(LocalPlayer, "IsSpectating", function(p175)
        -- upvalues: (ref) v_u_1, (ref) v_u_65
        if p175 then
            v_u_1.HideMenuScene()
        elseif v_u_65() then
            v_u_1.ShowMenuScene()
        end
        return function()
            -- upvalues: (ref) v_u_65, (ref) v_u_1
            if v_u_65() then
                v_u_1.ShowMenuScene()
            end
        end
    end)
    m_Observers.observeAttribute(LocalPlayer, "Team", function(p176)
        -- upvalues: (ref) v_u_1, (ref) v_u_65
        if p176 == "Counter-Terrorists" or p176 == "Terrorists" then
            v_u_1.HideMenuScene()
        elseif v_u_65() then
            v_u_1.ShowMenuScene()
        end
        return function()
            -- upvalues: (ref) v_u_65, (ref) v_u_1
            task.delay(0.1, function()
                -- upvalues: (ref) v_u_65, (ref) v_u_1
                if v_u_65() then
                    v_u_1.ShowMenuScene()
                end
            end)
        end
    end)
    local function v_u_181() -- name: updateMenuCharacterLoadout
        -- upvalues: (ref) v_u_25, (ref) v_u_26, (ref) v_u_27, (ref) v_u_112, (ref) v_u_84, (ref) v_u_117
        if v_u_25 and v_u_26 then
            if v_u_27 and v_u_27.Parent then
                v_u_27:Destroy()
                v_u_27 = nil
            end
            local RightHand_0 = v_u_25:FindFirstChild("RightHand")
            local WeaponAttachment = RightHand_0 and RightHand_0:FindFirstChild("WeaponAttachment")
            if WeaponAttachment then
                WeaponAttachment:Destroy()
            end
            local CharacterArmor_0 = v_u_25:FindFirstChild("CharacterArmor")
            if CharacterArmor_0 then
                for _, v180 in ipairs(CharacterArmor_0:GetChildren()) do
                    if v180:IsA("BasePart") and v180:FindFirstChild("GloveAttachment") then
                        v180:Destroy()
                    end
                end
            end
            v_u_27 = v_u_112(v_u_25, v_u_26, true)
            v_u_84(v_u_25, v_u_26, true)
            v_u_117(v_u_25)
        end
    end
    local v_u_182 = m_DataController.CreateListener(LocalPlayer, "Loadout", function()
        -- upvalues: (copy) v_u_181
        v_u_181()
    end)
    v_u_28:Add(function()
        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (copy) v_u_182
        m_DataController.RemoveListener(LocalPlayer, "Loadout", v_u_182)
    end, true, "LoadoutListener")
    local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
    local m_SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
    m_GameState.ListenToState(function(_, p185)
        -- upvalues: (ref) LocalPlayer, (copy) m_SpectateController, (ref) v_u_65, (ref) v_u_1
        if p185 == "Game Ending" or p185 == "Map Voting" then
            if LocalPlayer:GetAttribute("IsSpectating") then
                m_SpectateController.Stop(false, true)
            end
            if v_u_65() then
                v_u_1.ShowMenuScene()
            end
        end
    end)
end
function v_u_1.Start() -- name: Start end
return v_u_1
