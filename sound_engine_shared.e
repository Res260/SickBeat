note
	description: "Class to share SOUND_ENGINE singleton."
	author: "Émilio G!"
	date: "16-2-22"
	revision: "0 16-02-22"

deferred class
	SOUND_ENGINE_SHARED

feature
	sound_engine:SOUND_ENGINE
		once
			create Result.make
		end
end
