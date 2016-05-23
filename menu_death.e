note
	description: "{MENU} showing the player's final score and returning him to main_menu"
	author: "Guillaume Jean"
	date: "2016-05-22"
	revision: "16w16a"

class
	MENU_DEATH

inherit
	MENU

create
	make_with_score

feature {NONE} -- Initialization

	make_with_score(a_score: INTEGER; a_is_multiplayer: BOOLEAN; a_context: CONTEXT)
			-- Initializes `Current' to display `a_score'
		do
			make(a_context)
			is_multiplayer := a_is_multiplayer
			set_title("You Died! - Final Score: " + a_score.to_hex_string + " (" + a_score.out + ")")
			add_button("Try again", agent try_again_action)
			add_button("Leave to main menu", agent leave_action)
		end

feature {NONE} -- Implementation

	is_multiplayer: BOOLEAN
			-- Whether or not the game was multiplayer

	try_again_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Try again button
		do
			if is_multiplayer then
				create {MENU_MULTIPLAYER} next_menu.make(context)
				return_to_main
			else
				create {MENU_LOADING_SCREEN} next_menu.make(context)
				return_to_main
			end
		end

	leave_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Leave button
		do
			play_menu_sound_click
			return_to_main
		end

end
