note
	description: "{MENU} implementing game specific mechanics and rendering. This needs to be a {MENU} so the menus can naviguate to it."
	author: "Guillaume Jean and �milio G!"
	date: "2016-05-20"
	revision: "16w16a"
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
			on_stop,
			on_cleanup
		end
	GAME_CORE
	MATH_UTILITY
	SOUND_MANAGER_SHARED
	SOUND_FACTORY_SHARED

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
			create current_map.make([3840.0, 2160.0], a_context.image_factory.get_enemy_texture_tuple, a_context.image_factory.get_arcs_texture_tuple)
			current_map.start_spawning
			create {ARRAYED_LIST[HUD_ITEM]}hud_items.make(2)
			score := 0
			hud_items.extend (create {HUD_SCORE}.make(score, 20, 20, "localhost", context))
			hud_items.extend (create {HUD_SCORE}.make(-1, 20, 40, "", context))
			create renderer.make(background, hud_items, context)
			create physics.make
			create current_player.make([context.window.width / 2, context.window.height / 2], controller, current_map, context)
			hud_items.extend(create {HUD_HEALTH}.make(current_player.health_max, current_player.health, 20, 60))
			create {LINKED_LIST[ENTITY]} entities.make
			create {ARRAYED_LIST[DRAWABLE]} drawables.make(0)
			entities.extend(current_player)
			drawables.extend(current_player)
			physics.physic_objects.extend(current_player)
			time_since_last_frame := 0
			last_frame := 0
			create game_update_mutex.make
			create {LINKED_LIST[ENEMY]} ennemies.make
			audio_source_hit := sound_manager.get_audio_source
			if attached audio_source_hit as la_audio_source then
				la_audio_source.queue_sound (sound_factory.create_sound_hit_player)
			end
			create game_update_thread.make(game_update_mutex, Current)
			controller.mouse_button_update_actions.extend(agent current_player.on_click)
			controller.mouse_wheel_actions.extend(agent current_player.on_mouse_wheel)
			controller.number_actions.extend(agent current_player.set_color_index)
			current_player.collision_actions.extend(agent (a_physic_object: PHYSIC_OBJECT)
					do
						do_player_collision(a_physic_object)
					end
				)
			current_player.launch_wave_event.extend(agent (a_wave:WAVE)
					do
						add_entity_to_world(a_wave)
					end
				)
			current_player.death_actions.extend(agent (a_entity: ENTITY)
					do
						create {MENU_DEATH} next_menu.make_with_score(score, attached network_engine, context)
						return_to_main
					end
				)
			current_map.spawn_enemies_actions.extend(agent (a_enemy: ENEMY)
					do
						add_enemy_to_world(a_enemy)
						a_enemy.collision_actions.extend(agent a_enemy.do_collision)
						a_enemy.death_actions.extend(agent (a_entity: ENTITY) do add_score(10) end)
					end
				)
		end

	make_multiplayer(a_context: CONTEXT; a_network_engine: NETWORK_ENGINE)
			-- Initialize all the attributes for a multiplayer game (sets `network_engine' to `a_network_engine') where you join a game.
		do
			make(a_context)
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
		end

feature {NONE} -- Implementation

	game_update_mutex: MUTEX
			-- Mutex used to lock the rendered objects

	game_update_thread: GAME_UPDATE_THREAD
			-- Thread used for the game updates

	audio_source_hit: detachable AUDIO_SOURCE
			-- Audio source for when `Current' is hit by something

	set_events
			-- Sets the event handlers for `Current'
		do
			game_library.quit_signal_actions.extend(agent on_quit_signal)
			game_library.iteration_actions.extend(agent on_iteration)
			context.window.expose_actions.extend(agent on_redraw)
			context.window.size_change_actions.extend(agent on_size_change)
			context.window.mouse_button_pressed_actions.extend(agent on_pressed)
			context.window.mouse_button_released_actions.extend(agent on_released)
			context.window.mouse_motion_actions.extend(agent on_mouse_motion)
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
--				io.put_string("Frames: " + frame_display.out + " Ticks: " + tick_display.out + " Entities: " + entities.count.out + " HP: " + current_player.health.rounded.out + "     %R")
			end

			if attached {HUD_HEALTH} hud_items.last as la_hud_health then
				la_hud_health.update_value(current_player.health)
			end
			update_camera
			on_redraw(a_timestamp)

			across drawables as la_drawables loop
				if attached {WAVE} la_drawables.item as la_wave then
					if attached la_wave.audio_source as la_audio_source then
						la_audio_source.set_position (
								((la_wave.as_box.box_center.x - current_player.x_real) / 550000).truncated_to_real,
								((la_wave.as_box.box_center.y - current_player.y_real) / 2500).truncated_to_real, 0)
					end
				end
			end

			game_update_mutex.unlock
		end

	on_stop
			-- Close the game_update_thread
		do
--			io.put_string("%N")
			if attached network_engine as la_network_engine then
				la_network_engine.stop_connexion
			end
			game_update_thread.pause_thread
		end

	on_restart
			-- Reset the tick counter in order to prevent the game to continue playing when pausing
		do
			last_frame := 0
			if game_update_thread.is_launchable then
				game_update_thread.launch
			end
			game_update_thread.resume_thread
		ensure then
			Tick_Reset: last_frame = 0
		end

	on_cleanup
			-- Destroy `game_update_thread'
		do
			game_update_thread.resume_thread
			game_update_thread.stop_thread
			game_update_thread.join
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

	do_player_collision(a_physic_object: PHYSIC_OBJECT)
			-- Determines what to do with `current_player's collision with `a_physic_object'
		local
			l_damage: REAL_64
		do
			if attached {WAVE} a_physic_object as la_wave then
				if la_wave.source /= current_player then
					l_damage := la_wave.energy / 1000
					if la_wave.color.to_rgb_hex_string ~ current_player.current_color.to_rgb_hex_string then
						l_damage := l_damage * 0.0
					end
					current_player.deal_damage(l_damage)
					if attached audio_source_hit as la_audio_source and l_damage > 0 then
						if not la_audio_source.is_playing then
							la_audio_source.set_gain ((l_damage.truncated_to_real / 4).min(1) * sound_manager.master_volume)
							la_audio_source.play
							la_audio_source.queue_sound (sound_factory.create_sound_hit_player)
						end
					end
					la_wave.deal_damage(l_damage * 200)
				end
			elseif attached {ENEMY} a_physic_object as la_enemy then
				la_enemy.deal_damage(la_enemy.health_max)
				current_player.deal_damage(current_player.health_max * 0.25)
			end
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
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
