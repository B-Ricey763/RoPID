local RoPID = require(script.Parent.Parent)
--[[
  Creates an array of PID controllers.
  Useful when using the same gains but for different
  set points and process values.
  Used by Vec2 and Vec3 util modules.
  Not really sure if it's needed.
]]
return function (num, ...)
  local comp = table.create(num, {})
  for i = 1, num do
    comp[i] = RoPID.new(...)
  end
  return comp
end
