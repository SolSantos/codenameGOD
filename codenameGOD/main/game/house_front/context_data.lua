local game_state = require("main.game_state")
local items = require("main.game.item.items")
local context_data = require("main.context_data")

local update_context_entries

update_context_entries = function(self)
	context_data[hash("broke_bike")] = {
		{text="Inspect", click=function()
			if bike_inspect == 0 then
				msg.post("/balloon", "show_text", {text = "A useless bike. Honestly, who designed this?", character="randall"})
				bike_inspect = bike_inspect + 1 
			elseif bike_inspect == 1 then
				msg.post("/balloon", "show_text", {text = "Seriously, it doesn't even have pedals.", character="randall"})
				bike_inspect = bike_inspect + 1 
			elseif bike_inspect == 2 then
				msg.post("/balloon", "show_text", {text = "The wheels aren't even made of rubber. What is this... are they made of plastic?!", character="randall"})
				bike_inspect = bike_inspect + 1 
			else
				msg.post("/balloon", "show_text", {text = "Who owns this??!", character="randall"})
				bike_inspect = 0
			end
		end}
	}

	context_data[hash("trash")] = {
		{text="Inspect", click=function()
			if not game_state.data.trash_inspected then
				msg.post("/balloon", "show_text", {text = "Just a load of garb- Wait...What's that?", character="randall"})	
				game_state.data.trash_inspected=true
				update_context_entries(self)
			else
				msg.post("/balloon", "show_text", {text = "Trash can, not trash cannot.\n Heh.", character="randall"})	
			end
		end}
	}
	if game_state.data.trash_inspected and not game_state.data.trash_pickup then
		table.insert(context_data[hash("trash")], {text="Open", click=function()
			msg.post("/balloon", "show_text", {text = "Oh. It's just a Jon Bovi album.", character="randall"})	
			game_state.data.trash_pickup=true
			msg.post("/sound#6-drawer_opening", "play_sound")
			game_state.data.coins_shown = true
			local cd = items.data["cd"]
			cd.status = "show"
			cd.position.x = 904
			cd.position.y = 103
			msg.post("/item_manager#item_manager", "update_visible_items")
			update_context_entries(self)
		end})
	end

	context_data[hash("sky")] = {
		{text="Inspect", click="Beautiful sky today. Somehow always clear."}
	}
	context_data[hash("doggo")] = {
		{text="Inspect", click="Must. Fight. Urge. To. Pet."}
	}
	context_data[hash("back_to_room_door")] = {
		{text="Inspect", click="The front entrance to my headquarters."},
		{text="Go", click=function()
			msg.post(door_sound_url, "play_sound")
			msg.post("/collections#main", "load_screen", {
				name = "room",
				pos = vmath.vector3(422,311,0.2)
			})
		end}
	}

	context_data[hash("city_street_arrow")] = {
		{text="Inspect", click="This road leads to the city. Not the city of Rome, no."},
		{text="Go", click=function()
			if game_state.data.stage == game_state.stages.PROLOG and not items.data.ticket.in_inventory then
				msg.post("/balloon", "show_text", {text="I can't go to the tournament without the ticket.", character = "randall", sound="#Randall_6"})
				return
			end

			msg.post("/collections#main", "load_screen", {
				name = "city_street_day",
				pos = vmath.vector3(200,211,0.2)
			})
		end}
	}
end

return update_context_entries