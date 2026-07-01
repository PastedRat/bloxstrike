-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Debris = workspace:WaitForChild("Debris")
local m_SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_InputController = require(ReplicatedStorage.Controllers.InputController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_CharacterHighlight = require(ReplicatedStorage.Classes.CharacterHighlight)
local m_GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local m_CharacterKinematics = require(script.Components.CharacterKinematics)
local m_Defuser = require(script.Components.Defuser)
local v_u_17 = {
    ["Counter-Terrorists"] = Color3.fromRGB(25, 80, 170),
    ["Terrorists"] = Color3.fromRGB(255, 215, 70)
}
local v_u_18 = {}
local v_u_19 = {}
local v_u_20 = {}
local v_u_21 = nil
local function v_u_27(p22, p23) -- name: waitForHumanoid
    local Humanoid = p22:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        return Humanoid
    end
    local v25 = tick()
    while p22.Parent do
        task.wait(0.1)
        local Humanoid_0 = p22:FindFirstChildOfClass("Humanoid")
        if Humanoid_0 then
            return Humanoid_0
        end
        if p23 and p23 <= tick() - v25 then
            return nil
        end
    end
    return nil
end
local function v_u_31(p28, p29) -- name: ApplyNameTagTextColor
    for _, v30 in ipairs(p28:GetDescendants()) do
        if v30:IsA("TextLabel") then
            v30.TextColor3 = p29
        elseif v30:IsA("TextButton") then
            v30.TextColor3 = p29
        elseif v30:IsA("TextBox") then
            v30.TextColor3 = p29
        end
    end
end
local function v_u_65(p_u_32, p_u_33, p_u_34) -- name: CreateNameTag
    -- upvalues: (copy) v_u_17, (copy) v_u_27, (copy) Debris, (copy) v_u_19, (ref) v_u_21, (copy) m_Janitor, (copy) ReplicatedStorage, (copy) PlayerGui, (copy) v_u_31, (copy) m_Observers, (copy) HttpService, (copy) m_GetWeaponProperties, (copy) v_u_20
    local v_u_35 = v_u_17[p_u_34]
    if not v_u_35 then
        return nil
    end
    local v_u_36 = v_u_27(p_u_33)
    if not v_u_36 then
        return nil
    end
    local Head = p_u_33:WaitForChild("Head")
    if Head and v_u_36 then
        local v38 = p_u_32.Character == p_u_33 and (p_u_33:IsDescendantOf(workspace) and not p_u_33:IsDescendantOf(Debris))
        if v38 then
            if p_u_33:GetAttribute("Dead") == true then
                v38 = false
            else
                v38 = v_u_36.Health > 0
            end
        end
        if v38 then
            if v_u_19[p_u_32] then
                v_u_19[p_u_32]:Destroy()
                v_u_19[p_u_32] = nil
                if v_u_21 then
                    v_u_21()
                end
            end
            local v39 = m_Janitor.new()
            local v_u_40 = v39:Add(ReplicatedStorage.Assets.Other.Character.Arrow:Clone())
            local v41
            if p_u_33 then
                v41 = p_u_33:GetAttribute("CompetitivePlayerColor") or v_u_35
            else
                v41 = v_u_35
            end
            v_u_40.Arrow.ImageColor3 = v41
            v_u_40.Adornee = Head
            v_u_40.Parent = PlayerGui
            local v_u_42 = v39:Add(ReplicatedStorage.Assets.Other.Character.NameTag:Clone())
            v_u_42.Info.PlayerName.Text = ("%*"):format(p_u_32.DisplayName)
            v_u_42.Info.Weapons.Bomb.Visible = false
            v_u_42.Adornee = Head
            v_u_42.Parent = PlayerGui
            local Health = v_u_42.Info.Health
            local v44 = v_u_36.Health / v_u_36.MaxHealth * 100
            Health.Text = ("%*%%"):format((math.ceil(v44)))
            v_u_31(v_u_42, v41)
            v39:Add(p_u_33:GetAttributeChangedSignal("CompetitivePlayerColor"):Connect(function()
                -- upvalues: (copy) p_u_32, (copy) p_u_33, (copy) p_u_34, (copy) v_u_35, (copy) v_u_40, (copy) v_u_42, (ref) v_u_31
                local v45 = p_u_33
                local v46 = v_u_35
                if v45 then
                    v46 = v45:GetAttribute("CompetitivePlayerColor") or v46
                end
                if v_u_40.Parent and v_u_40:FindFirstChild("Arrow") then
                    v_u_40.Arrow.ImageColor3 = v46
                end
                if v_u_42.Parent then
                    v_u_31(v_u_42, v46)
                end
            end))
            v39:Add(v_u_36:GetPropertyChangedSignal("Health"):Connect(function()
                -- upvalues: (copy) v_u_42, (copy) v_u_36
                if v_u_42 and (v_u_42.Parent and v_u_42:FindFirstChild("Info")) then
                    local Health_0 = v_u_42.Info.Health
                    local v48 = v_u_36.Health / v_u_36.MaxHealth * 100
                    Health_0.Text = ("%*%%"):format((math.ceil(v48)))
                end
            end))
            v39:Add(m_Observers.observeAttribute(p_u_32, "CurrentEquipped", function(p49)
                -- upvalues: (copy) v_u_42, (ref) HttpService, (ref) m_GetWeaponProperties, (copy) p_u_32
                if not (v_u_42 and (v_u_42.Parent and v_u_42:FindFirstChild("Info"))) then
                    return function() end
                end
                local v50 = HttpService:JSONDecode(p49 or "[]")
                if v50 and v50.Name then
                    local v51 = m_GetWeaponProperties(v50.Name)
                    if v_u_42.Info and (v_u_42.Info.Weapons and v_u_42.Info.Weapons.Gun) then
                        v_u_42.Info.Weapons.Gun.Image = v51 and (v51.Icon or "") or ""
                        v_u_42.Info.Weapons.Gun.Visible = v51 or false
                    end
                elseif v_u_42.Info and (v_u_42.Info.Weapons and v_u_42.Info.Weapons.Gun) then
                    v_u_42.Info.Weapons.Gun.Visible = false
                end
                if v50 then
                    v50 = v50.Name == "C4"
                end
                if v_u_42.Info and (v_u_42.Info.Weapons and v_u_42.Info.Weapons.Bomb) then
                    local v52 = p_u_32:GetAttribute("Slot5")
                    local v53
                    if v52 then
                        v53 = HttpService:JSONDecode(v52)
                        if v53 then
                            v53 = v53.Weapon == "C4"
                        end
                    else
                        v53 = false
                    end
                    local Bomb = v_u_42.Info.Weapons.Bomb
                    if v53 then
                        v53 = not v50
                    end
                    Bomb.Visible = v53
                end
                return function()
                    -- upvalues: (ref) v_u_42
                    if v_u_42 and (v_u_42:FindFirstChild("Info") and (v_u_42.Info.Weapons and v_u_42.Info.Weapons.Gun)) then
                        v_u_42.Info.Weapons.Gun.Visible = false
                    end
                end
            end))
            v39:Add(m_Observers.observeAttribute(p_u_32, "Slot5", function(p55)
                -- upvalues: (copy) v_u_42, (ref) HttpService, (copy) p_u_32
                if not (v_u_42 and (v_u_42.Parent and v_u_42:FindFirstChild("Info"))) then
                    return function() end
                end
                local v56 = HttpService:JSONDecode(p55 or "[]")
                if v56 then
                    v56 = v56.Weapon == "C4"
                end
                local v57 = p_u_32:GetAttribute("CurrentEquipped")
                local v58
                if v57 then
                    v58 = HttpService:JSONDecode(v57)
                    if v58 then
                        v58 = v58.Name == "C4"
                    end
                else
                    v58 = false
                end
                if v_u_42.Info and (v_u_42.Info.Weapons and v_u_42.Info.Weapons.Bomb) then
                    local Bomb_0 = v_u_42.Info.Weapons.Bomb
                    if v56 then
                        v56 = not v58
                    end
                    Bomb_0.Visible = v56
                end
                return function()
                    -- upvalues: (ref) v_u_42
                    if v_u_42 and (v_u_42:FindFirstChild("Info") and (v_u_42.Info.Weapons and v_u_42.Info.Weapons.Bomb)) then
                        v_u_42.Info.Weapons.Bomb.Visible = false
                    end
                end
            end))
            v_u_19[p_u_32] = v39
            v_u_20[p_u_32] = {
                ["Arrow"] = v_u_40,
                ["NameTag"] = v_u_42
            }
            v39:Add(function()
                -- upvalues: (ref) v_u_20, (copy) p_u_32
                v_u_20[p_u_32] = nil
            end)
            local function v64() -- name: cleanupIfCharacterBecameStale
                -- upvalues: (copy) p_u_32, (copy) p_u_33, (copy) v_u_36, (ref) Debris, (ref) v_u_19, (ref) v_u_21
                local v60 = p_u_33
                local v61 = v_u_36
                local v62 = p_u_32.Character == v60 and (v60:IsDescendantOf(workspace) and not v60:IsDescendantOf(Debris))
                if v62 then
                    if v60:GetAttribute("Dead") == true then
                        v62 = false
                    else
                        v62 = v61.Health > 0
                    end
                end
                if not v62 then
                    local v63 = p_u_32
                    if v_u_19[v63] then
                        v_u_19[v63]:Destroy()
                        v_u_19[v63] = nil
                        if v_u_21 then
                            v_u_21()
                        end
                    end
                end
            end
            v39:Add(p_u_33:GetAttributeChangedSignal("Dead"):Connect(v64))
            v39:Add(v_u_36.Died:Connect(v64))
            v39:Add(p_u_33.AncestryChanged:Connect(v64))
            if v_u_21 then
                v_u_21()
            end
            return v39
        end
    end
    return nil
end
v_u_21 = function()
    -- upvalues: (copy) v_u_20, (copy) v_u_17, (copy) v_u_31
    for v66, v67 in pairs(v_u_20) do
        local v68 = v66:GetAttribute("Team")
        local v69
        if v68 then
            v69 = v_u_17[v68] or nil
        else
            v69 = nil
        end
        if v68 and v69 then
            local Character = v66.Character
            if Character then
                v69 = Character:GetAttribute("CompetitivePlayerColor") or v69
            end
            if v67.Arrow and v67.Arrow.Parent then
                v67.Arrow.Arrow.ImageColor3 = v69
            end
            if v67.NameTag and v67.NameTag.Parent then
                v_u_31(v67.NameTag, v69)
            end
        end
    end
end
workspace:GetAttributeChangedSignal("ServerGamemode"):Connect(function()
    -- upvalues: (ref) v_u_21
    if v_u_21 then
        v_u_21()
    end
end)
local function v_u_77(_, p71, p72) -- name: characterAdded
    -- upvalues: (copy) m_CameraController, (copy) m_InputController
    local Humanoid_1 = p71:FindFirstChildOfClass("Humanoid")
    if not Humanoid_1 then
        local v74 = tick()
        repeat
            task.wait(0.1)
            Humanoid_1 = p71:FindFirstChildOfClass("Humanoid")
        until Humanoid_1 or tick() - v74 > 5
    end
    if Humanoid_1 then
        m_CameraController.setPerspective(true, false)
        p72:Add(function()
            -- upvalues: (ref) m_CameraController
            m_CameraController.setPerspective(false, true)
        end)
        m_InputController.enableGroup("Gameplay")
        p72:Add(function()
            -- upvalues: (ref) m_InputController
            m_InputController.disableGroup("Gameplay")
        end)
        p72:Add(Humanoid_1.StateChanged:Connect(function(p75, p76)
            -- upvalues: (ref) m_CameraController
            m_CameraController.StateChanged(p75, p76)
        end))
    end
end
local function v_u_80(p78) -- name: SetAllNameTagsVisibility
    -- upvalues: (copy) v_u_20
    for _, v79 in pairs(v_u_20) do
        if v79.Arrow then
            v79.Arrow.Enabled = p78
        end
        if v79.NameTag then
            v79.NameTag.Enabled = p78
        end
    end
end
m_SpectateController.ListenToSpectate:Connect(function(p81) -- name: OnSpectateChanged
    -- upvalues: (copy) v_u_80
    v_u_80(p81 == nil)
end)
return m_Observers.observeCharacter(function(p_u_82, p_u_83)
    -- upvalues: (copy) v_u_18, (copy) m_Janitor, (copy) v_u_19, (ref) v_u_21, (copy) LocalPlayer, (copy) v_u_77, (copy) Players, (copy) v_u_65, (copy) m_CharacterKinematics, (copy) m_Defuser, (copy) m_CharacterHighlight, (copy) m_SpectateController, (copy) m_Observers, (copy) m_RunServiceController
    if v_u_18[p_u_82] then
        v_u_18[p_u_82]:Destroy()
        v_u_18[p_u_82] = nil
    end
    local v_u_84 = m_Janitor.new()
    v_u_18[p_u_82] = v_u_84
    if v_u_19[p_u_82] then
        v_u_19[p_u_82]:Destroy()
        v_u_19[p_u_82] = nil
        if v_u_21 then
            v_u_21()
        end
    end
    if LocalPlayer == p_u_82 then
        v_u_77(p_u_82, p_u_83, v_u_84)
        for v85, _ in pairs(v_u_19) do
            if v_u_19[v85] then
                v_u_19[v85]:Destroy()
                v_u_19[v85] = nil
                if v_u_21 then
                    v_u_21()
                end
            end
        end
        for _, v_u_86 in ipairs(Players:GetPlayers()) do
            if v_u_86 ~= LocalPlayer then
                local Character_0 = v_u_86.Character
                if Character_0 and Character_0:IsDescendantOf(workspace) then
                    local v88 = LocalPlayer:GetAttribute("Team")
                    local v89 = v_u_86:GetAttribute("Team")
                    if v88 == v89 and (v89 == "Terrorists" or v89 == "Counter-Terrorists") and workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                        v_u_65(v_u_86, Character_0, v89)
                        if v_u_18[v_u_86] then
                            v_u_18[v_u_86]:Add(function()
                                -- upvalues: (copy) v_u_86, (ref) v_u_19, (ref) v_u_21
                                local v90 = v_u_86
                                if v_u_19[v90] then
                                    v_u_19[v90]:Destroy()
                                    v_u_19[v90] = nil
                                    if v_u_21 then
                                        v_u_21()
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end
    else
        local v91 = p_u_82:GetAttribute("Team")
        local v92 = v91 == "Counter-Terrorists" and Color3.fromRGB(0, 75, 200) or (v91 == "Terrorists" and Color3.fromRGB(255, 220, 50) or Color3.fromRGB(255, 255, 255))
        v_u_84:Add(function()
            -- upvalues: (ref) m_CharacterKinematics, (copy) p_u_82
            m_CharacterKinematics.cleanup(p_u_82)
        end)
        local v_u_93 = m_Defuser.new(p_u_82, p_u_83)
        v_u_84:Add(function()
            -- upvalues: (copy) v_u_93
            v_u_93:Destroy()
        end)
        local v94 = workspace:GetAttribute("Gamemode")
        local v95 = v91 == "Terrorists" and true or v91 == "Counter-Terrorists"
        local v96
        if v95 then
            v96 = v94 ~= "Deathmatch"
        else
            v96 = v95
        end
        local v97 = LocalPlayer:GetAttribute("Team") == v91
        if v95 then
            local v98
            if v94 == "Deathmatch" then
                v98 = Enum.HighlightDepthMode.Occluded
            else
                v98 = Enum.HighlightDepthMode.AlwaysOnTop
            end
            local v_u_99 = v_u_84:Add(m_CharacterHighlight.new(p_u_83, {
                ["DepthMode"] = nil,
                ["FillColor"] = nil,
                ["OutlineColor"] = nil,
                ["OutlineTransparency"] = 0.4,
                ["FillTransparency"] = 0.7,
                ["DepthMode"] = v98,
                ["FillColor"] = Color3.fromRGB(255, 255, 255),
                ["OutlineColor"] = v92
            }))
            local function v_u_117() -- name: updateHighlightVisible
                -- upvalues: (copy) p_u_83, (copy) p_u_82, (ref) LocalPlayer, (ref) m_SpectateController, (copy) v_u_99
                if p_u_83 and p_u_83.Parent then
                    local v100 = workspace:GetAttribute("Gamemode")
                    local v101 = workspace:GetAttribute("GameState")
                    local v102 = p_u_82:GetAttribute("Team")
                    local v103 = p_u_83:GetAttribute("Dead") == true
                    local v104 = p_u_83:GetAttribute("Invincible") == true
                    local v105 = LocalPlayer:GetAttribute("IsSpectating") == true
                    local v106 = m_SpectateController.GetPlayer()
                    local v107
                    if v106 then
                        v107 = v106:GetAttribute("Team")
                    else
                        v107 = v106
                    end
                    local v108 = m_SpectateController.GetCurrentSpectateInstance()
                    local v109
                    if v108 == nil then
                        v109 = false
                    else
                        v109 = v108.PerspectiveState == "First-Person"
                    end
                    local v110 = v106 == p_u_82
                    local v111 = LocalPlayer:GetAttribute("Team") == v102
                    if v105 then
                        if not v109 then
                            v110 = v109
                        end
                    else
                        v110 = v105
                    end
                    local v112
                    if v100 == "Deathmatch" then
                        v112 = false
                    elseif v105 then
                        if v107 == v102 then
                            v112 = not v110
                        else
                            v112 = false
                        end
                    else
                        v112 = v105
                    end
                    if v111 then
                        v105 = v111
                    elseif v105 then
                        v105 = v107 == v102
                    end
                    local v113 = v104 and not v110
                    if v113 then
                        v113 = v100 == "Deathmatch" and true or (v101 == "Warmup" and true or v105)
                    end
                    local v114
                    if v113 and v101 == "Warmup" then
                        v114 = Enum.HighlightDepthMode.Occluded
                    elseif v100 == "Deathmatch" then
                        v114 = Enum.HighlightDepthMode.Occluded
                    else
                        v114 = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    if v_u_99.Highlight and v_u_99.Highlight.Parent then
                        v_u_99.Highlight.DepthMode = v114
                    end
                    if v103 then
                        v_u_99.OutlineOnly = false
                        v_u_99:UpdateState(false)
                    else
                        local v115 = v_u_99
                        local v116
                        if v112 then
                            v116 = not v113
                        else
                            v116 = v112
                        end
                        v115.OutlineOnly = v116
                        v_u_99:UpdateState(v113 or v112)
                    end
                else
                    return
                end
            end
            v_u_84:Add(m_Observers.observeAttribute(p_u_83, "Dead", function(_)
                -- upvalues: (copy) v_u_117, (copy) v_u_99
                v_u_117()
                return function()
                    -- upvalues: (ref) v_u_99
                    v_u_99:UpdateState(false)
                end
            end))
            v_u_84:Add(m_Observers.observeAttribute(p_u_83, "Invincible", function(_)
                -- upvalues: (copy) v_u_117, (copy) v_u_99
                v_u_117()
                return function()
                    -- upvalues: (ref) v_u_99
                    v_u_99:UpdateState(false)
                end
            end))
            v_u_84:Add(m_Observers.observeAttribute(LocalPlayer, "IsSpectating", function()
                -- upvalues: (copy) v_u_117
                v_u_117()
                return function() end
            end))
            v_u_84:Add(m_SpectateController.ListenToSpectate:Connect(function()
                -- upvalues: (copy) v_u_117
                v_u_117()
            end))
            v_u_84:Add(m_Observers.observeAttribute(LocalPlayer, "Team", function()
                -- upvalues: (copy) v_u_117
                v_u_117()
                return function() end
            end))
            v_u_84:Add(m_Observers.observeAttribute(p_u_82, "Team", function()
                -- upvalues: (copy) v_u_117
                v_u_117()
                return function() end
            end))
            v_u_84:Add(m_Observers.observeAttribute(workspace, "GameState", function()
                -- upvalues: (copy) v_u_117
                v_u_117()
                return function() end
            end))
            local v_u_118 = 0
            v_u_99.Janitor:Add(m_RunServiceController.BindToHeartbeat(("Observers.Character.HighlightSync.%*"):format(p_u_82.UserId), function(p119)
                -- upvalues: (ref) v_u_118, (ref) LocalPlayer, (copy) p_u_83, (copy) v_u_117
                v_u_118 = v_u_118 + p119
                if v_u_118 >= 0.2 then
                    v_u_118 = 0
                    if LocalPlayer:GetAttribute("IsSpectating") == true or p_u_83:GetAttribute("Invincible") == true then
                        v_u_117()
                    end
                end
            end))
            v_u_117()
        end
        if v97 and v96 then
            v_u_65(p_u_82, p_u_83, v91)
            v_u_84:Add(function()
                -- upvalues: (copy) p_u_82, (ref) v_u_19, (ref) v_u_21
                local v120 = p_u_82
                if v_u_19[v120] then
                    v_u_19[v120]:Destroy()
                    v_u_19[v120] = nil
                    if v_u_21 then
                        v_u_21()
                    end
                end
            end)
        end
        if LocalPlayer:GetAttribute("IsSpectating") and not m_SpectateController.GetCurrentSpectateInstance() then
            m_SpectateController.Next()
        end
    end
    return function()
        -- upvalues: (copy) v_u_84
        v_u_84:Destroy()
    end
end)
