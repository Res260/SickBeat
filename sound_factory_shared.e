note
	description: "Class to share SOUND_ENGINE singleton."
	author: "Émilio G!"
	date: "16-2-22"
	revision: "0 16-02-22"
	legal: "See notice at end of class."

deferred class
	SOUND_FACTORY_SHARED

feature
	sound_factory:SOUND_FACTORY
		once
			create Result.make
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
