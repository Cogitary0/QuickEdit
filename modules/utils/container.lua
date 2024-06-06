local bag_info = {}
local container = {}
local ter_mode = 1

function container:send_bag(data)
    bag_info = data
end

function container:send_mode(data)
    ter_mode = data
end

function container:get_mode()
    return ter_mode
end

function container:get_bag()
    if #bag_info == 0 then
        return {0}
    else
        return bag_info
    end
end


return container