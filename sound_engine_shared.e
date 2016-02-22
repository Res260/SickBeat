note
	description: "Summary description for {SOUND_ENGINE_SHARED}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SOUND_ENGINE_SHARED

feature
	Sound_engine:SOUND_ENGINE
		once
			create Result.make
		end
end
