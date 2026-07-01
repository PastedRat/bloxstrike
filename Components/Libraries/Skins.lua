-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local m_GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local v_u_6 = nil
local m_Signal = require(ReplicatedStorage.Packages.Signal)
local Assets = ReplicatedStorage:WaitForChild("Assets")
local Weapons = Assets:WaitForChild("Weapons")
local Skins = Assets:WaitForChild("Skins")
local v_u_11 = m_Signal.new()
v_u_1.OnItemStockSchemasUpdated = v_u_11
local v_u_12 = {}
local v_u_13 = {}
local v_u_14 = {
    {
        ["max"] = 0.07,
        ["wear"] = "Factory New"
    },
    {
        ["max"] = 0.15,
        ["wear"] = "Minimal Wear"
    },
    {
        ["max"] = 0.38,
        ["wear"] = "Field-Tested"
    },
    {
        ["max"] = 0.45,
        ["wear"] = "Well-Worn"
    },
    {
        ["max"] = 1,
        ["wear"] = "Battle-Scarred"
    }
}
local v_u_15 = {
    ["Factory New"] = "Mint Condition",
    ["Minimal Wear"] = "Near-Mint",
    ["Field-Tested"] = "Standard-Grade",
    ["Well-Worn"] = "Combat-Worn",
    ["Battle-Scarred"] = "War-Torn"
}
local function v_u_23(p16) -- name: ResolveCharmFromId
    -- upvalues: (ref) v_u_6, (copy) ReplicatedStorage, (copy) Players
    if not v_u_6 then
        local v17, v18 = pcall(function()
            -- upvalues: (ref) ReplicatedStorage
            return require(ReplicatedStorage.Controllers.DataController)
        end)
        if v17 then
            v_u_6 = v18
        end
    end
    local v19 = v_u_6
    if not v19 then
        return nil
    end
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        return nil
    end
    local v21 = v19.Get(LocalPlayer, "Inventory")
    if not v21 or typeof(v21) ~= "table" then
        return nil
    end
    for _, v22 in ipairs(v21) do
        if v22._id == p16 and v22.Type == "Charm" then
            return {
                ["Skin"] = v22.Skin,
                ["Pattern"] = v22.Pattern
            }
        end
    end
    return nil
end
local function v_u_26(p24) -- name: CreateSyntheticStockSchema
    -- upvalues: (copy) m_GetWeaponProperties
    local v25 = m_GetWeaponProperties(p24)
    return v25 and {
        ["paintId"] = "stock",
        ["type"] = nil,
        ["name"] = nil,
        ["skin"] = "Stock",
        ["rarity"] = "Stock",
        ["floatRange"] = nil,
        ["floatChances"] = nil,
        ["charmImages"] = nil,
        ["wearImages"] = nil,
        ["supportsStatTrak"] = false,
        ["statTrakChance"] = 0,
        ["isEnabled"] = true,
        ["isMarketplaceVisible"] = false,
        ["collection"] = nil,
        ["description"] = "Standard issue finish.",
        ["caseRarity"] = "Stock",
        ["imageAssetId"] = nil,
        ["type"] = v25.Class,
        ["name"] = p24,
        ["floatRange"] = {
            ["min"] = 0,
            ["max"] = 0.07
        },
        ["floatChances"] = {
            {
                ["wear"] = "Factory New",
                ["chance"] = 100
            }
        },
        ["charmImages"] = {},
        ["wearImages"] = {},
        ["imageAssetId"] = v25.Icon or v25.ReverseIcon
    } or nil
end
local function v_u_37(p27, p_u_28) -- name: GetKillTrackValue
    -- upvalues: (copy) m_GetWeaponProperties
    local v29 = p27 or 0
    local v30 = typeof(v29) == "number"
    assert(v30, "KillCount must be a number")
    local v31, v32 = pcall(function(...)
        -- upvalues: (ref) m_GetWeaponProperties, (copy) p_u_28
        return m_GetWeaponProperties(p_u_28)
    end)
    if v31 and v32 then
        if v32.Class == "Melee" then
            local v33 = math.floor(v29)
            local v34 = math.clamp(v33, 0, 9999)
            return tostring(v34)
        else
            local v35 = math.floor(v29)
            local v36 = math.clamp(v35, 0, 999999)
            return string.format("%06d", v36)
        end
    else
        return nil
    end
end
local function v_u_44(p38, p39, p40) -- name: GetSkinTextureFolder
    -- upvalues: (copy) Skins
    local v41 = Skins:FindFirstChild(p38)
    if v41 then
        if p40 and p38 == "Smoke Grenade" then
            local v42 = v41:FindFirstChild(p40)
            if v42 and v42:IsA("Folder") then
                return v42
            end
        end
        local v43 = v41:FindFirstChild(p39)
        if v43 and v43:IsA("Folder") then
            return v43
        else
            return nil
        end
    else
        return nil
    end
end
local function v_u_54(p45, p46) -- name: GetWearFromFloat
    -- upvalues: (copy) v_u_14, (copy) v_u_15
    local min = p45.floatRange.min
    local v48 = p45.floatRange.max - 1e-12
    local v49 = math.max(min, v48)
    local min_0 = p45.floatRange.min
    local v51 = math.clamp(p46, min_0, v49)
    local v52 = math.clamp(v51, 0, 1)
    for _, v53 in ipairs(v_u_14) do
        if v52 < v53.max then
            return v53.wear, v_u_15[v53.wear]
        end
    end
    return "Battle-Scarred", "War-Torn"
end
local function v_u_61(p55, p56, p57) -- name: GetWearTextureFolder
    -- upvalues: (copy) v_u_54, (copy) v_u_14
    if not (p55 and p55:IsA("Folder")) then
        return nil
    end
    local v58 = v_u_54(p56, p57)
    if v58 then
        v58 = p55:FindFirstChild(v58)
    end
    if v58 and v58:IsA("Folder") then
        return v58
    end
    for _, v59 in ipairs(v_u_14) do
        local v60 = p55:FindFirstChild(v59.wear)
        if v60 and v60:IsA("Folder") then
            return v60
        end
    end
    return nil
end
local function v_u_66(p62, p63) -- name: FindMatchingMeshParts
    local v64 = {}
    for _, v65 in ipairs(p62:GetDescendants()) do
        if v65:IsA("MeshPart") and v65.Name == p63 then
            table.insert(v64, v65)
        end
    end
    return v64
end
local function v_u_77(p67, p68) -- name: ApplySkinTextures
    -- upvalues: (copy) v_u_66
    local v69 = 0
    local v70 = 0
    local v71 = {}
    for _, v72 in ipairs(p68:GetChildren()) do
        if v72:IsA("SurfaceAppearance") then
            v69 = v69 + 1
            local v73 = v_u_66(p67, v72.Name)
            if #v73 > 0 then
                for _, v74 in ipairs(v73) do
                    local SurfaceAppearance = v74:FindFirstChildOfClass("SurfaceAppearance")
                    if SurfaceAppearance then
                        SurfaceAppearance:Destroy()
                    end
                    v72:Clone().Parent = v74
                end
                v70 = v70 + 1
            else
                local Name = v72.Name
                table.insert(v71, Name)
            end
        end
    end
    return v69, v70, v71
end
local function v_u_90(p78, p79, p80, p_u_81) -- name: AttachStatTrakToWeapon
    -- upvalues: (copy) m_GetWeaponProperties, (copy) Assets, (copy) v_u_37
    local v82, v83 = pcall(function(...)
        -- upvalues: (ref) m_GetWeaponProperties, (copy) p_u_81
        return m_GetWeaponProperties(p_u_81)
    end)
    local v84 = v82 and (v83 and v83.Class == "Melee") and "KillTrackKnife" or "KillTrak"
    local v85 = Assets.Other[v84]:Clone()
    local PrimaryPart = p79.PrimaryPart
    if PrimaryPart then
        local KillTrack = p79:FindFirstChild("KillTrack", true)
        if KillTrack then
            local PrimaryPart_0 = v85.PrimaryPart
            local v89 = Instance.new("WeldConstraint")
            v89.Part0 = PrimaryPart_0
            v89.Part1 = PrimaryPart
            v89.Parent = PrimaryPart_0
            v85:PivotTo(KillTrack.WorldCFrame)
            v85.Screen.SurfaceGui.TextLabel.Text = v_u_37(p80, p_u_81)
            v85.Parent = p78
        else
            v85:Destroy()
        end
    else
        v85:Destroy()
        return
    end
end
local function v_u_97(p91, p92, p93) -- name: AttachStatTrak
    -- upvalues: (copy) v_u_90
    local Weapon = p91:FindFirstChild("Weapon")
    if Weapon then
        v_u_90(p91, Weapon, p92, p93)
    else
        local WeaponL = p91:FindFirstChild("WeaponL")
        local WeaponR = p91:FindFirstChild("WeaponR")
        if WeaponL then
            v_u_90(p91, WeaponL, p92, p93)
        end
        if WeaponR then
            v_u_90(p91, WeaponR, p92, p93)
        end
    end
end
local function v_u_106(p98, p99, p100) -- name: AttachNameTagToWeapon
    -- upvalues: (copy) Assets
    local v101 = Assets.Other.NamePlate:Clone()
    local PrimaryPart_1 = p99.PrimaryPart
    if PrimaryPart_1 then
        local Nametag = PrimaryPart_1:FindFirstChild("Nametag")
        if Nametag then
            local PrimaryPart_2 = v101.PrimaryPart
            local v105 = Instance.new("WeldConstraint")
            v105.Part0 = PrimaryPart_2
            v105.Part1 = PrimaryPart_1
            v105.Parent = PrimaryPart_2
            v101:PivotTo(Nametag.WorldCFrame)
            v101.Screen.SurfaceGui.TextLabel.Text = tostring(p100)
            v101.Parent = p98
        else
            v101:Destroy()
        end
    else
        v101:Destroy()
        return
    end
end
local function v_u_112(p107, p108) -- name: AttachNameTag
    -- upvalues: (copy) v_u_106
    local Weapon_0 = p107:FindFirstChild("Weapon")
    if Weapon_0 then
        v_u_106(p107, Weapon_0, p108)
    else
        local WeaponL_0 = p107:FindFirstChild("WeaponL")
        local WeaponR_0 = p107:FindFirstChild("WeaponR")
        if WeaponL_0 then
            v_u_106(p107, WeaponL_0, p108)
        end
        if WeaponR_0 then
            v_u_106(p107, WeaponR_0, p108)
        end
    end
end
local function v_u_126(p113, p114, p115, p_u_116) -- name: AttachStatTrakCameraToWeapon
    -- upvalues: (copy) m_GetWeaponProperties, (copy) Assets, (copy) v_u_37
    local v117, v118 = pcall(function(...)
        -- upvalues: (ref) m_GetWeaponProperties, (copy) p_u_116
        return m_GetWeaponProperties(p_u_116)
    end)
    local v119 = v117 and (v118 and v118.Class == "Melee") and "KillTrackKnife" or "KillTrak"
    local v120 = Assets.Other[v119]:Clone()
    local PrimaryPart_3 = p114.PrimaryPart
    if PrimaryPart_3 then
        local KillTrack_0 = p114:FindFirstChild("KillTrack", true)
        if KillTrack_0 then
            local PrimaryPart_4 = v120.PrimaryPart
            local v124 = Instance.new("WeldConstraint")
            v124.Part0 = PrimaryPart_4
            v124.Part1 = PrimaryPart_3
            v124.Parent = PrimaryPart_4
            v120:PivotTo(KillTrack_0.WorldCFrame)
            local SurfaceGui = v120.Screen.SurfaceGui
            SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
            SurfaceGui.CanvasSize = Vector2.new(100, 25)
            SurfaceGui.TextLabel.Text = v_u_37(p115, p_u_116)
            SurfaceGui.TextLabel.TextSize = 29
            SurfaceGui.TextLabel.Size = UDim2.fromScale(1, 1)
            v120.Parent = p113
        else
            v120:Destroy()
        end
    else
        v120:Destroy()
        return
    end
end
local function v_u_133(p127, p128, p129) -- name: AttachStatTrakCamera
    -- upvalues: (copy) v_u_126
    local Weapon_1 = p127:FindFirstChild("Weapon")
    if Weapon_1 then
        v_u_126(p127, Weapon_1, p128, p129)
    else
        local WeaponL_1 = p127:FindFirstChild("WeaponL")
        local WeaponR_1 = p127:FindFirstChild("WeaponR")
        if WeaponL_1 then
            v_u_126(p127, WeaponL_1, p128, p129)
        end
        if WeaponR_1 then
            v_u_126(p127, WeaponR_1, p128, p129)
        end
    end
end
local function v_u_143(p134, p135, p136) -- name: AttachNameTagCameraToWeapon
    -- upvalues: (copy) Assets
    local v137 = Assets.Other.NamePlate:Clone()
    local PrimaryPart_5 = p135.PrimaryPart
    if PrimaryPart_5 then
        local Nametag_0 = PrimaryPart_5:FindFirstChild("Nametag")
        if Nametag_0 then
            local PrimaryPart_6 = v137.PrimaryPart
            local v141 = Instance.new("WeldConstraint")
            v141.Part0 = PrimaryPart_6
            v141.Part1 = PrimaryPart_5
            v141.Parent = PrimaryPart_6
            v137:PivotTo(Nametag_0.WorldCFrame)
            local SurfaceGui_0 = v137.Screen.SurfaceGui
            SurfaceGui_0.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
            SurfaceGui_0.CanvasSize = Vector2.new(100, 8)
            SurfaceGui_0.TextLabel.Text = tostring(p136)
            SurfaceGui_0.TextLabel.TextSize = 8.98
            SurfaceGui_0.TextLabel.Size = UDim2.fromScale(0.95, 1)
            SurfaceGui_0.TextLabel.Position = UDim2.fromOffset(5, 0)
            v137.Parent = p134
        else
            v137:Destroy()
        end
    else
        v137:Destroy()
        return
    end
end
local function v_u_149(p144, p145) -- name: AttachNameTagCamera
    -- upvalues: (copy) v_u_143
    local Weapon_2 = p144:FindFirstChild("Weapon")
    if Weapon_2 then
        v_u_143(p144, Weapon_2, p145)
    else
        local WeaponL_2 = p144:FindFirstChild("WeaponL")
        local WeaponR_2 = p144:FindFirstChild("WeaponR")
        if WeaponL_2 then
            v_u_143(p144, WeaponL_2, p145)
        end
        if WeaponR_2 then
            v_u_143(p144, WeaponR_2, p145)
        end
    end
end
local function v_u_166(p150, p151, p152, p153) -- name: AttachCharmToWeapon
    -- upvalues: (copy) Assets
    local Charms = Assets:FindFirstChild("Charms")
    local v155
    if Charms then
        v155 = Charms:FindFirstChild("CharmBase")
    else
        v155 = Charms
    end
    if v155 and v155:IsA("Model") then
        local v156 = Charms:FindFirstChild(p151)
        if v156 then
            v156 = v156:FindFirstChild((tostring(p152)))
        end
        if v156 and v156:IsA("Model") then
            local Charm = p150:FindFirstChild("Charm" .. p153, true)
            if Charm then
                local Parent = Charm.Parent
                if Parent and Parent:IsA("BasePart") then
                    local v159 = v155:Clone()
                    v159.Parent = p150
                    v159:PivotTo(Charm.WorldCFrame * CFrame.Angles(0, 0, 0))
                    if v159.PrimaryPart then
                        local PrimaryPart_7 = v159.PrimaryPart
                        local v161 = Instance.new("WeldConstraint")
                        v161.Part0 = PrimaryPart_7
                        v161.Part1 = Parent
                        v161.Parent = PrimaryPart_7
                    end
                    local v162 = v156:Clone()
                    v162.Parent = v159
                    local Part = v159:FindFirstChild("Part")
                    if Part and Part:IsA("BasePart") then
                        v162:PivotTo(Part.CFrame)
                        Part:Destroy()
                    end
                    local HingeConstraint = v159:FindFirstChild("HingeConstraint", true)
                    local v165 = HingeConstraint and (v162.PrimaryPart and v162.PrimaryPart:FindFirstChild("Attachment"))
                    if v165 then
                        HingeConstraint.Attachment1 = v165
                    end
                end
            else
                print("Charm attachment not found for weapon:", p150.Name, p153)
                return
            end
        else
            warn("Specific charm not found for weapon:", p150.Name, p151, p152)
            return
        end
    else
        warn("Charm base not found for weapon:", p150.Name)
        return
    end
end
local function v_u_175(p167, p168) -- name: AttachCharm
    -- upvalues: (copy) v_u_23, (copy) v_u_166
    if typeof(p168) == "table" then
        if p168._id and p168.Position then
            local Position = p168.Position
            local v170, v171
            if p168.Skin and p168.Pattern then
                v170 = p168.Skin
                v171 = p168.Pattern
            else
                local v172 = v_u_23(p168._id)
                if not v172 then
                    return
                end
                v170 = v172.Skin
                v171 = v172.Pattern
            end
            if v170 and v171 then
                if p167:FindFirstChild("Weapon") then
                    v_u_166(p167, v170, v171, Position)
                else
                    local WeaponL_3 = p167:FindFirstChild("WeaponL")
                    local WeaponR_3 = p167:FindFirstChild("WeaponR")
                    if WeaponL_3 then
                        v_u_166(p167, v170, v171, Position)
                    end
                    if WeaponR_3 then
                        v_u_166(p167, v170, v171, Position)
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
local function v_u_192(p176, p177, p178, p179) -- name: AttachCharmCameraToWeapon
    -- upvalues: (copy) Assets
    local Charms_0 = Assets:FindFirstChild("Charms")
    local v181
    if Charms_0 then
        v181 = Charms_0:FindFirstChild("CharmBase")
    else
        v181 = Charms_0
    end
    if v181 and v181:IsA("Model") then
        local v182 = Charms_0:FindFirstChild(p177)
        if v182 then
            v182 = v182:FindFirstChild((tostring(p178)))
        end
        if v182 and v182:IsA("Model") then
            local Charm_0 = p176:FindFirstChild("Charm" .. p179, true)
            if Charm_0 then
                local Parent_0 = Charm_0.Parent
                if Parent_0 and Parent_0:IsA("BasePart") then
                    local v185 = v181:Clone()
                    v185.Parent = p176
                    v185:PivotTo(Charm_0.WorldCFrame * CFrame.Angles(0, 0, 0))
                    if v185.PrimaryPart then
                        local PrimaryPart_8 = v185.PrimaryPart
                        local v187 = Instance.new("WeldConstraint")
                        v187.Part0 = PrimaryPart_8
                        v187.Part1 = Parent_0
                        v187.Parent = PrimaryPart_8
                    end
                    local v188 = v182:Clone()
                    v188.Parent = v185
                    local Part_0 = v185:FindFirstChild("Part")
                    if Part_0 and Part_0:IsA("BasePart") then
                        v188:PivotTo(Part_0.CFrame)
                        Part_0:Destroy()
                    end
                    local HingeConstraint_0 = v185:FindFirstChild("HingeConstraint", true)
                    local v191 = HingeConstraint_0 and (v188.PrimaryPart and v188.PrimaryPart:FindFirstChild("Attachment"))
                    if v191 then
                        HingeConstraint_0.Attachment1 = v191
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
local function v_u_201(p193, p194) -- name: AttachCharmCamera
    -- upvalues: (copy) v_u_23, (copy) v_u_192
    if typeof(p194) == "table" then
        if p194._id and p194.Position then
            local Position_0 = p194.Position
            local v196, v197
            if p194.Skin and p194.Pattern then
                v196 = p194.Skin
                v197 = p194.Pattern
            else
                local v198 = v_u_23(p194._id)
                if not v198 then
                    return
                end
                v196 = v198.Skin
                v197 = v198.Pattern
            end
            if v196 and v197 then
                if p193:FindFirstChild("Weapon") then
                    v_u_192(p193, v196, v197, Position_0)
                else
                    local WeaponL_4 = p193:FindFirstChild("WeaponL")
                    local WeaponR_4 = p193:FindFirstChild("WeaponR")
                    if WeaponL_4 then
                        v_u_192(p193, v196, v197, Position_0)
                    end
                    if WeaponR_4 then
                        v_u_192(p193, v196, v197, Position_0)
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
function v_u_1.GetCharmModel(p202, p203) -- name: GetCharmModel
    -- upvalues: (copy) Assets
    local Charms_1 = Assets:FindFirstChild("Charms")
    local v205
    if Charms_1 then
        v205 = Charms_1:FindFirstChild("CharmBase")
    else
        v205 = Charms_1
    end
    if not (v205 and v205:IsA("Model")) then
        warn((("Skins.GetCharmModel: Charm base not found for charm \"%*\" with pattern \"%*\""):format(p202, p203)))
        return nil
    end
    local v206 = Charms_1:FindFirstChild(p202)
    if v206 then
        v206 = v206:FindFirstChild((tostring(p203)))
    end
    if not (v206 and v206:IsA("Model")) then
        warn((("Skins.GetCharmModel: Specific charm not found for charm \"%*\" with pattern \"%*\""):format(p202, p203)))
        return nil
    end
    local v207 = v205:Clone()
    v207.Name = p202
    local v208 = v206:Clone()
    v208.Parent = v207
    local Part_1 = v207:FindFirstChild("Part")
    if Part_1 and Part_1:IsA("BasePart") then
        v208:PivotTo(Part_1.CFrame)
        Part_1:Destroy()
    end
    local HingeConstraint_1 = v207:FindFirstChild("HingeConstraint", true)
    local v211 = HingeConstraint_1 and (v208.PrimaryPart and v208.PrimaryPart:FindFirstChild("Attachment"))
    if v211 then
        HingeConstraint_1.Attachment1 = v211
    end
    return v207
end
function v_u_1.GetBadgeModel(p212) -- name: GetBadgeModel
    -- upvalues: (copy) Assets
    local Badges = Assets:FindFirstChild("Badges")
    if not Badges then
        warn((("Skins.GetBadgeModel: Badges folder not found for badge \"%*\""):format(p212)))
        return nil
    end
    local v214 = Badges:FindFirstChild(p212)
    if v214 and v214:IsA("Model") then
        return v214:Clone()
    end
    warn((("Skins.GetBadgeModel: Badge model not found for \"%*\""):format(p212)))
    return nil
end
function v_u_1.GetWearNameForFloat(p215, p216) -- name: GetWearNameForFloat
    -- upvalues: (copy) v_u_54
    local v217, v218 = v_u_54(p215, p216)
    return v217, v218
end
function v_u_1.GetKillTrackValue(p219, p220) -- name: GetKillTrackValue
    -- upvalues: (copy) v_u_37
    return v_u_37(p219, p220)
end
function v_u_1.GetMagazine(p221, p222, p223) -- name: GetMagazine
    -- upvalues: (copy) v_u_1, (ref) v_u_12, (copy) v_u_11, (copy) Weapons, (copy) Skins, (copy) v_u_61, (copy) v_u_77
    local v224
    if typeof(p221) == "string" and (typeof(p222) == "string" and p221 ~= "") then
        v224 = p222 ~= ""
    else
        v224 = false
    end
    if not v224 then
        return nil
    end
    local v225 = v_u_1.GetSkinInformation(p221, p222)
    if not v225 and next(v_u_12) == nil then
        v_u_11:Wait()
        v225 = v_u_1.GetSkinInformation(p221, p222)
    end
    if not v225 then
        return nil
    end
    local Character = Weapons:FindFirstChild(p221)
    if not (Character and Character:IsA("Folder")) then
        Character = nil
    end
    if Character then
        Character = Character:FindFirstChild("Character")
    end
    if not (Character and Character:IsA("Model")) then
        return nil
    end
    local v227 = {}
    for _, v228 in ipairs(Character:GetDescendants()) do
        if v228:IsA("BasePart") and v228:HasTag("CharacterMagazine") then
            table.insert(v227, v228)
        end
    end
    if #v227 == 0 then
        return nil
    end
    local v229 = Instance.new("Model")
    v229.Name = "Magazine"
    for _, v230 in ipairs(v227) do
        local v231 = v230:Clone()
        v231.Parent = v229
        if not v229.PrimaryPart then
            v229.PrimaryPart = v231
        end
    end
    local v232 = Skins:FindFirstChild(p221)
    local v233
    if v232 then
        v233 = v232:FindFirstChild(p222)
        if not (v233 and v233:IsA("Folder")) then
            v233 = nil
        end
    else
        v233 = nil
    end
    if v233 then
        v233 = v233:FindFirstChild("Character")
    end
    local v234 = v_u_61(v233, v225, p223 or v225.floatRange.min)
    if v234 then
        v_u_77(v229, v234)
    end
    return v229
end
function v_u_1.GetGloves(p235, p236, p237) -- name: GetGloves
    -- upvalues: (copy) v_u_1, (ref) v_u_12, (copy) v_u_11, (copy) Weapons, (copy) Skins, (copy) v_u_61, (copy) v_u_77
    local v238
    if typeof(p235) == "string" and (typeof(p236) == "string" and p235 ~= "") then
        v238 = p236 ~= ""
    else
        v238 = false
    end
    if not v238 then
        return nil
    end
    local v239 = v_u_1.GetSkinInformation(p235, p236)
    if not v239 and next(v_u_12) == nil then
        v_u_11:Wait()
        v239 = v_u_1.GetSkinInformation(p235, p236)
    end
    if not v239 then
        return nil
    end
    local v240 = Weapons:FindFirstChild(p235)
    if not (v240 and v240:IsA("Folder")) then
        v240 = nil
    end
    if not v240 then
        return nil
    end
    local v241 = Instance.new("Model")
    v241.Name = p235
    for _, v242 in ipairs(v240:GetChildren()) do
        if v242:IsA("BasePart") then
            v242:Clone().Parent = v241
        end
    end
    local v243 = Skins:FindFirstChild(p235)
    local v244
    if v243 then
        v244 = v243:FindFirstChild(p236)
        if not (v244 and v244:IsA("Folder")) then
            v244 = nil
        end
    else
        v244 = nil
    end
    if v244 then
        v244 = v244:FindFirstChild("Camera")
    end
    local v245 = v_u_61(v244, v239, p237 or v239.floatRange.min)
    if v245 then
        v_u_77(v241, v245)
    end
    return v241
end
function v_u_1.GetCharacterModel(p246, p247, p248, p249, p250, p251, _, p252) -- name: GetCharacterModel
    -- upvalues: (copy) v_u_1, (ref) v_u_12, (copy) v_u_11, (copy) Weapons, (copy) v_u_44, (copy) v_u_61, (copy) v_u_77, (copy) v_u_97, (copy) v_u_112, (copy) v_u_175
    local v253
    if typeof(p246) == "string" and (typeof(p247) == "string" and p246 ~= "") then
        v253 = p247 ~= ""
    else
        v253 = false
    end
    if not v253 then
        return nil
    end
    local v254 = v_u_1.GetSkinInformation(p246, p247)
    if not v254 and next(v_u_12) == nil then
        v_u_11:Wait()
        v254 = v_u_1.GetSkinInformation(p246, p247)
    end
    if not v254 then
        warn((("SkinHandler.GetCharacterModel: Skin \"%*\" not found for weapon \"%*\""):format(p247, p246)))
        return nil
    end
    local Character_0 = Weapons:FindFirstChild(p246)
    if not (Character_0 and Character_0:IsA("Folder")) then
        Character_0 = nil
    end
    if Character_0 then
        Character_0 = Character_0:FindFirstChild("Character")
    end
    if not (Character_0 and Character_0:IsA("Model")) then
        warn((("SkinHandler.GetCharacterModel: Base character model not found for weapon \"%*\""):format(p246)))
        return nil
    end
    local v256 = Character_0:Clone()
    local Character_1 = v_u_44(p246, p247, p252)
    if Character_1 then
        Character_1 = Character_1:FindFirstChild("Character")
    end
    local v258 = v_u_61(Character_1, v254, p248 or v254.floatRange.max)
    if v258 then
        v_u_77(v256, v258)
    end
    if p249 then
        v_u_97(v256, p249, p246)
    end
    if p250 then
        v_u_112(v256, p250)
    end
    if p251 then
        v_u_175(v256, p251)
    end
    return v256
end
function v_u_1.GetWorldModel(p259, p260, p261, p262, p263, p264, _) -- name: GetWorldModel
    -- upvalues: (copy) v_u_1, (ref) v_u_12, (copy) v_u_11, (copy) Weapons, (copy) Skins, (copy) v_u_61, (copy) v_u_77, (copy) v_u_97, (copy) v_u_112, (copy) v_u_175
    local v265
    if typeof(p259) == "string" and (typeof(p260) == "string" and p259 ~= "") then
        v265 = p260 ~= ""
    else
        v265 = false
    end
    if not v265 then
        return nil
    end
    local v266 = v_u_1.GetSkinInformation(p259, p260)
    if not v266 and next(v_u_12) == nil then
        v_u_11:Wait()
        v266 = v_u_1.GetSkinInformation(p259, p260)
    end
    if not v266 then
        return nil
    end
    local v267 = Weapons:FindFirstChild(p259)
    if not (v267 and v267:IsA("Folder")) then
        v267 = nil
    end
    if v267 then
        v267 = v267:FindFirstChild("Other")
    end
    if v267 then
        v267 = v267:FindFirstChild("World")
    end
    if not (v267 and v267:IsA("Model")) then
        return nil
    end
    local v268 = v267:Clone()
    local v269 = Skins:FindFirstChild(p259)
    local v270
    if v269 then
        v270 = v269:FindFirstChild(p260)
        if not (v270 and v270:IsA("Folder")) then
            v270 = nil
        end
    else
        v270 = nil
    end
    if v270 then
        v270 = v270:FindFirstChild("Character")
    end
    local v271 = v_u_61(v270, v266, p261 or v266.floatRange.max)
    if v271 then
        v_u_77(v268, v271)
    end
    if p262 then
        v_u_97(v268, p262, p259)
    end
    if p263 then
        v_u_112(v268, p263)
    end
    if p264 then
        v_u_175(v268, p264)
    end
    return v268
end
function v_u_1.GetCameraModel(p272, p273, p274, p275, p276, p277, _, p278) -- name: GetCameraModel
    -- upvalues: (copy) v_u_1, (ref) v_u_12, (copy) v_u_11, (copy) Weapons, (copy) v_u_44, (copy) v_u_61, (copy) v_u_77, (copy) v_u_133, (copy) v_u_149, (copy) v_u_201
    local v279
    if typeof(p272) == "string" and (typeof(p273) == "string" and p272 ~= "") then
        v279 = p273 ~= ""
    else
        v279 = false
    end
    if not v279 then
        return nil
    end
    local v280 = v_u_1.GetSkinInformation(p272, p273)
    if not v280 and next(v_u_12) == nil then
        v_u_11:Wait()
        v280 = v_u_1.GetSkinInformation(p272, p273)
    end
    if not v280 then
        return nil
    end
    local Camera = Weapons:FindFirstChild(p272)
    if not (Camera and Camera:IsA("Folder")) then
        Camera = nil
    end
    if Camera then
        Camera = Camera:FindFirstChild("Camera")
    end
    if not (Camera and Camera:IsA("Model")) then
        return nil
    end
    local Camera_0 = v_u_44(p272, p273, p278)
    if Camera_0 then
        Camera_0 = Camera_0:FindFirstChild("Camera")
    end
    local v283 = v_u_61(Camera_0, v280, p274 or v280.floatRange.max)
    local v284 = Camera:Clone()
    if v283 then
        v_u_77(v284, v283)
    end
    if p275 then
        v_u_133(v284, p275, p272)
    end
    if p276 then
        v_u_149(v284, p276)
    end
    if p277 then
        v_u_201(v284, p277)
    end
    return v284
end
function v_u_1.GetSkinInformation(p285, p286) -- name: GetSkinInformation
    -- upvalues: (ref) v_u_12, (copy) v_u_13, (copy) v_u_26
    local v287
    if typeof(p285) == "string" and (typeof(p286) == "string" and p285 ~= "") then
        v287 = p286 ~= ""
    else
        v287 = false
    end
    if not v287 then
        return nil
    end
    local v288 = v_u_12[p285]
    if v288 and v288[p286] then
        return v288[p286]
    end
    if p286 ~= "Stock" then
        return nil
    end
    local v289 = v_u_13[p285]
    if v289 and v289.Stock then
        return v289.Stock
    end
    local v290 = v_u_26(p285)
    if not v290 then
        return nil
    end
    local v291 = v289 or {}
    v291.Stock = v290
    v_u_13[p285] = v291
    return v290
end
function v_u_1.GetAllSkinsForWeapon(p292) -- name: GetAllSkinsForWeapon
    -- upvalues: (ref) v_u_12
    if typeof(p292) ~= "string" or p292 == "" then
        return nil
    end
    local v293 = v_u_12[p292]
    if not v293 then
        return nil
    end
    local v294 = {}
    for _, v295 in pairs(v293) do
        table.insert(v294, v295)
    end
    return v294
end
function v_u_1.GetWearImageForFloat(p296, p297) -- name: GetWearImageForFloat
    -- upvalues: (copy) v_u_54
    local v298 = v_u_54(p296, p297)
    if not v298 then
        return nil
    end
    for _, v299 in ipairs(p296.wearImages) do
        if v299.wear == v298 then
            return v299.assetId
        end
    end
    return nil
end
function v_u_1.GetBaseWeaponModel(p300, p301) -- name: GetBaseWeaponModel
    -- upvalues: (copy) Weapons
    if typeof(p300) == "string" and p300 ~= "" then
        local v302 = Weapons:FindFirstChild(p300)
        if not (v302 and v302:IsA("Folder")) then
            v302 = nil
        end
        if v302 then
            local v303 = v302:FindFirstChild(p301)
            if v303 and v303:IsA("Model") then
                return v303:Clone()
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end
if ReplicatedStorage:GetAttribute("AvaiableSkins") then
    v_u_12 = HttpService:JSONDecode((ReplicatedStorage:GetAttribute("AvaiableSkins")))
    if #v_u_11:GetConnections() > 0 then
        v_u_11:Fire(v_u_12)
    end
end
ReplicatedStorage:GetAttributeChangedSignal("AvaiableSkins"):Connect(function()
    -- upvalues: (copy) ReplicatedStorage, (ref) v_u_12, (copy) HttpService, (copy) v_u_11
    local v304 = ReplicatedStorage:GetAttribute("AvaiableSkins")
    if v304 then
        v_u_12 = HttpService:JSONDecode(v304)
        if #v_u_11:GetConnections() > 0 then
            v_u_11:Fire(v_u_12)
        end
    else
        return
    end
end)
return v_u_1
