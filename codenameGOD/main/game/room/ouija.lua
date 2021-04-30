local inside_gameobject = require("main.inside_gameobject")
local SHAKE = 1
local SHAKE_SLEEP = 0.1

return {
	init = function(room)
		msg.post(room.big_ouija_url, "enable")
		go.animate(room.randall_arms_url, "position.y", go.PLAYBACK_ONCE_FORWARD, 30, go.EASING_LINEAR, 1, 0, function()
			room.arms_position = go.get_position(room.randall_arms_url)
			room.ouija_in_use = true
		end)
		room.shake_elapsed = 0
	end,
	update = function(room, dt)
		room.shake_elapsed = room.shake_elapsed + dt
		if room.shake_elapsed > SHAKE_SLEEP then
			local offset = vmath.vector3(math.random(-SHAKE, SHAKE), math.random(-SHAKE, SHAKE), 0)
			go.set_position(room.arms_position + offset, room.randall_arms_url)
			room.shake_elapsed = 0
		end
	end,
	on_input = function(room, action_id, action)
		if action_id == hash("click") and action.pressed then
			if inside_gameobject(room.arms_hitbox_url, action.x, action.y) then
				print("draging hands")
			end
		end
	end,
	final = function(room)
	end
}