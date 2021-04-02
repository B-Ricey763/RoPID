local RunService = game:GetService("RunService")
local PID = require(game:GetService("ReplicatedStorage").PIDController)
local Tuner = require(PID.Tuner)
local ball: Part = workspace.Ball
local goal = workspace.Goal
local vf = ball.VectorForce

local controller = PID.newVector3(ball.AssemblyMass * workspace.Gravity + 100, 5000, 2500, 100000)

local tuner = Tuner.new("BallTuner", controller)

RunService.Stepped:Connect(function(et, dt)
  local out = controller:Calculate(goal.Position, ball.Position, dt)
  vf.Force = out
end)
