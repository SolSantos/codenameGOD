local game_state = require("main.game_state")
local items = require("main.game.item.items")
local context_data = require("main.context_data")
local balloon_utils = require("main.game.dialogue.utils")

local update_context_entries
update_context_entries = function(self)
	context_data[hash("telescope")] = {
		{text="Inspect", click="My telescope! Many nights spent looking\nat girl--stars. Yes, indeed."}
	}
	if game_state.data.waiting_for_night then
		table.insert(context_data[hash("telescope")], {
			text="Spy", click=function()
				self.cutscenes.prolog_end(self, "spy")
			end})	
		end
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

			if not game_state.data.coins_shown then
				game_state.data.coins_shown = true
				local coins = items.data["coins"]
				coins.status = "show"
				coins.position.x = 784
				coins.position.y = 253
				msg.post("/item_manager#item_manager", "update_visible_items")
			end
			if game_state.data.awaiting_signal and not self.sign_drawer then
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
			if game_state.data.allowed_leave then
				msg.post("/collections#main", "load_screen",{
					name = "house_front",
					pos = vmath.vector3(222,211,0.2)
				})
				msg.post(self.door_sound_url, "play_sound")
				return
			end
			if game_state.data.awaiting_signal then
				msg.post("/balloon", "show_text", {delay = 4, text="Not leaving here until I'm touched by the divine.", character = "/randall", sound="#Randall_2"})
			elseif game_state.data.waiting_for_night then
				msg.post("/balloon", "show_text", {delay = 4, text="The party only starts at night, so I have to wait until there.", character = "/randall", sound="#Randall_2"})
			else
				if items.data.ticket.in_inventory then
					balloon_utils.show_one_of({
						delay=4, character="/randall", messages={
							{text="I need to put on my shoes before I leave...", sound="#Randall_3"},
							{text="What am I doing? I can't go barefoot!", sound="#Randall_panic1"},
						}
					})
				else
					balloon_utils.show_one_of({
						delay=4, character="/randall", messages={
							{text="I have to find my ticket before I leave!", sound="#Randall_1"},
							{text="Shoot, almost forgot my ticket!", sound="#Randall_4"},
						}
					})
				end			
			end
		end}
	}
	context_data[hash("nes")] = {
		{text="Inspect", click="It's a Nintendo. \nTop of the line gaming technology!"}
	}
	if game_state.data.waiting_for_night then
		table.insert(context_data[hash("nes")], {
			text="Play", click=function()
				self.cutscenes.prolog_end(self, "nes")
			end})	
		end
	context_data[hash("tv")] = {
		{text="Inspect", click="My TV. Yea, it's 480p. The future is here baby!"}
	}
	if game_state.data.waiting_for_night then
		table.insert(context_data[hash("tv")], {
			text="Watch TV", click=function()
				self.cutscenes.prolog_end(self, "tv")
			end})	
	end

	context_data[hash("books")] = {}
	local ticket_moved = items.data.ticket.found == 1
	if not ticket_moved then
		context_data[hash("books")] = {
			{text="Inspect", click="I hope the Dark Tower series ends soon, I hate waiting!"},
			{text="Move",    click=function()
				msg.post(self.room_url, "show_ticket")
				items.data.ticket.movable = true
				msg.post(self.books_context_url, "deactivate")
			end}
		}
	end
	if game_state.data.waiting_for_night then
		table.insert(context_data[hash("books")], {
			text="Read", click=function()
					msg.post("/balloon", "show_text", {delay = 2, text="Might as well read until night...", character = "/randall", sound="#Randall_2"})
					self.cutscenes.prolog_end(self, "read")
			end})	
	end

	if self.window_closed then
		context_data[hash("room_window")] = {
			{text="Open", click=function()
				self.window_closed = false
				self.refresh_window(self)
				update_context_entries(self)
			end}
		}
	else
		context_data[hash("room_window")] = {
			{text="Close", click=function()
				self.window_closed = true
				self.refresh_window(self)
				update_context_entries(self)
			end}
		}
	end
	
	context_data[hash("randall_trousers")] = {}
	if game_state.data.awaiting_signal then
		if not self.sign_tv then
			table.insert(context_data[hash("tv")], {text="Turn On", click=function(x, y)
				self.sign_tv = true
				self.divine_signs = self.divine_signs + 1
				msg.post(self.room_url, "divine_sign")
				msg.post(self.tv_url, "play_animation", {id = hash("room_tv_on")})
				msg.post(self.tv_sound_url, "play_sound")
				update_context_entries(self)
			end})
		end
		if not self.sign_window and self.window_closed then
			context_data[hash("room_window")] = {
				{text="Pull", click=function()
					self.sign_window = true
					self.window_closed = false
					self.divine_signs = self.divine_signs + 1
					msg.post(self.room_url, "divine_sign")
					msg.post(self.window_sound_url, "play_sound")
					self.refresh_window(self)
					update_context_entries(self)
				end}
			}
		end
		if not self.sign_trousers then
			table.insert(context_data[hash("randall_trousers")], {text="Pull", click=function()
				self.show_hints = false
				self.sign_trousers = true
				msg.post("/randall", "set_state", {state=RANDALL_STATE.PRAISING_NO_PANTS})
				msg.post(self.zipper_sound_url, "play_sound")
				event_manager:register_event(3, function()
					self.divine_signs = self.divine_signs + 1
					msg.post(self.room_url, "divine_sign")
					update_context_entries(self)
					self.show_hints = true
				end)
			end})
		end
	end

	context_data[hash("room_bed")] = {
		{text="Inspect", click="My bed where I hide from this mean world!"}
	}
	if game_state.data.waiting_for_night then
		table.insert(context_data[hash("room_bed")], {
			text="Sleep", click=function()
				if not self.window_closed then
					msg.post("/balloon", "show_text", {delay = 4, text="I can't sleep with all this light comming from the outside.", character = "/randall", sound="#Randall_2"})
				else
					self.cutscenes.prolog_end(self, "sleep")
				end
			end
		})	
	end

end

return update_context_entries