note
	description: "Draws on the screen all the drawables provided."
	author: "Guillaume Jean"
	date: "30 March 2016"
	revision: "16w09a"
	legal: "See notice at end of class."

class
	RENDER_ENGINE

create
	make

feature -- Initialization

	make(a_background: BACKGROUND; a_context: CONTEXT)
			-- Initialize `Current' with `a_background' to draw behind everything else on `a_context's screen
		do
			context := a_context
			current_background := a_background
		end

feature {NONE} -- Implementation

	context: CONTEXT
			-- Current context of the application

	current_background: BACKGROUND
			-- Background of the application

feature -- Access

	render(a_drawables: LIST[DRAWABLE])
			-- Draws `background' with the `a_drawables' on top of it
		do
			context.renderer.clear

			current_background.draw(context)

			across a_drawables as la_drawables loop
				la_drawables.item.draw(context)
			end

			context.window.update
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
