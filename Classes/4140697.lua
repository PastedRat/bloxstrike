-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
game:GetService("RunService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local m_RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray)
local m_Camera = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Camera)
local m_CreateZeusBeam = require(ReplicatedStorage.Components.Common.VFXLibary.CreateZeusBeam)
local m_CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer)
local m_WeaponComponent = require(ReplicatedStorage.Classes.WeaponComponent)
local m_Freecam = require(ReplicatedStorage.Classes.Freecam)
local m_Bullet = require(ReplicatedStorage.Components.Weapon.Classes.Bullet)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Signal = require(ReplicatedStorage.Packages.Signal)
local m_Spring = require(ReplicatedStorage.Shared.Spring)
local m_Sift = require(ReplicatedStorage.Packages.Sift)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local Characters = workspace:WaitForChild("Characters")
local Debris = workspace:WaitForChild("Debris")
local CurrentCamera = workspace.CurrentCamera
local v_u_24 = RaycastParams.new()
v_u_24.FilterType = Enum.RaycastFilterType.Exclude
v_u_24.IgnoreWater = true
local v_u_25 = {
    ["Heavy Swing"] = true,
    ["BackStab"] = true,
    ["Swing1"] = true,
    ["Swing2"] = true,
    ["Inspect"] = true,
    ["Reload"] = true,
    ["Throw"] = true,
    ["Use"] = true
}
local v_u_26 = {
    ["StartThrow"] = true
}
local v_u_27 = {
    ["NoSuppressorShoot"] = true,
    ["ShootRight"] = true,
    ["ShootLeft"] = true,
    ["Shoot"] = true,
    ["SlamFire"] = true
}
local function v_u_36(p28, p29) -- name: cacheAndHideInstance
    if p29:IsA("BasePart") then
        local v30 = p28.Transparencies[p29] or {
            ["Transparency"] = p29.Transparency,
            ["Textures"] = {}
        }
        for _, v31 in p29:GetChildren() do
            if v31:IsA("Texture") and not table.find(v30.Textures, v31) then
                local Textures = v30.Textures
                table.insert(Textures, v31)
                v31.Parent = nil
            end
        end
        if p29.Transparency < 1 then
            p29.Transparency = 1
        end
        p28.Transparencies[p29] = v30
    elseif p29:IsA("Texture") then
        local Parent = p29.Parent
        if Parent and Parent:IsA("BasePart") then
            local v34 = p28.Transparencies[Parent] or {
                ["Transparency"] = Parent.Transparency,
                ["Textures"] = {}
            }
            if not table.find(v34.Textures, p29) then
                local Textures_0 = v34.Textures
                table.insert(Textures_0, p29)
            end
            p29.Parent = nil
            p28.Transparencies[Parent] = v34
            return
        end
    elseif p29:IsA("BillboardGui") then
        p29.Enabled = false
    end
end
local function v_u_42(p37) -- name: syncSpectatedRechargeAfterShot
    if p37 and (p37.Properties and p37.Properties.RechargeTime) then
        local Rounds = p37.Properties.Rounds
        local v39 = tonumber(Rounds) or 0
        local Rounds_0 = p37.Rounds
        local v41 = (tonumber(Rounds_0) or v39) - 1
        p37.Rounds = math.max(v41, 0)
        p37.RechargeStartTime = workspace:GetServerTimeNow()
    end
end
local function v_u_50(p43) -- name: recreateSpectatedShotEffects
    -- upvalues: (copy) CurrentCamera, (copy) Debris, (copy) v_u_24, (copy) m_CreateTracer, (copy) m_CreateZeusBeam, (copy) m_DataController, (copy) LocalPlayer, (copy) m_Camera
    v_u_24.FilterDescendantsInstances = { p43.Player.Character, CurrentCamera, Debris }
    local WeaponComponent = p43.WeaponComponent
    if WeaponComponent and WeaponComponent.Bullet then
        local AimingOptions = WeaponComponent.Properties.AimingOptions
        local IsAiming = WeaponComponent.IsAiming
        if WeaponComponent.Bullet._updateShotSpread then
            WeaponComponent.Bullet:_updateShotSpread(AimingOptions, IsAiming)
        end
    end
    local v47 = workspace:Raycast(CurrentCamera.CFrame.Position, CurrentCamera.CFrame.LookVector * p43.WeaponComponent.Properties.Range, v_u_24)
    local Range = v47 and v47.Distance or p43.WeaponComponent.Properties.Range
    local MuzzlePart = p43.WeaponComponent.Viewmodel.Model.Interactables:FindFirstChild("MuzzlePart")
    if MuzzlePart then
        m_CreateTracer(Range, MuzzlePart.Position, CurrentCamera.CFrame.LookVector)
        if p43.WeaponComponent.Properties.MuzzleType == "Zeus x27" then
            m_CreateZeusBeam(MuzzlePart)
        end
        if m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false then
            m_Camera(MuzzlePart, p43.WeaponComponent.Properties.HasSuppressor and p43.CurrentEquipped.IsSuppressed and "Suppressor" or p43.WeaponComponent.Properties.MuzzleType)
        end
    end
end
function v_u_1.UpdateCameraCFrame(p51, p52) -- name: UpdateCameraCFrame
    -- upvalues: (copy) m_Spring
    if not (p51.CameraPositionSpring and p51.CameraRotationSpring) then
        p51.CameraRotationSpring = m_Spring.new(1, 35, p52.LookVector)
        p51.CameraPositionSpring = m_Spring.new(1, 35, p52.Position)
    end
    p51.CameraRotationSpring:setGoal(p52.LookVector)
    p51.CameraPositionSpring:setGoal(p52.Position)
end
function v_u_1.UpdateSuppressorState(p53, p54) -- name: UpdateSuppressorState
    local Silencer_0 = p54.Viewmodel.Model:FindFirstChild("Silencer", true)
    if Silencer_0 and p54.Properties.HasSuppressor then
        Silencer_0.Transparency = p53.CurrentEquipped.IsSuppressed and 0 or 1
    end
end
function v_u_1.UpdateSuppressor(p56) -- name: UpdateSuppressor
    if p56.WeaponComponent and p56.WeaponComponent.Viewmodel then
        local Silencer = p56.WeaponComponent.Viewmodel.Model:FindFirstChild("Silencer", true)
        if Silencer then
            local v60 = table.freeze({
                {
                    ["AnimationTrack"] = nil,
                    ["State"] = false,
                    ["Event"] = nil,
                    ["AnimationTrack"] = p56.WeaponComponent.Viewmodel.Animation:getAnimation("RemoveSuppressor"),
                    ["Event"] = function(p58) -- name: Event
                        -- upvalues: (copy) Silencer
                        return p58:GetMarkerReachedSignal("ScrewOnEnd"):Connect(function()
                            -- upvalues: (ref) Silencer
                            Silencer.Transparency = 1
                        end)
                    end
                },
                {
                    ["AnimationTrack"] = nil,
                    ["State"] = true,
                    ["Event"] = nil,
                    ["AnimationTrack"] = p56.WeaponComponent.Viewmodel.Animation:getAnimation("AddSuppressor"),
                    ["Event"] = function(p_u_59) -- name: Event
                        -- upvalues: (copy) Silencer
                        return p_u_59:GetPropertyChangedSignal("IsPlaying"):Connect(function()
                            -- upvalues: (copy) p_u_59, (ref) Silencer
                            if p_u_59.IsPlaying then
                                task.delay(0.016666666666666666, function()
                                    -- upvalues: (ref) Silencer
                                    Silencer.Transparency = 0
                                end)
                            end
                        end)
                    end
                }
            })
            for _, v_u_61 in ipairs(v60) do
                if p56.WeaponComponent and p56.WeaponComponent.Janitor then
                    p56.WeaponComponent.Janitor:Add(v_u_61.Event(v_u_61.AnimationTrack))
                    p56.WeaponComponent.Janitor:Add(v_u_61.AnimationTrack.Ended:Connect(function()
                        -- upvalues: (copy) Silencer, (copy) v_u_61
                        if Silencer.Transparency < 1 == v_u_61.State then
                            Silencer.Transparency = v_u_61.State and 0 or 1
                        end
                    end))
                end
            end
            p56:UpdateSuppressorState(p56.WeaponComponent)
        end
    else
        return
    end
end
function v_u_1.Switch(p62, p63) -- name: Switch
    -- upvalues: (copy) CurrentCamera, (copy) m_CameraController, (copy) m_Constants, (copy) m_Freecam, (copy) m_Remotes
    if p62.Humanoid and p62.Humanoid.Health > 0 then
        p62.PerspectiveState = p63
        if p62.FreecamInstance then
            p62.FreecamInstance:Stop()
            p62.FreecamInstance:Destroy()
            p62.FreecamInstance = nil
        end
        if p62.PerspectiveState == "First-Person" then
            p62.TransparencyState = true
            p62:SetCharacterTransparency(p62.TransparencyState)
            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CameraSubject = p62.Humanoid
            if p62.CurrentEquipped then
                p62:SetEquipped(p62.CurrentEquipped, false)
            end
            p62:UpdateScopeState()
            m_CameraController.setPerspective(true, false)
        elseif p62.PerspectiveState == "Third-Person" then
            p62.TransparencyState = false
            p62:SetCharacterTransparency(p62.TransparencyState)
            CurrentCamera.CameraType = Enum.CameraType.Follow
            CurrentCamera.CameraSubject = p62.Humanoid
            local WeaponComponent_0 = p62.WeaponComponent and p62.WeaponComponent
            if WeaponComponent_0 then
                if WeaponComponent_0.Bullet then
                    WeaponComponent_0.Bullet:destroy()
                    WeaponComponent_0.Bullet = nil
                end
                if WeaponComponent_0.Janitor then
                    WeaponComponent_0.Janitor:Destroy()
                end
                p62.WeaponComponent = nil
            end
            m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
            m_CameraController.setPerspective(false, false)
        elseif p62.PerspectiveState == "Free-Cam" then
            p62.TransparencyState = false
            p62:SetCharacterTransparency(p62.TransparencyState)
            local WeaponComponent_1 = p62.WeaponComponent and p62.WeaponComponent
            if WeaponComponent_1 then
                if WeaponComponent_1.Bullet then
                    WeaponComponent_1.Bullet:destroy()
                    WeaponComponent_1.Bullet = nil
                end
                if WeaponComponent_1.Janitor then
                    WeaponComponent_1.Janitor:Destroy()
                end
                p62.WeaponComponent = nil
            end
            m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
            if not p62.FreecamInstance then
                p62.FreecamInstance = p62.Janitor:Add(m_Freecam.new())
            end
            if p62.FreecamInstance then
                p62.FreecamInstance:Start()
            end
        end
        m_Remotes.Spectate.SetSpectatePerspective.Send(p62.PerspectiveState)
    end
end
function v_u_1.SetEquipped(p_u_66, p67, p68) -- name: SetEquipped
    -- upvalues: (copy) m_WeaponComponent, (copy) m_Bullet
    local v69 = p_u_66.WeaponComponent
    if v69 then
        v69 = p_u_66.WeaponComponent.Identifier
    end
    p_u_66.CurrentEquipped = p67
    if v69 == p67.Identifier then
        local WeaponComponent_2 = p_u_66.WeaponComponent
        if WeaponComponent_2 then
            WeaponComponent_2.IsSuppressed = p67.IsSuppressed
            WeaponComponent_2.Rounds = p67.Rounds
            WeaponComponent_2.Capacity = p67.Capacity
            WeaponComponent_2.RechargeStartTime = p67.RechargeStartTime
        end
        p_u_66:UpdateSuppressorState(p_u_66.WeaponComponent)
    else
        if p_u_66.WeaponComponent then
            p_u_66:SetWeaponViewmodelTransparency(false)
            local WeaponComponent_3 = p_u_66.WeaponComponent
            if WeaponComponent_3 then
                if WeaponComponent_3.Bullet then
                    WeaponComponent_3.Bullet:destroy()
                    WeaponComponent_3.Bullet = nil
                end
                if WeaponComponent_3.Janitor then
                    WeaponComponent_3.Janitor:Destroy()
                end
                p_u_66.WeaponComponent = nil
            end
        end
        if p_u_66.CurrentEquipped and p_u_66.PerspectiveState == "First-Person" then
            local v72, v73 = pcall(function()
                -- upvalues: (ref) m_WeaponComponent, (copy) p_u_66
                return m_WeaponComponent.new(p_u_66.Player, p_u_66.CurrentEquipped.Identifier, p_u_66.CurrentEquipped._id, 1, p_u_66.CurrentEquipped.Name, p_u_66.CurrentEquipped.Skin, p_u_66.CurrentEquipped.Float, p_u_66.CurrentEquipped.StatTrack, p_u_66.CurrentEquipped.NameTag, p_u_66.CurrentEquipped.OriginalOwner, p_u_66.CurrentEquipped.Charm, p_u_66.CurrentEquipped.Stickers)
            end)
            if not (v72 and v73) then
                warn((("[Spectate] Failed to create viewmodel for %* (%* | %*): %*"):format(p_u_66.Player.Name, p_u_66.CurrentEquipped.Name, p_u_66.CurrentEquipped.Skin, (tostring(v73)))))
                p_u_66.TransparencyState = false
                if not pcall(function()
                    -- upvalues: (copy) p_u_66
                    p_u_66:SetCharacterTransparency(false)
                end) then
                    warn("[Spectate] Failed to restore character transparency after viewmodel creation failure")
                end
                p_u_66:Switch("Third-Person")
                p_u_66.CurrentEquippedChanged:Fire(p_u_66.CurrentEquipped)
                return
            end
            if v73.Properties and v73.Properties.Spread then
                local v74 = m_Bullet.new(v73, v73.Properties)
                v73.Bullet = v74
                if v73.Janitor then
                    v73.Janitor:Add(v74, "destroy", "SpectateBullet")
                end
            end
            if v73 then
                v73.IsSuppressed = p67.IsSuppressed
                v73.Rounds = p67.Rounds
                v73.Capacity = p67.Capacity
                v73.RechargeStartTime = p67.RechargeStartTime
            end
            p_u_66.WeaponComponent = v73
            p_u_66.TransparencyState = true
            p_u_66:SetCharacterTransparency(p_u_66.TransparencyState)
            if p_u_66.WeaponComponent and p_u_66.WeaponComponent.Viewmodel then
                p_u_66.WeaponComponent.Viewmodel:equip(not p68)
                if p_u_66.WeaponComponent.Properties.HasSuppressor then
                    p_u_66:UpdateSuppressor()
                end
            end
            p_u_66:UpdateScopeState()
        end
        p_u_66.CurrentEquippedChanged:Fire(p_u_66.CurrentEquipped)
    end
end
function v_u_1.UpdateScopeState(p75) -- name: UpdateScopeState
    -- upvalues: (copy) m_CameraController, (copy) m_Constants
    if p75.PerspectiveState == "First-Person" then
        if p75.CurrentEquipped then
            local Name = p75.CurrentEquipped.Name
            local v77 = Name == "AWP" and true or Name == "SSG 08"
            local v78 = Name == "AUG" and true or Name == "SG 553"
            local v79 = p75.Player:GetAttribute("ScopeIncrement") or 0
            local v80 = v79 > 0
            if v77 then
                if p75.WeaponComponent and (p75.WeaponComponent.Viewmodel and p75.WeaponComponent.Viewmodel.Bobble) then
                    local ScopeReticlePart = p75.WeaponComponent.Viewmodel.Bobble.ScopeReticlePart
                    local SurfaceGui = ScopeReticlePart and ScopeReticlePart:FindFirstChildOfClass("SurfaceGui")
                    if SurfaceGui then
                        SurfaceGui.Enabled = false
                    end
                end
                if v80 and v79 <= 2 then
                    m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV - ({ 37, 60 })[v79])
                    if p75.WeaponComponent and p75.WeaponComponent.Viewmodel then
                        p75:SetWeaponViewmodelTransparency(true)
                        return
                    end
                else
                    m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
                    if p75.WeaponComponent and p75.WeaponComponent.Viewmodel then
                        p75:SetWeaponViewmodelTransparency(false)
                        return
                    end
                end
            elseif v78 then
                local v83 = p75.WeaponComponent
                if v83 then
                    v83 = p75.WeaponComponent.Viewmodel
                end
                if v83 then
                    if v80 then
                        if not v83.Hidden then
                            v83:hide()
                        end
                        if v83.Bobble and (v83.Bobble.Scope and v83.Bobble.ScopeReticlePart) then
                            v83:aim()
                        end
                        m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV - 15)
                    else
                        if v83.Hidden then
                            v83:unhide()
                        end
                        if v83.Bobble and (v83.Bobble.Scope and v83.Bobble.ScopeReticlePart) then
                            v83:unaim()
                        end
                        m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
                    end
                end
            else
                m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
                if p75.WeaponComponent and p75.WeaponComponent.Viewmodel then
                    p75:SetWeaponViewmodelTransparency(false)
                end
            end
        end
    else
        return
    end
end
function v_u_1.SetWeaponViewmodelTransparency(p84, p85) -- name: SetWeaponViewmodelTransparency
    if p84.WeaponComponent and (p84.WeaponComponent.Viewmodel and p84.WeaponComponent.Viewmodel.Model) then
        local Model = p84.WeaponComponent.Viewmodel.Model
        if not p84.WeaponTransparencyCache then
            p84.WeaponTransparencyCache = {}
        end
        for _, v87 in ipairs(Model:GetDescendants()) do
            if v87:IsA("BasePart") and (v87.Name ~= "Right Arm" and (v87.Name ~= "Left Arm" and (v87.Name ~= "HumanoidRootPart" and v87.Name ~= "ViewmodelLight"))) then
                if p85 then
                    if not p84.WeaponTransparencyCache[v87] then
                        p84.WeaponTransparencyCache[v87] = v87.Transparency
                    end
                    v87.Transparency = 1
                else
                    local v88 = p84.WeaponTransparencyCache[v87]
                    if v88 ~= nil then
                        v87.Transparency = v88
                        p84.WeaponTransparencyCache[v87] = nil
                    end
                end
            end
        end
    end
end
function v_u_1.HideDebrisWeapons(p89) -- name: HideDebrisWeapons
    -- upvalues: (copy) Debris, (copy) v_u_36
    if p89.TransparencyState then
        local Name_0 = p89.Player.Name
        local v91 = Debris:FindFirstChild(Name_0 .. "_Weapon")
        if v91 then
            for _, v92 in ipairs(v91:GetDescendants()) do
                v_u_36(p89, v92)
            end
        end
        local v93 = Debris:FindFirstChild(Name_0 .. "_WeaponAttachments")
        if v93 then
            for _, v94 in ipairs(v93:GetDescendants()) do
                v_u_36(p89, v94)
            end
        end
    end
end
function v_u_1.SetCharacterTransparency(p_u_95, p96) -- name: SetCharacterTransparency
    -- upvalues: (copy) v_u_36, (copy) m_Janitor, (copy) Debris, (copy) m_RemoveFromArray
    local v97 = p_u_95.Character:GetDescendants()
    local function v_u_101(p98) -- name: processDebrisWeapon
        -- upvalues: (ref) v_u_36, (copy) p_u_95
        for _, v99 in ipairs(p98:GetDescendants()) do
            v_u_36(p_u_95, v99)
        end
        if p_u_95.TransparencyJanitor then
            p_u_95.TransparencyJanitor:Add(p98.DescendantAdded:Connect(function(p100)
                -- upvalues: (ref) p_u_95, (ref) v_u_36
                if p_u_95.TransparencyState then
                    v_u_36(p_u_95, p100)
                end
            end))
        end
    end
    if p96 then
        if not p_u_95.TransparencyJanitor then
            local v102 = p_u_95.Janitor:Add(m_Janitor.new())
            p_u_95.TransparencyJanitor = v102
            v102:Add(p_u_95.Character.DescendantAdded:Connect(function(p103)
                -- upvalues: (copy) p_u_95, (ref) v_u_36
                if p_u_95.TransparencyState then
                    v_u_36(p_u_95, p103)
                end
            end))
            v102:Add(Debris.ChildAdded:Connect(function(p104)
                -- upvalues: (copy) p_u_95, (copy) v_u_101
                if p_u_95.TransparencyState then
                    local Name_1 = p_u_95.Player.Name
                    if p104.Name == Name_1 .. "_Weapon" or p104.Name == Name_1 .. "_WeaponAttachments" then
                        v_u_101(p104)
                    end
                end
            end))
        end
        for _, v106 in ipairs(v97) do
            v_u_36(p_u_95, v106)
        end
        local Name_2 = p_u_95.Player.Name
        local v108 = Debris:FindFirstChild(Name_2 .. "_Weapon")
        if v108 then
            v_u_101(v108)
        end
        local v109 = Debris:FindFirstChild(Name_2 .. "_WeaponAttachments")
        if v109 then
            v_u_101(v109)
            return
        end
    else
        if p_u_95.TransparencyJanitor then
            p_u_95.TransparencyJanitor:Destroy()
            p_u_95.TransparencyJanitor = nil
        end
        for v_u_110, v111 in pairs(p_u_95.Transparencies) do
            if v_u_110 and v_u_110.Parent then
                v_u_110.Transparency = v111.Transparency
                m_RemoveFromArray(v111.Textures, function(_, p112)
                    -- upvalues: (copy) v_u_110
                    p112.Parent = v_u_110
                    return true
                end)
            end
        end
        for _, v113 in ipairs(v97) do
            if v113:IsA("BillboardGui") then
                v113.Enabled = true
            end
        end
    end
end
function v_u_1.AddSpectateEvent(p114, p115) -- name: AddSpectateEvent
    -- upvalues: (copy) v_u_50, (copy) v_u_27, (copy) v_u_42, (copy) v_u_26, (copy) v_u_25
    if p114.WeaponComponent and p114.WeaponComponent.Viewmodel then
        local v116 = p114.WeaponComponent.Viewmodel
        if v116 then
            v116 = p114.WeaponComponent.Viewmodel.Animation
        end
        local WeaponComponent_4 = p114.WeaponComponent
        if p115 == "RevolverChargeStart" then
            if WeaponComponent_4 and (WeaponComponent_4.Bullet and WeaponComponent_4.Properties.ShootingOptions == "Revolver") then
                local v118 = WeaponComponent_4.Properties.FireModes
                if v118 then
                    v118 = v118.Primary
                end
                local Spread = v118 and v118.Spread or WeaponComponent_4.Properties.Spread
                WeaponComponent_4.Bullet:setSpreadConfig(Spread)
            end
            WeaponComponent_4.IsChargeFiring = true
            WeaponComponent_4.ChargeStartTick = tick()
            v116:stopAnimations()
            v116:play("Shoot")
            v116:play("Idle")
            return
        end
        if p115 == "RevolverChargeCancel" then
            if WeaponComponent_4 then
                if WeaponComponent_4 and (WeaponComponent_4.Bullet and WeaponComponent_4.Properties.ShootingOptions == "Revolver") then
                    local v120 = WeaponComponent_4.Properties.FireModes
                    if v120 then
                        v120 = v120.Secondary or v120.Primary
                    end
                    local Spread_0 = v120 and v120.Spread or WeaponComponent_4.Properties.Spread
                    WeaponComponent_4.Bullet:setSpreadConfig(Spread_0)
                end
                WeaponComponent_4.IsChargeFiring = false
                WeaponComponent_4.ChargeStartTick = 0
            end
            v116:stopAnimations()
            v116:play("Idle")
            return
        end
        if p115 == "RevolverChargeRelease" then
            if WeaponComponent_4 and (WeaponComponent_4.Bullet and WeaponComponent_4.Properties.ShootingOptions == "Revolver") then
                local v122 = WeaponComponent_4.Properties.FireModes
                if v122 then
                    v122 = v122.Primary
                end
                local Spread_1 = v122 and v122.Spread or WeaponComponent_4.Properties.Spread
                WeaponComponent_4.Bullet:setSpreadConfig(Spread_1)
            end
            v_u_50(p114)
            if WeaponComponent_4 then
                if WeaponComponent_4 and (WeaponComponent_4.Bullet and WeaponComponent_4.Properties.ShootingOptions == "Revolver") then
                    local v124 = WeaponComponent_4.Properties.FireModes
                    if v124 then
                        v124 = v124.Secondary or v124.Primary
                    end
                    local Spread_2 = v124 and v124.Spread or WeaponComponent_4.Properties.Spread
                    WeaponComponent_4.Bullet:setSpreadConfig(Spread_2)
                end
                WeaponComponent_4.IsChargeFiring = false
                WeaponComponent_4.ChargeStartTick = 0
            end
        end
        if v_u_27[p115] then
            if WeaponComponent_4.Properties.ShootingOptions == "Revolver" then
                local v126 = p115 == "SlamFire" and "Secondary" or "Primary"
                if WeaponComponent_4 and (WeaponComponent_4.Bullet and WeaponComponent_4.Properties.ShootingOptions == "Revolver") then
                    local v127 = WeaponComponent_4.Properties.FireModes
                    if v127 then
                        v127 = v126 == "Secondary" and v127.Secondary or v127.Primary
                    end
                    local Spread_3 = v127 and v127.Spread or WeaponComponent_4.Properties.Spread
                    WeaponComponent_4.Bullet:setSpreadConfig(Spread_3)
                end
                if v126 == "Secondary" then
                    if WeaponComponent_4 then
                        if WeaponComponent_4 and (WeaponComponent_4.Bullet and WeaponComponent_4.Properties.ShootingOptions == "Revolver") then
                            local v129 = WeaponComponent_4.Properties.FireModes
                            if v129 then
                                v129 = v129.Secondary or v129.Primary
                            end
                            local Spread_4 = v129 and v129.Spread or WeaponComponent_4.Properties.Spread
                            WeaponComponent_4.Bullet:setSpreadConfig(Spread_4)
                        end
                        WeaponComponent_4.IsChargeFiring = false
                        WeaponComponent_4.ChargeStartTick = 0
                    end
                else
                    WeaponComponent_4.IsChargeFiring = false
                    WeaponComponent_4.ChargeStartTick = 0
                end
            end
            v_u_42(WeaponComponent_4)
            local v131 = not v116:getAnimation(p115) and "Shoot" or p115
            v116:stopAnimations()
            v116:play(v131)
            v116:play("Idle")
            v_u_50(p114)
            if WeaponComponent_4.Properties.ShootingOptions == "Revolver" and p115 ~= "SlamFire" then
                if WeaponComponent_4 then
                    if WeaponComponent_4 and (WeaponComponent_4.Bullet and WeaponComponent_4.Properties.ShootingOptions == "Revolver") then
                        local v132 = WeaponComponent_4.Properties.FireModes
                        if v132 then
                            v132 = v132.Secondary or v132.Primary
                        end
                        local Spread_5 = v132 and v132.Spread or WeaponComponent_4.Properties.Spread
                        WeaponComponent_4.Bullet:setSpreadConfig(Spread_5)
                    end
                    WeaponComponent_4.IsChargeFiring = false
                    WeaponComponent_4.ChargeStartTick = 0
                end
            end
        else
            if p115 == "Remove Suppressor" or p115 == "Add Suppressor" then
                v116:stopAnimations()
                v116:play(string.gsub(p115, " ", ""))
                v116:play("Idle")
                return
            end
            if p115 == "Cancel Plant" then
                v116:stopAnimations()
                v116:play("Idle")
                return
            end
            if p115 == "Switch Fire Mode" then
                v116:stopAnimations()
                v116:play("Switch")
                v116:play("Idle")
                return
            end
            if v_u_26[p115] then
                v116:stopAnimations()
                v116:play("StartThrow")
                local v134 = v116:play("ThrowIdle")
                if v134 then
                    v134.Looped = true
                    return
                end
            else
                if p115 == "CancelThrow" then
                    v116:stopAnimations()
                    v116:play("Idle")
                    return
                end
                if v_u_25[p115] or (p115 == "Inspect" or string.match(p115, "^Inspect%d+$") ~= nil) then
                    local v135 = (p115 == "Inspect" and true or string.match(p115, "^Inspect%d+$") ~= nil) and not v116:getAnimation(p115) and "Inspect" or p115
                    v116:stopAnimations()
                    v116:play(v135)
                    v116:play("Idle")
                end
            end
        end
    end
end
local function v_u_153(p136, p137) -- name: updateSpectatorAutomaticScope
    if p136.PerspectiveState == "First-Person" then
        if p136.CurrentEquipped then
            local Name_3 = p136.CurrentEquipped.Name
            if Name_3 == "AUG" and true or Name_3 == "SG 553" then
                if (p136.Player:GetAttribute("ScopeIncrement") or 0) > 0 then
                    if p136.WeaponComponent and p136.WeaponComponent.Viewmodel then
                        local Viewmodel = p136.WeaponComponent.Viewmodel
                        if Viewmodel.Bobble and Viewmodel.Bobble.IsAiming then
                            local WeaponComponent_5 = p136.WeaponComponent
                            if WeaponComponent_5 and WeaponComponent_5.Bullet then
                                local v141 = WeaponComponent_5.Bullet:getBaseSpread() or 0
                                local v142 = v141 - (p136.LastSpreadValue or 0)
                                local v143 = math.abs(v142)
                                local v144 = (p136.LastScopeUpdateTime or 0) + p137
                                if v143 < 0.01 and v144 < 0.03333333333333333 then
                                    p136.LastScopeUpdateTime = v144
                                    return
                                else
                                    p136.LastScopeUpdateTime = 0
                                    p136.LastSpreadValue = v141
                                    local ScopeReticlePart_0 = Viewmodel.Bobble.ScopeReticlePart
                                    if ScopeReticlePart_0 then
                                        local ScopeUICache = p136.ScopeUICache
                                        if ScopeUICache and ScopeUICache.SurfaceGui == ScopeReticlePart_0 then
                                            local Crosshair = ScopeUICache.Crosshair
                                            if Crosshair and Crosshair.Parent then
                                                local v148 = math.clamp(v141, 0, 2) * 2
                                                Crosshair.Size = UDim2.fromScale(v148 + 2.5, v148 + 2.5)
                                                Crosshair.Position = UDim2.fromScale(0.5, 0.5)
                                                return
                                            end
                                            p136.ScopeUICache = nil
                                        end
                                        local SurfaceGui_0 = ScopeReticlePart_0:FindFirstChildOfClass("SurfaceGui")
                                        if SurfaceGui_0 then
                                            local Frame = SurfaceGui_0:FindFirstChild("Frame")
                                            if Frame then
                                                local Frame_0 = Frame:FindFirstChild("Frame")
                                                if Frame_0 then
                                                    p136.ScopeUICache = {
                                                        ["Crosshair"] = Frame_0,
                                                        ["SurfaceGui"] = SurfaceGui_0,
                                                        ["Frame"] = Frame
                                                    }
                                                    local v152 = math.clamp(v141, 0, 2) * 2
                                                    Frame_0.Size = UDim2.fromScale(v152 + 2.5, v152 + 2.5)
                                                    Frame_0.Position = UDim2.fromScale(0.5, 0.5)
                                                end
                                            else
                                                return
                                            end
                                        else
                                            return
                                        end
                                    else
                                        return
                                    end
                                end
                            else
                                return
                            end
                        else
                            return
                        end
                    else
                        return
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
function v_u_1.Render(p154, p155) -- name: Render
    -- upvalues: (copy) CurrentCamera, (copy) v_u_153
    if p154.PerspectiveState ~= "Free-Cam" then
        if p154.CameraPositionSpring and p154.CameraRotationSpring then
            p154.CameraPositionSpring:update(p155)
            p154.CameraRotationSpring:update(p155)
            if p154.PerspectiveState == "First-Person" then
                CurrentCamera.CFrame = CFrame.lookAt(p154.CameraPositionSpring:getPosition(), p154.CameraPositionSpring:getPosition() + p154.CameraRotationSpring:getPosition())
                if p154.WeaponComponent and p154.WeaponComponent.Viewmodel then
                    p154.WeaponComponent.Viewmodel:render(p155)
                end
                local WeaponComponent_6 = p154.WeaponComponent
                if WeaponComponent_6 and (WeaponComponent_6.Bullet and WeaponComponent_6.Bullet.updateSpread) then
                    WeaponComponent_6.Bullet:updateSpread(p155)
                end
                v_u_153(p154, p155)
            end
        end
    end
end
function v_u_1.new(p157, p158, p159) -- name: new
    -- upvalues: (copy) v_u_1, (copy) m_Janitor, (copy) m_Signal, (copy) LocalPlayer, (copy) HttpService, (copy) m_Remotes, (copy) Characters, (copy) m_Sift, (copy) m_CameraController, (copy) m_Constants
    local v160 = v_u_1
    local v_u_161 = setmetatable({}, v160)
    v_u_161.Janitor = m_Janitor.new()
    v_u_161.CurrentEquippedChanged = v_u_161.Janitor:Add(m_Signal.new())
    v_u_161.StopSpectating = v_u_161.Janitor:Add(m_Signal.new())
    v_u_161.Humanoid = p159
    v_u_161.Character = p158
    v_u_161.Player = p157
    v_u_161.CurrentPlayerTeam = p157:GetAttribute("Team")
    v_u_161.PerspectiveState = "First-Person"
    v_u_161.TransparencyState = true
    v_u_161.FreecamInstance = nil
    v_u_161.Transparencies = {}
    v_u_161.TransparencyJanitor = nil
    v_u_161.WeaponTransparencyCache = {}
    v_u_161.ScopeUICache = nil
    v_u_161.LastScopeUpdateTime = 0
    v_u_161.LastSpreadValue = 0
    v_u_161:SetCharacterTransparency(v_u_161.TransparencyState)
    v_u_161:Switch(v_u_161.PerspectiveState)
    LocalPlayer.ReplicationFocus = v_u_161.Humanoid
    v_u_161.Janitor:Add(function()
        -- upvalues: (ref) LocalPlayer
        LocalPlayer.ReplicationFocus = nil
    end)
    if v_u_161.Player:GetAttribute("CurrentEquipped") then
        v_u_161:SetEquipped(HttpService:JSONDecode((v_u_161.Player:GetAttribute("CurrentEquipped"))), false)
    end
    v_u_161.Janitor:Add(v_u_161.Player:GetAttributeChangedSignal("CurrentEquipped"):Connect(function()
        -- upvalues: (copy) v_u_161, (ref) HttpService
        local v162 = v_u_161.Player:GetAttribute("CurrentEquipped")
        if v162 then
            v_u_161:SetEquipped(HttpService:JSONDecode(v162), true)
            task.defer(function()
                -- upvalues: (ref) v_u_161
                if v_u_161.TransparencyState and v_u_161.PerspectiveState == "First-Person" then
                    v_u_161:HideDebrisWeapons()
                end
            end)
        end
    end))
    if v_u_161.Character:GetAttribute("CameraCFrame") then
        v_u_161:UpdateCameraCFrame((v_u_161.Character:GetAttribute("CameraCFrame")))
    end
    v_u_161.Janitor:Add(v_u_161.Character:GetAttributeChangedSignal("CameraCFrame"):Connect(function()
        -- upvalues: (copy) v_u_161
        v_u_161:UpdateCameraCFrame((v_u_161.Character:GetAttribute("CameraCFrame")))
    end))
    if v_u_161.Player:GetAttribute("ScopeIncrement") then
        v_u_161:UpdateScopeState()
    end
    v_u_161.Janitor:Add(v_u_161.Player:GetAttributeChangedSignal("ScopeIncrement"):Connect(function()
        -- upvalues: (copy) v_u_161
        v_u_161:UpdateScopeState()
    end))
    if v_u_161.Humanoid.Health <= 0 then
        task.defer(function()
            -- upvalues: (copy) v_u_161
            v_u_161.StopSpectating:Fire()
        end)
    end
    v_u_161.Janitor:Add(v_u_161.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        -- upvalues: (copy) v_u_161
        if v_u_161.Humanoid and v_u_161.Humanoid.Health <= 0 then
            v_u_161.StopSpectating:Fire()
        end
    end))
    if v_u_161.Character:GetAttribute("Dead") then
        task.defer(function()
            -- upvalues: (copy) v_u_161
            v_u_161.StopSpectating:Fire()
        end)
    end
    v_u_161.Janitor:Add(v_u_161.Character:GetAttributeChangedSignal("Dead"):Connect(function()
        -- upvalues: (copy) v_u_161
        if v_u_161.Character:GetAttribute("Dead") then
            v_u_161.StopSpectating:Fire()
        end
    end))
    v_u_161.Janitor:Add(m_Remotes.UI.UIPlayerKilled.Listen(function(p163)
        -- upvalues: (copy) v_u_161
        local Victim = p163.Victim
        if Victim then
            local UserId = v_u_161.Player.UserId
            if tostring(UserId) == Victim then
                v_u_161.StopSpectating:Fire()
            end
        end
    end))
    v_u_161.Janitor:Add(v_u_161.Character.AncestryChanged:Connect(function(_, p166)
        -- upvalues: (ref) Characters, (copy) v_u_161
        if not (p166 and p166:IsDescendantOf(Characters)) then
            v_u_161.StopSpectating:Fire()
        end
    end))
    v_u_161.Janitor:Add(function()
        -- upvalues: (copy) v_u_161, (ref) m_Sift, (ref) m_CameraController, (ref) m_Constants
        v_u_161.TransparencyState = false
        if m_Sift.Dictionary.count(v_u_161.Transparencies) > 0 then
            v_u_161:SetCharacterTransparency(v_u_161.TransparencyState)
        end
        m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
    end)
    v_u_161.Janitor:Add(function()
        -- upvalues: (copy) v_u_161
        if v_u_161.WeaponComponent then
            local v167 = v_u_161
            local WeaponComponent_7 = v167.WeaponComponent
            if WeaponComponent_7 then
                if WeaponComponent_7.Bullet then
                    WeaponComponent_7.Bullet:destroy()
                    WeaponComponent_7.Bullet = nil
                end
                if WeaponComponent_7.Janitor then
                    WeaponComponent_7.Janitor:Destroy()
                end
                v167.WeaponComponent = nil
            end
        end
        v_u_161.WeaponTransparencyCache = {}
        v_u_161.LastScopeUpdateTime = 0
        v_u_161.LastSpreadValue = 0
        v_u_161.ScopeUICache = nil
    end)
    v_u_161.Janitor:Add(function()
        -- upvalues: (copy) v_u_161
        if v_u_161.FreecamInstance then
            v_u_161.FreecamInstance:Stop()
            v_u_161.FreecamInstance:Destroy()
            v_u_161.FreecamInstance = nil
        end
    end)
    return v_u_161
end
function v_u_1.Destroy(p169) -- name: Destroy
    p169.Janitor:Destroy()
end
return v_u_1
