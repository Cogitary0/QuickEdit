local editor = require("quickedit:build/mainBuild")
local container = require('quickedit:utils/container')
local click, start_pos = 0, { }

function on_broken(x,y,z)
    click, start_pos = 0, { }
end


function on_placed(x, y, z)
    
    if click == 0 then
        click = 1
        start_pos = {x, y, z}
    else

        editor.circle(
            start_pos,
            {x, y, z},
            container:get_bag()
        )

        click, start_pos = 0, { }
    end
end