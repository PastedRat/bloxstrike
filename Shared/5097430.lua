-- Decompiled with Medal

local v_u_1 = {
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7
}
local v_u_2 = {
    0,
    1,
    3,
    4,
    5,
    7
}
local v_u_3 = {
    0,
    1,
    4,
    5,
    6
}
local v_u_4 = {}
v_u_4.__index = v_u_4
v_u_4.ClassName = "ViewportModel"
local function v_u_16(p5, p6, p7) -- name: getCorners
    local v8 = {}
    for v9, v10 in pairs(p7) do
        local v11 = v10 / 4
        local v12 = math.floor(v11) % 2 * 2 - 1
        local v13 = v10 / 2
        local v14 = math.floor(v13) % 2 * 2 - 1
        local v15 = 2 * (v10 % 2) - 1
        v8[v9] = p5 * (p6 * Vector3.new(v12, v14, v15))
    end
    return v8
end
local function v_u_23(p17) -- name: getModelPointCloud
    -- upvalues: (copy) v_u_2, (copy) v_u_3, (copy) v_u_1, (copy) v_u_16
    local v18 = {}
    for _, v19 in pairs(p17:GetDescendants()) do
        if v19:IsA("BasePart") then
            local v20
            if v19:IsA("WedgePart") then
                v20 = v_u_2
            elseif v19:IsA("CornerWedgePart") then
                v20 = v_u_3
            else
                v20 = v_u_1
            end
            local v21 = v_u_16(v19.CFrame, v19.Size / 2, v20)
            for _, v22 in pairs(v21) do
                table.insert(v18, v22)
            end
        end
    end
    return v18
end
local function v_u_34(p24, p25, p26, p27) -- name: viewProjectionEdgeHits
    local v28 = (-1 / 0)
    local v29 = (1 / 0)
    for _, v30 in pairs(p24) do
        local v31 = p27 * (p26 - v30.Z)
        local v32 = v30[p25] + v31
        local v33 = v30[p25] - v31
        v28 = math.max(v28, v32, v33)
        v29 = math.min(v29, v32, v33)
    end
    return v28, v29
end
function v_u_4.GenerateViewport(p35, p36, p37) -- name: GenerateViewport
    -- upvalues: (copy) v_u_4
    local v38 = p37 or CFrame.Angles(0, 0, 0)
    local Camera = p35:FindFirstChildOfClass("Camera")
    if not Camera then
        Camera = Instance.new("Camera")
        Camera.FieldOfView = 70
        Camera.Parent = p35
        p35.CurrentCamera = Camera
    end
    p36.Parent = p35
    local v40 = v_u_4.new(p35, Camera)
    v40:SetModel(p36)
    Camera.CFrame = v40:GetMinimumFitCFrame(v38)
end
function v_u_4.CleanViewport(p41) -- name: CleanViewport
    local Model = p41:FindFirstChildOfClass("Model")
    if Model then
        Model:Destroy()
    end
end
function v_u_4.new(p43, p44) -- name: new
    -- upvalues: (copy) v_u_4
    local v45 = v_u_4
    local v46 = setmetatable({}, v45)
    v46.Model = nil
    v46.ViewportFrame = p43
    v46.Camera = p44
    v46._points = {}
    v46._modelCFrame = CFrame.new()
    v46._modelSize = Vector3.new()
    v46._modelRadius = 0
    v46._viewport = {}
    v46:Calibrate()
    return v46
end
function v_u_4.SetModel(p47, p48) -- name: SetModel
    -- upvalues: (copy) v_u_23
    p47.Model = p48
    local v49, v50 = p48:GetBoundingBox()
    p47._points = v_u_23(p48)
    p47._modelCFrame = v49
    p47._modelSize = v50
    p47._modelRadius = v50.Magnitude / 2
end
function v_u_4.Calibrate(p51) -- name: Calibrate
    local v52 = {}
    local AbsoluteSize = p51.ViewportFrame.AbsoluteSize
    v52.aspect = AbsoluteSize.X / AbsoluteSize.Y
    local v54 = p51.Camera.FieldOfView / 2
    v52.yFov2 = math.rad(v54)
    local yFov2 = v52.yFov2
    v52.tanyFov2 = math.tan(yFov2)
    local aspect = v52.tanyFov2 * v52.aspect
    v52.xFov2 = math.atan(aspect)
    local xFov2 = v52.xFov2
    v52.tanxFov2 = math.tan(xFov2)
    local tanyFov2 = v52.tanyFov2
    local aspect_0 = v52.aspect
    local v60 = tanyFov2 * math.min(1, aspect_0)
    v52.cFov2 = math.atan(v60)
    local cFov2 = v52.cFov2
    v52.sincFov2 = math.sin(cFov2)
    p51._viewport = v52
end
function v_u_4.GetFitDistance(p62, p63) -- name: GetFitDistance
    local v64 = p63 and ((p63 - p62._modelCFrame.Position).Magnitude or 0) or 0
    return (p62._modelRadius + v64) / p62._viewport.sincFov2
end
function v_u_4.GetMinimumFitCFrame(p65, p66) -- name: GetMinimumFitCFrame
    -- upvalues: (copy) v_u_34
    if not p65.Model then
        return CFrame.new()
    end
    local v67 = (p66 - p66.Position):Inverse()
    local _points = p65._points
    local v69 = { v67 * _points[1] }
    local v70 = v69[1].Z
    for v71 = 2, #_points do
        local v72 = v67 * _points[v71]
        local v73 = v72.Z
        v70 = math.min(v70, v73)
        v69[v71] = v72
    end
    local v74, v75 = v_u_34(v69, "X", v70, p65._viewport.tanxFov2)
    local v76, v77 = v_u_34(v69, "Y", v70, p65._viewport.tanyFov2)
    local tanxFov2 = (v74 - v75) / 2 / p65._viewport.tanxFov2
    local tanyFov2_0 = (v76 - v77) / 2 / p65._viewport.tanyFov2
    local v80 = math.max(tanxFov2, tanyFov2_0)
    return p66 * CFrame.new((v74 + v75) / 2, (v76 + v77) / 2, v70 + v80)
end
return v_u_4
