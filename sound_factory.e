note
	description: "Summary description for {SOUND_FACTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOUND_FACTORY

inherit
	SOUND

feature -- Access

	 --| Remove line when `new_1' is initialized in creation procedure.

	new: SOUND
			-- `new'
		attribute check False then end end --| Remove line when `new' is initialized in creation procedure.

end
