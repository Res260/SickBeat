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
			update
		end
	BOUNDING_SPHERE
		rename
			radius as bounding_radius
		end
	MATH_UTILITY
	SOUND_FACTORY_SHARED

create
	make

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialize `Current'
		do
			x_real := a_context.window.width / 2
			y_real := a_context.window.height / 2
			make_entity(x_real, y_real, a_context)
			make_sphere(x_real, y_real, radius)
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
			textures := context.image_factory.get_player_texture_tuple
			arc_textures := context.image_factory.get_arcs_texture_tuple
			current_texture := textures.red
			current_color := colors.white
			current_arc := arc_textures.red
			radius := current_texture.width / 2
			bounding_radius := radius
			normal_angle := context.image_factory.player_arc_angle
		end

feature {NONE} -- Implementation

	max_speed: TUPLE[x, y: REAL_64]
			-- Max speed of `Current'

	acceleration: TUPLE[x, y: REAL_64]
			-- Acceleration of `Current'

	current_color: GAME_COLOR
			-- Temporary color until it is changed from the `color_index'

feature -- Access

	current_texture:GAME_TEXTURE
			-- Active texture of `Current'

	current_arc:GAME_TEXTURE
			-- Active arc texture of `Current'

	speed: TUPLE[x, y: REAL_64]
			-- Speed of `Current'

	radius: REAL_64
			-- `Current's radius

	normal_angle: REAL_64
			-- Wave angle for normal attacks

	textures:TUPLE[black, red, green, blue, white: GAME_TEXTURE]
			-- Possible colors of the entities

	arc_textures:TUPLE[black, red, green, blue, white: GAME_TEXTURE]
			-- Possible colors of the arcs

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
			l_x: INTEGER
			l_y: INTEGER
			l_speed: TUPLE[x, y: REAL_64]
		do
			if a_mouse_state.is_left_button_pressed then
				l_x := a_mouse_state.x - x_real.rounded + context.camera.position.x
				l_y := a_mouse_state.y - y_real.rounded + context.camera.position.y
				if l_x /= 0 or l_y /= 0 then
					l_direction := atan2(l_x, l_y)
					create l_speed
					l_speed.x := speed.x * 1
					l_speed.y := speed.y * 1
					if attached {GAME_COLOR} colors.at(color_index + 1) as la_color then
						create l_wave.make(x_real, y_real, l_direction, normal_angle, l_speed, la_color, Current, context, current_arc, create{SOUND}.make_from_other (sound_factory.sounds_list[1]))
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
			--context.renderer.draw_filled_rectangle(x - 25 - context.camera.position.x, y - 25 - context.camera.position.y, 50, 50)
			context.renderer.draw_texture(current_texture, x - (current_texture.width // 2) - context.camera.position.x, y - (current_texture.height // 2) - context.camera.position.y)
			draw_collision(context)

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
			center.x := x_real
			center.y := y_real
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

			if attached {GAME_TEXTURE} textures.at(color_index + 1) as la_texture then
				current_texture := la_texture
			end

			if attached {GAME_TEXTURE} arc_textures.at(color_index + 1) as la_arc_texture then
				current_arc := la_arc_texture
			end
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
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
