-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = workspace:WaitForChild("Debris")
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local LocalPlayer = Players.LocalPlayer
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local v_u_9 = Instance.new("WedgePart", script)
v_u_9.BottomSurface = Enum.SurfaceType.Smooth
v_u_9.TopSurface = Enum.SurfaceType.Smooth
v_u_9.Anchored = true
local function v_u_37(p10, p11, p12, p13) -- name: draw3dTriangle
    -- upvalues: (copy) v_u_9
    debug.profilebegin("VFX.BreakGlass.DrawTriangle")
    local v14 = p11 - p10
    local v15 = p12 - p10
    local v16 = p12 - p11
    local v17 = v14:Dot(v14)
    local v18 = v15:Dot(v15)
    local v19 = v16:Dot(v16)
    if v18 < v17 and v19 < v17 then
        local v20 = p12
        p12 = p10
        p10 = p11
        p11 = v20
    elseif v19 < v18 then
        if v17 >= v18 then
            local v21 = p11
            p11 = p10
            p10 = v21
        end
    else
        local v22 = p11
        p11 = p10
        p10 = v22
    end
    local v23 = p10 - p11
    local v24 = p12 - p11
    local v25 = p12 - p10
    local Unit = v24:Cross(v23).Unit
    local Unit_0 = v25:Cross(Unit).Unit
    local Unit_1 = v25.Unit
    local v29 = v23:Dot(Unit_0)
    local v30 = math.abs(v29)
    local v31 = v_u_9:Clone()
    local v32 = v23:Dot(Unit_1)
    local v33 = math.abs(v32)
    v31.Size = Vector3.new(0, v30, v33)
    v31.CFrame = CFrame.fromMatrix((p11 + p10) / 2, Unit, Unit_0, Unit_1)
    v31.Parent = p13
    local v34 = v_u_9:Clone()
    local v35 = v24:Dot(Unit_1)
    local v36 = math.abs(v35)
    v34.Size = Vector3.new(0, v30, v36)
    v34.CFrame = CFrame.fromMatrix((p11 + p12) / 2, -Unit, Unit_0, -Unit_1)
    v34.Parent = p13
    debug.profileend()
    return v31, v34
end
return function(p38, p39, p40)
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer, (copy) m_Janitor, (copy) m_Sound, (copy) v_u_37, (copy) Debris, (copy) TweenService
    debug.profilebegin("VFX.BreakGlass")
    if p38 then
        debug.profilebegin("VFX.BreakGlass.GetSetting")
        local v41 = m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Glass Shatter") ~= false
        debug.profileend()
        local v_u_42 = m_Janitor.new()
        if v41 then
            debug.profilebegin("VFX.BreakGlass.BuildCornerPoints")
            local v43 = {}
            if p38.Size.Z > p38.Size.X then
                local v44 = p38.CFrame * CFrame.new(0, p38.Size.Y * 0.5, p38.Size.Z * 0.5)
                table.insert(v43, v44)
                local v45 = p38.CFrame * CFrame.new(0, p38.Size.Y * 0.5, 0)
                table.insert(v43, v45)
                local v46 = p38.CFrame * CFrame.new(0, p38.Size.Y * 0.5, -p38.Size.Z * 0.5)
                table.insert(v43, v46)
                local v47 = p38.CFrame * CFrame.new(0, 0, -p38.Size.Z * 0.5)
                table.insert(v43, v47)
                local v48 = p38.CFrame * CFrame.new(0, -p38.Size.Y * 0.5, -p38.Size.Z * 0.5)
                table.insert(v43, v48)
                local v49 = p38.CFrame * CFrame.new(0, -p38.Size.Y * 0.5, 0)
                table.insert(v43, v49)
                local v50 = p38.CFrame * CFrame.new(0, -p38.Size.Y * 0.5, p38.Size.Z * 0.5)
                table.insert(v43, v50)
                local v51 = p38.CFrame * CFrame.new(0, 0, p38.Size.Z * 0.5)
                table.insert(v43, v51)
            else
                local v52 = p38.CFrame * CFrame.new(p38.Size.X * 0.5, p38.Size.Y * 0.5, 0)
                table.insert(v43, v52)
                local v53 = p38.CFrame * CFrame.new(0, p38.Size.Y * 0.5, 0)
                table.insert(v43, v53)
                local v54 = p38.CFrame * CFrame.new(-p38.Size.X * 0.5, p38.Size.Y * 0.5, 0)
                table.insert(v43, v54)
                local v55 = p38.CFrame * CFrame.new(-p38.Size.X * 0.5, 0, 0)
                table.insert(v43, v55)
                local v56 = p38.CFrame * CFrame.new(-p38.Size.X * 0.5, -p38.Size.Y * 0.5, 0)
                table.insert(v43, v56)
                local v57 = p38.CFrame * CFrame.new(0, -p38.Size.Y * 0.5, 0)
                table.insert(v43, v57)
                local v58 = p38.CFrame * CFrame.new(p38.Size.X * 0.5, -p38.Size.Y * 0.5, 0)
                table.insert(v43, v58)
                local v59 = p38.CFrame * CFrame.new(p38.Size.X * 0.5, 0, 0)
                table.insert(v43, v59)
            end
            debug.profileend()
            debug.profilebegin("VFX.BreakGlass.CreateFragments")
            for v60, v61 in ipairs(v43) do
                local v62 = v43[v60 + 1] or v43[1]
                local v_u_63, v_u_64 = v_u_37(v61.Position, v62.Position, p39, Debris)
                for _, v65 in ipairs({ v_u_63, v_u_64 }) do
                    local Transparency = p38.Transparency
                    v65.Transparency = math.min(Transparency, 0.6)
                    v65.AssemblyLinearVelocity = p40 * 15
                    v65.CollisionGroup = "Debris"
                    v65.Color = p38.Color
                    v65.Anchored = false
                end
                v_u_42:Add(v_u_63)
                v_u_42:Add(v_u_64)
                task.delay(4.75, function()
                    -- upvalues: (copy) v_u_42, (ref) TweenService, (copy) v_u_63, (copy) v_u_64
                    debug.profilebegin("VFX.BreakGlass.FragmentFadeTween")
                    v_u_42:Add(TweenService:Create(v_u_63, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                        ["Transparency"] = 1
                    })):Play()
                    v_u_42:Add(TweenService:Create(v_u_64, TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                        ["Transparency"] = 1
                    })):Play()
                    debug.profileend()
                end)
            end
            debug.profileend()
            debug.profilebegin("VFX.BreakGlass.CleanupSource")
            p38.CollisionGroup = "Debris"
            p38.Transparency = 1
            p38.CanCollide = false
            p38.CastShadow = false
            p38.CanQuery = false
            p38.CanTouch = false
            p38.Anchored = true
            m_Sound.new("Bullet"):playOneTime({
                ["Name"] = "Glass Shattered",
                ["Parent"] = nil,
                ["Parent"] = p38
            })
            v_u_42:Add(p38)
            local Parent = p38.Parent
            if Parent and (Parent:IsA("Model") and Parent:HasTag("BreakableGlass")) then
                v_u_42:Add(Parent)
                for _, v68 in ipairs(Parent:GetDescendants()) do
                    if v68:IsA("Decal") then
                        v68:Destroy()
                    end
                end
            end
            debug.profileend()
            task.delay(5, function()
                -- upvalues: (copy) v_u_42
                debug.profilebegin("VFX.BreakGlass.DelayedCleanup")
                v_u_42:Destroy()
                debug.profileend()
            end)
            debug.profileend()
        else
            debug.profilebegin("VFX.BreakGlass.NoShatter.Sound")
            m_Sound.new("Bullet"):PlaySoundAtPosition({
                ["Position"] = nil,
                ["Class"] = "Bullet",
                ["Name"] = "Glass Shattered",
                ["Position"] = p39
            })
            debug.profileend()
            debug.profilebegin("VFX.BreakGlass.NoShatter.CleanupSource")
            p38.CollisionGroup = "Debris"
            p38.Transparency = 1
            p38.CanCollide = false
            p38.CastShadow = false
            p38.CanQuery = false
            p38.CanTouch = false
            p38.Anchored = true
            v_u_42:Add(p38)
            local Parent_0 = p38.Parent
            if Parent_0 and (Parent_0:IsA("Model") and Parent_0:HasTag("BreakableGlass")) then
                v_u_42:Add(Parent_0)
                for _, v70 in ipairs(Parent_0:GetDescendants()) do
                    if v70:IsA("Decal") then
                        v70:Destroy()
                    end
                end
            end
            debug.profileend()
            task.delay(0.1, function()
                -- upvalues: (copy) v_u_42
                debug.profilebegin("VFX.BreakGlass.NoShatter.DelayedCleanup")
                v_u_42:Destroy()
                debug.profileend()
            end)
            debug.profileend()
        end
    else
        debug.profileend()
        return
    end
end
