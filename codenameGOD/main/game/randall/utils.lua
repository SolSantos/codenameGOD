local CHARACTER_SPEED = 200 -- pixels / s
local movement_duration = function(target)
	local pos = go.get_position()
	local dist = math.abs(target.x - pos.x) + math.abs(target.y - pos.y)
	return dist / CHARACTER_SPEED	
end

return {
	movement_duration = movement_duration
}