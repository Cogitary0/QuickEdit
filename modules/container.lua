local bag_info = {}
local container = {}

function container:send_bag(data)
    bag_info = data
end

function container:get_bag()
    if #bag_info == 0 then
        return {0}
    else
        return bag_info
    end
end


return container