note
	description: "Abstract class used for any element drawn on the screen"
	author: "Guillaume Jean"
	date: "Mon, 14 March 2016 14:09"
	revision: "16w07a"

deferred class
	DRAWABLE

feature {NONE} -- Initialization

	make_drawable(a_x, a_y: INTEGER; a_texture: GAME_TEXTURE; a_window: GAME_WINDOW_RENDERED)
			-- Initializes drawable with the width and height of the texture
		do
			x := a_x
			y := a_y
			texture := a_texture
			window := a_window
			renderer := a_window.renderer
		end

feature {NONE} -- Implementation

	window: GAME_WINDOW_RENDERED
			-- Window where `Current' is drawn

	renderer: GAME_RENDERER
			-- Renderer used to draw `Current' in the window

feature -- Access

	x, y: INTEGER
			-- Position of `Current' in the screen from top left

	texture: detachable GAME_TEXTURE
			-- Texture of `Current'

	draw
			-- Draws `Current'
		do
			if attached texture as la_texture then
				renderer.draw_texture(la_texture, x, y)
			end
		end
end
