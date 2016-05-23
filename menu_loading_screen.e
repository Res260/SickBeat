note
	description: "The loading screen while textures and sounds are loading."
	author: "Guillaume Jean and Émilio G!"
	date: "2016-05-16"
	revision: "16w15a"

class
	MENU_LOADING_SCREEN
inherit
	MENU
		redefine
			make,
			on_start,
			on_stop,
			on_iteration
		end
create
	make,
	make_multiplayer,
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
			add_button("Generating sounds...", agent useless_action)
			add_button("Generating images...", agent useless_action)
		end

	make_multiplayer(a_context: CONTEXT; a_host: STRING)
			--Initialization for `Current'. Connects to `a_host' for the multiplayer.
		do
			make(a_context)
			create network_engine.make
			if attached network_engine as la_network_engine then
				la_network_engine.connect_client (a_host)
				if not attached la_network_engine.client_socket then
					return_menu
				end
			end
		end

	make_multiplayer_host(a_context: CONTEXT; a_network_engine: NETWORK_ENGINE)
			--Initialization for `Current'. Listen for incoming connections for the multiplayer.
		do
			make(a_context)
			network_engine := a_network_engine
			is_host := True
		end

feature -- Implementation

	is_host:BOOLEAN
			--True if the client hosts a server.

	network_engine: detachable NETWORK_ENGINE
			--The game's network engine.

	thread_sounds:MENU_LOADING_SCREEN_SOUNDS_THREAD
			--Thread that generates sounds for the game.

	thread_images:MENU_LOADING_SCREEN_IMAGES_THREAD
			--Thread that generates textures for the game.

	sounds_text_updated: BOOLEAN
			-- Whether or not `thread_sounds' was completed last time `Current' checked

	images_text_updated: BOOLEAN
			-- Whether or not `thread_images' was completed last time `Current' checked

	on_iteration(a_timestamp: NATURAL_32)
			-- Updates the loading texts if a thread is completed
		do
			Precursor(a_timestamp)
			if thread_sounds.completed and not sounds_text_updated then
				buttons[1].set_text("Done generating sounds")
				update_buttons_dimension
				on_redraw(a_timestamp)
				sounds_text_updated := True
			end
			if thread_images.completed and not images_text_updated then
				buttons[2].set_text("Done generating images")
				update_buttons_dimension
				on_redraw(a_timestamp)
				images_text_updated := True
			end
		end

	on_start
			-- Launches threads
		do
			Precursor
			play_menu_sound_click
			thread_sounds.launch
			thread_images.launch
		end

	on_stop
			-- Joins threads and enters the game.
		do
			Precursor
			thread_sounds.join
			thread_images.join
			if(attached network_engine as la_network_engine) then
				if(is_host) then
					create {GAME_ENGINE} next_menu.make_multiplayer_host(context, la_network_engine)
				else
					create {GAME_ENGINE} next_menu.make_multiplayer(context, la_network_engine)
				end
			else
				create {GAME_ENGINE} next_menu.make(context)
			end
		end

	stop_menu_from_thread
			-- Might change
		do
			if thread_sounds.completed and thread_images.completed then
				return_menu
			end
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
