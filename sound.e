note
	description: "Class that holds information."
	author: "Émilio G!"
	date: "160223"
	revision: "$Revision$"

class
	SOUND

inherit
	AUDIO_SOUND
		rename
			make as make_with_file
		end

create
	make

feature {NONE}

	make (a_sound_data : ARRAYED_LIST[INTEGER_16])
		do
			sound_data:= a_sound_data
			make_with_file ()
		end

feature
	sound_data: ARRAYED_LIST[INTEGER_16]

end
