note
	description: "Abstract object that can interact with the world."
	author: "Guillaume Jean"
	date: "10 May 2016"
	revision: "16w14a"
	legal: "See notice at end of class."

deferred class
	PHYSIC_OBJECT

feature {NONE} -- Initialization

	make_physic_object
			-- Initializes `Current's internal attributes
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

	collides_precisely_with_other(a_other: PHYSIC_OBJECT): BOOLEAN
			-- Whether or not `Current' collides with `a_other'
		do
			if attached {BOUNDING_BOX} a_other as la_box then
				Result := collides_with_box(la_box)
			elseif attached {BOUNDING_ARC} a_other as la_arc then
				Result := collides_with_arc(la_arc)
			elseif attached {BOUNDING_SPHERE} a_other as la_sphere then
				Result := collides_with_sphere(la_sphere)
			elseif attached {BOUNDING_PLANE} a_other as la_plane then
				Result := collides_with_plane(la_plane)
			end
		end

	collides_with_box(a_box: BOUNDING_BOX): BOOLEAN
			-- Whether or not `Current' collides with `a_box'
		deferred
		end

	collides_with_arc(a_arc: BOUNDING_ARC): BOOLEAN
			-- Whether or not `Current' collides with `a_arc'
		deferred
		end

	collides_with_sphere(a_sphere: BOUNDING_SPHERE): BOOLEAN
			-- Whether or not `Current' collides with `a_sphere'
		deferred
		end

	collides_with_plane(a_plane: BOUNDING_PLANE): BOOLEAN
			-- Whether or not `Current' collides with `a_plane'
		deferred
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
