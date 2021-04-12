--[[
  *PUT IN SERVER SCRIPT*
  A basic example using a Ball's Velocity (on the X axis).
  This uses the base RoPID class since we are only controlling
  one axis. This would be good for a player in a side-scroller
  controlling a physics-based ball.
]]
local RoPID = require(game:GetService("ReplicatedStorage").RoPID)
local Tuner = require(RoPID.Util.Tuner)

-- The speed we want to go 
local GOAL_VELOCITY = 1

local function createBall()
  local ball = Instance.new("Part")
  ball.Shape = "Ball"
  ball.Size = Vector3.new(3, 3, 3)
  ball.Position = Vector3.new(0, 5, 0)
  ball.CanCollide = true
  ball.Parent = workspace
  --------------------------------------------------------
  -- NOTE: IF YOU ARE HAVING TROUBLE WITH PLAYER INTERACTIONS
  -- WITH PID CONTROLLED OBJECTS, SET THE OWNERSHIP TO THE 
  -- SERVER (which is nil)
  --------------------------------------------------------
  ball:SetNetworkOwner(nil)

  -- Should be using VectorForce but too lazy to make
  local bodyForce =  Instance.new("BodyForce")
  bodyForce.Parent = ball

  return ball
end

local ball = createBall()
local bf = ball.BodyForce
-- For a situation like this, we only need to use the Proportional part
-- so we set all other gains to zero
local controller = RoPID.new(500, 0, 0)
Tuner.new("Ball", controller)

game:GetService("RunService").Stepped:Connect(function(et, dt)
  local output = controller:Calculate(GOAL_VELOCITY, ball.AssemblyLinearVelocity.X, dt)
  bf.Force = Vector3.new(output, 0, 0)
end)