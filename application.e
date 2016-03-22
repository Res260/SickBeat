note
	description: "Sickbeat root application class."
	author: "Guillaume Jean"
	date: "21 Mar 2016"
	revision: "16w08a"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			game_library.enable_video
			text_library.enable_text
			start_game
			game_library.clear_all_events
			text_library.quit_library
			game_library.quit_library
		end

	start_game
			-- Initialize game stuff and start menus
		require
			Video_Is_Enabled: game_library.is_video_enable
			Text_Is_Enabled: text_library.is_text_enable
		local
			l_ressource_factory: RESSOURCE_FACTORY
			l_window_builder: GAME_WINDOW_RENDERED_BUILDER
			l_window: GAME_WINDOW_RENDERED
			l_context: CONTEXT
			l_main_menu: MENU
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
<<<<<<< HEAD
			-- TODO: Create resource factories
			run_main_menu(l_window)
		end

	run_main_menu(a_window: GAME_WINDOW_RENDERED)
		local
			l_main_menu: MENU_MAIN
			l_continue_menu: BOOLEAN

			l_audio_source: AUDIO_SOURCE
--			l_audio_source_2: AUDIO_SOURCE
			l_sound: SOUND
--			l_sound_2: AUDIO_SOUND_FILE
		do
			sound_manager.create_audio_source
			l_audio_source:= sound_manager.last_audio_source
			l_sound:= sound_factory.create_sound_menu_click

--			l_audio_source_2:= sound_engine.create_audio_source
--			create l_sound_2.make (".\ressources\audio\menu.ogg")
--			l_sound_2.open
--			l_audio_source_2.queue_sound (l_sound_2)
--			l_audio_source_2.set_gain (0.1)
--			l_audio_source_2.play

			create l_main_menu.make (a_window)
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
=======
			create l_ressource_factory.make(l_window.renderer, l_window.pixel_format)
			if l_ressource_factory.has_error then
				io.error.put_string("An error occured while loading ressources.%N")
>>>>>>> master
			else
				create l_context.make(l_window, l_ressource_factory)
				create {MENU_MAIN} l_main_menu.make(l_context)
				l_main_menu.start
			end
		end
end
