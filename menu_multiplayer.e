note
	description: "The multiplayer menu to display."
	author: "Émilio Gonzalez"
	date: "2016-05-03"
	revision: "16w13a"

class
	MENU_MULTIPLAYER

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
			create network_engine.make
			set_title("SickBeat - Multiplayer")
			add_button("Host", agent host_action)
			add_button("Join", agent join_action)
			add_button("Return", agent return_action)
		end

feature {NONE}

	network_engine: NETWORK_ENGINE
			-- The engine to manage network connections.

	host_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Host button.
		do
			play_menu_sound_click
			io.put_string("Host clicked!%N")
			create {MENU_LOADING_SCREEN} next_menu.make_multiplayer_host(context, network_engine)
			continue_to_next
		end

	join_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the join button.
		do
			play_menu_sound_click
			io.put_string("Join clicked!%N")
--			create {GAME_ENGINE} next_menu.make_multiplayer(context, void)
			return_menu
		end

	return_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Return button.
		do
			play_menu_sound_click
			io.put_string("Return clicked!%N")
			return_menu
		end
end
