note
	description: "Draws on the screen all the drawables provided."
	author: "Guillaume Jean"
	date: "30 March 2016"
	revision: "16w09a"

class
	RENDER_ENGINE

create
	make

feature -- Initialization

	make(a_map: MAP; a_context: CONTEXT)
			-- Initialize `Current' with the map
		do
			context := a_context
			current_map := a_map
		end

feature {NONE} -- Implementation

	context: CONTEXT
			-- Current context of the application

	current_map: MAP
			-- Map used to draw the background

feature -- Access

	render(a_background: BACKGROUND; a_drawables: LIST[DRAWABLE])
			-- Draws the background with the drawables on top of it
		do
			context.renderer.clear

			a_background.draw

			across a_drawables as la_drawables loop
				la_drawables.item.draw
			end

			context.window.update
		end

end
