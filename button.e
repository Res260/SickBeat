note
	description: "An interface object used to make actions upon clicking it."
	author: "Guillaume Jean"
	date: "Tue, 15 March 2016 09:50"
	revision: "16w07a"

class
	BUTTON

inherit
	DRAWABLE
		redefine
			draw
		end

feature {NONE} -- Initialization

	make(a_x, a_y: INTEGER; a_texture: GAME_TEXTURE; a_window: GAME_WINDOW_RENDERED; a_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]])
		do

		end

feature -- Implementation

	button_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]

feature -- Access


end
