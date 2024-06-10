local editor = require("quickedit:build/mainBuild")
local container = require("quickedit:utils/container")
--[[
1. Просто рисовалка
2. Шарики делаем
3. Квадратики делаем
4. Наслоение тортиков
5. Вращаем спиннер
6. Replace
7. Smooth
]]--


local function rotate(x, y, z)
    local rotation = block.get_rotation(x, y, z)
    local rotation = rotation + 1
    if rotation > 3 then
        rotation = 0
    end
    block.set_rotation(x, y, z, rotation)
end


function on_use_on_block(x, y, z)
    local mode = container:get_mode()
    local radius = container:get().ter_radius
    if mode == 1 then
        editor.paint({x-radius, y-radius, z-radius}, {x+radius, y+radius, z+radius}, container:get_bag())
    elseif mode == 2 then
        editor.sphere({x-radius, y-radius, z-radius}, {x+radius, y+radius, z+radius}, container:get_bag())
    elseif mode == 3 then
        editor.fill({x-radius, y-radius, z-radius}, {x+radius, y+radius, z+radius}, container:get_bag())
    elseif mode == 5 then
        rotate(x, y, z)
    elseif mode == 6 then
        editor.replace({x-radius, y-radius, z-radius}, {x+radius, y+radius, z+radius}, container:get_bag())
    elseif mode == 7 then
        editor.smooth({x-radius, y-radius, z-radius}, {x+radius, y+radius, z+radius}, radius)
    else
        editor.layering(x, y, z, radius)
    end
end
