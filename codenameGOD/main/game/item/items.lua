local items = {
	data = {
		-- ROOM ITEMS --

		petrock = {
			name = "petrock",
			text = "Pet rock!",
			position = {x=984, y=274},
			image = "items1",
			scenario = "room",
			status = "show",
			found = 0,
			label = "A friendly pet rock.",
			movable = true
		},
		coins = {
			name = "coins",
			text = "This might come in handy!",
			position = {x=380, y=214},
			image = "items2",
			scenario = "room",
			status = "hide",
			found = 0,
			label = "Some coins.",
			movable = true
		},
		ticket = {
			name = "ticket",
			text = "Ticket",
			position = {x=256, y=360},
			image = "items3",
			scenario = "room",
			status = "show",
			found = 0,
			label = "A ticket.",
			movable = true
		},
		shoe1 = {
			name = "shoe1",
			text = "Shoe",
			position = {x=262, y=98},
			image = "items4",
			scenario = "room",
			status = "show",
			found = 0,
			label = "This is the left shoe.",
			movable = true
		},
		shoe2 = {
			name = "shoe2",
			text = "Shoe",
			position = {x=814, y=159},
			image = "items5",
			scenario = "room",
			status = "show",
			found = 0,
			label = "This is the right shoe.",
			movable = true
		}
		-- END OF ROOM ITEMS
	}
}

items.load_save = function()
	local loaded_data = persistence.load_table("items.save")
	if loaded_data then
		items.data = loaded_data
	end
end

return items