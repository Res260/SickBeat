note
	description: "Abstract class used to make {MENU}s."
	author: "Guillaume Jean"
	date: "21 March 2016"
	revision: "16w08a"

deferred class
	MENU

inherit
	GAME_LIBRARY_SHARED
	SOUND_MANAGER_SHARED
	SOUND_FACTORY_SHARED

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Basic creation of a {MENU}
		require
			Ressource_Factory_Has_No_Error: not a_context.ressource_factory.has_error
		do
			clicked_button := 0
			pressed_button := 0
			released_button := 0
			context := a_context
			exit_requested := False
			is_main_menu := False
			create background.make(context.ressource_factory.menu_background, context)
			create {LINKED_LIST[BUTTON]} buttons.make
			update_buttons_dimension
			sound_engine.create_audio_source
			menu_audio_source := sound_engine.last_audio_source
			menu_sound := sound_factory.create_sound_menu_click
		ensure
			context = a_context
		end

	make_as_main(a_context: CONTEXT)
			-- Creation of a {MENU} that makes it the main one
		do
			make(a_context)
			is_main_menu := True
		end

feature {NONE} -- Implementation

	menu_audio_source: AUDIO_SOURCE
			-- Source for the audio sounds of the buttons in `Current'

	menu_sound: SOUND
			-- Sound to be played when clicking the buttons

	context: CONTEXT
			-- Context of the application

	set_events
			-- Set the event handlers for `Current'
		require
			Events_Enabled: game_library.is_events_enable
		do
			game_library.quit_signal_actions.extend(agent on_quit_signal)
			context.window.expose_actions.extend(agent on_redraw)
			context.window.size_change_actions.extend(agent on_size_change)
			context.window.mouse_button_pressed_actions.extend(agent on_pressed)
			context.window.mouse_button_released_actions.extend(agent on_released)
		end

	on_quit_signal(a_timestamp: NATURAL_32)
			-- Method run when the X button of the window is clicked
		do
			close_program
			return_menu
		ensure
			Exit_Requested: exit_requested
		end

	on_redraw(a_timestamp: NATURAL_32)
			-- Redraws the screen
			-- Method run once per tick
		do
			context.renderer.clear

			background.draw

			if attached title as la_title then
				la_title.draw
			end

			across buttons as la_buttons loop
				la_buttons.item.draw
			end

			context.window.update
		end

	on_size_change(a_timestamp: NATURAL_32)
			-- Whenever the `window's size changes
		do
			update_buttons_dimension
			on_redraw(a_timestamp)
		end

	on_restart
			-- Called when `Current' starts again
		do
		end

feature {NONE} -- Basic Operations

	pressed_button: INTEGER
			-- Button pressed at the start of the mouse click

	released_button: INTEGER
			-- Button pressed at the end of the mouse click

	check_button_collision(a_mouse_state: GAME_MOUSE_STATE): INTEGER
			-- Check in which `buttons' the mouse is
			-- Returns the last occurence in the case where it hits multiple buttons
		local
			l_button_index: INTEGER
		do
			across buttons as la_buttons loop
				if la_buttons.item.point_in_button(a_mouse_state.x, a_mouse_state.y) then
					l_button_index := la_buttons.cursor_index
				end
			end
			Result := l_button_index
		end

	on_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8)
			-- Whenever a mouse button is pressed in the `window'
		do
			if a_mouse_state.is_left_button_pressed then
				pressed_button := check_button_collision(a_mouse_state)
			end
		end

	on_released(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- Whenever a mouse button is released in the `window'
		do
			if a_mouse_state.is_left_button_released then
				released_button := check_button_collision(a_mouse_state)
			end
			if pressed_button = released_button then
				clicked_button := released_button
			end
			if clicked_button > 0 then
				buttons.at(clicked_button).do_click
			end
		end

feature -- Access

	is_main_menu: BOOLEAN
			-- Whether or not `Current' is the main menu

	exit_requested: BOOLEAN
			-- Whether or not the program has been requested to stop

	returning_to_main: BOOLEAN
			-- Whether or not `Current' has to recursively return menus until `Current' has `is_main_menu' set to True

	stop_menu: BOOLEAN
			-- Whether or not the current menu needs to stop and return to the previous one

	clicked_button: INTEGER
			-- Index of the `buttons' clicked by the user.

	background: BACKGROUND
			-- `Current's background

	title: detachable TEXT
			-- `Current's title

	buttons: LIST[BUTTON]
			-- List of `Current's buttons

	next_menu: detachable MENU
			-- Menu ran when `Current' stops

	start
			-- Start the execution of `Current's loop
			-- Handles the `next_menu'
		do
			from
				clicked_button := 0
			until
				stop_menu
			loop
				context.window.renderer.set_drawing_color(background_color)
				set_events
				update_buttons_dimension
				on_restart
				on_redraw(game_library.time_since_create)
				game_library.launch
				game_library.clear_all_events
				if attached next_menu as la_menu then
					la_menu.start
					if la_menu.exit_requested then
						close_program
					elseif la_menu.returning_to_main then
						if not is_main_menu then
							return_to_main
						end
					end
				end
			end
		end

	continue_to_next
			-- Stop this {MENU} and go to `next_menu'
		do
			game_library.stop
		end

	return_menu
			-- Quit this {MENU} and return to the previous one
		do
			stop_menu := True
			continue_to_next
		end

	return_to_main
			-- Quit this {MENU} and return previous ones until only the {MENU} with `is_main_menu' set to True is running
		do
			returning_to_main := True
			return_menu
		end

	close_program
			-- Recursively exit all {MENU}s
		do
			exit_requested := True
			return_menu
		end

	set_title(a_title: READABLE_STRING_GENERAL)
			-- Set `Current's title's texture and dimension
		do
			create title.make(a_title, text_color, context)
			update_buttons_dimension
		end

	add_button(a_button_name: READABLE_STRING_GENERAL; a_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]])
			-- Add a button to `Current's screen with `a_button_name' as text
		local
			l_button: BUTTON
		do
			create l_button.make(a_button_name, text_color, context, a_action)
			buttons.extend(l_button)
			update_buttons_dimension
		ensure
			Button_List_Is_Bigger: old buttons.count + 1 = buttons.count
		end

	update_buttons_dimension
			-- Modify the `buttons' position and `title' to adjust their positions
			-- by following the size of the `buttons' texture and `title's text
		local
			l_height_between: INTEGER
			l_left_margin: INTEGER
			l_left_margin_title: INTEGER
			l_y: INTEGER
			l_button_font_size: INTEGER
			l_title_font_size: INTEGER
			l_title_font: TEXT_FONT
		do
			l_title_font_size := context.window.height // 15
			l_title_font := context.ressource_factory.menu_font(l_title_font_size)
			l_button_font_size := context.window.height // 30
			l_height_between := context.window.height // 100
			l_left_margin := context.window.width // 15
			l_left_margin_title := context.window.width // 30
			l_y := context.window.height // 2
			if attached title as la_title then
				la_title.change(l_left_margin_title, l_y - l_title_font.text_dimension(la_title.text).height - l_height_between, l_title_font_size)
			end
			across buttons as la_buttons loop
				la_buttons.item.change(l_left_margin, l_y, l_button_font_size)
				if attached la_buttons.item.texture as la_texture then
					l_y := l_y + la_texture.height + l_height_between
				end
			end
		end

	text_color: GAME_COLOR
			-- The color used to draw the `buttons' and the `title'
		once
			create Result.make_rgb(0, 0, 0)
		end

	background_color: GAME_COLOR
			-- The color used to draw behind the actual `background'
		once
			create Result.make_rgb(255, 255, 255)
		end

invariant
	Pressed_Button_Valid: 0 <= pressed_button and pressed_button <= buttons.count
	Released_Button_Valid: 0 <= released_button and released_button <= buttons.count
	Clicked_Button_Valid: 0 <= clicked_button and clicked_button <= buttons.count
end
