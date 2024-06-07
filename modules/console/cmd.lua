local editorSession = require("quickedit:editor_session")
local preBuild = require("quickedit:build/preBuild")
local container = require("quickedit:utils/container")
local containerBlocks = require("quickedit:container/blocks")
local trash = {}



console.add_command(
    "q.pos1",
    "set <pos1>",
    function (args, kwargs)
        local x, y, z = player.get_pos()
        print(x, y, z)
        container:get().pos1 = {x,y,z}
    end
)

console.add_command(
    "q.pos2",
    "set <pos2>",
    function (args, kwargs)
        local x, y, z = player.get_pos()
        print(x, y, z)
        container:get().pos2 = {x, y, z}
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


        if #container:get().pos1 ~= 0 and #container:get().pos2 ~= 0 then

            if command == "del" then

                mainBuild.cuboid(container:get().pos1, container:get().pos2, {0}, true)
                trash = {"del"}

            else
                local func_exist = false
                for key, func in pairs(preBuild) do
                    if key == command then
                        func(container:get().pos1, container:get().pos2, container:get().bag, filled)
                        func_exist = true
                        break
                    end
                end
                if func_exist then
                    return "Done"
                else
                    return "Function is not exist"
                end
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
        container:get().ter_mode = mode[1]
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

