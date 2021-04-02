-- PIDController
-- April 4, 2021


--[[
  A class for managing PID, with gains and bounds
  Supported types: number, Vector3 (make sure to use the appropriate constructor)

  Example usage:
    local controller = PIDController.new(4, 2, 2.5)
    local goal = 10
    local actual = (some value read from the game, like a Position or Velocity)

    game:GetService("RunService").Stepped:Connect(function(et, dt)
      local out = controller:Calculate(goal, actual, dt)
    end)
  
]]

local PIDController = {}
PIDController.__index = PIDController

PIDController.Tuner = script.Tuner

--[[
  Private base constructor that can take numerous types

  Params:
    kP: proportional constant
    kI: integral constant
    kD: derivative constant
    min: minimum value
    max: maximum value
]]
function PIDController.new(kP: number, kI: number, kD: number, min: number, max: number)
  return setmetatable({
    Gains = {
      kP = kP,
      kI = kI,
      kD = kD,
    },
    Bounds = {
      Min = min or -math.huge,
      Max = max or math.huge,
    },
    _integral = 0,
    _pastErr = 0,
  }, PIDController)
end

--[[
  Calculates the controller output

  Params:
    setPoint: the desired value
    processValue: the measured value
]]
function PIDController:Calculate(setPoint: number, processValue: number, deltaTime: number)
  local err = setPoint - processValue
	local pOut = self.Gains.kP * err
	local iOut = 0
  if not self.IntegratorOff then
    self._integral += err * deltaTime
    iOut = self.Gains.kI * self._integral
  end
	local dOut = self.Gains.kD * (err - self._pastErr) / deltaTime
	local rawOutput = pOut + iOut + dOut
  local output = math.clamp(rawOutput, self.Bounds.Min, self.Bounds.Max)

  self.IntegratorOff = self:_shouldClamp(rawOutput, output, err)

	self._pastErr = err
  return output
end

function PIDController:_shouldClamp(before, after, err)
  return before ~= after and math.sign(before) == math.sign(err)
end

return PIDController