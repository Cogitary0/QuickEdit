local editor = require("quickedit:editor")
local container = require 'quickedit:container'

local click_create_cuboid = 0
local start_pos_create = {0, 0, 0}

function on_broken(x,y,z)
    click_create_cuboid = 0
    start_pos_create = {0, 0, 0}
end

function on_placed(x, y, z)
    if click_create_cuboid == 0 then 
        click_create_cuboid = 1
        start_pos_create = {x, y, z}
    else 
        editor.cuboid(
            start_pos_create,  
            {x, y, z},
            container:get_bag()
        )
        click_create_cuboid = 0
        start_pos_create = {0, 0, 0}
    end
end
