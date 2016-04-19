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
		redefine
			change
		end
	BOUNDING_BOX

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
			make_box(0, 0, 0, 0)
		end

feature {NONE} -- Implementation

	button_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]
			-- Procedure called by the button when a click happens on the button

feature -- Access

	change(a_x, a_y, a_font_size: INTEGER)
			-- Updates the bounding box
		do
			Precursor(a_x, a_y, a_font_size)
			lower_corner.x := x
			lower_corner.y := y
			upper_corner.x := x + width
			upper_corner.y := y + height
		end

	do_click
			-- Procedure called when a click happens on the button
		do
			button_action(text)
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
