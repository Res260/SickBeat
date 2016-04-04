note
	description: "Implementation of {DRAWABLE} for drawing text."
	author: "Guillaume Jean"
	date: "22 March 2016"
	revision: "16w08a"
	legal: "See notice at end of class."

class
	TEXT

inherit
	DRAWABLE

create
	make

feature {NONE} -- Initialization

	make(a_text: READABLE_STRING_GENERAL; a_color: GAME_COLOR; a_context: CONTEXT)
			-- Initialization of `Current' with a string and a color
		do
			make_drawable(0, 0, Void, a_context)
			text := a_text
			text_color := a_color
		end

feature {NONE} -- Implementation

	text_color: GAME_COLOR
			-- Text color for `Current'

feature -- Access

	text: READABLE_STRING_GENERAL assign set_text
			-- String of the text used when drawing

	change(a_x, a_y, a_font_size: INTEGER)
			-- Change `Current's position to specified x, y and font_size
			-- Recreates the text {GAME_TEXTURE}
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
			end
		end

	set_text(a_text: READABLE_STRING_GENERAL)
		do
			text := a_text
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
