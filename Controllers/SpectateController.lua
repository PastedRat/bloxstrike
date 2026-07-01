-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local m_InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
local m_Spectate = require(ReplicatedStorage.Classes.Spectate)
local m_Freecam = require(ReplicatedStorage.Classes.Freecam)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Promise = require(ReplicatedStorage.Shared.Promise)
local m_Signal = require(ReplicatedStorage.Packages.Signal)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local CurrentCamera = workspace.CurrentCamera
local v_u_19 = m_Signal.new()
v_u_1.ListenToSpectate = v_u_19
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local v_u_21 = "First-Person"
local v_u_22 = {}
local v_u_23 = 0
local v_u_24 = false
local v_u_25 = 1
local v_u_26 = 1
local v_u_27 = 0
local v_u_28 = nil
local v_u_29 = nil
local v_u_30 = { "First-Person", "Third-Person", "Free-Cam" }
local v_u_31 = nil
local v_u_32 = nil
local function v_u_34() -- name: GetSpectateBombModel
    -- upvalues: (copy) CollectionService
    for _, v33 in ipairs(CollectionService:GetTagged("Bomb")) do
        if v33:IsA("Model") and (v33.PrimaryPart and v33:IsDescendantOf(workspace)) then
            return v33
        end
    end
    return nil
end
local function v_u_44() -- name: ShouldBeSpectating
    -- upvalues: (copy) m_MenuState, (copy) ReplicatedStorage, (copy) LocalPlayer, (ref) v_u_24
    if m_MenuState.IsCaseSceneActive() then
        return false
    end
    local v35
    if m_MenuState.WantsMainMenu() then
        local v36 = m_MenuState.GetMenuFrame()
        if v36 == nil then
            v35 = false
        else
            v35 = v36.Visible == true
        end
    else
        v35 = false
    end
    if v35 then
        return false
    end
    if require(ReplicatedStorage.Controllers.EndScreenController).IsActive() then
        return false
    end
    local v37 = LocalPlayer
    local v38 = v37:GetAttribute("Team")
    local v39
    if (v38 == "Counter-Terrorists" and true or v38 == "Terrorists") and (v37 ~= LocalPlayer or not v_u_24) then
        local Character = v37.Character
        if Character and Character:IsDescendantOf(workspace) and not Character:GetAttribute("Dead") then
            local Humanoid = Character:FindFirstChildWhichIsA("Humanoid", true)
            if Humanoid == nil then
                v39 = false
            else
                v39 = Humanoid.Health > 0
            end
        else
            v39 = false
        end
    else
        v39 = false
    end
    if v39 then
        return false
    end
    local v42 = LocalPlayer:GetAttribute("Team")
    if v42 ~= "Counter-Terrorists" and v42 ~= "Terrorists" then
        return false
    end
    local v43 = require(ReplicatedStorage.Database.Components.GameState).GetState()
    return v43 ~= "Game Ending" and v43 ~= "Map Voting"
end
local function v_u_60() -- name: StartSpectatingOnDeath
    -- upvalues: (copy) v_u_44, (ref) v_u_31, (ref) v_u_32, (copy) m_CameraController, (copy) m_Constants, (copy) LocalPlayer, (copy) Players, (ref) v_u_24, (copy) v_u_1
    if v_u_44() then
        if v_u_31 or v_u_32 then
            return
        else
            m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
            m_CameraController.setPerspective(true, false)
            local v45 = LocalPlayer:GetAttribute("LastKiller")
            local v46
            if v45 then
                LocalPlayer:SetAttribute("LastKiller", nil)
                v46 = Players:FindFirstChild(v45)
                if v46 then
                    local v47
                    if v46 == LocalPlayer then
                        v47 = false
                    else
                        local v48 = v46:GetAttribute("Team")
                        local v49
                        if (v48 == "Counter-Terrorists" and true or v48 == "Terrorists") and (v46 ~= LocalPlayer or not v_u_24) then
                            local Character_0 = v46.Character
                            if Character_0 and Character_0:IsDescendantOf(workspace) and not Character_0:GetAttribute("Dead") then
                                local Humanoid_0 = Character_0:FindFirstChildWhichIsA("Humanoid", true)
                                if Humanoid_0 == nil then
                                    v49 = false
                                else
                                    v49 = Humanoid_0.Health > 0
                                end
                            else
                                v49 = false
                            end
                        else
                            v49 = false
                        end
                        if v49 then
                            local v52 = workspace:GetAttribute("ServerGamemode")
                            local v53
                            if ((typeof(v52) ~= "string" or v52 ~= "Casual" and (v52 ~= "Competitive" and v52 ~= "Deathmatch")) and "Casual" or v52) == "Competitive" then
                                local v54 = LocalPlayer:GetAttribute("Team")
                                if v54 == "Counter-Terrorists" and true or v54 == "Terrorists" then
                                    local v55 = LocalPlayer
                                    local v56 = v55:GetAttribute("Team")
                                    local v57
                                    if (v56 == "Counter-Terrorists" and true or v56 == "Terrorists") and (v55 ~= LocalPlayer or not v_u_24) then
                                        local Character_1 = v55.Character
                                        if Character_1 and Character_1:IsDescendantOf(workspace) and not Character_1:GetAttribute("Dead") then
                                            local Humanoid_1 = Character_1:FindFirstChildWhichIsA("Humanoid", true)
                                            if Humanoid_1 == nil then
                                                v57 = false
                                            else
                                                v57 = Humanoid_1.Health > 0
                                            end
                                        else
                                            v57 = false
                                        end
                                    else
                                        v57 = false
                                    end
                                    v53 = not v57
                                else
                                    v53 = false
                                end
                            else
                                v53 = false
                            end
                            v47 = (not v53 or LocalPlayer:GetAttribute("Team") == v46:GetAttribute("Team")) and true or false
                        else
                            v47 = false
                        end
                    end
                    if not v47 then
                        v46 = nil
                    end
                else
                    v46 = nil
                end
            else
                v46 = nil
            end
            if v46 then
                v_u_1.SetNextPlayer(v46)
            else
                v_u_1.Next()
            end
        end
    else
        return
    end
end
local function v_u_72() -- name: UpdateCharacters
    -- upvalues: (copy) v_u_22, (copy) Players, (copy) LocalPlayer, (ref) v_u_24
    local v61 = workspace:GetAttribute("ServerGamemode")
    local v62 = (typeof(v61) ~= "string" or v61 ~= "Casual" and (v61 ~= "Competitive" and v61 ~= "Deathmatch")) and "Casual" or v61
    table.clear(v_u_22)
    for _, v63 in ipairs(Players:GetPlayers()) do
        local v64 = LocalPlayer:GetAttribute("Team")
        local v65 = v63:GetAttribute("Team")
        local v66
        if v63 == LocalPlayer then
            v66 = false
        else
            local v67 = v63:GetAttribute("Team")
            if (v67 == "Counter-Terrorists" and true or v67 == "Terrorists") and (v63 ~= LocalPlayer or not v_u_24) then
                local Character_2 = v63.Character
                if Character_2 and Character_2:IsDescendantOf(workspace) and not Character_2:GetAttribute("Dead") then
                    local Humanoid_2 = Character_2:FindFirstChildWhichIsA("Humanoid", true)
                    if Humanoid_2 == nil then
                        v66 = false
                    else
                        v66 = Humanoid_2.Health > 0
                    end
                else
                    v66 = false
                end
            else
                v66 = false
            end
        end
        if v62 == "Competitive" then
            if (v64 == "Spectators" and true or v65 == v64) and v66 then
                local v70 = v_u_22
                table.insert(v70, v63)
            end
        elseif v66 then
            local v71 = v_u_22
            table.insert(v71, v63)
        end
    end
end
function v_u_1.GetCurrentSpectateInstance() -- name: GetCurrentSpectateInstance
    -- upvalues: (ref) v_u_31
    return v_u_31
end
function v_u_1.IsLocalPlayerDead() -- name: IsLocalPlayerDead
    -- upvalues: (ref) v_u_24
    return v_u_24
end
function v_u_1.GetPlayer() -- name: GetPlayer
    -- upvalues: (copy) LocalPlayer, (ref) v_u_24, (copy) v_u_1
    local v73 = LocalPlayer
    local v74 = v73:GetAttribute("Team")
    local v75
    if (v74 == "Counter-Terrorists" and true or v74 == "Terrorists") and (v73 ~= LocalPlayer or not v_u_24) then
        local Character_3 = v73.Character
        if Character_3 and Character_3:IsDescendantOf(workspace) and not Character_3:GetAttribute("Dead") then
            local Humanoid_3 = Character_3:FindFirstChildWhichIsA("Humanoid", true)
            if Humanoid_3 == nil then
                v75 = false
            else
                v75 = Humanoid_3.Health > 0
            end
        else
            v75 = false
        end
    else
        v75 = false
    end
    if v75 then
        return LocalPlayer
    else
        local v78 = v_u_1.GetCurrentSpectateInstance()
        if v78 then
            return v78.Player
        else
            return nil
        end
    end
end
function v_u_1.SetNextPlayer(p79) -- name: SetNextPlayer
    -- upvalues: (ref) v_u_31, (copy) LocalPlayer, (copy) v_u_1, (ref) v_u_24, (copy) m_Spectate, (copy) m_Remotes
    local Player = v_u_31
    if Player then
        Player = v_u_31.Player
    end
    if p79 == LocalPlayer then
        v_u_1.Next()
        return
    else
        local v81
        if p79 == LocalPlayer then
            v81 = false
        else
            local v82 = p79:GetAttribute("Team")
            local v83
            if (v82 == "Counter-Terrorists" and true or v82 == "Terrorists") and (p79 ~= LocalPlayer or not v_u_24) then
                local Character_4 = p79.Character
                if Character_4 and Character_4:IsDescendantOf(workspace) and not Character_4:GetAttribute("Dead") then
                    local Humanoid_4 = Character_4:FindFirstChildWhichIsA("Humanoid", true)
                    if Humanoid_4 == nil then
                        v83 = false
                    else
                        v83 = Humanoid_4.Health > 0
                    end
                else
                    v83 = false
                end
            else
                v83 = false
            end
            if v83 then
                local v86 = workspace:GetAttribute("ServerGamemode")
                local v87
                if ((typeof(v86) ~= "string" or v86 ~= "Casual" and (v86 ~= "Competitive" and v86 ~= "Deathmatch")) and "Casual" or v86) == "Competitive" then
                    local v88 = LocalPlayer:GetAttribute("Team")
                    if v88 == "Counter-Terrorists" and true or v88 == "Terrorists" then
                        local v89 = LocalPlayer
                        local v90 = v89:GetAttribute("Team")
                        local v91
                        if (v90 == "Counter-Terrorists" and true or v90 == "Terrorists") and (v89 ~= LocalPlayer or not v_u_24) then
                            local Character_5 = v89.Character
                            if Character_5 and Character_5:IsDescendantOf(workspace) and not Character_5:GetAttribute("Dead") then
                                local Humanoid_5 = Character_5:FindFirstChildWhichIsA("Humanoid", true)
                                if Humanoid_5 == nil then
                                    v91 = false
                                else
                                    v91 = Humanoid_5.Health > 0
                                end
                            else
                                v91 = false
                            end
                        else
                            v91 = false
                        end
                        v87 = not v91
                    else
                        v87 = false
                    end
                else
                    v87 = false
                end
                v81 = (not v87 or LocalPlayer:GetAttribute("Team") == p79:GetAttribute("Team")) and true or false
            else
                v81 = false
            end
        end
        if v81 then
            local Character_6 = p79.Character
            local v95 = Player == p79
            local v96 = v_u_31
            if v96 then
                v96 = v_u_31.Character == Character_6
            end
            local v97 = p79:GetAttribute("Team")
            local v98
            if (v97 == "Counter-Terrorists" and true or v97 == "Terrorists") and (p79 ~= LocalPlayer or not v_u_24) then
                local Character_7 = p79.Character
                if Character_7 and Character_7:IsDescendantOf(workspace) and not Character_7:GetAttribute("Dead") then
                    local Humanoid_6 = Character_7:FindFirstChildWhichIsA("Humanoid", true)
                    if Humanoid_6 == nil then
                        v98 = false
                    else
                        v98 = Humanoid_6.Health > 0
                    end
                else
                    v98 = false
                end
            else
                v98 = false
            end
            if not (v95 and (v96 and v98)) then
                v_u_1.Stop(false, true)
                local v101 = Character_6 and (v98 and Character_6:FindFirstChildWhichIsA("Humanoid", true))
                if v101 then
                    local v102 = m_Spectate.new(p79, Character_6, v101)
                    v_u_31 = v102
                    v_u_1.ListenToSpectate:Fire(p79)
                    v102.StopSpectating:Once(function()
                        -- upvalues: (ref) v_u_1
                        v_u_1.Stop(false, true)
                        v_u_1.Next()
                    end)
                    m_Remotes.Spectate.SpectatePlayer.Send(p79.Name)
                    return
                end
                v_u_1.Next()
            end
        else
            v_u_1.Next()
        end
    end
end
function v_u_1.Switch() -- name: Switch
    -- upvalues: (copy) LocalPlayer, (ref) v_u_24, (ref) v_u_21, (ref) v_u_25, (ref) v_u_31, (ref) v_u_32, (copy) v_u_30
    local v103 = workspace:GetAttribute("ServerGamemode")
    local v104
    if ((typeof(v103) ~= "string" or v103 ~= "Casual" and (v103 ~= "Competitive" and v103 ~= "Deathmatch")) and "Casual" or v103) == "Competitive" then
        local v105 = LocalPlayer:GetAttribute("Team")
        if v105 == "Counter-Terrorists" and true or v105 == "Terrorists" then
            local v106 = LocalPlayer
            local v107 = v106:GetAttribute("Team")
            local v108
            if (v107 == "Counter-Terrorists" and true or v107 == "Terrorists") and (v106 ~= LocalPlayer or not v_u_24) then
                local Character_8 = v106.Character
                if Character_8 and Character_8:IsDescendantOf(workspace) and not Character_8:GetAttribute("Dead") then
                    local Humanoid_7 = Character_8:FindFirstChildWhichIsA("Humanoid", true)
                    if Humanoid_7 == nil then
                        v108 = false
                    else
                        v108 = Humanoid_7.Health > 0
                    end
                else
                    v108 = false
                end
            else
                v108 = false
            end
            v104 = not v108
        else
            v104 = false
        end
    else
        v104 = false
    end
    if v104 then
        v_u_21 = "First-Person"
        v_u_25 = 1
        if v_u_31 then
            v_u_31:Switch("First-Person")
        end
        if v_u_32 then
            v_u_32:Destroy()
            v_u_32 = nil
        end
    else
        local v111 = v_u_25 + 1
        if #v_u_30 < v111 then
            v_u_21 = v_u_30[1]
            v_u_25 = 1
        elseif v111 <= #v_u_30 then
            v_u_21 = v_u_30[v111]
            v_u_25 = v111
        end
        if v_u_31 then
            v_u_31:Switch(v_u_21)
        end
    end
end
function v_u_1.UpdateIndex(p112) -- name: UpdateIndex
    -- upvalues: (copy) v_u_72, (copy) v_u_22, (ref) v_u_26, (copy) m_Promise, (copy) LocalPlayer, (ref) v_u_24, (copy) v_u_1
    v_u_72()
    if #v_u_22 > 0 then
        v_u_26 = v_u_26 + p112
        if v_u_26 <= 0 then
            v_u_26 = #v_u_22
        elseif v_u_26 > #v_u_22 then
            v_u_26 = 1
        end
    end
    return m_Promise.new(function(p113, p114)
        -- upvalues: (ref) v_u_22, (ref) v_u_26, (ref) LocalPlayer, (ref) v_u_24, (ref) v_u_72, (ref) v_u_1
        local v115 = v_u_22[v_u_26]
        if v115 then
            local v116 = v115:GetAttribute("Team")
            local v117
            if (v116 == "Counter-Terrorists" and true or v116 == "Terrorists") and (v115 ~= LocalPlayer or not v_u_24) then
                local Character_9 = v115.Character
                if Character_9 and Character_9:IsDescendantOf(workspace) and not Character_9:GetAttribute("Dead") then
                    local Humanoid_8 = Character_9:FindFirstChildWhichIsA("Humanoid", true)
                    if Humanoid_8 == nil then
                        v117 = false
                    else
                        v117 = Humanoid_8.Health > 0
                    end
                else
                    v117 = false
                end
            else
                v117 = false
            end
            if v117 then
                p113(v115)
                return
            end
        end
        v_u_72()
        if #v_u_22 > 0 then
            v_u_26 = 1
            p113(v_u_22[1])
        else
            v_u_1.Stop(false, false)
            p114("No players alive to spectate")
        end
    end)
end
function v_u_1.Next() -- name: Next
    -- upvalues: (copy) v_u_1
    return v_u_1.UpdateIndex(1):andThen(function(p120)
        -- upvalues: (ref) v_u_1
        v_u_1.SetNextPlayer(p120)
    end):catch(function() end)
end
function v_u_1.Previous() -- name: Previous
    -- upvalues: (copy) v_u_1
    return v_u_1.UpdateIndex(-1):andThen(function(p121)
        -- upvalues: (ref) v_u_1
        v_u_1.SetNextPlayer(p121)
    end):catch(function() end)
end
function v_u_1.Stop(p122, p123) -- name: Stop
    -- upvalues: (ref) v_u_29, (copy) LocalPlayer, (ref) v_u_28, (ref) v_u_31, (copy) m_Remotes, (ref) v_u_32, (copy) v_u_19
    if v_u_29 and LocalPlayer.ReplicationFocus == v_u_29 then
        LocalPlayer.ReplicationFocus = nil
    end
    v_u_28 = nil
    v_u_29 = nil
    if v_u_31 then
        v_u_31:Destroy()
        v_u_31 = nil
    end
    if p122 and LocalPlayer:GetAttribute("IsSpectating") then
        m_Remotes.Spectate.StopSpectating.Send()
    end
    if p123 and v_u_32 then
        v_u_32:Destroy()
        v_u_32 = nil
    end
    v_u_19:Fire()
end
function v_u_1.Broadcast() -- name: Broadcast
    -- upvalues: (copy) LocalPlayer, (ref) v_u_27, (copy) m_InventoryController, (copy) m_MenuState, (copy) m_Remotes, (copy) CurrentCamera
    local v124 = LocalPlayer:GetAttribute("Spectators")
    local v125 = v124 and v124 > 0 and 0.016666666666666666 or 0.2
    if v125 <= v_u_27 then
        local v126 = m_InventoryController.getCurrentEquipped()
        v_u_27 = v_u_27 - v125
        if v126 then
            local v127 = LocalPlayer.PlayerGui:FindFirstChild("MainGui")
            if v127 then
                v127 = LocalPlayer.PlayerGui.MainGui:FindFirstChild("Menu")
            end
            if v127 then
                v127 = v127:FindFirstChild("Inspect")
            end
            if v127 and v127.Visible then
                return
            elseif not m_MenuState.IsCaseSceneActive() then
                m_Remotes.Spectate.UpdateCameraCFrame.Send(CurrentCamera.CFrame)
            end
        end
    end
end
function v_u_1.Render(p128) -- name: Render
    -- upvalues: (ref) v_u_23, (ref) v_u_27, (copy) LocalPlayer, (ref) v_u_24, (ref) v_u_21, (ref) v_u_25, (ref) v_u_31, (ref) v_u_32, (copy) v_u_1, (ref) v_u_29, (ref) v_u_28, (copy) CurrentCamera, (copy) m_CameraController, (copy) v_u_44, (copy) m_MenuState, (copy) m_Router, (copy) v_u_72, (copy) v_u_22, (ref) v_u_26, (copy) v_u_34, (copy) m_Constants, (copy) m_Freecam
    v_u_23 = v_u_23 + p128
    v_u_27 = v_u_27 + p128
    local v129 = workspace:GetAttribute("ServerGamemode")
    local v130
    if ((typeof(v129) ~= "string" or v129 ~= "Casual" and (v129 ~= "Competitive" and v129 ~= "Deathmatch")) and "Casual" or v129) == "Competitive" then
        local v131 = LocalPlayer:GetAttribute("Team")
        if v131 == "Counter-Terrorists" and true or v131 == "Terrorists" then
            local v132 = LocalPlayer
            local v133 = v132:GetAttribute("Team")
            local v134
            if (v133 == "Counter-Terrorists" and true or v133 == "Terrorists") and (v132 ~= LocalPlayer or not v_u_24) then
                local Character_10 = v132.Character
                if Character_10 and Character_10:IsDescendantOf(workspace) and not Character_10:GetAttribute("Dead") then
                    local Humanoid_9 = Character_10:FindFirstChildWhichIsA("Humanoid", true)
                    if Humanoid_9 == nil then
                        v134 = false
                    else
                        v134 = Humanoid_9.Health > 0
                    end
                else
                    v134 = false
                end
            else
                v134 = false
            end
            v130 = not v134
        else
            v130 = false
        end
    else
        v130 = false
    end
    if v130 then
        local v137 = workspace:GetAttribute("ServerGamemode")
        local v138
        if ((typeof(v137) ~= "string" or v137 ~= "Casual" and (v137 ~= "Competitive" and v137 ~= "Deathmatch")) and "Casual" or v137) == "Competitive" then
            local v139 = LocalPlayer:GetAttribute("Team")
            if v139 == "Counter-Terrorists" and true or v139 == "Terrorists" then
                local v140 = LocalPlayer
                local v141 = v140:GetAttribute("Team")
                local v142
                if (v141 == "Counter-Terrorists" and true or v141 == "Terrorists") and (v140 ~= LocalPlayer or not v_u_24) then
                    local Character_11 = v140.Character
                    if Character_11 and Character_11:IsDescendantOf(workspace) and not Character_11:GetAttribute("Dead") then
                        local Humanoid_10 = Character_11:FindFirstChildWhichIsA("Humanoid", true)
                        if Humanoid_10 == nil then
                            v142 = false
                        else
                            v142 = Humanoid_10.Health > 0
                        end
                    else
                        v142 = false
                    end
                else
                    v142 = false
                end
                v138 = not v142
            else
                v138 = false
            end
        else
            v138 = false
        end
        if v138 then
            v_u_21 = "First-Person"
            v_u_25 = 1
            if v_u_31 and v_u_31.PerspectiveState ~= "First-Person" then
                v_u_31:Switch("First-Person")
            end
            if v_u_32 then
                v_u_32:Destroy()
                v_u_32 = nil
            end
        end
    end
    if v_u_24 then
        local Character_12 = LocalPlayer.Character
        local v146
        if Character_12 and Character_12:IsDescendantOf(workspace) and not Character_12:GetAttribute("Dead") then
            local Humanoid_11 = Character_12:FindFirstChildWhichIsA("Humanoid", true)
            if Humanoid_11 == nil then
                v146 = false
            else
                v146 = Humanoid_11.Health > 0
            end
        else
            v146 = false
        end
        if v146 then
            v_u_24 = false
        end
    end
    local v148 = LocalPlayer
    local v149 = v148:GetAttribute("Team")
    local v150
    if (v149 == "Counter-Terrorists" and true or v149 == "Terrorists") and (v148 ~= LocalPlayer or not v_u_24) then
        local Character_13 = v148.Character
        if Character_13 and Character_13:IsDescendantOf(workspace) and not Character_13:GetAttribute("Dead") then
            local Humanoid_12 = Character_13:FindFirstChildWhichIsA("Humanoid", true)
            if Humanoid_12 == nil then
                v150 = false
            else
                v150 = Humanoid_12.Health > 0
            end
        else
            v150 = false
        end
    else
        v150 = false
    end
    if v150 then
        v_u_1.Broadcast()
        if v_u_29 and LocalPlayer.ReplicationFocus == v_u_29 then
            LocalPlayer.ReplicationFocus = nil
        end
        v_u_28 = nil
        v_u_29 = nil
        if v_u_31 then
            v_u_1.Stop(true, true)
        end
        if v_u_32 then
            v_u_32:Destroy()
            v_u_32 = nil
        end
        local v153 = LocalPlayer
        local v154 = v153:GetAttribute("Team")
        local v155
        if (v154 == "Counter-Terrorists" and true or v154 == "Terrorists") and (v153 ~= LocalPlayer or not v_u_24) then
            local Character_14 = v153.Character
            if Character_14 and Character_14:IsDescendantOf(workspace) and not Character_14:GetAttribute("Dead") then
                local Humanoid_13 = Character_14:FindFirstChildWhichIsA("Humanoid", true)
                if Humanoid_13 == nil then
                    v155 = false
                else
                    v155 = Humanoid_13.Health > 0
                end
            else
                v155 = false
            end
        else
            v155 = false
        end
        if v155 then
            local Humanoid_14 = LocalPlayer.Character:FindFirstChild("Humanoid")
            if Humanoid_14 then
                CurrentCamera.CameraType = Enum.CameraType.Custom
                CurrentCamera.CameraSubject = Humanoid_14
            end
            m_CameraController.setPerspective(true, false)
            return
        end
        ::l138::
        return
    else
        if v_u_44() or LocalPlayer:GetAttribute("IsSpectating") then
            local v159
            if m_MenuState.WantsMainMenu() then
                local v160 = m_MenuState.GetMenuFrame()
                if v160 == nil then
                    v159 = false
                else
                    v159 = v160.Visible == true
                end
            else
                v159 = false
            end
            if not v159 then
                if m_MenuState.IsCaseSceneActive() then
                    return
                end
                if v_u_31 then
                    if v_u_29 and LocalPlayer.ReplicationFocus == v_u_29 then
                        LocalPlayer.ReplicationFocus = nil
                    end
                    v_u_28 = nil
                    v_u_29 = nil
                    if m_Router.broadcastRouter("IsInspectActive") then
                        return
                    end
                    v_u_31:Render(p128)
                    if v_u_32 then
                        v_u_32:Destroy()
                        v_u_32 = nil
                        return
                    end
                else
                    if v_u_23 >= 0.2 then
                        v_u_23 = 0
                        v_u_72()
                        if #v_u_22 > 0 then
                            v_u_26 = v_u_26 + 1
                            if v_u_26 <= 0 then
                                v_u_26 = #v_u_22
                            elseif v_u_26 > #v_u_22 then
                                v_u_26 = 1
                            end
                        end
                    end
                    if v_u_22[v_u_26] then
                        if v_u_29 and LocalPlayer.ReplicationFocus == v_u_29 then
                            LocalPlayer.ReplicationFocus = nil
                        end
                        v_u_28 = nil
                        v_u_29 = nil
                        v_u_1.Next()
                        return
                    end
                    if v130 then
                        v_u_28 = not (v_u_28 and v_u_28.Parent) and v_u_34()
                        if v_u_28 then
                            m_CameraController.setPerspective(false, false)
                            m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
                        end
                        if v_u_28 then
                            local v161 = v_u_28
                            local v162
                            if v161 and v161.Parent then
                                local PrimaryPart = v161.PrimaryPart
                                if PrimaryPart then
                                    if v_u_29 ~= PrimaryPart then
                                        v_u_29 = PrimaryPart
                                        LocalPlayer.ReplicationFocus = PrimaryPart
                                    end
                                    CurrentCamera.CameraType = Enum.CameraType.Follow
                                    CurrentCamera.CameraSubject = PrimaryPart
                                    v162 = true
                                else
                                    v162 = false
                                end
                            else
                                v162 = false
                            end
                            if v162 then
                                if v_u_32 then
                                    v_u_32:Destroy()
                                    v_u_32 = nil
                                end
                                return
                            end
                        end
                        if v_u_29 and LocalPlayer.ReplicationFocus == v_u_29 then
                            LocalPlayer.ReplicationFocus = nil
                        end
                        v_u_28 = nil
                        v_u_29 = nil
                        if v_u_32 then
                            v_u_32:Destroy()
                            v_u_32 = nil
                        end
                        return
                    end
                    if v_u_29 and LocalPlayer.ReplicationFocus == v_u_29 then
                        LocalPlayer.ReplicationFocus = nil
                    end
                    v_u_28 = nil
                    v_u_29 = nil
                    v_u_32 = not v_u_32 and m_Freecam.new()
                    if v_u_32 then
                        v_u_32:Start()
                        return
                    end
                end
                goto l138
            end
        end
        if v_u_31 then
            v_u_1.Stop(false, true)
            return
        end
        if v_u_29 and LocalPlayer.ReplicationFocus == v_u_29 then
            LocalPlayer.ReplicationFocus = nil
        end
        v_u_28 = nil
        v_u_29 = nil
        goto l138
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) m_Observers, (copy) LocalPlayer, (copy) m_MenuState, (copy) v_u_1, (copy) m_CameraController, (copy) m_Constants, (ref) v_u_31, (copy) Players, (ref) v_u_24, (copy) m_Remotes, (copy) v_u_60, (copy) ReplicatedStorage, (copy) m_RunServiceController
    m_Observers.observeAttribute(LocalPlayer, "IsSpectating", function(p164)
        -- upvalues: (ref) LocalPlayer, (ref) m_MenuState, (ref) v_u_1, (ref) m_CameraController, (ref) m_Constants, (ref) v_u_31, (ref) Players, (ref) v_u_24
        if p164 then
            LocalPlayer:SetAttribute("PendingSpectateRequestAt", nil)
            if m_MenuState.IsCaseSceneActive() then
                return function()
                    -- upvalues: (ref) v_u_1
                    v_u_1.Stop(false, true)
                end
            end
            local v165
            if m_MenuState.WantsMainMenu() then
                local v166 = m_MenuState.GetMenuFrame()
                if v166 == nil then
                    v165 = false
                else
                    v165 = v166.Visible == true
                end
            else
                v165 = false
            end
            if v165 then
                return function()
                    -- upvalues: (ref) v_u_1
                    v_u_1.Stop(false, true)
                end
            end
            m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
            m_CameraController.setPerspective(true, false)
            if not v_u_31 then
                local v167 = LocalPlayer:GetAttribute("LastKiller")
                local v168
                if v167 then
                    LocalPlayer:SetAttribute("LastKiller", nil)
                    v168 = Players:FindFirstChild(v167)
                    if v168 then
                        local v169
                        if v168 == LocalPlayer then
                            v169 = false
                        else
                            local v170 = v168:GetAttribute("Team")
                            local v171
                            if (v170 == "Counter-Terrorists" and true or v170 == "Terrorists") and (v168 ~= LocalPlayer or not v_u_24) then
                                local Character_15 = v168.Character
                                if Character_15 and Character_15:IsDescendantOf(workspace) and not Character_15:GetAttribute("Dead") then
                                    local Humanoid_15 = Character_15:FindFirstChildWhichIsA("Humanoid", true)
                                    if Humanoid_15 == nil then
                                        v171 = false
                                    else
                                        v171 = Humanoid_15.Health > 0
                                    end
                                else
                                    v171 = false
                                end
                            else
                                v171 = false
                            end
                            if v171 then
                                local v174 = workspace:GetAttribute("ServerGamemode")
                                local v175
                                if ((typeof(v174) ~= "string" or v174 ~= "Casual" and (v174 ~= "Competitive" and v174 ~= "Deathmatch")) and "Casual" or v174) == "Competitive" then
                                    local v176 = LocalPlayer:GetAttribute("Team")
                                    if v176 == "Counter-Terrorists" and true or v176 == "Terrorists" then
                                        local v177 = LocalPlayer
                                        local v178 = v177:GetAttribute("Team")
                                        local v179
                                        if (v178 == "Counter-Terrorists" and true or v178 == "Terrorists") and (v177 ~= LocalPlayer or not v_u_24) then
                                            local Character_16 = v177.Character
                                            if Character_16 and Character_16:IsDescendantOf(workspace) and not Character_16:GetAttribute("Dead") then
                                                local Humanoid_16 = Character_16:FindFirstChildWhichIsA("Humanoid", true)
                                                if Humanoid_16 == nil then
                                                    v179 = false
                                                else
                                                    v179 = Humanoid_16.Health > 0
                                                end
                                            else
                                                v179 = false
                                            end
                                        else
                                            v179 = false
                                        end
                                        v175 = not v179
                                    else
                                        v175 = false
                                    end
                                else
                                    v175 = false
                                end
                                v169 = (not v175 or LocalPlayer:GetAttribute("Team") == v168:GetAttribute("Team")) and true or false
                            else
                                v169 = false
                            end
                        end
                        if not v169 then
                            v168 = nil
                        end
                    else
                        v168 = nil
                    end
                else
                    v168 = nil
                end
                if v168 then
                    v_u_1.SetNextPlayer(v168)
                else
                    v_u_1.Next()
                end
            end
        end
        return function()
            -- upvalues: (ref) v_u_1
            v_u_1.Stop(false, true)
        end
    end)
    m_Remotes.Character.CharacterDied.Listen(function()
        -- upvalues: (ref) LocalPlayer, (ref) v_u_24, (ref) v_u_60
        local Character_17 = LocalPlayer.Character
        local v183
        if Character_17 and Character_17:IsDescendantOf(workspace) and not Character_17:GetAttribute("Dead") then
            local Humanoid_17 = Character_17:FindFirstChildWhichIsA("Humanoid", true)
            if Humanoid_17 == nil then
                v183 = false
            else
                v183 = Humanoid_17.Health > 0
            end
        else
            v183 = false
        end
        if v183 then
            v_u_24 = false
        else
            v_u_24 = true
            v_u_60()
        end
    end)
    LocalPlayer.CharacterAdded:Connect(function(p_u_185)
        -- upvalues: (ref) v_u_24, (ref) LocalPlayer, (ref) m_MenuState, (ref) v_u_1, (ref) m_Remotes, (ref) v_u_31, (ref) v_u_60
        v_u_24 = false
        local v186 = LocalPlayer:GetAttribute("Team")
        local v187 = v186 == "Counter-Terrorists" and true or v186 == "Terrorists"
        local Humanoid_18 = p_u_185:FindFirstChildWhichIsA("Humanoid", true)
        if Humanoid_18 then
            if Humanoid_18.Health > 0 then
                Humanoid_18 = not p_u_185:GetAttribute("Dead")
            else
                Humanoid_18 = false
            end
        end
        local v189 = LocalPlayer:GetAttribute("PendingSpectateRequestAt")
        local v190
        if v189 == nil then
            v190 = false
        else
            v190 = os.clock() - v189 < 3
        end
        if v187 and Humanoid_18 then
            m_MenuState.SetWantsMainMenu(false)
            v_u_1.Stop(not v190, true)
            if not v190 and LocalPlayer:GetAttribute("IsSpectating") then
                m_Remotes.Spectate.StopSpectating.Send()
            end
        elseif v_u_31 and v_u_31.Player then
            m_Remotes.Spectate.SpectatePlayer.Send(v_u_31.Player.Name)
        end
        local v_u_191 = p_u_185:GetAttributeChangedSignal("Dead"):Connect(function()
            -- upvalues: (copy) p_u_185, (ref) v_u_60
            if p_u_185:GetAttribute("Dead") then
                v_u_60()
            end
        end)
        local v_u_192 = nil
        v_u_192 = p_u_185.AncestryChanged:Connect(function(_, p193)
            -- upvalues: (ref) v_u_191, (ref) v_u_192
            if not p193 then
                if v_u_191 then
                    v_u_191:Disconnect()
                    v_u_191 = nil
                end
                if v_u_192 then
                    v_u_192:Disconnect()
                    v_u_192 = nil
                end
            end
        end)
    end)
    require(ReplicatedStorage.Database.Components.GameState).ListenToState(function(_, p194)
        -- upvalues: (ref) v_u_1
        if p194 == "Game Ending" or p194 == "Map Voting" then
            v_u_1.Stop(false, true)
        end
    end)
    m_RunServiceController.BindToRenderStep("SpectateController.Render", function(p195)
        -- upvalues: (ref) v_u_1
        v_u_1.Render(p195)
    end)
end
function v_u_1.Start() -- name: Start
    -- upvalues: (copy) m_Remotes, (ref) v_u_31, (copy) UserInputService, (copy) LocalPlayer, (copy) v_u_1, (copy) CurrentCamera
    m_Remotes.Spectate.ReplicateSpectateEvent.Listen(function(...)
        -- upvalues: (ref) v_u_31
        if v_u_31 then
            v_u_31:AddSpectateEvent(...)
        end
    end)
    UserInputService.InputBegan:Connect(function(p196)
        -- upvalues: (ref) LocalPlayer, (ref) v_u_1
        if LocalPlayer:GetAttribute("IsSpectating") and (p196.KeyCode == Enum.KeyCode.Space and not LocalPlayer:GetAttribute("IsPlayerChatting")) then
            v_u_1.Switch()
        end
    end)
    if UserInputService.TouchEnabled then
        UserInputService.TouchStarted:Connect(function(p197, p198)
            -- upvalues: (ref) LocalPlayer, (ref) CurrentCamera, (ref) v_u_1
            if p198 or LocalPlayer:GetAttribute("IsPlayerChatting") then
                return
            elseif LocalPlayer:GetAttribute("IsSpectating") then
                local Position = p197.Position
                if CurrentCamera.ViewportSize.X / 2 > Position.X then
                    v_u_1.Previous()
                else
                    v_u_1.Next()
                end
            else
                return
            end
        end)
    end
end
return v_u_1
