note
	description: "The loading screen while textures and sounds are loading."
	author: "�milio G!"
	date: "2016-04-25"
	revision: "16w12a"

class
	MENU_LOADING_SCREEN
inherit
	MENU
		redefine
			make,
			on_start,
			on_stop
		end
create
	make,
	make_as_main

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialization of `Current'
		do
			Precursor(a_context)
			set_title("SickBeat - Waiting for miracles")
			create thread_sounds.make
			create thread_images.make(context.image_factory)
			thread_sounds.stop_actions.extend (agent stop_menu_from_thread)
			thread_images.stop_actions.extend (agent stop_menu_from_thread)
			add_button("G�n�ration des sons en cours", agent useless_action)
			add_button("G�n�ration des images en cours", agent useless_action)
		end

feature --Implementation

	thread_sounds:MENU_LOADING_SCREEN_SOUNDS_THREAD
		--Thread that generates sounds for the game.

	thread_images:MENU_LOADING_SCREEN_IMAGES_THREAD
		--Thread that generates textures for the game.

	on_start
		--Launches threads
		do
			Precursor
			play_menu_sound_click
			thread_sounds.launch
			thread_images.launch
			io.put_string("Useless button clicked! Bravo champion%N")
		end

	on_stop
			--Join threads and enters the game.
		do
			Precursor
			thread_sounds.join
			buttons[1].set_text ("G�n�ration des sons termin�e")
			thread_images.join
			buttons[2].set_text ("G�n�ration des images termin�e")
			create {GAME_ENGINE} next_menu.make(context)
		end

	stop_menu_from_thread
			--Might change
		do
			return_menu
		end

	useless_action(a_string: READABLE_STRING_GENERAL)
			-- Action played when the user clicks the useless button
		do
			play_menu_sound_click
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
