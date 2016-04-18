note
	description: "Class containing some useful objects."
	author: "Guillaume Jean and �milio G!"
	date: "Tue, 15 March 2016 21:05"
	revision: "16w10a"
	legal: "See notice at end of class."

class
	CONTEXT

create
	make

feature {NONE} -- Initialization

	make(a_window: GAME_WINDOW_RENDERED; a_ressource_factory: RESSOURCE_FACTORY)
		do
			window := a_window
			renderer := a_window.renderer
			ressource_factory := a_ressource_factory
			create image_factory.make(renderer)
		end

feature -- Access

	window: GAME_WINDOW_RENDERED
			-- The application's window

	renderer: GAME_RENDERER
			-- The application's window renderer

	ressource_factory: RESSOURCE_FACTORY
			-- The application's ressource factory

	image_factory:IMAGE_FACTORY
			--The applications' image factory
invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
