-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Other = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Other")
local Debris_0 = workspace:WaitForChild("Debris")
return function(p6)
    -- upvalues: (copy) Other, (copy) Players, (copy) Debris_0, (copy) Debris
    local v7 = tonumber(p6)
    if not v7 then
        return
    end
    local ZeusDeath = Other:FindFirstChild("ZeusDeath")
    if not (ZeusDeath and ZeusDeath:IsA("ParticleEmitter")) then
        return
    end
    local v9 = Players:GetPlayerByUserId(v7)
    local v10
    if v9 then
        v10 = Debris_0:FindFirstChild(v9.Name)
        if not (v10 and (v10:IsA("Model") and v10:HasTag("Ragdoll"))) then
            v10 = nil
        end
    else
        v10 = nil
    end
    if v10 then
        ::l14::
        if v10 then
            local HumanoidRootPart = v10:FindFirstChild("HumanoidRootPart")
            if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
                local v_u_12 = ZeusDeath:Clone()
                v_u_12.Enabled = false
                v_u_12.Parent = HumanoidRootPart
                local v13 = v_u_12:GetAttribute("EmitCount")
                if typeof(v13) == "number" and v13 > 0 then
                    v_u_12:Emit(v13)
                else
                    v_u_12.Enabled = true
                    task.delay(0.15, function()
                        -- upvalues: (copy) v_u_12
                        if v_u_12 and v_u_12.Parent then
                            v_u_12.Enabled = false
                        end
                    end)
                end
                local v14 = Debris
                local Max = v_u_12.Lifetime.Max
                v14:AddItem(v_u_12, math.max(Max, 1) + 1)
            end
        else
            return
        end
    else
        local v16 = os.clock() + 0.5
        while true do
            if true then
                task.wait(0.05)
                local v17 = Players:GetPlayerByUserId(v7)
                if v17 then
                    v10 = Debris_0:FindFirstChild(v17.Name)
                    if not (v10 and (v10:IsA("Model") and v10:HasTag("Ragdoll"))) then
                        v10 = nil
                    end
                else
                    v10 = nil
                end
            end
            if v10 or v16 <= os.clock() then
                goto l14
            end
        end
    end
end
