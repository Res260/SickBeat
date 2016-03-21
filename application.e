note
	description: "Sickbeat root application class."
	author: "Guillaume Jean"
	date: "Tue, 23 Fev 2016 09:00"
	revision: "16w06a"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED
	SOUND_ENGINE_SHARED
	SOUND_FACTORY_SHARED

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
			create l_ressource_factory.make(l_window.renderer, l_window.pixel_format)
			if l_ressource_factory.has_error then
				io.error.put_string("An error occured while loading ressources.%N")
			else
				create l_context.make(l_window, l_ressource_factory)
				create {MENU_MAIN} l_main_menu.make(l_context)
				l_main_menu.start
			end
		end

--	run_main_menu(a_context: CONTEXT)
--			-- Show the {MENU_MAIN} and manage it's output.
--			-- Show the menu in `a_window' using ressources from `a_ressource_factory'.
--		require
--			Window_Has_No_Error: not a_context.window.has_error
--			Ressource_Factory_Has_No_Error: not a_context.ressource_factory.has_error
--		local
--			l_main_menu: MENU_MAIN
--			l_audio_source: AUDIO_SOURCE
--			l_audio_source_2: AUDIO_SOURCE
--			l_sound: SOUND
--			l_sound_2: AUDIO_SOUND_FILE
--		do
--			l_audio_source:= sound_engine.create_audio_source
--			l_sound:= sound_factory.create_sound_menu_click

--			l_audio_source_2:= sound_engine.create_audio_source
--			create l_sound_2.make (".\ressources\audio\menu.ogg")
--			l_sound_2.open
--			l_audio_source_2.queue_sound (l_sound_2)
--			l_audio_source_2.set_gain (0.1)
--			l_audio_source_2.play
--		ensure
--			Ressource_Factory_No_Error: not a_context.ressource_factory.has_error
--		end
end
