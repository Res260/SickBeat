note
	description: "Class that manages sounds/musics for the game."
	author: "Émilio G!"
	date: "160222"
	revision: "0.1"

class
	SOUND_ENGINE

create
	make

feature {NONE} -- Access

	make
		do
			sound_on := TRUE
			sounds := create {ARRAYED_LIST[SOUND]}.make(0)
		end

	sound_on:BOOLEAN
	sounds: LIST [SOUND]

feature

	toggle_sound
			--toggle if sound plays or not
		do
			sound_on := not sound_on
		end

	run
			--do the engine's job
		do

		end

	clear_ressources
			--called at the end of the program to clear allocated ressources
		do
			sounds.wipe_out
		end

	add_sound(a_sound: SOUND)
			--adds a sound to the list of active sounds
		do
			sounds.append (a_sound)
		end

end
