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
			as_box,
			collides_with_box,
			collides_with_arc
		end

create
	make_box

feature {NONE} -- Initialization

	make_box(a_x1, a_y1, a_x2, a_y2: REAL_64)
			-- Initializes `Current'
		do
			make_physic_object
			create upper_corner
			create lower_corner
			create box_center
			update_to([a_x1, a_y1], [a_x2, a_y2])
		end

feature -- Access

	box_color: GAME_COLOR
			-- Color for the bounding boxes
		once("PROCESS")
			create Result.make(255, 142, 0, 255)
		end

feature -- Implementation

	as_box: BOUNDING_BOX
			-- Returns `Current'
		do
			Result := Current
		ensure then
			Box_Unmodified: Result = Current
		end

	collides_with_box(a_other: BOUNDING_BOX): BOOLEAN
			-- Whether or not `Current' collides with another {BOUNDING_BOX}
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

	collides_with_arc(a_arc: BOUNDING_ARC): BOOLEAN
			-- Whether or not `Current' collides with a {BOUNDING_ARC}
		do
			Result := a_arc.collides_with_box(Current)
		end

	collides_with_sphere(a_sphere: BOUNDING_SPHERE): BOOLEAN
			-- Whether or not `Current' collides with a {BOUNDING_SPHERE}
		do
			Result := a_sphere.collides_with_box(Current)
		end

feature -- Access

	upper_corner: TUPLE[x, y: REAL_64]
			-- Upper corner of `Current's box
			-- Do not modify directly, use instead `move_box_to'

	lower_corner: TUPLE[x, y: REAL_64]
			-- Lower corner of `Current's box
			-- Do not modify directly, use instead `move_box_to'

	box_center: TUPLE[x, y: REAL_64]
			-- Center of `Current'
			-- Do not modify directly.

	draw_box(a_context: CONTEXT)
			-- Draw `Current's outline
			-- Only happens if `a_context' is in debug mode
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

	update_to(a_lower_corner, a_upper_corner: TUPLE[x, y: REAL_64])
			-- Update `Current's coordinates
		do
			lower_corner.x := a_lower_corner.x
			lower_corner.y := a_lower_corner.y
			upper_corner.x := a_upper_corner.x
			upper_corner.y := a_upper_corner.y
			box_center.x := (lower_corner.x + upper_corner.x) / 2
			box_center.y := (lower_corner.y + upper_corner.y) / 2
		ensure
			Corners_Set: lower_corner ~ a_lower_corner and upper_corner ~ a_upper_corner
			Center_Set: box_center.x >= lower_corner.x and box_center.x <= upper_corner.x and box_center.y >= lower_corner.y and box_center.y <= upper_corner.y
		end

invariant
	Upper_Corner_Biggest_Corner: upper_corner.x >= lower_corner.x and upper_corner.y >= lower_corner.y
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
