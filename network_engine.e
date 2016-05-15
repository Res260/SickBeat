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
			create {LINKED_LIST[FLEXIBLE_THREAD]} threads_server_receive_updates.make
			continue_listening_server := False
		end

feature {NONE} -- Implementation

	server_socket: detachable NETWORK_STREAM_SOCKET
			-- The server's socket (if any).

	thread_server_listening_connexions: detachable FLEXIBLE_THREAD
			-- The thread that listen to incoming connexions.

	threads_server_receive_updates: LIST[FLEXIBLE_THREAD]
			-- The thread that receive updates from the players.

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
			l_socket:NETWORK_STREAM_SOCKET
		do
			game_network := a_game_network
			create l_socket.make_server_by_port (server_port)
			l_socket.set_non_blocking
			create server_matcher.make
			if(attached server_matcher as la_server_matcher) then
				la_server_matcher.compile("{(.*)}")
			end
			if(l_socket.is_bound) then
				has_error := False
				server_socket := l_socket
				create thread_server_listening_connexions.make (agent listen_new_connexions)
				if(attached thread_server_listening_connexions as la_thread_server_listening) then
					la_thread_server_listening.launch
				end
			else
				has_error := True
				-- Todo deal with this
			end
		end

	listen_new_connexions
		local
			l_address: NETWORK_SOCKET_ADDRESS
		do
			if attached server_socket as la_server_socket and attached game_network as la_game_network then
				from
					continue_listening_server := True
				until
					continue_listening_server = False
				loop
					la_server_socket.listen (1)
					la_server_socket.accept
					if attached la_server_socket.accepted as la_client_socket then
						if attached la_client_socket.address as la_address then
							start_server_receive_updates(la_client_socket)
							la_game_network.add_player (la_address.host_address.host_address)
						else
							print("%Nla_client_socket.address not attached%N")
						end
					end
				end
			end
		end

	server_listen_updates(a_socket: NETWORK_STREAM_SOCKET)
		do
			from
			until
				false
			loop
--				print("server_listen_updates")
--				if attached {PLAYER} a_socket.retrieved as la_player then
--					io.put_string("Player recu:%N" + la_player.height.to_hex_string + "%N")
--				end
			end
			print("Kappa2")
		end

	start_server_receive_updates(a_socket: NETWORK_STREAM_SOCKET)
		do
			threads_server_receive_updates.extend (create {FLEXIBLE_THREAD}.make (agent server_listen_updates(a_socket)))
			threads_server_receive_updates[threads_server_receive_updates.count].launch
			print("saluuuut")
		end

	run_as_server
			-- Listen to incoming communications
		local
			l_packet:detachable PACKET
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
						l_packet := la_server_socket.receive (6000, 0)
						if(attached la_server_socket.peer_address as la_peer_address) then
--							handle_communication_server(la_peer_address.host_address.host_address, create{STRING}.make_from_c (l_packet.data.item), la_server_matcher, la_game_network)
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

	client_socket: detachable NETWORK_STREAM_SOCKET
			-- The client's socket.

	client_thread:detachable FLEXIBLE_THREAD
			-- The client's thread to process network packets.

	connect_client(a_host: STRING)
			--Starts the network job for the client.
		local
			l_addr_factory:INET_ADDRESS_FACTORY
			l_socket: NETWORK_STREAM_SOCKET
			l_address:detachable INET_ADDRESS
		do
			create l_addr_factory
			l_address:= l_addr_factory.create_from_name (a_host)
			if l_address = Void then
				io.put_string ("Error: Address " + a_host + " invalid%N")
			else
				create l_socket.make_client_by_address_and_port (l_address, server_port)
				if l_socket.invalid_address then
					io.put_string ("Can't connect to " + a_host + ":" + server_port.to_hex_string +".%N")
				else
					l_socket.connect
					if not l_socket.is_connected then
						io.put_string ("Can't connect to " + a_host + ":" + server_port.to_hex_string +".%N")
					else
						client_socket := l_socket
						print("%NCONNECTED!!%N")
					end
				end
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

--					send_player_things

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
