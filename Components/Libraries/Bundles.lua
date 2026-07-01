-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
require(script:WaitForChild("Types"))
local v_u_4 = require(ReplicatedStorage.Packages.Signal).new()
v1.OnActiveBundleUpdated = v_u_4
local v_u_5 = nil
function v1.GetActiveBundle() -- name: GetActiveBundle
    -- upvalues: (ref) v_u_5
    return v_u_5
end
function v1.ObserveActiveBundle(p6) -- name: ObserveActiveBundle
    -- upvalues: (copy) v_u_4, (ref) v_u_5
    local v_u_7 = v_u_4:Connect(p6)
    if v_u_5 then
        p6(v_u_5)
    end
    return function()
        -- upvalues: (copy) v_u_7
        v_u_7:Disconnect()
    end
end
if ReplicatedStorage:GetAttribute("ActiveBundle") then
    v_u_5 = HttpService:JSONDecode((ReplicatedStorage:GetAttribute("ActiveBundle")))
    if #v_u_4:GetConnections() > 0 then
        v_u_4:Fire(v_u_5)
    end
end
ReplicatedStorage:GetAttributeChangedSignal("ActiveBundle"):Connect(function()
    -- upvalues: (copy) ReplicatedStorage, (ref) v_u_5, (copy) HttpService, (copy) v_u_4
    local v8 = ReplicatedStorage:GetAttribute("ActiveBundle")
    if v8 then
        v_u_5 = HttpService:JSONDecode(v8)
        if #v_u_4:GetConnections() > 0 then
            v_u_4:Fire(v_u_5)
        end
    else
        return
    end
end)
return v1
