-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local m_Observers = require(ReplicatedStorage.Packages.Observers)
local m_Weapon = require(script.Weapon)
return m_Observers.observeTag("WeaponDropped", function(p4)
    -- upvalues: (copy) m_Weapon
    local v_u_5 = m_Weapon.new(p4)
    return function()
        -- upvalues: (copy) v_u_5
        if v_u_5 then
            v_u_5:destroy()
        end
    end
end)
