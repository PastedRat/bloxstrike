-- Decompiled with Medal

local v_u_1 = {}
v_u_1.__index = v_u_1
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local m_Sound = require(ReplicatedStorage.Classes.Sound)
local m_GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_Profiler = require(ReplicatedStorage.Shared.Profiler)
local m_Promise = require(ReplicatedStorage.Shared.Promise)
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_MenuState = require(script.MenuState)
local Screens = script:WaitForChild("Screens")
local MainGui = ReplicatedStorage.Assets.UI:WaitForChild("MainGui") or PlayerGui:FindFirstChild("MainGui")
MainGui.Parent = PlayerGui
local v_u_16 = nil
local v_u_17 = nil
local v_u_18 = 1
local v_u_19 = {
    "Ammo",
    "Armor",
    "Health",
    "Inventory",
    "Money"
}
local function v_u_28(p20, p21) -- name: recursive
    -- upvalues: (copy) v_u_28, (copy) m_Profiler, (copy) m_Promise, (copy) MainGui, (copy) RunService
    if p21 then
        for _, v_u_22 in ipairs(p20:GetChildren()) do
            local v_u_23 = p21:FindFirstChild(v_u_22.Name)
            if v_u_22:IsA("Folder") then
                if v_u_23 then
                    v_u_28(v_u_22, v_u_23)
                else
                    warn((("Missing corresponding interface folder : \"%*\""):format((string.lower(v_u_22:GetFullName())))))
                end
            elseif v_u_22:IsA("ModuleScript") then
                if v_u_23 then
                    local v_u_24 = m_Profiler.getInstancePath(v_u_22, script)
                    local v_u_25 = m_Profiler.getInstancePath(v_u_22, script)
                    m_Promise.try(function()
                        -- upvalues: (copy) v_u_25, (ref) m_Profiler, (copy) v_u_22
                        debug.setmemorycategory((("Interface.%*"):format(v_u_25)))
                        m_Profiler.mark((("Interface.Require.%*"):format(v_u_25)))
                        return require(v_u_22)
                    end):catch(warn):andThen(function(p_u_26)
                        -- upvalues: (ref) m_Promise, (copy) v_u_24, (ref) m_Profiler, (ref) MainGui, (copy) v_u_23
                        local v27
                        if p_u_26.Initialize then
                            v27 = m_Promise.try(function()
                                -- upvalues: (ref) v_u_24, (ref) m_Profiler, (copy) p_u_26, (ref) MainGui, (ref) v_u_23
                                debug.setmemorycategory((("Interface.%*"):format(v_u_24)))
                                m_Profiler.mark((("Interface.Initialize.%*"):format(v_u_24)))
                                return p_u_26.Initialize(MainGui, v_u_23)
                            end)
                        else
                            v27 = m_Promise.resolve()
                        end
                        v27:andThen(function()
                            -- upvalues: (copy) p_u_26, (ref) m_Promise, (ref) v_u_24, (ref) m_Profiler
                            if p_u_26.Start then
                                return m_Promise.try(function()
                                    -- upvalues: (ref) v_u_24, (ref) m_Profiler, (ref) p_u_26
                                    debug.setmemorycategory((("Interface.%*"):format(v_u_24)))
                                    m_Profiler.mark((("Interface.Start.%*"):format(v_u_24)))
                                    return p_u_26.Start()
                                end)
                            end
                        end):catch(warn)
                    end)
                elseif RunService:IsStudio() then
                    warn((("Missing corresponding interface module for : \"%*\""):format((string.lower(v_u_22:GetFullName())))))
                end
            end
        end
    else
        warn((("Pointer: \"%*\" is not apart of interface."):format(p20.Name)))
    end
end
function v_u_1.guarantee(p29) -- name: guarantee
    for _ = 1, 15 do
        if pcall(p29) then
            break
        end
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) m_MenuState, (copy) MainGui, (copy) v_u_1, (copy) StarterGui, (copy) m_GetUserPlatform, (copy) m_Profiler, (copy) v_u_19, (copy) m_DataController, (copy) LocalPlayer, (ref) v_u_18, (copy) m_Router, (ref) v_u_16, (copy) m_Sound, (copy) PlayerGui, (ref) v_u_17
    m_MenuState.Initialize(MainGui)
    v_u_1.guarantee(function()
        -- upvalues: (ref) StarterGui
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        StarterGui:SetCore("ResetButtonCallback", false)
    end)
    local Bottom = MainGui:WaitForChild("Gameplay"):WaitForChild("Bottom")
    local v_u_31 = {}
    local v_u_32 = table.find(m_GetUserPlatform(), "Mobile") ~= nil
    m_Profiler.spawn("Interface.Initialize.HUDScale", function()
        -- upvalues: (ref) m_Profiler, (ref) v_u_19, (copy) Bottom, (copy) v_u_31, (ref) m_DataController, (ref) LocalPlayer, (copy) v_u_32
        task.wait(0.1)
        m_Profiler.mark("Interface.HUDScale.Setup")
        for _, v33 in ipairs(v_u_19) do
            local v34 = Bottom:FindFirstChild(v33)
            if v34 and v34:IsA("Frame") then
                local v35 = v_u_31
                local v36 = v34:FindFirstChild("HUDScale")
                if not (v36 and v36:IsA("UIScale")) then
                    v36 = v34:FindFirstChildOfClass("UIScale")
                    if v36 then
                        v36.Name = "HUDScale"
                    else
                        v36 = Instance.new("UIScale")
                        v36.Name = "HUDScale"
                        v36.Parent = v34
                    end
                end
                table.insert(v35, v36)
            end
        end
        local v37 = v_u_32 and 1 or (m_DataController.Get(LocalPlayer, "Settings.Game.HUD.Scale") or 1)
        for _, v38 in ipairs(v_u_31) do
            v38.Scale = v37
        end
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Scale", function(p39)
        -- upvalues: (copy) v_u_32, (copy) v_u_31
        local v40 = v_u_32 and 1 or (p39 or 1)
        for _, v41 in ipairs(v_u_31) do
            v41.Scale = v40
        end
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Audio.Music.Main Menu Volume", function(p42)
        -- upvalues: (ref) v_u_18
        v_u_18 = (tonumber(p42) or 100) / 100
    end)
    m_Router.observerRouter("RunInterfaceSound", function(p43)
        -- upvalues: (ref) v_u_16, (ref) m_Sound, (ref) PlayerGui, (ref) v_u_18
        if not (v_u_16 and v_u_16.Sounds) then
            v_u_16 = m_Sound.new("Interface")
        end
        local v44 = v_u_16
        if v44 then
            v44:playOneTime({
                ["Parent"] = PlayerGui,
                ["Name"] = p43
            }, v_u_18)
        end
    end)
    m_Router.observerRouter("RunStoreSound", function(p45)
        -- upvalues: (ref) v_u_17, (ref) m_Sound, (ref) PlayerGui, (ref) v_u_18
        if not (v_u_17 and v_u_17.Sounds) then
            v_u_17 = m_Sound.new("Store")
        end
        local v46 = v_u_17
        if v46 then
            v46:playOneTime({
                ["Parent"] = PlayerGui,
                ["Name"] = p45
            }, v_u_18)
        end
    end)
end
function v_u_1.Start() -- name: Start
    -- upvalues: (copy) v_u_28, (copy) Screens, (copy) MainGui
    v_u_28(Screens, MainGui)
end
return v_u_1
