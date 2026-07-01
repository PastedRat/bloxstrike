-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
require(script.Types)
local LocalPlayer = Players.LocalPlayer
local m_SpectateController = require(ReplicatedStorage.Controllers.SpectateController)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Class = require(script.Class)
local v_u_9 = {}
LocalPlayer.CharacterAdded:Connect(function(_)
    -- upvalues: (copy) v_u_9
    for _, v10 in pairs(v_u_9) do
        v10:UpdateVisibility(nil)
    end
end)
m_SpectateController.ListenToSpectate:Connect(function(p11)
    -- upvalues: (copy) v_u_9
    if p11 then
        p11 = p11:GetAttribute("Team")
    end
    for _, v12 in pairs(v_u_9) do
        v12:UpdateVisibility(p11)
    end
end)
return m_Observers.observeTag("PlayerPositionMarker", function(p13)
    -- upvalues: (copy) m_DataController, (copy) LocalPlayer, (copy) HttpService, (copy) m_Class, (copy) m_SpectateController, (copy) v_u_9
    if m_DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" then
        return nil
    end
    if not p13:IsDescendantOf(workspace) then
        return nil
    end
    local v_u_14 = HttpService:GenerateGUID(false)
    local new = m_Class.new
    local v16 = m_SpectateController.GetPlayer()
    local v17
    if v16 and v16 ~= LocalPlayer then
        v17 = v16:GetAttribute("Team")
    else
        v17 = nil
    end
    local v_u_18 = new(p13, v_u_14, v17)
    v_u_9[v_u_14] = v_u_18
    return function()
        -- upvalues: (ref) v_u_9, (copy) v_u_14, (copy) v_u_18
        v_u_9[v_u_14] = nil
        v_u_18:Destroy()
    end
end)
