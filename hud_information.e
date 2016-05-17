note
	description: "Class that represents a HUD that holds informations."
	author: "Émilio Gonzalez"
	date: "2016-05-17"
	revision: "16w15a"
	legal: "See notice at end of class."

deferred class
	HUD_INFORMATION

inherit
	HUD_ITEM
	DRAWABLE

feature -- Access

	value: ANY
			-- The value in the HUD. value.Out might be used to draw it

	update_value(a_new_value: ANY)
			-- Updates `value' with `a_new_value'
		deferred
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
