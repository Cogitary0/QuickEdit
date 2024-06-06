local containerBlocksReleaseBuild = {x = nil, y = nil, z = nil, id = nil}
local containerBlocksPreBuild = {x = nil, y = nil, z = nil, id = nil}
local __container__ = { }

function __container__.send(pos1, id_block, form)

    if form == "pre" then
        
        -- containerBlocksPreBuild = {
        --     x = pos1[1], y = pos1[2], z = pos1[3], id = id_block
        -- }

        table.insert(
            containerBlocksPreBuild, {
                x = pos1[1], y = pos1[2], z = pos1[3], id = id_block
            }
        )

    -- elseif form == "release" then

    --     containerBlocksReleaseBuild = {
    --         x = pos2[1], y = pos2[2], z = pos2[3], id = id_block
    --     }

    end

end

function __container__.get(form)

    if form == "pre" then
        
        return containerBlocksPreBuild

    elseif form == "release" then

        return containerBlocksReleaseBuild

    end
    
end

function __container__.remove(form)

    if form == "pre" then
        
        containerBlocksPreBuild = {x = nil, y = nil, z = nil, id = nil}

    elseif form == "release" then

        containerBlocksReleaseBuild = {x = nil, y = nil, z = nil, id = nil}

    end
    
end

return __container__