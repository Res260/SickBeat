note
	description: "Generates the ennemies and contains a background."
	author: "Guillaume Jean"
	date: "29 March 2016"
	revision: "16w08a"

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

	context: CONTEXT
			-- Graphical context of the application (renderer, window and ressource_factory)

feature -- Access

	background: BACKGROUND
			-- Background of `Current'

end
