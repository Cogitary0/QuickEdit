local editorSession = require("quickedit:editor_session")
local preBuild = require("quickedit:build/preBuild")
local container = require("quickedit:utils/container")
local const = require("quickedit:constants")
local __container__ = require("quickedit:container/blocks")
local __session__ = require("quickedit:container/session") 
local ssn = __session__.new()


console.add_command(
    "q.pos1",
    "set pos1",
    function ()
        local x, y, z = player.get_pos()
        print("pos1 set")
        container:get().pos1 = {x,y,z}
    end
)


console.add_command(
    "q.pos2",
    "set pos2",
    function ()
        local x, y, z = player.get_pos()
        print("pos2 set")
        container:get().pos2 = {x, y, z}
    end
)


console.add_command(
    "q.build",
    "build",
    function()
        
        local cont = unpack(ssn:get(ssn:size()))
    
        for index = 1, #cont, 1 do

            local id_block = container:get_bag()[math.random(1, #container:get_bag())] 
            
            local elements = cont[index]
            block.set(
                elements.x, 
                elements.y, 
                elements.z, 
                id_block
            )
    
        end
    
        ssn:remove(ssn:size())

    end
)


console.add_command(
    "q.undo",
    "reset preBuild",
    function()

        if ssn:size() > 0 then

            editorSession.undo(ssn)

        end

    end
)


console.add_command(
    "q.set command:str filled:str=true",
    "set <pos1> && <pos2>",

    function (args, kwargs)

        local command, filled = unpack(args)

        if #container:get().pos1 ~= 0 and #container:get().pos2 ~= 0 then

            for key, func in pairs(editorSession) do

                if key == command then
                    local cont = __container__.new()

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
    function(arg)
        local mode = arg[1]
        container:get().ter_mode = mode
        return 'mode: ' .. mode .. " " .. const.MODES[mode]
    end
)


console.add_command(
    "q.bag",
    "give terraformer",
    function()
        inventory.add(0, item.index('quickedit:bag'), 1)
    end
)


console.add_command(
    "q.bag.info",
    "Display bag",
    function()
        local text = 'INFO:\n'
        for idx, value in pairs(container:get().bag) do
            text = text .. idx .. '. ' .. block.name(value) .. '\n'
        end
        return text
    end
)

