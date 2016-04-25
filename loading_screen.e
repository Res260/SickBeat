note
	description: "Summary description for {LOADING_SCREEN}."
	author: "Émilio G!"
	date: "2016-04-25"
	revision: "16w12a"

class
	MENU_LOADING_SCREEN
inherit
	MENU
		redefine
			make,
			on_restart
		end
create
	make,
	make_as_main

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialization of `Current'
		do
			Precursor(a_context)
			set_title("SickBeat - Waiting for miracles")
			add_button("Bouton inutile", agent useless_action)
		end

	on_restart
			-- Where the game starts loading
		do
			Precursor
			create {GAME_ENGINE} next_menu.make(context)
			continue_to_next
		end

	useless_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the useless button
		do
			play_menu_sound_click
			io.put_string("Useless button clicked! Bravo champion%N")
			continue_to_next
		end


end
