Container = {}
Container.__index = Container
local const = require("quickedit:constants")

function Container.new()

    local self = setmetatable({}, Container)
    self.cont = {}
    return self

end


function Container:add(x, y, z, id)

    table.insert(self.cont, {
        x = x, y = y, z = z, id = id
    })

end


function Container:size()
    return #self.cont
end


function Container:get(index)
    return self.cont[index]
end


function Container:getAll()
    return self.cont
end


function Container:getCoords(index)
    return self.cont[index].x, self.cont[index].y, self.cont[index].z
end


function Container:getId(index)

    local element = self:get(index)

    if element then
        return element.index
    else
        return nil
    end

end


function Container:clear()

    for i = #self.cont, 1, -1 do
        table.remove(self.cont, i)
    end

end


function Container:printAll()

    for __, value in ipairs(self.cont) do
        print("x: ", value.x, "y: ", value.y, "z: ", value.z, "id: ", value.id)
    end

end


function Container:rotate(axis, angle)

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


return Container