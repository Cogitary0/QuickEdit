local module = {}
local PosManager = require 'quickedit:utils/pos_manager'

--Поворот схемы
function module.rotate_standart(meownatic)
    local x = meownatic.x
    local z = meownatic.z

    -- Поворот на 90 градусов
    meownatic.x = -z
    meownatic.z = x

    local state = meownatic.state.rotation

    if state == 3 then
        state = 0
    elseif state == 0 then
        state = 1
    elseif state == 1 then
        state = 2
    elseif state == 2 then
        state = 3
    end
    meownatic.state.rotation = state
    return meownatic
end

function module.delete_air(meownatic, setair)
    local del = {}
    if setair == false then
        for i = 1, #meownatic do
            if meownatic[i].id == 'core:air' then
                table.insert(del, i)
            end
        end

        for i = 1, #del do
            table.remove(meownatic, del[i])
        end
        return meownatic
    else
        return meownatic
    end
end

function module.materials(meownatic)
    local count = {}
    for _, materials in pairs(meownatic) do
        local id = materials.id
        count[id] = (count[id] or 0) + 1
    end

    local sorted_count = {}
    for id, count_value in pairs(count) do
        table.insert(sorted_count, { id = id, count = count_value })
    end
    table.sort(sorted_count, function(a, b)
        if a.count == b.count then
            return a.id < b.id
        else
            return a.count > b.count
        end
    end)

    return sorted_count
end

function module.upmeow(meownatic)
    local max_y = PosManager.max_y(meownatic)
    for i = 1, #meownatic do
        local y = meownatic[i].y
        local state = meownatic[i].state.rotation
        
        if state == 5 then
            meownatic[i].state.rotation = 4
        elseif state == 4 then
            meownatic[i].state.rotation = 5
        end

        meownatic[i].y = -y + max_y
    end
    return meownatic
end

function module.mirroring(meownatic)
    max_x = PosManager.max_x(meownatic)
    min_x = PosManager.min_x(meownatic)
    max_z = PosManager.max_z(meownatic)
    min_z = PosManager.min_z(meownatic)

    dX = math.abs(max_x) + math.abs(min_x)
    dZ = math.abs(max_z) + math.abs(min_z)
    if dX <= dZ then
        for i = 1, #meownatic do
            local x = meownatic[i].x
            local state = meownatic[i].state.rotation
            meownatic[i].x = -x + max_x
            if state == 3 then
                state = 1
            elseif state == 0 then
                state = 2
            elseif state == 1 then
                state = 3
            elseif state == 2 then
                state = 0
            end
            meownatic[i].state.rotation = state
        end
    else
        for i = 1, #meownatic do
            local z = meownatic[i].z
            local state = meownatic[i].state.rotation
            meownatic[i].z = -z + max_z
            if state == 3 then
                state = 1
            elseif state == 0 then
                state = 2
            elseif state == 1 then
                state = 3
            elseif state == 2 then
                state = 0
            end
            meownatic[i].state.rotation = state
        end
    end
    return meownatic
end


return module