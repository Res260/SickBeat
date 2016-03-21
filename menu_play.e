note
	description: "{MENU} implemented for the user to decide the mode to play on."
	author: "Guillaume Jean"
	date: "Mon, 21 Mar 2016 13:45"
	revision: "16w08a"

class
	MENU_PLAY

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
			set_title("SickBeat - Play")
			add_button("Singleplayer", agent singleplayer_action)
			add_button("Multiplayer", agent multiplayer_action)
			add_button("Return", agent return_action)
		end

feature {NONE} -- Implementation

	singleplayer_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Play button
		do
			io.put_string("Singleplayer clicked!%N")
		end

	multiplayer_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Options button
		do
			io.put_string("Multiplayer clicked!%N")
		end

	return_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Exit button
		do
			io.put_string("Return clicked!%N")
			stop
		end
end
