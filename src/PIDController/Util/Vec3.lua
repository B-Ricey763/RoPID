local PIDController = require(script.Parent.Parent)

local Vec3 = {}
Vec3.__index = Vec3

function Vec3.new(kP: number, kI: number, kD: number, min: number, max: number)
  return setmetatable({
    X = PIDController.new(kP, kI, kD, min, max),
    Y = PIDController.new(kP, kI, kD, min, max),
    Z = PIDController.new(kP, kI, kD, min, max),
  }, Vec3)
end

function Vec3.Is(obj)
  return typeof(obj) == "table" and getmetatable(obj) == Vec3
end

function Vec3:Calculate(setPoint: number, proccessValue: number, deltaTime: number)
  return Vector3.new(self.X:Calculate(setPoint.X, proccessValue.X, deltaTime),
                    self.Y:Calculate(setPoint.Y, proccessValue.Y, deltaTime),
                    self.Z:Calculate(setPoint.Z, proccessValue.Z, deltaTime))
end

return Vec3