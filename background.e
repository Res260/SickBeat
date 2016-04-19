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

	make(a_texture: detachable GAME_TEXTURE; a_context: CONTEXT)
			-- Initializes `Current' as a {BACKGROUND} that fills the screen
		do
			make_drawable(0, 0, a_texture, a_context)
			movable := False
		end

	make_movable(a_texture: detachable GAME_TEXTURE; a_size: TUPLE[width, height: INTEGER]; a_context: CONTEXT)
			-- Initializes `Current' as a {BACKGROUND} of fixed size that can be moved around
		do
			make(a_texture, a_context)
			size := a_size
			movable := True
		end

feature {NONE} -- Implementation

	size: detachable TUPLE[width, height: INTEGER]
			-- Size of the background. Only used when movable.

	draw_movable
			-- Draws the background by scaling it to `Current' size
		require
			Is_Movable: movable
		do
			if attached texture as la_texture and attached size as la_size then
				context.renderer.draw_sub_texture_with_scale(la_texture, 0, 0, la_texture.width, la_texture.height,
								x - context.camera.position.x, y - context.camera.position.y, la_size.width, la_size.height)
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

	draw
			-- Draws the background by scaling it to the window size
		do
			if movable then
				draw_movable
			else
				if attached texture as la_texture then
					context.renderer.draw_sub_texture_with_scale(la_texture, 0, 0, la_texture.width, la_texture.height,
							-context.camera.position.x, -context.camera.position.y, context.window.width, context.window.height)
				end
			end
		end
invariant
	Size_If_Movable: movable implies attached size
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
