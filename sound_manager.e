note
	description: "Class that manages sounds/musics for the game."
	author: "Émilio G!"
	date: "16-02-29"
	revision: "16w08a"
	legal: "See notice at end of class."

class
	SOUND_MANAGER

inherit
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE}

	make
		-- Initialization for `Current'. Enables the audio_library.
		do
			sound_on := True
			audio_library.enable_sound
			audio_library.launch_in_thread
			audio_library.disable_print_on_error
		end

feature -- Access

	sound_on:BOOLEAN --boolean (doesnt work for now) that is true when sound is on.

	toggle_sound
		--toggle if sound plays or not
		do
			sound_on := not sound_on
		end

	create_audio_source
		--creates and adds an audio source in audio_library
		do
			audio_library.sources_add
		end

	last_audio_source:AUDIO_SOURCE
		--returns the last audio source added by `Current'.create_audio_source
		do
			Result := audio_library.last_source_added
		end

	set_master_volume(a_new_volume: REAL_32)
		--sets the master volume to a_new_volume
		--side effect on audio_library sources
		require
			New_Volume_Valid: a_new_volume >= 0 and a_new_volume <= 1
		do
			across audio_library.sources as la_source loop
				la_source.item.set_gain (a_new_volume)
			end
		end

	run
			--do `Current's job... nothing to see here for now.
		do

		end

	clear_ressources
			--called at the end of the program to clear allocated ressources
		do
			audio_library.stop_thread
			audio_library.quit_library
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
