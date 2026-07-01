-- Decompiled with Medal

local v1 = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_InputController = require(script.Parent.InputController)
local m_DataController = require(script.Parent.DataController)
local m_ConfigController = require(script.Parent.ConfigController)
local m_RunServiceController = require(script.Parent.RunServiceController)
local m_GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local v_u_15 = {}
local v_u_16 = nil
local v_u_17 = 0
local v_u_18 = nil
local v_u_19 = 0
local Hints = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("UI"):WaitForChild("Hints")
local Static = Hints:WaitForChild("Static")
local Ranged = Hints:WaitForChild("Ranged")
local Middle = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui"):WaitForChild("Gameplay"):WaitForChild("Middle")
local v_u_24 = {
    ["BuyMenu"] = {
        ["Type"] = "Static",
        ["Action"] = "Buy Menu",
        ["Blurb"] = "Open the Buy Menu!"
    },
    ["PlantAction"] = {
        ["Type"] = "Static",
        ["Action"] = "Fire",
        ["Blurb"] = "Plant the Bomb!"
    },
    ["EquipBomb"] = {
        ["Type"] = "Static",
        ["Action"] = "Explosives & Traps",
        ["Blurb"] = "Equip the Bomb!"
    },
    ["Inspect"] = {
        ["Type"] = "Static",
        ["Action"] = "Inspect",
        ["Blurb"] = "Inspect"
    },
    ["Reload"] = {
        ["Type"] = "Static",
        ["Action"] = "Reload",
        ["Blurb"] = "Reload your Weapon!"
    },
    ["Use"] = {
        ["Type"] = "Static",
        ["Action"] = "Use",
        ["Blurb"] = ""
    },
    ["Plant"] = {
        ["Type"] = "Ranged",
        ["Action"] = "Plant",
        ["Blurb"] = "Plant the Bomb!",
        ["HideDistance"] = 5
    },
    ["Defuse"] = {
        ["Type"] = "Ranged",
        ["Action"] = "Defuse",
        ["Blurb"] = "Defuse the Bomb!",
        ["HideDistance"] = 5
    },
    ["Rescue"] = {
        ["Type"] = "Ranged",
        ["Action"] = "Rescue",
        ["Blurb"] = "Rescue the Hostage!",
        ["HideDistance"] = 5
    },
    ["Return"] = {
        ["Type"] = "Ranged",
        ["Action"] = "Return",
        ["Blurb"] = "Return the Hostage",
        ["HideDistance"] = 5
    },
    ["Defend"] = {
        ["Type"] = "Ranged",
        ["Action"] = "Defend",
        ["Blurb"] = "Defend!",
        ["HideDistance"] = 0
    },
    ["HelpPlant"] = {
        ["Type"] = "Ranged",
        ["Action"] = "HelpPlant",
        ["Blurb"] = "Help Plant the Bomb",
        ["HideDistance"] = 0
    },
    ["DefendHostage"] = {
        ["Type"] = "Ranged",
        ["Action"] = "Defend",
        ["Blurb"] = "Defend the Hostages!",
        ["HideDistance"] = 0
    }
}
local function v_u_31() -- name: teammateBombCarrier
    -- upvalues: (copy) LocalPlayer, (copy) Players, (copy) HttpService
    local v25 = LocalPlayer:GetAttribute("Team")
    if not v25 then
        return nil
    end
    for _, v26 in ipairs(Players:GetPlayers()) do
        if v26 ~= LocalPlayer and v26:GetAttribute("Team") == v25 then
            local v27 = v26:GetAttribute("Slot5")
            local v28
            if typeof(v27) == "string" then
                local v29
                v29, v28 = pcall(HttpService.JSONDecode, HttpService, v27)
                if not v29 or typeof(v28) ~= "table" then
                    v28 = nil
                end
            else
                v28 = nil
            end
            local v30
            if v28 == nil then
                v30 = false
            else
                v30 = v28.Weapon == "C4"
            end
            if v30 then
                return v26
            end
        end
    end
    return nil
end
local function v_u_49(p32, p33) -- name: distanceToOBB
    local v34 = p32.CFrame:PointToObjectSpace(p33)
    local v35 = p32.Size * 0.5
    local v36 = v34.X
    local v37 = -v35.X
    local v38 = v35.X
    local v39 = math.clamp(v36, v37, v38)
    local v40 = v34.Y
    local v41 = -v35.Y
    local v42 = v35.Y
    local v43 = math.clamp(v40, v41, v42)
    local v44 = v34.Z
    local v45 = -v35.Z
    local v46 = v35.Z
    local v47 = math.clamp(v44, v45, v46)
    local v48 = Vector3.new(v39, v43, v47)
    return (p32.CFrame:PointToWorldSpace(v48) - p33).Magnitude
end
local function v_u_53() -- name: bombSiteParts
    local v50 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Zones")
    if v50 then
        v50 = workspace.Map.Zones:FindFirstChild("Sites")
    end
    local v51 = {}
    if not v50 then
        return v51
    end
    for _, v52 in ipairs(v50:GetDescendants()) do
        if v52:IsA("BasePart") and v52:GetAttribute("Site") then
            table.insert(v51, v52)
        end
    end
    return v51
end
local function v_u_57() -- name: bombSiteRepresentatives
    -- upvalues: (copy) v_u_53
    local v54 = {}
    for _, v55 in ipairs((v_u_53())) do
        local v56 = v55:GetAttribute("Site")
        if not v54[v56] then
            v54[v56] = v55
        end
    end
    return v54
end
local function v_u_61() -- name: isInPlantZone
    -- upvalues: (copy) LocalPlayer, (copy) v_u_53, (copy) v_u_49
    local Character = LocalPlayer.Character
    local v59
    if Character then
        v59 = Character.PrimaryPart or Character:FindFirstChild("HumanoidRootPart") or nil
    else
        v59 = nil
    end
    if not v59 then
        return false
    end
    for _, v60 in ipairs((v_u_53())) do
        if v_u_49(v60, v59.Position) <= 0.25 then
            return true
        end
    end
    return false
end
local v_u_62 = nil
local v_u_63 = nil
local function v_u_88(p64) -- name: updateRangedHint
    -- upvalues: (ref) v_u_62, (copy) LocalPlayer, (ref) v_u_63, (copy) CurrentCamera
    local target = p64.target
    if target and target.Parent then
        local Icon = p64.icon or p64.ui:FindFirstChild("Icon")
        local Arrow = p64.arrow or p64.ui:FindFirstChild("Arrow")
        local Attention = p64.attentionFrame or p64.ui:FindFirstChild("Attention")
        if Icon and (Arrow and Attention) then
            p64.icon = Icon
            p64.arrow = Arrow
            p64.attentionFrame = Attention
            local Position = target.Position
            if p64.promoteOnClose and p64.hideDistance > 0 then
                local Character_0 = LocalPlayer.Character
                local v71 = not Character_0 or Character_0.PrimaryPart or (Character_0:FindFirstChild("HumanoidRootPart") or nil)
                if v71 and (v71.Position - Position).Magnitude <= p64.hideDistance then
                    local hintType = p64.hintType
                    v_u_62(p64.hintId)
                    if hintType == "Defuse" then
                        v_u_63("Use", nil, "Defuse the Bomb!", "Use", false)
                        task.delay(3, function()
                            -- upvalues: (ref) v_u_62
                            v_u_62("Use")
                        end)
                        return
                    elseif hintType == "Rescue" then
                        v_u_63("Use", nil, "Rescue the Hostage!", "Use", false)
                        task.delay(3, function()
                            -- upvalues: (ref) v_u_62
                            v_u_62("Use")
                        end)
                    elseif hintType == "Plant" then
                        v_u_63("PlantAction", nil, nil, "PlantAction", false)
                    end
                end
            end
            local CFrame = CurrentCamera.CFrame
            local ViewportSize = CurrentCamera.ViewportSize
            local v75, v76 = CurrentCamera:WorldToViewportPoint(Position)
            local v77
            if v76 then
                local ViewportSize_0 = CurrentCamera.ViewportSize
                v77 = v75.X >= 100 and (v75.X <= ViewportSize_0.X - 100 and (v75.Y >= 100 and v75.Y <= ViewportSize_0.Y - 100))
            else
                v77 = false
            end
            if v77 then
                p64.ui.BackgroundTransparency = 0.5
                p64.ui.Position = UDim2.new(0, v75.X, 0, v75.Y - 60 - 30)
                p64.ui.AnchorPoint = Vector2.new(0.5, 0.5)
                Attention.Size = UDim2.new(0.75, 0, 0.75, 0)
                Attention.Visible = true
                Arrow.Visible = false
                Icon.Visible = false
            else
                p64.ui.BackgroundTransparency = 1
                local Unit = (Position - CFrame.Position).Unit
                local v80 = -Unit:Dot(CFrame.UpVector)
                local v81 = Unit:Dot(CFrame.RightVector)
                local v82 = math.atan2(v80, v81)
                local v83 = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
                local v84 = ViewportSize.X
                local v85 = ViewportSize.Y
                local v86 = math.min(v84, v85) / 2 - 60
                p64.ui.Position = UDim2.new(0, v83.X + math.cos(v82) * v86, 0, v83.Y + math.sin(v82) * v86 - 30)
                p64.ui.AnchorPoint = Vector2.new(0.5, 0.5)
                Arrow.Visible = true
                Arrow.Position = UDim2.new(0.5, 0, 0.5, 0)
                Arrow.AnchorPoint = Vector2.new(0.5, 0.5)
                Arrow.Rotation = math.deg(v82) - 90
                local v87 = v82 + 3.141592653589793
                Icon.Position = UDim2.new(0.5, math.cos(v87) * 55, 0.5, math.sin(v87) * 55)
                Icon.Visible = true
                Attention.Visible = false
            end
            p64.ui.Visible = true
        end
    else
        v_u_62(p64.hintId)
        return
    end
end
v_u_63 = function(p89, p90, p91, p92, p93)
    -- upvalues: (copy) v_u_24, (copy) m_DataController, (copy) LocalPlayer, (copy) m_GameState, (copy) v_u_15, (ref) v_u_62, (copy) Static, (copy) m_GetPreferenceColor, (copy) m_InputController, (copy) Middle, (copy) Ranged, (ref) v_u_16, (copy) m_RunServiceController, (copy) v_u_88
    local v94 = v_u_24[p89]
    if v94 then
        local v95, v96 = pcall(m_DataController.Get, LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages")
        if not v95 or v96 ~= false then
            local v97 = m_GameState.GetState()
            if p89 == "BuyMenu" then
                if v97 ~= "Buy Period" and (v97 ~= "Round In Progress" and v97 ~= "Warmup") then
                    return
                end
            elseif v97 ~= "Round In Progress" then
                return
            end
            local v98 = p92 or p89
            local v99 = v_u_15[v98]
            if v99 and (v99.hintType == p89 and v99.target == p90) then
                return
            else
                if v99 then
                    v_u_62(v98)
                end
                if v94.Type == "Static" then
                    local v100 = Static:Clone()
                    v100.Left.BackgroundColor3 = m_GetPreferenceColor()
                    v100.Right.BackgroundColor3 = m_GetPreferenceColor()
                    v100.Instructions.Text = p91 or v94.Blurb
                    v100.ControlIcon.KeycapIcon.Control.Text = m_InputController.GetActionKeybind(v94.Action) or "???"
                    v_u_15[v98] = {
                        ["ui"] = nil,
                        ["target"] = nil,
                        ["hintType"] = nil,
                        ["hintId"] = nil,
                        ["hideDistance"] = 0,
                        ["promoteOnClose"] = false,
                        ["ui"] = v100,
                        ["hintType"] = p89,
                        ["hintId"] = v98
                    }
                    v100:SetAttribute("Type", p89)
                    v100.Position = v100.Position - UDim2.fromOffset(0, 30)
                    v100.Parent = Middle
                    v100.Visible = true
                elseif v94.Type == "Ranged" and p90 then
                    local v101 = Ranged:Clone()
                    v_u_15[v98] = {
                        ["ui"] = v101,
                        ["target"] = p90,
                        ["hintType"] = p89,
                        ["hintId"] = v98,
                        ["hideDistance"] = v94.HideDistance or 0,
                        ["promoteOnClose"] = p93 == true,
                        ["icon"] = v101:FindFirstChild("Icon"),
                        ["arrow"] = v101:FindFirstChild("Arrow"),
                        ["attentionFrame"] = v101:FindFirstChild("Attention")
                    }
                    v101.Left.BackgroundColor3 = m_GetPreferenceColor()
                    v101.Right.BackgroundColor3 = m_GetPreferenceColor()
                    v101.Attention.Instructions.Text = p91 or v94.Blurb
                    if not v_u_16 then
                        v_u_16 = m_RunServiceController.BindToRenderStep("HintController.RenderRangedHints", function()
                            -- upvalues: (ref) v_u_15, (ref) v_u_16, (ref) v_u_88
                            local v102 = {}
                            for _, v103 in pairs(v_u_15) do
                                if v103.target then
                                    table.insert(v102, v103)
                                end
                            end
                            if #v102 == 0 then
                                v_u_16:Disconnect()
                                v_u_16 = nil
                            else
                                for _, v104 in ipairs(v102) do
                                    v_u_88(v104)
                                end
                            end
                        end)
                    end
                    v101:SetAttribute("Type", p89)
                    v101.Parent = Middle
                    v101.Visible = true
                end
            end
        end
    end
end
v_u_62 = function(p105)
    -- upvalues: (copy) v_u_15, (ref) v_u_16
    if p105 then
        local v106 = v_u_15[p105]
        if v106 then
            v106.ui:Destroy()
            v_u_15[p105] = nil
        end
    else
        for v107, v108 in pairs(v_u_15) do
            v108.ui:Destroy()
            v_u_15[v107] = nil
        end
        if v_u_16 then
            v_u_16:Disconnect()
            v_u_16 = nil
        end
    end
end
function v1.createHint(_, p109, p110, p111, p112, p113) -- name: createHint
    -- upvalues: (ref) v_u_63
    v_u_63(p109, p110, p111, p112, p113)
end
function v1.clearHint(_, p114) -- name: clearHint
    -- upvalues: (ref) v_u_62
    v_u_62(p114)
end
local function v_u_124(p115, p116) -- name: reconcile
    -- upvalues: (copy) v_u_15, (ref) v_u_62, (ref) v_u_63
    local v117 = {}
    for v118, v119 in pairs(v_u_15) do
        if p116(v118) then
            local v120 = p115[v118]
            if not v120 or v120.target ~= v119.target then
                table.insert(v117, v118)
            end
        end
    end
    for _, v121 in ipairs(v117) do
        v_u_62(v121)
    end
    for v122, v123 in pairs(p115) do
        if not v_u_15[v122] then
            v_u_63(v123.type, v123.target, nil, v122, false)
        end
    end
end
local function v_u_126(p125) -- name: isDefusalManaged
    return (p125 == "HelpPlant" or (p125 == "PlantAction" or (p125 == "EquipBomb" or string.sub(p125, 1, 6) == "Plant_"))) and true or string.sub(p125, 1, 7) == "Defend_"
end
local function v_u_151() -- name: computeDefusalDesired
    -- upvalues: (ref) v_u_18, (copy) m_ConfigController, (copy) m_GameState, (ref) v_u_19, (copy) m_DataController, (copy) LocalPlayer, (copy) CollectionService, (copy) v_u_57, (copy) HttpService, (copy) v_u_61, (copy) v_u_31
    local v127 = {}
    local v128
    if v_u_18 == nil or v_u_18 > 1 or not m_ConfigController.Get("IsNewOnboarding") then
        v128 = false
    else
        local v129 = m_GameState.GetState()
        local v130 = v_u_19
        if v129 == "Buy Period" or v129 == "Warmup" then
            v130 = v130 + 1
        end
        v128 = v130 <= 1
    end
    if v128 and (m_GameState.GetState() == "Round In Progress" and workspace:GetAttribute("Gamemode") == "Bomb Defusal") then
        local v131, v132 = pcall(m_DataController.Get, LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages")
        if not v131 or v132 ~= false then
            local v133 = LocalPlayer.Character
            if v133 then
                v133 = v133:FindFirstChildOfClass("Humanoid")
            end
            local v134
            if v133 == nil then
                v134 = false
            else
                v134 = v133.Health > 0
            end
            if v134 and #CollectionService:GetTagged("Bomb") <= 0 then
                local v135 = LocalPlayer:GetAttribute("Team")
                local v136 = v_u_57()
                if v135 == "Terrorists" then
                    local v137 = LocalPlayer:GetAttribute("Slot5")
                    local v138
                    if typeof(v137) == "string" then
                        local v139
                        v139, v138 = pcall(HttpService.JSONDecode, HttpService, v137)
                        if not v139 or typeof(v138) ~= "table" then
                            v138 = nil
                        end
                    else
                        v138 = nil
                    end
                    local v140
                    if v138 == nil then
                        v140 = false
                    else
                        v140 = v138.Weapon == "C4"
                    end
                    if v140 then
                        if v_u_61() then
                            local v141 = LocalPlayer:GetAttribute("CurrentEquipped")
                            local v142
                            if typeof(v141) == "string" then
                                local v143
                                v143, v142 = pcall(HttpService.JSONDecode, HttpService, v141)
                                if not v143 or typeof(v142) ~= "table" then
                                    v142 = nil
                                end
                            else
                                v142 = nil
                            end
                            local v144
                            if v142 == nil then
                                v144 = false
                            else
                                v144 = v142.Name == "C4"
                            end
                            if v144 then
                                v127.PlantAction = {
                                    ["type"] = "PlantAction",
                                    ["target"] = nil
                                }
                                return v127
                            else
                                v127.EquipBomb = {
                                    ["type"] = "EquipBomb",
                                    ["target"] = nil
                                }
                                return v127
                            end
                        else
                            for v145, v146 in pairs(v136) do
                                v127["Plant_" .. v145] = {
                                    ["type"] = "Plant",
                                    ["target"] = nil,
                                    ["target"] = v146
                                }
                            end
                            return v127
                        end
                    end
                    local v147 = v_u_31()
                    local v148 = v147 and v147.Character
                    if v148 then
                        v148 = v147.Character.PrimaryPart
                    end
                    if v148 then
                        v127.HelpPlant = {
                            ["type"] = "HelpPlant",
                            ["target"] = nil,
                            ["target"] = v148
                        }
                        return v127
                    end
                elseif v135 == "Counter-Terrorists" then
                    for v149, v150 in pairs(v136) do
                        v127["Defend_" .. v149] = {
                            ["type"] = "Defend",
                            ["target"] = nil,
                            ["target"] = v150
                        }
                    end
                end
                return v127
            end
        end
    end
    return v127
end
local function v_u_152() -- name: reconcileDefusal
    -- upvalues: (copy) v_u_124, (copy) v_u_151, (copy) v_u_126
    v_u_124(v_u_151(), v_u_126)
end
task.spawn(function()
    -- upvalues: (copy) v_u_124, (copy) v_u_151, (copy) v_u_126
    while true do
        v_u_124(v_u_151(), v_u_126)
        task.wait(0.25)
    end
end)
local function v_u_154(p153) -- name: isHostageManaged
    return (p153 == "Return" or string.sub(p153, 1, 7) == "Rescue_") and true or string.sub(p153, 1, 14) == "DefendHostage_"
end
local function v_u_162() -- name: closestHostageReturnPart
    -- upvalues: (copy) LocalPlayer
    local v155 = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Zones")
    if v155 then
        v155 = workspace.Map.Zones:FindFirstChild("Hints")
    end
    local Character_1 = LocalPlayer.Character
    local v157 = not Character_1 or Character_1.PrimaryPart or (Character_1:FindFirstChild("HumanoidRootPart") or nil)
    if not (v155 and v157) then
        return nil
    end
    local v158 = (1 / 0)
    local v159 = nil
    for _, v160 in ipairs(v155:GetChildren()) do
        if v160:IsA("BasePart") then
            local Magnitude = (v160.Position - v157.Position).Magnitude
            if Magnitude < v158 then
                v159 = v160
                v158 = Magnitude
            end
        end
    end
    return v159
end
local function v_u_175() -- name: computeHostageDesired
    -- upvalues: (ref) v_u_18, (copy) m_ConfigController, (copy) m_GameState, (ref) v_u_19, (copy) m_DataController, (copy) LocalPlayer, (copy) v_u_162, (copy) CollectionService
    local v163 = {}
    local v164
    if v_u_18 == nil or v_u_18 > 1 or not m_ConfigController.Get("IsNewOnboarding") then
        v164 = false
    else
        local v165 = m_GameState.GetState()
        local v166 = v_u_19
        if v165 == "Buy Period" or v165 == "Warmup" then
            v166 = v166 + 1
        end
        v164 = v166 <= 1
    end
    if v164 and (m_GameState.GetState() == "Round In Progress" and workspace:GetAttribute("Gamemode") == "Hostage Rescue") then
        local v167, v168 = pcall(m_DataController.Get, LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages")
        if not v167 or v168 ~= false then
            local v169 = LocalPlayer.Character
            if v169 then
                v169 = v169:FindFirstChildOfClass("Humanoid")
            end
            local v170
            if v169 == nil then
                v170 = false
            else
                v170 = v169.Health > 0
            end
            if v170 then
                local v171 = LocalPlayer:GetAttribute("Team")
                if v171 == "Counter-Terrorists" then
                    if LocalPlayer:GetAttribute("IsCarryingHostage") ~= true then
                        for _, v172 in ipairs(CollectionService:GetTagged("Hostage")) do
                            if v172:GetAttribute("CanRescue") and v172.PrimaryPart then
                                v163["Rescue_" .. v172.Name] = {
                                    ["type"] = "Rescue",
                                    ["target"] = nil,
                                    ["target"] = v172.PrimaryPart
                                }
                            end
                        end
                        return v163
                    end
                    local v173 = v_u_162()
                    if v173 then
                        v163.Return = {
                            ["type"] = "Return",
                            ["target"] = nil,
                            ["target"] = v173
                        }
                        return v163
                    end
                elseif v171 == "Terrorists" then
                    for _, v174 in ipairs(CollectionService:GetTagged("Hostage")) do
                        if v174:GetAttribute("CanRescue") and v174.PrimaryPart then
                            v163["DefendHostage_" .. v174.Name] = {
                                ["type"] = "DefendHostage",
                                ["target"] = nil,
                                ["target"] = v174.PrimaryPart
                            }
                        end
                    end
                end
                return v163
            end
        end
    end
    return v163
end
local function v_u_176() -- name: reconcileHostage
    -- upvalues: (copy) v_u_124, (copy) v_u_175, (copy) v_u_154
    v_u_124(v_u_175(), v_u_154)
end
task.spawn(function()
    -- upvalues: (copy) v_u_124, (copy) v_u_175, (copy) v_u_154
    while true do
        v_u_124(v_u_175(), v_u_154)
        task.wait(1)
    end
end)
local function v_u_184() -- name: tryShowBuyMenu
    -- upvalues: (ref) v_u_18, (copy) m_ConfigController, (copy) m_GameState, (ref) v_u_19, (copy) LocalPlayer, (copy) Middle, (ref) v_u_17, (copy) v_u_15, (ref) v_u_63
    local v177
    if v_u_18 == nil or v_u_18 > 1 or not m_ConfigController.Get("IsNewOnboarding") then
        v177 = false
    else
        local v178 = m_GameState.GetState()
        local v179 = v_u_19
        if v178 == "Buy Period" or v178 == "Warmup" then
            v179 = v179 + 1
        end
        v177 = v179 <= 1
    end
    if v177 then
        local v180 = LocalPlayer:GetAttribute("Team")
        if v180 == "Terrorists" or v180 == "Counter-Terrorists" then
            local v181 = LocalPlayer.Character
            if v181 then
                v181 = v181:FindFirstChildOfClass("Humanoid")
            end
            local v182
            if v181 == nil then
                v182 = false
            else
                v182 = v181.Health > 0
            end
            if v182 then
                local BuyMenu = Middle:FindFirstChild("BuyMenu")
                if not (BuyMenu and BuyMenu:IsA("GuiObject")) then
                    BuyMenu = nil
                end
                if not (BuyMenu and BuyMenu.Visible) then
                    v_u_17 = tick() + 5
                    if not v_u_15.BuyMenu then
                        v_u_63("BuyMenu", nil, nil, "BuyMenu", false)
                    end
                end
            end
        end
    end
end
LocalPlayer.CharacterAdded:Connect(v_u_184)
LocalPlayer:GetAttributeChangedSignal("Team"):Connect(v_u_184)
if LocalPlayer.Character then
    task.spawn(v_u_184)
end
task.spawn(function()
    -- upvalues: (copy) v_u_15, (ref) v_u_18, (copy) m_ConfigController, (copy) m_GameState, (ref) v_u_19, (ref) v_u_62, (ref) v_u_17, (copy) Middle
    while true do
        if v_u_15.BuyMenu then
            local v185
            if v_u_18 == nil or v_u_18 > 1 or not m_ConfigController.Get("IsNewOnboarding") then
                v185 = false
            else
                local v186 = m_GameState.GetState()
                local v187 = v_u_19
                if v186 == "Buy Period" or v186 == "Warmup" then
                    v187 = v187 + 1
                end
                v185 = v187 <= 1
            end
            if v185 then
                if v_u_17 <= tick() then
                    local v188 = m_GameState.GetState()
                    if v188 ~= "Buy Period" and v188 ~= "Warmup" then
                        v_u_62("BuyMenu")
                    end
                end
            else
                v_u_62("BuyMenu")
            end
        end
        local BuyMenu_0 = Middle:FindFirstChild("BuyMenu")
        if not (BuyMenu_0 and BuyMenu_0:IsA("GuiObject")) then
            BuyMenu_0 = nil
        end
        if BuyMenu_0 and (BuyMenu_0.Visible and v_u_15.BuyMenu) then
            local v190 = m_GameState.GetState()
            if v190 ~= "Buy Period" and v190 ~= "Warmup" then
                v_u_62("BuyMenu")
            end
        end
        task.wait(0.5)
    end
end)
m_Remotes.Hints.BombSiteEntered.Listen(function(p191)
    -- upvalues: (ref) v_u_18, (copy) m_ConfigController, (copy) m_GameState, (ref) v_u_19, (copy) CollectionService, (ref) v_u_63
    if p191 and p191.action == "Defuse" then
        local v192
        if v_u_18 == nil or v_u_18 > 1 or not m_ConfigController.Get("IsNewOnboarding") then
            v192 = false
        else
            local v193 = m_GameState.GetState()
            local v194 = v_u_19
            if v193 == "Buy Period" or v193 == "Warmup" then
                v194 = v194 + 1
            end
            v192 = v194 <= 1
        end
        if v192 then
            local v195 = CollectionService:GetTagged("Bomb")
            if #v195 == 1 then
                local PrimaryPart = v195[1].PrimaryPart
                if PrimaryPart then
                    v_u_63("Defuse", PrimaryPart, nil, "Defuse", true)
                end
            end
        end
    end
end)
m_Remotes.Hints.ClearHint.Listen(function(p197)
    -- upvalues: (ref) v_u_62, (copy) v_u_15
    if p197 then
        p197 = p197.hintType
    end
    if p197 == nil or p197 == "" then
        v_u_62()
    else
        local v198 = {}
        for v199, v200 in pairs(v_u_15) do
            if v199 == p197 or v200.hintType == p197 then
                table.insert(v198, v199)
            end
        end
        for _, v201 in ipairs(v198) do
            v_u_62(v201)
        end
    end
end)
local function v_u_205() -- name: clearOnboardingHints
    -- upvalues: (copy) v_u_15, (ref) v_u_62
    local v202 = {}
    for v203 in pairs(v_u_15) do
        if v203 == "BuyMenu" or (v203 == "Defuse" or v203 == "Use") or (v203 == "HelpPlant" or (v203 == "PlantAction" or (v203 == "EquipBomb" or string.sub(v203, 1, 6) == "Plant_")) or string.sub(v203, 1, 7) == "Defend_" or (v203 == "Return" or string.sub(v203, 1, 7) == "Rescue_" or string.sub(v203, 1, 14) == "DefendHostage_")) then
            table.insert(v202, v203)
        end
    end
    for _, v204 in ipairs(v202) do
        v_u_62(v204)
    end
end
m_Remotes.Character.CharacterDied.Listen(function()
    -- upvalues: (ref) v_u_62
    v_u_62()
end)
m_DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Enable Game Instructor Messages", function(p206)
    -- upvalues: (ref) v_u_62
    if p206 == false then
        v_u_62()
    end
end)
m_ConfigController.OnChanged("IsNewOnboarding", function()
    -- upvalues: (copy) v_u_205, (copy) v_u_184, (copy) v_u_152, (copy) v_u_176
    v_u_205()
    task.spawn(v_u_184)
    task.spawn(v_u_152)
    task.spawn(v_u_176)
end)
v_u_19 = m_GameState.GetState() == "Round In Progress" and 1 or v_u_19
m_GameState.ListenToState(function(p207, p208)
    -- upvalues: (ref) v_u_19, (copy) v_u_15, (ref) v_u_62, (ref) v_u_18, (copy) m_ConfigController, (copy) m_GameState, (ref) v_u_17, (copy) v_u_184, (copy) v_u_152, (copy) v_u_176
    if p208 == "Round In Progress" and (p207 ~= nil and p207 ~= "Round In Progress") then
        v_u_19 = v_u_19 + 1
    end
    if p208 ~= "Round In Progress" then
        local v209 = {}
        for v210 in pairs(v_u_15) do
            if v210 ~= "BuyMenu" then
                table.insert(v209, v210)
            end
        end
        for _, v211 in ipairs(v209) do
            v_u_62(v211)
        end
    end
    if v_u_15.BuyMenu then
        local v212
        if v_u_18 == nil or v_u_18 > 1 or not m_ConfigController.Get("IsNewOnboarding") then
            v212 = false
        else
            local v213 = m_GameState.GetState()
            local v214 = v_u_19
            if v213 == "Buy Period" or v213 == "Warmup" then
                v214 = v214 + 1
            end
            v212 = v214 <= 1
        end
        if v212 then
            if v_u_17 <= tick() then
                local v215 = m_GameState.GetState()
                if v215 ~= "Buy Period" and v215 ~= "Warmup" then
                    v_u_62("BuyMenu")
                end
            end
        else
            v_u_62("BuyMenu")
        end
    end
    if p208 == "Round In Progress" then
        task.spawn(v_u_184)
        task.spawn(v_u_152)
        task.spawn(v_u_176)
    elseif p208 == "Buy Period" or p208 == "Warmup" then
        task.spawn(v_u_184)
    end
end)
m_DataController.CreateListener(LocalPlayer, "Statistics.Joins", function(p216)
    -- upvalues: (ref) v_u_18, (copy) v_u_184, (copy) v_u_152, (copy) v_u_176
    v_u_18 = typeof(p216) == "number" and p216 and p216 or nil
    task.spawn(v_u_184)
    task.spawn(v_u_152)
    task.spawn(v_u_176)
end)
CollectionService:GetInstanceAddedSignal("Bomb"):Connect(function()
    -- upvalues: (copy) v_u_152
    task.spawn(v_u_152)
end)
CollectionService:GetInstanceRemovedSignal("Bomb"):Connect(function()
    -- upvalues: (ref) v_u_62, (copy) v_u_152
    v_u_62("Defuse")
    v_u_62("Use")
    task.spawn(v_u_152)
end)
LocalPlayer:GetAttributeChangedSignal("Slot5"):Connect(function()
    -- upvalues: (copy) v_u_152
    task.spawn(v_u_152)
end)
LocalPlayer:GetAttributeChangedSignal("CurrentEquipped"):Connect(function()
    -- upvalues: (copy) v_u_152
    task.spawn(v_u_152)
end)
LocalPlayer:GetAttributeChangedSignal("IsCarryingHostage"):Connect(function()
    -- upvalues: (copy) v_u_176
    task.spawn(v_u_176)
end)
return v1
