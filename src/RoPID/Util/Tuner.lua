local RoPID = require(script.Parent.Parent)

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
  else 
    
  end
end

function Tuner:Destroy()
  if self._instance then 
    self._instance:Destroy()
  end
end

return Tuner