note
	description : "SickBeat application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED
	TEXT_LIBRARY_SHARED
	SOUND_ENGINE_SHARED
	SOUND_FACTORY_SHARED

create
	make

--feature -- Initialization

--	game: GAME_ENGINE
			-- `game'
--		attribute check False then end end --| Remove line when `game' is initialized in creation procedure.

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_sound_test:SOUND
		do
			game_library.enable_video
			text_library.enable_text
--			create game.make
			sound_engine.do_nothing --usefull af
			game_library.clear_all_events
			text_library.quit_library
			game_library.quit_library
		end

end
