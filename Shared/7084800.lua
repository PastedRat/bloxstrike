-- Decompiled with Medal

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat
local LocalPlayer = RunService:IsClient()
if LocalPlayer then
    LocalPlayer = Players.LocalPlayer
end
game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local v_u_6 = require(script.Enum).enums
local m_Janitor = require(script.Janitor)
local m_Signal = require(script.Signal)
local m_ZonePlusReference = require(script.ZonePlusReference)
local v10 = m_ZonePlusReference.getObject()
local ZoneController = script.ZoneController
local Tracker = ZoneController.Tracker
local CollectiveWorldModel = ZoneController.CollectiveWorldModel
local v_u_14 = require(ZoneController)
local v15 = game:GetService("RunService"):IsClient() and "Client" or "Server"
local v16
if v10 then
    v16 = v10:FindFirstChild(v15)
else
    v16 = v10
end
if v16 then
    return require(v10.Value)
end
local v_u_17 = {}
v_u_17.__index = v_u_17
if not v16 then
    m_ZonePlusReference.addToReplicatedStorage()
end
v_u_17.enum = v_u_6
function v_u_17.new(p18) -- name: new
    -- upvalues: (copy) v_u_17, (copy) v_u_6, (copy) m_Janitor, (copy) HttpService, (copy) v_u_14, (copy) m_Signal, (copy) LocalPlayer
    local v_u_19 = {}
    local v20 = v_u_17
    setmetatable(v_u_19, v20)
    local v21 = typeof(p18)
    if v21 ~= "table" and v21 ~= "Instance" then
        error("The zone container must be a model, folder, basepart or table!")
    end
    v_u_19.accuracy = v_u_6.Accuracy.High
    v_u_19.autoUpdate = true
    v_u_19.respectUpdateQueue = true
    local v22 = m_Janitor.new()
    v_u_19.janitor = v22
    v_u_19._updateConnections = v22:add(m_Janitor.new(), "destroy")
    v_u_19.container = p18
    v_u_19.zoneParts = {}
    v_u_19.overlapParams = {}
    v_u_19.region = nil
    v_u_19.volume = nil
    v_u_19.boundMin = nil
    v_u_19.boundMax = nil
    v_u_19.recommendedMaxParts = nil
    v_u_19.zoneId = HttpService:GenerateGUID()
    v_u_19.activeTriggers = {}
    v_u_19.occupants = {}
    v_u_19.trackingTouchedTriggers = {}
    v_u_19.enterDetection = v_u_6.Detection.Centre
    v_u_19.exitDetection = v_u_6.Detection.Centre
    v_u_19._currentEnterDetection = nil
    v_u_19._currentExitDetection = nil
    v_u_19.totalPartVolume = 0
    v_u_19.allZonePartsAreBlocks = true
    v_u_19.trackedItems = {}
    v_u_19.settingsGroupName = nil
    v_u_19.worldModel = workspace
    v_u_19.onItemDetails = {}
    v_u_19.itemsToUntrack = {}
    v_u_14.updateDetection(v_u_19)
    v_u_19.updated = v22:add(m_Signal.new(), "destroy")
    local v23 = {
        "player",
        "part",
        "localPlayer",
        "item"
    }
    local v24 = { "entered", "exited" }
    for _, v_u_25 in pairs(v23) do
        local v_u_26 = 0
        local v_u_27 = 0
        for _, v28 in pairs(v24) do
            local v29 = v22:add(m_Signal.new(true), "destroy")
            local v_u_30 = v28:sub(1, 1):upper() .. v28:sub(2)
            v_u_19[v_u_25 .. v_u_30] = v29
            v29.connectionsChanged:Connect(function(p31)
                -- upvalues: (copy) v_u_25, (ref) LocalPlayer, (copy) v_u_30, (ref) v_u_26, (ref) v_u_27, (ref) v_u_14, (copy) v_u_19
                if v_u_25 == "localPlayer" and (not LocalPlayer and p31 == 1) then
                    error(("Can only connect to \'localPlayer%s\' on the client!"):format(v_u_30))
                end
                v_u_26 = v_u_27
                v_u_27 = v_u_27 + p31
                if v_u_26 == 0 and v_u_27 > 0 then
                    v_u_14._registerConnection(v_u_19, v_u_25, v_u_30)
                elseif v_u_26 > 0 and v_u_27 == 0 then
                    v_u_14._deregisterConnection(v_u_19, v_u_25)
                end
            end)
        end
    end
    v_u_17.touchedConnectionActions = {}
    for _, v32 in pairs(v23) do
        local v_u_33 = v_u_19[("_%sTouchedZone"):format(v32)]
        if v_u_33 then
            v_u_19.trackingTouchedTriggers[v32] = {}
            v_u_17.touchedConnectionActions[v32] = function(p34)
                -- upvalues: (copy) v_u_33, (copy) v_u_19
                v_u_33(v_u_19, p34)
            end
        end
    end
    v_u_19:_update()
    v_u_14._registerZone(v_u_19)
    v22:add(function()
        -- upvalues: (ref) v_u_14, (copy) v_u_19
        v_u_14._deregisterZone(v_u_19)
    end, true)
    return v_u_19
end
function v_u_17.fromRegion(p35, p36) -- name: fromRegion
    -- upvalues: (copy) v_u_17
    local v_u_37 = Instance.new("Model")
    local function v_u_43(p38, p39) -- name: createCube
        -- upvalues: (copy) v_u_43, (copy) v_u_37
        if p39.X > 2024 or (p39.Y > 2024 or p39.Z > 2024) then
            local v40 = p39 * 0.25
            local v41 = p39 * 0.5
            v_u_43(p38 * CFrame.new(-v40.X, -v40.Y, -v40.Z), v41)
            v_u_43(p38 * CFrame.new(-v40.X, -v40.Y, v40.Z), v41)
            v_u_43(p38 * CFrame.new(-v40.X, v40.Y, -v40.Z), v41)
            v_u_43(p38 * CFrame.new(-v40.X, v40.Y, v40.Z), v41)
            v_u_43(p38 * CFrame.new(v40.X, -v40.Y, -v40.Z), v41)
            v_u_43(p38 * CFrame.new(v40.X, -v40.Y, v40.Z), v41)
            v_u_43(p38 * CFrame.new(v40.X, v40.Y, -v40.Z), v41)
            v_u_43(p38 * CFrame.new(v40.X, v40.Y, v40.Z), v41)
        else
            local v42 = Instance.new("Part")
            v42.CFrame = p38
            v42.Size = p39
            v42.Anchored = true
            v42.Parent = v_u_37
        end
    end
    v_u_43(p35, p36)
    local v44 = v_u_17.new(v_u_37)
    v44:relocate()
    return v44
end
function v_u_17._calculateRegion(_, p45, p46) -- name: _calculateRegion
    local v47 = {
        ["Min"] = {},
        ["Max"] = {}
    }
    for v_u_48, v49 in pairs(v47) do
        v49.Values = {}
        function v49.parseCheck(p50, p51) -- name: parseCheck
            -- upvalues: (copy) v_u_48
            if v_u_48 == "Min" then
                return p50 <= p51
            end
            if v_u_48 == "Max" then
                return p51 <= p50
            end
        end
        function v49.parse(p52, p53) -- name: parse
            for v54, v55 in pairs(p53) do
                local v56 = p52.Values[v54] or v55
                if p52.parseCheck(v55, v56) then
                    p52.Values[v54] = v55
                end
            end
        end
    end
    for _, v57 in pairs(p45) do
        local v58 = v57.Size * 0.5
        local v59 = {
            v57.CFrame * CFrame.new(-v58.X, -v58.Y, -v58.Z),
            v57.CFrame * CFrame.new(-v58.X, -v58.Y, v58.Z),
            v57.CFrame * CFrame.new(-v58.X, v58.Y, -v58.Z),
            v57.CFrame * CFrame.new(-v58.X, v58.Y, v58.Z),
            v57.CFrame * CFrame.new(v58.X, -v58.Y, -v58.Z),
            v57.CFrame * CFrame.new(v58.X, -v58.Y, v58.Z),
            v57.CFrame * CFrame.new(v58.X, v58.Y, -v58.Z),
            v57.CFrame * CFrame.new(v58.X, v58.Y, v58.Z)
        }
        for _, v60 in pairs(v59) do
            local v61, v62, v63 = v60:GetComponents()
            local v64 = { v61, v62, v63 }
            v47.Min:parse(v64)
            v47.Max:parse(v64)
        end
    end
    local v65 = {}
    local v66 = {}
    for v67, v68 in pairs(v47) do
        for _, v72 in pairs(v68.Values) do
            local v70 = v67 == "Min" and v66 and v66 or v65
            if not p46 then
                local v71 = (v72 + (v67 == "Min" and -2 or 2) + 2) / 4
                local v72 = math.floor(v71) * 4
            end
            table.insert(v70, v72)
        end
    end
    local v73 = unpack
    local v74 = Vector3.new(v73(v66))
    local v75 = unpack
    local v76 = Vector3.new(v75(v65))
    return Region3.new(v74, v76), v74, v76
end
function v_u_17._displayBounds(p77) -- name: _displayBounds
    if not p77.displayBoundParts then
        p77.displayBoundParts = true
        local v78 = {
            ["BoundMin"] = p77.boundMin,
            ["BoundMax"] = p77.boundMax
        }
        for v79, v80 in pairs(v78) do
            local v81 = Instance.new("Part")
            v81.Anchored = true
            v81.CanCollide = false
            v81.Transparency = 0.5
            v81.Size = Vector3.new(1, 1, 1)
            v81.Color = Color3.fromRGB(255, 0, 0)
            v81.CFrame = CFrame.new(v80)
            v81.Name = v79
            v81.Parent = workspace
            p77.janitor:add(v81, "Destroy")
        end
    end
end
function v_u_17._update(p_u_82) -- name: _update
    -- upvalues: (copy) RunService
    local container = p_u_82.container
    local v84 = {}
    local v_u_85 = 0
    p_u_82._updateConnections:clean()
    local v86 = typeof(container)
    local v87 = {}
    if v86 == "table" then
        for _, v88 in pairs(container) do
            if v88:IsA("BasePart") then
                table.insert(v84, v88)
            end
        end
    elseif v86 == "Instance" then
        if container:IsA("BasePart") then
            table.insert(v84, container)
        else
            table.insert(v87, container)
            for _, v89 in pairs(container:GetDescendants()) do
                if v89:IsA("BasePart") then
                    table.insert(v84, v89)
                else
                    table.insert(v87, v89)
                end
            end
        end
    end
    p_u_82.zoneParts = v84
    p_u_82.overlapParams = {}
    local v90 = true
    for _, v_u_91 in pairs(v84) do
        local _, v92 = pcall(function()
            -- upvalues: (copy) v_u_91
            return v_u_91.Shape.Name
        end)
        if v92 ~= "Block" then
            v90 = false
        end
    end
    p_u_82.allZonePartsAreBlocks = v90
    local v93 = OverlapParams.new()
    v93.FilterType = Enum.RaycastFilterType.Include
    v93.MaxParts = #v84
    v93.FilterDescendantsInstances = v84
    p_u_82.overlapParams.zonePartsWhitelist = v93
    local v94 = OverlapParams.new()
    v94.FilterType = Enum.RaycastFilterType.Exclude
    v94.FilterDescendantsInstances = v84
    p_u_82.overlapParams.zonePartsIgnorelist = v94
    local function v97() -- name: update
        -- upvalues: (copy) p_u_82, (ref) v_u_85, (ref) RunService
        if p_u_82.autoUpdate then
            local v_u_95 = os.clock()
            if p_u_82.respectUpdateQueue then
                v_u_85 = v_u_85 + 1
                v_u_95 = v_u_95 + 0.1
            end
            local v_u_96 = nil
            v_u_96 = RunService.Heartbeat:Connect(function()
                -- upvalues: (ref) v_u_95, (ref) v_u_96, (ref) p_u_82, (ref) v_u_85
                if v_u_95 <= os.clock() then
                    v_u_96:Disconnect()
                    if p_u_82.respectUpdateQueue then
                        v_u_85 = v_u_85 - 1
                    end
                    if v_u_85 == 0 and p_u_82.zoneId then
                        p_u_82:_update()
                    end
                end
            end)
        end
    end
    local v98 = { "Size", "Position" }
    for _, v_u_99 in pairs(v84) do
        for _, v100 in pairs(v98) do
            p_u_82._updateConnections:add(v_u_99:GetPropertyChangedSignal(v100):Connect(v97), "Disconnect")
        end
        local CollisionGroup = v_u_99.CollisionGroup
        if CollisionGroup ~= "Default" and CollisionGroup ~= "Debris" then
            error("Zone parts must belong to the \'Default\' or \'Debris\' CollisionGroup.")
        end
        p_u_82._updateConnections:add(v_u_99:GetPropertyChangedSignal("CollisionGroupId"):Connect(function()
            -- upvalues: (copy) v_u_99
            local CollisionGroup_0 = v_u_99.CollisionGroup
            if CollisionGroup_0 ~= "Default" and CollisionGroup_0 ~= "Debris" then
                error("Zone parts must belong to the \'Default\' or \'Debris\' CollisionGroup.")
            end
        end), "Disconnect")
    end
    local v103 = { "ChildAdded", "ChildRemoved" }
    for _, _ in pairs(v87) do
        for _, v104 in pairs(v103) do
            p_u_82._updateConnections:add(p_u_82.container[v104]:Connect(function(p105)
                -- upvalues: (copy) p_u_82, (ref) v_u_85, (ref) RunService
                if p105:IsA("BasePart") and p_u_82.autoUpdate then
                    local v_u_106 = os.clock()
                    if p_u_82.respectUpdateQueue then
                        v_u_85 = v_u_85 + 1
                        v_u_106 = v_u_106 + 0.1
                    end
                    local v_u_107 = nil
                    v_u_107 = RunService.Heartbeat:Connect(function()
                        -- upvalues: (ref) v_u_106, (ref) v_u_107, (ref) p_u_82, (ref) v_u_85
                        if v_u_106 <= os.clock() then
                            v_u_107:Disconnect()
                            if p_u_82.respectUpdateQueue then
                                v_u_85 = v_u_85 - 1
                            end
                            if v_u_85 == 0 and p_u_82.zoneId then
                                p_u_82:_update()
                            end
                        end
                    end)
                end
            end), "Disconnect")
        end
    end
    local v108, v109, v110 = p_u_82:_calculateRegion(v84)
    local v111, _, _ = p_u_82:_calculateRegion(v84, true)
    p_u_82.region = v108
    p_u_82.exactRegion = v111
    p_u_82.boundMin = v109
    p_u_82.boundMax = v110
    local Size = v108.Size
    p_u_82.volume = Size.X * Size.Y * Size.Z
    p_u_82:_updateTouchedConnections()
    p_u_82.updated:Fire()
end
function v_u_17._updateOccupants(p113, p114, p115) -- name: _updateOccupants
    local v116 = p113.occupants[p114]
    if not v116 then
        v116 = {}
        p113.occupants[p114] = v116
    end
    local v117 = {}
    for v118, v119 in pairs(v116) do
        local v120 = p115[v118]
        if v120 == nil or v120 ~= v119 then
            v116[v118] = nil
            if not v117.exited then
                v117.exited = {}
            end
            local exited = v117.exited
            table.insert(exited, v118)
        end
    end
    for v122, _ in pairs(p115) do
        if v116[v122] == nil then
            v116[v122] = v122:IsA("Player") and (v122.Character or true) or true
            if not v117.entered then
                v117.entered = {}
            end
            local entered = v117.entered
            table.insert(entered, v122)
        end
    end
    return v117
end
function v_u_17._formTouchedConnection(p124, p125) -- name: _formTouchedConnection
    -- upvalues: (copy) m_Janitor
    local v126 = "_touchedJanitor" .. p125
    local v127 = p124[v126]
    if v127 then
        v127:clean()
    else
        p124[v126] = p124.janitor:add(m_Janitor.new(), "destroy")
    end
    p124:_updateTouchedConnection(p125)
end
function v_u_17._updateTouchedConnection(p128, p129) -- name: _updateTouchedConnection
    local v130 = p128["_touchedJanitor" .. p129]
    if v130 then
        for _, v131 in pairs(p128.zoneParts) do
            v130:add(v131.Touched:Connect(p128.touchedConnectionActions[p129], p128), "Disconnect")
        end
    end
end
function v_u_17._updateTouchedConnections(p132) -- name: _updateTouchedConnections
    for v133, _ in pairs(p132.touchedConnectionActions) do
        local v134 = p132["_touchedJanitor" .. v133]
        if v134 then
            v134:cleanup()
            p132:_updateTouchedConnection(v133)
        end
    end
end
function v_u_17._disconnectTouchedConnection(p135, p136) -- name: _disconnectTouchedConnection
    local v137 = "_touchedJanitor" .. p136
    local v138 = p135[v137]
    if v138 then
        v138:cleanup()
        p135[v137] = nil
    end
end
function v_u_17._partTouchedZone(p_u_139, p_u_140) -- name: _partTouchedZone
    -- upvalues: (copy) m_Janitor, (copy) Heartbeat, (copy) v_u_6
    local part = p_u_139.trackingTouchedTriggers.part
    if not part[p_u_140] then
        local v_u_142 = 0
        local v_u_143 = false
        local Position = p_u_140.Position
        local v_u_145 = os.clock()
        local v_u_146 = p_u_139.janitor:add(m_Janitor.new(), "destroy")
        part[p_u_140] = v_u_146
        if not ({
            ["Seat"] = true,
            ["VehicleSeat"] = true
        })[p_u_140.ClassName] and ({
            ["HumanoidRootPart"] = true
        })[p_u_140.Name] then
            p_u_140.CanTouch = false
        end
        local v147 = p_u_140.Size.X * p_u_140.Size.Y * p_u_140.Size.Z * 100000
        local v_u_148 = math.round(v147) * 0.00001
        p_u_139.totalPartVolume = p_u_139.totalPartVolume + v_u_148
        v_u_146:add(Heartbeat:Connect(function()
            -- upvalues: (ref) v_u_142, (ref) v_u_6, (copy) p_u_139, (copy) p_u_140, (ref) v_u_143, (ref) Position, (ref) v_u_145, (copy) v_u_146
            local v149 = os.clock()
            if v_u_142 <= v149 then
                local v150 = v_u_6.Accuracy.getProperty(p_u_139.accuracy)
                v_u_142 = v149 + v150
                local v151 = p_u_139:findPoint(p_u_140.CFrame) or p_u_139:findPart(p_u_140)
                if v_u_143 then
                    if not v151 then
                        v_u_143 = false
                        Position = p_u_140.Position
                        v_u_145 = os.clock()
                        p_u_139.partExited:Fire(p_u_140)
                    end
                else
                    if v151 then
                        v_u_143 = true
                        p_u_139.partEntered:Fire(p_u_140)
                        return
                    end
                    if (p_u_140.Position - Position).Magnitude > 1.5 and v150 <= v149 - v_u_145 then
                        v_u_146:cleanup()
                        return
                    end
                end
            end
        end), "Disconnect")
        v_u_146:add(function()
            -- upvalues: (copy) part, (copy) p_u_140, (copy) p_u_139, (copy) v_u_148
            part[p_u_140] = nil
            p_u_140.CanTouch = true
            local v152 = p_u_139
            local v153 = (p_u_139.totalPartVolume - v_u_148) * 100000
            v152.totalPartVolume = math.round(v153) * 0.00001
        end, true)
    end
end
local v_u_157 = {
    ["Ball"] = function(p154)
        return "GetPartBoundsInRadius", { p154.Position, p154.Size.X }
    end,
    ["Block"] = function(p155)
        return "GetPartBoundsInBox", { p155.CFrame, p155.Size }
    end,
    ["Other"] = function(p156)
        return "GetPartsInPart", { p156 }
    end
}
function v_u_17._getRegionConstructor(p158, p_u_159, p160) -- name: _getRegionConstructor
    -- upvalues: (copy) v_u_157
    local v161, v162 = pcall(function()
        -- upvalues: (copy) p_u_159
        return p_u_159.Shape.Name
    end)
    local v163 = nil
    local v164 = nil
    if v161 and p158.allZonePartsAreBlocks then
        local v165 = v_u_157[v162]
        if v165 then
            v163, v164 = v165(p_u_159)
        end
    end
    if not v163 then
        v164 = { p_u_159 }
        v163 = "GetPartsInPart"
    end
    if p160 then
        table.insert(v164, p160)
    end
    return v163, v164
end
function v_u_17.findLocalPlayer(p166) -- name: findLocalPlayer
    -- upvalues: (copy) LocalPlayer
    if not LocalPlayer then
        error("Can only call \'findLocalPlayer\' on the client!")
    end
    return p166:findPlayer(LocalPlayer)
end
function v_u_17._find(p167, p168, p169) -- name: _find
    -- upvalues: (copy) v_u_14
    v_u_14.updateDetection(p167)
    local v170 = v_u_14.trackers[p168]
    local v171 = v_u_14.getTouchingZones(p169, false, p167._currentEnterDetection, v170)
    for _, v172 in pairs(v171) do
        if v172 == p167 then
            return true
        end
    end
    return false
end
function v_u_17.findPlayer(p173, p174) -- name: findPlayer
    local v175 = p174.Character
    if v175 then
        v175 = v175:FindFirstChildOfClass("Humanoid")
    end
    if v175 then
        return p173:_find("player", p174.Character)
    else
        return false
    end
end
function v_u_17.findItem(p176, p177) -- name: findItem
    return p176:_find("item", p177)
end
function v_u_17.findPart(p178, p179) -- name: findPart
    local v180, v181 = p178:_getRegionConstructor(p179, p178.overlapParams.zonePartsWhitelist)
    local v182 = p178.worldModel[v180](p178.worldModel, unpack(v181))
    if #v182 > 0 then
        return true, v182
    else
        return false
    end
end
function v_u_17.getCheckerPart(p183) -- name: getCheckerPart
    -- upvalues: (copy) v_u_14
    local checkerPart = p183.checkerPart
    if not checkerPart then
        checkerPart = p183.janitor:add(Instance.new("Part"), "Destroy")
        checkerPart.Size = Vector3.new(0.1, 0.1, 0.1)
        checkerPart.Name = "ZonePlusCheckerPart"
        checkerPart.Anchored = true
        checkerPart.Transparency = 1
        checkerPart.CanCollide = false
        p183.checkerPart = checkerPart
    end
    local worldModel = p183.worldModel
    if worldModel == workspace then
        worldModel = v_u_14.getWorkspaceContainer()
    end
    if checkerPart.Parent ~= worldModel then
        checkerPart.Parent = worldModel
    end
    return checkerPart
end
function v_u_17.findPoint(p186, p187) -- name: findPoint
    if typeof(p187) == "Vector3" then
        p187 = CFrame.new(p187)
    end
    local v188 = p186:getCheckerPart()
    v188.CFrame = p187
    local v189, v190 = p186:_getRegionConstructor(v188, p186.overlapParams.zonePartsWhitelist)
    local v191 = p186.worldModel[v189](p186.worldModel, unpack(v190))
    if #v191 > 0 then
        return true, v191
    else
        return false
    end
end
function v_u_17._getAll(p192, p193) -- name: _getAll
    -- upvalues: (copy) v_u_14
    v_u_14.updateDetection(p192)
    local v194 = {}
    local v195 = v_u_14._getZonesAndItems(p193, {
        ["self"] = true
    }, p192.volume, false, p192._currentEnterDetection)[p192]
    if v195 then
        for v196, _ in pairs(v195) do
            table.insert(v194, v196)
        end
    end
    return v194
end
function v_u_17.getPlayers(p197) -- name: getPlayers
    return p197:_getAll("player")
end
function v_u_17.getItems(p198) -- name: getItems
    return p198:_getAll("item")
end
function v_u_17.getParts(p199) -- name: getParts
    local v200 = {}
    if p199.activeTriggers.part then
        local part_0 = p199.trackingTouchedTriggers.part
        for v202, _ in pairs(part_0) do
            table.insert(v200, v202)
        end
        return v200
    else
        local v203 = p199.worldModel:GetPartBoundsInBox(p199.region.CFrame, p199.region.Size, p199.overlapParams.zonePartsIgnorelist)
        for _, v204 in pairs(v203) do
            if p199:findPart(v204) then
                table.insert(v200, v204)
            end
        end
        return v200
    end
end
function v_u_17.getRandomPoint(p205) -- name: getRandomPoint
    local exactRegion = p205.exactRegion
    local Size_0 = exactRegion.Size
    local CFrame = exactRegion.CFrame
    local v209 = Random.new()
    local v210 = nil
    repeat
        local v211 = CFrame * CFrame.new(v209:NextNumber(-Size_0.X / 2, Size_0.X / 2), v209:NextNumber(-Size_0.Y / 2, Size_0.Y / 2), v209:NextNumber(-Size_0.Z / 2, Size_0.Z / 2))
        local v212, v213 = p205:findPoint(v211)
        v210 = v212 and true or v210
    until v210
    return v211.Position, v213
end
function v_u_17.setAccuracy(p214, p215) -- name: setAccuracy
    -- upvalues: (copy) v_u_6
    local v216 = tonumber(p215)
    if v216 then
        if not v_u_6.Accuracy.getName(v216) then
            error(("%s is an invalid enumId!"):format(v216))
        end
    else
        v216 = v_u_6.Accuracy[p215]
        if not v216 then
            error(("\'%s\' is an invalid enumName!"):format(p215))
        end
    end
    p214.accuracy = v216
end
function v_u_17.setDetection(p217, p218) -- name: setDetection
    -- upvalues: (copy) v_u_6
    local v219 = tonumber(p218)
    if v219 then
        if not v_u_6.Detection.getName(v219) then
            error(("%s is an invalid enumId!"):format(v219))
        end
    else
        v219 = v_u_6.Detection[p218]
        if not v219 then
            error(("\'%s\' is an invalid enumName!"):format(p218))
        end
    end
    p217.enterDetection = v219
    p217.exitDetection = v219
end
function v_u_17.trackItem(p_u_220, p_u_221) -- name: trackItem
    -- upvalues: (copy) m_Janitor, (copy) Tracker
    local v222 = p_u_221:IsA("BasePart")
    local v223
    if v222 then
        v223 = false
    else
        v223 = p_u_221:FindFirstChildOfClass("Humanoid")
        if v223 then
            v223 = p_u_221:FindFirstChild("HumanoidRootPart")
        end
    end
    assert(v222 or v223, "Only BaseParts or Characters/NPCs can be tracked!")
    if not p_u_220.trackedItems[p_u_221] then
        if p_u_220.itemsToUntrack[p_u_221] then
            p_u_220.itemsToUntrack[p_u_221] = nil
        end
        local v224 = p_u_220.janitor:add(m_Janitor.new(), "destroy")
        local v225 = {
            ["janitor"] = v224,
            ["item"] = p_u_221,
            ["isBasePart"] = v222,
            ["isCharacter"] = v223
        }
        p_u_220.trackedItems[p_u_221] = v225
        v224:add(p_u_221.AncestryChanged:Connect(function()
            -- upvalues: (copy) p_u_221, (copy) p_u_220
            if not p_u_221:IsDescendantOf(game) then
                p_u_220:untrackItem(p_u_221)
            end
        end), "Disconnect")
        require(Tracker).itemAdded:Fire(v225)
    end
end
function v_u_17.untrackItem(p226, p227) -- name: untrackItem
    -- upvalues: (copy) Tracker
    local v228 = p226.trackedItems[p227]
    if v228 then
        v228.janitor:destroy()
    end
    p226.trackedItems[p227] = nil
    require(Tracker).itemRemoved:Fire(v228)
end
function v_u_17.bindToGroup(p229, p230) -- name: bindToGroup
    -- upvalues: (copy) v_u_14
    p229:unbindFromGroup()
    (v_u_14.getGroup(p230) or v_u_14.setGroup(p230))._memberZones[p229.zoneId] = p229
    p229.settingsGroupName = p230
end
function v_u_17.unbindFromGroup(p231) -- name: unbindFromGroup
    -- upvalues: (copy) v_u_14
    if p231.settingsGroupName then
        local v232 = v_u_14.getGroup(p231.settingsGroupName)
        if v232 then
            v232._memberZones[p231.zoneId] = nil
        end
        p231.settingsGroupName = nil
    end
end
function v_u_17.relocate(p233) -- name: relocate
    -- upvalues: (copy) CollectiveWorldModel
    if not p233.hasRelocated then
        local v234 = require(CollectiveWorldModel).setupWorldModel(p233)
        p233.worldModel = v234
        p233.hasRelocated = true
        local container_0 = p233.container
        if typeof(container_0) == "table" then
            container_0 = Instance.new("Folder")
            for _, v236 in pairs(p233.zoneParts) do
                v236.Parent = container_0
            end
        end
        p233.relocationContainer = p233.janitor:add(container_0, "Destroy", "RelocationContainer")
        container_0.Parent = v234
    end
end
function v_u_17._onItemCallback(p_u_237, p238, p239, p_u_240, p_u_241) -- name: _onItemCallback
    local v242 = p_u_237.onItemDetails[p_u_240]
    if not v242 then
        v242 = {}
        p_u_237.onItemDetails[p_u_240] = v242
    end
    if #v242 == 0 then
        p_u_237.itemsToUntrack[p_u_240] = true
    end
    table.insert(v242, p_u_240)
    p_u_237:trackItem(p_u_240)
    if p_u_237:findItem(p_u_240) == p239 then
        p_u_241()
        if p_u_237.itemsToUntrack[p_u_240] then
            p_u_237.itemsToUntrack[p_u_240] = nil
            p_u_237:untrackItem(p_u_240)
            return
        end
    else
        local v_u_243 = nil
        v_u_243 = p_u_237[p238]:Connect(function(p244)
            -- upvalues: (ref) v_u_243, (copy) p_u_240, (copy) p_u_241, (copy) p_u_237
            if v_u_243 and p244 == p_u_240 then
                v_u_243:Disconnect()
                v_u_243 = nil
                p_u_241()
                if p_u_237.itemsToUntrack[p_u_240] then
                    p_u_237.itemsToUntrack[p_u_240] = nil
                    p_u_237:untrackItem(p_u_240)
                end
            end
        end)
    end
end
function v_u_17.onItemEnter(p245, ...) -- name: onItemEnter
    p245:_onItemCallback("itemEntered", true, ...)
end
function v_u_17.onItemExit(p246, ...) -- name: onItemExit
    p246:_onItemCallback("itemExited", false, ...)
end
function v_u_17.destroy(p247) -- name: destroy
    p247:unbindFromGroup()
    p247.janitor:destroy()
end
v_u_17.Destroy = v_u_17.destroy
return v_u_17
