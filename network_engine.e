note
	description: "Summary description for {NETWORK_ENGINE}."
	author: "Émilio Gonzalez"
	date: "16-05-03"
	revision: "16w13a"
	legal: "See notice at end of class."

class
	NETWORK_ENGINE

create
	make

feature{NONE} -- Initialization

	make
			-- Initialitation for `Current'.
		do
			continue_listening_server := False

		end

feature {NONE} -- Implementation

	server_socket: detachable NETWORK_DATAGRAM_SOCKET
			-- The server's socket (if any).

	thread_server_listening: detachable FLEXIBLE_THREAD
			-- The thread that listen to incoming communications (as a server).

feature -- Access

	has_error:BOOLEAN
			-- True if an error occured in `Current'.

	continue_listening_server: BOOLEAN
			-- The token to continue listening for communications.

	initiate_server
			-- Initiates a server connection using port 42069.
		local
			l_socket:NETWORK_DATAGRAM_SOCKET
		do
			create l_socket.make_bound (42066)
			l_socket.set_non_blocking
			if(l_socket.is_bound) then
				has_error := False
				server_socket := l_socket
				create thread_server_listening.make (agent run_as_server)
				if(attached thread_server_listening as at_thread_server_listening) then
					at_thread_server_listening.launch
				end
			else
				has_error := True
				-- Todo deal with this
			end
		end

	run_as_server
			-- Listen to incoming communications
		do
			if(attached server_socket as la_server_socket) then

				from
					continue_listening_server := True
				until
					continue_listening_server = False
				loop
					la_server_socket.read_stream (5000)
					print(la_server_socket.last_string + "SAME")
					io.put_new_line
				end
			else
				print("server_socket not attached. %N");
			end
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
