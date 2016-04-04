note
	description: "Summary description for {PHYSICS_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	legal: "See notice at end of class."

class
	PHYSICS_ENGINE

feature {NONE} -- Access

	physic_objects: LIST [PHYSIC_OBJECT]
			-- `physic_objects'
		attribute check False then end end --| Remove line when `physic_objects' is initialized in creation procedure.

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
