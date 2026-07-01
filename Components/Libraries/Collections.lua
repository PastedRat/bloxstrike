-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
require(script:WaitForChild("Types"))
local v_u_4 = require(ReplicatedStorage.Packages.Signal).new()
v1.OnAvailableCollectionsUpdated = v_u_4
local v_u_5 = nil
function v1.GetCollectionByName(p6) -- name: GetCollectionByName
    -- upvalues: (ref) v_u_5
    for _, v7 in ipairs(v_u_5) do
        if v7.name == p6 then
            return v7
        end
    end
    return nil
end
function v1.ObserveAvailableCollections(p8) -- name: ObserveAvailableCollections
    -- upvalues: (copy) v_u_4, (ref) v_u_5
    local v_u_9 = v_u_4:Connect(p8)
    if v_u_5 then
        p8(v_u_5)
    end
    return function()
        -- upvalues: (copy) v_u_9
        v_u_9:Disconnect()
    end
end
if ReplicatedStorage:GetAttribute("AvailableCollections") then
    v_u_5 = HttpService:JSONDecode((ReplicatedStorage:GetAttribute("AvailableCollections")))
    if #v_u_4:GetConnections() > 0 then
        v_u_4:Fire(v_u_5)
    end
end
ReplicatedStorage:GetAttributeChangedSignal("AvailableCollections"):Connect(function()
    -- upvalues: (copy) ReplicatedStorage, (ref) v_u_5, (copy) HttpService, (copy) v_u_4
    local v10 = ReplicatedStorage:GetAttribute("AvailableCollections")
    if v10 then
        v_u_5 = HttpService:JSONDecode(v10)
        if #v_u_4:GetConnections() > 0 then
            v_u_4:Fire(v_u_5)
        end
    else
        return
    end
end)
return v1
