note
	description: "Handles physics."
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
		local
			l_physic_objects1, l_physic_objects2: LIST[PHYSIC_OBJECT]
		do
			physic_objects.start
			l_physic_objects1 := physic_objects.duplicate(physic_objects.count)
			from
				l_physic_objects1.start
			until
				l_physic_objects1.exhausted
			loop
				from
					l_physic_objects1.forth
					l_physic_objects2 := l_physic_objects1.duplicate(l_physic_objects1.count)
					l_physic_objects2.start
					l_physic_objects1.back
				until
					l_physic_objects2.exhausted
				loop
					if l_physic_objects1.item.collides_with_other(l_physic_objects2.item) then
						if l_physic_objects1.item.collides_precisely_with_other(l_physic_objects2.item) then
							l_physic_objects1.item.collision_actions.call(l_physic_objects2.item)
						end
					end
					l_physic_objects2.forth
				end
				l_physic_objects1.forth
			end
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
