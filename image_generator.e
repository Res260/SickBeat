note
	description: "Class that generates images using GAME_PIXEL_READER_WRITER"
	author: "Émilio Gonzalez and Guillaume Jean"
	date: "2016-04-26"
	revision: "16w12a"
	legal: "See notice at end of class."

class
	IMAGE_GENERATOR

inherit
	MATH_UTILITY

feature --Initialization

feature --Access

	make_pixels_transparent(a_pixels: GAME_PIXEL_READER_WRITER)
			--Loops every pixels in a_pixels and makes it transparent.
		do
			across 1 |..| a_pixels.width as l_i loop
				across 1 |..| a_pixels.height as l_j loop
					a_pixels.set_pixel (create {GAME_COLOR}.make (0,0,0,0), l_j.item, l_i.item)
				end
			end
		end

	make_circle(a_pixels:GAME_PIXEL_READER_WRITER; a_outside_color, a_inside_color: GAME_COLOR;
		  a_border_color:detachable GAME_COLOR; a_border_thickness: INTEGER_32)
			--Makes a circle fading from a_outside_color to a_inside_color that is as large
			-- as a_pixels can handle. Also makes a a_border_color border of a_border_thickness pixels thick.
			-- If you do not wish to have a border, simply set a_border_thickness to 0 and a_border_color
			-- can be void.
		require
			Pixels_Dimentions_Valid: a_pixels.width = a_pixels.height
			Pixels_Dimensions_Even: a_pixels.height \\ 2 = 0
			Border_Color_With_Border_Thickness: a_border_thickness > 0 implies attached a_border_color
		local
			l_resolution: INTEGER_32
			i: INTEGER_32
			l_radius: INTEGER
			l_color: GAME_COLOR
			l_red_increments:REAL_64
			l_green_increments:REAL_64
			l_blue_increments:REAL_64
			l_alpha_increments:REAL_64
		do
			create l_color.make_from_other (a_outside_color)
			l_radius := (a_pixels.height - a_border_thickness) // 2
			l_red_increments := ((a_outside_color.red).as_integer_32 - a_inside_color.red) / l_radius
			l_green_increments := ((a_outside_color.green).as_integer_32 - a_inside_color.green) / l_radius
			l_blue_increments := ((a_outside_color.blue).as_integer_32 - a_inside_color.blue) / l_radius
			l_alpha_increments := ((a_outside_color.alpha).as_integer_32 - a_inside_color.alpha) / l_radius
			from
				i := 0
			until
				i >= l_radius
			loop
				l_color.red := (a_inside_color.red + (l_red_increments * i).rounded).to_natural_8
				l_color.green := (a_inside_color.green + (l_green_increments * i).rounded).to_natural_8
				l_color.blue := (a_inside_color.blue + (l_blue_increments * i).rounded).to_natural_8
				l_color.alpha := (a_inside_color.alpha + (l_alpha_increments * i).rounded).to_natural_8
				l_resolution := ((pi * i)^1.6).ceiling + 1
				make_circle_border(a_pixels, i, l_color, l_resolution)
				i := i + 1
			end
			if(attached a_border_color as la_border_color) then
				l_radius := a_pixels.height // 2
				from
					i := l_radius - 1
				until
					i <= l_radius - a_border_thickness - 1
				loop
					l_resolution := ((pi * i)^1.6).ceiling + 1
					make_circle_border(a_pixels, i, la_border_color, l_resolution)
					i := i - 1
				end
			end
		end

	make_circle_border(a_pixels:GAME_PIXEL_READER_WRITER; a_radius:INTEGER_32; a_color:GAME_COLOR; a_resolution: INTEGER_32)
			--Makes a one pixel large border (color a_color) of a circle with a radius of a_radius. a_resolution represents
			--the number of pixels that will be drawn.
		require
			Pixels_Dimentions_Valid: a_pixels.width = a_pixels.height
			Pixels_Dimensions_Even: a_pixels.height \\ 2 = 0
			Radius_Valid: a_radius >= 0 and a_radius <= a_pixels.height // 2
			Resolution_Valid: a_resolution > 0
		local
			l_center_x:REAL_64
			l_center_y:REAL_64
			l_angle:REAL_64
			l_angle_increments:REAL_64
			l_pixel_x: INTEGER_32
			l_pixel_y: INTEGER_32
		do
			if(a_radius > 0) then

				l_center_x := a_pixels.width / 2
				l_center_y := a_pixels.height / 2
				l_angle_increments := Two_pi / a_resolution
				from
					l_angle := 0
				until
					l_angle >= Two_pi
				loop
					l_pixel_x := (l_center_x + (a_radius * cosine(l_angle))).rounded.min(a_pixels.width)
					if(l_pixel_x <= 0) then
						l_pixel_x := 1
					elseif(l_pixel_x > a_pixels.width) then
						l_pixel_x := a_pixels.width
					end
					l_pixel_y := (l_center_y + (a_radius * sine(l_angle))).rounded.min(a_pixels.height)
					if(l_pixel_y <= 0) then
						l_pixel_y := 1
					elseif(l_pixel_y > a_pixels.height) then
						l_pixel_y := a_pixels.height
					end
					a_pixels.set_pixel (a_color, l_pixel_x, l_pixel_y)
					l_angle := l_angle + l_angle_increments
				end
			else
				a_pixels.set_pixel (a_color, a_pixels.width // 2, a_pixels.height // 2)
			end
		end

	make_arc(a_pixels:GAME_PIXEL_READER_WRITER; a_color:GAME_COLOR; a_center: TUPLE[x, y: REAL_64]; a_start_angle, a_end_angle,
		a_radius: REAL_64; a_resolution: INTEGER)
			-- Creates an arc centered on a_center with a radius of a_radius at a rasoultion of
			-- a_resolution from a_start_angle rad to a_end_angle rad.
		require
			Start_Angle_Smaller: a_start_angle < a_end_angle
		local
			l_radius:REAL_64
			l_old_x: REAL_64
			l_old_y: REAL_64
			l_new_x: REAL_64
			l_new_y: REAL_64
			l_resolution_factor: REAL_64
			i: REAL_64
		do
			from
				l_radius := a_radius
			until
				l_radius < a_radius - 1
			loop
				l_resolution_factor := (a_end_angle - a_start_angle) / a_resolution
				l_old_x := l_radius * cosine(a_start_angle) + a_center.x
				l_old_y := l_radius * sine(a_start_angle) + a_center.y
				from
					i := a_start_angle + l_resolution_factor
				until
					i >= a_end_angle
				loop
					l_new_x := l_radius * cosine(i) + a_center.x
					l_new_y := l_radius * sine(i) + a_center.y
					draw_line_between_two_points(a_pixels, a_color, l_old_x.rounded, l_old_y.rounded, l_new_x.rounded, l_new_y.rounded)
					l_old_x := l_new_x
					l_old_y := l_new_y
					i := i + l_resolution_factor
				end
				l_new_x := l_radius * cosine(a_end_angle) + a_center.x
				l_new_y := l_radius * sine(a_end_angle) + a_center.y
				draw_line_between_two_points(a_pixels, a_color, l_old_x.rounded, l_old_y.rounded, l_new_x.rounded, l_new_y.rounded)
				l_radius := l_radius - 0.5
			end
		end

	draw_line_between_two_points(a_pixels:GAME_PIXEL_READER_WRITER; a_color:GAME_COLOR; a_x_1, a_y_1, a_x_2, a_y_2: INTEGER_32)
			-- Draws in a_pixels a line from (a_x_1, a_y_1) to (a_x_2, a_y_2) of color a_color.
		require
			Position1_Valid: a_x_1 >= 0 and a_y_1 >= 0 and a_x_1 <= a_pixels.width and a_y_1 <= a_pixels.height
			Position2_Valid: a_x_2 >= 0 and a_y_2 >= 0 and a_x_2 <= a_pixels.width and a_y_2 <= a_pixels.height
		local
			l_position: TUPLE[x, y:INTEGER_32]
			l_slope, l_b: REAL_64
			l_x_difference, l_y_difference:INTEGER_32
			l_lowest_x, l_highest_x:INTEGER_32
			l_lowest_y, l_highest_y:INTEGER_32
			i:INTEGER_32
		do
			create l_position
			l_slope := get_slope(a_x_1, a_y_1, a_x_2, a_y_2)
			l_b := a_y_1 - (l_slope * a_x_1)
			l_y_difference := (a_y_2 - a_y_1)
			if(l_y_difference > 0) then
				l_lowest_y := a_y_1
				l_highest_y := a_y_2
			else
				l_lowest_y := a_y_2
				l_highest_y := a_y_1
			end
			l_x_difference := (a_x_2 - a_x_1)
			if(l_x_difference < 0) then
				l_lowest_x := a_x_2
				l_highest_x := a_x_1
			else
				l_lowest_x := a_x_1
				l_highest_x := a_x_2
			end
			if(l_slope.abs < 1) then
				from
					i := l_lowest_x
				until
					i > l_highest_x
				loop
					l_position := get_capped_position(a_pixels, [i + 1, ((l_slope * (i)) + l_b).rounded + 1])
					a_pixels.set_pixel(a_color, l_position.x, l_position.y)
					i := i + 1
				end
			else
				from
					i := l_lowest_y
				until
					i > l_highest_y
				loop
					l_position := get_capped_position(a_pixels, [((i - l_b) / l_slope).rounded + 1, i + 1])
					a_pixels.set_pixel(a_color, l_position.x, l_position.y)
					i := i + 1
				end
			end
		end

feature{NONE}

	get_slope(a_x_1, a_y_1, a_x_2, a_y_2:INTEGER_32):REAL_64
			--Returns the slope from two points.
		local
			l_slope: REAL_64
		do
			l_slope := (a_y_1 - a_y_2) / (a_x_1 - a_x_2)
			if(l_slope.is_positive_infinity) then
				l_slope := 1000000000000
			end
			if(l_slope.is_negative_infinity) then
				l_slope := 1000000000000
			end
			if(l_slope.is_nan) then
				l_slope := 0
			end
			Result := l_slope
		end

	get_capped_position(a_pixels:GAME_PIXEL_READER_WRITER; a_position:TUPLE[x, y:INTEGER_32]):TUPLE[x,y:INTEGER_32]
			-- Caps positions to a_pixels positions if it is out of bound and returns a TUPLE
		do
			create Result
			if(a_position.x > a_pixels.width) then
				Result.x := a_pixels.width
			elseif(a_position.x < 1) then
				Result.x := 1
			else
				Result.x := a_position.x
			end
			if(a_position.y > a_pixels.height) then
					Result.x := a_pixels.height
			elseif(a_position.y < 1) then
				Result.y := 1
			else
				Result.y := a_position.y
			end
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
