note
	description: "Class to share SOUND_MANAGER singleton."
	author: "Émilio G!"
	date: "16-3-22"
	revision: "16w08a"

deferred class
	SOUND_MANAGER_SHARED

feature
	sound_manager:SOUND_MANAGER
		once
			create Result.make
		end
end
