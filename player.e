note
	description: "Special {ENTITY} controlled by the user."
	author: "Guillaume Jean"
	date: "2016-05-03"
	revision: "16w12a"
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

	make(a_position: TUPLE[x, y: REAL_64]; a_controller: CONTROLLER; a_context: CONTEXT)
			-- Initialize `Current' at position `a_position' to move following `a_controller's controls
			-- Gathers textures and the waves' angle from `a_context'
		do
			controller := a_controller
			x_real := a_position.x
			y_real := a_position.y
			create max_speed
			create acceleration
			create speed
			max_speed.x := 750
			max_speed.y := 750
			create launch_wave_event
			color_index := 4
			colors := [
						create {GAME_COLOR}.make(0, 0, 0, 255),		-- Black
						create {GAME_COLOR}.make(255, 0, 0, 255),	-- Red
						create {GAME_COLOR}.make(0, 255, 0, 255),	-- Green
						create {GAME_COLOR}.make(0, 0, 255, 255),	-- Blue
						create {GAME_COLOR}.make(255, 255, 255, 255)-- White
					  ]
			sounds := [
						sound_factory.sounds_list[1],
						sound_factory.sounds_list[2],
						sound_factory.sounds_list[3],
						sound_factory.sounds_list[4],
						sound_factory.sounds_list[5]
					  ]
			textures := a_context.image_factory.get_player_texture_tuple
			arc_textures := a_context.image_factory.get_arcs_texture_tuple
			current_texture := textures.white
			current_color := colors.white
			current_arc := arc_textures.white
			current_sound := sounds.white
			radius := current_texture.width / 2
			make_entity(x_real, y_real)
			make_sphere(x_real, y_real, radius)
			bounding_radius := radius
			normal_angle := a_context.image_factory.player_arc_angle
		end

feature {NONE} -- Implementation

	acceleration_input: REAL_64 = 1000.0
			-- Acceleration of the player given by the inputs

	max_speed: TUPLE[x, y: REAL_64]
			-- Max speed of `Current'

	acceleration: TUPLE[x, y: REAL_64]
			-- Acceleration of `Current'

feature -- Access

	controller: CONTROLLER
			-- Controller controlling the player

	current_color: GAME_COLOR
			-- {GAME_COLOR} of `Current'

	current_texture:GAME_TEXTURE
			-- Active {GAME_TEXTURE} of `Current'

	current_arc:GAME_TEXTURE
			-- Active arc {GAME_TEXTURE} of `Current'

	current_sound: SOUND
			-- Active {SOUND} of `Current'

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

	sounds: TUPLE[black, red, green, blue, white: SOUND]
			-- Possible sounds of the waves

	launch_wave_event: ACTION_SEQUENCE[TUPLE[WAVE]]
			-- Called when `Current' creates a new wave

	on_mouse_wheel(a_delta_x, a_delta_y: INTEGER)
			-- Mouse wheel listener for updating the colors based on where it was
		do
			set_color_index((color_index + a_delta_y + colors.count) \\ colors.count)
		end

	on_click(a_mouse: MOUSE)
			-- Mouse update listener for `Current' updating with `a_mouse'
		local
			l_wave: WAVE
			l_direction: REAL_64
			l_x: INTEGER
			l_y: INTEGER
			l_speed: TUPLE[x, y: REAL_64]
		do
			if a_mouse.buttons.left then
				l_x := a_mouse.position.x - x_real.rounded
				l_y := a_mouse.position.y - y_real.rounded
				if l_x /= 0 or l_y /= 0 then
					l_direction := atan2(l_x, l_y)
					create l_speed
					l_speed.x := speed.x
					l_speed.y := speed.y
					if attached {GAME_COLOR} colors.at(color_index + 1) as la_color then
						create l_wave.make(x_real, y_real, l_direction, normal_angle, l_speed, la_color, Current, current_arc, create{SOUND}.make_from_other (current_sound))
						launch_wave_event.call(l_wave)
					end
				end
			end
		end

	draw(a_context: CONTEXT)
			-- Draw `Current' using `a_context's renderer and offsetting by `a_context.camera's position
		do
			a_context.renderer.set_drawing_color(current_color)
			a_context.renderer.draw_texture(current_texture, x - (current_texture.width // 2) - a_context.camera.position.x, y - (current_texture.height // 2) - a_context.camera.position.y)
			draw_collision(a_context)
		end

	update_acceleration
			-- Update `Current's acceleration from the current `controller' inputs
		local
			l_x_accel: REAL_64
			l_y_accel: REAL_64
		do
			l_x_accel := -speed.x
			l_y_accel := -speed.y
			if controller.keys.up then
				l_y_accel := l_y_accel - acceleration_input
			end
			if controller.keys.down then
				l_y_accel := l_y_accel + acceleration_input
			end
			if controller.keys.left then
				l_x_accel := l_x_accel - acceleration_input
			end
			if controller.keys.right then
				l_x_accel := l_x_accel + acceleration_input
			end

			set_acceleration(l_x_accel, l_y_accel)
		end

	update(a_timediff: REAL_64)
			-- Update `Current's `speed' and position from it's `acceleration'
		do
			update_acceleration
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

			if attached {SOUND} sounds.at(color_index + 1) as la_sound then
				current_sound := la_sound
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
