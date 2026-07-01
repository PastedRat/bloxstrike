-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local m_HapticsController = require(ReplicatedStorage.Controllers.HapticsController)
local m_SoundController = require(ReplicatedStorage.Controllers.SoundController)
local m_InputController = require(ReplicatedStorage.Controllers.InputController)
local m_GetRayIgnore = require(ReplicatedStorage.Components.Common.GetRayIgnore)
local m_GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker)
local m_CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact)
local m_BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass)
local m_WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
local function v_u_25(p19, p20) -- name: isBackStab
    local HumanoidRootPart = p19:WaitForChild("HumanoidRootPart")
    local HumanoidRootPart_0 = p20:WaitForChild("HumanoidRootPart")
    if not (HumanoidRootPart and HumanoidRootPart_0) then
        return nil
    end
    local v23 = HumanoidRootPart_0.CFrame.LookVector:Dot((HumanoidRootPart.Position - HumanoidRootPart_0.Position).Unit)
    local v24 = math.acos(v23)
    return math.deg(v24) > 100
end
function v_u_1.stopAllAnimations(p26) -- name: stopAllAnimations
    if p26.CharacterAnimator then
        if p26.Viewmodel and p26.Viewmodel.Animation then
            p26.Viewmodel.Animation:cancelCrossfade()
            for v27, v28 in pairs(p26.CharacterAnimator.Animations) do
                if v28.IsPlaying and v28.Name ~= "Idle" then
                    p26.CharacterAnimator:stop(v27)
                end
            end
            for v29, v30 in pairs(p26.Viewmodel.Animation.Animations) do
                if v30.IsPlaying and v30.Name ~= "Idle" then
                    p26.Viewmodel.Animation:stop(v29)
                end
            end
        end
    else
        return
    end
end
function v_u_1.reload(p31) -- name: reload
    if p31.IsInspecting or p31.IsInspectFadingOut then
        p31:cancelInspect(0.25)
    end
end
function v_u_1.shoot(p_u_32, p33) -- name: shoot
    -- upvalues: (copy) LocalPlayer, (copy) m_Router, (copy) m_SoundController, (copy) m_GetRayIgnore, (copy) CurrentCamera, (copy) m_Remotes, (copy) m_CreateImpact, (copy) v_u_25, (copy) m_BreakGlass, (copy) m_CreateMarker, (copy) m_HapticsController, (copy) HttpService, (copy) m_InputController
    if tick() - p_u_32.WeaponEquippedTick <= 1 or LocalPlayer:GetAttribute("Dead") then
        return
    elseif p_u_32.Properties.FireRate then
        if p_u_32.IsShooting then
            return
        else
            local v34 = p_u_32.Player
            if v34 then
                v34 = p_u_32.Player.Character
            end
            if v34 then
                if p_u_32.IsInspecting or p_u_32.IsInspectFadingOut then
                    p_u_32:cancelInspect(0.25)
                end
                p_u_32:stopAllAnimations()
                p_u_32.IsInspecting = false
                p_u_32.IsInspectFadingOut = false
                p_u_32.IsShooting = true
                m_Router.broadcastRouter("UpdatePlayerNoiseCone", "Melee", v34.PrimaryPart.Position, m_SoundController.GetMeleeRange(p_u_32.Name), nil)
                local v35 = RaycastParams.new()
                v35.FilterType = Enum.RaycastFilterType.Exclude
                v35.FilterDescendantsInstances = m_GetRayIgnore()
                v35.IgnoreWater = true
                local Range = CurrentCamera.CFrame.LookVector * p_u_32.Properties.Range
                local Position = CurrentCamera.CFrame.Position
                local v38 = workspace:Raycast(Position, Range, v35) or workspace:Spherecast(Position, 1.5, Range, v35)
                local v39 = p33 and "Heavy Swing" or ("Swing%*"):format((math.random(1, 2)))
                m_Remotes.Spectate.ReplicateSpectateEvent.Send(v39)
                if v38 then
                    local Instance = v38.Instance
                    local Position_0 = v38.Position
                    local Material = v38.Material
                    local Normal = v38.Normal
                    local v44 = Instance and Instance.Parent
                    if v44 then
                        v44 = Instance.Parent:FindFirstChildOfClass("Humanoid")
                    end
                    if v44 then
                        m_CreateImpact(Instance, "Blood Splatter", Position_0, Normal, false, true, true)
                        v39 = p33 and v_u_25(LocalPlayer.Character, Instance.Parent) and "BackStab" or v39
                    else
                        local Parent = Instance.Parent
                        m_CreateImpact(Instance, Material.Name, Position_0, Normal, false, true, true)
                        if Parent and Parent:HasTag("BreakableGlass") then
                            m_BreakGlass(Instance, Position_0, Range.Unit)
                        elseif not (Instance:HasTag("BreakableGlass") or Parent and Parent:HasTag("BreakableGlass")) then
                            m_CreateMarker(Instance, "Melee", Position_0, Normal)
                        end
                    end
                    m_Remotes.Melee.MeleeAttack.Send({
                        ["Direction"] = CurrentCamera.CFrame.LookVector * p_u_32.Properties.Range,
                        ["Material"] = v38.Material.Name,
                        ["Distance"] = v38.Distance,
                        ["Instance"] = v38.Instance,
                        ["Position"] = v38.Position,
                        ["Normal"] = v38.Normal,
                        ["MeleeAttack"] = v39,
                        ["Identifier"] = p_u_32.Identifier
                    })
                end
                local v46 = p_u_32.Viewmodel.Animation:play(v39)
                local v47 = (v39 == "Swing1" or v39 == "Swing") and "Swing" or v39
                local v48 = p_u_32.Properties.FireRate * (p33 and 2.05 or 1)
                m_HapticsController.vibrate(Enum.VibrationMotor.Small, 1.15, 0.2)
                p_u_32.CharacterAnimator:play(v47)
                local v49 = v48 or (v46 and v46.Length or 0.3)
                task.delay(v49, function()
                    -- upvalues: (copy) p_u_32, (ref) HttpService, (ref) LocalPlayer, (ref) m_InputController
                    if not p_u_32.IsDestroyed then
                        p_u_32.IsShooting = false
                        if p_u_32.Identifier ~= HttpService:JSONDecode(LocalPlayer:GetAttribute("CurrentEquipped") or "[]").Identifier then
                            return
                        end
                        local IsFireHeld = m_InputController.isActionPressed("Fire", { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }) or p_u_32.IsFireHeld
                        local v51 = m_InputController.isActionPressed("Secondary Fire", { Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2 })
                        if IsFireHeld or v51 then
                            p_u_32:shoot(v51)
                            return
                        end
                    end
                end)
            end
        end
    else
        return
    end
end
function v_u_1.cancelInspect(p_u_52, p53, p54) -- name: cancelInspect
    if p_u_52.IsInspecting or p_u_52.IsInspectFadingOut then
        if p_u_52.InspectDelayThread then
            task.cancel(p_u_52.InspectDelayThread)
            p_u_52.InspectDelayThread = nil
        end
        local v55 = p54 or 0.3
        local v_u_56 = p53 or 1.2
        p_u_52.IsInspectFadingOut = true
        p_u_52.IsInspecting = false
        p_u_52.Viewmodel.Animation:markInspectCancel()
        if p_u_52.CancelDelayThread then
            task.cancel(p_u_52.CancelDelayThread)
            p_u_52.CancelDelayThread = nil
        end
        if p_u_52.FadeCompleteThread then
            task.cancel(p_u_52.FadeCompleteThread)
            p_u_52.FadeCompleteThread = nil
        end
        p_u_52.CancelDelayThread = task.delay(v55, function()
            -- upvalues: (copy) p_u_52, (copy) v_u_56
            if p_u_52.IsDestroyed then
                return
            elseif p_u_52.IsInspectFadingOut then
                p_u_52.Viewmodel.Animation:crossfadeTo("Idle", v_u_56)
                p_u_52.FadeCompleteThread = task.delay(v_u_56, function()
                    -- upvalues: (ref) p_u_52
                    if not p_u_52.IsDestroyed then
                        p_u_52.FadeCompleteThread = nil
                        p_u_52.IsInspectFadingOut = false
                    end
                end)
            end
        end)
    end
end
function v_u_1.inspect(p_u_57) -- name: inspect
    -- upvalues: (copy) m_Remotes
    if p_u_57.IsShooting then
        return
    elseif p_u_57.IsInspecting and not p_u_57.IsInspectFadingOut then
        return
    else
        local v58 = p_u_57.IsInspectFadingOut == true
        if v58 then
            p_u_57.IsInspectFadingOut = false
            if p_u_57.CancelDelayThread then
                task.cancel(p_u_57.CancelDelayThread)
                p_u_57.CancelDelayThread = nil
            end
            if p_u_57.FadeCompleteThread then
                task.cancel(p_u_57.FadeCompleteThread)
                p_u_57.FadeCompleteThread = nil
            end
            p_u_57.Viewmodel.Animation:cancelCrossfade()
        end
        p_u_57.IsInspecting = true
        p_u_57.IsShooting = false
        if p_u_57.InspectDelayThread then
            task.cancel(p_u_57.InspectDelayThread)
            p_u_57.InspectDelayThread = nil
        end
        local v59 = p_u_57.Viewmodel.Animation:pickInspectVariant()
        if v58 then
            if not p_u_57.Viewmodel.Animation:crossfadeRestart(v59, 0.25) then
                p_u_57:stopAllAnimations()
                p_u_57.Viewmodel.Animation:play(v59)
            end
            m_Remotes.Spectate.ReplicateSpectateEvent.Send(v59)
            local v60 = p_u_57.Viewmodel.Animation:getAnimation(v59)
            if v60 then
                p_u_57.InspectDelayThread = task.delay(v60.Length, function()
                    -- upvalues: (copy) p_u_57
                    if not p_u_57.IsDestroyed then
                        p_u_57.InspectDelayThread = nil
                        p_u_57.IsInspecting = false
                    end
                end)
            end
        else
            p_u_57:stopAllAnimations()
            local v61 = p_u_57.Viewmodel.Animation:play(v59)
            m_Remotes.Spectate.ReplicateSpectateEvent.Send(v59)
            p_u_57.InspectDelayThread = task.delay(v61.Length, function()
                -- upvalues: (copy) p_u_57
                if not p_u_57.IsDestroyed then
                    p_u_57.InspectDelayThread = nil
                    p_u_57.IsInspecting = false
                end
            end)
        end
    end
end
function v_u_1.drop(p62) -- name: drop
    -- upvalues: (copy) m_GameState, (copy) m_Remotes, (copy) m_GetCharacterVelocity, (copy) LocalPlayer, (copy) CurrentCamera
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false
    end
    if m_GameState.GetState() == "Warmup" then
        return false
    end
    if workspace:GetAttribute("VIPKnifeDropEnabled") ~= true then
        return false
    end
    p62:unequip()
    m_Remotes.Inventory.DropWeapon.Send({
        ["CharacterVelocity"] = m_GetCharacterVelocity(LocalPlayer.Character),
        ["Direction"] = CurrentCamera.CFrame.LookVector,
        ["Identifier"] = p62.Identifier
    })
    return true
end
function v_u_1.equip(p63) -- name: equip
    p63.Viewmodel.Animation:stopAnimations()
    p63.CharacterAnimator:stopAnimations()
    p63.CharacterAnimator:play("Idle")
    p63.CharacterAnimator:play("Equip")
    p63.WeaponEquippedTick = tick()
    p63.Viewmodel:equip(false)
    p63.IsInspectFadingOut = false
    p63.IsInspecting = false
    p63.IsShooting = false
    p63.IsFireHeld = false
end
function v_u_1.unequip(p64) -- name: unequip
    p64.CharacterAnimator:stopAnimations()
    p64.Viewmodel:unequip()
    p64.IsInspectFadingOut = false
    p64.IsInspecting = false
    p64.IsShooting = false
    p64.IsFireHeld = false
end
function v_u_1.new(p65, p66, p67, p68, p69, p70, p71, p72, p73, p74, p75, p76, _) -- name: new
    -- upvalues: (copy) m_WeaponComponent, (copy) v_u_1
    local v77 = m_WeaponComponent.new(p65, p66, p67, p68, p69, p70, p71, p72, p73, p74, p75, p76)
    local v78 = v_u_1
    local v79 = setmetatable(v77, v78)
    v79.IsInspectFadingOut = false
    v79.IsInspecting = false
    v79.IsShooting = false
    v79.IsFireHeld = false
    v79.InspectDelayThread = nil
    v79.CancelDelayThread = nil
    v79.FadeCompleteThread = nil
    v79.AlternativeSwitchTick = 0
    v79.WeaponEquippedTick = 0
    return v79
end
function v_u_1.destroy(p80) -- name: destroy
    -- upvalues: (copy) m_WeaponComponent
    if not p80.IsDestroyed then
        p80.IsDestroyed = true
        if p80.InspectDelayThread then
            task.cancel(p80.InspectDelayThread)
            p80.InspectDelayThread = nil
        end
        if p80.CancelDelayThread then
            task.cancel(p80.CancelDelayThread)
            p80.CancelDelayThread = nil
        end
        if p80.FadeCompleteThread then
            task.cancel(p80.FadeCompleteThread)
            p80.FadeCompleteThread = nil
        end
        if p80.Janitor then
            p80.Janitor:Destroy()
            p80.Janitor = nil
        end
        p80.IsInspectFadingOut = nil
        p80.IsInspecting = nil
        p80.IsShooting = nil
        p80.IsFireHeld = nil
        p80.AlternativeSwitchTick = nil
        p80.WeaponEquippedTick = nil
        m_WeaponComponent.destroy(p80)
    end
end
return v_u_1
