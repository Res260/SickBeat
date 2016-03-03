note
	description: "Abstract class used to make {MENU}s."
	author: "Guillaume Jean"
	date: "Fri, 26 Feb 2016 12:20:00"
	revision: "0.9"

deferred class
	MENU

inherit
	ENGINE
		redefine
			make, run, on_resize, on_size_change, on_restore
		end

feature {NONE} -- Initialization

	make(a_window: GAME_WINDOW_RENDERED; a_ressource_factory: RESSOURCE_FACTORY)
		do
			clicked_button := 0
			Precursor(a_window, a_ressource_factory)
			background_texture := ressource_factory.menu_background
			create {LINKED_LIST[GAME_TEXTURE]} buttons_texture.make
			update_buttons_dimension
		end

feature {NONE} -- Implementation

	on_redraw(a_timestamp: NATURAL_32)
		do
			window.renderer.clear

			if attached background_texture as background then
				window.renderer.draw_sub_texture_with_scale (background, 0, 0, background.width, background.height,
																		 0, 0, window.width, window.height)
			end

			if attached title_texture as la_title and attached title_dimension as la_title_dimension then
				window.renderer.draw_texture(la_title, la_title_dimension.x, la_title_dimension.y)
			end

			from
				buttons_texture.start
				buttons_dimension.start
			until
				buttons_texture.after OR buttons_dimension.after
			loop
				window.renderer.draw_texture(buttons_texture.item, buttons_dimension.item.x, buttons_dimension.item.y)
				buttons_texture.forth
				buttons_dimension.forth
			end

			window.update
		end

	on_clicked(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- Whenever a click is released in the `window'
		do
			if a_mouse_state.is_left_button_released then
				-- Check mouse collisions
				from
					buttons_dimension.start
				until
					buttons_dimension.after
				loop
					if
						buttons_dimension.item.x < a_mouse_state.x and
						buttons_dimension.item.y < a_mouse_state.y and
						buttons_dimension.item.x + buttons_dimension.item.width > a_mouse_state.x and
						buttons_dimension.item.y + buttons_dimension.item.height > a_mouse_state.y
					then
						clicked_button := buttons_dimension.index
						stop
					end
					buttons_dimension.forth
				end
			end
		end

	on_resize(a_timestamp: NATURAL_32; a_width, a_height: INTEGER_32)
			-- Whenever the `window' is resized
		do
			update_buttons_dimension
		end

	on_size_change(a_timestamp: NATURAL_32)
			-- Whenever the `window's size changes
		do
			update_buttons_dimension
		end

	on_restore(a_timestamp: NATURAL_32)
			-- Whenever the `window' is restored
		do
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

	background_texture: detachable GAME_TEXTURE
			-- Image of `Current's background

	title_texture: detachable GAME_TEXTURE
			-- Image of `Current's title

	title_dimension: detachable TUPLE[x, y, width, height: INTEGER]
			-- Position and size of `Current's title

	title_font: TEXT_FONT
			-- Font used to render titles

	buttons_texture: LIST[GAME_TEXTURE]
			-- List of `Current's buttons' text

	buttons_dimension: LIST[TUPLE[x, y, width, height: INTEGER]]
			-- List of `Current's buttons' position and size

	button_font: TEXT_FONT
			-- Font used to render buttons

--	set_background_texture(a_menu_name: READABLE_STRING_GENERAL)
--			-- Set `Current's background texture
--		local
--			l_image: IMG_IMAGE_FILE
--			l_path: PATH
--		do
--			create l_path.make_from_string("ressources")
--			l_path := l_path.extended("images")
--			l_path := l_path.extended(a_menu_name)
--			l_path := l_path.extended("background")
--			l_path := l_path.appended_with_extension("png")
--			create l_image.make(l_path.name)
--			if l_image.is_openable then
--				l_image.open
--				if l_image.is_open then
--					create background_texture.make_from_image (window.renderer, l_image)
--				end
--			end
--		ensure
--			Background_Has_No_Error: attached background_texture as bg_txt and then not bg_txt.has_error
--		end

	set_title(a_title: READABLE_STRING_GENERAL)
			-- Set `Current's title's texture and dimension
		local
			l_image: TEXT_SURFACE_BLENDED
		do
			create l_image.make(a_title, title_font, text_color)
			if l_image.is_open then
				create title_texture.make_from_surface(window.renderer, l_image)
			else
				has_error := True
			end
			update_buttons_dimension
		end

	add_button(a_button_name: READABLE_STRING_GENERAL)
			-- Add a button to `Current's screen with `a_button_name' as text
		local
			l_image: TEXT_SURFACE_BLENDED
		do
			create l_image.make(a_button_name, button_font, text_color)
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
			l_left_margin: INTEGER
			l_left_margin_title: INTEGER
			l_y: INTEGER
		do
			title_font := ressource_factory.menu_font(window.height // 25)
			button_font := ressource_factory.menu_font(window.height // 30)
			l_height_between := window.height // 100
			l_left_margin := window.width // 15
			l_left_margin_title := window.width // 30
			l_y := window.height // 2

			create {ARRAYED_LIST[TUPLE[x, y, width, height: INTEGER]]}buttons_dimension.make(0)

			if attached title_texture as la_title then
				title_dimension := [l_left_margin_title, l_y - la_title.height - l_height_between, la_title.width, la_title.height]
			end

			across buttons_texture as la_buttons loop
				buttons_dimension.extend([l_left_margin, l_y, la_buttons.item.width, la_buttons.item.height])
				l_y := l_y + la_buttons.item.height + l_height_between
			end
		end

	text_color: GAME_COLOR
			-- The color used to draw the foreground (text). TODO: Change it
		once
			create Result.make_rgb(0, 0, 0)
		end

	background_color: GAME_COLOR
			-- The color used to draw the background. TODO: Change it
		once
			create Result.make_rgb(255, 255, 255)
		end

invariant
	Buttons_Size_Synced: buttons_dimension.count = buttons_texture.count
end
