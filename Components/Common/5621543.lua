-- Decompiled with Medal

local UserInputService = game:GetService("UserInputService")
return function()
    -- upvalues: (copy) UserInputService
    local v2 = {}
    if UserInputService.GamepadEnabled then
        table.insert(v2, "Console")
    end
    if UserInputService.VREnabled then
        table.insert(v2, "VR")
    end
    if UserInputService.MouseEnabled or UserInputService.KeyboardEnabled then
        table.insert(v2, "PC")
    end
    if UserInputService.TouchEnabled and not table.find(v2, "PC") then
        table.insert(v2, "Mobile")
    end
    return v2
end
