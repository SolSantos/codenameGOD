local inside_gameobject = require("main.inside_gameobject")
local game_state = require("main.game_state")
local utils = require("main.utils")
local SHAKE = 1
local SHAKE_MOVING = 3
local SHAKE_MOVING_SLEEP = 0.02
local SHAKE_SLEEP = 0.1
local LETTER_WAIT_TIME = 1.6
local SCARED_DEACTIVATION_TIME = 0.7
local LETTER_TALK_TIME = 1.5
local MAGNIFIER_OFFSET = vmath.vector3(2, 90, 0)
local OUIJA_SIZE = vmath.vector3(732, 480, 0)
local BALLOON_POS = vmath.vector3(1030, 260, 1)

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
	M =     {x=627, y=289, width=32,  height=50},
	N =     {x=86,  y=195, width=30,  height=50},
	O =     {x=135, y=177, width=30,  height=50},
	P =     {x=183, y=195, width=30,  height=50},
	Q =     {x=227, y=173, width=30,  height=54},
	R =     {x=272, y=193, width=30,  height=52},
	S =     {x=318, y=177, width=30,  height=50},
	T =     {x=358, y=193, width=30,  height=52},
	U =     {x=399, y=177, width=30,  height=50},
	V =     {x=443, y=190, width=37,  height=55},
	W =     {x=491, y=177, width=32,  height=50},
	X =     {x=538, y=193, width=30,  height=52},
	Y =     {x=582, y=177, width=33,  height=50},
	Z =     {x=624, y=193, width=34,  height=52},
	["1"] = {x=168, y=101, width=23,  height=39},
	["2"] = {x=201, y=109, width=29,  height=39},
	["3"] = {x=241, y=101, width=29,  height=39},
	["4"] = {x=280, y=105, width=29,  height=39},
	["5"] = {x=324, y=101, width=29,  height=39},
	["6"] = {x=365, y=109, width=29,  height=39},
	["7"] = {x=405, y=101, width=29,  height=39},
	["8"] = {x=444, y=109, width=29,  height=39},
	["9"] = {x=485, y=101, width=29,  height=39},
	["0"] = {x=529, y=109, width=29,  height=39},
	YES =   {x=235, y=383, width=90,  height=38},
	NO =    {x=423, y=383, width=57,  height=38},
	DONE =  {x=299, y=30,  width=121, height=40}
}

local inside_rect = function(rect, x, y)
	local inside_x = x >= rect.x and x <= rect.x + rect.width
	local inside_y = y >= rect.y and y <= rect.y + rect.height
	return inside_x and inside_y
end

local get_hovered_letter = function(room, x, y)
	local ouija_offset = go.get_position(room.big_ouija_url) - (OUIJA_SIZE / 2)
	x = x - ouija_offset.x
	y = y - ouija_offset.y
	
	for text, rect in pairs(ouija_mapping) do
		if inside_rect(rect, x, y) then
			return text
		end
	end
	return nil
end

local end_ouija_mode = function(room)
	game_state.god_name = room.god_name
	room.ouija_in_use = false
	room.cutscenes.god_name_selected(room)
end

-- letter here may be nil, [A-Z0-9], or the words YES, NO and DONE
local handle_selected_letter = function(room, dt, letter)
	if not letter then
		room.leave_letter = true
		room.hover_elapsed = utils.clamp(room.hover_elapsed - (dt * 4), 0, LETTER_WAIT_TIME)
		return
	end
	
	room.hover_elapsed = utils.clamp(room.hover_elapsed + dt, 0, LETTER_WAIT_TIME)
	if letter ~= room.letter then
		room.hover_elapsed = 0
	end
	room.letter = letter

	if not room.moved_after_selection or not room.leave_letter or room.hover_elapsed < LETTER_WAIT_TIME then
		return
	end
	room.leave_letter = false
	
	if letter == "YES" then
		if room.ouija_name_done then
			end_ouija_mode(room)
		else
			msg.post("/balloon", "show_text", {delay=20, text = "First confirm that the name is done.", no_arrow=true, pos=BALLOON_POS, character = "/randall", sound="#Randall_4"})	
		end
	elseif letter == "NO" then
		msg.post("/balloon", "show_text", {delay=20, text = "If "..room.god_name.." isn't your name which one is?", no_arrow=true, pos=BALLOON_POS, character = "/randall", sound="#Randall_4"})
		room.god_name = ""
		room.ouija_name_done = false
	elseif letter == "DONE" then
		msg.post("/balloon", "show_text", {delay=20, text = "Is "..room.god_name.." your name??", no_arrow=true, pos=BALLOON_POS, character = "/randall", sound="#Randall_4"})
		room.ouija_name_done = true
	else
		room.god_name = room.god_name..letter
		local display_text = ""
		for letter in room.god_name:gmatch(".") do
			display_text = display_text..".."..letter.." "
		end
		msg.post("/balloon", "show_text", {delay=20, text=display_text, character="/randall", no_arrow=true, pos=BALLOON_POS, sound="#Randall_4"})
	end

	room.moved_after_selection = false
end

local get_letter_scaled_rect = function(letter, ouija_offset)
	local w, h = window.get_size()
	local scale = vmath.vector3(w / WIDTH, h / HEIGHT, 1.0)
	local rect = ouija_mapping[letter]
	local rx = (rect.x + ouija_offset.x) * scale.x
	local ry = (rect.y + ouija_offset.y) * scale.y
	local rw = rect.width * scale.x
	local rh = rect.height * scale.y
	return vmath.vector4(rx, ry, rw, rh)
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
		room.hover_elapsed = 0
		room.god_name = ""
		room.moved_after_selection = true
		room.ouija_name_done = false
		room.scared_elapsed = 0
		room.talking_elapsed = 0
		room.letter = nil
		room.leave_letter = true
	end,
	update = function(room, dt)
		local shake = SHAKE
		local shake_sleep = SHAKE_SLEEP
		local magnifier_pos = room.arms_position + MAGNIFIER_OFFSET

		local w, h = window.get_size() 
		local scale = vmath.vector3(w / WIDTH, h / HEIGHT, 1.0)
		go.set(room.big_ouija_hitbox_url, "magnifier_radius", vmath.vector4(45 * scale.y, 0, 0, 0))

		local letter = get_hovered_letter(room, magnifier_pos.x, magnifier_pos.y)
		local ouija_offset = go.get_position(room.big_ouija_url) - (OUIJA_SIZE / 2)
		if letter then
			local pos = get_letter_scaled_rect(letter, ouija_offset)
			go.set(room.big_ouija_hitbox_url, "letter_rect", pos)
		end

		if room.moved_hands then
			go.set_position(room.arms_position, room.randall_arms_url)
			go.set(room.big_ouija_hitbox_url, "magnifier_pos", vmath.vector4(magnifier_pos.x * scale.x, magnifier_pos.y * scale.y, magnifier_pos.z, 0))
			
			room.moved_hands = false
			room.moved_after_selection = true
			shake = SHAKE_MOVING
			shake_sleep = SHAKE_MOVING_SLEEP
			msg.post("/randall", "get_scared")
			room.scared_elapsed = 0
		else
			room.scared_elapsed = room.scared_elapsed + dt
			if room.scared_elapsed > SCARED_DEACTIVATION_TIME then
				msg.post("/randall", "idle")
			end
		end
		handle_selected_letter(room, dt, letter)
		go.set(room.big_ouija_hitbox_url, "hover_elapsed", vmath.vector4(room.hover_elapsed, 0, 0, 0))

		-- Since we keep the balloon in display for a big time we want to manually 
		-- tell randall to stop talking earlier.
		if not room.moved_after_selection then
			room.talking_elapsed = room.talking_elapsed + dt
			if room.talking_elapsed > LETTER_TALK_TIME then
				msg.post("/randall", "stop_talking")
				room.talking_elapsed = 0
			end
		end
		
		room.shake_elapsed = room.shake_elapsed + dt
		if room.shake_elapsed > shake_sleep then
			local offset = vmath.vector3(math.random(-shake, shake), math.random(-shake, shake), 0)
			go.set_position(room.arms_position + offset, room.randall_arms_url)
			room.shake_elapsed = 0
		end
	end,
	on_input = function(room, action_id, action)
		if action_id == hash("click") then
			local in_same_pos = action.x == room.arms_position.x and action.y == room.arms_position.y
			if not in_same_pos and inside_gameobject(room.arms_hitbox_url, action.x, action.y) then
				room.arms_position = vmath.vector3(action.x, action.y, room.arms_position.z)
				room.moved_hands = true
			end
		end
	end
}