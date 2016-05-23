note
	description: "{HUD_INFORMATION} drawing the health amount of the player"
	author: "Guillaume Jean"
	date: "2016-05-22"
	revision: "16w16a"

class
	HUD_HEALTH

inherit
	HUD_INFORMATION
		redefine
			draw
		end

create
	make

feature {NONE} -- Initialization

	make(a_max_health, a_health: REAL_64; a_x, a_y: INTEGER)
			-- Initializes `Current' to scale `a_health' over `a_max_health'
		do
			max_health := a_max_health
			value := a_health
			x := a_x
			y := a_y
		end

feature {NONE} -- Implementation

	max_health: REAL_64
			-- Maximum amount of health the player has

	background_color: GAME_COLOR
			-- Background color of the health bar
		once("PROCESS")
			create Result.make(255, 255, 255, 255)
		end

	border_color: GAME_COLOR
			-- Border color of the health bar
		once("PROCESS")
			create Result.make(0, 0, 0, 255)
		end

feature -- Implementation

	update_value(a_value: ANY)
			-- Updates `current_health' to `a_value' if it is a {REAL_64}
		require else
			New_Value_Real: attached {REAL_64} a_value
		do
			value := a_value
		end

feature -- Access

	draw(a_context: CONTEXT)
			-- Draws the health scale on `a_context's window
		local
			l_healthyness: REAL_64
			l_green, l_red: NATURAL_8
		do
			if attached {REAL_64} value as la_health then
				a_context.renderer.set_drawing_color(border_color)
				a_context.renderer.draw_filled_rectangle(x, y, 106, 26)
				a_context.renderer.set_drawing_color(background_color)
				a_context.renderer.draw_filled_rectangle(x + 3, y + 3, 100, 20)
				l_healthyness := la_health / max_health
				l_green := (255.0).min(512 * l_healthyness).rounded.as_natural_8
				l_red := (255.0).min(512 - (512 * l_healthyness)).rounded.as_natural_8
				a_context.renderer.set_drawing_color(create {GAME_COLOR}.make(l_red, l_green, 0, 255))
				a_context.renderer.draw_filled_rectangle(x + 3, y + 3, (100 * l_healthyness).rounded, 20)
			end
		end

end
