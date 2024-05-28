local editor = require("quickedit:editor_session")
local container = require('quickedit:utils/container')

local clck = 0
local start_pos = { }


function on_broken(x, y, z)
	clck, start_pos = 0, { }
end

   
function on_placed(x, y, z) 
	
	if clck == 0 then 
		clck, start_pos = 1, {x, y, z}

    else
		editor.sphere(start_pos, {x, y, z}, container:get_bag())
		clck, start_pos = 0, { }
	end

end
    