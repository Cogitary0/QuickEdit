local Container = {}
local containerBlocks = {}

function Container.send(pos, id, form)
    if form == 'pre' then
      table.insert(containerBlocks, {
          x = pos[1],
          y = pos[2],
          z = pos[3],
          id = id
      })
    end
end

function Container.get()
    return containerBlocks
end

function Container.remove()
    containerBlocks = {}
end

return Container