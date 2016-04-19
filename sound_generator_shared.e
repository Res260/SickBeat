note
	description: "Class to share SOUND_GENERATOR singleton."
	author: "�milio G!"
	date: "16-03-22"
	revision: "1"
	legal: "See notice at end of class."

deferred class
	SOUND_GENERATOR_SHARED

feature
	sound_generator:SOUND_GENERATOR
		once
			create Result.make
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
