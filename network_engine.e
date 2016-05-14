note
	description: "Summary description for {NETWORK_ENGINE}."
	author: "Émilio Gonzalez"
	date: "16-05-03"
	revision: "16w13a"
	legal: "See notice at end of class."

class
	NETWORK_ENGINE

inherit
	GAME_LIBRARY_SHARED

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

	client_port: INTEGER = 42065
			-- The client's port.

	server_port: INTEGER = 42066
			-- The server's port.

	has_error:BOOLEAN
			-- True if an error occured in `Current'.

	continue_listening_server: BOOLEAN
			-- The token to continue listening for communications.

	continue_client_loop: BOOLEAN
			-- The token to continue to run as a client.

	server_matcher: detachable RX_PCRE_REGULAR_EXPRESSION
			-- The regex matcher for the server.

	game_network: detachable GAME_NETWORK
			-- The server's game manager.

	initiate_server(a_game_network: GAME_NETWORK)
			-- Initiates a server connection using `server_port'.
		local
			l_socket:NETWORK_DATAGRAM_SOCKET
		do
			game_network := a_game_network
			create l_socket.make_bound (server_port)
			l_socket.set_non_blocking
			create server_matcher.make
			if(attached server_matcher as la_server_matcher) then
				la_server_matcher.compile("{(.*)}")
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
			l_packet:PACKET
		do
			if (attached server_socket as la_server_socket and attached server_matcher as la_server_matcher
				and attached game_network as la_game_network) then

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
							handle_communication_server(la_peer_address.host_address.host_address, create{STRING}.make_from_c (l_packet.data.item), la_server_matcher, la_game_network)
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

	handle_communication_server(a_from, a_communication: STRING; a_server_matcher:RX_PCRE_REGULAR_EXPRESSION; a_game_network: GAME_NETWORK)
			-- Calls a feature based on what the server received (`a_communication').
		local
			l_message: STRING
		do
			print("Traitement d'une communication provenant de " + a_from + ": " + a_communication)
			l_message := get_message_from_communication(a_communication, a_server_matcher)
			if(a_communication.starts_with ("SICK_NEW_PLAYER{}")) then
				a_game_network.add_player (a_from)
			elseif(a_communication.starts_with ("SICK_PLAYER_POSITION{ ")) then

			end
		end

	get_message_from_communication(a_communication: STRING; a_matcher: RX_PCRE_REGULAR_EXPRESSION): STRING
			-- Using `a_matcher', get the message from `a_communication'.
		do
			a_matcher.match(a_communication)
			Result := ""
			if a_matcher.has_matched and a_matcher.match_count > 0 then
				Result := a_matcher.captured_substring (1)
			end
		end

	game_engine: detachable GAME_ENGINE
			-- The client's game engine.

	client_socket: detachable NETWORK_DATAGRAM_SOCKET
			-- The client's socket.

	client_thread:detachable FLEXIBLE_THREAD
			-- The client's thread to process network packets.

	initiate_client_thread(a_game_engine: GAME_ENGINE)
			--Starts the network job for the client.
		local
			l_socket: NETWORK_DATAGRAM_SOCKET
		do
			game_engine := a_game_engine
			create l_socket.make_targeted ("127.0.0.1", server_port)
			client_socket := l_socket
			create client_thread.make(agent run_as_client)
			if(attached client_thread as la_client_thread) then
				la_client_thread.launch
			end
		end

	run_as_client
			-- Threaded method to update the game according to the server's informations.
		local
			l_previous_tick: REAL_64
			l_update_time_difference: REAL_64
			l_time_difference: REAL_64
			l_execution_time: REAL_64
		do
			if(attached game_engine as la_game_engine and attached client_socket as la_client_socket) then
				send_sick_new_player
				send_sick_new_player
				send_sick_new_player
				from
					continue_client_loop := True
				until
					continue_client_loop = False
				loop
					l_previous_tick := last_tick
					last_tick := game_library.time_since_create.to_real_64

					send_player_things

					l_execution_time := game_library.time_since_create.to_real_64 - last_tick
					l_time_difference := milliseconds_per_tick - l_execution_time - 0.5
					if l_time_difference > 0 then
						if(attached client_thread as la_client_thread) then
							la_client_thread.sleep((l_time_difference * 1000000).truncated_to_integer_64)
						end
					end
				end
			end
		end

	send_sick_new_player
			-- Sends SICK_NEW_PLAYER{} to the server
		do
			if(attached client_socket as la_client_socket) then
				la_client_socket.put_string ("SICK_NEW_PLAYER{}")
			end
		end

	send_player_thing
		do

		end

	last_tick: REAL_64
			-- Time of last update in milliseconds

	ticks_per_seconds: NATURAL_32 = 120
			-- Ticks executed per second

	milliseconds_per_tick: REAL_64
			-- Fraction of seconds per tick
		once("PROCESS")
			Result := 1000 / ticks_per_seconds
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
