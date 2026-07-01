-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Classes.Ragdoll.Types)
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_Ragdoll = require(ReplicatedStorage.Classes.Ragdoll)
local v_u_4 = m_Sound.new("Finishers")
local function v_u_7(p5, _) -- name: Activate
    -- upvalues: (copy) v_u_4
    v_u_4:play({
        ["Parent"] = nil,
        ["Name"] = "Gold",
        ["Parent"] = p5.CharacterModel
    })
    if p5.CharacterModel:FindFirstChild("CharacterArmor") then
        p5.CharacterModel.CharacterArmor:Destroy()
    end
    for _, v6 in ipairs(p5.CharacterModel:GetDescendants()) do
        if v6:IsA("Shirt") or v6:IsA("Pants") then
            v6:Destroy()
        elseif v6:IsA("BasePart") then
            v6.Color = Color3.fromRGB(255, 170, 0)
            v6.Material = Enum.Material.Metal
        end
    end
end
return {
    ["Replication"] = "All",
    ["Finisher"] = nil,
    ["Finisher"] = function(p8, p9) -- name: Finisher
        -- upvalues: (copy) m_Ragdoll, (copy) v_u_7
        local v_u_10 = m_Ragdoll.new(p8, p9)
        v_u_7(v_u_10, p9)
        return {
            ["OnDestroy"] = v_u_10.OnDestroy,
            ["Destroy"] = function() -- name: Destroy
                -- upvalues: (copy) v_u_10
                v_u_10:Destroy()
            end
        }
    end
}
