-- Decompiled with Medal

local HttpService = game:GetService("HttpService")
return function(p_u_2)
    -- upvalues: (copy) HttpService
    local v3, v_u_4 = pcall(function()
        -- upvalues: (ref) HttpService, (copy) p_u_2
        return HttpService:JSONEncode(p_u_2)
    end)
    if not (v3 and v_u_4) then
        return p_u_2
    end
    local v5, v6 = pcall(function()
        -- upvalues: (ref) HttpService, (copy) v_u_4
        return HttpService:JSONDecode(v_u_4)
    end)
    if not (v5 and v6) then
        return p_u_2
    end
    for _, v7 in ipairs({
        "_id",
        "Type",
        "Name",
        "Skin",
        "Rarity",
        "OriginalOwner"
    }) do
        if v6[v7] ~= nil then
            local v8 = v6[v7]
            if typeof(v8) == "number" then
                local v9 = v6[v7]
                v6[v7] = tostring(v9)
            end
        end
    end
    if v6.MetaData then
        local MetaData = v6.MetaData
        if typeof(MetaData) == "table" then
            for _, v11 in ipairs({ "LastTradeAt", "CreatedAt" }) do
                if v6.MetaData[v11] ~= nil then
                    local v12 = v6.MetaData[v11]
                    if typeof(v12) == "string" then
                        local v13 = v6.MetaData[v11]
                        local v14 = tonumber(v13)
                        if v14 == nil then
                            v6.MetaData[v11] = nil
                        else
                            v6.MetaData[v11] = v14
                        end
                    end
                end
            end
            for _, v15 in ipairs({ "GlobalMarketPlaceListingReference" }) do
                if v6.MetaData[v15] == false then
                    v6.MetaData[v15] = nil
                end
            end
            for _, v16 in ipairs({
                "OriginalOwner",
                "Owner",
                "Origin",
                "GlobalMarketPlaceListingReference"
            }) do
                if v6.MetaData[v16] ~= nil then
                    local v17 = v6.MetaData[v16]
                    if typeof(v17) == "number" then
                        local MetaData_0 = v6.MetaData
                        local v19 = v6.MetaData[v16]
                        MetaData_0[v16] = tostring(v19)
                    end
                end
            end
        end
    end
    return v6
end
