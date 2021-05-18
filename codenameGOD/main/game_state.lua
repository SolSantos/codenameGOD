local game_state = {
	data = {
		-- Starting place in the game
		current_map = "room",
		randall_pos = {x=590, y=356},
		-- Check if the game has cleared the introductory cutscene
		intro_done = false,
		-- Check if the game is at "playable" phase - 'true' means randall can move around/interact, and 'false' means...well he can't
		in_gameplay = false,
		-- Check if Randall is wearing his shoes
		both_shoes = false,
		-- Check if first puzzle is completed
		allowed_leave = false,
		-- First item picked in the game will display an arrow to the inventory
		first_item_picked = false,
		-- Tells if we already opened the drawer in the room and saw the coins
		coins_shown = false,
		-- Tells if the player has leaved the at least once
		leaved_house_once = false,
		-- The player came back to room after the bullies steal his ticket
		comming_from_bullies = false,
		-- Randall is waiting for a sign from god
		awaiting_signal = false,
		-- Name of the player
		god_name = nil,
		-- State of the day ("day" or "night")
		day_state = "day",
		-- Tells us if the player is in the waiting for night puzzle
		waiting_for_night = false
	}
}

game_state.load_save = function()
	local loaded_data = persistence.load_table("state.save")
	if loaded_data then
		game_state.data = loaded_data
	end
end

return game_state