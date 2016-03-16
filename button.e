note
	description: "An interface object used to make actions upon clicking it."
	author: "Guillaume Jean"
	date: "Tue, 15 March 2016 09:50"
	revision: "16w07a"

class
	BUTTON

inherit
	DRAWABLE

create
	make

feature {NONE} -- Initialization

	make(a_x, a_y: INTEGER; a_name: READABLE_STRING_GENERAL; a_texture: GAME_TEXTURE; a_window: GAME_WINDOW_RENDERED; a_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]])
		do
			make_drawable(a_x, a_y, a_texture, a_window)
			button_action := a_action
			name := a_name
		end

feature {NONE} -- Implementation

	name: READABLE_STRING_GENERAL
			-- Name of the button used for identifying

	button_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]
			-- Procedure called by the button when a click happens on the button

feature -- Access

	do_click
			-- Procedure called when a click happens on the button
		do
			button_action(name)
		end
end
