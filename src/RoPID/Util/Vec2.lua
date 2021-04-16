--[[
  Basically a wrapper class for a Compound with 2 values. See RoPID.Util.Compound for details.
  Vec2 is also tunable, but each axis is tuned the same. Useful for GUI
  applications, or anything in 2D space.

  API:
    Vec2.Is(obj: any): boolean

    vec2Controller = Vec2.new(kP: number, kI: number, kD: number, min: number?, max: number?)
      > Same as RoPID, uses ... to pass into compound

    vec2Controller:Calculate(setPoint: Vector2, proccessValue: Vector2, deltaTime: number): Vector2
      > Same as RoPID, but uses Vector2s for sp and pv
]]

local RoPID = require(script.Parent.Parent)

local Vec2 = {}
Vec2.__index = Vec2

function Vec2.new(...)
  return setmetatable({
    _comp = RoPID.Compound(2, ...)
  }, Vec2)
end

function Vec2.Is(obj): boolean
  return typeof(obj) == "table" and getmetatable(obj) == Vec2
end

function Vec2:Calculate(setPoint: Vector2, proccessValue: Vector2, deltaTime: number): Vector2
  local comp = self._comp
  return Vector2.new(
    comp[1]:Calculate(setPoint.X, proccessValue.X, deltaTime),
    comp[2]:Calculate(setPoint.Y, proccessValue.Y, deltaTime))
end

return Vec2