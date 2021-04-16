-- PIDController
-- BRicey763
-- April 4, 2021

--[[
  A PID (Proportional, Integral, Derivative) Controller is a type of closed feedback loop that uses a specfic algorithim 
  to get an ouput that gets to the desired position quickly, doesn't overshoot, and can resist transient errors. 
  Some uses in real life include cruise control on a car, altitude on a drone, and temperature for an oven. 
  However, the gains for a PID controller have to be tuned manually. For assistance with this, see RoPID.Util.Tuner. 
  This module is heavily inspired by AeroGameFramework's PID module:
  https://github.com/Sleitnick/AeroGameFramework/blob/43e4e02717e36ac83c820abc4461fb8afa2cd967/src/StarterPlayer/StarterPlayerScripts/Aero/Modules/PID.lua
  But it also guards against integrator windup (which is essential in almost any application), and has a bunch of helper classes.
  This class only deals with numbers, if you want PID with Vector3s or Vector2s, see their respective files in RoPID.Util. 
  For more info on PID, watch this series on YouTube:
  https://youtube.com/playlist?list=PLn8PRpmsu08pQBgjxYFXSsODEF3Jqmm-y


  API:

    RoPID.Is(obj: any): boolean

    RoPID.Compound(num: number, ...: number): RoPID[]
      > Creates a bunch of PID controllers at once. 
        WARNING: No support for this in Tuner

    controller = RoPID.new(kP: number, kI: number, kD: number, min: number?, max: number?)
      > kP, kI, and kD are the gains. If you want to turn one of them off, just 
        pass in zero. Notice min and max are optional.

    controller:Calculate(setPoint: number, processValue: number, deltaTime: number): number
      > Given the set point (the goal position), the proccess value (the acutal position),
        and deltaTime (the time between each call), it uses the standard PID algorithim to
        get an ouput

  EXAMPLE USAGE:
    
    local controller = RoPID.new(5, 2, 3, -100, 100)
    local goal = 10 -- Your desired position, speed, height, etc.

    game:GetService("RunService").Stepped:Connect(function(et, deltaTime)
      local actualValue = -- read some value (maybe height, speed, or direction)
      local out = controller:Calculate(goal, actualValue, deltaTime)
      someVectorForce.Force = Vector3.new(out, 0, 0) -- Drive an actuator to implement the feedback
    end)
    
]]

local INVALID_GAINS_ERR = "Need 3 gains: P, I, D"

local RoPID = {}
RoPID.__index = RoPID

RoPID.Util = script.Util

function RoPID.new(kP: number, kI: number, kD: number, min: number?, max: number?)
  assert(kP and kI and kD, INVALID_GAINS_ERR)
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
  }, RoPID)
end

function RoPID.Compound(num, ...)
  local comp = table.create(num, {})
  for i = 1, num do
    comp[i] = RoPID.new(...)
  end
  return comp
end

function RoPID.Is(obj: any): boolean
  return typeof(obj) == "table" and getmetatable(obj) == RoPID
end

function RoPID:Calculate(setPoint: number, processValue: number, deltaTime: number): number
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

function RoPID:_shouldClamp(before, after, err)
  return before ~= after and math.sign(before) == math.sign(err)
end

return RoPID