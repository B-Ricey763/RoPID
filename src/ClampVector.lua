--[[
  Clamps a given vector by normalizing it and finding the min mag.

  Params:
    vector: the vector in question
    max: maximum magnitude

  Returns:
    the clamped vector
]]
return function (vector: (Vector3 | Vector2), max: number): (Vector3 | Vector2)
  local mag = vector.Magnitude
  return vector.Unit * math.min(mag, max)
end