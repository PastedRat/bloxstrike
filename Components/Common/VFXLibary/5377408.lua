-- Decompiled with Medal

game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local Smoke = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GrenadeParticles"):WaitForChild("Smoke")
local v_u_5 = {
    ["Terrorists"] = Color3.fromRGB(185, 170, 145),
    ["Counter-Terrorists"] = Color3.fromRGB(155, 170, 190)
}
local _ = {
    ["Color"] = nil,
    ["Decay"] = nil,
    ["Density"] = 1,
    ["Glare"] = 1,
    ["Haze"] = 2.5,
    ["Color"] = Color3.new(1, 1, 1),
    ["Decay"] = Color3.new(1, 1, 1)
}
local v_u_6 = {}
local v_u_7 = {}
local v_u_8 = nil
local function v_u_25(p9, p10, p11, p12) -- name: CreateVoxel
    -- upvalues: (copy) Smoke, (copy) v_u_7
    local v13 = Smoke:Clone()
    v13.Name = "SmokeVoxel"
    v13.Size = Vector3.new(p10, p10, p10)
    v13.Position = p9
    v13.Anchored = true
    v13.CanCollide = false
    v13.CanQuery = false
    v13.CanTouch = false
    v13.CastShadow = false
    v13.Parent = p11
    local v14 = p10 / 4
    local v15 = {}
    for _, v16 in ipairs(v13:GetDescendants()) do
        if v16:IsA("ParticleEmitter") then
            local Keypoints = v16.Size.Keypoints
            local v18 = {}
            for _, v19 in ipairs(Keypoints) do
                local new = NumberSequenceKeypoint.new
                local Time = v19.Time
                local v22 = v19.Value * v14
                local v23 = v19.Envelope * v14
                table.insert(v18, new(Time, v22, v23))
            end
            v16.Size = NumberSequence.new(v18)
            if p12 then
                v16.Color = ColorSequence.new(p12)
            end
            v16.Enabled = false
            table.insert(v15, v16)
        end
    end
    for _, v24 in ipairs(v13:GetChildren()) do
        if v24:IsA("BillboardGui") then
            v24:Destroy()
        end
    end
    v_u_7[v13] = {
        ["voxel"] = nil,
        ["emitters"] = nil,
        ["emitConnection"] = nil,
        ["isActive"] = false,
        ["lastEmitTime"] = 0,
        ["scaleFactor"] = nil,
        ["teamColor"] = nil,
        ["lifetimeExtended"] = false,
        ["activatedTime"] = 0,
        ["emissionStopped"] = false,
        ["totalParticlesEmitted"] = 0,
        ["voxel"] = v13,
        ["emitters"] = v15,
        ["scaleFactor"] = v14,
        ["teamColor"] = p12
    }
    return v13
end
local function v_u_46(p26, p27) -- name: DeploySmoke
    -- upvalues: (ref) v_u_8, (copy) m_RunServiceController, (copy) v_u_7
    debug.profilebegin("VFX.VoxelSmoke.DeploySmoke")
    local v28 = p26:GetChildren()
    if #v28 == 0 then
        debug.profileend()
        return
    else
        local Position = Vector3.new(0, 0, 0)
        local v30 = {}
        for _, v31 in ipairs(v28) do
            if v31:IsA("BasePart") then
                Position = Position + v31.Position
                table.insert(v30, v31)
            end
        end
        if #v30 == 0 then
            debug.profileend()
        else
            local v32 = Position / #v30
            local v33 = 0
            for _, v34 in ipairs(v30) do
                local Magnitude = (v34.Position - v32).Magnitude
                if v33 < Magnitude then
                    v33 = Magnitude
                end
            end
            local v36 = v33 == 0 and 1 or v33
            if not v_u_8 then
                v_u_8 = m_RunServiceController.BindToHeartbeat("VFX.CreateVoxelSmoke.Emitters", function()
                    -- upvalues: (ref) v_u_7
                    local v37 = tick()
                    for _, v38 in pairs(v_u_7) do
                        if v38.voxel and (v38.voxel.Parent and (v38.isActive and not v38.emissionStopped)) then
                            if not v38.lifetimeExtended then
                                v38.lifetimeExtended = true
                                v38.activatedTime = v37
                                for _, v39 in ipairs(v38.emitters) do
                                    if v39 and v39.Parent then
                                        v39.Lifetime = NumberRange.new((1 / 0))
                                    end
                                end
                            end
                            local activatedTime = v37 - v38.activatedTime
                            if activatedTime >= 0.8 then
                                v38.emissionStopped = true
                            elseif 0.1 + 0.30000000000000004 * (activatedTime / 0.8) <= v37 - v38.lastEmitTime then
                                v38.lastEmitTime = v37
                                local v41 = #v38.emitters * 1
                                v38.totalParticlesEmitted = v38.totalParticlesEmitted + v41
                                for _, v42 in ipairs(v38.emitters) do
                                    if v42 and v42.Parent then
                                        v42:Emit(1)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
            for _, v_u_43 in ipairs(v30) do
                local v44 = (v_u_43.Position - v32).Magnitude / v36 * p27
                task.delay(v44, function()
                    -- upvalues: (copy) v_u_43, (ref) v_u_7
                    if v_u_43.Parent then
                        local v45 = v_u_7[v_u_43]
                        if v45 then
                            v45.isActive = true
                        end
                    end
                end)
            end
            debug.profileend()
        end
    end
end
local function v_u_54(p_u_47) -- name: FadeOutSmoke
    -- upvalues: (copy) v_u_7, (ref) v_u_8
    debug.profilebegin("VFX.VoxelSmoke.FadeOutSmoke")
    local v_u_48 = p_u_47:GetChildren()
    for _, v49 in ipairs(v_u_48) do
        if v49:IsA("BasePart") then
            local v50 = v_u_7[v49]
            if v50 then
                v50.isActive = false
                for _, v51 in ipairs(v50.emitters) do
                    if v51 and v51.Parent then
                        v51.Enabled = false
                    end
                end
            end
        end
    end
    task.delay(6, function()
        -- upvalues: (copy) v_u_48, (ref) v_u_7, (ref) v_u_8, (copy) p_u_47
        debug.profilebegin("VFX.VoxelSmoke.FadeOutSmoke.DelayedCleanup")
        for _, v52 in ipairs(v_u_48) do
            if v52:IsA("BasePart") then
                v_u_7[v52] = nil
                v52:Destroy()
            end
        end
        local v53 = false
        for _, _ in pairs(v_u_7) do
            v53 = true
            break
        end
        if not v53 and v_u_8 then
            v_u_8:Disconnect()
            v_u_8 = nil
        end
        if p_u_47 and p_u_47.Parent then
            p_u_47:Destroy()
        end
        debug.profileend()
    end)
    debug.profileend()
end
return {
    ["Create"] = function(p_u_55) -- name: Create
        -- upvalues: (copy) Workspace, (copy) v_u_6, (copy) v_u_5, (copy) v_u_25, (copy) v_u_46, (copy) v_u_54
        debug.profilebegin("VFX.VoxelSmoke.Create")
        local v_u_56 = Instance.new("Folder")
        v_u_56.Name = "VoxelSmoke_" .. p_u_55.SmokeId
        v_u_56.Parent = Workspace:WaitForChild("Debris")
        v_u_6[p_u_55.SmokeId] = v_u_56
        local Team = p_u_55.Team
        if Team then
            Team = v_u_5[p_u_55.Team]
        end
        debug.profilebegin("VFX.VoxelSmoke.Create.CreateVoxels")
        for _, v58 in ipairs(p_u_55.Voxels) do
            v_u_25(v58.Position, v58.Size, v_u_56, Team)
        end
        debug.profileend()
        v_u_46(v_u_56, p_u_55.DeployTime)
        task.delay(p_u_55.Duration, function()
            -- upvalues: (ref) v_u_6, (copy) p_u_55, (ref) v_u_54, (copy) v_u_56
            if v_u_6[p_u_55.SmokeId] then
                v_u_54(v_u_56)
                v_u_6[p_u_55.SmokeId] = nil
            end
        end)
        debug.profileend()
    end,
    ["Destroy"] = function(p59) -- name: Destroy
        -- upvalues: (copy) v_u_6, (copy) v_u_54
        debug.profilebegin("VFX.VoxelSmoke.Destroy")
        local v60 = v_u_6[p59]
        if v60 then
            v_u_54(v60)
            v_u_6[p59] = nil
        end
        debug.profileend()
    end,
    ["DestroyAll"] = function() -- name: DestroyAll
        -- upvalues: (copy) v_u_6, (copy) v_u_7, (ref) v_u_8
        debug.profilebegin("VFX.VoxelSmoke.DestroyAll")
        for v61, v62 in pairs(v_u_6) do
            for _, v63 in ipairs(v62:GetChildren()) do
                if v63:IsA("BasePart") then
                    v_u_7[v63] = nil
                    v63:Destroy()
                end
            end
            v62:Destroy()
            v_u_6[v61] = nil
        end
        local v64 = false
        for _, _ in pairs(v_u_7) do
            v64 = true
            break
        end
        if not v64 and v_u_8 then
            v_u_8:Disconnect()
            v_u_8 = nil
        end
        debug.profileend()
    end,
    ["Disrupt"] = function(p65, p66, p67) -- name: Disrupt
        -- upvalues: (copy) v_u_6, (copy) v_u_7, (copy) Smoke
        debug.profilebegin("VFX.VoxelSmoke.Disrupt")
        for _, v68 in pairs(v_u_6) do
            for _, v_u_69 in ipairs(v68:GetChildren()) do
                if v_u_69:IsA("BasePart") and p66 >= (v_u_69.Position - p65).Magnitude then
                    local v_u_70 = v_u_7[v_u_69]
                    if v_u_70 and v_u_70.isActive then
                        v_u_70.isActive = false
                        local scaleFactor = v_u_70.scaleFactor
                        for _, v72 in ipairs(v_u_70.emitters) do
                            if v72 and v72.Parent then
                                v72:Destroy()
                            end
                        end
                        v_u_70.emitters = {}
                        local teamColor = v_u_70.teamColor
                        task.delay(p67, function()
                            -- upvalues: (copy) v_u_70, (ref) v_u_7, (copy) v_u_69, (ref) Smoke, (copy) scaleFactor, (copy) teamColor
                            debug.profilebegin("VFX.VoxelSmoke.Disrupt.RestoreEmitters")
                            if v_u_70 and v_u_7[v_u_69] then
                                if v_u_69 and v_u_69.Parent then
                                    local v74 = {}
                                    for _, v75 in ipairs(Smoke:GetDescendants()) do
                                        if v75:IsA("ParticleEmitter") then
                                            local v76 = v75:Clone()
                                            local Keypoints_0 = v76.Size.Keypoints
                                            local v78 = {}
                                            for _, v79 in ipairs(Keypoints_0) do
                                                local new_0 = NumberSequenceKeypoint.new
                                                local Time_0 = v79.Time
                                                local v82 = v79.Value * scaleFactor
                                                local v83 = v79.Envelope * scaleFactor
                                                table.insert(v78, new_0(Time_0, v82, v83))
                                            end
                                            v76.Size = NumberSequence.new(v78)
                                            if teamColor then
                                                v76.Color = ColorSequence.new(teamColor)
                                            end
                                            v76.Enabled = false
                                            v76.Parent = v_u_69
                                            table.insert(v74, v76)
                                        end
                                    end
                                    v_u_70.emitters = v74
                                    v_u_70.lastEmitTime = 0
                                    v_u_70.isActive = true
                                    v_u_70.lifetimeExtended = false
                                    v_u_70.activatedTime = 0
                                    v_u_70.emissionStopped = false
                                    v_u_70.totalParticlesEmitted = 0
                                    debug.profileend()
                                else
                                    debug.profileend()
                                end
                            else
                                debug.profileend()
                                return
                            end
                        end)
                    end
                end
            end
        end
        debug.profileend()
    end,
    ["GetActiveVoxelCount"] = function() -- name: GetActiveVoxelCount
        -- upvalues: (copy) v_u_7
        local v84 = 0
        for _, _ in pairs(v_u_7) do
            v84 = v84 + 1
        end
        return v84
    end
}
