note
	description: "Class to share SOUND_FACTORY singleton."
	author: "�milio G!"
	date: "16-2-22"
	revision: "16w05a"
	legal: "See notice at end of class."

deferred class
	SOUND_FACTORY_SHARED

feature
	sound_factory:SOUND_FACTORY
		once("PROCESS")
			create Result.make
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
