note
	description: "Summary description for {MENU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MENU

inherit
	ENGINE
		redefine
			make, run
		end

feature {NONE} -- Initialization

	make(a_window: GAME_WINDOW_RENDERED)
		do
			clicked_button := 0
			Precursor(a_window)
			update_buttons_dimension
		end

feature -- Access

	has_error: BOOLEAN
		-- Previous action caused an error

	run
		do
			clicked_button := 0
			window.renderer.set_drawing_color(background_color)
			window.mouse_button_released_actions.extend(agent on_clicked)
			Precursor
		end

	clicked_button: INTEGER
		-- Integer representing the button clicked by the user.

feature -- Implementation

	on_redraw(a_timestamp: NATURAL_32)
		do
			window.renderer.clear

			-- TODO: Draw stuff here

			window.update
		end

	on_clicked(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- Whenever a click happens in the `window'
		do
			if a_mouse_state.is_left_button_released and a_nb_clicks = 1 then
				-- Check mouse collisions
			end
		end

	title_texture: detachable GAME_TEXTURE
			-- Image of `Current's title

	title_dimension: detachable TUPLE[x, y, width, height: INTEGER]
			-- Position and size of `Current's title

	buttons_texture: LIST[GAME_TEXTURE]
			-- List of `Current's buttons' text

	buttons_dimension: LIST[TUPLE[x, y, width, height: INTEGER]]
			-- List of `Current's buttons' position and size

	font: TEXT_FONT
			-- Font used to generate the images in `Current'

	set_title(a_title: READABLE_STRING_GENERAL)
			-- Set `Current's title's texture and dimension
		local
			l_image: TEXT_SURFACE_SHADED
		do
			create l_image.make(a_title, font, foreground_color, background_color)
			if l_image.is_open then
				create title.make_from_surface(window.renderer, l_image)
			else
				has_error := True
			end
			update_buttons_dimension
		end

	add_button(a_button_name: READABLE_STRING_GENERAL)
			-- Add a button to `Current's screen with `a_button_name' as text
		local
			l_image: TEXT_SURFACE_SHADED
		do
			create l_image.make(a_button_name, font, foreground_color, background_color)
			if l_image.is_open then
				buttons_texture.extend(create {GAME_TEXTURE}.make_from_surface(window.renderer, l_image))
			else
				has_error := True
			end
			update_buttons_dimension
		end

	update_buttons_dimension
			-- Modify the `buttons_dimension' and `title_dimension' to adjust their positions
			-- by following the size of the `buttons_texture' and `title_texture'
		local
			l_height_between: INTEGER
			l_total_height: INTEGER
			l_y: INTEGER
			l_window_half_width: INTEGER
		do
			create {ARRAYED_LIST[TUPLE[x, y, width, height: INTEGER]]}buttons_dimension.make(0)

			
		end

	foreground_color: GAME_COLOR
			-- The color used to draw the foreground (text).
		once
			create Result.make_rgb(0, 0, 0)
		end

	background_color: GAME_COLOR
			-- The color used to draw the background.
		once
			create Result.make_rgb(255, 255, 255)
		end
end
