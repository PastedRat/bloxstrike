-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
require(script:WaitForChild("Types"))
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local function v_u_7(p5, p6) -- name: OpenGarage
    -- upvalues: (copy) m_Sound, (copy) TweenService
    m_Sound.new("Miscellaneous"):playOneTime({
        ["Parent"] = nil,
        ["Name"] = "Open Garage",
        ["Parent"] = p5.Handle
    })
    return TweenService:Create(p5.Handle, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ["Position"] = p6 + Vector3.new(0, 10, 0)
    })
end
local function v_u_10(p8, p9) -- name: CloseGarage
    -- upvalues: (copy) m_Sound, (copy) TweenService
    m_Sound.new("Miscellaneous"):playOneTime({
        ["Parent"] = nil,
        ["Name"] = "Close Garage",
        ["Parent"] = p8.Handle
    })
    return TweenService:Create(p8.Handle, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ["Position"] = p9
    })
end
return m_Observers.observeTag("Garage", function(p_u_11)
    -- upvalues: (copy) m_Observers, (copy) v_u_7, (copy) v_u_10
    p_u_11:WaitForChild("Handle")
    if p_u_11:IsDescendantOf(workspace) then
        local Position = p_u_11.Handle.Position
        local v_u_13 = nil
        return m_Observers.observeAttribute(p_u_11, "CurrentState", function(p14)
            -- upvalues: (ref) v_u_13, (ref) v_u_7, (copy) p_u_11, (copy) Position, (ref) v_u_10
            if v_u_13 then
                v_u_13:Cancel()
                v_u_13 = nil
            end
            if not p14 then
                local v15 = v_u_10(p_u_11, Position)
                v_u_13 = v15
                v15:Play()
                return function()
                    -- upvalues: (ref) p_u_11, (ref) v_u_10, (ref) Position
                    if p_u_11:IsDescendantOf(workspace) then
                        v_u_10(p_u_11, Position)
                    end
                end
            end
            local v16 = v_u_7(p_u_11, Position)
            v_u_13 = v16
            v16:Play()
        end)
    end
end)
