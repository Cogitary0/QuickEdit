local editorSession = require("quickedit:editor_session")
local preBuild = require("quickedit:build/preBuild")
local psm = require("quickedit:utils/pos_manager")
local container = require("quickedit:utils/container")
local const = require("quickedit:constants")
local __container__ = require("quickedit:container/blocks")
local __session__ = require("quickedit:container/session") 
local ssn = __session__.new()

local function split_string(inp)
    local words = {}

    for word in inp:gmatch("%S+") do
        table.insert(words, word)
    end

    return words
end

console.add_command(
    "q.pos1",
    "Set pos1",
    function ()
        local x, y, z = player.get_pos() 
        x, y, z = math.floor( x ), math.floor( y ), math.floor( z )
        psm.change_pos1(x, y, z)
        return "[QE]\t pos1:" .. " " .. "(" .. x .. ", " .. y .. ", " .. z .. ")"
    end
)


console.add_command(
    "q.pos2",
    "Set pos2",
    function ()
        local x, y, z = player.get_pos()
        x, y, z = math.floor( x ), math.floor( y ), math.floor( z )
        psm.change_pos2(x, y, z)
        return "[QE]\t pos2:" .. " " .. "(" .. x .. ", " .. y .. ", " .. z .. ")"
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
    "q.set command:str",
    "set <pos1> && <pos2>",

    function (args)

        local command, filled = split_string(args[1])[1], split_string(args[1])[2]
        if filled == nil then
            filled = container:get().filled
        else
            filled = filled == 'true'
        end
        print(command)
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

                    return

                end

            end

            return '[QE]\t command not found'

        end

    end
)


console.add_command(
    "q.laser",
    "Give laser",
    function()
        inventory.add(0, item.index('quickedit:laser'), 1)
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
    "q.ter.radius radius:int",
    "Set radius build",
    function(arg)
        local radius = arg[1]
        if radius > 0 then
            container:get().ter_radius = radius
            return "[QE]\t Radius: " .. radius
        else
            return "[QE]\t The radius must be greater than 0"
        end
    end
)


console.add_command(
    "q.ter.mode mode:int",
    "Change terraformer mode",
    function(arg)
        local mode = arg[1]
        if const.MODES[mode] ~= nil then
            container:get().ter_mode = mode
            return '[QE]\t mode: (' .. mode .. ") " .. const.MODES[mode]
        else
            return '[QE]\t mode: (' .. mode .. ') not found'
        end
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
    "q.bag.add id_block:str",
    "Add block in bag",
    function(arg)

        local id_block = arg[1]
        table.insert(container:get().bag, block.index(id_block))
        if block.index(id_block) > -1 and block.index(id_block) <= block.defs_count() then
            return "[QE]\t Add block: " .. block.name(id_block)
        else
            return '[QE]\t block: (' .. id_block .. ') was not found'
        end
    end
)


console.add_command(
    "q.bag.del position:int",
    "Delete block by postion",
    function(pos)
    
        local postionBlock = pos[1]
        local del_block = container:get().bag[postionBlock]
        if del_block ~= nil then
            table.remove(container:get().bag, postionBlock)
            return "[QE]\t Del block: " .. del_block
        else
            return '[QE]\t block: (' .. postionBlock .. ') was not found'
        end
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

