local editorSession = require("quickedit:editor_session")
local preBuild = require("quickedit:build/preBuild")
local container = require("quickedit:utils/container")
local containerBlocks = require("quickedit:container/blocks")
local pos1 = {}
local pos2 = {}
local trash = {}



console.add_command(
    "q.pos1",
    "set <pos1>",
    function (args, kwargs)
        local x, y, z = player.get_pos()
        print(x, y, z)
        pos1 = {x,y,z}
    end
)

console.add_command(
    "q.pos2",
    "set <pos2>",
    function (args, kwargs)
        local x, y, z = player.get_pos()
        print(x, y, z)
        pos2 = {x, y, z}
    end
)

console.add_command(
    "q.undo",
    "reset preBuild",
    function()
        preBuild.undo(containerBlocks.get())
        trash = {}
    end
)


console.add_command(
    "q.set command:str filled:str=true",
    "set <pos1> && <pos2>",

    function (args, kwargs)

        local command, filled = unpack(args)
        filled = filled == "true"


        if #pos1 ~= 0 and #pos2 ~= 0 then
            
            if command == "del" then
            
                preBuild.preDelete(pos1, pos2)
                trash = {"del"}
    
            end

        end

    end
)

console.add_command(
    "q.wand",
    "give terraformer",
    function()
        inventory.add(0, item.index('quickedit:terraformer'), 1)
    end
)

console.add_command(
    "q.terraformer.mode mode:int",
    "change terraformer mode",
    function(mode)
        container:send_mode(mode[1])
        return 'mode: ' .. mode[1]
    end
)

-- console.add_command(
--     "q.build",
--     "confirm build",
--     function()
--         if trash == "del" then
--             editorSession.delete(containerBlocks)
--         end
--     end
-- )

