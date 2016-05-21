note
	description: "Class representing an enemy in the game. It shoots wave and dies."
	author: "�milio G!"
	date: "2016-05-20"
	revision: "16w16a"
	legal: "See notice at end of class."

class
	ENEMY

inherit
	ENTITY
		rename
			width as drawable_width,
			height as drawable_height
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

	make(a_position: TUPLE[x, y: REAL_64]; a_texture: GAME_TEXTURE; a_color: GAME_COLOR; a_arc: GAME_TEXTURE; a_sound: SOUND)
			-- Initializes `Current' at `a_position', with `a_texture', with `a_arc', with `a_color' and with `a_sound'
		do
			make_entity(a_position.x, a_position.y)
			radius := a_texture.width / 2
			make_sphere(x_real, y_real, radius)
			bounding_radius := radius
			sound := a_sound
			create speed
			create max_speed
			arc := a_arc
			speed.x := 0
			speed.y := speed.x
			max_speed.x := 70
			max_speed.y := max_speed.x
			create launch_wave_event
			color := a_color
			x := a_position.x.rounded
			y := a_position.y.rounded
			texture := a_texture
		end

feature {NONE} -- Implementation

	width: REAL_64 = 40.0
			-- Width of `Current'

	height: REAL_64 = 40.0
			-- Height of `Current'

	speed: TUPLE[x, y: REAL_64]
			-- Speed (in pixels per second) of `Current'

	max_speed: TUPLE[x, y: REAL_64]
			-- Max speed of `Current'

	radius: REAL_64
			-- `Current's radius

	color: GAME_COLOR
			-- Color of `Current'

	shoot_wave_cooldown_interval: REAL_64 = 5.5
			-- Time between shooting a {WAVE} in seconds

	shoot_wave_cooldown: REAL_64
			-- Time until shooting the next {WAVE} in seconds

	arc: GAME_TEXTURE
			-- The {GAME_TEXTURE} for the {WAVE}s thrown by `Current'

	sound: SOUND
			-- The {SOUND} for the {WAVE}s thrown by `Current'

feature -- Access

	launch_wave_event: ACTION_SEQUENCE[TUPLE[WAVE]]
			-- Called when `Current' creates a new wave

	draw(a_context: CONTEXT)
			-- Draws `Current' on the screen
		do
			if attached texture as la_texture then
				a_context.renderer.draw_texture(la_texture, x - (la_texture.width // 2) - a_context.camera.position.x, y - (la_texture.height // 2) - a_context.camera.position.y)
			end
			draw_collision(a_context)
		end

	update(a_timediff: REAL_64)
			-- Updates `Current' on every tick
		do
			shoot_wave_cooldown := (0.0).max(shoot_wave_cooldown - (a_timediff))
			x_real := x_real + a_timediff * speed.x
			y_real := y_real + a_timediff * speed.y
			x := x_real.floor
			y := y_real.floor
			center.x := x_real
			center.y := y_real
		end

	update_state(a_player: PLAYER)
			-- Updates the `a_player'-dependant attributes of `Current'
		local
			l_x_difference, l_y_difference, l_distance_no_hypotenuse: INTEGER
		do
			l_x_difference := a_player.x - x
			l_y_difference := a_player.y - y
			l_distance_no_hypotenuse := l_x_difference.abs + l_y_difference.abs + 1
			speed.x := (l_x_difference / l_distance_no_hypotenuse) * max_speed.x
			speed.y := (l_y_difference / l_distance_no_hypotenuse) * max_speed.y
			if shoot_wave_cooldown <= 0.0 then
				shoot_wave(a_player)
			end
		end

	shoot_wave(a_player: PLAYER)
			-- Shoots a wave in the direction of `a_player'
		local
			l_wave: WAVE
			l_direction: REAL_64
			l_x, l_y: INTEGER
			l_speed: TUPLE[x, y: REAL_64]
		do
			create l_speed
			l_x := a_player.x - x
			l_y := a_player.y - y
			if l_x /= 0 and l_y /= 0 then
				l_direction := atan2(l_x, l_y)
			else
				l_direction := 0
			end
			l_speed.x := speed.x
			l_speed.y := speed.y
			create l_wave.make(x_real, y_real, a_player.x_real, a_player.y_real, l_direction, Pi_2, l_speed, color, Current, arc, create{SOUND}.make_from_other (sound))
			launch_wave_event.call(l_wave)
			shoot_wave_cooldown := shoot_wave_cooldown_interval
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
