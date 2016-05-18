note
	description: "Class that manages sounds/musics for the game."
	author: "Émilio G!"
	date: "16-05-17"
	revision: "16w15a"
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
			create audio_sources_mutex.make
			set_master_volume(1)
		end

feature -- Access

	sound_on:BOOLEAN
		--boolean (doesnt work for now) that is true when sound is on.

	audio_sources_mutex: MUTEX
		-- The mutex to add and remove audio sources.

	master_volume: REAL_32
		-- The volume (in %) of every audio source.

	toggle_sound
		--toggle if sound plays or not
		do
			sound_on := not sound_on
		end

	create_audio_source
		--creates and adds an audio source in audio_library
		do
			audio_sources_mutex.lock
				audio_library.sources_add
			audio_sources_mutex.unlock
		end

	last_audio_source:AUDIO_SOURCE
		--returns the last audio source added by `Current'.create_audio_source
		do
			Result := audio_library.last_source_added
		end

	remove_source(a_source:AUDIO_SOURCE)
			--Removes `a_source' from the audio_library sources
		do
			audio_sources_mutex.lock
				audio_library.sources_prune (a_source)
			audio_sources_mutex.unlock
		end

	set_master_volume(a_new_volume: REAL_64)
		--sets the master volume to a_new_volume
		--side effect on audio_library sources
		require
			New_Volume_Valid: a_new_volume >= 0 and a_new_volume <= 1
		do
			master_volume := a_new_volume.truncated_to_real
			across audio_library.sources as la_source loop
				la_source.item.set_gain (a_new_volume.truncated_to_real)
			end
			print("%NNEW MASTER VOLUME: " + master_volume.out + "%N")
		end

	clear_ressources
			-- called at the end of the program to clear allocated ressources
		do
			audio_library.stop_thread
			audio_library.quit_library
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
