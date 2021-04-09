local RoPID = require(script.Parent.Parent)
local Compound = require(script.Parent.Compound)

local Vec3 = {}
Vec3.__index = Vec3

function Vec3.new(...)
  return setmetatable({
    _comp = Compound(3, ...)
  }, Vec3)
end

function Vec3.Is(obj)
  return typeof(obj) == "table" and getmetatable(obj) == Vec3
end

function Vec3:Calculate(setPoint: number, proccessValue: number, deltaTime: number)
  local comp = self._comp
  return Vector3.new(
    comp[1]:Calculate(setPoint.X, proccessValue.X, deltaTime),
    comp[2]:Calculate(setPoint.Y, proccessValue.Y, deltaTime),
    comp[3]:Calculate(setPoint.Z, proccessValue.Z, deltaTime))
end

return Vec3