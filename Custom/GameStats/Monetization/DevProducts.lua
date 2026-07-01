-- Decompiled with Medal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
require(ReplicatedStorage.Database.Custom.Types)
local m_Constants = require(ReplicatedStorage.Database.Custom.Constants)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local v_u_5 = RunService:IsServer()
local v56 = {
    ["Credits Starter Pack"] = {
        ["DevProductId"] = 3550800164,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p6, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v7 = v_u_5
            assert(v7, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Credits Starter Pack", p6)
        end
    },
    ["Refresh Missions"] = {
        ["DevProductId"] = 3509753152,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p8, p9) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v10 = v_u_5
            assert(v10, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Refresh Missions", p8, p9)
        end
    },
    ["+ 400 Credits"] = {
        ["DevProductId"] = 3543515479,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p11, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v12 = v_u_5
            assert(v12, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Credits Purchased", p11, 400)
        end
    },
    ["+ 950 Credits"] = {
        ["DevProductId"] = 3543515926,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p13, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v14 = v_u_5
            assert(v14, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Credits Purchased", p13, 950)
        end
    },
    ["+ 3,100 Credits"] = {
        ["DevProductId"] = 3543516192,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p15, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v16 = v_u_5
            assert(v16, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Credits Purchased", p15, 3100)
        end
    },
    ["+ 6,500 Credits"] = {
        ["DevProductId"] = 3543516540,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p17, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v18 = v_u_5
            assert(v18, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Credits Purchased", p17, 6500)
        end
    },
    ["+ 13,250 Credits"] = {
        ["DevProductId"] = 3543516770,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p19, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v20 = v_u_5
            assert(v20, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Credits Purchased", p19, 13250)
        end
    },
    ["+ 27,000 Credits"] = {
        ["DevProductId"] = 3543517001,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p21, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v22 = v_u_5
            assert(v22, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Credits Purchased", p21, 27000)
        end
    },
    ["+ 67,500 Credits"] = {
        ["DevProductId"] = 3543517199,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p23, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v24 = v_u_5
            assert(v24, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Credits Purchased", p23, 67500)
        end
    },
    ["Gift + 400 Credits"] = {
        ["DevProductId"] = 3543518894,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p25, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v26 = v_u_5
            assert(v26, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits", p25, 400)
        end
    },
    ["Gift + 950 Credits"] = {
        ["DevProductId"] = 3543519307,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p27, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v28 = v_u_5
            assert(v28, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits", p27, 950)
        end
    },
    ["Gift + 3,100 Credits"] = {
        ["DevProductId"] = 3543519553,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p29, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v30 = v_u_5
            assert(v30, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits", p29, 3100)
        end
    },
    ["Gift + 6,500 Credits"] = {
        ["DevProductId"] = 3543519769,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p31, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v32 = v_u_5
            assert(v32, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits", p31, 6500)
        end
    },
    ["Gift + 13,250 Credits"] = {
        ["DevProductId"] = 3543520414,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p33, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v34 = v_u_5
            assert(v34, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits", p33, 13250)
        end
    },
    ["Gift + 27,000 Credits"] = {
        ["DevProductId"] = 3543520614,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p35, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v36 = v_u_5
            assert(v36, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Credits", p35, 27000)
        end
    },
    ["Gift + 67,500 Credits"] = {
        ["DevProductId"] = 3543520837,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p37, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Constants, (copy) m_Router
            local v38 = v_u_5
            assert(v38, "This function should only be called on the server.")
            local MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION = (require(game:GetService("ServerScriptService").Services.DataService).Get(p37, "Statistics.RobuxSpent") or 0) >= m_Constants.MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION
            assert(MINIMUM_CREDITS_FOR_SPECIAL_CREDITS_OPTION, "Player has not met the minimum spending requirement.")
            return m_Router.broadcastRouter("Gift Credits", p37, 67500)
        end
    },
    ["Purchase Featured Bundle"] = {
        ["DevProductId"] = 3602890548,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p40, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v41 = v_u_5
            assert(v41, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Featured Bundle", p40)
        end
    },
    ["Gift Featured Bundle"] = {
        ["DevProductId"] = 3602890606,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p42, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v43 = v_u_5
            assert(v43, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Featured Bundle", p42)
        end
    },
    ["M4A1-S | SuperSoaked"] = {
        ["DevProductId"] = 3602889991,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p44, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v45 = v_u_5
            assert(v45, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Featured Package", p44, "M4A1-S | SuperSoaked")
        end
    },
    ["Sawed-Off | SuperSoaked"] = {
        ["DevProductId"] = 3602890181,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p46, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v47 = v_u_5
            assert(v47, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Featured Package", p46, "Sawed-Off | SuperSoaked")
        end
    },
    ["USP-S | SuperSoaked"] = {
        ["DevProductId"] = 3602890348,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p48, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v49 = v_u_5
            assert(v49, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Purchase Featured Package", p48, "USP-S | SuperSoaked")
        end
    },
    ["Gift M4A1-S | SuperSoaked"] = {
        ["DevProductId"] = 3602890087,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p50, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v51 = v_u_5
            assert(v51, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Featured Package", p50, "M4A1-S | SuperSoaked")
        end
    },
    ["Gift Sawed-Off | SuperSoaked"] = {
        ["DevProductId"] = 3602890296,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p52, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v53 = v_u_5
            assert(v53, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Featured Package", p52, "Sawed-Off | SuperSoaked")
        end
    },
    ["Gift USP-S | SuperSoaked"] = {
        ["DevProductId"] = 3602890440,
        ["OnPurchased"] = nil,
        ["OnPurchased"] = function(p54, _) -- name: OnPurchased
            -- upvalues: (copy) v_u_5, (copy) m_Router
            local v55 = v_u_5
            assert(v55, "This function should only be called on the server.")
            return m_Router.broadcastRouter("Gift Featured Package", p54, "USP-S | SuperSoaked")
        end
    }
}
return table.freeze(v56)
