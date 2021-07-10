math.random()

local LETTERS_PER_SECOND = 20 -- Should be the same as the value in balloon
local function get_text_duration(text)
	return (text:len() / LETTERS_PER_SECOND) + 1 + (0.2 * text:len() / 11)  
end

local function show_one_of(group)
	if not group or not group.messages or #group.messages == 0 then
		return 
	end

	local index = math.random(1, #group.messages)
	local message = group.messages[index]
	msg.post("/balloon", "show_text", {
		delay=message.delay or group.delay,
		text=message.text,
		character=message.character or group.character,
		sound=message.sound or group.sound,
		no_arrow=message.no_arrow or group.no_arrow,
		skip=message.skip or group.skip,
		effects=message.effects or group.effects,
		pos=message.pos or group.pos
	})
end

local function show_next_in_sequence(group)
	if not group or not group.messages or #group.messages == 0 then
		return
	end
	
	event_manager:clear_events()
	group.index = group.index or 0
	local message = group.messages[group.index + 1]
	if message.text_group then
		local last_wait_time = 0
		for i, m in pairs(message.text_group) do
			event_manager:register_event(last_wait_time, function()
				msg.post("/collections", "send_collection", {name="moved"})
				msg.post("/balloon", "show_text", {
					delay=m.delay or message.delay or group.delay,
					text=m.text,
					character=m.character or message.character or group.character,
					sound=m.sound or message.sound or group.sound,
					no_arrow=m.no_arrow or message.no_arrow or group.no_arrow,
					skip=m.skip or message.skip or group.skip,
					effects=m.effects or message.effects or group.effects,
					pos=m.pos or message.pos or group.pos
				})
			end)
			last_wait_time = get_text_duration(m.text)
		end
	else
		msg.post("/balloon", "show_text", {
			delay=message.delay or group.delay,
			text=message.text,
			character=message.character or group.character,
			sound=message.sound or group.sound,
			no_arrow=message.no_arrow or group.no_arrow,
			skip=message.skip or group.skip,
			effects=message.effects or group.effects,
			pos=message.pos or group.pos
		})
	end
	group.index = (group.index + 1) % #group.messages 
end

return {
	show_one_of = show_one_of,
	show_next_in_sequence = show_next_in_sequence,
	get_text_duration = get_text_duration
}