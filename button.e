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
			-- Initializes `Current' with text `a_text' of `a_color' color to draw in `a_context's screen to do `a_action' when clicked
		do
			make_text(a_text, a_color, a_context)
			button_action := a_action
			make_box(0, 0, 0, 0)
		end

feature {NONE} -- Implementation

	button_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]
			-- Procedure called by the button when a click happens on `Current'

feature -- Access

	change(a_x, a_y, a_font_size: INTEGER)
			-- Changes `Current's coordinates to (`a_x', `a_x') and `Current's font size to `a_font_size'
		do
			Precursor(a_x, a_y, a_font_size)
			lower_corner.x := x
			lower_corner.y := y
			upper_corner.x := x + width
			upper_corner.y := y + height
		ensure then
			Lower_Corner_Set: lower_corner.x = x and lower_corner.y = y
			Upper_Corner_Set: upper_corner.x = x + width and upper_corner.y = y + height
		end

	do_click
			-- Called when a click happens on `Current'
		do
			button_action(text)
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
