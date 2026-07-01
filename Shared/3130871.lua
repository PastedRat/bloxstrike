-- Decompiled with Medal

local HttpService = game:GetService("HttpService")
local v_u_66 = {
    ["startRecording"] = function(p2, p3, p4, p5, p6, p7) -- name: startRecording
        local v8 = {
            ["grenade_type"] = nil,
            ["throw_type"] = nil,
            ["start_position"] = nil,
            ["throw_direction"] = nil,
            ["player_velocity"] = nil,
            ["player_state"] = nil,
            ["map_name"] = "",
            ["start_time"] = nil,
            ["points"] = nil,
            ["bounces"] = nil,
            ["end_position"] = nil,
            ["end_reason"] = nil,
            ["grenade_type"] = p2,
            ["throw_type"] = p3,
            ["start_position"] = { p4.X, p4.Y, p4.Z }
        }
        local Unit = p5.Unit
        v8.throw_direction = { Unit.X, Unit.Y, Unit.Z }
        v8.player_velocity = { p6.X, p6.Y, p6.Z }
        v8.player_state = p7 or "standing"
        v8.start_time = tick()
        v8.points = {}
        v8.bounces = {}
        return v8
    end,
    ["recordPoint"] = function(p10, p11, p12) -- name: recordPoint
        local v13 = p11.simulationTime * 1000
        local v14 = math.floor(v13)
        if p12 or v14 - (#p10.points <= 0 and -16 or p10.points[#p10.points].time_ms) >= 16 then
            local v15 = {
                ["time_ms"] = v14
            }
            local position = p11.position
            v15.position = { position.X, position.Y, position.Z }
            local velocity = p11.velocity
            v15.velocity = { velocity.X, velocity.Y, velocity.Z }
            v15.speed = p11.velocity.Magnitude
            local points = p10.points
            table.insert(points, v15)
        end
    end,
    ["recordBounce"] = function(p19, p20, p21, p22) -- name: recordBounce
        local v23 = p20.normal or Vector3.new(0, 1, 0)
        local velocity_0 = p20.velocity
        local v25 = {}
        local v26 = (p20.timestamp - (p19.start_time or p20.timestamp)) * 1000
        v25.time_ms = math.floor(v26)
        local position_0 = p20.position
        v25.position = { position_0.X, position_0.Y, position_0.Z }
        v25.velocity_before = { p21.X, p21.Y, p21.Z }
        v25.velocity_after = { velocity_0.X, velocity_0.Y, velocity_0.Z }
        v25.surface_normal = { v23.X, v23.Y, v23.Z }
        v25.surface_type = p22 or "world"
        local Magnitude = p21.Magnitude
        local v29
        if Magnitude < 0.001 then
            v29 = 0
        else
            local v30 = (p21 / Magnitude):Dot(v23)
            local v31 = math.abs(v30)
            local v32 = math.clamp(v31, -1, 1)
            local v33 = math.acos(v32)
            v29 = math.deg(v33)
        end
        v25.incident_angle = v29
        local Magnitude_0 = velocity_0.Magnitude
        local v35
        if Magnitude_0 < 0.001 then
            v35 = 0
        else
            local v36 = (velocity_0 / Magnitude_0):Dot(v23)
            local v37 = math.abs(v36)
            local v38 = math.clamp(v37, -1, 1)
            local v39 = math.acos(v38)
            v35 = math.deg(v39)
        end
        v25.reflection_angle = v35
        local bounces = p19.bounces
        table.insert(bounces, v25)
    end,
    ["finishRecording"] = function(p41, p42, p43) -- name: finishRecording
        p41.end_position = { p42.X, p42.Y, p42.Z }
        p41.end_reason = p43
    end,
    ["exportJSON"] = function(p44, p45) -- name: exportJSON
        -- upvalues: (copy) HttpService
        local time_ms = #p44.points <= 0 and 0 or p44.points[#p44.points].time_ms
        local v47 = {
            ["metadata"] = {
                ["source"] = "roblox",
                ["grenade_type"] = nil,
                ["throw_type"] = nil,
                ["map"] = nil,
                ["coordinate_system"] = nil,
                ["grenade_type"] = p44.grenade_type,
                ["throw_type"] = p44.throw_type,
                ["map"] = p45 or (p44.map_name or ""),
                ["coordinate_system"] = {
                    ["up_axis"] = "y",
                    ["unit"] = "studs"
                }
            },
            ["throw_params"] = {
                ["start_position"] = p44.start_position,
                ["throw_direction"] = p44.throw_direction,
                ["player_velocity"] = p44.player_velocity,
                ["player_state"] = p44.player_state
            },
            ["trajectory"] = p44.points,
            ["bounces"] = p44.bounces,
            ["summary"] = {
                ["duration_ms"] = time_ms,
                ["bounce_count"] = #p44.bounces,
                ["end_position"] = p44.end_position,
                ["end_reason"] = p44.end_reason
            }
        }
        return HttpService:JSONEncode(v47)
    end,
    ["simulateAndExport"] = function(p48, p49, p50, p51, p52, p53, p54, p55, p56) -- name: simulateAndExport
        -- upvalues: (copy) v_u_66
        local v57, v58 = p48.calculateThrowParameters(p51, p52, p50, p54.rangeScale)
        local state = p48.createInitialState(v57, v58, p50, p53, p54.rangeScale, tick())
        local v60 = p50 == "Far" and "left" or "right"
        local v61 = v_u_66.startRecording(p49, v60, v57, v58, p53, p53.Magnitude > 1 and "walking" or "standing")
        v_u_66.recordPoint(v61, state, true)
        local v62 = 0
        while not state.isAtRest and v62 < 10000 do
            v62 = v62 + 1
            local velocity_1 = state.velocity
            local v64 = p48.simulate(state, p54, p55, 0.016666666666666666)
            state = v64.state
            v_u_66.recordPoint(v61, state)
            for _, v65 in v64.events do
                if v65.type == "bounce" then
                    v_u_66.recordBounce(v61, v65, velocity_1)
                elseif v65.type == "rest" or (v65.type == "fuse" or v65.type == "floor_impact") then
                    v_u_66.finishRecording(v61, v65.position, v65.type)
                end
            end
        end
        if not v61.end_reason then
            v_u_66.finishRecording(v61, state.position, "timeout")
        end
        v_u_66.recordPoint(v61, state, true)
        return v_u_66.exportJSON(v61, p56)
    end
}
return v_u_66
