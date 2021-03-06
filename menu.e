note
	description: "Abstract class used to make {MENU}s."
	author: "Guillaume Jean and �milio G!"
	date: "2016-05-17"
	revision: "16w15a"
	legal: "See notice at end of class."

deferred class
	MENU

inherit
	GAME_LIBRARY_SHARED
	SOUND_MANAGER_SHARED
	SOUND_FACTORY_SHARED

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initializes `Current' with `a_context' to gather global information
		require
			Ressource_Factory_Has_No_Error: not a_context.ressource_factory.has_error
		do
			clicked_button := 0
			pressed_button := 0
			released_button := 0
			context := a_context
			exit_requested := False
			is_main_menu := False
			create mouse.make(0, 0)
			create background.make(context.ressource_factory.menu_background)
			create {LINKED_LIST[BUTTON]} buttons.make
			create {LINKED_LIST[TEXTBOX]} textboxes.make
			update_buttons_dimension
			menu_audio_source := sound_manager.get_audio_source
			menu_sound := sound_factory.create_sound_menu_click
		ensure
			context = a_context
		end

	make_as_main(a_context: CONTEXT)
			-- Creation of `Current' that makes it the main one
		do
			make(a_context)
			is_main_menu := True
		end

feature {NONE} -- Implementation

	started: BOOLEAN
			-- Whether or not `Current' has started
			-- Used for on_start

	menu_audio_source: detachable AUDIO_SOURCE
			-- Source for the audio sounds of the buttons in `Current'

	menu_sound: SOUND
			-- Sound to be played when clicking the buttons

	play_menu_sound_click
			-- Plays the menu sound click
		do
			if attached menu_audio_source as la_menu_audio_source then
				if(la_menu_audio_source.is_playing) then
					la_menu_audio_source.stop
				end
				la_menu_audio_source.queue_sound(menu_sound)
				la_menu_audio_source.play
			end
		end

	set_events
			-- Set the event handlers for `Current'
		require
			Events_Enabled: game_library.is_events_enable
		do
			game_library.quit_signal_actions.extend(agent on_quit_signal)
			game_library.iteration_actions.extend(agent on_iteration)
			context.window.expose_actions.extend(agent on_redraw)
			context.window.size_change_actions.extend(agent on_size_change)
			context.window.mouse_button_pressed_actions.extend(agent on_pressed)
			context.window.mouse_button_released_actions.extend(agent on_released)
			context.window.mouse_motion_actions.extend(agent on_mouse_motion)
			context.window.key_pressed_actions.extend(
					agent (a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
						do
							across textboxes as la_textbox loop
								la_textbox.item.on_key_pressed(a_key_state)
							end
							on_redraw(a_timestamp)
						end
				)
			context.window.text_input_actions.extend(
					agent (a_timestamp: NATURAL_32; a_text: STRING_32)
						do
							across textboxes as la_textbox loop
								la_textbox.item.on_text_input(a_text)
							end
							on_redraw(a_timestamp)
						end
				)
		end

	on_iteration(a_timestamp: NATURAL_32)
			-- Method run on every iteration
		do
			if not started then
				started := True
				on_start
			end
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

			background.draw(context)

			if attached title as la_title then
				la_title.draw(context)
			end

			across buttons as la_buttons loop
				la_buttons.item.draw(context)
			end

			across textboxes as la_textboxes loop
				la_textboxes.item.draw
			end

			context.window.update
		end

	on_size_change(a_timestamp: NATURAL_32)
			-- Whenever the `window's size changes
		do
			update_buttons_dimension
			on_redraw(a_timestamp)
		end

	on_start
			-- Called when `Current' starts
		do
		end

	on_stop
			-- Called when `Current' is stopped
		do
		end

	on_restart
			-- Called when `Current' starts again
		do
			context.camera.move_to_position(context.window.width // 2, context.window.height // 2, context.window)
		end

	on_cleanup
			-- Called when `Current' isn't used anymore
		do
		end

	on_mouse_motion(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_MOTION_STATE; a_delta_x, a_delta_y: INTEGER)
			-- Handles the mouse_motion (`a_mouse_state') event
			-- Updates `mouse''s position
		do
			mouse.position := [a_mouse_state.x + context.camera.position.x, a_mouse_state.y + context.camera.position.y]
		end

feature {NONE} -- Basic Operations

	pressed_button: INTEGER
			-- Button pressed at the start of the mouse click

	released_button: INTEGER
			-- Button pressed at the end of the mouse click

	check_button_collision: INTEGER
			-- Check in which `buttons' the `mouse' is
			-- Returns the last occurence in the case where it hits multiple buttons
		local
			l_button_index: INTEGER
		do
			across buttons as la_buttons loop
				if mouse.collides_with_other(la_buttons.item) then
					l_button_index := la_buttons.cursor_index
				end
			end
			Result := l_button_index
		end

	on_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8)
			-- Whenever a mouse button is pressed in the `window'
		do
			mouse.position := [a_mouse_state.x + context.camera.position.x, a_mouse_state.y + context.camera.position.y]
			if a_mouse_state.is_left_button_pressed then
				mouse.buttons.left := True
				pressed_button := check_button_collision
			elseif a_mouse_state.is_middle_button_pressed then
				mouse.buttons.mouse_wheel := True
			elseif a_mouse_state.is_right_button_pressed then
				mouse.buttons.right := True
			end
		end

	on_released(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_nb_clicks: NATURAL_8)
			-- Whenever a mouse button is released in the `window'
		do
			mouse.position := [a_mouse_state.x + context.camera.position.x, a_mouse_state.y + context.camera.position.y]
			if a_mouse_state.is_left_button_released then
				mouse.buttons.left := False
				released_button := check_button_collision
			elseif a_mouse_state.is_middle_button_released then
				mouse.buttons.mouse_wheel := False
			elseif a_mouse_state.is_right_button_released then
				mouse.buttons.right := False
			end
			if pressed_button = released_button then
				clicked_button := released_button
			end
			if clicked_button > 0 then
				buttons.at(clicked_button).do_click
			end
		end

feature -- Access

	context: CONTEXT
			-- Context of the application

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

	mouse: MOUSE
			-- `Current's mouse

	background: BACKGROUND
			-- `Current's background

	title: detachable TEXT
			-- `Current's title

	buttons: LIST[BUTTON]
			-- List of `Current's buttons

	textboxes: LIST[TEXTBOX]
			-- List of `Current's textboxes

	next_menu: detachable MENU
			-- Menu ran when `Current' stops

	useless_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the useless button
		do
			play_menu_sound_click
		end

	start
			-- Start the execution of `Current's loop
			-- Handles the�`next_menu'
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
				on_stop
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
			on_cleanup
		end

	continue_to_next
			-- Stop this {MENU} and go to `next_menu'
		do
			game_library.stop
		end

	return_menu
			-- Quit this {MENU}�and return to the previous one
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
			create title.make(a_title, text_color)
			update_buttons_dimension
		end

	add_button(a_button_name: READABLE_STRING_GENERAL; a_action: PROCEDURE[ANY, TUPLE[READABLE_STRING_GENERAL]])
			-- Add a button to `Current's screen with `a_button_name' as text
		local
			l_button: BUTTON
		do
			create l_button.make(a_button_name, text_color, a_action)
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
		do
			l_title_font_size := context.window.height // 15
			context.ressource_factory.generate_font(l_title_font_size)
			if attached context.ressource_factory.last_font as la_font then
				l_button_font_size := context.window.height // 30
				l_height_between := context.window.height // 100
				l_left_margin := context.window.width // 15
				l_left_margin_title := context.window.width // 30
				l_y := context.window.height // 2
				if attached title as la_title then
					la_title.change(l_left_margin_title, l_y - la_font.text_dimension(la_title.text).height - l_height_between, l_title_font_size, context)
				end
				across buttons as la_buttons loop
					la_buttons.item.change(l_left_margin, l_y, l_button_font_size, context)
					if attached la_buttons.item.texture as la_texture then
						l_y := l_y + la_texture.height + l_height_between
					end
				end
			end


		end

	add_textbox(a_button_reference: BUTTON)
		-- Add a textbox to `Current's screen
			local
				l_textbox: TEXTBOX
			do
				create l_textbox.make (a_button_reference.upper_corner.x.rounded + 5, a_button_reference.y, 400, 30, 5, context)
				textboxes.extend(l_textbox)
			ensure
				Textbox_List_Is_Bigger: old textboxes.count + 1 = textboxes.count
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
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
