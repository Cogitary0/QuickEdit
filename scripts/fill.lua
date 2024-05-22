local edt = require("quickedit:editor")

local click_fill = 0
local start_pos = {0, 0, 0}



function on_broken(x, y, z)
    click_fill = 0
    start_pos = {0, 0, 0}
end


function on_placed(x, y, z)
    if click_fill == 0 then
        click_fill = 1
        start_pos = {x, y, z}
    else
        click_fill = 0
        editor.fill(start_pos, {x, y, z}, get_block(x,y-1,z)) 
        start_pos = {0, 0, 0}   
    end
end













