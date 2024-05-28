local bag_info = {}
local container = {}

function container:send_bag(data)
    bag_info = data
end

function container:get_bag()
    return bag_info
end


return container