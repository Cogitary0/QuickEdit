Session = {}
Session.__index = Session
local const = require("quickedit:constants")

function Session.new()
    
    local self = setmetatable({}, Session)
    self.__session__ = {}
    return self

end


function Session:get(index) 
    return self.__session__[index] 
end

function Session:getAll() 
    return self.__session__
end

function Session:add(data) 
    table.insert(self.__session__, {data}) 
end


function Session:size() 
    return #self.__session__ 
end


function Session:print()

    for __, value in ipairs(self.__session__) do
        print(value)
    end

end


function Session:remove(index)
    table.remove(self.__session__, index)
end


function Session:clear()
    
    for value = 1, #self.__session__,  1 do
        table.remove(self.__session__, value)
    end

end


return Session