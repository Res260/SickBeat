note
	description: "Class implementing the {MENU_MAIN}."
	author: "Guillaume Jean"
	date: "Fri, 26 Feb 2016 12:34:56"
	revision: "16w06a"

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
		end

	options_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Options button
		do
			io.put_string("Options clicked!%N")
		end

	exit_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Exit button
		do
			io.put_string("Exit clicked!%N")
			request_exit
		end

feature -- Access

	is_play_clicked: BOOLEAN
		do
			Result := clicked_button = 1
		end

	is_option_clicked: BOOLEAN
		do
			Result := clicked_button = 2
		end

	is_exit_clicked: BOOLEAN
		do
			Result := clicked_button = 3
		end
end
