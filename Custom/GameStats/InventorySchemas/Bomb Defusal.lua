-- Decompiled with Medal

local v1 = {
    ["MaxInventorySpace"] = 5,
    ["InventorySlots"] = nil,
    ["InventorySlots"] = {
        {
            ["MaxSlotSpace"] = 1,
            ["Type"] = "Primary"
        },
        {
            ["MaxSlotSpace"] = 1,
            ["Type"] = "Secondary"
        },
        {
            ["MaxSlotSpace"] = 2,
            ["Type"] = "Melee"
        },
        {
            ["MaxSlotSpace"] = 4,
            ["Type"] = "Grenade"
        },
        {
            ["MaxSlotSpace"] = 1,
            ["Type"] = "C4"
        }
    }
}
return table.freeze(v1)
