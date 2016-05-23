note
	description: "{PHYSIC_OBJECT} with the shape of a plane."
	author: "Guillaume Jean"
	date: "10 May 2016"
	revision: "16w14a"

class
	BOUNDING_PLANE

inherit
	PHYSIC_OBJECT
	MATH_UTILITY

create
	make_plane

feature {NONE} -- Initialization

	make_plane(a_normal: TUPLE[x, y: REAL_64]; a_offset: REAL_64)
			-- Initalizes `Current' point towards `a_normal' from center (0, 0) with `a_offset' on the axis
			-- Note: `a_normal' is normalized
		require
			Normal_Not_Null: not (a_normal.x ~ 0 and a_normal.y ~ 0)
		do
			make_physic_object
			normal := a_normal
			length := normalize_vector(normal)
			offset := a_offset
			create minimum_bounding_box.make_box(0, 0, 0, 0)
			update_minimum_bounding_box
		end

feature {NONE} -- Implementation

	minimum_bounding_box: BOUNDING_BOX
			-- Smallest possible {BOUNDING_BOX} containing `Current'
			-- This has infinite borders

	update_minimum_bounding_box
			-- Updates `Current's minimum_bounding_box
		local
			l_x1, l_x2, l_y1, l_y2: REAL_64
			l_infinite_offset: REAL_64
		do
			l_infinite_offset := offset * {REAL_64}.positive_infinity
			if l_infinite_offset.is_nan then
				l_infinite_offset := 0
			end
			l_x1 := normal.y + l_infinite_offset
			l_x2 := normal.y - l_infinite_offset
			l_y1 := normal.x + l_infinite_offset
			l_y2 := normal.x - l_infinite_offset
			minimum_bounding_box.update_to([l_x1.min(l_x2), l_y1.min(l_y2)], [l_x1.max(l_x2), l_y1.max(l_y2)])
		end

feature -- Access

	length: REAL_64
			-- Length of `Current's normal

	normal: TUPLE[x, y: REAL_64]
			-- Direction from (0, 0) where `Current' points

	offset: REAL_64
			-- Offset of `Current' on `normal' axis

feature -- Implementation

	as_box: BOUNDING_BOX
			-- Minimalistic version of `Current' as a {BOUNDING_BOX}
		do
			Result := minimum_bounding_box
		end

	collides_with_box(a_other: BOUNDING_BOX): BOOLEAN
			-- Whether or not `Current' collides with a {BOUNDING_BOX}
		local
			l_box_extent: TUPLE[x, y: REAL_64]
			l_abs_normal: TUPLE[x, y: REAL_64]
			l_interval_radius: REAL_64
			l_normal_dot: REAL_64
			l_box_center_plane: REAL_64
			l_distance: REAL_64
		do
			l_box_extent := [a_other.upper_corner.x - a_other.box_center.x, a_other.upper_corner.y - a_other.box_center.y]
			l_abs_normal := [normal.x.abs, normal.y.abs]
			l_interval_radius := (l_box_extent.x * l_abs_normal.y) + (l_box_extent.y * l_abs_normal.y)
			l_normal_dot := (normal.x * a_other.box_center.x) + (normal.y * a_other.box_center.y)
			l_box_center_plane := l_normal_dot - offset
			l_distance := l_box_center_plane - l_interval_radius
			Result := l_distance < 0
		end

	collides_with_arc(a_other: BOUNDING_ARC): BOOLEAN
			-- Whether or not `Current' collides with a {BOUNDING_ARC}
		do
			Result := False
		end

	collides_with_sphere(a_other: BOUNDING_SPHERE): BOOLEAN
			-- Whether or not `Current' collides with a {BOUNDING_SPHERE}
		local
			l_distance_plane: REAL_64
		do
			l_distance_plane := (dot_product(normal, a_other.center) - offset) / length
			Result := l_distance_plane.abs - a_other.radius <= 0
		end

	collides_with_plane(a_other: BOUNDING_PLANE): BOOLEAN
			-- Whetehr or not `Current' collides with a {BOUNDING_PLANE}
			-- Will most likely not be used. 2 planes with different orientations always collide.
		do
			Result := not (normal.x ~ a_other.normal.x and normal.y ~ a_other.normal.y)
		end

invariant
	Normal_Is_Normalized: check_normalization(normal)
end
