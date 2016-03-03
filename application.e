note
	description: "Sickbeat root application class."
	author: "Guillaume Jean"
	date: "Tue, 23 Fev 2016 09:00:00"
	revision: "0.1"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED
	SOUND_ENGINE_SHARED
	SOUND_FACTORY_SHARED

create
	make

feature -- Initialization

	game: GAME_ENGINE
			-- `game'
		attribute check False then end end --| Remove line when `game' is initialized in creation procedure.

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			game_library.enable_video
			text_library.enable_text
			run_game
			game_library.clear_all_events
			text_library.quit_library
			game_library.quit_library
		end

	run_game
			-- Initialize game stuff and start menus
		local
			l_ressource_factory: RESSOURCE_FACTORY
			l_window_builder: GAME_WINDOW_RENDERED_BUILDER
			l_window: GAME_WINDOW_RENDERED
		do
			l_window_builder.is_resizable := True
			l_window_builder.is_fake_fullscreen := True
			l_window_builder.is_fullscreen := False
			l_window_builder.must_renderer_be_hardware_accelerated := True
			l_window_builder.must_renderer_be_software_rendering := False
			l_window_builder.must_renderer_support_texture_target := True
			l_window_builder.must_renderer_synchronize_update := True
			l_window_builder.title := "SickBeat"
			l_window := l_window_builder.generate_window
			create l_ressource_factory.make(l_window.renderer, l_window.pixel_format)
			if l_ressource_factory.has_error then
				io.error.put_string("An error occured while loading ressources.%N")
			else
				run_main_menu(l_window, l_ressource_factory)
			end
		end

	run_main_menu(a_window: GAME_WINDOW_RENDERED; a_ressource_factory: RESSOURCE_FACTORY)
			-- Show the {MENU_MAIN} and manage it's output.
			-- Show the menu in `a_window' using ressources from `a_ressource_factory'.
		local
			l_main_menu: MENU_MAIN
			l_continue_menu: BOOLEAN

			l_audio_source: AUDIO_SOURCE
			l_audio_source_2: AUDIO_SOURCE
			l_sound: SOUND
			l_sound_2: AUDIO_SOUND_FILE
		do
<<<<<<< HEAD
			create l_main_menu.make(a_window, a_ressource_factory)
=======
			l_audio_source:= sound_engine.create_audio_source
			l_sound:= sound_factory.create_sound_menu_click

			l_audio_source_2:= sound_engine.create_audio_source
			create l_sound_2.make (".\ressources\audio\menu.ogg")
			l_sound_2.open
			l_audio_source_2.queue_sound (l_sound_2)
			l_audio_source_2.set_gain (0.1)
			l_audio_source_2.play

			create l_main_menu.make (a_window)
>>>>>>> refs/remotes/origin/master
			if not l_main_menu.has_error then
				from
					l_continue_menu := True
				until
					l_continue_menu = False
				loop
					l_main_menu.run
					if l_main_menu.is_play_clicked then
						l_audio_source.queue_sound (l_sound)
						l_audio_source.play
					elseif l_main_menu.is_option_clicked then
						l_audio_source.queue_sound (l_sound)
						l_audio_source.play
					elseif l_main_menu.is_exit_clicked then
						l_audio_source.queue_sound (l_sound)
						l_audio_source.play
						l_continue_menu := False
					end
				end
			else
				io.error.put_string ("An error occured while loading the main menu.%N")
			end
		end

end
