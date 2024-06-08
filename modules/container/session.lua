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


function Session:rotate(axis, angle)

    local rad = angle * const.DEGREE
    local sinAngle = math.sin(rad)
    local cosAngle = sinAngle + const.HALF_PI

    if axis == "x" then

        for __, value in ipairs(self.cont) do
            local y = value.y * cosAngle - value.z * sinAngle
            local z = value.y * sinAngle + value.z * cosAngle
            value.y = y
            value.z = z
        end

    elseif axis == "y" then

        for __, value in ipairs(self.cont) do
            local x = value.x * cosAngle + value.z * sinAngle
            local z = -value.x * sinAngle + value.z * cosAngle
            value.x = x
            value.z = z
        end

    elseif axis == "z" then

        for __, value in ipairs(self.cont) do
            local x = value.x * cosAngle - value.y * sinAngle
            local y = value.x * sinAngle + value.y * cosAngle
            value.x = x
            value.y = y
        end

    else
        error("Invalid axis")

    end

end



return Session