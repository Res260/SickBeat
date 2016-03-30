note
	description: "A {DRAWABLE} scaled to fit the whole window."
	author: "Guillaume Jean"
	date: "15 March 2016"
	revision: "16w07a"
	legal: "See notice at end of class."

class
	BACKGROUND

inherit
	DRAWABLE
		redefine
			draw
		end

create
	make

feature {NONE} -- Initialization

	make(a_texture: detachable GAME_TEXTURE; a_context: CONTEXT)
		do
			make_drawable(0, 0, a_texture, a_context)
		end

feature -- Implementation

	draw
			-- Draws the background by scaling it to the window size
		do
			if attached texture as la_texture then
				context.renderer.draw_sub_texture_with_scale(la_texture, 0, 0, la_texture.width, la_texture.height,
															     		 0, 0, context.window.width, context.window.height)
			end
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
