Matrix = {}
Matrix.__index = Matrix

function Matrix.new(row, col)
    local self = setmetatable({}, Matrix)

    self.row = row
    self.col = col
    self.data = {}

    
end