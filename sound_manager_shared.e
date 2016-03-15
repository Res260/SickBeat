note
	description: "Class to share SOUND_ENGINE singleton."
	author: "Émilio G!"
	date: "16-2-22"
	revision: "16w07a"

deferred class
	SOUND_MANAGER_SHARED

feature
	sound_engine:SOUND_MANAGER
		once
			create Result.make
		end
end
