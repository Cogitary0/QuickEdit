local editorSession = require("quickedit:editor_session")
local preBuild = require("quickedit:build/preBuild")
local container = require("quickedit:utils/container")
local const = require("quickedit:constants")
local __container__ = require("quickedit:container/blocks")
local __session__ = require("quickedit:container/session") 
local ssn = __session__.new()


console.add_command(
    "q.pos1",
    "Set pos1",
    function ()
        local x, y, z = player.get_pos()
        container:get().pos1 = {x,y,z}
        return "pos1:" .. " " .. "(" .. x .. ", " .. y .. ", " .. z .. ")"
    end
)


console.add_command(
    "q.pos2",
    "Set pos2",
    function ()
        local x, y, z = player.get_pos()
        container:get().pos2 = {x, y, z}
        return "pos2:" .. " " .. "(" .. x .. ", " .. y .. ", " .. z .. ")"
    end
)


console.add_command(
    "q.build",
    "Build",
    function()
        
        if ssn:size() > 0 then
            
            editorSession.build(ssn)

        end

    end
)


console.add_command(
    "q.build.info",
    "Get info about builds",
    function()

        local text = "INFO:\n"
        if ssn:size() > 0 then
            
            for num, containers in ipairs(ssn:getAll()) do
                
                text = "[Amout builds]: " .. num .. ", [All blocks]: " ..  #unpack(containers) .. "\n"

            end

        end

        return text

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
    "q.set command:str filled:str",
    "set <pos1> && <pos2>",

    function (args)

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
    "Give terraformer",
    function()
        inventory.add(0, item.index('quickedit:terraformer'), 1)
    end
)


console.add_command(
    "q.ter.mode mode:int",
    "Change terraformer mode",
    function(arg)
        local mode = arg[1]
        container:get().ter_mode = mode
        return 'mode: (' .. mode .. ") " .. const.MODES[mode]
    end
)


console.add_command(
    "q.bag",
    "Give terraformer",
    function()
        inventory.add(0, item.index('quickedit:bag'), 1)
    end
)


console.add_command(
    "q.bag.add id_block:int",
    "Add block in bag",
    function(arg)

        local id_block = arg[1]
        table.insert(container:get().bag, id_block)
        return "Add block: " .. block.name(id_block)

    end
)


console.add_command(
    "q.bag.del position:int",
    "Delete block by postion",
    function(pos)
    
        local postionBlock = pos[1]
        local del_block = container:get().bag[postionBlock]
        table.remove(container:get().bag, postionBlock)
        return "Del block: " .. del_block
    
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

