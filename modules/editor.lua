-- local vec3 = require("res:vector3")
local tblu = require 'quickedit:utils/table_utils'
local funcUtils = require 'quickedit:utils/func_utils'

local editor = { 
    HALF_PI = 1.5707963267948966192, -- Pi / 2
    TWO_PI = 6.2831853071795864769, -- 2 * Pi
    EXP = 2.71828182845904523536028747135, -- euler num
    PI = 3.14159265358979323846264338328, -- const pi
    RADIAN = 57.2957795131,
    DEGREE = 0.0174532925199
}

-- main func
function editor.delete( pos1, pos2 )
    local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)
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

function editor.fill( pos1, pos2, use )
    local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)
    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                local id = use[math.random(1, #use)]
                if get_block(dx, dy, dz) ~= id then 
                    block.set(dx, dy, dz, id) 
                end
            end
        end
    end
end


function editor.linespace( pos1, pos2, use )
    local __x0, __y0, __z0 = unpack( pos1 )
    local __x1, __y1, __z1 = unpack( pos2 )
    local dx = __x1 - __x0
    local dy = __y1 - __y0
    local dz = __z1 - __z0
    local max_dist = math.max(math.abs(dx),math.abs(dy),math.abs(dz))
    local stepX = dx/max_dist
    local stepY = dy/max_dist
    local stepZ = dz/max_dist
    for i = 1, max_dist, 0.1 do
        local id_block = use[math.random(1, #use)]
        block.set(
            __x0 + stepX * i, 
            __y0 + stepY * i, 
            __z0 + stepZ * i,
            id_block,
            get_block_states(
                __x0, __y0, __z0
            )
        )
    end

    block.set(__x0, __y0, __z0,0)
    block.set(__x1, __y1, __z1,0)
end

function editor.cuboid( pos1, pos2, use )
    local __x0, __y0, __z0, __x1, __y1, __z1 = funcUtils.__get_selection_bounds__( pos1, pos2 )
    for dx = __x0, __x1 do
        for dz = __z0, __z1 do 
            local id_block = use[math.random(1, #use)]
            block.set(dx, __y0, dz, id_block) 
            block.set(dx, __y1, dz, id_block) 
        end

        for dy = __y0 + 1, __y1 - 1 do 
            local id_block = use[math.random(1, #use)]
            block.set(dx, dy, __z0, id_block)
            block.set(dx, dy, __z1, id_block) 
        end
    end

    for dy = __y0 + 1, __y1 - 1 do
        for dz = __z0 + 1, __z1 - 1 do 
            local id_block = use[math.random(1, #use)]
            block.set(__x0, dy, dz, id_block) 
            block.set(__x1, dy, dz, id_block) 
        end
    end

end

function editor.circle( pos1, pos2, use )
    
    local radius = funcUtils.__distance__(pos1, pos2)
    local __x, __y, __z = unpack(pos1)
    local __x1, __y1, __z1 = unpack(pos2)
    local precision = 0.1
    local deltaPhi = 360 - precision

    if math.abs(__y1 - __y) < 3 then
        for phi = 0, deltaPhi, precision do
            local id_block = use[math.random(1, #use)]
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
            local id_block = use[math.random(1, #use)]
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
            local id_block = use[math.random(1, #use)]
            local phiRad = phi * editor.RADIAN
            local yy = __y + radius * math.cos(phiRad)
            local zz = __z + radius * math.sin(phiRad)
            block.set(
                __x, yy, zz, 
                id_block, 
                get_block_states(__x, yy, zz))           
        end
    end

    block.set(__x1, __y1, __z1, 0, 0)
    block.set(__x, __y, __z, 0)

end

function editor.sphere( pos1, pos2, use )
    local __x0, __y0, __z0 = unpack(pos1)
    local __x1, __y1, __z1 = unpack(pos2)
    local radius = funcUtils.__distance__(pos1, pos2)
    local precision = 1
    
    local delta_theta = 360 - precision
    local delta_phi = 180 - precision

    block.set(__x1, __y1, __z1, 0)
    block.set(__x0, __y0, __z0, 0)
    
    for theta = 0, delta_theta, precision do
        local theta_rad = theta * editor.RADIAN
        for phi = 0, delta_phi, precision do
            local id_block = use[math.random(1, #use)]
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


function editor.cylinder( pos1, pos2, use )
    local __x0, __y0, __z0 = unpack(pos1)
    local __x1, __y1, __z1 = unpack(pos2)
    local __height = funcUtils.__round__(math.abs(__y1 - __y0))
    local sign = funcUtils.__sign__(__y1 - __y0)
    local radius = math.sqrt((__x1 - __x0)^2 + (__z1 - __z0)^2)
    local precision = 0.1

    block.set(__x1, __y1, __z1, 0); block.set(__x0, __y0, __z0, 0)
    
    for theta = 0, 360, precision do
        local theta_rad = theta * editor.RADIAN
        for height = 0, __height, 1 do
            local __x = __x0 + (radius * math.cos(theta_rad))
            local __z = __z0 + (radius * math.sin(theta_rad))
            local __y = __y0 + height * sign
            local id_block = use[math.random(1, #use)]
            if not is_solid_at(__x, __y, __z) or is_replaceable_at(__x, __y, __z) then
                block.set(__x, __y, __z, id_block)
            end
        end
    end
end

function editor.replace( pos1, pos2, use, replace)
    local __x0, __y0, __z0 = unpack(pos1)
    local __x1, __y1, __z1 = unpack(pos2)
    
    __x0, __y0, __z0, __x1, __y1, __z1 = funcUtils.__get_selection_bounds__(pos1, pos2)

    if #use and #replace ~= 0 then
        for dy = __y0, __y1 do
            for dx = __x0, __x1 do
                for dz = __z0, __z1 do
                    local indx_block = tblu.find(replace, block.get(dx, dy, dz))
                    if indx_block ~= nil then
                        block.set(
                            dx, dy, dz,
                            use[indx_block]
                        )
                    end
                end
            end
        end

        for j = 0, 3, 1 do block.set(__x0, __y0 + j, __z0, 0) end
        
    end
    
end

return editor


