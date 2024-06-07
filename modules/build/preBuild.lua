local mainBuild = require("quickedit:build/mainBuild")
local funcUtils = require("quickedit:utils/func_utils")
local container = require("quickedit:utils/container")
local containerBlocksClass = require("quickedit:container/blocks")
local sessionContainerBlocksClass = require("quickedit:container/session")
local preBuild = {}


-- main func
function preBuild.preDelete(pos1, pos2, containerBlocks, session) 
    
    local ID_PRE_BUILD_BLOCK = block.index("quickedit:prebuildblock")
    local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)
    
    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                if is_solid_at(dx, dy, dz) or block.get(dx, dy, dz) ~= ID_NULL_BLOCK then
                    containerBlocks:add(dx,dy,dz,block.get(dx,dy,dz))
                    block.set(dx, dy, dz, ID_PRE_BUILD_BLOCK)
                end
            end
        end
    end
    session:add(containerBlocks:getAll())
end


function preBuild.undo(containerBlocks, session)

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


function preBuild.cuboid(pos1, pos2, filled, containerBlocks, sessio)
    mainBuild.cuboid(pos1, pos2, filled, containerBlocks, sessio)
end


function preBuild.circle(pos1, pos2, filled, containerBlocks, sessio)
    mainBuild.circle(pos1, pos2, filled, containerBlocks, sessio)
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
end




return preBuild


