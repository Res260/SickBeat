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
			self_score := "-1"
			friend_score := "-2"
		end

feature {NONE} -- Implementation

	server_socket: detachable NETWORK_STREAM_SOCKET
			-- The server's socket (if any).

	thread_connexion: detachable FLEXIBLE_THREAD

feature -- Access

	server_port: INTEGER = 42066
			-- The server's port.

	has_error:BOOLEAN
			-- True if an error occured in `Current'.

	continue_listening_server: BOOLEAN
			-- The token to continue listening for communications.

	continue_network: BOOLEAN
			-- The token to continue to run as a client.

	self_score: STRING

	set_self_score(a_score:STRING)
		do
			self_score := a_score
		end

	friend_score: STRING

	initiate_server
			-- Initiates a server connection using `server_port'.
		local
			l_socket:NETWORK_STREAM_SOCKET
		do
			create l_socket.make_server_by_port (server_port)
			if(l_socket.is_bound) then
				server_socket := l_socket
				create thread_connexion.make (agent listen_server)
				if(attached thread_connexion as la_thread_connexion) then
					la_thread_connexion.launch
				end
			else
				print("%NCant bind to" + server_port.to_hex_string + "%N")
			end
		end

	listen_new_connexions
		do
			if attached server_socket as la_server_socket then
				la_server_socket.listen (1)
				la_server_socket.accept
				if attached la_server_socket.accepted as la_client_socket then
					if attached la_client_socket.peer_address as la_address then
						start_server_receive_updates(la_client_socket)
					else
						print("%Nla_client_socket.address not attached%N")
					end
				end
			end
		end

	listen_server
		do
			if attached server_socket as la_server_socket then
				la_server_socket.listen (1)
				la_server_socket.accept
				if attached la_server_socket.accepted as la_client_socket then
					client_socket := la_client_socket
					run
				end
			end
		end

	run
		do
			if attached client_socket as la_client_socket then
				if attached la_client_socket.address as la_address then
					from
						continue_network := true
					until
						continue_network = false
					loop
						la_client_socket.put_string (self_score)
						la_client_socket.read_line
						friend_score := la_client_socket.last_string
					end
				end
			end
		end

	start_server_receive_updates(a_socket: NETWORK_STREAM_SOCKET)
		do
			client_socket := a_socket
			print("saluuuut")
		end

	client_socket: detachable NETWORK_STREAM_SOCKET
			-- The client's socket.

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

	update_score(a_ip, a_score: STRING)
		do
--			print(a_ip + ": " + a_score)
			print("%NSALUT")
		end

note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) 2016 Émilio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end
