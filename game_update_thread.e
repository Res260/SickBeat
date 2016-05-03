note
	description: "Threaded loop part of the {GAME_ENGINE}"
	author: "Guillaume Jean"
	date: "19 April 2016"
	revision: "16w11a"
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
	make

feature {NONE} -- Initialization

	make(a_mutex: MUTEX; a_game_core: GAME_CORE)
			-- Initializes `Current'
		do
			make_thread
			must_stop := False
			game_update_mutex := a_mutex
			game_core := a_game_core
		end

feature {NONE} -- Implementation

	must_stop: BOOLEAN
			-- Whether or not `Current' should stop running

	game_update_mutex: MUTEX
			-- Mutex used to share ressources

	game_core: GAME_CORE
			-- Where the ressources are

	last_tick: REAL_64
			-- Time of last update in milliseconds

	ticks_per_seconds: NATURAL_32 = 120
			-- Ticks executed per second

	milliseconds_per_tick: REAL_64
			-- Fraction of seconds per tick
		once("PROCESS")
			Result := 1000 / ticks_per_seconds
		end

feature -- Implementation

	execute
			-- Executed when the thread is launched
		local
			l_previous_tick: REAL_64
			l_update_time_difference: REAL_64
			l_time_difference: REAL_64
			l_execution_time: REAL_64
		do
			from
			until
				must_stop
			loop
				game_update_mutex.lock

				l_previous_tick := last_tick
				last_tick := game_library.time_since_create.to_real_64
				l_update_time_difference := (last_tick - l_previous_tick) / 1000

				game_core.increment_ticks

				game_core.update_camera
				game_core.update_everything(l_update_time_difference)
				game_core.physics.check_all

				game_update_mutex.unlock

				l_execution_time := game_library.time_since_create.to_real_64 - last_tick
				l_time_difference := milliseconds_per_tick - l_execution_time - 0.5
				if l_time_difference > 0 then
					sleep((l_time_difference * 1000000).truncated_to_integer_64) -- Nanosecondes
				end
			end
		end

feature -- Access

	stop_thread
			-- Stop the thread
		do
			must_stop := True
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
