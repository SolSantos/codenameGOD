local context_data = require("main.context_data")

function register_goto_screen(key, inspect_text, next_screen, pos)
	if type(key) == "table" then
		key, inspect_text, next_screen, pos = key.key, key.inspect_text, key.next_screen, key.pos -- Allow individual arguments or table
	end
	
	context_data[hash(key)] = {
		{text="Inspect", click=inspect_text},
		{text="Go", click=function()
			msg.post("/collections#main", "load_screen", {name=next_screen, pos=pos})
		end}
	}
end

return {
	register_goto_screen=register_goto_screen
}