-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HapticService = game:GetService("HapticService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local LocalPlayer = Players.LocalPlayer
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local v_u_9 = {}
local v_u_10 = nil
local function v_u_14(p11) -- name: updateQueue
    -- upvalues: (copy) v_u_9, (copy) HapticService, (ref) v_u_10
    for v12, v13 in pairs(v_u_9) do
        v13.Length = v13.Length - p11
        if HapticService:IsMotorSupported(v13.InputMotor, v12) then
            HapticService:SetMotor(v13.InputMotor, v12, v13.Intensity)
        end
        if v13.Length <= 0 then
            HapticService:SetMotor(v13.InputMotor, v12, 0)
            v_u_9[v12] = nil
        end
    end
    if next(v_u_9) == nil and v_u_10 then
        v_u_10:Disconnect()
        v_u_10 = nil
    end
end
function v1.vibrate(p15, p16, p17) -- name: vibrate
    -- upvalues: (copy) UserInputService, (copy) m_DataController, (copy) LocalPlayer, (copy) v_u_9, (ref) v_u_10, (copy) m_RunServiceController, (copy) v_u_14
    local v18 = UserInputService:GetLastInputType() == Enum.UserInputType.Touch and "Mobile" or "Controller"
    local v19 = m_DataController.Get(LocalPlayer, "Settings.Game.Other." .. v18 .. " Haptics/Vibrations")
    local v20
    if v19 == nil then
        v20 = false
    else
        v20 = v19 ~= false
    end
    if v20 then
        local Gamepad1 = Enum.UserInputType.Gamepad1
        if v_u_9[p15] then
            local v22 = v_u_9[p15]
            v22.InputMotor = Gamepad1
            if v22.Length < p17 then
                v22.Length = p17
            end
            if v22.Intensity < p16 then
                v22.Intensity = p16
            end
        else
            v_u_9[p15] = {
                ["InputMotor"] = Gamepad1,
                ["Intensity"] = p16,
                ["Length"] = p17
            }
        end
        if v_u_10 then
            return
        end
        v_u_10 = m_RunServiceController.BindToRenderStep("HapticsController.UpdateQueue", v_u_14)
    end
end
return v1
