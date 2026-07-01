-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
local LocalPlayer = Players.LocalPlayer
local v_u_11 = {
    ["WarmupColorCorrection"] = true,
    ["FlashbangColorCorrection"] = true
}
local v12 = {}
local v_u_13 = nil
local function v_u_18() -- name: getBestMapColorCorrection
    -- upvalues: (ref) v_u_13, (copy) Lighting, (copy) v_u_11
    local v14 = v_u_13
    if v14 and (v14:IsDescendantOf(Lighting) and not v_u_11[v14.Name]) then
        return v14
    end
    local v15 = nil
    local v16 = nil
    for _, v17 in ipairs(Lighting:GetDescendants()) do
        if v17:IsA("ColorCorrectionEffect") and not v_u_11[v17.Name] then
            if v17.Enabled then
                v15 = v15 or v17
            end
            if not v16 then
                v16 = v17
            end
        end
    end
    v_u_13 = v15 or v16
    return v_u_13
end
local function v_u_22() -- name: findActiveViewmodelModel
    -- upvalues: (copy) Workspace
    local CurrentCamera = Workspace.CurrentCamera
    if not CurrentCamera then
        return nil
    end
    for _, v20 in ipairs(CurrentCamera:GetChildren()) do
        if v20:IsA("Model") and v20:FindFirstChild("Stats") then
            return v20
        end
    end
    for _, v21 in ipairs(CurrentCamera:GetDescendants()) do
        if v21:IsA("Model") and v21:FindFirstChild("Stats") then
            return v21
        end
    end
    return nil
end
local function v_u_26(p23, p24) -- name: getViewmodelModelFromInstance
    local v25 = nil
    if not p23:IsA("Model") then
        p23 = p23:FindFirstAncestorOfClass("Model")
        if p23 then
            if not p23:IsA("Model") then
                p23 = v25
            end
        else
            p23 = v25
        end
    end
    if p23 and (p23:IsDescendantOf(p24) and p23:FindFirstChild("Stats")) then
        return p23
    else
        return nil
    end
end
function v12.Start() -- name: Start
    -- upvalues: (copy) ReplicatedStorage, (copy) m_MenuState, (copy) LocalPlayer, (copy) v_u_18, (copy) TweenService, (copy) m_Router, (copy) Workspace, (copy) v_u_22, (copy) v_u_26, (copy) m_GameState, (copy) m_Observers
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local v28
    if Assets then
        v28 = Assets:FindFirstChild("Warmup")
        if not (v28 and v28:IsA("Folder")) then
            v28 = nil
        end
    else
        v28 = nil
    end
    if v28 then
        local ColorCorrection = v28:FindFirstChild("ColorCorrection")
        local ViewmodelHighlight = v28:FindFirstChild("ViewmodelHighlight")
        if ColorCorrection and ColorCorrection:IsA("ColorCorrectionEffect") then
            if ViewmodelHighlight and ViewmodelHighlight:IsA("Highlight") then
                local v_u_31 = 0
                local v_u_32 = nil
                local v_u_33 = false
                local v_u_34 = false
                local function v_u_80() -- name: startBuyPeriodEffects
                    -- upvalues: (ref) v_u_31, (ref) v_u_32, (ref) v_u_18, (copy) ColorCorrection, (ref) TweenService, (ref) m_Router, (ref) Workspace, (ref) v_u_22, (copy) ViewmodelHighlight, (ref) v_u_26
                    v_u_31 = v_u_31 + 1
                    if v_u_32 then
                        v_u_32()
                        v_u_32 = nil
                    end
                    v_u_31 = v_u_31 + 1
                    local v_u_35 = v_u_31
                    local v_u_36 = false
                    local v_u_37 = false
                    local v_u_38 = nil
                    local v_u_39 = nil
                    local v_u_40 = v_u_18()
                    local v_u_41 = nil
                    local v_u_42
                    if v_u_40 then
                        v_u_42 = v_u_40.Enabled or false
                    else
                        v_u_42 = false
                    end
                    local v_u_43 = v_u_40 and {
                        ["Brightness"] = v_u_40.Brightness,
                        ["Contrast"] = v_u_40.Contrast,
                        ["Saturation"] = v_u_40.Saturation,
                        ["TintColor"] = v_u_40.TintColor
                    } or nil
                    if v_u_40 then
                        v_u_40.Enabled = true
                        v_u_40.Brightness = ColorCorrection.Brightness
                        v_u_40.Contrast = ColorCorrection.Contrast
                        v_u_40.Saturation = ColorCorrection.Saturation
                        v_u_40.TintColor = ColorCorrection.TintColor
                    else
                        warn("[WarmupEffectsController] No map ColorCorrectionEffect found under Lighting; warmup CC tween skipped")
                    end
                    local function v_u_46(p44) -- name: startFinalCountdownTweens
                        -- upvalues: (ref) v_u_36, (ref) v_u_38, (ref) v_u_39, (copy) v_u_40, (copy) v_u_43, (ref) v_u_41, (ref) TweenService
                        if v_u_36 then
                            return
                        elseif p44 > 0 then
                            v_u_36 = true
                            v_u_38 = os.clock()
                            v_u_39 = p44
                            if v_u_40 and v_u_43 then
                                if v_u_41 then
                                    v_u_41:Cancel()
                                    v_u_41 = nil
                                end
                                local v45 = TweenService:Create(v_u_40, TweenInfo.new(p44, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                    ["Brightness"] = v_u_43.Brightness,
                                    ["Contrast"] = v_u_43.Contrast,
                                    ["Saturation"] = v_u_43.Saturation,
                                    ["TintColor"] = v_u_43.TintColor
                                })
                                v_u_41 = v45
                                v45:Play()
                            end
                        end
                    end
                    local v_u_47 = nil
                    local v_u_48 = nil
                    local v_u_49 = nil
                    local v_u_50 = nil
                    local v_u_51 = nil
                    local v_u_52 = nil
                    local v_u_53 = false
                    local v_u_54 = false
                    local function v_u_60(p_u_55) -- name: startHighlightTweenIfPossible
                        -- upvalues: (ref) v_u_53, (ref) v_u_48, (ref) v_u_47, (ref) v_u_36, (ref) v_u_38, (ref) v_u_39, (ref) TweenService
                        if v_u_53 then
                            if p_u_55.Parent then
                                p_u_55:Destroy()
                            end
                            if v_u_48 == p_u_55 then
                                v_u_48 = nil
                            end
                            return
                        elseif v_u_47 then
                            return
                        elseif v_u_36 then
                            local v56
                            if v_u_36 and (v_u_38 and v_u_39) then
                                local v57 = v_u_39 - (os.clock() - v_u_38)
                                v56 = math.max(0, v57)
                            else
                                v56 = 0
                            end
                            if v56 <= 0 then
                                v_u_53 = true
                                p_u_55.FillTransparency = 1
                                p_u_55.OutlineTransparency = 1
                                p_u_55:Destroy()
                                if v_u_48 == p_u_55 then
                                    v_u_48 = nil
                                end
                            else
                                local v_u_58 = TweenService:Create(p_u_55, TweenInfo.new(v56, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                    ["FillTransparency"] = 1,
                                    ["OutlineTransparency"] = 1
                                })
                                v_u_47 = v_u_58
                                v_u_58.Completed:Connect(function(p59)
                                    -- upvalues: (ref) v_u_47, (copy) v_u_58, (ref) v_u_53, (copy) p_u_55, (ref) v_u_48
                                    if v_u_47 == v_u_58 then
                                        v_u_47 = nil
                                    end
                                    if p59 == Enum.PlaybackState.Completed then
                                        v_u_53 = true
                                    end
                                    if p_u_55.Parent then
                                        p_u_55:Destroy()
                                    end
                                    if v_u_48 == p_u_55 then
                                        v_u_48 = nil
                                    end
                                end)
                                v_u_58:Play()
                            end
                        else
                            return
                        end
                    end
                    local function v_u_66() -- name: ensureHighlightAttached
                        -- upvalues: (ref) v_u_31, (copy) v_u_35, (ref) v_u_53, (ref) v_u_36, (ref) v_u_38, (ref) v_u_39, (ref) v_u_47, (ref) v_u_48, (ref) Workspace, (ref) v_u_52, (ref) v_u_22, (ref) ViewmodelHighlight, (copy) v_u_60
                        if v_u_31 == v_u_35 then
                            if v_u_53 then
                                return
                            else
                                if v_u_36 then
                                    local v61
                                    if v_u_36 and (v_u_38 and v_u_39) then
                                        local v62 = v_u_39 - (os.clock() - v_u_38)
                                        v61 = math.max(0, v62)
                                    else
                                        v61 = 0
                                    end
                                    if v61 <= 0 then
                                        v_u_53 = true
                                        if v_u_47 then
                                            v_u_47:Cancel()
                                            v_u_47 = nil
                                        end
                                        if v_u_48 then
                                            v_u_48:Destroy()
                                            v_u_48 = nil
                                        end
                                        return
                                    end
                                end
                                local CurrentCamera_0 = Workspace.CurrentCamera
                                if CurrentCamera_0 then
                                    local v64 = v_u_52
                                    if not (v64 and v64:IsDescendantOf(CurrentCamera_0)) then
                                        v64 = v_u_22()
                                        v_u_52 = v64
                                    end
                                    if v64 then
                                        local v65 = v_u_48
                                        if not v65 or v65.Parent == nil then
                                            v65 = ViewmodelHighlight:Clone()
                                            v_u_48 = v65
                                            v_u_47 = nil
                                        end
                                        if v65.Parent ~= v64 then
                                            v65.Parent = v64
                                        end
                                        if v65.Adornee ~= v64 then
                                            v65.Adornee = v64
                                        end
                                        v_u_60(v65)
                                    end
                                else
                                    return
                                end
                            end
                        else
                            return
                        end
                    end
                    v_u_66()
                    local function v_u_73(p_u_67) -- name: bindToCamera
                        -- upvalues: (ref) v_u_49, (ref) v_u_50, (ref) v_u_51, (ref) v_u_53, (ref) v_u_26, (ref) v_u_52, (ref) v_u_54, (ref) v_u_31, (copy) v_u_35, (copy) v_u_66, (ref) v_u_48, (ref) ViewmodelHighlight
                        if v_u_49 then
                            v_u_49:Disconnect()
                            v_u_49 = nil
                        end
                        if v_u_50 then
                            v_u_50:Disconnect()
                            v_u_50 = nil
                        end
                        if v_u_51 then
                            v_u_51:Disconnect()
                            v_u_51 = nil
                        end
                        if p_u_67 then
                            v_u_49 = p_u_67.ChildAdded:Connect(function(p68)
                                -- upvalues: (ref) v_u_53, (ref) v_u_26, (copy) p_u_67, (ref) v_u_52, (ref) v_u_54, (ref) v_u_31, (ref) v_u_35, (ref) v_u_66
                                if not v_u_53 then
                                    local v69 = v_u_26(p68, p_u_67)
                                    if v69 then
                                        v_u_52 = v69
                                    end
                                    if not v_u_54 and v_u_31 == v_u_35 then
                                        if v_u_53 then
                                            return
                                        end
                                        v_u_54 = true
                                        task.defer(function()
                                            -- upvalues: (ref) v_u_54, (ref) v_u_66
                                            v_u_54 = false
                                            v_u_66()
                                        end)
                                    end
                                end
                            end)
                            v_u_51 = p_u_67.ChildRemoved:Connect(function(p70)
                                -- upvalues: (ref) v_u_53, (ref) v_u_52, (ref) v_u_54, (ref) v_u_31, (ref) v_u_35, (ref) v_u_66
                                if not v_u_53 then
                                    if v_u_52 == p70 or v_u_52 and v_u_52:IsDescendantOf(p70) then
                                        v_u_52 = nil
                                    end
                                    if not v_u_54 and v_u_31 == v_u_35 then
                                        if v_u_53 then
                                            return
                                        end
                                        v_u_54 = true
                                        task.defer(function()
                                            -- upvalues: (ref) v_u_54, (ref) v_u_66
                                            v_u_54 = false
                                            v_u_66()
                                        end)
                                    end
                                end
                            end)
                            v_u_50 = p_u_67.DescendantAdded:Connect(function(p71)
                                -- upvalues: (ref) v_u_53, (ref) v_u_48, (ref) ViewmodelHighlight, (ref) v_u_26, (copy) p_u_67, (ref) v_u_52, (ref) v_u_54, (ref) v_u_31, (ref) v_u_35, (ref) v_u_66
                                if v_u_53 then
                                    return
                                elseif p71 == v_u_48 or p71:IsA("Highlight") and p71.Name == ViewmodelHighlight.Name then
                                    return
                                else
                                    local v72 = v_u_26(p71, p_u_67)
                                    if v72 then
                                        v_u_52 = v72
                                        if not v_u_54 and v_u_31 == v_u_35 then
                                            if v_u_53 then
                                                return
                                            end
                                            v_u_54 = true
                                            task.defer(function()
                                                -- upvalues: (ref) v_u_54, (ref) v_u_66
                                                v_u_54 = false
                                                v_u_66()
                                            end)
                                        end
                                    end
                                end
                            end)
                        end
                    end
                    v_u_73(Workspace.CurrentCamera)
                    local v_u_74 = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                        -- upvalues: (ref) v_u_52, (copy) v_u_73, (ref) Workspace, (ref) v_u_54, (ref) v_u_31, (copy) v_u_35, (ref) v_u_53, (copy) v_u_66
                        v_u_52 = nil
                        v_u_73(Workspace.CurrentCamera)
                        if not v_u_54 and v_u_31 == v_u_35 then
                            if v_u_53 then
                                return
                            end
                            v_u_54 = true
                            task.defer(function()
                                -- upvalues: (ref) v_u_54, (ref) v_u_66
                                v_u_54 = false
                                v_u_66()
                            end)
                        end
                    end)
                    local v_u_77 = Workspace:GetAttributeChangedSignal("Timer"):Connect(function()
                        -- upvalues: (ref) v_u_31, (copy) v_u_35, (ref) Workspace, (ref) v_u_53, (ref) v_u_47, (ref) v_u_48, (ref) v_u_37, (ref) m_Router, (ref) v_u_36, (copy) v_u_46, (copy) v_u_60, (ref) v_u_54, (copy) v_u_66
                        if v_u_31 == v_u_35 then
                            local v75 = Workspace:GetAttribute("Timer")
                            if typeof(v75) == "number" then
                                if v75 <= 0 then
                                    v_u_53 = true
                                    if v_u_47 then
                                        v_u_47:Cancel()
                                        v_u_47 = nil
                                    end
                                    if v_u_48 then
                                        v_u_48:Destroy()
                                        v_u_48 = nil
                                    end
                                else
                                    if not v_u_37 and v75 <= 2 then
                                        v_u_37 = true
                                        m_Router.broadcastRouter("RunRoundSound", "Round Start Countdown")
                                    end
                                    if not v_u_36 and v75 <= 3 then
                                        v_u_46((math.min(3, v75)))
                                        local v76 = v_u_48
                                        if v76 then
                                            v_u_60(v76)
                                            return
                                        end
                                        if not v_u_54 and v_u_31 == v_u_35 then
                                            if v_u_53 then
                                                return
                                            end
                                            v_u_54 = true
                                            task.defer(function()
                                                -- upvalues: (ref) v_u_54, (ref) v_u_66
                                                v_u_54 = false
                                                v_u_66()
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
                    end)
                    local v78 = Workspace:GetAttribute("Timer")
                    if typeof(v78) == "number" then
                        if v78 > 0 and (not v_u_37 and v78 <= 2) then
                            local _ = true
                            m_Router.broadcastRouter("RunRoundSound", "Round Start Countdown")
                        end
                        if v78 > 0 and v78 <= 3 then
                            v_u_46((math.min(3, v78)))
                            local v79 = v_u_48
                            if v79 then
                                v_u_60(v79)
                            elseif not v_u_54 and (v_u_31 == v_u_35 and not v_u_53) then
                                v_u_54 = true
                                task.defer(function()
                                    -- upvalues: (ref) v_u_54, (copy) v_u_66
                                    v_u_54 = false
                                    v_u_66()
                                end)
                            end
                        end
                    end
                    v_u_32 = function()
                        -- upvalues: (ref) v_u_54, (ref) v_u_41, (ref) v_u_47, (ref) v_u_49, (ref) v_u_50, (ref) v_u_51, (ref) v_u_74, (ref) v_u_77, (ref) v_u_48, (copy) v_u_40, (copy) v_u_43, (copy) v_u_42
                        v_u_54 = false
                        if v_u_41 then
                            v_u_41:Cancel()
                            v_u_41 = nil
                        end
                        if v_u_47 then
                            v_u_47:Cancel()
                            v_u_47 = nil
                        end
                        if v_u_49 then
                            v_u_49:Disconnect()
                            v_u_49 = nil
                        end
                        if v_u_50 then
                            v_u_50:Disconnect()
                            v_u_50 = nil
                        end
                        if v_u_51 then
                            v_u_51:Disconnect()
                            v_u_51 = nil
                        end
                        if v_u_74 then
                            v_u_74:Disconnect()
                            v_u_74 = nil
                        end
                        if v_u_77 then
                            v_u_77:Disconnect()
                            v_u_77 = nil
                        end
                        if v_u_48 then
                            v_u_48:Destroy()
                            v_u_48 = nil
                        end
                        if v_u_40 and v_u_43 then
                            v_u_40.Brightness = v_u_43.Brightness
                            v_u_40.Contrast = v_u_43.Contrast
                            v_u_40.Saturation = v_u_43.Saturation
                            v_u_40.TintColor = v_u_43.TintColor
                            v_u_40.Enabled = v_u_42
                        end
                    end
                end
                m_GameState.ListenToState(function(_, p81)
                    -- upvalues: (ref) v_u_33, (ref) m_GameState, (ref) m_MenuState, (ref) LocalPlayer, (ref) v_u_34, (copy) v_u_80, (ref) v_u_31, (ref) v_u_32
                    v_u_33 = p81 == "Buy Period"
                    v_u_33 = m_GameState.GetState() == "Buy Period"
                    local v82
                    if m_MenuState.IsInspectActive() or m_MenuState.IsCaseSceneActive() then
                        v82 = false
                    else
                        local v83 = m_MenuState.GetMenuFrame()
                        if v83 and v83.Visible then
                            v82 = false
                        else
                            local v84 = LocalPlayer:GetAttribute("IsSpectating") == true
                            local v85 = LocalPlayer.Character ~= nil
                            v82 = v85 or v84
                        end
                    end
                    if v_u_33 and v82 then
                        if not v_u_34 then
                            v_u_34 = true
                            v_u_80()
                            return
                        end
                    elseif v_u_34 then
                        v_u_34 = false
                        v_u_31 = v_u_31 + 1
                        if v_u_32 then
                            v_u_32()
                            v_u_32 = nil
                        end
                    end
                end)
                m_MenuState.OnScreenChanged:Connect(function()
                    -- upvalues: (ref) m_GameState, (ref) v_u_33, (ref) m_MenuState, (ref) LocalPlayer, (ref) v_u_34, (copy) v_u_80, (ref) v_u_31, (ref) v_u_32
                    v_u_33 = m_GameState.GetState() == "Buy Period"
                    local v86
                    if m_MenuState.IsInspectActive() or m_MenuState.IsCaseSceneActive() then
                        v86 = false
                    else
                        local v87 = m_MenuState.GetMenuFrame()
                        if v87 and v87.Visible then
                            v86 = false
                        else
                            local v88 = LocalPlayer:GetAttribute("IsSpectating") == true
                            local v89 = LocalPlayer.Character ~= nil
                            v86 = v89 or v88
                        end
                    end
                    if v_u_33 and v86 then
                        if not v_u_34 then
                            v_u_34 = true
                            v_u_80()
                            return
                        end
                    elseif v_u_34 then
                        v_u_34 = false
                        v_u_31 = v_u_31 + 1
                        if v_u_32 then
                            v_u_32()
                            v_u_32 = nil
                        end
                    end
                end)
                m_MenuState.OnInspectStateChanged:Connect(function()
                    -- upvalues: (ref) m_GameState, (ref) v_u_33, (ref) m_MenuState, (ref) LocalPlayer, (ref) v_u_34, (copy) v_u_80, (ref) v_u_31, (ref) v_u_32
                    v_u_33 = m_GameState.GetState() == "Buy Period"
                    local v90
                    if m_MenuState.IsInspectActive() or m_MenuState.IsCaseSceneActive() then
                        v90 = false
                    else
                        local v91 = m_MenuState.GetMenuFrame()
                        if v91 and v91.Visible then
                            v90 = false
                        else
                            local v92 = LocalPlayer:GetAttribute("IsSpectating") == true
                            local v93 = LocalPlayer.Character ~= nil
                            v90 = v93 or v92
                        end
                    end
                    if v_u_33 and v90 then
                        if not v_u_34 then
                            v_u_34 = true
                            v_u_80()
                            return
                        end
                    elseif v_u_34 then
                        v_u_34 = false
                        v_u_31 = v_u_31 + 1
                        if v_u_32 then
                            v_u_32()
                            v_u_32 = nil
                        end
                    end
                end)
                m_MenuState.OnCaseSceneStateChanged:Connect(function()
                    -- upvalues: (ref) m_GameState, (ref) v_u_33, (ref) m_MenuState, (ref) LocalPlayer, (ref) v_u_34, (copy) v_u_80, (ref) v_u_31, (ref) v_u_32
                    v_u_33 = m_GameState.GetState() == "Buy Period"
                    local v94
                    if m_MenuState.IsInspectActive() or m_MenuState.IsCaseSceneActive() then
                        v94 = false
                    else
                        local v95 = m_MenuState.GetMenuFrame()
                        if v95 and v95.Visible then
                            v94 = false
                        else
                            local v96 = LocalPlayer:GetAttribute("IsSpectating") == true
                            local v97 = LocalPlayer.Character ~= nil
                            v94 = v97 or v96
                        end
                    end
                    if v_u_33 and v94 then
                        if not v_u_34 then
                            v_u_34 = true
                            v_u_80()
                            return
                        end
                    elseif v_u_34 then
                        v_u_34 = false
                        v_u_31 = v_u_31 + 1
                        if v_u_32 then
                            v_u_32()
                            v_u_32 = nil
                        end
                    end
                end)
                LocalPlayer.CharacterAdded:Connect(function()
                    -- upvalues: (ref) m_GameState, (ref) v_u_33, (ref) m_MenuState, (ref) LocalPlayer, (ref) v_u_34, (copy) v_u_80, (ref) v_u_31, (ref) v_u_32
                    v_u_33 = m_GameState.GetState() == "Buy Period"
                    local v98
                    if m_MenuState.IsInspectActive() or m_MenuState.IsCaseSceneActive() then
                        v98 = false
                    else
                        local v99 = m_MenuState.GetMenuFrame()
                        if v99 and v99.Visible then
                            v98 = false
                        else
                            local v100 = LocalPlayer:GetAttribute("IsSpectating") == true
                            local v101 = LocalPlayer.Character ~= nil
                            v98 = v101 or v100
                        end
                    end
                    if v_u_33 and v98 then
                        if not v_u_34 then
                            v_u_34 = true
                            v_u_80()
                            return
                        end
                    elseif v_u_34 then
                        v_u_34 = false
                        v_u_31 = v_u_31 + 1
                        if v_u_32 then
                            v_u_32()
                            v_u_32 = nil
                        end
                    end
                end)
                LocalPlayer.CharacterRemoving:Connect(function()
                    -- upvalues: (ref) m_GameState, (ref) v_u_33, (ref) m_MenuState, (ref) LocalPlayer, (ref) v_u_34, (copy) v_u_80, (ref) v_u_31, (ref) v_u_32
                    v_u_33 = m_GameState.GetState() == "Buy Period"
                    local v102
                    if m_MenuState.IsInspectActive() or m_MenuState.IsCaseSceneActive() then
                        v102 = false
                    else
                        local v103 = m_MenuState.GetMenuFrame()
                        if v103 and v103.Visible then
                            v102 = false
                        else
                            local v104 = LocalPlayer:GetAttribute("IsSpectating") == true
                            local v105 = LocalPlayer.Character ~= nil
                            v102 = v105 or v104
                        end
                    end
                    if v_u_33 and v102 then
                        if not v_u_34 then
                            v_u_34 = true
                            v_u_80()
                            return
                        end
                    elseif v_u_34 then
                        v_u_34 = false
                        v_u_31 = v_u_31 + 1
                        if v_u_32 then
                            v_u_32()
                            v_u_32 = nil
                        end
                    end
                end)
                m_Observers.observeAttribute(LocalPlayer, "IsSpectating", function()
                    -- upvalues: (ref) m_GameState, (ref) v_u_33, (ref) m_MenuState, (ref) LocalPlayer, (ref) v_u_34, (copy) v_u_80, (ref) v_u_31, (ref) v_u_32
                    v_u_33 = m_GameState.GetState() == "Buy Period"
                    local v106
                    if m_MenuState.IsInspectActive() or m_MenuState.IsCaseSceneActive() then
                        v106 = false
                    else
                        local v107 = m_MenuState.GetMenuFrame()
                        if v107 and v107.Visible then
                            v106 = false
                        else
                            local v108 = LocalPlayer:GetAttribute("IsSpectating") == true
                            local v109 = LocalPlayer.Character ~= nil
                            v106 = v109 or v108
                        end
                    end
                    if v_u_33 and v106 then
                        if not v_u_34 then
                            v_u_34 = true
                            v_u_80()
                        end
                    elseif v_u_34 then
                        v_u_34 = false
                        v_u_31 = v_u_31 + 1
                        if v_u_32 then
                            v_u_32()
                            v_u_32 = nil
                        end
                    end
                    return function() end
                end)
                local v110
                if m_GameState.GetState() == "Buy Period" then
                    v_u_33 = true
                    v110 = v_u_33
                else
                    v_u_33 = false
                    v110 = v_u_33
                end
                local v111
                if m_MenuState.IsInspectActive() or m_MenuState.IsCaseSceneActive() then
                    v111 = false
                else
                    local v112 = m_MenuState.GetMenuFrame()
                    if v112 and v112.Visible then
                        v111 = false
                    else
                        local v113 = LocalPlayer:GetAttribute("IsSpectating") == true
                        local v114 = LocalPlayer.Character ~= nil
                        v111 = v114 or v113
                    end
                end
                if v110 and v111 then
                    if not v_u_34 then
                        v_u_34 = true
                        v_u_80()
                    end
                elseif v_u_34 then
                    v_u_34 = false
                    v_u_31 = v_u_31 + 1
                    if v_u_32 then
                        v_u_32()
                        v_u_32 = nil
                    end
                end
            else
                warn("[WarmupEffectsController] Missing Assets.Warmup.ViewmodelHighlight (Highlight)")
            end
        else
            warn("[WarmupEffectsController] Missing Assets.Warmup.ColorCorrection (ColorCorrectionEffect)")
            return
        end
    else
        warn("[WarmupEffectsController] Missing ReplicatedStorage.Assets.Warmup")
        return
    end
end
return v12
