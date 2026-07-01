-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local function v_u_25(p5, p6, p7, p8) -- name: UpdateBoat
    p7[1] = p7[1] + p6
    local Handle = p5.Handle
    if Handle and Handle:IsDescendantOf(workspace) then
        if not p8[1] then
            p8[1] = Handle.CFrame
        end
        local v10 = p8[1]
        local v11 = p7[1]
        local v12 = v11 * 0.8
        local v13 = math.sin(v12) * 0.05235987755982989
        local v14 = v11 * 0.8 * 0.7
        local v15 = math.cos(v14) * 0.05235987755982989 * 0.8
        local v16 = v11 * 0.5
        local v17 = math.sin(v16) * 0.15
        local v18 = v11 * 1.2
        local v19 = math.sin(v18) * 0.1
        local v20 = v10.LookVector * v17 + Vector3.new(0, v19, 0)
        local v21 = v10.Position + v20
        local v22 = CFrame.Angles(v13, 0, 0)
        local v23 = CFrame.Angles(0, 0, v15)
        local v24 = v10 * v22 * v23
        Handle.CFrame = v24 + (v21 - v24.Position)
    end
end
return m_Observers.observeTag("TugBoat", function(p_u_26)
    -- upvalues: (copy) m_Janitor, (copy) m_RunServiceController, (copy) v_u_25
    if p_u_26:IsDescendantOf(workspace) then
        local v_u_27 = m_Janitor.new()
        local v_u_28 = { nil }
        local v_u_29 = { 0 }
        local v30 = m_RunServiceController.CreateBindingName("Observers.Game.TugBoat.Update")
        v_u_27:Add(m_RunServiceController.BindToHeartbeat(v30, function(p31)
            -- upvalues: (ref) v_u_25, (copy) p_u_26, (copy) v_u_29, (copy) v_u_28
            v_u_25(p_u_26, p31, v_u_29, v_u_28)
        end))
        return function()
            -- upvalues: (copy) v_u_27
            v_u_27:Destroy()
        end
    end
end)
