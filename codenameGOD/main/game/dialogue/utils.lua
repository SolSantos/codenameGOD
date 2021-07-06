math.random()

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
	
	group.index = group.index or 0
	local message = group.messages[group.index + 1]
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
	group.index = (group.index + 1) % #group.messages 
end

return {
	show_one_of = show_one_of,
	show_next_in_sequence = show_next_in_sequence
}