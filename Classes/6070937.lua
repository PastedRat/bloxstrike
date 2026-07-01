-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local m_DataController = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("DataController"))
require(script:WaitForChild("Types"))
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local v_u_7 = ReplicatedStorage:FindFirstChild("Sounds") or Instance.new("Folder", ReplicatedStorage)
v_u_7.Name = "Sounds"
local Debris = workspace:WaitForChild("Debris")
local v_u_9 = {}
local v_u_10 = 1
local v_u_11 = nil
local function v_u_14(p12) -- name: SelectSound
    local v13 = p12:GetChildren()
    return v13[math.random(1, #v13)]:Clone()
end
local function v_u_22(p15) -- name: TranslateSoundPath
    local v16 = string.split(p15, ".")
    local v17 = game
    for v18, v_u_19 in ipairs(v16) do
        if v17 and v18 > 1 then
            if v17 == game then
                local v20, v21 = pcall(function()
                    -- upvalues: (copy) v_u_19
                    return game:GetService(v_u_19)
                end)
                v17 = v20 and v21 and v21 or v17:FindFirstChild(v_u_19)
            else
                v17 = v17:FindFirstChild(v_u_19)
            end
            if not v17 then
                error((("Path: \"%*\" does not exist"):format(p15)))
            end
        end
    end
    return v17
end
local function v_u_29(p23, p24, p25) -- name: CreateSoundInstance
    local v26 = Instance.new("Sound")
    v26.RollOffMaxDistance = p25.RollOffMaxDistance or 10000
    v26.RollOffMinDistance = p25.RollOffMinDistance or 10
    v26.TimePosition = p25.TimePosition or 0
    v26.RollOffMode = Enum.RollOffMode.Inverse
    v26.Looped = p25.Looped or false
    v26.SoundId = ("rbxassetid://%*"):format(p24)
    v26.Volume = p25.Volume or 0.5
    v26.Name = p23
    local Pitch = p25.Pitch
    if typeof(Pitch) == "number" and Pitch ~= 1 then
        local v28 = Instance.new("PitchShiftSoundEffect")
        v28.Name = "PitchShift"
        v28.Octave = math.clamp(Pitch, 0.5, 2)
        v28.Parent = v26
    end
    return v26
end
local function v_u_39(p_u_30, p31, p32) -- name: TrackMasterVolume
    -- upvalues: (ref) v_u_11, (ref) v_u_10, (copy) m_DataController, (copy) LocalPlayer, (copy) v_u_9
    local v33 = p32 or 1
    local v34 = {
        ["BaseVolume"] = p31,
        ["OtherMultiplier"] = v33
    }
    if not v_u_11 then
        local v35 = m_DataController.Get(LocalPlayer, "Settings.Audio.Audio.Master Volume") or 100
        v_u_10 = (tonumber(v35) or 100) / 100
        v_u_11 = m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Audio.Master Volume", function(p36)
            -- upvalues: (ref) v_u_10, (ref) v_u_9
            v_u_10 = (tonumber(p36) or 100) / 100
            for v37, v38 in pairs(v_u_9) do
                if v37.Parent then
                    v37.Volume = v38.BaseVolume * v_u_10 * v38.OtherMultiplier
                    v37:SetAttribute("MasterVolumeMultiplier", v_u_10)
                else
                    v_u_9[v37] = nil
                end
            end
        end)
    end
    v_u_9[p_u_30] = v34
    p_u_30:SetAttribute("BaseVolume", p31)
    p_u_30:SetAttribute("OtherVolumeMultiplier", v33)
    p_u_30.Volume = v34.BaseVolume * v_u_10 * v34.OtherMultiplier
    p_u_30:SetAttribute("MasterVolumeMultiplier", v_u_10)
    p_u_30.Destroying:Once(function()
        -- upvalues: (ref) v_u_9, (copy) p_u_30
        v_u_9[p_u_30] = nil
    end)
end
function v_u_1.play(p40, p41, p42) -- name: play
    -- upvalues: (copy) HttpService, (copy) v_u_22, (copy) v_u_39
    local Path = p41.Parent or p41.Path
    local v44 = ("Sound couldn\'t locate sound parent for %*"):format(p41.Name)
    assert(Path, v44)
    if not p40.Sounds then
        return nil
    end
    local v45 = p40.Sounds:FindFirstChild(p41.Name)
    if v45 then
        local v46 = HttpService:GenerateGUID(false)
        local Parent = p41.Parent
        if p41.Path and not Parent then
            Parent = v_u_22(p41.Path)
        end
        if not Parent then
            return nil
        end
        local v48 = v45:GetChildren()
        local v_u_49 = v48[math.random(1, #v48)]:Clone()
        v_u_49.Parent = Parent
        v_u_49.Name = v46
        v_u_39(v_u_49, v_u_49.Volume, p42)
        v_u_49:Play()
        v_u_49.Ended:Once(function()
            -- upvalues: (copy) v_u_49
            v_u_49:Destroy()
        end)
        return v_u_49
    end
end
function v_u_1.playOneTime(p50, p51, p52) -- name: playOneTime
    return p50:play(p51, p52 or 1)
end
function v_u_1.PlaySoundAtPosition(p_u_53, p54, p55, p56, p57, p58) -- name: PlaySoundAtPosition
    -- upvalues: (copy) Debris, (copy) v_u_14, (copy) HttpService, (copy) v_u_39
    if p_u_53.IsDestroyed then
        return
    elseif p_u_53.Sounds then
        local v59 = p_u_53.Sounds:FindFirstChild(p54.Name)
        if v59 then
            local v60 = p_u_53.Janitor:Add(Instance.new("Part"))
            v60.Size = Vector3.new(1, 1, 1)
            v60.Position = p54.Position
            v60.CollisionGroup = "Debris"
            v60.CanCollide = false
            v60.CanTouch = false
            v60.CanQuery = false
            v60.Anchored = true
            v60.Transparency = 1
            v60.Parent = Debris
            v60.Name = "Sound"
            local v_u_61 = p_u_53.Janitor:Add(v_u_14(v59))
            local Volume = v_u_61.Volume
            v_u_61.Name = HttpService:GenerateGUID(false)
            v_u_61.Parent = v60
            if (p54.Name == "Headshot" and true or p54.Name == "Helmet Headshot") and p57 then
                v_u_61.RollOffMode = Enum.RollOffMode.InverseTapered
                v_u_61.RollOffMaxDistance = 10000
                v_u_61.RollOffMinDistance = 10000
                if p58 then
                    Volume = Volume * 0
                end
            end
            v_u_39(v_u_61, Volume, p56)
            v_u_61:Play()
            if v_u_61.Looped and p55 then
                p_u_53.Janitor:Add(task.delay(p55, function()
                    -- upvalues: (copy) p_u_53
                    p_u_53:destroy()
                end), true)
            else
                p_u_53.Janitor:Add(v_u_61.Ended:Once(function()
                    -- upvalues: (copy) p_u_53
                    p_u_53:destroy()
                end))
            end
            p_u_53.Janitor:Add(v_u_61.AncestryChanged:Connect(function()
                -- upvalues: (copy) v_u_61, (copy) p_u_53
                if not v_u_61.Parent then
                    p_u_53:destroy()
                end
            end))
        else
            p_u_53:destroy()
        end
    else
        p_u_53:destroy()
        return
    end
end
function v_u_1.createSoundGroup(p63) -- name: createSoundGroup
    -- upvalues: (ref) v_u_7, (copy) v_u_29
    local v64 = require(p63)
    local v65 = Instance.new("Folder", v_u_7)
    v65.Name = p63.Name
    for v66, v67 in pairs(v64) do
        local v68 = Instance.new("Folder", v65)
        v68.Name = v66
        for v69, v70 in ipairs(v67.Identifiers) do
            v_u_29(v69, v70, v67.Properties).Parent = v68
        end
    end
end
function v_u_1.new(p71) -- name: new
    -- upvalues: (copy) v_u_1, (copy) m_Janitor, (ref) v_u_7
    local v72 = v_u_1
    local v73 = setmetatable({}, v72)
    v73.Janitor = m_Janitor.new()
    v73.IsDestroyed = false
    v73.SoundGroupName = p71
    v73.Sounds = v_u_7:WaitForChild(p71, 10)
    return v73
end
function v_u_1.destroy(p74) -- name: destroy
    if not p74.IsDestroyed then
        p74.IsDestroyed = true
        p74.Janitor:Destroy()
        p74.SoundGroupName = nil
        p74.Janitor = nil
        p74.Sounds = nil
    end
end
return v_u_1
