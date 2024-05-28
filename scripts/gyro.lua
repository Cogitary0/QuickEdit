
-- local click = 0
-- local spx, spy, spz = 0 ,0 ,0
-- local function F(x) return 18/(x^(0.8)) end

-- function circle_gen(cx, cy, cz, radius, precision, id)
--     local deltaPhi = 360 - precision

--     for phi = 0, deltaPhi, precision do
--         local phiRad = vox_math.rad(phi)

--         local x = cx + radius * vox_math.cos(phiRad)
--         local z = cz + radius * vox_math.sin(phiRad)

--         set_block(x, cy, z, id, get_block_states(x, cy, z))
--     end
-- end

-- function circle_gen_x(cx, cy, cz, radius, precision, id)
--     local deltaPhi = 360 - precision

--     for phi = 0, deltaPhi, precision do
--         local phiRad = vox_math.rad(phi)

--         local y = cy + radius * vox_math.cos(phiRad)
--         local z = cz + radius * vox_math.sin(phiRad)

--         set_block(cx, y, z, id, get_block_states(cx, y, z))
--     end
-- end

-- function circle_gen_y(cx, cy, cz, radius, precision, id)
--     local deltaPhi = 360 - precision

--     for phi = 0, deltaPhi, precision do
--         local phiRad = vox_math.rad(phi)

--         local x = cx + radius * vox_math.cos(phiRad)
--         local z = cz + radius * vox_math.sin(phiRad)

--         set_block(x, cy, z, id, get_block_states(x, cy, z))
--     end
-- end

-- function circle_gen_z(cx, cy, cz, radius, precision, id)
--     local deltaPhi = 360 - precision

--     for phi = 0, deltaPhi, precision do
--         local phiRad = vox_math.rad(phi)

--         local x = cx + radius * vox_math.cos(phiRad)
--         local y = cy + radius * vox_math.sin(phiRad)

--         set_block(x, y, cz, id, get_block_states(x, y, cz))
--     end
-- end

-- function on_broken(x,y,z)
--     click, spx, spy, spz = 0,0,0,0
-- end

-- function on_placed(x, y, z)
    
--     if click == 0 then
--         click, spx, spy, spz = 1, x, y, z
--     else
--         local id = get_block(x, y - 1, z)
--         local d = vox_math.dist(spx, spy, spz, x, y, z)
--         local precision = F(d)
--         set_block(x, y, z, id, get_block_states(x, y, z))
--         set_block(spx, spy, spz, 0)

--         circle_gen(spx, spy, spz, d, precision, id)
--         circle_gen_x(spx, spy, spz, d, precision, id)
--         circle_gen_y(spx, spy, spz, d, precision, id)
--         circle_gen_z(spx, spy, spz, d, precision, id)

--         click, spx, spy, spz = 0, 0, 0, 0
--     end
-- end