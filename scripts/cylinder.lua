local editor = require("quickedit:build/mainBuild")
local container = require('quickedit:utils/container')

local clck, start_pos = 0, { }

function on_broken(x, y, z, playerid)
    clck, start_pos = 0, { }
end

function on_placed(x, y, z, playerid)

	if clck == 0 then 
		clck, start_pos = 1,{x, y, z}
	else
		editor.cylinder(
			start_pos,
			{x, y, z},
			container:get_bag()
		)
		clck, start_pos = 0, { }
	end

end

