local HINT_TIME = 10 -- seconds
local FLAVORS_BEFORE_HINT = 2 -- 2 flavors and then 1 hint

local update = function(collection, dt)
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
	collection._hint.update_time = 0
end

return {
	update=update,
	reset=reset
}