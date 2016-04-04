note
	description: "Generates the ennemies and contains a background."
	author: "Guillaume Jean"
	date: "29 March 2016"
	revision: "16w08a"
	legal: "See notice at end of class."

class
	MAP

create
	make

feature {NONE} -- Initialization

	make(a_background: BACKGROUND; a_context: CONTEXT)
			-- Initialize `Current' with a background
		do
			background := a_background
			context := a_context
		end

feature {NONE} -- Implementation

	background: BACKGROUND
			-- Background of `Current'

	context: CONTEXT
			-- Graphical context of the application (renderer, window and ressource_factory)
invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
