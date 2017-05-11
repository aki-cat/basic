
local grid = require 'basic.prototype' :new {
  3, 3, 0,
  unit = 32,
  __type = 'grid'
}

local function fill_grid (t, width, height, fill)
  for x = 1, width do
    t[x] = {}
    for y = 1, height do
      t[x][y] = fill or 0
    end
  end
end

function grid:__init ()
  local width, height, fill = self[1], self[2], self[3]
  self.container = {}
  fill_grid(self.container, width, height, fill)
end

function grid:set_cell (x, y, fill)
  assert(self.container[x], "Invalid x pos: " .. x)
  assert(self.container[x][y], "Invalid y pos: " .. y)
  self.container[x][y] = fill or 0
end

function grid:get_cell (x, y)
  return (self.container[x] or {})[y]
end

function grid:is_occupied (x, y)
  local cell = self:get_cell()
  return cell and cell ~= self:get_base()
end

function grid:get_width ()
  return self[1]
end

function grid:get_height ()
  return self[2]
end

function grid:get_dimensions ()
  return self[1], self[2]
end

function grid:get_unit ()
  return self.unit
end

function grid:set_unit (u)
  self.unit = u
end

function grid:get_base ()
  return self[3]
end

function grid:clear ()
  fill_grid(self.container)
end

function grid.new_from_table (t)
  local m = grid:new { #t[1], #t }
  for i in ipairs(t) do
    for j in ipairs(t[i]) do
      print("row/y", i)
      print("col/x", j)
      m:set_cell(j, i, t[i][j])
    end
  end
  return m
end

function grid:iterate ()
  local init_s = { 1, 0, tbl = self.container }
  return function(s, value)
    local m = s.tbl

    s[2] = s[2] + 1
    x, y = s[1], s[2]
    value = m[x] and m[x][y]

    if not value then
      s[1] = s[1] + 1
      s[2] = 1
      x, y = s[1], s[2]
      value = m[x] and m[x][y]
    end

    return value and x, y, value
  end,
  init_s,
  0
end

function grid:__tostring ()
  local s = "\n"
  for x, y, value in self:iterate() do
    s = s .. "[" .. x .. ", " .. y .. "]: " .. value .. "\n"
  end
  s = s .. "\n"
  return s
end

return grid
