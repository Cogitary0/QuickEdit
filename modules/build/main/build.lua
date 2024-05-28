-- local vec3 = require("res:vector3")
local tblu       =  require('quickedit:utils/table_utils')
local funcUtils  =  require('quickedit:utils/func_utils')
local pre_build  =  require('quickedit:build/pre/build')

local mainBuild = { 
    HALF_PI = 1.5707963267948966192, -- Pi / 2
    TWO_PI = 6.2831853071795864769, -- 2 * Pi
    EXP = 2.71828182845904523536028747135, -- euler num
    PI = 3.14159265358979323846264338328, -- const pi
    RADIAN = 57.2957795131,
    DEGREE = 0.0174532925199
}


-- main func
function mainBuild.delete( pos1, pos2 )
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


function mainBuild.fill( pos1, pos2, use )
    local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)
    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                local id = use[math.random(1, #use)]
                if block.get(dx, dy, dz) ~= id then 
                    block.set(dx, dy, dz, id) 
                end
            end
        end
    end
	-- block.set(dx,dy+1,dz,0)
end


function mainBuild.linespace( pos1, pos2, use )
    local x0, y0, z0 = unpack( pos1 )
    local x1, y1, z1 = unpack( pos2 )
    local dx = x1 - x0
    local dy = y1 - y0
    local dz = z1 - z0
    local max_dist = math.max(math.abs(dx),math.abs(dy),math.abs(dz))
    local stepX = dx/max_dist
    local stepY = dy/max_dist
    local stepZ = dz/max_dist
    for i = 1, max_dist, 0.1 do
        local id_block = use[math.random(1, #use)]
        block.set(
            x0 + stepX * i, 
            y0 + stepY * i, 
            z0 + stepZ * i,
            id_block,
            get_block_states(
                x0, y0, z0
            )
        )
    end

    block.set(x0, y0, z0,0)
    block.set(x1, y1, z1,0)
end


function mainBuild.cuboid( pos1, pos2, use )
    local x0, y0, z0, x1, y1, z1 = funcUtils.__get_selection_bounds__( pos1, pos2 )
    for dx = x0, x1 do
        for dz = z0, z1 do 
            local id_block = use[math.random(1, #use)]
            block.set(dx, y0, dz, id_block) 
            block.set(dx, y1, dz, id_block) 
        end

        for dy = y0 + 1, y1 - 1 do 
            local id_block = use[math.random(1, #use)]
            block.set(dx, dy, z0, id_block)
            block.set(dx, dy, z1, id_block) 
        end
    end

    for dy = y0 + 1, y1 - 1 do
        for dz = z0 + 1, z1 - 1 do 
            local id_block = use[math.random(1, #use)]
            block.set(x0, dy, dz, id_block) 
            block.set(x1, dy, dz, id_block) 
        end
    end

end


function mainBuild.circle( pos1, pos2, use )

    local radius = funcUtils.__distance__(pos1, pos2)
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local precision = 0.1
    local deltaPhi = 360 - precision

    if math.abs(y1 - y0) < 3 then
        for phi = 0, deltaPhi, precision do
            local id_block = use[math.random(1, #use)]
            local phiRad = phi * mainBuild.RADIAN
            local xx = x0 + radius * math.cos(phiRad)
            local zz = z0 + radius * math.sin(phiRad)
            block.set(
                xx, y0, zz,
                id_block,
                get_block_states(xx, y0, zz))
        end

    elseif math.abs(z1 - z0) > 3 then
        for phi = 0, deltaPhi, precision do
            local id_block = use[math.random(1, #use)]
            local phiRad = phi * mainBuild.RADIAN
            local xx = x0 + radius * math.cos(phiRad)
            local yy = y0 + radius * math.sin(phiRad)
            block.set(
                xx, yy, z0,
                id_block,
                get_block_states(xx, yy, z0))
        end

    elseif math.abs(x1 - x0) > 3 then
        for phi = 0, deltaPhi, precision do
            local id_block = use[math.random(1, #use)]
            local phiRad = phi * mainBuild.RADIAN
            local yy = y0 + radius * math.cos(phiRad)
            local zz = z0 + radius * math.sin(phiRad)
            block.set(
                x0, yy, zz,
                id_block,
                get_block_states(x0, yy, zz))
        end
    end

    block.set(x1, y1, z1, 0, 0)
    block.set(x0, y0, z0, 0)

end



function mainBuild.serp(pos1, pos2, use)
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local radius = funcUtils.__round__(funcUtils.__distance__(pos1, pos2))

    local function divide(x, y, z, r)
        if r <= 1 then
            local id_block = use[math.random(1, #use)]
            block.set(x, y, z, id_block)
        else
            local r2 = r / 2
            divide(x - r2, y, z, r2)
            divide(x + r2, y, z, r2)
            divide(x, y - r2, z, r2)
            divide(x, y + r2, z, r2)
            divide(x, y, z - r2, r2)
            divide(x, y, z + r2, r2)
        end
    end

    divide(x0, y0, z0, radius)
end


function mainBuild.sphere( pos1, pos2, use )
    
    local precision
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local radius = funcUtils.__round__(funcUtils.__distance__(pos1, pos2))

    if radius < 7 then
        precision = 3

    elseif radius >= 7 and radius < 12 then
        precision = 2

    elseif radius > 12 and radius < 18 then
        precision = 1.3

    elseif radius > 18 and radius < 25 then
        precision = 0.8

    else
        precision = 16 / radius^(0.88)
    end

    print(precision, radius)
    
    local delta_theta = 361 - precision
    local delta_phi = 181 - precision

    block.set(x1, y1, z1, 0)
    block.set(x0, y0, z0, 0)
    if #use ~= 0 then

        for theta = 0, delta_theta, precision do
            local theta_rad = theta * mainBuild.RADIAN
        
            for phi = 0, delta_phi, precision do

                local id_block = use[math.random(1, #use)]
                local phi_rad = phi * mainBuild.RADIAN
                local __x = x0 + (radius * math.sin(phi_rad) * math.cos(theta_rad))
                local __y = y0 + (radius * math.sin(phi_rad) * math.sin(theta_rad))
                local __z = z0 + (radius * math.cos(phi_rad))
                
                if block.is_replaceable_at(__x, __y, __z) then 
                    block.set(__x, __y, __z, id_block)
                end

            end

        end

    end


end


function mainBuild.cylinder( pos1, pos2, use )
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local __height = funcUtils.__round__(math.abs(y1 - y0))
    local sign = funcUtils.__sign__(y1 - y0)
    local radius = math.sqrt((x1 - x0)^2 + (z1 - z0)^2)
    local precision = 0.1

    block.set(x1, y1, z1, 0); block.set(x0, y0, z0, 0)
    
    for theta = 0, 360, precision do
        local theta_rad = theta * mainBuild.RADIAN
        for height = 0, __height, 1 do
            local __x = x0 + (radius * math.cos(theta_rad))
            local __z = z0 + (radius * math.sin(theta_rad))
            local __y = y0 + height * sign
            local id_block = use[math.random(1, #use)]
            if not is_solid_at(__x, __y, __z) or is_replaceable_at(__x, __y, __z) then
                block.set(__x, __y, __z, id_block)
            end
        end
    end
end


function mainBuild.replace( pos1, pos2, use, replace)
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    
    x0, y0, z0, x1, y1, z1 = funcUtils.__get_selection_bounds__(pos1, pos2)

    if #use and #replace ~= 0 then
        for dy = y0, y1 do
            for dx = x0, x1 do
                for dz = z0, z1 do
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

        for j = 0, 3, 1 do block.set(x0, y0 + j, z0, 0) end
        
    end
    
end


return mainBuild


