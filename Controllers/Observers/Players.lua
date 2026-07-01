-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_DebugFlags = require(ReplicatedStorage.Shared.DebugFlags)
local LocalPlayer = Players.LocalPlayer
local m_CreateWeaponModel = require(script.Components.CreateWeaponModel)
local v_u_8 = {}
local function v_u_16(p9) -- name: clearCurrentEquippedVisuals
    -- upvalues: (copy) v_u_8
    debug.profilebegin("Observers.Players.ClearCurrentEquippedVisuals")
    v_u_8[p9] = nil
    local Character = p9.Character
    if Character and Character:IsDescendantOf(workspace) then
        local WeaponAttachments = Character:FindFirstChild("WeaponAttachments")
        if WeaponAttachments then
            debug.profilebegin("Observers.Players.ClearVisuals.ClearWeaponAttachments")
            WeaponAttachments:ClearAllChildren()
            debug.profileend()
        end
        local WeaponModel = Character:FindFirstChild("WeaponModel")
        if WeaponModel then
            debug.profilebegin("Observers.Players.ClearVisuals.ClearWeaponModel")
            WeaponModel:ClearAllChildren()
            debug.profileend()
        end
        local Debris = workspace:FindFirstChild("Debris")
        if Debris then
            local v14 = Debris:FindFirstChild(p9.Name .. "_Weapon")
            if v14 and v14 then
                debug.profilebegin("Observers.Players.ClearVisuals.DestroyEquippedWeapon")
                v14:Destroy()
                debug.profileend()
            end
            local v15 = Debris:FindFirstChild(p9.Name .. "_WeaponAttachments")
            if v15 and v15 then
                debug.profilebegin("Observers.Players.ClearVisuals.DestroyAttachmentsFolder")
                v15:Destroy()
                debug.profileend()
            end
            debug.profileend()
        else
            debug.profileend()
        end
    else
        debug.profileend()
        return
    end
end
local function v_u_21(p17) -- name: buildInventorySlots
    -- upvalues: (copy) HttpService
    debug.profilebegin("Observers.Players.BuildInventorySlots")
    local v18 = {}
    for v19 = 1, 3 do
        local v20 = p17:GetAttribute("Slot" .. v19)
        if v20 then
            debug.profilebegin("Observers.Players.BuildInventorySlots.JSONDecode")
            v18[v19] = HttpService:JSONDecode(v20)
            debug.profileend()
        end
    end
    debug.profileend()
    return v18
end
local function v_u_32(p22) -- name: stickerSignature
    if typeof(p22) ~= "table" then
        return ""
    end
    local v23 = {}
    for v24, v25 in ipairs(p22) do
        if typeof(v25) == "table" then
            local Position = v25.Position
            local v27 = typeof(Position) == "table" and (Position.Rotation or "") or ""
            local v28 = typeof(Position) == "table" and (Position.X or "") or ""
            local v29 = typeof(Position) == "table" and (Position.Y or "") or ""
            local format = string.format
            local v31 = v25.Sticker or ""
            v23[v24] = format("%s@%s,%s,%s", tostring(v31), tostring(v27), tostring(v28), (tostring(v29)))
        else
            v23[v24] = tostring(v25)
        end
    end
    return table.concat(v23, ";")
end
local function v_u_55(p33) -- name: visualSignature
    -- upvalues: (copy) v_u_32
    debug.profilebegin("Observers.Players.VisualSignature")
    if typeof(p33) ~= "table" then
        debug.profileend()
        return ""
    end
    local concat = table.concat
    local v35 = {}
    local v36 = p33.Identifier or ""
    local v37 = tostring(v36)
    local v38 = p33.Name or ""
    local v39 = tostring(v38)
    local v40 = p33.Skin or ""
    local v41 = tostring(v40)
    local v42 = p33.Float or ""
    local v43 = tostring(v42)
    local v44 = p33.StatTrack or ""
    local v45 = tostring(v44)
    local v46 = p33.NameTag or ""
    local v47 = tostring(v46)
    local Charm = p33.Charm
    local v49
    if Charm == nil or Charm == false then
        v49 = ""
    elseif typeof(Charm) == "table" then
        local v50 = Charm._id or ""
        local v51 = tostring(v50)
        local v52 = Charm.Position or ""
        v49 = v51 .. "@" .. tostring(v52)
    else
        v49 = tostring(Charm)
    end
    local v53 = p33.IsSuppressed or ""
    __set_list(v35, 1, {v37, v39, v41, v43, v45, v47, v49, tostring(v53), v_u_32(p33.Stickers)})
    local v54 = concat(v35, "|")
    debug.profileend()
    return v54
end
local function v_u_59(p_u_56) -- name: refreshObjectiveKitHolster
    -- upvalues: (copy) m_CreateWeaponModel, (copy) m_DebugFlags
    local v57, v58 = pcall(function()
        -- upvalues: (ref) m_CreateWeaponModel, (copy) p_u_56
        m_CreateWeaponModel.RefreshObjectiveKitHolster(p_u_56)
    end)
    if m_DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not v57 then
        warn(("[ThirdPersonWeaponModels] %s RefreshObjectiveKitHolster failed: %s"):format(p_u_56.Name, (tostring(v58))))
    end
end
local function v_u_64(p_u_60) -- name: createObjectiveKitListener
    -- upvalues: (copy) m_Observers, (copy) v_u_59
    local v_u_61 = m_Observers.observeAttribute(p_u_60, "HasDefuseKit", function()
        -- upvalues: (ref) v_u_59, (copy) p_u_60
        v_u_59(p_u_60)
        return function() end
    end)
    local v_u_62 = m_Observers.observeAttribute(p_u_60, "HasRescueKit", function()
        -- upvalues: (ref) v_u_59, (copy) p_u_60
        v_u_59(p_u_60)
        return function() end
    end)
    local v_u_63 = p_u_60.CharacterAdded:Connect(function()
        -- upvalues: (ref) v_u_59, (copy) p_u_60
        v_u_59(p_u_60)
    end)
    v_u_59(p_u_60)
    return function()
        -- upvalues: (copy) v_u_61, (copy) v_u_62, (copy) v_u_63
        v_u_61()
        v_u_62()
        v_u_63:Disconnect()
    end
end
local function v_u_68(p_u_65) -- name: refreshBombHolster
    -- upvalues: (copy) m_CreateWeaponModel, (copy) m_DebugFlags
    debug.profilebegin("Observers.Players.RefreshBombHolster")
    local v66, v67 = pcall(function()
        -- upvalues: (ref) m_CreateWeaponModel, (copy) p_u_65
        m_CreateWeaponModel.RefreshBombHolster(p_u_65)
    end)
    if m_DebugFlags.IsEnabled("ThirdPersonWeaponModels") and not v66 then
        warn(("[ThirdPersonWeaponModels] %s RefreshBombHolster failed: %s"):format(p_u_65.Name, (tostring(v67))))
    end
    debug.profileend()
end
local function v_u_77(p_u_69) -- name: createBombHolsterListener
    -- upvalues: (copy) v_u_68, (copy) m_Observers
    local v70 = p_u_69:GetAttribute("CurrentEquipped")
    local v_u_71 = typeof(v70) == "string" and (string.match(v70, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or ""
    local v_u_72 = p_u_69:GetAttributeChangedSignal("Slot5"):Connect(function()
        -- upvalues: (ref) v_u_68, (copy) p_u_69
        v_u_68(p_u_69)
    end)
    local v_u_75 = m_Observers.observeAttribute(p_u_69, "CurrentEquipped", function(p73)
        -- upvalues: (ref) v_u_71, (ref) v_u_68, (copy) p_u_69
        local v74 = typeof(p73) == "string" and (string.match(p73, "\"Name\"%s*:%s*\"([^\"]+)\"") or "") or ""
        if v74 == v_u_71 then
            return function() end
        end
        v_u_71 = v74
        v_u_68(p_u_69)
        return function() end
    end)
    local v_u_76 = p_u_69.CharacterAdded:Connect(function()
        -- upvalues: (ref) v_u_68, (copy) p_u_69
        v_u_68(p_u_69)
    end)
    v_u_68(p_u_69)
    return function()
        -- upvalues: (copy) v_u_72, (copy) v_u_75, (copy) v_u_76
        v_u_72:Disconnect()
        v_u_75()
        v_u_76:Disconnect()
    end
end
return m_Observers.observePlayer(function(p_u_78)
    -- upvalues: (copy) LocalPlayer, (copy) m_Observers, (copy) m_DebugFlags, (copy) v_u_16, (copy) HttpService, (copy) v_u_55, (copy) v_u_8, (copy) m_CreateWeaponModel, (copy) v_u_21, (copy) v_u_64, (copy) v_u_77
    debug.profilebegin("Observers.Players.observePlayer")
    if p_u_78 == LocalPlayer then
        debug.profileend()
        return function() end
    end
    debug.profilebegin("Observers.Players.CreateListeners")
    local v_u_87 = m_Observers.observeAttribute(p_u_78, "CurrentEquipped", function(p79)
        -- upvalues: (ref) m_DebugFlags, (copy) p_u_78, (ref) v_u_16, (ref) HttpService, (ref) v_u_55, (ref) v_u_8, (ref) m_CreateWeaponModel, (ref) v_u_21
        debug.profilebegin("Observers.Players.CurrentEquippedChanged")
        if m_DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            local v80 = warn
            local Name = p_u_78.Name
            local v82 = typeof(p79) == "string" and (#p79 or -1) or -1
            v80(("[ThirdPersonWeaponModels] %s CurrentEquipped changed (%s bytes JSON)"):format(Name, (tostring(v82))))
        end
        if not p79 then
            v_u_16(p_u_78)
            debug.profileend()
            return function() end
        end
        debug.profilebegin("Observers.Players.CurrentEquipped.JSONDecode")
        local v_u_83 = HttpService:JSONDecode(p79)
        debug.profileend()
        local v84 = v_u_55(v_u_83)
        if v84 ~= "" and v_u_8[p_u_78] == v84 then
            debug.profileend()
            return function() end
        end
        v_u_8[p_u_78] = v84
        debug.profilebegin("Observers.Players.CurrentEquipped.CreateWeaponModel")
        local v85, v86, _ = pcall(function()
            -- upvalues: (ref) m_CreateWeaponModel, (ref) p_u_78, (copy) v_u_83, (ref) v_u_21
            return m_CreateWeaponModel(p_u_78, v_u_83, (v_u_21(p_u_78)))
        end)
        debug.profileend()
        if m_DebugFlags.IsEnabled("ThirdPersonWeaponModels") then
            if v85 then
                warn(("[ThirdPersonWeaponModels] %s CreateWeaponModel ok"):format(p_u_78.Name))
            else
                warn(("[ThirdPersonWeaponModels] %s CreateWeaponModel failed: %s"):format(p_u_78.Name, (tostring(v86))))
            end
        end
        debug.profileend()
        return function()
            -- upvalues: (ref) p_u_78, (ref) v_u_16
            if p_u_78:GetAttribute("CurrentEquipped") == nil then
                v_u_16(p_u_78)
            end
        end
    end)
    local v_u_88 = v_u_64(p_u_78)
    local v_u_89 = v_u_77(p_u_78)
    debug.profileend()
    debug.profileend()
    return function()
        -- upvalues: (copy) v_u_87, (copy) v_u_88, (copy) v_u_89, (ref) m_CreateWeaponModel, (copy) p_u_78, (ref) v_u_8
        debug.profilebegin("Observers.Players.DisconnectPlayer")
        v_u_87()
        v_u_88()
        v_u_89()
        m_CreateWeaponModel.ClearPlayerCache(p_u_78)
        v_u_8[p_u_78] = nil
        debug.profileend()
    end
end)
