local game_state = require("main.game_state")
local items = require("main.game.item.items")
local context_data = require("main.context_data")

local update_context_entries
update_context_entries = function(self)
	context_data[hash("telescope")] = {
		{text="Inspect", click="My telescope! Many nights spent looking\nat girl--stars. Yes, indeed."}
	}
	context_data[hash("drawer")] = {
		{text="Inspect", click="I like to hide my change under my socks. It's rewarding to find a nickel between my toes every now and then!"}
	}
	if self.drawer_open then
		table.insert(context_data[hash("drawer")], {text="Close", click=function(x, y)
			self.drawer_open = false
			msg.post("/sound#6-drawer_opening", "play_sound")
			msg.post(self.drawer_url, "play_animation", {id = hash("close_drawer")})
			update_context_entries(self)
		end})
	else
		table.insert(context_data[hash("drawer")], {text="Open", click=function(x, y)
			self.drawer_open = true
			msg.post("/sound#6-drawer_opening", "play_sound")
			msg.post(self.drawer_url, "play_animation", {id = hash("open_drawer")})

			if not game_state.coins_shown then
				game_state.coins_shown = true
				local coins = items["coins"]
				coins.status = "show"
				coins.position.x = x
				coins.position.y = y
				msg.post("/item_manager#item_manager", "update_visible_items")
			end
			if game_state.awaiting_signal and not self.sign_drawer then
				self.sign_drawer = true
				msg.post(self.room_url, "divine_sign")
				self.divine_signs = self.divine_signs + 1
			end
			update_context_entries(self)
		end})
	end
	context_data[hash("room_door")] = {
		{text="Inspect", click="Door to the outside.\nThe wild urban jungle. The big adventure. The great unknown.\n....My frontyard."},
		{text="Go Out", click=function(x, y)
			if game_state.allowed_leave then
				msg.post("/collections#main", "load_screen",{
					name = "house_front",
					pos = vmath.vector3(222,211,0.4)
				})
				msg.post(self.door_sound_url, "play_sound")
				return
			end
			if not game_state.awaiting_signal then
				local r = math.random(2)
				if items.ticket.in_inventory then
					if r == 1 then
						msg.post("/balloon", "show_text", {delay = 4, text="I need to put on my shoes before I leave...", character = "/randall", sound="#Randall_3"})
					else
						msg.post("/balloon", "show_text", {delay = 4, text="What am I doing? I can't go barefoot!", character = "/randall", sound="#Randall_panic1"})
					end
				else
					if r == 1 then
						msg.post("/balloon", "show_text", {delay = 4, text="I have to find my ticket before I leave!", character = "/randall", sound="#Randall_1"})
					else
						msg.post("/balloon", "show_text", {delay = 4, text="Shoot, almost forgot my ticket!", character = "/randall", sound="#Randall_4"})
					end
				end			
			else
				msg.post("/balloon", "show_text", {delay = 4, text="Not leaving here until I'm touched by the divine.", character = "/randall", sound="#Randall_2"})
			end
		end}
	}
	context_data[hash("nes")] = {
		{text="Inspect", click="It's a Nintendo. \nTop of the line gaming technology!"}
	}
	context_data[hash("tv")] = {
		{text="Inspect", click="My TV. Yea, it's 480p. The future is here baby!"}
	}
	context_data[hash("books")] = {
		{text="Inspect", click="I hope the Dark Tower series ends soon, I hate waiting!"},
		{text="Move",    click=function()
			msg.post(self.room_url, "show_ticket")
			items.ticket.movable = true
			game_state.ticket_moved = true
			msg.post(self.books_context_url, "deactivate")
		end}
	}

	context_data[hash("room_window")] = {}
	context_data[hash("randall_trousers")] = {}
	if game_state.awaiting_signal then
		if not self.sign_tv then
			table.insert(context_data[hash("tv")], {text="Turn On", click=function(x, y)
				self.sign_tv = true
				self.divine_signs = self.divine_signs + 1
				msg.post(self.room_url, "divine_sign")
				msg.post(self.tv_sound_url, "play_sound")
				update_context_entries(self)
			end})
		end
		if not self.sign_window then
			table.insert(context_data[hash("room_window")], {text="Pull", click=function()
				self.sign_window = true
				msg.post(self.window_url, "play_animation", {id = hash("room_window3")})
				self.divine_signs = self.divine_signs + 1
				msg.post(self.room_url, "divine_sign")
				msg.post(self.window_sound_url, "play_sound")
				update_context_entries(self)
			end})
		end
		if not self.sign_trousers then
			table.insert(context_data[hash("randall_trousers")], {text="Pull", click=function()
				self.show_hints = false
				self.sign_trousers = true
				msg.post("/randall", "set_state", {state=RANDALL_STATE.PRAISING_NO_PANTS})
				msg.post(self.zipper_sound_url, "play_sound")
				event_manager:register_event(4, function()
					self.divine_signs = self.divine_signs + 1
					msg.post(self.room_url, "divine_sign")
					update_context_entries(self)
					self.show_hints = true
				end)
			end})
		end
	end
end

return update_context_entries