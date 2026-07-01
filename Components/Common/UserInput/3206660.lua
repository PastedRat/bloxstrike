-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local m_InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
local function v_u_12(p3, p4, p5) -- name: getPreferredSpaceOrder
    local v6 = {}
    if p3 ~= 3 then
        for v7 = 1, #p4 do
            if not p5 or p5(p4[v7]) then
                table.insert(v6, v7)
            end
        end
        return v6
    end
    for v8, v9 in ipairs(p4) do
        if v9.Name ~= "Zeus x27" then
            table.insert(v6, v8)
        end
    end
    for v10, v11 in ipairs(p4) do
        if v11.Name == "Zeus x27" then
            table.insert(v6, v10)
        end
    end
    return v6
end
local function v_u_24(p13, p14, p15, p16) -- name: getPreferredSpaceNumber
    -- upvalues: (copy) v_u_12
    local v17 = v_u_12(p13, p14, p16)
    local v18 = v17[1]
    if not v18 then
        return 0
    end
    if not p15 then
        return v18
    end
    for v23, v20 in ipairs(p14) do
        if v20.Identifier == p15 then
            ::l8::
            if v23 == 0 then
                return v18
            end
            for v21, v22 in ipairs(v17) do
                if v22 == v23 then
                    return v17[v21 + 1] or v18
                end
            end
            return v18
        end
    end
    local v23 = 0
    goto l8
end
return function(p25, p26)
    -- upvalues: (copy) m_InventoryController, (copy) v_u_24, (copy) v_u_12
    local v27 = m_InventoryController.getCurrentEquipped()
    local v28 = m_InventoryController.getInventorySlot(p25)
    if v28 then
        if v27 then
            if (v27.Slot or 1) == p25 then
                local v29 = v_u_24(p25, v28._items, v27.Identifier, p26)
                if v29 > 0 then
                    m_InventoryController.equip(p25, v29)
                    return
                end
            else
                local v30 = v_u_12(p25, v28._items, p26)[1] or 0
                if v30 > 0 then
                    m_InventoryController.equip(p25, v30)
                    return
                end
            end
        else
            local v31 = v_u_12(p25, v28._items, p26)[1] or 0
            if v31 > 0 then
                m_InventoryController.equip(p25, v31)
            end
        end
    end
end
