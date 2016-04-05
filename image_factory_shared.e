note
	description: "Class to share IMAGE_FACTORY singleton."
	author: "Émilio G!"
	date: "16-04-04"
	revision: "16w09a"
	legal: "See notice at end of class."

deferred class
	IMAGE_FACTORY_SHARED

feature
	image_factory:IMAGE_FACTORY
		once
			create Result.make
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
