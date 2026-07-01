-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Database.Custom.Types)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins)
return function(p4, p5)
    -- upvalues: (copy) m_DataController, (copy) m_Skins
    local v6, v7 = m_DataController.Get(p4, "Loadout", "Inventory")
    if not (v6 and v7) then
        return ""
    end
    local v8 = v6[p5]
    if not (v8 and v8.Equipped) then
        return ""
    end
    local v9 = v8.Equipped["Equipped Badge"]
    if not v9 or v9 == "" then
        return ""
    end
    local v10 = nil
    for _, v11 in ipairs(v7) do
        if v11._id == v9 then
            v10 = v11
            break
        end
    end
    if not v10 then
        return ""
    end
    local v12 = m_Skins.GetSkinInformation(v10.Name, v10.Skin)
    return v12 and (m_Skins.GetWearImageForFloat(v12, v10.Float or 0.9999) or v12.imageAssetId or "") or ""
end
