note
	description: "Class implementing the {MENU_MAIN}."
	author: "Guillaume Jean"
	date: "Fri, 26 Feb 2016 12:34:56"
	revision: "1.0"

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

	make(a_window: GAME_WINDOW_RENDERED)
		do
			Precursor(a_window)
			set_title("SickBeat")
			add_button("Play")
			add_button("Options")
			add_button("Exit")
		end

feature -- Access

	is_play_clicked: BOOLEAN
		do
			Result := clicked_button = 1
		end

	is_exit_clicked: BOOLEAN
		do
			Result := clicked_button = 3
		end
end
