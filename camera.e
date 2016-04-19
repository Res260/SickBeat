note
	description: "Reference point for drawing objects."
	author: "Guillaume Jean"
	date: "4 April 2016"
	revision: "16w09a"

class
	CAMERA

create
	make

feature {NONE} -- Initialization

	make(a_x, a_y: INTEGER)
			-- Initializes `Current'
		do
			position := [a_x, a_y]
		end

feature -- Access

	position: TUPLE[x, y: INTEGER]
			-- Position of `Current'

	move_to_position(a_position: TUPLE[x, y: INTEGER]; a_window: GAME_WINDOW_RENDERED)
			-- Move `position' to `a_position' and center on window
		do
			position.x := a_position.x - a_window.width // 2
			position.y := a_position.y - a_window.height // 2
		end

	move_at_entity(a_entity: ENTITY; a_window: GAME_WINDOW_RENDERED)
			-- Move `position' to `a_entity's position and center on window
		do
			position.x := a_entity.x - a_window.width // 2
			position.y := a_entity.y - a_window.height // 2
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
