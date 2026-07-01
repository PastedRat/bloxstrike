-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local m_DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local m_GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local m_CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam)
local Debris = workspace:WaitForChild("Debris")
local v_u_7 = {}
local function v_u_13(p_u_8) -- name: getEmitterConfigs
    -- upvalues: (copy) v_u_7
    local v9 = v_u_7[p_u_8]
    if v9 then
        return v9
    end
    local v10 = {}
    for _, v11 in ipairs(p_u_8:GetDescendants()) do
        if v11:IsA("ParticleEmitter") then
            local v12 = {
                ["Emitter"] = v11,
                ["Delay"] = v11:GetAttribute("EmitDelay") or 0,
                ["Count"] = v11:GetAttribute("EmitCount") or 1
            }
            table.insert(v10, v12)
        end
    end
    v_u_7[p_u_8] = v10
    p_u_8.Destroying:Once(function()
        -- upvalues: (ref) v_u_7, (copy) p_u_8
        v_u_7[p_u_8] = nil
    end)
    return v10
end
function executeMuzzleFlash(p14, p15) -- name: executeMuzzleFlash
    -- upvalues: (copy) v_u_13
    debug.profilebegin("VFX.MuzzleFlash.Character.Execute")
    local v16 = p14:FindFirstChild(p15)
    if not v16 then
        debug.profileend()
        return nil
    end
    debug.profilebegin("VFX.MuzzleFlash.Character.EmitParticles")
    for _, v_u_17 in ipairs((v_u_13(v16))) do
        local Emitter = v_u_17.Emitter
        if v_u_17.Delay > 0 then
            task.delay(v_u_17.Delay, function()
                -- upvalues: (copy) Emitter, (copy) v_u_17
                if Emitter.Parent then
                    Emitter:Emit(v_u_17.Count)
                end
            end)
        elseif Emitter.Parent then
            Emitter:Emit(v_u_17.Count)
        end
    end
    debug.profileend()
    debug.profileend()
    return p14.Position
end
local function v_u_20(p19, ...) -- name: dlog
    -- upvalues: (copy) m_DebugFlags
    if m_DebugFlags.IsEnabled("WeaponFX") then
        warn(("[WeaponFX][MuzzleFlash.Character] " .. p19):format(...))
    end
end
local function v_u_39(p_u_21, p_u_22, p_u_23, p_u_24, p_u_25, p_u_26) -- name: tryCreate
    -- upvalues: (copy) Players, (copy) v_u_20, (copy) m_GetWeaponProperties, (copy) Debris, (copy) v_u_39, (copy) m_CreateZeusBeam
    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate")
    local v27 = Players:FindFirstChild(p_u_21)
    if v27 then
        debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.GetWeaponProperties")
        local v28 = m_GetWeaponProperties(p_u_22)
        debug.profileend()
        if v28 then
            if v27.Character then
                debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindWeaponModel")
                local v29 = Debris:FindFirstChild(v27.Name .. "_Weapon")
                debug.profileend()
                if v29 then
                    debug.profilebegin("VFX.MuzzleFlash.Character.TryCreate.FindMuzzlePart")
                    local Interactables = v29:FindFirstChild("Interactables")
                    if Interactables then
                        local MuzzlePart = Interactables:FindFirstChild("MuzzlePart")
                        if v28.ShootingOptions == "Dual" then
                            MuzzlePart = Interactables:FindFirstChild("MuzzlePart" .. (p_u_23 == "Left" and "L" or "R"))
                        end
                        if MuzzlePart then
                            debug.profileend()
                            if v28.MuzzleType == "Zeus x27" then
                                debug.profilebegin("VFX.MuzzleFlash.Character.CreateZeusBeam")
                                m_CreateZeusBeam(MuzzlePart)
                                debug.profileend()
                            end
                            if p_u_26 then
                                debug.profileend()
                                return
                            else
                                local MuzzleType = p_u_24 or v28.MuzzleType
                                if MuzzleType then
                                    if not executeMuzzleFlash(MuzzlePart, MuzzleType) then
                                        v_u_20("executeMuzzleFlash failed player=%s weapon=%s override=%s attempt=%d", v27.Name, tostring(p_u_22), tostring(p_u_24), p_u_25)
                                    end
                                    debug.profileend()
                                else
                                    debug.profileend()
                                end
                            end
                        else
                            v_u_20("missing muzzle part player=%s weapon=%s shootingHand=%s attempt=%d", v27.Name, tostring(p_u_22), tostring(p_u_23), p_u_25)
                            debug.profileend()
                            debug.profileend()
                            return
                        end
                    else
                        if p_u_25 < 3 then
                            task.delay(0.05, function()
                                -- upvalues: (ref) v_u_39, (copy) p_u_21, (copy) p_u_22, (copy) p_u_23, (copy) p_u_24, (copy) p_u_25, (copy) p_u_26
                                v_u_39(p_u_21, p_u_22, p_u_23, p_u_24, p_u_25 + 1, p_u_26)
                            end)
                        end
                        local v33 = v_u_20
                        local Name = v27.Name
                        local v35 = p_u_25 < 3
                        v33("missing Interactables on %s_Weapon (retry=%s) player=%s weapon=%s attempt=%d", Name, tostring(v35), v27.Name, tostring(p_u_22), p_u_25)
                        debug.profileend()
                        debug.profileend()
                        return
                    end
                else
                    if p_u_25 < 3 then
                        task.delay(0.05, function()
                            -- upvalues: (ref) v_u_39, (copy) p_u_21, (copy) p_u_22, (copy) p_u_23, (copy) p_u_24, (copy) p_u_25, (copy) p_u_26
                            v_u_39(p_u_21, p_u_22, p_u_23, p_u_24, p_u_25 + 1, p_u_26)
                        end)
                    end
                    local v36 = v_u_20
                    local Name_0 = v27.Name
                    local v38 = p_u_25 < 3
                    v36("missing %s_Weapon in Debris (retry=%s) player=%s weapon=%s attempt=%d", Name_0, tostring(v38), v27.Name, tostring(p_u_22), p_u_25)
                    debug.profileend()
                    return
                end
            else
                v_u_20("character missing player=%s weapon=%s attempt=%d", v27.Name, tostring(p_u_22), p_u_25)
                debug.profileend()
                return
            end
        else
            v_u_20("weapon properties missing player=%s weapon=%s attempt=%d", v27.Name, tostring(p_u_22), p_u_25)
            debug.profileend()
            return
        end
    else
        v_u_20("player not found username=%s weapon=%s attempt=%d", tostring(p_u_21), tostring(p_u_22), p_u_25)
        debug.profileend()
        return
    end
end
return function(p40, p41, p42, p43, p44)
    -- upvalues: (copy) v_u_39
    v_u_39(p40, p41, p42, p43, 0, p44)
end
