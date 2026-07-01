-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local LocalPlayer = Players.LocalPlayer
local m_GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local m_NumberSlots = require(ReplicatedStorage.Database.Custom.GameStats.NumberSlots)
local m_Grenade = require(ReplicatedStorage.Components.Grenade)
local m_Weapon = require(ReplicatedStorage.Components.Weapon)
local m_Melee = require(ReplicatedStorage.Components.Melee)
local m_C4 = require(ReplicatedStorage.Components.C4)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local v_u_13 = {
    ["Grenade"] = m_Grenade,
    ["Weapon"] = m_Weapon,
    ["Melee"] = m_Melee,
    ["C4"] = m_C4
}
function v_u_1.setCurrentEquipped(p14, p15) -- name: setCurrentEquipped
    p14.PreviousEquipped = p14.CurrentEquipped
    p14.CurrentEquipped = p15
end
function v_u_1.getNextInventorySlotFromPriority(p16) -- name: getNextInventorySlotFromPriority
    -- upvalues: (copy) m_NumberSlots
    local v17 = -1
    local v18 = nil
    for v19, v20 in ipairs(p16.Inventory) do
        if #v20._items >= 1 then
            local v21 = m_NumberSlots.Priorities[v19] or 0
            if v17 < v21 then
                v18 = v19
                v17 = v21
            end
        end
    end
    return v18
end
function v_u_1.getInventoryItemFromLoadout(p22, p23) -- name: getInventoryItemFromLoadout
    local v24 = nil
    local v25 = nil
    local v26 = nil
    for v27, v28 in ipairs(p22.Inventory) do
        local _items = v28._items
        for v30, v31 in ipairs(_items) do
            if v31.Identifier == p23 then
                v26 = v30
                v25 = v27
                v24 = v31
                break
            end
        end
    end
    return v24, v25, v26
end
function v_u_1.removeInventoryItem(p32, p33) -- name: removeInventoryItem
    local v34, v35, v36 = p32:getInventoryItemFromLoadout(p33)
    local v37 = v34 and p32.Inventory[v35]
    if v37 then
        table.remove(v37._items, v36)
        if p32.CurrentEquipped == v34 then
            p32:setCurrentEquipped(nil)
        end
        v34:destroy()
    end
end
function v_u_1.grantPlayerInventoryItem(p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50) -- name: grantPlayerInventoryItem
    -- upvalues: (copy) m_GetWeaponProperties, (copy) v_u_13, (copy) LocalPlayer
    local v51 = p38.Inventory[p39]
    local v52 = ("%* does not exist in player inventory"):format(p39)
    assert(v51, v52)
    local v53 = m_GetWeaponProperties(p42)
    local v54 = ("Client couldn\'t find weapon properties for \"%*\""):format(p42)
    assert(v53, v54)
    local v55 = v_u_13[v53.Class]
    local v56 = ("Client couldn\'t find weapon component for \"%*\""):format(p42)
    assert(v55, v56)
    debug.profilebegin("Loadout.grantPlayerInventoryItem")
    debug.profilebegin("Loadout.grantPlayerInventoryItem.Component.new")
    local v57, v_u_58 = pcall(v55.new, LocalPlayer, p40, p41, p39, p42, p43, p44, p45, p46, p47, p48, p49, p50)
    debug.profileend()
    if not v57 then
        debug.profileend()
        error(v_u_58, 2)
    end
    debug.profilebegin("Loadout.grantPlayerInventoryItem.InsertAndCleanup")
    local _items_0 = v51._items
    table.insert(_items_0, v_u_58)
    p38.Janitor:Add(function()
        -- upvalues: (copy) v_u_58
        if v_u_58 then
            local v60 = v_u_58
            if getmetatable(v60) and not v_u_58.IsDestroyed then
                v_u_58:destroy()
            end
        end
    end)
    debug.profileend()
    debug.profileend()
end
function v_u_1.new(p61) -- name: new
    -- upvalues: (copy) v_u_1, (copy) m_Janitor, (copy) m_RunServiceController, (copy) LocalPlayer
    debug.profilebegin("Loadout.new")
    local v62 = v_u_1
    local v_u_63 = setmetatable({}, v62)
    v_u_63.Janitor = m_Janitor.new()
    v_u_63.IsDestroyed = false
    v_u_63.Inventory = p61
    v_u_63.PreviousEquipped = nil
    v_u_63.CurrentEquipped = nil
    v_u_63.Janitor:Add(m_RunServiceController.BindToRenderStep("Classes.Loadout.RenderEquippedViewmodel", function(p64)
        -- upvalues: (copy) v_u_63, (ref) LocalPlayer
        if v_u_63.IsDestroyed then
            return
        else
            local Character = LocalPlayer.Character
            if not (Character and Character:GetAttribute("Dead")) then
                if v_u_63.CurrentEquipped then
                    debug.profilebegin("Loadout.RenderEquippedViewmodel")
                    v_u_63.CurrentEquipped.Viewmodel:render(p64)
                    debug.profileend()
                end
            end
        end
    end))
    debug.profileend()
    return v_u_63
end
function v_u_1.destroy(p66) -- name: destroy
    if not p66.IsDestroyed then
        debug.profilebegin("Loadout.destroy")
        p66.IsDestroyed = true
        if p66.CurrentEquipped then
            if p66.CurrentEquipped.unequip then
                p66.CurrentEquipped:unequip()
            end
            if p66.CurrentEquipped.destroy and not p66.CurrentEquipped.IsDestroyed then
                p66.CurrentEquipped:destroy()
            end
            p66.CurrentEquipped = nil
        end
        if p66.PreviousEquipped then
            if p66.PreviousEquipped.destroy and not p66.PreviousEquipped.IsDestroyed then
                p66.PreviousEquipped:destroy()
            end
            p66.PreviousEquipped = nil
        end
        if p66.Inventory then
            for _, v67 in ipairs(p66.Inventory) do
                if v67 and v67._items then
                    table.clear(v67._items)
                end
            end
        end
        p66.Janitor:Destroy()
        p66.Janitor = nil
        p66.Inventory = nil
        debug.profileend()
    end
end
return v_u_1
