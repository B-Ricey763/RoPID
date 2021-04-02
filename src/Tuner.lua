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
    _controller = controller,
  }, Tuner)

  self:_init()

  return self
end

function Tuner:_init()
  local folder: Folder = self._instance

  for name, gain in pairs(self._controller.Gains) do
    folder:SetAttribute(name, gain)
    folder:GetAttributeChangedSignal(name):Connect(function()
      self._controller.Gains[name] = folder:GetAttribute(name)
    end)
  end

  for name, bound in pairs(self._controller.Bounds) do
    folder:SetAttribute(name, bound)
    folder:GetAttributeChangedSignal(name):Connect(function()
      self._controller.Bounds[name] = folder:GetAttribute(name)
    end)
  end
end

function Tuner:Destroy()
  if self._instance then 
    self._instance:Destroy()
  end
end

return Tuner