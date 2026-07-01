-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local m_WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_Camera = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera)
local m_CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam)
local m_CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker)
local m_CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact)
local m_CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer)
local m_BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass)
local m_GetCharacterVelocity = require(ReplicatedStorage.Components.Common.GetCharacterVelocity)
local m_HapticsController = require(ReplicatedStorage.Controllers.HapticsController)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_SoundController = require(ReplicatedStorage.Controllers.SoundController)
local m_InputController = require(ReplicatedStorage.Controllers.InputController)
local m_HintController = require(ReplicatedStorage.Controllers.HintController)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_GameState = require(ReplicatedStorage.Database.Components.GameState)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local m_Bullet = require(script.Classes.Bullet)
local CurrentCamera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v_u_28 = m_Sound.new("Other")
local v_u_29 = { 37, 60 }
local v_u_30 = { Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2 }
local v_u_31 = { Enum.UserInputType.MouseButton2, Enum.KeyCode.ButtonL2 }
local v_u_32 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true
workspace:GetAttributeChangedSignal("VIPInfiniteAmmoEnabled"):Connect(function()
    -- upvalues: (ref) v_u_32
    v_u_32 = workspace:GetAttribute("VIPInfiniteAmmoEnabled") == true
end)
local v_u_33 = v_u_32
local v_u_34 = {}
for _, v35 in ipairs(ReplicatedStorage.Database.Custom.Weapons:GetChildren()) do
    if v35:IsA("ModuleScript") then
        v_u_34[v35.Name] = require(v35)
    end
end
local function v_u_41(p36, p37) -- name: getPressedActionBinding
    -- upvalues: (copy) m_InputController
    local v38 = m_InputController.getActionKeybinds(p36)
    for _, v39 in ipairs(v38) do
        if m_InputController.isBindingPressed(v39) then
            return v39
        end
    end
    if p37 and #v38 == 0 then
        for _, v40 in ipairs(p37) do
            if m_InputController.isBindingPressed(v40) then
                return v40
            end
        end
    end
    return nil
end
local function v_u_48(p42, p43) -- name: buildActiveRecoilPattern
    local Recoil_0 = p42.Properties.Recoil
    if not Recoil_0 then
        return nil
    end
    local Properties = p42.Properties
    if p42.Properties.ShootingOptions == "Revolver" and p43 then
        Properties = table.clone(p42.Properties)
        local FireModes = p42.Properties.FireModes
        local Primary = not FireModes or (p43 or "Primary") == "Secondary" and FireModes.Secondary or FireModes.Primary
        Properties.FireRate = Primary and Primary.FireRate or (p42.Properties.FireRate or 0.1)
    end
    return Recoil_0.Pattern(Properties)
end
local function v_u_58(p49, p50) -- name: applyActiveRecoilProfile
    -- upvalues: (copy) v_u_48
    local Recoil_1 = p49.Recoil
    if Recoil_1 then
        local v52 = p49.Properties.ShootingOptions == "Revolver" and p50 and p50 or "Default"
        local FireModes_0 = p49.Properties.FireModes
        local Primary_0 = not FireModes_0 or (p50 or "Primary") == "Secondary" and FireModes_0.Secondary or FireModes_0.Primary
        local v55 = Primary_0 and Primary_0.FireRate or (p49.Properties.FireRate or 0.1)
        local v56 = Recoil_1.Functions[v52]
        if not v56 then
            v56 = v_u_48(p49, p50)
            if not v56 then
                return
            end
            Recoil_1.Functions[v52] = v56
        end
        local ActiveFireRate = Recoil_1.ActiveFireRate
        if ActiveFireRate > 0 and (v55 > 0 and ActiveFireRate ~= v55) then
            Recoil_1.Time = Recoil_1.Time / ActiveFireRate * v55
            Recoil_1.RecoveryTime = Recoil_1.RecoveryTime / ActiveFireRate * v55
        end
        Recoil_1.Function = v56
        Recoil_1.ActiveFireRate = v55
    end
end
local function v_u_62(p59) -- name: replicateRevolverChargeStartSound
    -- upvalues: (copy) LocalPlayer, (copy) m_Remotes
    local Character = LocalPlayer
    if Character then
        Character = LocalPlayer.Character
    end
    if Character and Character:IsDescendantOf(workspace) then
        local Head = Character:FindFirstChild("Head")
        if Head then
            m_Remotes.Sound.ReplicateSound.Send({
                ["Parent"] = nil,
                ["Class"] = nil,
                ["Name"] = "Prepare",
                ["Parent"] = Head,
                ["Class"] = p59.Name
            })
        end
    else
        return
    end
end
local function v_u_72(p_u_63) -- name: startRechargeTimer
    -- upvalues: (ref) v_u_33
    local RechargeTime = p_u_63.Properties.RechargeTime
    local Rounds = p_u_63.Properties.Rounds
    if RechargeTime and Rounds then
        if v_u_33 then
            if p_u_63.RechargeThread then
                task.cancel(p_u_63.RechargeThread)
                p_u_63.RechargeThread = nil
            end
            p_u_63.Rounds = Rounds
            p_u_63.RechargeStartTime = nil
            return
        elseif Rounds <= p_u_63.Rounds then
            if p_u_63.RechargeThread then
                task.cancel(p_u_63.RechargeThread)
                p_u_63.RechargeThread = nil
            end
            p_u_63.RechargeStartTime = nil
            return
        else
            if p_u_63.RechargeThread then
                task.cancel(p_u_63.RechargeThread)
                p_u_63.RechargeThread = nil
            end
            local v66 = workspace:GetServerTimeNow()
            local Identifier = p_u_63.Identifier
            local v68 = p_u_63.RechargeStartTime or v66
            local v69 = v66 - v68
            local v70 = RechargeTime - math.max(v69, 0)
            local v71 = math.max(v70, 0)
            p_u_63.RechargeStartTime = v68
            if v71 <= 0 then
                p_u_63.Rounds = Rounds
                p_u_63.RechargeStartTime = nil
            else
                p_u_63.RechargeThread = task.delay(v71, function()
                    -- upvalues: (copy) p_u_63, (copy) Identifier, (copy) Rounds
                    if not p_u_63.IsDestroyed and p_u_63.Identifier == Identifier then
                        p_u_63.RechargeThread = nil
                        p_u_63.Rounds = Rounds
                        p_u_63.RechargeStartTime = nil
                    end
                end)
            end
        end
    else
        return
    end
end
local function v_u_81(p73, p74, p75, p76) -- name: resolveFireAnimationNames
    local FireModes_1 = p73.Properties.FireModes
    local Primary_1 = not FireModes_1 or (p76 or "Primary") == "Secondary" and FireModes_1.Secondary or FireModes_1.Primary
    if not Primary_1 then
        return p74, p75
    end
    local Animation = Primary_1.Animation
    if Animation and (p73.Viewmodel and p73.Viewmodel.Animation) then
        if not p73.Viewmodel.Animation:getAnimation(Animation) then
            Animation = p74
        end
    else
        Animation = p74
    end
    local CharacterAnimation = Primary_1.CharacterAnimation
    if CharacterAnimation and p73.CharacterAnimator then
        if not p73.CharacterAnimator:getAnimation(CharacterAnimation) then
            CharacterAnimation = p75
        end
    else
        CharacterAnimation = p75
    end
    return Animation, CharacterAnimation
end
local function v_u_86(p82, p83) -- name: stopRevolverChargeAnimation
    -- upvalues: (copy) v_u_81
    if p82.Viewmodel and (p82.Viewmodel.Animation and p82.CharacterAnimator) then
        local v84, v85 = v_u_81(p82, "Shoot", "Shoot", "Primary")
        p82.Viewmodel.Animation:cancelCrossfade()
        p82.Viewmodel.Animation:stop(v84)
        p82.CharacterAnimator:stop(v85)
        if p83 ~= false and p82.IsEquipped then
            p82.Viewmodel.Animation:play("Idle")
            p82.CharacterAnimator:play("Idle")
        end
    end
end
local function v_u_93(p87) -- name: completeRevolverChargeShot
    -- upvalues: (copy) LocalPlayer, (copy) m_GameState, (copy) v_u_58
    if p87.IsDestroyed then
        return
    elseif p87.IsEquipped then
        if p87.IsChargeFiring then
            local Character_0 = LocalPlayer
            if Character_0 then
                Character_0 = LocalPlayer.Character
            end
            local v89 = not Character_0 or Character_0:GetAttribute("Dead")
            if v89 or (m_GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true)) then
                p87:cancelRevolverCharge(false, not v89)
                return
            else
                p87.CurrentWalkSpeedOverride = nil
                if p87.Rounds > 0 then
                    p87:shoot("Primary")
                else
                    if p87.ChargeThread then
                        task.cancel(p87.ChargeThread)
                        p87.ChargeThread = nil
                    end
                    if p87.ChargeShootConnection and p87.ChargeShootConnection.Connected then
                        p87.ChargeShootConnection:Disconnect()
                    end
                    p87.ChargeShootConnection = nil
                    p87.HasPendingChargeRequest = false
                    p87.IsChargeFiring = false
                    p87.ChargeStartTick = 0
                    p87.CurrentWalkSpeedOverride = nil
                    if p87.Properties.ShootingOptions == "Revolver" then
                        if p87.Bullet then
                            local FireModes_2 = p87.Properties.FireModes
                            local v91
                            if FireModes_2 then
                                v91 = FireModes_2.Secondary or FireModes_2.Primary
                            else
                                v91 = nil
                            end
                            local Spread = v91 and v91.Spread or p87.Properties.Spread
                            p87.Bullet:setSpreadConfig(Spread)
                        end
                        v_u_58(p87, "Secondary")
                    end
                    p87:reload()
                end
            end
        else
            return
        end
    else
        return
    end
end
local function v_u_117(p94) -- name: kickCamera
    -- upvalues: (copy) m_CameraController
    local Rotation = p94.Rotation
    local Position = p94.Position
    local Value = Rotation.RotationDampen.Value
    local Value_0 = Rotation.RotationSpeed.Value
    local Value_1 = Position.PositionDampen.Value
    local Value_2 = Position.PositionSpeed.Value
    local v101 = Value_1 > 2 and 1 or Value_1
    local v102 = Value_2 > 2 and 1 or Value_2
    local v103 = Value_0 >= 30 and 25 or Value_0
    local Value_3 = Rotation.RotationX.Value
    local Value_4 = Rotation.RotationY.Value
    local Value_5 = Rotation.RotationZ.Value
    local v107 = Value >= 5 and 1 or Value
    local v108 = (Value_3 < 0.1 and 1 or Value_3) * 0.8
    local v109 = math.abs(Value_4) < 0.1 and 25 or math.abs(Value_4)
    local v110 = (math.random() * 2 - 1) * v109 * 0.5
    local v111 = Value_5 < 0.1 and 1 or Value_5
    local v112 = {
        ["Value"] = Vector3.new(v108, v110, v111),
        ["Damper"] = v107,
        ["Speed"] = v103
    }
    local v113 = {}
    local Value_6 = Position.PositionX.Value
    local Value_7 = Position.PositionY.Value
    local Value_8 = Position.PositionZ.Value
    v113.Value = Vector3.new(Value_6, Value_7, Value_8)
    v113.Damper = v101
    v113.Speed = v102
    m_CameraController.weaponKick(v112, v113)
end
function v_u_1.isJumping(_) -- name: isJumping
    return false
end
function v_u_1.getSpread(p118) -- name: getSpread
    local v119 = p118.Bullet:getTrueSpread()
    if p118:isJumping() then
        return v119 + 0
    else
        return v119
    end
end
function v_u_1.getCrosshairDisplayState(_) -- name: getCrosshairDisplayState
    return nil
end
function v_u_1.getBaseSpread(p120) -- name: getBaseSpread
    local v121 = p120.Bullet:getBaseSpread()
    if p120:isJumping() then
        return v121 + 0
    else
        return v121
    end
end
function v_u_1.cancelRevolverCharge(p122, p123, p124) -- name: cancelRevolverCharge
    -- upvalues: (copy) v_u_58, (copy) v_u_86, (copy) m_Remotes
    local IsChargeFiring = p122.IsChargeFiring
    if p122.ChargeThread then
        task.cancel(p122.ChargeThread)
        p122.ChargeThread = nil
    end
    if p122.ChargeShootConnection and p122.ChargeShootConnection.Connected then
        p122.ChargeShootConnection:Disconnect()
    end
    p122.ChargeShootConnection = nil
    p122.HasPendingChargeRequest = false
    p122.IsChargeFiring = false
    p122.ChargeStartTick = 0
    p122.CurrentWalkSpeedOverride = nil
    if p122.Properties.ShootingOptions == "Revolver" then
        if p122.Bullet then
            local FireModes_3 = p122.Properties.FireModes
            local v127
            if FireModes_3 then
                v127 = FireModes_3.Secondary or FireModes_3.Primary
            else
                v127 = nil
            end
            local Spread_0 = v127 and v127.Spread or p122.Properties.Spread
            p122.Bullet:setSpreadConfig(Spread_0)
        end
        v_u_58(p122, "Secondary")
    end
    if IsChargeFiring then
        v_u_86(p122, p124)
        if p124 ~= false and (p122.IsEquipped and not p122.IsDestroyed) then
            m_Remotes.Spectate.ReplicateSpectateEvent.Send("RevolverChargeCancel")
        end
    end
    if p123 ~= true then
        p122.IsFireHeld = false
        p122.FireInputBinding = nil
    end
end
function v_u_1.startRevolverCharge(p_u_129, p130) -- name: startRevolverCharge
    -- upvalues: (copy) LocalPlayer, (copy) m_GameState, (copy) v_u_58, (copy) v_u_81, (copy) v_u_93, (copy) v_u_62, (copy) m_Remotes
    if p_u_129.Properties.ShootingOptions == "Revolver" then
        local FireModes_4 = p_u_129.Properties.FireModes
        local v132
        if FireModes_4 then
            v132 = FireModes_4.Primary
        else
            v132 = nil
        end
        if v132 and v132.InputBehavior == "Charge" then
            p_u_129:stopRevolverSecondaryFire()
            local v133 = p_u_129.Viewmodel.Animation:getAnimation("Equip")
            if (v133 and (v133.Length and (v133.Length > 0 and v133.Length * 0.925)) or 0.5) >= tick() - p_u_129.WeaponEquippedTick then
                return
            elseif LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Dead")) then
                return
            elseif m_GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true) then
                p_u_129.IsFireHeld = false
                p_u_129.FireInputBinding = nil
                p_u_129.IsAlternativeFireHeld = false
                p_u_129.AlternativeFireInputBinding = nil
                p_u_129.HasPendingChargeRequest = false
                return
            elseif p_u_129.IsAdjustingSuppressor or (p_u_129.IsReloading or p_u_129.IsChargeFiring) then
                return
            elseif p_u_129.IsShooting then
                local ShootRequestTick = tick() - p_u_129.ShootRequestTick
                local v135 = 0
                local FireModes_5 = p_u_129.Properties.FireModes
                local v137
                if FireModes_5 then
                    v137 = FireModes_5.Primary
                else
                    v137 = nil
                end
                local v138 = (v137 and v137.FireRate or (p_u_129.Properties.FireRate or 0.1)) - ShootRequestTick
                if math.max(v135, v138) <= 0.15 then
                    p_u_129.IsFireHeld = true
                    p_u_129.FireInputBinding = p130
                    p_u_129.HasPendingChargeRequest = true
                end
                return
            elseif p_u_129.Rounds <= 0 then
                p_u_129.IsFireHeld = false
                p_u_129.FireInputBinding = nil
                p_u_129:reload()
            else
                p_u_129.IsFireHeld = true
                p_u_129.FireInputBinding = p130
                p_u_129.HasPendingChargeRequest = false
                p_u_129.IsChargeFiring = true
                p_u_129.ChargeStartTick = tick()
                p_u_129.CurrentWalkSpeedOverride = v132.HoldWalkSpeed or p_u_129.Properties.WalkSpeed
                if p_u_129.Bullet then
                    local FireModes_6 = p_u_129.Properties.FireModes
                    local v140
                    if FireModes_6 then
                        v140 = FireModes_6.Primary
                    else
                        v140 = nil
                    end
                    local Spread_1 = v140 and v140.Spread or p_u_129.Properties.Spread
                    p_u_129.Bullet:setSpreadConfig(Spread_1)
                end
                v_u_58(p_u_129, "Primary")
                local v142 = p_u_129.Bullet and (v132 and v132.ChargeStartSpread) and (v132.Spread or p_u_129.Properties.Spread)
                if v142 then
                    p_u_129.Bullet:setBaseSpreadForConfig(v132.ChargeStartSpread, v142)
                end
                if p_u_129.IsInspecting or p_u_129.IsInspectFadingOut then
                    p_u_129:cancelInspect(nil, nil, true)
                end
                if p_u_129.ChargeThread then
                    task.cancel(p_u_129.ChargeThread)
                    p_u_129.ChargeThread = nil
                end
                if p_u_129.ChargeShootConnection and p_u_129.ChargeShootConnection.Connected then
                    p_u_129.ChargeShootConnection:Disconnect()
                end
                p_u_129.ChargeShootConnection = nil
                p_u_129:stopAllAnimations()
                local v143, v144 = v_u_81(p_u_129, "Shoot", "Shoot", "Primary")
                local v145 = p_u_129.Viewmodel.Animation:play(v143)
                if v145 then
                    v145:AdjustSpeed(1)
                    p_u_129.ChargeShootConnection = v145:GetMarkerReachedSignal("Shoot"):Connect(function()
                        -- upvalues: (ref) v_u_93, (copy) p_u_129
                        v_u_93(p_u_129)
                    end)
                end
                local v146 = p_u_129.CharacterAnimator:play(v144)
                if v146 then
                    v146:AdjustSpeed(1)
                end
                v_u_62(p_u_129)
                m_Remotes.Spectate.ReplicateSpectateEvent.Send("RevolverChargeStart")
                if not v145 then
                    local v147 = v132.ChargeTime or 0
                    p_u_129.ChargeThread = task.delay(v147, function()
                        -- upvalues: (ref) v_u_93, (copy) p_u_129
                        v_u_93(p_u_129)
                    end)
                end
            end
        else
            return
        end
    else
        return
    end
end
function v_u_1.startRevolverSecondaryFire(p148, p149) -- name: startRevolverSecondaryFire
    -- upvalues: (copy) m_GameState, (copy) LocalPlayer, (copy) v_u_58
    if p148.Properties.ShootingOptions == "Revolver" then
        if m_GameState.GetState() == "Buy Period" or (LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true) then
            p148.IsFireHeld = false
            p148.FireInputBinding = nil
            p148.IsAlternativeFireHeld = false
            p148.AlternativeFireInputBinding = nil
            p148.HasPendingChargeRequest = false
            return
        else
            p148:cancelRevolverCharge(false, false)
            p148.IsAlternativeFireHeld = true
            p148.AlternativeFireInputBinding = p149
            if p148.Bullet then
                local FireModes_7 = p148.Properties.FireModes
                local v151
                if FireModes_7 then
                    v151 = FireModes_7.Secondary or FireModes_7.Primary
                else
                    v151 = nil
                end
                local Spread_2 = v151 and v151.Spread or p148.Properties.Spread
                p148.Bullet:setSpreadConfig(Spread_2)
            end
            v_u_58(p148, "Secondary")
            if p148.IsShooting or (p148.IsReloading or p148.IsAdjustingSuppressor) then
                return
            elseif p148.Rounds > 0 then
                p148:shoot("Secondary")
            else
                p148:reload()
            end
        end
    else
        return
    end
end
function v_u_1.stopRevolverSecondaryFire(p153) -- name: stopRevolverSecondaryFire
    -- upvalues: (copy) v_u_58
    p153.IsAlternativeFireHeld = false
    p153.AlternativeFireInputBinding = nil
    if not p153.IsChargeFiring then
        if p153.Properties.ShootingOptions ~= "Revolver" then
            return
        end
        if p153.Bullet then
            local FireModes_8 = p153.Properties.FireModes
            local v155
            if FireModes_8 then
                v155 = FireModes_8.Secondary or FireModes_8.Primary
            else
                v155 = nil
            end
            local Spread_3 = v155 and v155.Spread or p153.Properties.Spread
            p153.Bullet:setSpreadConfig(Spread_3)
        end
        v_u_58(p153, "Secondary")
    end
end
function v_u_1.stopAllAnimations(p157) -- name: stopAllAnimations
    if p157.CharacterAnimator then
        if p157.Viewmodel and p157.Viewmodel.Animation then
            p157.Viewmodel.Animation:cancelCrossfade()
            for v158, v159 in pairs(p157.CharacterAnimator.Animations) do
                if v159.IsPlaying and v159.Name ~= "Idle" then
                    p157.CharacterAnimator:stop(v158)
                end
            end
            for v160, v161 in pairs(p157.Viewmodel.Animation.Animations) do
                if v161.IsPlaying and v161.Name ~= "Idle" then
                    p157.Viewmodel.Animation:stop(v160)
                end
            end
        end
    else
        return
    end
end
function v_u_1.removeSuppressor(p162) -- name: removeSuppressor
    -- upvalues: (copy) m_Remotes
    if tick() - p162.WeaponEquippedTick <= 1 then
        return
    elseif not (p162.IsAdjustingSuppressor or (p162.IsShooting or (p162.IsReloading or p162.IsAiming))) then
        p162.IsAdjustingSuppressor = true
        p162.IsBurstShooting = false
        p162.IsInspecting = false
        p162.IsReloading = false
        p162.IsShooting = false
        p162.IsAiming = false
        p162.ScopeStartTick = 0
        p162:stopAllAnimations()
        p162.Viewmodel.Animation:play("RemoveSuppressor")
        p162.CharacterAnimator:play("RemoveSuppressor")
        m_Remotes.Spectate.ReplicateSpectateEvent.Send("Remove Suppressor")
    end
end
function v_u_1.addSuppressor(p163) -- name: addSuppressor
    -- upvalues: (copy) m_Remotes
    if tick() - p163.WeaponEquippedTick <= 1 then
        return
    elseif not (p163.IsAdjustingSuppressor or (p163.IsShooting or (p163.IsReloading or p163.IsAiming))) then
        p163.IsAdjustingSuppressor = true
        p163.IsBurstShooting = false
        p163.IsInspecting = false
        p163.IsReloading = false
        p163.IsShooting = false
        p163.IsAiming = false
        p163:stopAllAnimations()
        p163.Viewmodel.Animation:play("AddSuppressor")
        p163.CharacterAnimator:play("AddSuppressor")
        m_Remotes.Spectate.ReplicateSpectateEvent.Send("Add Suppressor")
    end
end
function v_u_1.scope(p164, p165) -- name: scope
    -- upvalues: (copy) v_u_28, (copy) LocalPlayer, (copy) m_CameraController, (copy) m_Constants, (copy) v_u_29, (copy) m_Remotes
    if p164.Viewmodel then
        if tick() - p164.WeaponEquippedTick <= 1 then
            return
        else
            local v166 = p164.Properties.AimingOptions == "AutomaticScope"
            if p164.IsAdjustingSuppressor or (p164.IsReloading or p164.IsShooting and not v166) then
                return
            elseif not p164.IsDestroyed then
                if p164.Properties.HasScope then
                    if not p164.IsAiming then
                        p164:stopAllAnimations()
                    end
                    p164.IsBurstShooting = false
                    p164.IsInspecting = false
                    p164.IsReloading = false
                    p164.IsShooting = false
                    if not p164.IsAiming then
                        p164.ScopeStartTick = tick()
                    end
                    p164.IsAiming = true
                    local Name = p164.Name
                    if Name == "SSG 08" and true or Name == "AWP" then
                        p164.IsSniperScoped = true
                        if p164.Name == "AWP" and p164.Player then
                            p164.Player:SetAttribute("IsSniperScoped", true)
                        end
                    end
                    if p164.Properties.AimingOptions == "SniperScope" then
                        if not p164.Viewmodel.Hidden then
                            p164.Viewmodel:hide()
                        end
                        v_u_28:play({
                            ["Parent"] = nil,
                            ["Name"] = "Toggle Scope",
                            ["Parent"] = LocalPlayer.PlayerGui
                        })
                        if p165 then
                            p164.CurrentScopeIncrement = p164.CurrentScopeIncrement + 1
                            if p164.CurrentScopeIncrement >= 3 then
                                p164:unscope()
                            else
                                m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV - v_u_29[p164.CurrentScopeIncrement])
                                m_Remotes.Inventory.UpdateScopeIncrement.Send(p164.CurrentScopeIncrement)
                            end
                        else
                            m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV - v_u_29[1])
                            m_Remotes.Inventory.UpdateScopeIncrement.Send(1)
                            return
                        end
                    end
                    if p164.Properties.AimingOptions == "AutomaticScope" then
                        if p164.CurrentScopeIncrement == 1 then
                            p164:unscope()
                            return
                        end
                        p164.CurrentScopeIncrement = 1
                        if not p164.Viewmodel.Hidden then
                            p164.Viewmodel:hide()
                        end
                        p164.Viewmodel:aim()
                        m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV - 15 * p164.CurrentScopeIncrement)
                        m_Remotes.Inventory.UpdateScopeIncrement.Send(p164.CurrentScopeIncrement)
                        v_u_28:play({
                            ["Parent"] = nil,
                            ["Name"] = "Scope In",
                            ["Parent"] = LocalPlayer.PlayerGui
                        })
                    end
                end
            end
        end
    else
        return
    end
end
function v_u_1.unscope(p168, p169) -- name: unscope
    -- upvalues: (copy) m_Remotes, (copy) ReplicatedStorage, (copy) m_CameraController, (copy) m_Constants, (copy) v_u_28, (copy) LocalPlayer
    if tick() - p168.WeaponEquippedTick <= 1 then
        return
    elseif p168.IsAdjustingSuppressor then
        return
    elseif tick() - p168.WeaponEquippedTick > 1 then
        if p168.Properties.HasScope then
            if p168.IsAiming then
                p168:stopAllAnimations()
            end
            if p168.CurrentScopeIncrement > 0 or p168.IsAiming then
                m_Remotes.Inventory.UpdateScopeIncrement.Send(0)
            end
            if not p169 then
                p168.CurrentScopeIncrement = 0
            end
            p168.IsInspecting = false
            p168.IsReloading = false
            p168.IsAiming = false
            p168.ScopeStartTick = 0
            local Name_0 = p168.Name
            if Name_0 == "SSG 08" and true or Name_0 == "AWP" then
                p168.IsSniperScoped = false
                if p168.Name == "AWP" and p168.Player then
                    p168.Player:SetAttribute("IsSniperScoped", false)
                end
            end
            if p168.Properties.AimingOptions == "SniperScope" then
                if p168.Viewmodel.Hidden then
                    p168.Viewmodel:unhide()
                end
                local m_CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController)
                local m_MenuSceneController = require(ReplicatedStorage.Controllers.MenuSceneController)
                if not (m_CaseSceneController.IsActive() or m_MenuSceneController.IsActive()) then
                    m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
                end
                if p169 then
                    local v173 = p168.CurrentScopeIncrement - 1
                    p168.CurrentScopeIncrement = math.clamp(v173, 0, 3)
                    return
                end
            elseif p168.Properties.AimingOptions == "AutomaticScope" then
                p168.CurrentScopeIncrement = 0
                p168.Viewmodel:unaim()
                if p168.Viewmodel.Hidden then
                    p168.Viewmodel:unhide()
                end
                m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV - 15 * p168.CurrentScopeIncrement)
                v_u_28:play({
                    ["Parent"] = nil,
                    ["Name"] = "Scope Out",
                    ["Parent"] = LocalPlayer.PlayerGui
                })
            end
        end
    end
end
function v_u_1.cancelInspect(p_u_174, p175, p176, p177) -- name: cancelInspect
    if p_u_174.IsInspecting or p_u_174.IsInspectFadingOut then
        if p_u_174.InspectDelayThread then
            task.cancel(p_u_174.InspectDelayThread)
            p_u_174.InspectDelayThread = nil
        end
        if p_u_174.CancelDelayThread then
            task.cancel(p_u_174.CancelDelayThread)
            p_u_174.CancelDelayThread = nil
        end
        if p_u_174.FadeCompleteThread then
            task.cancel(p_u_174.FadeCompleteThread)
            p_u_174.FadeCompleteThread = nil
        end
        if p177 then
            p_u_174.IsInspecting = false
            p_u_174.IsInspectFadingOut = false
            p_u_174.Viewmodel.Animation:markInspectCancel()
            p_u_174.Viewmodel.Animation:cancelCrossfade()
        else
            local v_u_178 = p175 or 0.25
            p_u_174.IsInspectFadingOut = true
            p_u_174.IsInspecting = false
            p_u_174.Viewmodel.Animation:markInspectCancel()
            p_u_174.CancelDelayThread = task.delay(p176 or 0.3, function()
                -- upvalues: (copy) p_u_174, (copy) v_u_178
                if p_u_174.IsDestroyed then
                    return
                elseif p_u_174.IsInspectFadingOut then
                    p_u_174.Viewmodel.Animation:crossfadeTo("Idle", v_u_178)
                    p_u_174.FadeCompleteThread = task.delay(v_u_178, function()
                        -- upvalues: (ref) p_u_174
                        if not p_u_174.IsDestroyed then
                            p_u_174.FadeCompleteThread = nil
                            p_u_174.IsInspectFadingOut = false
                        end
                    end)
                end
            end)
        end
    else
        return
    end
end
function v_u_1.inspect(p_u_179) -- name: inspect
    -- upvalues: (copy) m_Remotes
    if tick() - p_u_179.WeaponEquippedTick <= 1 then
        return
    else
        if p_u_179.IsChargeFiring then
            p_u_179:cancelRevolverCharge(false, false)
        end
        p_u_179:stopRevolverSecondaryFire()
        if p_u_179.IsAdjustingSuppressor or (p_u_179.IsShooting or (p_u_179.IsReloading or p_u_179.IsAiming)) then
            return
        elseif p_u_179.IsInspecting and not p_u_179.IsInspectFadingOut then
            return
        else
            local v180 = p_u_179.IsInspectFadingOut == true
            if v180 then
                p_u_179.IsInspectFadingOut = false
                if p_u_179.CancelDelayThread then
                    task.cancel(p_u_179.CancelDelayThread)
                    p_u_179.CancelDelayThread = nil
                end
                if p_u_179.FadeCompleteThread then
                    task.cancel(p_u_179.FadeCompleteThread)
                    p_u_179.FadeCompleteThread = nil
                end
                p_u_179.Viewmodel.Animation:cancelCrossfade()
            end
            p_u_179.IsBurstShooting = false
            p_u_179.IsInspecting = true
            p_u_179.IsReloading = false
            p_u_179.IsShooting = false
            p_u_179.ScopeStartTick = 0
            p_u_179.IsAiming = false
            if p_u_179.InspectDelayThread then
                task.cancel(p_u_179.InspectDelayThread)
                p_u_179.InspectDelayThread = nil
            end
            local v181 = p_u_179.Viewmodel.Animation:pickInspectVariant()
            if v180 then
                if not p_u_179.Viewmodel.Animation:crossfadeRestart(v181, 0.25) then
                    p_u_179:stopAllAnimations()
                    p_u_179.Viewmodel.Animation:play(v181)
                end
                m_Remotes.Spectate.ReplicateSpectateEvent.Send(v181)
                local v182 = p_u_179.Viewmodel.Animation:getAnimation(v181)
                if v182 then
                    p_u_179.InspectDelayThread = task.delay(v182.Length, function()
                        -- upvalues: (copy) p_u_179
                        if not p_u_179.IsDestroyed then
                            p_u_179.InspectDelayThread = nil
                            p_u_179.IsInspecting = false
                        end
                    end)
                end
            else
                p_u_179:stopAllAnimations()
                local v183 = p_u_179.Viewmodel.Animation:play(v181)
                m_Remotes.Spectate.ReplicateSpectateEvent.Send(v181)
                p_u_179.InspectDelayThread = task.delay(v183.Length, function()
                    -- upvalues: (copy) p_u_179
                    if not p_u_179.IsDestroyed then
                        p_u_179.InspectDelayThread = nil
                        p_u_179.IsInspecting = false
                    end
                end)
            end
        end
    end
end
function v_u_1.updateFireMode(p184) -- name: updateFireMode
    -- upvalues: (copy) v_u_28, (copy) LocalPlayer, (copy) m_Remotes, (copy) m_Router
    if tick() - p184.WeaponEquippedTick <= 1 then
        return
    elseif not (p184.IsShooting or (p184.IsReloading or (p184.IsBurstShooting or p184.IsChargeFiring))) then
        v_u_28:play({
            ["Name"] = "Switch Fire Mode",
            ["Parent"] = nil,
            ["Parent"] = LocalPlayer.PlayerGui
        })
        p184:stopAllAnimations()
        p184.Viewmodel.Animation:play("Switch")
        p184.AlternativeSwitchTick = tick()
        p184.AlternativeShootingOption = p184.AlternativeShootingOption == "Burst" and "Default" or "Burst"
        m_Remotes.Spectate.ReplicateSpectateEvent.Send("Switch Fire Mode")
        local v185 = p184.Properties.Automatic and "Switched to automatic" or "Switched to semi-automatic"
        m_Router.broadcastRouter("CreateNotification", "Switched Fire Mode", p184.AlternativeShootingOption == "Default" and v185 and v185 or "Switched to burst-fire mode", 2.5)
    end
end
function v_u_1.drop(p186) -- name: drop
    -- upvalues: (copy) m_GameState, (copy) m_Remotes, (copy) m_GetCharacterVelocity, (copy) LocalPlayer, (copy) CurrentCamera
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        return false
    end
    if m_GameState.GetState() == "Warmup" then
        return false
    end
    if not p186.Properties.Droppable then
        return false
    end
    p186:unequip()
    m_Remotes.Inventory.DropWeapon.Send({
        ["CharacterVelocity"] = m_GetCharacterVelocity(LocalPlayer.Character),
        ["Direction"] = CurrentCamera.CFrame.LookVector,
        ["Identifier"] = p186.Identifier
    })
    return true
end
function v_u_1.reload(p_u_187) -- name: reload
    -- upvalues: (copy) v_u_28, (copy) LocalPlayer, (copy) HttpService, (copy) m_Remotes, (copy) m_HintController
    local v_u_188
    if workspace:GetAttribute("Gamemode") == "Deathmatch" then
        v_u_188 = p_u_187.Properties.ReloadAnimationCount == 1
    else
        v_u_188 = false
    end
    if tick() - p_u_187.WeaponEquippedTick <= 1 then
        return
    end
    if p_u_187.IsChargeFiring then
        p_u_187:cancelRevolverCharge(false, false)
    end
    p_u_187:stopRevolverSecondaryFire()
    if p_u_187.IsAdjustingSuppressor or (p_u_187.IsReloading or p_u_187.IsShooting) then
        return
    end
    if p_u_187.Properties.Rounds == p_u_187.Rounds then
        if p_u_187.IsInspecting or p_u_187.IsInspectFadingOut then
            p_u_187:cancelInspect(0.25)
        end
        return
    end
    if p_u_187.Properties.RechargeTime then
        if p_u_187.IsInspecting or p_u_187.IsInspectFadingOut then
            p_u_187:cancelInspect(0.25)
        end
        return
    end
    if p_u_187.Capacity <= 0 and not v_u_188 then
        if p_u_187.IsInspecting or p_u_187.IsInspectFadingOut then
            p_u_187:cancelInspect(0.25)
        end
        return v_u_28:play({
            ["Parent"] = nil,
            ["Name"] = "No Ammo",
            ["Parent"] = LocalPlayer.PlayerGui
        })
    end
    if p_u_187.IsAiming then
        p_u_187:unscope()
    end
    if not (p_u_187.Properties.Rounds and p_u_187.Properties.ReloadAnimationCount) then
        return
    end
    if p_u_187.IsInspecting or p_u_187.IsInspectFadingOut then
        p_u_187:cancelInspect(nil, nil, true)
    end
    p_u_187:stopAllAnimations()
    p_u_187.ReloadStartTick = tick()
    p_u_187.IsBurstShooting = false
    p_u_187.IsInspecting = false
    p_u_187.IsReloading = true
    p_u_187.IsShooting = false
    p_u_187.CurrentWalkSpeedOverride = nil
    if p_u_187.Properties.ReloadAnimationCount > 1 then
        local ReloadAnimationCount = p_u_187.Properties.Rounds / p_u_187.Properties.ReloadAnimationCount
        local v190 = p_u_187.Viewmodel.Animation:play("ReloadStart")
        task.wait(v190.Length * 0.75)
        local v191 = p_u_187.Properties.Rounds - p_u_187.Rounds / ReloadAnimationCount
        for _ = 1, math.ceil(v191) do
            if not p_u_187.IsReloading then
                break
            end
            local v192 = p_u_187.Viewmodel.Animation:play("ReloadAction")
            if not v192 then
                error((("Client failed to fetch reload animation for %*."):format(p_u_187.Name)))
            end
            local v_u_193 = HttpService:GenerateGUID(false)
            p_u_187.CurrentReloadIdentity = v_u_193
            p_u_187.CharacterAnimator:play("Reload")
            m_Remotes.Spectate.ReplicateSpectateEvent.Send("Reload")
            v192:GetMarkerReachedSignal("MagOut"):Once(function()
                -- upvalues: (ref) m_Remotes, (copy) p_u_187
                m_Remotes.Inventory.CreateMagazine.Send(p_u_187.Identifier)
            end)
            v192:GetMarkerReachedSignal("MagIn"):Once(function()
                -- upvalues: (copy) p_u_187, (copy) ReloadAnimationCount, (copy) v_u_193, (ref) m_Remotes
                local v194 = p_u_187
                local IsDestroyed = not v194.IsDestroyed
                if IsDestroyed then
                    IsDestroyed = v194.IsEquipped == true
                end
                if IsDestroyed then
                    local v196 = ReloadAnimationCount
                    local Capacity = p_u_187.Capacity
                    local v198 = math.clamp(v196, 0, Capacity)
                    if p_u_187.CurrentReloadIdentity == v_u_193 and v198 <= p_u_187.Capacity then
                        m_Remotes.Inventory.ReloadWeapon.Send({
                            ["Identifier"] = p_u_187.Identifier,
                            ["Capacity"] = p_u_187.Capacity,
                            ["Rounds"] = p_u_187.Rounds
                        })
                        p_u_187.Rounds = p_u_187.Rounds + v198
                        if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                            p_u_187.Capacity = p_u_187.Capacity - v198
                        end
                    end
                end
            end)
            task.wait(v192.Length)
        end
        if p_u_187.IsReloading then
            p_u_187.Viewmodel.Animation:play("ReloadEnd").Ended:Once(function()
                -- upvalues: (copy) p_u_187
                p_u_187.IsReloading = false
            end)
        end
    else
        local v_u_199 = HttpService:GenerateGUID(false)
        p_u_187.CurrentReloadIdentity = v_u_199
        local v_u_200 = p_u_187.Viewmodel.Animation:play("Reload")
        local v201 = ("Client failed to fetch reload animation for %*."):format(p_u_187.Name)
        assert(v_u_200, v201)
        if v_u_200 then
            p_u_187.CharacterAnimator:play("Reload")
            m_Remotes.Spectate.ReplicateSpectateEvent.Send("Reload")
            v_u_200:GetMarkerReachedSignal("MagOut"):Once(function()
                -- upvalues: (ref) m_Remotes, (copy) p_u_187
                m_Remotes.Inventory.CreateMagazine.Send(p_u_187.Identifier)
            end)
            v_u_200:GetMarkerReachedSignal("MagIn"):Once(function()
                -- upvalues: (copy) p_u_187, (copy) v_u_199, (ref) m_Remotes, (ref) m_HintController, (copy) v_u_188
                local v202 = p_u_187
                local IsDestroyed_0 = not v202.IsDestroyed
                if IsDestroyed_0 then
                    IsDestroyed_0 = v202.IsEquipped == true
                end
                if IsDestroyed_0 then
                    local Rounds_0 = p_u_187.Properties.Rounds - p_u_187.Rounds
                    local v205 = math.abs(Rounds_0)
                    if p_u_187.CurrentReloadIdentity == v_u_199 then
                        m_Remotes.Inventory.ReloadWeapon.Send({
                            ["Identifier"] = p_u_187.Identifier,
                            ["Rounds"] = p_u_187.Rounds,
                            ["Capacity"] = p_u_187.Capacity
                        })
                        m_HintController:clearHint("Reload")
                        if v_u_188 then
                            p_u_187.Rounds = p_u_187.Properties.Rounds
                            p_u_187.Capacity = p_u_187.Properties.Capacity
                            return
                        end
                        if p_u_187.Capacity - v205 > 0 then
                            p_u_187.Rounds = p_u_187.Properties.Rounds
                            if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
                                local v206 = p_u_187
                                local v207 = p_u_187.Capacity - v205
                                v206.Capacity = math.max(0, v207)
                                return
                            end
                        elseif p_u_187.Capacity - v205 <= 0 then
                            p_u_187.Rounds = p_u_187.Rounds + p_u_187.Capacity
                            p_u_187.Capacity = 0
                        end
                    end
                end
            end)
            if p_u_187.ReloadTrackFinishedConnection and p_u_187.ReloadTrackFinishedConnection.Connected then
                p_u_187.ReloadTrackFinishedConnection:Disconnect()
            end
            p_u_187.ReloadTrackFinishedConnection = v_u_200:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                -- upvalues: (copy) p_u_187, (copy) v_u_200
                if not p_u_187.IsDestroyed then
                    if not v_u_200.IsPlaying and p_u_187.WeaponEquippedTick < p_u_187.ReloadStartTick then
                        p_u_187.IsReloading = false
                    end
                    if p_u_187.ReloadTrackFinishedConnection and p_u_187.ReloadTrackFinishedConnection.Connected then
                        p_u_187.ReloadTrackFinishedConnection:Disconnect()
                    end
                    p_u_187.ReloadTrackFinishedConnection = nil
                end
            end)
        end
    end
    return nil
end
function v_u_1.shoot(p_u_208, p209) -- name: shoot
    -- upvalues: (copy) LocalPlayer, (copy) m_GameState, (ref) v_u_1, (copy) v_u_34, (copy) v_u_28, (copy) m_CameraController, (ref) v_u_33, (copy) v_u_81, (copy) v_u_72, (copy) m_SoundController, (copy) m_Router, (copy) v_u_58, (copy) m_Remotes, (copy) m_DataController, (copy) m_CreateZeusBeam, (copy) m_Camera, (copy) m_CreateTracer, (copy) Players, (copy) m_CreateImpact, (copy) m_BreakGlass, (copy) m_CreateMarker, (copy) v_u_117, (copy) m_HapticsController, (copy) m_InputController
    local v210 = p209 or "Primary"
    local FireModes_9 = p_u_208.Properties.FireModes
    local Primary_2 = not FireModes_9 or (v210 or "Primary") == "Secondary" and FireModes_9.Secondary or FireModes_9.Primary
    local v_u_213 = Primary_2 and Primary_2.FireRate or (p_u_208.Properties.FireRate or 0.1)
    local IsChargeFiring_0 = p_u_208.Properties.ShootingOptions == "Revolver"
    if IsChargeFiring_0 then
        if v210 == "Primary" then
            IsChargeFiring_0 = p_u_208.IsChargeFiring
        else
            IsChargeFiring_0 = false
        end
    end
    local v215 = p_u_208.Viewmodel.Animation:getAnimation("Equip")
    if LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true then
        p_u_208.IsFireHeld = false
        p_u_208.FireInputBinding = nil
        p_u_208.IsAlternativeFireHeld = false
        p_u_208.AlternativeFireInputBinding = nil
        p_u_208.HasPendingChargeRequest = false
        if p_u_208.IsChargeFiring then
            p_u_208:cancelRevolverCharge(false, false)
        end
        return
    end
    if tick() - p_u_208.WeaponEquippedTick <= v215.Length * 0.925 or LocalPlayer and (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Dead")) then
        return
    end
    if m_GameState.GetState() == "Buy Period" then
        return
    end
    if pcall(function()
        -- upvalues: (copy) p_u_208
        local Properties_0 = p_u_208.Properties
        Properties_0.FireRate = Properties_0.FireRate + 1e-7
    end) then
        v_u_1 = {}
        while true do

        end
    end
    if v_u_34 and v_u_34[p_u_208.Name] then
        local v217 = v_u_34[p_u_208.Name]
        if p_u_208.Properties.FireRate < v217.FireRate or (p_u_208.Properties.BulletsPerShot > v217.BulletsPerShot or (p_u_208.Properties.Range > v217.Range or p_u_208.Properties.Penetration > v217.Penetration)) then
            v_u_1 = {}
            while true do

            end
        end
    end
    if not (p_u_208.Properties.FireRate and p_u_208.Properties.BulletsPerShot) then
        return
    end
    if p_u_208.IsAdjustingSuppressor then
        return
    end
    if p_u_208.IsReloading and p_u_208.Properties.MuzzleType ~= "ShotGun" then
        return
    end
    local v218 = p_u_208.Player
    if v218 then
        v218 = p_u_208.Player.Character
    end
    if not v218 then
        return
    end
    if not p_u_208.CharacterAnimator then
        return
    end
    if p_u_208.AlternativeShootingOption ~= "Burst" then
        p_u_208.ShootRequestTick = tick()
    end
    if p_u_208.IsShooting and p_u_208.AlternativeShootingOption == "Default" then
        return
    end
    local Interactables = p_u_208.Viewmodel.Model:FindFirstChild("Interactables")
    if not Interactables then
        return
    end
    if p_u_208.Rounds <= 0 then
        p_u_208:reload()
        return
    end
    local Rounds_1 = p_u_208.Properties.Rounds
    if Rounds_1 and p_u_208.Rounds <= Rounds_1 * 0.2 then
        v_u_28:play({
            ["Parent"] = nil,
            ["Name"] = "Low Ammo Fire",
            ["Parent"] = LocalPlayer.PlayerGui
        })
    end
    local ShootingHand = p_u_208.IsAiming and p_u_208.Properties.AimingOptions == "AutomaticScope" and "AimShoot" or "Shoot"
    local ShootingHand_0 = p_u_208.Properties.HasSuppressor and not p_u_208.IsSuppressed and "NoSuppressorShoot" or "Shoot"
    m_CameraController.toWeaponFirePosition()
    if not IsChargeFiring_0 and (p_u_208.IsInspecting or p_u_208.IsInspectFadingOut) then
        p_u_208:cancelInspect(nil, nil, true)
    end
    if not IsChargeFiring_0 then
        p_u_208:stopAllAnimations()
    end
    p_u_208.CurrentReloadIdentity = nil
    p_u_208.IsInspecting = false
    p_u_208.IsInspectFadingOut = false
    p_u_208.IsReloading = false
    p_u_208.IsShooting = true
    if p_u_208.ChargeThread then
        task.cancel(p_u_208.ChargeThread)
        p_u_208.ChargeThread = nil
    end
    if p_u_208.ChargeShootConnection and p_u_208.ChargeShootConnection.Connected then
        p_u_208.ChargeShootConnection:Disconnect()
    end
    p_u_208.ChargeShootConnection = nil
    p_u_208.HasPendingChargeRequest = false
    p_u_208.IsChargeFiring = false
    p_u_208.ChargeStartTick = 0
    p_u_208.CurrentWalkSpeedOverride = nil
    if not v_u_33 then
        p_u_208.Rounds = p_u_208.Rounds - 1
    end
    p_u_208.RechargeStartTime = workspace:GetServerTimeNow()
    if p_u_208.Properties.ShootingOptions == "Dual" then
        p_u_208.ShootingHand = p_u_208.ShootingHand == "Left" and "Right" or "Left"
        ShootingHand = "Shoot" .. p_u_208.ShootingHand
        ShootingHand_0 = "Shoot" .. p_u_208.ShootingHand
    end
    local v223, v224 = v_u_81(p_u_208, ShootingHand_0, ShootingHand, v210)
    if p_u_208.Properties.MuzzleType ~= "ShotGun" then
        p_u_208.CharacterAnimator:adjustAnimationSpeed(v224, v_u_213)
    end
    if p_u_208.Rounds > 150 then
        return
    end
    v_u_72(p_u_208)
    local Position_0 = v218.PrimaryPart.Position
    local v226 = p_u_208.Properties.HasSuppressor
    if v226 then
        v226 = p_u_208.IsSuppressed
    end
    local v227 = v226 == true
    local v228 = m_SoundController.GetWeaponShootRange(p_u_208.Name, v227)
    m_Router.broadcastRouter("UpdatePlayerNoiseCone", "Weapon", Position_0, v228, nil)
    if p_u_208.Bullet then
        local FireModes_10 = p_u_208.Properties.FireModes
        local Primary_3 = not FireModes_10 or (v210 or "Primary") == "Secondary" and FireModes_10.Secondary or FireModes_10.Primary
        local Spread_4 = Primary_3 and Primary_3.Spread or p_u_208.Properties.Spread
        p_u_208.Bullet:setSpreadConfig(Spread_4)
    end
    v_u_58(p_u_208, v210)
    local MuzzlePart = p_u_208.Properties.ShootingOptions == "Dual" and (p_u_208.ShootingHand == "Left" and Interactables:FindFirstChild("MuzzlePartL") or Interactables:FindFirstChild("MuzzlePartR")) or Interactables.MuzzlePart
    local Position_1 = MuzzlePart.Position
    debug.profilebegin("Weapon.BuildShootPacket")
    local v234 = {}
    local v235 = {}
    for _ = 1, p_u_208.Properties.BulletsPerShot do
        local v236 = p_u_208.Bullet:create(p_u_208.Properties.AimingOptions, p_u_208.IsAiming)
        if v236 then
            table.insert(v234, v236)
            local v237 = v236.Origin
            local v238 = {}
            for _, v239 in ipairs(v236.Hits) do
                local v240 = {
                    ["Distance"] = (v239.Position - v237).Magnitude,
                    ["Instance"] = v239.Instance,
                    ["Position"] = v239.Position,
                    ["Normal"] = v239.Normal,
                    ["Material"] = v239.Material,
                    ["Exit"] = v239.Exit
                }
                table.insert(v238, v240)
                v237 = v239.Position
            end
            local v241 = {
                ["Direction"] = v236.Direction,
                ["Origin"] = v236.Origin,
                ["Hits"] = v238
            }
            table.insert(v235, v241)
        end
    end
    debug.profileend()
    if IsChargeFiring_0 and p_u_208.Properties.ShootingOptions == "Revolver" then
        if p_u_208.Bullet then
            local FireModes_11 = p_u_208.Properties.FireModes
            local v243
            if FireModes_11 then
                v243 = FireModes_11.Secondary or FireModes_11.Primary
            else
                v243 = nil
            end
            local Spread_5 = v243 and v243.Spread or p_u_208.Properties.Spread
            p_u_208.Bullet:setSpreadConfig(Spread_5)
        end
        v_u_58(p_u_208, "Secondary")
    end
    debug.profilebegin("Weapon.SendShootPacket")
    m_Remotes.Inventory.ShootWeapon.Send({
        ["IsSniperScoped"] = p_u_208.IsSniperScoped,
        ["ShootingHand"] = p_u_208.ShootingHand,
        ["Identifier"] = p_u_208.Identifier,
        ["Capacity"] = p_u_208.Capacity,
        ["Bullets"] = v235,
        ["Rounds"] = p_u_208.Rounds
    })
    debug.profileend()
    local v245 = m_DataController.Get(LocalPlayer, "Settings.Video.Presets.First Person Tracers") ~= false
    local v246 = m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false
    if v246 then
        local v247
        if p_u_208.Properties.AimingOptions == "AutomaticScope" then
            v247 = p_u_208.IsAiming
        else
            v247 = false
        end
        v246 = not v247
    end
    local v248 = m_DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true
    local v249 = p_u_208.Properties.MuzzleType == "Zeus x27"
    local v250 = p_u_208.Properties.MuzzleType ~= "Zeus x27"
    local v251 = p_u_208.Properties.MuzzleType == "Zeus x27"
    if v249 then
        m_CreateZeusBeam(MuzzlePart)
    end
    if v246 and #v234 > 0 then
        m_Camera(MuzzlePart, p_u_208.Properties.HasSuppressor and p_u_208.IsSuppressed and "Suppressor" or p_u_208.Properties.MuzzleType)
    end
    for _, v252 in ipairs(v234) do
        if v245 then
            m_CreateTracer(v252.Distance, Position_1, v252.Direction)
        end
        local v253 = false
        for _, v254 in ipairs(v252.Hits) do
            local Instance = v254.Instance
            local Position_2 = v254.Position
            local Material = v254.Material
            local Normal = v254.Normal
            local Exit = v254.Exit
            local v260
            if Instance then
                v260 = Instance:FindFirstAncestorOfClass("Model")
            else
                v260 = Instance
            end
            local v261
            if v260 == nil then
                v261 = false
            else
                v261 = Players:GetPlayerFromCharacter(v260) ~= nil
            end
            if v261 then
                if v248 then
                    m_CreateImpact(Instance, "Blood Splatter", Position_2, Normal, Exit, false, true, nil, v253, nil, v251)
                end
            else
                v253 = not Exit and true or v253
                if v250 then
                    m_CreateImpact(Instance, Material, Position_2, Normal, Exit, false, true)
                end
                local Parent = Instance.Parent
                if Parent and (Parent:HasTag("BreakableGlass") and not Exit) then
                    m_BreakGlass(Instance, Position_2, v252.Direction)
                elseif not (Instance:HasTag("BreakableGlass") or Parent and Parent:HasTag("BreakableGlass")) and v250 then
                    m_CreateMarker(Instance, "Bullet", Position_2, Normal)
                end
                if Parent and (Parent:HasTag("BreakableDoor") and (p_u_208.Properties.Penetration or 0) <= 0) then
                    break
                end
            end
        end
    end
    if p_u_208.Viewmodel.Model.CameraShake then
        v_u_117(p_u_208.Viewmodel.Model.CameraShake)
    end
    p_u_208.Viewmodel.Bobble:addScopeKick()
    if p_u_208.Viewmodel.applyCharmImpulse then
        local LookVector = p_u_208.Viewmodel.Model.WorldPivot.LookVector
        local UpVector = p_u_208.Viewmodel.Model.WorldPivot.UpVector
        local v265 = LookVector * -1 + UpVector * 0.3
        p_u_208.Viewmodel:applyCharmImpulse(v265)
    end
    if p_u_208.Recoil then
        local Recoil_2 = p_u_208.Recoil
        Recoil_2.Time = Recoil_2.Time + v_u_213
    end
    m_Remotes.Spectate.ReplicateSpectateEvent.Send(IsChargeFiring_0 and "RevolverChargeRelease" or v223)
    local IsAiming = p_u_208.IsAiming
    if IsAiming then
        IsAiming = p_u_208.Properties.AimingOptions == "SniperScope"
    end
    if IsAiming then
        p_u_208:unscope(true)
    end
    local v268
    if IsChargeFiring_0 then
        v268 = p_u_208.Viewmodel.Animation:getAnimation(v223)
    else
        v268 = p_u_208.Viewmodel.Animation:play(v223)
    end
    if IsChargeFiring_0 then
        if not (v268 and v268.IsPlaying) then
            v268 = p_u_208.Viewmodel.Animation:play(v223)
            p_u_208.CharacterAnimator:play(v224)
        end
    else
        p_u_208.CharacterAnimator:play(v224)
    end
    m_HapticsController.vibrate(Enum.VibrationMotor.Small, 1.25, 0.225)
    if p_u_208.ShootDelayThread then
        task.cancel(p_u_208.ShootDelayThread)
        p_u_208.ShootDelayThread = nil
    end
    local v269 = v_u_213 or (v268 and v268.Length or 0.1)
    p_u_208.ShootDelayThread = task.delay(v269, function()
        -- upvalues: (copy) p_u_208, (copy) IsAiming, (ref) m_DataController, (ref) LocalPlayer, (ref) m_InputController, (copy) v_u_213
        if p_u_208.IsDestroyed then
            return
        else
            p_u_208.IsShooting = false
            p_u_208.ShootDelayThread = nil
            local v270 = p_u_208
            local IsDestroyed_1 = not v270.IsDestroyed
            if IsDestroyed_1 then
                IsDestroyed_1 = v270.IsEquipped == true
            end
            if IsDestroyed_1 then
                if IsAiming and (p_u_208.ShootRequestTick > p_u_208.WeaponEquippedTick and (p_u_208.Rounds > 0 and m_DataController.Get(LocalPlayer, "Settings.Game.Item.Auto Re-Zoom Sniper Rifle after Shot") == true)) then
                    p_u_208:scope(true)
                end
                if p_u_208.Properties.ShootingOptions == "Revolver" then
                    local v272 = p_u_208.IsAlternativeFireHeld == true
                    if v272 and (p_u_208.AlternativeFireInputBinding and not m_InputController.isBindingPressed(p_u_208.AlternativeFireInputBinding)) then
                        p_u_208.IsAlternativeFireHeld = false
                        p_u_208.AlternativeFireInputBinding = nil
                        v272 = false
                    end
                    local FireModes_12 = p_u_208.Properties.FireModes
                    local v274
                    if FireModes_12 then
                        v274 = FireModes_12.Secondary or FireModes_12.Primary
                    else
                        v274 = nil
                    end
                    if v272 and (v274 and v274.HoldRepeat) then
                        if p_u_208.Rounds > 0 then
                            p_u_208:shoot("Secondary")
                        else
                            p_u_208:reload()
                        end
                    else
                        local v275 = p_u_208.IsFireHeld == true
                        if v275 and (p_u_208.FireInputBinding and not m_InputController.isBindingPressed(p_u_208.FireInputBinding)) then
                            p_u_208.IsFireHeld = false
                            p_u_208.FireInputBinding = nil
                            v275 = false
                        end
                        local FireModes_13 = p_u_208.Properties.FireModes
                        local v277
                        if FireModes_13 then
                            v277 = FireModes_13.Primary
                        else
                            v277 = nil
                        end
                        if v275 and (v277 and v277.HoldRepeat) then
                            if p_u_208.Rounds > 0 then
                                p_u_208:startRevolverCharge(p_u_208.FireInputBinding)
                            else
                                p_u_208:reload()
                            end
                        else
                            if p_u_208.HasPendingChargeRequest == true then
                                p_u_208.HasPendingChargeRequest = false
                                if v275 then
                                    p_u_208:startRevolverCharge(p_u_208.FireInputBinding)
                                end
                            end
                            return
                        end
                    end
                else
                    local v278 = tick()
                    local v279 = v_u_213
                    local ShootRequestTick_0 = math.min(0.15, v279) >= v278 - p_u_208.ShootRequestTick
                    local v281 = p_u_208.IsFireHeld == true
                    if v281 and (p_u_208.FireInputBinding and not m_InputController.isBindingPressed(p_u_208.FireInputBinding)) then
                        p_u_208.IsFireHeld = false
                        p_u_208.FireInputBinding = nil
                        v281 = false
                    end
                    if p_u_208.Properties.Automatic and v281 and v281 or (not p_u_208.Properties.Automatic and (ShootRequestTick_0 and not v281) or false) then
                        if p_u_208.Properties.ShootingOptions == "Burst" and p_u_208.AlternativeShootingOption == "Burst" then
                            return
                        elseif p_u_208.Rounds > 0 then
                            p_u_208:shoot()
                        else
                            p_u_208:reload()
                        end
                    else
                        return
                    end
                end
            else
                return
            end
        end
    end)
end
function v_u_1.equip(p_u_282) -- name: equip
    -- upvalues: (copy) m_GameState, (copy) LocalPlayer, (copy) m_InputController, (copy) v_u_41, (copy) v_u_31, (copy) v_u_30, (copy) v_u_58
    p_u_282.IsEquipped = true
    if p_u_282.Bullet then
        p_u_282.Bullet:setActive(true)
    end
    if p_u_282.Viewmodel.Hidden then
        p_u_282.Viewmodel:unhide()
    end
    p_u_282.Viewmodel.Animation:stopAnimations()
    p_u_282.CharacterAnimator:stopAnimations()
    p_u_282.CharacterAnimator:play("Idle")
    p_u_282.CharacterAnimator:play("Equip")
    p_u_282.WeaponEquippedTick = tick()
    p_u_282.Viewmodel:equip(false)
    if p_u_282.Janitor:Get("EquipDelayFire") then
        p_u_282.Janitor:Remove("EquipDelayFire")
    end
    local v283 = p_u_282.Viewmodel.Animation:getAnimation("Equip")
    local v284 = v283 and (v283.Length and (v283.Length > 0 and v283.Length * 0.925)) or 0.5
    local v_u_287 = task.delay(v284, function()
        -- upvalues: (copy) p_u_282, (ref) m_GameState, (ref) LocalPlayer, (ref) m_InputController, (ref) v_u_41, (ref) v_u_31, (ref) v_u_30
        if p_u_282.IsDestroyed then
            return
        elseif p_u_282.IsEquipped then
            if m_GameState.GetState() == "Buy Period" then
                return
            elseif LocalPlayer:GetAttribute("IsDefusingBomb") == true or LocalPlayer:GetAttribute("IsLocallyDefusingBomb") == true then
                p_u_282.IsFireHeld = false
                p_u_282.FireInputBinding = nil
                p_u_282.IsAlternativeFireHeld = false
                p_u_282.AlternativeFireInputBinding = nil
                p_u_282.HasPendingChargeRequest = false
                return
            else
                if p_u_282.Properties.ShootingOptions == "Revolver" and (p_u_282.IsAlternativeFireHeld or m_InputController.isActionActive("SecondaryFire")) then
                    local v285 = p_u_282.AlternativeFireInputBinding or v_u_41("SecondaryFire", v_u_31)
                    if v285 or p_u_282.IsAlternativeFireHeld then
                        p_u_282:startRevolverSecondaryFire(v285)
                        return
                    end
                end
                if m_InputController.isActionActive("Fire") then
                    local v286 = v_u_41("Fire", v_u_30)
                    if v286 then
                        if p_u_282.Properties.ShootingOptions == "Revolver" then
                            p_u_282:startRevolverCharge(v286)
                            return
                        end
                        p_u_282.IsFireHeld = true
                        p_u_282.FireInputBinding = v286
                        p_u_282:shoot()
                    end
                end
            end
        else
            return
        end
    end)
    p_u_282.Janitor:Add(function()
        -- upvalues: (copy) v_u_287
        task.cancel(v_u_287)
    end, false, "EquipDelayFire")
    p_u_282.CurrentScopeIncrement = 0
    p_u_282.IsBurstShooting = false
    p_u_282.IsInspectFadingOut = false
    p_u_282.IsInspecting = false
    p_u_282.IsReloading = false
    p_u_282.IsShooting = false
    p_u_282.IsFireHeld = false
    p_u_282.FireInputBinding = nil
    p_u_282.HasPendingChargeRequest = false
    p_u_282.IsAlternativeFireHeld = false
    p_u_282.AlternativeFireInputBinding = nil
    p_u_282.IsAiming = false
    p_u_282.IsChargeFiring = false
    p_u_282.ScopeStartTick = 0
    p_u_282.IsAdjustingSuppressor = false
    p_u_282.CurrentWalkSpeedOverride = nil
    p_u_282.ChargeStartTick = 0
    p_u_282.ChargeThread = nil
    p_u_282.ChargeShootConnection = nil
    if p_u_282.Properties.ShootingOptions == "Revolver" then
        if p_u_282.Bullet then
            local FireModes_14 = p_u_282.Properties.FireModes
            local v289
            if FireModes_14 then
                v289 = FireModes_14.Secondary or FireModes_14.Primary
            else
                v289 = nil
            end
            local Spread_6 = v289 and v289.Spread or p_u_282.Properties.Spread
            p_u_282.Bullet:setSpreadConfig(Spread_6)
        end
        v_u_58(p_u_282, "Secondary")
    end
    local Name_1 = p_u_282.Name
    if Name_1 == "SSG 08" and true or Name_1 == "AWP" then
        p_u_282.IsSniperScoped = false
        if p_u_282.Name == "AWP" and p_u_282.Player then
            p_u_282.Player:SetAttribute("IsSniperScoped", false)
        end
    end
end
function v_u_1.unequip(p292) -- name: unequip
    -- upvalues: (copy) ReplicatedStorage, (copy) m_CameraController, (copy) m_Constants
    p292.IsEquipped = false
    if p292.Bullet then
        p292.Bullet:setActive(false)
    end
    p292:cancelRevolverCharge(false, false)
    p292:stopRevolverSecondaryFire()
    if p292.Janitor:Get("EquipDelayFire") then
        p292.Janitor:Remove("EquipDelayFire")
    end
    if p292.ShootDelayThread then
        task.cancel(p292.ShootDelayThread)
        p292.ShootDelayThread = nil
    end
    local m_CaseSceneController_0 = require(ReplicatedStorage.Controllers.CaseSceneController)
    local m_MenuSceneController_0 = require(ReplicatedStorage.Controllers.MenuSceneController)
    if not (m_CaseSceneController_0.IsActive() or m_MenuSceneController_0.IsActive()) then
        m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
    end
    p292.CharacterAnimator:stopAnimations()
    p292.Viewmodel:unequip()
    if p292.IsAiming then
        p292:unscope()
    end
    if p292.Viewmodel.Hidden then
        p292.Viewmodel:unhide()
    end
    p292.IsBurstShooting = false
    p292.IsInspectFadingOut = false
    p292.IsInspecting = false
    p292.IsReloading = false
    p292.IsShooting = false
    p292.IsFireHeld = false
    p292.FireInputBinding = nil
    p292.HasPendingChargeRequest = false
    p292.IsAlternativeFireHeld = false
    p292.AlternativeFireInputBinding = nil
    p292.IsAiming = false
    p292.IsChargeFiring = false
    p292.IsAdjustingSuppressor = false
    p292.CurrentWalkSpeedOverride = nil
    p292.ChargeStartTick = 0
    p292.ChargeThread = nil
    p292.ChargeShootConnection = nil
    local Name_2 = p292.Name
    if Name_2 == "SSG 08" and true or Name_2 == "AWP" then
        p292.IsSniperScoped = false
        if p292.Name == "AWP" and p292.Player then
            p292.Player:SetAttribute("IsSniperScoped", false)
        end
    end
    if p292.Recoil then
        p292.Recoil.Function = p292.Recoil.Functions.Default
        p292.Recoil.ActiveFireRate = p292.Properties.FireRate or 0.1
        p292.Recoil.Value = Vector2.zero
        p292.Recoil.RecoveryValue = Vector2.zero
        p292.Recoil.RecoveryTime = 0
        p292.Recoil.RecoveryStartTime = 0
        p292.Recoil.Time = 0
    end
end
function v_u_1.createSuppressor(p_u_296) -- name: createSuppressor
    -- upvalues: (copy) m_Remotes
    local Silencer = p_u_296.Viewmodel.Model:FindFirstChild("Silencer", true)
    if Silencer then
        Silencer.Transparency = p_u_296.IsSuppressed and 0 or 1
        local Identifier_0 = p_u_296.Identifier
        local v_u_299 = false
        local v300 = p_u_296.Viewmodel.Animation:getAnimation("RemoveSuppressor")
        local v_u_301 = p_u_296.Viewmodel.Animation:getAnimation("AddSuppressor")
        p_u_296.Janitor:Add(v300:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function()
            -- upvalues: (copy) p_u_296, (copy) Silencer, (ref) m_Remotes, (copy) Identifier_0
            if not p_u_296.IsDestroyed then
                Silencer.Transparency = 1
                local v302 = {
                    ["Identifier"] = nil,
                    ["State"] = false,
                    ["Identifier"] = Identifier_0
                }
                m_Remotes.Inventory.UpdateWeaponSuppressor.Send(v302)
            end
        end))
        p_u_296.Janitor:Add(v300.Ended:Connect(function()
            -- upvalues: (copy) p_u_296, (copy) Silencer, (ref) m_Remotes, (copy) Identifier_0
            p_u_296.IsAdjustingSuppressor = false
            if Silencer.Transparency < 1 == false then
                if not p_u_296.IsDestroyed then
                    Silencer.Transparency = 1
                    local v303 = {
                        ["Identifier"] = nil,
                        ["State"] = false,
                        ["Identifier"] = Identifier_0
                    }
                    m_Remotes.Inventory.UpdateWeaponSuppressor.Send(v303)
                end
                p_u_296.IsSuppressed = false
            end
        end))
        p_u_296.Janitor:Add(v_u_301:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function()
            -- upvalues: (ref) v_u_299, (copy) p_u_296, (copy) Silencer, (ref) m_Remotes, (copy) Identifier_0
            v_u_299 = true
            if not p_u_296.IsDestroyed then
                Silencer.Transparency = 0
                local v304 = {
                    ["Identifier"] = nil,
                    ["State"] = true,
                    ["Identifier"] = Identifier_0
                }
                m_Remotes.Inventory.UpdateWeaponSuppressor.Send(v304)
            end
            p_u_296.IsSuppressed = true
        end))
        p_u_296.Janitor:Add(v_u_301:GetPropertyChangedSignal("IsPlaying"):Connect(function()
            -- upvalues: (copy) v_u_301, (ref) v_u_299, (copy) Silencer
            if v_u_301.IsPlaying then
                v_u_299 = false
                task.delay(0.016666666666666666, function()
                    -- upvalues: (ref) v_u_301, (ref) Silencer
                    if v_u_301.IsPlaying then
                        Silencer.Transparency = 0
                    end
                end)
            end
        end))
        p_u_296.Janitor:Add(v_u_301.Ended:Connect(function()
            -- upvalues: (copy) p_u_296, (ref) v_u_299, (copy) Silencer
            p_u_296.IsAdjustingSuppressor = false
            if not v_u_299 then
                Silencer.Transparency = 1
            end
        end))
    end
end
function v_u_1.setupRecoil(p_u_305) -- name: setupRecoil
    -- upvalues: (copy) m_RunServiceController, (copy) m_CameraController
    local Recoil_3 = p_u_305.Properties.Recoil
    if p_u_305.Properties.Recoil then
        local RecoverySpeed = Recoil_3.RecoverySpeed
        local Scale = Recoil_3.Scale
        local Damper = Recoil_3.Damper
        local Speed = Recoil_3.Speed
        local CameraScale = Recoil_3.CameraScale
        local Identifier_1 = p_u_305.Identifier
        local v313 = Recoil_3.Pattern(p_u_305.Properties)
        local v314 = {
            ["Function"] = nil,
            ["Functions"] = nil,
            ["Value"] = nil,
            ["RotationValue"] = Vector3.new(0, 0, 0),
            ["ActiveFireRate"] = nil,
            ["Time"] = 0,
            ["RecoveryValue"] = nil,
            ["RecoveryTime"] = 0,
            ["RecoveryStartTime"] = 0,
            ["Function"] = v313,
            ["Functions"] = {
                ["Default"] = v313
            },
            ["Value"] = Vector2.zero,
            ["ActiveFireRate"] = p_u_305.Properties.FireRate or 0.1,
            ["RecoveryValue"] = Vector2.zero
        }
        p_u_305.Recoil = v314
        local Recoil = p_u_305.Recoil
        p_u_305.Janitor:Add(m_RunServiceController.BindToStepped(("Components.Weapon.%*.Recoil"):format(p_u_305.Identifier), function(_, _)
            -- upvalues: (copy) p_u_305, (copy) Recoil, (copy) RecoverySpeed, (copy) Scale, (copy) Identifier_1, (ref) m_CameraController, (copy) Damper, (copy) Speed, (copy) CameraScale
            if not p_u_305.IsDestroyed and (Recoil and p_u_305.IsEquipped) then
                local v316 = Recoil.Function(Recoil.Time)
                if p_u_305.IsShooting then
                    Recoil.Value = v316
                    Recoil.RecoveryValue = v316
                    Recoil.RecoveryTime = Recoil.Time
                    Recoil.RecoveryStartTime = os.clock()
                else
                    local v317 = Recoil.RecoveryValue.Magnitude / RecoverySpeed
                    if v317 > 0 then
                        local v318 = (os.clock() - Recoil.RecoveryStartTime) / v317
                        local v319 = math.clamp(v318, 0, 1)
                        Recoil.Value = Recoil.RecoveryValue:Lerp(Vector2.zero, v319)
                        Recoil.Time = Recoil.RecoveryTime * (1 - v319)
                    else
                        Recoil.Value = Vector2.zero
                        Recoil.Time = 0
                    end
                end
                local v320 = Recoil.Value.Y
                local v321 = Recoil.Value.X
                local v322 = Vector3.new(v320, v321, 0)
                local v323 = Scale
                local v324 = v322 * math.rad(v323)
                Recoil.RotationValue = v324
                if not p_u_305.IsDestroyed and (p_u_305.IsEquipped and p_u_305.Identifier == Identifier_1) then
                    local v325 = {
                        ["Value"] = v324,
                        ["Damper"] = Damper,
                        ["Speed"] = Speed
                    }
                    m_CameraController.setWeaponRecoil(v325, CameraScale)
                end
            end
        end), "Disconnect", "RecoilConnection")
    end
end
function v_u_1.new(p326, p327, p328, p329, p330, p331, p332, p333, p334, p335, p336, p337, p338) -- name: new
    -- upvalues: (copy) m_WeaponComponent, (ref) v_u_1, (copy) m_Bullet, (copy) v_u_58, (copy) ReplicatedStorage, (copy) m_CameraController, (copy) m_Constants, (copy) v_u_72
    local v339 = m_WeaponComponent.new(p326, p327, p328, p329, p330, p331, p332, p333, p334, p335, p336, p337)
    local v340 = v_u_1
    local v_u_341 = setmetatable(v339, v340)
    v_u_341.IsEquipped = false
    local v342 = p338 or {}
    v_u_341.Bullet = m_Bullet.new(v_u_341, v_u_341.Properties)
    v_u_341.Capacity = v342.Capacity or v_u_341.Properties.Capacity
    v_u_341.Rounds = v342.Rounds or v_u_341.Properties.Rounds
    v_u_341.RechargeStartTime = v342.RechargeStartTime
    v_u_341.CurrentReloadIdentity = nil
    v_u_341.AlternativeShootingOption = "Default"
    v_u_341.AlternativeSwitchTick = 0
    v_u_341.IsBurstShooting = false
    v_u_341.ShootingHand = "Right"
    v_u_341.HasPendingChargeRequest = false
    v_u_341.IsAlternativeFireHeld = false
    v_u_341.AlternativeFireInputBinding = nil
    v_u_341.IsChargeFiring = false
    v_u_341.CurrentWalkSpeedOverride = nil
    v_u_341.IsAdjustingSuppressor = false
    v_u_341.IsInspectFadingOut = false
    v_u_341.IsInspecting = false
    v_u_341.IsReloading = false
    v_u_341.IsShooting = false
    v_u_341.IsAiming = false
    v_u_341.IsFireHeld = false
    v_u_341.FireInputBinding = nil
    v_u_341.ScopeStartTick = 0
    if v342.IsSuppressed == nil then
        v_u_341.IsSuppressed = v_u_341.Properties.HasSuppressor
    else
        v_u_341.IsSuppressed = v342.IsSuppressed
    end
    v_u_341.IsSniperScoped = false
    v_u_341.ReloadTrackFinishedConnection = nil
    v_u_341.ShootDelayThread = nil
    v_u_341.InspectDelayThread = nil
    v_u_341.CancelDelayThread = nil
    v_u_341.FadeCompleteThread = nil
    v_u_341.ChargeThread = nil
    v_u_341.RechargeThread = nil
    v_u_341.ChargeShootConnection = nil
    v_u_341.CurrentScopeIncrement = 0
    v_u_341.WeaponEquippedTick = 0
    v_u_341.ChargeStartTick = 0
    v_u_341.ShootRequestTick = 0
    v_u_341.ReloadStartTick = 0
    v_u_341.ScopeStartTick = 0
    v_u_341:setupRecoil()
    if v_u_341.Properties.ShootingOptions == "Revolver" then
        if v_u_341.Bullet then
            local FireModes_15 = v_u_341.Properties.FireModes
            local v344
            if FireModes_15 then
                v344 = FireModes_15.Secondary or FireModes_15.Primary
            else
                v344 = nil
            end
            local Spread_7 = v344 and v344.Spread or v_u_341.Properties.Spread
            v_u_341.Bullet:setSpreadConfig(Spread_7)
        end
        v_u_58(v_u_341, "Secondary")
    end
    v_u_341.Janitor:Add(function()
        -- upvalues: (copy) v_u_341, (ref) ReplicatedStorage, (ref) m_CameraController, (ref) m_Constants
        v_u_341:cancelRevolverCharge(false, false)
        v_u_341:stopRevolverSecondaryFire()
        if v_u_341.Bullet then
            v_u_341.Bullet:destroy()
            v_u_341.Bullet = nil
        end
        if v_u_341.IsAiming then
            local m_CaseSceneController_1 = require(ReplicatedStorage.Controllers.CaseSceneController)
            local m_MenuSceneController_1 = require(ReplicatedStorage.Controllers.MenuSceneController)
            if not (m_CaseSceneController_1.IsActive() or m_MenuSceneController_1.IsActive()) then
                m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
            end
        end
    end)
    if v_u_341.Properties.HasSuppressor then
        v_u_341:createSuppressor()
    end
    if v_u_341.Rounds < (v_u_341.Properties.Rounds or v_u_341.Rounds) then
        v_u_72(v_u_341)
    end
    return v_u_341
end
function v_u_1.destroy(p348) -- name: destroy
    -- upvalues: (copy) m_WeaponComponent
    if not p348.IsDestroyed then
        p348.IsDestroyed = true
        if p348.ReloadTrackFinishedConnection and p348.ReloadTrackFinishedConnection.Connected then
            p348.ReloadTrackFinishedConnection:Disconnect()
            p348.ReloadTrackFinishedConnection = nil
        end
        if p348.ShootDelayThread then
            task.cancel(p348.ShootDelayThread)
            p348.ShootDelayThread = nil
        end
        if p348.ChargeThread then
            task.cancel(p348.ChargeThread)
            p348.ChargeThread = nil
        end
        if p348.RechargeThread then
            task.cancel(p348.RechargeThread)
            p348.RechargeThread = nil
        end
        if p348.ChargeShootConnection and p348.ChargeShootConnection.Connected then
            p348.ChargeShootConnection:Disconnect()
            p348.ChargeShootConnection = nil
        end
        if p348.InspectDelayThread then
            task.cancel(p348.InspectDelayThread)
            p348.InspectDelayThread = nil
        end
        if p348.CancelDelayThread then
            task.cancel(p348.CancelDelayThread)
            p348.CancelDelayThread = nil
        end
        if p348.FadeCompleteThread then
            task.cancel(p348.FadeCompleteThread)
            p348.FadeCompleteThread = nil
        end
        if p348.Recoil then
            p348.Recoil.RecoveryStartTime = nil
            p348.Recoil.RotationValue = nil
            p348.Recoil.RecoveryValue = nil
            p348.Recoil.RecoveryTime = nil
            p348.Recoil.ActiveFireRate = nil
            p348.Recoil.Function = nil
            p348.Recoil.Functions = nil
            p348.Recoil.Value = nil
            p348.Recoil.Time = nil
            p348.Recoil = nil
        end
        if p348.Bullet then
            p348.Bullet:destroy()
            p348.Bullet = nil
        end
        p348.Janitor:Destroy()
        p348.Janitor = nil
        p348.AlternativeShootingOption = nil
        p348.AlternativeSwitchTick = nil
        p348.CurrentReloadIdentity = nil
        p348.CurrentScopeIncrement = nil
        p348.WeaponEquippedTick = nil
        p348.ChargeStartTick = nil
        p348.ShootRequestTick = nil
        p348.ReloadStartTick = nil
        p348.ShootingHand = nil
        p348.CurrentWalkSpeedOverride = nil
        p348.HasPendingChargeRequest = nil
        p348.IsAlternativeFireHeld = nil
        p348.AlternativeFireInputBinding = nil
        p348.IsChargeFiring = nil
        p348.ChargeThread = nil
        p348.ChargeShootConnection = nil
        m_WeaponComponent.destroy(p348)
    end
end
return v_u_1
