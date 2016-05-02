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
		local
			l_min_radius_distance, l_max_radius_distance: REAL_64
			l_center_distance: REAL_64
			l_difference_x, l_difference_y: REAL_64
			l_collision_angle: REAL_64
			l_do_borders_touch: BOOLEAN
			l_is_angle_in_range: BOOLEAN
		do
			l_min_radius_distance := radius + a_arc.radius - a_arc.thickness
			l_max_radius_distance := radius + a_arc.radius
			l_difference_x := a_arc.center.x - center.x
			l_difference_y := a_arc.center.y - center.y
			l_center_distance := l_difference_x ^ 2 + l_difference_y ^ 2
			l_do_borders_touch := l_min_radius_distance ^ 2 <= l_center_distance and l_center_distance <= l_max_radius_distance ^ 2
			if l_difference_x ~ 0 and l_difference_y ~ 0 then
				Result := l_do_borders_touch
			else
				l_collision_angle := atan2(l_difference_x, l_difference_y)
				l_is_angle_in_range := is_angle_in_range(l_collision_angle, a_arc.start_angle, a_arc.end_angle)
				Result := l_do_borders_touch and l_is_angle_in_range
			end
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

	draw_collision(a_context: CONTEXT)
			-- Draws `Current's minimal bounding box and a sphere
		do
			if a_context.debugging then
				update_minimal_bounding_box
				minimal_bounding_box.draw_box(a_context)
				a_context.renderer.draw_line(center.x.rounded - a_context.camera.position.x, center.y.rounded - a_context.camera.position.y, (center.x + radius).rounded - a_context.camera.position.x, center.y.rounded - a_context.camera.position.y)
				draw_circle(a_context, center.x - a_context.camera.position.x, center.y - a_context.camera.position.y)
			end
		end

	draw_circle(a_context: CONTEXT; a_center: TUPLE[x, y: REAL_64])
			-- Creates an arc centered on a_center with a radius of a_radius at a rasoultion of
			-- a_resolution from a_start_angle rad to a_end_angle rad.
		local
			l_old_x: REAL_64
			l_old_y: REAL_64
			l_new_x: REAL_64
			l_new_y: REAL_64
			l_resolution_factor: REAL_64
			i: REAL_64
		do
			a_context.renderer.set_drawing_color(minimal_bounding_box.box_color)
			l_resolution_factor := Two_Pi / 50
			l_old_x := radius + a_center.x
			l_old_y := a_center.y
			from
				i := l_resolution_factor
			until
				i >= Two_Pi
			loop
				l_new_x := radius * cosine(i) + a_center.x
				l_new_y := radius * sine(i) + a_center.y
				a_context.renderer.draw_line(l_old_x.rounded, l_old_y.rounded, l_new_x.rounded, l_new_y.rounded)
				l_old_x := l_new_x
				l_old_y := l_new_y
				i := i + l_resolution_factor
			end
			l_new_x := radius + a_center.x
			l_new_y := a_center.y
			a_context.renderer.draw_line(l_old_x.rounded, l_old_y.rounded, l_new_x.rounded, l_new_y.rounded)
		end

invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
