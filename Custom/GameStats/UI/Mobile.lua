-- Decompiled with Medal

local v_u_1 = {
    ["REQUIRED_BUTTONS"] = table.freeze({
        "Shoot",
        "Shop",
        "Reload",
        "Jump",
        "Crouch",
        "Aim",
        "Drop",
        "Interact",
        "Inspect",
        "SwapTeam",
        "Configure",
        "Menu",
        "Ping"
    }),
    ["MIN_SIZE"] = 0.05,
    ["MAX_SIZE"] = 0.4,
    ["MIN_POSITION"] = -2,
    ["MAX_POSITION"] = 2
}
local v_u_2 = {
    ["Inspect"] = {
        ["Position"] = {
            ["X"] = 0.71,
            ["Y"] = 0.275
        },
        ["Size"] = {
            ["X"] = 0.08,
            ["Y"] = 0.125
        }
    },
    ["Aim"] = {
        ["Position"] = {
            ["X"] = 0.796,
            ["Y"] = 0.328
        },
        ["Size"] = {
            ["X"] = 0.0877,
            ["Y"] = 0.132
        }
    },
    ["Crouch"] = {
        ["Position"] = {
            ["X"] = 0.07,
            ["Y"] = 0.382
        },
        ["Size"] = {
            ["X"] = 0.0826,
            ["Y"] = 0.1529
        }
    },
    ["Drop"] = {
        ["Position"] = {
            ["X"] = 0.915,
            ["Y"] = 0.315
        },
        ["Size"] = {
            ["X"] = 0.0638,
            ["Y"] = 0.106
        }
    },
    ["Interact"] = {
        ["Position"] = {
            ["X"] = 0.7572,
            ["Y"] = 0.7332
        },
        ["Size"] = {
            ["X"] = 0.1151,
            ["Y"] = 0.1779
        }
    },
    ["Jump"] = {
        ["Position"] = {
            ["X"] = 0.919,
            ["Y"] = 0.478
        },
        ["Size"] = {
            ["X"] = 0.0823,
            ["Y"] = 0.1551
        }
    },
    ["Menu"] = {
        ["Position"] = {
            ["X"] = 0.835,
            ["Y"] = 0.0645
        },
        ["Size"] = {
            ["X"] = 0.0649,
            ["Y"] = 0.0962
        }
    },
    ["Shoot"] = {
        ["Position"] = {
            ["X"] = 0.8195,
            ["Y"] = 0.5021
        },
        ["Size"] = {
            ["X"] = 0.1151,
            ["Y"] = 0.1779
        }
    },
    ["Reload"] = {
        ["Position"] = {
            ["X"] = 0.7098,
            ["Y"] = 0.4151
        },
        ["Size"] = {
            ["X"] = 0.066,
            ["Y"] = 0.1233
        }
    },
    ["Shop"] = {
        ["Position"] = {
            ["X"] = 0.07,
            ["Y"] = 0.525
        },
        ["Size"] = {
            ["X"] = 0.075,
            ["Y"] = 0.1334
        }
    },
    ["SwapTeam"] = {
        ["Position"] = {
            ["X"] = 0.9,
            ["Y"] = 0.0645
        },
        ["Size"] = {
            ["X"] = 0.0649,
            ["Y"] = 0.0962
        }
    },
    ["Configure"] = {
        ["Position"] = {
            ["X"] = 0.9,
            ["Y"] = 0.17
        },
        ["Size"] = {
            ["X"] = 0.0649,
            ["Y"] = 0.0962
        }
    },
    ["Ping"] = {
        ["Position"] = {
            ["X"] = 0.729,
            ["Y"] = 0.561
        },
        ["Size"] = {
            ["X"] = 0.066,
            ["Y"] = 0.1233
        }
    }
}
local function v_u_5(p3) -- name: CopyButtonLayout
    local v4 = {
        ["Position"] = {
            ["X"] = p3.Position.X,
            ["Y"] = p3.Position.Y
        },
        ["Size"] = {
            ["X"] = p3.Size.X,
            ["Y"] = p3.Size.Y
        }
    }
    return v4
end
local function v_u_14(p6) -- name: HasValidButtonLayout
    if typeof(p6) ~= "table" then
        return false
    end
    local Position = p6.Position
    local Size = p6.Size
    if typeof(Position) ~= "table" or typeof(Size) ~= "table" then
        return false
    end
    local v9 = Position.X
    local v10
    if typeof(v9) == "number" and (v9 == v9 and v9 ~= (1 / 0)) then
        v10 = v9 ~= (-1 / 0)
    else
        v10 = false
    end
    if v10 then
        local v11 = Position.Y
        if typeof(v11) == "number" and (v11 == v11 and v11 ~= (1 / 0)) then
            v10 = v11 ~= (-1 / 0)
        else
            v10 = false
        end
        if v10 then
            local v12 = Size.X
            if typeof(v12) == "number" and (v12 == v12 and v12 ~= (1 / 0)) then
                v10 = v12 ~= (-1 / 0)
            else
                v10 = false
            end
            if v10 then
                local v13 = Size.Y
                if typeof(v13) == "number" and (v13 == v13 and v13 ~= (1 / 0)) then
                    v10 = v13 ~= (-1 / 0)
                else
                    v10 = false
                end
            end
        end
    end
    return v10
end
function v_u_1.GetButtonNames() -- name: GetButtonNames
    -- upvalues: (copy) v_u_1
    return table.clone(v_u_1.REQUIRED_BUTTONS)
end
function v_u_1.GetDefaultLayout() -- name: GetDefaultLayout
    -- upvalues: (copy) v_u_1, (copy) v_u_5, (copy) v_u_2
    local v15 = {}
    for _, v16 in ipairs(v_u_1.REQUIRED_BUTTONS) do
        v15[v16] = v_u_5(v_u_2[v16])
    end
    return v15
end
function v_u_1.GetDefaultButtonLayout(p17) -- name: GetDefaultButtonLayout
    -- upvalues: (copy) v_u_2, (copy) v_u_5
    local v18 = v_u_2[p17]
    return not v18 and {
        ["Position"] = {
            ["X"] = 0.5,
            ["Y"] = 0.5
        },
        ["Size"] = {
            ["X"] = 0.1,
            ["Y"] = 0.1
        }
    } or v_u_5(v18)
end
function v_u_1.ClampButtonLayout(p19) -- name: ClampButtonLayout
    -- upvalues: (copy) v_u_1
    local v20 = p19.Size.X
    local MIN_SIZE = v_u_1.MIN_SIZE
    local MAX_SIZE = v_u_1.MAX_SIZE
    local v23 = math.clamp(v20, MIN_SIZE, MAX_SIZE)
    local v24 = p19.Size.Y
    local MIN_SIZE_0 = v_u_1.MIN_SIZE
    local MAX_SIZE_0 = v_u_1.MAX_SIZE
    local v27 = math.clamp(v24, MIN_SIZE_0, MAX_SIZE_0)
    local v28 = {}
    local v29 = {}
    local v30 = p19.Position.X
    local MIN_POSITION = v_u_1.MIN_POSITION
    local MAX_POSITION = v_u_1.MAX_POSITION
    v29.X = math.clamp(v30, MIN_POSITION, MAX_POSITION)
    local v33 = p19.Position.Y
    local MIN_POSITION_0 = v_u_1.MIN_POSITION
    local MAX_POSITION_0 = v_u_1.MAX_POSITION
    v29.Y = math.clamp(v33, MIN_POSITION_0, MAX_POSITION_0)
    v28.Position = v29
    v28.Size = {
        ["X"] = v23,
        ["Y"] = v27
    }
    return v28
end
function v_u_1.HasAllRequiredButtons(p36) -- name: HasAllRequiredButtons
    -- upvalues: (copy) v_u_1, (copy) v_u_14
    if typeof(p36) ~= "table" then
        return false
    end
    for _, v37 in ipairs(v_u_1.REQUIRED_BUTTONS) do
        if not v_u_14(p36[v37]) then
            return false
        end
    end
    return true
end
function v_u_1.SanitizeLayout(p38) -- name: SanitizeLayout
    -- upvalues: (copy) v_u_1, (copy) v_u_14
    local v39 = v_u_1.GetDefaultLayout()
    if typeof(p38) ~= "table" then
        return v39
    end
    for _, v40 in ipairs(v_u_1.REQUIRED_BUTTONS) do
        local v41 = p38[v40]
        if v_u_14(v41) then
            local ClampButtonLayout = v_u_1.ClampButtonLayout
            local v43 = {
                ["Position"] = {
                    ["X"] = v41.Position.X,
                    ["Y"] = v41.Position.Y
                },
                ["Size"] = {
                    ["X"] = v41.Size.X,
                    ["Y"] = v41.Size.Y
                }
            }
            v39[v40] = ClampButtonLayout(v43)
        end
    end
    return v39
end
return v_u_1
