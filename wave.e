note
	description: "{ENTITY} that damages other entities and augments in size."
	author: "Guillaume Jean and Émilio G!"
	date: "2016-04-26"
	revision: "16w12a"
	legal: "See notice at end of class."

class
	WAVE

inherit
	ENTITY
		redefine
			update,
			draw
		end
	BOUNDING_ARC
		rename
			direction as bounding_direction,
			radius as bounding_radius
		end
	MATH_UTILITY
	SOUND_MANAGER_SHARED

create
	make

feature {NONE} -- Initialization

	make(a_x, a_y, a_direction, a_angle: REAL_64; a_center_speed: TUPLE[x, y: REAL_64]; a_color: GAME_COLOR; a_source: ENTITY; a_context: CONTEXT; a_texture:GAME_TEXTURE; a_sound:SOUND)
			-- Initialize `Current' with a direction, angle, maximum radius, and color
		do
			context := a_context
			make_entity(a_x, a_y, a_context)
			direction := a_direction
			angle := a_angle
			create wave_texture.share_from_other (a_texture)
			create color.make_from_other(a_color)
			radius := a_source.width / 2
			energy := initial_energy
			center_speed := a_center_speed
			source := a_source
			make_bounding_arc(a_x, a_y, a_direction, a_angle, radius)
			sound_manager.create_audio_source
			audio_source := sound_manager.last_audio_source
			sound := a_sound
			audio_source.queue_sound (sound)
			audio_source.play
			collision_actions.extend(agent (a_physic_object: PHYSIC_OBJECT)
										do
											if not attached {WAVE} a_physic_object then
												a_physic_object.collision_actions.call(Current)
											end
										end
								    )

		end

feature {NONE} -- Basic Operations



feature -- Access

	audio_source:AUDIO_SOURCE
		-- Audio source to play the wave's sound.

	sound:SOUND
		-- The sound to be played when the wave is alive.

	wave_texture:GAME_TEXTURE
		-- The wave's game texture

	source: ENTITY
			-- {ENTITY} which created `Current'
			-- Used to determine if it should deal damage or not to an {ENTITY}.

	alpha: NATURAL_8
			-- Alpha channel of `Current'

	energy: REAL_64
			-- Energy left for `Current' to survive

	initial_energy: REAL_64 = 3500.0
			-- Initial `energy'

	energy_loss: REAL_64 = -1000.0
			-- `energy' loss per second

	wave_duration:REAL_64
			-- The total duration of the wave
			once
				Result := (initial_energy / energy_loss).abs
			end

	center_speed: TUPLE[x, y: REAL_64]
			-- Speed of the moving arc center

	radius_speed: REAL_64 = 100.0
			-- Radius incrementation speed of `Current's arc

	direction: REAL_64
			-- Direction of `Current's arc

	angle: REAL_64
			-- Angle of `Current's arc

	radius: REAL_64
			-- Radius of `Current's arc

	dead: BOOLEAN
			-- Whether or not `Current's should be deleted

	color: GAME_COLOR
			-- Color of `Current'

	draw
			-- Draw `Current' on `context's renderer
		require else
			Still_Alive: not dead
		local
			l_previous_color: GAME_COLOR
			l_width_destination:INTEGER_32
			l_height_destination:INTEGER_32
		do
			l_previous_color := context.renderer.drawing_color

			color.set_alpha(alpha)
			context.renderer.set_drawing_color(color)

			l_width_destination := (minimal_bounding_box.upper_corner.x - minimal_bounding_box.lower_corner.x).rounded.abs
			l_height_destination := (minimal_bounding_box.upper_corner.y - minimal_bounding_box.lower_corner.y).rounded.abs
			wave_texture.set_additionnal_alpha (alpha)
			context.renderer.draw_sub_texture_with_scale_rotation_and_mirror (wave_texture,
					0, 0,
					wave_texture.width, wave_texture.height,
					x_real.rounded - context.camera.position.x - (l_width_destination // 2), y_real.rounded - context.camera.position.y - (l_height_destination // 2),
					l_width_destination, l_height_destination, l_width_destination // 2, l_height_destination // 2, angle, False, False)
			draw_box(context)
			context.renderer.set_drawing_color(l_previous_color)
		end

	update(a_timediff: REAL_64)
			-- Update `Current' on every game tick
		require else
			Still_Alive: not dead
		do
			x_real := x_real + (center_speed.x * a_timediff)
			y_real := y_real + (center_speed.y * a_timediff)
			radius := radius + (radius_speed * a_timediff)
			energy := (0.0).max(energy + (energy_loss * a_timediff))
			alpha := (255 * energy / initial_energy).rounded.as_natural_8
			bounding_radius := radius
			center.x := x_real
			center.y := y_real
			dead := energy <= 0
		ensure then
			No_Energy_Equals_Dead: energy <= 0 = dead
			Energy_Loss_Over_Time: (energy = old energy + (energy_loss * a_timediff)) or (energy = 0)
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
