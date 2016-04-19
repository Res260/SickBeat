note
	description: "Class to share SOUND_MANAGER singleton."
	author: "Émilio G!"
	date: "16-3-22"
	revision: "16w08a"
	legal: "See notice at end of class."

deferred class
	SOUND_MANAGER_SHARED

feature
	sound_manager:SOUND_MANAGER
		once
			create Result.make
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
