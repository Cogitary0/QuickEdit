local editor = require("quickedit:editor_session")
local container = require('quickedit:utils/container')

local click_fill = 0
local start_pos = { }

function on_broken(x, y, z, playerid)

    click_fill = 0
    start_pos = { }

end

function on_placed(x, y, z, playerid)
   
    if click_fill == 0 then
        
        click_fill = 1
        start_pos = {x, y, z}
    else

		editor.fill(
            start_pos, 
            {x, y, z}, 
            container:get_bag()
        ) 
		
        click_fill = 0
        start_pos = { }
        
	end
end













