note
	description: "Class that generates images using GAME_PIXEL_READER_WRITER"
	author: "Émilio Gonzalez"
	date: "2016-04-18"
	revision: "16w11a"
	legal: "See notice at end of class."

class
	IMAGE_GENERATOR

inherit
	MATH_UTILITY

create
	make

feature --Initialization
	make
		-- Initialization for `Current'. Sets some attributes.
		do
		end

feature --Access

	make_pixels_transparent(a_pixels: GAME_PIXEL_READER_WRITER)
		do
			across 1 |..| a_pixels.width as l_i loop
				across 1 |..| a_pixels.height as l_j loop
					a_pixels.set_pixel (create {GAME_COLOR}.make (0,0,0,0), l_i.item, l_j.item)
				end
			end
		end

	make_circle(a_pixels:GAME_PIXEL_READER_WRITER; a_outside_color, a_inside_color: GAME_COLOR;
		  a_border_color:detachable GAME_COLOR; a_border_thickness: INTEGER_32)
		require
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
				l_resolution := ((pi * i)^1.6).ceiling
				make_circle_border(a_pixels, i, l_color, l_resolution)
				i := i + 1
			end

			if(attached a_border_color as la_border_color) then
				l_radius := a_pixels.height // 2
				from
					i := l_radius
				until
					i <= l_radius - a_border_thickness
				loop
					l_resolution := ((pi * i)^1.5).ceiling
					make_circle_border(a_pixels, i, la_border_color, l_resolution)
					i := i - 1
				end
			end
		end

	make_circle_border(a_pixels:GAME_PIXEL_READER_WRITER; a_radius:INTEGER_32; a_color:GAME_COLOR; a_resolution: INTEGER_32)
		local
			l_center_x:REAL_64
			l_center_y:REAL_64
			l_angle:REAL_64
			l_angle_increments:REAL_64
			l_pixel_x: INTEGER_32
			l_pixel_y: INTEGER_32
		do
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
				end
				if(l_pixel_x > a_pixels.width) then
					l_pixel_x := a_pixels.width
				end
				l_pixel_y := (l_center_y + (a_radius * sine(l_angle))).rounded.min(a_pixels.height)
				if(l_pixel_y <= 0) then
					l_pixel_y := 1
				end
				if(l_pixel_y > a_pixels.height) then
					l_pixel_y := a_pixels.height
				end
				a_pixels.set_pixel (a_color, l_pixel_x, l_pixel_y)
				l_angle := l_angle + l_angle_increments
			end
		end

	draw_line_between_two_points(a_pixels:GAME_PIXEL_READER_WRITER; a_x_1, a_y_1, a_x_2, a_y_2: INTEGER_32)
		local
			l_slope: REAL_64
		do

		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
