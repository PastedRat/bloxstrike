-- Decompiled with Medal

return function(p1) -- name: GetCharacterVelocity
    if p1 then
        p1 = p1:FindFirstChild("HumanoidRootPart")
    end
    return not p1 and Vector3.new(0, 0, 0) or p1.AssemblyLinearVelocity
end
