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
	make,
	make_movable

feature {NONE} -- Initialization

	make(a_texture: detachable GAME_TEXTURE)
			-- Initializes `Current' with `a_texture' to draw whenever `draw' is called
		do
			make_drawable(0, 0, a_texture)
			movable := False
		end

	make_movable(a_texture: detachable GAME_TEXTURE; a_size: TUPLE[width, height: INTEGER])
			-- Initializes `Current' with `a_texture' of fixed `a_size' that can be moved around on the `a_context' screen
		do
			make(a_texture)
			size := a_size
			movable := True
		end

feature {NONE} -- Implementation

	size: detachable TUPLE[width, height: INTEGER]
			-- Size of `Current'. Only used when movable.

	draw_movable(a_context: CONTEXT)
			-- Draws `Current' by scaling it to `Current' size
		require
			Is_Movable: movable
		do
			if attached texture as la_texture and attached size as la_size then
				a_context.renderer.draw_sub_texture_with_scale(la_texture, 0, 0, la_texture.width, la_texture.height,
								x - a_context.camera.position.x, y - a_context.camera.position.y, la_size.width, la_size.height)
			end
		end

feature -- Implementation

	movable: BOOLEAN
			-- Whether or not `Current' is not locked to fill the screen

	move(a_x, a_y: INTEGER)
			-- Move `Current' to (`a_x', `a_y')
		require
			Is_Movable: movable
		do
			x := a_x
			y := a_y
		ensure
			X_Moved: x = a_x
			Y_Moved: y = a_y
		end

	draw(a_context: CONTEXT)
			-- Draws `Current' by scaling it to the `a_context's window size
		do
			if movable then
				draw_movable(a_context)
			else
				if attached texture as la_texture then
					a_context.renderer.draw_sub_texture_with_scale(la_texture, 0, 0, la_texture.width, la_texture.height,
							-a_context.camera.position.x, -a_context.camera.position.y, a_context.window.width, a_context.window.height)
				end
			end
		end
invariant
	Size_If_Movable: movable implies attached size
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
