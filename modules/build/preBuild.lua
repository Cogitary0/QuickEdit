local mainBuild = require("quickedit:build/mainBuild")
local funcUtils = require("quickedit:utils/func_utils")
local container = require("quickedit:utils/container")
local containerBlocksClass = require("quickedit:container/blocks")
local sessionContainerBlocksClass = require("quickedit:container/session")
local preBuild = {}


-- main func
-- function preBuild.preDelete(pos1, pos2, containerBlocks, session) 
    
--     local ID_PRE_BUILD_BLOCK = block.index("quickedit:prebuildblock")
--     local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)
    
--     for dy = minY, maxY, 1 do
--         for dz = minZ, maxZ, 1 do
--             for dx = minX, maxX, 1 do
--                 if is_solid_at(dx, dy, dz) or block.get(dx, dy, dz) ~= ID_NULL_BLOCK then
--                     containerBlocks:add(dx,dy,dz,block.get(dx,dy,dz))
--                     block.set(dx, dy, dz, ID_PRE_BUILD_BLOCK)
--                 end
--             end
--         end
--     end
--     session:add(containerBlocks:getAll())
-- end


function preBuild.undo(session)

    local cont = unpack(session:get(session:size()))
    
    for index = 1, #cont, 1 do
        
        local elements = cont[index]
        block.set(elements.x, elements.y, elements.z, elements.id)

    end

    session:remove(session:size())
end


function preBuild.preLinespace(pos1, pos2, filled, containerBlocks, session)

    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local dx = x1 - x0
    local dy = y1 - y0
    local dz = z1 - z0
    local max_dist = math.max(math.abs(dx),math.abs(dy),math.abs(dz))
    local stepX = dx/max_dist
    local stepY = dy/max_dist
    local stepZ = dz/max_dist
    local precision = 1
    local id_block = block.index("quickedit:prebuildblock")

    for i = 1, max_dist, precision do

        local __x = x0 + stepX * i
        local __y = y0 + stepY * i
        local __z = z0 + stepZ * i
        
        -- if block.is_replaceable_at(__x, __y, __z) or block.get(__x, __y, __z) ~= id_block then

        containerBlocks:add(__x, __y, __z, block.get(__x, __y, __z))
        block.set(__x, __y, __z,id_block)

        -- end

    end
    session:add(containerBlocks:getAll())

    -- containerBlocks:add(x1, y1, z1, block.get(x1, y1, z1))
    -- block.set(x0, y0, z0, 0)
    -- block.set(x1, y1, z1, 0)
end


function preBuild.preCuboid(pos1, pos2, filled, containerBlocks, session)
    local id_block = block.index("quickedit:prebuildblock")
    local x0, y0, z0, x1, y1, z1 = funcUtils.__get_selection_bounds__( pos1, pos2 )

    if not filled then
        for dx = x0, x1 do
            for dz = z0, z1 do
                containerBlocks:add(dx,y0,dz, block.get(dx,y0,dz))
                containerBlocks:add(dx,y1,dz, block.get(dx,y1,dz))
                block.set(dx, y0, dz, id_block)
                block.set(dx, y1, dz, id_block)
            end

            for dy = y0 + 1, y1 - 1 do
                containerBlocks:add(dx,y1,z0, block.get(dx,y1,z0))
                containerBlocks:add(dx,y1,z1, block.get(dx,y1,z1))
                block.set(dx, dy, z0, id_block)
                block.set(dx, dy, z1, id_block)
            end
        end

        for dy = y0 + 1, y1 - 1 do
            for dz = z0 + 1, z1 - 1 do
                containerBlocks:add(x0,y1,dz, block.get(x1,y1,dz))
                containerBlocks:add(x1,y1,dz, block.get(x0,y1,dz))
                block.set(x0, dy, dz, id_block)
                block.set(x1, dy, dz, id_block)
            end
        end

    else

        local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)

        for dy = minY, maxY, 1 do
            for dz = minZ, maxZ, 1 do
                for dx = minX, maxX, 1 do
                    containerBlocks:add(dx,dy,dz, block.get(dx,dy,dz))
                    block.set(dx, dy, dz, id_block)
                end
            end
        end

    end
    session:add(containerBlocks:getAll())
end


function preBuild.circle(pos1, pos2, filled, containerBlocks, sessio)
    local id_block = block.index("quickedit:prebuildblock")
    local radius = funcUtils.__distance__(pos1, pos2)
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local precision = 0.1
    local deltaPhi = 360 - precision

    if math.abs(y1 - y0) < 3 then
        for phi = 0, deltaPhi, precision do

            local phiRad = phi * const.RADIAN
            local __x = x0 + radius * math.cos(phiRad)
            local __z = z0 + radius * math.sin(phiRad)
            containerBlocks:add(__x, y0, __z, block.get(__x, y0, __z))
            block.set(__x, y0, __z,id_block)
        end

    elseif math.abs(z1 - z0) > 3 then
        for phi = 0, deltaPhi, precision do

            local phiRad = phi * const.RADIAN
            local __x = x0 + radius * math.cos(phiRad)
            local __y = y0 + radius * math.sin(phiRad)
            containerBlocks:add(__x, __y, z0, block.get(__x, __y, z0))
            block.set(__x, __y, z0, id_block)
        end

    elseif math.abs(x1 - x0) > 3 then
        for phi = 0, deltaPhi, precision do

            local phiRad = phi * const.RADIAN
            local __y = y0 + radius * math.cos(phiRad)
            local __z = z0 + radius * math.sin(phiRad)
            containerBlocks:add(x0, __y, __z, block.get(x0, __y, __z))
            block.set(x0, __y, __z, id_block)
        end
    end

    session:add(containerBlocks:getAll())
end


function preBuild.serp(pos1, pos2, filled, containerBlocks, sessio)
    mainBuild.serp(pos1, pos2, filled, containerBlocks, sessio)
end


function preBuild.preSphere(pos1, pos2, filled, containerBlocks, session)

    local dx, dy, dz
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local id_block = block.index("quickedit:prebuildblock")
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
                    dx, dy, dz = x + x0, y + y0, z + z0

                    if dist >=radiusSqr2 and dist <= radiusSqr then

                        -- if id_block ~= block.get(dx, dy, dz) then
                        containerBlocks:add(dx, dy, dz, block.get(dx, dy, dz))
                        block.set(dx, dy, dz, id_block)
                        

                        -- end

                        

                    end
                end
            end

        end

    else

        for y = -radius, radius, 1 do
            for x = -radius, radius, 1 do
                for z = -radius, radius, 1 do

                    local dist = x*x + y*y + z*z
                    dx, dy, dz = x + x0, y + y0, z + z0

                    if dist <= radiusSqr  then

                        -- if id_block ~= block.get(dx, dy, dz) then
                        containerBlocks:add(dx, dy, dz, block.get(dx, dy, dz))
                        block.set(dx, dy, dz, id_block)
                        -- end

                        

                    end

                end
            end

        end

    end
    session:add(containerBlocks:getAll())
end

function preBuild.cylinder(pos1, pos2, filled, containerBlocks, sessio)
    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z1 = unpack(pos2)
    local id_block = block.index("quickedit:prebuildblock")

    local dx = x1 - x0
    local dy = y1 - y0
    local dz = z1 - z0
    local __height = funcUtils.__round__(math.abs(dy))
    local __sign = funcUtils.__sign__(dy)

    local radiusSqr = dx*dx + dz*dz
    local radius = radiusSqr^0.5
    local radiusSqrNotFilled = not filled and (radius - 1) * (radius - 1) or nil

    if filled then

        for height = 0, __height, 1 do

            for x = -radius, radius do

                for z = -radius, radius do

                    local dist = x * x + z * z

                    if dist < radiusSqr then

                        containerBlocks:add(x + x0,  y0 + height * __sign, z + z0, block.get(x + x0,  y0 + height * __sign, z + z0))

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

                    if dist > radiusSqrNotFilled and dist < radiusSqr then

                        containerBlocks:add(x + x0,  y0 + height * __sign, z + z0, block.get(x + x0,  y0 + height * __sign, z + z0))

                        if block.get(x + x0,  y0 + height * __sign, z + z0) ~= id_block then

                            block.set(x + x0,  y0 + height * __sign, z + z0, id_block)

                        end
                    end

                end

            end

        end

    end
    session:add(containerBlocks:getAll())
end


return preBuild


