-- Decompiled with Medal

local TextChatService = game:GetService("TextChatService")
return function(p_u_2)
    -- upvalues: (copy) TextChatService
    local v3, v4 = pcall(function()
        -- upvalues: (ref) TextChatService, (copy) p_u_2
        return TextChatService:CanUserChatAsync(p_u_2.UserId)
    end)
    if v3 then
        return v4
    end
    warn("[CanUserUseChat] Failed to check if user can use chat", v4)
    return false
end
