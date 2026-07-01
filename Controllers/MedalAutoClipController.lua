-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local m_MedalClipper = require(ReplicatedStorage:WaitForChild("MedalClipper"))
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local v_u_6 = RunService:IsStudio()
local function v_u_10(p_u_7) -- name: triggerMedalClip
    -- upvalues: (copy) v_u_6, (copy) m_MedalClipper
    if v_u_6 then
        print("[MedalAutoClipController]", "Received clip request", ("eventId=%*"):format(p_u_7.EventId), ("eventName=%*"):format(p_u_7.EventName), ("duration=%*"):format(p_u_7.Duration), (("captureDelayMs=%*"):format(p_u_7.CaptureDelayMs or 0)))
    end
    local v8, v9 = pcall(function()
        -- upvalues: (ref) m_MedalClipper, (copy) p_u_7
        m_MedalClipper:TriggerClip(p_u_7.EventId, p_u_7.EventName, {
            ["duration"] = p_u_7.Duration,
            ["captureDelayMs"] = p_u_7.CaptureDelayMs,
            ["contextTags"] = p_u_7.ContextTags
        })
    end)
    if v8 then
        if v_u_6 then
            print("[MedalAutoClipController]", "Medal TriggerClip completed", p_u_7.EventName)
        end
    else
        warn((("[MedalAutoClipController] Failed to trigger Medal clip: %*"):format(v9)))
    end
end
function v1.Initialize() -- name: Initialize
    -- upvalues: (copy) m_Remotes, (copy) v_u_10
    m_Remotes.Collaborations.MedalAutoClip.Listen(v_u_10)
end
return v1
