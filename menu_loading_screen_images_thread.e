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
			completed := False
			make_thread
		end

feature -- Implementation

	completed: BOOLEAN
			-- Whether or not `Current' has completed it's task

	stop_actions: ACTION_SEQUENCE[TUPLE]
			-- Called when `Current's execution is completed

	image_factory:IMAGE_FACTORY
			-- The game's image factory

	execute
			-- Executed when the thread is launched
		do
			image_factory.make_all_textures
			completed := True
			stop_actions.call
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
