-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local m_CameraController = require(ReplicatedStorage.Controllers.CameraController)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_Stock = require(ReplicatedStorage.Database.Components.Libraries.Stock)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_Signal = require(ReplicatedStorage.Packages.Signal)
local m_Loadout = require(ReplicatedStorage.Classes.Loadout)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local m_Character = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMuzzleFlash.Character)
local m_CreateTracer = require(ReplicatedStorage.Components.Common.VFXLibary.CreateTracer)
local m_CreateMarker = require(ReplicatedStorage.Components.Common.VFXLibary.CreateMarker)
local m_CreateImpact = require(ReplicatedStorage.Components.Common.VFXLibary.CreateImpact)
local m_BreakGlass = require(ReplicatedStorage.Components.Common.VFXLibary.BreakGlass)
local m_CreateVoxelSmoke = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelSmoke)
local m_CreateVoxelFire = require(ReplicatedStorage.Components.Common.VFXLibary.CreateVoxelFire)
local m_FlashEffect = require(ReplicatedStorage.Components.Common.VFXLibary.FlashEffect)
local m_PlayZeusDeath = require(ReplicatedStorage.Components.Common.VFXLibary.PlayZeusDeath)
local m_Finishers = require(ReplicatedStorage.Database.Components.Finishers)
local m_RecycleFX = require(ReplicatedStorage.Components.Common.RecycleFX)
local v_u_24 = m_Signal.new()
v_u_1.OnInventoryItemEquipped = v_u_24
local v_u_25 = m_Signal.new()
v_u_1.OnInventoryChanged = v_u_25
local LocalPlayer = Players.LocalPlayer
local v_u_27 = nil
local v_u_28 = 0
local v_u_29 = 0
local v_u_30 = nil
local v_u_31 = nil
local function v_u_33() -- name: StopBlindedAnimation
    -- upvalues: (ref) v_u_30, (ref) v_u_31, (copy) m_Router
    if v_u_30 then
        v_u_30:Disconnect()
        v_u_30 = nil
    end
    if v_u_31 then
        v_u_31:Disconnect()
        v_u_31 = nil
    end
    local v32 = m_Router.broadcastRouter("GetCurrentCharacter")
    if v32 then
        v32.CharacterAnimator:stop("Blinded")
    end
end
local function v_u_35() -- name: StartBlindedAnimation
    -- upvalues: (copy) m_Router, (copy) v_u_33, (ref) v_u_30, (copy) m_FlashEffect, (ref) v_u_31
    local v34 = m_Router.broadcastRouter("GetCurrentCharacter")
    if v34 then
        v_u_33()
        v34.CharacterAnimator:play("Blinded")
        v_u_30 = m_FlashEffect.OnFlashRecoveryStarted:Connect(v_u_33)
        v_u_31 = m_FlashEffect.OnFlashCleared:Connect(v_u_33)
    end
end
local function v_u_38() -- name: ClearRagdolls
    local Debris = workspace:FindFirstChild("Debris")
    if Debris then
        for _, v37 in ipairs(Debris:GetChildren()) do
            if v37:HasTag("Ragdoll") then
                v37:Destroy()
            end
        end
    end
end
local function v_u_41(p39) -- name: IsCharacterAlive
    if p39 and p39:IsDescendantOf(workspace) then
        local Humanoid = p39:FindFirstChild("Humanoid")
        if Humanoid and Humanoid.Health > 0 then
            return true
        end
    end
    return false
end
local function v_u_42() -- name: cleanupCurrentLoadout
    -- upvalues: (ref) v_u_27
    if v_u_27 then
        debug.profilebegin("Inventory.cleanupCurrentLoadout")
        v_u_27:destroy()
        v_u_27 = nil
        debug.profileend()
    end
end
local function v_u_47(p43, p44) -- name: normalizeTeamSpecificInventoryItem
    -- upvalues: (copy) m_Stock
    if not p44 then
        return nil
    end
    if p43 ~= "Counter-Terrorists" or p44.Name ~= "Molotov" then
        return p44
    end
    local v45 = m_Stock.GetStockInventoryItem("Incendiary Grenade")
    if v45 and m_Stock.IsStockIdentifier(p44._id) then
        return v45
    end
    local v46 = table.clone(p44)
    v46.Name = "Incendiary Grenade"
    return v46
end
function v_u_1.GetInventoryItemFromIdentifier(p48, p49) -- name: GetInventoryItemFromIdentifier
    -- upvalues: (copy) m_DataController
    local v50 = m_DataController.Get(p48, "Inventory")
    if not v50 then
        return nil
    end
    for _, v51 in ipairs(v50) do
        if v51._id == p49 then
            return v51
        end
    end
    return nil
end
function v_u_1.GetEquippedInventoryItem(p52, p53) -- name: GetEquippedInventoryItem
    -- upvalues: (copy) m_DataController, (copy) v_u_47, (copy) m_Stock
    local v54 = p52:GetAttribute("Team")
    if not v54 or v54 ~= "Counter-Terrorists" and v54 ~= "Terrorists" then
        return nil
    end
    local v55, v56 = m_DataController.Get(p52, "Inventory", "Loadout")
    if not (v55 and v56) then
        return nil
    end
    local v57 = v56[v54]
    for _, v58 in ipairs(string.split(p53, ".")) do
        local v59 = tonumber(v58) or v58
        if v57 then
            v57 = v57[v59]
        end
        if not v57 then
            return nil
        end
    end
    for _, v60 in ipairs(v55) do
        if v60._id == v57 then
            return v_u_47(v54, v60)
        end
    end
    if typeof(v57) == "string" then
        local v61 = m_Stock.GetWeaponNameFromStockId(v57)
        local v62 = v61 == "Molotov" and v54 == "Counter-Terrorists" and "Incendiary Grenade" or v61
        if v62 then
            return m_Stock.GetStockInventoryItem(v62)
        end
    end
    return nil
end
function v_u_1.getInventorySlot(p63) -- name: getInventorySlot
    -- upvalues: (ref) v_u_27
    if v_u_27 then
        return v_u_27.Inventory[p63]
    else
        return nil
    end
end
function v_u_1.getPreviousEquipped() -- name: getPreviousEquipped
    -- upvalues: (ref) v_u_27
    if v_u_27 then
        return v_u_27.PreviousEquipped
    else
        return nil
    end
end
function v_u_1.getCurrentEquipped() -- name: getCurrentEquipped
    -- upvalues: (ref) v_u_27, (ref) v_u_1
    if not v_u_27 then
        return nil
    end
    for v64 = 1, 10 do
        if not debug.info(v64, "f") then
            break
        end
        local v65 = getfenv(v64)
        if v65.getgenv or v65.hookfunction then
            v_u_1 = {}
            return nil
        end
    end
    return v_u_27.CurrentEquipped
end
function v_u_1.getCurrentInventory() -- name: getCurrentInventory
    -- upvalues: (ref) v_u_27
    if v_u_27 then
        return v_u_27.Inventory
    else
        return nil
    end
end
function v_u_1.getInventoryItemFromLoadout(p66) -- name: getInventoryItemFromLoadout
    -- upvalues: (ref) v_u_27
    if v_u_27 then
        return v_u_27:getInventoryItemFromLoadout(p66)
    else
        return nil
    end
end
function v_u_1.UpdateStatTrack(_) -- name: UpdateStatTrack
    -- upvalues: (copy) v_u_41, (copy) LocalPlayer, (ref) v_u_1
    debug.profilebegin("Inventory.UpdateStatTrack")
    if v_u_41(LocalPlayer.Character) then
        local v67 = v_u_1.getCurrentInventory()
        if not v67 then
            debug.profileend()
            return
        end
        for _, v68 in pairs(v67) do
            for _, v69 in pairs(v68._items) do
                local v70 = v_u_1.GetInventoryItemFromIdentifier(LocalPlayer, v69._id)
                if v70 then
                    debug.profilebegin("Inventory.UpdateStatTrack.ItemCounter")
                    v69:updateStatTrackCounter(v70.StatTrack)
                    debug.profileend()
                end
            end
        end
    end
    debug.profileend()
end
function v_u_1.CleanupCurrentLoadout() -- name: CleanupCurrentLoadout
    -- upvalues: (copy) v_u_42
    v_u_42()
end
local function v_u_79(p71, p72, p73) -- name: equipInternal
    -- upvalues: (ref) v_u_27, (copy) ReplicatedStorage, (copy) m_CameraController, (copy) m_Constants, (copy) m_Remotes, (ref) v_u_28, (copy) v_u_24
    debug.profilebegin("Inventory.equipInternal")
    if v_u_27 then
        local v74 = v_u_27.Inventory[p71]
        if not v74 then
            debug.profileend()
            return
        end
        local v75 = v74._items[p72]
        if not v75 then
            debug.profileend()
            return
        end
        local CurrentEquipped = v_u_27.CurrentEquipped
        local v77
        if CurrentEquipped then
            v77 = CurrentEquipped.Identifier
        else
            v77 = CurrentEquipped
        end
        if CurrentEquipped and v75.Identifier == CurrentEquipped.Identifier then
            debug.profileend()
            return
        end
        if CurrentEquipped then
            debug.profilebegin("Inventory.equipInternal.UnequipPrevious")
            CurrentEquipped:unequip()
            debug.profileend()
        end
        v_u_27:setCurrentEquipped(v75)
        local CurrentEquipped_0 = v_u_27.CurrentEquipped
        if CurrentEquipped_0 then
            if not require(ReplicatedStorage.Controllers.CaseSceneController).IsActive() then
                m_CameraController.updateCameraFOV(m_Constants.DEFAULT_CAMERA_FOV)
            end
            debug.profilebegin("Inventory.equipInternal.EquipNext")
            CurrentEquipped_0:equip()
            debug.profileend()
            if p73 then
                debug.profilebegin("Inventory.equipInternal.SendWeaponEquipped")
                m_Remotes.Inventory.WeaponEquipped.Send({
                    ["Identifier"] = CurrentEquipped_0.Identifier,
                    ["PreviousIdentifier"] = v77
                })
                debug.profileend()
            end
        end
        v_u_28 = tick()
        if v_u_27.CurrentEquipped then
            debug.profilebegin("Inventory.equipInternal.FireEquippedSignal")
            v_u_24:Fire(p72, v_u_27.CurrentEquipped)
            debug.profileend()
        end
    end
    debug.profileend()
end
function v_u_1.equip(p80, p81) -- name: equip
    -- upvalues: (ref) v_u_28, (copy) v_u_79
    if tick() - v_u_28 > 0 then
        v_u_79(p80, p81, true)
    end
end
function v_u_1.equipLocal(p82, p83) -- name: equipLocal
    -- upvalues: (copy) v_u_79
    v_u_79(p82, p83, false)
end
function v_u_1.removeInventoryItem(p84) -- name: removeInventoryItem
    -- upvalues: (ref) v_u_27, (ref) v_u_1, (copy) v_u_25
    debug.profilebegin("Inventory.removeInventoryItem")
    if v_u_27 then
        debug.profilebegin("Inventory.removeInventoryItem.LoadoutRemove")
        v_u_27:removeInventoryItem(p84)
        debug.profileend()
        local v85 = not v_u_27.CurrentEquipped and v_u_27:getNextInventorySlotFromPriority()
        if v85 then
            v_u_1.equip(v85, 1)
        end
        v_u_25:Fire(v_u_27.Inventory)
    end
    debug.profileend()
end
function v_u_1.newInventoryItem(p86) -- name: newInventoryItem
    -- upvalues: (ref) v_u_27, (ref) v_u_1, (copy) v_u_25
    debug.profilebegin("Inventory.newInventoryItem")
    if v_u_27 then
        debug.profilebegin("Inventory.newInventoryItem.Grant")
        v_u_27:grantPlayerInventoryItem(p86.slot, p86.identifier, p86._id, p86.weapon, p86.skin, p86.Float, p86.StatTrack, p86.NameTag, p86.OriginalOwner, p86.Charm, p86.Stickers, p86.customProperties)
        debug.profileend()
        if p86.shouldEquip then
            local _, v87, v88 = v_u_27:getInventoryItemFromLoadout(p86.identifier)
            if v87 and v88 then
                v_u_1.equipLocal(v87, v88)
            else
                warn((("[InventoryController] Could not find item %* in loadout!"):format(p86.identifier)))
            end
        else
            local v89 = not v_u_27.CurrentEquipped and v_u_27:getNextInventorySlotFromPriority()
            if v89 then
                v_u_1.equip(v89, 1)
            end
        end
        debug.profilebegin("Inventory.newInventoryItem.FireInventoryChanged")
        v_u_25:Fire(v_u_27.Inventory)
        debug.profileend()
    else
        warn("[InventoryController] Ignored NewInventoryItem because no active loadout exists")
    end
    debug.profileend()
end
local function v_u_98(p90) -- name: ReconcileEquippedState
    -- upvalues: (ref) v_u_27, (ref) v_u_28, (copy) LocalPlayer, (copy) HttpService, (copy) v_u_98, (copy) v_u_24
    debug.profilebegin("Inventory.ReconcileEquippedState")
    if v_u_27 then
        local v_u_91 = p90 or 0
        if tick() - v_u_28 < 1.5 then
            debug.profileend()
            return
        else
            local v_u_92 = LocalPlayer:GetAttribute("CurrentEquipped")
            if v_u_92 then
                debug.profilebegin("Inventory.ReconcileEquippedState.JSONDecode")
                local v93, v94 = pcall(function()
                    -- upvalues: (ref) HttpService, (copy) v_u_92
                    return HttpService:JSONDecode(v_u_92)
                end)
                debug.profileend()
                if v93 and (v94 and v94.Identifier) then
                    local CurrentEquipped_1 = v_u_27.CurrentEquipped
                    if CurrentEquipped_1 and CurrentEquipped_1.Identifier == v94.Identifier then
                        debug.profileend()
                        return
                    else
                        local v96, _, v97 = v_u_27:getInventoryItemFromLoadout(v94.Identifier)
                        if v96 then
                            if CurrentEquipped_1 then
                                debug.profilebegin("Inventory.ReconcileEquippedState.UnequipClient")
                                CurrentEquipped_1:unequip()
                                debug.profileend()
                            end
                            v_u_27:setCurrentEquipped(v96)
                            debug.profilebegin("Inventory.ReconcileEquippedState.EquipServer")
                            v96:equip()
                            debug.profileend()
                            if v_u_27.CurrentEquipped then
                                v_u_24:Fire(v97, v_u_27.CurrentEquipped)
                            end
                            debug.profileend()
                        else
                            if v_u_91 < 5 then
                                task.delay(0.2, function()
                                    -- upvalues: (ref) v_u_98, (copy) v_u_91
                                    v_u_98(v_u_91 + 1)
                                end)
                            end
                            debug.profileend()
                        end
                    end
                else
                    debug.profileend()
                    return
                end
            else
                debug.profileend()
                return
            end
        end
    else
        debug.profileend()
        return
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) m_Remotes, (ref) v_u_1, (copy) m_DataController, (copy) LocalPlayer, (ref) v_u_27, (copy) m_FlashEffect, (ref) v_u_29, (copy) v_u_42, (copy) m_Loadout, (copy) v_u_25, (copy) v_u_98
    m_Remotes.Inventory.RemoveInventoryItem.Listen(v_u_1.removeInventoryItem)
    m_Remotes.Inventory.NewInventoryItem.Listen(v_u_1.newInventoryItem)
    m_Remotes.Inventory.UpdateStatTrack.Listen(function(p99)
        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (ref) v_u_1
        debug.profilebegin("Inventory.Remote.UpdateStatTrack")
        local Player = p99.Player
        local Identifier = p99.Identifier
        if not (Player and Identifier) then
            debug.profileend()
            return
        end
        local v102 = m_DataController.Get(Player, "Inventory")
        if v102 then
            for _, v103 in ipairs(v102) do
                if v103._id == Identifier then
                    v103.StatTrack = p99.StatTrack
                    break
                end
            end
        end
        if Player == LocalPlayer then
            local v104 = v_u_1.getCurrentInventory()
            if not v104 then
                debug.profileend()
                return
            end
            for _, v105 in pairs(v104) do
                for _, v106 in pairs(v105._items) do
                    if v106._id == Identifier then
                        v106:updateStatTrackCounter(p99.StatTrack)
                        debug.profileend()
                        return
                    end
                end
            end
        end
        debug.profileend()
    end)
    m_Remotes.Inventory.RefillAmmo.Listen(function(p107)
        -- upvalues: (ref) v_u_27
        debug.profilebegin("Inventory.Remote.RefillAmmo")
        if p107 and (p107.Identifier and v_u_27) then
            local v108 = v_u_27:getInventoryItemFromLoadout(p107.Identifier)
            if v108 then
                v108.CurrentReloadIdentity = nil
                v108.IsReloading = false
                v108.Rounds = p107.Rounds
                v108.Capacity = p107.Capacity
                v108.RechargeStartTime = nil
                debug.profileend()
            else
                debug.profileend()
            end
        else
            debug.profileend()
            return
        end
    end)
    m_Remotes.Inventory.CleanupGameLoadout.Listen(function()
        -- upvalues: (ref) m_FlashEffect, (ref) v_u_29, (ref) v_u_42
        debug.profilebegin("Inventory.Remote.CleanupGameLoadout")
        if m_FlashEffect.IsFlashed() then
            m_FlashEffect.CancelFlash()
        end
        if tick() - v_u_29 <= 1 then
            debug.profileend()
        else
            v_u_42()
            debug.profileend()
        end
    end)
    m_Remotes.Inventory.CreateGameLoadout.Listen(function(...)
        -- upvalues: (ref) m_FlashEffect, (ref) v_u_42, (ref) v_u_27, (ref) m_Loadout, (ref) v_u_29, (ref) v_u_25
        debug.profilebegin("Inventory.Remote.CreateGameLoadout")
        if m_FlashEffect.IsFlashed() then
            debug.profilebegin("Inventory.CreateGameLoadout.CancelFlash")
            m_FlashEffect.CancelFlash()
            debug.profileend()
        end
        v_u_42()
        debug.profilebegin("Inventory.CreateGameLoadout.Loadout.new")
        v_u_27 = m_Loadout.new(...)
        debug.profileend()
        v_u_29 = tick()
        if v_u_27 then
            debug.profilebegin("Inventory.CreateGameLoadout.FireInventoryChanged")
            v_u_25:Fire(v_u_27.Inventory)
            debug.profileend()
        end
        debug.profileend()
    end)
    LocalPlayer:GetAttributeChangedSignal("CurrentEquipped"):Connect(function()
        -- upvalues: (ref) v_u_98
        task.defer(v_u_98)
    end)
end
function v_u_1.Start() -- name: Start
    -- upvalues: (copy) m_Remotes, (copy) m_DataController, (copy) LocalPlayer, (copy) m_Finishers, (copy) Players, (copy) m_PlayZeusDeath, (copy) m_RecycleFX, (copy) m_Character, (copy) m_CreateImpact, (copy) m_CreateMarker, (copy) m_CreateTracer, (copy) m_BreakGlass, (copy) m_CreateVoxelSmoke, (copy) m_CreateVoxelFire, (copy) ReplicatedStorage, (copy) m_FlashEffect, (copy) v_u_35, (ref) v_u_1, (copy) v_u_38, (copy) m_Router
    m_Remotes.VFX.ReplicateFinisher.Listen(function(p109)
        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (ref) m_Finishers, (ref) Players
        debug.profilebegin("VFX.Remote.ReplicateFinisher")
        if m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Ragdolls") ~= false and p109 then
            m_Finishers.ExecuteFinisher(p109)
            debug.profileend()
        else
            local v110 = p109.Victim
            if v110 then
                v110 = Players:GetPlayerByUserId(p109.Victim)
            end
            if v110 then
                v110 = v110.Character
            end
            if v110 then
                v110.Archivable = true
                v110:Destroy()
            end
            debug.profileend()
        end
    end)
    m_Remotes.UI.UIPlayerKilled.Listen(function(p111)
        -- upvalues: (ref) m_PlayZeusDeath
        debug.profilebegin("UI.Remote.UIPlayerKilled")
        if p111 and p111.Weapon == "Zeus x27" then
            m_PlayZeusDeath(p111.Victim)
        end
        debug.profileend()
    end)
    m_Remotes.VFX.CleanupDebris.Listen(m_RecycleFX)
    m_Remotes.VFX.CreateCharacterMuzzleFlash.Listen(function(p112)
        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (ref) m_Character
        debug.profilebegin("VFX.Remote.CreateCharacterMuzzleFlash")
        local v113 = m_DataController.Get(LocalPlayer, "Settings.Video.Presets.Muzzle Flash") ~= false
        if v113 or p112.WeaponName == "Zeus x27" then
            m_Character(p112.PlayerName, p112.WeaponName, p112.ShootingHand, p112.Suppressor, not v113)
            debug.profileend()
        else
            debug.profileend()
        end
    end)
    m_Remotes.VFX.CreateImpact.Listen(function(p114)
        -- upvalues: (ref) LocalPlayer, (ref) m_DataController, (ref) m_CreateImpact
        debug.profilebegin("VFX.Remote.CreateImpact")
        local v115
        if p114.AttackerUserId == nil then
            v115 = false
        else
            local AttackerUserId = p114.AttackerUserId
            local UserId = LocalPlayer.UserId
            v115 = AttackerUserId == tostring(UserId)
        end
        if v115 and m_DataController.Get(LocalPlayer, "Settings.Game.Other.Emit Particles When Server Validated") == true then
            debug.profileend()
        else
            m_CreateImpact(p114.Instance, p114.Material, p114.Position, p114.Normal, p114.Exit, p114.Ricochet, v115, p114.AttackerUserId, p114.IsWallbang, p114.WasHelmetHeadshot, p114.SuppressVisuals)
            debug.profileend()
        end
    end)
    m_Remotes.VFX.CreateMarker.Listen(function(p118)
        -- upvalues: (ref) m_CreateMarker
        debug.profilebegin("VFX.Remote.CreateMarker")
        m_CreateMarker(p118.Instance, p118.Type, p118.Position, p118.Normal)
        debug.profileend()
    end)
    m_Remotes.VFX.CreateTracer.Listen(function(p119)
        -- upvalues: (ref) m_CreateTracer
        debug.profilebegin("VFX.Remote.CreateTracer")
        m_CreateTracer(p119.Distance, p119.Origin, p119.Target)
        debug.profileend()
    end)
    m_Remotes.VFX.BreakGlass.Listen(function(p120)
        -- upvalues: (ref) m_BreakGlass
        debug.profilebegin("VFX.Remote.BreakGlass")
        m_BreakGlass(p120.Instance, p120.Position, p120.Direction)
        debug.profileend()
    end)
    m_Remotes.VFX.CreateVoxelSmoke.Listen(function(p121)
        -- upvalues: (ref) m_CreateVoxelSmoke
        debug.profilebegin("VFX.Remote.CreateVoxelSmoke")
        m_CreateVoxelSmoke.Create(p121)
        debug.profileend()
    end)
    m_Remotes.VFX.DestroyVoxelSmoke.Listen(function(p122)
        -- upvalues: (ref) m_CreateVoxelSmoke
        debug.profilebegin("VFX.Remote.DestroyVoxelSmoke")
        m_CreateVoxelSmoke.Destroy(p122)
        debug.profileend()
    end)
    m_Remotes.VFX.DisruptVoxelSmoke.Listen(function(p123)
        -- upvalues: (ref) m_CreateVoxelSmoke
        debug.profilebegin("VFX.Remote.DisruptVoxelSmoke")
        m_CreateVoxelSmoke.Disrupt(p123.Position, p123.Radius, p123.Duration)
        debug.profileend()
    end)
    m_Remotes.VFX.CreateVoxelFire.Listen(function(p124)
        -- upvalues: (ref) m_CreateVoxelFire
        debug.profilebegin("VFX.Remote.CreateVoxelFire")
        m_CreateVoxelFire.Create(p124)
        debug.profileend()
    end)
    m_Remotes.VFX.DestroyVoxelFire.Listen(function(p125)
        -- upvalues: (ref) m_CreateVoxelFire
        debug.profilebegin("VFX.Remote.DestroyVoxelFire")
        m_CreateVoxelFire.Destroy(p125)
        debug.profileend()
    end)
    m_Remotes.VFX.UpdateVoxelFire.Listen(function(p126)
        -- upvalues: (ref) m_CreateVoxelFire
        debug.profilebegin("VFX.Remote.UpdateVoxelFire")
        m_CreateVoxelFire.Update(p126)
        debug.profileend()
    end)
    local m_SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
    m_Remotes.VFX.FlashPlayer.Listen(function(p128)
        -- upvalues: (ref) m_FlashEffect, (ref) v_u_35
        debug.profilebegin("VFX.Remote.FlashPlayer")
        if m_FlashEffect.Flash(p128) and not p128.Duration then
            v_u_35()
        end
        debug.profileend()
    end)
    m_SpectateController.ListenToSpectate:Connect(function()
        -- upvalues: (ref) m_FlashEffect
        if m_FlashEffect.IsFlashed() then
            m_FlashEffect.CancelFlash()
        end
    end)
    require(ReplicatedStorage.Database.Components.GameState).ListenToState(function(_, p129)
        -- upvalues: (ref) m_CreateVoxelSmoke, (ref) m_CreateVoxelFire
        if p129 == "Buy Period" then
            m_CreateVoxelSmoke.DestroyAll()
            m_CreateVoxelFire.DestroyAll()
        end
    end)
    m_DataController.CreateListener(LocalPlayer, "Inventory", function(p130)
        -- upvalues: (ref) v_u_1
        debug.profilebegin("Inventory.DataListener.Inventory")
        v_u_1.UpdateStatTrack(p130)
        debug.profileend()
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Ragdolls", function(p131)
        -- upvalues: (ref) v_u_38
        if p131 == false then
            v_u_38()
        end
    end)
    m_Router.observerRouter("GetInventoryItemFromIdentifier", function(p132, p133)
        -- upvalues: (ref) v_u_1
        return v_u_1.GetInventoryItemFromIdentifier(p132, p133)
    end)
    m_Router.observerRouter("GetEquippedInventoryItem", function(p134, p135)
        -- upvalues: (ref) v_u_1
        return v_u_1.GetEquippedInventoryItem(p134, p135)
    end)
    m_Router.observerRouter("GetCurrentEquipped", function()
        -- upvalues: (ref) v_u_1
        return v_u_1.getCurrentEquipped()
    end)
end
return v_u_1
