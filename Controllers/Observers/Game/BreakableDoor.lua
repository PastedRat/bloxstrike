-- Decompiled with Medal

local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local v_u_10 = Players.LocalPlayer:GetMouse()
local v_u_11 = UserInputService.TouchEnabled
if v_u_11 then
    v_u_11 = not UserInputService.KeyboardEnabled
end
local v_u_12 = {}
local v_u_13 = nil
local v_u_14 = {}
local function v_u_28(p15) -- name: stepVisuals
    -- upvalues: (copy) v_u_14, (ref) v_u_13
    local v16 = false
    for v17, v18 in pairs(v_u_14) do
        if v17.Parent then
            if v18.Moving then
                v16 = true
                local v19 = v18.TargetAngle - v18.Angle > 0 and 1 or -1
                local StartAngle = v18.TargetAngle - v18.StartAngle
                local Duration = math.abs(StartAngle) / v18.Duration
                local v22 = v18.Angle + v19 * Duration * p15
                local v23
                if v19 > 0 then
                    local TargetAngle = v18.TargetAngle
                    v23 = math.min(v22, TargetAngle)
                else
                    local TargetAngle_0 = v18.TargetAngle
                    v23 = math.max(v22, TargetAngle_0)
                end
                local v26 = v_u_14[v17]
                if v26 then
                    v26.Angle = v23
                    v17:PivotTo(v26.ClosedPivot * CFrame.Angles(0, v23, 0))
                end
                local v27 = v18.TargetAngle - v23
                if math.abs(v27) < 0.001 then
                    v18.Moving = false
                end
            end
        else
            v_u_14[v17] = nil
        end
    end
    if not v16 and v_u_13 then
        v_u_13:Disconnect()
        v_u_13 = nil
    end
end
local function v_u_30() -- name: useMouseDoor
    -- upvalues: (copy) v_u_10, (copy) v_u_12, (copy) m_Remotes
    local v29 = v_u_10.Target
    if v29 then
        while v29 do
            if v29:IsA("Model") and v_u_12[v29] then
                m_Remotes.BreakableDoor.Use.Send(v29)
                return
            end
            v29 = v29.Parent
        end
    end
end
v_u_10.Button1Down:Connect(function()
    -- upvalues: (copy) v_u_11, (copy) v_u_30
    if not v_u_11 then
        v_u_30()
    end
end)
local function v_u_36(p31) -- name: applyDoorState
    -- upvalues: (copy) v_u_14, (ref) v_u_13, (copy) m_RunServiceController, (copy) v_u_28
    local v32 = v_u_14[p31]
    if v32 then
        local Angle = p31:GetAttribute("DoorAngle") or v32.Angle
        local v34 = v_u_14[p31]
        if v34 then
            v34.Angle = Angle
            p31:PivotTo(v34.ClosedPivot * CFrame.Angles(0, Angle, 0))
        end
        v32.StartAngle = Angle
        v32.TargetAngle = p31:GetAttribute("DoorTargetAngle") or Angle
        local v35 = p31:GetAttribute("DoorMoveDuration") or 0
        v32.Duration = math.max(v35, 0.001)
        v32.Elapsed = 0
        v32.Moving = p31:GetAttribute("DoorMoving") == true
        if v32.Moving and not v_u_13 then
            v_u_13 = m_RunServiceController.BindToRenderStep("Observers.Game.BreakableDoor.StepVisuals", v_u_28)
        end
    end
end
local function v_u_50(p_u_37, p38) -- name: releaseVisualStage
    -- upvalues: (copy) v_u_14, (copy) m_Sound, (copy) Debris
    local v39 = v_u_14[p_u_37]
    if v39 then
        local v40 = p_u_37:GetAttribute("BreakDirectionX") or 0
        local v41 = p_u_37:GetAttribute("BreakDirectionY") or 0
        local v42 = p_u_37:GetAttribute("BreakDirectionZ") or 0
        local v43 = Vector3.new(v40, v41, v42)
        local Unit = v43.Magnitude <= 0 and Vector3.new(0, 0, 1) or v43.Unit
        local v45 = workspace:FindFirstChild("Debris") or workspace
        for _, v46 in ipairs(v39.StageParts[p38] or {}) do
            if v46.Parent then
                local v_u_47 = v46:Clone()
                local v_u_48 = nil
                v_u_47.Transparency = v39.Transparencies[v46] or 0
                v_u_47.Anchored = false
                v_u_47.CanCollide = true
                v_u_47.CanQuery = false
                v_u_47.CanTouch = true
                v_u_47.CFrame = v46.CFrame
                v_u_47:SetAttribute("BreakableDoorDebris", true)
                v_u_48 = v_u_47.Touched:Connect(function(p49)
                    -- upvalues: (copy) p_u_37, (ref) v_u_48, (ref) m_Sound, (copy) v_u_47
                    if p49.CanCollide and (p49:GetAttribute("BreakableDoorDebris") ~= true and not p49:IsDescendantOf(p_u_37)) then
                        if v_u_48 then
                            v_u_48:Disconnect()
                            v_u_48 = nil
                        end
                        m_Sound.new("BreakableDoor"):PlaySoundAtPosition({
                            ["Position"] = nil,
                            ["Class"] = "BreakableDoor",
                            ["Name"] = "Part Hit Ground",
                            ["Position"] = v_u_47.Position
                        })
                    end
                end)
                v_u_47.Parent = v45
                Debris:AddItem(v_u_47, 8)
                v_u_47:ApplyImpulse((Unit + Vector3.new(0, 0.35, 0)) * v_u_47.AssemblyMass * math.random(20, 35))
            end
        end
    end
end
local function v_u_55(p51) -- name: applyStage
    -- upvalues: (copy) v_u_14, (copy) v_u_50
    local v52 = v_u_14[p51]
    if v52 then
        local v53 = p51:GetAttribute("Stage") or 0
        if v53 <= v52.Stage then
            v52.Stage = v53
        else
            for v54 = v52.Stage + 1, v53 do
                v_u_50(p51, v54)
            end
            v52.Stage = v53
        end
    else
        return
    end
end
return m_Observers.observeTag("BreakableDoor", function(p_u_56)
    -- upvalues: (copy) m_Janitor, (copy) v_u_12, (copy) v_u_14, (copy) v_u_36, (copy) v_u_55, (ref) v_u_13
    if not p_u_56:IsA("Model") then
        return nil
    end
    local v_u_57 = m_Janitor.new()
    v_u_12[p_u_56] = true
    v_u_14[p_u_56] = {
        ["ClosedPivot"] = nil,
        ["Angle"] = nil,
        ["StartAngle"] = 0,
        ["TargetAngle"] = 0,
        ["Duration"] = 0,
        ["Elapsed"] = 0,
        ["Moving"] = false,
        ["Stage"] = nil,
        ["StageParts"] = nil,
        ["Transparencies"] = nil,
        ["ClosedPivot"] = p_u_56:GetPivot(),
        ["Angle"] = p_u_56:GetAttribute("DoorAngle") or 0,
        ["Stage"] = p_u_56:GetAttribute("Stage") or 0,
        ["StageParts"] = {},
        ["Transparencies"] = {}
    }
    for _, v58 in ipairs(p_u_56:GetChildren()) do
        if v58:IsA("BasePart") then
            local Name = v58.Name
            local v60 = tonumber(Name:match("^Stage(%d)Break$"))
            if v60 then
                v_u_14[p_u_56].StageParts[v60] = v_u_14[p_u_56].StageParts[v60] or {}
                local v61 = v_u_14[p_u_56].StageParts[v60]
                table.insert(v61, v58)
                v_u_14[p_u_56].Transparencies[v58] = v58.Transparency
            end
        end
    end
    local Angle_0 = v_u_14[p_u_56].Angle
    local v63 = v_u_14[p_u_56]
    if v63 then
        v63.Angle = Angle_0
        p_u_56:PivotTo(v63.ClosedPivot * CFrame.Angles(0, Angle_0, 0))
    end
    v_u_36(p_u_56)
    v_u_57:Add(p_u_56:GetAttributeChangedSignal("DoorMoveId"):Connect(function()
        -- upvalues: (ref) v_u_36, (copy) p_u_56
        v_u_36(p_u_56)
    end))
    v_u_57:Add(p_u_56:GetAttributeChangedSignal("Stage"):Connect(function()
        -- upvalues: (ref) v_u_55, (copy) p_u_56
        v_u_55(p_u_56)
    end))
    v_u_57:Add(function()
        -- upvalues: (ref) v_u_12, (copy) p_u_56, (ref) v_u_14, (ref) v_u_13
        v_u_12[p_u_56] = nil
        v_u_14[p_u_56] = nil
        if next(v_u_14) == nil and v_u_13 then
            v_u_13:Disconnect()
            v_u_13 = nil
        end
    end)
    return function()
        -- upvalues: (copy) v_u_57
        v_u_57:Destroy()
    end
end)
