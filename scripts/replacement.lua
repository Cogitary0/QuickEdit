local click_replace,start_pos_x,start_pos_y,start_pos_z = 0,0,0,0
function replace_select_space(x, y, z)
    local spx,spy,spz
    local x0, y0, z0
    local x1, y1, z1
    local id_need_block, id_replace_block

    spx,spy,spz = start_pos_x,start_pos_y,start_pos_z
    x0,y0,z0 = spx,spy,spz
    x1,y1,z1 = x,y,z

    id_need_block = get_block(spx,spy+1,spz)
    id_replace_block = get_block(spx,spy+2,spz)
    if spx > x then x0,x1 = x,spx end
    if spy > y then y0,y1 = y,spy end
    if spz > z then z0,z1 = z,spz end
    if id_need_block and id_replace_block ~= 0 then
        repeat
            for dy = y0, y1 do
                for dx = x0, x1 do
                    for dz = z0, z1 do
                        if get_block(dx,dy,dz) == id_replace_block then
                            set_block(dx, dy, dz, id_need_block, get_block_states(dx, dy, dz))
                        end
                    end
                end
            end
        until id_need_block ~= 0 or id_replace_block ~= 0
        
        for j=0,3,1 do set_block(spx,spy+j,spz,0,get_block_states(spx,spy,spz)) end
        
        click_replace,start_pos_x,start_pos_y,start_pos_z,id_need_block,id_replace_block = 0,0,0,0,0,0
    end
end

function on_broken(x,y,z)
    click_replace,start_pos_x,start_pos_y,start_pos_z = 1,0,0,0
end

function on_placed(x, y, z)
    if click_replace==0 then click_replace,start_pos_x,start_pos_y,start_pos_z = 1,x,y,z
    else 
        replace_select_space(x,y,z)
        set_block(x,y,z,0) 
    end
end



