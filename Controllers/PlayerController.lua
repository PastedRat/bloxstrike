-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local v_u_4 = tick()
local m_GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Remotes = require(ReplicatedStorage.Database.Security.Remotes)
local function v_u_9(_) -- name: HandleNextFrame
    -- upvalues: (copy) m_Remotes, (ref) v_u_4
    debug.profilebegin("PlayerController.HandleNextFrame")
    local v8 = tick()
    m_Remotes.Player.BlankRequest.Send(v8)
    if v8 - v_u_4 >= 900 then
        m_Remotes.Player.AFKTeleport.Send()
        v_u_4 = v8
        debug.profileend()
    else
        debug.profileend()
    end
end
function v1.Initialize() -- name: Initialize
    -- upvalues: (copy) UserInputService, (ref) v_u_4, (copy) m_Remotes
    UserInputService.InputBegan:Connect(function()
        -- upvalues: (ref) v_u_4
        v_u_4 = tick()
    end)
    UserInputService.InputChanged:Connect(function()
        -- upvalues: (ref) v_u_4
        v_u_4 = tick()
    end)
    m_Remotes.Player.BlankRequest.Listen(function(p10)
        -- upvalues: (ref) m_Remotes
        local Send = m_Remotes.Player.ReportPlayerConnect.Send
        local v12 = (tick() - p10) * 1000
        local v13 = math.floor(v12)
        Send((tostring(v13)))
    end)
end
function v1.Start() -- name: Start
    -- upvalues: (copy) m_GetUserPlatform, (copy) m_Remotes, (copy) m_RunServiceController, (copy) v_u_9
    local v_u_14 = 0
    task.delay(5, function()
        -- upvalues: (ref) m_GetUserPlatform, (ref) m_Remotes
        local v15 = m_GetUserPlatform()
        if v15 and #v15 > 0 then
            local v16 = v15[1]
            m_Remotes.Player.SubmitUserPlatformAnalytics.Send(v16)
        end
    end)
    m_RunServiceController.BindToHeartbeat("PlayerController.ReportPlayerState", function(p17)
        -- upvalues: (ref) v_u_14, (ref) v_u_9
        v_u_14 = v_u_14 + p17
        if v_u_14 >= 5 then
            v_u_14 = v_u_14 - 5
            v_u_9(p17)
        end
    end)
end
return v1
