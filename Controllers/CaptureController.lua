-- Decompiled with Medal

local v1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CaptureService = game:GetService("CaptureService")
local m_Promise = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Promise"))
function v1.CaptureScreenshot(p_u_5) -- name: CaptureScreenshot
    -- upvalues: (copy) m_Promise, (copy) CaptureService
    return m_Promise.new(function(p_u_6, p7)
        -- upvalues: (ref) CaptureService, (copy) p_u_5
        local v9, v10 = pcall(function()
            -- upvalues: (ref) CaptureService, (ref) p_u_5, (copy) p_u_6
            CaptureService:CaptureScreenshot(function(p8)
                -- upvalues: (ref) p_u_5, (ref) p_u_6
                if p_u_5 then
                    p_u_5(p8)
                end
                p_u_6(p8)
            end)
        end)
        if not v9 then
            p7(v10)
        end
    end)
end
return v1
