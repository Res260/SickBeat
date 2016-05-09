note
	description: "Class to make a thread based on a feature"
	author: "Émilio G!"
	date: "2016-05-03"
	revision: "16w13a"

class
	FLEXIBLE_THREAD

inherit
	THREAD
		rename
			make as make_thread
		redefine
			execute
		end

create
	make

feature {NONE}

	make(a_procedure: PROCEDURE[ANY, TUPLE])
			-- Initialization for `Current'
		do
			procedure := a_procedure
			make_thread
		end

	procedure: PROCEDURE[ANY, TUPLE]
			-- Procedure to call in the Thread

	execute
			-- Executed when the thread is launched
		do
			procedure.call
		end
end
