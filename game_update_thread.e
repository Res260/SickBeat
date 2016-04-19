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

	make(a_mutex: MUTEX)
			-- Initializes `Current'
		do
			make_thread
			must_stop := False
			game_update_mutex := a_mutex
		end

feature {NONE} -- Implementation

	must_stop: BOOLEAN
			-- Whether or not `Current' should stop running

	game_update_mutex: MUTEX
			-- Mutex used to share ressources

feature -- Implementation

	execute
			-- Executed when the thread is launched
		do
			from
			until
				must_stop
			loop
				game_update_mutex.lock
				
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
