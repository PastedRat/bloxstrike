-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Janitor = require(ReplicatedStorage.Shared.Janitor)
local v_u_7 = {}
local v_u_8 = nil
local function v_u_27(p9) -- name: stepZones
    -- upvalues: (copy) Workspace, (copy) v_u_7, (ref) v_u_8
    local v10 = Workspace.CurrentCamera
    if v10 then
        v10 = v10.CFrame.Position
    end
    for v11, v12 in pairs(v_u_7) do
        if v11:IsDescendantOf(Workspace) then
            if v10 then
                v12.StepAccumulator = v12.StepAccumulator + p9
                if v12.StepAccumulator >= 0.06666666666666667 then
                    local StepAccumulator = v12.StepAccumulator
                    v12.StepAccumulator = 0
                    local v14 = StepAccumulator * 3
                    local v15 = math.min(1, v14)
                    local v16 = v11.CFrame:PointToObjectSpace(v10)
                    local v17 = v11.Size / 2
                    local v18 = v16.X
                    local v19
                    if math.abs(v18) <= v17.X then
                        local v20 = v16.Y
                        if math.abs(v20) <= v17.Y then
                            local v21 = v16.Z
                            v19 = math.abs(v21) <= v17.Z
                        else
                            v19 = false
                        end
                    else
                        v19 = false
                    end
                    for _, v22 in ipairs(v12.SoundDataList) do
                        local v23 = v19 and (v22.MaximumVolume or 0) or 0
                        local Volume = v22.GlobalSound.Volume
                        local v25 = v23 - Volume
                        if math.abs(v25) <= 0.002 then
                            if Volume ~= v23 then
                                v22.GlobalSound.Volume = v23
                            end
                            v22.CurrentVolume = v23
                        else
                            local v26 = Volume + v25 * v15
                            v22.GlobalSound.Volume = v26
                            v22.CurrentVolume = v26
                        end
                    end
                end
            end
        else
            v_u_7[v11] = nil
        end
    end
    if next(v_u_7) == nil and v_u_8 then
        v_u_8:Disconnect()
        v_u_8 = nil
    end
end
return m_Observers.observeTag("AmbiencePart", function(p_u_28)
    -- upvalues: (copy) m_Janitor, (copy) SoundService, (copy) v_u_7, (ref) v_u_8, (copy) m_RunServiceController, (copy) v_u_27
    if not p_u_28:IsDescendantOf(workspace) then
        return function() end
    end
    local v29 = {}
    for _, v30 in p_u_28:GetChildren() do
        if v30:IsA("Sound") then
            table.insert(v29, v30)
        end
    end
    if #v29 <= 0 then
        return function() end
    end
    local v_u_31 = m_Janitor.new()
    local v32 = {}
    for _, v33 in v29 do
        local v34 = v_u_31:Add(v33:Clone())
        v34.RollOffMode = Enum.RollOffMode.Inverse
        v34.RollOffMaxDistance = 10000
        v34.RollOffMinDistance = 10000
        v34.Parent = SoundService
        v34.PlayOnRemove = false
        v34.Volume = 0
        v34:Play()
        local v35 = {
            ["MaximumVolume"] = nil,
            ["GlobalSound"] = nil,
            ["CurrentVolume"] = 0,
            ["MaximumVolume"] = v33.Volume > 0 and v33.Volume or 1,
            ["GlobalSound"] = v34
        }
        table.insert(v32, v35)
    end
    v_u_7[p_u_28] = {
        ["Part"] = nil,
        ["SoundDataList"] = nil,
        ["StepAccumulator"] = 0,
        ["Part"] = p_u_28,
        ["SoundDataList"] = v32
    }
    if not v_u_8 then
        v_u_8 = m_RunServiceController.BindToHeartbeat("Observers.Game.AmbiencePart.UpdateZones", v_u_27)
    end
    v_u_31:Add(function()
        -- upvalues: (ref) v_u_7, (copy) p_u_28, (ref) v_u_8
        v_u_7[p_u_28] = nil
        if next(v_u_7) == nil and v_u_8 then
            v_u_8:Disconnect()
            v_u_8 = nil
        end
    end)
    return function()
        -- upvalues: (copy) v_u_31
        v_u_31:Cleanup()
    end
end)
