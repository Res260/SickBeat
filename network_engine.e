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
			create{LINKED_LIST[STRING]} users.make
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

	users: LIST[STRING]
			-- List of connected users.

	server_matcher: detachable KMP_MATCHER
			-- The regex manager for the server.
	initiate_server
			-- Initiates a server connection using port 42069.
		local
			l_socket:NETWORK_DATAGRAM_SOCKET
		do
			create l_socket.make_bound (42066)
			l_socket.set_non_blocking
			create server_matcher.make_empty
			if(attached server_matcher as la_server_matcher) then
				la_server_matcher.set_pattern ("{(.*)}")
			end
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
		local
			l_communication: STRING
			l_packet:PACKET
		do
			if (attached server_socket as la_server_socket and attached server_matcher as la_server_matcher) then

				from
					continue_listening_server := True
				until
					continue_listening_server = False
				loop
					from
					until
						not la_server_socket.is_readable
					loop
						l_packet := la_server_socket.received(5000, 0)
						if(attached la_server_socket.peer_address as la_peer_address) then
							handle_communication(la_peer_address.host_address.host_address, create{STRING}.make_from_c (l_packet.data.item), la_server_matcher)
						else
							print("peer_address n'existe pas!")
						end
					end
--					if (attached thread_server_listening as la_thread_server_listening) then
--						la_thread_server_listening.sleep (1000000000)
--					end
				end
			else
				print("server_socket or server_matcher not attached. %N");
			end
		end

	handle_communication(a_from, a_communication: STRING; a_server_matcher:KMP_MATCHER)
		local
			l_message: STRING
			l_matcher:KMP_MATCHER
		do
			print("Traitement d'une communication provenant de " + a_from + ": " + a_communication)
			l_message := get_message_from_communication(a_communication, a_server_matcher)
			print("%NMessage: " + l_message)
			if(a_communication.starts_with ("SICK_NEW_PLAYER{} ")) then

			end
		end

	get_message_from_communication(a_communication: STRING; a_matcher: KMP_MATCHER): STRING
		local
			l_found: BOOLEAN
		do
			a_matcher.set_text (a_communication)
			l_found := a_matcher.search_for_pattern
			a_matcher.find_matching_indices
			Result := ""
			if(attached a_matcher.matching_indices as la_matching_indices and attached a_matcher.lengths as la_lengths) then
				if(la_matching_indices.count > 0) then
					Result := a_communication.substring (la_matching_indices[1], la_matching_indices[1] + la_lengths[1] - 1)
				end
			end
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
