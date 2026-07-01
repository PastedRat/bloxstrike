-- Decompiled with Medal

local v_u_1 = {}
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
require(script:WaitForChild("Types"))
local m_DataController = require(ReplicatedStorage.Controllers.DataController)
local m_MenuState = require(ReplicatedStorage.Interface.MenuState)
local m_GetUserPlatform = require(ReplicatedStorage.Components.Common.GetUserPlatform)
local m_Router = require(ReplicatedStorage.Database.Security.Router)
local m_KeybindParser = require(script:WaitForChild("KeybindParser"))
local Actions = script:WaitForChild("Actions")
local LocalPlayer = Players.LocalPlayer
local v_u_13 = {}
local v_u_14 = {}
local v_u_15 = {}
local v_u_16 = {
    ["ScrollWheelUp"] = nil,
    ["ScrollWheelDown"] = nil
}
local function v_u_26(p17, p18, p19) -- name: handleInput
    -- upvalues: (copy) v_u_15, (copy) m_MenuState, (copy) v_u_14
    local v20 = v_u_15[p17]
    if v20 then
        local v21 = m_MenuState.GetMenuFrame()
        local v22 = m_MenuState.GetCurrentScreen()
        local v23 = m_MenuState.GetMainGui()
        if v23 then
            v23 = v23:FindFirstChild("Gameplay")
        end
        local v24
        if v23 then
            v24 = v23:FindFirstChild("Bottom")
        else
            v24 = v23
        end
        if v23 then
            v23 = v23:FindFirstChild("Middle")
        end
        if v23 then
            v23 = v23:FindFirstChild("TeamSelection")
        end
        local Visible = v23 and v23:IsA("GuiObject") and (v23.Visible and (v24 and v24:IsA("GuiObject")))
        if Visible then
            Visible = not v24.Visible
        end
        if ((v22 ~= nil or v21 and v21.Visible == true) and true or Visible == true) and (v20.Category ~= "UI Keys" and v20.Category ~= "Communication Options" and p18 == Enum.UserInputState.Begin) then
            v20.IsActive = false
            return
        elseif v_u_14[v20.Group] == true then
            v20.IsActive = p18 == Enum.UserInputState.Begin
            task.spawn(v20.Callback, p18, p19)
        elseif p18 ~= Enum.UserInputState.Begin and v20.IsActive then
            v20.IsActive = false
            task.spawn(v20.Callback, p18, p19)
        end
    else
        return
    end
end
local function v_u_29(p27, p28) -- name: handleScrollWheelInput
    -- upvalues: (copy) v_u_26
    if p27 then
        v_u_26(p27, Enum.UserInputState.Begin, {
            ["UserInputType"] = Enum.UserInputType.MouseWheel,
            ["Delta"] = Vector3.new(0, p28, 0)
        })
        task.defer(v_u_26, p27, Enum.UserInputState.End, {
            ["UserInputType"] = Enum.UserInputType.MouseWheel,
            ["Delta"] = Vector3.new(0, p28, 0)
        })
    end
end
function v_u_1.registerAction(p30) -- name: registerAction
    -- upvalues: (copy) v_u_15
    v_u_15[p30.Name] = {
        ["Category"] = nil,
        ["Callback"] = nil,
        ["Group"] = nil,
        ["BindPriority"] = nil,
        ["Name"] = nil,
        ["IsActive"] = false,
        ["Keybinds"] = nil,
        ["Category"] = p30.Category,
        ["Callback"] = p30.Callback,
        ["Group"] = p30.Group,
        ["BindPriority"] = p30.BindPriority,
        ["Name"] = p30.Name,
        ["Keybinds"] = {}
    }
end
function v_u_1.bindKeybinds(p_u_31, p32) -- name: bindKeybinds
    -- upvalues: (copy) v_u_15, (copy) ContextActionService, (copy) v_u_16, (copy) v_u_13, (copy) v_u_26
    local v33 = v_u_15[p_u_31]
    if v33 then
        ContextActionService:UnbindAction(p_u_31)
        for _, v34 in ipairs(v33.Keybinds) do
            if typeof(v34) == "string" then
                if v34 == "ScrollWheelUp" then
                    v_u_16.ScrollWheelUp = nil
                elseif v34 == "ScrollWheelDown" then
                    v_u_16.ScrollWheelDown = nil
                end
            else
                v_u_13[v34] = nil
            end
        end
        local v35 = {}
        local v36 = {}
        for _, v37 in ipairs(p32) do
            if v37 then
                if typeof(v37) == "string" then
                    if v37 == "ScrollWheelUp" and not v_u_16.ScrollWheelUp then
                        table.insert(v35, v37)
                        v_u_16.ScrollWheelUp = p_u_31
                    elseif v37 == "ScrollWheelDown" and not v_u_16.ScrollWheelDown then
                        table.insert(v35, v37)
                        v_u_16.ScrollWheelDown = p_u_31
                    end
                elseif not v_u_13[v37] then
                    table.insert(v35, v37)
                    table.insert(v36, v37)
                    v_u_13[v37] = p_u_31
                end
            end
        end
        v33.Keybinds = v35
        if #v36 > 0 then
            local function v40(_, p38, p39)
                -- upvalues: (ref) v_u_26, (copy) p_u_31
                v_u_26(p_u_31, p38, p39)
            end
            if v33.BindPriority ~= nil then
                ContextActionService:BindActionAtPriority(p_u_31, v40, false, v33.BindPriority, table.unpack(v36))
                return
            end
            ContextActionService:BindAction(p_u_31, v40, false, table.unpack(v36))
        end
    end
end
function v_u_1.loadActionsFromDatabase(p41) -- name: loadActionsFromDatabase
    -- upvalues: (copy) m_KeybindParser, (copy) v_u_1
    for _, v42 in pairs(p41) do
        for v43, v44 in pairs(v42) do
            local v45 = {}
            if typeof(v44) == "table" then
                local v46 = v44.Computer and v44.Computer ~= "" and m_KeybindParser.parse(v44.Computer)
                if v46 then
                    table.insert(v45, v46)
                end
                local v47 = v44.Console and v44.Console ~= "" and m_KeybindParser.parse(v44.Console)
                if v47 then
                    table.insert(v45, v47)
                end
                v_u_1.bindKeybinds(v43, v45)
            end
        end
    end
end
function v_u_1.isActionActive(p48) -- name: isActionActive
    -- upvalues: (copy) v_u_15
    local v49 = v_u_15[p48]
    return v49 and v49.IsActive or false
end
function v_u_1.enableGroup(p50) -- name: enableGroup
    -- upvalues: (copy) v_u_14
    v_u_14[p50] = true
end
function v_u_1.disableGroup(p51) -- name: disableGroup
    -- upvalues: (copy) v_u_14
    v_u_14[p51] = nil
end
function v_u_1.GetActionKeybind(p52) -- name: GetActionKeybind
    -- upvalues: (copy) v_u_15
    local v53 = v_u_15[p52]
    if v53 and #v53.Keybinds ~= 0 then
        local v54 = v53.Keybinds[1]
        if typeof(v54) == "string" then
            return v54
        else
            return tostring(v54):match("%.(%w+)$") or tostring(v54)
        end
    else
        return nil
    end
end
function v_u_1.Initialize() -- name: Initialize
    -- upvalues: (copy) Actions, (copy) v_u_1, (copy) LocalPlayer, (copy) ContextActionService, (copy) m_DataController, (copy) m_Router
    for _, v55 in ipairs(Actions:GetChildren()) do
        if v55:IsA("ModuleScript") then
            v_u_1.registerAction((require(v55)))
        end
    end
    v_u_1.enableGroup("Default")
    LocalPlayer.CharacterAdded:Connect(function(_)
        -- upvalues: (ref) ContextActionService
        ContextActionService:UnbindAction("jumpAction")
    end)
    m_DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse", function(p56)
        -- upvalues: (ref) v_u_1
        if p56 then
            v_u_1.loadActionsFromDatabase(p56)
        end
    end)
    m_Router.observerRouter("RebindKeybinds", function()
        -- upvalues: (ref) m_DataController, (ref) LocalPlayer, (ref) v_u_1
        local v57 = m_DataController.Get(LocalPlayer, "Settings.Keyboard/Mouse")
        if not v57 then
            return false
        end
        v_u_1.loadActionsFromDatabase(v57)
        return true
    end)
end
function v_u_1.getActionKeybinds(p58) -- name: getActionKeybinds
    -- upvalues: (copy) v_u_15
    local v59 = v_u_15[p58]
    if not v59 then
        return {}
    end
    local v60 = {}
    for _, v61 in ipairs(v59.Keybinds) do
        if typeof(v61) ~= "string" then
            table.insert(v60, v61)
        end
    end
    return v60
end
function v_u_1.isBindingPressed(p62) -- name: isBindingPressed
    -- upvalues: (copy) m_GetUserPlatform, (copy) UserInputService
    if typeof(p62) == "string" then
        return false
    elseif typeof(p62) == "EnumItem" then
        if p62.EnumType == Enum.KeyCode then
            if p62 ~= Enum.KeyCode.ButtonR2 and p62 ~= Enum.KeyCode.ButtonL2 or not table.find(m_GetUserPlatform(), "Console") then
                return UserInputService:IsKeyDown(p62)
            end
            local v63 = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
            for _, v64 in pairs(v63) do
                if v64.KeyCode == p62 then
                    return v64.Position.Z > 0.3
                end
            end
            return false
        elseif p62.EnumType == Enum.UserInputType then
            return UserInputService:IsMouseButtonPressed(p62)
        else
            return false
        end
    else
        return false
    end
end
function v_u_1.isActionPressed(p65, p66) -- name: isActionPressed
    -- upvalues: (copy) v_u_1
    local v67 = v_u_1.getActionKeybinds(p65)
    if #v67 == 0 then
        if not p66 or #p66 <= 0 then
            return false
        end
    else
        p66 = v67
    end
    for _, v68 in ipairs(p66) do
        if v_u_1.isBindingPressed(v68) then
            return true
        end
    end
    return false
end
function v_u_1.Start() -- name: Start
    -- upvalues: (copy) UserInputService, (copy) v_u_29, (copy) v_u_16
    UserInputService.InputChanged:Connect(function(p69)
        -- upvalues: (ref) v_u_29, (ref) v_u_16
        if p69.UserInputType == Enum.UserInputType.MouseWheel then
            local v70 = p69.Position.Z
            if v70 > 0 then
                v_u_29(v_u_16.ScrollWheelUp, 1)
            elseif v70 < 0 then
                v_u_29(v_u_16.ScrollWheelDown, -1)
            end
        else
            return
        end
    end)
end
return v_u_1
