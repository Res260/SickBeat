note
	description: "Abstract object that can interact with the world."
	author: "Guillaume Jean"
	date: "5 March 2016"
	revision: "16w10a"
	legal: "See notice at end of class."

deferred class
	PHYSIC_OBJECT

feature {NONE} -- Initialization

	make_physic_object
		do
			create collision_actions
		end

feature -- Access

	collision_actions: ACTION_SEQUENCE[TUPLE[PHYSIC_OBJECT]]
			-- Actions executed when `Current' collides with another {PHYSIC_OBJECT}

	as_box: BOUNDING_BOX
			-- Return the minimal bounding box of `Current'
		deferred
		end

	collides_with_other(a_other: PHYSIC_OBJECT): BOOLEAN
			-- Whether or not `Current' collides with `a_other's minimal bounding box
		do
			Result := as_box.collides_with_box(a_other.as_box)
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
