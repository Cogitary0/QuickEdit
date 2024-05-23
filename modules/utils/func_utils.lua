local funcUtils = { }

funcUtils.__minmax__ = function(pos1, pos2)
    local minX, maxX = math.min(pos1[1],pos2[1]),math.max(pos1[1],pos2[1])
    local minY, maxY = math.min(pos1[2],pos2[2]),math.max(pos1[2],pos2[2])
    local minZ, maxZ = math.min(pos1[3],pos2[3]),math.max(pos1[3],pos2[3])
    return minX, maxX, minY, maxY, minZ, maxZ
end


funcUtils.__distance__ = function(start_pos, end_pos)
    return math.sqrt( 
        math.pow(end_pos[1] - start_pos[1], 2) + 
        math.pow(end_pos[2] - start_pos[2], 2) + 
        math.pow(end_pos[3] - start_pos[3], 2) 
    )
end

funcUtils.__get_selection_bounds__ = function(start_pos, end_pos)
    local __x0, __y0, __z0 = unpack(start_pos)
    local __x1, __y1, __z1 = unpack(end_pos)
    if __x1 > __x0 then __x1, __x0 = __x0, __x1 end
    if __y1 > __y0 then __y1, __y0 = __y0, __y1 end
    if __z1 > __z0 then __z1, __z0 = __z0, __z1 end
    return __x1, __y1, __z1, __x0, __y0, __z0
end    

funcUtils.__sign__ = function(value)
    if value == 0 then return 0 end
    return value / math.abs(value)
end

funcUtils.__round__ = function(value)
    return value >= 0 and math.floor( value + 0.5 ) or math.ceil( value - 0.5 )
end

return funcUtils