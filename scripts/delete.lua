local edt = require("quickedit:editor")
local click_delete = 0
local start_pos_delete = {0, 0, 0}


function on_broken(x,y,z)
    click_delete = 0
    start_pos_delete = {0, 0, 0}
end


function on_placed(x, y, z)
    if click_delete == 0 then
        click_delete = 1
        start_pos_delete = {x, y, z}
    else
        click_delete = 0
        editor.delete(start_pos_delete, {x, y, z})
        start_pos_delete = {0, 0, 0}
    end
end
