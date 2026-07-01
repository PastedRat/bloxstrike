-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local m_RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController)
local v_u_4 = 60
local v_u_5 = {}
local v_u_6 = tick()
local v_u_7 = 0
local function v13() -- name: updateSequences
    -- upvalues: (ref) v_u_7, (ref) v_u_6, (ref) v_u_4, (copy) v_u_5
    v_u_7 = v_u_7 + 1
    local v8 = tick()
    local v9 = v8 - v_u_6
    if v9 >= 1 then
        local v10 = v_u_7 / v9
        v_u_4 = math.floor(v10)
        v_u_6 = v8
        v_u_7 = 0
    end
    for v11, v12 in v_u_5 do
        if v11 and v11.Parent then
            v12._nextFrame(v8)
        else
            v12.stop()
        end
    end
end
if RunService:IsClient() then
    m_RunServiceController.BindToRenderStep("Shared.SpriteSequencer.Update", v13)
else
    m_RunServiceController.BindToHeartbeat("Shared.SpriteSequencer.Update", v13)
end
local v_u_31 = {
    ["new"] = function(p_u_14, p_u_15) -- name: new
        -- upvalues: (ref) v_u_4, (copy) v_u_5
        local v_u_20 = {
            ["looping"] = false,
            ["cells"] = nil,
            ["framerate"] = nil,
            ["cells"] = p_u_15,
            ["framerate"] = v_u_4,
            ["play"] = function(p16, p17) -- name: play
                -- upvalues: (ref) v_u_4, (copy) v_u_20, (ref) v_u_5, (copy) p_u_14
                local v18 = p16 or v_u_4
                v_u_20.looping = p17 or false
                v_u_20.framerate = v18
                local v19 = v_u_5[p_u_14.instance]
                if v19 then
                    if v19 == v_u_20 then
                        return
                    end
                    v19.stop()
                end
                v_u_5[p_u_14.instance] = v_u_20
            end,
            ["isPlaying"] = function() -- name: isPlaying
                -- upvalues: (ref) v_u_5, (copy) p_u_14, (copy) v_u_20
                return v_u_5[p_u_14.instance] == v_u_20
            end
        }
        local v_u_21 = 0
        local v_u_22 = tick()
        function v_u_20._nextFrame(p23) -- name: _nextFrame
            -- upvalues: (ref) v_u_22, (copy) v_u_20, (ref) v_u_21, (copy) p_u_14, (copy) p_u_15
            if p23 - v_u_22 >= 1 / v_u_20.framerate then
                v_u_22 = p23
                v_u_21 = v_u_21 + 1
                p_u_14.display(p_u_15[v_u_21])
                if v_u_21 >= #p_u_15 then
                    if v_u_20.looping then
                        v_u_21 = 0
                        return
                    end
                    v_u_20.stop()
                end
            end
        end
        function v_u_20.stop() -- name: stop
            -- upvalues: (ref) v_u_21, (ref) v_u_5, (copy) p_u_14, (copy) v_u_20
            v_u_21 = 0
            local v24 = v_u_5[p_u_14.instance]
            if v24 then
                if v24 == v_u_20 then
                    v_u_5[p_u_14.instance] = nil
                end
            else
                return
            end
        end
        return v_u_20
    end,
    ["fromRange"] = function(p25, p26, p27) -- name: fromRange
        -- upvalues: (copy) v_u_31
        local v28 = p27 - p26 > 0
        assert(v28, ".fromRange only accepts positive ranges")
        local v29 = {}
        for v30 = p26, p27 do
            v29[#v29 + 1] = v30
        end
        return v_u_31.new(p25, v29)
    end
}
return v_u_31
