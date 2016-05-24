note
	description: "Threaded loop part of the {GAME_ENGINE}"
	author: "Guillaume Jean and Émilio G!"
	date: "2016-05-14"
	revision: "16w15a"
	legal: "See notice at end of class."

class
	GAME_UPDATE_THREAD

inherit
	THREAD
		rename
			make as make_thread
		redefine
			execute
		end
	GAME_LIBRARY_SHARED

create
	make,
	make_multiplayer

feature {NONE} -- Initialization

	make(a_mutex: MUTEX; a_game_core: GAME_ENGINE)
			-- Initializes `Current' by setting `game_core' with `a_game_core' and `game_update_mutex' with `a_mutex'
		do
			make_thread
			must_stop := False
			must_run := True
			game_update_mutex := a_mutex
			game_core := a_game_core
		end

	make_multiplayer(a_mutex: MUTEX; a_game_core: GAME_ENGINE; a_network_engine: NETWORK_ENGINE)
			-- Initializes `Current' with `a_network_engine' for the multiplayer
		do
			make(a_mutex, a_game_core)
			network_engine := a_network_engine
			is_multiplayer := True
		end

feature {NONE} -- Implementation

	network_engine: detachable NETWORK_ENGINE
			-- The application's network engine.

	must_stop: BOOLEAN
			-- Whether or not `Current' should stop running

	must_run: BOOLEAN
			-- Whether or not `Current' should yield it's execution until it is resumed

	game_update_mutex: MUTEX
			-- Mutex used to share ressources

	game_core: GAME_CORE
			-- Where the ressources are

	last_tick: REAL_64
			-- Time of last update in milliseconds

	ticks_per_seconds: NATURAL_32 = 90
			-- Ticks executed per second

	milliseconds_per_tick: REAL_64
			-- Fraction of seconds per tick
		once("PROCESS")
			Result := 1000 / ticks_per_seconds
		end

feature -- Implementation

	execute
			-- Executed when the thread is launched
		do
			if is_multiplayer then
				execute_multiplayer
			else
				execute_single_player
			end
		end

	execute_single_player
			-- Method executed for every tick of a single player game
		do
			from
			until
				must_stop
			loop
				from
				until
					must_run
				loop
					yield
				end
				on_tick_singleplayer
			end
		end

	on_tick_singleplayer
			-- The actual action executed for any game
		local
			l_previous_tick: REAL_64
			l_update_time_difference: REAL_64
			l_time_difference: REAL_64
			l_execution_time: REAL_64
		do
			game_update_mutex.lock

			l_previous_tick := last_tick
			last_tick := game_library.time_since_create.to_real_64
			l_update_time_difference := (last_tick - l_previous_tick) / 1000

			game_core.increment_ticks

			game_core.update_everything(l_update_time_difference)
			game_core.physics.check_all
			game_core.clear_dead_entities

			game_update_mutex.unlock

			l_execution_time := game_library.time_since_create.to_real_64 - last_tick
			l_time_difference := milliseconds_per_tick - l_execution_time - 0.5
			if l_time_difference > 0 then
				sleep((l_time_difference * 1000000).truncated_to_integer_64)
			end
		end

	execute_multiplayer
			-- executed for a multiplayer game
		do
			if attached network_engine as la_network_engine then
				from
				until
					must_stop
				loop
					from
					until
						must_run
					loop
						yield
					end
					on_tick_singleplayer
					on_tick_multiplayer(la_network_engine)
				end
			end
		end

	on_tick_multiplayer(a_network_engine: NETWORK_ENGINE)
			-- If a multiplayer game requires special treatement, it goes here
		do
		end

feature -- Access

	is_multiplayer: BOOLEAN
			-- True if updating a multiplayer game.

	stop_thread
			-- Stop the thread
		do
			must_stop := True
		end

	pause_thread
			-- Pause the thread
		do
			must_run := False
		end

	resume_thread
			-- Resume the thread
		do
			must_run := True
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
