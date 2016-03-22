note
	description: "An interface object used to make actions upon clicking it."
	author: "Guillaume Jean"
	date: "15 March 2016"
	revision: "16w07a"

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
		do
			make_text(a_text, a_color, a_context)
			button_action := a_action
		end

feature {NONE} -- Implementation

	button_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]
			-- Procedure called by the button when a click happens on the button

feature -- Access

	do_click
			-- Procedure called when a click happens on the button
		do
			button_action(text)
		end
end
