local edt = require("quickedit:editor")

local put_block_line = 0
local start_pos = {0, 0, 0}


function on_broken(x,y,z)
    put_block_line = 0
    start_pos = {0, 0, 0}
end

function on_placed(x,y,z)
    if put_block_line == 0 then 
        put_block_line = 1
        start_pos = {x, y, z}
    else 
        editor.linespace(
            start_pos,
            {x, y, z},
            get_block(x,y-1,z)
        )

        put_block_line = 0 
        start_pos = {0, 0, 0}
    end
        
end