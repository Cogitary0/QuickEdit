local vec3 = require("res:vector3")

editor = { 
    HALF_PI = 1.5707963267948966192, -- Pi / 2
    TWO_PI = 6.2831853071795864769, -- 2 * Pi
    EXP = 2.71828182845904523536028747135, -- euler num
    PI = 3.14159265358979323846264338328, -- const pi
    RADIAN = 57.2957795131,
    DEGREE = 0.0174532925199
}


local __minmax__ = function(pos1, pos2)
    local minX, maxX = math.min(pos1[1],pos2[1]),math.max(pos1[1],pos2[1])
    local minY, maxY = math.min(pos1[2],pos2[2]),math.max(pos1[2],pos2[2])
    local minZ, maxZ = math.min(pos1[3],pos2[3]),math.max(pos1[3],pos2[3])
    return minX, maxX, minY, maxY, minZ, maxZ
end

local __distance__ = function(pos1, pos2)
    local __x0, __y0, __z0 = pos1[1], pos1[2], pos1[3]
    local __x1, __y1, __z1 = pos2[1], pos2[2], pos2[3]
    return ( (__x1 - __x0)^2 + (__y1 - __y0)^2 + (__z1 - __z0)^2 )^0.5
end


local __get_selection_bounds__ = function(start_pos, end_pos)
    local __x0, __y0, __z0 = start_pos[1], start_pos[2], start_pos[3]
    local __x1, __y1, __z1 = end_pos[1], end_pos[2], end_pos[3]
    if __x1 > __x0 then __x1, __x0 = __x0, __x1 end
    if __y1 > __y0 then __y1, __y0 = __y0, __y1 end
    if __z1 > __z0 then __z1, __z0 = __z0, __z1 end
    return __x1, __y1, __z1, __x0, __y0, __z0
end    

local __sign__ = function(value)
    if value == 0 then return 0 end
    return value / math.abs(value)
end

local __round__ = function(value)
    return value >= 0 and math.floor( value + 0.5 ) or math.ceil( value - 0.5 )
end

function editor.delete( pos1, pos2 )
    local minX, maxX, minY, maxY, minZ, maxZ = __minmax__(pos1,pos2)
    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                if is_solid_at(dx, dy, dz) then
                    block.set(dx,dy,dz,0)
                end
            end
        end
    end

end

function editor.fill( pos1, pos2, id )
    local minX, maxX, minY, maxY, minZ, maxZ = __minmax__(pos1,pos2)
    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                if get_block(dx, dy, dz) ~= id then 
                    block.set(dx, dy, dz, id) 
                end
            end
        end
    end
end


function editor.linespace( pos1, pos2, id_block )
    local __x0, __y0, __z0 = pos1[1], pos1[2], pos1[3]
    local __x1, __y1, __z1 = pos2[1], pos2[2], pos2[3]
    local dx = __x1 - __x0
    local dy = __y1 - __y0
    local dz = __z1 - __z0
    local max_dist = math.max(math.abs(dx),math.abs(dy),math.abs(dz))
    local stepX = dx/max_dist
    local stepY = dy/max_dist
    local stepZ = dz/max_dist
    local i = 1
    while (i <= max_dist) do
        block.set(
            __x0 + stepX * i, 
            __y0 + stepY * i, 
            __z0 + stepZ * i,
            id_block,
            get_block_states(
                __x0, __y0, __z0
            )
        )
        i = i + 0.1
    end

    block.set(
        __x0, __y0, __z0,
        id_block,
        get_block_states(
                __x0, __y0, __z0
            )
    )

    block.set(
        __x1, __y1, __z1,
        id_block
    )
end

function editor.cuboid( pos1, pos2, id_block )
    local __x0, __y0, __z0, __x1, __y1, __z1 = __get_selection_bounds__( pos1, pos2 )
    for dx = __x0, __x1 do
        for dz = __z0, __z1 do 
            block.set(dx, __y0, dz, id_block) 
            block.set(dx, __y1, dz, id_block) 
        end

        for dy = __y0 + 1, __y1 - 1 do 
            block.set(dx, dy, __z0, id_block)
            block.set(dx, dy, __z1, id_block) 
        end
    end

    for dy = __y0 + 1, __y1 - 1 do
        for dz = __z0 + 1, __z1 - 1 do 
            block.set(__x0, dy, dz, id_block) 
            block.set(__x1, dy, dz, id_block) 
        end
    end

end

function editor.circle( pos1, pos2, id_block )
    
    local radius = __distance__(pos1, pos2)
    local __x, __y, __z = pos1[1], pos1[2], pos1[3]
    local __x1, __y1, __z1 = pos2[1], pos2[2], pos2[3]
    local precision = 0.1
    local deltaPhi = 360 - precision

    if math.abs(__y1 - __y) < 3 then
        for phi = 0, deltaPhi, precision do
            local phiRad = phi * editor.RADIAN
            local xx = __x + radius * math.cos(phiRad)
            local zz = __z + radius * math.sin(phiRad)
            block.set(
                xx, __y, zz, 
                id_block, 
                get_block_states(xx, __y, zz))           
        end

    elseif math.abs(__z1 - __z) > 3 then
        for phi = 0, deltaPhi, precision do
            local phiRad = phi * editor.RADIAN
            local xx = __x + radius * math.cos(phiRad)
            local yy = __y + radius * math.sin(phiRad)
            block.set(
                xx, yy, __z, 
                id_block, 
                get_block_states(xx, yy, __z))           
        end

    elseif math.abs(__x1 - __x) > 3 then 
        for phi = 0, deltaPhi, precision do
            local phiRad = phi * editor.RADIAN
            local yy = __y + radius * math.cos(phiRad)
            local zz = __z + radius * math.sin(phiRad)
            block.set(
                __x, yy, zz, 
                id_block, 
                get_block_states(__x, yy, zz))           
        end
    end

    block.set(__x1, __y1, __z1, id_block, 0)
    block.set(__x, __y, __z, 0)

end

function editor.sphere( pos1, pos2, id_block )
    local __x0, __y0, __z0 = pos1[1], pos1[2], pos1[3]
    local __x1, __y1, __z1 = pos2[1], pos2[2], pos2[3]
    local radius = __distance__(pos1, pos2)
    local precision = 1
    
    local delta_theta = 360 - precision
    local delta_phi = 180 - precision

    block.set(__x1, __y1, __z1, id_block)
    block.set(__x0, __y0, __z0, 0)
    
    for theta = 0, delta_theta, precision do
        local theta_rad = theta * editor.RADIAN
        for phi = 0, delta_phi, precision do
            local phi_rad = phi * editor.RADIAN
            local __x = __x0 + (radius * math.sin(phi_rad) * math.cos(theta_rad))
            local __y = __y0 + (radius * math.sin(phi_rad) * math.sin(theta_rad))
            local __z = __z0 + (radius * math.cos(phi_rad))
            if not is_solid_at(__x, __y, __z) or is_replaceable_at(__x, __y, __z) then 
                block.set(__x, __y, __z, id_block)
            end
        end
    end
            
end


function editor.cylinder( pos1, pos2, id_block )
    local __x0, __y0, __z0 = pos1[1], pos1[2], pos1[3]
    local __x1, __y1, __z1 = pos2[1], pos2[2], pos2[3]
    local __height = __round__(math.abs(__y1 - __y0))
    local sign = __sign__(__y1 - __y0)
    local radius = math.sqrt((__x1 - __x0)^2 + (__z1 - __z0)^2)
    local precision = 0.1

    block.set(__x1, __y1, __z1, 0); block.set(__x0, __y0, __z0, 0)
    
    for theta = 0, 360, precision do
        local theta_rad = theta * editor.RADIAN
        for height = 0, __height, 1 do
            local __x = __x0 + (radius * math.cos(theta_rad))
            local __z = __z0 + (radius * math.sin(theta_rad))
            local __y = __y0 + height * sign
            
            if not is_solid_at(__x, __y, __z) or is_replaceable_at(__x, __y, __z) then
                block.set(__x, __y, __z, id_block)
            end
        end
    end
end

function editor.replace( pos1, pos2 )
    local __x0, __y0, __z0 = pos1[1], pos1[2], pos1[3]
    local __x1, __y1, __z1 = pos2[1], pos2[2], pos2[3]
    
    -- мне надо заменить этот блок на этот
    local id_need_block = block.get(__x0, __y0 + 2, __z0)
    local id_replace_block = block.get(__x0, __y0 + 1, __z0)

    for i = 0, 3, 1 do block.set(__x0, __y0 + i, __z0, 0) end 
    block.set(__x1, __y1, __z1, 0)
    
    __x0, __y0, __z0, __x1, __y1, __z1 = __get_selection_bounds__(pos1, pos2)

    if id_need_block and id_replace_block ~= 0 then
        repeat
            for dy = __y0, __y1 do
                for dx = __x0, __x1 do
                    for dz = __z0, __z1 do
                        if block.get(dx, dy, dz) == id_replace_block then
                            block.set(
                                dx, dy, dz,
                                id_need_block
                            )
                        end
                    end
                end
            end
        until id_need_block ~= 0 or id_replace_block ~= 0

        for j = 0, 3, 1 do block.set(__x0, __y0 + j, __z0, 0) end
        
    end
    
end

-- function editor.randbox( pos1, pos2, id_block )
--     local __x0, __y0, __z0, __x1, __y1, __z1 = __get_selection_bounds__(pos1, pos2)

--     for i = 1, 255, 1 do
--         local id_block_up = block.get(pos1[1], pos1[2] + i, pos1[3])
--         if id_block_up ~= 0 then id_block[i] = id_block_up
--         elseif #id_block == 0 and id_block_up == 0 then for j = 1, 21, 1 do if_block[j] = math.random(1, 21) end break end
--     end


--     for dz = __z0, __z1 do
--         for dy = __y0, __y1 do
--             for dx = __x0, __x1 do
--                 block.set(
--                     dx, dy, dz,
--                     id_block[math.random(1, #id_block)]
--                 )
--             end
--         end
--     end
-- end


