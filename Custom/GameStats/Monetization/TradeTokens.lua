-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local v_u_4 = RunService:IsServer()
local v74 = {
    ["Credits Starter Pack"] = {
        ["Price"] = 57,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p5, p6) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v7 = v_u_4
            assert(v7, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits Starter Pack With Tokens", p5, p6)
        end
    },
    ["+ 400 Credits"] = {
        ["Price"] = 229,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p8, p9) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v10 = v_u_4
            assert(v10, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits With Tokens", p8, 400, p9)
        end
    },
    ["+ 950 Credits"] = {
        ["Price"] = 517,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p11, p12) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v13 = v_u_4
            assert(v13, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits With Tokens", p11, 950, p12)
        end
    },
    ["+ 3,100 Credits"] = {
        ["Price"] = 1437,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p14, p15) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v16 = v_u_4
            assert(v16, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits With Tokens", p14, 3100, p15)
        end
    },
    ["+ 6,500 Credits"] = {
        ["Price"] = 2874,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p17, p18) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v19 = v_u_4
            assert(v19, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits With Tokens", p17, 6500, p18)
        end
    },
    ["+ 13,250 Credits"] = {
        ["Price"] = 5749,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p20, p21) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v22 = v_u_4
            assert(v22, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits With Tokens", p20, 13250, p21)
        end
    },
    ["+ 27,000 Credits"] = {
        ["Price"] = 11499,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p23, p24) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v25 = v_u_4
            assert(v25, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits With Tokens", p23, 27000, p24)
        end
    },
    ["+ 67,500 Credits"] = {
        ["Price"] = 28749,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p26, p27) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v28 = v_u_4
            assert(v28, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits With Tokens", p26, 67500, p27)
        end
    },
    ["Gift + 400 Credits"] = {
        ["Price"] = 229,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p29, p30) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v31 = v_u_4
            assert(v31, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits With Tokens", p29, 400, p30)
        end
    },
    ["Gift + 950 Credits"] = {
        ["Price"] = 517,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p32, p33) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v34 = v_u_4
            assert(v34, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits With Tokens", p32, 950, p33)
        end
    },
    ["Gift + 3,100 Credits"] = {
        ["Price"] = 1437,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p35, p36) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v37 = v_u_4
            assert(v37, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits With Tokens", p35, 3100, p36)
        end
    },
    ["Gift + 6,500 Credits"] = {
        ["Price"] = 2874,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p38, p39) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v40 = v_u_4
            assert(v40, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits With Tokens", p38, 6500, p39)
        end
    },
    ["Gift + 13,250 Credits"] = {
        ["Price"] = 5749,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p41, p42) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v43 = v_u_4
            assert(v43, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits With Tokens", p41, 13250, p42)
        end
    },
    ["Gift + 27,000 Credits"] = {
        ["Price"] = 11499,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p44, p45) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v46 = v_u_4
            assert(v46, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits With Tokens", p44, 27000, p45)
        end
    },
    ["Gift + 67,500 Credits"] = {
        ["Price"] = 28749,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p47, p48) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v49 = v_u_4
            assert(v49, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits With Tokens", p47, 67500, p48)
        end
    },
    ["Purchase Featured Bundle"] = {
        ["Price"] = 1149,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p50, p51) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v52 = v_u_4
            assert(v52, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Featured Bundle With Tokens", p50, p51)
        end
    },
    ["Gift Featured Bundle"] = {
        ["Price"] = 1149,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p53, p54) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v55 = v_u_4
            assert(v55, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Featured Bundle With Tokens", p53, p54)
        end
    },
    ["M4A1-S | SuperSoaked"] = {
        ["Price"] = 689,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p56, p57) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v58 = v_u_4
            assert(v58, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Featured Package With Tokens", p56, "M4A1-S | SuperSoaked", p57)
        end
    },
    ["Sawed-Off | SuperSoaked"] = {
        ["Price"] = 459,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p59, p60) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v61 = v_u_4
            assert(v61, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Featured Package With Tokens", p59, "Sawed-Off | SuperSoaked", p60)
        end
    },
    ["USP-S | SuperSoaked"] = {
        ["Price"] = 574,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p62, p63) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v64 = v_u_4
            assert(v64, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Featured Package With Tokens", p62, "USP-S | SuperSoaked", p63)
        end
    },
    ["Gift M4A1-S | SuperSoaked"] = {
        ["Price"] = 689,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p65, p66) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v67 = v_u_4
            assert(v67, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Featured Package With Tokens", p65, "M4A1-S | SuperSoaked", p66)
        end
    },
    ["Gift Sawed-Off | SuperSoaked"] = {
        ["Price"] = 459,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p68, p69) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v70 = v_u_4
            assert(v70, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Featured Package With Tokens", p68, "Sawed-Off | SuperSoaked", p69)
        end
    },
    ["Gift USP-S | SuperSoaked"] = {
        ["Price"] = 574,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p71, p72) -- name: OnPurchased
            -- upvalues: (copy) v_u_4, (copy) m_Router
            local v73 = v_u_4
            assert(v73, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Featured Package With Tokens", p71, "USP-S | SuperSoaked", p72)
        end
    }
}
return table.freeze(v74)
