-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
local m_DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local m_MovementSounds = require(script.MovementSounds)
local m_Character = require(ReplicatedStorage.Database.Audio.Character)
local m_FloorSounds = require(ReplicatedStorage.Database.Audio.FloorSounds)
local CurrentCamera = Workspace.CurrentCamera
local v_u_21 = {
    ["WeaponSuppressed"] = 50,
    ["Footstep"] = 48,
    ["Landing"] = 60,
    ["Weapon"] = 120,
    ["Melee"] = 50,
    ["Jump"] = 40
}
local v_u_22 = {}
local v_u_23 = {}
local v_u_24 = nil
local v_u_25 = {
    "Knife",
    "Bayonet",
    "Karambit",
    "Daggers"
}
local v_u_26 = {
    ["Headshot"] = 1,
    ["Humiliation"] = 2,
    ["MultiKill"] = 3,
    ["KillSpree"] = 4,
    ["Rampage"] = 5,
    ["Dominating"] = 6,
    ["Monster Kill"] = 7,
    ["LudicrusKill"] = 8,
    ["Unstoppable"] = 9,
    ["Godlike"] = 10
}
local v_u_27 = {
    [2] = "MultiKill",
    [3] = "KillSpree",
    [4] = "Rampage",
    [5] = "Dominating",
    [6] = "Monster Kill",
    [7] = "LudicrusKill",
    [8] = "Unstoppable",
    [9] = "Godlike"
}
local v_u_28 = 0
local v_u_29 = nil
local v_u_30 = 0
local v_u_31 = nil
local function v_u_34(p32) -- name: isKnifeWeapon
    -- upvalues: (copy) v_u_25
    for _, v33 in ipairs(v_u_25) do
        if string.find(p32, v33) then
            return true
        end
    end
    return false
end
local function v_u_40(p35) -- name: updateBombPlantedMusicVolume
    -- upvalues: (ref) v_u_31, (copy) m_DataController, (copy) LocalPlayer
    if v_u_31 and v_u_31.Parent then
        local v36 = (tonumber(p35) or 50) / 50
        local v37 = m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100
        local v38 = (tonumber(v37) or 100) / 100
        local Volume_0 = v_u_31:GetAttribute("BaseVolume")
        if typeof(Volume_0) ~= "number" then
            Volume_0 = v_u_31.Volume
        end
        v_u_31.Volume = Volume_0 * v36 * v38
    end
end
function v_u_1.SetBombPlantedMusicVolume(p41) -- name: SetBombPlantedMusicVolume
    -- upvalues: (copy) v_u_40
    v_u_40(p41)
end
function v_u_1.GetPlayerNoiseCone() -- name: GetPlayerNoiseCone
    -- upvalues: (ref) v_u_24
    if v_u_24 and tick() - v_u_24.Time >= 2 then
        v_u_24 = nil
    end
    return v_u_24
end
function v_u_1.UpdatePlayerNoiseCone(p42, p43, p44) -- name: UpdatePlayerNoiseCone
    -- upvalues: (ref) v_u_24
    local v45 = p43 * 0.5
    local v46 = tick()
    if p44 then
        v45 = v45 * 0.5
    end
    if v_u_24 and (v46 - v_u_24.Time < 2 and v45 < v_u_24.Range) then
        v_u_24.Time = v46
    else
        v_u_24 = {
            ["Position"] = p42,
            ["Range"] = v45,
            ["Time"] = v46
        }
    end
end
function v_u_1.GetFootstepRange(p47, p48) -- name: GetFootstepRange
    -- upvalues: (copy) m_FloorSounds
    local Concrete = m_FloorSounds[p47] or m_FloorSounds.Concrete
    local v50 = Concrete and (Concrete.Properties and Concrete.Properties.RollOffMaxDistance) or 48
    if p48 then
        v50 = v50 * 0.5 or v50
    end
    return v50
end
function v_u_1.GetWeaponShootRange(p51, p52) -- name: GetWeaponShootRange
    -- upvalues: (copy) v_u_23, (copy) ReplicatedStorage
    local v53
    if v_u_23[p51] then
        v53 = v_u_23[p51]
    else
        local v54 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(p51)
        if v54 then
            local v55
            v55, v53 = pcall(require, v54)
            if v55 and v53 then
                v_u_23[p51] = v53
            else
                v53 = nil
            end
        else
            v53 = nil
        end
    end
    if v53 then
        if p52 and v53.Silencer then
            local Silencer = v53.Silencer
            return Silencer and (Silencer.Properties and Silencer.Properties.RollOffMaxDistance) or 50
        else
            local Shoot = v53.Shoot
            return Shoot and (Shoot.Properties and Shoot.Properties.RollOffMaxDistance) or 120
        end
    else
        return p52 and 50 or 120
    end
end
function v_u_1.GetMeleeRange(p58) -- name: GetMeleeRange
    -- upvalues: (copy) v_u_23, (copy) ReplicatedStorage
    local v59
    if v_u_23[p58] then
        v59 = v_u_23[p58]
    else
        local v60 = ReplicatedStorage.Database.Audio.Weapons:FindFirstChild(p58)
        if v60 then
            local v61
            v61, v59 = pcall(require, v60)
            if v61 and v59 then
                v_u_23[p58] = v59
            else
                v59 = nil
            end
        else
            v59 = nil
        end
    end
    if not v59 then
        return 50
    end
    local HitOne = v59.HitOne
    return HitOne and (HitOne.Properties and HitOne.Properties.RollOffMaxDistance) or 50
end
function v_u_1.GetMovementRange(p63, p64) -- name: GetMovementRange
    -- upvalues: (copy) v_u_21, (copy) m_Character
    local v65 = v_u_21[p63] or 48
    if p63 == "Landing" then
        local v66 = m_Character["Fall Damage"]
        if v66 and v66.Properties then
            v65 = v66.Properties.RollOffMaxDistance or v65
        end
    end
    if p64 then
        v65 = v65 * 0.5 or v65
    end
    return v65
end
function v_u_1.ClearPlayerNoiseCone() -- name: ClearPlayerNoiseCone
    -- upvalues: (ref) v_u_24
    v_u_24 = nil
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) ReplicatedStorage, (copy) m_Sound, (copy) ContentProvider, (copy) m_Router, (copy) m_MenuState, (copy) CurrentCamera, (copy) m_DataController, (copy) LocalPlayer, (copy) m_GameState, (copy) m_RunServiceController, (copy) m_Remotes, (copy) m_FlashEffect, (copy) m_DebugFlags, (ref) v_u_31, (copy) Players, (copy) v_u_40, (ref) v_u_28, (ref) v_u_29, (ref) v_u_30, (copy) v_u_27, (copy) v_u_26, (copy) v_u_34, (copy) v_u_1
    for _, v67 in ipairs(ReplicatedStorage.Database.Audio:GetDescendants()) do
        if v67:IsA("ModuleScript") then
            m_Sound.createSoundGroup(v67)
        end
    end
    task.spawn(function()
        -- upvalues: (ref) ContentProvider, (ref) ReplicatedStorage
        ContentProvider:PreloadAsync({ ReplicatedStorage.Sounds })
    end)
    m_Router.observerRouter("RunRoundSound", function(p68)
        -- upvalues: (ref) m_MenuState, (ref) m_Sound, (ref) CurrentCamera
        if m_MenuState.GetCurrentScreen() == nil then
            local v69 = {
                ["Parent"] = CurrentCamera,
                ["Name"] = p68
            }
            return m_Sound.new("Round"):playOneTime(v69)
        end
    end)
    m_Router.observerRouter("PlayCountdownTimer", function()
        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (ref) m_MenuState, (ref) m_Sound
        local v70 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Main Menu Volume") or 100) / 100
        if m_MenuState.GetCurrentScreen() == nil then
            if v70 > 0 then
                m_Sound.new("Interface"):playOneTime({
                    ["Parent"] = nil,
                    ["Name"] = "Countdown Timer",
                    ["Parent"] = LocalPlayer.PlayerGui
                }, v70)
            end
            return nil
        end
    end)
    local v_u_71 = nil
    local v_u_72 = nil
    local v_u_73 = nil
    local function v_u_84(p74) -- name: updateBuyPhaseVolume
        -- upvalues: (ref) v_u_71, (ref) m_DataController, (ref) LocalPlayer, (ref) v_u_73, (ref) v_u_72
        if v_u_71 and v_u_71.Parent then
            local v75 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Start Volume") or 50) / 50
            local v76 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
            local Volume_1 = v_u_71:GetAttribute("BaseVolume") or v_u_71.Volume
            local v78
            if p74 and v_u_73 then
                local v79 = tick() - v_u_73
                if v79 < 6 then
                    v78 = 1
                else
                    local v80 = 1 - (v79 - 6) * 0.2
                    v78 = math.max(0, v80)
                end
            else
                v78 = 1
            end
            v_u_71.Volume = Volume_1 * v75 * v76 * v78
            if p74 and v_u_73 then
                local v81 = tick() - v_u_73
                local v82
                if v81 < 6 then
                    v82 = 1
                else
                    local v83 = 1 - (v81 - 6) * 0.2
                    v82 = math.max(0, v83)
                end
                if v82 <= 0 then
                    if v_u_72 then
                        v_u_72:Disconnect()
                        v_u_72 = nil
                    end
                    v_u_71:Stop()
                    v_u_71:Destroy()
                    v_u_71 = nil
                    v_u_73 = nil
                end
            end
        end
    end
    m_GameState.ListenToState(function(_, p85)
        -- upvalues: (ref) LocalPlayer, (ref) v_u_71, (ref) v_u_72, (ref) v_u_73, (ref) m_DataController, (ref) m_Sound, (ref) CurrentCamera, (ref) m_RunServiceController, (copy) v_u_84
        if p85 == "Buy Period" then
            local v86 = LocalPlayer:GetAttribute("Team")
            if v86 ~= "Counter-Terrorists" and v86 ~= "Terrorists" then
                return
            end
            if v_u_71 then
                if v_u_72 then
                    v_u_72:Disconnect()
                    v_u_72 = nil
                end
                if v_u_71.Parent then
                    v_u_71:Stop()
                    v_u_71:Destroy()
                end
                v_u_71 = nil
                v_u_73 = nil
            end
            local v87 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Round Start Volume") or 50) / 50
            local v88 = {
                ["Parent"] = nil,
                ["Name"] = "Buy Phase",
                ["Parent"] = CurrentCamera
            }
            v_u_71 = m_Sound.new("Round"):play(v88, v87)
            if v_u_71 then
                local v_u_89 = v_u_71
                v_u_89.Destroying:Once(function()
                    -- upvalues: (ref) v_u_71, (copy) v_u_89, (ref) v_u_73
                    if v_u_71 == v_u_89 then
                        v_u_71 = nil
                        v_u_73 = nil
                    end
                end)
                local v90 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                local Volume_2 = v_u_71.Volume
                if v87 > 0 and v90 > 0 then
                    Volume_2 = Volume_2 / (v87 * v90) or Volume_2
                end
                v_u_71:SetAttribute("BaseVolume", Volume_2)
                v_u_73 = tick()
                task.spawn(function()
                    -- upvalues: (ref) v_u_72, (ref) m_RunServiceController, (ref) v_u_71, (ref) v_u_73, (ref) v_u_84
                    v_u_72 = m_RunServiceController.BindToHeartbeat("SoundController.BuyPhaseFade", function()
                        -- upvalues: (ref) v_u_71, (ref) v_u_73, (ref) v_u_84, (ref) v_u_72
                        if not (v_u_71 and v_u_71.Parent) then
                            if v_u_72 then
                                v_u_72:Disconnect()
                                v_u_72 = nil
                            end
                            goto l10
                        end
                        if not v_u_73 then
                            return
                        end
                        local v92 = tick() - v_u_73
                        local v93 = v92 >= 6
                        v_u_84(v93)
                        if v93 then
                            if not (v_u_71 and v_u_71.Parent) then
                                ::l12::
                                if v_u_72 then
                                    v_u_72:Disconnect()
                                    v_u_72 = nil
                                    return
                                end
                                goto l10
                            end
                            local v94
                            if v92 < 6 then
                                v94 = 1
                            else
                                local v95 = 1 - (v92 - 6) * 0.2
                                v94 = math.max(0, v95)
                            end
                            if v94 <= 0 then
                                goto l12
                            end
                        end
                        ::l10::
                    end)
                end)
                return
            end
        elseif v_u_71 then
            if v_u_72 then
                v_u_72:Disconnect()
                v_u_72 = nil
            end
            if v_u_71.Parent then
                v_u_71:Stop()
                v_u_71:Destroy()
            end
            v_u_71 = nil
            v_u_73 = nil
        end
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Round Start Volume", function()
        -- upvalues: (copy) v_u_84, (ref) v_u_72
        v_u_84(v_u_72 ~= nil)
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function()
        -- upvalues: (copy) v_u_84, (ref) v_u_72
        v_u_84(v_u_72 ~= nil)
    end)
    m_Remotes.Sound.ReplicateSound.Listen(function(p96)
        -- upvalues: (ref) m_FlashEffect, (ref) m_DebugFlags, (ref) v_u_31, (ref) m_Sound, (ref) Players, (ref) LocalPlayer, (ref) m_MenuState, (ref) m_GameState, (ref) m_DataController, (ref) v_u_40
        local v97 = m_FlashEffect.GetAudioFadeMultiplier()
        if m_DebugFlags.IsEnabled("WeaponFX") then
            local v98
            if p96 and p96.Name then
                local Name = p96.Name
                v98 = tostring(Name) or ""
            else
                v98 = ""
            end
            local v100
            if p96 and p96.Class then
                local Class = p96.Class
                v100 = tostring(Class) or ""
            else
                v100 = ""
            end
            local v102 = string.lower(v98)
            if string.find(v102, "shoot", 1, true) or string.find(v102, "fire", 1, true) then
                local v103 = m_FlashEffect.IsFlashed()
                local v104 = warn
                local v105 = "[WeaponFX][Client][Sound] recv class=%s name=%s flashed=%s parent=%s position=%s path=%s"
                local v106 = tostring(v103)
                local v107
                if p96 then
                    v107 = p96.Parent
                else
                    v107 = p96
                end
                local v108 = tostring(v107)
                local v109
                if p96 then
                    v109 = p96.Position
                else
                    v109 = p96
                end
                local v110 = tostring(v109)
                local v111
                if p96 then
                    v111 = p96.Path
                else
                    v111 = p96
                end
                v104(v105:format(v100, v98, v106, v108, v110, (tostring(v111))))
            end
        end
        if p96.Name == "Bomb Planted Music" and (p96.Class == "Counter-Terrorists" and v_u_31) then
            if v_u_31.Parent then
                v_u_31:Stop()
                v_u_31:Destroy()
            end
            v_u_31 = nil
        end
        if p96.Position then
            local v112 = m_Sound.new(p96.Class)
            local v113 = {
                ["Position"] = p96.Position,
                ["Class"] = p96.Class,
                ["Name"] = p96.Name
            }
            local Duration = p96.Duration
            v112:PlaySoundAtPosition(v113, tonumber(Duration), v97)
        elseif p96.Parent or p96.Path then
            if p96.Parent and p96.Parent:IsA("BasePart") then
                local Parent = p96.Parent
                if Parent and Parent.Name == "Head" then
                    local Parent_0 = Parent.Parent
                    if Parent_0 and (Parent_0:IsA("Model") and (Parent_0:IsDescendantOf(workspace) and Players:GetPlayerFromCharacter(Parent_0) == LocalPlayer)) then
                        if m_DebugFlags.IsEnabled("WeaponFX") then
                            local v117 = warn
                            local Name_0 = p96.Name
                            local v119 = tostring(Name_0)
                            local Class_0 = p96.Class
                            v117(("[WeaponFX][Client][Sound] skipped local duplicate head sound name=%s class=%s"):format(v119, (tostring(Class_0))))
                        end
                        return
                    end
                end
            end
            if (p96.Name == "Bomb Planted" or (p96.Name == "Bomb Defused" or p96.Name == "Hostage Rescued")) and m_MenuState.GetCurrentScreen() ~= nil then
                return
            end
            if p96.Name == "Bomb Planted Music" and p96.Class == "Counter-Terrorists" then
                if m_GameState.GetState() ~= "Round In Progress" then
                    return
                end
                if m_MenuState.GetCurrentScreen() ~= nil then
                    return
                end
                v97 = v97 * ((m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50)
            elseif (p96.Name == "Counter-Terrorists Win" or p96.Name == "Terrorists Win") and p96.Class == "Round" then
                if m_MenuState.GetCurrentScreen() ~= nil then
                    return
                end
                v97 = v97 * ((m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50)
            end
            local v_u_121 = m_Sound.new(p96.Class):playOneTime({
                ["Parent"] = p96.Parent,
                ["Name"] = p96.Name,
                ["Path"] = p96.Path
            }, v97)
            if (p96.Name == "Counter-Terrorists Win" or p96.Name == "Terrorists Win") and (p96.Class == "Round" and v_u_121) then
                if v_u_121 then
                    local v122 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
                    local v123 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                    local Volume = v_u_121.Volume
                    if v122 > 0 and v123 > 0 then
                        Volume = Volume / (v122 * v123) or Volume
                    end
                    v_u_121:SetAttribute("BaseVolume", Volume)
                    local function v127() -- name: updateRoundWinVolume
                        -- upvalues: (copy) v_u_121, (ref) m_DataController, (ref) LocalPlayer, (copy) Volume
                        if v_u_121 and v_u_121.Parent then
                            local v125 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Round End Volume") or 50) / 50
                            local v126 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                            v_u_121.Volume = (v_u_121:GetAttribute("BaseVolume") or Volume) * v125 * v126
                        end
                    end
                    local v_u_128 = m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Round End Volume", v127)
                    local v_u_129 = m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", v127)
                    v_u_121.Destroying:Once(function()
                        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (copy) v_u_128, (copy) v_u_129
                        m_DataController.RemoveListener(LocalPlayer, "Settings.Audio.Music.Round End Volume", v_u_128)
                        m_DataController.RemoveListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", v_u_129)
                    end)
                    return
                end
            else
                v_u_31 = p96.Name == "Bomb Planted Music" and (p96.Class == "Counter-Terrorists" and v_u_121)
                if v_u_31 then
                    local v130 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50) / 50
                    local v131 = (m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100) / 100
                    local Volume_3 = v_u_31.Volume
                    if v130 > 0 and v131 > 0 then
                        Volume_3 = Volume_3 / (v130 * v131) or Volume_3
                    end
                    v_u_31:SetAttribute("BaseVolume", Volume_3)
                    local function v133() -- name: updateBombPlantedVolume
                        -- upvalues: (ref) v_u_31, (ref) m_DataController, (ref) LocalPlayer, (ref) v_u_40
                        if v_u_31 and v_u_31.Parent then
                            v_u_40(m_DataController.Get(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume") or 50)
                        end
                    end
                    local v_u_134 = m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume", v133)
                    local v_u_135 = m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", v133)
                    v_u_31.Destroying:Once(function()
                        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (copy) v_u_134, (copy) v_u_135
                        m_DataController.RemoveListener(LocalPlayer, "Settings.Audio.Music.Bomb/Hostage Volume", v_u_134)
                        m_DataController.RemoveListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", v_u_135)
                    end)
                end
            end
        end
    end)
    local CollectionService = game:GetService("CollectionService")
    local function v_u_139() -- name: setupBombDefuseListener
        -- upvalues: (copy) CollectionService, (ref) v_u_31
        local v_u_137 = CollectionService:GetTagged("Bomb")[1]
        if v_u_137 and v_u_137:IsDescendantOf(workspace) then
            local v_u_138 = nil
            v_u_138 = v_u_137:GetAttributeChangedSignal("Defused"):Connect(function()
                -- upvalues: (copy) v_u_137, (ref) v_u_31, (ref) v_u_138
                if v_u_137:GetAttribute("Defused") then
                    if v_u_31 then
                        if v_u_31.Parent then
                            v_u_31:Stop()
                            v_u_31:Destroy()
                        end
                        v_u_31 = nil
                    end
                    if v_u_138 then
                        v_u_138:Disconnect()
                    end
                end
            end)
        end
    end
    CollectionService:GetInstanceAddedSignal("Bomb"):Connect(function(_)
        -- upvalues: (copy) v_u_139
        v_u_139()
    end)
    task.defer(function()
        -- upvalues: (copy) v_u_139
        v_u_139()
    end)
    m_GameState.ListenToState(function(_, p140)
        -- upvalues: (ref) v_u_31
        if p140 ~= "Round In Progress" and v_u_31 then
            if v_u_31.Parent then
                v_u_31:Stop()
                v_u_31:Destroy()
            end
            v_u_31 = nil
        end
    end)
    m_Remotes.UI.UIPlayerKilled.Listen(function(p141)
        -- upvalues: (ref) LocalPlayer, (ref) v_u_28, (ref) v_u_29, (ref) v_u_30, (ref) v_u_27, (ref) v_u_26, (ref) v_u_34, (ref) m_Sound
        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            local UserId = LocalPlayer.UserId
            local v143 = tostring(UserId)
            if p141.Victim == v143 then
                v_u_28 = 0
                if v_u_29 then
                    local v144 = v_u_29
                    v_u_29 = nil
                    v_u_30 = 0
                    if v144.Parent then
                        v144:Stop()
                        v144:Destroy()
                    end
                end
                return
            elseif p141.Killer == v143 then
                v_u_28 = v_u_28 + 1
                local v145 = v_u_28
                local v_u_146 = v_u_27[math.min(v145, 9)]
                local v_u_147
                if v_u_146 then
                    v_u_147 = v_u_26[v_u_146] or 0
                else
                    v_u_147 = 0
                    v_u_146 = nil
                end
                if p141.Headshot and v_u_147 < 1 then
                    v_u_147 = 1
                    v_u_146 = "Headshot"
                end
                if p141.Weapon and (v_u_34(p141.Weapon) and v_u_147 < 2) then
                    v_u_146 = "Humiliation"
                    v_u_147 = 2
                end
                if v_u_146 then
                    if v_u_147 >= v_u_30 then
                        if v_u_29 then
                            local v148 = v_u_29
                            v_u_29 = nil
                            v_u_30 = 0
                            if v148.Parent then
                                v148:Stop()
                                v148:Destroy()
                            end
                        end
                        task.delay(0.2, function()
                            -- upvalues: (ref) v_u_147, (ref) v_u_30, (ref) v_u_29, (ref) m_Sound, (ref) LocalPlayer, (ref) v_u_146
                            if v_u_147 >= v_u_30 then
                                if v_u_29 then
                                    local v149 = v_u_29
                                    v_u_29 = nil
                                    v_u_30 = 0
                                    if v149.Parent then
                                        v149:Stop()
                                        v149:Destroy()
                                    end
                                end
                                local v_u_150 = m_Sound.new("Deathmatch"):play({
                                    ["Parent"] = LocalPlayer.PlayerGui,
                                    ["Name"] = v_u_146
                                })
                                if v_u_150 then
                                    v_u_29 = v_u_150
                                    v_u_30 = v_u_147
                                    v_u_150.Ended:Once(function()
                                        -- upvalues: (ref) v_u_29, (copy) v_u_150, (ref) v_u_30
                                        if v_u_29 == v_u_150 then
                                            v_u_29 = nil
                                            v_u_30 = 0
                                        end
                                    end)
                                    v_u_150.Destroying:Once(function()
                                        -- upvalues: (ref) v_u_29, (copy) v_u_150, (ref) v_u_30
                                        if v_u_29 == v_u_150 then
                                            v_u_29 = nil
                                            v_u_30 = 0
                                        end
                                    end)
                                end
                            end
                        end)
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
    end)
    m_Remotes.Sound.StopSoundAtPosition.Listen(function(p151)
        local Debris = workspace:FindFirstChild("Debris")
        if Debris then
            for _, v153 in ipairs(Debris:GetChildren()) do
                if v153.Name == "Sound" and (v153:IsA("BasePart") and (v153.Position - p151.Position).Magnitude <= p151.Radius) then
                    v153:Destroy()
                end
            end
        end
    end)
    m_Router.observerRouter("UpdatePlayerNoiseCone", function(p154, p155, p156, p157)
        -- upvalues: (ref) v_u_1
        if typeof(p156) ~= "number" then
            p156 = ({
                ["Footstep"] = v_u_1.GetFootstepRange(p156 or "Concrete", p157),
                ["Landing"] = v_u_1.GetMovementRange("Landing", p157),
                ["Jump"] = v_u_1.GetMovementRange("Jump", p157)
            })[p154]
        end
        if not p156 then
            return nil
        end
        v_u_1.UpdatePlayerNoiseCone(p155, p156, p157)
        return nil
    end)
end
function v_u_1.Start() -- name: Start
    -- upvalues: (copy) m_Observers, (copy) LocalPlayer, (copy) v_u_22, (copy) m_MovementSounds, (copy) v_u_1, (ref) v_u_28, (ref) v_u_29, (ref) v_u_30, (copy) Players, (copy) m_RunServiceController
    m_Observers.observeCharacter(function(p158, p159)
        -- upvalues: (ref) LocalPlayer, (ref) v_u_22, (ref) m_MovementSounds, (ref) v_u_1, (ref) v_u_28, (ref) v_u_29, (ref) v_u_30
        local v160 = p158 == LocalPlayer
        local v_u_161 = v_u_22[p158]
        if not v_u_161 then
            v_u_161 = m_MovementSounds.new(p158)
            v_u_22[p158] = v_u_161
        end
        if v160 then
            v_u_1.ClearPlayerNoiseCone()
            v_u_28 = 0
            if v_u_29 then
                local v162 = v_u_29
                v_u_29 = nil
                v_u_30 = 0
                if v162.Parent then
                    v162:Stop()
                    v162:Destroy()
                end
            end
        end
        v_u_161:SetCharacter(p159)
        return function()
            -- upvalues: (ref) v_u_161
            v_u_161:SetCharacter(nil)
        end
    end)
    Players.PlayerRemoving:Connect(function(p163)
        -- upvalues: (ref) v_u_22
        local v164 = v_u_22[p163]
        if v164 then
            v_u_22[p163] = nil
            v164:Destroy()
        end
    end)
    m_RunServiceController.BindToHeartbeat("SoundController.MovementSounds", function(p165)
        -- upvalues: (ref) LocalPlayer, (ref) v_u_22
        local Character = LocalPlayer.Character
        local v167
        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid")
            local v169 = Humanoid and (Humanoid.Health > 0 and Character:FindFirstChild("HumanoidRootPart"))
            if v169 then
                v167 = v169.Position
            else
                v167 = nil
            end
        else
            v167 = nil
        end
        for _, v170 in pairs(v_u_22) do
            v170:Update(p165, v167)
        end
    end)
end
return v_u_1
