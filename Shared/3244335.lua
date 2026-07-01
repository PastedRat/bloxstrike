-- Decompiled with Medal

local v1 = {}
local function v_u_16(p_u_2, p_u_3) -- name: newSpriteSheet
    local v_u_15 = {
        ["totalCells"] = #p_u_2,
        ["instance"] = p_u_3,
        ["_frames"] = p_u_2,
        ["display"] = function(p4) -- name: display
            -- upvalues: (copy) p_u_2, (copy) p_u_3, (copy) v_u_15
            if not p_u_2[p4] then
                error((("index %* out of range in spritesheet"):format(p4)))
            end
            local v5 = p_u_2[p4]
            if p_u_3.Image ~= v5.url then
                p_u_3.Image = v5.url
            end
            local ImageRectSize = p_u_3.ImageRectSize
            local size = v5.size
            local v8
            if ImageRectSize.X ^ 2 == size.X ^ 2 then
                v8 = ImageRectSize.Y ^ 2 == size.Y ^ 2
            else
                v8 = false
            end
            if not v8 then
                p_u_3.ImageRectSize = v5.size
            end
            local v9 = p_u_3
            local new = Vector2.new
            local v11
            if v_u_15.isMirroredX() then
                v11 = v5.offset.X - p_u_3.ImageRectSize.X
            else
                v11 = v5.offset.X
            end
            local v12
            if v_u_15.isMirroredY() then
                v12 = v5.offset.Y - p_u_3.ImageRectSize.Y
            else
                v12 = v5.offset.Y
            end
            v9.ImageRectOffset = new(v11, v12)
            v_u_15.currentCell = p4
        end,
        ["flip"] = function() -- name: flip
            -- upvalues: (copy) v_u_15
            v_u_15.mirrorX()
        end,
        ["mirrorX"] = function() -- name: mirrorX
            -- upvalues: (copy) p_u_3, (copy) v_u_15
            p_u_3.ImageRectSize = p_u_3.ImageRectSize * Vector2.new(-1, 1)
            v_u_15.display(v_u_15.currentCell)
        end,
        ["mirrorY"] = function() -- name: mirrorY
            -- upvalues: (copy) p_u_3, (copy) v_u_15
            p_u_3.ImageRectSize = p_u_3.ImageRectSize * Vector2.new(1, -1)
            v_u_15.display(v_u_15.currentCell)
        end,
        ["isFlipped"] = function() -- name: isFlipped
            -- upvalues: (copy) v_u_15
            v_u_15.isMirroredX()
        end,
        ["isMirroredX"] = function() -- name: isMirroredX
            -- upvalues: (copy) p_u_3
            return p_u_3.ImageRectSize.X < 0
        end,
        ["isMirroredY"] = function() -- name: isMirroredY
            -- upvalues: (copy) p_u_3
            return p_u_3.ImageRectSize.Y < 0
        end,
        ["extend"] = function(p13) -- name: extend
            -- upvalues: (copy) p_u_2, (copy) v_u_15
            for _, v14 in p13._frames do
                p_u_2[#p_u_2 + 1] = v14
            end
            v_u_15.totalCells = #p_u_2
        end,
        ["length"] = function() -- name: length
            -- upvalues: (copy) p_u_2
            return #p_u_2
        end
    }
    v_u_15.display(1)
    return v_u_15
end
function v1.new(p17, p18, p19, p20) -- name: new
    -- upvalues: (copy) v_u_16
    local v21 = p17:IsA("ImageLabel")
    assert(v21, "Instance must be an ImageLabel")
    local v22 = p19 / p20
    local v23 = v22.X
    local v24 = math.floor(v23)
    local v25 = v22.Y
    local v26 = math.floor(v25)
    p17.Image = p18
    p17.ImageRectSize = p20
    p17.ImageRectOffset = Vector2.zero
    local v27 = 0
    local v28 = {}
    while true do
        local v29 = 0
        repeat
            v28[v27 * v24 + v29 + 1] = {
                ["offset"] = Vector2.new(p20.X * v29, p20.Y * v27),
                ["url"] = p18,
                ["size"] = p20
            }
            v29 = v29 + 1
        until v24 <= v29
        v27 = v27 + 1
        if v26 <= v27 then
            return v_u_16(v28, p17)
        end
    end
end
return v1
