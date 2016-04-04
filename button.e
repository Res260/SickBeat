note
	description: "An interface object used to make actions upon clicking it."
	author: "Guillaume Jean"
	date: "15 March 2016"
	revision: "16w07a"
	legal: "See notice at end of class."

class
	BUTTON

inherit
	TEXT
		rename
			make as make_text
		end

create
	make

feature {NONE} -- Initialization

	make(
			a_text: READABLE_STRING_GENERAL; a_color: GAME_COLOR; a_context: CONTEXT;
			a_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]
		)
			-- Basic creation of a {BUTTON}
		do
			make_text(a_text, a_color, a_context)
			button_action := a_action
		end

feature {NONE} -- Implementation

	button_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]
			-- Procedure called by the button when a click happens on the button

feature -- Access

	point_in_button(a_x, a_y: INTEGER): BOOLEAN
			-- Returns whether or not the point is in the button
		local
			l_result: BOOLEAN
		do
			if x < a_x and y < a_y and x + width > a_x and y + height > a_y then
				l_result := True
			end
			Result := l_result
		end

	do_click
			-- Procedure called when a click happens on the button
		do
			button_action(text)
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
