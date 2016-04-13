note
	description: "{ENTITY} that damages other entities and augments in size."
	author: "Guillaume Jean"
	date: "12 April 2016"
	revision: "16w010a"
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

create
	make

feature {NONE} -- Initialization

	make(a_x, a_y, a_direction, a_angle: REAL_64; a_center_speed: TUPLE[x, y: REAL_64]; a_color: GAME_COLOR; a_source: ENTITY; a_context: CONTEXT)
			-- Initialize `Current' with a direction, angle, maximum radius, and color
		do
			make_entity(a_x, a_y, a_context)
			direction := a_direction
			angle := a_angle
			create color.make_from_other(a_color)
			radius := a_source.width / 2
			energy := initial_energy
			center_speed := a_center_speed
			source := a_source
			make_bounding_arc(a_x, a_y, a_direction, a_angle, radius)
		end

feature {NONE} -- Basic Operations

	draw_arc(a_center: TUPLE[x, y: REAL_64]; a_start_angle, a_end_angle, a_radius: REAL_64; a_resolution: INTEGER; a_renderer: GAME_RENDERER)
			-- Draw an arc centered on a_center with a_radius at a_resolution from a_start_angle to a_end_angle
		require
			Start_Angle_Smaller: a_start_angle < a_end_angle
		local
			l_old_x: REAL_64
			l_old_y: REAL_64
			l_new_x: REAL_64
			l_new_y: REAL_64
			l_resolution_factor: REAL_64
			i: REAL_64
		do
			l_resolution_factor := (a_end_angle - a_start_angle) / a_resolution
			l_old_x := a_radius * cosine(a_start_angle) + a_center.x
			l_old_y := a_radius * sine(a_start_angle) + a_center.y
			from
				i := a_start_angle + l_resolution_factor
			until
				i >= a_end_angle
			loop
				l_new_x := a_radius * cosine(i) + a_center.x
				l_new_y := a_radius * sine(i) + a_center.y
				a_renderer.draw_line(l_old_x.rounded, l_old_y.rounded, l_new_x.rounded, l_new_y.rounded)
				l_old_x := l_new_x
				l_old_y := l_new_y
				i := i + l_resolution_factor
			end
			l_new_x := a_radius * cosine(a_end_angle) + a_center.x
			l_new_y := a_radius * sine(a_end_angle) + a_center.y
			a_renderer.draw_line(l_old_x.rounded, l_old_y.rounded, l_new_x.rounded, l_new_y.rounded)
		end

feature -- Access

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
		do
			l_previous_color := context.renderer.drawing_color

			color.set_alpha(alpha)
			context.renderer.set_drawing_color(color)
			draw_arc(x_real - context.camera.position.x, y_real - context.camera.position.y, direction - angle / 2, direction + angle / 2,
						radius, 40, context.renderer)

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
			if energy <= 0 then
				dead := True
			end
		ensure then
			No_Energy_Equals_Dead: energy <= 0 = dead
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
