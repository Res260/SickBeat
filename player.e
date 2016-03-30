note
	description: "Special {ENTITY} controlled by the user."
	author: "Guillaume Jean"
	date: "27 March 2016"
	revision: "16w08a"

class
	PLAYER

inherit
	ENTITY
		redefine
			draw,
			update
		end

create
	make

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialize `Current'
		do
			x_real := a_context.window.width / 2
			y_real := a_context.window.height / 2
			make_entity(x_real, y_real, a_context)
			create max_speed
			create acceleration
			create speed
			max_speed.x := 75
			max_speed.y := 75
			create color.make(255, 255, 255, 255)
		end

feature {NONE} -- Implementation

	max_speed: TUPLE[x, y: REAL_64]
			-- Max speed of `Current'

	acceleration: TUPLE[x, y: REAL_64]
			-- Acceleration of `Current'

feature -- Access

	speed: TUPLE[x, y: REAL_64]
			-- Speed of `Current'

	color: GAME_COLOR assign set_color
			-- Color of `Current'

	draw
			-- Draw `Current' using `context's renderer
		local
			l_previous_color: GAME_COLOR
		do
			l_previous_color := context.renderer.drawing_color

			context.renderer.set_drawing_color(color)
			context.renderer.draw_filled_rectangle(x - 25, y - 25, 50, 50)

			context.renderer.set_drawing_color(l_previous_color)
		end

	update(a_timediff: REAL_64)
			-- Update `Current's `speed' and position from it's `acceleration'
		do
			speed.x := max_speed.x.opposite.max(max_speed.x.min(speed.x + acceleration.x * a_timediff))
			speed.y := max_speed.y.opposite.max(max_speed.y.min(speed.y + acceleration.y * a_timediff))
			x_real := x_real + a_timediff * speed.x
			y_real := y_real + a_timediff * speed.y
			x := x_real.rounded
			y := y_real.rounded
		end

	set_acceleration(a_x_accel, a_y_accel: REAL_64)
			-- Change `Current's acceleration
		do
			acceleration.x := a_x_accel
			acceleration.y := a_y_accel
		end

	set_color(a_color: GAME_COLOR)
			-- Change `Current's color
		do
			color := a_color
		end
end
