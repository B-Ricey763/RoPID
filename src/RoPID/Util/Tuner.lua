--[[
  Tuner is responsible for debugging gains for your PID
  controller. It uses a folder with some attributes to edit
  the gains in runtime. They do not persist, so make sure
  to write them down before you close a session.

  API:
    tuner = Tuner.new(name: string, controller: RoPID | Vec3 | Vec2, parent: Instance?)
      > Creates a new folder in parent (or workspace, if parent is nil) with attributes
        denoting each gain (kP, kI, kD) and bound (min, max). When you change the attribute
        values, the gains and bounds of the controller change as well.

    tuner:Destroy()
      > deletes the folder
]]

local RoPID = require(script.Parent.Parent)
local Vec3 = require(script.Parent.Vec3)
local Vec2 = require(script.Parent.Vec2)

local INVALID_CONTROLLER_ERR = "Tuner: %s does not have a valid controller"

local Tuner = {}
Tuner.__index = Tuner

function Tuner.new(name, controller, parent)
  assert(RoPID.Is(controller) or Vec3.Is(controller) or Vec2.Is(controller), 
    string.format(INVALID_CONTROLLER_ERR, name))

  local folder = Instance.new("Folder")
  folder.Name = name
  folder.Parent = parent or workspace

  local self = setmetatable({
    _instance = folder,
  }, Tuner)
  self:_init(controller)
  return self
end

function Tuner:_init(controller)
  local folder: Folder = self._instance
  if RoPID.Is(controller) then
    for name, gain in pairs(controller.Gains) do
      folder:SetAttribute(name, gain)
      folder:GetAttributeChangedSignal(name):Connect(function()
        controller.Gains[name] = folder:GetAttribute(name)
      end)
    end

    for name, bound in pairs(controller.Bounds) do
      folder:SetAttribute(name, bound)
      folder:GetAttributeChangedSignal(name):Connect(function()
        controller.Bounds[name] = folder:GetAttribute(name)
      end)
    end

  elseif Vec3.Is(controller) or Vec2.Is(controller) then
    -- This makes sure we initilize every controller recursively
    for _, compController in ipairs(controller._comp) do
      self:_init(compController)
    end
  end
end

function Tuner:Destroy()
  if self._instance then 
    self._instance:Destroy()
  end
end

return Tuner