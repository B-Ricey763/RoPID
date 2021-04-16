--[[
  Basically a wrapper class for a Compound with 2 values. See RoPID.Util.Compound for details.
  Vec3 is also tunable, but each axis is tuned the same. Useful for GUI
  applications, or anything in 2D space.

  API:
    Vec3.Is(obj: any): boolean

    Vec3Controller = Vec3.new(kP: number, kI: number, kD: number, min: number?, max: number?)
      > Same as RoPID, uses ... to pass into compound

    Vec3Controller:Calculate(setPoint: Vector3, proccessValue: Vector3, deltaTime: number): Vector3
      > Same as RoPID, but uses Vector3s for sp and pv
]]

local RoPID = require(script.Parent.Parent)

local Vec3 = {}
Vec3.__index = Vec3

function Vec3.new(...)
  return setmetatable({
    _comp = RoPID.Compound(3, ...)
  }, Vec3)
end

function Vec3.Is(obj): boolean
  return typeof(obj) == "table" and getmetatable(obj) == Vec3
end

function Vec3:Calculate(setPoint: Vector3, proccessValue: Vector3, deltaTime: number): Vector3
  local comp = self._comp
  return Vector3.new(
    comp[1]:Calculate(setPoint.X, proccessValue.X, deltaTime),
    comp[2]:Calculate(setPoint.Y, proccessValue.Y, deltaTime),
    comp[3]:Calculate(setPoint.Z, proccessValue.Z, deltaTime))
end

return Vec3