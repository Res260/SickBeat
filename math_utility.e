note
	description: "Implementation of math functions and constants that aren't in {DOUBLE_MATH}."
	author: "Guillaume Jean"
	date: "12 April 2016"
	revision: "16w10a"

class
	MATH_UTILITY

inherit
	DOUBLE_MATH

feature -- Constants

	Two_Pi: REAL_64
			-- Pi * 2
		once
			Result := 2*Pi
		end

	Three_Pi_2: REAL_64
			-- 3Pi / 2
		once
			Result := 3 * Pi_2
		end

feature -- Access

	dot_product(a_vector1, a_vector2: TUPLE[x, y: REAL_64]): REAL_64
			-- Returns the dot product of 2 (x, y) coordinates
		do
			Result := (a_vector1.x * a_vector2.x) + (a_vector1.y * a_vector2.y)
		end

	normalize_vector(a_vector: TUPLE[x, y: REAL_64]): REAL_64
			-- Returns the magnitude of `a_vector'
			-- Side effect: normalizes `a_vector'
		local
			l_magnitude: REAL_64
		do
			l_magnitude := sqrt(a_vector.x ^ 2 + a_vector.y ^ 2)
			if l_magnitude /= 0 then
				a_vector.x := a_vector.x / l_magnitude
				a_vector.y := a_vector.y / l_magnitude
			end
			Result := l_magnitude
		end

	normalize_angle(a_angle, a_center: REAL_64): REAL_64
			-- See http://bit.ly/normalizeAngle
		do
			Result := a_angle - Two_Pi * floor((a_angle + Pi - a_center) / Two_Pi)
		end

	is_angle_in_range(a_angle, a_start_angle, a_end_angle: REAL_64): BOOLEAN
			-- More complete version of `is_angle_in_range2'.
			-- Might be faster than the other in extreme cases.
		local
			l_angle: REAL_64
		do
			l_angle := normalize_angle(a_angle, (a_start_angle + a_end_angle) / 2)
			Result := a_start_angle <= l_angle and l_angle <= a_end_angle
		end

	is_angle_in_range2(a_angle, a_start_angle, a_end_angle: REAL_64): BOOLEAN
			-- Checks if `a_angle' is within `a_start_angle' and `a_end_angle'
			-- Priority #1 for optimizing
		local
			l_angle: REAL_64
			i: REAL_64
		do
			Result := False
			from
				i := -1
			until
				i > 1 or Result
			loop
				l_angle := a_angle + (Two_Pi * i)
				if a_start_angle <= l_angle and l_angle <= a_end_angle then
					Result := True
				end
				i := i + 1
			end
		end

	atan2(a_x, a_y: REAL_64): REAL_64
			-- Correctly handles arc_tangent negatives and zeros
			-- Undefined for `a_x' and `a_y' equal to 0
			-- Returns in range [0, 2*Pi]
			-- See definition at https://en.wikipedia.org/wiki/Atan2
		require
			Angle_Possible: a_x /= 0 or a_y /= 0
		local
			l_y_x_ratio: REAL_64
			l_angle: REAL_64
		do
			if a_x ~ 0 then
				if a_y > 0 then
					l_angle := Pi_2
				elseif a_y < 0 then
					l_angle := Three_Pi_2
				end
			else
				l_y_x_ratio := a_y / a_x
				l_angle := arc_tangent(l_y_x_ratio)
				if a_x < 0 then
					l_angle := l_angle + Pi
				elseif a_x > 0 and a_y < 0 then
					l_angle := Two_Pi + l_angle
				end
			end
			Result := l_angle
		end

	modulo(a_x, a_n: REAL_64): REAL_64
			-- Same as {INTEGER_32}.integer_remainder but for REAL_64
		do
			Result := a_x - (a_n * floor(a_x/a_n))
		end

	clamp(a_value, a_min, a_max: REAL_64): REAL_64
			-- If value > max then max is returned
			-- If value < min then min is returned
			-- If min <= value <= max then value is returned
		do
			if a_value > a_max then
				Result := a_max
			elseif a_value < a_min then
				Result := a_min
			else
				Result := a_value
			end
		end

	clamp_to_sides(a_value, a_min, a_max: REAL_64): REAL_64
			-- Same as clamp but returns the closest side when min <= value <= max
		do
			if a_value > a_max then
				Result := a_max
			elseif a_value < a_min then
				Result := a_min
			else
				Result := ((((a_value - a_min) / a_max).rounded) * a_max) + a_min
			end
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end


