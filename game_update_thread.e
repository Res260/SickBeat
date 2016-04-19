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

create
	make

feature {NONE} -- Initialization

	make(a_mutex: MUTEX; a_game_core: GAME_CORE; a_game_library: GAME_LIBRARY_CONTROLLER)
			-- Initializes `Current'
		do
			make_thread
			must_stop := False
			game_update_mutex := a_mutex
			game_core := a_game_core
			game_library := a_game_library
		end

feature {NONE} -- Implementation

	must_stop: BOOLEAN
			-- Whether or not `Current' should stop running

	game_update_mutex: MUTEX
			-- Mutex used to share ressources

	game_core: GAME_CORE
			-- Where the ressources are

	game_library: GAME_LIBRARY_CONTROLLER
			-- The game_library used by the main thread

	tick_display: INTEGER
			-- Number of ticks in the past second

	tick_counter: INTEGER
			-- Number of ticks this second

	second_counter: REAL_64
			-- Time since last tick

	last_tick: NATURAL_32
			-- Time of last update in milliseconds

	time_since_last_tick: REAL_64
			-- Time since last update in seconds

feature -- Implementation

	execute
			-- Executed when the thread is launched
		do
			from
			until
				must_stop
			loop
				if last_tick <= 0 then
					time_since_last_tick := 0
				else
					time_since_last_tick := (game_library.time_since_create - last_tick) / 1000
				end
				last_tick := game_library.time_since_create

				second_counter := second_counter + time_since_last_tick
				if second_counter >= 1.0 then
					second_counter := second_counter - 1.0
					tick_display := tick_counter
					tick_counter := 0
					io.put_string("Ticks: " + tick_display.out + "%N")
				end

				game_update_mutex.lock

				game_core.update_player_acceleration
				game_core.update_camera
				game_core.update_everything
				game_core.physics.check_all

				game_update_mutex.unlock
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
