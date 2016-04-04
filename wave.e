note
	description: "{ENTITY} that damages the {ENNEMY}."
	author: "Guillaume Jean"
	date: "29 March 2016"
	revision: "16w08a"

class
	WAVE

inherit
	ENTITY
		redefine
			update,
			draw
		end
	DOUBLE_MATH

create
	make

feature {NONE} -- Initialization

	make(a_x, a_y, a_direction, a_angle: REAL_64; a_center_speed: TUPLE[x, y: REAL_64]; a_color: GAME_COLOR; a_context: CONTEXT)
			-- Initialize `Current' with a direction, angle, maximum radius, and color
		do
			make_entity(a_x, a_y, a_context)
			direction := a_direction
			angle := a_angle
			create color.make_from_other(a_color)
			radius := 0
			lifetime := initial_lifetime
			center_speed := a_center_speed
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
			l_old_x := a_radius * cosine(a_start_angle) + a_center.x
			l_old_y := a_radius * sine(a_start_angle) + a_center.y
			l_resolution_factor := Pi / a_resolution
			from
				i := a_start_angle
			until
				i > a_end_angle + l_resolution_factor
			loop
				l_new_x := a_radius * cosine(i) + a_center.x
				l_new_y := a_radius * sine(i) + a_center.y
				a_renderer.draw_line(l_old_x.rounded, l_old_y.rounded, l_new_x.rounded, l_new_y.rounded)
				l_old_x := l_new_x
				l_old_y := l_new_y
				i := i + l_resolution_factor
			end
		end

feature -- Access

	alpha: NATURAL_8
			-- Alpha channel of `Current'

	lifetime: REAL_64
			-- Time left for `Current' to survive

	initial_lifetime: REAL_64 = 3.5
			-- Initial `lifetime'

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

	hit_max: BOOLEAN
			-- Whether or not `Current's radius has surpassed it's maximum radius

	color: GAME_COLOR
			-- Color of `Current'

	draw
			-- Draw `Current' on `context's renderer
		require else
			Still_In_Screen: not hit_max
		local
			l_previous_color: GAME_COLOR
		do
			l_previous_color := context.renderer.drawing_color

			color.set_alpha(alpha)
			context.renderer.set_drawing_color(color)
			draw_arc(x_real, y_real, direction - angle / 2, direction + angle / 2, radius, 40, context.renderer)

			context.renderer.set_drawing_color(l_previous_color)
		end

	update(a_timediff: REAL_64)
			-- Update `Current' on every game tick
			-- Increments `radius' until it is bigger than max_radius
		require else
			Still_Alive: not hit_max
		do
			x_real := x_real + (center_speed.x * a_timediff)
			y_real := y_real + (center_speed.y * a_timediff)
			radius := radius + (radius_speed * a_timediff)
			lifetime := (0.0).max(lifetime - a_timediff)
			alpha := (255 * lifetime / initial_lifetime).rounded.as_natural_8
			if lifetime <= 0 then
				hit_max := True
			end
		end
end
