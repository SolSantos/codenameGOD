local inside_gameobject = require("main.inside_gameobject")
local SHAKE = 1
local SHAKE_SLEEP = 0.1

local ouija_mapping =  {
	A =     {x=90,  y=289, width=30,  height=50},
	B =     {x=138, y=272, width=30,  height=50},
	C =     {x=186, y=289, width=30,  height=50},
	D =     {x=234, y=272, width=30,  height=50},
	E =     {x=280, y=289, width=30,  height=50},
	F =     {x=327, y=272, width=30,  height=50},
	G =     {x=374, y=289, width=30,  height=50},
	H =     {x=419, y=272, width=30,  height=50},
	I =     {x=464, y=289, width=20,  height=50},
	J =     {x=496, y=272, width=30,  height=50},
	K =     {x=539, y=289, width=30,  height=50},
	L =     {x=583, y=272, width=30,  height=50},
	M =     {x=627, y=289, width=30,  height=50},
	N =     {x=86,  y=195, width=30,  height=50},
	O =     {x=135, y=177, width=30,  height=50},
	P =     {x=183, y=195, width=30,  height=50},
	Q =     {x=227, y=177, width=30,  height=50},
	R =     {x=272, y=195, width=30,  height=50},
	S =     {x=318, y=177, width=30,  height=50},
	T =     {x=358, y=195, width=30,  height=50},
	U =     {x=399, y=177, width=30,  height=50},
	V =     {x=443, y=195, width=30,  height=50},
	W =     {x=491, y=177, width=30,  height=50},
	X =     {x=538, y=195, width=30,  height=50},
	Y =     {x=582, y=177, width=30,  height=50},
	Z =     {x=628, y=195, width=30,  height=50},
	["1"] = {x=171, y=104, width=17,  height=33},
	["2"] = {x=203, y=114, width=25,  height=33},
	["3"] = {x=244, y=104, width=25,  height=33},
	["4"] = {x=283, y=114, width=25,  height=33},
	["5"] = {x=327, y=104, width=25,  height=33},
	["6"] = {x=368, y=114, width=25,  height=33},
	["7"] = {x=408, y=104, width=25,  height=33},
	["8"] = {x=447, y=114, width=25,  height=33},
	["9"] = {x=488, y=104, width=25,  height=33},
	["0"] = {x=532, y=114, width=25,  height=33},
	YES =   {x=235, y=383, width=90,  height=38},
	NO =    {x=423, y=383, width=57,  height=38},
	DONE =  {x=299, y=30,  width=121, height=40}
}

local magnifier_offset = vmath.vector3(-6 , 100, 0)
local ouija_size = vmath.vector3(732, 480, 0)

local inside_rect = function(rect, x, y)
	local inside_x = x >= rect.x and x <= rect.x + rect.width
	local inside_y = y >= rect.y and y <= rect.y + rect.height
	return inside_x and inside_y
end

local get_hovered_letter = function(room, x, y)
	local ouija_offset = go.get_position(room.big_ouija_url) - (ouija_size / 2)
	x = x - ouija_offset.x
	y = y - ouija_offset.y
	
	for text, rect in pairs(ouija_mapping) do
		if inside_rect(rect, x, y) then
			return text
		end
	end
	return nil
end

return {
	init = function(room)
		msg.post(room.big_ouija_url, "enable")
		go.animate(room.randall_arms_url, "position.y", go.PLAYBACK_ONCE_FORWARD, 30, go.EASING_LINEAR, 1, 0, function()
			room.arms_position = go.get_position(room.randall_arms_url)
			room.ouija_in_use = true
		end)
		room.shake_elapsed = 0
		room.moved_hands = false
	end,
	update = function(room, dt)
		if moved_hands then
			go.set_position(room.arms_position, room.randall_arms_url)
			moved_hands = false
		else
			local magnifier_pos = room.arms_position + magnifier_offset
			local letter = get_hovered_letter(room, magnifier_pos.x, magnifier_pos.y)
			if letter then
				print(letter)
			end
		end
		
		room.shake_elapsed = room.shake_elapsed + dt
		if room.shake_elapsed > SHAKE_SLEEP then
			local offset = vmath.vector3(math.random(-SHAKE, SHAKE), math.random(-SHAKE, SHAKE), 0)
			go.set_position(room.arms_position + offset, room.randall_arms_url)
			room.shake_elapsed = 0
		end
	end,
	on_input = function(room, action_id, action)
		if action_id == hash("click") then
			local in_same_pos = action.x == room.arms_position.x and action.y == room.arms_position.y
			if not in_same_pos and inside_gameobject(room.arms_hitbox_url, action.x, action.y) then
				room.arms_position = vmath.vector3(action.x, action.y, room.arms_position.z)
				moved_hands = true
			end
		end
	end,
	final = function(room)
	end
}