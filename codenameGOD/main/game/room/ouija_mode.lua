local inside_gameobject = require("main.inside_gameobject")
local game_state = require("main.game_state")
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
		return
	end
	
	room.hover_elapsed = room.hover_elapsed + dt
	if not room.moved_after_selection or room.hover_elapsed < LETTER_WAIT_TIME then
		return
	end
	
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
	room.hover_elapsed = 0
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
	end,
	update = function(room, dt)
		local shake = SHAKE
		local shake_sleep = SHAKE_SLEEP
		if room.moved_hands then
			go.set_position(room.arms_position, room.randall_arms_url)
			room.moved_hands = false
			room.hover_elapsed = 0
			room.moved_after_selection = true
			shake = SHAKE_MOVING
			shake_sleep = SHAKE_MOVING_SLEEP
			msg.post("/randall", "get_scared")
			room.scared_elapsed = 0
		else
			local magnifier_pos = room.arms_position + MAGNIFIER_OFFSET
			local letter = get_hovered_letter(room, magnifier_pos.x, magnifier_pos.y)
			handle_selected_letter(room, dt, letter)

			room.scared_elapsed = room.scared_elapsed + dt
			if room.scared_elapsed > SCARED_DEACTIVATION_TIME then
				msg.post("/randall", "idle")
			end
		end

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