note
	description: "{MENU} implemented for the user to decide whether he's playing or configuring the game."
	author: "Guillaume Jean"
	date: "21 March 2016"
	revision: "16w08b"
	legal: "See notice at end of class."

class
	MENU_MAIN

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
			set_title("SickBeat")
			add_button("Play", agent play_action)
			add_button("Options", agent options_action)
			add_button("Exit", agent exit_action)
			play_menu_music
		end

feature {NONE} -- Implementation

	play_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Play button
		do
			io.put_string("Play clicked!%N")
			sound_manager.set_master_volume (1)
			create {MENU_PLAY} next_menu.make(context)
			play_menu_sound_click
			continue_to_next
		end

	options_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Options button
		do
			play_menu_sound_click
			io.put_string("Options clicked!%N")
		end

	exit_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Exit button
		do
			play_menu_sound_click
			io.put_string("Exit clicked!%N")
			close_program
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
