-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local m_WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = game:GetService("Players").LocalPlayer
function v_u_1.stopAllAnimations(p11) -- name: stopAllAnimations
    if p11.CharacterAnimator then
        if p11.Viewmodel and p11.Viewmodel.Animation then
            for v12, v13 in pairs(p11.CharacterAnimator.Animations) do
                if v13.IsPlaying and v13.Name ~= "Idle" then
                    p11.CharacterAnimator:stop(v12)
                end
            end
            for v14, v15 in pairs(p11.Viewmodel.Animation.Animations) do
                if v15.IsPlaying and v15.Name ~= "Idle" then
                    p11.Viewmodel.Animation:stop(v14)
                end
            end
        end
    else
        return
    end
end
function v_u_1.StartThrow(p16) -- name: StartThrow
    -- upvalues: (copy) m_GameState, (copy) LocalPlayer, (copy) CurrentCamera, (copy) m_Remotes
    if p16.IsDestroyed then
        return
    else
        local v17
        if workspace:GetAttribute("ServerGamemode") == "Competitive" then
            v17 = m_GameState.GetState() == "Buy Period"
        else
            v17 = false
        end
        if v17 then
            return
        elseif p16.EquipTime > 0 and tick() - p16.EquipTime < 0.7 then
            return
        else
            local v18 = tick()
            if p16.LastThrowTime > 0 and v18 - p16.LastThrowTime < 0.7 then
                return
            elseif p16.ThrowStarted and not p16.ThrowFinished then
                return
            else
                if p16.ThrowFinished then
                    p16.ThrowFinished = false
                    p16.ThrowStarted = false
                    if p16.Janitor:Get("ThrowGrenadeFinished") then
                        p16.Janitor:Remove("ThrowGrenadeFinished")
                    end
                    if p16.Janitor:Get("ThrowGrenadeStoppedFallback") then
                        p16.Janitor:Remove("ThrowGrenadeStoppedFallback")
                    end
                end
                local v19 = tick()
                if p16.LastThrowTime > 0 and v19 - p16.LastThrowTime < 0.7 then
                    return
                elseif LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Dead")) then
                    return
                else
                    p16.ThrowStarted = true
                    if p16.Viewmodel then
                        if p16.Viewmodel.IsDestroyed then
                            return
                        elseif p16.Viewmodel.Model then
                            if p16.Viewmodel.Model.Parent ~= CurrentCamera then
                                if p16.Viewmodel.IsDestroyed or not p16.Viewmodel.equip then
                                    return
                                end
                                p16.Viewmodel:equip(false)
                            end
                            if p16.Viewmodel.Hidden then
                                p16.Viewmodel:unhide()
                            end
                            local v20 = tick()
                            if p16.LastThrowTime > 0 and v20 - p16.LastThrowTime < 0.7 then
                                p16.ThrowStarted = false
                                return
                            elseif not p16.Viewmodel.IsDestroyed then
                                local v21 = p16.Viewmodel.Animation.Animations.Equip
                                if v21 then
                                    v21 = v21.IsPlaying
                                end
                                if v21 then
                                    for v22, v23 in pairs(p16.Viewmodel.Animation.Animations) do
                                        if v23.IsPlaying and (v23.Name ~= "Idle" and v23.Name ~= "Equip") then
                                            p16.Viewmodel.Animation:stop(v22)
                                        end
                                    end
                                    for v24, v25 in pairs(p16.CharacterAnimator.Animations) do
                                        if v25.IsPlaying and (v25.Name ~= "Idle" and v25.Name ~= "Equip") then
                                            p16.CharacterAnimator:stop(v24)
                                        end
                                    end
                                else
                                    p16:stopAllAnimations()
                                end
                                p16.CharacterAnimator:play("StartThrow")
                                p16.CharacterAnimator:play("ThrowIdle")
                                if p16.Viewmodel and (not p16.Viewmodel.IsDestroyed and (p16.Viewmodel.Model and p16.Viewmodel.Model.Parent == CurrentCamera)) then
                                    local v26 = p16.Viewmodel.Animation:play("ThrowIdle")
                                    p16.Viewmodel.Animation:play("StartThrow")
                                    m_Remotes.Spectate.ReplicateSpectateEvent.Send("StartThrow")
                                    if v26 then
                                        v26.Looped = true
                                        return
                                    end
                                end
                            end
                        else
                            return
                        end
                    else
                        return
                    end
                end
            end
        end
    end
end
function v_u_1.Throw(p_u_27, p_u_28) -- name: Throw
    -- upvalues: (copy) m_GameState, (copy) LocalPlayer, (copy) CurrentCamera, (copy) RunService, (copy) m_Remotes, (copy) m_GetCharacterVelocity
    if p_u_27.ThrowFinished then
        return
    else
        local v29
        if workspace:GetAttribute("ServerGamemode") == "Competitive" then
            v29 = m_GameState.GetState() == "Buy Period"
        else
            v29 = false
        end
        if v29 then
            if p_u_27.ThrowStarted and not p_u_27.ThrowFinished then
                p_u_27:Cancel()
            end
            return
        elseif LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Dead")) then
            return
        elseif p_u_27.Viewmodel and (not p_u_27.Viewmodel.IsDestroyed and p_u_27.Viewmodel.Model) then
            if p_u_27.Viewmodel.Model.Parent ~= CurrentCamera then
                if p_u_27.Viewmodel.IsDestroyed or not p_u_27.Viewmodel.equip then
                    p_u_27.ThrowStarted = false
                    return
                end
                p_u_27.Viewmodel:equip(false)
                RunService.Heartbeat:Wait()
                if p_u_27.Viewmodel.Model.Parent ~= CurrentCamera then
                    p_u_27.ThrowStarted = false
                    return
                end
            end
            if p_u_27.Viewmodel.Hidden then
                p_u_27.Viewmodel:unhide()
            end
            if p_u_27.Viewmodel.Animation then
                if p_u_27.Janitor:Get("ThrowGrenadeFinished") then
                    p_u_27.Janitor:Remove("ThrowGrenadeFinished")
                end
                if p_u_27.Janitor:Get("ThrowGrenadeStoppedFallback") then
                    p_u_27.Janitor:Remove("ThrowGrenadeStoppedFallback")
                end
                local v30 = p_u_27.Viewmodel.Animation.Animations.Equip
                if v30 then
                    v30 = v30.IsPlaying
                end
                if v30 then
                    p_u_27.Viewmodel.Animation:stop("Equip")
                    p_u_27.CharacterAnimator:stop("Equip")
                    for v31, v32 in pairs(p_u_27.Viewmodel.Animation.Animations) do
                        if v32.IsPlaying and v32.Name ~= "Idle" then
                            p_u_27.Viewmodel.Animation:stop(v31)
                        end
                    end
                    for v33, v34 in pairs(p_u_27.CharacterAnimator.Animations) do
                        if v34.IsPlaying and v34.Name ~= "Idle" then
                            p_u_27.CharacterAnimator:stop(v33)
                        end
                    end
                    RunService.Heartbeat:Wait()
                else
                    if p_u_27.Viewmodel.Animation.Animations.StartThrow then
                        p_u_27.Viewmodel.Animation:stop("StartThrow")
                    end
                    if p_u_27.Viewmodel.Animation.Animations.ThrowIdle then
                        p_u_27.Viewmodel.Animation:stop("ThrowIdle")
                    end
                    if p_u_27.CharacterAnimator.Animations.StartThrow then
                        p_u_27.CharacterAnimator:stop("StartThrow")
                    end
                    if p_u_27.CharacterAnimator.Animations.ThrowIdle then
                        p_u_27.CharacterAnimator:stop("ThrowIdle")
                    end
                end
                if p_u_27.Viewmodel and (not p_u_27.Viewmodel.IsDestroyed and p_u_27.Viewmodel.Animation) then
                    local v35 = p_u_27.Viewmodel.Animation:play(p_u_28)
                    if v35 then
                        local v36 = tick()
                        while v35.Length == 0 and tick() - v36 < 0.5 do
                            RunService.Heartbeat:Wait()
                        end
                        if p_u_27.IsDestroyed or (not p_u_27.Viewmodel or p_u_27.Viewmodel.IsDestroyed) then
                            p_u_27.ThrowStarted = false
                            return
                        else
                            p_u_27.CharacterAnimator:play("Throw")
                            m_Remotes.Spectate.ReplicateSpectateEvent.Send("Throw")
                            p_u_27.ThrowCompleted = false
                            local function v_u_40() -- name: completeThrow
                                -- upvalues: (copy) p_u_27, (ref) LocalPlayer, (ref) m_GetCharacterVelocity, (ref) m_Remotes, (ref) CurrentCamera, (copy) p_u_28
                                if p_u_27.ThrowCompleted then
                                    return
                                else
                                    p_u_27.ThrowCompleted = true
                                    if not p_u_27.IsDestroyed and p_u_27.Identifier then
                                        p_u_27.ThrowFinished = true
                                        p_u_27.ThrowStarted = false
                                        p_u_27.LastThrowTime = tick()
                                        local v37 = LocalPlayer.Character
                                        local v38 = m_GetCharacterVelocity(v37)
                                        if v37 then
                                            v37 = v37:FindFirstChildOfClass("Humanoid")
                                        end
                                        local v39
                                        if v37 == nil then
                                            v39 = false
                                        else
                                            v39 = v37:GetAttribute("Crouching") == true
                                        end
                                        m_Remotes.Inventory.ThrowGrenade.Send({
                                            ["Direction"] = CurrentCamera.CFrame.LookVector,
                                            ["Position"] = CurrentCamera.CFrame.Position,
                                            ["Identifier"] = p_u_27.Identifier,
                                            ["Animation"] = p_u_28,
                                            ["CharacterVelocity"] = v38,
                                            ["IsCrouching"] = v39
                                        })
                                    end
                                end
                            end
                            if v35 and v35.IsPlaying then
                                p_u_27.Janitor:Add(v35:GetMarkerReachedSignal("Throw"):Once(function()
                                    -- upvalues: (copy) v_u_40
                                    v_u_40()
                                end), "Disconnect", "ThrowGrenadeFinished")
                                p_u_27.Janitor:Add(v35.Stopped:Once(function()
                                    -- upvalues: (copy) p_u_27, (copy) v_u_40
                                    task.delay(0.05, function()
                                        -- upvalues: (ref) p_u_27, (ref) v_u_40
                                        if not (p_u_27.ThrowCompleted or p_u_27.IsDestroyed) then
                                            v_u_40()
                                        end
                                    end)
                                end), "Disconnect", "ThrowGrenadeStoppedFallback")
                                if v35.Length > 0 then
                                    local v41 = v35.Length * 0.7
                                    local v_u_42 = task.delay(v41, function()
                                        -- upvalues: (copy) p_u_27, (copy) v_u_40
                                        if not p_u_27.ThrowCompleted and (not p_u_27.IsDestroyed and (p_u_27.ThrowStarted and not p_u_27.ThrowFinished)) then
                                            v_u_40()
                                        end
                                    end)
                                    p_u_27.Janitor:Add(function()
                                        -- upvalues: (copy) v_u_42
                                        task.cancel(v_u_42)
                                    end, false, "ThrowGrenadeDelayFallback2")
                                end
                                local v_u_43 = task.delay(2, function()
                                    -- upvalues: (copy) p_u_27, (copy) v_u_40
                                    if not p_u_27.ThrowCompleted and (not p_u_27.IsDestroyed and (p_u_27.ThrowStarted and not p_u_27.ThrowFinished)) then
                                        v_u_40()
                                    end
                                end)
                                p_u_27.Janitor:Add(function()
                                    -- upvalues: (copy) v_u_43
                                    task.cancel(v_u_43)
                                end, false, "ThrowGrenadeDelayFallback3")
                            else
                                p_u_27.ThrowStarted = false
                            end
                        end
                    else
                        p_u_27.ThrowStarted = false
                        return
                    end
                else
                    p_u_27.ThrowStarted = false
                    return
                end
            else
                p_u_27.ThrowStarted = false
                return
            end
        else
            p_u_27.ThrowStarted = false
            return
        end
    end
end
function v_u_1.Cancel(p44) -- name: Cancel
    -- upvalues: (copy) m_Remotes
    if not p44.ThrowFinished then
        if p44.Janitor:Get("ThrowGrenadeFinished") then
            p44.Janitor:Remove("ThrowGrenadeFinished")
        end
        if p44.Janitor:Get("ThrowGrenadeStoppedFallback") then
            p44.Janitor:Remove("ThrowGrenadeStoppedFallback")
        end
        if p44.Janitor:Get("ThrowGrenadeDelayFallback2") then
            p44.Janitor:Remove("ThrowGrenadeDelayFallback2")
        end
        if p44.Janitor:Get("ThrowGrenadeDelayFallback3") then
            p44.Janitor:Remove("ThrowGrenadeDelayFallback3")
        end
        p44.ThrowFinished = false
        p44.ThrowStarted = false
        p44.ThrowCompleted = false
        p44:stopAllAnimations()
        m_Remotes.Spectate.ReplicateSpectateEvent.Send("CancelThrow")
    end
end
function v_u_1.inspect(p_u_45) -- name: inspect
    -- upvalues: (copy) m_Remotes
    if not p_u_45.IsInspecting then
        if p_u_45.ThrowStarted and not p_u_45.ThrowFinished then
            p_u_45:Cancel()
        end
        p_u_45.IsInspecting = true
        p_u_45:stopAllAnimations()
        local v46 = p_u_45.Viewmodel.Animation:play("Inspect")
        m_Remotes.Spectate.ReplicateSpectateEvent.Send("Inspect")
        task.delay(v46.Length, function()
            -- upvalues: (copy) p_u_45
            p_u_45.IsInspecting = false
        end)
    end
end
function v_u_1.reload(_) -- name: reload end
function v_u_1.drop(p47) -- name: drop
    -- upvalues: (copy) m_GameState, (copy) m_Remotes, (copy) m_GetCharacterVelocity, (copy) LocalPlayer, (copy) CurrentCamera
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false
    end
    if m_GameState.GetState() == "Warmup" then
        return false
    end
    if not p47.Properties.Droppable then
        return false
    end
    p47:unequip()
    m_Remotes.Inventory.DropWeapon.Send({
        ["CharacterVelocity"] = m_GetCharacterVelocity(LocalPlayer.Character),
        ["Direction"] = CurrentCamera.CFrame.LookVector,
        ["Identifier"] = p47.Identifier
    })
    return true
end
function v_u_1.equip(p_u_48) -- name: equip
    -- upvalues: (copy) m_GameState, (copy) UserInputService
    p_u_48.EquipTime = tick()
    if p_u_48.Janitor:Get("EquipDelayThrow") then
        p_u_48.Janitor:Remove("EquipDelayThrow")
    end
    p_u_48.Viewmodel.Animation:stopAnimations()
    p_u_48.CharacterAnimator:stopAnimations()
    p_u_48.ThrowStarted = false
    p_u_48.ThrowFinished = false
    p_u_48.ThrowCompleted = false
    p_u_48.CharacterAnimator:play("Idle")
    p_u_48.CharacterAnimator:play("Equip")
    p_u_48.Viewmodel:equip(false)
    local v_u_49 = task.delay(0.7, function()
        -- upvalues: (copy) p_u_48, (ref) m_GameState, (ref) UserInputService
        if p_u_48.IsDestroyed then
            return
        elseif m_GameState.GetState() ~= "Buy Period" then
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonR2) then
                p_u_48:StartThrow()
            end
        end
    end)
    p_u_48.Janitor:Add(function()
        -- upvalues: (copy) v_u_49
        task.cancel(v_u_49)
    end, false, "EquipDelayThrow")
end
function v_u_1.unequip(p50) -- name: unequip
    if p50.Janitor:Get("EquipDelayThrow") then
        p50.Janitor:Remove("EquipDelayThrow")
    end
    p50.CharacterAnimator:stopAnimations()
    p50.Viewmodel:unequip()
    p50.IsInspecting = false
    if p50.ThrowStarted and not p50.ThrowFinished then
        p50:Cancel()
    end
end
function v_u_1.new(p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62, _) -- name: new
    -- upvalues: (copy) m_WeaponComponent, (copy) v_u_1
    local v63 = m_WeaponComponent.new(p51, p52, p53, p54, p55, p56, p57, p58, p59, p60, p61, p62)
    local v64 = v_u_1
    local v65 = setmetatable(v63, v64)
    v65.IsInspecting = false
    v65.ThrowStarted = false
    v65.ThrowFinished = false
    v65.ThrowCompleted = false
    v65.LastThrowTime = 0
    v65.EquipTime = 0
    return v65
end
function v_u_1.destroy(p66) -- name: destroy
    -- upvalues: (copy) m_WeaponComponent
    if not p66.IsDestroyed then
        p66.IsDestroyed = true
        if p66.Janitor then
            p66.Janitor:Destroy()
            p66.Janitor = nil
        end
        p66.ThrowFinished = nil
        p66.ThrowStarted = nil
        p66.ThrowCompleted = nil
        p66.IsInspecting = nil
        m_WeaponComponent.destroy(p66)
    end
end
return v_u_1
