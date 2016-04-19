note
	description: "Holds the mouse position at all times. Can collide with stuff."
	author: "Guillaume Jean"
	date: "12 April 2016"
	revision: "16w10a"

class
	MOUSE

inherit
	BOUNDING_BOX

create
	make

feature {NONE} -- Initialization

	make(a_position: TUPLE[x, y: INTEGER])
		do
			position := a_position
			make_box(position.x.to_double, position.y.to_double, position.x.to_double, position.y.to_double)
		end

feature {NONE} -- Implementation

	update_box
			-- Update `Current's bounding_box position
		do
			lower_corner.x := position.x.to_double
			lower_corner.y := position.y.to_double
			upper_corner.x := position.x.to_double
			upper_corner.y := position.y.to_double
		end

feature -- Access

	position: TUPLE[x, y: INTEGER] assign set_position
			-- Position of `Current'

	set_position(a_new_position: TUPLE[x, y: INTEGER])
		do
			position.x := a_new_position.x
			position.y := a_new_position.y
			update_box
		ensure
			Position_Set: position ~ a_new_position
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
