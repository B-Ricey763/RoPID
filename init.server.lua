--[[
  This PID test script bascially mimics a BodyPosition by moving a part
  to a goal Part. Unlike BodyPosition, you can change the Integral component, and
  this works because of the clamping to integrator windup.

  DISCLAIMER: I kind of suck at tuning my PID Controllers, so please
  play around with the gains (P, I, D) yourself. You can find them
  in the constructor: PIDVec3.new(kP, kI, kD, min, max)
]]

local RunService = game:GetService("RunService")
local RoPID = require(game:GetService("ReplicatedStorage").RoPID)
local Tuner = require(RoPID.Util.Tuner)
local PIDVec3 = require(RoPID.Util.Vec3)
local part: Part = workspace.Part
local goal = workspace.Goal

-- Realistically, you'd do this in test.project.json, or your Roblox Project,
-- but I was too lazy, so I create the VectorForce here
local vf = Instance.new("VectorForce")
local attach = Instance.new("Attachment")
vf.Attachment0 = attach
vf.RelativeTo = Enum.ActuatorRelativeTo.World
attach.Parent = part
vf.Parent = part

-- Make the proportional part a little greater than the force needed to lift the part
local kP = part.AssemblyMass * workspace.Gravity + 100 
-- The PIDVec3 is a wrapper class with 3 PID controllers, one to each axis: X, Y, Z
local controller = PIDVec3.new(kP, 5000, 2500, -80000, 80000)
-- Go to workspace.BallTuner and change the attributes to tune your PID Controller
Tuner.new("BallTuner", controller)
-- Update the vf every frame with the new PID output
RunService.Stepped:Connect(function(_, dt)
  local out = controller:Calculate(goal.Position, part.Position, dt)
  vf.Force = out
end)
