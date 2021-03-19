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
	drawer_opened = false,
	ticket_moved = false
}