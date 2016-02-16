note
	description: "Summary description for {PHYSICS_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PHYSICS_ENGINE

feature {NONE} -- Access

	physic_objects: LIST [PHYSIC_OBJECT]
			-- `physic_objects'
		attribute check False then end end --| Remove line when `physic_objects' is initialized in creation procedure.

end
