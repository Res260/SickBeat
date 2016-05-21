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
		local
			i: INTEGER
		do
			sound_on := True
			audio_library.enable_sound
			audio_library.launch_in_thread
			audio_library.disable_print_on_error
			audio_library.listener.initialize
			audio_library.listener.set_position (0, 0, 0)
			audio_library.listener.set_orientation (0, 1, 0, 0, 0, 1)
			audio_library.listener.set_velocity (0, 0, 0)
			create {LINKED_QUEUE[AUDIO_SOURCE]}sources_queue.make
			create audio_sources_mutex.make
			from
				i := 1
			until
				i > max_audio_sources
			loop
				create_audio_source
				i := i + 1
			end
			set_master_volume(1)
		end

	create_audio_source
		--creates and adds an audio source in audio_library
		do
			audio_sources_mutex.lock
				audio_library.sources_add
				sources_queue.put (audio_library.last_source_added)
			audio_sources_mutex.unlock
		end

feature -- Access

	sources_queue: QUEUE[AUDIO_SOURCE]
		-- Audio source pool.

	max_audio_sources: NATURAL_16 = 32
		-- Max number of allowed audio sources.

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

	can_get_audio_source: BOOLEAN
		--returns true if you can retrieve an audio_source
		do
			Result := False
			if not sources_queue.is_empty then
				Result := True
			end
		end

	get_audio_source:detachable AUDIO_SOURCE
		--returns an audio source in sources_queue
		do
			audio_sources_mutex.lock
				if can_get_audio_source then
					Result := sources_queue.item
					sources_queue.remove
				else
					Result := Void
				end
			audio_sources_mutex.unlock
		end

	replace_source(a_source:AUDIO_SOURCE)
			-- Places `a_source' in `sources_queue'
		do
			audio_sources_mutex.lock
				sources_queue.put (a_source)
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
