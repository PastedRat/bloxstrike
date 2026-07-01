-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local m_InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
return function()
    -- upvalues: (copy) m_InventoryController
    local v3 = m_InventoryController.getCurrentEquipped()
    if v3 then
        local v4 = v3.Slot or 1
        local _items = m_InventoryController.getInventorySlot(v4)._items
        local Identifier = v3.Identifier
        for v9, v8 in ipairs(_items) do
            if v8.Identifier == Identifier then
                goto l6
            end
        end
        local v9 = 0
        ::l6::
        if v9 <= 1 then
            local v10 = m_InventoryController.getCurrentInventory()
            local v11 = v4
            for v12 = #v10, 1, -1 do
                if #v10[v12]._items > 0 and v12 < v4 then
                    v4 = v12
                    break
                end
            end
            if v4 == v11 then
                for v13 = #v10, 1, -1 do
                    if #v10[v13]._items > 0 and v4 < v13 then
                        v4 = v13
                    end
                end
            end
            local v14 = m_InventoryController.getInventorySlot(v4)
            m_InventoryController.equip(v4, #v14._items)
            return
        end
        local v15 = v9 - 1
        m_InventoryController.equip(v4, v15)
    end
end
