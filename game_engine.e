note
	description: "{MENU} implementing game specific mechanics and rendering. This needs to be a {MENU} so the menus can naviguate to it."
	author: "Guillaume Jean"
	date: "22 March 2016"
	revision: "16w08a"
	legal: "See notice at end of class."

class
	GAME_ENGINE

inherit
	MENU
		redefine
			make,
			on_redraw,
			on_pressed,
			set_events,
			on_restart
		end
	MATH_UTILITY

create
	make,
	make_as_main

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialize all the attributs
		do
			Precursor(a_context)
			create background.make_movable(context.ressource_factory.game_background, [3840, 2160], context)
			create current_map.make(background, context)
			create renderer.make(current_map, context)
			create current_player.make(context)
			create {LINKED_LIST[ENTITY]} entities.make
			create {ARRAYED_LIST[HUD_ITEM]} hud_items.make(0)
			create {ARRAYED_LIST[DRAWABLE]} drawables.make(0)
			entities.extend(current_player)
			drawables.extend(current_player)
			time_since_last := 0
			last_tick := 0
			current_player.launch_wave_event.extend(agent (a_wave:WAVE)
														do
															add_entity_to_world(a_wave)
														end
													)
		end

feature {NONE} -- Implementation

	frame_display: INTEGER
			-- Number of frames in the past second

	frame_counter: INTEGER
			-- Number of frames this second

	second_counter: REAL_64
			-- Time since last frame

	player_acceleration: REAL_64 = 200.0
			-- Acceleration of the player

	key_up, key_down, key_left, key_right: BOOLEAN
			-- Booleans for each movement keys, if true, the key is currently held

	last_tick: NATURAL_32
			-- Time of last update in milliseconds

	time_since_last: REAL_64
			-- Time since last update in seconds

	set_events
			-- Sets the event handlers for `Current'
		do
			Precursor
			context.window.key_pressed_actions.extend(agent on_key_press)
			context.window.key_released_actions.extend(agent on_key_release)
			context.window.keyboard_focus_lost_actions.extend(agent on_keyboard_focus_lost)
			context.window.mouse_motion_actions.extend(agent on_mouse_motion)
			context.window.mouse_wheel_move_actions.extend(agent on_mouse_wheel)
			game_library.iteration_actions.extend(agent on_tick)
		end

	on_tick(a_timestamp: NATURAL_32)
			-- Method run on every iteration (should be 60 times per second)
		do
			if last_tick <= 0 then
				time_since_last := 0
			else
				time_since_last := (a_timestamp - last_tick) / 1000
			end
			last_tick := a_timestamp

			second_counter := second_counter + time_since_last
			if second_counter >= 1.0 then
				second_counter := second_counter - 1.0
				frame_display := frame_counter
				frame_counter := 0
				io.put_string("Frames: " + frame_display.out + "%N")
			end

			update_player
			update_camera

			clear_out_of_bounds_waves

			on_redraw(a_timestamp)
		end

	clear_out_of_bounds_waves
			-- Clears every {WAVE} that is no longer visible in the screen
		local
			l_to_remove: LINKED_LIST[ENTITY]
		do
			create l_to_remove.make
			across entities as la_entities loop
				la_entities.item.update(time_since_last)
				if attached {WAVE} la_entities.item as la_wave then
					if la_wave.collides_with_other(current_player) then
--						io.put_string("PogChamp Collision!%N")
					end
					if la_wave.dead then
						l_to_remove.extend(la_wave)
					end
				end
			end
			from
				l_to_remove.start
				entities.start
				drawables.start
			until
				l_to_remove.exhausted
			loop
				entities.prune(l_to_remove.item)
				drawables.prune(l_to_remove.item)
				l_to_remove.forth
			end
		ensure
			Entities_Out_Of_Bounds_Deleted: across entities as la_entities all
												if attached {WAVE} la_entities.item as la_wave then
													not la_wave.dead
												else
													True
												end
											end
			Drawables_Out_Of_Bounds_Deleted: across drawables as la_drawables all
												if attached {WAVE} la_drawables.item as la_wave then
													not la_wave.dead
												else
													True
												end
											end
		end

	update_player
			-- Update `current_player's speed by following physics
			-- might be ported into physics engine later
		local
			l_x_accel: REAL_64
			l_y_accel: REAL_64
		do
			l_x_accel := -current_player.speed.x
			l_y_accel := -current_player.speed.y
			if key_up then
				l_y_accel := l_y_accel - player_acceleration
			end
			if key_down then
				l_y_accel := l_y_accel + player_acceleration
			end
			if key_left then
				l_x_accel := l_x_accel - player_acceleration
			end
			if key_right then
				l_x_accel := l_x_accel + player_acceleration
			end

			current_player.set_acceleration(l_x_accel, l_y_accel)
		end

	update_camera
			-- Update `context.camera's position
		do
			context.camera.move_at_entity(current_player, context.window)
		end

	on_restart
			-- Reset the tick counter in order to prevent the game to continue playing when pausing
		do
			last_tick := 0
		ensure then
			Tick_Reset: last_tick = 0
		end

	on_redraw(a_timestamp: NATURAL_32)
			-- Redraw the screen
		do
			frame_counter := frame_counter + 1
			renderer.render(drawables)
		end

	on_keyboard_focus_lost(a_timestamp: NATURAL_32)
			-- Reset the keys whenever the keyboard focus is lost
		do
			key_left := False
			key_right := False
			key_up := False
			key_down := False
		ensure then
			Keys_Are_No_Longer_Held: not key_left and not key_right and not key_up and not key_down
		end

	on_key_press(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Handles the key_press event
			-- Pauses the game when pressing the Escape key
			-- Moves the player or changes it color
		do
			if not a_key_state.is_repeat then
				if a_key_state.is_escape then
					create {MENU_PAUSE} next_menu.make(context)
					continue_to_next
				elseif a_key_state.is_f3 then
					context.debugging := not context.debugging
				end
			end
			if a_key_state.is_a then
				key_left := True
			elseif a_key_state.is_d then
				key_right := True
			elseif a_key_state.is_w then
				key_up := True
			elseif a_key_state.is_s then
				key_down := True
			elseif a_key_state.is_1 then
				current_player.set_color_index(0)
			elseif a_key_state.is_2 then
				current_player.set_color_index(1)
			elseif a_key_state.is_3 then
				current_player.set_color_index(2)
			elseif a_key_state.is_4 then
				current_player.set_color_index(3)
			elseif a_key_state.is_5 then
				current_player.set_color_index(4)
			end
		end

	on_key_release(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Handle the key_release event
			-- Resets the movement keys
		do
			if a_key_state.is_a then
				key_left := False
			elseif a_key_state.is_d then
				key_right := False
			elseif a_key_state.is_w then
				key_up := False
			elseif a_key_state.is_s then
				key_down := False
			end
		end

	on_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8)
			-- Handle the mouse_button_pressed event
			-- Shoots waves where the player is aiming at
		do
			current_player.on_click(a_mouse_state)
		end

	on_mouse_wheel(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_EVENTS_STATE; a_delta_x, a_delta_y: INTEGER)
			-- Handle the mouse_wheel_move event
			-- Changes `current_player's color by looping through the `wave_colors'
		do
			current_player.set_color_index((current_player.color_index + a_delta_y + current_player.colors.count) \\ current_player.colors.count)
		end

feature -- Basic Operations

	add_entity_to_world(a_entity: ENTITY)
			-- Adds an entity to the world
		do
--			if attached {TOURELLE} a_entity as la_tourelle then
--				la_tourelle.launch_wave_event(agent add_entity_to_world)
--			end
			entities.extend(a_entity)
			drawables.extend(a_entity)
		end

feature -- Initialization

	renderer: RENDER_ENGINE
			-- Object rendering engine

	current_player: PLAYER
			-- {PLAYER} currently being controlled by the user

	network: NETWORK_ENGINE
			-- `network'
		attribute check False then end end --| Remove line when `network' is initialized in creation procedure.

feature -- Access

	hud_items: LIST[HUD_ITEM]
			-- `hud_items'
		attribute check False then end end --| Remove line when `hud_items' is initialized in creation procedure.

	current_map: MAP
			-- Map currently played

	physics: PHYSICS_ENGINE
			-- `physics'
		attribute check False then end end --| Remove line when `physics' is initialized in creation procedure.

	entities: LIST[ENTITY]
			-- List of all entities to update every tick

	drawables: LIST[DRAWABLE]
			-- List of all objects to render every frame
invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
