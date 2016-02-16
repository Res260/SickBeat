note
	description: "Summary description for {SOUND_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOUND_ENGINE

feature {NONE} -- Access

	sounds: LIST [SOUND]
			-- `sounds'
		attribute check False then end end --| Remove line when `sounds' is initialized in creation procedure.

end
