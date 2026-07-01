-- Decompiled with Medal

local v_u_1 = {}
local function v_u_7(p_u_2) -- name: getEmitterConfigs
    -- upvalues: (copy) v_u_1
    local v3 = v_u_1[p_u_2]
    if v3 then
        return v3
    end
    local v4 = {}
    for _, v5 in ipairs(p_u_2:GetDescendants()) do
        if v5:IsA("ParticleEmitter") then
            local v6 = {
                ["Emitter"] = v5,
                ["Delay"] = v5:GetAttribute("EmitDelay") or 0,
                ["Count"] = v5:GetAttribute("EmitCount") or 1
            }
            table.insert(v4, v6)
        end
    end
    v_u_1[p_u_2] = v4
    p_u_2.Destroying:Once(function()
        -- upvalues: (ref) v_u_1, (copy) p_u_2
        v_u_1[p_u_2] = nil
    end)
    return v4
end
return function(p8, p9)
    -- upvalues: (copy) v_u_7
    debug.profilebegin("VFX.MuzzleFlash.Camera")
    local v10 = p8:FindFirstChild(p9)
    if not v10 then
        debug.profileend()
        return nil
    end
    debug.profilebegin("VFX.MuzzleFlash.Camera.EmitParticles")
    for _, v_u_11 in ipairs((v_u_7(v10))) do
        local Emitter = v_u_11.Emitter
        if v_u_11.Delay > 0 then
            task.delay(v_u_11.Delay, function()
                -- upvalues: (copy) Emitter, (copy) v_u_11
                if Emitter.Parent then
                    Emitter:Emit(v_u_11.Count)
                end
            end)
        elseif Emitter.Parent then
            Emitter:Emit(v_u_11.Count)
        end
    end
    debug.profileend()
    debug.profileend()
    return p8.Position
end
