note
	description: "{PHYSIC_OBJECT} with the shape of an arc."
	author: "Guillaume Jean"
	date: "6 April 2016"
	revision: "16w10a"
	legal: "See notice at end of class."

class
	BOUNDING_ARC

inherit
	PHYSIC_OBJECT
		redefine
			as_box,
			collides_with_box,
			collides_with_arc
		end
	MATH_UTILITY

create
	make_bounding_arc

feature {NONE} -- Initialization

	make_bounding_arc(a_center: TUPLE[x, y: REAL_64]; a_direction, a_angle, a_radius: REAL_64)
			-- Initializes `Current' centered at (`a_x', `a_y') with `a_radius' radius towards `a_direction' with `a_angle' centered at `a_direction'
		local
			l_half_angle: REAL_64
		do
			make_physic_object
			center := a_center
			direction := a_direction
			l_half_angle := a_angle / 2
			start_angle := direction - l_half_angle
			end_angle := direction + l_half_angle
			radius := a_radius
			create minimal_bounding_box.make_box(0, 0, 0, 0)
			update_minimal_bounding_box
		end

feature {NONE} -- Implementation

	minimal_bounding_box: BOUNDING_BOX
			-- Smallest {BOUNDING_BOX} that contains `Current'

	update_minimal_bounding_box
			-- Update `minimal_bounding_box'
		local
			l_upper_x: REAL_64
			l_upper_y: REAL_64
			l_lower_x: REAL_64
			l_lower_y: REAL_64
		do
			if (start_angle <= 0 and 0 <= end_angle) or (start_angle <= Two_Pi and Two_Pi <= end_angle) then
				l_upper_x := center.x + radius
			else
				l_upper_x := center.x + (radius * (cosine(start_angle).max(cosine(end_angle))))
			end
			if (start_angle <= Pi_2 and Pi_2 <= end_angle) or (start_angle <= 5 * Pi_2 and 5 * Pi_2 <= end_angle) then
				l_upper_y := center.y + radius
			else
				l_upper_y := center.y + (radius * (sine(start_angle).max(sine(end_angle))))
			end
			if start_angle <= Pi and Pi <= end_angle then
				l_lower_x := center.x - radius
			else
				l_lower_x := center.x + (radius * (cosine(start_angle).min(cosine(end_angle))))
			end
			if (start_angle <= Three_Pi_2 and Three_Pi_2 <= end_angle) or (start_angle <= -Pi_2 and -Pi_2 <= end_angle) then
				l_lower_y := center.y - radius
			else
				l_lower_y := center.y + (radius * (sine(start_angle).min(sine(end_angle))))
			end
			minimal_bounding_box.update_to([l_lower_x, l_lower_y], [l_upper_x, l_upper_y])
		end

feature -- Implementation

	as_box: BOUNDING_BOX
			-- Return the minimal bounding box of `Current's arc
		do
			Result := minimal_bounding_box
		end

	collides_with_box(a_box: BOUNDING_BOX): BOOLEAN -- TODO: Detect angle within range
			-- Whether or not `Current' collides with a {BOUNDING_BOX}
		local
			l_closest_x, l_closest_y: REAL_64
			l_distance: REAL_64
			l_difference_x, l_difference_y: REAL_64
			l_angle: REAL_64
		do
			l_closest_x := clamp(center.x, a_box.lower_corner.x, a_box.upper_corner.x)
			l_closest_y := clamp(center.y, a_box.lower_corner.y, a_box.upper_corner.y)
			l_distance := l_closest_x ^ 2 + l_closest_y ^ 2
			if l_distance <= radius ^ 2 then
				l_difference_x := l_closest_x - center.x
				l_difference_y := l_closest_y - center.y
				l_angle := calculate_circle_angle(l_difference_x, l_difference_y)
				Result := start_angle <= l_angle and l_angle <= end_angle
			else
				Result := False
			end
		end

	collides_with_arc(a_arc: BOUNDING_ARC): BOOLEAN -- TODO: Detect angle within range
			-- Whether or not `Current' collides with a {BOUNDING_ARC}
		local
			l_center_distance_x, l_center_distance_y: REAL_64
			l_center_angle1, l_center_angle2: REAL_64
			l_temp_start_angle1, l_temp_start_angle2: REAL_64
			l_temp_end_angle1, l_temp_end_angle2: REAL_64
		do
			l_center_distance_x := a_arc.center.x - center.x
			l_center_distance_y := a_arc.center.y - center.y
			if l_center_distance_x ~ 0 and l_center_distance_y ~ 0 then
				Result := radius - a_arc.radius <= 0
			else
				l_center_angle1 := calculate_circle_angle(l_center_distance_x, l_center_distance_y)
				l_center_angle2 := modulo(Pi - l_center_angle1, Two_Pi)
				l_temp_start_angle1 := start_angle
				l_temp_start_angle2 := a_arc.start_angle
				l_temp_end_angle1 := end_angle
				l_temp_end_angle2 := a_arc.end_angle
				if end_angle > Two_Pi then
					l_temp_start_angle1 := l_temp_start_angle1 - Two_Pi
					l_temp_end_angle1 := l_temp_end_angle1 - Two_Pi
				elseif start_angle < -Two_Pi then
					l_temp_start_angle1 := l_temp_start_angle1 + Two_Pi
					l_temp_end_angle1 := l_temp_end_angle1 + Two_Pi
				end
				if a_arc.end_angle > Two_Pi then
					l_temp_start_angle2 := l_temp_start_angle2 - Two_Pi
					l_temp_end_angle2 := l_temp_end_angle2 - Two_Pi
				elseif a_arc.start_angle < -Two_Pi then
					l_temp_start_angle2 := l_temp_start_angle2 + Two_Pi
					l_temp_end_angle2 := l_temp_end_angle2 + Two_Pi
				end
				Result := (
								l_temp_start_angle1 <= l_center_angle1 and
								l_center_angle1 <= l_temp_end_angle1 and
								l_temp_start_angle2 <= l_center_angle2 and
								l_center_angle2 <= l_temp_end_angle2
						  )
			end
		end

feature -- Access

	center: TUPLE[x, y: REAL_64]
			-- Center position of the arc

	direction: REAL_64
			-- Direction of the arc

	start_angle, end_angle: REAL_64
			-- Start and end angle of the arc

	radius: REAL_64
			-- Radius of the arc

	draw_box(a_context: CONTEXT)
		do
			update_minimal_bounding_box
			if a_context.debugging then
				minimal_bounding_box.draw_box(a_context)
			end
		end

invariant
	Start_Angle_Lowest_Angle: start_angle <= end_angle
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
