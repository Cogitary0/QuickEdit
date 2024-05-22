local editor = require("quickedit:editor")
local container = require 'quickedit:container'
local click_replace, start_pos = 0, {0, 0, 0}

function on_broken(x,y,z)
    click_replace, stark_pos = 0, {0, 0, 0}
end

function on_placed(x, y, z)
    if click_replace == 0 then click_replace, stark_pos = 1, {x, y, z} 
    else 
        local bag = container:get_bag()
        local use = {}
        local replace = {}
        for i = 1, #bag do
            if i % 2 ~= 0 then table.insert(use, bag[i]) else table.insert(replace, bag[i]) end
        end
        editor.replace(
            stark_pos,
            {x, y, z},
            use,
            replace
        )
        stark_pos = {0, 0, 0}
        click_replace = 0
    end
end



