local container = require('quickedit:utils/container')
local bag_inventory = {}

function on_use_on_block(x, y, z, playerid)
    bag_inventory[#bag_inventory + 1] = get_block(x, y, z)
    container:send_bag(bag_inventory)
end

function on_block_break_by(x, y, z, playerid)
    bag_inventory = {}
    container:send_bag({})
end