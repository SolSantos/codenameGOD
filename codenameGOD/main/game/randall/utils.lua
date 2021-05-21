local inside_gameobject = require("main.inside_gameobject")

local CHARACTER_SPEED = 200 -- pixels / s
local movement_duration = function(target)
	local pos = go.get_position()
	local dist = math.abs(target.x - pos.x) + math.abs(target.y - pos.y)
	return dist / CHARACTER_SPEED	
end

local default_item_ignore = function()
	msg.post("/balloon", "show_text", {text="Why are things falling on me??", character = "/randall", sound="#Randall_short2"})
end

local was_hit = function(x, y)
	return inside_gameobject(msg.url("/randall#hit_box"), x, y, vmath.vector3(-4, -63, 0))
end

return {
	movement_duration = movement_duration,
	default_item_ignore = default_item_ignore,
	was_hit = was_hit
}