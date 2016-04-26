note
	description: "Class to share IMAGE_GENERATOR singleton."
	author: "Émilio G!"
	date: "16-04-18"
	revision: "1"
	legal: "See notice at end of class."

deferred class
	IMAGE_GENERATOR_SHARED

feature
	image_generator:IMAGE_GENERATOR
		once
			create Result
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
