local psm = require("quickedit:utils/pos_manager")

function on_use_on_block(x, y, z)
    if state == false then
        state = true
        psm.change_pos1(x, y, z)
    else
        state = false
        psm.change_pos2(x, y, z)
    end
end