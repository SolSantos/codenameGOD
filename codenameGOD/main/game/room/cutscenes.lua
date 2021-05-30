local game_state = require("main.game_state")
local update_context_entries = require("main.game.room.context_data")
local ouija_mode = require("main.game.room.ouija_mode")

return {
	intro=function(self)
		msg.post("/randall", "set_state", {state=RANDALL_STATE.LYING_DOWN})
		msg.post("/collections#main", "stop_game")
		msg.post("/cutscene#cutscene", "cutscene_start")
		msg.post("/randall", "sleep")
		event_manager:register_event(6, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="Randall, wake up!! \nYou're gonna be late for school!", character = self.bro_url, sound="#Bullies_4", skip=true})
			msg.post("/randall", "wakeup")
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="It's Saturday! I'm not falling for that again Travis!", character="/randall", sound="#Randall_1", skip=true})
		end)

		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=2.5, text="Whatever, turd!", character = self.bro_url, sound="#Bullies_2", skip=true})
		end)

		event_manager:register_event(2.5, function(_, id)
			msg.post("/balloon", "show_text", {delay=4, text="Sigh...\nHe's such a douche...", character="/randall", sound="#Randall_short2", skip=true})
		end)

		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=1.5, text="Oh no!", sound="#Randall_panic1", character="/randall", skip=true})
		end)

		event_manager:register_event(1.5, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="I'm gonna be late for the annual \nSorcery: The congregation annual tournament!", character="/randall", skip=true})
		end)

		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="Gotta find my shoes before I leave...\nAnd my ticket!", character="/randall", sound="#Randall_4"})
		end)

		event_manager:register_event(4.5, function(_, id)
			msg.post("/transition", "play_transition")
		end)
		event_manager:register_event(1.25, function(_, id)
			go.set_position(vmath.vector3(520,300,go.get_position("/randall").z), "/randall")
			msg.post("/randall", "set_state", {state=RANDALL_STATE.SHOELESS})
			msg.post("/collections#main", "stop_game")
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/collections#main", "restart_game")
			msg.post("/cutscene#cutscene", "cutscene_end")
			game_state.data.intro_done = true
			game_state.data.in_gameplay = true
			self.show_hints = true
		end)
	end,
	ready_for_tournament=function(self)
		event_manager:register_event(1, function(_, id)
			msg.post("/balloon", "show_text", {delay = 4, text="Alright! Time to bounce out of here!", character = "/randall", sound="#Randall_1"})
		end)
	end,
	back_from_bullies=function(self)
		msg.post("/collections#main", "stop_game")
		msg.post("/cutscene#cutscene", "cutscene_start")
		local door_pos = vmath.vector3(922, 400, 0.2)
		event_manager:register_event(0, function(_, id)
			go.set_position(door_pos, "/randall")
			msg.post("/randall", "go_to", {pos=vmath.vector3(850, 280, 0.2), duration=3})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/randall", "go_to", {pos=vmath.vector3(540, 280, 0.2), duration=5})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/randall#sprite", "play_animation", {id=hash("sad_start")})
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/randall#sprite", "play_animation", {id=hash("sad_idle")})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/randall#sprite", "play_animation", {id=hash("sad_end")})
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="That was just so weird, what just happened...", character = "/randall", sound="#Randall_6", skip=true})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="Even earlier with my shoes... and then my ticket...", character = "/randall", sound="#Randall_5", skip=true})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="Could it be!? Perhaps I'm not alone!?", character = "/randall", sound="#Randall_panic1", skip=true})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=8, text="Something feels off. All these seemingly well-timed events... I didn't even get wedgied! My boys were finally sparred for once!", character = "/randall", sound="#Randall_3", skip=true})
		end)
		event_manager:register_event(9, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="This can only be explained by the works of... of...", character = "/randall", sound="#Randall_4", skip=true})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="A GOD!!!!!!!!!!", character = "/randall", sound="#Randall_panic2", skip=true})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay=4, text="... I think.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/balloon", "show_text", {delay=4, text="Oh, mighty god!", character = "/randall", sound="#Randall_panic1", skip=true})
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/balloon", "show_text", {delay=5, text="If you truly are there, please, PLEASE give me a sign!", character = "/randall", sound="#Randall_4"})
			msg.post("/randall", "set_state", {state=RANDALL_STATE.PRAISING})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/cutscene#cutscene", "cutscene_end")
			msg.post("/collections#main", "restart_game")
			self.show_hints = true
			game_state.data.comming_from_bullies = false
			game_state.data.awaiting_signal = true
			game_state.data.in_gameplay = true
			update_context_entries(self)
		end)
	end,
	ouija_cutscene=function(self)
		game_state.data.in_gameplay = false
		msg.post("/collections#main", "stop_game")
		msg.post("/cutscene#cutscene", "cutscene_start")
		event_manager:register_event(2, function(_, id)
			msg.post("/balloon", "show_text", {delay = 2, text="Dude.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 2, text="Oh.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 1, text="My.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 1, text="God.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 2, text="Literally.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 3, text="This is great! You're like the Yoda to my Luke.", character = "/randall", sound="#Randall_3", skip=true})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 2, text="The E.T. to my Elliot.", character = "/randall", sound="#Randall_short1", skip=true})
		end)
		event_manager:register_event(1.5, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 1.5, text="Spock to my Kirk.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(1.5, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 1.5, text="Gandalf to my Frodo.", character = "/randall", sound="#Randall_short2", skip=true})
		end)
		event_manager:register_event(1.5, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 3, text="The Doctor to my...whichever assistant is on TV now.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/balloon", "show_text", {delay = 1.5, text="The old man to my Link.", character = "/randall", sound="#Randall_short4", skip=true})
		end)
		event_manager:register_event(1.5, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 3, text="...Ok, I'll shut up now.", character = "/randall", sound="#Randall_short3", skip=true})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 3, text="But wait, I can't keep calling you God.", character = "/randall", sound="#Randall_1", skip=true})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/balloon", "show_text", {delay = 3, text="What if you have an actual name? Like Rob?", character = "/randall", sound="#Randall_2", skip=true})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 3, text="Are you named Robert? Should I call you Robbie?", character = "/randall", sound="#Randall_3", skip=true})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 7, text="I know! This is the perfect time to bring out the ol' Ouija Board for some assistance!", character = "/randall", sound="#Randall_panic1", skip=true})
		end)
		event_manager:register_event(7, function(_, id)
			msg.post("/balloon",  "show_text", {delay = 5, text="Finally, a reason to put the Wija board to good use...", character = "/randall", sound="#Randall_1", skip=true})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay = 4, text="Now, first we gotta do some setup...", character = "/randall", sound="#Randall_panic2"})
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/transition", "play_transition")
			msg.post("/god", "turn_dark")
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/randall", "set_state", {state=RANDALL_STATE.NORMAL})
			msg.post(self.telescope_url, "disable")
			msg.post(self.tv_url, "disable")
			msg.post(self.nintendo_url, "disable")
			msg.post("/inventory", "disable")
			msg.post(self.ouija_url, "enable")
			self.window_closed = true
			self.refresh_window(self)
			
			go.set_position(vmath.vector3(850, 250, 0.2), "/randall")
			msg.post("/randall", "set_state", {state=RANDALL_STATE.WIZARD_HAT})
			msg.post("/god", "show_light", {x=976 / WIDTH, y=202 / HEIGHT, radius=0.1})
			msg.post(self.candle_url, "enable")
		end)
		event_manager:register_event(3, function(_, id)
			ouija_mode.init(self)
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/cutscene#cutscene", "cutscene_end")
			msg.post("/collections#main", "restart_game")

			-- Disable other possible interactions 
			msg.post("/context_menu", "disable_context_menu")
			msg.post("/item_manager", "stop_game")
		end)
	end,
	god_name_selected = function(self)
		local balloon_pos = vmath.vector3(1010, 260, 1)
		game_state.data.in_gameplay = false
		msg.post("/collections#main", "stop_game")
		msg.post("/cutscene#cutscene", "cutscene_start")
		if game_state.data.god_name == "ASS" or game_state.data.god_name == "DICK" or game_state.data.god_name == "PENIS" or game_state.data.god_name == "BALLS" or game_state.data.god_name == "FART"  then
			event_manager:register_event(2, function(_, id)
				msg.post("/balloon", "show_text", {delay=7, text = "...Wait... that name....you must be a 10 year old with that sense of humor!", character = "/randall", sound="#Randall_2", skip=true, no_arrow=true, pos=balloon_pos})
			end)
		elseif game_state.data.god_name == "LINK" or game_state.data.god_name == "MARIO" or game_state.data.god_name == "SAMUS" or game_state.data.god_name == "METROID"  or game_state.data.god_name == "SONIC" or game_state.data.god_name == "CLOUD" then
			event_manager:register_event(2, function(_, id)
				msg.post("/balloon", "show_text", {delay=7, text = "...I feel like I know that name from somewhere. Huh.", character = "/randall", sound="#Randall_2", skip=true, no_arrow=true, pos=balloon_pos})
			end)
		elseif game_state.data.god_name == "AAA" or game_state.data.god_name == "MAN" then
			event_manager:register_event(2, function(_, id)
				msg.post("/balloon", "show_text", {delay=4, text = "A classic directly from the arcades!", character = "/randall", sound="#Randall_2", skip=true, no_arrow=true, pos=balloon_pos})
			end)
		end
		event_manager:register_event(7, function(_, id)
			msg.post("/balloon", "show_text", {delay = 6, text="Wow! I never would have thought that a God could have such a name as "..game_state.data.god_name..".", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(6, function(_, id)
			msg.post("/balloon", "show_text", {delay = 5, text="Goes to show how little we know about the world still.", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay = 1, text="...", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/balloon", "show_text", {delay = 1, text="...", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/balloon", "show_text", {delay = 6, text="You know, earlier today, those bullies of mine were talking about Becky--", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(6, function(_, id)
			msg.post("/balloon", "show_text", {delay = 5, text="Oh, Becky is just this girl I... sorta... like.", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(5, function(_, id)
			msg.post("/balloon", "show_text", {delay = 6, text="Anyway, it seems she's throwing a party tonight! And it will definitely be at the local club.", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(6, function(_, id)
			msg.post("/balloon", "show_text", {delay = 4, text="If a God called "..game_state.data.god_name.." really is beside me...", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/balloon", "show_text", {delay = 6, text="Then with his assistance I'm sure to finally win Becky's heart and show Scott's gang who's boss!", character = "/randall", sound="#Randall_short4", skip=true, no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(6, function(_, id)
			msg.post("/balloon", "show_text", {delay = 4, text="Now I just have to wait until nightfall.", character = "/randall", sound="#Randall_short4", no_arrow=true, pos=balloon_pos})
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/transition", "play_transition")
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/god", "back_to_day")

			msg.post(self.telescope_url, "enable")
			msg.post(self.tv_url, "enable")
			msg.post(self.nintendo_url, "enable")
			msg.post("/inventory", "enable")
			msg.post("/inventory", "inv_close")

			msg.post(self.ouija_url, "disable")
			msg.post(self.big_ouija_url, "disable")
			msg.post(self.randall_arms_url, "disable")
			msg.post(self.candle_url, "disable")
			
			msg.post("/context_menu", "enable_context_menu")
			msg.post("/cutscene#cutscene", "cutscene_end")
			msg.post("/collections#main", "restart_game")

			game_state.data.awaiting_signal = false
			game_state.data.waiting_for_night = true
			update_context_entries(self)
		end)
	end,
	prolog_end = function(self)
		event_manager:register_event(1, function(_, id)
			msg.post("/transition", "play_transition")
		end)
		event_manager:register_event(1, function(_, id)
			go.set_position(vmath.vector3(590,356,0.2), "/randall")
			msg.post("/randall", "set_state", {state=RANDALL_STATE.LYING_DOWN})

			game_state.data.day_state = "night"
			game_state.data.stage = game_state.stages.BECKY_PARTY
			game_state.data.waiting_for_night = false

			msg.post("/collections#main", "checkpoint")
			self.refresh_window(self)
			update_context_entries(self)

			msg.post("/god", "turn_dark")
			msg.post("/cutscene#cutscene", "cutscene_start")
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/transition", "play_transition")
		end)
		event_manager:register_event(1, function(_, id)
			msg.post("/god", "back_to_day")
			self.cutscenes.wakeup_at_night(self)
		end)
	end,
	prolog_end = function(self)
		event_manager:register_event(1, function(_, id)
			msg.post("/transition", "play_transition")
		end)
		event_manager:register_event(1, function(_, id)
			go.set_position(vmath.vector3(590,356,0.2), "/randall")
			msg.post("/randall", "set_state", {state=RANDALL_STATE.LYING_DOWN})

			game_state.data.day_state = "night"
			game_state.data.stage = game_state.stages.BECKY_PARTY
			game_state.data.waiting_for_night = false

			msg.post("/collections#main", "checkpoint")
			self.refresh_window(self)
			update_context_entries(self)

			msg.post("/god", "turn_dark")
			msg.post("/cutscene#cutscene", "cutscene_start")
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/transition", "play_chapter_transition", {
				title="Chapter 2", description="Party Time", fade=0.5, fade_back=1
			})
		end)
		event_manager:register_event(4, function(_, id)
			msg.post("/god", "back_to_day")
			self.cutscenes.wakeup_at_night(self)
		end)
	end,
	wakeup_at_night = function(self)
		event_manager:register_event(0, function(_, id)
			go.set_position(vmath.vector3(520,300,go.get_position("/randall").z), "/randall")
			msg.post("/randall", "set_state", {state=RANDALL_STATE.NORMAL})
		end)
		event_manager:register_event(2, function(_, id)
			msg.post("/balloon", "show_text", {delay = 3, text="Ok, it's night.", character = "/randall", sound="#Randall_short3", skip=true})
		end)
		event_manager:register_event(3, function(_, id)
			msg.post("/balloon", "show_text", {delay = 3, text="Let's go to that party!", character = "/randall", sound="#Randall_short2"})
			msg.post("/cutscene#cutscene", "cutscene_end")
		end)
	end
}