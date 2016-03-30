note
	description: "{MENU} implemented for the user to decide the mode to play on."
	author: "Guillaume Jean"
	date: "21 March 2016"
	revision: "16w08a"
	legal: "See notice at end of class."

class
	MENU_PLAY

inherit
	MENU
		redefine
			make
		end

create
	make,
	make_as_main

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialization of `Current'
		do
			Precursor(a_context)
			set_title("SickBeat - Play")
			add_button("Singleplayer", agent singleplayer_action)
			add_button("Multiplayer", agent multiplayer_action)
			add_button("Return", agent return_action)
		end

feature {NONE} -- Implementation

	singleplayer_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Singleplayer button
		do
			io.put_string("Singleplayer clicked!%N")
			create {GAME_ENGINE} next_menu.make(context)
			continue_to_next
		end

	multiplayer_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Multiplayer button
		do
			io.put_string("Multiplayer clicked!%N")
		end

	return_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Return button
		do
			io.put_string("Return clicked!%N")
			return_menu
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
