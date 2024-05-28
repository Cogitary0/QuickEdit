local pre_build = {}

-- пока заготовка на будущее

-- build -> fill, cube, cuboid, ...
function pre_build.__cuboid__(pos1, pos2, distance)
    
    local x0, y0, z0 = math.min(pos1[1], pos2[1]), math.min(pos1[2], pos2[2]), math.min(pos1[3], pos2[3])
    local x1, y1, z1 = math.max(pos1[1], pos2[1]), math.max(pos1[2], pos2[2]), math.max(pos1[3], pos2[3])
    local ID_BLOCK_PRE_BUILD = 0 -- no block (temporary solution)

    -- create edges along the {y} axis
    for dx = x0, x1 do
        if block.is_replaceable_at(dx, y0, z0) then block.set(dx, y0, z0, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(dx, y0, z1) then block.set(dx, y0, z1, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(dx, y1, z0) then block.set(dx, y1, z0, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(dx, y1, z1) then block.set(dx, y1, z1, ID_BLOCK_PRE_BUILD) end
    end

    -- create edges along the {z} axis
    for dy = y0, y1 do
        if block.is_replaceable_at(x0, dy, z0) then block.set(x0, dy, z0, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(x1, dy, z0) then block.set(x1, dy, z0, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(x0, dy, z1) then block.set(x0, dy, z1, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(x1, dy, z1) then block.set(x1, dy, z1, ID_BLOCK_PRE_BUILD) end
    end

    -- create edges along the {x} axis
    for dz = z0, z1 do
        if block.is_replaceable_at(x0, y0, dz) then block.set(x0, y0, dz, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(x1, y0, dz) then block.set(x1, y0, dz, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(x0, y1, dz) then block.set(x0, y1, dz, ID_BLOCK_PRE_BUILD) end
        if block.is_replaceable_at(x1, y1, dz) then block.set(x1, y1, dz, ID_BLOCK_PRE_BUILD) end
    end
end


function pre_build.__sphere__(pos1, pos2, distance)
    local ID_BLOCK_PRE_BUILD = 0 -- no block (temporary solution)
    
    local function circle_gen(cx, cy, cz, radius, precision, id)
        local deltaPhi = 360 - 0.1

        for phi = 0, deltaPhi, 0.1 do
            local phiRad = math.rad(phi)

            local x = cx + radius * math.cos(phiRad)
            local z = cz + radius * math.sin(phiRad)

            if is_replaceable_at(x, cy, z) then block.set(x, cy, z, id, get_block_states(x, cy, z)) end
        end
    end

    local function circle_gen_x(cx, cy, cz, radius, precision, id)
        local deltaPhi = 360 - 0.1

        for phi = 0, deltaPhi, 0.1 do
            local phiRad = math.rad(phi)

            local y = cy + radius * math.cos(phiRad)
            local z = cz + radius * math.sin(phiRad)

            if is_replaceable_at(cx, y, z) then block.set(cx, y, z, id, get_block_states(cx, y, z)) end
        end
    end

    local function circle_gen_y(cx, cy, cz, radius, precision, id)
        local deltaPhi = 360 - 0.1

        for phi = 0, deltaPhi, 0.1 do
            local phiRad = math.rad(phi)

            local x = cx + radius * math.cos(phiRad)
            local z = cz + radius * math.sin(phiRad)

            if is_replaceable_at(x, cy, z) then block.set(x, cy, z, id, get_block_states(x, cy, z)) end
        end
    end

    local function circle_gen_z(cx, cy, cz, radius, precision, id)
        local deltaPhi = 360 - 0.1

        for phi = 0, deltaPhi, 0.1 do
            local phiRad = math.rad(phi)

            local x = cx + radius * math.cos(phiRad)
            local y = cy + radius * math.sin(phiRad)

            if is_replaceable_at(x, y, cz) then block.set(x, y, cz, id, get_block_states(x, y, cz)) end
        end
    end

    local x0, y0, z0 = unpack(pos1)
    local x1, y1, z0 = unpack(pos2)

    circle_gen(x0, y0, z0, distance, 0.1, ID_BLOCK_PRE_BUILD)
    circle_gen_x(x0, y0, z0, distance, 0.1, ID_BLOCK_PRE_BUILD)
    circle_gen_y(x0, y0, z0, distance, 0.1, ID_BLOCK_PRE_BUILD)
    circle_gen_z(x0, y0, z0, distance, 0.1, ID_BLOCK_PRE_BUILD)


end


-- function pre_build_cuboid(pos1, pos2)
-- 	local x0, y0, z0 = unpack(pos1)
-- 	local x1, y1, z1 = unpack(pos2)
-- 	local ID_BLOCK_PRE_BUILD = block.index('quickedit:alpha')
	
-- 	-- movement along the horizont; {y},{z} = const
-- 	for dx = x0, x1 do
-- 		if block.is_replaceable_at(dx,y0,z0) then block.set(dx, y0, z0, ID_BLOCK_PRE_BUILD) end 
--         if block.is_replaceable_at(dx,y0,z1) then block.set(dx, y0, z1, ID_BLOCK_PRE_BUILD) end
--         if block.is_replaceable_at(dx,y1,z0) then block.set(dx, y1, z0, ID_BLOCK_PRE_BUILD) end
--         if block.is_replaceable_at(dx,y1,z1) then block.set(dx, y1, z1, ID_BLOCK_PRE_BUILD) end
--     end

	
-- 	-- movement along the verticals; {x},{z} = const
-- 	for dy = y0, y1 do
--         if block.is_replaceable_at(x0,dy,z0) then block.set(x0, dy, z0, ID_BLOCK_PRE_BUILD) end 
--         if block.is_replaceable_at(x0,dy,z1) then block.set(x0, dy, z1, ID_BLOCK_PRE_BUILD) end
--         if block.is_replaceable_at(x1,dy,z0) then block.set(x1, dy, z0, ID_BLOCK_PRE_BUILD) end
--         if block.is_replaceable_at(x1,dy,z1) then block.set(x1, dy, z1, ID_BLOCK_PRE_BUILD) end
-- 	end
	
-- 	x0, y0, z0 = nil, nil, nil
-- 	x1, y1, z1 = nil, nil, nil
	
-- end


return pre_build