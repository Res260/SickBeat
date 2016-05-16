note
	description: "Threaded class to receive updates from a client"
	author: "�milio G!"
	date: "2016-05-15"
	revision: "16w15a"
	legal: "See notice at end of class."

class
	SERVER_RECEIVE_UPDATES_THREAD

inherit
	THREAD
		rename
			make as make_thread
		redefine
			execute
		end

create
	make

feature {NONE} -- Initialization

	make(a_socket:NETWORK_STREAM_SOCKET)
			-- Initializes `Current'
		do
			socket := a_socket
			make_thread
		end

feature -- Implementation

	socket: NETWORK_STREAM_SOCKET

	execute
			-- Executed when the thread is launched
		local

		do
			from
			until
				false
			loop
				print("server_listen_updates")
				receive_player
			end
		end

	receive_player
			-- Re�oit un {LIVRE} du `a_socket' et affiche ces informations
		local
			l_retry:BOOLEAN		-- Par d�faut, l_retry sera � `False'
		do
			if not l_retry then		-- Si la clause 'rescue' n'a pas �t� utilis�, re�oit le livre
				if attached {PLAYER} socket.retrieved as la_player then
					io.put_string("Livre recu:%N%N")
				end
			else	-- Si la clause 'rescue' a �t� utilis�, affiche un message d'erreur
				io.put_string("Le message recu n'est pas un livre valide.%N")
			end
		rescue	-- Permet d'attraper un exception
			l_retry := True
			retry
		end
note
	license: "GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007 | Copyright (c) �milio Gonzalez and Guillaume Jean"
	source: "[file: LICENSE]"
end

