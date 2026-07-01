-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties)
local m_Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local m_Cases = require(ReplicatedStorage.Database.Components.Libraries.Cases)
local m_Buttons = require(ReplicatedStorage.Database.Custom.GameStats.UI.Inventory.Buttons)
local v_u_7 = {
    ["Forbidden"] = 7,
    ["Special"] = 6,
    ["Red"] = 5,
    ["Pink"] = 4,
    ["Purple"] = 3,
    ["Blue"] = 2,
    ["Stock"] = 1
}
local v_u_8 = {
    ["Sticker Capsule"] = 14,
    ["Charm Capsule"] = 13,
    ["Music Kit"] = 8,
    ["Graffiti"] = 11,
    ["Grenade"] = 16,
    ["Sticker"] = 10,
    ["Zeus x27"] = 3,
    ["Charm"] = 9,
    ["Melee"] = 1,
    ["Glove"] = 2,
    ["Badge"] = 7,
    ["Case"] = 12,
    ["C4"] = 15
}
local v_u_9 = {
    ["Melee"] = 1,
    ["Glove"] = 2,
    ["Case"] = 3,
    ["Charm Capsule"] = 4,
    ["Sticker Capsule"] = 4
}
local v_u_10 = {
    ["Miscellaneous"] = 18,
    ["Equipment"] = 17,
    ["Pistol"] = 3,
    ["Rifle"] = 6,
    ["Heavy"] = 5,
    ["SMG"] = 4
}
local v_u_11 = {
    ["Pistols"] = 1,
    ["Mid Tier"] = 2,
    ["Rifles"] = 3
}
local v_u_12 = {
    ["Equipped Melee"] = 1,
    ["Equipped Gloves"] = 2,
    ["Equipped Badge"] = 3,
    ["Equipped Music Kit"] = 4,
    ["Equipped Graffiti"] = 5,
    ["Equipped Zeus x27"] = 6
}
local function v_u_19(p13, p14) -- name: GetCollectionNameForItem
    -- upvalues: (copy) m_Buttons, (copy) m_Cases, (copy) m_Skins
    if m_Buttons.IsCapsule(p13) then
        return "Capsules"
    end
    if p13.Type ~= "Case" then
        if not (p13.Name and p13.Skin) then
            return nil
        end
        local v15 = m_Skins.GetSkinInformation(p13.Name, p13.Skin)
        return v15 and v15.collection or nil
    end
    if not p13.Skin then
        return nil
    end
    local v16 = m_Cases.GetCaseByName(p13.Skin)
    if not v16 then
        return nil
    end
    if p14 then
        p14 = p14()
    end
    if not p14 then
        return nil
    end
    for _, v17 in ipairs(p14) do
        if v17.cases then
            for _, v18 in ipairs(v17.cases) do
                if v18 == v16.name then
                    return v17.name
                end
            end
        end
    end
    return nil
end
local function v_u_34(p20, p21) -- name: GetEquippedItemPriority
    -- upvalues: (copy) m_DataController, (copy) v_u_11, (copy) v_u_12
    local v22 = nil
    local v23 = m_DataController.Get(p21, "Loadout")
    if not v23 then
        return nil
    end
    for _, v24 in ipairs({ "Counter-Terrorists", "Terrorists" }) do
        local v25 = v23[v24]
        if v25 and v25.Loadout then
            for v26, v27 in pairs(v_u_11) do
                if v27 and (v25.Loadout[v26] and v25.Loadout[v26].Options) then
                    for v28, v29 in ipairs(v25.Loadout[v26].Options) do
                        if v29 == p20 then
                            local v30 = v27 * 1000 + v28
                            if not v22 or v30 < v22 then
                                v22 = v30
                            end
                        end
                    end
                end
            end
            if v25.Equipped then
                for v31, v32 in pairs(v25.Equipped) do
                    if v32 == p20 then
                        local v33 = v_u_12[v31] or 99
                        if not v22 or v33 < v22 then
                            v22 = v33
                        end
                    end
                end
            end
        end
    end
    return v22
end
return {
    ["GetSortComparisonFunction"] = function(p35, p_u_36, p_u_37) -- name: GetSortComparisonFunction
        -- upvalues: (copy) v_u_19, (copy) m_Buttons, (copy) v_u_9, (copy) m_Skins, (copy) v_u_7, (copy) v_u_34, (copy) v_u_8, (copy) m_GetWeaponProperties, (copy) v_u_10
        return p35 == "Alphabetical" and function(p38, p39)
            local v40 = (p38.Skin == "Stock" or p38.MetaData and p38.MetaData.Origin == "Stock") and true or false
            local v41 = (p39.Skin == "Stock" or p39.MetaData and p39.MetaData.Origin == "Stock") and true or false
            if v40 == v41 then
                local v42
                if p38.Type == "Case" then
                    v42 = p38.Skin or ""
                else
                    v42 = (p38.Name or "") .. "|" .. (p38.Skin or "")
                end
                local v43
                if p39.Type == "Case" then
                    v43 = p39.Skin or ""
                else
                    v43 = (p39.Name or "") .. "|" .. (p39.Skin or "")
                end
                if v42 == v43 then
                    local v44 = p38.MetaData and (p38.MetaData.CreatedAt or 0) or 0
                    local v45 = p39.MetaData and (p39.MetaData.CreatedAt or 0) or 0
                    if v44 == v45 then
                        return (p38._id or "") < (p39._id or "")
                    else
                        return v45 < v44
                    end
                else
                    return v42 < v43
                end
            else
                return v41, true
            end
        end or (p35 == "Collection" and function(p46, p47)
            -- upvalues: (ref) v_u_19, (copy) p_u_37, (ref) m_Buttons, (ref) v_u_9, (ref) m_Skins, (ref) v_u_7
            local v48 = (p46.Skin == "Stock" or p46.MetaData and p46.MetaData.Origin == "Stock") and true or false
            local v49 = (p47.Skin == "Stock" or p47.MetaData and p47.MetaData.Origin == "Stock") and true or false
            if v48 == v49 then
                local v50 = v_u_19(p46, p_u_37) or ""
                local v51 = v_u_19(p47, p_u_37) or ""
                if v50 == v51 then
                    local v52 = m_Buttons.GetEffectiveItemType(p46)
                    local v53 = m_Buttons.GetEffectiveItemType(p47)
                    local v54 = v_u_9[v52] or 4
                    local v55 = v_u_9[v53] or 4
                    if v54 == v55 then
                        local v56
                        if p46.Name and p46.Skin then
                            v56 = m_Skins.GetSkinInformation(p46.Name, p46.Skin) or nil
                        else
                            v56 = nil
                        end
                        local v57
                        if p47.Name and p47.Skin then
                            v57 = m_Skins.GetSkinInformation(p47.Name, p47.Skin) or nil
                        else
                            v57 = nil
                        end
                        local v58 = v56 and v_u_7[v56.rarity] or 0
                        local v59 = v57 and v_u_7[v57.rarity] or 0
                        if v58 == v59 then
                            local v60
                            if p46.Type == "Case" then
                                v60 = p46.Skin or ""
                            else
                                v60 = (p46.Name or "") .. "|" .. (p46.Skin or "")
                            end
                            local v61
                            if p47.Type == "Case" then
                                v61 = p47.Skin or ""
                            else
                                v61 = (p47.Name or "") .. "|" .. (p47.Skin or "")
                            end
                            if v60 == v61 then
                                return (p46.MetaData and p46.MetaData.CreatedAt or 0) > (p47.MetaData and p47.MetaData.CreatedAt or 0)
                            else
                                return v60 < v61
                            end
                        else
                            return v59 < v58
                        end
                    else
                        return v54 < v55
                    end
                else
                    return v50 < v51
                end
            else
                return v49, true
            end
        end or (p35 == "Equipped" and function(p62, p63)
            -- upvalues: (ref) v_u_34, (copy) p_u_36
            local v64 = (p62.Skin == "Stock" or p62.MetaData and p62.MetaData.Origin == "Stock") and true or false
            local v65 = (p63.Skin == "Stock" or p63.MetaData and p63.MetaData.Origin == "Stock") and true or false
            if v64 == v65 then
                local v66
                if p62._id then
                    v66 = v_u_34(p62._id, p_u_36) or nil
                else
                    v66 = nil
                end
                local v67
                if p63._id then
                    v67 = v_u_34(p63._id, p_u_36) or nil
                else
                    v67 = nil
                end
                if v66 ~= nil == (v67 ~= nil) then
                    if v66 and v67 then
                        if v66 == v67 then
                            local v68
                            if p62.Type == "Case" then
                                v68 = p62.Skin or ""
                            else
                                v68 = (p62.Name or "") .. "|" .. (p62.Skin or "")
                            end
                            local v69
                            if p63.Type == "Case" then
                                v69 = p63.Skin or ""
                            else
                                v69 = (p63.Name or "") .. "|" .. (p63.Skin or "")
                            end
                            if v68 == v69 then
                                return (p62.MetaData and p62.MetaData.CreatedAt or 0) > (p63.MetaData and p63.MetaData.CreatedAt or 0)
                            else
                                return v68 < v69
                            end
                        else
                            return v66 < v67
                        end
                    else
                        local v70
                        if p62.Type == "Case" then
                            v70 = p62.Skin or ""
                        else
                            v70 = (p62.Name or "") .. "|" .. (p62.Skin or "")
                        end
                        local v71
                        if p63.Type == "Case" then
                            v71 = p63.Skin or ""
                        else
                            v71 = (p63.Name or "") .. "|" .. (p63.Skin or "")
                        end
                        if v70 == v71 then
                            return (p62.MetaData and p62.MetaData.CreatedAt or 0) > (p63.MetaData and p63.MetaData.CreatedAt or 0)
                        else
                            return v70 < v71
                        end
                    end
                else
                    return v66 ~= nil
                end
            else
                return v65, true
            end
        end or (p35 == "Newest" and function(p72, p73)
            -- upvalues: (copy) p_u_36
            local v74 = (p72.Skin == "Stock" or p72.MetaData and p72.MetaData.Origin == "Stock") and true or false
            local v75 = (p73.Skin == "Stock" or p73.MetaData and p73.MetaData.Origin == "Stock") and true or false
            if v74 == v75 then
                local LastTradeAt = p72.MetaData.LastTradeAt
                local v77 = tonumber(LastTradeAt)
                local CreatedAt = p72.MetaData.CreatedAt
                local v79 = tonumber(CreatedAt)
                if v77 > 0 then
                    v79 = v77 or v79
                end
                local LastTradeAt_0 = p73.MetaData.LastTradeAt
                local v81 = tonumber(LastTradeAt_0)
                local CreatedAt_0 = p73.MetaData.CreatedAt
                local v83 = tonumber(CreatedAt_0)
                if v81 > 0 then
                    v83 = v81 or v83
                end
                if v79 == v83 then
                    local v84
                    if p72.Type == "Case" then
                        v84 = p72.Skin or ""
                    else
                        v84 = (p72.Name or "") .. "|" .. (p72.Skin or "")
                    end
                    local v85
                    if p73.Type == "Case" then
                        v85 = p73.Skin or ""
                    else
                        v85 = (p73.Name or "") .. "|" .. (p73.Skin or "")
                    end
                    if v84 == v85 then
                        return (p72._id or "") < (p73._id or "")
                    else
                        return v84 < v85
                    end
                else
                    return v83 < v79
                end
            else
                return v75, true
            end
        end or (p35 == "Quality" and function(p86, p87)
            -- upvalues: (ref) m_Skins, (ref) v_u_7
            local v88 = (p86.Skin == "Stock" or p86.MetaData and p86.MetaData.Origin == "Stock") and true or false
            local v89 = (p87.Skin == "Stock" or p87.MetaData and p87.MetaData.Origin == "Stock") and true or false
            if v88 == v89 then
                local v90
                if p86.Name and p86.Skin then
                    v90 = m_Skins.GetSkinInformation(p86.Name, p86.Skin) or nil
                else
                    v90 = nil
                end
                local v91
                if p87.Name and p87.Skin then
                    v91 = m_Skins.GetSkinInformation(p87.Name, p87.Skin) or nil
                else
                    v91 = nil
                end
                local v92 = v90 and v_u_7[v90.rarity] or 0
                local v93 = v91 and v_u_7[v91.rarity] or 0
                if v92 == v93 then
                    local v94
                    if p86.Type == "Case" then
                        v94 = p86.Skin or ""
                    else
                        v94 = (p86.Name or "") .. "|" .. (p86.Skin or "")
                    end
                    local v95
                    if p87.Type == "Case" then
                        v95 = p87.Skin or ""
                    else
                        v95 = (p87.Name or "") .. "|" .. (p87.Skin or "")
                    end
                    if v94 == v95 then
                        return (p86.MetaData and p86.MetaData.CreatedAt or 0) > (p87.MetaData and p87.MetaData.CreatedAt or 0)
                    else
                        return v94 < v95
                    end
                else
                    return v93 < v92
                end
            else
                return v89, true
            end
        end or (p35 == "Type" and function(p96, p97)
            -- upvalues: (ref) m_Buttons, (ref) v_u_8, (ref) m_GetWeaponProperties, (ref) v_u_10
            local v98 = (p96.Skin == "Stock" or p96.MetaData and p96.MetaData.Origin == "Stock") and true or false
            local v99 = (p97.Skin == "Stock" or p97.MetaData and p97.MetaData.Origin == "Stock") and true or false
            if v98 == v99 then
                local v100 = m_Buttons.GetEffectiveItemType(p96)
                local v101 = m_Buttons.GetEffectiveItemType(p97)
                local v102 = v_u_8[v100]
                local v103
                if v102 or v100 ~= "Weapon" then
                    v103 = v102 or 99
                elseif p96.Name then
                    local v104, v105 = pcall(m_GetWeaponProperties, p96.Name)
                    v103 = v104 and (v105 and v105.Type) and (v_u_10[v105.Type] or 99) or 99
                else
                    v103 = 99
                end
                local v106 = v_u_8[v101]
                local v107
                if v106 or v101 ~= "Weapon" then
                    v107 = v106 or 99
                elseif p97.Name then
                    local v108, v109 = pcall(m_GetWeaponProperties, p97.Name)
                    v107 = v108 and (v109 and v109.Type) and (v_u_10[v109.Type] or 99) or 99
                else
                    v107 = 99
                end
                if v103 == v107 then
                    local v110
                    if p96.Type == "Case" then
                        v110 = p96.Skin or ""
                    else
                        v110 = (p96.Name or "") .. "|" .. (p96.Skin or "")
                    end
                    local v111
                    if p97.Type == "Case" then
                        v111 = p97.Skin or ""
                    else
                        v111 = (p97.Name or "") .. "|" .. (p97.Skin or "")
                    end
                    if v110 == v111 then
                        return (p96.MetaData and p96.MetaData.CreatedAt or 0) > (p97.MetaData and p97.MetaData.CreatedAt or 0)
                    else
                        return v110 < v111
                    end
                else
                    return v103 < v107
                end
            else
                return v99, true
            end
        end or (p35 == "Float" and function(p112, p113)
            local v114 = (p112.Skin == "Stock" or p112.MetaData and p112.MetaData.Origin == "Stock") and true or false
            local v115 = (p113.Skin == "Stock" or p113.MetaData and p113.MetaData.Origin == "Stock") and true or false
            if v114 == v115 then
                local v116 = p112.Name == "Badge"
                local v117 = p113.Name == "Badge"
                if v116 == v117 then
                    local v118 = p112.Name == "Charm"
                    local v119 = p113.Name == "Charm"
                    if v118 == v119 then
                        local Float = p112.Float
                        local Float_0 = p113.Float
                        if Float == nil or Float_0 == nil then
                            if Float == nil then
                                if Float_0 == nil then
                                    local v122
                                    if p112.Type == "Case" then
                                        v122 = p112.Skin or ""
                                    else
                                        v122 = (p112.Name or "") .. "|" .. (p112.Skin or "")
                                    end
                                    local v123
                                    if p113.Type == "Case" then
                                        v123 = p113.Skin or ""
                                    else
                                        v123 = (p113.Name or "") .. "|" .. (p113.Skin or "")
                                    end
                                    if v122 == v123 then
                                        return (p112.MetaData and p112.MetaData.CreatedAt or 0) > (p113.MetaData and p113.MetaData.CreatedAt or 0)
                                    else
                                        return v122 < v123
                                    end
                                else
                                    return false
                                end
                            else
                                return true
                            end
                        elseif Float == Float_0 then
                            local v124
                            if p112.Type == "Case" then
                                v124 = p112.Skin or ""
                            else
                                v124 = (p112.Name or "") .. "|" .. (p112.Skin or "")
                            end
                            local v125
                            if p113.Type == "Case" then
                                v125 = p113.Skin or ""
                            else
                                v125 = (p113.Name or "") .. "|" .. (p113.Skin or "")
                            end
                            if v124 == v125 then
                                return (p112.MetaData and p112.MetaData.CreatedAt or 0) > (p113.MetaData and p113.MetaData.CreatedAt or 0)
                            else
                                return v124 < v125
                            end
                        else
                            return Float < Float_0
                        end
                    else
                        return v119, true
                    end
                else
                    return v117, true
                end
            else
                return v115, true
            end
        end or nil))))))
    end
}
