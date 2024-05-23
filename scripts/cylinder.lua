local editor = require("quickedit:editor")
local container = require 'quickedit:container'
local clck, start_pos = 0, {0, 0, 0}

function on_broken(x, y, z)
    clck, start_pos = 0, {0,0,0}
end

function on_placed(x, y, z)
	if clck == 0 then 
		clck, start_pos = 1,{x, y, z}
	else
		editor.cylinder(
			start_pos,
			{x, y, z},
			container:get_bag()
		)
		clck, start_pos = 0, {0, 0, 0}
	end
end

