local HINT_TIME = 15 -- seconds
local FLAVORS_BEFORE_HINT = 2 -- 2 flavors and then 1 hint
local is_running = true

local update = function(collection, dt)
	if not is_running then
		return
	end
	
	local hint = collection._hint or {update_time=0, counter=0, own_url=msg.url()}

	hint.update_time = hint.update_time + dt
	if hint.update_time >= HINT_TIME then
		if hint.counter < FLAVORS_BEFORE_HINT then
			msg.post(hint.own_url, "flavor")
		else
			msg.post(hint.own_url, "hint")
		end
		hint.counter = (hint.counter + 1) % (FLAVORS_BEFORE_HINT + 1)
		hint.update_time = 0
	end

	collection._hint = hint
end

local reset = function(collection)
	if collection._hint then
		collection._hint.update_time = 0
	end
end

local stop = function()
	is_running = false
end

local restart = function()
	is_running = true
end

return {
	update=update,
	reset=reset,
	stop=stop,
	restart=restart
}