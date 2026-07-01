-- Decompiled with Medal

local Players = game:GetService("Players")
local v_u_2 = game:GetService("RunService"):IsServer()
local LocalPlayer = Players.LocalPlayer
local v_u_4 = {}
local v_u_5 = nil
local function v_u_8() -- name: getSnapshot
    -- upvalues: (copy) v_u_2, (ref) v_u_5
    if not v_u_2 then
        return nil
    end
    if v_u_5 then
        return v_u_5
    end
    local v6, v_u_7 = pcall(function()
        return game:GetService("ConfigService"):GetConfigAsync()
    end)
    if not (v6 and v_u_7) then
        return nil
    end
    v_u_5 = v_u_7
    v_u_7.UpdateAvailable:Connect(function()
        -- upvalues: (copy) v_u_7
        pcall(v_u_7.Refresh, v_u_7)
    end)
    return v_u_5
end
function v_u_4.Get(p9) -- name: Get
    -- upvalues: (copy) v_u_2, (copy) v_u_8, (copy) LocalPlayer
    if v_u_2 then
        local v10 = v_u_8()
        if v10 then
            local v11, v12 = pcall(v10.GetValue, v10, p9)
            if v11 then
                return v12
            else
                return nil
            end
        else
            return nil
        end
    else
        return LocalPlayer:GetAttribute(p9)
    end
end
function v_u_4.GetNumber(p13, p14) -- name: GetNumber
    -- upvalues: (copy) v_u_4
    local v15 = v_u_4.Get(p13)
    return tonumber(v15) or p14
end
function v_u_4.GetRewardMultiplier(p16) -- name: GetRewardMultiplier
    -- upvalues: (copy) v_u_4
    local GetNumber = v_u_4.GetNumber
    return math.max(0, GetNumber(p16, 1))
end
function v_u_4.OnChanged(p_u_18, p_u_19) -- name: OnChanged
    -- upvalues: (copy) v_u_2, (copy) v_u_8, (copy) LocalPlayer
    if v_u_2 then
        local v_u_20 = v_u_8()
        if v_u_20 then
            local v21, v22 = pcall(v_u_20.GetValueChangedSignal, v_u_20, p_u_18)
            if v21 and v22 then
                return v22:Connect(function()
                    -- upvalues: (copy) v_u_20, (copy) p_u_18, (copy) p_u_19
                    local v23, v24 = pcall(v_u_20.GetValue, v_u_20, p_u_18)
                    local v25 = p_u_19
                    if not v23 then
                        v24 = nil
                    end
                    v25(v24)
                end)
            else
                return nil
            end
        else
            return nil
        end
    else
        return LocalPlayer:GetAttributeChangedSignal(p_u_18):Connect(function()
            -- upvalues: (copy) p_u_19, (ref) LocalPlayer, (copy) p_u_18
            p_u_19(LocalPlayer:GetAttribute(p_u_18))
        end)
    end
end
return v_u_4
