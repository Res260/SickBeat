note
	description: "Threaded class to load textures"
	author: "Émilio G!"
	date: "2016-04-25"
	revision: "16w12a"
	legal: "See notice at end of class."

class
	MENU_LOADING_SCREEN_IMAGES_THREAD

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

	make(a_image_factory:IMAGE_FACTORY)
			-- Initializes `Current'
		do
			create stop_actions
			image_factory := a_image_factory
			make_thread
		end

feature -- Implementation

	stop_actions: ACTION_SEQUENCE[TUPLE]
		--procedure to call to start the game.

	image_factory:IMAGE_FACTORY
		-- The game's image factory

	execute
			-- Executed when the thread is launched
		local

		do
			io.put_string ("Thread textures launché")
			image_factory.make_all_textures
			io.put_string ("Textures faites")
			stop_actions.call
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
