note
	description: "Summary description for {GAME_NETWORK}."
	author: "Émilio Gonzalez"
	date: "2016-05-09"
	revision: "16w14b"

class
	GAME_NETWORK

inherit
	GAME_CORE
	GAME_LIBRARY_SHARED
	THREAD
		rename
			make as make_thread
		end

create
	make

feature
	make(a_context: CONTEXT; a_network_engine: NETWORK_ENGINE)
		local
			l_background: BACKGROUND
			l_mouse: MOUSE
		do
			context := a_context
			network_engine := a_network_engine
			create controllers_mutex.make
			create entities_mutex.make
			create{LINKED_LIST[CONTROLLER]} controllers.make
			create physics.make
			create l_mouse.make(0, 0)
			create {LINKED_LIST[ENTITY]} entities.make
			create {ARRAYED_LIST[DRAWABLE]} drawables.make(0)
			create l_background.make_movable(a_context.ressource_factory.game_background, [3840, 2160], a_context)
			create current_map.make(l_background, a_context)
			time_since_last_frame := 0
			last_frame := 0
--			controller.mouse_update_actions.extend(agent current_player.on_click)
--			controller.mouse_wheel_actions.extend(agent current_player.on_mouse_wheel)
--			controller.number_actions.extend(agent current_player.set_color_index)
--			current_player.collision_actions.extend(agent (a_physic_object: PHYSIC_OBJECT)
--														do
--															io.put_string("BOOM!")
--														end
--												   )
--			current_player.launch_wave_event.extend(agent (a_wave:WAVE) do add_entity_to_world(a_wave) end )
			make_thread
		end

	context: CONTEXT

	network_engine: NETWORK_ENGINE

	controllers: LIST[CONTROLLER]
			--List of player's controllers.

	last_tick: REAL_64
			-- Time of last update in milliseconds

	ticks_per_seconds: NATURAL_32 = 120
			-- Ticks executed per second

	milliseconds_per_tick: REAL_64
			-- Fraction of seconds per tick
		once("PROCESS")
			Result := 1000 / ticks_per_seconds
		end

	controllers_mutex: MUTEX
		-- The mutex for the controllers.

	entities_mutex: MUTEX
		-- The mutex for the entities.

	add_player(a_ip: STRING)
		local
			l_temp_player: PLAYER
		do
			controllers_mutex.lock
			if across controllers as la_controller all not la_controller.item.source.is_equal(a_ip) end then
--			if(controllers.for_all (agent (controller: CONTROLLER):BOOLEAN
--										do
--											Result := not controller.source.is_equal(a_ip))
--										end) then
				create l_temp_player.make (create{MOUSE}.make ([0,0]), a_ip, context)
				entities_mutex.lock
					entities.extend (l_temp_player)
					controllers.extend (l_temp_player.controller)
					print("%NJOUEUR ADDED: " + a_ip + "%N")
				entities_mutex.unlock
			end
			controllers_mutex.unlock
		end

	execute
		local
			l_previous_tick: REAL_64
			l_update_time_difference: REAL_64
			l_time_difference: REAL_64
			l_execution_time: REAL_64
		do
			from
			until
				false
			loop

				l_previous_tick := last_tick
				last_tick := game_library.time_since_create.to_real_64
				l_update_time_difference := (last_tick - l_previous_tick) / 1000

				increment_ticks

				entities_mutex.lock
				controllers_mutex.lock
					update_everything(l_update_time_difference)
					physics.check_all
				controllers_mutex.unlock
				entities_mutex.unlock

				l_execution_time := game_library.time_since_create.to_real_64 - last_tick
				l_time_difference := milliseconds_per_tick - l_execution_time - 0.5
				if l_time_difference > 0 then
					sleep((l_time_difference * 1000000).truncated_to_integer_64)
				end
			end
		end

end
