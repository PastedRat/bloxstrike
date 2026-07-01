-- Decompiled with Medal

local v_u_1 = table.freeze({
    ["Lebron James"] = "LeGoat",
    ["Medal.tv"] = "Medal"
})
return function(p2, p3)
    -- upvalues: (copy) v_u_1
    if not p2:find("PATTERN") then
        return v_u_1[p2] or p2
    end
    local v4, v5 = table.unpack(p2:split("_PATTERN_"))
    if p3 then
        v4 = ("%* \226\128\162 Pattern %*"):format(v4, v5) or v4
    end
    return v4
end
