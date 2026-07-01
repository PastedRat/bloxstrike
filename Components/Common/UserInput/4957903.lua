-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local m_InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
return function()
    -- upvalues: (copy) m_InventoryController
    local v3 = m_InventoryController.getCurrentEquipped()
    if v3 then
        local v4 = v3.Slot or 1
        local v5 = m_InventoryController.getInventorySlot(v4)
        local _items = v5._items
        local Identifier = v3.Identifier
        for v10, v9 in ipairs(_items) do
            if v9.Identifier == Identifier then
                goto l6
            end
        end
        local v10 = 0
        ::l6::
        if #v5._items <= v10 then
            local v11 = m_InventoryController.getCurrentInventory()
            local v12 = v4
            for v13 = 1, #v11 do
                if #v11[v13]._items > 0 and v4 < v13 then
                    v4 = v13
                    break
                end
            end
            if v4 == v12 then
                for v14 = 1, #v11 do
                    if #v11[v14]._items > 0 and v14 < v4 then
                        v4 = v14
                        break
                    end
                end
            end
            m_InventoryController.equip(v4, 1)
            return
        end
        local v15 = v10 + 1
        m_InventoryController.equip(v4, v15)
    end
end
