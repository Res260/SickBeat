note
	description: "The options menu to display. Can control the sound."
	author: "Émilio Gonzalez"
	date: "2016-05-18"
	revision: "16w15a"

class
	MENU_OPTIONS

inherit
	MENU
		redefine
			make
		end
	SOUND_MANAGER_SHARED

create
	make,
	make_as_main

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialization of `Current'
		do
			Precursor(a_context)
			create network_engine.make
			set_title("SickBeat - Options")
			add_button("Volume (%%)", agent useless_action)
			add_textbox (buttons[buttons.count])
			add_button("Save changes", agent save_action)
			add_button("Return", agent return_action)
			textboxes[1].add_text ((sound_manager.master_volume*100).rounded.out)
		end

feature {NONE}

	network_engine: NETWORK_ENGINE
			-- The engine to manage network connections.

	save_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the 'Save changes' button.
		local
			l_text: STRING
			l_volume: INTEGER
		do
			play_menu_sound_click
			l_text := textboxes[1].text.text.as_string_8
			l_text.adjust
			if l_text.is_integer then
				l_volume := textboxes[1].text.text.to_integer
				if l_volume <= 100 then
					sound_manager.set_master_volume (l_volume / 100)
					if buttons.count > 3 then
						buttons.go_i_th (4)
						buttons.remove
					end
					add_button("Saved!", agent useless_action)
					on_redraw(1)
				else
					add_invalid
				end
			else
				add_invalid
			end
		end

	add_invalid
		do
			if buttons.count > 3 then
				buttons.go_i_th (4)
				buttons.remove
			end
			add_button("Invalid_volume!", agent useless_action)
			on_redraw(1)
		end

	return_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the Return button.
		do
			play_menu_sound_click
			return_menu
		end
end
