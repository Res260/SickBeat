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
			sounds := create {ARRAYED_LIST[SOUND]}.make (0)
		end

	sound_on:BOOLEAN
	sounds: LIST [SOUND]

feature

	toggle_sound
			--toggle if sound plays or not
		do
			sound_on := not sound_on
		end

end
