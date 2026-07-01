-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local m_Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
local m_CloseButtonRegistry = require(ReplicatedStorage.Shared.CloseButtonRegistry)
local m_Rarities = require(ReplicatedStorage.Database.Custom.GameStats.Rarities)
local m_LevelsIcon = require(ReplicatedStorage.Database.Custom.GameStats.LevelsIcon)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_ActivateButton = require(ReplicatedStorage.Components.Common.InterfaceAnimations.ActivateButton)
local m_AttachGlovesToCharacter = require(ReplicatedStorage.Database.Components.Common.AttachGlovesToCharacter)
local m_Halftime = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.Halftime)
local v_u_22 = CFrame.new(-0.251, 0.806, -0.406) * CFrame.Angles(0, -1.5707963267948966, 1.5707963267948966)
local v_u_23 = {
    {
        ["maxLevel"] = 5,
        ["title"] = "Recruit"
    },
    {
        ["maxLevel"] = 10,
        ["title"] = "Private"
    },
    {
        ["maxLevel"] = 15,
        ["title"] = "Corporal"
    },
    {
        ["maxLevel"] = 20,
        ["title"] = "Sergeant"
    },
    {
        ["maxLevel"] = 25,
        ["title"] = "Master Sergeant"
    },
    {
        ["maxLevel"] = 30,
        ["title"] = "Lieutenant"
    },
    {
        ["maxLevel"] = 35,
        ["title"] = "Captain"
    },
    {
        ["maxLevel"] = 40,
        ["title"] = "Global Elite"
    }
}
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = workspace.CurrentCamera
local Characters = ReplicatedStorage.Assets.Characters
local v_u_28 = {
    {
        ["Entrance"] = "rbxassetid://100747011940776",
        ["Idle"] = "rbxassetid://100747011940776"
    },
    {
        ["Entrance"] = "rbxassetid://103701913618746",
        ["Idle"] = "rbxassetid://100955283476946"
    },
    {
        ["Entrance"] = "rbxassetid://91396952135880",
        ["Idle"] = "rbxassetid://120200138438261"
    },
    {
        ["Entrance"] = "rbxassetid://136102955582599",
        ["Idle"] = "rbxassetid://74544097369437"
    },
    {
        ["Entrance"] = "rbxassetid://71439100344953",
        ["Idle"] = "rbxassetid://122693948164334"
    }
}
local v_u_29 = {
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
local v_u_30 = {
    ["Counter-Terrorists"] = "CT",
    ["Terrorists"] = "T"
}
local v_u_31 = m_Janitor.new()
local v_u_32 = false
local v_u_33 = 0
local returnToMenu = true
local overlayMode = "EndScreen"
local v_u_36 = nil
local v_u_37 = nil
local v_u_38 = {
    ["RoundWonCT"] = true,
    ["RoundWonT"] = true,
    ["RoundLost"] = true,
    ["PlayerMVPCT"] = true,
    ["PlayerMVPT"] = true
}
local function v_u_49(p39) -- name: sortPlayersByADR
    local v40 = {}
    for v41, v42 in pairs(p39) do
        local Team = v42.Team
        if Team == "Counter-Terrorists" and true or Team == "Terrorists" then
            table.insert(v40, {
                ["userId"] = v41,
                ["data"] = v42
            })
        end
    end
    table.sort(v40, function(p44, p45)
        if (p44.data.ADR or 0) ~= (p45.data.ADR or 0) then
            return (p44.data.ADR or 0) > (p45.data.ADR or 0)
        end
        if (p44.data.Score or 0) ~= (p45.data.Score or 0) then
            return (p44.data.Score or 0) > (p45.data.Score or 0)
        end
        local userId = p44.userId
        local v47 = tonumber(userId) or (1 / 0)
        local userId_0 = p45.userId
        return v47 < (tonumber(userId_0) or (1 / 0))
    end)
    return v40
end
local function v_u_60(p50) -- name: rankFFAPlayers
    local v51 = {}
    for v52, v53 in pairs(p50) do
        local Team_0 = v53.Team
        if Team_0 == "Counter-Terrorists" and true or Team_0 == "Terrorists" then
            table.insert(v51, {
                ["userId"] = v52,
                ["data"] = v53
            })
        end
    end
    table.sort(v51, function(p55, p56)
        if (p55.data.Score or 0) ~= (p56.data.Score or 0) then
            return (p55.data.Score or 0) > (p56.data.Score or 0)
        end
        if (p55.data.Kills or 0) ~= (p56.data.Kills or 0) then
            return (p55.data.Kills or 0) > (p56.data.Kills or 0)
        end
        if (p55.data.Assists or 0) ~= (p56.data.Assists or 0) then
            return (p55.data.Assists or 0) > (p56.data.Assists or 0)
        end
        local userId_1 = p55.userId
        local v58 = tonumber(userId_1) or (1 / 0)
        local userId_2 = p56.userId
        return v58 < (tonumber(userId_2) or (1 / 0))
    end)
    return v51
end
local function v_u_66() -- name: cleanupDebris
    -- upvalues: (copy) LocalPlayer
    local Debris = workspace:FindFirstChild("Debris")
    if Debris then
        for _, v62 in Debris:GetChildren() do
            v62:Destroy()
        end
    end
    local Characters_0 = workspace:FindFirstChild("Characters")
    if Characters_0 then
        for _, v64 in Characters_0:GetChildren() do
            if v64:IsA("Folder") then
                for _, v65 in v64:GetChildren() do
                    v65:Destroy()
                end
            end
        end
    end
    if LocalPlayer.Character then
        LocalPlayer.Character:Destroy()
    end
end
local function v_u_69(p67, p68) -- name: setElementTransparency
    if p67:IsA("TextLabel") then
        p67.TextTransparency = p68
        return
    elseif p67:IsA("TextButton") then
        p67.TextTransparency = p68
        return
    elseif p67:IsA("ImageLabel") then
        p67.ImageTransparency = p68
        return
    elseif p67:IsA("ImageButton") then
        p67.ImageTransparency = p68
        return
    elseif p67:IsA("Frame") then
        p67.BackgroundTransparency = p68
    elseif p67:IsA("UIStroke") then
        p67.Transparency = p68
    end
end
local function v_u_73(p70, p71) -- name: tweenElementTransparency
    -- upvalues: (copy) TweenService
    local v72 = TweenInfo.new(0.5)
    if p70:IsA("TextLabel") or p70:IsA("TextButton") then
        TweenService:Create(p70, v72, {
            ["TextTransparency"] = p71
        }):Play()
        return
    elseif p70:IsA("ImageLabel") or p70:IsA("ImageButton") then
        TweenService:Create(p70, v72, {
            ["ImageTransparency"] = p71
        }):Play()
        return
    elseif p70:IsA("Frame") then
        TweenService:Create(p70, v72, {
            ["BackgroundTransparency"] = p71
        }):Play()
    elseif p70:IsA("UIStroke") then
        TweenService:Create(p70, v72, {
            ["Transparency"] = p71
        }):Play()
    end
end
local function v_u_76(p74) -- name: shouldSkipFade
    if p74:GetAttribute("SkipFade") then
        return true
    end
    local Parent = p74.Parent
    while Parent and Parent:IsA("GuiObject") do
        if Parent:GetAttribute("SkipFade") then
            return true
        end
        Parent = Parent.Parent
    end
    return false
end
local function v_u_81(p77, p78) -- name: fadeFrame
    -- upvalues: (copy) v_u_76, (copy) TweenService, (copy) v_u_73
    local v79
    if v_u_76(p77) then
        v79 = nil
    else
        v79 = TweenService:Create(p77, TweenInfo.new(0.5), {
            ["BackgroundTransparency"] = p78
        })
    end
    for _, v80 in p77:GetDescendants() do
        if not v_u_76(v80) then
            v_u_73(v80, p78)
        end
    end
    if v79 then
        v79:Play()
    end
    return v79
end
local function v_u_84(p82) -- name: fadeInFrame
    -- upvalues: (copy) v_u_76, (copy) v_u_69, (copy) v_u_81
    if not v_u_76(p82) then
        p82.BackgroundTransparency = 1
    end
    for _, v83 in p82:GetDescendants() do
        if not v_u_76(v83) then
            v_u_69(v83, 1)
        end
    end
    p82.Visible = true
    return v_u_81(p82, 0)
end
local function v_u_88(p85) -- name: storeFrameTransparency
    local v86 = {}
    for _, v87 in p85:GetDescendants() do
        if v87:IsA("UIStroke") then
            v86[v87] = v87.Transparency
        end
    end
    return {
        ["BackgroundTransparency"] = p85.BackgroundTransparency,
        ["Strokes"] = v86
    }
end
local function v_u_116(p89) -- name: populateLevelFrame
    -- upvalues: (copy) PlayerGui, (ref) v_u_37, (copy) m_DataController, (copy) LocalPlayer, (copy) v_u_23, (copy) m_LevelsIcon, (copy) v_u_88
    local MainGui_0 = PlayerGui:FindFirstChild("MainGui")
    local v91
    if MainGui_0 then
        local Gameplay = MainGui_0:FindFirstChild("Gameplay")
        if Gameplay then
            v91 = Gameplay:FindFirstChild("Middle")
        else
            v91 = nil
        end
    else
        v91 = nil
    end
    local v93
    if v91 then
        v93 = v91:FindFirstChild("EndScreen")
    else
        v93 = nil
    end
    if not v93 then
        return nil
    end
    local Level_0 = v93:FindFirstChild("Level")
    if not Level_0 then
        return nil
    end
    local v95 = v_u_37 or m_DataController.Get(LocalPlayer, "Level")
    if not v95 then
        return nil
    end
    local v96 = v95.Level or 1
    local v97 = v95.Experience or 0
    local v98 = v95.NextExperienceRequirement or 1000
    local TextLabel = Level_0:FindFirstChild("TextLabel")
    if not TextLabel then
        ::l18::
        local Rank = Level_0:FindFirstChild("Rank")
        if Rank then
            Rank.Image = m_LevelsIcon[tostring(v96)] or ""
        end
        local LevelBar = Level_0:FindFirstChild("LevelBar")
        if not LevelBar then
            return nil
        end
        local Current = LevelBar:FindFirstChild("Current")
        local Earned = LevelBar:FindFirstChild("Earned")
        if not (Current and Earned) then
            return nil
        end
        local CurrentInfo = Level_0:FindFirstChild("CurrentInfo", true)
        local EarnedInfo = Level_0:FindFirstChild("EarnedInfo", true)
        if not (CurrentInfo and EarnedInfo) then
            return nil
        end
        Current:SetAttribute("SkipFade", true)
        Earned:SetAttribute("SkipFade", true)
        CurrentInfo:SetAttribute("SkipFade", true)
        EarnedInfo:SetAttribute("SkipFade", true)
        local v106 = ("%*xp"):format(v97)
        local Amount = CurrentInfo:FindFirstChild("Amount")
        if Amount then
            Amount.Text = v106
        end
        local v108 = ("+%*xp"):format(p89)
        local Amount_0 = EarnedInfo:FindFirstChild("Amount")
        if Amount_0 then
            Amount_0.Text = v108
        end
        local v110 = Current.Size.Y
        local v111 = v_u_88(CurrentInfo)
        local v112 = v_u_88(EarnedInfo)
        return {
            ["currentXP"] = v97,
            ["xpEarned"] = p89,
            ["nextLevelXP"] = math.max(v98, 1),
            ["currentLevel"] = v96,
            ["barHeight"] = v110,
            ["levelBar"] = LevelBar,
            ["levelFrame"] = Level_0,
            ["currentBar"] = Current,
            ["earnedBar"] = Earned,
            ["currentInfo"] = CurrentInfo,
            ["earnedInfo"] = EarnedInfo,
            ["currentInfoTransparency"] = v111,
            ["earnedInfoTransparency"] = v112
        }
    end
    local v113 = "[%* Rank %*]"
    for _, v114 in ipairs(v_u_23) do
        if v96 <= v114.maxLevel then
            title = v114.title
            ::l22::
            TextLabel.Text = v113:format(title, v96)
            goto l18
        end
    end
    local title = "Global Elite"
    goto l22
end
local function v_u_127(p117, p118, p119, p120) -- name: tweenInfoToBarEnd
    -- upvalues: (copy) TweenService
    local Position = p117.Position
    local v122 = p118.AbsolutePosition.X + p119 * p118.AbsoluteSize.X
    local Parent_0 = p117.Parent
    local v124 = Parent_0 and Parent_0.AbsolutePosition.X or 0
    local v125 = p117.AnchorPoint.X * p117.AbsoluteSize.X
    local v126 = v122 - v124 + v125
    return TweenService:Create(p117, p120, {
        ["Position"] = UDim2.new(0, v126, Position.Y.Scale, Position.Y.Offset)
    })
end
local function v_u_144(p128, p129, p130) -- name: getAdjustedEarnedPosition
    local v131 = p128.AbsolutePosition.Y
    local v132 = p128.AbsolutePosition.X + p128.AbsoluteSize.X
    local v133 = p129.Parent.AbsolutePosition.X
    local v134 = p129.AnchorPoint.X * p129.AbsoluteSize.X
    if v133 + p130 - v134 >= v132 + 5 then
        local Parent_1 = p129.Parent
        local v136 = Parent_1 and Parent_1.AbsolutePosition.Y or 0
        local v137 = p129.AnchorPoint.Y * p129.AbsoluteSize.Y
        local v138 = v131 - v136 + v137
        return UDim2.new(0, p130, 0, v138)
    end
    local v139 = v131 + p128.AbsoluteSize.Y + -2
    local Parent_2 = p129.Parent
    local v141 = Parent_2 and Parent_2.AbsolutePosition.Y or 0
    local v142 = p129.AnchorPoint.Y * p129.AbsoluteSize.Y
    local v143 = v139 - v141 + v142
    return UDim2.new(0, p130, 0, v143)
end
local function v_u_154(p145, p146, p147, p148, p149) -- name: tweenInfoToBarEndWithOverlapCheck
    -- upvalues: (copy) v_u_144, (copy) TweenService
    local v150 = p147.AbsolutePosition.X + p148 * p147.AbsoluteSize.X
    local Parent_3 = p145.Parent
    local v152 = Parent_3 and Parent_3.AbsolutePosition.X or 0
    local v153 = p145.AnchorPoint.X * p145.AbsoluteSize.X
    return TweenService:Create(p145, p149, {
        ["Position"] = v_u_144(p146, p145, v150 - v152 + v153)
    })
end
local function v_u_258(p155) -- name: animateLevelBar
    -- upvalues: (ref) v_u_32, (copy) TweenService, (copy) v_u_127, (copy) m_Sound, (copy) CurrentCamera, (copy) v_u_144, (copy) v_u_154, (copy) v_u_23, (copy) m_LevelsIcon
    if not v_u_32 then
        return
    end
    local nextLevelXP = p155.currentXP / p155.nextLevelXP
    local v157 = math.clamp(nextLevelXP, 0, 1)
    local xpEarned = p155.currentXP + p155.xpEarned
    local nextLevelXP_0 = xpEarned / p155.nextLevelXP
    local v160 = math.clamp(nextLevelXP_0, 0, 1)
    local v161 = p155.nextLevelXP <= xpEarned
    p155.currentBar.Visible = false
    p155.earnedBar.Visible = false
    local currentBar = p155.currentBar
    local barHeight = p155.barHeight
    currentBar.Size = UDim2.new(0, 0, barHeight.Scale, barHeight.Offset)
    local earnedBar = p155.earnedBar
    local barHeight_0 = p155.barHeight
    earnedBar.Size = UDim2.new(0, 0, barHeight_0.Scale, barHeight_0.Offset)
    p155.currentInfo.Visible = false
    p155.earnedInfo.Visible = false
    local currentInfo = p155.currentInfo
    local currentInfoTransparency = p155.currentInfoTransparency
    currentInfo.BackgroundTransparency = currentInfoTransparency.BackgroundTransparency
    for v168, v169 in pairs(currentInfoTransparency.Strokes) do
        if v168 and v168.Parent then
            v168.Transparency = v169
        end
    end
    local earnedInfo = p155.earnedInfo
    local earnedInfoTransparency = p155.earnedInfoTransparency
    earnedInfo.BackgroundTransparency = earnedInfoTransparency.BackgroundTransparency
    for v172, v173 in pairs(earnedInfoTransparency.Strokes) do
        if v172 and v172.Parent then
            v172.Transparency = v173
        end
    end
    local levelBar = p155.levelBar
    local currentInfo_0 = p155.currentInfo
    local v176 = levelBar.AbsolutePosition.X + 0 * levelBar.AbsoluteSize.X
    local Parent_4 = currentInfo_0.Parent
    local v178 = Parent_4 and Parent_4.AbsolutePosition.X or 0
    local v179 = currentInfo_0.AnchorPoint.X * currentInfo_0.AbsoluteSize.X
    local v180 = v176 - v178 + v179
    local levelBar_0 = p155.levelBar
    local earnedInfo_0 = p155.earnedInfo
    local v183 = levelBar_0.AbsolutePosition.X + 0 * levelBar_0.AbsoluteSize.X
    local Parent_5 = earnedInfo_0.Parent
    local v185 = Parent_5 and Parent_5.AbsolutePosition.X or 0
    local v186 = earnedInfo_0.AnchorPoint.X * earnedInfo_0.AbsoluteSize.X
    local v187 = v183 - v185 + v186
    local Position_0 = p155.currentInfo.Position
    local Position_1 = p155.earnedInfo.Position
    p155.currentInfo.Position = UDim2.new(0, v180, Position_0.Y.Scale, Position_0.Y.Offset)
    p155.earnedInfo.Position = UDim2.new(0, v187, Position_1.Y.Scale, Position_1.Y.Offset)
    task.wait(0.5)
    if not v_u_32 then
        return
    end
    p155.currentBar.Visible = true
    p155.currentInfo.Visible = true
    if v157 > 0 then
        local v190 = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local v191 = TweenService
        local currentBar_0 = p155.currentBar
        local v193 = {}
        local barHeight_1 = p155.barHeight
        v193.Size = UDim2.new(v157, 0, barHeight_1.Scale, barHeight_1.Offset)
        local v195 = v191:Create(currentBar_0, v190, v193)
        local v196 = v_u_127(p155.currentInfo, p155.levelBar, v157, v190)
        local v197 = {
            ["Parent"] = nil,
            ["Name"] = "XP Bar Fill",
            ["Parent"] = CurrentCamera
        }
        m_Sound.new("Interface"):play(v197)
        v195:Play()
        v196:Play()
        v195.Completed:Wait()
        if not v_u_32 then
            return
        end
    end
    if p155.xpEarned <= 0 then
        return
    end
    task.wait(0.6)
    if not v_u_32 then
        return
    end
    local earnedBar_0 = p155.earnedBar
    local barHeight_2 = p155.barHeight
    earnedBar_0.Size = UDim2.new(v157, 0, barHeight_2.Scale, barHeight_2.Offset)
    p155.earnedBar.Visible = true
    p155.earnedInfo.Visible = true
    local levelBar_1 = p155.levelBar
    local earnedInfo_1 = p155.earnedInfo
    local v202 = levelBar_1.AbsolutePosition.X + v157 * levelBar_1.AbsoluteSize.X
    local Parent_6 = earnedInfo_1.Parent
    local v204 = Parent_6 and Parent_6.AbsolutePosition.X or 0
    local v205 = earnedInfo_1.AnchorPoint.X * earnedInfo_1.AbsoluteSize.X
    local v206 = v202 - v204 + v205
    local v207 = v_u_144(p155.currentInfo, p155.earnedInfo, v206)
    p155.earnedInfo.Position = v207
    if not v161 then
        local v208 = TweenInfo.new(0.75, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local v209 = TweenService
        local earnedBar_1 = p155.earnedBar
        local v211 = {}
        local barHeight_3 = p155.barHeight
        v211.Size = UDim2.new(v160, 0, barHeight_3.Scale, barHeight_3.Offset)
        local v213 = v209:Create(earnedBar_1, v208, v211)
        local v214 = v_u_154(p155.earnedInfo, p155.currentInfo, p155.levelBar, v160, v208)
        local v215 = {
            ["Parent"] = nil,
            ["Name"] = "XP Bar Fill",
            ["Parent"] = CurrentCamera
        }
        local v216 = m_Sound.new("Interface"):play(v215)
        if v216 then
            v216.PlaybackSpeed = 1.15
        end
        v213:Play()
        v214:Play()
        v213.Completed:Wait()
        return
    end
    local v217 = TweenInfo.new(0.375, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local v218 = TweenService
    local earnedBar_2 = p155.earnedBar
    local v220 = {}
    local barHeight_4 = p155.barHeight
    v220.Size = UDim2.new(1, 0, barHeight_4.Scale, barHeight_4.Offset)
    local v222 = v218:Create(earnedBar_2, v217, v220)
    local v223 = v_u_154(p155.earnedInfo, p155.currentInfo, p155.levelBar, 1, v217)
    local v224 = {
        ["Parent"] = nil,
        ["Name"] = "XP Bar Fill",
        ["Parent"] = CurrentCamera
    }
    local v225 = m_Sound.new("Interface"):play(v224)
    if v225 then
        v225.PlaybackSpeed = 1.15
    end
    v222:Play()
    v223:Play()
    v222.Completed:Wait()
    if not v_u_32 then
        return
    end
    local v226 = {
        ["Parent"] = nil,
        ["Name"] = "Level Up",
        ["Parent"] = CurrentCamera
    }
    m_Sound.new("Interface"):play(v226)
    local nextLevelXP_1 = (xpEarned - p155.nextLevelXP) / p155.nextLevelXP
    local v228 = math.clamp(nextLevelXP_1, 0, 1)
    local v229 = p155.currentLevel + 1
    local TextLabel_0 = p155.levelFrame:FindFirstChild("TextLabel")
    if not TextLabel_0 then
        ::l41::
        local Rank_0 = p155.levelFrame:FindFirstChild("Rank")
        if Rank_0 then
            Rank_0.Image = m_LevelsIcon[tostring(v229)] or ""
        end
        local currentBar_1 = p155.currentBar
        local barHeight_5 = p155.barHeight
        currentBar_1.Size = UDim2.new(0, 0, barHeight_5.Scale, barHeight_5.Offset)
        local earnedBar_3 = p155.earnedBar
        local barHeight_6 = p155.barHeight
        earnedBar_3.Size = UDim2.new(0, 0, barHeight_6.Scale, barHeight_6.Offset)
        p155.currentInfo.Visible = false
        local levelBar_2 = p155.levelBar
        local earnedInfo_2 = p155.earnedInfo
        local v238 = levelBar_2.AbsolutePosition.X + 0 * levelBar_2.AbsoluteSize.X
        local Parent_7 = earnedInfo_2.Parent
        local v240 = Parent_7 and Parent_7.AbsolutePosition.X or 0
        local v241 = earnedInfo_2.AnchorPoint.X * earnedInfo_2.AbsoluteSize.X
        local v242 = v238 - v240 + v241
        local earnedInfo_3 = p155.earnedInfo
        local v244 = p155.currentInfo.AbsolutePosition.Y
        local Parent_8 = earnedInfo_3.Parent
        local v246 = Parent_8 and Parent_8.AbsolutePosition.Y or 0
        local v247 = earnedInfo_3.AnchorPoint.Y * earnedInfo_3.AbsoluteSize.Y
        local v248 = v244 - v246 + v247
        p155.earnedInfo.Position = UDim2.new(0, v242, 0, v248)
        local v249 = TweenService
        local earnedBar_4 = p155.earnedBar
        local v251 = {}
        local barHeight_7 = p155.barHeight
        v251.Size = UDim2.new(v228, 0, barHeight_7.Scale, barHeight_7.Offset)
        local v253 = v249:Create(earnedBar_4, v217, v251)
        local v254 = v_u_127(p155.earnedInfo, p155.levelBar, v228, v217)
        v253:Play()
        v254:Play()
        v253.Completed:Wait()
        return
    end
    local v255 = "[%* Rank %*]"
    for _, v256 in ipairs(v_u_23) do
        if v229 <= v256.maxLevel then
            title_0 = v256.title
            ::l45::
            TextLabel_0.Text = v255:format(title_0, v229)
            goto l41
        end
    end
    local title_0 = "Global Elite"
    goto l45
end
local function v_u_264(p259) -- name: getItemIcon
    -- upvalues: (copy) m_Cases, (copy) m_Skins
    local v260 = not p259.Type and "" or string.lower(p259.Type)
    local Name = p259.Name
    if v260 == "credits" then
        return "rbxassetid://115958498634807"
    end
    if v260 == "case" or (v260 == "sticker capsule" or (v260 == "charm pack" or v260 == "charm capsule")) then
        local v262 = m_Cases.GetCaseByName(Name)
        if v262 and v262.imageAssetId then
            return v262.imageAssetId
        end
    end
    local v263 = p259.Skin and (Name and m_Skins.GetSkinInformation(Name, p259.Skin))
    if v263 then
        if v263.wearImages and v263.wearImages[1] then
            return v263.wearImages[1].assetId
        end
        if v263.charmImages and v263.charmImages[1] then
            return v263.charmImages[1].assetId
        end
        if v263.imageAssetId then
            return v263.imageAssetId
        end
    end
    return "rbxassetid://18822070027"
end
local function v_u_292(p265) -- name: displayDrops
    -- upvalues: (ref) v_u_32, (copy) PlayerGui, (copy) v_u_264, (copy) m_Rarities, (copy) v_u_84, (copy) TweenService, (copy) v_u_31
    if v_u_32 and (p265 and #p265 ~= 0) then
        local MainGui_1 = PlayerGui:FindFirstChild("MainGui")
        local v267
        if MainGui_1 then
            local Gameplay_0 = MainGui_1:FindFirstChild("Gameplay")
            if Gameplay_0 then
                v267 = Gameplay_0:FindFirstChild("Middle")
            else
                v267 = nil
            end
        else
            v267 = nil
        end
        local v269
        if v267 then
            v269 = v267:FindFirstChild("EndScreen")
        else
            v269 = nil
        end
        if v269 then
            local Drops = v269:FindFirstChild("Drops")
            local v271
            if Drops then
                v271 = Drops:FindFirstChild("Container")
            else
                v271 = Drops
            end
            local v272
            if v271 then
                v272 = v271:FindFirstChild("ItemTemplate")
            else
                v272 = v271
            end
            if v272 then
                v271:SetAttribute("SkipFade", true)
                v272.Visible = false
                for _, v273 in v271:GetChildren() do
                    if v273:IsA("Frame") and v273.Name ~= "ItemTemplate" then
                        v273:Destroy()
                    end
                end
                Drops.Visible = false
                task.wait(0.8)
                if v_u_32 then
                    local v274 = {}
                    for v275, v276 in ipairs(p265) do
                        local reward = v276.reward
                        local v278 = reward.type == "credits"
                        local v279 = reward.inventoryItem
                        if v278 or v279 then
                            local v280 = v272:Clone()
                            v280.Name = "Drop_" .. v275
                            v280.Visible = false
                            v280.Parent = v271
                            local Content = v280:FindFirstChild("Content")
                            if Content then
                                local Icon = Content:FindFirstChild("Icon")
                                if Icon then
                                    Icon.Image = v278 and "rbxassetid://115958498634807" or v_u_264(v279)
                                end
                                local Amount_1 = Content:FindFirstChild("amount") or Content:FindFirstChild("Amount")
                                if Amount_1 then
                                    if v278 and reward.amount then
                                        Amount_1.Visible = true
                                        Amount_1.Text = ("x%*"):format(reward.amount)
                                    else
                                        Amount_1.Visible = false
                                    end
                                end
                                local v284 = Content:FindFirstChild("RarityFrame")
                                if v284 then
                                    v284 = v284:FindFirstChild("UIGradient")
                                end
                                if v284 then
                                    if v278 then
                                        v279 = "Rare"
                                    elseif v279 then
                                        v279 = v279.Rarity
                                    end
                                    if v279 then
                                        local v285 = m_Rarities[v279]
                                        if v285 and v285.ColorSequence then
                                            v284.Color = v285.ColorSequence
                                        end
                                    end
                                end
                                local Size = Content.Size
                                Content.Size = UDim2.new(Size.X.Scale * 1.25, Size.X.Offset * 1.25, Size.Y.Scale * 1.25, Size.Y.Offset * 1.25)
                                local Player = v280:FindFirstChild("Player", true)
                                if Player and v276.userId > 0 then
                                    Player.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(v276.userId)
                                end
                                table.insert(v274, {
                                    ["item"] = v280,
                                    ["content"] = Content,
                                    ["originalSize"] = Size
                                })
                            else
                                v280:Destroy()
                            end
                        end
                    end
                    if #v274 == 0 then
                        return
                    else
                        v_u_84(Drops)
                        task.wait(0.5)
                        if v_u_32 then
                            local v_u_288 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                            for v289, v_u_290 in ipairs(v274) do
                                task.delay((v289 - 1) * 0.35, function()
                                    -- upvalues: (ref) v_u_32, (copy) v_u_290, (ref) TweenService, (copy) v_u_288, (ref) v_u_31
                                    if v_u_32 then
                                        v_u_290.item.Visible = true
                                        local v291 = TweenService:Create(v_u_290.content, v_u_288, {
                                            ["Size"] = v_u_290.originalSize
                                        })
                                        v_u_31:Add(v291, "Cancel")
                                        v291:Play()
                                    end
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
        else
            return
        end
    else
        return
    end
end
local function v_u_301(p293) -- name: captureVisibilitySnapshot
    -- upvalues: (ref) v_u_36
    local Gameplay_1 = p293:FindFirstChild("Gameplay")
    local Menu = p293:FindFirstChild("Menu")
    local v296
    if Gameplay_1 then
        v296 = Gameplay_1:FindFirstChild("Middle") or nil
    else
        v296 = nil
    end
    local v297 = {}
    local v298
    if Gameplay_1 then
        v298 = Gameplay_1.Visible or false
    else
        v298 = false
    end
    v297.GameplayVisible = v298
    v297.MenuVisible = Menu and Menu.Visible or false
    v297.GameplayChildren = {}
    v297.MiddleChildren = {}
    if Gameplay_1 then
        for _, v299 in Gameplay_1:GetChildren() do
            if v299:IsA("Frame") or v299:IsA("CanvasGroup") then
                v297.GameplayChildren[v299.Name] = v299.Visible
            end
        end
    end
    if v296 then
        for _, v300 in v296:GetChildren() do
            if v300:IsA("Frame") or v300:IsA("CanvasGroup") then
                v297.MiddleChildren[v300.Name] = v300.Visible
            end
        end
    end
    v_u_36 = v297
end
local function v_u_314(p302, p303) -- name: restoreVisibilitySnapshot
    -- upvalues: (ref) v_u_36, (copy) v_u_38
    if v_u_36 then
        local v304 = v_u_36
        v_u_36 = nil
        local Gameplay_2 = p302:FindFirstChild("Gameplay")
        local Menu_0 = p302:FindFirstChild("Menu")
        local v307
        if Gameplay_2 then
            v307 = Gameplay_2:FindFirstChild("Middle") or nil
        else
            v307 = nil
        end
        if Menu_0 then
            Menu_0.Visible = v304.MenuVisible
        end
        if Gameplay_2 then
            Gameplay_2.Visible = v304.GameplayVisible
            for _, v308 in Gameplay_2:GetChildren() do
                if v308:IsA("Frame") or v308:IsA("CanvasGroup") then
                    local v309 = v304.GameplayChildren[v308.Name]
                    if v309 ~= nil then
                        v308.Visible = v309
                    end
                end
            end
        end
        if v307 then
            for _, v310 in v307:GetChildren() do
                if v310:IsA("Frame") or v310:IsA("CanvasGroup") then
                    local v311 = v304.MiddleChildren[v310.Name]
                    if v311 ~= nil then
                        v310.Visible = v311
                    end
                end
            end
            if p303 then
                for v312 in pairs(v_u_38) do
                    local v313 = v307:FindFirstChild(v312)
                    if v313 and (v313:IsA("Frame") or v313:IsA("CanvasGroup")) then
                        v313.Visible = false
                    end
                end
            end
        end
    end
end
local function v_u_323(p315) -- name: enforceEndScreenVisibility
    -- upvalues: (ref) overlayMode, (copy) m_MenuState
    local v316 = overlayMode == "Halftime"
    if p315:FindFirstChild("Menu") then
        m_MenuState.HideMenu()
    end
    local Gameplay_3 = p315:FindFirstChild("Gameplay")
    if Gameplay_3 then
        local Middle = Gameplay_3:FindFirstChild("Middle")
        local v319
        if Middle then
            v319 = Middle:FindFirstChild("EndScreen") or nil
        else
            v319 = nil
        end
        local v320
        if Middle then
            v320 = Middle:FindFirstChild("Halftime") or nil
        else
            v320 = nil
        end
        Gameplay_3.Visible = true
        for _, v321 in Gameplay_3:GetChildren() do
            if v321:IsA("Frame") or v321:IsA("CanvasGroup") then
                v321.Visible = v321 == Middle
            end
        end
        if Middle then
            Middle.Visible = true
            for _, v322 in Middle:GetChildren() do
                if v322:IsA("Frame") or v322:IsA("CanvasGroup") then
                    if v322 == v319 then
                        v322.Visible = not v316
                    elseif v322 == v320 then
                        v322.Visible = v316
                    else
                        v322.Visible = false
                    end
                end
            end
            if v319 then
                v319.Visible = not v316
            end
            if v320 then
                v320.Visible = v316
            end
        end
    else
        return
    end
end
local function v_u_361(p324) -- name: showEndScreenUI
    -- upvalues: (copy) PlayerGui, (copy) v_u_301, (copy) m_CameraController, (copy) m_MenuState, (copy) m_Halftime, (copy) v_u_31, (copy) m_RunServiceController, (copy) v_u_323, (copy) v_u_69
    local didWin = p324.didWin
    local isDraw = p324.isDraw
    local winningTeam = p324.winningTeam
    local ctScore = p324.ctScore
    local tScore = p324.tScore
    local scoreTextOverride = p324.scoreTextOverride
    local showAccolades = p324.showAccolades
    local returnToMenu_0 = p324.returnToMenu
    local v333 = p324.overlayMode == "Halftime"
    local halftimeTeam = p324.halftimeTeam
    local MainGui = PlayerGui:FindFirstChild("MainGui")
    if MainGui then
        v_u_301(MainGui)
        m_CameraController.setForceLockOverride("EndScreen", true)
        m_CameraController.setPerspective(false, true)
        if MainGui:FindFirstChild("Menu") then
            m_MenuState.HideMenu()
            m_CameraController.setForceLockOverride("Menu", false)
        end
        local Gameplay_4 = MainGui:FindFirstChild("Gameplay")
        if Gameplay_4 then
            Gameplay_4.Visible = true
            for _, v337 in Gameplay_4:GetChildren() do
                if v337:IsA("Frame") or v337:IsA("CanvasGroup") then
                    v337.Visible = false
                end
            end
            local Middle_0 = Gameplay_4:FindFirstChild("Middle")
            if Middle_0 then
                for _, v339 in Middle_0:GetChildren() do
                    if v339:IsA("Frame") or v339:IsA("CanvasGroup") then
                        v339.Visible = false
                    end
                end
                Middle_0.Visible = true
                local EndScreen = Middle_0:FindFirstChild("EndScreen")
                local Halftime = Middle_0:FindFirstChild("Halftime")
                if v333 then
                    if EndScreen then
                        EndScreen.Visible = false
                    end
                    if Halftime and (halftimeTeam == "Counter-Terrorists" or halftimeTeam == "Terrorists") then
                        m_Halftime.Show(halftimeTeam)
                    else
                        m_Halftime.Hide()
                    end
                    v_u_31:Add(m_RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function()
                        -- upvalues: (ref) v_u_323, (copy) MainGui
                        v_u_323(MainGui)
                    end), "Disconnect", "EndScreenVisibilityLock")
                    return
                else
                    m_Halftime.Hide()
                    if EndScreen then
                        local MapVote = EndScreen:FindFirstChild("MapVote")
                        if MapVote then
                            MapVote.Visible = false
                        end
                        local Top = EndScreen:FindFirstChild("Top")
                        if Top then
                            Top.Visible = false
                        end
                        EndScreen.Visible = true
                        local Victory_0 = EndScreen:FindFirstChild("Victory")
                        local Defeat_0 = EndScreen:FindFirstChild("Defeat")
                        if Victory_0 then
                            Victory_0.BackgroundTransparency = 0
                            for _, v346 in Victory_0:GetDescendants() do
                                v_u_69(v346, 0)
                            end
                            Victory_0.Visible = isDraw or didWin
                        end
                        if Defeat_0 then
                            Defeat_0.BackgroundTransparency = 0
                            for _, v347 in Defeat_0:GetDescendants() do
                                v_u_69(v347, 0)
                            end
                            local v348 = not isDraw
                            if v348 then
                                v348 = not didWin
                            end
                            Defeat_0.Visible = v348
                        end
                        local MVP = EndScreen:FindFirstChild("MVP")
                        if MVP then
                            MVP.Visible = showAccolades
                        end
                        local Close = EndScreen:FindFirstChild("Close")
                        if Close then
                            Close.Visible = returnToMenu_0
                        end
                        local v351
                        if isDraw then
                            v351 = scoreTextOverride or ("<b>%*</b> - %*"):format(ctScore, tScore)
                        else
                            if winningTeam == "Counter-Terrorists" then
                                local v352 = ctScore
                                ctScore = tScore
                                tScore = v352
                            end
                            v351 = scoreTextOverride or ("<b>%*</b> - %*"):format(tScore, ctScore)
                        end
                        local Score = Victory_0 and Victory_0:FindFirstChild("Score")
                        if Score then
                            Score.BackgroundColor3 = Color3.fromRGB(11, 97, 31)
                            Score.Glow.ImageColor3 = Color3.fromRGB(46, 158, 78)
                            Score.Pattern.ImageColor3 = Color3.fromRGB(134, 255, 78)
                            Score.UIStroke.Color = Color3.fromRGB(48, 127, 48)
                            local TextLabel_1 = Score:FindFirstChild("TextLabel")
                            if TextLabel_1 then
                                TextLabel_1.Text = v351
                            end
                        end
                        local Score_0 = Defeat_0 and Defeat_0:FindFirstChild("Score")
                        if Score_0 then
                            Score_0.BackgroundColor3 = Color3.fromRGB(83, 9, 9)
                            Score_0.Glow.ImageColor3 = Color3.fromRGB(158, 14, 14)
                            Score_0.Pattern.ImageColor3 = Color3.fromRGB(255, 53, 53)
                            Score_0.UIStroke.Color = Color3.fromRGB(127, 48, 48)
                            local TextLabel_2 = Score_0:FindFirstChild("TextLabel")
                            if TextLabel_2 then
                                TextLabel_2.Text = v351
                            end
                        end
                        local TextLabel_3 = Victory_0 and Victory_0:FindFirstChild("TextLabel")
                        if TextLabel_3 then
                            TextLabel_3.Text = isDraw and "Draw" or "Victory"
                        end
                        local TextLabel_4 = Defeat_0 and Defeat_0:FindFirstChild("TextLabel")
                        if TextLabel_4 then
                            TextLabel_4.Text = isDraw and "Draw" or "Defeat"
                        end
                        local Level_1 = EndScreen:FindFirstChild("Level")
                        if Level_1 then
                            Level_1.Visible = false
                        end
                        local Drops_0 = EndScreen:FindFirstChild("Drops")
                        if Drops_0 then
                            Drops_0.Visible = false
                        end
                        v_u_31:Add(m_RunServiceController.BindToRenderStep("EndScreenController.VisibilityLock", function()
                            -- upvalues: (ref) v_u_323, (copy) MainGui
                            v_u_323(MainGui)
                        end), "Disconnect", "EndScreenVisibilityLock")
                    end
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
local function v_u_382() -- name: hideEndScreenUI
    -- upvalues: (copy) PlayerGui, (copy) m_Halftime
    local MainGui_2 = PlayerGui:FindFirstChild("MainGui")
    if MainGui_2 then
        local Gameplay_5 = MainGui_2:FindFirstChild("Gameplay")
        if Gameplay_5 then
            local Middle_1 = Gameplay_5:FindFirstChild("Middle")
            if Middle_1 then
                local EndScreen_0 = Middle_1:FindFirstChild("EndScreen")
                if EndScreen_0 then
                    EndScreen_0.Visible = false
                    m_Halftime.Hide()
                    local Victory_1 = EndScreen_0:FindFirstChild("Victory")
                    local Defeat_1 = EndScreen_0:FindFirstChild("Defeat")
                    local Level_2 = EndScreen_0:FindFirstChild("Level")
                    if Victory_1 then
                        Victory_1.Visible = false
                    end
                    if Defeat_1 then
                        Defeat_1.Visible = false
                    end
                    if Level_2 then
                        Level_2.Visible = false
                        local LevelBar_0 = Level_2:FindFirstChild("LevelBar")
                        if LevelBar_0 then
                            local Current_0 = LevelBar_0:FindFirstChild("Current")
                            local Earned_0 = LevelBar_0:FindFirstChild("Earned")
                            if Current_0 then
                                Current_0:SetAttribute("SkipFade", nil)
                            end
                            if Earned_0 then
                                Earned_0:SetAttribute("SkipFade", nil)
                            end
                        end
                        local CurrentInfo_0 = Level_2:FindFirstChild("CurrentInfo", true)
                        local EarnedInfo_0 = Level_2:FindFirstChild("EarnedInfo", true)
                        if CurrentInfo_0 then
                            CurrentInfo_0:SetAttribute("SkipFade", nil)
                        end
                        if EarnedInfo_0 then
                            EarnedInfo_0:SetAttribute("SkipFade", nil)
                        end
                    end
                    local MVP_0 = EndScreen_0:FindFirstChild("MVP")
                    if MVP_0 then
                        MVP_0.Visible = false
                        for v375 = 1, 5 do
                            local v376 = MVP_0:FindFirstChild((tostring(v375)))
                            if v376 then
                                v376.Visible = false
                            end
                        end
                    end
                    local Drops_1 = EndScreen_0:FindFirstChild("Drops")
                    if Drops_1 then
                        Drops_1.Visible = false
                        local Container = Drops_1:FindFirstChild("Container")
                        if Container then
                            Container:SetAttribute("SkipFade", nil)
                            for _, v379 in Container:GetChildren() do
                                if v379:IsA("Frame") and v379.Name ~= "ItemTemplate" then
                                    v379:Destroy()
                                end
                            end
                        end
                    end
                    local MapVote_0 = EndScreen_0:FindFirstChild("MapVote")
                    if MapVote_0 then
                        MapVote_0.Visible = true
                    end
                    local Top_0 = EndScreen_0:FindFirstChild("Top")
                    if Top_0 then
                        Top_0.Visible = true
                    end
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
local function v_u_386(p383) -- name: findInventoryItem
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer
    local v384 = m_DataController.Get(LocalPlayer, "Inventory")
    if type(v384) ~= "table" then
        return nil
    end
    for _, v385 in ipairs(v384) do
        if v385 and v385._id == p383 then
            return v385
        end
    end
    return nil
end
local function v_u_403(p387, p388, p389) -- name: attachGlovesToCharacter
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer, (copy) v_u_386, (copy) v_u_29, (copy) m_Skins, (copy) ReplicatedStorage, (copy) m_AttachGlovesToCharacter
    local Name_0 = nil
    local Skin = nil
    local Float = nil
    if p389 then
        Name_0 = p389.Name
        Skin = p389.Skin
        Float = p389.Float
    else
        local v393 = p388 == "CT" and "Counter-Terrorists" or "Terrorists"
        local v394 = m_DataController.Get(LocalPlayer, "Loadout")
        local v395
        if type(v394) == "table" then
            local v396 = v394[v393]
            if type(v396) == "table" and v396.Equipped then
                v395 = v396.Equipped["Equipped Gloves"]
                if type(v395) ~= "string" or v395 == "" then
                    v395 = nil
                end
            else
                v395 = nil
            end
        else
            v395 = nil
        end
        if v395 then
            local v397 = v_u_386(v395)
            if v397 then
                Name_0 = v397.Name
                Skin = v397.Skin
                Float = v397.Float
            end
        end
    end
    local Glove = Name_0 or v_u_29[p388].Glove
    local v399
    if Skin and (Skin ~= "" and Float ~= nil) then
        v399 = m_Skins.GetGloves(Glove, Skin, Float) or nil
    else
        v399 = nil
    end
    local v400
    if v399 then
        v400 = v399:GetChildren()
    else
        local v401 = ReplicatedStorage.Assets.Weapons:FindFirstChild(Glove)
        if not v401 then
            return
        end
        v400 = v401:GetChildren()
    end
    local v402 = p387:FindFirstChild("CharacterArmor") or Instance.new("Folder")
    v402.Name = "CharacterArmor"
    v402.Parent = p387
    m_AttachGlovesToCharacter(v400, p387, v402)
end
local function v_u_413(p404, p405) -- name: getEquippedWeaponFromLoadout
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer
    local v406 = m_DataController.Get(LocalPlayer, "Loadout")
    if type(v406) ~= "table" then
        return nil
    end
    local v407 = v406[p404]
    if type(v407) ~= "table" or not v407.Loadout then
        return nil
    end
    local Rifles = v407.Loadout.Rifles
    if Rifles then
        local Options = Rifles.Options
        if type(Options) == "table" then
            local v410 = m_DataController.Get(LocalPlayer, "Inventory")
            if type(v410) ~= "table" then
                return nil
            end
            for _, v411 in ipairs(Rifles.Options) do
                if type(v411) == "string" and v411 ~= "" then
                    for _, v412 in ipairs(v410) do
                        if v412 and (v412._id == v411 and v412.Name == p405) then
                            return {
                                ["Skin"] = v412.Skin,
                                ["Float"] = v412.Float,
                                ["StatTrack"] = v412.StatTrack,
                                ["NameTag"] = v412.NameTag
                            }
                        end
                    end
                end
            end
            return nil
        end
    end
    return nil
end
local function v_u_428(p414, p415, p416) -- name: attachWeaponToCharacter
    -- upvalues: (copy) v_u_29, (copy) m_Skins, (copy) v_u_413, (copy) v_u_22
    local Weapon = v_u_29[p415].Weapon
    local v418 = nil
    if p416 and (p416.Skin and p416.Skin ~= "") then
        v418 = m_Skins.GetCharacterModel(Weapon, p416.Skin, p416.Float, p416.StatTrack, p416.NameTag)
    else
        local v419 = v_u_413(p415 == "CT" and "Counter-Terrorists" or "Terrorists", Weapon)
        if v419 and (v419.Skin and v419.Skin ~= "") then
            v418 = m_Skins.GetCharacterModel(Weapon, v419.Skin, v419.Float, v419.StatTrack, v419.NameTag)
        end
    end
    local v420 = v418 or m_Skins.GetBaseWeaponModel(Weapon, "Character")
    if v420 then
        v420.Name = Weapon
        local RightHand = p414:FindFirstChild("RightHand")
        if RightHand then
            if not v420.PrimaryPart then
                local v422 = v420:FindFirstChild("Weapon")
                if v422 then
                    v422 = v422:FindFirstChild("Insert")
                end
                if not v422 then
                    v420:Destroy()
                    return
                end
                v420.PrimaryPart = v422
            end
            for _, v423 in v420:GetDescendants() do
                if v423:IsA("BasePart") then
                    v423.CanCollide = false
                    v423.CanQuery = false
                    v423.CanTouch = false
                    v423.Anchored = false
                    v423.Massless = true
                end
            end
            v420.Parent = p414
            local v424 = Instance.new("Motor6D")
            v424.Name = "WeaponAttachment"
            v424.Part0 = RightHand
            v424.Part1 = v420.PrimaryPart
            v424.Parent = RightHand
            if Weapon == "AK-47" then
                v424.C0 = v_u_22
            else
                local Properties = v420:FindFirstChild("Properties")
                if Properties then
                    local C0 = Properties:FindFirstChild("C0")
                    local C1 = Properties:FindFirstChild("C1")
                    if C0 then
                        v424.C0 = C0.Value
                    end
                    if C1 then
                        v424.C1 = C1.Value
                    end
                end
            end
        else
            v420:Destroy()
            return
        end
    else
        return
    end
end
local function v_u_470(p429) -- name: populateMVPFrame
    -- upvalues: (copy) PlayerGui, (copy) Players, (copy) m_DataController, (copy) m_Skins
    local MainGui_3 = PlayerGui:FindFirstChild("MainGui")
    if not MainGui_3 then
        return
    end
    local Gameplay_6 = MainGui_3:FindFirstChild("Gameplay")
    if not Gameplay_6 then
        return
    end
    local Middle_2 = Gameplay_6:FindFirstChild("Middle")
    if not Middle_2 then
        return
    end
    local EndScreen_1 = Middle_2:FindFirstChild("EndScreen")
    if not EndScreen_1 then
        return
    end
    local MVP_1 = EndScreen_1:FindFirstChild("MVP")
    if not MVP_1 then
        return
    end
    local v435 = {
        3,
        2,
        4,
        1,
        5
    }
    for v436 = 1, 5 do
        local v437 = MVP_1:FindFirstChild((tostring(v436)))
        if v437 then
            v437.Visible = false
        end
    end
    for v438, v439 in ipairs(p429) do
        local v440 = v435[v438]
        local v441 = MVP_1:FindFirstChild((tostring(v440)))
        if v441 then
            local data = v439.data
            local userId_3 = v439.userId
            local v444 = Players:GetPlayerByUserId((tonumber(userId_3)))
            local v445 = v444 and v444.Name or ("Player_%*"):format(userId_3)
            local Username = v441:FindFirstChild("Username")
            if Username then
                Username.Text = v445
            end
            local KDA = v441:FindFirstChild("KDA")
            if KDA then
                KDA.Text = ("%*-%*-%*"):format(data.Kills or 0, data.Deaths or 0, data.Assists or 0)
            end
            local HSP = v441:FindFirstChild("HSP")
            if HSP then
                local v449 = data.Kills or 0
                local v450 = data.Headshots or 0
                local v451
                if v449 <= 0 then
                    v451 = "0%"
                else
                    local v452 = v450 / v449 * 100
                    v451 = ("%*%%"):format((math.floor(v452)))
                end
                HSP.Text = v451
            end
            local APR = v441:FindFirstChild("APR")
            if APR then
                local v454 = data.ADR or 0
                local v455 = math.floor(v454)
                APR.Text = tostring(v455)
            end
            local Score_1 = v441:FindFirstChild("Score")
            if not Score_1 then
                for _, v457 in v441:GetChildren() do
                    if v457:IsA("TextLabel") and (v457.Name == "NameScore" and v457.Text ~= "SCORE") then
                        Score_1 = v457
                        break
                    end
                end
            end
            if Score_1 then
                local v458 = data.Score or 0
                Score_1.Text = tostring(v458)
            end
            local Category = v441:FindFirstChild("Category")
            if Category then
                Category.Text = data.Accolade or "Participant"
            end
            local Player_0 = v441:FindFirstChild("Player")
            local Avatar = Player_0 and Player_0:FindFirstChild("Avatar")
            if Avatar then
                Avatar.Image = ("rbxthumb://type=AvatarHeadShot&id=%*&w=150&h=150"):format(userId_3)
            end
            local Pin = v441:FindFirstChild("Pin")
            if Pin then
                if v444 and data.Team then
                    local v463, v464 = m_DataController.Get(v444, "Loadout", "Inventory")
                    local imageAssetId = ""
                    if v463 and v464 then
                        local v466 = v463[data.Team]
                        if v466 and v466.Equipped then
                            local v467 = v466.Equipped["Equipped Badge"]
                            if v467 and v467 ~= "" then
                                for _, v468 in ipairs(v464) do
                                    if v468._id == v467 then
                                        local v469 = m_Skins.GetSkinInformation(v468.Name, v468.Skin)
                                        if v469 and v469.imageAssetId then
                                            imageAssetId = v469.imageAssetId
                                        end
                                        break
                                    end
                                end
                            end
                        end
                    end
                    if imageAssetId == "" then
                        Pin.Visible = false
                    else
                        Pin.Image = imageAssetId
                        Pin.Visible = true
                    end
                else
                    Pin.Visible = false
                end
            end
            v441.Visible = true
        end
    end
end
local function v_u_495(p471, p472) -- name: spawnEndScreenCharacters
    -- upvalues: (copy) v_u_470, (copy) v_u_30, (copy) v_u_29, (copy) Characters, (copy) v_u_403, (copy) v_u_428, (copy) v_u_28, (copy) v_u_31
    local v473 = workspace:FindFirstChild("Map")
    if v473 then
        v473 = workspace.Map:FindFirstChild("EndScreen")
    end
    if not v473 then
        return {}
    end
    local v474 = #p471
    local v475 = {}
    for v476 = 1, math.min(5, v474) do
        local v477 = p471[v476]
        table.insert(v475, v477)
    end
    if p472 then
        v_u_470(v475)
    end
    local v478 = {
        3,
        2,
        4,
        1,
        5
    }
    local v479 = {}
    for v480, v481 in ipairs(v475) do
        local v482 = v478[v480]
        local v483 = v473:FindFirstChild((tostring(v482)))
        if v483 then
            local v484 = v_u_30[v481.data.Team]
            if v484 then
                local v485 = v_u_29[v484]
                if v485 then
                    local v486 = Characters:FindFirstChild(v485.Character)
                    if v486 then
                        local v487 = v486:Clone()
                        v487.Name = "EndScreenCharacter_" .. v481.userId
                        v487:PivotTo(v483.CFrame)
                        v487.Parent = v473
                        v_u_403(v487, v484, v481.data.Gloves)
                        v_u_428(v487, v484, v481.data.Weapon)
                        local Humanoid = v487:FindFirstChild("Humanoid")
                        if Humanoid then
                            local Animator = Humanoid:FindFirstChildOfClass("Animator")
                            if not Animator then
                                Animator = Instance.new("Animator")
                                Animator.Parent = Humanoid
                            end
                            local v490 = v_u_28[v482]
                            if v490 then
                                local v491 = Instance.new("Animation")
                                v491.AnimationId = v490.Entrance
                                local v492 = Animator:LoadAnimation(v491)
                                v492.Looped = false
                                v492.Priority = Enum.AnimationPriority.Action
                                v492:Play()
                                local v493 = Instance.new("Animation")
                                v493.AnimationId = v490.Idle
                                local v494 = Animator:LoadAnimation(v493)
                                v494.Looped = true
                                v494.Priority = Enum.AnimationPriority.Idle
                                v494:Play()
                                v_u_31:Add(v491)
                                v_u_31:Add(v492)
                                v_u_31:Add(v493)
                                v_u_31:Add(v494)
                            end
                        end
                        v_u_31:Add(v487, "Destroy")
                        table.insert(v479, v487)
                    end
                end
            end
        end
    end
    return v479
end
local function v_u_500() -- name: animateCamera
    -- upvalues: (copy) CurrentCamera, (copy) m_CameraController, (copy) TweenService
    local v496 = workspace:FindFirstChild("Map")
    if v496 then
        v496 = workspace.Map:FindFirstChild("EndScreen")
    end
    if not v496 then
        return nil
    end
    local Start = v496:FindFirstChild("Start")
    local End = v496:FindFirstChild("End")
    if not (Start and End) then
        warn("[EndScreen] Missing Start or End part!")
        return nil
    end
    CurrentCamera.CameraType = Enum.CameraType.Scriptable
    CurrentCamera.CFrame = Start.CFrame
    CurrentCamera.Focus = Start.CFrame
    CurrentCamera.FieldOfView = m_CameraController.clampFOV(60)
    m_CameraController.setMouseEnabled(true)
    local v499 = TweenService:Create(CurrentCamera, TweenInfo.new(14, Enum.EasingStyle.Linear), {
        ["CFrame"] = End.CFrame
    })
    v499:Play()
    return v499
end
local function v_u_508() -- name: closeAllActiveScenes
    -- upvalues: (copy) m_MenuState, (copy) m_Router, (copy) PlayerGui, (copy) m_CameraController, (copy) ReplicatedStorage
    m_MenuState.SetBlurEnabled(false)
    if m_MenuState.IsCaseSceneActive() then
        m_Router.broadcastRouter("CaseSceneCloseForGameEnd")
    end
    if m_MenuState.IsInspectActive() then
        m_Router.broadcastRouter("WeaponInspectCloseForGameEnd")
    end
    local MainGui_4 = PlayerGui:FindFirstChild("MainGui")
    if MainGui_4 then
        local Menu_1 = MainGui_4:FindFirstChild("Menu")
        if Menu_1 and Menu_1.Visible then
            m_MenuState.HideMenu()
            m_CameraController.setForceLockOverride("Menu", false)
        end
        if Menu_1 then
            Menu_1.BackgroundTransparency = 1
        end
    end
    local MainGui_5 = PlayerGui:FindFirstChild("MainGui")
    local v504
    if MainGui_5 then
        local Gameplay_7 = MainGui_5:FindFirstChild("Gameplay")
        if Gameplay_7 then
            v504 = Gameplay_7:FindFirstChild("Middle")
        else
            v504 = nil
        end
    else
        v504 = nil
    end
    if v504 then
        local BuyMenu = v504:FindFirstChild("BuyMenu")
        if BuyMenu and BuyMenu.Visible then
            require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.BuyMenu).closeFrame()
        end
        local TeamSelection = v504:FindFirstChild("TeamSelection")
        if TeamSelection and TeamSelection.Visible then
            require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.TeamSelection).closeFrame()
        end
    end
end
function v_u_1.IsActive() -- name: IsActive
    -- upvalues: (ref) v_u_32
    return v_u_32
end
function v_u_1._runSequence(p_u_509) -- name: _runSequence
    -- upvalues: (ref) v_u_33, (ref) returnToMenu, (ref) overlayMode, (copy) v_u_66, (copy) v_u_361, (copy) v_u_495, (copy) v_u_500, (copy) v_u_31, (copy) PlayerGui, (copy) v_u_116, (copy) v_u_81, (copy) v_u_84, (copy) v_u_258, (copy) v_u_292, (copy) v_u_1
    v_u_33 = v_u_33 + 1
    local v_u_510 = v_u_33
    returnToMenu = p_u_509.returnToMenu
    overlayMode = p_u_509.overlayMode
    v_u_66()
    v_u_361(p_u_509)
    v_u_495(p_u_509.displayPlayers, p_u_509.showAccolades)
    local v511 = v_u_500()
    if v511 then
        v_u_31:Add(v511, "Cancel")
    end
    if p_u_509.showProgression then
        task.delay(4, function()
            -- upvalues: (copy) v_u_510, (ref) v_u_33, (ref) PlayerGui, (ref) v_u_116, (copy) p_u_509, (ref) v_u_81, (ref) v_u_84, (ref) v_u_258, (ref) v_u_292
            if v_u_510 == v_u_33 then
                local MainGui_6 = PlayerGui:FindFirstChild("MainGui")
                local v513
                if MainGui_6 then
                    local Gameplay_8 = MainGui_6:FindFirstChild("Gameplay")
                    if Gameplay_8 then
                        v513 = Gameplay_8:FindFirstChild("Middle")
                    else
                        v513 = nil
                    end
                else
                    v513 = nil
                end
                local v515
                if v513 then
                    v515 = v513:FindFirstChild("EndScreen")
                else
                    v515 = nil
                end
                if v515 then
                    local Victory = v515:FindFirstChild("Victory")
                    local Defeat = v515:FindFirstChild("Defeat")
                    local Level = v515:FindFirstChild("Level")
                    local v_u_519 = v_u_116(p_u_509.xpEarned)
                    local v520 = p_u_509.isDraw and Victory and Victory or (p_u_509.didWin and Victory and Victory or Defeat)
                    if v520 and v520.Visible then
                        v_u_81(v520, 1)
                    end
                    task.delay(0.5, function()
                        -- upvalues: (ref) v_u_510, (ref) v_u_33, (copy) Victory, (copy) Defeat, (copy) Level, (ref) v_u_84, (copy) v_u_519, (ref) v_u_258, (ref) p_u_509, (ref) v_u_292
                        if v_u_510 == v_u_33 then
                            if Victory then
                                Victory.Visible = false
                            end
                            if Defeat then
                                Defeat.Visible = false
                            end
                            if Level then
                                v_u_84(Level)
                                task.spawn(function()
                                    -- upvalues: (ref) v_u_519, (ref) v_u_258, (ref) p_u_509, (ref) v_u_292
                                    if v_u_519 then
                                        v_u_258(v_u_519)
                                    end
                                    if p_u_509.levelRewards and #p_u_509.levelRewards > 0 then
                                        v_u_292(p_u_509.levelRewards)
                                    end
                                end)
                            end
                        end
                    end)
                end
            else
                return
            end
        end)
    end
    local v521 = p_u_509.sequenceDuration or (p_u_509.showProgression and 14 or 4)
    task.delay(v521, function()
        -- upvalues: (copy) v_u_510, (ref) v_u_33, (ref) v_u_1, (copy) p_u_509
        if v_u_510 == v_u_33 then
            v_u_1._finishSequence(p_u_509.returnToMenu)
        end
    end)
end
function v_u_1._finishSequence(p522) -- name: _finishSequence
    -- upvalues: (ref) returnToMenu, (ref) v_u_33, (ref) overlayMode, (ref) v_u_32, (copy) m_CameraController, (copy) v_u_31, (copy) v_u_382, (copy) PlayerGui, (copy) ReplicatedStorage, (copy) v_u_314, (copy) m_MenuState, (ref) v_u_36, (copy) m_DataController, (copy) LocalPlayer, (ref) v_u_37
    if p522 == nil then
        p522 = returnToMenu
    end
    v_u_33 = v_u_33 + 1
    overlayMode = "EndScreen"
    v_u_32 = false
    m_CameraController.setForceLockOverride("EndScreen", false)
    v_u_31:Cleanup()
    v_u_382()
    m_CameraController.SetEnabled(true)
    local MainGui_7 = PlayerGui:FindFirstChild("MainGui")
    if p522 then
        require(ReplicatedStorage.Controllers.MenuSceneController).ShowMenuScene()
        require(ReplicatedStorage.Interface.Screens.Menu.Top).ResetToMainMenu()
        if MainGui_7 then
            if not MainGui_7.Menu.Visible then
                m_CameraController.setForceLockOverride("Menu", true)
                MainGui_7.Menu.Visible = true
            end
            MainGui_7.Gameplay.Visible = false
        end
    else
        if MainGui_7 then
            v_u_314(MainGui_7, true)
            m_MenuState.HideMenu()
            MainGui_7.Gameplay.Visible = true
        end
        m_CameraController.setPerspective(true, false)
    end
    if p522 then
        v_u_36 = nil
    end
    local v524 = m_DataController.Get(LocalPlayer, "Level")
    if v524 then
        v_u_37 = {
            ["Level"] = v524.Level,
            ["Experience"] = v524.Experience,
            ["NextExperienceRequirement"] = v524.NextExperienceRequirement
        }
    end
end
function v_u_1.Begin(p525) -- name: Begin
    -- upvalues: (ref) v_u_32, (copy) v_u_1, (copy) m_MenuState, (copy) m_Router, (copy) LocalPlayer, (copy) v_u_60, (copy) v_u_49, (copy) v_u_508, (copy) m_SpectateController, (copy) m_CameraController
    local v526 = p525.Halftime == true and "Halftime" or "EndScreen"
    if v_u_32 then
        warn("[EndScreen] Interrupting active sequence for new end screen")
        local v527, v528 = pcall(v_u_1._finishSequence, false)
        if not v527 then
            warn("[EndScreen] _finishSequence error during interrupt: " .. tostring(v528))
        end
        v_u_32 = false
    end
    if m_MenuState.IsCaseSceneActive() and m_Router.broadcastRouter("IsCaseSceneRolling") == true then
        return
    end
    local v529 = workspace:GetAttribute("Gamemode") == "Deathmatch"
    local v530
    if p525.Players then
        local Players_0 = p525.Players
        local UserId = LocalPlayer.UserId
        v530 = Players_0[tostring(UserId)] or nil
    else
        v530 = nil
    end
    if not v530 then
        local v533 = warn
        local UserId_0 = LocalPlayer.UserId
        local v535 = tostring(UserId_0)
        local v536 = LocalPlayer
        local v537 = tostring(v536:GetAttribute("Team"))
        local WinningTeam = p525.WinningTeam
        v533(("[EndScreen] Local player missing from payload (userId=%s, teamAttr=%s, winningTeam=%s)"):format(v535, v537, (tostring(WinningTeam))))
        local v539 = LocalPlayer:GetAttribute("Team")
        if v539 ~= "Counter-Terrorists" and v539 ~= "Terrorists" then
            return
        end
        if v529 then
            return
        end
    end
    local v540 = v530 and v530.Team or LocalPlayer:GetAttribute("Team")
    local v541 = p525.WinningTeam == "Draw"
    local v542 = nil
    local v543 = p525.ShowAccolades ~= false
    local v544 = p525.ShowProgression ~= false
    local SequenceDuration = p525.SequenceDuration
    local v546 = p525.ReturnToMenu ~= false
    local v547, v548
    if v529 then
        if v530 then
            local Team_1 = v530.Team
            if Team_1 == "Counter-Terrorists" and true or Team_1 == "Terrorists" then
                v547 = v_u_60(p525.Players)
                if #v547 == 0 then
                    warn("[EndScreen] Begin skipped for Deathmatch: no eligible ranked players")
                    return
                end
                local v550 = nil
                for v551, v552 in ipairs(v547) do
                    local userId_4 = v552.userId
                    local UserId_1 = LocalPlayer.UserId
                    if userId_4 == tostring(UserId_1) then
                        v550 = v551
                        break
                    end
                end
                if not v550 then
                    local v555 = warn
                    local UserId_2 = LocalPlayer.UserId
                    v555(("[EndScreen] Begin skipped for Deathmatch: local player missing from ranked list (userId=%s)"):format((tostring(UserId_2))))
                    return
                end
                v548 = v550 == 1
                if not v542 then
                    local v557 = "You placed %*"
                    local v558 = v550 % 100
                    local v559
                    if v558 >= 11 and v558 <= 13 then
                        v559 = ("%*th"):format(v550)
                    else
                        local v560 = v550 % 10
                        if v560 == 1 then
                            v559 = ("%*st"):format(v550)
                        elseif v560 == 2 then
                            v559 = ("%*nd"):format(v550)
                        elseif v560 == 3 then
                            v559 = ("%*rd"):format(v550)
                        else
                            v559 = ("%*th"):format(v550)
                        end
                    end
                    v542 = v557:format(v559)
                end
                ::l76::
                local v561, v562 = pcall(v_u_508)
                if not v561 then
                    warn("[EndScreen] closeAllActiveScenes error: " .. tostring(v562))
                end
                local v563, v564 = pcall(m_SpectateController.Stop, false, true)
                if not v563 then
                    warn("[EndScreen] SpectateController.Stop error: " .. tostring(v564))
                end
                m_CameraController.SetEnabled(false)
                v_u_32 = true
                local v565 = v530 and v530.ExperienceEarned or 0
                local v566 = {}
                for v567 in pairs(p525.Players) do
                    local v568 = tonumber(v567)
                    if v568 then
                        table.insert(v566, v568)
                    end
                end
                table.sort(v566)
                local v569 = {}
                for _, v570 in ipairs(v566) do
                    local LevelRewards = p525.Players[tostring(v570)]
                    if LevelRewards then
                        LevelRewards = LevelRewards.LevelRewards
                    end
                    if LevelRewards then
                        for _, v572 in ipairs(LevelRewards) do
                            table.insert(v569, {
                                ["userId"] = v570,
                                ["reward"] = v572
                            })
                        end
                    end
                end
                v_u_1._runSequence({
                    ["displayPlayers"] = v547,
                    ["didWin"] = v548,
                    ["isDraw"] = v541,
                    ["winningTeam"] = p525.WinningTeam,
                    ["xpEarned"] = v565,
                    ["levelRewards"] = v569,
                    ["ctScore"] = p525.CTScore or 0,
                    ["tScore"] = p525.TScore or 0,
                    ["scoreTextOverride"] = v542,
                    ["showAccolades"] = v543,
                    ["showProgression"] = v544,
                    ["sequenceDuration"] = SequenceDuration,
                    ["returnToMenu"] = v546,
                    ["overlayMode"] = v526,
                    ["halftimeTeam"] = v540
                })
                return
            end
        end
        local v573 = warn
        local v574 = "[EndScreen] Begin skipped for Deathmatch: invalid team data (team=%s)"
        if v530 then
            v530 = v530.Team
        end
        v573(v574:format((tostring(v530))))
        return
    else
        if v540 ~= "Counter-Terrorists" and v540 ~= "Terrorists" then
            local v575 = warn
            local v576 = tostring(v540)
            local v577 = LocalPlayer
            local v578 = tostring(v577:GetAttribute("Team"))
            local WinningTeam_0 = p525.WinningTeam
            v575(("[EndScreen] Begin skipped: invalid team (team=%s, teamAttr=%s, winningTeam=%s)"):format(v576, v578, (tostring(WinningTeam_0))))
            return
        end
        v548 = not v541
        if v548 then
            v548 = p525.WinningTeam == v540
        end
        local v580 = {}
        for v581, v582 in pairs(p525.Players) do
            if v582.Team == v540 then
                v580[v581] = v582
            end
        end
        v547 = v_u_49(v580)
        goto l76
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) PlayerGui, (copy) m_ActivateButton, (copy) m_CloseButtonRegistry, (copy) v_u_1, (copy) m_DataController, (copy) LocalPlayer, (ref) v_u_37, (copy) m_Remotes, (ref) v_u_32
    local MainGui_8 = PlayerGui:FindFirstChild("MainGui")
    local v584
    if MainGui_8 then
        local Gameplay_9 = MainGui_8:FindFirstChild("Gameplay")
        if Gameplay_9 then
            v584 = Gameplay_9:FindFirstChild("Middle")
        else
            v584 = nil
        end
    else
        v584 = nil
    end
    local v586
    if v584 then
        v586 = v584:FindFirstChild("EndScreen")
    else
        v586 = nil
    end
    if v586 then
        local Drops_2 = v586:FindFirstChild("Drops")
        if Drops_2 then
            Drops_2.Visible = false
        end
        local Close_0 = v586:FindFirstChild("Close")
        if Close_0 then
            m_ActivateButton(Close_0)
            m_CloseButtonRegistry.Add(v586, Close_0, function()
                -- upvalues: (ref) v_u_1
                v_u_1._finishSequence()
            end)
        end
    end
    m_DataController.CreateListener(LocalPlayer, "Level", function(p589)
        -- upvalues: (ref) v_u_37
        if v_u_37 == nil and p589 then
            v_u_37 = {
                ["NextExperienceRequirement"] = p589.NextExperienceRequirement,
                ["Experience"] = p589.Experience,
                ["Level"] = p589.Level
            }
        end
    end)
    m_Remotes.Match.EndScreen.Listen(function(p590)
        -- upvalues: (ref) v_u_1, (ref) v_u_32
        local v591, v592 = pcall(v_u_1.Begin, p590)
        if not v591 then
            warn("[EndScreen] Begin failed: " .. tostring(v592))
            if v_u_32 then
                pcall(v_u_1._finishSequence)
            end
        end
    end)
end
return v_u_1
