note
	description: "Summary description for {ENNEMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	legal: "See notice at end of class."

class
	ENNEMY

inherit
	ENTITY
		rename
			width as drawable_width,
			height as drawable_height
		redefine
			draw,
			update
		end
	BOUNDING_BOX

create
	make

feature {NONE} -- Initialization

	make(a_position: TUPLE[x, y: REAL_64]; a_texture: GAME_TEXTURE; a_color: GAME_COLOR)
			-- Initializes `Current' at `a_position', with `a_texture' and with `a_color'
		do
			color := a_color
			make_box(a_position.x - width / 2, a_position.y - height / 2, a_position.x + width / 2, a_position.y + height / 2)
			x := a_position.x.rounded
			y := a_position.y.rounded
			make_entity(a_position.x, a_position.y)
			texture := a_texture
		end

feature {NONE} -- Implementation

	width: REAL_64 = 40.0
			-- Width of `Current'

	height: REAL_64 = 40.0
			-- Height of `Current'

	color: GAME_COLOR
			-- Color of `Current'

feature -- Access

	draw(a_context: CONTEXT)
			-- Draws the ennemy on the screen
		do
			if attached texture as la_texture then
				a_context.renderer.draw_texture(la_texture, x - (la_texture.width // 2) - a_context.camera.position.x, y - (la_texture.height // 2) - a_context.camera.position.y)
			end
		end

	update(a_timediff: REAL_64)
		do

		end

	update_state(a_player: PLAYER)
		do

		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
