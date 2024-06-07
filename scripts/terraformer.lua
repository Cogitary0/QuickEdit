local editor = require("quickedit:build/mainBuild")
local container = require("quickedit:utils/container")
local state = false
--1. Просто рисовалка
--2. Шарики делаем
--3. Квадратики делаем
--4. Наслоение тортиков

function on_use_on_block(x, y, z)
    local mode = container:get_mode()
    if mode == 1 then
        editor.cuboid({x-1, y-1, z-1}, {x+1, y+1, z+1}, container:get_bag(), true, 0)
        elseif mode == 2 then
            editor.sphere({x-1, y-1, z-1}, {x+1, y+1, z+1}, container:get_bag() )
        elseif mode == 3 then
            editor.cuboid({x-1, y-1, z-1}, {x+1, y+1, z+1}, container:get_bag(), true)
        else
            editor.layering(x, y, z)
    end
end

function on_block_break_by(x, y, z)
    if state == false then
        state = true
        container:get().pos1 = {x, y, z}
    else
        state = false
        container:get().pos2 = {x, y, z}
    end
end