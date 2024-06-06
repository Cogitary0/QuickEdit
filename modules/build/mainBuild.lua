local tblu = require('quickedit:utils/table_utils')
local funcUtils = require('quickedit:utils/func_utils')
local const = require('quickedit:constants')

local mainBuild = {}

-- future func
function mainBuild.delete(contBlocks)

    
    local lenCB = #contBlocks
    local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(
        {contBlocks[1].x, contBlocks[1].y, contBlocks[1].z}, 
        {contBlocks[lenCB].x, contBlocks[lenCB].y, contBlocks[lenCB].z}
    )
        
    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                if is_solid_at(dx, dy, dz) or block.get(dx, dy, dz) ~= ID_NULL_BLOCK then
                    block.set(dx, dy, dz, 0)
                end
            end
        end
    end
end




-- past func
function mainBuild.linespace(pos1, pos2, use)
    local x0, y0, z0 = unpack( pos1 )
    local x1, y1, z1 = unpack( pos2 )
    local dx = x1 - x0
    local dy = y1 - y0
    local dz = z1 - z0
    local max_dist = math.max(math.abs(dx),math.abs(dy),math.abs(dz))
    local stepX = dx/max_dist
    local stepY = dy/max_dist
    local stepZ = dz/max_dist
    local precision = 1


    for i = 1, max_dist, precision do

        local id_block = use[math.random(1, #use)]

        local __x = x0 + stepX * i
        local __y = y0 + stepY * i
        local __z = z0 + stepZ * i

        if block.is_replaceable_at(__x, __y, __z) or block.get(__x, __y, __z) ~= id_block then

            block.set(__x, __y, __z,id_block)

        end

    end

    block.set(x0, y0, z0, 0)
    block.set(x1, y1, z1, 0)
end


function mainBuild.cuboid(pos1, pos2, use, filled)
    local lenUse = #use
    local x0, y0, z0, x1, y1, z1 = funcUtils.__get_selection_bounds__( pos1, pos2 )

    if not filled then
        for dx = x0, x1 do
            for dz = z0, z1 do
                local id_block = use[math.random(1, lenUse)]
                block.set(dx, y0, dz, id_block)
                block.set(dx, y1, dz, id_block)
            end

            for dy = y0 + 1, y1 - 1 do
                local id_block = use[math.random(1, lenUse)]
                block.set(dx, dy, z0, id_block)
                block.set(dx, dy, z1, id_block)
            end
        end

        for dy = y0 + 1, y1 - 1 do
            for dz = z0 + 1, z1 - 1 do
                local id_block = use[math.random(1, lenUse)]
                block.set(x0, dy, dz, id_block)
                block.set(x1, dy, dz, id_block)
            end
        end

    else

        local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)

        for dy = minY, maxY, 1 do
            for dz = minZ, maxZ, 1 do
                for dx = minX, maxX, 1 do
                    local id_block = use[math.random(1, lenUse)]
                    if block.get(dx, dy, dz) ~= id_block then
                        block.set(dx, dy, dz, id_block)
                    end
                end
            end
        end

    end

end


function mainBuild.circle(pos1, pos2, use)

    local radius = funcUtils.__distance__(pos1, pos2)
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local precision = 0.1
    local deltaPhi = 360 - precision

    if math.abs(y1 - y0) < 3 then
        for phi = 0, deltaPhi, precision do
            local id_block = use[math.random(1, #use)]
            local phiRad = phi * const.RADIAN
            local __x = x0 + radius * math.cos(phiRad)
            local __z = z0 + radius * math.sin(phiRad)
            block.set(
                __x, y0, __z,
                id_block,
                get_block_states(__x, y0, __z)
            )
        end

    elseif math.abs(z1 - z0) > 3 then
        for phi = 0, deltaPhi, precision do
            local id_block = use[math.random(1, #use)]
            local phiRad = phi * const.RADIAN
            local __x = x0 + radius * math.cos(phiRad)
            local __y = y0 + radius * math.sin(phiRad)
            block.set(
                __x, __y, z0,
                id_block,
                get_block_states(__x, __y, z0)
            )
        end

    elseif math.abs(x1 - x0) > 3 then
        for phi = 0, deltaPhi, precision do
            local id_block = use[math.random(1, #use)]
            local phiRad = phi * const.RADIAN
            local __y = y0 + radius * math.cos(phiRad)
            local __z = z0 + radius * math.sin(phiRad)
            block.set(
                x0, __y, __z,
                id_block,
                get_block_states(x0, __y, __z)
            )
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


function mainBuild.sphere(pos1, pos2, use, filled)

    local dx, dy, dz
    local lenUse = #use
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    dx, dy, dz = x1 - x0, y1 - y0, z1 - z0

    if filled == nil then filled = false end
    local radiusSqr = dx * dx + dy * dy + dz * dz
    local radius = math.sqrt(radiusSqr)
    local radiusSqr2 = not filled and (radius-1) * (radius-1) or nil

    block.set(x1, y1, z1, 0)
    block.set(x0, y0, z0, 0)
    dx, dy, dz = nil, nil, nil


    if not filled then

        for x = -radius, radius, 1 do
            for y = -radius, radius, 1 do
                for z = -radius, radius, 1 do

                    local dist = x*x + y*y + z*z
                    local id_block = use[math.random(1, lenUse)]
                    dx, dy, dz = x + x0, y + y0, z + z0

                    if dist >=radiusSqr2 and dist <= radiusSqr then

                        if id_block ~= block.get(dx, dy, dz) then

                            block.set(dx, dy, dz, id_block)

                        end

                    end
                end
            end

        end

    else

        for y = -radius, radius, 1 do
            for x = -radius, radius, 1 do
                for z = -radius, radius, 1 do

                    local dist = x*x + y*y + z*z
                    local id_block = use[math.random(1, lenUse)]
                    dx, dy, dz = x + x0, y + y0, z + z0

                    if dist <= radiusSqr  then

                        if id_block ~= block.get(dx, dy, dz) then

                            block.set(dx, dy, dz, id_block)

                        end

                    end

                end
            end

        end

    end

end


function mainBuild.cylinder(pos1, pos2, use, filled)

    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local lenUse = #use

    local dx = x1 - x0
    local dy = y1 - y0
    local dz = z1 - z0
    local __height = funcUtils.__round__(math.abs(dy))
    local __sign = funcUtils.__sign__(dy)

    local radiusSqr = dx*dx + dz*dz
    local radius = radiusSqr^0.5
    local radiusSqrNotFilled = not filled and (radius - 1) * (radius - 1) or nil

    block.set(x0, y0, z0, 0)
    block.set(x1, y1, z1, 0)

    if filled then

        for height = 0, __height, 1 do

            for x = -radius, radius do

                for z = -radius, radius do

                    local dist = x * x + z * z
                    local id_block = use[math.random(1, lenUse)]

                    if dist < radiusSqr then

                        if block.get(x + x0,  y0 + height * __sign, z + z0) ~= id_block then

                            block.set(x + x0,  y0 + height * __sign, z + z0, id_block)

                        end


                    end

                end

            end

        end

    else

        for height = 0, __height, 1 do

            for x = -radius, radius do

                for z = -radius, radius do

                    local dist = x * x + z * z
                    local id_block = use[math.random(1, lenUse)]

                    if dist > radiusSqrNotFilled and dist < radiusSqr then

                        if block.get(x + x0,  y0 + height * __sign, z + z0) ~= id_block then

                            block.set(x + x0,  y0 + height * __sign, z + z0, id_block)

                        end
                    end

                end

            end

        end

    end


end


function mainBuild.replace(pos1, pos2, use, replace)
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


