note
	description: "Abstract class used for any element drawn on the screen"
	author: "Guillaume Jean"
	date: "14 March 2016"
	revision: "16w07a"

deferred class
	DRAWABLE

feature {NONE} -- Initialization

	make_drawable(a_x, a_y: INTEGER; a_texture: detachable GAME_TEXTURE; a_context: CONTEXT)
			-- Initializes the {DRAWABLE} with the width and height of the {GAME_TEXTURE}
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
			-- Position of `Current' in the screen from top left in pixels

	width: INTEGER
			-- Width of `Current'
		local
			l_width: INTEGER
		do
			if attached texture as la_texture then
				l_width := la_texture.width
			else
				l_width := 0
			end
			Result := l_width
		end

	height: INTEGER
			-- Height of `Current'
		local
			l_height: INTEGER
		do
			if attached texture as la_texture then
				l_height := la_texture.height
			else
				l_height := 0
			end
			Result := l_height
		end

	texture: detachable GAME_TEXTURE
			-- Texture to draw

	draw
			-- Draws `Current's texture if it exists
		do
			if attached texture as la_texture then
				context.renderer.draw_texture(la_texture, x, y)
			end
		end
end
