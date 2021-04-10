return {
	-- Check if the game has cleared the introductory cutscene
	intro_done = false,
	-- Check if the game is at "playable" phase - 'true' means randall can move around/interact, and 'false' means...well he can't
	in_gameplay = false,
	-- Check if Randall is wearing his shoes
	both_shoes = false,
	-- Check if first puzzle is completed
	allowed_leave = false,
	first_item_picked = false,
	-- Tells if we already opened the drawer in the room and saw the coins
	coins_shown = false,
	ticket_moved = false,
	-- The player came back to room after the bullies steal his ticket
	comming_from_bullies = false,
	-- Randall is waiting for a sign from god
	awaiting_signal = false
}