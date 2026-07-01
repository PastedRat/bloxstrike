-- Decompiled with Medal

local v_u_78 = {
    ["Constants"] = {
        ["SOURCE_TO_STUDS"] = 0.0763888888888889,
        ["SV_GRAVITY"] = 800,
        ["GRENADE_GRAVITY_SCALE"] = 0.39,
        ["GRENADE_ELASTICITY"] = 0.4,
        ["JUMP_THROW_ELASTICITY"] = 0.32,
        ["PLAYER_ELASTICITY"] = 0.3,
        ["MIN_ELASTICITY"] = 0,
        ["MAX_ELASTICITY"] = 0.9,
        ["MAX_THROW_VELOCITY_SOURCE"] = 750,
        ["PLAYER_VELOCITY_SCALE"] = 1.5,
        ["SLEEP_VELOCITY_SOURCE"] = 20,
        ["STOP_EPSILON_SOURCE"] = 0.1,
        ["FLOOR_NORMAL_THRESHOLD"] = 0.7,
        ["OVERBOUNCE"] = 2,
        ["FIXED_TIMESTEP"] = 0.0078125,
        ["MAX_BOUNCES"] = 20,
        ["THROW_POWER_SCALE"] = 0.7,
        ["THROW_POWER_BASE"] = 0.3,
        ["VELOCITY_SCALE"] = 0.58,
        ["GRAVITY"] = Vector3.new(0, -23.833334, 0),
        ["MAX_THROW_VELOCITY"] = 57.29166666666667,
        ["SLEEP_VELOCITY"] = 1.527777777777778,
        ["STOP_EPSILON"] = 0.0076388888888888895,
        ["THROW_UPWARD_BIAS_FAR"] = 0.06,
        ["THROW_UPWARD_BIAS_NEAR"] = 0.04,
        ["THROW_FORWARD_OFFSET"] = 1.35,
        ["THROW_HEIGHT_OFFSET"] = 2.4,
        ["PLAYER_VELOCITY_INHERITANCE"] = 1.5,
        ["PLAYER_VERTICAL_VELOCITY_SCALE"] = 2,
        ["GROUND_CHECK_DISTANCE"] = 0.2,
        ["MAX_SIMULATION_TIME"] = 10,
        ["JUMP_THROW_DETECTION_THRESHOLD"] = 5,
        ["JUMP_THROW_HORIZONTAL_DAMPENING"] = 1,
        ["JUMP_THROW_FIXED_VERTICAL"] = 20,
        ["JUMP_THROW_HEIGHT_BONUS"] = 0,
        ["MAX_THROW_SPEED"] = 50,
        ["MAX_JUMP_THROW_SPEED"] = 62,
        ["MAX_ACCUMULATED_TIME"] = 0.1,
        ["MAX_ITERATIONS_PER_FRAME"] = 16
    },
    ["createInitialState"] = function(p1, p2, p3, p4, p5, p6) -- name: createInitialState
        local v7 = ((p3 == "Far" and 1 or 0) * 0.7 + 0.3) * 57.29166666666667 * p5 * 0.58
        local v8 = p4.Y > 5
        local v9 = 1
        if v8 then
            p1 = p1 + Vector3.new(0, 0, 0)
        end
        local v10
        if v8 then
            v10 = Vector3.new(0, 20, 0)
        else
            local v11 = p4.Y * 2 * 0.58
            v10 = Vector3.new(0, v11, 0)
        end
        local v12
        if v8 then
            local v13 = p2.X * v9
            local v14 = p2.Y
            local v15 = p2.Z * v9
            v12 = Vector3.new(v13, v14, v15).Unit
        else
            v12 = p2
        end
        local v16 = v12 * v7 + v10
        local v17 = not v8 and 1 or v9
        local v18 = p2.X * v17
        local v19 = p2.Y
        local v20 = p2.Z * v17
        local v21 = Vector3.new(v18, v19, v20).Unit * v7 * 0.15
        local v22 = p5 * 6.5 * 0.58
        local v23 = v16 + (v21 + Vector3.new(0, v22, 0))
        local v24 = not v8 and 50 or (p2.Y - 0.4) * 20 + 62
        if v24 < v23.Magnitude then
            v23 = v23.Unit * v24
        end
        local v25 = p4.X
        local v26 = p4.Z
        local v27 = v23 + Vector3.new(v25, 0, v26) * 1.5 * v9
        local v28 = p6 * 1000
        local v29 = math.floor(v28) % 1000
        local v30 = v29 % 11 - 5
        local v31 = v29 / 11
        local v32 = math.floor(v31) % 13 - 6
        local v33 = v29 / 143
        local v34 = math.floor(v33) % 11 - 5
        return {
            ["position"] = nil,
            ["velocity"] = nil,
            ["angularVelocity"] = nil,
            ["timestamp"] = nil,
            ["simulationTime"] = 0,
            ["bounceCount"] = 0,
            ["isGrounded"] = false,
            ["isAtRest"] = false,
            ["hasTouched"] = false,
            ["accumulatedTime"] = 0,
            ["isJumpThrow"] = nil,
            ["position"] = p1,
            ["velocity"] = v27,
            ["angularVelocity"] = Vector3.new(v30, v32, v34),
            ["timestamp"] = p6,
            ["isJumpThrow"] = v8
        }
    end,
    ["createConfig"] = function(p35, p36, p37, p38, p39, p40) -- name: createConfig
        return {
            ["radius"] = nil,
            ["restitution"] = 0.4,
            ["maxBounces"] = 20,
            ["fuseTime"] = nil,
            ["minimumFuseTime"] = nil,
            ["explodeOnFloorImpact"] = nil,
            ["rangeScale"] = nil,
            ["isNearThrow"] = nil,
            ["radius"] = p35,
            ["fuseTime"] = p38,
            ["minimumFuseTime"] = p39,
            ["explodeOnFloorImpact"] = p40,
            ["rangeScale"] = p36,
            ["isNearThrow"] = p37
        }
    end,
    ["detectCollision"] = function(p41, p42, p43, p44) -- name: detectCollision
        local v45 = p42 - p41
        local Magnitude = v45.Magnitude
        if Magnitude < 0.001 then
            return nil
        end
        local v47 = p43 * 0.01
        local v48 = {}
        local v49 = Vector3.new(v47, 0, 0)
        local v50 = -v47
        local v51 = Vector3.new(v50, 0, 0)
        local v52 = Vector3.new(0, v47, 0)
        local v53 = -v47
        local v54 = Vector3.new(0, v53, 0)
        local v55 = Vector3.new(0, 0, v47)
        local v56 = -v47
        __set_list(v48, 1, {v49, v51, v52, v54, v55, (Vector3.new(0, 0, v56))})
        local Distance = (1 / 0)
        local v58 = workspace:Raycast(p41, v45, p44)
        local v59
        if v58 and v58.Distance < Distance then
            Distance = v58.Distance
            v59 = Vector3.new(0, 0, 0)
        else
            v58 = nil
            v59 = Vector3.new(0, 0, 0)
        end
        for _, v60 in v48 do
            local v61 = p41 + v60
            local v62 = workspace:Raycast(v61, v45, p44)
            if v62 and v62.Distance < Distance then
                Distance = v62.Distance
                v59 = v60
                v58 = v62
            end
        end
        if not v58 then
            return nil
        end
        local v63 = v58.Position - v59
        local Magnitude_0 = (v63 - p41).Magnitude
        if Magnitude + v47 + 0.1 < Magnitude_0 then
            return nil
        end
        local Instance = v58.Instance
        local Parent = Instance.Parent
        local v67
        if Parent then
            v67 = Parent:FindFirstChildOfClass("Humanoid") ~= nil
        else
            v67 = Parent
        end
        local v68 = Parent and Parent:HasTag("BreakableGlass") or Instance:HasTag("BreakableGlass")
        return {
            ["hit"] = true,
            ["position"] = nil,
            ["normal"] = nil,
            ["distance"] = nil,
            ["instance"] = nil,
            ["isPlayer"] = nil,
            ["isGlass"] = nil,
            ["position"] = v63,
            ["normal"] = v58.Normal,
            ["distance"] = Magnitude_0,
            ["instance"] = Instance,
            ["isPlayer"] = v67,
            ["isGlass"] = v68
        }
    end,
    ["checkGrounded"] = function(p69, p70) -- name: checkGrounded
        local v71 = workspace:Raycast(p69, Vector3.new(0, -0.2, 0), p70)
        if v71 then
            return true, v71.Normal
        else
            return false, nil
        end
    end,
    ["checkSurfaceContact"] = function(p72, p73, p74) -- name: checkSurfaceContact
        local v75 = p73 + 0.1
        for _, v76 in {
            Vector3.new(0, -1, 0),
            Vector3.new(0, 1, 0),
            Vector3.new(1, 0, 0),
            Vector3.new(-1, 0, 0),
            Vector3.new(0, 0, 1),
            Vector3.new(0, 0, -1)
        } do
            local v77 = workspace:Raycast(p72, v76 * v75, p74)
            if v77 and v77.Distance < v75 then
                return true, v77.Normal
            end
        end
        return false, nil
    end
}
local function v_u_89(p79, p80, p81) -- name: PhysicsClipVelocity
    local v82 = p79:Dot(p80) * p81
    local v83 = p79.X - p80.X * v82
    local v84 = p79.Y - p80.Y * v82
    local v85 = p79.Z - p80.Z * v82
    local v86 = math.abs(v83) < 0.0076388888888888895 and 0 or v83
    local v87 = math.abs(v84) < 0.0076388888888888895 and 0 or v84
    local v88 = math.abs(v85) < 0.0076388888888888895 and 0 or v85
    return Vector3.new(v86, v87, v88)
end
function v_u_78.integrate(p90, p91, p92, p93) -- name: integrate
    if p93 then
        return p90 + p91 * p92, p91
    end
    local v94 = p91.Y - p92 * 23.83333396911621
    local v95 = (p91.Y + v94) / 2
    local v96 = p91.X * p92
    local v97 = v95 * p92
    local v98 = p91.Z * p92
    local v99 = Vector3.new(v96, v97, v98)
    local v100 = p91.X
    local v101 = p91.Z
    local v102 = Vector3.new(v100, v94, v101)
    return p90 + v99, v102
end
function v_u_78.calculateBounce(p103, p104, p105, p106) -- name: calculateBounce
    -- upvalues: (copy) v_u_89
    local v107 = table.clone(p105)
    local v108 = (p105.isJumpThrow and 0.32 or 0.4) * (p106 and 0.3 or 1)
    local v109 = math.clamp(v108, 0, 0.9)
    local v110 = v_u_89(p103, p104, 2) * v109
    if p104.Y > 0.7 and v110:Dot(v110) < 2.3341049382716053 then
        v107.bounceCount = p105.bounceCount + 1
        v107.hasTouched = true
        return Vector3.new(0, 0, 0), v107
    else
        v107.bounceCount = p105.bounceCount + 1
        v107.hasTouched = true
        return v110, v107
    end
end
function v_u_78.shouldStop(p111, p112, p113) -- name: shouldStop
    if p112 and p113 then
        return p111:Dot(p111) < 2.3341049382716053
    else
        return false
    end
end
function v_u_78.step(p114, p115, p116, p117) -- name: step
    -- upvalues: (copy) v_u_78
    local v118 = table.clone(p114)
    v118.simulationTime = p114.simulationTime + p117
    local v119 = nil
    if v118.simulationTime >= 10 then
        v118.isAtRest = true
        return v118, {
            ["type"] = "timeout",
            ["timestamp"] = nil,
            ["position"] = nil,
            ["normal"] = Vector3.new(0, 1, 0),
            ["velocity"] = nil,
            ["bounceCount"] = nil,
            ["timestamp"] = p114.timestamp + v118.simulationTime,
            ["position"] = v118.position,
            ["velocity"] = v118.velocity,
            ["bounceCount"] = v118.bounceCount
        }
    end
    if p115.fuseTime and v118.simulationTime >= p115.fuseTime then
        v118.isAtRest = true
        return v118, {
            ["type"] = "fuse",
            ["timestamp"] = nil,
            ["position"] = nil,
            ["normal"] = Vector3.new(0, 1, 0),
            ["velocity"] = nil,
            ["bounceCount"] = nil,
            ["timestamp"] = p114.timestamp + v118.simulationTime,
            ["position"] = v118.position,
            ["velocity"] = v118.velocity,
            ["bounceCount"] = v118.bounceCount
        }
    end
    if p114.bounceCount >= p115.maxBounces then
        v118.isAtRest = true
        v118.velocity = Vector3.new(0, 0, 0)
        return v118, {
            ["type"] = "rest",
            ["timestamp"] = nil,
            ["position"] = nil,
            ["normal"] = Vector3.new(0, 1, 0),
            ["velocity"] = Vector3.new(0, 0, 0),
            ["bounceCount"] = nil,
            ["timestamp"] = p114.timestamp + v118.simulationTime,
            ["position"] = v118.position,
            ["bounceCount"] = v118.bounceCount
        }
    end
    local position = v118.position
    local v121, v122 = v_u_78.integrate(v118.position, v118.velocity, p117, v118.isGrounded)
    local v123 = v_u_78.detectCollision(position, v121, p115.radius, p116)
    if v123 then
        local v124
        v124, v118 = v_u_78.calculateBounce(v122, v123.normal, v118, v123.isPlayer)
        v118.position = v123.position + v123.normal * 0.05
        v118.velocity = v124
        local v125 = v123.normal.Y > 0.7
        if p115.explodeOnFloorImpact and v125 and (not p115.minimumFuseTime or v118.simulationTime >= p115.minimumFuseTime) then
            v118.isAtRest = true
            return v118, {
                ["type"] = "floor_impact",
                ["timestamp"] = nil,
                ["position"] = nil,
                ["normal"] = nil,
                ["velocity"] = nil,
                ["bounceCount"] = nil,
                ["timestamp"] = p114.timestamp + v118.simulationTime,
                ["position"] = v118.position,
                ["normal"] = v123.normal,
                ["velocity"] = v118.velocity,
                ["bounceCount"] = v118.bounceCount
            }
        end
        v119 = {
            ["type"] = "bounce",
            ["timestamp"] = nil,
            ["position"] = nil,
            ["normal"] = nil,
            ["velocity"] = nil,
            ["bounceCount"] = nil,
            ["timestamp"] = p114.timestamp + v118.simulationTime,
            ["position"] = v118.position,
            ["normal"] = v123.normal,
            ["velocity"] = v118.velocity,
            ["bounceCount"] = v118.bounceCount
        }
    else
        v118.position = v121
        v118.velocity = v122
    end
    local v126, v127 = v_u_78.checkGrounded(v118.position, p116)
    v118.isGrounded = v126
    if not v_u_78.shouldStop(v118.velocity, v126, v118.hasTouched) or (p115.minimumFuseTime and v118.simulationTime < p115.minimumFuseTime or p115.fuseTime) then
        return v118, v119
    end
    v118.isAtRest = true
    v118.velocity = Vector3.new(0, 0, 0)
    v118.angularVelocity = Vector3.new(0, 0, 0)
    return v118, {
        ["type"] = "rest",
        ["timestamp"] = nil,
        ["position"] = nil,
        ["normal"] = nil,
        ["velocity"] = Vector3.new(0, 0, 0),
        ["bounceCount"] = nil,
        ["timestamp"] = p114.timestamp + v118.simulationTime,
        ["position"] = v118.position,
        ["normal"] = v127 or Vector3.new(0, 1, 0),
        ["bounceCount"] = v118.bounceCount
    }
end
function v_u_78.simulate(p128, p129, p130, p131) -- name: simulate
    -- upvalues: (copy) v_u_78
    if p128.isAtRest then
        if not p129.fuseTime then
            return {
                ["state"] = p128,
                ["events"] = {}
            }
        end
        local v132 = table.clone(p128)
        v132.simulationTime = p128.simulationTime + p131
        return v132.simulationTime >= p129.fuseTime and {
            ["state"] = v132,
            ["events"] = {
                {
                    ["type"] = "fuse",
                    ["timestamp"] = nil,
                    ["position"] = nil,
                    ["normal"] = Vector3.new(0, 1, 0),
                    ["velocity"] = nil,
                    ["bounceCount"] = nil,
                    ["timestamp"] = p128.timestamp + v132.simulationTime,
                    ["position"] = v132.position,
                    ["velocity"] = v132.velocity,
                    ["bounceCount"] = v132.bounceCount
                }
            }
        } or {
            ["state"] = v132,
            ["events"] = {}
        }
    end
    local v133 = table.clone(p128)
    v133.accumulatedTime = p128.accumulatedTime + p131
    local v134, v135
    if v133.accumulatedTime > 0.1 then
        v133.accumulatedTime = 0.1
        v134 = 0
        v135 = {}
    else
        v134 = 0
        v135 = {}
    end
    while v133.accumulatedTime >= 0.0078125 and v134 < 16 do
        v134 = v134 + 1
        v133.accumulatedTime = v133.accumulatedTime - 0.0078125
        local v136
        v133, v136 = v_u_78.step(v133, p129, p130, 0.0078125)
        if v136 then
            table.insert(v135, v136)
        end
        if v133.isAtRest then
            break
        end
    end
    return {
        ["state"] = v133,
        ["events"] = v135
    }
end
function v_u_78.calculateThrowParameters(p137, p138, p139, p140) -- name: calculateThrowParameters
    local v141 = p139 == "Near"
    local v142 = (v141 and 0.04 or 0.06) * math.clamp(p140, 0.8, 1.2)
    local v143 = 1.35
    local v144 = 2.4
    local v145
    if v141 then
        v143 = v143 * 0.55
        v145 = v144 * 0.8
        v142 = v142 + 0.08
    else
        v145 = v144 + 0.1
    end
    local Unit = (p138 + Vector3.new(0, v142, 0)).Unit
    local v147 = p138.X
    local v148 = p138.Z
    local v149 = Vector3.new(v147, 0, v148)
    return p137 + (v149.Magnitude < 0.01 and Vector3.new(0, 0, -1) or v149).Unit * v143 + Vector3.new(0, v145, 0), Unit
end
function v_u_78.interpolateState(p150, p151, p152) -- name: interpolateState
    local v153 = table.clone(p151)
    v153.position = p150.position:Lerp(p151.position, p152)
    v153.velocity = p150.velocity:Lerp(p151.velocity, p152)
    v153.angularVelocity = p150.angularVelocity:Lerp(p151.angularVelocity, p152)
    return v153
end
return v_u_78
