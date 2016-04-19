note
	description: "{MENU} implemented for the user to configure the game while playing."
	author: "Guillaume Jean"
	date: "24 March 2016"
	revision: "16w08a"
	legal: "See notice at end of class."

class
	MENU_PAUSE

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
			set_title("SickBeat - Pause")
			add_button("Return to game", agent return_action)
			add_button("Options", agent options_action)
			add_button("Leave to main menu", agent leave_action)
		end

feature {NONE} -- Implementation

	leave_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Play button
		do
			play_menu_sound_click
			io.put_string("Leave to main menu clicked!%N")
			return_to_main
		end

	options_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Options button
		do
			play_menu_sound_click
			io.put_string("Options clicked!%N")
		end

	return_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Exit button
		do
			play_menu_sound_click
			io.put_string("Return clicked!%N")
			return_menu
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
