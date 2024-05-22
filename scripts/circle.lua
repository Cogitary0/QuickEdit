--dofile("res/content/voxelhelp/vox_math.lua")
local edt = require("quickedit:editor")
local click, start_pos = 0, {0, 0, 0}

function on_broken(x,y,z)
    click, start_pos = 0, {0, 0, 0}
end


function on_placed(x, y, z)
    
    if click == 0 then
        click = 1
        start_pos = {x, y, z}
    else

        editor.circle(
            start_pos,
            {x, y, z},
            get_block(x, y - 1, z)
        )

        click, start_pos = 0, {0, 0, 0}
    end
end