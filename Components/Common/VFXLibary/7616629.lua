-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
require(ReplicatedStorage.Database.Custom.Types)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local m_FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local m_Materials = require(script.Components.Materials)
local Impacts = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Impacts")
local Debris_0 = workspace:WaitForChild("Debris")
local function v_u_13(p11) -- name: hasParticleEmitter
    for _, v12 in ipairs(p11:GetDescendants()) do
        if v12:IsA("ParticleEmitter") then
            return true
        end
    end
    return false
end
local function v_u_18(p14) -- name: createImpactMarker
    -- upvalues: (copy) v_u_13
    debug.profilebegin("VFX.Impact.CreateImpactMarker")
    local v15 = {}
    for _, v16 in ipairs(p14:GetChildren()) do
        if v16:IsA("BasePart") and v_u_13(v16) then
            v15[#v15 + 1] = v16
        end
    end
    if #v15 == 0 then
        debug.profileend()
        return nil
    end
    local v17 = v15[math.random(1, #v15)]:Clone()
    v17.CollisionGroup = "Debris"
    v17.CanCollide = false
    v17.CanQuery = false
    v17.CanTouch = false
    v17.Anchored = true
    debug.profileend()
    return v17
end
local function v_u_22(p19, p20) -- name: IsHeadImpact
    if p20 ~= "Blood Splatter" or not (p19 and p19:IsA("BasePart")) then
        return false
    end
    local v21 = string.lower(p19.Name)
    return (v21 == "head" or (v21 == "headhitbox" or (v21 == "hitboxhead" or v21 == "headhb"))) and true or string.find(v21, "head", 1, true) ~= nil
end
return function(p23, p24, p25, p26, p27, p28, p29, _, p30, p31, p32)
    -- upvalues: (copy) Impacts, (copy) m_Materials, (copy) v_u_22, (copy) Players, (copy) HttpService, (copy) m_FlashEffect, (copy) m_DebugFlags, (copy) m_Sound, (copy) v_u_18, (copy) Debris_0, (copy) Debris
    debug.profilebegin("VFX.Impact")
    local v33 = Impacts:FindFirstChild(m_Materials[p24] or p24)
    if v33 then
        if p23 then
            debug.profilebegin("VFX.Impact.ResolveSound")
            local Name = v33.Name
            if v_u_22(p23, p24) or p31 ~= nil then
                Name = "Headshot"
                local v35 = false
                if not p28 then
                    if p31 == nil then
                        local Model = p23:FindFirstAncestorOfClass("Model")
                        if Model and (Model:FindFirstChildOfClass("Humanoid") and Model:IsDescendantOf(workspace)) then
                            local v37 = Players:GetPlayerFromCharacter(Model)
                            if v37 and v37:IsDescendantOf(Players) then
                                local v38 = nil
                                local v_u_39 = v37:GetAttribute("Armor")
                                local v40
                                if typeof(v_u_39) == "string" and v_u_39 ~= "" then
                                    local v41
                                    v41, v40 = pcall(function()
                                        -- upvalues: (ref) HttpService, (copy) v_u_39
                                        return HttpService:JSONDecode(v_u_39)
                                    end)
                                    if v41 then
                                        if typeof(v40) ~= "table" then
                                            v40 = v38
                                        end
                                    else
                                        v40 = v38
                                    end
                                else
                                    v40 = v38
                                end
                                if v40 == nil then
                                    v35 = false
                                else
                                    v35 = v40.Type == "Kevlar + Helmet"
                                end
                            end
                        end
                    else
                        v35 = p31 == true
                    end
                end
                if v35 then
                    v33 = Impacts:FindFirstChild("Helmet Headshot") or v33
                    Name = "Helmet Headshot"
                end
            end
            debug.profileend()
            if p27 then
                if m_DebugFlags.IsEnabled("WeaponFX") then
                    warn(("[WeaponFX][Client][ImpactSound] skipped (exit shot) material=%s pos=%s"):format(tostring(p24), (tostring(p25))))
                end
            else
                debug.profilebegin("VFX.Impact.PlaySound")
                local v42 = m_FlashEffect.IsFlashed()
                local v43 = v42 and 0 or 1
                if m_DebugFlags.IsEnabled("WeaponFX") then
                    warn(("[WeaponFX][Client][ImpactSound] play material=%s sound=%s pos=%s flashed=%s exit=%s melee=%s volumeMult=%s"):format(tostring(p24), tostring(Name), tostring(p25), tostring(v42), tostring(p27), tostring(p28), (tostring(v43))))
                end
                m_Sound.new("Bullet"):PlaySoundAtPosition({
                    ["Position"] = nil,
                    ["Class"] = "Bullet",
                    ["Name"] = nil,
                    ["Position"] = p25,
                    ["Name"] = Name
                }, nil, v43, p29 == true, p30 == true)
                debug.profileend()
            end
        end
        if p24 == "Blood Splatter" then
            v33 = Impacts["Hit Registration"]
        end
        if v33 and (p24 == "Blood Splatter" or not p28) and p32 ~= true then
            local v44 = v_u_18(v33)
            if not v44 then
                debug.profileend()
                return
            end
            debug.profilebegin("VFX.Impact.ParentMarker")
            v44.CFrame = CFrame.new(p25, p25 + p26) + p26 * 0.1
            v44.Parent = Debris_0
            v44.Transparency = 1
            debug.profileend()
            debug.profilebegin("VFX.Impact.EmitParticles")
            for _, v_u_45 in ipairs(v44:GetDescendants()) do
                if v_u_45:IsA("ParticleEmitter") then
                    task.delay(v_u_45:GetAttribute("EmitDelay") or 0, function()
                        -- upvalues: (copy) v_u_45
                        v_u_45:Emit(v_u_45:GetAttribute("EmitCount") or 1)
                    end)
                end
            end
            debug.profileend()
            Debris:AddItem(v44, 5)
        end
    end
    debug.profileend()
end
