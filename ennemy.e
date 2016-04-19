note
	description: "Summary description for {ENNEMY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	legal: "See notice at end of class."

class
	ENNEMY

inherit
	ENTITY

feature -- Access

	as_box: BOUNDING_BOX
		do
			create Result.make(0, 0, 0, 0)
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
