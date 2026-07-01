-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
require(script:WaitForChild("Types"))
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local function v_u_9(p5) -- name: updateScreen
    local Screen = p5:FindFirstChild("Screen")
    if Screen then
        for _, v7 in ipairs(Screen:GetChildren()) do
            if v7.Name == "Noise" then
                local v8 = math.random()
                v7.Transparency = math.clamp(v8, 0.2, 0.7)
                v7.Color3 = Color3.fromRGB(192 + math.random(-10, 10), 216 + math.random(-10, 10), 255 + math.random(-10, 10))
            end
        end
    end
end
local function v_u_14(p10) -- name: breakScreen
    -- upvalues: (copy) TweenService
    local Screen_0 = p10:FindFirstChild("Screen")
    if Screen_0 then
        TweenService:Create(Screen_0, TweenInfo.new(2.15), {
            ["Color"] = Color3.fromRGB(0, 0, 0)
        }):Play()
        local PointLight = Screen_0.ScreenLight.PointLight
        for _ = 1, 8 do
            PointLight.Enabled = not PointLight.Enabled
            task.wait(math.random(1, 4) / 10)
        end
        PointLight.Enabled = false
        for _, v13 in ipairs(Screen_0:GetChildren()) do
            if v13.Name == "Noise" then
                v13.Transparency = 1
            end
        end
    end
end
return m_Observers.observeTag("Television", function(p_u_15)
    -- upvalues: (copy) m_RunServiceController, (copy) v_u_9, (copy) m_Observers, (copy) v_u_14
    local v_u_16 = 0
    if p_u_15:IsDescendantOf(workspace) then
        local v17 = m_RunServiceController.CreateBindingName("Observers.Game.Television.Noise")
        local v_u_19 = m_RunServiceController.BindToHeartbeat(v17, function(p18)
            -- upvalues: (ref) v_u_16, (copy) p_u_15, (ref) v_u_9
            v_u_16 = v_u_16 + p18
            if v_u_16 >= 0.016666666666666666 then
                v_u_16 = v_u_16 - 0.016666666666666666
                if p_u_15 and p_u_15:IsDescendantOf(workspace) then
                    v_u_9(p_u_15)
                end
            end
        end)
        local v_u_20 = m_Observers.observeAttribute(p_u_15, "Broken", function(_)
            -- upvalues: (ref) v_u_14, (copy) p_u_15, (copy) v_u_19
            v_u_14(p_u_15)
            if v_u_19 and v_u_19.Connected then
                v_u_19:Disconnect()
            end
        end)
        return function()
            -- upvalues: (copy) v_u_20, (copy) v_u_19
            v_u_20()
            if v_u_19 and v_u_19.Connected then
                v_u_19:Disconnect()
            end
        end
    end
end)
