-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
require(ReplicatedStorage.Database.Custom.Types)
local SprayPatterns = ReplicatedStorage.Database.Custom.Weapons.SprayPatterns
local function v_u_20(p4, p5) -- name: CreatePattern
    -- upvalues: (copy) SprayPatterns
    local FireRate = p5.FireRate
    local Rounds = p5.Rounds
    local v8 = {}
    local v9 = SprayPatterns:FindFirstChild(p4)
    if not v9 then
        warn(string.format("%s has no spray pattern part", p4))
        return nil
    end
    if #v9:GetChildren() ~= Rounds then
        warn(string.format("%s spray pattern points not equal to magazine size", p4), Rounds, #v9:GetChildren())
    end
    local v10 = v9[tostring(1)]
    for v11 = 1, Rounds do
        local v12 = v9[tostring(v11)]
        local zero = Vector2.zero
        local zero_0 = Vector2.zero
        if v11 > 1 then
            local v15 = v10.WorldCFrame:Inverse()
            local v16 = v11 - 1
            local Position = (v15 * v9[tostring(v16)].WorldCFrame).Position
            zero = Vector2.new(Position.X, Position.Y)
            local Position_0 = (v10.WorldCFrame:Inverse() * v12.WorldCFrame).Position
            zero_0 = Vector2.new(Position_0.X, Position_0.Y)
        end
        local v19 = {
            ["Duration"] = 1 * FireRate,
            ["EasingStyle"] = Enum.EasingStyle.Linear,
            ["EasingDirection"] = Enum.EasingDirection.In,
            ["Path"] = { zero * 0.5, zero_0 * 0.5 }
        }
        table.insert(v8, v19)
    end
    return v8
end
local function v_u_28(p21, p22) -- name: getKeyframeAtTime
    local v23 = 0
    for _, v24 in ipairs(p21) do
        local Duration_0 = v24.Duration
        local v26 = v23 + Duration_0
        if p22 <= v26 then
            local v27 = (p22 - v23) / Duration_0
            return v24, math.clamp(v27, 0, 1)
        end
        v23 = v26
    end
    return nil, nil
end
local function v_u_44(p29, p30) -- name: getPositionOnPath
    if #p29 == 2 then
        return p29[1]:Lerp(p29[2], p30)
    end
    if #p29 == 3 then
        local v31 = p29[1]
        local v32 = p29[2]
        local v33 = p29[3]
        local v34 = 1 - p30
        return v34 * v34 * v31 + v34 * 2 * p30 * v32 + p30 * p30 * v33
    end
    if #p29 ~= 4 then
        return Vector2.zero
    end
    local v35 = p29[1]
    local v36 = p29[2]
    local v37 = p29[3]
    local v38 = p29[4]
    local v39 = 1 - p30
    local v40 = p30 * p30
    local v41 = v39 * v39
    local v42 = v41 * v39
    local v43 = v40 * p30
    return v42 * v35 + v41 * 3 * p30 * v36 + v39 * 3 * v40 * v37 + v43 * v38
end
local v45 = {}
for _, v46 in ipairs(SprayPatterns:GetChildren()) do
    local Name = v46.Name
    v45[Name] = function(p48)
        -- upvalues: (copy) v_u_20, (copy) Name, (copy) v_u_28, (copy) TweenService, (copy) v_u_44
        local _ = p48.FireRate * p48.Rounds
        local v_u_49 = v_u_20(Name, p48)
        local Duration = 0
        for _, v51 in ipairs(v_u_49) do
            Duration = Duration + v51.Duration
        end
        return function(p52)
            -- upvalues: (copy) Duration, (ref) v_u_28, (copy) v_u_49, (ref) TweenService, (ref) v_u_44
            local v53 = Duration
            local v54, v55 = v_u_28(v_u_49, (math.clamp(p52, 0, v53)))
            local v56 = TweenService:GetValue(v55, v54.EasingStyle, v54.EasingDirection)
            return v_u_44(v54.Path, v56)
        end
    end
end
return v45
