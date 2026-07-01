-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Tracers = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Tracers")
local Debris_0 = workspace:WaitForChild("Debris")
return function(_, p6, p7)
    -- upvalues: (copy) Tracers, (copy) Debris_0, (copy) TweenService, (copy) Debris
    debug.profilebegin("VFX.Tracer")
    if p6 then
        local Default = Tracers:FindFirstChild("Default")
        assert(Default, "Default is not apart of Assets.Miscellaneous")
        debug.profilebegin("VFX.Tracer.CloneAsset")
        local v9 = Default:Clone()
        v9.CollisionGroup = "Debris"
        v9.CanCollide = false
        v9.CanQuery = false
        v9.CanTouch = false
        v9.Anchored = true
        debug.profileend()
        debug.profilebegin("VFX.Tracer.Parent")
        v9.CFrame = CFrame.new(p6 + p7 * 5)
        v9.Parent = Debris_0
        debug.profileend()
        debug.profilebegin("VFX.Tracer.CreateTweens")
        local v_u_10 = TweenService:Create(v9, TweenInfo.new(1, Enum.EasingStyle.Linear), {
            ["CFrame"] = CFrame.new(p6 + p7 * 1000)
        })
        task.defer(function()
            -- upvalues: (copy) v_u_10
            v_u_10:Play()
        end)
        local v11 = TweenInfo.new(0.05, Enum.EasingStyle.Linear)
        v9.BottomAttachment.Position = Vector3.new(0, 0, 0)
        v9.RightAttachment.Position = Vector3.new(0, 0, 0)
        v9.LeftAttachment.Position = Vector3.new(0, 0, 0)
        v9.TopAttachment.Position = Vector3.new(0, 0, 0)
        TweenService:Create(v9.TopAttachment, v11, {
            ["Position"] = Vector3.new(0, 0.1, 0)
        }):Play()
        TweenService:Create(v9.BottomAttachment, v11, {
            ["Position"] = Vector3.new(0, -0.1, 0)
        }):Play()
        TweenService:Create(v9.LeftAttachment, v11, {
            ["Position"] = Vector3.new(-0.1, 0, 0)
        }):Play()
        TweenService:Create(v9.RightAttachment, v11, {
            ["Position"] = Vector3.new(0.1, 0, 0)
        }):Play()
        debug.profileend()
        Debris:AddItem(v9, 2)
        debug.profileend()
    else
        debug.profileend()
    end
end
