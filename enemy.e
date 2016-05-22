note
	description: "Class representing an enemy in the game. It shoots wave and dies."
	author: "Émilio G!"
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
			update,
			deal_damage
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
			health := health_max
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

	shoot_wave_cooldown_interval: REAL_64 = 5.5
			-- Time between shooting a {WAVE} in seconds

	shoot_wave_cooldown: REAL_64
			-- Time until shooting the next {WAVE} in seconds

	arc: GAME_TEXTURE
			-- The {GAME_TEXTURE} for the {WAVE}s thrown by `Current'

	sound: SOUND
			-- The {SOUND} for the {WAVE}s thrown by `Current'

feature -- Access

	health: REAL_64
			-- `Current's health

	health_max: REAL_64 = 100.0
			-- `Current's maximum amount of `health'

	color: GAME_COLOR
			-- Color of `Current'

	launch_wave_event: ACTION_SEQUENCE[TUPLE[WAVE]]
			-- Called when `Current' creates a new wave

	draw(a_context: CONTEXT)
			-- Draws `Current' on the screen
		do
			if attached texture as la_texture then
				la_texture.set_additionnal_alpha(((128 * health / health_max) + 127).rounded.as_natural_8)
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
			update_minimal_bounding_box
			if not dead and health <= 0.0 then
				dead := True
				death_actions.call(Current)
			end
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

	deal_damage(a_damage: REAL_64)
			-- Deals `a_damage' damage to `Current'
		do
			health := (0.0).max(health - a_damage)
		ensure then
			Damage_Dealt: health = old health - a_damage or health ~ 0.0
		end

	do_collision(a_physic_object: PHYSIC_OBJECT)
			-- Determines what to do with `Current's collision with `a_physic_object'
		local
			l_damage: REAL_64
		do
			if attached {WAVE} a_physic_object as la_wave then
				if attached {PLAYER} la_wave.source then
					l_damage := la_wave.energy / 1000
					if la_wave.color.to_rgb_hex_string ~ color.to_rgb_hex_string then
						l_damage := l_damage * 0.0
					end
					deal_damage(l_damage)
					la_wave.deal_damage(l_damage * 200)
				end
			elseif attached {PLAYER} a_physic_object as la_player then
				deal_damage(health_max)
				la_player.deal_damage(la_player.health_max * 0.25)
			end
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
