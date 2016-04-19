note
	description: "Summary description for {PHYSICS_ENGINE}."
	author: "Guillaume Jean"
	date: "18 April 2016"
	revision: "16w11a"
	legal: "See notice at end of class."

class
	PHYSICS_ENGINE

create
	make

feature {NONE} -- Initialization

	make
			-- Initializes `Current'
		do
			create {LINKED_LIST[PHYSIC_OBJECT]} physic_objects.make
		end

feature -- Access

	physic_objects: LIST[PHYSIC_OBJECT]
			-- List of collidable objects

	check_all
			-- Checks all collisions of `physic_objects'
		do

		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
