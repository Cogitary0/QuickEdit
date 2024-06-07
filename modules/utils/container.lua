local container = {}

local new_container = {
    pos1 = {},
    pos2 = {},
    bag = {},
    ter_mode = 1
}

function container:send_bag(data)
    new_container.bag = data
end

function container:send_mode(data)
    new_container.ter_mode = data
end

function container:get_mode()
    return new_container.ter_mode
end

function container:get()
    return new_container
end

function container:get_bag()
    if #new_container.bag == 0 then
        return {0}
    else
        return new_container.bag
    end
end


return container