-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
require(script:WaitForChild("Types"))
local m_Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local m_GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_CharacterAnimator = require(script.Classes.CharacterAnimator)
local m_Viewmodel = require(script.Classes.Viewmodel)
function v1.new(p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19) -- name: new
    -- upvalues: (copy) m_Janitor, (copy) m_GetWeaponProperties, (copy) m_CharacterAnimator, (copy) m_Viewmodel, (copy) m_Skins
    debug.profilebegin("WeaponComponent.new")
    local v_u_20 = {}
    debug.profilebegin("WeaponComponent.new.Janitor")
    v_u_20.Janitor = m_Janitor.new()
    v_u_20.IsDestroyed = false
    debug.profileend()
    v_u_20.OriginalOwner = p17
    v_u_20.Identifier = p9
    v_u_20.StatTrack = p15
    v_u_20.Stickers = p19
    v_u_20.NameTag = p16
    v_u_20.Player = p8
    v_u_20.Float = p14
    v_u_20.Name = p12
    v_u_20.Charm = p18
    v_u_20.Skin = p13
    v_u_20.Slot = p11
    v_u_20._id = p10
    debug.profilebegin("WeaponComponent.new.GetWeaponProperties")
    v_u_20.Properties = m_GetWeaponProperties(p12)
    debug.profileend()
    debug.profilebegin("WeaponComponent.new.CharacterAnimator")
    v_u_20.CharacterAnimator = m_CharacterAnimator.new(v_u_20.Player, p12)
    debug.profileend()
    debug.profilebegin("WeaponComponent.new.Viewmodel")
    local v21, v22 = pcall(m_Viewmodel.new, v_u_20, p12, p13)
    debug.profileend()
    if not v21 then
        debug.profileend()
        error(v22, 2)
    end
    v_u_20.Viewmodel = v22
    debug.profilebegin("WeaponComponent.new.CleanupCallbacks")
    v_u_20.Janitor:Add(function()
        -- upvalues: (copy) v_u_20
        if v_u_20.CharacterAnimator then
            v_u_20.CharacterAnimator:destroy()
            v_u_20.CharacterAnimator = nil
        end
    end)
    v_u_20.Janitor:Add(function()
        -- upvalues: (copy) v_u_20
        if v_u_20.Viewmodel then
            v_u_20.Viewmodel:destroy()
            v_u_20.Viewmodel = nil
        end
    end)
    debug.profileend()
    function v_u_20.updateStatTrackCounter(p23, p24)
        -- upvalues: (ref) m_Skins
        p23.StatTrack = p24
        local KillTrak = p23.StatTrack and p23.Viewmodel.Model:FindFirstChild("KillTrak", true)
        if KillTrak then
            KillTrak.Screen.SurfaceGui.TextLabel.Text = m_Skins.GetKillTrackValue(p24, p23.Name)
        end
    end
    debug.profileend()
    return v_u_20
end
function v1.destroy(p26) -- name: destroy
    debug.profilebegin("WeaponComponent.destroy")
    if p26.CharacterAnimator then
        p26.CharacterAnimator:destroy()
        p26.CharacterAnimator = nil
    end
    if p26.Viewmodel then
        p26.Viewmodel:destroy()
        p26.Viewmodel = nil
    end
    if p26.Janitor then
        p26.Janitor:Destroy()
        p26.Janitor = nil
    end
    p26.updateStatTrackCounter = nil
    p26.OriginalOwner = nil
    p26.Properties = nil
    p26.Identifier = nil
    p26.StatTrack = nil
    p26.Stickers = nil
    p26.NameTag = nil
    p26.Player = nil
    p26.Float = nil
    p26.Name = nil
    p26.Charm = nil
    p26.Skin = nil
    p26.Slot = nil
    p26._id = nil
    debug.profileend()
end
return v1
