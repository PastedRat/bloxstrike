-- Decompiled with Medal

local TweenService = game:GetService("TweenService")
local v_u_2 = {}
v_u_2.__index = v_u_2
function v_u_2.new(p3) -- name: new
    -- upvalues: (copy) v_u_2
    local v4 = v_u_2
    local v5 = setmetatable({}, v4)
    v5.value = p3
    v5.lastValue = p3
    v5.goal = p3
    v5.timestamp = 0
    v5.rate = nil
    v5.tweenInfo = nil
    return v5
end
function v_u_2.setGoal(p6, p7) -- name: setGoal
    p6.lastValue = p6.value
    p6.goal = p7
    p6.timestamp = os.clock()
end
function v_u_2.useFixedRate(p8, p9) -- name: useFixedRate
    p8.rate = p9
    p8.tweenInfo = nil
end
function v_u_2.useTween(p10, p11) -- name: useTween
    p10.rate = nil
    p10.tweenInfo = p11
end
function v_u_2.get(p12) -- name: get
    return p12.value
end
function v_u_2.update(p13, p14) -- name: update
    -- upvalues: (copy) TweenService
    if p13.value == p13.goal then
        return
    elseif p13.tweenInfo then
        local Time = (os.clock() - p13.timestamp) / p13.tweenInfo.Time
        local v16 = TweenService:GetValue(math.clamp(Time, 0, 1), p13.tweenInfo.EasingStyle, p13.tweenInfo.EasingDirection)
        local lastValue = p13.lastValue
        local goal = p13.goal
        p13.value = (1 - v16) * lastValue + goal * v16
    elseif p13.rate then
        local rate = p13.rate
        local value = p13.goal - p13.value
        local v21 = rate * math.sign(value) * p14
        local v22 = p13.value + v21
        if v21 < 0 then
            local goal_0 = p13.goal
            p13.value = math.max(v22, goal_0)
            return
        end
        local goal_1 = p13.goal
        p13.value = math.min(v22, goal_1)
    end
end
return v_u_2
