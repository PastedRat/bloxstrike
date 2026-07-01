-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local freeze = table.freeze
local v3 = {
    ["Droppable"] = false,
    ["Automatic"] = true,
    ["Team"] = "Both",
    ["Type"] = "Equipment",
    ["Class"] = "Melee",
    ["Slot"] = "Melee",
    ["ReverseIcon"] = "rbxassetid://139380311026447",
    ["Icon"] = "rbxassetid://103569239379116",
    ["FireRate"] = 0.36,
    ["Range"] = 3,
    ["ArmorPenetration"] = 0.9,
    ["WalkSpeed"] = 20.2,
    ["RagdollMultiplier"] = 35,
    ["DamagePerPart"] = {
        ["Torso"] = 41,
        ["Head"] = 48,
        ["Arms"] = 31,
        ["Legs"] = 28
    },
    ["CharacterAnimations"] = ReplicatedStorage.Assets.WeaponAnimations["Flip Knife"].CharacterAnimations,
    ["CameraAnimations"] = ReplicatedStorage.Assets.WeaponAnimations["Flip Knife"].CameraAnimations,
    ["ShowCrosshair"] = true
}
return freeze(v3)
