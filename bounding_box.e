note
	description: "{PHYSIC_OBJECT} with the shape of a rectangle."
	author: "Guillaume Jean"
	date: "6 April 2016"
	revision: "16w10a"
	legal: "See notice at end of class."

class
	BOUNDING_BOX

inherit
	PHYSIC_OBJECT
		redefine
			as_box
		end

create
	make_box

feature {NONE} -- Initialization

	make_box(a_x1, a_y1, a_x2, a_y2: REAL_64)
			-- Initializes `Current'
		do
			create upper_corner
			create lower_corner
			upper_corner.x := a_x1.max(a_x2)
			upper_corner.y := a_y1.max(a_y2)
			lower_corner.x := a_x1.min(a_x2)
			lower_corner.y := a_y1.min(a_y2)
		end

feature {NONE} -- Implementation

	box_color: GAME_COLOR
			-- Color for the bounding boxes
		once
			create Result.make(255, 142, 0, 255)
		end

feature -- Access

	upper_corner: TUPLE[x, y: REAL_64]
			-- Upper corner of `Current's box

	lower_corner: TUPLE[x, y: REAL_64]
			-- Lower corner of `Current's box

	draw_box(a_context: CONTEXT)
		local
			l_lower_x, l_lower_y, l_upper_x, l_upper_y: INTEGER
		do
			if a_context.debugging then
				l_lower_x := lower_corner.x.rounded - a_context.camera.position.x
				l_lower_y := lower_corner.y.rounded - a_context.camera.position.y
				l_upper_x := upper_corner.x.rounded - a_context.camera.position.x
				l_upper_y := upper_corner.y.rounded - a_context.camera.position.y
				a_context.renderer.set_drawing_color(box_color)
				a_context.renderer.draw_line(l_lower_x, l_lower_y, l_lower_x, l_upper_y)
				a_context.renderer.draw_line(l_lower_x, l_lower_y, l_upper_x, l_lower_y)
				a_context.renderer.draw_line(l_lower_x, l_upper_y, l_upper_x, l_upper_y)
				a_context.renderer.draw_line(l_upper_x, l_lower_y, l_upper_x, l_upper_y)
			end
		end

	as_box: BOUNDING_BOX
			-- Returns `Current'
		do
			Result := Current
		end

	collides_with_box(a_other: BOUNDING_BOX): BOOLEAN
		do
			if
				a_other.lower_corner.x <= upper_corner.x and
				a_other.upper_corner.x >= lower_corner.x and
				a_other.upper_corner.y >= lower_corner.y and
				a_other.lower_corner.y <= upper_corner.y
			then
				Result := True
			else
				Result := False
			end
		end

invariant
	Upper_Corner_Biggest_Corner: upper_corner.x >= lower_corner.x and upper_corner.y >= lower_corner.y
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
