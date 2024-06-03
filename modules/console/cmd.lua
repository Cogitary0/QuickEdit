local pos1 = {}
local pos2 = {}
local editorSession = require("quickedit:editor_session")

-- устанавливаем pos1 && pos2
console.add_command(

    "q command:str", -- cmd
    
    "set <pos1> && <pos2>", -- descriptions cmd

    function (args, kwargs)
        local command = unpack(args)
        local xp, yp, zp = player.get_pos()

        if command == "pos1" then
            print(1)
            
            if #pos1 == 0 then
                
                pos1 = {x = xp, y = yp, z = zp}

            end

            

        elseif command == "pos2" then
            print(2)

            if #pos2 == 0 then
                
                pos2 = {x = xp, y = yp, z = zp}

            end

        elseif command == "fill" then
            print(3)
            print(#pos1, #pos2)
            if #pos1 ~= 0 and #pos2 ~= 0 then
                
                editorSession.fill(pos1, pos2, 11, true)

            end

        end



    end
)

