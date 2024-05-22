local edt = require("quickedit:editor")
local click_replace, start_pos = 0, {0, 0, 0}

function on_broken(x,y,z)
    click_replace, stark_pos = 0, {0, 0, 0}
end

function on_placed(x, y, z)
    if click_replace == 0 then click_replace, stark_pos = 1, {x, y, z} 
    else 
        editor.replace(
            stark_pos,
            {x, y, z}
        )
        stark_pos = {0, 0, 0}
        click_replace = 0
    end
end



