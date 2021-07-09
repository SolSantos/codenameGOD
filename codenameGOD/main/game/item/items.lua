local items = {
	data = {
		-- ROOM ITEMS --

		petrock = {
			name = "petrock",
			text = "Pet rock!",
			position = {x=974, y=224},
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
		briefs = {
			name = "briefs",
			text = "Briefs",
			position = {x=320, y=108},
			image = "briefs",
			scenario = "room",
			status = "show",
			found = 0,
			label = "My briefs!",
			movable = true
		},
		shoe1 = {
			name = "shoe1",
			text = "Shoe",
			position = {x=343, y=98},
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
		},
		-- HOUSE FRONT Items
		cd = {
			name = "cd_case",
			text = "A CD by Jon Bovi",
			position = {x=800, y=360},
			image = "items9",
			scenario = "house_front",
			status = "hide",
			found = 0,
			label = "A CD by a band called Jon Bovi.",
			movable = true
		},
		-- CITY CENTER items
		pepsi = {
			name = "pepsi",
			text = "A pepsi can",
			position = {x=306, y=206},
			image = "items8",
			scenario = "city_center",
			status = "hide",
			found = 0,
			label = "A probably stale can of pepsi.",
			movable = true
		}
	}
}

items.load_save = function()
	local loaded_data = persistence.load_table("items.save")
	if loaded_data then
		items.data = loaded_data
	end
end

return items