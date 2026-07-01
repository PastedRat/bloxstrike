-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(script:WaitForChild("Types"))
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local m_Spring = require(ReplicatedStorage.Shared.Spring)
function v_u_1.UpdateState(p6, p7) -- name: UpdateState
    if p6.Highlight and p6.Highlight.Parent then
        if p6.IsEnabled ~= p7 then
            p6.Highlight.Enabled = p7
            p6.IsEnabled = p7
        end
    end
end
function v_u_1.Construct(p8) -- name: Construct
    p8.Highlight.OutlineTransparency = p8.Properties.OutlineTransparency
    p8.Highlight.FillTransparency = p8.Properties.FillTransparency
    p8.Highlight.OutlineColor = p8.Properties.OutlineColor
    p8.Highlight.DepthMode = p8.Properties.DepthMode
    p8.Highlight.FillColor = p8.Properties.FillColor
end
local function v_u_14(p9, p10) -- name: waitForHumanoid
    local Humanoid = p9:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        return Humanoid
    end
    local v12 = tick()
    while p9.Parent do
        task.wait(0.1)
        local Humanoid_0 = p9:FindFirstChildOfClass("Humanoid")
        if Humanoid_0 then
            return Humanoid_0
        end
        if p10 and p10 <= tick() - v12 then
            return nil
        end
    end
    return nil
end
function v_u_1.new(p15, p16) -- name: new
    -- upvalues: (copy) v_u_1, (copy) m_Janitor, (copy) m_Spring, (copy) v_u_14, (copy) m_RunServiceController
    local v17 = v_u_1
    local v_u_18 = setmetatable({}, v17)
    v_u_18.Janitor = m_Janitor.new()
    v_u_18.CurrentTransparency = m_Spring.new(0.95, 1.5, 0.6)
    v_u_18.Properties = p16
    v_u_18.Character = p15
    v_u_18.Highlight = v_u_18.Janitor:Add(Instance.new("Highlight", p15))
    v_u_18.Highlight.Enabled = false
    v_u_18.IsEnabled = false
    v_u_18.OutlineOnly = false
    v_u_18:Construct()
    local v19 = v_u_14(p15)
    if v19 then
        v_u_18.Janitor:Add(v19.Died:Connect(function()
            -- upvalues: (copy) v_u_18
            v_u_18:Destroy()
        end))
    end
    local v20 = m_RunServiceController.CreateBindingName("Classes.CharacterHighlight.Pulse")
    v_u_18.Janitor:Add(m_RunServiceController.BindToHeartbeat(v20, function(p21)
        -- upvalues: (copy) v_u_18
        if v_u_18.Highlight and v_u_18.Highlight.Parent then
            local v22 = v_u_18.CurrentTransparency:getPosition()
            v_u_18.CurrentTransparency:update(p21)
            if v22 >= 0.8 then
                v_u_18.CurrentTransparency:setGoal(0.6)
            elseif v22 <= 0.6 then
                v_u_18.CurrentTransparency:setGoal(0.8)
            end
            if v_u_18.OutlineOnly then
                v_u_18.Highlight.FillColor = v_u_18.Properties.OutlineColor:Lerp(Color3.new(1, 1, 1), 0.2)
                v_u_18.Highlight.FillTransparency = 0.9
            else
                v_u_18.Highlight.FillColor = v_u_18.Properties.FillColor
                v_u_18.Highlight.FillTransparency = v22
            end
        else
            return
        end
    end))
    return v_u_18
end
function v_u_1.Destroy(p23) -- name: Destroy
    p23.Janitor:Destroy()
end
return v_u_1
