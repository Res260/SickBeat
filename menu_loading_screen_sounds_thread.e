note
	description: "Threaded class to load sounds"
	author: "�milio G!"
	date: "2016-04-25"
	revision: "16w12a"
	legal: "See notice at end of class."

class
	MENU_LOADING_SCREEN_SOUNDS_THREAD

inherit
	THREAD
		rename
			make as make_thread
		redefine
			execute
		end
	SOUND_FACTORY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Initializes `Current'
		do
			create stop_actions
			make_thread
		end

feature {NONE} -- Implementation

feature -- Implementation

	stop_actions: ACTION_SEQUENCE[TUPLE]
		--procedure to call to start the game.

	execute
			-- Executed when the thread is launched
		local

		do
			io.put_string ("Thread son launch�")
			sound_factory.populate_sounds_list
			io.put_string ("Sons faits")
			stop_actions.call
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
