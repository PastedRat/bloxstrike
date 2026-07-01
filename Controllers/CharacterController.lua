-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local m_Character = require(ReplicatedStorage.Classes.Character)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
local m_CharacterKinematics = require(ReplicatedStorage.Controllers.Observers.Character.Components.CharacterKinematics)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local LocalPlayer = Players.LocalPlayer
local m_PlayerModule = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))
local CurrentCamera = workspace.CurrentCamera
local v_u_16 = nil
local v_u_17 = nil
local v_u_18 = nil
local v_u_19 = nil
local v_u_20 = nil
local v_u_21 = false
local function v_u_24() -- name: recoverCharacterControllerIfDesynced
    -- upvalues: (ref) v_u_16, (copy) LocalPlayer, (copy) v_u_1
    if v_u_16 then
        return
    else
        local Character = LocalPlayer.Character
        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            if Humanoid and Humanoid.Health > 0 then
                if Character:GetAttribute("Dead") ~= true then
                    v_u_1.characterAdded(Character)
                end
            else
                return
            end
        else
            return
        end
    end
end
function v_u_1.getCurrentCharacter() -- name: getCurrentCharacter
    -- upvalues: (ref) v_u_16
    return v_u_16
end
function v_u_1.GetWalkState() -- name: GetWalkState
    -- upvalues: (ref) v_u_16
    local IsWalking = v_u_16
    if IsWalking then
        IsWalking = v_u_16.IsWalking
    end
    return IsWalking
end
function v_u_1.GetCrouchState() -- name: GetCrouchState
    -- upvalues: (ref) v_u_16
    local IsCrouching = v_u_16
    if IsCrouching then
        IsCrouching = v_u_16.IsCrouching
    end
    return IsCrouching
end
function v_u_1.walk(p27) -- name: walk
    -- upvalues: (ref) v_u_16
    if v_u_16 then
        v_u_16:ToggleWalkState(p27)
    end
end
function v_u_1.crouch(p28) -- name: crouch
    -- upvalues: (ref) v_u_16
    if v_u_16 then
        v_u_16:ToggleCrouchInput(p28)
    end
end
function v_u_1.PlantBomb() -- name: PlantBomb
    -- upvalues: (ref) v_u_16
    if v_u_16 then
        v_u_16:PlantBomb()
    end
end
function v_u_1.CancelBombPlant() -- name: CancelBombPlant
    -- upvalues: (ref) v_u_16
    if v_u_16 then
        v_u_16:CancelBombPlant()
    end
end
function v_u_1.jump() -- name: jump
    -- upvalues: (ref) v_u_16, (copy) LocalPlayer
    if v_u_16 then
        v_u_16.IsJumpRequested = true
        v_u_16:Jump()
    else
        local Character_0 = LocalPlayer.Character
        if Character_0 then
            local Humanoid_0 = Character_0:FindFirstChildOfClass("Humanoid")
            if Humanoid_0 and Humanoid_0.Health > 0 then
                Humanoid_0.Jump = true
            end
        end
    end
end
function v_u_1.characterAdded(p_u_31) -- name: characterAdded
    -- upvalues: (ref) v_u_16, (copy) m_CaseSceneController, (copy) m_PlayerModule, (copy) CurrentCamera, (copy) LocalPlayer, (ref) v_u_19, (ref) v_u_17, (ref) v_u_20, (ref) v_u_18, (ref) v_u_21, (copy) m_Character, (copy) m_InventoryController, (copy) m_Remotes
    if v_u_16 then
        v_u_16:Destroy()
        v_u_16 = nil
    end
    local v32 = m_CaseSceneController.IsActive()
    local HumanoidRootPart = p_u_31:WaitForChild("HumanoidRootPart", 20)
    local Humanoid_1 = p_u_31:FindFirstChildOfClass("Humanoid")
    if not Humanoid_1 then
        local v35 = tick()
        repeat
            task.wait(0.1)
            Humanoid_1 = p_u_31:FindFirstChildOfClass("Humanoid")
        until Humanoid_1 or tick() - v35 > 20
    end
    if p_u_31:IsDescendantOf(workspace) and Humanoid_1 then
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        local activeController = m_PlayerModule:GetControls()
        if activeController then
            activeController = activeController.activeController
        end
        if activeController then
            activeController.moveVector = Vector3.new(0, 0, 0)
            activeController.backwardValue = 0
            activeController.forwardValue = 0
            activeController.rightValue = 0
            activeController.leftValue = 0
        end
        if not v32 then
            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.CameraSubject = p_u_31.Humanoid
        end
        LocalPlayer.ReplicationFocus = p_u_31.Humanoid
        if v_u_19 then
            v_u_19()
            v_u_19 = nil
        end
        if v_u_17 then
            v_u_17:Disconnect()
            v_u_17 = nil
        end
        if v_u_20 then
            v_u_20()
            v_u_20 = nil
        end
        if v_u_18 then
            v_u_18:Disconnect()
            v_u_18 = nil
        end
        v_u_21 = false
        v_u_16 = m_Character.new(p_u_31, HumanoidRootPart, Humanoid_1)
        local function v_u_37() -- name: handleDeath
            -- upvalues: (ref) v_u_21, (ref) v_u_16, (ref) m_InventoryController, (ref) v_u_19, (ref) v_u_17, (ref) v_u_20, (ref) v_u_18
            if not v_u_21 then
                v_u_21 = true
                if v_u_16 then
                    v_u_16:Destroy()
                    v_u_16 = nil
                end
                m_InventoryController.CleanupCurrentLoadout()
                if v_u_19 then
                    v_u_19()
                    v_u_19 = nil
                end
                if v_u_17 then
                    v_u_17:Disconnect()
                    v_u_17 = nil
                end
                if v_u_20 then
                    v_u_20()
                    v_u_20 = nil
                end
                if v_u_18 then
                    v_u_18:Disconnect()
                    v_u_18 = nil
                end
            end
        end
        v_u_19 = m_Remotes.Character.CharacterDied.Listen(function()
            -- upvalues: (ref) LocalPlayer, (copy) p_u_31, (copy) v_u_37
            if LocalPlayer.Character == p_u_31 then
                if p_u_31:GetAttribute("Dead") ~= true then
                    local Humanoid_2 = p_u_31:FindFirstChildOfClass("Humanoid")
                    if Humanoid_2 and Humanoid_2.Health > 0 then
                        return
                    end
                end
                v_u_37()
            end
        end)
        v_u_17 = p_u_31:GetAttributeChangedSignal("Dead"):Connect(function()
            -- upvalues: (copy) p_u_31, (copy) v_u_37
            if p_u_31:GetAttribute("Dead") then
                v_u_37()
            end
        end)
        v_u_20 = m_Remotes.UI.UIPlayerKilled.Listen(function(p39)
            -- upvalues: (ref) LocalPlayer, (copy) p_u_31, (copy) v_u_37
            if p39 then
                local Victim = p39.Victim
                local UserId = LocalPlayer.UserId
                if Victim == tostring(UserId) and LocalPlayer.Character == p_u_31 then
                    v_u_37()
                    return
                end
            end
        end)
        v_u_18 = Humanoid_1.HealthChanged:Connect(function(p42)
            -- upvalues: (copy) v_u_37
            if p42 <= 0 then
                v_u_37()
            end
        end)
        if p_u_31:GetAttribute("Dead") or Humanoid_1.Health <= 0 then
            v_u_37()
        end
    else
        return
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) LocalPlayer, (copy) v_u_1, (ref) v_u_16, (ref) v_u_19, (ref) v_u_17, (ref) v_u_20, (ref) v_u_18, (ref) v_u_21, (copy) m_GameState, (copy) v_u_24, (copy) m_Remotes, (copy) m_Sound, (copy) m_CameraController, (copy) m_CharacterKinematics
    LocalPlayer.CharacterAdded:Connect(function(p43)
        -- upvalues: (ref) v_u_1
        v_u_1.characterAdded(p43)
    end)
    LocalPlayer.CharacterRemoving:Connect(function()
        -- upvalues: (ref) v_u_16, (ref) v_u_19, (ref) v_u_17, (ref) v_u_20, (ref) v_u_18, (ref) v_u_21
        if v_u_16 then
            v_u_16:Destroy()
            v_u_16 = nil
        end
        if v_u_19 then
            v_u_19()
            v_u_19 = nil
        end
        if v_u_17 then
            v_u_17:Disconnect()
            v_u_17 = nil
        end
        if v_u_20 then
            v_u_20()
            v_u_20 = nil
        end
        if v_u_18 then
            v_u_18:Disconnect()
            v_u_18 = nil
        end
        v_u_21 = false
    end)
    m_GameState.ListenToState(function(_, p44)
        -- upvalues: (ref) v_u_24
        if p44 == "Buy Period" or p44 == "Round In Progress" then
            v_u_24()
        end
    end)
    m_Remotes.Character.CharacterDamaged.Listen(function()
        -- upvalues: (ref) v_u_16, (ref) m_Sound, (ref) LocalPlayer
        if v_u_16 then
            v_u_16.CharacterAnimator:play("Damaged")
            m_Sound.new("Character"):playOneTime({
                ["Parent"] = nil,
                ["Name"] = "Character Damaged",
                ["Parent"] = LocalPlayer.PlayerGui
            })
        end
    end)
    m_Remotes.Character.CharacterFlinch.Listen(function(p45)
        -- upvalues: (ref) m_CameraController
        m_CameraController.flinch(p45.Damage, p45.Headshot)
    end)
    m_Remotes.Character.ShotSlow.Listen(function(p46)
        -- upvalues: (ref) v_u_16
        if v_u_16 then
            v_u_16.ShotSlowUntil = tick() + p46.Duration
            v_u_16.ShotSlowMultiplier = p46.Multiplier
        end
    end)
    m_Remotes.Character.ReplicateLookAngle.Listen(function(p47)
        -- upvalues: (ref) m_CharacterKinematics
        local Player = p47.Player
        local HorizontalAngle = p47.HorizontalAngle
        local VerticalLook = p47.VerticalLook
        if Player and (HorizontalAngle == HorizontalAngle and VerticalLook == VerticalLook) then
            m_CharacterKinematics.setTargetRotation(Player, HorizontalAngle)
            m_CharacterKinematics.setVerticalLook(Player, VerticalLook)
        end
    end)
end
function v_u_1.Start() -- name: Start
    -- upvalues: (copy) m_Router, (copy) v_u_1
    m_Router.observerRouter("Plant Bomb", function()
        -- upvalues: (ref) v_u_1
        v_u_1.PlantBomb()
    end)
    m_Router.observerRouter("Cancel Bomb Plant", function()
        -- upvalues: (ref) v_u_1
        v_u_1.CancelBombPlant()
    end)
    m_Router.observerRouter("GetCurrentCharacter", function()
        -- upvalues: (ref) v_u_1
        return v_u_1.getCurrentCharacter()
    end)
end
return v_u_1
