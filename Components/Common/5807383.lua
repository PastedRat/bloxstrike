-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors)
local v_u_6 = m_Colors["Team Color"]["Counter-Terrorists"]
return function()
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer, (copy) m_Colors, (copy) v_u_6
    local v7 = m_DataController.Get(LocalPlayer, "Settings.Game.HUD.Color")
    local v8 = LocalPlayer:GetAttribute("Team")
    return m_Colors[v7] and m_Colors[v7][v8] or v_u_6
end
