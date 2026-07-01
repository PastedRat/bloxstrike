-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
local m_CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_InputController = require(ReplicatedStorage.Controllers.InputController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_Viewmodel = require(ReplicatedStorage.Classes.WeaponComponent.Classes.Viewmodel)
local m_GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName)
local m_ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local m_GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local m_Collections = require(ReplicatedStorage.Database.Components.Libraries.Collections)
local m_GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local m_Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local m_Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local m_CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v30 = m_GetUserPlatform()
local v_u_31 = table.find(v30, "Mobile")
if v_u_31 then
    v_u_31 = #v30 <= 1
end
local CurrentCamera = workspace.CurrentCamera
local InspectScenes = nil
local Lighting_0 = ReplicatedStorage.Assets.Lighting
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps
local v_u_36 = nil
local v_u_37 = nil
local v_u_38 = nil
local InspectPivot = nil
local v_u_40 = nil
local v_u_41 = nil
local GlobalShadows = nil
local v_u_43 = nil
local v_u_44 = false
local v_u_45 = nil
local Name = nil
local v_u_47 = nil
local v_u_48 = {}
local v_u_49 = m_Janitor.new()
local v_u_50 = "Weapon"
local v_u_51 = false
local DEFAULT_CAMERA_FOV = m_Constants.DEFAULT_CAMERA_FOV
local v_u_53 = false
local zero = Vector2.zero
local v_u_55 = 40
local v_u_56 = 40
local v_u_57 = 0
local v_u_58 = 0
local v_u_59 = 0
local v_u_60 = 0
local v_u_61 = {
    ["WEAPON_NAME_NO_COLLECTION_POSITION"] = UDim2.fromScale(0.5, 0.075),
    ["WEAPON_NAME_NO_COLLECTION_SIZE"] = UDim2.fromScale(0.317, 0.054),
    ["WEAPON_NAME_COLLECTION_POSITION"] = UDim2.fromScale(0.5, 0.075),
    ["WEAPON_NAME_COLLECTION_SIZE"] = UDim2.fromScale(0.243, 0.054),
    ["RARITY_FRAME_NO_COLLECTION_POSITION"] = UDim2.fromScale(0.5, 0.143),
    ["RARITY_FRAME_COLLECTION_POSITION"] = UDim2.fromScale(0.5, 0.143)
}
local v_u_62 = {}
local v_u_63 = nil
local v_u_64 = nil
local v_u_65 = 1
local function v_u_74() -- name: applyMapLighting
    -- upvalues: (copy) Maps, (ref) GlobalShadows, (copy) Lighting, (copy) m_DataController, (copy) LocalPlayer
    local Map = workspace:FindFirstChild("Map")
    if Map then
        local v67 = Map:GetAttribute("MapName")
        if v67 and typeof(v67) == "string" then
            local v68 = Maps:FindFirstChild(v67)
            if v68 and v68:IsA("ModuleScript") then
                local v69 = require(v68)
                if v69.Lighting then
                    local Properties = v69.Lighting.Properties
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
                    for _, v71 in ipairs(Lighting:GetChildren()) do
                        if v71.Name ~= "Menu" then
                            v71:Destroy()
                        end
                    end
                    local Assets = v69.Lighting.Assets
                    if Assets then
                        for _, v73 in ipairs(Assets:GetChildren()) do
                            v73:Clone().Parent = Lighting
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
local function v_u_82(p75) -- name: applySceneLighting
    -- upvalues: (copy) Lighting_0, (copy) Maps, (ref) GlobalShadows, (copy) Lighting, (copy) m_DataController, (copy) LocalPlayer
    local Menu = Lighting_0:FindFirstChild(p75) or Lighting_0:FindFirstChild("Menu")
    if Menu then
        local v77 = Maps:FindFirstChild(p75)
        if v77 and v77:IsA("ModuleScript") then
            local v78 = require(v77)
            if v78.Lighting and v78.Lighting.Properties then
                local Properties_0 = v78.Lighting.Properties
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
        for _, v80 in ipairs(Lighting:GetChildren()) do
            if v80.Name ~= "Menu" then
                v80:Destroy()
            end
        end
        for _, v81 in ipairs(Menu:GetChildren()) do
            v81:Clone().Parent = Lighting
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
end
local function v_u_87() -- name: getRandomInspectScene
    -- upvalues: (ref) InspectScenes, (copy) ReplicatedStorage
    local v83
    if InspectScenes then
        v83 = InspectScenes
    else
        local Assets_0 = ReplicatedStorage:FindFirstChild("Assets")
        if Assets_0 then
            InspectScenes = Assets_0:WaitForChild("InspectScenes", 10)
        end
        v83 = InspectScenes
    end
    if v83 then
        local v85 = {}
        for _, v86 in ipairs(v83:GetChildren()) do
            if v86:IsA("Model") then
                table.insert(v85, v86)
            end
        end
        if #v85 > 0 then
            return v85[math.random(1, #v85)]
        else
            return nil
        end
    else
        return nil
    end
end
local function v_u_91(p88) -- name: activateInspectSceneFlags
    for _, v89 in ipairs(p88:GetDescendants()) do
        if v89:IsA("Model") then
            local csFlag = v89:FindFirstChild("csFlag")
            if csFlag and (csFlag:IsA("Model") and not v89:HasTag("Flag")) then
                v89:AddTag("Flag")
            end
        end
    end
end
local function v_u_98() -- name: updateWeaponTransform
    -- upvalues: (ref) v_u_45, (ref) v_u_47, (ref) v_u_58, (ref) v_u_57, (ref) InspectPivot
    if v_u_45 and v_u_47 then
        local WeaponPart = v_u_47:FindFirstChild("WeaponPart")
        if WeaponPart then
            local v93 = CFrame.Angles(0, -1.5707963267948966, 0)
            local v94 = v_u_58
            local v95 = v_u_57
            local v96 = CFrame.Angles(0, math.rad(v94), (math.rad(v95)))
            if InspectPivot then
                local v97 = v_u_45:GetPivot():ToObjectSpace(InspectPivot.WorldCFrame)
                v_u_45:PivotTo(WeaponPart.CFrame * v96 * v93 * v97:Inverse())
            else
                v_u_45:PivotTo(WeaponPart.CFrame * v96 * v93)
            end
        else
            return
        end
    else
        return
    end
end
local function v_u_101() -- name: getPinchDistance
    -- upvalues: (ref) v_u_62
    local v99 = {}
    for _, v100 in pairs(v_u_62) do
        table.insert(v99, v100)
    end
    if #v99 >= 2 then
        return (v99[1] - v99[2]).Magnitude
    else
        return nil
    end
end
local function v_u_106() -- name: hideMenuFrames
    -- upvalues: (copy) m_MenuState, (ref) v_u_44, (copy) m_MenuSceneController
    m_MenuState.EnterInspect()
    local v102 = m_MenuState.GetMenuFrame()
    if v102 then
        v_u_44 = m_MenuSceneController.IsActive()
        if v_u_44 then
            m_MenuSceneController.HideMenuScene(true)
            m_MenuSceneController.SetMusicVolumeMultiplier(0.5, 0.5)
        end
        m_MenuState.SetBlurEnabled(false)
        v102.BackgroundTransparency = 1
        local Pattern_0 = v102:FindFirstChild("Pattern")
        if Pattern_0 then
            Pattern_0.Visible = false
        end
        local Top = v102:FindFirstChild("Top")
        if Top then
            Top.Visible = false
        end
        for _, v105 in ipairs(v102:GetChildren()) do
            if v105:IsA("Frame") and v105.Name ~= "Top" then
                if v105.Name == "Inspect" or v105.Name == "InspectFrame" then
                    v105.Visible = true
                else
                    v105.Visible = false
                end
            end
        end
    end
end
local function v_u_118() -- name: initializeInspectButtons
    -- upvalues: (copy) m_MenuState, (copy) m_ActivateButton, (copy) m_CloseButtonRegistry, (copy) v_u_1, (copy) m_DataController, (copy) LocalPlayer, (copy) m_Router
    local v107 = m_MenuState.GetMenuFrame()
    if v107 then
        local InspectFrame = v107:FindFirstChild("Inspect") or v107:FindFirstChild("InspectFrame")
        if InspectFrame then
            local Bottom = InspectFrame:FindFirstChild("Bottom")
            if Bottom then
                local Close = Bottom:FindFirstChild("Close")
                if Close and Close:IsA("GuiButton") then
                    m_ActivateButton(Close)
                    m_CloseButtonRegistry.Add(InspectFrame, Close, function()
                        -- upvalues: (ref) v_u_1
                        v_u_1.HideInspect()
                    end)
                end
                local MobileButtons = InspectFrame:FindFirstChild("MobileButtons")
                if MobileButtons then
                    local Inspect = MobileButtons:FindFirstChild("Inspect")
                    if Inspect and Inspect:IsA("TextButton") then
                        m_ActivateButton(Inspect)
                        Inspect.MouseButton1Click:Connect(function()
                            -- upvalues: (ref) v_u_1
                            v_u_1.PlayInspectAnimation()
                        end)
                        local v113 = m_DataController.Get(LocalPlayer, "MobileButtons")
                        if v113 and v113.Inspect then
                            local Inspect_0 = v113.Inspect
                            if Inspect_0.Position and Inspect_0.Size then
                                Inspect.Position = UDim2.fromScale(Inspect_0.Position.X, Inspect_0.Position.Y)
                                Inspect.Size = UDim2.fromScale(Inspect_0.Size.X, Inspect_0.Size.Y)
                            end
                        end
                    end
                    MobileButtons.Visible = false
                end
                local Charm = Bottom:FindFirstChild("Charm")
                if Charm then
                    local Next = Charm:FindFirstChild("Next")
                    if Next and Next:IsA("GuiButton") then
                        m_ActivateButton(Next)
                        Next.MouseButton1Click:Connect(function()
                            -- upvalues: (ref) v_u_1
                            v_u_1.CycleCharmPosition()
                        end)
                    end
                    local Confirm = Charm:FindFirstChild("Confirm")
                    if Confirm and Confirm:IsA("GuiButton") then
                        m_ActivateButton(Confirm)
                        Confirm.MouseButton1Click:Connect(function()
                            -- upvalues: (ref) m_Router
                            m_Router.broadcastRouter("ConfirmCharmAttachment")
                        end)
                    end
                end
            end
        else
            return
        end
    else
        return
    end
end
local function v_u_124() -- name: updateInspectMobileButtonsVisibility
    -- upvalues: (copy) m_MenuState, (ref) v_u_51, (ref) v_u_50, (copy) v_u_31
    local v119 = m_MenuState.GetMenuFrame()
    if v119 then
        local InspectFrame_0 = v119:FindFirstChild("Inspect") or v119:FindFirstChild("InspectFrame")
        if InspectFrame_0 then
            local MobileButtons_0 = InspectFrame_0:FindFirstChild("MobileButtons")
            if MobileButtons_0 then
                local Inspect_1 = MobileButtons_0:FindFirstChild("Inspect")
                if Inspect_1 then
                    local v123 = v_u_51
                    if v123 then
                        if v_u_50 == "Viewmodel" then
                            v123 = v_u_31
                        else
                            v123 = false
                        end
                    end
                    MobileButtons_0.Visible = v123
                    Inspect_1.Visible = v123
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
local function v_u_129() -- name: updateCharmFrameVisibility
    -- upvalues: (copy) m_MenuState, (copy) m_Router
    local v125 = m_MenuState.GetMenuFrame()
    if v125 then
        local InspectFrame_1 = v125:FindFirstChild("Inspect") or v125:FindFirstChild("InspectFrame")
        if InspectFrame_1 then
            local Bottom_0 = InspectFrame_1:FindFirstChild("Bottom")
            if Bottom_0 then
                local Charm_0 = Bottom_0:FindFirstChild("Charm")
                if Charm_0 then
                    Charm_0.Visible = m_Router.broadcastRouter("HasPendingCharmAttachment") or false
                end
            end
        else
            return
        end
    else
        return
    end
end
local function v_u_133(p130) -- name: supportsViewmodelInspect
    -- upvalues: (copy) m_GetWeaponProperties
    if p130.Type == "Weapon" or (p130.Type == "Melee" or p130.Type == "Glove") then
        return true
    end
    if p130.Name then
        local v131, v132 = pcall(m_GetWeaponProperties, p130.Name)
        if v131 and (v132 and v132.Class) then
            return (v132.Class == "Weapon" or v132.Class == "Melee") and true or v132.Class == "Glove"
        end
    end
    return false
end
local function v_u_138() -- name: setupGloveViewmodelInspectAnimation
    -- upvalues: (ref) v_u_36, (ref) v_u_37, (ref) v_u_38
    if v_u_36 then
        if v_u_36.IsPlaying then
            v_u_36:Stop(0)
        end
        v_u_36:Destroy()
        v_u_36 = nil
    end
    if v_u_37 then
        v_u_37:Destroy()
        v_u_37 = nil
    end
    if v_u_38 and v_u_38.Animation then
        local Animator = v_u_38.Animation.Animator
        if Animator then
            local v_u_135 = Instance.new("Animation")
            v_u_135.AnimationId = "rbxassetid://135926544677482"
            local v136, v137 = pcall(function()
                -- upvalues: (copy) Animator, (copy) v_u_135
                return Animator:LoadAnimation(v_u_135)
            end)
            if v136 and v137 then
                v_u_37 = v_u_135
                v_u_36 = v137
                if v_u_36 then
                    if v_u_38 and v_u_38.Animation then
                        v_u_38.Animation:stopAnimations()
                    end
                    if v_u_36.IsPlaying then
                        v_u_36:Stop(0)
                    end
                    v_u_36.TimePosition = 0
                    v_u_36:Play(0, 1, 1)
                end
            else
                v_u_135:Destroy()
                return
            end
        else
            return
        end
    else
        return
    end
end
local function v_u_143(p139, p140) -- name: resolveInspectViewmodelSkin
    -- upvalues: (copy) m_Skins
    local v141 = (not p140 or (p140 == "" or not p140)) and "Vanilla" or p140
    if m_Skins.GetSkinInformation(p139, v141) then
        return v141
    elseif m_Skins.GetSkinInformation(p139, "Vanilla") then
        return "Vanilla"
    elseif m_Skins.GetSkinInformation(p139, "Default") then
        return "Default"
    else
        local v142 = m_Skins.GetAllSkinsForWeapon(p139)
        if v142 and (v142[1] and v142[1].skin) then
            return v142[1].skin
        else
            return v141
        end
    end
end
local function v_u_146() -- name: resolveGloveProxyWeapon
    -- upvalues: (copy) m_Skins
    for _, v144 in ipairs({
        "FAMAS",
        "AK-47",
        "M4A1-S",
        "Glock-18",
        "USP-S"
    }) do
        local v145 = m_Skins.GetBaseWeaponModel(v144, "Camera")
        if v145 then
            v145:Destroy()
            return v144
        end
    end
    return "FAMAS"
end
local function v_u_153(p147) -- name: clearViewmodelHorizontalOffset
    if p147 and p147.Model then
        local Stats = p147.Model:FindFirstChild("Stats")
        if Stats then
            local Default = Stats:FindFirstChild("Default")
            if Default then
                local Value = Default.Value
                if typeof(Value) == "Vector3" then
                    local v151 = Value.Y
                    local v152 = Value.Z
                    Default.Value = Vector3.new(0.05, v151, v152)
                end
            end
        end
    else
        return
    end
end
local function v_u_170(p154) -- name: setupWeaponInspect
    -- upvalues: (ref) v_u_47, (copy) m_Skins, (ref) v_u_45, (ref) InspectPivot
    if v_u_47 then
        local WeaponPart_0 = v_u_47:FindFirstChild("WeaponPart")
        if WeaponPart_0 then
            local v156 = nil
            local v157 = p154.Type == "Glove"
            local v158 = p154.Type == "Charm"
            local v159 = p154.Type == "Badge"
            if v157 then
                local v160 = m_Skins.GetGloves(p154.Name, p154.Skin, p154.Float)
                if v160 then
                    if v160:IsA("BasePart") then
                        v156 = Instance.new("Model")
                        v156.Name = p154.Name
                        v160.Parent = v156
                        v156.PrimaryPart = v160
                    else
                        v156 = v160
                    end
                end
            elseif v158 then
                v156 = m_Skins.GetCharmModel(p154.Skin, p154.Pattern or 1) or v156
            elseif v159 then
                v156 = m_Skins.GetBadgeModel(p154.Skin) or v156
            else
                v156 = m_Skins.GetCharacterModel(p154.Name, p154.Skin, p154.Float, p154.StatTrack, p154.NameTag, p154.Charm, p154.Stickers)
            end
            if v156 then
                v156.Name = "InspectWeapon"
                v_u_45 = v156
                InspectPivot = v156:FindFirstChild("InspectPivot", true)
                if InspectPivot then
                    warn((("[InspectController]: Found InspectPivot at %*"):format((InspectPivot:GetFullName()))))
                else
                    warn((("[InspectController]: No InspectPivot found for %*"):format(p154.Name)))
                end
                local CharmBase = v156:FindFirstChild("CharmBase", true)
                for _, v162 in ipairs(v156:GetDescendants()) do
                    if v162:IsA("BasePart") then
                        local v163
                        if CharmBase then
                            v163 = v162:IsDescendantOf(CharmBase)
                        else
                            v163 = CharmBase
                        end
                        v162.CastShadow = false
                        if v158 then
                            if v156.PrimaryPart == v162 then
                                v162.CanCollide = false
                                v162.CanQuery = false
                                v162.CanTouch = false
                                v162.Anchored = true
                            else
                                v162.CanCollide = false
                                v162.CanQuery = false
                                v162.CanTouch = false
                                v162.Anchored = false
                            end
                        elseif v163 then
                            v162.Anchored = false
                        else
                            v162.CanCollide = v162:IsA("MeshPart") and true or false
                            v162.CanQuery = false
                            v162.CanTouch = false
                            v162.Anchored = true
                        end
                    end
                end
                if v157 and (p154.Name == "T Glove" or p154.Name == "CT Glove") then
                    local v164 = {}
                    for _, v165 in ipairs(v156:GetChildren()) do
                        if v165:IsA("BasePart") then
                            table.insert(v164, v165)
                        end
                    end
                    if #v164 >= 2 then
                        local v166 = v156:FindFirstChild("RightGlove") or v164[1]
                        for _, v167 in ipairs(v164) do
                            if v167 ~= v166 then
                                v167:Destroy()
                            end
                        end
                    end
                end
                v156.Parent = v_u_47
                local v168 = CFrame.Angles(0, -1.5707963267948966, 0)
                if InspectPivot then
                    local v169 = v156:GetPivot():ToObjectSpace(InspectPivot.WorldCFrame)
                    v156:PivotTo(WeaponPart_0.CFrame * v168 * v169:Inverse())
                else
                    v156:PivotTo(WeaponPart_0.CFrame * v168)
                end
            else
                warn(("[InspectController]: Failed to get model for \"%*\""):format(p154.Name), p154)
                return
            end
        else
            warn("[InspectController]: Inspect scene missing WeaponPart")
            return
        end
    else
        return
    end
end
local function v_u_192(p_u_171) -- name: setupViewmodelInspect
    -- upvalues: (ref) v_u_36, (ref) v_u_37, (ref) v_u_38, (ref) v_u_41, (copy) m_InputController, (copy) LocalPlayer, (copy) m_GetWeaponProperties, (copy) m_MenuSceneController, (copy) HttpService, (copy) m_Router, (ref) v_u_65, (copy) v_u_146, (copy) v_u_143, (copy) m_Viewmodel, (copy) CurrentCamera, (copy) v_u_153, (copy) v_u_138
    if v_u_36 then
        if v_u_36.IsPlaying then
            v_u_36:Stop(0)
        end
        v_u_36:Destroy()
        v_u_36 = nil
    end
    if v_u_37 then
        v_u_37:Destroy()
        v_u_37 = nil
    end
    if v_u_38 then
        v_u_38:destroy()
        v_u_38 = nil
    end
    if v_u_41 then
        v_u_41:Destroy()
        v_u_41 = nil
    end
    m_InputController.enableGroup("Gameplay")
    local v172 = LocalPlayer:GetAttribute("Team") == "Counter-Terrorists" and "CT" or "T"
    local v173
    if p_u_171 then
        if p_u_171.Type == "Glove" then
            v173 = true
        elseif p_u_171.Name then
            local v174, v175 = pcall(m_GetWeaponProperties, p_u_171.Name)
            if v174 and (v175 and v175.Class) then
                v173 = v175.Class == "Glove"
            else
                v173 = false
            end
        else
            v173 = false
        end
    else
        v173 = false
    end
    local v176 = m_MenuSceneController.CreateStandaloneCharacter(v172)
    if v176 then
        if v173 then
            local v177 = {
                ["Name"] = p_u_171.Name,
                ["Skin"] = p_u_171.Skin,
                ["Float"] = p_u_171.Float
            }
            if p_u_171._id and p_u_171._id ~= "" then
                v177.SkinIdentifier = p_u_171._id
            end
            v176:SetAttribute("EquippedGloves", HttpService:JSONEncode(v177))
        end
        v_u_41 = v176
        local Charm_1 = p_u_171.Charm
        if m_Router.broadcastRouter("HasPendingCharmAttachment") and type(Charm_1) == "table" then
            Charm_1 = {
                ["_id"] = Charm_1._id
            }
            local v179 = v_u_65
            Charm_1.Position = tostring(v179)
        end
        local v_u_180 = {
            ["Player"] = LocalPlayer,
            ["Character"] = v176,
            ["StatTrack"] = p_u_171.StatTrack,
            ["Stickers"] = p_u_171.Stickers,
            ["NameTag"] = p_u_171.NameTag,
            ["Float"] = p_u_171.Float,
            ["Charm"] = Charm_1
        }
        local Name_0 = p_u_171.Name
        local Skin = p_u_171.Skin
        local v183 = false
        local v_u_184
        if v173 then
            Name_0 = v_u_146()
            v183 = true
            v_u_184 = "Stock"
        else
            v_u_184 = v_u_143(Name_0, Skin)
        end
        v_u_180.ViewmodelCameraWeapon = Name_0
        v_u_180.ViewmodelHideWeaponGeometry = v183
        local v185, v186 = pcall(function()
            -- upvalues: (ref) m_Viewmodel, (copy) v_u_180, (copy) p_u_171, (copy) v_u_184
            return m_Viewmodel.new(v_u_180, p_u_171.Name, v_u_184)
        end)
        local v187
        if v185 and v186 then
            v187 = nil
        else
            v187 = v186
            v186 = nil
        end
        if v186 then
            v_u_38 = v186
            if v_u_38 then
                v_u_38:equip(v173)
                if v_u_38.Model then
                    if v_u_38.Model.Parent ~= CurrentCamera then
                        v_u_38.Model.Parent = CurrentCamera
                    end
                    if v_u_38.Hidden then
                        v_u_38:unhide()
                    end
                    if v173 then
                        v_u_153(v_u_38)
                    end
                    if v173 then
                        v_u_138()
                    end
                    task.defer(function()
                        -- upvalues: (ref) v_u_38
                        if v_u_38 and v_u_38.Model then
                            for _, v188 in ipairs(v_u_38.Model:GetDescendants()) do
                                if v188:IsA("BasePart") then
                                    v188.CastShadow = false
                                    if v188.Name ~= "HumanoidRootPart" and (v188.Name ~= "ViewmodelLight" and (v188.Name ~= "MuzzlePart" and v188.Name ~= "MuzzlePartL")) and v188.Name ~= "MuzzlePartR" then
                                        local v189 = v188:GetAttribute("HiddenTransparency")
                                        if v189 == nil then
                                            v189 = nil
                                        else
                                            v188:SetAttribute("HiddenTransparency", nil)
                                        end
                                        local v190
                                        if v189 == nil then
                                            v190 = v188:GetAttribute("_CaseScenePrevTransparency")
                                            if v190 == nil then
                                                v190 = v189
                                            else
                                                v188:SetAttribute("_CaseScenePrevTransparency", nil)
                                            end
                                        else
                                            v190 = v189
                                        end
                                        local v191
                                        if v190 == nil then
                                            v191 = v188:GetAttribute("_InspectPrevTransparency")
                                            if v191 == nil then
                                                v191 = v190
                                            else
                                                v188:SetAttribute("_InspectPrevTransparency", nil)
                                            end
                                        else
                                            v191 = v190
                                        end
                                        if v191 == nil then
                                            if v188.Transparency >= 1 and (v188.Name == "Right Arm" or v188.Name == "Left Arm") then
                                                v188.Transparency = 0
                                            end
                                        else
                                            v188.Transparency = v191
                                        end
                                    end
                                elseif v188:IsA("SurfaceGui") then
                                    if v188:GetAttribute("_InspectPrevSurfaceGuiEnabled") then
                                        v188.Enabled = true
                                        v188:SetAttribute("_InspectPrevSurfaceGuiEnabled", nil)
                                    end
                                    if v188:GetAttribute("_CaseScenePrevSurfaceGuiEnabled") then
                                        v188.Enabled = true
                                        v188:SetAttribute("_CaseScenePrevSurfaceGuiEnabled", nil)
                                    end
                                    if not v188.Enabled then
                                        v188.Enabled = true
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        else
            warn(("[InspectController]: Failed to create viewmodel (%* | %*)"):format(Name_0, v_u_184), v187)
            if v_u_36 then
                if v_u_36.IsPlaying then
                    v_u_36:Stop(0)
                end
                v_u_36:Destroy()
                v_u_36 = nil
            end
            if v_u_37 then
                v_u_37:Destroy()
                v_u_37 = nil
            end
            if v_u_38 then
                v_u_38:destroy()
                v_u_38 = nil
            end
            if v_u_41 then
                v_u_41:Destroy()
                v_u_41 = nil
            end
            m_InputController.enableGroup("Gameplay")
        end
    else
        warn("[InspectController]: Failed to create standalone character for viewmodel")
        return
    end
end
local function v_u_199(p193) -- name: setInspectMode
    -- upvalues: (ref) v_u_40, (copy) m_GetWeaponProperties, (ref) v_u_50, (ref) v_u_45, (ref) InspectPivot, (ref) v_u_36, (ref) v_u_37, (ref) v_u_38, (ref) v_u_41, (copy) m_InputController, (copy) v_u_124, (copy) v_u_170, (ref) v_u_56, (copy) v_u_192, (copy) DEFAULT_CAMERA_FOV
    local v194 = v_u_40
    if v194 then
        local v195
        if v194 then
            if v194.Type == "Glove" then
                v195 = true
            elseif v194.Name then
                local v196, v197 = pcall(m_GetWeaponProperties, v194.Name)
                if v196 and (v197 and v197.Class) then
                    v195 = v197.Class == "Glove"
                else
                    v195 = false
                end
            else
                v195 = false
            end
        else
            v195 = false
        end
        local v198 = v195 and p193 == "Weapon" and "Viewmodel" or p193
        if v_u_50 == v198 then
            return
        else
            if v_u_50 == "Weapon" then
                if v_u_45 then
                    v_u_45:Destroy()
                    v_u_45 = nil
                end
                InspectPivot = nil
            elseif v_u_50 == "Viewmodel" then
                if v_u_36 then
                    if v_u_36.IsPlaying then
                        v_u_36:Stop(0)
                    end
                    v_u_36:Destroy()
                    v_u_36 = nil
                end
                if v_u_37 then
                    v_u_37:Destroy()
                    v_u_37 = nil
                end
                if v_u_38 then
                    v_u_38:destroy()
                    v_u_38 = nil
                end
                if v_u_41 then
                    v_u_41:Destroy()
                    v_u_41 = nil
                end
                m_InputController.enableGroup("Gameplay")
            end
            v_u_50 = v198
            v_u_124()
            if v198 == "Weapon" then
                v_u_170(v194)
                v_u_56 = 40
                m_InputController.enableGroup("Gameplay")
            elseif v198 == "Viewmodel" then
                m_InputController.disableGroup("Gameplay")
                v_u_192(v194)
                v_u_56 = DEFAULT_CAMERA_FOV
            end
        end
    else
        return
    end
end
local function v_u_213(p200, p201, p202) -- name: updateButtonVisuals
    -- upvalues: (ref) v_u_50, (copy) TweenService
    local HoverFrame = p201:FindFirstChild("HoverFrame")
    local SelectFrame = p201:FindFirstChild("SelectFrame")
    local ImageLabel = p201:FindFirstChild("ImageLabel")
    local v206
    if v_u_50 == p200 then
        v206 = p200 ~= "Info"
    else
        v206 = false
    end
    if v206 then
        local v207 = {
            ["BackgroundTransparency"] = 1
        }
        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v207):Play()
        end
        local v208 = {
            ["BackgroundTransparency"] = 0,
            ["BackgroundColor3"] = nil,
            ["BackgroundColor3"] = Color3.fromRGB(95, 95, 95)
        }
        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), v208):Play()
        end
        if ImageLabel then
            local v209 = {
                ["ImageColor3"] = Color3.fromRGB(210, 210, 210)
            }
            if ImageLabel then
                TweenService:Create(ImageLabel, TweenInfo.new(0.2), v209):Play()
                return
            end
        end
    else
        local v210 = {
            ["BackgroundTransparency"] = 1
        }
        if SelectFrame then
            TweenService:Create(SelectFrame, TweenInfo.new(0.2), v210):Play()
        end
        if ImageLabel then
            local v211 = {
                ["ImageColor3"] = Color3.fromRGB(255, 255, 255)
            }
            if ImageLabel then
                TweenService:Create(ImageLabel, TweenInfo.new(0.2), v211):Play()
            end
        end
        local v212 = {
            ["BackgroundTransparency"] = p202 and 0 or 1
        }
        if HoverFrame then
            TweenService:Create(HoverFrame, TweenInfo.new(0.2), v212):Play()
        end
    end
end
local function v_u_218(p214, p215) -- name: refreshAllButtons
    -- upvalues: (copy) v_u_213
    for v216, v217 in pairs(p214) do
        if v217 and v217:IsA("GuiButton") then
            v_u_213(v216, v217, v216 == p215)
        end
    end
end
local function v_u_229(p219, p220) -- name: scaleInfoFrameToFit
    -- upvalues: (copy) CurrentCamera, (copy) TextService
    local v221 = CurrentCamera.ViewportSize.Y * 0.025
    local v222 = math.floor(v221)
    local v223 = math.min(v222, 32)
    local v224 = math.max(8, v223)
    local Gotham = Enum.Font.Gotham
    local v226 = 0
    for _, v227 in ipairs(p220) do
        if v227 and (v227:IsA("TextLabel") and v227.Text ~= "") then
            v227.TextScaled = false
            local v228 = TextService:GetTextSize(v227.Text:gsub("<[^>]*>", ""), v224, Gotham, Vector2.new((1 / 0), (1 / 0)))
            if v226 < v228.X then
                v226 = v228.X
            end
            v227.TextSize = v224
            v227.TextWrapped = false
        end
    end
    if v226 > 0 then
        p219.Size = UDim2.new(0.05, v226, p219.Size.Y.Scale, p219.Size.Y.Offset)
    end
end
local function v_u_255(p230, p231, p232) -- name: showInfoFrame
    -- upvalues: (copy) m_Skins, (copy) v_u_229
    local Information = p230:FindFirstChild("Information")
    if Information then
        if p232 then
            local v234 = Information.Parent.AbsolutePosition.X
            local v235 = p232.AbsolutePosition.X + p232.AbsoluteSize.X / 2 - v234
            Information.Position = UDim2.new(0, v235 + Information.AbsoluteSize.X / 2, Information.Position.Y.Scale, Information.Position.Y.Offset)
        end
        Information.Visible = true
        local v236 = m_Skins.GetSkinInformation(p231.Name, p231.Skin)
        local v237
        if v236 then
            local _, v238 = m_Skins.GetWearNameForFloat(v236, p231.Float or 0)
            v237 = v238 or "Mint Condition"
        else
            v237 = "Mint Condition"
        end
        local v239 = p231.Type == "Charm"
        local Exterior = Information:FindFirstChild("Exterior")
        if Exterior then
            if v239 then
                Exterior.Visible = false
            else
                Exterior.Visible = true
                Exterior.RichText = true
                Exterior.Text = ("<b><font color=\"rgb(175,175,175)\">Exterior</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(v237)
            end
        end
        local Tradeable = Information:FindFirstChild("Tradeable")
        if Tradeable then
            Tradeable.RichText = true
            Tradeable.Text = ("<b><font color=\"rgb(175,175,175)\">Tradeable</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(p231.IsTradeable and "Yes" or "No")
        end
        local Serial = Information:FindFirstChild("Serial")
        if Serial then
            Serial.RichText = true
            local Serial_0 = p231.Serial
            Serial.Text = ("<b><font color=\"rgb(175,175,175)\">Serial</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(typeof(Serial_0) ~= "number" and "N/A" or ("#%*"):format((tostring(Serial_0):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))))
        end
        local Pattern = Information:FindFirstChild("Pattern")
        if Pattern then
            if p231.Type == "Charm" then
                Pattern.Visible = true
                Pattern.RichText = true
                local v245 = p231.Pattern or 0
                Pattern.Text = ("<b><font color=\"rgb(175,175,175)\">Pattern</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format((tostring(v245)))
            elseif p231.Skin:find("PATTERN") then
                local Skin_0 = p231.Skin
                local _, v247 = table.unpack(Skin_0:split("_PATTERN_"))
                Pattern.Text = ("<b><font color=\"rgb(175,175,175)\">Pattern</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format(v247)
                Pattern.Visible = true
            else
                Pattern.Visible = false
            end
        end
        local Float = Information:FindFirstChild("Float")
        if Float then
            if v239 then
                Float.Visible = false
            else
                Float.Visible = true
                Float.RichText = true
                Float.Text = ("<b><font color=\"rgb(175,175,175)\">Float</font></b>: <font color=\"rgb(255,255,255)\">%*</font>"):format((string.format("%.14f", p231.Float or 0)))
            end
        end
        task.defer(function()
            -- upvalues: (copy) Exterior, (copy) Tradeable, (copy) Serial, (copy) Pattern, (copy) Float, (ref) v_u_229, (copy) Information
            local v249 = {}
            if Exterior and Exterior.Visible then
                local v250 = Exterior
                table.insert(v249, v250)
            end
            if Tradeable then
                local v251 = Tradeable
                table.insert(v249, v251)
            end
            if Serial then
                local v252 = Serial
                table.insert(v249, v252)
            end
            if Pattern and Pattern.Visible then
                local v253 = Pattern
                table.insert(v249, v253)
            end
            if Float and Float.Visible then
                local v254 = Float
                table.insert(v249, v254)
            end
            v_u_229(Information, v249)
        end)
    end
end
local function v_u_260() -- name: shouldHideInfoButton
    -- upvalues: (copy) m_MenuState, (copy) PlayerGui
    if m_MenuState.IsCaseSceneActive() then
        return true
    end
    if m_MenuState.GetScreenBeforeCaseScene() == "Store" then
        return true
    end
    if m_MenuState.GetCurrentScreen() == "Store" then
        return true
    end
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    if MainGui then
        local Menu_0 = MainGui:FindFirstChild("Menu")
        local Store = Menu_0 and Menu_0:FindFirstChild("Store")
        if Store then
            local CaseContent = Store:FindFirstChild("CaseContent")
            if CaseContent and CaseContent:GetAttribute("WasVisibleBeforeInspect") == true then
                return true
            end
        end
    end
    return false
end
local function v_u_266(p_u_261, p_u_262, p_u_263, p_u_264) -- name: setupButtonEvents
    -- upvalues: (copy) v_u_49, (copy) v_u_213, (ref) v_u_40, (copy) v_u_260, (copy) v_u_255, (ref) v_u_50, (copy) v_u_199, (copy) v_u_218
    v_u_49:Add(p_u_261.MouseEnter:Connect(function()
        -- upvalues: (ref) v_u_213, (copy) p_u_262, (copy) p_u_261, (copy) p_u_264, (ref) v_u_40, (ref) v_u_260, (ref) v_u_255
        v_u_213(p_u_262, p_u_261, true)
        if p_u_262 == "Info" and (p_u_264 and v_u_40) and (not v_u_260() and v_u_40.Type ~= "Badge") then
            v_u_255(p_u_264, v_u_40, p_u_261)
        end
    end), "Disconnect", "InspectButton_Enter_" .. p_u_262)
    v_u_49:Add(p_u_261.MouseLeave:Connect(function()
        -- upvalues: (ref) v_u_213, (copy) p_u_262, (copy) p_u_261, (copy) p_u_264
        v_u_213(p_u_262, p_u_261, false)
        local v265 = p_u_262 == "Info" and (p_u_264 and p_u_264:FindFirstChild("Information"))
        if v265 then
            v265.Visible = false
        end
    end), "Disconnect", "InspectButton_Leave_" .. p_u_262)
    if p_u_262 == "Info" then
        v_u_49:Add(p_u_261.Activated:Connect(function()
            -- upvalues: (copy) p_u_264, (ref) v_u_40, (ref) v_u_260, (ref) v_u_255, (copy) p_u_261
            if p_u_264 and (v_u_40 and (not v_u_260() and v_u_40.Type ~= "Badge")) then
                v_u_255(p_u_264, v_u_40, p_u_261)
            end
        end), "Disconnect", "InspectButton_Activated_Info")
    else
        v_u_49:Add(p_u_261.MouseButton1Click:Connect(function()
            -- upvalues: (ref) v_u_50, (copy) p_u_262, (ref) v_u_199, (ref) v_u_218, (copy) p_u_263
            if v_u_50 ~= p_u_262 then
                v_u_199(p_u_262)
                v_u_218(p_u_263, p_u_262)
            end
        end), "Disconnect", "InspectButton_Click_" .. p_u_262)
    end
end
local function v_u_281(p267, p268) -- name: setupInspectButtons
    -- upvalues: (copy) v_u_133, (copy) m_GetWeaponProperties, (copy) v_u_260, (copy) v_u_213, (copy) v_u_266
    local v269 = p267:FindFirstChild("Bottom")
    if v269 then
        v269 = v269:FindFirstChild("Frame")
    end
    if v269 then
        local v270 = v_u_133(p268)
        local v271
        if p268 then
            if p268.Type == "Glove" then
                v271 = true
            elseif p268.Name then
                local v272, v273 = pcall(m_GetWeaponProperties, p268.Name)
                if v272 and (v273 and v273.Class) then
                    v271 = v273.Class == "Glove"
                else
                    v271 = false
                end
            else
                v271 = false
            end
        else
            v271 = false
        end
        local v274 = {
            ["Info"] = v269:FindFirstChild("Info"),
            ["Viewmodel"] = v269:FindFirstChild("Viewmodel"),
            ["Weapon"] = v269:FindFirstChild("Weapon")
        }
        local v275 = v_u_260()
        local v276 = p268.Type == "Badge"
        for v277, v278 in pairs(v274) do
            if v278 and v278:IsA("GuiButton") then
                if v277 == "Info" then
                    local v279 = not v275
                    if v279 then
                        v279 = not v276
                    end
                    v278.Visible = v279
                elseif v277 == "Weapon" then
                    local v280
                    if v270 then
                        v280 = not v271
                    else
                        v280 = v270
                    end
                    v278.Visible = v280
                else
                    v278.Visible = v270
                end
                v_u_213(v277, v278, false)
                v_u_266(v278, v277, v274, p267)
            end
        end
    end
end
local function v_u_290(p282, p283) -- name: updateCollectionData
    -- upvalues: (copy) m_Collections, (copy) v_u_61
    if p283 then
        p283 = p283.collection
    end
    local v284
    if p283 then
        v284 = m_Collections.GetCollectionByName(p283)
    else
        v284 = p283
    end
    local v285 = v284 ~= nil
    local CollectionName = p282:FindFirstChild("CollectionName")
    if CollectionName and CollectionName:IsA("TextLabel") then
        CollectionName.Visible = v285
        CollectionName.Text = p283 or ""
    end
    local CollectionIcon = p282:FindFirstChild("CollectionIcon")
    if CollectionIcon and CollectionIcon:IsA("ImageLabel") then
        CollectionIcon.Image = v284 and v284.imageAssetId or ""
        CollectionIcon.Visible = v285
    end
    local WeaponName = p282:FindFirstChild("WeaponName")
    if WeaponName and WeaponName:IsA("TextLabel") then
        WeaponName.Position = v285 and v_u_61.WEAPON_NAME_COLLECTION_POSITION or v_u_61.WEAPON_NAME_NO_COLLECTION_POSITION
        WeaponName.Size = v285 and v_u_61.WEAPON_NAME_COLLECTION_SIZE or v_u_61.WEAPON_NAME_NO_COLLECTION_SIZE
        WeaponName.TextXAlignment = Enum.TextXAlignment.Center
    end
    local Rarity = p282:FindFirstChild("Rarity")
    if Rarity and Rarity:IsA("Frame") then
        Rarity.Position = v285 and v_u_61.RARITY_FRAME_COLLECTION_POSITION or v_u_61.RARITY_FRAME_NO_COLLECTION_POSITION
    end
end
local function v_u_313(p291) -- name: updateInspectFrameUI
    -- upvalues: (copy) PlayerGui, (copy) v_u_281, (copy) v_u_260, (copy) m_Skins, (copy) m_GetSkinDisplayName, (copy) v_u_290, (copy) m_Rarities
    local MainGui_0 = PlayerGui:FindFirstChild("MainGui")
    if MainGui_0 then
        local Menu_1 = MainGui_0:FindFirstChild("Menu")
        if Menu_1 then
            local InspectFrame_2 = Menu_1:FindFirstChild("Inspect") or Menu_1:FindFirstChild("InspectFrame")
            if InspectFrame_2 then
                v_u_281(InspectFrame_2, p291)
                local Information_0 = v_u_260() and InspectFrame_2:FindFirstChild("Information")
                if Information_0 then
                    Information_0.Visible = false
                end
                local v296 = m_Skins.GetSkinInformation(p291.Name, p291.Skin)
                local WeaponName_0 = InspectFrame_2:FindFirstChild("WeaponName")
                if WeaponName_0 and WeaponName_0:IsA("TextLabel") then
                    local v298 = m_GetSkinDisplayName(p291.Skin)
                    local v299 = v296 and v296.type == "Melee" and "\226\152\133 " or ""
                    local v300 = " | " .. v298
                    local v301 = v300 and v300 == "Vanilla" and "" or v300
                    WeaponName_0.Text = v299 .. (p291.Name:find("Zeus") and "Taser" or p291.Name) .. v301
                end
                if v296 then
                    v_u_290(InspectFrame_2, v296)
                    local Rarity_0 = InspectFrame_2:FindFirstChild("Rarity")
                    local v303 = Rarity_0 and (Rarity_0:IsA("Frame") and v296.rarity) and m_Rarities[v296.rarity]
                    if v303 then
                        Rarity_0.BackgroundColor3 = v303.Color
                    end
                end
                local Description = InspectFrame_2:FindFirstChild("Description")
                if Description then
                    local StatTrack = p291.StatTrack
                    local v306 = typeof(StatTrack) == "number" and true or p291.StatTrack == true
                    local Top_0 = Description:FindFirstChild("Top")
                    if Top_0 then
                        Top_0.Visible = v306
                    end
                    local Middle = Description:FindFirstChild("Middle")
                    if Middle then
                        Middle.Visible = v306
                        local KillTrack = v306 and Middle:FindFirstChild("KillTrack")
                        if KillTrack then
                            local StatTrack_0 = p291.StatTrack
                            KillTrack.Text = ("KillTrack\226\132\162 Confirmed Kills: %*"):format(typeof(StatTrack_0) ~= "number" and 0 or p291.StatTrack)
                        end
                    end
                    local Bottom_1 = Description:FindFirstChild("Bottom")
                    if Bottom_1 then
                        local Description_0 = Bottom_1:FindFirstChild("Description")
                        if Description_0 and v296 then
                            Description_0.Text = v296.description or ""
                        end
                    end
                end
            end
        else
            return
        end
    else
        return
    end
end
local function v_u_317() -- name: hideViewmodels
    -- upvalues: (ref) v_u_48, (copy) CurrentCamera, (ref) v_u_38
    v_u_48 = {}
    for _, v314 in ipairs(CurrentCamera:GetChildren()) do
        if v314:IsA("Model") and (v314.Name ~= "InspectScene" and (not v_u_38 or v_u_38.Model ~= v314)) then
            for _, v315 in ipairs(v314:GetDescendants()) do
                if v315:IsA("BasePart") then
                    if v315.Transparency < 1 then
                        v315:SetAttribute("_InspectPrevTransparency", v315.Transparency)
                        v315.Transparency = 1
                    end
                elseif v315:IsA("SurfaceGui") then
                    if v315.Enabled then
                        v315:SetAttribute("_InspectPrevSurfaceGuiEnabled", true)
                        v315.Enabled = false
                    end
                elseif v315:IsA("Texture") and v315.Transparency < 1 then
                    v315:SetAttribute("_InspectPrevTransparency", v315.Transparency)
                    v315.Transparency = 1
                end
            end
            local v316 = v_u_48
            table.insert(v316, v314)
        end
    end
end
local function v_u_322() -- name: showViewmodels
    -- upvalues: (ref) v_u_48
    for _, v318 in ipairs(v_u_48) do
        if v318 and v318.Parent then
            for _, v319 in ipairs(v318:GetDescendants()) do
                if v319:IsA("BasePart") then
                    local v320 = v319:GetAttribute("_InspectPrevTransparency")
                    if v320 ~= nil then
                        v319.Transparency = v320
                        v319:SetAttribute("_InspectPrevTransparency", nil)
                    end
                elseif v319:IsA("SurfaceGui") then
                    if v319:GetAttribute("_InspectPrevSurfaceGuiEnabled") ~= nil then
                        v319.Enabled = true
                        v319:SetAttribute("_InspectPrevSurfaceGuiEnabled", nil)
                    end
                elseif v319:IsA("Texture") then
                    local v321 = v319:GetAttribute("_InspectPrevTransparency")
                    if v321 == nil then
                        v319.Transparency = 0.3
                    else
                        v319.Transparency = v321
                        v319:SetAttribute("_InspectPrevTransparency", nil)
                    end
                end
            end
        end
    end
    v_u_48 = {}
end
local function v_u_337() -- name: restoreMenuFrames
    -- upvalues: (copy) m_MenuState, (ref) v_u_44, (copy) m_MenuSceneController
    local v323 = m_MenuState.GetMenuFrame()
    if v323 and v323.Visible then
        local InspectFrame_3 = v323:FindFirstChild("Inspect") or v323:FindFirstChild("InspectFrame")
        if InspectFrame_3 and InspectFrame_3:IsA("GuiObject") then
            local MobileButtons_1 = InspectFrame_3:FindFirstChild("MobileButtons")
            InspectFrame_3.Visible = false
            if MobileButtons_1 then
                MobileButtons_1.Visible = false
            end
        end
        local v326 = m_MenuState.GetScreenBeforeInspect()
        local v327 = v_u_44
        v_u_44 = false
        m_MenuState.ExitInspect()
        if v327 then
            m_MenuSceneController.ShowMenuScene()
            m_MenuSceneController.SetMusicVolumeMultiplier(1, 0.5)
        end
        local Top_1 = v323:FindFirstChild("Top")
        if Top_1 then
            Top_1.Visible = true
        end
        if v326 then
            local v329 = v323:FindFirstChild(v326)
            if v329 then
                for _, v330 in ipairs(v323:GetChildren()) do
                    if v330:IsA("Frame") and (v330.Name ~= "Top" and (v330.Name ~= v326 and (v330.Name ~= "Inspect" and v330.Name ~= "InspectFrame"))) then
                        v330.Visible = false
                    end
                end
                v329.Visible = true
                if m_MenuState.IsCaseSceneActive() and v326 == "Store" then
                    m_MenuState.SetBlurEnabled(false)
                    v323.BackgroundTransparency = 1
                    local Pattern_1 = v323:FindFirstChild("Pattern")
                    if Pattern_1 then
                        Pattern_1.Visible = false
                        return
                    end
                else
                    local v332
                    if v326 == "Dashboard" then
                        v332 = false
                    else
                        v332 = v326 ~= "Play"
                    end
                    m_MenuState.SetBlurEnabled(v332)
                    v323.BackgroundTransparency = v332 and 0.15 or 1
                    local Pattern_2 = v323:FindFirstChild("Pattern")
                    if Pattern_2 then
                        Pattern_2.Visible = not v332
                        return
                    end
                end
            end
        else
            for _, v334 in ipairs(v323:GetChildren()) do
                if v334:IsA("Frame") and (v334.Name ~= "Top" and (v334.Name ~= "Dashboard" and (v334.Name ~= "Inspect" and v334.Name ~= "InspectFrame"))) then
                    v334.Visible = false
                end
            end
            local Dashboard = v323:FindFirstChild("Dashboard")
            if Dashboard then
                Dashboard.Visible = true
            end
            m_MenuState.SetBlurEnabled(false)
            v323.BackgroundTransparency = 1
            local Pattern_3 = v323:FindFirstChild("Pattern")
            if Pattern_3 then
                Pattern_3.Visible = true
            end
        end
    else
        v_u_44 = false
        m_MenuState.ExitInspect()
    end
end
function v_u_1.ShowInspect(p338) -- name: ShowInspect
    -- upvalues: (ref) v_u_51, (copy) v_u_1, (copy) m_Router, (ref) v_u_64, (ref) v_u_65, (ref) v_u_40, (ref) v_u_50, (copy) m_GetWeaponProperties, (copy) v_u_106, (copy) v_u_317, (copy) v_u_129, (copy) v_u_313, (ref) v_u_43, (copy) v_u_337, (ref) v_u_47, (copy) v_u_91, (ref) Name, (copy) v_u_82, (copy) ReplicatedStorage, (copy) v_u_74, (copy) m_InputController, (copy) v_u_192, (copy) v_u_170, (ref) v_u_57, (ref) v_u_58, (ref) v_u_59, (ref) v_u_60, (ref) v_u_55, (copy) DEFAULT_CAMERA_FOV, (ref) v_u_56, (copy) CurrentCamera, (copy) m_CameraController, (copy) v_u_49, (copy) m_RunServiceController, (copy) UserInputService, (ref) v_u_38, (copy) v_u_98, (ref) v_u_53, (ref) zero, (copy) LocalPlayer, (ref) v_u_62, (ref) v_u_63, (copy) v_u_101, (ref) v_u_45, (ref) InspectPivot, (copy) v_u_124
    if v_u_51 then
        v_u_1.HideInspect()
    end
    if m_Router.broadcastRouter("HasPendingCharmAttachment") then
        v_u_64 = p338
        v_u_65 = 1
    else
        v_u_64 = nil
    end
    v_u_40 = p338
    local v339
    if p338 then
        if p338.Type == "Glove" then
            v339 = true
        elseif p338.Name then
            local v340, v341 = pcall(m_GetWeaponProperties, p338.Name)
            if v340 and (v341 and v341.Class) then
                v339 = v341.Class == "Glove"
            else
                v339 = false
            end
        else
            v339 = false
        end
    else
        v339 = false
    end
    v_u_50 = v339 and "Viewmodel" or "Weapon"
    v_u_106()
    v_u_317()
    v_u_129()
    v_u_313(p338)
    if v_u_43 then
        if v_u_43 and v_u_43.Parent ~= workspace then
            v_u_43.Parent = workspace
        end
        v_u_47 = v_u_43
        v_u_91(v_u_47)
        if Name then
            v_u_82(Name)
        end
        local v_u_342
        if v_u_47 then
            v_u_342 = v_u_47:FindFirstChild("CamPart")
        else
            v_u_342 = nil
        end
        if v_u_342 then
            local v343
            if v_u_47 then
                v343 = v_u_47:FindFirstChild("WeaponPart")
            else
                v343 = nil
            end
            if v343 then
                if v_u_50 == "Viewmodel" then
                    m_InputController.disableGroup("Gameplay")
                    v_u_192(p338)
                else
                    m_InputController.enableGroup("Gameplay")
                    v_u_170(p338)
                end
                v_u_57 = 0
                v_u_58 = 0
                v_u_59 = 0
                v_u_60 = 0
                if v_u_50 == "Viewmodel" then
                    v_u_55 = DEFAULT_CAMERA_FOV
                    v_u_56 = DEFAULT_CAMERA_FOV
                else
                    v_u_55 = 40
                    v_u_56 = 40
                end
                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                CurrentCamera.CFrame = v_u_342.CFrame
                CurrentCamera.Focus = v_u_342.CFrame
                m_CameraController.updateCameraFOV(v_u_50 ~= "Viewmodel" and 40 or DEFAULT_CAMERA_FOV)
                m_CameraController.setForceLockOverride("Inspect", true)
                v_u_49:Add(m_RunServiceController.BindToRenderStep("InspectController.CameraUpdate", function(p344)
                    -- upvalues: (ref) v_u_55, (ref) v_u_56, (ref) v_u_47, (copy) v_u_342, (ref) CurrentCamera, (ref) m_CameraController, (ref) v_u_50, (ref) UserInputService, (ref) v_u_60, (ref) v_u_59, (ref) v_u_38, (ref) v_u_57, (ref) v_u_58, (ref) v_u_98
                    local v345 = p344 * 8
                    local v346 = math.min(1, v345)
                    v_u_55 = v_u_55 + (v_u_56 - v_u_55) * v346
                    if v_u_47 and v_u_342 then
                        CurrentCamera.CameraType = Enum.CameraType.Scriptable
                        CurrentCamera.CFrame = v_u_342.CFrame
                        CurrentCamera.Focus = v_u_342.CFrame
                        CurrentCamera.FieldOfView = m_CameraController.clampFOV(v_u_55)
                    end
                    if v_u_50 == "Weapon" and UserInputService.GamepadEnabled then
                        local v347 = UserInputService:GetLastInputType()
                        local v348 = UserInputService:GetGamepadState((v347 == Enum.UserInputType.Gamepad1 or (v347 == Enum.UserInputType.Gamepad2 or (v347 == Enum.UserInputType.Gamepad3 or v347 == Enum.UserInputType.Gamepad4))) and v347 and v347 or Enum.UserInputType.Gamepad1)
                        if v348 then
                            for _, v349 in pairs(v348) do
                                if v349.KeyCode == Enum.KeyCode.Thumbstick2 then
                                    local v350 = Vector2.new(v349.Position.X, v349.Position.Y)
                                    if v350.Magnitude > 0.1 then
                                        local v351 = Vector2.new(v350.X * 0.5 * 60 * p344 * 4.75, v350.Y * 0.5 * 60 * p344 * 4.75)
                                        v_u_60 = v_u_60 + v351.X * 0.5
                                        v_u_59 = v_u_59 + v351.Y * 0.5
                                        local v352 = v_u_59
                                        v_u_59 = math.clamp(v352, -80, 80)
                                    end
                                elseif v349.KeyCode == Enum.KeyCode.ButtonR2 then
                                    if v349.Position.Z > 0.1 then
                                        local v353 = -v349.Position.Z * 2 * 30 * p344 * 0.55
                                        if v_u_50 ~= "Viewmodel" then
                                            local v354 = v_u_56 - v353 * 2
                                            v_u_56 = math.clamp(v354, 20, 70)
                                        end
                                    end
                                elseif v349.KeyCode == Enum.KeyCode.ButtonL2 and v349.Position.Z > 0.1 then
                                    local v355 = v349.Position.Z * 2 * 30 * p344 * 0.55
                                    if v_u_50 ~= "Viewmodel" then
                                        local v356 = v_u_56 - v355 * 2
                                        v_u_56 = math.clamp(v356, 20, 70)
                                    end
                                end
                            end
                        end
                    end
                    if v_u_50 == "Viewmodel" and v_u_38 then
                        v_u_38:render(p344)
                    elseif v_u_50 == "Weapon" then
                        local v357 = p344 * 10
                        local v358 = math.min(1, v357)
                        v_u_57 = v_u_57 + (v_u_59 - v_u_57) * v358
                        v_u_58 = v_u_58 + (v_u_60 - v_u_58) * v358
                        v_u_98()
                    end
                end), "Disconnect", "CameraUpdate")
                v_u_49:Add(UserInputService.InputBegan:Connect(function(p359, _)
                    -- upvalues: (ref) v_u_53, (ref) zero, (ref) m_InputController, (ref) LocalPlayer, (ref) v_u_1, (ref) v_u_62, (ref) v_u_63, (ref) v_u_101
                    if p359.UserInputType == Enum.UserInputType.MouseButton1 then
                        v_u_53 = true
                        zero = Vector2.new(p359.Position.X, p359.Position.Y)
                    end
                    local v360 = m_InputController.getActionKeybinds("Inspect")
                    if table.find(v360, p359.KeyCode) then
                        if LocalPlayer:GetAttribute("IsPlayerChatting") then
                            return
                        end
                        v_u_1.PlayInspectAnimation()
                    end
                    if p359.UserInputType == Enum.UserInputType.Touch then
                        v_u_62[p359] = Vector2.new(p359.Position.X, p359.Position.Y)
                        local v361 = 0
                        for _ in pairs(v_u_62) do
                            v361 = v361 + 1
                        end
                        if v361 == 1 then
                            v_u_53 = true
                            zero = Vector2.new(p359.Position.X, p359.Position.Y)
                        end
                        v_u_63 = v_u_101()
                    end
                end), "Disconnect", "InputBegan")
                v_u_49:Add(UserInputService.InputChanged:Connect(function(p362, _)
                    -- upvalues: (ref) v_u_53, (ref) zero, (ref) v_u_60, (ref) v_u_59, (ref) v_u_62, (ref) v_u_101, (ref) v_u_63, (ref) v_u_50, (ref) v_u_56
                    if p362.UserInputType == Enum.UserInputType.MouseMovement and v_u_53 then
                        local v363 = Vector2.new(p362.Position.X, p362.Position.Y)
                        local v364 = v363 - zero
                        v_u_60 = v_u_60 + v364.X * 0.5
                        v_u_59 = v_u_59 + v364.Y * 0.5
                        local v365 = v_u_59
                        v_u_59 = math.clamp(v365, -80, 80)
                        zero = v363
                    end
                    if p362.UserInputType == Enum.UserInputType.Touch then
                        local v366 = Vector2.new(p362.Position.X, p362.Position.Y)
                        v_u_62[p362] = v366
                        local v367 = 0
                        for _ in pairs(v_u_62) do
                            v367 = v367 + 1
                        end
                        if v367 == 1 and v_u_53 then
                            local v368 = v366 - zero
                            v_u_60 = v_u_60 + v368.X * 0.5
                            v_u_59 = v_u_59 + v368.Y * 0.5
                            local v369 = v_u_59
                            v_u_59 = math.clamp(v369, -80, 80)
                            zero = v366
                        end
                        if v367 >= 2 then
                            local v370 = v_u_101()
                            if v370 and v_u_63 then
                                local v371 = (v370 - v_u_63) * 0.01
                                if v_u_50 ~= "Viewmodel" then
                                    local v372 = v_u_56 - v371 * 2
                                    v_u_56 = math.clamp(v372, 20, 70)
                                end
                            end
                            v_u_63 = v370
                        end
                    end
                    if p362.UserInputType == Enum.UserInputType.MouseWheel then
                        local v373 = p362.Position.Z
                        if v_u_50 == "Viewmodel" then
                            return
                        end
                        local v374 = v_u_56 - v373 * 2
                        v_u_56 = math.clamp(v374, 20, 70)
                    end
                end), "Disconnect", "InputChanged")
                v_u_49:Add(UserInputService.InputEnded:Connect(function(p375, _)
                    -- upvalues: (ref) v_u_53, (ref) v_u_62, (ref) v_u_63, (ref) v_u_101
                    if p375.UserInputType == Enum.UserInputType.MouseButton1 then
                        v_u_53 = false
                    end
                    if p375.UserInputType == Enum.UserInputType.Touch then
                        v_u_62[p375] = nil
                        local v376 = 0
                        for _ in pairs(v_u_62) do
                            v376 = v376 + 1
                        end
                        if v376 == 0 then
                            v_u_53 = false
                        end
                        v_u_63 = v_u_101()
                    end
                end), "Disconnect", "InputEnded")
                v_u_49:Add(function()
                    -- upvalues: (ref) v_u_45, (ref) v_u_47, (ref) v_u_43, (ref) ReplicatedStorage, (ref) v_u_53, (ref) v_u_62, (ref) v_u_63, (ref) v_u_57, (ref) v_u_58, (ref) v_u_59, (ref) v_u_60, (ref) v_u_55, (ref) v_u_56, (ref) InspectPivot
                    if v_u_45 then
                        v_u_45:Destroy()
                        v_u_45 = nil
                    end
                    if v_u_47 and v_u_47 == v_u_43 then
                        v_u_47.Parent = ReplicatedStorage
                        v_u_47 = nil
                    elseif v_u_47 then
                        v_u_47:Destroy()
                        v_u_47 = nil
                    end
                    v_u_53 = false
                    v_u_62 = {}
                    v_u_63 = nil
                    v_u_57 = 0
                    v_u_58 = 0
                    v_u_59 = 0
                    v_u_60 = 0
                    v_u_55 = 40
                    v_u_56 = 40
                    InspectPivot = nil
                end, true, "InspectCleanup")
                v_u_51 = true
                v_u_124()
            else
                warn("[InspectController]: Inspect scene missing WeaponPart")
                if v_u_47 then
                    v_u_47.Parent = ReplicatedStorage
                    v_u_47 = nil
                end
                v_u_74()
                v_u_337()
            end
        else
            warn("[InspectController]: Inspect scene missing CamPart")
            if v_u_47 then
                v_u_47.Parent = ReplicatedStorage
                v_u_47 = nil
            end
            v_u_74()
            v_u_337()
            return
        end
    else
        warn("[InspectController]: No preloaded inspect scene available")
        v_u_337()
        return
    end
end
function v_u_1.HideInspect(p377) -- name: HideInspect
    -- upvalues: (ref) v_u_51, (copy) v_u_49, (ref) v_u_36, (ref) v_u_37, (ref) v_u_38, (ref) v_u_41, (copy) m_InputController, (ref) v_u_45, (ref) InspectPivot, (copy) m_MenuState, (copy) m_CaseSceneController, (copy) v_u_74, (copy) CurrentCamera, (copy) m_CameraController, (copy) m_Constants, (copy) v_u_337, (ref) v_u_44, (copy) v_u_322, (ref) v_u_48, (ref) v_u_64, (ref) v_u_65, (copy) v_u_124
    if v_u_51 then
        v_u_49:Cleanup()
        if v_u_36 then
            if v_u_36.IsPlaying then
                v_u_36:Stop(0)
            end
            v_u_36:Destroy()
            v_u_36 = nil
        end
        if v_u_37 then
            v_u_37:Destroy()
            v_u_37 = nil
        end
        if v_u_38 then
            v_u_38:destroy()
            v_u_38 = nil
        end
        if v_u_41 then
            v_u_41:Destroy()
            v_u_41 = nil
        end
        m_InputController.enableGroup("Gameplay")
        if v_u_45 then
            v_u_45:Destroy()
            v_u_45 = nil
        end
        InspectPivot = nil
        if m_MenuState.IsCaseSceneActive() then
            m_CaseSceneController.ApplyCaseSceneLighting()
        else
            v_u_74()
        end
        CurrentCamera.CameraType = Enum.CameraType.Custom
        m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
        m_CameraController.setForceLockOverride("Inspect", false)
        if p377 then
            m_MenuState.ExitInspect()
            v_u_44 = false
        else
            v_u_337()
        end
        if m_MenuState.IsCaseSceneActive() then
            v_u_48 = {}
        else
            v_u_322()
        end
        v_u_64 = nil
        v_u_65 = 1
        v_u_51 = false
        v_u_124()
    end
end
function v_u_1.IsActive() -- name: IsActive
    -- upvalues: (ref) v_u_51
    return v_u_51
end
function v_u_1.ToggleInspect(p378) -- name: ToggleInspect
    -- upvalues: (ref) v_u_51, (copy) v_u_1
    if v_u_51 then
        v_u_1.HideInspect()
    elseif p378 then
        v_u_1.ShowInspect(p378)
    end
end
function v_u_1.CycleCharmPosition() -- name: CycleCharmPosition
    -- upvalues: (ref) v_u_51, (ref) v_u_64, (ref) v_u_65, (copy) v_u_1
    if v_u_51 and v_u_64 then
        v_u_65 = v_u_65 % 4 + 1
        local v379 = v_u_65
        v_u_1.RefreshWeaponWithCharm((tostring(v379)))
    end
end
function v_u_1.RefreshWeaponWithCharm(p380) -- name: RefreshWeaponWithCharm
    -- upvalues: (ref) v_u_51, (ref) v_u_47, (ref) v_u_64, (ref) v_u_57, (ref) v_u_58, (ref) v_u_59, (ref) v_u_60, (ref) v_u_50, (ref) v_u_45, (copy) m_Skins, (ref) InspectPivot, (copy) v_u_98, (ref) v_u_38, (ref) v_u_41
    if v_u_51 and (v_u_47 and v_u_64) then
        local v381 = v_u_47
        local v382 = v_u_64
        if v381:FindFirstChild("WeaponPart") then
            local v383 = v_u_57
            local v384 = v_u_58
            local v385 = v_u_59
            local v386 = v_u_60
            local Charm_2 = v382.Charm
            local v388 = type(Charm_2) == "table" and {
                ["_id"] = Charm_2._id,
                ["Position"] = p380
            } or p380
            if v_u_50 == "Weapon" then
                if v_u_45 then
                    v_u_45:Destroy()
                    v_u_45 = nil
                end
                local v389 = m_Skins.GetCharacterModel(v382.Name, v382.Skin, v382.Float, v382.StatTrack, v382.NameTag, v388, v382.Stickers)
                if not v389 then
                    warn((("[InspectController]: Failed to refresh weapon model for charm position %*"):format(p380)))
                    return
                end
                v389.Name = "InspectWeapon"
                v_u_45 = v389
                InspectPivot = v389:FindFirstChild("InspectPivot", true)
                local CharmBase_0 = v389:FindFirstChild("CharmBase", true)
                for _, v391 in ipairs(v389:GetDescendants()) do
                    if v391:IsA("BasePart") then
                        local v392
                        if CharmBase_0 then
                            v392 = v391:IsDescendantOf(CharmBase_0)
                        else
                            v392 = CharmBase_0
                        end
                        v391.CastShadow = false
                        if v392 then
                            v391.Anchored = false
                        else
                            v391.CanCollide = v391:IsA("MeshPart") and true or false
                            v391.CanQuery = false
                            v391.CanTouch = false
                            v391.Anchored = true
                        end
                    end
                end
                v389.Parent = v381
                v_u_57 = v383
                v_u_58 = v384
                v_u_59 = v385
                v_u_60 = v386
                v_u_98()
            end
            if v_u_38 and v_u_41 then
                v_u_38.Charm = v388
                v_u_38:construct(v_u_41, nil)
            end
        end
    else
        return
    end
end
function v_u_1.GetCurrentCharmPosition() -- name: GetCurrentCharmPosition
    -- upvalues: (ref) v_u_65
    return v_u_65
end
function v_u_1.PlayInspectAnimation() -- name: PlayInspectAnimation
    -- upvalues: (ref) v_u_50, (ref) v_u_38, (ref) v_u_40, (copy) m_GetWeaponProperties, (ref) v_u_36
    if v_u_50 == "Viewmodel" and v_u_38 then
        local v393 = v_u_40
        local v394
        if v393 then
            if v393.Type == "Glove" then
                v394 = true
            elseif v393.Name then
                local v395, v396 = pcall(m_GetWeaponProperties, v393.Name)
                if v395 and (v396 and v396.Class) then
                    v394 = v396.Class == "Glove"
                else
                    v394 = false
                end
            else
                v394 = false
            end
        else
            v394 = false
        end
        if v394 then
            if v_u_36 then
                if v_u_38 and v_u_38.Animation then
                    v_u_38.Animation:stopAnimations()
                end
                if v_u_36.IsPlaying then
                    v_u_36:Stop(0)
                end
                v_u_36.TimePosition = 0
                v_u_36:Play(0, 1, 1)
            end
        elseif v_u_38.Animation then
            local v397 = v_u_38.Animation:pickInspectVariant()
            v_u_38.Animation:stopAnimations()
            v_u_38.Animation:play("Idle")
            v_u_38.Animation:play(v397)
        end
    else
        return
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer, (copy) Lighting, (ref) GlobalShadows, (copy) v_u_87, (ref) Name, (ref) v_u_43, (copy) ReplicatedStorage, (copy) UserInputService, (ref) v_u_51, (copy) v_u_1, (copy) m_Router, (ref) v_u_65
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
    local v398 = v_u_87()
    if v398 then
        Name = v398.Name
        v_u_43 = v398
        if v_u_43 then
            v_u_43.Name = "InspectScene"
            v_u_43.Parent = ReplicatedStorage
        end
    else
        warn("[InspectController]: No inspect scene found to preload in ReplicatedStorage.Assets.InspectScenes")
    end
    UserInputService.InputBegan:Connect(function(p399, p400)
        -- upvalues: (ref) v_u_51, (ref) v_u_1
        if not p400 then
            if p399.KeyCode == Enum.KeyCode.Escape and v_u_51 then
                v_u_1.HideInspect()
            end
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function()
        -- upvalues: (ref) v_u_51, (ref) v_u_1
        if v_u_51 then
            v_u_1.HideInspect()
        end
    end)
    m_Router.observerRouter("WeaponInspect", function(p401, p402, p403, p404, p405, p406, p407, p408, p409, p410, p411, p412)
        -- upvalues: (ref) ReplicatedStorage, (ref) v_u_1
        if not require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
            local v413 = {
                ["_id"] = p410 or "inspect_" .. p401 .. "_" .. p402,
                ["Name"] = p401,
                ["Skin"] = p402,
                ["Float"] = p403,
                ["StatTrack"] = p404,
                ["NameTag"] = p405,
                ["Charm"] = p406,
                ["Stickers"] = p407,
                ["Type"] = p408,
                ["Pattern"] = p409,
                ["Serial"] = p411,
                ["IsTradeable"] = p412
            }
            v_u_1.ShowInspect(v413)
        end
    end)
    m_Router.observerRouter("WeaponInspectClose", function()
        -- upvalues: (ref) v_u_1
        v_u_1.HideInspect()
    end)
    m_Router.observerRouter("WeaponInspectCloseForGameEnd", function()
        -- upvalues: (ref) v_u_1
        v_u_1.HideInspect(true)
    end)
    m_Router.observerRouter("IsInspectActive", function()
        -- upvalues: (ref) v_u_1
        return v_u_1.IsActive()
    end)
    m_Router.observerRouter("GetCurrentCharmPosition", function()
        -- upvalues: (ref) v_u_65
        return v_u_65
    end)
end
function v_u_1.Start() -- name: Start
    -- upvalues: (copy) v_u_118
    v_u_118()
end
return v_u_1
