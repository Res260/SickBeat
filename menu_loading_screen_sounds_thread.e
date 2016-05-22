note
	description: "Threaded class to load sounds"
	author: "Émilio G!"
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
			completed := False
			make_thread
		end

feature {NONE} -- Implementation

feature -- Implementation

	completed: BOOLEAN
			-- Whether or not `Current' has completed it's task

	stop_actions: ACTION_SEQUENCE[TUPLE]
			-- Called when `Current' has completed it's task

	execute
			-- Executed when the thread is launched
		do
			sound_factory.populate_sounds_list
			completed := True
			stop_actions.call
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
