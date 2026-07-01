-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
require(script:WaitForChild("Types"))
local Debris_0 = workspace:WaitForChild("Debris")
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local v_u_5 = require(ReplicatedStorage.Classes.Sound).new("Bullet")
local function v_u_10(p6) -- name: createDuplicateVent
    -- upvalues: (copy) Debris_0
    local v7 = p6:GetPivot()
    p6:SetAttribute("Broken", false)
    p6:RemoveTag("Interactable")
    p6:RemoveTag("Vent")
    local v8 = p6:Clone()
    v8:PivotTo(v7)
    v8.Parent = Debris_0
    for _, v9 in ipairs(v8:GetChildren()) do
        if v9:IsA("BasePart") then
            v9.CanCollide = true
            v9.Transparency = 0
        end
    end
    return v8
end
local function v_u_17(p11) -- name: createBreakPoints
    -- upvalues: (copy) Debris, (copy) v_u_5
    local v12 = p11:GetAttribute("Direction")
    for _, v13 in ipairs(p11:GetChildren()) do
        if v13:IsA("BasePart") then
            v13.CollisionGroup = "Debris"
            v13.Anchored = false
            local v14 = v12.X * math.random(15, 20)
            local v15 = v12.Y * math.random(15, 20)
            local v16 = v12.Z * math.random(15, 20)
            v13:ApplyImpulse((Vector3.new(v14, v15, v16)))
        end
    end
    Debris:AddItem(p11, 5)
    v_u_5:play({
        ["Name"] = "Break Metal Vent",
        ["Parent"] = nil,
        ["Parent"] = p11.PrimaryPart
    })
end
return m_Observers.observeTag("Vent", function(p_u_18)
    -- upvalues: (copy) m_Observers, (copy) v_u_10, (copy) v_u_17
    if p_u_18:IsDescendantOf(workspace) then
        return m_Observers.observeAttribute(p_u_18, "Broken", function(p19)
            -- upvalues: (ref) v_u_10, (copy) p_u_18, (ref) v_u_17
            if p19 then
                v_u_17((v_u_10(p_u_18)))
            end
        end)
    end
end)
