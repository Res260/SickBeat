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

	make(
			a_text: READABLE_STRING_GENERAL; a_color: GAME_COLOR; a_context: CONTEXT;
			a_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]
		)
		do
			make_drawable(0, 0, Void, a_context)
			button_action := a_action
			text := a_text
			text_color := a_color
		end

feature {NONE} -- Implementation

	text_color: GAME_COLOR
			-- Text color for `Current'

	text: READABLE_STRING_GENERAL
			-- Text of the button used when drawing and identifying

	button_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]]
			-- Procedure called by the button when a click happens on the button

feature -- Access

	change(a_x, a_y, a_font_size: INTEGER)
			-- Change `Current's position to specified x and y
		local
			l_font: TEXT_FONT
			l_text_surface: TEXT_SURFACE_BLENDED
		do
			x := a_x
			y := a_y
			l_font := context.ressource_factory.menu_font(a_font_size)
			create l_text_surface.make(text, l_font, text_color)
			if l_text_surface.is_open then
				create texture.make_from_surface(context.renderer, l_text_surface)
			else
				has_error := True
			end
		end

	do_click
			-- Procedure called when a click happens on the button
		do
			button_action(text)
		end
end
