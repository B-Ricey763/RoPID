--[[
  *PUT IN A LOCAL SCRIPT*
  Makes a Frame in a ScreenGui follow the mouse location.
  For some reason it is not exactly centered but
  it works accurately other than that.
]]

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RoPID = require(game:GetService("ReplicatedStorage").RoPID) -- It's good practice to keep it in ReplicatedStorage
local Vec2 = require(RoPID.Util.Vec2)

local CORE_GUI_OFFSET = Vector2.new(0, 36)
local GUI_SIZE = Vector2.new(100, 100)

-- Creates a new gui with a frame
local function createGui()
  local gui = Instance.new("ScreenGui")
  gui.Parent = playerGui

  local frame = Instance.new("Frame")
  frame.Size = UDim2.fromOffset(GUI_SIZE.X, GUI_SIZE.Y)
  frame.Position = UDim2.fromOffset(0, 0)
  frame.Parent = gui

  return frame
end
-- We use the Vec2 variation since guis are in 2D space
local controller = Vec2.new(.1, .5, .01) -- Change the gains if you want
local gui = createGui()

RunService.RenderStepped:Connect(function(dt)
  -- mousePos is a vector2, so it works great
  local mousePos = UserInputService:GetMouseLocation()
  local guiPos = gui.AbsolutePosition + CORE_GUI_OFFSET + GUI_SIZE/2 -- Have to add an offset for some reason
  local output = controller:Calculate(mousePos, guiPos, dt)
  gui.Position += UDim2.fromOffset(output.X, output.Y)
end)

