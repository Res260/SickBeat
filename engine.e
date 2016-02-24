note
	description: "{ENGINE} is a basic controller and graphical interface."
	author: "Guillaume Jean"
	date: "Tue, 23 Fev 2016 09:20:00"
	revision: "0.1"

deferred class
	ENGINE

inherit
	GAME_LIBRARY_SHARED

feature {NONE} -- Initialization

	make(a_window: GAME_WINDOW_RENDERED)
		do
			window := a_window
		ensure
			window = a_window
		end

feature -- Access
	run
			-- Execute a 'tick' of `Current'
		do
			game_library.quit_signal_actions.extend(agent on_quit_signal)
			window.expose_actions.extend(agent on_redraw)
			on_redraw(game_library.time_since_create)
			game_library.launch
			game_library.clear_all_events
		end

	stop
			-- Stop the execution of `Current'
		do
			game_library.stop
		end

feature {NONE} -- Implementation

	window: GAME_WINDOW_RENDERED
			-- The window of the running application

	on_quit_signal(a_timestamp: NATURAL_32)
			-- Method run when the X button is clicked
		do
			stop
		end

	on_redraw(a_timestamp: NATURAL_32)
			-- Method run when the screen is redrawn
		deferred
		end

end
