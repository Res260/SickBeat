note
	description: "{ENGINE} is a basic controller and graphical interface."
	author: "Guillaume Jean"
	date: "Tue, 23 Fev 2016 09:20"
	revision: "16w06a"

deferred class
	ENGINE

inherit
	GAME_LIBRARY_SHARED

feature {NONE} -- Initialization

	make(a_window: GAME_WINDOW_RENDERED; a_ressource_factory: RESSOURCE_FACTORY)
		require
			Ressource_Factory_Has_No_Error: not a_ressource_factory.has_error
		do
			window := a_window
			ressource_factory := a_ressource_factory
			stop_requested := False
		ensure
			window = a_window
			ressource_factory = a_ressource_factory
		end

feature -- Access

	stop_requested: BOOLEAN
			-- Whether or not `Current' has been requested to stop

	request_stop
			-- Request `Current' to stop
		do
			stop_requested := True
		end

	run
			-- Execute a 'tick' of `Current'
		require
			Events_Enabled: game_library.is_events_enable
		do
			game_library.quit_signal_actions.extend(agent on_quit_signal)
			window.expose_actions.extend(agent on_redraw)
			window.size_change_actions.extend(agent on_size_change)
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

	ressource_factory: RESSOURCE_FACTORY
			-- Factory used to create ressources

	on_quit_signal(a_timestamp: NATURAL_32)
			-- Method run when the X button is clicked
		do
			request_stop
			stop
		end

	on_redraw(a_timestamp: NATURAL_32)
			-- Method run when the `window' is redrawn
		deferred
		end

	on_size_change(a_timestamp: NATURAL_32)
			-- Method run when the `window's size changes
		do
		end
end
