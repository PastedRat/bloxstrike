-- Decompiled with Medal

local v_u_1 = {
    ["Shared"] = table.freeze({
        ["MissionCreditRewardMultipliers"] = table.freeze({
            ["hourly"] = "HourlyMissionCreditRewardMultiplier",
            ["daily"] = "DailyMissionCreditRewardMultiplier",
            ["weekly"] = "WeeklyMissionCreditRewardMultiplier",
            ["monthly"] = "MonthlyMissionCreditRewardMultiplier"
        })
    }),
    ["ServerOnly"] = table.freeze({
        ["GameplayCreditRewardMultiplier"] = "GameplayCreditRewardMultiplier"
    })
}
local function v_u_5(p2, p3) -- name: collectKeys
    -- upvalues: (copy) v_u_5
    if typeof(p2) == "string" then
        table.insert(p3, p2)
        return
    elseif typeof(p2) == "table" then
        for _, v4 in pairs(p2) do
            v_u_5(v4, p3)
        end
    end
end
function v_u_1.GetSharedKeys() -- name: GetSharedKeys
    -- upvalues: (copy) v_u_5, (copy) v_u_1
    local v6 = {}
    v_u_5(v_u_1.Shared, v6)
    return v6
end
return table.freeze(v_u_1)
