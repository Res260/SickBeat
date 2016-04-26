note
	description: "Threaded class to load textures and sounds"
	author: "Émilio G!"
	date: "2016-04-25"
	revision: "16w12a"
	legal: "See notice at end of class."

class
	MENU_LOADING_SCREEN_THREAD

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
			make_thread
		end

feature {NONE} -- Implementation

feature -- Implementation

	execute
			-- Executed when the thread is launched
		local

		do
			io.put_string ("Thread launché")
			sound_factory.populate_sounds_list
			io.put_string ("Sons faits")
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
