-- Decompiled with Medal

local v1 = table.freeze({
    ["UnrankedComp"] = 89844875164241,
    ["Deathmatch"] = 107028954108065,
    ["Defusal"] = 100334860793031
})
local v2 = table.freeze({
    ["UnrankedComp"] = 108194354348181,
    ["Deathmatch"] = 135434213652028,
    ["Defusal"] = 114234929420007
})
local v3 = table.freeze({
    ["UnrankedComp"] = 0,
    ["Deathmatch"] = 0,
    ["Defusal"] = 0
})
local PlaceId = game.PlaceId
for _, v5 in pairs(v1) do
    if v5 == PlaceId then
        v13 = true
        ::l4::
        local v6
        if v13 then
            v6 = "Dev"
            ::l8::
            local v7 = v6 == "Dev" and v1 and v1 or (v6 == "Prod" and v2 and v2 or v3)
            local Defusal = v7.Defusal
            local UnrankedComp = v7.UnrankedComp
            local v10 = (UnrankedComp == Defusal or not UnrankedComp) and 0 or UnrankedComp
            return table.freeze({
                ["VERSION"] = "1.0.9",
                ["MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION"] = 100000,
                ["DEFAULT_CAMERA_FOV"] = 70,
                ["ACTIVE_EVENTS"] = nil,
                ["EVENT_END_TIMES"] = nil,
                ["ADMINISTRATOR_FINISHER_WHITELIST"] = nil,
                ["VIP_MENU_PANEL_WHITELIST"] = nil,
                ["AIM_ASSIST_WHITELIST"] = nil,
                ["AIM_ASSIST_CONFIGS"] = nil,
                ["PRODUCTION_UNIVERSE_ID"] = 7633926880,
                ["ACTIVE_PLACE_ENVIRONMENT"] = nil,
                ["GAMEMODE_SUBPLACE_IDS"] = nil,
                ["ACTIVE_GAMEMODE_SUBPLACE_IDS"] = nil,
                ["GAMEMODE_PLACE_IDS"] = nil,
                ["TRADING_PLACE_ID"] = 101836176558619,
                ["ACTIVE_EVENTS"] = {
                    ["MEDAL.TV"] = false
                },
                ["EVENT_END_TIMES"] = {
                    ["MEDAL.TV"] = os.time({
                        ["year"] = 2026,
                        ["month"] = 3,
                        ["day"] = 1,
                        ["hour"] = 0,
                        ["min"] = 0,
                        ["sec"] = 0
                    })
                },
                ["ADMINISTRATOR_FINISHER_WHITELIST"] = { 3659308968, 107643044, 1243042178 },
                ["VIP_MENU_PANEL_WHITELIST"] = {
                    363101315,
                    3659308968,
                    1243042178,
                    107643044,
                    9236102964,
                    38260227,
                    40222641
                },
                ["AIM_ASSIST_WHITELIST"] = {},
                ["AIM_ASSIST_CONFIGS"] = {
                    ["DEVELOPER"] = {
                        ["TargetSelection"] = {
                            ["Enabled"] = true,
                            ["MaxDistance"] = 200,
                            ["MaxAngle"] = 0.7853981633974483
                        },
                        ["Friction"] = {
                            ["Enabled"] = true,
                            ["BubbleRadius"] = 4,
                            ["MinSensitivity"] = 0.3,
                            ["MaxSensitivity"] = 1
                        },
                        ["Magnetism"] = {
                            ["Enabled"] = true,
                            ["MaxAngleHorizontal"] = 0.3490658503988659,
                            ["MaxAngleVertical"] = 0.17453292519943295,
                            ["PullStrength"] = 0.3141592653589793,
                            ["StopThreshold"] = 0.003490658503988659,
                            ["MaxDistance"] = 200
                        },
                        ["VerticalMagnetism"] = {
                            ["Enabled"] = true,
                            ["MaxAngleHorizontal"] = 0.17453292519943295,
                            ["MaxAngleVertical"] = 0.3490658503988659,
                            ["PullStrength"] = 0.20943951023931956,
                            ["StopThreshold"] = 0.008726646259971648,
                            ["MaxDistance"] = 200
                        },
                        ["RecoilAssist"] = {
                            ["Enabled"] = true,
                            ["ReductionAmount"] = 0.75,
                            ["RequiresTarget"] = false
                        }
                    },
                    ["PLAYER"] = {
                        ["TargetSelection"] = {
                            ["Enabled"] = true,
                            ["MaxDistance"] = 125,
                            ["MaxAngle"] = 0.5235987755982988
                        },
                        ["Friction"] = {
                            ["Enabled"] = true,
                            ["BubbleRadius"] = 2.4,
                            ["MinSensitivity"] = 0.5,
                            ["MaxSensitivity"] = 1
                        },
                        ["Magnetism"] = {
                            ["Enabled"] = true,
                            ["MaxAngleHorizontal"] = 0.20943951023931956,
                            ["MaxAngleVertical"] = 0.10471975511965978,
                            ["PullStrength"] = 0.11344640137963143,
                            ["StopThreshold"] = 0.008726646259971648,
                            ["MaxDistance"] = 125
                        },
                        ["VerticalMagnetism"] = {
                            ["Enabled"] = true,
                            ["MaxAngleHorizontal"] = 0.20943951023931956,
                            ["MaxAngleVertical"] = 0.10471975511965978,
                            ["PullStrength"] = 0.11344640137963143,
                            ["StopThreshold"] = 0.008726646259971648,
                            ["MaxDistance"] = 125
                        },
                        ["RecoilAssist"] = {
                            ["Enabled"] = true,
                            ["ReductionAmount"] = 0.5,
                            ["RequiresTarget"] = false
                        }
                    }
                },
                ["ACTIVE_PLACE_ENVIRONMENT"] = v6,
                ["GAMEMODE_SUBPLACE_IDS"] = {
                    ["Prod"] = v2,
                    ["Dev"] = v1
                },
                ["ACTIVE_GAMEMODE_SUBPLACE_IDS"] = v7,
                ["GAMEMODE_PLACE_IDS"] = {
                    ["Deathmatch"] = nil,
                    ["Casual"] = nil,
                    ["Competitive"] = nil,
                    ["Trading"] = 101836176558619,
                    ["Deathmatch"] = v7.Deathmatch,
                    ["Casual"] = v7.Defusal,
                    ["Competitive"] = v10
                }
            })
        end
        for _, v11 in pairs(v2) do
            if v11 == PlaceId then
                v12 = true
                ::l12::
                if v12 then
                    v6 = "Prod"
                elseif game.GameId == 7633926880 then
                    v6 = "Prod"
                else
                    v6 = "Dev"
                end
                goto l8
            end
        end
        local v12 = false
        goto l12
    end
end
local v13 = false
goto l4
