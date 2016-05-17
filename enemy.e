note
	description: "Summary description for {ENEMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	legal: "See notice at end of class."

class
	ENEMY

inherit
	ENTITY
		rename
			width as drawable_width,
			height as drawable_height
		end
	BOUNDING_BOX

create
	make

feature {NONE} -- Initialization

	make(a_position: TUPLE[x, y: REAL_64])
			-- Initializes `Current' at `a_position'
		do
			make_box(a_position.x - width / 2, a_position.y - height / 2, a_position.x + width / 2, a_position.y + height / 2)
			make_entity(a_position.x, a_position.y)
		end

feature {NONE} -- Implementation

	width: REAL_64 = 40.0
			-- Width of `Current'

	height: REAL_64 = 40.0
			-- Height of `Current'

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
