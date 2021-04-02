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

local ClampVector = require(script.ClampVector)

local function ClampWrapper(val, params)
  local min = params.Min
  local max = params.Max
  if not min or not max then return val end
  return math.clamp(val, min, max)
end

local function ClampVectorWrapper(val, params)
  local max = params.MaxMagnitude
  if not max then return val end
  return ClampVector(val, max)
end

local PIDController = {}
PIDController.__index = PIDController

PIDController.Tuner = script.Tuner

--[[
  Default constructor for systems with single numbers as their ouput

  Params:
    kP: proportional constant
    kI: integral constant
    kD: derivative constant
    min: (optional) minimum output
    max: (optional) maximum output
]]
function PIDController.new(kP: number, kI: number, kD: number, min, max): any
  return PIDController._new(kP, kI, kD,
                            0, 
                            ClampWrapper, 
                            {Min = min, Max = max})
end

--[[
  Default constructor for systems with Vector3s as their ouput.
  Keep in mind since magnitudes can only be positive, there is no
  minimum value.

  Params:
    kP: proportional constant
    kI: integral constant
    kD: derivative constant
    maxMagnitude: (optional) maximum threshold for ouput
]]
function PIDController.newVector3(kP: number, kI: number, kD: number, maxMagnitude): any
  return PIDController._new(kP, kI, kD, 
                            Vector3.new(), 
                            ClampVectorWrapper, 
                            {MaxMagnitude = maxMagnitude})
end

--[[
  Private base constructor that can take numerous types

  Params:
    kP: proportional constant
    kI: integral constant
    kD: derivative constant
    default: provided by public constructors, used for initialzation of integral and pastErr
    clamp: the specific clamp function, it gets the output and clampParams as parameters
    Bounds: either {min, max} or {maxMagnitude}, sent to clamp function
]]
function PIDController._new(kP: number, kI: number, kD: number, default, clamp, bounds)
  return setmetatable({
    Gains = {
      kP = kP,
      kI = kI,
      kD = kD,
    },
    Bounds = bounds,
    _integral = default,
    _pastErr = default,
    _clamp = clamp,
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
  self._integral += err * deltaTime
	local pOut = self.Gains.kP * err
	local iOut = self.Gains.kI * self._integral
	local dOut = self.Gains.kD * (err - self._pastErr) / deltaTime
	self._pastErr = err
	return self._clamp(pOut + iOut + dOut, self.Bounds)
end

return PIDController