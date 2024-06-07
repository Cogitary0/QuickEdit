Container = {}
Container.__index = Container

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


return Container