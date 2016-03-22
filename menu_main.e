note
	description: "{MENU} implemented for the user to decide whether he's playing or configuring the game."
	author: "Guillaume Jean"
	date: "21 March 2016"
	revision: "16w08b"

class
	MENU_MAIN

inherit
	MENU
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
		do
			Precursor(a_context)
			set_title("SickBeat")
			add_button("Play", agent play_action)
			add_button("Options", agent options_action)
			add_button("Exit", agent exit_action)
		end

feature {NONE} -- Implementation

	play_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Play button
		do
			io.put_string("Play clicked!%N")
			create {MENU_PLAY} next_menu.make(context)
			continue_to_next
		end

	options_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Options button
		do
			io.put_string("Options clicked!%N")
--			menu_audio_source.queue_sound(menu_sound)
--			menu_audio_source.play
		end

	exit_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Exit button
		do
			io.put_string("Exit clicked!%N")
			close_program
		end
end
