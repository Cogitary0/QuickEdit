local table_utils = {}

function table_utils.easy_concat(tbl)
    local output = ""
    for i, value in pairs(tbl) do
        output = output .. tostring(value)
        if i ~= #tbl then
            output = output .. ", "
        end
    end
    return output
end

function table_utils.equals(tbl1, tbl2)
    return table_utils.easy_concat(tbl1) == table_utils.easy_concat(tbl2)
end

function table_utils.tbl_in_tbl(tbl, key)
    local temp_table = {}
    for _, b in ipairs(tbl) do
        temp_table[table_utils.easy_concat(b)] = b
    end
    key = table_utils.easy_concat(key)
    return temp_table[key]
end

function table_utils.find(tbl, elem)
    for i = 1, #tbl do
        if tbl[i] == elem then
            return i
        end
    end
end

function table_utils.iselem(table, element, state_is_true)
    if table ~= state_is_true then
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
        return false
    elseif state_is_true ~= nil then
        return true
    end
end

function table_utils.insert_unique(tbl, elem)
    if tbl ~= nil then
        if table_utils.find(tbl, elem) == false then
            table.insert(tbl, elem)
        end
    end
end

function table_utils.copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

function table_utils.sort(t)
    table.sort(t, function(a, b) return a < b end)
    return t
end

return table_utils