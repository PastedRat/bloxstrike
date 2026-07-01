-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function v5(p2) -- name: DecompileAnimations
    local v3 = {}
    for _, v4 in p2:GetChildren() do
        if v4:IsA("Animation") then
            v3[v4.Name] = v4
        end
    end
    return v3
end
local freeze = table.freeze
local v7 = {
    ["VIEWPORT_CHARACTER_OFFSET"] = CFrame.new(0, 0.025, 0.4)
}
local v8 = {
    ["CT"] = {
        ["CameraOffset"] = nil,
        ["IdleAnimation"] = "rbxassetid://137360078752983",
        ["CharacterOffset"] = nil,
        ["Character"] = "IDF",
        ["CameraOffset"] = CFrame.new(0, 0.2, -8) * CFrame.Angles(0, -3.141592653589793, 0),
        ["CharacterOffset"] = CFrame.new(0, 0.025, 0.4)
    },
    ["T"] = {
        ["CameraOffset"] = nil,
        ["IdleAnimation"] = "rbxassetid://99540873384647",
        ["CharacterOffset"] = nil,
        ["Character"] = "Anarchist",
        ["CameraOffset"] = CFrame.new(0, 0.2, -8) * CFrame.Angles(0, -3.141592653589793, 0),
        ["CharacterOffset"] = CFrame.new(0, 0.025, 0.4)
    }
}
v7.VIEWPORT_CHARACTER_CONFIG = v8
v7.ANIMATION_MAPPING = {
    ["Grenade"] = v5(ReplicatedStorage.Assets.UI.Loadout.Animations.Grenade),
    ["Sniper"] = v5(ReplicatedStorage.Assets.UI.Loadout.Animations.Sniper),
    ["Pistol"] = v5(ReplicatedStorage.Assets.UI.Loadout.Animations.Pistol),
    ["Heavy"] = v5(ReplicatedStorage.Assets.UI.Loadout.Animations.Heavy),
    ["Rifle"] = v5(ReplicatedStorage.Assets.UI.Loadout.Animations.Rifle),
    ["Melee"] = v5(ReplicatedStorage.Assets.UI.Loadout.Animations.Melee),
    ["LMG"] = v5(ReplicatedStorage.Assets.UI.Loadout.Animations.LMG),
    ["SMG"] = v5(ReplicatedStorage.Assets.UI.Loadout.Animations.SMG)
}
return freeze(v7)
