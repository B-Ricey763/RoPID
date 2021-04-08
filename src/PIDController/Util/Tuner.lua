local PIDController = require(script.Parent.Parent)
local Vec3 = require(script.Parent.Vec3)

--[[
  Used for debugging your PID Controllers.
]]
local Tuner = {}
Tuner.__index = Tuner

function Tuner.new(name, controller, parent)
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
  if getmetatable(controller) == PIDController then
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
  elseif getmetatable(controller) == Vec3 then
    self:_init(controller.X)
    self:_init(controller.Y)
    self:_init(controller.Z)
  end
end

function Tuner:Destroy()
  if self._instance then 
    self._instance:Destroy()
  end
end

return Tuner