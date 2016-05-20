note
	description: "{MENU} implementing game specific mechanics and rendering. This needs to be a {MENU} so the menus can naviguate to it."
	author: "Guillaume Jean and Émilio G!"
	date: "2016-05-17"
	revision: "16w15a"
	legal: "See notice at end of class."

class
	GAME_ENGINE

inherit
	MENU
		redefine
			make,
			on_redraw,
			set_events,
			on_restart,
			on_stop
		end
	GAME_CORE
	MATH_UTILITY

create
	make,
	make_multiplayer,
	make_multiplayer_host,
	make_as_main

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialize all the attributes and sets `context' with `a_context'
		do
			Precursor(a_context)
			make_core
			create controller.make(mouse)
			create background.make_movable(context.ressource_factory.game_background, [3840, 2160])
			create current_map.make([3840.0, 2160.0], a_context.image_factory.get_ennemy_texture_tuple, a_context.image_factory.get_arcs_texture_tuple)
			current_map.start_spawning
			create {ARRAYED_LIST[HUD_ITEM]}hud_items.make(2)
			score := 0
			hud_items.extend (create {HUD_SCORE}.make(score, 20, 20, "localhost", context))
			hud_items.extend (create {HUD_SCORE}.make(-1, 20, 40, "", context))
			create renderer.make(background, hud_items, context)
			create physics.make
			create current_player.make([context.window.width / 2, context.window.height / 2], controller, context)
			create {LINKED_LIST[ENTITY]} entities.make
			create {ARRAYED_LIST[DRAWABLE]} drawables.make(0)
			entities.extend(current_player)
			drawables.extend(current_player)
			physics.physic_objects.extend(current_player)
			time_since_last_frame := 0
			last_frame := 0
			create game_update_mutex.make
			create {LINKED_LIST[ENNEMY]} ennemies.make
			create game_update_thread.make(game_update_mutex, Current)
			controller.mouse_button_update_actions.extend(agent current_player.on_click)
			controller.mouse_wheel_actions.extend(agent current_player.on_mouse_wheel)
			controller.number_actions.extend(agent current_player.set_color_index)
			current_player.collision_actions.extend(agent (a_physic_object: PHYSIC_OBJECT)
														do
															--io.put_string("BOOM!")
														end
												   )
			current_player.launch_wave_event.extend(agent (a_wave:WAVE)
														do
															add_entity_to_world(a_wave)
														end
												   )
			current_map.spawn_enemies_actions.extend(agent (a_ennemy: ENNEMY)
														do
															add_ennemy_to_world(a_ennemy)
														end
													)
		end

	make_multiplayer(a_context: CONTEXT; a_network_engine: NETWORK_ENGINE)
			-- Initialize all the attributes for a multiplayer game (sets `network_engine' to `a_network_engine') where you join a game.
		do
			make(a_context)
			current_map.stop_spawning
			network_engine := a_network_engine
			if attached network_engine as la_network_engine then
				create game_update_thread.make_multiplayer(game_update_mutex, Current, la_network_engine)
			end
		end

	make_multiplayer_host(a_context: CONTEXT; a_network_engine: NETWORK_ENGINE)
			-- Initializes all the attributes for a multiplayer game (sets `network_engine' to `a_network_engine')
			-- where you are the host
		do
			a_network_engine.initiate_server
			network_engine := a_network_engine
			make(a_context)
			current_map.stop_spawning
		end

feature {NONE} -- Implementation

	game_update_mutex: MUTEX
			-- Mutex used to lock the rendered objects

	game_update_thread: detachable GAME_UPDATE_THREAD
			-- Thread used for the game updates

	set_events
			-- Sets the event handlers for `Current'
		do
			Precursor
			context.window.key_pressed_actions.extend(agent on_key_press)
			context.window.key_pressed_actions.extend(
					agent (a_timestamp: NATURAL_32; a_game_key: GAME_KEY_STATE)
						do current_player.controller.on_key_pressed(a_game_key) end
				)
			context.window.key_released_actions.extend(
					agent (a_timestamp: NATURAL_32; a_game_key: GAME_KEY_STATE)
						do current_player.controller.on_key_release (a_game_key) end
				)
			context.window.keyboard_focus_lost_actions.extend(
					agent (a_timestamp: NATURAL_32)
						do current_player.controller.clear_keyboard end
				)
			context.window.mouse_button_pressed_actions.extend(
					agent (a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_clicks: NATURAL_8)
						do controller.on_mouse_button_update(a_mouse_state) end
				)
			context.window.mouse_button_released_actions.extend(
					agent (a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_RELEASED_STATE; a_clicks: NATURAL_8)
						do controller.on_mouse_button_update(a_mouse_state) end
				)
			context.window.mouse_motion_actions.extend(
					agent (a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_MOTION_STATE; a_delta_x, a_delta_y: INTEGER)
						do current_player.controller.on_mouse_update(a_mouse_state) end
				)
			context.window.mouse_wheel_move_actions.extend(
					agent (a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_EVENTS_STATE; a_delta_x, a_delta_y: INTEGER)
						do current_player.controller.on_mouse_wheel(a_delta_x, a_delta_y) end
				)
			game_library.iteration_actions.extend(agent on_tick)
		end

	on_tick(a_timestamp: NATURAL_32)
			-- Method run on every iteration (should be 60 times per second)
		do

			if attached {HUD_SCORE} hud_items.at(2) as la_other_score then
				if attached network_engine as la_network_engine then
					la_network_engine.set_self_score(score.out)
					if la_network_engine.is_connected then
						la_other_score.update_value(la_network_engine.friend_score.to_integer)
						la_other_score.should_draw := True
					else
						la_other_score.should_draw := False
					end
				else
					la_other_score.should_draw := False
				end
			end

			game_update_mutex.lock

			if last_frame <= 0 then
				time_since_last_frame := 0
			else
				time_since_last_frame := (a_timestamp - last_frame) / 1000
			end
			last_frame := a_timestamp

			second_counter := second_counter + time_since_last_frame
			if second_counter >= 1.0 then
				second_counter := second_counter - 1.0
				frame_display := frame_counter
				tick_display := tick_counter
				frame_counter := 0
				tick_counter := 0
				io.put_string("Frames: " + frame_display.out + " Ticks: " + tick_display.out + " Entities: " + entities.count.out + "     %R")
			end

			update_camera

			on_redraw(a_timestamp)

			game_update_mutex.unlock
		end

	on_stop
			-- Close the game_update_thread
		do
			io.put_string("%N")
			if attached network_engine as la_network_engine then
				la_network_engine.stop_connexion
			end
			if attached game_update_thread as la_game_update_thread then
				la_game_update_thread.stop_thread
				la_game_update_thread.join
			end
		end

	on_restart
			-- Reset the tick counter in order to prevent the game to continue playing when pausing
		do
			last_frame := 0
			if attached game_update_thread as la_game_update_thread then
				if la_game_update_thread.is_launchable then
					la_game_update_thread.launch
				end
			end
		ensure then
			Tick_Reset: last_frame = 0
		end

	on_redraw(a_timestamp: NATURAL_32)
			-- Redraw the screen
		do
			frame_counter := frame_counter + 1
			renderer.render(drawables)
		end

	on_key_press(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Pauses the game when pressing the Escape key
			-- Toggles debugging mode whem pressing F3
		do
			score := score + 1
			if attached {HUD_INFORMATION} hud_items[1] as la_hud_score then
				la_hud_score.update_value (score)
			end
			if not a_key_state.is_repeat then
				if a_key_state.is_escape then
					create {MENU_PAUSE} next_menu.make(context)
					continue_to_next
				elseif a_key_state.is_f3 then
					context.debugging := not context.debugging
				end
			end
		end

	update_camera
			-- Update `context.camera's position
		do
			context.camera.move_at_entity(current_player, context.window)
		end

feature -- Access

	renderer: RENDER_ENGINE
			-- Object rendering engine

	network_engine: detachable NETWORK_ENGINE
			-- The network engine for multiplayer score.

	hud_items: LIST[HUD_ITEM]
			-- List of hud items to draw.

invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
