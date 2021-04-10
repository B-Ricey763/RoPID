--[[
  *PUT IN SERVER SCRIPT*
  A ball that tries to get to a point
  in 3D space. It is mainly tuned for the
  Y axis (because of gravity), but the other
  axes work pretty well. 
]]
local RunService = game:GetService("RunService")
local RoPID = require(game:GetService("ReplicatedStorage").RoPID) -- Change to wherever the module is
local Vec3 = require(RoPID.Util.Vec3)

local function createBall()
  local ball = Instance.new("Part")
  ball.Shape = "Ball"
  ball.Size = Vector3.new(3, 3, 3)
  ball.Position = Vector3.new(0, 5, 0)
  ball.CanCollide = true
  ball.Parent = workspace

  -- Should be using VectorForce but too lazy to make
  local bodyForce =  Instance.new("BodyForce")
  bodyForce.Parent = ball

  return ball
end

local function createGoal()
  local goal = Instance.new("Part")
  goal.Shape = "Ball"
  goal.Size = Vector3.new(.5, .5, .5)
  goal.Position = Vector3.new(0, 10, 0)
  goal.CanCollide = false
  goal.Anchored = true
  goal.BrickColor = BrickColor.Blue()
  goal.Transparency = .5
  goal.Parent = workspace
  return goal
end

local controller = Vec3.new(2000, 150, 250) -- Change gains if you want
local ball = createBall()
local bf = ball.BodyForce
local goal = createGoal()

RunService.Stepped:Connect(function(et, dt)
  local output = controller:Calculate(goal.Position, ball.Position, dt)
  bf.Force = output
end)