note
	description: "Class to share SOUND_GENERATOR singleton."
	author: "Émilio G!"
	date: "16-03-22"
	revision: "1"

deferred class
	SOUND_GENERATOR_SHARED

feature
	sound_generator:SOUND_GENERATOR
		once
			create Result.make
		end
end
