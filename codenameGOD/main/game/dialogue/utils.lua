local LETTERS_PER_SECOND = 20

local get_visible_text = function(text, elapsed)
	local visible_count = math.min(text:len(), elapsed * LETTERS_PER_SECOND)
	return text:sub(0, visible_count)
end

return {
	LETTERS_PER_SECOND = LETTERS_PER_SECOND,
	get_visible_text=get_visible_text 
}