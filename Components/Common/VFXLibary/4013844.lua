-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
game:GetService("Workspace")
local GrenadeParticles = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GrenadeParticles")
local InnerFire = GrenadeParticles:WaitForChild("InnerFire")
local OuterFire = GrenadeParticles:WaitForChild("OuterFire")
local v_u_6 = {}
local function v_u_27(p7, p8) -- name: GetSurfaceCFrame
    local Unit = p8.Unit
    local v10 = Unit.Y
    if math.abs(v10) > 0.99 then
        return CFrame.new(p7)
    end
    local v11 = Unit.X
    local v12 = math.abs(v11)
    local v13 = Unit.Z
    local v14
    if math.abs(v13) <= v12 then
        local v15 = Unit.X
        local v16 = Unit.Y
        v14 = Vector3.new(v15, v16, 0).Unit
    else
        local v17 = Unit.Y
        local v18 = Unit.Z
        v14 = Vector3.new(0, v17, v18).Unit
    end
    local v19 = v14.X
    local v20 = v14.Z
    local v21 = Vector3.new(v19, 0, v20)
    if v21.Magnitude < 0.01 then
        return CFrame.new(p7)
    end
    local Unit_0 = v21.Unit
    local v23 = Unit_0.Z
    local v24 = -Unit_0.X
    local v25 = Vector3.new(v23, 0, v24)
    local Unit_1 = v25:Cross(v14).Unit
    return CFrame.fromMatrix(p7, v25, v14, -Unit_1)
end
local function v_u_36(p28, p29, p30, p31, p32, p33) -- name: CreateVoxel
    -- upvalues: (copy) InnerFire, (copy) OuterFire, (copy) v_u_27
    local v34 = (p32 and InnerFire or OuterFire):Clone()
    v34.Name = p32 and "InnerFireVoxel" or "OuterFireVoxel"
    v34.Size = Vector3.new(p29, 0.2, p30)
    v34.CFrame = v_u_27(p28, p31)
    v34.Anchored = true
    v34.CanCollide = false
    v34.CanQuery = false
    v34.CanTouch = false
    v34.CastShadow = false
    v34.Parent = p33
    for _, v35 in ipairs(v34:GetDescendants()) do
        if v35:IsA("ParticleEmitter") then
            v35.Enabled = true
        end
    end
    return v34
end
local v_u_84 = {
    ["Create"] = function(p_u_37) -- name: Create
        -- upvalues: (copy) v_u_6, (copy) v_u_36, (copy) TweenService, (copy) v_u_84
        debug.profilebegin("VFX.VoxelFire.Create")
        local v38 = Instance.new("Folder")
        v38.Name = "VoxelFire_" .. p_u_37.FireId
        v38.Parent = workspace:WaitForChild("Debris")
        v_u_6[p_u_37.FireId] = v38
        debug.profilebegin("VFX.VoxelFire.Create.CalculateCenter")
        local v39 = Vector3.new(0, 0, 0)
        for _, v40 in ipairs(p_u_37.Voxels) do
            v39 = v39 + v40.Position
        end
        if #p_u_37.Voxels > 0 then
            v39 = v39 / #p_u_37.Voxels
        end
        debug.profileend()
        local v41 = CFrame.identity
        debug.profilebegin("VFX.VoxelFire.Create.CreateVoxels")
        local v42 = (1 / 0)
        local v43 = nil
        local Size = Vector3.new(0, 0, 0)
        for _, v45 in ipairs(p_u_37.Voxels) do
            local v46 = v45.Position.X
            local v47 = v45.Position.Z
            local v48 = Vector3.new(v46, 0, v47)
            local v49 = v39.X
            local v50 = v39.Z
            local v51 = (v48 - Vector3.new(v49, 0, v50)).Magnitude <= 4
            local v52 = v_u_36(v45.Position, v45.SizeX, v45.SizeZ, v45.Normal, v51, v38)
            local v53 = v45.Position.X
            local v54 = v45.Position.Z
            local v55 = Vector3.new(v53, 0, v54)
            local v56 = p_u_37.Position.X
            local v57 = p_u_37.Position.Z
            local Magnitude = (v55 - Vector3.new(v56, 0, v57)).Magnitude
            if Magnitude < v42 then
                Size = v52.Size
                v41 = v52.CFrame
                v43 = v52
                v42 = Magnitude
            end
        end
        debug.profileend()
        if v43 then
            debug.profilebegin("VFX.VoxelFire.Create.LandingBurstTween")
            local v59 = Size.X
            local v60 = Size.Z
            local v61 = Vector3.new(v59, 10, v60)
            local v62 = v41 + v41.UpVector * ((v61.Y - Size.Y) / 2)
            v43.Size = v61
            v43.CFrame = v62
            TweenService:Create(v43, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ["Size"] = Size,
                ["CFrame"] = v41
            }):Play()
            debug.profileend()
        end
        task.delay(p_u_37.Duration, function()
            -- upvalues: (ref) v_u_6, (copy) p_u_37, (ref) v_u_84
            if v_u_6[p_u_37.FireId] then
                v_u_84.Destroy(p_u_37.FireId)
            end
        end)
        debug.profileend()
    end,
    ["Destroy"] = function(p63) -- name: Destroy
        -- upvalues: (copy) v_u_6
        debug.profilebegin("VFX.VoxelFire.Destroy")
        local v_u_64 = v_u_6[p63]
        if v_u_64 then
            for _, v65 in ipairs(v_u_64:GetChildren()) do
                if v65:IsA("BasePart") then
                    for _, v66 in ipairs(v65:GetDescendants()) do
                        if v66:IsA("ParticleEmitter") then
                            v66.Enabled = false
                        end
                    end
                end
            end
            task.delay(2, function()
                -- upvalues: (copy) v_u_64
                if v_u_64 and v_u_64.Parent then
                    v_u_64:Destroy()
                end
            end)
            v_u_6[p63] = nil
        end
        debug.profileend()
    end,
    ["Update"] = function(p_u_67) -- name: Update
        -- upvalues: (copy) v_u_6, (copy) v_u_36
        debug.profilebegin("VFX.VoxelFire.Update")
        local v_u_68 = v_u_6[p_u_67.FireId]
        if v_u_68 then
            for _, v69 in ipairs(v_u_68:GetChildren()) do
                if v69:IsA("BasePart") then
                    for _, v70 in ipairs(v69:GetDescendants()) do
                        if v70:IsA("ParticleEmitter") then
                            v70.Enabled = false
                        end
                    end
                end
            end
            task.delay(0.3, function()
                -- upvalues: (copy) v_u_68, (copy) p_u_67, (ref) v_u_36
                debug.profilebegin("VFX.VoxelFire.Update.DelayedRebuild")
                if v_u_68 and v_u_68.Parent then
                    for _, v71 in ipairs(v_u_68:GetChildren()) do
                        if v71:IsA("BasePart") then
                            v71:Destroy()
                        end
                    end
                    if #p_u_67.Voxels == 0 then
                        debug.profileend()
                    else
                        local Position = Vector3.new(0, 0, 0)
                        for _, v73 in ipairs(p_u_67.Voxels) do
                            Position = Position + v73.Position
                        end
                        local Voxels = Position / #p_u_67.Voxels
                        for _, v75 in ipairs(p_u_67.Voxels) do
                            local v76 = v75.Position.X
                            local v77 = v75.Position.Z
                            local v78 = Vector3.new(v76, 0, v77)
                            local v79 = Voxels.X
                            local v80 = Voxels.Z
                            local v81 = (v78 - Vector3.new(v79, 0, v80)).Magnitude <= 4
                            v_u_36(v75.Position, v75.SizeX, v75.SizeZ, v75.Normal, v81, v_u_68)
                        end
                        debug.profileend()
                    end
                else
                    debug.profileend()
                    return
                end
            end)
            debug.profileend()
        else
            debug.profileend()
        end
    end,
    ["DestroyAll"] = function() -- name: DestroyAll
        -- upvalues: (copy) v_u_6
        debug.profilebegin("VFX.VoxelFire.DestroyAll")
        for v82, v83 in pairs(v_u_6) do
            if v83 and v83.Parent then
                v83:Destroy()
            end
            v_u_6[v82] = nil
        end
        debug.profileend()
    end
}
return v_u_84
