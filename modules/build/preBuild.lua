local mainBuild = require("quickedit:build/mainBuild")
local funcUtils = require("quickedit:utils/func_utils")
local containerBlocks = require("quickedit:container/blocks")
local container = require("quickedit:utils/container")
local preBuild = {}


-- main func
function preBuild.preDelete(pos1, pos2) 

    local ID_PRE_BUILD_BLOCK = block.index("quickedit:prebuildblock")
    local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(pos1, pos2)
    local it = 0

    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                
                container:send_bag({
                    dx,dy,dz, block.get(dx,dy,dz)
                })

                block.set(dx, dy, dz, ID_PRE_BUILD_BLOCK)

            end
        end
    end
    print(#container:get_bag())
    print(unpack(container:get_bag()))
end


function mainBuild.undo(contBlocks)
    
    local lenCB = #contBlocks
    local id_block = contBlocks.id
    local minX, maxX, minY, maxY, minZ, maxZ = funcUtils.__minmax__(
        {contBlocks[1].x, contBlocks[1].y, contBlocks[1].z}, 
        {contBlocks[lenCB].x, contBlocks[lenCB].y, contBlocks[lenCB].z}
    )
        
    for dy = minY, maxY, 1 do
        for dz = minZ, maxZ, 1 do
            for dx = minX, maxX, 1 do
                block.set(dx, dy, dz, id_block)
            end
        end
    end
end


-- @TODO
function preBuild.preLinespace(pos1, pos2, use)

end


function preBuild.cuboid(pos1, pos2, use, filled)
--
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