note
	description: "{PHYSIC_OBJECT} with the shape of a circle."
	author: "Guillaume Jean"
	date: "21 April 2016"
	revision: "16w12a"
	legal: "See notice at end of class."

class
	BOUNDING_SPHERE

inherit
	PHYSIC_OBJECT
	MATH_UTILITY

create
	make_sphere

feature {NONE} -- Initialization

	make_sphere(a_center: TUPLE[x, y: REAL_64]; a_radius: REAL_64)
			-- Initializes `Current'
		do
			make_physic_object
			center := a_center
			radius := a_radius
			create minimal_bounding_box.make_box(0, 0, 0, 0)
			update_minimal_bounding_box
		end

feature {NONE} -- Implementation

	minimal_bounding_box: BOUNDING_BOX
			-- Smalled rectangle containing `Current'

	update_minimal_bounding_box
			-- Updates `minimal_bounding_box' with `Current's new coordinates and radius
		local
			l_lower_corner: TUPLE[x, y: REAL_64]
			l_upper_corner: TUPLE[x, y: REAL_64]
		do
			create l_lower_corner
			create l_upper_corner
			l_lower_corner.x := center.x - radius
			l_lower_corner.y := center.y - radius
			l_upper_corner.x := center.x + radius
			l_upper_corner.y := center.y + radius

			minimal_bounding_box.update_to(l_lower_corner, l_upper_corner)
		end

feature -- Implementation

	as_box: BOUNDING_BOX
			-- Returns the minimal bounding box of `Current'
		do
			Result := minimal_bounding_box
		end

	collides_with_box(a_box: BOUNDING_BOX): BOOLEAN
			-- Check if `Current' collides with `a_box'
		local
			l_closest_x, l_closest_y: REAL_64
			l_distance: REAL_64
		do
			l_closest_x := clamp(center.x, a_box.lower_corner.x, a_box.upper_corner.x)
			l_closest_y := clamp(center.y, a_box.lower_corner.y, a_box.upper_corner.y)
			l_distance := l_closest_x ^ 2 + l_closest_y ^ 2
			Result := l_distance <= radius ^ 2
		end

	collides_with_arc(a_arc: BOUNDING_ARC): BOOLEAN
			-- Check if `Current' collides with `a_arc'
		do
			Result := False
		end

	collides_with_sphere(a_sphere: BOUNDING_SPHERE): BOOLEAN
			-- Check if `Current' collides with `a_sphere'
		local
			l_radius_distance: REAL_64
			l_center_distance: REAL_64
		do
			l_radius_distance := radius + a_sphere.radius
			l_center_distance := (center.x - a_sphere.center.x) ^ 2 + (center.y - a_sphere.center.y) ^ 2
			Result := l_center_distance <= l_radius_distance ^ 2
		end

feature -- Access

	center: TUPLE[x, y: REAL_64]
			-- Center coordinates of `Current'

	radius: REAL_64
			-- Radius of `Current'

invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
