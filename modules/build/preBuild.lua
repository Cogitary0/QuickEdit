local mainBuild = require("quickedit:build/mainBuild")
local funcUtils = require("quickedit:utils/func_utils")
local container = require("quickedit:utils/container")
local containerBlocksClass = require("quickedit:container/blocks")
local preBuild = {}


-- main func
function preBuild.preDelete(pos1, pos2, containerBlocks) 
    local ID_PRE_BUILD_BLOCK = block.index("quickedit:prebuildblock")
    local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)
    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                containerBlocks:add(dx,dy,dz,block.get(dx,dy,dz))
                block.set(dx, dy, dz, ID_PRE_BUILD_BLOCK)
            end
        end
    end
end


function preBuild.undo(containerBlocks)
    
    -- получение коордов 
    local x0, y0, z0 = containerBlocks:get(1).x, containerBlocks:get(1).y, containerBlocks:get(1).z

    -- local xn, yn, zn = containerBlocks:get(#containerBlocks:size())
    print(x0, y0, z0, containerBlocks:size())
end


-- function preBuild.scaffold(pos1, pos2, containerBlocks)
--     local ID_PRE_BUILD_BLOCK = block.index("quickedit:prebuildblock")
--     local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)
--     for dy = minY, maxY, 1 do
--         for dz = minZ, maxZ, 1 do
--             for dx = minX, maxX, 1 do
--                 containerBlocks:add(dx,dy,dz,block.get(dx,dy,dz))
--                 block.set(dx, dy, dz, ID_PRE_BUILD_BLOCK)
--             end
--         end
--     end
--     containerBlocks:printAll()
-- end


function preBuild.preLinespace(pos1, pos2, use)

end


function preBuild.cuboid(pos1, pos2, use, filled)
    print('TEST')
end


function preBuild.circle(pos1, pos2, use)
--
end


function preBuild.serp(pos1, pos2, use)
  --
end


function preBuild.sphere(pos1, pos2, use, filled)
--
end


function preBuild.cylinder(pos1, pos2, use, filled)
--
end


function preBuild.replace(pos1, pos2, use, replace)
 --
end


return preBuild


