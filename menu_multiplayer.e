note
	description: "The multiplayer menu to display."
	author: "�milio Gonzalez"
	date: "2016-05-17"
	revision: "16w15a"

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
			add_textbox(buttons[2])
		end

feature {NONE}

	network_engine: NETWORK_ENGINE
			-- The engine to manage network connections.

	host_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Host button.
		do
			play_menu_sound_click
			create {MENU_LOADING_SCREEN} next_menu.make_multiplayer_host(context, network_engine)
			continue_to_next
		end

	join_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the join button.
		local
			l_ip: STRING
		do
			play_menu_sound_click
			l_ip := textboxes[1].text.text.to_string_8
			l_ip.right_adjust
			l_ip.left_adjust
			create {MENU_LOADING_SCREEN} next_menu.make_multiplayer(context, l_ip)
			return_menu
		end

	return_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Return button.
		do
			play_menu_sound_click
			return_menu
		end
end
