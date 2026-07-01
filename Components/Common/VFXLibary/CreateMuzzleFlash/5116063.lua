-- Decompiled with Medal

return function(p1, p2, p3, p4)
    debug.profilebegin("VFX.MuzzleFlash.CloneAsset")
    local v5 = p2:FindFirstChild(p3):Clone()
    v5.Name = p3
    v5.CollisionGroup = "Debris"
    v5.CanCollide = false
    v5.CanQuery = false
    v5.CanTouch = false
    v5.Anchored = false
    v5.Massless = true
    v5.CFrame = p1.CFrame
    v5.Parent = p1
    local v6 = Instance.new(p4)
    v6.Part0 = p1
    v6.Part1 = v5
    v6.Parent = v5
    debug.profileend()
    return v5
end
