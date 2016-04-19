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

	calculate_circle_angle(a_x, a_y: INTEGER): REAL_64
			-- Correctly handles arc_tangent negatives and zeros
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

	modulo(x, n: REAL_64): REAL_64
		do
			Result := x - (n * floor(x/n))
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
