note
	description: "Class containing some useful objects."
	author: "Guillaume Jean"
	date: "12 April 2016"
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
			debugging := False
			create camera.make(0, 0)
		end

feature -- Access

	window: GAME_WINDOW_RENDERED
			-- The application's window

	renderer: GAME_RENDERER
			-- The application's window renderer

	ressource_factory: RESSOURCE_FACTORY
			-- The application's ressource factory

	debugging: BOOLEAN assign set_debugging
			-- Show debugging infos

	camera: CAMERA
			-- Camera of the world

	set_debugging(a_other: BOOLEAN)
			-- Change debugging value
		do
			debugging := a_other
		ensure
			Debugging_Updated: debugging = a_other
		end

invariant
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007"
	source: "[file: LICENSE]"
end
