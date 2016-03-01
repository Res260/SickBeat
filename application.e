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
			-- TODO: Add resource factories
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
			-- TODO: Create resource factories
			run_main_menu(l_window)
		end

	run_main_menu(a_window: GAME_WINDOW_RENDERED)
		local
			l_main_menu: MENU_MAIN
			l_continue_menu: BOOLEAN
		do
			create l_main_menu.make (a_window)
			if not l_main_menu.has_error then
				from
					l_continue_menu := True
				until
					l_continue_menu = False
				loop
					l_main_menu.run
					if l_main_menu.is_play_clicked then
						io.put_string("Play clicked!%N")
					elseif l_main_menu.is_option_clicked then
						io.put_string("Options clicked!%N")
					elseif l_main_menu.is_exit_clicked then
						io.put_string("Exit clicked!%N")
						l_continue_menu := False
					end
				end
			else
				io.error.put_string ("An error occured while loading the main menu.%N")
			end
		end

end
