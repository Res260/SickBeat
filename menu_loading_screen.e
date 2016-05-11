note
	description: "The loading screen while textures and sounds are loading."
	author: "Émilio G!"
	date: "2016-04-25"
	revision: "16w13a"

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
	make_multiplayer_host,
	make_as_main

feature {NONE} -- Initialization

	make(a_context: CONTEXT)
			-- Initialization of `Current'
		do
			Precursor(a_context)
			is_host := False
			set_title("SickBeat - Waiting for miracles")
			create thread_sounds.make
			create thread_images.make(context.image_factory)
			thread_sounds.stop_actions.extend (agent stop_menu_from_thread)
			thread_images.stop_actions.extend (agent stop_menu_from_thread)
			add_button("Génération des sons en cours", agent useless_action)
			add_button("Génération des images en cours", agent useless_action)
		end

	make_multiplayer_host(a_context: CONTEXT; a_network_engine: NETWORK_ENGINE)
		do
			make(a_context)
			network_engine := a_network_engine
			is_host := True
		end

feature --Implementation

	is_host:BOOLEAN
		--True if the client hosts a server.

	network_engine: detachable NETWORK_ENGINE
		--The game's network engine.

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
			buttons[1].set_text ("Génération des sons terminée")
			thread_images.join
			buttons[2].set_text ("Génération des images terminée")
			if(attached network_engine as la_network_engine) then
				if(is_host) then
					create {GAME_ENGINE} next_menu.make_multiplayer_host(context, la_network_engine, create {GAME_NETWORK}.make(context, la_network_engine))
				else
					create {GAME_ENGINE} next_menu.make_multiplayer(context, la_network_engine)
				end
			else
				create {GAME_ENGINE} next_menu.make(context)
			end
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
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
