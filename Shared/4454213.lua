-- Decompiled with Medal

local v_u_23 = {
    ["mark"] = function(p1) -- name: mark
        debug.profilebegin(p1)
        debug.profileend()
    end,
    ["beginScope"] = function(p2) -- name: beginScope
        debug.profilebegin(p2)
    end,
    ["endScope"] = function() -- name: endScope
        debug.profileend()
    end,
    ["scope"] = function(p3, p4, ...) -- name: scope
        debug.profilebegin(p3)
        local v5 = table.pack(pcall(p4, ...))
        debug.profileend()
        if not v5[1] then
            error(v5[2], 2)
        end
        local v6 = v5.n
        return table.unpack(v5, 2, v6)
    end,
    ["getInstancePath"] = function(p7, p8) -- name: getInstancePath
        local v9 = {}
        while p7 and p7 ~= p8 do
            local Name = p7.Name
            table.insert(v9, 1, Name)
            p7 = p7.Parent
        end
        return table.concat(v9, ".")
    end,
    ["defer"] = function(p_u_11, p_u_12, ...) -- name: defer
        -- upvalues: (copy) v_u_23
        local v_u_13 = table.pack(...)
        task.defer(function()
            -- upvalues: (copy) p_u_11, (ref) v_u_23, (copy) p_u_12, (copy) v_u_13
            debug.setmemorycategory(p_u_11)
            v_u_23.mark(p_u_11)
            local v14 = p_u_12
            local v15 = v_u_13
            local v16 = v_u_13.n
            v14(table.unpack(v15, 1, v16))
        end)
    end,
    ["spawn"] = function(p_u_17, p_u_18, ...) -- name: spawn
        -- upvalues: (copy) v_u_23
        local v_u_19 = table.pack(...)
        task.spawn(function()
            -- upvalues: (copy) p_u_17, (ref) v_u_23, (copy) p_u_18, (copy) v_u_19
            debug.setmemorycategory(p_u_17)
            v_u_23.mark(p_u_17)
            local v20 = p_u_18
            local v21 = v_u_19
            local v22 = v_u_19.n
            v20(table.unpack(v21, 1, v22))
        end)
    end
}
return v_u_23
