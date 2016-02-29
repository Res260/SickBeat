note
	description: "Class that manages sounds/musics for the game."
	author: "Émilio G!"
	date: "16-02-22"
	revision: "0.1"

class
	SOUND_ENGINE

inherit
	AUDIO_LIBRARY_SHARED

create
	make

feature {NONE} -- Access

	make
		local
			l_line:STRING
		do
			sound_on := TRUE
			audio_sources := create {ARRAYED_LIST[AUDIO_SOURCE]}.make(0)
			audio_library.enable_sound
			io.put_string ("YEAH2")
			audio_library.launch_in_thread
			run
			from
				l_line:=""
			until
				l_line.is_equal ("quit")
			loop

			end
			audio_library.stop_thread
			audio_library.disable_print_on_error
		end

	sound_on:BOOLEAN
	audio_sources: LIST [AUDIO_SOURCE]

feature

	toggle_sound
			--toggle if sound plays or not
		do
			sound_on := not sound_on
		end

	run
			--do the engine's job
		do
			io.put_string ("YESS FISTON")
		end

	clear_ressources
			--called at the end of the program to clear allocated ressources
		do
			audio_sources.wipe_out
			audio_library.stop_thread
			audio_library.quit_library
		end

	add_audio_source(a_sound: SOUND)
			--adds an audio source to the list of active sounds
		do
			--sounds.append()
		end

end
