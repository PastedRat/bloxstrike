-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local profilebegin = debug.profilebegin
local profileend = debug.profileend
local m_RunServiceController = require(game:GetService("ReplicatedStorage").Controllers.RunServiceController)
local new_0 = Vector3.new
local new = CFrame.new
local Angles = CFrame.Angles
local rad = math.rad
local v_u_9 = new_0()
local m_CameraShakeInstance = require(script.CameraShakeInstance)
local CameraShakeState = m_CameraShakeInstance.CameraShakeState
v_u_1.CameraShakeInstance = m_CameraShakeInstance
v_u_1.Presets = require(script.CameraShakePresets)
function v_u_1.new(p12, p13) -- name: new
    -- upvalues: (copy) v_u_9, (copy) v_u_1
    local v14 = type(p12) == "number"
    assert(v14, "RenderPriority must be a number (e.g.: Enum.RenderPriority.Camera.Value)")
    local v15 = type(p13) == "function"
    assert(v15, "Callback must be a function")
    local v16 = {
        ["_running"] = false,
        ["_renderName"] = "CameraShaker",
        ["_renderPriority"] = nil,
        ["_posAddShake"] = nil,
        ["_rotAddShake"] = nil,
        ["_camShakeInstances"] = nil,
        ["_removeInstances"] = nil,
        ["_callback"] = nil,
        ["_renderPriority"] = p12,
        ["_posAddShake"] = v_u_9,
        ["_rotAddShake"] = v_u_9,
        ["_camShakeInstances"] = {},
        ["_removeInstances"] = {},
        ["_callback"] = p13
    }
    local v17 = v_u_1
    return setmetatable(v16, v17)
end
function v_u_1.Start(p_u_18) -- name: Start
    -- upvalues: (copy) m_RunServiceController, (copy) profilebegin, (copy) profileend
    if not p_u_18._running then
        p_u_18._running = true
        local _callback = p_u_18._callback
        m_RunServiceController.BindToRenderStep(p_u_18._renderName, p_u_18._renderPriority, function(p20)
            -- upvalues: (ref) profilebegin, (copy) p_u_18, (ref) profileend, (copy) _callback
            profilebegin("CameraShakerUpdate")
            local v21 = p_u_18:Update(p20)
            profileend()
            _callback(v21)
        end)
    end
end
function v_u_1.Stop(p22) -- name: Stop
    -- upvalues: (copy) m_RunServiceController
    if p22._running then
        m_RunServiceController.UnbindFromRenderStep(p22._renderName)
        p22._running = false
    end
end
function v_u_1.StopSustained(p23, p24) -- name: StopSustained
    for _, v25 in pairs(p23._camShakeInstances) do
        if v25.fadeOutDuration == 0 then
            v25:StartFadeOut(p24 or v25.fadeInDuration)
        end
    end
end
function v_u_1.Update(p26, p27) -- name: Update
    -- upvalues: (copy) v_u_9, (copy) CameraShakeState, (copy) new, (copy) Angles, (copy) rad
    local PositionInfluence = v_u_9
    local RotationInfluence = v_u_9
    local _camShakeInstances = p26._camShakeInstances
    for v31 = 1, #_camShakeInstances do
        local v32 = _camShakeInstances[v31]
        local v33 = v32:GetState()
        if v33 == CameraShakeState.Inactive and v32.DeleteOnInactive then
            p26._removeInstances[#p26._removeInstances + 1] = v31
        elseif v33 ~= CameraShakeState.Inactive then
            local v34 = v32:UpdateShake(p27)
            PositionInfluence = PositionInfluence + v34 * v32.PositionInfluence
            RotationInfluence = RotationInfluence + v34 * v32.RotationInfluence
        end
    end
    for v35 = #p26._removeInstances, 1, -1 do
        local v36 = p26._removeInstances[v35]
        table.remove(_camShakeInstances, v36)
        p26._removeInstances[v35] = nil
    end
    return new(PositionInfluence) * Angles(0, rad(RotationInfluence.Y), 0) * Angles(rad(RotationInfluence.X), 0, (rad(RotationInfluence.Z)))
end
function v_u_1.Shake(p37, p38) -- name: Shake
    local v39
    if type(p38) == "table" then
        v39 = p38._camShakeInstance
    else
        v39 = false
    end
    assert(v39, "ShakeInstance must be of type CameraShakeInstance")
    p37._camShakeInstances[#p37._camShakeInstances + 1] = p38
    return p38
end
function v_u_1.ShakeSustain(p40, p41) -- name: ShakeSustain
    local v42
    if type(p41) == "table" then
        v42 = p41._camShakeInstance
    else
        v42 = false
    end
    assert(v42, "ShakeInstance must be of type CameraShakeInstance")
    p40._camShakeInstances[#p40._camShakeInstances + 1] = p41
    p41:StartFadeIn(p41.fadeInDuration)
    return p41
end
function v_u_1.ShakeOnce(p43, p44, p45, p46, p47, p48, p49) -- name: ShakeOnce
    -- upvalues: (copy) m_CameraShakeInstance
    local v50 = m_CameraShakeInstance.new(p44, p45, p46, p47)
    v50.PositionInfluence = typeof(p48) == "Vector3" and p48 and p48 or Vector3.new(0.15, 0.15, 0.15)
    v50.RotationInfluence = typeof(p49) == "Vector3" and p49 and p49 or Vector3.new(1, 1, 1)
    p43._camShakeInstances[#p43._camShakeInstances + 1] = v50
    return v50
end
function v_u_1.StartShake(p51, p52, p53, p54, p55, p56) -- name: StartShake
    -- upvalues: (copy) m_CameraShakeInstance
    local v57 = m_CameraShakeInstance.new(p52, p53, p54)
    v57.PositionInfluence = typeof(p55) == "Vector3" and p55 and p55 or Vector3.new(0.15, 0.15, 0.15)
    v57.RotationInfluence = typeof(p56) == "Vector3" and p56 and p56 or Vector3.new(1, 1, 1)
    v57:StartFadeIn(p54)
    p51._camShakeInstances[#p51._camShakeInstances + 1] = v57
    return v57
end
return v_u_1
