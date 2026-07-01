-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local m_Spring = require(ReplicatedStorage.Shared.Spring)
local LocalPlayer = Players.LocalPlayer
local MainGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui")
local CurrentCamera = workspace.CurrentCamera
local v_u_12 = true
local v_u_13 = 1
local v_u_14 = 0
Vector2.new(4, 3)
local v_u_15 = {}
local v_u_16 = {}
local v_u_17 = false
local v_u_18 = 1
local v_u_19 = 0.5
local v_u_20 = nil
local v_u_21 = nil
local v_u_22 = nil
local v_u_23 = nil
local v_u_24 = nil
local v_u_25 = m_Spring.new(1, 100, m_Constants.DEFAULT_CAMERA_FOV)
local v_u_26 = m_Spring.new(0.5, 25, Vector3.new(0, 0, 0))
local v_u_27 = m_Spring.new(0.4, 25, Vector3.new(0, 0, 0))
local v_u_28 = m_Spring.new(0.3, 35, Vector3.new(0, 0, 0))
local v_u_29 = m_Spring.new(0.6, 30, Vector3.new(0, 0, 0))
local v_u_30 = m_Spring.new(1, 1, Vector3.new(0, 0, 0))
local v_u_31 = m_Spring.new(1, 1, Vector3.new(0, 0, 0))
local v_u_32 = m_Spring.new(1, 1, Vector3.new(0, 0, 0))
local function v_u_36() -- name: getCameraInput
    -- upvalues: (ref) v_u_20, (copy) LocalPlayer
    if v_u_20 then
        return v_u_20
    end
    local v33 = LocalPlayer:FindFirstChild("PlayerScripts")
    if v33 then
        v33 = v33:FindFirstChild("PlayerModule")
    end
    if v33 then
        v33 = v33:FindFirstChild("CameraModule")
    end
    if v33 then
        v33 = v33:FindFirstChild("CameraInput")
    end
    if not (v33 and v33:IsA("ModuleScript")) then
        return nil
    end
    local v34, v35 = pcall(require, v33)
    if not (v34 and (v35 and v35.setTouchSensitivity)) then
        return nil
    end
    v_u_20 = v35
    return v35
end
local function v_u_45(p37) -- name: getCameraCFrame
    -- upvalues: (copy) v_u_26, (copy) v_u_31, (copy) v_u_27, (copy) v_u_30, (copy) v_u_32, (ref) v_u_13, (ref) v_u_21, (copy) ReplicatedStorage, (copy) v_u_29, (copy) v_u_28, (ref) v_u_24
    local v38 = v_u_26:getPosition()
    local v39 = v_u_31:getPosition() + v_u_27:getPosition()
    local v40 = v38 + v_u_30:getPosition()
    local v41 = v_u_32:getPosition() * (p37 or v_u_13)
    if not v_u_21 then
        local v42, v43 = pcall(function()
            -- upvalues: (ref) ReplicatedStorage
            return require(ReplicatedStorage.Controllers.AimAssistController)
        end)
        if v42 and v43 then
            v_u_21 = v43
        end
    end
    local v44 = v40 + v41 * (1 - (not (v_u_21 and v_u_21.GetRecoilAssistMultiplier) and 0 or v_u_21.GetRecoilAssistMultiplier())) + v_u_29:getPosition() + v_u_28:getPosition()
    return v_u_24 * CFrame.new(v39) * CFrame.Angles(v44.X, v44.Y, v44.Z)
end
function v_u_1.getWeaponKickRotation() -- name: getWeaponKickRotation
    -- upvalues: (copy) v_u_30
    return v_u_30:getPosition()
end
function v_u_1.updateCameraFOV() -- name: updateCameraFOV
    -- upvalues: (copy) v_u_16, (copy) v_u_25
    -- failed to decompile
end
function v_u_1.setFOVLock(p46, p47, p48) -- name: setFOVLock
    -- upvalues: (copy) v_u_25, (copy) v_u_16
    -- block 12
    if p47 then
        local v49 = p48 or v_u_25:getGoal()
        v_u_16[p46] = math.clamp(v49, 1, 80)
    else
        v_u_16[p46] = nil
    end
    local v50, v51, v52
    -- GenericForInit
v50, v51, v52 = pairs(v_u_16)
[internal control] = v52
-- end GenericForInit
    local v53, v54
    -- GenericForNext
v53, v54 = v50(v51, [internal control])
if v53 ~= nil
[internal control] = v53
-- end GenericForNext
    -- block 2
    goto l8
    ::l4::
    v54 = nil
    goto l8
    -- block 7
    goto l4
    ::l8::
    if v54 ~= nil then
        v_u_25:reset(v54)
    end
    return
end
function v_u_1.isFOVLocked() -- name: isFOVLocked
    -- upvalues: (copy) v_u_16
    return next(v_u_16) ~= nil
end
function v_u_1.setMouseEnabled(p55) -- name: setMouseEnabled
    -- upvalues: (ref) v_u_17, (copy) v_u_15, (copy) UserInputService, (copy) MainGui
    v_u_17 = p55
    if next(v_u_15) == nil then
        UserInputService.MouseBehavior = p55 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = p55
        MainGui.CameraPerspective.Visible = p55
    end
end
function v_u_1.setForceLockOverride(p56, p57) -- name: setForceLockOverride
    -- upvalues: (copy) v_u_15, (copy) UserInputService, (copy) MainGui
    if p57 then
        v_u_15[p56] = true
    else
        v_u_15[p56] = nil
    end
    if next(v_u_15) ~= nil then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        MainGui.CameraPerspective.Visible = true
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false
        MainGui.CameraPerspective.Visible = false
    end
end
function v_u_1.resetForceLockOverride() -- name: resetForceLockOverride
    -- upvalues: (copy) v_u_15, (ref) v_u_17, (copy) UserInputService, (copy) MainGui
    table.clear(v_u_15)
    v_u_17 = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    UserInputService.MouseIconEnabled = false
    MainGui.CameraPerspective.Visible = false
end
function v_u_1.isForceLockOverrideActive() -- name: isForceLockOverrideActive
    -- upvalues: (copy) v_u_15
    return next(v_u_15) ~= nil
end
function v_u_1.SetEnabled(p58) -- name: SetEnabled
    -- upvalues: (ref) v_u_12, (ref) v_u_24
    v_u_12 = p58
    if not p58 then
        v_u_24 = nil
    end
end
function v_u_1.IsEnabled() -- name: IsEnabled
    -- upvalues: (ref) v_u_12
    return v_u_12
end
function v_u_1.setPerspective(p59, p60) -- name: setPerspective
    -- upvalues: (copy) v_u_1, (copy) LocalPlayer
    local v61 = p59 and 0 or 5
    v_u_1.setMouseEnabled(p60)
    LocalPlayer.CameraMaxZoomDistance = v61
    LocalPlayer.CameraMinZoomDistance = v61
    LocalPlayer.CameraMode = p59 and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic
end
function v_u_1.toWeaponFirePosition() -- name: toWeaponFirePosition
    -- upvalues: (ref) v_u_24, (copy) v_u_30, (copy) v_u_31, (copy) CurrentCamera, (copy) v_u_1, (copy) v_u_45
    if v_u_24 then
        v_u_30:reset(Vector3.new(0, 0, 0))
        v_u_31:reset(Vector3.new(0, 0, 0))
        CurrentCamera.CFrame = v_u_24
        v_u_1.updateCamera((v_u_45(1)))
    end
end
function v_u_1.weaponKick(p62, p63) -- name: weaponKick
    -- upvalues: (copy) v_u_30, (copy) v_u_31, (copy) v_u_1
    v_u_30:setDampingRatio(p62.Damper)
    v_u_30:setFrequency(p62.Speed)
    v_u_30:setPosition(p62.Value * 0.017453292519943295 * 1)
    v_u_31:setDampingRatio(p63.Damper)
    v_u_31:setFrequency(p63.Speed)
    v_u_31:setPosition(p63.Value * 1)
    v_u_1.updateCamera()
end
function v_u_1.setWeaponRecoil(p64, p65) -- name: setWeaponRecoil
    -- upvalues: (copy) v_u_32, (ref) v_u_13
    v_u_32:setDampingRatio(p64.Damper)
    v_u_32:setFrequency(p64.Speed)
    v_u_32:setGoal(p64.Value)
    v_u_13 = p65
end
function v_u_1.getWeaponRecoil() -- name: getWeaponRecoil
    -- upvalues: (copy) v_u_32
    return v_u_32:getPosition()
end
require(ReplicatedStorage.Database.Security.Router).observerRouter("CameraControllerGetWeaponRecoil", function()
    -- upvalues: (copy) v_u_1
    return v_u_1.getWeaponRecoil()
end)
function v_u_1.flinch(_, p66) -- name: flinch
    -- upvalues: (copy) v_u_29
    v_u_29:impulse(Vector3.new(30, 0, 0) * (p66 and 2 or 1))
end
function v_u_1.BombExploded() -- name: BombExploded
    -- upvalues: (copy) v_u_16, (copy) v_u_27, (copy) v_u_28, (copy) v_u_25
    -- failed to decompile
end
function v_u_1.updateCamera() -- name: updateCamera
    -- upvalues: (copy) v_u_16, (copy) v_u_25, (copy) CurrentCamera, (copy) m_Constants, (ref) v_u_18, (ref) v_u_19, (ref) v_u_21, (copy) ReplicatedStorage, (ref) v_u_22, (copy) UserInputService, (ref) v_u_23, (copy) v_u_36, (copy) v_u_45, (copy) LocalPlayer
    -- failed to decompile
end
function v_u_1.StateChanged(p67, p68) -- name: StateChanged
    -- upvalues: (ref) v_u_14, (copy) v_u_26
    if tick() - v_u_14 >= 0.3 then
        if p67 == Enum.HumanoidStateType.Freefall and p68 == Enum.HumanoidStateType.Landed then
            v_u_14 = tick()
            v_u_26:setFrequency(25)
            v_u_26:impulse(Vector3.new(-0.2, 0, 0))
            task.delay(0.2, function()
                -- upvalues: (ref) v_u_26
                v_u_26:setFrequency(15)
                v_u_26:impulse(Vector3.new(0.05, 0, 0))
            end)
        end
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) ReplicatedStorage, (ref) v_u_21, (copy) m_RunServiceController, (copy) v_u_27, (copy) v_u_28, (copy) v_u_30, (copy) v_u_31, (copy) v_u_29, (copy) v_u_32, (copy) v_u_25, (copy) v_u_26, (ref) v_u_12, (copy) CurrentCamera, (copy) LocalPlayer, (ref) v_u_24, (copy) v_u_45, (copy) v_u_1, (copy) v_u_15, (ref) v_u_17, (copy) UserInputService, (copy) MainGui
    local v69, v70 = pcall(function()
        -- upvalues: (ref) ReplicatedStorage
        return require(ReplicatedStorage.Controllers.AimAssistController)
    end)
    if v69 and (v70 and v70.Initialize) then
        v_u_21 = v70
        v70.Initialize()
    end
    m_RunServiceController.BindToStepped("CameraController.UpdateSprings", function(_, p71)
        -- upvalues: (ref) v_u_27, (ref) v_u_28, (ref) v_u_30, (ref) v_u_31, (ref) v_u_29, (ref) v_u_32, (ref) v_u_25, (ref) v_u_26
        v_u_27:update(p71)
        v_u_28:update(p71)
        v_u_30:update(p71)
        v_u_31:update(p71)
        v_u_29:update(p71)
        v_u_32:update(p71)
        v_u_25:update(p71)
        v_u_26:update(p71)
    end)
    m_RunServiceController.BindToRenderStep("CameraController.UpdateCamera", Enum.RenderPriority.Camera.Value + 1, function(p72)
        -- upvalues: (ref) v_u_12, (ref) CurrentCamera, (ref) v_u_21, (ref) LocalPlayer, (ref) v_u_24, (ref) v_u_45, (ref) v_u_1, (ref) v_u_15, (ref) v_u_17, (ref) UserInputService, (ref) MainGui
        if v_u_12 then
            local CFrame = CurrentCamera.CFrame
            if v_u_21 and v_u_21.GetMagnetismRotation then
                local v74 = v_u_21.GetMagnetismRotation(p72)
                if v74.Magnitude > 0.001 and (v74.X == v74.X and v74.Y == v74.Y) then
                    local v75 = v74.X
                    if math.abs(v75) < 3.141592653589793 then
                        local v76 = v74.Y
                        if math.abs(v76) < 3.141592653589793 then
                            local Character = LocalPlayer.Character
                            local v78
                            if Character and Character:FindFirstChild("HumanoidRootPart") then
                                v78 = Character.HumanoidRootPart.Position
                            else
                                v78 = CFrame.Position
                            end
                            local v79 = CFrame.Position - v78
                            local v80 = v74.Y
                            local v81 = math.clamp(v80, -0.08726646259971647, 0.08726646259971647)
                            local v82 = v74.X
                            local v83 = math.clamp(v82, -0.08726646259971647, 0.08726646259971647)
                            local v84 = CFrame.Angles(0, v83, 0)
                            local v85 = CFrame.fromAxisAngle(CFrame.RightVector, v81) * v84
                            local v86 = v78 + v85:VectorToWorldSpace(v79)
                            local Rotation = v85 * CFrame.Rotation
                            CFrame = CFrame.new(v86) * Rotation
                        end
                    end
                end
            end
            v_u_24 = CFrame
            local v88 = v_u_45()
            v_u_1.updateCamera(v88)
            local v89 = next(v_u_15) ~= nil and true or v_u_17
            local v90
            if v89 then
                v90 = Enum.MouseBehavior.Default
            else
                v90 = Enum.MouseBehavior.LockCenter
            end
            if UserInputService.MouseBehavior ~= v90 then
                UserInputService.MouseBehavior = v90
            end
            if UserInputService.MouseIconEnabled ~= v89 then
                UserInputService.MouseIconEnabled = v89
            end
            if MainGui.CameraPerspective.Visible ~= v89 then
                MainGui.CameraPerspective.Visible = v89
            end
        end
    end)
    m_RunServiceController.BindToRenderStep("CameraController.ResetCameraShake", Enum.RenderPriority.Camera.Value - 1, function()
        -- upvalues: (ref) v_u_12, (ref) v_u_24, (ref) CurrentCamera
        if v_u_12 then
            if v_u_24 then
                CurrentCamera.CFrame = v_u_24
            end
        else
            return
        end
    end)
    UserInputService.TextBoxFocused:Connect(function()
        -- upvalues: (ref) v_u_1
        v_u_1.setForceLockOverride("TextBox", true)
    end)
    UserInputService.TextBoxFocusReleased:Connect(function()
        -- upvalues: (ref) UserInputService, (ref) v_u_1
        task.defer(function()
            -- upvalues: (ref) UserInputService, (ref) v_u_1
            local v91 = UserInputService:GetFocusedTextBox() ~= nil
            v_u_1.setForceLockOverride("TextBox", v91)
        end)
    end)
    local v92 = UserInputService:GetFocusedTextBox() ~= nil
    v_u_1.setForceLockOverride("TextBox", v92)
    m_RunServiceController.BindToRenderStep("CameraController.AspectRatioStretch", Enum.RenderPriority.Camera.Value + 2, function()
        -- upvalues: (ref) v_u_12
        if not v_u_12 then
        end
    end)
    local v93 = LocalPlayer:GetAttribute("Team")
    local v94 = v93 == "Counter-Terrorists" and true or v93 == "Terrorists"
    if LocalPlayer.Character == nil and not v94 then
        v_u_1.setForceLockOverride("InitialMenu", true)
    end
end
function v_u_1.Start() -- name: Start
    -- upvalues: (copy) ReplicatedStorage, (copy) LocalPlayer, (copy) v_u_1, (copy) m_Constants, (copy) m_DataController, (ref) v_u_18, (ref) v_u_23, (copy) v_u_36, (ref) v_u_19
    local m_CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
    LocalPlayer.CharacterAdded:Connect(function(p96)
        -- upvalues: (copy) m_CaseSceneController, (ref) v_u_1, (ref) m_Constants
        if not m_CaseSceneController.IsActive() then
            v_u_1.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
        end
        p96:GetAttributeChangedSignal("Dead"):Once(function()
            -- upvalues: (ref) m_CaseSceneController, (ref) v_u_1, (ref) m_Constants
            if not m_CaseSceneController.IsActive() then
                v_u_1.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
            end
        end)
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Mouse Sensitivity", function(p97)
        -- upvalues: (ref) v_u_18, (ref) v_u_23, (ref) v_u_36
        v_u_18 = math.clamp(p97 or 1, 0.1, 10)
        local v98 = v_u_18
        if v_u_23 then
            local v99 = v_u_23 - v98
            if math.abs(v99) <= 0.0001 then
                return
            end
        end
        local v100 = v_u_36()
        if v100 and v100.setTouchSensitivity then
            v_u_23 = v98
            v100.setTouchSensitivity(v98)
        end
    end)
    local v101 = v_u_18
    if v_u_23 then
        local v102 = v_u_23 - v101
        if math.abs(v102) <= 0.0001 then
            ::l4::
            m_DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Zoom Sensitivity Multiplier", function(p103)
                -- upvalues: (ref) v_u_19
                v_u_19 = math.clamp(p103 or 0.5, 0.1, 5)
            end)
            return
        end
    end
    local v104 = v_u_36()
    if v104 and v104.setTouchSensitivity then
        v_u_23 = v101
        v104.setTouchSensitivity(v101)
    end
    goto l4
end
function v_u_1.clampFOV(p105) -- name: clampFOV
    return math.clamp(p105, 1, 80)
end
return v_u_1
