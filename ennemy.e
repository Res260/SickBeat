note
	description: "Summary description for {ENNEMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	legal: "See notice at end of class."

class
	ENNEMY

inherit
	ENTITY
		rename
			width as drawable_width,
			height as drawable_height
		redefine
			draw,
			update
		end
	BOUNDING_BOX
	MATH_UTILITY
	SOUND_FACTORY_SHARED

create
	make

feature {NONE} -- Initialization

	make(a_position: TUPLE[x, y: REAL_64]; a_texture: GAME_TEXTURE; a_color: GAME_COLOR; a_arc: GAME_TEXTURE)
			-- Initializes `Current' at `a_position', with `a_texture', with `a_arc' and with `a_color'
		do
			create speed
			arc := a_arc
			speed.x := 0
			speed.y := speed.x
			create launch_wave_event
			color := a_color
			make_box(a_position.x - width / 2, a_position.y - height / 2, a_position.x + width / 2, a_position.y + height / 2)
			x := a_position.x.rounded
			y := a_position.y.rounded
			make_entity(a_position.x, a_position.y)
			texture := a_texture
		end

feature {NONE} -- Implementation

	width: REAL_64 = 40.0
			-- Width of `Current'

	height: REAL_64 = 40.0
			-- Height of `Current'

	speed: TUPLE[x, y: INTEGER]
			-- Speed (in pixels per second) of `Current'

	color: GAME_COLOR
			-- Color of `Current'

	shoot_wave_cooldown_interval: REAL_64 = 4.0
			-- Time between shooting a {WAVE} in seconds

	shoot_wave_cooldown: REAL_64
			-- Time until shooting the next {WAVE} in seconds

	arc: GAME_TEXTURE
			-- The texture for the {WAVE}s thrown by `Current'

feature -- Access

	launch_wave_event: ACTION_SEQUENCE[TUPLE[WAVE]]
			-- Called when `Current' creates a new wave

	draw(a_context: CONTEXT)
			-- Draws the ennemy on the screen
		do
			if attached texture as la_texture then
				a_context.renderer.draw_texture(la_texture, x - (la_texture.width // 2) - a_context.camera.position.x, y - (la_texture.height // 2) - a_context.camera.position.y)
			end
		end

	update(a_timediff: REAL_64)
		do
			shoot_wave_cooldown := (0.0).max(shoot_wave_cooldown - (a_timediff))
		end

	update_state(a_player: PLAYER)
		local
			l_wave: WAVE
			l_direction: REAL_64
			l_x, l_y: INTEGER
			l_speed: TUPLE[x, y: REAL_64]
		do
			if shoot_wave_cooldown <= 0.0 then
				create l_speed
				l_x := a_player.x - x
				l_y := a_player.y - y
				l_direction := atan2(l_x, l_y)
				l_speed.x := speed.x
				l_speed.y := speed.y
--				create l_wave.make(x_real, y_real, l_direction, Pi_2, l_speed, color, Current, arc, create{SOUND}.make_from_other (sound_factory.sounds_list[1]))
				create l_wave.make(x_real, y_real, l_direction, Pi_2, l_speed, color, Current, arc)
				launch_wave_event.call(l_wave)
				shoot_wave_cooldown := shoot_wave_cooldown_interval
			end
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
