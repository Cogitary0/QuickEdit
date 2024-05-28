local editor = require("quickedit:editor_session")
local container = require('quickedit:utils/container')

local put_block_line = 0
local start_pos = { }

function on_broken(x, y, z)
    put_block_line = 0
    start_pos = { }
end

function on_placed(x, y, z)

    if put_block_line == 0 then 
        put_block_line = 1
        start_pos = {x, y, z}
        
    else 
        editor.linespace(
            start_pos,
            {x, y, z},
            container:get_bag()
        )

        put_block_line = 0 
        start_pos = { }
    end
        
end
