-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local LocalPlayer = Players.LocalPlayer
local m_WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
require(ReplicatedStorage.Classes.Sound)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local CurrentCamera = workspace.CurrentCamera
local Debris = workspace:WaitForChild("Debris")
local v_u_13 = nil
local v_u_14 = RaycastParams.new()
v_u_14.FilterType = Enum.RaycastFilterType.Exclude
v_u_14.IgnoreWater = true
local function v_u_27() -- name: PlayerCanPlantC4
    -- upvalues: (copy) LocalPlayer, (copy) CurrentCamera, (copy) Debris, (copy) Players, (copy) v_u_14
    local Character = LocalPlayer.Character
    local v16
    if Character and Character:IsDescendantOf(workspace) then
        local Humanoid = Character:FindFirstChild("Humanoid")
        v16 = Humanoid and Humanoid.Health > 0 and true or false
    else
        v16 = false
    end
    if v16 then
        local Humanoid_0 = Character:FindFirstChild("Humanoid")
        if Humanoid_0 then
            local v19 = Humanoid_0:GetState()
            if v19 == Enum.HumanoidStateType.Freefall or v19 == Enum.HumanoidStateType.Jumping then
                return false
            end
        end
        local PrimaryPart = Character.PrimaryPart
        if PrimaryPart and PrimaryPart.Position then
            local v21 = { CurrentCamera, Debris }
            for _, v22 in ipairs(Players:GetPlayers()) do
                if v22.Character then
                    local Character_0 = v22.Character
                    table.insert(v21, Character_0)
                end
            end
            v_u_14.FilterDescendantsInstances = v21
            local Position = PrimaryPart.Position
            local v25 = workspace:Raycast(Position, Vector3.new(-0, -5, -0), v_u_14)
            if v25 then
                local Instance = v25.Instance
                if Instance:HasTag("PlantArea") and Instance:GetAttribute("Site") then
                    return true
                end
            end
        end
    end
    return false
end
function v_u_1.stopAllAnimations(p28) -- name: stopAllAnimations
    if p28.CharacterAnimator then
        if p28.Viewmodel and p28.Viewmodel.Animation then
            for v29, v30 in pairs(p28.CharacterAnimator.Animations) do
                if v30.IsPlaying and v30.Name ~= "Idle" then
                    p28.CharacterAnimator:stop(v29)
                end
            end
            for v31, v32 in pairs(p28.Viewmodel.Animation.Animations) do
                if v32.IsPlaying and v32.Name ~= "Idle" then
                    p28.Viewmodel.Animation:stop(v31)
                end
            end
            p28.Viewmodel.Animation:stopSounds()
        end
    else
        return
    end
end
function v_u_1.reload(_) -- name: reload end
function v_u_1.shoot(p_u_33) -- name: shoot
    -- upvalues: (copy) v_u_27, (copy) m_Remotes, (copy) m_Router
    if not p_u_33.IsPlanting then
        if p_u_33.Janitor:Get("BombAnimationEnded") then
            p_u_33.Janitor:Remove("BombAnimationEnded")
        end
        if v_u_27() then
            p_u_33.IsInspecting = false
            p_u_33.IsPlanting = true
            p_u_33.PlantStartedTick = tick()
            p_u_33:stopAllAnimations()
            m_Remotes.Spectate.ReplicateSpectateEvent.Send("Use")
            local v34 = p_u_33.Viewmodel.Animation:play("Use")
            m_Remotes.Spectate.ReplicateSpectateEvent.Send("Use")
            p_u_33.CharacterAnimator:play("Use")
            m_Remotes.C4.Start.Send(p_u_33.Identifier)
            m_Router.broadcastRouter("Plant Bomb")
            p_u_33.Janitor:Add(v34.Ended:Connect(function()
                -- upvalues: (copy) p_u_33, (ref) v_u_27, (ref) m_Remotes, (ref) m_Router
                if p_u_33.IsPlanting then
                    if v_u_27() then
                        m_Remotes.C4.Planted.Send(p_u_33.Identifier)
                        p_u_33.IsPlanting = false
                    end
                    m_Router.broadcastRouter("Cancel Bomb Plant")
                end
            end), "Disconnect", "BombAnimationEnded")
        end
    end
end
function v_u_1.cancel(p35) -- name: cancel
    -- upvalues: (copy) m_Remotes, (copy) m_Router
    if p35.IsPlanting then
        p35.Viewmodel.Model.Weapon.Interactive.SurfaceGui.TextLabel.Text = "*******"
        p35.IsPlanting = false
        p35:stopAllAnimations()
        m_Remotes.Spectate.ReplicateSpectateEvent.Send("Cancel Plant")
        m_Remotes.C4.Cancel.Send(p35.Identifier)
        m_Router.broadcastRouter("Cancel Bomb Plant")
        if p35.Janitor:Get("BombAnimationEnded") then
            p35.Janitor:Remove("BombAnimationEnded")
        end
    end
end
function v_u_1.inspect(p_u_36) -- name: inspect
    -- upvalues: (copy) m_Remotes
    if not (p_u_36.IsInspecting or p_u_36.IsPlanting) then
        p_u_36.IsInspecting = true
        p_u_36:stopAllAnimations()
        local v37 = p_u_36.Viewmodel.Animation:play("Inspect")
        m_Remotes.Spectate.ReplicateSpectateEvent.Send("Inspect")
        task.delay(v37.Length, function()
            -- upvalues: (copy) p_u_36
            p_u_36.IsInspecting = false
        end)
    end
end
function v_u_1.drop(p38) -- name: drop
    -- upvalues: (copy) m_GameState, (copy) m_Remotes, (copy) m_GetCharacterVelocity, (copy) LocalPlayer, (copy) CurrentCamera
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false
    end
    if m_GameState.GetState() == "Warmup" then
        return false
    end
    if p38.IsPlanting then
        return false
    end
    if not p38.Properties.Droppable then
        return false
    end
    p38:unequip()
    m_Remotes.Inventory.DropWeapon.Send({
        ["CharacterVelocity"] = m_GetCharacterVelocity(LocalPlayer.Character),
        ["Direction"] = CurrentCamera.CFrame.LookVector,
        ["Identifier"] = p38.Identifier
    })
    return true
end
function v_u_1.equip(p39) -- name: equip
    -- upvalues: (ref) v_u_13
    p39.Viewmodel.Animation:stopAnimations()
    p39.CharacterAnimator:stopAnimations()
    p39.CharacterAnimator:play("Idle")
    p39.CharacterAnimator:play("Equip")
    p39.Viewmodel:equip(false)
    v_u_13 = p39
end
function v_u_1.unequip(p40) -- name: unequip
    -- upvalues: (ref) v_u_13
    if p40.IsPlanting then
        p40:cancel()
    end
    p40.CharacterAnimator:stopAnimations()
    p40.Viewmodel:unequip()
    if v_u_13 and v_u_13 == p40 then
        v_u_13 = nil
    end
end
function v_u_1.new(p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52, _) -- name: new
    -- upvalues: (copy) m_WeaponComponent, (copy) v_u_1, (copy) m_RunServiceController, (copy) v_u_27
    local v53 = m_WeaponComponent.new(p41, p42, p43, p44, p45, p46, p47, p48, p49, p50, p51, p52)
    local v54 = v_u_1
    local v_u_55 = setmetatable(v53, v54)
    v_u_55.IsInspecting = false
    v_u_55.IsPlanting = false
    v_u_55.PlantStartedTick = 0
    v_u_55.Janitor:Add(m_RunServiceController.BindToHeartbeat(("Components.C4.%*.PlantValidation"):format(p42), function(_)
        -- upvalues: (copy) v_u_55, (ref) v_u_27
        if v_u_55.IsPlanting and not v_u_27() then
            v_u_55:cancel()
        end
    end))
    return v_u_55
end
function v_u_1.destroy(p56) -- name: destroy
    -- upvalues: (ref) v_u_13, (copy) m_WeaponComponent
    if not p56.IsDestroyed then
        p56.IsDestroyed = true
        if p56.IsPlanting then
            p56:cancel()
        end
        if v_u_13 and v_u_13 == p56 then
            v_u_13 = nil
        end
        if p56.Janitor then
            p56.Janitor:Destroy()
            p56.Janitor = nil
        end
        p56.PlantStartedTick = nil
        p56.IsInspecting = nil
        p56.IsPlanting = nil
        m_WeaponComponent.destroy(p56)
    end
end
m_Remotes.C4.ForceCancel.Listen(function()
    -- upvalues: (ref) v_u_13
    if v_u_13 and v_u_13.IsPlanting then
        v_u_13:cancel()
    end
end)
return v_u_1
