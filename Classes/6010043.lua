-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_InputController = require(ReplicatedStorage.Controllers.InputController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local CurrentCamera = workspace.CurrentCamera
local v_u_11 = Vector2.new(9.42477796076938, 5.497787143782138)
function v_u_1.UpdateMovement(p12, p13) -- name: UpdateMovement
    -- upvalues: (copy) m_InputController
    local Unit = Vector3.new(0, 0, 0)
    if m_InputController.isActionActive("Move Forward") then
        Unit = Unit + Vector3.new(0, 0, -1)
    end
    if m_InputController.isActionActive("Move Backward") then
        Unit = Unit + Vector3.new(0, 0, 1)
    end
    if m_InputController.isActionActive("Move Left (Strafe)") then
        Unit = Unit + Vector3.new(-1, 0, 0)
    end
    if m_InputController.isActionActive("Move Right (Strafe)") then
        Unit = Unit + Vector3.new(1, 0, 0)
    end
    local v15 = 40 * (m_InputController.isActionActive("Walk") and 0.2 or 1)
    if Unit ~= Vector3.new(0, 0, 0) then
        Unit = Unit.Unit
    end
    local CameraCFrame = p12.CameraCFrame
    local RightVector = CameraCFrame.RightVector
    local UpVector = CameraCFrame.UpVector
    local LookVector = CameraCFrame.LookVector
    local v20 = (RightVector * Unit.X + UpVector * Unit.Y + LookVector * -Unit.Z) * (v15 * p13)
    local v21 = p12.CameraCFrame.Position + v20
    p12.CameraCFrame = CFrame.new(v21, v21 + LookVector)
    p12:UpdateMouseWheel(p13)
end
function v_u_1.UpdateMouseWheel(p22, _) -- name: UpdateMouseWheel
    -- upvalues: (copy) m_InputController
    if p22.MouseWheelDelta ~= 0 then
        local v23 = m_InputController.isActionActive("Walk")
        local MouseWheelDelta = p22.MouseWheelDelta
        local CameraCFrame_0 = p22.CameraCFrame
        local LookVector_0 = CameraCFrame_0.LookVector
        local v27 = 15 * (v23 and 0.5 or 1)
        local v28 = LookVector_0 * (MouseWheelDelta > 0 and v27 and v27 or -v27)
        local v29 = CameraCFrame_0.Position + v28
        p22.CameraCFrame = CFrame.new(v29, v29 + LookVector_0)
        p22.MouseWheelDelta = 0
    end
end
function v_u_1.UpdateRotation(p30, _) -- name: UpdateRotation
    -- upvalues: (copy) UserInputService, (copy) m_InputController, (copy) CurrentCamera, (copy) v_u_11
    local v31 = UserInputService:GetMouseDelta()
    local v32 = m_InputController.isActionActive("Walk") and 0.5 or 1
    local ViewportSize = CurrentCamera.ViewportSize
    local v34 = v31.X / ViewportSize.X * (v_u_11.X * v32)
    local v35 = v31.Y / ViewportSize.Y * (v_u_11.Y * v32)
    local CameraCFrame_1 = p30.CameraCFrame
    local Position = CameraCFrame_1.Position
    local LookVector_1 = CameraCFrame_1.LookVector
    local v39 = LookVector_1.Y
    local v40 = math.asin(v39) - v35
    local v41 = math.clamp(v40, -1.3962634015954636, 1.3962634015954636)
    local v42 = LookVector_1.X
    local v43 = LookVector_1.Z
    local v44 = Vector3.new(v42, 0, v43)
    local Magnitude = v44.Magnitude
    local v46 = Magnitude < 0.001 and Vector3.new(0, 0, -1) or v44 / Magnitude
    local v47 = -v46.X
    local v48 = -v46.Z
    local v49 = math.atan2(v47, v48) - v34
    local v50 = math.cos(v41)
    local v51 = -math.sin(v49) * v50
    local v52 = math.sin(v41)
    local v53 = -math.cos(v49) * v50
    local v54 = Vector3.new(v51, v52, v53)
    p30.CameraCFrame = CFrame.new(Position, Position + v54)
end
function v_u_1.UpdateCamera(p55) -- name: UpdateCamera
    -- upvalues: (copy) CurrentCamera
    CurrentCamera.CFrame = p55.CameraCFrame
end
function v_u_1.Render(p56, p57) -- name: Render
    p56:UpdateMovement(p57)
    p56:UpdateRotation(p57)
    p56:UpdateCamera()
end
function v_u_1.Start(p_u_58) -- name: Start
    -- upvalues: (copy) CurrentCamera, (copy) m_CameraController, (copy) UserInputService, (copy) m_RunServiceController, (copy) LocalPlayer
    if not p_u_58.IsActive then
        p_u_58.IsActive = true
        p_u_58.CameraCFrame = CurrentCamera.CFrame
        p_u_58.MouseWheelDelta = 0
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        m_CameraController.setMouseEnabled(false)
        p_u_58.Janitor:Add(UserInputService:GetPropertyChangedSignal("MouseBehavior"):Connect(function()
            -- upvalues: (copy) p_u_58, (ref) UserInputService
            if p_u_58.IsActive and UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
                UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            end
        end), "Disconnect", "EnforceMouseBehavior")
        p_u_58.RenderStepName = "Freecam"
        m_RunServiceController.BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value + 10, function(p59)
            -- upvalues: (copy) p_u_58
            if p_u_58.IsActive then
                p_u_58:Render(p59)
            end
        end)
        local Map = workspace:FindFirstChild("Map")
        local v61
        if Map then
            local ReplicationFocus = Map:FindFirstChild("ReplicationFocus")
            if ReplicationFocus then
                v61 = ReplicationFocus:FindFirstChild("Focus")
            else
                v61 = nil
            end
        else
            v61 = nil
        end
        if v61 then
            LocalPlayer.ReplicationFocus = v61
            p_u_58.Janitor:Add(function()
                -- upvalues: (ref) LocalPlayer
                LocalPlayer.ReplicationFocus = nil
            end, true, "ReplicationFocus")
        end
        p_u_58.Janitor:Add(function()
            -- upvalues: (ref) m_RunServiceController
            m_RunServiceController.UnbindFromRenderStep("Freecam")
        end, true)
    end
end
function v_u_1.Stop(p63) -- name: Stop
    -- upvalues: (copy) m_RunServiceController, (copy) CurrentCamera
    if p63.IsActive then
        p63.IsActive = false
        m_RunServiceController.UnbindFromRenderStep("Freecam")
        p63.RenderStepName = nil
        CurrentCamera.CameraType = Enum.CameraType.Custom
        if p63.Janitor:Get("EnforceMouseBehavior") then
            p63.Janitor:Remove("EnforceMouseBehavior")
        end
        if p63.Janitor:Get("ReplicationFocus") then
            p63.Janitor:Remove("ReplicationFocus")
        end
    end
end
function v_u_1.new() -- name: new
    -- upvalues: (copy) v_u_1, (copy) m_Janitor, (copy) UserInputService
    local v64 = v_u_1
    local v_u_65 = setmetatable({}, v64)
    v_u_65.Janitor = m_Janitor.new()
    v_u_65.CameraCFrame = CFrame.identity
    v_u_65.MouseWheelDelta = 0
    v_u_65.RenderStepName = nil
    v_u_65.IsActive = false
    v_u_65.Janitor:Add(UserInputService.InputChanged:Connect(function(p66, p67)
        -- upvalues: (copy) v_u_65
        if v_u_65.IsActive and (not p67 and p66.UserInputType == Enum.UserInputType.MouseWheel) then
            v_u_65.MouseWheelDelta = p66.Position.Z
        end
    end), "Disconnect")
    v_u_65.Janitor:Add(function()
        -- upvalues: (copy) v_u_65
        if v_u_65.IsActive then
            v_u_65:Stop()
        end
    end)
    return v_u_65
end
function v_u_1.Destroy(p68) -- name: Destroy
    p68.Janitor:Destroy()
end
return v_u_1
