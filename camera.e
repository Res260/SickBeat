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

	make(a_x, a_y: INTEGER; a_context: CONTEXT)
			-- Initializes `Current'
		do
			create position
			position.x := a_x
			position.y := a_y
			context := a_context
		end

feature {NONE} -- Implementation

	context: CONTEXT
			-- Context of the current running application

feature -- Access

	position: TUPLE[x, y: INTEGER]
			-- Position of `Current'

	move_to_position(a_position: TUPLE[x, y: INTEGER])
			-- Move `position' to `a_position' and center on window
		do
			position.x := a_position.x - context.window.width // 2
			position.y := a_position.y - context.window.height // 2
		end

	move_at_entity(a_entity: ENTITY)
			-- Move `position' to `a_entity's position and center on window
		do
			position.x := a_entity.x - context.window.width // 2
			position.y := a_entity.y - context.window.height // 2
		end
end
