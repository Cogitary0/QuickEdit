-- local edt = require("quickedit:editor")
-- local click_put = 0
-- local start_pos = {x=0, y=0, z=0}
-- local id_blocks = { }

-- -- local function fill_select_space(x, y, z, id)
-- --     local x0, y0, z0, x1, y1, z1 = gsb(x, y, z, start_pos.x, start_pos.y, start_pos.z)
-- --     for dz = z0, z1 do
-- --         for dy = y0, y1 do
-- --             for dx = x0, x1 do
-- --                 set_block(dx, dy, dz, id[math.random(1,#id)], get_block_states(x0, y0, z0)) 
-- --             end
-- --         end
-- --     end
    
-- -- end

-- function on_broken(x,y,z)
--     click_put = 0
--     start_pos = {x=0,y=0,z=0}
--     id_blocks = { }
-- end

-- function on_placed(x, y, z)
--     if click_put == 0 then
--         click_put = 1
--         start_pos = {x, y, z}
--     else
--         editor.randbox(
--             start_pos,
--             {x, y, z},
--             id_blocks
--         )
--         -- for i = 1, 255, 1 do
--         --     local id_block_up = get_block(start_pos.x,start_pos.y+i,start_pos.z)
--         --     if id_block_up ~= 0 then id_blocks[i] = id_block_up
--         --     elseif #id_blocks == 0 and id_block_up == 0 then for j=1,21,1 do id_blocks[j] = math.random(1,21) end break end
--         -- end

        
--         -- fill_select_space(x, y, z, id_blocks)
        
--         id_blocks={ }
--         click_put = 0
--     end
-- end


-- function gsb(x, y, z, spx, spy, spz)
--     local x0, y0, z0, x1, y1, z1 = spx, spy, spz, x, y, z

--     if x < spx then x0, x1 = x, spx end
--     if y < spy then y0, y1 = y, spy end
--     if z < spz then z0, z1 = z, spz end

--     return x0, y0, z0, x1, y1, z1
-- end







