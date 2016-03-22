note
	description: "Sickbeat root application class."
	author: "Guillaume Jean"
	date: "21 March 2016"
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
			create l_ressource_factory.make(l_window.renderer, l_window.pixel_format)
			if l_ressource_factory.has_error then
				io.error.put_string("An error occured while loading ressources.%N")
			else
				create l_context.make(l_window, l_ressource_factory)
				create {MENU_MAIN} l_main_menu.make(l_context)
				l_main_menu.start
			end
		end
end
