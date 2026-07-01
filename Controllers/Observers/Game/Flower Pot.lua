-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
require(script:WaitForChild("Types"))
local Debris_0 = workspace:WaitForChild("Debris")
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local function v_u_10(p6) -- name: createDuplicateFlowerPot
    -- upvalues: (copy) Debris_0
    local v7 = p6:GetPivot()
    p6:SetAttribute("Broken", false)
    p6:RemoveTag("Flower Pot")
    p6:RemoveTag("Interactable")
    local v8 = p6:Clone()
    v8:PivotTo(v7)
    v8.Parent = Debris_0
    for _, v9 in ipairs(v8:GetChildren()) do
        if v9:IsA("BasePart") then
            v9.CanCollide = true
            v9.Transparency = 0
            if v9.Name == "Unbroken" then
                v9.Transparency = 1
            end
        end
    end
    return v8
end
local function v_u_15(p11) -- name: createBreakPoints
    -- upvalues: (copy) Debris, (copy) m_Sound
    local v12 = p11:GetAttribute("Direction")
    for _, v13 in ipairs(p11:GetChildren()) do
        if v13:IsA("BasePart") and v13.Name ~= "Unbroken" then
            v13.CollisionGroup = "Debris"
            v13.Anchored = false
            v13.Massless = true
        end
    end
    for _, v14 in ipairs(p11:GetChildren()) do
        if v14:IsA("BasePart") then
            v14:ApplyImpulse(v12 * math.random(2, 3))
        end
    end
    Debris:AddItem(p11, 5)
    m_Sound.new("Bullet"):playOneTime({
        ["Name"] = "Break Flower Pot",
        ["Parent"] = nil,
        ["Parent"] = p11.PrimaryPart
    })
end
return m_Observers.observeTag("Flower Pot", function(p_u_16)
    -- upvalues: (copy) m_Observers, (copy) v_u_10, (copy) v_u_15
    if p_u_16:IsDescendantOf(workspace) then
        return m_Observers.observeAttribute(p_u_16, "Broken", function(p17)
            -- upvalues: (ref) v_u_10, (copy) p_u_16, (ref) v_u_15
            if p17 then
                v_u_15((v_u_10(p_u_16)))
            end
        end)
    end
end)
