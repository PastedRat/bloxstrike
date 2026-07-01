-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local m_Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
local m_GetWeaponProperties = require(script.Parent.GetWeaponProperties)
local function v_u_7(p4) -- name: CreateFallbackStockInformation
    -- upvalues: (copy) m_GetWeaponProperties
    local v5, v6 = pcall(m_GetWeaponProperties, p4)
    if v5 then
        return v6 and {
            ["paintId"] = "stock",
            ["type"] = nil,
            ["name"] = nil,
            ["skin"] = "Stock",
            ["rarity"] = "Stock",
            ["floatRange"] = nil,
            ["floatChances"] = nil,
            ["charmImages"] = nil,
            ["wearImages"] = nil,
            ["supportsStatTrak"] = false,
            ["statTrakChance"] = 0,
            ["isEnabled"] = true,
            ["isMarketplaceVisible"] = false,
            ["collection"] = nil,
            ["description"] = "Standard issue finish.",
            ["caseRarity"] = "Stock",
            ["imageAssetId"] = nil,
            ["type"] = v6.Class,
            ["name"] = p4,
            ["floatRange"] = {
                ["min"] = 0,
                ["max"] = 0.07
            },
            ["floatChances"] = {
                {
                    ["wear"] = "Factory New",
                    ["chance"] = 100
                }
            },
            ["charmImages"] = {},
            ["wearImages"] = {},
            ["imageAssetId"] = v6.Icon or v6.ReverseIcon
        } or nil
    else
        return nil
    end
end
return function(p8, p9)
    -- upvalues: (copy) m_Skins, (copy) v_u_7
    local v10 = m_Skins.GetSkinInformation(p8, p9)
    if v10 or p9 ~= "Stock" then
        return v10
    else
        return v_u_7(p8)
    end
end
