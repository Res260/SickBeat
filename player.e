note
	description: "Special {ENTITY} controlled by the user."
	author: "Guillaume Jean"
	date: "27 March 2016"
	revision: "16w09a"
	legal: "See notice at end of class."

class
	PLAYER

inherit
	ENTITY
		redefine
			draw,
			update,
			width,
			height
		end
	BOUNDING_BOX
	MATH_UTILITY

create
	make

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialize `Current'
		do
			x_real := a_context.window.width / 2
			y_real := a_context.window.height / 2
			make_entity(x_real, y_real, a_context)
			make_box(x_real - 25, y_real - 25, x_real + 25, y_real + 25)
			create max_speed
			create acceleration
			create speed
			max_speed.x := 75
			max_speed.y := 75
			create launch_wave_event
			color_index := 4
			colors := [
						create {GAME_COLOR}.make(0, 0, 0, 255),		-- Black
						create {GAME_COLOR}.make(255, 0, 0, 255),	-- Red
						create {GAME_COLOR}.make(0, 255, 0, 255),	-- Green
						create {GAME_COLOR}.make(0, 0, 255, 255),	-- Blue
						create {GAME_COLOR}.make(255, 255, 255, 255)-- White
					  ]
			current_color := colors.white
		end

feature {NONE} -- Implementation

	max_speed: TUPLE[x, y: REAL_64]
			-- Max speed of `Current'

	acceleration: TUPLE[x, y: REAL_64]
			-- Acceleration of `Current'

	current_color: GAME_COLOR
			-- Temporary color until it is changed from the `color_index'

feature -- Access

	speed: TUPLE[x, y: REAL_64]
			-- Speed of `Current'

	colors: TUPLE[black, red, green, blue, white: GAME_COLOR]
			-- Possible colors of the entities

	color_index: INTEGER assign set_color_index
			-- Color index of `Current's color

	launch_wave_event: ACTION_SEQUENCE[TUPLE[WAVE]]
			-- Called when `Current' creates a new wave

	on_click(a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE)
			-- Mouse button pressed listener for `Current'
		local
			l_wave: WAVE
			l_direction: REAL_64
			l_angle: REAL_64
			l_x: INTEGER
			l_y: INTEGER
			l_speed: TUPLE[x, y: REAL_64]
		do
			if a_mouse_state.is_left_button_pressed then
				l_angle := Pi_4
				l_x := a_mouse_state.x - x_real.rounded + context.camera.position.x
				l_y := a_mouse_state.y - y_real.rounded + context.camera.position.y
				if l_x /= 0 or l_y /= 0 then
					l_direction := calculate_circle_angle(l_x, l_y)
					create l_speed
					l_speed.x := speed.x * 0.75
					l_speed.y := speed.y * 0.75
					if attached {GAME_COLOR} colors.at(color_index + 1) as la_color then
						create l_wave.make(x_real, y_real, l_direction, l_angle, l_speed, la_color, Current, context)
						launch_wave_event.call(l_wave)
					end
				end
			end
		end

	draw
			-- Draw `Current' using `context's renderer and offsetting by `context.camera's position
		local
			l_previous_color: GAME_COLOR
		do
			l_previous_color := context.renderer.drawing_color

			context.renderer.set_drawing_color(current_color)
			context.renderer.draw_filled_rectangle(x - 25 - context.camera.position.x, y - 25 - context.camera.position.y, 50, 50)

			draw_box(context)

			context.renderer.set_drawing_color(l_previous_color)
		end

	update(a_timediff: REAL_64)
			-- Update `Current's `speed' and position from it's `acceleration'
		do
			speed.x := max_speed.x.opposite.max(max_speed.x.min(speed.x + acceleration.x * a_timediff))
			speed.y := max_speed.y.opposite.max(max_speed.y.min(speed.y + acceleration.y * a_timediff))
			x_real := x_real + a_timediff * speed.x
			y_real := y_real + a_timediff * speed.y
			x := x_real.floor
			y := y_real.floor
			upper_corner.x := x_real + width / 2
			upper_corner.y := y_real + width / 2
			lower_corner.x := x_real - width / 2
			lower_corner.y := y_real - width / 2
		ensure then
			X_Speed_Is_Bounded: max_speed.x.opposite <= speed.x and speed.x <= max_speed.x
			Y_Speed_Is_Bounded: max_speed.y.opposite <= speed.y and speed.y <= max_speed.y
		end

	update_color
			-- Update `current_color' attribute from the `color_index'
		do
			if attached {GAME_COLOR} colors.at(color_index + 1) as la_color then
				current_color := la_color
			end
		end

	width: INTEGER
		do
			Result := 50
		end

	height: INTEGER
		do
			Result := 50
		end

	set_acceleration(a_x_accel, a_y_accel: REAL_64)
			-- Change `Current's acceleration
		do
			acceleration.x := a_x_accel
			acceleration.y := a_y_accel
		ensure
			X_Acceleration_Set: acceleration.x = a_x_accel
			Y_Acceleration_Set: acceleration.y = a_y_accel
		end

	set_color_index(a_color_index: INTEGER)
			-- Change `Current's color index
		do
			color_index := a_color_index
			update_color
		ensure
			Color_Index_Set: color_index = a_color_index
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
