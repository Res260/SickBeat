note
	description: "Abstract class used for any element drawn on the screen"
	author: "Guillaume Jean"
	date: "Mon, 14 March 2016 14:09"
	revision: "16w07a"

deferred class
	DRAWABLE

feature {NONE} -- Initialization

	make_drawable(a_x, a_y: INTEGER; a_texture: GAME_TEXTURE; a_context: CONTEXT)
			-- Initializes drawable with the width and height of the texture
		do
			x := a_x
			y := a_y
			texture := a_texture
			context := a_context
		end

feature {NONE} -- Implementation

	context: CONTEXT
			-- Current application's context

feature -- Access

	x, y: INTEGER
			-- Position of `Current' in the screen from top left

	texture: detachable GAME_TEXTURE
			-- Texture of `Current'

	draw
			-- Draws `Current'
		do
			if attached texture as la_texture then
				context.renderer.draw_texture(la_texture, x, y)
			end
		end
end
