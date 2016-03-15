note
	description: "Class that manages sounds/musics for the game."
	author: "Émilio G!"
	date: "16-02-22"
	revision: "16w07a"

class
	SOUND_MANAGER

inherit
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE}

	make
		do
			sound_on := TRUE
			audio_library.enable_sound
			audio_library.launch_in_thread
			audio_library.disable_print_on_error
		end

feature -- Access

	sound_on:BOOLEAN

	toggle_sound
			--toggle if sound plays or not
		do
			sound_on := not sound_on
		end

	create_audio_source
		--creates and adds a ?????????
		do
			audio_library.sources_add
		end

	last_audio_source:AUDIO_SOURCE
		--returns the last audio source added by `Current'.create_audio_source
		do
			Result := audio_library.last_source_added
		end

	run
			--do `Current's job
		do

		end

	clear_ressources
			--called at the end of the program to clear allocated ressources
		do
			audio_library.stop_thread
			audio_library.quit_library
		end

end
