-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local LocalPlayer = Players.LocalPlayer
local m_MenuSceneController = nil
local m_CaseSceneController = nil
local m_InspectController = nil
local GlobalShadows = nil
local function v_u_18(p11) -- name: applyMapLighting
    -- upvalues: (copy) Maps, (ref) GlobalShadows, (copy) Lighting, (copy) m_DataController, (copy) LocalPlayer
    local v12 = Maps:FindFirstChild(p11)
    if v12 and v12:IsA("ModuleScript") then
        local v13 = require(v12)
        if v13.Lighting then
            local Properties = v13.Lighting.Properties
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
            for _, v15 in ipairs(Lighting:GetChildren()) do
                if v15.Name ~= "Menu" then
                    v15:Destroy()
                end
            end
            local Assets = v13.Lighting.Assets
            if Assets then
                for _, v17 in ipairs(Assets:GetChildren()) do
                    v17:Clone().Parent = Lighting
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
            warn((("[MapLighting]: Map \"%*\" has no lighting configuration"):format(p11)))
            return
        end
    else
        warn((("[MapLighting]: Map \"%*\" not found in database"):format(p11)))
        return
    end
end
local function v_u_20() -- name: shouldApplyMapLighting
    -- upvalues: (ref) m_MenuSceneController, (copy) ReplicatedStorage, (ref) m_CaseSceneController, (ref) m_InspectController
    if not m_MenuSceneController then
        m_MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
    end
    if not m_CaseSceneController then
        m_CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
    end
    if not m_InspectController then
        m_InspectController = require(ReplicatedStorage.Controllers.InspectController)
    end
    local v19 = not (m_MenuSceneController.IsActive() or m_CaseSceneController.IsActive())
    if v19 then
        v19 = not m_InspectController.IsActive()
    end
    return v19
end
local function v_u_25(p_u_21) -- name: handleMapLoaded
    -- upvalues: (copy) v_u_20, (copy) v_u_18
    if v_u_20() then
        local v22 = p_u_21:GetAttribute("MapName")
        if not v22 or typeof(v22) ~= "string" then
            v22 = nil
        end
        if v22 then
            v_u_18(v22)
        else
            local v_u_23 = nil
            v_u_23 = p_u_21:GetAttributeChangedSignal("MapName"):Connect(function()
                -- upvalues: (ref) v_u_20, (ref) v_u_23, (copy) p_u_21, (ref) v_u_18
                if v_u_20() then
                    local v24 = p_u_21:GetAttribute("MapName")
                    if not v24 or typeof(v24) ~= "string" then
                        v24 = nil
                    end
                    if v24 then
                        v_u_23:Disconnect()
                        v_u_18(v24)
                    end
                else
                    v_u_23:Disconnect()
                end
            end)
        end
    else
        return
    end
end
m_DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function()
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer, (copy) Lighting, (ref) GlobalShadows
    if m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if GlobalShadows ~= nil then
            Lighting.GlobalShadows = GlobalShadows
        end
    else
        Lighting.GlobalShadows = false
    end
end)
workspace.ChildAdded:Connect(function(p_u_26)
    -- upvalues: (copy) v_u_25
    if p_u_26.Name == "Map" then
        task.defer(function()
            -- upvalues: (ref) v_u_25, (copy) p_u_26
            v_u_25(p_u_26)
        end)
    end
end)
local Map = workspace:FindFirstChild("Map")
if Map then
    task.defer(function()
        -- upvalues: (copy) v_u_25, (copy) Map
        v_u_25(Map)
    end)
end
return nil
