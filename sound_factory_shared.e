note
	description: "Summary description for {SOUND_ENGINE_SHARED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SOUND_FACTORY_SHARED

feature
	sound_factory:SOUND_FACTORY
		once
			create Result.make
		end
end
