-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Other = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Other")
local Debris_0 = workspace:WaitForChild("Debris")
local function v_u_8(p5, p6) -- name: getBeamUpVector
    local v7 = p6 - p5 * p6:Dot(p5)
    if v7.Magnitude <= 0.001 then
        v7 = Vector3.new(0, 1, 0) - p5 * (Vector3.new(0, 1, 0)):Dot(p5)
    end
    if v7.Magnitude <= 0.001 then
        v7 = Vector3.new(0, 0, 1) - p5 * (Vector3.new(0, 0, 1)):Dot(p5)
    end
    return v7.Unit
end
local function v_u_16(p9) -- name: getBeamCleanupTime
    local v10 = 5
    for _, v11 in ipairs(p9:GetDescendants()) do
        if v11:IsA("ParticleEmitter") then
            local v12 = v11:GetAttribute("EmitDelay")
            local v13 = typeof(v12) ~= "number" and 0 or v12
            local Max = v11.Lifetime.Max
            local v15 = v13 + math.max(Max, 1) + 1
            v10 = math.max(v10, v15)
        end
    end
    return v10
end
return function(p17)
    -- upvalues: (copy) Other, (copy) v_u_8, (copy) Debris_0, (copy) Debris, (copy) v_u_16
    local ZeusBeam = Other:FindFirstChild("ZeusBeam")
    if not (ZeusBeam and ZeusBeam:IsA("BasePart")) then
        return nil
    end
    local LookVector = p17.CFrame.LookVector
    if LookVector.Magnitude <= 0.001 then
        return nil
    end
    local Unit = LookVector.Unit
    local v21 = ZeusBeam:Clone()
    v21.CollisionGroup = "Debris"
    v21.CanCollide = false
    v21.CanQuery = false
    v21.CanTouch = false
    v21.Anchored = true
    local v22 = p17.Position + Unit * (v21.Size.X * 0.5)
    local v23 = v_u_8(Unit, p17.CFrame.UpVector)
    v21.CFrame = CFrame.fromMatrix(v22, Unit, v23)
    v21.Parent = Debris_0
    for _, v_u_24 in ipairs(v21:GetDescendants()) do
        if v_u_24:IsA("ParticleEmitter") then
            local v25 = v_u_24:GetAttribute("EmitDelay")
            local v26 = typeof(v25) ~= "number" and 0 or v25
            task.delay(v26, function()
                -- upvalues: (copy) v_u_24
                if v_u_24.Parent then
                    local v27 = v_u_24:GetAttribute("EmitCount")
                    local v28 = typeof(v27) ~= "number" and 0 or v27
                    if v28 > 0 then
                        v_u_24:Emit(v28)
                    else
                        v_u_24.Enabled = true
                        task.delay(0.15, function()
                            -- upvalues: (ref) v_u_24
                            if v_u_24.Parent then
                                v_u_24.Enabled = false
                            end
                        end)
                    end
                else
                    return
                end
            end)
        end
    end
    Debris:AddItem(v21, (v_u_16(v21)))
    return v21
end
