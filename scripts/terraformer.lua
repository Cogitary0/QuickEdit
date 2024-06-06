local editor = require("quickedit:build/mainBuild")
local container = require 'quickedit:container'

local mode = 2
--1. Просто рисовалка
--2. Шарики делаем
--3. Квадратики делаем
--4. Наслоение тортиков

function on_use_on_block(x, y, z)
    if mode == 1 then
        editor.fill({x-1, y-1, z-1}, {x+1, y+1, z+1}, container:get_bag(), 0)
        elseif mode == 2 then
            editor.sphere({x-1, y-1, z-1}, {x+1, y+1, z+1}, container:get_bag() )
        elseif mode == 3 then
            editor.fill({x-1, y-1, z-1}, {x+1, y+1, z+1}, container:get_bag())
        elseif mode == 4 then
            editor.layering(x, y, z)
    end
end