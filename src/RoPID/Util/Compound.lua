local RoPID = require(script.Parent.Parent)

local Compound = {}
Compound.__index = Compound

function Compound.new(num, ...)
  local self = setmetatable({
    _list = table.create(num, {}),
    Num = num,
  }, Compound)
  for i = 1, num do
    self._list[i] = RoPID.new(...)
  end
  return self
end

function Compound.Is(obj)
  return typeof(obj) == "table" and getmetatable(obj) == Compound
end

return Compound
