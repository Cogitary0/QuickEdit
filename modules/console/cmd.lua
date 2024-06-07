local editorSession = require("quickedit:editor_session")
local preBuild = require("quickedit:build/preBuild")
local container = require("quickedit:utils/container")
local __container__ = require("quickedit:container/blocks")
local __session__ = require("quickedit:container/session") 
local cont = __container__.new()
local ssn = __session__.new()



console.add_command(
    "q.pos1",
    "set <pos1>",
    function (args, kwargs)
        local x, y, z = player.get_pos()
        print("pos1 set")
        container:get().pos1 = {x,y,z}
    end
)

console.add_command(
    "q.pos2",
    "set <pos2>",
    function (args, kwargs)
        local x, y, z = player.get_pos()
        print("pos2 set")
        container:get().pos2 = {x, y, z}
    end
)

console.add_command(
    "q.undo",
    "reset preBuild",
    function()

        if ssn:size() > 0 then

            editorSession.undo(cont, ssn)

        end

    end
)


console.add_command(
    "q.set mode:str filled:str=true",
    "set <pos1> && <pos2>",

    function (args, kwargs)

        local mode, filled = unpack(args)
        filled = filled == "true"

        if #container:get().pos1 ~= 0 and #container:get().pos2 ~= 0 then

            for key, func in pairs(editorSession) do

                if key == command then

                    func(
                        container:get().pos1, 
                        container:get().pos2, 
                        filled, 
                        cont,
                        ssn
                    )

                    break

                end

            end
        end
    end
)

console.add_command(
    "q.ter",
    "give terraformer",
    function()
        inventory.add(0, item.index('quickedit:terraformer'), 1)
    end
)

console.add_command(
    "q.ter.mode mode:int",
    "change terraformer mode",
    function(mode)
        container:get().ter_mode = mode[1]
        return 'mode: ' .. mode[1]
    end
)

console.add_command(
    "q.link",
    "",
    function()
        ssn:print()
    end
)

