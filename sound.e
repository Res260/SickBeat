note
	description: "Class that holds information."
	author: "�milio G!"
	date: "160223"
	revision: "$Revision$"

class
	SOUND

inherit
	AUDIO_SOUND

create
	make

feature {NONE}

	make (a_sound_data : ARRAYED_LIST[INTEGER_16])
		do
			sound_data:= a_sound_data
		end

feature
	sound_data: ARRAYED_LIST[INTEGER_16]

end
