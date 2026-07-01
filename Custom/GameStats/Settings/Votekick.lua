-- Decompiled with Medal

return table.freeze({
    ["MIN_LEVEL"] = 3,
    ["GetActiveTeam"] = function(p1) -- name: GetActiveTeam
        if p1 == "Counter-Terrorists" or p1 == "Terrorists" then
            return p1
        else
            return nil
        end
    end
})
