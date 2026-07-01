-- Decompiled with Medal

local v_u_1 = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
require(ReplicatedStorage.Database.Custom.Types)
local LocalPlayer = Players.LocalPlayer
local v_u_5 = {}
local v_u_6 = {}
local v_u_7 = {}
local v_u_8 = {}
local function v_u_12(p9) -- name: IsDeadCharacterModel
    if typeof(p9) ~= "Instance" or not p9:IsA("Model") then
        return false
    end
    if p9:HasTag("Ragdoll") then
        return false
    end
    if p9:GetAttribute("Dead") == true then
        return true
    end
    local Humanoid = p9:FindFirstChildOfClass("Humanoid")
    local v11
    if Humanoid == nil then
        v11 = false
    else
        v11 = Humanoid.Health <= 0
    end
    return v11
end
local function v_u_18(p13) -- name: ResolveEnemyCharacter
    -- upvalues: (copy) Players, (copy) v_u_8, (copy) v_u_12
    local Victim = p13.Victim
    if Victim then
        local Character = Players:GetPlayerByUserId(Victim)
        local v16 = Character and Character.Name or v_u_8[Victim]
        if v16 then
            local v17 = workspace:WaitForChild("Debris"):QueryDescendants((("#%*"):format(v16)))[1]
            if v_u_12(v17) then
                return v17
            else
                if Character then
                    Character = Character.Character
                end
                if v_u_12(Character) then
                    return Character
                elseif Character and (Character:IsA("Model") and not Character:HasTag("Ragdoll")) then
                    return Character
                else
                    return nil
                end
            end
        else
            return nil
        end
    else
        return nil
    end
end
function v_u_1.IsFinisherValidForReplication(p19) -- name: IsFinisherValidForReplication
    -- upvalues: (copy) v_u_7, (copy) LocalPlayer
    local v20 = v_u_7[p19.Finisher]
    local v21 = ("\"%*\" is not a valid member of database.custom.finishers"):format(p19.Finisher)
    assert(v20, v21)
    local UserId = LocalPlayer.UserId
    return v20.Replication == "Killer" and p19.Killer == UserId and true or (v20.Replication == "Victim" and p19.Victim == UserId and true or (v20.Replication == "Both" and (p19.Killer == UserId or p19.Victim == UserId) and true or v20.Replication == "All"))
end
function v_u_1.ExecuteFinisher(p_u_23) -- name: ExecuteFinisher
    -- upvalues: (copy) v_u_1, (copy) v_u_7, (copy) v_u_18, (copy) v_u_6, (copy) v_u_5
    if v_u_1.IsFinisherValidForReplication(p_u_23) then
        local v_u_24 = v_u_7[p_u_23.Finisher]
        local v25 = ("\"%*\" is not a valid member of database.custom.finishers"):format(p_u_23.Finisher)
        assert(v_u_24, v25)
        local v36, v37 = pcall(function()
            -- upvalues: (ref) v_u_18, (copy) p_u_23, (ref) v_u_6, (ref) v_u_5, (copy) v_u_24
            local v26 = v_u_18(p_u_23)
            if not v26 then
                local v27 = os.clock() + 0.35
                repeat
                    task.wait(0.05)
                    v26 = v_u_18(p_u_23)
                until v26 or v27 <= os.clock()
            end
            if not v26 then
                warn((("Failed to execute finisher \"%*\": missing victim character \"%*\""):format(p_u_23.Finisher, p_u_23.Victim)))
                return nil
            end
            v26.Archivable = true
            local Victim_0 = p_u_23.Victim
            local v_u_29 = tostring(Victim_0)
            local v30 = v_u_6[v_u_29]
            if v30 then
                v30.Destroy()
            end
            while #v_u_5 >= 8 do
                local v31 = table.remove(v_u_5, 1)
                if v31 then
                    v31.Destroy()
                end
            end
            local v_u_32 = v_u_24.Finisher(v26, p_u_23)
            local v_u_33 = {
                ["Name"] = v_u_29,
                ["Destroy"] = function() -- name: Destroy
                    -- upvalues: (ref) v_u_6, (copy) v_u_29, (copy) v_u_32
                    v_u_6[v_u_29] = nil
                    v_u_32.Destroy()
                end
            }
            v_u_6[v_u_29] = v_u_32
            local v34 = v_u_5
            table.insert(v34, v_u_33)
            v_u_32.OnDestroy:Once(function()
                -- upvalues: (ref) v_u_5, (copy) v_u_33
                local v35 = table.find(v_u_5, v_u_33)
                if v35 then
                    table.remove(v_u_5, v35)
                end
            end)
        end)
        if not v36 then
            warn((("Failed to execute finisher \"%*\": %*"):format(p_u_23.Finisher, v37)))
        end
    end
end
for _, v38 in Players:GetPlayers() do
    v_u_8[v38.UserId] = v38.Name
end
Players.PlayerAdded:Connect(function(p39)
    -- upvalues: (copy) v_u_8
    v_u_8[p39.UserId] = p39.Name
end)
for _, v40 in ipairs(ReplicatedStorage.Database.Custom.Finishers:GetChildren()) do
    if v40:IsA("ModuleScript") then
        v_u_7[v40.Name] = require(v40)
    end
end
return v_u_1
